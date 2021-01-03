#using scripts\codescripts\struct;

#using scripts\cp\_dialog;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_sgen;
#using scripts\cp\cp_mi_sing_sgen_util;
#using scripts\cp\cp_mi_sing_sgen_pallas;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

                                                                                                            	   	
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "triggerstring", "CP_MI_SING_SGEN_FLOOD_USE_DOOR" );

function skipto_flood_init( str_objective, b_starting )
{
	init_flags();
	
	spawn_manager::set_global_active_count( 30 ); // Set max AI - edge case when overdrive sprinting with more than 2 players
	
	spawner::add_spawn_function_group( "flood_combat_runners", "script_noteworthy", &fallback_spawnfunc );
	
	// Activate Flood Combat entities
	array::run_all( GetEntArray( "flood_combat_trigger", "script_noteworthy" ), &TriggerEnable, true );

	// Entities that still need to be disabled until later in this event
	array::run_all( GetEntArray( "floor_door_hint_trigger", "targetname" ), &TriggerEnable, false );

	if ( b_starting )
	{
		sgen::init_hendricks( str_objective );
		cp_mi_sing_sgen_pallas::elevator_setup();
		GetEnt( "pallas_lift_front", "targetname" ) util::self_delete();

		sgen::wait_for_all_players_to_spawn();

		array::run_all( GetAITeamArray( "axis" ), &Delete ); // TEMP: TODO - Bunch of AI spawn outside SGEN

		if ( ( level.skipto_point === "dev_flood_combat" ) )
		{
			level.players[ 0 ] SetOrigin( ( 1152, -3864, -4876 ) );
			level.players[ 0 ] SetPlayerAngles( ( 0, 0, 0 ) );
		}		
	}

	level clientfield::set( "w_underwater_state", 1 );
	SetDvar( "phys_buoyancy", 1 );
	spawner::add_spawn_function_group( "flood_reinforcement_robot", "script_noteworthy", &reinforcement_robot_setup );
	level.ai_hendricks ai::set_behavior_attribute( "can_melee", false );
	level.ai_hendricks ai::set_behavior_attribute( "can_be_meleed", false );
	
	set_pipes_states_combat();
	set_doors_states_combat();
	
	a_s_spawn_point = struct::get_array( "charging_station_spawn_point" );
	array::thread_all( a_s_spawn_point, &util::delay_notify, 5, "post_pallas" );

	array::thread_all( GetEntArray( "water_spout_trigger", "targetname" ), &water_spout_push );

	array::thread_all( GetEntArray( "stumble_trigger", "targetname" ), &sgen_util::stumble_trigger_think );
	
	main();
	
	skipto::objective_completed( "flood_combat" );
}

function skipto_flood_done( str_objective, b_starting, b_direct, player )
{
}

function skipto_flood_defend_init( str_objective, b_starting )
{
	// Init flags
	// "script_flag_true"/"flood_defend_flood_hallway_kill_zone_enabled"
	
	if ( b_starting )
	{
		level flag::init( "hendricks_defend_started" );
		level flag::init( "flood_defend_hendricks_at_door" );
	
		// Activate Flood Combat entities
		array::run_all( GetEntArray( "flood_combat_trigger", "script_noteworthy" ), &TriggerEnable, true );
	
		// Entities that still need to be disabled until later in this event
		array::run_all( GetEntArray( "floor_door_hint_trigger", "targetname" ), &TriggerEnable, false );
		sgen::init_hendricks( str_objective );
		cp_mi_sing_sgen_pallas::elevator_setup();
		GetEnt( "pallas_lift_front", "targetname" ) util::self_delete();
		level flag::set( "pallas_lift_front_open" );

		sgen::wait_for_all_players_to_spawn();

		array::run_all( GetAITeamArray( "axis" ), &Delete ); // TEMP: TODO - Bunch of AI spawn outside SGEN - TODO: why are AI spawning outside the map?

		if ( ( level.skipto_point === "dev_flood_combat" ) )
		{
			level.players[ 0 ] SetOrigin( ( 1152, -3864, -4876 ) );
			level.players[ 0 ] SetPlayerAngles( ( 0, 0, 0 ) );
		}
		
		level clientfield::set( "w_underwater_state", 1 );
		SetDvar( "phys_buoyancy", 1 );
		spawner::add_spawn_function_group( "flood_reinforcement_robot", "script_noteworthy", &reinforcement_robot_setup );
		level.ai_hendricks ai::set_behavior_attribute( "can_melee", false );
		level.ai_hendricks ai::set_behavior_attribute( "can_be_meleed", false );
	
		set_doors_states_defend();
	
		array::thread_all( GetEntArray( "water_spout_trigger", "targetname" ), &water_spout_push );
	
	//	array::thread_all( GetEntArray( "stumble_trigger", "targetname" ), &sgen_util::stumble_trigger_think ); // TODO: Causes SRE - do even need this here?
		level thread defend_room_set_state_flooded();
		level thread handle_earthquakes();
		
		objectives::set( "cp_level_sgen_breadcrumb", struct::get( "flood_combat_breadcrumb_end" ) );
		
		level thread hendricks_defend_movement();
		
		t_boundary = GetEnt( "flood_defend_out_of_boundary_trig", "targetname" );
		t_boundary SetVisibleToAll();
	}

	spawner::add_spawn_function_group( "flood_defend_catwalk_spawn_zone_robot", "targetname", &catwalk_spawn_zone_spawnfunc );
		
	defend_main( b_starting );
	
	spawn_manager::set_global_active_count( 32 ); // Resetting to default
	
	skipto::objective_completed( "flood_defend" );
}

// Self is AI
function catwalk_spawn_zone_spawnfunc()
{
	const N_MIN = 15;
	const N_SCALE = 11;
	
	n_level = 2;
	n_chance = sgen_util::get_num_scaled_by_player_count( N_MIN, N_SCALE );
		
	if( n_chance > RandomIntRange( 0, 100 ) )
	{
		n_level = 3;
	}
	
	self.goalradius = 256; // Respects spawner target node and goalradius when ignoring all
	self ai::set_behavior_attribute( "rogue_control", "forced_level_" + n_level );
}

