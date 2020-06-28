function mb_Rogue_OnLoad()
    if mb_GetMySpecName() == "Assassination" then
        mb_classSpecificRunFunction = mb_Rogue_Assassination_OnUpdate
        mb_SpecNotSupported("Assassination Rogues are not yet supported")
    elseif mb_GetMySpecName() == "Combat" then
        mb_classSpecificRunFunction = mb_Rogue_Combat_OnUpdate
        mb_SpecNotSupported("Combat Rogues are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Rogue_Subtlety_OnUpdate
        mb_SpecNotSupported("Subtlety Rogues are not yet supported")
    end
end