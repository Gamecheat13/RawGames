/*
la_2_drones_ambient.gsc - contains all behavior logic for ambient drones throughout LA_2
 */

#include common_scripts\utility;
#include maps\_utility;

main()
{
	wait_for_first_player();
	
	_init_aerial_vehicles();
	level thread vehicle_clear_corpses();
	
	//a_structs = get_struct_array( "flight_point_struct", "targetname", true );
	a_structs = get_struct_array( "flight_point_ground_section", "script_noteworthy", true );
	a_start_points = get_struct_array( "drone_spawn_point", "targetname", true );
	sp_avenger = get_struct( "avenger_fast_la2_vehiclespawner", "targetname", true );
	sp_pegasus = get_struct( "pegasus_fast_la2_vehiclespawner", "targetname", true );
	sp_f35 = get_struct( "f35_fast_la2_vehiclespawner", "targetname", true );

	n_toggle = 0;
	
	while ( true )
	{
		n_max_drones = level.aerial_vehicles.circling_max_count;		
		n_current_drones = level.aerial_vehicles.circling.size;
		n_wait_time = 1;
		b_drone_slot_free = ( n_current_drones < n_max_drones );
		b_vehicle_slot_free = is_vehicle_slot_open();
		
		if ( b_drone_slot_free && b_vehicle_slot_free )
		{
			b_should_spawn_axis = false;
			b_should_spawn_ally = false;
			
			// 3:1 ratio in favor of axis
			n_ally_count = Int( n_max_drones * 0.25 );
			n_axis_count = Int( n_max_drones * 0.75 );
			
			if ( level.aerial_vehicles.allies.size < n_ally_count )
			{
				b_should_spawn_ally = true;
			}
			
			if ( level.aerial_vehicles.axis.size < n_axis_count )
			{
				b_should_spawn_axis = true;
			}
			
			if ( b_should_spawn_ally )
			{
				str_spawner_name = "f35_fast_la2";
				s_point = maps\la_2_fly::_get_random_element_player_cant_see( a_start_points );
				sp_f35.origin = s_point.origin;
			}
			else if ( b_should_spawn_axis )
			{
				if ( n_toggle )
				{
					n_toggle = 0;
					str_spawner_name = "pegasus_fast_la2";
					s_point = maps\la_2_fly::_get_random_element_player_cant_see( a_start_points );
					sp_pegasus.origin = s_point.origin;					
				}
				else
				{
					n_toggle = 1;
					str_spawner_name = "avenger_fast_la2";
					s_point = maps\la_2_fly::_get_random_element_player_cant_see( a_start_points );
					sp_avenger.origin = s_point.origin;
				}
			}
			
			vh_plane = plane_spawn( str_spawner_name, ::plane_ambient_behavior, a_structs, a_start_points );
			n_wait_time = 0.1;
		}
		
		wait n_wait_time;
	}
}

is_vehicle_slot_open()
{
	a_current_vehicles = GetVehicleArray();
	n_max_vehicles = 55;
	b_vehicle_slot_free = ( a_current_vehicles.size < n_max_vehicles );	
	
	return b_vehicle_slot_free;
}

