--[[Original Author: Pizzalol
	Date: 21.04.2015.
	Creates a dummy with a dummy deafening spell
	The dummy acts as the projectile while following the particle projectile]]
function deafening_blast_start(keys)
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local target_point = keys.target_points[1]
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Ability and projectile variables
    local knockback_duration = ability:GetSpecialValueFor("knockback_duration") + 0.1
    local travel_distance = ability:GetSpecialValueFor("travel_distance")
    local travel_speed = ability:GetSpecialValueFor("travel_speed")
    local radius_start = ability:GetSpecialValueFor("radius_start")
    local radius_end = ability:GetSpecialValueFor("radius_end")
    local dummy_ability_name = keys.dummy_ability_name
    local projectile_name = keys.projectile_name
    local direction = (target_point - caster_location):Normalized()

    -- Create the dummy
    local deafening_dummy = CreateUnitByName("npc_dummy_unit", caster_location, false, caster, caster, caster:GetTeamNumber())
    deafening_dummy:AddAbility(dummy_ability_name)

    -- Set up the dummy ability
    local dummy_ability = deafening_dummy:FindAbilityByName(dummy_ability_name)
    dummy_ability:SetLevel(1)

    -- Initialize the dummy calculation variables
    local distance_traveled = 0
    local dummy_speed = travel_speed * 1 / 30


    -- Create projectile
    local projectile_table =
    {
        EffectName = projectile_name,
        Ability = dummy_ability,
        vSpawnOrigin = caster_location,
        vVelocity = direction * travel_speed,
        fDistance = travel_distance,
        fStartRadius = radius_start,
        fEndRadius = radius_end,
        Source = deafening_dummy,
        bHasFrontalCone = true,
        bReplaceExisting = false,
        iUnitTargetTeam = ability:GetAbilityTargetTeam(),
        iUnitTargetFlags = ability:GetAbilityTargetFlags(),
        iUnitTargetType = ability:GetAbilityTargetType()
    }
    ProjectileManager:CreateLinearProjectile(projectile_table)

    -- Move the dummy
    Timers:CreateTimer(function()
        -- If the dummy traveled the whole distance then kill it
        if distance_traveled < travel_distance then
            -- Otherwise keep track of the distance traveled and set the new position
            local dummy_location = deafening_dummy:GetAbsOrigin() + direction * dummy_speed
            deafening_dummy:SetAbsOrigin(dummy_location)
            distance_traveled = distance_traveled + dummy_speed

            return 1 / 30
        else
            -- Remove the dummy after the knockback duration to allow all the modifiers to be applied
            Timers:CreateTimer(knockback_duration, function()
                deafening_dummy:RemoveSelf()
            end)
        end
    end)
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers upon hitting a target
	Deals damage depending on Exort and applies the knockback modifier depending on Quas]]
function deafening_blast_hit(keys)
    local caster = keys.caster -- Dummy
    local caster_owner = caster:GetOwner() -- Hero
    local target = keys.target
    local ability = keys.ability
    local owner_ability = caster_owner:FindAbilityByName("soundmaster_deafening_blast")

    -- Ability variables
    local damage = owner_ability:GetSpecialValueFor("damage")
    local knockback_duration = owner_ability:GetSpecialValueFor("knockback_duration")
    local knockback_modifier = keys.knockback_modifier

    -- Apply the knockback modifier
    ability:ApplyDataDrivenModifier(caster, target, knockback_modifier, { duration = knockback_duration })

    -- Initialize the damage table and deal the damage
    local damage_table = {}
    damage_table.attacker = caster_owner
    damage_table.victim = target
    damage_table.ability = owner_ability
    damage_table.damage_type = owner_ability:GetAbilityDamageType()
    damage_table.damage = damage

    ApplyDamage(damage_table)
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Keeps track of the caster and the direction in which to be knocked back]]
function deafening_blast_knockback_start(keys)
    local caster = keys.caster -- Dummy
    local caster_owner = caster:GetOwner() -- Hero
    local caster_location = caster:GetAbsOrigin()
    local target = keys.target
    local target_location = target:GetAbsOrigin()

    target.deafening_direction = (target_location - caster_location):Normalized()
    target.deafening_direction.x = 0
    target.deafening_direction.z = 0
    target.deafening_direction = target.deafening_direction:Normalized()
    target.deafening_caster = caster_owner
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers on an interval in the knockback modifier, moves the target]]
function deafening_blast_knockback(keys)
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local knockback_speed = 6

    local new_location = target_location + target.deafening_direction * knockback_speed
    target:SetAbsOrigin(GetGroundPosition(new_location, target))
end

--[[Author: Pizzalol
	Date: 21.04.2015.
	Triggers upon the expiration of the knockback modifier
	Applies a disarm modifier depending on the Wex level]]
function deafening_blast_disarm(keys)
    local target = keys.target
    local caster = target.deafening_caster -- Hero
    local ability = keys.ability -- Dummy ability
    local owner_ability = caster:FindAbilityByName("soundmaster_deafening_blast")

    local disarm_duration = owner_ability:GetSpecialValueFor("disarm_duration")
    local disarm_modifier = keys.disarm_modifier

    FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)

    -- Check if the target is alive(to prevent errors when the deafening blast is the killing blow)
    if target:IsAlive() and ability then
        ability:ApplyDataDrivenModifier(caster, target, disarm_modifier, { duration = disarm_duration })
    end
end
