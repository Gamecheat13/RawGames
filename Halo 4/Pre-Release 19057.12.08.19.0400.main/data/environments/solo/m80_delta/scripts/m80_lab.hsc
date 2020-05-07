//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_lab (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** LAB ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
//global boolean b_keep_looping_idle_anim = TRUE;
//global boolean b_player0_underneath = FALSE;
//global boolean b_player1_underneath = FALSE;
//global boolean b_player2_underneath = FALSE;
//global boolean b_player3_underneath = FALSE;
//global short s_player0_location = -1;
//global short s_player1_location = -1;
//global short s_player2_location = -1;
//global short s_player3_location = -1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_startup::: Startup
script startup f_lab_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_lab_startup :::" );

	// init lab
	wake( f_lab_init );

end

// === f_lab_init::: Initialize
script dormant f_lab_init()
	//dprint( "::: f_lab_init :::" );

	// setup cleanup
	wake( f_lab_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current_active() >= S_ZONESET_TO_LAB) and (zoneset_current_active() <= S_ZONESET_LAB), 1 );
	
	// init modules
	wake( f_lab_ai_init );
	wake( f_lab_narrative_init );
	//wake( f_lab_audio_init );
	wake( f_lab_fx_init );
	
	// init sub modules
	wake( f_lab_doors_init );
	wake( f_lab_props_init );
	wake( f_lab_control_init );
	wake( f_lab_puppeteers_init );
	wake( f_lab_checkpoints_init );
	
	// setup trigger
	wake( f_lab_trigger );

end

// === f_lab_deinit::: Deinitialize
script dormant f_lab_deinit()
	//dprint( "::: f_lab_deinit :::" );

	// deinit modules
	wake( f_lab_ai_deinit );
	wake( f_lab_narrative_deinit );
	//wake( f_lab_audio_deinit );
	wake( f_lab_fx_deinit );
	
	// deinit sub modules
	wake( f_lab_doors_deinit );
	wake( f_lab_props_deinit );
	wake( f_lab_control_deinit );
	wake( f_lab_puppeteers_deinit );
	wake( f_lab_checkpoints_deinit );

	// kill functions
	kill_script( f_lab_init );
	kill_script( f_lab_trigger );
	kill_script( f_lab_action_start );
	kill_script( f_lab_action_complete );

end

