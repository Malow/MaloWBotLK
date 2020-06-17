function mb_registerMessageHandlers()
	mb_registerMessageHandler("lc", mb_lcHandler)

	if mb_isCommanding then
		return
	end

    mb_registerMessageHandler("remoteExecute", mb_remoteExecuteHandler)
    mb_registerMessageHandler("setCommander", mb_setCommanderHandler)
    mb_registerMessageHandler("mount", mb_mountHandler)
    mb_registerMessageHandler("accept", mb_acceptHandler)
    mb_registerMessageHandler("moveForward", mb_moveForwardHandler)
end

function mb_remoteExecuteHandler(msg, from)
	if not mb_isTrustedCharacter(from) then
		mb_print(from .. " tried to make me remoteExecute but I don't trust him/her")
		return
	end
	local func = loadstring(msg)
	if func == nil then
		SendChatMessage("Bad Code: " .. code, "RAID", "Common")
	else
		func()
	end
end

function mb_setCommanderHandler(msg, from)
	if not mb_isTrustedCharacter(from) then
		return
	end
	mb_commanderUnit = mb_getUnitForPlayerName(msg)
end

function mb_mountHandler(msg, from)
    if UnitRace("player") == "Human" and not UnitBuff("player", "Swift Palomino") then
        CastSpellByName("Swift Palomino")
        return
    end
    if UnitRace("player") == "Draenei" and not UnitBuff("player", "Great Red Elekk") then
        CastSpellByName("Great Red Elekk")
        return
    end
end

function mb_acceptHandler(msg, from)
	if not mb_isTrustedCharacter(from) then
		return
	end
    AcceptGuild()
    RetrieveCorpse()
	AcceptTrade()
end

function mb_moveForwardHandler(msg, from)
	if not mb_isTrustedCharacter(from) then
		return
	end
	mb_startedMovingForward = mb_time
	MoveForwardStart()
end

function mb_lcHandler(msg, from)
	mb_LootHandler_handleLootCouncilRequest(msg)
end
