/*
la_2_fly.gsc - contains all functionality for air-to-air section of LA_2 
 */

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la_2.gsh;

main()
{

}



flyby_test( str_row, str_col, n_index )
{
	level endon( "dogfight_done" );
	
	wait 5;
	
	// spawn plane
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( "avenger_fast_la2" );
	vh_plane SetNearGoalNotifyDist( 512 );
	vh_plane endon( "death" );
	
	while ( true )
	{
		b_should_approach = !( level.player is_looking_at( vh_plane.origin, 0.6 ) );
		
		if ( b_should_approach )
		{
			//iprintlnbold( "plane approaching now" );
			// move plane to approach point
			vh_plane thread _approach_goal( str_row, str_col );
			//vh_plane thread flyby_spline_approach( n_index, str_row, str_col );
			
			// keep plane in position
			vh_plane waittill( "near_goal" );
			vh_plane SetSpeed( 400 );
			vh_plane notify( "_stop_approach" );
			vh_plane thread match_player_direction();
			//iprintlnbold( "plane at goal" );
		}
		
		wait 1;
	}
}

match_player_direction()
{
	self endon( "death" );
	self notify( "_stop_matching_direction" );
	self endon( "_stop_matching_direction" );
	
	while ( true )
	{
		v_origin = self.origin;
		v_angles = AnglesToForward( level.player GetPlayerAngles() );
		n_scale = 10000;
		
		v_goal = v_origin + ( v_angles * n_scale );
	//	level thread draw_line_for_time( self.origin, v_goal, 1, 1, 1, 5 );
		self _set_veh_goal_pos_dogfight( v_goal );
		
		wait 0.5;
	}
}

_approach_goal( str_row, str_col )
{
	self endon( "death" );
	self notify( "_stop_approach" );
	self endon( "_stop_approach" );
	level endon( "dogfight_done" );
	
	e_approach = level.f35 f35_get_approach_point( str_row, str_col );
	self.origin = e_approach.origin;
	self.angles = level.f35.angles;
	self SetPhysAngles( level.f35.angles );
	//iprintlnbold( "plane at approach point" );	
	n_speed_multiplier_min = 2;
	n_speed_multiplier_max = 3;
	n_speed_min = level.f35.speed_plane_max * n_speed_multiplier_min;
	n_speed_max = 1000;
	
	/*
	n_counter = 0;  // frames
	n_counter_timeout = 20;
	n_dot_max = 0;
	*/
	
	while ( !flag( "dogfight_done" ) )
	{		
		n_speed_player = level.f35 GetSpeedMPH();
		n_speed_catch_rough = n_speed_player * n_speed_multiplier_max;
		n_speed_catch = clamp( n_speed_catch_rough, n_speed_min, n_speed_max );  // overtake player
		self SetSpeed( n_speed_catch );
		// move plane to goal point
		e_goal = level.f35 f35_get_goal_point( str_row, str_col );

		/*
		n_dot = level.player get_dot_forward( self.origin, false, false );
		b_should_reset_position = ( ( n_counter > n_counter_timeout ) && ( n_dot < n_dot_max ) );
		if ( b_should_reset_position )
		{
			iprintlnbold( "resetting position" );
			n_counter = 0;
			e_approach = level.f35 f35_get_approach_point( str_row, str_col );
			self.origin = e_approach.origin;
			self.angles = level.f35.angles;
			self SetPhysAngles( level.f35.angles );			
		}		
		*/
		
		self _set_veh_goal_pos_dogfight( e_goal.origin );	
//		n_counter++;
		
		wait 0.1;
	}
}


/*
ground_targets_dogfights()
{
	//level endon( "ground_targets_done" ); // travisj- keeping these going for now
	
	a_structs = get_struct_array( "roadblock_flyby_structs", "script_noteworthy", true );
	
	n_cooldown_time = 5;
	n_cooldown_time_ms = n_cooldown_time * 1000;
	
	while ( true )
	{
		b_struct_available = false;
		
		while( !b_struct_available )
		{
			n_index = RandomInt( a_structs.size );
			s_current = a_structs[ n_index ];
			n_current_time = GetTime();
			
			b_is_first_use = !IsDefined( s_current.last_used );
			b_is_ready = IsDefined( s_current.last_used ) && ( ( n_current_time - s_current.last_used ) > n_cooldown_time_ms );
			
			if ( b_is_first_use || b_is_ready )
			{
				b_struct_available = true;
				s_current.last_used = n_current_time;
			}
			
			wait 0.05;
		} 
		
		n_index = RandomInt( 4 );
		n_chase_time = RandomFloatRange( 1.5, 2 );
		
		if ( n_index == 0 )
		{
			level thread plane_basic_dogfight( "pegasus_fast", "f35_fast", s_current.targetname, n_chase_time );		
		}
		else if ( n_index == 1 )
		{
			level thread plane_basic_dogfight( "f35_fast", "pegasus_fast", s_current.targetname, n_chase_time );
		}
		else if ( n_index == 2 )
		{
			level thread plane_basic_dogfight( "avenger_fast", "f35_fast", s_current.targetname, n_chase_time );
		}
		else 
		{
			level thread plane_basic_dogfight( "f35_fast", "avenger_fast", s_current.targetname, n_chase_time );
		}
		
		wait RandomFloatRange( 1, 2 );
	}
}
*/

_get_random_element_player_can_see( a_elements, n_distance )
{
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for _get_random_element_player_can_see" );
	Assert( ( a_elements.size > 0 ), "a_elements needs to contain at least one element in _get_random_element_player_can_see" );
	
	b_found_element = false;
	e_player = level.player;
	n_dot_range = 0.6;
	b_do_trace = false;
	b_use_distance = IsDefined( n_distance );
	b_distance_passed = true;
	
	while ( !b_found_element )
	{
		s_element = random( a_elements );
		//b_found_element = e_player is_behind( s_element.origin );
		
		b_can_player_see_point = e_player is_looking_at( s_element.origin, n_dot_range, b_do_trace );
		
		if ( b_use_distance )
		{
			b_distance_passed = false;
			
			n_distance_current = Distance2D( e_player.origin, s_element.origin );
			
			if ( n_distance_current > n_distance )
			{
				b_distance_passed = true;
			}
		}
		
		if ( b_can_player_see_point && b_distance_passed )
		{
		    b_found_element = true;
		}
		    
		wait 0.1;
	}
	
	return s_element;
}

_get_random_element_player_cant_see( a_elements, n_distance )
{
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for _get_random_element_player_cant_see" );
	Assert( ( a_elements.size > 0 ), "a_elements needs to contain at least one element in _get_random_element_player_cant_see" );
	
	b_found_element = false;
	e_player = level.player;
	n_dot_range = 0.3;
	b_do_trace = false;
	b_use_distance = IsDefined( n_distance );
	b_distance_passed = true;
	
	while ( !b_found_element )
	{
		s_element = random( a_elements );
		//b_found_element = e_player is_behind( s_element.origin );
		
		if ( !IsDefined( s_element ) )
		{
			wait 0.1;
			continue;
		}
		
		b_can_player_see_point = e_player is_looking_at( s_element.origin, n_dot_range, b_do_trace );
		
		if ( b_use_distance )
		{
			b_distance_passed = false;
			
			n_distance_current = Distance2D( e_player.origin, s_element.origin );
			
			if ( n_distance_current > n_distance )
			{
				b_distance_passed = true;
			}
		}
		
		if ( !b_can_player_see_point && b_distance_passed )
		{
		    b_found_element = true;
		}
		    
		wait 0.1;
	}
	
	return s_element;
}


f35_dogfights()
{
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_dogfight_stop_trigger", "dogfight_done", ::flag_set, "convoy_at_dogfight" );	
	
	n_distance_from_player_close = 10000;
	n_distance_from_player_medium = 25000;	
	
	n_circling_drone_count = 45;
	level thread _set_max_circling_count( n_circling_drone_count );	
	
	maps\la_2_drones_ambient::aerial_vehicles_set_circling_close( false );
	level thread maps\la_2_drones_ambient::update_circling_plane_structs( "flight_point_air_section", "script_noteworthy", n_distance_from_player_close, n_distance_from_player_medium );	
	
	flag_wait( "convoy_at_dogfight" );
	//spawn_manager_disable( "spawn_manager_rooftops_apartments" );
	
	maps\_lockonmissileturret::EnableLockOn();
	
	maps\la_2_ground::convoy_blocked_by_debris();
	maps\createart\la_2_art::art_jet_mode_settings();
	
	flag_set( "no_fail_from_distance" );
	flag_set( "convoy_nag_override" );  // don't play convoy damage/distance nag lines right now
	//level.f35 _f35_set_conventional_flight_mode();
	//level thread maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_MODE_PLANE", undefined, maps\la_2_player_f35::f35_control_check_mode, "dogfight_done" );
	
	dogfights_monitor_warning_distance();
	dogfights_monitor_failure_distance();
	level thread mark_all_visible_enemies_as_targets();
	
	autosave_by_name( "la_2" );
	
	flag_wait( "dogfights_story_done" );
	
	level.f35 thread maps\la_2_anim::vo_dogfight_f35();
	
	level thread dogfight_flyby_watcher();
	autosave_by_name( "la_2" );
	
	scale_model_LODs( 1, 1 );
	
	_dogfight_spawner_think();
	
	flag_set( "dogfight_done" );
	flag_clear( "convoy_nag_override" );
	
	if ( is_greenlight_build() )
	{
		level thread end_greenlight_demo();
	}
}

