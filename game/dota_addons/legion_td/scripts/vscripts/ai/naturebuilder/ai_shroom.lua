require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI(self)
    self:SetContextThink("init_think", function()
        self:FindAbilityByName("shroom_venomous_gale"):SetLevel(1)
        self.aiThink = aiThinkStandardSkill
        self.abilities = {}
		self.abilities[1] = self:FindAbilityByName("shroom_venomous_gale")
		self.abilities[1].Skill = UseSkillTargetPositionOptimalRadius
		self.abilities[1].SkillTrigger = CheckAbilityRange
        self.Unstuck = Unstuck
        self:SetContextThink("ai_shroom.aiThink", Dynamic_Wrap(self, "aiThink"), 0)
    end, 0)
end
