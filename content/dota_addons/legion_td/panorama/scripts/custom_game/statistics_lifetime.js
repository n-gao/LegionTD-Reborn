//var steam_id = "76561198334931074";
var steam_id = Game.GetLocalPlayerInfo().player_steamid;

function GetWinRate() {
    var wonGames = GetDataOf(steam_id, "won_games");
    var lostGames = GetDataOf(steam_id, "lost_games");
    if (wonGames + lostGames == 0) {
        return "0%";
    }
    return Math.floor(wonGames/(wonGames + lostGames) * 1000) / 10 + "%";
}

function InitAttribute(key, valueFunc) {
    var attribute = $.CreatePanel("Panel", $("#LifetimeAttributes"), key + "Attribute");
    attribute.SetAttributeString("Key", key);
    GameUI.CustomUIConfig().ValueFunctions[key] = valueFunc;
    attribute.BLoadLayout("file://{resources}/layout/custom_game/statistics_lifetime_attribute.xml", false, false);	
}

function InitSimpleAttribute(key, attributeName) {
    var valueFunc = function() {
        return GetDataOf(steam_id, attributeName);
    }
    InitAttribute(key, valueFunc);
}

function InitFractionKillAttribute(fraction) {
    InitAttribute("Killed " + CapitalizeFirstLetter(fraction) + " Units",
     function() {return GetKillsOfFraction(steam_id, fraction)});
}

function CapitalizeFirstLetter(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
}

function ToPercentage(str) {
    if (str === -1) return 0+'%';
    var win_rate = parseFloat(str == undefined ? "NaN" : str.replace(',','.'));
    if (win_rate === NaN)
        win_rate = 0;
    return Math.floor(win_rate*100)+'%';
}

function ToTime(str) {
    var sec = parseInt(str);
    var minutes = GetMinutes(sec);
    var hours = GetHours(sec);
    return GetHours(sec)+':'+(minutes<10 ? '0' : '')+minutes;
}

function GetHours(sec) {
    return Math.floor(sec/3600);
}

function GetMinutes(sec) {
    return Math.floor(sec/60)%60;
}

(function() {
    GameUI.CustomUIConfig().ValueFunctions = {};
    InitAttribute("Time Played", function(){ return ToTime(GetDataOf(steam_id, "time_played"));});
    InitAttribute("Level", function() { return GetLevelOf(steam_id);});
    InitSimpleAttribute("Experience", "experience");
    InitSimpleAttribute("Rating", "rating");
    InitSimpleAttribute("Won Games", "won_games");
    InitSimpleAttribute("Lost Games", "lost_games");
    InitAttribute("Win Rate", function() {return ToPercentage(GetDataOf(steam_id, "win_rate"));});
    InitSimpleAttribute("Won Duels", "won_duels");
    InitSimpleAttribute("Lost Duels", "lost_duels");
    InitAttribute("Duel Win Rate", function() {return ToPercentage(GetDataOf(steam_id, "duel_win_rate"));});
    InitSimpleAttribute("Earned Tangos", "earned_tangos");
    InitAttribute("Tangos per Minute", function() {return parseInt(GetDataOf(steam_id, "tangos_per_minute"))});
    InitSimpleAttribute("Earned Gold", "earned_gold");
    InitAttribute("Gold per Minute", function() {return parseInt(GetDataOf(steam_id, "gold_per_minute"))});
    InitSimpleAttribute("Kills", "kills");
    InitSimpleAttribute("Leaks", "leaks");
    InitFractionKillAttribute("wave");
    InitFractionKillAttribute("income");
    InitFractionKillAttribute("human");
    InitFractionKillAttribute("elemental");
    InitFractionKillAttribute("nature");
    InitFractionKillAttribute("assassin");
})();
 