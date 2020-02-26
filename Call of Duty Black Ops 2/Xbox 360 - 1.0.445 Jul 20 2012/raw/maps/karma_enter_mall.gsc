
#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\_anim;
#include maps\karma_util;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
// INIT functions
//*****************************************************************************

//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "store_explosion_dialog" );
	//flag_init( "event8_force_defalco_pip" );
	flag_init( "event8_pip_swimming_pool_bridge" );
	flag_init( "event8_salazar_unlocks_exit_door" );
//	flag_init( "event8_player_in_position_to_open_door" );
	flag_init( "friendly_asd_activated" );
	flag_init( "event8_exit_door_opening" );
	flag_init( "e8_door_breach_complete" );
	flag_init( "e8_complete" );
}

//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_enter_mall()
{
//	init_hero( "hero_name_here" );

	skipto_teleport( "skipto_enter_mall" );
	
	level.ai_harper = init_hero_startstruct( "harper", "e8_harper_start" );
	level.ai_salazar = init_hero_startstruct( "salazar", "e8_salazar_start" );
//	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e8_redshirt1_start" );
//	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e8_redshirt2_start" );

	level.ai_karma = undefined;
	level.ai_defalco = undefined;
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	//**************
	// *** CHEAT ***
	//**************
	
	//level.e8_skip_spawning_1 = true;
	//level.e8_skip_spawning_2 = true;
	
	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/

	maps\karma_exit_club::karma2_hide_tower_and_shell();


	//level thread update_billboard( "Exit Club", "Pacing", "Small", "7" );

	// Initialization
	spawn_funcs();
	
	maps\karma_2_anim::mall_anims();
	
	maps\karma_little_bird::karma_init_rusher_distances();
	

	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************
	
//	level.ai_redshirt1 set_force_color( "r" );
//	level.ai_redshirt2 set_force_color( "r" );

	level.ai_harper set_force_color( "g" );
	level.ai_salazar set_force_color( "g" );


	// Effects
	mall_ambient_effects();

	//********************
	// Kick off the dialog
	//********************

	//level thread e8_enter_mall_vo();
	
	//*******************************
	// Bring back the players Weapons
	//*******************************

	level thread battlechatter_on();
	flag_set( "draw_weapons" );
	//IPrintLnBold( "DRAW WEAPONS" );
	
	level thread maps\karma_exit_club::exit_club_clean_up();
	
	level thread visionset_change();
	//******************************
	// Start the initial Engagements
	//******************************

	// Spawn the AI based on the which of the two enterances the player uses to enter event 9
	level thread e8_wave_spawning();
	
	// Objectives
	level thread enter_mall_objectives();

	// Brute Perk
	level thread brute_force_perk();
	
	// fxanim explosion
	level thread fxanim_mall_explosion();
	
	// Shrimps - Test stuff
	//level thread mall_shrimps();
	
	// Wait for Event 8 to Complete
	// Exiting this function automatically calls the main() function in the next event
	// This linking process is setup by the SkipTo system
	
	flag_wait( "e8_door_breach_complete" );

}

visionset_change()
{
	trigger_wait("mall_visionset");
	level thread maps\createart\karma_2_art::vision_set_change( "sp_karma2_mall_interior" );
}

//
//	Need an AI to run something when spawned?  Put it here.
spawn_funcs()
{
//	add_spawn_function_veh( "intro_drone", ::intro_drone );
}


//*************************************
// Switch on the ambient ouside effects
//*************************************

mall_ambient_effects()
{
	exploder( 331 );		// Seagulls
	exploder( 801 );		// Ambient effects
}


//*****************************************************************************
//
//*****************************************************************************

enter_mall_objectives()
{
	wait( 0.25 );

	t_player_door_exit_mall = getent( "objective_exit_mall_trigger", "targetname" );
	s_struct_exit_mall = getstruct( t_player_door_exit_mall.target, "targetname" );
	t_player_door_exit_mall triggerOff();
	

	set_objective( level.OBJ_FIGHT_IN_MALL );
	
	level waittill( "e8_aqua_room_triggered" );
	

	//******************
	// Event 8 - Cleanup
	//******************

	wait( 0.01 );
	level notify( "e8_thread_a1" );
	wait( 0.01 );
	level notify( "e8_thread_a2" );
	wait( 0.01 );
	
	// Clean up the dead animated civs
	level notify( "e8_str_cleanup_civs_groupa" );


	//**********************************************************
	// Wait for the player to clean up the enemy in the Aquarium
	//**********************************************************

	str_objective_notify = "e8_all_enemy_killed";
	level thread e8_kill_all_enemy_at_end_of_mall( 10, str_objective_notify );
	level waittill( str_objective_notify );
	
	//IPrintLnBold( "AQUA ROOM CLEARED" );
	wait( 1 );
	set_objective( level.OBJ_FIGHT_IN_MALL, undefined, "done" );
	
	level thread salazar_door_breach_event();
	
	
	//******************
	// Event 8 - Cleanup
	//******************

//	wait( 0.01 );
//	level notify( "e8_thread_a3" );
//	wait( 0.01 );


	//*******************************************************************
	// OBJECTIVE: Wait for Salazar to open the door that leads to Event 9
	//*******************************************************************

	set_objective( level.OBJ_SALAZAR_UNLOCK_DOOR,s_struct_exit_mall, ""  );
	flag_wait( "event8_salazar_unlocks_exit_door" );
	wait( 1 );

	flag_set( "e8_door_breach_complete" );
	set_objective( level.OBJ_SALAZAR_UNLOCK_DOOR, undefined, "done" );

	wait( 0.01 );


	//***************************
	// Set objective for Event8_2
	//***************************
	
	t_trigger = getent( "trigger_end_event8_2", "targetname" );
	s_struct = getstruct( t_trigger.target, "targetname" );
	set_objective( level.OBJ_MOVE_TO_POOL_AREA, s_struct, "" );
//	t_trigger waittill( "trigger" );
	flag_wait( "e8_door_breach_complete" );
	
	set_objective( level.OBJ_MOVE_TO_POOL_AREA, undefined, "delete" );

	wait( 0.01 );


	//******************
	// Event 8 - Cleanup
	//******************

	//IPrintLnBold( "Wave Cleanup" );

	wait( 0.01 );
	cleanup_ents( "e8_wave_1" );
	wait( 0.01 );
	cleanup_ents( "e8_wave_2" );
	wait( 0.01 );
	cleanup_ents( "e8_aqua_guards" );
}


//*****************************************************************************
// Handles the Save points as we progress through the waves
//*****************************************************************************

mall_save_point( save_point_number )
{
	switch( save_point_number )
	{
		case 1:
			if( !IsDefined(level.mall_save_1) )
			{
				autosave_by_name( "karma_mall_1" );
				level.mall_save_1 = 1;
			}
		break;
	
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
 		
		case 4:
			if( !IsDefined(level.mall_save_4) )
			{
				autosave_by_name( "karma_mall_4" );
 				level.mall_save_4 = 1;
			}
 		break;

		default:
			ASSERTMSG( "Unknown Autosave in Mall" ); 
		break;
	}
}


//*****************************************************************************
// FXANIM
//*****************************************************************************