vehicle_clear_corpses()
{
	n_wait_loop_min = 4;
	n_wait_loop_max = 6;
	n_delete_wait = 4;
	n_delete_wait_max = 15;
	n_delete_wait_max_ms = n_delete_wait_max * 1000;
	n_delete_wait_ms = n_delete_wait * 1000;
	b_do_trace = false;
	n_dot = 0.3;
	n_distance_auto_delete = 20000;
	n_distance_auto_delete_sq = n_distance_auto_delete * n_distance_auto_delete;
	
	while ( true )
	{
		a_corpses = get_ent_array( "script_vehicle_corpse", "classname" );
		
		for ( i = 0; i < a_corpses.size; i++ )
		{
			n_time_current = GetTime();			
			e_temp = a_corpses[ i ];
			
			if ( !IsDefined( e_temp.death_time ) )
			{
				e_temp.death_time = n_time_current;
			}
			
			n_time_since_death_ms = n_time_current - e_temp.death_time;
			b_time_to_delete = ( n_time_since_death_ms > n_delete_wait_ms );
			                    
			if ( b_time_to_delete )
			{
				b_can_player_see_corpse = level.player is_player_looking_at( e_temp.origin, n_dot, b_do_trace ); 
				n_distance = DistanceSquared( e_temp.origin, level.player.origin );
				b_corpse_out_of_range = ( n_distance > n_distance_auto_delete_sq );
				b_max_corpse_time_elapsed = ( n_delete_wait_max_ms > n_time_since_death_ms );
				
				if ( !b_can_player_see_corpse || b_corpse_out_of_range || b_max_corpse_time_elapsed )
				{					
					if ( IsDefined( e_temp.deathmodel_pieces ) )
					{
						array_delete( e_temp.deathmodel_pieces );
						e_temp.deathmodel_pieces = undefined;
					}					
					
					e_temp Delete();
				}
			}
		}
		
		n_wait = RandomFloatRange( n_wait_loop_min, n_wait_loop_max );
		wait n_wait;
	}
}


update_circling_plane_structs( str_manual_targetname, str_manual_key, n_distance_close_manual, n_distance_medium_manual )
{
	self notify( "_update_circling_plane_structs" );  // only run one copy of this at a time
	self endon( "_update_circling_plane_structs" );
	
	str_targetname = "flight_point_struct";
	str_key = "targetname";
	n_distance_close = 7500;
	n_distance_medium = 12000;
	
	n_update_min = 2;
	n_update_max = 3;
	
	if ( IsDefined( str_manual_targetname ) )
	{
		str_targetname = str_manual_targetname;
	}
	
	if ( IsDefined( str_manual_key ) )
	{
		str_key = str_manual_key;
	}
	
	if ( IsDefined( n_distance_close_manual ) )
	{
		n_distance_close = n_distance_close_manual;
	}
	
	if ( IsDefined( n_distance_medium_manual ) )
	{
		n_distance_medium = n_distance_medium_manual;
	}
	
	a_all_flight_points = get_struct_array( str_targetname, str_key );
	
	//iprintlnbold( "update_circling_plane_structs running..." );
	
	while ( true )
	{
		n_update_time = RandomFloatRange( n_update_min, n_update_max );
		wait n_update_time;
		
		//v_reference_point = level.f35.origin;
		//v_angles = AnglesToForward( level.f35.angles );
		//n_scale = 1000;
		//v_reference_point = level.f35.origin + ( v_angles * 1000 );
		v_reference_point = level.player.origin;
		
		a_structs_close = get_within_range( v_reference_point, a_all_flight_points, n_distance_close );
		a_structs_medium_all = get_within_range( v_reference_point, a_all_flight_points, n_distance_medium );
		a_structs_medium = array_exclude( a_structs_medium_all, a_structs_close );
		
		n_structs_close = a_structs_close.size;
		
		if ( n_structs_close < 30 )
		{
		//	iprintlnbold( n_structs + " found within " +n_distance_close + " units of " + v_reference_point );
		}
		
		level.aerial_vehicles.valid_structs = a_all_flight_points;
		level.aerial_vehicles.valid_structs_close = a_structs_close;
		level.aerial_vehicles.valid_structs_medium = a_structs_medium;
	}
}

plane_ambient_behavior( a_structs, a_start_points )
{
	self endon( "death" );
	
	self ent_flag_init( "is_tracking" );
	n_goal_notify_distance = 5096;
	n_speed_max = 450;
	n_speed_min = 425;
	n_speed = RandomIntRange( n_speed_min, n_speed_max );
	self SetSpeed( n_speed );
	self SetNearGoalNotifyDist( n_goal_notify_distance );		
	
	s_fake_spawn_point = random( a_start_points );
	self _plane_move_to_point( s_fake_spawn_point );

	self thread _lock_on_behavior();
	self thread fly_to_random_struct( a_structs );  // runs when 'is_tracking' is false
	self thread track_and_shoot_target();  // runs when 'is_tracking' is true 
	self thread _track_circling_planes();
	self thread missile_lock_watcher();
}

