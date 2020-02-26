
#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_ai_rappel;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//
// USEFUL AI STUFF
//
// e_ai.fixednode = true;		// forces a guy to stay on a node
// node exposed					// Makes an ai fire aggressively
// script_forcerambo 1			// NODE: Puts AI into aggressive Rambo behaviour
// pacifist						// if true - the ai will not fire
// g_friendlyfiredist			// should control distance firendlies fire at
// ignoreme and ingoreall		// misc ai ignore params
// self.favoriteenemy
// self.attackeraccuracy
// 



//*****************************************************************************
//*****************************************************************************

karma_init_rusher_distances()
{														// in metres?
	level.player_rusher_jumper_dist = (42*6);			// 42*6
	level.player_rusher_vclose_dist = (42*7);			// 42*7
	level.player_rusher_fight_dist = (42*12);			// 42*12
	level.player_rusher_medium_dist = (42*15);			// 42*15
	level.player_rusher_player_busy_dist = (42*22);		// 42*22
}


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "asd_intro_done" );
	
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
	// West path
	add_spawn_function_ai_group( "vol_sundeck_mall", 		::fighting_withdrawl );
	add_spawn_function_ai_group( "vol_sundeck_west_1f", 	::fighting_withdrawl );
	add_spawn_function_ai_group( "vol_sundeck_west_2f", 	::fighting_withdrawl );
	
	// Middle path
	add_spawn_function_ai_group( "vol_north_cliff_west_1f", ::fighting_withdrawl );
	add_spawn_function_ai_group( "vol_north_cliff_west_2f", ::fighting_withdrawl );
	
	// South path
	add_spawn_function_ai_group( "vol_south_cliff_west", 	::fighting_withdrawl );
	add_spawn_function_ai_group( "vol_cliffs_east", 		::fighting_withdrawl );
	
	// Northeast arm
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
	level.ai_harper		= init_hero( "harper" );
	level.ai_salazar	= init_hero( "salazar" );
	level.ai_redshirt1	= init_hero( "redshirt1" );
	level.ai_redshirt2	= init_hero( "redshirt2" );

	skipto_teleport( "skipto_little_bird" );

	level thread maps\createart\karma_2_art::vision_set_change( "sp_karma2_mall_interior" );
	maps\karma_enter_mall::mall_ambient_effects();
	
	trigger_use( "e8_color_11" );

//TODO TEMP TESTING...DELETE WHEN DONE Brute Perk
	level.vh_friendly_asd = spawn_vehicle_from_targetname( "specialty_asd" );
	flag_set( "friendly_asd_activated" );
	
	s_teleport = GetStruct( "skipto_sundeck_asd", "targetname" );
	level.vh_friendly_asd.origin = s_teleport.origin;
	level.vh_friendly_asd thread friendly_asd_think();
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

	level thread show_geo_models_trigger();

	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/

	// Set Wind Magnitude
	SetSavedDvar( "wind_global_vector", "213 148 -56" );

	// Objectives
	level thread little_bird_objectives();

	karma_init_rusher_distances();
	setup_fallback_monitors();

	maps\karma_2_anim::sundeck_anims();
	level thread civilians_injured_from_battle_anim();

	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************
	level thread squad_sundeck_fight();

	//****************************
	// Gump load unique Animations
	//****************************
	load_gump( "karma_2_gump_sundeck" );
	
	//**************
	// Save Progress
	//**************
	level thread autosave_by_name( "e9_starts_up" );

	//**********************
	// Start the Engagements
	//**********************
	level.player thread metal_storm_intro_dialog();

	//**********************
	//	Progression of Events
	//**********************
	trigger_wait( "t_asd_intro" );

	level thread asd_intro();

	level thread e9_civilian_spawning();
	
	// Spawn the enemy AI
	level thread e9_wave_spawning();

	// enter the sundeck
	trigger_wait( "e9_player_enters_sundeck" );

	// Kill off the dead civs at the top of the stairs
	//	stop rushers
	level notify( "e9_player_in_pool_area" );
	wait( 10 );	// let the player run around a bit before...
	
	exploder( 899 );	// detonate the towers
	
	
	trigger_wait( "trigger_end_event9_2" );
	             
	level thread defalco_helipad_pip();


	flag_wait( "event9_complete" );
}


//*****************************************************************************
//*****************************************************************************

show_geo_models_trigger()
{
	// First hide it
	maps\karma_exit_club::karma2_hide_tower_and_shell();

	// Then unhide
	e_trigger = getent( "e9_shell_model_swap", "targetname" );
	e_trigger waittill( "trigger" );
	
	maps\karma_exit_club::karma2_show_tower_and_shell();	
}


//*****************************************************************************
// AI WAVES
//*****************************************************************************
e9_civilian_spawning()
{
	str_category_startup = "e9_wave_1_startup";

	// Animation Threads
	level thread civilian_group4_waiting_to_escape_anim( 4 );				// 3
//	level thread civilian_left_stairs_group1_anim( 0.1 );
	level thread civilian_left_stairs_group2_anim( 2 );
	level thread civilian_balcony_fling_anim( 2, str_category_startup );	// 2
	// Wounded civs - Part 1
	level thread e9_setup_wounded_civs_groupa( 4, "str_cleanup_civs_groupa" );
		

}


