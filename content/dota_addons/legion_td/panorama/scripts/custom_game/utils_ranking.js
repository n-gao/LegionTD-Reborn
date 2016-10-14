"use strict";

function RequestRankingFromTo(attribute, start, end) {
    var data = {
        playerID : Players.GetLocalPlayer(),
        attribute : attribute,
        from : start,
        to : end
    }
    GameEvents.SendCustomGameEventToServer("request_ranking", data);
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
    InitRanking();
    return GameUI.CustomUIConfig().Rankings;
}

function UpdateRanking(data) {
    var ranking = GetRanking(data.attribute);
    $.Msg(data);
    for (var i = 0; i < data.length; i++) {
        ranking[data[i].Rank] = data.SteamId;
        GetStoredData()[data[i].SteamId] = data[i].Data
    }
}

function InitRanking() {
    if (GameUI.CustomUIConfig().Rankings == null) {
        GameUI.CustomUIConfig().Rankings = {};
        GameUI.CustomUIConfig().Rankings.Requests = [];
	    GameEvents.Subscribe("send_rankings", UpdateRanking);
    }
}

(function() {
    InitRanking();
    //RequestRankingFromTo("kills", 0, 1);
})();
