function mb_Paladin_OnLoad()
	mb_registerDesiredBuff(BUFF_KINGS)
	mb_registerDesiredBuff(BUFF_WISDOM)
	mb_registerDesiredBuff(BUFF_MIGHT)
	local name, iconPath, tier, column, currentRank, maxRank, isExceptional, meetsPrereq = GetTalentInfo(3, 5)
	if currentRank == 2 then
		mb_registerMessageHandler(BUFF_MIGHT.requestType, mb_mightHandler)
		return
	end
	if UnitName("player") == "Warde" then
		mb_registerMessageHandler(BUFF_WISDOM.requestType, mb_wisdomHandler)
		return
	end
	if UnitName("player") == "Tunbert" then
		mb_registerMessageHandler(BUFF_KINGS.requestType, mb_kingsHandler)
		return
	end
end

function mb_Paladin_OnUpdate()
	AssistUnit(mb_commanderUnit)
	
	if UnitBuff("player", "The Art of War") then
		if mb_Paladin_FlashOfLightRaid() then
			return
		end
	end
	
	if UnitName("player") == "Aerer" and not UnitBuff("player", "Retribution Aura") then
		CastSpellByName("Retribution Aura")
		return
	end
	
	if not UnitBuff("player", "Seal of Command") then
		CastSpellByName("Seal of Command")
		return
	end
	
	if not mb_hasValidOffensiveTarget() then
		return
	end
	
	if not mb_isAutoAttacking then
		CastSpellByName("Auto Attack")
	end
	
	if GetSpellCooldown("Judgement of Wisdom") == 0 then
		CastSpellByName("Judgement of Wisdom")
		return
	end	
	
	if GetSpellCooldown("Hammer of Wrath") == 0 and mb_unitHealthPercentage("target") < 21 then
		CastSpellByName("Hammer of Wrath")
		return
	end	
	
	if GetSpellCooldown("Crusader Strike") == 0 then
		CastSpellByName("Crusader Strike")
		return
	end
	
	if GetSpellCooldown("Divine Storm") == 0 and CheckInteractDistance("target", 3) then
		CastSpellByName("Divine Storm")
		return
	end	
end

function mb_Paladin_FlashOfLightRaid()
	local healUnit, missingHealth = mb_getMostDamagedFriendly("Flash of Light")
	if missingHealth > 500 then
		TargetUnit(healUnit)
		CastSpellByName("Flash of Light")
		return true
	end
	return false
end

function mb_mightHandler(msg, from)
	TargetUnit(mb_getUnitForPlayerName(from))
	CastSpellByName("Blessing of Might")
end

function mb_wisdomHandler(msg, from)
	TargetUnit(mb_getUnitForPlayerName(from))
	CastSpellByName("Blessing of Wisdom")
end

function mb_kingsHandler(msg, from)
	TargetUnit(mb_getUnitForPlayerName(from))
	CastSpellByName("Blessing of Kings")
end







