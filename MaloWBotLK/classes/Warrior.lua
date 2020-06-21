function mb_Warrior_OnLoad()
	mb_RegisterDesiredBuff(BUFF_KINGS)
	mb_RegisterDesiredBuff(BUFF_MIGHT)
	mb_RegisterDesiredBuff(BUFF_SANCTUARY)
	mb_RegisterDesiredBuff(BUFF_FORT)
	mb_RegisterDesiredBuff(BUFF_SHADOW_PROT)
	mb_RegisterDesiredBuff(BUFF_MOTW)

	if mb_GetMySpecName() == "Arms" then
		mb_classSpecificRunFunction = mb_Warrior_Arms_OnUpdate
	elseif mb_GetMySpecName() == "Fury" then
		mb_SayRaid("Fury spec is not supported yet")
	else
		mb_SayRaid("Protection spec is not supported yet")
	end
end

mb_Warrior_lastCommandingShoutRaidCheck = 0
function mb_Warrior_CommandingShout()
	if not UnitBuff("player", "Commanding Shout") then
		if UnitPower("player") < 10 then
			return mb_CastSpellWithoutTarget("Bloodrage")
		end
		return mb_CastSpellWithoutTarget("Commanding Shout")
	end
	if mb_Warrior_lastCommandingShoutRaidCheck + 10 > mb_time then
		return false
	end
	mb_Warrior_lastCommandingShoutRaidCheck = mb_time
	local members = mb_GetNumPartyOrRaidMembers()
	for i = 1, members do
		local unit = mb_GetUnitFromPartyOrRaidIndex(i)
		if not UnitBuff(unit, "Commanding Shout") and CheckInteractDistance(unit, 4) then
			if UnitPower("player") < 10 then
				return mb_CastSpellWithoutTarget("Bloodrage")
			end
			return mb_CastSpellWithoutTarget("Commanding Shout")
		end
	end
	return false
end

