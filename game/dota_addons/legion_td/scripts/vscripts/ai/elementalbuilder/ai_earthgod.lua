EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("tiny_avalanche"):SetLevel(1)
		self:FindAbilityByName("tiny_grow"):SetLevel(3)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillOnTargetPosition
		self.ability = self:FindAbilityByName("tiny_avalanche")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_earthgod.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
