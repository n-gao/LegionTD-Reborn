var RadiantKing = null;
var DireKing = null;

var radiantHealthProgressBar = null;
var radiantHealthLabel = null;

var direHealthProgressBar = null;
var direHealthLabel = null;


function createHealthBars(){
  radiantHealthProgressBar = $.CreatePanel("ProgressBar", $("#EmptyBarRadiant"), "HealthBarRadiant"); 
  radiantHealthProgressBar.min = 0;
  radiantHealthProgressBar.max = 100;
  radiantHealthProgressBar.value = 100;
  radiantHealthLabel = $.CreatePanel("Label", $("#EmptyBarRadiant"), "HealthPercentageRadiant");
  radiantHealthLabel.AddClass("HealthPercentageRadiant");
  
  direHealthProgressBar = $.CreatePanel("ProgressBar", $("#EmptyBarDire"), "HealthBarDire");
  direHealthProgressBar.min = 0;
  direHealthProgressBar.max = 100;
  direHealthProgressBar.value = 100;
  direHealthLabel = $.CreatePanel("Label", $("#EmptyBarDire"), "HealthPercentageDire");
  direHealthLabel.AddClass("HealthPercentageDire");
  
  
}

function startUpdateHealthBarLoop() {
  updateHealthBar();
  $.Schedule(1.0/30.0, startUpdateHealthBarLoop);
}

function updateHealthBar() {

  radiantHealthProgressBar.value = Entities.GetHealthPercent(RadiantKing);
  radiantHealthLabel.text = Entities.GetHealthPercent(RadiantKing) + "%";
  
  direHealthProgressBar.value = Entities.GetHealthPercent(DireKing);
  direHealthLabel.text = Entities.GetHealthPercent(DireKing) + "%";
}

function startFindKingsLoop() {
  var allUnits = Entities.GetAllEntities()
  for (var unit of allUnits) {
    var unitName = Entities.GetUnitName(unit)
    if (unitName == "dire_king") {
      DireKing = unit;
    }
    if (unitName == "radiant_king") {
      RadiantKing = unit;
    }
  }

  if (DireKing && RadiantKing) {
    createHealthBars();
    startUpdateHealthBarLoop();
  } else {
    $.Schedule(1, startFindKingsLoop)
  }
}

startFindKingsLoop();