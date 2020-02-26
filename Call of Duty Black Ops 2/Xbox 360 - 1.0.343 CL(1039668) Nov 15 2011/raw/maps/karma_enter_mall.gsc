
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\_anim;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
// INIT functions
//*****************************************************************************

//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "event8_complete" );
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    add_spawn_function( "intro_drone", ::intro_drone );

	run_thread_on_noteworthy( "perk_id", ::add_spawn_function, ::ai_visible );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_enter_mall()
{
//	init_hero( "hero_name_here" );

	start_teleport( "skipto_enter_mall" );
	
	level.ai_han = init_hero_startstruct( "han", "e8_han_start" );
	level.ai_harper = init_hero_startstruct( "harper", "e8_harper_start" );
	level.ai_salazar = init_hero_startstruct( "salazar", "e8_salazar_start" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e8_redshirt1_start" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e8_redshirt2_start" );

	level.ai_karma = undefined;
	level.ai_defalco = undefined;
	
	level thread maps\createart\karma_art::karma_fog_sunset();
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	// *** CHEAT ***
	level.e8_skip_beginning = false;
	level.e8_skip_ending = false;
	//level.e8_skip_beginning = true;
	//level.e8_skip_ending = true;


	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/

	//level thread update_billboard( "Exit Club", "Pacing", "Small", "7" );

	// Initialization
	spawn_funcs();
	
	maps\karma_2_anim::event_08_anims();
	

	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************
	
	level.ai_han set_force_color( "r" );
	level.ai_redshirt1 set_force_color( "r" );
	level.ai_redshirt2 set_force_color( "r" );

	level.ai_harper set_force_color( "g" );
	level.ai_salazar set_force_color( "g" );

	
	//*******************************
	// Bring back the players Weapons
	//*******************************

	level thread battlechatter_on();
	flag_set( "draw_weapons" );
	//IPrintLnBold( "DRAW WEAPONS" );
	

	//******************************
	// Start the initial Engagements
	//******************************

	// Spawn the AI based on the which of the two enterances the player uses to enter event 9
	level thread e8_wave_spawning();
	
	// Objectives
	level thread enter_mall_objectives();
	
	// Brute Perk
	level thread brute_perk();
	
	// Shrimps - Test stuff
	//level thread mall_shrimps();
	
	// Wait for Event 8 to Complete
	// Exiting this function automatically calls the main() function in the next event
	// This linking process is setup by the SkipTo system
	
	flag_wait( "event8_complete" );
}

//
//	Need an AI to run something when spawned?  Put it here.
spawn_funcs()
{
//	add_spawn_function_veh( "intro_drone", ::intro_drone );
}


//*****************************************************************************
//
//*****************************************************************************

enter_mall_objectives()
{
	wait( 0.25 );

	//***************************
	// Set objective for Event8_1
	//***************************
	
	t_trigger = getent( "trigger_end_event8_1", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_8_1, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_8_1, undefined, "delete" );

	wait( 0.01 );


	//***************************
	// Set objective for Event8_2
	//***************************
	
	t_trigger = getent( "trigger_end_event8_2", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_8_2, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_8_2, undefined, "delete" );

	wait( 0.01 );


	//***************************
	// Set objective for Event8_3
	//***************************
	
/*
	t_trigger = getent( "trigger_end_event8_3", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_8_3, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_8_3, undefined, "delete" );
*/


	//******************
	// Event 8 - Cleanup
	//******************

	//IPrintLnBold( "Wave Cleanup" );

	wait( 0.01 );
	cleanup_ents( "e8_wave_1" );
	wait( 0.01 );
	cleanup_ents( "e8_wave_2" );
	wait( 0.01 );
	

	//***************************
	// Progress to Event 9
	//***************************

// sb42 - fix this save
	//autosave_by_name( "karma_enter_mall" );
	wait( 0.01 );
	flag_set( "event8_complete" );
}


