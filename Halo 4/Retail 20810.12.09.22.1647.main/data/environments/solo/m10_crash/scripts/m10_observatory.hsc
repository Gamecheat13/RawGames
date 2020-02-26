
// =================================================================================================
// =================================================================================================
// OBSERVATORY ENCOUNTER
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================

global short S_OBS_OBJ_CON  								= 0;

global short DEF_OBS_OBJ_START 							= 1;
global short DEF_OBS_OBJ_ENCOUNTER_01				= 2;
global short DEF_OBS_OBJ_POWER_ACTIVE		  	= 3;
global short DEF_OBS_OBJ_DOOR_OPENING		  	= 4;
global short DEF_OBS_OBJ_MAW_REVEAL 				= 5;
global short DEF_OBS_OBJ_PODS_LANDED 				= 6;
global short DEF_OBS_OBJ_WAVE_01 						= 7;
global short DEF_OBS_OBJ_LANDER_01_SPAWN  	= 8;
global short DEF_OBS_OBJ_LANDER_01_UNLOAD 	= 9;
global short DEF_OBS_OBJ_LANDER_02_SPAWN  	= 10;
global short DEF_OBS_OBJ_LANDER_02_UNLOAD 	= 11;
global short DEF_OBS_OBJ_ENCOUNTER_CLEANUP	= 12;
global short DEF_OBS_OBJ_CORTANA_GET 				= 13;
global short DEF_OBS_OBJ_ELEVATOR_OPEN 			= 14;
global short DEF_OBS_OBJ_ELEVATOR_ACTIVE 		= 15;

global short S_OBS_WAVE_COUNT 	= 0;
global short S_OBS_WAVE_NEXT   = 0;

global short S_OBS_LANDER_ELITE_COUNT = 2;

global short DEF_OBS_FLEET_FRAME_TOTAL 	= 1800;
global short DEF_OBS_WINDOW_FRAME_TOTAL = 30;

global real R_OBS_FLEET_POSITION		= 0.0;
global real R_OBS_WINDOW_POSITION   = 0.0;


global long L_observatory_cruiser_rumble_ID = 0;

global long L_checkpoint_combat_ID_observatory = 0;
global long g_ObsShipsShow = 0;
global long g_DebrisShow = 0;

// =================================================================================================

script startup f_observatory_init()
	sleep_until (b_mission_started == TRUE);
	//wake(f_observatory_main);
	wake(f_observatory_main_02);
	kill_volume_disable(kill_observatory);
end

//NEW OBSERVATORY ENCOUNTER SET UP NO DROP POD MOMENT
script dormant f_observatory_main_02()
	dprint ("::: observatory prepare 2:::");

	sleep_until (current_zone_set_fully_active() == S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory, 1);
	object_create_folder_anew(dm_observatory);
	object_create_folder_anew(dc_observatory);
	kill_volume_enable(kill_observatory);
	sleep_until(object_valid(wr_obs_3));
	wr_obs_3->open_instant();
	wr_obs_4->open_instant();
	wr_obs_7->open_instant();
	wr_obs_8->open_instant();
	wr_obs_11->open_instant();
	wr_obs_12->open_instant();
	wr_obs_13->open_instant();
	//dprint  ("::: observatory start :::");
	
	//DATA MINE
	data_mine_set_mission_segment ("m10_observatory");
	
	//STAGING
	//wake(f_wr_obs_main);
	wake(f_grenade_tutorial);
	wake (f_observatory_objectives);
		print ("WAKE OBJECTIVES");
	
	device_group_set_immediate (obs_power_group, 0);

	sleep_s(1);
	
	//START
	S_OBS_OBJ_CON = DEF_OBS_OBJ_START;
		print ("OBJ_CON START");

