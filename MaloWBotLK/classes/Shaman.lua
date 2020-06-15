function mb_Shaman_OnLoad()
	local _, _, elementalPoints = GetTalentTabInfo(1)
	local _, _, enhancementPoints = GetTalentTabInfo(2)
	local _, _, restorationPoints = GetTalentTabInfo(3)
	if elementalPoints > enhancementPoints and elementalPoints > restorationPoints then
		mb_sayRaid("Elemental spec is not supported yet")
	elseif restorationPoints > elementalPoints and restorationPoints > enhancementPoints then
		mb_classSpecificRunFunction = mb_Shaman_RestorationOnUpdate
	else
		mb_classSpecificRunFunction = mb_Shaman_EnhancementOnUpdate
	end

	mb_registerDesiredBuff(BUFF_KINGS)
	mb_registerDesiredBuff(BUFF_WISDOM)
	mb_registerDesiredBuff(BUFF_MIGHT)
	mb_registerDesiredBuff(BUFF_SANCTUARY)
end

function mb_Shaman_ChainHealRaid()
	local healUnit, missingHealth = mb_getMostDamagedFriendly("Chain Heal")
	if missingHealth > mb_getSpellEffect("Chain Heal") then
		mb_castSpellOnFriendly(healUnit, "Chain Heal")
		return true
	end
	return false
end

function mb_Shaman_ApplyWeaponEnchants(mainHandSpell, offHandSpell)
	local hasMainHandEnchant, mainHandExpiration, _, hasOffHandEnchant, offHandExpiration = GetWeaponEnchantInfo()
	if not hasMainHandEnchant then
		if mb_castSpellOnSelf(mainHandSpell) then
			return true
		end
	end
	if offHandSpell == nil then
		return false
	end
	if not hasOffHandEnchant then
		if mb_castSpellOnSelf(offHandSpell) then
			return true
		end
	end
	return false
end