// === f_lab_cleanup::: Cleanup
script dormant f_lab_cleanup()
	sleep_until( zoneset_current() > S_ZONESET_LAB_EXIT, 1 );
	//dprint( "::: f_lab_cleanup :::" );

	// Deinitialize
	wake( f_lab_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_lab_trigger::: Trigger
script dormant f_lab_trigger()
	//dprint( "::: f_lab_trigger :::" );

	// start data mining
	sleep_until( zoneset_current_active() >= S_ZONESET_TO_LAB, 1 );
	if ( zoneset_current() == S_ZONESET_TO_LAB ) then
		data_mine_set_mission_segment( "m80_ToLab" );
	end
	
	// checkpoint
	if ( zoneset_current() < S_ZONESET_LAB ) then 
		checkpoint_no_timeout( TRUE, "f_lab_trigger: TO LAB" );
	end

	// wait for lab to start
	sleep_until( f_lab_started(), 1 );
	wake( f_lab_action_start );

	// entered
	sleep_until( f_lab_entered(), 1 );
	f_objective_blip( DEF_R_OBJECTIVE_LAB_ENTER(), TRUE );

	// wait for lab to be completed
	sleep_until( f_lab_completed(), 1 );
	wake( f_lab_action_complete );

end

// === f_lab_action_start::: Action
script dormant f_lab_action_start()
	//dprint( "::: f_lab_action_start :::" );

	// start data mining
	data_mine_set_mission_segment( "m80_Lab" );
	
	// start music
	thread( f_mus_m80_e02_begin() );
	
	// checkpoint
	checkpoint_no_timeout( TRUE, "f_lab_trigger: LAB" );

end

// === f_lab_action_complete::: Action
script dormant f_lab_action_complete()
	//dprint( "::: f_lab_action_complete :::" );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_lab_action_complete" );
	
	// prepare next zone
	zoneset_prepare( S_ZONESET_LAB_EXIT );
	
	// narrative
	wake( m80_prelab_door_controls );

	// start objective
	f_objective_set( DEF_R_OBJECTIVE_LAB_CONTROL(), TRUE, FALSE, FALSE, TRUE );

	// wait to blip
	sleep_until( 
			dialog_id_played_check( L_dlg_prelab_door_controls )
			or
			dialog_foreground_id_line_index_check_greater_equel( L_dlg_prelab_door_controls, S_dlg_prelab_door_controls_objective_line_index )
			or
			( device_get_power(dc_lab_exit) == 1.0 )
		, 1 );
	f_objective_blip( DEF_R_OBJECTIVE_LAB_CONTROL(), TRUE, FALSE );

	// end music
	thread( f_mus_m80_e02_finish() );

end

// === f_lab_started::: Checks if the lab sequence was started
script static boolean f_lab_started()
static boolean b_started = FALSE;

	if ( (not b_started) and object_valid(dm_lab_door) and object_active_for_script(dm_lab_door) ) then
		b_started = not dm_lab_door->position_close_check();
	end

	// return
	b_started;

end

// === f_lab_entered::: Checks if the lab sequence was entered
script static boolean f_lab_entered()
static boolean b_entered = FALSE;

	if ( not b_entered ) then
		b_entered = volume_test_players( tv_lab_entered );
	end

	// return
	b_entered;

end

// === f_lab_completed::: Checks if the lab sequence was completed
script static boolean f_lab_completed()
static boolean b_completed = FALSE;

	if ( not b_completed ) then
		b_completed = f_ai_is_defeated( sg_lab_hunters );
	end

	// return
	b_completed;

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_props_init::: Init
script dormant f_lab_props_init()
	//dprint( "::: f_lab_props_init :::" );
	
	// init sub modules
	wake( f_lab_props_to_lab_init );
	wake( f_lab_props_lab_init );
	
end

// === f_lab_props_deinit::: Deinit
script dormant f_lab_props_deinit()
	//dprint( "::: f_lab_props_deinit :::" );
	
	// init sub modules
	wake( f_lab_props_to_lab_deinit );
	wake( f_lab_props_lab_deinit );
	
	// kill functions
	kill_script( f_lab_props_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PROPS: TO LAB
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_props_to_lab_init::: Init
script dormant f_lab_props_to_lab_init()
	sleep_until( zoneset_current_active() >= S_ZONESET_TO_LAB, 1 );
	//dprint( "::: f_lab_props_to_lab_init :::" );

	object_create_folder( 'crates_to_lab' );
	object_create_folder( 'equipment_to_lab' );
	object_create_folder( 'weapons_to_lab' );
		
end

// === f_lab_props_to_lab_deinit::: Deinit
script dormant f_lab_props_to_lab_deinit()
	//dprint( "::: f_lab_props_to_lab_deinit :::" );

	object_destroy_folder( 'crates_to_lab' );
	
	// kill functions
	kill_script( f_lab_props_to_lab_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PROPS: LAB
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_props_lab_init::: Init
script dormant f_lab_props_lab_init()
	sleep_until( zoneset_current_active() == S_ZONESET_LAB, 1 );
	//dprint( "::: f_lab_props_lab_init :::" );

	object_create_folder( 'crates_lab' );
	object_create_folder( 'weapons_lab' );
		
end

// === f_lab_props_lab_deinit::: Deinit
script dormant f_lab_props_lab_deinit()
	//dprint( "::: f_lab_props_lab_deinit :::" );

	object_destroy_folder( 'crates_lab' );
	
	// kill functions
	kill_script( f_lab_props_lab_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PUPPETEERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_lab_puppeteers_init::: Init
script dormant f_lab_puppeteers_init()
	//dprint( "::: f_lab_puppeteers_init :::" );
	
	// init sub modules
	wake( f_lab_puppeteer_start_init );
	wake( f_lab_puppeteer_end_init );
	
end

// === f_lab_puppeteers_deinit::: Deinit
script dormant f_lab_puppeteers_deinit()
	//dprint( "::: f_lab_puppeteers_deinit :::" );
	
	// init sub modules
	wake( f_lab_puppeteer_start_deinit );
	wake( f_lab_puppeteer_end_deinit );
	
	// kill functions
	kill_script( f_lab_puppeteers_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PUPPETEER: START
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_lab_scientist_01_pup_health 			= 0.0;
global real R_lab_scientist_02_pup_health 			= 0.0;
global real R_lab_scientist_03_pup_health 			= 0.0;
global real R_lab_scientist_04_pup_health 			= 0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_lab_puppeteer_start_init::: Init
script dormant f_lab_puppeteer_start_init()
	//dprint( "::: f_lab_puppeteer_start_init :::" );
	
	// setup trigger
	wake( f_lab_puppeteer_start_trigger );
	
end

// === f_lab_puppeteer_start_deinit::: Deinit
script dormant f_lab_puppeteer_start_deinit()
	//dprint( "::: f_lab_puppeteer_start_deinit :::" );
	
	// kill functions
	kill_script( f_lab_puppeteer_start_init );
	kill_script( f_lab_puppeteer_start_trigger );
//	kill_script( f_lab_puppeteer_start_action );
	
end

// === f_lab_puppeteer_start_trigger::: Trigger
script dormant f_lab_puppeteer_start_trigger()
local long l_pup_id = -1;
	//dprint( "::: f_lab_puppeteer_start_trigger :::" );
	
	// action
	sleep_until( f_lab_started() and (ai_spawn_count(sq_lab_scientists) > 0) and (ai_spawn_count(sq_lab_security_01) > 0) and (ai_spawn_count(sq_lab_security_02) > 0), 1 );
	l_pup_id = pup_play_show( 'pup_lab_scientist_flee' );
	
	// wait until it's done
	sleep_until( not pup_is_playing(l_pup_id) or f_lab_completed() or ai_allegiance_broken(player, human), 1 );
	pup_stop_show( l_pup_id );
//	wake( f_lab_puppeteer_start_action );
	
end
/*
// === f_lab_puppeteer_start_action::: Action
script dormant f_lab_puppeteer_start_action()
	//dprint( "::: f_lab_puppeteer_start_action :::" );

	// set allegiance
	//ai_allegiance( player, human );

	l_pup_id = pup_play_show( 'pup_lab_scientist_flee' );
	sleep_until( not pup_is_playing(l_pup_id) or f_lab_completed() or ai_allegiance_broken(player, human), 1 );
	pup_stop_show( l_pup_id );
	//dprint( "::: f_lab_puppeteer_start_action: END :::" );
	
	// check if we need to kill this show
	//if ( pup_is_playing(l_pup_id) ) then
		//dprint( "::: f_lab_puppeteer_start_action: FORCE KILL :::" );
	//end
	
end
*/
script static boolean f_lab_puppeteer_flee_scientist_exit( object obj_scientist, real r_health )
	( object_get_health(obj_scientist) < r_health )
	or
	not f_atrium_marine_ready_pistol( object_get_ai(obj_scientist) )
	//( objects_distance_to_object( Players(), obj_scientist ) <=0.5 )
	or
	(
		( ai_living_count(sg_lab_hunters) > 0 )
		and
		( objects_distance_to_object(ai_actors(sg_lab_hunters), obj_scientist) <= 1.0 )
	);
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: PUPPETEER: END
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object OBJ_lab_puppet_security_01 = 			NONE;
global object OBJ_lab_puppet_security_02 = 			NONE;
global object OBJ_lab_puppet_security_03 = 			NONE;
global object OBJ_lab_puppet_scientist_01 = 		NONE;
global object OBJ_lab_puppet_scientist_02 = 		NONE;
global object OBJ_lab_puppet_scientist_03 = 		NONE;
global object OBJ_lab_puppet_scientist_04 = 		NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_lab_puppeteer_end_init::: Init
script dormant f_lab_puppeteer_end_init()
	//dprint( "::: f_lab_puppeteer_end_init :::" );
	
	// setup trigger
	wake( f_lab_puppeteer_end_trigger );
	
end

// === f_lab_puppeteer_end_deinit::: Deinit
script dormant f_lab_puppeteer_end_deinit()
	//dprint( "::: f_lab_puppeteer_end_deinit :::" );
	
	// kill functions
	kill_script( f_lab_puppeteer_end_init );
	kill_script( f_lab_puppeteer_end_trigger );
	kill_script( f_lab_puppeteer_end_action );
	
end

// === f_lab_puppeteer_end_trigger::: Trigger
script dormant f_lab_puppeteer_end_trigger()
	sleep_until( f_lab_completed(), 1 );
	//dprint( "::: f_lab_puppeteer_end_trigger :::" );
	
	// action
	wake( f_lab_puppeteer_end_action );
	
end

// === f_lab_puppeteer_end_action::: Action
script dormant f_lab_puppeteer_end_action()
local short s_living_cnt = 0;
	
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_security_01.01, 'pup_lab_complete_security_01_pistol', 'pup_lab_complete_security_01_rifle') );
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_security_01.02, 'pup_lab_complete_security_02_pistol', 'pup_lab_complete_security_02_rifle') );
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_security_02.01, 'pup_lab_complete_security_03_pistol', 'pup_lab_complete_security_03_rifle') );

	thread( f_lab_puppeteer_end_puppeteer(sq_lab_scientists.01, 'pup_lab_complete_scientist_01_pistol', 'pup_lab_complete_scientist_01_rifle') );
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_scientists.02, 'pup_lab_complete_scientist_02_pistol', 'pup_lab_complete_scientist_02_rifle') );
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_scientists.03, 'pup_lab_complete_scientist_03_pistol', 'pup_lab_complete_scientist_03_rifle') );
	thread( f_lab_puppeteer_end_puppeteer(sq_lab_scientists.04, 'pup_lab_complete_scientist_04_pistol', 'pup_lab_complete_scientist_04_rifle') );