//	game_save();
//	print ("Game Saved");
	thread( f_mus_m10_e01_begin() );

	sleep_until(volume_test_players(tv_enter_obs)==TRUE, 1);
		print ("In volume");
	//ai_place(ai_observatory_init);

	print ("Puppet Show Start");
	// elite hacking the business
	pup_play_show(elite_hacking_obs);
	pup_play_show(obs_grunts_1);
	pup_play_show(obs_grunts_2);	
	wake(f_grunt_living_check);
	thread (disregard_player());

	
	//TURN OFF AI GRENADES
	ai_grenades(FALSE);
	sleep_until(ai_combat_status(ai_observatory_init) > 7 or ai_living_count(ai_observatory_init) < 1);
	S_OBS_OBJ_CON = DEF_OBS_OBJ_ENCOUNTER_01;
	sleep_until(ai_living_count(ai_observatory_init) < 1);
	wake(f_obs_plinth_02);
	
	NotifyLevel("first obs guys dead");

	sleep_until (S_OBS_OBJ_CON == DEF_OBS_OBJ_DOOR_OPENING, 1);
	
	//sleep until right moment in dialogue
	//game_save();
	wake(f_obs_cov_ai_02);
	
	sleep_until (S_OBS_OBJ_CON == DEF_OBS_OBJ_ELEVATOR_OPEN, 1);
	game_save();
	//kill optional leaving dialogue once comabat is over
	sleep_forever(f_dialog_observatory_try_to_leave_optional);
		
	sleep_s(2);
		
	//game_save();
	thread( f_mus_m10_e01_finish() );
	sleep_s(1);
	
	wake(f_elevator_activate);
end

// f_objective_set( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip )
script dormant f_observatory_objectives
	
	// kill the guys
	sleep_until(volume_test_players(tv_leave_obs_during_combat), 1);
	thread (f_objective_set( DEF_R_OBJECTIVE_ELIMINATE_ENEMY, TRUE, FALSE, TRUE, FALSE ));
	// HAX: for some reason this doesn't say complete
	
	// ai eliminated, find the switch
	sleep_until(LevelEventStatus("first obs guys dead"), 1);
	//thread (f_objective_complete( DEF_R_OBJECTIVE_ELIMINATE_ENEMY, TRUE, FALSE ));
	thread (f_objective_set( DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR, TRUE, FALSE, TRUE, TRUE ));
	wake(f_blip_override_panel);
	
	// unblip if switch hit
	sleep_until(LevelEventStatus("override switch hit"), 1);
	thread (f_objective_blip( DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR, FALSE, TRUE ));
		
	// guys rush in, kill them!
	sleep_until(LevelEventStatus("landers broken through"), 1);
	thread (f_objective_set( DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2, TRUE, FALSE, FALSE, FALSE ));

	// killed attackers, head to elevator
	sleep_until(LevelEventStatus("Get to the Elevator"), 1);
	
	sleep_until(b_elevator_banks_blip == TRUE);
	thread (f_objective_blip( DEF_R_OBJECTIVE_GOTO_ELEVATOR, TRUE, TRUE ));
	
	sleep_until(b_get_objective_beacon == TRUE);
	thread (f_objective_set( DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS, TRUE, FALSE, TRUE, FALSE ));

	objectives_finish(0);
	objectives_show_up_to(1);
		
	// got near elevator
	sleep_until(LevelEventStatus("Got near elevator"), 1);
	thread(f_objective_blip( DEF_R_OBJECTIVE_GOTO_ELEVATOR, FALSE, TRUE ));
end

script dormant f_blip_override_panel()
	sleep_until(LevelEventStatus("obs waypoint set"), 1);
	
	sleep_s (10);
			
	if (device_get_power(obs_plinth_control) == 1) then
		thread (f_mission_objective_blip( DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR, TRUE));
	end		
end


script static void disregard_player()

	player_action_test_reset();
	sleep_until (volume_test_players (tv_obs_ai_disregard) or player_action_test_grenade_trigger() or player_action_test_primary_trigger()
							or ai_living_count(sq_obs_start_elite_01) < 1 or ai_combat_status(sq_obs_start_elite_01) >= 7, 1);
	
	ai_set_blind(sq_obs_start_grunt_02, FALSE);
	ai_set_blind(sq_obs_start_grunt_03_left, FALSE);
	ai_set_blind(sq_obs_start_grunt_04_left, FALSE);
	ai_set_deaf (sq_obs_start_elite_01, FALSE);
	wake(f_surprise_grunts);
end

//================================================================================================
//OBSERVATORY
//================================================================================================

/*script static void f_activator_get( object trigger, unit activator )
	g_ics_player = activator;
end*/

