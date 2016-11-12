require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("ember_spirit_flame_guard"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("ember_spirit_flame_guard")
		self.ability[1].Skill = UseSkillNoTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_fireelemental.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
