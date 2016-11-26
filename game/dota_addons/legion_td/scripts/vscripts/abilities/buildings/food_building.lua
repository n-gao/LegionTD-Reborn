function increase_food_limit(event)
    local increment = event.ability:GetSpecialValueFor("limit_increament")
    local player = event.caster.player
    player:IncreaseFoodLimit(increment)
    player.buildingUpgradeValue = player.buildingUpgradeValue + event.ability:GetGoldCost(-1)
    if event.ability:GetLevel() == event.ability:GetMaxLevel() then
        event.caster:RemoveAbility(event.ability:GetAbilityName())
    else
        event.ability:SetLevel(event.ability:GetLevel() + 1)
    end
end
