"use strict"

function LeftPad(str, sym, count) {
    str = "" + str;
    var pad = "";
    for (var i = 0; i < count; i++)
        pad = pad + sym;
    return pad.substring(0, pad.length - str.length) + str;
}

function Contains(arr, obj) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] == obj) {
            return true;
        }
    }
    return false;
}

function RequestStoredDataFor(steamId) {
    var data = {
        playerID: Players.GetLocalPlayer(),
        steamID: steamId
    }
    GameEvents.SendCustomGameEventToServer("request_stored_data", data);
}

function StackTrace() {
    var err = new Error();
    $.Msg(err.stack);
}

function GetStoredDataFor(steamId) {
    return GetStoredData()["" + steamId];
}

function UpdateData(data) {
    GetStoredData()["" + data.steamID] = data;
}

function GetStoredData() {
    Init();
    return GameUI.CustomUIConfig().StoredData;
}

function Init() {
    if (GameUI.CustomUIConfig().StoredData == null) {
        GameUI.CustomUIConfig().StoredData = {};
        GameUI.CustomUIConfig().StoredData.Requests = [];
        GameEvents.Subscribe("send_stored_data", UpdateData);
    }
}

function GetDataOf(steamID, key) {
    var data = GetStoredDataFor(steamID);
    if (data == null) {
        RequestStoredDataFor(steamID);
        return -1;
    }
    return data[key];
}

function GetAllF1ctions(steamID) {
    var data = GetStoredDataFor(steamID);
    if (data == null) {
        return {}
    }
    var keys = Object.keys(data);
    var result = {};
    for (var key in keys) {
        if (keys[key].indexOf("kills_") != -1) {
            result[key] = keys[key];
        }
    }
    return result;
}

function GetKillsOfFraction(steamID, fraction) {
    return GetDataOf(steamID, "killed_" + fraction);
}

function GetKillsOf(steamID) {
    return GetDataOf(steamID, "kills");
}

function GetLeaksOf(steamID) {
    return GetDataOf(steamID, "leaks");
}

function GetExperienceOf(steamID) {
    return GetDataOf(steamID, "experience");
}

function GetEarnedTangosOf(steamID) {
    return GetDataOf(steamID, "earned_tangos");
}

function GetLevelOf(steamID) {
    return ExpToLevel(GetExperienceOf(steamID));
}

function GetRequiredExpForLevel(level) {
    if (level > 300)
        return 9999999999999999999;
    return level * level * 500 - 500;
}

function ExpToLevel(exp) {
    var level = 1;
    while (exp >= GetRequiredExpForLevel(level + 1))
        level++;
    return level;
}

function GetExpSinceLastLevel(steamID) {
    var exp = GetExperienceOf(steamID);
    var level = GetLevelOf(steamID);
    var exp1 = GetRequiredExpForLevel(level);
    return exp - exp1;
}

function GetExpForNextLevel(steamID) {
    var level = GetLevelOf(steamID);
    var exp1 = GetRequiredExpForLevel(level);
    var exp2 = GetRequiredExpForLevel(level + 1);
    return exp2 - exp1;
}

function GetExpPercantage(steamID) {
    var exp = GetExpSinceLastLevel(steamID);
    var required = GetExpForNextLevel(steamID);
    return exp / required;
}

(function () {
    Init();
})();
