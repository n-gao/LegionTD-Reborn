devour = class({})
LinkLuaModifier( "modifier_dismember_lua", "abilities/undeadbuilder/modifier_dismember_lua.lua" ,LUA_MODIFIER_MOTION_NONE )

--[[Author: Valve
    Date: 26.09.2015.]]
--------------------------------------------------------------------------------

function devour:GetConceptRecipientType()
    return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function devour:SpeakTrigger()
    return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function devour:GetChannelTime()
    self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
    self.hero_duration = self:GetSpecialValueFor( "hero_duration" )

    if IsServer() then
        if self.hVictim ~= nil then
            if self.hVictim:IsConsideredHero() then
                return self.hero_duration
            else
                return self.creep_duration
            end
        end

        return 0.0
    end

    return self.hero_duration
end

--------------------------------------------------------------------------------

function devour:OnAbilityPhaseStart()
    if IsServer() then
        self.hVictim = self:GetCursorTarget()
    end

    return true
end

--------------------------------------------------------------------------------

function devour:OnSpellStart()
    if self.hVictim == nil then
        return
    end

    if self.hVictim:TriggerSpellAbsorb( self ) then
        self.hVictim = nil
        self:GetCaster():Interrupt()
    else
        self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_dismember_lua", { duration = self:GetChannelTime() } )
        self.hVictim:Interrupt()
    end
end


--------------------------------------------------------------------------------

function devour:OnChannelFinish( bInterrupted )
    if self.hVictim ~= nil then
        self.hVictim:RemoveModifierByName( "modifier_dismember_lua" )
    end
end

--------------------------------------------------------------------------------