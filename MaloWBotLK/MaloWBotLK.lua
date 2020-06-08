local MY_NAME = "MaloWBotLK"
local MY_ABBREVIATION = "MB"

-- Frame setup for update
local total = 0
local function mb_update(self, elapsed)
	total = total + elapsed
	if total >= 0.1 then
		total = 0
		mb_onUpdate()
    end
end
local f = CreateFrame("frame", MY_NAME .. "Frame", UIParent)
f:SetPoint("CENTER")
f:SetScript("OnUpdate", mb_update)
f:SetSize(1, 1)
f:Show()

-- Cmds
SlashCmdList[MY_ABBREVIATION .. "COMMAND"] = function(msg)
	if not mb_handleCommand(msg) then
		mb_print("Unrecognized command: " .. msg)
	end
end 
SLASH_MPCOMMAND1 = "/" .. MY_ABBREVIATION;

-- Events
local hasLoaded = false
function mb_onEvent(self, event, arg1, arg2, arg3, ...)
	if event == "ADDON_LOADED" and arg1 == MY_NAME then
		hasLoaded = true
	elseif event == "CHAT_MSG_ADDON" and arg1 == "MB" then
		local message = arg2
		local from = arg4
		if from ~= UnitName("player") then
			local mbCom = {}
			mbCom.message = message
			mbCom.from = from
			mb_handleIncomingMessage(mbCom)
		end
	elseif event == "PLAYER_ENTER_COMBAT" then
		mb_isAutoAttacking = true
	elseif event == "PLAYER_LEAVE_COMBAT" then
		mb_isAutoAttacking = false
	end
end
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTER_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:SetScript("OnEvent", mb_onEvent);

mb_hasInitiated = false
mb_classSpecificRunFunction = nil
function mb_init()
	mb_registerMessageHandlers()
	local playerClass = mb_GetClass("player")
	if playerClass == "DEATHKNIGHT" then
		mb_Deathknight_OnLoad()
		mb_classSpecificRunFunction = mb_Deathknight_OnUpdate
	elseif playerClass == "DRUID" then
		mb_Druid_OnLoad()
		mb_classSpecificRunFunction = mb_Druid_OnUpdate
	elseif playerClass == "HUNTER" then
		mb_Hunter_OnLoad()
		mb_classSpecificRunFunction = mb_Hunter_OnUpdate
	elseif playerClass == "MAGE" then
		mb_Mage_OnLoad()
		mb_classSpecificRunFunction = mb_Mage_OnUpdate
	elseif playerClass == "PALADIN" then
		mb_Paladin_OnLoad()
		mb_classSpecificRunFunction = mb_Paladin_OnUpdate
	elseif playerClass == "PRIEST" then
		mb_Priest_OnLoad()
		mb_classSpecificRunFunction = mb_Priest_OnUpdate
	elseif playerClass == "ROGUE" then
		mb_Rogue_OnLoad()
		mb_classSpecificRunFunction = mb_Rogue_OnUpdate
	elseif playerClass == "SHAMAN" then
		mb_Shaman_OnLoad()
		mb_classSpecificRunFunction = mb_Shaman_OnUpdate
	elseif playerClass == "WARLOCK" then
		mb_Warlock_OnLoad()
		mb_classSpecificRunFunction = mb_Warlock_OnUpdate
	elseif playerClass == "WARRIOR" then
		mb_Warrior_OnLoad()
		mb_classSpecificRunFunction = mb_Warrior_OnUpdate
	else
		mb_print("Error, playerClass " .. tostring(playerClass) .. " not supported")
	end
	mb_createMacro("MBReload", "/run ReloadUI()", 1)
	mb_hasInitiated = true
end





-------------------------------------------------------------------
-- Lib stuff
-------------------------------------------------------------------

function mb_getNumPartyOrRaidMembers()
	if UnitInRaid("player") then
		return GetNumRaidMembers()
	else
		return GetNumPartyMembers()
	end
	return 0
end

-- Returns the unit that has specified raidIndex
function mb_getUnitFromPartyOrRaidIndex(index)
	if index ~= 0 then
		if UnitInRaid("player") then
			return "raid" .. index
		else
			return "party" .. index
		end
	end
	return "player"
end

-- Returns the unit that has specified raidIndex
function mb_getUnitFromPartyOrRaidIndex(index)
	if index ~= 0 then
		if UnitInRaid("player") then
			return "raid" .. index
		else
			return "party" .. index
		end
	end
	return "player"
end

