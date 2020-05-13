//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e8m2_artilleray_explosion_warning_range = 							8.5;
static short S_e8m2_artilleray_cnt = 																	0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_init::: Init
script dormant f_e8_m2_artillery_init()
	dprint( "f_e8_m2_artillery_init" );

	// init sub modules
	wake( f_e8_m2_artillery_01_init );
	wake( f_e8_m2_artillery_02_init );
	wake( f_e8_m2_artillery_03_init );

	// set default allegiances
	ai_allegiance_break( player, DEF_E8_M2_TEAM_ARTILLERY );
	ai_allegiance_break( DEF_E8_M2_TEAM_ARTILLERY, player );
	ai_allegiance( covenant, DEF_E8_M2_TEAM_ARTILLERY );
	ai_allegiance( DEF_E8_M2_TEAM_ARTILLERY, covenant );

	ai_allegiance( covenant, DEF_E8_M2_TEAM_CORE );
	ai_allegiance( DEF_E8_M2_TEAM_CORE, covenant );
	ai_allegiance( human, DEF_E8_M2_TEAM_CORE );
	ai_allegiance( DEF_E8_M2_TEAM_CORE, human );
	
	// setup triggers
	wake( f_e8_m2_artillery_trigger );

end

// === f_e8_m2_artillery_trigger::: Trigger
script dormant f_e8_m2_artillery_trigger()
	dprint( "f_e8_m2_artillery_trigger" );

	// infinity msg about artillery
	sleep_until( ((not volume_test_players_all(tv_e8m2_start_area)) and (player_living_count() > 0)) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN), 1 );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN );	
	wake( f_e8_m2_dialog_artillery_infinity_info );

	// end
	sleep_until( LevelEventStatus("e8m2_artillery_end"), 1 );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_COMPLETE );

end

