//*=============================================================================================================================
//===================== GLOBAL MIDNIGHT FIREFIGHT SCRIPTS ========================================================
//*=============================================================================================================================

//debug

global boolean debug = false;
global boolean b_v_print = false;
global boolean b_v_inspect = false; 

//*=============================================================================================================================
//======================== GLOBALS ==================================================================
//*=============================================================================================================================

//variable for the spawned squads and phantoms
global ai ai_spawned_squad = none;
global ai ai_phantom_squad = none;

//variable for the defense objective
global ai ai_defend_all = none;

//are enemies blipped variable
global boolean b_enemies_are_blipped = false;
global boolean b_dont_blip_enemies = false;

//variables for cycling through waves and spawning waves in the correct location (these maybe should be local)
global short wave_squads = 0;
global short wave_squad_location = 0;

//gets set to true when the end goal event gets triggered
global boolean goal_finished = false;

//gets set to true when the end wave event gets triggered (end_wave)
global boolean wave_finished = false;

//gets set to true when ALL the waves have ended in a player goal
global boolean b_all_waves_ended = false;

//controls the difficulty of the wave getting called
global wave_difficulty difficulty = Medium;

//controls when the enemies are done spawning in a wave -- for example, a drop ship is coming in
global boolean b_done_spawning_enemies = true;
global boolean b_drop_pod_complete = true;
global boolean b_pause_wave = false;

global boolean precondition = false;

//game is ended
global boolean b_game_ended = false;
global boolean b_game_won = false;
global boolean b_game_lost = false;
global long l_goal_timer = 0;

//defend player goal
global real r_defend_timer = 5.0 * 60 * 30;

//controls the objective counts in the objective destroy player goal
global short s_all_objectives = 0;
global short s_all_objectives_count = 0;

//controls whether the wait for trigger player goal is triggered
global boolean b_end_player_goal = false;

//controls when the automatic HUD markers kick off
global boolean b_wait_for_narrative_hud = false;
global boolean b_no_pod_blips = false;

//boss squad definition
global ai ai_boss_objective = none;

//default mission variable
global boolean mission_is_test_debug = false;

global short s_defend_obj_destroyed = 0;

// Ammo crate objects
//global folder eq_ammo_crates = eq_destroy_crates;
//global folder eq_ammo_crates = none;
//global object_name obj_ammo_crate0 = ammo_crate0;
//global object_name obj_ammo_crate1 = ammo_crate1;
global object_name objective_obj = none;

//variables for controlling defend objectives (might be better local)
global object_name obj_defend_1 = none;
global object_name obj_defend_2 = none;


global object_name dm_droppod_1 = dm_drop_01;
global object_name dm_droppod_2 = dm_drop_02;
global object_name dm_droppod_3 = dm_drop_03;
global object_name dm_droppod_4 = dm_drop_04;
global object_name dm_droppod_5 = dm_drop_05;

global object_name obj_drop_pod_1 = drop_pod_lg_01;
global object_name obj_drop_pod_2 = drop_pod_lg_02;
global object_name obj_drop_pod_3 = drop_pod_lg_03;
global object_name obj_drop_pod_4 = drop_pod_lg_04;
global object_name obj_drop_pod_5 = drop_pod_lg_05;

//controls blipping location
global object_name flag_0 = none;

//left in to control failing a mission -- debug currently
global cutscene_title title_lose = failed;

//take these out a little later
//=================== LOOPING SOUNDS/MUSIC MISC ======================
global looping_sound fx_misc_warning = "sound\environments\multiplayer\chopperbowl\new_machines\ambience\machine_04_powr_core_warning_alert.sound_looping";
global looping_sound fx_misc_warning_2 = "sound\environments\multiplayer\chopperbowl\new_machines\ambience\machine_04_powr_core_warning_alert.sound_looping";
global looping_sound music_start = "sound\environments\solo\m020\music\m20_music";
global looping_sound music_mid_beat = "sound\environments\solo\m020\music\gpost04";
global looping_sound music_up_beat = "sound\environments\solo\m020\music\bridge_02";


//=================== CREATION VARIABLES ======================
global short goal_index = 0;

global short current_folder_index = 0;

global short spawn_folder_index = -1;
static short crateExecutedToIndex = -1;

//=================== GOALS ======================

global boolean b_goal_ended = false;
global boolean b_capture_marker = false;

//the amount in seconds the mission will end and return to the main menu after "game_won_with_finish_timer_override" is called
global real r_game_end_timer = 9;

//*=============================================================================================================================
//====================== END GAME =========================================================
//*=============================================================================================================================

script dormant firefight_lost_game
	//firefight_end_game
	sleep_until (b_game_lost == true, 1);
	print ("game lost");
	game_lost(true);
	mp_round_end();
//b_game_ended
end

script dormant firefight_won_game
	sleep_until (b_game_won == true, 1);
	print ("game won");
	game_won_with_finish_timer_override (r_game_end_timer);
	mp_round_end_with_winning_team(mp_team_red);

end

//this script controls the loss condition based on lives.  We are currently not supporting lives, so this script doesn't get called
script dormant end_condition_lives
	//make sure this doesn't fire before everybody spawns
	static short dead_sec = 0;
	sleep_until (firefight_players_dead() == false);
	repeat
		if firefight_players_dead() == true then
			dead_sec = dead_sec + 1;
		else
			dead_sec = 0;
		end
	until (dead_sec >= 8, 30);
	//cinematic_set_title (title_lose);
//	sound_impulse_start (vo_all_dead, none, 1.0);
	//insert incident for no more lives here
	b_game_lost = true;
	print ("no more lives!");
end

//this controls the time limit per objective -- l_goal_timer gets reset with each objective
script dormant end_condition_time
	//sleep_until (l_goal_timer == firefight_mode_get_current_goal_time_limit() * 60, 1);
	
	//each objective has a time limit of 1 hour, then lose the mission.  This is a failsafe for bugs, AFKers and griefers
	sleep_until (l_goal_timer == 60 * 60, 1);
	//insert incident for out of time here
	print ("out of time!");
	print ("if you are seeing this message at the beginning of a level");
	print ("you probably haven't loaded a correct game_variant");
	print ("...or there is no time limit set in your mission"); 

	b_game_lost = true;
	sleep_forever(objective_timer);
	
end


//*=========================================================================================================
//===============LIVES================================
//*=========================================================================================================

script static boolean firefight_players_dead
	list_count_not_dead(players()) <= 0;
end

//respawns dead players after 10 seconds
script continuous respawn_dead_players_timer
	static short dead_sec = 0;
	sleep_until (firefight_players_dead() == false, 1);
	//print ("starting dead players timer");
	v_print ("starting dead players timer");
	firefight_mode_lives_set (game_coop_player_count() + 1);
	repeat
		repeat
			if list_count_not_dead(players()) < game_coop_player_count() then
				firefight_mode_lives_set (game_coop_player_count() + 1);
				dead_sec = dead_sec +1;
			else
				firefight_mode_lives_set (game_coop_player_count() + 1);
				dead_sec = 0;
			end
		until (dead_sec >= 10, 30);
		firefight_mode_respawn_dead_players();
		v_print ("respawning dead players");
	until (b_game_won == true or b_game_lost == true, 1);
end

//adds lives to the number of total lives -- we are no longer supporting lives, not commenting out, just in case thouse
script static void f_add_lives
	firefight_mode_respawn_dead_players();
	//firefight_mode_lives_set (firefight_mode_lives_get() + game_coop_player_count());
	v_print ("lives added");
end

//extra double makes b_goal_ended false at then end of each goal (a failsafe for hacky or sloppy mission scripts)
script continuous check_goal_finished()
	v_print ("starting goal finished thread");
	//gmu 03/02/2012 -- commenting this out and the wake, to speed up the time it takes to end the goal
	//sleep_forever();
		sleep_until (b_goal_ended == true, 1);
		b_goal_ended = false;
	//sleep (30 * 1);
	NotifyLevel("end_goal");
	

end

//*=============================================================================================================================
//================== CREATE OBJECTIVE OBJECTS (CRATES, SCENERY, MACHINES) ====================================================================
//*=============================================================================================================================


//============= CREATE FOLDERS ===========================
//
// Add a new crate.
//
script static short f_add_crate_folder(folder crate_folder)

	v_print ("Registering crate folder.");

	if b_v_inspect == true then
		inspect(crate_folder);
	end
	

	//
	// Index 0 is reserved, pre-increment count.
	//
	current_folder_index = (current_folder_index + 1);

	if (firefight_mode_is_crate_folder_valid(current_folder_index)) then

		breakpoint("Folder index is already registered!");

	end

	//
	// Store the folder in the initial set of indicies.
	//
	firefight_mode_set_crate_folder_at(crate_folder, current_folder_index);	

	//
	// Ensure that the first block is initialized.
	//
	wake(f_ensure_initial_crate_block);

	current_folder_index;

