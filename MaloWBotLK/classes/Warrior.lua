function mb_Warrior_OnLoad()
	mb_classSpecificRunFunction = mb_Warrior_OnUpdate

	mb_registerDesiredBuff(BUFF_KINGS)
	mb_registerDesiredBuff(BUFF_MIGHT)
	mb_registerDesiredBuff(BUFF_SANCTUARY)
end

function mb_Warrior_OnUpdate()
	if not UnitBuff("player", "Commanding Shout") and UnitPower("player") >= 10 then
		mb_castSpellOnSelf("Commanding Shout")
		return
	end

	AssistUnit(mb_commanderUnit)
	if not mb_hasValidOffensiveTarget() then
		return
	end
	
	if not mb_isAutoAttacking then
		InteractUnit("target")
	end

	if mb_getDebuffStackCount("target", "Sunder Armor") < 5 and UnitPower("player") >= 15 and mb_castSpellOnTarget("Sunder Armor") then
		return
	end

	if UnitPower("player") >= 30 and mb_castSpellOnTarget("Mortal Strike") then
		return
	end
end