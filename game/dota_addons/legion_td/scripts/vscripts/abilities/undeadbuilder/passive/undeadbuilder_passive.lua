local ability
local caster

function undeadbuilder_passive_start(keys)
    LinkLuaModifier(
        "modifier_undeadbuilder_necromancy_lua",
        "abilities/undeadbuilder/passive/modifier_undeadbuilder_necromancy_lua.lua",
        LUA_MODIFIER_MOTION_NONE
    )
    ability = keys.ability
    caster = keys.caster
    Game:AddStartOfRoundListener(ApplyNecromancy)
end

function ApplyNecromancy()
    for _, unit in pairs(caster.player.units) do
        if (unit.npc ~= nil) then
            unit.npc:AddNewModifier(caster, ability, "modifier_undeadbuilder_necromancy_lua", {})
        end
    end
    return 1
end
