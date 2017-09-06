"use strict";

var nextRoundTime = 0;

function RoundChanged(data) {
    $("#CurrentRound").text = "" + data.displayRound;
    $("#RoundPanel").SetHasClass("BetweenRounds", data.state == 0);
    nextRoundTime = data.nextRoundTime;
    $.Msg("Round updated:");
    $.Msg(data);
    UpdateTime();
}

function PeriodicallyUpdateTime() {
  UpdateTime();
  $.Schedule(0.1, PeriodicallyUpdateTime);
}

function UpdateTime() {
    var time = Game.GetGameTime();
    var mins = Math.floor(time/60);
    var secs = Math.floor(time) % 60;
    $("#Time").text = pad(mins, 2) + ":" + pad(secs, 2);
    $("#CountDown").text = Math.round(nextRoundTime - time) + "s";
}

function pad (num, max) {
    var str = num.toString();
    return str.length < max ? pad("0" + str, max) : str;
}

(function() {
    PeriodicallyUpdateTime();
    GameEvents.Subscribe("round_changed", RoundChanged);
})();
