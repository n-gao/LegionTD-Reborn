if GameRound == nil then
  GameRound = class ({})
end


--Liest Rundeninfos ein
function GameRound:ReadRoundConfiguration(kv, roundNumber)
  self.roundNumber = roundNumber
  self.roundQuestTitle = kv.round_quest_title or "Kaputt"
  self.roundTitle = kv.round_title or "Kaputt"
  self.bounty = kv.bounty
  self.winningTeam = DOTA_TEAM_NOTEAM
  self.spawners = {}

  for key, val in pairs(kv) do
    if type(val) == "table" and val.NPCName then
      local spawner = GameSpawner()
      spawner:ReadConfiguration( key, val, self)
      self.spawners[key] = spawner
    end
  end
end


--Begin der Runde
function GameRound:Begin()
  print("Runde "..self.roundNumber.." started.")

  self.remainingUnits = {}
  self.EventHandles = {
    ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameRound, "OnNPCSpawned"), self),
    ListenToGameEvent("entity_killed", Dynamic_Wrap(GameRound, "OnEntityKilled"), self)
  }
  self.unstuckTimer = Timers:CreateTimer(120, function()
    if Game:GetCurrentRound() == self then
      Game:ClearBoard()
      print("Unstuck")
    end
  end)
  for ind, key in pairs(self.spawners) do
    key:Spawn()
  end
end

--Ende einer Runde
function GameRound:End()
  for key, val in pairs(self.EventHandles) do
    StopListeningToGameEvent(val)
  end
  Timers.timers[self.unstuckTimer] = nil
  self.unstuckTimer = nil
  self.EventHandles = {}
  Game:RoundFinished()
end


--Überprüft ob eine Runde vorbei ist
function GameRound:CheckEnd()
  self:CheckUnitsAlive()
  if next(self.remainingUnits) == nil then
    print("Rounde beendet")
    self:End()
  end
end



function GameRound:CheckUnitsAlive()
  local deadUnitCount = 0
  for ind, unit in pairs(self.remainingUnits) do
    if unit:IsNull() or not unit:IsAlive() then
      table.remove(self.remainingUnits, ind - deadUnitCount)
      deadUnitCount = deadUnitCount + 1
    end
  end
end


--NPC gespawnt
function GameRound:OnNPCSpawned(event)
  local spawned = EntIndexToHScript(event.entindex)
  if not spawned or spawned:IsPhantom() or spawned:GetClassname() == "npc_dota_thinker" or spawned:GetUnitName() == "" then
    return
  end
  if spawned:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not spawned.dontAdd then
    self:AddUnitToBeKilled(spawned)
  end
end



function GameRound:AddUnitToBeKilled(unit)
  unit:SetMustReachEachGoalEntity(true)
  table.insert(self.remainingUnits, unit)
end


--Jemand wurde getötet
function GameRound:OnEntityKilled(event)
  local killed = EntIndexToHScript(event.entindex_killed)
  if not killed then
    return
  end
  for i, unit in pairs(self.remainingUnits) do
    if killed == unit then
      table.remove(self.remainingUnits, i)
      break
    end
  end
  print(""..#self.remainingUnits.." units left")
  self:CheckEnd()
end



function GameRound:KillAll()
  if not self.remainingUnits then
    return
  end
  for _,ent in pairs(self.remainingUnits) do
    Timers:CreateTimer(0, function()
      if not ent:IsNull() then
       ent:ForceKill(false)
     end
   end)
  end
end
