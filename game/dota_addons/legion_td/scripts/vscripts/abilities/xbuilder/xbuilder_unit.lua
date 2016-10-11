function sell(event)
	local unit = event.caster.unit
	local player = unit.player
	unit:RemoveNPC()
	Timers:CreateTimer(1, function ()
			UTIL_RemoveImmediate(unit.npc)
		end)
	local gold = unit.goldCost / 2
	if unit.buyround == Game:GetCurrentRound() then
		gold = unit.goldCost
	end

	PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
	table.remove(unit.player.units, unit.player:GetUnitKey(unit))

	local name = unit.npcclass
	local baseunit
	for i,v in pairs(event["caster"]["player"]["units"]) do
		if v.npcclass == "tower_xbuilder_baseunit" then
			baseunit = v
			break
		end
	end
	if name == "tower_xbuilder_offensiveunit" then
		baseunit.offensiveSlotCount = baseunit.offensiveSlotCount+1
	elseif name == "tower_xbuilder_defensiveunit" then
		baseunit.defensiveSlotCount = baseunit.defensiveSlotCount+1
	elseif name == "tower_xbuilder_utilityunit" then
		baseunit.utilitySlotCount = baseunit.utilitySlotCount+1
	elseif name == "tower_xbuilder_abilityunit" then
		baseunit.abilitySlotCount = baseunit.abilitySlotCount+1
	end

	player:RefreshPlayerInfo()
end


function UnitSpawn(event)
	if not Game:IsBetweenRounds() then
		local playerid = event.caster.player.playerID
		local player = Game:FindPlayerWithID(playerid)
		player:SendErrorCode(LEGION_ERROR_BETWEEN_ROUNDS)
		return
	end

	local name = Unit.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID"))

	local baseunit
	for i,v in pairs(event["caster"]["player"]["units"]) do
		if v.npcclass == "tower_xbuilder_baseunit" then
			baseunit = v
		end
	end
	
	if name == "tower_xbuilder_baseunit" then
		if baseunit then
			local playerid = event.caster.player.playerID
			local player = Game:FindPlayerWithID(playerid)
			player:SendErrorCode(LEGION_ERROR_UNIT_LIMIT_REACHED)
			PlayerResource:ModifyGold(playerid, event.ability:GetGoldCost(event.ability:GetLevel()), true, DOTA_ModifyGold_Unspecified)
			return
		end
		local unit = Unit.new(Unit.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")), 
			event.unit:GetCursorPosition(), 
			event.caster, 
			event.ability:GetSpecialValueFor("food_cost"), 
			event.ability:GetGoldCost(event.ability:GetLevel()))
		unit.offensiveSlotCount = 1
		unit.defensiveSlotCount = 1
		unit.utilitySlotCount = 1
		unit.abilitySlotCount = 1

	elseif not baseunit then
		local playerid = event.caster.player.playerID
		local player = Game:FindPlayerWithID(playerid)
		player:SendErrorCode(LEGION_ERROR_UNIT_LIMIT_REACHED)
		PlayerResource:ModifyGold(playerid, event.ability:GetGoldCost(event.ability:GetLevel()), true, DOTA_ModifyGold_Unspecified)
		return

	elseif name == "tower_xbuilder_offensiveunit" then
		if baseunit.offensiveSlotCount > 0 then
			baseunit.offensiveSlotCount = baseunit.offensiveSlotCount-1
			local unit = Unit.new(Unit.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")), 
				event.unit:GetCursorPosition(), 
				event.caster, 
				event.ability:GetSpecialValueFor("food_cost"), 
				event.ability:GetGoldCost(event.ability:GetLevel()))

			unit.npc:SetRenderColor(255,0,0)

			pidx = ParticleManager:CreateParticle("particles/xbuilder/wisp_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, Game:FindPlayerWithID(event.caster.player.playerid))
			ParticleManager:SetParticleControl(pidx, 15, Vector(255,1,1))

			for i,v in pairs(unit.npc:GetChildren()) do
				if v:GetClassname() == "dota_item_wearable" then
					v:SetRenderColor(255,0,0)
					print(2)
				end
				print(v:GetClassname())
			end
		else
			local playerid = event.caster.player.playerID
			local player = Game:FindPlayerWithID(playerid)
			player:SendErrorCode(LEGION_ERROR_UNIT_LIMIT_REACHED)
			PlayerResource:ModifyGold(playerid, event.ability:GetGoldCost(event.ability:GetLevel()), true, DOTA_ModifyGold_Unspecified)
			return
		end

	elseif name == "tower_xbuilder_defensiveunit" then

	elseif name == "tower_xbuilder_utilityunit" then

	elseif name == "tower_xbuilder_abilityunit" then

	else
		print("Tried to spawn non xbuilder unit!")
	end

	event.caster.player:RefreshPlayerInfo()
end


function UpgradeUnit(event)
	local id = event.ability:GetSpecialValueFor("unitID")
	playerid = event.unit:GetPlayerOwnerID()
	local newclass = Unit.GetUnitNameByID(id)
	event.caster.unit.npcclass = newclass
	event.caster.unit:Respawn()
	event.caster.unit.foodCost = event.caster.unit.foodCost
		+ event.ability:GetSpecialValueFor("food_cost")
	event.caster.unit.goldCost = event.caster.unit.goldCost
		+ event.ability:GetGoldCost(event.ability:GetLevel())
	PlayerResource:NewSelection(playerid, event.caster.unit.npc)
end