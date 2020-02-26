/*
	
	PUT NEED TO KNOW LEVEL INFO UP HERE

*/

#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\angola_utility;

main()
{
  //this must be loaded first
	maps\angola_fx::main();
	setup_objectives();

	melee_mpla_init();
	level_precache();

	level_init_flags();

	
	setup_skipto();
	//-- Skipto's.  These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info

	//overrides default introscreen function
	level.custom_introscreen = ::angola_custom_introscreen;
	
	maps\_load::main();
	maps\_drones::init();  // required for drones to function
	
	maps\angola_amb::main();
	maps\angola_anim::main();
	
	array_thread( GetSpawnerArray(), ::add_spawn_function, maps\_mpla_unita::setup_mpla );
	
	//SetSavedDvar("phys_buoyancy", 1);  // this enables buoyant physics objects in Radiant (our boat)
	//SetSavedDvar("phys_ragdoll_buoyancy", 1);  // this enables ragdoll corpses to float. Note required, but fun. 
	
	level thread maps\_objectives::objectives();
	level thread maps\createart\angola_art::main();
	level thread setup_challenges();
}

setup_skipto()
{
	
	add_skipto( "riverbed_intro", 		maps\angola_riverbed::skipto_riverbed_intro, 		"Riverbed Intro",	maps\angola_riverbed::riverbed_intro );
	add_skipto( "riverbed",				maps\angola_riverbed::skipto_riverbed,				"Riverbed",			maps\angola_riverbed::riverbed );
	add_skipto( "savannah_start", 		maps\angola_savannah::skipto_savannah_start,		"Savannah Start",	maps\angola_savannah::savannah_start );
	add_skipto( "savannah_hill", 		maps\angola_savannah::skipto_savannah_hill,			"Savannah Hill",	maps\angola_savannah::savannah_hill );
	add_skipto( "savannah_finish", 		maps\angola_savannah::skipto_savannah_finish,		"Savannah Finish",	maps\angola_savannah::savannah_finish );
	add_skipto( "river", 				::angola_2_skipto);
	add_skipto( "boat_fight", 			::angola_2_skipto);
	add_skipto( "jungle_stealth", 		::angola_2_skipto);
	add_skipto( "village", 				::angola_2_skipto);
	add_skipto( "jungle_escape", 		::angola_2_skipto);
	//add_skipto( "debug_heli_strafe", 	maps\angola_savannah::skipto_debug_heli_strafe,			"Savannah Hill",	maps\angola_savannah::savannah_hill );
	
	default_skipto( "riverbed_intro" );
	
	set_skipto_cleanup_func( maps\angola_utility::skipto_setup );
}

angola_2_skipto()
{
	ChangeLevel("angola_2", true);
}

//
// Put all precache calls here
level_precache()
{
	PrecacheModel( "t6_wpn_mortar_shell_prop_view" );
	PrecacheModel( "t6_wpn_launch_mm1_world" );
	PrecacheModel( "t6_wpn_ar_m16a2_prop_view" );
	PrecacheModel( "p6_tool_shovel" );
	PrecacheModel( "veh_t6_mil_buffelapc_window_xcam" );
	PrecacheModel( "veh_t6_mil_buffelapc_windshield_cracked01" );
	PrecacheModel( "veh_t6_mil_buffelapc_windshield_cracked02" );
	PrecacheModel( "veh_t6_mil_buffelapc_windshield_cracked03" );
	
	PrecacheModel( "veh_t6_mil_gaz66_cargo_door_left" );
	PrecacheModel( "veh_t6_mil_gaz66_cargo_door_right" );
	
	PrecacheItem( "mgl_sp" );
	PrecacheItem( "mortar_shell_dpad_sp" );
}

angola_custom_introscreen( string1, string2, string3, string4, string5 )
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

	// Fade out black
	wait 0.2;
	introblack FadeOverTime( 0.5 );
	introblack.alpha = 0; 
	wait 0.5;
	introblack Destroy();

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



