#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_anim;
#include maps\yemen_utility;


/* ------------------------------------------------------------------------------------------
	INIT functions
-------------------------------------------------------------------------------------------*/

//	event-specific flags
init_flags()
{
	flag_init( "market_start" );
	flag_init( "market_vtol_saved" );
	flag_init( "market_complete" );
}


//	event-specific spawn functions
init_spawn_funcs()
{
	a_yemeni_spawners = GetEntArray( "market_yemeni", "script_noteworthy" );
	array_thread( a_yemeni_spawners, ::add_spawn_function, maps\yemen_utility::yemeni_teamswitch_spawnfunc );
	
	a_terrorist_spawners = GetEntArray( "market_terrorist", "script_noteworthy" );
	array_thread( a_terrorist_spawners, ::add_spawn_function, maps\yemen_utility::terrorist_teamswitch_spawnfunc );
	
	sp_terrorist_vtol_shooter = GetEnt( "market_terrorist_stinger", "script_noteworthy" );
	sp_terrorist_vtol_shooter thread add_spawn_function( ::market_vtol_shooter_spawnfunc );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_market()
{
	skipto_setup();
	
	start_teleport( "skipto_market_player" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Market" );
#/

	init_spawn_funcs();
		
	flag_set( "market_start" );
		
	market_setup();
	level thread market_menendez_walk();
	market_vtol_crash();
	
	flag_wait( "market_complete" );
}


/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/

market_setup()
{
	level.friendlyFireDisabled = true;
	
	level.player SetThreatBiasGroup( "player" );
	
	market_table_flips_init();
	
	autosave_by_name( "yemen_market_start" );
}



market_menendez_walk()
{
	run_scene( "exit_stage" );
	run_scene( "exit_courtyard" );
	run_scene( "exit_courtyard_loop" );
}


market_vtol_crash()
{	
	m_vtol			= GetEnt( "market_vtol_to_save", "targetname" );
	s_crash_spot 	= GetStruct( "market_vtol_crash_spot", "targetname" );
	s_save_spot		= GetStruct( "market_vtol_save_spot", "targetname" );
	s_stinger_start	= GetStruct( "vtol_crash_stinger_start", "targetname" );
	
	trigger_wait( "market_end" );	

	autosave_by_name( "yemen_market_vtol_crash" );
	
	if( flag( "market_vtol_saved" ) )
	{
		trigger_off( "vtol_crash_blocker", "targetname" );
		m_vtol MoveTo( s_save_spot.origin, 10, 1, 1 );
	}
	else
	{
		MagicBullet( "rpg_magic_bullet_sp", s_stinger_start.origin, m_vtol.origin - (0, 0, 32 ) );
		
		wait( 1 );
		
		m_vtol MoveTo( s_crash_spot.origin, 2, .5, .5 );
	}
	
	flag_set( "market_complete" );
}



market_vtol_shooter_spawnfunc()
{
	self thread maps\yemen_utility::terrorist_teamswitch_spawnfunc();
	
	self waittill( "death" );
	flag_set( "market_vtol_saved" );
}



/* ------------------------------------------------------------------------------------------
	Other functions
-------------------------------------------------------------------------------------------*/

market_table_flips_init()
{
	a_table_structs = GetStructArray( "marketplace_table_spot", "script_noteworthy" );
	array_thread( a_table_structs, ::market_table_flip_think );
}

market_table_flip_think()
{	
	const n_spawn_flags = 15;			// AI_AXIS, AI_ALLIES, AI_NEUTRAL, NOTPLAYER
	const n_table_flip_chance = 20;		// out of 100
	const n_table_noflip_cooldown = 2;	// time between attmpts to flip
	is_table_ready = false;
	e_guy = undefined;
	
	m_table = spawn_anim_model( "market_table", self.origin, self.angles, true );

	nd_new_cover = GetNode( self.target, "targetname" );
	SetEnableNode( nd_new_cover, false );
	
	// animation has wrong angles, easier to fix here
	self.angles = ( self.angles[0], self.angles[1] - 90, self.angles[2] );
	
	// wait for a guy to be close to the table, then send him over and flip it
	t_neartable_trig = Spawn( "trigger_radius", self.origin, n_spawn_flags, 256, 128 );
	
	while( !is_table_ready )
	{
		t_neartable_trig waittill( "trigger", e_guy );
		
		if( RandomInt(100) < n_table_flip_chance )	// each time trigger is hit, it only has a certain percentage chance to flip
		{
			is_table_ready = true;	
		}
		else
		{
			wait n_table_noflip_cooldown;		// set cooldown between attempts to flip
		}		
	}
	
	e_guy.animname = "generic";
	
	self anim_reach_aligned( e_guy, "market_table_flip" );
	
	a_anim_ents = Array( e_guy, m_table.anim_link );
	self anim_single_aligned( a_anim_ents, "market_table_flip" );
	
	SetEnableNode( nd_new_cover, true );
	e_guy.goalradius = 16;
	e_guy SetGoalNode( nd_new_cover );
}