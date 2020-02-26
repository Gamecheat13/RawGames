--## SERVER

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- *_*_*_*_*_*_*_ GLOBAL MISSION SCRIPT *_*_*_*_*_*_*_*_*
-- *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*

--[[

Functions:

StartMission(mission:table)									--Start a new mission
EndMission(mission:table)									--Tell a mission to end
CreateMissionThread(mission:table, func:ifunction, ...)		--Create a thread, tracked in our mission table, so we can kill it, if needed
Sys_KillAllThreads(storage:table)							--Kill all threads in storage
StartInsertionPoint(mission:table)					--start an insertpoint point (teleports players and sets the profile)


----Example-----

global mission1:table=
{
	--name of the mission
	name = "Mission1",
	
	--points to blip to show the way through the mission
	breadCrumbs = {FLAGS.temp_mission1_flag1, FLAGS.temp_mission1_flag2},
	
	--description of the mission
	description = "Mission1: Follow the path.",
	
	--starting profiles to set for each player
	profiles = {STARTING_PROFILES.profile1, STARTING_PROFILES.profile2, STARTING_PROFILES.profile3, STARTING_PROFILES.profile4},
	
	--the point set of points that the players will teleport to if this is an insertion point
	points = POINTS.point_sets_1,
}


function mission1.Start()
end


function mission1.End()
	StartMission2();
end


To start a mission call:
StartMission(mission1);

--]]


global g_currentMission:table = nil;

function IsAnyMissionActive():boolean
	return g_currentMission ~= nil;
end

function IsMissionActive(mission:table):boolean
	return g_currentMission == mission;
end

--Start a new mission
function StartMission(mission:table, isblinking:boolean)
	if not IsServer() then
		error ("StartMission was called on the client, try running me on the server with: ServerCmd()");
--		return print ("this is the client, run me on the server");
	end
	--Validate the mission passed in is valid and guarantee that only one
	--mission is running at a time.
	if (mission == nil) then
		print("StartMission: Failed to start nil mission");	
		return;
	end

	if (g_currentMission ~= nil) then
		print("StartMission: Failed to start mission '", GetMissionName(mission), "'. Mission '", GetMissionName(g_currentMission), "' is still active, please stop it first.");
		return;
	end
	
	if(isOsirisCampaignUR) then
		fade_in(0,0,0,0);
	end
	
	local hasOnePlayer = false;
	repeat
		-- Do not start the mission until all players have spawned in as a unit
		for key,aPlayer in pairs(players()) do
			if(aPlayer ~= nil) then
				if(player_get_unit(aPlayer) ~= nil) then
					print("A player has spawned!");
					hasOnePlayer = true;
					break;
				end
			end
		end
		Sleep(1);
	until hasOnePlayer == true
	Sleep(2);
	print("Players spawned, resetting metagame timer");
	campaign_metagame_reset_timer();
	
	--set the variable to the mission name
	g_currentMission = mission;

	--Clear runningThreadId
	mission.runningThreadId = {};

	--Print out the name
	if (mission.name ~= nil) then
		--print("Starting ", mission.name);
		SetDebugMissionName(mission.name);
		print ("Starting Mission: ", mission.name);
	else
		print ("PLEASE NAME THIS MISSION");
	end
	
	--Display any descripting of the mission
	if (mission.description ~= nil) then
		set_text_defaults();
		set_text_color(1, 0.9764706, 0.9764706, 0.9764706);
		set_text_lifespan(300);
		set_text_font(FONT_ID.terminal);
		set_text_justification(TEXT_JUSTIFICATION.center);
		set_text_alignment(TEXT_ALIGNMENT.top);
		set_text_scale(1);
		set_text_margins(0, 0.12, 0, 0);
		set_text_shadow_style(TEXT_DROP_SHADOW.drop);
		
		show_text(mission.description);
	end

	--Start the breadcrumbs		
	if(mission.breadCrumbs ~= nil) then
		
		CreateMissionThread(TrackBreadCrumbs, mission);
		
	end


