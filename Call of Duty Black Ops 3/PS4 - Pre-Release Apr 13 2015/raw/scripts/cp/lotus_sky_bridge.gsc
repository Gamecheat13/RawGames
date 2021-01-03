#using scripts\codescripts\struct;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\lotus_util;

#using scripts\shared\ai\archetype_robot;
#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       















//*****************************************************************************
// INDUSTRIAL ZONE
//*****************************************************************************
function industrial_zone_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		skipto::teleport_ai( str_objective );
		
		lotus_util::spawn_funcs_generic_rogue_control();
	}
	
	// specific for industrial
	spawner::add_spawn_function_group( "industrial_nrc", "script_noteworthy", &industrial_fight );
		
	exploder::exploder( "fx_vista_read2a" );
	
	custom_traversals_on_off( "sky_bridge_top_1_traversal", true );
	
	// destruction state
	set_skybridge_destruction_state( "skybridge_event_10-39_broken", 	"hide" );
	set_skybridge_destruction_state( "skybridge_event_10-41_broken", 	"hide" );
	set_skybridge_destruction_state( "skybridge_event_10-42_broken", 	"hide" );

	// shift pristine skybridge01 into place (apply preset offset)
	a_skybridge_chunks = GetEntArray( "skybridge_event_10-41", "targetname" );
	foreach( e_chunk in a_skybridge_chunks )
	{
		e_chunk.origin = e_chunk.origin + ( 9206, 0, 0 );
	}

	wait 0.1; // give the bridge time to get into position before connecting the traversals
	
	// connect custom traversals now that bridge is in place
	custom_traversals_on_off( "skybridge00a_custom_traversal", true );
	custom_traversals_on_off( "skybridge01_custom_traversal", true );
	custom_traversals_on_off( "skybridge01a_custom_traversal", true );
	custom_traversals_on_off( "skybridge02_custom_traversal", true );
	
	level thread flyby_vtols();
	
	trigger::wait_till( "trig_industrial_hendricks_move_up" );
	
	level thread industrial_ambient_bridge_battle();
	level thread industrial_sequence();
	level thread industrial_rvh_battle();
	
	trigger::wait_till( "industrial_zone_complete" );
	skipto::objective_completed( "industrial_zone" );
}

function industrial_zone_done( str_objective, b_starting, b_direct, player )
{
}

function industrial_ambient_bridge_battle()
{
	// start endless battle between NRC and robots on upper floor of bridge 1
	spawn_manager::enable( "sm_skybridge_01_shooters" ); // nrc shooters
	spawn_manager::enable( "sm_skybridge_01_zombies" ); // robot zombies
	
	trigger::wait_till( "trig_industrial_end_fight" );

	spawn_manager::disable( "sm_skybridge_01_shooters" ); // nrc shooters
	spawn_manager::disable( "sm_skybridge_01_zombies" ); // robot zombies
	
	a_enemies = spawn_manager::get_ai( "sm_skybridge_01_shooters" );
	array::run_all( a_enemies, &Kill );
	
	a_enemies = spawn_manager::get_ai( "sm_skybridge_01_zombies" );
	array::run_all( a_enemies, &Kill );
}

function industrial_sequence()
{	
	scene::init( "cin_lot_09_02_pursuit_vign_wallsmash" );
	
	trigger::wait_till( "body_fall_trigger" );
	
	level thread scene::play( "cin_lot_09_02_pursuit_vign_thrown" );

	trigger::wait_till( "trig_wallsmash" );

	scene::play( "cin_lot_09_02_pursuit_vign_wallsmash" );
	
	trigger::wait_till( "trig_industrial_spawn_2" );
	
	mdl_clip = GetEnt( "industrial_jump_robot_clip", "targetname" );
	mdl_clip Delete();
}

function industrial_rvh_battle()
{
	trigger::wait_till( "trig_industrial_rvh" );
	
	level thread sky_bridge_rvh_battles( 10, "trig_industrial_end_fight", 0.25 );
	level thread sky_bridge_rvh_battles( 11, "trig_industrial_end_fight", 0.25 );
}