end

//
// Begin a new crate block.
//
script static short f_add_new_crate_block()

	//
	// Skip a folder entry leaving an empty gap.
	//
	current_folder_index = (current_folder_index + 1);

	current_folder_index;

end

//
// Begin a new create block at a specified index.
//
script static short f_add_new_crate_block_at_index(short index)

	//
	// Set the folder index to the specified index.
	//
	current_folder_index = index;

	current_folder_index;

end

//
// Create all the crates in a block.
//
script static short f_create_crate_block(short index)

	local short folderIndex = index;

	if firefight_mode_is_crate_folder_valid(folderIndex) then

		repeat
			v_print("Creating folder index:");
			
			if b_v_inspect == true then
				inspect(folderIndex);
			end
			

			//
			// Create the folder.
			//
			object_create_folder_anew(firefight_mode_get_crate_folder_at(folderIndex));
			
			//
			// Get the next folder.
			//
			folderIndex = folderIndex + 1;

		until (firefight_mode_is_crate_folder_valid(folderIndex) == false, 0);

	end

	folderIndex;

end

//
// Ensures all crates in the inital block have been created.
//
script continuous f_ensure_initial_crate_block()

	repeat

		v_print ("Waking to create initial crate block.");

		if current_folder_index != 0 then

			if (crateExecutedToIndex == -1) then
				
				crateExecutedToIndex = 1;

			end

			local short newIndex = f_create_crate_block(crateExecutedToIndex);

			if (newIndex != crateExecutedToIndex) then

				v_print("Created crates up to index:");
				
				if b_v_inspect == true then
					inspect(newIndex);
				end
				
				//inspect(newIndex);

			end

			crateExecutedToIndex = newIndex;

		end

		sleep_forever();

	until (false, 1);

end

//
// Wait until the initial block of crates are all created.
//
script static void f_wait_for_initial_crates()

	sleep_until(crateExecutedToIndex == -1 or firefight_mode_is_crate_folder_valid(crateExecutedToIndex) == false);

end


//================ CREATE OBJECTIVE OBJECTS ===========================
//create the props based on the first objective -- change this to look through all the goals based on string ID and create them??
script static void f_firefight_create_all_objectives
	print ("creating all the objectives and crates");
	
	goal_index = 0;
	
	//
	// Ensure all the intial crates have been setup.
	//
	wake(f_ensure_initial_crate_block);

	//loop through each of the player goals
	repeat
		if b_v_inspect == true then
			inspect(goal_index);
		end
		
		//inspect (goal_index);
		f_firefight_create_objectives();
		goal_index = (goal_index + 1);

	until (goal_index == firefight_mode_get_goal_count(), 1);
	print ("done creating all the objectives and crates");
end

script static void f_firefight_create_objectives()
	v_print ("creating objectives");
	local short obj_index = 0;
	local short create_objective = 0;
	
	//loop through each of the objectives in the goal and create them
	repeat
		v_print ("repeating creating objectives");
		create_objective = firefight_mode_get_objective(goal_index, obj_index);
		if create_objective != 0 then
			v_print ("creating objective");
			object_create_anew(firefight_mode_get_objective_name_at(create_objective));
			
			//inspect (create_objective);
			
			if b_v_inspect == true then
				inspect(obj_index);
			end
			
			//inspect (obj_index);
			//checking the health of the object for debugging
			if object_valid (firefight_mode_get_objective_name_at(create_objective)) then
				v_print ("object valid");
			else
				v_print (".....OBJECT NOT VALID.....");
			end
			
		end
	obj_index = (obj_index + 1);
	until (create_objective == 0, 1);
	//until (create_objective == 0, 1, 100);
	v_print ("done creating objectives");
end

//=================== CREATE SPAWN OBJECTS ===========================
script static void f_create_current_spawn_folders()
	print ("creating spawn points");
	//if it's the first goal create a spawn folder no matter what
	if firefight_mode_goal_get() == 0 then
		//if no current start locaiton is set, look for the spawn_init_index
		if firefight_mode_get_current_start_location_folder() == 0 then
			
			if s_spops_mission_spawn_init_index == 0 then
				print ("WARNING, please fix -- no spawn folder set anywhere -- please fix or else players won't spawn");
			else
				spawn_folder_index = s_spops_mission_spawn_init_index;
				print ("WARNING, please fix -- current start location set to 0 for this goal, defaulting to s_spops_mission_spawn_init_index");
			end
			
		else
			spawn_folder_index = firefight_mode_get_current_start_location_folder();
		end
		object_create_folder_anew(firefight_mode_get_crate_folder_at(spawn_folder_index));
		v_print ("creating spawn folder because goal is 0");
		
		if b_v_inspect == true then
			inspect(spawn_folder_index);
		end
		
		//inspect (spawn_folder_index);
	
	//if it's not the first goal and the new spawn folder is different from the old spawn folder then create the new folder and destroy the old one
	elseif spawn_folder_index != firefight_mode_get_current_start_location_folder() then
		if firefight_mode_get_current_start_location_folder() == 0 then
			spawn_folder_index = s_spops_mission_spawn_init_index;
			print ("WARNING, please fix -- current start location set to 0 for this goal, defaulting to s_spops_mission_spawn_init_index");
		end
			
		object_create_folder_anew(firefight_mode_get_crate_folder_at(firefight_mode_get_current_start_location_folder()));
		v_print ("creating new spawn folder because goal start location is different from the index");
		sleep(1);
		v_print ("destroying old spawn folder index folder");
		object_destroy_folder(firefight_mode_get_crate_folder_at(spawn_folder_index));
		spawn_folder_index = firefight_mode_get_current_start_location_folder();
			
		if b_v_inspect == true then
			inspect(spawn_folder_index);
		end
			
		//inspect (spawn_folder_index);
	
	//if it's not the first goal and the new spawn folder is the same as the old spawn folder then don't do anything
	elseif spawn_folder_index == firefight_mode_get_current_start_location_folder() then
		v_print ("not spawning a new folder or destroying the old one because the start location folders are the same");
	end

	
end

global boolean b_spawn_folder_locked = false;

// HEY DESIGNERS USE THIS FUNCTION TO ADD NEW SPAWN POINTS MID GOAL
script static void f_create_new_spawn_folder (short spawn_folder)
	//spawn_folder_index = spawn_folder;
	print ("creating new spawn folder because designer said so");
	if spawn_folder != spawn_folder_index then
		sleep_until (b_spawn_folder_locked == false, 1);
		b_spawn_folder_locked = true;
		object_create_folder_anew(firefight_mode_get_crate_folder_at(spawn_folder));
		print ("creating new spawn folder");
		inspect (spawn_folder);
		sleep(1);
		object_destroy_folder(firefight_mode_get_crate_folder_at(spawn_folder_index));
		print ("destroying old spawn folder index folder");
		inspect (spawn_folder_index);
		spawn_folder_index = spawn_folder;
		print ("new spawn folder index is...");
		inspect (spawn_folder_index);
		b_spawn_folder_locked = false;
	else
		print ("WARNING - new spawn folder is the same as previous folder, no change in spawn points");
	end
end


//===================== TIMER ====================================================================
//this controls ending the game if the goal timer is up
//this sets a timer to tick every second
script continuous objective_timer()
	sleep_forever();
//	sleep (30 * 5);
	v_print ("start timer");
//	game_engine_timer_set (firefight_mode_get_current_goal_time_limit() * 60);
//	game_engine_timer_show ("TIMER", true);
//	game_engine_timer_start();
	l_goal_timer = 0;
//	
	repeat
		l_goal_timer = l_goal_timer + 1;
	until (b_goal_ended == true, 30);
//	
end


//===================== HUD ====================================================================
//globally turn on/off HUD elements

script static void f_turn_off_ordnance_hud
//	hud_show_fanfares (false);
	hud_show_toast_commendations (true);
	hud_show_medal_posting_ui (false);
//	player_ordnance_enabled_override = 0;


end


//*=============================================================================================================================
//============ GOALS AND WAVES =========================================================
//*=============================================================================================================================


//========GOALS=================================

script static void firefight_player_goals()
	print ("::starting firefight player goals");
