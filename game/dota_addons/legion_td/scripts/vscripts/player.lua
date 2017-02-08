if Player == nil then
    Player = class({})
end

--new player
function Player.new(plyEntitie, userID)
    local self = Player()
    self.plyEntitie = plyEntitie
    self.teamnumber = self:GetTeamNumber() -- new players don't have a team number so this is worthless here
    if self.plyEntitie ~= nil then plyEntitie.myPlayer = self end
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
    self.buildingUpgradeValue = 0
    self.missedSpawns = 0
    self.abandoned = false
    self.earnedTangos = 0
    self.experience = 0
    self.fractionKills = {}
    self.wonDuels = 0
    self.buildUnits = {}
    self.killedUnits = {}
    self.leakedUnits = {}
    return self
end

function Player:BuildUnit(unitname)
    self.buildUnits[unitname] = (self.buildUnits[unitname] or 0) + 1
end

function Player:KilledUnit(killed)
    self.killedUnits[killed:GetUnitName()] = (self.killedUnits[killed:GetUnitName()] or 0) + 1
    local fraction = Game.UnitKV[killed:GetUnitName()].Legion_Fraction or "other"
    self:IncreaseKillOfFraction(fraction)
end

function Player:GetFraction()
    if self.hero == nil then return "other" end
    local heroName = self.hero:GetUnitName()
    for _, data in pairs(Game.HeroKV) do
        if data.override_hero == heroName then
            return data.Legion_Fraction
        end
    end
    return "other"
end

function Player.NewPlaceHolder()
    return Player.new(nil, nil)
end

function Player:GetSteamID()
    local id = PlayerResource:GetSteamID(self:GetPlayerID())
    if id ~= -1 then
        return tostring(id)
    end
    return nil
end

function Player:GetWonDuels()
    if self.wonDuels == nil then self.wonDuels = 0 end
    return self.wonDuels
end

function Player:WonDuel()
    self.wonDuels = self:GetWonDuels() + 1
end

function Player:GetKillsOfFraction(fraction)
    return self.fractionKills[fraction] or 0
end

function Player:IncreaseKillOfFraction(fraction)
    self.fractionKills[fraction] = (self.fractionKills[fraction] or 0) + 1
end

function Player:GetExperience()
    return self.experience or 0
end

function Player:AddExperience(amount)
    self.experience = self:GetExperience() + amount
end

function Player:GetKills()
    if self.plyEntitie == nil then
        return 0
    end
    return PlayerResource:GetLastHits(self:GetPlayerID())
end

function Player:GetLeaks()
    return self.leaks or 0
end

function Player:GetEarnedTangos()
    return self.earnedTangos or 0
end

function Player:Reconnected()
    --self:SetPlayerEntitie(plyEntitie)
    --self.missedSpawns = 0
end

function Player:SetPlayerEntitie(plyEntitie, userID)
    GameRules:SetGoldPerTick(0)
    self.plyEntitie = plyEntitie
    self.userID = userID
    plyEntitie.myPlayer = self
    if self.lane and not self.abandoned then
        self.lane.isActive = true
    end
    for _, unit in pairs(self.units) do
        unit:GivePlayerControl()
    end
    --self.missedSpawns = 0
end


function Player:RemoveEntitie()
    print("User " .. self.userID .. " removed.")
    self.plyEntitie = nil

    -- why is this here
    self.userID = -1

    self.leaksPenalty = 25
    self.leaked = true
    if self.lane then
        self.lane.isActive = false
    end
end



--sets hero to player
function Player:SetNPC(npc)
    self.hero = npc
    print(self.hero:GetUnitName())
    print(self:GetFraction())
    self.playerID = self:GetPlayerID()
    npc.player = self
    self.teamnumber = self.hero:GetTeamNumber()
    print("new player set to team " .. self.teamnumber)
    local laneID = self.hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and 1 or 5
    if self.hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        laneID = 1
    else
        laneID = 5
    end
    while Game.lanes["" .. laneID].isUsed do
        laneID = laneID + 1
        if not Game.lanes["" .. laneID] then
            print("FUUUUUUU...")
            break
        end
    end

    self.lane = Game.lanes["" .. laneID]
    self.lane.player = self
    self.lane.isUsed = true
    self.lane.isActive = true
    self:PrepareBuilding(self.lane.mainBuilding)
    self:PrepareBuilding(self.lane.foodBuilding)

    --skill abilities
    for i = 0, self.hero:GetAbilityCount() - 2 do
        local ability = self.hero:GetAbilityByIndex(i)
        if ability then
            ability:SetLevel(1)
            ability.player = self
        end
    end
    self.hero:SetAbilityPoints(0)

    --prepartaion

    self.tangoCheckingTimer = Timers:CreateTimer(0, function()
        self:CreateTangoTicker()
        return CHECKING_INTERVALL
    end)

    npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
    Timers:CreateTimer(0.2, function()
        self:ToSpawn()
    end)
    self:RefreshPlayerInfo()
end


--checks tangos
function Player:HasEnoughTangos(amount)
    if self.abandoned then return false end
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
    for _, unit in pairs(self.units) do
        usedFood = usedFood + unit.foodCost
    end
    usedFood = usedFood + self.tangoAddAmount - START_TANGO_ADD_AMOUNT
    return usedFood
end


