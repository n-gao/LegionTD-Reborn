--[[
Pudge AI
]]

require( "ai/ai_core_new" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
    thisEntity:SetContextThink( "AIThink", AIThink, 1 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorStartRot, BehaviorStopRot } ) 
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

BehaviorStartRot = {}

-- turn on rot when there's at least one enemy in range
function BehaviorStartRot:Evaluate()
    self.fadeAbility = thisEntity:FindAbilityByName("pudge_rot_lua")

    local range = 250
    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
        
    if #enemies > 0 and self.fadeAbility:GetToggleState() == false then
        return 2 
    end
    return 0
end

function BehaviorStartRot:Begin()
    self.fadeAbility = thisEntity:FindAbilityByName("pudge_rot_lua")
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
        UnitIndex = thisEntity:entindex(),
        AbilityIndex = self.fadeAbility:entindex()
    }
end

BehaviorStartRot.Continue = BehaviorStartRot.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

BehaviorStopRot = {}

-- if rot is turned on and there is no enemies around we want to turn it off
function BehaviorStopRot:Evaluate()
    self.fadeAbility = thisEntity:FindAbilityByName("pudge_rot_lua")

    local range = 250
    local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_CLOSEST, false )
        
    if #enemies < 1 and self.fadeAbility:GetToggleState() then
        return 2 
    end
    return 0
end

function BehaviorStopRot:Begin()
    self.fadeAbility = thisEntity:FindAbilityByName("pudge_rot_lua")    
    self.endTime = GameRules:GetGameTime() + .1

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
        UnitIndex = thisEntity:entindex(),
        AbilityIndex = self.fadeAbility:entindex()
    }
end

BehaviorStopRot.Continue = BehaviorStartRot.Evaluate -- after stopping rot we will return to evaluation of starting rot
--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorStartRot, BehaviorStopRot }
