-- Copyright (c) Microsoft. All rights reserved.


--## SERVER

local __thisFilenameHash = GetCurrentFileBeingLoaded();

REQUIRES("levels/multi/sgh_interlock/scripts/sgh_interlock_tutorial_narrative.lua");	-- Streams in all the conversation tables that were exported from Gamma


-- Globals
-----------------------------------------------
-- Intro 
global pelican_commander_idle_show:number = nil;
global pelican_commander_idle_show_kit:folder_handle = nil;
global pelican_intro_show_kit:folder_handle = nil;
global pelican_intro_camera_idle_show_kit:folder_handle = nil;
global guard_marines_show:number = nil;
global guard_marines_show_kit:folder_handle = nil;
global war_stories_marines_show:number = nil;
global war_stories_marines_show_kit:folder_handle = nil;
global teaching_marines_show:number = nil;
global teaching_marines_show_kit:folder_handle = nil;
global desk_marine_show:number = nil;
global desk_marine_show_kit:folder_handle = nil;
global tired_marines_show:number = nil;
global tired_marines_show_kit:folder_handle = nil;

-- Course
global console_marines_show:number = nil;
global console_marines_show_kit:folder_handle = nil;
global course_marines_show:number = nil;
global course_marines_show_kit:folder_handle = nil;
global news_marines_show:number = nil;
global news_marines_show_kit:folder_handle = nil;

-- Live fire
global spartans_prep_group_show:number = nil;
global spartans_prep_group_show_kit:folder_handle = nil;
global spartans_prep_one_show:number = nil;
global spartans_prep_one_show_kit:folder_handle = nil;
global live_fire_commander_idle_show:number = nil;
global live_fire_commander_idle_show_kit:folder_handle = nil;


-- Local Helper Methods
-----------------------------------------------
local function GetCommanderIdlePuppet(thisLine:table, thisConvo:table, queue:table, lineId:any):any
	return (live_fire_commander_idle_show and composer_get_puppet_from_show("storm_masterchief", live_fire_commander_idle_show)) or nil;
end

local function GetCommanderIntroIdlePuppet(thisLine:table, thisConvo:table, queue:table, lineId:any):any
	local succeeded,value = table.GetDescendant(KITS.nar_mp_academy_pelican_intro_01_idle, "nar_mp_academy_pelican_intro_01_idle");
	if (succeeded) then
		return composer_get_puppet_from_show("storm_masterchief", value);
	end

	return nil;
end

local function GetDrillSergeantObject(thisLine:table, thisConvo:table, queue:table, lineId:any):any
	return OBJECTS.drill_sergeant_with_face;
end


