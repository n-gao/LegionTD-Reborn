modifier_unit_freeze_lua = class({})

function modifier_unit_freeze_lua:IsDebuff()
    return true
end

function modifier_unit_freeze_lua:IsStunDebuff()
    return true
end

function modifier_unit_freeze_lua:IsHidden()
    return true
end

function modifier_unit_freeze_lua:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }

    return state
end
