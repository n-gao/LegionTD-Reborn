--[[
Pudge AI
]]

require("ai/ai_core_new")

behaviorSystem = {} -- create the global so we can assign to it

function Spawn(entityKeyValues)
    thisEntity:SetContextThink("AIThink", AIThink, 1)
    behaviorSystem = AICore:CreateBehaviorSystem({ BehaviorNone, BehaviorPurification })
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

BehaviorPurification = {}

function BehaviorPurification:Evaluate()
    self.purificationAbility = thisEntity:FindAbilityByName("paladin_purification")
    local target
    local desire = 0

    -- let's not choose this twice in a row
    --if AICore.currentBehavior == self then return desire end -- no, lets!

    if self.purificationAbility and self.purificationAbility:IsFullyCastable() then
        local range = self.purificationAbility:GetCastRange()
        local allies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, FIND_ANY_ORDER, false)
        local mostHurt = 50 -- minimum hurt amount
        -- print ("Paladin is considering the health of " .. #allies .. " allies!")
        for _, unit in pairs(allies) do
            local healthLost = unit:GetMaxHealth() - unit:GetHealth()
            if healthLost > mostHurt and healthLost > (unit:GetMaxHealth() * .4) then --only cast if unit has lost at least 40% of its health
                target = unit
            end
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

function BehaviorPurification:Begin()
    self.endTime = GameRules:GetGameTime() + .6 -- purification takes forever to cast

    self.order =
    {
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        UnitIndex = thisEntity:entindex(),
        TargetIndex = self.target:entindex(),
        AbilityIndex = self.purificationAbility:entindex()
    }
end

BehaviorPurification.Continue = BehaviorPurification.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorPurification }
