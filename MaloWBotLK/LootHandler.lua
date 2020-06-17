
mb_LootHandler_queuedLootCouncilMsg = nil

function mb_LootHandler_update()
    if mb_LootHandler_queuedLootCouncilMsg ~= nil then
        local msg = mb_LootHandler_queuedLootCouncilMsg
        mb_LootHandler_queuedLootCouncilMsg = nil
        mb_LootHandler_handleLootCouncilRequest(msg)
    end
end

function mb_LootHandler_handleLootCouncilRequest(msg)
    local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount,
        itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(msg)
    if itemName == nil then
        mb_LootHandler_queuedLootCouncilMsg = msg
        GameTooltip:SetHyperlink(msg)
        return
    end
    if not mb_LootHandler_canEquipItem(itemSubType) then
        return
    end
    local usableSlots = mb_LootHandler_getUsableSlotsForItemEquipLoc(itemEquipLoc)
    local output = ""
    local currentItemValue = 99999999
    for _, v in pairs(usableSlots) do
        local currentItemLink = GetInventoryItemLink("player", v)
        if currentItemLink == nil then
            currentItemValue = 0
        else
            output = output .. currentItemLink .. "   "
            currentItemValue = min(currentItemValue, mb_LootHandler_getNormalizedValueForItem(currentItemLink))
        end
    end
    local newItemValue = mb_LootHandler_getNormalizedValueForItem(itemLink)
    if newItemValue > currentItemValue then
        local valueIncrease = newItemValue - currentItemValue
        mb_sayRaid(floor(valueIncrease) .. " score increase over " .. output)
    end
end

function mb_LootHandler_getNormalizedValueForItem(itemLink)
    local stats = {}
    GetItemStats(itemLink, stats)

    if mb_statWeights[UnitClass("player")] == nil or mb_statWeights[UnitClass("player")][mb_getMySpecName()] == nil then
        mb_sayRaid("I don't have stat-weights set up for my class/spec")
        return 0
    end

    local myStatWeights = mb_statWeights[UnitClass("player")][mb_getMySpecName()]
    local itemValue = 0
    for badStatName, statAmount in pairs(stats) do
        local goodStatName = mb_LootHandler_getGoodStatName(badStatName)
        if goodStatName == nil then
            mb_sayRaid("I didn't have a good-name translation for stat: " .. badStatName)
        else
            local statWeight = mb_statWeights[UnitClass("player")][mb_getMySpecName()][goodStatName]
            if statWeight == nil then
                mb_sayRaid("I didn't have a stat-weight defined for the stat: " .. goodStatName)
            else
                itemValue = itemValue + statAmount * statWeight
            end
        end
    end
    return itemValue
end



-- ----------------------------------
-- Hardcoded translation functions --
-- ----------------------------------
function mb_LootHandler_getUsableSlotsForItemEquipLoc(itemEquipLoc)
    if itemEquipLoc == "INVTYPE_HEAD" then return {1} end
    if itemEquipLoc == "INVTYPE_NECK" then return {2} end
    if itemEquipLoc == "INVTYPE_SHOULDER" then return {3} end
    if itemEquipLoc == "INVTYPE_CHEST" or itemEquipLoc == "INVTYPE_ROBE" then return {5} end
    if itemEquipLoc == "INVTYPE_WAIST" then return {6} end
    if itemEquipLoc == "INVTYPE_LEGS" then return {7} end
    if itemEquipLoc == "INVTYPE_FEET" then return {8} end
    if itemEquipLoc == "INVTYPE_WRIST" then return {9} end
    if itemEquipLoc == "INVTYPE_HAND" then return {10} end
    if itemEquipLoc == "INVTYPE_FINGER" then return {11, 12} end
    if itemEquipLoc == "INVTYPE_TRINKET" then return {13, 14} end
    if itemEquipLoc == "INVTYPE_CLOAK" then return {15} end
    if itemEquipLoc == "INVTYPE_WEAPON" then return {16, 17} end
    if itemEquipLoc == "INVTYPE_2HWEAPON" or itemEquipLoc == "INVTYPE_WEAPONMAINHAND" then return {16} end
    if itemEquipLoc == "INVTYPE_SHIELD" or itemEquipLoc == "INVTYPE_WEAPONOFFHAND" or itemEquipLoc == "INVTYPE_HOLDABLE" then return {17} end
    if itemEquipLoc == "INVTYPE_RANGED" or itemEquipLoc == "INVTYPE_RANGEDRIGHT" or itemEquipLoc == "INVTYPE_THROWN" or itemEquipLoc == "INVTYPE_RELIC" then return {18} end
