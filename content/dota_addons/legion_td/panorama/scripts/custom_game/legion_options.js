function IncomeTogglePressed() {
  var data = {
    playerID : Players.GetLocalPlayer(),
    value : $("#IncomeToggle").checked
  };
  GameEvents.SendCustomGameEventToServer("toggle_income_limit", data);
}
