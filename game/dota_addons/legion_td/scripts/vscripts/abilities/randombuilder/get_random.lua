SpawnAbilities = {}

SpawnAbilities.tier1 = {
    "humanbuilder_spawn_militia",
    "naturebuilder_spawn_spider",
    "elementalbuilder_spawn_waterbender",
}

SpawnAbilities.tier2 = {
    "humanbuilder_spawn_archer",
    "naturebuilder_spawn_bug",
    "elementalbuilder_spawn_thunderbender",
}

SpawnAbilities.tier3 = {
    "humanbuilder_spawn_novice",
    "naturebuilder_spawn_bear",
    "elementalbuilder_spawn_earthbender",
}

SpawnAbilities.tier4 = {
    "humanbuilder_spawn_gyrocopter_mk1",
    "naturebuilder_spawn_treant",
    "elementalbuilder_spawn_firebender",
}

SpawnAbilities.tier5 = {
    "humanbuilder_spawn_lieutenant",
    "naturebuilder_spawn_hyena",
    "elementalbuilder_spawn_voidbender",
    "naturebuilder_spawn_centaur",
}

SpawnAbilities.tier6 = {
    "naturebuilder_spawn_centaur",
}

function GetRandomUnit(event)
    local tier = event.ability:GetSpecialValueFor("tier")
    local index = event.ability:GetAbilityIndex()
    event.unit:RemoveAbility(event.ability:GetName())
    print(tier)
    print(index)
    local ind = math.random(#SpawnAbilities["tier" .. tier])
    print(ind)
    local ability = event.unit:AddAbility(SpawnAbilities["tier" .. tier][ind])
    print(SpawnAbilities["tier" .. tier][ind])
    ability:SetAbilityIndex(index)
    ability:SetLevel(1)
end
