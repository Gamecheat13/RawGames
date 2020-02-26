//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab/Armory
//										iob							- Observatory
//										ifl							- Flank
//										ibe							-	Beacon
//										ibr							- Broken Floors
//										iea							- Explosion Alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//	
/*
obj_get_cortana					= "OBJECTIVE: Retrieve Cortana"
obj_activate_power			= "OBJECTIVE: Restore Ship Power"
obj_launch_beacon				= "OBJECTIVE: Launch Distress Beacon"
obj_toescapepodbay			= "OBJECTIVE: Escape the Ship"
obj_enterescapepod			= "OBJECTIVE: Catch the Escape Pod"
*/									
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// OBJECTIVES
// -------------------------------------------------------------------------------------------------
// Defines
global real DEF_R_OBJECTIVE_GOTO_OBSERVATION					= 0.1;
global real DEF_R_OBJECTIVE_ACTIVATE_ELEVATOR					= 0.2;
global real DEF_R_OBJECTIVE_ELIMINATE_ENEMY						= 0.3;
global real DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR				= 0.4;
global real DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2					= 0.5;
global real DEF_R_OBJECTIVE_GOTO_ELEVATOR							= 0.6;
global real DEF_R_OBJECTIVE_GET_IN_ELEVATOR						= 0.7;
global real DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS			= 0.8;
global real DEF_R_OBJECTIVE_MANUAL_LAUNCH							= 0.9;
global real DEF_R_OBJECTIVE_REACH_ESCAPE_PODS					= 1.0;
global real DEF_R_OBJECTIVE_EXIT_OUTER_DECK						= 1.1;
global real DEF_R_OBJECTIVE_PRY_POD_DOOR							= 1.2;

// variables
global boolean B_missioncomplete_title_pause					= FALSE;
global boolean B_missioncomplete_end_pause						= TRUE;

