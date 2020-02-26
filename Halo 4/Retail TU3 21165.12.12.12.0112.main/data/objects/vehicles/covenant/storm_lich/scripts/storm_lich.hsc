//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// OBJECT: 					storm_lich
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// STORM_LICH
// =================================================================================================
// =================================================================================================

// defines
script static string_id DEF_M_LICH_TURRET_BOTTOM_LEFT()			"l_b_turret";										end
script static string_id DEF_M_LICH_TURRET_BOTTOM_RIGHT()		"r_b_turret";										end
script static string_id DEF_M_LICH_TURRET_TOP_LEFT()				"l_t_turret";										end
script static string_id DEF_M_LICH_TURRET_TOP_RIGHT()				"r_t_turret";										end
script static string_id DEF_M_LICH_MAIN_FLOOR()							"spawn_mainfloor";							end
script static string_id DEF_M_LICH_GRAVLIFT_UP()						"storm_lich_grav_lift_up";			end
script static string_id DEF_M_LICH_GRAVLIFT_DOWN()					"storm_lich_grav_lift_down";		end
script static string_id DEF_M_LICH_GRAVLIFT_DROP()					"fx_grav_lift";									end
script static string_id DEF_M_LICH_PHANTOM_GRAVITY()				"m80_storm_lich_ride_gravity";	end
script static string_id DEF_M_LICH_POWER_CORE()							"power_core";										end
script static string_id DEF_M_LICH_CENTER_REFERENCE()				"lich_center_reference";				end

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Startup
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_init: init function
script startup instanced storm_lich_init()

	// init sub modules
	grav_phantom_init( );
	grav_lift_init( );
	local_physics_init( );
	core_init( );
/*
	ai_init( );
	damage_init( );
*/

end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: FX
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
script static effect FX_DAMAGE_DESTROY_EXPLOSION()
	'objects\vehicles\covenant\storm_space_phantom\fx\destruction\main_explosion.effect';
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: SFX
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
script static sound SFX_DAMAGE_DESTROY_EXPLOSION()
	'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_05';
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Local Physics
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables
instanced boolean B_local_physics_active 						= FALSE;

// functions
script static instanced void local_physics_init()
	
	local_physics_active_set( TRUE );
	
end

script static instanced void local_physics_active_set( boolean b_active )
	if ( local_physics_active_get() != b_active ) then
		B_local_physics_active = b_active;
		object_set_phantom_power( this, b_active );
		lich_inspect_b( "local_physics_active_set", b_active );
	end
end

script static instanced boolean local_physics_active_get()
	B_local_physics_active;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Gravity Phantom
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables

// functions
script static instanced void grav_phantom_init()
	
	grav_phantom_active_set( FALSE );
	
end

script static instanced void grav_phantom_active_set( boolean b_active )
	object_set_phantom_power( grav_phantom_obj(), b_active );
end

// === grav_phantom_obj::: Gets the grav phantom down object
script static instanced object grav_phantom_obj()
	object_at_marker( this, DEF_M_LICH_PHANTOM_GRAVITY() );
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Grav Lift
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// defines
script static real DEF_R_GRAVLIFT_DROP_DELAY_DEFAULT() 							1.0;													end
script static real DEF_R_GRAVLIFT_DROP_CLEANUP_DELAY_DEFAULT() 			5.0;													end

// variables

// functions
// === grav_lift_init::: <Turns the grav lifts off by default>
script static instanced void grav_lift_init()
	
	// setup sub modules
	grav_lift_door_init( );
	
	// set init state
	grav_lift_disable( );
	
end

// === grav_lift_disable::: <Turns the grav lifts off>
script static instanced void grav_lift_disable()
	grav_lift_up_active( FALSE );
	grav_lift_down_active( FALSE );
end

// === grav_lift_up_active::: <Activates or deactivates the UP grav lift>
//			b_enable [boolean] = <TRUE equals on, FALSE equals off>
script static instanced void grav_lift_up_active( boolean b_enable )

	if ( b_enable ) then
		//dprint( "Lich UP grav lift ON" );
		object_set_phantom_power( grav_lift_down_obj(), FALSE );
		object_set_function_variable(this, gravlift_fx_down, 0, 0); // turn off the down fx immediately
		object_set_phantom_power( grav_lift_up_obj(), TRUE );
		object_set_function_variable(this, gravlift_fx_up, 1, 0.5); // turn on the up fx with a slow ramp up
	end
	if ( not b_enable ) then
		//dprint( "Lich UP grav lift OFF" );
		object_set_phantom_power( grav_lift_up_obj(), FALSE );
		object_set_function_variable(this, gravlift_fx_up, 0, 0); // turn off the up fx immediately
	end
	
	// open/close the door based on the state
	grav_lift_door_state_open_set( b_enable );

end

// === grav_lift_down_active::: <Activates or deactivates the DOWN grav lift>
//			b_active [boolean] = <TRUE equals on, FALSE equals off>
script static instanced void grav_lift_down_active( boolean b_enable )

	if ( b_enable ) then
		//dprint( "Lich DOWN grav lift ON" );
		object_set_phantom_power( grav_lift_up_obj(), FALSE );
		object_set_function_variable(this, gravlift_fx_up, 0, 0); // turn off the up fx immediately
		object_set_phantom_power( grav_lift_down_obj(), TRUE );
		object_set_function_variable(this, gravlift_fx_down, 1, 0.5); // turn on the down fx with a slow ramp up
	end
	if ( not b_enable ) then
		//dprint( "Lich DOWN grav lift OFF" );
		object_set_phantom_power( grav_lift_down_obj(), FALSE );
		object_set_function_variable(this, gravlift_fx_down, 0, 0); // turn off the down fx immediately
	end
	
	// open/close the door based on the state
	grav_lift_door_state_open_set( b_enable );
	
end

// === grav_lift_down_obj::: Gets the grav lift down object
script static instanced object grav_lift_down_obj()
	object_at_marker( this, DEF_M_LICH_GRAVLIFT_DOWN() );
end

