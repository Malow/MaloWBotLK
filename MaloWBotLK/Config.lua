mb_config = {}


-- Which characters in the raid should be considered tanks, and as such be paid extra attention to by the healers
mb_config.tanks = {"Malowtank", "Elerien", "Tunbert", "Maligna"}


-- List of character names that you trust, that your characters will accept orders, remote-executes etc. from.
mb_config.trustedCharacters = {}
table.insert(mb_config.trustedCharacters, "Malowtank")
table.insert(mb_config.trustedCharacters, "Aerer")
table.insert(mb_config.trustedCharacters, "Rewis")
table.insert(mb_config.trustedCharacters, "Warde")
table.insert(mb_config.trustedCharacters, "Ceolmar")
table.insert(mb_config.trustedCharacters, "Riffin")
table.insert(mb_config.trustedCharacters, "Tunbert")
table.insert(mb_config.trustedCharacters, "Ninki")
table.insert(mb_config.trustedCharacters, "Abith")
table.insert(mb_config.trustedCharacters, "Puabi")
table.insert(mb_config.trustedCharacters, "Igal")
table.insert(mb_config.trustedCharacters, "Verne")
table.insert(mb_config.trustedCharacters, "Carin")


-- List of waters that should be drunk
mb_config.waters = {}
table.insert(mb_config.waters, "Conjured Mana Strudel")


-- Decides whether characters should register consumables for reagent watch
mb_config.enableConsumablesWatch = true


-- List of profession CD's to use automatically (in order)
mb_config.professionCooldowns = {}
mb_config.professionCooldowns["Alchemy"] = {}
table.insert(mb_config.professionCooldowns["Alchemy"], "Transmute: Eternal Shadow to Life")


-- Class Order is the alphabetical order that the character is within its own class
mb_config.classOrder = {}
mb_config.classOrder.mightBlesser = 1
mb_config.classOrder.wisdomBlesser = 2
mb_config.classOrder.sancBlesser = 3
mb_config.classOrder.kingsBlesser = 4
mb_config.classOrder.retriAura = 1
mb_config.classOrder.concentrationAura = 2
mb_config.classOrder.devoAura = 3
mb_config.classOrder.frostAura = 4
mb_config.classOrder.fireAura = 5
mb_config.classOrder.crusaderAura = 6
mb_config.classOrder.shadowAura = 7


-- Blacklisted interrupt spells, spells that are not interruptible but that shows as interruptible
mb_config.blacklistedInterruptSpells = {}
mb_config.blacklistedInterruptSpells["Malygos"] = { "Arcane Breath" }
mb_config.blacklistedInterruptSpells["Sartharion"] = { "Flame Breath" }


-- -----------------------------------------------
-- Raid Layout
-- -----------------------------------------------
mb_config.raidLayout = {}
mb_config.raidLayout["25man"] = {}
mb_config.raidLayout["25man"][1] = {}
table.insert(mb_config.raidLayout["25man"][1], "Malowtank")
table.insert(mb_config.raidLayout["25man"][1], "Aerer")
table.insert(mb_config.raidLayout["25man"][1], "Ninki")
table.insert(mb_config.raidLayout["25man"][1], "Carin")
table.insert(mb_config.raidLayout["25man"][1], "Rewis")
mb_config.raidLayout["25man"][2] = {}
table.insert(mb_config.raidLayout["25man"][2], "Warde")
table.insert(mb_config.raidLayout["25man"][2], "Riffin")
table.insert(mb_config.raidLayout["25man"][2], "Tunbert")
table.insert(mb_config.raidLayout["25man"][2], "Abith")
table.insert(mb_config.raidLayout["25man"][2], "Elerien")
mb_config.raidLayout["25man"][3] = {}
table.insert(mb_config.raidLayout["25man"][3], "Puabi")
table.insert(mb_config.raidLayout["25man"][3], "Verne")
table.insert(mb_config.raidLayout["25man"][3], "Odia")
table.insert(mb_config.raidLayout["25man"][3], "Necria")
table.insert(mb_config.raidLayout["25man"][3], "Trudy")
mb_config.raidLayout["25man"][4] = {}
table.insert(mb_config.raidLayout["25man"][4], "Khalia")
table.insert(mb_config.raidLayout["25man"][4], "Gwethriel")
table.insert(mb_config.raidLayout["25man"][4], "Arethel")
table.insert(mb_config.raidLayout["25man"][4], "Kisaana")
table.insert(mb_config.raidLayout["25man"][4], "Ceolmar")
mb_config.raidLayout["25man"][5] = {}
table.insert(mb_config.raidLayout["25man"][5], "Maligna")
table.insert(mb_config.raidLayout["25man"][5], "Charnel")
table.insert(mb_config.raidLayout["25man"][5], "Pestilina")
table.insert(mb_config.raidLayout["25man"][5], "Umbria")
table.insert(mb_config.raidLayout["25man"][5], "Igal")


