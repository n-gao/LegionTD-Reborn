require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillNoTarget
		self.ability = self:FindAbilityByName("kingLeoric_spiked_carapace")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_shadow_hunter.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
