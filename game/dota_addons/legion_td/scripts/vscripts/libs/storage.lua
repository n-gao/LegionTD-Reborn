JSON = require("libs/json")
JSON.decodeIntegerStringificationLength = 10

DataAttribute = "data"
FailureAttribute = "failure"

Storage = {}
Storage.serverURL = "http://localhost:5000/api/player"

Storage.app_id = 1

Storage.online = true
--key: steamId
--value: table
--- -key: assigned by table.insert
---- value: callback
Storage.requested = {}
--key: steamId
--value: data
Storage.cachedData = {}
--key: attribute
--value: table
--- -key: assinged by table.insert
---- value: { from, to, callback }
Storage.rankingRequests = {}
--key: attribute
--value: table
--- -key: rank
---- value: data
Storage.rankings = {}
--key: attribute
--value: table
--- -key: attribute
---- value: playerCount
Storage.rankingEntries = {}
--key: attribute
--value: table
--- -key: steamId
---- value: rank
Storage.rankingPositions = {}
--key: attribute
--value: table
--- -key: steamId
---- value: table
------ key: assigned by table.insert
------ value: callback
Storage.rankingPositionRequests = {}

function Storage:Init()
    local data = LoadKeyValues("scripts/vscripts/libs/storage_settings.kv")
    if data == nil then return end
    Storage.serverURL = data.url
    Storage.app_id = data.customGameId
    if Convars:GetBool('developer') then
        Storage.serverURL = data.debugUrl
    end
end

Storage:Init()

