/*-----------------------------------------------------------------------------	
pakistan.gsc
-----------------------------------------------------------------------------*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\pakistan_util;
#include maps\_glasses;
#include maps\_scene;
#include maps\_stealth_logic;

#insert raw\maps\pakistan.gsh;
#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\pakistan_fx::main();
	maps\_flamethrower_plight::init();
	maps\pakistan_anim::main();
	
	level_precache();
	init_flags();
	setup_objectives();
	setup_skiptos();	
	maps\_patrol::patrol_init();
	level.custom_introscreen = maps\pakistan_anthem_approach::pakistan_title_screen;
	
	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\pakistan_amb::main();
	
	// init stealth
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();

	OnPlayerConnect_Callback( ::on_player_connect );
	
	level thread maps\createart\pakistan_art::main();
	
	// Handles the updating of objectives
	level thread maps\_objectives::objectives(); 
	level thread pakistan_objectives(); 
	
	level thread global_funcs();
}

on_player_connect()
{
	setup_challenges();
	
	SetSavedDvar( "phys_buoyancy", 1 );  // enables buoyant physics objects in water
	
	// set water level
	n_water_level_offset = 0;
	if ( flag( "frogger_started" ) && !flag( "frogger_done" ) )
	{
		n_water_level_offset = FROGGER_WATER_HEIGHT_OFFSET;
	}
	SetDvar( "r_waterWaveBase", n_water_level_offset );	
}

// All precache calls go here
level_precache()
{
	// scripted stuff
	maps\_fire_direction::precache();
	
	// weapons 
	PrecacheTurret( CLAW_FLAMETHROWER_WEAPON );
	PrecacheItem( "usrpg_player_sp" );
	PrecacheItem( "defaultweapon_invisible_sp" );
	
	// shaders
	PrecacheShader( "flamethrowerfx_color_distort_overlay_bloom" );
	PrecacheShader( INTRO_STATIC_SHADER );  // intro static
	
	// models
	PrecacheModel( CLAW_FLAMETHROWER_MODEL );
	PrecacheModel( CLAW_FLAMETHROWER_ATTACHMENT );
	PrecacheModel( PERK_BRUTE_FORCE_PROP );
	PrecacheModel( CIVILIAN_CORPSE_MODEL );
	PrecacheModel( DATA_GLOVE_TEXTURE );
	maps\pakistan_street::precache_frogger_debris();
	
	// strings
	PrecacheString( &"pak_extracam_full" );  // lua notify to make extra cam full screen
	PreCacheString( &"generic_filter_pakistan_claw_wakeup" );  // extracam material for claw
	PrecacheString( &"hud_update_vehicle_custom" );  // claw hud notify
	
	// rumbles
	PrecacheRumble( FROGGER_WATER_RUMBLE );
}

pakistan_objectives()
{
	flag_wait( "intro_anim_done" );
	wait 1;  // wait for AI to be spawned in for skiptos 
	ai_harper = get_ent( "harper_ai", "targetname", true );
	set_objective( level.OBJ_GET_TO_BASE, ai_harper, "follow" );
	
	// escape bus
	flag_wait( "bus_dam_idle_started" );
	set_objective( level.OBJ_GET_TO_BASE, undefined, undefined );
	
	e_bus_escape = get_ent( "bus_escape_hint_origin", "targetname", true );
	
	wait 4;  // delay notice slightly so player can see bus first
	
	set_objective( level.OBJ_BUS_ESCAPE, e_bus_escape );
	flag_wait( "bus_dam_gate_push_test_done" );
	set_objective( level.OBJ_BUS_ESCAPE, undefined, "done" );
	
	set_objective( level.OBJ_GET_TO_BASE, ai_harper, "follow" );
	
	flag_wait( "player_inside_sewer" );
	
	// switch to section 2 objective when info available
}

global_funcs()
{
	add_global_spawn_function( "axis", maps\pakistan_fx::play_water_fx );
	add_global_spawn_function( "allies", maps\pakistan_fx::play_water_fx );		
	add_global_spawn_function( "axis", ::float_longer_on_death );
	add_spawn_function_veh( "fake_vehicle_spawner", ::take_no_damage );
	add_spawn_function_veh( "drone_helicopter", maps\pakistan_anthem_approach::drone_helicopter_setup );
	add_spawn_function_veh( "anthem_ambient_drone", ::drone_add_cheap_spotlight );
	
	flag_wait( "level.player" );  // wait for level.player to be defined
	wait_network_frame();  // wait for client to catch server so client flags are registered

	level.player thread maps\pakistan_fx::play_water_fx();

	maps\pakistan_market::claw_1_init();
	maps\_rusher::init_rusher();
	maps\pakistan_street::bus_dam_success_debris_setup();
}

drone_add_cheap_spotlight()  // self = ambient drone
{
	DRONE_SPOTLIGHT_TAG = "tag_turret";
	self play_fx( "helicopter_drone_spotlight_cheap", self GetTagOrigin( DRONE_SPOTLIGHT_TAG ), self GetTagAngles( DRONE_SPOTLIGHT_TAG ), "death", true, DRONE_SPOTLIGHT_TAG );
}

// important - this should have no effect when dvar phys_ragdoll_buoyancy = 0. If bouyancy is required, use ForceBuoyancy to bypass dvar
float_longer_on_death()  // self = AI
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		self FloatLonger();
	}
}

take_no_damage()
{
	self.takedamage = false;
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
//	These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
setup_skiptos()
{
	default_skipto( "intro" );
	
	// section 1
	add_skipto( "intro", 					maps\pakistan_market::skipto_intro, 					
	           &"intro",  					maps\pakistan_market::intro );
	
	add_skipto( "market", 					maps\pakistan_market::skipto_market,	 				
	           &"market", 					maps\pakistan_market::market );
	
	add_skipto( "dev_market_perk", 			maps\pakistan_market::skipto_market_dev_perk, 				
	           &"market_with_perk", 		maps\pakistan_market::market );
	
	add_skipto( "dev_market_no_perk", 		maps\pakistan_market::skipto_market_dev_no_perk, 				
	           &"market_with_perk", 		maps\pakistan_market::market );	
	
	add_skipto( "car_smash", 				maps\pakistan_market::skipto_car_smash, 				
	           &"car_smash", 				maps\pakistan_market::car_smash );
	
	add_skipto( "market_exit",	 			maps\pakistan_market::skipto_market_exit,
	           &"market_exit", 				maps\pakistan_market::market_exit );
	
	add_skipto( "dev_market_exit_perk",	 	maps\pakistan_market::skipto_market_exit_perk,
	           &"market_exit", 				maps\pakistan_market::market_exit );
	
	add_skipto( "dev_market_exit_no_perk",	maps\pakistan_market::skipto_market_exit_no_perk,
	           &"market_exit", 				maps\pakistan_market::market_exit );	
	
	add_skipto( "frogger",					maps\pakistan_street::skipto_frogger,
	           &"frogger", 					maps\pakistan_street::frogger );
	
	add_skipto( "dev_frogger_claw_support",	maps\pakistan_street::skipto_frogger_claw_support,
	           &"frogger", 					maps\pakistan_street::frogger );
	
	add_skipto( "bus_street", 				maps\pakistan_street::skipto_bus_street,
	           &"bus_street", 				maps\pakistan_street::bus_street );
	
	add_skipto( "bus_dam", 					maps\pakistan_street::skipto_bus_dam,
	           &"bus_dam", 					maps\pakistan_street::bus_dam );
	
	add_skipto( "alley", 					maps\pakistan_street::skipto_alley,
	           &"alley", 					maps\pakistan_street::alley );
	
	add_skipto( "anthem_approach", 			maps\pakistan_anthem_approach::skipto_anthem_approach,
	           &"anthem_approach", 			maps\pakistan_anthem_approach::anthem_approach );
	
	add_skipto( "sewer_exterior", 			maps\pakistan_anthem_approach::skipto_sewer_exterior, 			
	           &"sewer_exterior", 			maps\pakistan_anthem_approach::sewer_exterior );
	
	add_skipto( "sewer_interior", 			maps\pakistan_anthem_approach::skipto_sewer_interior, 			
	           &"sewer_interior", 			maps\pakistan_anthem_approach::sewer_interior );
	
	add_skipto( "dev_sewer_interior_perk", 	maps\pakistan_anthem_approach::skipto_sewer_interior_perk, 		
	           &"sewer_interior_perk", 		maps\pakistan_anthem_approach::sewer_interior );
	
	add_skipto( "dev_sewer_interior_no_perk", maps\pakistan_anthem_approach::skipto_sewer_interior_no_perk, 		
	           &"sewer_interior_perk", 		maps\pakistan_anthem_approach::sewer_interior );	
	
	// section 2
	add_skipto( "anthem", 			::skipto_pakistan_2 );
	add_skipto( "roof_meeting", 	::skipto_pakistan_2 );
	add_skipto( "claw", 			::skipto_pakistan_2 );
	
	// section 3
	add_skipto( "escape_intro",		::skipto_pakistan_3 );
	add_skipto( "escape_battle",	::skipto_pakistan_3 );
	add_skipto( "escape_bosses",	::skipto_pakistan_3 );
	add_skipto( "warehouse",		::skipto_pakistan_3 );
	add_skipto( "hangar",			::skipto_pakistan_3 );
	add_skipto( "standoff",			::skipto_pakistan_3 );
	add_skipto( "dev_s3_script",	::skipto_pakistan_3 );
	add_skipto( "dev_s3_build",		::skipto_pakistan_3 );
	
	set_skipto_cleanup_func( ::skipto_cleanup );
}

skipto_pakistan_2()
{
	ChangeLevel( "pakistan_2", true );
}

skipto_pakistan_3()
{
	ChangeLevel( "pakistan_3", true );
}

/* ------------------------------------------------------------------------------------------
CHALLENGES
-------------------------------------------------------------------------------------------*/
setup_challenges()
{	
	self thread maps\_challenges_sp::register_challenge( "froggernohits", ::challenge_frogger_no_hits );
	self thread maps\_challenges_sp::register_challenge( "dronesonly", ::challenge_drones_only );
	self thread maps\_challenges_sp::register_challenge( "intel", ::challenge_find_all_intel );
	self thread maps\_challenges_sp::register_challenge( "dronekill",	::challenge_drone_kills );
}

