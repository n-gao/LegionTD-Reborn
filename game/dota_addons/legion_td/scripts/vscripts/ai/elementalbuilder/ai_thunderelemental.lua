require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("leshrac_diabolic_edict"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("leshrac_diabolic_edict")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_thunderelemental.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