-- Sequences
-----------------------------------------------
--[========================================================================[
          Academy_PELICAN_intro_01
--]========================================================================]
NarrativeInterface.loadedSequences.TUTORIAL_INTRO = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void

		-- common
		local narrativeVars = TableRepository.GetOrRegisterTable("AcademyNarrative");

		local convoToSplit:string = "mpacademynarrative_academy_pelican_intro_01";
		-- Part 1 doesn't have any lines in it, split on 1 to create an empty convo
		NarrativeInterface.CreateSplitConversations(convoToSplit, __thisFilenameHash, 1);

		-----------------------------------------------------------------

		-- setup part 1

		local convoId1:string = "mpacademynarrative_academy_pelican_intro_01_sub_part1"
		local convo1:table = NarrativeInterface.loadedConversations[convoId1];
		if (not convo1) then return; end
		convo1.show = "nar_mp_academy_pelican_intro_01_camera";
		-- TO DO, figure out if we need to change co-op.  For now defaulting to 0 per guidance from Narrative engineering.
		narrativeVars.player = PLAYERS.player0;

		compdata = compdata or {};
		compdata.callbacks = compdata.callbacks or {};
		convo1.compdata = compdata;
		compdata.look_done = 
			function(state:table):boolean
				return narrativeVars.endLookUp == true;
			end;
		compdata.look_start = 
			function(state:table)
				NarrativeInterface.CreateNarrativeThread(LookUp);
				narrativeVars.LookBannerCall();
			end;
		narrativeVars.timerDuration = 1;

		compdata.StartScript =
			function(state:table)
				hud_show_crosshair(false);
				hud_show_radar(false);
			end;

		compdata.SkipScript =	
			function(state:table)
				narrativeVars.endLookUp = true;
				DisableObjectiveMessage();
				-- Disables activation volume kit that controls the invert tooltip popup
				KITS.tooltip_popup_invert:Disable();
			end;

		compdata.EndScript =
			function(state:table)
				state.callbacks.EndConversation(state);
			end

		-----------------------------------------------------------------

		-- setup part 2

		local convoId2:string = "mpacademynarrative_academy_pelican_intro_01_sub_part2"
		local convo2:table = NarrativeInterface.loadedConversations[convoId2];
		if (not convo2) then return; end
		convo2.show = "nar_mp_academy_pelican_intro_01_camera_part2";

		local compdataPart2:table = {};
		compdataPart2.callbacks = {};
		convo2.compdata = compdataPart2;

		convo2.compdata.EndScript =
			function(state:table)
				state.callbacks.EndConversation(state);
				ReplaceCinematicPelican(); --function declared in sgh_interlock_tutorial_facility.lua
				hud_show_crosshair(true);
				hud_show(true);
			end;

		convo2.compdata.SkipScript =	
			function(state:table)
				print("Skipping intro sequence");
				Object_SetPosition(PLAYERS.player0, ToLocation(FLAGS.academy_intro_skip));
				hud_show_crosshair(true);
				hud_show(true);
				-- Disables activation volume kit that controls the invert tooltip popup
				KITS.tooltip_popup_invert:Disable();
			end;

		-----------------------------------------------------------------

		SleepUntil([|narrativeVars.MovieDone == true],1);

		pelican_intro_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_pelican_intro_01");
		pelican_intro_camera_idle_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_pelican_intro_01_camera");
		pelican_commander_idle_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_pelican_intro_01_idle");		
		-- create and play chain convo
		NarrativeInterface.CreateAndPlayChainConversation( { convoId1, convoId2 }, sequenceId, true );

		local show_idle:string = "nar_mp_academy_pelican_intro_01_idle";
        pelican_commander_idle_show = composer_play_show(show_idle);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief", pelican_commander_idle_show, FLAGS.fl_tutorial_start);
		NarrativeInterface.PlayNarrativeSequence("ACADEMY_EXIT_PICKUP_1");
    end,
    
    playingItems = {},
};


function LookUp():void
	local narrativeVars = TableRepository.GetOrRegisterTable("AcademyNarrative");

	repeat
		narrativeVars.timerThread = NarrativeInterface.CreateNarrativeThread(TimerStartUpThread);
		narrativeVars.volumeThread = NarrativeInterface.CreateNarrativeThread(VolumeTestUpThread);
		SleepUntil([|IsThreadValid(narrativeVars.timerThread)], 1);
		SleepUntil([|not IsThreadValid(narrativeVars.timerThread)], 1);
		KillThread(narrativeVars.volumeThread);
	until narrativeVars.endLookUp == true;
end



-- time out, phase 1
function TimerStartUpThread():void
	local narrativeVars = TableRepository.GetOrRegisterTable("AcademyNarrative");
	local simpleTimer:number = 0;

	repeat
		SleepSeconds(1);
		simpleTimer = simpleTimer + 1;
	until simpleTimer == narrativeVars.timerDuration;
end


-- invert choice, phase 1
function VolumeTestUpThread():void
	local narrativeVars = TableRepository.GetOrRegisterTable("AcademyNarrative");
	local playerCage: cage_stack = Cage_StackGetOrCreatePlayer(narrativeVars.player);
	repeat
		if Cage_IsStackLookingAtVolume(playerCage, VOLUMES.narrative_intro_lookat_volume, 10, 5) then
			--print("looked up")
			KillThread(narrativeVars.timerThread);
			narrativeVars.endLookUp = true;
		end

		SleepOneFrame();
	until narrativeVars.endLookUp == true;
end

