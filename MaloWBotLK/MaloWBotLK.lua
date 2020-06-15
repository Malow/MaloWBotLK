local MY_NAME = "MaloWBotLK"
local MY_ABBREVIATION = "MB"

-- Prints message in chatbox
function mb_print(msg)
	MaloWUtils_Print(MY_ABBREVIATION .. ": " .. tostring(msg))
end

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
SLASH_MBCOMMAND1 = "/" .. MY_ABBREVIATION;

-- Events
local hasLoaded = false
function mb_onEvent(self, event, arg1, arg2, arg3, ...)
	if event == "ADDON_LOADED" and arg1 == MY_NAME then
		hasLoaded = true
	elseif event == "CHAT_MSG_ADDON" and arg1 == "MB" then
		local message = arg2
		local from = arg4
		local mbCom = {}
		mbCom.message = message
		mbCom.from = from
		mb_handleIncomingMessage(mbCom)
	elseif event == "PLAYER_ENTER_COMBAT" then
		mb_isAutoAttacking = true
	elseif event == "PLAYER_LEAVE_COMBAT" then
		mb_isAutoAttacking = false
	elseif event == "PARTY_INVITE_REQUEST" then
		if mb_isTrustedCharacter(arg1) then
			AcceptGroup()
			StaticPopup1:Hide()
		end
	elseif event == "CONFIRM_SUMMON" then
		if mb_isEnabled and not mb_isCommanding then
			ConfirmSummon()
			StaticPopup1:Hide()
		end
	elseif event == "RESURRECT_REQUEST" then
		AcceptResurrect()
		StaticPopup1:Hide()
	elseif event == "QUEST_ACCEPT_CONFIRM" or event == "QUEST_DETAIL" then
		AcceptQuest()
		ConfirmAcceptQuest()
		StaticPopup1:Hide()
	elseif event == "GROUP_ROSTER_CHANGED" then
		mb_updateClassOrder()
	end
end
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTER_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PARTY_INVITE_REQUEST")
f:RegisterEvent("CONFIRM_SUMMON")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("QUEST_ACCEPT_CONFIRM")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("GROUP_ROSTER_CHANGED")
f:SetScript("OnEvent", mb_onEvent);

mb_hasInitiated = false
mb_classSpecificRunFunction = nil
function mb_init()
	mb_registerMessageHandlers()
	
	-- Set Class Order
	mb_updateClassOrder()
	
	mb_initClass()
	
	mb_createMacro("MBReload", "/run ReloadUI()", 1)
	SetCVar("autoSelfCast", 0) -- Disable auto self-casting to allow directly casting spells on raid-members
	SetCVar("autoLootDefault", 1) -- Enable autolooting
	
	if TI_VersionString ~= nil then -- Turn TurnIn on if it's loaded
		TI_Switch("on")
		TI_status.options[7].state = true
	end
	
	mb_hasInitiated = true
end

function mb_initClass()
	local playerClass = mb_GetClass("player")
	if playerClass == "DEATHKNIGHT" then
		mb_Deathknight_OnLoad()
		mb_GCDSpell = "Death Coil"
	elseif playerClass == "DRUID" then
		mb_Druid_OnLoad()
		mb_GCDSpell = "Healing Touch"
	elseif playerClass == "HUNTER" then
		mb_Hunter_OnLoad()
		mb_GCDSpell = "Serpent Sting"
	elseif playerClass == "MAGE" then
		mb_Mage_OnLoad()
		mb_GCDSpell = "Frost Armor"
	elseif playerClass == "PALADIN" then
		mb_Paladin_OnLoad()
		mb_GCDSpell = "Seal of Righteousness"
	elseif playerClass == "PRIEST" then
		mb_Priest_OnLoad()
		mb_GCDSpell = "Lesser Heal"
	elseif playerClass == "ROGUE" then
		mb_Rogue_OnLoad()
		mb_GCDSpell = "Sinister Strike"
	elseif playerClass == "SHAMAN" then
		mb_Shaman_OnLoad()
		mb_GCDSpell = "Healing Wave"
	elseif playerClass == "WARLOCK" then
		mb_Warlock_OnLoad()
		mb_GCDSpell = "Demon Skin"
	elseif playerClass == "WARRIOR" then
		mb_Warrior_OnLoad()
		mb_GCDSpell = "Hamstring"
	else
		mb_print("Error, playerClass " .. tostring(playerClass) .. " not supported")
	end
end


mb_classOrder = {}
mb_myClassOrderIndex = nil
function mb_updateClassOrder()
	local name = UnitName("player")
	table.insert(mb_classOrder, name)
    local members = mb_getNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_getUnitFromPartyOrRaidIndex(i)
		if mb_GetClass(unit) == mb_GetClass("player") then
			name = UnitName(unit)
			table.insert(mb_classOrder, name)
		end
	end
	table.sort(mb_classOrder)
	local count = 1
	for i, v in pairs(mb_classOrder) do
		if v == UnitName("player") then
			mb_myClassOrderIndex = i
			return
		end
	end
end




-- -------------------
-- OnUpdate stuff
-- -------------------

mb_GCDSpell = nil
mb_isCommanding = false
mb_commanderUnit = nil
mb_shouldFollow = true
mb_isEnabled = false
mb_isAutoAttacking = false
mb_time = GetTime()
mb_startedMovingForward = 0

-- OnUpdate
function mb_onUpdate()
	if not mb_isEnabled then
		return
	end
	if GetRealmName() ~= "LichKingMBW" then
		return
	end
	if not mb_hasInitiated then
		mb_init()
		return
	end
	mb_time = GetTime()
	mb_requestDesiredBuffsThrottled()
	if mb_isCommanding then
		return
	end
	if mb_commanderUnit ~= nil and mb_shouldFollow then
		FollowUnit(mb_commanderUnit)
	end
	if mb_startedMovingForward ~= 0 and mb_startedMovingForward + 2 < mb_time then
		MoveForwardStop()
		mb_startedMovingForward = 0
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
	
	if mbCom.from == UnitName("player") and string.sub(messageType, 1, 5) ~= "buff:" then
		return
	end
		
	if messageType == "enable" and mb_isTrustedCharacter(mbCom.from) then
		mb_isEnabled = true
		mb_init()
		return
	end
	
	if not mb_isEnabled then
		return
	end
	
	if mb_registeredMessageHandlers[messageType] ~= nil then
		mb_registeredMessageHandlers[messageType](message, mbCom.from)
	end
end

function mb_initAsLeader()
	mb_sendMessage("enable")
	mb_sendMessage("setCommander", UnitName("player"))
	mb_updateClassOrder()
	if not mb_hasInitiated then
		mb_initClass()
		mb_hasInitiated = true
	end
	mb_isCommanding = true
	mb_isEnabled = true
end

mb_desiredBuffs = {}
function mb_registerDesiredBuff(buff)
	table.insert(mb_desiredBuffs, buff)
end

mb_lastBuffRequest = GetTime()
function mb_requestDesiredBuffsThrottled()
	if mb_lastBuffRequest + 3 > mb_time then
		return
	end
	mb_lastBuffRequest = mb_time
	for _, buff in pairs(mb_desiredBuffs) do
		local hasBuff = false

		if buff.singleAuraName ~= nil and UnitAura("player", buff.singleAuraName) then
			hasBuff = true
		end
		if buff.groupAuraName ~= nil and UnitAura("player", buff.groupAuraName) then
			hasBuff = true
		end

		if not hasBuff then
			mb_sendMessage(buff.requestType)
		end
	end
end




