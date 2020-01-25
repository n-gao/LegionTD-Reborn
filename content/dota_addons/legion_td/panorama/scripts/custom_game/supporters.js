"use strict";

function UpdateSupporters(supporters) {
    GameUI.CustomUIConfig().Supporters = supporters;
    $.DispatchEvent("DOTAGame_PlayerDetailsChanged", null);
}

(function() {
    GameUI.CustomUIConfig().Supporters = [];
    GameEvents.Subscribe("supporters", UpdateSupporters);
})();
