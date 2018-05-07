require("experience")
require("playerdata")
require("notifications")

if Game == nil then
    Game = class({})
end

--Spielstati
GAMESTATE_PREPARATION = 0
GAMESTATE_FIGHTING = 1
GAMESTATE_END = 2
STARTING_ROUND = 1
CHECKING_INTERVALL = 1

--Neues Spiel
function Game.new()
    local self = Game()
    Game = self
    self.storage = require("libs/storage")
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(Game, 'OnNPCSpawned'), self)
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(Game, 'OnConnectFull'), self)
    ListenToGameEvent('player_reconnected', Dynamic_Wrap(Game, 'OnPlayerReconnect'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(Game, 'OnPlayerDisconnect'), self)
    self.players = {}
    self.playerDatas = {}
    self.sendRadiant = {}
    self.sendDire = {}
    self.sendLeaderRadiant = 1 -- we'll rotate who gets the biggest send each wave
    self.sendLeaderDire = 1 -- we'll rotate who gets the biggest send each wave
    self.endOfRoundListeners = {}
    self.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    self.DamageKV = LoadKeyValues("scripts/damage_table.kv")
    self.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
    self.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    self.EnglishLocalizationKV = LoadKeyValues("resource/addon_english.txt")
    GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(Game, "DamageFilter"), Game)
    GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(Game, "OrderFilter"), Game)
    
    LinkLuaModifier("modifier_attack_arcane_lua", "abilities/damage/modifier_attack_arcane_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_attack_normal_lua", "abilities/damage/modifier_attack_normal_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_attack_pierce_lua", "abilities/damage/modifier_attack_pierce_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_defend_heavy_lua", "abilities/damage/modifier_defend_heavy_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_defend_medium_lua", "abilities/damage/modifier_defend_medium_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_defend_light_lua", "abilities/damage/modifier_defend_light_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_king_duel_lua", "abilities/modifier_king_duel_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_unit_freeze_lua", "abilities/modifier_unit_freeze_lua.lua", LUA_MODIFIER_MOTION_NONE)
    
    if Convars:GetBool('developer') then
        Convars:RegisterCommand("start_next_round", Dynamic_Wrap(self, "StartNextRoundCommand"), "keine Ahnung", 0)
        Convars:RegisterCommand("start_prev_round", Dynamic_Wrap(self, "StartPreviousRoundCommand"), "keine Ahnung", 0)
        Convars:RegisterCommand("restart_round", Dynamic_Wrap(self, "RestartRoundCommand"), "keine Ahnung", 0)
        Convars:RegisterCommand("reset", Dynamic_Wrap(self, "RestartCommand"), "keine Ahnung", 0)
        Convars:RegisterCommand("wiki", Dynamic_Wrap(self, "WikiCommand"), "no idea", 0)
    end
    
    CustomGameEventManager:RegisterListener("send_unit", Dynamic_Wrap(Game, "SendUnit"))
    CustomGameEventManager:RegisterListener("upgarde_king", Dynamic_Wrap(Game, "UpgradeKing"))
    CustomGameEventManager:RegisterListener("vote_option_clicked", Dynamic_Wrap(Game, "VoteOptionClicked"))
    CustomGameEventManager:RegisterListener("skip_pressed", Dynamic_Wrap(Game, "SkipPressed"))
    CustomGameEventManager:RegisterListener("request_stored_data", Dynamic_Wrap(Game, "RequestStoredData"))
    CustomGameEventManager:RegisterListener("request_ranking", Dynamic_Wrap(Game, "RequestRanking"))
    CustomGameEventManager:RegisterListener("request_ranking_position", Dynamic_Wrap(Game, "RequestRankingPosition"))
    CustomGameEventManager:RegisterListener("request_match_history", Dynamic_Wrap(Game, "RequestMatchHistory"))
    
    GameRules:SetSafeToLeave(false)
    GameRules:SetStrategyTime(0)
    GameRules:SetHeroSelectionTime(45)
    return self
end



--List alle Informationen ein
function Game:ReadConfiguration()
    local kv = LoadKeyValues("scripts/maps/" .. GetMapName() .. ".txt")
    if not kv then
        print("Map informations are missing!")
        return
    end
    self.initPrepTime = kv.FirstPrepTime
    self.timeBetweenRounds = kv.PrepTimeBetweenRounds
    self.timeBeforeDuel = kv.PrepTimeBeforeDuel
    self:ReadLastSpawn(kv["LastSpawn"])
    self:ReadLastSpawnRanged(kv["LastSpawnRanged"])
    self:ReadIncomeSpawner(kv["IncomeSpawner"])
    self:ReadDuelSpawn(kv["DuelSpawn"])
    self:ReadDuelTargets(kv["DuelTarget"])
    self:ReadLanes(kv["Lanes"])
    self:ReadRoundConfiguration(kv)
    self.radiantBoss = Entities:FindByName(nil, "radiant_king")
    self.direBoss = Entities:FindByName(nil, "dire_king")
    print("everything loaded")
end



function Game:ReadDuelSpawn(kvDue)
    self.duelSpawn = {}
    if not (type(kvDue) == "table") then
        return
    end
    for ind, sp in pairs(kvDue) do
        local obj = Entities:FindByName(nil, sp.Name)
        if obj then
            self.duelSpawn[ind] = obj
        else
            print(sp.Name .. " not found.")
        end
    end