// === f_e8_m2_artillery_living_cnt::: Returns the count of living  artillery
script static short f_e8_m2_artillery_living_cnt()
local short s_cnt = 0;

	if ( object_get_health(vh_e8_m2_artillery_01) > 0.0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( object_get_health(vh_e8_m2_artillery_02) > 0.0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( object_get_health(vh_e8_m2_artillery_03) > 0.0 ) then
		s_cnt = s_cnt + 1;
	end

	// returns
	s_cnt;
end

// === f_e8_m2_artillery_living_ratio::: Returns the ratio of living artillery
script static real f_e8_m2_artillery_living_ratio()
	real( f_e8_m2_artillery_living_cnt() ) / real( S_e8m2_artilleray_cnt );
end

// === f_e8_m2_artillery_killed_cnt::: Returns the count of killed artillery
script static short f_e8_m2_artillery_killed_cnt()
	S_e8m2_artilleray_cnt - f_e8_m2_artillery_living_cnt();
end

// === f_e8_m2_artillery_core_get_artillery::: Returns the artillery object for a core
script static object_name f_e8_m2_artillery_core_get_artillery( object obj_core )
local object_name obj_artillery = NONE;

	if ( obj_core != NONE ) then

		if ( (obj_core == cr_e8_m2_artillery_01_core_01) or (obj_core == cr_e8_m2_artillery_01_core_02) or (obj_core == cr_e8_m2_artillery_01_core_03) ) then
			obj_artillery = vh_e8_m2_artillery_01;
		end
		if ( (obj_core == cr_e8_m2_artillery_02_core_01) or (obj_core == cr_e8_m2_artillery_03_core_02) or (obj_core == cr_e8_m2_artillery_03_core_03) ) then
			obj_artillery = vh_e8_m2_artillery_02;
		end
		if ( (obj_core == cr_e8_m2_artillery_03_core_01) or (obj_core == cr_e8_m2_artillery_03_core_02) or (obj_core == cr_e8_m2_artillery_03_core_03) ) then
			obj_artillery = vh_e8_m2_artillery_03;
		end

	end

	// return
	obj_artillery;
end

// === f_e8_m2_artillery_core_get_artillery::: Returns the core object index for an artillery
script static object_name f_e8_m2_artillery_get_core( object obj_artillery, short s_index )
local object_name obj_core = NONE;

	if ( obj_artillery != NONE ) then
	
		// artillery 01
		if ( obj_artillery == vh_e8_m2_artillery_01 ) then
			if ( s_index == 1 ) then
				obj_core = cr_e8_m2_artillery_01_core_01;
			end
			if ( s_index == 2 ) then
				obj_core = cr_e8_m2_artillery_01_core_02;
			end
			if ( s_index == 3 ) then
				obj_core = cr_e8_m2_artillery_01_core_03;
			end
		end
		
		// artillery 02
		if ( obj_artillery == vh_e8_m2_artillery_02 ) then
			if ( s_index == 1 ) then
				obj_core = cr_e8_m2_artillery_02_core_01;
			end
			if ( s_index == 2 ) then
				obj_core = cr_e8_m2_artillery_02_core_02;
			end
			if ( s_index == 3 ) then
				obj_core = cr_e8_m2_artillery_02_core_03;
			end
		end
		
		// artillery 03
		if ( obj_artillery == vh_e8_m2_artillery_03 ) then
			if ( s_index == 1 ) then
				obj_core = cr_e8_m2_artillery_03_core_01;
			end
			if ( s_index == 2 ) then
				obj_core = cr_e8_m2_artillery_03_core_02;
			end
			if ( s_index == 3 ) then
				obj_core = cr_e8_m2_artillery_03_core_03;
			end
		end
		
	end

	// return
	obj_core;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 01 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_01_init::: Init
script dormant f_e8_m2_artillery_01_init()
local long l_thread = 0;
	dprint( "f_e8_m2_artillery_01_init" );

	l_thread = thread( f_e8_m2_artillery_manage(DEF_E8M2_INDEX_OBJECTIVE_ARTILLARY_01, fld_e8_m2_spawn_artillery_01, vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01, dm_e8_m2_artillery_01_shell_01, cr_e8_m2_artillery_01_core_02, dm_e8_m2_artillery_01_shell_02, cr_e8_m2_artillery_01_core_03, dm_e8_m2_artillery_01_shell_03) );
	thread( f_e8_m2_ai_artillery_setup(l_thread, vh_e8_m2_artillery_01, sq_e8m2_a01_leader, sq_e8m2_a01_support, flg_e8m2_artillery_01_spawn_loc, sq_e8m2_a01_c01_leader, sq_e8m2_a01_c01_support, flg_e8m2_artillery_01_core_01_spawn_loc, sq_e8m2_a01_c02_leader, sq_e8m2_a01_c02_support, flg_e8m2_artillery_01_core_02_spawn_loc, sq_e8m2_a01_c03_leader, sq_e8m2_a01_c03_support, flg_e8m2_artillery_01_core_03_spawn_loc) );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 02 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_02_init::: Init
script dormant f_e8_m2_artillery_02_init()
local long l_thread = 0;
	dprint( "f_e8_m2_artillery_02_init" );

	l_thread = thread( f_e8_m2_artillery_manage(DEF_E8M2_INDEX_OBJECTIVE_ARTILLARY_02, fld_e8_m2_spawn_artillery_02, vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01, dm_e8_m2_artillery_02_shell_01, cr_e8_m2_artillery_02_core_02, dm_e8_m2_artillery_02_shell_02, cr_e8_m2_artillery_02_core_03, dm_e8_m2_artillery_02_shell_03) );
	thread( f_e8_m2_ai_artillery_setup(l_thread, vh_e8_m2_artillery_02, sq_e8m2_a02_leader, sq_e8m2_a02_support, flg_e8m2_artillery_02_spawn_loc, sq_e8m2_a02_c01_leader, sq_e8m2_a02_c01_support, flg_e8m2_artillery_02_core_01_spawn_loc, sq_e8m2_a02_c02_leader, sq_e8m2_a02_c02_support, flg_e8m2_artillery_02_core_02_spawn_loc, sq_e8m2_a02_c03_leader, sq_e8m2_a02_c03_support, flg_e8m2_artillery_02_core_03_spawn_loc) );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 03 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_03_init::: Init
script dormant f_e8_m2_artillery_03_init()
local long l_thread = 0;
	dprint( "f_e8_m2_artillery_03_init" );

	l_thread = thread( f_e8_m2_artillery_manage(DEF_E8M2_INDEX_OBJECTIVE_ARTILLARY_03, fld_e8_m2_spawn_artillery_03, vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01, dm_e8_m2_artillery_03_shell_01, cr_e8_m2_artillery_03_core_02, dm_e8_m2_artillery_03_shell_02, cr_e8_m2_artillery_03_core_03, dm_e8_m2_artillery_03_shell_03) );
	thread( f_e8_m2_ai_artillery_setup(l_thread, vh_e8_m2_artillery_03, sq_e8m2_a03_leader, sq_e8m2_a03_support, flg_e8m2_artillery_03_spawn_loc, sq_e8m2_a03_c01_leader, sq_e8m2_a03_c01_support, flg_e8m2_artillery_03_core_01_spawn_loc, sq_e8m2_a03_c02_leader, sq_e8m2_a03_c02_support, flg_e8m2_artillery_03_core_02_spawn_loc, sq_e8m2_a03_c03_leader, sq_e8m2_a03_c03_support, flg_e8m2_artillery_03_core_03_spawn_loc) );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: STABILITY: STATE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE = 						0;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED = 			1;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS = 				2;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED = 				3;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_unit_state::: Returns the current firing 
script static short f_e8_m2_artillery_unit_state( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )

	if ( object_get_health(obj_artillery) <= 0.0 ) then
		DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED;
	elseif ( (object_get_health(obj_core_01) > 0.0) and (object_get_health(obj_core_02) > 0.0) and (object_get_health(obj_core_03) > 0.0) ) then
		DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
	elseif ( (object_get_health(obj_core_01) <= 0.0) and (object_get_health(obj_core_02) <= 0.0) and (object_get_health(obj_core_03) <= 0.0) ) then
		DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS;
	else
		DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED;
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: MANAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_e8m2_artilleray_blip_range = 							20.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_manage::: Manages the artillery logic
script static void f_e8_m2_artillery_manage( short s_index_objective, folder fld_spawn_locs, object_name obj_artillery, object_name obj_core_01, object_name obj_shell_01, object_name obj_core_02, object_name obj_shell_02, object_name obj_core_03, object_name obj_shell_03 )
local long l_objective_primary = 0;
local long l_objective_secondary = 0;
local long l_damage_thread = 0;
	dprint( "f_e8_m2_artillery_manage" );

	// make sure the objects are created
	if ( not object_valid(obj_artillery) ) then
		object_create( obj_artillery );
		sleep_until( object_valid(obj_artillery), 1 );
	end
	
	// targetting settings
	ai_object_set_team( obj_artillery, DEF_E8_M2_TEAM_ARTILLERY );
	ai_object_enable_targeting_from_vehicle( obj_artillery, TRUE );
	ai_object_set_targeting_bias( obj_artillery, 0.75 );
	
	// disable seats
	vehicle_set_player_interaction( vehicle(obj_artillery), 'wraith_d', FALSE, TRUE );
	vehicle_set_player_interaction( vehicle(obj_artillery), 'wraith_b_l', FALSE, TRUE );
	vehicle_set_player_interaction( vehicle(obj_artillery), 'wraith_b_r', FALSE, TRUE );
	vehicle_set_player_interaction( vehicle(obj_artillery), 'wraith_b_b', FALSE, TRUE );
	vehicle_set_unit_interaction( vehicle(obj_artillery), 'wraith_d', FALSE, TRUE );
	vehicle_set_unit_interaction( vehicle(obj_artillery), 'wraith_b_l', FALSE, TRUE );
	vehicle_set_unit_interaction( vehicle(obj_artillery), 'wraith_b_r', FALSE, TRUE );
	vehicle_set_unit_interaction( vehicle(obj_artillery), 'wraith_b_b', FALSE, TRUE );
	
	// increment artillery cnt
	S_e8m2_artilleray_cnt = S_e8m2_artilleray_cnt + 1;

	// manage cores
	thread( f_e8_m2_artillery_core_manage(obj_artillery, obj_core_01, obj_shell_01) );
	thread( f_e8_m2_artillery_core_manage(obj_artillery, obj_core_02, obj_shell_02) );
	thread( f_e8_m2_artillery_core_manage(obj_artillery, obj_core_03, obj_shell_03) );
	
	//thread( test_recent_damage(obj_artillery) );
	
	// XXX TEMP UNTIL WE GET REAL ASSET
	units_set_maximum_vitality( obj_artillery, 2500.0, 0.0 );
	units_set_current_vitality( obj_artillery, 2500.0, 0.0 );
	
	// set the firefight objective
	firefight_mode_set_objective_name_at( obj_artillery, s_index_objective );
	
	// wait for mission start
	sleep_until( f_spops_mission_start_complete(), 1 );
	
	// setup spawn location watchers
	thread( f_e8_m2_artillery_manage_spawn_locs( fld_spawn_locs, obj_artillery, obj_core_01, obj_shell_01, obj_core_02, obj_shell_02, obj_core_03, obj_shell_03) );

	// setup attack manager	
	thread( f_e8_m2_artillery_manage_attack(obj_artillery, obj_core_01, obj_core_02, obj_core_03) );
	
	// damage watch
	l_damage_thread = thread( f_e8_m2_artillery_state_damage_watch(DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, obj_artillery, 0.04975, 0.15, 0.90, -1) );
	
	// far blip
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 1 );
	if ( object_get_health(obj_artillery) > 0.0 ) then
		l_objective_primary = f_blip_auto_object_distance( obj_artillery, "default", 0.1, FALSE );
	end

	// near
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artilleray_blip_range), 1 );
	// near dialog
	if ( objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artilleray_blip_range ) then
		if ( ((f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) and (f_e8_m2_artillery_state() <= DEF_E8M2_ARTILLERY_STATE_NEAR)) or (f_e8_m2_artillery_living_cnt() == 1) ) then
			thread( f_e8_m2_dialog_artillery_near() );
		end
	end
	
	// near blip
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_NEAR), 1 );
	kill_thread( l_objective_primary );
	if ( object_get_health(obj_artillery) > 0.0 ) then
		l_objective_primary = f_blip_auto_object_distance( obj_artillery, "default", R_e8m2_artilleray_blip_range, FALSE );
		if ( f_e8_m2_artillery_state() < DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK ) then
			l_objective_secondary = f_blip_auto_object_distance( obj_artillery, "neutralize", R_e8m2_artilleray_blip_range, TRUE );
		end
	end
	
	// too tough
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH), 1 );
	kill_thread( l_objective_secondary );
	if ( object_get_health(obj_artillery) > 0.0 ) then
		thread( f_e8_m2_dialog_artillery_tough() );
	end
	
	// change the core allegiance so ai will start tergetting them
	ai_allegiance_break( player, DEF_E8_M2_TEAM_CORE );
	ai_allegiance_break(	 DEF_E8_M2_TEAM_CORE, player );
	ai_allegiance_remove( human, DEF_E8_M2_TEAM_CORE );
	ai_allegiance_remove( DEF_E8_M2_TEAM_CORE, human );
	
	// core damaged
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED), 1 );
	if ( (object_get_health(obj_artillery) > 0.0) and (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) <= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
		thread( f_e8_m2_dialog_artillery_core_attacked(obj_artillery, obj_core_01, obj_core_02, obj_core_03) );
	end
	
	// Switch blip
	sleep_until( (object_get_health(obj_artillery) <= 0.0) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK) or (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), 1 );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK );

	// cores destroyed
	sleep_until( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, 1 );
	if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS ) then
		thread( f_e8_m2_dialog_artillery_cores_destroyed(obj_artillery, obj_core_01, obj_core_02, obj_core_03) );
	end
	
	// Destroyed
	sleep_until( object_get_health(obj_artillery) <= 0.0, 1 );

	// destroyed vo
	thread( f_e8_m2_dialog_artillery_destroyed() );

	// clean up threads
	kill_thread( l_objective_primary );
	kill_thread( l_objective_secondary );
	kill_thread( l_damage_thread );

