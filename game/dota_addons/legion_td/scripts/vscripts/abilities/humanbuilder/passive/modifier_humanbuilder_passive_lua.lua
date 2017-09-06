modifier_humanbuilder_passive_lua = class({})

--------------------------------------------------------------------------------
function modifier_humanbuilder_passive_lua:GetTexture()
    return "shadow_shaman_voodoo"
end

--------------------------------------------------------------------------------
function modifier_humanbuilder_passive_lua:OnCreated(kv)
    self.food_per_turn = self:GetAbility():GetSpecialValueFor("food_per_turn")

    if self:GetStackCount() > 0 then
        self.food_per_turn = self.food_per_turn * 2
    end

    if IsServer() then
        local gameEnt = GameRules.GameMode.game
        local playerObj = gameEnt:FindPlayerWithID(self:GetParent():GetPlayerID())
        self.foodlimit = playerObj.foodlimit
        self.givenExtraFood = 0
        self.desiredExtraFood = 0

        playerObj.lane.foodBuilding:RemoveAbility("increase_food_limit")
    end
end

--------------------------------------------------------------------------------
function modifier_humanbuilder_passive_lua:OnRefresh(kv)
    if IsServer() then

        local game = GameRules.GameMode.game
        local currentRound = game:GetDisplayRound()
        local playerObj = game:FindPlayerWithID(self:GetParent():GetPlayerID())
        local foodlimit = playerObj.foodlimit

        self.desiredExtraFood = math.floor(self.food_per_turn * currentRound)
        if self.givenExtraFood < self.desiredExtraFood then
            local extraFood = self.desiredExtraFood - self.givenExtraFood
            playerObj:IncreaseFoodLimit(extraFood)
            self.givenExtraFood = self.givenExtraFood + extraFood
            self:GetParent():SetModifierStackCount("modifier_humanbuilder_passive_lua", self:GetParent(), self.givenExtraFood)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_humanbuilder_passive_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_humanbuilder_passive_lua:OnTooltip(params)
    return self.food_per_turn
end

--------------------------------------------------------------------------------
