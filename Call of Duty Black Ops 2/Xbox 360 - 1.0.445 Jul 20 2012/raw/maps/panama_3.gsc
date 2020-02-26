/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\panama_utility;

main()
{	
	// This MUST be first for CreateFX!	
	maps\panama_3_fx::main();
	
	level_precache();
	level_init_flags();
	setup_skiptos();

//	maps\_hiding_door::door_main();  // run this to enable the hiding_door scripts
//	maps\_hiding_door::window_main();  // run this to enable the hiding_window scripts
	
	//Shabs - Temp until new exe's are checked in with Laufer's fix
	level.supportsPistolAnimations = true;
	
	maps\_load::main();
	maps\panama_3_amb::main();
	maps\panama_3_anim::main();
	
	OnPlayerConnect_Callback( ::on_player_connect );

	// panama fog and post effects gsc
	maps\createart\panama3_art::main();
	
//	animscripts\dog_init::initDogAnimations();
	maps\_digbats::melee_digbat_init(); //TODO: Shabs - might not need this
//	maps\_drones::init();
//	maps\_civilians::init_civilians();
	array_thread( GetSpawnerArray(), ::add_spawn_function, maps\_digbats::setup_digbat );
	
	level thread setup_global_challenges();
	level thread setup_objectives();
	level thread maps\_objectives::objectives();
	
	//inits vehicle lights
	level._vehicle_load_lights = true;
	
	add_hint_string( "player_jump_hint", &"PANAMA_PLAYER_JUMP_PROMPT" );
	add_hint_string( "docks_warning", &"PANAMA_DOCKS_WARNING" );
	
	//enable battlechatter for allies and axis
	//battlechatter_on();
}

// self == player
on_player_connect()
{
	self thread setup_section_challenges();
}

level_precache()
{ 
	PreCacheItem( "barretm82_emplacement" );
	PreCacheItem( "barretm82_sp" );
	PreCacheItem( "ac130_vulcan_minigun" );
//	PreCacheItem( "ac130_howitzer_minigun" );
	PreCacheItem( "rpg_magic_bullet_sp" );
	PrecacheItem( "m1911_1handed_sp" );
	PrecacheItem( "barretm82_highvzoom_sp" );
	
	PrecacheItem( "rpg_player_sp" );
	PrecacheRumble( "angola_hind_ride");

	PreCacheModel( "c_usa_woods_panama_lower_dmg1_viewbody" );
	PreCacheModel( "c_usa_woods_panama_lower_dmg2_viewbody" );
	PreCacheModel( "veh_iw_mh6_littlebird" );
	PrecacheModel( "t6_wpn_machete_prop" );
	//PrecacheModel( "c_usa_seal80s_skinner_fb" );
	PrecacheModel( "t6_wpn_ir_strobe_world");

	PreCacheShader( "cinematic" );
	
	PreCacheRumble( "slide_rumble" );
	
	PrecacheString( &"PANAMA_FRIENDLY_FIRE_FAILURE");
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
	
	add_skipto( "slums_intro", 	::skipto_panama_2,	"Slums Intro"	);
	add_skipto( "slums_main",	::skipto_panama_2,	"Slums Main"	);
	
	add_skipto( "building", 	maps\panama_building::skipto_building,  	"Building",		maps\panama_building::main	 );
	add_skipto( "chase",	 	maps\panama_chase::skipto_chase,		  	"Chase",		maps\panama_chase::main		 );
	add_skipto( "checkpoint",	maps\panama_chase::skipto_checkpoint,		"Checkpoint",	maps\panama_chase::checkpoint_event );
	add_skipto( "docks", 		maps\panama_docks::skipto_docks, 			"Docks",		maps\panama_docks::main		 );
	add_skipto( "sniper",		maps\panama_docks::skipto_sniper,			"Sniper"						 			 );	
	
	default_skipto( "building" );
	
	set_skipto_cleanup_func( maps\panama_utility::skipto_setup );
}

skipto_panama()
{
	ChangeLevel( "panama", true );
}

skipto_panama_2()
{
	ChangeLevel( "panama_2", true );
}

/* ------------------------------------------------------------------------------------------
CHALLENGES
-------------------------------------------------------------------------------------------*/
setup_section_challenges() // self == player
{	
	//level specific challenges
    self thread maps\_challenges_sp::register_challenge( "clinicassault", ::challenge_docks_guards_speed_kill );
}

challenge_docks_guards_speed_kill( str_notify )
{
	level.total_digbat_killed = 0;
		
	level waittill("end_gauntlet");
	
	/#
		iprintln("total digbat killed : " + level.total_digbat_killed );
	#/
	
	if(level.total_digbat_killed >= 4)
	{
		self notify( str_notify );
	}
	
}