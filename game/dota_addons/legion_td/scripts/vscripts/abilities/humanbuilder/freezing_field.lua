--[[
    Author: kritth
    Date: 5.1.2015.
    Order the explosion in clockwise direction
]]
function freezing_field_order_explosion(keys)
    Timers:CreateTimer(0.0, function()
        keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_freezing_field_northwest_thinker_datadriven", {})
        return nil
    end)
end

--[[
    Author: kritth
    Date: 09.01.2015.
    Apply the explosion
]]
function freezing_field_explode(keys)
    local ability = keys.ability
    local caster = keys.caster
    local casterLocation = keys.caster:GetAbsOrigin()
    local abilityDamage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    local minDistance = ability:GetLevelSpecialValueFor("explosion_min_dist", (ability:GetLevel() - 1))
    local maxDistance = ability:GetLevelSpecialValueFor("explosion_max_dist", (ability:GetLevel() - 1))
    local radius = ability:GetLevelSpecialValueFor("explosion_radius", (ability:GetLevel() - 1))
    local debuffRadius = ability:GetLevelSpecialValueFor("debuff_radius", (ability:GetLevel() - 1))
    local modifierName = "modifier_freezing_field_debuff"
    local refModifierName = "modifier_freezing_field_ref_point_datadriven"
    local particleName = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"
    local soundEventName = "hero_Crystal.freezingField.explosion"
    local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local targetFlag = ability:GetAbilityTargetFlags() -- DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    local damageType = ability:GetAbilityDamageType()

    -- Get random point
    local castDistance = RandomInt(minDistance, maxDistance)
    local angle = RandomInt(0, 90)
    local dy = castDistance * math.sin(angle)
    local dx = castDistance * math.cos(angle)
    local attackPoint = Vector(0, 0, 0)

    -- lets find a random enemy unit to center on
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, maxDistance,
        targetTeam, targetType, targetFlag, 0, false)

    if #units > 0 then -- do we see any enemies?


        attackPoint = units[RandomInt(1, #units)]:GetAbsOrigin()


        Timers:CreateTimer(.4, function() -- we put damage on a delay so that it synchs better with the particle

            -- damage
            units = FindUnitsInRadius(caster:GetTeamNumber(), attackPoint, caster, radius, targetTeam, targetType, targetFlag, 0, false)
            for k, v in pairs(units) do
                local damageTable =
                {
                    victim = v,
                    attacker = caster,
                    damage = abilityDamage,
                    damage_type = damageType
                }
                ApplyDamage(damageTable)
            end

            -- debuff
            units = FindUnitsInRadius(caster:GetTeamNumber(), attackPoint, caster, debuffRadius, targetTeam, targetType, targetFlag, 0, false)
            for k, v in pairs(units) do
                ability:ApplyDataDrivenModifier(caster, v, modifierName, {})
            end
        end)

        -- Fire effect
        local fxIndex = ParticleManager:CreateParticle(particleName, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(fxIndex, 0, attackPoint)

        -- Fire sound at dummy
        -- local dummy = CreateUnitByName( "npc_dummy_unit", attackPoint, false, caster, caster, caster:GetTeamNumber() )
        -- ability:ApplyDataDrivenModifier( caster, dummy, refModifierName, {} )
        -- StartSoundEvent( soundEventName, dummy )
        -- Timers:CreateTimer( 0.1, function()
        --     dummy:ForceKill( true )
        --     return nil
        -- end )
    end
end
