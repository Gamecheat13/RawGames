--## SERVER

-- *-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
-- *_*_*_*_*_*_*_ GLOBAL MISSION SCRIPT *_*_*_*_*_*_*_*_*
-- *_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*

--[[


--Add your start goal(s) to your mission
global mission1:table=
{
	startGoals = {"goal_BaseCamp"},
}



--Example of simple goal using gotoflag
missionPlateau.goal_BaseCamp = 
{
	description = "Rendezvous with the Engineers",
	gotoFlags = {FLAGS.crumb0},

	next = {"goal_Breach"};
}


--Example of simple goal using gotoVolume and navPoint
missionPlateau.goal_Breach = 
{
	gotoVolume = VOLUMES.tv_breach,
	navPoint = FLAGS.crumb1,
	objective = {"tracking_object1", "tracking_object2"},
	next = {"goal_Caves"},
}



--Optional Start function can be added to be called AFTER the goal has started
function missionPlateau.goal_SentryShipEncounter.Start():void

	GoalAiPlace(AI.sq_phant_pilots);
	GoalCreateThread(missionPlateau.goal_SentryShipEncounter, pf_sentry_liftoff_conditions);

end



--Optional End function is called AFTER the goal is removed and BEFORE the next goal is triggered
function missionPlateau.goal_Breach.End():void

	f_play_show("vs_wall_destruction");

end

--Optional Cleanup function can be added to be called AFTER the goal has ended (mainly used for blinks for fixing up the gamestate)
function missionPlateau.goal_SentryShipEncounter.Cleanup():void

	object_destroy ("cr_not_important");
	object_create ("cr_important");

end

--Optional Intro function can be added to be called BEFORE the goal has started
function missionPlateau.goal_SentryShipEncounter.Intro():void

	f_play_show("vs_wall_destruction");

end



--Create a Blink function for quick teleporting and startup of the goal
function Blink_Breach()

	GoalBlink(missionPlateau, "goal_SentryShipEncounter", FLAGS.tpf3);

end


--Starting a goal
GoalStart(missionPlateau, "goal_Breach");
--Close all old goals, teleprot to flag and start this goal (and mission)
GoalBlink(missionPlateau, "goal_Breach", FLAGS.tpf3);


--Complete a goal (a goal can have many tasks that needs completing)
GoalCompleteTask(missionPlateau.goal_Breach);
--Increment number of tasks needed performed
GoalAddTask(missionPlateau.goal_Breach);


--Place an Ai in the current goal and remember what goal it belongs to (system will handle Ai garbage collection)
GoalAiPlace(AI.sq_phant_pilots);
--Remove all Ai belonging to this goal
GoalAiRemove(missionPlateau.goal_Breach);


--Create a thread and store its id in our table so that we can kill it later
GoalCreateThread(missionPlateau.goal_Breach, pf_sentry_liftoff_conditions);
--Kill all the threads belonging to this goal
GoalKillAllThreads(missionPlateau.goal_Breach);

--]]

global g_debugGoalsThread:thread = nil;
global g_currentGoal:table = nil;


--Do we need this now that we only have 1 goal running?
--function CreateGoalTrackTable()
--	--local goals = {}
--	local gTrack:table = 
--	{
--		numActiveGoals=0,
--		activeGoals = {},
--	};
--	setmetatable(gTrack, { __index = 
--		function (t,k) 
--			if k=="first" then
--				local _,x = next(t.activeGoals);
--				return x;
--			elseif k=="firstname" then
--				local _,x = next(t.activeGoals);
--				if next(t.activeGoals,_) then
--					return DebugGetGoalName (x) .. " ...";
--				else
--					return DebugGetGoalName (x);
--				end
--			end 
--		end });
--	return gTrack;
--end
--
--global goalTrack:table = CreateGoalTrackTable();

-- Returns true if the given goal is active.
function IsGoalActive(goal:table):boolean
	return g_currentGoal == goal;
end
	
-- This gets set when we are completing all goals and do not want to end regular
-- progression of the mission (e.g. blinks)

