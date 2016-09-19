-- GameRules Variables
ENABLE_HERO_RESPAWN = true              -- Should the heroes automatically respawn on a timer or stay dead until manually respawned
UNIVERSAL_SHOP_MODE = false             -- Should the main shop contain Secret Shop items as well as regular items
ALLOW_SAME_HERO_SELECTION = true        -- Should we let people select the same hero as each other
TEAM_SIZE = 4

HERO_SELECTION_TIME = 15.0              -- How long should we let people select their hero?
PRE_GAME_TIME = 0.0                    	-- How long after people select their heroes should the horn blow and the game start?
POST_GAME_TIME = 60.0                   -- How long should we let people look at the scoreboard before closing the server automatically?
TREE_REGROW_TIME = 60.0                 -- How long should it take individual trees to respawn after being cut down/destroyed?

GOLD_PER_TICK = 0                     -- How much gold should players get per tick?
GOLD_TICK_TIME = -1                      -- How long should we wait in seconds between gold ticks?

RECOMMENDED_BUILDS_DISABLED = false     -- Should we disable the recommened builds for heroes (Note: this is not working currently I believe)
CAMERA_DISTANCE_OVERRIDE = 1134.0        -- How far out should we allow the camera to go?  1134 is the default in Dota

MINIMAP_ICON_SIZE = 1                   -- What icon size should we use for our heroes?
MINIMAP_CREEP_ICON_SIZE = 1             -- What icon size should we use for creeps?
MINIMAP_RUNE_ICON_SIZE = 1              -- What icon size should we use for runes?

RUNE_SPAWN_TIME = 120                    -- How long in seconds should we wait between rune spawns?
CUSTOM_BUYBACK_COST_ENABLED = true      -- Should we use a custom buyback cost setting?
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- Should we use a custom buyback time?
BUYBACK_ENABLED = false                 -- Should we allow people to buyback when they die?

DISABLE_FOG_OF_WAR_ENTIRELY = false     -- Should we disable fog of war entirely for both teams?
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- Should we give gold for hero kills the same as in Dota, or allow those values to be changed?

USE_CUSTOM_TOP_BAR_VALUES = true        -- Should we do customized top bar values or use the default kill count per team?
TOP_BAR_VISIBLE = true                  -- Should we display the top bar score/count at all?
SHOW_KILLS_ON_TOPBAR = true             -- Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false  -- Should we enable backdoor protection for our towers?
REMOVE_ILLUSIONS_ON_DEATH = false       -- Should we remove all illusions if the main hero dies?
DISABLE_GOLD_SOUNDS = false             -- Should we disable the gold sound when players get gold?

END_GAME_ON_KILLS = true                -- Should the game end after a certain number of kills?
KILLS_TO_END_GAME_FOR_TEAM = 50         -- How many kills for a team should signify an end of game?

USE_CUSTOM_HERO_LEVELS = true           -- Should we allow heroes to have custom levels?
MAX_LEVEL = 50                          -- What level should we let heroes get to?
USE_CUSTOM_XP_VALUES = true             -- Should we use custom XP values to level up heroes, or the default Dota numbers?

-- Fill this table up with the required XP per level if you want to change it
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
	XP_PER_LEVEL_TABLE[i] = i * 100
end


LAST_WAVE_DMG_PER_ROUND = 20;
LAST_WAVE_HEALTH_PER_ROUND = 200;

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

MAX_SENDS = 90

START_TANGO_LIMIT = 100
TANGO_LIMIT_PER_ROUND = 25
LEAKED_TANGO_MULTIPLIER = .15

LEGION_ERROR_BETWEEN_ROUNDS = 0
LEGION_ERROR_NOT_ENOUGH_TANGOS = 1
LEGION_ERROR_INVALID_LOCATION = 2
LEGION_ERROR_NOT_ENOUGH_FOOD = 3
LEGION_ERROR_TO_CLOSE = 4
LEGION_ERROR_TO_MANY_UPGRADES = 5
LEGION_ERROR_DURING_DUEL = 6

voteOptions = {}
voteOptions["tango_limit"] = false
voteOptions["return_to_sender"] = false
voteOptions["fog_of_war"] = false


function UpdateAllVoteLabels()
  for _,opt in pairs(voteOptions) do
    UpdateVoteLabel(opt)
  end
end

function UpdateVoteLabel(opt)
  CustomGameEventManager:Send_ServerToAllClients("update_vote_label", {
    option = opt,
    votes = GetVotesFor(opt),
    playerCount = PlayerResource:GetPlayerCount(),
  })
end

function GetVotesFor(option)
  local result = 0
  for _,player in pairs(Game.players) do
    local vote = player["wants"..option]
    if vote == 1 then
      result = result + 1
    end
  end
  return result
end

function CheckVoteResults()
  local voteResults = {}
  local incomeLimitCount = 0
  local rtsVoteCount = 0
    for option, value in pairs(voteOptions) do
      voteResults[option] = GetVotesFor(option)
    end
  for option, votes in pairs(voteResults) do
    print("votes for "..option..": "..votes)
		if (votes > (PlayerResource:GetPlayerCount() / 2)) then
    	voteOptions[option] = not voteOptions[option]
		end
    if (voteOptions[option]) then
      print(option.." is active.")
    else
      print(option.." is deactived.")
    end
  end
  GameRules:GetGameModeEntity():SetFogOfWarDisabled(not voteOptions["fog_of_war"])
end
