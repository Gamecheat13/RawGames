//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	atrium (or iat)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CRASH ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean b_atrium_exited = 												FALSE;
global boolean B_atrium_leaving = 											FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_startup::: Startup
script startup f_atrium_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_atrium_startup :::" );

	// init atrium
	wake( f_atrium_init );

end

// === f_atrium_init::: Initialize
script dormant f_atrium_init()
	//dprint( "::: f_atrium_init :::" );

	// setup cleanup
	wake( f_atrium_cleanup );
	
	// wait for init condition
	sleep_until( zoneset_current_active() == S_ZONESET_ATRIUM, 1 );
	
	// init modules
	wake( f_atrium_ai_init );
	wake( f_atrium_narrative_init );
	//wake( f_atrium_audio_init );
	//wake( f_atrium_fx_init );
	
	// init sub modules
	wake( f_atrium_doors_init );
	wake( f_atrium_props_init );
	wake( f_atrium_puppeteers_init );
	
	// setup trigger
	wake( f_atrium_trigger );

end

// === f_atrium_deinit::: Deinitialize
script dormant f_atrium_deinit()
	//dprint( "::: f_atrium_deinit :::" );
	
	// init modules
	wake( f_atrium_ai_deinit );
	wake( f_atrium_narrative_deinit );
	//wake( f_atrium_audio_deinit );
	//wake( f_atrium_fx_deinit );
	
	// deinit sub modules
	wake( f_atrium_doors_deinit );
	wake( f_atrium_props_deinit );
	wake( f_atrium_puppeteers_deinit );

	// kill functions
	kill_script( f_atrium_init );	
	kill_script( f_atrium_trigger );
	kill_script( f_atrium_start );
	kill_script( f_atrium_action );

end

