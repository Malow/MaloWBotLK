mb_TrustedCharacters = {}
table.insert(mb_TrustedCharacters, "Malowtank")
table.insert(mb_TrustedCharacters, "Aerer")

function mb_isTrustedCharacter(charName)
	for _, name in pairs(mb_TrustedCharacters) do 
		if name == charName then
			return true
		end
	end
	return false
end

