
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
-- Holy Light
mb_spellEffectBaseValues["Holy Light"] = {}
mb_spellEffectBaseValues["Holy Light"].coefficient = 1.66
mb_spellEffectBaseValues["Holy Light"][1] = 60
mb_spellEffectBaseValues["Holy Light"][2] = 116
mb_spellEffectBaseValues["Holy Light"][3] = 239
mb_spellEffectBaseValues["Holy Light"][4] = 455
mb_spellEffectBaseValues["Holy Light"][5] = 708
mb_spellEffectBaseValues["Holy Light"][6] = 998
mb_spellEffectBaseValues["Holy Light"][7] = 1349
mb_spellEffectBaseValues["Holy Light"][8] = 1777
mb_spellEffectBaseValues["Holy Light"][9] = 2266
mb_spellEffectBaseValues["Holy Light"][10] = 2486
mb_spellEffectBaseValues["Holy Light"][11] = 3138
mb_spellEffectBaseValues["Holy Light"][12] = 4677
mb_spellEffectBaseValues["Holy Light"][13] = 5444
-- Holy Shock
mb_spellEffectBaseValues["Holy Shock"] = {}
mb_spellEffectBaseValues["Holy Shock"].coefficient = 0.81
mb_spellEffectBaseValues["Holy Shock"][1] = 582
mb_spellEffectBaseValues["Holy Shock"][2] = 780
mb_spellEffectBaseValues["Holy Shock"][3] = 1025
mb_spellEffectBaseValues["Holy Shock"][4] = 1287
mb_spellEffectBaseValues["Holy Shock"][5] = 1526
mb_spellEffectBaseValues["Holy Shock"][6] = 2504
mb_spellEffectBaseValues["Holy Shock"][7] = 2911
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







