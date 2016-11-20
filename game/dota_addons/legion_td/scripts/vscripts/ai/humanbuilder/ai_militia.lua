EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("militia_shield_bash")
		self.abilities[1].Skill = UseSkillOnTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_militia.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
