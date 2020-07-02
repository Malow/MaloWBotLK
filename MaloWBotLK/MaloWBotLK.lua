local MY_NAME = "MaloWBotLK"
local MY_ABBREVIATION = "MB"

-- Prints message in chatbox
function mb_Print(msg)
	if type(msg) == "table" then
		msg = MaloWUtils_ConvertTableToString(msg)
	end
	MaloWUtils_Print(MY_ABBREVIATION .. ": " .. tostring(msg))
end

-- Frame setup for update
local total = 0
local function mb_Update(self, elapsed)
	total = total + elapsed
	if total >= 0.1 then
		total = 0
		mb_OnUpdate()
    end
end
local f = CreateFrame("frame", MY_NAME .. "Frame", UIParent)
f:SetPoint("CENTER")
f:SetScript("OnUpdate", mb_Update)
f:SetSize(1, 1)
f:Show()

-- Cmds
SlashCmdList[MY_ABBREVIATION .. "COMMAND"] = function(msg)
	if not mb_HandleCommand(msg) then
		mb_Print("Unrecognized command: " .. msg)
	end
end 
SLASH_MBCOMMAND1 = "/" .. MY_ABBREVIATION;

-- Events
local hasLoaded = false
function mb_OnEvent(self, event, arg1, arg2, arg3, arg4, ...)
	if event == "ADDON_LOADED" and arg1 == MY_NAME then
		hasLoaded = true
	elseif event == "CHAT_MSG_ADDON" and arg1 == "MB" then
		local mbCom = {}
		mbCom.message = arg2
		mbCom.from = arg4
		mb_HandleIncomingMessage(mbCom)
	elseif event == "PLAYER_ENTER_COMBAT" then
		mb_isAutoAttacking = true
	elseif event == "PLAYER_LEAVE_COMBAT" then
		mb_isAutoAttacking = false
	elseif event == "PARTY_INVITE_REQUEST" then
		if mb_IsTrustedCharacter(arg1) then
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
		mb_UpdateClassOrder()
	elseif event == "UI_ERROR_MESSAGE" then
		if arg1 == "You are too far away!" then
			mb_HandleTooFarAway()
		elseif arg1 == "You are facing the wrong way!" or arg1 == "Target needs to be in front of you." then
			mb_HandleFacingWrongWay()
		end
	elseif event == "UNIT_SPELLCAST_SENT" and arg1 == "player" then
		mb_shouldCallPreCastFinishCallback = true
		mb_currentCastTargetUnit = mb_GetUnitForPlayerName(arg4)
	end
end
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("CHAT_MSG_ADDON")
f:RegisterEvent("PLAYER_ENTER_COMBAT")
f:RegisterEvent("PLAYER_LEAVE_COMBAT")
f:RegisterEvent("PARTY_INVITE_REQUEST")
f:RegisterEvent("CONFIRM_SUMMON")
f:RegisterEvent("RESURRECT_REQUEST")
f:RegisterEvent("QUEST_ACCEPT_CONFIRM")
f:RegisterEvent("QUEST_DETAIL")
f:RegisterEvent("GROUP_ROSTER_CHANGED")
f:RegisterEvent("UI_ERROR_MESSAGE")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:SetScript("OnEvent", mb_OnEvent)

mb_hasInitiated = false
mb_classSpecificRunFunction = nil
mb_originalErrorHandler = nil
function mb_InitAsSlave()
	mb_InitShared()
	local classActionSlotOffset = 0
	if mb_GetClass("player") == "WARRIOR" then
		classActionSlotOffset = 72
	end
	mb_CreateMacro("MBReload", "/run ReloadUI()", classActionSlotOffset + 1)
	mb_CreateMacro("MBFree", "/run mb_commanderUnit=nil", classActionSlotOffset + 2)
	SetCVar("autoSelfCast", 0) -- Disable auto self-casting to allow directly casting spells on raid-members
	SetCVar("autoLootDefault", 1) -- Enable autolooting

	mb_originalErrorHandler = geterrorhandler()
	seterrorhandler(mb_ErrorHandler)

	if TI_VersionString ~= nil then -- Turn TurnIn on if it's loaded
		TI_Switch("on")
		TI_status.options[7].state = true
	end
end

function mb_InitAsCommander()
	mb_isCommanding = true
	mb_SendMessage("enable")
	mb_SendMessage("setCommander", UnitName("player"))
	mb_InitShared()
	mb_isEnabled = true
end