function skipto_flood_defend_done( str_objective, b_starting, b_direct, player )
{
	a_ai = GetAITeamArray( "axis", "team3" );

	foreach( ai in a_ai )
	{
		// Move Human AI To Underwater Area To Drown Seamlessly
		if ( !(isdefined(ai.archetype) && ( ai.archetype == "robot" )) )
		{
			ai.ignoreall = true;
			ai sgen_util::teleport_to_underwater();
		}
		else
		{
			// Delete Robots
			ai util::self_delete();
		}
	}

	if ( IsDefined( level.ai_hendricks ) )
	{
		level.ai_hendricks ai::set_behavior_attribute( "can_melee", true );
		level.ai_hendricks ai::set_behavior_attribute( "can_be_meleed", true );
	}
}

function init_flags()
{
	// Init flags
	// "script_flag_set"/"flood_defend_reached"
	// "script_flag_set"/"flood_combat_surgical_room_door_close"
	// "script_flag_set"/"flood_defend_start_flood_fallback"
	// "script_flag_set"/"flood_combat_start_flooding"
	// "script_flag_set"/"flood_combat_door_crush_robot_start"
	// "script_flag_true"/"defend_time_expired"
	// "script_flag_true"/"flood_defend_enemies_spawning"
	// "script_flag_set_on_cleared"/"flood_defend_catwalk_spawn_zone_unoccupied"
	
	level flag::init( "hendricks_defend_started" );
	level flag::init( "flood_combat_nag_playing" );
	level flag::init( "flood_defend_hendricks_at_door" );
}

function main()
{
	level flag::wait_till( "all_players_spawned" );
	
	objective_trigger = GetEnt( "surgical_room_entrance_close", "targetname" );
	
	level thread sgen_util::set_door_state( "surgical_catwalk_door", "open" );

	level thread alarm_sounds();
	level thread combat_vo();
	level thread handle_breadcrumbs();
	level thread handle_earthquakes();
	level thread handle_fallback();
	level thread handle_fallback_runners_cleanup();
	level thread hendricks_movement();
	
	level scene::play( "cin_sgen_20_02_twinrevenge_1st_elevator" );
	level flag::set( "pallas_lift_front_open" );
	
	objectives::set( "cp_level_sgen_escape_sgen" );
	
	a_ai_runners = [];
	a_sp_intro_runners = GetSpawnerArray( "flood_combat_elevator_runners", "targetname" );
	
	foreach( n_count, sp_runner in a_sp_intro_runners )
	{
		a_ai_runners[ n_count ] = spawner::simple_spawn_single( sp_runner );
	}
	
	trigger::wait_till( "surprised_54i_trigger" );
		
	level thread play_rejoin_scene();
	level thread play_robot_door_scene();
	level thread clean_up_charging_zone();
	
	level flag::wait_till( "flood_combat_surgical_room_door_close" );
	
	spawn_manager::enable( "flood_combat_defend_room_fallback_spawns" );
	
	level thread play_surgical_room_door_scene();
	level thread break_surgical_room_windows();
	level thread defend_room_set_state_risk_of_flooding();

	level thread defend_room_set_state_flooding();
	
	level flag::wait_till_timeout( 10, "flood_defend_zone_started" );
	
	level notify( "cancel_hendricks_safe_zone" );
	
	spawn_manager::kill( "flood_combat_defend_room_fallback_spawns", true );
	spawn_manager::enable( "flood_combat_defend_room_fallback2_spawns" );
	
	level flag::wait_till_timeout( 30, "flood_defend_reached" );
	level flag::set( "flood_defend_reached" );
}

function clean_up_charging_zone()
{
	level flag::wait_till( "flood_combat_charging_zone_cleared" ); // Set when trigger cleared
	
	t_charging_zone = GetEnt( "flood_combat_charging_zone_trig", "targetname" );
	t_boundary = GetEnt( "flood_defend_out_of_boundary_trig", "targetname" );
	
	t_boundary SetVisibleToAll();
	
	sgen_util::set_door_state( "flood_robot_room_door_open", "close" );
	
	spawn_manager::kill( "flood_combat_charging_room_spawnmanager", true );
	spawn_manager::kill( "flood_combat_robot_room_spawnmanager", true );
	
	{wait(.05);};
	
	a_ai_54i = GetAITeamArray( "axis" );
	
	foreach( ai_54i in a_ai_54i )
	{
		if( IsAlive( ai_54i ) && ai_54i IsTouching( t_charging_zone ) )
		{
			ai_54i Kill();
		}
	}
	
	charging_station_cleanup();
}

function defend_main( b_starting )
{
	level flag::wait_till( "all_players_spawned" );
	
	level flag::set( "flood_combat_charging_zone_cleared" ); // Set flag for out of bounds and cleanup in case a player idles at elevator
	
	spawn_manager::kill( "flood_combat_defend_room_fallback2_spawns", true );
	
//	ai_door util::delay( 4, "death", &util::self_delete ); // TODO: this guy will need to be animated. The scene can clean him up.
	
	level thread defend_vo();
	level thread handle_defend_breadcrumbs();
	
	defend_logic( b_starting );
}

function hendricks_movement()
{
	level.ai_hendricks colors::disable();
	level.ai_hendricks.goalradius = 16;
	
	level flag::wait_till( "all_players_spawned" );
	level flag::wait_till( "pallas_lift_front_open" );
	
	level scene::play( "cin_sgen_21_01_releasetorrent_vign_pushdown_hendricks", level.ai_hendricks );
	
	level.ai_hendricks SetGoal( GetNode( "flood_combat_hendricks_intro_node", "targetname" ) );
	
	level.ai_hendricks colors::enable();

	trigger::wait_till( "flood_combat_windows_start", undefined );
	
	level.ai_hendricks colors::disable();
	
	level.ai_hendricks SetGoal( GetNode( "flood_combat_hendricks_catwalk_node", "targetname" ) );
	
	zone_wait_till_player( "flood_combat_catwalk_front_zone_trig", undefined, .75 );
	
	level.ai_hendricks zone_wait_till_safe( "flood_combat_catwalk_front_zone_trig", undefined, undefined, .74, "cancel_hendricks_safe_zone" );
	
	level thread weaken_catwalk_close_enemies();
	
	scene::add_scene_func( "cin_sgen_21_02_floodcombat_vign_traverse_hendricks", &kill_fallback_spawnmanager, "play" );
	level scene::play( "cin_sgen_21_02_floodcombat_vign_traverse_hendricks" );
	
	play_hendricks_defend_scene();
	
	nd_goal = GetNode( "flood_defend_hendricks_ready_node", "targetname" );
	
	level.ai_hendricks SetGoal( nd_goal );
}

