humanUnits = {
    "tower_humanbuilder_archbishop",
    "tower_humanbuilder_archer",
    "tower_humanbuilder_archmage",
    "tower_humanbuilder_blademaster",
    "tower_humanbuilder_footman",
    "tower_humanbuilder_futuristic_gyrocopter",
    "tower_humanbuilder_general",
    "tower_humanbuilder_gunner",
    "tower_humanbuilder_gyrocopter_mk1",
    "tower_humanbuilder_gyrocopter_mk2",
    "tower_humanbuilder_hunter",
    "tower_humanbuilder_icewrack_grandmaster",
    "tower_humanbuilder_lieutenant",
    "tower_humanbuilder_mage",
    "tower_humanbuilder_marksman",
    "tower_humanbuilder_militia",
    "tower_humanbuilder_novice",
    "tower_humanbuilder_paladin",
    "tower_humanbuilder_sharpshooter",
    "tower_humanbuilder_soldier",
    "tower_humanbuilder_soundmaster",
    "tower_humanbuilder_spearman",
    "tower_humanbuilder_tactician"
}

function precache(keys)
    Timers:CreateTimer(25, function()
        print("async precache of human builder units")
        for _, unitName in pairs(humanUnits) do
            PrecacheUnitByNameAsync(unitName, function(...) end)
        end
    end)
end
