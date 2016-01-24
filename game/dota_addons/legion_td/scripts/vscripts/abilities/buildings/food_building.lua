function increase_food_limit(event)
  local increment = event.ability:GetSpecialValueFor("limit_increament")
  local player = event.caster.player
  player:IncreaseFoodLimit(increment)
  player.buildingUpgradeValue = player.buildingUpgradeValue + event.ability:GetGoldCost(-1)
end
