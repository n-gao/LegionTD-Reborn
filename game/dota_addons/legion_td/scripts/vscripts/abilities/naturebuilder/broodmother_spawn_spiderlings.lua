function SpawnSpiderlings(event)
    spider = CreateUnitByName("tower_naturebuilder_spider", event.caster:GetAbsOrigin(), true, nil, event.caster:GetOwner(), event.caster:GetTeamNumber())
    spider:AddNewModifier(spider, nil, "modifier_kill", { duration = event.ability:GetSpecialValueFor("duration") })
    spider.nextTarget = event.caster.nextTarget
    spider = CreateUnitByName("tower_naturebuilder_spider", event.caster:GetAbsOrigin(), true, nil, event.caster:GetOwner(), event.caster:GetTeamNumber())
    spider:AddNewModifier(spider, nil, "modifier_kill", { duration = event.ability:GetSpecialValueFor("duration") })
    spider.nextTarget = event.caster.nextTarget
end
