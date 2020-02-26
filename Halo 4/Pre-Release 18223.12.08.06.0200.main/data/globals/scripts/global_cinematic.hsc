// ===============================================================================================================================================
// GLOBAL CINEMATIC ==============================================================================================================================
// ===============================================================================================================================================

global boolean b_debug_cinematic_scripts = true;
global boolean b_cinematic_entered = false;

// ===============================================================================================================================================
// Cinematic Play Scripts ========================================================================================================================
// ===============================================================================================================================================

script static void f_start_mission (string_id cinematic_name)

	if (b_cinematic_entered == false) then
		cinematic_enter (cinematic_name, TRUE);
	end
	b_cinematic_entered = false;
	sleep (1);
	
	if (cinematic_skip_start()) then
		if b_debug_cinematic_scripts then
			print ("f_start_mission: playing cinematic...");
		end
		cinematic_run_script_by_name (cinematic_name);
	end
	
	cinematic_skip_stop ();
end

script static void f_play_cinematic (string_id cinematic_name, zone_set cinematic_zone_set, zone_set zone_to_load_when_done)

	if (b_cinematic_entered == false) then
		cinematic_enter (cinematic_name, FALSE);
	end
	b_cinematic_entered = false;
	sleep (1);
	
	// switch zone sets 
	switch_zone_set (cinematic_zone_set);
	sleep (1);
		
	if (cinematic_skip_start()) then
		if b_debug_cinematic_scripts then
			print ("f_play_cinematic: playing cinematic...");
		end
		cinematic_run_script_by_name (cinematic_name);
	end
	
	cinematic_skip_stop_load_zone (zone_to_load_when_done);
end

script static void f_play_cinematic_unskippable(string_id cinematic_name, zone_set cinematic_zone_set)

	if (b_cinematic_entered == false) then
		cinematic_enter (cinematic_name, FALSE);
	end
	b_cinematic_entered = false;
	sleep (1);

	// switch zone sets 
	switch_zone_set (cinematic_zone_set);
	sleep (1);
		
	sound_suppress_ambience_update_on_revert();
	sleep (1);

	if b_debug_cinematic_scripts then
		print ("f_play_cinematic_unskippable: playing cinematic...");
	end
	cinematic_run_script_by_name (cinematic_name);
end

script static void f_play_cinematic_chain (string_id cinematic1, string_id cinematic2, string_id cinematic3)
	
	if (b_cinematic_entered == false) then
		cinematic_enter (cinematic1, TRUE);
	end
	b_cinematic_entered = false;
	sleep (1);
	
	if (cinematic_skip_start()) then
	
		if (cinematic1 != -1) then
			if b_debug_cinematic_scripts then
				print ("f_play_cinematic_chain: playing cinematic 1...");
			end
			cinematic_run_script_by_name (cinematic1);
		end
		
		if (cinematic2 != -1) then
			if b_debug_cinematic_scripts then
				print ("f_play_cinematic_chain: playing cinematic 2...");
			end
			cinematic_run_script_by_name (cinematic2);
		end
		
		if (cinematic3 != -1) then
			if b_debug_cinematic_scripts then
				print ("f_play_cinematic_chain: playing cinematic 3...");
			end
			cinematic_run_script_by_name (cinematic3);
		end
	end
	
	cinematic_skip_stop ();
end

script static void f_end_mission (string_id cinematic_name, zone_set cinematic_zone_set)
		
	if (b_cinematic_entered == false) then
		cinematic_enter (cinematic_name, FALSE);
	end
	b_cinematic_entered = false;	
	sleep (1);
	
	ai_erase_all();
	garbage_collect_now();
	
	switch_zone_set (cinematic_zone_set);
	sleep (1);

	if (cinematic_skip_start()) then
		if b_debug_cinematic_scripts then
			print ("f_end_mission: playing cinematic...");
		end
		cinematic_run_script_by_name (cinematic_name);
	end
	
	cinematic_skip_stop_internal();
	fade_out (0, 0, 0, 0);
	sleep (1);
end

script static void f_end_mission_ai (string_id cinematic_name, zone_set cinematic_zone_set)
		
	if (b_cinematic_entered == false) then 
		cinematic_enter (cinematic_name, FALSE);
	end
	b_cinematic_entered = false;	
	sleep (1);
	
	//(ai_erase_all) in case we want to end the cinematic and manually erase ai
	ai_disregard (player0(), true);
	ai_disregard (player1(), true);
	ai_disregard (player2(), true);
	ai_disregard (player3(), true);			
	garbage_collect_now();
	
	switch_zone_set (cinematic_zone_set);
	sleep (1);

	if (cinematic_skip_start()) then
		if b_debug_cinematic_scripts then
			print ("f_end_mission_ai: playing cinematic...");
		end
		cinematic_run_script_by_name (cinematic_name);
	end
	
	cinematic_skip_stop_internal();
	fade_out (0, 0, 0, 0);
	sleep (1);
end

// ===============================================================================================================================================
// Cinematic Skip Scripts ========================================================================================================================
// ===============================================================================================================================================

script static boolean cinematic_skip_start ()
	cinematic_skip_start_internal(); 			// Listen for the button which reverts (skips) 
	game_save_cinematic_skip();					// Save the game state 
	sleep_until(not (game_saving()), 1); 		// Sleep until the game is done saving 
	not (game_reverted());						// Return whether or not the game has been reverted 
