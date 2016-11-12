require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("kingLeoric_bloodrage")
		self.ability[1].Skill = UseSkillOnSelf
		self.ability[2] = self:FindAbilityByName("kingLeoric_soul_rend")
		self.ability[2].Skill = UseSkillOnTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_blood_drinker.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
