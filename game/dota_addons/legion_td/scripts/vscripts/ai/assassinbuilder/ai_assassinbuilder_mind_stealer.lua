require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("assassinbuilder_hinder")
		self.abilities[1].Skill = UseSkillTargetPositionOptimalRadius
		self.abilities[1].SkillTrigger = CheckAbilityRange
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_mind_stealer.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end