function GoalStart(mission:table, goalName:string)
	
	--check to see if the goal attempting to start is a real goal, if it isn't then return
	if mission[goalName] == nil then
		error (	"\nBad goal name called on goal start or next goal. Not starting goal.\n"..
				"The bad name is '" .. goalName .. "'.\n" ..
				"Check to see if the mission or goal is spelled correctly.");
		return
	end
	
	local goal:table = mission[goalName];
	
	if g_currentGoal ~= nil then
		error ("\n not starting goal ".. goalName.. " because the goal ".. g_currentGoal.name.. " is active");
		return
	end
	
		--Don't start this goal if it's already started.
	if IsGoalActive(goal) then
		error("\nAttempting to start goal '" .. goalName .. "' twice.");
		return;
	end
	
	g_currentGoal = goal;
	
	--Store name and mission in our table
	goal.mission = mission;
	goal.name = goalName;

	--Clear runningThreadId
	goal.runningThreadId = {};

	--Clear ai tracking
	goal.activeAi = {};
	goal.numActiveAi = 0;

	--Print out the name
	print("Starting goal ", goalName);

	--Track active goals
--	goalTrack.activeGoals[goal] = goal;
--	goalTrack.numActiveGoals = goalTrack.numActiveGoals + 1;

	-- Create the goal and start running its startup functions as a GoalThread
	-- so if the goal gets stopped they get stopped immediately.
	GoalCreateThread(goal, Sys_GoalStart, goal);
end

function ToggleLimboForAllPlayers(useLimbo:boolean)
	-- Ensures players will live through all zone set transitions.
	-- Setting limbo to true disconnects them from physics.
	print("Toggling limbo");
	if(useLimbo == true) then
		-- Make sure no players are in vehicles
		for _,v in ipairs(players()) do
			if(v ~= nil) then
				print("Exiting vehicles");
				unit_exit_vehicle(player_get_unit(v), 0);
			end
		end
		
		-- Gotta wait to get out of those vehicles!
		for _,v in ipairs(players()) do
			if(v ~= nil) then
				print("Waiting til vehicles exited");
				SleepUntil([| unit_in_vehicle(player_get_unit(v)) == false ], 1);
			end
		end
	end
	
	for _,v in ipairs(players()) do
		if(v ~= nil) then
			print("Setting limbo");
			object_set_limbo(player_get_unit(v), useLimbo);
		end
	end
	RunClientScript("ToggleLimboForAllPlayersClient", useLimbo);
	Sleep(10);
end

function Sys_GoalStart(goal:table)

	goal.phase = "Intro";

	--saves the game
	game_save_no_timeout();
	
	--Call the intro function
	if(goal.Intro ~= nil) then
		goal.Intro();
	end

	goal.phase = "Start";

	--Display any descripting of the goal
	if (goal.description ~= nil) then
		set_text_defaults();
		set_text_color(1, 0.9764706, 0.9764706, 0.9764706);
		set_text_lifespan(120);
		set_text_font(FONT_ID.terminal);
		set_text_justification(TEXT_JUSTIFICATION.center);
		set_text_alignment(TEXT_ALIGNMENT.top);
		set_text_scale(1);
		set_text_margins(0, 0.25, 0, 0);
		set_text_shadow_style(TEXT_DROP_SHADOW.drop);
		
		show_text(goal.description);
	end

	--Create any objects flagged in the objectives table
	if goal.objectives then
		for _,obj in ipairs (goal.objectives) do
			print ("turning on tracking for ", obj);
			ObjectSetSpartanTrackingEnabled (obj, true);
			--object_create_anew (obj);
		end
	end

	--Add a navpoint
	if (goal.navPoint ~= nil) then
		navpoint_track_flag_named(goal.navPoint, "navpoint_goto");
	end

	--Add a navpoint hint
	if (goal.navPointHint ~= nil) then
		GoalAddNavpointHint(goal, goal.navPointHint, 30);
	end

	goal.numTasks = 0;

	--Start a goto flags task
	if(goal.gotoFlags ~= nil) then
		GoalCreateThread(goal, GoalGotoFlags, goal);
	end

	--Start a goto volume task
	if(goal.gotoVolume ~= nil) then
		GoalCreateThread(goal, GoalGotoVolume, goal);
	end
	
	--Wait on an object to be used.
	if(goal.useObject ~= nil) then		
		goal.numTasks = goal.numTasks + 1;
		if not object_valid (goal.useObject) then
			object_create_anew (goal.useObject);
		end
		goal.useObjectCallback = GoalCreateUseObjectCallback(goal);
		RegisterInteractEvent(goal.useObjectCallback, OBJECTS[goal.useObject]);
		
	end
	
	--Wait on an object to be destroyed.
	if(goal.destroyObject ~= nil) then		
		goal.numTasks = goal.numTasks + 1;
		if not object_valid (goal.destroyObject) then
			object_create_anew (goal.destroyObject);
		end
		goal.destroyObjectCallback = GoalCreateDestroyObjectCallback(goal);
		RegisterDeathEvent(goal.destroyObjectCallback, OBJECTS[goal.destroyObject]);
		
	end
	
	if(goal.killSquad ~= nil) then		
		goal.numTasks = goal.numTasks + 1;
		goal.killSquadCallback = GoalCreateKillSquadCallback(goal);
		RegisterAIDeathEvent(goal.killSquadCallback, goal.killSquad);
		
	end
	
	--Run the start function
	if(goal.Start ~= nil) then
		goal.Start();
	end