fxanim_mall_explosion()
{
	e_trigger = getent( "pokee_store_explosion", "targetname" );
	e_trigger waittill( "trigger" );
	
	level notify( "fxanim_store_bomb_01_start" );
	
	flag_set( "store_explosion_dialog" );

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


	//******************************
	// Initial group of wounded civs
	//******************************

	level thread e8_setup_wounded_civs_groupa( 0.4, "e8_str_cleanup_civs_groupa" );
	level thread e8_setup_wounded_civs_groupb( 10, "e8_str_cleanup_civs_groupb" );


	//***********************************
	// Karma Defalco drag PIP moment
	//***********************************

	level thread e8_pip_defalco_karma_crossing_swimming_pool_bridge( 40, 5.5 );

	
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

	str_thread_cleanup = "e8_thread_a1";

	str_category = "e8_wave_1";
	str_sniper_category = "e8_sniper_castle";


	level thread e8_enter_mall_trigger( str_category );
	level thread e8_enter_mall_part2_trigger( str_category );
		
	level thread e8_mall_upper_left_wave1_trigger( str_category, str_thread_cleanup );
		
	level thread e8_mall_upper_right_wave1_trigger( str_category, str_thread_cleanup );
	level thread e8_mall_upper_right_wave2_trigger( str_category, str_thread_cleanup );

	level thread e8_start_left_staircase_trigger( str_category, str_thread_cleanup );
	level thread e8_start_right_staircase_trigger( str_category, str_thread_cleanup );

	level thread e8_helicopter_rappel_intro( 0.5, 0.5, str_sniper_category );
	
	// mall is in the indoor now.
//	level thread e8_flanking_helicopters( 15, 3, 25, 4 );		// 10, 3


	//***********************************
	// Wave 2
	//***********************************

	str_category = "e8_wave_2";
	str_thread_cleanup = "e8_thread_a2";

	level thread e8_mall_ul_mid_point_trigger( 4, str_category, str_thread_cleanup );
	level thread e8_mall_ul_staircase_trigger( 5, str_category, str_thread_cleanup );
	
	level thread e8_mall_ur_mid_point_trigger( 4, str_category, str_thread_cleanup );
	level thread e8_mall_ur_approach_castle_trigger( 4.5, str_category, str_thread_cleanup );
	
	level thread e8_start_bridge_left_trigger( str_category, str_thread_cleanup );
	level thread e8_start_bridge_right_trigger( str_category, str_thread_cleanup );
	
	level thread e8_mall_low_left_mid_trigger( 6, str_category, str_thread_cleanup );
	level thread e8_mall_low_right_mid_trigger( 6, str_category, str_thread_cleanup );
	

	//***********************************
	// Wave 3
	//***********************************
	
	str_category = "e8_wave_3";
	str_thread_cleanup = "e8_thread_a3";

	level thread e8_mall_ul_reached_staircase_trigger( 10, str_category, str_thread_cleanup );
	level thread e8_mall_ul_approach_aqua_trigger( 15, str_category, str_thread_cleanup );

	level thread e8_mall_ur_reached_sniper_castle_trigger( 10, str_category, str_thread_cleanup );
	level thread e8_mall_ur_approach_aqua_trigger( 15, str_category, str_thread_cleanup );

	level thread e8_mall_low_left_at_castle_trigger( 10, str_category, str_thread_cleanup );
	level thread e8_mall_low_right_at_castle_trigger( 15, str_category, str_thread_cleanup );
	
	level thread e8_mall_rappel_guys_on_bridge_trigger ( 1, str_category, str_thread_cleanup );


	//***********************************
	// End Aquarium Arena
	//***********************************
	
	str_aquaroom_friendly_category = "e8_aqua_guards";
	
	level thread e8_aqua_room_trigger( 20, str_aquaroom_friendly_category, str_category );
	
	level thread e8_civs_trapped_staircase_trigger( 0.1, 0.3, 9 );
	
	level thread e8_aquarium_rpg_killers_trigger( 10, str_category );
	
	
	//***********************************
	// Door Breached into Event 9
	//***********************************
	
	str_category = "e8_wave_4";
	
	level thread e8_the_end_enemy_spawners( 25, str_category );
}


//*****************************************************************************
//*****************************************************************************
// Mall Spawning
//*****************************************************************************
//*****************************************************************************

