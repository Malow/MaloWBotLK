
function mb_BossModule_Kelthuzad_PreOnUpdate()
    if UnitIsDeadOrGhost("player") then
        return
    end
    if mb_commanderUnit == nil and UnitName("target") ~= "Kel'Thuzad" then
        return
    end
    if mb_commanderUnit ~= nil and UnitName(mb_commanderUnit .. "target") ~= "Kel'Thuzad" then
        return
    end
    if mb_BossModule_Kelthuzad_ManaDetonation() then
        return
    end
    mb_BossModule_Kelthuzad_VoidZone()
    mb_BossModule_Kelthuzad_DoRangeCheck()
    return false
end

mb_BossModule_Kelthuzad_positionPreManaDetonation = nil
function mb_BossModule_Kelthuzad_ManaDetonation()
    if mb_GetDebuffTimeRemaining("player", "Detonate Mana") > 0 then
        if mb_BossModule_Kelthuzad_positionPreManaDetonation == nil then
            mb_BossModule_Kelthuzad_positionPreManaDetonation = {}
            local x, y = mb_GetMapPosition("player")
            mb_BossModule_Kelthuzad_positionPreManaDetonation.x = x
            mb_BossModule_Kelthuzad_positionPreManaDetonation.y = y
            mb_SayRaid("Detonate Mana on me!")
        end
        local x, y = mb_BossModule_Kelthuzad_GetClosestSafeManaDetonationSpot()
        if mb_GoToPosition_Update(x, y, 0.003) then
            return
        else
            mb_GoToPosition_Reset()
        end
    else
        if mb_BossModule_Kelthuzad_positionPreManaDetonation == nil then
            mb_GoToPosition_Reset()
        else
            if not mb_GoToPosition_Update(mb_BossModule_Kelthuzad_positionPreManaDetonation.x, mb_BossModule_Kelthuzad_positionPreManaDetonation.y, 0.003) then
                mb_BossModule_Kelthuzad_positionPreManaDetonation = nil
                mb_GoToPosition_Reset()
            end
        end
    end
end

mb_BossModule_Kelthuzad_safeManaDetonationSpots = {
    {x = 0.31086, y = 0.17621}, -- NW
    {x = 0.30254, y = 0.24763}, -- W
    {x = 0.32986, y = 0.31212}, -- SW
    {x = 0.37876, y = 0.32598}, -- SE
    {x = 0.42104, y = 0.28386}, -- E
    {x = 0.43086, y = 0.21019}, -- NE
}
function mb_BossModule_Kelthuzad_GetClosestSafeManaDetonationSpot()
    local curX, curY = mb_GetMapPosition("player")
    local minDistance = 999999
    local minDistanceSpot = nil
    for _, spot in pairs(mb_BossModule_Kelthuzad_safeManaDetonationSpots) do
        local dX, dY = spot.x - curX, spot.y - curY
        local distance = math.sqrt(dX * dX + dY * dY)
        if distance < minDistance then
            minDistance = distance
            minDistanceSpot = spot
        end
    end
    if minDistanceSpot == nil then
        mb_SayRaid("Couldn't find a safe mana detonation spot")
        return nil, nil
    end
    return minDistanceSpot.x, minDistanceSpot.y
end

mb_BossModule_Kelthuzad_lastDetectedVoidZone = 0
mb_BossModule_Kelthuzad_isMovingFromVoidZone = false
function mb_BossModule_Kelthuzad_VoidZone()
    local timeSinceVoidZone = mb_time - mb_BossModule_Kelthuzad_lastDetectedVoidZone
    if timeSinceVoidZone < 3 then
        mb_DisableAutomaticMovement()
        mb_BossModule_Kelthuzad_isMovingFromVoidZone = true
        return
    end
    if timeSinceVoidZone < 5 then
        StrafeLeftStart()
        return
    end
    if timeSinceVoidZone < 7 then
        StrafeLeftStop()
        StrafeRightStart()
        return
    end
    if mb_BossModule_Kelthuzad_isMovingFromVoidZone then
        mb_StopMoving()
        mb_EnableAutomaticMovement()
        mb_BossModule_Kelthuzad_isMovingFromVoidZone = false
    end
end

mb_BossModule_Kelthuzad_lastRangeCheck = 0
function mb_BossModule_Kelthuzad_DoRangeCheck()
    if mb_BossModule_Kelthuzad_lastRangeCheck + 1 > mb_time then
        return
    end
    mb_BossModule_Kelthuzad_lastRangeCheck = mb_time
    local count = 0
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
        if UnitCanAttack("player", unit) == 1 then
            if mb_CrowdControl(unit) then
                return
            end
        end
        if not UnitIsDeadOrGhost(unit) and CheckInteractDistance(unit, 2) then
            count = count + 1
        end
    end
    if count > 5 then
        mb_SayRaid("I have " .. tostring(count) .. " friendlies close to me")
    end
    return
end

function mb_BossModule_Kelthuzad_CombatLogCallback(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15)
    if arg6 == "Kel'Thuzad" and arg4 == "SPELL_CAST_SUCCESS" and arg12 == "Shadow Fissure" then
        local targetUnit = mb_GetUnitForPlayerName(arg9)
        if targetUnit ~= nil then
            if CheckInteractDistance(targetUnit, 3) then
                mb_BossModule_Kelthuzad_lastDetectedVoidZone = mb_time
                mb_SayRaid("I'm running from Void Zone!")
            end
        end
    end
end

function mb_BossModule_Kelthuzad_OnLoad()
    mb_BossModule_PreOnUpdate = mb_BossModule_Kelthuzad_PreOnUpdate
    mb_CombatLogModule_Enable()
    mb_CombatLogModule_SetCallback(mb_BossModule_Kelthuzad_CombatLogCallback)
end

mb_BossModule_RegisterModule("kelthuzad", mb_BossModule_Kelthuzad_OnLoad)