if WaveSpawner == nil then
    WaveSpawner = class({})
end

function WaveSpawner:ReadConfiguration(name, kv, gameRound)
    self.gameRound = gameRound
    self.name = name
    self.npcName = kv.NPCName
    self.unitCount = kv.UnitCount
    self.dmgBonus = 0
    self.healthBonus = 0
end

function round(num, nearest)
    num = num / nearest
    num = math.floor(num)
    num = num * nearest
    return num, num / nearest
end

function WaveSpawner:Spawn()
    local spawners = Game.lanes
    local count = 1
    --Spawn normal Wave
    for key, lane in pairs(spawners) do
        if SpawnOnLane(lane) then
            local polar = 1
            local spacing = 128
            if lane.spawnpoint:GetAbsOrigin().y < 0 then polar = -1 end
            local rank1 = lane.spawnpoint:GetAbsOrigin()
            local positions = {}
            local columns = 5
            for i = 1, self.unitCount do
                local offset = (((columns - 1) / 2) * spacing) * -1
                if i > round(self.unitCount, columns) then
                    offset = offset + (((round(self.unitCount, columns) + columns) - self.unitCount) / 2) * spacing
                end
                local voffset = 0
                if self.unitCount > columns * 2 then
                    voffset = spacing * polar * -1
                end
                local hpos = offset + (((i - 1) % columns) * spacing)
                local vpos = voffset + (math.floor((i - 1) / columns)) * spacing * polar
                --print ("inserting into table! Offset is " .. offset .. "; coordinates " .. hpos .. ", " .. vpos)
                table.insert(positions, Vector(hpos, vpos, 0))
            end
            
            -- print ("RANK AND FILE:")
            -- for _, v in ipairs(positions) do
            --   print(v.x .. ", " .. v.y)
            -- end
            for i = 1, self.unitCount do
                local creep = CreateUnitByName(self.npcName,
                    positions[i] + rank1, true, nil, nil, DOTA_TEAM_NEUTRALS)
                if positions[i].y > 0 then
                    creep:SetAngles(0, 90, 0)
                else
                    creep:SetAngles(0, 270, 0)
                end
                creep:Stop()
                ExecuteOrderFromTable({
                    UnitIndex = creep:entindex(),
                    OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                    TargetIndex = 0, --Optional.  Only used when targeting units
                    AbilityIndex = 0, --Optional.  Only used when casting abilities
                    Position = Vector(positions[i].x, 0, 0), --Optional.  Only used when targeting the ground
                    Queue = 1 --Optional.  Used for queueing up abilities
                })
                creep:MoveToPositionAggressive(Vector(positions[i].x, 0, 0))
                creep.wayStep = 2
                creep.waypoints = {}
                local wpCount = #lane.waypoints
                for j = 1, wpCount do
                    table.insert(creep.waypoints, lane.waypoints[j] + positions[i])
                    DebugDrawCircle(lane.waypoints[j] + positions[i], Vector(0, 255, 0), 1, 50, false, 50)
                end
                creep.waypoints[wpCount].y = lane.waypoints[wpCount].y -- make final waypoint y aligned with king regardless of formation rank
                creep.nextTarget = lane.nextWaypoint
                creep.lane = lane
                creep:SetMaxHealth(creep:GetMaxHealth() + self.healthBonus)
                creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() + self.healthBonus)
                creep:Heal(self.healthBonus, nil)
                creep:SetBaseDamageMin(creep:GetBaseDamageMin() + self.dmgBonus)
                creep:SetBaseDamageMax(creep:GetBaseDamageMax() + self.dmgBonus)
                self.ApplyHardMode(creep)
            end
        end
    end
    
    self.dmgBonus = self.dmgBonus + LAST_WAVE_DMG_PER_ROUND
    self.healthBonus = self.healthBonus + LAST_WAVE_HEALTH_PER_ROUND
    
    self:SendIncomingUnits(DOTA_TEAM_GOODGUYS)
    self:SendIncomingUnits(DOTA_TEAM_BADGUYS)
end

function WaveSpawner.ApplyHardMode(creep)
    if (not voteOptions["hard_mode"]) then return end
    
    local bonusHp = creep:GetMaxHealth() * HARD_MODE_HEALTH_MULTIPLIER - creep:GetMaxHealth()
    creep:SetMaxHealth(creep:GetMaxHealth() + bonusHp)
    creep:SetBaseMaxHealth(creep:GetBaseMaxHealth() + bonusHp)
    creep:Heal(bonusHp, nil)
    
    creep:SetBaseDamageMin(creep:GetBaseDamageMin() * HARD_MODE_DAMAGE_MULTIPLIER)
    creep:SetBaseDamageMax(creep:GetBaseDamageMax() * HARD_MODE_DAMAGE_MULTIPLIER)
end

