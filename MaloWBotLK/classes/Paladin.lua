function mb_Paladin_OnLoad()
	mb_classSpecificRunFunction = mb_Paladin_OnUpdate

	mb_registerDesiredBuff(BUFF_KINGS)
	mb_registerDesiredBuff(BUFF_WISDOM)
	mb_registerDesiredBuff(BUFF_MIGHT)
	mb_registerDesiredBuff(BUFF_SANCTUARY)
	if mb_myClassOrderIndex == mb_ClassOrderConfig.mightBlesser then
		mb_registerMessageHandler(BUFF_MIGHT.requestType, mb_Paladin_mightHandler)
		return
	end
	if mb_myClassOrderIndex == mb_ClassOrderConfig.wisdomBlesser then
		mb_registerMessageHandler(BUFF_WISDOM.requestType, mb_Paladin_wisdomHandler)
		return
	end
	if mb_myClassOrderIndex == mb_ClassOrderConfig.kingsBlesser then
		mb_registerMessageHandler(BUFF_KINGS.requestType, mb_Paladin_kingsHandler)
		return
	end
	if mb_myClassOrderIndex == mb_ClassOrderConfig.sancBlesser then
		mb_registerMessageHandler(BUFF_SANCTUARY.requestType, mb_Paladin_sancHandler)
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

	if mb_Paladin_CastAura() then
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
	
	if mb_isSpellInRange("Crusader Strike", "target") and mb_castSpellOnSelf("Divine Storm") then
		return
	end	
end

function mb_Paladin_FlashOfLightRaid()
	local healUnit, missingHealth = mb_getMostDamagedFriendly("Flash of Light")
	if missingHealth > mb_getSpellEffect("Flash of Light") then
		mb_castSpellOnFriendly(healUnit, "Flash of Light")
		return true
	end
	return false
end

function mb_Paladin_mightHandler(msg, from)
	mb_Paladin_handleBless(from, "Greater Blessing of Might", "Blessing of Might")
end

function mb_Paladin_wisdomHandler(msg, from)
	mb_Paladin_handleBless(from, "Greater Blessing of Wisdom", "Blessing of Wisdom")
end

function mb_Paladin_kingsHandler(msg, from)
	mb_Paladin_handleBless(from, "Greater Blessing of Kings", "Blessing of Kings")
end

function mb_Paladin_sancHandler(msg, from)
	mb_Paladin_handleBless(from, "Greater Blessing of Sanctuary", "Blessing of Sanctuary")
end

function mb_Paladin_handleBless(targetPlayerName, greaterSpell, singleSpell)
	if UnitAffectingCombat("player") then
		return
	end
	if mb_castSpellOnFriendly(mb_getUnitForPlayerName(targetPlayerName), greaterSpell) then
		return
	end
	mb_castSpellOnFriendly(mb_getUnitForPlayerName(targetPlayerName), singleSpell)
end

function mb_Paladin_CastAura()
	local myAura = ""
	if mb_myClassOrderIndex == mb_ClassOrderConfig.retriAura then
		myAura = "Retribution Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.concentrationAura then
		myAura = "Concentration Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.frostAura then
		myAura = "Frost Resistance Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.devoAura then
		myAura = "Devotion Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.fireAura then
		myAura = "Fire Resistance Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.crusaderAura then
		myAura = "Crusader Aura"
	elseif mb_myClassOrderIndex == mb_ClassOrderConfig.shadowAura then
		myAura = "Shadow Resistance Aura"
	end
	if UnitBuff("player", myAura) then
		return false
	end
	return mb_castSpellOnSelf(myAura)
end