e8_enter_mall_trigger( str_category )
{
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_enter_mall_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_enter_mall_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
	
	// Holders
	a_holders = getentarray( "e8_enter_mall_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_enter_mall_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
	
	e_trigger = getent( "e8_enter_mall_trigger", "targetname" );
	e_trigger waittill( "trigger" );
	
	sp_friendly1 = getent( "redshirt1", "targetname" );
	level.ai_redshirt1 = simple_spawn_single( sp_friendly1, ::spawn_fn_ai_run_to_holding_node, false );
	level.ai_redshirt1 set_force_color( "r" );
	level.ai_redshirt1.goalradius = 64;
	level.ai_redshirt1 thread magic_bullet_shield();
	
	sp_friendly3 = getent( "redshirt2", "targetname" );
	level.ai_redshirt2= simple_spawn_single( sp_friendly3, ::spawn_fn_ai_run_to_holding_node, false );
	level.ai_redshirt2 set_force_color( "r" );
	level.ai_redshirt2.goalradius = 64;
	level.ai_redshirt2 thread magic_bullet_shield();


//	// Friendlies 
	spawn_ai_battle( "e8_friendly_enter_mall_spawner_scapegoat0", "e8_enter_mall_spawner_killer0", undefined, undefined, false, true, 0.1, 0.8 );
	sp_friendly2 = getent( "e8_friendly_enter_mall_spawner_scapegoat1", "targetname" );
	ai_friendly2 = simple_spawn_single( sp_friendly2, ::spawn_fn_ai_run_to_holding_node, false, str_category );
//	sp_friendly3 = getent( "e8_friendly_enter_mall_hold_spawner", "targetname" );
//	ai_friendly3 = simple_spawn_single( sp_friendly3, ::spawn_fn_ai_run_to_holding_node, false, str_category );
//	
	wait( 0.1 );
	level thread ai_bullet_shiled_until_trigger( "e8_enter_mall_spawner_killer0_ai", "cafi_rappel", 0.1 );
	level thread ai_bullet_shiled_until_trigger( "e8_friendly_enter_mall_spawner_scapegoat0_ai", "cafi_rappel", 0.9 );
	level thread ai_bullet_shiled_until_trigger( "e8_friendly_enter_mall_spawner_scapegoat1_ai", "cafi_rappel", 0.9 );
//	level thread ai_bullet_shiled_until_trigger( "e8_friendly_enter_mall_hold_spawner", "cafi_rappel", 0.9 );
}

// self = level
ai_bullet_shiled_until_trigger( str_ent_targetname, str_trigger, npc_damage_scale )
{
	e_ent = getent( str_ent_targetname, "targetname" );
	e_ent endon( "death" );
	
	e_ent.overrideActorDamage = ::player_rusher_damage_override;
	e_ent.npc_damage_scale = npc_damage_scale;

	e_trigger = getent( str_trigger, "targetname" );
	e_trigger waittill( "trigger" );

	e_ent.npc_damage_scale = 1.0;
}


//*****************************************************************************
//*****************************************************************************

e8_enter_mall_part2_trigger( str_category )
{
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	e_trigger = getent( "e8_enter_mall_part2_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "ENTER MALL PART 2 TRIGGER" );
	
	// Ignore
	a_spawners = getentarray( "e8_enter_mall_part2_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_enter_mall_part2_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}

	// Regular
	a_spawners = getentarray( "e8_enter_mall_part2_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_enter_mall_part2_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}

	// Jumper
	a_jumpers = getentarray( "e8_enter_mall_part2_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_enter_mall_part2_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*10) );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_upper_left_wave1_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_mall_upper_left_wave1_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Upper Left Wave 1" );

	mall_save_point( 1 );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}
	
	// Rushers
	sp_rusher = getent( "e8_mall_upper_left_wave1_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_upper_left_wave1_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
	
	// Regular
	a_spawners = getentarray( "e8_mall_upper_left_wave1_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_upper_left_wave1_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, 1, false, false );
	}
	
	// Cililian AI
	level thread e9_civ_left_wave1_trigger( 0.01 );
}


//*****************************************************************************
//*****************************************************************************

e8_mall_upper_right_wave1_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_mall_upper_right_wave1_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	//IPrintLnBold( "MALL Upper Right Wave 1" );
	
	// Ignore
	a_spawners = getentarray( "e8_mall_upper_right_wave1_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		//IPrintLnBold( "IGNORE IGNORE" );
		add_spawn_function_group( "e8_mall_upper_right_wave1_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_upper_right_wave1_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_upper_right_wave1_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
	
	// Holders
	a_holders = getentarray( "e8_mall_upper_right_wave1_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_upper_right_wave1_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_upper_right_wave2_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_mall_upper_right_wave2_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Upper Right Wave 2" );
	
	mall_save_point( 1 );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Cililian AI
	level thread e9_civ_right_wave2_trigger( 0.01 );
}


//*****************************************************************************
//*****************************************************************************

e8_start_left_staircase_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_start_left_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Left Staircase Trigger" );

	mall_save_point( 1 );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}
	
	// Regular
	a_spawners = getentarray( "e8_start_left_staircase_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_start_left_staircase_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Rushers
	sp_rusher = getent( "e8_start_left_staircase_rusher_spawner", "targetname" );
	add_spawn_function( "e8_start_left_staircase_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, e_ai.script_delay, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_start_right_staircase_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_start_right_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Right Staircase Trigger" );

	mall_save_point( 1 );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_start_right_staircase_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_start_right_staircase_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Rushers
	sp_rusher = getent( "e8_start_right_staircase_rusher_spawner", "targetname" );
	add_spawn_function( "e8_start_right_staircase_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, e_ai.script_delay, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
	
	// Holders
	a_holders = getentarray( "e8_start_right_staircase_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_start_right_staircase_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
}

//*****************************************************************************
//*****************************************************************************

e8_mall_ul_mid_point_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ul_mid_point_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UL Mid Point Trigger" );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ul_mid_point_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_mid_point_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Rushers
	sp_rusher = getent( "e8_mall_ul_mid_point_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ul_mid_point_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ul_staircase_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ul_mid_point_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UL Staircase Trigger" );

	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ul_staircase_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_staircase_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, 1, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ur_mid_point_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ur_mid_point_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UR Staircase Trigger" );

	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ur_mid_point_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_mid_point_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, 1, false, false );
	}
	
	// Rushers
	sp_rusher = getent( "e8_mall_ur_mid_point_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ur_mid_point_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ur_approach_castle_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ur_approach_castle_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UR Approach Castle Trigger" );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Jumper
	a_jumpers = getentarray( "e8_mall_ur_approach_castle_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_castle_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*8) );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ur_approach_castle_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_castle_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, 1, false, false );
	}
	
	// Holders
	a_holders = getentarray( "e8_mall_ur_approach_castle_holder_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_castle_holder_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
	
	// Ignore
	a_spawners = getentarray( "e8_mall_ur_approach_castle_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_castle_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_start_bridge_left_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	e_trigger = getent( "e8_start_bridge_left_trigger", "targetname" );
	e_trigger endon( "death" );
	e_trigger waittill( "trigger" );
	
	//IPrintLnBold( "MALL Bridge Left Trigger" );
	
	t_opposite = getent( e_trigger.target, "targetname" );
	if( IsDefined(t_opposite) )
	{
		//IPrintLnBold( "DELETING: MALL Bridge Right Trigger" );
		t_opposite delete();
	}

	// Regular
	a_spawners = getentarray( "e8_start_bridge_left_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_start_bridge_left_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Rushers
	sp_rusher = getent( "e8_start_bridge_left_rusher_spawner", "targetname" );
	add_spawn_function( "e8_start_bridge_left_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_start_bridge_right_trigger( str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );
	
	e_trigger = getent( "e8_start_bridge_right_trigger", "targetname" );
	e_trigger endon( "death" );
	e_trigger waittill( "trigger" );
	
	//IPrintLnBold( "MALL Bridge Right Trigger" );
	
	t_opposite = getent( e_trigger.target, "targetname" );
	if( IsDefined(t_opposite) )
	{
		//IPrintLnBold( "DELETING: MALL Bridge Right Trigger" );
		t_opposite delete();
	}

	// Regular
	a_spawners = getentarray( "e8_start_bridge_right_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_start_bridge_right_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Rushers
	sp_rusher = getent( "e8_start_bridge_right_rusher_spawner", "targetname" );
	add_spawn_function( "e8_start_bridge_right_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_low_left_mid_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_low_left_mid_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Low Left Mid Trigger" );

	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_mall_low_left_mid_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_mid_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_low_left_mid_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_mid_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}
	
	// Rushers
	sp_rusher = getent( "e8_mall_low_left_mid_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_low_left_mid_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_low_right_mid_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_low_right_mid_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL Low Right Mid Trigger" );
	
	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	// Regular
	a_spawners = getentarray( "e8_mall_low_right_mid_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_mid_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_low_right_mid_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_mid_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}
	
	// Rushers
	sp_rusher = getent( "e8_mall_low_right_mid_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_low_right_mid_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
	
	// Jumper
	a_jumpers = getentarray( "e8_mall_low_right_mid_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_mid_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*10) );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ul_reached_staircase_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ul_reached_staircase_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UL Reaqched Staircase" );
	
	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_ul_reached_staircase_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ul_reached_staircase_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}
	
	// Holders
	a_holders = getentarray( "e8_mall_ul_reached_staircase_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_ul_reached_staircase_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
	
	// Regular
	a_spawners = getentarray( "e8_mall_ul_reached_staircase_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_reached_staircase_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
	
	// Jumper
	a_jumpers = getentarray( "e8_mall_ul_reached_staircase_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_ul_reached_staircase_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*8) );
	}
	
	// Ignore
	a_spawners = getentarray( "e8_mall_ul_reached_staircase_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_reached_staircase_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ul_approach_aqua_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ul_approach_aqua_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UL Approach Aqua" );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_ul_approach_aqua_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ul_approach_aqua_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_ul_approach_aqua_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_approach_aqua_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}

	// Jumper
	a_jumpers = getentarray( "e8_mall_ul_approach_aqua_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_ul_approach_aqua_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*8) );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ul_approach_aqua_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ul_approach_aqua_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ur_reached_sniper_castle_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ur_reached_sniper_castle_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UR Reached Sniper Castle" );
	
	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_ur_reached_sniper_castle_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ur_reached_sniper_castle_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_ur_reached_sniper_castle_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_reached_sniper_castle_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}
	
	// Regular
	a_spawners = getentarray( "e8_mall_ur_reached_sniper_castle_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_reached_sniper_castle_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_ur_approach_aqua_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_ur_approach_aqua_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UR Approach Aqua" );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_ur_approach_aqua_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_ur_approach_aqua_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_fight_dist, 0.02, 0.1, 1 );
	}

	// Holders
	a_holders = getentarray( "e8_mall_ur_approach_aqua_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_aqua_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_ur_approach_aqua_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_ur_approach_aqua_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
	
//	ai1 = GetEnt( "terrorist_rappel_left1", "targetname" );
//	ai1 thread left_rappel( 1 );
//	
//	ai1 = GetEnt( "terrorist_rappel_left1", "targetname" );
//	ai1 thread left_rappel( 1 );
}

e8_mall_rappel_guys_on_bridge_trigger( delay, str_category, str_thread_cleanup )
{
	
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_rappel_guys_on_bridge", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL UR Approach Aqua" );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}
	
	ai1 = GetEnt( "terrorist_rappel_left1", "targetname" );
	ai1 thread left_rappel( 1 );
	
	ai1 = GetEnt( "terrorist_rappel_left2", "targetname" );
	ai1 thread left_rappel( 2 );
}

left_rappel( num )
{
//	self endon( "death" );
//	self waittill( "jumpedout" );
//	
//	self thread waittill_player_looking_at_me( "player_looking_at_rappel_guy" );
	
	self.b_rappelling = true;
	self thread run_scene_and_delete( "terrorist_rappel_left" + num );
	
	self waittill( "goal" );	
//	flag_set( "left_side_rappel_started" );
	
	scene_wait( "terrorist_rappel_left" + num );
	
	self.b_rappelling = undefined;
//	if ( flag( "sniper_option" ) )
//	{
		self set_spawner_targets( "low_road_attack_nodes01" );
//	}
//	else
//	{
//		self SetGoalVolumeAuto( level.goalVolumes[ "goal_volume_left_side" ] );
//	}
}
//*****************************************************************************
//*****************************************************************************

e8_mall_low_left_at_castle_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_low_left_at_castle_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL LL At Castle" );

	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_low_left_at_castle_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_low_left_at_castle_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_player_busy_dist, 0.02, 0.1, 1 );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_low_left_at_castle_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_at_castle_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_low_left_at_castle_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_at_castle_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}

	// Holders
	a_holders = getentarray( "e8_mall_low_left_at_castle_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_at_castle_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}
	
	// Jumper
	a_jumpers = getentarray( "e8_mall_low_left_at_castle_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_low_left_at_castle_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*8) );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_mall_low_right_at_castle_trigger( delay, str_category, str_thread_cleanup )
{
	level endon( str_thread_cleanup );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	e_trigger = getent( "e8_mall_low_right_at_castle_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "MALL LR At Castle" );

	mall_save_point( 2 );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Rushers
	sp_rusher = getent( "e8_mall_low_right_at_castle_rusher_spawner", "targetname" );
	add_spawn_function( "e8_mall_low_right_at_castle_rusher_spawner", "targetname", ::ai_cant_sprint );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread player_rusher( str_category, undefined, level.player_rusher_player_busy_dist, 0.02, 0.1, 1 );
	}

	// Regular
	a_spawners = getentarray( "e8_mall_low_right_at_castle_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_at_castle_regular_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}

	// Ignore
	a_spawners = getentarray( "e8_mall_low_right_at_castle_ignore_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_at_castle_ignore_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, true );
	}

	// Holders
	a_holders = getentarray( "e8_mall_low_right_at_castle_hold_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_at_castle_hold_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, true, false );
	}

	// Jumper
	a_jumpers = getentarray( "e8_mall_low_right_at_castle_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		add_spawn_function_group( "e8_mall_low_right_at_castle_jumper_spawner", "targetname", ::ai_cant_sprint );
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, (42*8) );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_aqua_room_trigger( delay, str_aquaroom_friendly_category, str_category )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	// Wait for one of the end room triggers, then kill off the others
	str_notify = "e8_aqua_room_triggered";
	multiple_trigger_waits( "e8_aqua_room_trigger", str_notify );
	level waittill( str_notify );

	mall_save_point( 3 );

	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}
	
	//IPrintLnBold( "Aqua Room Triggered" );
	
	wait( 2 );

	level thread e8_end_room_friendly_enemy_battle( 0.1, str_aquaroom_friendly_category, str_category );
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
//	e_executioner thread spawn_fn_ai_run_to_target( undefined, undefined, undefined, undefined, undefined );
	
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
			e_ent add_cleanup_ent( str_category );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

e8_civs_trapped_staircase_trigger( anim_delay, pip_delay, pip_time )
{
	//*****************
	// Wait for trigger
	//*****************
	
	str_level_notify = "e8_civs_staircase_triggered";
	multiple_trigger_waits( "e8_civs_trapped_staircase_trigger", str_level_notify );
	level waittill( str_level_notify );
	

	//******************************************************
	// Kill off the guys that rapelled onto the sniper tower
	//******************************************************

	cleanup_ents( "e8_sniper_castle" );
	
	wait( 0.01 );
	
	// Clean up the dead animated civs
	level notify( "e8_str_cleanup_civs_groupb" );
	

	//******************************************************
	// Turn OFF the trigger for the player opening the door
	// Turn back on once Salazar has opened the door locks
	//******************************************************

	e_player_open_door_trigger = getent( "objective_exit_mall_trigger", "targetname" );
	e_player_open_door_trigger trigger_off();
	
	player_at_gate_pos = getent( "player_at_gate_pos", "targetname" );
	player_at_gate_pos trigger_off();

//	e_temp_door = getent( "e9_security_gate", "targetname" );
	//e_temp_door disconnectpaths();


	//************************************************************
	// Any delay before we start the multiple civilian animations?
	//************************************************************
	
//	if( IsDefined(anim_delay) && (anim_delay > 0) )
//	{
//		wait( anim_delay );
//	}


	//******************************************************
	// Safety check - Must play Defalco Karma Drag PIP first
	//******************************************************
//
//	while( 1 )
//	{
//		if( flag( "event8_pip_swimming_pool_bridge" ) )
//		{
//			break;
//		}
//		wait( 0.01 );
//	}
//
//	//IPrintLnBold( "Starting Staircase Civ Anims" );
//
//	level.num_civs_complete_stair_rush = 0;
//	// IMPORTANT: This MUST match the number of threaded anims below
//	level.max_civs_complete_stair_rush = 7;
//
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_girl_a_start", 
//											"scene_event8_stair_rush_girl_a_idle", 
//											"scene_event8_stair_rush_girl_a_stairs" );
//
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_girl_b_start", 
//											"scene_event8_stair_rush_girl_b_idle", 
//											"scene_event8_stair_rush_girl_b_stairs" );
//										
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy1_a_start", 
//											"scene_event8_stair_rush_guy1_a_idle", 
//											"scene_event8_stair_rush_guy1_a_stairs" );
//										
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy1_b_start", 
//											"scene_event8_stair_rush_guy1_b_idle", 
//											"scene_event8_stair_rush_guy1_b_stairs" );
//									
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy2_a_start", 
//											"scene_event8_stair_rush_guy2_a_idle", 
//											"scene_event8_stair_rush_guy2_a_stairs" );
//
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy2_b_start", 
//											"scene_event8_stair_rush_guy2_b_idle", 
//											"scene_event8_stair_rush_guy2_b_stairs" );
//										
//	level thread stair_rush_civ_part1_anim(	"scene_event8_stair_rush_guy3_b_start", 
//											"scene_event8_stair_rush_guy3_b_idle", 
//											"scene_event8_stair_rush_guy3_b_stairs" );
}


//*****************************************************************************
//*****************************************************************************

stair_rush_civ_part1_anim( str_start_scene, str_idle_scene, str_stairs_scene )
{
	run_scene_and_delete( str_start_scene );
	wait( 0.1 );
	level.num_civs_complete_stair_rush++;
	//run_scene_and_delete( str_idle_scene );
}


//*****************************************************************************
//*****************************************************************************

stair_civs_rush_pathing_through_door( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	while( level.num_civs_complete_stair_rush < level.max_civs_complete_stair_rush )
	{
		wait( 0.1 );
	}
	
	while( 1 )
	{
		if( flag("event8_exit_door_opening") )
		{
			break;
		}
		wait( 0.01 );
	}
	
	//IPrintLnBold( "CIVS - Stair Rush" );
	
	start_time = 2.5;
	
	level thread civ_run_from_node_to_node( start_time, "stair_rush_girl_a", "e8_civ_exit_node1_start", "e8_civ_exit_node1_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_girl_b", "e8_civ_exit_node2_start", "e8_civ_exit_node2_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy1_a", "e8_civ_exit_node3_start", "e8_civ_exit_node3_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy1_b", "e8_civ_exit_node4_start", "e8_civ_exit_node4_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy2_a", "e8_civ_exit_node5_start", "e8_civ_exit_node5_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy2_b", "e8_civ_exit_node6_start", "e8_civ_exit_node6_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy3_b", "e8_civ_exit_node7_start", "e8_civ_exit_node7_end" );
	
	level thread civ_run_from_node_to_node( start_time, "stair_rush_guy_extra1", "e8_civ_exit_node8_start", "e8_civ_exit_node1_end" );
	level thread civ_run_from_node_to_node( start_time, "stair_rush_girl_extra1", "e8_civ_exit_node9_start", "e8_civ_exit_node2_end" );
}


//*****************************************************************************
//*****************************************************************************
// Civilians running along nodes
//*****************************************************************************
//*****************************************************************************

e9_civ_left_wave1_trigger( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Left Wave 1 Civs Tiggered" );	

	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a1";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a2";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a3";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a4";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a5";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a6";
	level thread civ_run_along_node_array( 0.1, "e8_mall_left_wave1_civ1", a_str_nodes );
	
	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_b1";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_b2";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a3";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a4";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a5";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a6";
	level thread civ_run_along_node_array( 0.1, "e8_mall_left_wave1_civ2", a_str_nodes );
	
	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_c1";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_c2";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a3";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a4";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a5";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_left_wave1_a6";
	level thread civ_run_along_node_array( 0.1, "e8_mall_left_wave1_civ3", a_str_nodes );
}


//*****************************************************************************
//*****************************************************************************

e9_civ_right_wave2_trigger( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Right Wave 2 Civs Tiggered" );	

	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a1";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a2";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a3";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a4";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a5";
	level thread civ_run_along_node_array( 0.1, "e8_mall_right_wave2_civ1", a_str_nodes );

	a_str_nodes = [];
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_b1";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_b2";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a3";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a4";
	a_str_nodes[ a_str_nodes.size ] = "e8_civ_right_wave2_a5";
	level thread civ_run_along_node_array( 0.1, "e8_mall_right_wave2_civ2", a_str_nodes );
}


//*****************************************************************************
// RAPELLING - Onto the Sniper Tower
//*****************************************************************************

e8_helicopter_rappel_intro( start_delay, rappel_delay, str_category )
{
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		return;
	}

	if( IsDefined(start_delay) )
	{
		wait( start_delay );
	}

//	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e8_little_bird_start" );
//	e_heli SetSpeed( 0, 10, 10 );
//	
//	e_heli endon( "death" );
//
//	// Helicopter flys away now that the rapelling has finished
//	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_rappel_path", (42*3), false );
//	
//	e_heli waittill( "heli_path_complete" );
	
	e_trigger = getent( "cafi_rappel", "targetname" );
	e_trigger waittill( "trigger" );

	// Delay before rappeling starts
	if( IsDefined(rappel_delay) && (rappel_delay > 0) )
	{
		wait( rappel_delay );
	}
	
	s_rappel_start = getstruct( "e8_start_rappel_struct", "targetname" );

	// Setup the Rappel ai spawn functions
	sp_ent_1 = getent( "e8_tower1_rappel_spawner", "targetname" );
	sp_ent_1 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, true, false );
		
	sp_ent_2 = getent( "e8_tower2_rappel_spawner", "targetname" );
	sp_ent_2 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, false );
	
	sp_ent_3 = getent( "e8_tower3_rappel_spawner", "targetname" );
	sp_ent_3 add_spawn_function( maps\_ai_rappel::start_ai_rappel, undefined, s_rappel_start, false, true );

	// Start the guys rapelling in a staggered way
	ai_ent_1 = sp_ent_1 spawn_ai( true );
	//nd_node = getnode( "", "targetname" );
	if( IsDefined(ai_ent_1) )
	{
		//ai_ent_1 SetGoalNode( nd_node );
		ai_ent_1 thread ai_rappel_run_to_target( str_category, true );
	}

	wait( 2.25 );	// 1.25
	ai_ent_2 = sp_ent_2 spawn_ai( true );
	//nd_node = getnode( "", "targetname" );
	if( IsDefined(ai_ent_2) )
	{
		//ai_ent_2 SetGoalNode( nd_node );
		ai_ent_2 thread ai_rappel_run_to_target( str_category, true );
	}
	
	wait( 1.5 );	// 0.5
	ai_ent_3 = sp_ent_3 spawn_ai( true );
	//nd_node = getnode( "", "targetname" );
	if( IsDefined(ai_ent_3) )
	{
		//ai_ent_3 SetGoalNode( nd_node );
		ai_ent_2 thread ai_rappel_run_to_target( str_category, true );
	}
	
//	wait( 5 );		// 5
	
	// Helicopter flys away now that the rapelling has finished
//	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_rappel_path_end", (42*1.5), true );
}


//*****************************************************************************
//*****************************************************************************

ai_rappel_run_to_target( str_category, ignoreme )
{
	self endon( "death" );
	
	self.b_rappelling = true;
	
	self waittill("rappel_done");

	self.b_rappelling = undefined;
	if( IsDefined(ignoreme) )
	{
		self.ignoreme = true;
	}
	self thread spawn_fn_ai_run_to_target( true, str_category, undefined, undefined, undefined );
}


//*****************************************************************************
//*****************************************************************************

e8_flanking_helicopters( delay1, delay2, delay3, delay4 )
{
	if( IsDefined(delay1) && (delay1 > 0)) 
	{
		wait( delay1 );
	}
	
	level.ai_harper thread say_dialog( "we_got_a_small_fle_004", 5 );
	
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e8_little_bird_start_right_flank" );
	e_heli SetSpeed( 0, 10, 10 );
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_right_flank_path", (42*3), true );

	if( IsDefined(delay2) && (delay2 > 0)) 
	{
		wait( delay2 );
	}

	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e8_little_bird_start_left_flank" );
	e_heli SetSpeed( 0, 10, 10 );
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_left_flank_path", (42*3), true );
	

	if( IsDefined(delay3) && (delay3 > 0)) 
	{
		wait( delay3 );
	}
	
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e8_little_bird_start_right_flank" );
	e_heli SetSpeed( 0, 10, 10 );
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_right_flank_path", (42*3), true );

	if( IsDefined(delay4) && (delay4 > 0)) 
	{
		wait( delay4 );
	}

	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e8_little_bird_start_left_flank" );
	e_heli SetSpeed( 0, 10, 10 );
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e8_little_bird_start_left_flank_path", (42*3), true );
}


//*****************************************************************************
//*****************************************************************************

//e8_animate_door_to_e9()
//{
//	// (1) Spawn a Script Model
//	e_sm_origin = spawn( "script_model", (0, 0, 0) );
//	
//	// (2) setmodel "tag_origine_animate"
//	e_sm_origin SetModel( "tag_origin_animate" );
//	
//	// (3) Link Door to Script Model
//	e_door = getent( "e9_security_gate", "targetname" );
//	e_door LinkTo( e_sm_origin, "origin_animate_jnt" );
//	
//	//IPrintLnBold( "About to Open Door" );
//	
//	flag_set( "event8_exit_door_opening" );
//	
//	e8_open_door_animation( 0, e_sm_origin );
//	wait( 0.1 );
//	
//	e_sm_origin delete();
//}
//
//#using_animtree( "animated_props" );
//e8_open_door_animation( delay, e_model )
//{
//	if( IsDefined(delay) && (delay > 0) )
//	{
//		wait( delay );
//	}
//	
//	// Play animation of door closing
//	
//	anim_name = %o_karma_9_1_gate;
//	
//	anim_time = GetAnimLength( anim_name );
//	
//	e_model UseAnimTree(#animtree);
//	e_model SetAnim( anim_name );
//	
//	wait( anim_time );
//}
#using_animtree( "generic_human" );


//*****************************************************************************
//*****************************************************************************

e8_pip_defalco_karma_crossing_swimming_pool_bridge( trigger_time, pip_time )
{
	if( IsDefined(level.e8_skip_spawning_1) )
	{
		flag_set( "event8_pip_swimming_pool_bridge" );
		return;
	}
	
	level thread setup_ai_aqu_pip_scene();

	level waittill( "aqua_explosion_trigger" );
	
	exploder( 750 );

	clientNotify( "fov_zoom_e7_defalco_chase" );
	level notify( "fxanim_aquarium_pillar_start" );
	
	level pip_karma_event( "e9_defalco_karma_bridge_pip_cam", "scene_event9_defalco_karma_bridge" );
	
	flag_set( "event8_pip_swimming_pool_bridge" );
	
	m_aquarium = GetEnt( "aquarium", "targetname" );
	if ( IsDefined( m_aquarium ) )
	{
		m_aquarium SetModel("dest_aquarium_glass_karma");
	}
	
	stop_exploder( 750 );
}

setup_ai_aqu_pip_scene()
{	
	level endon( "e8_complete" );

	if( !IsDefined(level.ai_defalco) )
	{	
		level.ai_defalco = simple_spawn_single( "defalco" );
	}
	
	level.ai_defalco.ignoreme = true;
	level.ai_defalco.animname = "defalco";
	level.ai_defalco DisableAimAssist();
	level.ai_defalco.health = 99999;
	level.ai_defalco.team = "axis";  // don't show friend name

	if( !IsDefined(level.ai_karma) )
	{	
		level.ai_karma = simple_spawn_single( "karma" );
	}
	
	level.ai_karma.ignoreme = true;
	level.ai_karma.animname = "karma";
	level.ai_karma.health = 99999;
	level.ai_karma.team = "allies"; 
	level.ai_karma.name = " ";
}

//*****************************************************************************
//*****************************************************************************
// Event 8 - Mall VO
//*****************************************************************************
//*****************************************************************************

e8_enter_mall_vo()
{
	level endon( "e8_complete" );
	
	//level thread nag_move_foward( "aqua_explosion_trigger" );		// harper and salazar nag vo.
	
	flag_wait( "intro_explosion_dialog" );
	level.player say_dialog( "fari_what_happened_0" );				// Farid: What happened?
	level.ai_harper  say_dialog( "harp_defalco_detonated_a_0" );	// Harper: DeFalco detonated a fucking bomb outside the nightclub!  He has the girl.
	level.player say_dialog( "sect_patch_us_into_the_se_0" );		// Mason: Patch us into the security cameras for this deck.
//	level.ai_harper  say_dialog( "harp_these_dumbass_mall_c_0" );	// Harper: These dumbass mall cops don't stand a chance against mercs.
	
	flag_set( "pip_defalco_in_mall_flag" );
	level.player say_dialog( "sect_there_he_s_in_the_0" );			// Mason: There - He's in the Mall!
	level.player say_dialog( "sect_let_s_go_1" );					// Mason: Let's go.
	
	flag_wait( "e7_pip_defalco_in_mall" );
	level.ai_harper  say_dialog( "harp_we_got_choppers_over_0" );	// Harper: We got choppers overhead!...
	level.ai_salazar say_dialog( "sala_infantry_rappelling_0" );	// Salazar: Infantry rappelling in!
	level.ai_harper  say_dialog( "harp_they_really_want_thi_0");	// Harper: They really want this Karma chic bad.
	
	flag_wait( "store_explosion_dialog" );
	level.player say_dialog( "sect_farid_defalco_s_bl_0" );			// Mason: Farid!  DeFalco's blowing the ship!
	level.ai_harper  say_dialog( "harp_is_the_son_of_a_bitc_0" );	// Harper: Is the son of a bitch still on board?!
	level.player say_dialog( "fari_i_m_not_sure_i_ca_0" );			// Farid: I'm not sure... I can't see.
	level.ai_harper  say_dialog( "harp_we_can_t_let_that_ba_0" );	// Harper: Is the son of a bitch still on board?!
	
	level thread nag_move_foward( "aqua_explosion_trigger" );		// harper and salazar nag vo.
	
	level waittill( "aqua_explosion_trigger" );
	level.player say_dialog( "fari_i_have_him_exiting_0" );			// Farid: I have him - Exiting the Mall!
	level.ai_harper  say_dialog( "harp_this_bastard_s_reall_0" );	// Harper: This bastard's really pissin' me off!!
	level.player say_dialog( "sect_farid_you_have_to_0" );			// Mason: Farid!  You have to jam DeFalco's detonator.
	level.player say_dialog( "fari_i_m_working_on_it_0" );			// Farid: I'm working on it!
	
	flag_wait( "start_gatepull" );
	level.player say_dialog( "sect_get_it_open_0" );			// Mason: Get it open.
	
	
	
}

nag_move_foward( str_end_flag )
{
	level endon( str_end_flag );
	
	a_harper_nag = [];
	a_harper_nag[ 0 ] = "harp_we_can_t_let_that_ba_0";  //We can't let that bastard escape!
	a_harper_nag[ 1 ] = "harp_dammit_we_gotta_pi_0"; 	//Dammit - We gotta pick up the pace!
	a_harper_nag[ 2 ] = "harp_push_through_before_0";  	//Push through, before DeFalco escapes!
	a_harper_nag[ 3 ] = "harp_shit_man_he_s_getti_0";  	//Shit man, he's getting away!
	a_harper_nag[ 4 ] = "harp_briggs_ain_t_gonna_b_0";  //Briggs ain't gonna be happy if we lose the girl!
	a_harper_nag[ 5 ] = "harp_keep_moving_section_0";  	//Keep moving, Section.
	a_harper_nag[ 6 ] = "harp_we_gotta_move_we_re_0";  	//We gotta move! We're losing ground!
	
	a_salazar_nag = [];
	a_salazar_nag[ 0 ] = "sala_where_the_hell_is_he_0";  //Where the Hell is he?
	a_salazar_nag[ 1 ] = "sala_we_re_going_to_lose_0"; 	 //We're going to lose him!
	a_salazar_nag[ 2 ] = "sala_defalco_s_getting_aw_0";  //DeFalco's getting away.
	a_salazar_nag[ 3 ] = "sala_we_have_to_move_fast_0";  //We have to move faster!
	a_salazar_nag[ 4 ] = "sala_don_t_slow_down_0";  	 //Don't slow down!
	a_salazar_nag[ 5 ] = "sala_we_re_losing_him_0";  	 //We're losing him!
	a_salazar_nag[ 6 ] = "sala_hurry_section_0";  		 //Hurry, Section!

	
	wait 7;
	
	while( !flag( str_end_flag ) )
	{
		if ( cointoss() )
		{
			level.ai_harper say_dialog( a_harper_nag[ RandomInt( a_harper_nag.size ) ] );
		}
		
		else
		{
			level.ai_salazar say_dialog( a_salazar_nag[ RandomInt( a_salazar_nag.size ) ] );
		}
		
		wait RandomFloatRange( 7.0, 9.0 );
	}
}
//*****************************************************************************
//*****************************************************************************
// SPECIALTY PERK - Brite Force for the Blockage
//*****************************************************************************
//*****************************************************************************

brute_force_perk()
{
	level endon( "e8_complete" );

	level.vh_friendly_asd = spawn_vehicle_from_targetname( "specialty_asd" );
	wait( 1.0 );	// wait for bootup to finish
	level.vh_friendly_asd maps\_metal_storm::metalstorm_off();

	// Wait for the perk to arrive
	while( 1 )
	{
		if( level.player HasPerk( "specialty_brutestrength" ) )
		{
			break;
		}
		
		wait( 0.1 );
	}
	
	// Set the Brute Force Objective
	s_brute = getstruct( "brute_force_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_brute.origin, "interact" );
	
	GetEnt( "t_brute_force_use", "targetname" ) SetHintString( &"KARMA_2_PERK" );
	trigger_wait( "t_brute_force_use" );

	t_brute_use = GetEnt( "t_brute_force_use", "targetname" );
	t_brute_use Delete();
	
	e_blockage_clip = GetEnt( "brute_force_blocker_clip", "targetname" );
	e_blockage_clip trigger_off();
	
	run_scene_and_delete( "brute" );	
	
	set_objective( level.OBJ_INTERACT, s_brute, "remove" );

	level.player thread brute_force_dialog();
	flag_wait( "friendly_asd_activated" );

	level.vh_friendly_asd thread friendly_asd_think();
}

brute_force_dialog()
{
 	self say_dialog("sect_farid_we_ve_got_an_0");	//Farid!  We've got an ASD unit waiting for tasking -  Remote Station 55.
    self say_dialog("sect_can_you_program_it_t_0");	//Can you program it to provide support based on our Biometric IDs?
    self say_dialog("fari_i_ll_try_0");				//I'll try...
    self say_dialog("fari_station_55_55_0");		//Station 55... 55.... Got it!
    self say_dialog("fari_set_parameters_id_0");	//Set parameters... ID monitor and protect...
    self say_dialog("fari_initiate_boot_sequen_0");	//Initiate boot sequence...
  
    flag_set( "friendly_asd_activated" );
    self say_dialog("harp_you_re_a_miracle_wor_0", 2.0);	//You're a miracle worker, Farid!
}


//
friendly_asd_think()
{
	self endon( "death" );

	self thread maps\_metal_storm::metalstorm_on();
	self thread maps\_metal_storm::metalstorm_set_team( "allies" );
	self SetThreatBiasGroup( "allies" );

	CONST N_DIST_TOO_FAR = 500*500;
 	CONST N_DIST_DEFEND  = 300*300;
 	
	while( 1 )
	{
		n_dist = DistanceSquared( self.origin, level.player.origin );
		if ( n_dist > N_DIST_TOO_FAR )
		{
			self thread maps\_vehicle::defend( level.player.origin, 144 );
			self SetSpeed( 15, 5, 5 );
		}
		wait( 2.0 );
	}
}


//*****************************************************************************
//*****************************************************************************
// SALAZAR DOOR BREACH EVENT
//*****************************************************************************
//*****************************************************************************

salazar_door_breach_event()
{
	//*****************************************
	// Door Opening to Swimming Pool Area Event
	//*****************************************

	// Salazar runs to the start node, then plays an animation opening the door
	//level thread salazar_unlock_door_animation();
	level.ai_salazar setgoalpos( level.ai_salazar.origin );
	wait_network_frame();

	//IPrintLnBold( "Salazar Anim reach into door  position" );
	
	// Wait for Salazar to start the breach animation (ANIM REACH)
	level.ai_salazar waittill( "goal" );
	
	wait_network_frame();
	run_scene_and_delete( "scene_event8_door_breach_salazar" );

	player_at_gate_pos = getent( "player_at_gate_pos", "targetname" );
	player_at_gate_pos trigger_on();
	
	level thread run_scene( "scene_event8_door_breach_salazar_idle" );
	
	//level waittill("player_at_gate_pos");
	
	while(!level.player istouching(player_at_gate_pos) )
	{
	    wait .05;
	      
	 }
	
	end_scene( "scene_event8_door_breach_salazar_idle" );


	//*******************************************
	// Turn on some wounded civs behaind the door
	//*******************************************

	level thread e8_setup_wounded_civs_groupc( 2, "e9_player_in_pool_area" );


	//**************************
	// Now start the door breach
	//**************************
	level thread run_scene_and_delete( "scene_event8_door_breach" );
//	level thread run_scene_and_delete( "scene_event8_door_breach_harper" );
//	level thread run_scene_and_delete( "scene_event8_door_breach_salazar_end" );
	//level thread e8_animate_door_to_e9();
	//level thread stair_civs_rush_pathing_through_door( 0.1 );
		
	level thread karma_9_1_gate_lift_hero_run_to_path( "harper_exit_gate_node", "scene_event8_door_breach_harper" );
	level thread karma_9_1_gate_lift_hero_run_to_path( "salazar_exit_gate_node", "scene_event8_door_breach_salazar_end" );
		
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node1", "scene_event8_civ_escape1" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node2", "scene_event8_civ_escape2" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node3", "scene_event8_civ_escape3" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node4", "scene_event8_civ_escape4" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node5", "scene_event8_civ_escape5" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node6", "scene_event8_civ_escape6" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node7", "scene_event8_civ_escape7" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node8", "scene_event8_civ_escape8" );
	level thread karma_9_1_gate_lift_civ_run_to_path( "civ_exit_node9", "scene_event8_civ_escape9" );
	
	level thread remove_door_collision( 2, 2 );

	// Wait for the Door Breach scene to finish
	scene_wait( "scene_event8_door_breach" );
	//level thread gate_open_idle();
	flag_set( "event8_salazar_unlocks_exit_door" );
//	flag_set( "e8_door_breach_complete" );
	
//	wait( 1 );

	// Trigger color 11 - Friednlies go through the door
	e_trigger = getent( "e8_color_11", "targetname" );
	e_trigger triggerOn();
	e_trigger activate_trigger();
}

karma_9_1_gate_lift_hero_run_to_path( run_to, str_scene_name, delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Staring Civs Escape into Mall" );
//	flag_wait( "start_gatepull" );
	
	level thread run_scene( str_scene_name );
	
	wait( 1 );
	a_ai = get_ais_from_scene( str_scene_name );
	scene_wait( str_scene_name );
	
	n_node = getnode( run_to, "targetname" );
	
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i].goalradius = 48;
		a_ai[i] setgoalnode( n_node );
 		a_ai[i] waittill("goal");
	}	
	
}

//*****************************************************************************
//*****************************************************************************

remove_door_collision( delay, door_time )
{
	e_door_clip = getent( "e7_door_clip", "targetname" );
	wait( delay );
	
	pos = e_door_clip.origin;
	up = anglestoup( e_door_clip.angles );
	pos = pos + ( up*(42*3) );
	
	e_door_clip connectpaths();
	e_door_clip moveto( pos, door_time, 0.5, 0.5 );
}


//*****************************************************************************
//*****************************************************************************

salazar_unlock_door_animation()
{
	//IPrintLnBold( "Clearing Salazar Goal" );

//	level endon("player_at_gate_pos");
	// Clear Salazars goal
	level.ai_salazar setgoalpos( level.ai_salazar.origin );
	wait_network_frame();

	//IPrintLnBold( "Salazar Anim reach into door  position" );
	
	// Wait for Salazar to start the breach animation (ANIM REACH)
	level.ai_salazar waittill( "goal" );
	
	wait_network_frame();
	run_scene( "scene_event8_door_breach_salazar" );
	
	flag_set( "event8_salazar_unlocks_exit_door" );
	player_at_gate_pos = getent( "player_at_gate_pos", "targetname" );
	player_at_gate_pos trigger_on();
	
	level thread run_scene( "scene_event8_door_breach_salazar_idle" );
	
}


//*****************************************************************************
//*****************************************************************************
// Activate the Enemy RPG Killers
//*****************************************************************************
//*****************************************************************************

e8_aquarium_rpg_killers_trigger( delay, str_category )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	// Wait for trigger
	level waittill( "e8_civs_staircase_triggered" );

	level thread salazar_get_into_door_open_position( 10 );

	level thread e8_end_rpg_killer( 1, "e8_rpg_killer_1", str_category );
	//level thread e8_end_rpg_killer( 5, "e8_rpg_killer_2", str_category );

	// Regular
	a_spawners = getentarray( "e8_end_room_enemy_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_end_rpg_killer( delay, str_targetname, str_category )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	sp_guy = getent( str_targetname, "targetname" );

	e_ai_rpg = simple_spawn_single( sp_guy );
	e_ai_rpg spawn_fn_ai_run_to_target( false, str_category, true, true, false );
	
	e_ai_rpg endon( "death" );
	e_ai_rpg.script_accuracy = 0.9;
	
//	IPrintLnBold( "RPG GUY: ready to fire" );
	
	start_time = gettime();
	fire_time = 15;
	alive_time = 20;

	str_targetname = "e8_end_room_friendly_spawner_ai";
	e_ai_rpg thread vo_check_for_friendly_deaths( str_targetname );

	while( 1 )
	{
		// Any targets left?
		a_targets = getentarray( str_targetname, "targetname" );
		if( !IsDefined(a_targets) || (a_targets.size == 0) )
		{
			//IPrintLnBold( "ALL DEAD" );
			break;
		}

		// Time up yet?
		time = gettime();
		total_time = ( time - start_time ) / 1000;
		if( total_time >= fire_time )
		{
			break;
		}

		// Get a target
		index = randomint( a_targets.size );
		ai_target = a_targets[ index ];
		e_ai_rpg thread shoot_at_target( ai_target );
				
		// Wait for next fire attempt
		fire_wait = randomintrange( 2, 4 );
		wait( fire_wait );
	}
	
	// Kill him after some time
	while( 1 )
	{
		time = gettime();
		total_time = ( time - start_time ) / 1000;
		if(  IsAlive( e_ai_rpg ) && (total_time >= alive_time) )
		{
			pos = e_ai_rpg.origin;
			dir = AnglesToForward( e_ai_rpg.angles );
			pos = pos + (dir * (42*0.5));
			playfx( level._effect["def_explosion"], pos );
			e_ai_rpg dodamage( 1000, e_ai_rpg.origin );
			break;
		}
		wait( 0.1 );
	}
}


//*****************************************************************************
//*****************************************************************************

// self = rpg attacker
vo_check_for_friendly_deaths( str_targetname )
{
	self endon( "death" );

	a_targets = getentarray( str_targetname, "targetname" );
	if( !IsDefined(a_targets) || (a_targets.size == 0) )
	{
		return;
	}
		
	max_targets = a_targets.size;

	while( 1 )
	{
		a_targets = getentarray( str_targetname, "targetname" );
		if( !IsDefined(a_targets) || (a_targets.size == 0) || (a_targets.size < max_targets) )
		{
			break;
		}
		wait( 0.2 );
	}
	
	level.player thread say_dialog( "poor_bastards_be_012", 1.5 );
}


//*****************************************************************************
// Battle between the friendly and enemy forces in the Aquarium
//*****************************************************************************

e8_end_room_friendly_enemy_battle( delay, str_friendly_category, str_enemy_category )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "End Mall Security Battle" );	

	// Spawn the dudes
	a_friendly = simple_spawn( "e8_end_room_friendly_spawner" );
	wait( 0.3 );
	a_enemy = simple_spawn( "e8_end_room_enemy_spawner" );
	wait( 0.3 );
	
	for( i=0; i<a_friendly.size; i++ )
	{
		e_ent = a_friendly[ i ];
		e_ent thread spawn_fn_ai_run_to_holding_node( false, str_friendly_category, true, false );
		e_ent.health = 10;
		e_ent.script_accuracy = 0.4;
	}

	for( i=0; i<a_enemy.size; i++ )
	{
		e_ent = a_enemy[ i ];
		e_ent thread spawn_fn_ai_run_to_holding_node( false, str_enemy_category, true, false );
		e_ent.script_accuracy = 1.0;
	}
}


