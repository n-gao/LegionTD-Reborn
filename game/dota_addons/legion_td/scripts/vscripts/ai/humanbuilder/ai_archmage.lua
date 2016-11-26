--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorFade, BehaviorFrost })
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

BehaviorFade = {}

function BehaviorFade:Evaluate()
    self.fadeAbility = thisEntity:FindAbilityByName("archmage_chain_fade")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.fadeAbility and self.fadeAbility:IsFullyCastable() then
        local range = self.fadeAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
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

function BehaviorFade:Begin()
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = self.target:entindex(),
        AbilityIndex = self.fadeAbility:entindex(),
        Position = nil
    }
end

BehaviorFade.Continue = BehaviorFade.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorFrost = {}

function BehaviorFrost:Evaluate()
    self.frostAbility = thisEntity:FindAbilityByName("archmage_crystal_nova")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.frostAbility and self.frostAbility:IsFullyCastable() then
        local range = self.frostAbility:GetCastRange()
        local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false)
        if #enemies > 0 then target = enemies[1] end
    end

    if target then
        desire = 5
        self.target = target
    else
        desire = 0
    end

    return desire
end

function BehaviorFrost:Begin()
    self.endTime = GameRules:GetGameTime() + .4 -- wait a bit after casting

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        Position = self.target:GetAbsOrigin(),
        AbilityIndex = self.frostAbility:entindex(),
        TargetIndex = nil
    }
end

BehaviorFrost.Continue = BehaviorFrost.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorFade, BehaviorFrost }