end


function GoalAddNavpointHint(goal:table, navPoint:flag, proximity:number)

	GoalCreateThread(goal, Sys_GoalDisplayInitialHint, navPoint);
	GoalCreateThread(goal, Sys_GoalDisplayProximityHint, navPoint, proximity);
end


function Sys_GoalDisplayInitialHint(navPoint:flag)

	sleep_s (2);
	navpoint_track_flag_named(navPoint, "navpoint_goto");
	sleep_s (4);
	navpoint_track_flag(navPoint, false);
end


function Sys_GoalDisplayProximityHint(navPoint:flag, proximityDistance:number)

	SleepUntil([| objects_distance_to_flag(players(), navPoint) < proximityDistance], 5);
	navpoint_track_flag_named(navPoint, "navpoint_goto");
end


--add a task to the goal of having a player getting close to a flag
function GoalGotoFlags(goal:table)

	goal.numTasks = goal.numTasks + 1;
	local index:number = 1;

	while (goal.gotoFlags[index] ~= nil) do

		--Add a navpoint
--		local orderId:number = MusketeersOrderMoveTo(PLAYERS.player0, goal.gotoFlags[index], true);
		navpoint_track_flag_named(goal.gotoFlags[index], "navpoint_goto");

		--Wait until a player spawns & we are close to the nav point
		SleepUntil([| list_count(players()) > 0 and objects_distance_to_flag(players(), goal.gotoFlags[index]) < 5], 3);

		--Remove navpoint
		navpoint_track_flag(goal.gotoFlags[index], false);
--		MusketeersOrderCancel(orderId);

		index = index+1;
	end

	GoalCompleteTask(goal);
end


--add a task to the goal of having a player entering a trigger volume
function GoalGotoVolume(goal:table)

	goal.numTasks = goal.numTasks + 1;
	SleepUntil([| volume_test_players(goal.gotoVolume) ], 1);
	GoalCompleteTask(goal);

end

--add a task to the goal of having a player interact with an object
function GoalCreateUseObjectCallback(goal:table)
	return 
		function(interactee:object, interacter:object)
			GoalCompleteTask(goal);
			goal.useObjectCallback = nil;
		end
end

--add a task to the goal of having an object get destroyed
function GoalCreateDestroyObjectCallback(goal:table)
	return 
		function(interactee:object, interacter:object)
			GoalCompleteTask(goal);
			goal.destroyObjectCallback = nil;
		end
end

--add a task to the goal of having a squad killed
function GoalCreateKillSquadCallback(goal:table)
	return 
		function(interactee:object, interacter:object)
			GoalCompleteTask(goal);
			goal.killSquadCallback = nil;
		end
end

--Create Manual nav points mid goal
function GoalCreateManualNavPoint( goal:table, navPoint:flag, replace_current:boolean)
	if replace_current then
		navpoint_track_flag(goal.navPoint, false);
	end
	goal.navPoint = navPoint;
	navpoint_track_flag_named(goal.navPoint, "navpoint_goto");
end

--REMOVE Manual nav points mid goal
function GoalRemoveManualNavPoint( goal:table, navPoint:flag)
	goal.navPoint = navPoint;
	navpoint_track_flag(goal.navPoint, false);
end

