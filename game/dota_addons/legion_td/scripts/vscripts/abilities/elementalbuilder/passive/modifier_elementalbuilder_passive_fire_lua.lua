modifier_elementalbuilder_passive_fire_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:GetTexture()
    return "lina_dragon_slave"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:OnCreated(kv)
    self.fire_damage_increase = self:GetAbility():GetSpecialValueFor("basedamagepercent_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:OnRefresh(kv)
    self.fire_damage_increase = self:GetAbility():GetSpecialValueFor("basedamagepercent_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:GetModifierBaseDamageOutgoing_Percentage(params)
    return self.fire_damage_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_fire_lua:OnTooltip(params)
    return self.fire_damage_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
