# MaloWBotLK
3.3.5 version of MaloWBot, very barebones atm

Has OnLoad and OnUpdate functions for each (which if you're using LuaUnlock you can use to cast spells through etc.)

Has a system to handle chat commands through /mb X

Has a system to handle sending and receiving messages between characters. To send a message see MaloWBotLK.lua line 120, and how to receieve a message see classes/Paladin.lua

Currently has a hard-coded check that realm-name is "LichKingMBW", and the addon is disabled if it's not. This is because I don't want to have it running when I play on other realms.
