#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_glasses;
#include maps\_vehicle;
#include maps\_fire_direction;
#include maps\_dialog;
#include maps\_quadrotor;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

// Max number of friendly quads
// This covers how many spawn, reinforce, and damage modification to terrorists
#define ALLIED_QUADROTOR_COUNT 8

/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	//drone controller
	flag_init( "drones_online" );
	
	flag_init( "drone_control_skip_setup" );//skipto
		
	//event flags
	flag_init( "drone_control_started" );
	flag_init( "drone_control_lost" );
	flag_init( "drone_control_alley_entered" ); // set by trigger
	flag_init( "drone_control_alley_building_entered" ); // set by trigger - controls whether spawner is active
	flag_init( "drone_control_alley_building_alley_triggered" ); // set by trigger - controls inside building spawns
	flag_init( "drone_control_guantlet_started" ); // this flag is set by trigger trig_dc_enter_gauntlet
	flag_init( "drone_control_farmhouse_started" ); // set by trig_dc_guantlet_to_outskirts
	flag_init( "drone_control_farmhouse_reached" ); // set by trigger
	flag_init( "drone_control_farmhouse_cleanup" ); // set by trigger
	flag_init( "drone_control_right_path_started" ); // set by trigger
	flag_init( "drone_control_left_path_started" ); // set by trigger
	flag_init( "hijacked_cliffside_firefight" ); // sets firefight across the canyon
	flag_init( "drone_control_player_override" ); // multiplay player damage on street
	flag_init( "player_shot_terrorist" ); // for kill with drones challenge
}
	
	
//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "gauntlet_terrorist", "script_noteworthy", ::drone_control_terrorist_spawnfunc );
	add_spawn_function_group( "farmhouse_terrorist", "script_noteworthy", ::drone_control_terrorist_spawnfunc );
	add_spawn_function_group( "pathchoice_terrorist", "script_noteworthy", ::drone_control_terrorist_spawnfunc );
	add_spawn_function_group( "crossover_terrorist", "script_noteworthy", ::drone_control_terrorist_spawnfunc );
	
	add_spawn_function_veh( "allied_quadrotor", ::drone_control_allied_quadrotor_spawnfunc );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_drone_control()
{
	skipto_teleport( "skipto_drone_control_player" );
	
	init_hero_startstruct( "sp_salazar", "skipto_drone_control_salazar" );

	load_gump( "yemen_gump_outskirts" );
	
	switch_player_to_mason();
	drone_control_skipto_setup();
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Drone Control" );
	#/
	
//NOTE: color groups are set up so that Salazar is across the gauntlet from you at all times		
		
	autosave_by_name( "drone_control_start" );
	
	flag_set("drone_control_started");
	flag_set( "morals_rail_done" ); // make sure breadcrumb updates if not doing morals rail
	   
	//-- Get Salazar into position by manually using the color trigger
	trigger_use("trig_drone_control_color_alley_start");
	
	level thread vo_drone_control();
	drone_control_setup();
//	level.player say_dialog( "sept_medivac_harper_to_th_0" );
	//skipto
	if( !flag( "drone_control_skip_setup" ) )
	{
	   	drone_control_go();
	}
}



/* ------------------------------------------------------------------------------------------
	SETUP
-------------------------------------------------------------------------------------------*/

drone_control_skipto_setup()
{
	path_start = GetVehicleNode( "drone_control_quadrotors_enter_guantlet_spline", "targetname" );
	
	for( i=0; i < ALLIED_QUADROTOR_COUNT; i++ )
	{
		quad = maps\_vehicle::spawn_vehicle_from_targetname( "allied_quadrotor" );
		quad thread maps\_quadrotor::quadrotor_set_team( "allies" );
		quad.goalradius = 450;
	}
}

// self = quadrotor
_switch_node_think()
{
    self endon( "death" );
    self waittill( "reached_end_node" );
        
    while ( 1 )
    {
        self waittill( "switch_node" );
        
        switch_node_name = self.currentNode.script_string;        
        self.switchNode = GetVehicleNode( switch_node_name, "targetname" );
        self SetSwitchNode( self.nextNode, self.switchNode );
    }    
}

drone_control_setup()
{
	level notify( "start_drone_control_canopies" );
	
	maps\createart\yemen_art::alleyway();
	
	level thread drone_control_cleanup();
	level thread maps\yemen_capture::outskirts_fall_death();
	level thread drone_control_ambient_fx();
	drone_control_setup_threat_bias();
}

