kingLeoric_frenzy = class({})

LinkLuaModifier("modifier_kingLeoric_frenzy", "abilities/kingLeoric/kingLeoric_frenzy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingLeoric_frenzy_cooldown", "abilities/kingLeoric/kingLeoric_frenzy.lua", LUA_MODIFIER_MOTION_NONE)
------------------------------------------------------------------------------------------------------------------------------------------------------
function kingLeoric_frenzy:GetBehavior(  ) 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function kingLeoric_frenzy:GetGoldCost( iLevel ) 
	return 0 
end

function kingLeoric_frenzy:GetManaCost( iLevel ) 
	return 0 
end

function kingLeoric_frenzy:IsRefreshable(  ) 
	return false 
end

function kingLeoric_frenzy:IsStealable(  ) 
	return false 
end

function kingLeoric_frenzy:OnOwnerSpawned(  )
	self.cooldown = 0
	self.player.hero:AddNewModifier(self.player.hero, self, "modifier_kingLeoric_frenzy_cooldown", {})
end

function kingLeoric_frenzy:OnAbilityPhaseStart(  )
	local Game = GameRules.GameMode.game
	if IsServer() then
		if self.cooldown == nil or self.cooldown <= GameRules.GameMode.game.gameRound - GameRules.GameMode.game.doneDuels then
			if not Game:IsBetweenRounds() then
				return true
			else
				local message = "Inbetween rounds"
				local playerID = self:GetCaster():GetPlayerID()
				Notifications:ClearBottom(playerID)
				Notifications:Bottom(playerID, {text=message, duration=5, style={color="red", ["font-size"]="30px"}})
				return false
			end
		else
			local message = (self.cooldown - (GameRules.GameMode.game.gameRound - GameRules.GameMode.game.doneDuels)).." rounds left on cooldown"
			local playerID = self:GetCaster():GetPlayerID()
			Notifications:ClearBottom(playerID)
			Notifications:Bottom(playerID, {text=message, duration=5, style={color="red", ["font-size"]="30px"}})
			return false
		end
	else
		return false
	end
end

function kingLeoric_frenzy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		for i,v in pairs(self.player.units) do
			if not v.npc:IsNull() then
				local mod = v.npc:AddNewModifier(self.player.hero, self, "modifier_kingLeoric_frenzy", {duration = self:GetSpecialValueFor("duration")})
				mod.ability = self
			end
		end
		local mod = self.player.hero:AddNewModifier(self.player.hero, self, "modifier_kingLeoric_frenzy", {duration = self:GetSpecialValueFor("duration")})
		mod.ability = self
		self.cooldown = GameRules.GameMode.game.gameRound - GameRules.GameMode.game.doneDuels + self:GetSpecialValueFor("cooldown")
		self.player.hero:AddNewModifier(self.player.hero, self, "modifier_kingLeoric_frenzy_cooldown", {})
		return true
	else
		return false
	end
end

function kingLeoric_frenzy:ProcsMagicStick(  ) 
	return false 
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_kingLeoric_frenzy == nil then
	modifier_kingLeoric_frenzy = class({})
end

function modifier_kingLeoric_frenzy:IsHidden(  )
	return false
end

function modifier_kingLeoric_frenzy:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_kingLeoric_frenzy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_kingLeoric_frenzy:RemoveOnDeath(  ) 
	return true
end

function modifier_kingLeoric_frenzy:DestroyOnExpire(  ) 
	return true
end

function modifier_kingLeoric_frenzy:GetTexture(  ) 
	return "ogre_magi_bloodlust" 
end

function modifier_kingLeoric_frenzy:GetAttributes(  ) 
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_kingLeoric_frenzy:DeclareFunctions(  )
	return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_kingLeoric_frenzy:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
end

function modifier_kingLeoric_frenzy:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_kingLeoric_frenzy_cooldown == nil then
	modifier_kingLeoric_frenzy_cooldown = class({})
end

function modifier_kingLeoric_frenzy_cooldown:IsHidden(  ) 
	return false
end

function modifier_kingLeoric_frenzy_cooldown:GetTexture(  ) 
	return "ogre_magi_bloodlust" 
end

function modifier_kingLeoric_frenzy_cooldown:GetAttributes(  ) 
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_kingLeoric_frenzy_cooldown:DeclareFunctions(  )
	return { }
end

function modifier_kingLeoric_frenzy_cooldown:OnCreated(  )
	self:StartIntervalThink(0.2)
end

function modifier_kingLeoric_frenzy_cooldown:OnIntervalThink()
	local ability = self:GetAbility()
	local cooldown = ability.cooldown - (GameRules.GameMode.game.gameRound - GameRules.GameMode.game.doneDuels)
	if cooldown < 1 then 
		cooldown = 0
	else
		ability:StartCooldown(cooldown)
	end
	self:SetStackCount(cooldown)
end

function modifier_kingLeoric_frenzy_cooldown:OnTooltip( params )
	return self:GetStackCount()*1.0
end

------------------------------------------------------------------------------------------------------------------------------------------------------