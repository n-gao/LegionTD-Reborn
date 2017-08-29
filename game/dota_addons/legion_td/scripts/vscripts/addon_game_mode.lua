-- Required files to be visible from anywhere
require('precache')
require('game_settings')
require('timers')
require('barebones')
require("statcollection/init")
require('game')
require('game_round')
require('duel_round')
require('wave_spawner')
require('player')
require('unit')
require('popups')
require('notifications')
require('damage')
require('selection')
require('wiki')
require('wave_unit')
require('commands')

function Precache(context)
    -- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
    -- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues
    --[[
    This function is used to precache resources/units/items/abilities that will be needed
    for sure in your game and that cannot or should not be precached asynchronously or
    after the game loads.
    
    See GameMode:PostLoadPrecache() in barebones.lua for more information
    ]]
    print("[BAREBONES] Performing pre-load precache")
    
    for _, r in pairs(RequiredUnits) do
        PrecacheUnitByNameSync(r, context)
    end
end

-- Create the game mode when we activate
function Activate()
    GameRules.GameMode = GameMode()
    GameRules.GameMode:InitGameMode()
    GameRules:SetShowcaseTime(0)
end