function weaken_catwalk_close_enemies()
{
	a_ai_catwalk_close = GetAITeamArray( "axis" );
	t_zone = GetEnt( "flood_combat_catwalk_front_zone_trig", "targetname" );
	
	foreach( ai_catwalk in a_ai_catwalk_close )
	{
		if( IsAlive( ai_catwalk ) && ai_catwalk IsTouching( t_zone ) )
		{
			ai_catwalk.health = 1; 
		}
	}
}

function zone_wait_till_player( str_key, str_val = "targetname", n_delay = 0 )
{
	level endon( "flood_defend" ); // Flag set by skipto system
	
	t_zone = GetEnt( str_key, str_val );
	
	t_zone endon( "death" );
	
	do
	{
		t_zone waittill( "trigger", e_triggerer );
		
		if( IsPlayer( e_triggerer ) )
		{
			break;
		}
	}
	while( true );
	
	wait n_delay;
}

// Self is AI
function zone_wait_till_safe( str_key, str_val = "targetname", str_species = "robot", n_delay = 0, str_ender )
{
	self endon( "death" );
	level endon( "flood_defend" ); // Flag set by skipto system
	if( isdefined( str_ender ) )
	{
		level endon( str_ender );	
	}
	
	const N_CHECK_TIME = 1.5;
	
	t_safe = GetEnt( str_key, str_val );
	
	t_safe endon( "death" );
	
	do
	{
		t_safe waittill( "trigger" );
		
		n_touchers = 0;
		a_ai_enemies = GetAISpeciesArray( "axis", str_species );
			
		foreach( ai_enemy in a_ai_enemies )
		{
			if( IsAlive( ai_enemy ) && ai_enemy IsTouching( self ) )
			{
				n_touchers++;
			}
		}
		
		wait N_CHECK_TIME;
	}
	while( n_touchers > 0 );
	
	wait n_delay;
}

function kill_fallback_spawnmanager( a_ents )
{
	level.ai_hendricks waittill( "traversal_started" ); // Sent by notetrack
	
	spawn_manager::kill( "flood_combat_defend_room_fallback_spawns", true );
}

function set_doors_states_combat()
{
	level scene::init( "p7_fxanim_cp_sgen_door_bursting_01_bundle" );
	
	level thread sgen_util::set_door_state( "surgical_room_door", "open" );
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_0", "open" );
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_1", "open" );
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_2", "open" );
	level thread sgen_util::set_door_state( "flood_robot_room_door_close", "close" );
	level thread sgen_util::set_door_state( "flood_robot_room_door_open", "open" );
}

function set_doors_states_defend()
{
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_0", "open" );
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_1", "open" );
	level thread sgen_util::set_door_state( "surgical_room_interior_entrance_doors_2", "open" );
	level thread sgen_util::set_door_state( "flood_robot_room_door_close", "close" );
	level thread sgen_util::set_door_state( "flood_robot_crush_door", "close" );
	level thread sgen_util::set_door_state( "surgical_room_door", "close" );
}

function handle_earthquakes()
{
	level endon( "defend_time_expired" );

	level sgen_util::quake( 0.5, 1.5, sgen_util::get_players_center(), 5000, 4, 7 );

	while( true )
	{
		// TODO: try playing rumble at varying distances so intensity is dynamic
		if( math::cointoss() )
		{
			v_origin = level.ai_hendricks.origin;
		}
		else
		{
			v_origin = sgen_util::get_players_center();
		}
		
		if( isdefined( v_origin ) )
		{
			n_magnitude = RandomFloatRange( .15, .25 );
			n_duration = RandomFloatRange( .75, 1.78 );
			n_range = 5000;
			n_timeout = RandomFloatRange( 8, 15 );
			
			level sgen_util::quake( n_magnitude, n_duration, v_origin, n_range );
			
			wait n_timeout + n_duration;
		}
	}
}

function handle_fallback_runners_cleanup()
{
	level endon( "flood_combat_completed" ); // Flag set by skipto system
	
	t_exit = GetEnt( "flood_combat_flood_hall_cleanup_trig", "targetname" );
	
	while( true )
	{
		t_exit waittill( "trigger", ai_runner );
		
		ai_runner Delete();
		
		{wait(.05);};
	}
}

function issue_fallback()
{
	level.b_fallback_active = true;
	
	a_ai_54i_humans = GetAISpeciesArray( "axis", "human" );
	
	const N_MIN = .15;
	const N_MAX = .45;
	
	foreach( ai_human in a_ai_54i_humans )
	{	
		n_wait = RandomFloatRange( N_MIN, N_MAX );
		
		wait n_wait;
		
		if( IsAlive( ai_human ) )
		{
			ai_human thread fallback_think();
		}
	}
}

function cancel_fallback()
{
	level.b_fallback_active = false;
	
	a_ai_54i_humans = GetAISpeciesArray( "axis", "human" );
	
	const N_MIN = .15;
	const N_MAX = .45;
	const N_MAX_RAD = 768;
	const N_MIN_RAD = 512;
	
	foreach( ai_human in a_ai_54i_humans )
	{
		n_wait = RandomFloatRange( N_MIN, N_MAX );
			
		if( IsAlive( ai_human ) )
		{
			ai_human ai::set_behavior_attribute( "sprint", false );
			ai_human notify( "cancel_fallback" );
			ai_human.goalradius = N_MAX_RAD;
			ai_human thread go_to_nearest_node( undefined, N_MAX_RAD, N_MIN_RAD );
		}
	}
}