//*****************************************************************************
// AI WAVES
//*****************************************************************************

e8_wave_spawning()
{
	//***********************************
	// Trigger starts Event 8
	//***********************************
	
	//t_trigger = getent( "start_event_8", "targetname" );
	//t_trigger waittill( "trigger" );
	//wait( 1 );

	// ( anim_delay, pip_delay, pip_time )

	level thread e8_civs_trapped_staircase_trigger( 0.1, 0.3, 9 );


	//***********************************
	// Wave 1 - Animations
	//***********************************

	str_category = "e8_wave_1";

	spawn_time = undefined;		// 0.1

// sb42
	// 4 Ai guards spawn at bottom
	//e8_intro_guard_anims( delay, str_category )
	//level thread e8_startup_civ_anims( spawn_time );
	
	
	//***********************************
	// Wave 1 - Spawners
	//***********************************

	str_category = "e8_wave_1";

	if( level.e8_skip_beginning == false )
	{
		level thread e8_enter_mall_trigger( str_category );
	}


	//***********************************
	// Wave 2
	//***********************************

	str_category = "e8_wave_2";

	if( level.e8_skip_beginning == false )
	{
		//level thread e8_intro_guard_ai_spawners( spawn_time, str_category );
	
		//level thread e8_upper_left_start_mall_spawners( 2, 0.1, str_category );			// 0.1
	
		//level thread e8_upper_right_start_mall_spawners( 2, 0.1, str_category );		// 0.1
	
		//level thread e8_lower_start_mall_spawners( 2, 0.1, str_category );				// 0.1
	
		level thread e8_sniper_castle_spawners( 2, 0.1, str_category );					// 0.1

		level thread e8_mall_moving_cover();
	}
	

	//***********************************
	// Wave 3
	//***********************************
	
	str_category = "e8_wave_3";
	
	if( level.e8_skip_ending == false )
	{
		level thread e8_left_side_staircase_spawners( 3, 0.1, str_category );			// 0.1

		level thread e8_right_mid_point_spawners( 3, 0.1, str_category );				// 0.1

		level thread e8_left_past_staircase_spawners( 3, 0.1, str_category );			// 0.1
	
		level thread e8_mall_end_spawners( 3, 0.1, str_category );						// 0.1
	}
}


//*****************************************************************************
//*****************************************************************************

