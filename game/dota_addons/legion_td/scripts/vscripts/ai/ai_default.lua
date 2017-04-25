require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandard
		self.NextWayPoint = NextWayPoint
		self.Unstuck = Unstuck
		self:Unstuck()
		self:SetContextThink( "ai_standard.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end