-- From Dota 2 Spell Library https://github.com/Pizzalol/SpellLibrary
--[[Author: YOLOSPAGHETTI
	Date: February 4, 2016
	Checks if Riki is behind his target
	Borrows heavily from bristleback.lua]]
	
function CheckBackstab(params)
	
	local ability = params.ability
	local multiplier = ability:GetSpecialValueFor("dmg_multiplier") - 1
	local backstabAngle = ability:GetSpecialValueFor("backstab_angle") / 2

	-- The y value of the angles vector contains the angle we actually want: where units are directionally facing in the world.
	local victim_angle = params.target:GetAnglesAsVector().y
	local origin_difference = params.target:GetAbsOrigin() - params.attacker:GetAbsOrigin()

	-- Get the radian of the origin difference between the attacker and Riki. We use this to figure out at what angle the victim is at relative to Riki.
	local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
	
	-- Convert the radian to degrees.
	origin_difference_radian = origin_difference_radian * 180
	local attacker_angle = origin_difference_radian / math.pi
	-- Makes angle "0 to 360 degrees" as opposed to "-180 to 180 degrees" aka standard dota angles.
	attacker_angle = attacker_angle + 180.0
	
	-- Finally, get the angle at which the victim is facing Riki.
	local result_angle = attacker_angle - victim_angle
	result_angle = math.abs(result_angle)
	
	-- Check for the backstab angle.
	if result_angle >= (180 - (backstabAngle)) and result_angle <= (180 + (backstabAngle)) then 

		EmitSoundOn(params.sound, params.target)
		local particle = ParticleManager:CreateParticle(params.particle, PATTACH_ABSORIGIN_FOLLOW, params.target) 
		ParticleManager:SetParticleControlEnt(particle, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), true) 

		ApplyDamage({victim = params.target, attacker = params.attacker, damage = params.damage * multiplier, damage_type = ability:GetAbilityDamageType()})
	end
end
