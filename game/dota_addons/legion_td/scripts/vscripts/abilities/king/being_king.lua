function BossDied(event)
    local team = event.caster:GetTeamNumber()
    local winner = 0
    if team == DOTA_TEAM_GOODGUYS then
        winner = DOTA_TEAM_BADGUYS
    else
        winner = DOTA_TEAM_GOODGUYS
    end
    GameRules:SetGameWinner(winner)
    GameRules:Defeated()
end
