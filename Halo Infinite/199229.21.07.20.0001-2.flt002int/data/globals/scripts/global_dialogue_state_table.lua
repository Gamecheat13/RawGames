-- preprocess
-- Copyright (c) Microsoft. All rights reserved.

--[[*****************************************************************************************************************
  ____  _       _                          ____  _        _         _____     _     _        _  __                   
 |  _ \(_) __ _| | ___   __ _ _   _  ___  / ___|| |_ __ _| |_ ___  |_   _|_ _| |__ | | ___  | |/ /___ _   _ ___      
 | | | | |/ _` | |/ _ \ / _` | | | |/ _ \ \___ \| __/ _` | __/ _ \   | |/ _` | '_ \| |/ _ \ | ' // _ \ | | / __|     
 | |_| | | (_| | | (_) | (_| | |_| |  __/  ___) | || (_| | ||  __/   | | (_| | |_) | |  __/ | . \  __/ |_| \__ \     
 |____/|_|\__,_|_|\___/ \__, |\__,_|\___| |____/ \__\__,_|\__\___|   |_|\__,_|_.__/|_|\___| |_|\_\___|\__, |___/     
                        |___/                                                                         |___/          
*******************************************************************************************************************]]

global DialogueStateTable:table = {
	-- for testing
	{ name = "TestA",								type = PERSISTENCE_KEY_TYPE.Bool },
	{ name = "TestB",								type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "TestC",								type = PERSISTENCE_KEY_TYPE.Long },

--We USED TO need this, but hopefully we don't need to rely on this any longer and can just use numeric constants in expressions!	
----[[********************************************************************************************************************************************
--	numeric values need to be stored as constants in order to be evaluated in expressions
--************************************************************************************************************************************************  ]]--
--	{ name = "constant_0",							type = PERSISTENCE_KEY_TYPE.Byte },
--	{ name = "constant_1",							type = PERSISTENCE_KEY_TYPE.Byte },
--	{ name = "constant_2",							type = PERSISTENCE_KEY_TYPE.Byte },
--	{ name = "constant_3",							type = PERSISTENCE_KEY_TYPE.Byte },
--	{ name = "constant_4",							type = PERSISTENCE_KEY_TYPE.Byte },
--	{ name = "constant_5",							type = PERSISTENCE_KEY_TYPE.Byte },

--[[**************************************************************************************
	Open World Dominion Theme Context
****************************************************************************************** ]]--
	{ name = "world_context_dominion",				type = PERSISTENCE_KEY_TYPE.Byte },
	
--[[**************************************************************************************
	Open World POI Categorical Theme Context
****************************************************************************************** ]]--
--Unused after converting over to specific Linear Mission POI values, but still possible to setup for and use with functions, with use of strings or different scripted parameters
	{ name = "world_context_poi_aa_gun",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_armory",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_communications",	type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_fortress",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_garrison",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_motor_pool",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_power_node",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_prison",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_refinery",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_poi_spire",				type = PERSISTENCE_KEY_TYPE.Byte },

	{ name = "world_context_unsc_fob",				type = PERSISTENCE_KEY_TYPE.Byte },
	
--[[**************************************************************************************
	Linear Mission Specific POI Context
****************************************************************************************** ]]--
	{ name = "world_context_m01_banished",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m02_underbelly",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m03_pilotbase",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m04_prison",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m05_digsite",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m06_conservatory",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m07_spire01",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m08_aaguns",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m09_towers",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m10_nexus",				type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m11_spire02",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m12_forerunner",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m15_bosshq",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_m16_auditorium",		type = PERSISTENCE_KEY_TYPE.Byte },

--[[**************************************************************************************
	Open World Outpost Specific POI Context
****************************************************************************************** ]]--
	{ name = "world_context_out_baboon",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_marmoset",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_mandrill",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_silverback",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_bonobo",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_gibbon",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "world_context_out_howler",			type = PERSISTENCE_KEY_TYPE.Byte },


--[[**************************************************************************************
	 Open World Custom Theme Context
****************************************************************************************** ]]--
	-- TBD
	
--[[********************************************************************************************************************************************
	Based on Persistence Key data tracked by Dialog State Manager Script:
--************************************************************************************************************************************************  ]]--

--[[**************************************************************************************
	Linear Mission Local Progress
****************************************************************************************** ]]--
	{ name = "local_progress_m01_banished",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m02_underbelly",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m03_pilotbase",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m04_prison",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m05_digsite",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m06_conservatory",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m07_spire01",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m08_aaguns",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m09_towers",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m10_nexus",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m11_spire02",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m12_forerunner",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m15_bosshq",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_m16_auditorium",		type = PERSISTENCE_KEY_TYPE.Byte },

--[[**************************************************************************************
	Open World Outpost Local Progress
****************************************************************************************** ]]--
	{ name = "local_progress_out_baboon",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_marmoset",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_mandrill",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_silverback",		type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_bonobo",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_gibbon",			type = PERSISTENCE_KEY_TYPE.Byte },
	{ name = "local_progress_out_howler",			type = PERSISTENCE_KEY_TYPE.Byte },

	-- FOBss tracked as a larger world set
	{ name = "world_progress_unsc_fobs",			type = PERSISTENCE_KEY_TYPE.Byte },

--[[**************************************************************************************
	Player Threat based on overall Open World Content Completion
****************************************************************************************** ]]--
	-- TBD

--[[**************************************************************************************
	Current-Dominion Progress based on completed content within each individual Dominion
****************************************************************************************** ]]--
	-- TBD

--[[**************************************************************************************
	Overall Campaign Progress based on completion of Major campaign milestones across all Dominions
****************************************************************************************** ]]--
	-- TBD

}