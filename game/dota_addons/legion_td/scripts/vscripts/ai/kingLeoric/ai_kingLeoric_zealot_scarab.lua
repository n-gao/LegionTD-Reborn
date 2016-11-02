require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("kingLeoric_beetle_swarm")
		self.ability[1].Skill = UseSkillOnTargetPosition
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_alpha_predator.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