// enemy target cap is 32. There may be more than 32 planes active. mark only the ones player can see.
mark_all_visible_enemies_as_targets()
{
	n_wait_min = 1;
	n_wait_max = 2;
	n_max_targets = 22;  // 32 minus 10 from event
	n_dot = 0.5;
	b_do_trace = false;
	
	while ( !flag( "dogfight_done" ) )
	{
		a_temp = level.aerial_vehicles.axis;
		a_targets = Target_GetArray();
		n_target_count = a_targets.size;
		
		for ( i = 0; i < a_temp.size; i++ )
		{
			b_can_player_see = level.player is_looking_at( a_temp[ i ].origin, n_dot, b_do_trace );
			b_should_be_target = ( n_target_count < n_max_targets );
			b_is_target = Target_IsTarget( a_temp[ i ] );
			
			// new target
			if ( b_can_player_see && b_should_be_target && !b_is_target )
			{
				Target_Set( a_temp[ i ] );
				n_target_count++;
			}
			else if ( !b_can_player_see && b_is_target )  // previous target to remove
			{
				Target_Remove( a_temp[ i ] );
				n_target_count--;
			}
		}
		
		n_wait = RandomFloatRange( n_wait_min, n_wait_max );
		wait n_wait;
	}
	
	a_temp = Target_GetArray();
	
	for ( i = 0; i < a_temp.size; i++ )
	{
		Target_Remove( a_temp[ i ] );
	}
}

dogfights_monitor_warning_distance()
{
	a_warning_triggers = get_ent_array( "air_warning_trigger", "targetname", true );
	
	array_thread( a_warning_triggers, ::_dogfights_warning_distance_check );
}

_dogfights_warning_distance_check()
{
	// endon? 
	
	n_warning_frequency = 4;
	n_warning_frequency_ms = n_warning_frequency * 1000;
	n_wait_time_min = 0.8;
	n_wait_time_max = 1.5;
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		e_triggered.dogfight_warning = true;		
		n_time = GetTime();
		
		if ( !IsDefined( e_triggered.dogfight_warning_time_last ) )
		{
			e_triggered.dogfight_warning_time_last = 0;
		}
		
		b_should_warn = false;
		if ( ( n_time - e_triggered.dogfight_warning_time_last ) > n_warning_frequency_ms )
		{
			b_should_warn = true;
		}
		
		if ( b_should_warn )
		{
			level.f35 thread say_dialog( "F35_dogfight_distance_warning" );
			e_triggered.dogfight_warning_time_last = n_time;
		}
		
		n_wait_time = RandomFloatRange( n_wait_time_min, n_wait_time_max );
		wait n_wait_time;
	}
}

dogfights_monitor_failure_distance()
{
	a_failure_triggers = get_ent_array( "air_failure_trigger", "targetname", true );
	
	array_thread( a_failure_triggers, ::_dogfights_failure_distance_check );
}

_dogfights_failure_distance_check()
{
	// endon? 
	
	n_wait_min = 0.8;
	n_wait_max = 1.5;
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		if ( IsPlayer( e_triggered ) && !IsGodMode( e_triggered ) )
		{
			SetDvar( "ui_deadquote", &"LA_2_DISTANCE_FAIL" );
			MissionFailed();
		}
		
		n_wait_time = RandomFloatRange( n_wait_min, n_wait_max );
		wait n_wait_time;
	}
}

_dogfight_spawner_think()
{
	// flight point structs
	a_plane_spawn_points = get_struct_array( "drone_dogfight_spawn_point", "targetname", true );
	a_valid_flight_points = get_struct_array( "flight_point_air_section", "script_noteworthy", true );
	n_total_waves = level.aerial_vehicles.dogfights.waves.size;
	
	// spawn points
	sp_avenger = get_struct( "avenger_fast_la2_vehiclespawner", "targetname", true );
	sp_pegasus = get_struct( "pegasus_fast_la2_vehiclespawner", "targetname", true );
	sp_f35 = get_struct( "f35_fast_la2_vehiclespawner", "targetname", true );	
	
	n_killed_threshold = DOGFIGHTS_TARGETS;
	n_spawned_total = 0;
	
	wait 5;

	n_active_max = 8;
	
	while ( !flag( "dogfight_done" ) )
	{
		n_killed = level.aerial_vehicles.dogfights.killed_total;
		
		if ( n_killed >= n_killed_threshold )
		{
			flag_set( "dogfight_done" );
			continue;
		}
		
		n_active = level.aerial_vehicles.dogfights.targets.size;
		b_should_spawn_attackers = ( n_active < n_active_max );
		n_killed = level.aerial_vehicles.dogfights.killed_total;
		
		b_should_spawn_strafing_group = /* !flag( "strafing_run_active" ) */  false; 
		
		if ( b_should_spawn_strafing_group )
		{
			flag_set( "strafing_run_active" );
			level thread spawn_convoy_strafing_wave();
			flag_waitopen( "strafing_run_active" );
		}
		else if ( b_should_spawn_attackers )
		{
			str_type = _dogfight_spawner_determine_type();
			s_point = _get_random_element_player_can_see( a_plane_spawn_points, 20000 );
			sp_pegasus.origin = s_point.origin;		
			sp_avenger.origin = s_point.origin;		
			plane_spawn_dogfight( str_type, a_plane_spawn_points, a_valid_flight_points );
			n_spawned_total++;
		}
		
		wait 2;
	}
	
	// set 'escape positions' for remaining active dogfight planes
	for ( i = 0; i < level.aerial_vehicles.dogfights.targets.size; i++ )
	{
		s_goal = random( a_plane_spawn_points );
		
		if ( is_alive( level.aerial_vehicles.dogfights.targets[ i ] ) )
		{
			level.aerial_vehicles.dogfights.targets[ i ] notify( "dogfight_done" );
			level.aerial_vehicles.dogfights.targets[ i ].escape_position = s_goal.origin;
		}
	}
	
	delay_thread( 2, ::last_locked_clear );  // get rid of any lingering targets on hud
	
	iprintlnbold( "get back to the convoy!" );
}


plane_spawn_dogfight( str_type, a_fake_spawn_points, a_valid_flight_points, b_count_towards_total )
{
	Assert( IsDefined( str_type ), "str_type is a required parameter for plane_spawn_dogfight" );
	
	if ( !IsDefined( b_count_towards_total ) )
	{
		b_count_towards_total = true;
	}
	
	// determine type of drone
	if ( str_type == "pegasus" )
	{
		str_name = "pegasus_fast_la2";
		func_behavior = ::dogfight_behavior_pegasus;
		v_offset = ( 0, 0, 0 );
	}
	else if ( str_type == "avenger" )
	{
		str_name = "avenger_fast_la2";
		func_behavior = ::dogfight_behavior_avenger;
		v_offset = ( 0, 0, 0 );
	}
	else
	{
		AssertMsg( str_type + " is not a supported plane type for plane_spawn_dogfight. implement it!" );
	}
	
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_name );
	vh_plane.valid_flight_points = a_valid_flight_points;
	vh_plane.is_dogfight_plane = true;
	// set_target
	vh_plane EnableAimAssist();
	Target_Set( vh_plane, v_offset );
	
	// thread behavior
	if ( b_count_towards_total )
	{
		vh_plane thread dogfight_enemy_counter();
		vh_plane thread _set_objective_on_plane();
	}
	
	vh_plane thread [[ func_behavior ]]();
	
	return vh_plane;
}

_set_strafing_run_objective_on_plane( n_index )
{
	// level.OBJ_DOGFIGHTS_STRAFE
	
	// objective marker
	if ( !IsDefined( level.dogfights_objective_strafe_marker_active ) )
	{
		level.dogfights_objective_strafe_marker_active = true;
		Objective_Add( level.OBJ_DOGFIGHTS_STRAFE, "current" );
		Objective_Set3D( level.OBJ_DOGFIGHTS_STRAFE, true, "red" );
	}
	
	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, self );
	
	self waittill_either( "death", "dogfight_done" );

	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, ( 0, 0, 0 ) );  // clears additional position
	level.aerial_vehicles.dogfights.killed_total++;
	dogfights_objective_update_counter();
}

