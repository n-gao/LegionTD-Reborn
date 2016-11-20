require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("centaur_hoof_stomp_datadriven")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggroInRange
		self.abilities[1].SkillUseRange = 80
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_bigcentaur.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
