--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorBarrage, BehaviorCalldown, BehaviorFlak })
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

BehaviorFlak = {}

function BehaviorFlak:Evaluate()
    self.flakAbility = thisEntity:FindAbilityByName("futuristic_gyrocopter_flak_cannon")
    local desire = 0
    local blastDirection = nil

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.flakAbility and self.flakAbility:IsFullyCastable() then
        local range = self.flakAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
        if #enemies > 0 then target = true end
    end

    if target then
        desire = 3
    else
        desire = 0
    end

    return desire
end

function BehaviorFlak:Begin()

    self.endTime = GameRules:GetGameTime() + .2

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = nil,
        AbilityIndex = self.flakAbility:entindex(),
        Position = nil
    }
end

BehaviorFlak.Continue = BehaviorFlak.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorBarrage = {}

function BehaviorBarrage:Evaluate()
    self.barrageAbility = thisEntity:FindAbilityByName("futuristic_gyrocopter_rocket_barrage")
    local desire = 0
    local blastDirection = nil

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.barrageAbility and self.barrageAbility:IsFullyCastable() then
        local range = self.barrageAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
        if #enemies > 0 then target = true end
    end

    if target then
        desire = 4
    else
        desire = 0
    end

    return desire
end

function BehaviorBarrage:Begin()

    self.endTime = GameRules:GetGameTime() + .2

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = nil,
        AbilityIndex = self.barrageAbility:entindex(),
        Position = nil
    }
end

BehaviorBarrage.Continue = BehaviorBarrage.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorCalldown = {}

function BehaviorCalldown:Evaluate()
    self.calldownAbility = thisEntity:FindAbilityByName("futuristic_gyrocopter_call_down")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.calldownAbility and self.calldownAbility:IsFullyCastable() then
        local range = self.calldownAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
        for _, enemy in ipairs(enemies) do
            if enemy:IsAttacking() then target = enemy break end -- only call down on attacking (nonmoving) enemies
        end
    end

    if target then
        desire = 5
        self.target = target
    else
        desire = 0
    end

    return desire
end

function BehaviorCalldown:Begin()

    self.endTime = GameRules:GetGameTime() + .4 -- wait a bit after casting

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        Position = self.target:GetAbsOrigin(),
        AbilityIndex = self.calldownAbility:entindex(),
        TargetIndex = nil
    }
end

BehaviorCalldown.Continue = BehaviorCalldown.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorBarrage, BehaviorCalldown, BehaviorFlak }
