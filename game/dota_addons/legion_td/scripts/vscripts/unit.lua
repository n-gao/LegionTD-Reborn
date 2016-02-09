if Unit == nil then
  Unit = class({})
end



ai_standard = require('ai/ai_core')
--Naturebuilder AI
ai_broodmother = require('ai/naturebuilder/ai_broodmother')
ai_bigcentaur = require('ai/naturebuilder/ai_bigcentaur')
--Elementalbuilder AI
ai_fireelemental = require('ai/elementalbuilder/ai_fireelemental')
ai_firegod = require('ai/elementalbuilder/ai_firegod')
ai_thunderelemental = require('ai/elementalbuilder/ai_thunderelemental')
ai_thundergod = require('ai/elementalbuilder/ai_thundergod')
ai_thunderwarrior = require('ai/elementalbuilder/ai_thunderwarrior')
ai_voidelemental = require('ai/elementalbuilder/ai_voidelemental')
ai_waterwarrior = require('ai/elementalbuilder/ai_waterwarrior')
--Humanbuilder AI
ai_militia = require('ai/humanbuilder/ai_militia')
ai_footman = require('ai/humanbuilder/ai_footman')
ai_soldier = require('ai/humanbuilder/ai_soldier')
ai_spearman = require('ai/humanbuilder/ai_spearman')



function Unit.new(npcclass, position, owner, foodCost, goldCost)
  local self = Unit()
  self.owner = owner
  self.player = owner.player
  self.buyround = Game:GetCurrentRound()
  self.goldCost = goldCost
  self.foodCost = foodCost
  self.npcclass = npcclass
  self.spawnposition = position
  self.target = self.player.lane.unitWaypoint
  self.nextTarget = self.target:GetAbsOrigin()
  self.nextTarget.x = self.spawnposition.x
  table.insert(self.player.units, self)
  self:Spawn()
end



function Unit:Spawn()
  --PrecacheUnitByNameAsync(self.npcclass, function () 
    self.npc = CreateUnitByName(self.npcclass, self.spawnposition, false, nil,
    self.owner, self.owner:GetTeamNumber())
    if self.spawnposition.y > 0 then
      self.npc:SetAngles(0, 90, 0)
    else
      self.npc:SetAngles(0, 270, 0)
    end
    self.npc.unit = self
    self.npc.player = self.player
    self.npc.nextTarget = self.nextTarget
    self.npc:SetMinimumGoldBounty(self.foodCost)
    self.npc:SetMaximumGoldBounty(self.foodCost)
    self:Lock()
  --end
  --)
end



