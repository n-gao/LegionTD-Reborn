if not DuelRound then
    DuelRound = class({})
end

DuelRound.doneRounds = {}

function DuelRound.new(data, roundNumber)
    local self = DuelRound()
    self.roundTitle = data.round_title
    self.bounty = data.bounty
    self.final_duel = (data.determines_winner == "true")
    self.isDuelRound = true
    self.winningTeam = DOTA_TEAM_NOTEAM
    self.remainingUnitsRadiant = {}
    self.remainingUnitsDire = {}
    self.roundNumber = roundNumber
    self.playerscores = {}
    self.eventHandles = {}
    for _, pl in pairs(Game.players) do
        self.playerscores[pl:GetPlayerID()] = 0
    end
    return self
end

function DuelRound:Begin()
    self:MoveCameras()
    self.eventHandles = {
        ListenToGameEvent("entity_killed", Dynamic_Wrap(DuelRound, "OnEntityKilled"), self)
    }
    self.unstuckTimer =
        Timers:CreateTimer(
        180,
        function()
            if Game:GetCurrentRound() == self then
                Game.storage:LogError("Unstuck duel round")
                SafeCall(
                    function()
                        self:End()
                    end
                )
                print("Unstuck")
            end
        end
    )
    Game.doneDuels = Game.doneDuels + 1
    self:PlaceUnits()
    if voteOptions["final_duel"] and self.final_duel then
        self:PlaceKings()
    end
    self:CheckEnd()
end

function DuelRound:MoveCameras()
    local radiantDuelSpawn = Game.duelSpawn["" .. DOTA_TEAM_GOODGUYS]:GetAbsOrigin()
    local direDuelSpawn = Game.duelSpawn["" .. DOTA_TEAM_BADGUYS]:GetAbsOrigin()
    for _, pl in pairs(Game.players) do
        local cameraTarget
        if pl:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
            cameraTarget = radiantDuelSpawn
        else
            cameraTarget = direDuelSpawn
        end
        pl:MoveCamera(cameraTarget, 1.5)
    end
end

--Jemand wurde getötet
function DuelRound:OnEntityKilled(event)
    DeepPrintTable(event)
    local killed = EntIndexToHScript(event.entindex_killed)
    if not killed then
        return
    end
    local team = self.remainingUnitsRadiant
    if killed:GetTeamNumber() == DOTA_TEAM_BADGUYS then
        team = self.remainingUnitsDire
    end
    for i, unit in pairs(team) do
        if killed == unit then
            table.remove(team, i)
            break
        end
    end
    if event.entindex_attacker ~= nil then
        killerunit = EntIndexToHScript(event.entindex_attacker)
        killerID = killerunit:GetPlayerOwnerID()
        if self.playerscores[killerID] == nil then
            self.playerscores[killerID] = 0
        end
        self.playerscores[killerID] = self.playerscores[killerID] + killed:GetMinimumGoldBounty()
        print("duel score for " .. killerID .. ": " .. self.playerscores[killerID])
    end
    self:CheckEnd()
end

function DuelRound:PlaceKings()
    Game.radiantBoss:SetAbsOrigin(Vector(0, -1100, 0))
    Game.radiantBoss:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    Game.radiantBoss:SetDayTimeVisionRange(2000)
    Game.radiantBoss:SetBaseMoveSpeed(300)
    Game.direBoss:SetAbsOrigin(Vector(0, 1100, 0))
    Game.direBoss:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    Game.direBoss:SetDayTimeVisionRange(2000)
    Game.direBoss:SetBaseMoveSpeed(300)

    Game.direBoss:AddNewModifier(Game.direBoss, nil, "modifier_king_duel_lua", {})
    Game.radiantBoss:AddNewModifier(Game.radiantBoss, nil, "modifier_king_duel_lua", {})

    table.insert(self.remainingUnitsRadiant, Game.radiantBoss)
    table.insert(self.remainingUnitsDire, Game.direBoss)

    ExecuteOrderFromTable(
        {
            UnitIndex = Game.radiantBoss:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = Game.direBoss:entindex()
        }
    )

    ExecuteOrderFromTable(
        {
            UnitIndex = Game.direBoss:entindex(),
            OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
            TargetIndex = Game.radiantBoss:entindex()
        }
    )
end

