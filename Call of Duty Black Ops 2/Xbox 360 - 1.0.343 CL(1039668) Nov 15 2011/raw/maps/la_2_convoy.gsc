/* la_2_convoy.gsc - all friendly convoy movement housed here */

#include maps\_utility;
#include common_scripts\utility;
#include maps\_dialog;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	wait_for_first_player();
	flag_wait( "la_transition_setup_done" );
	
	convoy_setup();
	convoy_set_leader();

	level thread convoy_pathing_start();
	//level thread convoy_stop_point_setup();
	level thread convoy_regroup_check();
	level thread convoy_distance_check( 26000, 0.95 );
	level thread convoy_setup_misc();
}

// set up level variables for all possible vehicles in friendly convoy
convoy_setup()
{	
	level.convoy = SpawnStruct();
	level.convoy.vehicles = [];  // array of vehicles
	level.convoy.distance_warning_percentage = 0.75;
	level.convoy.distance_warning_percentage_default = level.convoy.distance_warning_percentage;
	
	// president's vehicle
	level.convoy.vh_potus = get_ent( "convoy_potus", "targetname", true );
	level.convoy.vehicles[ level.convoy.vehicles.size ] = level.convoy.vh_potus;
	level.convoy.vh_potus thread func_on_death( ::potus_death );
	level.convoy.vh_potus thread _init_cougar_turret( "bullet" );
	
	// CO and F35 pilot's vehicle 
	level.convoy.vh_van = get_ent( "convoy_van", "targetname", true );
//	level.convoy.vehicles[ level.convoy.vehicles.size ] = level.convoy.vh_van; 
	level.convoy.vh_van thread convoy_vehicle_think_van( "convoy_start_default" );  // van does its own thing separate from convoy
	level.convoy.vh_van thread harper_fires_from_van();
	level.convoy.vh_van.takedamage = false;
	level.convoy.vh_van thread convoy_add_glow_shader();
	
	// G20 vehicle 1
	level.convoy.vh_g20_1 = get_ent( "convoy_g20_1", "targetname", true );
	level.convoy.vehicles[ level.convoy.vehicles.size ] = level.convoy.vh_g20_1;
	level.convoy.vh_g20_1 thread func_on_death( ::g20_1_death );
	level.convoy.vh_g20_1 thread _init_cougar_turret( "bullet" );
		
	// if G20 vehicle 1 died, delete the vehicle
	if ( !flag( "G20_1_saved" ) )
	{
		level.convoy.vh_g20_1 Delete();
	}
	
	// G20 vehicle 2
	level.convoy.vh_g20_2 = get_ent( "convoy_g20_2", "targetname", true );
	level.convoy.vehicles[ level.convoy.vehicles.size ] = level.convoy.vh_g20_2;
	level.convoy.vh_g20_2 thread func_on_death( ::g20_2_death );
	// TEMP: _turret doesn't support vehicles as a targeting pool yet. when code function is in, remove this. TravisJ 6/29/2011
	level.convoy.vh_g20_2 thread _init_cougar_turret( "bullet" );

	// if G20 vehicle 2 died, delete the vehicle
	if ( !flag( "G20_2_saved" ) )
	{
		level.convoy.vh_g20_2 Delete();
	}	
	
	// if we deleted any vehicles, clean up
	level.convoy.vehicles = array_removeDead( level.convoy.vehicles );  
	
	// thread movement logic functions on all convoy vehicles
	for ( i = 0; i < level.convoy.vehicles.size; i++ )
	{
		level.convoy.vehicles[ i ] thread convoy_vehicle_think( "convoy_start_default" );
		level.convoy.vehicles[ i ] convoy_setup_fakehealth();
		level.convoy.vehicles[ i ] thread add_scripted_damage_state( 0.33, ::convoy_low_health_func );
		level.convoy.vehicles[ i ] thread convoy_add_glow_shader();
	}	
}

convoy_add_glow_shader()  // self = convoy vehicle
{
	self SetClientFlag( 14 );  // 15 = red glow shader, 14 = green glow shader
	
	self waittill( "death" );
	
	self ClearClientFlag( 14 );
}

convoy_setup_misc()
{
	a_temp = level.convoy.vehicles;
	a_temp[ a_temp.size ] = level.convoy.vh_van;
	
	for ( i = 0; i < a_temp.size; i++ )
	{
		a_temp[ i ] thread func_on_notify( "rooftops_slow_down", ::set_vehicle_speed, 25 );
		a_temp[ i ] thread func_on_notify( "rooftops_speed_up", ::set_vehicle_speed, 35 );
		a_temp[ i ] thread func_on_notify( "trenchruns_slow_down", ::set_vehicle_speed, 30 );
	}
}

