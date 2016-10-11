require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("firegod_supernova"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggroInRange
		self.skillUseRange = 300
		self.Skill = UseSkillNoTarget
		self.ability = self:FindAbilityByName("firegod_supernova")
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_firegod.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
