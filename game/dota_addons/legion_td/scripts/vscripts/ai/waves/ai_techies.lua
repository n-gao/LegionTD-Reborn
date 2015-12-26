EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self.Skill = UseSkillOnTarget
		self.ability = self:GetAbilityByIndex(0)
		self:SetContextThink( "ai_techies.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
