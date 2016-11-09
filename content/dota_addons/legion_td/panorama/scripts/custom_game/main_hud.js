"use strict";

GameUI.CustomUIConfig().units =  new Array(
	{id : 1001, cost : 20, income : 1, cooldown : 0, name : "incomeunit_kobold", icon : "send_incomeunit_kobold"},
	{id : 1002, cost : 45, income : 1, cooldown : 0, name : "incomeunit_hill_troll_shaman", icon : "send_incomeunit_hill_troll_shaman"},
	{id : 1003, cost : 50, income : 2, cooldown : 0, name : "incomeunit_hill_troll_warrior", icon : "send_incomeunit_hill_troll_warrior"},
	{id : 1004, cost : 75, income : 2, cooldown : 0, name : "incomeunit_harpy", icon : "send_incomeunit_harpy"},
	{id : 1005, cost : 100, income : 3, cooldown : 4, name : "incomeunit_ghost", icon : "send_incomeunit_ghost"},
	{id : 1006, cost : 125, income : 4, cooldown : 5, name : "incomeunit_little_wolf", icon : "send_incomeunit_little_wolf"},
	{id : 1007, cost : 150, income : 5, cooldown : 6, name : "incomeunit_satyr", icon : "send_incomeunit_satyr"},
	{id : 1008, cost : 175, income : 4, cooldown : 6, name : "incomeunit_ogre_warrior", icon : "send_incomeunit_ogre_warrior"},
	{id : 1009, cost : 200, income : 6, cooldown : 7, name : "incomeunit_little_centaur", icon : "send_incomeunit_little_centaur"},
	{id : 1010, cost : 225, income : 7, cooldown : 9, name : "incomeunit_wolf", icon : "send_incomeunit_wolf"},
	{id : 1011, cost : 250, income : 6, cooldown : 10, name : "incomeunit_golem", icon : "send_incomeunit_golem"},
	{id : 1013, cost : 275, income : 8, cooldown : 11, name : "incomeunit_centaur", icon : "send_incomeunit_centaur"},
	{id : 1014, cost : 300, income : 10, cooldown : 12, name : "incomeunit_vulture", icon : "send_incomeunit_vulture"},
	{id : 1015, cost : 325, income : 10, cooldown : 13, name : "incomeunit_lizard", icon : "send_incomeunit_lizard"},
	{id : 1016, cost : 400, income : 10, cooldown : 14, name : "incomeunit_lycanwolf", icon : "send_incomeunit_lycanwolf"},
	{id : 1017, cost : 425, income : 10, cooldown : 15, name : "incomeunit_black_drake", icon : "send_incomeunit_black_drake"},
	{id : 1018, cost : 450, income : 10, cooldown : 16, name : "incomeunit_big_lizard", icon : "send_incomeunit_big_lizard"},
	{id : 1019, cost : 500, income : 10, cooldown : 17, name : "incomeunit_ancientgolem", icon : "send_incomeunit_ancient_golem"},
	{id : 1020, cost : 550, income : 10, cooldown : 18, name : "incomeunit_fleshgolem", icon : "send_incomeunit_fleshgolem"},
	{id : 1021, cost : 600, income : 10, cooldown : 19, name : "incomeunit_jellyfish", icon : "send_incomeunit_jellyfish"},
	{id : 1022, cost : 650, income : 10, cooldown : 20, name : "incomeunit_hulk", icon : "send_incomeunit_hulk"},
	{id : 1023, cost : 700, income : 10, cooldown : 21, name : "incomeunit_beast", icon : "send_incomeunit_beast"},
	{id : 1024, cost : 750, income : 10, cooldown : 22, name : "incomeunit_diablo", icon : "send_incomeunit_diablo"},
	{id : 1025, cost : 800, income : 12, cooldown : 23, name : "incomeunit_roshan", icon : "send_incomeunit_rosh"}
);

var overlay = null;

function AddUnit(unit, row) {
	var unitPanel = $.CreatePanel("Panel", row, unit.name);
	unitPanel.BLoadLayout("file://{resources}/layout/custom_game/shop_unit.xml", false, false);
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
	unitRow.BLoadLayout("file://{resources}/layout/custom_game/shop_unit_row.xml", false, false);
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

function OnMinimizedButtonPressed() {
	$("#LowerStatisticsButton").ToggleClass("Minimized");
}

function OnSkipButtonPressed() {
	$.GetContextPanel().SetHasClass("SkipPressed", true);
	var data = {
		playerID : Players.GetLocalPlayer()
	}
	GameEvents.SendCustomGameEventToServer("skip_pressed", data);
}

function OnStatisticsButtonPressed() {
	overlay.ToggleClass("ShowStatistics");
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
	$("#tangoIncome").text = "" + infos.tango_income + $.Localize("#tango_income_text");
	if (infos.max_tangos != -1)
	 	$("#tangoIncome").text += "\n" + infos.max_tangos + " " + $.Localize("#tango_maximum_text");
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
	$("#ErrorMessage").text = $.Localize(data.error);

	$.Schedule(1, ClearErrorMessage);
}

function ClearErrorMessage() {
	$.GetContextPanel().SetHasClass("error_appeared", false);
	$("#ErrorMessage").text = "";
}

function GetInfoPanel() {
	return $("InfoPanel")
}

function EnableSkip(data) {
	$.GetContextPanel().SetHasClass("SkipPressed", data.value == 0);
}

function InitStatisticsOverlay() {
	overlay = $.CreatePanel("Panel", $("#StatisticsOverlay"), "StatisticsOverlay");
	overlay.BLoadLayout("file://{resources}/layout/custom_game/statistics_overlay.xml", false, false);
	var playerLevel = $.CreatePanel("Panel", $("#LegionLevelHook"), "PlayerLevel");
	playerLevel.SetAttributeString("steam_id", Game.GetLocalPlayerInfo().player_steamid);
	playerLevel.BLoadLayout("file://{resources}/layout/custom_game/statistics_player_level.xml", false, false);
	var playerProgress = $.CreatePanel("Panel", $("#LegionProgressHook"), "PlayerProgress");
	playerProgress.SetAttributeString("steam_id", Game.GetLocalPlayerInfo().player_steamid);
	playerProgress.BLoadLayout("file://{resources}/layout/custom_game/statistics_experience_progress.xml", false, false);
	AutoRequestStoredDataFor(Game.GetLocalPlayerInfo().player_steamid);
}

(function () {
	GameEvents.Subscribe("dota_player_update_query_unit", UpdateInfoPanel);
	GameEvents.Subscribe("update_player_info", UpdatePlayerInfo);
	GameEvents.Subscribe("debug", UpdateDebug);
	GameEvents.Subscribe("error", ErrorMessage);
    GameEvents.Subscribe("enable_skip", EnableSkip);
	for (var i = 0; i < 3; i++) {
		var upgrade = $.CreatePanel("Panel", $("#Upgrades"), "KingHealthUpgrade");
		upgrade.BLoadLayout("file://{resources}/layout/custom_game/shop_upgrade.xml", false, false);
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
	InitStatisticsOverlay();
})();