//Grunts puppeteer exit animation
script dormant f_surprise_grunts()
	print("**Surprise!!**");
	custom_animation(sq_obs_start_grunt_02.spawn_points_0, "objects\characters\storm_grunt\storm_grunt.model_animation_graph", "combat:pistol:surprise_front", true);
	sleep(15);
	custom_animation(sq_obs_start_grunt_02.spawn_points_3, "objects\characters\storm_grunt\storm_grunt.model_animation_graph", "combat:pistol:surprise_front", true);
	sleep(5);
	custom_animation(sq_obs_start_grunt_03_left.spawn_points_2, "objects\characters\storm_grunt\storm_grunt.model_animation_graph", "combat:pistol:surprise_front", true);
		sleep(10);
	custom_animation(sq_obs_start_grunt_04_left.spawn_points_1, "objects\characters\storm_grunt\storm_grunt.model_animation_graph", "combat:pistol:surprise_front", true);
end

script dormant f_obs_plinth_02()
	//Objective blip is in dialog
	
	//game_save();
	
	wake(f_dialog_observatory_start);
	//wake(f_dialog_observatory_start_optional);
	
	sleep_until(LevelEventStatus("obs waypoint set"), 1);
	
	sleep_s(0.3);
	device_group_set_immediate (obs_power_group, 1);
	sleep(1);
	sleep_until (device_get_position(obs_plinth_control) != 0, 1);

	device_group_set_immediate (obs_power_group, 0);
	
	NotifyLevel("override switch hit");
	
	//g_ics_player = player0; // HACK - eventually this should be set to the player that pressed the button
	local long show_button=pup_play_show(obs_button);
	sleep_until(not pup_is_playing(show_button),1);

	wake(f_obs_blast_shields_open);

//	sleep_forever(f_dialog_observatory_start_optional);
		
	S_OBS_OBJ_CON = DEF_OBS_OBJ_DOOR_OPENING;

	// PiP
	//hud_play_pip("010_ob_deck_pip");
	
	wake(f_move_close_ship_obs);
	g_ObsShipsShow= pup_play_show(obs_ships);	
	g_DebrisShow= pup_play_show(debris_show);	
	local long show = pup_play_show(observe);
	sleep_until(not pup_is_playing(show),1);
	
	NotifyLevel("landers broken through");
	
	pup_play_show(observe_left);
	
	show = pup_play_show(observe_right);
	
	sleep_until(not pup_is_playing(show),1);
	S_OBS_OBJ_CON = DEF_OBS_OBJ_WAVE_01;
	wake (f_lander_elite_check);
	
	// optional if player leaves during combat
	wake(f_dialog_observatory_try_to_leave_optional);
end

script dormant f_move_close_ship_obs()
		object_cinematic_visibility( close_cruiser, TRUE );
		object_move_to_point (close_cruiser, 500, ps_close_cruiser.p0);
end

script dormant f_obs_cov_ai_02()
	sleep_until (S_OBS_OBJ_CON == DEF_OBS_OBJ_WAVE_01, 1);
		if ( L_checkpoint_combat_ID_observatory == 0 ) then
		L_checkpoint_combat_ID_observatory = f_combat_checkpoint_add( obs_group, -1, TRUE, -1, 10, -1 );
	end
	
	//music
	thread(f_music_observatory_first_pod_landed());
	ai_object_enable_grenade_attack(player0, FALSE);
	ai_grenades(FALSE);
	thread(m10_observ_stragglers());
	wake(m10_observ_atmosphere_breach);
	
	sleep_until (ai_living_count(obs_lander_ai) > 0);
	sleep_until (ai_living_count (obs_lander_ai) <= 2);
	S_OBS_OBJ_CON = DEF_OBS_OBJ_ENCOUNTER_CLEANUP;
	sleep_until (ai_living_count (obs_lander_ai) == 0, 1);
	
	//music 
	thread(f_music_observatory_combat_finished());
	ai_object_enable_grenade_attack(player0, TRUE);
	ai_grenades(TRUE);
	sleep_s(1);
	S_OBS_OBJ_CON = DEF_OBS_OBJ_ELEVATOR_OPEN;
end

script dormant f_lander_elite_check()
	repeat 
	dprint("start elite living check");
		if (ai_living_count(sq_obs_right_elite) + ai_living_count(sq_obs_left_elite)) > 1 then
		dprint("equals 2");
		sleep_s(1);
		else
		S_OBS_LANDER_ELITE_COUNT = 1;
		dprint("set to 1");
		end
		sleep_s(1);
	until(S_OBS_LANDER_ELITE_COUNT == 1);

