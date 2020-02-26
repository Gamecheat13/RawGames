//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_airlocks (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AIRLOCKS: TWO ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_airlock_index = 														2;
global short S_airlock_two_complete_cnt = 								0;

global short S_airlock_two_01_state = 										DEF_S_AIRLOCK_STATE_INIT;
global short S_airlock_two_02_state = 										DEF_S_AIRLOCK_STATE_INIT;
global short S_airlock_two_03_state = 										DEF_S_AIRLOCK_STATE_INIT;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static void debug_airlock_two_state()
	
	dprint( "------------------------------------------" );
	dprint( "debug_airlock_two_state ------------------" );
	dprint( "S_airlock_two_01_state: STATE" );
	inspect( S_airlock_two_01_state );
	dprint( "S_airlock_two_02_state: STATE" );
	inspect( S_airlock_two_02_state );
	dprint( "S_airlock_two_03_state: STATE" );
	inspect( S_airlock_two_03_state );
	dprint( "     " );

	dprint( "f_airlocks_two_started() ------------------" );
	dprint( "f_airlocks_two_started(): STATE" );
	inspect( f_airlocks_two_started() );
	dprint( "     " );

	dprint( "f_airlocks_two_entered() ------------------" );
	dprint( "f_airlocks_two_entered(): STATE" );
	inspect( f_airlocks_two_entered() );
	dprint( "     " );

	dprint( "f_airlocks_two_bays_finished() ------------" );
	dprint( "f_airlocks_two_bays_finished(): STATE" );
	inspect( f_airlocks_two_bays_finished() );
	dprint( "     " );

	dprint( "f_airlocks_two_finished() -----------------" );
	dprint( "f_airlocks_two_finished(): STATE" );
	inspect( f_airlocks_two_finished() );
	dprint( "     " );

	dprint( "complete conditions -----------------" );
	dprint( "ai_living_count(sg_airlock_two_units): CNT" );
	inspect( ai_living_count(sg_airlock_two_units) );
	dprint( "ai_living_count(sq_airlock_two_bay_02_02e): CNT" );
	inspect( ai_living_count(sq_airlock_two_bay_02_02e) );
	
	// blip AI so we can identify the problems
	f_blip_ai( sg_airlock_two_units, "DEFAULT" );
	
	dprint( "------------------------------------------" );
	
end

// === f_airlocks_two_init::: Initialize
script dormant f_airlocks_two_init()
	//dprint( "::: f_airlocks_two_init :::" );
	
	// setup cleanup
	wake( f_airlocks_two_cleanup );
	
	// wait for init condition
	sleep_until( zoneset_current_active() == S_ZONESET_AIRLOCK_TWO, 1 );
	
	// init sub modules
	wake( f_airlocks_two_doors_init );
	wake( f_airlocks_two_props_init );
	wake( f_airlocks_two_gravity_init );
	
	// init modules
	wake( f_airlocks_two_ai_init ); 
	
	// setup trigger
	wake( f_airlocks_two_trigger );

end

// === f_airlocks_two_deinit::: Deinitialize
script dormant f_airlocks_two_deinit()
	//dprint( "::: f_airlocks_two_deinit :::" );
	
	// reset airlocks index
	if ( f_airlocks_current_index_get() == S_airlock_index ) then
		f_airlocks_current_index_set( 0 );
	end
	
	// deinit modules
	wake( f_airlocks_two_ai_deinit );
	
	// init sub modules
	wake( f_airlocks_two_doors_deinit );
	wake( f_airlocks_two_props_deinit );
	wake( f_airlocks_two_gravity_deinit );

	// kill functions
	kill_script( f_airlocks_two_init );
	kill_script( f_airlocks_two_trigger );
	kill_script( f_airlocks_two_action_start );
	kill_script( f_airlocks_two_action_complete );
	kill_script( f_airlocks_two_action_start_bay_01 );
	kill_script( f_airlocks_two_action_start_bay_02 );
	kill_script( f_airlocks_two_action_start_bay_03 );

end

