function IncomeTogglePressed() {
  var data = {
    playerID : Players.GetLocalPlayer(),
    value : $("#IncomeToggle").checked
  };
  GameEvents.SendCustomGameEventToServer("toggle_income_limit", data);
}

function ReturnToSenderTogglePressed() {
  var data = {
    playerID : Players.GetLocalPlayer(),
    value : $("#RtsToggle").checked
  };
  GameEvents.SendCustomGameEventToServer("toggle_return_to_sender", data);
}