end

function mb_LootHandler_getGoodStatName(badStatName)
    -- Base stats
    if badStatName == "ITEM_MOD_AGILITY_SHORT" then return "agility" end
    if badStatName == "ITEM_MOD_INTELLECT_SHORT" then return "intellect" end
    if badStatName == "ITEM_MOD_SPIRIT_SHORT" then return "spirit" end
    if badStatName == "ITEM_MOD_STRENGTH_SHORT" then return "strength" end
    if badStatName == "ITEM_MOD_STAMINA_SHORT" then return "stamina" end

    -- Ratings
    if badStatName == "ITEM_MOD_CRIT_RATING_SHORT" then return "critRating" end
    if badStatName == "ITEM_MOD_RESILIENCE_RATING_SHORT" then return "resilienceRating" end
    if badStatName == "ITEM_MOD_DEFENSE_SKILL_RATING_SHORT" then return "defenseRating" end
    if badStatName == "ITEM_MOD_EXPERTISE_RATING_SHORT" then return "expertiseRating" end
    if badStatName == "ITEM_MOD_DODGE_RATING_SHORT" then return "dodgeRating" end
    if badStatName == "ITEM_MOD_PARRY_RATING_SHORT" then return "parryRating" end
    if badStatName == "ITEM_MOD_BLOCK_RATING_SHORT" then return "blockRating" end
    if badStatName == "ITEM_MOD_ARMOR_PENETRATION_RATING_SHORT" then return "armorPenetrationRating" end
    if badStatName == "ITEM_MOD_HIT_RATING_SHORT" then return "hitRating" end
    if badStatName == "ITEM_MOD_HASTE_RATING_SHORT" then return "hasteRating" end

    -- Others
    if badStatName == "ITEM_MOD_ATTACK_POWER_SHORT" then return "attackPower" end
    if badStatName == "RESISTANCE0_NAME" then return "armor" end
    if badStatName == "ITEM_MOD_BLOCK_VALUE_SHORT" then return "blockValue" end
    if badStatName == "ITEM_MOD_SPELL_POWER_SHORT" then return "spellPower" end
    if badStatName == "ITEM_MOD_MANA_REGENERATION_SHORT" then return "mp5" end
    if badStatName == "ITEM_MOD_POWER_REGEN0_SHORT" then return "mp5" end
    if badStatName == "ITEM_MOD_DAMAGE_PER_SECOND_SHORT" then return "dps" end

    -- Sockets
    if badStatName == "EMPTY_SOCKET_META" then return "socketMeta" end
    if badStatName == "EMPTY_SOCKET_RED" then return "socketColored" end
    if badStatName == "EMPTY_SOCKET_BLUE" then return "socketColored" end
    if badStatName == "EMPTY_SOCKET_YELLOW" then return "socketColored" end

    return nil
end

function mb_LootHandler_canEquipItem(itemSubType)
    local myClass = UnitClass("player")
    local mySpec = mb_getMySpecName()
    if itemSubType == "Plate" then
        if myClass == "Paladin" or myClass == "Warrior" or myClass == "Deathknight" then
            return true
        end
        return false
    end
    if itemSubType == "Mail" then
        if myClass == "Paladin" or myClass == "Warrior" or myClass == "Deathknight" or myClass == "Shaman" or myClass == "Hunter" then
            return true
        end
        return false
    end
    if itemSubType == "Leather" then
        if myClass == "Mage" or myClass == "Warlock" or myClass == "Priest" then
            return false
        end
        return true
    end
    return true
end



