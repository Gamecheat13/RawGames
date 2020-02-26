
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\karma_metal_storm;
#include maps\_anim;
#include maps\_ai_rappel;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//
// USEFUL AI STUFF
//
// e_ai.fixednode = true;		// forces a guy to stay on a node
// node exposed					// Makes an ai fire aggressively
// script_forcerambo 1			// NODE: Puts AI into aggressive Rambo behaviour
// pacafist						// if true - the ai will not fire
// g_friendlyfiredist			// should control distance firendlies fire at
// ignoreme and ingoreall		// misc ai ignore params
// 



/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "reached_the_rocks_objective" );

	flag_init( "flag_use_left_bunker_spawners" );
	flag_init( "flag_use_right_bunker_spawners" );

	flag_init( "upper_left_stairs_spawners_active" );

	flag_init( "flag_bunker_snipers_active" );
	
	flag_init( "flag_reached_metal_storm" );

	flag_init( "event9_complete" );
}


//*****************************************************************************
// Need an AI to run something when spawned?  Put it here.
//*****************************************************************************

init_spawn_funcs()
{
//	add_spawn_function( "intro_drone", ::intro_drone );

	run_thread_on_noteworthy( "perk_id", ::add_spawn_function, ::ai_visible );
}


//*****************************************************************************
//	Need an AI to run something when spawned?  Put it here.
//*****************************************************************************

spawn_funcs()
{
}


//*****************************************************************************
// SKIPTO functions
//*****************************************************************************

skipto_little_bird()
{
//	init_hero( "hero_name_here" );

	start_teleport( "skipto_little_bird" );
	
	level.ai_han = init_hero_startstruct( "han", "e9_han_start" );
	level.ai_harper = init_hero_startstruct( "harper", "e9_harper_start" );
	level.ai_salazar = init_hero_startstruct( "salazar", "e9_salazar_start" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e9_redshirt1_start" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e9_redshirt2_start" );
	
	level.ai_karma = undefined;
	level.ai_defalco = undefined;

	level thread maps\createart\karma_art::karma_fog_sunset();
}


//*****************************************************************************
//	MAIN functions
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
//*****************************************************************************

main()
{
	// *** CHEAT ***
	level.e9_skip_beginning = false;
	//level.e9_skip_beginning = true;


	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/
//	level thread update_billboard( "Exit Club", "Little Bird Attack", "Small", "9" );

	// Initialization
//	spawn_funcs();
	maps\karma_2_anim::event_09_anims();

	level.player_rusher_jumper_dist = (42*6);			// 42*6
	level.player_rusher_vclose_dist = (42*7);			// 42*7
	level.player_rusher_fight_dist = (42*12);			// 42*12
	level.player_rusher_medium_dist = (42*15);			// 42*15
	level.player_rusher_player_busy_dist = (42*22);		// 42*22
	

	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************
	
	level.ai_han set_force_color( "r" );
	level.ai_redshirt1 set_force_color( "r" );
	level.ai_redshirt2 set_force_color( "r" );

	level.ai_harper set_force_color( "g" );
	level.ai_salazar set_force_color( "g" );


	//**************************
	// Switch on Outside Effects
	// Set Wind Magnitude
	//**************************

	exploder( 331 );		// Seagulls
	exploder( 801 );		// Ambient effects

	SetSavedDvar( "wind_global_vector", "213 148 -56" );


	//****************************
	// Gump load unique Animations
	//****************************
	
	load_gump( "karma_gump_9" );
	
	
	//**********************
	// Start the Engagements
	//**********************

	// Use the color system to move the friendly guys around
	level thread e9_start_friendly_movement();
	
	// Spawn the AI based on the which of the two enterances the player uses to enter event 9
	level thread e9_wave_spawning();
	
	// Objectives
	level thread little_bird_objectives();

	// Dialog
	init_event9_dialog();

	flag_wait( "event9_complete" );
}


//*****************************************************************************
//*****************************************************************************

init_event9_dialog()
{
	add_dialog( "get_to_the_rocks_nag1", "Mason, advance to the rocks past the swimming pool.  Defalco is escaping with Karma." );
	add_dialog( "get_to_the_rocks_nag2", "Mason, move now, advance past the rocks." );
}


//*****************************************************************************
// AI WAVES
//*****************************************************************************

e9_wave_spawning()
{
	//***********************************
	// Wave 1
	//***********************************

	str_category_startup = "e9_wave_1_startup";

	// Animation Threads
	level thread civilians_running_from_battle_anim( 2.5 );				// 0.5
	level thread civilian_group4_waiting_to_escape_anim( 4 );			// 3
	level thread civilian_left_stairs_group1_anim( 0.1 );
	level thread civilian_left_stairs_group2_anim( 2 );
	level thread civilian_balcony_fling_anim( 2 );						// 2

	// Helicopter Rappelling in guys at the start
	level thread helicopter_rappel_intro( 3 );

	if( level.e9_skip_beginning == false )
	{
		// If the player hangs around too much at the start, send rushers after him
		level thread e9_start_player_rushers( str_category_startup );
	
		// Enemy spawners
		level thread e9_bridge_runners( 1.5, str_category_startup );					// 0.5
		level thread e9_start_balcony_death_event( 0.5, 8 );							// 4, 8

		level thread e9_left_staircase_climbing_trigger( str_category_startup );

		level thread e9_keep_player_busy_at_start_trigger( str_category_startup );
	
		level thread e9_start_staircase_rpg_trigger( str_category_startup );
	
		level thread e9_left_staircase_begins_trigger( str_category_startup );
	
		level thread e9_player_reaches_bottom_left_stairs_trigger( str_category_startup );
		
		level thread e9_stairs_by_blockage_trigger( str_category_startup );
		
		level thread e9_cleanup_left_bunker_trigger();
	}
	
	// Triggers for Civs getting flushed out
	level thread e9_civ_rocks_right_trigger( 0.1 );
	
	
	//***********************************
	// Wave 2
	//***********************************

	wait( 0.5 );	// Helps level startup

	str_category_snipers = "e9_wave_2_snipers";

	if( level.e9_skip_beginning == false )
	{
		// The main spawn manager of the left stairs
		// Uses three separate triggers as the starts can be approached from multiple angles
		level thread e9_manager_upper_left_stairs_trigger( str_category_snipers );

		level thread e9_bunker_right_begin_trigger( str_category_snipers );
		level thread e9_rocks_right_shark_trigger( str_category_snipers );
		level thread e9_rocks_left_shark_trigger( str_category_snipers );
	
		level thread e9_strength_test_dude( "rocks_jump_down_guy1_trigger", str_category_snipers, 3 );
		level thread e9_strength_test_dude( "rocks_jump_down_guy2_trigger", str_category_snipers, 1 );

		level thread e9_left_upper_tunnel_spawner( str_category_snipers );

		level thread e9_left_stairs_approach_blocker_trigger( str_category_snipers );
		
		level thread e9_setup_balcony_explosion_blocker_triggers();

		level thread little_bird_attack_drinks_area();
	}
	
	level thread e9_bunker_enemy_management( str_category_snipers );
		

	//**************************
	//**************************
	// POST METAL STORM TRIGGERS
	//**************************
	//**************************
	
	//***********************************
	// Wave 3
	//***********************************

	str_category = "e9_wave_3_begins";

	level thread e9_post_ms_left_begin_trigger( str_category );
	level thread e9_post_ms_right_begin_trigger( str_category );
	
	str_category = "e9_wave_3_ongoing";
	
	level thread e9_post_ms_left_wave2_trigger( str_category );
	level thread e9_post_ms_right_wave2_trigger( str_category );
	
	level thread e9_post_ms_left_wave3_trigger( str_category );
	level thread e9_post_ms_right_wave3_trigger( str_category );


	//***********************************
	// Wave 4
	//***********************************

	str_category = "e9_wave_4_begins";

	level thread e9_enemy_end_stairs_left( str_category );
	level thread e9_enemy_end_stairs_right( str_category );
	
	
	//***********************************
	// Little Bird
	//***********************************

	//level thread little_bird_end_level();
}


//*****************************************************************************
// Event 9 OBJECTIVES
//*****************************************************************************

