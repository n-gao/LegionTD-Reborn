--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorBarrage })
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

BehaviorBarrage = {}

function BehaviorBarrage:Evaluate()
    self.barrageAbility = thisEntity:FindAbilityByName("gyrocopter_mk2_rocket_barrage")
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

AICore.possibleBehaviors = { BehaviorNone, BehaviorBarrage }
