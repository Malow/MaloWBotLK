
mb_spellEffectBaseValues = {}
-- Flash of Light
mb_spellEffectBaseValues["Flash of Light"] = {}
mb_spellEffectBaseValues["Flash of Light"].coefficient = 1.0
mb_spellEffectBaseValues["Flash of Light"][1] = 93
mb_spellEffectBaseValues["Flash of Light"][2] = 144
mb_spellEffectBaseValues["Flash of Light"][3] = 211
mb_spellEffectBaseValues["Flash of Light"][4] = 288
mb_spellEffectBaseValues["Flash of Light"][5] = 390
mb_spellEffectBaseValues["Flash of Light"][6] = 499
mb_spellEffectBaseValues["Flash of Light"][7] = 658
mb_spellEffectBaseValues["Flash of Light"][8] = 764
mb_spellEffectBaseValues["Flash of Light"][9] = 879
-- Chain Heal
mb_spellEffectBaseValues["Chain Heal"] = {}
mb_spellEffectBaseValues["Chain Heal"].coefficient = 1.34
mb_spellEffectBaseValues["Chain Heal"][1] = 368
mb_spellEffectBaseValues["Chain Heal"][2] = 465
mb_spellEffectBaseValues["Chain Heal"][3] = 629
mb_spellEffectBaseValues["Chain Heal"][4] = 691
mb_spellEffectBaseValues["Chain Heal"][5] = 942
mb_spellEffectBaseValues["Chain Heal"][6] = 1034
mb_spellEffectBaseValues["Chain Heal"][7] = 1205


function mb_GetSpellEffect(spell)
    local _, rank = GetSpellInfo(spell)
    local spellRank = tonumber(string.sub(rank, 5))
    local spellValues = mb_spellEffectBaseValues[spell]
    if spellValues == nil or spellValues[spellRank] == nil then
        mb_SayRaid(spell .. "(Rank " .. spellRank .. ") is not supported in SpellEffectCalculator, please add it in SpellEffectCalculator.lua at the top.")
        return nil
    end
    local baseValue = spellValues[spellRank]
    local coefficient = spellValues.coefficient
    local spellPower = GetSpellBonusHealing()
    return (baseValue + coefficient * spellPower) * 1.06 -- Count on having Improved Devotion Aura
end







