"use strict";

GameUI.CustomUIConfig().units =  new Array(
	{id : 1001, cost : 20, income : 1, cooldown : 1, name : "incomeunit_kobold", icon : "send_incomeunit_kobold"},
	{id : 1002, cost : 40, income : 1, cooldown : 2, name : "incomeunit_hill_troll_shaman", icon : "send_incomeunit_hill_troll_shaman"},
	{id : 1003, cost : 40, income : 2, cooldown : 2, name : "incomeunit_hill_troll_warrior", icon : "send_incomeunit_hill_troll_warrior"},
	{id : 1004, cost : 60, income : 3, cooldown : 3, name : "incomeunit_harpy", icon : "send_incomeunit_harpy"},
	{id : 1005, cost : 80, income : 3, cooldown : 4, name : "incomeunit_ghost", icon : "send_incomeunit_ghost"},
	{id : 1006, cost : 100, income : 4, cooldown : 5, name : "incomeunit_little_wolf", icon : "send_incomeunit_little_wolf"},
	{id : 1007, cost : 120, income : 5, cooldown : 6, name : "incomeunit_satyr", icon : "send_incomeunit_satyr"},
	{id : 1008, cost : 120, income : 4, cooldown : 6, name : "incomeunit_ogre_warrior", icon : "send_incomeunit_ogre_warrior"},
	{id : 1009, cost : 150, income : 6, cooldown : 7, name : "incomeunit_little_centaur", icon : "send_incomeunit_little_centaur"},
	{id : 1010, cost : 180, income : 7, cooldown : 9, name : "incomeunit_wolf", icon : "send_incomeunit_wolf"},
	{id : 1011, cost : 200, income : 6, cooldown : 10, name : "incomeunit_golem", icon : "send_incomeunit_golem"},
	{id : 1013, cost : 200, income : 8, cooldown : 10, name : "incomeunit_centaur", icon : "send_incomeunit_centaur"},
	{id : 1014, cost : 250, income : 10, cooldown : 10, name : "incomeunit_vulture", icon : "send_incomeunit_vulture"},
	{id : 1015, cost : 270, income : 10, cooldown : 10, name : "incomeunit_lizard", icon : "send_incomeunit_lizard"},
	{id : 1016, cost : 300, income : 10, cooldown : 10, name : "incomeunit_lycanwolf", icon : "send_incomeunit_lycanwolf"},
	{id : 1017, cost : 350, income : 11, cooldown : 10, name : "incomeunit_black_drake", icon : "send_incomeunit_black_drake"},
	{id : 1018, cost : 380, income : 12, cooldown : 10, name : "incomeunit_big_lizard", icon : "send_incomeunit_big_lizard"},
	{id : 1019, cost : 400, income : 13, cooldown : 10, name : "incomeunit_ancientgolem", icon : "send_incomeunit_ancient_golem"},
	{id : 1020, cost : 440, income : 14, cooldown : 10, name : "incomeunit_fleshgolem", icon : "send_incomeunit_fleshgolem"},
	{id : 1021, cost : 450, income : 14, cooldown : 10, name : "incomeunit_jellyfish", icon : "send_incomeunit_jellyfish"},
	{id : 1022, cost : 480, income : 15, cooldown : 10, name : "incomeunit_hulk", icon : "send_incomeunit_hulk"},
	{id : 1023, cost : 500, income : 15, cooldown : 10, name : "incomeunit_beast", icon : "send_incomeunit_beast"},
	{id : 1024, cost : 550, income : 15, cooldown : 10, name : "incomeunit_diablo", icon : "send_incomeunit_diablo"},
	{id : 1025, cost : 600, income : 16, cooldown : 10, name : "incomeunit_roshan", icon : "send_incomeunit_rosh"}
);

var LEGION_ERROR_BETWEEN_ROUNDS = 0;
var LEGION_ERROR_NOT_ENOUGH_TANGOS = 1;
var LEGION_ERROR_INVALID_LOCATION = 2;
var LEGION_ERROR_NOT_ENOUGH_FOOD = 3;
var LEGION_ERROR_TO_CLOSE = 4;
var LEGION_ERROR_TO_MANY_UPGRADES = 5;
var LEGION_ERROR_DURING_DUEL = 6;

function AddUnit(unit, row) {
	var unitPanel = $.CreatePanel("Panel", row, unit.name);
	unitPanel.BLoadLayout("file://{resources}/layout/custom_game/squadron_unit.xml", false, false);
	var icon = unitPanel.FindChildInLayoutFile("UnitIcon");
	var iconName = "file://{resources}/images/custom_game/spellicons/"+unit.icon+".png";
	icon.SetImage(iconName);
	var cost = unitPanel.FindChildInLayoutFile("TangoCostLabel");
	var income = unitPanel.FindChildInLayoutFile("GoldIncomeLabel");
	var desc = unitPanel.FindChildInLayoutFile("DescLabel");
	income.text = "Income: " + unit.income;
	cost.text = "Cost: "+ unit.cost;
	desc.text = $.Localize("#DOTA_Tooltip_ability_"+unit.icon+"_Description").split(": ").pop();
	unitPanel.SetAttributeInt("id", unit.id);
	unitPanel.SetAttributeInt("cost", unit.cost);
	unitPanel.SetAttributeInt("cooldown", unit.cooldown);
	unitPanel.SetAttributeInt("income", unit.income);
	unitPanel.SetAttributeString("name", unit.name);
	unitPanel.SetAttributeString("iconname", unit.icon);
	return unitPanel;
}

