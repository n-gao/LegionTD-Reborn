modifier_elementalbuilder_passive_thunder_negative_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:GetTexture()
    return "razor_plasma_field"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:OnCreated(kv)
    self.thunder_magic_decrease = self:GetAbility():GetSpecialValueFor("magic_decrease_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:OnRefresh(kv)
    self.thunder_magic_decrease = self:GetAbility():GetSpecialValueFor("magic_decrease_percent")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:OnTooltip(params)
    return self.thunder_magic_decrease * self:GetStackCount() * -1
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_thunder_negative_lua:IsDebuff()
    return true
end

