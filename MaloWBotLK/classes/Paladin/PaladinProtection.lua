
-- TODO:
-- Every man for himself on loss of control
-- LayOnHand low friendly
-- Divine Shield + Taunt into click away if low and all those CDs are ready
-- BoP friendly who has aggro
-- Salv friendly who is high on threat
-- Auto-taunt off non-tanks

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

    if not UnitBuff("player", "Sacred Shield") and mb_CastSpellOnSelf("Sacred Shield") then
        return
    end

    if not UnitBuff("player", "Righteous Fury") and mb_CastSpellWithoutTarget("Righteous Fury") then
        return
    end

    if not UnitBuff("player", "Seal of Vengeance") and mb_CastSpellWithoutTarget("Seal of Vengeance") then
        return
    end

    if not mb_AcquireOffensiveTarget() then
        return
    end

    if not mb_isAutoAttacking then
        InteractUnit("target")
    end

    if not UnitBuff("player", "Holy Shield") and mb_CastSpellWithoutTarget("Holy Shield") then
        return
    end

    if mb_IsSpellInRange("Judgement of Light", "target") then
        if not UnitBuff("player", "Divine Plea") then
            if mb_CastSpellWithoutTarget("Divine Plea") then
                return
            end
        end
        if mb_CastSpellWithoutTarget("Consecration") then
            return
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

    if mb_CastSpellOnTarget("Avenger's Shield") then
        return
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

    if mb_CastSpellOnTarget("Hammer of Wrath") then
        return
    end

    if UnitCreatureType("target") == "Undead" and mb_IsSpellInRange("Judgement of Light", "target") then
        if mb_CastSpellWithoutTarget("Holy Wrath") then
            return
        end
    end
end