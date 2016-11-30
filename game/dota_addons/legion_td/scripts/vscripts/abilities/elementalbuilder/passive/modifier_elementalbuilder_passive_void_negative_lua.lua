modifier_elementalbuilder_passive_void_negative_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:GetTexture()
    return "enigma_midnight_pulse"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:OnCreated(kv)
    self.void_damage_increase = self:GetAbility():GetSpecialValueFor("incomingdamage_increase_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:OnRefresh(kv)
    self.void_damage_increase = self:GetAbility():GetSpecialValueFor("incomingdamage_increase_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:GetModifierIncomingDamage_Percentage(params)
    return self.void_damage_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:OnTooltip(params)
    return self.void_damage_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_void_negative_lua:IsDebuff()
    return true
end
