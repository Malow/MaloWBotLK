function mb_GetClass(unit)
	local _, class = UnitClass(unit)
	return class
end

function mb_GetNumPartyOrRaidMembers()
	if UnitInRaid("player") then
		return GetNumRaidMembers()
	else
		return GetNumPartyMembers()
	end
	return 0
end

function mb_GetNumOnlinePartyOrRaidMembers()
	local members = mb_GetNumPartyOrRaidMembers()
	local count = members
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if not UnitIsConnected(unit) then
			count = count - 1
		end
	end
	return count
end

-- Returns true if there's more than 20 online people in the raid
function mb_Is25ManRaid()
	return mb_GetNumOnlinePartyOrRaidMembers() > 20
end

-- Returns the unit that has specified raidIndex
function mb_GetUnitFromPartyOrRaidIndex(index)
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
function mb_GetUnitForPlayerName(playerName)
	if UnitName("player") == playerName then
		return "player"
	end
	local members = mb_GetNumPartyOrRaidMembers()
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if UnitName(unit) == playerName then
			return unit
		end
	end
	return nil
end

-- Returns a bool, and the substring of the remaining string
function mb_StringStartsWith(fullString, startString)
	if string.sub(fullString, 1, string.len(startString)) == startString then
		return true, string.sub(fullString, string.len(startString) + 2)
	end
	return false, nil
end

-- Prints message in raid-chat
function mb_SayRaid(message)
	SendChatMessage(message, "RAID")
end

function mb_CreateMacro(name, body, actionSlot)
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

function mb_IsValidOffensiveUnit(unit)
	if not UnitExists(unit) then
		return false
	end
	if UnitIsDeadOrGhost(unit) then
		return false
	end
	if not UnitCanAttack("player", unit) == 1 then
		return false
	end
	if not UnitAffectingCombat(unit) then
		return false
	end
	return true
end

function mb_GetMissingHealth(unit)
	return UnitHealthMax(unit) - UnitHealth(unit)
end

-- Runs IsSpellInRange and converts to bool
function mb_IsSpellInRange(spell, unit)
	return IsSpellInRange(spell, unit) == 1
end

-- Checks if target exists, is friendly and if it's dead or ghost, and if the spell is in range if provided
function mb_IsUnitValidFriendlyTarget(unit, spell)
    if UnitIsDeadOrGhost(unit) then
        return false
    end
	if UnitCanAttack("player", unit) == 1 then
		return false
	end
	if spell ~= nil and not mb_IsSpellInRange(spell, unit) then
		return false
	end
	if UnitBuff(unit, "Spirit of Redemption") then
		return false
	end
	return true
end

-- Scans through the raid or party for the unit missing the most health. If "spell" is provided it will make sure the spell is within range of the target
function mb_GetMostDamagedFriendly(spell)
    local healTarget = 0
    local missingHealthOfTarget = mb_GetMissingHealth("player")
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
        local missingHealth = mb_GetMissingHealth(unit)
        if missingHealth > missingHealthOfTarget then
            if mb_IsUnitValidFriendlyTarget(unit, spell) then
				if mb_Paladin_Holy_beaconUnit == nil or mb_Paladin_Holy_beaconUnit ~= unit then -- Used for Holy paladins to make them never heal their beacon
					missingHealthOfTarget = missingHealth
					healTarget = i
				end
            end
        end
    end
	if UnitExists("focus") then
		local missingHealth = mb_GetMissingHealth("focus")
		if missingHealth > missingHealthOfTarget and mb_IsUnitValidFriendlyTarget("focus", spell) then
			return "focus", missingHealth
		end
	end
    if healTarget == 0 then
        return "player", missingHealthOfTarget
    else
        return mb_GetUnitFromPartyOrRaidIndex(healTarget), missingHealthOfTarget
    end
end

function mb_UnitHealthPercentage(unit)
	return (UnitHealth(unit) * 100) / UnitHealthMax(unit)
end

function mb_UnitPowerPercentage(unit)
	return (UnitPower(unit) * 100) / UnitPowerMax(unit)
end

