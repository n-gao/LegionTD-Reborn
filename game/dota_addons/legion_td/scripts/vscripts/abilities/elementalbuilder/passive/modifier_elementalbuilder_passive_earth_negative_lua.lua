modifier_elementalbuilder_passive_earth_negative_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:GetTexture()
    return "earthshaker_fissure"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:OnCreated(kv)
    self.earth_armor_decrease = self:GetAbility():GetSpecialValueFor("armor_decrease")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:OnRefresh(kv)
    self.earth_armor_decrease = self:GetAbility():GetSpecialValueFor("armor_decrease")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:GetModifierPhysicalArmorBonus(params)
    return self.earth_armor_decrease * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:OnTooltip(params)
    return self.earth_armor_decrease * self:GetStackCount() * -1
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_negative_lua:IsDebuff()
    return true
end