end

script static void f_lab_puppeteer_end_puppeteer( ai ai_puppet, string_id sid_pup_pistol, string_id sid_pup_rifle )
local boolean b_has_pistol = FALSE;
local long l_pup_id = -1;
local long l_timer = timer_stamp( 3.0 );

	// short delay
	sleep_s( 0.5, 1.5 );
	
	// force low vitality
//	unit_set_maximum_vitality( ai_puppet, object_get_maximum_vitality(ai_puppet, FALSE) * 0.1375, 0.0 );
	unit_set_maximum_vitality( ai_puppet, object_get_maximum_vitality(ai_puppet, FALSE) * 0.5, 0.0 );
	unit_set_current_vitality( ai_puppet, object_get_maximum_vitality(ai_puppet, FALSE), 0.0 );
	
	repeat

		// face the player
		cs_face_player( ai_puppet, TRUE );

		sleep_until( not ai_allegiance_broken(player, human) and (object_get_recent_body_damage(ai_puppet) <= 0.0), 1 );
	
		// face the door
		cs_face( ai_puppet, TRUE, ps_pup_lab_complete.door );

		// check weapon
		b_has_pistol = f_atrium_marine_ready_pistol( ai_puppet );
		
		// play show
		if ( b_has_pistol ) then
			l_pup_id = pup_play_show( sid_pup_pistol );
		else
			l_pup_id = pup_play_show( sid_pup_rifle );
		end
	
		// wait
		sleep_until( (pup_is_playing(l_pup_id) == FALSE) or ai_allegiance_broken(player, human) or (object_get_recent_body_damage(ai_puppet) > 0.0) or (b_has_pistol != f_atrium_marine_ready_pistol(ai_puppet)), 1 );
		
		// check if we need to kill this show
		if ( pup_is_playing(l_pup_id) ) then
			pup_stop_show( l_pup_id );
		end


	until( unit_get_health(ai_puppet) <= 0.0, 1 );

	//dprint( "f_lab_puppeteer_end_puppeteer: eee" );
	if ( timer_expired(l_timer) and (ai_living_count(sg_lab_humans) > 0) ) then
		dprint( "f_lab_puppeteer_end_puppeteer: FORCE ALLEGIANCE BREAK" );
		repeat
			ai_allegiance_break( 'player', 'human' );
		until( ai_allegiance_broken(player, human) or (ai_living_count(sg_lab_humans) <= 0), 1 );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: CONTROLS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_lab_control_pup = 					-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_control_init::: Init