//	wake (end_condition_lives); no longer using lives
	wake (end_condition_time);
	firefight_mode_infinite_lives_set(true);
	firefight_mode_start_goals(difficulty);
	
	//sets the squad group that is tracked for placing HUD markers, tracking wave AI numbers
	firefight_set_squad_group(ai_ff_all);
	
	//turn on enemy markers showing up always in the radar "gutter"
	navpoint_scripting_force_enemy_always_on (true);
	
	//sleep (10);
	//creating the crates for the mission
	
	//
	// Wait for all crates to spawn (blocking).
	//
	f_wait_for_initial_crates();

	//creates all the player goal objective objects
	f_firefight_create_all_objectives();
	
	//turn off PVP ordnace HUD
	thread(f_turn_off_ordnance_hud());
	
	//thread (f_firefight_ammo_crate_create());
	static short current = 0;
	
	//this is the goal looping script -- loop through the goals until all the goals are complete
	if ( firefight_mode_get_goal_count() > 0) then
		repeat
			print ("Starting Goal");
			//creating spawn folders and deleting old spawn folders
			// Don't do this in a thread, because if it happens out of order you are well and truly fucked.
			f_create_current_spawn_folders();
			//adding lives and respawning dead players
			thread (f_add_lives());
			//commenting this out 03.02.2012 to speed up the goal ending time
			//wake the script that checks whether goals are finished
			//wake (check_goal_finished);
			goal_finished = false;
			//start the script that setups the player goal through the map script
			f_firefight_setup_goal();
			//start the wave logic if applicable for the goal
			f_firefight_run_goal(current );
			sleep_until( goal_finished, 1 );		
			current = firefight_mode_increment_player_goal(difficulty);
			print ("Goal Ended");
		until (current == firefight_mode_get_goal_count(), 1);
	end
end



//starts the script of the goal based on the goal type set up in the tag in Bonobo
//the individual goal scripts are called in the mission or map scripts -- this was done just in case we wanted to add parameters per mission
script static void f_firefight_setup_goal()
	if firefight_mode_current_player_goal_type() == object_destruction then
		//setup_destroy();
		wake (objective_destroy);
	elseif firefight_mode_current_player_goal_type() == time_passed then
		//setup_wait_for_trigger();
		wake (objective_wait_for_trigger);
	elseif firefight_mode_current_player_goal_type() == no_more_waves then
		//setup_swarm();
		wake (objective_swarm);
	elseif firefight_mode_current_player_goal_type() == location_arrival then
		//setup_atob();
		wake (objective_atob);
	elseif firefight_mode_current_player_goal_type() == defense then
		//setup_defend();
		wake (objective_defend);
	//not really used
	elseif firefight_mode_current_player_goal_type() == object_delivery then
		//setup_take();
		wake (objective_take);
	//not really used
	elseif firefight_mode_current_player_goal_type() == other then
		//setup_capture();
		wake (objective_capture);
	//not really used
	elseif firefight_mode_current_player_goal_type() == kill_boss then
		//setup_boss();
		wake (objective_kill_boss);

	end
	
end

// THIS IS THE MAIN GOAL RUNNING SCRIPT
script static void f_firefight_run_goal( short goal_index)
	static short current = 0;
	
	//have to set current to "0" because creating the variable doesn't reset it to 0
	current = 0;
	b_all_waves_ended = false;
	v_print ("::starting firefight_run_goal::");
	
	//start the wave spawning logic if there are waves in the goal
	if ( firefight_mode_waves_in_player_goal() > 0) then
		repeat
			v_print ("running wave");

			wave_finished = false;
			//respawn dead players -- when it works put in a check to see if the flag is called in the variant -- though I don't see why we would ever NOT want this
//			if firefight_mode_team_respawns_on_wave() == true then
//				firefight_mode_respawn_dead_players();
//				print ("all dead players respawned");
//			end
			//respawn dead players no matter what between waves
			firefight_mode_respawn_dead_players();
			
			//sleep until all the drop pods and phantoms are destroyed OR the player goal has been completed
			v_print ("---is precondition or goal finished true?---");
			f_precondition();
			
			//respawn dead players no matter what between waves
			firefight_mode_respawn_dead_players();
			
//			sleep_until (precondition or goal_finished, 1);
			//if the goal is NOT finished start a wave
			if (goal_finished == false) then
				v_print ("---threading f_firefight_run_wave---");
				thread (f_firefight_run_wave(goal_index, current));
				//commenting out this sleep to see if anything bad happens
				//sleep (30);
			end
			
			//sleep until the number of AI specified in the wave is killed OR the player goal has been completed
			sleep_until ( wave_finished or goal_finished, 1);	
			v_print ("in goal thread wave is finished or goal is finished");	
//			print ( "what is current??");
//			inspect (current);
//			inspect (goal_finished);
//			print ("what is waves in player goal - 1");
//			inspect (short(firefight_mode_waves_in_player_goal()- 1));
			//if there are more waves in the goal increment the wave ONLY if the goal isn't finished.  If the goal is finished or there are no more waves then end
			if (current != (short(firefight_mode_waves_in_player_goal() - 1)) and (goal_finished == false)) then
				current = firefight_mode_increment_wave();
				v_print ("increment wave");
			else
				v_print ("no more waves");
				current = firefight_mode_waves_in_player_goal();
			end
			print ("wave ended");
		until(current == firefight_mode_waves_in_player_goal() or goal_finished, 1);	
		print ("all waves ended in goal");
		b_all_waves_ended = true;
		
	end
end

//THIS PAUSES THE GOAL SCRIPT UNTIL CERTAIN PRECONDITIONS ARE MEANT -- CURRENTLY THE ONLY PRECONDITION IS THAT THE WAVE ISN"T PAUSED AND THE GOAL ISN'T FINISHED
script static void f_precondition

	//pause here until there are no more phantoms and drop pods OR the goal is finished
	v_print ("---waiting on precondition---");
	sleep_until (precondition == true or b_pause_wave == false or goal_finished == true, 1);
	
//	precondition = true;
	v_print ("---precondition is true---");
end


//WAIT UNTIL THE CODE CALLS THE EVENT "end_goal" THEN ENDS THE GOAL
script continuous end_goal()
	sleep_until(LevelEventStatus("end_goal"), 1);
	v_print ("goal ending");
	goal_finished = true;
	//sleep_forever(f_firefight_run_goal);

end

//===============WAVES===============================================


//this waits for the engine to call "end_wave" then unblips the enemies and says "wave_finished"
script continuous end_wave()
	//the "end wave" event comes from the engine
	sleep_until(LevelEventStatus("end_wave"), 1);
	v_print ( "Wave Ending");
	if (firefight_get_squad_group() != none) and b_enemies_are_blipped == true and b_dont_blip_enemies == false then 
		thread (f_unblip_ai_cui(firefight_get_squad_group()));
	end
	firefight_set_squad_group(none);
	wave_finished = true;
end



//squad placement scripts (dropships, monster closets, etc.
script static void f_firefight_run_wave (short goal_index, short wave_index)
	b_done_spawning_enemies = false;
	precondition = false;
	//set the correct wave type and squad types
	local short s_current_wave_type		= firefight_mode_get_wave_type();
	local short s_current_squad1			= firefight_mode_get_squad_to_place (goal_index, wave_index, 0);
	local short s_current_squad2			= firefight_mode_get_squad_to_place (goal_index, wave_index, 1);
	local long  l_current_squad_type	= firefight_mode_get_wave_squad();
	precondition = true;
	print ("---spawning enemies in a wave---");
	
	
	if ( firefight_mode_current_wave_spawn_method() == Dropship) then
		v_print ("spawning with dropship");
		f_dlc_dropship_loader(s_current_wave_type, s_current_squad1, s_current_squad2, l_current_squad_type);
		
	elseif ( firefight_mode_current_wave_spawn_method() == Monster_Closet) then 
		v_print ("spawning with monster closet");
		//spawn in spawn points or squad formations
		
		f_dlc_monster_squad(s_current_wave_type, s_current_squad1, s_current_squad2, l_current_squad_type);
		
	elseif ( firefight_mode_current_wave_spawn_method()  == Drop_Pod) then
		v_print ("spawning with drop pod");
		f_dlc_droppod_loader(s_current_wave_type, s_current_squad1, s_current_squad2, l_current_squad_type);

	elseif ( firefight_mode_current_wave_spawn_method() == Test_Spawn) then
		v_print ("spawning with test spawn -- PAUSING");
		f_pause_wave();
		
	end


	v_print ("---done spawning enemies---");
	firefight_set_squad_group( ai_ff_all);
	b_done_spawning_enemies = true;

end


