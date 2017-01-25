"use strict";

function UpdateTimer(data)
{
  var timerText = "";
  timerText += data.timer_minute;
  timerText += ":";
  timerText += data.timer_second;

  $("#Time").text = timerText;
}

function UpdateRound(data)
{
  var roundText = "";
  roundText += data.round;

  $("#CurrentRound").text = roundText;
}

function UpdateCountDown(data) {
  $("#RoundPanel").SetHasClass("BetweenRounds", data.betweenRounds);
  var countDownText = Math.round(data.seconds) + "s";
  $("#CountDown").text = countDownText;
}

(function() {
    GameEvents.Subscribe("update_countdown", UpdateCountDown);
    GameEvents.Subscribe("update_time", UpdateTimer);
    GameEvents.Subscribe("update_round", UpdateRound);
})();
