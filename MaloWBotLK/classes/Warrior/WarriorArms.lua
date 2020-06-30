-- TODO:
-- Use Every Man For Himself on loss of control
-- Start using on-use trinkets
-- Interrupt with pummel
-- Recklessness on pre-pull
-- Some better check for Commanding Shout than CheckInteractDistance(unit, 4), that's 28 yards, range is 45 yards.
-- 		Maybe some item you can use on friendly?

function mb_Warrior_Arms_OnLoad()
    mb_EnableIWTDistanceClosing("Mortal Strike")
    mb_CombatLogModule_Enable()
end

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

    if (mb_commanderUnit == nil or CheckInteractDistance(mb_commanderUnit, 1)) and CheckInteractDistance("target", 1) then
        if mb_CastSpellOnTarget("Charge") then
            return
        end
    end

    mb_CastSpellWithoutTarget("Bloodrage")

    if UnitPower("player") >= 75 then
        if mb_cleaveMode > 0 then
            mb_CastSpellOnTarget("Cleave")
        else
            mb_CastSpellOnTarget("Heroic Strike")
        end
    end

    if mb_GetMyDebuffTimeRemaining("target", "Rend") == 0 then
        mb_CastSpellOnTarget("Rend")
        return
    end

    if mb_GetDebuffStackCount("target", "Sunder Armor") < 5 or mb_GetDebuffTimeRemaining("target", "Sunder Armor") < 5 then
        mb_CastSpellOnTarget("Sunder Armor")
        return
    end

    if UnitBuff("player", "Sudden Death") then
        mb_CastSpellOnTarget("Execute")
        return
    end

    if mb_IsSpellInRange("Mortal Strike", "target") then
        if not UnitDebuff("target", "Demoralizing Shout") and not UnitDebuff("target", "Demoralizing Roar") then
            mb_CastSpellWithoutTarget("Demoralizing Shout")
            return
        end
    end

    if mb_CastSpellOnTarget("Overpower") then
        return
    end

    if mb_ShouldUseDpsCooldowns("Mortal Strike") then
        mb_UseItemCooldowns()
        if UnitPower("player") >= 25 and mb_UnitHealthPercentage("target") < 20 then
            if mb_IsSpellInRange("Mortal Strike", "target") and mb_CastSpellOnTarget("Shattering Throw") then
                return
            end
        end
    end

    if mb_cleaveMode > 0 then
        if not UnitDebuff("target", "Thunder Clap") and mb_IsSpellInRange("Mortal Strike", "target") then
            mb_CastSpellWithoutTarget("Thunder Clap")
            return
        end
        if mb_GetRemainingSpellCooldown("Sweeping Strikes") == 0 and mb_IsSpellInRange("Mortal Strike", "target") then
            mb_CastSpellWithoutTarget("Sweeping Strikes")
            return
        end
        if mb_GetRemainingSpellCooldown("Bladestorm") == 0 and mb_IsSpellInRange("Mortal Strike", "target") then
            mb_CastSpellWithoutTarget("Bladestorm")
            return
        end
        if mb_cleaveMode > 1 and mb_GetRemainingSpellCooldown("Thunder Clap") == 0 and mb_IsSpellInRange("Mortal Strike", "target") then
            mb_CastSpellWithoutTarget("Thunder Clap")
            return
        end
    end

    if mb_UnitHealthPercentage("target") < 20 then
        mb_CastSpellOnTarget("Execute")
        return
    end

    local timeRemainingUntilNextSwing = (mb_CombatLogModule_GetLastSwingTime() + UnitAttackSpeed("player")) - mb_time
    if timeRemainingUntilNextSwing > 0.6 then
        mb_CastSpellOnTarget("Slam")
        return
    end

    if mb_CastSpellOnTarget("Mortal Strike") then
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