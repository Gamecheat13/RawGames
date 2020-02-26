#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;
#include maps\_glasses;
#include maps\_vehicle;
#include maps\_osprey;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
	INIT functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	// objective flags
	flag_init( "obj_hijacked_sitrep" );
	
	// events
	flag_init( "hijacked_start" );
	flag_init( "hijacked_stairs_collapse" ); 				// set by trigger
	flag_init( "hijacked_cliffside_building_destroyed" );
	flag_init( "hijacked_rpg_fired" ); 						// american fires rpg
	flag_init( "hijacked_bridge_fell" ); 					// set by trigger
	
	// challenge
	flag_init( "hijacked_environmental" ); 					// set by trigger damage
	
	flag_init( "menendez_hijack_vtol_active" );
}

//	event-specific spawn functions
init_spawn_funcs()
{
	add_spawn_function_group( "hijacked_ally", "script_noteworthy", ::hijacked_allied_spawnfunc );
	add_spawn_function_group( "hijacked_ally_bridge", "script_noteworthy", ::hijacked_allied_bridge_spawnfunc );
	
	add_spawn_function_veh( "hijacked_robot", "script_noteworthy", ::hijacked_hostile_quadrotor_spawnfunc );
	add_spawn_function_veh( "hijacked_bridge_robot", "script_noteworthy", ::hijacked_hostile_quadrotor_spawnfunc );
	add_spawn_function_veh( "hijacked_player_only_quad", "script_noteworthy", ::hijacked_hostile_player_quadrotor_spawnfunc );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_hijacked()
{
	load_gump( "yemen_gump_outskirts" );
	
	skipto_teleport( "s_hijacked_skipto_left_player" );
		
	switch_player_to_mason();
	drone_control_setup();
	
	init_hero_startstruct( "sp_salazar", "s_hijacked_skipto_left_salazar" );
	level thread hijacked_skipto_setup();
}

//at bridge
skipto_hijacked_bridge()
{
	skipto_teleport( "skipto_capture_player" );
	
	switch_player_to_mason();
	drone_control_setup();
	
	init_hero_startstruct( "sp_salazar", "skipto_capture_salazar" );
	
	load_gump( "yemen_gump_outskirts" );
	
	level thread maps\yemen_capture::outskirts_fall_death();
	flag_set( "menendez_hijack_vtol_active" );
}

// capture bink skipto
skipto_hijacked_menendez()
{
//	skipto_teleport( "s_hijacked_skipto_left_player" );
//	maps\yemen_capture::capture_skipto_setup();
//	flag_set( "menendez_hijack_vtol_active" );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions 
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "Event Name" );
	#/
	
		flag_set( "hijacked_start" );
		flag_set( "cleanup_farmhouse" );
		
		// hijacked scene for bink capture
		menendez_hijack_scene_check();
		autosave_by_name( "hijacked_start" );
		
		hijacked_setup();
		level thread vo_hijacked();
		level thread quadrotor_start_rockslide();
		level thread quadrotor_right_foreshadow();
		quadrotor_left_foreshadow();
		level thread terrorists_expose();
		level thread tree_1_sound();
		level thread tree_2_sound();
		level thread hijack_bridge_snapwatch();
		hijacked_drone_control_lost();
		spawn_menendez_vtol();
//		spawn_quadrotor_formation( 4, "hijacked_hostile_formation_spline", "yemen_hijacked_quadrotor_hostile_formation" );
		
		level waittill( "metalstorm_spawned" );
		
		quadrotors_guard_metalstorm();
		
		level waittill( "swap_quadrotors" );
		
		level thread stairs_shoot_stairs_building();
		level thread stairs_building_damage_listener();
		spawn_quadrotor_formation( 7, "hijacked_hostile_formation_bridge_spline", "yemen_hijacked_quadrotor_hostile_bridge_formation" );
		hijacked_bridge_event();
		quadrotors_guard_bridge();
	
		level waittill( "bridge_crossing" );
		
		s_target = GetStruct( "capture_steps_vtol_shoot_spot", "targetname" );
		maps\yemen_capture::vtol_turret_attacks_target( undefined, undefined, 4, s_target.origin );
}

/* ------------------------------------------------------------------------------------------
	SETUP
	***************************************************************************************
-------------------------------------------------------------------------------------------*/
	
hijacked_setup()
{
	level thread hijacked_crash_drone_near_player();
	level thread hijacked_threat_bias_control();
	hijacked_destructibles_setup();
	level thread hijacked_cleanup();
}

// Self = hostile quadrotor
hijacked_hostile_quadrotor_spawnfunc()
{
	self thread maps\_quadrotor::quadrotor_set_team( "axis" );
	self SetThreatBiasGroup( "quadrotors" );
	self.goalradius = 450;
}

// Self = hostile quadrotor
hijacked_hostile_player_quadrotor_spawnfunc()
{
	self set_ignoreme( true );
	self hijacked_hostile_quadrotor_spawnfunc();
}