//*****************************************************************************
//*****************************************************************************

e8_kill_all_enemy_at_end_of_mall( delay, str_objective_notify )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	a_volume = getentarray( "e8_aquarium_enemy_kill_volume", "targetname" );

	// Wait for all the enemy to be killed in the end area
	while( 1 )
	{
		a_enemy = GetAIArray( "axis" );
		if( !IsDefined(a_enemy) || (a_enemy.size == 0) )
		{
			break;
		}
	
		ai_inside = 0;
		for( i=0; i<a_enemy.size; i++ )
		{
			for( vol_num=0; vol_num<a_volume.size; vol_num++ )
			{
				if( a_enemy[i] IsTouching( a_volume[vol_num] ) )
				{
					ai_inside++;
					break;
				}
			}
		}
		
		if( ai_inside <= 0 )
		{
			break;
		}
	
		wait( 1 );
	}
	
	wait( 0.01 );
	level notify( "e8_thread_a3" );
	wait( 0.01 );

	//IPrintLnBold( "ALL ENEMY KILLED" );	

	level notify( str_objective_notify );
}


//*****************************************************************************
//*****************************************************************************

salazar_get_into_door_open_position( delay )
{
	wait( delay );

	nd_target = getnode( "e8_salazar_door_wait_position", "targetname" );
	level.ai_salazar.goalradius = 48;
	level.ai_salazar setgoalnode( nd_target );
}