set_vehicle_speed( n_speed )
{
	self SetSpeed( n_speed );
}

harper_fires_from_van()  // self = van
{
	self endon( "_convoy_vehicle_think_stop" );
	
	flag_wait( "player_flying" );
	
	// spawn in harper
	ai_harper = get_ent( "harper_ai", "targetname" );
	if ( !IsDefined( ai_harper ) )
	{
		ai_harper = simple_spawn_single( "harper" );
	}
	
	ai_harper.animname = "harper";
	
	// put harper in the van
	b_has_unloaded = false;
	while ( IsDefined( ai_harper.ridingvehicle ) )
	{
		if ( !b_has_unloaded )
		{
			vh_temp = ai_harper.ridingvehicle;
			vh_temp vehicle_unload();
			b_has_unloaded = true;
		}
		
		wait 0.1;
	}
	ai_harper enter_vehicle( self );
	////ai_harper LinkTo( self, "tag_driver" );
		
	// override harper's .vehicle_idle_override to play 'firing' anim
	ai_harper.vehicle_idle_override = %generic_human::ch_la_09_01_harpershooting_harper;
	//self thread maps\_anim::anim_loop_aligned( ai_harper, "harper_fires_out_window", "tag_driver", "harper_stops_firing" );
		
	// make harper actually fire
	ai_harper thread _harper_fires_at_targets();
}

_harper_fires_at_targets()
{
	// notetrack is "fire"
}

// set up burst parameters and targeting pool then enable AI turret on cougar
_init_cougar_turret( str_type )  // self = cougar vehicle with turret
{
	self endon( "death" );
	
	Assert( IsDefined( str_type ), "str_type is a required parameter for _init_cougar_turret" );
	
	a_target_types = [];
	
	if ( str_type == "bullet" )
	{
		n_index = 1;
		a_target_types[ a_target_types.size ] = "ai";
		
		n_fire_min = 3;
		n_fire_max = 6;
		n_wait_min = 2;
		n_wait_max = 3;
	}
	else if ( str_type == "sam" )
	{
		n_index = 2;
		a_target_types[ a_target_types.size ] = "vehicles";
		
		n_fire_min = 2;
		n_fire_max = 3;
		n_wait_min = 5;
		n_wait_max = 8;		
	}
	else
	{
		AssertMsg( str_type + " is not a supported type of weapon for _init_cougar_turret" );
	}
	
	self.turret_index_used = n_index;
	self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index );
	self maps\_turret::set_turret_target_types_array( a_target_types, n_index );
	self thread maps\_turret::enable_turret( n_index );
	
	flag_wait( "convoy_at_rooftops" );
	//self maps\_turret::disable_turret( n_index );
}

_shoot_at_drones()
{
	e_target = undefined;
	b_has_target = false;
	
	while ( !b_has_target )
	{
		a_drones = level.aerial_vehicles.axis;
		
		if ( IsDefined( a_drones ) && ( a_drones.size > 0 ) )
		{
			e_target = random( a_drones );
			
			if ( maps\la_2_player_f35::_can_bullet_hit_target( self.origin, e_target ) )
			{
				b_has_target = true;
			}
		}
		
		wait 0.1;
	}
	
	return e_target;
}

convoy_setup_fakehealth()
{
	// TODO: base on difficulty
	self.armor_max = 1500;
	
	if ( self == level.convoy.vh_potus )
	{
		self.armor_max *= 2;  // president's cougar has double health
	}
	
	self.armor = self.armor_max;
	
	self.friendlyfire_shield = false;  // friendlyfire_shield needs to be off for damage callback to work		
	self.overrideVehicleDamage = ::convoy_vehicle_damage;	
}


convoy_low_health_func()
{
	PlayFXOnTag( level._effect[ "cougar_damage_smoke" ], self, "tag_origin" );
	
	if ( self == level.convoy.vh_potus )
	{
		level notify( "POTUS_health_low" );
	}
}