/*-----------------------------------------------------------------------------
 * Setup threat bias - so player has to fight
 * We want quadrotors to engage upper enemies more than lower
 * We want all enemies to prefer to engage the player more than the quadrotors
 * ***************************************************************************/
drone_control_setup_threat_bias()
{
	CreateThreatBiasGroup( "upper_terrorists" );
	CreateThreatBiasGroup( "lower_terrorists" );
	CreateThreatBiasGroup( "quadrotors" );
	CreateThreatBiasGroup( "player" );
	
	change_threat_bias( -10000, -10000, -10000, -10000, 100000, 100000 );
	
	level.player SetThreatBiasGroup( "player" );
}

/*-----------------------------------------------------------------------------
 * Change threat bias
 * Mandatory: threat bias
 * ***************************************************************************/
change_threat_bias( n_qr_to_upper, n_qr_to_lower, n_upper_to_qr, n_lower_to_qr, n_upper_to_player, n_lower_to_player )
{
	SetThreatBias( "upper_terrorists", 		"quadrotors", 				n_qr_to_upper );
	SetThreatBias( "lower_terrorists", 		"quadrotors", 				n_qr_to_lower );
	SetThreatBias( "quadrotors", 			"upper_terrorists",			n_upper_to_qr );
	SetThreatBias( "quadrotors", 			"lower_terrorists", 		n_upper_to_player );
	SetThreatBias( "player", 				"upper_terrorists", 		n_lower_to_qr );
	SetThreatBias( "player", 				"lower_terrorists", 		n_lower_to_player );
}

// self = guy
drone_control_terrorist_spawnfunc()
{	
	self.overrideActorDamage = ::terrorist_shot_callback;
	self SetThreatBiasGroup( "upper_terrorists" );
}

// self = guy
drone_control_lower_spawnfunc()
{	
	self.overrideActorDamage = ::terrorist_shot_callback;
	self SetThreatBiasGroup( "lower_terrorists" );
}

// self = quadrotor
drone_control_allied_quadrotor_spawnfunc()
{	
	self thread maps\_quadrotor::quadrotor_set_team( "allies" );
	self veh_magic_bullet_shield( true );
}

//quadrotor_reinforce()
//{
//	level endon( "drone_control_lost" );
//	
//	while( 1 )
//	{
//		a_vh_quads = GetEntArray( "allied_quadrotor", "targetname" );
//		
//		if( a_vh_quads.size < 8 )
//		{
//			vh_quadrotor = maps\_vehicle::spawn_vehicle_from_targetname( "allied_quadrotor" );
//			vh_quadrotor.origin = level.player.origin + (RandomIntRange( -128, -64 ), RandomIntRange( -128, 128), RandomIntRange( 128, 256 ) );
//			maps\_fire_direction::add_fire_direction_shooter( vh_quadrotor );
//			vh_quadrotor SetThreatBiasGroup( "quadrotors" );
//		}
//		
//		wait .2;
//	}
//}

// Make quadrotos move into front of player
drone_control_quadrotors_move_to_player_look_position_test()
{
	level endon( "drone_control_lost" );
	
	while( true )
	{
		v_eye_pos = level.player GetEye();	
		v_player_eye = level.player GetPlayerAngles();
		v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
		v_trace_to_point = v_eye_pos + ( v_player_eye * 1028 );
		a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
		v_movepoint = a_trace["position"];
		
		a_qrotors = GetEntArray( "allied_quadrotor", "script_noteworthy" );
		
		foreach( veh_qrotor in a_qrotors )
		{
			veh_qrotor defend( v_movepoint, 400 );
		}
		
		wait .5; 
	}
}

drone_control_ambient_fx()
{
	flag_wait( "drone_control_gauntlet_started" );
	
	stop_exploder( 1030 );
	exploder( 1040 );
	
	maps\createart\yemen_art::market_2();
}

/*------------------------------------------------------------------------------
 * Controls threat to player in first area of drone control
 * Overrides damage taken on street
 * Enables turret when player is on street
 * ***************************************************************************/