//THIS IS WHERE THE SQUADS GET SPAWNED
script static void f_dlc_spawn_squads (short squad1, short squad2, long squad_type)
	print ("start spawn_squads");
	
	if squad1 > 0 then
		if squad_type >= 0 then
			ai_place_wave_in_limbo (squad_type, firefight_mode_get_squad_at(squad1), 1);
			v_print ("spawning squad 1 with WAVE spawn");
		else
			//might need to change this to == -1 incase the index references numbers lower than -1
			//if there is a NOT valid squad written in the "squad type" in the tag then spawn squad with the spawn points
			ai_place_in_limbo (firefight_mode_get_squad_at(squad1));
			v_print ("spawning squad 1 with spawn points");
		end
	else
			print ("no squad to spawn in squad location 1");
	end
	
	if squad2 > 0 then
		if squad_type >= 0 then
			ai_place_wave_in_limbo (squad_type, firefight_mode_get_squad_at(squad2), 1);
			print ("spawning squad 2 with WAVE spawn");
		else
			//might need to change this to == -1 incase the index references numbers lower than -1
			//if there is a NOT valid squad written in the "squad type" in the tag then spawn squad with the spawn points
			ai_place_in_limbo (firefight_mode_get_squad_at(squad2));
			v_print ("spawning squad 2 with spawn points");
		end
	else
			v_print ("no squad to spawn in squad location 2");
	end
	v_print ("done spawning squads");
end



//*=============================================================================================================================
//===========MONSTER CLOSET========
//*=============================================================================================================================

script static void f_dlc_monster_squad (short wave_type, short squad1, short squad2, long squad_type)
	print ("start monster squad spawn");
	
	//check to see if the squads are valid, then look for the squad type to see if it should spawn from the wave formations
	//then look at the wave type to determine what ai_place funtion should be used (default, limbo, birth or shard)
	
	//gmu -- I'm keeping these functions separate because of the print statements
//*****SQUAD1
	//if there is a valid squad in the squad 1 field then start spawning, else print no squad to spawn
	if squad1 > 0 then
	
		//if there is a valid wave in the squad type field then spawn the squad from the wave type into the squad_formation
		if squad_type >= 0 then
			
			//look at the wave type field at spawn appropriately
			if wave_type == 0 then
				ai_place_wave (squad_type, firefight_mode_get_squad_at(squad1), 1);
				print ("spawning squad 1 with WAVE spawn");
			elseif wave_type == 1 then
				ai_place_wave_in_limbo (squad_type, firefight_mode_get_squad_at(squad1), 1);
				print ("spawning squad 1 with WAVE spawn in limbo");
			else
				ai_place_wave (squad_type, firefight_mode_get_squad_at(squad1), 1);
				print ("spawning squad 1 with WAVE spawn because other wave types aren't supported");
			end
		
		//if there is a NOT valid squad written in the "squad type" in the tag then spawn squad with the spawn points
		elseif squad_type == -1 then
			
			//look at the wave type field at spawn appropriately
			if wave_type == 0 then
				ai_place (firefight_mode_get_squad_at(squad1));
				print ("spawning squad 1 with spawn points");
			elseif wave_type == 1 then
				ai_place_in_limbo (firefight_mode_get_squad_at(squad1));
				print ("spawning squad 1 with spawn points in limbo");
			elseif wave_type == 2 then
				ai_place_with_birth (firefight_mode_get_squad_at(squad1));
				print ("spawning squad 1 with spawn points with birth");
			elseif wave_type == 3 then
				ai_place_with_shards (firefight_mode_get_squad_at(squad1));
				print ("spawning squad 1 with spawn points with shards");	
			else 
				ai_place (firefight_mode_get_squad_at(squad1));
				print ("spawning squad 1 with spawn points because there is no valid wave type");	
			end
		
		else
			print ("no valid squad type index -- I didn't think this was possible");
		//this ends the squads 1 spawn type if statement
		end
		
	else
		print ("no squad to spawn in squad location 1");
	//this ends the squads 1 if statement
	end

//*****SQUAD2
	//if there is a valid squad in the squad 1 field then start spawning, else print no squad to spawn
	if squad2 > 0 then
	
		//if there is a valid wave in the squad type field then spawn the squad from the wave type into the squad_formation
		if squad_type >= 0 then
			
			//look at the wave type field at spawn appropriately
			if wave_type == 0 then
				ai_place_wave (squad_type, firefight_mode_get_squad_at(squad2), 1);
				print ("spawning squad 2 with WAVE spawn");
			elseif wave_type == 1 then
				ai_place_wave_in_limbo (squad_type, firefight_mode_get_squad_at(squad2), 1);
				print ("spawning squad 2 with WAVE spawn in limbo");
			else
				ai_place_wave (squad_type, firefight_mode_get_squad_at(squad2), 1);
				print ("spawning squad 2 with WAVE spawn because other wave types aren't supported");
			end
		
		//if there is a NOT valid squad written in the "squad type" in the tag then spawn squad with the spawn points
		elseif squad_type == -1 then
			
			//look at the wave type field at spawn appropriately
			if wave_type == 0 then
				ai_place (firefight_mode_get_squad_at(squad2));
				print ("spawning squad 2 with spawn points");
			elseif wave_type == 1 then
				ai_place_in_limbo (firefight_mode_get_squad_at(squad2));
				print ("spawning squad 2 with spawn points in limbo");
			elseif wave_type == 2 then
				ai_place_with_birth (firefight_mode_get_squad_at(squad2));
				print ("spawning squad 2 with spawn points with birth");
			elseif wave_type == 3 then
				ai_place_with_shards (firefight_mode_get_squad_at(squad2));
				print ("spawning squad 2 with spawn points with shards");	
			else 
				ai_place (firefight_mode_get_squad_at(squad2));
				print ("spawning squad 2 with spawn points because there is no valid wave type");	
			end
		
		else
			print ("no valid squad type index -- I didn't think this was possible");
		//this ends the squads 2 spawn type if statement
		end
		
	else
		v_print ("no squad to spawn in squad location 2");
	
	end
	//this ends the squads 2 if statement

end

//*=============================================================================================================================
//===========DROPSHIPS==============
//*=============================================================================================================================

script static void f_dlc_dropship_loader(short wave_type, short squad_1, short squad_2, long squad_type)
	print ("start dropship loader");
	
	//place the phantom
	ai_place (firefight_mode_get_squad_at (wave_type));
	
	//spawn the squads to go in the phantom
	f_dlc_spawn_squads(squad_1, squad_2, squad_type);
	
	//load the phantom
	if squad_1 > 0 then
		ai_exit_limbo (firefight_mode_get_squad_at (squad_1));
		f_load_dropship (ai_vehicle_get_from_squad (firefight_mode_get_squad_at(wave_type), 0), firefight_mode_get_squad_at (squad_1));
	end
	
	if squad_2 > 0 then
		ai_exit_limbo (firefight_mode_get_squad_at (squad_2));
		f_load_dropship (ai_vehicle_get_from_squad (firefight_mode_get_squad_at(wave_type), 0), firefight_mode_get_squad_at (squad_2));
	end
end


script static void f_load_dropship (vehicle dropship, ai squad)
//load phantoms in both sets of seats
	v_print ("load phantom dual...");
	if (vehicle_test_seat (dropship, "phantom_p_lf") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_lf");
		v_print ("ai placed in seat1");
	else
		v_print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_rf") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_rf");
		v_print ("ai placed in seat2");
	else
		v_print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_lb") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_lb");
		v_print ("ai placed in seat3");
	else
		v_print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_rb") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_rb");
		v_print ("ai placed in seat4");
	else
		v_print ("seat taken");
	end
	v_print ("loaded side dual");

end



//*=============================================================================================================================
//================DROP PODS============
//*=============================================================================================================================