// self is guy
hijacked_allied_spawnfunc()
{
	self SetThreatBiasGroup( "allies" );
	self magic_bullet_shield();
	
	flag_wait( "drone_control_lost" );
	
	self stop_magic_bullet_shield();
}

// self is guy
hijacked_allied_bridge_spawnfunc()
{
	level endon( "capture_started" );
	
	a_nd_goals = GetNodeArray( "hijacked_bridge_goal", "targetname" );
	nd_goal = Random( a_nd_goals );
	
	self SetThreatBiasGroup( "allies" );
	self change_movemode( "sprint" );
	self set_ignoreme( true );
	self magic_bullet_shield();
	self force_goal( nd_goal );
}

setup_allies()
{

}

// threat bias control
hijacked_threat_bias_control()
{
	level endon( "capture_started" );
	
	salazar = GetEnt( "sp_salazar_ai", "targetname" );
	
	CreateThreatBiasGroup( "allies" );
	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "quadrotors" );
	
	SetThreatBias( "allies", "quadrotors", 10000 );
	SetThreatBias( "quadrotors", "allies", 10000 );
	SetThreatBias( "player", "quadrotors", 10000 );
	
	level.player SetThreatBiasGroup( "player" );
	salazar SetThreatBiasGroup( "player" );
	
	level waittill( "swap_quadrotors" ); // kill quadrotors before building, spawn quadrotors at bridge
	
	SetThreatBias( "allies", "quadrotors", 10000 );
	SetThreatBias( "quadrotors", "allies", 10000 );
	SetThreatBias( "player", "quadrotors", -10000 );
	
	level.player set_ignoreme( true );
}

// setup hijacked events on skipto
hijacked_skipto_setup()
{
	level.player maps\_fire_direction::init_fire_direction();
	hijacked_skipto_quadrotors_init();
	hijacked_skipto_salazar_init();
	level thread maps\yemen_drone_control::allied_quadrotor_control();
	level thread maps\yemen_drone_control::drone_control_quadrotor_sounds();
	level thread maps\yemen_capture::outskirts_fall_death();
}

//	set up allied quadrotors on skipto
hijacked_skipto_quadrotors_init()
{
	maps\yemen_drone_control::drone_control_skipto_setup();
	maps\yemen_drone_control::setup_allied_quadrotors();
	
	a_vh_quadrotors = GetEntArray( "allied_quadrotor", "targetname" );
	
	foreach( vh_quadrotor in a_vh_quadrotors )
	{
		vh_quadrotor.origin = level.player.origin + (RandomIntRange( 34, 128 ), RandomIntRange( 34, 128), RandomIntRange( 34, 128 ));
	}
}

// Give Salazr a random goal so he doesn't run back to his spawn target
hijacked_skipto_salazar_init()
{
	ai_salazar = GetEnt( "sp_salazar_ai", "targetname" );
	a_nd_salazar = GetNodeArray( "nd_hijacked_start_colors", "targetname" );
	nd_start = Random( a_nd_salazar );
	
	ai_salazar thread force_goal( nd_start, 32, false, undefined, true );
}

allied_quadrotors_move_ahead_and_delete()
{
	s_goal = GetStruct( "s_hijacked_hostile_qrotor_goal1" );
	a_quadrotors = GetEntArray( "allied_quadrotor", "targetname" );
	
	foreach( vh_quadrotor in a_quadrotors )
	{
		vh_quadrotor.goalpos = s_goal.origin;
	}
	
	wait 15;
	
	array_delete( a_quadrotors );
}

// hide bridge and building destruction states
hijacked_destructibles_setup()
{
	a_m_bridge_destroyed_parts = GetEntArray( "bridge_destroyed", "targetname" );
	a_m_building_destroyed = GetEntArray( "bridge_building_destroyed", "targetname" );
		
	foreach( m_bridge_destroyed in a_m_bridge_destroyed_parts )
	{
		m_bridge_destroyed Hide();
	}
	
	foreach( m_building_destroyed in a_m_building_destroyed )
	{
		m_building_destroyed Hide();
	}
	
	hijacked_setup_trees();
}

/*---------------------------------------------------------------------------------
 * Crash quadrotors into trees
 * trigger's script_noteworthy is the drone's spawn point
 * 			 script_string is the drone path start node
 * *******************************************************************************/
hijacked_setup_trees()
{
	a_t_crash_trigs = GetEntArray( "quadrotor_tree_crash_trig", "targetname" );
	array_thread( a_t_crash_trigs, ::quadrotor_crash_tree_think );
}

hijacked_ambient_guys()
{
	a_ambient_spawners = GetEntArray( "ambient_guys_ai", "script_noteworthy" );
	array_thread( a_ambient_spawners, ::hijacked_ambient_spawnfunc );
}

hijacked_bridge_guys()
{
	a_ambient_spawners = GetEntArray( "sp_hijacked_ally_capture", "targetname" );
	array_thread( a_ambient_spawners, ::hijacked_ambient_spawnfunc );
}

