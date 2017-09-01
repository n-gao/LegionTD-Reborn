"use strict";

function GetMinutes(seconds) {
    return Math.floor(seconds / 60);
}

function formatDate(date) {
    var monthNames = [
        "January", "February", "March",
        "April", "May", "June", "July",
        "August", "September", "October",
        "November", "December"
    ];

    var day = date.getDate();
    var month = date.getMonth();
    var year = date.getFullYear();
    var hour = date.getHours();
    var minutes = date.getMinutes();

    return (day > 9 ? '' : '0') + day + '.'
        + (month > 9 ? '' : '0') + month + '.'
        + year + ' '
        + (hour > 9 ? '' : '0') + hour + ':'
        + (minutes > 9 ? '' : '0') + minutes;
}


(function () {
    var won = $.GetContextPanel().GetAttributeInt("Won", 0);
    var result = $.GetContextPanel().GetAttributeInt("RatingChange", 0);
    var duration = $.GetContextPanel().GetAttributeInt("Duration", 0);
    var builder = $.GetContextPanel().GetAttributeString("Builder", 0);
    var date = $.GetContextPanel().GetAttributeString("Date", "");
    var isTraining = $.GetContextPanel().GetAttributeInt("Training", 1);
    var d = new Date(date);
    $("#Result").text = result >= 0 ? "+" + result : result;
    $("#Result").SetHasClass("Won", won);
    $("#Result").SetHasClass("Lost", !won);
    var min = GetMinutes(duration);
    var seconds = duration - min * 60;
    $("#Duration").text = min + ":" + seconds;
    $("#Date").text = formatDate(d);
    $("#BuilderName").text = $.Localize(builder + "builder");
    $("#BuilderImage").SetImage("file://{resources}/images/custom_game/buildericons/" + builder + ".png");
})();
