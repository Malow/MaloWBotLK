-- TODO:
-- Every man for Himself on CC
-- Tricks of the Trade with requests

function mb_Rogue_Combat_OnUpdate()
    if not mb_IsReadyForNewCast() then
        return
    end

    if mb_Rogue_ApplyPoisons() then
        return
    end

    if UnitAffectingCombat("player") and mb_UnitHealthPercentage("player") < 30 then
        if mb_CastSpellWithoutTarget("Evasion") then
            return
        end
        if mb_CastSpellWithoutTarget("Cloak of Shadows") then
            return
        end
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

    if mb_GetMyThreatPercentage("target") > 85 then
        if mb_CastSpellWithoutTarget("Vanish") then
            return
        end
    end

    mb_HandleAutomaticSalvationRequesting()

    if mb_GetBuffTimeRemaining("player", "Slice and Dice") == 0 then
        if mb_GetComboPoints("player", "target") >= 4 then
            if mb_CastSpellWithoutTarget("Slice and Dice") then
                -- mb_SayRaid("Casting " .. tostring(mb_GetComboPoints()) .. "p Slice and Dice")
            end
            return
        elseif mb_GetComboPoints("player", "target") > 0 and UnitPower("player") < 55 then
            if mb_CastSpellWithoutTarget("Slice and Dice") then
                -- mb_SayRaid("Casting " .. tostring(mb_GetComboPoints()) .. "p Slice and Dice")
            end
            return
        else
            mb_CastSpellOnTarget("Sinister Strike")
            return
        end
    end

    if mb_ShouldUseDpsCooldowns("Sinister Strike") then
        mb_UseItemCooldowns()
        if mb_CastSpellWithoutTarget("Blade Flurry") then
            return
        end
        if UnitPower("player") < 60 and mb_GetBuffTimeRemaining("player", "Adrenaline Rush") == 0 then
            if mb_CastSpellWithoutTarget("Killing Spree") then
                return
            end
        end
        if mb_CastSpellWithoutTarget("Adrenaline Rush") then
            return
        end
    end

    if mb_cleaveMode > 1 then
        mb_CastSpellWithoutTarget("Fan of Knives")
        return
    end

    -- Evisc early to align next S&D or Rupture

    if mb_GetComboPoints() < 4 then
        mb_CastSpellOnTarget("Sinister Strike")
        return
    end

    local predictedEnergyBeforeNextSnd = mb_Rogue_GetPredictedEnergyIn(mb_GetBuffTimeRemaining("player", "Slice and Dice"))
    if predictedEnergyBeforeNextSnd < 100 then
        return
    elseif mb_GetComboPoints() == 4 and predictedEnergyBeforeNextSnd - 40 < 100 then
        mb_CastSpellOnTarget("Sinister Strike")
        return
    end

    if mb_GetMyDebuffTimeRemaining("target", "Rupture") == 0 then
        if mb_CastSpellOnTarget("Rupture") then
            -- mb_SayRaid("Casting " .. tostring(mb_GetComboPoints()) .. "p Rupture")
        end
        return
    end

    local predictedEnergyBeforeNextRupture = mb_Rogue_GetPredictedEnergyIn(mb_GetMyDebuffTimeRemaining("target", "Rupture"))
    if predictedEnergyBeforeNextRupture < 100 then
        return
    elseif mb_GetComboPoints() == 4 and predictedEnergyBeforeNextRupture - 40 < 100 then
        mb_CastSpellOnTarget("Sinister Strike")
        return
    end

    if mb_CastSpellOnTarget("Eviscerate") then
        -- mb_SayRaid("Casting " .. tostring(mb_GetComboPoints()) .. "p Eviscerate")
    end
end