end

script static void cinematic_skip_stop ()
	cinematic_skip_stop_internal(); 			// Stop listening for the button 
	if (not (game_reverted())) then 
		game_revert(); 							// If the player did not revert, do it for him 
		sleep(1); 								// Sleep so that the game can apply the revert
	end
end

script static void cinematic_skip_stop_load_zone (zone_set zone_to_load_when_done)
	cinematic_skip_stop_internal(); 			// Stop listening for the button 
	if (not (game_reverted())) then 
		game_revert(); 							// If the player did not revert, do it for him 
		sleep(1); 								// Sleep so that the game can apply the revert
	end
	switch_zone_set (zone_to_load_when_done);
	sleep(2);
end

// ===============================================================================================================================================
// Cinematic Enter Scripts =======================================================================================================================
// ===============================================================================================================================================

script static void cinematic_enter (string_id cinematic_name, boolean lower_weapon)
	// setting this boolean up so that designers can call a cinematic_enter from outside of the f_play_cinematic -dmiller 6-11-2010
	b_cinematic_entered = true;
	cinematic_enter_pre (lower_weapon);
	sleep (cinematic_tag_fade_out_from_game (cinematic_name));
	cinematic_enter_post();
end

script static void cinematic_enter_no_fade (string_id cinematic_name, boolean lower_weapon)
	// setting this boolean up so that designers can call a cinematic_enter from outside of the f_play_cinematic
	b_cinematic_entered = true;
	cinematic_enter_pre (lower_weapon);
	cinematic_enter_post();
end

script static void cinematic_enter_pre (boolean lower_weapon)
	
	thread (sfx_cinematic_enter());
	
	// ai ignores players
	ai_disregard (players() , TRUE);

	// players cannot take damage 
	object_cannot_take_damage (players());

	// scale player input to zero 
	// cgirons todo: this was (player_control_fade_out_all_input 0) for snaps check if it is a problem
	player_control_fade_out_all_input (1);
	
	// lower the player's weapon
	if (lower_weapon) then
		if b_debug_cinematic_scripts then
			print ("lowering weapon slowly...");
		end	
		players_weapon_down( -1, 1.0, TRUE );
	end		
	
	// pause the meta-game timer 
	campaign_metagame_time_pause(TRUE);

	// fade out the chud 
	// cgirons todo: this was (chud_cinematic_fade 0 0) for snaps check if it is a problem
	chud_cinematic_fade( 0, 0.5 );
end

script static void cinematic_enter_post ()

	// deativate players equipment (forunner vision, etc.)
	players_deactivate_all_equipment ();
	
	// hide players 
	if b_debug_cinematic_scripts then
		print ("hiding players...");
	end
	players_hide( -1, TRUE );
	
	// disable player input 
	player_enable_input (FALSE);

	// player can now move 
	player_disable_movement (TRUE);
	sleep (1);
	
	// go time
	if b_debug_cinematic_scripts then 
		print ("camera control on");
	end
	
	camera_control (TRUE);
	cinematic_start();
end

// ===============================================================================================================================================
// Cinematic Exit Scripts ========================================================================================================================
// ===============================================================================================================================================

script static void cinematic_exit (string_id cinematic_name, boolean weapon_starts_lowered)
	cinematic_exit_pre (weapon_starts_lowered);
	sleep (cinematic_tag_fade_in_to_game (cinematic_name));
	cinematic_exit_post (weapon_starts_lowered);
end

script static void cinematic_exit_no_fade (string_id cinematic_name, boolean weapon_starts_lowered)
	cinematic_exit_pre (weapon_starts_lowered);
	cinematic_exit_post (weapon_starts_lowered);
end

script static void cinematic_exit_pre (boolean weapon_starts_lowered)
	cinematic_stop();
	camera_control (OFF);

	// unhide players 
	players_hide( -1, FALSE );
	
	// raise weapon 
	if (weapon_starts_lowered) then
		if b_debug_cinematic_scripts then
			print ("snapping weapon to lowered state...");
		end
		players_weapon_down( -1, 1.0/30.0, TRUE );
		sleep (1);
		players_weapon_down( -1, 1.0, FALSE );
		sleep (1);
	end
	
	// unlock the players gaze 
	player_control_unlock_gaze (player0());
	player_control_unlock_gaze (player1());
	player_control_unlock_gaze (player2());
	player_control_unlock_gaze (player3());
	sleep (1);
end

script static void cinematic_exit_post (boolean weapon_starts_lowered)
	cinematic_show_letterbox (0);
	
	// raise weapon 
	if (weapon_starts_lowered) then
		if b_debug_cinematic_scripts then
			print ("raising player weapons slowly...");
		end
		players_weapon_down( -1, 1.0, FALSE );
		sleep (10);		
	end
	
	// fade in the chud 
	chud_cinematic_fade (1, 1);
	sleep (1);
		
	// enable player input 
	player_enable_input (TRUE);

	// scale player input to one 
	player_control_fade_in_all_input (1);
	
	// pause the meta-game timer 
	campaign_metagame_time_pause (FALSE);

	// the ai will disregard all players 
	ai_disregard (players(), FALSE);

	// players can now take damage 
	object_can_take_damage (players());

	// player can now move 
	player_disable_movement (FALSE);
	
	thread( sfx_cinematic_exit() );
end
