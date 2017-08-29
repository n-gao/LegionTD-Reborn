"use strict"

function UpdateExperience() {
    var perc = GetExpPercantage(steam_id);
    $("#ExperienceBar").style.width = "" + Math.round(perc * 100) + "%";
    $("#ExperienceLabel").text = GetExpSinceLastLevel(steam_id) + "/" + GetExpForNextLevel(steam_id);
    $.Schedule(1, UpdateExperience)
}

(function () {
    RequestStoredDataFor(steam_id);
    UpdateExperience();
})();
