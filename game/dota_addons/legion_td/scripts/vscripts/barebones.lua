print('[BAREBONES] barebones.lua')

-- Generated from template
if GameMode == nil then
    --	print ( '[BAREBONES] creating barebones game mode' )
    GameMode = class({})
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
    GameMode = self
    --	print('[BAREBONES] Starting to load Barebones gamemode...')
    -- Setup rules
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, TEAM_SIZE)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, TEAM_SIZE)
    GameRules:SetHeroRespawnEnabled(ENABLE_HERO_RESPAWN)
    GameRules:SetUseUniversalShopMode(UNIVERSAL_SHOP_MODE)
    GameRules:SetSameHeroSelectionEnabled(ALLOW_SAME_HERO_SELECTION)
    GameRules:SetHeroSelectionTime(HERO_SELECTION_TIME)
    GameRules:SetPreGameTime(PRE_GAME_TIME)
    GameRules:SetPostGameTime(POST_GAME_TIME)
    GameRules:SetTreeRegrowTime(TREE_REGROW_TIME)
    GameRules:SetUseCustomHeroXPValues(USE_CUSTOM_XP_VALUES)
    GameRules:SetGoldPerTick(GOLD_PER_TICK)
    GameRules:SetGoldTickTime(GOLD_TICK_TIME)
    GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
    GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
    GameRules:SetHeroMinimapIconScale(MINIMAP_ICON_SIZE)
    GameRules:SetCreepMinimapIconScale(MINIMAP_CREEP_ICON_SIZE)
    GameRules:SetRuneMinimapIconScale(MINIMAP_RUNE_ICON_SIZE)
    print('[BAREBONES] GameRules set')
    
    -- Listeners - Event Hooks
    -- All of these events can potentially be fired by the game, though only the uncommented ones have had
    -- Functions supplied for them.
    ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
    ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
    ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
    ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
    ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
    ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
    ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
    ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
    ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
    ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
    ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
    ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
    ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
    ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
    ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
    ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
    ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
    ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)
    ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
    ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
    ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)
    ListenToGameEvent("player_chat", Dynamic_Wrap(CommandEngine, "CheckCommand"), self)
    
    -- Change random seed
    local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0', '')
    math.randomseed(tonumber(timeTxt))
    
    -- Initialized tables for tracking state
    self.vUserIds = {}
    self.vSteamIds = {}
    self.vBots = {}
    self.vBroadcasters = {}
    
    self.vPlayers = {}
    self.vRadiant = {}
    self.vDire = {}
    
    self.nRadiantKills = 0
    self.nDireKills = 0
    self.game = Game.new()
    self.game:ReadConfiguration()
    
    self.bSeenWaitForPlayers = false
    
    -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI'
    --  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )'
    print('[BAREBONES] Done loading Barebones gamemode!\n\n')
end

mode = nil

-- This function is called 1 to 2 times as the player connects initially but before they
-- have completely connected
function GameMode:PlayerConnect(keys)
    print('[BAREBONES] PlayerConnect')
    DeepPrintTable(keys)
    
    if keys.bot == 1 then
        -- This user is a Bot, so add it to the bots table
        self.vBots[keys.userid] = 1
    end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
    print('[BAREBONES] OnConnectFull')
    DeepPrintTable(keys)
    GameMode:CaptureGameMode()
    
    local entIndex = keys.index + 1
    -- The Player entity of the joining user
    local ply = EntIndexToHScript(entIndex)
    
    -- The Player ID of the joining player
    local playerID = ply:GetPlayerID()
    
    -- Update the user ID table with this user
    self.vUserIds[keys.userid] = ply
    
    -- Update the Steam ID table
    self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply
    
    -- If the player is a broadcaster flag it in the Broadcasters table
    if PlayerResource:IsBroadcaster(playerID) then
        self.vBroadcasters[keys.userid] = 1
        return
    end
end