e9_wave_spawning()
{
	//***********************************
	// Wave 1
	//***********************************

	str_category_startup = "e9_wave_1_startup";

	// Helicopter Rappelling in guys at the start
	level thread helicopter_rappel_intro( 3 );

	if( level.e9_skip_beginning == false )
	{
		// If the player hangs around too much at the start, send rushers after him
		level thread e9_start_player_rushers( str_category_startup );
	
		// Enemy spawners - 1st main attack wave, they run from over the pool bridges
		level thread e9_bridge_runners( 1.5, str_category_startup );					// 0.5

		// Set piece event with friendlies fighting enemy soldiers in the distance by the stairs
// sb42 - TODO: Maybe put this on a trigger at the base of the start stairs
		level thread e9_start_balcony_death_event( 0.5, 8 );							// 4, 8

		// Info volume that keeps spawning dudes at the player if he hangs around in the start area
		level thread e9_keep_player_busy_at_start_trigger( 0.5, str_category_startup );

// West bridge, heading north
		// Trigger near the 1st bridge over the pool that brings in the RPG guy	
		level thread e9_sundeck_west_rpg( 1, str_category_startup );

		// Trigger on the 1st bridge over the pool, directly ahead at the start	
		level thread e9_manager_upper_left_stairs( str_category_startup );

		// Trigger at the 2nd bridge over the pool by the rocks
		level thread e9_stairs_by_blockage_trigger( 8, str_category_startup );

		// Triggered as we approach the far left staircase	
		level thread e9_player_reaches_bottom_left_stairs_trigger( 6, str_category_startup );
		
		// Not triggered unless we reach the far left staircase
		level thread e9_left_staircase_climbing_trigger( 7, str_category_startup );
	}
	
	// Triggers for Civs getting flushed out
	level thread e9_civ_rocks_right_trigger( 0.1 );
	
	// Pre Metal Storm battle Civs
	level thread e9_civs_right_pre_metal_storm_trigger( 0.1 );
	level thread e9_civs_left_pre_metal_storm_trigger( 0.1 );
		
	
	//***********************************
	// Wave 2
	//***********************************

	wait( 0.5 );	// Helps level startup

	str_category_snipers = "e9_wave_2_snipers";

	if( level.e9_skip_beginning == false )
	{
		level thread e9_bunker_right_begin_trigger( str_category_snipers );
		level thread e9_cliffs_trigger( str_category_snipers );
	
		level thread e9_strength_test_dude( "rocks_jump_down_guy1_trigger", str_category_snipers, 3 );
		level thread e9_strength_test_dude( "rocks_jump_down_guy2_trigger", str_category_snipers, 1 );

		level thread e9_left_upper_tunnel_spawner( str_category_snipers );

		level thread e9_setup_balcony_explosion_blocker_triggers();

		level thread little_bird_attack_drinks_area();
	}
	
	level thread e9_bunker_enemy_management( str_category_snipers );
		

	//**************************
	//**************************
	// POST METAL STORM TRIGGERS
	//**************************
	//**************************
	
	flag_wait( "reached_the_rocks_objective" );

	//**************
	// Civs triggers
	//**************
	
	level thread e9_civ_left_end_trigger( 0.1 );
	level thread e9_civ_right_end_trigger( 0.1 );
	level thread e9_civ_middle_end_trigger( 0.1 );
	
	
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
	
	
	//left side fallback - PC
	level thread left_fallback1();
	level thread left_fallback2();
	level thread left_fallback3();
}


//
//	Ripped from Yemen
intro_asd_think()
{
	self endon( "death" );

	self thread maps\_metal_storm::metalstorm_set_team( "team3" );
	self SetThreatBiasGroup( "ship_drones" );

	// Now make ASD drive into view
	s_dest = GetStruct( "asd_intro_start", "targetname" );
	self thread maps\_vehicle::defend( s_dest.origin, 64 );
	wait( 2.5 );
	
	// Absolutely hit the column
	s_shot_start = GetStruct( "asd_missile_hit", "targetname" );
	s_shot_dest  = GetStruct( s_shot_start.target, "targetname" );
	MagicBullet( "metalstorm_launcher", s_shot_start.origin, s_shot_dest.origin, self );
	wait( 0.4 );
	
	level notify( "fxanim_column_explode_start" );
	exploder( 799 );	// column explosion fx
	wait( 0.05 );
	
	RadiusDamage( s_shot_dest.origin, 140, 500, 500, self );
	wait( 4.0 );	// give him time to stay in the intro spot
	self waittill_any( "near_goal" );

	flag_set( "asd_intro_done" );

	// Now move into position to intercept the bridge
	s_dest = GetStruct( s_dest.target, "targetname" );
	self thread maps\_vehicle::move_to( s_dest.origin );
	self waittill_any( "goal", "near_goal", "damage" );	

	self thread maps\_vehicle::defend( s_dest.origin, s_dest.radius );
}


//
//	ASD annihilates a couple of guys
asd_intro()
{
//	level thread civilians_running_from_battle_anim();
	wait( 0.3 );
	
	// Spawn initial guys
	a_ai_guards = simple_spawn( "e9_asd_intro_runner" );

	// Spawn ASD and let it rip
	vh_asd = spawn_vehicle_from_targetname( "metal_storm_intro" );
	vh_asd thread intro_asd_think();
	
	foreach( ai_guard in a_ai_guards )
	{
		ai_guard thread asd_intro_guard_think( vh_asd );
	}
}


//
//	Run to goal and shoot at ASD
asd_intro_guard_think( vh_asd )
{
	self SetThreatBiasGroup( "tacitus" );
	self waittill( "goal" );
	
	self thread shoot_at_target( vh_asd ); 
}


left_fallback1()
{	
	flag_wait ( "left_fallback_wave1" );
	//IPrintLnBold ("wave 1 fallback");
	array_thread( get_ai_group_ai("left_wave1_1"), ::set_goalpos_and_volume_from_targetname, "fallback_down" );
	array_thread( get_ai_group_ai("left_wave1_2"), ::set_goalpos_and_volume_from_targetname, "fallback_up_2" );
	array_thread( get_ai_group_ai("left_wave1_3"), ::set_goalpos_and_volume_from_targetname, "fallback_up_3" );
	array_thread( get_ai_group_ai("left_wave1_4"), ::set_goalpos_and_volume_from_targetname, "fallback_up_4" );
}
	
left_fallback2()
{		
	flag_wait ( "fallback_wave_2" );
	//IPrintLnBold ("wave 2 fallback");
	array_thread( get_ai_group_ai("left_wave2_1"), ::set_goalpos_and_volume_from_targetname, "fallback_down" );
	array_thread( get_ai_group_ai("left_wave2_2"), ::set_goalpos_and_volume_from_targetname, "fallback_up_3" );
	array_thread( get_ai_group_ai("left_wave2_3"), ::set_goalpos_and_volume_from_targetname, "fallback_up_4" );
}
	
left_fallback3()
{
	flag_wait ( "fallback_wave_3" );
	//IPrintLnBold ("wave 3 fallback");
	array_thread( get_ai_group_ai("left_wave3_1"), ::set_goalpos_and_volume_from_targetname, "fallback_up_1" );
	array_thread( get_ai_group_ai("left_wave3_2"), ::set_goalpos_and_volume_from_targetname, "fallback_up_2" );
}

