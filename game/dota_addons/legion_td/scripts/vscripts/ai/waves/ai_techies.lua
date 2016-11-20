require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self.abilities = {}
		self.abilities[1] = self:GetAbilityByIndex(0)
		self.abilities[1].Skill = UseSkillOnTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self:SetContextThink( "ai_techies.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
