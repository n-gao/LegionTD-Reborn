require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(4)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:GetAbilityByIndex(0)
		self.abilities[1].Skill = Bloodlust
		self.abilities[1].SkillTrigger = function() return true end
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_ogre.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function Bloodlust(entity, ability)
	local Radius = 300
	local allies = FindUnitsInRadius(entity:GetTeamNumber(), entity:GetAbsOrigin(), nil, Radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #allies < 1 then return 1 end

	entity:CastAbilityOnTarget(allies[1], ability, -1)
	return 1
end
