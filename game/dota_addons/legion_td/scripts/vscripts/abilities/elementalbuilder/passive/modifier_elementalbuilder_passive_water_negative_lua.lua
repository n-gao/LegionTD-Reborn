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
function modifier_elementalbuilder_passive_water_negative_lua:OnCreated(kv)
    self.water_attackspeed_reduction = self:GetAbility():GetSpecialValueFor("attackspeed_decrease")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_negative_lua:OnRefresh(kv)
    self.water_attackspeed_reduction = self:GetAbility():GetSpecialValueFor("attackspeed_decrease")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_negative_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_negative_lua:GetModifierAttackSpeedBonus_Constant(params)
    return self.water_attackspeed_reduction * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_negative_lua:OnTooltip(params)
    return self.water_attackspeed_reduction * self:GetStackCount() * -1
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_negative_lua:IsDebuff()
    return true
end
