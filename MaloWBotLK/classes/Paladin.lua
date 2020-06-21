function mb_Paladin_OnLoad()
	mb_RegisterDesiredBuff(BUFF_KINGS)
	mb_RegisterDesiredBuff(BUFF_WISDOM)
	mb_RegisterDesiredBuff(BUFF_SANCTUARY)
	mb_RegisterDesiredBuff(BUFF_FORT)
	mb_RegisterDesiredBuff(BUFF_SPIRIT)
	mb_RegisterDesiredBuff(BUFF_INTELLECT)
	mb_RegisterDesiredBuff(BUFF_SHADOW_PROT)
	mb_RegisterDesiredBuff(BUFF_MOTW)

	mb_CheckReagentAmount("Symbol of Kings", 300)

	if mb_GetMySpecName() == "Holy" then
		mb_SayRaid("Holy spec is not supported yet")
	elseif mb_GetMySpecName() == "Protection" then
		mb_classSpecificRunFunction = mb_Paladin_Protection_OnUpdate
		mb_RegisterDesiredBuff(BUFF_MIGHT)
	else
		mb_classSpecificRunFunction = mb_Paladin_Retribution_OnUpdate
		mb_RegisterDesiredBuff(BUFF_MIGHT)
	end


	if mb_GetMySpecName() == "Protection" then -- Override class-order blessing for prot-palas since they have sanc
		mb_RegisterMessageHandler(BUFF_SANCTUARY.requestType, mb_Paladin_SancHandler)
		return
	end
	if mb_myClassOrderIndex == mb_config.classOrder.mightBlesser then
		mb_RegisterMessageHandler(BUFF_MIGHT.requestType, mb_Paladin_MightHandler)
		return
	end
	if mb_myClassOrderIndex == mb_config.classOrder.kingsBlesser then
		mb_RegisterMessageHandler(BUFF_KINGS.requestType, mb_Paladin_KingsHandler)
		return
	end
	if mb_myClassOrderIndex == mb_config.classOrder.wisdomBlesser then
		mb_RegisterMessageHandler(BUFF_WISDOM.requestType, mb_Paladin_WisdomHandler)
		return
	end
end

function mb_Paladin_FlashOfLightRaid()
	local healUnit, missingHealth = mb_GetMostDamagedFriendly("Flash of Light")
	if missingHealth > mb_GetSpellEffect("Flash of Light") then
		mb_CastSpellOnFriendly(healUnit, "Flash of Light")
		return true
	end
	return false
end

function mb_Paladin_MightHandler(msg, from)
	mb_Paladin_HandleBless(from, "Greater Blessing of Might", "Blessing of Might")
end

function mb_Paladin_WisdomHandler(msg, from)
	mb_Paladin_HandleBless(from, "Greater Blessing of Wisdom", "Blessing of Wisdom")
end

function mb_Paladin_KingsHandler(msg, from)
	mb_Paladin_HandleBless(from, "Greater Blessing of Kings", "Blessing of Kings")
end

function mb_Paladin_SancHandler(msg, from)
	mb_Paladin_HandleBless(from, "Greater Blessing of Sanctuary", "Blessing of Sanctuary")
end

function mb_Paladin_HandleBless(targetPlayerName, greaterSpell, singleSpell)
	if UnitAffectingCombat("player") then
		return
	end
	if mb_CastSpellOnFriendly(mb_GetUnitForPlayerName(targetPlayerName), greaterSpell) then
		return
	end
	mb_CastSpellOnFriendly(mb_GetUnitForPlayerName(targetPlayerName), singleSpell)
end

function mb_Paladin_CastAura()
	local myAura = ""
	if mb_GetMySpecName() == "Protection" then -- Override class-order auras for prot-palas since they have improved
		myAura = "Devotion Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.retriAura then
		myAura = "Retribution Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.concentrationAura then
		myAura = "Concentration Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.frostAura then
		myAura = "Frost Resistance Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.devoAura then
		myAura = "Devotion Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.fireAura then
		myAura = "Fire Resistance Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.crusaderAura then
		myAura = "Crusader Aura"
	elseif mb_myClassOrderIndex == mb_config.classOrder.shadowAura then
		myAura = "Shadow Resistance Aura"
	end
	if UnitBuff("player", myAura) then
		return false
	end
	return mb_CastSpellWithoutTarget(myAura)
end






