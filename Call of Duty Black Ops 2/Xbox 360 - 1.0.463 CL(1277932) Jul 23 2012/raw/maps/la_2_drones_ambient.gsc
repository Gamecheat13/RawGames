/*
la_2_drones_ambient.gsc - contains all behavior logic for ambient drones throughout LA_2
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\la_2_fly;
#include maps\la_utility;

#insert raw\maps\_utility.gsh;

#define MIN_SPAWN_DISTANCE 20000
main()
{
	wait_for_first_player();
	
	_init_aerial_vehicles();
	level thread vehicle_clear_corpses();	
}

vehicle_clear_corpses()
{
	const n_wait_loop_min = 4;
	const n_wait_loop_max = 6;
	const n_delete_wait = 4;
	const n_delete_wait_max = 15;
	n_delete_wait_max_ms = n_delete_wait_max * 1000;
	n_delete_wait_ms = n_delete_wait * 1000;
	b_do_trace = true;
	const n_dot = 0.5;
	const n_distance_auto_delete = 20000;
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
			b_can_free = !IsDefined( e_temp.dontfreeme );  // if .dontfreeme isn't defined, it's able to use FreeVehicle()
			b_time_to_delete = b_can_free && ( n_time_since_death_ms > n_delete_wait_ms );
			                    
			if ( b_time_to_delete )
			{
				b_can_player_see_corpse = level.player is_looking_at( e_temp.origin, n_dot, b_do_trace ); 
				n_distance = DistanceSquared( e_temp.origin, level.player.origin );
				b_corpse_out_of_range = ( n_distance > n_distance_auto_delete_sq );
				b_max_corpse_time_elapsed = ( n_delete_wait_max_ms < n_time_since_death_ms );
				
				if ( !b_can_player_see_corpse && ( b_corpse_out_of_range || b_max_corpse_time_elapsed ) )
				{					
					// F35s, pegasus, avenger planes
					if ( IsDefined( e_temp.deathmodel_pieces ) )
					{
						array_delete( e_temp.deathmodel_pieces );
						e_temp.deathmodel_pieces = undefined;
					}

					// bigrigs
					if ( IsDefined( e_temp.trailer_model ) )
					{
						e_temp.trailer_model Delete();
					}
					
					e_temp Delete();
				}
			}
		}
		
		n_wait = RandomFloatRange( n_wait_loop_min, n_wait_loop_max );
		wait n_wait;
	}
}

// plays special fx on ground/building collision
crash_landing_fx()
{
	self endon( "death" );
	
	self waittill( "veh_collision" );
	
	if ( !IsDefined( level.green_zone_volume ) )
	{
		level.green_zone_volume = get_ent( "green_zone_volume", "targetname", true );
	}
	
	b_is_in_playable_space = self IsTouching( level.green_zone_volume );
	b_hit_building_wrap = self _did_drone_hit_building_wrap();
	
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
		
		if ( b_hit_building_wrap ) 
		{
			n_fx_id_papers = level._effect[ "building_wrap_impact_sparks" ];
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
			e_fire = _get_random_element_player_cant_see( level.persistent_fires );		
			ArrayRemoveValue( level.persistent_fires, e_fire );
			
			if ( IsDefined( e_fire ) )  // two fires can appear simultaneously
			{
				e_fire Delete();
			}
		}
		
		level.persistent_fires[ level.persistent_fires.size ] = e_temp;		
		/#println( "persistent fires = " + level.persistent_fires.size );#/
	}
	else  // outside playable space, fx exist for ~15 seconds then die off. don't monitor
	{
		n_fx_id = level._effect[ "plane_crash_smoke_distant" ];  // default fx to play outside playable space
		PlayFx( n_fx_id, self.origin );
	}
}

_did_drone_hit_building_wrap()
{
	if ( !IsDefined( level.building_wrap_volumes ) )
	{
		level.building_wrap_volumes = get_ent_array( "building_wrap_volume", "targetname", true );
	}

	b_hit_building_wrap = false;

	for ( i = 0; i < level.building_wrap_volumes.size; i++ )
	{
		if ( self IsTouching( level.building_wrap_volumes[ i ] ) )
		{
			b_hit_building_wrap = true;
		}
	}
	
	return b_hit_building_wrap;
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
	b_is_ally = self _increment_plane_count();
	
	self waittill( "death" );
	
	self _decrement_plane_count( b_is_ally );
}

_increment_plane_count()
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
	
	return b_is_ally;
}

_decrement_plane_count( b_is_ally )
{
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

_get_random_element_player_can_see( a_elements, n_distance )
{
	Assert( IsDefined( a_elements ), "a_elements is a required parameter for _get_random_element_player_can_see" );
	Assert( ( a_elements.size > 0 ), "a_elements needs to contain at least one element in _get_random_element_player_can_see" );
	
	b_found_element = false;
	e_player = level.player;
	const n_dot_range = 0.6;
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
	const n_dot_range = 0.3;
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

/*
dogfight_ambient_drone_spawn_manager()
{
	level endon( "kill_ambient_drone_spawn_manager" );
	
	level.zones = [];
	level.zones[0] = "ambient_north_loop";
	level.zones[1] = "ambient_east_loop";
//	zones[2] = "city_1_loop";

//	level thread zone_trigger_watch( "trig_ambient_west" );
//	level thread zone_spawn_planes( "trig_ambient_west", "west" );		
//
//	level thread zone_trigger_watch( "trig_ambient_north" );
//	level thread zone_spawn_planes( "trig_ambient_north", "north" );	
//	
//	level thread zone_trigger_watch( "trig_ambient_east" );
//	level thread zone_spawn_planes( "trig_ambient_east", "east" );		
	
	
}


dogfight_ambient_drone_spawn_manager()
{
	level endon( "kill_ambient_drone_spawn_manager" );
	
	zones = [];
	zones[0] = "south_west_corner_start";
	zones[1] = "south_east_corner";
	zones[2] = "north_east_loop_start";
	zones[3] = "north_west_corner_start";
	
	while ( !flag( "dogfight_done" ) )
	{
		wait( 2 );
		
		closest = 999999;
		closest_index = -1;
		for ( i = 0; i < zones.size; i++ )
		{
			node = GetVehicleNode( zones[i], "targetname" );
			dist = Distance2D( node.origin, level.player.origin );
			if( dist < closest )
			{
				dot = VectorDot( VectorNormalize( node.origin - level.player.origin ), AnglesToForward( level.player.viewlockedentity.angles ) );
				if ( dot > 0.0 && dot < 0.9  )
				{
					closest = dist;
					closest_index = i;
				}
			}
		}
		
		if ( closest_index >= 0 )
		{
			start_node = zones[ closest_index ]; //get_best_spline_node( zones[closest_index] );
			
			n_spawn_count = 5;
			if ( level.aerial_vehicles.count + n_spawn_count + 2 > 50 )
			{
				deleted = level cleanup_ambient_drones( n_spawn_count * 4, 50000 );
				if ( deleted >= n_spawn_count )
				{
					level thread maps\la_2_fly::spawn_plane_group( start_node, n_spawn_count, "pegasus_ground_ambient_flyby_2", "f38_ground_ambient_flyby_2" );	
					level waittill( "ambient_drone_spawn_done" );
				}
			}
			else
			{
				level thread maps\la_2_fly::spawn_plane_group( start_node, n_spawn_count, "pegasus_ground_ambient_flyby_2", "f38_ground_ambient_flyby_2" );					
				level waittill( "ambient_drone_spawn_done" );				
			}
		}
	}
}

*/

