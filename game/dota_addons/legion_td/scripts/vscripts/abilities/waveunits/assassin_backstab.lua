function BackstabHit(event)
    local caster = event.caster
    local target = event.target
    local maxAngle = event.ability:GetSpecialValueFor("angle")
    local victim_angle = target:GetAnglesAsVector().y
    local origin_difference = target:GetAbsOrigin() - caster:GetAbsOrigin()
    local origin_difference_radian = math.atan2(origin_difference.y, origin_difference.x)
    origin_difference_radian = origin_difference_radian * 180
    local attacker_angle = origin_difference_radian / math.pi
    attacker_angle = attacker_angle + 180.0
    local result_angle = attacker_angle - victim_angle
    result_angle = math.abs(result_angle)
    if result_angle >= (180 - (maxAngle / 2)) and result_angle <= (180 + (maxAngle / 2)) and not target:IsBuilding() then
        local mult = event.ability:GetSpecialValueFor("extra_damage")
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = caster:GetAttackDamage() * mult,
            damage_type = DAMAGE_TYPE_PHYSICAL,
        }
        EmitSoundOn("Hero_Riki.Backstab", target)
        CreateEffect({
            entitiy = target,
            effect = "particles/units/heroes/hero_riki/riki_backstab.vpcf"
        })
        ApplyDamage(damageTable)
    end
end
