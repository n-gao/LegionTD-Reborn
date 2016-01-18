if Game == nil then
  Game = class({})
end

--Spielstati
GAMESTATE_PREPARATION = 0
GAMESTATE_FIGHTING = 1
GAMESTATE_END = 2
STARTING_ROUND = 1
CHECKING_INTERVALL = 1

START_HEALTH_BONUS = 450
MAX_KING_UPGRADES = 75
HEALTH_BONUS_ADD = 25
START_DAMAGE_BONUS = 6
DAMAGE_BONUS_ADD = 1
START_BONUS_REGEN = 1
REGEN_BONUS_ADD = 0.2

START_TANGO_ADD_AMOUNT = 1
START_TANGO_ADD_SPEED = 5.0
START_GOLD = 100
START_TANGO = 40
START_FOOD_LIMIT = 10
START_INCOME = 0

START_TANGO_LIMIT = 100
TANGO_LIMIT_PER_ROUND = 25
LEAKED_TANGO_MULTIPLIER = .10

LEGION_ERROR_BETWEEN_ROUNDS = 0
LEGION_ERROR_NOT_ENOUGH_TANGOS = 1
LEGION_ERROR_INVALID_LOCATION = 2
LEGION_ERROR_NOT_ENOUGH_FOOD = 3
LEGION_ERROR_TO_CLOSE = 4
LEGION_ERROR_TO_MANY_UPGRADES = 5
LEGION_ERROR_DURING_DUEL = 6

