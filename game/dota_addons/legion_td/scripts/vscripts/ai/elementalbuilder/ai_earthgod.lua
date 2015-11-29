EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self:GetAbilityByIndex(1):SetLevel(1)
		self:GetAbilityByIndex(2):SetLevel(3)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillOnTargetPosition
		self.ability = self:GetAbilityByIndex(1)
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_earthgod.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