function mb_InitShared()
	if mb_hasInitiated then
		return
	end
	mb_hasInitiated = true

	mb_registeredMessageHandlers = {}
	mb_RegisterMessageHandlers()
	mb_UpdateClassOrder()
	mb_InitClass()
	mb_CheckDurability()

	local numSkills = GetNumSkillLines()
	for i = 1, numSkills do
		if GetSkillLineInfo(i) == "Skinning" then
			mb_isSkinner = true
		end
		if GetSkillLineInfo(i) == "Mining" then
			mb_isMiner = true
		end
		if GetSkillLineInfo(i) == "Herbalism" then
			mb_isHerbalist = true
		end
	end
end

function mb_InitClass()
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
		mb_Print("Error, playerClass " .. tostring(playerClass) .. " not supported")
	end
end

mb_classOrder = {}
mb_myClassOrderIndex = nil
function mb_UpdateClassOrder()
	local name = UnitName("player")
	mb_classOrder = {}
	table.insert(mb_classOrder, name)
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if mb_GetClass(unit) == mb_GetClass("player") and UnitIsConnected(unit) then
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
mb_cleaveMode = 0 -- 0 = Single-target, 1 = Cleave, 2 = Full AoE
mb_GCDSpell = nil
mb_isCommanding = false
mb_commanderUnit = nil
-- "none" = Never follows, not allowed to move if out of range of target, free to turn to face the right way
-- "lenient" = Only follow-spams when commander is more than 11 yards away, free to turn or move if out of range of target automatically if within those 11 yards of commander
-- "strict" = Spams follow constantly, not free to turn or move
mb_followMode = "lenient"
mb_isEnabled = false
mb_isAutoAttacking = false
mb_time = GetTime()
mb_shouldStopMovingForwardAt = 0
-- This callback will be called 0.3 seconds before a spell-cast finishes, to let you mb_StopCast() it if you want
mb_preCastFinishCallback = nil
mb_shouldCallPreCastFinishCallback = false
mb_currentCastTargetUnit = nil
mb_IWTDistanceClosingRangeCheckSpell = nil
mb_doAutoRotationAsCommander = false
mb_lastMovementTime = GetTime()
mb_disableAutomaticMovement = false
-- OnUpdate
function mb_OnUpdate()
	if not mb_isEnabled then
		return
	end
	if GetRealmName() ~= "LichKingMBW" then
		return
	end
	if not mb_hasInitiated then
		mb_InitAsSlave()
		return
	end
	mb_time = GetTime()
	mb_LootHandler_OnUpdate()
	mb_RequestDesiredBuffsThrottled()
	mb_FixRaidSetup()
	if mb_IsMoving() then
		mb_lastMovementTime = mb_time
	end
	if mb_isCommanding then
		if mb_doAutoRotationAsCommander then
			if mb_BossModule_PreOnUpdate() then
				return
			end
			mb_classSpecificRunFunction()
		end
		return
	end
	if not mb_disableAutomaticMovement then
		if mb_commanderUnit ~= nil then
			if mb_followMode == "lenient" or mb_IsDrinking() then
				if not CheckInteractDistance(mb_commanderUnit, 2) then
					FollowUnit(mb_commanderUnit)
				end
			elseif mb_followMode == "strict" then
				FollowUnit(mb_commanderUnit)
			end
			if mb_followMode == "lenient" and not mb_IsDrinking() then
				if not UnitAffectingCombat("player") or not mb_IsValidOffensiveUnit("target") then
					FollowUnit(mb_commanderUnit)
				end
			end
		end
		if mb_shouldStopMovingForwardAt ~= 0 and mb_shouldStopMovingForwardAt < mb_time then
			MoveForwardStart()
			MoveForwardStop()
			mb_shouldStopMovingForwardAt = 0
		end
		if mb_IWTDistanceClosingRangeCheckSpell ~= nil and mb_IsValidOffensiveUnit("target") and (mb_commanderUnit == nil or mb_followMode == "none" or CheckInteractDistance(mb_commanderUnit, 2)) then
			if not mb_IsSpellInRange(mb_IWTDistanceClosingRangeCheckSpell, "target") then
				SetCVar("autoInteract", 1)
				InteractUnit("target")
				SetCVar("autoInteract", 0)
			elseif mb_IsMoving() then
				mb_shouldStopMovingForwardAt = mb_time
			end
		end
	end
	if mb_preCastFinishCallback ~= nil and mb_shouldCallPreCastFinishCallback then
		local spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, interrupt = UnitCastingInfo("player")
		if spell ~= nil then
			if endTime / 1000 < mb_time + 0.3 then
				mb_shouldCallPreCastFinishCallback = false
				mb_preCastFinishCallback(spell, mb_currentCastTargetUnit)
			end
		end
	end
	if mb_HandleQueuedAcceptedRequest() then
		return
	end
	if mb_BossModule_PreOnUpdate() then
		return
	end
	mb_classSpecificRunFunction()
	if not mb_isCommanding then
		mb_HarvestCreature()
	end