spawn_convoy_strafing_wave()
{
	level endon( "dogfight_done" );
	
	const N_FLYBY_COUNT = 1;  // number of guys in a flyby 'pack'
	const MAX_DISTANCE_FOR_FLYBY = 20000;
	
	// pause flybys
	flag_clear( "force_flybys_available" );
	flag_set( "strafing_run_active" );
	
	a_planes = [];
	
	// where should planes spawn?
	if ( Distance( level.player.origin, level.convoy.vh_potus.origin ) < MAX_DISTANCE_FOR_FLYBY )
	{
		// spawn planes in players view that fly at the convoy
		iprintlnbold( "SPAWNING PLANES IN PLAYER VIEW" );
		
		s_point = _get_random_element_player_can_see( level.aerial_vehicles.valid_structs_medium, MAX_DISTANCE_FOR_FLYBY );
		v_teleport_point = s_point.origin;
		b_use_flyby = false;
	}
	else 
	{
		// spawn planes behind player that fly over his head, then go to the convoy
		iprintlnbold( "SPAWNING PLANES BEHIND PLAYER" );
		b_use_flyby = true;
	}
	
	for ( i = 0; i < N_FLYBY_COUNT; i++ )
	{		
		vh_plane = plane_spawn( "pegasus_fast_la2", ::dogfight_convoy_strafe, b_use_flyby );
		vh_plane.no_tracking = true;  // take plane out of ambient drone targeting pool 
		vh_plane ent_flag_init( "is_tracking" );
		Target_Set( vh_plane );
		vh_plane _setup_plane_firing_by_type();
		vh_plane _set_strafing_run_objective_on_plane( i );
		
		if ( !b_use_flyby )
		{
			vh_plane.origin = v_teleport_point;
		}
		
		a_planes[ a_planes.size ] = vh_plane;
	}
	
	array_wait( a_planes, "death" );
		
	iprintlnbold( "strafing run done" );
	flag_clear( "strafing_run_active" );
}

dogfight_convoy_strafe( b_flyby )
{
	self endon( "death" );
	
	// pattern: 1) start at current origin
	// 			2) fly to convoy
	// 			3) fly past convoy to some node at map edge
	// 			4) repeat steps 2 and 3
	
	self SetNearGoalNotifyDist( 1500 );
	
	if ( b_flyby )
	{
		n_index = f35_get_available_approach_point();
		
		a_positions = f35_convert_index_to_strings( n_index );
		str_col = a_positions[ "col" ];
		str_row = a_positions[ "row" ];
	
		self approach_point_claim( n_index );
		self thread _approach_goal( str_row, str_col );	
		
		self waittill( "near_goal" );		
		self notify( "_stop_approach" );
		self notify( "free_approach_point" );
	}
	
	iprintlnbold( "STARTING STRAFING RUN" );
		
	while ( true )
	{
		e_target = maps\la_2_convoy::convoy_get_leader();
		self SetVehGoalPos( e_target.origin + ( 0, 0, 2000 ) );
		self maps\_turret::set_turret_target( e_target, ( 0, 0, 0 ), 0 );
		self thread draw_line_for_time( self.origin, e_target.origin, 1, 1, 1, 5 );
		
		iprintlnbold( "I'M STRAFING THE CONVOY" );
		
		self waittill( "near_goal" );
		
		v_goal = self.origin + ( FLAT_ORIGIN( AnglesToForward( self.angles ) ) * 30000 ) + ( 0, 0, 5000 );
		self SetVehGoalPos( v_goal );
		self thread draw_line_for_time( self.origin, v_goal, 1, 1, 1, 5 );
		
		iprintlnbold( "I'M FLYING AWAY FROM THE CONVOY" );
		
		self waittill( "near_goal" );	
	}
}

dogfight_flyby_watcher()
{
	n_max_flybys = level.f35.n_max_flyby_count;
	n_flyby_time_max = 0.05;  // seconds
	n_flyby_time_max_ms = n_flyby_time_max * 1000;
	n_poll_time = 0.05;
	a_valid_flight_points = get_struct_array( "flight_point_air_section", "script_noteworthy", true );
	
	level.dogfights_flyby_last_time	= GetTime();  // starts the same time as dogfights
	
	flag_set( "force_flybys_available" ); // this is toggled elsewhere by waves, but set to on by default at event start
	
	while ( !flag( "dogfight_done" ) )
	{
		n_time = GetTime();
		
		n_active_flybys = level.f35.n_goal_ents_occupied;
		b_should_force_flyby = flag( "force_flybys_available" ) && ( ( n_time - level.dogfights_flyby_last_time ) > n_flyby_time_max_ms ) && ( n_active_flybys == 0 ) && maps\la_2_drones_ambient::is_vehicle_slot_open();
		
		if ( b_should_force_flyby )
		{
			b_found_plane = false;			
			iprintln( "forcing flyby now" );
			
			// spawn a plane that doesn't count towards our normal attacker count
			vh_plane = plane_spawn_dogfight( "avenger", undefined, a_valid_flight_points, false );
			
			// SOUND: put some sort of flyby sound here to fade into normal flyby
			
			// force it into flyby behavior (all positioning logic is inside flyby state function)
			vh_plane dogfight_behavior_change_state( "flyby" );
			
			// clean vehicle up after it it's out of view and not locked on by player
			vh_plane thread dogfight_flyby_remove_after_force_flyby();
			//vh_plane notify( "near_goal" );  // this will stop all current behavior and force current thread to continue
			wait 0.1;
			//vh_plane.state_locked = true;
			
		}
		
		wait n_poll_time;
	}
}

#define MIN_DOGFIGHT_FLY_HEIGHT 6500
_set_veh_goal_pos_dogfight(vec_veh_goal)
{
	if(flag("dogfights_story_done") && !flag("dogfight_done"))
    {
    	if( vec_veh_goal[2] < MIN_DOGFIGHT_FLY_HEIGHT )
        {
        	vec_veh_goal = (vec_veh_goal[0], vec_veh_goal[1], MIN_DOGFIGHT_FLY_HEIGHT + RandomIntRange(0, 1200));
        }
	}
                
    self SetVehGoalPos(vec_veh_goal);
}


dogfight_flyby_remove_after_force_flyby()
{
	self endon( "death" );
	
	b_player_can_see_me = true;
	b_player_is_tracking_me = true;
	
	// waittill flyby is done (flyby->fly_straight)
	while ( self.state != "fly_straight" )
	{
		if ( self.state != "fly_straight" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "fly_straight" )
		{
			continue;
		}
	}
	
	//iprintlnbold( "forced flyby plane flying straight" );
	
	while ( b_player_can_see_me || b_player_is_tracking_me )
	{
		b_player_can_see_me = level.player is_looking_at( self.origin, 0.7, false );
		b_player_is_tracking_me = ( IsDefined( level.dogfights_last_locked ) && ( level.dogfights_last_locked == self ) );
		wait 1;
	}
	
	//iprintlnbold( "deleting forced flyby plane!" );
	VEHICLE_DELETE( self )  // looks weird but semicolon is in macro
}

// objectives are set manually with code functions instead of _objectives since it doesn't re-use objective positions. 
// if this situation arises anywhere other than LA_2 I will update the system to handle this. -TravisJ
_set_objective_on_plane()  // self = plane
{
	n_targets_total = DOGFIGHTS_TARGETS;
	
	// objective marker
	if ( !IsDefined( level.dogfights_objective_marker_active ) )
	{
		level.dogfights_objective_marker_active = true;
		Objective_Add( level.OBJ_DOGFIGHTS, "current" );
		Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", n_targets_total );
		dogfights_objective_setup();
		Objective_Set3D( level.OBJ_DOGFIGHTS, true, "default" );
	}
	
	//Objective_Position( level.OBJ_DOGFIGHTS, self );
	//Objective_Set3D( level.OBJ_DOGFIGHTS, true, "red" );
	n_index = dogfights_objective_get_available_position();
	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, self );
	
	self waittill_either( "death", "dogfight_done" );
	

	self dogfights_objective_release_position( n_index );
	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, ( 0, 0, 0 ) );  // clears additional position
	
	dogfights_objective_update_counter();
}

dogfights_objective_update_counter()
{
	n_targets_total = DOGFIGHTS_TARGETS;
	n_killed = level.aerial_vehicles.dogfights.killed_total;
	n_remaining = n_targets_total - n_killed;
	n_halfway = Int( n_targets_total * 0.5 );
	
	if ( n_killed == n_halfway )
	{
		autosave_by_name( "la_2" );
	}
	
	if ( n_remaining <= 0 )
	{
		if ( !flag( "dogfight_done" ) )
		{
			flag_set( "dogfight_done" );
			Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", 0 );
			Objective_State( level.OBJ_DOGFIGHTS, "done" );
		}
	}
	else 
	{
		Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", n_remaining );
	}
}

dogfights_objective_setup()
{
	// there are 8 max objective positions available within the objective system. we need to reuse these.
	level.aerial_vehicles.dogfights.objective_positions = [];
	n_max_objectives = 8;
	
	for ( i = 0; i < n_max_objectives; i++ )
	{
		// false = unoccupied, true = occupied
		level.aerial_vehicles.dogfights.objective_positions[ level.aerial_vehicles.dogfights.objective_positions.size ] = false;
	}
}

