require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggroInRange
		self.skillUseRange = 80
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("centaur_hoof_stomp_datadriven")
		self.ability[1].Skill = UseSkillNoTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_bigcentaur.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
