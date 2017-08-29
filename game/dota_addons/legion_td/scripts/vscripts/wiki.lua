function Game:WikiCommand()
    
    local filePath = "../../dota_addons/legion_td/scripts/legion_td_reborn_wiki.txt"
    local file = io.open(filePath, "w")
    local unitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    local abilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    local engKV = LoadKeyValues("resource/addon_english.txt")
    local heroKV = LoadKeyValues("scripts/npc/npc_heroes.custom.txt")
    
    local builder_list = {"naturebuilder", "elementalbuilder", "humanbuilder"}
    local builder_list_inv = table_invert(builder_list)
    
    local relevant_stats = {
        "StatusHealth", "AttackRate", "AttackDamageMin", "AttackDamageMax",
        "ArmorPhysical", "MagicalResistance", "AttackRange",
        "Ability1", "Ability2", "Ability3", "Ability4", "Ability5", "Ability6",
        "Ability7", "Ability8", "Ability9", "Ability10", "Ability11", "Ability12",
        "Ability13", "Ability14", "Ability15", "Ability16",
        "BountyGoldMin", "BountyGoldMax", "AttackAcquisitionRange"
    }
    local relevant_stats_inv = table_invert(relevant_stats)
    
    local relevant_astats = {"AbilityBehavior", "SpellImmunityType", "AbilityCastRange", "AbilityCooldown"}
    
    for _, buildername in builder_list do
        file:write(engKV["Tokens"][buildername] .. "\n")
        basic_units = {}
    -- for i = 1,6 do
    -- 	local basic_unit = heroKV[buildername][]
    -- end
    end
    
    
    
    
    for unitname, unittable in pairs(unitKV) do
        local buildername = string.match(unitname, "tower_")
        if buildername then
            for k, v in pairs(unittable) do
                if type(v) ~= "table" and relevant_stats_inv[k] then
                    if string.starts(k, "Ability") and v ~= "sell"
                        and not string.find(v, "builder_upgrade_") and not string.find(v, "ability_empty_") then
                        file:write(make_ability(v))
                    else
                        file:write("unit " .. unitname .. " " .. k .. ", " .. v .. "\n")
                    end
                end
            end
        end
    end
    
    file:close()
    
    print("write was okay")
end

function make_ability(abilityname)
    local unitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    local abilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    local engKV = LoadKeyValues("resource/addon_english.txt")
    print("make_ability for " .. abilityname)
    local output
    if engKV["Tokens"]["DOTA_Tooltip_ability_" .. abilityname] then
        output = engKV["Tokens"]["DOTA_Tooltip_ability_" .. abilityname]
    else
        output = abilityname
    end
    
    output = output .. "\n"
    
    if not abilityKV[abilityname] then return output .. "(same as dota)\n" end
    
    sAbilityBehavior = abilityKV[abilityname]["AbilityBehavior"] or "ABILITY_BEHAVIOR_NONE"
    tAbilityBehavior = split(sAbilityBehavior, "|", nil)
    
    output = output .. sAbilityBehavior .. "(" .. #tAbilityBehavior .. ")"
    
    output = output .. "\n"
    
    return output
end



function table_invert(t)
    local s = {}
    for k, v in pairs(t) do
        s[v] = k
    end
    return s
end

function string.starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function trim(s)
    -- from PiL2 20.4
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end

function split(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return {str}
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0 -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end
