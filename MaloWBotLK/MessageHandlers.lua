function mb_registerMessageHandlers()
    mb_registerMessageHandler("remoteExecute", mb_remoteExecuteHandler)
    mb_registerMessageHandler("setCommander", mb_setCommanderHandler)
    mb_registerMessageHandler("mount", mb_mountHandler)
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

function mb_setCommanderHandler(msg)
	mb_commanderUnit = mb_getUnitForPlayerName(msg)
end

function mb_mountHandler(msg)
	if not UnitBuff("player", "Swift Palomino") then 
		CastSpellByName("Swift Palomino")
	end
end