// self is AI
function go_to_nearest_node( v_origin = self.origin, n_min = 256, n_max = 512, b_reverse = false )
{
	self endon( "death" );
	
	a_nd_covers = GetNodesInRadiusSorted( v_origin, n_min, n_max, 128 );
	
	if( b_reverse && a_nd_covers.size > 1 )
	{
		a_nd_covers = array::reverse( a_nd_covers );
	}
	
	foreach( nd_cover in a_nd_covers )
	{
		if( !IsNodeOccupied( nd_cover ) && IsAlive( self ) )
		{
			self SetGoal( nd_cover );
			return;
		}
	}
	
	self SetGoal( self.origin );
}

// Enemies on our side of the door that closes go updairs
function issue_last_stand()
{
	level endon( "flood_defend_complete" );
	
	t_combat_zone = GetEnt( "flood_combat_prelab_zone_aitrig", "targetname" ); // Axis trigger
	t_last_stand_zone = GetEnt( "flood_combat_defend_upper_goaltrig", "targetname" );
	
	t_combat_zone endon( "death" );
	t_last_stand_zone endon( "death" );
	
	t_combat_zone SetInvisibleToAll();
	
	while( true )
	{
		t_combat_zone waittill( "trigger", e_triggerer );
		
		if( IsAlive( e_triggerer ) && e_triggerer.script_noteworthy !== "ignore_last_stand" )
		{
			e_triggerer notify( "cancel_fallback" );
			e_triggerer SetGoal( t_last_stand_zone );
		}
	}
}

function stop_fallback_and_scatter()
{
	level endon( "flood_defend_complete" );
	
	level waittill( "flooded_lab_door_close" ); // Sent by notetrack
	
	cancel_fallback();
	issue_scatter();
}

function issue_scatter()
{
	a_ai_54i = GetAITeamArray( "axis" );
	t_last_stand_zone = GetEnt( "flood_combat_defend_upper_goaltrig", "targetname" );
	t_combat_zone = GetEnt( "flood_combat_prelab_zone_aitrig", "targetname" );
	s_center = struct::get( "flood_defend_flee_center" );
	
	const N_MIN = .15;
	const N_MAX = .45;
	
	foreach( ai_54i in a_ai_54i )
	{
		n_wait = RandomFloatRange( N_MIN, N_MAX );
		
		if( IsAlive( ai_54i ) && !ai_54i IsTouching( t_last_stand_zone ) && !ai_54i IsTouching( t_combat_zone ) )
		{
			ai_54i.accuracy = .1;
			ai_54i.health = 1;
			
			ai_54i thread go_to_nearest_node( s_center.origin, s_center.radius, s_center.radius, true );
		}
	}
}

function handle_fallback()
{
	trigger::wait_till( "flood_combat_intro_fallback_trig" );
	
	level thread issue_fallback();
	
	trigger::wait_till( "flood_combat_charging_room_spawn_trig" );
	
	level thread cancel_fallback();
	
	level flag::wait_till( "flood_defend_start_flood_fallback" );
	
	trigger::use( "flood_combat_door_burst_trig" );
	
	level thread issue_fallback();
	
	trigger::wait_till( "flood_combat_robot_crushed_door_trig" );
	
	level thread cancel_fallback();
	
	trigger::wait_till( "flood_combat_prelab_spawn_trig" );
	
	level thread issue_fallback();
	
	level flag::wait_till( "flood_combat_surgical_room_door_close" );
	
	issue_last_stand();
}

// Self is AI
function fallback_spawnfunc()
{
	if( ( isdefined( level.b_fallback_active ) && level.b_fallback_active ) )
	{
		self fallback_think();
	}
}

// Self is AI
function fallback_think()
{
	nd_goal = GetNode( "flood_combat_fallback_node", "targetname" );
	
	self ai::set_behavior_attribute( "sprint", true );
	self ai::force_goal( nd_goal, 256, false, "cancel_fallback" );
}

function alarm_sounds()
{
	array::thread_all( GetEntArray( "alarm_sound", "targetname" ), &play_looping_alarm );
}


function play_looping_alarm()
{
	self PlayLoopSound( "evt_flood_alarm_" + self.script_noteworthy );
	self waittill( "stop_flood_sounds" );
	self StopLoopSound( .5 );
	self util::self_delete();
}

// Set window water looping
function defend_room_set_state_risk_of_flooding()
{
	level thread scene::play(  "water_lt_01", "targetname" ); 
	level scene::play(  "water_rt_02", "targetname" );
}

function defend_room_set_state_flooding()
{
	level scene::init( "dividerl_lt_01", "targetname" );
	level scene::init( "divider_rt_02", "targetname" );
	
	level flag::wait_till( "flood_combat_start_flooding" ); // Set on triggers
	
	level thread flooding_sound_start();
	level thread flooding_water_sheeting();
	level thread handle_flooding_waterfall_lt();
	level thread handle_flooding_waterfall_rt();

	e_water_nosight = GetEnt( "flood_combat_water_nosight", "targetname" );
	e_water_nosight.origin += ( 0, 0, 512 );
}

function handle_flooding_waterfall_lt()
{
	level clientfield::set( "w_flood_combat_windows_b", 1 );
	
	wait 1.2; // ~35 frames - as declared by fxanim dept
	
	level thread scene::stop(  "water_lt_01", "targetname", true );
	
	level thread scene::play(  "waterfall_lt_01", "targetname" );
	level thread scene::play(  "dividerl_lt_01", "targetname" );
}

function handle_flooding_waterfall_rt()
{
	level clientfield::set( "w_flood_combat_windows_c", 1 );
	
	wait .93; // ~28 frames - as declared by fxanim dept
	
	level thread scene::stop(  "water_rt_02", "targetname", true );
	
	level thread scene::play(  "waterfall_rt_02", "targetname" );
	level thread scene::play(  "divider_rt_02", "targetname" );
}

