function MoveCamera(data) {
  $.Msg(data);
   var cameraTarget = [];
   if (data.unitTargetEntIndex) {
    cameraTarget = Entities.GetAbsOrigin(data.unitTargetEntIndex)
  } else if (data.cameraTarget) {
    var cameraTargetString = data.cameraTarget.split(" ");
     cameraTarget[0] = parseFloat(cameraTargetString[0]);
    cameraTarget[1] = parseFloat(cameraTargetString[1]);
    cameraTarget[2] = parseFloat(cameraTargetString[2]);
  }
   GameUI.SetCameraTargetPosition(cameraTarget, data.lerp);
}
 (function () {
  GameEvents.Subscribe("move_camera", MoveCamera);
})();