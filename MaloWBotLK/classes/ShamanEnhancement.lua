
-- TODO:
-- Gift of the Naruu on tanks?
-- Magma totem on cleave > 1
-- Wind Shear to interrupt
-- Fire Elemental Totem on CD
-- Earth Elemental Totem? Seems when you use one it starts a shared CD with the other for 2 mins, but each still has 10 min CD
--      Avoid Totemic Recall when Elemental Totem is down, also go back to normal totems after the Elemental totem is gone.
-- If I'm within melee range of the target, but my fire totem is not very close to me, re-place it, otherwise Fire Nova will miss
function mb_Shaman_Enhancement_OnLoad()
    local is25Man = mb_Is25ManRaid()
    local _, _, _, _, improvedStrengthOfEarth = GetTalentInfo(2, 1);
    if improvedStrengthOfEarth > 0 or not is25Man then
        mb_Shaman_SetEarthTotem("Strength of Earth Totem")
    else
        mb_Shaman_SetEarthTotem("Tremor Totem")
    end
    mb_Shaman_SetFireTotem("Searing Totem")
    if not is25Man then
        mb_Shaman_SetWaterTotem("Mana Spring Totem")
    else
        mb_Shaman_SetWaterTotem("Healing Stream Totem")
    end
    local _, _, _, _, improvedWindfury = GetTalentInfo(2, 13);
    if improvedWindfury > 0 or not is25Man then
        mb_Shaman_SetAirTotem("Windfury Totem")
    else
        mb_Shaman_SetAirTotem("Grounding Totem")
    end
    mb_EnableIWTDistanceClosing("Stormstrike")
end

function mb_Shaman_Enhancement_OnUpdate()
    if not mb_IsReadyForNewCast() then
        return
    end

    if mb_Drink() then
        return
    end

    if UnitExists("playerpet") then
        PetPassiveMode()
        mb_SetPetAutocast("Bash", true)
        mb_SetPetAutocast("Spirit Walk", true)
        mb_SetPetAutocast("Spirit Wolf Leap", true)
        mb_SetPetAutocast("Twin Howl", false)
    end

    if mb_ResurrectRaid("Ancestral Spirit") then
        return
    end

    if mb_Shaman_ApplyWeaponEnchants("Windfury Weapon", "Flametongue Weapon") then
        return
    end

    if mb_GetBuffStackCount("player", "Maelstrom Weapon") >= 4 then
        if mb_Shaman_ChainHealRaid() then
            return
        end
    end

    if mb_Shaman_HandleTotems() then
        return
    end

    if not UnitBuff("player", "Lightning Shield") and mb_CastSpellWithoutTarget("Lightning Shield") then
        return
    end

    if not mb_AcquireOffensiveTarget() then
        if mb_UnitPowerPercentage("player") > 30 then
            if mb_Shaman_ChainHealRaid() then
                return
            end
        end
        return
    end

    if UnitExists("playerpet") then
        PetAttack()
    end

    if not mb_isAutoAttacking then
        InteractUnit("target")
    end

    if mb_IsSpellInRange("Stormstrike", "target") and mb_CastSpellWithoutTarget("Shamanistic Rage") then
        return
    end

    if mb_CastSpellOnTarget("Stormstrike") then
        return
    end

    if mb_ShouldUseDpsCooldowns("Stormstrike") then
        mb_UseItemCooldowns()
        if mb_CastSpellWithoutTarget("Feral Spirit") then
            return
        end
    end

    if mb_cleaveMode > 0 and mb_IsSpellInRange("Stormstrike", "target") then
        if mb_CastSpellWithoutTarget("Fire Nova") then
            return
        end
    end

    if mb_GetBuffStackCount("player", "Maelstrom Weapon") >= 4 then
        if mb_cleaveMode > 0 and mb_CastSpellOnTarget("Chain Lightning") then
            return
        elseif mb_CastSpellOnTarget("Lightning Bolt") then
            return
        end
    end

    if not mb_UnitHasMyDebuff("target", "Flame Shock") and mb_CastSpellOnTarget("Flame Shock") then
        return
    end

    if mb_CastSpellOnTarget("Lava Lash") then
        return
    end

    if mb_IsSpellInRange("Stormstrike", "target") and mb_CastSpellWithoutTarget("Fire Nova") then
        return
    end

    if mb_UnitPowerPercentage("player") > 30 and not mb_IsSpellInRange("Stormstrike", "target") then
        if mb_Shaman_ChainHealRaid() then
            return
        end

        if mb_CastSpellOnTarget("Lava Burst") then
            return
        end

        if mb_CastSpellOnTarget("Lightning Bolt") then
            return
        end
    end
end