// set up guys
hijacked_ambient_spawnfunc() // self = guy
{
	self magic_bullet_shield();
	self set_ignoreme( true );
}

hijacked_crash_drone_near_player()
{
	v_qrotor = spawn_vehicle_from_targetname( "yemen_quadrotor_spawner" );
	wait 1;
	v_trace_to_point = level.player GetEye() + ( VectorNormalize( AnglesToForward( level.player GetPlayerAngles() ) )  * 350 );
	v_qrotor.origin = v_trace_to_point + (0, 0, 256);
	v_qrotor.goalpos = v_trace_to_point + (0, 0, 256);
	RadiusDamage( v_qrotor.origin + (0, 0, 10), 32, v_qrotor.health + 10, v_qrotor.health + 10 );
}

// spawns menendez's vtol for end sequence
spawn_menendez_vtol()
{
	flag_wait( "spawn_menendez_vtol" );
	
	veh_vtol = spawn_vehicle_from_targetname( "yemen_morals_rail_vtol_spawner" ); // this is one with a turret
	nd_path = GetVehicleNode( "nd_capture_vtol_land_start", "targetname" );
	
	veh_vtol SetSpeed( 10 );
	veh_vtol SetHoverParams( 1 );
	veh_vtol veh_toggle_tread_fx( 0 ); // off so fx dept can control look of the area
	veh_vtol thread go_path( nd_path);
//	veh_vtol setup_vtol_turret();
}
 
 // Self = VTOL
 setup_vtol_turret()
{
	// create new turret
	self.turret = maps\_turret::create_turret( self.origin, self.angles, "axis", "v78_player_minigun_gunner", "veh_t6_air_v78_vtol_side_gun" );
	self.turret MakeTurretUnusable();
	
	// don't shoot anything without being told to, dammit
	self.turret maps\_turret::pause_turret( 0 );

	self setontargetangle( 2 );

	/# recordEnt( self.turret ); #/

	self.turret LinkTo( self, "tag_gunner1", ( 0, 0, 0 ), ( 0, 0, 0 ) );
}
 
// Only used on skipto hijacked_menendez
menendez_hijack_scene_check()
{
	if( flag( "menendez_hijack_vtol_active" ) )
	{
		switch_player_to_mason();
		wait 1; // wait for scenes to get set up since they are initialized as the player progresses through the map
		level thread run_scene( "menendez_hack" );
		level thread run_scene( "pilot_hack" );
		give_models_guns( "menendez_hack", "t6_wpn_pistol_judge_world" );
	}
}

// gives gun to scene model
give_models_guns( str_scene, str_gun )
{
	a_models = get_model_or_models_from_scene( str_scene );
	
	foreach ( m_guy in a_models )
	{
		m_guy attach( str_gun, "tag_weapon_right" );
	}
}

/* ------------------------------------------------------------------------------------------
	CLEANUP
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

hijacked_cleanup()
{
	level thread background_rappellers_cleanup();
	
	flag_wait( "spawn_menendez_vtol" );
	
	a_ai_guys = GetEntArray( "hijacked_terrorists", "script_noteworthy" );
	kill_units( a_ai_guys );
	
	a_ai_crossover_guys = get_ai_array( "crossover_terrorist", "script_noteworthy" );
	array_delete( a_ai_crossover_guys );
	
	level waittill( "swap_quadrotors" );
		
	a_vh_hijacked_robots = GetEntArray( "hijacked_robot", "script_noteworthy" );
	kill_units( a_vh_hijacked_robots, true );
	
	level waittill( "bridge_crossing" );
		
	a_vh_bridge_robots = GetEntArray( "hijacked_bridge_robot", "script_noteworthy" );
	kill_units( a_vh_bridge_robots, true );
	
	a_vh_bridge_player_quad_spawners = GetEntArray( "hijacked_player_only_quad", "script_noteworthy" );
	kill_units( a_vh_bridge_player_quad_spawners );
}

background_rappellers_cleanup()
{
	level endon( "capture_started" );
	
	flag_wait_any( "hijacked_salazar_advance_on_right", "hijacked_salazar_advance_on_left" );
	
	a_ai_rappellers = get_ai_array( "hijacked_ally", "script_noteworthy" );
//	array_delete( a_ai_rappellers );
}

/*--------------------------------------------------------------
 * Kills units with specified script noteworthy
 * Mandatory: entities
 * Optional: bool stagger deaths ( defaults to false )
 * ************************************************************/
