-- This is the Sample Mod!

-- I would recommend keeping your mod_id in a variable to access with create() methods and stuff
-- there's a bunch of methods that prepend your mod_id to the name/oids so it comes in handy!
MOD_NAME = "incense_mod"
MOD_ID_PREPEND = MOD_NAME .. "_"

-- register is called first to register your mod with the game
-- https://wiki.apico.buzz/wiki/Modding_API#register()
function register()
  -- register our mod name, hooks, and local modules
  return {
    name = MOD_NAME,
    hooks = {"ready"}, -- subscribe to hooks we want so they're called
    modules = {"define", "scripts"} -- load other modules we need, in this case "/modules/define.lua" and "/modules/scripts.lua"
  }
end

-- init is called once registered and gives you a chance to run any setup code
-- https://wiki.apico.buzz/wiki/Modding_API#init()
function init() 

  -- turn on devmode
  api_set_devmode(true)

  -- log to the console
  api_log(LOG_DEF, "Starting definitions")

  -- define new items
  define_incense_powder()
  --define_incense_stick()
  
  -- define a new type of bee
  define_praying_bee()
  
  -- define a new menu object, in this case an "incense burner" that turns normal bees into blessed ones 
  define_incense_burner()

  -- if you dont return success here your mod will not load
  -- this can be useful if your define fails as you can decide to NOT return "Success" to tell APICO 
  -- that something went wrong and to ignore your mod
  return "Success"
end


-- ready is called once all mods are ready and once the world has loaded any undefined instances from mods in the save
function ready()

end