// === f_airlocks_two_cleanup::: Cleanup
script dormant f_airlocks_two_cleanup()
	sleep_until( (zoneset_current() > S_ZONESET_TO_LOOKOUT), 1 );
	//dprint( "::: f_airlocks_two_cleanup :::" );

	// Deinitialize
	wake( f_airlocks_two_deinit );

end

// === f_airlocks_two_trigger::: Trigger
script dormant f_airlocks_two_trigger()
	//dprint( "::: f_airlocks_two_trigger :::" );
	
	// start
	sleep_until( f_airlocks_two_started(), 1 );	
	wake( f_airlocks_two_action_start );

	// partial complete
	sleep_until( f_airlocks_two_bays_finished() and (ai_living_count(sg_airlock_two_units) <= 3) and ((ai_living_count(sq_airlock_two_bay_02_02e) <= 0) or (not unit_has_equipment(sq_airlock_two_bay_02_02e.elite_01, "objects\equipment\storm_active_camo\storm_active_camo.equipment"))), 1 );	
	wake( f_airlocks_two_action_complete );

end

// === f_airlocks_two_action_start::: Starts the airlock area
script dormant f_airlocks_two_action_start()
	//dprint( "::: f_airlocks_two_action_start :::" );
	
	// set datamining
	data_mine_set_mission_segment( "m80_Airlock_Two" );

	// set airlock index
	f_airlocks_current_index_set( S_airlock_index );

	// collect garbages
	//garbage_collect_now();

	// setup airlock bays
	wake( f_airlocks_two_action_start_bay_01 );
	wake( f_airlocks_two_action_start_bay_02 );
	wake( f_airlocks_two_action_start_bay_03 );
	
	// checkpoint
	checkpoint_no_timeout( TRUE, "f_airlocks_two_action_start" );	
	
end

// === f_airlocks_two_action_complete::: Completes the airlock area
script dormant f_airlocks_two_action_complete()
local long l_timer = timer_stamp( 2.0 );
	//dprint( "::: f_airlocks_two_action_complete :::" );

	sleep_until( timer_expired(l_timer) or f_airlocks_two_finished(), 1 );

	if ( not f_airlocks_two_finished() ) then
		// VO
		wake( f_dialog_m80_airlock_two_few_left );
		sleep_until( dialog_foreground_id_active_check(L_dlg_m80_airlock_two_few_left) or dialog_id_played_check(L_dlg_m80_airlock_two_few_left), 1 );
		l_timer = timer_stamp( 1.5 );
		sleep_until( timer_expired(l_timer) or f_airlocks_two_finished() or dialog_id_played_check(L_dlg_m80_airlock_two_few_left), 1 );
	end
		
	if ( not f_airlocks_two_finished() ) then
		// BLIP
		f_objective_set( DEF_R_OBJECTIVE_AIRLOCKS_ENEMIES(), TRUE, TRUE, FALSE, TRUE );
	
		// finish
		sleep_until( f_airlocks_two_finished(), 1 );
	end
	
	// pause a brief moment
	sleep_s( 0.5 );
	checkpoint_no_timeout( TRUE, "f_airlocks_two_trigger: AIRLOCK TWO FINISHED" );

	// prepare next zone set
	//if ( zoneset_current() == S_ZONESET_AIRLOCK_TWO ) then
	//	thread( zoneset_prepare(S_ZONESET_TO_LOOKOUT) );
	//end

	// blip exit
	f_objective_set( DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT(), TRUE, TRUE, FALSE, TRUE );

end