-- Turns a playerName into a unit-reference, nil if not found
function mb_getUnitForPlayerName(playerName)
	local members = mb_getNumPartyOrRaidMembers()
	for i = 1, members do
		local unit = mb_getUnitFromPartyOrRaidIndex(i)
		if UnitName(unit) == playerName then
			return unit
		end
	end
	if UnitName("player") == playerName then
		return "player"
	end
	return nil
end

-- Returns a bool, and the substring of the remaining string
function mb_stringStartsWith(fullString, startString)
	if string.sub(fullString, 1, string.len(startString)) == startString then
		return true, string.sub(fullString, string.len(startString) + 2)
	end
	return false, nil
end

-- Prints message in chatbox
function mb_print(msg)
	MaloWUtils_Print(MY_ABBREVIATION .. ": " .. tostring(msg))
end

-- Prints message in raid-chat
function mb_sayRaid(message)
	SendChatMessage(message, "RAID", "Common")
end

function mb_createMacro(name, body, actionSlot)
	local macroId = GetMacroIndexByName(name)
	if macroId > 0 then
		EditMacro(macroId, name, 12, body, 1, 1)
	else
		macroId = CreateMacro(name, 12, body, 1, 1)
	end
	PickupMacro(macroId)
	PlaceAction(actionSlot)
	ClearCursor()
end

function mb_hasValidOffensiveTarget()
	if not UnitExists("target") then
		return false
	end
	if UnitIsDeadOrGhost("target") then
		return false
	end
	if UnitIsFriend("player", "target") then
		return false
	end
	if not UnitCanAttack("player", "target") == 1 then
		return false
	end
	return true
end

function mb_getMissingHealth(unit)
	return UnitHealthMax(unit) - UnitHealth(unit)
end

-- Checks if target exists, is visible, is friendly and if it's dead or ghost
function mb_isUnitValidFriendlyTarget(unit)
    if UnitIsDeadOrGhost(unit) then
        return false
    end
	if not CheckInteractDistance(unit, 4) then
		return false
	end
	return true
end

-- Scans through the raid or party for the unit missing the most health.
function mb_GetMostDamagedFriendly()
    local healTarget = 0
    local missingHealthOfTarget = mb_getMissingHealth("player")
    local members = mb_getNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_getUnitFromPartyOrRaidIndex(i)
        local missingHealth = mb_getMissingHealth(unit)
        if missingHealth > missingHealthOfTarget then
            if mb_isUnitValidFriendlyTarget(unit) then
                missingHealthOfTarget = missingHealth
                healTarget = i
            end
        end
    end
    if healTarget == 0 then
        return "player", missingHealthOfTarget
    else
        return mb_getUnitFromPartyOrRaidIndex(healTarget), missingHealthOfTarget
    end
end



-------------------------------------------------------------------
-- End of Lib stuff
-------------------------------------------------------------------





mb_commanderUnit = nil
mb_shouldFollow = true
mb_enabled = false
mb_isAutoAttacking = false

-- OnUpdate
function mb_onUpdate()
	if GetRealmName() ~= "LichKingMBW" then
		return
	end
	if not hasLoaded or not mb_enabled then
		return
	end
	if not mb_hasInitiated then
		mb_init()
		return
	end
	
	if mb_commanderUnit ~= nil and mb_shouldFollow then
		FollowUnit(mb_commanderUnit)
	end
	mb_classSpecificRunFunction()
end

function mb_handleCommand(msg)
	local isRemoteExecute, remainingString = mb_stringStartsWith(msg, "remoteExecute")
	if isRemoteExecute then
		mb_sendMessage("remoteExecute ", remainingString)
		return true
	end
	
	return false
end

function mb_sendMessage(messageType, message)
	SendAddonMessage("MB", messageType .. " " .. tostring(message), "RAID")
end

mb_registeredMessageHandlers = {}
function mb_registerMessageHandler(messageType, handlerFunc)
	mb_registeredMessageHandlers[messageType] = handlerFunc
end

function mb_handleIncomingMessage(mbCom)
	local messageType = string.sub(mbCom.message, 1, string.find(mbCom.message, " ") - 1)
	local message = string.sub(mbCom.message, string.find(mbCom.message, " ") + 1)
		
	if messageType == "enable" then
		mb_enabled = true
		mb_init()
		return
	end
	
	if not mb_enabled then
		return
	end
	
	if mb_registeredMessageHandlers[messageType] ~= nil then
		mb_registeredMessageHandlers[messageType](message)
		return
	end
	mb_sayRaid("I don't have a MessageHandler registered for: " .. messageType)
end

function mb_initAsLeader()
	mb_sendMessage("enable")
	mb_sendMessage("setCommander", UnitName("player"))
end


