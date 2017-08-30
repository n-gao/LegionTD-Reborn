if Unit == nil then
    Unit = class({})
end

LinkLuaModifier("modifier_unit_freeze_lua", "abilities/modifier_unit_freeze_lua.lua", LUA_MODIFIER_MOTION_NONE)

Unit.UnitTable = dofile("config_unit")

function Unit:GetUnitNameByID(id)
    return self.UnitTable[id]
end


function Unit.new(npcclass, position, owner, foodCost, goldCost)
    local self = Unit()
    self.owner = owner
    self.player = owner.player
    self.npcclass = npcclass
    self.player:BuildUnit(self.npcclass)
    self.buyround = Game:GetCurrentRound()
    self.goldCost = goldCost
    self.foodCost = foodCost
    self.spawnposition = position
    self.target = self.player.lane.unitWaypoint
    self.nextTarget = self.target:GetAbsOrigin()
    self.nextTarget.x = self.spawnposition.x
    table.insert(self.player.units, self)
    self:Spawn()
end



function Unit:Spawn()
    --PrecacheUnitByNameAsync(self.npcclass, function ()
    self.npc = CreateUnitByName(self.npcclass, self.spawnposition, false, nil,
        self.owner, self.owner:GetTeamNumber())
    if self.spawnposition.y > 0 then
        self.npc:SetAngles(0, 90, 0)
    else
        self.npc:SetAngles(0, 270, 0)
    end
    self.npc.unit = self
    self.npc.player = self.player
    self.npc.nextTarget = self.nextTarget
    self.npc:SetMinimumGoldBounty(self.foodCost)
    self.npc:SetMaximumGoldBounty(self.foodCost)
    self:Lock()
--end
--)
end


function Unit:RemoveNPC()
    if not self.npc:IsNull() and self.npc:IsAlive() then
        self.npc:ForceKill(false)
    end
end



function Unit:Respawn()
    self:RemoveNPC()
    self:Spawn()
end



function Unit:ResetPosition()
    if not self.npc:IsNull() and self.npc:IsAlive() then
        FindClearSpaceForUnit(self.npc, self.spawnposition, true)
        self.npc.nextTarget = self.nextTarget
        self:Unlock()
    end
end



function Unit:Unlock()
    if self.npc and not self.npc:IsNull() and self.npc:IsAlive() then
        self.npc:RemoveModifierByName("modifier_unit_freeze_lua")
        self.npc:RemoveModifierByName("modifier_invulnerable")
        self.npc:SetControllableByPlayer(-1, false)
        self.npc:Stop()
        self:EndCooldowns()
        Timers:CreateTimer(0.5, function()
            local pos = self.npc.nextTarget
            --pos.x = self.spawnposition.x
            ExecuteOrderFromTable({
                UnitIndex = self.npc:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex = 0, --Optional.  Only used when targeting units
                AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = pos, --Optional.  Only used when targeting the ground
                Queue = 0 --Optional.  Used for queueing up abilities
            })
        end)
    end
end

function Unit:EndCooldowns()
    for i = 0, 16, 1 do
        local ability = self.npc:GetAbilityByIndex(i);
        if (ability and not ability:IsNull()) then
            ability:EndCooldown()
        end
    end
end



function Unit:Lock()
    if not self.npc:IsNull() and self.npc:IsAlive() then
        self.npc:AddNewModifier(nil, nil, "modifier_invulnerable", {})
        self.npc:AddNewModifier(nil, nil, "modifier_unit_freeze_lua", {})
        self:GivePlayerControl()
    end
end



function Unit:GivePlayerControl()
    if self.player:IsActive() then
        self.npc:SetControllableByPlayer(self.owner.player:GetPlayerID(), true)
    end
end


function sell(event)
    local unit = event.caster.unit
    local player = unit.player
    unit:RemoveNPC()
    Timers:CreateTimer(1, function()
        UTIL_RemoveImmediate(unit.npc)
    end)
    local gold = unit.goldCost / 2
    if unit.buyround == Game:GetCurrentRound() then
        gold = unit.goldCost
    end
    PlayerResource:ModifyGold(player:GetPlayerID(), gold, true, DOTA_ModifyGold_Unspecified)
    table.remove(unit.player.units, unit.player:GetUnitKey(unit))
    player:RefreshPlayerInfo()
end


function UnitSpawn(event)
    if not Game:IsBetweenRounds() then
        print("player trying to build unit post-spawn!")
        playerid = event.unit:GetPlayerOwnerID()
        player = Game:FindPlayerWithID(playerid)
        player:SendErrorCode(LEGION_ERROR_BETWEEN_ROUNDS)
        local gold = event.ability:GetGoldCost(event.ability:GetLevel())
        player.hero:ModifyGold(gold, true, DOTA_ModifyGold_Unspecified)
        return
    end
    local unit = Unit.new(Unit:GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")),
        event.unit:GetCursorPosition(), event.caster, event.ability:GetSpecialValueFor("food_cost"),
        event.ability:GetGoldCost(event.ability:GetLevel()))
    event.caster.player:RefreshPlayerInfo()
end


function UpgradeUnit(event)
    local id = event.ability:GetSpecialValueFor("unitID")
    playerid = event.unit:GetPlayerOwnerID()
    local newclass = Unit:GetUnitNameByID(id)
    event.caster.unit.npcclass = newclass
    event.caster.unit.player:BuildUnit(newclass)
    event.caster.unit:Respawn()
    event.caster.unit.foodCost = event.caster.unit.foodCost
        + event.ability:GetSpecialValueFor("food_cost")
    event.caster.unit.goldCost = event.caster.unit.goldCost
        + event.ability:GetGoldCost(event.ability:GetLevel())
    PlayerResource:NewSelection(playerid, event.caster.unit.npc)
end


function OnEndReached(trigger)-- trigger at end of lane to teleport to final defense
    local npc = trigger.activator
    if npc.unit and not npc:IsRealHero() then
        if not (npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS) then
            npc.nextTarget = Game.lastDefends["" .. npc:GetTeamNumber()]:GetAbsOrigin()
            if npc:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
                FindClearSpaceForUnit(npc, Game.lastDefendsRanged["" .. npc:GetTeamNumber()]:GetAbsOrigin(), true)
                npc.nextTarget.y = npc.nextTarget.y - 200
            else
                FindClearSpaceForUnit(npc, npc.nextTarget, true)
            end
            ExecuteOrderFromTable({
                UnitIndex = npc:entindex(),
                OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                TargetIndex = 0, --Optional.  Only used when targeting units
                AbilityIndex = 0, --Optional.  Only used when casting abilities
                Position = npc.nextTarget, --Optional.  Only used when targeting the ground
                Queue = 0 --Optional.  Used for queueing up abilities
            })
        end
    end
end