drone_control_threat_control_think()
{	
	level endon( "drone_control_farmhouse_started" ); // end this on next secion
	
	t_street_trig = GetEnt( "trig_drone_control_street_exposed", "targetname" );
	e_turret = GetEnt( "guantlet_turret", "targetname" );

	while( 1 )
	{
		t_street_trig trigger_wait();
		
		flag_set( "drone_control_player_override" );
		
		// turret targets player when exposed
		// it doesn't target other units
		// it is inactive when player is not on the street
		e_turret maps\_turret::enable_turret();
		e_turret maps\_turret::set_turret_target_flags( TURRET_TARGET_PLAYERS );
	
		while( level.player IsTouching( t_street_trig ) )
		{
			wait .25;
		}
		
		e_turret maps\_turret::disable_turret();
		
		flag_clear( "drone_control_player_override" );
	}
}

/* ------------------------------------------------------------------------------------------
	DAMAGE CALLBACKS
-------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------
 * Controls damage taken by player when in street
 * ****************************************************************************/
drone_control_player_damage_callback( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	if( flag( "drone_control_player_override" ) )
	{
		n_damage = Int( n_damage * 2 ); // 2x damage
	}
	if( IsDefined( e_attacker.script_noteworthy ) && e_attacker.script_noteworthy == "allied_quadrotor" )
	{
		n_damage = Int( n_damage / 2 ); // half damage
	}
	
    return n_damage;
}

/*------------------------------------------------------------------------------------------------------------
 * Stops allies from owning the terrorists because we have a badass weapon already
 * Sets flag - player_shot_terrorist tracks if player has fired on terrorists or not, if he has he fails challenge
 * Divide quadrotor damage to terrorist by # of quadrotor allies
 * **********************************************************************************************************/
terrorist_shot_callback( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if( isDefined( eAttacker ) && isPlayer( eAttacker) )
	{
		if( !flag( "player_shot_terrorist" ) )
		{
			flag_set( "player_shot_terrorist" ); // if flag is set player fails challenge
		}
	}
		
	return iDamage;
}

/* ------------------------------------------------------------------------------------------
	CLEANUP
-------------------------------------------------------------------------------------------*/

