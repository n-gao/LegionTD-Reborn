require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandard
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_mind_breaker.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
