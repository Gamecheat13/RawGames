-- Copyright (c) Microsoft. All rights reserved.

--[[**************************************************************************************************************************************************************************************
 ______   ___   _______  ___      _______  _______  __   __  _______      _______  _______  _______  _______  _______      __   __  _______  __    _  _______  _______  _______  ______   
|      | |   | |   _   ||   |    |       ||       ||  | |  ||       |    |       ||       ||   _   ||       ||       |    |  |_|  ||   _   ||  |  | ||   _   ||       ||       ||    _ |  
|  _    ||   | |  |_|  ||   |    |   _   ||    ___||  | |  ||    ___|    |  _____||_     _||  |_|  ||_     _||    ___|    |       ||  |_|  ||   |_| ||  |_|  ||    ___||    ___||   | ||  
| | |   ||   | |       ||   |    |  | |  ||   | __ |  |_|  ||   |___     | |_____   |   |  |       |  |   |  |   |___     |       ||       ||       ||       ||   | __ |   |___ |   |_||_ 
| |_|   ||   | |       ||   |___ |  |_|  ||   ||  ||       ||    ___|    |_____  |  |   |  |       |  |   |  |    ___|    |       ||       ||  _    ||       ||   ||  ||    ___||    __  |
|       ||   | |   _   ||       ||       ||   |_| ||       ||   |___      _____| |  |   |  |   _   |  |   |  |   |___     | ||_|| ||   _   || | |   ||   _   ||   |_| ||   |___ |   |  | |
|______| |___| |__| |__||_______||_______||_______||_______||_______|    |_______|  |___|  |__| |__|  |___|  |_______|    |_|   |_||__| |__||_|  |__||__| |__||_______||_______||___|  |_|

**************************************************************************************************************************************************************************************]]--

--## SERVER

--startup the Dialogue State Manager systems
function startup.DialogueStateManager()
	DomEnumStringMapper();
	WorldPersistenceListener();
	DominionVolumeWatcher();
--We USED TO need this, but hopefully we don't need to rely on this any longer and can just use numeric constants in expressions!	
--	DSTNumericConstantSetter()
end

--We USED TO need this, but hopefully we don't need to rely on this any longer and can just use numeric constants in expressions!	
----[[********************************************************************************************************************************************
--Dialogue State Table needs to store Numeric Values as Constants in Keys, so they can be used in comparative Expresesions against DST Keys
--************************************************************************************************************************************************  ]]--
--function DSTNumericConstantSetter():void
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_0"), 0);
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_1"), 1);
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_2"), 2);
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_3"), 3);
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_4"), 4);
--	DialogueState_SetByteKey(DIALOGUESTATE_KEY("constant_5"), 5);
--end

--[[********************************************************************************************************************************************
Global Table to map DominionEnums to strings for SetDominionDialogContext
************************************************************************************************************************************************  ]]--
global ow_dom_enum_string_map:table = {};

function DomEnumStringMapper():void
	ow_dom_enum_string_map[DominionEnum.none] = "None";
	ow_dom_enum_string_map[DominionEnum.green] = "Green";
	ow_dom_enum_string_map[DominionEnum.green_digsite] = "Green";
	ow_dom_enum_string_map[DominionEnum.yellow] = "Yellow";
	ow_dom_enum_string_map[DominionEnum.yellow_aagun] = "Yellow";
	ow_dom_enum_string_map[DominionEnum.red] = "Red";
end

--[[********************************************************************************************************************************************
Global Tables for use in mapping Open World contextual Data to State Table Key Values
************************************************************************************************************************************************  ]]--
global ow_dom_dialogue_context_map:table = {
	None = 0,
	Green = 1,
	Yellow = 2,
	Red = 3,
	Antigonum = 1,
	Regalium = 2,
	Escharum = 3,
}

--poi persistence keys mapped to Dialogue State Keys, to be taken in from the mission manager sending a mission name
global ow_poi_dialogue_context_map:table = {
	["Dungeon-BanishedShip"]	 = {context = "world_context_m01_banished",		 progress = "local_progress_m01_banished"},
	["Dungeon-Underbelly"]		 = {context = "world_context_m02_underbelly",	 progress = "local_progress_m02_underbelly"},
	["poi_green_pilot_base"]	 = {context = "world_context_m03_pilotbase",	 progress = "local_progress_m03_pilotbase"},
	["poi_green_prison"]		 = {context = "world_context_m04_prison",		 progress = "local_progress_m04_prison"},
	["poi_green_refinery"]		 = {context = "world_context_m05_digsite",		 progress = "local_progress_m05_digsite"},
	["poi_forerunner_dallas"]	 = {context = "world_context_m06_conservatory",	 progress = "local_progress_m06_conservatory"},
	["poi_green_spire"]			 = {context = "world_context_m07_spire01",		 progress = "local_progress_m07_spire01"},
	["poi_forerunner_tower_main_mission"]	 = {context = "world_context_m09_towers",		 progress = "local_progress_m09_towers"},
	["poi_base_aa_island"]		 = {context = "world_context_m08_aaguns",		 progress = "local_progress_m08_aaguns"},
	["poi_forerunner_houston"]	 = {context = "world_context_m10_nexus",		 progress = "local_progress_m10_nexus"},
	["poi_yellow_spire"]		 = {context = "world_context_m11_spire02",		 progress = "local_progress_m11_spire02"},
	["poi_forerunner_austin"]	 = {context = "world_context_m12_forerunner",	 progress = "local_progress_m12_forerunner"},
	["poi_boss_hq_interior"]	 = {context = "world_context_m15_bosshq",		 progress = "local_progress_m15_bosshq"},
	["poi_cortana_palace"]		 = {context = "world_context_m16_auditorium",	 progress = "local_progress_m16_auditorium"},
	["poi_outpost_bonobo"]		 = {context = "world_context_out_bonobo",		 progress = "local_progress_out_bonobo"},
	["poi_outpost_baboon"]		 = {context = "world_context_out_baboon",		 progress = "local_progress_out_baboon"},
	["poi_outpost_marmoset"]	 = {context = "world_context_out_marmoset",		 progress = "local_progress_out_marmoset"},
	["poi_outpost_silverback"]	 = {context = "world_context_out_silverback",	 progress = "local_progress_out_silverback"},
	["poi_outpost_mandrill"]	 = {context = "world_context_out_mandrill",		 progress = "local_progress_out_mandrill"},
	["poi_outpost_gibbon"]		 = {context = "world_context_out_gibbon",		 progress = "local_progress_out_gibbon"},
	["poi_outpost_howler"]		 = {context = "world_context_out_howler",		 progress = "local_progress_out_howler"},

	["poi_unsc_fob"]			 = {context = "world_context_unsc_fob",			 progress = "world_progress_unsc_fobs"},
}

