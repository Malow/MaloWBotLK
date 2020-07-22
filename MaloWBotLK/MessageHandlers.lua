function mb_RegisterMessageHandlers()
    mb_RegisterMessageHandler("lc", mb_LcHandler)

    if mb_isCommanding then
        return
    end

    mb_RegisterMessageHandler("remoteExecute", mb_RemoteExecuteHandler)
    mb_RegisterMessageHandler("setCommander", mb_SetCommanderHandler)
    mb_RegisterMessageHandler("mount", mb_MountHandler)
    mb_RegisterMessageHandler("accept", mb_AcceptHandler)
    mb_RegisterMessageHandler("moveForward", mb_MoveForwardHandler)
end

function mb_RemoteExecuteHandler(msg, from)
    if not mb_IsTrustedCharacter(from) then
        return
    end
    local func = loadstring(msg)
    if func == nil then
        mb_SayRaid("Bad Code: " .. msg)
    else
        func()
    end
end

function mb_SetCommanderHandler(msg, from)
    if not mb_IsTrustedCharacter(from) then
        return
    end
    mb_commanderUnit = mb_GetUnitForPlayerName(msg)
end

function mb_MountHandler(msg, from)
    if not mb_IsTrustedCharacter(from) then
        return
    end
    if IsMounted() then
        return
    end
    CallCompanion("MOUNT", 1)
end

function mb_AcceptHandler(msg, from)
    if not mb_IsTrustedCharacter(from) then
        return
    end
    AcceptGuild()
    RetrieveCorpse()
    AcceptTrade()
end

function mb_MoveForwardHandler(msg, from)
    if not mb_IsTrustedCharacter(from) then
        return
    end
    mb_shouldStopMovingForwardAt = mb_time + 2
    MoveForwardStart()
end

function mb_LcHandler(msg, from)
    mb_LootHandler_HandleLootCouncilRequest(msg)
end
