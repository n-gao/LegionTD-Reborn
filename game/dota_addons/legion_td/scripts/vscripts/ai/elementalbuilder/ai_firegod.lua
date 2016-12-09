require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("firegod_supernova"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("firegod_supernova")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggroInRange
		self.abilities[1].SkillUseRange = 300
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_firegod.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
