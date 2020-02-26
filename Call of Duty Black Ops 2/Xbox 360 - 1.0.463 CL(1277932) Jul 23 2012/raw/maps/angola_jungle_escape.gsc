
#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;
#include maps\_drones;
#include maps\_music;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//****************
// USEFUL AI STUFF
//****************

//
// e_ai.fixednode = true;			// forces a guy to stay on a node
// node exposed						// Makes an ai fire aggressively
// script_forcerambo 1				// NODE: Puts AI into aggressive Rambo behaviour
// pacafist							// if true - the ai will not fire
// g_friendlyfiredist				// should control distance firendlies fire at
// ignoreme and ingoreall			// misc ai ignore params
// self.favoriteenemy
// self.attackeraccuracy
// 
// self.pathEnemyFightDist = 512;	// Keeps an AI within a radius of the goal entity, default goalent is the target node
// self.setgoalentity( e_ent )
//
// self.a.disableReacquire = true;	// Keeps the AI away from the player a bit
//
// self.canFlank = true;			// The AI will attempt to move to flanking positions around the player
// self.aggressiveMode= true;       // Makes them approach the players position, makes heros look bad though
//
// self change_movemode( "run" );	// Control the movement motion animation
//
// self.dontmelee = true;
//
// self thread force_goal( nd_4, 64, true );
//
// self.allowdeath = false;
// self SetCanDamage( false );
//
// self.moveplaybackrate = 1.0		// Animatin playback speed
//


//*****************************************************************************
//*****************************************************************************

skipto_jungle_escape()
{
	skipto_teleport_players( "player_skipto_jungle_escape" );

	level.ai_woods = init_hero( "woods" );
	level.ai_hudson = init_hero( "hudson" );

	level.player_beartrap_toolshed_pickup = true;

	// sb43 - todo fix this hack
	je_setup_player_weapons();

	exploder( 200 );
	level notify( "fxanim_vines_start" );
}


//*****************************************************************************
//*****************************************************************************

init_flags()
{
	flag_init( "je_mason_meets_woods_at_village_exit" );

	flag_init( "je_mason_drops_down_from_village" );

	flag_init( "je_hudson_heads_to_battle_1" );
	flag_init( "je_hudson_in_position_for_battle_1" );
	flag_init( "je_battle_1_wave3_started" );
	flag_init( "je_force_squad_to_move_to_battle_2" );

	flag_init( "je_hudson_heads_to_battle_2" );
	flag_init( "je_hudson_in_position_for_battle_2" );
	flag_init( "je_battle_2_wave1_started" );
	flag_init( "je_battle_2_wave2_started" );
	flag_init( "je_force_squad_to_move_to_battle_3" );

	flag_init( "je_hudson_heads_to_battle_3" );
	flag_init( "je_hudson_in_position_for_battle_3" );
	flag_init( "je_battle_3_wave2_started" );

	flag_init( "je_hudson_heads_to_beach" );

	flag_init( "je_woods_takes_damage" );

	flag_init( "jungle_escape_defend_complete" );
}


//*****************************************************************************
//*****************************************************************************

angola_init_rusher_distances()
{
	level.player_rusher_jumper_dist = (42*6);			// 42*6
	level.player_rusher_vclose_dist = (42*7);			// 42*7
	level.player_rusher_fight_dist = (42*12);			// 42*12
	level.player_rusher_medium_dist = (42*15);			// 42*15
	level.player_rusher_player_busy_dist = (42*22);		// 42*22
}


//*****************************************************************************
//*****************************************************************************

main()
{
	// Lets try for the demo
	level.jungle_escape_accuracy = 0.3;

	// CHEATS
	level.je_skip_battle1 = false;
	level.je_skip_battle2 = false;
	level.je_skip_battle3 = false;
	level.disable_nags = false;

	// Challenges Initialization
	level.num_snipertree_kills = 0;
	level.num_snipertree_challenge_kills = 8;

	tree_sniper_initialization();

	level.player thread maps\createart\angola_art::jungle_escape();

	level thread jungle_escape_begins_vo( 1 );

	level.player swap_to_primary_weapon( "m16_sp" );

	level thread sniper_tree_vo();

	init_flags();

	// Stop Mason exiting the village the wrong way
	level thread activate_the_wrong_exit_from_village_trigger();

	// Objectives
	level thread angola_jungle_objectives();

	// Triggers used to Spawn in the AI in Waves
	level thread angola_jungle_wave_spawning();
	
	// Scene animation Triggers and Events
	level thread angola_jungle_animations();
	
	//Shawn J - Sound
	SetDvar( "footstep_sounds_cutoff", 3000 );

	// Mission fails if Woods takes too much damage
	level thread woods_damage_fail_condition();

	flag_wait( "jungle_escape_defend_complete" );
}


//*****************************************************************************
//*****************************************************************************

jungle_escape_begins_vo( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	level.player say_dialog( "maso_hudson_we_re_movin_0" );

	wait( 0.5 );

	level.ai_hudson say_dialog( "huds_did_you_secure_evac_0" );
	level.player say_dialog( "maso_i_m_not_sure_0" );

	wait( 2 );
	level.ai_hudson say_dialog( "huds_dammit_mason_behi_0" );
	level.ai_hudson say_dialog( "huds_we_got_cuban_regular_0" );
	level.ai_hudson say_dialog( "huds_looks_like_half_a_da_0" );

	wait( 4 );
	level.ai_hudson say_dialog( "huds_keep_us_covered_0" );

	flag_wait( "je_hudson_in_position_for_battle_1" );
	level.ai_hudson say_dialog( "huds_too_many_we_gotta_h_0" );
}


//*****************************************************************************
//*****************************************************************************

je_setup_player_weapons()
{
	// TODO - How do we actually make sure the player has a sniper weapon
	
	level.player takeAllWeapons();
	level.player GiveWeapon( "m16_sp" );
	level.player GiveWeapon( "machete_sp", 0 );
	level.player GiveWeapon( "dragunov_sp" );

	level.player GiveWeapon( "frag_grenade_sp" );
	level.player SetWeaponAmmoClip( "frag_grenade_sp", 5 );
	
//	for( i=0; i<3; i++ )
//	{
//		level.player GiveWeapon( "mortar_shell_sp" );
//	}

	//level.player TakeWeapon( "m1911_sp" );
	level.player SwitchToWeapon( "m16_sp" );

	if( IsDefined(level.player_beartrap_toolshed_pickup) )
	{
		maps\angola_2_beartrap::give_player_beartrap();
	}

	//level.player GiveWeapon( "mortar_shell_sp" );
	//level.player setactionslot( 2, "weapon", "mortar_shell_sp" );
}


//*****************************************************************************
//*****************************************************************************