end

function mb_HandleCommand(msg)
    -- remoteExecute
	local matches, remainingString = mb_StringStartsWith(msg, "re")
	if matches then
		mb_SendMessage("remoteExecute ", remainingString)
		return true
	end

	matches, remainingString = mb_StringStartsWith(msg, "lc")
	if matches then
		mb_SayRaid("----------------------------------")
		mb_SayRaid("Loot Council started for: " .. remainingString)
		mb_SendMessage("lc ", remainingString)
		return true
	end

	matches, remainingString = mb_StringStartsWith(msg, "bm")
	if matches then
		mb_BossModule_LoadModule(remainingString)
		mb_SendMessage("remoteExecute ", "mb_BossModule_LoadModule(\"" .. remainingString .. "\")")
		return true
	end

    matches, remainingString = mb_StringStartsWith(msg, "InitAsCommander")
    if matches then
        mb_InitAsCommander()
        return true
    end
	return false
end

function mb_SendMessage(messageType, message)
	SendAddonMessage("MB", messageType .. " " .. tostring(message), "RAID")
end

function mb_SendExclusiveRequest(requestType, message)
	local requestId = tostring(math.random(9999999))
	mb_SendMessage("exclusiveRequest", requestId .. ":" .. requestType .. ":" .. message)
end

mb_registeredMessageHandlers = {}
function mb_RegisterMessageHandler(messageType, handlerFunc)
	mb_registeredMessageHandlers[messageType] = handlerFunc
end

function mb_ShouldHandleMessageFromSelf(messageType)
	if string.sub(messageType, 1, 5) == "buff:" then
		return true
	end
	if string.sub(messageType, 1, 2) == "lc" then
		return true
	end
	return false
end

function mb_HandleIncomingMessage(mbCom)
	local messageType = string.sub(mbCom.message, 1, string.find(mbCom.message, " ") - 1)
	local message = string.sub(mbCom.message, string.find(mbCom.message, " ") + 1)

	if messageType == "acceptExclusiveRequest" then
		local requestId = tonumber(message)
		if mbCom.from == UnitName("player") then
			table.insert(mb_queuedAcceptedRequests, mb_acceptedPendingExclusiveRequests[requestId])
		end
		mb_acceptedPendingExclusiveRequests[requestId] = nil
	end
	
	if mbCom.from == UnitName("player") and not mb_ShouldHandleMessageFromSelf(messageType) then
		return
	end

	if messageType == "exclusiveRequest" then
		mb_HandleIncomingExclusiveRequest(message, mbCom.from)
		return
	end
		
	if messageType == "enable" and mb_IsTrustedCharacter(mbCom.from) then
		mb_isEnabled = true
		mb_InitAsSlave()
		return
	end
	
	if not mb_isEnabled then
		return
	end
	
	if mb_registeredMessageHandlers[messageType] ~= nil then
		mb_registeredMessageHandlers[messageType](message, mbCom.from)
	end
end

mb_queuedAcceptedRequests = {}
mb_executorAttempts = 0
function mb_HandleQueuedAcceptedRequest()
	local request = mb_queuedAcceptedRequests[1]
	if request ~= nil then
		if mb_registeredExclusiveRequestHandlers[request.type].executor(request.message, request.from) then
			table.remove(mb_queuedAcceptedRequests, 1)
			mb_executorAttempts = 0
		else
			mb_executorAttempts = mb_executorAttempts + 1
			if mb_executorAttempts > 25 then
				mb_executorAttempts = 0
				mb_SayRaid("I'm stuck trying to fulfil a request of type: " .. request.type)
				table.remove(mb_queuedAcceptedRequests, 1)
			end
		end
		return true
	end
	return false
end

mb_registeredExclusiveRequestHandlers = {}
function mb_RegisterExclusiveRequestHandler(requestType, acceptorFunc, executorFunc)
	mb_registeredExclusiveRequestHandlers[requestType] = {}
	mb_registeredExclusiveRequestHandlers[requestType].acceptor = acceptorFunc
	mb_registeredExclusiveRequestHandlers[requestType].executor = executorFunc
end

