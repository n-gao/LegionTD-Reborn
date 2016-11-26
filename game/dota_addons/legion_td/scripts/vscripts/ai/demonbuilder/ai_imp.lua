--[[
Pudge AI
]]

require( "ai/ai_core_new" )

behaviorSystem = {} -- create the global so we can assign to it

function Spawn( entityKeyValues )
	thisEntity:SetContextThink( "AIThink", AIThink, 1 )
    behaviorSystem = AICore:CreateBehaviorSystem( { BehaviorNone, BehaviorImpale } ) 
    --thisEntity:FindAbilityByName("tiny_grow"):SetLevel(3)
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

BehaviorImpale = {}

function BehaviorImpale:Evaluate()
	self.ImpaleAbility = thisEntity:FindAbilityByName("lion_impale")
	local desire = 0
	local target

	-- let's not choose this twice in a row
	if AICore.currentBehavior == self then return desire end

	if self.ImpaleAbility and self.ImpaleAbility:IsFullyCastable() then
		local range = 500 -- Impale's actual cast range is too far and units often walk out of it
		local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetAbsOrigin(), nil, range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, 0, FIND_ANY_ORDER, false )
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

function BehaviorImpale:Begin()
	self.endTime = GameRules:GetGameTime() + .1

	self.order =
	{
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		UnitIndex = thisEntity:entindex(),
		Position = self.target:GetAbsOrigin(),
		AbilityIndex = self.ImpaleAbility:entindex(),
		TargetIndex = nil
	}
end

BehaviorImpale.Continue = BehaviorImpale.Begin --if we re-enter this ability, we might have a different target; might as well do a full reset

--------------------------------------------------------------------------------------------------------

AICore.possibleBehaviors = { BehaviorNone, BehaviorImpale }
