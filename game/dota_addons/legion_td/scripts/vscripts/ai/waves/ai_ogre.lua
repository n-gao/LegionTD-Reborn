require("ai/ai_core")

SEARCHING_RADIUS = 300;

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
    self:GetAbilityByIndex(0):SetLevel(4)
		self.aiThink = aiThinkStandardBuff
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:GetAbilityByIndex(0)
		self.ability[1].Skill = Bloodlust
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_ogre.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

function Bloodlust(self, ability)
	local ally;
	local allies = Entities:FindAllInSphere(
		self:GetAbsOrigin(),
		SEARCHING_RADIUS)
	ally = allies[RandomInt(1, #allies)]
  self:CastAbilityOnTarget(ally, ability, -1)
  return 1
end
