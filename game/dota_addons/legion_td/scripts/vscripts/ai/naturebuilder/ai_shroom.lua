require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI(self)
    self:SetContextThink("init_think", function()
        self:FindAbilityByName("shroom_venomous_gale"):SetLevel(1)
        self.aiThink = aiThinkStandardSkill
        self.CheckIfHasAggro = CheckIfHasAggro
        self.Skill = UseSkillOnTargetPosition
        self.ability = self:FindAbilityByName("shroom_venomous_gale")
        self.Unstuck = Unstuck
        self:SetContextThink("ai_shroom.aiThink", Dynamic_Wrap(self, "aiThink"), 0)
    end, 0)
end
