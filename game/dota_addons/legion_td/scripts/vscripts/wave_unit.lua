function LeftLane(trigger)
    local npc = trigger.activator
    if npc and not npc:IsRealHero() then
        if npc:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
            PopupSadface(npc)
            npc.leftLane = true
            npc:AddAbility("ability_phased")
            local ability = npc:FindAbilityByName("ability_phased")
            ability:SetLevel(1)
            if npc.lane.player then
                npc.lane.player:Leaked(npc, npc:GetLevel())
            end
            npc:SetMinimumGoldBounty(1)
            npc:SetMaximumGoldBounty(1)
        --npc.nextTarget = npc.lastWaypoint
        end
    end
end