function Game.GetUnitNameByID(id)
  if id == 1 then return "tower_naturebuilder_spider"
  elseif id == 2 then return "tower_naturebuilder_bug"
  elseif id == 3 then return "tower_naturebuilder_bear"
  elseif id == 4 then return "tower_naturebuilder_treant"
  elseif id == 5 then return "tower_naturebuilder_hyena"
  elseif id == 6 then return "tower_naturebuilder_centaur"
  elseif id == 7 then return "tower_naturebuilder_broodmother"
  elseif id == 8 then return "tower_naturebuilder_big_bug"
  elseif id == 9 then return "tower_naturebuilder_druid_bear"
  elseif id == 10 then return "tower_naturebuilder_iron_bear"
  elseif id == 11 then return "tower_naturebuilder_shroom"
  elseif id == 12 then return "tower_naturebuilder_flower_treant"
  elseif id == 13 then return "tower_naturebuilder_agressive_boar"
  elseif id == 14 then return "tower_naturebuilder_big_centaur"
  elseif id == 15 then return "tower_naturebuilder_centaur_warrunner"
  elseif id == 16 then return "tower_naturebuilder_treebeard"

  elseif id == 50 then return "tower_elementalbuilder_waterbender"
  elseif id == 51 then return "tower_elementalbuilder_thunderbender"
  elseif id == 52 then return "tower_elementalbuilder_earthbender"
  elseif id == 53 then return "tower_elementalbuilder_firebender"
  elseif id == 54 then return "tower_elementalbuilder_voidbender"
  elseif id == 55 then return "tower_elementalbuilder_waterelemental"
  elseif id == 56 then return "tower_elementalbuilder_waterwarrior"
  elseif id == 57 then return "tower_elementalbuilder_watergod"
  elseif id == 58 then return "tower_elementalbuilder_earthelemental"
  elseif id == 59 then return "tower_elementalbuilder_earthwarrior"
  elseif id == 60 then return "tower_elementalbuilder_earthgod"
  elseif id == 61 then return "tower_elementalbuilder_thunderelemental"
  elseif id == 62 then return "tower_elementalbuilder_thunderwarrior"
  elseif id == 63 then return "tower_elementalbuilder_thundergod"
  elseif id == 64 then return "tower_elementalbuilder_fireelemental"
  elseif id == 65 then return "tower_elementalbuilder_firewarrior"
  elseif id == 66 then return "tower_elementalbuilder_firegod"
  elseif id == 67 then return "tower_elementalbuilder_voidelemental"
  elseif id == 68 then return "tower_elementalbuilder_voidwarrior"
  elseif id == 69 then return "tower_elementalbuilder_voidgod"

  elseif id == 100 then return "tower_humanbuilder_archbishop"
  elseif id == 101 then return "tower_humanbuilder_archer"
  elseif id == 102 then return "tower_humanbuilder_archmage"
  elseif id == 103 then return "tower_humanbuilder_blademaster"
  elseif id == 104 then return "tower_humanbuilder_footman"
  elseif id == 105 then return "tower_humanbuilder_futuristic_gyrocopter"
  elseif id == 106 then return "tower_humanbuilder_general"
  elseif id == 107 then return "tower_humanbuilder_gunner"
  elseif id == 108 then return "tower_humanbuilder_gyrocopter_mk1"
  elseif id == 109 then return "tower_humanbuilder_gyrocopter_mk2"
  elseif id == 110 then return "tower_humanbuilder_hunter"
  elseif id == 111 then return "tower_humanbuilder_icewrack_grandmaster"
  elseif id == 112 then return "tower_humanbuilder_lieutenant"
  elseif id == 113 then return "tower_humanbuilder_mage"
  elseif id == 114 then return "tower_humanbuilder_marksman"
  elseif id == 115 then return "tower_humanbuilder_militia"
  elseif id == 116 then return "tower_humanbuilder_novice"
  elseif id == 117 then return "tower_humanbuilder_paladin"
  elseif id == 118 then return "tower_humanbuilder_sharpshooter"
  elseif id == 119 then return "tower_humanbuilder_soldier"
  elseif id == 120 then return "tower_humanbuilder_soundmaster"
  elseif id == 121 then return "tower_humanbuilder_spearman"
  elseif id == 122 then return "tower_humanbuilder_tactician"

  elseif id == 1001 then return "incomeunit_kobold"
  elseif id == 1002 then return "incomeunit_hill_troll_shaman"
  elseif id == 1003 then return "incomeunit_hill_troll_warrior"
  elseif id == 1004 then return "incomeunit_harpy"
  elseif id == 1005 then return "incomeunit_ghost"
  elseif id == 1006 then return "incomeunit_little_wolf"
  elseif id == 1007 then return "incomeunit_satyr"
  elseif id == 1008 then return "incomeunit_ogre_warrior"
  elseif id == 1009 then return "incomeunit_little_centaur"
  elseif id == 1010 then return "incomeunit_wolf"
  elseif id == 1011 then return "incomeunit_golem"
  elseif id == 1012 then return "incomeunit_little_golem"
  elseif id == 1013 then return "incomeunit_centaur"
  elseif id == 1014 then return "incomeunit_vulture"
  elseif id == 1015 then return "incomeunit_lizard"
  elseif id == 1016 then return "incomeunit_lycanwolf"
  elseif id == 1017 then return "incomeunit_black_drake"
  elseif id == 1018 then return "incomeunit_big_lizard"
  elseif id == 1019 then return "incomeunit_ancientgolem"
  elseif id == 1020 then return "incomeunit_fleshgolem"
  elseif id == 1021 then return "incomeunit_jellyfish"
  elseif id == 1022 then return "incomeunit_hulk"
  elseif id == 1023 then return "incomeunit_beast"
  elseif id == 1024 then return "incomeunit_diablo"
  elseif id == 1025 then return "incomeunit_rosh"
    -- elseif id == 16 then return "tower_naturebuilder_centaur"
  end
end



