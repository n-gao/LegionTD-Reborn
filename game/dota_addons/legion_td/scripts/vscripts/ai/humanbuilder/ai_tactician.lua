--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorBolt, BehaviorAngel })
end

function AIThink() -- For some reason AddThinkToEnt doesn't accept member functions
    return behaviorSystem:Think()
end

--------------------------------------------------------------------------------------------------------

BehaviorNone = {}

function BehaviorNone:Evaluate()
    return 1 -- must return a value > 0, so we have a default
end

function BehaviorNone:Begin()
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
        Position = thisEntity.nextTarget
    }
end

function BehaviorNone:Continue()
    self.endTime = GameRules:GetGameTime() + .1
end

--------------------------------------------------------------------------------------------------------

BehaviorBolt = {}

function BehaviorBolt:Evaluate()
    self.boltAbility = thisEntity:FindAbilityByName("tactician_storm_bolt")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.boltAbility and self.boltAbility:IsFullyCastable() then
        local range = self.boltAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
        if #enemies > 0 then target = enemies[1] end
    end

    if target then
        desire = 3
        self.target = target
    else
        desire = 0
    end

    return desire
end

function BehaviorBolt:Begin()
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = self.target:entindex(),
        AbilityIndex = self.boltAbility:entindex()
    }
end

BehaviorBolt.Continue = BehaviorBolt.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorAngel = {}

function BehaviorAngel:Evaluate()
    self.angelAbility = thisEntity:FindAbilityByName("tactician_guardian_angel")
    local target
    local desire = 0

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.angelAbility and self.angelAbility:IsFullyCastable() then
        local range = self.angelAbility:GetCastRange()
        local allies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        --print ("tactician guardian angel allies number considering: " .. #allies .. " (" .. range .. " range)")
        for _, unit in pairs(allies) do
            local healthLost = unit:GetMaxHealth() - unit:GetHealth()
            if healthLost > (unit:GetMaxHealth() * .4) then --only cast if unit has lost at least 40% of its health
                desire = 8
                break
            end
        end
    end

    return desire
end

function BehaviorAngel:Begin()
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = nil,
        AbilityIndex = self.angelAbility:entindex()
    }


    local units = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, self.angelAbility:GetCastRange(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_CLOSEST, false)

    local cooldown = self.angelAbility:GetCooldown(self.angelAbility:GetLevel() - 1)

    print("found " .. #units .. "friendly units ")

    for _, unit in pairs(units) do
        if unit ~= thisEntity then
            local unitGuardian = unit:FindAbilityByName("tactician_guardian_angel")
            if unitGuardian then
                unitGuardian:StartCooldown(600)
                print("Putting a guardian angel on cooldown")
            end
        end
    end
end

BehaviorAngel.Continue = BehaviorAngel.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorBolt, BehaviorAngel }
