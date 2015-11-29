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

(function() {
    GameEvents.Subscribe("update_time", UpdateTimer);
    GameEvents.Subscribe("update_round", UpdateRound);
})();