// 
convoy_vehicle_think( node_or_string )  // self = convoy vehicle
{
	Assert( IsDefined( node_or_string ), "node_or_string is a required parameter for convoy_vehicle_think!" );
		
	self notify( "_convoy_vehicle_think_stop" );
	self endon( "_convoy_vehicle_think_stop" );
	self endon( "death" );
	
	// set movement flags
	if ( !IsDefined( self.ent_flag[ "is_moving" ] ) )
	{
		self ent_flag_init( "is_moving" );
	}
	
	// set vehicle avoidance
	self SetVehicleAvoidance( false );
 	
	
	//nd_path = GetVehicleNode( node_or_string, "script_noteworthy" );
	if ( IsString( node_or_string ) )
	{
		nd_path = convoy_get_path_node( node_or_string );
	}
	else 
	{
		nd_path = node_or_string;
	}
	n_acceleration = 15;	
	
	flag_wait( "convoy_movement_started" );
	self thread go_path( nd_path );	
	self ent_flag_set( "is_moving" );
	
	while ( true )
	{
		self waittill( "convoy_stop" );
		println( self.targetname + " is stopping\n" );	
		n_speed = self GetSpeedMPH();
		self SetSpeed( 0 );
		
		self ent_flag_clear( "is_moving" );
		
		flag_wait_all( "convoy_can_move", "player_in_range_of_convoy", "convoy_in_position" );
		
		self thread set_avoidance_for_time();
		println( self.targetname + " is moving\n" );
		//self ResumeSpeed( n_acceleration );
		
		if ( n_speed < 0 )
		{
			n_speed = 0;
		}
		
		self SetSpeed( n_speed );
		self ent_flag_set( "is_moving" );
	}
}


convoy_get_count_moving()
{
	a_temp = level.convoy.vehicles;
	
	n_moving = 0;
	n_speed_threshold = 2;
	
	for ( i = 0; i < a_temp.size; i++ )
	{
		n_speed = a_temp[ i ] GetSpeedMPH();
		
		if ( n_speed > n_speed_threshold )
		{
			a_temp[ i ] ent_flag_set( "is_moving" );
		}
		
		if ( a_temp[ i ] ent_flag( "is_moving" ) )
		{
			n_moving++;
		}
	}
	
	return n_moving;
}

convoy_get_count_stopped()
{
	a_temp = level.convoy.vehicles;
	
	n_stopped = 0;
	n_speed_threshold = 2;
	
	for ( i = 0; i < a_temp.size; i++ )
	{
		if ( is_alive( a_temp[ i ] ) )
		{
			n_speed = a_temp[ i ] GetSpeedMPH();
			
			if ( n_speed < n_speed_threshold )
			{
				a_temp[ i ] ent_flag_clear( "is_moving" );
			}	
			
			if ( !( a_temp[ i ] ent_flag( "is_moving" ) ) )
			{
				n_stopped++;
			}
		}
	}
	
	return n_stopped;
}

// gets vehicle node convoy vehicle should be using to and returns it
convoy_get_path_node( node_or_string )  // self = convoy vehicle
{
	Assert( IsDefined( node_or_string ), "node_or_string is a required parameter for convoy_get_path_node!" );
	Assert( IsDefined( self.script_int ), "script int missing on convoy vehicle " + self.targetname );
	
	a_nodes = GetVehicleNodeArray( node_or_string, "script_noteworthy" );
	Assert( ( a_nodes.size > 0 ), "convoy_get_path_node found no vehicle nodes with script noteworthy " + node_or_string );
	
	
	n_my_int = self.script_int;
	b_found_node = false;
	nd_path = undefined;
	
	for ( i = 0; i < a_nodes.size; i++ )
	{
		if ( a_nodes[ i ].script_int == n_my_int )
		{
			b_found_node = true;
			nd_path = a_nodes[ i ];
		}
	}
	
	Assert( b_found_node, "convoy_get_path_node found no nodes with script_int of " + n_my_int );
	
	return nd_path;
}

