require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("storm_spirit_static_remnant"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillNoTarget
		self.ability = self:FindAbilityByName("storm_spirit_static_remnant")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_thunderwarrior.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