end



function Game:ReadDuelTargets(kvDuet)
    self.duelTargets = {}
    if not (type(kvDuet) == "table") then
        return
    end
    for ind, sp in pairs(kvDuet) do
        local obj = Entities:FindByName(nil, sp.Name)
        if obj then
            self.duelTargets[ind] = obj
        else
            print(sp.Name .. " not found.")
        end
    end
end



function Game:ReadIncomeSpawner(kvInc)
    self.incomeSpawner = {}
    if not (type(kvInc) == "table") then
        return
    end
    for ind, sp in pairs(kvInc) do
        local obj = Entities:FindByName(nil, sp.Name)
        if obj then
            self.incomeSpawner[ind] = obj
        else
            print(sp.Name .. " not found.")
        end
    end
end


--List Punkte für die letzte Verteidigung ein
function Game:ReadLastSpawn(kvLast)
    self.lastDefends = {}
    if type(kvLast) ~= "table" then
        return
    end
    for ind, sp in pairs(kvLast) do
        local obj = Entities:FindByName(nil, sp.Name)
        if obj then
            self.lastDefends[ind] = obj
        else
            print(sp.Name .. " not found.")
        end
    end
end

function Game:ReadLastSpawnRanged(kvLastR)
    self.lastDefendsRanged = {}
    if type(kvLastR) ~= "table" then
        return
    end
    for ind, sp in pairs(kvLastR) do
        local obj = Entities:FindByName(nil, sp.Name)
        if obj then
            self.lastDefendsRanged[ind] = obj
        else
            print(sp.Name .. " not found.")
        end
    end
end



--List Spawnpunkte ein
function Game:ReadLanes(kvSpawns)
    self.lanes = {}
    if type(kvSpawns) ~= "table" then
        return
    end
    for ind, sp in pairs(kvSpawns) do
        local lbox = Entities:FindByName(nil, sp.Box)
        local lspawn = Entities:FindByName(nil, sp.SpawnerName)
        local lwaypoint = Entities:FindByName(nil, sp.Waypoint)
        local lnextWaypoint = Entities:FindByName(nil, sp.NextWaypoint)
        local lmidWaypoint = Entities:FindByName(nil, sp.MidWaypoint)
        local lheroSpawn = Entities:FindByName(nil, sp.HeroSpawn)
        local lunitWaypoint = Entities:FindByName(nil, sp.UnitWaypoint)
        local lmainBuilding = Entities:FindByName(nil, sp.MainBuilding)
        local lfoodBuilding = Entities:FindByName(nil, sp.FoodBuilding)
        local llastWaypoint = Entities:FindByName(nil, sp.LastWaypoint)
        if lspawn and lwaypoint and lheroSpawn and lunitWaypoint and lbox
            and lfoodBuilding and lmainBuilding and lnextWaypoint and llastWaypoint then
            print("Lane " .. ind .. " found.")
            self.lanes[ind] = {
                spawnpoint = lspawn,
                waypoint = lwaypoint:GetAbsOrigin(),
                nextWaypoint = lnextWaypoint:GetAbsOrigin(),
                midWaypoint = lmidWaypoint:GetAbsOrigin(),
                lastWaypoint = llastWaypoint:GetAbsOrigin(),
                waypoints = {lwaypoint:GetAbsOrigin(), lnextWaypoint:GetAbsOrigin(), lmidWaypoint:GetAbsOrigin(), llastWaypoint:GetAbsOrigin() },
                heroSpawn = lheroSpawn,
                unitWaypoint = lunitWaypoint,
                box = lbox,
                unitBuilding = lunitBuilding,
                unitBuilding2 = lunitBuilding2,
                mainBuilding = lmainBuilding,
                foodBuilding = lfoodBuilding,
            }
        end
    end
end



function Game:ReadRoundConfiguration(kv)
    self.rounds = {}
    self.doneDuels = 0
    self.lastWaveCount = 0
    local duelRoundCount = 0
    local i = 1
    while true do
        local roundData = kv["Rounds"][tostring(i)]
        if not roundData then break end
        
        local roundType = roundData["round_type"]
        local roundObj
        
        if roundType == "wave" then
            roundObj = GameRound()
            roundObj:ReadRoundConfiguration(roundData, self, self:GetRoundCount() + 1 - duelRoundCount)
        elseif roundType == "duel" then
            roundObj = DuelRound.new(roundData, self, self:GetRoundCount() + 1)
            duelRoundCount = duelRoundCount + 1
        else
            print("FATAL ERROR: Reading rounds, could not read round type")
            return
        end
        
        table.insert(self.rounds, roundObj)
        
        print("Round " .. i .. " loaded: " .. roundType)
        i = i + 1
    end
end



function Game:GetRoundCount()
    return table.count(self.rounds)
end



function Game:GetDisplayRound()
    return self.gameRound - self.doneDuels - self.lastWaveCount
end



function Game:GetTangoLimit()
    if (voteOptions["tango_limit"]) then
        return START_TANGO_LIMIT + self.gameRound * TANGO_LIMIT_PER_ROUND
    end
    return -1
