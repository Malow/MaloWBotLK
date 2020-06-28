function mb_Deathknight_OnLoad()
    if mb_GetMySpecName() == "Blood" then
        mb_classSpecificRunFunction = mb_Deathknight_Blood_OnUpdate
        mb_SayRaid("Blood Deathknights are not yet supported")
    elseif mb_GetMySpecName() == "Frost" then
        mb_classSpecificRunFunction = mb_Deathknight_Frost_OnUpdate
        mb_SayRaid("Frost Deathknights are not yet supported")
    else
        mb_classSpecificRunFunction = mb_Deathknight_Unholy_OnUpdate
        mb_SayRaid("Unholy Deathknights are not yet supported")
    end
end


