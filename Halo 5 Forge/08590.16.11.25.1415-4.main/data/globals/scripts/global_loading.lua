--## SERVER

-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- LOADING SCRIPTS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------


function sys_LoadHalsey()
	print ("Load Halsey Mission");
	sys_LoadScenario (t_scenarioTable.halsey);
end

function sys_LoadCin_030()
	print ("Load cinema_030");
	sys_LoadScenario (t_scenarioTable.cin_030);
end

function sys_LoadAssaultOnStation()
	print ("Load Assault on Station Mission");
	sys_LoadScenario (t_scenarioTable.assault);
end

function sys_LoadCin_060()
	print ("Load cinema_060");
	sys_LoadScenario (t_scenarioTable.cin_060);
end

function sys_LoadMeridian()
	print ("Load Meridian Mission");
	sys_LoadScenario (t_scenarioTable.meridian);
end

function sys_LoadW1Hub()
	print ("Load W1Hub Mission");
	sys_LoadScenario (t_scenarioTable.miningtown);
end


function sys_LoadUnconfirmedReports()
	print ("Load Unconfirmed Reports Mission");
	sys_LoadScenario (t_scenarioTable.unconfirmed);
end

function sys_LoadEvacuation()
	print ("Load Evacuation Mission");
	sys_LoadScenario (t_scenarioTable.evacuation);
end

function sys_LoadCin_110()
	print ("Load cinema_110");
	sys_LoadScenario (t_scenarioTable.cin_110);
end

function sys_LoadBuilder()
	print ("Load Builder Mission");
	sys_LoadScenario (t_scenarioTable.builder);
end

function sys_LoadCin_120()
	print ("Load cinema_120");
	sys_LoadScenario (t_scenarioTable.cin_120);
end

function sys_LoadGrotto()
	print ("Load Grotto Mission");
	sys_LoadScenario (t_scenarioTable.grotto);
end


function sys_LoadW2Hub()
	print ("Load Covenant Hub Mission");
	sys_LoadScenario (t_scenarioTable.campsite);

end

function sys_LoadPlateau()
	print ("Load Plateau Mission");
	sys_LoadScenario (t_scenarioTable.plateau);
end

function sys_LoadW2Hub_2()
	print ("Load Covenant Hub Mission 2");
	sys_LoadScenario (t_scenarioTable.campsitereturn);
end

function sys_LoadTitanAtTsunami()
	print ("Load Titan at Tsunami Mission");
	sys_LoadScenario (t_scenarioTable.tsunami);
end

function sys_LoadArrival()
	print ("Load Arrival Mission");
	sys_LoadScenario (t_scenarioTable.arrival);
end


function sys_LoadTrials()
	print ("Load Trials Mission");
	sys_LoadScenario (t_scenarioTable.trials);
end

function sys_LoadSentinels()
	print ("Load Sentinels Mission");
	sys_LoadScenario (t_scenarioTable.sentinels);
end

function sys_LoadEnding()
	print ("Load end of game");

	sys_LoadScenario ({"end of game"});
end

function IsCombatMission():boolean
	local id:number = get_campaign_mission_id();
	print("campaign id is " .. id);
	return not (id == -1 or id == 3 or id == 8 or id == 10);
end

function BeatParTime():boolean
	local id:number = get_campaign_mission_id();
	return IsCombatMission () and campaign_metagame_get_time_seconds() < get_mission_par_time (id);
end

