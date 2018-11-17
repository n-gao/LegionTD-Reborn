function SplitShotLaunch(keys)
    local caster = keys.caster
    local casterLocation = caster:GetAbsOrigin()
    local ability = keys.ability
    local modifierName = keys.modifiername

    -- Targeting variables
    local targetType = ability:GetAbilityTargetType()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetFlags = ability:GetAbilityTargetFlags()
    local attackTarget = caster:GetAttackTarget()

    --ability variables
    local radius = caster:GetAttackRange()
    local maxTargets = Game:GetActivePlayerInTeam(caster:GetTeamNumber()) - 1
    local projectileSpeed = caster:GetProjectileSpeed()
    local projectile = keys.split_shot_projectile
    
    local targets = FindUnitsInRadius(caster:GetTeam(), casterLocation, nil, radius, targetTeam, targetType, targetFlags, FIND_CLOSEST, false)
    
    -- Create projectiles for units that are not the casters current attack target
    for _, target in pairs(targets) do
        -- If we reached the maximum amount of targets then break the loop
        if maxTargets == 0 then break end

        if target ~= attackTarget then
            local projectileInfo =
            {
                EffectName = projectile,
                Ability = ability,
                vSpawnOrigin = casterLocation,
                Target = target,
                Source = caster,
                bHasFrontalCone = false,
                iMoveSpeed = projectileSpeed,
                bReplaceExisting = false,
                bProvidesVision = false
            }
            ProjectileManager:CreateTrackingProjectile(projectileInfo)
            maxTargets = maxTargets - 1
        end
    end
end

function SplitShotDamage(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local dmgPerc = keys.ability:GetSpecialValueFor("damge_perc")

    local damage_table = {}

    damage_table.attacker = caster
    damage_table.victim = target
    damage_table.damage_type = ability:GetAbilityDamageType()
    damage_table.damage = caster:GetAttackDamage() * dmgPerc

    ApplyDamage(damage_table)
end
