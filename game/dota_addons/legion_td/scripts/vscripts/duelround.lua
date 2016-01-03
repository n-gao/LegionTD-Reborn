if not DuelRound then
  DuelRound = class({})
end



function DuelRound.new(data, roundNumber, determinWinner)
  local self = DuelRound()
  if data then
    self.roundTitle = data.round_title
    self.bounty = data.bounty
  else
    self.roundTitle = "Final Round"
    self.bounty = 0
  end
  self.isDuelRound = true
  self.winningTeam = DOTA_TEAM_NOTEAM
  self.remainingUnitsRadiant = {}
  self.remainingUnitsDire = {}
  self.roundNumber = roundNumber
  self.winningCondition = determinWinner
  return self
end



function DuelRound:Begin()
  self.EventHandles = {
    ListenToGameEvent("entity_killed", Dynamic_Wrap(GameRound, "OnEntityKilled"), self)
  }
  if not winningCondition then
    self.unstuckTimer = Timers:CreateTimer(240, function()
      if Game:GetCurrentRound() == self then
        Game:ClearBoard()
        print("Unstuck")
      end
    end)
  else
    Game:RespawnUnits()
    Game.noUpgrade = true
  end
  Game.doneDuels = Game.doneDuels + 1
  self:PlaceUnits()
end



--Jemand wurde getötet
function DuelRound:OnEntityKilled(event)
  local killed = EntIndexToHScript(event.entindex_killed)
  if not killed then
    return
  end
  local team = self.remainingUnitsRadiant
  if killed:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    team = self.remainingUnitsDire
  end
  for i, unit in pairs(team) do
    if killed == unit then
      table.remove(team, i)
      break
    end
  end
  self:CheckEnd()
end



function DuelRound:PlaceUnits()
  for _,pl in pairs(Game.players) do
    if pl:IsActive() then
      local spawnPoint = Game.duelSpawn[""..pl:GetTeamNumber()]
      local target = Game.duelSpawn[""..(-pl:GetTeamNumber() + 5)]
      local team = self.remainingUnitsRadiant
      if pl:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        team = self.remainingUnitsDire
      end
      for _,unit in pairs(pl.units) do
        unit.nextTarget = target:GetAbsOrigin()
        FindClearSpaceForUnit(unit.npc, spawnPoint:GetAbsOrigin(), true)
        table.insert(team, unit.npc)
        ExecuteOrderFromTable(
          UnitIndex = unit.npc:entindex(),
          OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
          Position = unit.nextTarget
        )
      end
    end
  end
end



function DuelRound:CheckEnd()
  self:CheckUnitsAlive()
  if next(self.remainingUnitsRadiant) == nil or next(self.remainingUnitsDire) == nil then
    print("Rounde beendet")
    self:End()
  end
end



--Ende einer Runde
function DuelRound:End()
  self.winningTeam = DOTA_TEAM_GOODGUYS
  if next(self.remainingUnitsRadiant) == nil then
    self.winningTeam = DOTA_TEAM_BADGUYS
  end
  if self.determinWinner then
    GameRules:SetGameWinner(self.winningTeam)
    GameRules:Defeated()
  end
  for key, val in pairs(self.EventHandles) do
    StopListeningToGameEvent(val)
  end
  Timers.timers[self.unstuckTimer] = nil
  self.unstuckTimer = nil
  self.EventHandles = {}
  Game:RoundFinished()
end



function DuelRound:CheckUnitsAlive()
  local deadUnitCount = 0
  for ind, unit in pairs(self.remainingUnitsRadiant) do
    if unit:IsNull() or not unit:IsAlive() then
      table.remove(self.remainingUnitsRadiant, ind - deadUnitCount)
      deadUnitCount = deadUnitCount + 1
    end
  end
  deadUnitCount = 0
  for ind, unit in pairs(self.remainingUnitsDire) do
    if unit:IsNull() or not unit:IsAlive() then
      table.remove(self.remainingUnitsDire, ind - deadUnitCount)
      deadUnitCount = deadUnitCount + 1
    end
  end
end
