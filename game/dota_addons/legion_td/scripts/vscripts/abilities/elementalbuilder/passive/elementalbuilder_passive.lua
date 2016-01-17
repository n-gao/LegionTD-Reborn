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
	LinkLuaModifier( "modifier_elementalbuilder_passive_elemental_harmony_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_elemental_harmony_lua.lua" ,LUA_MODIFIER_MOTION_NONE )



	local ability = keys.ability
	local caster = keys.caster
	local elementNames = {"water", "thunder", "earth", "fire", "void"}
	local elementNames_inv = table_invert(elementNames)
	local elementSums = {}
	local elementRatios = {}
	local elementStacks = {}
	local elementGods = {}
	local maxStacks = 10

	Timers:CreateTimer(function()

		id = caster:GetPlayerID()
		playerObj = Game:FindPlayerWithID(id)

		print ("u have " .. #playerObj.units )

		for _, element in pairs (elementNames) do
			elementSums[element] = 0
			elementRatios[element] = 0
			elementStacks[element] = 0
			elementGods[element] = nil
		end

		local valueSum = 0 -- total value of all towers without god-overseen elements

		for _, unitRef in pairs(playerObj.units) do -- lets look for gods first
			unitName = unitRef.npcclass
			for _, element in pairs(elementNames) do
				if string.find(unitName, element) then
					if string.find(unitName, "god") then
						elementGods[element] = true
					end
				end
			end
		end

		for _, unitRef in pairs(playerObj.units) do
			unitName = unitRef.npcclass
			for _, element in pairs(elementNames) do
				if string.find(unitName, element) then
					elementSums[element] = elementSums[element] + unitRef.goldCost
					if not elementGods[element] then
						valueSum = valueSum + unitRef.goldCost -- elements only add to value sum if they have no god
					end
					break -- each unit is only one element, right??
				end
			end
		end

		local elementCount = 0

		for _, element in pairs(elementNames) do
			if elementSums[element] > 0 and not elementGods[element] then
				elementCount = elementCount + 1
			end
		end

		local valueAvg = valueSum / elementCount

		print ("Element Count: " .. elementCount .. ", Total value: " .. valueSum .. ", average " .. valueAvg)

		for element, total in pairs(elementSums) do
			elementRatios[element] = total / valueAvg
			if elementGods[element] then
				elementStacks[element] = 0
				print (element .. " has a god!")
			elseif elementRatios[element] >= 1 then
				elementStacks[element] = -math.floor(5*(1-(elementRatios[element])))
				print (element .. ": " .. total .. "(" .. elementRatios[element] .. " surplus), " .. elementStacks[element] .. " stacks")
			else
				elementStacks[element] = math.floor(5*(1-(1/elementRatios[element])))
				print (element .. ": " .. total .. "(" .. 1/elementRatios[element] .. " defecit), " .. elementStacks[element] .. " stacks")
			end
		end

		-- check for elemental harmony

		local harmony = true

		for _, element in pairs(elementNames) do
			if elementSums[element] == 0 then harmony = false end
			if (elementStacks[element] > 1) or (elementStacks[element] < -1) then harmony = false end
		end

		if harmony then
			print ("we have harmony")
			for _, element in pairs(elementNames) do
				elementStacks[element] = maxStacks
			end
		end

		for _, unitRef in pairs(playerObj.units) do
			local unit = unitRef.npc
			if unit then

				unit:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_elemental_harmony_lua", {})

				if harmony then
					unit:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 0)
				else
					unit:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 1)
				end

				for _, element in pairs(elementNames) do
					if elementSums[element] > 0 then
						unit:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_lua", {})
						unit:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_negative_lua", {})
						if elementStacks[element] < 0 then
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0)
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, math.min(maxStacks,0-elementStacks[element]-1))
						else
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, math.min(maxStacks,elementStacks[element]-1))
							unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
						end
					end
				end
			end
		end

		--apply the modifiers to the hero as well for display


		caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_elemental_harmony_lua", {})

		if harmony then
			caster:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 0)
		else
			caster:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 1)
		end

		for _, element in pairs(elementNames) do
			caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_lua", {})
			caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_".. element .."_negative_lua", {})
			if elementSums[element] > 0 then
				if elementStacks[element] < 0 then
					caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0)
					caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, math.min(maxStacks,0-elementStacks[element]-1))
				else
					caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, math.min(maxStacks,elementStacks[element]-1))
					caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
				end
			else
				caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0))
				caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
			end
		end
		
		return 1 -- slowish
	end)	
end