convoy_vehicle_think_van( node_or_string )  // self = convoy vehicle
{	
	Assert( IsDefined( node_or_string ), "node_or_string is a required parameter for convoy_vehicle_think_van!" );	

	self notify( "_convoy_vehicle_think_stop" );
	self endon( "_convoy_vehicle_think_stop" );
	self endon( "death" );
	
	// set movement flags
	if ( !IsDefined( self.ent_flag[ "is_moving" ] ) )
	{
		self ent_flag_init( "is_moving" );
		
		// first run only
		self thread _van_watch_for_notify( "break_formation", ::van_roadblock_behavior, "harper_roadblock_attach_path" );
		self thread func_on_notify( "pacing_wait_for_convoy", ::stop_and_wait_for_flag, "convoy_at_roadblock", 30 );
		self thread func_on_notify( "dogfights_wait_for_convoy", ::stop_and_wait_for_flag, "dogfight_done", 30 );		
	}

	if ( !IsDefined( self.ent_flag[ "ignore_convoy_path" ] ) )
	{
		self ent_flag_init( "ignore_convoy_path" );
	}
	
	// set vehicle avoidance
	self SetVehicleAvoidance( true );  // TODO: set this when convoy vehicle dies	
	
	if ( IsString( node_or_string ) )
	{
		nd_path = convoy_get_path_node( node_or_string );
	}
	else 
	{
		nd_path = node_or_string;
	}
	
	n_acceleration = 15;	
	
	flag_wait( "player_flying" );
	t_debris_trigger = get_ent( "player_inside_debris_cloud_trigger", "targetname", true );
	while ( level.player IsTouching( t_debris_trigger ) )
	{
		wait 0.1;
	}
	
	self.drivepath = 1;
	self thread go_path( nd_path );	
	self ent_flag_set( "is_moving" );
	
	while ( true )
	{
		self ent_flag_wait( "ignore_convoy_path" );		
		
		self waittill( "convoy_stop" );
		println( self.targetname + " is stopping\n" );	
		self SetSpeed( 0 );
		
		self ent_flag_clear( "is_moving" );
		
		flag_wait_all( "convoy_can_move", "player_in_range_of_convoy", "convoy_in_position" );
		
	//	self thread set_avoidance_for_time();
		println( self.targetname + " is moving\n" );
		//self ResumeSpeed( n_acceleration );
		self SetSpeed( 30 );
		self ent_flag_set( "is_moving" );
	}
}

stop_and_wait_for_flag( str_flag, n_speed_resume )
{
	n_speed = 30;
	
	self SetSpeed( 0 );
	
	flag_wait( str_flag );
		
	self SetSpeed( n_speed );
}

// function that sets up van behavior
_van_watch_for_notify( str_notify, func_on_notify, str_rejoin_convoy_vehicle_node )  // self = van
{
	Assert( IsDefined( str_notify ), "str_notify is a required parameter for _van_watch_for_notify" );
	Assert( IsDefined( func_on_notify ), "func_on_notify is a required parameter for _van_watch_for_notify" );
	Assert( IsDefined( str_rejoin_convoy_vehicle_node ), "str_rejoin_convoy_vehicle_node is a required parameter for _van_watch_for_notify" );
		
	nd_rejoin_convoy = GetVehicleNode( str_rejoin_convoy_vehicle_node, "targetname" );
	Assert( IsDefined( nd_rejoin_convoy ), "nd_rejoin_convoy is missing for van_roadblock_behavior" );		
	
	self waittill( str_notify );
	
	self ent_flag_set( "ignore_convoy_path" );
	
	self [[ func_on_notify ]]();
	
	self ent_flag_clear( "ignore_convoy_path" );
	
	self SetVehGoalPos( nd_rejoin_convoy.origin );
	self waittill_either( "goal", "near_goal" );
	
	self thread go_path( nd_rejoin_convoy );
}

van_roadblock_behavior()
{
	//iprintlnbold( "van_roadblock_behavior starting..." );
	
	a_structs = get_struct_array( "roadblock_van_drive_points", "targetname", true );
	n_near_goal_dist = 256;
	n_wait_time_min = 2;
	n_wait_time_max = 4;
	n_wait_time_default = 0.5;
	
	self SetNearGoalNotifyDist( n_near_goal_dist );
	
	s_drive_point_last = undefined;
	while ( !flag( "ground_targets_done" ) )
	{		
		s_drive_point = random( a_structs );
		v_drive_point = s_drive_point.origin;
		
		b_can_path = BulletTracePassed( self.origin, v_drive_point, true, self );
		n_wait_time = n_wait_time_default;
		
		if ( !IsDefined( s_drive_point_last ) )
		{
			s_drive_point_last = s_drive_point;	
		}
		
		if ( IsDefined( s_drive_point_last ) && ( s_drive_point == s_drive_point_last ) )
		{
			b_can_path = false;
		}
		
		if ( b_can_path )
		{
			//iprintlnbold( "van is driving to " + v_drive_point );
			self SetVehGoalPos( v_drive_point );
		
			self waittill_either( "near_goal", "goal" );
		
			n_wait_time = RandomFloatRange( n_wait_time_min, n_wait_time_max );
			s_drive_point_last = s_drive_point;
		}
		
		wait n_wait_time;
	}
	
	//iprintlnbold( "van_roadblock_behavior done" );	
}


