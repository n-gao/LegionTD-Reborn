if Unit == nil then
    Unit = class({})
end

LinkLuaModifier("modifier_unit_freeze_lua", "abilities/modifier_unit_freeze_lua.lua", LUA_MODIFIER_MOTION_NONE)

function Unit.GetUnitNameByID(id)
    if id == 1 then return "tower_naturebuilder_spider"
    elseif id == 2 then return "tower_naturebuilder_bug"
    elseif id == 3 then return "tower_naturebuilder_bear"
    elseif id == 4 then return "tower_naturebuilder_treant"
    elseif id == 5 then return "tower_naturebuilder_hyena"
    elseif id == 6 then return "tower_naturebuilder_centaur"
    elseif id == 7 then return "tower_naturebuilder_broodmother"
    elseif id == 8 then return "tower_naturebuilder_big_bug"
    elseif id == 9 then return "tower_naturebuilder_druid_bear"
    elseif id == 10 then return "tower_naturebuilder_iron_bear"
    elseif id == 11 then return "tower_naturebuilder_shroom"
    elseif id == 12 then return "tower_naturebuilder_flower_treant"
    elseif id == 13 then return "tower_naturebuilder_agressive_boar"
    elseif id == 14 then return "tower_naturebuilder_big_centaur"
    elseif id == 15 then return "tower_naturebuilder_centaur_warrunner"
    elseif id == 16 then return "tower_naturebuilder_treebeard"
    elseif id == 17 then return "tower_naturebuilder_very_big_bug"

    elseif id == 50 then return "tower_elementalbuilder_waterbender"
    elseif id == 51 then return "tower_elementalbuilder_thunderbender"
    elseif id == 52 then return "tower_elementalbuilder_earthbender"
    elseif id == 53 then return "tower_elementalbuilder_firebender"
    elseif id == 54 then return "tower_elementalbuilder_voidbender"
    elseif id == 55 then return "tower_elementalbuilder_waterelemental"
    elseif id == 56 then return "tower_elementalbuilder_waterwarrior"
    elseif id == 57 then return "tower_elementalbuilder_watergod"
    elseif id == 58 then return "tower_elementalbuilder_earthelemental"
    elseif id == 59 then return "tower_elementalbuilder_earthwarrior"
    elseif id == 60 then return "tower_elementalbuilder_earthgod"
    elseif id == 61 then return "tower_elementalbuilder_thunderelemental"
    elseif id == 62 then return "tower_elementalbuilder_thunderwarrior"
    elseif id == 63 then return "tower_elementalbuilder_thundergod"
    elseif id == 64 then return "tower_elementalbuilder_fireelemental"
    elseif id == 65 then return "tower_elementalbuilder_firewarrior"
    elseif id == 66 then return "tower_elementalbuilder_firegod"
    elseif id == 67 then return "tower_elementalbuilder_voidelemental"
    elseif id == 68 then return "tower_elementalbuilder_voidwarrior"
    elseif id == 69 then return "tower_elementalbuilder_voidgod"

    elseif id == 100 then return "tower_humanbuilder_archbishop"
    elseif id == 101 then return "tower_humanbuilder_archer"
    elseif id == 102 then return "tower_humanbuilder_archmage"
    elseif id == 103 then return "tower_humanbuilder_blademaster"
    elseif id == 104 then return "tower_humanbuilder_footman"
    elseif id == 105 then return "tower_humanbuilder_futuristic_gyrocopter"
    elseif id == 106 then return "tower_humanbuilder_general"
    elseif id == 107 then return "tower_humanbuilder_gunner"
    elseif id == 108 then return "tower_humanbuilder_gyrocopter_mk1"
    elseif id == 109 then return "tower_humanbuilder_gyrocopter_mk2"
    elseif id == 110 then return "tower_humanbuilder_hunter"
    elseif id == 111 then return "tower_humanbuilder_icewrack_grandmaster"
    elseif id == 112 then return "tower_humanbuilder_lieutenant"
    elseif id == 113 then return "tower_humanbuilder_mage"
    elseif id == 114 then return "tower_humanbuilder_marksman"
    elseif id == 115 then return "tower_humanbuilder_militia"
    elseif id == 116 then return "tower_humanbuilder_novice"
    elseif id == 117 then return "tower_humanbuilder_paladin"
    elseif id == 118 then return "tower_humanbuilder_sharpshooter"
    elseif id == 119 then return "tower_humanbuilder_soldier"
    elseif id == 120 then return "tower_humanbuilder_soundmaster"
    elseif id == 121 then return "tower_humanbuilder_spearman"
    elseif id == 122 then return "tower_humanbuilder_tactician"

    elseif id == 300 then return "tower_kingLeoric_creeping_shadow"
    elseif id == 301 then return "tower_kingLeoric_jester"
    elseif id == 302 then return "tower_kingLeoric_lotus"
    elseif id == 303 then return "tower_kingLeoric_mind_stealer"
    elseif id == 304 then return "tower_kingLeoric_zealot_scarab"
    elseif id == 305 then return "tower_kingLeoric_alpha_predator"
    elseif id == 306 then return "tower_kingLeoric_bloodknife"
    elseif id == 307 then return "tower_kingLeoric_blood_drinker"
    elseif id == 308 then return "tower_kingLeoric_dark_wraith"
    elseif id == 309 then return "tower_kingLeoric_mind_breaker"
    elseif id == 310 then return "tower_kingLeoric_mind_slicer"
    elseif id == 311 then return "tower_kingLeoric_nightshade"
    elseif id == 312 then return "tower_kingLeoric_nimble_edge"
    elseif id == 313 then return "tower_kingLeoric_shadow_hunter"
    elseif id == 314 then return "tower_kingLeoric_silent_champion"
    elseif id == 315 then return "tower_kingLeoric_stealth_assassin"
    elseif id == 316 then return "tower_kingLeoric_timekeeper"
    elseif id == 317 then return "tower_kingLeoric_trickster"

    elseif id == 1001 then return "incomeunit_kobold"
    elseif id == 1002 then return "incomeunit_hill_troll_shaman"
    elseif id == 1003 then return "incomeunit_hill_troll_warrior"
    elseif id == 1004 then return "incomeunit_harpy"
    elseif id == 1005 then return "incomeunit_ghost"
    elseif id == 1006 then return "incomeunit_little_wolf"
    elseif id == 1007 then return "incomeunit_satyr"
    elseif id == 1008 then return "incomeunit_ogre_warrior"
    elseif id == 1009 then return "incomeunit_little_centaur"
    elseif id == 1010 then return "incomeunit_wolf"
    elseif id == 1011 then return "incomeunit_golem"
    elseif id == 1012 then return "incomeunit_little_golem"
    elseif id == 1013 then return "incomeunit_centaur"
    elseif id == 1014 then return "incomeunit_vulture"
    elseif id == 1015 then return "incomeunit_lizard"
    elseif id == 1016 then return "incomeunit_lycanwolf"
    elseif id == 1017 then return "incomeunit_black_drake"
    elseif id == 1018 then return "incomeunit_big_lizard"
    elseif id == 1019 then return "incomeunit_ancientgolem"
    elseif id == 1020 then return "incomeunit_fleshgolem"
    elseif id == 1021 then return "incomeunit_jellyfish"
    elseif id == 1022 then return "incomeunit_hulk"
    elseif id == 1023 then return "incomeunit_beast"
    elseif id == 1024 then return "incomeunit_diablo"
    elseif id == 1025 then return "incomeunit_rosh"
        -- elseif id == 16 then return "tower_naturebuilder_centaur"
    end
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
    local unit = Unit.new(Unit.GetUnitNameByID(event.ability:GetSpecialValueFor("unitID")),
        event.unit:GetCursorPosition(), event.caster, event.ability:GetSpecialValueFor("food_cost"),
        event.ability:GetGoldCost(event.ability:GetLevel()))
    event.caster.player:RefreshPlayerInfo()
end


function UpgradeUnit(event)
    local id = event.ability:GetSpecialValueFor("unitID")
    playerid = event.unit:GetPlayerOwnerID()
    local newclass = Unit.GetUnitNameByID(id)
    event.caster.unit.npcclass = newclass
    event.caster.unit.player:BuildUnit(newclass)
    event.caster.unit:Respawn()
    event.caster.unit.foodCost = event.caster.unit.foodCost
            + event.ability:GetSpecialValueFor("food_cost")
    event.caster.unit.goldCost = event.caster.unit.goldCost
            + event.ability:GetGoldCost(event.ability:GetLevel())
    PlayerResource:NewSelection(playerid, event.caster.unit.npc)
end


function OnEndReached(trigger) -- trigger at end of lane to teleport to final defense
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
