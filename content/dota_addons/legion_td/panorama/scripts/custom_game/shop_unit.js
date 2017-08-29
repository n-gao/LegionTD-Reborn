"use strict";

var data;

function OnHover() {
	$.GetContextPanel().SetHasClass("Hovered", true);
}

function OnEndHover() {
	$.GetContextPanel().SetHasClass("Hovered", false);
}

function OnUnitClicked() {
	var panel = $.GetContextPanel();
	var morePlayerInfos = GameUI.CustomUIConfig().morePlayerInfos[Players.GetLocalPlayer()];
	if (Game.GetDOTATime(false, false) > panel.GetAttributeInt("nextUse", 0)) {
		data = {
			id: panel.GetAttributeInt("id", 0),
			cost: panel.GetAttributeInt("cost", 0),
			income: panel.GetAttributeInt("income", 0),
			playerID: Players.GetLocalPlayer()
		};
		GameEvents.SendCustomGameEventToServer("send_unit", data);
		if (morePlayerInfos.tango_count >= data.cost) {
			SetCooldown();
		}
	}
}

function SendUnitSucessfull(data) {
	if (data.sucessfull) {
		SetCooldown();
	} else {

	}
}

function SetCooldown() {
	var panel = $.GetContextPanel();
	var cooldown = panel.GetAttributeInt("cooldown", 0);
	panel.SetAttributeInt("nextUse", Game.GetDOTATime(false, false) + cooldown);
	SetTintVisible(true);
	$.Schedule(0.5, CheckCooldown);
}

function SetTintVisible(bool) {
	if (bool) {
		$.GetContextPanel().FindChildInLayoutFile("UnitTint").SetHasClass("TintVisible", bool);
	} else {
		$.GetContextPanel().FindChildInLayoutFile("UnitTint").SetHasClass("FadeTint", true);
		$.Schedule(0.2, RemoveTint);
	}
}

function RemoveTint() {
	$.GetContextPanel().FindChildInLayoutFile("UnitTint").SetHasClass("TintVisible", false);
	$.GetContextPanel().FindChildInLayoutFile("UnitTint").SetHasClass("FadeTint", false);
}

function CheckCooldown() {
	var panel = $.GetContextPanel();
	if (Game.GetDOTATime(false, false) > panel.GetAttributeInt("nextUse", 0)) {
		SetTintVisible(false);
	} else {
		$.Schedule(0.5, CheckCooldown);
	}
}