-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
    if mode == nil then
        -- Set GameMode parameters
        mode = GameRules:GetGameModeEntity()
        mode:SetRecommendedItemsDisabled(RECOMMENDED_BUILDS_DISABLED)
        mode:SetCameraDistanceOverride(CAMERA_DISTANCE_OVERRIDE)
        mode:SetCustomBuybackCostEnabled(CUSTOM_BUYBACK_COST_ENABLED)
        mode:SetCustomBuybackCooldownEnabled(CUSTOM_BUYBACK_COOLDOWN_ENABLED)
        mode:SetBuybackEnabled(BUYBACK_ENABLED)
        mode:SetTopBarTeamValuesOverride(USE_CUSTOM_TOP_BAR_VALUES)
        mode:SetTopBarTeamValuesVisible(TOP_BAR_VISIBLE)
        mode:SetUseCustomHeroLevels(USE_CUSTOM_HERO_LEVELS)
        mode:SetCustomHeroMaxLevel(MAX_LEVEL)
        mode:SetCustomXPRequiredToReachNextLevel(XP_PER_LEVEL_TABLE)
        
        --mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
        mode:SetTowerBackdoorProtectionEnabled(ENABLE_TOWER_BACKDOOR_PROTECTION)
        
        mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
        mode:SetGoldSoundDisabled(DISABLE_GOLD_SOUNDS)
        mode:SetRemoveIllusionsOnDeath(REMOVE_ILLUSIONS_ON_DEATH)
        
        self:OnFirstPlayerLoaded()
    end
end

-- This is an example console command
function GameMode:ExampleConsoleCommand()
    print('******* Example Console Command ***************')
    local cmdPlayer = Convars:GetCommandClient()
    if cmdPlayer then
        local playerID = cmdPlayer:GetPlayerID()
        if playerID ~= nil and playerID ~= -1 then
            -- Do something here for the player who called this command
            PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
        end
    end
    print('*********************************************')
end

--[[
This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function
in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
If this occurs it causes the client to never precache things configured in that block.

In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will
precache the precache{} block statement of the unit and all precache{} block statements for every Ability#
defined on the unit.

This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
time, you can call the functions individually (for example if you want to precache units in a new wave of
holdout).
]]
function GameMode:PostLoadPrecache()
    print("[BAREBONES] Performing Post-Load precache")
end

