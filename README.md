# MaloWBotLK
3.3.5 version of MaloWBot, very barebones atm, only supported class/spec is Ret Paladin, and that is just barely supported

Has OnLoad and OnUpdate functions for each class (which if you're using LuaUnlock you can use to cast spells through etc.)

Has a system to handle chat commands through /mb X

Has a system to handle sending and receiving messages between characters. To send a message use mb_sendMessage(msgType, msg), and how to receieve a message see MessageHandlers.lua

Currently has a hard-coded check that realm-name is "LichKingMBW", and the addon is disabled if it's not. This is because I don't want to have it running when I play on other realms.
