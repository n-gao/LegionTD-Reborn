"use strict";


(function () {
    $("#Name").steamid = $.GetContextPanel().GetAttributeString("SteamID", "Missing Rank");
    $("#Avater").steamid = $.GetContextPanel().GetAttributeString("SteamID", "Missing Rank");
    $("#Rank").text = $.GetContextPanel().GetAttributeString("Rank", "Missing Rank");
    $("#Value").text = $.GetContextPanel().GetAttributeString("Value", "Missing Value");
})();
