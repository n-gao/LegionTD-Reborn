function randombuilder_passive_start(keys)
    LinkLuaModifier("modifier_randombuilder_passive_lua", "abilities/randombuilder/passive/modifier_randombuilder_passive_lua.lua", LUA_MODIFIER_MOTION_NONE)

    local ability = keys.ability
    local caster = keys.caster

    Timers:CreateTimer(function()

        id = caster:GetPlayerID()
        playerObj = Game:FindPlayerWithID(id)

        if not Game.gameState == GAMESTATE_PREPARATION then return 1 end

        -- print ("u have " .. #playerObj.units )

        -- for _, unitRef in pairs(playerObj.units) do
        -- 	local unit = unitRef.npc
        -- 	if unit and not unit:IsNull() and unit:IsAlive() then

        -- 		unit:AddNewModifier(caster, ability, "modifier_naturebuilder_passive_deathknell_lua", {})

        -- 	end
        -- end

        --apply the modifiers to the hero as well for display


        caster:AddNewModifier(caster, ability, "modifier_randombuilder_passive_lua", {})


        return 1 -- slowish
    end)
end
