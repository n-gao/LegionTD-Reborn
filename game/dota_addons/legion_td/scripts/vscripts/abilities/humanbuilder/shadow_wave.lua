--[[Spell modified from spell library shadow wave, Original Author: Pizzalol on 09.02.2015.]]

function ShadowWave(keys)
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Ability variables
    local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)
    local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
    local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local heal = damage
    local unit_healed = false

    -- Particles
    local shadow_wave_particle = keys.shadow_wave_particle
    local shadow_wave_damage_particle = keys.damage_particle

    -- Setting up the damage and hit tables
    local hit_table = {}
    local hurt_table = {}
    local damage_table = {}
    damage_table.attacker = caster
    damage_table.damage_type = ability:GetAbilityDamageType()
    damage_table.ability = ability
    damage_table.damage = damage

    -- If the target is not the caster then do the extra bounce for the caster
    if target ~= caster then
        -- Insert the caster into the hit table
        table.insert(hit_table, caster)
        -- Heal the caster and do damage to the units around it
        caster:Heal(heal, caster)

        local units_to_damage = FindUnitsInRadius(caster:GetTeam(), caster_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

        for _, v in pairs(units_to_damage) do
            local check_unit = 0 -- Helper variable

            -- Checking the hurt table to see if we're already hurting this unit
            for c = 0, #hurt_table do
                if hurt_table[c] == v then
                    check_unit = 1
                end
            end

            -- Add the unit to the hurt table if it's not already
            if check_unit == 0 then
                table.insert(hurt_table, v)
            end
        end
    end

    -- Mark the target as already hit
    table.insert(hit_table, target)
    -- Heal the initial target and do the damage to the units around it
    target:Heal(heal, caster)
    local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

    for _, v in pairs(units_to_damage) do
        local check_unit = 0 -- Helper variable

        -- Checking the hurt table to see if we're already hurting this unit
        for c = 0, #hurt_table do
            if hurt_table[c] == v then
                check_unit = 1
            end
        end

        -- Add the unit to the hurt table if it's not already
        if check_unit == 0 then
            table.insert(hurt_table, v)
        end
    end


    -- Priority is Hurt Units > Units
    -- we start from 2 first because we healed 1 target already
    for i = 2, max_targets do
        -- Helper variable to keep track if we healed a unit already
        unit_healed = false

        -- Find all the units in bounce radius
        local units = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)

        -- HURT UNITS --
        -- check for hurt units if we havent healed a unit yet
        if not unit_healed then
            for _, unit in pairs(units) do
                local check_unit = 0 -- Helper variable to determine if the unit has been hit or not

                -- Checking the hit table to see if the unit is hit
                for c = 0, #hit_table do
                    if hit_table[c] == unit then
                        check_unit = 1
                    end
                end

                -- If its not hit then check if the unit is hurt
                if check_unit == 0 then
                    if unit:GetHealth() ~= unit:GetMaxHealth() then
                        -- After we find the hurt hero unit then we insert it into the hit table to keep track of it
                        -- and we also get the unit position
                        table.insert(hit_table, unit)
                        local unit_location = unit:GetAbsOrigin()

                        -- Create the particle for the visual effect
                        local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
                        ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

                        -- Set the unit as the new target
                        target = unit
                        target_location = unit_location

                        -- Heal it and deal damage to enemy units around it
                        target:Heal(heal, caster)
                        local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

                        for _, v in pairs(units_to_damage) do
                            local check_unit = 0 -- Helper variable

                            -- Checking the hurt table to see if we're already hurting this unit
                            for c = 0, #hurt_table do
                                if hurt_table[c] == v then
                                    check_unit = 1
                                end
                            end

                            -- Add the unit to the hurt table if it's not already
                            if check_unit == 0 then
                                table.insert(hurt_table, v)
                            end
                        end

                        -- Set the helper variable to true
                        unit_healed = true

                        break
                    end
                end
            end
        end

        -- UNITS --
        -- Search for units regardless if it is hurt or not
        -- Search only if we havent healed a unit yet
        if not unit_healed then
            for _, unit in pairs(units) do
                local check_unit = 0 -- Helper variable to determine if a unit has been hit or not

                -- Checking the hit table to see if the unit is hit
                for c = 0, #hit_table do
                    if hit_table[c] == unit then
                        check_unit = 1
                    end
                end

                -- If its not hit then do the bounce
                if check_unit == 0 then
                    -- Insert the found unit into the hit table
                    -- and we also get the unit position
                    table.insert(hit_table, unit)
                    local unit_location = unit:GetAbsOrigin()

                    -- Create the particle for the visual effect
                    local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
                    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
                    ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

                    -- Set the unit as the new target
                    target = unit
                    target_location = unit_location

                    -- Heal it and deal damage to enemy units around it
                    target:Heal(heal, caster)
                    local units_to_damage = FindUnitsInRadius(caster:GetTeam(), target_location, nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, ability:GetAbilityTargetType(), 0, 0, false)

                    for _, v in pairs(units_to_damage) do
                        local check_unit = 0 -- Helper variable

                        -- Checking the hurt table to see if we're already hurting this unit
                        for c = 0, #hurt_table do
                            if hurt_table[c] == v then
                                check_unit = 1
                            end
                        end

                        -- Add the unit to the hurt table if it's not already
                        if check_unit == 0 then
                            table.insert(hurt_table, v)
                        end
                    end

                    -- Set the helper variable to true
                    unit_healed = true

                    break
                end
            end
        end
    end
    -- print ("hurt_table")
    for _, v in pairs(hurt_table) do
        -- print (v)
        -- Play the particle
        local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(damage_particle, 0, v, PATTACH_POINT_FOLLOW, "attach_hitloc", v:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(damage_particle)

        damage_table.victim = v
        ApplyDamage(damage_table)
    end
end
