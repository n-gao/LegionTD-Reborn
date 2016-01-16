modifier_elementalbuilder_passive_thunder_lua = class({})

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:IsHidden()
	if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:GetTexture()
	return "razor_plasma_field"
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:OnCreated( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:OnRefresh( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:GetModifierPercentageCooldown( params )
	return self.void_cooldown_reduction * self:GetStackCount()
end

--------------------------------------------------------------------------------