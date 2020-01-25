spiritbuilder_dissimilate = class({})

LinkLuaModifier(
    "modifier_spiritbuilder_dissimilate",
    "abilities/spiritbuilder/spiritbuilder_dissimilate.lua",
    LUA_MODIFIER_MOTION_NONE
)
LinkLuaModifier(
    "modifier_spiritbuilder_dissimilate_cooldown",
    "abilities/spiritbuilder/spiritbuilder_dissimilate.lua",
    LUA_MODIFIER_MOTION_NONE
)
------------------------------------------------------------------------------------------------------------------------------------------------------
function spiritbuilder_dissimilate:GetBehavior()
    return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function spiritbuilder_dissimilate:GetGoldCost(iLevel)
    return 0
end

function spiritbuilder_dissimilate:GetManaCost(iLevel)
    return 0
end

function spiritbuilder_dissimilate:IsRefreshable()
    return false
end

function spiritbuilder_dissimilate:IsStealable()
    return false
end

function spiritbuilder_dissimilate:OnOwnerSpawned()
    self.cooldown = 0
    self.player.hero:AddNewModifier(self.player.hero, self, "modifier_spiritbuilder_dissimilate_cooldown", {})
end

function spiritbuilder_dissimilate:OnAbilityPhaseStart()
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
            local message = (self.cooldown - (game.gameRound - game.doneDuels)) .. " rounds left on cooldown"
            local playerID = self:GetCaster():GetPlayerID()
            Notifications:ClearBottom(playerID)
            Notifications:Bottom(
                playerID,
                {text = message, duration = 5, style = {color = "red", ["font-size"] = "30px"}}
            )
            return false
        end
    else
        return false
    end
end

function spiritbuilder_dissimilate:OnSpellStart()
    if IsServer() then
        local caster = self:GetCaster()
        local game = GameRules.GameMode.game
        for i, v in pairs(self.player.units) do
            if not v.npc:IsNull() and v.npc:IsAlive() then
                local mod =
                    v.npc:AddNewModifier(
                    self.player.hero,
                    self,
                    "modifier_spiritbuilder_dissimilate",
                    {duration = self:GetSpecialValueFor("duration")}
                )
                mod.ability = self
            end
        end
        local mod =
            self.player.hero:AddNewModifier(
            self.player.hero,
            self,
            "modifier_spiritbuilder_dissimilate",
            {duration = self:GetSpecialValueFor("duration")}
        )
        mod.ability = self
        self.cooldown = game:GetDisplayRound() + self:GetSpecialValueFor("cooldown")
        self.cooldownModifier =
            self.player.hero:AddNewModifier(self.player.hero, self, "modifier_spiritbuilder_dissimilate_cooldown", {})
        self.cooldownModifier:SetStackCount(self.cooldown)

        if (self.roundListener == null) then
            self.roundListener = function()
                self:NextRound()
                return 1
            end
            Game:AddEndOfRoundListener(self.roundListener)
        end
        self:SetActivated(false)

        return true
    else
        return false
    end
end

function spiritbuilder_dissimilate:ProcsMagicStick()
    return false
end

function spiritbuilder_dissimilate:NextRound()
    if (IsServer()) then
        if (self.cooldown == 0) then
            return
        end
        local game = GameRules.GameMode.game
        local cooldown = self.cooldown - game:GetDisplayRound()
        if (not self.cooldownModifier:IsNull()) then
            self.cooldownModifier:SetStackCount(cooldown)
        end
        if cooldown < 1 then
            cooldown = 0
            self:SetActivated(true)
            if (not self.cooldownModifier:IsNull()) then
                self.cooldownModifier:Destroy()
            end
        else
            self:SetActivated(false)
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_spiritbuilder_dissimilate == nil then
    modifier_spiritbuilder_dissimilate = class({})
end

function modifier_spiritbuilder_dissimilate:IsHidden()
    return false
end

function modifier_spiritbuilder_dissimilate:GetEffectName()
    return "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf"
end

function modifier_spiritbuilder_dissimilate:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_spiritbuilder_dissimilate:RemoveOnDeath()
    return true
end

function modifier_spiritbuilder_dissimilate:DestroyOnExpire()
    return true
end

function modifier_spiritbuilder_dissimilate:GetTexture()
    return "void_spirit_dissimilate"
end

function modifier_spiritbuilder_dissimilate:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_spiritbuilder_dissimilate:DeclareFunctions()
    return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, MODIFIER_PROPERTY_EVASION_CONSTANT}
end

function modifier_spiritbuilder_dissimilate:GetModifierPreAttack_BonusDamage(params)
    return self:GetAbility():GetSpecialValueFor("attackdamage_bonus")
end

function modifier_spiritbuilder_dissimilate:GetModifierEvasion_Constant(params)
    return self:GetAbility():GetSpecialValueFor("evasion_bonus")
end

------------------------------------------------------------------------------------------------------------------------------------------------------
if modifier_spiritbuilder_dissimilate_cooldown == nil then
    modifier_spiritbuilder_dissimilate_cooldown = class({})
end

function modifier_spiritbuilder_dissimilate_cooldown:IsHidden()
    return false
end

function modifier_spiritbuilder_dissimilate_cooldown:GetTexture()
    return "void_spirit_dissimilate"
end

function modifier_spiritbuilder_dissimilate_cooldown:GetAttributes()
    return MODIFIER_ATTRIBUTE_NONE
end

function modifier_spiritbuilder_dissimilate_cooldown:DeclareFunctions()
    return {}
end

function modifier_spiritbuilder_dissimilate_cooldown:OnCreated()
end

function modifier_spiritbuilder_dissimilate_cooldown:OnTooltip(params)
    return self:GetStackCount() * 1.0
end

------------------------------------------------------------------------------------------------------------------------------------------------------