missile_lock_watcher()
{
	self endon( "death" );
	level endon( "dogfight_done" );
	
	self.lockon_behavior_active = false;
	
	flag_wait( "convoy_at_dogfight" );
	
	while ( !flag( "dogfight_done" ) )
	{
		self waittill( "missileLockTurret_locked" );
		level.f35 notify( "missile_turret_locked", self );
		self.lockon_behavior_active = true;
		
		// clear last locked target since we're locked on now
		if ( is_alive( level.dogfights_last_locked ) )
		{
			//iprintlnbold( "target locked" );
			level.dogfights_last_locked notify( "stop_draw_last_locked" );
		}		
		
		self waittill( "missileLockTurret_cleared" );
		level.f35 notify( "missile_turret_cleared", self );
		self.lockon_behavior_active = false;
		
		self thread maps\la_2_fly::last_locked_draw();
	}
}

track_and_shoot_target()
{
	self endon( "death" );
	self endon( "stop_ambient_behavior" );
	
	n_wait_min = 0.5;
	n_wait_max = 1.5;
	
	while( IsAlive( self ) )
	{
		b_has_target = self _does_plane_have_target();
		b_is_being_tracked = self _is_plane_being_tracked();
		
		if ( !b_has_target && !b_is_being_tracked )
		{
			e_target = self _find_plane_target();
			self _track_and_kill_target( e_target );
		}
		
		n_wait = RandomFloatRange( n_wait_min, n_wait_max );
		wait n_wait;
	}
}

_is_plane_being_tracked()  // self = plane
{	
	b_is_being_tracked = false;
	
	// have I been tracked before?
	if ( !IsDefined( self.being_tracked ) )
	{
		b_is_being_tracked = false;
	}
	
	// if I've been tracked before, is my attacker still alive?
	if ( IsDefined( self.being_tracked ) && IsAlive( self.being_tracked ) )
	{
		b_is_being_tracked = true;
	}
	
	return b_is_being_tracked;
}

_track_and_kill_target( e_target )
{
	self notify( "_stop_tracking_plane" );
	self endon( "_stop_tracking_plane" );
	self endon( "death" );
	
	n_wait_time_min = 0.8;
	n_wait_time_max = 1.5;
	
	self ent_flag_set( "is_tracking" );
	
	if ( !IsDefined( self.weapons_configured ) )
	{
		self _setup_plane_firing_by_type();
	}
	
	// fire all weapons forever as set by burst parameters. weapon_indicies parameter set in _setup_plane_firing_by_type()
	for ( i = 0; i < self.weapon_indicies.size; i++ )
	{
		n_index = self.weapon_indicies[ i ];
		//self thread maps\_turret::shoot_turret_at_target( e_target, -1, ( 0, 0, -80 ), n_index );
		//println( self.vehicletype + " is using turret index " + n_index );
		self thread maps\_turret::set_turret_target( e_target, ( 0, 0, -80 ), n_index );	
		self thread maps\_turret::fire_turret_for_time( -1, n_index );
	}	
	
	// movement: track target's position
	while ( IsAlive( e_target ) )
	{
		//self SetVehGoalPos( e_target.origin );
		self SetVehGoalPos( e_target.next_goal_pos );
		
		//self thread draw_line_for_time( self.origin, e_target.origin, 1, 1, 1, 1 );
		//self thread _print_goal_line( e_target, 1, 0, 0 );
		n_wait_time = RandomFloatRange( n_wait_time_min, n_wait_time_max );
		//self waittill_notify_or_timeout( "near_goal", n_wait_time );
		self waittill( "near_goal" );
	}
	
	// stop all turret firing
	for ( i = 0; i < self.weapon_indicies.size; i++ )
	{
		n_index = self.weapon_indicies[ i ];
		self stop_turret( n_index );
	}
	
	self ent_flag_clear( "is_tracking" );	
}

_does_plane_have_target()
{
	b_has_target = false;
	
	if ( IsDefined( self.plane_target ) )
	{
		b_has_target = true;
	}
	
	return b_has_target;
}