function NewRow(id) {
	var unitRow = $.CreatePanel("Panel", $("#Units"), "row_" + id);
	unitRow.BLoadLayout("file://{resources}/layout/custom_game/squadron_unit_row.xml", false, false);
	return unitRow;
}

function AddUnits(units) {
	var rowID = 0;
	var currentRow = null;
	for (var i = 0; i < units.length; i++) {
		if (i % 4 == 0) {
			currentRow = NewRow(rowID);
			rowID++;
		}
		var unitPanel = AddUnit(units[i], currentRow);
	}
}


function OnShopButtonPressed() {
	$("#ShopPanel").ToggleClass("ShopPanelVisible");
}


function UpdatePlayerInfo(data) {
	UpdateInfoPanel();
}

function UpdateInfoPanel() {
	var morePlayerInfos = GameUI.CustomUIConfig().morePlayerInfos;
	var selected = Players.GetQueryUnit(Players.GetLocalPlayer());
	var displayedPlayer = Players.GetLocalPlayer();
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerTeamId = -1;
	if ( localPlayer )
	{
		localPlayerTeamId = localPlayer.player_team_id;
	}

	if (selected != -1) {
		for (var i = 0; i < morePlayerInfos.length; i++) {
			var plInfo = Game.GetPlayerInfo(i);
			if (plInfo && plInfo.player_team_id == localPlayerTeamId) {
				if (selected == Players.GetPlayerHeroEntityIndex(i)) {
					displayedPlayer = i;
				}
			}
		}
	}
	var infos = morePlayerInfos[displayedPlayer];
	$("#tangos").text = "" + infos.tango_count;
	$("#goldIncome").text = "" + infos.gold_income + $.Localize("#gold_income_text");
	$("#tangoIncome").text = "" + infos.tango_income + $.Localize("#tango_income_text") + "\n" + infos.max_tangos + " " + $.Localize("#tango_maximum_text");
	$("#foodLabel").text = "" + infos.current_food + "/" + infos.max_food;
}

function UpdateDebug(data) {
	var text = "";
	text += data.text;

	$("#LastDebug").text = $("#Debug").text;
	$("#Debug").text = text;
}

function ErrorMessage(data) {
	$.GetContextPanel().SetHasClass("error_appeared", true);
	var text;
	switch (data.errorCode) {
		case LEGION_ERROR_BETWEEN_ROUNDS:
		text = $.Localize("#Error_not_between_rounds");
		break;
		case LEGION_ERROR_NOT_ENOUGH_TANGOS:
		text = $.Localize("#Error_not_enough_tangos");
		break;
		case LEGION_ERROR_INVALID_LOCATION:
		text = $.Localize("#Error_invalid_location");
		break;
		case LEGION_ERROR_NOT_ENOUGH_FOOD:
		text = $.Localize("#Error_not_enough_food");
		break;
		case LEGION_ERROR_TO_CLOSE:
		text = $.Localize("#Error_to_close_to_another");
		break;
		case LEGION_ERROR_TO_MANY_UPGRADES:
		text = $.Localize("#Error_to_many_king_upgrades");
		break;
		case LEGION_ERROR_DURING_DUEL:
		text = $.Localize("#Error_not_possible_in_last_duel");
		break;
		default:
		text = $.Localize("#Error_unknown");
	}
	$("#ErrorMessage").text = text;

	$.Schedule(1, ClearErrorMessage);
}

function ClearErrorMessage() {
	$.GetContextPanel().SetHasClass("error_appeared", false);
	$("#ErrorMessage").text = "";
}

function GetInfoPanel() {
	return $("InfoPanel")
}

(function () {
	GameEvents.Subscribe("dota_player_update_query_unit", UpdateInfoPanel);
	GameEvents.Subscribe("update_player_info", UpdatePlayerInfo);
	GameEvents.Subscribe("debug", UpdateDebug);
	GameEvents.Subscribe("error", ErrorMessage);
	for (var i = 0; i < 3; i++) {
		var upgrade = $.CreatePanel("Panel", $("#Upgrades"), "KingHealthUpgrade");
		upgrade.BLoadLayout("file://{resources}/layout/custom_game/squadron_upgrade.xml", false, false);
		upgrade.SetAttributeInt("UpgradeType", i);
		upgrade.FindChildInLayoutFile("DescLabel1").text = $.Localize("#Upgrade_King")
		var label = upgrade.FindChildInLayoutFile("DescLabel2");
		var icon = upgrade.FindChildInLayoutFile("Icon");
		switch (i) {
			case 0:
			label.text = $.Localize("#Upgrade_King_Health");
			icon.SetImage("file://{resources}/images/custom_game/spellicons/omniknight_purification.png");
			break;
			case 1:
			label.text = $.Localize("#Upgrade_King_Attack");
			icon.SetImage("file://{resources}/images/custom_game/spellicons/juggernaut_blade_dance.png");
			break;
			case 2:
			label.text = $.Localize("#Upgrade_King_Regen");
			icon.SetImage("file://{resources}/images/custom_game/spellicons/enchantress_natures_attendants.png");
			break;
			default:

		}
	}
	AddUnits(GameUI.CustomUIConfig().units);
})();