dogfights_objective_get_available_position()  // self = plane with objective marker on it
{
	Assert( !IsDefined( self.dogfights_objective_index ), "objective index is already defined on dogfight plane!" );
	
	n_free_position = -1;
	
	for ( i = 0; i < level.aerial_vehicles.dogfights.objective_positions.size; i++ )
	{
		if ( level.aerial_vehicles.dogfights.objective_positions[ i ] == false )
		{
			level.aerial_vehicles.dogfights.objective_positions[ i ] = true;
			self.dogfights_objective_index = i;
			n_free_position = i;
			break;
		}
	}
	
	return n_free_position;
}

dogfights_objective_release_position( n_index )  // self = plane that needs its objective marker removed
{
	level.aerial_vehicles.dogfights.objective_positions[ n_index ] = false;
}

_dogfight_spawner_determine_type()
{
	n_index = RandomInt( 2 );
	
	if ( n_index == 0 )
	{
		str_type = "avenger";
	}
	else 
	{
		str_type = "pegasus";
	}
	
	return str_type;
}

dogfight_enemy_counter()
{
	level.aerial_vehicles.dogfights.targets[  level.aerial_vehicles.dogfights.targets.size ] = self;
	
	self waittill( "death" );

	level.aerial_vehicles.dogfights.killed_total++;
	level.aerial_vehicles.player_killed_total++;
	level.aerial_vehicles.dogfights.targets = array_removeDead(  level.aerial_vehicles.dogfights.targets );
}

dogfight_behavior_avenger()
{
	self endon( "death" );
	
	// set up states
	if ( !IsDefined( self.state ) )
	{
		self.state_previous = "none";
		self.state = "attack";
		self.states_available = [];
		self.state_locked = false;
	}	
	
	// add speed monitor
	self thread _dogfight_speed_monitor();
	
	// add distance/dot monitor
	
	// add flyby logic
	self thread _dogfight_flyby_avenger();

	// add attack logic
	self thread _dogfight_attack_avenger();

	// add locked on logic	
	self thread _dogfight_locked_on_avenger();
	
	// fly straight logic
	self thread _dogfight_fly_straight();
	
	// fly away after dogfights are over
	self thread _dogfight_post_event();
	
	n_flyby_max = level.f35.n_max_flyby_count;
	b_ignore_z = false;
	b_normalize_dot = false;
	
	// determine best state
	while ( true )
	{
		if ( self.state_locked )
		{
			self waittill( "can_change_state" );
		}
		
		if ( flag( "dogfight_done" ) && IsDefined( self.escape_position ) )
		{
			self dogfight_behavior_change_state( "post_dogfight" );
			return;
		}
		
		n_dot_dist = level.player get_dot_forward( self.origin, b_ignore_z, b_normalize_dot );  // dot to plane from player's perspective
		b_locked_on = false;
		n_flyby_count = level.f35.n_goal_ents_occupied;
		b_can_flyby = ( n_flyby_count < n_flyby_max );
		b_flying_straight = ( self.state == "fly_straight" );
		
		if ( self.state == "flyby" )
		{
			// automatically transition to fly_straight behavior
			self dogfight_behavior_change_state( "fly_straight" );
		}
		else if ( b_locked_on )
		{
			//iprintlnbold( "locked on..." );
		}
		else if ( ( n_dot_dist > 0 ) && !b_flying_straight )
		{
			self dogfight_behavior_change_state( "attack" );
		}
		else if ( (n_dot_dist < 0 ) && ( b_can_flyby ) )
		{	
			self dogfight_behavior_change_state( "flyby" );
		}
		
		wait 1;  // reevaluation period for non-locked states (fly_straight, etc)
	}
}

// when should plane match speed?
// when should plane fly full speed?
// what are min/max speeds?
_dogfight_speed_monitor()  // self = plane
{
	self endon( "death" );
	
	n_speed_min = level.f35.speed_drone_min;
	n_speed_max = level.f35.speed_drone_max;
	n_distance_ideal = 5500;
	n_distance_ideal_sq = n_distance_ideal * n_distance_ideal;
	n_tolerance = 600;
	n_multiplier_slowdown = 0.6;
	n_tolerance_sq = n_tolerance * n_tolerance;
	
	while ( !flag( "dogfight_done" ) )
	{
		b_should_set_speed = false;
		
		if ( ( self.state == "fly_straight" ) || ( self.state == "attack" ) )
		{
			b_should_set_speed = true;
			n_speed_new = level.f35 GetSpeedMPH();
			n_speed_self = self GetSpeedMPH(); 
			
			n_distance_sq = DistanceSquared( self.origin, level.f35.origin );
			
			if ( n_distance_sq > n_distance_ideal_sq )
			{
				n_speed_new = Int( n_speed_new * n_multiplier_slowdown );
			}
		
			n_speed_new = clamp( n_speed_new, n_speed_min, n_speed_max );
		}
		
		if ( b_should_set_speed )
		{
			self SetSpeed( n_speed_new );
		}
		
		wait 0.25;
	}
}

// checks for valid states and changes behavior state of plane
dogfight_behavior_change_state( str_state )
{
	Assert( IsDefined( str_state ), "str_state is required for dogfight_behavior_change_state" );
	
	a_keys = GetArrayKeys( self.states_available );
	
	b_state_valid = false;
	
	for ( i = 0; i < a_keys.size; i++ )
	{
		if ( a_keys[ i ] == str_state )
		{
			b_state_valid = true;
		}
	}
	
	Assert( b_state_valid, str_state + " is not a valid state for " + self.vehicletype + " at origin " + self.origin );
	
	self notify( "plane_state_changed" );
	//Print3D( self.origin, str_state, ( 1, 1, 1 ), 1, 30, 5 );
	self.state_previous = self.state;
	self.state = str_state;
}

_dogfight_attack_avenger()
{
	self endon( "death" );
	
	if( !IsDefined( self.states_available[ "attack" ] ) )
	{
		self.states_available[ "attack" ] = true;
	}
	
	e_target = level.player;
	v_offset = ( 0, 0, 0 );	
	n_near_goal_distance = 5096;
	a_flight_points = self.valid_flight_points;	
	n_acceleration = 300;
	n_deceleration = 250;
	n_speed_min = 400;
	n_speed_max = 450;
	n_distance_to_player = 6000;	
	
	self thread _dogfight_fire_while_in_player_view();
	
	n_pattern = 0;
	self _set_veh_goal_pos_dogfight( level.dogfights_volume.origin );	
	
	while ( !flag( "dogfight_done" ) )
	{
		if ( self.state != "attack" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "attack" )
		{
			n_pattern = 0;
			continue;
		}
		
		self.state_locked = true;
		self SetNearGoalNotifyDist( n_near_goal_distance );
		b_do_close_structs_exist = IsDefined( level.aerial_vehicles.valid_structs_close );
		b_are_there_enough_close_structs = ( b_do_close_structs_exist && ( level.aerial_vehicles.valid_structs_close.size > 0 ) );
		
		if ( b_do_close_structs_exist && b_are_there_enough_close_structs )
		{
			a_flight_points = level.aerial_vehicles.valid_structs_close;
		}		
		
		if ( n_pattern == 0 )  // fly in front of the player
		{
			s_flight_point = _get_random_element_player_can_see( a_flight_points, n_distance_to_player );
			v_flight_point = s_flight_point.origin;
		}
		else if ( n_pattern == 1 )  // fly to the player
		{
			v_offset_z = ( 0, 0, RandomIntRange( -500, 750 ) );
			v_flight_point = ( level.player.origin + v_offset_z );
		}
		else  // fly behind the player
		{
			s_flight_point = _get_random_element_player_cant_see( a_flight_points, n_distance_to_player );
			v_flight_point = s_flight_point.origin;
			n_pattern = 0;  // reset pattern
		}
		
		self _set_veh_goal_pos_dogfight( v_flight_point );
		//self thread draw_line_for_time( self.origin, v_flight_point, 1, 1, 1, 1 );
		self waittill( "near_goal" );
		self.state_locked = false;
		self notify( "can_change_state" );
	}	
}

