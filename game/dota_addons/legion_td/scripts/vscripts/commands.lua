CommandEngine = {}
CommandEngine.Commands = {}
CommandEngine.Variables = {}

CommandEngine.prefix = "-"
CommandEngine.Variables.waveKV = LoadKeyValues("scripts/maps/" .. GetMapName() .. ".txt")
CommandEngine.Variables.damageKV = LoadKeyValues("scripts/damage_table.kv")

function CommandEngine.init()
    CommandEngine.initialized = true
    
    if GameRules:IsCheatMode() then
        CommandEngine.Commands.stop = Game.StopRound
        CommandEngine.Commands.start = Game.StartNextRoundCommand
        CommandEngine.Commands.skip = CommandEngine.Commands.start
    end
end

function CommandEngine:CheckCommand(keys)
    if not CommandEngine.initialized then CommandEngine.init() end
    if string.sub(keys.text, 1, #CommandEngine.prefix) then
        
        local submessage = string.sub(keys.text, #CommandEngine.prefix + 1)
        local div = select(2, string.find(submessage, " "))
        if div then div = div - 1 else div = #submessage end
        local command = submessage:sub(1, div):lower()
        submessage = submessage:sub(div + 2)
        
        if CommandEngine.Commands[command] then
            CommandEngine.Commands[command](self, submessage, keys)
            print("PlayerID " .. keys.playerid .. " ran command " .. keys.text)
        end
    end
end

function CommandEngine.waveInfo(waveNum, playerid)
    local waveKV = CommandEngine.Variables.waveKV.Rounds
    if waveNum == nil then print("waveInfo canceled: index nil") return end
    if #Game.rounds <= waveNum then print("waveInfo canceled: index out of bounds") return end
    
    local roundNum = waveNum
    local i = 1
    while i <= roundNum do
        if Game.rounds[i].isDuelRound then
            roundNum = roundNum + 1
            if #Game.rounds <= roundNum then print("waveInfo canceled: index out of bounds") return end
        end
        i = i + 1
    end
    print("waveInfo: " .. roundNum)
    
    local name = waveKV[tostring(roundNum)]["Unit"]["NPCName"]
    local amount = waveKV[tostring(roundNum)]["Unit"]["UnitCount"] or 0
    
    local wavebounty = waveKV[tostring(roundNum)]["bounty"] or 0
    local unitbounty = Game.UnitKV[name]["BountyGoldMin"] or 0
    local total = tonumber(wavebounty) + (tonumber(unitbounty) * tonumber(amount))
    
    local health = Game.UnitKV[name]["StatusHealth"] or 0
    local armor = Game.UnitKV[name]["ArmorPhysical"] or 0
    local range = Game.UnitKV[name]["AttackRange"] or 0
    
    local damageMin = tonumber(Game.UnitKV[name]["AttackDamageMin"]) or 0
    local damageMax = tonumber(Game.UnitKV[name]["AttackDamageMax"]) or 0
    local attackRate = tonumber(Game.UnitKV[name]["AttackRate"]) or 0
    
    if damageMin then damageMin = (math.floor(damageMin * 1000)) / 1000 end -- rounding floating point from KV's
    if damageMax then damageMax = (math.floor(damageMax * 1000)) / 1000 end -- rounding floating point from KV's
    if attackRate then attackRate = (math.floor(attackRate * 1000)) / 1000 end -- rounding floating point from KV's
    
    local attackType = Game.UnitKV[name]["LegionAttackType"] or "none"
    local defendType = Game.UnitKV[name]["LegionDefendType"] or "none"
    local attackCapabilities = Game.UnitKV[name]["AttackCapabilities"] or "none"
    
    if attackCapabilities == "DOTA_UNIT_CAP_MELEE_ATTACK" then attackCapabilities = "Melee"
    elseif attackCapabilities == "DOTA_UNIT_CAP_RANGED_ATTACK" then attackCapabilities = "Ranged"
    else attackCapabilities = "Can't attack"
    end
    
    local lines = {
        "Wave " .. waveNum .. ":",
        amount .. "x " .. name .. " (" .. attackType .. " / " .. defendType .. ")",
        "Total " .. total .. " Gold (" .. wavebounty .. "g + " .. amount .. "x " .. unitbounty .. "g)",
        "Health: " .. health .. " Armor: " .. armor,
        "Damage: " .. damageMin .. "-" .. damageMax .. " (" .. attackRate .. " AR) Range: " .. range .. " (" .. attackCapabilities .. ")"
    }
    
    if CommandEngine.Variables.damageKV[attackType] then
        local first = true
        local line = "Deals: "
        for i, v in pairs(CommandEngine.Variables.damageKV[attackType]) do
            if first then
                first = false
            else
                line = line .. " | "
            end
            
            line = line .. (math.floor(tonumber(v) * 1000) / 1000) .. "x " .. i -- rounding floating point from KV's
        end
        table.insert(lines, line)
    end
    
    do
        local line = "Takes: "
        local first = true
        for i, v in pairs(CommandEngine.Variables.damageKV) do
            if v[defendType] then
                if first then
                    first = false
                else
                    line = line .. " | "
                end
                
                line = line .. (math.floor(tonumber(v[defendType]) * 1000) / 1000) .. "x " .. i -- rounding floating point from KV's
            end
        end
        table.insert(lines, line)
    end
    
    local player = PlayerResource:GetPlayer(playerid)
    for i, v in pairs(lines) do
        CustomGameEventManager:Send_ServerToPlayer(player, "waveinfo_notification", {text = v, duration = 15, style = {color = "black", ["font-size"] = "25px", ["line-height"] = "0px"}})
    end
end

function CommandEngine.Commands.wave(instance, submessage, keys)
    CommandEngine.waveInfo(tonumber(submessage), keys.playerid)
end

function CommandEngine.Commands.info(instance, submessage, keys)
    CommandEngine.waveInfo(Game:GetDisplayRound(), keys.playerid)
end

function CommandEngine.Commands.infonext(instance, submessage, keys)
    CommandEngine.waveInfo(Game:GetDisplayRound() + 1, keys.playerid)
end

function CommandEngine.Commands.settings(instance, submessage, keys)
    if CommandEngine.Variables.settingsCooldown then return end
    CommandEngine.Variables.settingsCooldown = true
    local resettimer = Timers:CreateTimer(30, function()CommandEngine.Variables.settingsCooldown = false end)
    
    Say(nil, "Current settings:", false)
    for i, v in pairs(voteOptions) do
        Say(nil, i .. " : " .. tostring(v), false)
    end
end

if GameRules:IsCheatMode() then
    function CommandEngine.Commands.tango(instance, submessage, keys)
        instance.vPlayers[keys.playerid + 1].player:AddTangos(tonumber(submessage) or 0)
    end
    
    function CommandEngine.Commands.reinitialize(instance, submessage, keys)
        print("Reinitializing commands!")
        dofile("commands")
    end
    
    -- Fill this with whatever, used for testing (accompanied by reinitialize)
    function CommandEngine.Commands.test(instance, submessage, keys)
    end
    
    function CommandEngine.Commands.setwave(instance, submessage, keys)
        Game:SetRound(tonumber(submessage))
    end
end

CommandEngine.Commands.gamemode = CommandEngine.Commands.settings
