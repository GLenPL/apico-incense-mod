--------------------------
--- IDs name constants ---
--------------------------

ID_incense_powder = "incense_powder"
ID_incense_burner = "burner"

LOG_DEF = "Definers"

----------------------
--- Defining items ---
----------------------

function define_incense_powder()
  incense_powder_def = {
    id = ID_incense_powder,
    name = "Incense powder",
    category = "Ressource",
    tooltip = "Some incense powder. It has a nice smell. Why don't you smell it ? Haha, you have some on your nose, now!",
    shop_sell = 2.5,
    shop_buy = 5,
    machines = {"incense_burner"},
    bee_lore = "The pollen of some specific flowers that only this species of bees pollinates.",
  }
  sprite_path = "sprites/incense_powder/apico_mod_encens.png"
  
  api_define_item(incense_powder_def, sprite_path)
end

--------------------------------
--- Defining the praying bee ---
--------------------------------

function define_praying_bee()

  -- setup the bee def
  praying_bee_def = {
    id = "praying",
    title = "Praying",
    latin = "Apis Comprecatus",
    hint = "Said to be found only on revered grounds, this mutation of Apis Somnus and Apis Reverentia would be a blessing on this world",
    desc = "This is just a cool damn bee",
    lifespan = {"Long", "Ancient"},
    productivity = {"Slowest", "Slow"},
    fertility = {"Infertile", "Unlucky"},
    stability = {"Normal", "Stable"},
    behaviour = {"Cathemeral"},
    climate = {"Temperate"},
    rainlover = true,
    snowlover = true,
    grumpy = false,
    produce = MOD_ID_PREPEND .. ID_incense_powder,
    chance = 36,
    bid = "IP",
    requirement = "Is it shown in the predictor ?",
    tier = 4
  }

  -- create new bee
  -- in this example we have a "sprites" folder in our mod root
  api_define_bee(praying_bee_def, 
    "sprites/bee/bee_item.png",
    "sprites/bee/bee_shiny.png", 
    "sprites/bee/bee_hd.png",
    {r=86, g=82, b=100},
    "sprites/bee/bee_mag.png",
    "The praying is restored, thanks to one beekeeper!",
    "'Bzzz bzzz bzzz' buzzed interviewed Praying bee!"
  );

  api_define_bee_recipe("hallowed", "dream", "praying", "mutation_to_praying")
end


-----------------------------------
--- Defining the incense burner ---
-----------------------------------

-- menu objects are items you can place down and then click on to open an actual menu
function define_incense_burner()
  -- define new menu object as normal
  burner_def = {
    id = ID_incense_burner,
    name = "Incense Burner",
    category = "Beekeeping",
    tooltip = "Blesses bees",
    layout = {
      {7, 17, "Input", {"bee"}},
      {7, 39, "Input", {"bee"}},
      {30, 17, "Input", {"bee"}},
      {30, 39, "Input", {"bee"}},
      {65, 39, "Input", {MOD_ID_PREPEND .. ID_incense_powder}},
      {100, 17, "Output"},
      {100, 39, "Output"},
      {123, 17, "Output"},
      {123, 39, "Output"},
      {7, 66},
      {30, 66},
      {53, 66},
      {77, 66},
      {100, 66},
      {123, 66},
    },
    buttons = {"Help", "Target", "Move", "Close"},
    info = {
      {"1. Bee Input", "GREEN"},
      {"2. Incense Input", "BLUE"},
      {"3. Blessed Bee Output", "RED"},
      {"4. Extra Storage", "WHITE"},
    },
    tools = {"mouse1", "hammer1"},
    placeable = true,
  }
  
  burner_item_sprite_path = "sprites/burner/item.png"
  burner_menu_sprite_path = "sprites/burner/menu.png"
  
  api_define_menu_object(
    burner_def,
    burner_item_sprite_path,
    burner_menu_sprite_path,
    {
      define = "burner_define", -- defined in "scripts.lua" as a function
      draw = "burner_draw", -- defined in "scripts.lua" as a function
      tick = "burner_tick", -- defined in "scripts.lua" as a function
      change = "burner_change" -- defined in "scripts.lua" as a function
    }
  )
  
  burner_recipe = {
    {item = "planks2", amount = 10},
    {item = MOD_ID_PREPEND .. ID_incense_powder, amount = 5},
    {item = "honeycomb", amount = 5}
  }
  
  api_define_recipe("beekeeping", MOD_ID_PREPEND .. ID_incense_burner, burner_recipe, 1)

end
