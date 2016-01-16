modifier_elementalbuilder_passive_water_lua = class({})

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:IsHidden()
	if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:GetTexture()
	return "morphling_waveform"
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:OnCreated( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:OnRefresh( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_water_lua:GetModifierPercentageCooldown( params )
	return self.void_cooldown_reduction * self:GetStackCount()
end

--------------------------------------------------------------------------------