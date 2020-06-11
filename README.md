# MaloWBotLK
3.3.5 version of MaloWBot, very barebones atm, only supported class/spec is Ret Paladin, and that is just barely supported

Has OnLoad and OnUpdate functions for each class (which if you're using LuaUnlock you can use to cast spells through etc.)

Has a system to handle chat commands through /mb X

Has a system to handle sending and receiving messages between characters. To send a message use mb_sendMessage(msgType, msg), and how to receieve a message see MessageHandlers.lua

Currently has a hard-coded check that realm-name is "LichKingMBW", and the addon is disabled if it's not. This is because I don't want to have it running when I play on other realms.

In order for the bot to start running mb_enabled needs to be set to true (it's by default false since I don't want it to run immediately when I log in. One way to get it running is to have a macro '/run mb_initAsLeader()' on your main character. This will set everyone else in your raid to follow your main character, and it will set the mb_enabled to true for them all as well.