dogfight_ambient_drone_spawn_manager()
{
	level endon( "kill_ambient_drone_spawn_manager" );
	
	level.zone_drone_counts = [];
	level.zone_drone_counts[ "trig_ambient_east" ] = 0;
	level.zone_drone_counts[ "trig_ambient_west" ] = 0;
	level.zone_drone_counts[ "trig_ambient_north" ] = 0;
	
	start_nodes_west = [];
	start_nodes_east[0] = "south_east_corner";
	start_nodes_east[1] = "north_east_loop_start";	
	
	start_nodes_west = [];
	start_nodes_west[0] = "north_west_corner_start";	
	start_nodes_west[1] = "south_west_corner_start";
	
	start_nodes_north = [];
	start_nodes_north[0] = "ambient_north_track_1";
	start_nodes_north[1] = "ambient_north_track_2";

	level thread zone_trigger_watch( "trig_ambient_east" );
	level thread zone_spawn_planes( "trig_ambient_east", start_nodes_east );		
	
	level thread zone_trigger_watch( "trig_ambient_west" );
	level thread zone_spawn_planes( "trig_ambient_west", start_nodes_west );
	
	level thread zone_trigger_watch( "trig_ambient_north" );
	level thread zone_spawn_planes( "trig_ambient_north", start_nodes_north );	
}

