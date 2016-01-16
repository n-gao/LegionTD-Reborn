function elementalbuilder_passive_start(keys)
	LinkLuaModifier( "modifier_elementalbuilder_passive_earth_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_earth_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_earth_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_earth_negative_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_fire_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_fire_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_fire_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_fire_negative_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_thunder_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_thunder_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_thunder_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_thunder_negative_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_void_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_void_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_void_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_void_negative_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_water_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_water_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	LinkLuaModifier( "modifier_elementalbuilder_passive_water_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_water_negative_lua.lua" ,LUA_MODIFIER_MOTION_NONE )
	local ability = keys.ability
	local caster = keys.caster
	local elementNames = {"water", "thunder", "earth", "fire", "void"}
	local elementNames_inv = table_invert(elementNames)
	local elementSums = {}
	local elementRatios = {}
	local elementStacks = {}
	local maxStacks = 20

	print ("grepple")


	Timers:CreateTimer(function()

		id = caster:GetPlayerID()
		playerObj = Game:FindPlayerWithID(id)

		print ("dur dur u have " .. #playerObj.units )

		for _, element in pairs (elementNames) do
			elementSums[element] = 0
			elementRatios[element] = 0
			elementStacks[element] = 0
		end

		local valueSum = 0

		for _, unitRef in pairs(playerObj.units) do
			unitName = unitRef.npcclass
			for _, element in pairs(elementNames) do
				if string.find(unitName, element) then
					elementSums[element] = elementSums[element] + unitRef.goldCost
					valueSum = valueSum + unitRef.goldCost
					break -- each unit is only one element, right??
				end
			end
		end

		local elementCount = 0

		for _, element in pairs(elementNames) do
			if elementSums[element] > 0 then
				elementCount = elementCount + 1
			end
		end

		local valueAvg = valueSum / elementCount

		print ("Total value: " .. valueSum .. ", average " .. valueAvg)

		for element, total in pairs(elementSums) do
			elementRatios[element] = total / valueAvg
			if elementRatios[element] >= 1 then
				elementStacks[element] = -math.floor(10*(1-(elementRatios[element])))
				print (element .. ": " .. total .. "(" .. elementRatios[element] .. " surplus), " .. elementStacks[element] .. " stacks")
			else
				elementStacks[element] = math.floor(10*(1-(1/elementRatios[element])))
				print (element .. ": " .. total .. "(" .. 1/elementRatios[element] .. " defecit), " .. elementStacks[element] .. " stacks")
			end
		end

		for _, unitRef in pairs(playerObj.units) do
			local unit = unitRef.npc
			if unit then
				for _, element in pairs(elementNames) do
					if elementSums[element] > 0 then
						unit:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_lua", {})
						unit:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_negative_lua", {})
						if elementStacks[element] < 0 then
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0)
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, math.min(maxStacks,0-elementStacks[element])-1)
						else
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, math.min(maxStacks,elementStacks[element])-1)
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
						end
					end
				end
			end
		end

		return 1 -- slowish
	end)	
end