// === grav_lift_up_obj::: Gets the grav lift down object
script static instanced object grav_lift_up_obj()
	object_at_marker( this, DEF_M_LICH_GRAVLIFT_UP() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Grav Lift: Door
// -------------------------------------------------------------------------------------------------
// variables
instanced real R_grav_lift_door_open_time 						= 1.0;
instanced real R_grav_lift_door_close_time 						= 1.0;

// functions
// === grav_lift_door_init::: Initializes
script static instanced void grav_lift_door_init()
	grav_lift_door_close(0.0 );
end

// === grav_lift_door_open::: Opens the grav lift door with specific time
script static instanced void grav_lift_door_open( real r_time )

	// defaults
	if ( r_time < 0 ) then
		r_time = grav_lift_door_open_time_get( );
	end
	unit_open(this);
	// XXX check if not already open, animate door open
	
end
// === grav_lift_door_open_default::: Opens the grav lift door with default time
script static instanced void grav_lift_door_open_default()
	grav_lift_door_open( -1 );
end




// === grav_lift_door_close::: Closes the grav lift door with specific time
script static instanced void grav_lift_door_close( real r_time )

	// defaults
	if ( r_time < 0 ) then
		r_time = grav_lift_door_close_time_get( );
	end
	
	// XXX check if not already closed, animate door closed
	unit_close(this);
end
// === grav_lift_door_close_default::: Closes the grav lift door with default time
script static instanced void grav_lift_door_close_default()
	grav_lift_door_close( -1 );
end

// === grav_lift_door_close::: Sets the grav lift door default open time
script static instanced void grav_lift_door_open_time_set( real r_time )
	R_grav_lift_door_open_time = r_time;
end
// === grav_lift_door_open_time_get::: Gets the  grav lift door default close time
script static instanced real grav_lift_door_open_time_get()
	// return
	R_grav_lift_door_open_time;
end

// === grav_lift_door_close::: Sets the grav lift door default close time
script static instanced void grav_lift_door_close_time_set( real r_time )
	R_grav_lift_door_close_time = r_time;
end
// === grav_lift_door_close_time_get::: Gets the  grav lift door default open time
script static instanced real grav_lift_door_close_time_get()
	// return
	R_grav_lift_door_close_time;
end

// === grav_lift_door_state_open_time_set::: Sets the open state of the gav lift door
script static instanced void grav_lift_door_state_open_time_set( boolean b_open, real r_time )
	
	if ( b_open ) then
		grav_lift_door_open( r_time );
	end
	if ( not b_open ) then
		grav_lift_door_close( r_time );
	end
	
end
// === grav_lift_door_state_open_set::: Sets the open state of the gav lift door
script static instanced void grav_lift_door_state_open_set( boolean b_open )
	
	grav_lift_door_state_open_time_set( b_open, -1 );
	
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Grav Lift: Drop
// -------------------------------------------------------------------------------------------------
script static instanced void grav_lift_drop_unit( ai ai_unit, real r_delay_pre, real r_delay_post, real r_delay_cleanup, boolean b_spawn_auto )

	// check auto spawn
	if ( b_spawn_auto and (ai_living_count(ai_unit) == 0) ) then
		ai_place_in_limbo( ai_unit );
		sleep_until( ai_living_count(ai_unit) > 0, 1 );
	end

	if ( ai_living_count(ai_unit) > 0 ) then
		// defaults
		if ( r_delay_pre < 0.0 ) then
			r_delay_pre = DEF_R_GRAVLIFT_DROP_DELAY_DEFAULT();
		end
		if ( r_delay_post < 0.0 ) then
			r_delay_post = DEF_R_GRAVLIFT_DROP_DELAY_DEFAULT();
		end
		if ( r_delay_cleanup < 0.0 ) then
			r_delay_cleanup = DEF_R_GRAVLIFT_DROP_CLEANUP_DELAY_DEFAULT();
		end

		// wait out the pre-delay
		sleep_s( r_delay_pre );

		// check if in limbo
		if ( ai_in_limbo_count(ai_unit) > 0 ) then
			ai_exit_limbo( ai_unit );
			sleep_until( ai_in_limbo_count(ai_unit) == 0, 1 );
		end
	
		// disable falling damage for their trip down
		unit_falling_damage_disable( ai_unit, TRUE );
	
		// attach unit to the	drop location
		objects_attach( this, DEF_M_LICH_GRAVLIFT_DROP(), ai_unit, "" );
		sleep( 1 );
	
		// now drop the unit
		objects_detach( this, ai_unit );
	
		// setup grav lift post cleanup
		thread( sys_grav_lift_drop_unit_cleanup(ai_unit, r_delay_cleanup) );
	
		// wait out the post-delay
		sleep_s( r_delay_post );
	end

end

script static void sys_grav_lift_drop_unit_cleanup( ai ai_unit, real r_delay_cleanup )

	sleep_s( r_delay_cleanup );
	unit_falling_damage_disable( ai_unit, TRUE );

end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turrets
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
script static short DEF_S_TURRET_BOTTOM_CNT() 2;																									end
script static short DEF_S_TURRET_TOP_CNT() 		2;																									end
script static short DEF_S_TURRET_LEFT_CNT() 	2;																									end
script static short DEF_S_TURRET_RIGHT_CNT() 	2;																									end
script static short DEF_S_TURRET_CNT() 				DEF_S_TURRET_BOTTOM_CNT() - DEF_S_TURRET_TOP_CNT();	end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Object
// -------------------------------------------------------------------------------------------------
// functions
// === turret_bottom_left_obj::: Gets a turret object
script static instanced object turret_bottom_left_obj()
	object_at_marker( this, DEF_M_LICH_TURRET_BOTTOM_LEFT() );
end
// === turret_bottom_right_obj::: Gets a turret object
script static instanced object turret_bottom_right_obj()
	object_at_marker( this, DEF_M_LICH_TURRET_BOTTOM_RIGHT() );
end
// === turret_top_left_obj::: Gets a turret object
script static instanced object turret_top_left_obj()
	object_at_marker( this, DEF_M_LICH_TURRET_TOP_LEFT() );
end
// === turret_top_right_obj::: Gets a turret object
script static instanced object turret_top_right_obj()
	object_at_marker( this, DEF_M_LICH_TURRET_TOP_RIGHT() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: attach
// -------------------------------------------------------------------------------------------------
// === turret_obj_bottom_left_attach::: Attaches object to turret marker if nothing is there
//		RETURN: [BOOLEAN] TRUE; if an object was attached
script static instanced boolean turret_obj_bottom_left_attach( object obj_attach, string_id sid_attach_marker, boolean b_multi_attach )
	object_attach( DEF_M_LICH_TURRET_BOTTOM_LEFT(), obj_attach, sid_attach_marker, b_multi_attach );
end

// === turret_obj_bottom_right_attach::: Attaches object to turret marker if nothing is there
//		RETURN: [BOOLEAN] TRUE; if an object was attached
script static instanced boolean turret_obj_bottom_right_attach( object obj_attach, string_id sid_attach_marker, boolean b_multi_attach )
	object_attach( DEF_M_LICH_TURRET_BOTTOM_RIGHT(), obj_attach, sid_attach_marker, b_multi_attach );
end

// === turret_obj_top_left_attach::: Attaches object to turret marker if nothing is there
//		RETURN: [BOOLEAN] TRUE; if an object was attached
script static instanced boolean turret_obj_top_left_attach( object obj_attach, string_id sid_attach_marker, boolean b_multi_attach )
	object_attach( DEF_M_LICH_TURRET_TOP_LEFT(), obj_attach, sid_attach_marker, b_multi_attach );
end

// === turret_obj_top_right_attach::: Attaches object to turret marker if nothing is there
//		RETURN: [BOOLEAN] TRUE; if an object was attached
script static instanced boolean turret_obj_top_right_attach( object obj_attach, string_id sid_attach_marker, boolean b_multi_attach )
	object_attach( DEF_M_LICH_TURRET_TOP_RIGHT(), obj_attach, sid_attach_marker, b_multi_attach );
end

// === object_attach::: Attaches object to the lich markers
//		RETURN: [BOOLEAN] TRUE; if an object was attached
script static instanced boolean object_attach( string_id sid_lich_marker, object obj_attach, string_id sid_attach_marker, boolean b_multi_attach )
local boolean b_return = FALSE;

	if ( b_multi_attach or (object_at_marker(this, sid_lich_marker) == NONE) ) then
		objects_attach( this, sid_lich_marker, obj_attach, sid_attach_marker );
		b_return = TRUE;
	end
	
	// return
	b_return;
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Unit
// -------------------------------------------------------------------------------------------------
// functions
// === turret_unit_bottom_left_get::: Gets a turret unit
script static instanced unit turret_bottom_left_unit()
	unit( turret_bottom_left_obj() );
end
// === turret_unit_bottom_right_get::: Gets a turret unit
script static instanced unit turret_bottom_right_unit()
	unit( turret_bottom_right_obj() );
end
// === turret_unit_top_left_get::: Gets a turret unit
script static instanced unit turret_top_left_unit()
	unit( turret_top_left_obj() );
end
// === turret_unit_top_right_get::: Gets a turret unit
script static instanced unit turret_top_right_unit()
	unit( turret_top_right_obj() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied
// -------------------------------------------------------------------------------------------------
// === turret_bottom_left_occupied::: Checks if the turret is occupied
script static instanced boolean turret_bottom_left_occupied()
	vehicle_test_seat( turret_bottom_left_unit(), "" );
end
// === turret_bottom_right_occupied::: Checks if the turret is occupied
script static instanced boolean turret_bottom_right_occupied()
	vehicle_test_seat( turret_bottom_right_unit(), "" );
end
// === turret_top_left_occupied::: Checks if the turret is occupied
script static instanced boolean turret_top_left_occupied()
	vehicle_test_seat( turret_top_left_unit(), "" );
end
// === turret_top_right_occupied::: Checks if the turret is occupied
script static instanced boolean turret_top_right_occupied()
	vehicle_test_seat( turret_top_right_unit(), "" );
end
// === turret_bottom_occupied::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_bottom_occupied( boolean b_all )
	( (b_all) and (turret_bottom_occupied_cnt() == DEF_S_TURRET_BOTTOM_CNT()) ) or ( (not b_all) and (turret_bottom_occupied_cnt() > 1) );
end
// === turret_top_occupied::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_top_occupied( boolean b_all )
	( (b_all) and (turret_top_occupied_cnt() == DEF_S_TURRET_TOP_CNT()) ) or ( (not b_all) and (turret_top_occupied_cnt() > 1) );
end
// === turret_left_occupied::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_left_occupied( boolean b_all )
	( (b_all) and (turret_left_occupied_cnt() == DEF_S_TURRET_LEFT_CNT()) ) or ( (not b_all) and (turret_left_occupied_cnt() > 1) );
end
// === turret_right_occupied::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_right_occupied( boolean b_all )
	( (b_all) and (turret_right_occupied_cnt() == DEF_S_TURRET_RIGHT_CNT()) ) or ( (not b_all) and (turret_right_occupied_cnt() > 1) );
end
// === turret_occupied::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_occupied( boolean b_all )
	( (b_all) and (turret_occupied_cnt() == DEF_S_TURRET_CNT()) ) or ( (not b_all) and (turret_occupied_cnt() > 1) );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: cnt
// -------------------------------------------------------------------------------------------------
// === turret_bottom_occupied_cnt::: Counts how many turrets in a section are occupied
script static instanced short turret_bottom_occupied_cnt()
local short s_return = 0;
	if ( turret_bottom_left_occupied() ) then
		s_return = s_return + 1;
	end
	if ( turret_bottom_right_occupied() ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_top_occupied_cnt::: Counts how many turrets in a section are occupied
script static instanced short turret_top_occupied_cnt()
local short s_return = 0;
	if ( turret_top_left_occupied() ) then
		s_return = s_return + 1;
	end
	if ( turret_top_right_occupied() ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_left_occupied_cnt::: Counts how many turrets in a section are occupied
script static instanced short turret_left_occupied_cnt()
local short s_return = 0;
	if ( turret_bottom_left_occupied() ) then
		s_return = s_return + 1;
	end
	if ( turret_top_left_occupied() ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end

// === turret_right_occupied_cnt::: Counts how many turrets in a section are occupied
script static instanced short turret_right_occupied_cnt()
local short s_return = 0;
	if ( turret_bottom_right_occupied() ) then
		s_return = s_return + 1;
	end
	if ( turret_top_right_occupied() ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end

// === turret_occupied_cnt::: Counts how many turrets in a section are occupied
script static instanced short turret_occupied_cnt()
	// return
	turret_bottom_occupied_cnt() + turret_top_occupied_cnt();
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: Unit
// -------------------------------------------------------------------------------------------------
// === turret_bottom_left_occupied_unit::: Checks if the turret is occupied by a specific unit
//			u_test = Unit  to test the seat occupied against
script static instanced boolean turret_bottom_left_occupied_unit( unit u_test )
	vehicle_test_seat_unit( turret_bottom_left_unit(), "", u_test );
end
// === turret_bottom_right_occupied_unit::: Checks if the turret is occupied by a specific unit
//			u_test = Unit  to test the seat occupied against
script static instanced boolean turret_bottom_right_occupied_unit( unit u_test )
	vehicle_test_seat_unit( turret_bottom_right_unit(), "", u_test );
end
// === turret_top_left_occupied_unit::: Checks if the turret is occupied by a specific unit
//			u_test = Unit  to test the seat occupied against
script static instanced boolean turret_top_left_occupied_unit( unit u_test )
	vehicle_test_seat_unit( turret_top_left_unit(), "", u_test );
end
// === turret_top_right_occupied_unit::: Checks if the turret is occupied by a specific unit
//			u_test = Unit  to test the seat occupied against
script static instanced boolean turret_top_right_occupied_unit( unit u_test )
	vehicle_test_seat_unit( turret_top_right_unit(), "", u_test );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: Unit List
// -------------------------------------------------------------------------------------------------
// === turret_bottom_left_occupied_unit_list::: Checks if the turret is occupied by a specific unit list
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced boolean turret_bottom_left_occupied_unit_list( object_list ol_unit_list )
	vehicle_test_seat_unit_list( turret_bottom_left_unit(), "", ol_unit_list );
end
// === turret_bottom_right_occupied_unit_list::: Checks if the turret is occupied by a specific unit list
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced boolean turret_bottom_right_occupied_unit_list( object_list ol_unit_list )
	vehicle_test_seat_unit_list( turret_bottom_right_unit(), "", ol_unit_list );
end
// === turret_top_left_occupied_unit_list::: Checks if the turret is occupied by a specific unit list
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced boolean turret_top_left_occupied_unit_list( object_list ol_unit_list )
	vehicle_test_seat_unit_list( turret_top_left_unit(), "", ol_unit_list );
end
// === turret_top_right_occupied_unit_list::: Checks if the turret is occupied by a specific unit list
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced boolean turret_top_right_occupied_unit_list( object_list ol_unit_list )
	vehicle_test_seat_unit_list( turret_top_right_unit(), "", ol_unit_list );
end
// === turret_bottom_occupied_unit_list::: Checks if a section of turrets is occupied
//			ol_unit_list = Object list of units to test the seat occupied against
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_bottom_occupied_unit_list( object_list ol_unit_list, boolean b_all )
	( (b_all) and (turret_bottom_occupied_unit_list_cnt(ol_unit_list) == DEF_S_TURRET_BOTTOM_CNT()) ) or ( (not b_all) and (turret_bottom_occupied_unit_list_cnt(ol_unit_list) > 1) );
end
// === turret_top_occupied_unit_list::: Checks if a section of turrets is occupied
//			ol_unit_list = Object list of units to test the seat occupied against
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_top_occupied_unit_list( object_list ol_unit_list, boolean b_all )
	( (b_all) and (turret_top_occupied_unit_list_cnt(ol_unit_list) == DEF_S_TURRET_TOP_CNT()) ) or ( (not b_all) and (turret_top_occupied_unit_list_cnt(ol_unit_list) > 1) );
end
// === turret_left_occupied_unit_list::: Checks if a section of turrets is occupied
//			ol_unit_list = Object list of units to test the seat occupied against
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_left_occupied_unit_list( object_list ol_unit_list, boolean b_all )
	( (b_all) and (turret_left_occupied_unit_list_cnt(ol_unit_list) == DEF_S_TURRET_LEFT_CNT()) ) or ( (not b_all) and (turret_left_occupied_unit_list_cnt(ol_unit_list) > 1) );
end
// === turret_right_occupied_unit_list::: Checks if a section of turrets is occupied
//			ol_unit_list = Object list of units to test the seat occupied against
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_right_occupied_unit_list( object_list ol_unit_list, boolean b_all )
	( (b_all) and (turret_right_occupied_unit_list_cnt(ol_unit_list) == DEF_S_TURRET_RIGHT_CNT()) ) or ( (not b_all) and (turret_right_occupied_unit_list_cnt(ol_unit_list) > 1) );
end
// === turret_occupied_unit_list::: Checks if a section of turrets is occupied
//			ol_unit_list = Object list of units to test the seat occupied against
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_occupied_unit_list( object_list ol_unit_list, boolean b_all )
	( (b_all) and (turret_occupied_unit_list_cnt(ol_unit_list) == DEF_S_TURRET_CNT()) ) or ( (not b_all) and (turret_occupied_unit_list_cnt(ol_unit_list) > 1) );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: Unit List: cnt
// -------------------------------------------------------------------------------------------------
// === turret_bottom_occupied_unit_list_cnt::: Counts how many turrets in a section are occupied
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced short turret_bottom_occupied_unit_list_cnt( object_list ol_unit_list )
local short s_return = 0;
	if ( turret_bottom_left_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end
	if ( turret_bottom_right_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_top_occupied_unit_list_cnt::: Counts how many turrets in a section are occupied
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced short turret_top_occupied_unit_list_cnt( object_list ol_unit_list )
local short s_return = 0;
	if ( turret_top_left_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end
	if ( turret_top_right_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_left_occupied_unit_list_cnt::: Counts how many turrets in a section are occupied
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced short turret_left_occupied_unit_list_cnt( object_list ol_unit_list )
local short s_return = 0;
	if ( turret_bottom_left_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end
	if ( turret_top_left_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_right_occupied_unit_list_cnt::: Counts how many turrets in a section are occupied
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced short turret_right_occupied_unit_list_cnt( object_list ol_unit_list )
local short s_return = 0;
	if ( turret_bottom_right_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end
	if ( turret_top_right_occupied_unit_list(ol_unit_list) ) then
		s_return = s_return + 1;
	end

	// return
	s_return;
end
// === turret_occupied_unit_list_cnt::: Counts how many turrets in a section are occupied
//			ol_unit_list = Object list of units to test the seat occupied against
script static instanced short turret_occupied_unit_list_cnt( object_list ol_unit_list )
	// return
	turret_bottom_occupied_unit_list_cnt( ol_unit_list ) + turret_top_occupied_unit_list_cnt( ol_unit_list );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: Players
// -------------------------------------------------------------------------------------------------
// === turret_bottom_left_occupied_players::: Checks if the turret is occupied by a player
script static instanced boolean turret_bottom_left_occupied_players()
	turret_bottom_left_occupied_unit_list( Players() );
end
// === turret_bottom_right_occupied_players::: Checks if the turret is occupied by a player
script static instanced boolean turret_bottom_right_occupied_players()
	turret_bottom_right_occupied_unit_list( Players() );
end
// === turret_top_left_occupied_players::: Checks if the turret is occupied by a player
script static instanced boolean turret_top_left_occupied_players()
	turret_top_left_occupied_unit_list( Players() );
end
// === turret_top_right_occupied_players::: Checks if the turret is occupied by a player
script static instanced boolean turret_top_right_occupied_players()
	turret_top_right_occupied_unit_list( Players() );
end
// === turret_bottom_occupied_players::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_bottom_occupied_players( boolean b_all )
	( (b_all) and (turret_bottom_occupied_players_cnt() == DEF_S_TURRET_BOTTOM_CNT()) ) or ( (not b_all) and (turret_bottom_occupied_players_cnt() > 1) );
end
// === turret_top_occupied_players::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_top_occupied_players( boolean b_all )
	( (b_all) and (turret_top_occupied_players_cnt() == DEF_S_TURRET_TOP_CNT()) ) or ( (not b_all) and (turret_top_occupied_players_cnt() > 1) );
end
// === turret_left_occupied_players::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_left_occupied_players( boolean b_all )
	( (b_all) and (turret_left_occupied_players_cnt() == DEF_S_TURRET_LEFT_CNT()) ) or ( (not b_all) and (turret_left_occupied_players_cnt() > 1) );
end
// === turret_right_occupied_players::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_right_occupied_players( boolean b_all )
	( (b_all) and (turret_right_occupied_players_cnt() == DEF_S_TURRET_RIGHT_CNT()) ) or ( (not b_all) and (turret_right_occupied_players_cnt() > 1) );
end
// === turret_occupied_players::: Checks if a section of turrets is occupied
//			b_all = TRUE; Requires all to be occupied, FALSE; requires at least one to be occupied
script static instanced boolean turret_occupied_players( boolean b_all )
	( (b_all) and (turret_occupied_players_cnt() == DEF_S_TURRET_CNT()) ) or ( (not b_all) and (turret_occupied_players_cnt() > 1) );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turret: Occupied: Player: cnt
// -------------------------------------------------------------------------------------------------
// === turret_bottom_occupied_players_cnt::: Counts how many turrets in a section are occupied
//			ol_players = Object list of units to test the seat occupied against
script static instanced short turret_bottom_occupied_players_cnt()
	turret_bottom_occupied_unit_list_cnt( Players() );
end
// === turret_top_occupied_players_cnt::: Counts how many turrets in a section are occupied
//			ol_players = Object list of units to test the seat occupied against
script static instanced short turret_top_occupied_players_cnt()
	turret_top_occupied_unit_list_cnt( Players() );
end
// === turret_left_occupied_players_cnt::: Counts how many turrets in a section are occupied
//			ol_players = Object list of units to test the seat occupied against
script static instanced short turret_left_occupied_players_cnt()
	turret_left_occupied_unit_list_cnt( Players() );
end
// === turret_right_occupied_players_cnt::: Counts how many turrets in a section are occupied
//			ol_players = Object list of units to test the seat occupied against
script static instanced short turret_right_occupied_players_cnt()
	turret_right_occupied_unit_list_cnt( Players() );
end
// === turret_occupied_players_cnt::: Counts how many turrets in a section are occupied
//			ol_players = Object list of units to test the seat occupied against
script static instanced short turret_occupied_players_cnt()
	turret_occupied_unit_list_cnt( Players() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Turrets: AI Load
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === turret_ai_load::: Loads a gunner into a turret
script static instanced void turret_ai_load( string_id sid_seat, ai ai_gunner, boolean b_spawn_auto )
	dprint( "storm_lich: turret_ai_load" );
	if ( object_at_marker(this, sid_seat) != NONE ) then

		if ( b_spawn_auto and (ai_living_count(ai_gunner) == 0) ) then
			dprint( "storm_lich: turret_ai_load: SPAWNING" );
			ai_place_in_limbo( ai_gunner );
			sleep_until( ai_living_count(ai_gunner) > 0, 1 );
		end
		 
		if ( ai_living_count(ai_gunner) > 0 ) then
			dprint( "storm_lich: turret_ai_load: LOADING" );
			// exit the AI from limbo
			ai_exit_limbo( ai_gunner );

			vehicle_load_magic( object_at_marker(this, sid_seat), "", ai_get_object(ai_gunner) );

		end
		
	end

end

// === turret_ai_top_left_load::: Loads a gunner into top left turret
script static instanced void turret_ai_top_left_load( ai ai_gunner, boolean b_spawn_auto )
	turret_ai_load( DEF_M_LICH_TURRET_TOP_LEFT(), ai_gunner, b_spawn_auto );
end

// === turret_ai_top_right_load::: Loads a gunner into top right turret
script static instanced void turret_ai_top_right_load( ai ai_gunner, boolean b_spawn_auto )
	turret_ai_load( DEF_M_LICH_TURRET_TOP_RIGHT(), ai_gunner, b_spawn_auto );
end

// === turret_ai_top_load::: Loads a gunner into both top turret
script static instanced void turret_ai_top_load( ai ai_gunner_l, ai ai_gunner_r, boolean b_spawn_auto )
	turret_ai_top_left_load( ai_gunner_l, b_spawn_auto );
	turret_ai_top_right_load( ai_gunner_r, b_spawn_auto );
end

// === turret_ai_bottom_left_load::: Loads a gunner into bottom left turret
script static instanced void turret_ai_bottom_left_load( ai ai_gunner, boolean b_spawn_auto )
	turret_ai_load( DEF_M_LICH_TURRET_BOTTOM_LEFT(), ai_gunner, b_spawn_auto );
end

// === turret_ai_bottom_right_load::: Loads a gunner into bottom right turret
script static instanced void turret_ai_bottom_right_load( ai ai_gunner, boolean b_spawn_auto )
	turret_ai_load( DEF_M_LICH_TURRET_BOTTOM_RIGHT(), ai_gunner, b_spawn_auto );
end

// === turret_ai_bottom_load::: Loads a gunner into both bottom turret
script static instanced void turret_ai_bottom_load( ai ai_gunner_l, ai ai_gunner_r, boolean b_spawn_auto )
	turret_ai_bottom_left_load( ai_gunner_l, b_spawn_auto );
	turret_ai_bottom_right_load( ai_gunner_r, b_spawn_auto );
end

// === turret_ai_all::: Loads a gunner into all turrets
script static instanced void turret_ai_all( ai ai_gunner_top_l, ai ai_gunner_top_r, ai ai_gunner_bottom_l, ai ai_gunner_bottom_r, boolean b_spawn_auto )
	turret_ai_top_left_load( ai_gunner_top_l, b_spawn_auto );
	turret_ai_top_right_load( ai_gunner_top_r, b_spawn_auto );
	turret_ai_bottom_left_load( ai_gunner_bottom_l, b_spawn_auto );
	turret_ai_bottom_right_load( ai_gunner_bottom_r, b_spawn_auto );
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables
script static real DEF_R_DAMAGE_HEALTH_DEFAULT() 							2000.0;			end
script static string_id DEF_R_DAMAGE_TARGET() 								"default"; 	end

script static real DEF_R_DAMAGE_LOW_RATIO_DEFAULT()						0.75;	 			end
script static real DEF_R_DAMAGE_MEDIUM_RATIO_DEFAULT()				0.50;	 			end
script static real DEF_R_DAMAGE_HIGH_RATIO_DEFAULT()					0.25;	 			end
script static real DEF_R_DAMAGE_DESTROYED_DEFAULT()						0.001;			end

instanced long L_damage_transition_thread	= 									0;

// functions
/*
// === damage_init::: <Turns the grav lifts off by default>
script static instanced void damage_init()
	
end
*/

// === damage_obj::: Gets the object to apply damage to
script static instanced object damage_obj()
	object_at_marker( this, DEF_R_DAMAGE_TARGET() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Get
// -------------------------------------------------------------------------------------------------
// === damage_value_get::: Gets the health value of the ship
//		RETURN: [REAL] Damage health value of the vehicle
script static instanced real damage_value_get()
local real l_return = 0.0;

	l_return = DEF_R_DAMAGE_HEALTH_DEFAULT() * object_get_health( damage_obj() );

	// this helps round out some math errors	
	if ( l_return < DEF_R_DAMAGE_DESTROYED_DEFAULT() ) then
		l_return = 0.0;
	end
	
	// return
	l_return;
end

// === damage_ratio_get::: Gets the health ratio of the ship
//		RETURN: [REAL] Damage health ratio of the vehicle
script static instanced real damage_ratio_get()
local real l_return = 0.0;

	l_return = object_get_health( damage_obj() );

	// this helps round out some math errors	
	if ( l_return < DEF_R_DAMAGE_DESTROYED_DEFAULT() ) then
		l_return = 0.0;
	end
	
	// return
	l_return;
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Convert
// -------------------------------------------------------------------------------------------------
// === damage_ratio_convert_to_value::: Converts health ratio to a health value
//		RETURN: [REAL] Health ratio of the value
script static instanced real damage_ratio_convert_to_value( real r_ratio )
	r_ratio * DEF_R_DAMAGE_HEALTH_DEFAULT();
end

// === damage_value_convert_to_ratio::: Converts health value to a health ratio
//		RETURN: [REAL] Health ratio of the value
script static instanced real damage_value_convert_to_ratio( real r_value )
	// RETURN
	r_value / DEF_R_DAMAGE_HEALTH_DEFAULT();
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Apply
// -------------------------------------------------------------------------------------------------
// === damage_value_apply::: Applies a value of damage to the ship
script static instanced void damage_value_apply( real r_value )
	if ( r_value > 0.0 ) then
		damage_object( damage_obj(), "", r_value );
		lich_inspect_r( "damage_value_apply: CURRENT HEALTH RATIO", damage_ratio_get() );
	end
end

// === damage_ratio_apply::: Applies a ratio of damage to the ship
script static instanced void damage_ratio_apply( real r_ratio )
	damage_value_apply( damage_ratio_convert_to_value(r_ratio) );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Set
// -------------------------------------------------------------------------------------------------
// === damage_value_set::: Sets the damage value of the ship
script static instanced void damage_value_set( real r_value )
	damage_value_apply( damage_value_get() - r_value );
end

// === damage_ratio_set::: Sets the damage ratio of the ship
script static instanced void damage_ratio_set( real r_ratio )
	damage_ratio_apply( damage_ratio_get() - r_ratio );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: State
// -------------------------------------------------------------------------------------------------
script static instanced boolean damage_check_low( boolean b_state_only )
	( damage_ratio_get() <= DEF_R_DAMAGE_LOW_RATIO_DEFAULT() ) and ( (not b_state_only) or (damage_ratio_get() > DEF_R_DAMAGE_MEDIUM_RATIO_DEFAULT()) );
end
script static instanced boolean damage_check_medium( boolean b_state_only )
	( damage_ratio_get() <= DEF_R_DAMAGE_MEDIUM_RATIO_DEFAULT() ) and ( (not b_state_only) or (damage_ratio_get() > DEF_R_DAMAGE_HIGH_RATIO_DEFAULT()) );
end
script static instanced boolean damage_check_high( boolean b_state_only )
	( damage_ratio_get() <= DEF_R_DAMAGE_HIGH_RATIO_DEFAULT() ) and ( (not b_state_only) or (damage_ratio_get() > DEF_R_DAMAGE_DESTROYED_DEFAULT()) );
end
script static instanced boolean damage_check_destroyed()
	( damage_ratio_get() <= DEF_R_DAMAGE_DESTROYED_DEFAULT() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Destroy
// -------------------------------------------------------------------------------------------------
// === damage_destroy::: Handles destroying the lich
//		b_destroy [boolean] - TRUE; will call object_destroy on the "this".  Otherwise it will only be hidden
script static instanced void damage_destroy( trigger_volume tv_ship, boolean b_destroy )

	// play the fx
	effect_new_on_object_marker( FX_DAMAGE_DESTROY_EXPLOSION(), this, "storm_lich_damage_fx" );
	
	f_screenshake_event_volume( tv_ship, DEF_R_SCREENSHAKE_EVENT_INTENSITY_VERY_HIGH(), DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW(), -0.25, -1, 1.0, SFX_DAMAGE_DESTROY_EXPLOSION() );
	
	// wait a brief moment
	sleep_s( 0.125 );
	
	// kill everyone in the ship
	thread( triggerobjs_kill_ai(tv_ship, FALSE) );
	
	// wait a brief moment for the explosion to go off
	sleep_s( 0.25 );
	 
	// switch to the destroyed model
	object_set_variant( this, "destroyed" );
	sleep( 1 );
	object_hide( this, TRUE );
	
	// automatically delete the ship if requested to do so
	if ( b_destroy ) then
		object_destroy( this );
	end
	
end

// === damage_destroy_auto_ratio::: Auto trigger destruction of the ship when damage <= a certain ratio
//		r_ratio [real] - Health ratio to trigger ship destruction
//		b_destroy [boolean] - See "damage_destroy" function
script static instanced long damage_destroy_auto_ratio( real r_ratio, trigger_volume tv_ship, boolean b_destroy )
	thread( sys_damage_destroy_auto_ratio(r_ratio, tv_ship, b_destroy) );
end

// === damage_destroy_auto_value::: Auto trigger destruction of the ship when damage <= a certain value
//		r_value [real] - Health value to trigger ship destruction
//		b_destroy [boolean] - See "damage_destroy" function
script static instanced long damage_destroy_auto_value( real r_value, trigger_volume tv_ship, boolean b_destroy )
	damage_destroy_auto_ratio( damage_value_convert_to_ratio(r_value), tv_ship, b_destroy );
end

// === sys_damage_destroy_auto_ratio::: System that manages auto destroying the ship
script static instanced void sys_damage_destroy_auto_ratio( real r_ratio, trigger_volume tv_ship, boolean b_destroy )

	// wait for damage to be <= the r_ratio
	sleep_until( damage_ratio_get() <= r_ratio, 1 );

	damage_destroy( tv_ship, b_destroy );
	
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Transition
// -------------------------------------------------------------------------------------------------
// === damage_transition_active_check::: Checks if a damage transition thread is active
//		RETURN: [BOOLEAN] TRUE; damage transition thread is active
script static instanced boolean damage_transition_active_check()
	// return
	isthreadvalid( L_damage_transition_thread );
end

// === damage_value_transition::: Transitions the damage value over time
//		r_value_start [REAL] - Starting damage value
//			[DEFAULT: < 0] = Current damage value; damage_value_get()
//		r_value_end [REAL] - Ending damage value
//			[DEFAULT: < 0] = 0.0; Full damage
//		r_time [REAL] - Time (seconds) to transition the damage
//		RETURN: [LONG] Thread ID for the transition
script static instanced long damage_value_transition( real r_value_start, real r_value_end, real r_time )

	// defaults
	if ( r_value_start < 0 ) then
		r_value_start = damage_value_get( );
	end
	if ( r_value_end < 0 ) then
		r_value_end = 0.0;
	end

	// Thread & Return
	thread( sys_damage_value_transition(r_value_start, r_value_end, r_time) );
	
end

// === damage_ratio_transition::: Transitions the damage ratio over time
//		r_ratio_start [REAL] - Starting damage ratio
//			[DEFAULT: < 0] = Current damage ratio; damage_ratio_get()
//		r_ratio_end [REAL] - Ending damage ratio
//			[DEFAULT: < 0] = 0.0; Full damage
//		r_time [REAL] - Time (seconds) to transition the damage
//		RETURN: [LONG] Thread ID for the transition
script static instanced long damage_ratio_transition( real r_ratio_start, real r_ratio_end, real r_time )
	
	// defaults
	if ( r_ratio_start < 0 ) then
		r_ratio_start = damage_ratio_get( );
	end
	if ( r_ratio_end < 0 ) then
		r_ratio_end = 0.0;
	end
	
	damage_value_transition( damage_ratio_convert_to_value(r_ratio_start), damage_ratio_convert_to_value(r_ratio_end), r_time );
	
end

// === sys_damage_value_transition::: System function that transitions the damage value over time
//		NOTE: DO NOT USE!
script static instanced void sys_damage_value_transition( real r_value_start, real r_value_end, real r_time )
static long l_time_start = 0;
static long l_time_end = 0;
static real r_health_range = 0.0;
static real r_health_delta = 0.0;
static real r_time_range = 0.0;

	// check if a damage transition thread is already active and kill it
	if ( damage_transition_active_check() ) then
		kill_thread( L_damage_transition_thread );
	end
	// set this as the active thread
	sys_damage_transition_active_set( GetCurrentThreadId() );

	// get start time	
	l_time_start = game_tick_get();

	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_time );

	// setup variables
	r_health_range = r_value_end - r_value_start;
	r_time_range = l_time_end - l_time_start;

	if ( (r_health_range > 0.001) and (r_time_range > 0.001) ) then
	
		repeat
		
			r_health_delta = real( game_tick_get()-l_time_start ) / r_time_range;
			
			// set the health value
			damage_value_set( r_value_start + (r_health_range * r_health_delta) );
			
		until ( game_tick_get() >= l_time_end, 1 );
		
	end
	damage_value_set( r_value_end );

end

// === sys_damage_transition_active_set::: Sets the current damage thread id
script static instanced void sys_damage_transition_active_set( long l_thread )
	L_damage_transition_thread = l_thread;
end


// -------------------------------------------------------------------------------------------------
// STORM_LICH: Damage: Sync
// -------------------------------------------------------------------------------------------------
script static instanced long damage_ratio_device_sync_pos( device dm_machine, real r_pos_start, real r_pos_end, real r_ratio_start, real r_ratio_end )
	
	// defaults
	if ( r_ratio_start < 0 ) then
		r_ratio_start = damage_ratio_get( );
	end
	if ( r_ratio_end < 0 ) then
		r_ratio_end = 0.0;
	end

	// use value function for pipeline
	damage_value_device_sync_pos( dm_machine, r_pos_start, r_pos_end, damage_ratio_convert_to_value(r_ratio_start), damage_ratio_convert_to_value(r_ratio_end) );

end
script static instanced long damage_value_device_sync_pos( device dm_machine, real r_pos_start, real r_pos_end, real r_value_start, real r_value_end )

	// defaults
	if ( r_value_start < 0 ) then
		r_value_start = damage_value_get( );
	end
	if ( r_value_end < 0 ) then
		r_value_end = 0.0;
	end
	if ( r_pos_start < 0 ) then
		r_pos_start = 0.0;
	end
	if ( r_pos_end < 0 ) then
		r_pos_end = 1.0;
	end

	if ( r_pos_start <= r_pos_end ) then
		thread( sys_damage_value_device_sync_pos( dm_machine, r_pos_start, r_pos_end, r_value_start, r_value_end) );
	else
		damage_value_device_sync_pos( dm_machine, r_pos_end, r_pos_start, r_value_end, r_value_start );
	end

end
script static instanced void sys_damage_value_device_sync_pos( device dm_machine, real r_pos_start, real r_pos_end, real r_value_start, real r_value_end )
local real r_pos_device = 0.0;
local real r_pos_range = 0.0;
local real r_health_range = 0.0;
local real r_health_delta = 0.0;

	lich_inspect_r( "sys_damage_value_device_sync_pos: r_pos_start", r_pos_start );
	lich_inspect_r( "sys_damage_value_device_sync_pos: r_pos_end", r_pos_end );
	lich_inspect_r( "sys_damage_value_device_sync_pos: r_value_start", r_value_start );
	lich_inspect_r( "sys_damage_value_device_sync_pos: r_value_end", r_value_end );

	// setup variables
	r_health_range = r_value_end - r_value_start;
	r_pos_range = r_pos_end - r_pos_start;

	// wait for position to be in range
	sleep_until( (device_get_position(dm_machine) >= r_pos_start) and (device_get_position(dm_machine) <= r_pos_end), 1 );
	lich_inspect_r( "sys_damage_value_device_sync_pos: START", r_pos_start );

	if ( (abs_r(r_health_range) > 0.001) and (abs_r(r_pos_range) > 0.001) ) then
		
		repeat
			// get the position
			r_pos_device = device_get_position(dm_machine );
			
			// calculate delta
			r_health_delta = (r_pos_device - r_pos_start) / r_pos_range;

			// set the health value
			damage_value_set( r_value_start + (r_health_range * r_health_delta) );
			lich_inspect_r( "sys_damage_value_device_sync_pos: SET", r_value_start + (r_health_range * r_health_delta) );

			// wait for position to change
			if ( (r_pos_device >= r_pos_start) and (r_pos_device <= r_pos_end) ) then
				sleep_until( device_get_position(dm_machine) != r_pos_device, 1 );
			end
		until( not ((r_pos_device >= r_pos_start) and (r_pos_device <= r_pos_end)), 1 );

	else
			sleep_until( not ((device_get_position(dm_machine) >= r_pos_start) and (device_get_position(dm_machine) <= r_pos_end)), 1 );
	end

	// make sure the final value is applied
	damage_value_set( r_value_end );

	lich_inspect_r( "sys_damage_value_device_sync_pos: END", r_pos_end );

end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core
// -------------------------------------------------------------------------------------------------
// defines
script static real DEF_R_CORE_DAMAGE_HEALTH_DEFAULT() 					40.0;											end
script static string_id DEF_M_CORE_DAMAGE_TARGET() 							DEF_M_LICH_POWER_CORE(); 	end

script static real DEF_R_CORE_DAMAGE_LOW_RATIO_DEFAULT()				0.75;	 										end
script static real DEF_R_CORE_DAMAGE_MEDIUM_RATIO_DEFAULT()			0.50;	 										end
script static real DEF_R_CORE_DAMAGE_HIGH_RATIO_DEFAULT()				0.25;	 										end
script static real DEF_R_CORE_DAMAGE_DESTROYED_RATIO_DEFAULT()	0.001;	 									end

script static real DEF_R_CORE_AUTO_DAMAGE_SHIP_TIME_DEFAULT()		15.0;	 										end
static real R_core_auto_damage_ship_time = 											DEF_R_CORE_AUTO_DAMAGE_SHIP_TIME_DEFAULT();
static boolean B_core_auto_damage_ship_enabled = 								TRUE;

script static instanced void core_init()
	lich_dprint( "core_init" );	
	
	core_auto_damage_ship_set( core_auto_damage_ship_get() );
	
end

// === core_obj::: Gets the core object
script static instanced object core_obj()
	object_at_marker( this, DEF_M_CORE_DAMAGE_TARGET() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: Damage: Get
// -------------------------------------------------------------------------------------------------
// === core_damage_value_get::: Gets the health value of the core
//		RETURN: [REAL] Damage health value of the vehicle
script static instanced real core_damage_value_get()
local real l_return = 0.0;

	l_return = DEF_R_CORE_DAMAGE_HEALTH_DEFAULT() * object_get_health( core_obj() );

	// this helps round out some math errors	
	if ( l_return < DEF_R_CORE_DAMAGE_DESTROYED_RATIO_DEFAULT() ) then
		l_return = 0.0;
	end
	
	// return
	l_return;
end

// === damage_ratio_get::: Gets the health ratio of the core
//		RETURN: [REAL] Damage health ratio of the vehicle
script static instanced real core_damage_ratio_get()
local real l_return = 0.0;

	l_return = object_get_health( core_obj() );

	// this helps round out some math errors	
	if ( l_return < DEF_R_CORE_DAMAGE_DESTROYED_RATIO_DEFAULT() ) then
		l_return = 0.0;
	end
	
	// return
	l_return;
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: Damage: Convert
// -------------------------------------------------------------------------------------------------
// === core_damage_ratio_convert_to_value::: Converts health ratio to a health value
//		RETURN: [REAL] Health ratio of the value
script static instanced real core_damage_ratio_convert_to_value( real r_ratio )
	r_ratio * DEF_R_CORE_DAMAGE_HEALTH_DEFAULT();
end

// === core_damage_value_convert_to_ratio::: Converts health value to a health ratio
//		RETURN: [REAL] Health ratio of the value
script static instanced real core_damage_value_convert_to_ratio( real r_value )
	// RETURN
	r_value / DEF_R_CORE_DAMAGE_HEALTH_DEFAULT();
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: Damage: Apply
// -------------------------------------------------------------------------------------------------
// === damage_value_apply::: Applies a value of damage to the core
script static instanced void core_damage_value_apply( real r_value )
	if ( r_value > 0.0 ) then
		damage_object( core_obj(), "", r_value );
	end
end

// === core_damage_ratio_apply::: Applies a ratio of damage to the core
script static instanced void core_damage_ratio_apply( real r_ratio )
	core_damage_value_apply( core_damage_ratio_convert_to_value(r_ratio) );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: Damage: Set
// -------------------------------------------------------------------------------------------------
// === core_damage_value_set::: Sets the damage value of the core
script static instanced void core_damage_value_set( real r_value )
	core_damage_value_apply( core_damage_value_get() - r_value );
end

// === core_damage_ratio_set::: Sets the damage ratio of the core
script static instanced void core_damage_ratio_set( real r_ratio )
	core_damage_ratio_apply( core_damage_ratio_get() - r_ratio );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: Damage: State
// -------------------------------------------------------------------------------------------------
script static instanced boolean core_damage_check_low( boolean b_state_only )
	( core_damage_ratio_get() <= DEF_R_CORE_DAMAGE_LOW_RATIO_DEFAULT() ) and ( (not b_state_only) or (core_damage_ratio_get() > DEF_R_CORE_DAMAGE_MEDIUM_RATIO_DEFAULT()) );
end
script static instanced boolean core_damage_check_medium( boolean b_state_only )
	( core_damage_ratio_get() <= DEF_R_CORE_DAMAGE_MEDIUM_RATIO_DEFAULT() ) and ( (not b_state_only) or (core_damage_ratio_get() > DEF_R_CORE_DAMAGE_HIGH_RATIO_DEFAULT()) );
end
script static instanced boolean core_damage_check_high( boolean b_state_only )
	( core_damage_ratio_get() <= DEF_R_CORE_DAMAGE_HIGH_RATIO_DEFAULT() ) and ( (not b_state_only) or (core_damage_ratio_get() > DEF_R_CORE_DAMAGE_DESTROYED_RATIO_DEFAULT()) );
end
script static instanced boolean core_damage_check_destroyed()
	( core_damage_ratio_get() <= DEF_R_CORE_DAMAGE_DESTROYED_RATIO_DEFAULT() );
end

// -------------------------------------------------------------------------------------------------
// STORM_LICH: Core: auto damage ship: enable
// -------------------------------------------------------------------------------------------------
// === core_auto_damage_ship_set::: Enable/disable the core auto damage ship
script static instanced void core_auto_damage_ship_set( boolean b_enable )
static long l_core_thread = 0;

	B_core_auto_damage_ship_enabled = b_enable;
	
	if ( not b_enable ) then
		kill_thread( l_core_thread );
	elseif ( not isthreadvalid(l_core_thread) ) then
		l_core_thread = thread( sys_core_auto_damage_ship() );
	end 
	
end

// === core_auto_damage_ship_get::: Gets the core auto damage ship enabled state
script static instanced boolean core_auto_damage_ship_get()
	B_core_auto_damage_ship_enabled;
end

// === core_auto_damage_ship_time_set::: Sets the core autso damage ship time
script static instanced void core_auto_damage_ship_time_set( real r_time )
	// defaults
	if ( r_time < 0.0 ) then
		r_time = DEF_R_CORE_AUTO_DAMAGE_SHIP_TIME_DEFAULT();
	end
	
	R_core_auto_damage_ship_time = r_time;
end

// === core_auto_damage_ship_time_get::: Gets the core auto damage ship time
script static instanced real core_auto_damage_ship_time_get()
	R_core_auto_damage_ship_time;
end

// === sys_core_auto_damage::: Manages the core auto damage ship
script static instanced void sys_core_auto_damage_ship()
local long l_timer_start = 0;
local long l_transition_thread = 0;
local real r_time = core_auto_damage_ship_time_get();
local real r_time_passed = 0.0;
	
	// wait for core to be destroyed
	sleep_until( core_damage_check_destroyed(), 1 );
	
	// store the starting time
	l_timer_start = game_tick_get();
	
	repeat
	
		// calculate the time passed since the core auto damage started
		r_time_passed = frames_to_seconds(game_tick_get() - l_timer_start);
		
		// start a thread to auto damage the ship
		if ( isthreadvalid(l_transition_thread) ) then
			kill_thread( l_transition_thread );
		end
		l_transition_thread = damage_ratio_transition( 1.0, 0.0, core_auto_damage_ship_time_get() - r_time_passed );

		// wait for transition to finish or time value to change	
		sleep_until( (not isthreadvalid(l_transition_thread)) or (r_time != core_auto_damage_ship_time_get()), 1 );
		
	until( not isthreadvalid(l_transition_thread), 1 );
	
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// lich: name
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables
instanced string str_lich_name														= "";

// functions
script static instanced void name_set( string str_name )
	// store ID
	str_lich_name = str_name;
	lich_dprint( "name_set" );
end
script static instanced string name_get()
	str_lich_name;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// STORM_LICH: debug
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables
instanced boolean b_lich_debug													= FALSE;

// functions
script static instanced void lich_dprint( string str_debug )
	if ( debug_get() ) then
		dprint( "LICH_DEBUG: -------------------------------------------------------------" );
		if ( name_get() != "" ) then
			dprint( name_get() );
		end
		dprint( str_debug );
		dprint( "-------------------------------------------------------------------------" );
	end
end	
script static instanced void lich_inspect_r( string str_debug, real r_inspect )
	if ( debug_get() ) then
		dprint( "LICH_INSPECT [REAL] #####################################################" );
		if ( name_get() != "" ) then
			dprint( name_get() );
		end
		dprint( str_debug );
		inspect( r_inspect );
		dprint( "#########################################################################" );
	end
end	
script static instanced void lich_inspect_b( string str_debug, boolean b_inspect )
	if ( debug_get() ) then
		dprint( "LICH_INSPECT [BOOLEAN] ##################################################" );
		if ( name_get() != "" ) then
			dprint( name_get() );
		end
		dprint( str_debug );
		inspect( b_inspect );
		dprint( "#########################################################################" );
	end
end	
script static instanced void lich_inspect_str( string str_debug, string str_inspect )
	if ( debug_get() ) then
		dprint( "LICH_INSPECT [STRING] ###################################################" );
		if ( name_get() != "" ) then
			dprint( name_get() );
		end
		dprint( str_debug );
		dprint( str_inspect );
		dprint( "#########################################################################" );
	end
end	
script static instanced void debug_set( boolean b_active )
	b_lich_debug = b_active;
end
script static instanced boolean debug_get()
	b_lich_debug;
end

/*
// -------------------------------------------------------------------------------------------------
// STORM_LICH: <SUB MODULE>
// -------------------------------------------------------------------------------------------------
// defines
static <TYPE> DEF_<T>_<SUBMODULE>_<NAME> 			= <VALUE>;

// variables
static <TYPE> <T>_<submodule>_<name> 					= <VALUE>;
instanced <TYPE> <t>_<submodule>_<name>				= <VALUE>;

// functions
// === <SUBMODULE>_init::: Init
script static instanced void <SUBMODULE>_init()
	dprint( "::: <SUBMODULE>_init :::" );

	// XXX_TODO

end

// === <SUBMODULE>_deinit::: Deinit
script static instanced void <SUBMODULE>_deinit()
	dprint( "::: <SUBMODULE>_deinit :::" );

	// XXX_TODO

end
*/
