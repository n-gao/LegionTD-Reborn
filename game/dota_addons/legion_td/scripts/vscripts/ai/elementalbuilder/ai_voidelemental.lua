require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
		self:FindAbilityByName("bane_brain_sap"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.CheckIfHasAggro = CheckIfHasAggro
		self.ability = {}
		self.ability[1] = self:FindAbilityByName("bane_brain_sap")
		self.ability[1].Skill = UseSkillOnTarget
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_voidelemental.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