// controls cleanup of everything in this event
drone_control_cleanup()
{
	// Clean up previous quadrotors so I can control where they come in exactly
	a_vh_morals_rail_quadrotors = GetEntArray( "allied_quadrotor", "targetname" );
	
	foreach( vh_quad in a_vh_morals_rail_quadrotors )
	{
		VEHICLE_DELETE( vh_quad );
	}
	
	flag_wait( "drone_control_alley_entered" );
	
	a_vh_morals_rail_vtols = GetEntArray( "yemen_drone_control_vtol_spawner", "targetname" );
	
	 foreach( vh_vtol in a_vh_morals_rail_vtols )
	 {
	 	VEHICLE_DELETE( vh_vtol );
	 }
	  
	a_vh_morals_rail_vtols = GetEntArray( "yemen_morals_rail_vtol_spawner", "targetname" );
	
	foreach( vh_vtol in a_vh_morals_rail_vtols )
	{
		VEHICLE_DELETE( vh_vtol );
	}
	
	flag_wait( "drone_control_farmhouse_started" );
	
	maps\createart\yemen_art::outdoors();
	
	level thread quadrotors_go_spline_then_ai( "drone_control_transition_spline" );
	
	e_turret = GetEnt( "guantlet_turret", "targetname" );
	
	// guantlet street
	flag_clear( "drone_control_player_override" );
	e_turret disable_turret();
	spawn_manager_kill( "trig_gauntlet_upper_terrorists" );
	spawn_manager_kill( "trig_gauntlet_upper_terrorists2" );
	spawn_manager_kill( "trig_gauntlet_upper_terrorists3" );
	wait .2; // be sure spawn managers are dead
	a_ai_gauntlet_guys = get_ai_array( "gauntlet_terrorist", "script_noteworthy" );
	array_delete( a_ai_gauntlet_guys );
	
	flag_wait( "drone_control_farmhouse_cleanup" );
	
	spawn_manager_kill( "farmhouse_terrorist_roof_trig" );
	wait .1; // make sure spawn manager is dead
	a_ai_farm_guys = get_ai_array( "farmhouse_terrorist", "script_noteworthy" );
	array_delete( a_ai_farm_guys );
	
	flag_wait( "cleanup_pathchoice" );
	
	a_ai_path_guys = get_ai_array( "pathchoice_terrorist", "script_noteworthy" );
	array_delete( a_ai_path_guys );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

drone_control_go()
{
	level.salazar = GetEnt( "sp_salazar_ai", "targetname" );
	
	level.salazar change_movemode( "sprint" );
	level.salazar.radius = 128;
	
	drone_control_alley_go();
	drone_control_gauntlet_go();
	
	flag_wait( "drone_control_farmhouse_started" ); // set in radiant

	level.salazar set_force_color( "b" );
	
	drone_control_farmhouse_go();
	drone_control_splitpath_go();
}

//1st area
drone_control_alley_go()
{	
	flag_wait( "drone_control_alley_entered" );
	
	spawn_quadrotors( ALLIED_QUADROTOR_COUNT, "drone_control_quadrotors_enter_guantlet_spline", "allied_quadrotor" );
	
//	level thread drone_control_alley_qrotor_start();
	
	setmusicstate("YEMEN_MASON_KICKS_ASS");
	
	//Audio - snapshot lower's ambient sound
	level ClientNotify ("mbs");
	
	
	level.player maps\_fire_direction::init_fire_direction();
	
	drone_control_morals_rail_vtol_go();
	drone_control_alley_start_control();
}

drone_control_alley_qrotor_start()
{
	play_bink_on_hud("yemen_drone_cam");
	level.player maps\_fire_direction::init_fire_direction();
}

//2nd area
drone_control_gauntlet_go()
{
	level.player.overridePlayerDamage = ::drone_control_player_damage_callback;
	
	a_morals_actors = GetEntArray( "morals_actor", "script_noteworthy" );
	array_delete( a_morals_actors );
	
	level.salazar set_force_color( "c" ); // new guantlet street colors for Salazar
	setup_allied_quadrotors();
	level thread allied_quadrotor_control();
	level thread drone_control_quadrotors_move_to_player_look_position_test();
//	drone_control_gauntlet_magic_rpgs();
	drone_control_gauntlet_ambience();
	
	level clientNotify("snd_canyon_wind");
	
	flag_wait( "drone_control_guantlet_started" );
	
	level thread drone_control_quadrotor_sounds();
	level thread drone_control_threat_control_think(); // modify damage if on street
}

// sets up quadrotors
setup_allied_quadrotors()
{
	a_vh_quads = GetEntArray( "allied_quadrotor", "targetname" );
	
	foreach( vh_quad in a_vh_quads )
	{
		vh_quad SetThreatBiasGroup( "quadrotors" );
		maps\_fire_direction::add_fire_direction_shooter( vh_quad );
		vh_quad drone_control_allied_quadrotor_spawnfunc();
	}
}

//3rd area
drone_control_farmhouse_go()
{
	spawn_vtols_at_structs( "s_dc_farmhouse_first_vtol_left" );
}

//4th area - has two parts: left/right
drone_control_splitpath_go()
{
	level thread drone_control_splitpath_cliffside_ambient();
	level thread drone_control_do_ambient_crossover();
}

drone_control_morals_rail_vtol_go()
{
	veh_vtol = GetEnt( "yemen_morals_rail_vtol_spawner", "targetname" );
	
	nd_vtol_start = GetVehicleNode( "nd_drone_control_vtol_start", "targetname" );
}

//start ability to control drones
drone_control_alley_start_control()
{
	level thread drone_cam_pip_sounds();
	screen_message_create( &"YEMEN_DRONES_ONLINE" );
	
	level thread play_bink_on_hud("yemen_drone_cam");
	
	screen_message_delete();
	
	flag_set("drones_online");
	
//	level thread quadrotor_reinforce();
}

drone_control_gauntlet_magic_rpgs()
{
	flag_wait( "drone_control_guantlet_started" );
	
	level thread spawn_vtols_at_structs( "s_dc_gauntlet_middle_vtol" );
	
	drone_control_fire_magic_rpgs_at_target( "s_drone_control_rpg_magicbullet_guy", "s_drone_control_rpg_magicbullet_guy_target" );
	
	wait 1;//waiting for vtol to progress a bit
	
	level thread drone_control_fire_magic_rpgs_at_target( "s_drone_control_rpg_magicbullet", "s_drone_control_rpg_magicbullet_target" );
}

//starts ambient looping vtols based on trigger looks - they stop on flag( "drone_control_farmhouse_started" )
drone_control_gauntlet_ambience()
{
	level thread drone_control_do_ambient_vtols( "trig_look_dc_guantlet_right_first_vtol_spawn", "s_dc_gauntlet_right_vtol", undefined, "drone_control_farmhouse_started" );
	level thread drone_control_do_ambient_vtols( "trig_look_dc_guantlet_right_second_vtol_spawn", "s_dc_gauntlet_right_second_vtol", undefined, "drone_control_farmhouse_started" );
	level thread drone_control_do_ambient_quadrotors();
}

//Drone control off
drone_control_drones_offline()
{
	screen_message_create( &"YEMEN_DRONES_OFFLINE" );
	
	flag_clear("drones_online");
	
	flag_set( "drone_control_lost" );

	level.player maps\_fire_direction::_fire_direction_kill();
	
	level thread qr_drones_fly_away();
	
	vo_drones_offline();
	
	//Eckert - Play pip sounds
	level thread drone_cam_pip_sounds();
	
	play_bink_on_hud("yemen_kill_pilot");
	
	screen_message_delete();
	
	autosave_by_name( "drone_control_lost_drones" );
}

/* ------------------------------------------------------------------------------------------
	QUADROTORS
-------------------------------------------------------------------------------------------*/

/*__________________________________________________________________
 * Spawns quadrotors
 * Mandatory: number of quads, start node, spawner targetname
 * *****************************************************************/
spawn_quadrotors( n_count, str_nd_start, str_spawner )
{	
	path_start = GetVehicleNode( str_nd_start, "targetname" );
	offset = (30, 0, 0);
	
	for( i=0; i < n_count; i++ )
	{
		quad = maps\_vehicle::spawn_vehicle_from_targetname( str_spawner );
		quad maps\_quadrotor::quadrotor_start_scripted();
		wait 0.1;	// allow the state to change to scripted
		quad SetVehicleAvoidance( false );
		quad maps\_vehicle::getonpath( path_start );
		quad.drivepath = true;
		offset_scale = get_offset_scale( i );
		
		quad PathFixedOffset( offset * offset_scale );
		quad thread maps\_vehicle::gopath();
		quad thread maps\yemen_hijacked::activate_ai_on_end_path();
		quad thread quadrotor_speedmatch_player();
		
		wait RandomFloatRange( .55, .75 );
	}
}

quadrotors_go_spline_then_ai( str_nd_start )
{	
	path_start = GetVehicleNode( str_nd_start, "targetname" );
	a_vh_quds = GetEntArray( "allied_quadrotor", "script_noteworthy" );
	
	offset = (30, 0, 0);
	
	foreach( quad in a_vh_quds )
	{
		quad maps\_quadrotor::quadrotor_start_scripted();
		wait 0.1;	// allow the state to change to scripted
		quad SetVehicleAvoidance( false );
		quad maps\_vehicle::getonpath( path_start );
		quad.drivepath = true;
		quad veh_magic_bullet_shield( true );
		quad PathFixedOffset( offset );
		quad thread maps\_vehicle::gopath();
		quad thread maps\yemen_hijacked::activate_ai_on_end_path();
		quad veh_magic_bullet_shield( true );
		wait RandomFloatRange( .55, .6 );
	}
}

// Self = quadrotor
quadrotor_speedmatch_player()
{
	level endon( "drone_control_guantlet_started" );
	self endon( "reached_end_node" );
	self endon( "death" );
	
	while( 1 )
	{
		n_dist = Distance2D( level.player.origin, self.origin );
		n_dot = level.player get_dot_direction( self.origin, true, true, "forward", true );
		
		if( n_dot <= .15 )
		{
			self SetSpeed( 20, 30, 30 ); // speed up
		}
		else
		{
			if( n_dist > 460 )
			{
				self SetSpeed( 15, 8, 8 ); // slow down
			}
			else
			{
				self SetSpeed( 18, 10, 10 ); // speed up
			}
		}
		
		wait .05;
	}
}

#define QR_OFFSET 4
// Runs drone control specific logic on quadrotors
allied_quadrotor_control()
{
	level endon( "drone_control_lost" );
	
	while( true )
	{
		v_movepoint = _get_player_look_position();
		a_qrotors = GetEntArray( "allied_quadrotor", "script_noteworthy" );
		
		foreach( veh_qrotor in a_qrotors )
		{
			veh_qrotor.goalpos = v_movepoint;
			veh_qrotor.custom_target_offset = ( RandomFloatRange( -QR_OFFSET, QR_OFFSET ), RandomFloatRange( -QR_OFFSET, QR_OFFSET ), RandomFloatRange( -QR_OFFSET, QR_OFFSET ) );
		}
		
		wait .4;
	}
}

_get_player_look_position()
{
	v_eye_pos = level.player GetEye();	
	v_player_eye = level.player GetPlayerAngles();
	v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
	v_trace_to_point = v_eye_pos + ( v_player_eye * 128 );
	a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
	v_movepoint = a_trace["position"];
}

/* ------------------------------------------------------------------------------------------
	AMBIENT
-------------------------------------------------------------------------------------------*/

//shoot rpgs from stuct to struct
drone_control_fire_magic_rpgs_at_target( str_s_rpgs_name, str_s_rpg_target )
{
	a_rpgs = GetStructArray( str_s_rpgs_name, "targetname" );
	s_target = GetStruct( str_s_rpg_target, "targetname" );
	
	foreach( s_rpg in a_rpgs )
	{
		MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_target.origin );
		
		wait RandomFloatRange( .5, 1 );//stagger fire
	}
}
	
