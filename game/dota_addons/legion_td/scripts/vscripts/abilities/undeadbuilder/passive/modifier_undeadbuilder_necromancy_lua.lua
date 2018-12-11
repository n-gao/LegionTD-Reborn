modifier_undeadbuilder_necromancy_lua = modifier_undeadbuilder_necromancy_lua or class({})

function modifier_undeadbuilder_necromancy_lua:IsDebuff()
    return false
end

function modifier_undeadbuilder_necromancy_lua:IsStunDebuff()
    return false
end

function modifier_undeadbuilder_necromancy_lua:IsHidden()
    return false
end

function modifier_undeadbuilder_necromancy_lua:IsAura()
    return true
end

function modifier_undeadbuilder_necromancy_lua:IsPermanent()
    return true
end

function modifier_undeadbuilder_necromancy_lua:IsAura()
    return true
end

function modifier_undeadbuilder_necromancy_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_undeadbuilder_necromancy_lua:OnDeath()
    if (Game.gameState ~= GAMESTATE_FIGHTING) then
        return
    end
    self.npc = self:GetParent()
    if (self.npc:GetHealth() ~= 0) then
        return
    end
    if (self.npc == nil or self.npc.unit == nil) then
        return
    end
    self.unit = self.npc.unit
    local goldCost = self.unit.goldCost
    local zombie =
        CreateUnitByName(
        "tower_undeadbuilder_resurrected",
        self.npc:GetAbsOrigin(),
        false,
        self.unit,
        nil,
        self.npc:GetTeamNumber()
    )
    FindClearSpaceForUnit(zombie, self.npc:GetAbsOrigin(), true)
    zombie.nextTarget = self.npc.nextTarget
    zombie.player = self.npc.player
    zombie.unit = self.unit

    --Adjust strength based on gold
    zombie:SetMaxHealth(goldCost * 2 / 3 + 40)
    zombie:SetHealth(goldCost * 2 / 3 + 40)
    zombie:SetPhysicalArmorBaseValue(goldCost / 10 - 3)
    zombie:SetBaseDamageMin(12 + 0.085 * goldCost)
    zombie:SetModelScale(0.4787234 + 0.00070921 * goldCost)

    self:Destroy()
    Game:AddEndOfRoundListener(
        function()
            if (not zombie:IsNull()) then
                zombie:ForceKill(false)
            end
            return nil
        end
    )
end

function modifier_undeadbuilder_necromancy_lua:RemoveOnDeath()
    return true
end

function modifier_undeadbuilder_necromancy_lua:IsPurgable()
    return false
end

function modifier_undeadbuilder_necromancy_lua:GetTexture()
    return "necrolyte_sadist"
end