// self == enemy
function industrial_fight( n_level, str_volume )
{
	self endon( "death" );
	
	if ( self.archetype == "robot" )
	{
		self ai::set_behavior_attribute( "rogue_control", "forced_level_" + n_level );
		
		if ( IsDefined( str_volume ) )
		{
			e_goalvolume = GetEnt( str_volume + "_1", "targetname" );
			self SetGoal( e_goalvolume );
		}
	}
	else
	{
		self ai::set_behavior_attribute( "can_initiateaivsaimelee", false );
		self ai::set_behavior_attribute( "can_melee", false );
	}
	
	self.overrideActorDamage = &industrial_nrc_damage_override;
	
	trigger::wait_till( "trig_industrial_end_fight" );
	
	self.b_end_fight = true;
	
	if ( IsDefined( str_volume ) )
	{
		trigger::wait_till( "trig_industrial_spawn_1" );
		
		e_goalvolume = GetEnt( str_volume + "_2", "targetname" );
		self SetGoal( e_goalvolume );
		
		trigger::wait_till( "trig_industrial_spawn_2" );
		
		self ClearGoalVolume();
	}
}

// self == enemy
function industrial_nrc_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( self.b_end_fight === true && self.archetype == "human" )
	{
		n_damage = self.health;
	}
	else if ( !IsPlayer( e_inflictor ) )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

//*****************************************************************************
// SKY BRIDGE1
//*****************************************************************************
function sky_bridge1_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		
		skipto::teleport_ai( str_objective );
		
		lotus_util::spawn_funcs_generic_rogue_control();
	}
	
	spawner::add_spawn_function_group( "robot_fall_to_death", "script_noteworthy", &robot_fall_to_death );
	
	level scene::init( "p7_fxanim_cp_lotus_mobile_shop_sky02_bundle" );
	level scene::init( "p7_fxanim_cp_lotus_mobile_shop_sky03_break_bundle" );

	// destruction state
	set_skybridge_destruction_state( "skybridge_event_10-39_broken", 	"hide" );
	set_skybridge_destruction_state( "skybridge_event_10-41_broken", 	"hide" );
	set_skybridge_destruction_state( "skybridge_event_10-42_broken", 	"hide" );
	
	// connect custom traversals now that bridge is in place
	custom_traversals_on_off( "sb_1_broken_start", true );
	
	debris_push_animation();
	
	level thread wwz_vtol();
	
	trigger::wait_till( "trig_mobile_shop_sky01" );
	
	level thread sky_bridge_climbers();
	
	mdl_clip = GetEnt( "mobile_shop_fall_1_clip", "targetname" );
	mdl_clip Delete();
	
	level thread scene::play( "p7_fxanim_cp_lotus_mobile_shop_sky01_bundle" );
	
	level thread sky_bridge_bottom_rvh_battle();

	trigger::wait_till( "sky_bridge1_complete" );
	skipto::objective_completed( "sky_bridge1" );
}

function sky_bridge1_done( str_objective, b_starting, b_direct, player )
{
}

function debris_push_animation()
{
	t_debris_push = GetEnt( "trig_debris_push", "targetname" );
	t_debris_push TriggerEnable( false );
	
	scene::init( "cin_lot_10_01_skybridge_1st_push", level.ai_hendricks );
	
	level.ai_hendricks waittill( "goal" );
	
	t_debris_push TriggerEnable( true );
	trigger::wait_till( "trig_debris_push" );
	
	level thread debris_push_sky_bridge_view();
	
	mdl_clip = GetEnt( "debris_push_clip", "targetname" );
	mdl_clip Delete();
	
	scene::play( "cin_lot_10_01_skybridge_1st_push" );
	
	spawn_manager::enable( "sm_sky_bridge_1" );
}