//spawns ambient vtol with trigger
drone_control_do_ambient_vtols( str_trig_name, str_struct, str_nd_name, str_flag_name )
{	            
	if( IsDefined( str_flag_name ) )
	{
		while( !flag( str_flag_name ) )
		{
			trigger_wait( str_trig_name );
		
			spawn_vtols_at_structs( str_struct, str_nd_name );
		}
	}
	
	else
	{
		trigger_wait( str_trig_name );
	
		spawn_vtols_at_structs( str_struct, str_nd_name );
	}
}

//Ambient shooting on cliffside
//TODO: make this good
drone_control_splitpath_cliffside_ambient()
{
	level endon( "fxanim_bridge_explode_start" );
	            
	s_gun1 = GetStruct( "s_hijacked_cliffside_magicbullet_gun1", "targetname" );
	s_gun1_target = GetStruct( s_gun1.target, "targetname" );
	s_gun2 = GetStruct( "s_hijacked_cliffside_magicbullet_gun2", "targetname" );
	s_gun2_target = GetStruct( s_gun2.target, "targetname" );
	s_gun3 = GetStruct( "s_hijacked_cliffside_magicbullet_gun3", "targetname" );
	s_gun3_target = GetStruct( s_gun3.target, "targetname" );
	
	while( true )
	{
		for ( i = 0; i < 60; i++ )
			{
				MagicBullet( "mp7_sp", s_gun1.origin, s_gun1_target.origin );
				MagicBullet( "mp7_sp", s_gun2.origin, s_gun2_target.origin );
				MagicBullet( "mp7_sp", s_gun3.origin, s_gun3_target.origin );
					
				wait 0.1;
			}
		
		wait 0.5;
	}
}

