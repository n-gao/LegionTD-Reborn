function UpdatePlayerInfo()
{
  var creator_steamid = $.GetContextPanel().GetAttributeString("creator_steamid", -1);
  var creator_name = $.GetContextPanel().GetAttributeString("creator_name", "");
  var creator_title = $.GetContextPanel().GetAttributeString("creator_title", "");
	$( "#PlayerName" ).text = creator_name;
	$( "#PlayerAvatar" ).steamid = creator_steamid;
  $( "#PlayerTitle" ).text = creator_title;
}

(function()
{
	UpdatePlayerInfo();
})();