--[========================================================================[
          ACADEMY_PELICAN_EXIT_LOOK_TUTORIAL
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_pelican_exit_look_tutorial = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_pelican_exit_look_tutorial";
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up line 1 of this convo to play on the Drill Sergeant, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetDrillSergeantObject;
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_PELICAN_EXIT_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_pelican_exit_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_pelican_exit_2";
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up line 1 of this convo to play on the Drill Sergeant, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetDrillSergeantObject;
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_PELICAN_EXIT_3
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_pelican_exit_3 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_pelican_exit_3";
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up line 1 of this convo to play on the Drill Sergeant, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetDrillSergeantObject;
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_EXIT_PICKUP_1  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_pelican_exit_pickup_1";
		SleepSeconds(120);
		if(TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreet == true) then
			return;
		end

		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up line 1 of this convo to play on the Drill Sergeant, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetDrillSergeantObject;

        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
		NarrativeInterface.PlayNarrativeSequence("ACADEMY_EXIT_PICKUP_2");

	end,
	playingItems = {},
};

--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_2
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_EXIT_PICKUP_2  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_pelican_exit_pickup_2";
		SleepSeconds(120);
		if(TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreet == true) then
			return;
		end
		
        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
		NarrativeInterface.PlayNarrativeSequence("ACADEMY_EXIT_PICKUP_3");

	end,
	playingItems = {},
};

--[========================================================================[
          Academy_PELICAN_EXIT_PICKUP_3
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_EXIT_PICKUP_3  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_pelican_exit_pickup_3";
		SleepSeconds(120);
		if(TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreet == true) then
			return;
		end
		
        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
		NarrativeInterface.PlayNarrativeSequence("ACADEMY_EXIT_PICKUP_1");

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_LOBBY_INTRO_1
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_LOBBY_INTRO_1  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_lobby_intro_1";
		TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreet = true;
		
        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);

		TableRepository.GetOrRegisterTable("AcademyNarrative").DoorGreetComplete = true;
	end,
	playingItems = {},
};

--[========================================================================[
          Academy_AI_INTRO_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_intro_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_intro_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_AI_Intro_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_intro_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_intro_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_AI_Intro_4
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_intro_4 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_intro_4";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);

		TableRepository.GetOrRegisterTable("AcademyNarrative").AIDescriptionComplete = true;
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_INTRO_4_ALT
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_intro_4_alt = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_intro_4_alt";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          Academy_AI_SELECT_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_select_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_select_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_SHIELDS_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_shields_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_shields_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_SHIELDS_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_shields_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_shields_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_SHIELDS_3
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_shields_3 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_shields_3";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_DOOR_HACK_1
--]========================================================================]
NarrativeInterface.loadedSequences.TUTORIAL_AI_OUTRO  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		local convoId:string = "mpacademynarrative_academy_ai_door_hack_1";
		
        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_DOOR_HACK_2
--]========================================================================]
NarrativeInterface.loadedSequences.TUTORIAL_AI_HACK_REMINDER = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		local convoId:string = "mpacademynarrative_academy_ai_door_hack_2";
		SleepSeconds(30);
		if(TableRepository.GetOrRegisterTable("AcademyNarrative").MovementDoorOpen == true) then
			return;
		end

        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_AI_DOOR_HACK_3
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_ai_door_hack_3 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_ai_door_hack_3";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