--	--Create any collectibles used by this mission
--	if(mission.collectibles ~= nil) then
--
--		CreateCollectibles(mission);
--
--	end

	--Call the Start function for this mission	
	if (mission.Start ~= nil) then
		
		CreateMissionThread(mission.Start);
	end

	--Start the goal(s) unless blinking
	if mission.startGoals ~= nil and not isblinking then
		for _,v in ipairs(mission.startGoals) do
			GoalStart(mission, v);
	  end
	end
	
end



--Display a list of nav points, one at a time until any player reaches, it. Then call End on the mission.
function TrackBreadCrumbs(mission:table)

	--Make sure we have players available
	SleepUntil([| player_get_first_alive() ~= nil], 3);

	local index:number = 1;

	while (mission.breadCrumbs[index] ~= nil) do

		--Add a navpoint
		navpoint_track_flag_named(mission.breadCrumbs[index], "navpoint_goto");

		--Wait until we are close to the nav point
		SleepUntil([| objects_distance_to_flag(players(), mission.breadCrumbs[index]) > 0 and objects_distance_to_flag(players(), mission.breadCrumbs[index]) < 5], 3);

		--Remove navpoint
		navpoint_track_flag(mission.breadCrumbs[index], false);

		index = index+1;
	end

	EndMission(mission);
end

--unblips any blipped breadcrumbs
function DeleteBreadCrumbs(mission:table)

	SleepUntil([| player_get_first_alive() ~= nil], 3);

	local index:number = 1;

	while (mission.breadCrumbs[index] ~= nil) do

		--Remove navpoint
		navpoint_track_flag(mission.breadCrumbs[index], false);

		index = index+1;
	end

end

---- Create all of our collectibles.
--function CreateCollectibles(mission:table)
--
--	for _,collectible in ipairs(mission.collectibles) do
--		-- We are always creating collectibles for now, even if they have been 
--		-- already collected.
--		local collectibleObject = object_create_anew(collectible.objectName);
--	end
--end

--Tell a mission to end
function EndMission(mission:table, iskilling:boolean)

	--Validate the mission passed in is valid & the active mission.
	if (mission == nil) then
		print("EndMission: Failed to end nil mission");
		return;
	end

	if (g_currentMission ~= mission) then	
		print("EndMission: Failed to end mission '", GetMissionName(mission), "'. It is not the active mission (",GetMissionName(g_currentMission),").");
		return;
	end
	
	--completing all the goals before ending the mission to try to catch any dangling threads
	GoalCompleteAllGoals();

	--If we have a mission name, print it out
	if (mission.name ~= nil) then
		print("Ending ", mission.name);
	end

	--Kill all threads still running for this mission
	Sys_KillAllThreads(mission);

	--Unblip any remaining breadcrumbs
	if(mission.breadCrumbs ~= nil) then
		CreateMissionThread(DeleteBreadCrumbs, mission);
	end
	
	--Fade out and display debug text if fadeOutMission is "no"
	if mission.endFadeOut == "yes" and not iskilling then
	
		FadeOutMission();
		
		--Tell people it is complete
		local n_end_seconds:number = 5;
		
		set_text_defaults();
		set_text_color(1, 0.9764706, 0.9764706, 0.9764706);
		set_text_lifespan(seconds_to_frames(n_end_seconds));
		set_text_font(FONT_ID.terminal);
		set_text_justification(TEXT_JUSTIFICATION.center);
		set_text_alignment(TEXT_ALIGNMENT.center);
		set_text_scale(1);
		set_text_margins(0, 0.12, 0, 0);
		set_text_shadow_style(TEXT_DROP_SHADOW.drop);
			
		show_text("MISSION COMPLETE");
	
		sleep_s (n_end_seconds);
	end
	
	--Mark the currentMission as nil. This allows a new mission to start in the
	--old mission's End function.
	g_currentMission = nil;
	

	--Call any existing End function	
	if mission.End ~= nil and not iskilling then
		mission.End();
	end
	
	if editor_mode() then 
		FadeInMission();
	end
end

function EndCurrentMission()
	print ("Ending current mission and all its goals");
	EndMission (g_currentMission);