function sys_LoadScenario (scenario:table)
	if not editor_mode() then
		--un comment this when there is function for determining if a mission is on Thunderhead
		--	if OnThunderhead then
		--		NetSetUICampaignMap(path);
		--		NetStartUICampaign();
		--	else
		
		-- Make sure a player is actually alive before triggering the next mission to prevent rare softlocks
		-- that can happen when people die during the PGCR.
		SleepUntil([|player_get_first_alive() ~= nil], 1);
		
		if campaign_metagame_enabled() and not is_infinity_mission() then
			campaign_metagame_time_pause(true);
			campaign_finalize_scores();
			RunClientScript("SetLastMissionCompletedTimeClient", campaign_metagame_last_mission_time_get());
			
			-- Freeeze the physics sim and make all player's units unable to die.
			-- The game is technically still running while the pgcr is up, and players dying can get
			-- things into a bad state.
			if(scenario ~= t_scenarioTable.trials) then
				-- Arrival does weird zone set stuff that actually makes putting the players into limbo unsafe,
				-- but they're actually already in psuedo-limbo. So it's okay to skip this in that case.
				ToggleLimboForAllPlayers(true);
			end
			
			for _, v in ipairs (players()) do
				object_cannot_die(player_get_unit(v), true);
			end
			
			sleep_s (1);
			
			if IsCombatMission() then
				local num_players:number = game_coop_player_count();
				local min_score:number = math.huge;
				local max_score:number = 0;
				
				for _, v in ipairs (players()) do
					local score:number = campaign_metagame_get_player_score (v);
					min_score = math.min (score, min_score);
					max_score = math.max (score, max_score);
					if score > n_parScoreToBeat then
						CampaignScriptedAchievementUnlocked(29);
					end
				end
				
				if max_score > n_arcadeScoreToBeat then
					CampaignScriptedAchievementUnlocked(25);
				end
				if get_total_skull_multiplier() >= 2 and max_score > n_skullScoreToBeat then
					CampaignScriptedAchievementUnlocked(26);
				end
				if num_players > 1 and min_score > n_minScoreInFireteamToBeat then
					CampaignScriptedAchievementUnlocked(27);
				end
				if BeatParTime() then
					CampaignScriptedAchievementUnlocked(28);
				end
			end
		end
		
		local path:string = scenario[1];
		print("loading scenario ", path);
		GameIsSafeToResetFromIron = false;
		game_won();
	else
		print ("in editor, not loading new scenario");
	end
end


-- =================================================================================================
-- LOOMINGSCRIPTS
-- =================================================================================================
-- =================================================================================================
-- =================================================================================================
-- -------------------------------------------------------------------------------------------------

global t_scenarioTable:table =
	{
		halsey = {"levels\\campaignworld030\\w3_halsey\\w3_halsey", ""},
		cin_030 = {"levels\\cinematics\\cin_030\\cin_030", ""},
		assault = {"levels\\campaignworld040\\w4_station\\w4_station", ""},
		cin_060 = {"levels\\cinematics\\cin_060\\cin_060", ""},
		meridian = {"levels\\campaignworld010\\w1_meridian\\w1_meridian", ""},
		miningtown = {"levels\\campaignworld010\\w1_miningtown\\w1_miningtown", ""},
		unconfirmed = {"levels\\campaignworld010\\w1_unconfirmed_reports\\w1_unconfirmed_reports", ""},
		evacuation = {"levels\\campaignworld010\\w1_evacuation\\w1_evacuation", ""},
		cin_110 = {"levels\\cinematics\\cin_110\\cin_110", ""},
		builder = {"levels\\campaignworld030\\w3_builder\\w3_builder", ""},
		cin_120 = {"levels\\cinematics\\cin_120\\cin_120", ""},
		grotto = {"levels\\campaignworld020\\w2_grotto\\w2_grotto", ""},
		campsite = {"levels\\campaignworld020\\w2_campsite\\w2_campsite", ""},
		plateau = {"levels\\campaignworld020\\w2_plateau\\w2_plateau", ""},
		campsitereturn = {"levels\\campaignworld020\\w2_campsite_return\\w2_campsite_return", ""},
		tsunami = {"levels\\campaignworld020\\w2_tsunami\\w2_tsunami", ""},
		arrival = {"levels\\campaignworld030\\w3_arrival\\w3_arrival", ""},
		trials = {"levels\\campaignworld030\\w3_citadel\\w3_citadel", ""},
		sentinels = {"levels\\campaignworld030\\w3_innerworld\\w3_innerworld", ""},
		
	};

global n_loomTimer:number = 0;

global n_parScoreToBeat:number = 500000;
global n_minScoreInFireteamToBeat:number = 200000;
global n_skullScoreToBeat:number = 50000;
global n_arcadeScoreToBeat:number = 10000;

function loomtest(scenario:string, zoneset:string)
	LoomScenario (scenario, zoneset);
	print ("looming ", scenario);
	print ("looming ", zoneset);
	--local timer:number = 0;
	n_loomTimer = 0;
	repeat
		sleep_s (1);
		n_loomTimer = n_loomTimer + 1;
		print ("seconds to loom is ", n_loomTimer);
	until not ScenarioLoomInProgress();
	--SleepUntil ([| not ScenarioLoomInProgress() ], 1);
	print ("loom done");
end

function loomNow(map:string)
	--print ("looming ",t_loomTable[map][1]);
	--print (t_loomTable[map][2]);
	loomtest (t_scenarioTable[map][1], t_scenarioTable[map][2]);
end




-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- ONLY CLIENT/SERVER CODE BEYOND THIS POINT, thanks in advance.
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--## CLIENT
function remoteClient.SetLastMissionCompletedTimeClient(missionTimeSeconds:number)
	campaign_metagame_last_mission_time_set(missionTimeSeconds);
end