end

// === f_e8_m2_artillery_manage_attack::: Manages the spawn locations for an artillery
script static void f_e8_m2_artillery_manage_spawn_locs( folder fld_spawn_locs, object_name obj_artillery, object_name obj_core_01, object_name obj_shell_01, object_name obj_core_02, object_name obj_shell_02, object_name obj_core_03, object_name obj_shell_03 )
static short s_active_cnt = 0;
	dprint( "f_e8_m2_artillery_manage_spawn_locs" );

	// wait to activate
	sleep_until( 
		( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE )
		or
		( objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artilleray_blip_range )
	, 1 );

	// activate
	dprint( "f_e8_m2_artillery_manage_spawn_locs: ACTIVATE" );
	object_create_folder( fld_spawn_locs );
	s_active_cnt = s_active_cnt + 1;

	// wait to deactivate
	sleep_until( (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED) and ((s_active_cnt > 1) or (f_e8_m2_artillery_living_cnt() <= 0)), 1 );

	// deactivate
	dprint( "f_e8_m2_artillery_manage_spawn_locs: DEACTIVATE" );
	object_destroy_folder( fld_spawn_locs );
	s_active_cnt = s_active_cnt - 1;

	// setup final spawn points
	if ( (f_e8_m2_artillery_living_cnt() <= 0) and (s_active_cnt == 0) ) then
		dprint( "f_e8_m2_artillery_manage_spawn_locs: FINAL" );
		object_destroy_folder( fld_e8_m2_spawn_init );
		object_create_folder( fld_e8_m2_spawn_rendezvous );
	end

