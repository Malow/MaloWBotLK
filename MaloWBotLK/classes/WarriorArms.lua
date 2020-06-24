-- TODO:
-- Use Every Man For Himself on loss of control
-- Start using on-use trinkets
-- Interrupt with pummel
-- Recklessness on pre-pull
-- Some better check for Commanding Shout than CheckInteractDistance(unit, 4), that's 28 yards, range is 45 yards.
-- 		Maybe some item you can use on friendly?

function mb_Warrior_Arms_OnUpdate()
    if not mb_IsReadyForNewCast() then
        return
    end

    if GetShapeshiftForm() ~= 1 then
        mb_CastSpellWithoutTarget("Battle Stance")
        return
    end

    if UnitAffectingCombat("player") and mb_UnitHealthPercentage("player") < 30 then
        if UnitPower("player") >= 15 and mb_CastSpellWithoutTarget("Enraged Regeneration") then
            return
        end
    end

    if mb_Warrior_CommandingShout() then
        return
    end

    if not mb_AcquireOffensiveTarget() then
        return
    end

    if not mb_isAutoAttacking then
        InteractUnit("target")
    end

    if not UnitAffectingCombat("player") then
        return
    end

    mb_CastSpellWithoutTarget("Bloodrage")

    if UnitPower("player") >= 75 then
        if mb_cleaveMode > 0 then
            mb_CastSpellOnTarget("Cleave")
        else
            mb_CastSpellOnTarget("Heroic Strike")
        end
    end

    if UnitPower("player") >= 15 then
        if mb_GetDebuffStackCount("target", "Sunder Armor") < 5 or mb_GetDebuffTimeRemaining("target", "Sunder Armor") < 3 then
            if mb_CastSpellOnTarget("Sunder Armor") then
                return
            end
        end
    end

    if UnitPower("player") >= 10 and mb_IsSpellInRange("Mortal Strike", "target") then
        if not UnitDebuff("target", "Demoralizing Shout") and not UnitDebuff("target", "Demoralizing Roar") then
            if mb_CastSpellWithoutTarget("Demoralizing Shout") then
                return
            end
        end
    end

    if mb_cleaveMode > 0 then
        if UnitPower("player") >= 20 then
            if not UnitDebuff("target", "Thunder Clap") and not UnitDebuff("target", "Judgements of the Just") then
                if mb_CastSpellWithoutTarget("Thunder Clap") then
                    return
                end
            end
        end
        if UnitPower("player") >= 30 then
            if mb_CastSpellWithoutTarget("Sweeping Strikes") then
                return
            end
        end
    end

    if UnitPower("player") >= 10 and not mb_TargetHasMyDebuff("Rend") then
        if mb_CastSpellOnTarget("Rend") then
            return
        end
    end

    if mb_ShouldUseDpsCooldowns() then
        if UnitPower("player") >= 25 and mb_UnitHealthPercentage("target") < 20 then
            if mb_IsSpellInRange("Mortal Strike", "target") and mb_CastSpellOnTarget("Shattering Throw") then
                return
            end
        end
        if UnitPower("player") >= 25 and mb_CastSpellWithoutTarget("Bladestorm") then
            return
        end
    end

    if UnitPower("player") >= 5 and mb_CastSpellOnTarget("Overpower") then
        return
    end

    if UnitPower("player") >= 10 and mb_CastSpellOnTarget("Execute") then
        return
    end

    if UnitPower("player") >= 30 and mb_CastSpellOnTarget("Mortal Strike") then
        return
    end
    if mb_CastSpellOnTarget("Victory Rush") then
        return
    end

    if mb_CastSpellWithoutTarget("Berserker Rage") then
        return
    end

    if mb_CastSpellOnTarget("Heroic Throw") then
        return
    end
end