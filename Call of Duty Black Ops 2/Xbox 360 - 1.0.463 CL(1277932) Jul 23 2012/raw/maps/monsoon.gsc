#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\monsoon_util;
#include maps\_titus;
#include maps\_camo_suit;
#include maps\_glasses;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{
	// This MUST be first for CreateFX!
	maps\monsoon_fx::main();

	level_precache();
	level_init();
	level_init_flags();
	setup_objectives();
	setup_skiptos();
	
	maps\_metal_storm::init();
	maps\_heatseekingmissile::init();
	
	//overrides default introscreen function
	level.custom_introscreen = ::monsoon_custom_introscreen;
		
	// There should not be any waits before this function is called.  If you need a wait, make sure the function
	//	is either threaded or called after _load::main.
	maps\_load::main();

	maps\monsoon_anim::main();
	
	// init stealth logic and behavior
	maps\_stealth_logic::stealth_init( "rain" );
	maps\_stealth_logic::stealth_detect_corpse_range_set( 256, 128, 64 );
  	maps\_stealth_behavior::main();
  	maps\_patrol::patrol_init();
  	maps\monsoon_anim::custom_patrol_init();
  	
  	// run camo suit logic
  	array_thread( GetSpawnerArray(), ::add_spawn_function, ::setup_camo_suit_ai );
  	maps\_rusher::init_rusher();
  	
  	// run gas freeze logic
  	array_thread( GetSpawnerArray(), ::add_spawn_function, ::setup_gasfreeze_ai );
  		 	
  	// run logic on the outside lift
  	level thread outside_lift_init();
  	level thread sway_init();
  	
  	level thread maps\createart\monsoon_art::main();
  	
  	// Handles the updating of objectives
	level thread maps\_objectives::objectives();
	
	OnPlayerConnect_Callback( ::on_player_connect );	
	
	//dvars for the mud
	SetSavedDvar( "r_waterWaveAngle", "40 120 205 302" );
	SetSavedDvar( "r_waterWaveWavelength", "275 358 206 431" );
	SetSavedDvar( "r_waterWaveAmplitude", "1.25 2.5 1.5 2" );
	SetSavedDvar( "r_waterWaveSteepness", "1 1 1 1" );
	SetSavedDvar( "r_waterWaveSpeed", "0.8 1.35 0.675 1.125" );
	
	//immediate fade to black to hide gump loading
	screen_fade_out( 0 ); 
	
}