set_avoidance_for_time()
{
	self endon( "death" );
	
	b_old_avoidance = IS_TRUE( self GetVehicleAvoidance() );
	
	self SetVehicleAvoidance( true );	
	
	wait 10;
	
	self SetVehicleAvoidance( b_old_avoidance );	
}

g20_1_death()
{
	if ( flag( "G20_1_saved" ) )
	{
		level.convoy.vehicles = array_remove( level.convoy.vehicles, self );
		flag_set( "G20_1_dead" );
		convoy_set_leader();
    }
}

g20_2_death()
{
	if ( flag( "G20_2_saved" ) )
	{
		level.convoy.vehicles = array_remove( level.convoy.vehicles, self );
		flag_set( "G20_2_dead" );
		convoy_set_leader();	
	}
}

potus_death()
{
	if ( flag( "trenchruns_start" ) && !flag( "eject_sequence_started" ) )
	{
	    // play president's vehicle getting hit by drone sound
	}
	
	wait 1;
	
	SetDvar( "ui_deadquote", &"LA_2_OBJ_PROTECT_FAIL" );
	MissionFailed();	
}

// monitors stopping convoy as a group and notifies script when they arrive
convoy_stop_point_setup()
{	

	
	
	

	level thread convoy_regroup_check();
}

convoy_regroup_check()
{
	while ( true )
	{
		flag_wait( "convoy_can_move" );
		
		n_vehicles = level.convoy.vehicles.size;
		n_vehicles_stopped = convoy_get_count_stopped();
		
		if ( n_vehicles == n_vehicles_stopped )
		{
			flag_set( "convoy_in_position" );
		}
		else 
		{
			flag_clear( "convoy_in_position" );
		}
		
		wait 1;
	}
}


convoy_register_stop_point( str_trigger_name, str_wait_flag, func_on_trigger, param_1 )
{
	Assert( IsDefined( str_trigger_name ), "str_trigger_name is a required parameter for convoy_register_stop_point" );
	Assert( IsDefined( str_wait_flag ), "str_wait_flag is a required parameter for convoy_register_stop_point" );
	
	t_stop = get_ent( str_trigger_name, "targetname", true );
	
	t_stop _waittill_triggered_by_convoy();
	
	flag_clear( "convoy_can_move" );
	
	println( str_trigger_name + " hit\n" );
	if ( IsDefined( func_on_trigger ) )
	{
		self [[ func_on_trigger ]]( param_1 );
	}
	
	flag_wait( str_wait_flag );
	println( str_wait_flag + " = 1\n" );
	
	flag_set( "convoy_can_move" );
	
	if ( IsDefined( t_stop ) )
	{
		t_stop Delete();
	}
}

_waittill_triggered_by_convoy()  // self = trigger
{
	b_is_convoy_vehicle = false;
	
	while ( !b_is_convoy_vehicle )
	{
		self waittill( "trigger", e_triggered );
		
		for ( i = 0; i < level.convoy.vehicles.size; i++ )
		{
			if ( e_triggered == level.convoy.vehicles[ i ] )
			{
				b_is_convoy_vehicle = true;
			}
		}
	}	
}

// set convoy leader. this is the vehicle that enemies will focus fire on
convoy_set_leader()
{
	level.convoy.vehicles = array_removeDead( level.convoy.vehicles );
	
	// temporarily make all vehicles invulnerable until leader is set. note: only leader takes damage
	for ( i = 0; i < level.convoy.vehicles.size; i++ )
	{
		level.convoy.vehicles[ i ].takedamage = false; 
	}
	
	// convoy order: G20_1 -> G20_2 -> POTUS -> van (never targeted)
	if ( flag( "G20_1_saved" ) && !flag( "G20_1_dead" ) )
	{
		level.convoy.leader = level.convoy.vh_g20_1;
	}
	else if ( flag( "G20_2_saved" ) && !flag( "G20_2_dead" ) )
	{
		level.convoy.leader = level.convoy.vh_g20_2;
	}
	else 
	{
		level.convoy.leader = level.convoy.vh_potus;
	}
	
	level.convoy.leader.takedamage = true;
	level.convoy.leader thread maps\la_2_anim::vo_convoy_damage_nag();
}

convoy_get_leader()
{
	n_counter = 0;
	n_counter_threshold = 10;
	n_wait = 0.05;
	
	b_found_leader = false;
	
	while ( !b_found_leader && ( n_counter < n_counter_threshold ) )
	{
		if ( IsDefined( level.convoy.leader ) )
		{
			b_found_leader = true;
			vh_leader = level.convoy.leader;
		}
		
		n_counter++;
	}
	
	return vh_leader;
}