zone_trigger_watch( zone_name )
{
	trigger = GetEnt( zone_name, "targetname" );
	
	while ( 1 )
	{
		trigger waittill( "trigger" );
		
		trig_origin = ( trigger.origin[0], trigger.origin[1], 0 );
		player_origin = ( level.player.origin[0], level.player.origin[1], 0 );
		player_forward = ( IsDefined( level.player.viewlockedentity ) ? AnglesToForward( level.player.viewlockedentity.angles ) : AnglesToForward( level.player.angles ) );
		
		dir = trig_origin - player_origin;
		dot = VectorDot( dir, player_forward );
		
//		if ( dot > 0.0 )
			trigger.triggered = true;
	}
}

#define MAX_ZONE_DRONE_COUNT 10
zone_spawn_planes( zone_name, start_nodes )
{
	level endon( "kill_ambient_drone_spawn_manager" );
	
	trigger = GetEnt( zone_name, "targetname" );
	
	n_spawn_count_axis = 5;	
	n_spawn_count_allies = 2;		
	current_track = 0;
	
	total = n_spawn_count_axis + n_spawn_count_allies;
	
	while ( 1 )
	{
		if ( IS_TRUE( trigger.triggered ) )
		{
			//iprintlnbold( zone_name );
			
			vehicle_count = GetVehicleArray().size;
			if ( vehicle_count > 50 )
			{
				deleted = level cleanup_ambient_drones( n_spawn_count_axis + n_spawn_count_allies, 50000 );
				if ( deleted < n_spawn_count_axis + n_spawn_count_allies )
				{
					trigger.triggered = false;						
					continue;
				}
			}
			
			if ( level.zone_drone_counts[ zone_name ] + total <= MAX_ZONE_DRONE_COUNT )
			{
				if ( level.aerial_vehicles.count + n_spawn_count_axis + n_spawn_count_allies > 50 )
				{
					deleted = level cleanup_ambient_drones( ( n_spawn_count_axis + n_spawn_count_allies ) * 4, 50000 );
					if ( deleted >= ( n_spawn_count_axis + n_spawn_count_allies ) )
					{
						n_spawned = level thread spawn_plane_group( zone_name, start_nodes[ current_track ], n_spawn_count_axis, "pegasus_ground_ambient_flyby_2", "f38_ground_ambient_flyby_2" );
						level waittill( start_nodes[ current_track ] );
						level.zone_drone_counts[ zone_name ] += ( n_spawn_count_axis + n_spawn_count_allies );
					}
					else
					{			
						trigger.triggered = false;									
						continue;
					}
				}
				else
				{
					n_spawned = level thread spawn_plane_group( zone_name, start_nodes[ current_track ], n_spawn_count_axis, "pegasus_ground_ambient_flyby_2", "f38_ground_ambient_flyby_2" );					
					level waittill( start_nodes[ current_track ] );
					level.zone_drone_counts[ zone_name ] += ( n_spawn_count_axis + n_spawn_count_allies );
				}
		
				current_track++;
				if ( current_track >= start_nodes.size )
					current_track = 0;
				
				wait( 2 );			
			}
		}

		trigger.triggered = false;		
		wait( 0.05 );
	}
}

