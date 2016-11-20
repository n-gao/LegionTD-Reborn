require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:GetAbilityByIndex(0):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:GetAbilityByIndex(0)
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_deathprophet.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
