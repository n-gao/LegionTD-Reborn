"use strict";
var steam_id;

//--------------------------------------------------------------------------------------------------
// Handeler for when the unssigned players panel is clicked that causes the player to be reassigned
// to the unssigned players team#
//--------------------------------------------------------------------------------------------------
function OnLeaveTeamPressed() {
	Game.PlayerJoinTeam(5); // 5 == unassigned ( DOTA_TEAM_NOTEAM )
}


//--------------------------------------------------------------------------------------------------
// Update the contents of the player panel when the player information has been modified.
//--------------------------------------------------------------------------------------------------
function OnPlayerDetailsChanged() {
	var playerId = $.GetContextPanel().GetAttributeInt("player_id", -1);
	var playerInfo = Game.GetPlayerInfo(playerId);
	steam_id = playerInfo.player_steamid;
	if (!playerInfo)
		return;
	$("#PlayerName").text = playerInfo.player_name;
	$("#PlayerAvatar").steamid = playerInfo.player_steamid;

	$.GetContextPanel().SetHasClass("player_is_local", playerInfo.player_is_local);
	$.GetContextPanel().SetHasClass("player_has_host_privileges", playerInfo.player_has_host_privileges);

	SetTitle();
}

function SetTitle() {
	var title = "";
	if (Contains(GameUI.CustomUIConfig().Creator, steam_id)) {
		title = $.Localize("#legion_contributor_creator");
	} else if (Contains(GameUI.CustomUIConfig().Leaders, steam_id)) {
		title = $.Localize("#legion_contributor_leader");
	} else if (Contains(GameUI.CustomUIConfig().PreviousLeaders, steam_id)) {
		title = $.Localize("#legion_constributor_previous_leader");
	} else if (Contains(GameUI.CustomUIConfig().GameDesigners, steam_id)) {
		title = $.Localize("#legion_contributor_design");
	} else if (Contains(GameUI.CustomUIConfig().Programmers, steam_id)) {
		title = $.Localize("#legion_contributor_programming");
	}
	$("#PlayerTitle").text = title;
}

function Contains(array, toSearch) {
	var result;
	array.forEach(function (entry) { if (entry == toSearch) result = true; });
	return result;
}

//--------------------------------------------------------------------------------------------------
// Entry point, update a player panel on creation and register for callbacks when the player details
// are changed.
//--------------------------------------------------------------------------------------------------
(function () {
	OnPlayerDetailsChanged();
	$.RegisterForUnhandledEvent("DOTAGame_PlayerDetailsChanged", OnPlayerDetailsChanged);
})();
