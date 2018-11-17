function elementalbuilder_passive_start(keys)
    LinkLuaModifier("modifier_elementalbuilder_passive_earth_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_earth_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_earth_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_earth_negative_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_fire_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_fire_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_fire_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_fire_negative_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_thunder_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_thunder_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_thunder_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_thunder_negative_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_void_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_void_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_void_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_void_negative_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_water_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_water_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_water_negative_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_water_negative_lua.lua", LUA_MODIFIER_MOTION_NONE)
    LinkLuaModifier("modifier_elementalbuilder_passive_elemental_harmony_lua", "abilities/elementalbuilder/passive/modifier_elementalbuilder_passive_elemental_harmony_lua.lua", LUA_MODIFIER_MOTION_NONE)



    local ability = keys.ability
    local caster = keys.caster
    local elementNames = { "water", "thunder", "earth", "fire", "void" }
    local inverseElements = {
        water = "fire",
        thunder = "water",
        earth = "void",
        fire = "earth",
        void = "thunder"
    }
    local elementSums = {}
    local elementRatios = {}
    local elementStacks = {}
    --Worth 10 but -4
    local elementGods = {}
    --Worth 6 but -3
    local elementWarriors = {}
    --Worth 4 but -2
    local elementElemental = {}
    --Worth 2 but -1
    local elementBender = {}
    local maxStacks = 10
    local maxNegativeStacks = 30

    Timers:CreateTimer(function()

        id = caster:GetPlayerID()
        playerObj = Game:FindPlayerWithID(id)

        if not Game.gameState == GAMESTATE_PREPARATION then return 1 end

        --print ("u have " .. #playerObj.units )

        for _, element in pairs(elementNames) do
            elementSums[element] = 0
            elementRatios[element] = 0
            elementStacks[element] = 0
            elementGods[element] = 0
            elementWarriors[element] = 0
            elementElemental[element] = 0
            elementBender[element] = 0
        end

        for _, unitRef in pairs(playerObj.units) do -- count gods, warriors, elementals and benders
            unitName = unitRef.npcclass
            for _, element in pairs(elementNames) do
                if string.find(unitName, element) then
                    if string.find(unitName, "god") then
                        elementGods[element] = elementGods[element] + 1
                    elseif string.find(unitName, "warrior") then
                        elementWarriors[element] = elementWarriors[element] + 1
                    elseif string.find(unitName, "bender") then
                        elementBender[element] = elementBender[element] + 1
                    elseif string.find(unitName, "elemental") then
                        elementElemental[element] = elementElemental[element] + 1
                    end
                    break
                end
            end
        end

        --print("calculating stacks")
        for element, count in pairs(elementGods) do
            local inverseElement = inverseElements[element]
            elementStacks[element] = elementStacks[element] + 8 * count
            elementStacks[inverseElement] = elementStacks[inverseElement] - 4 * count
        end
        for element, count in pairs(elementWarriors) do
            local inverseElement = inverseElements[element]
            elementStacks[element] = elementStacks[element] + 6 * count
            elementStacks[inverseElement] = elementStacks[inverseElement] - 3 * count
        end
        for element, count in pairs(elementElemental) do
            local inverseElement = inverseElements[element]
            elementStacks[element] = elementStacks[element] + 4 * count
            elementStacks[inverseElement] = elementStacks[inverseElement] - 2 * count
        end
        for element, count in pairs(elementBender) do
            local inverseElement = inverseElements[element]
            elementStacks[element] = elementStacks[element] + 2 * count
            elementStacks[inverseElement] = elementStacks[inverseElement] - 1 * count
        end
        --for element, stacks in pairs(elementStacks) do
        --    print(element.." "..stacks)
        --end

        --[[
        local valueSum = 0 -- total value of all towers without god-overseen elements

        for _, unitRef in pairs(playerObj.units) do -- lets look for gods first
            unitName = unitRef.npcclass
            for _, element in pairs(elementNames) do
                if string.find(unitName, element) then
                    if string.find(unitName, "god") then
                        elementGods[element] = true
                    end
                end
            end
        end

        for _, unitRef in pairs(playerObj.units) do
            unitName = unitRef.npcclass
            for _, element in pairs(elementNames) do
                if string.find(unitName, element) then
                    elementSums[element] = elementSums[element] + unitRef.goldCost
                    if not elementGods[element] then
                        valueSum = valueSum + unitRef.goldCost -- elements only add to value sum if they have no god
                    end
                    break -- each unit is only one element, right??
                end
            end
        end

        local elementCount = 0

        for _, element in pairs(elementNames) do
            if elementSums[element] > 0 and not elementGods[element] then
                elementCount = elementCount + 1
            end
        end

        local valueAvg = valueSum / elementCount

        --print("Element Count: " .. elementCount .. ", Total value: " .. valueSum .. ", average " .. valueAvg)

        for element, total in pairs(elementSums) do
            elementRatios[element] = total / valueAvg
            if elementGods[element] then
                elementStacks[element] = 1
          --      print(element .. " has a god!")
            elseif elementRatios[element] >= 1 then
                elementStacks[element] = math.floor(5 * (elementRatios[element] - 1))
          --      print("elementRatios(" .. element .. "): " .. elementRatios[element])
            else
                elementStacks[element] = math.floor(5 * (1 - (1 / elementRatios[element])))
          --      print("elementRatios(" .. element .. "): " .. elementRatios[element] .. " reciprocal of " .. 1 / elementRatios[element])
            end
            if elementStacks[element] > 0 then elementStacks[element] = elementStacks[element] - 1 end
            if elementStacks[element] < 0 then elementStacks[element] = elementStacks[element] + 1 end
        end

        -- check for elemental harmony

        local harmony = true

        for _, element in pairs(elementNames) do
            if elementSums[element] == 0 then harmony = false end
            if not (elementStacks[element] == 0) then harmony = false end
        end


        if harmony then
            --print ("we have harmony")
            for _, element in pairs(elementNames) do
                elementStacks[element] = maxStacks
            end
        end
        --]]

        for _, unitRef in pairs(playerObj.units) do
            local unit = unitRef.npc
            if unit and not unit:IsNull() and unit:IsAlive() and caster and ability then

                unit:AddNewModifier(unit, ability, "modifier_elementalbuilder_passive_elemental_harmony_lua", {})

                if harmony then
                    unit:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", unit, 0)
                else
                    unit:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", unit, 1)
                end

                for _, element in pairs(elementNames) do
                  --  if elementSums[element] > 0 then
                        unit:AddNewModifier(unit, ability, "modifier_elementalbuilder_passive_" .. element .. "_lua", {})
                        unit:AddNewModifier(unit, ability, "modifier_elementalbuilder_passive_" .. element .. "_negative_lua", {})
                        if elementStacks[element] < 0 then
                            unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", unit, 0)
                            unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", unit, math.min(maxNegativeStacks, 0 - elementStacks[element]))
                        else
                            unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", unit, math.min(maxStacks, elementStacks[element]))
                            unit:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", unit, 0)
                        end
                  --  end
                end
            end
        end

        --apply the modifiers to the hero as well for display


        caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_elemental_harmony_lua", {})

        if harmony then
            caster:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 0)
        else
            caster:SetModifierStackCount("modifier_elementalbuilder_passive_elemental_harmony_lua", caster, 1)
        end

        for _, element in pairs(elementNames) do
            caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_" .. element .. "_lua", {})
            caster:AddNewModifier(caster, ability, "modifier_elementalbuilder_passive_" .. element .. "_negative_lua", {})
            --if elementSums[element] > 0 then
                if elementStacks[element] < 0 then
                    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0)
                    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, math.min(maxNegativeStacks, 0 - elementStacks[element]))
                else
                    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, math.min(maxStacks, elementStacks[element]))
                    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
                end
            --else
            --    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_lua", caster, 0)
            --    caster:SetModifierStackCount("modifier_elementalbuilder_passive_" .. element .. "_negative_lua", caster, 0)
            --end
        end

        return 1 -- slowish
    end)
end
