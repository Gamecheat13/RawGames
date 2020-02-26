/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\panama_utility;

main()
{	
	// This MUST be first for CreateFX!	
	maps\panama_fx::main();
	
	level_precache();
	level_init_flags();
	setup_skiptos();

	//overrides default introscreen function
	level.custom_introscreen = ::panama_custom_introscreen;
	
	maps\_hiding_door::door_main();  // run this to enable the hiding_door scripts
	maps\_hiding_door::window_main();  // run this to enable the hiding_window scripts

	level.swimmingFeature = false;	
	
	maps\_load::main();
	maps\panama_amb::main();
	maps\panama_anim::main();

	// To run the stealth script on the players
	level thread onPlayerConnect();	
			

	maps\_stealth_logic::stealth_init();                
	
	maps\_stealth_behavior::main();
	
		// panama fog and post effects gsc
	maps\createart\panama_art::main();
	
	animscripts\dog_init::initDogAnimations();
	maps\_digbats::melee_digbat_init();
	maps\_drones::init();
	
	//inits vehicle lights
	level._vehicle_load_lights = true;
	
	array_thread( GetSpawnerArray(), ::add_spawn_function, maps\_digbats::setup_digbat );

	init_fade_settings();
	
	maps\_civilians::init_civilians();
	
	SetSavedDvar("phys_buoyancy", 1);  // this enables buoyant physics objects in Radiant (our boat)
	SetSavedDvar("phys_ragdoll_buoyancy", 1);  // this enables ragdoll corpses to float. Note required, but fun.    

	level thread setup_challenges();
	level thread setup_objectives();
	level thread maps\_objectives::objectives();

	add_hint_string( "contextual_kill", &"PANAMA_CONTEXTUAL_KILL" );
	add_hint_string( "street_warning", &"PANAMA_STREET_WARNING" );
	add_hint_string( "hangar_warning", &"PANAMA_HANGAR_WARNING" );	
	add_hint_string( "player_jump_hint", &"PANAMA_PLAYER_JUMP_PROMPT" );
	add_hint_string( "docks_warning", &"PANAMA_DOCKS_WARNING" );
	
	//battlechatter_on();
}

onPlayerConnect()
{
	while ( true )
	{
		
		level waittill( "connecting", e_player );

		e_player.team = "allies";	// MUST have a team "axis" or "allies"

		wait 2;	// for some reason, the stealth script detects the player as
						// "dead" or "undefined immediately after joining. Waiting 2 seconds
						// solves the problem. (1 sec does not) Needs resolving.

		e_player thread stealth_ai();	
	}
}

panama_custom_introscreen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 

	introblack = NewHudElem(); 
	introblack.x = 0; 
	introblack.y = 0; 
	introblack.horzAlign = "fullscreen"; 
	introblack.vertAlign = "fullscreen"; 
	introblack.foreground = true;
	introblack SetShader( "black", 640, 480 );

	flag_wait("all_players_connected");

	introblack thread intro_hud_fadeout();

	//notify from intro animation sent from event_1_info_screen in vorkuta_mine.gsc
//	level waittill("show_level_info");
	flag_wait( "show_introscreen_title" );

	pausetime = 0.75;
	totaltime = 14.25;
	time_to_redact = ( 0.525 * totaltime);
	rubout_time = 1;
	color = (1,1,1);

	delay_between_redacts_min = 350; // this is a slight pause added when redacting each line, so it isn't robotically smooth
	delay_between_redacts_max = 500;

	start_rubout_time = Int( time_to_redact*1000 );// convert to miliseconds and fraction of total time to start rubbing out the text
	totalpausetime = 0; // track how much time we've waited so we can wait total desired waittime
	rubout_time = Int(rubout_time*1000); // convert to miliseconds 

	// following 2 lines are used in and logically could exist in isdefined(string1), but need to be initialized so exist here
	redacted_line_time = Int( 1000* (totaltime - totalpausetime) ); // each consecutive line waits the total time minus the total pause time so far, so they all go away at once.

	if( IsDefined( string1 ) )
	{
		level thread maps\_introscreen::introscreen_create_redacted_line( string1, redacted_line_time, start_rubout_time, rubout_time, color ); 

		wait( pausetime );
		totalpausetime += pausetime;	
	}

	if( IsDefined( string2 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string2, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string3 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);	
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string3, redacted_line_time,  start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	if( IsDefined( string4 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) )	+ RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);		
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
	
		level thread maps\_introscreen::introscreen_create_redacted_line( string4, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}		

	if( IsDefined( string5 ) )
	{
		start_rubout_time = Int ( (start_rubout_time + rubout_time) - (pausetime*1000) ) + RandomIntRange(delay_between_redacts_min, delay_between_redacts_max);			
		redacted_line_time = int( 1000* (totaltime - totalpausetime) );
		
		level thread maps\_introscreen::introscreen_create_redacted_line( string5, redacted_line_time, start_rubout_time, rubout_time, color);

		wait( pausetime ); 	
		totalpausetime += pausetime;
	}

	wait (totaltime - totalpausetime);

	//default wait time
	wait 2.5;

	level notify("introscreen_done");
	
	// Fade out text
	maps\_introscreen::introscreen_fadeOutText(); 
}

