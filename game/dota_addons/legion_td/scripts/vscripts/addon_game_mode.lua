--[[
	Basic Barebones
]]

-- Required files to be visible from anywhere
require( 'timers' )
require( 'barebones' )
require( "statcollection/init" )
require ('game')
require ('gameround')
require ('duelround')
require ('gamespawner')
require ('player')
require ('unit')
require ('popups')
require ('damage')
require ('wiki')

RequiredUnits = {
	-- Bosses
	"radiant_boss",
	"dire_boss",

	-- Waves
	"unit_abaddon",
	"unit_assassins",
	"unit_chaos",
	"unit_chen",
	"unit_deathprophet",
	"unit_donkey",
	"unit_dragon",
	"unit_drunken",
	"unit_earthspirit",
	"unit_enchantress",
	"unit_fatty",
	"unit_gatling_sniper",
	"unit_huskar",
	"unit_hydra",
	"unit_king",
	"unit_kunkka",
	"unit_lightning_ball",
	"unit_little_fishy",
	"unit_necro",
	"unit_necro_replacement",
	"unit_not_lifestealer",
	"unit_ogre",
	"unit_phantom",
	"unit_predator",
	"unit_rubick",
	"unit_space_cow",
	"unit_techies",
	"unit_templer",
	"unit_tidehunter",
	"unit_tiny",
	"unit_unicorn",
	"unit_zombie",

	--Incomeunits
	"incomeunit_ancientgolem",
	"incomeunit_beast",
	"incomeunit_big_lizard",
	"incomeunit_black_drake",
	"incomeunit_centaur",
	"incomeunit_diablo",
	"incomeunit_fleshgolem",
	"incomeunit_ghost",
	"incomeunit_golem",
	"incomeunit_harpy",
	"incomeunit_hill_troll_shaman",
	"incomeunit_hill_troll_warrior",
	"incomeunit_hulk",
	"incomeunit_jellyfish",
	"incomeunit_kobold",
	"incomeunit_little_centaur",
	"incomeunit_little_wolf",
	"incomeunit_little_golem",
	"incomeunit_lizard",
	"incomeunit_lycanwolf",
	"incomeunit_ogre_warrior",
	"incomeunit_rosh",
	"incomeunit_satyr",
	"incomeunit_vulture",
	"incomeunit_wolf"--[[,

	--Naturebuilder
	"tower_naturebuilder_agressive_boar",
	"tower_naturebuilder_bear",
	"tower_naturebuilder_big_bug",
	"tower_naturebuilder_big_centaur",
	"tower_naturebuilder_broodmother",
	"tower_naturebuilder_bug",
	"tower_naturebuilder_centaur",
	"tower_naturebuilder_centaur_warrunner",
	"tower_naturebuilder_druid_bear",
	"tower_naturebuilder_flower_tower",
	"tower_naturebuilder_hyena",
	"tower_naturebuilder_iron_bear",
	"tower_naturebuilder_shroom",
	"tower_naturebuilder_spider",
	"tower_naturebuilder_treant",

	--Elementalbuilder
	"tower_elementalbuilder_earthbender",
	"tower_elementalbuilder_earthelemental",
	"tower_elementalbuilder_earthgod",
	"tower_elementalbuilder_earthwarrior",
	"tower_elementalbuilder_firebender",
	"tower_elementalbuilder_fireelemental",
	"tower_elementalbuilder_firegod",
	"tower_elementalbuilder_firewarrior",
	"tower_elementalbuilder_thunderbender",
	"tower_elementalbuilder_thunderelemental",
	"tower_elementalbuilder_thundergod",
	"tower_elementalbuilder_thunderwarrior",
	"tower_elementalbuilder_voidbender",
	"tower_elementalbuilder_voidelemental",
	"tower_elementalbuilder_voidgod",
	"tower_elementalbuilder_voidwarrior",
	"tower_elementalbuilder_waterbender",
	"tower_elementalbuilder_waterelemental",
	"tower_elementalbuilder_watergod",
	"tower_elementalbuilder_waterwarrior",

	--Humanbuilder
	"tower_humanbuilder_archbishop",
	"tower_humanbuilder_archer",
	"tower_humanbuilder_archmage",
	"tower_humanbuilder_blademaster",
	"tower_humanbuilder_footman",
	"tower_humanbuilder_futuristic_gyrocopter",
	"tower_humanbuilder_general",
	"tower_humanbuilder_gunner",
	"tower_humanbuilder_gyrocopter_mk1",
	"tower_humanbuilder_gyrocopter_mk2",
	"tower_humanbuilder_hunter",
	"tower_humanbuilder_icewrack_grandmaster",
	"tower_humanbuilder_lieutenant",
	"tower_humanbuilder_mage",
	"tower_humanbuilder_marksman",
	"tower_humanbuilder_militia",
	"tower_humanbuilder_novice",
	"tower_humanbuilder_paladin",
	"tower_humanbuilder_sharpshooter",
	"tower_humanbuilder_soldier",
	"tower_humanbuilder_soundmaster",
	"tower_humanbuilder_spearman",
	"tower_humanbuilder_tactician"]]
}

function Precache( context )
	-- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
	-- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues

	--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that cannot or should not be precached asynchronously or
	after the game loads.

	See GameMode:PostLoadPrecache() in barebones.lua for more information
	]]

	print("[BAREBONES] Performing pre-load precache")

	for _,r in pairs(RequiredUnits) do
		PrecacheUnitByNameSync(r, context)
	end
end

-- Create the game mode when we activate
function Activate()
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
end