script dormant f_lab_control_init()
	sleep_until( object_valid(dc_lab_exit), 1 );
	//dprint( "::: f_lab_control_init :::" );
	
	// initialize off
	device_set_position_immediate( dc_lab_exit, 1.0 );
	device_set_power( dc_lab_exit, 0.0 );
	
end

// === f_lab_control_deinit::: Deinit
script dormant f_lab_control_deinit()
	//dprint( "::: f_lab_control_deinit :::" );
	
	// kill functions
	kill_script( f_lab_control_init );
	kill_script( f_lab_control_exit_action );
	
end

// === f_lab_control_exit_action::: Button pressed
script static void f_lab_control_exit_action( object obj_control, unit u_activator )
	//dprint( "::: f_lab_control_exit_action :::" );

	// unblip
	f_objective_blip( DEF_R_OBJECTIVE_LAB_CONTROL(), FALSE, FALSE );
	
	// play the button press
	p_player_puppet = u_activator;
	L_lab_control_pup = pup_play_show( 'pup_lab_button' );
	sleep_until( not pup_is_playing(L_lab_control_pup), 1 );

end

// === f_lab_control_deinit::: Deinit
script static void f_lab_control_pressed()

	// cinematic
	fade_out( 0, 0, 0, seconds_to_frames(1.25) );
	sleep_s( 1.25 );
	if ( pup_is_playing(L_lab_control_pup) ) then
		pup_stop_show( L_lab_control_pup );
	end
	thread( ins_cine_82() );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: CHECKPOINTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_checkpoints_init::: Init