monsoon_custom_introscreen( string1, string2, string3, string4, string5 )
{
	level.introstring = []; 

	//wait for player to connect and one of the gumps to finish loading
	flag_wait( "all_players_connected" );
	flag_wait_either( "monsoon_gump_exterior", "monsoon_gump_interior" );
	
	// Fade out black
	screen_fade_in( 1 );
	
	//TODO put this flagset on a notetrack
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

on_player_connect()
{
	level.player = get_players()[0];
	level.player setup_challenges();
	level.player thread heli_evade();
	level.player thread player_dualoptic_tutorial();
	
	level thread bruteforce_perk_asd();	
}

setup_skiptos()
{
	//-- Skipto's.  These set up skipto points as well as set up the flow of events in the level.  See module_skipto for more info
	add_skipto( "intro", 			maps\monsoon_intro::skipto_intro, 			"Intro",  		 		maps\monsoon_intro::main 				);
	add_skipto( "harper_reveal", 	maps\monsoon_intro::skipto_harper_reveal,	"Harper Reveal",  	 	maps\monsoon_intro::main 				);
	add_skipto( "rock_swing", 		maps\monsoon_intro::skipto_rock_swing,	 	"Rock Swing",  	 		maps\monsoon_intro::main 				);
	add_skipto( "suit_jump",		maps\monsoon_intro::skipto_suit_jump,	 	"Suit Jump",  			maps\monsoon_intro::main			 	);
	add_skipto( "suit_flying",		maps\monsoon_wingsuit::skipto_suit_fly, 	"Suit Flying",  		maps\monsoon_wingsuit::wingsuit_main 	);
	add_skipto( "camo_intro", 		maps\monsoon_wingsuit::skipto_camo_intro, 	"Camo Intro",  			maps\monsoon_wingsuit::camo_intro_main  ); 
	
	add_skipto( "camo_battle", 		maps\monsoon_ruins::skipto_camo_battle, 	"Camouflage_Battle", 	maps\monsoon_ruins::camo_battle_main 	);
	add_skipto( "helipad_battle", 	maps\monsoon_ruins::skipto_helipad_battle,	"Helipad Battle", 		maps\monsoon_ruins::helipad_battle_main	);
	add_skipto( "outer_ruins", 		maps\monsoon_ruins::skipto_outer_ruins, 	"Outer Ruins", 			maps\monsoon_ruins::outer_ruins_main	);
	add_skipto( "inner_ruins", 		maps\monsoon_ruins::skipto_inner_ruins, 	"Inner Ruins", 			maps\monsoon_ruins::inner_ruins_main	);
	add_skipto( "ruins_interior", 	maps\monsoon_ruins::skipto_ruins_interior, 	"Ruins Interior", 		maps\monsoon_ruins::ruins_interior_main );
	
	add_skipto( "lab", 				maps\monsoon_lab::skipto_lab,				"Lab", 					maps\monsoon_lab::lab_main		  				); 
	add_skipto( "lab_battle", 		maps\monsoon_lab::skipto_lab_battle,		"Lab Battle", 			maps\monsoon_lab::lab_battle_main	    		);
	add_skipto( "fight_to_isaac", 	maps\monsoon_lab::skipto_fight_to_isaac,	"Lab Battle", 			maps\monsoon_lab::fight_to_isaac_main	    	);
	add_skipto( "lab_defend", 		maps\monsoon_lab_defend::skipto_lab_defend,	"Lab Defend", 			maps\monsoon_lab_defend::lab_defend_main 		);
	add_skipto( "celerium_chamber", maps\monsoon_celerium_chamber::skipto_celerium,	"Celerium Chamber", maps\monsoon_celerium_chamber::celerium_chamber_main 		);

	default_skipto( "intro" );
	
	set_skipto_cleanup_func( maps\monsoon_util::skipto_setup );	
}

//
// All precache calls go here
level_precache()
{	
	// Player Arms
	PreCacheModel( "c_usa_cia_masonjr_viewhands_cl" );
	
	// SECTION 1
	PrecacheRumble( "monsoon_harper_swing" );
	PrecacheRumble( "monsoon_player_swing" );
	PrecacheRumble( "monsoon_gloves_impact" );
	
	// SECTION 2
	PrecacheItem( "scar_dualoptic_silencer_sp" );
	PrecacheModel( "ctl_light_spotlight_generator_on" );
	PrecacheModel( "p6_stadium_light_pole_on" );
	PrecacheModel( "p6_container_yard_light_on" );
	PrecacheModel( "ctl_spotlight_modern_3x_on" );
	PrecacheModel( "ctl_light_spotlight_generator_off" );
	PrecacheModel( "p6_stadium_light_pole_off" );
	PrecacheModel( "p6_container_yard_light_off" );
	PrecacheModel( "ctl_spotlight_modern_3x_off" );
	
	PrecacheItem( "emp_grenade_monsoon_sp" );
	
	PrecacheString( &"hud_update_vehicle" );

	// SECTION 3
	PreCacheItem( "rpg_magic_bullet_sp" );
	PreCacheItem( "rpg_player_sp" );
	PreCacheItem( "metalstorm_launcher" );
	PrecacheItem( "riotshield_sp" );
	PrecacheItem( "qcw05_sp" );
	
	PrecacheModel( "t6_wpn_shield_carry_world" );	
	PrecacheModel( "p6_celerium_chip" );
	PreCacheModel( "p6_asd_charger_door" );
	
	PrecacheRumble( "tank_rumble" );
	PrecacheModel( "veh_t6_drone_asd_freeze" );
	
	maps\_camo_suit::precache();
}

//anything for the level that needs to run at the start
level_init()
{
	//move the destroyed blocker for the ruins
	trigger_off( "ruins_blocker", "targetname" );
	
	//move the destroyed archway
	m_archway = GetEnt( "heli_rocket_gate_collapse", "targetname" );
	m_archway trigger_off();
	m_archway ConnectPaths();	
	
	//turn on all the lights in the EMP area
	a_lights = GetEntArray( "emp_light", "targetname" );
	foreach( light in a_lights )
	{
		light SetLightIntensity( 32 );
	}
	
	//hide destroyed versions of ruins
	a_m_hide[0] = GetEnt( "ruins_gate_destroyed", "targetname" );
	a_m_hide[1] = GetEnt( "ruins_pagoda_left_destroyed", "targetname" );
	a_m_hide[2] = GetEnt( "ruins_pagoda_right_destroyed", "targetname" );
	a_m_hide[3] = GetEnt( "temple_doors_destroyed", "targetname" );
	a_m_hide[4] = GetEnt( "terrain_slide_left", "targetname" );
	a_m_hide[5] = GetEnt( "cliff_slide_left", "targetname" );
	foreach( m_hide in a_m_hide )
	{
		m_hide Hide();
	}	
	
	trig_player_riotshield = GetEnt( "trig_player_riotshield", "targetname" );
	trig_player_riotshield trigger_off();
	
	a_defend_crash_show = GetEntArray( "defend_crash_show", "targetname" );
	foreach( crash_piece in a_defend_crash_show )
	{
		crash_piece Hide();
	}			
	
	a_defend_pillar_show = GetEntArray( "defend_pillar_show", "targetname" );
	foreach( piece in a_defend_pillar_show )
	{
		piece Hide();
	}			
	
	trig_player_celerium = GetEnt( "trig_player_celerium", "targetname" );
	trig_player_celerium trigger_off();		
	
	trig_isaac_player = GetEnt( "trig_isaac_player", "targetname" );
	trig_isaac_player trigger_off();	

	m_lift = GetEnt( "lift_interior", "targetname" );
	m_lift SetMovingPlatformEnabled( true );
	
	//link use trigger
	trig_elevator_panel = GetEnt( "trig_elevator_panel", "targetname" );
	trig_elevator_panel EnableLinkTo();
	trig_elevator_panel LinkTo( m_lift );
	trig_elevator_panel SetHintString( &"MONSOON_LIFT_PROMPT" );
	trig_elevator_panel SetCursorHint( "HINT_NOICON" );
	trig_elevator_panel trigger_off();
	
	trig_ddm_regroup = GetEnt( "trig_ddm_regroup", "targetname" );
	trig_ddm_regroup trigger_off();	
	
	trig_player_celerium_door = GetEnt( "trig_player_celerium_door", "targetname" );
	trig_player_celerium_door trigger_off();
	
	level.metalstorm_freeze_death = true;
}