end

script dormant f_wave_1_timer()
	sleep_s(random_range(90, 110));
	//dprint("::: NEXT WAVE:::");
	S_OBS_WAVE_NEXT = 1;
end

script dormant f_wave_2_timer()
	sleep_s(random_range(80, 90));
	//dprint("::: NEXT WAVE:::");
	S_OBS_WAVE_NEXT = 2;
end


script dormant f_obs_maw()

	sleep_until(f_check_device_position(obs_fleet_drop_pod, 100, DEF_OBS_FLEET_FRAME_TOTAL), 1);
	//dprint("maw opening now");
	//maw_door->open();
	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	L_observatory_cruiser_rumble_ID = f_mission_screenshakes_rumble_low( 4.0 );
	//XXX NEED TO COME UP WITH SOLUTION TO SELL FUD MOVING INTO MAW

end

script dormant f_cov_ship_fly_over()
	sleep_until(f_check_device_position(obs_fleet_drop_pod, 400, DEF_OBS_FLEET_FRAME_TOTAL), 1);
	f_screenshake_event_med( 0.75, 1.25, 5.0, NONE );
end


//=================================================================================================
//STAGING
//=================================================================================================

//ELEVATOR
script dormant f_elevator_activate()
	dprint("Elevator on");
    wake(m10_observatory_get_objective_beacon_main);
    wake(m10_observatory_get_objective_beacon_alt);
	
	//dprint("sleep until door and elevator are valid");
	sleep_until( object_valid(elevator_1_platform) and object_valid(door_elevator_1_top), 1 );
	//dprint("prep elevator");

	// setup elevator door
	dprint("set device position track");
	device_set_position_track( door_elevator_1_top, 'any:idle', 0 );
	device_set_position(door_elevator_1_top, 0);
	
	//dprint("disable kill volume and set cinematic visibility");
	kill_volume_disable(kill_observatory);
	object_cinematic_visibility( elevator_1_platform, TRUE );	
	object_set_always_active( elevator_1_platform, TRUE );
	
	//dprint("blip door");
	sleep_s(12);
	NotifyLevel("Get to the Elevator");

	sleep_until (volume_test_players (tv_enter_obs));

	//game_save();
	
	NotifyLevel("Got near elevator");

	// open elevator door
	f_elevator_open();	
end

script static void f_elevator_check_reset() 
	sleep_until(volume_test_players(tv_observatory_elevator), 1);
	f_elevator_close();
	sleep_until(device_get_position(door_elevator_1_top) == 0);

	if volume_test_players (tv_observatory_elevator) then
		dprint("elevator ready to go");
		wake(f_elevator_go);
	else
		f_elevator_open(); 
	end
end

script static void f_elevator_open()
	
	sleep_until(device_get_position(door_elevator_1_top) == 0, 1);
	NotifyLevel("Got in elevator");
	thread(fx_elevator_flares());
	// open the doors
	sfx_elevator_double_door(door_elevator_1_top); // play door open sound
	device_animate_position(door_elevator_1_top, 1, 2, 0.1, 0.1, FALSE);
	
	// wait for the doors to get open completely
	sleep_until(device_get_position(door_elevator_1_top) == 1, 1);
	thread(f_elevator_check_reset());
	kill_script(m10_objective_6_nudge);
		sleep_forever(m10_objective_6_nudge);
		b_objective_6_complete = TRUE;
end

script static void f_elevator_close()
	dprint("F_ELEVATOR_CLOSE");

	// turn off puppet shows that aren't visible anymore
	if g_ObsShipsShow>0 then
		pup_stop_show(g_ObsShipsShow);
		g_ObsShipsShow = 0;
	end
	if g_DebrisShow>0 then
		pup_stop_show(g_DebrisShow);
		g_DebrisShow = 0;
	end
	
	// make sure it's all the way open before proceeding
	sleep_until(device_get_position(door_elevator_1_top) == 1, 1); 
	sleep_s(2);
	dprint("sleep 2");

	// close the top door
	sfx_elevator_double_door(door_elevator_1_top); // play door sound	
	device_animate_position(door_elevator_1_top, 0, 2, 0.1, 0.1, FALSE);
	
	dprint("door closed unblip object");
	thread(f_objective_blip( DEF_R_OBJECTIVE_GOTO_ELEVATOR, FALSE, TRUE ));
	f_unblip_object (elevator_1_platform);
