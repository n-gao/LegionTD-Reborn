"use strict";
var key;

function UpdateValue() {
    $("#Value").text = GameUI.CustomUIConfig().ValueFunctions[key]();
    $.Schedule(1, UpdateValue);
}

(function () {
    key = $.GetContextPanel().GetAttributeString("Key", "key");
    $("#Key").text = key;
    UpdateValue();
})();