--[[
This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
    print("[BAREBONES] First Player has loaded")
end

--[[
This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
    print("[BAREBONES] All Players have loaded into the game")
end

--[[
This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
levels, changing the starting gold, removing/adding abilities, adding physics, etc.

The hero parameter is the hero entity that just spawned in.
]]
function GameMode:OnHeroInGame(hero)
    print("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())
    
    -- Store a reference to the player handle inside this hero handle.
    hero.player = PlayerResource:GetPlayer(hero:GetPlayerID())
    -- Store the player's name inside this hero handle.
    hero.playerName = PlayerResource:GetPlayerName(hero:GetPlayerID())
    -- Store this hero handle in this table.
    table.insert(self.vPlayers, hero)
    -- This line for example will set the starting gold of every hero to 500 unreliable gold
    hero:SetGold(START_GOLD, false)
end

--[[
This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
    print("[BAREBONES] The game has officially begun")
end

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
    print('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
    DeepPrintTable(keys)
    
    local name = keys.name
    local networkid = keys.networkid
    local reason = keys.reason
    local userid = keys.userid
end

-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
    print("[BAREBONES] GameRules State Changed")
    DeepPrintTable(keys)
    
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then
        self.bSeenWaitForPlayers = true
    elseif newState == DOTA_GAMERULES_STATE_INIT then
        Timers:RemoveTimer("alljointimer")
    elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
        local et = 6
        if self.bSeenWaitForPlayers then
            et = .01
        end
        Timers:CreateTimer("alljointimer", {
            useGameTime = true,
            endTime = et,
            callback = function()
                if PlayerResource:HaveAllPlayersJoined() then
                    GameMode:PostLoadPrecache()
                    GameMode:OnAllPlayersLoaded()
                    return
                end
                return 1
            end
        })
    elseif newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
        Game:RandomHeroes()
    elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        GameMode:OnGameInProgress()
        if not self.game.isRunning then
            self.game:Start()
        end
    end
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
    --	print("[BAREBONES] NPC Spawned")
    --	DeepPrintTable(keys)
    local npc = EntIndexToHScript(keys.entindex)
    
    if npc:IsRealHero() and npc.bFirstSpawned == nil then
        npc.bFirstSpawned = true
        GameMode:OnHeroInGame(npc)
    end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
    --print("[BAREBONES] Entity Hurt")
    --DeepPrintTable(keys)
    if keys.entindex_attacker then
        local entCause = EntIndexToHScript(keys.entindex_attacker)
    end
    if keys.entindex_killed then
        local entVictim = EntIndexToHScript(keys.entindex_killed)
    end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
    print('[BAREBONES] OnItemPurchased')
    DeepPrintTable(keys)
    
    local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
    local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
    print('[BAREBONES] OnPlayerReconnect')
    DeepPrintTable(keys)
end

-- An item was purchased by a player
function GameMode:OnItemPurchased(keys)
    print('[BAREBONES] OnItemPurchased')
    DeepPrintTable(keys)
    
    -- The playerID of the hero who is buying something
    local plyID = keys.PlayerID
    if not plyID then return end
    
    -- The name of the item purchased
    local itemName = keys.itemname
    
    -- The cost of the item purchased
    local itemcost = keys.itemcost
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
    --	print('[BAREBONES] AbilityUsed')
    --	DeepPrintTable(keys)
    local player = EntIndexToHScript(keys.PlayerID)
    local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
    print('[BAREBONES] OnNonPlayerUsedAbility')
    DeepPrintTable(keys)
    
    local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
    print('[BAREBONES] OnPlayerChangedName')
    DeepPrintTable(keys)
    
    local newName = keys.newname
    local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility(keys)
    print('[BAREBONES] OnPlayerLearnedAbility')
    DeepPrintTable(keys)
    
    local player = EntIndexToHScript(keys.player)
    local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
    print('[BAREBONES] OnAbilityChannelFinished')
    DeepPrintTable(keys)
    
    local abilityname = keys.abilityname
    local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
    print('[BAREBONES] OnPlayerLevelUp')
    DeepPrintTable(keys)
    
    local player = EntIndexToHScript(keys.player)
    local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
    --	print ('[BAREBONES] OnLastHit')
    --	DeepPrintTable(keys)
    local isFirstBlood = keys.FirstBlood == 1
    local isHeroKill = keys.HeroKill == 1
    local isTowerKill = keys.TowerKill == 1
    local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
    print('[BAREBONES] OnTreeCut')
    DeepPrintTable(keys)
    
    local treeX = keys.tree_x
    local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated(keys)
    print('[BAREBONES] OnRuneActivated')
    DeepPrintTable(keys)
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local rune = keys.rune
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
    print('[BAREBONES] OnPlayerTakeTowerDamage')
    DeepPrintTable(keys)
    
    local player = PlayerResource:GetPlayer(keys.PlayerID)
    local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
    print('[BAREBONES] OnPlayerPickHero')
    DeepPrintTable(keys)
    
    local heroClass = keys.hero
    local heroEntity = EntIndexToHScript(keys.heroindex)
    local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
    print('[BAREBONES] OnTeamKillCredit')
    DeepPrintTable(keys)
    
    local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
    local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
    local numKills = keys.herokills
    local killerTeamNumber = keys.teamnumber
end

-- An entity died
function GameMode:OnEntityKilled(keys)
    --	print( '[BAREBONES] OnEntityKilled Called' )
    --	DeepPrintTable( keys )
    -- The Unit that was Killed
    local killedUnit = EntIndexToHScript(keys.entindex_killed)
    -- The Killing entity
    local killerEntity = nil
    
    if keys.entindex_attacker ~= nil then
        killerEntity = EntIndexToHScript(keys.entindex_attacker)
    end
-- Put code here to handle when an entity gets killed
end