drone_control_do_ambient_quadrotors()
{
	while( !flag( "drone_control_farmhouse_reached" ) )
	{
		level endon( "drone_control_farmhouse_reached" );
		
		level thread maps\yemen_capture:: capture_spawn_fake_qrotors_at_structs_and_move( "s_dc_gauntlet_right_fake_quadrotors_first", RandomIntRange( 5, 6 ) );
		
	    wait RandomFloatRange( 1, 3 );
	}
}

drone_control_do_ambient_crossover()
{
	level endon( "drone_control_lost" );
		
	level thread maps\yemen_capture:: capture_spawn_fake_qrotors_at_structs_and_move( "s_dc_gauntlet_right_pathchoice_crossover", RandomIntRange( 1, 3) );
}

/* ------------------------------------------------------------------------------------------
	VO functions
-------------------------------------------------------------------------------------------*/
vo_drone_control()
{
	level.player thread say_dialog( "sala_command_salazar_on_0" );			// SALAZAR: Command.  Salazar on Primary SAT. New frontline trace is phase line ORANGE.  Multiple EAGLES down -request immediate MEDEVAC LZ SPARROW.
	
	flag_wait( "drone_control_alley_entered" );
	
	level thread vo_drone_control_intro();	
	level thread vo_vtol_pilot_intro();
	
	flag_wait( "drone_control_guantlet_started" );
	
	level.player thread say_dialog( "sala_rpgs_on_the_rooftops_0" );		// SALAZAR: Rpgs on the rooftops!
	
	level thread vo_guantlet_left_balcony_rpg();
	level thread vo_killzone();
	level thread vo_choose_left_path();
	level thread vo_choose_right_path();
	level thread vo_farmhouse_intro();
	level thread vo_pathchoice_hold();
//	temp_vo_func();
}

