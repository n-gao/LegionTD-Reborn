"use strict";

function OnHover() {
	$.GetContextPanel().SetHasClass("Hovered", true);
}

function OnEndHover() {
	$.GetContextPanel().SetHasClass("Hovered", false);
}

function OnUpgradeClicked() {
	var data = {
		id : Players.GetLocalPlayer(),
		type : $.GetContextPanel().GetAttributeInt("UpgradeType", 0),
		cost : 100,
		income : 3
	};
	GameEvents.SendCustomGameEventToServer("upgarde_king", data);
}
