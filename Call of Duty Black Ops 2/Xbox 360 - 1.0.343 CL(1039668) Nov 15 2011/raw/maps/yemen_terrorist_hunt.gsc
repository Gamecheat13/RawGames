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
	flag_init( "terrorist_hunt_start" );
	flag_init( "terrorist_hunt_rockethall_start" );
	flag_init( "terrorist_hunt_rockethall_done" );
	flag_init( "terrorist_hunt_complete" );
}


//
//	event-specific spawn functions
init_spawn_funcs()
{
	
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/

//	skip-to only initialization (not run if this event skip-to isn't used)
skipto_terrorist_hunt()
{
	skipto_setup();
	level thread test_rocket_hall_play_all_fx();
	start_teleport( "skipto_terrorist_hunt_player" );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions 
-------------------------------------------------------------------------------------------*/

//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//		your skipto sequence will be called.
main()
{
/#
	IPrintLn( "Terrorist Hunt" );
#/

	terrorist_hunt_setup();
	
	flag_set( "terrorist_hunt_start" );
	
	rocket_hall();
	
	flag_set( "terrorist_hunt_complete" );
}




terrorist_hunt_setup()
{
	a_spawners = GetEntArray( "rocket_hall_actors", "script_noteworthy" );
	array_thread( a_spawners, ::add_spawn_function, ::rocket_hall_terrorist_spawnfunc );
	
	simple_spawn( "terrorist_hunt_court_terrorist", maps\yemen_utility::terrorist_teamswitch_spawnfunc );
	trigger_use( "terrorist_hunt_spawn_drones", "targetname", level.player );
}

/* ------------------------------------------------------------------------------------------
	EVENT functions
-------------------------------------------------------------------------------------------*/


rocket_hall()
{
	const n_slow_timer = 1;
	
	trigger_wait( "trig_rocket_hall_door" );
	
	flag_set( "terrorist_hunt_rockethall_start" );

	a_zone_trigs = GetEntArray( "rocket_hall_zone", "targetname" );
	array_thread( a_zone_trigs, ::rocket_hall_zone_think );
	
	simple_spawn( "rocket_hall_yemeni", ::rocket_hall_yemeni_spawnfunc );
	
	e_door = GetEnt( "rocket_hall_door", "targetname" );
	e_door Delete();
	
	a_player_weapons = level.player GetWeaponsListPrimaries();
	level.player TakeAllWeapons();
	level.player GiveWeapon( "xm25_sp" );
	level.player SwitchToWeapon( "xm25_sp" );
	
	level thread rocket_hall_unlink_after_shot( a_player_weapons );
	
	level thread run_scene( "rocket_hall_intro" );
	n_anim_length = GetAnimLength( %player::p_yemen_03_03_xm25_intro );
	
	wait n_anim_length - n_slow_timer;	// start slowmo before anim ends TODO: replace with notetrack
	SetTimeScale( .1 );

	level.player EnableWeapons();
	level.player ShowViewModel();			
	wait n_slow_timer;	// waiting for the rest of the length of the animation
	
	level thread run_scene( "rocket_hall_reaction_to_gun" );
	
	flag_set( "terrorist_hunt_rockethall_done" );
}



rocket_hall_zone_think()
{
	n_zone_id = self.script_int;
	
	a_zone_ai = simple_spawn( "rocket_hall_ai" + n_zone_id, ::rocket_hall_terrorist_spawnfunc );
	
	self waittill( "trigger" );
	level notify( "rocket_hall_zone_hit" );
	
	level thread rocket_hall_play_death_anims( n_zone_id );	
	
	level thread rocket_hall_kill_zone_ai( a_zone_ai );
	
	switch ( n_zone_id )
	{
		case 2:		// no break, flows through
		case 3:
			level notify( "fxanim_ceiling_collapse_start" );
			break;
	}
	
	a_zone_fx = GetStructArray( "terrorist_hunt_zone_" + n_zone_id + "_fx", "targetname" );
	rocket_hall_play_zone_fx( a_zone_fx );	
}

rocket_hall_play_death_anims( n_zone_id )
{
	str_scene = "rocket_hall_death_zone_" + n_zone_id;
	
	run_scene( str_scene );
	a_scene_ai = get_ais_from_scene( str_scene );
	
	if ( n_zone_id == 1 )
	{
		level thread run_scene( "rocket_hall_death_zone_1_loop" );
		ai_guy = get_ais_from_scene( "rocket_hall_death_zone_1_loop" );
		a_scene_ai = array_remove( a_scene_ai, ai_guy );
	}
	
	foreach ( ai_guy in a_scene_ai )	// TODO: change this to ragdoll notetracks
	{
		ai_guy StartRagdoll();
	}
	
	
}

rocket_hall_kill_zone_ai( a_zone_ai )
{
	if( a_zone_ai.size )
	{
		foreach ( ai_guy in a_zone_ai )
		{
			if( IsDefined( ai_guy ) && IsAlive( ai_guy ) )
			{
				ai_guy DoDamage( ai_guy.health + 10, (0,0,0) );
			}
		}
	}
}



rocket_hall_play_zone_fx( a_zone_fx )
{
	foreach( s_zone_fx in a_zone_fx )
	{
		str_fx = s_zone_fx.script_string;
		if( !IsDefined( s_zone_fx.angles ) )
		{
			s_zone_fx.angles = (0, 0, 0);
		}
		v_forward = AnglesToForward( s_zone_fx.angles );
		PlayFX( GetFX( str_fx ), s_zone_fx.origin, v_forward );
		wait RandomFloatRange( 0, 0.1 );
	}
}



rocket_hall_unlink_after_shot( a_player_weapons )
{
	level waittill( "rocket_hall_zone_hit" );
	
	level.player TakeWeapon( "xm25_sp" );
	
	foreach ( w_weapon in a_player_weapons )
	{
		level.player GiveWeapon( w_weapon );
	}
	
	wait .1;
	level.player SwitchToWeapon( a_player_weapons[1] );
	
	wait .4;
	SetTimeScale( 1 );
	
	m_player_body = get_model_or_models_from_scene( "rocket_hall_reaction_to_gun", "player_body" );
	m_player_body Delete();
}



test_rocket_hall_play_all_fx()
{
	a_zone_trigs = GetEntArray( "rocket_hall_zone", "targetname" );
	
	while(true)
	{
		if( level.player ButtonPressed( "DPAD_UP" ) )
		{
			foreach( t_zone in a_zone_trigs )
			{
				n_zone_id = t_zone.script_int;
				a_zone_fx = GetStructArray( "terrorist_hunt_zone_" + n_zone_id + "_fx", "targetname" );
				rocket_hall_play_zone_fx( a_zone_fx );	
			}
			
			while( level.player ButtonPressed( "DPAD_UP" ) )
			{
				wait 0.05;	
			}
		}	   	
		
		wait 0.05;
	}		
}



/* ------------------------------------------------------------------------------------------
	Spawn Functions
-------------------------------------------------------------------------------------------*/

rocket_hall_yemeni_spawnfunc()
{
	self.team = "axis";
	self magic_bullet_shield();
}

rocket_hall_terrorist_spawnfunc()
{
	self.team = "allies";
	self magic_bullet_shield();
	
	level waittill( "rocket_hall_zone_hit" );
	
	self.team = "team3";
	self stop_magic_bullet_shield();
}