end

function Game:GetAllActivePlayer()
    local result = {}
    for _, player in pairs(self.players) do
        if player:IsActive() then
            result[_] = player
        end
    end
    return result
end


function Game:RandomHeroes()
    for _, player in pairs(self.players) do
        if not PlayerResource:HasSelectedHero(player:GetPlayerID()) then
            player.plyEntitie:MakeRandomHeroSelection()
        end
    end
end

--Start des Spiels
function Game:Start()
    print("Game:Start()")
	Notifications:TopToAll({text="<b color='red'>Remember:</b> <b color='white'>If you find any bug, please report it to the Discord.</b> ", duration=10.0})
    self.radiantKingVision = CreateUnitByName("king_vision_dummy", self.radiantBoss:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
    self.direKingVision = CreateUnitByName("king_vision_dummy", self.direBoss:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
    self.gridBoxes = Entities:FindByName(nil, "gridboxes")
    self.gameRound = STARTING_ROUND
    self.isRunning = true
    self:SetGameState(GAMESTATE_PREPARATION)
    Timers:CreateTimer(0, function()
        for _, player in pairs(self.players) do
            player:RefreshPlayerInfo()
        end
    end)
    self.radiantBoss.healthBonus = START_HEALTH_BONUS
    self.radiantBoss.damageBonus = START_DAMAGE_BONUS
    self.radiantBoss.regenBonus = START_BONUS_REGEN
    self.direBoss.healthBonus = START_HEALTH_BONUS
    self.direBoss.damageBonus = START_DAMAGE_BONUS
    self.direBoss.regenBonus = START_BONUS_REGEN
    CheckVoteResults()
    self:CreateGameTimer()
    -- GameRules:GetGameModeEntity():SetThink("OnThink", self, "Check", 0)
    self:Initialize()
    self:SaveMatchAtEnd()
    self:SaveDataAtEnd()
    
    if Convars:GetBool('developer') then
        Game:UpdateAbilityData()
        Game:UpdateUnitData()
        Game:UpdateBuilderData()
    end
end

function Game:CreateGameTimer()
    if not self.gameTimer then
        self.gameTimer = Timers:CreateTimer(0, function()
            return self:OnThink()
        end)
        self.countDownTimer = Timers:CreateTimer(1, function()
            if (self.nextRoundTime) then
                CustomGameEventManager:Send_ServerToAllClients("update_countdown", {betweenRounds = Game:IsBetweenRounds(), seconds = Game:GetRemainingBuildingTime()})
            else
                CustomGameEventManager:Send_ServerToAllClients("update_countdown", {betweenRounds = Game:IsBetweenRounds(), seconds = -1})
            end
            return 1
        end)
    end
end

function Game:GetRemainingBuildingTime()
    if (self.gameState ~= GAMESTATE_PREPARATION) then
        return 0
    end
    return Game.nextRoundTime - GameRules:GetGameTime()
end



--Wird jede viertel Sekunde aufgerufen, überprüft Spielstatus
function Game:OnThink()
    self:CheckPlayerAbandon()
    if self.gameState == GAMESTATE_PREPARATION then
        --festlegung der vorbereitungszeit
        if self.nextRoundTime <= GameRules:GetGameTime() then
            self:StartNextRound()
        end
    end
    if self.gameState == GAMESTATE_FIGHTING then
        self.rounds[self.gameRound]:CheckEnd()
    end
    if self.gameState == GAMESTATE_END then
        end
    return 0.25
end

function Game:SetGameState(newState)
    local oldState = self.gameState
    self.gameState = newState
    if self.gameState == GAMESTATE_PREPARATION then
        self:SetNextRoundTime()
    end
    if self.gameState ~= self.oldState then
        self:SendRoundChanged()
    end
end

function Game:SetNextRoundTime()
    if not self.finishedWaves then
        self:SetWaitTime()
    else
        self:ResetUnitPositions()
        self:StartNextRound()
    end
end


function Game:CheckPlayerAbandon()
    for _, player in pairs(self.players) do
        if player.calledAbandon == false and (player.missedSpawns >= 3 or PlayerResource:GetConnectionState(player:GetPlayerID()) == DOTA_CONNECTION_STATE_ABANDONED) then
            player.calledAbandon = true
            GameRules:SendCustomMessage("<p color='red'>" .. PlayerResource:GetPlayerName(player:GetPlayerID()) .. " abandoned the game.</p>")
        end
    end
end


function Game:ResetSkip()
    for _, player in pairs(self.players) do
        player.wantsSkip = false
    end
end

function Game:SendRoundChanged()
    CustomGameEventManager:Send_ServerToAllClients("round_changed", {
        round = self.gameRound,
        displayRound = self:GetDisplayRound(),
        isDuel = self:GetCurrentRound().isDuelRound == true,
        state = self.gameState,
        nextRoundTime = self.nextRoundTime,
    });
end

--Setzt die Zeit zum warten zur nächsten Runde
function Game:SetWaitTime()
    Game:ResetSkip()
    
    local waitTime = self.timeBetweenRounds
    if self.gameRound == 1 then
        waitTime = self.initPrepTime
    end
    if self.rounds[self.gameRound].isDuelRound then
        waitTime = self.timeBeforeDuel
    end
    self.nextRoundTime = GameRules:GetGameTime() + waitTime
    
    self:RespawnUnits()
    print("Time to next Round: " .. waitTime)
end



--Runde beendet
function Game:RoundFinished()
    self.gridBoxes:RemoveEffects(EF_NODRAW)
    if not self.gameTimer then
        self:CreateGameTimer()
    end
    for _, listener in pairs(self.endOfRoundListeners) do
        pcall(listener)
    end
    
    self.IncreaseRound()
    self:SetGameState(GAMESTATE_PREPARATION)
    for _, player in pairs(self.players) do
        player.tangoLimit = self:GetTangoLimit()
    end
end



function Game:GetCurrentRound()
    return self.rounds[self.gameRound]
end



--Startet nächste Runde
function Game:StartNextRound()
    self:CheckTeamLeft(DOTA_TEAM_GOODGUYS)
    self:CheckTeamLeft(DOTA_TEAM_BADGUYS)
    print "Game:StartNextround()"
    for _, player in pairs(self.players) do
        if player:IsActive() then --only repair leaks if lane is active
            player.leaked = false;
            player.leaksPenalty = 0;
        end
        if player.lane and not player.lane.isActive then
            player.missedSpawns = player.missedSpawns + 1
        end
        if not player.abandoned then
            if player.missedSpawns >= 3 or PlayerResource:GetConnectionState(player:GetPlayerID()) == DOTA_CONNECTION_STATE_ABANDONED then
                player:Abandon()
            end
        end
        if voteOptions["tango_limit"] and player.tangos > self:GetTangoLimit() then
            player.tangos = self:GetTangoLimit()
        end
    end
    if voteOptions["fog_of_war"] then
        mode:SetFogOfWarDisabled(true)
    end
    self.gridBoxes:AddEffects(EF_NODRAW)
    self.nextRoundTime = nil
    self.rounds[self.gameRound]:Begin()
    print "Game:StartNextround() about to call self:UnlockUnits()"
    self:UnlockUnits()
    self:SetGameState(GAMESTATE_FIGHTING)
end

function Game:CheckTeamLeft(team)
    local isEmpty = true
    for _, player in pairs(self.players) do
        if (player:GetTeamNumber() == team) then
            isEmpty = false
            if (not player:HasAbandoned()) then
                return
            end
        end
    end
    if isEmpty then
        return
    end
    local winner = DOTA_TEAM_GOODGUYS
    if team == DOTA_TEAM_GOODGUYS then
        winner = DOTA_TEAM_BADGUYS
    end
    GameRules:SetGameWinner(winner)
    GameRules:Defeated()
end



--Checkt ob gerade keine Runde läuft
function Game:IsBetweenRounds()
    return self.gameState == GAMESTATE_PREPARATION
end



--Überprüft ob Einheit hier gespawnt werden kann
function Game:CanSpawn(caster, vector)
    local CHECKINGRADIUS = 30
    local result = 2
    for _, ent in pairs(Entities:FindAllInSphere(vector, CHECKINGRADIUS)) do
        if ent.unit and ent:IsAlive() then
            return LEGION_ERROR_TO_CLOSE
        end
        if ent == caster.player.lane.box then
            result = LEGION_ERROR_NOT_ENOUGH_TANGOS
        end
    end
    return result
end



--Sorgt dafür dass die Zeit aktualisiert Wird
function Game:Initialize()
    if (voteOptions["fog_of_war"]) then
        mode:SetFogOfWarDisabled(false)
    end
    Timers:CreateTimer(0, function()
        GameRules:SetTimeOfDay(0.26)-- always day!
        return 1
    end)
end


--NPC gespawnt, falls spieler in die Liste eintragen
function Game:OnNPCSpawned(key)
    local npc = EntIndexToHScript(key.entindex)
    if npc.firstSpawned == nil then
        npc.firstSpawned = true
        if npc:IsRealHero() then
            for _, player in pairs(self.players) do
                if player:GetPlayerID() == npc:GetPlayerID() then
                    -- local ltext = "ID:"..npc:GetPlayerID()
                    -- CustomGameEventManager:Send_ServerToPlayer(player:GetPlayer(), "debug", {text = ltext})
                    player:SetNPC(npc)
                    return
                end
            end
        else -- not a hero
            if Game.UnitKV[npc:GetUnitName()] then
                local attack_type = Game.UnitKV[npc:GetUnitName()]["LegionAttackType"] or "none"
                local defend_type = Game.UnitKV[npc:GetUnitName()]["LegionDefendType"] or "none"
                --print ("unit spawned with " .. attack_type .. "/" .. defend_type)
                npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type .. "_lua", {})
                npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type .. "_lua", {})
            end
        end
    end