function defend_room_set_state_flooded()
{
	level thread flooding_sound_start();
	level thread flooding_water_sheeting();

	level clientfield::set( "w_flood_combat_windows_b", 1 );
	
	level thread scene::skipto_end(  "waterfall_lt_01", "targetname" );
	level thread scene::skipto_end(  "dividerl_lt_01", "targetname" );

	level clientfield::set( "w_flood_combat_windows_c", 1 );
	
	level thread scene::skipto_end(  "waterfall_rt_02", "targetname" );
	level thread scene::skipto_end(  "divider_rt_02", "targetname" );

	e_water_nosight = GetEnt( "flood_combat_water_nosight", "targetname" ); 
	e_water_nosight.origin += ( 0, 0, 512 );
}

function flooding_sound_start()
{
	flood_start_1 = GetEnt( "flooding_start_1", "targetname" );
	flood_start_2 = GetEnt( "flooding_start_2", "targetname" );
	torrent_gush_left = GetEnt( "evt_torrent_gush_left", "targetname" );
	torrent_gush_right = GetEnt( "evt_torrent_gush_right", "targetname" );
	torrent_surface_left = GetEnt( "evt_torrent_gush_surface_l", "targetname" );
	torrent_surface_right = GetEnt( "evt_torrent_gush_surface_r", "targetname" );
								
	
	if ( IsDefined( flood_start_1 ) && IsDefined( flood_start_2 ) )
	{
		playsoundatposition( "evt_flood_start_1", flood_start_1.origin );
		playsoundatposition( "evt_flood_start_2", flood_start_2.origin );
	}
	//water_grate_1 = GetEnt( "water_metal_sound_1", "targetname" );
	//water_grate_2 = GetEnt( "water_metal_sound_2", "targetname" );

	if ( IsDefined (torrent_gush_left) && IsDefined (torrent_gush_right ) && IsDefined (torrent_surface_left) && IsDefined (torrent_surface_right ))
	{
		//water_grate_1 PlayLoopSound ( "evt_torrent_water_metal" );
		//water_grate_2 PlayLoopSound ( "evt_torrent_water_metal" );
		torrent_gush_left playloopsound ("evt_torrent_gush");
		torrent_gush_right playloopsound ("evt_torrent_gush");	
		torrent_surface_left playloopsound ("evt_torrent_gush_surface");
		torrent_surface_right playloopsound ("evt_torrent_gush_surface");	
			
		level waittill( "stop_flood_sounds" );

		//water_grate_1 StopLoopSound( .5 );
		//water_grate_1 Delete();
		//water_grate_2 StopLoopSound( .5 );
		//water_grate_2 Delete();
		torrent_gush_left StopLoopSound( .5 );
		torrent_gush_left Delete();
		torrent_gush_right StopLoopSound( .5 );
		torrent_gush_right Delete();
		torrent_surface_left StopLoopSound( .5 );
		torrent_surface_left Delete();
		torrent_surface_right StopLoopSound( .5 );
		torrent_surface_right Delete();
		flood_start_1 Delete();
		flood_start_2 Delete();
	}
}

function flooding_water_sheeting()
{
	level endon( "flood_defend_completed" ); // Flag set by skipto system
	
	e_volume = GetEnt( "flood_combat_water_sheeting", "targetname" );

	e_volume endon( "death" );
	
	while ( true )
	{
		foreach ( player in level.players )
		{
			if ( player IsTouching( e_volume ) )
			{
				if ( !( isdefined( player.tp_water_sheeting ) && player.tp_water_sheeting ) )
				{
					player clientfield::set_to_player( "tp_water_sheeting", 1 );
					player.tp_water_sheeting = true;
				}
			}
			else
			{
				if ( ( isdefined( player.tp_water_sheeting ) && player.tp_water_sheeting ) )
				{
					player clientfield::set_to_player( "tp_water_sheeting", 0 );
					player.tp_water_sheeting = false;
				}
			}
		}

		wait ( 1 );
	}

	array::thread_all( level.players, &clientfield::set_to_player, "tp_water_sheeting", 0 );
}

function water_spout_push()
{
	level endon( "flood_combat_completed" );
	
	str_water_fx_origins = struct::get_array( self.target, "targetname" );
	v_dir = AnglesToForward( ( 0, str_water_fx_origins[ 0 ].angles[1], 0 ) );
	v_org = str_water_fx_origins[ 0 ].origin;
	v_length = 128; // Of FX sprout

	array::thread_all( str_water_fx_origins, &loop_water_spout_fx, self );

	while ( true )
	{
		self waittill( "trigger", player );

		if ( !player IsOnGround() && IsDefined( player.last_air_push_time ) && ( GetTime() - player.last_air_push_time ) < 1000 )
		{
			continue;
		}

		n_distance = Distance2D( v_org, player.origin );

		if ( n_distance > v_length )
		{
			continue;
		}

		if ( player IsSprinting() && n_distance > ( v_length * 0.40 ) )
		{
			continue;
		}

		n_push_strength = MapFloat( 0, v_length, 80.0, 0.0, n_distance  );

		player SetVelocity( v_dir * n_push_strength );

		if ( !player IsOnGround() )
		{
			player.last_air_push_time = GetTime();
		}
	}

}

function loop_water_spout_fx( trigger )
{
	level endon( "flood_combat_completed" );

	e_fx_origin = util::spawn_model( "tag_origin", self.origin, self.angles );
	e_fx_origin.script_objective = "flood_defend";
	
	trigger::wait_till( self.target, undefined, undefined, false );
	
	if( isdefined( trigger.script_string ) )
	{
		level thread scene::play( trigger.script_string );
		level thread sgen_util::quake( 0.35, RandomFloatRange( 0.8, 1.4 ), sgen_util::get_players_center(), 5000, 1, 2 );
	}
	
	e_fx_origin playsound( "evt_pipe_break" );
	e_fx_origin PlayLoopSound( "evt_water_pipe_flow" );
}

function play_surgical_room_door_scene()
{
	ai_door = spawner::simple_spawn_single( "surgical_room_door_close_guy_spawner" );
	
	level util::delay( 2, "death", &sgen_util::set_door_state, "surgical_room_door", "close" );
	// level scene::play( "surgical_room_close_door", "targetname", ai_door );
		
	if ( IsAlive( ai_door ) )
	{
		ai_door fallback_think();
	}
}