function debris_push_sky_bridge_view()
{
	wait 2.7; // latest possible moment before the player can see robots spawning in - probably can get a notetrack for this
	
	level thread robot_vs_human_battle();
	
	level thread sky_bridge_rvh_battles( 2, "trig_mobile_shop_sky01" );
	level thread sky_bridge_rvh_battles( 3, "trig_mobile_shop_sky01" );
	level thread sky_bridge_rvh_battles( 4, "trig_mobile_shop_sky01" );
	level thread sky_bridge_rvh_battles( 5, "trig_mobile_shop_sky01" );
	
	spawn_manager::enable( "sm_sky_bridge_0" );
	
	level thread skybridge01_kaboom();
	
	set_skybridge_destruction_state( "skybridge_event_10-39_broken", "show" );
	set_skybridge_destruction_state( "skybridge_event_10-41_broken", "show" );
	set_skybridge_destruction_state( "skybridge_event_10-39", "delete" );
	set_skybridge_destruction_state( "skybridge_event_10-41", "delete" );
	
	ai_robot = spawner::simple_spawn_single( "robot_long_jump" );
	level thread scene::play( "cin_lot_10_01_skybridge_vign_jump_robot04", ai_robot );
	
	ai_robot = spawner::simple_spawn_single( "robot_long_jump" );
	level thread scene::play( "cin_lot_10_01_skybridge_vign_jump_robot05", ai_robot );
}

function set_skybridge_destruction_state( str_name, str_state )
{
	a_kaboom_chunks = GetEntArray( str_name, "targetname" );
	foreach( e_chunk in a_kaboom_chunks )
	{
		if( str_state == "hide" )
		{
			e_chunk Ghost();
			e_chunk NotSolid();
		}
		else if( str_state == "show" )
		{
			e_chunk Show();
			e_chunk Solid();
		}
		else
		{
			e_chunk Delete();
		}
	}	
}

function robot_vs_human_battle()
{
	ai_human = spawner::simple_spawn_single( "rvh_human_0" );
	ai_robot = spawner::simple_spawn_single( "rvh_robot_0" );
	
	ai_human ai::set_ignoreall( true );
	ai_human ai::set_ignoreme( true );
	ai_robot SetEntityTarget( ai_human );
	
	wait 0.85; // can wait before the 2nd pair
	
	ai_human = spawner::simple_spawn_single( "rvh_human_1" );
	ai_robot = spawner::simple_spawn_single( "rvh_robot_1" );
	
	ai_human ai::set_ignoreall( true );
	ai_human ai::set_ignoreme( true );
	ai_robot SetEntityTarget( ai_human );
}

function sky_bridge_rvh_battles( n_index, str_trigger, n_wait ) // ambient melee battles between robots vs human
{
	ai_human = spawner::simple_spawn_single( "rvh_human_" + n_index );
	ai_robot = spawner::simple_spawn_single( "rvh_robot_" + n_index );
	
	ai_human ai::set_behavior_attribute( "can_initiateaivsaimelee", false );
	ai_human.overrideActorDamage = &rvh_damage_override;
	ai_human SetEntityTarget( ai_robot );
	
	ai_robot.overrideActorDamage = &rvh_damage_override;
	ai_robot SetEntityTarget( ai_human );
	ai_robot rogue_control_ignore_players( true );
	
	trigger::wait_till( str_trigger );
	
	if ( isdefined( n_wait ) )
	{
		wait n_wait;
	}
	
	if ( IsAlive( ai_human ) )
	{
		ai_human ai::set_ignoreall( true );
		ai_human ai::set_ignoreme( true );
		ai_human.b_end_fight = true;
	}
	
	if ( IsAlive( ai_robot ) )
	{
		ai_robot.b_end_fight = true;
		ai_robot rogue_control_ignore_players( false );
	}
}

