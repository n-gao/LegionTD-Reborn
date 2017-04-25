function add_tango_collector(event)
    local player = event.caster.player
    local newTangoAdd = player.tangoAddAmount + 1
    local foodCost = event.ability:GetSpecialValueFor("food_cost")
    if (not player:HasEnoughFood(foodCost)) then
        Player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_FOOD)
        return
    end
    player:SetTangoAddAmount(newTangoAdd)
    player.buildingUpgradeValue = player.buildingUpgradeValue + event.ability:GetGoldCost(event.ability:GetLevel())
    if event.ability:GetLevel() == event.ability:GetMaxLevel() then
        event.caster:RemoveAbility(event.ability:GetAbilityName())
    else
        event.ability:SetLevel(event.ability:GetLevel() + 1)
    end
end

function increase_tango_speed(event)
    local player = event.caster.player
    local newTangoSpeed = player.tangoAddSpeed * 0.6
    player:SetTangoAddSpeed(newTangoSpeed)
    player.buildingUpgradeValue = player.buildingUpgradeValue + event.ability:GetGoldCost(event.ability:GetLevel())
    if event.ability:GetLevel() == event.ability:GetMaxLevel() then
        event.caster:RemoveAbility(event.ability:GetAbilityName())
    else
        event.ability:SetLevel(event.ability:GetLevel() + 1)
    end
end

function refund_gold(event)
    local player = event.caster.player
    local gold = event.ability:GetGoldCost(event.ability:GetLevel() - 1)
    player.hero:ModifyGold(gold, true, DOTA_ModifyGold_Unspecified)
end

function refund_tango(event)
    local player = event.caster.player
    local tango = event.ability:GetSpecialValueFor("tango_cost")
    player:AddTangos(tango)
end
