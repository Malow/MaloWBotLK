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
	local members = mb_GetNumPartyOrRaidMembers()
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
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
function mb_StringStartsWith(fullString, startString)
	if string.sub(fullString, 1, string.len(startString)) == startString then
		return true, string.sub(fullString, string.len(startString) + 2)
	end
	return false, nil
end

-- Prints message in raid-chat
function mb_SayRaid(message)
	SendChatMessage(message, "RAID", "Common")
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

function mb_HasValidOffensiveTarget()
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
	if not UnitAffectingCombat("target") then
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

-- Checks if target exists, is visible, is friendly and if it's dead or ghost, and if the spell is in range if provided
function mb_IsUnitValidFriendlyTarget(unit, spell)
    if UnitIsDeadOrGhost(unit) then
        return false
    end
	if not UnitIsFriend(unit, "player") then
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
				if spell == nil or mb_IsSpellInRange(spell, unit) then
					missingHealthOfTarget = missingHealth
					healTarget = i
				end
            end
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

-- Checks if there's no cooldown and if the spell use useable (have mana to cast it)
function mb_CanCastSpell(spell)
	if GetSpellCooldown(spell) ~= 0 then
		return false
	end
	local usable, nomana = IsUsableSpell(spell)
	return usable == 1
end

-- Returns true on success
function mb_CastSpellOnTarget(spell)
	if not mb_CanCastSpell(spell) then
		return false
	end
	if not mb_IsSpellInRange(spell, "target") then
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
	if not mb_CanCastSpell(spell) then
		return false
	end
	if not mb_IsUnitValidFriendlyTarget(unit, spell) then
		return false
	end
	-- If we're commanding we want self auto-cast on, which means we always need to target units to cast on them.
	if mb_isCommanding or UnitIsFriend("target", "player") then
		TargetUnit(unit)
	end
	CastSpellByName(spell)
	if SpellIsTargeting() then
		SpellTargetUnit(unit)
	end
	return true
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

-- Will try to resurrect a dead raid member
function mb_ResurrectRaid(resurrectionSpell)
	if UnitIsDead("target") and UnitCastingInfo("player") == resurrectionSpell then
		return true
	end
	
	if UnitAffectingCombat("player") then
		return false
	end
	if not mb_CanCastSpell(resurrectionSpell) then
		return false
	end
    local members = mb_GetNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if UnitIsDead(unit) and not mb_IsSomeoneResurrectingUnit(unit) and mb_IsSpellInRange(resurrectionSpell, unit) then
			TargetUnit(unit)
			CastSpellByName(resurrectionSpell)
			mb_SayRaid("I'm resurrecting " .. UnitName(unit))
			return true
		end
	end
end

-- Checks if your target has a debuff from the spell specified that specifically you have cast
function mb_TargetHasMyDebuff(spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("target", spell, nil, "PLAYER|HARMFUL")
	return name ~= nil
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

-- Returns the time remaining of a debuff
function mb_GetDebuffTimeRemaining(unit, spell)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spell, nil, "HARMFUL")
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

-- Returns the name of your spec
function mb_GetMySpecName()
	local name, _, points = GetTalentTabInfo(1)
	for i = 2, 3 do
		local n, _, p = GetTalentTabInfo(i)
		if p > points then
			points = p
			name = n
		end
	end
	return name
end

-- Returns true if using CDs is a good idea
function mb_ShouldUseDpsCooldowns()
	if not mb_HasValidOffensiveTarget() then
		return false
	end
	local members = mb_GetNumPartyOrRaidMembers()
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