// self == enemy
function rvh_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( !IsPlayer( e_inflictor ) )
	{
		if ( !isdefined( self.b_end_fight ) || e_inflictor.archetype === "human" )
		{
			n_damage = 0;
		}
	}
	else if ( e_inflictor.targetname === "wwz_vtol_vh" )
	{
		n_damage *= 2;
	}
	
	return n_damage;
}

// self == rogue control
function rogue_control_ignore_players( b_ignore )
{
	foreach ( player in level.players )
	{
		self SetIgnoreEnt( player, b_ignore );
	}
}

function sky_bridge_bottom_rvh_battle()
{
	level thread sky_bridge_rvh_battles( 6, "sky_bridge1_complete", 0.15 );
	level thread sky_bridge_rvh_battles( 7, "sky_bridge1_complete", 0.15 );
	level thread sky_bridge_rvh_battles( 8, "sky_bridge1_complete", 0.15 );
	level thread sky_bridge_rvh_battles( 9, "sky_bridge1_complete", 0.15 );
}

// self == enemy robot
function robot_fall_to_death()
{
	self ai::set_behavior_attribute( "rogue_control", "forced_level_2" );
	
	nd_traversal = GetNode( "fall_to_death_traversal", "targetname" );
	self ai::set_behavior_attribute( "rogue_control_force_goal", nd_traversal.origin );
}

function wwz_vtol()
{
	e_carver = GetEnt( "wwz_vtol_crash_carver", "targetname" );
	e_carver ConnectPaths();
	
	trigger::wait_till( "trig_wwz_vtol" );
	
	vh_vtol = vehicle::simple_spawn_single_and_drive( "wwz_vtol" );
	vh_vtol flag::init( "set_0_done" );
	vh_vtol thread wwz_vtol_targets();
	
	vh_vtol flag::wait_till( "set_0_done" );
	
	level notify( "robot_swarm" );
	
	e_origin = GetEnt( "wwz_target_final", "targetname" );
	vh_vtol SetLookAtEnt( e_origin );
	
	nd_start = GetVehicleNode( "wwz_vtol_start_nd_1", "targetname" );
	vh_vtol vehicle::get_on_and_go_path( nd_start );
	
	flag::wait_till( "play_wwz_vtol_crash" ); // flag set in Radiant on a trigger
	
	level notify( "vtol_crash_start" );
	
	vh_vtol ClearVehGoalPos();
	
	ai_climber = spawner::simple_spawn_single( "sb_1_normal_climber" );
	ai_climber.script_string = "wwz_robot";
	ai_climber rogue_control_ignore_players( true );
	
	a_scene_1 = array( ai_climber, vh_vtol );
	level thread scene::play( "cin_lot_10_02_skybridge_vign_wwzfinale_robot01", a_scene_1 );
	
	const n_wwz_robot_remaining = 9;
	for ( i = 2; i <= n_wwz_robot_remaining; i++ )
	{
		ai_climber = spawner::simple_spawn_single( "sb_1_normal_climber" );
		ai_climber.script_string = "wwz_robot";
		ai_climber rogue_control_ignore_players( true );
		level thread scene::play( "cin_lot_10_02_skybridge_vign_wwzfinale_robot0" + i, ai_climber );
	}
	
	level thread scene::play( "p7_fxanim_cp_lotus_skybridge_vtol_crash_bundle" );
	
	wait 8;	// TODO: replace this with a notetrack on the anim?
	
	level notify( "vtol_crash_done" );
	
	e_volume = GetEnt( "vol_wwz_crash", "targetname" );
	//a_robot_swarm = GetAIArray( "sky_bridge_swarm", "script_string" );
	a_robot_swarm = GetAITeamArray( "team3" );
	foreach ( ai_robot in a_robot_swarm )
	{
		if ( ai_robot IsTouching( e_volume ) )
		{
			ai_robot Kill();
		}
	}
	
	custom_traversals_on_off( "sb_1_broken_start", false );
	
	set_skybridge_destruction_state( "skybridge_event_10-42", "hide" );
	set_skybridge_destruction_state( "skybridge_event_10-42-clip", "hide" );
	set_skybridge_destruction_state( "skybridge_event_10-42_broken", "show" );
	
	e_carver DisconnectPaths();
	
	foreach ( player in level.players )
	{
		player PlayRumbleOnEntity( "artillery_rumble" );
		Earthquake( 0.5, 0.15, player.origin, 64 );
	}
	
	a_wwz_robots = GetAIArray( "wwz_robot", "script_string" );
	array::run_all( a_wwz_robots, &Kill );
	
	level.ai_hendricks colors::disable();
	
	level scene::play( "cin_lot_10_03_skybridge_vign_vtoljump_hendricks", level.ai_hendricks );
	
	skipto::teleport_ai( "sky_bridge2", level.ai_hendricks ); // HACK: remove this once hendricks animation is correct
	
	level.ai_hendricks colors::enable();
}

