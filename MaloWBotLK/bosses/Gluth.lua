
mb_BossModule_Gluth_lastExternalRequest = 0
function mb_BossModule_Gluth_PreOnUpdate()
    if mb_IsTank() then
        if not UnitIsUnit("player", "targettarget") then
            if not UnitDebuff("player", "Mortal Wound") then
                if mb_GetClass("player") == "PALADIN" then
                    mb_CastSpellOnTarget("Reckoning")
                    return true
                elseif mb_GetClass("player") == "DRUID" then
                    mb_CastSpellOnTarget("Growl")
                    return true
                end
            end
        elseif UnitBuff("target", "Enrage") then
            if mb_BossModule_Gluth_lastExternalRequest + 10 < mb_time then
                mb_BossModule_Gluth_lastExternalRequest = mb_time
                mb_SendExclusiveRequest("external", "")
            end
            mb_UseItemCooldowns()
            if mb_GetClass("player") == "PALADIN" then
                if mb_CastSpellWithoutTarget("Divine Protection") then
                    return true
                end
            elseif mb_GetClass("player") == "DRUID" then
                if mb_CastSpellWithoutTarget("Barkskin") then
                    return true
                end
                if mb_CastSpellWithoutTarget("Survival Instincts") then
                    return true
                end
            end
        end
    end
    return false
end

function mb_BossModule_Gluth_OnLoad()
    mb_BossModule_PreOnUpdate = mb_BossModule_Gluth_PreOnUpdate
end

mb_BossModule_RegisterModule("gluth", mb_BossModule_Gluth_OnLoad)