vo_hint_standing_by_for_targets()
{
		level endon( "drone_control_lost" );
		
		wait 5;
		 
		while( true )
		{
			wait RandomIntRange( 10, 16 );
			
			if( level.player HasWeapon( "data_glove_sp" ) )
			{	
				if( flag( "fire_direction_shader_on" ) )
				{
					level.player thread say_dialog( "vtol_standing_by_for_targ_0" );			// Standing by for targets.
				}
			}
		}
}

vo_drone_control_intro()
{
	level.player say_dialog( "sect_command_we_need_th_0" );					// SECTION: Command - We need the downlink code to assume OPCON of the Drone fleet in support of capture of Menendez.
	level.player say_dialog( "comm_sending_codes_to_you_0" );				// COMMAND: Sending codes to your display, drones re-tasked to your objective.
	level.player say_dialog( "vtol_drone_targeting_cont_0" );				// VTOL PILOT: (over radio) Drone targeting control - Manual override engaged.
	level.player thread say_dialog( "vtol_standing_by_for_targ_0" );		// Standing by for targets.
	
//	level.player say_dialog( "sept_command_i_m_going_a_0" );				// Command, I’m going after Menendez.  I need access to our Drone Targeting control.
}

vo_vtol_pilot_intro()
{
	level.player say_dialog( "vtol_hud_relay_systems_en_0" );				// VTOL PILOT: - (over radio) - HUD relay systems enacted.
}

vo_guantlet_left_balcony_rpg()
{
	level endon( "drone_control_farmhouse_started" );

	flag_wait( "drone_control_guantlet_warn_balc_rpg" );
	wait .34;
	level.player say_dialog( "sala_balcony_left_side_0" );
}

vo_killzone()
{
	level endon( "drone_control_farmhouse_started" );
	
	flag_wait( "drone_control_player_override" );

	level.player say_dialog( "sect_the_whole_street_s_a_0" );				// SECTION: The whole Street’s a kill zone!
}

vo_choose_left_path()
{
	level endon( "drone_control_salazar_takes_left" );
	
	flag_wait( "drone_control_salazar_takes_right" );
	
	level.player say_dialog( "sect_take_the_right_i_v_0" );					// SECTION: Take the right!  I’ve got the left.
}

vo_choose_right_path()
{
	level endon( "drone_control_salazar_takes_right" );
	
	flag_wait( "drone_control_salazar_takes_left" );
	
	level.player say_dialog( "sect_you_take_the_left_0" );					// SECTION: You take the left - I’ll take the right.
}

vo_farmhouse_intro()
{
	level endon( "drone_control_farmhouse_cleanup" );
	
	flag_wait( "drone_control_farmhouse_started" );
	
	level.player say_dialog( "sala_taking_fire_from_the_0" );			// Taking fire from the window!
	
	level.player say_dialog( "sala_menendez_is_headed_f_0" );			// SALAZAR: Menendez is headed for the Citadel, building 61 of the GRG.  Push all available assets to that grid.
	level.player say_dialog( "sala_eyes_on_status_only_0" );			// Eyes on status only!  I say again do not engage the Citadel, we need him alive.
	
	flag_wait( "farmhouse_salazar_warn_building" );
	
	level.player say_dialog( "sala_enemies_in_the_build_0" );			// Taking fire from the window!
}

vo_pathchoice_hold()
{
	level endon( "cleanup_pathchoice" );
	
	flag_wait( "fxanim_falling_rocks_start_kickoff" );
	
	level.player say_dialog( "sect_salazar_hold_your_0" );				// Salazar - Hold your position.
}