end



function Game:OnConnectFull(keys)
    local entIndex = keys.index + 1
    local ply = EntIndexToHScript(entIndex)
    local playerID = ply:GetPlayerID()
    if not PlayerResource:IsBroadcaster(playerID) then
        local player = self:FindPlayerWithID(playerID)
        if player then
            print("Game:OnConnectFull(): Player object found for existing player.")
            player:SetPlayerEntity(ply, keys.userid)
        else
            print("Game:OnConnectFull(): Player object not found for player entIndex " .. entIndex .. " playerID " .. playerID .. "; Creating.")
            local newPlayer = Player.new(ply, keys.userid)
            self.players[keys.userid] = newPlayer
        end
    end
    
    for _, p in pairs(self.players) do
        local data = {
            playerID = p:GetPlayerID(),
            steamID = p:GetSteamID()
        }
        self:RequestStoredData(data)
    end
end


function Game:OnPlayerReconnect(keys)
    local entIndex = keys.index + 1
    local ply = EntIndexToHScript(entIndex)
    local playerID = ply:GetPlayerID()
    if not PlayerResource:IsBroadcaster(playerID) then
        local player = self:FindPlayerWithID(playerID)
        if player then
            player:SetPlayerEntity(ply, keys.userid)
        else
            print("Who reconnected?! " .. playerID)
        end
    end
