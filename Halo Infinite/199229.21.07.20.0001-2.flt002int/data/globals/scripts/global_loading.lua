-- Copyright (C) Microsoft. All rights reserved.
--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- TESTS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------

function LoomTimeTest(level:string, zoneSet:string, spawnPoint:string_id):void
	local loomTimer:number = 0;
	LoomScenario (level, zoneSet);
	print ("looming ", level);
	print ("looming ", zoneSet);

	repeat
		sleep_s (1);
		loomTimer = loomTimer + 1;
		print ("seconds to loom is ", loomTimer);
	until not ScenarioLoomInProgress();
	
	print ("loom done");
	--SetNextSpawnPoint(spawnPoint);
end


-- =================================================================================================
-- =================================================================================================
-- LOADING
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------
global g_island01Path:string = "levels\\campaign\\ring01\\island01\\island01";

global g_levelTable:table =
	{
		ring01_zone01 = {path = g_island01Path, zoneSet = "default", spawnPoint = "island_default_start_01"},
		
		--prototype levels
		campaign_hub = {path = "levels\\campaign\\temp\\campaign_hub\\campaign_hub", zoneSet = "default", spawnPoint = "playerstart"},
		power_tether = {path = "levels\\test\\power_tether_test01\\power_tether_test01\\power_tether_test01", zoneSet = "default", spawnPoint = ""},
		supply_lines = {path = "levels\\campaign\\prototypes\\prototype_base_shenanigans\\prototype_base_shenanigans", zoneSet = "default", spawnPoint = ""},
		vehicle_base = {path = "levels\\temp\\v-miklit\\vehicle_base01\\vehicle_base01", zoneSet = "default", spawnPoint = ""},
		outpost = {path = "levels\\campaign\\prototypes\\base_op_mun_1\\base_op_mun_1", zoneSet = "default", spawnPoint = ""},
		vehicle_demo = {path = "levels\\temp\\chdonsan\\vehicle_demo\\vehicle_demo", zoneSet = "default", spawnPoint = ""},
		underbelly = {path = "levels\\temp\\ow_dungeons\\fore\\dung_fore_underbelly_01\\dung_fore_underbelly_01", zoneSet = "default", spawnPoint = ""},
		spire = {path = "levels\\temp\\ow_dungeons\\fore\\dung_fore_citadel_01\\dung_fore_citadel_01", zoneSet = "default", spawnPoint = ""},
		shenanigans = {path = "levels\\campaign\\prototypes\\prototype_base_shenanigans\\prototype_base_shenanigans", zoneSet = "default", spawnPoint = ""},
		jailbreak02 = {path = 'levels\campaign\prototypes\jailbreak02\jailbreak02', zoneSet = "default", spawnPoint = ""},
		dungeon_cortana = {path = 'levels\campaign\ring01\dungeons\dungeon_cortana\dungeon_cortana', zoneSet = "default", spawnPoint = ""},
		dung_inq_1 = {path = 'levels\campaign\prototypes\prototype_dung_inq\dung_inq_1\dung_inq_1', zoneSet = "default", spawnPoint = ""},
		temp_spartanmem1 = {path = 'levels\temp\gurasche\temp_spartanmem1\temp_spartanmem1', zoneSet = "default", spawnPoint = ""},
		spm_overworld001 = {path = 'levels\campaign\ring01\spartan_memories\spm_overworld001\spm_overworld001', zoneSet = "default", spawnPoint = ""},
		dynamic_events = {path = 'levels\campaign\prototypes\event_kits\event_kits', zoneSet = "default", spawnPoint = ""},
		interactions_gym = {path = 'levels\design\sandbox_interactions_gym\sandbox_interactions_gym', zoneSet = "default", spawnPoint = ""},
		refinery_base = {path = 'levels\campaign\ring01\island01\regions\green_refinery_base\green_refinery_base', zoneSet = "default", spawnPoint = ""},
		firing_range = {path = 'levels\test\firing_range\firing_range', zoneSet = "default", spawnPoint = ""},
		fob_test = {path = "levels\\test\\fob_test\\fob_test\\fob_test", zoneSet = "default", spawnPoint = "playerstart"},
		
		--shipping level transitions (chronological)
		m1_banished =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_banished_ship\dungeon_banished_ship',
			zoneSet = "default",
			spawnPoint = "",
		},
		m2_underbelly =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_underbelly\dungeon_underbelly',
			zoneSet = "zoneset01_streamingsetup",
			zoneSetIndex = 0,
			spawnPoint = "landing_playerstart_01",
			spawnIndex = 0,
			missionKeyName = "Dungeon-Underbelly",
			linearEval = true,
		},
		from_underbelly =
		{
			path = g_island01Path,
			zoneSet = "streaming",
			zoneSetIndex = 0,
			spawnPoint = "from_underbelly_playerstart_01",
			spawnIndex = 69,
			missionKeyName = "poi_green_pilot_base",
			linearEval = false,
		},
		forerunner_dallas =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_forerunner_dallas\dungeon_forerunner_dallas',
			zoneSet = "zoneset_01",
			zoneSetIndex = 0,
			spawnPoint = "dallas_playerstart_01",
			spawnIndex = 4,
			missionKeyName = "poi_forerunner_dallas",
			linearEval = true,
		},
		from_forerunner_dallas =
		{
			path = g_island01Path,
			zoneSet = "streaming",
			zoneSetIndex = 0,
			spawnPoint = "from_dallas_playerstart_01",
			spawnIndex = 145,
			missionKeyName = "poi_forerunner_dallas",
			linearEval = false,
		},
		m3_spire01 =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_spire_01\dungeon_spire_01',
			zoneSet = "zoneset_01",
			zoneSetIndex = 0,
			spawnPoint = "collector_room_playerstart_01",
			spawnIndex = 4,
			missionKeyName = "poi_green_spire",
			linearEval = true,
		}, --
		from_spire_01 =
		{
			path = g_island01Path,
			zoneSet = "exit_dungeon_spire_01",
			zoneSetIndex = 2,
			spawnPoint = "spire_01_control_room_playerstart_01",
			spawnIndex = 269,
			missionKeyName = "poi_green_spire",
			linearEval = false,
		},
		forerunner_houston = 
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_forerunner_houston\dungeon_forerunner_houston',
			zoneSet = "zoneset_01",
			zoneSetIndex = 0,
			spawnPoint = "entrance_playerstart_01",
			spawnIndex = 4,
			missionKeyName = "poi_forerunner_houston",
			linearEval = true,
		},
		m4_spire02 =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_spire_02\dungeon_spire_02',
			zoneSet = "zoneset_01",
			zoneSetIndex = 0,
			spawnPoint = "yellow_spire_collector_playerstart_01",
			spawnIndex = 1,
			missionKeyName = "poi_yellow_spire",
			linearEval = true,
		},
		from_spire_02 =
		{
			path = g_island01Path,
			zoneSet = "exit_dungeon_spire_02",
			zoneSetIndex = 8,
			spawnPoint = "from_spire_02_playerstart_01",
			spawnIndex = 281,
			missionKeyName = "poi_yellow_spire",
			linearEval = false,
		},
		forerunner_austin =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_forerunner_austin\dungeon_forerunner_austin',
			zoneSet = "interlude",
			zoneSetIndex = 0,
			spawnPoint = "teleporter_room_playerstart_01",
			spawnIndex = 4,
			missionKeyName = "poi_forerunner_austin",
			linearEval = true,
		},
		from_forerunner_austin =
		{
			path = g_island01Path,
			zoneSet = "streaming",
			zoneSetIndex = 0,
			spawnPoint = "from_austin_playerstart_01",
			spawnIndex = 233,
			missionKeyName = "poi_boss_hq_exterior",
			linearEval = false,
		},
		boss_hq =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_boss_hq_interior\dungeon_boss_hq_interior',
			zoneSet = "zoneset_01_streaming",
			zoneSetIndex = 4,
			spawnPoint = "entrance_room_playerstart_01",
			spawnIndex = 0,
			missionKeyName = "poi_boss_hq_interior",
			linearEval = true,
		}, --
		cortana_palace =
		{
			path = 'levels\campaign\ring01\dungeons\dungeon_cortana_palace\dungeon_cortana_palace',
			zoneSet = "zoneset_01",
			zoneSetIndex = 0,
			spawnPoint = "dropsite_playerstart_01",
			spawnIndex = 1,
			missionKeyName = "poi_cortana_palace",
			linearEval = true,
		}, --
		from_cortana_palace =
		{
			path = g_island01Path,
			zoneSet = "streaming",
			zoneSetIndex = 0,
			spawnPoint = "from_cortana_palace",
			spawnIndex = 37,
			missionKeyName = nil,
			linearEval = false,
		},

		--asset gyms
		banished_gym = {path = 'levels\design\palette_gyms\banished_gym\banished_gym', zoneSet = "default", spawnPoint = ""},
		banished_ship_gym = {path = 'levels\design\palette_gyms\banished_ship_gym\banished_ship_gym', zoneSet = "default", spawnPoint = ""},
		cave_gym = {path = 'levels\design\palette_gyms\cave_gym\cave_gym', zoneSet = "default", spawnPoint = ""},
		forerunner_gym = {path = 'levels\design\palette_gyms\forerunner_gym\forerunner_gym', zoneSet = "default", spawnPoint = ""},
		natural_spaces_gym = {path = 'levels\design\palette_gyms\natural_spaces_gym\natural_spaces_gym', zoneSet = "default", spawnPoint = ""},
		
	};

