require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(3)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:GetAbilityByIndex(0)
		self.ability[1].Skill = UseSkillNoTarget
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_dragon.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
