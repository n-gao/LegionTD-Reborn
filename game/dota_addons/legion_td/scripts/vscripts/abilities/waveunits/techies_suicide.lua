function Suicide(keys)
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Ability variables
    local respawn_time_percentage = ability:GetLevelSpecialValueFor("respawn_time_percentage", ability_level)
    local vision_radius = ability:GetLevelSpecialValueFor("vision_radius", ability_level)
    local vision_duration = ability:GetLevelSpecialValueFor("vision_duration", ability_level)

    -- Insert modifiers into the table that would otherwise prevent a units death
    local exception_table = {}
    table.insert(exception_table, "modifier_dazzle_shallow_grave")
    table.insert(exception_table, "modifier_shallow_grave_datadriven")

    -- Remove the modifiers if they exist
    local modifier_count = caster:GetModifierCount()
    for i = 0, modifier_count do
        local modifier_name = caster:GetModifierNameByIndex(i)
        local modifier_check = false

        -- Compare if the modifier is in the exception table
        -- If it is then set the helper variable to true and remove it
        for j = 0, #exception_table do
            if exception_table[j] == modifier_name then
                modifier_check = true
                break
            end
        end

        -- Remove the modifier depending on the helper variable
        if modifier_check then
            caster:RemoveModifierByName(modifier_name)
        end
    end

    -- Create the vision and kill the caster
    ability:CreateVisibilityNode(caster_location, vision_radius, vision_duration)
    caster:Kill(ability, caster)
end

function DamageBosses(keys)
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local small_radius = ability:GetLevelSpecialValueFor("small_radius", ability_level)
    local big_radius = ability:GetLevelSpecialValueFor("big_radius", ability_level)
    local multiplier = ability:GetLevelSpecialValueFor("damage_boss_multiplier", ability_level)
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local partial_damage = ability:GetLevelSpecialValueFor("partial_damage", ability_level)
	local untis_in_small_radius = FindUnitsInRadius(caster:GetTeamNumber(),
                                    caster:GetOrigin(), 
                                    nil,                                    
                                    small_radius, 
                                    ability:GetAbilityTargetTeam(), 
                                    ability:GetAbilityTargetType(), 0, 0, false)
	local untis_in_big_radius = FindUnitsInRadius(caster:GetTeamNumber(),
                                    caster:GetOrigin(), 
                                    nil,                                    
                                    big_radius, 
                                    ability:GetAbilityTargetTeam(), 
                                    ability:GetAbilityTargetType(), 0, 0, false)
    for _, unit in pairs(untis_in_small_radius) do
        if unit:HasModifier("isBoss") then
            ApplyDamage({
                victim = unit,
                attacker = caster,
                damage = (damage - partial_damage) * multiplier,
                damage_type = ability:GetAbilityDamageType(),
                ability = ability
            })
        end
    end
    for _, unit in pairs(untis_in_big_radius) do
        if unit:HasModifier("isBoss") then
            ApplyDamage({
                victim = unit,
                attacker = caster,
                damage = partial_damage * multiplier,
                damage_type = ability:GetAbilityDamageType(),
                ability = ability
            })
        end
    end
end
