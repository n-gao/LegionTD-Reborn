function Jinada(keys)
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    local cooldown = ability:GetCooldown(ability:GetLevel() - 1)
    local caster = keys.caster
    local modifierName = keys.modifiername

    ability:StartCooldown(cooldown)

    caster:RemoveModifierByName(modifierName)

    Timers:CreateTimer(cooldown, function()
        if (not ability:IsNull()) then
            ability:ApplyDataDrivenModifier(caster, caster, modifierName, {})
        end
    end)
end
