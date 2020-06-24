
-- TODO:
-- Add a DPS rotation if high mana
-- Lay on Hands, is an external CD due to talent
-- Divine Protection pre-taking damage, probably through a "use personals" macro
-- Avenging Wrath when needed, probably through a "Heal CD" macro
--     Divine Illumination at the same time and replace Flash of Light with Holy Light during the duration
--     Make sure to prevent casting Divine Plea while these CDs are up, and make sure to not cast these CDs while Divine Plea is up
--     Avoid popping heal-CDs while heroism is up, or within 10 seconds of the start of a fight
-- Divine Favor
--      Pop it when you notice high raid damage and you know you'll be holy Lighting
-- Make him cast holy light over Flash of Light when he notices massive raid damage
--      Implement some function that retrieves a "severity" of raid health from a scale of like 1 to 10
--      1 meaning everyone in the raid have full health
--      10 meaning everyone alive in the raid has 1% HP
--      Only cast Divine Plea during low severity
--      Possibly click away Divine Plea if severity is high

function mb_Paladin_Holy_OnLoad()
    mb_preCastFinishCallback = mb_Paladin_Holy_PreCastFinishCallback
end

mb_Paladin_Holy_beaconUnit = nil
function mb_Paladin_Holy_OnUpdate()
    if not mb_IsReadyForNewCast() then
        return
    end

    if mb_Drink() then
        return
    end

    if mb_ResurrectRaid("Redemption") then
        return
    end

    if UnitAffectingCombat("player") and mb_UnitHealthPercentage("player") < 30 and mb_CastSpellWithoutTarget("Divine Shield") then
        return
    end

    if mb_Paladin_CastAura() then
        return
    end

    if not UnitBuff("player", "Seal of Wisdom") then
        if mb_CastSpellWithoutTarget("Seal of Wisdom") then
            return
        end
    end

    if mb_UnitPowerPercentage("player") < 60 and mb_CastSpellWithoutTarget("Divine Plea") then
        return
    end

    local mainTankUnit, offTankUnit = mb_GetUnitForPlayerName(mb_config.mainTank), mb_GetUnitForPlayerName(mb_config.offTank)
    local sacredShieldTarget = mainTankUnit
    if mb_GetClass(mainTankUnit) == "PALADIN" and offTankUnit ~= nil then
        sacredShieldTarget = offTankUnit
    end

    if not UnitBuff(sacredShieldTarget, "Sacred Shield") and mb_CastSpellOnFriendly(sacredShieldTarget, "Sacred Shield") then
        return
    end

    if not UnitBuff(mainTankUnit, "Beacon of Light") then
        if mb_CastSpellOnFriendly(mainTankUnit, "Beacon of Light") then
            mb_Paladin_Holy_beaconUnit = mainTankUnit
            return
        else
            mb_Paladin_Holy_beaconUnit = nil
        end
    end

    if mb_RaidHeal("Holy Shock") then
        return
    end

    if UnitBuff("player", "Infusion of Light") then
        if mb_RaidHeal("Holy Light") then
            return
        end
    end

    if mb_AcquireOffensiveTarget() then
        if not mb_isAutoAttacking then
            InteractUnit("target")
        end

        if mb_GetBuffTimeRemaining("player", "Judgements of the Pure") < 5 and mb_CastSpellOnTarget("Judgement of Light") then
            return
        end
    end

    if mb_RaidHeal("Holy Light") then
        return
    end

    if mb_RaidHeal("Flash of Light") then
        return
    end

    if mb_CleanseRaid("Cleanse", "Magic", "Poison", "Disease") then
        return
    end

    if mb_GetBuffTimeRemaining(mainTankUnit, "Beacon of Light") < 10 and mb_CastSpellOnFriendly(mainTankUnit, "Beacon of Light") then
        return
    end

    if UnitAffectingCombat("player") then
        if offTankUnit ~= nil and mb_CastSpellOnFriendly(offTankUnit, "Holy Light") then
            return
        elseif mb_CastSpellOnFriendly("player", "Holy Light") then
            return
        end
    end
end

function mb_Paladin_Holy_PreCastFinishCallback(spell, unit)
    local spellTargetUnitMissingHealth = mb_GetMissingHealth(unit)
    local beaconUnitMissingHealth = 0
    if mb_Paladin_Holy_beaconUnit ~= nil then
        beaconUnitMissingHealth = mb_GetMissingHealth(unit)
    end
    local healAmount = mb_GetSpellEffect(spell)
    local effectiveHealAmount = 0
    if healAmount > spellTargetUnitMissingHealth then
        effectiveHealAmount = effectiveHealAmount + spellTargetUnitMissingHealth
    else
        effectiveHealAmount = effectiveHealAmount + healAmount
    end
    if healAmount > beaconUnitMissingHealth then
        effectiveHealAmount = effectiveHealAmount + beaconUnitMissingHealth
    else
        effectiveHealAmount = effectiveHealAmount + healAmount
    end
    if effectiveHealAmount * 1.1 < healAmount then
        mb_StopCast()
    end
end

