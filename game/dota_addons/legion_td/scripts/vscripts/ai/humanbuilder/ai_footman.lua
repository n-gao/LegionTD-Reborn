require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("footman_shield_bash")
		self.ability[1].Skill = UseSkillOnTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_footman.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