-- -----------------------------------------------
-- Stat Weights
-- -----------------------------------------------
mb_config.statWeights = {}
-- Paladin
mb_config.statWeights["Paladin"] = {}
-- Holy
mb_config.statWeights["Paladin"]["Holy"] = {}
mb_config.statWeights["Paladin"]["Holy"].agility = 0.0
mb_config.statWeights["Paladin"]["Holy"].intellect = 1.0
mb_config.statWeights["Paladin"]["Holy"].spirit = 0.0
mb_config.statWeights["Paladin"]["Holy"].strength = 0.0
mb_config.statWeights["Paladin"]["Holy"].stamina = 0.1
mb_config.statWeights["Paladin"]["Holy"].critRating = 0.46
mb_config.statWeights["Paladin"]["Holy"].resilienceRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].defenseRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].expertiseRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].dodgeRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].parryRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].blockRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].armorPenetrationRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].hitRating = 0.0
mb_config.statWeights["Paladin"]["Holy"].hasteRating = 0.35
mb_config.statWeights["Paladin"]["Holy"].attackPower = 0.0
mb_config.statWeights["Paladin"]["Holy"].armor = 0.0
mb_config.statWeights["Paladin"]["Holy"].blockValue = 0.0
mb_config.statWeights["Paladin"]["Holy"].spellPower = 0.58
mb_config.statWeights["Paladin"]["Holy"].mp5 = 0.88
mb_config.statWeights["Paladin"]["Holy"].dps = 0.0
mb_config.statWeights["Paladin"]["Holy"].socketMeta = 100
mb_config.statWeights["Paladin"]["Holy"].socketColored = 16
-- Protection
mb_config.statWeights["Paladin"]["Protection"] = {}
mb_config.statWeights["Paladin"]["Protection"].agility = 0.6
mb_config.statWeights["Paladin"]["Protection"].intellect = 0.0
mb_config.statWeights["Paladin"]["Protection"].spirit = 0.0
mb_config.statWeights["Paladin"]["Protection"].strength = 0.16
mb_config.statWeights["Paladin"]["Protection"].stamina = 1.0
mb_config.statWeights["Paladin"]["Protection"].critRating = 0.0
mb_config.statWeights["Paladin"]["Protection"].resilienceRating = 0.0
mb_config.statWeights["Paladin"]["Protection"].defenseRating = 0.5
mb_config.statWeights["Paladin"]["Protection"].expertiseRating = 0.59
mb_config.statWeights["Paladin"]["Protection"].dodgeRating = 0.4
mb_config.statWeights["Paladin"]["Protection"].parryRating = 0.45
mb_config.statWeights["Paladin"]["Protection"].blockRating = 0.07
mb_config.statWeights["Paladin"]["Protection"].armorPenetrationRating = 0.0
mb_config.statWeights["Paladin"]["Protection"].hitRating = 0.0
mb_config.statWeights["Paladin"]["Protection"].hasteRating = 0.0
mb_config.statWeights["Paladin"]["Protection"].attackPower = 0.0
mb_config.statWeights["Paladin"]["Protection"].armor = 0.08
mb_config.statWeights["Paladin"]["Protection"].blockValue = 0.06
mb_config.statWeights["Paladin"]["Protection"].spellPower = 0.0
mb_config.statWeights["Paladin"]["Protection"].mp5 = 0.0
mb_config.statWeights["Paladin"]["Protection"].dps = 0.0
mb_config.statWeights["Paladin"]["Protection"].socketMeta = 100
mb_config.statWeights["Paladin"]["Protection"].socketColored = 16
-- Retribution
mb_config.statWeights["Paladin"]["Retribution"] = {}
mb_config.statWeights["Paladin"]["Retribution"].agility = 0.32
mb_config.statWeights["Paladin"]["Retribution"].intellect = 0.0
mb_config.statWeights["Paladin"]["Retribution"].spirit = 0.0
mb_config.statWeights["Paladin"]["Retribution"].strength = 0.8
mb_config.statWeights["Paladin"]["Retribution"].stamina = 0.01
mb_config.statWeights["Paladin"]["Retribution"].critRating = 0.4
mb_config.statWeights["Paladin"]["Retribution"].resilienceRating = 0.0
mb_config.statWeights["Paladin"]["Retribution"].defenseRating = 0.0
mb_config.statWeights["Paladin"]["Retribution"].expertiseRating = 0.33
mb_config.statWeights["Paladin"]["Retribution"].dodgeRating = 0.0
mb_config.statWeights["Paladin"]["Retribution"].parryRating = 0.0
mb_config.statWeights["Paladin"]["Retribution"].blockRating = 0.0
mb_config.statWeights["Paladin"]["Retribution"].armorPenetrationRating = 0.2
mb_config.statWeights["Paladin"]["Retribution"].hitRating = 0.5
mb_config.statWeights["Paladin"]["Retribution"].hasteRating = 0.25
mb_config.statWeights["Paladin"]["Retribution"].attackPower = 0.34
mb_config.statWeights["Paladin"]["Retribution"].armor = 0.0
mb_config.statWeights["Paladin"]["Retribution"].blockValue = 0.0
mb_config.statWeights["Paladin"]["Retribution"].spellPower = 0.09
mb_config.statWeights["Paladin"]["Retribution"].mp5 = 0.0
mb_config.statWeights["Paladin"]["Retribution"].dps = 0.0
mb_config.statWeights["Paladin"]["Retribution"].socketMeta = 100
mb_config.statWeights["Paladin"]["Retribution"].socketColored = 12.8

