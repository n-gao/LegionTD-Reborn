"use strict";

function GetCallbacks() {
    return GameUI.CustomUIConfig().Rankings.Callbacks;
}

function RequestRankingFromTo(attribute, start, end, callback) {
    var data = {
        playerID : Players.GetLocalPlayer(),
        attribute : attribute,
        from : start,
        to : end
    }
    GameEvents.SendCustomGameEventToServer("request_ranking", data);
    GetCallbacks().push({ attribute : attribute, start : start, end : end, callback : callback});
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
    var ranking = GetRanking(data.attribute);
    for (var i = 0; i <= data.count; i++) {
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
	    GameEvents.Subscribe("send_rankings", UpdateRanking);
    //}
}

(function() {
    InitRanking();
})();
