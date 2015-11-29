if GameSpawner == nil then
  GameSpawner = class({})
end

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
        self.ApplyAI(creep)
      end
    end
  end

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
  local spawners = {}
  local count = 0
  local units = {}
  if team == DOTA_TEAM_GOODGUYS then
    units = Game.sendRadiant
    Game.sendRadiant = {}
    for i = 5,8 do
      if Game.lanes[""..i].isActive then
        spawners[count + 1] = Game.lanes[""..i]
        count = count + 1
      end
    end
  else
    units = Game.sendDire
    Game.sendDire = {}
    for i = 1,4 do
      if Game.lanes[""..i].isActive then
        spawners[count + 1] = Game.lanes[""..i]
        count = count + 1
      end
    end
  end

  local ind = 1
  for _,unit in pairs(units) do
    if next(spawners) == nil then
      unit:ForceKill(false)
    else
      local lane = spawners[ind]
      ind = (ind % count) + 1
      FindClearSpaceForUnit(unit, lane.spawnpoint:GetAbsOrigin(), true)
      unit:SetInitialGoalEntity(lane.waypoint)
      unit:SetTeam(DOTA_TEAM_NEUTRALS)
      unit.nextTarget = lane.nextWaypoint
      unit.lastWypoint = lane.lastWaypoint
      unit.lane = lane
      self.gameRound:AddUnitToBeKilled(unit)
    end
  end
end
