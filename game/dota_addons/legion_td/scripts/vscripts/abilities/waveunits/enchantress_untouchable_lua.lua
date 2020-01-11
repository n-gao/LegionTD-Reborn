enchantress_untouchable_lua = class({})
LinkLuaModifier( "modifier_enchantress_untouchable_lua", "abilities/modifier_enchantress_untouchable_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_enchantress_untouchable_lua_debuff", "abilities/modifier_enchantress_untouchable_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function enchantress_untouchable_lua:GetIntrinsicModifierName()
	return "modifier_enchantress_untouchable_lua"
end