require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self.ability = {}
		self.ability[1] = self:GetAbilityByIndex(0)
		self.ability[1].Skill = UseSkillOnTarget
		self:SetContextThink( "ai_techies.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