mb_acceptedPendingExclusiveRequests = {}
function mb_HandleIncomingExclusiveRequest(message, from)
	local strings = mb_SplitString(message, ":")
	local requestType = strings[2]
	if mb_registeredExclusiveRequestHandlers[requestType] ~= nil then
		local requestId = tonumber(strings[1])
		local message = strings[3]
		if mb_registeredExclusiveRequestHandlers[requestType].acceptor(message, from) then
			local exclusiveRequest = {}
			exclusiveRequest.type = requestType
			exclusiveRequest.message = message
			exclusiveRequest.from = from
			mb_acceptedPendingExclusiveRequests[requestId] = exclusiveRequest
			mb_SendMessage("acceptExclusiveRequest", requestId)
		end
	end
end

mb_desiredBuffs = {}
function mb_RegisterDesiredBuff(buff)
	table.insert(mb_desiredBuffs, buff)
end

mb_lastBuffRequest = GetTime()
function mb_RequestDesiredBuffsThrottled()
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
			mb_SendMessage(buff.requestType)
		end
	end
end

function mb_HandleFacingWrongWay()
	if not mb_isEnabled or mb_isCommanding then
		return
	end
	if mb_followMode == "strict" then
		return
	end
	SetCVar("autoInteract", 1)
	InteractUnit("target")
	SetCVar("autoInteract", 0)
	mb_shouldStopMovingForwardAt = mb_time
end

function mb_EnableIWTDistanceClosing(rangeCheckSpell)
	mb_IWTDistanceClosingRangeCheckSpell = rangeCheckSpell
end

function mb_HandleTooFarAway()
	if not mb_isEnabled or mb_isCommanding or mb_followMode == "none" or mb_IWTDistanceClosingRangeCheckSpell~= nil then
		return
	end
	if mb_followMode == "lenient" then
		SetCVar("autoInteract", 1)
		InteractUnit("target")
		SetCVar("autoInteract", 0)
		mb_shouldStopMovingForwardAt = mb_time + 0.5
	end
end

mb_lastError = 0
function mb_ErrorHandler(msg)
	if mb_lastError + 10 > mb_time then
		mb_originalErrorHandler(msg)
		return
	end
	mb_lastError = mb_time
	mb_SayRaid("I received lua-error: " .. msg .. ". Call stack:")
	for w in string.gmatch(debugstack(2, 20, 20), "[^\n]+") do
		mb_SayRaid(string.gsub(w, "Interface\\AddOns\\", ""))
	end
	mb_SayRaid("-------------------------------------")
	mb_originalErrorHandler(msg)
end

mb_fixRaidSetupName = nil
mb_fixRaidSetupLastInvite = 0
function mb_FixRaidSetup()
	if mb_fixRaidSetupName == nil then
		return
	end
	local currentMembers = mb_GetNumPartyOrRaidMembers()
	if not UnitInRaid("player") and currentMembers > 0 then
		ConvertToRaid()
		return
	end

	local setup = mb_config.raidLayout[mb_fixRaidSetupName]
	local didInvite = false
	if mb_fixRaidSetupLastInvite + 10 > mb_time then
		return
	end
	for groupId, groupMembers in pairs(setup) do
		for memberId, memberName in pairs(groupMembers) do
			if mb_GetUnitForPlayerName(memberName) == nil then
				mb_fixRaidSetupLastInvite = mb_time
				InviteUnit(memberName)
				didInvite = true
			end
		end
	end
	if didInvite then
		return
	end

	-- TODO add fixing of subgroups
	--for raidIndex = 1, currentMembers do
	--	local name, _, subgroup = GetRaidRosterInfo(raidIndex);
	--	if not mb_TableContains(groupMembers, name) and subgroup ~= groupId then
	--		SwapRaidSubgroup(raidIndex)
	--	end
	--end

	SetLootMethod("freeforall")
	mb_Print("Finished fixing raid setup for " .. mb_fixRaidSetupName)
	mb_fixRaidSetupName = nil
end

mb_lastHarvestCheck = 0
mb_isSkinner = false
mb_isMiner = false
mb_isHerbalist = false
function mb_HarvestCreature()
	if not mb_isMiner and not mb_isSkinner and not mb_isHerbalist then
		return
	end
	if mb_lastHarvestCheck + 1 > mb_time then
		return
	end
	mb_lastHarvestCheck = mb_time
	if UnitExists("target") and UnitIsDead("target") then
		if mb_isSkinner then
			CastSpellByName("Skinning")
		elseif mb_isMiner then
			CastSpellByName("Mining")
		elseif mb_isHerbalist then
			CastSpellByName("Herbalism")
		end
	end
end