end



function Game:OrderFilter(keys)
    local order = keys.order_type
    local unit = EntIndexToHScript(keys.units["0"])
    local units = {}
    for _, key in pairs(keys.units) do
        table.insert(units, EntIndexToHScript(key))
    end
    
    local issuingPlayer = self:FindPlayerWithID(keys.issuer_player_id_const)
    if issuingPlayer then
        if issuingPlayer.abandoned == true then return false end
    end
    
    if order == DOTA_UNIT_ORDER_HOLD_POSITION then
        for _, u in pairs(units) do
            if u.unit then
                return false
            end
        end
    end
    
    
    local player = nil
    if unit then
        player = unit.player
    end
    
    
    local ability = EntIndexToHScript(keys.entindex_ability)
    -- if it is an ability
    if ability then
        -- if it is MY ability
        if ability.player then
            player = ability.player
        else
            if ability:GetOwner() and ability:GetOwner().player then
                player = ability:GetOwner().player
            else
                return true
            end
        end
        local tangoCost = ability:GetSpecialValueFor("tango_cost")
        local foodCost = ability:GetSpecialValueFor("food_cost")
        --Does it have FoodCost?
        if foodCost then
            if not player then
                return false
            end
            if not player:HasEnoughFood(foodCost) then
                player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_FOOD)
                return false
            end
        end
        --DOes it have tangoCost
        if tangoCost then
            if not player then
                return false
            end
            if not player:SpendTangos(tangoCost) then
                player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_TANGOS)
                return false
            end
        end
        
        --Tower Special Case
        if string.find(ability:GetName(), "spawn") then
            --between rounds?
            if not self:IsBetweenRounds() then
                if player then
                    player:SendErrorCode(LEGION_ERROR_BETWEEN_ROUNDS)
                end
                return false
            end
            --quantize the target position to grid square centers
            keys.position_x = round(keys.position_x, 64) + 32
            keys.position_y = round(keys.position_y, 64) + 32
            --valid location?
            local vector = Vector(keys.position_x, keys.position_y, keys.position_z)
            local canSpawn = self:CanSpawn(ability:GetCaster(), vector)
            if not (canSpawn == LEGION_ERROR_NOT_ENOUGH_TANGOS) then
                if player then
                    player:SendErrorCode(canSpawn)
                    if canSpawn == LEGION_ERROR_INVALID_LOCATION then
                        local pos = player.lane.box:GetAbsOrigin()
                        MinimapEvent(player:GetTeamNumber(), player.hero, pos.x, pos.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 1)
                    end
                end
                return false
            end
        end
    end
    --all other orders
    return true
end


function Game:FindPlayerWithSteamID(steamID)
    for _, player in pairs(self.players) do
        if tostring(player:GetSteamID()) == tostring(steamID) then
            return player
        end
    end
    return nil
end


function Game:GetAllPlayersOfTeam(id)
    local result = {}
    for _, player in pairs(self.players) do
        if (player:GetTeamNumber() == id) then
            table.insert(result, player)
        end
    end
    return result
end


function Game:FindPlayerWithID(id)
    for _, player in pairs(self.players) do
        if player:GetPlayerID() == id then
            return player
        end
    end
    return nil
end



function Game:OnPlayerDisconnect(key)
    for ind, player in pairs(self.players) do
        if player.userID == key.userid then
            player:RemoveEntitie()
        end
    end
end


--sends a unit
function Game:SendUnit(data)
    local lData = {
        id = data.id,
        playerID = data.playerID,
        income = data.income,
        cost = data.cost
    }
    local player = Game:FindPlayerWithID(lData.playerID)
    if not player then return end
    if player:SpendTangos(lData.cost) then
        player:AddIncome(lData.income)
        local spawn = player:GetIncomeSpawner():GetAbsOrigin()
        local team = player:GetTeamNumber()
        local name = Unit:GetUnitNameByID(lData.id)
        player:SendUnit(name)
        local unit = CreateUnitByName(name, spawn, true, nil, nil, team)
        unit.tangoValue = lData.cost
        unit:AddNewModifier(nil, nil, "modifier_invulnerable", {})
        unit:AddNewModifier(nil, nil, "modifier_unit_freeze_lua", {})
        WaveSpawner.ApplyHardMode(unit)
        local sendFromRadiant = false
        if team == DOTA_TEAM_GOODGUYS then
            sendFromRadiant = not sendFromRadiant
        end
        if voteOptions["return_to_sender"] then
            sendFromRadiant = not sendFromRadiant
        end
        if sendFromRadiant then
            print("adding unit to Game.sendRadiant")
            table.insert(Game.sendRadiant, unit)
            if #Game.sendRadiant > MAX_SENDS then
                Game:LimitSends(Game.sendRadiant)
            end
        else
            print("adding unit to Game.sendDire")
            table.insert(Game.sendDire, unit)
            if #Game.sendDire > MAX_SENDS then
                Game:LimitSends(Game.sendDire)
            end
        end
    else
        player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_TANGOS)
    end
