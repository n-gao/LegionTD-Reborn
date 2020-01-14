Precacher =
    Precacher or
    class(
        {
            constructor = function(self, numWaves)
                self.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
                self.HeroKV = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
                self.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
                self.UnitTable = dofile("config_unit")
                self.MapKV = LoadKeyValues("scripts/maps/" .. GetMapName() .. ".txt")
                self.numWaves = numWaves
            end
        }
    )

function Precacher:PrecacheEverything(context)
    for name, table in pairs(self.AbilityKV) do
        if table.AbilitySpecial ~= nil then
            for _, entry in pairs(table.AbilitySpecial) do
                for key, value in pairs(entry) do
                    if key == "unitID" then
                        unitName = self.UnitTable[value]
                        -- print("Precaching " .. unitName)
                        if string.find(name, "spawn") then
                            PrecacheUnitByNameSync(unitName, context)
                        elseif string.find(name, "upgrade") then
                            PrecacheUnitByNameAsync(
                                unitName,
                                function(...)
                                end
                            )
                        end
                    end
                end
            end
        end
    end
    self:PrecacheRounds(context)
    self:PrecacheIncomeUnits(context)
    PrecacheUnitByNameSync("radiant_king", context)
    PrecacheUnitByNameSync("dire_king", context)
end

function Precacher:PrecacheRounds(context)
    for i, round in pairs(self.MapKV.Rounds) do
        if round.round_type == "wave" then
            if tonumber(i) <= self.numWaves then
                PrecacheUnitByNameSync(round.Unit.NPCName, context)
            else
                PrecacheUnitByNameAsync(
                    round.Unit.NPCName,
                    function(...)
                    end
                )
            end
        end
    end
end

function Precacher:PrecacheIncomeUnits(context)
    print("Precaching incomeunits")
    for name, table in pairs(self.UnitKV) do
        if string.find(name, "incomeunit") then
            PrecacheUnitByNameSync(name, context)
        end
    end
end

RequiredUnits = {
    -- Bosses
    "radiant_king",
    "dire_king",
    -- Waves
    -- "unit_abaddon",
    -- "unit_assassins",
    -- "unit_chaos",
    -- "unit_chen",
    -- "unit_deathprophet",
    "unit_donkey",
    -- "unit_dragon",
    -- "unit_drunken",
    -- "unit_earthspirit",
    -- "unit_enchantress",
    -- "unit_fatty",
    -- "unit_gatling_sniper",
    -- "unit_huskar",
    -- "unit_hydra",
    -- "unit_king",
    -- "unit_kunkka",
    -- "unit_lightning_ball",
    -- "unit_little_fishy",
    -- "unit_necro",
    -- "unit_necro_replacement",
    -- "unit_not_lifestealer",
    -- "unit_ogre",
    -- "unit_phantom",
    -- "unit_predator",
    -- "unit_rubick",
    "unit_space_cow",
    -- "unit_techies",
    -- "unit_templer",
    -- "unit_tidehunter",
    -- "unit_tiny",
    "unit_unicorn",
    -- "unit_zombie",

    --Incomeunits
    -- "incomeunit_ancientgolem",
    -- "incomeunit_beast",
    -- "incomeunit_big_lizard",
    -- "incomeunit_black_drake",
    -- "incomeunit_centaur",
    -- "incomeunit_diablo",
    -- "incomeunit_fleshgolem",
    -- "incomeunit_ghost",
    -- "incomeunit_golem",
    -- "incomeunit_harpy",
    "incomeunit_hill_troll_shaman",
    "incomeunit_hill_troll_warrior",
    -- "incomeunit_hulk",
    -- "incomeunit_jellyfish",
    "incomeunit_kobold",
    -- "incomeunit_little_centaur",
    -- "incomeunit_little_wolf",
    -- "incomeunit_little_golem",
    -- "incomeunit_lizard",
    -- "incomeunit_lycanwolf",
    -- "incomeunit_ogre_warrior",
    -- "incomeunit_rosh",
    -- "incomeunit_satyr",
    -- "incomeunit_vulture",
    -- "incomeunit_wolf",

    --Naturebuilder
    "tower_naturebuilder_bug",
    "tower_naturebuilder_spider",
    --Elementalbuilder
    "tower_elementalbuilder_earthbender",
    "tower_elementalbuilder_firebender",
    "tower_elementalbuilder_thunderbender",
    "tower_elementalbuilder_voidbender",
    "tower_elementalbuilder_waterbender",
    --Humanbuilder
    "tower_humanbuilder_archer",
    "tower_humanbuilder_militia",
    "tower_humanbuilder_novice"

    --Higher level units
    -- "tower_elementalbuilder_earthbender",
    -- "tower_elementalbuilder_earthelemental",
    -- "tower_elementalbuilder_earthgod",
    -- "tower_elementalbuilder_earthwarrior",
    -- "tower_elementalbuilder_firebender",
    -- "tower_elementalbuilder_fireelemental",
    -- "tower_elementalbuilder_firegod",
    -- "tower_elementalbuilder_firewarrior",
    -- "tower_elementalbuilder_thunderbender",
    -- "tower_elementalbuilder_thunderelemental",
    -- "tower_elementalbuilder_thundergod",
    -- "tower_elementalbuilder_thunderwarrior",
    -- "tower_elementalbuilder_voidbender",
    -- "tower_elementalbuilder_voidelemental",
    -- "tower_elementalbuilder_voidgod",
    -- "tower_elementalbuilder_voidwarrior",
    -- "tower_elementalbuilder_waterbender",
    -- "tower_elementalbuilder_waterelemental",
    -- "tower_elementalbuilder_watergod",
    -- "tower_elementalbuilder_waterwarrior",

    -- "tower_humanbuilder_archbishop",
    -- "tower_humanbuilder_archer",
    -- "tower_humanbuilder_archmage",
    -- "tower_humanbuilder_blademaster",
    -- "tower_humanbuilder_footman",
    -- "tower_humanbuilder_futuristic_gyrocopter",
    -- "tower_humanbuilder_general",
    -- "tower_humanbuilder_gunner",
    -- "tower_humanbuilder_gyrocopter_mk1",
    -- "tower_humanbuilder_gyrocopter_mk2",
    -- "tower_humanbuilder_hunter",
    -- "tower_humanbuilder_icewrack_grandmaster",
    -- "tower_humanbuilder_lieutenant",
    -- "tower_humanbuilder_mage",
    -- "tower_humanbuilder_marksman",
    -- "tower_humanbuilder_militia",
    -- "tower_humanbuilder_novice",
    -- "tower_humanbuilder_paladin",
    -- "tower_humanbuilder_sharpshooter",
    -- "tower_humanbuilder_soldier",
    -- "tower_humanbuilder_soundmaster",
    -- "tower_humanbuilder_spearman",
    -- "tower_humanbuilder_tactician",

    -- "tower_naturebuilder_agressive_boar",
    -- "tower_naturebuilder_bear",
    -- "tower_naturebuilder_big_bug",
    -- "tower_naturebuilder_big_centaur",
    -- "tower_naturebuilder_broodmother",
    -- "tower_naturebuilder_bug",
    -- "tower_naturebuilder_centaur",
    -- "tower_naturebuilder_centaur_warrunner",
    -- "tower_naturebuilder_druid_bear",
    -- "tower_naturebuilder_flower_tower",
    -- "tower_naturebuilder_hyena",
    -- "tower_naturebuilder_iron_bear",
    -- "tower_naturebuilder_shroom",
    -- "tower_naturebuilder_spider",
    -- "tower_naturebuilder_treant",
    -- "tower_naturebuilder_treebeard",
}