_dogfight_fire_while_in_player_view()
{
	self endon( "death" );
	
	e_target = level.f35;
	v_offset = ( 0, 0, 0 );
	n_fire_time = 2;
	n_wait_time = 0.25;
	n_dot_player = 0.5;
	n_dot_self = 0.1;
	n_distance_for_missiles = 12000;
	n_distance_for_missiles_sq = n_distance_for_missiles * n_distance_for_missiles;
	n_distance_for_missiles_max = 35000;
	n_distance_for_missiles_max_sq = n_distance_for_missiles_max * n_distance_for_missiles_max;
	n_distance_for_guns = 10000;
	n_distance_for_guns_sq = n_distance_for_guns * n_distance_for_guns;
	n_delay_between_fake_shots = 0.25;
	n_shots = Int( n_fire_time / n_delay_between_fake_shots );
	
	self _setup_plane_firing_by_type();
	
	while ( !flag( "dogfight_done" ) )
	{
		if ( self.state != "attack" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "attack" )
		{
			n_pattern = 0;
			continue;
		}		
		
		b_can_see_player = self is_looking_at( e_target.origin, n_dot_self );
		b_player_can_see_me = e_target is_looking_at( self.origin, n_dot_player );
		n_distance_sq = DistanceSquared( self.origin, level.player.origin );
		b_within_valid_missile_range = ( ( n_distance_sq > n_distance_for_missiles_sq ) && ( n_distance_sq < n_distance_for_missiles_max_sq ) );
		
		if ( b_within_valid_missile_range )
		{
			b_fired_missile = self try_to_fire_missile_at_player();
			
			if ( b_fired_missile )
			{
				self thread last_locked_draw( "fired" );
			}
		}		
		
		if ( b_can_see_player && b_player_can_see_me )
		{			
			//level thread draw_line_for_time( self.origin, e_target.origin, 1, 1, 1, 1 );

			// actually fire the turrets
			for ( i = 0; i < self.weapon_indicies.size; i++ )
			{
				n_index = self.weapon_indicies[ i ];
				self maps\_turret::set_turret_target( e_target, v_offset, n_index );	
				self thread maps\_turret::fire_turret_for_time( n_fire_time, n_index );
			}	
			
			// fake the damage 
			for ( j = 0; j < n_shots; j++ )
			{
				b_do_damage = false;
				b_can_see_player = self is_looking_at( e_target.origin, n_dot_self );
				b_player_can_see_me = e_target is_looking_at( self.origin, n_dot_player );
				b_within_range = ( n_distance_sq < n_distance_for_guns_sq );
				
				// fake damage, just like F35 vs planes
				if ( b_can_see_player && b_player_can_see_me && b_within_range )
				{
					if ( self maps\la_2_player_f35::_can_bullet_hit_target( self.origin, e_target ) )
		        	{
		        		b_do_damage = true;
		        	} 
		        	
		        	if ( b_do_damage )
		        	{
		        		n_damage = maps\la_2_player_f35::f35_guns_get_damage( e_target );
		        		level.f35 DoDamage( n_damage, level.f35.origin, self, self, "riflebullet" );
		        	}    
				}	

				wait n_delay_between_fake_shots;				
			}			
		}
		
		wait n_wait_time;
	} 
}

try_to_fire_missile_at_player()
{
	b_should_fire_missile = false;
	
	if ( is_alive( level.f35 ) )
	{
		if ( !IsDefined( level.f35.missile_lock_last_ended ) )
		{
			level.f35.missile_lock_last_ended = 0;  // time of last missile lock
		}
		
		if ( !IsDefined( level.f35.missile_lock_active ) )
		{
			level.f35.missile_lock_active = false;  // is F35 currently locked on by enemy?
		}
		
		if ( !IsDefined( level.f35_missile_lock_cooldown ) )
		{
			switch( GetDifficulty() )
			{
				case "easy":
					level.f35_missile_lock_cooldown = 10;  // seconds
					break;
				case "medium":
					level.f35_missile_lock_cooldown = 9;  // seconds
					break;
				case "hard":
					level.f35_missile_lock_cooldown = 8;  // seconds
					break;
				case "fu":
					level.f35_missile_lock_cooldown = 7;  // seconds
					break;	
			}
			
			level.f35_missile_lock_cooldown_ms = level.f35_missile_lock_cooldown * 1000;
		}
		
		n_kill_threshold = 1;
		n_time = GetTime();
		n_killed = level.aerial_vehicles.dogfights.killed_total;
		
		// should plane try to fire a missile at player?
		b_player_can_see_me = level.player is_looking_at( self.origin );
		b_missile_event_ready = ( n_killed > n_kill_threshold );
		b_is_locked_now = level.f35.missile_lock_active;
		b_cooldown_finished = ( n_time - level.f35.missile_lock_last_ended ) > level.f35_missile_lock_cooldown_ms;
		b_clear_line_of_sight = self _can_bullet_hit_target( self.origin, level.f35 );
		b_should_fire_missile = ( b_player_can_see_me && !b_is_locked_now && b_cooldown_finished && b_missile_event_ready && b_clear_line_of_sight && !flag( "dogfight_done" ) );
		
		if ( b_should_fire_missile )
		{
			self fire_lockon_missile_event();
		}
	}
	
	return b_should_fire_missile;
}

fire_lockon_missile_event()  // self = plane that fires a missile
{
	level.f35.missile_lock_active = true;
	
	// notify player missile is incoming
	flag_set( "missile_event_started" );
	
	// Notify the hud
	LUINotifyEvent( &"hud_missile_incoming", 1, 1 );
	
	// fire missile
	e_missile = MagicBullet( "pegasus_missile_turret_doublesize", self GetTagOrigin( "tag_flash_gunner1" ),  level.f35.origin, self, level.player );
	
	e_missile thread missile_event_track_missile();
	e_missile thread missile_event_enable_damage();
}

missile_event_enable_damage()
{
	self endon( "death" );
	
	self Solid();
	self SetCanDamage( true );
	
	self waittill( "damage" );	
	
	self ResetMissileDetonationTime( 0 );
}

missile_event_track_missile()  // self = missile
{
	n_speed = 10000;
	n_distance_failure = 512;
	n_distance_dodge = 2000;
	n_dodge_frames = 0;
	n_dodge_frames_success = 3;  // 0.15 seconds
	n_start_distance = undefined;
	
	if ( !IsDefined( level.dogfight_missiles_dodged ) )
	{
		level.dogfight_missiles_dodged = 0;
	}
	
	if ( !IsDefined( level.dogfight_missiles_hit ) )
	{
		level.dogfight_missiles_hit = 0;
	}
	
	if ( !IsDefined( level.dogfight_missile_hint_count ) )
	{
		level.dogfight_missile_hint_count = 0;
	}
	
	if ( level.dogfight_missiles_dodged == 0 )
	{
//		level thread maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_MISSILE_DODGE", undefined, ::missile_dodge_check, "dogfight_done" );
		level.convoy.vh_van thread say_dialog( "use_evasive_maneuv_014" );  //Use evasive maneuvers to avoid the missiles!
	}
	else if ( level.dogfight_missile_hint_count == 0 )
	{
		level.dogfight_missile_hint_count++;
//		level thread maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_MISSILE_BUILDINGS", undefined, ::missile_building_check, "dogfight_done" );
		level.convoy.vh_van thread say_dialog( "fly_low__you_can_012" );  //Fly low!  You can shake those missiles if you fly between the buildings.
	}
	
	// objective marker
	if ( !IsDefined( level.obj_missile_tracker ) )
	{
		level.obj_missile_tracker = 31;
		Objective_Add( level.obj_missile_tracker, "active" );
	}
	
	if ( IsDefined( self ) )
	{
		Objective_Position( level.obj_missile_tracker, self );
		Objective_Set3D( level.obj_missile_tracker, true, "red" );
	}
	
	// calculate time to impact
	
	// show player time to impact	
	
	b_hit_player = false;
	
	self thread missile_event_null_damage_after_death();
	
	while ( IsDefined( self ) )
	{
		n_distance = Distance( self.origin, level.f35.origin );
		n_time_to_impact = n_distance / n_speed;
		self ResetMissileDetonationTime( 10 );
		
		if ( !IsDefined( n_start_distance ) )
		{
			n_start_distance = Int( n_distance / 12 );
		}
		
		// Notify the hud
		LUINotifyEvent( &"hud_missile_incoming_dist", 2, Int( n_distance / 12 ), n_start_distance );
		
		//self thread draw_line_for_time( self.origin, level.f35.origin, 1, 0, 0, 0.05 );
		
		//iprintln( "missile impact in " + n_time_to_impact + " seconds" );
		
		b_player_dodging = level.player missile_event_is_player_dodging();
		
		if ( b_player_dodging )
		{
			n_dodge_frames++;
		}
		else 
		{
			n_dodge_frames = 0;
		}
		
		b_dodged_long_enough = ( n_dodge_frames > n_dodge_frames_success );
		
		if ( ( n_distance < n_distance_dodge ) && b_player_dodging && b_dodged_long_enough )
		{
			//iprintlnbold( "dodge success!" );
			level.dogfight_missiles_dodged++;
			self ResetMissileDetonationTime( 0 );
			break;
		}
		
		if ( n_distance < n_distance_failure )
		{
			b_hit_player = true;
			flag_set( "missile_can_damage_player" );
			//iprintlnbold( "missile hit player" );
			level.dogfight_missiles_hit++;
			break;
		}
		
		wait 0.05;
	}

	if ( !b_hit_player )
	{
		//iprintlnbold( "missile evaded" );
	}

	Objective_Set3D( level.obj_missile_tracker, false );
	
	flag_clear( "missile_event_started" );

	// Notify the hud
	LUINotifyEvent( &"hud_missile_incoming", 1, 0 );
	
	level.f35.missile_lock_active = false;
	level.f35.missile_lock_last_ended = GetTime();
}

