"use strict";

var rankingPositionCallbacks = {}

function GetCallbacks() {
    return GameUI.CustomUIConfig().Rankings.Callbacks;
}

function GetRPCallbacks(attribute, steamId) {
    if (rankingPositionCallbacks[attribute] == null) {
        rankingPositionCallbacks[attribute] = {};
    }
    if (rankingPositionCallbacks[attribute][steamId] == null) {
        rankingPositionCallbacks[attribute][steamId] = [];
    }
    return rankingPositionCallbacks[attribute][steamId];
}

function RequestRankingPosition(attribute, steamId, callback) {
    var data = {
        playerId: Players.GetLocalPlayer(),
        attribute: attribute,
        steamId: steamId,
    }
    GetRPCallbacks(attribute, steamId).push(callback);
    GameEvents.SendCustomGameEventToServer("request_ranking_position", data);
}

function CallRPCallbacks(attribute, steamId, rank) {
    var callbacks = GetRPCallbacks(attribute, steamId);
    for (var i = callbacks.length - 1; i >= 0; i--) {
        callbacks[i](rank);
        callbacks.splice(i, 1);
    }
}

function ReceiveRankingPosition(data) {
    CallRPCallbacks(data.attribute, data.steamId, data.rank);
}

function RequestRankingFromTo(attribute, start, end, callback) {
    var data = {
        playerID: Players.GetLocalPlayer(),
        attribute: attribute,
        from: start,
        to: end
    }
    GameEvents.SendCustomGameEventToServer("request_ranking", data);
    GetCallbacks().push({ attribute: attribute, start: start, end: end, callback: callback });
}

function GetRankingFromTo(attribute, start, end) {
    var ranking = GetRanking(attribute);
    var result = [];
    for (var i = start; i <= end; i++) {
        result.push(ranking[i]);
    }
    return result;
}

function GetRanking(attribute) {
    var rankings = GetRankings();
    if (rankings[attribute] == null) {
        rankings[attribute] = {};
    }
    return rankings[attribute];
}

function GetRankings() {
    return GameUI.CustomUIConfig().Rankings;
}

function UpdateRanking(data) {
    $.Msg(data);
    var ranking = GetRanking(data.attribute);
    for (var i = 0; i < data.count; i++) {
        ranking[data[i].rank] = data[i].steamId
        GetStoredData()[data[i].steamId] = data[i].data
    }
    CallCallbacks();
}

function CallCallbacks() {
    var callbacks = GetCallbacks();
    for (var i = callbacks.length - 1; i >= 0; i--) {
        var entry = callbacks[i];
        if (HasDataFor(entry)) {
            entry.callback(GetRankingFromTo(entry.attribute, entry.start, entry.end));
            callbacks.splice(i, 1);
        }
    }
}

function HasDataFor(callbackData) {
    var ranking = GetRanking(callbackData.attribute);
    for (var i = callbackData.start; i <= callbackData.end; i++) {
        if (ranking[i] == null) {
            return false;
        }

    }
    return true;
}

function InitRanking() {
    //if (GameUI.CustomUIConfig().Rankings == null) {
    GameUI.CustomUIConfig().Rankings = {};
    GameUI.CustomUIConfig().Rankings.Callbacks = [];
    GameUI.CustomUIConfig().Rankings.Requests = [];
    GameUI.CustomUIConfig().RankingPositions = {};
    GameEvents.Subscribe("send_rankings", UpdateRanking);
    GameEvents.Subscribe("send_ranking_position", ReceiveRankingPosition);
    //}
}

(function () {
    InitRanking();
})();