global g_levelTransitionIgnoreSequenceBreakChecks:boolean = false;
global g_preventCampfireTriggeringDuringSpawning:boolean = true;
global g_enableLevelDataValidation:boolean = true;

function ToggleIgnoreSequenceBreakChecks():void
	g_levelTransitionIgnoreSequenceBreakChecks = not g_levelTransitionIgnoreSequenceBreakChecks;
	print("Ignoring Level Transition Sequence Break Checks:", g_levelTransitionIgnoreSequenceBreakChecks);
end

function startup.LevelDataValidation():void
	if g_enableLevelDataValidation == true then
		for _, details in hpairs(g_levelTable) do
			if not stringIsNullOrEmpty(details.path) and Level_IsCurrentNameEqual(details.path) == true then
				if not stringIsNullOrEmpty(details.zoneSet) and details.zoneSetIndex ~= nil then
					assert(ZONE_SETS[details.zoneSet] == ZONE_SETS[details.zoneSetIndex], "The global loading script has mismatching zone set info for the level "..details.path.." "..details.zoneSet);
				end
			end
		end
	end
end

function LoadLevelImmediate(level:string, zoneSet:string, spawnPoint:string, presetCampfire:boolean, zoneSetIndex:number, spawnIndex:number, missionKeyName:string, linearEval:boolean):void
	--if editor_mode() == false then
		PreLevelTransitionCallback(level, zoneSet, spawnPoint);

		if presetCampfire == true then
			if zoneSetIndex ~= nil and spawnIndex ~= nil and linearEval ~= nil then
				local missionManager:table = _G["g_currentMissionManager"];

				if missionManager ~= nil then
					local missionKey:persistence_key = nil;

					if missionKeyName ~= nil then
						missionKey = Persistence_TryCreateKeyFromString(missionKeyName);
					end

					for _, player in ipairs(PLAYERS.active) do
						if missionKey == nil or IsMissionCompletedForPlayer(player, missionKey) == false then
							print("pre-setting campfire info for", player, "-", level, spawnIndex, zoneSetIndex, linearEval);
							SetCampfirePointForNextMapForPlayer(player, level, spawnIndex, zoneSetIndex, linearEval, missionManager.currentMainMissionIndex);
						end
					end
				else
					print("Unable to pre-set campfire data, mission manager was nil");
				end
			else
				print("Unable to pre-set campfire data, campfire data was nil", zoneSetIndex, spawnIndex, linearEval);
			end
		end

		StartLevelAtSpawn(level, zoneSet, spawnPoint);
		--StartLevel(level);
	--end
