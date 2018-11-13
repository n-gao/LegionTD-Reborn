"use strict"

var path = "file://{images}/custom_game/levels/";
var filetype = ".png";

function GetLevel(steamId) {
    return Math.ceil(Math.random() * 100);
}

function UpdateLevel() {
    var storedData = GetStoredDataFor(steam_id);
    var level = GetLevelOf(steam_id);
    var iconLevel = (level - 1) % 100 + 1;
    $("#LegionLevelBackground").SetHasClass("silver", level > 100);
    $("#LegionLevelBackground").SetHasClass("gold", level > 200);
    $("#LevelIcon").SetImage(path + LeftPad(iconLevel, "0", 3) + filetype);
    $("#LevelLabel").text = level;
    $.Schedule(1, UpdateLevel);
}

(function () {
    RequestStoredDataFor(steam_id);
    UpdateLevel();
})();