end

script dormant f_elevator_go()
		dprint("F_ELEVATOR_GO");
		sleep_until(device_get_position(door_elevator_1_top) == 0, 1);	
		//fx_camera_pause( TRUE );
		sleep(1);

		// Move the elevator down
		// thread(sfx_m10_elevator_platform_start( NONE )); // start the motor sound- do we want to put the sound on the platform?
		// sfx_elevator_door_open( NONE ); // play sound for the inner door - TODO: need marker
		local long ele_show = pup_play_show(obs_elevator_down);
		
		// elevator_1_platform->down();		
		kill_volume_disable(kill_observatory);
		//fx_camera_pause( FALSE );
		sleep(80);
		volume_teleport_players_not_inside(tv_observatory_elevator, flag_obs_ele_tp) ;
		thread(f_objective_blip( DEF_R_OBJECTIVE_GOTO_ELEVATOR, FALSE, TRUE ));
		// Wait for it to descend
		// dprint("sleep_until Position 0.7");
		// sleep_until(device_get_position(elevator_1_platform) >= 0.7, 1);
		sleep_until(not pup_is_playing(ele_show));
		thread(f_objective_blip( DEF_R_OBJECTIVE_GOTO_ELEVATOR, FALSE, TRUE ));
		// thread(sfx_m10_elevator_platform_stop()); // stop the motor sound
		sleep_s(1);
		dprint("check");
		
		// Open the bottom doors
		// wake(f_elevator_door_bottom);
		sfx_elevator_double_door(door_elevator_1_bottom); // play door sound
		device_animate_position(door_elevator_1_bottom, 1, 2, 0, 0, FALSE);
end


//DOORS
/*
script dormant f_observatory_door_1()
	//dprint("Observatory door should open");
	//door_observatory_1->open_default();
	door_observatory_1->auto_trigger_open(tv_enter_obs, TRUE, TRUE, FALSE);
end
 */

/* script dormant f_elevator_door_bottom()
	wake (f_flank_main);
	game_save();
	
	dprint("F_ELEVATOR_DOOR_BOTTOM");
	sleep_until( object_valid(elevator_1_platform), 1);
	
	// dprint("object is moving down");
	// elevator_1_platform->door_open_bottom();
	// dprint("sleep to 1");
	// sleep_until(device_get_position(elevator_1_platform) == 1, 1);
	// dprint("prep door");
	// device_set_position_track( door_elevator_1_bottom, 'any:idle', 0 );
	// dprint("door set");
	// device_set_position(door_elevator_1_bottom, 0);
	
	sleep(1);
	device_animate_position(door_elevator_1_bottom, 1, 2, 0, 0, FALSE);
end */

script static void f_break( object_name window, object_name shield, object_name vortex_1, object_name vortex_2, object_name vortex_3, object_name vortex_4)
	//DESTROY WINDOW
	object_destroy (window);
	thread(f_obs_destroy_window(window));
	thread(f_obs_air_escape(window));
//xxxxx
	thread(f_screenshake_ambient_pause( TRUE, TRUE, 0.0 ));
	thread( f_screenshake_event_med(2.5, 1.0, 1.5, NONE) );  // XXX eventually switch to be location based
	thread(f_screenshake_ambient_pause( FALSE, FALSE, 0.0 ));
	//GRAVITY LOW
	NotifyLevel("window broken");
	//f_gravity_set( R_gravity_cryo );
	//AIR ESCAPE
	//sleep_s(0.1);
	
	sleep(5);
	//VORTEX CREATE
	object_create (vortex_1);
	object_create (vortex_3);
	object_create (vortex_4);
	sleep_s(real_random_range(1.75, 2));
	object_create (vortex_2);
	sleep_s(real_random_range(0.8, 1.0));
	object_destroy (vortex_1);
	object_destroy (vortex_2);
	object_destroy (vortex_3);
	object_destroy (vortex_4);
	thread(f_obs_shield_activate(window));
	f_gravity_set( R_gravity_default );	
end 

