/*
 	TEAM PANAMA 2
 	
	Scripters: Kevin Drew, Damoun Shabestari
	Builders: Lia Tjiong
	Prod: Shane Sasaki
	Animation: Jon Stoll, Ernie Urzua
*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\panama_utility;
#include maps\yemen_wounded;

main()
{	
	// This MUST be first for CreateFX!	
	maps\panama_2_fx::main();
	
	level_precache();
	level_init_flags();
	setup_skiptos();

	maps\_hiding_door::door_main();  // run this to enable the hiding_door scripts
	maps\_hiding_door::window_main();  // run this to enable the hiding_window scripts
	
	//Shabs - Temp until new exe's are checked in with Laufer's fix
	level.supportsPistolAnimations = true;
	
	maps\_load::main();
	maps\panama_2_amb::main();
	maps\panama_2_anim::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );

	// panama fog and post effects gsc
	maps\createart\panama_art::main();
	
	animscripts\dog_init::initDogAnimations();
	maps\_digbats::melee_digbat_init();
	maps\_drones::init();
	maps\_civilians::init_civilians();
	array_thread( GetSpawnerArray(), ::add_spawn_function, maps\_digbats::setup_digbat );
	
	level thread setup_global_challenges();
	level thread setup_objectives();
	level thread maps\_objectives::objectives();
	
	//inits vehicle lights
	level._vehicle_load_lights = true;
	
	//enable battlechatter for allies and axis
	//battlechatter_on();
}

// self == player
on_player_connect()
{
	setup_section_challenges();
}

level_precache()
{ 
	PreCacheItem( "ac130_vulcan_minigun" );
	PreCacheItem( "ac130_howitzer_minigun" );
	PreCacheItem( "rpg_magic_bullet_sp" );
	PreCacheItem( "irstrobe_dpad_sp" );
	PreCacheItem( "nightingale_dpad_sp" );
	PreCacheItem( "epipen_sp" );
	PreCacheItem( "ak47_gl_sp" );	
	PreCacheItem( "gl_ak47_sp" );
	PrecacheItem( "rpg_sp" );
	
	PreCacheModel( "t6_wpn_molotov_cocktail_prop_world" );
	PreCacheModel( "t6_wpn_crowbar_prop" );
	PreCacheModel( "c_pan_noriega_sack");
	PreCacheModel( "c_pan_noriega_cap" );

	PreCacheShader( "cinematic" );
	
	//setting up the mig's bombs through it's vehicle script	
	maps\_mig17::mig_setup_bombs( "plane_mig23" );		
}

setup_skiptos()
{
	//-- Skipto's.  These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
	add_skipto( "house", 		::skipto_panama,	"House"				);
	add_skipto( "zodiac",		::skipto_panama,	"Zodiac Approach"	);
	add_skipto( "beach",		::skipto_panama,	"Beach"				);
	add_skipto( "runway",		::skipto_panama,	"Runway Standoff" 	);	
	add_skipto( "learjet",		::skipto_panama,	"Lear Jet"			);		
	add_skipto( "motel", 		::skipto_panama,	"Motel" 			);
	
	add_skipto( "slums_intro", 	maps\panama_slums::skipto_slums_intro,  	"Slums Intro",	maps\panama_slums::intro 	 );
	add_skipto( "slums_main",	maps\panama_slums::skipto_slums_main,		"Slums Main",	maps\panama_slums::main  	 );
	
	add_skipto( "building", 	::skipto_panama_3,	"Building"		);
	add_skipto( "chase",	 	::skipto_panama_3,	"Chase"			);
	add_skipto( "checkpoint",	::skipto_panama_3,	"Checkpoint"	);
	add_skipto( "docks", 		::skipto_panama_3,	"Docks"			);
	add_skipto( "sniper",		::skipto_panama_3,	"Sniper"		);
	
	default_skipto( "slums_intro" );
	
	set_skipto_cleanup_func( maps\panama_utility::skipto_setup );
}

skipto_panama()
{
	ChangeLevel( "panama", true );
}

skipto_panama_3()
{
	ChangeLevel( "panama_3", true );
}

/* ------------------------------------------------------------------------------------------
CHALLENGES
-------------------------------------------------------------------------------------------*/
setup_section_challenges() // self == player
{
	//perk challenges
//	self thread maps\_challenges_sp::register_challenge( "rescuesoldier", maps\panama_slums::challenge_rescue_soldier );
//	self thread maps\_challenges_sp::register_challenge( "findweaponcache", maps\panama_slums::challenge_find_weapon_cache );
	
	//level specific challenges
	self thread maps\_challenges_sp::register_challenge( "destroyzpu", maps\panama_slums::challenge_destroy_zpu );
//	self thread maps\_challenges_sp::register_challenge( "grenadecombo", maps\panama_slums::challenge_grenade_combo );
}