script static void f_dlc_droppod_loader(short wave_type, short squad_1, short squad_2, long squad_type)
	print ("start droppod loader");
	
	//spawn the squads to go in the drop pod
	f_dlc_spawn_squads(squad_1, squad_2, squad_type);

	if wave_type == 1 then
		thread (f_dlc_load_drop_pod (dm_droppod_1, firefight_mode_get_squad_at(squad_1), firefight_mode_get_squad_at(squad_2), obj_drop_pod_1));
		v_print ("drop pod falling onto spot 1");
	elseif wave_type == 2 then
		thread (f_dlc_load_drop_pod (dm_droppod_2, firefight_mode_get_squad_at(squad_1), firefight_mode_get_squad_at(squad_2), obj_drop_pod_2));
		v_print ("drop pod falling onto spot 2");
	elseif wave_type == 3 then
		thread (f_dlc_load_drop_pod (dm_droppod_3, firefight_mode_get_squad_at(squad_1), firefight_mode_get_squad_at(squad_2), obj_drop_pod_3));
		v_print ("drop pod falling onto spot 3");
	elseif wave_type == 4 then
		thread (f_dlc_load_drop_pod (dm_droppod_4, firefight_mode_get_squad_at(squad_1), firefight_mode_get_squad_at(squad_2), obj_drop_pod_4));
		v_print ("drop pod falling onto spot 4");
	elseif wave_type == 5 then
		thread (f_dlc_load_drop_pod (dm_droppod_5, firefight_mode_get_squad_at(squad_1), firefight_mode_get_squad_at(squad_2), obj_drop_pod_5));
		v_print ("drop pod falling onto spot 5");
	else
		print ("no wave type specified, no drop pod coming down");
		ai_exit_limbo (firefight_mode_get_squad_at(squad_1));
		ai_exit_limbo (firefight_mode_get_squad_at(squad_2));
	end
end




//loads the drop pod -- set AI to none if you don't want to spawn them
//put in the name of the device machine, up to two squads, and the name of the drop pod
//this script will create the device and the pod and load the squads in, you should spawn the squads yourself.
script static void f_dlc_load_drop_pod (object_name dm_drop, ai squad, ai squad2, object_name pod)
	
	//wait until the pod is not around (in case this pod was just used)
	sleep_until (object_valid (pod) == false, 1);

	//f_spawn_squads();
	//v_print ("drop pod squads spawned");

	v_print ("drop pod ready to be created");
	object_create_anew (pod);
	object_hide (pod, true);
	
	// make sure the thrusters are off (I think this is unnecessary, but never hurts to be sure)
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.0);
	v_print ("drop pod created");
	
	//check to see if the AI squad has valid, living actors	
	//if firefight_mode_get_current_squad_to_place(0) == 0 then
	if ai_living_count (squad) == 0 then	
		v_print ("there are no living actors in the squad put in to the drop pod");
		v_print ("the script is not calling ai_exit_limbo on the squad");
	else
	
	//place the squad into the drop pod, checking to see if they really get put in	
	//if firefight_mode_get_current_squad_to_place(0) > 0 then
		ai_exit_limbo (squad);

		//check if the seats are taken in the pod
		if vehicle_test_seat (vehicle(pod), "") == false then
			v_print ("no seats taken before placing squads in drop pod");
		end

		//put the AI in the pod
		ai_vehicle_enter_immediate (squad, vehicle(pod));
		
		//if the seats are not taken because the AI did not get in the pod, print the error
		if vehicle_test_seat (vehicle(pod), "") == false then
			print ("no seats taken, the squad didn't get put into the drop pod :(");
		else
			v_print ("squad1 teleported into drop pod");
		end
	end
	
	//put second squad into drop pods if they exist
	if ai_living_count (squad2) > 0 then
		ai_exit_limbo (squad2);
		ai_vehicle_enter_immediate (squad2, vehicle(pod));
		v_print ("squad 2 teleported into drop pod");
	end
	
	sleep (1);

	//create the drop rail
	object_create_anew (dm_drop);
	v_print ("drop rail created");
	
	
	//attach the drop pod to the device machine
	objects_attach (dm_drop, "drop_pod", vehicle(pod), "");
	
	//scale the pod small, unhide it and scale it up over time
	object_set_scale (pod, 0.1, 1);
	sleep (2);
	object_hide (pod, false);
	object_set_scale (pod, 1.0, 60);
	sleep (10);
	
	local device device_drop = device(dm_drop);
	
	//animating the device machine dm_drop
	device_set_position_track(device_drop, 'pod_large_enter', 1 );
	//device_set_position_track(device_drop, 'pod_large_idle', 1 );
	device_animate_position (device_drop, 1, 3.3, 0, 2, 0);
	
	//wait until the players have spawned to show HUD items
	if ((b_wait_for_narrative_hud == false) or (b_no_pod_blips == false)) then
		v_print ("narrative hud is false, calling blip drop pod");
		thread (f_blip_drop_pods(pod, dm_drop));
	end
                
	// wait till the device_machine/pod is close to the bottom
	sleep_until (device_get_position (device(dm_drop)) >= 0.75, 1);
	
	// turn on the thrusters at half power to hover
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.5);

	sleep_until (device_get_position (device(dm_drop)) == 1, 1);

	//animate the pod to hover at the bottom of it's track

	device_set_overlay_track(device_drop, 'pod_large_idle');
	device_animate_overlay (device_drop, 1.0, 3.3, 0, 0);

	//open the pod and kick out the AI
	unit_open (vehicle(pod));
	v_print ("kicking ai out of pod...");
	vehicle_unload (pod, "");

	//sleep until the idle animation is done (sorry for the hard code)
	
	sleep (30 * 3.3);
	
	//play exit animation
	device_set_position_track(device_drop, 'pod_large_exit', 0 );
	device_animate_position (device_drop, 1, 3.3, 2, 0, 0);
	
	sleep (1);
	
	// turn on the thrusters at full power
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 1.0);
	
	//send the pod back up (by reversing the position of the device_machine)
	device_set_position (device(dm_drop), 0);
	
	//when the pod is back up in the air, scale it down, detach the objects and destroy them
	sleep_until (device_get_position (device(dm_drop)) == 0, 1, (30 * 3.3));
	object_set_scale (pod, 0.01, 30);
	sleep (60);
	objects_detach (dm_drop, vehicle(pod));
	object_destroy (dm_drop);
	object_destroy (pod);
	v_print ("done with drop pod");

	//b_drop_pod_complete = true;
end

script static void f_blip_drop_pods (object_name pod_2, object_name dm_drop_2)
	if
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0 then
		v_print ("player is alive blipping drop pod");
		sound_impulse_start (sfx_blip, NONE, 1);
		
		//f_blip_object_cui (dropship, "navpoint_enemy_vehicle");
		navpoint_track_object_named (pod_2, "navpoint_enemy_vehicle");
		sleep_until (object_valid (dm_drop_2) == false, 1);
		//f_unblip_object_cui (dropship);
	else
		v_print ("player is not alive NOT blipping drop pod");
	end

end


//==================WAVE PAUSE=======================================

script static void f_pause_wave
	//pauses for the the amount of seconds set in the "wave type" field in the mission variant tag
	b_pause_wave = true;
	print ("pausing for some seconds");
	inspect (short(firefight_mode_get_wave_type()));
	sleep_until (goal_finished, 1, firefight_mode_get_wave_type() * 30);
	print ("done pausing");
	b_pause_wave = false;
end


//================blips


script continuous check_need_blips()
	//automatic blipping of the waves
	sleep_until(LevelEventStatus("blip_remaining_enemies"),1);
	
	sleep (30);
	sleep_until(b_done_spawning_enemies == true, 1);
	v_print ("attempting to blip enemies");
	sleep_until (b_wait_for_narrative_hud == false or wave_finished, 1);
	if wave_finished then
		v_print ("wave is finished, resetting check_need_blips");
	else
		v_print ("blipping enemies");
		f_blip_ai_cui(firefight_get_squad_group(), "navpoint_enemy");
		//f_blip_ai_cui(gr_ff_remaining, "navpoint_enemy");
		b_enemies_are_blipped = true;
	end
end


//* ================================================================================================================
//================== OBJECT DESTRUCTION -- DESTROY OBJECTIVE SCRIPTS ====================================
//* ================================================================================================================

script continuous objective_destroy
	//sleep until woken	
	sleep_forever();
	b_goal_ended = false;
	print ("------objective destroy started------");

	//this is where the main script starts