e8_enter_mall_trigger( str_category )
{
	// Regular
	a_spawners = getentarray( "e8_enter_mall_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false );
	}
	
	// Holders
	a_holders = getentarray( "e8_enter_mall_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_intro_guard_ai_spawners( delay, str_category )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// First trigger AI some guys at your level
	a_intro_ai = getentarray( "e8_4soldier_intro_spawner", "targetname" );
	if( IsDefined(a_intro_ai) )
	{
		simple_spawn( a_intro_ai, ::spawn_fn_ai_run_to_target, 1, str_category, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************
// MALL START UPPER LEFT
//*****************************************************************************
//*****************************************************************************

e8_upper_left_start_mall_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_start_left_upper_attack_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_upper_left_start_mall_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_upper_left_start_mall";
	spawn_manager_enable( str_spawn_manager );
	
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// MALL START UPPER RIGHT
//*****************************************************************************

e8_upper_right_start_mall_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_start_right_upper_attack_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_upper_right_start_mall_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_upper_right_start_mall";
	spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// MALL START LOWER
//*****************************************************************************

e8_lower_start_mall_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_start_lower_attack_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_lower_start_mall_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	//IPrintLnBold( "STARTING LOWER MALL SPAWNERS" );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_lower_start_mall";
	spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// Snipers in the castle area at the start of the Mall
// There are 3 triggers covering different paths that can trigger the snipers
// - Once triggered, turn off the other triggers
//*****************************************************************************

e8_sniper_castle_spawners( save_number, delay, str_category )
{
	a_triggers = getentarray( "e8_sniper_castle_trigger", "targetname" );
	for( i=0; i<a_triggers.size; i++ )
	{
		a_triggers[i] thread sniper_castle_trigger( save_number, delay, "sniper_castle_triggered", "e8_sniper_castle_spawner", str_category );
	}
}

// self = trigger;
sniper_castle_trigger( save_number, delay, str_level_endon, str_spawner_name, str_category )
{
	level endon( str_level_endon );
	
	// Wait to be triggered by player
	self waittill( "trigger" );

	mall_save_point( save_number );

	// Delay before spawning?
	if( IsDefined(delay) && (delay>0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "SNIPER CASTLE TRIGGERED" );
	
	// Spawn the snipers with the player as a primary target
	a_ents = getentarray( str_spawner_name, "targetname" );
	if( IsDefined(a_ents) ) 
	{
		simple_spawn( a_ents, ::spawn_fn_ai_run_to_target, 1, str_category, false, false );
	}
	
	// Kill off the multiple path triggers with shared name
	level notify( str_level_endon );
}


//*****************************************************************************
// MALL - LEFT SIDE STAIRCASE
//*****************************************************************************

e8_left_side_staircase_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_left_side_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_left_side_staircase_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	//IPrintLnBold( "STARTING LEFT SIDE STAIRCASE SPAWNERS" );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_left_start_staircase";
	spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// MALL - RIGHT MID POINT
//*****************************************************************************

e8_right_mid_point_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_right_mid_point_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_right_mid_point_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	//IPrintLnBold( "STARTING RIGHT MID POINT SPAWNERS" );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_right_mid_point";
	spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// MALL - LEFT PAST STAIRCASE
//*****************************************************************************

e8_left_past_staircase_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_left_past_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	//IPrintLnBold( "STARTING LEFT PAST STAIRCASE SPAWNERS" );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	//str_spawn_manager = "e8_manager_mall_end";
	//spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
	
	// Just spawn the Spawners Once
	str_spawner_name = "e8_left_past_staircase_spawner" ;
	a_spawners = getentarray( str_spawner_name, "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false );
	}
}


//*****************************************************************************
// MALL - MALL END
//*****************************************************************************

e8_mall_end_spawners( save_number, delay, str_category )
{
	// Wait to activate the spawn manager
	e_trigger = getent( "e8_mall_end_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	mall_save_point( save_number );

	// Cleanup category
	add_spawn_function_group( "e8_mall_end_spawner", "targetname", ::spawner_set_cleanup_category, str_category );

	//IPrintLnBold( "STARTING MALL END SPAWNERS" );

	// Delay before spawning?
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Turn on the Spawn manager
	str_spawn_manager = "e8_manager_mall_end";
	spawn_manager_enable( str_spawn_manager );
	//waittill_spawn_manager_complete( str_spawn_manager );
}


//*****************************************************************************
// 
//*****************************************************************************

e8_mall_moving_cover()
{
	// Wait for the Demo to Start
	t_trigger = getent( "e8_moving_cover_trigger", "targetname" );
	t_trigger waittill( "trigger" );

	//IPrintLnBold( "Moving Cover Starting" );

	// Moving Cover 1
	e_moving_cover = getent( "moving_cover_1", "targetname" );
	guy = simple_spawn_single( "e8_moving_cover_spawner_1" );
	guy thread guy_moving_cover_think( e_moving_cover );
	e_moving_cover thread moving_cover_think( guy, 3.0, 2.0, 42*3, 8.0 );
	
	// Moving Cover 2
	e_moving_cover = getent( "moving_cover_2", "targetname" );
	guy = simple_spawn_single( "e8_moving_cover_spawner_2" );
	guy thread guy_moving_cover_think( e_moving_cover );
	e_moving_cover thread moving_cover_think( guy, 3.0, 2.0, 42*3, 6.0 );
}


//*****************************************************************************
// Handles the Save points as we progress through the waves
//*****************************************************************************

mall_save_point( save_point_number )
{
	switch( save_point_number )
	{
		case 2:
			if( !IsDefined(level.mall_save_2) )
			{
				autosave_by_name( "karma_mall_2" );
				level.mall_save_2 = 1;
			}
		break;
		
		case 3:
			if( !IsDefined(level.mall_save_3) )
			{
				autosave_by_name( "karma_mall_3" );
				level.mall_save_3 = 1;
			}
		break;

		default:
			ASSERTMSG( "Unknown Autosave in Mall" ); 
		break;
	}
}


//*****************************************************************************
//*****************************************************************************
// TEST STUFF
//*****************************************************************************
//*****************************************************************************

/*
mall_shrimps()
{
	t_trigger = getent( "start_mall_upper_shrimps", "targetname" );	
	t_trigger waittill( "trigger" );

	// Create Shrimp Upper Paths
	flag_init( "kill_mall_shrimps" );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_right"], "shrimp_mall_upper_left_1", 7, 12, 2, 8, undefined, "kill_mall_shrimps" );
	level thread maps\_shrimps::start_shrimp_path( level._effect["shrimp_run_left"], "shrimp_mall_upper_right_1", 7, 12, 2, 8, undefined, "kill_mall_shrimps" );
	
	t_trigger = getent( "stop_mall_upper_shrimps", "targetname" );	
	t_trigger waittill( "trigger" );
	
	// Kill shrimps with flag
	flag_set( "kill_mall_shrimps" );
}
*/

//-----------------------------------------------------------------------------------------------
//-----------------------------------SPECIALTY PERK---------------------------------
//-----------------------------------------------------------------------------------------------

brute_perk()
{	
	if( !level.player HasPerk( "specialty_brutestrength" ) )  // actually specialty_trespasser
	{
		return;
	}
	
	s_brute_use_pos = getstruct( "brute_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute_use_pos.origin, "interact" );
	
	trigger_wait( "t_brute_use" );
	
	set_objective( level.OBJ_INTERACT, s_brute_use_pos, "remove" );

	t_brute_use = GetEnt( "t_brute_use", "targetname" );
	t_brute_use Delete();
	
	// This is where we run to run the animation.  Since we don't have one, I commented it out.
	//run_scene_and_delete( "brute" );	
	
	m_brute_object = GetEnt( "brute_object", "targetname" );
	m_brute_object Delete();
}


//*****************************************************************************
//*****************************************************************************
// ANIMATIONS
//*****************************************************************************
//*****************************************************************************

e8_intro_civilians( delay, str_scene_name, a_ent_names )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	run_scene_and_delete( str_scene_name );

	//IPrintLnBold( "Civ Anim Finished: " + str_scene_name );

	if( IsDefined(a_ent_names) )
	{
		for( i=0; i<a_ent_names.size; i++ )
		{
			e_ent = getent( a_ent_names[i], "targetname" );
			if( IsDefined(e_ent) )
			{
				e_ent delete();
			}
		}
	}
}


//*****************************************************************************
// Mall Execution Animation Scene
//*****************************************************************************

guard_execution_in_mall_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "E8: Mall Execution Animation" );

	str_scene_name = "scene_event8_mall_execution";
	str_civilian_killed_targetname = "civ_executed_on_rocks_ai";
	str_executioner_targetname = "guard_rocks_executioner_ai";

	level thread maps\karma_little_bird::make_ent_ignore_battle( str_executioner_targetname, undefined, 0.1 );

	level thread run_scene_and_delete( str_scene_name );
	scene_wait( str_scene_name );
	
	// Put the dead civilian into ragdoll death
	e_dead_civ = getent( str_civilian_killed_targetname, "targetname" );
	if( IsDefined(e_dead_civ) )
	{
		e_dead_civ ragdoll_death();
	}
		
	
	// Send the executioner to a cover node
//	nd_node = getnode( "executioner_cover_node", "targetname" );
//	e_executioner = getent( "guard_rocks_executioner_ai", "targetname" );
//	e_executioner setup_bunker_enemy_params();
//	e_executioner SetGoalNode( nd_node );
//	e_executioner thread spawn_fn_ai_run_to_target( undefined, undefined, undefined, undefined );
	
	// Make executioner a target again
//	level make_ent_a_battle_target( str_executioner_targetname, undefined, undefined );
//	e_executioner setup_bunker_enemy_params();
	
//	civ_up = anglestoup( e_dead_civ.angles );
//	civ_dir = anglestoforward( e_dead_civ.angles );
//	pos = e_dead_civ.origin + (civ_dir * -200) + (civ_up * 40);
//	dir = vectornormalize( pos - e_executioner.origin );
//	dir = dir * 20;
//	e_dead_civ LaunchRagDoll( dir, e_dead_civ.origin );
}


e8_startup_civ_anims( spawn_time )
{
	// Misc civilian Animations
	a_ent_names = [];
	a_ent_names[ a_ent_names.size ] = "e7_wounded_man_1_ai";
	a_ent_names[ a_ent_names.size ] = "e7_wounded_woman_1_ai";
	level thread e8_intro_civilians( spawn_time, "scene_e8_intro_civ_couple_1", a_ent_names );

	a_ent_names = [];
	a_ent_names[ a_ent_names.size ] = "e7_wounded_man_2_ai";
	a_ent_names[ a_ent_names.size ] = "e7_wounded_woman_2_ai";
	level thread e8_intro_civilians( spawn_time, "scene_e8_intro_civ_couple_2", a_ent_names );

	a_ent_names = [];
	a_ent_names[ a_ent_names.size ] = "e7_wounded_man_3_ai";
	level thread e8_intro_civilians( spawn_time, "scene_e8_intro_civ_single_1", a_ent_names );

	a_ent_names = [];
	a_ent_names[ a_ent_names.size ] = "e7_wounded_woman_4_ai";
	level thread e8_intro_civilians( spawn_time, "scene_e8_intro_civ_single_2", a_ent_names );

	a_ent_names = [];
	a_ent_names[ a_ent_names.size ] = "e7_wounded_man_4_ai";
	level thread e8_intro_civilians( spawn_time, "scene_e8_intro_civ_single_3", a_ent_names );

	// Guard executed at the start of the mall
	// Still looks bad, MikeA: 9/13/11
	//guard_execution_in_mall_anim( 5 );
}


//*****************************************************************************
//*****************************************************************************

e8_intro_guard_anims( delay, str_category )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	// Wait a bit then spawn the animated enterances at the lower level
	wait( 1.0 );	// 3.0
	
	a_guards = [];
	a_guards[ a_guards.size ] = "scene_e8_intro_guard1";
	a_guards[ a_guards.size ] = "scene_e8_intro_guard2";
	a_guards[ a_guards.size ] = "scene_e8_intro_guard3";
	a_guards[ a_guards.size ] = "scene_e8_intro_guard4";
	
	for( i=0; i<a_guards.size; i++ )
	{
		level thread run_scene_and_delete( a_guards[i] );
	}
	
	wait( 1 );

	for( i=0; i<a_guards.size; i++ )
	{
		str_name = "e8_start_anim_guard" + (i+1) + "_ai";
		e_ent = getent( str_name, "targetname" );
		if( IsDefined(e_ent) )
		{
			//IPrintLnBold( "Found Guard" );
			add_cleanup_ent( str_category, e_ent );
			e_ent thread ai_visible();
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e8_civs_trapped_staircase_trigger( anim_delay, pip_delay, pip_time )
{
	// Wait for trigger
	e_trigger = getent( "e8_civs_trapped_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	e_temp_door = getent( "e9_security_gate", "targetname" );
	//e_temp_door disconnectpaths();


	//************************************************************
	// Any delay before we start the multiple civilian animations?
	//************************************************************
	
	if( IsDefined(anim_delay) && (anim_delay > 0) )
	{
		wait( anim_delay );
	}

	//IPrintLnBold( "Starting Staircase Civ Anims" );

	level.num_civs_complete_stair_rush = 0;
	// IMPORTANT: This MUST match the number of threaded anims below
	level.max_civs_complete_stair_rush = 7;

	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_girl_a_start", 
											"scene_event8_stair_rush_girl_a_idle", 
											"scene_event8_stair_rush_girl_a_stairs" );

	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_girl_b_start", 
											"scene_event8_stair_rush_girl_b_idle", 
											"scene_event8_stair_rush_girl_b_stairs" );
										
	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy1_a_start", 
											"scene_event8_stair_rush_guy1_a_idle", 
											"scene_event8_stair_rush_guy1_a_stairs" );
										
	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy1_b_start", 
											"scene_event8_stair_rush_guy1_b_idle", 
											"scene_event8_stair_rush_guy1_b_stairs" );
									
	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy2_a_start", 
											"scene_event8_stair_rush_guy2_a_idle", 
											"scene_event8_stair_rush_guy2_a_stairs" );

	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy2_b_start", 
											"scene_event8_stair_rush_guy2_b_idle", 
											"scene_event8_stair_rush_guy2_b_stairs" );
										
	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy3_b_start", 
											"scene_event8_stair_rush_guy3_b_idle", 
											"scene_event8_stair_rush_guy3_b_stairs" );



	//********************************************
	// Any delay before we start the PIP sequence?
	//********************************************
	
	if( IsDefined(pip_delay) && (pip_delay > 0) )
	{
		wait( pip_delay );
	}

	level thread pip_karma_event( 0.01, "e8_civs_trapped_extra_cam_struct", pip_time );
	wait( 0.1 );
	clientNotify( "fov_zoom_e7_defalco_chase" );
	
	
	//************************************
	// Wait for the temp door open trigger
	//************************************

	e_trigger = getent( "e8_open_temp_door_trigger", "targetname" );
	e_trigger waittill( "trigger" );
	
	IPrintLnBold( "Squad about to start door breach - please wait" );

	level thread stair_civs_rush_pathing_through_door( 0.1 );
	
	wait( 10 );

	//e_temp_door connectpaths();	
	
	up = anglestoup( e_temp_door.angles );
	v_pos = e_temp_door.origin + ( up * (42*3) );
	time = 3;
	e_temp_door moveto( v_pos, time, 0.5, 0.5 );
}

