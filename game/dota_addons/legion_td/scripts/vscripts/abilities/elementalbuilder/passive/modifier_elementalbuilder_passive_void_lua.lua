modifier_elementalbuilder_passive_void_lua = class({})

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_void_lua:OnCreated( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		self:SetStackCount( self:GetAbility():GetVoidBalance() )
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_void_lua:OnRefresh( kv )
	self.void_cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction_percent" )
	if IsServer() then
		self:GetParent():CalculateStatBonus()
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_void_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_void_lua:GetModifierPercentageCooldown( params )
	return self:GetStackCount() * self.void_cooldown_reduction
end

--------------------------------------------------------------------------------