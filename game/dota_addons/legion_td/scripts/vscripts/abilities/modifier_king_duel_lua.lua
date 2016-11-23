modifier_king_duel_lua = class({})

--------------------------------------------------------------------------------
function modifier_king_duel_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, --GetModifierExtraHealthPercentage
        -- MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, --GetModifierHealthRegenPercentage -- doesn't work with negatives
        MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, --GetModifierBaseDamageOutgoing_Percentage
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, --GetModifierConstantHealthRegen
    }

    return funcs
end

--------------------------------------------------------------------------------
function modifier_king_duel_lua:GetModifierExtraHealthPercentage() -- needs to be a float because valve
    return -.3
end

--------------------------------------------------------------------------------
function modifier_king_duel_lua:GetModifierConstantHealthRegen()
    parent = self:GetParent()
    stacks = parent:GetModifierStackCount("boss_upgrade_regen_stack", parent)
    regen = parent:GetBaseHealthRegen()
    print("stax: " .. stacks .. " Regen: " .. regen)
    return regen * -.2
end

--------------------------------------------------------------------------------

-- function modifier_king_duel_lua:GetModifierHealthRegenPercentage() -- doesn't seem to work with negative values

-- end

--------------------------------------------------------------------------------
function modifier_king_duel_lua:GetModifierBaseDamageOutgoing_Percentage()
    return -15
end
