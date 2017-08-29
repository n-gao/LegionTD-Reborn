require("ai/ai_core")

function Spawn(entity)
    InitAI(thisEntity)
end

function InitAI(self)
    self:SetContextThink("init_think", function()
        self.aiThink = aiThinkStandard
        self.NextWayPoint = NextWayPoint
        self.Unstuck = Unstuck
        self:Unstuck()
        self.kv = Game.UnitKV[self:GetUnitName()]
        if self.kv.AbilityLevel then
            DeepPrintTable(self.kv.AbilityLevel)
            for key, val in pairs(self.kv.AbilityLevel) do
                self:GetAbilityByIndex(tonumber(key:sub(8, 8))):SetLevel(tonumber(val))
            end
        end
        self:SetContextThink("ai_standard.aiThink", Dynamic_Wrap(self, "aiThink"), 0)
    end, 0)
end
