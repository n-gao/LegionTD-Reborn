"use strict";

function UpdateMatch(data) {
    $.Msg(data);
    var matches = GetMatches();
    for (var i = 0; i < data.count; i++) {
        matches[data[i].Id] = data[i].data;
    }
}

function UpdateMatchHistory(data) {
    $.Msg(data);
    var history = GetMatchHistory();
    var matches = GetMatches();
    for (var i in data) {
        history[data[i].order] = data[i].id;
        matches[data[i].id] = data[i].data;
    }
    CallHistoryCallbacks();
}

function RequestMatchHistory(from, to, callback) {
    var data = {
        playerId: Players.GetLocalPlayer(),
        steamId: Game.GetLocalPlayerInfo().player_steamid,
        from: from,
        to: to,
    }
    GameEvents.SendCustomGameEventToServer("request_match_history", data);
    GetHistoryCallbacks().push(callback);
}

function CallCallbacks() {

}

function CallHistoryCallbacks() {
    var callbacks = GetHistoryCallbacks();
    for (var i = 0; i < callbacks.length; i++) {
        var callback = callbacks[i];
        callback(GetMatchHistory());
    }
    GameUI.CustomUIConfig().MatchHistoryCallbacks = [];
}

function GetMatchData(id) {
    return GetMatches()[id];
}

function InitMatches() {
    if (GameUI.CustomUIConfig().Matches == null) {
        GameUI.CustomUIConfig().Matches = {};
        GameUI.CustomUIConfig().MatchesRequests = [];
        GameEvents.Subscribe("send_match", UpdateMatch);
        GameEvents.Subscribe("send_match_history", UpdateMatchHistory);

        GameUI.CustomUIConfig().MatchHistory = {};
        GameUI.CustomUIConfig().MatchHistoryCallbacks = [];
    }
}

function GetHistoryCallbacks() {
    return GameUI.CustomUIConfig().MatchHistoryCallbacks;
}

function GetMatches() {
    return GameUI.CustomUIConfig().Matches;
}

function GetMatchHistory() {
    return GameUI.CustomUIConfig().MatchHistory;
}

(function () {
    InitMatches();
})();