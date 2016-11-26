"use strict"

var path = "file://{images}/custom_game/levels/";
var filetype = ".png";

function GetLevel(steamId) {
    return Math.ceil(Math.random() * 100);
}
 
function UpdateLevel() {
    var storedData = GetStoredDataFor(steam_id);
    var level = GetLevelOf(steam_id); 
    $("#LevelIcon").SetImage(path + LeftPad(level, "0", 3) + filetype);
    $("#LevelLabel").text = level;
    $.Schedule(1, UpdateLevel);
}

(function() {
    RequestStoredDataFor(steam_id);
    UpdateLevel();
})();
