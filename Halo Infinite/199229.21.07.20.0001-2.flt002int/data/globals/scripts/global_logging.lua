-- Copyright (c) Microsoft. All rights reserved.
--   _______  __        ______   .______        ___       __          __        ______     _______   _______  __  .__   __.   _______ 
--  /  _____||  |      /  __  \  |   _  \      /   \     |  |        |  |      /  __  \   /  _____| /  _____||  | |  \ |  |  /  _____|
-- |  |  __  |  |     |  |  |  | |  |_)  |    /  ^  \    |  |        |  |     |  |  |  | |  |  __  |  |  __  |  | |   \|  | |  |  __  
-- |  | |_ | |  |     |  |  |  | |   _  <    /  /_\  \   |  |        |  |     |  |  |  | |  | |_ | |  | |_ | |  | |  . `  | |  | |_ | 
-- |  |__| | |  `----.|  `--'  | |  |_)  |  /  _____  \  |  `----.   |  `----.|  `--'  | |  |__| | |  |__| | |  | |  |\   | |  |__| | 
--  \______| |_______| \______/  |______/  /__/     \__\ |_______|   |_______| \______/   \______|  \______| |__| |__| \__|  \______| 
--                                                                                                                                    
--
-- =================================================================================================
-- Logging (SERVER and CLIENT)
-- =================================================================================================

global k_logCategories =
{
	Uncategorized = 0,
	Print = 1,
	Slayer = 2,
	CaptureArea = 3,
};

function Log_Verbose(category, ...)
	Log_Print(category, EVENT.verbose, unpack(arg));
end

function Log_Message(category, ...)
	Log_Print(category, EVENT.message, unpack(arg));
end

function Log_Warning(category, ...)
	Log_Print(category, EVENT.warning, unpack(arg));
end

function Log_Error(category, ...)
	Log_Print(category, EVENT.error, unpack(arg));
end