missile_event_null_damage_after_death()
{
	flag_clear( "missile_can_damage_player" );
	
	self waittill( "death" );
	
	//iprintlnbold( "missile destroyed" );
	wait 1;
	flag_clear( "missile_can_damage_player" );
}

missile_dodge_check()
{
	b_dodge_passed = false;
	
	if ( level.dogfight_missiles_dodged > 0 )
	{
		b_dodge_passed = true;
	}
	
	return b_dodge_passed;
}

missile_building_check()
{
	return false;
}

missile_event_is_player_dodging()
{
	n_threshold = 0.5;
	b_dodge_passed = false;
	
	v_thumbstick = self GetNormalizedCameraMovement();
		
	n_push_strength = Length( v_thumbstick );
	
	if ( n_push_strength > n_threshold )
	{
		b_dodge_passed = true;
	}
	
	return b_dodge_passed;
}

_dogfight_fly_straight()
{
	self endon( "death" );
	
	if ( !IsDefined( self.states_available[ "fly_straight" ] ) )
	{
		self.states_available[ "fly_straight" ] = true;
	}
	
	n_near_fly_straight_goal = 1500;
	n_distance_slow_down = 3000;	
	n_time_scale = 10;
	self.last_time_flying_straight = 0;
	n_fly_straight_min_time = 7;
	n_fly_straight_min_time_ms = n_fly_straight_min_time * 1000;
	n_speed_min_plane = level.f35.speed_drone_min;
	n_speed_max_plane = level.f35.speed_drone_max;
	n_scale_forward = 20;
	
	b_fly_right = true;
	b_fly_up = true;
	n_scale_right_min = 350;
	n_scale_right_max = 500;
	n_scale_up_min = 400;
	n_scale_up_max = 800;
	
	while ( !flag( "dogfight_done" ) )
	{
		if ( self.state != "fly_straight" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "fly_straight" )
		{
			continue;
		}		
		
		//iprintlnbold( "flying straight" );	
		n_time = GetTime();
		
		if ( ( self.state_previous == "flyby" ) && ( !self.state_locked ) )
		{
			self.last_time_flying_straight = n_time;
			self.state_locked = true;
			//iprintlnbold( "flying straight locked" );
		}
		
		// no state lock for locked_on
		self SetNearGoalNotifyDist( n_near_fly_straight_goal );
		v_origin = self.origin;
		//v_angles = AnglesToForward( level.player GetPlayerAngles() );
		v_angles = AnglesToForward( self.angles );
		n_speed = self GetSpeedMPH();
		v_offset = ( 0, 0, 0 );
		
		if ( self.lockon_behavior_active )
		{
			v_right = AnglesToRight( self.angles );
			v_up = AnglesToUp( self.angles );
			
			if ( !b_fly_right )
			{
				v_right *= -1;  // flip to left
			}
			
			if ( !b_fly_up )
			{
				v_up *= -1;  // go down
			}
			
			b_fly_right = !b_fly_right;
			b_fly_up = !b_fly_up;
			n_scale_right = RandomIntRange( n_scale_right_min, n_scale_right_max );
			n_scale_up = RandomIntRange( n_scale_up_min, n_scale_up_max );
			
			v_offset = ( v_right * n_scale_right ) + ( v_up * n_scale_up );
		}
		
		v_goal = v_origin + ( v_angles * n_speed * n_scale_forward ) + v_offset;
		//level thread draw_line_for_time( self.origin, v_goal, 1, 1, 1, 5 );
		self _set_veh_goal_pos_dogfight( v_goal );		
		
		if ( !is_point_inside_volume( v_goal, level.dogfights_volume ) )
		{
			//iprintlnbold( "going back to downtown" );
			v_goal = level.dogfights_volume.origin;
		}
		
		//self thread draw_line_for_time( self.origin, v_goal, 1, 1, 1, 2 ); 			
		self _set_veh_goal_pos_dogfight( v_goal );
		self waittill( "near_goal" );		
		
		n_time = GetTime();
		if ( self.state_locked && ( ( n_time - self.last_time_flying_straight ) > n_fly_straight_min_time_ms ) )
		{
			self.last_time_flying_straight = n_time;
			self.state_lock = false;
			self notify( "can_change_state" );
	//		iprintlnbold( "flying straight UNlocked" );
		}		
	}	
}

_dogfight_locked_on_avenger()
{
	self endon( "death" );
	level endon( "dogfight_done" );
	
	self.lockon_behavior_active = false;
		
	while ( !flag( "dogfight_done" ) )
	{
		self waittill( "missileLockTurret_locked" );
		self.lockon_behavior_active = true;
		
		if ( is_alive( level.dogfights_last_locked ) )
		{
			level.dogfights_last_locked notify( "stop_draw_last_locked" );	
		}		
		
		self waittill( "missileLockTurret_cleared" );
		self.lockon_behavior_active = false;
		
		self thread last_locked_draw();
	}
}

last_locked_draw( str_text )  // self = plane that needs a hud element on it
{
	if ( !IsDefined( level.dogfights_last_locked_objective ) )
	{
		//maps\_objectives::set_objective( level.OBJ_DOGFIGHTS_LAST, undefined, undefined, 9999 );
		Objective_Add( level.OBJ_DOGFIGHTS_LAST, "current" );
		level.dogfights_last_locked_objective = true;
	}
	
	if ( !IsDefined( level.dogfights_last_locked_time ) )
	{
		level.dogfights_last_locked_time = 0;  // last time updated for last locked/fired objective marker
	}
	
	if ( is_alive( level.dogfights_last_locked ) )
	{
		level.dogfights_last_locked notify( "stop_draw_last_locked" );	
	}
	
	level.dogfights_last_locked = self;
	n_update_cooldown = 0.5;  // seconds
	n_update_cooldown_ms = n_update_cooldown * 1000; // ms
	
	if ( !IsDefined( str_text ) )
	{
		str_text = "last locked";
	}

	// dogfight planes already have an objective associated with them. simply swap out their distance marker for custom text, then put it back when done
	if ( IS_TRUE( self.is_dogfight_plane ) )
	{
		if ( IsDefined( self.dogfights_objective_index ) )
		{
			n_index = self.dogfights_objective_index;
			// temporarily clear his position, but don't free it for use...
			Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, ( 0, 0, 0 ) );
		}
	}
	
	n_time = GetTime();
	
	if ( ( n_time - level.dogfights_last_locked_time ) < n_update_cooldown_ms )
	{
		wait n_update_cooldown;
	}
	
	if ( is_alive( self ) && !flag( "dogfight_done" ) )
	{
		Objective_Position( level.OBJ_DOGFIGHTS_LAST, self );	
		level.dogfights_last_locked_time = GetTime();
		Objective_Set3D( level.OBJ_DOGFIGHTS_LAST, true, "default", str_text );
		
		self waittill_any( "stop_draw_last_locked", "death", "dogfight_done" );
		
		level.dogfights_last_locked_time = GetTime();
		Objective_Set3D( level.OBJ_DOGFIGHTS_LAST, false );
		
		if ( IS_TRUE( self.is_dogfight_plane ) )
		{
			//iprintlnbold( "restoring objective marker" );
			if ( IsDefined( self.dogfights_objective_index ) )
			{
				n_index = self.dogfights_objective_index;
				// restore the objective index to normal distance marker
				Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, self );		
			}
		}
	}
}

last_locked_clear()
{
	if ( IsDefined( level.dogfights_last_locked_objective ) )
	{
		if ( is_alive( level.dogfights_last_locked ) )
		{
			e_temp = level.dogfights_last_locked;
			
			e_temp notify( "stop_draw_last_locked" );
		}
	}
}


_dogfight_post_event()
{
	self endon( "death" );
	
	if ( !IsDefined( self.states_available[ "post_dogfight" ] ) )
	{
		self.states_available[ "post_dogfight" ] = true;
	}
	
	while ( true )
	{
		if ( self.state != "post_dogfight" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "post_dogfight" )
		{
			continue;
		}		
		
		self _set_veh_goal_pos_dogfight( self.escape_position );
		self waittill( "near_goal" );
		self Delete();
	}		
}

/*
_dogfight_behavior_template()
{
	self endon( "death" );
	
	if ( !IsDefined( self.states_available[ "new_behavior" ] ) )
	{
		self.states_available[ "new_behavior" ] = true;
	}
	
	while ( true )
	{
		if ( self.state != "new_behavior" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "new_behavior" )
		{
			continue;
		}		
		
		self.state_locked = true;
		// behavior here
		// ...
		// behavior loops
		self.state_locked = false;
		self notify( "plane_state_changed" );
	}	
}
*/