// self == vtol
function wwz_vtol_targets()
{
	self endon( "death" );
	level endon( "vtol_crash_done" );
	
	e_origin = GetEnt( "wwz_target", "targetname" );
	self SetLookAtEnt( e_origin );
	
	wait 1; // time before firing at its targets
	
	a_enemies = GetAIArray( "rvh_ambient_first", "script_string" );
	foreach ( ai_enemy in a_enemies )
	{
		if ( IsAlive( ai_enemy ) )
		{
			self turret::shoot_at_target( ai_enemy, -1, undefined, 0 );
		}
	}
	
	self flag::set( "set_0_done" );
	
	while ( true )
	{
		a_robot_swarm = GetAIArray( "sky_bridge_swarm", "script_string" );
		foreach ( ai_robot in a_robot_swarm )
		{
			if ( IsAlive( ai_robot ) )
			{
				self turret::shoot_at_target( ai_robot, -1, undefined, 0 );
			}
		}
		
		wait 0.05;
	}
}

function sky_bridge_climbers()
{
	level thread sky_bridge_robot_swarm();
	
	const n_rushers = 3; // can be made the number of players based?
	const n_sets_of_normal_climbers = 3;
	
	trigger::wait_till( "trig_sb_climbers_0" );
	
	str_side = "right_";
	a_indexes = create_array_of_index( n_sets_of_normal_climbers );
	n_index_counter = 0;
	
	for ( i = 0; i < n_rushers; i++ )
	{
		ai_climber = spawner::simple_spawn_single( "sb_1_normal_climber" );
		n_climber_index = a_indexes[ n_index_counter ];
		s_climb_bundle = struct::get( "sb_normal_climb_" + str_side + n_climber_index );
		ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_sideclimb_robot02" );
		
		if ( str_side == "left_" )
		{
			str_side = "right_";
		}
		else
		{
			str_side = "left_";
		}
		
		n_index_counter++;
		
		if ( n_index_counter == a_indexes.size )
		{
			a_indexes = random_shuffle( a_indexes );
			n_index_counter = 0;
		}
		
		wait RandomFloatRange( 0.05, 0.15 );
	}
	
	if ( level.players.size > 2 )
	{
		const n_shooters = 2;
		const n_sets_of_fast_climbers = 1;
		
		a_nodes = GetNodeArray( "fast_climber_dest", "targetname" );
		
		for ( i = 0; i < n_shooters; i++ )
		{
			ai_climber = spawner::simple_spawn_single( "sb_forced_level_1" );
			n_climber_index = RandomInt( n_sets_of_fast_climbers );
			s_climb_bundle = struct::get( "sb_fast_climb_" + str_side + n_climber_index );
			ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_climbinfast_robot01" );
			
			if ( str_side == "left_" )
			{
				str_side = "right_";
			}
			else
			{
				str_side = "left_";
			}
			
			ai_climber thread ai::force_goal( a_nodes[i], 64, true, undefined, undefined, true );
			
			wait RandomFloatRange( 0.05, 0.15 );
		}
	}
}

