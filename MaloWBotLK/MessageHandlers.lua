function mb_registerMessageHandlers()
    mb_registerMessageHandler("remoteExecute", mb_remoteExecuteHandler)
    mb_registerMessageHandler("setCommander", mb_setCommanderHandler)
end

function mb_remoteExecuteHandler(msg)
	if not mb_isTrustedCharacter(mbCom.from) then
		mb_print(mbCom.from .. " tried to make me remoteExecute but I don't trust him/her")
		return
	end
	local func = loadstring(remainingString)
	if func == nil then
		SendChatMessage("Bad Code: " .. code, "RAID", "Common")
	else
		func()
	end
end

function mb_setCommanderHandler(msg)
	mb_commanderUnit = mb_getUnitForPlayerName(msg)
end



