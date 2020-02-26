#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\yemen_utility;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "metal_storms_start" );
	flag_init( "metal_storms_fire_building_rocket" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{
	a_yemeni_spawners = GetEntArray( "street_yemeni", "script_noteworthy" );
	array_thread( a_yemeni_spawners, ::add_spawn_function, maps\yemen_utility::yemeni_teamswitch_spawnfunc );
	
	a_terrorist_spawners = GetEntArray( "street_terrorist", "script_noteworthy" );
	array_thread( a_terrorist_spawners, ::add_spawn_function, maps\yemen_utility::terrorist_teamswitch_spawnfunc );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_metal_storms()
{
	skipto_setup();
	
	start_teleport( "skipto_metal_storms_player" );
	
	level.friendlyFireDisabled = true;
	level.player SetThreatBiasGroup( "player" );	
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Metal Storms" );
#/
	metal_storms_setup();
	init_spawn_funcs();
	
	flag_set( "metal_storms_start" );
	
	level thread street_balcony_runners();
	courtyard_fire_fake_rocket();
	courtyard_metalstorm();
	street_metalstorms();
}


metal_storms_setup()
{
	// Spawn AI on the second floor in the courtyard
	// simple_spawn( "courtyard_floor2_guys", maps\yemen_utility::terrorist_teamswitch_spawnfunc );
}


/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

courtyard_fire_fake_rocket()
{
	flag_wait( "metal_storms_fire_building_rocket" );
	
	s_start_point = GetStruct( "courtyard_rocket_start", "targetname" );
	s_end_point = GetStruct( s_start_point.target, "targetname" );
	
	MagicBullet( "rpg_magic_bullet_sp", s_start_point.origin, s_end_point.origin );
	
	trigger_wait( "courtyard_start_building_boom" );	// damage trigger, waits for rocket to hit	
	
	level thread courtyard_explosion_fx();

	level notify( "fxanim_balcony_courtyard_start" );
	level run_scene( "courtyard_balcony_deaths" );
	
	// TODO: change the ragdolling to notetracks
	a_scene_ai = get_ais_from_scene( "courtyard_balcony_deaths" );	
	foreach ( ai_guy in a_scene_ai )
	{
		ai_guy StartRagdoll();
		ai_guy DoDamage( ai_guy.health + 10, (0,0,0) );
	}	
}



courtyard_explosion_fx()
{
	s_explosion_point = GetStruct( "courtyard_building_fx", "targetname" );
	s_drama_struct = GetStruct( "courtyard_fx_at_player", "targetname" );	// Struct to play Rocket FX off of (that flies towards the player)
	
	PlayFX( level._effect["balcony_explosion"], s_explosion_point.origin );
	
	// Play this fx so it shoots right in front of where the player is looking
	v_eye_pos = level.player geteye();
	v_player_eye = level.player getPlayerAngles();
	v_player_eye = VectorNormalize( AnglesToForward( v_player_eye ) );
	
	v_trace_to_point = v_eye_pos + ( v_player_eye * 256 );
	a_trace = BulletTrace( v_eye_pos, v_trace_to_point, false, level.player );
	
	v_drama_fx = VectorNormalize( a_trace["position"] - s_drama_struct.origin );
	v_drama_fx = VectorToAngles( v_drama_fx );
	
	m_drama_spot = spawn_model( "tag_origin", s_drama_struct.origin, v_drama_fx );
	
	level thread draw_debug_line( a_trace["position"], s_drama_struct.origin, 15 );
	
	PlayFXOnTag( GetFX( "balcony_debris_atplayer" ), m_drama_spot, "tag_origin" );
}
	
	

street_balcony_runners()
{
	trigger_wait( "street_balcony_runner_start" );
	
	sp_runners = GetEnt( "street_balcony_runner", "targetname" );
	s_run_spot = GetStruct( "street_balcony_runner_goal", "targetname" );

	level thread street_balcony_take_position();
	
	for( i = 0; i < sp_runners.count; i++ )
	{
		ai_guy = sp_runners spawn_ai( true );
		ai_guy thread street_balcony_run( s_run_spot.origin );
		wait .5;
	}
}

street_balcony_run( v_runto_spot )
{
	level endon( "balcony_runner_alerted" );
	wait .1;
	self.goalradius = 128;
	self set_ignoreall( true );
	self SetGoalPos( v_runto_spot );
	
	self thread street_balcony_damage_listener();
	
	self waittill( "goal" );
	wait .5;
	self Delete();
}

street_balcony_damage_listener()
{
	self waittill_any( "damage", "pain", "bulletwhizby", "balcony_alert" );
	level notify( "balcony_runner_alerted" );
}


street_balcony_take_position()
{
	level waittill( "balcony_runner_alerted" );
	
	a_balcony_runners = GetEntArray( "street_balcony_runner_ai", "targetname" );
	a_balcony_nodes = array_randomize( GetNodeArray( "street_balcony_covernode", "targetname" ) );
	
	for( i = 0; i < a_balcony_runners.size; i++ )
	{
		a_balcony_runners[i] set_ignoreall( false );
		a_balcony_runners[i] SetGoalNode( a_balcony_nodes[i] );
	}
}

/* ------------------------------------------------------------------------------------------
	Metal Storms
-------------------------------------------------------------------------------------------*/

courtyard_metalstorm()
{
	trigger_use( "courtyard_start_metalstorm" );
	simple_spawn( "courtyard_target_guy", maps\yemen_utility::terrorist_teamswitch_spawnfunc );
	wait 1;
	
	vh_metalstorm = GetEnt( "courtyard_metalstorm", "script_noteworthy" );
	ai_metalstorm_target = GetEnt( "courtyard_target_guy_ai", "targetname" );
	ai_metalstorm_target.health = 30;
	
	a_targets = array( ai_metalstorm_target );
	vh_metalstorm metalstorm_shoot_target( a_targets );
}

street_metalstorms()
{
	wait( 10 );
	trigger_use( "street_start_metalstorms" );
}



// Temp, taken from Karma
metalstorm_shoot_target( a_targets )
{
	self endon( "death" );
	
	//*******************
	// Basic firing Setup
	//*******************
	
	turret_enabled = false;
	turret_index = 0;					// 0
	
	// Set burst firing rate
	n_fire_min = 0.4;	// 0.5
	n_fire_max = 0.6;	// 0.6
	n_wait_min = 0.3;	// 0.7
	n_wait_max = 0.4;	// 0.8
	self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, turret_index );

	self maps\_turret::enable_turret( turret_index ); 
	
	// Force the turret to shoot the player
	self maps\_turret::set_turret_target_ent_array( a_targets, turret_index );

	turret_enabled = true;
}