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
	self.thunder_magic_increase = self:GetAbility():GetSpecialValueFor( "magic_increase_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:OnRefresh( kv )
	self.thunder_magic_increase = self:GetAbility():GetSpecialValueFor( "magic_increase_percent" )
	if IsServer() then
		--
	end
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_TOOLTIP
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:GetModifierMagicalResistanceBonus( params )
	return self.thunder_magic_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:GetModifierMagicDamageOutgoing_Percentage( params )
	return self.thunder_magic_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_elementalbuilder_passive_thunder_lua:OnTooltip( params )
	return self.thunder_magic_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------