var playerCount = 8;
var voteOptionNames = [];

function IncomeTogglePressed() {
  var data = {
    playerID: Players.GetLocalPlayer(),
    value: $("#IncomeToggle").checked
  };
  GameEvents.SendCustomGameEventToServer("toggle_income_limit", data);
}

function VoteOptionClicked(opt) {
  var data = {
    option: opt,
    playerID: Players.GetLocalPlayer(),
    value: $("#" + opt).checked
  };
  GameEvents.SendCustomGameEventToServer("vote_option_clicked", data);
}

function UpdateVoteLabel(data) {
  if (voteOptionNames[data.option] == null) {
    voteOptionNames[data.option] = $("#" + data.option).text;
  }
  playerCount = data.playerCount;
  $("#" + data.option).text = voteOptionNames[data.option] + " " + data.votes + "/" + playerCount;
}

(function () {
  GameEvents.Subscribe("update_vote_label", UpdateVoteLabel);
})();