little_bird_objectives()
{
	wait( 0.25 );


	//*******************************
	// Setup the NAG mission failures
	//*******************************

	level thread advance_to_the_rocks_pacing();
	

	//**********************************************
	// Set objective for Player advancing past Rocks
	//**********************************************

	t_trigger_rocks = getent( "objective_advance_past_rocks_trigger", "targetname" );
	str_struct_name = t_trigger_rocks.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_ADVANCE_PAST_ROCKS, s_struct, "" );


	//**********************************************************
	// Save point when player activates the Snipers on the Rocks
	//**********************************************************
	
	level waittill( "start_sniper_objective" );
	wait( 0.01 );
	autosave_by_name( "e9_snipers" );


	//*********************************************
	// Wait for player to reach the rocks objective
	//*********************************************

	t_trigger_rocks waittill( "trigger" );
	set_objective( level.OBJ_ADVANCE_PAST_ROCKS, undefined, "delete" );
	flag_set( "reached_the_rocks_objective" );
	wait( 0.01 );


	//************************************
	// Savegame as player passes the rocks
	//************************************

	autosave_by_name( "e9_player_past_rocks" );


	//*******************************************
	// Objective stop Defalco escaping with Karma
	//*******************************************

	t_trigger_stop_defalco = getent( "objective_advance_stop_defalco_trigger", "targetname" );
	str_struct_name = t_trigger_stop_defalco.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJ_STOP_DEFALCO_ESCAPING_WITH_KARMA, s_struct, "" );
	t_trigger_stop_defalco waittill( "trigger" );
	set_objective( level.OBJ_STOP_DEFALCO_ESCAPING_WITH_KARMA, undefined, "delete" );


	//*****************
	// Cleanup - Part 1
	//*****************
	
	//IPrintLnBold( "Cleanup - Part 1" );
	cleanup_ents( "e9_wave_1_startup" );
	cleanup_ents( "e9_wave_2_snipers" );

	flag_set( "flag_reached_metal_storm" );

	wait( 0.01 );

	// Command friendlies to watch MS battle	
	level thread heros_watch_metal_storm_fight();

// TODO - Remove old script file
	//e_metal_storm = maps\karma_metal_storm::start_metal_storm( 0.1 );
	
// sb42
	//level thread metal_storm_2( 30 );
	
	e_metal_storm = spawn_vehicle_from_targetname( "metalstorm" );
		
	set_objective( level.OBJ_DESTROY_THE_METAL_STORM, e_metal_storm, "" );
	e_metal_storm waittill( "death" );
	set_objective( level.OBJ_DESTROY_THE_METAL_STORM, undefined, "delete" );

	wait( 0.01 );
	
	// Command friendlies ahead after MS battle	
	level thread heros_move_after_metal_storm_fight();


	//***************************
	// Set objective for Event9_2
	//***************************
	
	t_trigger = getent( "trigger_end_event9_2", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_9_2, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_9_2, undefined, "delete" );

	wait( 0.01 );


	//***************************
	// Set objective for Event9_3
	//***************************
	
	t_trigger = getent( "trigger_end_event9_3", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_9_3, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_9_3, undefined, "delete" );

	// End of Event 9 Cleanup
	cleanup_ents( "e9_wave_3_begins" );


	//***************************
	// Progress to Event 10
	//***************************
	
	// Gump load unique Animations before saving
	load_gump( "karma_gump_10" );

	autosave_by_name( "karma_little_bird" );
	wait( 0.05 );
	flag_set( "event9_complete" );
}


// sb42
metal_storm_2( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	e_metal_storm = spawn_vehicle_from_targetname( "metalstorm_2" );
}


//*****************************************************************************
// CLEAN UP: Any stray ents for the End of Level Animation in Event 10
//*****************************************************************************

cleanup_ents_for_event10_animation()
{
	cleanup_ents( "e9_wave_3_ongoing" );
	cleanup_ents( "e9_wave_4_begins" );
}


//*****************************************************************************
//*****************************************************************************

heros_watch_metal_storm_fight()
{
	t_trigger = getent( "color_metal_storm_begins_trigger" , "targetname" );
	t_trigger activate_trigger();
	//IPrintLnBold( "HEROS MOVE FORWARD 1" );
	
	level.ai_han.ignore_all = true;
	level.ai_harper.ignore_all = true;
	level.ai_salazar.ignore_all = true;
	level.ai_redshirt1.ignore_all = true;
	level.ai_redshirt2.ignore_all = true;
	
	wait( 1 );
	t_trigger delete();
}

heros_move_after_metal_storm_fight()
{
	t_trigger = getent( "color_metal_storm_ends_trigger" , "targetname" );
	t_trigger activate_trigger();
	//IPrintLnBold( "HEROS MOVE FORWARD 2" );
	
	level.ai_han.ignore_all = false;
	level.ai_harper.ignore_all = false;
	level.ai_salazar.ignore_all = false;
	level.ai_redshirt1.ignore_all = false;
	level.ai_redshirt2.ignore_all = false;

	wait( 1 );
	t_trigger delete();
}


//*****************************************************************************
//
//*****************************************************************************

e9_start_friendly_movement()
{
	wait( 0.1 );
	
	
	//***********************************
	// Get all the friendlies in an array
	//***********************************

	a_friendlies = [];
	a_friendlies[ a_friendlies.size ] = level.ai_salazar;
	a_friendlies[ a_friendlies.size ] = level.ai_redshirt2;
	a_friendlies[ a_friendlies.size ] = level.ai_han;
	a_friendlies[ a_friendlies.size ] = level.ai_harper;
	a_friendlies[ a_friendlies.size ] = level.ai_redshirt1;
	
	
	//**********************************************
	// Just eye candy at the start of the checkpoint
	//**********************************************

	for( i=0; i<a_friendlies.size; i++ )
	{
		ai_ent = a_friendlies[ i ];
		ai_ent.ignoreme = true;
		ai_ent.ignoreall = true;
	}

	
	//**********************************************
	// Right Side Cover nodes - Harper and Redshirt1
	//**********************************************

	nd_harper = getnode ( "e9_friendly_start_harper", "targetname" );
	nd_redshirt1 = getnode ( "e9_friendly_start_redshirt1", "targetname" );
	
	level.ai_harper.goalRadius = 32;
	level.ai_harper setgoalnode( nd_harper );
	
	level.ai_redshirt1.goalRadius = 32;
	level.ai_redshirt1 setgoalnode( nd_redshirt1 );
	
	
	//******************************************
	// Left Side Cover nodes - Han and Redshirt2
	//******************************************
	
	nd_han = getnode ( "e9_friendly_start_han", "targetname" );
	nd_redshirt2 = getnode ( "e9_friendly_start_redshirt2", "targetname" );
	
	level.ai_han.goalRadius = 32;
	level.ai_han setgoalnode( nd_han );

	level.ai_redshirt2.goalRadius = 32;
	level.ai_redshirt2 setgoalnode( nd_redshirt2 );


	//******************************************
	//******************************************

	nd_salazar = getnode ( "e9_friendly_start_salazar", "targetname" );

	level.ai_salazar.goalRadius = 32;
	level.ai_salazar setgoalnode( nd_salazar );

	
	//*****************************
	// Time for the battle to start
	//*****************************

	wait( 5 );	// 6
//	IPrintLnBold( "BATTLE START TIME" );

	for( i=0; i<a_friendlies.size; i++ )
	{
		ai_ent = a_friendlies[ i ];
		ai_ent.ignoreme = false;
		ai_ent.ignoreall = false;
	}
}


//*****************************************************************************
//*****************************************************************************

