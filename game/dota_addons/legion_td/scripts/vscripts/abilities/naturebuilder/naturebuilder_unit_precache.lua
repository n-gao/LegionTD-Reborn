natureUnits = {
    "tower_naturebuilder_agressive_boar",
    "tower_naturebuilder_bear",
    "tower_naturebuilder_big_bug",
    "tower_naturebuilder_big_centaur",
    "tower_naturebuilder_broodmother",
    "tower_naturebuilder_bug",
    "tower_naturebuilder_centaur",
    "tower_naturebuilder_centaur_warrunner",
    "tower_naturebuilder_druid_bear",
    "tower_naturebuilder_flower_tower",
    "tower_naturebuilder_hyena",
    "tower_naturebuilder_iron_bear",
    "tower_naturebuilder_shroom",
    "tower_naturebuilder_spider",
    "tower_naturebuilder_treant",
    "tower_naturebuilder_treebeard"
}

function precache(keys)
    Timers:CreateTimer(25, function()
        print("async precache of nature builder units")
        for _, unitName in pairs(natureUnits) do
            PrecacheUnitByNameAsync(unitName, function(...) end)
        end
    end)
end
