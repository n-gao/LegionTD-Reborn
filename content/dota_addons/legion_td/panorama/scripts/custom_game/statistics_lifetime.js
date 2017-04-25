
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

(function() {
    GameUI.CustomUIConfig().ValueFunctions = {};
    InitAttribute("Level", function() { return GetLevelOf(steam_id);});
    InitSimpleAttribute("Experience", "experience");
    InitSimpleAttribute("Won Games", "won_games");
    InitSimpleAttribute("Lost Games", "lost_games");
    InitAttribute("Winrate", GetWinRate);
    InitSimpleAttribute("Won Duels", "won_duels");
    InitSimpleAttribute("Earned Tangos", "earned_tangos");
    InitSimpleAttribute("Kills", "kills");
    InitSimpleAttribute("Leaks", "leaks");
    InitFractionKillAttribute("wave");
    InitFractionKillAttribute("income");
    InitFractionKillAttribute("human");
    InitFractionKillAttribute("elemental");
    InitFractionKillAttribute("nature");
})();