end

// === f_e8_m2_artillery_manage_attack::: Manages the artillery attack logic
script static void f_e8_m2_artillery_manage_attack( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
local long l_timer_attack = 0;
local short s_shots_fired = 0;
local boolean b_miss_fire = FALSE;
static long l_timer_last = 0;
static boolean b_firing = FALSE;
	dprint( "f_e8_m2_artillery_manage_attack" );

	// XXX wait for setup for first shot

	// initialize last shot timer
	l_timer_last = timer_stamp();

	repeat
	
		// start timer
		l_timer_attack = timer_stamp( 10.0, 15.0 );
		
		// wait
		sleep_until( timer_expired(l_timer_attack) and (not b_firing) and (timer_expired(l_timer_last, 10.0) or (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS)), 1 );
		
		// set firing
		b_firing = TRUE;

		// prepare artillery
		if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED ) then
			dprint( "f_e8_m2_artillery_manage_attack: PREPARE" );
			l_timer_attack = timer_stamp( 3.0 );
			sleep_until( timer_expired(l_timer_attack), 1 );
		end

		// reset shots fired
		s_shots_fired = 0;
		
		repeat

			// inc shots fired
			s_shots_fired = s_shots_fired + 1;

			// fire!
			if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED ) then
			
				dprint( "f_e8_m2_artillery_manage_attack: FIRE!!!" );

				// delay between shots
				sleep_s( 0.75 );

				// check for destablization
				if ( s_shots_fired <= f_e8_m2_artillery_core_cnt(obj_artillery, obj_core_01, obj_core_02, obj_core_03) ) then
					
					// destablized message
					if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED ) then
						thread( f_e8_m2_dialog_artillery_destabilized(obj_artillery, obj_core_01, obj_core_02, obj_core_03) );
					end

				end

				if ( f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS ) then
					b_miss_fire = TRUE;
				end

			end
		
		until( s_shots_fired >= f_e8_m2_artillery_core_cnt(obj_artillery, obj_core_01, obj_core_02, obj_core_03), 1 );
	
		// reset last shot timer
		l_timer_last = timer_stamp();

		// reset firing
		b_firing = FALSE;
		
	until( b_miss_fire or (f_e8_m2_artillery_unit_state(obj_artillery, obj_core_01, obj_core_02, obj_core_03) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED), 1 );

	// warning dialog
	thread( f_e8_m2_dialog_artillery_dangerous(obj_artillery, obj_core_01, obj_core_02, obj_core_03) );
	
	// delay before explodes
	l_timer_attack = timer_stamp( 3.0 );
	sleep_until( timer_expired(l_timer_attack) and (not dialog_id_active_check(L_e8_m2_dialog_artillery_dangerous)), 1 );
	
	// XXX TEMP
	if ( object_get_health(obj_artillery) > 0.0 ) then
		dprint( "f_e8_m2_artillery_manage_attack: DESTROY!!!" );
		damage_object( obj_artillery, 'hull_front', 25000.0 );
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: CORE: MANAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object OBJ_e8m2_artilleray_pup_core = 													NONE;
global object OBJ_e8m2_artilleray_pup_shell = 												NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_core_manage::: Manages core logic
script static void f_e8_m2_artillery_core_manage( object_name obj_artillery, object_name obj_core, object_name obj_shell )
local long l_damage_thread = 0;
local long l_objective = 0;
	dprint( "f_e8_m2_artillery_core_manage" );

	// setup core
	if ( not object_valid(obj_core) ) then
		object_create( obj_core );
		sleep_until( object_valid(obj_core), 1 );
	end
	
	// targetting settings
	ai_object_set_team( obj_core, DEF_E8_M2_TEAM_CORE );
	ai_object_enable_targeting_from_vehicle( obj_core, TRUE );
	ai_object_set_targeting_bias( obj_core, 0.75 );
	
	// XXX TEMP UNTIL WE GET REAL ASSET
	units_set_maximum_vitality( obj_core, 250.0, 0.0 );
	units_set_current_vitality( obj_core, 250.0, 0.0 );
	
	// setup shell
	if ( not object_valid(obj_shell) ) then
		object_create( obj_shell );
		sleep_until( object_valid(obj_shell), 1 );
	end
	// start pup show
	OBJ_e8m2_artilleray_pup_core = obj_core;
	OBJ_e8m2_artilleray_pup_shell = obj_shell;
	pup_play_show( 'pup_e8m2_shell' );
	
	//thread( test_recent_damage(obj_core) );
	
	// wait for mission start
	sleep_until( f_spops_mission_start_complete(), 1 );
	
	// damage watch
	l_damage_thread = thread( f_e8_m2_artillery_state_damage_watch(DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED, obj_core, 0.025, 0.075, 0.90, -1) );

	// blip core
	sleep_until( (object_get_health(obj_artillery) <= 0.0) or (object_get_health(obj_core) <= 0.0) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK), 1 );
	if ( (object_get_health(obj_artillery) > 0.0) and (object_get_health(obj_core) > 0.0) ) then
		l_objective = f_blip_auto_object_target_distance( obj_core, obj_artillery, "neutralize", R_e8m2_artilleray_blip_range, TRUE );
	end

	// core damaged
	sleep_until( (object_get_health(obj_artillery) <= 0.0) or (object_get_health(obj_core) <= 0.0), 1 );
	kill_thread( l_objective );
	kill_thread( l_damage_thread );

	// destroyed dialog
	if ( (object_get_health(obj_artillery) > 0.0) and (object_get_health(obj_core) <= 0.0) ) then
		thread( f_e8_m2_dialog_artillery_core_destroyed() );
	end
	
	// make sure the core is destroyed
	f_e8_m2_artillery_core_fade_out( obj_core, TRUE );