// commenting out the sleep to remove dead spots, we'll see if this breaks anything
//	sleep (30 * 3);
	s_all_objectives = 0;
	s_all_objectives_count = 0;
	wake (objective_timer);
	
	//set the objective to whatever is in the objective field in the player goal
	//objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	//sleep (30 * 6);
	
		//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	//if there is an objective set in the objective 0 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(0) > 0 then
		print ("objective 0 is active");
		s_all_objectives = s_all_objectives + 1;
		//set the objective to whatever is in the objective field in the player goal and watch for it to be destroyed
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0))));
	else
		print ("NOTHING is set in objective 0");
	end
	
	//if there is an objective set in the objective 1 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(1) > 0 then
		print ("objective 1 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(1))));
	else
		print ("NOTHING is set in objective 1");
	end
	
	//if there is an objective set in the objective 2 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(2) > 0 then
		print ("objective 2 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(2))));
	else
		print ("NOTHING is set in objective 2");
	end
	
		//if there is an objective set in the objective 3 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(3) > 0 then
		print ("objective 3 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(3))));
	else
		print ("NOTHING is set in objective 3");
	end
	
	//sleep until all the objectives are destroyed/switches flipped
	sleep_until (s_all_objectives == s_all_objectives_count, 1);
	
	print ("------objective destroy ended------");
	b_goal_ended = true;
	
end

script static void objective_destroy_watch (object_name objective_obj)
	//watch for a switch to be pulled or object to be destroyed and add 1 to the count once it is true
	print ("objective destroy watch started with object named...");
	if object_valid (objective_obj) == false then
		print ("objective object is NOT valid -- goal is blocked because it ");
	end
	inspect (objective_obj);
	if object_get_health(objective_obj) == 0 then
		if device_get_position(device(objective_obj)) == 0 then
			v_print ("---destroy goal is currently off and needs to get switched on");
			//f_blip_object (objective_obj, "activate");
			
			//blip the markers depending on the user data -- if the user data is 1 then display the opposite ie. activate becomes deactivate
			if firefight_mode_get_current_user_data() == 1 then
				v_print ("GLOBAL SCRIPT: user data is 1 reversing the nav marker to DEACTIVATE");
				thread (f_blip_object_cui (objective_obj, "navpoint_deactivate"));
			elseif firefight_mode_get_current_user_data() == 2 then
				v_print ("GLOBAL SCRIPT: user data is 2 setting the nav marker to generic OBJECTIVE");
				thread (f_blip_object_cui (objective_obj, "navpoint_goto"));
			elseif firefight_mode_get_current_user_data() == 3 then
				v_print ("GLOBAL SCRIPT: user data is 3 not setting the nav marker");
				
			else
				thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
			end
			
			sleep_until (device_get_position(device(objective_obj)) > 0, 1);
			v_print ("an object was switched on");
		
		else
			v_print ("---destroy goal is a device control that is currently on");
			
			//blip the markers depending on the user data -- if the user data is 1 then display the opposite ie. activate becomes deactivate
			if firefight_mode_get_current_user_data() == 1 then
				v_print ("GLOBAL SCRIPT: user data is 1 reversing the nav marker to ACTIVATE");
				thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
			elseif firefight_mode_get_current_user_data() == 2 then
				v_print ("GLOBAL SCRIPT: user data is 2 setting the nav marker to generic OBJECTIVE");
				thread (f_blip_object_cui (objective_obj, "navpoint_goto"));
			elseif firefight_mode_get_current_user_data() == 3 then
				v_print ("GLOBAL SCRIPT: user data is 3 not setting the nav marker");
				
			else
				thread (f_blip_object_cui (objective_obj, "navpoint_deactivate"));
			end
			
			sleep_until (device_get_position(device(objective_obj)) < 1, 1);
			v_print ("an object was switched off");		
		
		end
		//f_unblip_object (objective_obj);
		f_unblip_object_cui (objective_obj);
	else
		v_print ("---destroy goal is a destructible object");
		//turns on the HUD pointers and HUD health marker
		//f_blip_object (objective_obj, "neutralize");
		//thread (f_blip_object_cui (objective_obj, "navpoint_healthbar_neutralize"));
		if firefight_mode_get_current_user_data() == 1 then
			v_print ("GLOBAL SCRIPT: user data is 1 changing the nav marker to DESTROY");
			thread (f_blip_object_cui (objective_obj, "navpoint_healthbar_destroy"));
		elseif firefight_mode_get_current_user_data() == 2 then
			v_print ("GLOBAL SCRIPT: user data is 2 setting the nav marker to generic OBJECTIVE");
			thread (f_blip_object_cui (objective_obj, "navpoint_goto"));
		elseif firefight_mode_get_current_user_data() == 3 then
			v_print ("GLOBAL SCRIPT: user data is 3 not setting the nav marker");
				
		else
			thread (f_blip_object_cui (objective_obj, "navpoint_healthbar_neutralize"));
		
		end
		
		sleep_until (object_get_health(objective_obj) <= 0, 1);
		v_print ("an object was destroyed");
	end
	v_print ("s_all_objectives_count is now +1");
	s_all_objectives_count = s_all_objectives_count + 1;
end


// ================================================================================================================
//========= (DEFENSE) DEFEND OBJECTIVE SCRIPTS ====================================
// ================================================================================================================


script continuous objective_defend
	sleep_forever();
	print ("------objective defend started------");
	b_goal_ended = false;
	
	//set the objective objects
	//these are set in the game variant tag under "objective 1 - 4"
	if firefight_mode_get_current_objective(0) == 0 then
		print ("no objective set in tag for objective 0 :(");
	else
		//randomize which object gets attacked first
		begin_random_count (1)
			obj_defend_1 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
			obj_defend_1 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(1));
		end
		
		print ("obj defend 1 is set");
		
		inspect (obj_defend_1);
	end
	
	if firefight_mode_get_current_objective(1) == 0 then
		print ("no objective set in tag for objective 1 :(");
	else
		//make obj_defend 2 the opposite of obj_defend_1
		if obj_defend_1 == firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0)) then
			obj_defend_2 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(1));
		else
			obj_defend_2 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
		end
		
		print ("obj defend 2 is set");
		inspect (obj_defend_2);
	end
	
	//set the timer variable to the user data field then translate that to minutes
	r_defend_timer = firefight_mode_get_current_user_data() * 60 * 30;
	
	//make sure the defend timer is never set to 0.  Default it to 5 minutes
	if r_defend_timer == 0 then
		print ("-----WARNING---- no defend timer is set in the tag -- defaulting time to 5 minutes");
		r_defend_timer = 10.0 * 60 * 30;
	else
		print ("---defend timer is set for...");
		inspect (r_defend_timer);
	end
			
	//prep generators
	ai_object_set_team (obj_defend_1, player);
	object_set_allegiance (obj_defend_1, player);
	object_immune_to_friendly_damage (obj_defend_1, true);
	ai_object_set_team (obj_defend_2, player);
	object_set_allegiance (obj_defend_2, player);
	object_immune_to_friendly_damage (obj_defend_2, true);
	
	//place the AI
	//ai_place (sq_ff_marines);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	thread (defend_ai());
	thread (defend_lose_condition());
	
	//this sleep might be unneccesary now