--Create a thread, tracked in our goal table. The thread will automatically be 
--cleaned up when the goal completes. -- keeping this function around for backwards compatibility -- gmu 11/26/2014
function GoalCreateThread(storage:table, func:ifunction, ...)
	Sys_RunTrackedThread(storage, func, ...);
end

--creates a goalthread with the current goal
function GoalThread (func:ifunction, ...)
	Sys_RunTrackedThread (g_currentGoal, func, ...);
end

--completes the current goal
function GoalCompleteCurrent()
	GoalComplete (g_currentGoal);
end


function GoalComplete(goal:table, isblinking:boolean)

--check to see if the goal attempting to complete is active or nil, if it is then return
	--if goal == nil then
	if goal == nil then
		error ("bad goal table called on GoalComplete  Not completing goal\n"..
					"the bad name is '".. DebugGetGoalName(goal).."'\n"..
					"Check to see if the mission or goal is spelled correctly");
	elseif not IsGoalActive(goal) then
	--elseif g_currentGoal ~= goal then
		error ("goal table called on GoalComplete is not the active goal.  Not completing goal\n"..
					"the goal called is '".. DebugGetGoalName(goal).."'\n"..
					"only an active goal can be completed");
	end
	
	print ("completing goal ", goal.name);
	
	--Add this goal to the missions garbage collector
	if(goal.numActiveAi > 0) then

		AiGarbageCollectorAdd(goal);
	end

	--Stop all threads belonging to this goal
	Sys_KillAllThreads(goal);

	--Stop tracking this goal
--	goalTrack.activeGoals[goal] = nil;
--	goalTrack.numActiveGoals = goalTrack.numActiveGoals - 1;

	--Remove breadcrumbs
	if(goal.gotoFlags ~= nil) then
		local index:number = 1;
		while (goal.gotoFlags[index] ~= nil) do
			navpoint_track_flag(goal.gotoFlags[index], false);
			index = index+1;
		end
	end

	--Remove any navpoint
	if (goal.navPoint ~= nil) then
		navpoint_track_flag(goal.navPoint, false);
	end
	
	--Remove interact callback
	if (goal.useObjectCallback ~= nil) then
		UnregisterInteractEvent(goal.useObjectCallback, goal.useObject);
	end
	
		--Remove destroy object callback
	if (goal.destroyObjectCallback ~= nil) then
		UnregisterInteractEvent(goal.destroyObjectCallback, goal.destroyObject);
	end
	
		--Remove kill squad callback
	if (goal.killSquadCallback ~= nil) then
		UnregisterInteractEvent(goal.killSquadCallback, goal.killSquad);
	end

	--Remove any navpoint hint
	if (goal.navPointHint ~= nil) then
		navpoint_track_flag(goal.navPointHint, false);
	end

	--Destroy any objects flagged in the objectives table
	if goal.objectives then
		for _,obj in ipairs (goal.objectives) do
			ObjectSetSpartanTrackingEnabled (obj, false);
		end
	end
	
	goal.phase = "End";

	--Call the end function
	if not isblinking and goal.End ~= nil then
		goal.End();
	end

	-- Always call Cleanup, even if we are blinking.
	if (goal.Cleanup ~= nil) then
		goal.Cleanup();
	end
	
	g_currentGoal = nil;
	
	--Start the next goal(s)
	if not isblinking and goal.next ~= nil then
		GoalStart(goal.mission, goal.next[1]);
--		for _,v in ipairs(goal.next) do
--			GoalStart(goal.mission, v);
--		end
	end
end


function GoalCompleteCurrentTask ()
	GoalCompleteTask (g_currentGoal);
end

--completes a task from a goal
function GoalCompleteTask(goal:table)

	if goal == nil then
		error ("bad goal table called on GoalCompleteTask.  Not completing goal\n"..
					"the bad name is '".. DebugGetGoalName(goal).."'\n"..
					"Check to see if the mission or goal is spelled correctly");
	elseif not IsGoalActive(goal) then
		error ("goal called on GoalCompleteTask is not the active goal.  Not completing goal\n"..
					"the goal called is '".. DebugGetGoalName(goal).."'\n"..
					"only an active goal can be completed");
	end
	--Subtract tasks
	goal.numTasks = goal.numTasks - 1;
	print("Completed task for Goal ", goal.name, ". Remaining = ", goal.numTasks);

	--Wait for all tasks to be done
	if(goal.numTasks > 0) then 
		return;
	end

	--Complete the goal
	GoalComplete(goal);
