//Shameless copy with some modifications of notifications library by bmddota https://github.com/bmddota/barebones

function TopNotification(msg) {
  AddNotification(msg, $('#WaveInfoNotifications'));
}

function AddNotification(msg, panel) {
  var newNotification = true;
  var lastNotification = panel.GetChild(panel.GetChildCount() - 1)

  lastNotification = $.CreatePanel('Panel', panel, '');
  lastNotification.AddClass('NotificationLine')
  lastNotification.hittest = false;

  var notification = null;

  notification = $.CreatePanel('Label', lastNotification, '');

  $.Schedule(msg.duration, function () {
    //$.Msg('callback')
    if (lastNotification.deleted)
      return;

    lastNotification.DeleteAsync(0);
  });

  notification.html = true;
  var text = msg.text || "No Text provided";
  notification.text = $.Localize(text)
  notification.hittest = false;
  notification.AddClass('TitleText');

  notification.AddClass('NotificationMessage');

}

(function () {
  GameEvents.Subscribe("waveinfo_notification", TopNotification);
})();