kill_units( a_e_units, b_stagger )
{
	const HIGH_WAIT = .45;
	const LOW_WAIT = .65;
	
	foreach( e_unit in a_e_units )
    {	
		if( IsDefined( e_unit ) )
    	{
	    	if( e_unit.health > 0 )
			{
	    	   	RadiusDamage( e_unit.origin + (0, 0, 10), 32, e_unit.health + 10, e_unit.health + 10 );
	    	}
	    	
	    	if( IsDefined( b_stagger ) && b_stagger == true )
	    	{
	    		wait RandomFloatRange( HIGH_WAIT, LOW_WAIT );
	    	}
		}
    }
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// if player goes onto roof give him a good opportunity
terrorists_expose()
{
	level endon( "drone_control_lost" );
	
	level waittill( "hijacked_building_guys_exposed" );
	
	s_goal = GetStruct( "s_hijacked_buildiing_exposed_goal", "targetname" );
	a_ai_building_guys = get_ai_array( "hijacked_terrorists" );
	
	foreach( ai_guy in a_ai_building_guys )
	{
		ai_guy SetGoalPos( s_goal.origin );
	}
}

quadrotor_start_rockslide()
{
	level endon( "hijacked_building_battle_started" );
	level endon( "hijacked_left_foreshadow" );
	level endon( "hijacked_right_foreshadow" );
	
	level waittill( "fxanim_falling_rocks_start_kickoff" );
	
	spawn_quadrotor_and_drive_path( "yemen_hijacked_quadrotor_rockslide", "hijacked_rockslide_spline", true, false );
	
	level notify( "fxanim_falling_rocks_start" );
}

quadrotor_right_foreshadow()
{
	level endon( "hijacked_building_battle_started" );
	level endon( "hijacked_left_foreshadow" );
	
	level waittill( "hijacked_right_foreshadow" );
	
	spawn_quadrotor_and_drive_path( "yemen_hijacked_quadrotor_right_eratic", "hijacked_right_path_eratic_spline", true, false );
}

quadrotor_left_foreshadow()
{
	level endon( "hijacked_building_battle_started" );
	level endon( "hijacked_right_foreshadow" );
	
	level waittill( "hijacked_left_foreshadow" );
	
	spawn_quadrotor_and_drive_path( "yemen_hijacked_quadrotor_left_eratic", "hijacked_left_path_eratic_spline", true, false );
}

hijacked_drone_control_lost()
{
	flag_wait( "drone_control_lost" );
	
	a_ai_roof_guys = get_ai_array( "hijacked_roof_terrorist" );
	
	spawn_manager_kill( "quadrotor_tree_crash_trig" );
	spawn_quadrotor_and_drive_path( "yemen_hijacked_quadrotor_window", "nd_hijacked_buildign_window_quadrotor", true, false ); // quadrotor flies through window and crashes into cliff
	spawn_quadrotor_and_drive_path( "yemen_hijacked_quadrotor_roof", "hijacked_roof_spline", true, false ); // crash quadrotor into roof
	
//    level thread allied_quadrotors_move_ahead_and_delete();
	screen_message_create( &"YEMEN_DRONES_OFFLINE" );
	
	flag_clear("drones_online");
	
	level.player maps\_fire_direction::_fire_direction_kill();
	
	level thread qr_drones_fly_away();
	
	screen_message_delete();
	
	autosave_by_name( "drone_control_lost_drones" );
    a_ai_guys = GetEntArray( "hijacked_roof_terrorist", "script_noteworthy" );
    
    kill_units( a_ai_guys );
}

qr_drones_fly_away()
{
	a_qrotors = GetEntArray( "allied_quadrotor", "targetname" );
	s_goal_spot = GetStruct( "s_qr_drones_fly_away", "targetname" );
	e_target = GetEnt( "qr_drones_dummy_target", "targetname" );
	
	foreach( veh_qrotor in a_qrotors )
	{
		veh_qrotor.radius = 128;
		veh_qrotor thread qr_drones_move_and_change_team( s_goal_spot, e_target );
	}
}

qr_drones_move_and_change_team( s_goal, e_target )
{
	self notify( "change state" );
	self SetTurretTargetEnt( e_target );  //Set the turret to target a far-off spot so QR drones don't shoot at enemies on their way off-scene
	// self SetNearGoalNotifyDist( 128 );
	self.goalpos = s_goal.origin;
	
	while ( Distance2DSquared( self.origin, s_goal.origin ) > (512*512) )
	{
		wait 0.1;	
	}
	
	self veh_magic_bullet_shield( false );
	self.takedamage = true;
	self thread maps\_quadrotor::quadrotor_set_team( "axis" );
	self ClearTurretTarget();
//	self ClearVehGoalPos();
	// VEHICLE_DELETE( self );
}

/*----------------------------------------
 * Set up metalstorm-quadrotor miniboss
 * **************************************/
quadrotors_guard_metalstorm()
{
	wait 5;
	
	vh_metalstorm = GetEnt( "hijacked_first_metalstorm", "targetname" );
	a_vh_quadrotors = GetEntArray( "hijacked_first_metalstorm_guard1", "targetname" );
	a_vh_quadrotors2 = GetEntArray( "yemen_hijacked_quadrotor_hostile_formation", "targetname" );
	
	array_thread( a_vh_quadrotors, ::set_quadrotor_guard_position, vh_metalstorm );
	array_thread( a_vh_quadrotors2, ::set_quadrotor_guard_position, vh_metalstorm );
	
	level thread hijacked_miniboss_clear_listener();
}

hijacked_miniboss_clear_listener()
{
	while( true )
	{
		a_vh_quadrotors = GetEntArray( "hijacked_first_metalstorm_guard1", "targetname" );
		a_vh_quadrotors2 = GetEntArray( "yemen_hijacked_quadrotor_hostile_formation", "targetname" );
		n_squad_size = a_vh_quadrotors.size + a_vh_quadrotors2.size;
		
		if( n_squad_size == 0 )
		{
			level notify( "hijacked_miniboss_done" );
			break;
		}
		
		wait 1;
	}
}

// blow up bridge
hijacked_bridge_event()
{
	level waittill( "hijacked_suicide_drone_start" );
	
	// Audio
	level thread bridge_groan_sound_loop();
	
	level thread maps\yemen_anim::hijacked_anims();
	
	hijacked_bridge_drone_crash();
	hijacked_bridge_explode();
	level thread hijacked_bridge_soldier_fall();
}

// suicide drone hits bridge
hijacked_bridge_drone_crash()
{
	setup_allies();
	spawn_quadrotor_and_drive_path( "veh_quadrotor_yemen_hijacked_suicide", "hijacked_bridge_suicide_spline", true, false );
	
	autosave_by_name( "hijacked_bridge" );
}

// bridge explodes
hijacked_bridge_explode()
{
	exploder( 750 );
	
	//SOUND - SHAWN J
	PlaySoundAtPosition ( "fxa_bridge_explo", (-9350, -13638, 9280) );
	
	level notify( "fxanim_bridge_explode_start" );
	
	hijacked_bridge_swap();
	level thread run_scene( "hijacked_bridge_hang" );
}

capture_fake_battle()
{
	s_shoot_spot = GetStruct( "capture_bridge_battle_shoot_spot", "targetname" );
	a_ai_seals = get_ai_array( "hijacked_ally", "script_noteworthy" );
	a_ai_seals_b = get_ai_array( "hijacked_ally_bridge", "script_noteworthy" );
	o_target = Spawn( "script_origin", s_shoot_spot.origin );
	
	foreach( ai_seal in a_ai_seals )
	{
		ai_seal shoot_at_target_untill_dead( o_target );
	}
	
	foreach( ai_seal in a_ai_seals_b )
	{
		ai_seal shoot_at_target_untill_dead( o_target );
	}
	
	level waittill( "first_flashback" );
	
	o_target Delete();
}

/* ------------------------------------------------------------------------------------------
	QUADROTOR fuctions
	***************************************************************************************
-------------------------------------------------------------------------------------------*/
	
/*-----------------------------------------------------
 * Updates quadrotor position to metalstorm position
 * Self = quadrotor
 * Mandatory: vehicle to stay close to
 * ***************************************************/
set_quadrotor_guard_position( vh_guard_this )
{
	self endon( "death" );
	self endon( "delete" );
	
//	vh_guard_this endon( "death" );
//	vh_guard_this endon( "delete" );
//	level endon( "hijacked_miniboss_done" );
//	
//	while( true )
//	{
//		self.goalpos = vh_guard_this.origin;
//		wait .5;
//	}
}

quadrotors_guard_bridge()
{
	a_vh_quads = GetEntArray( "hijacked_bridge_robots", "script_noteworthy" );
	nd_goal = GetVehicleNode( "hijacked_hostile_formation_bridge_spline_end", "targetname" );
	
	foreach( vh_quad in a_vh_quads )
	{
		vh_quad.goalpos = nd_goal.origin;
	}
}

/*__________________________________________________________________________________________________________________
 * Spawns quadrotor from spawner and drives on path
 * Self is trigger (optional)
 * Optional: spawner name, path start node, bool should it crash?, should it waittill trigger? ( defaults to true )
 * ****************************************************************************************************************/
spawn_quadrotor_and_drive_path( str_veh_spawner, str_nd, b_crash, b_trig )
{
	if( !IsDefined( b_trig ) || b_trig == true )
	{
		self trigger_wait();
	}
	
	if( !IsDefined( str_veh_spawner ) )
	{
		str_veh_spawner = self.script_noteworthy;
	}
	
	veh_qrotor = spawn_vehicle_from_targetname( str_veh_spawner );
	veh_qrotor quadrotor_go_on_path( str_nd, b_crash );
}

/*__________________________________________________________________
 * Moves quadrotor on path, returning to ai or crashing at the end
 * Self is a quadrotor
 * Optional: node, should I crash? 
 * *****************************************************************/
quadrotor_go_on_path( str_nd, b_crash )
{
	self maps\_quadrotor::quadrotor_start_scripted();
	
	if( !IsDefined( str_nd ) )
	{
		str_nd = self.target;
	}
	
	nd_goal = GetVehicleNode( str_nd, "targetname" );
	
	self go_path( nd_goal );
	
	if( IsDefined( b_crash ) )
	{
		self thread play_fx( "quadrotor_crash", self.origin, self.angles, 2 );
		RadiusDamage( self.origin + (0, 0, 10), 128, self.health + 10, self.health + 10 );
	}
	else
	{
		self maps\_quadrotor::quadrotor_start_ai();
		self.goalpos = self.origin + (64, 0, 0);
	}
}

/*__________________________________________________________________
 * Spawns quadrotors in formation and drives on path
 * Mandatory: number of quads, start node, spawner targetname
 * *****************************************************************/
spawn_quadrotor_formation( n_count, str_nd_start, str_spawner, str_team )
{	
	path_start = GetVehicleNode( str_nd_start, "targetname" );
	offset = (0, 70, 0);

	for( i=0; i < n_count; i++ )
	{
		if( !IsDefined( str_team ) )
		{
			str_team = "axis";
		}
		quad = maps\_vehicle::spawn_vehicle_from_targetname( str_spawner );
		quad thread maps\_quadrotor::quadrotor_set_team( str_team );
		quad maps\_quadrotor::quadrotor_start_scripted();
		wait 0.1;	// allow the state to change to scripted
		quad SetVehicleAvoidance( false );
		quad maps\_vehicle::getonpath( path_start );
		quad.drivepath = true;
		//quad PathVariableOffset( (0, 10, 10), 2 );
		
		offset_scale = get_offset_scale( i );
		
		quad PathFixedOffset( offset * offset_scale );
		quad PathVariableOffset( ( 100, 100, 100 ), RandomIntRange( 1, 3 ) );
		quad thread maps\_vehicle::gopath();
		quad thread activate_ai_on_end_path();
		
		quad thread cleanup();
	}
}

cleanup()
{
	self endon( "death" );
	level waittill( "cleanup" );
	VEHICLE_DELETE( self );
}

activate_ai_on_end_path()
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	level notify( "awake_axis_quads" );
	
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	self maps\_quadrotor::quadrotor_start_ai();
	self SetVehicleAvoidance( true );
}