end





--Increment number of tasks needed performed
function GoalAddTask(goal:table)

	goal.numTasks = goal.numTasks + 1;
end


function GoalAiPlace (aiDesc:ai)
	sys_GoalAiPlace (g_currentGoal, aiDesc);
end

--Place an Ai and remember what goal it belongs to (system will handle Ai garbage collection)
function sys_GoalAiPlace(goal:table, aiDesc:ai)

	--Create the ai
	ai_place(aiDesc);

	--(TODO: do all this before we do ai place, by exposing the number of units in a squad, before its created)

	--Store the ai and accumulate the number of ai created in it
	local count:number = ai_living_count(aiDesc);
	goal.activeAi[aiDesc] = count;
	goal.numActiveAi = goal.numActiveAi + count;

	--Update our garbage collector
	AiGarbageCollectorUpdate(count);

end



--Remove all Ai belonging to this goal
function GoalAiRemove(goal:table)

	--Go through all active Ai
	for aiDesc,count in pairs(goal.activeAi) do

		--erase the ai
		ai_erase(aiDesc);

		--Remove from the list
		goal.activeAi[aiDesc] = nil;
	end

	--Remove this goal from the garbage collector
	AiGarbageCollectorRemove(goal, goal.numActiveAi);

	--Decrement count
	goal.numActiveAi = 0;

end



--Kill all the threads belonging to this goal
function GoalKillAllThreads(goal:table)

	Sys_KillAllThreads(goal);
end

--kills all the active goals (for shutting down a mission with a debug script, for example)
function GoalCompleteAllGoals()
	print ("Completing currently active goal");
	if g_currentGoal then
		GoalComplete (g_currentGoal, true);
	end
end




--BLINKING FUNCTION
--Close all old goals, teleport to checkpoints or, optionally, a flag and start this goal (and mission)
--			mission [table] = the name of the mission of the goal you want to blink to
--			goalName [string] = the name of the goal you want to blink to (as a string)
--			spawnFlag [flag] = [optional] a flag to teleport the player to when blinking
function GoalBlink(mission:table, goalName:string, spawnFlag:flag)
	if not IsServer() then
		error ("GoalBlink was called on the client, try running me on the server with: ServerCmd()");
--		return print ("this is the client, run me on the server");
	end
	
	--check to see if the goal attempting to start is a real goal, if it isn't then return
	if mission[goalName] == nil then
		error ("bad goal table called on GoalBlink.  Not blinking to goal\n"..
					"the bad name is '", goalName, "'\n"..
					"Check to see if the mission or goal is spelled correctly");
	end
	
	print ("blinking to goal", goalName);
	
	local goal:table = mission[goalName];
	
	--kill audio
	NarrativeQueue.Kill();
	
	--Stop current mission and goal
	--if g_currentMission ~= mission and g_currentMission ~= nil then
	if g_currentMission ~= nil then
		print ("because of blink, ending current mission named ", g_currentMission);
		--EndCurrentMission();
		MissionKillCurrent();
	
		--Start the mission without starting the first goal
		StartMission(mission, true);
	elseif g_currentMission == nil then
		StartMission(mission, true);
	end
	
	-- Put players in limbo to avoid crazy deaths from teleporting shenanigans
	ToggleLimboForAllPlayers(true);
	
	--Switches zonesets if necessary (mainly for blinks)
	if (goal.zoneSet ~= nil) and (current_zone_set_fully_active() ~= goal.zoneSet) then
		print ("goal is switching zone sets to zoneset", goal.zoneSet);
		switch_zone_set(goal.zoneSet);
		SleepUntil ([| current_zone_set_fully_active() == goal.zoneSet ], 1);
		--sleeping until the client and server are synced
		SleepUntil ([| AllClientViewsActiveAndStable() ], 1);
		-- current_zone_set_fully_active can return when it isn't safe to exit limbo, padding a few extra frames for safety.
		sleep_s (0.5);
		print ("zoneset is fully loaded");
	end

	--Teleport the players
	if spawnFlag ~= nil then
		teleport_player_to_flag (PLAYERS.player0, spawnFlag, true);
		teleport_player_to_flag (PLAYERS.player1, spawnFlag, true);
		teleport_player_to_flag (PLAYERS.player2, spawnFlag, true);
		teleport_player_to_flag (PLAYERS.player3, spawnFlag, true);
	elseif goal.checkPoints ~= nil and #goal.checkPoints == 4 then
			for k = 1,4 do
				object_teleport (SPARTANS[k], goal.checkPoints[k]);
				print ("teleporting", SPARTANS[k], "to point", goal.checkPoints[k]);
			end
	else
		print ("not teleporting players, no valid points specified");
	end
	
	-- Take players out of limbo now that the blink is done
	ToggleLimboForAllPlayers(false);
		
	--fade in (maybe add kill audio here somehow...)
	print ("done blinking, fading in and starting goal");
	fade_in (0, 0, 0, 60);
	
	
	--Start the goal
	GoalStart(mission, goalName);
	
	
	