// === f_atrium_cleanup::: Cleanup
script dormant f_atrium_cleanup()
	sleep_until( (zoneset_current_active() > S_ZONESET_ATRIUM_HUB), 1 );
	//dprint( "::: f_atrium_cleanup :::" );

	// Deinitialize
	wake( f_atrium_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_atrium_trigger::: Trigger
script dormant f_atrium_trigger()
	sleep_until( TRUE, 1 );
	//dprint( "::: f_atrium_trigger :::" );

	// Start
	wake( f_atrium_start );

	// wait for the event
	//sleep_until( volume_test_players(tv_atrium_entered_event), 1 );
	wake( f_atrium_action );

end

// === f_atrium_start::: Action
script dormant f_atrium_start()
	//dprint( "::: f_atrium_start :::" );

	// start data mining
	data_mine_set_mission_segment( "m80_Atrium" );

	// fake elevator door close behind you sound
	sound_impulse_start( 'sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_door_close', door_elevator_exit, 1 );

	// set generic atrium
	f_objective_set( DEF_R_OBJECTIVE_ATRIUM(), TRUE, FALSE, FALSE, TRUE );

end

// === f_atrium_action::: Action
script dormant f_atrium_action()
	//dprint( "::: f_atrium_action :::" );
	
	// prep next zone
	//thread( zoneset_prepare(S_ZONESET_ATRIUM_HUB) );

	// wait for dialog to start objective
	sleep_until( 
			dialog_id_played_check( L_dlg_m80_atrium_defenses_offline ) or
			dialog_foreground_id_line_index_check_greater( L_dlg_m80_atrium_defenses_offline, S_dlg_atrium_defenses_offline_objective_line_index )
			or
			(
				dialog_foreground_id_check( L_dlg_m80_atrium_defenses_offline )
				and
				( dialog_foreground_line_index_get() == S_dlg_atrium_defenses_offline_objective_line_index )
				and
				( not IsThreadValid(dialog_foreground_line_thread_get()) )
			)
		, 1 );
	thread( f_objective_set(DEF_R_OBJECTIVE_ATRIUM_EXIT(), TRUE, TRUE, FALSE, TRUE) );

	// wait to unblip the door
	sleep_until( b_atrium_exited, 1 );
	f_objective_blip( DEF_R_OBJECTIVE_ATRIUM_EXIT(), FALSE, FALSE );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
//static long L_atrium_turret_disable_01 = 								0;
//static long L_atrium_turret_disable_02 = 								0;
//static long L_atrium_turret_disable_03 = 								0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_props_init::: Init
script dormant f_atrium_props_init()
	//dprint( "::: f_atrium_props_init :::" );

	// create props	
//	object_create_folder( atrium_mechs );
	object_create_folder( atrium_crates );
	object_create_folder( atrium_scenery );
	object_create_folder( atrium_bipeds ); 

	// animate the prop(s)
	thread( f_object_rotate_bounce_y(cr_atrium_rader_01, 60.0, 6.00, 2.5, 3.0, 0, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_02, 87.5, 8.75, 2.5, 3.0, 0, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_03, 120.0, 12.0, 2.5, 3.0, 0, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_04, 75.0, 7.5, 2.5, 2.5, 1, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_05, 75.0, 7.5, 2.5, 2.5, -1, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_06, 75.0, 7.5, 2.5, 3.0, 0, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );
	thread( f_object_rotate_bounce_y(cr_atrium_rader_07, 120.0, 12.0, 2.5, 3.0, 0, f_sfx_unsc_communication_tower_rotate_start(), f_sfx_unsc_communication_tower_rotate_stop()) );

	// disable turrets
	//L_atrium_turret_disable_01 = thread( f_atrium_turret_enable(turret_atrium_1, FALSE) );
	//L_atrium_turret_disable_02 = thread( f_atrium_turret_enable(turret_atrium_2, FALSE) );
	//L_atrium_turret_disable_03 = thread( f_atrium_turret_enable(turret_atrium_3, FALSE) );
	
end

// === f_atrium_props_deinit::: Deinit
script dormant f_atrium_props_deinit()
	//dprint( "::: f_atrium_props_deinit :::" );

	// destroy props
//	object_destroy_folder( atrium_mechs );
	object_destroy_folder( atrium_crates );
	object_destroy_folder( atrium_scenery );
	object_destroy_folder( atrium_bipeds );
	
	// kill functions
	kill_script( f_atrium_props_init );
	
	// kill threads
	//kill_thread( L_atrium_turret_disable_01 );
	//kill_thread( L_atrium_turret_disable_02 );
	//kill_thread( L_atrium_turret_disable_03 );
	
end

// === f_atrium_props_mech_disable_pilot::: xxx
script static void f_atrium_turret_enable( object_name obj_turret, boolean b_enabled )

	sleep_until( object_valid(obj_turret), 1 );
	//dprint( "::: f_atrium_turret_enable :::" );
	vehicle_set_player_interaction( vehicle(obj_turret), "warthog_g", b_enabled, b_enabled );

end

// === f_object_rotate_bounce_y::: Init
script static void f_object_rotate_bounce_y( object_name obj_object, real r_y_rot, real r_time, real r_pause_min, real r_pause_max, short s_direction, sound snd_start, sound snd_stop )

	// randomize start direction
	if ( s_direction == 0 ) then
		begin_random_count( 1 )
			s_direction = 1;
			s_direction = -1;
		end
	end

	sleep_until( object_valid(obj_object), 1 );
	object_rotate_by_offset( obj_object, r_time * 0.5, 0.0, 0.0, (r_y_rot * 0.5) * s_direction, 0.0, 0.0 );
	s_direction = -s_direction;
	repeat
		sound_impulse_start( snd_start, obj_object, 1.0 );
		object_rotate_by_offset( obj_object, r_time, 0.0, 0.0, r_y_rot * s_direction, 0.0, 0.0 );
		sleep_s( r_pause_min, r_pause_max );
		sound_impulse_start( snd_stop, obj_object, 1.0 );
		s_direction = -s_direction;
	until( not object_valid(obj_object) or (object_get_health(obj_object) <= 0.0), 1 );
	
	// stop it if it's dead
	if ( object_valid(obj_object) ) then
		object_rotate_by_offset( obj_object, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 );
	end

end	



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: PUPPETEERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_puppeteers_init::: Init
script dormant f_atrium_puppeteers_init()
	//dprint( "::: f_atrium_puppeteers_init :::" );
	
	// init sub modules
	wake( f_atrium_puppeteer_mech_01_init );
	wake( f_atrium_puppeteer_mech_02_init );
	wake( f_atrium_puppeteer_mech_03_init );
	wake( f_atrium_puppeteer_mech_04_init );
	
end

// === f_atrium_puppeteers_deinit::: Deinit
script dormant f_atrium_puppeteers_deinit()
	//dprint( "::: f_atrium_puppeteers_deinit :::" );
	
	// init sub modules
	wake( f_atrium_puppeteer_mech_01_deinit );
	wake( f_atrium_puppeteer_mech_02_deinit );
	wake( f_atrium_puppeteer_mech_03_deinit );
	wake( f_atrium_puppeteer_mech_04_deinit );
	
	// kill functions
	kill_script( f_atrium_puppeteers_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: MECH 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_puppeteer_mech_01_init::: Init
script dormant f_atrium_puppeteer_mech_01_init()
	//dprint( "::: f_atrium_puppeteer_mech_01_init :::" );
	
	// setup trigger
	wake( f_atrium_puppeteer_mech_01_trigger );
	
end

// === f_atrium_puppeteer_mech_01_deinit::: Deinit
script dormant f_atrium_puppeteer_mech_01_deinit()
	//dprint( "::: f_atrium_puppeteer_mech_01_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_puppeteer_mech_01_init );
	kill_script( f_atrium_puppeteer_mech_01_trigger );
	kill_script( f_atrium_puppeteer_mech_01_action );
	
end

// === f_atrium_puppeteer_mech_01_trigger::: Trigger
script dormant f_atrium_puppeteer_mech_01_trigger()
	sleep_until( object_valid(bpd_atrium_mech_01), 1 );
	//dprint( "::: f_atrium_puppeteer_mech_01_trigger :::" );
	
	// action
	wake( f_atrium_puppeteer_mech_01_action );
	
end

// === f_atrium_puppeteer_mech_01_action::: Action
script dormant f_atrium_puppeteer_mech_01_action()
local long l_pup_id = -1;
	//dprint( "::: f_atrium_puppeteer_mech_01_action :::" );

	l_pup_id = pup_play_show( 'pup_atrium_mech_01' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: MECH 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_puppeteer_mech_02_init::: Init
script dormant f_atrium_puppeteer_mech_02_init()
	//dprint( "::: f_atrium_puppeteer_mech_02_init :::" );
	
	// setup trigger
	wake( f_atrium_puppeteer_mech_02_trigger );
	
end

// === f_atrium_puppeteer_mech_02_deinit::: Deinit
script dormant f_atrium_puppeteer_mech_02_deinit()
	//dprint( "::: f_atrium_puppeteer_mech_02_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_puppeteer_mech_02_init );
	kill_script( f_atrium_puppeteer_mech_02_trigger );
	kill_script( f_atrium_puppeteer_mech_02_action );
	
end

// === f_atrium_puppeteer_mech_02_trigger::: Trigger
script dormant f_atrium_puppeteer_mech_02_trigger()
	sleep_until( object_valid(bpd_atrium_mech_02), 1 );
	//dprint( "::: f_atrium_puppeteer_mech_02_trigger :::" );
	
	// action
	wake( f_atrium_puppeteer_mech_02_action );
	
end

// === f_atrium_puppeteer_mech_02_action::: Action
script dormant f_atrium_puppeteer_mech_02_action()
local long l_pup_id = -1;
	//dprint( "::: f_atrium_puppeteer_mech_02_action :::" );

	l_pup_id = pup_play_show( 'pup_atrium_mech_02' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: MECH 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global string STR_atrium_mech_look_requested = "";
global string STR_atrium_mech_look_direction = "";

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_puppeteer_mech_03_init::: Init
script dormant f_atrium_puppeteer_mech_03_init()
	//dprint( "::: f_atrium_puppeteer_mech_03_init :::" );
	
	// setup trigger
	wake( f_atrium_puppeteer_mech_03_trigger );
	
end

// === f_atrium_puppeteer_mech_03_deinit::: Deinit
script dormant f_atrium_puppeteer_mech_03_deinit()
	//dprint( "::: f_atrium_puppeteer_mech_03_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_puppeteer_mech_03_init );
	kill_script( f_atrium_puppeteer_mech_03_trigger );
	kill_script( f_atrium_puppeteer_mech_03_action );
	
end

// === f_atrium_puppeteer_mech_03_trigger::: Trigger
script dormant f_atrium_puppeteer_mech_03_trigger()
	sleep_until( object_valid(bpd_atrium_mech_03), 1 );
	//dprint( "::: f_atrium_puppeteer_mech_03_trigger :::" );
	
	// action
	wake( f_atrium_puppeteer_mech_03_action );
	
end

// === f_atrium_puppeteer_mech_03_action::: Action
script dormant f_atrium_puppeteer_mech_03_action()
local long l_pup_id = -1;
	//dprint( "::: f_atrium_puppeteer_mech_03_action :::" );

	l_pup_id = pup_play_show( 'pup_atrium_mech_03' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: MECH 04
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_atrium_mech_04_move_chance = 						25.00;
global real R_atrium_mech_04_animate_chance = 				31.25;
global real R_atrium_mech_04_animate_again_chance = 	25.00;
global boolean B_atrium_mech_04_first_walk = 					TRUE;
global string STR_atrium_mech_04_last_facing = 					"NONE";

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_puppeteer_mech_04_init::: Init
script dormant f_atrium_puppeteer_mech_04_init()
	//dprint( "::: f_atrium_puppeteer_mech_04_init :::" );
	
	// setup trigger
	wake( f_atrium_puppeteer_mech_04_trigger );
	
end

// === f_atrium_puppeteer_mech_04_deinit::: Deinit
script dormant f_atrium_puppeteer_mech_04_deinit()
	//dprint( "::: f_atrium_puppeteer_mech_04_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_puppeteer_mech_04_init );
	kill_script( f_atrium_puppeteer_mech_04_trigger );
	kill_script( f_atrium_puppeteer_mech_04_action );
	
end

// === f_atrium_puppeteer_mech_04_trigger::: Trigger
script dormant f_atrium_puppeteer_mech_04_trigger()
	sleep_until( object_valid(bpd_atrium_mech_04), 1 );
	//dprint( "::: f_atrium_puppeteer_mech_04_trigger :::" );
	
	// action
	wake( f_atrium_puppeteer_mech_04_action );
	
end

// === f_atrium_puppeteer_mech_04_action::: Action
script dormant f_atrium_puppeteer_mech_04_action()
local long l_pup_id = -1;
	//dprint( "::: f_atrium_puppeteer_mech_04_action :::" );

	l_pup_id = pup_play_show( 'pup_atrium_mech_04' );
	sleep_until( not pup_is_playing(l_pup_id), 1 );
	
end

// === f_atrium_puppeteer_mech_04_move::: Action
script static boolean f_atrium_puppeteer_mech_04_move()
static boolean b_condition = FALSE;

	if ( not b_condition ) then
		b_condition = b_atrium_shuttle_destroyed or ( objects_distance_to_object(players(), bpd_atrium_mech_04) <= 5.0 );
	end

	// RETURN
	b_condition and ( not ai_allegiance_broken(player, human) );

end

// === f_atrium_puppeteer_mech_04_at_start::: Action
script static boolean f_atrium_puppeteer_mech_04_at_start()
	objects_distance_to_flag( bpd_atrium_mech_04, flg_atrium_mech_04_start ) <= 7.5;
end

// === f_atrium_puppeteer_mech_04_chance_animate::: Action
script static boolean f_atrium_puppeteer_mech_04_chance_animate( real r_chance, string str_direction )
	(STR_atrium_mech_04_last_facing != str_direction) and f_chance(r_chance);
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_doors_init::: Init
script dormant f_atrium_doors_init()
	//dprint( "::: f_atrium_doors_init :::" );
	
	// init sub modules
	wake( f_atrium_door_start_init );
	wake( f_atrium_door_enter_init );
	wake( f_atrium_door_exit_init );
	
end

// === f_atrium_doors_deinit::: Deinit
script dormant f_atrium_doors_deinit()
	//dprint( "::: f_atrium_doors_deinit :::" );

	// deinit sub modules
	wake( f_atrium_door_start_deinit );
	wake( f_atrium_door_enter_deinit );
	wake( f_atrium_door_exit_deinit );
	
	// kill functions
	kill_script( f_atrium_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOOR: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_door_start_init::: Init
script dormant f_atrium_door_start_init()
	//dprint( "::: f_atrium_door_start_init :::" );

	// init sub modules
	wake( f_atrium_door_start_left_init );
	wake( f_atrium_door_start_right_init );
	
end

// === f_atrium_door_start_deinit::: Deinit
script dormant f_atrium_door_start_deinit()
	//dprint( "::: f_atrium_door_start_deinit :::" );

	// init sub modules
	wake( f_atrium_door_start_left_deinit );
	wake( f_atrium_door_start_right_deinit );
	
	// kill functions
	kill_script( f_atrium_door_start_init );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOOR: START: LEFT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_door_start_left_init::: Init
script dormant f_atrium_door_start_left_init()
	//dprint( "::: f_atrium_door_start_left_init :::" );
	
	// setup trigger
	wake( f_atrium_door_start_left_trigger );
	
end

// === f_atrium_door_start_left_deinit::: Deinit
script dormant f_atrium_door_start_left_deinit()
	//dprint( "::: f_atrium_door_start_left_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_door_start_left_init );
	kill_script( f_atrium_door_start_left_trigger );
	
end

// === f_atrium_door_start_left_trigger::: Trigger
script dormant f_atrium_door_start_left_trigger()
local boolean b_jittering = FALSE;
	sleep_until( object_valid(door_mechroom_interior_left) and object_active_for_script(door_mechroom_interior_left), 1 );
	//dprint( "::: f_atrium_door_start_left_trigger :::" );

	// setup jitter ranges
	door_mechroom_interior_left->speed_open( 5.0 );
	door_mechroom_interior_left->blend_setup( 1.0, 0.25 );
	door_mechroom_interior_left->jitter_open_range_setup( 0.20, 0.25 );
	door_mechroom_interior_left->jitter_close_range_setup( 0.0, 0.1 );
	door_mechroom_interior_left->jitter_delay_range_setup( 0.5, 1.0 );

	repeat
		if ( not b_jittering ) then
			door_mechroom_interior_left->close();
		end
	
		sleep_until( door_mechroom_interior_left->distance_check(Players(), door_mechroom_interior_left, -2.5) != b_jittering, 1 );
		
		// toggle jitter
		b_jittering = not b_jittering;
		
		// jitter	
		door_mechroom_interior_left->jitter_enabled( b_jittering );
		
	until( not object_valid(door_mechroom_interior_left) and not object_active_for_script(door_mechroom_interior_left), 1 );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOOR: START: RIGHT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_door_start_right_init::: Init
script dormant f_atrium_door_start_right_init()
	sleep_until( object_valid(door_mechroom_interior_right) and object_active_for_script(door_mechroom_interior_right), 1 );
	//dprint( "::: f_atrium_door_start_right_init :::" );
	
	// open
	door_mechroom_interior_right->auto_distance_open( -2.5, FALSE );
	
end

// === f_atrium_door_start_right_deinit::: Deinit
script dormant f_atrium_door_start_right_deinit()
	//dprint( "::: f_atrium_door_start_right_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_door_start_right_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOOR: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_door_enter_init::: Init
script dormant f_atrium_door_enter_init()
	sleep_until( object_valid(door_mechroom_exit) and object_active_for_script(door_mechroom_exit), 1 );
	//dprint( "::: f_atrium_door_enter_init :::" );

	// setup auto disable	
	thread( door_mechroom_exit->auto_enabled_zoneset(FALSE, S_ZONESET_ATRIUM_HUB, -1) );

	// open
	door_mechroom_exit->auto_distance_open( -6.5, FALSE );

	// close
	door_mechroom_exit->zoneset_auto_close_setup( S_ZONESET_ATRIUM_HUB, TRUE, FALSE, -1, S_ZONESET_ATRIUM_HUB, TRUE );
	door_mechroom_exit->auto_trigger_close_all_out( tv_atrium_enter_door_close_out, TRUE );

	// force closed
	door_mechroom_exit->close_immediate();

end

// === f_atrium_door_enter_deinit::: Deinit
script dormant f_atrium_door_enter_deinit()
	//dprint( "::: f_atrium_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_door_enter_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_door_exit_init::: Init
script dormant f_atrium_door_exit_init()
	sleep_until( object_valid(door_atrium_exit_maya) and object_active_for_script(door_atrium_exit_maya), 1 );
	//dprint( "::: f_atrium_door_exit_init :::" );

	// wait for exit objective
	sleep_until( f_objective_blipped_check(DEF_R_OBJECTIVE_ATRIUM_EXIT()), 1 );

	// setup auto disable	
	thread( door_atrium_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_TO_AIRLOCK_ONE, -1) );

	// open
	door_atrium_exit_maya->zoneset_auto_open_setup( S_ZONESET_ATRIUM_HUB, TRUE, TRUE, -1, S_ZONESET_ATRIUM_HUB, TRUE );
	door_atrium_exit_maya->auto_distance_open( -4.5, FALSE );

	// set leaving	
	B_atrium_leaving = TRUE;
	
	// close
	door_atrium_exit_maya->zoneset_auto_close_setup( S_ZONESET_TO_AIRLOCK_ONE, TRUE, FALSE, -1, S_ZONESET_TO_AIRLOCK_ONE, TRUE );
	door_atrium_exit_maya->auto_trigger_close_all_in( tv_atrium_exit_door_close_in, TRUE );

	// finished
	b_atrium_exited = TRUE;

	// force closed
	door_atrium_exit_maya->close_immediate();
	
	// cleanup atirum
	wake( f_atrium_deinit );
	
end

// === f_atrium_door_exit_deinit::: Deinit
script dormant f_atrium_door_exit_deinit()
	//dprint( "::: f_atrium_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_atrium_door_exit_init );
	
end
