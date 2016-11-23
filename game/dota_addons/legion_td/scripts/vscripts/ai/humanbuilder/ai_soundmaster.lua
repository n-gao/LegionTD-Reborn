--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorBlast, BehaviorStorm })
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

BehaviorBlast = {}

function BehaviorBlast:Evaluate()
    self.blastAbility = thisEntity:FindAbilityByName("soundmaster_deafening_blast")
    local desire = 0
    local blastDirection = nil

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.blastAbility and self.blastAbility:IsFullyCastable() then
        local range = 420 -- we don't want to use deafening blast's full range
        local northEnemies = FindUnitsInLine(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin() + Vector(0, 200, 0), thisEntity:GetAbsOrigin() + Vector(0, range, 0), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, FIND_CLOSEST)
        local southEnemies = FindUnitsInLine(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin() - Vector(0, 200, 0), thisEntity:GetAbsOrigin() - Vector(0, range, 0), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, FIND_CLOSEST)

        if #northEnemies > 0 then blastDirection = 1 end
        if #southEnemies > #northEnemies then blastDirection = -1 end
    end

    if blastDirection then
        desire = 5
        self.blastDirection = blastDirection
    else
        desire = 0
    end

    return desire
end

function BehaviorBlast:Begin()

    print("soundmaster desires to blast")



    targetPosition = thisEntity:GetAbsOrigin() + Vector(0, self.blastDirection * 200, 0)
    print(self.blastDirection)
    print(thisEntity:GetAbsOrigin())
    print(targetPosition)

    self.endTime = GameRules:GetGameTime() + .2

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = nil,
        AbilityIndex = self.blastAbility:entindex(),
        Position = targetPosition
    }

    ExecuteOrderFromTable {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = nil,
        AbilityIndex = self.blastAbility:entindex(),
        Position = targetPosition,
        Queue = 0
    }
end

BehaviorBlast.Continue = BehaviorBlast.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorStorm = {}

function BehaviorStorm:Evaluate()
    self.stormAbility = thisEntity:FindAbilityByName("soundmaster_lightning_storm")
    local desire = 0
    local target

    -- let's not choose this twice in a row
    if AICore.currentBehavior == self then return desire end

    if self.stormAbility and self.stormAbility:IsFullyCastable() then
        local range = self.stormAbility:GetCastRange()
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

function BehaviorStorm:Begin()

    print("soundmaster desires to storm")

    self.endTime = GameRules:GetGameTime() + .4 -- wait a bit after casting

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        UnitIndex = thisEntity:entindex(),
        Position = nil,
        AbilityIndex = self.stormAbility:entindex(),
        TargetIndex = self.target:entindex()
    }
end

BehaviorStorm.Continue = BehaviorStorm.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorBlast, BehaviorStorm }