// === f_airlocks_two_action_start_bay_01::: Starts the airlock bay
script dormant f_airlocks_two_action_start_bay_01()
local ai ai_squad = 				NONE;
local short s_state_next = 	DEF_S_AIRLOCK_STATE_RESET;

	repeat
		//dprint( "::: f_airlocks_two_action_start_bay_01: CYCLE :::" );
	
		// select a squad
		ai_squad = f_airlocks_two_ai_squad_get( 01, TRUE, sq_airlock_two_bay_01_01, 'pup_airlock_two_bay_01_01', sq_airlock_two_bay_01_02, 'pup_airlock_two_bay_01_02' );

		if ( ai_squad != NONE ) then
		
			print("cycling airlock 1");
			// cycle airlock
			f_airlocks_bay_manage(
				S_airlock_index, 
				1, 
				DEF_S_AIRLOCK_STATE_DEFAULT, 
				s_state_next, 
				ai_squad, 
				3.0,
				fx_14_airlock_two_door_3_a, 
				fx_14_airlock_two_door_3_b, 
				fx_14_airlock_two_door_3_c
			);
			
			// next time it's complete
			s_state_next = 	DEF_S_AIRLOCK_STATE_COMPLETE;
			
		end
		
	until( ai_squad == NONE, 1 );
	S_airlock_two_complete_cnt = S_airlock_two_complete_cnt + 1;
	//dprint( "::: f_airlocks_two_action_start_bay_01: COMPLETE :::" );

end

// === f_airlocks_two_action_start_bay_02::: Starts the airlock bay
script dormant f_airlocks_two_action_start_bay_02()
local ai ai_squad = 				NONE;
local short s_state_next = 	DEF_S_AIRLOCK_STATE_RESET;

	repeat
		//dprint( "::: f_airlocks_two_action_start_bay_02: CYCLE :::" );

		// select a squad
		ai_squad = f_airlocks_two_ai_squad_get( 02, FALSE, sq_airlock_two_bay_02_01, 'pup_airlock_two_bay_02_01', sq_airlock_two_bay_02_02, 'pup_airlock_two_bay_02_02' );

		if ( ai_squad != NONE ) then
			print("cycling airlock 2");
			// cycle airlock
			f_airlocks_bay_manage(
				S_airlock_index, 
				2, 
				DEF_S_AIRLOCK_STATE_DEFAULT, 
				s_state_next, 
				ai_squad, 
				0.0,
				fx_14_airlock_two_door_2_a, 
				fx_14_airlock_two_door_2_b, 
				fx_14_airlock_two_door_2_c
			);
			
			// next time it's complete
			s_state_next = 	DEF_S_AIRLOCK_STATE_COMPLETE;
			
		end
		
	until( ai_squad == NONE, 1 );
	S_airlock_two_complete_cnt = S_airlock_two_complete_cnt + 1;
	//dprint( "::: f_airlocks_two_action_start_bay_02: COMPLETE :::" );

end

// === f_airlocks_two_action_start_bay_03::: Starts the airlock bay
script dormant f_airlocks_two_action_start_bay_03()
local ai ai_squad = 				NONE;
local short s_state_next = 	DEF_S_AIRLOCK_STATE_RESET;

	repeat
		//dprint( "::: f_airlocks_two_action_start_bay_03: CYCLE :::" );

		// select a squad
		ai_squad = f_airlocks_two_ai_squad_get( 03, TRUE, sq_airlock_two_bay_03_01, 'pup_airlock_two_bay_03_01', sq_airlock_two_bay_03_02, 'pup_airlock_two_bay_03_02' );

		if ( ai_squad != NONE ) then
		
			print("cycling airlock 3");
			// cycle airlock
			f_airlocks_bay_manage(
				S_airlock_index, 
				3, 
				DEF_S_AIRLOCK_STATE_DEFAULT, 
				s_state_next, 
				ai_squad, 
				0.0,
				fx_14_airlock_two_door_1_a, 
				fx_14_airlock_two_door_1_b, 
				fx_14_airlock_two_door_1_c
			);
			
			// next time it's complete
			s_state_next = 	DEF_S_AIRLOCK_STATE_COMPLETE;
			
		end
		
	until( ai_squad == NONE, 1 );
	S_airlock_two_complete_cnt = S_airlock_two_complete_cnt + 1;
	//dprint( "::: f_airlocks_two_action_start_bay_03: COMPLETE :::" );

end

// === f_airlocks_two_action_started::: Checks if the area was started
script static boolean f_airlocks_two_started()
static boolean b_started = FALSE;

	if ( not b_started ) then
		b_started = volume_test_players( tv_airlock_two_start );
	end

	// return
	b_started;
end