_dogfight_flyby_avenger()
{
	self endon( "death" );
	
	if ( !IsDefined( self.states_available[ "flyby" ] ) )
	{
		self.states_available[ "flyby" ] = true;
	}
	
	n_flyby_dist = 1500;
	
	while ( true )
	{
		if ( self.state != "flyby" )
		{
			self waittill( "plane_state_changed" );
		}
		
		if ( self.state != "flyby" )
		{
			continue;
		}		
		
		level.dogfights_flyby_last_time = GetTime();
		
		self.state_locked = true;
		self SetNearGoalNotifyDist( n_flyby_dist );
		
		// make sure player can't see plane that's about to teleport behind him
		while ( level.player is_looking_at( self.origin, 0.6 ) )
		{
			wait 0.5;
		}
		
		// check to see if available point has already passed, so find available point
		n_index = f35_get_available_approach_point();
		
		a_positions = f35_convert_index_to_strings( n_index );
		str_col = a_positions[ "col" ];
		str_row = a_positions[ "row" ];
		
		if ( n_index == 20 )
		{
			self dogfight_behavior_change_state( "attack" );	
			continue;
		}
		
		//iprintlnbold( "plane approaching now" );
		// move plane to approach point
		//self thread flyby_spline_approach( n_index, str_row, str_col );
		self approach_point_claim( n_index );
		self thread _approach_goal( str_row, str_col );
		
		// set up message for flyby notification
		if ( str_row == "right" )
		{
		    str_approach_clock = 4;
		}
		else if ( str_row == "center" )
		{
			str_approach_clock = 6;
		}
		else 
		{
			str_approach_clock = 4;
		}
		
		if ( str_col == "top" )
		{
			str_approach_height = "above";
		}
		else if ( str_col == "center" )
		{
			str_approach_height = "behind";
		}
		else 
		{
			str_approach_height = "below";
		}
		
		iprintln( "Enemy plane " + str_approach_height + " you, at " + str_approach_clock + " o'clock!" );
		
		// keep plane in position
		self waittill( "near_goal" );		
		self notify( "_stop_approach" );
		self notify( "free_approach_point" );
		//self SetSpeed( 400 );
		//iprintlnbold( "plane at goal" );

		self.state_locked = false;
		self notify( "can_change_state" );
	}	
}

// takes f35 approach ent index and converts it to row/col stings. returns an array with string indicies "row" and "col"
f35_convert_index_to_strings( n_index )
{
	switch ( n_index )
	{
		case 0:
			str_row = "left";
			str_col = "top";
			break;
			
		case 1:
			str_row = "center";
			str_col = "top";
			break;				
			
		case 2:
			str_row = "right";
			str_col = "top";
			break;

		case 3:
			str_row = "left";
			str_col = "center";
			break;

		case 4:
			str_row = "center";
			str_col = "center";
			break;

		case 5:
			str_row = "right";
			str_col = "center";
			break;

		case 6:
			str_row = "left";
			str_col = "bottom";
			break;				
			
		case 7:
			str_row = "center";
			str_col = "bottom";
			break;

		case 8:
			str_row = "right";
			str_col = "bottom";
			break;

		case 20:
			str_row = "";
			str_col = "";
			break;
			
		default:
			AssertMsg( n_index + " is not a valid approach point for use with _dogfight_flyby_avenger" );
			break;				
	}
	
	a_return = [];
	a_return[ "row" ] = str_row;
	a_return[ "col" ] = str_col;
	
	return a_return;
}

flyby_spline_approach( n_index, str_row, str_col )  // self = plane
{
	self endon( "death" );
	self endon( "reached_end_node" );
	
	self thread cancel_ai_move_after_spline();
	
	nd_temp = level.f35.a_flyby_index[ n_index ];
	
	n_speed_multiplier_min = 2.5;
	n_speed_multiplier_max = 3;
	n_speed_min = level.f35.speed_plane_max * n_speed_multiplier_min;
	n_speed_max = level.f35.speed_plane_max * n_speed_multiplier_max;
	
	n_speed_player = level.f35 GetSpeedMPH();
	n_speed_catch_rough = n_speed_player * n_speed_multiplier_max;
	n_speed_catch = clamp( n_speed_catch_rough, n_speed_min, n_speed_max );  // overtake player
	self SetSpeed( n_speed_catch );	
	
	e_approach = level.f35 f35_get_approach_point( str_row, str_col );
	self.origin = e_approach.origin;
	self.angles = e_approach.angles;
	self PathMove( nd_temp, e_approach.origin, e_approach.angles );
	self AttachPath( nd_temp );
	self StartPath( nd_temp );
	
	while ( true )
	{
		v_origin = e_approach.origin;
		v_angles = e_approach.angles;
		
		self PathMove( nd_temp, v_origin, v_angles );
		self thread draw_line_for_time( self.origin, v_origin, 1, 1, 1, 5 );
		iprintln( "moving spline" );
		
		wait 0.05;
	}
}

cancel_ai_move_after_spline()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	iprintln( "cancelAIMove" );
	
	self CancelAIMove();
}


// lock start: missileLockTurret_locked
// lock end: missileLockTurret_cleared
_lock_on_behavior()
{
	self endon( "death" );
	self endon( "disable_lock_on_behavior" );

	if ( !IsDefined( self.ent_flag[ "locked_on" ] ) )
	{
		self ent_flag_init( "locked_on" );
	}
	
	n_distance_max = 50000;
	n_distance_max_sq = n_distance_max * n_distance_max;
	n_speed_tolerance = 20;
	n_evade_scale_min = 100;
	n_evade_scale_max = 500;
	n_time_min = 3;
	n_time_max = 7;
	n_near_goal_while_locked = 1024;
	n_near_goal_while_not_locked = 5096;
	n_distance_slow_down = 3000;
	n_locked_on_time = 6;
	self.last_time_locked_on = 0;
	
	self thread drone_countermeasures_think();
	
	while ( true )
	{
		self waittill( "missileLockTurret_locked" );
		
		// clear last locked target since we're locked on now
		if ( is_alive( level.dogfights_last_locked ) )
		{
			//iprintlnbold( "target locked" );
			level.dogfights_last_locked notify( "stop_draw_last_locked" );
		}
		
		self ent_flag_set( "locked_on" );
		self SetNearGoalNotifyDist( n_near_goal_while_locked );
		self.last_time_locked_on = GetTime();
		
		//while( self.locked_on && ( DistanceSquared( self.origin, level.f35.origin ) < n_distance_max_sq ) )
		while ( self.locked_on )
		{
			//iprintlnbold( "missile locked" );
			n_dot_min = 0.7;
			n_dot_max = 1;
			
			n_speed_player = level.f35 GetSpeedMPH();
			n_speed_self = self GetSpeedMPH();
			n_time = GetTime();
			
			n_distance = Distance( self.origin, level.f35.origin );
			
			if ( n_distance > n_distance_slow_down )
			{
				self.slowed_down = true;
				self SetSpeed( 250 );
			}
			else 
			{
				self.slowed_down = false;
				self SetSpeed( 400 );
			}
			
			v_forward_self = AnglesToForward( self.angles );
			v_angles_player = level.player GetPlayerAngles();
			v_forward_player = AnglesToForward( v_angles_player );
			
			// should plane go up? should it go right?
			b_go_right = RandomInt( 2 );
			b_go_up = RandomInt( 2 );
			
			n_scale_right = -1;
			n_scale_up = -1;
			
			if ( b_go_right )
			{
				n_scale_right = 1;
			}
			
			if ( b_go_up )
			{
				n_scale_up = 1;
			}
			
			v_angles_right = ( AnglesToRight( v_angles_player ) ) * n_scale_right;  // use player
			v_angles_up = ( AnglesToUp( self.angles ) ) * n_scale_up;
			n_evade_scale_right = RandomIntRange( n_evade_scale_min, n_evade_scale_max );
			n_evade_scale_up = RandomIntRange( n_evade_scale_min, n_evade_scale_max );
			v_offset = ( v_angles_right * n_evade_scale_right ) + ( v_angles_up * n_evade_scale_up );
			
			n_time_scale = RandomFloatRange( n_time_min, n_time_max );
			v_current_path = v_forward_self * n_speed_player * n_time_scale;
			
			if ( ( n_time - self.last_time_locked_on ) > n_locked_on_time )
			{
				// level out current path
				v_current_path = ( v_current_path[ 0 ], v_current_path[ 1 ], 0 );
			}
			
			v_path_straight = self.origin + v_current_path;  // redirect plane to player's view
			//v_goal = v_path_straight + v_offset;
			v_goal = v_path_straight;
			
			if ( !is_point_inside_volume( v_goal, level.dogfights_volume ) )
			{
				v_goal = level.dogfights_volume.origin;
			}
			
			//self thread draw_line_for_time( self.origin, v_goal, 1, 1, 1, 2 ); 			
			self _set_veh_goal_pos_dogfight( v_goal );
			//self waittill_either( "missileLockTurret_cleared", "near_goal" );
			self waittill( "near_goal" );
		}
		
		self thread last_locked_draw();
		self SetNearGoalNotifyDist( n_near_goal_while_not_locked );
		self ent_flag_clear( "locked_on" );
	}
}

