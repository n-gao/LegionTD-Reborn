--[[
Pudge AI
]]
require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({BehaviorNone, BehaviorBlast})
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

    self.order = {
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

-- use blast when there's at least one enemy in range
function BehaviorBlast:Evaluate()
    self.fadeAbility = thisEntity:FindAbilityByName("improved_nether_blast")

    local range = 700
    local enemies =
        FindUnitsInRadius(
        thisEntity:GetTeamNumber(),
        thisEntity:GetAbsOrigin(),
        nil,
        range,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        0,
        FIND_CLOSEST,
        false
    )
    local cooldown = self.fadeAbility:GetCooldownTimeRemaining()

    if #enemies > 0 and cooldown == 0 then
        self.target = enemies[1]
        return 2
    end
    return 0
end

function BehaviorBlast:Begin()
    self.fadeAbility = thisEntity:FindAbilityByName("improved_nether_blast")
    self.endTime = GameRules:GetGameTime() + .1

    self.order = {
        OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
        UnitIndex = thisEntity:entindex(),
        Position = self.target:GetAbsOrigin(),
        TargetIndex = nil,
        AbilityIndex = self.fadeAbility:entindex()
    }
end

BehaviorBlast.Continue = BehaviorBlast.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = {BehaviorNone, BehaviorBlast}