temp_vo_func()
{
	// First then wait for a set ammount of time, then remind player
	level.player say_dialog( "VTOL PILOT: - (over radio) - Standing by for targets." );
	level.player say_dialog( "SALAZAR: Mark targets for the drones!" );
	
	// based on player input
	level.player say_dialog( "VTOL PILOT: - (over radio) - Confirm." );
	level.player say_dialog( "VTOL PILOT: - (over radio) - Firing." );
	
	// gauntlet street enter

	level.player say_dialog( "SECTION: Split up - Take the high ground." );
	
	// then
	level.player say_dialog( "SECTION: Go." );
	
	// SALAZAR threat callouts
	level.player say_dialog( "SALAZAR: (over radio) More RPGs - Left side, high!" );
	level.player say_dialog( "SALAZAR: (over radio) More RPGs - Right side, high!" );
	level.player say_dialog( "SALAZAR: (over radio) Rooftop - Right side!" );
	level.player say_dialog( "SALAZAR: (over radio) Rooftop - Left side!" );
	level.player say_dialog( "SALAZAR: (over radio) Right side Balcony!" );
	level.player say_dialog( "SALAZAR: (over radio) Balcony - Left side!" );
	level.player say_dialog( "SALAZAR: (over radio) Ride side window!" );
	level.player say_dialog( "SALAZAR: (over radio) Left side window!" );
	
	// Salazar encourages us to use drones
	level.player say_dialog( "SALAZAR: (over radio) Section!  Use the drones to take out that position!" );
	level.player say_dialog( "SALAZAR: Taking fire from the window!" );
	
	// Salazar encourages us to use drones
	level.player say_dialog( "SALAZAR: (over radio) Section!  Use the drones to take out that position!" );
	level.player say_dialog( "SALAZAR: Taking fire from the window!" );
	
	// Salazar comment successful drone kills
	level.player say_dialog( "SALAZAR: Good kill." );
	level.player say_dialog( "SALAZAR: Drone kill confirmed." );
	level.player say_dialog( "SALAZAR: Target destroyed." );
	
	// Salazar Mountain road
	level.player say_dialog( "SALAZAR: (into radio) All stations this net, HVI is located building 6.1.  Establish blocking positions cutting off escape." );
	level.player say_dialog( "SALAZAR: (into radio) Eyes on status only!  I say again do not engage the Citadel, we need him alive." );
	
	// Interface VO
	level.player say_dialog( "INTERFACE: Link Established." );
	level.player say_dialog( "INTERFACE: Drone Control Online." );
	level.player say_dialog( "INTERFACE: Targeting." );
	level.player say_dialog( "INTERFACE: Target Confirmed." );
	level.player say_dialog( "INTERFACE: Attacking." );
	level.player say_dialog( "INTERFACE: Firing." );
	level.player say_dialog( "INTERFACE: Control Offline." );
	level.player say_dialog( "INTERFACE: System Error." );
	level.player say_dialog( "INTERFACE: Link Terminated." );
}

/* ------------------------------------------------------------------------------------------
	CHALLENGES
-------------------------------------------------------------------------------------------*/

usenodrone_challenge( str_notify )
{
	level endon( "player_shot_terrorist" );
	
	level waittill( "drone_control_lost" );
	
	if( !flag( "player_shot_terrorist" ) )
	{
		self notify( str_notify );		
	}		
}

/* ------------------------------------------------------------------------------------------
	AUDIO
-------------------------------------------------------------------------------------------*/

// quadrotor countrol audio and vo
drone_control_quadrotor_sounds()
{
	level endon( "drone_control_lost" );
	
	level thread vo_hint_standing_by_for_targets();
	
	while( true )
	{
		flag_wait( "fire_direction_shader_on" );
		
		if( level.player AttackButtonPressed() )
		{
			//C. Ayers
			level thread maps\yemen_amb::play_drone_control_tones_single();
			
			if( RandomIntRange( 1, 3 ) > 2 )
			{
				level.player say_dialog( "vtol_confirm_0" );						// Confirm
				wait RandomFloatRange( .15, .25 ); // vary the wait since it may be heard multiple times
			}
			
			level.player thread say_dialog( "vtol_firing_0" );						// Firing
			
			while( level.player AttackButtonPressed() )
			{
				wait .05;
			}
		}
		
		wait .05;
	}
}

// sounds for bink movie
drone_cam_pip_sounds()
{
	level.sound_pip_ent = spawn( "script_origin", level.player.origin );
	level.player playsound ("evt_pnp_on");
	level.sound_pip_ent playloopsound( "evt_pnp_loop", 1 );
	wait 6;
	level.player playsound ("evt_pnp_off");
	level.sound_pip_ent stoploopsound ();
	level.sound_pip_ent delete();
}