script dormant f_lab_checkpoints_init()
	//dprint( "::: f_lab_checkpoints_init :::" );
	
	// setup trigger
	wake( f_lab_checkpoints_trigger );
	
end

// === f_lab_checkpoints_deinit::: Deinit
script dormant f_lab_checkpoints_deinit()
	//dprint( "::: f_lab_checkpoints_deinit :::" );
	
	// kill functions
	kill_script( f_lab_checkpoints_init );
	kill_script( f_lab_checkpoints_trigger );
	
end
	
// === f_lab_checkpoints_trigger::: Trigger
script dormant f_lab_checkpoints_trigger()
local long l_checkpoint_thread = 0;
local short s_hunter_cnt = 0;
	//dprint( "::: f_lab_checkpoints_trigger :::" );

	// wait for some hunters to start
	sleep_until( ai_spawn_count(sg_lab_hunters) > 0, 1 );
	
	repeat
	
		if ( ai_living_count(sg_lab_hunters) > 0 ) then
			// store hunter living count
			s_hunter_cnt = ai_living_count( sg_lab_hunters );
			
			// wait for the living count to change
			sleep_until( s_hunter_cnt != ai_living_count(sg_lab_hunters), 1 );
			
			// checkpoint
			checkpoint_no_timeout( TRUE, "f_lab_checkpoints_trigger" );

		end
		
	until ( ai_living_count(sg_lab_hunters) <= 0, 1 );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_doors_init::: Init
script dormant f_lab_doors_init()
	//dprint( "::: f_lab_doors_init :::" );
	
	// init sub modules
	wake( f_lab_door_enter_init );
	
end

// === f_lab_doors_deinit::: Deinit
script dormant f_lab_doors_deinit()
	//dprint( "::: f_lab_doors_deinit :::" );

	// deinit sub modules
	wake( f_lab_door_enter_deinit );
	
	// kill functions
	kill_script( f_lab_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: DOOR: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_door_enter_init::: Init
script dormant f_lab_door_enter_init()
	sleep_until( object_valid(dm_lab_door) and object_active_for_script(dm_lab_door), 1 );
	//dprint( "::: f_lab_door_enter_init :::" );

	// setup auto disable	
	thread( dm_lab_door->auto_enabled_zoneset(FALSE, S_ZONESET_LAB_EXIT, -1) );

	// open
	dm_lab_door->zoneset_auto_open_setup( S_ZONESET_LAB, TRUE, TRUE, -1, S_ZONESET_LAB, TRUE );
	dm_lab_door->auto_distance_open( -5.0, FALSE );
	f_objective_set_timer_reminder( DEF_R_OBJECTIVE_LAB_ENTER(), TRUE, FALSE, FALSE, TRUE );

	// close
	dm_lab_door->auto_trigger_close_all_in( tv_lab_door_enter_close_in, TRUE );

	// complete the enter objective
	f_objective_complete( DEF_R_OBJECTIVE_LAB_ENTER(), FALSE, TRUE );

	// force closed
	dm_lab_door->close_immediate();
	
end

// === f_lab_door_enter_deinit::: Deinit
script dormant f_lab_door_enter_deinit()
	//dprint( "::: f_lab_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_lab_door_enter_init );
	
end
