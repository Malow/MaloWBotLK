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