end

function Game:LimitSends(units)
    local lowestUnit = units[1]
    local lowestIndex = 1
    for i, unit in pairs(units) do
        if unit.tangoValue < lowestUnit.tangoValue then
            lowestUnit = unit
            lowestIndex = i
        end
    end
    units[lowestIndex]:ForceKill(false)
    table.remove(units, lowestIndex)
end




function Game:UpgradeKing(data)
    local lData = {
        id = data.id,
        type = data.type,
        cost = data.cost,
        income = data.income
    }
    local player = Game:FindPlayerWithID(lData.id)
    if not player then return end
    if Game.noUpgrade then player:SendErrorCode(LEGION_ERROR_DURING_DUEL) return end
    if player:HasEnoughTangos(lData.cost) then
        local boss = Game.radiantBoss
        if player:GetTeamNumber() == DOTA_TEAM_BADGUYS then
            boss = Game.direBoss
        end
        if lData.type == 0 then
            if not Game:UpgradeKingsHealth(boss) then player:SendErrorCode(LEGION_ERROR_TO_MANY_UPGRADES) return end
        elseif lData.type == 1 then
            if not Game:UpgradeKingsAttack(boss) then player:SendErrorCode(LEGION_ERROR_TO_MANY_UPGRADES) return end
        elseif lData.type == 2 then
            if not Game:UpgradeKingsRegen(boss) then player:SendErrorCode(LEGION_ERROR_TO_MANY_UPGRADES) return end
        end
        player:AddIncome(lData.income)
        player:SpendTangos(lData.cost)
    else
        player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_TANGOS)
    end
end




function Game:UpgradeKingsHealth(king)
    if IncreaseStack(king, "boss_upgrade_health_stack") then
        king:SetMaxHealth(king:GetMaxHealth() + king.healthBonus)
        king:SetBaseMaxHealth(king:GetBaseMaxHealth() + king.healthBonus)
        king:Heal(king.healthBonus, nil)
        king.healthBonus = king.healthBonus + HEALTH_BONUS_ADD
        return true
    end
    return false
end




function Game:UpgradeKingsAttack(king)
    if IncreaseStack(king, "boss_upgrade_attack_stack") then
        king:SetBaseDamageMin(king:GetBaseDamageMin() + king.damageBonus)
        king:SetBaseDamageMax(king:GetBaseDamageMax() + king.damageBonus)
        king.damageBonus = king.damageBonus + DAMAGE_BONUS_ADD
        return true
    end
    return false
end




function Game:UpgradeKingsRegen(king)
    if IncreaseStack(king, "boss_upgrade_regen_stack") then
        king:SetBaseHealthRegen(king:GetBaseHealthRegen() + king.regenBonus)
        king.regenBonus = king.regenBonus + REGEN_BONUS_ADD
        return true
    end
    return false
end


function Game:VoteOptionClicked(data)
    local lData = {
        option = data.option,
        playerID = data.playerID,
        value = data.value
    }
    local player = Game:FindPlayerWithID(lData.playerID)
    player["wants" .. lData.option] = lData.value
    print(lData.playerID .. " voted for " .. lData.option .. " with " .. lData.value)
    UpdateVoteLabel(lData.option)
end

function Game:SkipPressed(data)
    local lData = {
        playerID = data.playerID
    }
    local player = Game:FindPlayerWithID(lData.playerID)
    player.wantsSkip = true
    print(lData.playerID .. " wants to skip waiting time.")
    
    Game:FormatSkipMessage(Game:CountSkipvotes(), Game:CountRemainingPlayers())
    Game:CheckSkip()
end

function Game:CountSkipvotes()
    local result = 0
    for _, player in pairs(self.players) do
        if player:WantsToSkip() then
            result = result + 1
        end
    end
    return result
end

function Game:CountRemainingPlayers()
    local count = 0
    for _, player in pairs(self.players) do
        if player:IsActive() then
            count = count + 1
        end
    end
    return count
end

function Game:FormatSkipMessage(votes, remaining)
    local message = ""
    if votes == 1 then
        message = "<b color='LawnGreen'>" .. votes .. " player</b> <b color='white'>is ready for the next round.</b><b color='LawnGreen'> " .. remaining .. " votes</b> <b color='white'>needed.</b>"
    else
        message = "<b color='LawnGreen'>" .. votes .. " players</b> <b color='white'>are ready for the next round.</b><b color='LawnGreen'> " .. remaining .. " votes</b> <b color='white'>needed.</b>"
    end
    GameRules:SendCustomMessage(message, 0, 0)
end