end

// === xxx::: xxx
script static void f_e8_m2_artillery_core_fade_out( object_name obj_core, boolean b_destroy )
	dprint( "f_e8_m2_artillery_core_manage" );
	if ( object_get_health(obj_core) > 0.0 ) then
		local long l_timer = timer_stamp( 1.0 );
		object_set_scale( obj_core, 0.001, seconds_to_frames(0.5) );
		sleep_until( timer_expired(l_timer) or (object_get_health(obj_core) <= 0.0), 1 );
	end
	if ( b_destroy and (object_get_health(obj_core) > 0.0) ) then
		object_destroy( obj_core );
	end
end

// === f_e8_m2_artillery_core_cnt::: Returns the number of cores available for the artillery
script static short f_e8_m2_artillery_core_cnt( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
	if ( object_get_health(obj_artillery) > 0.0 ) then
		local short s_cnt = 0;
		if ( object_get_health(obj_core_01) > 0.0 ) then
			s_cnt = s_cnt + 1;
		end
		if ( object_get_health(obj_core_02) > 0.0 ) then
			s_cnt = s_cnt + 1;
		end
		if ( object_get_health(obj_core_03) > 0.0 ) then
			s_cnt = s_cnt + 1;
		end
		
		// return
		s_cnt;
	else
		0;
	end
end

// === xxx::: xxx
script static boolean f_e8_m2_artillery_core_shell_idle_check( object obj_core, object obj_shell )
	TRUE;
end

// === xxx::: xxx
script static boolean f_e8_m2_artillery_core_shell_active_check( object obj_core, object obj_shell )
	TRUE;
end

// === xxx::: xxx
script static boolean f_e8_m2_artillery_core_shell_shutdown_check( object obj_core, object obj_shell )
	( object_get_health(obj_core) <= 0.0 );
end

// === xxx::: xxx
script static void f_e8_m2_artillery_core_shell_shutdown_action( object obj_core, object obj_shell )
	dprint( "f_e8_m2_artillery_core_shell_destroy_action" );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: STATE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_ARTILLERY_STATE_NONE = 												0;
global short DEF_E8M2_ARTILLERY_STATE_KNOWN = 											1;
global short DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN = 							2;
global short DEF_E8M2_ARTILLERY_STATE_NEAR = 												3;
global short DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH = 									4;
global short DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK = 								5;
global short DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED = 								6;
global short DEF_E8M2_ARTILLERY_STATE_COMPLETE = 										999;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e8m2_artillery_state = 															DEF_E8M2_ARTILLERY_STATE_NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_state::: Sets the state of the artillery
script static void f_e8_m2_artillery_state( short s_state )

	if ( s_state > S_e8m2_artillery_state ) then
		dprint( "f_e8_m2_artillery_state" );
		inspect( s_state );
		S_e8m2_artillery_state = s_state;
	end
	
end

// === f_e8_m2_artillery_state::: Gets the state of the artillery
script static short f_e8_m2_artillery_state()
	S_e8m2_artillery_state;
end

// === f_e8_m2_artillery_state_damage_watch::: Watches different types of damage and sets a state when thresholds are met
script static void f_e8_m2_artillery_state_damage_watch( short s_state, object_name obj_object, real r_recent_current, real r_recent_total, real r_health, real r_shield )
local real r_dmg_recent = 0.0;
local real r_dmg_temp = 0.0;
local real r_dmg_recent_total = 0.0;

	repeat
	
		// sum up total recent damage
		r_dmg_temp = object_get_recent_damage_total( obj_object );
		if ( r_dmg_temp < r_dmg_recent ) then
			r_dmg_recent_total = r_dmg_recent_total + r_dmg_recent;
		end
		r_dmg_recent = r_dmg_temp;
		/*
		dprint( "f_e8_m2_artillery_state_damage_watch" );
		inspect( r_dmg_recent );
		inspect( r_recent_current );
		inspect( r_dmg_recent >= r_recent_current );
		inspect( r_dmg_recent_total );
		inspect( r_recent_total );
		inspect( r_dmg_recent >= r_recent_total );
		*/
	
		// wait damage to reach goal or change
		sleep_until(
				( f_e8_m2_artillery_state() >= s_state )
				or
				( r_dmg_recent != object_get_recent_damage_total(obj_object) )
				or
				( object_get_health(obj_object) <= 0.0 )
				or
				(
					( r_recent_current >= 0.0 )
					and
					( r_dmg_recent >= r_recent_current )
				)
				or
				(
					( r_recent_total >= 0.0 )
					and
					( r_dmg_recent_total >= r_recent_total )
				)
				or
				(
					( r_health >= 0.0 )
					and
					( r_health >= object_get_health(obj_object) )
				)
				or
				(
					( r_shield >= 0.0 )
					and
					( r_shield >= object_get_shield(obj_object) )
				)
			, 1 );
	
	until( 
			( f_e8_m2_artillery_state() >= s_state )
			or
			( object_get_health(obj_object) <= 0.0 )
			or
			(
				( r_recent_current >= 0.0 )
				and
				( r_dmg_recent >= r_recent_current )
			)
			or
			(
				( r_recent_total >= 0.0 )
				and
				( r_dmg_recent_total >= r_recent_total )
			)
			or
			(
				( r_health >= 0.0 )
				and
				( r_health >= object_get_health(obj_object) )
			)
			or
			(
				( r_shield >= 0.0 )
				and
				( r_shield >= object_get_shield(obj_object) )
			)
		, 1 );

	// set the new state
	dprint( "f_e8_m2_artillery_state_damage_watch: DONE" );
	f_e8_m2_artillery_state( s_state );

end



















script static void test_recent_damage( object_name obj_test )
local real r_dmg = object_get_recent_damage_total( obj_test );
local real r_dmg_tmp = 0.0;

	repeat

		sleep_until( r_dmg != object_get_recent_damage_total(obj_test), 1 );
		r_dmg_tmp = object_get_recent_damage_total( obj_test );
		if ( r_dmg_tmp > r_dmg ) then
			dprint( "-" );
			inspect( r_dmg_tmp );
			inspect( object_get_health(obj_test) );
			inspect( object_get_health(obj_test) * object_get_maximum_vitality(obj_test, TRUE) );
			//inspect( object_get_shield(obj_test) );
		end
		r_dmg = r_dmg_tmp;
		
	until( FALSE, 1 );

end