drone_countermeasures_think()
{
	self endon( "death" );
	
	// self init_chaff();  // TODO: decide on when it's appropriate to use chaff against player

	
	n_distance_right_min = 500;
	n_distance_right_max = 800;
	n_distance_up_min = 500;
	n_distance_up_max = 800;
	n_projectile_speed = 20000;  // taken from GDT for 'f35_missile_turret'. no code access to this field
	n_bank_up_chance = 70;  // percent
	n_bank_right_chance = 50;  // percent
	
	while ( true )
	{
		self waittill( "missileTurret_fired_at_me", e_missile );

		b_fired_chaff = try_to_use_chaff( e_missile );
		
		v_forward = AnglesToForward( self.angles );
		v_right = AnglesToRight( self.angles );
		v_up = AnglesToUp( self.angles );

		n_scale_right = RandomIntRange( n_distance_right_min, n_distance_right_max );
		n_scale_up = RandomIntRange( n_distance_up_min, n_distance_up_max );
		
		n_bank_right = RandomInt( 100 );
		n_bank_up = RandomInt( 100 );
		
		if ( n_bank_right > n_bank_right_chance )
		{
			v_right *= -1;
		}
		
		if ( n_bank_up > n_bank_up_chance )
		{
			v_up *= -1;
		}
		
		v_offset = ( v_right * n_scale_right ) + ( v_up * n_scale_up );
		
		n_distance_to_player = Distance( self.origin, level.player.origin );
		
		n_projected_time_to_impact = n_distance_to_player / n_projectile_speed;
		n_time_scaled = n_projected_time_to_impact * 2;
		
		v_goal = ( v_forward * n_time_scaled ) + v_offset;
		
		self _set_veh_goal_pos_dogfight( v_goal );
	}
}

init_chaff()
{
	n_chaff_max = 1;
	
	if ( !IsDefined( self.chaff_count ) )
	{
		self.chaff_count = n_chaff_max;
	}
}

// returns whether chaff was fired off
try_to_use_chaff( e_missile )
{
	b_used_chaff = false;
	
	if ( self can_use_chaff() )
	{
		b_used_chaff = true;
		self thread use_chaff( e_missile );
	}
	
	return b_used_chaff;
}

can_use_chaff()
{
	b_can_use_chaff = IsDefined( self.chaff_count ) && ( self.chaff_count > 0 );
	
	return b_can_use_chaff;
}

use_chaff( e_missile )
{	
	if ( IsDefined( e_missile ) && is_alive( self ) )
	{
		iprintln( "enemy countermeasures detected..." );
		self.chaff_count--;
		n_chaff_scale = 200;
		n_chaff_time = 6;
		
		// play chaff FX
		PlayFXOnTag( level._effect[ "chaff" ], self, "tag_origin" );
		
		// spawn chaff temp ent and move it
		v_forward = AnglesToForward( self.angles );
		v_right = AnglesToRight( self.angles );
		v_down = ( AnglesToUp( self.angles ) ) * ( -1 );
		v_chaff_pos = self.origin + ( v_down * n_chaff_scale );
		n_speed = self GetSpeedMPH();
		n_gravity = GetDvarInt( "phys_gravity" );
		v_gravity = GetDvarVector( "phys_gravity_dir" );
		v_chaff_direction = self.origin + ( v_forward * n_speed );
		
		v_chaff_dir = VectorNormalize( VectorScale( v_forward, -0.2 ) + v_right );
		
		v_velocity = VectorScale( v_chaff_dir, RandomIntRange(400, 600));
		v_velocity = ( v_velocity[0], v_velocity[1], v_velocity[2] - RandomIntRange(10, 100) );
		e_chaff = spawn( "script_model", v_chaff_pos );
		e_chaff SetModel( "tag_origin" );
		e_chaff MoveGravity( v_velocity, n_chaff_time );
		
		// redirect missile at chaff
		e_missile Missile_SetTarget( e_chaff );
		
		e_missile thread _detonate_missile_near_chaff( e_chaff );
		
		// wait until missile is dead
		wait n_chaff_time;
		
		// remove temp ent
		e_chaff Delete();
		
		if ( IsDefined( e_missile ) && is_alive( self ) )
		{
			e_missile notify( "stop_chasing_chaff" );
			e_missile Missile_SetTarget( self );
		}
	}
}

_detonate_missile_near_chaff( e_chaff )
{
	self endon( "death" );
	self endon( "stop_chasing_chaff" );
	
	n_distance_explode = 256;
	n_distance_explode_sq = n_distance_explode * n_distance_explode;
	
	while ( IsDefined( e_chaff ) && IsDefined( self ) )
	{
		n_distance_sq = DistanceSquared( self.origin, e_chaff.origin );
		
		if ( n_distance_sq < n_distance_explode_sq )
		{
			self notify( "death" );
			wait 0.1;  // this is so death blossom can pull radius from missile 
			self ResetMissileDetonationTime( 0 );  // weirdly phrased, but this blows up the missile
		}
		
		wait 0.1;
	}
}


dogfight_behavior_pegasus()
{
	e_target = level.player;
	//self thread _track_and_kill_target( e_target );
	dogfight_behavior_avenger(); 
}

// replace with add_spawn_function_veh?
plane_spawn( str_targetname, func_behavior, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_targetname ), "str_targetname is a required parameter for plane_spawn!" );
	
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_targetname );  // TODO: make this randomized
	
	vh_plane thread plane_counter();
	
	if ( IsDefined( func_behavior ) )
	{
		single_thread( vh_plane, func_behavior, param_1, param_2, param_3, param_4, param_5 );
	}
	
	return vh_plane;
}



uav_target_convoy_leader()
{
	while( !IsDefined( level.convoy.leader ) )
	{
		wait 0.05;
		//IPrintLnBold( "convoy leader undefined" );
	}
	
	vh_leader = level.convoy.leader;
	
	return vh_leader;
}

delay_weapon_firing( n_firing_wait, e_target, n_time, v_offset, n_index )
{
	self endon( "death" );
	
	wait n_firing_wait;
	
	if ( IsDefined( e_target ) )
	{
		self thread maps\_turret::shoot_turret_at_target( e_target, n_time, v_offset, n_index );
	}
}

fly_to_spline_end( s_start, b_should_delete )
{
	Assert( IsDefined( s_start.target ), "s_target at " + s_start.origin + " is missing a target" );
	s_next = get_struct( s_start.target, "targetname", true );
	b_should_chain = true;
	
	if ( !IsDefined( b_should_delete ) )
	{
		b_should_delete = false;
	}
	
	n_neargoal_dist_default = 5096;
	
	while ( b_should_chain )
	{
		s_current = s_next;

		n_neargoal_dist = n_neargoal_dist_default;

		if ( IsDefined( s_start.radius ) )
		{
			n_neargoal_dist = s_start.radius;
		}
		
		self SetNearGoalNotifyDist( n_neargoal_dist );
						
		self _set_veh_goal_pos_dogfight( s_current.origin );
		
		self waittill_any( "goal", "near_goal" );
		
		b_should_chain = false;
		
		if ( IsDefined( s_current.target ) )
		{
			s_next = get_struct( s_current.target, "targetname", true );
			b_should_chain = true;
			
			// should plane slow down for corner? by how much?
			n_dot = self get_dot_forward( s_next.origin, false, true );  // should this return dot * distance? 
			
			// slow down until: dot/distance ok
			
			// resume speed 			
			//self ResumeSpeed( 150 );
		}
	}
	
	if ( b_should_delete )
	{
		self Delete();	
	}
}

// set burst firing parameters and anything else special about firing, then return array of turret indicies
_setup_plane_firing_by_type()  // self = vehicle
{
	a_indicies = [];
	
	if ( IS_PEGASUS( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 4;
		n_wait_max = 8;
		
		if ( IS_TRUE( self.is_dogfight_plane ) )  // missiles handled separately in dogfights
		{
			a_indicies[ a_indicies.size ] = 0;  // guns
		}
		else 
		{
			// fire dual missiles
			a_indicies[ a_indicies.size ] = 1;	// missiles
			//a_indicies[ a_indicies.size ] = 2;  // removing firing from secondary missile turret to lower FX count				
		}
	}
	else if ( IS_AVENGER( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		// fire bullet weapon
		a_indicies[ a_indicies.size ] = 0;	// guns
	}
	else if ( IS_F35_FAST( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}				
	}
	else if ( IS_F35_VTOL( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}			
	}
	else if ( IS_F35_FAST( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}			
	}	
	else 
	{
		AssertMsg( self.vehicletype + " is not currently supported by _setup_plane_firing_by_type. implement this!" );
	}
	
	for ( i = 0; i < a_indicies.size; i++ )
	{
		n_index = a_indicies[ i ];
		self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index );
	}
	
	self.weapons_configured = true;
	self.weapon_indicies = a_indicies;
	
	return a_indicies;
}

_plane_move_to_point( s_position )  // self = plane
{
	Assert( IsDefined( s_position ), "s_position is a required parameter for _plane_move_to_point" );
	//Assert( IsDefined( s_position.angles ), "s_position at " + s_position.origin + "is missing angles for _plane_move_to_point" );
	
	self.origin = s_position.origin;
	
	if ( IsDefined( s_position.angles ) )
	{
		self.angles = s_position.angles;
	}
}