function DuelRound:PlaceUnits()
    for _, pl in pairs(Game.players) do
        if pl:ShouldSpawn() then
            local spawnPoint = Game.duelSpawn["" .. pl:GetTeamNumber()]
            local target = Game.duelTargets["" .. pl:GetTeamNumber()]
            local team = self.remainingUnitsRadiant
            if pl:GetTeamNumber() == DOTA_TEAM_BADGUYS then
                team = self.remainingUnitsDire
            end
            for _, unit in pairs(pl.units) do
                unit.npc.nextTarget = target:GetAbsOrigin()
                local relativeposition = unit.npc:GetAbsOrigin() - unit.player.lane.box:GetAbsOrigin()
                if unit.npc:GetAbsOrigin().y < 0 then -- we want to rotate our relative positions for southern lanes
                    relativeposition.x = relativeposition.x * -1
                    relativeposition.y = relativeposition.y * -1
                end
                relativeposition.y = relativeposition.y + unit.player.lane.box:GetBoundingMaxs().y -- we want positions relative to the "front" of the lane
                if pl:GetTeamNumber() == DOTA_TEAM_BADGUYS then -- rotate again if spawning badguy creeps
                    relativeposition.x = relativeposition.x * -1
                    relativeposition.y = relativeposition.y * -1
                end
                movePoint = spawnPoint:GetAbsOrigin() + relativeposition
                unit.npc.nextTarget.x = movePoint.x
                FindClearSpaceForUnit(unit.npc, movePoint, true)
                unit.npc:Stop()
                table.insert(team, unit.npc)
            end
        end
    end
end

function DuelRound:CheckEnd()
    self:CheckUnitsAlive()
    if next(self.remainingUnitsRadiant) == nil or next(self.remainingUnitsDire) == nil then
        print("Rounde beendet")
        SafeCall(
            function()
                self:End()
            end
        )
    end
end

--Ende einer Runde
function DuelRound:End()
    Game:SetGameState(GAMESTATE_END_OF_ROUND)
    self.winningTeam = DOTA_TEAM_GOODGUYS
    local victoryText = "<b color='LawnGreen'>Radiant</b> <b color='white'>won the duel and earned</b> "
    if next(self.remainingUnitsRadiant) == nil then
        self.winningTeam = DOTA_TEAM_BADGUYS
        victoryText = "<b color='red'>Dire</b> <b color='white'>won the duel and earned</b> "
    end

    DuelRound.doneRounds["" .. Game.doneDuels] = {
        winner = self.winningTeam,
        time = GameRules:GetGameTime()
    }

    --Add won duel to stats
    local winners = Game:GetAllPlayersOfTeam(self.winningTeam)
    for _, winner in pairs(winners) do
        winner:WonDuel()
    end

    for key, val in pairs(self.eventHandles) do
        StopListeningToGameEvent(val)
    end
    Timers.timers[self.unstuckTimer] = nil
    self.unstuckTimer = nil
    self.eventHandles = {}
    local highscores = {}
    local scorescopy = shallowcopy(self.playerscores)
    while true do
        local highest = nil
        for id, score in pairs(scorescopy) do
            if highest == nil then
                highest = id
            end
            if self.playerscores[id] > self.playerscores[highest] then
                highest = id
            end
        end
        if highest then
            table.insert(highscores, highest)
            scorescopy[highest] = nil
        else
            break
        end
    end
    local rank = 1
    for _, id in ipairs(highscores) do
        GameRules:SendCustomMessage(
            "<b color='LawnGreen'>#" ..
                rank ..
                    ":</b> " .. PlayerResource:GetPlayerName(id) .. " <b color='cyan'>-</b> " .. self.playerscores[id],
            0,
            0
        )
        rank = rank + 1
        if rank > 4 then
            break
        end
    end

    if self.bounty then
        for _, player in pairs(Game.players) do
            if player.plyEntitie and player:GetTeamNumber() == self.winningTeam and not player.abandoned then
                player:Income(self.bounty)
            end
        end
    end
    GameRules:SendCustomMessage(
        "<b color='white'>" ..
            victoryText ..
                "</b><b color='gold'>" ..
                    self.bounty .. "</b> <b color='gold'>extra gold</b><b color='white'> each!</b>",
        0,
        0
    )
    Game:RoundFinished()
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function DuelRound:CheckUnitsAlive()
    local deadUnitCount = 0
    for ind, unit in pairs(self.remainingUnitsRadiant) do
        if unit:IsNull() or not unit:IsAlive() then
            table.remove(self.remainingUnitsRadiant, ind - deadUnitCount)
            deadUnitCount = deadUnitCount + 1
        end
    end
    deadUnitCount = 0
    for ind, unit in pairs(self.remainingUnitsDire) do
        if unit:IsNull() or not unit:IsAlive() then
            table.remove(self.remainingUnitsDire, ind - deadUnitCount)
            deadUnitCount = deadUnitCount + 1
        end
    end
end

function RelocateUnit(trigger)
    print("teleporting unit!")
    local npc = trigger.activator
    if npc.unit and not npc:IsRealHero() then
        local spawnPoint = Game.duelSpawn["" .. npc:GetTeamNumber()]
        local target = Game.duelTargets["" .. npc:GetTeamNumber()]
        FindClearSpaceForUnit(npc, spawnPoint:GetAbsOrigin(), true)
        npc.nextTarget = target:GetAbsOrigin()
    end
end
