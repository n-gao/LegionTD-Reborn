require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI(self)
    self:SetContextThink("init_think", function()
        self:FindAbilityByName("leshrac_diabolic_edict"):SetLevel(1)
        self.aiThink = aiThinkStandardSkill
        self.CheckIfHasAggro = CheckIfHasAggro
        self.Skill = UseSkillNoTarget
        self.ability = self:FindAbilityByName("leshrac_diabolic_edict")
        self.Unstuck = Unstuck
        self:SetContextThink("ai_thunderelemental.aiThink", Dynamic_Wrap(self, "aiThink"), 0)
    end, 0)
end
