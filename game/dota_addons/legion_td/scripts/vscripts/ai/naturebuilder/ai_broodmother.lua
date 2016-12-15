require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI( self )
	self:SetContextThink( "init_think", function()
    	self:FindAbilityByName("brood_spawn_spiderlings"):SetLevel(1)
		self.aiThink = aiThinkStandardSkill
		self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("brood_spawn_spiderlings")
		self.abilities[1].Skill = UseSkillNoTarget
		self.abilities[1].SkillTrigger = CheckIfHasAggro
		self.Unstuck = Unstuck
		self:SetContextThink( "ai_broodmother.aiThink", Dynamic_Wrap( self, "aiThink" ), 0 )
	end, 0 )
end
