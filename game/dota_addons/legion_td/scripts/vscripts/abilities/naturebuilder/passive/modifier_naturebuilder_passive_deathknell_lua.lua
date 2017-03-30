modifier_naturebuilder_passive_deathknell_lua = class({})

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:GetTexture()
    return "treant_leech_seed"
end

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:OnCreated(kv)
    self.damage_percent = self:GetAbility():GetSpecialValueFor("damage_percent")
    self.heal_percent = self:GetAbility():GetSpecialValueFor("heal_percent")

    if self:GetStackCount() > 0 then
        self.damage_percent = self.damage_percent * 2
        self.heal_percent = self.heal_percent * 2
    end

    if IsServer() then
        local doublePassive = false

        -- gameEnt = GameRules:GetGameModeEntity()
        gameEnt = GameRules.GameMode.game

        playerObj = gameEnt:FindPlayerWithID(self:GetParent():GetPlayerID())

        for _, unitRef in pairs(playerObj.units) do
            unitName = unitRef.npcclass
            if string.find(unitName, "treebeard") then
                doublePassive = true
            end
        end

        if doublePassive then
            self:GetParent():SetModifierStackCount("modifier_naturebuilder_passive_deathknell_lua", self:GetParent(), 1)
        else
            self:GetParent():SetModifierStackCount("modifier_naturebuilder_passive_deathknell_lua", self:GetParent(), 0)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:OnRefresh(kv)
    self.damage_percent = self:GetAbility():GetSpecialValueFor("damage_percent")
    self.heal_percent = self:GetAbility():GetSpecialValueFor("heal_percent")

    if self:GetStackCount() > 0 then
        self.damage_percent = self.damage_percent * 2
        self.heal_percent = self.heal_percent * 2
    end

    if IsServer() then
        local doublePassive = false

        -- gameEnt = GameRules:GetGameModeEntity()
        gameEnt = GameRules.GameMode.game

        playerObj = gameEnt:FindPlayerWithID(self:GetParent():GetPlayerID())

        for _, unitRef in pairs(playerObj.units) do
            unitName = unitRef.npcclass
            if string.find(unitName, "treebeard") then
                doublePassive = true
            end
        end

        if doublePassive then
            self:GetParent():SetModifierStackCount("modifier_naturebuilder_passive_deathknell_lua", self:GetParent(), 1)
        else
            self:GetParent():SetModifierStackCount("modifier_naturebuilder_passive_deathknell_lua", self:GetParent(), 0)
        end
    end
end

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_DEATH, MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:OnDeath(params)

    -- for k, v in pairs(params) do
    -- 	print (k)
    -- 	print (v)
    -- 	print ("---")
    -- end

    local deadUnit = params.unit

    local deadUnitOwnerID = deadUnit:GetPlayerOwnerID()

    if self:GetParent():GetPlayerID() == deadUnitOwnerID then

        -- do hurt

        local hurtAmount = deadUnit:GetMaxHealth() * (self.damage_percent / 100)
        local enemies = FindUnitsInRadius(deadUnit:GetTeamNumber(), deadUnit:GetAbsOrigin(), deadUnit, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        local target = enemies[RandomInt(1, #enemies)]

        if target then
            ApplyDamage({ victim = target, attacker = deadUnit, damage = hurtAmount, damage_type = DAMAGE_TYPE_MAGICAL })

            local attackName = "particles/units/heroes/hero_pugna/pugna_ward_attack.vpcf" -- There are some light/medium/heavy unused versions
            local attack = ParticleManager:CreateParticle(attackName, PATTACH_ABSORIGIN_FOLLOW, deadUnit)
            ParticleManager:SetParticleControl(attack, 1, target:GetAbsOrigin())
        end

        -- do heal

        local healAmount = deadUnit:GetMaxHealth() * (self.heal_percent / 100)
        local allies = FindUnitsInRadius(deadUnit:GetTeamNumber(), deadUnit:GetAbsOrigin(), deadUnit, 300, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        local target = allies[1]

        if target then

            local missingHP = target:GetMaxHealth() - target:GetHealth()

            for k, v in pairs(allies) do
                if v:GetMaxHealth() - v:GetHealth() > missingHP then
                    target = v
                    missingHP = v:GetMaxHealth() - v:GetHealth()
                end
            end

            target:SetHealth(target:GetHealth() + healAmount)
            PopupHealing(target, math.floor(healAmount))
        end
    end
end

--------------------------------------------------------------------------------
function modifier_naturebuilder_passive_deathknell_lua:OnTooltip(params)
    return self.damage_percent
end

--------------------------------------------------------------------------------