end


--==================================
--=======AI GARBAGE COLLECTOR=======
--==================================

global aiGarbageCollector:table = 
{
	garbageGoals = {},
	numActiveAi = 0,
	maxNumActiveAi = 50,
};



function AiGarbageCollectorFull() : boolean
	return aiGarbageCollector.numActiveAi > aiGarbageCollector.maxNumActiveAi;
end



function AiGarbageCollectorUpdate(numNewAi:number)

	aiGarbageCollector.numActiveAi = aiGarbageCollector.numActiveAi + numNewAi;

	--Do we need to make some space
	if(AiGarbageCollectorFull()) then
		
		repeat

			local oldestIndex:number = -1;
			local oldestGoal:table = nil;

			--Go through all active goals
			for goal,index in pairs(aiGarbageCollector.garbageGoals) do

				if(oldestGoal == nil or index < oldestIndex) then 
				
					oldestIndex = index;
					oldestGoal = goal;
				end
			end

			if(oldestGoal ~= nil) then 
				--remove the goal
				GoalAiRemove(oldestGoal);
			end

		--Wait until i didnt find anything, or im no longer full
		until oldestIndex == -1 or not AiGarbageCollectorFull()

	end
end



global aiGarbageCollectorInsertIndex:number = 0;

function AiGarbageCollectorAdd(goal:table)

	--Add a goal to be cleared of its ai, when needed
	aiGarbageCollector.garbageGoals[goal] = aiGarbageCollectorInsertIndex;
	aiGarbageCollectorInsertIndex = aiGarbageCollectorInsertIndex + 1;
end



function AiGarbageCollectorRemove(goal:table, numAi:number)

	--Remove this goal from our list, and deduct the number of ais in it
	aiGarbageCollector.numActiveAi = aiGarbageCollector.numActiveAi - numAi;
	aiGarbageCollector.garbageGoals[goal] = nil;
end



--=============================
--=======DEBUG FUNCTIONS=======
--=============================
--turns on a mode where the goals and objectives are printed to the screen
function DebugGoals()
	if g_debugGoalsThread == nil then
		g_debugGoalsThread = CreateThread(DoDebugGoals);
	else
		KillThread(g_debugGoalsThread);
		clear_all_text();
		g_debugGoalsThread = nil;
	end
end

function DoDebugGoals()

	local text_id:number = nil;
	repeat

		local debugString:string = "\r\nMission: " .. GetMissionName(g_currentMission) .. "\r\nActive Goals:\r\n";
		local debugString2:string = "\r\n" .. "\r\n" .. "\r\n" .. "\r\n";
		
		--for _, goal in pairs (goalTrack.activeGoals) do
		local goalString, objectiveString = DebugGetGoalsObjectives();
		debugString = debugString .. goalString  .. "\r\n";
		debugString2 = debugString2 .. objectiveString  .. "\r\n";

		set_text_defaults();
		set_text_color(1, 0.0, 0.9764706, 0.9764706);
		set_text_font(FONT_ID.terminal);
		set_text_justification(TEXT_JUSTIFICATION.left);
		set_text_alignment(TEXT_ALIGNMENT.top);
		set_text_scale(1);
		set_text_shadow_style(TEXT_DROP_SHADOW.drop);
		set_text_margins(0.01, 0.1, 0.0, 0.0);
		
		show_text(debugString);
		show_text(debugString2);
	
		sleep_s(1);

	until false

end

