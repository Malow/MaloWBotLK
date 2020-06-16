mb_TrustedCharacters = {}
table.insert(mb_TrustedCharacters, "Malowtank")
table.insert(mb_TrustedCharacters, "Aerer")
table.insert(mb_TrustedCharacters, "Rewis")
table.insert(mb_TrustedCharacters, "Warde")
table.insert(mb_TrustedCharacters, "Elweald")
table.insert(mb_TrustedCharacters, "Ceolmar")
table.insert(mb_TrustedCharacters, "Riffin")
table.insert(mb_TrustedCharacters, "Tunbert")
table.insert(mb_TrustedCharacters, "Ninki")
table.insert(mb_TrustedCharacters, "Abith")
table.insert(mb_TrustedCharacters, "Puabi")
table.insert(mb_TrustedCharacters, "Igal")
table.insert(mb_TrustedCharacters, "Verne")

function mb_isTrustedCharacter(charName)
	for _, name in pairs(mb_TrustedCharacters) do 
		if name == charName then
			return true
		end
	end
	return false
end

-- Class Order is the alphabetical order that the character is within its own class
mb_ClassOrderConfig = {}
mb_ClassOrderConfig.mightBlesser = 1
mb_ClassOrderConfig.wisdomBlesser = 2
mb_ClassOrderConfig.kingsBlesser = 3
mb_ClassOrderConfig.sancBlesser = 4
mb_ClassOrderConfig.retriAura = 1
mb_ClassOrderConfig.concentrationAura = 2
mb_ClassOrderConfig.frostAura = 3
mb_ClassOrderConfig.devoAura = 4
mb_ClassOrderConfig.fireAura = 5
mb_ClassOrderConfig.crusaderAura = 6
mb_ClassOrderConfig.shadowAura = 7



-- -----------------------------------------------
-- Stat Weights
-- -----------------------------------------------
mb_statWeights = {}
-- Paladin
mb_statWeights["Paladin"] = {}
-- Protection
mb_statWeights["Paladin"]["Protection"] = {}
mb_statWeights["Paladin"]["Protection"].agility = 0.6
mb_statWeights["Paladin"]["Protection"].intellect = 0.0
mb_statWeights["Paladin"]["Protection"].spirit = 0.0
mb_statWeights["Paladin"]["Protection"].strength = 0.16
mb_statWeights["Paladin"]["Protection"].stamina = 1.0
mb_statWeights["Paladin"]["Protection"].critRating = 0.0
mb_statWeights["Paladin"]["Protection"].resilienceRating = 0.0
mb_statWeights["Paladin"]["Protection"].defenseRating = 0.45
mb_statWeights["Paladin"]["Protection"].expertiseRating = 0.59
mb_statWeights["Paladin"]["Protection"].dodgeRating = 0.55
mb_statWeights["Paladin"]["Protection"].parryRating = 0.30
mb_statWeights["Paladin"]["Protection"].blockRating = 0.07
mb_statWeights["Paladin"]["Protection"].armorPenetrationRating = 0.0
mb_statWeights["Paladin"]["Protection"].hitRating = 0.0
mb_statWeights["Paladin"]["Protection"].hasteRating = 0.0
mb_statWeights["Paladin"]["Protection"].attackPower = 0.0
mb_statWeights["Paladin"]["Protection"].armor = 0.08
mb_statWeights["Paladin"]["Protection"].blockValue = 0.06
mb_statWeights["Paladin"]["Protection"].spellPower = 0.0
mb_statWeights["Paladin"]["Protection"].mp5 = 0.0
mb_statWeights["Paladin"]["Protection"].dps = 0.0
mb_statWeights["Paladin"]["Protection"].socketMeta = 100
mb_statWeights["Paladin"]["Protection"].socketColored = 16
-- Retribution
mb_statWeights["Paladin"]["Retribution"] = {}
mb_statWeights["Paladin"]["Retribution"].agility = 0.32
mb_statWeights["Paladin"]["Retribution"].intellect = 0.0
mb_statWeights["Paladin"]["Retribution"].spirit = 0.0
mb_statWeights["Paladin"]["Retribution"].strength = 0.8
mb_statWeights["Paladin"]["Retribution"].stamina = 0.01
mb_statWeights["Paladin"]["Retribution"].critRating = 0.4
mb_statWeights["Paladin"]["Retribution"].resilienceRating = 0.0
mb_statWeights["Paladin"]["Retribution"].defenseRating = 0.0
mb_statWeights["Paladin"]["Retribution"].expertiseRating = 0.66
mb_statWeights["Paladin"]["Retribution"].dodgeRating = 0.0
mb_statWeights["Paladin"]["Retribution"].parryRating = 0.0
mb_statWeights["Paladin"]["Retribution"].blockRating = 0.0
mb_statWeights["Paladin"]["Retribution"].armorPenetrationRating = 0.22
mb_statWeights["Paladin"]["Retribution"].hitRating = 1.0
mb_statWeights["Paladin"]["Retribution"].hasteRating = 0.3
mb_statWeights["Paladin"]["Retribution"].attackPower = 0.34
mb_statWeights["Paladin"]["Retribution"].armor = 0.0
mb_statWeights["Paladin"]["Retribution"].blockValue = 0.0
mb_statWeights["Paladin"]["Retribution"].spellPower = 0.09
mb_statWeights["Paladin"]["Retribution"].mp5 = 0.0
mb_statWeights["Paladin"]["Retribution"].dps = 4.7
mb_statWeights["Paladin"]["Retribution"].socketMeta = 100
mb_statWeights["Paladin"]["Retribution"].socketColored = 16