//	sleep (30 * 8);
	v_print ("DEFEND!!");

	wake (objective_timer);
	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	
	//turns on the HUD pointers and HUD health marker
	
	thread (f_blip_object_cui (obj_defend_1, "navpoint_healthbar_defend"));
	thread (f_blip_object_cui (obj_defend_2, "navpoint_healthbar_defend"));


		//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	print ("defend 1/5th time");
	NotifyLevel("defend_1/5");
	f_add_lives();
	
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 2/5th time");
		NotifyLevel("defend_2/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 3/5th time");
		NotifyLevel("defend_3/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 4/5th time");
		NotifyLevel("defend_4/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 5/5th time -- all done");
		NotifyLevel("defend_5/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end

//unblip the objects once the objective is complete
	if (object_get_health (obj_defend_1) > 0) then
		f_unblip_object_cui (obj_defend_1);
	end
	if (object_get_health (obj_defend_2) > 0) then
		f_unblip_object_cui (obj_defend_2);
	end
	
//stop any audio warnings
	sound_looping_stop (fx_misc_warning);
	sound_looping_stop (fx_misc_warning_2);	
	
	print ("------objective defend completed------");
	
	b_goal_ended = true;
	
end

script static void defend_ai
	//set the AI registered by the variable ai_defend_all to attack the defend objects every 5 seconds
	//
	repeat
		sleep_until (ai_living_count (ai_defend_all) > 0);
		ai_set_objective (ai_defend_all, objective_defend);
	
		
		//AI wants to kill the defend objects
		if (object_get_health (obj_defend_1) > 0) then
			ai_magically_see_object (ai_defend_all, obj_defend_1);
			ai_object_set_targeting_bias (obj_defend_1, 0.85);
			v_print ("--AI fighting object 1");
		elseif (object_get_health (obj_defend_2) > 0) then
			ai_magically_see_object (ai_defend_all, obj_defend_2);
			ai_object_set_targeting_bias (obj_defend_2, 0.85);
			v_print ("--AI fighting object 2");
		
		end
		sleep (30 * 5);
		//	(ai_living_count (ai_ff_all) <= 0) or
		//	(object_get_health (obj_defend_1) <= 0);
	until (b_goal_ended == true or
				(object_get_health(obj_defend_1) + object_get_health(obj_defend_2) <= 0), 1);
				print ("--both defend objects destroyed");
	
	//reset all the AI objectives after the player goal is done
	ai_set_objective (ai_defend_all, obj_survival);
end


//track the health of the defense objects, and call warning sounds when they get low.  End the goal when both are destroyed
script static void defend_lose_condition
	
	s_defend_obj_destroyed = 0;
	
	sleep_until (object_get_health (obj_defend_1) >= 0 and object_get_health (obj_defend_2) >= 0);
	
	sleep_until (object_get_health (obj_defend_1) <= 0.5 or object_get_health (obj_defend_2) <= 0.5);
	//sound_looping_start (fx_misc_warning, NONE, 1.0);
	thread (defend_lose_audio_1());
	
	sleep_until (object_get_health (obj_defend_1) <= 0 or object_get_health (obj_defend_2) <= 0);
	//sound_looping_stop (fx_misc_warning);
	s_defend_obj_destroyed = 1;
	
	sleep_until (object_get_health (obj_defend_1) <= 0.5 and object_get_health (obj_defend_2) <= 0.5);
	//sound_looping_start (fx_misc_warning_2, NONE, 1.0);
	thread (defend_lose_audio_2());
	
	sleep_until (object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0);
	
	s_defend_obj_destroyed = 2;
	
	b_goal_ended = true;
	print ("------objective defend LOST!!------");


end

//play the warning audio on the defense objects -- but only ever play it on one
script static void defend_lose_audio_1
	print ("warning klaxon 1 playing");
	if (object_get_health (obj_defend_1) <= 0.5 and object_get_health (obj_defend_2) <= 0.5) then
		sound_looping_start (fx_misc_warning, obj_defend_1, 1.0);
	elseif (object_get_health (obj_defend_1) <= 0.5 and object_get_health (obj_defend_2) > 0.5) then
		sound_looping_start (fx_misc_warning, obj_defend_1, 1.0);
	elseif (object_get_health (obj_defend_2) <= 0.5 and object_get_health (obj_defend_1) > 0.5) then
		sound_looping_start (fx_misc_warning, obj_defend_2, 1.0);	
	end
	//sleep_s (5);
	sleep_until (object_get_health (obj_defend_1) <= 0 or object_get_health (obj_defend_2) <= 0, 1, 30 * 5);
	sound_looping_stop (fx_misc_warning);

end

script static void defend_lose_audio_2
	print ("warning klaxon 2 playing");
	
	if (object_get_health (obj_defend_1) <= 0.5 and object_get_health (obj_defend_2) == 0) then
		sound_looping_start (fx_misc_warning, obj_defend_1, 1.0);
	elseif (object_get_health (obj_defend_2) <= 0.5 and object_get_health (obj_defend_1) == 0) then
		sound_looping_start (fx_misc_warning, obj_defend_2, 1.0);
	end

	sleep_until (object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0, 1, 30 * 5);
	sound_looping_stop (fx_misc_warning);

end

// ================================================================================================================
//============== (NO MORE WAVES) SWARM OBJECTIVE SCRIPTS ====================================
// ================================================================================================================



script continuous objective_swarm
	sleep_forever();
	print ("------objective swarm (NO MORE WAVES) started------");
	b_goal_ended = false;


	wake (objective_timer);
	
	//wait until the players have spawned to show HUD items and start the logic
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
	
	//set a 'goto' marker if there is a variable in the objective field
	if firefight_mode_get_current_objective(0) > 0 then
		flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
		//put a HUD marker on the spot players should go
		//f_blip_object (flag_0, "recon");
		thread (f_blip_object_cui (flag_0, "navpoint_generic"));
		v_print ("Swarm area blipped at flag");
		inspect (flag_0);		
	end
	
		
	//sleep until the final wave
	sleep_until (firefight_mode_wave_get() == firefight_mode_waves_in_player_goal() - 1, 1);
	
//	sleep (30 * 5);
	//sleep until the final wave is finished
	sleep_until (b_all_waves_ended, 1);
	
	//turn off the marker if one was set
	if firefight_mode_get_current_objective(0) != 0 then
		f_unblip_object_cui (flag_0);
	end
	
	print ("------objective swarm ended------");
	b_goal_ended = true;
end


// ================================================================================================================
//================= (OTHER) CAPTURE OBJECTIVE SCRIPTS ====================================
// ================================================================================================================

script continuous objective_capture
	sleep_forever();
	b_goal_ended = false;
	print ("......objective capture started.......");
	b_capture_marker = false;
	wake (objective_timer);
	objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (objective_obj);
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
		
	if device_get_position(device(objective_obj)) == 0 then
		v_print ("---capture object is a device control that is currently off");
		thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
		sleep_until (device_get_position(device(objective_obj)) > 0, 1);
		v_print ("capture object has been picked up");
		
	elseif
		device_get_position(device(objective_obj)) == 1 then
		v_print ("---destroy goal is a device control that is currently on");
		thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
		sleep_until (device_get_position(device(objective_obj)) < 1, 1);
		v_print ("capture object has been picked up");
		
	end	
	
	//call HUD marker here.  It should stay up until the the mission is over
	//cinematic_set_title (got_artifact);
	b_capture_marker = true;
	
	//f_unblip_object (objective_obj);
	f_unblip_object_cui (objective_obj);
	//objective is complete
		print ("------objective capture ended------");
	b_goal_ended = true;
	//end event

end

// ================================================================================================================
//============= (OBJECT DELIVERY) DEPOSIT OBJECTIVE SCRIPTS (TAKE)====================================
// ================================================================================================================

script continuous objective_take
	sleep_forever();
	b_goal_ended = false;
	print ("......objective take started.......");
	wake (objective_timer);
	//set the objectives to the objectives set in Bonobo
	//objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (flag_0);
	//tv_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(2));

	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	v_print ("------player(s) are alive------");
	
	
	//call HUD marker if not already called
	if b_capture_marker == false then
		b_capture_marker = true;
		v_print ("players have been 'given' the capture object or artifact");
	else
		v_print ("players already have the capture object or artifact");
	end
	
	//put a HUD marker on the drop off spot

	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	sleep (1);
	

	
	//change the radius of detecting the players
	local short objectDistance = 5;
	if firefight_mode_get_current_user_data() > 0 then
		objectDistance = firefight_mode_get_current_user_data();
	end
	
	v_print ("The radius of the marker is...");
	inspect (objectDistance);
	
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ), 1);	
	
	v_print ("------player(s) made it to the drop off spot------");
	//cinematic_set_title (artifact_returned);
	
	//turn off the hud markers for the drop off spot and the object
	//turn off HUD marker
	b_capture_marker = false;
	
	sleep (1);
	//f_unblip_object (flag_0);
	f_unblip_object_cui (flag_0);	
	
	//end the goal
	print ("------objective take ended------");
	b_goal_ended = true;
end

// ================================================================================================================
//========== LOCATION ARRIVAL OBJECTIVE SCRIPTS (A to B)====================================
// ================================================================================================================
script continuous objective_atob
sleep_forever();
	b_goal_ended = false;
	print ("------objective AtoB started------");
	wake (objective_timer);
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (flag_0);
	v_print ("------objective AtoB sleeping------");
	sleep_s (1);
	
	//sleep until they have gotten to the right spot on the map
	
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	v_print ("------player0 is alive------");
	
	//v_print out if there is not a proper flag created
	if objects_distance_to_object ((player0), flag_0) == -1 then
		print ("there is no object set to check the distance");
	end

	//put a HUD marker on the spot players should go
	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	
	//change the radius of detecting the players
	local short objectDistance = 5;
	if firefight_mode_get_current_user_data() > 0 then
		objectDistance = firefight_mode_get_current_user_data();
	end
	
	print ("The radius of the marker is...");
	inspect (objectDistance);
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ) or
		(b_end_player_goal == true), 1);	
	print ("------player(s) made it to the location------");
	
	//f_unblip_object (flag_0);
	f_unblip_object_cui (flag_0);
	
	print ("------objective AtoB ended------");
	b_goal_ended = true;
end


// ================================================================================================================
//=========== KILL BOSS OBJECTIVE SCRIPTS ====================================
// ================================================================================================================
script continuous objective_kill_boss
	sleep_forever();
	print ("------objective kill boss started------");
	b_goal_ended = false;
	ai_boss_objective = firefight_mode_get_squad_at(firefight_mode_get_current_objective(0));
	ai_place (ai_boss_objective);
	sleep (60);
	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
	
	sleep_until (b_wait_for_narrative_hud == false or ai_living_count (ai_boss_objective) <= 0, 1);
	if ai_living_count (ai_boss_objective) <= 0 then
		print ("AI BOSS DEAD, not blipping them");
	else
		print ("blipping Boss");
		f_blip_ai_cui (ai_boss_objective, "navpoint_enemy");