//XXX CAN PROBABLY STILL OPTIMIZE THIS SEQUENCE
script static void f_obs_destroy_window(object_name window)

		if window == obs_window_side_right then
			dprint("WINDOW RIGHT BREAK EFFECT");
			effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g_02.effect, fx_pod_debris02  );	
		else
			dprint("WINDOW LEFT BREAK EFFECT");
			effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g_02.effect, fx_pod_debris03  );	
		end
end

script static void f_obs_air_escape(object_name window)

		if window == obs_window_side_right then
			dprint("WINDOW RIGHT SUCK EFFECT");
			effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g_02.effect, fx_air_escape02 );
		else
			dprint("WINDOW LEFT SUCK EFFECT");
			effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g_02.effect, fx_air_escape03 );
		end
end

script static void f_obs_shield_activate(object_name window)

		if window == obs_window_side_right then
			//dprint("WINDOW RIGHT SHIELD EFFECT");
			thread(fx_shield_tube_rt_on());
		else
		//dprint("WINDOW LEFT SHIELD EFFECT");
		thread(fx_shield_tube_lf_on());
		end
end 
/////////////////////////////////////////////////////////

script dormant f_obs_blast_shields_open()
	//dprint("observatory blast shields openening");


//	object_create_folder_anew(dm_observatory);
	object_create_folder_anew(dc_observatory);
	sleep(1);
	thread(f_obs_light());

	//thread(obs_blast_shield->open());
	//thread(f_sfx_observatory_visor());
	//music
	NotifyLevel("music observatory doors opening");
	thread(f_music_observatory_doors_opening());
	kill_script(f_dialog_m10_objective_4);
	kill_script(m10_objective_4_nudge);
	sleep_forever(m10_objective_4_nudge);
end


/*script dormant f_wr_obs_main()

	sleep_until (S_OBS_OBJ_CON >= DEF_OBS_OBJ_START, 1);
	thread(wr_obs_11->auto_distance_open( -2, FALSE ));
	thread(wr_obs_12->auto_distance_open( -2, FALSE ));

	// Right Weapons odd
	dprint("right prep 01");
	

	
	
	sleep_until( object_valid(wr_obs_3), 1 );
	wr_obs_3->chain_parent_open( wr_obs_1, wr_obs_1->close_position(), wr_obs_3->S_chain_state_greater() );
	sleep_until( object_valid(wr_obs_5), 1 );
	dprint("right prep 02");
	wr_obs_5->chain_parent_open( wr_obs_3, wr_obs_3->close_position(), wr_obs_5->S_chain_state_greater() );
	dprint("right prep 03");
	sleep_until( object_valid(wr_obs_7), 1 );
	wr_obs_7->chain_parent_open( wr_obs_5, wr_obs_5->close_position(), wr_obs_7->S_chain_state_greater() );
	dprint("right preped and gtg");
	//Middle
	sleep_until( object_valid(wr_obs_13), 1 );
	wr_obs_13->chain_parent_open( wr_obs_7, wr_obs_7->close_position(), wr_obs_13->S_chain_state_greater() );
	dprint("middle prepped and gtg");
	//Left Weapons even
	sleep_until( object_valid(wr_obs_4), 1 );
	wr_obs_4->chain_parent_open( wr_obs_2, wr_obs_2->close_position(), wr_obs_4->S_chain_state_greater() );
	dprint("left prep 01");
	sleep_until( object_valid(wr_obs_6), 1 );
	wr_obs_6->chain_parent_open( wr_obs_4, wr_obs_4->close_position(), wr_obs_6->S_chain_state_greater() );
	dprint("left prep 02");
	sleep_until( object_valid(wr_obs_8), 1 );
	wr_obs_8->chain_parent_open( wr_obs_6, wr_obs_6->close_position(), wr_obs_8->S_chain_state_greater() );
	dprint("left prep 03");
	//sleep_until (S_OBS_OBJ_CON == DEF_OBS_OBJ_PODS_LANDED, 1);	
	dprint("all weapon racks prepped and gtg wait until grav == 0");
	sleep_until(LevelEventStatus("landers broken through"), 1);
	//sleep_s(1.5);
	sleep_until( object_valid(wr_obs_1), 1 );
	thread(wr_obs_1->open_default());
	dprint("raise 1");
	sleep_until( object_valid(wr_obs_2), 1 );
	thread(wr_obs_2->open_default());
	dprint("raise 2");
end*/

