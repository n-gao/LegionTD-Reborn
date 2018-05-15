require("notifications")

if GameRound == nil then
    GameRound = class({})
end


--Liest Rundeninfos ein
function GameRound:ReadRoundConfiguration(kv, game, roundNumber)
    self.roundNumber = roundNumber
    self.game = game
    self.roundQuestTitle = kv.round_quest_title or "Kaputt"
    self.roundTitle = kv.round_title or "Kaputt"
    self.bounty = kv.bounty
    self.winningTeam = DOTA_TEAM_NOTEAM
    self.spawners = {}
    self.remainingUnits = {}
    self.EventHandles = {}
    
    for key, val in pairs(kv) do
        if type(val) == "table" and val.NPCName then
            local spawner = WaveSpawner()
            spawner:ReadConfiguration(key, val, self)
            self.spawners[key] = spawner
        end
    end
end



function GameRound:Begin()
    print("Round " .. self.roundNumber .. " started.")
    self.remainingUnits = {}
    
    self.EventHandles = {
        ListenToGameEvent("npc_spawned", Dynamic_Wrap(GameRound, "OnNPCSpawned"), self),
        ListenToGameEvent("entity_killed", Dynamic_Wrap(GameRound, "OnEntityKilled"), self)
    }
    self.unstuckTimer = Timers:CreateTimer(180, function()
        if self.game:GetCurrentRound() == self then
            self:KillAll(true)
            print("Unstuck")
        end
    end)
    print("gonna do GameRound:Begin() Spawn()-ing")
    for ind, key in pairs(self.spawners) do
        print("Doing key:Spawn()")
        key:Spawn()
    end
    print("did GameRound:Begin() Spawn()-ing")
end


function GameRound:End()
    for key, val in pairs(self.EventHandles) do
        StopListeningToGameEvent(val)
    end
    if Timers.timers[self.unstuckTimer] then Timers.timers[self.unstuckTimer] = nil end
    self.unstuckTimer = nil
    self.EventHandles = {}
    self:KillAll(true)
    if self.bounty then
        for _, player in pairs(self.game.players) do
            player:Income(self.bounty)
        end
	   GameRules:SendCustomMessage("<b color='white'>Every player gained</b> <b color='gold'>" .. self.bounty .. " gold</b> <b color='white'>for surviving.</b>", 0, 0)
    end
    self.game:RoundFinished()
end


--Überprüft ob eine Runde vorbei ist
function GameRound:CheckEnd()
    self:CheckUnitsAlive()
    if next(self.remainingUnits) == nil then
        print("Round finished.")
        self:End()
    end
end



function GameRound:CheckUnitsAlive()
    local deadUnitCount = 0
    for ind, unit in pairs(self.remainingUnits) do
        if unit:IsNull() or not unit:IsAlive() then
            table.remove(self.remainingUnits, ind - deadUnitCount)
            deadUnitCount = deadUnitCount + 1
        end
    end
end


--NPC gespawnt
function GameRound:OnNPCSpawned(event)
    local spawned = EntIndexToHScript(event.entindex)
    if not spawned or spawned:IsPhantom() or spawned:GetClassname() == "npc_dota_thinker" or spawned:GetUnitName() == "" then
        return
    end
    if spawned:GetUnitName() == "storm_spirit_static_remnant" then return end
    if spawned:GetTeamNumber() == DOTA_TEAM_NEUTRALS and not spawned.dontAdd then
        self:AddUnitToBeKilled(spawned)
    end
end



function GameRound:AddUnitToBeKilled(unit)
    unit:SetMustReachEachGoalEntity(true)
    table.insert(self.remainingUnits, unit)
end


--Called when a unit dies
function GameRound:OnEntityKilled(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    if not killed or not self.remainingUnits then
        return
    end
    for i, unit in pairs(self.remainingUnits) do
        if killed == unit then
            table.remove(self.remainingUnits, i)
            break
        end
    end
    self:CheckEnd()
end



function GameRound:KillAll(skipAsync)
    if not self.remainingUnits then
        return
    end
    if not skipAsync then
        for _, ent in pairs(self.remainingUnits) do
            Timers:CreateTimer(0, function()
                if not ent:IsNull() then
                    ent:ForceKill(false)
                end
            end)
        end
    else
        for _, ent in pairs(self.remainingUnits) do
            if not ent:IsNull() then
                ent:ForceKill(false)
            end
        end
    end
end
