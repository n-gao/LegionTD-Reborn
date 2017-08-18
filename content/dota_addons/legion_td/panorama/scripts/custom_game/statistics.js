var LifetimeStatsPanel;


function CreateStatisticsPanel(name, parent, contentName) {
    LifetimeStatsPanel = $.CreatePanel("Panel", parent, name);
    LifetimeStatsPanel.SetAttributeString("headerLabel", name);
    LifetimeStatsPanel.BLoadLayout("file://{resources}/layout/custom_game/statistics_panel.xml", false, false);
    var contentHook = LifetimeStatsPanel.FindChildInLayoutFile("Content");
    var content = $.CreatePanel("Panel", contentHook, name + "Content");
    content.BLoadLayout("file://{resources}/layout/custom_game/" + contentName, false, false);
}

(function() {
    CreateStatisticsPanel("Lifetime", $("#StatisticsBody"), "statistics_lifetime.xml");
    CreateStatisticsPanel("Ranking", $("#StatisticsBody"), "statistics_ranking.xml");
    CreateStatisticsPanel("Match History", $("#StatisticsBody"), "statistics_match_history.xml");
})();