-- Shaman
mb_statWeights["Shaman"] = {}
-- Enhancement
mb_statWeights["Shaman"]["Enhancement"] = {}
mb_statWeights["Shaman"]["Enhancement"].agility = 0.55
mb_statWeights["Shaman"]["Enhancement"].intellect = 0.55
mb_statWeights["Shaman"]["Enhancement"].spirit = 0.0
mb_statWeights["Shaman"]["Enhancement"].strength = 0.35
mb_statWeights["Shaman"]["Enhancement"].stamina = 0.01
mb_statWeights["Shaman"]["Enhancement"].critRating = 0.55
mb_statWeights["Shaman"]["Enhancement"].resilienceRating = 0.0
mb_statWeights["Shaman"]["Enhancement"].defenseRating = 0.0
mb_statWeights["Shaman"]["Enhancement"].expertiseRating = 0.84
mb_statWeights["Shaman"]["Enhancement"].dodgeRating = 0.0
mb_statWeights["Shaman"]["Enhancement"].parryRating = 0.0
mb_statWeights["Shaman"]["Enhancement"].blockRating = 0.0
mb_statWeights["Shaman"]["Enhancement"].armorPenetrationRating = 0.26
mb_statWeights["Shaman"]["Enhancement"].hitRating = 1.0
mb_statWeights["Shaman"]["Enhancement"].hasteRating = 0.42
mb_statWeights["Shaman"]["Enhancement"].attackPower = 0.32
mb_statWeights["Shaman"]["Enhancement"].armor = 0.0
mb_statWeights["Shaman"]["Enhancement"].blockValue = 0.0
mb_statWeights["Shaman"]["Enhancement"].spellPower = 0.29
mb_statWeights["Shaman"]["Enhancement"].mp5 = 0.0
mb_statWeights["Shaman"]["Enhancement"].dps = 1.35
mb_statWeights["Shaman"]["Enhancement"].socketMeta = 100
mb_statWeights["Shaman"]["Enhancement"].socketColored = 16

-- Warrior
mb_statWeights["Warrior"] = {}
-- Arms
mb_statWeights["Warrior"]["Arms"] = {}
mb_statWeights["Warrior"]["Arms"].agility = 0.65
mb_statWeights["Warrior"]["Arms"].intellect = 0.0
mb_statWeights["Warrior"]["Arms"].spirit = 0.0
mb_statWeights["Warrior"]["Arms"].strength = 1.0
mb_statWeights["Warrior"]["Arms"].stamina = 0.01
mb_statWeights["Warrior"]["Arms"].critRating = 0.8
mb_statWeights["Warrior"]["Arms"].resilienceRating = 0.0
mb_statWeights["Warrior"]["Arms"].defenseRating = 0.0
mb_statWeights["Warrior"]["Arms"].expertiseRating = 0.85
mb_statWeights["Warrior"]["Arms"].dodgeRating = 0.0
mb_statWeights["Warrior"]["Arms"].parryRating = 0.0
mb_statWeights["Warrior"]["Arms"].blockRating = 0.0
mb_statWeights["Warrior"]["Arms"].armorPenetrationRating = 0.65
mb_statWeights["Warrior"]["Arms"].hitRating = 0.9
mb_statWeights["Warrior"]["Arms"].hasteRating = 0.5
mb_statWeights["Warrior"]["Arms"].attackPower = 0.45
mb_statWeights["Warrior"]["Arms"].armor = 0.0
mb_statWeights["Warrior"]["Arms"].blockValue = 0.0
mb_statWeights["Warrior"]["Arms"].spellPower = 0.0
mb_statWeights["Warrior"]["Arms"].mp5 = 0.0
mb_statWeights["Warrior"]["Arms"].dps = 4.7
mb_statWeights["Warrior"]["Arms"].socketMeta = 100
mb_statWeights["Warrior"]["Arms"].socketColored = 16









