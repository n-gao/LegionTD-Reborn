require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(4)
    self:GetAbilityByIndex(1):SetLevel(3)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:GetAbilityByIndex(0)
		self.abilities[1].Skill = UseSkillOnTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_king.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
