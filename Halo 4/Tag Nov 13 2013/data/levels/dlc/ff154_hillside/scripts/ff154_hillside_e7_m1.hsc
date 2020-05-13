//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** E7M1: MISSION ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
// spawn points
global short DEF_E7M1_INDEX_SPAWN_LOCS_INITIAL = 										90;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === e7_m1_startup::: Startup
script startup f_e7_m1_startup()

	//Wait for start
	if ( f_spops_mission_startup_wait("e7_m1_startup") ) then
	
		dprint( "f_e7_m1_startup" );
		wake( f_e7_m1_init );
		
	end
	
end

// === e7_m1_init::: Init
script dormant f_e7_m1_init()
	dprint( "f_e7_m1_init" );

	// disable all auto-blips
	b_wait_for_narrative_hud = TRUE;

	// set standard mission init
	f_spops_mission_setup( "e7_m1", DEF_HILLSIDE_ZONESET_INDEX_E7M1_START, gr_e7_m1_all, fld_e7_m1_spawn_start, DEF_E7M1_INDEX_SPAWN_LOCS_INITIAL );
	
	// initialize modules
	wake( f_e7_m1_ai_init );
	wake( f_e7_m1_narrative_init );
	wake( f_e7_m1_audio_init );
	
	// initialize sub-modules
	wake( f_e7_m1_shields_init );
	f_e7_m1_props_init();
	
	// setup is complete
	f_spops_mission_setup_complete( TRUE );
	
	// setup start trigger
	wake( f_e7_m1_trigger );

end

// === f_e7_m1_trigger::: Trigger
script dormant f_e7_m1_trigger()
	dprint( "f_e7_m1_trigger" );

	sleep_until( f_spops_mission_start_complete(), 1 );
	wake( f_e7_m1_action_start );

	sleep_until( (not object_valid(cr_e7_m1_shield_01)) or (not object_valid(cr_e7_m1_shield_02)) or (ai_living_count(sq_e7_m1_start_elite_01) <= 0) or (ai_living_count(sq_e7_m1_start_grunt_01) <= 0), 1 );
	wake( f_e7_m1_action_abort );

end

// === f_e7_m1_action_start::: Action
script dormant f_e7_m1_action_start()
	dprint( "f_e7_m1_action_start" );

	wake( f_e7_m1_dialog_start );

end

// === f_e7_m1_action_abort::: Action
script dormant f_e7_m1_action_abort()
	dprint( "f_e7_m1_action_abort" );

	wake( f_e7_m1_dialog_abort_start );
	f_blip_auto_flag_trigger( flg_e7_m1_lz_exit_loc, "default", tv_e7_m1_lz_exit_area, FALSE );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: SHIELDS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_shields_init::: Init
script dormant f_e7_m1_shields_init()
	dprint( "f_e7_m1_shields_init" );

	// start area
	thread( f_e7_m1_shields_manage(cr_e7_m1_shield_01, TRUE, cr_e7_m1_shield_01_terminal_a, NONE, cr_e7_m1_shield_01_terminal_b, dc_e7_m1_shield_01_terminal_b) );
	thread( f_e7_m1_shields_manage(cr_e7_m1_shield_02, TRUE, cr_e7_m1_shield_02_terminal_a, dc_e7_m1_shield_02_terminal_a, cr_e7_m1_shield_02_terminal_b, dc_e7_m1_shield_02_terminal_b) );

end

script static void f_e7_m1_shields_manage( object_name obj_shield, boolean b_active_start, object_name obj_terminal_a, object_name obj_terminal_a_control, object_name obj_terminal_b, object_name obj_terminal_b_control )
	dprint( "f_e7_m1_shields_manage" );

	// active start state
	if ( b_active_start and (not object_valid(obj_shield)) ) then
		object_create( obj_shield );
	end
	thread( f_e7_m1_shields_terminal_manage(obj_shield, obj_terminal_a, obj_terminal_a_control) );
	thread( f_e7_m1_shields_terminal_manage(obj_shield, obj_terminal_b, obj_terminal_b_control) );

end

script static void f_e7_m1_shields_terminal_manage( object_name obj_shield, object_name obj_terminal, object_name obj_terminal_control )

	// Make sure the objects have been created
	if ( (obj_terminal != NONE) and (not object_valid(obj_terminal)) ) then
		object_create( obj_terminal );
	end
	if ( obj_terminal_control != NONE ) then
	
		if ( not object_valid(obj_terminal_control) ) then
			object_create( obj_terminal_control );
		end
		object_hide( obj_terminal_control, TRUE );
	end

	if ( obj_terminal_control != NONE ) then
		local boolean b_active = FALSE;
		dprint( "f_e7_m1_shields_terminal_manage" );
		
		repeat
		
			// get shield active state
			b_active = object_valid( obj_shield );
			
			if ( b_active ) then
				dprint( "f_e7_m1_shields_terminal_manage: ON" );
				device_set_power( device(obj_terminal_control), 1.0 );
				device_set_position( device(obj_terminal_control), 0.0 );
				sleep_until( (object_valid(obj_shield) != b_active) or (device_get_position(device(obj_terminal_control)) > 0.0), 1 );
				object_destroy( obj_shield );
			else
				dprint( "f_e7_m1_shields_terminal_manage: OFF" );
				device_set_power( device(obj_terminal_control), 1.0 );
				device_set_position( device(obj_terminal_control), 0.0 );
				sleep_until( (object_valid(obj_shield) != b_active) or (device_get_position(device(obj_terminal_control)) > 0.0), 1 );
				object_create( obj_shield );
			end

			sleep_until( object_valid(obj_shield) != b_active, 1 );
		
		until( FALSE, 1 );
		
	end
	
end

// === f_activator_get::: For some strange reason device controls point to this function
script static void f_e7_m1_shield_switch( object obj_control, unit u_activator )
	dprint( "f_e7_m1_shield_switch" );

//	if ( obj_control == domain_terminal_button ) then
//	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: PROPS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7_m1_props_init::: Init
script static void f_e7_m1_props_init()
	dprint( "f_e7_m1_props_init" );

	// crates base
	object_create_folder( fld_e7_m1_crates_base );
	object_create_folder( fld_e7_m1_vehicles_base );

end