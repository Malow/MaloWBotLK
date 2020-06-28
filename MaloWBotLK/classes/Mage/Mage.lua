function mb_Mage_OnLoad()
    if mb_GetMySpecName() == "Arcane" then
        mb_classSpecificRunFunction = mb_Mage_Arcane_OnUpdate
        mb_SpecNotSupported("Arcane Mages are not yet supported")
    elseif mb_GetMySpecName() == "Fire" then
        mb_classSpecificRunFunction = mb_Mage_Fire_OnUpdate
        mb_SpecNotSupported("Fire Mages are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Mage_Frost_OnUpdate
        mb_SpecNotSupported("Frost Mages are not yet supported")
    end
end