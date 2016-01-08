EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("naga_siren_rip_tide"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggroInRange
		self.skillUseRange = 80
		self.Skill = UseSkillNoTarget
		self.ability = self:FindAbilityByName("naga_siren_rip_tide")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_waterwarrior.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
