

function mb_BossModule_Thaddius_PreOnUpdate()
    if mb_GetDebuffTimeRemaining("player", "Positive Charge") > 0 then
        mb_followMode = "none"
        return mb_GoToPosition_Update(0.27263963, 0.13271786, 0.003)
    elseif mb_GetDebuffTimeRemaining("player", "Negative Charge") > 0 then
        mb_followMode = "none"
        return mb_GoToPosition_Update(0.25859490, 0.15420512, 0.003)
    end
    mb_GoToPosition_Reset()
    return false
end

function mb_BossModule_Thaddius_OnLoad()
    mb_BossModule_PreOnUpdate = mb_BossModule_Thaddius_PreOnUpdate
end

mb_BossModule_RegisterModule("thaddius", mb_BossModule_Thaddius_OnLoad)