function create_array_of_index( n_indexes )
{
	a_indexes = [];
	for ( i = 0; i < n_indexes; i++ )
	{
		if ( !isdefined( a_indexes ) ) a_indexes = []; else if ( !IsArray( a_indexes ) ) a_indexes = array( a_indexes ); a_indexes[a_indexes.size]=i;;
	}
	
	a_indexes = random_shuffle( a_indexes );
	
	return a_indexes;
}

function random_shuffle( a_items ) // this function helps to make sure no repeats
{
	b_done_shuffling = undefined;
	item = a_items[ a_items.size - 1 ];
	
	while ( !( isdefined( b_done_shuffling ) && b_done_shuffling ) )
	{
		a_items = array::randomize( a_items );
		if ( a_items[0] != item )
		{
			b_done_shuffling = true;
		}
		
		wait 0.05;
	}
	
	return a_items;
}

function sky_bridge_robot_swarm()
{	
	const n_swarm_animations = 13; // can probably increase this if it doesn't dip framerate
	
	level waittill( "robot_swarm" );
	
	level thread robot_swarm_continue();
	
	ai_robot = spawner::simple_spawn_single( "robot_swarm_t2" );
	ai_robot.script_string = "sky_bridge_swarm";
	
	a_indexes = create_array_of_index( n_swarm_animations );
	for ( i = 0; i < a_indexes.size; i++ )
	{
		ai_climber = spawner::simple_spawn_single( "sb_forced_level_2" );
		ai_climber.script_string = "sky_bridge_swarm";
		s_climb_bundle = struct::get( "sb_fast_climb_swarm_" + a_indexes[i] );
		ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_climbinfast_robot01" );
		
		wait RandomFloatRange( 0.05, 0.15 );
	}
	
	const n_connection_cimbers = 2;
	for ( i = 0; i < n_connection_cimbers; i++ )
	{
		ai_climber = spawner::simple_spawn_single( "sb_forced_level_2" );
		ai_climber.script_string = "sky_bridge_swarm";
		s_climb_bundle = struct::get( "sb_fast_climb_swarm_connect_" + i );
		ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_climbinfast_robot01" );
		
		wait RandomFloatRange( 0.05, 0.15 );
	}
	
	level notify( "robot_swarm_continue" );
}

function robot_swarm_continue()
{
	level endon( "vtol_crash_start" );
	
	const n_swarm_animations = 13; // can probably increase this if it doesn't dip framerate
	
	level waittill( "robot_swarm_continue" );
	
	a_indexes = create_array_of_index( n_swarm_animations );
	n_index_counter = 0;
	
	while ( true )
	{
		a_robots = GetAIArray( "sky_bridge_swarm", "script_string" );
		if ( a_robots.size < n_swarm_animations )
		{
			ai_climber = spawner::simple_spawn_single( "sb_forced_level_2" );
			ai_climber.script_string = "sky_bridge_swarm";
			s_climb_bundle = struct::get( "sb_fast_climb_swarm_" + a_indexes[n_index_counter] );
			ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_climbinfast_robot01" );
			
			n_index_counter++;
		
			if ( n_index_counter == a_indexes.size )
			{
				a_indexes = random_shuffle( a_indexes );
				n_index_counter = 0;
			}
		}
		
		wait 0.05;
	}
}

// self == robot
function animation_robot_climb( s_climb_bundle, str_animation )
{
	self endon( "death" );
	
	self rogue_control_ignore_players( true );
	self animation::play( str_animation, s_climb_bundle );
	self rogue_control_ignore_players( false );
}

