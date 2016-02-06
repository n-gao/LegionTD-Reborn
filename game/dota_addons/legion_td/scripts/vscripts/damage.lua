function Game:DamageFilter( filterTable )
	--for k, v in pairs( filterTable ) do
	--	print("Damage: " .. k .. " " .. tostring(v) )
	--end
	local victim_index = filterTable["entindex_victim_const"]
	local attacker_index = filterTable["entindex_attacker_const"]
	if not victim_index or not attacker_index then
		return true
	end

	local victim = EntIndexToHScript( victim_index )
	local attacker = EntIndexToHScript( attacker_index )
	local damagetype = filterTable["damagetype_const"]

	-- Physical attack damage filtering
	if damagetype == DAMAGE_TYPE_PHYSICAL then
		local original_damage = filterTable["damage"] --Post reduction

		if not Game.UnitKV[attacker:GetUnitName()] then return true end
		if not Game.UnitKV[victim:GetUnitName()] then return true end

		local attack_type = Game.UnitKV[attacker:GetUnitName()]["Legion_AttackType"] or "none"
		local defend_type = Game.UnitKV[victim:GetUnitName()]["Legion_DefendType"] or "none"

		if attack_type == "none" or defend_type == "none" then return true end

		local damage_multiplier = Game.DamageKV[attack_type][defend_type] or 1

		--print (attacker:GetUnitName() .. "(" .. attack_type .. ") vs " .. victim:GetUnitName() .. "(" .. defend_type .. "), damage multiplied by " .. damage_multiplier)

		local damage = original_damage * damage_multiplier

		-- Reassign the new damage
		filterTable["damage"] = damage
	
	-- Magic damage filtering
	elseif damagetype == DAMAGE_TYPE_MAGICAL then

	end

	return true
end

DAMAGE_TYPES = {
    [0] = "DAMAGE_TYPE_NONE",
    [1] = "DAMAGE_TYPE_PHYSICAL",
    [2] = "DAMAGE_TYPE_MAGICAL",
    [4] = "DAMAGE_TYPE_PURE",
    [7] = "DAMAGE_TYPE_ALL",
    [8] = "DAMAGE_TYPE_HP_REMOVAL",
}
