


function Game:WikiCommand()

	local filePath = "../../dota_addons/legion_td/scripts/legion_td_reborn_wiki.txt"
	local file = io.open(filePath, "w")
	local unitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	local abilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	local engKV = LoadKeyValues("resource/addon_english.txt")

	local builder_list = {"naturebuilder", "elementalbuilder", "humanbuilder"}
	local builder_list_inv = table_invert(builder_list)

	local relevant_stats = {"StatusHealth", "AttackRate", "AttackDamageMin", "AttackDamageMax",
							"ArmorPhysical", "MagicalResistance", "AttackRange",
							"Ability1", "Ability2", "Ability3", "Ability4", "Ability5", "Ability6",
							"Ability7", "Ability8", "Ability9", "Ability10", "Ability11", "Ability12",
							"Ability13", "Ability14", "Ability15", "Ability16",
							"BountyGoldMin", "BountyGoldMax", "AttackAcquisitionRange"}
	local relevant_stats_inv = table_invert(relevant_stats)

	for unitname, unittable in pairs(unitKV) do
		local buildername = string.match(unitname, "tower_")
		if buildername then 
			for k, v in pairs(unittable) do
				if type(v) ~= "table" and relevant_stats_inv[k] then
					if engKV["Tokens"]["DOTA_Tooltip_ability_"..v] then
						print("eng name found")
						file:write("unit " .. unitname .. " " .. k .. ", " .. engKV["Tokens"]["DOTA_Tooltip_ability_"..v] .. "\n")
					else
						file:write("unit " .. unitname .. " " .. k .. ", " .. v .. "\n")
					end
				end
			end
		end
	end

	file:close()

	print ("write was okay")
end


function table_invert(t)
   local s={}
   for k,v in pairs(t) do
     s[v]=k
   end
   return s
end

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end