function flood_wave_sound()
{
	flood_emitter = spawn("script_origin", (26360, 1575, -6604));
	//flood_emitter playsound ("evt_flood_wave");

	level waittill( "play_flood_door_impact" ); // Sent via notetrack 
	
	flood_emitter playsoundwithnotify ("evt_flood_door_impact", "sounddone");
	flood_emitter waittill ("sounddone");
	flood_emitter delete();
}

function surgical_room_entrance_close_resistance()
{
	level thread surgical_room_entrance_close_resistance_earthquake();

	level waittill( "floor_door_open" );

	spawn_manager::disable( "flood_combat_reinforcements" );
	spawn_manager::kill( "flood_combat_reinforcements_human" );
}

function surgical_room_entrance_close_resistance_earthquake()
{
	level endon( "floor_door_open" );

	while ( true )
	{
		level sgen_util::quake( 0.35, RandomFloatRange( 0.8, 1.4 ), sgen_util::get_players_center(), 5000, 1, 2 );

		wait RandomIntRange( 8, 15 );
	}
}

function break_surgical_room_windows()
{
	trigger::wait_till( "flood_combat_windows_start", undefined, undefined, false );

	level thread flooding_window_break( "a" );
}

function defend_logic( b_starting )
{
	const N_DEFEND_START_TIMEOUT = 10;
	const N_DEFEND_TIME = 40;
	const N_DEFEND_LAST_STAND_TIME = 5;

	t_flood_hint_trigger = GetEnt( "floor_door_hint_trigger", "targetname" );
	t_flood_hint_trigger SetHintString( &"CP_MI_SING_SGEN_FLOOD_USE_DOOR" );
	t_flood_hint_trigger SetCursorHint( "HINT_NOICON" );
	
	level thread play_flood_hallway_kill_scene();
	level thread handle_flood_hallway();
	level thread stop_fallback_and_scatter();
	
	level waittill( "defend_ready" );
	
	level flag::set( "flood_defend_enemies_spawning" ); // Enable triggers
		
	spawn_manager::enable( "flood_combat_reinforcements" );
	
	level thread catwalk_zone_anti_camper_measures();
	
	if( b_starting )
	{
		play_hendricks_defend_scene();
	}

	level flag::wait_till( "hendricks_defend_started" );
	
	spawn_manager::enable( "flood_combat_reinforcements_human" );
	
	level.ai_hendricks ai::set_ignoreall( true );

	level thread surgical_room_entrance_close_resistance();
	
	wait N_DEFEND_TIME; // Defend timeout
	
	level notify( "defend_time_near" );
	
	wait N_DEFEND_LAST_STAND_TIME; // Defend timeout
	
	level flag::set( "defend_time_expired" ); // Enables trigger

	t_flood_hint_trigger waittill( "trigger" );

	level notify( "floor_door_open" );

	scene::add_scene_func( "cin_sgen_22_01_release_torrent_1st_flood_hendricks", &handle_flood_door_animation, "play" );
	level thread scene::play( "cin_sgen_22_01_release_torrent_1st_flood_hendricks", level.ai_hendricks );

	scene::add_scene_func( "cin_sgen_22_01_release_torrent_1st_flood_player", &play_water_teleport_fx, "play" );
	scene::add_scene_func( "cin_sgen_22_01_release_torrent_1st_flood_player", &stop_water_teleport_fx, "done" );
	level scene::play( "cin_sgen_22_01_release_torrent_1st_flood_player" );
	
	level notify ( "stop_flood_sounds" );

	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks colors::enable();
	
	spawn_manager::kill( "flood_defend_catwalk_spawn_zone_spawnmanager", true );
}

function play_water_teleport_fx( a_ents )
{
	wait 1.5;  //TODO - needs a notetrack to time the water fx
	
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "water_teleport", 1 );
	}
}

function stop_water_teleport_fx( a_ents )
{
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "water_teleport", 0 );
	}
}

function play_hendricks_defend_scene()
{
	level scene::play( "cin_sgen_22_01_release_torrent_vign_flood_new_hendricks_hackdoor", level.ai_hendricks );
		
	level flag::set( "hendricks_defend_started" );
		
	level thread scene::play( "cin_sgen_22_01_release_torrent_vign_flood_new_hendricks_grabdoor", level.ai_hendricks );
}

function hendricks_defend_movement()
{
	level.ai_hendricks colors::disable();
	level.ai_hendricks.goalradius = 16;
	
	nd_goal = GetNode( "flood_defend_hendricks_ready_node", "targetname" );
		
	level.ai_hendricks SetGoal( nd_goal );
}

function flooding_window_break( str_side )
{
	a_s_window = struct::get_array( "flood_combat_window_break_" + str_side, "targetname" );

	foreach ( s_window in a_s_window )
	{
		s_window_end = struct::get( s_window.target, "targetname" );

		for ( x = 0; x < 10; x++ )
		{
			MagicBullet( GetWeapon( "ar_standard" ), s_window.origin, s_window_end.origin );
		}
	}

	if ( ( str_side === "b" ) )
	{
		e_volume = GetEnt( "flood_combat_window_break_volume", "targetname" );

		ai = GetAIArray();

		for ( x = 0; x < ai.size; x++ )
		{
			if ( ai[ x ] IsTouching( e_volume ) )
			{
				ai[ x ].skipdeath = true;
				ai[ x ] DoDamage( ai[ x ].health + 666, ai[ x ].origin );
				ai[ x ] StartRagdoll();
				ai[ x ] LaunchRagdoll( AnglesToForward( ( 0, 90, 0 ) ) * 120 );
			}
		}
	}
}

function charging_station_cleanup()
{
	level thread sgen_util::set_door_state( "charging_station_entrance", "close" );
	
	array::thread_all( GetEntArray( "pod_track_model", "targetname" ), &util::self_delete );
}


function reinforcement_robot_setup()
{
	self ai::set_behavior_attribute( "force_cover", true );
	self ai::set_behavior_attribute( "sprint", true );
	self ai::set_behavior_attribute( "move_mode", "rambo" );
}