//*****************************************************************************
// SKY BRIDGE2
//*****************************************************************************
function sky_bridge2_main( str_objective, b_starting )
{
	if ( b_starting )
	{
		level.ai_hendricks = util::get_hero( "hendricks" );
		skipto::teleport_ai( str_objective );
		
		lotus_util::spawn_funcs_generic_rogue_control();
		
		level scene::init( "p7_fxanim_cp_lotus_mobile_shop_sky02_bundle" );
		level scene::init( "p7_fxanim_cp_lotus_mobile_shop_sky03_break_bundle" );
		
		level thread sky_bridge_rvh_battles( 6, "sky_bridge1_complete", 0.25 );
		level thread sky_bridge_rvh_battles( 7, "sky_bridge1_complete", 0.25 );
		level thread sky_bridge_rvh_battles( 8, "sky_bridge1_complete", 0.25 );
		level thread sky_bridge_rvh_battles( 9, "sky_bridge1_complete", 0.25 );
		
		level flag::wait_till( "first_player_spawned" );
	}
	
	spawner::add_spawn_function_group( "sb_2_shooters", "script_string", &sky_bridge2_robot_shooters );
	spawner::add_spawn_function_group( "sb_wasp", "script_noteworthy", &sky_bridge_wasp );
	
	set_skybridge_destruction_state( "skybridge_event_10-42", "delete" );
	set_skybridge_destruction_state( "skybridge_event_10-42-clip", "delete" );
	set_skybridge_destruction_state( "skybridge_event_10-42_broken", "show" );
	
	spawn_manager::enable( "sm_sky_bridge_2" );
	
	level thread sky_bridge_2_kill_friendly();
	
	trigger::wait_till( "trig_sky_bridge_bottom_0" );
	
	ai_climber = spawner::simple_spawn_single( "sb_1_normal_climber" );
	s_climb_bundle = struct::get( "sb_normal_climb_0" );
	ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_sideclimb_robot02" );
	
	trigger::wait_till( "trig_sb_bottom_climb_0" );
	
	ai_climber = spawner::simple_spawn_single( "sb_1_normal_climber" );
	s_climb_bundle = struct::get( "sb_normal_climb_1" );
	ai_climber thread animation_robot_climb( s_climb_bundle, "ch_lot_10_03_skybridge_aie_sideclimb_robot02" );
	
	trigger::wait_till( "trig_sb_2_retreat" );
	
	a_robots = GetAIArray( "sb_2_shooters", "script_string" );
	e_volume = GetEnt( "vol_sb_2_retreat", "targetname" );
	foreach ( ai_robot in a_robots )
	{
		ai_robot SetGoal( e_volume, true );
	}
	
	trigger::wait_till( "sky_bridge2_complete" );
	skipto::objective_completed( "sky_bridge2" );
}

// self == robot
function sky_bridge2_robot_shooters()
{
	self endon( "death" );
	
	a_friendlies = GetAIArray( "friendly_vtol_crew_ai", "targetname" );
	foreach ( ai_friendly in a_friendlies )
	{
		self SetEntityTarget( ai_friendly );
	}
}

// self == wasp
function sky_bridge_wasp()
{
	self.team = "team3";
	
	a_friendlies = GetAIArray( "friendly_vtol_crew_ai", "targetname" );
	foreach ( ai_friendly in a_friendlies )
	{
		self SetEntityTarget( ai_friendly );
	}
}

function sky_bridge_2_kill_friendly()
{
	trigger::wait_till( "trig_sb2_friendly_move" );
	
	a_friendlies = GetAIArray( "friendly_vtol_crew_ai", "targetname" );
	foreach ( ai_friendly in a_friendlies )
	{
		ai_friendly.overrideActorDamage = &sb2_friendly_damage_override;
	}
}

// self == friendly
function sb2_friendly_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	n_damage = self.health;
	
	return n_damage;
}

function sky_bridge2_done( str_objective, b_starting, b_direct, player )
{
}

//===========================================
// SKYBRIDGE01 KABOOM
//===========================================
function skybridge01_kaboom()
{
	exploder::exploder( "fx_sky_bridge_exp1" );
	array::run_all( level.players, &PlayRumbleOnEntity, "artillery_rumble" );
	custom_traversals_on_off( "skybridge01_custom_traversal", false );
}