// === f_airlocks_two_entered::: Checks if the area was entered
script static boolean f_airlocks_two_entered()
static boolean b_entered = FALSE;

	if ( not b_entered ) then
		b_entered = volume_test_players( tv_airlock_two_entered ) or volume_test_players(tv_reached_airlock_two_lowpath) or volume_test_players(tv_reached_airlock_two_highpath);
	end

	// return
	b_entered;
end

// === f_airlocks_two_bays_finished::: Checks if the area BAYS are finished
script static boolean f_airlocks_two_bays_finished()
static boolean b_finished = FALSE;

	if ( not b_finished ) then
		b_finished = ( f_airlocks_two_state_get(1) >= DEF_S_AIRLOCK_STATE_COMPLETE ) and ( f_airlocks_two_state_get(2) >= DEF_S_AIRLOCK_STATE_COMPLETE ) and ( f_airlocks_two_state_get(3) >= DEF_S_AIRLOCK_STATE_COMPLETE );
	end

	// return
	b_finished;
end

// === f_airlocks_two_finished::: Checks if the area was finished
script static boolean f_airlocks_two_finished()
static boolean b_finished = FALSE;

	if ( not b_finished ) then
		b_finished = ( ai_living_count(sg_airlock_two_units) <= 0 ) and f_airlocks_two_bays_finished();
	end

	// return
	b_finished;
end
/*
script static void test_airlocks_two_finished()
	//dprint( "test_airlocks_two_finished ------------------------------------" );
	
	//dprint( "f_airlocks_two_finished()" );
	//inspect( f_airlocks_two_finished() );
	if ( not f_airlocks_two_finished() ) then
	
		//dprint( "ai_living_count(sg_airlock_two_units)" );
		//inspect(ai_living_count(sg_airlock_two_units) );
	
		//dprint( "f_airlocks_two_bays_finished()" );
		//inspect( f_airlocks_two_bays_finished() );
		
		if ( not f_airlocks_two_bays_finished() ) then
		
			//dprint( "f_airlocks_two_state_get(1) == DEF_S_AIRLOCK_STATE_COMPLETE" );
			//inspect( f_airlocks_two_state_get(1) >= DEF_S_AIRLOCK_STATE_COMPLETE );
			if ( f_airlocks_two_state_get(1) < DEF_S_AIRLOCK_STATE_COMPLETE ) then
				//dprint( "f_airlocks_two_state_get(1)" );
				//inspect( f_airlocks_two_state_get(1) );
			end

			//dprint( "f_airlocks_two_state_get(2) == DEF_S_AIRLOCK_STATE_COMPLETE" );
			//inspect( f_airlocks_two_state_get(2) >= DEF_S_AIRLOCK_STATE_COMPLETE );
			if ( f_airlocks_two_state_get(2) < DEF_S_AIRLOCK_STATE_COMPLETE ) then
				//dprint( "f_airlocks_two_state_get(2)" );
				//inspect( f_airlocks_two_state_get(2) );
			end

			//dprint( "f_airlocks_two_state_get(3) == DEF_S_AIRLOCK_STATE_COMPLETE" );
			//inspect( f_airlocks_two_state_get(3) >= DEF_S_AIRLOCK_STATE_COMPLETE );
			if ( f_airlocks_two_state_get(3) < DEF_S_AIRLOCK_STATE_COMPLETE ) then
				//dprint( "f_airlocks_two_state_get(3)" );
				//inspect( f_airlocks_two_state_get(3) );
			end
		
		end
		
	end
	//dprint( "---------------------------------------------------------------" );
end
*/

   
     
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// airlocks: TWO: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_props_init::: Init
script dormant f_airlocks_two_props_init()
	//dprint( "::: f_airlocks_two_props_init :::" );
	
	object_create_folder( 'airlock_two_crates' );
	object_create_folder( 'airlock_two_equipment' );
	object_create_folder( 'airlock_two_weapons' );
	
end

// === f_airlocks_two_props_deinit::: Deinit
script dormant f_airlocks_two_props_deinit()
	//dprint( "::: f_airlocks_two_props_deinit :::" );

	// create	
	object_destroy_folder( 'airlock_two_crates' );
	
	// kill functions
	kill_script( f_airlocks_two_props_init );
	
