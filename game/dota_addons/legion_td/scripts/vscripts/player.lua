if Player == nil then
  Player = class({})
end

--new player
function Player.new(plyEntitie, userID)
  local self = Player()
  self.plyEntitie = plyEntitie
  self.teamnumber = self:GetTeamNumber()
  plyEntitie.myPlayer = self
  self.userID = userID
  self.units = {}
  self.tangos = START_TANGO
  self.tangoAddAmount = START_TANGO_ADD_AMOUNT
  self.tangoAddSpeed = START_TANGO_ADD_SPEED
  self.tangoAddProgress = 0
  self.income = START_INCOME
  self.foodlimit = START_FOOD_LIMIT
  self.leaks = 0
  self.leaksPenalty = 0
  return self
end


function Player:SetPlayerEntitie(plyEntitie, userID)
  self.plyEntitie = plyEntitie
  self.userID = userID
  plyEntitie.myPlayer = self
  if self.lane then
    self.lane.isActive = true
  end
  for _,unit in pairs(self.units) do
    unit:GivePlayerControl()
  end
end


function Player:RemoveEntitie()
  print("User "..self.userID.." removed.")
  self.plyEntitie = nil
  self.userID = -1
  if not Game:IsBetweenRounds() then
    self.leaked = true;
  end
  if self.lane then
    self.lane.isActive = false
  end
end



--sets hero to player
function Player:SetNPC(npc)
  self.hero = npc
  self.playerID = self:GetPlayerID()
  npc.player = self


  local laneID = self.hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and 1 or 5
  if self.hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    laneID = 1
  else
    laneID = 5
  end
  while Game.lanes[""..laneID].isUsed do
    laneID = laneID + 1
    if not Game.lanes[""..laneID] then
      print("FUUUUUUUCK")
      break
    end
  end

  self.lane = Game.lanes[""..laneID]
  self.lane.player = self
  self.lane.isUsed = true
  self.lane.isActive = true
  self:PrepareBuilding(self.lane.mainBuilding)
  self:PrepareBuilding(self.lane.foodBuilding)

  --skill abilities
  for i = 0, self.hero:GetAbilityCount() - 1 do
    local ability = self.hero:GetAbilityByIndex(i)
    if ability then
      ability:SetLevel(1)
      ability.player = self
    end
  end
  self.hero:SetAbilityPoints(0)

  --prepartaion
  npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
  Timers:CreateTimer( 0.2, function()
    self:ToSpawn()
  end)
  self:RefreshPlayerInfo()
end


--checks tangos
function Player:HasEnoughTangos(amount)
  return self.tangos >= amount
end

--consumes tangos
function Player:SpendTangos(amount)
  if self:HasEnoughTangos(amount) then
    self:AddTangos(-amount)
    return true
  else
    return false
  end
end

function Player:HasEnoughFood(food)
  if self.foodlimit - self:GetUsedFood() >= food then
    return true
  else
    return false
  end
end


function Player:IncreaseFoodLimit(increment)
  self.foodlimit = self.foodlimit + increment
  self:RefreshPlayerInfo()
end


function Player:GetUsedFood()
  local usedFood = 0
  for _,unit in pairs(self.units) do
    usedFood = usedFood + unit.foodCost
  end
  usedFood = usedFood + self.tangoAddAmount - START_TANGO_ADD_AMOUNT
  return usedFood
end


--add income
function Player:AddIncome(amount)
  self.income = self.income + amount
  self:RefreshPlayerInfo()
end


--adds income to gold
function Player:Income(bounty)
  PlayerResource:ModifyGold(self:GetPlayerID(), self.income + bounty, true, DOTA_ModifyGold_Unspecified)
end


--get player id
function Player:GetPlayerID()
  if not self.plyEntitie then
    self:RemoveEntitie()
    return self.playerID
  end
  self.playerID = self.plyEntitie:GetPlayerID()
  return self.plyEntitie:GetPlayerID()
end


--get player
function Player:GetPlayer()
  return PlayerResource:GetPlayer(self:GetPlayerID())
end


--get team number
function Player:GetTeamNumber()
  return self.plyEntitie:GetTeamNumber()
end


--get position before ancient
function Player:GetLastDef()
  return Game.lastDefends[""..self:GetTeamNumber()]
end


