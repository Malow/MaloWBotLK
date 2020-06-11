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