set_goalpos_and_volume_from_targetname(targetname)
{
	org = getent( targetname, "targetname" );
	volume = getent( org.target, "targetname" );
	
	self.fixednode = false;
	self.goalheight = 512;
	self.pacifist = true;

	self allowedstances( "stand", "prone", "crouch" );	
	self setgoalpos( org.origin );
	self.goalradius = org.radius;
	self setgoalvolume( volume );
	
	self waittill ("goal");
	self.pacifist = false;

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
	set_objective( level.OBJ_ADVANCE_PAST_ROCKS, s_struct );


	//**********************************************************
	// Save point when player activates the Snipers on the Rocks
	//**********************************************************
	
	level waittill( "start_sniper_objective" );
	wait( 0.01 );
	event9_save( "e9_snipers" );


	//*********************************************
	// Wait for player to reach the rocks objective
	//*********************************************

	t_trigger_rocks waittill( "trigger" );
	set_objective( level.OBJ_ADVANCE_PAST_ROCKS, undefined, "delete" );
	flag_set( "reached_the_rocks_objective" );
	wait( 0.01 );


	//***************
	// Cleanup - Civs
	//***************

	level notify( "str_cleanup_civs_groupa" );

	// Startup the next set of wounded civs	
	level thread e9_setup_wounded_civs_groupb( 1, "str_cleanup_civs_groupb" );


	//************************************
	// Savegame as player passes the rocks
	//************************************

	event9_save( "e9_player_past_rocks" );

	
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
	
	
	//**************************
	// Metal Storm Battle Starts
	//**************************
	
	// Command friendlies to watch MS battle	
	level thread heros_watch_metal_storm_fight();

	e_metal_storm = spawn_vehicle_from_targetname( "metalstorm_midway" );
	e_metal_storm thread maps\_metal_storm::metalstorm_set_team( "team3" );
	e_metal_storm SetThreatBiasGroup( "ship_drones" );
	e_metal_storm thread maps\_vehicle::defend( e_metal_storm.origin, 500 );
	
	e_metal_storm = spawn_vehicle_from_targetname( "metalstorm_midway2" );
	e_metal_storm thread maps\_metal_storm::metalstorm_set_team( "team3" );
	e_metal_storm SetThreatBiasGroup( "ship_drones" );
	e_metal_storm thread maps\_vehicle::defend( e_metal_storm.origin, 1000 );
	
	// Command friendlies ahead after MS battle	
	level thread heros_move_after_metal_storm_fight();

	// Throw some enemies at the player to keep a battle going after the Metal Storms Death
	level thread e9_post_ms_background_enemy_rusher_control( "post_ms_rushers" );


	//*************************************************
	// Defalco drag 3 - on bridge in swimming pool area
	//*************************************************

	level thread defalco_karma_exiting_pool_area_pip();
	
	
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


	//***************
	// Cleanup - Civs
	//***************

	level notify( "str_cleanup_civs_groupb" );
	//Startup the next set of wounded civs	
	level thread e9_setup_wounded_civs_groupc( 1, "str_cleanup_civs_groupc" );


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
	load_gump( "karma_2_gump_the_end" );

	event9_save( "karma_little_bird" );
	wait( 0.05 );
	flag_set( "event9_complete" );

}


//*****************************************************************************
// CLEAN UP: Any stray ents for the End of Level Animation in Event 10
//*****************************************************************************

cleanup_ents_for_defalco_escape_animation()
{
	cleanup_ents( "e9_wave_3_ongoing" );
	cleanup_ents( "e9_wave_4_begins" );
}



//*****************************************************************************
// Save point - Wrapper for Event 9
//*****************************************************************************

event9_save( str_save_name )
{
	// If the hurryup timer is active, protect against a bad time save
	if( !flag("reached_the_rocks_objective") )
	{
		time = gettime();
		time_so_far = ( time - level.rocks_pacing_start_time ) / 1000;
		time_left = level.rocks_failed_time - time_so_far;
		
		// If there is less than 25 seconds left, make it 25 seconds left
		min_time_left = 25;
		if( time_left < min_time_left )
		{
			dt = (min_time_left - time_left) * 1000;	// convert to ms
			level.rocks_pacing_start_time = level.rocks_pacing_start_time + dt;
		}
	}

	// Save progress
	autosave_by_name( str_save_name );
}


//*****************************************************************************
//*****************************************************************************