end

function LoomLevel(level:string, zoneSet:string, spawnPoint:string_id, debugPrint:boolean):void
	if editor_mode() == false then
		StartLoadingLevel(level, zoneSet, spawnPoint);

		if debugPrint == true then
			SleepUntil([|ScenarioLoomInProgress() == true], 0.1);

			while ScenarioLoomInProgress() == true do
				print("Looming", level, "in progress...");
				SleepSeconds(4);
			end
		else
			SleepUntil([|ScenarioLoomInProgress() == false], 1);
		end
	end
end

function StartLoadingLevel(level:string, zoneSet:string, spawnPoint:string_id):void
	LoomScenarioAtSpawn(level, zoneSet, spawnPoint);
	RunClientScript("LoomLevelClient", level , zoneSet, spawnPoint);
end

function LoadLevelFromTable(levelTable:table, presetCampfire:boolean):void
	LoadLevelImmediate(levelTable.path, levelTable.zoneSet, levelTable.spawnPoint, presetCampfire,
			levelTable.zoneSetIndex, levelTable.spawnIndex, levelTable.missionKeyName, levelTable.linearEval);
end

function LoomLevelFromTable(levelTable:table, debugPrint:boolean):void
	LoomLevel(levelTable.path, levelTable.zoneSet, levelTable.spawnPoint, debugPrint)
