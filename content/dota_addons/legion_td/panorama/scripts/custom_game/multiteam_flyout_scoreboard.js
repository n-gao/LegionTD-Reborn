"use strict";

var g_ScoreboardHandle = null;
var locked = false;

function SetFlyoutScoreboardVisible( bVisible )
{
	var b = bVisible || locked;
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", b);
	ScoreboardUpdater_SetScoreboardActive( g_ScoreboardHandle, b);
}

function SwitchLock() {
	locked = !locked;
}

(function()
{
	if ( ScoreboardUpdater_InitializeScoreboard === null ) { $.Msg( "WARNING: This file requires shared_scoreboard_updater.js to be included." ); }

	var scoreboardConfig =
	{
		"teamXmlName" : "file://{resources}/layout/custom_game/my_multiteam_flyout_scoreboard_team.xml",
		"playerXmlName" : "file://{resources}/layout/custom_game/my_multiteam_flyout_scoreboard_player.xml",
	};
	g_ScoreboardHandle = ScoreboardUpdater_InitializeScoreboard( scoreboardConfig, $( "#TeamsContainer" ) );

	SetFlyoutScoreboardVisible( true );

	$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