_find_plane_target()
{
	self endon( "death" );
	
	str_team = self.vteam;	
	b_target_is_open = false;
	b_is_ally = false;
	b_is_axis = false;
	
	if ( str_team == "allies" )
	{
		b_is_ally = true;
	}
	else if (str_team == "axis" )
	{
		b_is_axis = false;
	}
	else
	{
		AssertMsg( self.vteam + " is not a supported vehicle team for _find_plane_target!" );
	}	
	
	while( !b_target_is_open )
	{
		wait RandomFloatRange( 2.0, 4.0 );

		if ( b_is_ally )
		{
			a_targets = level.aerial_vehicles.axis;
		}
		else
		{
			a_targets = level.aerial_vehicles.allies;
		}
		
		if ( a_targets.size == 0 )
		{
			wait 1;
			continue;
		}
		
		e_target = random( a_targets );
		
		b_target_is_alive = IsDefined( e_target );
		b_target_out_of_combat = b_target_is_alive && !( e_target _is_plane_being_tracked() );
		b_can_track = !IsDefined( e_target.no_tracking );
		
		if ( b_target_is_alive && b_target_out_of_combat && b_can_track )
		{
			b_target_is_open = true;
			self.plane_target = e_target;
			e_target.plane_target = undefined;
			e_target.being_tracked = self;
			e_target ent_flag_clear( "is_tracking" );			
		}
	}
	
	return e_target;	
}

fly_to_random_struct( a_structs )
{
	self endon( "death" );
	self endon( "stop_ambient_behavior" );
	
	while ( true )
	{
		if ( IsDefined( level.aerial_vehicles.valid_structs ) )
		{
			a_structs = level.aerial_vehicles.valid_structs;
		}
		
		b_should_circle_close = IsDefined( self.circle_player_location ) && ( self.circle_player_location );
		b_can_circle_close = IsDefined( level.aerial_vehicles.valid_structs_close ) && ( level.aerial_vehicles.valid_structs_close.size > 0 );
		
		if ( b_should_circle_close && b_can_circle_close )
		{
			a_structs = level.aerial_vehicles.valid_structs_close;
		}
		else if ( IsDefined( level.aerial_vehicles.valid_structs_medium ) && ( level.aerial_vehicles.valid_structs_medium.size > 0 ) )
		{
			a_structs = level.aerial_vehicles.valid_structs_medium;
		}
		
		self ent_flag_waitopen( "locked_on" );
		self ent_flag_waitopen( "is_tracking" );
		
		s_current = random( a_structs );
		
		self.next_goal_pos = s_current.origin;
		self SetVehGoalPos( s_current.origin );
		//self thread _print_goal_line( s_current );
		self waittill( "near_goal" );
		
		wait 0.25;
	}
}


_kill_off_excess_drones()
{
	//println( "killing off excess drones..." );
	n_drone_max = level.aerial_vehicles.circling_max_count;	
	n_drone_count = level.aerial_vehicles.circling.size;
	a_drones = level.aerial_vehicles.circling;
	n_wait_min = 0.5;
	n_wait_max = 2.0;
	n_dot_range = 0.1;
	b_do_trace = false;
	e_player = level.player;
	
	while ( level.aerial_vehicles.circling.size > n_drone_max ) 
	{
		n_drone_max = level.aerial_vehicles.circling_max_count;		
		vh_drone = random( a_drones );
		//vh_drone notify( "death" );		
		
		if ( !IsDefined( vh_drone ) )
		{
			wait 0.05;
			continue;
		}
		
		b_can_see_drone = e_player is_looking_at( vh_drone.origin, n_dot_range, b_do_trace );
		
		if ( !b_can_see_drone )
		{
		//	vh_drone DoDamage( vh_drone.health, vh_drone.origin );
			vh_drone Delete();
		}
		
		println( "level.aerial_vehicles.circling.size = " + level.aerial_vehicles.circling.size + ". drone max = " + n_drone_max );
		n_wait = RandomFloatRange( n_wait_min, n_wait_max );
		wait n_wait;
	}
	
	//iprintln( "killing off excess drones done." );
}