stair_rush_civ_part1_anim( str_start_scene, str_idle_scene, str_stairs_scene )
{
	run_scene_and_delete( str_start_scene );
	wait( 0.1 );
	level.num_civs_complete_stair_rush++;
	//run_scene_and_delete( str_idle_scene );
}

stair_civs_rush_pathing_through_door( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	//level thread pip_karma_event( 7, "e8_civs_trapped_extra_cam_struct", 2 );

	IPrintLnBold( "CIVS - Stair Rush" );
	
	while( level.num_civs_complete_stair_rush < level.max_civs_complete_stair_rush )
	{
		wait( 0.1 );
	}
	
	wait( 1 );

	level thread civ_run_from_node_to_node( undefined, "stair_rush_girl_a", "e8_civ_exit_node1_start", "e8_civ_exit_node1_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_girl_b", "e8_civ_exit_node2_start", "e8_civ_exit_node2_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_guy1_a", "e8_civ_exit_node3_start", "e8_civ_exit_node3_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_guy1_b", "e8_civ_exit_node4_start", "e8_civ_exit_node4_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_guy2_a", "e8_civ_exit_node5_start", "e8_civ_exit_node5_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_guy2_b", "e8_civ_exit_node6_start", "e8_civ_exit_node6_end" );
	level thread civ_run_from_node_to_node( undefined, "stair_rush_guy3_b", "e8_civ_exit_node7_start", "e8_civ_exit_node7_end" );
}

