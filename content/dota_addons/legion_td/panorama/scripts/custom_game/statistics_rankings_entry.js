"use strict";


(function () {
    $("#Name").steamid = $.GetContextPanel().GetAttributeString("SteamID", "Missing Rank");
    $("#Avater").steamid = $.GetContextPanel().GetAttributeString("SteamID", "Missing Rank");
    $("#Rank").text = parseInt($.GetContextPanel().GetAttributeString("Rank", "-1")) + 1;
    $("#Value").text = $.GetContextPanel().GetAttributeString("Value", "Missing Value");
})();
