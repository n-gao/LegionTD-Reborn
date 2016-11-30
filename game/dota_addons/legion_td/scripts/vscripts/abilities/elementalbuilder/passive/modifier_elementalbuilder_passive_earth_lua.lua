modifier_elementalbuilder_passive_earth_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:IsHidden()
    if self:GetStackCount() < 1 then return true else return false end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:GetTexture()
    return "earthshaker_fissure"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:OnCreated(kv)
    self.earth_armor_increase = self:GetAbility():GetSpecialValueFor("armor_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:OnRefresh(kv)
    self.earth_armor_increase = self:GetAbility():GetSpecialValueFor("armor_increase")
    if IsServer() then
        --
    end
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:GetModifierPhysicalArmorBonus(params)
    return self.earth_armor_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_earth_lua:OnTooltip(params)
    return self.earth_armor_increase * self:GetStackCount()
end

--------------------------------------------------------------------------------