NarrativeInterface.loadedSequences.TUTORIAL_AI_MOMENT = {
	sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		local chipComp_kit = Kits_ActivateChildKit(nil, "mp_academy_intro_ai_drop_seque_end_p3");
        local chipComp = composer_play_show("mp_academy_intro_ai_drop_seque_end_p3");

		compdata = compdata or {};
		compdata.callbacks = compdata.callbacks or {};

		compdata.StartScript =
			function(state:table)
				state.startScriptThread = CreateThread(function()
					hud_show_crosshair(false);
					hud_show_radar(false);
					SendBroadcastCuiEvent("hud_transition_off_start");
					MPLuaCall("__OnPlayerHudHide");
					SleepSeconds(2);
					hud_show(false);
				end);  -- Normal thread ok - This will get cleaned up by the EndScript
			end;

		SleepUntil([|composer_show_is_playing(chipComp) == false], 1);
		DeactivateKitHandleAsync(chipComp_kit);
    end,
    
    playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_TRAINING_INTRo_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_training_intro_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_training_intro_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_TRAINING_Intro_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_training_intro_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_training_intro_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_CROUCH_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_crouch_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_crouch_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_Melee_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_melee_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_melee_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_Melee_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_melee_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_melee_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_WAIT
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_wait = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_wait";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_MOVEMENT_COURSE_TIMER_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_movement_course_timer_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_movement_course_timer_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OBSTACLE_OUTRO_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_obstacle_outro_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_obstacle_outro_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_Facility_Access_Denied_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_facility_access_denied_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_facility_access_denied_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_ARMORY_RETURN_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_return_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_return_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_IDLE_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_idle_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_idle_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_DOOR_NOGUN
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_door_nogun = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_door_nogun";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_PICKUP_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_pickup_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_pickup_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_armory_ADMIRE
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_armory_admire = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_armory_admire";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_INTRO_1_ALT1
--]========================================================================]
NarrativeInterface.loadedSequences.TUTORIAL_WEAPON_RANGE_INTRO = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		local cinematic_kit:folder_handle = Kits_ActivateChildKit(nil, "nar_mp_academy_range_intro_01_alt1");
        local convoId:string = "mpacademynarrative_academy_range_intro_1_alt1";
        local show_cinematic:string = "nar_mp_academy_range_intro_01_alt1";
		Device_SetDesiredPosition(OBJECTS.weapon_range_door_machine, 1);
 
		compdata = compdata or {};
		compdata.callbacks = compdata.callbacks or {};

		compdata.SkipScript = function(state:table)
			object_teleport(PLAYERS.player0, FLAGS.range_player);
			player_disable_movement(true, PLAYERS.player0);
		end;

        compdata.EndScript =
			function(state:table)
				state.callbacks.EndConversation(state);
				Device_SetDesiredPosition(OBJECTS.weapon_range_door_machine, 0);
				MPLuaCall("__OnPlayerHudShow");
				player_disable_movement(true, PLAYERS.player0);
				RunClientScript("HudTransitionToFirstPerson");
			end;

        --NarrativeInterface.FillAllNilCharacterFunctionsWith(convoId, CONVO_CHARACTER_FNC.GetPuppet);
        NarrativeInterface.PlayConversationEventBased(convoId, sequenceId, show_cinematic, compdata, true);
    end,
    
    playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_1
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_WEAPON_RANGE_1  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_range_ai_highlight_1";

		-- Splits the two line conversation into two separate conversations
		NarrativeInterface.CreateSplitConversations(convoId, __thisFilenameHash, 2);
		-- Save new convo names
		local convoId_1:string = convoId .. "_sub_part1";
		local convoId_2:string = convoId .. "_sub_part2";

		-- Play first line
		NarrativeInterface.PlayConversation(convoId_1, sequenceId, compdata, true);

		-- Highlights enemy targets on the Weapon Range in the tutorial.
		for _, target in hpairs(Squad_GetActors(AI.ar_target)) do
			RunClientScript("cl_CreateTargetOutline", ai_get_unit(target));
		end

		-- Play second line
		NarrativeInterface.PlayConversation(convoId_2, sequenceId, compdata, true);
		NarrativeInterface.SleepUntil.PlayNarrativeSequence("ACADEMY_WEAPON_RANGE_2");

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_2
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_WEAPON_RANGE_2  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_range_ai_highlight_2";

		-- Need to logic to detect player is using keyboard/mouse
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);

		NarrativeInterface.SleepUntil.PlayNarrativeSequence("ACADEMY_WEAPON_RANGE_3");

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_AI_HIGHLIGHT_3
--]========================================================================]
NarrativeInterface.loadedSequences.ACADEMY_WEAPON_RANGE_3  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_range_ai_highlight_3";


        NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_NEW_WEAPON_1

--]========================================================================]

NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_new_weapon_1 = {
 	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_new_weapon_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_SCOPE_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_scope_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_scope_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_SCOPE_pickup_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_scope_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_scope_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_Shields_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_shields_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_shields_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMy_RANGE_SHIELDS_HEADSHOT_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_shields_headshot_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_shields_headshot_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_PICKUP_1_SINGULAR
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_pickup_1_singular = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_pickup_1_singular";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_PICKUP_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_pickup_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_pickup_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_grenades_pickup = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_grenades_pickup";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_grenades_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_grenades_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_GRENADES_PICKUP_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_grenades_pickup_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_grenades_pickup_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_OUTRO_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_outro_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_outro_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_reminder_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_reminder_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_reminder_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_RANGE_Startover_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_range_startover_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_range_startover_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_Facility_INTRO_1
--]========================================================================]
NarrativeInterface.loadedSequences.INTERLOCK_INTRO  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_training_facility_intro_1";

		Device_SetDesiredPosition(OBJECTS.unsc_wall_ext_concrete_doorway_door_h18_w32_d04_a__dm, 1);
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
		TutorialQuickTipHandler(PLAYERS.player0, "academy_tip_scan_title", "academy_tip_scan", tutorialTipDisplaySeconds);
		NarrativeInterface.SleepUntil.PlayNarrativeSequence("INTERLOCK_INTRO_2");

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_BOTS_INTRO_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_bots_intro_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_bots_intro_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_BOTS_INTRO_3
--]========================================================================]
NarrativeInterface.loadedSequences.INTERLOCK_INTRO_2  = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
        local convoId:string = "mpacademynarrative_academy_bots_intro_3";

		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);

	end,
	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_RADAR
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_radar = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_radar";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_PING
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_ping = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_ping";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_GRENADES_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_grenades_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_grenades_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_GRENADES_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_grenades_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_grenades_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Equipment_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_equipment_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_equipment_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_equipment_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_equipment_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_equipment_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWERUPS_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_powerups_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_powerups_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWERUPS_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_powerups_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_powerups_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWER_Weapons_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_power_weapons_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_power_weapons_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_POWER_WEAPONS_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_power_weapons_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_power_weapons_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_weapon_container_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_weapon_container_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_weapon_container_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_commander_pickup_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_commander_pickup_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_1_ALT
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_commander_pickup_1_alt = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_commander_pickup_1_alt";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_BOTS_WELCOME_1_ALT
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_bots_welcome_1_alt = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_bots_welcome_1_alt";
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up line 1 of this convo to play on the Commander, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetCommanderIdlePuppet;
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_BOTS_WELCOME_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_bots_welcome_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_bots_welcome_2";
		local convo = NarrativeInterface.loadedConversations[convoId];
		if (not convo) then return; end

		-- Set up lines 1 and 2 of this convo to play on the Commander, for 3d sound spatialization, and for any embedded lip animations
		convo.lines[1].character = GetCommanderIdlePuppet;
		convo.lines[2].character = GetCommanderIdlePuppet;
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_TRAINING_FACILITY_Commander_PICKUP_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_training_facility_commander_pickup_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_training_facility_commander_pickup_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_OUTRO
--]========================================================================]
NarrativeInterface.loadedSequences.TUTORIAL_OUTRO = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		local cinematic_kit:folder_handle = Kits_ActivateChildKit(nil, "tutorial_outro");
        local convoId:string = "mpacademynarrative_academy_outro";
        local show_cinematic:string = "nar_mp_academy_outro";

		compdata = compdata or {};
		compdata.callbacks = compdata.callbacks or {};

        compdata.EndScript =
			function(state:table)
				state.callbacks.EndConversation(state);
			end;
 
        --NarrativeInterface.FillAllNilCharacterFunctionsWith(convoId, CONVO_CHARACTER_FNC.GetPuppet);
        NarrativeInterface.PlayConversationEventBased(convoId, sequenceId, show_cinematic, compdata, true);
    end,
    
    playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_1
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_1 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_1";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_2
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_2 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_2";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_3
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_3 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_3";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_4
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_4 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_4";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_5
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_5 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_5";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_6
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_6 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_6";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_7
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_7 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_7";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_8
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_8 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_8";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_9
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_9 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_9";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_10
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_10 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_10";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_11
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_11 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_11";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_12
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_12 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_12";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};