// Spawn closet catwalk stairs becomes kill zone
// Out of bounds trigger enables further down the hall when event starts to kill players who idle during events - "flood_defend_out_of_boundary_trig"
function catwalk_zone_anti_camper_measures()
{
	t_zone = GetEnt( "flood_defend_catwalk_spawn_zone_trig", "targetname" );
	e_spawnmanager = GetEnt( t_zone.target, "targetname" );
	
	t_zone endon( "death" );
	
	t_zone waittill( "trigger" ); // Trigger spawn manager
	
	level thread sgen_util::set_door_state( "flood_robot_room_door_close", "open" );
	level thread sgen_util::set_door_state( "flood_robot_room_door_open", "close" );
	
	while( isdefined( t_zone ) )
	{
		t_zone waittill( "trigger" );
	
		if( !spawn_manager::is_enabled( e_spawnmanager.targetname ) )
		{
			spawn_manager::enable( e_spawnmanager.targetname );
		}
		
		set_ignoreall_array( "flood_defend_catwalk_spawn_zone_robot", undefined, false );
				
		level flag::wait_till( "flood_defend_catwalk_spawn_zone_unoccupied" ); // Set when trigger cleared
		
		set_ignoreall_array( "flood_defend_catwalk_spawn_zone_robot" ); // Rushers will stay in goal while ignoring
		
		spawn_manager::disable( e_spawnmanager.targetname );
		
		t_zone thread kill_anti_campers();
	}
}

// Self is trigger
function kill_anti_campers()
{
	self endon( "death" );
	self endon( "trigger" );
	
	wait 4; // Death timeout
	
	a_ai_robots = GetEntArray( "flood_defend_catwalk_spawn_zone_robot" + "_ai", "targetname" ); 
		
	foreach( ai_kill in a_ai_robots )
	{
		ai_kill Kill();
	}
}

function set_ignoreall_array( str_spawner_name, str_key = "targetname", b_ignore = true )
{
	a_ai_ignorers = GetEntArray( str_spawner_name + "_ai", str_key ); 
	
	array::thread_all( a_ai_ignorers, &ai::set_ignoreall, b_ignore );
}

//----------------------------------------------------
// Scenes
// ---------------------------------------------------
function play_rejoin_scene()
{
	level scene::play( "cin_sgen_21_03_floodcombat_vign_rejoin" );
}

function play_robot_door_scene()
{
	level flag::wait_till( "flood_combat_door_crush_robot_start" ); // Set on triggers
	
	level thread scene::play( "cin_sgen_21_02_floodcombat_vign_escape_robot01" );
	
	level waittill( "crushed_robot_door_water_spray_start" ); // Sent via notetrack
	
	trigger::use( "sgen_robot_crushed_water_trig" );
}

function play_flood_hallway_kill_scene()
{
	ai_doorman = spawner::simple_spawn_single( "flood_defend_flood_door_guy" ); // Spawn to do reach into the space
	
	level scene::init( "cin_sgen_21_03_surgical_room_vign_closedoor_54i01", ai_doorman );
	
	trigger::wait_till( "flood_defend_defend_area_trig" );
	
	if( IsAlive( ai_doorman ) )
	{
		ai_doorman ai::set_ignoreall( true );
		ai_doorman ai::set_ignoreme( true );
		
		level scene::play( "cin_sgen_21_03_surgical_room_vign_closedoor_54i01", ai_doorman );
	}
}

function handle_flood_hallway()
{
	level thread scene::play( "p7_fxanim_cp_sgen_debris_hallway_flood_bundle" );
	
	level clientfield::set( "flood_defend_hallway_flood_siege", 1 ); // Play siege scene
	
	level thread handle_wave_kill_area();
	
	level waittill( "debris_hallway_doors_shut_start" ); // Sent via notetrack - p7_fxanim_cp_sgen_debris_hallway_flood_anim.xanim
		
	level thread flood_wave_sound();
	level scene::init( "fxanim_flooded_lab_door", "targetname" );
}

function handle_wave_kill_area()
{
	s_kill_center = struct::get( "flood_defend_wave_source_spot" );
	
	level waittill( "debris_hallway_start_radial_kill_pulse" ); // Sent via notetrack
	
	a_ai_54i = GetAISpeciesArray( "axis", "human" );
	a_ai_54i = ArraySortClosest( a_ai_54i, s_kill_center.origin );
	
	foreach( ai_54i in a_ai_54i )
	{
		wait RandomFloatRange( .2, .32 );
		
		if( IsAlive( ai_54i ) && Distance2D( ai_54i.origin, s_kill_center.origin ) <= s_kill_center.radius )
		{
			ai_54i Kill();
		}
	}
	
	level flag::set( "flood_defend_flood_hallway_kill_zone_enabled" ); // Enables trigger
}

function set_pipes_states_combat()
{
	level scene::init( "p7_fxanim_cp_sgen_pipes_bursting_04_bundle" );
}

function handle_flood_door_animation( a_ents )
{
	level scene::play( "fxanim_flooded_lab_door", "targetname" );
}

//----------------------------------------------------
// VO
// ---------------------------------------------------
function combat_vo()
{
	level.ai_hendricks dialog::say( "hend_what_the_hell_was_0", RandomFloatRange( .2, .3 ) ); //...what the hell was that?
	level.ai_hendricks dialog::say( "plyr_sounds_like_taylor_s_0", RandomFloatRange( .2, .3 ) ); // Sounds like Taylor’s new friends...
	
	level flag::wait_till( "pallas_lift_front_open" );

	level dialog::remote( "kane_hendricks_we_have_m_0", RandomFloatRange( .1, .25 ) ); 				// Hendricks! We have multiple explosions across the facility - you have to move now!
	level.ai_hendricks dialog::say( "hend_you_heard_her_let_0", RandomFloatRange( .2, .3 ) ); 	// You heard her - Let’s get the hell outta here!!!
	
	level dialog::remote( "kane_overwatch_drone_show_0", RandomFloatRange( .5, .76 ) ); // Overwatch Drone shows 54 Immortals all over the surface. They’re blowing the damn building to drown you!!
		
	level thread do_security_room_nag();
	
	trigger::wait_till( "flood_combat_charging_station_zone_trig" );

	level.ai_hendricks dialog::say( "hend_get_through_them_we_0" ); 							// Get through them! We’re running out of time!
	
	level thread do_charging_room_nag();
}

