function mb_Paladin_OnLoad()
	mb_registerDesiredBuff(BUFF_KINGS)
	mb_registerDesiredBuff(BUFF_WISDOM)
	mb_registerDesiredBuff(BUFF_MIGHT)
	if mb_myClassOrderIndex == 1 then
		mb_registerMessageHandler(BUFF_MIGHT.requestType, mb_Paladin_mightHandler)
		return
	end
	if mb_myClassOrderIndex == 2 then
		mb_registerMessageHandler(BUFF_WISDOM.requestType, mb_Paladin_wisdomHandler)
		return
	end
	if mb_myClassOrderIndex == 3 then
		mb_registerMessageHandler(BUFF_KINGS.requestType, mb_Paladin_kingsHandler)
		return
	end
end

function mb_Paladin_OnUpdate()
	if mb_resurrectRaid("Redemption") then
		return
	end
	
	if UnitBuff("player", "The Art of War") then
		if mb_Paladin_FlashOfLightRaid() then
			return
		end
	end
	
	if mb_myClassOrderIndex == 1 and not UnitBuff("player", "Retribution Aura") then
		CastSpellByName("Retribution Aura")
		return
	end
	
	if not UnitBuff("player", "Seal of Command") then
		CastSpellByName("Seal of Command")
		return
	end
	
	AssistUnit(mb_commanderUnit)
	if not mb_hasValidOffensiveTarget() then
		return
	end
	
	if not mb_isAutoAttacking then
		InteractUnit("target")
	end
	
	if mb_castSpellOnTarget("Judgement of Wisdom") then
		return
	end	
	
	if mb_unitHealthPercentage("target") < 21 and mb_castSpellOnTarget("Hammer of Wrath") then
		return
	end	
	
	if mb_castSpellOnTarget("Crusader Strike") then
		return
	end
	
	if CheckInteractDistance("target", 3) and mb_castSpellOnTarget("Divine Storm") then
		return
	end	
end

function mb_Paladin_FlashOfLightRaid()
	local healUnit, missingHealth = mb_getMostDamagedFriendly("Flash of Light")
	if missingHealth > 500 then
		mb_castSpellOnFriendly(healUnit, "Flash of Light")
		return true
	end
	return false
end

function mb_Paladin_mightHandler(msg, from)
	mb_castSpellOnFriendly(mb_getUnitForPlayerName(from), "Blessing of Might")
end

function mb_Paladin_wisdomHandler(msg, from)
	mb_castSpellOnFriendly(mb_getUnitForPlayerName(from), "Blessing of Wisdom")
end

function mb_Paladin_kingsHandler(msg, from)
	mb_castSpellOnFriendly(mb_getUnitForPlayerName(from), "Blessing of Kings")
end