activate_the_wrong_exit_from_village_trigger()
{
	a_volumes = getentarray( "exit_village_wrong_way_info_volume", "targetname" );

	while( 1 )
	{
		for( i=0; i<a_volumes.size; i++ )
		{
			if( level.player IsTouching(a_volumes[i]) )
			{
				missionFailedWrapper( &"ANGOLA_2_EXIT_VILLAGE_CANT_FIND_HUDSON" );
				return;
			}
		}
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

angola_jungle_objectives()
{
	wait( 0.25 );


	//***************************************************
	// OBJECTIVE: Exit village and Enter Forest Objective 
	//***************************************************

	t_exit_village = getent( "objective_mason_exit_villiage_into_forest_trigger", "targetname" );
	str_struct_name = t_exit_village.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_EXIT_VILLAGE_ENTER_FOREST, s_struct, "" );

	t_exit_village waittill( "trigger" );
	set_objective( level.OBJ_MASON_EXIT_VILLAGE_ENTER_FOREST, undefined, "delete" );

	flag_set( "je_mason_meets_woods_at_village_exit" );

	
	//****************************************
	// Wait to put a Follow Objetive on Hudson
	//****************************************

	while( 1 )
	{
		if( flag("je_hudson_heads_to_battle_1") )
		{
			break;
		}
		wait( 0.01 );
	}

	wait( 1 );

	set_objective( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, level.ai_hudson, "follow" );


	//**********************************************************************
	// When Hudson and Woods reach the 1st rest spot, get ready for a battle
	//**********************************************************************

	while( 1 )
	{
		if( flag( "je_hudson_in_position_for_battle_1" ) )
		{
			break;
		}
		wait( 0.01 );
	}

	objective_state( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, "invisible" );
	
	wait( 0.5 );
	
	set_objective( level.OBJ_BATTLE_FOREST_1, level.ai_woods.origin, "defend" );


	//************************************************************************
	// Wait for the 1st battle to finish
	// before triggering the next obejctive
	//************************************************************************

	wait_for_1st_battle_to_complete();
	
	set_objective( level.OBJ_BATTLE_FOREST_1, undefined, "delete" );


	//************************************************************************
	// Once the 1st battle is over, advance to battle 2
	//************************************************************************

	flag_wait( "je_hudson_heads_to_battle_2" );

	level.ai_hudson thread say_dialog( "huds_i_got_him_let_s_go_0" );

	wait( 0.5 );

	objective_state( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, "active" );

	//iprintlnbold( "Mason, Were moving ahead NOW, cover us" );
	//level.player say_dialog( "maso_now_hudson_0" );
		
	autosave_by_name( "move_to_battle_2_start" );

	flag_wait( "je_hudson_in_position_for_battle_2" );

	objective_state( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, "invisible" );

	wait( 0.1 );


	//*************************************************************************
	// Jungle Escape - Defend/Battle 2
	//*************************************************************************

	set_objective( level.OBJ_BATTLE_FOREST_2, level.ai_woods, "defend" );

	autosave_by_name( "je_battle_2_starting" );


	//************************************************************************
	// Wait for the 2nd battle to finish
	// before triggering the next obejctive
	//************************************************************************

	wait_for_2nd_battle_to_complete();

	set_objective( level.OBJ_BATTLE_FOREST_2, undefined, "delete" );
	
	
	//************************************************************************
	// Once the 2nd battle is over, advance to Battle 3
	//************************************************************************
	
	flag_wait( "je_hudson_heads_to_battle_3" );

	wait( 0.5 );

	objective_state( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, "active" );

	/*
	IPrintLnBold( "HUDSON AND WOODS MOVE - PART 3" );
	*/

	autosave_by_name( "move_to_battle_3_start" );

	wait( 1 );
	
	flag_wait( "je_hudson_in_position_for_battle_3" );
		
	set_objective( level.OBJ_PROTECT_HUDSON_AND_WOODS_ON_WAY_TO_BEACH, undefined, "delete" );

	wait( 0.5 );
	

	//*************************************************************************
	// Jungle Escape - Defend/Battle 3
	//*************************************************************************

	autosave_by_name( "je_battle_3_starting" );

	set_objective( level.OBJ_BATTLE_FOREST_3, level.ai_woods, "defend" );


	//************************************************************************
	// Wait for the 3rd battle to finish
	// before triggering the next obejctive
	//************************************************************************

	wait_for_3rd_battle_to_complete();

	set_objective( level.OBJ_BATTLE_FOREST_3, undefined, "delete" );
	
	wait( 0.1 );

	flag_set( "jungle_escape_defend_complete" );
}


//*******************************************************************************
// Check for conditions that make Hudson and Woods move from defend 1 to defend 2
//*******************************************************************************

wait_for_1st_battle_to_complete()
{
	if( level.je_skip_battle1 == false )
	{
		flag_wait( "je_battle_1_wave3_started" );

		if( level.disable_nags == false )
		{
			level thread je_1st_battle_advance_nag_lines();
		}

		wait( 1 );

		while( 1 )
		{
			// Either wait for the trigger or all AXIS to be killed
			if( GetAIArray("axis").size <= 2 )	// 1
			{
				//IPrintLnBold( "1 Enemy Left" );
				break;
			}
		
			if( flag("je_hudson_heads_to_battle_2") )
			{
				//IPrintLnBold( "Hudson and Woods want to move" );
				break;
			}

			if( flag("je_force_squad_to_move_to_battle_2") )
			{
				//IPrintLnBold( "Force Flag" );
				break;
			}
		
			wait( 0.01 );
		}
	}

	level.ai_hudson notify( "hudson_move_with_woods" );

	flag_set( "je_hudson_heads_to_battle_2" );
	make_all_enemy_aggressive( true );
}


//*****************************************************************************
// Check for conditions that make Hudson and Woods move from defend 2 to defend 3
//*****************************************************************************

wait_for_2nd_battle_to_complete()
{
	if( level.je_skip_battle2 == false )
	{
		flag_wait( "je_battle_2_wave1_started" );

		flag_wait( "je_battle_2_wave2_started" );

/*
		if( flag( "je_force_squad_to_move_to_battle_3" ) )
		{
			wait( 2 );
		}
		else
		{
			wait( 10 );
		}
*/

		wait( 5 );		// 20

		//iprintlnbold( "STARTING DEFEND2 TIME" );

		start_time = gettime();
		while( 1 )
		{
			// Don't let the battlehere last too long
			time = gettime();
			dt = ( time - start_time ) / 1000;
			if( dt > 15 )
			{
				//iprintlnbold( "STARTING DEFEND2 TIME ABORT" );
				break;
			}

			// Either wait for the trigger or all AXIS to be killed
			if( GetAIArray("axis").size <= 2 )	// 1
			{
				break;
			}
			wait( 0.01 );
		}

		//iprintlnbold( "MASON: We need to head to the beach, cover us" );
		level.ai_hudson thread say_dialog( "huds_come_on_we_re_movin_0", 2 );
		level.ai_hudson thread say_dialog( "huds_i_got_you_brother_0", 7 );
		level.ai_hudson thread say_dialog( "huds_come_on_woods_we_0", 15 );

		if( level.disable_nags == false )
		{
			level thread mason_protect_nag_think( level.ai_hudson, 1000, 2, 8, 15, 
													"Mason, get back to Hudson and Woods, stay together", 
													"Mason, you must Woods now", 
													&"ANGOLA_2_MISSION_FAILED_LOST_CONTACT_WITH_HUDSON" );
		}


		wait( 3 );
	}

	level.ai_hudson notify( "hudson_move_with_woods" );

	flag_set( "je_hudson_heads_to_battle_3" );
	make_all_enemy_aggressive( true );
}


//*****************************************************************************
//*****************************************************************************

wait_for_3rd_battle_to_complete()
{
	if( level.je_skip_battle3 == false )
	{
		flag_wait( "je_battle_3_wave2_started" );
	
		// Let some guys spawn in
		wait( 21 );							// 25

		start_time = gettime();

		while( 1 )
		{
			// Don't let the battlehere last too long
			time = gettime();
			dt = ( time - start_time ) / 1000;
			if( dt > 15 )
			{
				//iprintlnbold( "STARTING DEFEND3 TIME ABORT" );
				break;
			}
			
			// Either wait for the trigger or all AXIS to be killed
			if( GetAIArray("axis").size <= 3 )	// 1
			{
				break;
			}
			wait( 0.01 );
		}

		//iprintlnbold( "MASON: We Need to Meet the Evac at the Beach" );

		flag_set( "je_hudson_heads_to_beach" );
		level.ai_hudson notify( "hudson_move_with_woods" );

		wait( 1 );
	}

	level.ai_hudson notify( "hudson_move_with_woods" );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

angola_jungle_wave_spawning()
{
	angola_init_rusher_distances();

	//**********************************************************
	// Setup the Mason nag to keep him close to Hudson and Woods
	// 1500, 4, 15, 25
	//**********************************************************

	if( level.disable_nags == false )
	{
		level thread mason_protect_nag_think( level.ai_hudson, 1500, 4, 15, 25, 
												"Mason, get back to Hudson and Woods, stay together", 
												"Mason, final warning you must protect Hudson amd Woods", 
												&"ANGOLA_2_MISSION_FAILED_LOST_CONTACT_WITH_HUDSON" );
	}


	//***************
	// Defend Event 1
	//***************
	
	str_category = "jungle_battle_1";

	if( level.je_skip_battle1 == false )
	{
		level thread je_battle1_enemy_cheerleader();
		level thread je_battle1_jungle_chasers( str_category );
		level thread je_battle1_start_trigger( str_category );
	}


	//***************
	// Defend Event 2
	//***************

	str_category = "jungle_battle_2";

	if( level.je_skip_battle2 == false )
	{
		level thread je_battle2_chasers( str_category );
		level thread je_battle2_stealth_patrol_setup( str_category );
		//level thread je_battle2_dog_attack_trigger();
		level thread je_battle2_wave1_trigger( str_category );
		level thread je_battle2_wave2_trigger( str_category );
	}


	//***************
	// Defend Event 3
	//***************

	str_category = "jungle_battle_3";

	if( level.je_skip_battle3 == false )
	{
		level thread je_battle3_chasers( str_category );
		//level thread je_goto_defend3_dog_attack_trigger();
		level thread je_battle3_wave1_trigger( str_category );
		level thread je_battle3_wave2_trigger( str_category );
		level thread je_battle3_wave3_trigger( str_category );
		level thread je_battle3_wave4_trigger( str_category );
		level thread je_battle3_wave_drones_trigger( str_category );
		level thread je_battle3_mortar_attack();
	}
}


//*****************************************************************************
//*****************************************************************************

je_battle1_enemy_cheerleader()
{
	flag_wait( "je_mason_drops_down_from_village" );
	wait( 6 );
	
	//IPrintLnBold( "Playering ALerted Guy" );

	str_scene_name = "je_defend1_enemy_alerted";

	level thread run_scene( str_scene_name );
	wait( 0.1 );
	e_ai = getent( "guy_soldier_ai", "targetname" );
	e_ai.ignoreall = true;
	v_start_pos = e_ai.origin;

	e_ai entity_common_spawn_setup( undefined, undefined, undefined, undefined );

	scene_wait( str_scene_name );

	nd_node = getnode( "defend1_chearleader_kill_node", "targetname" );
	e_ai.goalradius = 48;
	e_ai setgoalnode( nd_node );
	e_ai waittill( "goal" );

	e_ai delete();
}


//*****************************************************************************
//*****************************************************************************

je_battle1_jungle_chasers( str_category )
{
	wait( 2.5 );	// 3

	//IPrintLnBold( "Village Chasers WAVE 1" );

	// Regular - 3 guys
	a_spawners = getentarray( "je_village_chasers_wave1_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, true, false, false );
	}

	level thread push_chasers_forward_as_defend1_develops();

	
	//*****************************************
	// Always spawn in another more deadly wave
	//*****************************************

	start_time = gettime();

	wave2_wait_time = 7;	// 9

	while( 1 )
	{
		time = gettime();

		// No more need for village chasers
		//if( flag("je_mason_drops_down_from_village") )
		//{
		//	break;
		//}

		dt = (time - start_time) /1000;
		if( dt > wave2_wait_time )
		{
			//num_axis = GetAIArray("axis").size;
			//if( num_axis <=1 )
			{
				// Regular - 4 guys
				a_spawners = getentarray( "je_village_chasers_wave2_regular_spawner", "targetname" );
				if( IsDefined(a_spawners) ) 
				{
					simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, true, false, false );
				}
				return;
			}
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************

push_chasers_forward_as_defend1_develops()
{
	// Wait for the player to drop down and enter the main area of defend area 1
	flag_wait( "je_mason_drops_down_from_village" );

	wait( 12 );		// 20

	e_volume = getent( "village_exit_volume", "targetname" );
	a_enemies = GetAISpeciesArray( "axis", "all" );
	a_ai_targets = [];

	// Get all the AI within the info volume
	for( i=0; i<a_enemies.size; i++ )
	{
		e_ai = a_enemies[i];
		if( e_ai IsTouching(e_volume) )
		{
			a_ai_targets[ a_ai_targets.size ] = e_ai;
		}
	}

	// Force all the AI within the info volume to ove forwards towards the player
	for( i=0; i<a_ai_targets.size; i++ )
	{
		e_ai = a_ai_targets[i];

		e_ai.pathEnemyFightDist = 892;
		e_ai setgoalentity( level.player );
	}

	//IPrintLnBold( "Enemy inside Volume " + a_enemies.size + " " + a_ai_targets.size );
}


//*****************************************************************************
// Spawns the initial patrol guys in the first defend area
//*****************************************************************************

je_battle1_start_trigger( str_category )
{
	// Wait for one of the triggers that start off the initial patrol
	str_notify = "je_battle1_start_notify";
	multiple_trigger_waits( "player_escaping_village_trigger", str_notify );
	level waittill( str_notify );

	flag_set( "je_mason_drops_down_from_village" );

	//flag_wait( "je_hudson_heads_to_battle_1" );

	autosave_by_name( "player_enters_1st_defend_area" );

	wait( 4 );	// 4

	a_spawners = getentarray( "je_battle1_start_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
	
	wait( 3 );

	level thread je_battle1_wave2_trigger( str_category );
}


//*****************************************************************************
//*****************************************************************************

je_battle1_wave2_trigger( str_category )
{
	//IPrintLnBold( "BATTLE 1 - Wave 2" );
	
/*
	// Regular - 1 guys
	// Loose guy to quicken up battle
	a_spawners = getentarray( "je_battle1_wave2_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
*/

/*
	// Holders - 1 guy
	a_holders = getentarray( "je_battle1_wave2_holder_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, 10, false, false );
	}
*/
		

	//****************************************************
	// Bring in the 2nd attack wave after a few conditions
	// - 2 or less AXIS alive
	// - min wait time
	// - max wait time
	//****************************************************

	min_wait_time = 6;		// 8
	max_wait_time = 15;		// 25
	min_axis_left = 3;		// 2
	
	battle1_start_time = gettime();

	wait( min_wait_time );

	while( 1 )
	{
		// Start after MAX wait time
		time = gettime();
		dt = ( time - battle1_start_time ) / 1000;
		if( dt >= max_wait_time )
		{
			break;
		}

		// Start after min AXIS left
		num_axis = GetAIArray("axis").size;
		if( num_axis <= min_axis_left )
		{
			break;
		}

		wait( 0.01 );
	}


	//**************************************
	// Start the 2nd attack wave at Battle 1
	//**************************************

	level thread je_battle1_wave3_trigger( str_category );

	wait( 0.1 );

	flag_set( "je_battle_1_wave3_started" );
}


//*****************************************************************************
//*****************************************************************************

je_battle1_wave3_trigger( str_category )
{
	//IPrintLnBold( "BATTLE 1 - Wave 3" );

	autosave_by_name( "battle_1_wave_3" );
	
	// Regular - 1 guy
	a_spawners = getentarray( "je_battle1_wave3_regular_launcher_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}

	// Holders - 1 guy
	// Remove guy to simplify batttle
/*
	a_holders = getentarray( "je_battle1_wave3_holder_spawner", "targetname" );
	if( IsDefined(a_holders) ) 
	{
		simple_spawn_script_delay( a_holders, ::spawn_fn_ai_run_to_holding_node, true, str_category, 5, false, false );
	}
*/

	// Bring the AI closer to the player, need to adjust if the player climbs a tree
	level thread defend1_set_ai_pathing_distances( 2 );
}


//*****************************************************************************
//*****************************************************************************

defend1_set_ai_pathing_distances( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	enemy_left_4 = 0;
	enemy_left_2 = 0;
	enemy_left_1 = 0;

	path_distance = 2048;

	while( 1 )
	{
		ai = GetAIArray( "axis" );

		if( (enemy_left_4 == 0) && (ai.size<=4) )
		{
			//IPrintLnBold( "ENEMY RADIUS 4" );
			path_distance = 1500;		// 1500
			ai_set_enemy_fight_distance( level.player, path_distance, true );
			enemy_left_4 = 1;
		}

		if( (enemy_left_2 == 0) && (ai.size<=2) )
		{
			//IPrintLnBold( "ENEMY RADIUS 2" );
			path_distance = 1250;		// 750
			ai_set_enemy_fight_distance( level.player, path_distance, true );
			enemy_left_2 = 1;
		}

		if( (enemy_left_1 == 0) && (ai.size<=1) )
		{
			//IPrintLnBold( "ENEMY RADIUS 1" );
			path_distance = 1000;		// 300
			ai_set_enemy_fight_distance( level.player, path_distance, true );
			enemy_left_1 = 1;
			return;
		}

		// If the player is up a tree, expand the radius
		if( is_player_climbing_tree() )
		{
			ai_set_enemy_fight_distance( undefined, 2048, true );

			while( 1 )
			{
				if( !is_player_climbing_tree() )
				{
					ai_set_enemy_fight_distance( level.player, path_distance, true );
					break;
				}
				wait( 0.01 );
			}
		}


		// If the second defend battle has started, kill thread
		if( flag("je_hudson_in_position_for_battle_2") )
		{
			ai_set_enemy_fight_distance( undefined, 2048, true );
			return;
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
// Defend 2
//*****************************************************************************
//*****************************************************************************

je_battle2_chasers( str_category )
{
	e_trigger = getent( "defend2_chaser_spawners_trigger", "targetname" );

	e_trigger waittill( "trigger" );

	//iprintlnbold( "Entering Defend2 chasers" );

	// Regular - 2 guys
	a_spawners = getentarray( "je_defend2_chaser_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, true, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

je_battle2_stealth_patrol_setup( str_category )
{
	flag_wait( "je_hudson_in_position_for_battle_2" );

	wait( 1 );		// 6
	//iprintlnbold( "Defend2 Starting" );

	// 3 guys
	level thread maps\angola_stealth::setup_stealth_event( undefined, "je_battle2_patrol_spawner", str_category, false, false );
	level thread maps\angola_stealth::player_stealth_override_spotted_params( 0.3, 0.4 );		// 0.15  0.5
	level thread patrol_set_ground_visibility_distance( 2000 );
}


//*****************************************************************************
//*****************************************************************************

je_battle2_dog_attack_trigger()
{
	flag_wait( "je_hudson_in_position_for_battle_2" );
	
	wait( 0.1 );	// 0.1

	level thread temp_defend2_dogs_text();

	wait( 1 );		// 1
	
	dog_spawner = GetEnt( "je_dog1_start_event2_spawner", "targetname" );
	dog = simple_spawn_single( dog_spawner );
	a_nodes = [];
	a_nodes[ a_nodes.size ] = "je_defend2_dog1_node1";
	a_nodes[ a_nodes.size ] = "je_defend2_dog1_node2";
	a_nodes[ a_nodes.size ] = "je_defend2_dog1_node3";
	a_nodes[ a_nodes.size ] = "je_defend2_dog1_node4";
	dog thread dog_follow_node_array_then_attack_target( level.player, true, a_nodes );
}

temp_defend2_dogs_text()
{
	IPrintLnBold( "There using dogs to track us down, cover us" );
	wait( 2 );
	IPrintLnBold( "MASON: Take up a defensive Position in the area ahead" );
}


//*****************************************************************************
//*****************************************************************************

je_battle2_wave1_trigger( str_category )
{
	flag_wait( "je_hudson_heads_to_battle_2" );

	level thread behind_us_vo_node();
	
	// Wait for stealth to start
	while( 1 )
	{
		if( is_player_in_stealth_mode() )
		{
			break;
		}
		wait( 0.01 );
	}
	
	// Wait for the player to break stealth
	while( 1 )
	{
		if( !is_player_in_stealth_mode() )
		{
			break;
		}
		wait( 0.01 );
	}

	// Give the player some time to kill the dogs and set traps
	min_start_time = 4;
	max_start_time = 8;
	min_enemies = 1;
	str_start_notify = "mike_is_cool_2";
	level thread maps\angola_2_util::wait_time_and_enemies( min_start_time, max_start_time, min_enemies, str_start_notify );
	level waittill( str_start_notify );
	
	//IPrintLnBold( "BATTLE2: Wave 1" );

	level thread battle2_wave1_dialog();

	// Regular - 2 guys
	a_spawners = getentarray( "je_battle2_wave1_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, true, false );
	}

	// Launcher - 1 guy
	a_spawners = getentarray( "je_battle2_wave1_launcher_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, true, true );
	}

	// Rushers - 1 guy
	level thread simple_spawn_rusher_single( "je_battle2_wave1_rusher_spawner", str_category, level.player_rusher_medium_dist );

	flag_set( "je_battle_2_wave1_started" );
}

battle2_wave1_dialog()
{
	wait( 2 );
	level.ai_hudson say_dialog( "huds_come_on_mason_0" );

	wait( 0.5 );
	level.ai_hudson say_dialog( "huds_we_gotta_get_out_of_0" );

	wait( 0.5 );
	level.ai_hudson say_dialog( "huds_you_secured_the_evac_0" );
	level.player say_dialog( "maso_can_it_hudson_0" );
}

je_battle2_wave2_trigger( str_category )
{
	flag_wait( "je_hudson_in_position_for_battle_2" );

	// Give player time to cleanup wave 1
	min_start_time = 15;	// 20
	max_start_time = 40;	// 70
	min_enemies = 2;

	str_start_notify = "mike_is_cool";
	level thread maps\angola_2_util::wait_time_and_enemies( min_start_time, max_start_time, min_enemies, str_start_notify );
	level waittill( str_start_notify );

	flag_set( "je_battle_2_wave2_started" );

	//
	// Don't need wave2 for now, speed up the battle (2/29/12)
	//

	flag_set( "je_force_squad_to_move_to_battle_3" );

	//IPrintLnBold( "BATTLE2: Wave 2" );
	//
	// Regular
	//a_spawners = getentarray( "je_battle2_wave2_regular_spawner", "targetname" );
	//if( IsDefined(a_spawners) ) 
	//{
	//	simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	//}

	// DON"T NEED WAVE 3 - For now anyway
	//level thread je_battle2_wave3_trigger( str_category, 3 );
}

je_battle2_wave3_trigger( str_category, delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}
	
	/*
	IPrintLnBold( "BATTLE2: Wave 3" );
	*/

	// Regular
	a_spawners = getentarray( "je_battle2_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}

	// Rushers
	level thread simple_spawn_rusher_single( "je_battle2_wave3_rusher_spawner", str_category, level.player_rusher_medium_dist );
}


//*****************************************************************************
//*****************************************************************************

behind_us_vo_node()
{
	nd_node = getnode( "behind_us_vo_node", "targetname" );

	v_forward = anglestoforward( nd_node.angles );

	while( 1 )
	{
		v_dir = vectornormalize( level.player.origin - nd_node.origin );

		dot = vectordot( v_forward, v_dir );
		if( dot > 0.3 )
		{
			break;
		}
	
		wait( 0.01 );
	}

	level.ai_hudson say_dialog( "huds_behind_us_0" );
}


//*****************************************************************************
//*****************************************************************************
// Defend 3
//*****************************************************************************
//*****************************************************************************

je_battle3_chasers( str_category )
{
	flag_wait( "je_hudson_heads_to_battle_3" );

	wait( 3 );

	//iprintlnbold( "Defend3 Chasers Active" );
	
	// Regular - 3 guys
	a_spawners = getentarray( "je_defend3_chaser_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, true, false, false );
	}

	level thread battle3_chaser_alerted_animation();
}

//*****************************************************************************
//*****************************************************************************

battle3_chaser_alerted_animation()
{
	//IPrintLnBold( "Playering Alerted Guy" );

	str_scene_name = "je_defend2_enemy_alerted";

	level thread run_scene( str_scene_name );
	wait( 0.1 );
	e_ai = getent( "guy_soldier_ai", "targetname" );

	e_ai entity_common_spawn_setup( undefined, undefined, undefined, undefined );

	scene_wait( str_scene_name );

	nd_node = getnode( "defend3_chaser_target_node", "targetname" );
	e_ai.goalradius = 48;
	e_ai setgoalnode( nd_node );
	e_ai waittill( "goal" );
	e_ai.goalradius = 2048;
}


//*****************************************************************************
//*****************************************************************************

je_goto_defend3_dog_attack_trigger()
{
	e_trigger = getent( "defend3_player_arrives_trigger", "targetname" );
	e_trigger trigger_off();

	// Dog warning text
	flag_wait( "je_hudson_heads_to_battle_3" );

	e_trigger trigger_on();
	e_trigger waittill( "trigger" );

	wait( 6 );		// 12
	level thread temp_defend3_dogs_text();

	// wiatif or Hudson and Woods to get to the battle 3 cover position
	flag_wait( "je_hudson_in_position_for_battle_3" );

	// Send in the first dog						   

	wait( 0 );

	//IPrintLnBold( "First Dog" );

	dog_spawner = GetEnt( "je_dog1_event3_spawner", "targetname" );	
	dog = simple_spawn_single( dog_spawner );
	a_nodes = [];
	a_nodes[ a_nodes.size ] = "je_defend3_dog1_node1";
	a_nodes[ a_nodes.size ] = "je_defend3_dog1_node2";
	a_nodes[ a_nodes.size ] = "je_defend3_dog1_node3";
	a_nodes[ a_nodes.size ] = "je_defend3_dog1_node4";
	dog thread dog_follow_node_array_then_attack_target( level.player, true, a_nodes );

	wait( 2 );		// 3


// Removing one of the dogs, lets see if anyone notices
/*
	// Send in the 2nd dog
	dog_spawner = GetEnt( "je_dog2_event3_spawner", "targetname" );	
	dog = simple_spawn_single( dog_spawner );
	a_nodes = [];
	a_nodes[ a_nodes.size ] = "je_defend3_dog2_node1";
	a_nodes[ a_nodes.size ] = "je_defend3_dog2_node2";
	a_nodes[ a_nodes.size ] = "je_defend3_dog2_node3";
	a_nodes[ a_nodes.size ] = "je_defend3_dog2_node4";
	dog thread dog_follow_node_array_then_attack_target( level.player, true, a_nodes );
*/

}

temp_defend3_dogs_text()
{
	IPrintLnBold( "MASON: The dogs are back on our trail, cover us" );
}


//*****************************************************************************
//*****************************************************************************

je_battle3_wave1_trigger( str_category )
{
	flag_wait( "je_hudson_in_position_for_battle_3" );

	wait( 6 );		// 9

	level.ai_hudson thread say_dialog( "huds_they_re_all_over_w_0", 3 );
	level.ai_hudson thread say_dialog( "huds_where_the_hell_is_th_0", 7 );

	/*
	IPrintLnBold( "Battle 3 Wave 1" );
	*/

	autosave_by_name( "battle_3_wave_1" );
		
	// Holders - 1 guy
	a_spawners = getentarray( "je_battle3_wave1_launcher_holder_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_holding_node, true, str_category, 666, false, true );
	}

	// Regular - 3 guys
	a_spawners = getentarray( "je_battle3_wave1_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

je_battle3_wave2_trigger( str_category )
{
	flag_wait( "je_hudson_in_position_for_battle_3" );

	// Give player time to cleanup wave 1
	min_start_time = 15;	// 25
	max_start_time = 25;	// 35
	min_enemies = 3;		// 2

	str_start_notify = "mike_is_cool_3_2";
	level thread maps\angola_2_util::wait_time_and_enemies( min_start_time, max_start_time, min_enemies, str_start_notify );
	level waittill( str_start_notify );

	/*
	IPrintLnBold( "Battle 3: Wave 2" );
	*/

	autosave_by_name( "battle_3_wave_2" );

	flag_set( "je_battle_3_wave2_started" );

	// Regular - 4 guys
	a_spawners = getentarray( "je_battle3_wave2_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
}


//*****************************************************************************
// End of battle chasers to the beach
//*****************************************************************************

je_battle3_wave3_trigger( str_category )
{
	flag_wait( "je_hudson_heads_to_beach" );

	level.ai_hudson thread say_dialog( "huds_fall_back_fall_back_0", 2);
	
	/*
	IPrintLnBold( "Battle 3: Wave 3" );
	*/

	autosave_by_name( "battle_3_wave_3" );

	// Regular - 4 guys
	a_spawners = getentarray( "je_battle3_wave3_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

je_battle3_wave4_trigger( str_category )
{
	flag_wait( "je_hudson_heads_to_beach" );

	wait( 12 );

	//IPrintLnBold( "Battle 3: Wave 4" );

	// Regular - 4 guys
	a_spawners = getentarray( "je_battle3_wave4_regular_spawner", "targetname" );
	if( IsDefined(a_spawners) ) 
	{
		simple_spawn_script_delay( a_spawners, ::spawn_fn_ai_run_to_target, true, str_category, false, false, false );
	}
}


//*****************************************************************************
//*****************************************************************************

je_battle3_wave_drones_trigger( str_category )
{
	flag_wait( "je_hudson_heads_to_beach" );

	wait( 8 );

	//*********************
	// Send out some drones
	//*********************

	//IPrintLnBold( "Battle 3: End Scene Drones" );

	sp_drone = getent( "je_drone1_spawner", "targetname" );
	drones_assign_spawner( "drone1_end_level_trigger", sp_drone );
	drones_speed_modifier( "drone1_end_level_trigger", -0.3, -0.1 );
	drones_start( "drone1_end_level_trigger" );
	wait( 25 );
	drones_delete( "drone1_end_level_trigger" );
}


//*****************************************************************************
//*****************************************************************************

je_battle3_mortar_attack()
{
	level thread rock_attack_mortar();

	flag_wait( "je_battle_3_wave2_started" );

	wait( 10 );								// 15

	v_start = ( -23583, -1116, 372 );
	speed_scale = 0.18;						// 0.2
	height_scale = 0.75;					// 0.75


	//***************************
	// Missile 1 - A warning shot
	//***************************

	//v_end = ( -26190, 1548, 85 );
	v_end = ( -26200, 971, 85 );

	level thread fire_angola_mortar( v_start, v_end, speed_scale, height_scale, 1.0 );

	level waittill( "angola_mortar_impact" );
	wait( 0.5 );


	//*************************
	// Missile - Warning shot 2
	//*************************

	wait( 3 );

	v_end = ( -26328, 922, 85 );
	level thread fire_angola_mortar( v_start, v_end, speed_scale, height_scale, 1.0 );

	
	//***************************************************************************
	// Fire Missiles at the players location until the gets the prompt to move on
	//***************************************************************************

	while( 1 )
	{
		delay = randomfloatrange( 6, 10 );		// 7, 11
	
		wait( delay );

		if( IsDefined(level.hudson_at_beach_evauation_point) && (level.hudson_at_beach_evauation_point==true) )
		{
			break;
		}

		v_end = level.player.origin;
		v_dir = VectorNormalize( v_start - v_end );
		r_dist = randomfloatrange( (42*6), (42*22) );
		v_end = v_end + ( v_dir * r_dist );

		level thread fire_angola_mortar( v_start, v_end, speed_scale, height_scale, 42*2 );
	}
}

rock_attack_mortar()
{
	flag_wait( "je_hudson_in_position_for_battle_3" );

	//IPrintLnBold( "ABOUT to blow up Rocks" );

	wait( 5 );

	v_start = ( -23583, -1116, 372 );
	speed_scale = 0.18;						// 0.2
	height_scale = 0.75;					// 0.75
	v_end = ( -25701, 1515, 160 );
	level thread fire_angola_mortar( v_start, v_end, speed_scale, height_scale, 1.0 );

	level waittill( "angola_mortar_impact" );

	level.ai_hudson thread say_dialog( "huds_incoming_mortars_0", 0.1 );

	wait( 0.3 );

	level notify( "fxanim_mortar_rocks_start" );

	wait( 2 );

	//iprintlnbold( "Mason there shelling us, we can't hold this position much longer" );
}


//*****************************************************************************
//*****************************************************************************
// *** ANIMATIONS ***
//*****************************************************************************
//*****************************************************************************

angola_jungle_animations()
{
	level thread mason_woods_goto_jungle_fight1_anim();

	level thread mason_woods_goto_jungle_fight2_anim();

	level thread mason_woods_goto_jungle_fight3_anim();
}


//*****************************************************************************
//*****************************************************************************

mason_woods_goto_jungle_fight1_anim()
{
	// Looping Anim - Waiting to meetup with Mason to start event
	level thread run_scene( "hudson_woods_jungle_escape_begin_loop" );

	// Wait for meetup
	while( 1 )
	{
		if ( flag("je_mason_meets_woods_at_village_exit") )
		{
			break;
		}
		wait( 0.1 );
	}

	level.ai_woods.ignoreme = true;
	
	// Start the long Scene of hudson and Woods talking to Mason, then heading to defend area 1
	str_scene_name = "mason_meets_hudson_and_woods_at_start";
	level thread run_scene(str_scene_name );
	wait( 0.1 );
	flag_set( "je_hudson_heads_to_battle_1" );
	
	//iprintlnbold( "Mason, we gotta get to the beach for our evacuation" );

	level.ai_hudson.ignoreme = true;
	level.ai_woods.ignoreme = true;

	// Wait for Hudson and Woods to get to Defend Point 1
	scene_wait( str_scene_name );

	// Looping anim - Woods loops in hurt idle, Hudson joins the fight with Mason
	flag_set( "je_hudson_in_position_for_battle_1" );
	level thread run_scene( "hudson_woods_jungle_escape_stop_01_loop" );

	// Make hudson fight
	level.ai_hudson.ignoreall = true;
	level.ai_hudson.ignoreme = true;

	a_nodes = [];
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend1_node1", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend1_node2", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend1_node3", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend1_node4", "targetname" );
	level.ai_hudson thread hudson_join_battle( a_nodes, 10, 18 );
}

//*****************************************************************************
//*****************************************************************************

mason_woods_goto_jungle_fight2_anim()
{
	flag_wait( "je_hudson_heads_to_battle_2" );

	delete_scene( "hudson_woods_jungle_escape_stop_01_loop" );

	// Animation Take Woods and Hudson to Battle 2
	level.ai_woods.ignoreme = true;
	run_scene( "hudson_and_woods_jungle_escape_move_defend_2" );

	flag_set( "je_hudson_in_position_for_battle_2" );

	level thread run_scene( "hudson_woods_jungle_escape_stop_02_loop" );

	a_nodes = [];
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend2_node1", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend2_node2", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend2_node3", "targetname" );
	level.ai_hudson thread hudson_join_battle( a_nodes, 20, 30 );
}


//*****************************************************************************
//*****************************************************************************

mason_woods_goto_jungle_fight3_anim()
{
	flag_wait( "je_hudson_heads_to_battle_3" );

	delete_scene( "hudson_woods_jungle_escape_stop_02_loop" );

	// Animation Take Woods and Hudson to Battle 3
	level.ai_woods.ignoreme = true;
	run_scene( "hudson_and_woods_jungle_escape_move_defend_3" );

	flag_set( "je_hudson_in_position_for_battle_3" );

	level thread run_scene( "hudson_woods_jungle_escape_stop_03_loop" );

	a_nodes = [];
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend3_node1", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend3_node2", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend3_node3", "targetname" );
	a_nodes[ a_nodes.size ] = getnode( "hudson_defend3_node4", "targetname" );
	level.ai_hudson thread hudson_join_battle( a_nodes, 20, 30 );
}


//*****************************************************************************
//*****************************************************************************

// sb43
// self = Hudson
hudson_join_battle( a_nodes, min_wait, max_wait )
{
	self endon( "death" );
	self endon( "hudson_move_with_woods" );

	nd_node = a_nodes[0];
	self setgoalnode( nd_node );
	self.goalradius = 48;
	
	self.ignoreall = true;
	self.ignoreme = true;

	self.attackeraccuracy = 0.1;

	self waittill( "goal" );

	// We don't want Hudson moving around unless under our control
	self.fixednode = true;

	// Hudson must stay out of the battle until stealth is broken
	while( 1 )
	{
		if( !is_player_in_stealth_mode() )
		{
			break;
		}
		wait( 0.01 );
	}

	// Hudson joins the battle
	self.ignoreme = false;
	self.ignoreall = false;
	self.accuracy = 0.1;

	// If Hudson has a selection of nodes to move between, let him move
	if( a_nodes.size > 1 )
	{
		start_time = gettime();
		node_index = 0;
		while( 1 )
		{
			delay = randomfloatrange( min_wait, max_wait );		// 8, 15
			wait( delay );

			node_index++;
			if(node_index >= a_nodes.size )
			{
				node_index = 0;
			}

			nd_node = a_nodes[node_index];
			self setgoalnode( nd_node );
			self.goalradius = 48;
			self waittill( "goal" );

			self.fixednode = true;
		}
	}
	
	// Stay within a radius of Woods
	//self setgoalentity( level.ai_woods );
	//self.pathEnemyFightDist = (1024+512);
	//self.goalradius = (1024+512);
}


//*****************************************************************************
//*****************************************************************************

je_1st_battle_advance_nag_lines()
{

/*
	nag1_done = 0;
	nag1_time = 8;		// 12
	nag2_done = 0;
	nag2_time = 17;		// 22
	nag3_done = 0;
	nag3_time = 24;		// 32
*/

	nag1_done = 1;
	nag1_time = 1;		// 1
	nag2_done = 0;
	nag2_time = 7;		// 7
	nag3_done = 0;
	nag3_time = 15;		// 16

	start_time = gettime();

	while( 1 )
	{
		if( flag("je_hudson_heads_to_battle_2") )
		{
			return;
		}

		time = gettime();
		dt = ( time - start_time ) / 1000;

		if( !nag1_done )
		{
			if( dt >= nag1_time )
			{
				//iprintlnbold( "Mason, take out the enemy we're moving Woods again soon" );
				level.ai_hudson thread say_dialog( "huds_son_of_a_bitch_0" );
				nag1_done = 1;
			}
		}
		else if( !nag2_done )
		{
			if( dt >= nag2_time )
			{
				//iprintlnbold( "Mason, get ready I have to keep Woods Moving" );
				level.ai_hudson say_dialog( "huds_they_re_still_coming_0" );
				level.player thread say_dialog( "maso_we_gotta_move_0" );
				nag2_done = 1;
			}
		}
		else
		{
			if( dt >= nag3_time )
			{
				// Dialog done by movement
				nag3_done = 1;
				flag_set( "je_force_squad_to_move_to_battle_2" );
				return;
			}
		}

		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
// Tree Sniper Functionality
//*****************************************************************************
//*****************************************************************************

tree_sniper_initialization()
{
	a_tree_sniper_triggers = getentarray( "tree_sniper_trigger", "targetname" );
	if( IsDefined(a_tree_sniper_triggers) && (a_tree_sniper_triggers.size > 0) )
	{
		for( i=0; i<a_tree_sniper_triggers.size; i++ )
		{
			a_tree_sniper_triggers[i] thread sniper_tree_update();
		}
	}
}


//*****************************************************************************
// self = tree "use trigger"
// self.script_int = 1  - This means its a new style tree
//*****************************************************************************

sniper_tree_update()
{
	self setCursorHint( "HINT_NOICON" );
	self SetHintString( "Press [{+activate}] to Climb Tree" );
	
	s_tree_struct = getstruct( self.target, "targetname" );

	e_link_ent = spawn( "script_model", s_tree_struct.origin );
	e_link_ent SetModel( "tag_origin" );
	e_link_ent.angles = s_tree_struct.angles;

	//v_start_player_position = level.player.origin;
	//v_start_player_angles = level.player.angles;
	
	if( IsDefined(self.script_int) && (self.script_int == 1) )
	{
		new_style_tree = 1;
	}
	else
	{
		new_style_tree = 0;
	}

	while( 1 )
	{
		self waittill( "trigger" );
		self trigger_off();
		
		level.player.climbing_tree = true;
				
		enemy_ai_keep_your_distance( true );

		// If the player climbs a tree, stop the AI using grenades
		enemy_ai_disable_grenades( true );

		// If the player climbs a tree, confuse the AI
		if( !is_player_in_stealth_mode() )
		{
			player_climbs_tree_confuses_ai();
		}

		if( new_style_tree )
		{
			add_scene_properties( "player_climb_up_tree_10", s_tree_struct.targetname );
			run_scene( "player_climb_up_tree_10" );
		}
		else
		{
			add_scene_properties( "player_climb_up_tree_60", s_tree_struct.targetname );
			run_scene( "player_climb_up_tree_60" );
		}
		
		up = anglestoup( (0, 90, 0) );
		e_link_ent.origin = level.player.origin + ( up * 42 );
		e_link_ent.angles = level.player.angles;
		level.player PlayerLinkTo( e_link_ent, "tag_origin", 1, 100, 100, 45, 45 );

		if( level.console )
			screen_message_create( "Press [{+stance}] to Climb down Tree" );
		else
			screen_message_create( "Press [{+activate}] to Climb down Tree" );

		message_displayed = 1;
		display_time = 3;
		start_time = gettime();

		ai_push_count = 0;

		while( 1 )
		{
			if( level.player climb_down_button_pressed() )
			{
				break;
			}

			if( message_displayed )
			{
				time = gettime();
				dt = (time - start_time) / 1000;
				if( dt >= display_time )
				{
					screen_message_delete();
					message_displayed = 0;
				}
			}

			// Keep pushing the AI Away from the player when he is up the tree
			ai_push_count++;
			if( ai_push_count >= 10 )
			{
				enemy_ai_keep_your_distance( true );
				ai_push_count = 0;
			}

			// If the player climbs a tree, stop the AI using grenades, keep on enforceing this
			enemy_ai_disable_grenades( true );
			
			wait( 0.01 );
		}

		if( message_displayed )
		{
			screen_message_delete();
		}

		level.player unlink();

		// TEMP: Waiting for animation
		//dir = anglestoforward( level.player.angles );
		//v_pos = level.player.origin - (dir*60);
		//level.player setOrigin( v_pos );

		level.player.ignoreme = true;
			
		if( new_style_tree )
		{
			add_scene_properties( "player_climb_down_tree_10", s_tree_struct.targetname );
			run_scene( "player_climb_down_tree_10" );
		}
		else
		{
			add_scene_properties( "player_climb_down_tree_60", s_tree_struct.targetname );
			run_scene( "player_climb_down_tree_60" );
		}

		level.player.ignoreme = false;

		enemy_ai_keep_your_distance( false );

		enemy_ai_disable_grenades( false );

		level.player.climbing_tree = undefined;

		//level.player setorigin( v_start_player_position );
		//v_start_player_angles = level.player.angles;
		
		self trigger_on();
	}

	e_link_ent delete();
}


//*****************************************************************************
//*****************************************************************************

climb_down_button_pressed()
{
	if( !level.console && self usebuttonpressed() )
	{
		return true;
	}

	return self buttonPressed("BUTTON_B");
}


//*****************************************************************************
//*****************************************************************************

is_player_climbing_tree()
{
	if( IsDefined(level.player.climbing_tree) && (level.player.climbing_tree == true) )
	{
		return( 1 );
	}
	
	return( 0 );
}


//*****************************************************************************
//*****************************************************************************
// DOG Attack Scripts
//*****************************************************************************
//*****************************************************************************

// self = dog
dog_follow_path_then_attack_target( e_target, one_hit_player_kill )
{
	self endon( "death" );

	// Make doga a one player hit kill
	if( IsDefined(one_hit_player_kill) && (one_hit_player_kill == true) )
	{
		self.overrideActorDamage = ::easy_dog_damage_override;
	}

	self.ignoreall = true;

	self thread dog_change_target_if_player_up_tree( e_target, level.ai_woods, undefined );

	if( IsDefined(self.target) )
	{
		n_node = getnode( self.target, "targetname" );
		while( 1 )
		{
			self SetGoalPos( n_node.origin );
			self.goalradius = 164;

			last_dist = -999;			
			while( 1 )
			{
				dist = distance( self.origin, n_node.origin );
				if( (dist <= self.goalradius ) || (dist == last_dist) )
				{
					self SetGoalpos( self.origin );
					wait( 0.01 );
					break;
				}

				last_dist = dist;

				wait( 0.01 );
			}

			if( !IsDefined( n_node.target) )
			{
				break;
			}

			n_node = getnode( n_node.target, "targetname" );
		}
	}
	
	self.ignoreall = false;

	self thread dog_attacks_target( e_target );
}


// self = dog
dog_follow_node_array_then_attack_target( e_target, one_hit_player_kill, a_nodes )
{
	self endon( "death" );
	self endon( "stop_attacking_target" );

	// Make dog a one player hit kill
	if( IsDefined(one_hit_player_kill) && (one_hit_player_kill == true) )
	{
		self.overrideActorDamage = ::easy_dog_damage_override;
	}

	self.ignoreall = true;

	n_node = getnode( a_nodes[0], "targetname" );	
	self thread dog_change_target_if_player_up_tree( e_target, undefined, n_node.origin );

	if( IsDefined(a_nodes) )
	{
		for( i=0; i<a_nodes.size; i++ )
		{
			n_node = getnode( a_nodes[i], "targetname" );
		
			self SetGoalPos( n_node.origin );
			self.goalradius = 164;

			last_dist = -999;			
			while( 1 )
			{
				dist = distance( self.origin, n_node.origin );
				if( (dist <= self.goalradius ) || (dist == last_dist) )
				{
					self SetGoalpos( self.origin );
					wait( 0.01 );
					break;
				}

				last_dist = dist;

				wait( 0.01 );
			}
		}
	}
	
	self.ignoreall = false;

	self thread dog_attacks_target( e_target );
}


//
easy_dog_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if( IsDefined(e_inflictor) && (e_inflictor == level.player) )
	{
		//IPrintLnBold( "Easy Dog Damage" );
		n_damage = self.health + 100;
	}

	return( n_damage );

}


// This is a wrapper function for SetEntityTarget when used on a dog; if the target dies, ClearEntityTarget needs to be called
// for the dog to transition to a new target
dog_attacks_target( target )  // self = dog
{
	self endon( "death" );  // stop this function if the dog is killed
	self endon( "stop_attacking_target" );  // this can be received from "stop_dog_attacks_target()"
	
	if( !IsDefined( target ) )  // make sure we have a real target
	{
		//println( "invalid target for make_dog_attack_target" );
		return;
	}
	
	if( !self.isdog )  // make sure self is a dog
	{
		//println( "make_dog_attack_target should only be used on dogs!" );
		return;
	}
	
	self SetEntityTarget( target );  // set dog's target to the target we passed in
	
	while( IsAlive( target ) )  // wait until the target is dead. this is important because if the AI dies
	{							// and ClearEntityTarget isn't run, the dog will still focus on the dead guy
		wait( 0.1 );
	}
	
	self ClearEntityTarget();  // clear the dog's target and put him back into normal AI state
}


// self = dog
dog_run_to_position_and_die( v_escape_position )
{
	self endon( "death" );

	self ClearEntityTarget();  // clear the dog's target and put him back into normal AI state
	wait( 0.1 );

	self setgoalpos( v_escape_position ) ;

	while( 1 )
	{
		dist = distance( self.origin, v_escape_position );
		if( dist < 128 )
		{
			self dodamage( self.health+100, self.origin );		
			return;
		}
		wait( 0.01 );
	}
}


//*****************************************************************************
// If the player is up a tree, change the dogs target entity
// self = dog
//*****************************************************************************

dog_change_target_if_player_up_tree( e_main_target, e_alt_target, v_escape_position )
{
	self endon( "death" );

	// Run to an alternative position is the player is climbing a tree
	if( IsDefined(v_escape_position) )
	{
		while( 1 )
		{
			if( is_player_climbing_tree() )
			{
				//v_dog_pos = ( self.origin[0], self.origin[1], 0 );
				//v_target_pos = ( e_main_target.origin[0], e_main_target.origin[1], 0 );

				//dist = distance( v_dog_pos, v_target_pos );
				//if( dist< 128 )
				{
					self notify( "stop_attacking_target" );
					wait( 0.1 );
					self thread dog_run_to_position_and_die( v_escape_position );
					return;
				}
			}

			wait( 0.01 );
		}
	}

	// Attack an alternative target if the player is climbing a tree
	else if( IsDefined(e_alt_target) )
	{
		while( 1 )
		{
			if( is_player_climbing_tree() )
			{
				self notify( "stop_attacking_target" );
				wait( 0.1 );
				self thread dog_attacks_target( e_alt_target );
				self thread fail_mission_in_attacking_range( e_alt_target, 64, 2 );
				return;
			}
			wait( 0.1 );
		}
	}
}

// self = dog
fail_mission_in_attacking_range( e_target, attack_range, mission_failure_delay )
{
	self endon( "death" );

	while( 1 )
	{
		dist = distance( self.origin, e_target.origin );
		if( dist <= attack_range )
		{
			break;
		}

		wait( 0.01 );
	}

	wait( mission_failure_delay );

	maps\_utility::missionFailedWrapper( "Dog_Attacks_Allies" );
}


//*****************************************************************************
//*****************************************************************************

woods_damage_fail_condition()
{
	flag_wait( "je_hudson_in_position_for_battle_1" );

	level.ai_woods.ignoreme = false;
	level.ai_woods.overrideActorDamage = ::woods_damage_override;

	num_warnings = 0;
	
	time_last_hit = undefined;

	nag = 0;

	while( 1 )
	{
		// When we finally head to the beach, don't need to check on Woods health anymore
		if( flag("je_hudson_heads_to_beach") )
		{
			return;
		}

		if( flag("je_woods_takes_damage") )
		{
			num_warnings++;
			time_last_hit = gettime();
			if( num_warnings >= 4 )
			{
				missionFailedWrapper( &"ANGOLA_2_WOODS_KILLED" );				
			}

			//iprintlnbold( "MASON, PROTECT WOODS, the enemy is targetting him" );

			if( nag == 0 )
			{
				level.player say_dialog( "maso_we_gotta_protect_woo_0" );
				nag = 1;
			}
			else
			{
				level.ai_hudson say_dialog( "huds_dammit_mason_we_g_0" );
				//huds_cover_woods_he_s_a_0
				//huds_woods_is_under_fire_0
				nag = 0;
			}

			wait( 3 );
			flag_clear( "je_woods_takes_damage" );
		}

		// If woods is quite damaged and he's not been hit in a bit, give him a break
		if( num_warnings > 2 )
		{
			if( IsDefined(time_last_hit) )
			{
				time = gettime();
				dt = ( time - time_last_hit ) / 1000;
				if( dt > 60 )
				{
					num_warnings = num_warnings - 1;
					time_last_hit = time;
				}
			}
		}

		wait( 0.01 );
	}
}

woods_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	n_damage = 0;
	flag_set( "je_woods_takes_damage" );
	return( n_damage );
}


//*****************************************************************************
//*****************************************************************************

sniper_tree_vo()
{
	a_volumes = getentarray( "tree_sniper_helper_volume", "targetname" );
	if( IsDefined(a_volumes) )
	{
		while( 1 )
		{
			for( i=0; i<a_volumes.size; i++ )
			{
				if( level.player IsTouching(a_volumes[i]) )
				{
					level.ai_hudson say_dialog( "huds_use_the_ladder_0" );
					level.ai_hudson say_dialog( "huds_get_up_high_and_prov_0" );
					return;
				}
			}
			
			wait( 0.01 );
		}
	}
}