e9_bunker_right_begin_trigger( str_category )
{
	t_trigger = getent( "e9_bunker_right_begin_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	//IPrintLnBold( "Bunker Right Begin Spawners" );

	// RPG guy on balcony by the rocks
	a_ents = getentarray( "e9_bunker_rpg_spawner", "targetname" );
	if( IsDefined(a_ents) ) 
	{
		simple_spawn_script_delay( a_ents, ::spawn_fn_ai_run_to_target, 1, str_category, true, true );
	}
	
	// Animation of civilian executioner on the rocks
	level thread civilian_rocks_execution_anim( 0.01, str_category );
}


//*****************************************************************************
//
//*****************************************************************************

e9_bunker_enemy_management( str_category )
{
	level thread wait_for_linker_bunker_trigger( "e9_trigger_bunker_enemy_left_side", 
												 "flag_use_left_bunker_spawners", 
												 "bunker_spawnwers_triggered" );

	level thread wait_for_linker_bunker_trigger( "e9_bunker_right_side_trigger", 
												 "flag_use_right_bunker_spawners", 
												 "bunker_spawnwers_triggered" );

	
	level waittill( "bunker_spawnwers_triggered" );


	//*****************************************************************************
	// The snipers are triggered by both the left and right bunker spawner triggers
	//*****************************************************************************

	//IPrintLnBold( "Creating Bunker Enemies" );

	// Snipers - They use favourateenemy to target the player
	a_sp_ents = getentarray( "e9_bunker_enemy", "targetname" );
	if( IsDefined(a_sp_ents) ) 
	{
		a_ents = simple_spawn( a_sp_ents );
		for( i=0; i<a_ents.size; i++ )
		{
			a_ents[i] setup_bunker_enemy_params();
			add_cleanup_ent( str_category, a_ents[i] );
		}
	}
	
// sb42
	// TODO: THIS IS HARD CODED - remember the executioner is now one of these ents
	level.ai_sniper1 = a_ents[0];
	level.ai_sniper2 = a_ents[1];
	level.ai_sniper3 = a_ents[2];
	level.ai_sniper4 = a_ents[3];
	
	level notify( "start_sniper_objective" );
	
	flag_set( "flag_bunker_snipers_active" );
	
	
	//***********************************************
	// Spawn either the Left or Right Bunker Spawners
	//***********************************************
	
	if( flag("flag_use_left_bunker_spawners") )
	{
		//IPrintLnBold( "LEFT BUNKER SPAWNER" );
		str_spawn_manager = "e9_bunker_left_flank_manager";
		spawn_manager_enable( str_spawn_manager );
		level.e9_bunker_left_flank_manager = str_spawn_manager;
	}
	
	if( flag("flag_use_right_bunker_spawners") )
	{
		//IPrintLnBold( "RIGHT BUNKER SPAWNER" );
		//spawn_manager_enable( "e9_bunker_right_side_manager" );
		
		// RPG guy on balcony by the rocks
		a_ents = getentarray( "e9_past_rocks_right_rpg_spawner", "targetname" );
		if( IsDefined(a_ents) ) 
		{
			simple_spawn_script_delay( a_ents, ::spawn_fn_ai_run_to_target, 1, str_category, true, true );
		}
		
		// Smallish attack wave around the right side of the rocks
		a_ents = getentarray( "e9_right_rocks_wave1_spawner", "targetname" );
		if( IsDefined(a_ents) ) 
		{
			simple_spawn_script_delay( a_ents, ::spawn_fn_ai_run_to_target, 1, str_category, true, true );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

setup_bunker_enemy_params()
{
	self.favoriteenemy = level.player;
	self.attackeraccuracy = 1.0;
	//self.ignoreme = true;
}


//*****************************************************************************
//
//*****************************************************************************

wait_for_linker_bunker_trigger( str_trigger_name, str_spawner_flag, str_level_notify )
{
	level endon( str_level_notify );

	t_trigger = getent( str_trigger_name, "targetname" );
	t_trigger waittill( "trigger" );
	
	flag_set( str_spawner_flag );

	// This will kill the linked trigger
	level notify( str_level_notify );
}


//*****************************************************************************
//*****************************************************************************

e9_rocks_right_shark_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_rocks_right_shark_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "Right Shark Attack" );

	// Rushers
	sp_rusher = getent( "e9_rocks_right_shark_rusher_spawner", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_medium_dist, 0.02, 0.1, 1 );
	}

	// Exposed
	a_runners = getentarray( "e9_rocks_right_shark_exposed_spawner", "targetname" );
	if( IsDefined(a_runners) ) 
	{
		simple_spawn( a_runners, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_rocks_left_shark_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_rocks_left_shark_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "Left Shark Attack" );

	// Civs get flushed out
	level thread civ_run_from_node_to_node( 0.3, "stair_rush_girl_a", "e9_civ_rocks_mid_start", "e9_civ_rocks_mid_end" );
	level thread civ_run_from_node_to_node( 0.1, "stair_rush_guy1_a", "e9_civ_rocks_mid_2_start", "e9_civ_rocks_mid_end" );

	// Rushers
	sp_rushers = getentarray( "e9_rocks_left_shark_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_medium_dist, 0.02, 0.1, 1 );
		}
	}

	// Exposed
	a_runners = getentarray( "e9_rocks_left_shark_exposed_spawner", "targetname" );
	if( IsDefined(a_runners) ) 
	{
		simple_spawn( a_runners, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_start_player_rushers( str_category )
{
	level endon( "e9_player_in_pool_area" );

	level thread e9_wait_player_enters_pool_area( str_category );

	player_wait = 10.0;				// 8.5
	wait( player_wait );

	//IPrintLnBold( "1st Rusher Attack" );

	sp_rusher = getent( "e9_start_player_hurryup_1", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}


	// Delay before the 2nd rushers arrive

	wait( 12 );

	sp_rusher = getent( "e9_start_player_hurryup_2", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
	
	sp_rusher = getent( "e9_start_player_hurryup_3", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_wait_player_enters_pool_area( str_category )
{
	e_trigger = getent( "e9_player_enters_swimming_pool", "targetname" );
	e_trigger waittill( "trigger" );
	level notify( "e9_player_in_pool_area" );

	a_runners = getentarray( "e9_enter_swimming_pool_spawner", "targetname" );
	if( IsDefined(a_runners) ) 
	{
		simple_spawn_script_delay( a_runners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}
}


//*****************************************************************************
//
//*****************************************************************************

e9_bridge_runners( delay, str_category )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Creating Bridge Runner" );

	a_runners = getentarray( "e9_bridge_runner", "targetname" );
	if( IsDefined(a_runners) ) 
	{
		simple_spawn_script_delay( a_runners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}
}


//*****************************************************************************
//
//*****************************************************************************

e9_start_balcony_death_event( start_delay, battle_time )
{
	if( IsDefined(start_delay) )
	{
		wait( start_delay );
	}

	//IPrintLnBold( "STARTING ENEMY RUN" );

	// Setup the guy who does his balcony death
	a_sp_friendlys = getentarray( "e9_start_friendly_balcony_victim", "targetname" );
	a_ai_friendlys = simple_spawn( a_sp_friendlys );
	
	// Setup the enemy guards who run past the guard who falls to his death
	a_sp_enemys = getentarray( "e9_start_enemy_balcony_killer", "targetname" );
	if( IsDefined(a_sp_enemys) )
	{
		for( i=0; i<a_sp_enemys.size; i++ )
		{
			ai_enemy = simple_spawn_single( a_sp_enemys[i] );
			ai_enemy thread force_fire_at_balcony_friendly( a_ai_friendlys[i], a_sp_friendlys[0].target, a_sp_friendlys[1].target );
		}
	}
	
	// Make the Friendlies invulnerable for now
	for( i=0; i<a_ai_friendlys.size; i++ )
	{
		a_ai_friendlys[i].health = 11111;
		a_ai_friendlys[i].grenadeawareness = 0;
	}

	nd_explosion = getnode( a_ai_friendlys[0].target, "targetname" );

	wait( battle_time );

	// Kill the friendlies during the battle	
	for( i=0; i<a_ai_friendlys.size; i++ )
	{
		alive_time = randomfloatrange( 8, 11 );		// 4, 7
		a_ai_friendlys[i] thread entity_death_in_pose_after_time( alive_time, "stand" );
	}


	//****************************************
	// Play a bunch of explosion effects......
	//****************************************

	time = GetTime();
	explode_0_time = time + ( (alive_time*1000) / 100 );
	explode_1_time = time + ( (alive_time*1000) / 2.5 );
	explode_2_time = time + ( (alive_time*1000) + 1000 );


	//************
	// Explosion 0
	//************
	
	while( time < explode_0_time )
	{
		time = GetTime();
		wait( 0.01 );
	}

	pos = nd_explosion.origin;
	dir = AnglesToForward( nd_explosion.angles );
	right = AnglesToRight( nd_explosion.angles );
	pos = pos - (dir * (42*0.1)) - (right * (42*4));	// 7
	playfx( level._effect["def_explosion"], pos );


	//************
	// Explosion 1
	//************
	
	while( time < explode_1_time )
	{
		time = GetTime();
		wait( 0.01 );
	}

	pos = nd_explosion.origin;
	dir = AnglesToForward( nd_explosion.angles );
	right = AnglesToRight( nd_explosion.angles );
	pos = pos - (dir * (42*0.1)) - (right * (42*1.5));	// 4.5
	playfx( level._effect["def_explosion"], pos );

	exploder( 840 );

	
	//************
	// Explosion 2
	//************

	while( time < explode_2_time )
	{
		time = GetTime();
		wait( 0.01 );
	}

	pos = nd_explosion.origin;
	dir = AnglesToForward( nd_explosion.angles );
	right = AnglesToRight( nd_explosion.angles );
	pos = pos - (dir * (42*0.1)) - (right * (42*0.5));
	playfx( level._effect["def_explosion"], pos );
	
	exploder( 841 );
}


//*****************************************************************************
//
//*****************************************************************************

force_fire_at_balcony_friendly( ai_target, str_nd_target0, str_nd_target1 )
{
	self endon( "death" );

	// Get next node
	nd_node = getnode( str_nd_target0, "targetname" );
	nd_next_node = getnode( str_nd_target1, "targetname" );

	// Wait till we get to out target
	self.ignoreall = true;
	//self.ignoreme = true;
	self.goalRadius = 48;
	self.health = 300;
	self.allowPain = false;
	
	self setgoalnode( nd_node );
	self waittill( "goal" );
	
	//IPrintLnBold( "SHOOTING" );

	// Fire fake bolts
	self thread entity_fake_tracers( ai_target );
	
	while( IsDefined(ai_target) && (ai_target.health > 0) )
	{
		self.lastgrenadetime = GetTime();	// Should stop them using grenades
		//self.grenadeammo = 0;
		
		self thread shoot_at_target( ai_target, "J_head" );
		delay = randomfloatrange(0.3, 0.6);
		wait( delay );
	}
	
	// Move onto next target
//	IPrintLnBold( "GOT HIM" );
	self.allowPain = true;
	self.ignoreall = false;
	
	self setgoalnode( nd_next_node );
	self.goalradius = 48;
	
	self waittill( "goal" );
	
	self.goalRadius = 2048;
}


//*****************************************************************************
//*****************************************************************************

e9_keep_player_busy_at_start_trigger( str_category )
{
	start_time = gettime();
	last_ai_spawn_time = start_time;
	
	min_axis_alive = 3;
	min_spawn_wait_time = 20;
	
	volume = GetEnt( "keep_player_busy_at_start_volume", "targetname" );
	if( IsDefined(volume) )
	{
		while( 1 )
		{
			time= gettime();
			dt = (time - last_ai_spawn_time) / 1000;
			
			if( level.player IsTouching(volume) )
			{
				num_axis = 0;
				a_axis = getaiarray( "axis" );
				if( IsDefined(a_axis) )
				{
					num_axis = a_axis.size;
				}
			
				// Are we runninglow of enemies
				if( num_axis <= min_axis_alive )
				{
					// Is it a while since the player had some enemies thrown at him?
					if( dt > min_spawn_wait_time )
					{
						last_ai_spawn_time = time;

						//iprintlnbold( "DANNY IS BORED: SPAWN AI" );

						sp_rusher = getentarray( "e9_keep_player_bust_at_start_spawner", "targetname" );
						a_ai = simple_spawn( sp_rusher );
						if( IsDefined(a_ai) )
						{
							// To randomize things, only use the 1st 4 elements of the randomized array
							a_ai = array_randomize( a_ai );
							size = a_ai.size;
							if( size > 4 )
							{
								size = 4;
							}
							for( i=0; i<size; i++ )
							{
								a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_player_busy_dist, 0.02, 0.1, 1 );
							}
						}
					}
				}
				
				if( flag( "flag_bunker_snipers_active" ) )
				{
					//iprintlnbold( "No More Repeat Snipers" );
					return;
				}
			}

			if( dt < min_spawn_wait_time )
			{
				delay = min_spawn_wait_time - dt;
			}
			else
			{
				delay = randomfloatrange( 1.0, 3.0 );
			}
			wait( delay );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e9_left_staircase_climbing_trigger( str_category_startup )
{
	level endon( "metal_storm_cleanup" );

	t_trigger = getent( "e9_stairs_start_left_climbing_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	a_ents = getentarray( "e9_stairs_start_left_climbing_spawner", "targetname" );
	if( IsDefined(a_ents) ) 
	{
		//iprintlnbold ( "STAIRCASE CLIMBING SPAWNERS" );
		simple_spawn_script_delay( a_ents, ::spawn_fn_ai_run_to_target, 0, str_category_startup, false, false );
	}
}


//*****************************************************************************
// RPG Guys at the start by the staircase past the swimming pool area
//*****************************************************************************

e9_start_staircase_rpg_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	t_trigger = getent( "e9_start_staircase_rpg_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	// RPG Guy
	a_spawners = getentarray( "e9_left_stairs_rpg_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false );
		//ai_util_set_goal_radius_delay( "e9_left_stairs_rpg_spawner_ai", 4, 192, true );
	}
	
	// Misc Support Guys
	a_spawners = getentarray( "e9_staircase_rpg_runner_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, true, true );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_manager_upper_left_stairs_trigger( str_category )
{
	// Add spawn functions to the enemy spawners
	sp_guys = GetEntArray( "e9_stairs_start_upper_left_spawner", "targetname" );
	for( i=0; i<sp_guys.size; i++ )
	{
		sp_guys[i] add_spawn_function( ::spawn_fn_ai_run_to_target, undefined, str_category, false, false );
	}

	// Trigger(s) wait, multiple triggers needed because of the pool
	str_notify = "e9_manager_ul_stairs_notify";
	multiple_trigger_waits( "e9_manager_upper_left_stairs_trigger", str_notify );
	level waittill( str_notify );
	
	//iprintlnbold ( "UPPER LEFT STAIRS SPAWNERS" );

	// Add a Save Point
	autosave_by_name( "e9_upper_left_stairs" );
	
	flag_set( "upper_left_stairs_spawners_active" );

	// Switch on the spawn manager and wait for it to complete
	str_spawn_manager = "e9_manager_upper_left_stairs";
	level.stairs_spawn_manager = str_spawn_manager;
	spawn_manager_enable( str_spawn_manager );

	// Start the Single Rusher
	e_spawner = getent( "e9_bridge_rusher_spawner", "targetname" );
	e_ai = simple_spawn_single( e_spawner );
	e_ai thread player_rusher( str_category, undefined, (42*4), 0.02, 0.1, 1 );

	// Start the Left Stairs Sniper
	a_spawners = [];
	a_spawners[ a_spawners.size ] = getent( "e9_start_staircase_sniper_spawner", "targetname" );
	simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, true );
}


//*****************************************************************************
//*****************************************************************************

e9_left_upper_tunnel_spawner( str_category )
{
	level endon( "metal_storm_cleanup" );

	t_trigger = getent( "e9_left_stairs_enter_tunnel_trigger", "targetname" );
	t_trigger waittill( "trigger" );

	//IPrintLnBold( "TUNNEL SPAWNERS" );

	a_runners = getentarray( "e9_left_stairs_enter_tunnel_spawner", "targetname" );
	if( IsDefined(a_runners) ) 
	{
		simple_spawn_script_delay( a_runners, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_left_stairs_approach_blocker_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	t_trigger = getent( "e9_left_stairs_approach_blocker_trigger", "targetname" );
	t_trigger waittill( "trigger" );

	//IPrintLnBold( "Left Stairs Approach Blocker SPAWNERS" );

	a_holders = getentarray( "e9_left_stairs_approach_blocker_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}

	// Rushers
	sp_rushers = getentarray( "e9_left_stairs_approach_blocker_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
// self = guy
//*****************************************************************************

entity_fake_tracers( ent_target )
{
	self endon( "death" );
	ent_target endon( "death" );
	
	while( 1 )
	{
		base_height = 55;
		target_height = base_height + randomintrange( 15, 40 );
	
		start_pos = ( self.origin[0], self.origin[1], self.origin[2]+base_height );
		end_pos = ( ent_target.origin[0], ent_target.origin[1], ent_target.origin[2]+target_height );
		
		// Add 10 meters to end pos
		dir = VectorNormalize( end_pos - start_pos );
		end_pos = end_pos - ( dir * (42*2) );

		// Move along the side
		right = AnglesToRight( ent_target.angles );
		adj = randomfloatrange( -(42*1.5), (42*1.5) );
		end_pos = end_pos + ( right * adj );

		time = randomfloatrange( 0.45, 0.48 );	// 0.3, 0.36
		level thread karma_fake_tracer( start_pos, end_pos, time );

		delay = randomfloatrange( 0.20, 0.26 );
		wait( delay );
	}
}


//*****************************************************************************
//*****************************************************************************

karma_fake_tracer( start_pos, end_pos, alive_time )
{
	e_mover = spawn( "script_model", start_pos );
	e_mover SetModel( "tag_origin" );
	
	dir = end_pos - start_pos;
	dir = vectornormalize( dir );
	e_mover.angles = VectorToAngles( dir );
	
	PlayFXonTag( level._effect["fake_tracer"], e_mover, "tag_origin" );

	//end_pos = start_pos + (dir * (42*10) );
	e_mover moveto( end_pos, alive_time );

	wait( alive_time );

	// Removes fake mover ent and the attached effect	
	e_mover delete();
}



//*****************************************************************************
// self = level
//*****************************************************************************

make_ent_ignore_battle( str_targetname, use_magic_shield, delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	e_ent = getent( str_targetname, "targetname" );
	if( IsDefined(e_ent) )
	{
		e_ent.takedamage = false;
		e_ent.allowdeath = false;
		e_ent.ignoreme = true;
		e_ent.saved_health = e_ent.health;
		e_ent.health = 99999;
	
		if( IsDefined(use_magic_shield) )
		{
			e_ent magic_bullet_shield();
		}
	}
	else
	{
		iprintlnbold ( "Ent Missing: " + str_targetname );
	}
}


//*****************************************************************************
// self = level
//*****************************************************************************

make_ent_a_battle_target( str_targetname, magic_bullet_shield, delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	e_ent = getent( str_targetname, "targetname" );
	e_ent.takedamage = true;
	e_ent.allowdeath = true;
	e_ent.ignoreme = false;
	e_ent.health = e_ent.saved_health;
	
	if( IsDefined(magic_bullet_shield) )
	{
		e_ent stop_magic_bullet_shield();
	}
}


//*****************************************************************************
// self = level
//*****************************************************************************

ent_blood_trail( str_targetname, blood_delay, blood_time, blood_loop_wait )
{
	if( IsDefined(blood_delay) )
	{
		wait( blood_delay );
	}

	//IPrintLnBold( "Starting Blood Trail" );

	e_ent = getent( str_targetname, "targetname" );
	if( IsDefined(e_ent) )
	{
		start_time = gettime();
		end_time = start_time + (blood_time * 1000);
		
		time = start_time;
		while( time < end_time )
		{
			PlayFx( level._effect["blood_wounded_streak"], e_ent.origin );
			wait( blood_loop_wait );
			time = gettime();
		}
	}
	
	//IPrintLnBold( "Stoping Blood Trail" );
}


//*****************************************************************************
// self = level
//*****************************************************************************

little_bird_attack_drinks_area()
{
	str_attack_notify = "start_little_bird_attack_run";

	level thread lb_setup_multiple_trigger_waits( str_attack_notify );
	
	level waittill( str_attack_notify );

	//wait( 50 );
	//IPrintLnBold( "Helicopter Attack Run" );

	// Setup the FX noifies on the FX Anim explosion animation, when the helicopter blows the bar up
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "pillar_01_explode", ::bar_exploder1, "circle_bar" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "pillar_02_explode", ::bar_exploder2, "circle_bar" );
	maps\_anim::addNotetrack_customFunction( "fxanim_props", "rotunda_impact", ::bar_exploder3, "circle_bar" );
	//level.scr_anim["fxanim_props"]["circle_bar"] = %fxanim_karma_circle_bar_anim;


	// Start the helicopter down its attack path
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "little_bird" );
	e_heli thread helicopter_fly_down_attack_path( 1, 1, undefined, 15, "little_bird_strafe_attack_start", (42*1.5), true );

	// Fire Missiles
	wait( 1.0 );	//9
	
	e_heli thread lb_missile_burst();

	e_heli waittill( "missiles away" );

	// Blow up the bar
	wait( 0.2 );
	level notify( "fxanim_circle_bar_start" );
}

lb_setup_multiple_trigger_waits( str_attack_notify )
{
	a_triggers = getentarray( "spawn_helicopter_strafe_attack_trigger", "targetname");
	for( i=0; i<a_triggers.size; i++ )
	{
		level thread lb_attack_trigger_wait( a_triggers[i], str_attack_notify );
	}
}

lb_attack_trigger_wait( e_trigger, str_attack_notify )
{
	level endon( str_attack_notify );
	
	e_trigger waittill( "trigger" );
	
	level notify( str_attack_notify );
}

lb_missile_burst()
{
	self endon( "death" );

	a_targets = [];
	a_targets[ a_targets.size ] = getstruct( "lb_target_left0", "targetname" );
	a_targets[ a_targets.size ] = getstruct( "lb_target_left1", "targetname" );
	a_targets[ a_targets.size ] = getstruct( "lb_target_right0", "targetname" );
	a_targets[ a_targets.size ] = getstruct( "lb_target_right1", "targetname" );

	for( i=0; i<2; i++ )
	{
		wait( 0.5 );
		self thread lb_missile( a_targets[i].origin, 0.8 );

		// Screen Shake
		v_pos = a_targets[i].origin;
		scale = 0.4;
		duration = 0.6;
		radius = (42*60);
		level thread earthquake_delay( 0.8, scale, duration, v_pos, radius );
	}
	
	wait( 0.8 );
	
	for( i=2; i<4; i++ )
	{
		wait( 0.7 );
		self thread lb_missile( a_targets[i].origin, 0.6 );

		// Screen Shake
		v_pos = a_targets[i].origin;
		scale = 0.4;
		duration = 0.6;
		radius = (42*60);
		level thread earthquake_delay( 0.6, scale, duration, v_pos, radius );
	}
	
	self notify( "missiles away" );
}

// self = heli
lb_missile( target_pos, move_time )
{
	start_pos = self.origin;

	e_mover = spawn( "script_model", start_pos );
	e_mover SetModel( "tag_origin" );
	e_mover.angles = self.angles;

	PlayFxOnTag( level._effect["heli_missile_tracer"], e_mover, "tag_origin" );

	e_mover moveto( target_pos, move_time );
	
	wait( move_time );
	
	v_dir = anglestoforward( e_mover.angles );
	v_pos = e_mover.origin + (v_dir * (42*3));
	playfx( level._effect["def_explosion"], v_pos );
	
	e_mover delete();
}


//"projectileModel" "projectile_stinger_missile"
//"projTrailEffect" "fx\\weapon\\rocket\\fx_rocket_drone_geotrail.efx"


//*****************************************************************************
//*****************************************************************************

bar_exploder1( e_ent )
{
	//IPrintLnBold( "EXPLODER 1" );
	exploder( 913 );
}

bar_exploder2( e_ent )
{
	//IPrintLnBold( "EXPLODER 2" );
	exploder( 914 );
}

bar_exploder3( e_ent )
{
	//IPrintLnBold( "EXPLODER 3" );
	exploder( 915 );
}


//*****************************************************************************
//*****************************************************************************

e9_strength_test_dude( str_trigger, str_category, time_to_trigger_heli_attack )
{
	level endon( "strength_test_triggered" );

	e_trigger = getent( str_trigger, "targetname" );
	e_trigger waittill( "trigger" );
	
	//IPrintLnBold( "STRENGTH TEST ATTACK" );

	level thread strength_dude_helicopter_attack( time_to_trigger_heli_attack );
	
	str_attacker = "e9_strength_test_dude";
	str_node = e_trigger.target;
	strength_test_jumpdown_guy( str_node, str_attacker );
	
	//level thread save_when_strength_test_finished();
	wait( 0.01 );
	
	// Saving
	autosave_by_name( "strength_test_savepoint" );
	
	// Spawn the next wave of guys
	if( str_trigger == "rocks_jump_down_guy2_trigger" )		// Right
	{
		strength_post_right_ai_attack( str_category );
	}
	else													// Middle
	{
		strength_post_middle_ai_attack( str_category );
	}

	// Trigger the blockage cause by the helicopter attack
	level thread little_bird_blows_up_building( 3 );

	// Kill the jump down trigger threads
	level notify( "strength_test_triggered" );
}

spawn_post_strength_sharded_enemy( str_category, g0, g1, g2, g3 )
{
	if( g0 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g0_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
		}
	}
	if( g1 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g1_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
		}
	}
	if( g2 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g2_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
		}
	}
	if( g3 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g3_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
		}
	}
}

strength_post_right_ai_attack( str_category )
{
	spawn_post_strength_sharded_enemy( str_category, 1, 1, 1, 1 );

	a_spawners = getentarray( "e9_bunker_post_jumpdown_right_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}

	a_spawners = getentarray( "e9_post_jumpdown_rpg_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}
}

strength_post_middle_ai_attack( str_category )
{
	spawn_post_strength_sharded_enemy( str_category, 1, 1, 1, 1 );

	// Middle unique	
	a_spawners = getentarray( "e9_bunker_post_jumpdown_middle_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}

	// Middle hold
	a_spawners = getentarray( "e9_bunker_post_jumpdown_middle_hold_spawner", "targetname" );
	if( IsDefined(a_spawners) )
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}

	// Rushers
	sp_rusher = getentarray( "e9_bunker_post_jumpdown_middle_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rusher );
	if( IsDefined(a_ai) )
	{
		for( i=0; i<a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
	
	a_spawners = getentarray( "e9_post_jumpdown_rpg_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}
}

strength_dude_helicopter_attack( delay )
{
	level waittill( "nva_boom" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	t_ent = getentarray( "spawn_helicopter_strafe_attack_trigger", "targetname" );
	t_ent[0] activate_trigger();
}

save_when_strength_test_finished()
{
	level waittill( "strength_test_finished" );
	wait( 0.5 );
	autosave_by_name( "strength_test_savepoint" );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

e9_setup_balcony_explosion_blocker_triggers()
{
	e_triggers = getentarray( "e9_balcony_explosion_blocker_trigger", "targetname" );
	if( IsDefined(e_triggers) )
	{
		for( i=0; i<e_triggers.size; i++ )
		{
			e_triggers[i] thread e9_balcony_blocker_trigger();
		}
	}
}

e9_balcony_blocker_trigger()
{
	level endon( "balcony_blocker_away" );

	self waittill( "trigger" );
	
	//IPrintLnBold( "HELICOPTER ABOUT TO BLOWUP BUILDING" );
	
	delay = 0.01;
	if( IsDefined( self.script_delay) )
	{
		delay = self.script_delay;
	}
	
	level thread little_bird_blows_up_building( delay );
	
	wait( 1.5 );
	level notify( "balcony_blocker_away" );
}


//*****************************************************************************
//*****************************************************************************

e9_left_staircase_begins_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_left_staircase_begins_trigger", "targetname" );
	e_trigger waittill( "trigger" );
	
	//IPrintLnBold( "LEFT STAIRS BEGIN TRIGGERED" );
	
// sb42 - todo - get to work......
	level thread e9_civ_bridge_to_stairs( 0.8 );

	a_spawners = getentarray( "e9_left_staircase_begins_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_holding_node, 1, str_category, 1, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_player_reaches_bottom_left_stairs_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_player_reaches_bottom_left_stairs_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "PLAYER REACHES STAIRS TRIGGERED" );

	// Kill off the spawn manager for the stairs now we are close
	if( IsDefined(level.stairs_spawn_manager) )
	{
		if( is_spawn_manager_enabled(level.stairs_spawn_manager) )
		{
			//IPrintLnBold( "KILLING STAIRS SPAWN MANAGER" );
			spawn_manager_kill( level.stairs_spawn_manager );
		}
	}

	a_spawners = getentarray( "e9_player_reaches_bottom_left_stairs_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, 1, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_stairs_by_blockage_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_stairs_by_blockage_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "2nd Staircase TRIGGERED" );

	// Add a Save Point
	autosave_by_name( "e9_upper_left_stairs" );

	// Regular
	a_spawners = getentarray( "e9_stairs_by_blockage_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, 1, false );
	}
	
	// Middle hold
	a_spawners = getentarray( "e9_stairs_by_blockage_hold_spawner", "targetname" );
	if( IsDefined(a_spawners) )
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
}


//*****************************************************************************
// cleanup
//*****************************************************************************

e9_cleanup_left_bunker_trigger()
{
	e_trigger = getent( "e9_cleanup_left_bunker_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(level.e9_bunker_left_flank_manager) )
	{
		//IPrintLnBold( "Left bunker cleanup - TRIGGERED" );
		spawn_manager_kill( level.e9_bunker_left_flank_manager );
	}
}


//*****************************************************************************
// LITTLE BIRD - Blows up Blocker Building
//*****************************************************************************

little_bird_blows_up_building( delay )
{
	str_little_bird_targetname = "little_bird_explosion_blockage";

	//IPrintLnBold( "Little Bird: Delay = " + delay );

	// Soldiers run down staircase, coughing
	level thread e9_balcony_blowup_stairs_stumble_anim( 3 );

	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( str_little_bird_targetname );
	e_heli thread helicopter_fly_down_attack_path( 1, 1, undefined, 15, "little_bird_explosion_blockage_start", (42*2), true );
	
	// Soldiers thrown from building
	level thread e9_balcony_blowup_ledge_fall_anim( 2 );
	
	// Fire off some missiles
	e_heli thread lb_blocker_building_missile_burst( delay );
	e_heli waittill( "missiles away" );

	// Blowup the Blocker Building
	level notify( "fxanim_balcony_block_start" );
	
	// Balcony blowup effects
	level thread balcony_blowup_effects();
	
	// Screen Shake
	v_pos = (-777, 1501, -3068);
	scale = 0.45;
	duration = 1.5;
	radius = (42*60);
	earthquake_delay( 0.1, scale, duration, v_pos, radius );
}

balcony_blowup_effects()
{
	exploder( 844 );	// exp on inside and outside of room
	exploder( 845 );	// exp on outside only
	exploder( 846 );	// smoke billowing down stairwell
}

lb_blocker_building_missile_burst( delay )
{
	self endon( "death" );

	// Fire Missiles
	wait( 3.0 );

	a_targets = [];
	a_targets[ a_targets.size ] = getstruct( "lb_blocker_building_target0", "targetname" );
	a_targets[ a_targets.size ] = getstruct( "lb_blocker_building_target1", "targetname" );

	for( i=0; i<2; i++ )
	{
		wait( 0.75 );
		self thread lb_missile( a_targets[i].origin, 0.25 );
		
		// Screen Shake
		v_pos = a_targets[i].origin;
		scale = 0.25;
		duration = 0.3;
		radius = (42*60);
		level thread earthquake_delay( 0.3, scale, duration, v_pos, radius );
		
		if( i== 0 )
		{
			exploder( 842 );	// rocket hit 1
		}
		else
		{
			exploder( 843 );	// rocket hit 2
		}
	}

	if( IsDefined(delay) ) 
	{
		wait( 1.0 );
	}
	
	self notify( "missiles away" );
}


//*****************************************************************************
//*****************************************************************************

helicopter_rappel_intro( rappel_delay )
{
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "little_bird_rappel_start" );
	e_heli SetSpeed( 0, 10, 10 );
	
	e_heli endon( "death" );

	// Helicopter flys away now that the rapelling has finished
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "little_bird_rappel_path_part1", (42*3), false );
	
	e_heli waittill( "heli_path_complete" );

	// Delay before rappeling starts
	if( IsDefined(rappel_delay) && (rappel_delay > 0) )
	{
		wait( rappel_delay );
	}

	s_rappel_start = getstruct( "e9_start_rappel_struct", "targetname" );

	// Setup the Rappel ai spawn functions
	sp_ent_1 = getent( "e9_start_rappel_spawner_1", "targetname" );
	sp_ent_1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, true, false );
		
	sp_ent_2 = getent( "e9_start_rappel_spawner_2", "targetname" );
	sp_ent_2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, false );
	
	sp_ent_3 = getent( "e9_start_rappel_spawner_3", "targetname" );
	sp_ent_3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, true );

	// Start the guys rapelling in a staggered way
	ai_ent_1 = sp_ent_1 spawn_ai( true );
	if( IsDefined(ai_ent_1) )
	{
		ai_ent_1.ignoreme = true;
		ai_ent_1.ignoreall = true;
		ai_ent_1 thread ai_rappel_run_away( "stairs_left_rappel_exit", true );
	}

	wait( 2.25 );	// 1.25
	ai_ent_2 = sp_ent_2 spawn_ai( true );
	if( IsDefined(ai_ent_2) )
	{
		ai_ent_2.ignoreme = true;
		ai_ent_2.ignoreall = true;
		ai_ent_2 thread ai_rappel_run_away( "stairs_right_rappel_exit", true );
	}
	
	wait( 1.5 );	// 0.5
	ai_ent_3 = sp_ent_3 spawn_ai( true );
	if( IsDefined(ai_ent_3) )
	{
		ai_ent_3.ignoreme = true;
		ai_ent_3.ignoreall = true;
		ai_ent_3 thread ai_rappel_run_away( "stairs_left_rappel_exit", true );
	}
	
	wait( 5 );	// 5
	
	// Helicopter flys away now that the rapelling has finished
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "little_bird_rappel_path_part2", (42*1.5), true );
}


//*****************************************************************************
//*****************************************************************************

ai_rappel_run_away( str_exit_node, delete_at_goal )
{
	self endon( "death" );

	self waittill("rappel_done");

	self change_movemode( "sprint" );
	
	nd_node = getnode( str_exit_node, "targetname" );
	self SetGoalNode( nd_node );
	self.goalradius = 50;
	self waittill( "goal" );
	
	if( IsDefined(delete_at_goal) )
	{
		self delete();
		return;
	}
	
	self.goalradius = 2048;
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// Post Metal Storm Scripting
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

e9_post_ms_left_begin_trigger( str_category )
{
	t_trigger = getent( "e9_post_ms_left_begin_trigger", "targetname" );
	t_trigger waittill( "trigger" );

	// Cleans up threads
	level notify( "metal_storm_cleanup" );

	autosave_by_name( "e9_post_metal_storm" );

	//IPrintLnBold( "M STORM left spawners begin" );

	// Holders
	a_holders = getentarray( "e9_post_ms_left_begin_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}

	// Regular
	a_spawners = getentarray( "e9_post_ms_left_begin_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}
	
	// Rushers
	sp_rushers = getentarray( "e9_post_ms_left_begin_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
	
	// Prone
	a_holders = getentarray( "e9_post_ms_left_begin_prone_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn( a_holders, ::spawn_fn_ai_run_to_prone_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_left_wave2_trigger( str_category )
{
	str_notify = "e9_post_ms_left_wave2_notify";
	multiple_trigger_waits( "e9_post_ms_left_wave2_trigger", str_notify );
	level waittill( str_notify );

	//IPrintLnBold( "M STORM Left Wave 2" );

	// Regular
	a_spawners = getentarray( "e9_post_ms_left_wave2_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_left_wave2_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_left_wave3_trigger( str_category )
{
	str_notify = "e9_post_ms_left_wave3_notify";
	multiple_trigger_waits( "e9_post_ms_left_wave3_trigger", str_notify );
	level waittill( str_notify );

	//IPrintLnBold( "M STORM Left Wave 3" );
	
	autosave_by_name( "e9_post_metal_left_wave3" );
	
	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_post_ms_left_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}
	
	// Jumper
	a_jumpers = getentarray( "e9_post_ms_left_wave3_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		simple_spawn( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false );
	}

	// Holders
	a_holders = getentarray( "e9_post_ms_left_wave3_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
	
	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_left_wave3_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_vclose_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_right_begin_trigger( str_category )
{
	t_trigger = getent( "e9_post_ms_right_begin_trigger", "targetname" );
	t_trigger waittill( "trigger" );

	// Cleans up threads	
	level notify( "metal_storm_cleanup" );
	
	autosave_by_name( "e9_post_metal_storm" );
		
	//IPrintLnBold( "M STORM right spawners begin" );

	// Holders
	a_holders = getentarray( "e9_post_ms_right_begin_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}

	// Regular
	a_spawners = getentarray( "e9_post_ms_right_begin_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Rushers
	sp_rushers = getentarray( "e9_post_ms_right_begin_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_right_wave2_trigger( str_category )
{
	t_trigger = getent( "e9_post_ms_right_wave2_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	//IPrintLnBold( "M STORM Right Wave 2" );

	// Regular
	a_spawners = getentarray( "e9_post_ms_right_wave2_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_right_wave2_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
	
	// Prone
	a_holders = getentarray( "e9_post_ms_right_wave2_prone_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_prone_node, true, str_category, false, false );
	}
	
	// Jumper
	a_jumpers = getentarray( "e9_post_ms_right_wave2_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_right_wave3_trigger( str_category )
{
	t_trigger = getent( "e9_post_ms_right_wave3_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	//IPrintLnBold( "M STORM Right Wave 3" );

	autosave_by_name( "e9_post_metal_right_wave3" );
	
	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_post_ms_right_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_right_wave3_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
	
	// Jumper
	a_jumpers = getentarray( "e9_post_ms_right_wave3_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_enemy_end_stairs_left( str_category )
{
	t_trigger = getent( "e9_enemy_end_stairs_left", "targetname" );
	t_trigger waittill( "trigger" );
		
	//IPrintLnBold( "END STAIRS LEFT SPAWNERS" );

	autosave_by_name( "e9_enemy_end_stairs_left" );

	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_enemy_end_stairs_left_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Holders
	a_holders = getentarray( "e9_enemy_end_stairs_left_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
	
	// Add Rusher type AI
	sp_rushers = getentarray( "e9_enemy_end_stairs_left_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e9_enemy_end_stairs_right( str_category )
{
	t_trigger = getent( "e9_enemy_end_stairs_right", "targetname" );
	t_trigger waittill( "trigger" );
	
	//IPrintLnBold( "END STAIRS RIGHT SPAWNERS" );

	autosave_by_name( "e9_enemy_end_stairs_right" );

	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );
	
	// Regular
	a_spawners = getentarray( "e9_enemy_end_stairs_right_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}

	// Holders
	a_holders = getentarray( "e9_enemy_end_stairs_right_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_enemy_end_stairs_right_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
		}
	}
}


//*****************************************************************************
// Helicopter Rappelling in guys at the end of the level
//*****************************************************************************

helicopter_rappel_end_level( spawn_delay, rappel_delay )
{
	if( IsDefined(level.e9_end_level_helicopter) )
	{
		return;
	}
	else
	{
		level.e9_end_level_helicopter = true;
	}

	if( IsDefined(spawn_delay) && (spawn_delay!=0) )
	{
		wait( spawn_delay );
	}

	//IPrintLnBold( "Rappel Helicopter - End Level" );

	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "little_bird_end_map_rappel_left" );
	e_heli SetSpeed( 0, 10, 10 );
	
	e_heli endon( "death" );

	// Helicopter flys away now that the rapelling has finished
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "little_bird_end_map_rappel_left_start_path", (42*3), false );
	
	e_heli waittill( "heli_path_complete" );

	// Delay before rappeling starts
	if( IsDefined(rappel_delay) && (rappel_delay > 0) )
	{
		wait( rappel_delay );
	}

	s_rappel_start = getstruct( "e9_end_map_rappel_struct", "targetname" );

	// Setup the Rappel ai spawn functions
	sp_ent_1 = getent( "e9_start_rappel_spawner_1", "targetname" );
	sp_ent_1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, true, false );
		
	sp_ent_2 = getent( "e9_start_rappel_spawner_2", "targetname" );
	sp_ent_2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, false );
	
	sp_ent_3 = getent( "e9_start_rappel_spawner_3", "targetname" );
	sp_ent_3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, true );
	
	sp_ent_4 = getent( "e9_start_rappel_spawner_4", "targetname" );
	sp_ent_4 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, true );


	// Start the guys rapelling in a staggered way
	ai_ent_1 = sp_ent_1 spawn_ai( true );
	ai_ent_1 thread ai_rappel_run_away( "e9_end_stairs_left_defend_node", undefined );
	
	wait( 2.25 );	// 1.25
	ai_ent_2 = sp_ent_2 spawn_ai( true );
	ai_ent_2 thread ai_rappel_run_away( "e9_end_stairs_right_defend_node", undefined );
	
	wait( 1.5 );	// 0.5
	ai_ent_3 = sp_ent_3 spawn_ai( true );
	ai_ent_3 thread ai_rappel_run_away( "e9_end_stairs_defend_node3", undefined );

	wait( 1.5 );	// 0.5
	ai_ent_4 = sp_ent_4 spawn_ai( true );
	ai_ent_4 thread ai_rappel_run_away( "e9_end_stairs_defend_node4", undefined );

	wait( 5 );	// 5
	
	// Helicopter flys away now that the rapelling has finished
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "little_bird_end_map_rappel_left_end_path", (42*1.5), true );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
// ANIMATIONS THREADS
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

civilians_running_from_battle_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	// Leave a blood trail on a civ
	level thread ent_blood_trail( "civ_female_rich_ai", 5.0, 6.5, 0.2 );
	
	// Animation: Part 1 of 2
	run_scene( "scene_event9_civ_injured_and_helper_part1" );

	// Animation: Part 2 of 2
	level thread run_scene( "scene_event9_civ_injured_and_helper_part2" );

	// Kill the civilians after a while
	// TODO: Improve this cleanup
	wait( 15 );

	end_scene( "scene_event9_civ_injured_and_helper_part2" );
}


//*****************************************************************************
//*****************************************************************************

civilian_group4_waiting_to_escape_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	// Animation: Part 1 of 3	
	level thread run_scene( "scene_civilian_group4_escape_begin_loop" );

	// Time for the anim to create ents
	wait( 1 );

	// Waiting to trigger, if player can see and within trigger distance
	while( 1 )
	{
		dist = can_see_position( (-1097, -844, -3260), 0.9 );
		if( (dist > 0.0) && (dist < (42*34)) )	// (42*32)
		{
			break;
		}
		//IPrintLnBold( "ANIM Dist: " + dist );
		wait( 0.25 );
	}

	// Animation: Part 2 of 3
	run_scene( "scene_civilian_group4_escape_running" );

	// Animation: Part 3 of 3
	level thread run_scene( "scene_civilian_group4_escape_end_loop" );

	// Kill off the scene after time	
	wait( 100 );
	delete_scene( "scene_civilian_group4_escape_end_loop" );
}


//*****************************************************************************
//*****************************************************************************

civilian_left_stairs_group1_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	// Animation: Part 1 of 4
	level thread run_scene( "scene_civilian_left_stairs_group1_begin_loop" );
	
	// Waiting to trigger part 2, if player can see and within trigger distance
	while( 1 )
	{
		dist = can_see_position( (-3905, 1752, -3278), 0.9 );
		if( (dist > 0.0) && (dist < (49*50)) )	// (45*50)
		{
			break;
		}
		//IPrintLnBold( "ANIM Dist: " + dist );
		wait( 0.25 );
		
		// If the player has reached the metal storm area, kill the civ anims
		if( flag("flag_reached_metal_storm") )
		{
			delete_scene( "scene_civilian_left_stairs_group1_begin_loop" );
			delete_scene( "scene_civilian_left_stairs_group2_begin_loop" );
			return;
		}
	}
	
	level notify( "civilian_left_stairs_group1_anim_starting" );

	// Animation: Part 2 of 4
	run_scene( "scene_civilian_left_stairs_group1_run" );

	// Animation: Part 3 of 4
	level thread run_scene( "scene_civilian_left_stairs_group1_begin_loop_mid" );

	// Pause for a bit
	wait( 1 );
	
	max_wait_time = 120;
	start_time = gettime();
	while( 1 )
	{
		// Check for max wait time
		time = gettime();
		dt = ( time - start_time ) / 1000;
		if( dt > max_wait_time )
		{
			break;
		}
		
		// Now wait for the player to get close before next trigger
		if( flag("upper_left_stairs_spawners_active") )
		{
			break;
		}
		
		wait( 0.01 );
	}
		
	// Animation: Part 4 of 4
	level thread run_scene( "scene_civilian_left_stairs_group1_run_and_exit" );
	
	wait( 1.5 );
	
	level notify( "civilian_left_stairs_group1_anim_ending" );
}


//*****************************************************************************
//*****************************************************************************

civilian_left_stairs_group2_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	// Animation: Part 1 of 4
	level thread run_scene( "scene_civilian_left_stairs_group2_begin_loop" );
	
	// Waiting to trigger part 2, if player can see and within trigger distance
	
	level waittill( "civilian_left_stairs_group1_anim_starting" );

	wait( 1.6 );
	
	//IPrintLnBold( "ANIM Group2 - GO" );
	
	// Animation: Part 2 of 4
	run_scene( "scene_civilian_left_stairs_group2_run" );

	// Animation: Part 3 of 4
	level thread run_scene( "scene_civilian_left_stairs_group2_begin_loop_mid" );

	// Wait for the parent civ animation to trigger us to follow
	level waittill( "civilian_left_stairs_group1_anim_ending" );
	
	// Animation: Part 4 of 4
	run_scene( "scene_civilian_left_stairs_group2_run_and_exit" );
}


//*****************************************************************************
//*****************************************************************************

civilian_balcony_fling_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	run_scene( "scene_e9_start_balcony_fling" );
}

//*****************************************************************************
// 
//*****************************************************************************

civilian_rocks_execution_anim( delay, str_category_snipers )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

//	IPrintLnBold( "Execution Animation" );

	str_civilian_killed_targetname = "civ_executed_on_rocks_ai";
	str_executioner_targetname = "guard_rocks_executioner_ai";

	//level thread make_ent_ignore_battle( str_civilian_killed_targetname, undefined, 0.1 );
	level thread make_ent_ignore_battle( str_executioner_targetname, undefined, 0.1 );

	run_scene( "scene_event9_rocks_execution" );
	
	// Put the dead civilian into ragdoll death
	
	e_dead_civ = getent( str_civilian_killed_targetname, "targetname" );
	e_dead_civ ragdoll_death();
	
	// Send the executioner to a cover node
	nd_node = getnode( "executioner_cover_node", "targetname" );
	e_executioner = getent( "guard_rocks_executioner_ai", "targetname" );
	e_executioner setup_bunker_enemy_params();
	e_executioner SetGoalNode( nd_node );
	e_executioner thread spawn_fn_ai_run_to_target( undefined, undefined, false, false );
	e_executioner thread ai_visible();

	// Setup Cleanup
	add_cleanup_ent( str_category_snipers, e_executioner );
	add_cleanup_ent( str_category_snipers, e_dead_civ );
	
	// Make executioner a target again
	level make_ent_a_battle_target( str_executioner_targetname, undefined, undefined );
	e_executioner setup_bunker_enemy_params();
	
	civ_up = anglestoup( e_dead_civ.angles );
	civ_dir = anglestoforward( e_dead_civ.angles );
	pos = e_dead_civ.origin + (civ_dir * -200) + (civ_up * 40);
	dir = vectornormalize( pos - e_executioner.origin );
	dir = dir * 20;
	e_dead_civ LaunchRagDoll( dir, e_dead_civ.origin );
}


//*****************************************************************************
//*****************************************************************************

e9_balcony_blowup_ledge_fall_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	run_scene( "scene_e9_balcony_blowup_ledge_fall" );
}


//*****************************************************************************
//*****************************************************************************

e9_balcony_blowup_stairs_stumble_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_gump_9" );

	run_scene( "scene_e9_balcony_blowup_stairs_stumble" );
}


//*****************************************************************************
//*****************************************************************************
// Civilians running along nodes
//*****************************************************************************
//*****************************************************************************

e9_civ_rocks_right_trigger( delay )
{
	e_trigger = getent( "e9_civ_rocks_right_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Right Rocks Civs Tiggered" );	

	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a1";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a2";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a3";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a4";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a5";
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy1_b", a_str_nodes );
	
	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_b1";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_b2";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_b3";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a4";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_rocks_right_a5";
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy2_a", a_str_nodes );
}


//*****************************************************************************
//*****************************************************************************

e9_civ_bridge_to_stairs( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Civs Bridge Stairs Tiggered" );

	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a1";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a2";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a3";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a4";
	level thread civ_run_along_node_array( 1.1, "stair_rush_guy2_b", a_str_nodes, 1400 );
	
	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_b1";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_b2";
	//a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a3";
	a_str_nodes[ a_str_nodes.size ] = "e9_civ_bridge_stairs_a4";
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy3_b", a_str_nodes, 1400 );
}


//*****************************************************************************
//*****************************************************************************
// Player Speedup Triggers
//*****************************************************************************
//*****************************************************************************

advance_to_the_rocks_pacing()
{
	//*************************************
	// Wait for Mason to get past the rocks
	//*************************************

	start_time = gettime();

	nag1 = 0;
	nag1_time = 100;	// 90
	nag2 = 0;
	nag2_time = 130;	// 120
	nag3 = 0;
	nag3_time = 150;	// 140

	while( flag("reached_the_rocks_objective") == 0)
	{
		time = gettime();
		dt = (time - start_time) / 1000;
	
		if( nag1 == 0 )
		{
			if( dt > nag1_time )
			{
				nag1 = 1;
				level.ai_salazar thread say_dialog( "get_to_the_rocks_nag1" );
			}
		}	
		
		if( nag2 == 0 )
		{
			if( dt > nag2_time )
			{
				nag2 = 1;
				level.ai_salazar thread say_dialog( "get_to_the_rocks_nag2" );
			}
		}	

		if( nag3 == 0 )
		{
			if( dt > nag3_time )
			{
				nag3 = 1;
				missionfailedwrapper( &"KARMA_2_DEFALCO_ESCAPES_WITH_KARMA" );
				return;
			}
		}	
		
		wait( 0.01 );
	}
}


