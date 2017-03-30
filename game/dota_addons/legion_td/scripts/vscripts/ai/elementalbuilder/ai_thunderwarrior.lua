require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("thunderwarrior_static_remnant"):SetLevel(1)
		self:FindAbilityByName("thunderwarrior_overload"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("thunderwarrior_static_remnant")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_thunderwarrior.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
