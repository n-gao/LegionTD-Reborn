require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("assassinbuilder_bloodrage")
		self.abilities[1].Skill = UseSkillOnSelf
		self.abilities[1].SkillTrigger = function() return true end
		self.abilities[2] = self:FindAbilityByName("assassinbuilder_soul_rend")
		self.abilities[2].Skill = UseSkillTargetMostEHPPhysical
		self.abilities[2].SkillTrigger = CheckAbilityRange
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_blood_drinker.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
