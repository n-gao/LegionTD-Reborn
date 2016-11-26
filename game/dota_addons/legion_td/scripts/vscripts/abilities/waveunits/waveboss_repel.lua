function RepelResetter(keys)
    print("waveboss_repel.lua")
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local cooldown = ability:GetCooldown(ability_level)
    local modifier_time = keys.timemodifier
    local modifier_spell = keys.spellmodifier
    print("locals")

    ability:StartCooldown(cooldown)
    caster:RemoveModifierByName(modifier_time)
    print("mod removed")

    ability:ApplyDataDrivenModifier(caster, caster, modifier_spell, {})

    print("spell applied")

    Timers:CreateTimer(cooldown, function()
        if caster and ability then
            --ability:ApplyDataDrivenModifier(caster, caster, modifier_time, {})
        end
    end)

    print("timer created")
end