end

--LOAD/LOOM SPECIFIC LEVELS
--Ring01
function LoadIsland01(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_underbelly, presetCampfire);
end

function LoomIsland01():void
	LoomLevelFromTable(g_levelTable.from_underbelly);
end

function LoadIsland01FromSpire01(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_spire_01, presetCampfire);
end

function LoadIsland01FromSpire02(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_spire_02, presetCampfire);
end

function LoadIsland01FromForerunnerAustin(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_forerunner_austin, presetCampfire);
end

function LoadFromCortanaPalacePostEnding(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_cortana_palace, presetCampfire);
end

--LOAD RELEASE 01 LEVELS
-- Mission 00
function LoadM00(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.m0_pilot, presetCampfire);
end

-- Mission 01
function LoadM01(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.m1_banished, presetCampfire);
end

-- Mission 02
function LoadM02(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.m2_underbelly, presetCampfire);
end

-- Mission 03
function LoadM03(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.m3_spire01, presetCampfire);
end

-- Mission 04
function LoadM04(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.m4_spire02, presetCampfire);
end

--boss hq
function LoadBossHQ(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.boss_hq, presetCampfire);
end

function LoadCortanaPalace(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.cortana_palace, presetCampfire);
end

-- Cortana Dungeons
--forerunner dallas
function LoadForerunnerDallas(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.forerunner_dallas, presetCampfire);
end

--forerunner houston
function LoadForerunnerHouston(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.forerunner_houston, presetCampfire);
end

--forerunner austin
function LoadForerunnerAustin(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.forerunner_austin, presetCampfire);
end

-- LOAD ISLAND FROM RELEASE 01 LEVELS

--mission 02
function LoadIsland01FromM02(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_underbelly, presetCampfire);
end

--mission 03
function LoadIsland01FromM03(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_spire_01, presetCampfire);
end

--mission 04
function LoadIsland01FromM04(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_spire_02, presetCampfire);
end

function LoadIsland01FromForerunnerDallas(presetCampfire:boolean):void
	LoadLevelFromTable(g_levelTable.from_forerunner_dallas, presetCampfire);
end

-- LOAD PROTOTYPE MAPS
-- Prototype Game Hub
function LoadCampaignHub():void
	LoadLevelFromTable(g_levelTable.campaign_hub);
end

function LoadFiringRange():void
	LoadLevelFromTable(g_levelTable.firing_range);
end

function LoadFobTest():void
	LoadLevelFromTable(g_levelTable.fob_test);
end

-- Prototype Citadel
function LoadSpire01():void
	LoadLevelFromTable(g_levelTable.spire);
end

function LoomSpire01():void
	LoomLevelFromTable(g_levelTable.spire);
end

-- Prototype Shenanigans
function LoadShenanigans01():void
	LoadLevelFromTable(g_levelTable.shenanigans);
end

-- Prototype power tether
function LoadPowerTether():void
	LoadLevelFromTable(g_levelTable.power_tether);
end

-- Prototype Supply Lines
function LoadSupplyLines():void
	LoadLevelFromTable(g_levelTable.supply_lines);
end

-- Prototype vehicle base
function LoadVehicleBase01():void
	LoadLevelFromTable(g_levelTable.vehicle_base);
end

