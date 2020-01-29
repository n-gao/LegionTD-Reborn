spiritUnits = {
    "tower_spiritbuilder_earth_spirit",
    "tower_spiritbuilder_ember_spirit",
    "tower_spiritbuilder_lost_spirit",
    "tower_spiritbuilder_storm_spirit",
    "tower_spiritbuilder_vengeful_spirit",
    "tower_spiritbuilder_void_spirit",
    "tower_spiritbuilder_skywrath",
    "tower_spiritbuilder_shendelzare",
    "tower_spiritbuilder_kaolin",
    "tower_spiritbuilder_great_kaolin",
    "tower_spiritbuilder_raijin",
    "tower_spiritbuilder_thunderkeg",
    "tower_spiritbuilder_xin",
    "tower_spiritbuilder_great_xin",
    "tower_spiritbuilder_io",
    "tower_spiritbuilder_wisp",
    "tower_spiritbuilder_spirit_king",
    "tower_spiritbuilder_lightning_spirit"
}

function precache(keys)
    Timers:CreateTimer(25, function()
        print("async precache of spirit builder units")
        for _, unitName in pairs(spiritUnits) do
            PrecacheUnitByNameAsync(unitName, function(...) end)
        end
    end)
end