_track_circling_planes()
{
	b_is_circling_player = false;
	
	if ( !IsDefined( level.aerial_vehicles ) )
	{
		_init_aerial_vehicles();
	}

	if ( !IsDefined( level.aerial_vehicles.circling ) )
	{
		level.aerial_vehicles.circling = [];
	}
	
	if ( !IsDefined( level.aerial_vehicles.circling_close ) )
	{
		level.aerial_vehicles.circling_close = [];
	}
	
	level.aerial_vehicles.circling[ level.aerial_vehicles.circling.size ] = self;
	
	n_close_count = level.aerial_vehicles.close_count;
	b_should_circle_close = ( level.aerial_vehicles.circling_close_allowed ) && ( n_close_count > level.aerial_vehicles.circling_close.size );
	
	if ( b_should_circle_close )
	{
		b_is_circling_player = true;
		level.aerial_vehicles.circling_close[ level.aerial_vehicles.circling_close.size ] = self;
		self.circle_player_location = true;
	}
	
	self waittill( "death", e_killer );
	self track_planes_killed_by_player( e_killer );
	
	level.aerial_vehicles.circling = array_removeDead( level.aerial_vehicles.circling );
	
	if ( b_is_circling_player )
	{
		level.aerial_vehicles.circling_close = array_removeDead( level.aerial_vehicles.circling_close );
	}
}

track_planes_killed_by_player( e_attacker )
{
	b_does_attacker_exist = IsDefined( e_attacker );
	b_is_player = b_does_attacker_exist && IsPlayer( e_attacker );
	b_is_during_dogfights = ( flag( "convoy_at_dogfight" ) && !flag( "dogfight_done" ) );
	
	// track misc vehicles killed during dogfights
	if ( b_is_player && b_is_during_dogfights )
	{
		level.aerial_vehicles.dogfights.killed_total++;
		maps\la_2_fly::dogfights_objective_update_counter();
	}
	
	if ( b_is_player )  // track ambient plane kills by player
	{
		level.aerial_vehicles.player_killed_total++;
	}
	
	if ( b_is_player && ( self ent_flag( "is_tracking" ) ) )
	{
		iprintln( "player_saved_tracked_friendly_f35" );
		level notify( "player_saved_tracked_friendly_f35" );
	}
}

// plays special fx on ground/building collision
crash_landing_fx()
{
	// TODO: endon timeout?
	
	self waittill( "veh_collision" );
	
	if ( !IsDefined( level.green_zone_volume ) )
	{
		level.green_zone_volume = get_ent( "green_zone_volume", "targetname", true );
	}
	
	b_is_in_playable_space = self IsTouching( level.green_zone_volume );
	
	if ( b_is_in_playable_space )  // persistent fires occur in playable space
	{
		// determine which effect to play, based on surface plane collided with
		v_forward = AnglesToForward( self.angles );
		n_scale = 1000;
		v_trace_pos = self.origin + ( v_forward * n_scale );
		
		a_trace = BulletTrace( self.origin, v_trace_pos, false, self );
		str_surface = a_trace[ "surfacetype" ];
		v_normal = ( a_trace[ "normal" ] * -1 );
		b_hit_glass = IsSubStr( str_surface, "ice" );  // "ice" is the surface type for glass
		
		n_fx_id = level._effect[ "plane_crash_smoke_concrete" ];  // default fx to play inside playable space
		n_fx_id_papers = level._effect[ "drone_building_impact_paper_concrete" ];
		
		if ( b_hit_glass ) 
		{
			n_fx_id = level._effect[ "plane_crash_smoke_glass" ];  // glass has special fx
			n_fx_id_papers = level._effect[ "drone_building_impact_paper_glass" ];
		}
			
		if ( !IsDefined( level.persistent_fires ) )
		{
			level.persistent_fires = [];
		}
		
		e_temp = Spawn( "script_model", self.origin );
		e_temp SetModel( "tag_origin" );
		n_time = GetTime();
		e_temp.fx_start_time = n_time;  // monitor how long this has played
		
		PlayFxOnTag( n_fx_id, e_temp, "tag_origin" );
		PlayFX( n_fx_id_papers, e_temp.origin, v_forward );  // play paper fx on impact, too
		
		if ( level.persistent_fires.size > level.PERSISTENT_FIRES_MAX )
		{
			e_fire = maps\la_2_fly::_get_random_element_player_cant_see( level.persistent_fires );		
			level.persistent_fires = array_remove( level.persistent_fires, e_fire );
			
			if ( IsDefined( e_fire ) )  // two fires can appear simultaneously
			{
				e_fire Delete();
			}
		}
		
		level.persistent_fires[ level.persistent_fires.size ] = e_temp;		
		println( "persistent fires = " + level.persistent_fires.size );
	}
	else  // outside playable space, fx exist for ~15 seconds then die off. don't monitor
	{
		n_fx_id = level._effect[ "plane_crash_smoke_distant" ];  // default fx to play outside playable space
		PlayFx( n_fx_id, self.origin );
	}
}