function Player:GetTowerValue()
    local result = 0
    for _, unit in pairs(self.units) do
        result = result + unit.goldCost
    end
    return result
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
    if (self.teamnumber) then
        return self.teamnumber
    end
    if self.plyEntitie == nil then return -1 end
    self.teamnumber = self.plyEntitie:GetTeamNumber()
    return self.plyEntitie:GetTeamNumber()
end


--get position before ancient
function Player:GetLastDef()
    return Game.lastDefends["" .. self:GetTeamNumber()]
end


--get position of incoming unit spawn
function Player:GetIncomeSpawner()
    return Game.incomeSpawner["" .. self:GetTeamNumber()]
end


--adds tangos
function Player:AddTangos(amount)
    self.tangos = self.tangos + amount
    self:RefreshPlayerInfo()
end

function Player:GetTangos()
    return self.tangos
end


--refreshs tango ui
function Player:RefreshPlayerInfo()
    if self.plyEntitie and not self.plyEntitie:IsNull() and self:GetPlayerID() then
        CustomGameEventManager:Send_ServerToAllClients("update_player_info", {
            playerID = self:GetPlayerID(),
            leaks = self.leaks,
            tangoCount = self.tangos,
            maxTangos = Game:GetTangoLimit(),
            goldIncome = self.income,
            tangoIncome = self:GetTangoIncomeIn(60),
            currentFood = self:GetUsedFood(),
            maxFood = self.foodlimit,
            towerValue = self:GetTowerValue()
        })
    end
end

function Player:GetTangoIncomeIn(time)
    return math.floor(self:GetTangoIncome() * time)
end

function Player:GetTangoIncome()
    return (self.tangoAddAmount / self.tangoAddSpeed)
end


function Player:Leaked(unit, level)
    self.leaked = true
    self.leaks = self.leaks + 1
    self.leaksPenalty = self.leaksPenalty + level
    self.leakedUnits[unit:GetUnitName()] = (self.leakedUnits[unit:GetUnitName()] or 0) + 1
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
function EnteredRiver(trigger)
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
    for i = 0, building:GetAbilityCount() do
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


function Player:HasAbandoned()
    return self.abandoned
end


function Player:CreateTangoTicker()
    if (not Timers.timers[self.timer]) and (self.lane.mainBuilding) and (Game:GetCurrentRound()) then

        self.timer = Timers:CreateTimer(function()

            if Game.gameState == GAMESTATE_PREPARATION and Game.gameRound == STARTING_ROUND then return (1 / 30) end
            if self.abandoned == true then return end
            if Game:GetCurrentRound().isDuelRound then return end

            local tangoDelay = self.tangoAddSpeed
            if self.leaked then tangoDelay = self.tangoAddSpeed + (self.tangoAddSpeed * LEAKED_TANGO_MULTIPLIER * self.leaksPenalty) end
            if self.tangos > Game:GetTangoLimit() and Game:GetTangoLimit() > -1 then tangoDelay = tangoDelay * 5 end -- slow down production while over the maximum
            self.tangoAddProgress = self.tangoAddProgress + 1 / tangoDelay / 30
            local i = self.tangoAddProgress * math.pi * 2
            if self.lane.mainBuilding:GetAbsOrigin().y > 0 then
                i = i + math.pi
            end
            self.lane.mainBuilding:SetForwardVector(Vector(math.sin(i), math.cos(i), 0))

            if self.tangoAddProgress > 1 then
                self.tangoAddProgress = self.tangoAddProgress - 1
                PopupHealing(self.lane.mainBuilding, self.tangoAddAmount)
                self:IncomeTangos(self.tangoAddAmount)
            end

            return (1 / 30)
        end)
    end
end

function my_round(num, idp)
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Player:IncomeTangos(amount)
    amount = my_round(amount)
    self.earnedTangos = (self.earnedTangos or 0) + amount
    self:AddTangos(amount)
end


function Player:SendErrorCode(code)
    if self.plyEntitie then
        CustomGameEventManager:Send_ServerToPlayer(self:GetPlayer(), "error", {
            errorCode = code,
            error = errorStrings[code]
        })
    end
end



function Player:IsActive()
    return self.lane and self.lane.isActive
end

function Player:Abandon()
    print("abandoning player on team " .. self.teamnumber)
    local goldValue = PlayerResource:GetGold(self:GetPlayerID()) -- gold in pocket
    print("abandoning player had " .. goldValue .. " gold in pocket")
    goldValue = goldValue + (self.buildingUpgradeValue / 2) -- gold in building upgrades
    print("plus building upgrades: " .. goldValue)
    for _, unit in pairs(self.units) do -- gold in built units
        goldValue = goldValue + unit.goldCost
        unit:RemoveNPC()
    end
    self.units = {}
    print("plus units: " .. goldValue)
    distributePlayers = {}
    for _, player in pairs(Game.players) do
        if player:IsActive() == true and player.teamnumber == self.teamnumber then
            print("player " .. player:GetPlayerID() .. " (teamnumber " .. player.teamnumber .. ") is eligible!")
            table.insert(distributePlayers, player)
        end
    end
    goldEach = math.floor(goldValue / #distributePlayers)
    PlayerResource:SetGold(self:GetPlayerID(), 0, true)
    PlayerResource:SetGold(self:GetPlayerID(), 0, false)
    self.income = 0
    self.abandoned = true
end

function Player:WantsToSkip()
    if not self:IsActive() then return false end
    return self.wantsSkip or false
end