end   



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: STATE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_state_set::: Set
script static void f_airlocks_two_state_set( short s_bay_id, short s_state )
	//dprint( "::: f_airlocks_two_state_set :::" );
	//inspect( s_bay_id );
	if ( f_airlocks_two_state_get(s_bay_id) != s_state ) then
	
		if ( s_bay_id == 1 ) then
			S_airlock_two_01_state = s_state;
		elseif ( s_bay_id == 2 ) then
			S_airlock_two_02_state = s_state;
		else
			S_airlock_two_03_state = s_state;
		end
	
		//inspect( s_state );
	end
end

// === f_airlocks_two_state_get::: Get
script static short f_airlocks_two_state_get( short s_bay_id )
local short s_return = DEF_S_AIRLOCK_STATE_INIT;

	if ( s_bay_id == 1 ) then
		s_return = S_airlock_two_01_state;
	elseif ( s_bay_id == 2 ) then
		s_return = S_airlock_two_02_state;
	else
		s_return = S_airlock_two_03_state;
	end

	// return
	s_return;
end

// === f_airlocks_two_door_inner_get::: Get
script static object_name f_airlocks_two_door_inner_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		door_airlock_two_inner_1_maya;
	elseif ( s_bay_id == 2 ) then
		door_airlock_two_inner_2_maya;
	else
		door_airlock_two_inner_3_maya;
	end

end

// === f_airlocks_two_button_get::: Get
script static object_name f_airlocks_two_button_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		button_airlock_two_inner_1;
	elseif ( s_bay_id == 2 ) then
		button_airlock_two_inner_2;
	else
		button_airlock_two_inner_3;
	end

end

// === f_airlocks_two_button_get::: Get
script static object_name f_airlocks_two_gravity_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		low_grav_airlock_two_door_1;
	elseif ( s_bay_id == 2 ) then
		low_grav_airlock_two_door_2;
	else
		low_grav_airlock_two_door_3;
	end

end

// === f_airlocks_two_button_get::: Get
script static object_name f_airlocks_two_vacuum_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		gravlift_airlock_two_1;
	elseif ( s_bay_id == 2 ) then
		gravlift_airlock_two_2;
	else
		gravlift_airlock_two_3;
	end

end

// === f_airlocks_two_door_outer_get::: Get
script static object_name f_airlocks_two_door_outer_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		door_airlock_two_outer_1_maya;
	elseif ( s_bay_id == 2 ) then
		door_airlock_two_outer_2_maya;
	else
		door_airlock_two_outer_3_maya;
	end

end

// === f_airlocks_two_bay_volume_get::: Get
script static trigger_volume f_airlocks_two_bay_volume_get( short s_bay_id )

	if ( s_bay_id == 1 ) then
		tv_airlock_two_bay_1_area;
	elseif ( s_bay_id == 2 ) then
		tv_airlock_two_bay_2_area;
	else
		tv_airlock_two_bay_3_area;
	end

end

// === f_airlocks_bay_volume_get::: Get
script static trigger_volume f_airlocks_two_eject_kill_volume_get()
	tv_airlock_two_eject_kill;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: GRAVITY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_gravity_init::: Init
script dormant f_airlocks_two_gravity_init()
	sleep_until( object_valid(airlock_two_exterior_gravity), 1 );
	//dprint( "::: f_airlocks_two_gravity_init :::" );
	
	// hide gravity object
	object_hide( airlock_two_exterior_gravity, TRUE );
	
end

// === f_airlocks_two_gravity_deinit::: Deinit
script dormant f_airlocks_two_gravity_deinit()
	//dprint( "::: f_airlocks_two_gravity_deinit :::" );

	if ( object_valid(airlock_two_exterior_gravity) ) then
		object_destroy( airlock_two_exterior_gravity );
	end
	
	// kill functions
	kill_script( f_airlocks_two_gravity_init );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_doors_init::: Init