--get position of incoming unit spawn
function Player:GetIncomeSpawner()
  return Game.incomeSpawner[""..self:GetTeamNumber()]
end


--adds tangos
function Player:AddTangos(amount)
  self.tangos = self.tangos + amount
  if Game.withIncomeLimit and self.tangos > Game:GetTangoLimit() then
    self.tangos = Game:GetTangoLimit()
  end
  self:RefreshPlayerInfo()
end


--refreshs tango ui
function Player:RefreshPlayerInfo()
  if self.plyEntitie and not self.plyEntitie:IsNull() and self:GetPlayerID() then
    CustomGameEventManager:Send_ServerToAllClients("update_player_info", {
      playerID = self:GetPlayerID(),
      leaks = self.leaks,
      tangoCount = self.tangos,
      goldIncome = self.income,
      tangoIncome = math.floor(self.tangoAddAmount / self.tangoAddSpeed * 60),
      currentFood = self:GetUsedFood(),
      maxFood = self.foodlimit,
    })
  end
end


function Player:Leaked(unit, level)
  self.leaked = true
  self.leaks = self.leaks + 1
  self.leaksPenalty = self.leaksPenalty + level
  self:RefreshPlayerInfo()
end



--resets player location
function Player:ToSpawn()
  self.hero:SetAbsOrigin(self.lane.heroSpawn:GetAbsOrigin())
  PlayerResource:SetCameraTarget(self:GetPlayerID(), self.hero)
  Timers:CreateTimer(0.1, function()
    PlayerResource:SetCameraTarget(self:GetPlayerID(), nil)
  end)
  self.hero:Stop()
end


--on leaving lane
function leaveLane(trigger)
  local hero = trigger.activator
  if hero and hero:IsRealHero() then
    local vHeroPos = hero:GetAbsOrigin()
    local vCent = trigger.caller:GetCenter()
    local vMax = vCent + trigger.caller:GetBoundingMaxs()
    local vMin = vCent + trigger.caller:GetBoundingMins()
    if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      vHeroPos.x = vMin.x - 128
    else
      vHeroPos.x = vMax.x + 128
    end
    FindClearSpaceForUnit(hero, vHeroPos, false)
    hero:Stop()
  end
end



function Player:PrepareBuilding(building)
  building:SetTeam(self:GetTeamNumber())
  building:SetOwner(self.hero)
  building:SetControllableByPlayer(self:GetPlayerID(), true)
  building.player = self
  for i = 0,building:GetAbilityCount() do
    if building:GetAbilityByIndex(i) then
      building:GetAbilityByIndex(i).player = self
    end
  end
end



function Player:SetTangoAddAmount(newAddAmount)
  self.tangoAddAmount = tonumber(newAddAmount)
  self:RefreshPlayerInfo()
end



function Player:SetTangoAddSpeed(newAddSpeed)
  self.tangoAddSpeed = newAddSpeed
  self:RefreshPlayerInfo()
end



function Player:GetUnitKey(unit)
  for key, val in pairs(self.units) do
    if val == unit then
      return key
    end
  end
end



function Player:CreateTangoTicker()
  if (not Timers.timers[self.timer]) and (self.lane.mainBuilding) then

    self.timer = Timers:CreateTimer(function()
      
      local tangoDelay = self.tangoAddSpeed
      if self.leaked then tangoDelay = self.tangoAddSpeed + (self.tangoAddSpeed * LEAKED_TANGO_MULTIPLIER * self.leaksPenalty) end

      self.tangoAddProgress = self.tangoAddProgress + 1/tangoDelay/30
      local i = self.tangoAddProgress*math.pi*2
      if self.lane.mainBuilding:GetAbsOrigin().y > 0 then
        i = i + math.pi
      end
      self.lane.mainBuilding:SetForwardVector(Vector(math.sin(i), math.cos(i), 0))

      if self.tangoAddProgress > 1 then
        self.tangoAddProgress = self.tangoAddProgress - 1
        PopupHealing(self.lane.mainBuilding, self.tangoAddAmount)
        self:AddTangos(self.tangoAddAmount)
      end

      return (1/30)
    end)
  end
end



function Player:SendErrorCode(code)
  if self.plyEntitie then
    CustomGameEventManager:Send_ServerToPlayer(self:GetPlayer(), "error", {
      errorCode = code
    })
  end
end



function Player:IsActive()
  return self.lane and self.lane.isActive
end
