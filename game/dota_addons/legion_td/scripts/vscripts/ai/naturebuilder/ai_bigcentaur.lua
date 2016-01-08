EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggroInRange
		self.skillUseRange = 80
		self.Skill = UseSkillNoTarget
		self.ability = self:FindAbilityByName("centaur_hoof_stomp_datadriven")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_bigcentaur.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
