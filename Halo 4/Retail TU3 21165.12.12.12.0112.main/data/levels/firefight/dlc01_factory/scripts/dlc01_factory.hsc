//=============================================================================================================================
//============================================ FACTORY FIREFIGHT SCRIPT ========================================================
//=============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
//=============================================================================================================================
//================================================== LEVEL SCRIPT ==================================================================
//=============================================================================================================================

//=============================================================================================================================
//================================================== GLOBALS ==================================================================
//=============================================================================================================================
//================================================== TITLES ==================================================================
//global boolean b_wait_for_narrative = false;
//player variables for puppeteer
//global object pup_player0 = player0;
//global object pup_player1 = player1;
//global object pup_player2 = player2;
//global object pup_player3 = player3;
	
script startup factory

//================================================== MAIN SCRIPT STARTS ==================================================================
	// setup defaults
	f_spops_mission_startup_defaults();
                
	// track mission flow
	f_spops_mission_flow();

/*	ai_allegiance (human, player);
	ai_allegiance (player, human);
	ai_lod_full_detail_actors (20);

	//THIS STARTS ALL OF FIREFIGHT SCRIPTS
	wake (start_waves);*/
end
/*
script dormant start_waves
	wake (firefight_lost_game);
	wake (firefight_won_game);
	firefight_player_goals();
	print ("goals ended");
	print ("game won");
	//mp_round_end();
	b_game_won = true;

end

script static void setup_destroy
	//set any variables and start the main objective script from the global firefight script

	wake (objective_destroy);

end


script static void setup_defend
	//set any variables and start the main objective script from the global firefight script
	wake (objective_defend);

end

script static void setup_swarm
	//set any variables and start the main objective script from the global firefight script
	wake (objective_swarm);

end

script static void setup_capture
	//set any variables and start the main objective script from the global firefight script
	wake (objective_capture);
end

script static void setup_take
	//set any variables and start the main objective script from the global firefight script
	wake (objective_take);
end

script static void setup_atob
	wake (objective_atob);
end

script static void setup_boss
	wake (objective_kill_boss);
end

script static void setup_wait_for_trigger
	wake (objective_wait_for_trigger);
end
*/
// ==============================================================================================================
// ====== START SCRIPTS ===============================================================================
// ==============================================================================================================

// ====== MISC SCRIPTS ===============================================================================

// ==============================================================================================================
// ====== END MISSION SCRIPTS ===============================================================================
// ==============================================================================================================
//
//
//script continuous f_end_game_total  //ends the whole level
//	sleep_until (LevelEventStatus("end_level_total"), 1);
//	print ("Ending the level now.........................................");
//	sound_looping_stop (music_start);
//	//cinematic_set_title (title_destroy_obj_complete_1);
//	sound_impulse_start (vo_destroy_19, none, 1.0);
//	b_game_ended == TRUE;
//	print ("goals ended");
//	mp_round_end();
//end
//
//
//// ==============================================================================================================
//// ====== TEST ===============================================================================
//// ==============================================================================================================
//
//script static void f_start_player_intro
//	firefight_mode_set_player_spawn_suppressed(true);
//	//if editor_mode() then
//	//	firefight_mode_set_player_spawn_suppressed(false);
//	//else
//	//	intro();
//	//end
//	//intro();
//	firefight_mode_set_player_spawn_suppressed(false);
//	//sleep_until (goal_finished == true);
//end
//
///*script static void intro
//	fade_out (0, 0, 0, 1);
//	sleep (30);
////	object_create (test);
////	object_move_by_offset (test, 1, 0, 0, 30);
////	teleport_players_into_vehicle (test);
////	unit_open (test);
//	fade_in (0, 0, 0, 3);
//	player_effect_set_max_rotation (5, 5, 5);
//	player_effect_set_max_rumble(5, .5);
//	player_effect_start (5, 3);
//	object_move_by_offset (test, 5, 0, 0, -29);
//	fade_out (255, 255, 255, 1);
//	player_effect_stop (1);
//	sleep (30 * 1);
//	object_teleport_to_object (player0, lz_0);
//	sleep (1);
//	object_destroy (test);
//	fade_in (255, 255, 255, 90);
//end*/
//
//script static void camera_test
//	print ("............camera test started............");
//	object_cannot_take_damage (players());
//	ai_disregard (players(), TRUE);
//	player_camera_control (false);
//	player_enable_input (FALSE);
//	camera_control (true);
//	camera_set (cam_0, 1);
//	print ("camera0");
//	sleep (1);
//	camera_set (cam_1, 180);
//	print ("camera1");
//	sleep (240);
//	object_can_take_damage (players());
//	camera_control (false);
//	ai_disregard (players(), false);
//	player_camera_control (true);
//	player_enable_input (true);
//end
//
//
//// ==============================================================================================================
//// ====== FACTORY MESSAGES ===============================================================================
//// ==============================================================================================================