--[========================================================================[
          ACADEMY_SUPPORT_13
--]========================================================================]
NarrativeInterface.loadedSequences.mpacademynarrative_academy_support_13 = {
	sequence = function(sequenceId:string, transientState:table, compdata:table):void
		local convoId = "mpacademynarrative_academy_support_13";
		
		NarrativeInterface.PlayConversation(convoId, sequenceId, compdata, true);
	end,

	playingItems = {},
};


NarrativeInterface.loadedSequences.TUTORIAL_LIVEFIRE_SPARTANS_PREPARE = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		spartans_prep_group_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_spartans_prepare_01");
		spartans_prep_one_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_spartans_prepare_03");
		live_fire_commander_idle_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_spartans_sergeant");
        spartans_prep_group_show = composer_play_show("nar_mp_academy_crowd_spartans_prepare_01");
		spartans_prep_one_show = composer_play_show("nar_mp_academy_crowd_spartans_prepare_03");
		live_fire_commander_idle_show = composer_play_show("nar_mp_academy_crowd_spartans_sergeant");
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief", spartans_prep_group_show, FLAGS.player_teleport_interlock_start);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief_1", spartans_prep_group_show, FLAGS.player_teleport_interlock_start);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief_2", spartans_prep_group_show, FLAGS.player_teleport_interlock_start);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief", spartans_prep_one_show, FLAGS.player_teleport_interlock_start);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "storm_masterchief", live_fire_commander_idle_show, FLAGS.player_teleport_interlock_commander);
    end,
    
    playingItems = {},
};

NarrativeInterface.loadedSequences.TUTORIAL_LANDING_PAD_AMBIENT_MARINES = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		guard_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_marine_guard");
		war_stories_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_war_stories");
        guard_marines_show = composer_play_show("nar_mp_academy_marine_guard");
		war_stories_marines_show = composer_play_show("nar_mp_academy_crowd_war_stories");
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_rig", guard_marines_show, FLAGS.player_teleport_entrance);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_rig_01", guard_marines_show, FLAGS.player_teleport_entrance);
    end,
    
    playingItems = {},
};

NarrativeInterface.loadedSequences.TUTORIAL_INTRO_HALLWAY_AMBIENT_MARINES = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		teaching_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_teaching");
		desk_marine_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_marine_desk");
		tired_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_exhausted_marines");
        teaching_marines_show = composer_play_show("nar_mp_academy_crowd_teaching");
		desk_marine_show = composer_play_show("nar_mp_academy_marine_desk");
		tired_marines_show = composer_play_show("nar_mp_academy_crowd_exhausted_marines");
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_rig", desk_marine_show, FLAGS.player_teleport_desk);
    end,
    
    playingItems = {},
};

NarrativeInterface.loadedSequences.TUTORIAL_AI_ROOM_AMBIENT_MARINES = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		console_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_marine_consoles_standing");
        console_marines_show = composer_play_show("nar_mp_academy_marine_consoles_standing");
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_rig", console_marines_show, FLAGS.player_teleport_ai_room);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_rig_02", console_marines_show, FLAGS.player_teleport_ai_room);
    end,
    
    playingItems = {},
};

NarrativeInterface.loadedSequences.TUTORIAL_MOVEMENT_YARD_AMBIENT_MARINES = {
    sequence = function(sequenceId:string, transientState:table, compdata:table, sleepUntilConvosFinish:boolean):void
		course_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_prep_training");
		news_marines_show_kit = Kits_ActivateChildKit(nil, "nar_mp_academy_crowd_marines_discuss");
        course_marines_show = composer_play_show("nar_mp_academy_crowd_prep_training");
		news_marines_show = composer_play_show("nar_mp_academy_crowd_marines_discuss");
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine", course_marines_show, FLAGS.player_teleport_movement_yard);
		CreateThread(HandlePlayersWhoHurtOtherHumans, "marine_2", course_marines_show, FLAGS.player_teleport_movement_yard);
    end,
    
    playingItems = {},
};

--## CLIENT

function remoteClient.HudTransitionToFirstPerson()
	SendBroadcastCuiEvent("hud_transition_on_start");	-- This animates the HUD in
	hud_show(true);
	hud_show_crosshair(true);
	SendHuiEvent("event_hud_player_spawn_start");	-- This is the HUD scan lines
end