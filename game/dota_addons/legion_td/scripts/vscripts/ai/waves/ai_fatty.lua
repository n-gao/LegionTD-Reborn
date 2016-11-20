require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:GetAbilityByIndex(0)
		self.abilities[1].Skill = UseSkillOnTargetPosition
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.abilities:SetLevel(1)
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_fatty.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