script dormant f_airlocks_two_doors_init()
	//dprint( "::: f_airlocks_two_doors_init :::" );
	
	// init sub modules
	wake( f_airlocks_two_door_enter_init );
	wake( f_airlocks_two_door_exit_init );
	
end

// === f_airlocks_two_doors_deinit::: Deinit
script dormant f_airlocks_two_doors_deinit()
	//dprint( "::: f_airlocks_two_doors_deinit :::" );

	// deinit sub modules
	wake( f_airlocks_two_door_enter_deinit );
	wake( f_airlocks_two_door_exit_deinit );
	
	// kill functions
	kill_script( f_airlocks_two_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: DOOR: ENTER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_door_enter_init::: Init
script dormant f_airlocks_two_door_enter_init()
	sleep_until( object_valid(door_to_airlock_two_exit_maya) and object_active_for_script(door_to_airlock_two_exit_maya), 1 );
	//dprint( "::: f_airlocks_two_door_enter_init :::" );

	// open the door
	door_to_airlock_two_exit_maya->open_immediate();

	// close
	door_to_airlock_two_exit_maya->zoneset_auto_close_setup( S_ZONESET_TO_LOOKOUT, TRUE, TRUE, -1, S_ZONESET_TO_LOOKOUT, TRUE );
	door_to_airlock_two_exit_maya->auto_trigger_close_all_out( tv_airlock_two_door_enter_close_out, TRUE );

	// auto complete objective
	f_hallways_two_reward_blip( FALSE );

	// force closed
	door_to_airlock_two_exit_maya->close_immediate();
	
	// cleanup hallway two
	wake( f_hallways_two_deinit );
	
end

// === f_airlocks_two_door_enter_deinit::: Deinit
script dormant f_airlocks_two_door_enter_deinit()
	//dprint( "::: f_airlocks_two_door_enter_deinit :::" );
	
	// kill functions
	kill_script( f_airlocks_two_door_enter_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: TWO: DOOR: EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_two_door_exit_init::: Init
script dormant f_airlocks_two_door_exit_init()
	sleep_until( object_valid(door_airlock_two_exit_maya) and object_active_for_script(door_airlock_two_exit_maya), 1 );
	//dprint( "::: f_airlocks_two_door_exit_init :::" );

	// setup door
	//door_airlock_two_exit_maya->speed_open( 4.5 );
	//door_airlock_two_exit_maya->speed_close( 3.5 );
	
	// leave early check
	sleep_until( f_airlocks_two_finished() or volume_test_players(tv_open_door_hallways_exit), 1 );
	if ( not f_airlocks_two_finished() ) then
		wake( f_dialog_airlock_2_system_lockdown );
	end

	// setup auto disable	
	thread( door_airlock_two_exit_maya->auto_enabled_zoneset(FALSE, S_ZONESET_LOOKOUT, -1) );

	// open
	sleep_until( f_airlocks_two_finished(), 1 );
	door_airlock_two_exit_maya->zoneset_auto_open_setup( S_ZONESET_TO_LOOKOUT, TRUE, TRUE, -1, S_ZONESET_TO_LOOKOUT, TRUE );
	door_airlock_two_exit_maya->auto_trigger_open_any_in( tv_airlock_two_door_exit_open_in, FALSE );

	// close
	door_airlock_two_exit_maya->zoneset_auto_close_setup( S_ZONESET_LOOKOUT, TRUE, FALSE, -1, S_ZONESET_LOOKOUT, TRUE );
	door_airlock_two_exit_maya->auto_trigger_close_all_in( tv_airlock_two_door_exit_close_in, TRUE );

	// complete the exit objective
	f_objective_complete( DEF_R_OBJECTIVE_AIRLOCKS_TWO_EXIT(), FALSE, TRUE );
	
	// force closed
	door_airlock_two_exit_maya->close_immediate();
	
end

// === f_airlocks_two_door_exit_deinit::: Deinit
script dormant f_airlocks_two_door_exit_deinit()
	//dprint( "::: f_airlocks_two_door_exit_deinit :::" );
	
	// kill functions
	kill_script( f_airlocks_two_door_exit_init );
	
end
