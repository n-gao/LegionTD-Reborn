require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("kingLeoric_spiked_carapace")
		self.ability[1].Skill = UseSkillNoTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_shadow_hunter.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