challenge_drone_kills( str_notify )
{
	flag_wait( "section_3_started" );
		
	while ( true )
	{
		level waittill( "drone_kill" );
		self notify( str_notify );
	}
}

challenge_find_all_intel( str_notify )
{
	self waittill( "mission_finished" );
	
	has_player_collected_all = collected_all();
	
	if( has_player_collected_all )
	{
		debug_print_line( "challenge completed: " + str_notify );
		self notify( str_notify );		
	}	
}

challenge_frogger_no_hits( str_notify )
{
	level endon( "player_hit_by_frogger_debris" );
	
	flag_wait( "frogger_done" );
	
	debug_print_line( "challenge completed: " + str_notify );
	self notify( str_notify );
}

challenge_drones_only( str_notify )
{
	level endon( "player_used_gun" );
	
	self thread _challenge_drones_only_think();
	
	flag_wait( "frogger_done" );
	
	debug_print_line( "challenge completed: " + str_notify );
	self notify( str_notify );
}

_challenge_drones_only_think()
{
	level endon( "frogger_done" );
	level endon( "death" );
	
	while ( true )
	{
		self waittill( "weapon_fired", str_weapon );
		
		if ( str_weapon != "data_glove_sp" )
		{
			level notify( "player_used_gun" );
		}
	}
}

challenge_all_perks_used( str_notify )
{
	self waittill( "mission_finished" );
	
	b_player_used_all_perks = ( flag( "intruder_perk_used" ) && flag( "brute_force_perk_used" ) && flag( "lockbreaker_used" ) );
	
	if ( b_player_used_all_perks )
	{
		debug_print_line( "challenge completed: " + str_notify );
		self notify( str_notify );
	}
}