//*****************************************************************************
//*****************************************************************************

e8_the_end_enemy_spawners( delay, str_category )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	flag_wait( "e8_door_breach_complete" );

	//IPrintLnBold( "MALL The End Spawners" );
	
	if( IsDefined(level.e8_skip_spawning_2) )
	{
		return;
	}

	// Regular
//	a_spawners = getentarray( "e8_the_end_regular_spawner", "targetname" );
//	if( IsDefined(a_spawners) ) 
//	{
//		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, 1, false, false );
//	}
	
	// If the player hasn't triggered Event 9, force trigger it for them
	level thread trigger_event9_timer( 12 );
}


//*****************************************************************************
//*****************************************************************************

trigger_event9_timer( delay )
{
	wait( delay );
	
	e_trigger = getent( "trigger_end_event8_2", "targetname" );
	if( IsDefined(e_trigger) )
	{
		e_trigger activate_trigger();		
	}
}


//*****************************************************************************
//*****************************************************************************
// Wounded civs
//*****************************************************************************
//*****************************************************************************

e8_setup_wounded_civs_groupa( delay, str_cleanup_group )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_1";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_2";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_3";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_4";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_5";

	for( i=0; i<scene_names.size; i++ )
	{
		level thread run_scene( scene_names[i] );
	}

	level waittill( str_cleanup_group );

	for( i=0; i<scene_names.size; i++ )
	{
		end_scene( scene_names[i] );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_setup_wounded_civs_groupb( delay, str_cleanup_group )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b1";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b2";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b3";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b4";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b5";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_b6";

	for( i=0; i<scene_names.size; i++ )
	{
		level thread run_scene( scene_names[i] );
	}

	level waittill( str_cleanup_group );

	for( i=0; i<scene_names.size; i++ )
	{
		end_scene( scene_names[i] );
	}
}


//*****************************************************************************
//*****************************************************************************

e8_setup_wounded_civs_groupc( delay, str_cleanup_msg )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_c1";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_c2";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_c3";
	scene_names[ scene_names.size ] = "scene_e8_wounded_civ_c4";

	for( i=0; i<scene_names.size; i++ )
	{
		level thread run_scene( scene_names[i] );
	}

	level waittill( str_cleanup_msg );

	for( i=0; i<scene_names.size; i++ )
	{
		end_scene( scene_names[i] );
	}
}

karma_9_1_gate_lift_civ_run_to_path( run_to, str_scene_name, delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Staring Civs Escape into Mall" );
	flag_wait( "start_gatepull" );
	
	level thread run_scene( str_scene_name );
	wait( 1 );
	a_ai = get_ais_from_scene( str_scene_name );
	scene_wait( str_scene_name );
	
	n_node = getnode( run_to, "targetname" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] thread run_to_node_and_die( n_node );
	}
}

ai_cant_sprint()
{
	self endon( "death" );
	
	//self.ignoreall = true;
	//self enable_cqb();
	self.a.neversprintforvariation = true;
}