-- Shaman
mb_config.statWeights["Shaman"] = {}
-- Enhancement
mb_config.statWeights["Shaman"]["Enhancement"] = {}
mb_config.statWeights["Shaman"]["Enhancement"].agility = 0.55
mb_config.statWeights["Shaman"]["Enhancement"].intellect = 0.4
mb_config.statWeights["Shaman"]["Enhancement"].spirit = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].strength = 0.4
mb_config.statWeights["Shaman"]["Enhancement"].stamina = 0.01
mb_config.statWeights["Shaman"]["Enhancement"].critRating = 0.4
mb_config.statWeights["Shaman"]["Enhancement"].resilienceRating = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].defenseRating = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].expertiseRating = 0.84
mb_config.statWeights["Shaman"]["Enhancement"].dodgeRating = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].parryRating = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].blockRating = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].armorPenetrationRating = 0.2
mb_config.statWeights["Shaman"]["Enhancement"].hitRating = 1.0
mb_config.statWeights["Shaman"]["Enhancement"].hasteRating = 0.6
mb_config.statWeights["Shaman"]["Enhancement"].attackPower = 0.35
mb_config.statWeights["Shaman"]["Enhancement"].armor = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].blockValue = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].spellPower = 0.2
mb_config.statWeights["Shaman"]["Enhancement"].mp5 = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].dps = 0.0
mb_config.statWeights["Shaman"]["Enhancement"].socketMeta = 100
mb_config.statWeights["Shaman"]["Enhancement"].socketColored = 16