/* ------------------------------------------------------------------------------------------
	BRIDGE
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//Soldier falls from bridge when player gets close
hijacked_bridge_soldier_fall()
{	
	flag_wait( "hijacked_bridge_fell" );
	
	flag_set( "obj_capture_sitrep" );
	
	level thread run_scene( "hijacked_bridge_fall" );
	wait 6; // HACK: wait for anim to progress - change to notetrack
	level thread hijacked_bridge_ledge_crumble();
}

// bride part breaks off
hijacked_bridge_ledge_crumble()
{
	level notify( "fxanim_bridge_drop_start" ); // play fxanim
	
	wait 2; // HACK: wait for fxanim to progress - can you have notetracks on fxanims?
	
	// delete collision around ledge
	a_m_collision = GetEntArray( "m_hijacked_bridge_fall_clip", "targetname" );
	array_delete( a_m_collision );
}

//guys move across bridge
hijacked_bridge_guys_move_up()
{
//	trigger_wait( "trigs_hijacked_bridge_guys_move_up" );
	
	a_bridge_guys = GetEntArray( "sp_hijacked_soldier_rpg_ai", "targetname" );
	
	foreach( ai_guy in a_bridge_guys )
	{
		nd_goal = GetNode( self.script_noteworthy, "targetname" );
		
		ai_guy set_goalradius( 64 );
		ai_guy SetGoalNode( nd_goal );
	}
}

//shoot magic rpg
hijacked_magicbullet_shoot( str_gun )
{
	s_rpg = GetStruct( str_gun, "targetname" );
	s_target = GetStruct( s_rpg.target, "targetname" );
	
	if( IsDefined( s_rpg ) )
	{
		level notify( "magic_rgp_fired" );
		MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_target.origin );
	}
}

/* ------------------------------------------------------------------------------------------
	DESTRUCTIBLES
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//swap bridge for destroyed bridge
hijacked_bridge_swap()
{
	a_m_bridge_whole_parts = GetEntArray( "bridge_whole", "targetname" );
	a_m_bridge_destroyed_parts = GetEntArray( "bridge_destroyed", "targetname" );
	
	foreach( m_bridge_destroyed in a_m_bridge_destroyed_parts )
	{
		m_bridge_destroyed Show();
	}
	
	foreach( m_bridge_whole in a_m_bridge_whole_parts )
	{
		m_bridge_whole Hide(); // hiding instead of deleting to keep collision
	}
}

//swap building for destroyed building
hijacked_bridge_building_swap()
{
	a_m_building_whole = GetEntArray( "bridge_building_whole", "targetname" );
	a_m_building_destroyed = GetEntArray( "bridge_building_destroyed", "targetname" );

	foreach( m_building_destroyed in a_m_building_destroyed )
	{
		m_building_destroyed Show();
	}
		
	foreach( m_building_whole in a_m_building_whole )
	{
		m_building_whole Delete();
	}
}

// triggers quadrotor to crash
quadrotor_crash_tree_think() //self = trigger
{
	// end if either tree falls
//	level endon( "fxanim_tree_d_blood_fall01_start" );
//	level endon( "fxanim_tree_d_blood_fall02_start" );
	level endon( "capture_started" );
	
	str_id = self.script_noteworthy;
	str_node = self.script_string;
	
	self waittill( "trigger" );
	
	spawn_quadrotor_and_drive_path( str_id, str_node, true, false );
}

// Building above steps explodes
stairs_building_damage_listener()
{
	trigger_wait( "trig_dmg_hijacked_stairs" ); // rpg hits dmg trig
	
	exploder( 760 ); // building explosion
	
	level notify( "fxanim_rock_slide_start" );
	
	hijacked_bridge_building_swap();
	
	flag_set( "hijacked_stairs_collapse" ); // trigger hurt waiting on this flag
}

stairs_shoot_stairs_building()
{
	flag_wait( "hijacked_blow_up_building" );
	
	s_rpg = GetStruct( "s_hijacked_cliffside_magicbullet_rpg_building_collapse", "targetname" );
	s_target = GetStruct( s_rpg.target, "targetname" );
	
	level notify( "magic_rgp_fired" );
	MagicBullet( "rpg_magic_bullet_sp", s_rpg.origin, s_target.origin );
}

/* ------------------------------------------------------------------------------------------
	AMBIENT
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

//ambient quadrotors
hijacked_ambient_qrotors()
{
	level endon( "fxanim_bridge_explode_start" );
	
	level thread hijacked_ambient_qrotors_bridge();
	
	while( true )
	{
		level thread maps\yemen_capture:: capture_spawn_fake_qrotors_at_structs_and_move( "s_hijacked_fake_qrotors_chaotic", RandomIntRange( 8, 10 ) );
		
	    wait RandomFloatRange( 1, 3 );
	}
}

hijacked_ambient_qrotors_bridge()
{
	while( true )
	{
		level thread maps\yemen_capture:: capture_spawn_fake_qrotors_at_structs_and_move( "s_hijacked_fake_qrotors", RandomIntRange( 7, 9 ) );
		
	    wait RandomFloatRange( 1, 3 );
	}
}

/* ------------------------------------------------------------------------------------------
	CHALLENGES
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

// cause x rockslides
environmental_challenge( str_notify )
{
	level endon( "capture_sniper_active" ); // stop waiting when end starts
	
	flag_wait( "drone_control_farmhouse_started" ); // flag set at archway in drone control area
	
	const MIN_PERCENT = .5; // percent of total available
	
	a_dmg_trigs = GetEntArray( "hijacked_environmental", "script_noteworthy" ); // rockslide trigs
	n_min = a_dmg_trigs.size * MIN_PERCENT; // min number of destructions
	n_destroyed = 0;
	
	while( true )
	{	            			
		flag_wait( "hijacked_environmental" );
		   	
		n_destroyed ++;
		
		if( n_destroyed >= n_min ) // when min hits stop
		{
			break;
		}
		  	
		flag_clear( "hijacked_environmental" );
		
		wait 1;
	}
	
	self notify( str_notify );
}

// blow down x trees
lumberjack_challenge( str_notify )
{
	level endon( "capture_sniper_active" ); // stop waiting when end starts
	
	flag_wait( "drone_control_farmhouse_started" ); // flag set at archway in drone control area
	
	const MIN_PERCENT = .5; // percent of total available
	
	a_dmg_trigs = GetEntArray( "hijacked_lumberjack", "script_noteworthy" ); // rockslide trigs
	n_min = a_dmg_trigs.size * MIN_PERCENT; // min number of destructions
	n_destroyed = 0;
	
	while( true )
	{	            			
		flag_wait( "hijacked_lumberjack" );
		   	
		n_destroyed ++;
		
		if( n_destroyed >= n_min ) // when min hits stop
		{
			break;
		}
		  	
		flag_clear( "hijacked_lumberjack" );
		
		wait 1;
	}
	
	self notify( str_notify );
}

// fall to your death
clutz_challenge( str_notify )
{
	level endon( "menendez_surrenders" );

	flag_wait( "clutz" );        			
	
	self notify( str_notify );
}

/* ------------------------------------------------------------------------------------------
	AUDIO
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

tree_1_sound()
{ 
	level endon( "swap_quadrotors" );
	
	level waittill ("fxanim_tree_d_blood_fall01_start") ;
	
	m_tree_1_loc = GetEnt ( "fxanim_tree_d_blood_fall01", "targetname");
	m_tree_1_loc PlaySound ( "fxa_tree_01" );
	
}

tree_2_sound()
{
	level endon( "swap_quadrotors" );
	
	level waittill ("fxanim_tree_d_blood_fall02_start") ;
	
	m_tree_2_loc = GetEnt ( "fxanim_tree_d_blood_fall02", "targetname");
	m_tree_2_loc PlaySound ( "fxa_tree_02" );
}

bridge_groan_sound_loop()
{
	o_groan_location = Spawn ( "script_origin", (-9303, -13775, 828));
	o_groan_location PlayLoopSound ( "amb_bridge_failing" );
	
	level waittill ( "fxanim_bridge_drop_start" );
	
	PlaySoundAtPosition ( "fxa_bridge_give_way", o_groan_location.origin );
	
	o_groan_location StopLoopSound(2);
	wait(5);
	o_groan_location delete();                        
}

/* ------------------------------------------------------------------------------------------
	VO
	***************************************************************************************
-------------------------------------------------------------------------------------------*/

