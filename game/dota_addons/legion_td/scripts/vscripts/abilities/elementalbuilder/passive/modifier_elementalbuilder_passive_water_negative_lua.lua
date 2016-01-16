modifier_elementalbuilder_passive_water_negative_lua = class({})

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:IsHidden()
	if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:GetTexture()
	return "morphling_waveform"
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:OnCreated( kv )
	self.void_cooldown_increase = self:GetAbility():GetSpecialValueFor( "cooldown_increase_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:OnRefresh( kv )
	self.void_cooldown_increase = self:GetAbility():GetSpecialValueFor( "cooldown_increase_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:GetModifierPercentageCooldown( params )
	return self.void_cooldown_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_negative_lua:IsDebuff()
	return true
end