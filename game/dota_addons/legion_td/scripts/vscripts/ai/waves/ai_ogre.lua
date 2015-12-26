EXPORTS = {}

SEARCHING_RADIUS = 300;

EXPORTS.Init = function( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(4)
		self.aiThink = aiThinkStandardBuff
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = Bloodlust
		self.ability = self:GetAbilityByIndex(0)
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_ogre.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function Bloodlust(self)
	local ally;
	local allies = Entities:FindAllInSphere(
		self:GetAbsOrigin(),
		SEARCHING_RADIUS)
	ally = allies[RandomInt(1, #allies)]
  self:CastAbilityOnTarget(ally, self:GetAbilityByIndex(0), -1)
  return 1
end


return EXPORTS
