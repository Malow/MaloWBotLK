function mb_Paladin_OnLoad()
	
end

function mb_Paladin_OnUpdate()
	AssistUnit(mb_commanderUnit)
	
	if not mb_hasValidOffensiveTarget() then
		return
	end
	
	if not mb_isAutoAttacking then
		CastSpellByName("Auto Attack")
	end
	
	if UnitBuff("player", "The Art of War") then
		if mb_Paladin_FlashOfLightRaid() then
			return
		end
	end
	
	if not UnitBuff("player", "Seal of Command") then
		CastSpellByName("Seal of Command")
		return
	end
	
	if GetSpellCooldown("Judgement of Wisdom") == 0 then
		CastSpellByName("Judgement of Wisdom")
		return
	end	
	
	if GetSpellCooldown("Crusader Strike") == 0 then
		CastSpellByName("Crusader Strike")
		return
	end
	
	if GetSpellCooldown("Divine Storm") == 0 then
		CastSpellByName("Divine Storm")
		return
	end	
end

function mb_Paladin_FlashOfLightRaid()
	local healUnit, missingHealth = mb_GetMostDamagedFriendly()
	if missingHealth > 500 then
		TargetUnit(healUnit)
		CastSpellByName("Flash of Light")
		return true
	end
	return false
end