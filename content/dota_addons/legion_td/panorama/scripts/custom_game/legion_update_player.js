"use strict";

GameUI.CustomUIConfig().morePlayerInfos = new Array(Players.GetMaxPlayers());

function UpdatePlayerInfo(data) {
	var playerinfo = GameUI.CustomUIConfig().morePlayerInfos[data.playerID];
	playerinfo.leaks = data.leaks;
	playerinfo.tango_count = data.tangoCount;
	playerinfo.max_tangos = data.maxTangos;
	playerinfo.gold_income = data.goldIncome;
	playerinfo.tango_income = data.tangoIncome;
	playerinfo.current_food = data.currentFood;
	playerinfo.max_food = data.maxFood;
	playerinfo.towerValue = data.towerValue;
}

(function () {
	GameEvents.Subscribe("update_player_info", UpdatePlayerInfo);
	for (var i = 0; i < GameUI.CustomUIConfig().morePlayerInfos.length; i++) {
		GameUI.CustomUIConfig().morePlayerInfos[i] = { tango_count: 0, max_tangos: 0, gold_income: 0, tango_income: 0, leaks: 0, current_food: 0, max_food: 10, tower_value: 0 }
	}
})();
