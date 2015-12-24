if GameSpawner == nil then
  GameSpawner = class({})
end

LAST_WAVE_DMG_PER_ROUND = 200;
LAST_WAVE_HEALTH_PER_ROUND = 2000;

ai_standard = require('ai/ai_core')
ai_techies = require('ai/waves/ai_techies')
ai_fatty = require('ai/waves/ai_fatty')
ai_dragon = require('ai/waves/ai_dragon')
ai_deathprophet = require('ai/waves/ai_deathprophet')
ai_ogre = require('ai/waves/ai_ogre')
ai_rubick = require('ai/waves/ai_rubick')
ai_necro_replacement = require('ai/waves/ai_necro_replacement')

function GameSpawner:ReadConfiguration(name, kv, gameRound)
  self.gameRound = gameRound
  self.name = name
  self.npcName = kv.NPCName
  self.unitCount = kv.UnitCount
  self.dmgBonus = 0
  self.healthBonus = 0
end

function GameSpawner:Spawn()
  local spawners = Game.lanes
  local count = 1
  --Spawn normal Wave
  for key,value in pairs(spawners) do
    if value.isActive then
      for i = 1, self.unitCount do
        local creep = CreateUnitByName(self.npcName,
          value.spawnpoint:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        creep:Stop()
        creep:SetInitialGoalEntity(value.waypoint)
        creep.waypoint = value.waypoint
        creep.nextTarget = value.nextWaypoint
        creep.lastWaypoint = value.lastWaypoint
        creep.lane = value
        creep:SetMaxHealth(creep:GetMaxHealth() + self.healthBonus)
        creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() + self.healthBonus)
        creep:Heal(self.healthBonus, nil)
        creep:SetBaseDamageMin(creep:GetBaseDamageMin() + self.dmgBonus)
        creep:SetBaseDamageMax(creep:GetBaseDamageMax() + self.dmgBonus)
        self.ApplyAI(creep)
      end
    end
  end

  self.dmgBonus = self.dmgBonus + LAST_WAVE_DMG_PER_ROUND
  self.healthBonus = self.healthBonus + LAST_WAVE_HEALTH_PER_ROUND

  self:SendIncomingUnits(DOTA_TEAM_GOODGUYS)
  self:SendIncomingUnits(DOTA_TEAM_BADGUYS)
end

function GameSpawner.ApplyAI(creep)
  local name = creep:GetUnitName()
  if name == "unit_techies" then ai_techies.Init(creep)
  elseif name == "unit_fatty" then ai_fatty.Init(creep)
  elseif name == "unit_dragon" then ai_dragon.Init(creep)
  elseif name == "unit_deathprophet" then ai_deathprophet.Init(creep)
  elseif name == "unit_ogre" then ai_ogre.Init(creep)
  elseif name == "unit_rubick" then ai_rubick.Init(creep)
  elseif name == "unit_necro_replacement" then ai_necro_replacement.Init(creep)
  else ai_standard.Init(creep)
  end
end

function GameSpawner:SendIncomingUnits(team)
  local spawners = {} -- list of possible lanes that we can distribute to, indexed 1 to 4
  local count = 0 -- number of valid lanes to distribute to
  local units = {}
  local distributedValues = {}
  local lowestValue = 0
  local leader = 1
  if team == DOTA_TEAM_GOODGUYS then
    units = Game.sendRadiant
    Game.sendRadiant = {}
    for i = 5,8 do
      if Game.lanes[""..i].isActive then
        spawners[count + 1] = Game.lanes[""..i]
        distributedValues[count + 1] = 0
        count = count + 1
      end
    end
    leader = Game.sendLeaderRadiant
    Game.sendLeaderRadiant = Game.sendLeaderRadiant + 1
    if Game.sendLeaderRadiant > count then Game.sendLeaderRadiant = 1 end
  else
    units = Game.sendDire
    Game.sendDire = {}
    for i = 1,4 do
      if Game.lanes[""..i].isActive then
        spawners[count + 1] = Game.lanes[""..i]
        distributedValues[count + 1] = 0
        count = count + 1
      end
      leader = Game.sendLeaderDire
      Game.sendLeaderDire = Game.sendLeaderDire + 1
      if Game.sendLeaderDire > count then Game.sendLeaderDire = 1 end
    end
  end

  table.sort(units, function(a,b) return a.tangoValue>b.tangoValue end)-- sort units by their tango value

  for _,unit in ipairs(units) do
    if next(spawners) == nil then
      unit:ForceKill(false)
    else
      local theLane = 1
      for j = (leader), (leader+(count-1)) do
        if distributedValues[((j-1)%count)+1] == lowestValue then
          theLane = ((j-1)%count)+1
          break
        end
      end
      local lane = spawners[theLane]
      FindClearSpaceForUnit(unit, lane.spawnpoint:GetAbsOrigin(), true)
      unit:SetInitialGoalEntity(lane.waypoint)
      unit:SetTeam(DOTA_TEAM_NEUTRALS)
      unit.nextTarget = lane.nextWaypoint
      unit.lastWypoint = lane.lastWaypoint
      unit.lane = lane
      self.gameRound:AddUnitToBeKilled(unit)
      distributedValues[theLane] = distributedValues[theLane] + unit.tangoValue
      tempLowestValue = distributedValues[leader]
      for j = 1, (count) do
        if distributedValues[j] < tempLowestValue then tempLowestValue = distributedValues[j] end
      end
      lowestValue = tempLowestValue
    end
  end
end
