LinkLuaModifier("modifier_assassinbuilder_snot_spray", "abilities/assassinbuilder/assassinbuilder_snot_spray.lua", LUA_MODIFIER_MOTION_NONE)


function snot_spray_hit( param )
	local ability = param.ability
	local target = param.target
	local caster = param.caster
	local radius = ability:GetSpecialValueFor("radius")
	local targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)

	for _,unit in pairs(targets) do
		unit:AddNewModifier(caster, ability, "modifier_assassinbuilder_snot_spray", { duration = param.ability:GetSpecialValueFor("goo_duration") } )
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_assassinbuilder_snot_spray == nil then
	modifier_assassinbuilder_snot_spray = class({})
end

function modifier_assassinbuilder_snot_spray:RemoveOnDeath(  ) 
	return true 
end
function modifier_assassinbuilder_snot_spray:DestroyOnExpire(  ) 
	return true 
end
function modifier_assassinbuilder_snot_spray:IsHidden(  ) 
	return false
end

function modifier_assassinbuilder_snot_spray:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_assassinbuilder_snot_spray:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_assassinbuilder_snot_spray:GetTexture(  ) 
	return "bristleback_viscous_nasal_goo"
end

function modifier_assassinbuilder_snot_spray:GetAttributes(  ) 
	return MODIFIER_ATTRIBUTE_NONE
end 

function modifier_assassinbuilder_snot_spray:DeclareFunctions(  )
	return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_assassinbuilder_snot_spray:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attackspeed_base") + (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("attackspeed_per_stack"))
end

function modifier_assassinbuilder_snot_spray:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("armor_per_stack")
end

function modifier_assassinbuilder_snot_spray:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("base_move_slow") + (self:GetStackCount() * self:GetAbility():GetSpecialValueFor("move_slow_per_stack"))
end

function modifier_assassinbuilder_snot_spray:OnCreated( param ) 
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(1)
	end
end

function modifier_assassinbuilder_snot_spray:OnDestroy(  )
end

function modifier_assassinbuilder_snot_spray:OnRefresh( param )
	if IsServer() then
		stackcount = self:GetStackCount() or 0
		if stackcount < self:GetAbility():GetSpecialValueFor("stack_limit") then
			self:SetStackCount(stackcount+1)
		end
	end
end

function modifier_assassinbuilder_snot_spray:OnIntervalThink()
	if not IsServer() then return end
	local caster = self:GetCaster()
	local target = self:GetParent()
	local ability = self:GetAbility()
	local damage_per_second = ability:GetSpecialValueFor("damage_per_second")

	ApplyDamage({ victim = target, attacker = caster, damage = damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL })
end