function DebugGetGoalsObjectives()
	local goal:table = g_currentGoal;
	local objective:string = " no objective";
	local objective_type:string = " ";
	local goalString:string = "  Goal: " .. "NO GOAL RUNNING";
	
	if goal then
		goalString = "  Goal: " .. goal.name;
		objective = " <custom objective>";
		
		if(goal.gotoFlags ~= nil) then
			objective = " <goto> ";
			objective_type = GetEngineString (goal.gotoFlags);
		end

		if(goal.gotoVolume ~= nil) then
			objective = " <goto> ";
			objective_type = GetEngineString (goal.gotoVolume);
		end

		if(goal.useObject ~= nil) then
			objective = " <use> ";
			objective_type = GetEngineString (goal.useObject);
		end

		if(goal.destroyObject ~= nil) then
			objective = " <destroy> ";
			objective_type = GetEngineString (goal.destroyObject);
		end

		if(goal.killSquad ~= nil) then
			objective = " <kill> ";
			objective_type = GetEngineString (goal.killSquad);
		end
	end

	local objectiveString:string = "  Objective: " .. objective .. objective_type;
	
	return goalString, objectiveString;
end

-- Print the current Goal and Objective
function DebugPrintGoals()
	local goalString, objectiveString = DebugGetGoalsObjectives();

	print(goalString);
	print(objectiveString);
end

--function for helping test Goals
function DebugGetGoalName(goal:table):string
	if g_currentMission then
		for k,v in pairs (g_currentMission) do
			if v == goal then
				return tostring(k);
			end
		end
	end
	return tostring(goal);
end

--Tests all the goals to see if any are spelled wrong or set up incorrectly
function DebugTestGoals()
	print ("testing all the goals.  LUA will crash if the goals aren't set up properly");
	local goal:string = g_currentMission.startGoals[1];
	local t_goal:table = g_currentMission[goal].next;
	local s_goal:string = t_goal[1];
	print (goal);
	repeat
		print (s_goal);
		if g_currentMission[s_goal].next == nil then
			print ("the goal is nil, error");
			s_goal = nil;
		else
			
			t_goal = g_currentMission[s_goal].next;
			s_goal = t_goal[1];
		end
	until s_goal == nil;
end

global t_masterGoalList =
	{
		"description",
		"navPoint",
		"gotoflags",
		"gotoVolume",
		"useObject",
		"next",
		"zoneSet",
		"checkPoints",
		"Start",
		"End"
	}
	
function DebugTestGoalValues(goal:table)
	print ("debug testing goal ", goal);
	--for key,v in pairs (missionBuilder.goal_start_to_temple1) do
	for key,v in pairs (goal) do
		--print ("blah");
		--print (key);
		--print (v);
		
		--print ("testing", key);
	
		local valid:number = 0;
		for _,val in ipairs (t_masterGoalList) do
			--print (val, "for mobile list is being tested");
			
			if key == val then
				valid = valid + 1;
			end
			
		end
		if valid == 0 then
			print (key, "isn't valid");
		--else
			--print (_, "is valid");
		end		
	end
end

--## CLIENT
function remoteClient.ToggleLimboForAllPlayersClient(useLimbo:boolean)
	-- Ensures players will live through all zone set transitions.
	-- Setting limbo to true disconnects them from physics.
	for _,v in ipairs(players()) do
		if(v ~= nil) then
			object_set_limbo(player_get_unit(v), useLimbo);
		end
	end
end

--function DebugTestGoalValuesMission(mission:table)
--	print ("debug testing mission", mission);
--	--for key,v in pairs (missionBuilder.goal_start_to_temple1) do
--	for key,v in pairs (mission) do
--		--print ("blah");
--		--print (key);
--		--print (v);
--		if type (v) == "table" then
--			print ("testing", key);
--			for _,goal in pairs (v) do
--				local valid:number = 0;
--				for k_key,val in ipairs (mobileList) do
--					--print (val, "for mobile list is being tested");
--					
--					if _ == val then
--						valid = valid + 1;
--					end
--					
--				end
--				if valid == 0 then
--					print (_, "isn't valid");
--				--else
--					--print (_, "is valid");
--				end
--			end
--		end
--	end
--end

--missionBuilder.foo = 
--	{
--		zoneSet = ZONE_SETS.all,
--		blah = "blah"
--	}