function Game:CheckSkip()
    for _, player in pairs(self.players) do
        if player:IsActive() and not player:WantsToSkip() then
            return
        end
    end
    Game:SkipWait()
end

function IncreaseStack(king, modifier)
    local bossAbility = king:GetAbilityByIndex(0)
    local stackCounter = king:FindModifierByName(modifier)
    if not stackCounter then
        stackCounter = bossAbility:ApplyDataDrivenModifier(king, king, modifier, nil)
    end
    if stackCounter:GetStackCount() >= MAX_KING_UPGRADES then
        return false
    end
    stackCounter:IncrementStackCount()
    return true
end


function Game:IncreaseRound()
    Game.gameRound = Game.gameRound + 1;
    if (Game.gameRound > Game:GetRoundCount()) then
        Game.gameRound = Game.gameRound - 1
        Game.lastWaveCount = Game.lastWaveCount + 1
        Game.finishedWaves = true
    else
        if (Game.rounds[Game.gameRound].isDuelRound and voteOptions["deactivate_duels"]) then
            Game:IncreaseRound()
            Game.doneDuels = Game.doneDuels + 1
        end
    end
end



function Game:RecountDuels()
    local duelCount = 0
    local i = 1
    while i < self.gameRound do
        if self.rounds[tonumber(i)].isDuelRound then
            duelCount = duelCount + 1
        end
        i = i + 1
    end
    self.doneDuels = duelCount
    print("Recounted duels")
end



function Game:SetRound(i)
    local curRound = self:GetCurrentRound()
    self.gameRound = i
    self:RecountDuels()
    self.gameRound = i - 1
    curRound:End()
    self:OnThink()
    self:SkipWait()
    print("Set round to " .. i)
end



function Game:StartNextRoundCommand()
    if Game.gameState == GAMESTATE_PREPARATION then
        Game:SkipWait()
    elseif Game.gameState == GAMESTATE_FIGHTING then
        Game:SetRound(Game.gameRound + 1)
    end
end



function Game:RestartRoundCommand()
    Game:SetRound(Game.gameRound)
end



function Game:StartPreviousRoundCommand()
    Game:SetRound(Game.gameRound - 1)
end



function Game:RestartCommand()
    Game:SetRound(1)
end



function Game:StopRound()
    if Game.gameState == GAMESTATE_FIGHTING then
        Game:GetCurrentRound():End()
    end
end



function Game:ClearBoard()
    for _, round in pairs(self.rounds) do
        if not round.isDuelRound then
            round:KillAll()
        end
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Alle Einheiten respawnen
function Game:RespawnUnits()
    for _, player in pairs(self.players) do
        for __, unit in pairs(player.units) do
            unit:Respawn()
        end
    end
end

--Alle Einheiten zum Spawnpunkt
function Game:ResetUnitPositions()
    for _, player in pairs(self.players) do
        if player:IsActive() then
            for __, unit in pairs(player.units) do
                unit:ResetPosition()
            end
        end
    end
end

--Einheiten machen was
function Game:UnlockUnits()
    print "Doing Game:UnlockUnits()"
    for _, player in pairs(self.players) do
        if player:ShouldSpawn() then
            for __, unit in pairs(player.units) do
                unit:Unlock()
            end
        end
    end
end

--Tötet Einheiten
function Game:RemoveUnits()
    for _, player in pairs(self.players) do
        for __, unit in pairs(player.units) do
            unit:RemoveNPC()
        end
    end
end

--Stunt Einheiten
function Game:LockUnits()
    for _, player in pairs(self.players) do
        if player:IsActive() then
            for __, unit in pairs(player.units) do
                unit:Lock()
            end
        end
    end
end

--Respawnt Einheiten
function Game:SpawnUnits()
    for _, player in pairs(self.players) do
        if player:IsActive() then
            for __, unit in pairs(player.units) do
                unit:Spawn()
            end
        end
    end
end

function Game:SkipWait()
    if (self.nextRoundTime == nil) then
        return
    end
    if (not (self.nextRoundTime == nil)) then
        local missedTime = self.nextRoundTime - GameRules:GetGameTime()
        Game:DistributeMissedTangos(missedTime)
    end
    self.nextRoundTime = GameRules:GetGameTime()
end

function Game:DistributeMissedTangos(missedTime)
    for _, player in pairs(self.players) do
        player:IncomeTangos(player:GetTangoIncomeIn(missedTime))
    end
end



function Game:GetActivePlayerInTeam(team)
    local result = 0
    for _, player in pairs(Game.players) do
        if (player:GetTeamNumber() == team and player:ShouldSpawn()) then
            result = result + 1
        end
    end
    return result
end




function Game:CreatePlayerDataFor(playerID)
    local player = Game:FindPlayerWithID(playerID)
    if (player == nil) then return end
    PlayerData.CreateToPlayer(player, function(result, success)
        if success then
            Game:RequestStoredData({playerID = playerID, steamID = player:GetSteamID()})
        else
            print("Failure at creating new Playerdataset!")
        end
    end)
end

function Game:SendStoredData(playerID, steamID)
    local data = PlayerData.Get(steamID):GetToStoredData()
    data.steamID = steamID
    local player = Game:FindPlayerWithID(playerID)
    if (player == null) then
        Warning("StoredData: Cant find player " .. playerID .. "!")
        return
    end
    local plyEntitie = player.plyEntitie
    CustomGameEventManager:Send_ServerToPlayer(plyEntitie, "send_stored_data", data)
