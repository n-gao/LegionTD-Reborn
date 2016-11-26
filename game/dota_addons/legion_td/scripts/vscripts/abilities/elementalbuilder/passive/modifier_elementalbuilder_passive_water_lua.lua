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
function modifier_elementalbuilder_passive_water_lua:OnCreated(kv)
    self.water_attackspeed_increase = self:GetAbility():GetSpecialValueFor("attackspeed_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_lua:OnRefresh(kv)
    self.water_attackspeed_increase = self:GetAbility():GetSpecialValueFor("attackspeed_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_lua:GetModifierAttackSpeedBonus_Constant(params)
    return self.water_attackspeed_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_water_lua:OnTooltip(params)
    return self.water_attackspeed_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