heros_watch_metal_storm_fight()
{
	t_trigger = getent( "color_metal_storm_begins_trigger" , "targetname" );
	t_trigger activate_trigger();
	
	//IPrintLnBold( "HEROS WATCH METAL STORM" );
	
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
	
	//IPrintLnBold( "HEROS MOVE AFTER METAL STORM" );
	
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

//	Handle the Squad through the sundeck
squad_sundeck_fight()
{
	level.ai_harper		setup_squad_member( "g", "navy_seals" );
	level.ai_salazar	setup_squad_member( "g", "navy_seals" );
	level.ai_redshirt1	setup_squad_member( "r", "ship_security" );
	level.ai_redshirt2	setup_squad_member( "r", "ship_security" );

	//***********************************
	// Get all the friendlies in an array
	//***********************************
	a_friendlies = [];
	a_friendlies[ 0 ] = level.ai_harper;
	a_friendlies[ 1 ] = level.ai_salazar;
	a_friendlies[ 2 ] = level.ai_redshirt1;
	a_friendlies[ 3 ] = level.ai_redshirt2;
	
	//**********************************************
	// Just eye candy at the start of the checkpoint
	//**********************************************
	foreach( ai_ent in a_friendlies )
	{
		ai_ent.ignoreme = true;
		ai_ent.ignoreall = true;
	}
	flag_wait( "asd_intro_done" );
wait( 10 );	//TODO temp to make our guys not shoot at the ASD right away.  Needs to be handled

	//*****************************
	// Time for the battle to start
	//*****************************
	foreach( ai_ent in a_friendlies )
	{
		ai_ent.ignoreme = false;
		ai_ent.ignoreall = false;
	}
}


//
//	Squadmate init
setup_squad_member( str_color, str_threat_bias_group )
{
	self set_force_color( str_color );
	self SetThreatBiasGroup( str_threat_bias_group );
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
		simple_spawn_script_delay( a_ents );
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
			a_ents[i] add_cleanup_ent( str_category );
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
		// group spawns and comes around the middle
		a_ents = getentarray( "e9_bunker_left_flank_spawner", "targetname" );
		if( IsDefined(a_ents) ) 
		{
			simple_spawn_script_delay( a_ents );
		}
	}
	
	if( flag("flag_use_right_bunker_spawners") )
	{
		// Smallish attack wave around the right side of the rocks
		a_ents = getentarray( "e9_right_rocks_wave1_spawner", "targetname" );
		if( IsDefined(a_ents) ) 
		{
			simple_spawn_script_delay( a_ents );
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

e9_cliffs_trigger( str_category )
{
	level endon( "metal_storm_cleanup" );

	e_trigger = getent( "e9_cliffs_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	// Civs get flushed out
	level thread civ_run_from_node_to_node( 0.3, "stair_rush_girl_a", "e9_civ_rocks_mid_start" );
	level thread civ_run_from_node_to_node( 0.1, "stair_rush_guy1_a", "e9_civ_rocks_mid_2_start" );

	// Rushers
	simple_spawn( "e9_cliffs_rusher_spawner", ::aggressive_runner, str_category );

	// Exposed
	simple_spawn( "e9_cliffs_spawner" );
}


//*****************************************************************************
//*****************************************************************************

e9_start_player_rushers( str_category )
{
	level endon( "e9_player_in_pool_area" );

	player_wait = 10.0;				// 8.5
	wait( player_wait );

	//IPrintLnBold( "1st Rusher Attack" );

	sp_rusher = getent( "e9_start_player_hurryup_1", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread aggressive_runner( str_category );
	}


	// Delay before the 2nd rushers arrive

	wait( 12 );

	sp_rusher = getent( "e9_start_player_hurryup_2", "targetname" );
	e_ai = simple_spawn_single( sp_rusher );
	if( IsDefined(e_ai) )
	{
		e_ai thread aggressive_runner( str_category );
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
		simple_spawn_script_delay( a_runners );
//		simple_spawn_script_delay( a_runners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
	}
}


//*****************************************************************************
//
//*****************************************************************************

e9_start_balcony_death_event( start_delay, battle_time )
{
	if( IsDefined(start_delay) && (start_delay > 0) )
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
	if ( IsAlive( ai_target ) )
	{
		self thread entity_fake_tracers( ai_target );
		
		while( IsDefined(ai_target) && (ai_target.health > 0) )
		{
			self.lastgrenadetime = GetTime();	// Should stop them using grenades
			//self.grenadeammo = 0;
			
			self thread shoot_at_target( ai_target, "J_head" );
			delay = randomfloatrange(0.3, 0.6);
			wait( delay );
		}
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

e9_keep_player_busy_at_start_trigger( delay, str_category )
{
	wait( delay );

	start_time = gettime();
	last_ai_spawn_time = start_time;
	
	min_axis_alive = 3;
	min_spawn_wait_time = 20;
	
	volume = GetEnt( "vol_sundeck_mall", "targetname" );
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

						sp_rusher = getentarray( "e9_keep_player_busy_at_sundeck_mall", "targetname" );
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
								a_ai[i] thread aggressive_runner( str_category );
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

e9_left_staircase_climbing_trigger( delay, str_category_startup )
{
	level endon( "metal_storm_cleanup" );
	
	wait( delay );

	t_trigger = getent( "e9_stairs_start_left_climbing_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	a_ents = getentarray( "e9_stairs_start_left_climbing_spawner", "targetname" );
	if( IsDefined(a_ents) ) 
	{
		//iprintlnbold ( "STAIRCASE CLIMBING SPAWNERS" );
		simple_spawn_script_delay( a_ents, ::spawn_fn_ai_run_to_target, 0, str_category_startup, false, false, false );
	}
}


//*****************************************************************************
// RPG Guys at the start by the staircase past the swimming pool area
//*****************************************************************************

e9_sundeck_west_rpg( delay, str_category )
{
	level endon( "metal_storm_cleanup" );
	
	wait( delay );

	t_trigger = getent( "e9_player_enters_sundeck", "targetname" );
//	t_trigger = getent( "e9_start_staircase_rpg_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	// RPG Guy
	a_spawners = getentarray( "e9_left_stairs_rpg_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_manager_upper_left_stairs( str_category )
{
//	// Add spawn functions to the enemy spawners
//	sp_guys = GetEntArray( "e9_stairs_start_upper_left_spawner", "targetname" );
//	for( i=0; i<sp_guys.size; i++ )
//	{
//		sp_guys[i] add_spawn_function( ::spawn_fn_ai_run_to_target, undefined, str_category, false, false, false );
//	}

	trigger_wait( "e9_manager_upper_left_stairs_trigger" );
	
	//iprintlnbold ( "UPPER LEFT STAIRS SPAWNERS" );

	// Add a Save Point
	event9_save( "e9_upper_left_stairs" );
	
	flag_set( "upper_left_stairs_spawners_active" );

	level thread e9_civ_bridge_to_stairs( 0.8 );

	a_spawners = getentarray( "e9_left_staircase_begins_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners );
//		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_holding_node, 1, str_category, 1, false );
	}

	// Switch on the spawn manager and wait for it to complete
	str_spawn_manager = "e9_manager_upper_left_stairs";
	level.stairs_spawn_manager = str_spawn_manager;
	spawn_manager_enable( str_spawn_manager );

	// Start the Single Rusher
	e_spawner = getent( "e9_bridge_rusher_spawner", "targetname" );
	e_ai = simple_spawn_single( e_spawner, ::aggressive_runner, str_category );

	// Start the Left Stairs Sniper
	a_spawners = getentarray( "e9_start_staircase_sniper_spawner", "targetname" );
	simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, true, false );
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
		e_ent endon( "death" );
		
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
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "heli_circle_bar" );
	e_heli thread setup_helicopter_for_challenge();
	level.little_bird_status = e_heli;
	e_heli thread helicopter_fly_down_attack_path( 1, 1, undefined, 15, "little_bird_strafe_attack_start", (42*1.5), true );

	// Fire Missiles
	wait( 1.0 );	//9
	
	e_heli thread lb_missile_burst();

	e_heli waittill( "missiles away" );

	// Blow up the bar
	wait( 0.2 );
	
	playsoundatposition ( "evt_dome_explo_main" , (501, 609, -2979));
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
	e_mover playsound("wpn_little_bird_rocket_fire_npc");

	e_mover moveto( target_pos, move_time );
	
	wait( move_time );
	
	v_dir = anglestoforward( e_mover.angles );
	v_pos = e_mover.origin + (v_dir * (42*3));
	playfx( level._effect["def_explosion"], v_pos );
	playsoundatposition ("exp_little_bird_missile_explo", v_pos);

	
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

	strength_test_jumpdown_guy( e_trigger.target );
	
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
	level thread defalco_blows_up_building( 3 );

	// Kill the jump down trigger threads
	level notify( "strength_test_triggered" );
}


strength_test_jumpdown_guy( str_node )
{
	level.player.ignoreme = true;
	level.player EnableInvulnerability();
	
	s_align_loc = GetStruct( str_node, "targetname" );
	s_align = GetStruct( "generic_align" );
	s_align.origin = s_align_loc.origin;
	s_align.angles = s_align_loc.angles;

	// Intro
	level thread run_scene_and_delete( "sundeck_jump_attack_intro" );
	
	// Begin strength test hackery 
	level.player set_strengthtest_init( 16, 4 );
	level thread maps\_strength_test::strength_test_update( level.player, &"KARMA_2_STRENGTH_TEST" );

	wait( 4 );	// wait for struggle to start
	
	level.player ent_flag_set( "start_strength_test" );
	scene_wait( "sundeck_jump_attack_intro" );
	
	if ( level.player ent_flag( "strength_test_complete" ) )
	{
		level thread run_scene_and_delete( "sundeck_jump_attack_success" );
		wait( 0.1 );
		
		ai_pmc = get_ais_from_scene( "sundeck_jump_attack_success", "jump_attack_pmc" );
		scene_wait( "sundeck_jump_attack_success" );
		
		ai_pmc entity_hold_last_anim_frame( 1 );
		level.player DisableInvulnerability();
		
		// Saving
		event9_save( "strength_test_savepoint" );
	}
	else
	{
		level.player DisableInvulnerability();
		screen_message_delete();
		level run_scene_and_delete( "sundeck_jump_attack_failure" );
		MissionFailed();
	}
	
	level.player.ignoreme = false;
}


/*==============================================================
SELF: player
PURPOSE: Setup the Strength Test so we can use a customized version of it.
RETURNS: 
CREATOR: MikeA
===============================================================*/
set_strengthtest_init( max_button_presses, fail_time )
{
	self ent_flag_init( "start_strength_test" );
	self ent_flag_init( "strength_test_half_way" );
	self ent_flag_init( "strength_test_complete" );

	self.strengthtest_max_button_presses = max_button_presses;
	self.strengthtest_fail_time = fail_time;
	
	self.strengthtest_blur = 0;
	self.strengthtest_custom_fail = 1;
}


//
//	g1 is unused
spawn_post_strength_sharded_enemy( str_category, g0, g1, g2, g3 )
{
	if( g0 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g0_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
		}
	}
	if( g2 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g2_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
		}
	}
	if( g3 )
	{
		a_spawners = getentarray( "e9_bunker_post_jumpdown_right_g3_spawner", "targetname" );
		if( IsDefined(a_spawners) ) 
		{
			simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
		}
	}
}

strength_post_right_ai_attack( str_category )
{
	spawn_post_strength_sharded_enemy( str_category, 1, 1, 1, 1 );

	a_spawners = getentarray( "e9_bunker_post_jumpdown_right_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
	}
}

strength_post_middle_ai_attack( str_category )
{
	spawn_post_strength_sharded_enemy( str_category, 1, 1, 1, 1 );

	// Middle unique	
	a_spawners = getentarray( "e9_bunker_post_jumpdown_middle_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
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
			a_ai[i] thread aggressive_runner( str_category );
		}
	}
	
	a_spawners = getentarray( "e9_post_jumpdown_rpg_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 0, str_category, false, false, false );
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
	event9_save( "strength_test_savepoint" );
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
	
	level thread defalco_blows_up_building( delay );
	
	wait( 1.5 );
	level notify( "balcony_blocker_away" );
}


//*****************************************************************************
//*****************************************************************************

e9_player_reaches_bottom_left_stairs_trigger( delay, str_category )
{
	level endon( "metal_storm_cleanup" );
	
	wait( delay );

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

// Taken out the 2nd wave becuase its a little difficult
/*
	a_spawners = getentarray( "e9_player_reaches_bottom_left_stairs_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, 1, false, false );
	}
*/
	
}


//*****************************************************************************
//*****************************************************************************

e9_stairs_by_blockage_trigger( delay, str_category )
{
	level endon( "metal_storm_cleanup" );
	
	wait( delay );

	e_trigger = getent( "e9_stairs_by_blockage_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "2nd Staircase TRIGGERED" );

	// Add a Save Point
	event9_save( "e9_upper_left_stairs" );

	// Regular
	a_spawners = getentarray( "e9_north_cliff_west_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners );
//		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, 1, str_category, 1, false, false );
	}
	
	// Rushers
	simple_spawn( "e9_north_cliff_west_rusher", ::aggressive_runner, str_category );
}


//*****************************************************************************
// Defalco Blows up Blocker Building
//*****************************************************************************
defalco_blows_up_building( delay )
{
	// Soldiers run down staircase, coughing
	level thread e9_balcony_blowup_stairs_stumble_anim( 3 );
	
	// Soldiers thrown from building
//	level thread e9_balcony_blowup_ledge_fall_anim( 2 );
	
	// Blowup the Blocker Building
	level notify( "fxanim_balcony_block_start" );

	// Balcony blowup effects
	level thread balcony_blowup_effects();
	
	// Delete pristine stuff
	m_pristine = GetEnt( "sundeck_deck_explosion", "targetname" );
	if ( IsDefined( m_pristine ) )
	{
		m_pristine Delete();
	}
		
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
	e_heli thread setup_helicopter_for_challenge();
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

	self.b_rappelling = true;
	self waittill("rappel_done");

	self.b_rappelling = undefined;
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

	event9_save( "e9_post_metal_storm" );

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
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}
	
	// Rushers
	sp_rushers = getentarray( "e9_post_ms_left_begin_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread aggressive_runner( str_category );
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
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_left_wave2_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread aggressive_runner( str_category );
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
	
	event9_save( "e9_post_metal_left_wave3" );
	
	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_post_ms_left_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}
	
	// Jumper
	a_jumpers = getentarray( "e9_post_ms_left_wave3_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		simple_spawn( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, undefined );
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
			a_ai[i] thread aggressive_runner( str_category );
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
	
	event9_save( "e9_post_metal_storm" );
		
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
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}

	// Rushers
	sp_rushers = getentarray( "e9_post_ms_right_begin_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread aggressive_runner( str_category );
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
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_right_wave2_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread aggressive_runner( str_category );
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
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, undefined );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_post_ms_right_wave3_trigger( str_category )
{
	t_trigger = getent( "e9_post_ms_right_wave3_trigger", "targetname" );
	t_trigger waittill( "trigger" );
	
	//IPrintLnBold( "M STORM Right Wave 3" );

	event9_save( "e9_post_metal_right_wave3" );
	
	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_post_ms_right_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
	}

	// Add Rusher type AI
	sp_rushers = getentarray( "e9_post_ms_right_wave3_rusher_spawner", "targetname" );
	a_ai = simple_spawn( sp_rushers );
	if( IsDefined(a_ai) )
	{
		for( i=0; i< a_ai.size; i++ )
		{
			a_ai[i] thread aggressive_runner( str_category );
		}
	}
	
	// Jumper
	a_jumpers = getentarray( "e9_post_ms_right_wave3_jumper_spawner", "targetname" );
	if( IsDefined(a_jumpers) ) 
	{
		simple_spawn_script_delay( a_jumpers, ::spawn_fn_ai_run_to_jumper_node, true, str_category, false, false, undefined );
	}
}


//*****************************************************************************
//*****************************************************************************

e9_enemy_end_stairs_left( str_category )
{
	t_trigger = getent( "e9_enemy_end_stairs_left", "targetname" );
	t_trigger waittill( "trigger" );
		
	//IPrintLnBold( "END STAIRS LEFT SPAWNERS" );

	event9_save( "e9_enemy_end_stairs_left" );

	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );

	// Regular
	a_spawners = getentarray( "e9_enemy_end_stairs_left_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
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
			a_ai[i] thread aggressive_runner( str_category );
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

	event9_save( "e9_enemy_end_stairs_right" );

	// Helicopter Rappel
	level thread helicopter_rappel_end_level( 0.01, 1 );
	
	// Regular
	a_spawners = getentarray( "e9_enemy_end_stairs_right_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, false, str_category, false, false, false );
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
			a_ai[i] thread aggressive_runner( str_category );
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
	e_heli thread setup_helicopter_for_challenge();
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

// Injured couple
civilians_injured_from_battle_anim()
{
	level thread run_scene( "sundeck_civ_injured_and_helper_idle" );
	flag_wait( "sundeck_civ_injured_and_helper_idle_started" );

	a_ais = get_model_or_models_from_scene( "sundeck_civ_injured_and_helper_idle" );
	foreach( ai in a_ais )
	{
		ai add_cleanup_ent( "sundeck_intro" );
	}
}


//	Man gets shot and woman stops to help
//	now a part of the ASD intro, so they will most likely be killed
civilians_running_from_battle_anim()
{
	thread run_scene( "sundeck_civ_injured_and_helper" );
	flag_wait( "sundeck_civ_injured_and_helper_started" );

	a_ais = get_ais_from_scene( "sundeck_civ_injured_and_helper" );
	foreach( ai in a_ais )
	{
		ai add_cleanup_ent( "sundeck_intro" );
	}
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
	flag_wait( "karma_2_gump_sundeck" );

	// Animation: Part 1 of 3	
	level thread run_scene( "scene_civilian_group4_escape_begin_loop" );

	// Time for the anim to create ents
	trigger_wait( "e9_player_enters_sundeck" );

	// Animation: Part 2 of 3
	run_scene( "scene_civilian_group4_escape_running" );

	// Animation: Part 3 of 3
	level thread run_scene( "scene_civilian_group4_escape_end_loop" );

	// Kill off the scene after time	
	wait( 100 );
	delete_scene( "scene_civilian_group4_escape_end_loop" );
}


////*****************************************************************************
////*****************************************************************************
//
//civilian_left_stairs_group1_anim( delay )
//{
//	if( IsDefined(delay) )
//	{
//		wait( delay );
//	}
//	
//	// Gump safety wait	
//	flag_wait( "karma_2_gump_sundeck" );
//
//	// Animation: Part 1 of 4
//	level thread run_scene( "scene_civilian_left_stairs_group1_begin_loop" );
//	
//	// Waiting to trigger part 2, if player can see and within trigger distance
//	while( 1 )
//	{
//		dist = can_see_position( (-3905, 1752, -3278), 0.9 );
//		if( (dist > 0.0) && (dist < (49*50)) )	// (45*50)
//		{
//			break;
//		}
//		//IPrintLnBold( "ANIM Dist: " + dist );
//		wait( 0.25 );
//		
//		// If the player has reached the metal storm area, kill the civ anims
//		if( flag("flag_reached_metal_storm") )
//		{
//			delete_scene( "scene_civilian_left_stairs_group1_begin_loop" );
//			delete_scene( "scene_civilian_left_stairs_group2_begin_loop" );
//			return;
//		}
//	}
//	
//	level notify( "civilian_left_stairs_group1_anim_starting" );
//
//	// Animation: Part 2 of 4
//	run_scene( "scene_civilian_left_stairs_group1_run" );
//
//	// Animation: Part 3 of 4
//	level thread run_scene( "scene_civilian_left_stairs_group1_begin_loop_mid" );
//
//	// Pause for a bit
//	wait( 1 );
//	
//	max_wait_time = 120;
//	start_time = gettime();
//	while( 1 )
//	{
//		// Check for max wait time
//		time = gettime();
//		dt = ( time - start_time ) / 1000;
//		if( dt > max_wait_time )
//		{
//			break;
//		}
//		
//		// Now wait for the player to get close before next trigger
//		if( flag("upper_left_stairs_spawners_active") )
//		{
//			break;
//		}
//		
//		wait( 0.5 );
//	}
//		
//	// Animation: Part 4 of 4
//	level thread run_scene( "scene_civilian_left_stairs_group1_run_and_exit" );
//	
//	wait( 1.5 );
//	
//	level notify( "civilian_left_stairs_group1_anim_ending" );
//}


//*****************************************************************************
//*****************************************************************************

civilian_left_stairs_group2_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_2_gump_sundeck" );

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

civilian_balcony_fling_anim( delay, str_category )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_2_gump_sundeck" );

	str_scene_name = "scene_e9_start_balcony_fling";
	level thread run_scene( str_scene_name );
	
	// sb42	
	level thread add_effect_to_ent_when_stops_falling( 1, "balcony_fight_fling_friendly", level._effect["balcony_death_blood_splat"], 2 );

	wait( 1 );
	add_category_to_ai_in_scene( str_scene_name, str_category );
}


//*****************************************************************************
//*****************************************************************************

add_effect_to_ent_when_stops_falling( delay, str_ent_targetname, effect, min_wait )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	e_ai = getent( str_ent_targetname, "targetname" );
	e_ai endon( "death" );
	
	wait( min_wait );

	last_height = -1000000;
	
	while( 1 )
	{
		height = e_ai.origin[2];
		if( height == last_height )
		{
			break;
		}
		last_height = height;
		wait( 0.2 );
	}
	
	playfx( effect, e_ai.origin );
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

	run_scene( "sundeck_rocks_execution" );
	
	// Put the dead civilian into ragdoll death
	e_dead_civ = getent( str_civilian_killed_targetname, "targetname" );
	if ( IsAlive( e_dead_civ ) )
	{
		e_dead_civ ragdoll_death();
	}
	
	// Send the executioner to a cover node
	nd_node = getnode( "executioner_cover_node", "targetname" );
	e_executioner = getent( "guard_rocks_executioner_ai", "targetname" );
	e_executioner setup_bunker_enemy_params();
	e_executioner SetGoalPos( e_executioner.origin );
	e_executioner thread spawn_fn_ai_run_to_target( undefined, undefined, false, false, false );
	e_executioner add_cleanup_ent( str_category_snipers );

	// Make executioner a target again
	level make_ent_a_battle_target( str_executioner_targetname, undefined, undefined );
	e_executioner setup_bunker_enemy_params();
}


////*****************************************************************************
////*****************************************************************************
//
//e9_balcony_blowup_ledge_fall_anim( delay )
//{
//	if( IsDefined(delay) )
//	{
//		wait( delay );
//	}
//	
//	// Gump safety wait	
//	flag_wait( "karma_2_gump_sundeck" );
//
//	run_scene( "scene_e9_balcony_blowup_ledge_fall" );
//}


//*****************************************************************************
//*****************************************************************************

e9_balcony_blowup_stairs_stumble_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	// Gump safety wait	
	flag_wait( "karma_2_gump_sundeck" );

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

	level thread civ_run_along_node_array( 0.1, "stair_rush_guy1_b", "e9_civ_rocks_right_a" );
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy2_a", "e9_civ_rocks_right_b" );
}


//*****************************************************************************
//*****************************************************************************

e9_civ_bridge_to_stairs( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	level thread civ_run_along_node_array( 1.1, "stair_rush_guy2_b", "e9_civ_bridge_stairs_a", 1500 );
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy3_b", "e9_civ_bridge_stairs_b", 1500 );
}


//*****************************************************************************
//*****************************************************************************

e9_civs_right_pre_metal_storm_trigger( delay )
{
	e_trigger = getent( "e9_civs_right_pre_metal_storm_trigger" , "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	level thread civ_run_along_node_array( 0.1, "stair_rush_girl_a", "e9_civ_right_ms_a", 1500 );
	level thread civ_run_along_node_array( 1, "stair_rush_guy1_a", "e9_civ_right_ms_b", 1500 );
}


//*****************************************************************************
//*****************************************************************************

e9_civs_left_pre_metal_storm_trigger( delay )
{
	e_trigger = getent( "e9_civs_left_pre_metal_storm_trigger" , "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	level thread civ_run_along_node_array( 0.1, "stair_rush_girl_b", "e9_civ_left_ms_a", 1500 );
	level thread civ_run_along_node_array( 1, "stair_rush_guy1_b", "e9_civ_left_ms_b", 1500 );
}


//*****************************************************************************
//*****************************************************************************

e9_civ_left_end_trigger( delay )
{
	e_trigger = getent( "e9_civ_left_end_trigger" , "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Civs Left End Event 9" );
	
	level thread civ_run_along_node_array( 0.1, "stair_rush_guy2_b", "e9_civ_left_end_a", 1500 );
	level thread civ_run_along_node_array( 0.8, "stair_rush_girl_b", "e9_civ_left_end_b", 1500 );
	level thread civ_run_along_node_array( 2.0, "stair_rush_guy3_b", "e9_civ_left_end_a", 1500 );
}


//*****************************************************************************
//*****************************************************************************

e9_civ_right_end_trigger( delay )
{
	e_trigger = getent( "e9_civ_right_end_trigger" , "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Civs Right End Event 9" );

	level thread civ_run_along_node_array( 0.1, "rich_male_1", 		"e9_civ_right_end_a", 1500 );
	level thread civ_run_along_node_array( 0.6, "rich_female_1", 	"e9_civ_right_end_b", 1500 );
}



//*****************************************************************************
//*****************************************************************************

e9_civ_middle_end_trigger( delay )
{
	e_trigger = getent( "e9_civ_middle_end_trigger" , "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Civs Middle End Event 9" );

	level thread civ_run_along_node_array( 0.1, "rich_male_2", 		"e9_civ_middle_end_a", 1500 );
	level thread civ_run_along_node_array( 0.7, "rich_female_2",	"e9_civ_middle_end_b1", 1500 );
}


//*****************************************************************************
//*****************************************************************************
// PIP Moments in Event 9
//*****************************************************************************
//*****************************************************************************

defalco_karma_exiting_pool_area_pip()
{
	wait( 3 );	// not sure why it's delaying 3 secs
	
	level.player thread defalco_karma_exiting_pool_area_dialog();
	level thread pip_karma_event( "e9_defalco_karma_end_stairs_pip_cam", "sundeck_defalco_karma_end_stairs" );
	wait( 0.1 );
	
	clientNotify( "fov_zoom_e7_defalco_chase" );
}


//*************************
//	Defalco and Karma are sighted near the helipad
//*************************
defalco_helipad_pip( str_structname, str_scene_name )
{
	level.player thread defalco_helipad_dialog();
	pip_karma_event( "helipad_cam", "defalco_karma_helipad" );
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

	level.rocks_pacing_start_time = gettime();
	
	level.rocks_failed_time = 150;			// 150

	nag1 = 0;
	nag1_time = 100;						// 100
	nag2 = 0;
	nag2_time = 130;						// 130
	nag3 = 0;
	nag3_time = level.rocks_failed_time;

	while( flag("reached_the_rocks_objective") == 0)
	{
		time = gettime();
		dt = (time - level.rocks_pacing_start_time) / 1000;
	
		if( nag1 == 0 )
		{
			if( dt > nag1_time )
			{
				nag1 = 1;
				//level.ai_salazar thread say_dialog( "get_to_the_rocks_nag1" );
				level.player thread say_dialog( "weve_got_to_keep_008" );
			}
		}	
		
		if( nag2 == 0 )
		{
			if( dt > nag2_time )
			{
				nag2 = 1;
				level.player say_dialog( "hurry_it_up_009" );
				level.player say_dialog( "stay_on_him_010" );
				level.player say_dialog( "were_losing_him_011" );
			}
		}	

		if( nag3 == 0 )
		{
			if( dt > nag3_time )
			{
				nag3 = 1;
// temp disable				
//				missionfailedwrapper( &"KARMA_2_DEFALCO_ESCAPES_WITH_KARMA" );
				return;
			}
		}	
		
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
// Event 9 VO
//*****************************************************************************
//*****************************************************************************

metal_storm_intro_dialog()
{
	self			say_dialog("fari_al_jinan_s_defenses_0");	//Section!  Colossus's defenses are now armed to respond to a terrorist attack.
	self			say_dialog("fari_without_your_id_aut_0");	//Automated security will target armed personnel as hostile!
	level.ai_harper say_dialog("harp_that_include_the_ene_0");	//That include the enemy?
	self 			say_dialog("fari_any_armed_personnel_0");	//ANY armed personnel.
	level.ai_harper say_dialog("harp_least_it_s_not_all_b_0");	//Least it's not all bad news!
}


defalco_karma_exiting_pool_area_dialog()
{
    self say_dialog("fari_it_s_the_cell_phone_0");	//It's the cell phone!
    self say_dialog("sect_block_the_signal_0");		//Block the signal.
    self say_dialog("fari_working_on_it_0");		//Working on it.
}


defalco_helipad_dialog()
{
    self say_dialog("fari_you_guys_need_to_pic_0");	//You guys need to pick up the pace... He's nearly at the Evac deck.
    self say_dialog("fari_defalco_s_gone_to_a_0");	//DeFalco's gone to a lot of trouble to get this woman.
    self say_dialog("fari_he_will_not_hesitate_0");	//He will not hesitate to send Colossus to the bottom of the ocean, just to cover his tracks.
}


//*****************************************************************************
//*****************************************************************************
// Wounded civs
//*****************************************************************************
//*****************************************************************************

e9_setup_wounded_civs_groupa( delay, str_cleanup_group )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_1";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_2";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_3";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_4";

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

e9_setup_wounded_civs_groupb( delay, str_cleanup_group )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b1";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b2";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b3";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b4";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b5";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_b6";

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

e9_setup_wounded_civs_groupc( delay, str_cleanup_group )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	scene_names = [];
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_c1";
	scene_names[ scene_names.size ] = "scene_e9_wounded_civ_c2";

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


//************************************************************************************************
// throw some enem,y at the playet afert he metat storm fight, to keep the illision of war ongoing
//************************************************************************************************

e9_post_ms_background_enemy_rusher_control( str_category )
{
	a_ents = getentarray( "e9_post_ms_background_enemy_rusher_spawner", "targetname" );
	if( IsDefined(a_ents) )
	{
		a_enemy_spawners = array_randomize( a_ents ); 
	
		for( i=0; i<a_enemy_spawners.size; i++ )
		{
			e_ai = simple_spawn_single( a_enemy_spawners[ i ] );
			if( IsDefined(e_ai) )
			{
				//IPrintLnBold( "ENMEY RUSHER" );
				e_ai thread aggressive_runner( str_category );
			}
			
			delay = randomfloatrange( 0.1, 0.4 );
			wait( delay );
		}
	}
}


//
//	Keep fighting until you need to move to a fallback position
fighting_withdrawl()
{
	self endon( "death" );

	// Only perform this if you are assigned a goalvolume via script_string.
	// The script_string is used instead of script_goalvolume because set_goal_volume
	//	is giving me some undesired behavior because I'm chaining the goalvolumes using .target
	if ( !IsDefined( self.script_string ) )
	{
		return;
	}

	// If I was given an initial destination, then wait until I reach it.
	self waittill( "goal" );	

	// Make them more aggressive and smart
	self.fixedNode = false;
	self.canFlank = true;

	e_goalvolume = level.goalVolumes[ self.script_string ];
	while ( IsDefined( e_goalvolume ) )
	{
		// Work within your assigned volume
		self SetGoalVolumeAuto( e_goalvolume );

		self waittill( "goal" );
		
		// Wait until it's time to fallback
		flag_wait( e_goalvolume.script_goalvolume + "_fallback" );

		wait( RandomFloat( 2.0 ) );
		
		// Set new goal
		if ( IsDefined( e_goalvolume.target ) )
		{
			// If there's more than one targeted, then just pick one at random
			a_e_goalvolume = GetEntArray( e_goalvolume.target, "targetname" );
			if ( a_e_goalvolume.size > 1 )
			{
				e_goalvolume = random( a_e_goalvolume );
				a_e_goalvolume = undefined;
			}
			else
			{
				break;
			}
		}
		else
		{
			break;
		}
	}

}


//
//
setup_fallback_monitors()
{
	level thread fallback_monitor( "vol_sundeck_mall", 5 );
	
	// North path
	level thread fallback_monitor( "vol_sundeck_west_1f", 5, "vol_south_cliff_west" );
	level thread fallback_monitor( "vol_sundeck_west_2f", 2 );

	// Middle path
	level thread fallback_monitor( "vol_north_cliff_west_1f", 5 );
	level thread fallback_monitor( "vol_north_cliff_west_2f", 4, "vol_cliffs_east" );
	
	// South path
	level thread fallback_monitor( "vol_south_cliff_west", 7, "vol_sundeck_west_1f", "vol_sundeck_west_2f" );
	level thread fallback_monitor( "vol_cliffs_east", 2, "vol_north_cliff_west_1f",  "vol_north_cliff_west_2f" );

	// Northeast arm
//	level thread fallback_monitor( "vol_rock_garden",	7 );
//	level thread fallback_monitor( "vol_pond_left",		3 );
//	level thread fallback_monitor( "vol_pond_right",	3 );
//	level thread fallback_monitor( "vol_wedge_garden",	5 );
//	level thread fallback_monitor( "vol_end_stairs",	5 );
}

//
//	Monitor aigroup killed counts and set a withdrawl flag when the count is met
//		str_aigroup - the aigroup to monitor
//		n_kill_limit - the kill limit to reach before falling back
//		str_fallback_partner - this group should advance as well to help keep parallel movement
fallback_monitor( str_aigroup, n_kill_limit, str_fallback_extra1, str_fallback_extra2 )
{
	str_fallback = str_aigroup + "_fallback";
	level endon( str_fallback );
	
	flag_init( str_fallback );
	
	waittill_ai_group_amount_killed( str_aigroup, n_kill_limit );
	
	flag_set( str_fallback );
	
	// Advance addiitional areas
	if ( IsDefined( str_fallback_extra1 ) )
	{
		flag_set( str_fallback_extra1 + "_fallback" );
	}
	if ( IsDefined( str_fallback_extra2 ) )
	{
		flag_set( str_fallback_extra2 + "_fallback" );
	}
}