vo_hijacked()
{
	vo_hijacked_intro();
	level thread vo_hijacked_left_path();
	level thread vo_hijacked_right_path();
	vo_drones_offline();
	vo_bridge();
}

vo_hijacked_intro()
{
	flag_wait( "hijacked_building_battle_started" );
	
	level.player say_dialog( "sala_large_concentration_0" ); 			// SALAZAR: Large concentration of infantry - dead ahead.
}

vo_hijacked_left_path()
{
	level endon( "drone_control_lost" );
	
	flag_wait( "hijacked_salazar_advance_on_left" );
	
	level.player say_dialog( "sala_enemies_in_the_build_0" ); 			// salazar	Enemies in the building to your right!
}

vo_hijacked_right_path()
{
	level endon( "drone_control_lost" );
	
	flag_wait( "hijacked_salazar_advance_on_right" );
	
	level.player say_dialog( "sala_we_need_drone_suppor_0" ); 			// salazar	We need drone support on the building!
}

vo_drones_offline()
{
	flag_wait( "drone_control_lost" );
	
	level thread drone_cam_pip_sounds();
	play_bink_on_hud("yemen_kill_pilot");
	level.player say_dialog( "sala_section_watch_your_0" );				//salazar	Section! Watch your drones - input an altitude hold.
	//Eckert - Play pip sounds
	level.player say_dialog( "sect_it_s_not_me_i_ve_lo_0" );			// section	It’s not me, I’ve lost link!
	wait .15;
	level.player thread say_dialog( "mene_your_time_has_come_0" );		// Your time has come, David.
	
	flag_wait( "spawn_menendez_vtol" );
	
	level.player thread say_dialog( "sala_all_units_we_have_lo_0" );	// All units we have lost control of drone support, all drones are now hostile, engage as needed!
}