function Unit.ApplyAI(unit)
  local name = unit:GetUnitName()
  if name == "tower_naturebuilder_broodmother" then ai_broodmother.Init(unit)
  elseif name == "tower_naturebuilder_big_centaur" then ai_bigcentaur.Init(unit)
  elseif name == "tower_elementalbuilder_earthgod" then return
  elseif name == "tower_elementalbuilder_fireelemental" then ai_fireelemental.Init(unit)
  elseif name == "tower_elementalbuilder_firegod" then ai_firegod.Init(unit)
  elseif name == "tower_elementalbuilder_firewarrior" then return
  elseif name == "tower_elementalbuilder_thunderelemental" then ai_thunderelemental.Init(unit)
  elseif name == "tower_elementalbuilder_thundergod" then ai_thundergod.Init(unit)
  elseif name == "tower_elementalbuilder_thunderwarrior" then ai_thunderwarrior.Init(unit)
  elseif name == "tower_elementalbuilder_voidelemental" then ai_voidelemental.Init(unit)
  elseif name == "tower_elementalbuilder_voidgod" then return
  elseif name == "tower_elementalbuilder_watergod" then return
  elseif name == "tower_elementalbuilder_waterwarrior" then ai_waterwarrior.Init(unit)
  elseif name == "tower_humanbuilder_footman" then ai_footman.Init(unit)
  elseif name == "tower_humanbuilder_soldier" then ai_soldier.Init(unit)
  elseif name == "tower_humanbuilder_spearman" then ai_spearman.Init(unit)
  elseif name == "tower_humanbuilder_paladin" then return
  elseif name == "tower_humanbuilder_blademaster" then return
  elseif name == "tower_humanbuilder_tactician" then return
  elseif name == "tower_humanbuilder_novice" then return
  elseif name == "tower_humanbuilder_mage" then return
  elseif name == "tower_humanbuilder_archmage" then return
  elseif name == "tower_humanbuilder_archbishop" then return
  elseif name == "tower_humanbuilder_soundmaster" then return
  elseif name == "tower_humanbuilder_gyrocopter_mk1" then return
  elseif name == "tower_humanbuilder_gyrocopter_mk2" then return
  elseif name == "tower_humanbuilder_futuristic_gyrocopter" then return
  elseif name == "tower_naturebuilder_treebeard" then return
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
    self.npc:RemoveModifierByName("modifier_stunned")
    self.npc:RemoveModifierByName("modifier_invulnerable")
    self.npc:SetControllableByPlayer(-1, false)
    self.npc:Stop()
    Timers:CreateTimer(0.5, function ()
      local pos = self.npc.nextTarget
      --pos.x = self.spawnposition.x
      ExecuteOrderFromTable({
        UnitIndex = self.npc:entindex(), 
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        TargetIndex = 0, --Optional.  Only used when targeting units
        AbilityIndex = 0, --Optional.  Only used when casting abilities
        Position = pos, --Optional.  Only used when targeting the ground
        Queue = 0 --Optional.  Used for queueing up abilities
      })
      self.ApplyAI(self.npc)
    end)
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
  Timers:CreateTimer(1, function ()
      UTIL_RemoveImmediate(unit.npc)
    end)
  local gold = unit.goldCost / 2
  if unit.buyround == Game:GetCurrentRound() then
    gold = unit.goldCost
  end
  PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
  table.remove(unit.player.units, unit.player:GetUnitKey(unit))
  player:RefreshPlayerInfo()
end



function leaveLane(trigger)
  local npc = trigger.activator
  if npc and not npc:IsRealHero() then
    if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
      PopupSadface(npc)
      npc.leftLane = true
      npc:AddAbility("ability_phased")
      local ability = npc:FindAbilityByName("ability_phased")
      ability:SetLevel(1)
      if npc.lane.player then
        npc.lane.player:Leaked(self, npc:GetLevel())
      end
      npc:SetMinimumGoldBounty(1)
      npc:SetMaximumGoldBounty(1)
      --npc.nextTarget = npc.lastWaypoint
    end
  end
end


function UnitSpawn(event)
  local unit = Unit.new(Game.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")),
    event.unit:GetCursorPosition(), event.caster, event.ability:GetSpecialValueFor("food_cost"),
    event.ability:GetGoldCost(event.ability:GetLevel()))
  event.caster.player:RefreshPlayerInfo()
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



function OnStartTouch(trigger) -- trigger at end of lane to teleport to final defense
  local npc = trigger.activator
  if npc.unit and not npc:IsRealHero() then
    if not (npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS) then
      npc.nextTarget = Game.lastDefends[""..npc:GetTeamNumber()]:GetAbsOrigin()
      if npc:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
        FindClearSpaceForUnit(npc, Game.lastDefendsRanged[""..npc:GetTeamNumber()]:GetAbsOrigin(), true)
        npc.nextTarget.y = npc.nextTarget.y - 200
      else
        FindClearSpaceForUnit(npc, npc.nextTarget, true)
      end
      ExecuteOrderFromTable({
            UnitIndex = npc:entindex(), 
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            TargetIndex = 0, --Optional.  Only used when targeting units
            AbilityIndex = 0, --Optional.  Only used when casting abilities
            Position = npc.nextTarget, --Optional.  Only used when targeting the ground
            Queue = 0 --Optional.  Used for queueing up abilities
          })
    end
  end
end
