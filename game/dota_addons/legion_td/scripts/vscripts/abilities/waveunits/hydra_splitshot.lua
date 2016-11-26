function SplitShotHit(event)
    local caster = event.caster
    local target = event.target
    local perc = event.ability:GetSpecialValueFor("damge_perc")
    local damageTable = {
        victim = target,
        attacker = caster,
        damage = caster:GetAttackDamage() * perc,
        damage_type = DAMAGE_TYPE_PHYSICAL,
    }
    ApplyDamage(damageTable)
end
