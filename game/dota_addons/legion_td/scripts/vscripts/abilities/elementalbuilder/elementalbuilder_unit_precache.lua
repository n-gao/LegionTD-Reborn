elementalUnits = {
    "tower_elementalbuilder_earthbender",
    "tower_elementalbuilder_earthelemental",
    "tower_elementalbuilder_earthgod",
    "tower_elementalbuilder_earthwarrior",
    "tower_elementalbuilder_firebender",
    "tower_elementalbuilder_fireelemental",
    "tower_elementalbuilder_firegod",
    "tower_elementalbuilder_firewarrior",
    "tower_elementalbuilder_thunderbender",
    "tower_elementalbuilder_thunderelemental",
    "tower_elementalbuilder_thundergod",
    "tower_elementalbuilder_thunderwarrior",
    "tower_elementalbuilder_voidbender",
    "tower_elementalbuilder_voidelemental",
    "tower_elementalbuilder_voidgod",
    "tower_elementalbuilder_voidwarrior",
    "tower_elementalbuilder_waterbender",
    "tower_elementalbuilder_waterelemental",
    "tower_elementalbuilder_watergod",
    "tower_elementalbuilder_waterwarrior"
}

function precache(keys)
    Timers:CreateTimer(25, function()
        print("async precache of elemental builder units")
        for _, unitName in pairs(elementalUnits) do
            PrecacheUnitByNameAsync(unitName, function(...) end)
        end
    end)
end
