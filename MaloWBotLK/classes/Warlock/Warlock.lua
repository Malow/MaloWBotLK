function mb_Warlock_OnLoad()
    if mb_GetMySpecName() == "Affliction" then
        mb_classSpecificRunFunction = mb_Warlock_Affliction_OnUpdate
        mb_SpecNotSupported("Affliction Warlocks are not yet supported")
    elseif mb_GetMySpecName() == "Demonology" then
        mb_classSpecificRunFunction = mb_Warlock_Demonology_OnUpdate
        mb_SpecNotSupported("Demonology Warlocks are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Warlock_Destruction_OnUpdate
        mb_SpecNotSupported("Destruction Warlocks are not yet supported")
    end
end