vo_bridge()
{	
	level waittill( "swap_quadrotors" );
	
	level.player say_dialog( "sala_blocking_positions_0" );				// Blocking positions, I need updates on Menendez’ location.
	wait .1;
	level.player say_dialog( "reds_sir_no_activity_hv_0" );				// Sir, no activity, HVI appears to be inside the downed command VTOL, we are receiving heavy fire from its mini-gun..
	wait .15;
	level.player say_dialog( "sala_understood_maintain_0" );			// Understood, maintain eyes on but do not engage.
}

temp_vo_function()
{
	// New Building
	level.player say_dialog( "SALAZAR: Watch the stairs!" );
	
	// New buildign Balcony or famhouse building
	level.player say_dialog( "SECTION: I’ll establish a support position in the building!" );
	
	// Eyes on Menendez's VTOL
	level.player say_dialog( "SALAZAR: (into radio) Blocking positions, I need updates on Menendez’ location." );
	level.player say_dialog( "REDSHIRT: (over radio) Sir, no activity, HVI appears to be inside the downed command VTOL, we are receiving heavy fire from its mini-gun." );
	level.player say_dialog( "SALAZAR: (into radio) Understood, maintain eyes on but do not engage." );
	
	// Bridge
	level.player say_dialog( "SALAZAR: (over radio) Section, he’ll kill you where you stand!" );
	level.player say_dialog( "SECTION: No he won’t." );
	level.player say_dialog( "SALAZAR: (into radio) All units confirm hold fire, we are approaching command VTOL." );
	
	// KHAAAAAAAAAAAAAAN!
	// -- Mingun spins down --
	
	// memory echo..
	
	// Reinforcements
	level.player say_dialog( "MARINE: Bridge in sight. Hotel one inbound. Deploying west side of gorge." );
	
	// Might be old
	level.player say_dialog( "MARINE2: Watchtower, Hotel one actual, drones are targeting us! Check your fire!" );
	level.player say_dialog( "MARINE2: Command, drones have gone rogue!" );
	level.player say_dialog( "MARINE2: Watchtower, hotel one, we are taking friendly fire from the drones! Call them off! Expedite!" );
	level.player say_dialog( "MARINE1: Take cover, sir!" );
}
hijack_bridge_snapwatch()
{
	flag_wait ("hijacked_bridge_fell");
	//Audio - snapshot default
	level ClientNotify ("mbss");	
}