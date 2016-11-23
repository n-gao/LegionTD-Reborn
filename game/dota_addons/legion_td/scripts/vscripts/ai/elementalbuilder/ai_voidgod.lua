--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorBH })
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

BehaviorBH = {}

function BehaviorBH:Evaluate()
    self.BHAbility = thisEntity:FindAbilityByName("enigma_black_hole")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.BHAbility and self.BHAbility:IsFullyCastable() then
        local range = self.BHAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false)
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

function BehaviorBH:Begin()
    self.endTime = GameRules:GetGameTime() + 5

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        Position = self.target:GetAbsOrigin(),
        AbilityIndex = self.BHAbility:entindex(),
        TargetIndex = nil
    }
end

BehaviorBH.Continue = BehaviorBH.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorBH }
