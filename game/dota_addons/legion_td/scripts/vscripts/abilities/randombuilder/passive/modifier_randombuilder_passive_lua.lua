modifier_randombuilder_passive_lua = class({})

--------------------------------------------------------------------------------
function modifier_randombuilder_passive_lua:GetTexture()
    return "alchemist_goblins_greed"
end

--------------------------------------------------------------------------------
function modifier_randombuilder_passive_lua:OnCreated(kv)
    self.interestRate = self:GetAbility():GetSpecialValueFor("tangos_interest_rate")

    if IsServer() then
        self.gameEnt = GameRules.GameMode.game
        table.insert(self.gameEnt.endOfRoundListeners, function() self:PayInterest() end)
        self.playerObj = self.gameEnt:FindPlayerWithID(self:GetParent():GetPlayerID())
    end
end

function modifier_randombuilder_passive_lua:PayInterest()
    if not IsServer() then return end
    if self.gameEnt:GetCurrentRound().isDuelRound then return end
    local interest = self.interestRate * self.playerObj:GetTangos()
    self.playerObj:Income(interest)
end

--------------------------------------------------------------------------------
function modifier_randombuilder_passive_lua:OnRefresh(kv)
end

--------------------------------------------------------------------------------
function modifier_randombuilder_passive_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_randombuilder_passive_lua:OnTooltip(params)
    return self.interestRate
end

--------------------------------------------------------------------------------
