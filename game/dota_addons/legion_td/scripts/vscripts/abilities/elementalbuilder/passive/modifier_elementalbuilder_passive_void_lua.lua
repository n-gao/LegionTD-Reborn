modifier_elementalbuilder_passive_void_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:GetTexture()
    return "enigma_midnight_pulse"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:OnCreated(kv)
    self.void_damage_reduction = self:GetAbility():GetSpecialValueFor("incomingdamage_decrease_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:OnRefresh(kv)
    self.void_damage_reduction = self:GetAbility():GetSpecialValueFor("incomingdamage_decrease_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:GetModifierIncomingDamage_Percentage(params)
    return self.void_damage_reduction * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_lua:OnTooltip(params)
    return self.void_damage_reduction * self:GetStackCount() * -1
end

--------------------------------------------------------------------------------
