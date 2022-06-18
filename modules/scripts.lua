-- all functions in this module will be available to use as long as we specify it in our register() hook

-------------------
--- BEE SCRIPTS ---
-------------------

-- define the mutation critera/chance for our new bee
function mutation_to_praying(bee_a, bee_b, beehive)
  if (bee_a == "hallowed" and bee_b == "dream") or (bee_a == "dream" and bee_b == "hallowed") then
    --biome = 
    chance = api_random(99) + 1
    if true and chance <= 36 then
      return true
    end
  end
  return false;
end

------------------------------
--- Incense burner SCRIPTS ---
------------------------------

-- the define script is called when a menu object instance is created
-- this means we can define properties on the menu object for the first time
function burner_define(menu_id)

  -- create initial props
  api_dp(menu_id, "working", false)
  api_dp(menu_id, "percentage_current", 0)

  -- create gui for the menu
  api_define_gui(menu_id, "progress_bar", 49, 20, "burner_gui_tooltip", "sprites/burner/burner_gui.png")
  
  -- save gui sprite ref for later
  spr = api_get_sprite("sp_" .. MOD_ID_PREPEND .. "progress_bar")
  api_dp(menu_id, "progress_bar_sprite", spr)

  -- add our percentage_current prop to the default _fields list so the progress is saved 
  -- any keys in _fields will get their value saved when the game saves, and loaded when the game loads again
  fields = {"percentage_current"}
  fields = api_sp(menu_id, "_fields", fields)
end

-- the change script lets us listen for a change in the menu's slots
-- it's called when a slot changes in the menu
function burner_change(menu_id)
  -- if we have items in the first four slots let's get to work
  input_slot = api_slot_match_range(menu_id, {"ANY"}, {1, 2, 3, 4}, true) --as I can't ask for bees only ...
  fuel_spot = api_slot_match_range(menu_id, {MOD_ID_PREPEND .. ID_incense_powder}, {5}, true)
  output_slot = api_slot_match_range(menu_id, {""}, {6, 7, 8, 9}, true)
  
  working_value = input_slot ~= nil and fuel_spot ~= nil and output_slot ~= nil
  --change the working value
  api_sp(menu_id, "working", working_value)
  --reset counter if stops working
  if not working_value then api_sp(menu_id, "percentage_current", 0) end
end

-- the tick script lets us run logic we need for the menu object 
-- it's called every 0.1s (real-time)
function burner_tick(menu_id)

  -- handle countdown if working
  if api_gp(menu_id, "working") == true then
    -- add to counter
    api_sp(menu_id, "percentage_current", api_gp(menu_id, "percentage_current") + 1)
    
    -- if we hit the end, i.e. 10s have passed
    if api_gp(menu_id, "percentage_current") >= 100 then

      -- reset the counter
      api_sp(menu_id, "percentage_current", 0)
      
      -- get the "input" slots to get an item
      input_slot = api_slot_match_range(menu_id, {"ANY"}, {1, 2, 3, 4}, true)
      fuel_slot = api_slot_match_range(menu_id, {MOD_ID_PREPEND .. ID_incense_powder}, {5}, true)
      -- assuming there is a slot with stuff

        --first, remember the bee
        bee_to_bless = input_slot["item"]
        bee_to_bless_stats = input_slot["stats"]
        --then, delete it
        api_slot_decr(input_slot["id"])
        --consume fuel
        api_slot_decr(fuel_slot["id"])
        --bless the bee
        bee_to_bless_stats["shiny"] = true
        
        --find the free output slot
        output_slot = api_slot_match_range(menu_id, {""}, {6, 7, 8, 9}, true)
        --add it the bee
        api_slot_set(output_slot["id"], bee_to_bless, 1, bee_to_bless_stats)
        
        -- recheck input, if nothing then stop working
        burner_change(menu_id)
    end
  end
end

-- the draw script lets us draw custom things on the menu when it's open
-- here we can draw GUI elements or buttons or other things
-- you should avoid putting complex logic in the draw script
function burner_draw(menu_id)
  -- get camera
  cam = api_get_cam()

  -- draw gui progress here
  gui = api_get_inst(api_gp(menu_id, "progress_bar"))
  spr = api_gp(menu_id, "progress_bar_sprite")

  -- draw arrow "progress" block then cover up with arrow hole
  -- arrow sprite is 47x10
  gx = gui["x"] - cam["x"]
  gy = gui["y"] - cam["y"]
  progress = (api_gp(menu_id, "percentage_current") / 100 * 47)
  api_draw_sprite_part(spr, 2, 0, 0, progress, 10, gx, gy)
  api_draw_sprite(spr, 1, gx, gy)

  -- draw highlight if highlighted
  if api_get_highlighted("ui") == gui["id"] then
    api_draw_sprite(spr, 0, gx, gy)
  end

end

-- return text for gui tooltip
-- this method is called by the GUI instance when we hover over it
-- the text returned is shown in a tooltip
function burner_gui_tooltip(menu_id) 
  progress = math.floor((api_gp(menu_id, "percentage_current") / 100) * 100)
  percent = tostring(progress) .. "%"
  return {
    {"Progress", "FONT_WHITE"},
    {percent, "FONT_BGREY"}
  }
end