//	f_blip_ai (firefight_mode_get_squad_at(firefight_mode_get_current_objective(0)), "enemy");
//	think about putting in triggers for half health, etc.
		sleep_until(ai_living_count (ai_boss_objective) <= 0, 1);
	end
	print ("------objective kill boss ended------");
	b_goal_ended = true;

end


// ================================================================================================================
//========= WAIT FOR TRIGGER (TIME PASSED) OBJECTIVE SCRIPTS ====================================
// ================================================================================================================

script continuous objective_wait_for_trigger
	sleep_forever();
	print ("------objective wait for trigger started------");
	b_goal_ended = false;
	b_end_player_goal = false;
	
	sleep_until(b_end_player_goal == true, 1);
	print ("------b_end_player goal is true------");
	print ("------objective wait for trigger ended------");
	b_end_player_goal = false;
	b_goal_ended = true;
	
end

// ================================================================================================================
//======== BLIP SCRIPTS ====================================
// ================================================================================================================


// ===== THESE ARE TEST SCRIPTS TO TEST OUT THE NEW CUI NAV MARKERS -- THESE NEED TO GO INTO THE GLOBAL SCRIPTS ONCE CAMPAIGN IS READY -- SEPT 27, 2011 -- GMURPHY
// blip an object temporarily
script static void f_blip_object_cui (object obj, string_id type)
	//wait for the narrative to get done before turning on HUD
	sleep_until (b_wait_for_narrative_hud == false, 1);
	navpoint_track_object_named (obj, type);
end

script static void f_unblip_object_cui (object obj)
	//turn off the narrative HUD tracking and turn off the HUD markers
	kill_script (f_blip_object_cui );
	//b_wait_for_narrative_hud = false;
	navpoint_track_object (obj, false);
	
end	


script static void f_blip_ai_cui (ai group, string_id blip_type)
	sleep_until( (b_blip_list_locked == false), 1);
	print ("blipping ai");
	
	b_blip_list_locked = true;
	s_blip_list_index = 0;
	l_blip_list = ai_actors (group);
	
	repeat
		v_print ("repeating BLIPPING finding the health of the actors");
		if ( object_get_health (list_get (l_blip_list, s_blip_list_index) )> 0) then
		//f_blip_object_cui (list_get (l_blip_list, s_blip_list_index), blip_type);
			navpoint_track_object_named (list_get (l_blip_list, s_blip_list_index), blip_type);
		end	
			
		s_blip_list_index = (s_blip_list_index + 1);
	until ( s_blip_list_index >= list_count (l_blip_list), 1);
	print ("done blipping ai");
	b_blip_list_locked = false;
end


script static void f_unblip_ai_cui (ai group)
	sleep_until( (b_blip_list_locked == false ), 1);
	print ("unblipping ai");
	b_blip_list_locked = true;
	s_blip_list_index = 0;
	
	l_blip_list = ai_actors (group);
	repeat
		v_print ("repeating finding the health of the actors");
			if ( object_get_health (list_get (l_blip_list, s_blip_list_index)) > 0) then
				//f_unblip_object_cui (list_get (l_blip_list, s_blip_list_index));
				navpoint_track_object (list_get (l_blip_list, s_blip_list_index), false);
			end	
			s_blip_list_index = (s_blip_list_index + 1);
	until ( s_blip_list_index >= list_count (l_blip_list), 1);
	print ("done unblipping ai");
	b_blip_list_locked = false;
	b_enemies_are_blipped == false;
end


//==================OBJECTIVE TEXT ON SCREEN================================================

//global cutscene_title objective_text = dashes;


//new objective script
//script static void f_new_objective (cutscene_title objective_text)
script static void f_new_objective (string_id objective_text)

	if editor_mode() then
		cinematic_set_title (new_obj);
	end
	print ("new objective HUD");
	cui_hud_set_new_objective (objective_text);
	pause_test (objective_text);

end

//objective complete script
script static void f_objective_complete

	if editor_mode() then
		cinematic_set_title (obj_complete_text);
	end
	print ("objective complete HUD");
	cui_hud_set_objective_complete (obj_complete_text);
end



//*========================================================
//===============MISC START EVENTS================================================
//*========================================================

script continuous f_misc_set_objective_attack
	sleep_until (LevelEventStatus ("attack_players"), 1);
	print ("attack players");
	ai_set_objective (ai_ff_all, obj_survival);
	
end

// ================================================================================================================
//==================== HELPER SCRIPTS ====================================
// ================================================================================================================

script static void v_print (string strings)
	if b_v_print == true then
		print (strings);
	end

end



script continuous f_default_mission
	sleep_until (LevelEventStatus("test_debug"), 1);
	mission_is_test_debug = true;
	
	switch_zone_set (empty);
	
	firefight_mode_set_crate_folder_at(spawn_points_0, 90);
	
	firefight_mode_set_objective_name_at(lz_0, 	50);
	
	print ("mission is the test_debug mission");
	print ("only 1 spawn folder is active, nothing more -- have fun running around the map");
	f_spops_mission_setup_complete(true);	
	f_spops_mission_intro_complete(true);
	
	sleep_forever();
end

script static boolean b_players_are_alive
	// returns true if any players are alive.
	// used to determine when to start missions, vignettes, etc
	object_get_health (player0) > 0 or
	object_get_health (player1) > 0 or
	object_get_health (player2) > 0 or
	object_get_health (player3) > 0;

end


// ================================================================================================================
//========== ACHIEVEMENT SCRIPTS ====================================
// ================================================================================================================

script static void f_achievement_spops_1
	print ("spops achievement one accomplished - Roses vs Violets");
	//achievement_grant_to_all_players (spops_1_special);
	if player_valid (player0) then
		achievement_grant_to_player (player0, spops_1_special);
	end
	if player_valid (player1) then
		achievement_grant_to_player (player1, spops_1_special);
	end
	if player_valid (player2) then
		achievement_grant_to_player (player2, spops_1_special);
	end
	if player_valid (player3) then
		achievement_grant_to_player (player3, spops_1_special);
	end
	
end


script static void f_achievement_spops_2
	print ("spops achievement two accomplished - Rescue Ranger");
	//achievement_grant_to_all_players (spops_2_special);
	
	if player_valid (player0) then
		achievement_grant_to_player (player0, spops_2_special);
	end
	if player_valid (player1) then
		achievement_grant_to_player (player1, spops_2_special);
	end
	if player_valid (player2) then
		achievement_grant_to_player (player2, spops_2_special);
	end
	if player_valid (player3) then
		achievement_grant_to_player (player3, spops_2_special);
	end
end


script static void f_achievement_spops_3
	print ("spops achievement three accomplished - Knight in White Assassination");
	//achievement_grant_to_player (spops_3_special);
end


script static void f_achievement_spops_4
	print ("spops achievement four accomplished - What Power Outage");
	//achievement_grant_to_all_players (spops_4_special);
	if player_valid (player0) then
		achievement_grant_to_player (player0, spops_4_special);
	end
	if player_valid (player1) then
		achievement_grant_to_player (player1, spops_4_special);
	end
	if player_valid (player2) then
		achievement_grant_to_player (player2, spops_4_special);
	end
	if player_valid (player3) then
		achievement_grant_to_player (player3, spops_4_special);
	end
end


script static void f_achievement_spops_5
	print ("spops achievement five accomplished - No Easy Way Out");
	//achievement_grant_to_all_players (spops_5_special);
	if player_valid (player0) then
		achievement_grant_to_player (player0, spops_5_special);
	end
	if player_valid (player1) then
		achievement_grant_to_player (player1, spops_5_special);
	end
	if player_valid (player2) then
		achievement_grant_to_player (player2, spops_5_special);
	end
	if player_valid (player3) then
		achievement_grant_to_player (player3, spops_5_special);
	end
end

global short pause_text = 0;

script static void pause_test (string_id pause_text_id)
	print ("pause test");
	
	if pause_text > 0 then
		objectives_finish_up_to (pause_text - 1);
	end
	
	objectives_set_string (pause_text, pause_text_id);
	objectives_show_up_to (pause_text);
	pause_text = pause_text + 1;

end

script static void f_pause_screen_complete_objectives ()
	//print ("pause test");
	
	if pause_text > 0 then
		objectives_finish_up_to (pause_text - 1);
	end
	
end

script static void f_clear_spops_objectives()
	//print ("pause test");
	objectives_clear();
	sleep(1);	
	pause_text = 0;
end