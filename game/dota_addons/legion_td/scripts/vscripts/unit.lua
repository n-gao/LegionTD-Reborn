if Unit == nil then
  Unit = class({})
end



ai_standard = require('ai/ai_core')
--Naturebuilder AI
ai_broodmother = require('ai/naturebuilder/ai_broodmother')
ai_bigCentaur = require('ai/naturebuilder/ai_bigCentaur')
--Elementalbuilder AI
ai_earthgod = require('ai/elementalbuilder/ai_earthgod')
ai_fireelemental = require('ai/elementalbuilder/ai_fireelemental')
ai_firegod = require('ai/elementalbuilder/ai_firegod')
ai_firewarrior = require('ai/elementalbuilder/ai_firewarrior')
ai_thunderelemental = require('ai/elementalbuilder/ai_thunderelemental')
ai_thundergod = require('ai/elementalbuilder/ai_thundergod')
ai_thunderwarrior = require('ai/elementalbuilder/ai_thunderwarrior')
ai_voidelemental = require('ai/elementalbuilder/ai_voidelemental')
ai_voidgod = require('ai/elementalbuilder/ai_voidgod')
ai_watergod = require('ai/elementalbuilder/ai_watergod')
ai_waterwarrior = require('ai/elementalbuilder/ai_waterwarrior')



function Unit.new(npcclass, position, owner, foodCost, goldCost)
  local self = Unit()
  self.buytime = GameRules:GetGameTime()
  self.goldCost = goldCost
  self.foodCost = foodCost
  self.npcclass = npcclass
  self.spawnposition = position
  self.owner = owner
  self.player = owner.player
  self.target = self.player.lane.unitWaypoint
  self.currentTarget = self.target
  table.insert(self.player.units, self)
  self:Spawn()
end



function Unit:Spawn()
  self.npc = CreateUnitByName(self.npcclass, self.spawnposition, true, nil,
  self.owner, self.owner:GetTeamNumber())
  if self.spawnposition.y > 0 then
    self.npc:SetAngles(0, 90, 0)
  else
    self.npc:SetAngles(0, 270, 0)
  end
  self.npc.unit = self
  self.npc.player = self.player
  self.currentTarget = self.target
  self:Lock()
end



function Unit.ApplyAI(unit)
  local name = unit:GetUnitName()
  if name == "tower_naturebuilder_broodmother" then ai_broodmother.Init(unit)
  elseif name == "tower_naturebuilder_big_centaur" then ai_bigCentaur.Init(unit)
  elseif name == "tower_elementalbuilder_earthgod" then ai_earthgod.Init(unit)
  elseif name == "tower_elementalbuilder_fireelemental" then ai_fireelemental.Init(unit)
  elseif name == "tower_elementalbuilder_firegod" then ai_firegod.Init(unit)
  elseif name == "tower_elementalbuilder_firewarrior" then ai_firewarrior.Init(unit)
  elseif name == "tower_elementalbuilder_thunderelemental" then ai_thunderelemental.Init(unit)
  elseif name == "tower_elementalbuilder_thundergod" then ai_thundergod.Init(unit)
  elseif name == "tower_elementalbuilder_thunderwarrior" then ai_thunderwarrior.Init(unit)
  elseif name == "tower_elementalbuilder_voidelemental" then ai_voidelemental.Init(unit)
  elseif name == "tower_elementalbuilder_voidgod" then ai_voidgod.Init(unit)
  elseif name == "tower_elementalbuilder_watergod" then ai_watergod.Init(unit)
  elseif name == "tower_elementalbuilder_waterwarrior" then ai_waterwarrior.Init(unit)
  else ai_standard.Init(unit)
  end
end



function Unit:RemoveNPC()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:ForceKill(false)
  end
end



function Unit:Respawn()
  self:RemoveNPC()
  self:Spawn()
end



function Unit:ResetPosition()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    FindClearSpaceForUnit(self.npc, self.spawnposition, true)
    self:Unlock()
  end
end



function Unit:Unlock()
  if self.npc and not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:SetControllableByPlayer(-1, false)
    self.npc:RemoveModifierByName("modifier_stunned")
    self.npc:RemoveModifierByName("modifier_invulnerable")
    self.npc:Stop()
    self.npc:SetInitialGoalEntity(self.currentTarget)
    self.npc:SetMustReachEachGoalEntity(true)
    self.npc.nextTarget = self.currentTarget
    self.ApplyAI(self.npc)
  end
end



function Unit:Lock()
  if not self.npc:IsNull() and self.npc:IsAlive() then
    self.npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    self.npc:AddNewModifier(nil, nil, "modifier_stunned", {})
    self:GivePlayerControl()
  end
end



function Unit:GivePlayerControl()
  if self.player:IsActive() then
    self.npc:SetControllableByPlayer(self.owner.player:GetPlayerID(), true)
  end
end




function sell(event)
  local unit = event.caster.unit
  local player = unit.player
  unit:RemoveNPC()
  local gold = unit.goldCost / 2
  if GameRules:GetGameTime() <= (unit.buytime + 6) then
    gold = unit.goldCost
  end
  PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
  table.remove(unit.player.units, unit.player:GetUnitKey(unit))
end



function leaveLane(trigger)
  local npc = trigger.activator
  if npc and not npc:IsRealHero() then
    if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      npc.leftLane = true
      npc.lane.player:Leaked(self)
      npc:SetMinimumGoldBounty(1)
      npc:SetMaximumGoldBounty(1)
      npc.nextTarget = npc.lastWaypoint
    end
  end
end



function upgrade_unit(event)
  local id = event.ability:GetSpecialValueFor("unitID")
  local newclass = Game.GetUnitNameByID(id)
  event.caster.unit.npcclass = newclass
  event.caster.unit:Respawn()
  event.caster.unit.foodCost = event.caster.unit.foodCost
    + event.ability:GetSpecialValueFor("food_cost")
  event.caster.unit.goldCost = event.caster.unit.goldCost
    + event.ability:GetGoldCost(event.ability:GetLevel())
end



function OnStartTouch(trigger)
  local npc = trigger.activator
  if npc.unit and not npc:IsRealHero() then
    if not (npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS) then
      FindClearSpaceForUnit(npc, Game.lastDefends[""..npc:GetTeamNumber()]:GetAbsOrigin(), true)
      npc:Stop()
      npc:SetInitialGoalEntity(nil)
      npc.nextTarget = nil
    end
  end
end
