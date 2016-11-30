require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("assassinbuilder_cacophony")
		self.abilities[1].Skill = UseSkillTargetPositionOptimalRadius
		self.abilities[1].SkillTrigger = CheckAbilityRange
		self.abilities[1].CustomAffectRadius = self.abilities[1]:GetSpecialValueFor("wave_width") -- Very suboptimal, should check rectangle from caster instead
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_alpha_predator.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end