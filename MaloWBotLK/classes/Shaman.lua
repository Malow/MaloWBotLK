function mb_Shaman_OnLoad()
	mb_RegisterDesiredBuff(BUFF_KINGS)
	mb_RegisterDesiredBuff(BUFF_WISDOM)
	mb_RegisterDesiredBuff(BUFF_SANCTUARY)
	mb_RegisterDesiredBuff(BUFF_FORT)
	mb_RegisterDesiredBuff(BUFF_SPIRIT)
	mb_RegisterDesiredBuff(BUFF_INTELLECT)
	mb_RegisterDesiredBuff(BUFF_SHADOW_PROT)
	mb_RegisterDesiredBuff(BUFF_MOTW)

	if mb_GetMySpecName() == "Elemental" then
		mb_SayRaid("Elemental spec is not supported yet")
	elseif mb_GetMySpecName() == "Enhancement" then
		mb_classSpecificRunFunction = mb_Shaman_Enhancement_OnUpdate
		mb_Shaman_Enhancement_OnLoad()
		mb_RegisterDesiredBuff(BUFF_MIGHT)
	else
		mb_classSpecificRunFunction = mb_Shaman_Restoration_OnUpdate
	end

	mb_RegisterExclusiveRequestHandler("heroism", mb_Shaman_HeroismRequestAcceptor, mb_Shaman_HeroismRequestExecutor)
end

function mb_Shaman_ChainHealRaid()
	local healUnit, missingHealth = mb_GetMostDamagedFriendly("Chain Heal")
	if missingHealth > mb_GetSpellEffect("Chain Heal") then
		mb_CastSpellOnFriendly(healUnit, "Chain Heal")
		return true
	end
	return false
end

function mb_Shaman_ApplyWeaponEnchants(mainHandSpell, offHandSpell)
	local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()
	if not hasMainHandEnchant then
		if mb_CastSpellWithoutTarget(mainHandSpell) then
			return true
		end
	end
	if offHandSpell == nil then
		return false
	end
	if not hasOffHandEnchant then
		if mb_CastSpellWithoutTarget(offHandSpell) then
			return true
		end
	end
	return false
end

mb_Shaman_totems = {}
function mb_Shaman_SetFireTotem(spell)
	SetMultiCastSpell(133, mb_GetSpellIdForName(spell))
	mb_Shaman_totems[1] = spell
end
function mb_Shaman_SetEarthTotem(spell)
	SetMultiCastSpell(134, mb_GetSpellIdForName(spell))
	mb_Shaman_totems[2] = spell
end
function mb_Shaman_SetWaterTotem(spell)
	SetMultiCastSpell(135, mb_GetSpellIdForName(spell))
	mb_Shaman_totems[3] = spell
end
function mb_Shaman_SetAirTotem(spell)
	SetMultiCastSpell(136, mb_GetSpellIdForName(spell))
	mb_Shaman_totems[4] = spell
end

function mb_Shaman_HandleTotems()
	local totemCount = mb_Shaman_GetTotemCount()
	if totemCount > 0 and mb_Shaman_AreTotemsOutOfRange_Throttled() and mb_CastSpellWithoutTarget("Totemic Recall") then
		mb_Shaman_lastTotemCheck = mb_time
		return true
	end

	if UnitAffectingCombat("player") then
		if totemCount == 4 then
			return false
		end
		if totemCount < 2 then
		 	mb_CastSpellWithoutTarget("Call of the Elements")
			mb_Shaman_lastTotemCheck = mb_time
			return true
		end
		mb_CastSpellWithoutTarget(mb_Shaman_totems[mb_Shaman_GetMissingTotemIndex()])
		return true
	end
	return false
end

mb_Shaman_lastTotemCheck = 0
function mb_Shaman_AreTotemsOutOfRange_Throttled()
	if mb_Shaman_lastTotemCheck + 5 > mb_time then
		return false
	end
	mb_Shaman_lastTotemCheck = mb_time
	if not mb_Shaman_TargetAnyTotem() then
		return false
	end
	if not CheckInteractDistance("target", 1) then
		return true
	end
end

function mb_Shaman_TargetAnyTotem()
	ClearTarget()
	for i = 1, 4 do
		TargetTotem(i)
		if UnitExists("target") then
			return true
		end
	end
	return false
end

function mb_Shaman_GetMissingTotemIndex()
	for i = 1, 4 do
		local haveTotem, totemName, startTime, duration = GetTotemInfo(i)
		if startTime == 0 or startTime + duration <= mb_time then
			return i
		end
	end
	return nil
end

function mb_Shaman_GetTotemCount()
	local count = 0
	for i = 1, 4 do
		local haveTotem, totemName, startTime, duration = GetTotemInfo(i)
		if startTime ~= 0 and startTime + duration >= mb_time then
			count = count + 1
		end
	end
	return count
end

function mb_Shaman_PurgeTarget()
	for i = 1, 40 do
		local name, rank, icon, count, buffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitBuff("target", i)
		if buffType == "Magic" then
			return mb_CastSpellOnTarget("Purge")
		end
	end
	return false
end

function mb_Shaman_GetHeroismName()
    if UnitRace("player") == "Draenei" then
        return "Heroism"
    end
    return "Bloodlust"
end

function mb_Shaman_HeroismRequestAcceptor(message, from)
	if mb_GetRemainingSpellCooldown(mb_Shaman_GetHeroismName()) < 1.5 and mb_IsUsableSpell(mb_Shaman_GetHeroismName()) then
		return true
	end
	return false
end

function mb_Shaman_HeroismRequestExecutor(message, from)
	if not mb_IsReadyForNewCast() then
		return false
	end
	if mb_CastSpellWithoutTarget(mb_Shaman_GetHeroismName()) then
		mb_SayRaid("Casting " .. mb_Shaman_GetHeroismName())
		return true
	end
	return false
end