aerial_vehicles_set_circling_close( b_allow_circling_close )
{
	Assert( IsDefined( b_allow_circling_close ), "b_allow_circling_close is a required parameter for aerial_vehicles_set_circling_close" );
	
	level.aerial_vehicles.circling_close_allowed = b_allow_circling_close;	
	
	if ( !b_allow_circling_close )
	{
		a_temp = level.aerial_vehicles.circling_close;
		for ( i = 0; i < a_temp.size; i++ )
		{
			a_temp[ i ].circle_player_location = false;
		}
		a_temp = [];
		level.aerial_vehicles.circling_close = a_temp;
	}
	else
	{
		n_count = level.aerial_vehicles.close_count;
		
		while ( n_count > level.aerial_vehicles.circling_close.size )
		{
			vh_temp = random( level.aerial_vehicles.axis );
			b_is_being_tracked = vh_temp _is_plane_being_tracked();
			
			if ( !b_is_being_tracked )
			{
				vh_temp.circle_player_location = true;
				level.aerial_vehicles.circling_close[ level.aerial_vehicles.circling_close.size ] = vh_temp;
			}
			
			wait 0.05;
		}
	}
}

_set_max_circling_count( n_count )
{
	Assert( IsDefined( n_count ), "n_count is a required parameter for _set_max_circling_count" );
	
	level.aerial_vehicles.circling_max_count = n_count;
	
	_kill_off_excess_drones();			
}

