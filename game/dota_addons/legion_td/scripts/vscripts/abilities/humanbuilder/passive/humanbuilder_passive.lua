function humanbuilder_passive_start(keys)
    LinkLuaModifier(
        "modifier_humanbuilder_passive_lua",
        "abilities/humanbuilder/passive/modifier_humanbuilder_passive_lua.lua",
        LUA_MODIFIER_MOTION_NONE
    )

    local ability = keys.ability
    local caster = keys.caster

    caster:AddNewModifier(caster, ability, "modifier_humanbuilder_passive_lua", {})
    Game:AddEndOfRoundListener(
        function()
            caster:AddNewModifier(caster, ability, "modifier_humanbuilder_passive_lua", {})
            return 1
        end
    )
end