end

function Game:RequestStoredData(data)
    local lData = {
        playerID = data.playerID,
        steamID = data.steamID
    }
    local playerToSteamID = Game:FindPlayerWithSteamID(lData.steamID)
    Game.storage:GetPlayerData(lData.steamID, function(result, success)
        if success == false then
            Game:CreatePlayerDataFor(lData.playerID)
            return
        end
        PlayerData.AddOrUpdate(result, playerToSteamID, lData.steamID)
        Game:SendStoredData(lData.playerID, lData.steamID)
    end)
end

function Game:ConvertRankingData(data)
    local result = {}
    for k, val in pairs(data) do
        result[k] = {}
        result[k].steamId = val.steamId
        result[k].rank = val.rank
        result[k].data = PlayerData.NewWithoutSave(val.data, nil, val.steamId):GetToStoredData()
    end
    return result
end

function Game:RequestRanking(data)
    local lData = {
        playerID = data.playerID,
        attribute = data.attribute,
        from = data.from,
        to = data.to
    }
    Game.storage:GetRanking(lData.attribute, lData.from, lData.to, function(result, success)
        local sendData = Game:ConvertRankingData(result)
        sendData.count = table.count(sendData)
        sendData.attribute = lData.attribute
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(lData.playerID), "send_rankings", sendData)
    end)
end

function table.count(tab)
    local result = 0
    for k, v in pairs(tab) do
        result = result + 1
    end
    return result
end

function Game:RequestRankingPosition(data)
    local lData = {
        playerId = data.playerId,
        attribute = data.attribute,
        steamId = data.steamId,
    }
    Game.storage:GetRankingPosition(lData.attribute, lData.steamId, function(result)
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(lData.playerId), "send_ranking_position", result)
    end)
end

function Game:RequestMatchHistory(data)
    local lData = {
        playerId = data.playerId,
        steamId = data.steamId,
        from = data.from,
        to = data.to
    }
    Game.storage:GetMatchHistory(lData.steamId, lData.from, lData.to, function(result)
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(lData.playerId), "send_match_history", result)
    end)
end


function Game:UpdateUnitData()
    local data = {}
    for name,d in pairs(Game.UnitKV) do
        data[name] = d
        data[name].DisplayName = Game.EnglishLocalizationKV.Tokens[name] or name
        print(data[name].DisplayName)
    end
    Game.storage:UpdateUnitData(Game.UnitKV);
end


function Game:UpdateAbilityData()
    local data = {}
    for name,d in pairs(Game.AbilityKV) do
        data[name] = d
        data[name].DisplayName = Game.EnglishLocalizationKV.Tokens["DOTA_Tooltip_ability_"..name] or name
        print(data[name].DisplayName)
    end
    Game.storage:UpdateAbilityData(data);
end


function Game:UpdateBuilderData()
    local data = {}
    for name,d in pairs(Game.HeroKV) do
        data[name] = d
        data[name].DisplayName = Game.EnglishLocalizationKV.Tokens[name] or name
        print(data[name].DisplayName)
    end
    Game.storage:UpdateBuilderData(data);
end


function Game:SaveDataAtEnd()
    if GameRules:IsCheatMode() then return end
    HookSetWinnerFunction(function(gameRules, team)
        for _, player in pairs(self.players) do
            if player:GetTeamNumber() == team then
                player.wonGame = true
            else
                player.lostGame = true
            end
            local data = PlayerData.Get(player:GetSteamID()):GetToStoredData()
            self.storage:SavePlayerData(player:GetSteamID(), data)
        end
    end)
end

function Game:SaveMatchAtEnd()
    if GameRules:IsCheatMode() then return end
    HookSetWinnerFunction(function(gameRules, team)
        local matchData = {}
        for _, player in pairs(self.players) do
            matchData[player:GetSteamID()] = PlayerData.GetByPlayer(player):GetMatchData()
        end
        local duration = GameRules:GetGameTime()
        local wave = Game.gameRound + Game.lastWaveCount
        self.storage:SaveMatchData(team, duration, wave, matchData, DuelRound.doneRounds, function(response, success)
            print(success)
        end)
    end)
end

function Game:GetAllFractions()
    if Game.fractions ~= nil then return Game.fractions end
    Game.fractions = {}
    for _, unit in pairs(Game.UnitKV) do
        local fraction = unit.LegionFraction or "other"
        Game.fractions[fraction] = true
    end
    return Game.fractions
end

function Game:GetAllBuilders()
    self.heroList = self.heroList or LoadKeyValues("scripts/npc/herolist.txt")
    local result = {}
    for builder, data in pairs(self.HeroKV) do
        if (self.heroList[data.override_hero] or 0) ~= 0 then
            result[builder] = data.override_hero
        end
    end
    return result
end

function HookSetWinnerFunction(callback)
    local oldSetGameWinner = GameRules.SetGameWinner
    GameRules.SetGameWinner = function(gameRules, team)
        callback(gameRules, team)
        oldSetGameWinner(gameRules, team)
    end
end
