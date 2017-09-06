assassinbuilder_frenzy = class({})

LinkLuaModifier("modifier_assassinbuilder_frenzy", "abilities/assassinbuilder/assassinbuilder_frenzy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_assassinbuilder_frenzy_cooldown", "abilities/assassinbuilder/assassinbuilder_frenzy.lua", LUA_MODIFIER_MOTION_NONE)
------------------------------------------------------------------------------------------------------------------------------------------------------
function assassinbuilder_frenzy:GetBehavior(  ) 
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function assassinbuilder_frenzy:GetGoldCost( iLevel ) 
	return 0 
end

function assassinbuilder_frenzy:GetManaCost( iLevel ) 
	return 0 
end

function assassinbuilder_frenzy:IsRefreshable(  ) 
	return false 
end

function assassinbuilder_frenzy:IsStealable(  ) 
	return false 
end

function assassinbuilder_frenzy:OnOwnerSpawned(  )
	self.cooldown = 0
	self.player.hero:AddNewModifier(self.player.hero, self, "modifier_assassinbuilder_frenzy_cooldown", {})
end

function assassinbuilder_frenzy:OnAbilityPhaseStart(  )
	if IsServer() then
		local game = GameRules.GameMode.game
		if self.cooldown == nil or self.cooldown <= game.gameRound - game.doneDuels then
			if not game:IsBetweenRounds() then
				return true
			else
				self:GetCaster().player:SendErrorCode(LEGION_ERROR_BETWEEN_ROUNDS)
				return false
			end
		else
			local message = (self.cooldown - (game.gameRound - game.doneDuels)).." rounds left on cooldown"
			local playerID = self:GetCaster():GetPlayerID()
			Notifications:ClearBottom(playerID)
			Notifications:Bottom(playerID, {text=message, duration=5, style={color="red", ["font-size"]="30px"}})
			return false
		end
	else
		return false
	end
end

function assassinbuilder_frenzy:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local game = GameRules.GameMode.game
		for i,v in pairs(self.player.units) do
			if not v.npc:IsNull() and v.npc:IsAlive() then
				local mod = v.npc:AddNewModifier(self.player.hero, self, "modifier_assassinbuilder_frenzy", {duration = self:GetSpecialValueFor("duration")})
				mod.ability = self
			end
		end
		local mod = self.player.hero:AddNewModifier(self.player.hero, self, "modifier_assassinbuilder_frenzy", {duration = self:GetSpecialValueFor("duration")})
		mod.ability = self
		self.cooldown = game:GetDisplayRound() + self:GetSpecialValueFor("cooldown")
		self.cooldownModifier = self.player.hero:AddNewModifier(self.player.hero, self, "modifier_assassinbuilder_frenzy_cooldown", {})
		self.cooldownModifier:SetStackCount(self.cooldown)

		if (self.roundListener == null) then
			self.roundListener = function() self:NextRound() end
			table.insert(game.endOfRoundListeners, self.roundListener)
		end
		self:SetActivated(false)
			
		return true
	else
		return false
	end
end

function assassinbuilder_frenzy:ProcsMagicStick(  ) 
	return false 
end

function assassinbuilder_frenzy:NextRound()
	if (IsServer()) then
		if (self.cooldown == 0) then
			return
		end
		local game = GameRules.GameMode.game
		local cooldown = self.cooldown - game:GetDisplayRound()
		self.cooldownModifier:SetStackCount(cooldown)
		if cooldown < 1 then 
			cooldown = 0
			self:SetActivated(true)
			self.cooldownModifier:Destroy()
		else
			self:SetActivated(false)
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_assassinbuilder_frenzy == nil then
	modifier_assassinbuilder_frenzy = class({})
end

function modifier_assassinbuilder_frenzy:IsHidden(  )
	return false
end

function modifier_assassinbuilder_frenzy:GetEffectName()
	return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_assassinbuilder_frenzy:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_assassinbuilder_frenzy:RemoveOnDeath(  ) 
	return true
end

function modifier_assassinbuilder_frenzy:DestroyOnExpire(  ) 
	return true
end

function modifier_assassinbuilder_frenzy:GetTexture(  ) 
	return "ogre_magi_bloodlust" 
end

function modifier_assassinbuilder_frenzy:GetAttributes(  ) 
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_assassinbuilder_frenzy:DeclareFunctions(  )
	return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_assassinbuilder_frenzy:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetAbility():GetSpecialValueFor("attackspeed_bonus")
end

function modifier_assassinbuilder_frenzy:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetAbility():GetSpecialValueFor("movespeed_bonus")
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_assassinbuilder_frenzy_cooldown == nil then
	modifier_assassinbuilder_frenzy_cooldown = class({})
end

function modifier_assassinbuilder_frenzy_cooldown:IsHidden(  ) 
	return false
end

function modifier_assassinbuilder_frenzy_cooldown:GetTexture(  ) 
	return "ogre_magi_bloodlust" 
end

function modifier_assassinbuilder_frenzy_cooldown:GetAttributes(  ) 
	return MODIFIER_ATTRIBUTE_NONE
end

function modifier_assassinbuilder_frenzy_cooldown:DeclareFunctions(  )
	return { }
end

function modifier_assassinbuilder_frenzy_cooldown:OnCreated(  )

end

function modifier_assassinbuilder_frenzy_cooldown:OnTooltip( params )
	return self:GetStackCount()*1.0
end

------------------------------------------------------------------------------------------------------------------------------------------------------