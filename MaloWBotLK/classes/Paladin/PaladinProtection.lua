
-- TODO:
-- Every man for himself on loss of control
-- LayOnHand low friendly
-- Divine Shield + Taunt into click away if low and all those CDs are ready
-- BoP friendly who has aggro
-- Auto-taunt off non-tanks

function mb_Paladin_Protection_OnLoad()
    mb_RegisterDesiredBuff(BUFF_MIGHT)
    mb_RegisterDesiredBuff(BUFF_THORNS)
    mb_RegisterClassSpecificReadyCheckFunction(mb_Paladin_Protection_ReadyCheck)
    mb_RegisterExclusiveRequestHandler("taunt", mb_Paladin_Protection_TauntAcceptor, mb_Paladin_Protection_TauntExecutor)
end

function mb_Paladin_Protection_OnUpdate()
    if not mb_IsReadyForNewCast() then
        return
    end

    if mb_Drink() then
        return
    end

    if mb_ResurrectRaid("Redemption") then
        return
    end

    if mb_Paladin_CastAura() then
        return
    end

    if not UnitBuff("player", "Righteous Fury") and mb_CastSpellWithoutTarget("Righteous Fury") then
        return
    end

    if not UnitBuff("player", "Seal of Vengeance") and mb_CastSpellWithoutTarget("Seal of Vengeance") then
        return
    end

    if not UnitBuff("player", "Sacred Shield") and mb_CastSpellOnSelf("Sacred Shield") then
        return
    end

    if not mb_AcquireOffensiveTarget() then
        return
    end

    if not mb_isAutoAttacking then
        InteractUnit("target")
    end

    if mb_IsSpellInRange("Judgement of Light", "target") then
        if not UnitBuff("player", "Holy Shield") and mb_CastSpellWithoutTarget("Holy Shield") then
            return
        end
        if not UnitBuff("player", "Divine Plea") then
            if mb_CastSpellWithoutTarget("Divine Plea") then
                return
            end
        end
        if mb_UnitPowerPercentage("player") > 20 then
            if mb_CastSpellWithoutTarget("Consecration") then
                return
            end
        end
    else
        if mb_CastSpellOnTarget("Exorcism") then
            return
        end
    end

    if mb_cleaveMode > 0 then
        if UnitCreatureType("target") == "Undead" and mb_IsSpellInRange("Judgement of Light", "target") then
            if mb_CastSpellWithoutTarget("Holy Wrath") then
                return
            end
        end
    end

    if mb_UnitPowerPercentage("player") > 30 then
        if mb_CastSpellOnTarget("Avenger's Shield") then
            return
        end
    end

    if mb_CastSpellOnTarget("Judgement of Light") then
        return
    end

    if mb_CastSpellOnTarget("Hammer of the Righteous") then
        return
    end

    if mb_CastSpellOnTarget("Shield of Righteousness") then
        return
    end

    if mb_UnitPowerPercentage("player") > 25 then
        if mb_CastSpellOnTarget("Hammer of Wrath") then
            return
        end
    end

    if UnitCreatureType("target") == "Undead" and mb_IsSpellInRange("Judgement of Light", "target") then
        if mb_UnitPowerPercentage("player") > 30 then
            if mb_CastSpellWithoutTarget("Holy Wrath") then
                return
            end
        end
    end
end

function mb_Paladin_Protection_ReadyCheck()
    local ready = true
    if mb_GetBuffTimeRemaining("player", "Seal of Vengeance") < 540 then
        CancelUnitBuff("player", "Seal of Vengeance")
        ready = false
    end
    return ready
end

function mb_Paladin_Protection_TauntAcceptor(message, from)
    if UnitExists("target") and UnitIsUnit("target", mb_GetUnitForPlayerName(from) .. "target") then
        if mb_CanCastSpell("Hand of Reckoning", "target") or mb_CanCastSpell("Righteous Defense", "target") then
            return true
        end
        return false
    end
end

function mb_Paladin_Protection_TauntExecutor(message, from)
    if UnitExists("target") and UnitIsUnit("target", mb_GetUnitForPlayerName(from) .. "target") then
        if mb_CastSpellOnTarget("Hand of Reckoning") then
            mb_SayRaid("Im Taunting!")
            return true
        end
        if mb_CastSpellOnTarget("Righteous Defense") then
            mb_SayRaid("Im Taunting!")
            return true
        end
    end
    return false
end


