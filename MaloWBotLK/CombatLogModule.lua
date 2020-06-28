mb_CombatLogModule_frame = CreateFrame("frame", "MaloWBotCombatLogModuleFrame", UIParent)
mb_CombatLogModule_frame:Show()

function mb_CombatLogModule_OnEvent(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
    if arg6 == UnitName("player") then
        if arg4 == "SWING_DAMAGE" or arg4 == "SWING_MISSED" then
            mb_CombatLogModule_lastSwingTime = mb_time
            return
        end
    end
end

mb_CombatLogModule_lastSwingTime = 0
function mb_CombatLogModule_GetLastSwingTime()
    return mb_CombatLogModule_lastSwingTime
end

function mb_CombatLogModule_Enable()
    mb_CombatLogModule_frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
end

mb_CombatLogModule_frame:SetScript("OnEvent", mb_CombatLogModule_OnEvent)