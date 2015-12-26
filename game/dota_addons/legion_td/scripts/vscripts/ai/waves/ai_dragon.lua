EXPORTS = {}

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(3)
		self.aiThink = aiThinkStandardBuff
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillNoTarget
		self.ability = self:GetAbilityByIndex(0)
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_dragon.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

return EXPORTS