--providing aliases to point specific persistence Key strings at others for special cases where we want to consolidate keys into a single handle for POI context, such as forerunner towers.
global ow_poi_dialogue_context_persKey_aliases:table = {
	["poi_forerunner_north"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["poi_forerunner_south"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["poi_forerunner_east"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["poi_forerunner_west"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["tower_forerunner_north"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["tower_forerunner_south"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["tower_forerunner_east"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
	["tower_forerunner_west"]	 = "poi_forerunner_tower_main_mission", --this is specifically to catch the POI Persistence Keys for individual Towers coming in via mission manager and map them to a single world_context Key
}

--providing some string aliases for the different poi dialogue context strings for manual entry into the functions for testing and catching places where we might fire manually with data
global ow_poi_dialogue_context_aliases:table = {
	M02_Underbelly							= "Dungeon-Underbelly",		 --these may be provided as scriptable parameter strings in activator volume kit
	M03_PilotBase							= "poi_green_pilot_base",		 --these may be provided as scriptable parameter strings in activator volume kit
	M04_Prison								= "poi_green_prison",			 --these may be provided as scriptable parameter strings in activator volume kit
	M05_DigSite								= "poi_green_refinery",		 --these may be provided as scriptable parameter strings in activator volume kit
	M06_Conservatory						= "poi_forerunner_dallas",	 --these may be provided as scriptable parameter strings in activator volume kit
	M06_Dallas								= "poi_forerunner_dallas",	 --these may be provided as scriptable parameter strings in activator volume kit
	M07_Spire01								= "poi_green_spire",			 --these may be provided as scriptable parameter strings in activator volume kit
	M08_AAGuns								= "poi_base_aa_island",		 --these may be provided as scriptable parameter strings in activator volume kit
	M09_Towers								= "poi_forerunner_tower_main_mission", --these may be provided as scriptable parameter strings in activator volume kit
	M09_Tower_North							= "poi_forerunner_tower_main_mission",
	M09_Tower_South							= "poi_forerunner_tower_main_mission",
	M09_Tower_East							= "poi_forerunner_tower_main_mission",
	M09_Tower_West							= "poi_forerunner_tower_main_mission",
	M10_Nexus								= "poi_forerunner_houston",	 --these may be provided as scriptable parameter strings in activator volume kit
	M10_Houston								= "poi_forerunner_houston",	 --these may be provided as scriptable parameter strings in activator volume kit
	M11_Spire02								= "poi_yellow_spire",			 --these may be provided as scriptable parameter strings in activator volume kit
	M12_Forerunner							= "poi_forerunner_austin",	 --these may be provided as scriptable parameter strings in activator volume kit
	M12_Repository							= "poi_forerunner_austin",	 --these may be provided as scriptable parameter strings in activator volume kit
	M12_Austin								= "poi_forerunner_austin",	 --these may be provided as scriptable parameter strings in activator volume kit
	M15_BossHQ								= "poi_boss_hq_interior",		 --these may be provided as scriptable parameter strings in activator volume kit
	M16_Auditorium							= "poi_cortana_palace",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Baboon							= "poi_outpost_baboon",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Marmoset						= "poi_outpost_marmoset",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Mandrill						= "poi_outpost_mandrill",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Silverback						= "poi_outpost_silverback",	 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Bonobo							= "poi_outpost_bonobo",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Gibbon							= "poi_outpost_gibbon",		 --these may be provided as scriptable parameter strings in activator volume kit
	Outpost_Howler							= "poi_outpost_howler",		 --these may be provided as scriptable parameter strings in activator volume kit
	UNSC_FOB								= "poi_unsc_fob",			 --these may be provided as scriptable parameter strings in fob kit or activator volume kit
	Dungeon_Dallas							= "poi_forerunner_dallas",
	Dungeon_Houston							= "poi_forerunner_houston",
	Dungeon_Austin							= "poi_forerunner_austin",
	Dungeon_BanishedShip					= "Dungeon-BanishedShip",
	Dungeon_Underbelly						= "Dungeon-Underbelly",
--	['Dungeon-BanishedShip']				= "Dungeon-BanishedShip",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	['Dungeon-Underbelly']					= "Dungeon-Underbelly",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_green_pilot_base					= "poi_green_pilot_base",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_green_prison						= "poi_green_prison",			 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_green_refinery						= "poi_green_refinery",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_forerunner_dallas					= "poi_forerunner_dallas",	 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_green_spire							= "poi_green_spire",			 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_base_aa_island						= "poi_base_aa_island",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_forerunner_tower_main_mission		= "poi_forerunner_tower_main_mission", --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
	poi_forerunner_towers					= "poi_forerunner_tower_main_mission", --common mistaken assumption of main mission persistence key
	poi_forerunner_tower_north				= "poi_forerunner_tower_main_mission", --common mistaken assumption of tower persistence key
	poi_forerunner_tower_south				= "poi_forerunner_tower_main_mission", --common mistaken assumption of tower persistence key
	poi_forerunner_tower_east				= "poi_forerunner_tower_main_mission", --common mistaken assumption of tower persistence key
	poi_forerunner_tower_west				= "poi_forerunner_tower_main_mission", --common mistaken assumption of tower persistence key
--	poi_forerunner_houston					= "poi_forerunner_houston",	 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_yellow_spire						= "poi_yellow_spire",			 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_forerunner_austin					= "poi_forerunner_austin",	 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_boss_hq_interior					= "poi_boss_hq_interior",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_cortana_palace						= "poi_cortana_palace",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_baboon						= "poi_outpost_baboon",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_marmoset					= "poi_outpost_marmoset",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_mandrill					= "poi_outpost_mandrill",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_silverback					= "poi_outpost_silverback",	 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_bonobo						= "poi_outpost_bonobo",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_gibbon						= "poi_outpost_gibbon",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
--	poi_outpost_howler						= "poi_outpost_howler",		 --this is specifically to catch a string version of the PersKey sent by ProgressLocalMission() in global_dialougue_state_conditions
	poi_dungeon_banishedship				= "Dungeon-BanishedShip",
	poi_dungeon_underbelly					= "Dungeon-Underbelly",
	m01										= "Dungeon-BanishedShip",		 --commonly used for debugging/testing
	m02										= "Dungeon-Underbelly",		 --commonly used for debugging/testing
	m03										= "poi_green_pilot_base",		 --commonly used for debugging/testing
	m04										= "poi_green_prison",			 --commonly used for debugging/testing
	m05										= "poi_green_refinery",		 --commonly used for debugging/testing
	m06										= "poi_forerunner_dallas",	 --commonly used for debugging/testing
	m07										= "poi_green_spire",			 --commonly used for debugging/testing
	m08										= "poi_base_aa_island",		 --commonly used for debugging/testing
	m09										= "poi_forerunner_tower_main_mission", --commonly used for debugging/testing
	m10										= "poi_forerunner_houston",	 --commonly used for debugging/testing
	m11										= "poi_yellow_spire",			 --commonly used for debugging/testing
	m12										= "poi_forerunner_austin",	 --commonly used for debugging/testing
	m15										= "poi_boss_hq_interior",		 --commonly used for debugging/testing
	m16										= "poi_cortana_palace",		 --commonly used for debugging/testing
	banished								= "Dungeon-BanishedShip",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	underbelly								= "Dungeon-Underbelly",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	pilot_base								= "poi_green_pilot_base",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	prison									= "poi_green_prison",			 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	digsite									= "poi_green_refinery",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	conservatory							= "poi_forerunner_dallas",	 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	dallas									= "poi_forerunner_dallas",
	spire01									= "poi_green_spire",			 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	green_spire								= "poi_green_spire",			 --commonly used for debugging/testing, World team/Actual Content name
	antiaircraft							= "poi_base_aa_island",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	aaguns									= "poi_base_aa_island",		 --commonly used for debugging/testing, Alternate to Narrative Name
	aaisland								= "poi_base_aa_island",		 --commonly used for debugging/testing, Alternate to Narrative Name
	towers									= "poi_forerunner_tower_main_mission", --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	tower_north								= "poi_forerunner_tower_main_mission",
	tower_south								= "poi_forerunner_tower_main_mission",
	tower_east								= "poi_forerunner_tower_main_mission",
	tower_west								= "poi_forerunner_tower_main_mission",
	forerunner_towers						= "poi_forerunner_tower_main_mission", --commonly used for debugging/testing, Alternate to Narrative Name
	forerunner_north						= "poi_forerunner_tower_main_mission",
	forerunner_south						= "poi_forerunner_tower_main_mission",
	forerunner_east							= "poi_forerunner_tower_main_mission",
	forerunner_west							= "poi_forerunner_tower_main_mission",
	nexus									= "poi_forerunner_houston",	 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	houston									= "poi_forerunner_houston",
	spire02									= "poi_yellow_spire",			 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	yellow_spire							= "poi_yellow_spire",			 --commonly used for debugging/testing, World team/Actual Content name
	forerunner								= "poi_forerunner_austin",	 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	repository								= "poi_forerunner_austin",	 --commonly used for debugging/testing, Alternate to Narrative Name
	austin									= "poi_forerunner_austin",
	banished_base							= "poi_boss_hq_interior",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	bossHQ									= "poi_boss_hq_interior",		 --commonly used for debugging/testing, World team/Actual Content name
	auditorium								= "poi_cortana_palace",		 --commonly used for debugging/testing, Narrative's name for mission in scripts/Gamma
	cortana_palace							= "poi_cortana_palace",		 --commonly used for debugging/testing, World team/Actual Content name
	baboon									= "poi_outpost_baboon",		 --commonly used for debugging/testing
	marmoset								= "poi_outpost_marmoset",		 --commonly used for debugging/testing
	mandrill								= "poi_outpost_mandrill",		 --commonly used for debugging/testing
	silverback								= "poi_outpost_silverback",	 --commonly used for debugging/testing
	bonobo									= "poi_outpost_bonobo",		 --commonly used for debugging/testing
	gibbon									= "poi_outpost_gibbon",		 --commonly used for debugging/testing
	howler									= "poi_outpost_howler",		 --commonly used for debugging/testing
	fob										= "poi_unsc_fob",			 --commonly used for debugging/testing
	unsc									= "poi_unsc_fob",			 --commonly used for debugging/testing
	unscfob									= "poi_unsc_fob",			 --commonly used for debugging/testing
}

--[[********************************************************************************************
Registering to the Dialogue State Refresh Event fired in Code when The World Persistence System is updated
************************************************************************************************ ]]--
function WorldPersistenceListener()
	RegisterGlobalEvent(g_eventTypes.dialogueStateTableRefreshEvent, DialogueStateConditionsCheck);
end


--[[********************************************************************************************
Registering to Events for entering Dominion activation volumes for setting AI Dialogue Context
	This is called in startup scripts for island01, to start listening for players entering/exiting dominion activation volumes, and fire off the appropriate Dialogue functions when they are triggered.
************************************************************************************************ ]]--

function DominionVolumeWatcher()
	local domTable:table = GetDominionTable();
	if domTable ~= nil then
		for domEnum, domVolumesTable in hpairs(domTable) do
			if GetEngineType(domVolumesTable) == "table" then
				for _, tableVolume in ipairs(domVolumesTable) do
					RegisterEvent(g_eventTypes.activationVolumePlayerEnteredEvent, DominionVolumeTrigger, tableVolume, domEnum, "volume");
					RegisterEvent(g_eventTypes.activationVolumePlayerExitedEvent, DominionVolumeTriggerLeader, tableVolume, domEnum);
				end
			end
		end
	end
end

--[[********************************************************************************************************************************************
Callback Functions for passing DominionEnum from an entered/exited Dominion Activation Volume into a string value for SetDominionDialogueContext
************************************************************************************************************************************************  ]]--

--1. Used on Enter, when we have event data from the player and volume entered from the Event -- Use the Dominion Enum from the volume entered by the player
function DominionVolumeTrigger(eventParams, domEnum, trigger:string)
	SetDominionDialogueContext(ow_dom_enum_string_map[domEnum], trigger);
end

--2. Used on Exit or when the Entering Player Data is unavailable -- Use the Dominion Enum of the player's FireTeam leader, even if that is themselves, and the value returns as "None".
--(If the FireTeam Leader is dead, use the player who triggered the event, or else do nothing)
function DominionVolumeTriggerLeader(eventParams, domEnum)
	local leaderPlayer = GetFireTeamLeader();
	--make sure the fireteam leader is alive before setting context based on their dominion
	if object_get_health(leaderPlayer) > 0 then
		--get the dominion enum of the entering/exiting player's fireteam leader
		local dominion:number = GetPlayerDominion(leaderPlayer);
		--set Dominion Context Theme to the Dominion of the fireteam leader
		SetDominionDialogueContext(ow_dom_enum_string_map[dominion], "leader");
	--if the fireteam leader IS dead, try to use the player who triggered the event, even if the volume returns as "None".
	elseif eventParams ~= nil then
		--get the player data from the event
		local triggeringPlayer = eventParams.player;
		--get the dominion enum of the entering/exiting player
		local dominion:number = GetPlayerDominion(triggeringPlayer);
		--set Dominion Context Theme to the Dominion of the player who triggered the event
		SetDominionDialogueContext(ow_dom_enum_string_map[dominion], "exitplayer");
	--if the fireteam leader is dead and the triggering player is not available (not available when fired from POI activation volumes), leave the context alone and let it resolve when the next player enters/exits a POI or dominion volume
	else
		if DialogueState_debug == 1 then
			print ("No living Fireteam Leader, or Triggering Player data to query Dominion Volume from. Leaving Key 'dominion_context_theme' alone.");
		end
	end
end


--[[********************************************************************************************************************************************
Debug Functions to enable/disable debugging of Dialogue State Manager and Conditions by gating print statements in relevent functions
************************************************************************************************************************************************  ]]--
global DialogueState_debug = 0;

function DialogueState_debug_enable():void
	if	DialogueState_debug ~= 1 then
		DialogueState_debug = 1;
		print ("Now Debugging Dialogue State Manager and Dialogue State Conditions Global scripts. Print Statements ahoy!");
	elseif 	DialogueState_debug == 1 then
		print ("Dialogue State Manager Debugging already enabled.");
	end
end

function DialogueState_debug_disable():void
	if	DialogueState_debug ~= 0 then
		print ("No longer Debugging Dialogue State Manager and Dialogue State Conditions.  Enjoy the Silence.");
		DialogueState_debug = 0;
	elseif 	DialogueState_debug == 0 then
		print ("Dialogue State Manager Debugging already disabled.");
	end
end


--[[********************************************************************************************************************************************
Callback Functions for passing poiDialogContext from an entered/exited POI Activation Volume into a string value for SetPoiDialogueContext
************************************************************************************************************************************************  ]]--

--1. Used on Enter, where we only want to Increment POI Dialogue Context for the first player in Fireteam to enter the volume, and not if someone else is already inside and has incremented it by 1.
function PoiVolumeTriggerEnter(poiDialogContext:string, volume:activation_volume)
	SetPoiDialogueContext(poiDialogContext, "activation_volume_enter")
	if DialogueState_debug == 1 then
		print ("Player entered POI Volume. Volume context '", poiDialogContext, "'")
	end
	FollowMarinesPoiComment(volume); --additionally this fires an event on any following marines to let them know you've entered an area with ...things inside.
end

--2. Used on Exit, which should only trigger if all players in Fireteam have existed the volume, so the context can be safely decremented by 1.
function PoiVolumeTriggerExit(poiDialogContext:string)
	SetPoiDialogueContext(poiDialogContext, "activation_volume_exit")
end


--[[********************************************************************************************************************************************
Global functions for tracking Open World Contextual Data for Dialogue Filtering
	poi_context string value must exist in 'ow_poi_dialogue_context_map' table above with a valid context dialogue state key, or point to something that does via 'ow_poi_dialogue_context_aliases' table.
************************************************************************************************************************************************  ]]--

--Increment Poi Dialogue Context, set with a STRING from Debug, a Scriptable Parameter on an Activation Volume, or any other direct-script method, to convert through tables to an appropriate valid string or Persistence Key.
function SetPoiDialogueContext(poi_context:string, trigger:string)
	local triggerString = "Unknown Source";
	local contextKey = nil
	
	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		contextKey = ow_poi_dialogue_context_map[poi_context].context;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	end

	if contextKey == nil then
		if DialogueState_debug == 1 then
			print ("No Dialogue State Key defined for provided POI type '",poi_context,"'.  Not updating POI Dialogue Context Keys.");
		end
	else
		local contextValue = GetDialogueState(contextKey);
		if trigger == "activation_volume_exit" then
			triggerString = "Last Team Player exiting POI Activation Volume";
			if DialogueState_debug == 1 then
				print ("Removing POI Dialogue Context via ",triggerString,":");
				print ("  - '",poi_context,"' provided.  Decrementing Key '",contextKey,"' from",contextValue,"to",(contextValue-1),".");
			end
			SetDialogueState(contextKey, (contextValue-1));
		elseif trigger == "activation_volume_enter" then
			triggerString = "First Team Player entering POI Activation Volume";
			if DialogueState_debug == 1 then
				print ("Activating a POI Dialogue Context from ",triggerString,":");
				print ("  - '",poi_context,"' provided.  Incrementing Key '",contextKey,"' from",contextValue,"to",(contextValue+1),".");
			end
			SetDialogueState(contextKey, (contextValue+1));
		else
			if DialogueState_debug == 1 then
				print ("Activating a POI Dialogue Context from ",triggerString,":");
				print ("  - String '",poi_context,"' provided.  Incrementing Key '",contextKey,"' from",contextValue,"to",(contextValue+1),".");
			end
			SetDialogueState(contextKey, (contextValue+1));
		end
	end
end

--Context can be set with a PERSISTENCE KEY as the direct input instead of a string, but requires that the provided PersKey is a key in the 'ow_dialogue_context_map', or in the alias table to point to one that is.
function SetPoiDialogueContext_from_Key(poi_context:persistence_key, trigger:string)
	local triggerString = "Unknown Source";
	local contextKey = nil
	local keyString = Persistence_GetStringIdFromKey(poi_context)

	local ow_poi_dialogue_context_map_toKeys:table = {};
	for tableString, tableKeys in hpairs(ow_poi_dialogue_context_map) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_map_toKeys[Persistence_TryCreateKeyFromString(tableString)] = tableKeys;
		end
	end

	local ow_poi_dialogue_context_persKey_aliases_toKeys:table = {};
	for tableString, tableAlias in hpairs(ow_poi_dialogue_context_persKey_aliases) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_persKey_aliases_toKeys[Persistence_TryCreateKeyFromString(tableString)] = Persistence_TryCreateKeyFromString(tableAlias);
		end
	end

	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		contextKey = ow_poi_dialogue_context_map[poi_context].context;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	elseif ow_poi_dialogue_context_map_toKeys[poi_context] ~= nil then
		contextKey = ow_poi_dialogue_context_map_toKeys[poi_context].context;
	elseif ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context];
		contextKey = ow_poi_dialogue_context_map_toKeys[contextKeyAlias].context;
	end

	if contextKey == nil then
		if DialogueState_debug == 1 then
			print ("No Dialogue State Key defined for POI Persistence Key '",keyString,"'. Not updating POI Dialogue Context Keys.");
		end
	else
		local contextValue = GetDialogueState(contextKey);
		if trigger == "mission_manager_exit" then
			triggerString = "POI Exited Function in Mission Manager";
			if DialogueState_debug == 1 then
				print ("Removing POI Dialogue Context via ",triggerString,":");
				print ("  - Mission Persistence Key '",keyString,"' provided. Setting Key '",contextKey,"'from",contextValue,"to 0.");
			end
			SetDialogueState(contextKey, 0);
		elseif trigger == "mission_manager_enter" then
			triggerString = "POI Entered Function in Mission Manager";
			if DialogueState_debug == 1 then
				print ("Activating POI Dialogue Context from ",triggerString,":");
				print ("  - Mission Persistence Key '",keyString,"' provided. Incrementing Key '",contextKey,"'from",contextValue,"to",(contextValue+1),".");
			end
			SetDialogueState(contextKey, (contextValue+1));
		else
			if DialogueState_debug == 1 then
				print ("Activating a POI Dialogue Context from ",triggerString,":");
				print ("  - Persistence Key '",keyString,"' provided. Incrementing Key '",contextKey,"' from",contextValue,"to",(contextValue+1),".");
			end
			SetDialogueState(contextKey, (contextValue+1));
		end
	end
end

--Dominion Dialogue Context
function SetDominionDialogueContext(dominion:string, trigger:string)
	local triggerString = "Unknown Source";
	local contextKey = "world_context_dominion"
	local contextValue = ow_dom_dialogue_context_map[dominion];
	if contextValue == nil then
		if DialogueState_debug == 1 then
			print ("  - Value of '",dominion,"' provided.  Setting Key '",contextKey,"' to ",0," instead of '",contextValue,"'.");
		end
		SetDialogueState(contextKey, 0);
	else
		if trigger == "volume" then
			triggerString = "Volume entered by Player";
		elseif trigger == "leader" then
			triggerString = "Fireteam Leader's Current Volume";
		elseif trigger == "exitplayer" then
			triggerString = "Exiting Player's Current Volume";
		end
		if DialogueState_debug == 1 then
			print ("Setting Dominion Dialogue Context from ",triggerString,":");
			print ("  - Value of '",dominion,"' provided.  Setting Key '",contextKey,"' to '",contextValue,"'.");
		end
		SetDialogueState(contextKey, contextValue);
	end
end


--[[********************************************************************************************************************************************
Function called within PoiVolumeTriggerEnter to let Follow Marines know you entered a space:
	The first player into a POI volume can get an event sent to Marines who are Following them. In conjuntion with the POI Context, they may react.
************************************************************************************************************************************************  ]]--

function FollowMarinesPoiComment(volume:activation_volume)
	local firstPlayer:player = nil
	local playersInVolume = ActivationVolume_GetPlayers(volume);
	local dialogueEvent:string = "poi_entered";
	local delayTime:number = 2.5
	
	if #playersInVolume > 1 then
--		print ("Another player is already in this volume and got a chance at the entering Dialogue Event.  That was enough.");
	elseif #playersInVolume == 1 then
		for _, player in hpairs(playersInVolume) do
--			print ("Player",player,": is the first one in the volume.");
			firstPlayer = player;
		end
		SleepSeconds(delayTime * real_random_range(0.9, 1.1));
--		print ("Are players still in there?");
		playersInVolume = ActivationVolume_GetPlayers(volume);
		if not table.contains(playersInVolume, firstPlayer) then
--			print ("Players left too fast. Forget it.");
		else
--			print ("Does ",firstPlayer," have marines following them?");
			local firstSquad:ai = ai_unit_get_following_squad(firstPlayer);
			local followingActors:table = Squad_GetActors(firstSquad);
			if firstSquad == nil then
--				print ("First Player",firstPlayer," has no Following Marines.  Not firing Dialogue Event:",dialogueEvent," on anyone.");
			else
				if DialogueState_debug == 1 then
					print ("Firing Dialogue Event:\"",dialogueEvent,"\" on",#followingActors," of",ai_unit_get_following_actors_count(firstPlayer)," Marine AI following ",firstPlayer," as the first into a POI:");
				end
				for _, actor in hpairs(followingActors) do
					local marineAI = actor
					local marineObject = ai_get_object(actor)
					if ai_is_friendly_squad_following(marineAI) == true then
						if DialogueState_debug == 1 then
							print ("  - AI Actor: ",marineAI," , Object: ",marineObject);
						end
						DialogueSystem_RunEvent(marineObject, dialogueEvent, firstPlayer);
					end
				end
			end
		end
	else
--		print ("There must not be any players in the volume anymore.  Nevermind.");
	end
end



--[[********************************************************************************************************************************************
Set/Get Functions for POI Context/Progress and Dominion Contexts:
	Helpful Debug Functions for reading and manipulating Dialog Context outside of activation volume methods.
************************************************************************************************************************************************  ]]--

--[[********************************************************************************************
SetPoi_Absolute : Set the POI/Mission Context or Progress value of A Specific Key to A Specific Value
	poi_context string value must exist in 'ow_poi_dialogue_context_map' table above with a valid context/progress dialogue state key, or point to something that does via 'ow_poi_dialogue_context_aliases' table.
************************************************************************************************ ]]--
--Context Key
function SetPoiDialogueContext_Absolute(poi_context:string, absoluteValue)
	local triggerString = "Debug Command";
	local contextKey = nil
	
	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		contextKey = ow_poi_dialogue_context_map[poi_context].context;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local contextKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
	end
	
	if contextKey == nil then
		print ("No Dialogue State Key defined for provided POI type '",poi_context,"'.  Not updating POI Dialogue Context Keys.");
	elseif absoluteValue == nil then
		print ("No Value provided for setting '",poi_context,"' to.  Not updating POI Dialogue Context Key '",contextKey,"'.");
	else
		local contextValue = GetDialogueState(contextKey);
		if DialogueState_debug == 1 then
			print ("Setting POI Dialogue Context from ",triggerString,":");
			print ("  - Value of '",poi_context,"' provided.  Setting Absolute value of Key '",contextKey,"' from ",contextValue," to ",(absoluteValue),".");
		end
		SetDialogueState(contextKey, absoluteValue);
	end
end

--Progress Key
function SetPoiDialogueProgress_Absolute(poi_context:string, absoluteValue, trigger:string)
	local triggerString = "Debug Command";
	local progressKey = nil
	
	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		progressKey = ow_poi_dialogue_context_map[poi_context].progress;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	end

	if trigger == "conditions_check" then
		triggerString = "Dialogue State Conditions Check"
	end
	
	if progressKey == nil then
		print ("No Dialogue State Key defined for provided POI type '",poi_context,"'.  Not updating POI Dialogue Local Progress Keys.");
	elseif absoluteValue == nil then
		print ("No Value provided for setting '",poi_context,"' to.  Not updating POI Dialogue Context Key '",progressKey,"'.");
	else
		local progressValue = GetDialogueState(progressKey);
		if DialogueState_debug == 1 then
			print ("Setting POI Dialogue Local Progress from ",triggerString,":");
			print ("  - Value of '",poi_context,"' provided.  Setting Absolute value of Key '",progressKey,"' from ",progressValue," to ",(absoluteValue),".");
		end
		SetDialogueState(progressKey, absoluteValue);
	end
end

--Progress Can be set with a PERSISTENCE KEY as the direct input instead of a string, but requires that the provided PersKey is a key in the 'ow_dialogue_context_map', or in the alias table to point to one that is.
function SetPoiDialogueProgress_from_Key_Absolute(poi_context:persistence_key, absoluteValue, trigger:string)
	local triggerString = "Debug Command";
	local progressKey = nil
	local keyString = Persistence_GetStringIdFromKey(poi_context)

	local ow_poi_dialogue_context_map_toKeys:table = {};
	for tableString, tableKeys in hpairs(ow_poi_dialogue_context_map) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_map_toKeys[Persistence_TryCreateKeyFromString(tableString)] = tableKeys;
		end
	end

	local ow_poi_dialogue_context_persKey_aliases_toKeys:table = {};
	for tableString, tableAlias in hpairs(ow_poi_dialogue_context_persKey_aliases) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_persKey_aliases_toKeys[Persistence_TryCreateKeyFromString(tableString)] = Persistence_TryCreateKeyFromString(tableAlias);
		end
	end
	
	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		progressKey = ow_poi_dialogue_context_map[poi_context].progress;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	elseif ow_poi_dialogue_context_map_toKeys[poi_context] ~= nil then
		progressKey = ow_poi_dialogue_context_map_toKeys[poi_context].progress;
	elseif ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context];
		progressKey = ow_poi_dialogue_context_map_toKeys[progressKeyAlias].progress;
	end

	if trigger == "conditions_check" then
		triggerString = "Dialogue State Conditions Check"
	end
	
	if progressKey == nil then
		print ("No Dialogue State Key defined for POI Persistence Key '",keyString,"'. Not updating POI Dialogue Local Progress Keys.");
	elseif absoluteValue == nil then
		print ("No Value provided to set Persistence Key '",keyString,"' to.  Not updating POI Dialogue Context Key '",progressKey,"'.");
	else
		local progressValue = GetDialogueState(progressKey);
		if DialogueState_debug == 1 then
			print ("Setting POI Dialogue Local Progress from ",triggerString,":");
			print ("  - Persistence Key '",keyString,"' provided.  Setting Absolute value of Key '",progressKey,"' from ",progressValue," to ",(absoluteValue),".");
		end
		SetDialogueState(progressKey, absoluteValue);
	end
end

--[[********************************************************************************************
SetPoi_Reset : Set the POI/Mission Context or Progress value of All keys or A Specific key to default 0 value
	poi_context string value must exist in 'ow_poi_dialogue_context_map' table above with a valid context/progress dialogue state key, or point to something that does via 'ow_poi_dialogue_context_aliases' table.
************************************************************************************************ ]]--
--Context Key
function SetPoiDialogueContext_Reset(poi_context:string, trigger:string)
	local triggerString = "Debug Command";
	if trigger == "level_load" then
		triggerString = "Level Transition Load Level Function";
	elseif trigger == "mission_manager_enter" then
		triggerString = "POI Entered Function in Mission Manager";
	end

	if poi_context == nil or poi_context == "All" then
		if DialogueState_debug == 1 then
			print ("Resetting ALL Non-Zero POI Dialogue Context Keys from ",triggerString,":");
		end
		local nonZeroCount = 0
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local contextValue = GetDialogueState(key.context);
			if contextValue > 0 then
				SetDialogueState(key.context, 0);
				if DialogueState_debug == 1 then
					print ("  - Clearing '",context,"': value of Key '",key.context,"' changed from ",contextValue," to ",0,".");
				end
				nonZeroCount = (nonZeroCount+1);
			end
		end
		if DialogueState_debug == 1 then
			if nonZeroCount == 0 then
				print ("  - All POI Context Keys were previously at Zero value.");
			end
		end
	else
		local contextKey = nil
		
		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			contextKey = ow_poi_dialogue_context_map[poi_context].context;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local contextKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
		end
		
		if contextKey == nil then
			print ("No Dialogue State Key defined for provided POI type String '",poi_context,"'.  Not resetting any POI Dialogue Context Keys.");
		else
			local contextValue = GetDialogueState(contextKey);
			if DialogueState_debug == 1 then
				print ("Resetting POI Dialogue Context Key from ",triggerString,":");
				print ("  - Clearing '",poi_context,"': value of Key '",contextKey,"' changed from ",contextValue," to ",0,".");
			end
			SetDialogueState(contextKey, 0);
		end
	end
end

--Progress Key
function SetPoiDialogueProgress_Reset(poi_context:string, trigger:string)
	local triggerString = "Debug Command";

	if trigger == "conditions_check" then
		triggerString = "Dialogue State Conditions Check"
	end

	if poi_context == nil or poi_context == "All" then
		if DialogueState_debug == 1 then
			print ("Resetting ALL Non-Zero POI Dialogue Local Progress Keys from ",triggerString,":");
		end
		local nonZeroCount = 0
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local progressValue = GetDialogueState(key.progress);
			if progressValue > 0 then
				SetDialogueState(key.progress, 0);
				if DialogueState_debug == 1 then
					print ("  - Clearing '",context,"': value of Key '",key.progress,"' changed from ",progressValue," to ",0,".");
				end
				nonZeroCount = (nonZeroCount+1);
			end
		end
		if DialogueState_debug == 1 then
			if nonZeroCount == 0 then
				print ("  - All POI Local Progress Keys were previously at Zero value.");
			end
		end
	else
		local progressKey = nil
		
		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			progressKey = ow_poi_dialogue_context_map[poi_context].progress;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		end
	
		if progressKey == nil then
			print ("No Dialogue State Key defined for provided POI type String '",poi_context,"'.  Not resetting any POI Dialogue Local Progress Keys.");
		else
			local progressValue = GetDialogueState(progressKey);
			if DialogueState_debug == 1 then
				print ("Resetting POI Dialogue Local Progress Key from ",triggerString,":");
				print ("  - Clearing '",poi_context,"': value of Key '",progressKey,"' changed from ",progressValue," to ",0,".");
			end
			SetDialogueState(progressKey, 0);
		end
	end
end

--Progress can be set with a PERSISTENCE KEY as the direct input instead of a string, but requires that the provided PersKey is a key in the 'ow_dialogue_context_map', or in the alias table to point to one that is.
function SetPoiDialogueProgress_from_Key_Reset(poi_context:persistence_key, trigger:string)
	local triggerString = "Debug Command";
	local progressKey = nil
	local keyString = Persistence_GetStringIdFromKey(poi_context)

	local ow_poi_dialogue_context_map_toKeys:table = {};
	for tableString, tableKeys in hpairs(ow_poi_dialogue_context_map) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_map_toKeys[Persistence_TryCreateKeyFromString(tableString)] = tableKeys;
		end
	end

	local ow_poi_dialogue_context_persKey_aliases_toKeys:table = {};
	for tableString, tableAlias in hpairs(ow_poi_dialogue_context_persKey_aliases) do
		if Persistence_TryCreateKeyFromString(tableString) ~= nil then
			ow_poi_dialogue_context_persKey_aliases_toKeys[Persistence_TryCreateKeyFromString(tableString)] = Persistence_TryCreateKeyFromString(tableAlias);
		end
	end
	
	if trigger == "conditions_check" then
		triggerString = "Dialogue State Conditions Check"
	end

	if ow_poi_dialogue_context_map[poi_context] ~= nil then
		progressKey = ow_poi_dialogue_context_map[poi_context].progress;
	elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
		progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
	elseif ow_poi_dialogue_context_map_toKeys[poi_context] ~= nil then
		progressKey = ow_poi_dialogue_context_map_toKeys[poi_context].progress;
	elseif ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context] ~= nil then
		local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases_toKeys[poi_context];
		progressKey = ow_poi_dialogue_context_map_toKeys[progressKeyAlias].progress;
	end

	if progressKey == nil then
		print ("No Dialogue State Key defined for POI Persistence Key '",keyString,"'. Not resetting any POI Dialogue Local Progress Keys.");
	else
		local progressValue = GetDialogueState(progressKey);
		if DialogueState_debug == 1 then
			print ("Resetting POI Dialogue Local Progress Key from ",triggerString,":");
			print ("  - Clearing Persistence Key '",keyString,"': value of Key '",progressKey,"' changed from ",progressValue," to ",0,".");
		end
		SetDialogueState(progressKey, 0);
	end
end

--[[********************************************************************************************
GetPoi_Context/Progress : Get the POI/Mission Context or Progress value of All Keys, Active Keys, or A Specific Key
************************************************************************************************ ]]--
function GetPoiDialogueContext(poi_context:string)
	if poi_context == nil or poi_context == "All" then
		print ("No POI Context Provided. Reporting ALL POI Dialogue Context Keys:");
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local contextKey = key.context;
			local contextValue = GetDialogueState(contextKey);
			print ("  - Reporting '",context,"': value of Context Key '",contextKey,"' is ",contextValue,".");
		end
	elseif poi_context == "active" then
		print ("CONTEXT: Reporting ALL currently Non-Zero POI Dialogue Context Keys:");
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local contextKey = key.context;
			local contextValue = GetDialogueState(contextKey);
			if contextValue ~= 0 then
				print ("  - Active Context: '",context,"': Key '",contextKey,"' is at value ",contextValue,".");
			end
		end
	else
		local contextKey = nil
		
		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			contextKey = ow_poi_dialogue_context_map[poi_context].context;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local contextKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local contextKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			contextKey = ow_poi_dialogue_context_map[contextKeyAlias].context;
		end
		
		if contextKey == nil then
			print ("No Dialogue State Key defined for provided POI type '",poi_context,"'.  Can not report POI Dialogue Context Key.");
		else
			local contextValue = GetDialogueState(contextKey);
			print ("POI Dialogue Context Key status for '",poi_context,"':");
			print ("  - Value of Key '",contextKey,"' is ",contextValue,".");
		end
	end
end

function GetPoiDialogueProgress(poi_context:string)
	if poi_context == nil or poi_context == "All" then
		print ("No POI Context Provided. Reporting ALL POI Dialogue Local Progress Keys:");
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local progressKey = key.progress;
			local progressValue = GetDialogueState(progressKey);
			print ("  - Reporting '",context,"': value of Local Progress Key '",progressKey,"' is ",progressValue,".");
		end
	elseif poi_context == "active" then
		print ("PROGRESS: Reporting ALL currently Non-Zero POI Dialogue Local Progress Keys:");
		for context, key in hpairs(ow_poi_dialogue_context_map) do
			local progressKey = key.progress;
			local progressValue = GetDialogueState(progressKey);
			if progressValue ~= 0 then
				print ("  - Active Progress: '",context,"': Key '",progressKey,"' is at value ",progressValue,".");
			end
		end
	else
		local progressKey = nil
		
		if ow_poi_dialogue_context_map[poi_context] ~= nil then
			progressKey = ow_poi_dialogue_context_map[poi_context].progress;
		elseif ow_poi_dialogue_context_persKey_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_persKey_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		elseif ow_poi_dialogue_context_aliases[poi_context] ~= nil then
			local progressKeyAlias = ow_poi_dialogue_context_aliases[poi_context];
			progressKey = ow_poi_dialogue_context_map[progressKeyAlias].progress;
		end
		
		if progressKey == nil then
			print ("No Dialogue State Key defined for provided POI type '",poi_context,"'.  Can not report POI Dialogue Local Progress Key.");
		else
			local progressValue = GetDialogueState(progressKey);
			print ("POI Dialogue Local Progress Key status for String '",poi_context,"':");
			print ("  - Value of Key '",progressKey,"' is ",progressValue,".");
		end
	end
end

--[[********************************************************************************************
GetDominion_Context : Get the Current value of Dominion Context Key, and what Dominion Strings are Valid
************************************************************************************************ ]]--
function GetDominionDialogueContext()
	local contextKey = "world_context_dominion";
	local contextValue = GetDialogueState(contextKey);
	print ("DOMINION: Dialogue Context Key '",contextKey,"' is ",contextValue,": Valid Dominion Contexts are:");
	for context, value in hpairs(ow_dom_dialogue_context_map) do
		if value == contextValue then
			print ("  - '",context,"'");
		end
	end
end

--[[********************************************************************************************
GetDialogue_Status : Get the Current State of Non-Zero Context Keys, Progress Keys, and the Valid Dominion Strings
************************************************************************************************ ]]--
function GetDialogueContextStatus()
	GetPoiDialogueContext("active");
	GetPoiDialogueProgress("active");
	GetDominionDialogueContext();
end

--[[********************************************************************************************************************************************
DIALOGUE-STATE-Key-Setting/Getting Helper Utility Functions
	Utility Functions to Simplify Setting or Getting Dialogue State Key values and handle variable key type functions
************************************************************************************************************************************************  ]]--

--[[*******************************************************************
SetDialogueState:
	Checks Dialogue State Key Type, and uses the appropriate 'set' function for the listed DST key to set it to the provided value, converting integer values to bools if necessary
		Usage: Provide both a valid Dialogue State Table key name with "" and a value to set the key to.
		(ie: SetDialogueState("campaign_progress_dominion_green_major", 1)
***********************************************************************  ]]--
function SetDialogueState(key, value)
	if value == nil then
		print ("SetDialogueState: Can not set value of key '",key,"' to 'nil', please provide a value.");
	elseif key == nil then
		print ("SetDialogueState: Can not set value of key '",key,"', please provide a valid Dialogue State Key.");
	else
		if DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Bool then
			if value <= 0 then value = false else value = true end
			DialogueState_SetBoolKey(DIALOGUESTATE_KEY(key), value);
		elseif DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Byte then
			DialogueState_SetByteKey(DIALOGUESTATE_KEY(key), value);
		elseif DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Long then
			DialogueState_SetLongKey(DIALOGUESTATE_KEY(key), value);
		else
			print ("failed to set Dialogue State Key ",key,"to ",value);
		end
	end
end

--[[*******************************************************************
GetDialogueState:
	Checks Dialogue State Key Type, and uses the appropriate 'get' function for the listed DST key to read and return the current value.
		Usage: Provide a valid Dialogue State Table key name with "".
		(ie: print (GetDialogueState("campaign_progress_dominion_green_major"))
***********************************************************************  ]]--
function GetDialogueState(key)
	if key == nil then
		print ("GetDialogueState: Can not check value of key '",key,"', please provide a valid Dialogue State Key.");
	else
		local dialogueKeyValue = nil;
		if DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Bool then
			dialogueKeyValue = DialogueState_GetBoolKey(DIALOGUESTATE_KEY(key));
		elseif DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Byte then
			dialogueKeyValue = DialogueState_GetByteKey(DIALOGUESTATE_KEY(key));
		elseif DialogueState_GetKeyType(DIALOGUESTATE_KEY(key)) == PERSISTENCE_KEY_TYPE.Long then
			dialogueKeyValue = DialogueState_GetLongKey(DIALOGUESTATE_KEY(key));
		else
			print ("failed to find Dialogue State Key '",key,"'");
		end
		return dialogueKeyValue;
	end
end

--[[********************************************************************************************************************************************
PERSISTENCE-KEY-Checking Helper Utility Functions:
	Utility Functions to Simplify Persistence Key Queries and handle variable key type functions
************************************************************************************************************************************************  ]]--

--[[*******************************************************************
1. StateKeyCheck: Checks for the Persistence Key Type and returns the appropriate 'get' function for the listed key with correct API (on FireTeam Leader)
		Usage: Provide a valid Persistence Key STRING with "", and check against the value of the function with math Operators
		(ie: If StateKeyCheck("poi_epoi_01") == 1 then...)
***********************************************************************  ]]--
function StateKeyCheck(key)
	if key == nil then
		print ("StateKeyCheck: Can not check value of key '",key,"', please provide a valid Persistence Key.");
	else
		if Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Bool then
			return Persistence_GetBoolKey(PERSISTENCE_KEY(key));
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Byte then
			return Persistence_GetByteKey(PERSISTENCE_KEY(key));
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Short then
			return Persistence_GetByteKey(PERSISTENCE_KEY(key));
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Long then
			return Persistence_GetLongKey(PERSISTENCE_KEY(key));
		else
		end
	end
end

--[[*******************************************************************
2. StateKeyCheckValue: Checks Key Type, returns the appropriate 'get' function for the listed key, and checks the provided value against the current value of that key, converting integer values to bools if necessary
		Usage: Provide both a valid Persistence Key STRING with "", and a value.  If the key equals that value/doesn't, the function evaluates to true/false, no Operators required!
		(ie: if StateKeyCheckValue("poi_epoi_01, 1) then...)
***********************************************************************  ]]--
function StateKeyCheckValue(key, value)
	if key == nil then
		print ("StateKeyCheckValue: Can not check value of key '",key,"', please provide a valid Persistence Key.");
	else
		if Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Bool then
			if value <= 0 then value = false else value = true end
			if Persistence_GetBoolKey(PERSISTENCE_KEY(key)) == value then
	--			print("YES, bool key ",key," equals value of ",value,"!");
				return true;
			else
	--			print("NOPE, bool key ",key," does not equal value of ",value,"!");
				return false;
			end
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Byte then
			if Persistence_GetByteKey(PERSISTENCE_KEY(key)) == value then
	--			print("YES, byte key ",key," equals value of ",value,"!");
				return true;
			else
	--			print("NOPE, byte key ",key," does not equal value of ",value,"!");
				return false;
			end
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Short then
			if Persistence_GetByteKey(PERSISTENCE_KEY(key)) == value then
	--			print("YES, short(byte) key ",key,"equals value of ",value,"!");
				return true;
			else
	--			print("NOPE, short(byte) key ",key," does not equal value of ",value,"!");
				return false;
			end
		elseif Persistence_GetKeyType(PERSISTENCE_KEY(key)) == PERSISTENCE_KEY_TYPE.Long then
			if Persistence_GetLongKey(PERSISTENCE_KEY(key)) == value then
	--			print("YES, long key ",key,"equals value of ",value,"!");
				return true;
			else
	--			print("NOPE, long key ",key," does not equal value of ",value,"!");
				return false;
			end
		else
				return false;
		end
	end
end


--[[********************************************************************************************************************************************
SCRIPTED DIALOGUE EVENT Helper Functions:
	Utility Functions to Manage getting players for Dialogue Event Cause/Subject Reference and for sending the Dialogue Event to an object with the Player as cause/subject
************************************************************************************************************************************************  ]]--

function GetClosestPlayerToObject(objRef:object):object
	local objPos:vector = Object_GetPositionVector(objRef);				--Get my current Position
	local closestPlayer:object = GetFireTeamLeader();					--prepare to get a player
	local leaderPos:vector = Object_GetPositionVector(closestPlayer);	--default to the FireTeam Leader
	local closestDist:number = (objPos - leaderPos).length;
	for _, activePlayer in ipairs(PLAYERS.active) do					--but try to get the closest player
		local playerPos:vector = Object_GetPositionVector(activePlayer);
		local playerDist:number = (objPos - playerPos).length;
		if closestDist > playerDist then
			closestPlayer = activePlayer;
			closestDist = playerDist;
		end
	end
	return closestPlayer;
end

function dialogueEventWithClosestPlayerAs(playerSubOrCause:string, dialEvent:string, eventSubOrCause:object):void
	if playerSubOrCause == "cause" then
		DialogueSystem_RunEvent(eventSubOrCause, dialEvent, GetClosestPlayerToObject(eventSubOrCause));
		if DialogueState_debug == 1 then
			print("Sending Dialogue Event \"",dialEvent,"\" to Subject",eventSubOrCause," using ",GetClosestPlayerToObject(eventSubOrCause)," as Cause")
		end
	elseif playerSubOrCause == "subject" then
		DialogueSystem_RunEvent(GetClosestPlayerToObject(eventSubOrCause), dialEvent, eventSubOrCause);
		if DialogueState_debug == 1 then
			print("Sending Dialogue Event \"",dialEvent,"\" to Subject",GetClosestPlayerToObject(eventSubOrCause)," using ",eventSubOrCause," as Cause")
		end
	else
		print("FAILED! 1st argument must be the string \"subject\" or \"cause\" to determine which the Closest Player should be used as for firing the event.")
	end
end