--Neues Spiel
function Game.new()
  local self = Game()
  Game = self
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(Game, 'OnNPCSpawned'), self)
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(Game, 'OnConnectFull'), self)
  ListenToGameEvent('player_reconnected', Dynamic_Wrap(Game, 'OnPlayerReconnect'), self)
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(Game, 'OnPlayerDisconnect'), self)
  self.players = {}
  self.sendRadiant = {}
  self.sendDire = {}
  self.sendLeaderRadiant = 1 -- we'll rotate who gets the biggest send each wave
  self.sendLeaderDire = 1 -- we'll rotate who gets the biggest send each wave
  self.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
  self.DamageKV = LoadKeyValues("scripts/damage_table.kv")
  GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(Game, "DamageFilter"), Game)
  GameRules:GetGameModeEntity():SetExecuteOrderFilter(Dynamic_Wrap(Game, "OrderFilter"), Game)

  LinkLuaModifier( "modifier_attack_arcane_lua", "abilities/damage/modifier_attack_arcane_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_attack_normal_lua", "abilities/damage/modifier_attack_normal_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_attack_pierce_lua", "abilities/damage/modifier_attack_pierce_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_defend_heavy_lua", "abilities/damage/modifier_defend_heavy_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_defend_medium_lua", "abilities/damage/modifier_defend_medium_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
  LinkLuaModifier( "modifier_defend_light_lua", "abilities/damage/modifier_defend_light_lua.lua" ,LUA_MODIFIER_MOTION_NONE )


  if Convars:GetBool('developer') then
    Convars:RegisterCommand("start_next_round", Dynamic_Wrap(self, "StartNextRoundCommand"), "keine Ahnung", 0)
    Convars:RegisterCommand("start_prev_round", Dynamic_Wrap(self, "StartPreviousRoundCommand"), "keine Ahnung", 0)
    Convars:RegisterCommand("restart_round", Dynamic_Wrap(self, "RestartRoundCommand"), "keine Ahnung", 0)
    Convars:RegisterCommand("reset", Dynamic_Wrap(self, "RestartCommand"), "keine Ahnung", 0)
    Convars:RegisterCommand("wiki", Dynamic_Wrap(self, "WikiCommand"), "no idea", 0)
  end

  CustomGameEventManager:RegisterListener("send_unit", Dynamic_Wrap(Game, "SendUnit"))
  CustomGameEventManager:RegisterListener("upgarde_king", Dynamic_Wrap(Game, "UpgradeKing"))
  CustomGameEventManager:RegisterListener("toggle_income_limit", Dynamic_Wrap(Game, "ToggleIncomeLimit"))
  return self
end



--List alle Informationen ein
function Game:ReadConfiguration()
  local kv = LoadKeyValues("scripts/maps/"..GetMapName()..".txt")
  if not kv then
    print("voll scheiße gelaufen jetzt!!!!!!!!!!!")
    return
  end
  self.initPrepTime = kv.FirstPrepTime
  self.timeBetweenRounds = kv.PrepTimeBetweenRounds
  self:ReadLastSpawn(kv["LastSpawn"])
  self:ReadIncomeSpawner(kv["IncomeSpawner"])
  self:ReadDuelSpawn(kv["DuelSpawn"])
  self:ReadDuelTargets(kv["DuelTarget"])
  self:ReadLanes(kv["Lanes"])
  self:ReadRoundConfiguration(kv)
  self.radiantBoss = Entities:FindByName(nil, "radiant_boss")
  self.direBoss = Entities:FindByName(nil, "dire_boss")
  print("everything loaded")
end



function Game:ReadDuelSpawn(kvDue)
  self.duelSpawn = {}
  if not (type(kvDue) == "table") then
    return
  end
  for ind,sp in pairs(kvDue) do
    local obj = Entities:FindByName(nil, sp.Name)
    if obj then
      self.duelSpawn[ind] = obj
    else
      print(sp.Name.." not found.")
    end
  end
end



function Game:ReadDuelTargets(kvDuet)
  self.duelTargets = {}
  if not (type(kvDuet) == "table") then
    return
  end
  for ind,sp in pairs(kvDuet) do
    local obj = Entities:FindByName(nil, sp.Name)
    if obj then
      self.duelTargets[ind] = obj
    else
      print(sp.Name.." not found.")
    end
  end
end



function Game:ReadIncomeSpawner(kvInc)
  self.incomeSpawner = {}
  if not (type(kvInc) == "table") then
    return
  end
  for ind,sp in pairs(kvInc) do
    local obj = Entities:FindByName(nil, sp.Name)
    if obj then
      self.incomeSpawner[ind] = obj
    else
      print(sp.Name.." not found.")
    end
  end
end


--List Punkte für die letzte Verteidigung ein
function Game:ReadLastSpawn(kvLast)
  self.lastDefends = {}
  if type(kvLast) ~= "table" then
    return
  end
  for ind,sp in pairs(kvLast) do
    local obj = Entities:FindByName(nil, sp.Name)
    if obj then
      self.lastDefends[ind] = obj
    else
      print(sp.Name.." not found.")
    end
  end
end



--List Spawnpunkte ein
function Game:ReadLanes(kvSpawns)
  self.lanes = {}
  if type(kvSpawns) ~= "table" then
    return
  end
  for ind,sp in pairs(kvSpawns) do
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
      print("Lane "..ind.." found.")
      self.lanes[ind] = {
        spawnpoint = lspawn,
        waypoint = lwaypoint:GetAbsOrigin(),
        nextWaypoint = lnextWaypoint:GetAbsOrigin(),
        midWaypoint = lmidWaypoint:GetAbsOrigin(),
        lastWaypoint = llastWaypoint:GetAbsOrigin(),
        waypoints = {lwaypoint:GetAbsOrigin(), lnextWaypoint:GetAbsOrigin(), lmidWaypoint:GetAbsOrigin(), llastWaypoint:GetAbsOrigin(),},
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



--Liest Runden ein
function Game:ReadRoundConfiguration(kv)
  self.rounds = {}
  self.doneDuels = 0
  local duelRoundCount = 0
  while true do
    local roundName = string.format("Round%d", #self.rounds + 1 - duelRoundCount)
    local roundData = kv[roundName]
    if roundData == nil then
      return
    end
    local roundObj = GameRound()
    roundObj:ReadRoundConfiguration(roundData, #self.rounds + 1 - duelRoundCount)
    table.insert(self.rounds, roundObj)
    if #self.rounds % 10 == duelRoundCount then
      local duelRoundName = "DuelRound"..(duelRoundCount + 1)
      local duelRoundData = kv[duelRoundName]
      if duelRoundData then
        table.insert(self.rounds, DuelRound.new(duelRoundData, #self.rounds + 1, false))
        duelRoundCount = duelRoundCount + 1
      end
    end
    print("Round "..#self.rounds.." loaded")
  end
end



function Game:GetTangoLimit()
  return START_TANGO_LIMIT + self.gameRound * TANGO_LIMIT_PER_ROUND
end



--Start des Spiels
function Game:Start()
  print ("Game:Start()")
  self.radiantKingVision = CreateUnitByName("king_vision_dummy", self.radiantBoss:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
  self.direKingVision = CreateUnitByName("king_vision_dummy", self.direBoss:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
  self.gridBoxes = Entities:FindByName(nil, "gridboxes")
  self.gameState = GAMESTATE_PREPARATION
  self.gameRound = STARTING_ROUND
  self.isRunning = true
  Timers:CreateTimer(0, function()
    for _,player in pairs(self.players) do
      player:RefreshPlayerInfo()
    end
  end)
  self.radiantBoss.healthBonus = START_HEALTH_BONUS
  self.radiantBoss.damageBonus = START_DAMAGE_BONUS
  self.radiantBoss.regenBonus = START_BONUS_REGEN
  self.direBoss.healthBonus = START_HEALTH_BONUS
  self.direBoss.damageBonus = START_DAMAGE_BONUS
  self.direBoss.regenBonus = START_BONUS_REGEN
  local incomeLimitCount = 0
  for _,player in pairs(self.players) do
    if player.wantIncomeLimit == 1 then
      incomeLimitCount = incomeLimitCount + 1
    end
  end
  self.withIncomeLimit = incomeLimitCount > (PlayerResource:GetPlayerCount() / 2)
  self:CreateGameTimer()
  -- GameRules:GetGameModeEntity():SetThink("OnThink", self, "Check", 0)
  self:Initialice()
end


function Game:CreateGameTimer()
  if not self.gameTimer then
    self.gameTimer = Timers:CreateTimer(0, function()
      return self:OnThink()
    end)
  end
end



--Wird jede viertel Sekunde aufgerufen, überprüft Spielstatus
function Game:OnThink()
  if self.gameState == GAMESTATE_PREPARATION then
    --festlegung der vorbereitungszeit
    if not self.nextRoundTime then
      if not self.finishedWaves then
        self:SetWaitTime()
      else
        self:ResetUnitPositions()
        self:StartNextRound()
      end
    elseif self.nextRoundTime <= GameRules:GetGameTime() then
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



--Setzt die Zeit zum warten zur nächsten Runde
function Game:SetWaitTime()
  local waitTime = self.timeBetweenRounds
  if self.gameRound == 1 then
    waitTime = self.initPrepTime
  end
  self.nextRoundTime = GameRules:GetGameTime() + waitTime

  self.quest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title = "#QuestTimer" } )
  self.nextWaveQuest = SpawnEntityFromTableSynchronous( "quest", { name = "QuestName", title =  "#"..self.rounds[self.gameRound].roundTitle} )
  self.quest.finished = waitTime
  local subQuest = SpawnEntityFromTableSynchronous("subquest_base", {
    show_progress_bar = true,
    progress_bar_hue_shift = -119
  })
  self.quest:AddSubquest(subQuest)
  self.quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.quest.finished )
  self.quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, waitTime )
  subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.quest.finished )
  subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, waitTime )
  Timers:CreateTimer(1, function()
    self.quest.finished = self.quest.finished - 1
    self.quest:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.quest.finished )
    subQuest:SetTextReplaceValue( SUBQUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, self.quest.finished )
    if self.quest.finished == 0 then
      self.quest:CompleteQuest()
      self.nextWaveQuest:CompleteQuest()
      return
    end
    return 1
  end)

  CustomGameEventManager:Send_ServerToAllClients( "update_round", {round = self.gameRound - self.doneDuels} )
  self:RespawnUnits()
  print("Time to next Round: "..waitTime)
end



--Runde beendet
function Game:RoundFinished()
  mode:SetFogOfWarDisabled(false)
  self.gridBoxes:RemoveEffects(EF_NODRAW)
  if not self.gameTimer then
    self:CreateGameTimer()
  end
  local round = self:GetCurrentRound()
  if round.bounty then
    for _,player in pairs(self.players) do
      if player.plyEntitie and (player:GetTeamNumber() == round.winningTeam or round.winningTeam == DOTA_TEAM_NOTEAM) then
        player:Income(round.bounty)
      end
    end
  end
  self.gameRound = self.gameRound + 1
  self.gameState = GAMESTATE_PREPARATION
  if self.gameRound > #self.rounds then
    self.gameRound = self.gameRound - 1
    self.finishedWaves = true
  end
end



function Game:GetCurrentRound()
  return self.rounds[self.gameRound]
end



--Startet nächste Runde
function Game:StartNextRound()
  print "Game:StartNextround()"
  for _,player in pairs(self.players) do
    if player.lane and player.lane.isActive then --only repair leaks if lane is active
      player.leaked = false;
      player.leaksPenalty = 0;
    end
  end
  mode:SetFogOfWarDisabled(true)
  self.gridBoxes:AddEffects(EF_NODRAW)
  self.gameState = GAMESTATE_FIGHTING
  self.nextRoundTime = nil
  self.rounds[self.gameRound]:Begin()
  print "Game:StartNextround() about to call self:UnlockUnits()"
  self:UnlockUnits()
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
    if ent.unit then
      return 4
    end
    if ent == caster.player.lane.box then
      result = 1
    end
  end
  return result
end



--Sorgt dafür dass die Zeit aktualisiert Wird
function Game:Initialice()
  Timers:CreateTimer(0, function()
    local time = GameRules:GetGameTime()
    local minutes = math.floor(time / 60)
    local seconds = math.floor(time % 60)
    local minutesString = ""
    if minutes >= 10 then
      minutesString = ""..minutes
    else
      minutesString = "0"..minutes
    end
    local secondsString = ""
    if seconds >= 10 then
      secondsString = ""..seconds
    else
      secondsString = "0"..seconds
    end
    data = {
      timer_minute = minutesString,
      timer_second = secondsString
    }
    CustomGameEventManager:Send_ServerToAllClients("update_time", data)
    GameRules:SetTimeOfDay( 0.26 ) -- always day!
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
      local attack_type = Game.UnitKV[npc:GetUnitName()]["Legion_AttackType"] or "normal"
      local defend_type = Game.UnitKV[npc:GetUnitName()]["Legion_DefendType"] or "medium"
      print ("unit spawned with " .. attack_type .. "/" .. defend_type)
      npc:AddNewModifier(npc, nil, "modifier_attack_" .. attack_type .. "_lua", {})
      npc:AddNewModifier(npc, nil, "modifier_defend_" .. defend_type .. "_lua", {})
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
      print ("Game:OnConnectFull(): Player object found for existing player.")
      player:SetPlayerEntitie(ply, keys.userid)
    else
      print ("Game:OnConnectFull(): Player object not found for player entIndex " .. entIndex .. " playerID " .. playerID .."; Creating.")
      local newPlayer = Player.new(ply, keys.userid)
      table.insert(self.players, newPlayer)
    end
  end
end



function Game:OrderFilter(keys)
  local order = keys.order_type
  local unit = EntIndexToHScript(keys.units["0"])
  local units = {}
  for _,key in pairs(keys.units) do
    table.insert(units, EntIndexToHScript(key))
  end

  if order == DOTA_UNIT_ORDER_HOLD_POSITION then
    for _,u in pairs(units) do
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




function Game:ToggleIncomeLimit(data)
  local lData = {
    playerID = data.playerID,
    value = data.value
  }
  local player = Game:FindPlayerWithID(lData.playerID)
  player.wantIncomeLimit = data.value
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
    local name = Game.GetUnitNameByID(lData.id)
    local unit = CreateUnitByName(name, spawn, true, nil, nil, team)
    unit.tangoValue = lData.cost
    if team == 2 then
      print ("adding unit to Game.sendRadiant")
      table.insert(Game.sendRadiant, unit)
    else
      print ("adding unit to Game.sendDire")
      table.insert(Game.sendDire, unit)
    end
    player:RefreshPlayerInfo()
  else
    player:SendErrorCode(LEGION_ERROR_NOT_ENOUGH_TANGOS)
  end
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




function Game:StartNextRoundCommand()
  Game:ClearBoard()
  Game.gameRound = Game.gameRound + 1
  Game:RespawnUnits()
  Game:StartNextRound()
end



function Game:RestartRoundCommand()
  Game:ClearBoard()
  Game:RespawnUnits()
  Game:StartNextRound()
end



function Game:StartPreviousRoundCommand()
  Game:ClearBoard()
  Game.gameRound = Game.gameRound - 1
  Game:RespawnUnits()
  Game:StartNextRound()
end



function Game:RestartCommand()
  Game:ClearBoard()
  Game.gameRound = 1
  Game:RespawnUnits()
  Game:StartNextRound()
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
--Alle Einheiten respawnen
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
    if player:IsActive() then
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