end

function MissionKillCurrent()
	print ("Killing current mission");
	EndMission (g_currentMission, true);
end


--Create a thread, tracked in our mission table. The thread will automatically be
--cleaned up when the mission completes.
function CreateMissionThread( func:ifunction, ...)

	Sys_RunTrackedThread(g_currentMission, func, ...);
end


--Starts a thread that will be tracked in storage using the runningThreadId table.
--Calls func with ... params.
function Sys_RunTrackedThread(storage:table, func:ifunction, ...)

	--We need to immediately store the threadId in storage in case Sys_KillAllThreads
	--is called later in our current context.
	local threadId:thread = CreateThread(Sys_RunTrackedThreadInternal, storage, func, ...);
	storage.runningThreadId[threadId] = threadId;
end

-- Internal function used to do work for Sys_RunTrackedThread.
function Sys_RunTrackedThreadInternal(storage:table, func:ifunction, ...)

	--Call the function, with provided params
	func(...);

	--Remove the thread from the table of running threads.
    storage.runningThreadId[GetCurrentThreadId()] = nil;
end


--Kill all threads started with Sys_RunTrackedThread in storage.
function Sys_KillAllThreads(storage:table)

	--Get the id of the thread we are running
    local localThreadId:thread = GetCurrentThreadId();

	--Go through all current running threads
	for _,value in pairs(storage.runningThreadId) do

		--Kill the thread, unless its our thread
		if (localThreadId ~= value) then
			KillThread(value);
		end

		--Remove from the list
		storage.runningThreadId[value] = nil;
	end
end


--sets the player profile for each of the players
function Sys_SetPlayerProfile (mission:table)
	if mission.profiles ~= nil then
		for k,player in ipairs (players()) do
			if mission.profiles[k] == nil then
				k = 1;
			end
			player_set_profile (mission.profiles[k], player);
			print ("setting ", player, " to profile", mission.profiles[k]);
		end
	else
		print ("no player profiles to set");
	end
end

--sets and forces the player profile for each of the players
function Sys_ForcePlayerProfile (mission:table)
	if mission.profiles ~= nil then
		for k,player in ipairs (players()) do
			if mission.profiles[k] == nil then
				k = 1;
			end
			player_set_profile (mission.profiles[k], player);
			unit_add_equipment (player, mission.profiles[k], true, false);
			print ("forcing ", player, " to profile", mission.profiles[k]);
		end
	else
		print ("no player profiles to set");
	end
end

--teleports the players to the points in the table
function Sys_TeleportPlayers (mission:table)
	--wait until the players are alive
	SleepUntil([| player_get_first_alive() ~= nil], 3);
	
	if mission.points ~= nil then
		for k,player in ipairs (players()) do
			object_teleport (player, mission.points[k]);
			print ("teleporting", player, "to point", mission.points[k]);
		end
	else
		print ("no points to teleport the player");
	end
end

function FadeOutMission()
	print ("fade out");
	fade_out (0,0,0,60);
	player_control_fade_out_all_input(1);
	sleep_s(1);
end

function FadeInMission()
	print ("fade in");
	
	fade_in (0,0,0,60);
	player_control_fade_in_all_input(1);
	sleep_s(1);
end

function FadeOutMission_cin()
	print ("fade out");
	--fade_out (1,1,1,1);
	for _,player in ipairs (players()) do
		fade_out_for_player(player);
		
		player_control_fade_out_all_input(1);
	end
	
end

function FadeInMission_cin()
	print ("fade in");
	

	for _,player in ipairs(players()) do
		fade_in_for_player(player);
		
		player_control_fade_in_all_input(1);
	end
end


function LoadNextMission(scenario:string)
	print ("loading next mission called", scenario)
	if not editor_mode() then
		StartScenario (string);
	else
		print ("in editor, not loading the next level");
	end
end

-- Returns the given mission's name, handles nil mission's gracefully.
function GetMissionName(mission:table):string
	if (mission ~= nil) then
		return mission.name;
	end

	return "NONE"
end