script dormant f_grenade_tutorial()
	thread(f_grenade_check(player0));
	thread(f_grenade_check(player1));
	thread(f_grenade_check(player2));
	thread(f_grenade_check(player3));
end

script static void f_grenade_check(player player_num)
	//dprint("player HAS grenade run grenade tutorial");
	
	// HAX: Remove for GI demo
	//sleep_until (unit_get_total_grenade_count(player_num) > 0, 1);
	//chud_show_screen_training (player_num, "training_throwgrenade");
	sleep_s (3);
	//chud_show_screen_training (player_num, "");
end

//LIGHTS
script static void light_on_gradual()
	print("::: start light function :::");
	
	static real increment = 0.01;
	
	// Turn on direct lights
	// [mboulton 10/25/2011] Note that 12_observatory is actually bsp06, hence the bsp06 post-fix
	repeat
		set_lightmap_direct_scalar_bsp(6, get_lightmap_direct_scalar_bsp(6) + increment);
		set_lightmap_indirect_scalar_bsp(6, get_lightmap_direct_scalar_bsp(6));
	until (get_lightmap_direct_scalar_bsp(6) >= 2.0, 1);
	set_lightmap_direct_scalar_bsp(6, 2.0);
	set_lightmap_indirect_scalar_bsp(6, 2.0);

	
		
	// Wait a few secs
	sleep(60);

	
	thread(sfx_observatory_visor());
		
	//obs_blast_shield->open();
end

script static void light_off_gradual()
	static real decrement = 0.04;
	static real minValue = 0.05;
	
	repeat
		set_lightmap_indirect_scalar_bsp(6, get_lightmap_indirect_scalar_bsp(6) - decrement);
		set_lightmap_direct_scalar_bsp(6, get_lightmap_direct_scalar_bsp(6) - decrement);
	until (get_lightmap_direct_scalar_bsp(6) <= minValue, 1);
	set_lightmap_indirect_scalar_bsp(6, minValue);
	set_lightmap_direct_scalar_bsp(6, minValue);
end
	
script static void f_windows_close()
	obs_blast_shield->close();
	thread(light_off_gradual());
end
	
script static void f_windows_open()
	thread(light_on_gradual());
end

script dormant f_clean_up_obs_crates()
object_destroy(cr_obs_01);
object_destroy(cr_obs_02);
object_destroy(cr_obs_03);
object_destroy(cr_obs_04);
object_destroy(cr_obs_05);
object_destroy(cr_obs_06);
object_destroy(cr_obs_07);
object_destroy(cr_obs_08);
object_destroy(cr_obs_09);
object_destroy(cr_obs_10);
object_destroy(cr_obs_11);
object_destroy(cr_obs_12);
object_destroy(cr_obs_13);
object_destroy(cr_obs_14);
object_destroy(cr_obs_15);
object_destroy(cr_obs_16);
object_destroy(cr_obs_17);
object_destroy(cr_obs_18);
object_destroy(cr_obs_19);
object_destroy(cr_obs_20);
object_destroy(cr_obs_21);
object_destroy(cr_obs_22);
object_destroy(cr_obs_23);
object_destroy(cr_obs_24);
object_destroy(cr_obs_25);
object_destroy(cr_obs_26);
object_destroy(cr_obs_27);
object_destroy(cr_obs_28);
object_destroy(cr_obs_29);
object_destroy(cr_obs_30);
object_destroy(cr_obs_31);
object_destroy(cr_obs_32);
object_destroy(cr_obs_33);
object_destroy(cr_obs_34);
object_destroy(cr_obs_35);
object_destroy(cr_obs_36);
object_destroy(cr_obs_37);
object_destroy(cr_obs_38);
object_destroy(cr_obs_39);
object_destroy(cr_obs_40);

end