cleanup_ambient_drones( desired_delete_count, delete_dist, min_dot = 0.5 )
{
	potential_deletes = [];
	
	player_forward = ( IsDefined( level.player.viewlockedentity ) ? AnglesToForward( level.player.viewlockedentity.angles ) : AnglesToForward( level.player.angles ) );
	
	for ( i = 0; i < level.aerial_vehicles.axis.size; i++ )
	{
		if ( IsDefined( level.aerial_vehicles.axis[i] ) && !IsDefined( level.aerial_vehicles.axis[i].is_convoy_plane ) )
		{
			dot = VectorDot( VectorNormalize( level.aerial_vehicles.axis[i].origin - level.player.origin ), player_forward );			
			if ( dot < -0.5 )
			{
				potential_deletes[ potential_deletes.size ] = level.aerial_vehicles.axis[i];				
			}
			else if ( min_dot < 0.5 )
			{
				dist = Distance2D( level.aerial_vehicles.axis[i].origin, level.player.origin );
				if ( dist > delete_dist )
				{
					potential_deletes[ potential_deletes.size ] = level.aerial_vehicles.axis[i];
				}
			}
		}
	}	
	
	for ( i = 0; i < level.aerial_vehicles.allies.size; i++ )
	{
		if ( IsDefined( level.aerial_vehicles.allies[i] ) && !IsDefined( level.aerial_vehicles.allies[i].is_convoy_plane ) )
		{
			dot = VectorDot( VectorNormalize( level.aerial_vehicles.allies[i].origin - level.player.origin ), player_forward );			
			if ( dot < -0.5 )
			{
				potential_deletes[ potential_deletes.size ] = level.aerial_vehicles.allies[i];				
			}
			else if ( min_dot < 0.5 )
			{
				dist = Distance2D( level.aerial_vehicles.allies[i].origin, level.player.origin );
				if ( dist > delete_dist )
				{
					potential_deletes[ potential_deletes.size ] = level.aerial_vehicles.allies[i];
				}
			}
		}
	}
	
	n_deletes = ( desired_delete_count < potential_deletes.size ? desired_delete_count : potential_deletes.size );
	for ( i = 0; i < n_deletes; i++ )
	{
		if ( IsDefined( potential_deletes[i] ) )
		{
			level.zone_drone_counts[ potential_deletes[i].zone_name ]--;
			potential_deletes[i] delete();
		}
	}
	
	return n_deletes;
}

get_best_spline_node( node_start )
{
	player_forward = ( IsDefined( level.player.viewlockedentity ) ? AnglesToForward( level.player.viewlockedentity.angles ) : AnglesToForward( level.player.angles ) );	
	
	current_node = GetVehicleNode( node_start, "targetname" );
	next_node = GetVehicleNode( current_node.target, "targetname" );
	
	closest_node = undefined;
	closest_dist = 999999;
	
	while ( next_node.target != node_start )
	{
		delta = current_node.origin - level.player.origin;
		dist = Length( delta );
		
		if ( dist < closest_dist )
		{
			dot = VectorDot( VectorNormalize( delta ), player_forward );
			if ( dot > 0 )
			{
				closest_node = current_node;
				closest_dist = dist;
			}
		}
		
		current_node = next_node;
		next_node = GetVehicleNode( current_node.target, "targetname" );
	}
	/#
	if ( IsDefined( closest_node ) )
	{
		Circle( closest_node.origin, 1024, ( 1, 1, 1 ), false, 1 );
	}
	#/
	return closest_node;
}


spawn_plane_group( zone_name, initial_path, n_count, str_spawner, str_allies_spawner, delay )
{	
	level endon( "kill_ambient_drone_spawn_manager" );	
	
	if ( IsDefined( delay ) )
	{
		wait( delay );
	}
	
	a_planes = [];
	
	level.vh_lead_plane = undefined;
	
	for ( i = 0; i < n_count; i++ )
	{		
		vh_plane = plane_spawn( str_spawner, ::plane_drive_highway, initial_path, level.vh_lead_plane, i - 1 );
		
		vh_plane.transfer_route = 1;
		vh_plane SetSpeedImmediate( 600, 300 );		
		vh_plane thread ambient_drone_die();
		vh_plane thread death_watcher();
		vh_plane.zone_name = zone_name;
		
		if( !IsDefined( level.vh_lead_plane ) )
		{
			level.vh_lead_plane = vh_plane;
		}
		
		a_planes[ a_planes.size ] = vh_plane;
		
		wait 0.25;
	}
	
	level.vh_lead_plane = undefined;	
	
	for ( i = 0; i < 2; i++ ) 
	{
		vh_plane = plane_spawn( str_allies_spawner, ::plane_drive_highway, initial_path, level.vh_lead_plane, i - 1 );
		vh_plane.transfer_route = 1;		
		vh_plane.drone_targets = a_planes;
		vh_plane SetSpeedImmediate( 600, 300 );	
		vh_plane thread ambient_air_allies_weapon_think();
		vh_plane thread death_watcher();		
		vh_plane.zone_name = zone_name;		
				
		if( !IsDefined( level.vh_lead_plane ) )
		{
			level.vh_lead_plane = vh_plane;
		}

		wait( 0.05 );
	}
	
	level notify( initial_path );
}

ambient_air_allies_weapon_think()
{
	wait( 2 );
	self thread ambient_allies_weapons_think( 10 );	
}

death_watcher()
{
	self waittill( "death" );
	if ( IsDefined( self.zone_name ) )
		level.zone_drone_counts[ self.zone_name ]--;	
}