convoy_pathing_start()
{		
	flag_wait( "player_flying" );
	
	n_threshold = 16000;  // TODO: test
	
	while ( Distance2D( level.convoy.leader.origin, level.f35.origin ) > n_threshold )
	{
		wait 0.1;
	}
	
	flag_set( "convoy_movement_started" );
}

convoy_distance_check( n_distance, n_distance_warning_percentage )
{
	Assert( IsDefined( n_distance ), "n_distance is a required parameter for convoy_distance_check" );
	
	flag_wait( "convoy_movement_started" );
	
	level thread maps\la_2_anim::vo_convoy_distance_check_nag();
	
	if ( IsDefined( n_distance_warning_percentage ) )
	{
		level.convoy.distance_warning_percentage = n_distance_warning_percentage;
	}
	
	level.convoy.distance_max = n_distance;
	n_counter = 0;
	n_counter_max = 6;
	
	while( !flag( "eject_sequence_started" ) )
	{
		n_distance_max = level.convoy.distance_max; // this can be updated with convoy_distance_check_update
		level.convoy.distance_warning = n_distance_max * level.convoy.distance_warning_percentage;
		n_distance_warning = level.convoy.distance_warning;
		
		level.convoy.distance_to_convoy = Distance2D( level.f35.origin, level.convoy.vh_potus.origin );
		n_distance = level.convoy.distance_to_convoy;
		//iprintln( "Distance = " + n_distance );
/*		
		if ( n_distance > n_distance_max )
		{
			flag_set( "player_too_far_from_convoy" );
			n_counter++;
			
			if ( n_counter > n_counter_max )
			{
				level.convoy.vh_potus notify( "death" );
			}
		}
		else 
		{
			flag_clear( "player_too_far_from_convoy" );
			n_counter = 0;
		}
		*/
		
		// warn the player if he's too far from convoy, but don't fail him right away
		if ( n_distance > n_distance_warning )
		{
			flag_clear( "player_in_range_of_convoy" );
		}
		else 
		{
			flag_set( "player_in_range_of_convoy" );
			//flag_set( "convoy_can_move" );
		}
		
		// fail the player if he goes beyond the max distance threshold
		if ( n_distance > n_distance_max )
		{
			if ( !flag( "no_fail_from_distance" ) && ( !IsGodMode( level.player ) ) )
			{
				level.convoy.vh_potus notify( "death" );
			}
		}
		
		wait 1;
	}
}



convoy_distance_check_update( n_distance, n_warning_distance_percentage )
{
	Assert( IsDefined( level.convoy.distance_max ), "convoy_distance_check_update ran before convoy_distance_check" );
	
	level.convoy.distance_max = n_distance;
	level.convoy.distance_warning_percentage = level.convoy.distance_warning_percentage_default;  // reset warning distance percentage when updating
	
	if ( IsDefined( n_warning_distance_percentage ) )
	{
		level.convoy.distance_warning_percentage = n_warning_distance_percentage;
	}
}

convoy_vehicle_damage(eInflictor, eAttacker, iDamage, iDFlags, type, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime, damageFromUnderneath, modelIndex, partName)
{
	if ( IsPlayer( eAttacker ) )
	{		
		iDamage = 10;
		
		if ( IsSubStr( sWeapon, "missile_turret" ) )
		{
			iDamage = 200;
		}
	}
	else if ( IsAI( eAttacker ) )
	{
		str_team = eAttacker.team;
		
		if ( str_team == "allies" )  // don't take damage from friendly AI
		{
			return 0;
		}
		else if ( str_team == "axis" )
		{
			iDamage = 1;
			
			if ( IsSubstr( sWeapon, "rpg" ) )
			{
				iDamage = 150;
			}
		}
	}
	else if ( IS_VEHICLE( eAttacker ) )  // don't take damage from other cougars
	{
		if ( IsSubStr( eAttacker.vehicletype, "cougar" ) || eAttacker == level.convoy.vh_van )
		{
			iDamage = 0;
		}
		else 
		{
			iDamage = 10;
		}
	}
	
	self.armor -= iDamage;
	
	// handle death
	if ( ( self.armor - iDamage ) <= 0 )
	{
		if ( !IsGodMode( level.player ) )
		{
			self notify( "death" );
		}
	}
	
	iDamage = 1;
	
	return iDamage;
}