-- Prototype outpost
function LoadOutpost():void
	LoadLevelFromTable(g_levelTable.outpost);
end

-- Prototype vehicle_demo
function LoadVehicleDemo():void
	LoadLevelFromTable(g_levelTable.vehicle_demo);
end

-- Prototype underbelly
function LoadUnderbelly():void
	LoadLevelFromTable(g_levelTable.underbelly);
end

-- Prototype jailbreak02
function LoadJailbreak02():void
	LoadLevelFromTable(g_levelTable.jailbreak02);
end

-- Prototype dungeon_cortana
function LoadDungeonCortana():void
	LoadLevelFromTable(g_levelTable.dungeon_cortana);
end

--dung_inq_1
function LoadDungInq1():void
	LoadLevelFromTable(g_levelTable.dung_inq_1);
end

-- Prototype temp_spartanmem1
function LoadSpartanMemory1():void
	LoadLevelFromTable(g_levelTable.temp_spartanmem1);
end

-- Prototype spm_overworld001
function LoadSpartanMemoryOverworld():void
	LoadLevelFromTable(g_levelTable.spm_overworld001);
end

-- Prototype dynamic_events
function LoadDynamicEvents():void
	LoadLevelFromTable(g_levelTable.dynamic_events);
end

--Prototype interactions_gym
function LoadInteractionsGym():void
	LoadLevelFromTable(g_levelTable.interactions_gym);
end

--banished_gym
function LoadBanishedGym():void
	LoadLevelFromTable(g_levelTable.banished_gym);
end

--banished_ship_gym
function LoadBanishedShipGym():void
	LoadLevelFromTable(g_levelTable.banished_ship_gym);
end

--cave_gym
function LoadCaveGym():void
	LoadLevelFromTable(g_levelTable.cave_gym);
end

--forerunner_gym
function LoadForerunnerGym():void
	LoadLevelFromTable(g_levelTable.forerunner_gym);
end

--natural_spaces_gym
function LoadNaturalSpacesGym():void
	LoadLevelFromTable(g_levelTable.natural_spaces_gym);
end

--Prototype refinery_base
function LoadRefineryBase():void
	LoadLevelFromTable(g_levelTable.refinery_base);
end

-- Loading screen
function HoldLoadScreenForCinematic()
	if (editor_mode() == true) then
		return;
	end

	-- Force to black screen in event of direct launching via HL or a player replaying mission
	Composer_FadeOut(0, 0, 0, 0);

	local loadScreenVars:table = TableRepository.GetOrRegisterTable("LoadScreenVars");
	loadScreenVars.loadScreenOverride = true;
	RunClientScript("HoldLoadScreenForCinematic");
	Engine_AddShowWarmingUpLoadingScreenRef();
	CreateThread(WaitForCinematicToDropLoadScreen);	
end

--## CLIENT

-- Looming
function remoteClient.LoomLevelClient(level:string, zoneSet:string, spawnPoint:string_id)
	LoomScenarioAtSpawn(level, zoneSet, spawnPoint);
end

-- Loading screen
function remoteClient.HoldLoadScreenForCinematic()
	local loadScreenVars:table = TableRepository.GetOrRegisterTable("LoadScreenVars");
	loadScreenVars.loadScreenOverride = true;
	Engine_AddShowWarmingUpLoadingScreenRef();
	CreateThread(WaitForCinematicToDropLoadScreen);	
end

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- ONLY CLIENT/SERVER CODE BEYOND THIS POINT, thanks in advance.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--## COMMON

function ShowLoadingScreen(shouldShow:boolean)
	local loadScreenVars:table = TableRepository.GetOrRegisterTable("LoadScreenVars");
	if (not loadScreenVars.loadScreenOverride) then
		Engine_ShowWarmingUpLoadingScreen(shouldShow);
	end
end

function WaitForCinematicToDropLoadScreen()
	SleepUntilSeconds([| composer_show_scene_is_playing()], Game_TimeApproxFramesToSeconds(1), 20);	
	Engine_ReleaseShowWarmingUpLoadingScreenRef();
	local loadScreenVars:table = TableRepository.GetOrRegisterTable("LoadScreenVars");
	loadScreenVars.loadScreenOverride = false;
end