function Storage:RequestRankingPositions(attribute, steamIds)
    for _, steamId in pairs(steamIds) do
        local callbacks = self:GetRankingPositionCallbacks(attribute, steamId)
        table.insert(callbacks, function(result) end)
    end
    self:SendHttpRequest("GET", {
        customGameId = self.app_id,
        attribute = attribute,
        steamIds = JSON:encode(steamIds)
    }, function(result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Get Ranking Position Response")
        DeepPrintTable(resultTable)
        if (resultTable == nil) then return end
        for _, ranking in pairs(resultTable) do
            self:GetRankingPosition(ranking.attribute)[ranking.steamId] = ranking.rank
            local callbacks = self:GetRankingPositionCallbacks(ranking.attribute, ranking.steamId)
            for k, callback in pairs(callbacks) do
                callback(ranking)
                callbacks[k] = nil
            end
        end
    end)
end

function Storage:GetRankingPosition(attribute, steamId, callback)
    local rankingPositions = self:GetRankingPositions(attribute)
    if rankingPositions[steamId] ~= nil then
        return callback({attribute = attribute, steamId = steamId, rank = rankingPositions[steamId]})
    end
    local callbacks = self:GetRankingPositionCallbacks(attribute, steamId)
    table.insert(callbacks, callback)
    if (#callbacks > 1) then
        return
    end
    self:RequestRankingPosition(attribute, steamId)
end

function Storage:RequestRankingPosition(attribute, steamId)
    self:SendHttpRequest("GET", {
        customGameId = self.app_id,
        method = "ranking_position",
        steamId = steamId,
        rankingType = attribute
    }, function(result)
        local resultTable = JSON:decode(result)
        print("GET RANKING POSITION RESPONSE")
        DeepPrintTable(resultTable)
        if resultTable == nil then return end
        self:GetRankingPositions(resultTable.attribute)[resultTable.steamId] = resultTable.rank
        local callbacks = self:GetRankingPositionCallbacks(resultTable.attribute, resultTable.steamId)
        for k, callback in pairs(callbacks) do
            callback(resultTable)
            callbacks[k] = nil
        end
    end)
end

function Storage:GetRankingPositionCallbacks(attribute, steamId)
    if self.rankingPositionRequests[attribute] == nil then
        self.rankingPositionRequests[attribute] = {}
    end
    local callbacks = self.rankingPositionRequests[attribute]
    if callbacks[steamId] == nil then
        callbacks[steamId] = {}
    end
    return callbacks[steamId]
end

function Storage:GetRankingPositions(attribute)
    if self.rankingPositions[attribute] == nil then
        self.rankingPositions[attribute] = {}
    end
    return self.rankingPositions[attribute]
end

function Storage:GetRanking(attribute, from, to, callback)
    if (self:ContainsCachedRankings(attribute, from, to)) then
        callback(self:GetCachedRankings(attribute, from, to), true)
        return
    end
    self:RequestMissing(attribute, from, to)
    local requestData = {from = from, to = to, callback = callback}
    table.insert(self:GetRankingRequestsFor(attribute), requestData)
end

function Storage:CallRankingRequestCallbacks(attribute, success)
    local requests = self:GetRankingRequestsFor(attribute)
    for key, request in pairs(requests) do
        if (self:ContainsCachedRankings(attribute, request.from, request.to)) then
            local data = self:GetCachedRankings(attribute, request.from, request.to)
            request.callback(data, success)
            requests[key] = nil
        end
    end
end

function Storage:GetRankingRequestsFor(attribute)
    if (self.rankingRequests[attribute] == nil) then
        self.rankingRequests[attribute] = {}
    end
    return self.rankingRequests[attribute]
end

function Storage:RequestMissing(attribute, from, to)
    local cachedOrRequested = self:GetRequestedAndCachedIndices(attribute)
    local startValue = nil
    for i = from, to do
        if (cachedOrRequested[i] ~= true and startValue == nil) then
            startValue = i
        end
        if (cachedOrRequested[i] == true and startValue ~= nil) then
            self:RequestRankingFromTo(attribute, startValue, i)
            startValue = nil
        end
    end
    if startValue ~= nil then
        self:RequestRankingFromTo(attribute, startValue, to)
    end
end

function Storage:RequestRankingFromTo(attribute, from, to)
    self:SendHttpRequest("GET", {
        customGameId = self.app_id,
        method = "ranking",
        rankingType = attribute,
        from = from,
        to = to
    }, function(result)
        local resultTable = JSON:decode(result)
        if resultTable ~= nil then
            if resultTable["failure"] ~= nil then
                print(resultTable["failure"])
                return
            end
            self:AddCachedRanking(attribute, resultTable)
            self:CallRankingRequestCallbacks(attribute, true)
        end
    end)
end

function Storage:GetRequestedAndCachedIndices(attribute)
    local result = {}
    local cached = self:GetCachedRankings(attribute)
    local requested = self:GetRankingRequestsFor(attribute)
    for ind, val in pairs(cached) do
        result[ind] = true
    end
    for _, req in pairs(requested) do
        for i = req.from, req.to do
            result[i] = true
        end
    end
    return result
end

function Storage:ContainsCachedRankings(attribute, from, to)
    local ranking = self:GetCachedRankings(attribute)
    for i = from, to do
        if ranking[i] == nil then
            return false
        end
        if (i + 1 >= self:GetRankingCount(attribute)) then
            break
        end
    end
    return true
end

function Storage:GetCachedRankings(attribute, from, to)
    if (from == nil and to == nil) then
        if (self.rankings[attribute] == nil) then
            self.rankings[attribute] = {}
        end
        return self.rankings[attribute]
    end
    local ranking = self:GetCachedRankings(attribute)
    local result = {}
    if not self:ContainsCachedRankings(attribute, from, to) then return result end
    for i = from, to do
        if i >= self:GetRankingCount(attribute) then break end
        result[i] = ranking[i]
    end
    return result
end

function Storage:AddCachedRanking(attribute, data)
    local ranking = self.rankings[attribute] or {}
    for k, v in pairs(data.ranking) do
        ranking[k - 1 + data.from] = v
    end
    print("[STORAGE] Get Ranking Response")
    DeepPrintTable(data)
    self.rankingEntries[attribute] = data.playerCount
    self.rankings[attribute] = ranking
end

function Storage:GetRankingCount(attribute)
    return self.rankingEntries[attribute] or 0
end

function Storage:GetPlayerData(steam_id, callback)
    if self.cachedData[steam_id] ~= nil then
        callback(self.cachedData[steam_id], true)
        return
    end
    if (self.online == false) then
        callback(self.cachedData[steam_id] or {}, {})
        return
    end
    if self.requested[steam_id] ~= nil then
        table.insert(self.requested[steam_id], callback)
        return
    end
    self.requested[steam_id] = {}
    table.insert(self.requested[steam_id], callback)
    self:SendHttpRequest("GET", {
        customGameId = self.app_id,
        method = "info",
        steamId = steam_id,
    },
    function(result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Get Player Info Response")
        DeepPrintTable(resultTable)
        if resultTable ~= nil then
            if resultTable[DataAttribute] ~= nil then
                self.cachedData[steam_id] = resultTable[DataAttribute]
                self:CallRequestedCallbacks(steam_id, self.cachedData[steam_id], true)
                return
            end
            if resultTable[FailureAttribute] ~= nil then
                print(resultTable[FailureAttribute])
                self:CallRequestedCallbacks(steam_id, resultTable, false)
                return
            end
            self:CallRequestedCallbacks(steam_id, nil, false)
        end
        self:CallRequestedCallbacks(steam_id, nil, false)
    end)
end

function Storage:CallRequestedCallbacks(steam_id, result, success)
    if (self.requested[steam_id] == nil) then return end
    for _, callback in pairs(self.requested[steam_id]) do
        callback(result, success)
    end
end

function Storage:SavePlayerData(steam_id, toStore, callback)
    if (self.online == false) then
        if (callback ~= nil) then
            callback(nil, false)
        end
        return
    end
    if true then return end
    self:InvalidateData(steam_id)
    print("WANTS TO STORE:")
    DeepPrintTable(toStore)
    local data = JSON:encode(toStore)
    self:SendHttpRequest("POST", {
        customGameId = self.app_id,
        steamId = steam_id,
        data = data,
    }, function(result)
        local resultTable = JSON:decode(result)
        print("POST RESPONSE")
        DeepPrintTable(resultTable)
        if callback == nil then
            return
        end
        if resultTable ~= nil then
            callback(resultTable, resultTable[FailureAttribute] == nil)
        else
            callback(resultTable, false)
        end
    end)
end

function Storage:SaveMatchData(winner, duration, lastWave, playerData, duelData, callback)
    if (self.online == false) then
        if (callback ~= nil) then
            callback(nil, false)
        end
        return
    end
    DeepPrintTable(playerData)
    self:SendHttpRequest("POST", {
        customGameId = self.app_id,
        method = "save_match",
        winner = winner,
        duration = duration,
        lastWave = lastWave,
        playerData = JSON:encode(playerData),
        duelData = JSON:encode(duelData)
    }, function(result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Post Match Response")
        DeepPrintTable(resultTable)
        if callback == nil then
            return
        end
        if resultTable ~= nil then
            callback(resultTable, resultTable[FailureAttribute] == nil)
        else
            callback(resultTable, false)
        end
    end)
end

function Storage:UpdateUnitData(unitData)
    if (self.online == false) then
        return
    end
    self:SendHttpRequest("POST", {
        method = "update_units",
        data = JSON:encode(unitData)
    }, function(result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Updating Units Response")
        DeepPrintTable(resultTable)
    end)
end

function Storage:UpdateAbilityData(abilityData)
    if (self.online == false) then
        return
    end
    self:SendHttpRequest("POST", {
        method = "update_abilities",
        data = JSON:encode(abilityData)
    }, function (result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Updating Abilities Response")
        DeepPrintTable(resultTable)
    end)
end

function Storage:UpdateBuilderData(builderData)
    if (self.online == false) then
        return
    end
    self:SendHttpRequest("POST", {
        method = "update_heroes",
        data = JSON:encode(builderData)
    }, function (result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Updating Builder Response")
        DeepPrintTable(resultTable)
    end)
end

function Storage:GetMatchHistory(steamId, from, to, callback)
    if (self.online == false) then return end
    self:SendHttpRequest("GET", {
        method = "match_history",
        steamId = steamId,
        from = from,
        to = to
    }, function(result)
        local resultTable = JSON:decode(result)
        print("[STORAGE] Get Match History Response")
        DeepPrintTable(resultTable)
        callback(resultTable)
    end)
end

function Storage:SetServerURL(url)
    self.serverURL = url
end

function Storage:SetAppID(appID)
    self.app_id = appID
end

function Storage:InvalidateData(steam_id)
    self.cachedData[steam_id] = nil
end

function Storage:InvalidateAll()
    self.cachedData = {}
end

function Storage:SendHttpRequest(method, data, callback)
    print("[STORAGE] Send Data")
    DeepPrintTable(data)

    local req = CreateHTTPRequestScriptVM(method, self.serverURL)
    for key, value in pairs(data) do
        req:SetHTTPRequestGetOrPostParameter(key, tostring(value))
    end
    req:Send(function(result)
        print(result.Body)
        if (string.match(result.Body, "<html>")) then
            result.Body = ""
        end
        if (result.Body == "") then
            --self.online = false
        end
        callback(result.Body)
    end)
end

return Storage
