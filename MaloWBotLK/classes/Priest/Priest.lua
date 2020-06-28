function mb_Priest_OnLoad()
    if mb_GetMySpecName() == "Discipline" then
        mb_classSpecificRunFunction = mb_Priest_Discipline_OnUpdate
        mb_SpecNotSupported("Discipline Priests are not yet supported")
    elseif mb_GetMySpecName() == "Holy" then
        mb_classSpecificRunFunction = mb_Priest_Holy_OnUpdate
        mb_SpecNotSupported("Holy Priests are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Priest_Shadow_OnUpdate
        mb_SpecNotSupported("Shadow Priests are not yet supported")
    end
end