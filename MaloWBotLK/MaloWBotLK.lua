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
	local arguments = MaloWUtils_SplitStringOnSpace(msg)
	local command = table.remove(arguments, 1)
	if not mb_handleCommand(command, arguments) then
		mb_print("Unrecognized command: " .. command)
	end
end 
SLASH_MPCOMMAND1 = "/" .. MY_ABBREVIATION;

-- Prints message in chatbox
function mb_print(msg)
	MaloWUtils_Print(MY_ABBREVIATION .. ": " .. tostring(msg))
end

-- Events
mb_queuedIncomingCommunications = {}
local hasLoaded = false
function mb_onEvent(self, event, arg1, arg2, arg3, ...)
	if event == "ADDON_LOADED" and arg1 == MY_NAME then
		hasLoaded = true
		return
	end
	if event == "CHAT_MSG_ADDON" and arg1 == "MB" then
		local message = arg2
		local from = arg4
		if from ~= UnitName("player") then
			local mbCom = {}
			mbCom.message = message
			mbCom.from = from
			table.insert(mb_queuedIncomingCommunications, mbCom)
		end
	end
end
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("CHAT_MSG_ADDON")
f:SetScript("OnEvent", mb_onEvent);

function mb_getIncomingCommunication()
	local mbCom = table.remove(mb_queuedIncomingCommunications, 1)
	return mbCom
end

mb_classSpecificRunFunction = nil
function mb_init()
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
		mb_Print("Error, playerClass " .. tostring(playerClass) .. " not supported")
	end
end

-- OnUpdate
local hasInitiated = false
function mb_onUpdate()
	if GetRealmName() ~= "LichKingMBW" then
		return
	end
	if not hasLoaded then
		return
	end
	if not hasInitiated then
		hasInitiated = true
		mb_init()
		return
	end
	
	mb_classSpecificRunFunction()
end

function mb_handleCommand(command, arguments)
	if command == "sendmsg" then
		SendAddonMessage("MB", arguments[1], "RAID")
		return true
	end
	
	return false
end

