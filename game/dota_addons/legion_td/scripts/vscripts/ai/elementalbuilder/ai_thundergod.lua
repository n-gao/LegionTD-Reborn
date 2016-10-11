require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("zuus_arc_lightning"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.Skill = UseSkillOnTarget
		self.ability = self:FindAbilityByName("zuus_arc_lightning")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_thundergod.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
