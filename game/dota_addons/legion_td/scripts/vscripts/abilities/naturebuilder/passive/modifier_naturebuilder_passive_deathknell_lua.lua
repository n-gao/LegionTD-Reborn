modifier_naturebuilder_passive_deathknell_lua = class({})

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:GetTexture()
	return "earthshaker_fissure"
end

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:OnCreated( kv )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_percent")
	self.heal_percent = self:GetAbility():GetSpecialValueFor( "heal_percent")
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:OnRefresh( kv )
	self.damage_percent = self:GetAbility():GetSpecialValueFor( "damage_percent")
	self.heal_percent = self:GetAbility():GetSpecialValueFor( "heal_percent")
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH , MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:OnDeath( params )

	-- for k, v in pairs(params) do
	-- 	print (k)
	-- 	print (v)
	-- 	print ("---")
	-- end

	local deadUnit = params.unit

	local deadUnitOwnerID = deadUnit:GetPlayerOwnerID()

	if self:GetParent():GetPlayerID() == deadUnitOwnerID then
		print ("ZZzzzzzaap!")

		-- do hurt

		local hurtAmount = deadUnit:GetMaxHealth()*(self.damage_percent/100)
		local enemies = FindUnitsInRadius( deadUnit:GetTeamNumber(), deadUnit:GetAbsOrigin(), deadUnit, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		local target = enemies[RandomInt(1, #enemies)]

		if target then
			ApplyDamage({ victim = target, attacker = deadUnit, damage = hurtAmount, damage_type = DAMAGE_TYPE_MAGICAL })

			local attackName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf" -- There are some light/medium/heavy unused versions
			local attack = ParticleManager:CreateParticle(attackName, PATTACH_ABSORIGIN_FOLLOW, deadUnit)
			ParticleManager:SetParticleControl(attack, 1, target:GetAbsOrigin())
		end

		-- do heal

		local healAmount = deadUnit:GetMaxHealth()*(self.heal_percent/100)
		local allies = FindUnitsInRadius( deadUnit:GetTeamNumber(), deadUnit:GetAbsOrigin(), deadUnit, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		local target = allies[1]

		if target then

			local missingHP = target:GetMaxHealth() - target:GetHealth()

			for k, v in pairs(allies) do
				if v:GetMaxHealth() - v:GetHealth() > missingHP then
					target = v
					missingHP = v:GetMaxHealth() - v:GetHealth()
				end
			end

			target:SetHealth(target:GetHealth()+healAmount)
			PopupHealing(target, math.floor(healAmount))

		end

	end

end

--------------------------------------------------------------------------------

function modifier_naturebuilder_passive_deathknell_lua:OnTooltip( params )
	return self.earth_armor_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------