-- Warrior
mb_config.statWeights["Warrior"] = {}
-- Arms
mb_config.statWeights["Warrior"]["Arms"] = {}
mb_config.statWeights["Warrior"]["Arms"].agility = 0.4
mb_config.statWeights["Warrior"]["Arms"].intellect = 0.0
mb_config.statWeights["Warrior"]["Arms"].spirit = 0.0
mb_config.statWeights["Warrior"]["Arms"].strength = 1.0
mb_config.statWeights["Warrior"]["Arms"].stamina = 0.01
mb_config.statWeights["Warrior"]["Arms"].critRating = 0.35
mb_config.statWeights["Warrior"]["Arms"].resilienceRating = 0.0
mb_config.statWeights["Warrior"]["Arms"].defenseRating = 0.0
mb_config.statWeights["Warrior"]["Arms"].expertiseRating = 0.1
mb_config.statWeights["Warrior"]["Arms"].dodgeRating = 0.0
mb_config.statWeights["Warrior"]["Arms"].parryRating = 0.0
mb_config.statWeights["Warrior"]["Arms"].blockRating = 0.0
mb_config.statWeights["Warrior"]["Arms"].armorPenetrationRating = 0.4
mb_config.statWeights["Warrior"]["Arms"].hitRating = 0.45
mb_config.statWeights["Warrior"]["Arms"].hasteRating = 0.1
mb_config.statWeights["Warrior"]["Arms"].attackPower = 0.45
mb_config.statWeights["Warrior"]["Arms"].armor = 0.0
mb_config.statWeights["Warrior"]["Arms"].blockValue = 0.0
mb_config.statWeights["Warrior"]["Arms"].spellPower = 0.0
mb_config.statWeights["Warrior"]["Arms"].mp5 = 0.0
mb_config.statWeights["Warrior"]["Arms"].dps = 0.0
mb_config.statWeights["Warrior"]["Arms"].socketMeta = 100
mb_config.statWeights["Warrior"]["Arms"].socketColored = 16

-- Rogue
mb_config.statWeights["Rogue"] = {}
-- Combat
mb_config.statWeights["Rogue"]["Combat"] = {}
mb_config.statWeights["Rogue"]["Combat"].agility = 1.0
mb_config.statWeights["Rogue"]["Combat"].intellect = 0.0
mb_config.statWeights["Rogue"]["Combat"].spirit = 0.0
mb_config.statWeights["Rogue"]["Combat"].strength = 0.55
mb_config.statWeights["Rogue"]["Combat"].stamina = 0.01
mb_config.statWeights["Rogue"]["Combat"].critRating = 0.75
mb_config.statWeights["Rogue"]["Combat"].resilienceRating = 0.0
mb_config.statWeights["Rogue"]["Combat"].defenseRating = 0.0
mb_config.statWeights["Rogue"]["Combat"].expertiseRating = 0.82
mb_config.statWeights["Rogue"]["Combat"].dodgeRating = 0.0
mb_config.statWeights["Rogue"]["Combat"].parryRating = 0.0
mb_config.statWeights["Rogue"]["Combat"].blockRating = 0.0
mb_config.statWeights["Rogue"]["Combat"].armorPenetrationRating = 1.0
mb_config.statWeights["Rogue"]["Combat"].hitRating = 0.8
mb_config.statWeights["Rogue"]["Combat"].hasteRating = 0.73
mb_config.statWeights["Rogue"]["Combat"].attackPower = 0.5
mb_config.statWeights["Rogue"]["Combat"].armor = 0.0
mb_config.statWeights["Rogue"]["Combat"].blockValue = 0.0
mb_config.statWeights["Rogue"]["Combat"].spellPower = 0.0
mb_config.statWeights["Rogue"]["Combat"].mp5 = 0.0
mb_config.statWeights["Rogue"]["Combat"].dps = 0.0
mb_config.statWeights["Rogue"]["Combat"].socketMeta = 100
mb_config.statWeights["Rogue"]["Combat"].socketColored = 16