//xxx for fx


	script static void fx_fleet()
	//thread(fx_pods());
	thread(obs_blast_shield->open());
	sleep_s(1);
	object_cinematic_visibility( obs_fleet_background, TRUE );
	object_cinematic_visibility( obs_fleet_debris, TRUE );
	object_cinematic_visibility( obs_fleet_crash, TRUE );
	object_cinematic_visibility( obs_fleet_drop_pod, TRUE );
	//dprint("launch covenant fleet animation");
	thread(obs_fleet_background->launch());
	//dprint("obs_fleet_background");
	thread(obs_fleet_debris->launch());
	//dprint("obs_fleet_debris->launch()");
	thread(obs_fleet_crash->launch());
	//dprint("obs_fleet_crash->launch()");
	thread(obs_fleet_drop_pod->launch());
	//dprint("obs_fleet_drop_pod->launch()");
	thread(ambient_debris->start());
	end
	
	/*script static void fx_pods()
	//dprint("pods attached to device machine");
	objects_attach( obs_fleet_drop_pod, "m_obs_grunt_drop_pod_01", obs_pod_1, "chud_nav_point");
	objects_attach( obs_fleet_drop_pod, "m_obs_grunt_drop_pod_02", obs_pod_2, "chud_nav_point");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_01", beac_pod_1, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_02", beac_pod_2, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_03", beac_pod_3, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_04", beac_pod_4, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_05", beac_pod_5, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_06", beac_pod_6, "fx_impact");
end*/

	script static void fx_fleet_reset()
	thread(obs_blast_shield->close());
	sleep_s(1);
	//dprint("launch covenant fleet animation");
	thread(obs_fleet_background->reset());
	//dprint("obs_fleet_background");
	thread(obs_fleet_debris->reset());
	//dprint("obs_fleet_debris->launch()");
	thread(obs_fleet_crash->reset());
	//dprint("obs_fleet_crash->launch()");
	thread(obs_fleet_drop_pod->reset());
	//dprint("obs_fleet_drop_pod->launch()");
	end

script command_script cs_grunt_pod_exit_01()

cs_custom_animation (objects\characters\storm_grunt\storm_grunt.model_animation_graph, "m10_2grunts_exit_escpod_grua", TRUE);
end 

script command_script cs_grunt_pod_exit_02()
cs_custom_animation (objects\characters\storm_grunt\storm_grunt.model_animation_graph, "m10_2grunts_exit_escpod_grub", TRUE);
end 

script command_script cs_grunt_pod_exit_03()
cs_custom_animation (objects\characters\storm_grunt\storm_grunt.model_animation_graph, "m10_2grunts_exit_escpod_gruc", TRUE);
end 

script dormant f_temp_1()
	
	ai_place (ai_observatory_init);
	ai_grenades(FALSE);
	sleep_until(ai_combat_status(ai_observatory_init) > 7 or ai_living_count(ai_observatory_init) < 1);
	S_OBS_OBJ_CON = DEF_OBS_OBJ_ENCOUNTER_01;
	
	sleep_until(ai_living_count(ai_observatory_init) < 1);
	sleep_s(2);
	print("hello world");
 	wake (f_lander_elite_check);
	ai_place (obs_lander_ai);
	/*wr_obs_1->open_default();
	wr_obs_2->open_default();
	wr_obs_3->open_default();
	wr_obs_4->open_default();
	wr_obs_5->open_default();
	wr_obs_6->open_default();
	wr_obs_7->open_default();
	wr_obs_8->open_default();
	wr_obs_11->open_default();
	wr_obs_12->open_default();*/
	

end
script static void f_grunt_counter()
	local short  s_grunt_count = 0;

	repeat
		sleep_s(1);
		s_grunt_count = s_grunt_count + 1;
		//print("living grunt check");
	until(s_grunt_count == 60);
	
	if (ai_living_count(obs_grunt_squads) != 0) then
			 wake(f_dialog_m10_observ_stragglers);
	end

end

script dormant f_grunt_living_check()
	sleep_until(ai_living_count(obs_grunt_squads) <= 3);
	thread(f_grunt_counter());
end

script static void f_elite_left_no_melee()
	object_set_melee_attack_inhibited((ai_get_object(sq_obs_left_elite)),false);
end

script static void f_elite_right_no_melee()
	object_set_melee_attack_inhibited((ai_get_object(sq_obs_right_elite)),false);
end

script static void f_elite_left_readd_melee()
	object_set_melee_attack_inhibited((ai_get_object(sq_obs_left_elite)), TRUE);
end

script static void f_elite_right_readd_melee()
	object_set_melee_attack_inhibited((ai_get_object(sq_obs_right_elite)), TRUE);
end

script static void f_obs_light()
	print("::light is increasing::");
	sleep(85);
	interpolator_start ('observatory');
end