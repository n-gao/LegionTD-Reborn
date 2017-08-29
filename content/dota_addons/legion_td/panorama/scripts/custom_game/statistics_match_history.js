"use strict";

function AddMatchEntry(matchData) {
    var entry = $.CreatePanel("Panel", $("#MatchList"), "Match_" + matchData.id);
    entry.SetAttributeInt("MatchId", matchData.id);
    entry.SetAttributeInt("RatingChange", matchData.ratingChange);
    entry.SetAttributeInt("Duration", matchData.duration);
    entry.SetAttributeInt("Won", matchData.won);
    entry.SetAttributeString("Date", matchData.date);
    entry.SetAttributeString("Builder", matchData.builder);
    entry.SetAttributeString("Training", matchData.isTraining);
    entry.BLoadLayout("file://{resources}/layout/custom_game/statistics_match_entry.xml", false, false);
}

function ClearMatchList() {
    $("#MatchList").RemoveAndDeleteChildren();
}

(function () {
    ClearMatchList();
    RequestMatchHistory(0, 5, function (result) {
        for (var i in result) {
            if (result[i] === undefined)
                continue;
            var id = result[i];
            var match = GetMatchData(id);
            AddMatchEntry(match);
        }
    });
})();