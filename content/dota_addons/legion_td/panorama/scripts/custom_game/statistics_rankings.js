"use strict";
var attribute = "experience";
var start = 0;
var end = 15;

function OnRankingChanged() {
    SetRanking($("#RankingAttributeDropDown").GetSelected().id);
}

function SetRanking(newAttribute) {
    $.Msg("Changed Ranking to " + newAttribute);
    attribute = newAttribute;
    RequestRankingFromTo(attribute, start, end, function(result) {
        ClearRanking();
        $("#RankingAttributeLabel").text = $("#RankingAttributeDropDown").GetSelected().text;
        for (var i = start; i < result.length; i++) {
            AddRankingEntry(attribute, result[i], i + start);
        }
    });
}

function ClearRanking() {
    $("#RankingList").RemoveAndDeleteChildren();
}

function AddRankingEntry(attribute, steamID, rank) {
    var entry = $.CreatePanel("Panel", $("#RankingList"), steamID + "Ranking");
    var value = GetDataOf(steamID, attribute);
    entry.SetAttributeString("SteamID", steamID);
    entry.SetAttributeString("Rank", rank);
    entry.SetAttributeString("Value", value);
    entry.BLoadLayout("file://{resources}/layout/custom_game/statistics_rankings_entry.xml", false, false);	
} 

(function() {
    SetRanking("experience");
})();