_init_aerial_vehicles()
{
	if ( !IsDefined( level.aerial_vehicles ) )
	{
		level.aerial_vehicles = SpawnStruct();
	}
	
	if ( !IsDefined( level.aerial_vehicles.count ) )
	{
		level.aerial_vehicles.count = 0;
	}
	
	if ( !IsDefined( level.aerial_vehicles.allies ) )
	{
		level.aerial_vehicles.allies = [];
	}
	
	if ( !IsDefined( level.aerial_vehicles.axis ) )
	{
		level.aerial_vehicles.axis = [];
	}	
	
	if ( !IsDefined( level.aerial_vehicles.close_count ) )
	{
		level.aerial_vehicles.close_count = 10;
	}
	
	if ( !IsDefined( level.aerial_vehicles.valid_structs_medium ) )
	{
		level.aerial_vehicles.valid_structs_medium = [];
	}
	
	if ( !IsDefined( level.aerial_vehicles.circling ) )
	{
		level.aerial_vehicles.circling = [];
	}
	
	if ( !IsDefined( level.aerial_vehicles.circling_close_allowed ) )
	{
		level.aerial_vehicles.circling_close_allowed = true;
	}
	
	if ( !IsDefined( level.aerial_vehicles.circling_max_count ) )
	{
		level.aerial_vehicles.circling_max_count = 30;
	}
	
	if ( !IsDefined( level.aerial_vehicles.dogfights ) )
	{
		level.aerial_vehicles.dogfights = SpawnStruct();
	}
	
	if ( !IsDefined( level.aerial_vehicles.dogfights.waves ) )
	{		
		// wave 1
		n_avengers = 5;  // 5
		n_pegasus = 0;
		n_heli = 0;
		_dogfights_setup_wave_parameters( n_avengers, n_pegasus, n_heli );
		
		// wave 2
		n_avengers = 5;  // 5
		n_pegasus = 1;  // 1
		n_heli = 0;
		_dogfights_setup_wave_parameters( n_avengers, n_pegasus, n_heli );
		
		// wave 3
		n_avengers = 5;  // 5
		n_pegasus = 2;  // 2
		n_heli = 0;
		_dogfights_setup_wave_parameters( n_avengers, n_pegasus, n_heli );	

		// wave 4
		n_avengers = 5;  // 5
		n_pegasus = 3;  // 3
		n_heli = 0;
		_dogfights_setup_wave_parameters( n_avengers, n_pegasus, n_heli );		
		
		// wave 5
		n_avengers = 5;  // 5
		n_pegasus = 4;  // 4
		n_heli = 0;
		_dogfights_setup_wave_parameters( n_avengers, n_pegasus, n_heli );
	}
	
	if ( !IsDefined( level.aerial_vehicles.dogfights.current_wave ) )
	{
		level.aerial_vehicles.dogfights.current_wave = 0;
	}
	
	if ( !IsDefined( level.aerial_vehicles.dogfight_targets ) )
	{
		level.aerial_vehicles.dogfights.dogfight_targets = 0;
	}
	
	if ( !IsDefined( level.aerial_vehicles.spawned_this_wave ) )
	{
		level.aerial_vehicles.dogfights.spawned_this_wave = 0;
	}
	
	if ( !IsDefined( level.aerial_vehicles.killed_this_wave ) )
	{
		level.aerial_vehicles.dogfights.killed_this_wave = 0;
	}	
	
	if ( !IsDefined( level.aerial_vehicles.player_killed_total ) )
	{
		level.aerial_vehicles.player_killed_total = 0;
	}		
	
	if ( !IsDefined( level.aerial_vehicles.dogfights.targets ) )
	{
		level.aerial_vehicles.dogfights.targets = [];
	}
	
	if ( !IsDefined( level.aerial_vehicles.dogfights.killed_total ) )
	{
		level.aerial_vehicles.dogfights.killed_total = 0;
	}
}

_dogfights_setup_wave_parameters( n_avenger_count, n_pegasus_count, n_heli_count )
{
	if ( !IsDefined( level.aerial_vehicles.dogfights.waves ) )
	{	
		level.aerial_vehicles.dogfights.waves = [];	
	}
	
	a_wave = [];
	a_wave[ "avengers" ] = n_avenger_count;
	a_wave[ "pegasus" ] = n_pegasus_count;
	a_wave[ "helicopters" ] = n_heli_count;		
	a_wave[ "avengers_spawned" ] = 0;
	a_wave[ "pegasus_spawned" ] = 0;
	a_wave[ "helicopters_spawned" ] = 0;
	a_wave[ "killed_this_wave" ] = 0;
	
	level.aerial_vehicles.dogfights.waves[ level.aerial_vehicles.dogfights.waves.size ] = a_wave;
}

plane_counter()
{
	level.aerial_vehicles.count++;

	b_is_ally = false;
	b_is_axis = false;
	str_team = self.vteam;
	
	if ( str_team == "allies" )
	{
		b_is_ally = true;
	}
	else if ( str_team == "axis" )
	{
		b_is_axis = true;
	}
	
	if ( b_is_ally )
	{
		level.aerial_vehicles.allies[ level.aerial_vehicles.allies.size ] = self;
	}
	else if ( b_is_axis )
	{
		level.aerial_vehicles.axis[ level.aerial_vehicles.axis.size ] = self;
	}
	else
	{
		AssertMsg( "vehicle team " + str_team + " is not a valid team tracked by plane_counter()!" );
	}
	
	self waittill( "death" );
	
	level.aerial_vehicles.count--;
	
	if ( b_is_ally )
	{
		level.aerial_vehicles.allies = array_removeDead( level.aerial_vehicles.allies );
	}
	else 
	{
		level.aerial_vehicles.axis = array_removeDead( level.aerial_vehicles.axis );
	}
}