function do_security_room_nag()
{
	level endon( "flood_combat_completed" ); // Flag set by skipto system
	
	n_nag_min = 3;
	n_nag_max = 4;
	n_index = 0;
	a_str_nags = [];
	a_str_nags[0] = "hend_keep_moving_the_wh_0"; // // // Keep moving!! The whole place is collapsing!! 
	a_str_nags[1] = "hend_go_go_go_0"; // Go, go, go!!	
	
	while( n_index < a_str_nags.size )
	{
		trigger::wait_till( "flood_combat_security_room_zone_trig" );
	
		if( !level flag::get( "flood_combat_nag_playing" ) )
		{
			level flag::set( "flood_combat_nag_playing" );
			
			level.ai_hendricks dialog::say( a_str_nags[ n_index ] );
			
			n_index++;
			
			level flag::clear( "flood_combat_nag_playing" );
			
			n_nag_time = RandomFloatRange( n_nag_min, n_nag_max );
		
			wait n_nag_time;
		}
	}
}

function do_charging_room_nag()
{
	level endon( "flood_combat_completed" ); // Flag set by skipto system
	
	n_nag_min = 3;
	n_nag_max = 6;
	n_index = 0;
	a_str_nags = [];
	a_str_nags[0] = "hend_fucking_move_0"; // // Fucking move!!!
	a_str_nags[1] = "hend_don_t_stop_move_m_0"; // Don’t stop!! Move, move, move!!
	
	while( n_index < a_str_nags.size )
	{
		n_nag_time = RandomFloatRange( n_nag_min, n_nag_max );
		
		wait n_nag_time;
		
		trigger::wait_till( "flood_combat_charging_station_zone_trig" );
	
		if( !level flag::get( "flood_combat_nag_playing" ) )
		{
			level flag::set( "flood_combat_nag_playing" );
			
			level.ai_hendricks dialog::say( a_str_nags[ n_index ] );
			
			n_index++;
			
			level flag::clear( "flood_combat_nag_playing" );
		}
	}
}

function defend_vo()
{
	trigger::wait_or_timeout( 20, "flood_defend_defend_area_trig" );
	
	level dialog::player_say( "plrf_kane_i_hope_you_go_0" ); 									// Kane - I hope you got a plan, because we’re about to drown.
	level dialog::remote( "kane_alright_i_ll_talk_y_0", RandomFloatRange( .1, .25 ) ); 				// Alright, I’ll talk you through it. Open that door and flood the lab.
	level.ai_hendricks dialog::say( "hend_what_are_you_insan_0", RandomFloatRange( .1, .25 ) ); // What?? Are you insane??
	
	level dialog::remote( "kane_not_if_this_works_y_0", RandomFloatRange( .1, .25 ) );				// Not if this works. Your lungs should have more than enough air to get to the surface.
	level.ai_hendricks dialog::say( "hend_okay_okay_but_if_t_0", RandomFloatRange( .1, .25 ) );	// Okay, okay! But if this doesn’t work - I’m gonna fucking HAUNT you Kane...
	
	level notify( "defend_ready" );
	
	level.ai_hendricks dialog::say( "hend_shit_it_s_jammed_sh_0", RandomFloatRange( 1.5, 1.98 ) );	// Shit, it’s jammed shut! I gotta override the door’s system, cover me!!

	level waittill( "defend_time_near" );
	
	level.ai_hendricks dialog::say( "hend_just_a_few_more_seco_0", RandomFloatRange( .1, .25 ) );	// Just a few more seconds!!
	
	level waittill( "defend_time_expired" );
	
	level.ai_hendricks dialog::say( "hend_give_me_a_hand_0" );									// Give me a hand!
	
	level.ai_hendricks thread do_defend_nag();
}

// Self is AI
function do_defend_nag()
{
	level endon( "flood_defend_completed" ); // Flag set by skipto system
	
	a_str_nags = [];
	a_str_nags[0] = "hend_c_mon_we_gotta_get_o_0"; // C’mon we gotta get outta here!!
	a_str_nags[1] = "hend_the_whole_building_s_0"; // The whole building’s collapsing, help me out!!
	a_str_nags[2] = "hend_what_are_you_waiting_3"; // What are you waiting for?!! We gotta open this door NOW!!
	
	foreach( n_index, str_nag in a_str_nags )
	{
		wait RandomFloatRange( 2.56, 3.1 );
		
		level.ai_hendricks dialog::say( a_str_nags[n_index], RandomFloatRange( .1, .25 ) );
	}
}

//----------------------------------------------------
// Objectives
// ---------------------------------------------------
function handle_breadcrumbs()
{
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "flood_combat_start_breadcrumb_trig" );
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "flood_combat_breadcrumb_robot_door_trig" );
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "flood_combat_breadcrumb_surgical_door_trig" );
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "flood_combat_breadcrumb_surgical_stairs_trig" );
	objectives::breadcrumb( "cp_level_sgen_breadcrumb", "flood_combat_breadcrumb_catwalk_trig" );
	
	objectives::complete( "cp_level_sgen_breadcrumb" );
	objectives::set( "cp_level_sgen_breadcrumb", struct::get( "flood_combat_breadcrumb_end" ) );
}

function handle_defend_breadcrumbs()
{
	objectives::complete( "cp_level_sgen_breadcrumb", struct::get( "flood_combat_breadcrumb_end" ) );
	objectives::set( "cp_level_sgen_breadcrumb", struct::get( "flood_combat_breadcrumb_defend_room" ) );
	
	level flag::wait_till( "hendricks_defend_started" );
	
	objectives::complete( "cp_level_sgen_breadcrumb", struct::get( "flood_combat_breadcrumb_defend_room" ) );
	objectives::set( "cp_level_sgen_defend_3d", struct::get( "flood_defend_breadcrumb_start_spot" ) );
	
	level flag::wait_till( "defend_time_expired" );
	
	objectives::complete( "cp_level_sgen_defend_3d" );
	objectives::set( "cp_level_sgen_use_door" );
	
	level waittill( "stop_flood_sounds" );
	
	objectives::complete( "cp_level_sgen_use_door" );
}
