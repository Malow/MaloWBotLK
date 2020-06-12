function mb_GetClass(unit)
	local _, class = UnitClass(unit)
	return class
end

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

-- Runs IsSpellInRange and converts to bool
function mb_isSpellInRange(spell, unit)
	return IsSpellInRange(spell, unit) == 1
end

-- Checks if target exists, is visible, is friendly and if it's dead or ghost, and if the spell is in range if provided
function mb_isUnitValidFriendlyTarget(unit, spell)
    if UnitIsDeadOrGhost(unit) then
        return false
    end
	if not UnitIsFriend(unit, "player") then
		return false
	end
	if spell ~= nil and not mb_isSpellInRange(spell, unit) then
		return false
	end
	if UnitBuff(unit, "Spirit of Redemption") then
		return false
	end
	return true
end

-- Scans through the raid or party for the unit missing the most health. If "spell" is provided it will make sure the spell is within range of the target
function mb_getMostDamagedFriendly(spell)
    local healTarget = 0
    local missingHealthOfTarget = mb_getMissingHealth("player")
    local members = mb_getNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_getUnitFromPartyOrRaidIndex(i)
        local missingHealth = mb_getMissingHealth(unit)
        if missingHealth > missingHealthOfTarget then
            if mb_isUnitValidFriendlyTarget(unit, spell) then
				if spell == nil or mb_isSpellInRange(spell, unit) then
					missingHealthOfTarget = missingHealth
					healTarget = i
				end
            end
        end
    end
    if healTarget == 0 then
        return "player", missingHealthOfTarget
    else
        return mb_getUnitFromPartyOrRaidIndex(healTarget), missingHealthOfTarget
    end
end

function mb_unitHealthPercentage(unit)
	return (UnitHealth(unit) * 100) / UnitHealthMax(unit)
end

-- Checks if there's no cooldown and if the spell use useable (have mana to cast it)
function mb_canCastSpell(spell)
	if GetSpellCooldown(spell) ~= 0 then
		return false
	end
	local usable, nomana = IsUsableSpell(spell)
	return usable == 1
end

-- Returns true on success
function mb_castSpellOnTarget(spell)
	if not mb_canCastSpell(spell) then
		return false
	end
	if not mb_isSpellInRange(spell, "target") then
		return false
	end
	CastSpellByName(spell)
	return true
end

-- Returns true on success
function mb_castSpellOnSelf(spell)
	if not mb_canCastSpell(spell) then
		return false
	end
	CastSpellByName(spell)
	return true
end

-- Casts directly without changing your current target unless required to do so. Returns true on success
function mb_castSpellOnFriendly(unit, spell)
	if not mb_isSpellInRange(spell, unit) then
		return false
	end
	if UnitIsFriend("target", "player") then
		TargetUnit(unit)
	end
	CastSpellByName(spell)
	if SpellIsTargeting() then
		SpellTargetUnit(unit)
	end
	return true
end

-- Checks if any friendly unit is resurrecting another raid-member
function mb_isSomeoneResurrectingUnit(resurrectUnit)
    local members = mb_getNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_getUnitFromPartyOrRaidIndex(i)
		if UnitName(unit .. "target") == UnitName(resurrectUnit) then
			return true
		end
	end
	return false
end

-- Will try to resurrect a dead raid member
function mb_resurrectRaid(resurrectionSpell)
	if UnitIsDead("target") and UnitCastingInfo("player") == resurrectionSpell then
		return true
	end
	
	if UnitAffectingCombat("player") then
		return false
	end
	if not mb_canCastSpell(resurrectionSpell) then
		return false
	end
    local members = mb_getNumPartyOrRaidMembers()
    for i = 1, members do
        local unit = mb_getUnitFromPartyOrRaidIndex(i)
		if UnitIsDead(unit) and not mb_isSomeoneResurrectingUnit(unit) and mb_isSpellInRange(resurrectionSpell, unit) then
			TargetUnit(unit)
			CastSpellByName(resurrectionSpell)
			mb_sayRaid("I'm resurrecting " .. UnitName(unit))
			return true
		end
	end
end

-- Checks if your target has a debuff from the spell specified that specifically you have cast
function mb_targetHasMyDebuff(spellName)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura("target", spellName, nil, "PLAYER|HARMFUL")
	return name ~= nil
end

-- Checks if unit has a buff from the spell specified that specifically you have cast
function mb_unitHasMyBuff(unit, spellName)
	local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, spellName, nil, "PLAYER|HELPFUL")
	return name ~= nil
end