function WaveSpawner:SendIncomingUnits(team)
    local spawners = {}-- list of possible lanes that we can distribute to, indexed 1 to 4
    local count = 0 -- number of valid lanes to distribute to
    local units = {}
    local distributedValues = {}
    local distributedUnits = {}
    local lowestValue = 0
    local leader = 1
    if team == DOTA_TEAM_GOODGUYS then
        units = Game.sendRadiant
        Game.sendRadiant = {}
        for i = 5, 8 do
            local lane = Game.lanes["" .. i]
            if SpawnOnLane(lane) then
                spawners[count + 1] = lane
                distributedValues[count + 1] = 0
                distributedUnits[count + 1] = {}
                count = count + 1
            end
        end
        Game.sendLeaderDire = Game.sendLeaderDire + 1
        if Game.sendLeaderDire > 4 then Game.sendLeaderDire = 1 end
        for i = 1, 4 do
            local lane = Game.lanes["" .. Game.sendLeaderDire + 4]
            if SpawnOnLane(Game.lanes["" .. Game.sendLeaderDire + 4]) then break end
            Game.sendLeaderDire = Game.sendLeaderDire + 1
            if Game.sendLeaderDire > 4 then Game.sendLeaderDire = 1 end
        end
        print("Game.sendLeaderDire is now " .. Game.sendLeaderDire)
        leader = Game.sendLeaderDire
    else
        units = Game.sendDire
        Game.sendDire = {}
        for i = 1, 4 do
            if SpawnOnLane(Game.lanes["" .. i]) then
                spawners[count + 1] = Game.lanes["" .. i]
                distributedValues[count + 1] = 0
                distributedUnits[count + 1] = {}
                count = count + 1
            end
        end
        Game.sendLeaderRadiant = Game.sendLeaderRadiant + 1
        if Game.sendLeaderRadiant > 4 then Game.sendLeaderRadiant = 1 end
        for i = 1, 4 do
            if SpawnOnLane(Game.lanes["" .. Game.sendLeaderRadiant]) then break end
            Game.sendLeaderRadiant = Game.sendLeaderRadiant + 1
            if Game.sendLeaderRadiant > 4 then Game.sendLeaderRadiant = 1 end
        end
        print("Game.sendLeaderRadiant is now " .. Game.sendLeaderRadiant)
        leader = Game.sendLeaderRadiant
    end
    
    table.sort(units, function(a, b) return a.tangoValue > b.tangoValue end)-- sort units by their tango value
    
    print("Assigning send units-")
    
    for _, unit in ipairs(units) do
        if next(spawners) == nil then
            unit:ForceKill(false)
        else
            local theLane = 1
            for j = (leader), (leader + (count - 1)) do
                if distributedValues[((j - 1) % count) + 1] == lowestValue then
                    theLane = ((j - 1) % count) + 1
                    break
                end
            end
            
            table.insert(distributedUnits[theLane], unit)
            
            distributedValues[theLane] = distributedValues[theLane] + unit.tangoValue
            tempLowestValue = distributedValues[theLane]
            for _, j in pairs(distributedValues) do
                print("j = " .. j)
                if j and j < tempLowestValue then tempLowestValue = j end
            end
            lowestValue = tempLowestValue
        end
    end
    
    print("Moving send units-")
    
    local sendsPerMiniwave = 15
    
    for theLane, units in pairs(distributedUnits) do
        
        local lane = spawners[theLane]
        local unitCount = #units
        local polar = 1
        local spacing = 128
        if lane.spawnpoint:GetAbsOrigin().y < 0 then polar = -1 end
        local rank1 = lane.spawnpoint:GetAbsOrigin()
        local positions = {}
        local columns = 5
        for i = 1, unitCount do
            local offset = (((columns - 1) / 2) * spacing) * -1
            if i > round(unitCount, columns) then
                offset = offset + (((round(unitCount, columns) + columns) - unitCount) / 2) * spacing
            end
            local hpos = offset + (((i - 1) % columns) * spacing)
            local vpos = (math.floor((((i - 1) % sendsPerMiniwave)) / columns)) * spacing * polar
            print("inserting into table! Offset is " .. offset .. "; coordinates " .. hpos .. ", " .. vpos)
            table.insert(positions, Vector(hpos, vpos, 0))
        end
        
        
        
        
        local k = 1
        local i = 1
        
        for _, unit in pairs(units) do
            
            Timers:CreateTimer((math.floor((i - 1) / sendsPerMiniwave) * 2) + 2, function()
                    
                    print("i = " .. i)
                    print("k = " .. k)
                    
                    FindClearSpaceForUnit(unit, rank1 + positions[k], true)
                    
                    unit:RemoveModifierByName("modifier_unit_freeze_lua")
                    unit:RemoveModifierByName("modifier_invulnerable")
                    
                    unit.waypoints = {}
                    for j = 1, 4 do
                        DebugDrawCircle(lane.waypoints[j] + positions[k], Vector(0, 255, 0), 1, 50, false, 50)
                        table.insert(unit.waypoints, lane.waypoints[j] + positions[k])
                    end
                    
                    unit.waypoints[4].y = unit.waypoints[4].y -- make final waypoint y aligned with king regardless of formation rank
                    unit.wayStep = 2
                    
                    ExecuteOrderFromTable({
                        UnitIndex = unit:entindex(),
                        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
                        TargetIndex = 0, --Optional.  Only used when targeting units
                        AbilityIndex = 0, --Optional.  Only used when casting abilities
                        Position = unit.waypoints[unit.wayStep], --Optional.  Only used when targeting the ground
                        Queue = 0 --Optional.  Used for queueing up abilities
                    })
                    unit:SetTeam(DOTA_TEAM_NEUTRALS)
                    unit.nextTarget = lane.nextWaypoint
                    unit.lastWaypoint = lane.lastWaypoint
                    unit.lane = spawners[theLane]
                    self.gameRound:AddUnitToBeKilled(unit)
                    k = k + 1
            end)
            
            i = i + 1
        end
    end
end


function KingTrigger(trigger)
    local npc = trigger.activator
    if npc and not npc:IsRealHero() then
        if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
            npc:RemoveAbility("ability_phased")
            npc:RemoveModifierByName("modifier_phased")
        end
    end
end

function SpawnOnLane(lane)
    return lane.player and lane.player:ShouldSpawn()
end