-- Unit is optional, if provided it will check that the spell can be cast on the unit (that it's a valid target and is in range)
function mb_IsUsableSpell(spell, unit)
	local usable, nomana = IsUsableSpell(spell)
	if unit == nil then
		return usable == 1
	end
	if usable == nil then
		return false
	end
	if UnitCanAttack("player", unit) == 1 then
		return mb_IsValidOffensiveUnit(unit) and mb_IsSpellInRange(spell, unit)
	else
		return mb_IsUnitValidFriendlyTarget(unit, spell)
	end
end

-- Checks if there's no cooldown and if the spell use useable (have mana to cast it), and that if we're moving that it doesn't have a cast time
-- Unit is optional, if provided it will check that the spell can be cast on the unit (that it's a valid target and is in range)
function mb_CanCastSpell(spell, unit)
	if GetSpellCooldown(spell) ~= 0 then
		return false
	end
	if mb_IsMoving() then
		local name, rank, icon, cost, isFunnel, powerType, castTime, minRange, maxRange	= GetSpellInfo(spell)
		if castTime > 0 then
			return false
		end
	end
	return mb_IsUsableSpell(spell, unit)
end

-- Returns true on success
function mb_CastSpellOnTarget(spell)
	if not mb_CanCastSpell(spell, "target") then
		return false
	end
	CastSpellByName(spell)
	return true
end

-- Returns true on success
function mb_CastSpellWithoutTarget(spell)
	if not mb_CanCastSpell(spell) then
		return false
	end
	CastSpellByName(spell)
	return true
end

-- Casts directly without changing your current target unless required to do so. Returns true on success
function mb_CastSpellOnFriendly(unit, spell)
	if not mb_CanCastSpell(spell, unit) then
		return false
	end
	CastSpellByName(spell, unit)
	return true
end

function mb_CastSpellOnSelf(spell)
    if not mb_CanCastSpell(spell) then
        return false
    end
    CastSpellByName(spell, "player")
    return true
end

-- Returns true/false depending on if the unit is capable of resurrecting other players
function mb_IsUnitResurrector(unit)
	local unitClass = mb_GetClass(unit)
	return unitClass == "PALADIN" or unitClass == "PRIEST" or unitClass == "SHAMAN" or unitClass == "DRUID"
end

-- Checks if any friendly unit is resurrecting another raid-member
function mb_IsSomeoneResurrectingUnit(resurrectUnit)
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if UnitName(unit .. "target") == UnitName(resurrectUnit) then
			return true
		end
	end
	return false
end

function mb_GetResurrectionTarget(resurrectionSpell)
	local members = mb_GetNumPartyOrRaidMembers()
	local resUnit = nil
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if UnitIsDead(unit) and not mb_IsSomeoneResurrectingUnit(unit) and mb_IsSpellInRange(resurrectionSpell, unit) then
			if mb_IsUnitResurrector(unit) then
				return unit
			end
			resUnit = unit
		end
	end
	return resUnit
end

-- Will try to resurrect a dead raid member
function mb_ResurrectRaid(resurrectionSpell)
	if UnitIsDead("target") and UnitCastingInfo("player") == resurrectionSpell then
		return true
	end

	if UnitAffectingCombat("player") or mb_IsDrinking() then
		return false
	end
	if not mb_CanCastSpell(resurrectionSpell) then
		return false
	end
	local resUnit = mb_GetResurrectionTarget(resurrectionSpell)
	if resUnit == nil then
		return false
	end
	TargetUnit(resUnit)
	CastSpellByName(resurrectionSpell)
	mb_SayRaid("I'm resurrecting " .. UnitName(resUnit))
	return true
end

-- Checks if unit has a buff from the spell specified that specifically you have cast
function mb_UnitHasMyBuff(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "PLAYER|HELPFUL")
	return name ~= nil
end

-- Returns number of debuff stacks
function mb_GetDebuffStackCount(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "HARMFUL")
	if count == nil then
		return 0
	end
	return count
end

-- Returns the time remaining of a debuff, 0 if it doesn't exist
function mb_GetDebuffTimeRemaining(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "HARMFUL")
	if name == nil then
		return 0
	end
	return expirationTime - mb_time
end

-- Returns the time remaining of a debuff that you have cast, 0 if it doesn't exist
function mb_GetMyDebuffTimeRemaining(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "PLAYER|HARMFUL")
	if name == nil then
		return 0
	end
	return expirationTime - mb_time
end

-- Returns the time remaining of a buff
function mb_GetBuffTimeRemaining(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "HELPFUL")
	if name == nil then
		return 0
	end
	return expirationTime - mb_time
end

-- Returns number of buff stacks
function mb_GetBuffStackCount(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "HELPFUL")
	if count == nil then
		return 0
	end
	return count
end

--
function mb_CleanseRaid(spell, debuffType1, debuffType2, debuffType3)
	for i = 1, mb_GetNumPartyOrRaidMembers() do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if mb_UnitHasDebuffOfType(unit, debuffType1, debuffType2, debuffType3) and mb_IsUnitValidFriendlyTarget(unit, spell) then
			return mb_CastSpellOnFriendly(unit, spell)
		end
	end
	return false
end

--
function mb_UnitHasDebuffOfType(unit, debuffType1, debuffType2, debuffType3)
	for i = 1, 40 do
		local name, _, _, _, type = UnitDebuff(unit, i)
		if name == nil then
			return false
		end
		if debuffType1 ~= nil and debuffType1 == type then
			return true
		end
		if debuffType2 ~= nil and debuffType2 == type then
			return true
		end
		if debuffType3 ~= nil and debuffType3 == type then
			return true
		end
	end
	return false
end

-- Returns true if you're on Global Cooldown
function mb_IsOnGCD()
	if GetSpellCooldown(mb_GCDSpell) ~= 0 then
		return true
	end
	return false
end

-- Returns true if you're not on GCD and not currently casting
function mb_IsReadyForNewCast()
	if mb_IsOnGCD() then
		return false
	end
	local spell, rank, displayName, icon, startTime, endTime, isTradeSkill, castID, interrupt = UnitCastingInfo("player")
	if spell ~= nil then
		return false
	end
	return true
end

-- Returns the name of your spec
mb_cache_specName = nil
function mb_GetMySpecName()
	if mb_cache_specName ~= nil then
		return mb_cache_specName
	end
	local name, _, points = GetTalentTabInfo(1)
	for i = 2, 3 do
		local n, _, p = GetTalentTabInfo(i)
		if p > points then
			points = p
			name = n
		end
	end
	mb_cache_specName = name
	return name
end

mb_forceBlockDpsCooldowns = false
-- Returns true if using CDs is a good idea
function mb_ShouldUseDpsCooldowns(rangeCheckSpell)
	if mb_forceBlockDpsCooldowns then
		return false
	end
	if not mb_IsValidOffensiveUnit("target") then
		return false
	end
	if not mb_IsSpellInRange(rangeCheckSpell, "target") then
		return false
	end
	local members = mb_GetNumPartyOrRaidMembers()
	if UnitHealthMax("target") > UnitHealthMax("player") * members * 2 then
		return true
	end
	if UnitHealth("target") > UnitHealthMax("player") * members then
		return true
	end
	return false
end

-- Returns a spell-id for a spell-name
function mb_GetSpellIdForName(spellName)
	local link = GetSpellLink(spellName)
	link = string.sub(link, string.find(link, "spell:") + 6)
	local spellId = string.sub(link, 1, string.find(link, "|") - 1)
	return tonumber(spellId)
end

function mb_SetPetAutocast(spell, desiredState)
	local _, autoCastState = GetSpellAutocast(spell, "pet")
	autoCastState = autoCastState == 1
	if autoCastState == desiredState then
		return
	end
	ToggleSpellAutocast(spell, "pet")
end

function mb_CheckReagentAmount(itemName, desiredItemCount)
	local currentItemCount = mb_GetItemCount(itemName)
	if currentItemCount < desiredItemCount then
		mb_SayRaid("I'm low on " .. itemName .. ". " .. tostring(currentItemCount) .. "/" .. tostring(desiredItemCount))
	end
end

-- Returns the count of item with specified name
function mb_GetItemCount(itemName)
	local totalItemCount = 0
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink ~= nil then
				local name = GetItemInfo(itemLink)
				if name == itemName then
					local _, itemCount = GetContainerItemInfo(bag, slot);
					totalItemCount = totalItemCount + itemCount
				end
			end
		end
	end
	return totalItemCount
end

-- Makes the character say in raid if durability of any item is lower than 30%
function mb_CheckDurability()
	local lowestDurability = 1.0
	for i = 1, 18 do
		local current, maximum = GetInventoryItemDurability(i)
		if current ~= nil and maximum ~= nil then
			lowestDurability = min(lowestDurability, current / maximum)
		end
	end

	if lowestDurability < 0.3 then
		mb_SayRaid("I'm low on durability and could use a repair, my lowest item is at " .. tostring(lowestDurability * 100) .. "%")
	end
end

-- Returns true/false depending on if the item is in the table
function mb_TableContains(table, item)
	for _, v in pairs(table) do
		if v == item then
			return true
		end
	end
	return false
end

-- Finds the most damaged member in the raid and casts the spell on that target as long as it doesn't over-heal
function mb_RaidHeal(spell, acceptedOverheal)
	if acceptedOverheal == nil then
		acceptedOverheal = 1
	end
	local healUnit, missingHealth = mb_GetMostDamagedFriendly(spell)
	if missingHealth * (acceptedOverheal) > mb_GetSpellEffect(spell) then
		return mb_CastSpellOnFriendly(healUnit, spell)
	end
	return false
end

-- Tries to acquire an offensive target. Will assist the commander unit if it exists.
-- Returns true/false depending on if a valid offensive target was acquired.
function mb_AcquireOffensiveTarget()
	if mb_commanderUnit == nil then
		return mb_IsValidOffensiveUnit("target")
	end
	if not UnitExists(mb_commanderUnit .. "target") then
		ClearTarget()
		return false
	end
	AssistUnit(mb_commanderUnit)
	return mb_IsValidOffensiveUnit("target")
end

-- Checks whether it's a good time to buff, returns true/false
function mb_ShouldBuff()
	if UnitAffectingCombat("player") or mb_IsDrinking() or mb_UnitPowerPercentage("player") < 30 then
		return false
	end
	local members = mb_GetNumPartyOrRaidMembers()
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if UnitIsConnected(unit) then
			if not mb_IsUnitValidFriendlyTarget(unit) or not CheckInteractDistance(unit, 4) then
				return false
			end
		end
	end
	return true
end

-- returns the bag and slot indexes for where an item is located
function mb_GetItemLocation(itemName)
	for bag = 0, 4 do
		for slot = 1, GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			if itemLink ~= nil then
				local name = GetItemInfo(itemLink)
				if itemName == name then
					return bag, slot
				end
			end
		end
	end
	return nil
end

function mb_HasItem(itemName)
	return GetItemCount(itemName) ~= 0
end

-- tries to use an item in the bags, returns true/false depending on if successful
function mb_UseItem(itemName)
	if GetItemCount(itemName) == 0 then
		return false
	end
	UseItemByName(itemName)
	return true
end

function mb_IsDrinking()
	return UnitBuff("player", "Drink") ~= nil
end

-- Starts drinking if possible and if good to do so. Returns true if drinking
mb_lastWaterWarningTime = 0
function mb_Drink(force)
	if UnitAffectingCombat("player") or UnitIsDeadOrGhost("player") then
		return false
	end
    if mb_IsDrinking() then
        if mb_UnitPowerPercentage("player") < 99 then
            return true
        else
            SitStandOrDescendStart()
            return false
        end
    end
	local waterName = nil
	for _, water in pairs(mb_config.waters) do
		if mb_HasItem(water) then
			waterName = water
			break
		end
	end
	if waterName == nil then
		if mb_lastWaterWarningTime + 60 < mb_time then
			mb_SayRaid("I don't have any water")
			mb_lastWaterWarningTime = mb_time
		end
		return false
	end

	if force then
		return mb_UseItem(waterName)
	end
	if mb_UnitPowerPercentage("player") > 60 then
		return false
	end
	if mb_lastMovementTime + 2 > mb_time then
		return false
	end
	--if mb_isFollowing and mb_followMode == "lenient" then
	--	mb_BreakFollow()
	--	return true
	--end
	return mb_UseItem(waterName)
end

function mb_StopCast()
	SpellStopCasting()
end

function mb_SplitString(str, char)
    local strings = {}
    while string.find(str, char) do
        table.insert(strings, string.sub(str, 1, string.find(str, char) - 1))
        str = string.sub(str, string.find(str, char) + 1)
    end
    table.insert(strings, str)
    return strings
end

function mb_GetRemainingSpellCooldown(spell)
	local start, duration, enabled = GetSpellCooldown(spell)
	if duration == 0 then
		return 0
	end
	return (start + duration) - mb_time
end

-- Uses trinkets and engineering gloves
mb_itemCooldownSlots = {}
table.insert(mb_itemCooldownSlots, 10) -- Gloves (Engineering enchant)
table.insert(mb_itemCooldownSlots, 13) -- Trinket 1
table.insert(mb_itemCooldownSlots, 14) -- Trinket 2
function mb_UseItemCooldowns()
	for _, slot in pairs(mb_itemCooldownSlots) do
		local start, duration, enable = GetInventoryItemCooldown("player", slot)
		if enable == 1 and start == 0 then
			UseInventoryItem(slot)
			return true
		end
	end
	return false
end

function mb_IsMoving()
	return GetUnitSpeed("player") ~= 0
end

function mb_SpecNotSupported(msg)
	if not mb_isCommanding then
		mb_SayRaid(msg)
	end
end

function mb_IsTank()
	return mb_GetMySpecName() == "Protection" or mb_GetMySpecName() == "Feral Combat" or mb_GetMySpecName() == "Frost"
end

function mb_IsHealer()
    return mb_GetMySpecName() == "Holy" or mb_GetMySpecName() == "Restoration" or mb_GetMySpecName() == "Discipline"
end

function mb_IsUnitStunned(unit)
	if mb_GetBuffTimeRemaining(unit, "Hammer of Justice") > 0 then
		return true
	end
	if mb_GetBuffTimeRemaining(unit, "Holy Wrath") > 0 then
		return true
	end
	return false
end

function mb_IsUnitSlowed(unit)
	if mb_GetBuffTimeRemaining(unit, "Frost Shock") > 0 then
		return true
	end
	if mb_GetBuffTimeRemaining(unit, "Earthbind") > 0 then
		return true
	end
	if mb_GetBuffTimeRemaining(unit, "Hamstring") > 0 then
		return true
	end
	return false
end

function mb_GetMapPosition(unit)
	local x, y = GetPlayerMapPosition(unit)
	if x == 0 and y == 0 then
		SetMapToCurrentZone()
		x, y = GetPlayerMapPosition(unit)
	end
	return x, y
end

mb_GoToPosition_hasReset = true
mb_GoToPosition_hasReachedDestination = false
-- Returns true as long as the character is busy running towards the place, returns false once it's there
function mb_GoToPosition_Update(x, y, acceptedDistance)
    local curX, curY = mb_GetMapPosition("player")
    local dX, dY = x - curX, y - curY
    local distance = math.sqrt(dX * dX + dY * dY)
    if mb_GoToPosition_hasReachedDestination and distance < acceptedDistance * 1.5 then -- Allow 50% leeway if you reached the destination previously.
        return false
    end
    if distance < acceptedDistance then
        TurnLeftStop()
        TurnRightStop()
        MoveForwardStop()
        mb_GoToPosition_hasReachedDestination = true
        mb_GoToPosition_hasReset = true
		mb_disableAutomaticMovement = false
        return false
    end
    mb_GoToPosition_hasReachedDestination = false
    mb_GoToPosition_hasReset = false
	mb_disableAutomaticMovement = true

    local currentFacing = GetPlayerFacing()
    local desiredFacing = math.atan2(dX, dY) + math.pi
    local diff = desiredFacing - currentFacing
    if diff > 0 then
        if (currentFacing + 2 * math.pi) - desiredFacing < diff then
            diff = (currentFacing + 2 * math.pi) - desiredFacing
            TurnLeftStop()
            TurnRightStart()
        else
            TurnRightStop()
            TurnLeftStart()
        end
    else
        if (currentFacing - 2 * math.pi) - desiredFacing > diff then
            diff = (currentFacing - 2 * math.pi) - desiredFacing
            TurnRightStop()
            TurnLeftStart()
        else
            TurnLeftStop()
            TurnRightStart()
        end
    end
    if math.abs(diff) < math.pi / 2 then
        MoveForwardStart()
    else
        MoveForwardStop()
    end
    return true
end

-- Stops movement and camera turning, if the condition for GoToPosition changes before it has reached it destination characters can get stuck moving / turning otherwise.
function mb_GoToPosition_Reset()
    if mb_GoToPosition_hasReset then
        return
    end
    mb_GoToPosition_hasReset = true
	mb_disableAutomaticMovement = false
    TurnLeftStop()
    TurnRightStop()
    MoveForwardStop()
end

function mb_FollowUnit(unit)
	mb_isFollowing = true
	FollowUnit(unit)
end

function mb_BreakFollow()
	mb_isFollowing = false
	TurnLeftStart()
	TurnLeftStop()
end

mb_crowdControlSpells = {
	"Fear",
	"Polymorph",
	"Death Coil",
	"Hammer of Justice",
	"Hex"
}
function mb_CrowdControl(unit)
	for _, ccSpell in pairs(mb_crowdControlSpells) do
		if mb_GetDebuffTimeRemaining(unit, ccSpell) > 0 then
			if UnitCastingInfo("player") ~= nil and mb_currentCastTargetUnit == unit then
				mb_StopCast()
			end
			return false
		end
	end

	for _, ccSpell in pairs(mb_crowdControlSpells) do
		if mb_CanCastSpell(ccSpell, unit) then
			CastSpellByName(ccSpell, unit)
			return true
		end
	end
	return false
end