//===========================================
// FLYBY
//===========================================


function flyby_vtols()
{
	level endon( "end_flyby_vtols" );
	
	level.veh_flyby_vtol_ea = GetEnt( "skybridge_flyby_vtol_ea", "targetname" );
	level.veh_flyby_vtol_nrc = GetEnt( "skybridge_flyby_vtol_nrc", "targetname" );

	// opening flyby as player steps onto the ledge
	//
	
	t_bodyfall = GetEnt( "body_fall_trigger", "targetname" );
	v_quake_origin = t_bodyfall GetOrigin(); // get early b/c trigger deletes itself
	t_bodyfall waittill( "trigger" );
	
	nd_chaser = GetVehicleNode( "skybridge_flyby_vtol_opening_chaser_start", "targetname" );
	nd_chased = GetVehicleNode( "skybridge_flyby_vtol_opening_chased_start", "targetname" );
	e_chaser = level.veh_flyby_vtol_ea;
	e_chased = level.veh_flyby_vtol_nrc;
	e_chaser AttachPath( nd_chaser );
	e_chaser StartPath();
	wait 0.5;
	Earthquake( 0.45, 0.75, v_quake_origin, 256.0 ); // shake from close flyby of the trigger area
	foreach ( player in level.players )
	{
		player PlayRumbleOnEntity( "grenade_rumble" );
	}
	wait 1.0;
	e_chased AttachPath( nd_chased );
	e_chased StartPath();
	wait 0.5;
	Earthquake( 0.45, 0.75, v_quake_origin, 256.0 ); // shake from close flyby of the trigger area
	foreach ( player in level.players )
	{
		player PlayRumbleOnEntity( "grenade_rumble" );
	}
	
	e_chaser waittill( "reached_end_node" );

	// ambient flybys from now on
	//
		
	delay_between_flybys = RandomFloatRange( 3.0, 5.0 );
	
	while( true )
	{
		// randomly choose from the set of flyby paths-pairs
		n_flyby_path = RandomIntRange( 1, 3 + 1 );
		nd_chaser = GetVehicleNode( "skybridge_flyby_vtol_" + n_flyby_path + "_chaser_start", "targetname" );
		nd_chased = GetVehicleNode( "skybridge_flyby_vtol_" + n_flyby_path + "_chased_start", "targetname" );

		// decide whether to play EA vtol, NRC vtol, EA chasing NRC, or NRC chasing EA
		n_flyby_type = RandomInt( 1 );
		switch( n_flyby_type )
		{
			case 0:
				e_chaser = level.veh_flyby_vtol_ea;
				e_chased = level.veh_flyby_vtol_nrc;
				break;
			case 1:
				e_chaser = level.veh_flyby_vtol_nrc;
				e_chased = level.veh_flyby_vtol_ea;
				break;
			case 2:
				e_chaser = level.veh_flyby_vtol_ea;
				e_chased = undefined;
				break;
			case 3:
				e_chaser = level.veh_flyby_vtol_nrc;
				e_chased = undefined;
				break;
		}

		e_chaser AttachPath( nd_chaser );
		e_chaser StartPath();
		
		wait RandomFloatRange( 1.0, 1.5 ); // delay between chased and chaser
		
		if( isdefined( e_chased ) )
		{
			e_chased AttachPath( nd_chased );
			e_chased StartPath();
		}
		
		e_chaser waittill( "reached_end_node" );
		
		wait delay_between_flybys;
		delay_between_flybys = RandomFloatRange( 3.0, 5.0 );
	}

}

//===========================================
// UTILITIES
//
//===========================================
function custom_traversals_on_off( str_node_name, b_link )
{
	a_traversal_stars = GetNodeArray( str_node_name, "targetname" );
	foreach( nd_start in a_traversal_stars )
	{
		if( b_link )
		{
			LinkTraversal( nd_start );
		}
		else
		{
			UnlinkTraversal( nd_start );
		}
	}
}