intro_hud_fadeout()
{
	wait(0.2);
		// Fade out black
	self FadeOverTime( 0.5 ); 
	self.alpha = 0; 
	
	wait 0.5;
	self Destroy();
}

level_precache()
{ 
	PreCacheItem( "barretm82_emplacement" );
	PreCacheItem( "ac130_vulcan_minigun" );
	PreCacheItem( "ac130_howitzer_minigun" );
	PreCacheItem( "rpg_magic_bullet_sp" );
	PreCacheItem( "irstrobe_sp" );
	PreCacheItem( "nightingale_sp" );
	PreCacheItem( "epipen_sp" );
	PreCacheItem( "ak47_gl_sp" );	
	PreCacheItem( "gl_ak47_sp" );
	PreCacheItem( "knife_held_sp" ); //contextual melee knife
	PrecacheItem( "rpg_sp" );
	
	
	PreCacheModel( "p6_anim_burlap_sack" );	
	PreCacheModel( "t6_wpn_molotov_cocktail_prop_world" );
	PreCacheModel( "c_usa_woods_panama_lower_dmg1_viewbody" );
	PreCacheModel( "c_usa_woods_panama_lower_dmg2_viewbody" );
	PreCacheModel( "veh_iw_mh6_littlebird" );
	PrecacheModel( "c_usa_seal80s_skinner_fb" );

	PreCacheShader( "cinematic" );

	PrecacheModel( "p6_anim_hangar_hatch" );
	PreCacheModel( "p6_anim_cloth_pajamas" );
	PreCacheModel( "p6_anim_duffle_bag" );
	PreCacheModel( "c_usa_jungmar_pow_barnes" );
	PreCacheModel( "p6_anim_beer_pack" );
	PreCacheModel( "c_usa_jungmar_barnes_pris_body" );
	PreCacheModel( "c_usa_jungmar_barnes_pris_head" );
	
	PreCacheModel( "veh_t6_air_private_jet" );
	PreCacheModel( "veh_t6_air_private_jet_dead" );	
	
	//setting up the mig's bombs through it's vehicle script	
	maps\_mig17::mig_setup_bombs( "plane_mig23" );		
}

setup_skiptos()
{
	//-- Skipto's.  These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
	add_skipto( "house", 		maps\panama_house::skipto_house, 			"House",				maps\panama_house::main      );
	add_skipto( "zodiac",		maps\panama_airfield::skipto_zodiac, 		"Zodiac Approach",		maps\panama_airfield::zodiac_approach_main );
	add_skipto( "beach",		maps\panama_airfield::skipto_beach, 		"Beach",				maps\panama_airfield::beach_main );
	add_skipto( "runway",		maps\panama_airfield::skipto_runway, 		"Runway Standoff", 		maps\panama_airfield::runway_standoff_main   );	
	add_skipto( "learjet",		maps\panama_airfield::skipto_learjet, 		"Lear Jet",				maps\panama_airfield::learjet_main   );		
	add_skipto( "motel", 		maps\panama_motel::skipto_motel,  			"Motel", 				maps\panama_motel::main 	 );
	add_skipto( "slums_intro", 	maps\panama_slums::skipto_slums_intro,  	"Slums Intro",	maps\panama_slums::intro 	 );
	add_skipto( "slums_main",	maps\panama_slums::skipto_slums_main,		"Slums Main",	maps\panama_slums::main  	 );
	add_skipto( "building", 	maps\panama_building::skipto_building,  	"Building",		maps\panama_building::main	 );
	add_skipto( "chase",	 	maps\panama_chase::skipto_chase,		  	"Chase",		maps\panama_chase::main		 );
	add_skipto( "checkpoint",	maps\panama_chase::skipto_checkpoint,	"Checkpoint",		maps\panama_docks::main		 );
	add_skipto( "docks", 		maps\panama_docks::skipto_docks, 			"Docks",		maps\panama_docks::main		 );
	add_skipto( "sniper",		maps\panama_docks::skipto_sniper,			"Sniper"						 			 );
	
	default_skipto( "house" );
	
	set_skipto_cleanup_func( maps\panama_utility::skipto_setup );
}

