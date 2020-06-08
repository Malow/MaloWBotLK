mb_TrustedCharacters = {}
table.insert(mb_TrustedCharacters, "Malowtank")
table.insert(mb_TrustedCharacters, "Aerer")
table.insert(mb_TrustedCharacters, "Rewis")
table.insert(mb_TrustedCharacters, "Warde")
table.insert(mb_TrustedCharacters, "Elweald")
table.insert(mb_TrustedCharacters, "Ceolmar")
table.insert(mb_TrustedCharacters, "Riffin")
table.insert(mb_TrustedCharacters, "Tunbert")
table.insert(mb_TrustedCharacters, "Lewill")
table.insert(mb_TrustedCharacters, "Conbert")


function mb_isTrustedCharacter(charName)
	for _, name in pairs(mb_TrustedCharacters) do 
		if name == charName then
			return true
		end
	end
	return false
end

