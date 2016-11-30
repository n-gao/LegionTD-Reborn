modifier_elementalbuilder_passive_elemental_harmony_lua = class({})

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_elemental_harmony_lua:GetTexture()
    return "invoker_invoke"
end

--------------------------------------------------------------------------------
function modifier_elementalbuilder_passive_elemental_harmony_lua:IsHidden()
    if self:GetStackCount() > 0 then return true else return false end
end

--------------------------------------------------------------------------------