// functions
// === f_mission_objective_blip: Blips an objective index
script static boolean f_mission_objective_blip( real r_index, boolean b_blip )
static boolean b_blipped = FALSE;
	// set the default return value
	b_blipped = FALSE;

	//dprint( "::: f_mission_objective_blip :::" );
	inspect( r_index );
	
	//DEF_R_OBJECTIVE_GOTO_OBSERVATION
	if ( r_index == DEF_R_OBJECTIVE_GOTO_OBSERVATION ) then
		b_blipped = TRUE;
		thread (m10_objective_1_nudge());
	end	
	
	
	//DEF_R_OBJECTIVE_ACTIVATE_ELEVATOR	
	if ( r_index == DEF_R_OBJECTIVE_ACTIVATE_ELEVATOR ) then
		if ( b_blip ) then
			f_blip_flag( flg_elevator_ics_door_objective, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_flag( flg_elevator_ics_door_objective );
			b_blipped = TRUE;
		end
		thread (m10_objective_2_nudge());		
		kill_script(m10_objective_1_nudge);
		sleep_forever(m10_objective_1_nudge);
		b_objective_1_complete = TRUE;
	end	
	
	//DEF_R_OBJECTIVE_ELIMINATE_ENEMY
	if ( r_index == DEF_R_OBJECTIVE_ELIMINATE_ENEMY ) then
		thread (m10_objective_3_nudge());		
		kill_script(m10_objective_2_nudge);
		sleep_forever(m10_objective_2_nudge);
		b_objective_2_complete = TRUE;
		end

	//DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR	
	if ( r_index == DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR ) then
		if ( b_blip ) then
			f_blip_object_offset( obs_plinth_control, "default", 0.12 );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( obs_plinth_control );
			b_blipped = TRUE;
		end
		//thread (m10_objective_4_nudge());		
		kill_script(m10_objective_3_nudge);
		sleep_forever(m10_objective_3_nudge);
		b_objective_3_complete = TRUE;
	end	

	//DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2	
	if ( r_index == DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2 ) then
		b_blipped = TRUE;
		thread (m10_objective_5_nudge());		
		kill_script(m10_objective_4_nudge);
		sleep_forever(m10_objective_4_nudge);
		b_objective_4_complete = TRUE;
	end		
	
 	//DEF_R_OBJECTIVE_GOTO_ELEVATOR
 	if ( r_index == DEF_R_OBJECTIVE_GOTO_ELEVATOR ) then
		if ( b_blip ) then
			f_blip_flag( flag_blip_obs_ele, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_flag( flag_blip_obs_ele );
			b_blipped = TRUE;
		end
		thread (m10_objective_6_nudge());		
		kill_script(m10_objective_5_nudge);
		sleep_forever(m10_objective_5_nudge);
		b_objective_5_complete = TRUE;
	end	
	
	//DEF_R_OBJECTIVE_GET_IN_ELEVATOR
 	if ( r_index == DEF_R_OBJECTIVE_GET_IN_ELEVATOR ) then
		if ( b_blip ) then
			f_blip_object( elevator_1_platform, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( elevator_1_platform );
			b_blipped = TRUE;
		end
		thread (m10_objective_7_nudge());		
		kill_script(m10_objective_6_nudge);
		sleep_forever(m10_objective_6_nudge);
		b_objective_6_complete = TRUE;
	end	
	
	 	//DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS
 	if ( r_index == DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS ) then
		if ( b_blip ) then
			f_blip_object( missile_control_switch, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( missile_control_switch );
			b_blipped = TRUE;
		end
		thread (m10_objective_8_nudge());		
		kill_script(m10_objective_7_nudge);
		sleep_forever(m10_objective_7_nudge);
		b_objective_7_complete = TRUE;
	end	
	
 	//DEF_R_OBJECTIVE_BEACON_LAUNCH_START
 	if ( r_index == DEF_R_OBJECTIVE_MANUAL_LAUNCH ) then
		if ( b_blip ) then
			f_blip_object( mag_push_switch, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_object( mag_push_switch );
			b_blipped = TRUE;
		end
		thread (m10_objective_9_nudge());		
		kill_script(m10_objective_8_nudge);
		sleep_forever(m10_objective_8_nudge);
		b_objective_8_complete = TRUE;
	end	
	
 	//DEF_R_OBJECTIVE_BEACON_LAUNCH_ESCAPE
		if ( r_index == DEF_R_OBJECTIVE_REACH_ESCAPE_PODS ) then
		if ( b_blip ) then
			f_blip_flag( flag_airlock_exit, "default" );
			b_blipped = TRUE;
		end
		if ( not b_blip ) then
			f_unblip_flag( flag_airlock_exit );
			b_blipped = TRUE;
		end
		thread (m10_objective_10_nudge());		
		kill_script(m10_objective_9_nudge);
		sleep_forever(m10_objective_9_nudge);
		b_objective_9_complete = TRUE;
	end	
	
	//DEF_R_OBJECTIVE_EXIT_OUTER_DECK
	//if ( r_index == DEF_R_OBJECTIVE_EXIT_OUTER_DECK ) then
		//thread (m10_objective_11_nudge());		
		//end
		
	// return if something was blipped
	b_blipped;

end

// === f_mission_objective_title: Returns the index title title
script static string_id f_mission_objective_title( real r_index )
local string_id sid_return = SID_objective_none;
	
	//DEF_R_OBJECTIVE_GOTO_OBSERVATION
	if ( r_index == DEF_R_OBJECTIVE_GOTO_OBSERVATION ) then
		sid_return = 'obj_observation_deck';
	end	
	
	//DEF_R_OBJECTIVE_ELIMINATE_ENEMY	
	if ( r_index == DEF_R_OBJECTIVE_ELIMINATE_ENEMY ) then
		sid_return = 'obj_eliminate_enemy';
	end		

	//DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR	
	if ( r_index == DEF_R_OBJECTIVE_ACTIVATE_BLAST_DOOR ) then
		sid_return = 'obj_find_override';
	end		 
 	
	//DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2	
	if ( r_index == DEF_R_OBJECTIVE_ELIMINATE_ENEMY_2 ) then
		sid_return = 'obj_eliminate_enemy_2';
	end		
 
	// DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS
	if ( r_index == DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS ) then
		sid_return = 'obj_missile_controls';
	end	
 
 	// DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS
	if ( r_index == DEF_R_OBJECTIVE_MANUAL_LAUNCH ) then
		sid_return = 'obj_manual_release';
	end	
	
	// DEF_R_OBJECTIVE_REACH_ESCAPE_PODS
	if ( r_index == DEF_R_OBJECTIVE_REACH_ESCAPE_PODS ) then
		sid_return = 'obj_escape_pods';
	end	

	
	// return
	sid_return;

end
/*
// === f_objective_mission_missioncomplete::: Handles all the general mission complete
script dormant f_objective_mission_missioncomplete()
static real r_logo_time = 22.0;
static long l_logo_timer = 0;
	dprint( "::: f_objective_mission_missioncomplete :::" );

	//dprint( "::: --- MISSION COMPLETE --- :::" );
	//f_end_mission( 'cinematics\transitions\default_intra.cinematic_transition', '36_hallway_38_vehicle_40_debris' );

	// disable controls, etc
	player_action_test_reset();

	player_enable_input( 0 );
	camera_control( 1 );

	// complete current index
	f_objective_complete( f_objective_current_index(), FALSE, TRUE );

	sleep_until( not B_missioncomplete_title_pause, 1 );

	//fade_out( 1.0, 1.0, 1.0, seconds_to_frames(0.5) );
	//sleep_s( 0.5 );

	// show the screen
	cui_load_screen( 'environments\solo\m10_crash\ui\oyo_title.cui_screen' );
	l_logo_timer = seconds_to_frames(r_logo_time) + game_tick_get();
	
	thread( sys_screenshake_global_intensity_set(0.0, 2.5) );

	// wait for timer to finish or [back] input
	sleep_until( player_action_test_back() or (l_logo_timer <= game_tick_get()), 1 );
		
	// audio mission complete
	sfx_campaign_exit() ;
	sleep_until( not B_missioncomplete_end_pause, 1 );

	//if ( editor_mode() ) then
		//cinematic_transition_fade_out_from_game( 'cinematics\transitions\default_intra.cinematic_transition' );
	//end
	
	//sleep_until( not dialog_active(), 1 );
	//sleep_s( 0.5 );

	// end
	dprint( "::: f_objective_mission_missioncomplete: end_mission :::" );

	hud_show_crosshair( TRUE );
	hud_show_radar( TRUE );
	hud_show_weapon( TRUE );
	
	transition_fov( -1, -1, -1, -1 );
	//render_default_lighting = FALSE;
	
	f_objective_missioncomplete();

end
*/