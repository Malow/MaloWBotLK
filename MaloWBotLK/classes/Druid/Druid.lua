function mb_Druid_OnLoad()
    if mb_GetMySpecName() == "Balance" then
        mb_classSpecificRunFunction = mb_Druid_Balance_OnUpdate
        mb_SpecNotSupported("Balance Druids are not yet supported")
    elseif mb_GetMySpecName() == "Feral Combat" then
        mb_classSpecificRunFunction = mb_Druid_Feral_OnUpdate
        mb_SpecNotSupported("Feral Druids are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Druid_Restoration_OnUpdate
        mb_SpecNotSupported("Restoration Druids are not yet supported")
    end
end