

#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\angola_2_util;
#include maps\_anim;
#include maps\angola_jungle_stealth_carry;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


//*****************************************************************************
//*****************************************************************************

skipto_jungle_stealth()
{
	skipto_teleport_players( "player_skipto_jungle_stealth" );

	exploder( 200 );

	level.angola2_skipto = true;
}


//*****************************************************************************
//*****************************************************************************

init_flags()
{
	flag_init( "js_hudson_executes_hind_pilot" );

	flag_init( "js_hudson_waiting_at_log_blockage" );
	flag_init( "js_hudson_mason_rock_climb_start" );
	flag_init( "js_hudson_mason_rock_climb_complete" );

	flag_init( "js_hudson_lookout_for_child_soldiers" );
	flag_init( "mason_run_to_log_cover" );
	flag_init( "js_mason_in_cover_behind_log" );

	flag_init( "js_child_soldier_scene_complete" );

	flag_init( "js_player_enters_stealth_house" );

	flag_init( "js_moving_to_stealth_house_enter" );
	flag_init( "js_mason_in_position_in_building" );
	flag_init( "js_hudson_in_position_in_building" );

	flag_init( "js_mason_ready_to_exit_house" );

	flag_init( "js_stealth_house_complete" );

	init_stealth_carry_flags();
}

init_stealth_carry_flags()
{
	flag_init( "js_player_fails_stealth" );
	flag_init( "pause_woods_carry" );
	flag_init( "js_mason_is_carrying_woods" );
	flag_init( "woods_carry_cough" );
	flag_init( "player_obeys_stealth_command" );
}


//*****************************************************************************
//*****************************************************************************

main()
{
	switch_off_angola_escape_trigges();

	level.ai_woods = init_hero( "woods" );
	level.ai_hudson = init_hero( "hudson" );

	level.ai_hudson unlink();
	level.ai_hudson setgoalpos( level.ai_hudson.origin );

	level.player thread maps\createart\angola_art::jungle_stealth();

	init_flags();

	// Jungle Stealth Objectives
	level thread angola_stealth_objectives();

	// Mason carrying Woods
	level thread maps\angola_jungle_stealth_carry::mason_carry_woods( "j_stealth_player_picks_up_woods" );

	// Take away the players weapons
	level.player thread take_and_giveback_weapons( "give_back_weapons" );

	// Color System - Use the color system to move Hudson around
	level.ai_hudson set_force_color( "r" );

	// Intruder Perk
	level thread intruder_perk();

	// Dead bodies lying by the crashed chopper
	level thread chopper_dead_bodies();

	// Hudson shoots hind pilot
	level thread hudson_executes_hind_pilot();

	// 
	level thread fail_mission_if_player_does_not_follow_hudson();

	// Hudson Move the Blockage
	level thread hudson_rock_blockage();

	level thread hudson_get_into_position_after_rock_blockage();

	// 1st forced cover behind the log
	level thread hudsun_approaches_child_solider_encounter();
	
	// MASON Waits to Move to Stealth Position 2 (in the ruined house)
	level thread waiting_for_stealth_move_to_house();

	// Mason waits to move to Stealth Position 3 (in the dense bushes)
	level thread waiting_for_move_to_dense_foliage_area();

	level notify( "fxanim_vines_start" );

	flag_wait( "js_stealth_house_complete" );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

angola_stealth_objectives()
{
	//*************************************************
	//*************************************************

	flag_wait( "js_mason_is_carrying_woods" );

	wait( 0.25 );

	autosave_by_name( "mason_carrying_woods" );

	
	//*************************************************
	// OBJECTIVE: Follow Hudson into the Forest
	//*************************************************

	flag_wait( "js_hudson_executes_hind_pilot" );

	wait( 0.5 );
		
	set_objective( level.OBJ_MASON_FOLLOW_HUDSON, level.ai_hudson, "breadcrumb" );


	//***************************************************************************
	// Wait for Hudson to get into position, then activate the rock climb trigger
	//***************************************************************************

	flag_wait( "js_hudson_mason_rock_climb_start" );

	set_objective( level.OBJ_MASON_FOLLOW_HUDSON, undefined, "delete" );

	maps\angola_jungle_stealth_carry::set_carry_crouch_speed( level.default_mason_carry_crouch_speed * 0.9 );

	
	//****************************************
	// Wait for Mason to pass the log blockage
	//****************************************

	flag_wait( "js_hudson_mason_rock_climb_complete" );

	autosave_by_name( "js_hudson_mason_rock_climb_complete" );

	wait( 0.1 );


	//**************************************************************
	// OBJECTIVE: See the child Soldiers and Hide underneath the log
	//**************************************************************

	t_trigger = getent( "objective_mason_hudson_see_child_soldiers_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_HUDSON_LOOKOUT_FOR_CHILD_SOLDIERS, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_HUDSON_LOOKOUT_FOR_CHILD_SOLDIERS, undefined, "delete" );

	flag_set( "js_hudson_lookout_for_child_soldiers" );


	//****************************************
	// Wait for Mason to pass the log blockage
	//****************************************

	flag_wait( "mason_run_to_log_cover" );
	
	wait( 0.1 );

	
	//*******************************************************
	// OBJECTIVE: Mason told to hide behind the log for cover
	//*******************************************************
	
	t_trigger = getent( "objective_mason_hide_under_log_cover_trigger", "targetname" );
	if( IsDefined(t_trigger) )
	{
		str_struct_name = t_trigger.target;
		s_struct = getstruct( str_struct_name, "targetname" );
		set_objective( level.OBJ_MASON_HIDE_BEHIND_LOG_OBJECTIVE, s_struct, "" );

		t_trigger waittill( "trigger" );
		set_objective( level.OBJ_MASON_HIDE_BEHIND_LOG_OBJECTIVE, undefined, "delete" );
	}

	flag_set( "js_mason_in_cover_behind_log" );

	maps\angola_jungle_stealth_carry::set_carry_crouch_speed( level.default_mason_carry_crouch_speed );

	
	//***********************************************************
	// Wait for the command from Hudson to move to Stealth Area 2
	//***********************************************************

	set_objective( level.OBJ_HUDSON_STEALTH_ORDERS1_OBJECTIVE );
	flag_wait( "js_moving_to_stealth_house_enter" );
	set_objective( level.OBJ_HUDSON_STEALTH_ORDERS1_OBJECTIVE, undefined, "delete" );

	wait( 0.1 );


	//****************************
	// Move to Stealth Hide Area 2
	//****************************

	t_trigger = getent( "objective_mason_goto_stealth_building_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_RUN_TO_COVER2_OBJECTIVE, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_RUN_TO_COVER2_OBJECTIVE, undefined, "delete" );

	flag_set( "js_mason_in_position_in_building" );

	autosave_by_name( "mason_at_stealth_house_enter" );


	//***********************************************************
	// Wait for the command from Hudson to move to Stealth Area 3
	//***********************************************************

	set_objective( level.OBJ_MASON_IN_COVER2_POSITION );
	flag_wait( "js_stealth_house_complete" );
	set_objective( level.OBJ_MASON_IN_COVER2_POSITION, undefined, "delete" );

	wait( 0.1 );
}


//*****************************************************************************
//*****************************************************************************
// ANIMATIONS
//*****************************************************************************
//*****************************************************************************

chopper_dead_bodies()
{
	level thread run_scene( "chopper_dead_body1" );
	level thread run_scene( "chopper_dead_body2" );
	level thread run_scene( "chopper_dead_body3" );
	
	flag_wait( "mason_run_to_log_cover" );

	end_scene( "chopper_dead_body1" );
	end_scene( "chopper_dead_body2" );
	end_scene( "chopper_dead_body3" );
}

hudson_executes_hind_pilot()
{
	// Hudson exits the water
	str_scene_name = "j_stealth_player_picks_up_woods_hudson_watches";
	level thread run_scene_and_delete( str_scene_name );
	wait( 0.1 );
	level.ai_hudson.ignoreall = true;
	
	//scene_wait( str_scene_name );

	hudson_kill_pilot_wait_time = 9;		// 10
	wait( hudson_kill_pilot_wait_time );

	// Hudson runs to the scene start points and plays the execution animation
	str_pilot_execution_hudson = "pilot_execution_hudson";
	str_pilot_execution_pilot = "pilot_execution_pilot";

	// Start the two animation scenes
	level thread run_scene_and_delete( str_pilot_execution_hudson );
	level thread run_scene_first_frame( str_pilot_execution_pilot );

	// Wait for Hudson to start the animation
	level.ai_hudson waittill( "goal" );

	run_scene( str_pilot_execution_pilot );

	// Wait for Hudson to complete the animation
	scene_wait( str_pilot_execution_hudson );
	
	level clientnotify( "aS_off" );
	flag_set( "js_hudson_executes_hind_pilot" );
}


//*****************************************************************************
//*****************************************************************************

hudson_rock_blockage()
{
	t_trigger = getent( "hudson_rock_bockage_trigger", "targetname" );
	t_trigger trigger_off();

	flag_wait( "js_hudson_executes_hind_pilot" );
	
	run_scene( "hudson_moves_to_rock_blockage" );

	level thread run_scene( "hudson_moves_to_rock_blockage_loop" );

	// Wait for the player to get in place

	/*
	IPrintLnBold( "Hudson at the rocks waiting for Mason" );
	*/

	flag_set( "js_hudson_waiting_at_log_blockage" );

	t_trigger trigger_on();
	t_trigger waittill( "trigger" );
	
	flag_set( "js_hudson_mason_rock_climb_start" );

	// Climb over the rock blockage
	hide_player_carry();
	level thread run_scene( "hudson_climb_rock_blockage" );
	run_scene( "mason_woods_climb_rock_blockage" );
	unhide_player_carry();

	flag_set( "js_hudson_mason_rock_climb_complete" );
}


//*****************************************************************************
//*****************************************************************************

hudson_get_into_position_after_rock_blockage()
{
	flag_wait( "js_hudson_mason_rock_climb_complete" );

	// Hudson Moves to 1st Child Soldier Reveal Area
	t_trigger = getent( "color_hudson_1st_child_reveal_trigger", "targetname" );
	t_trigger activate_trigger();

	wait( 0.1 );		// 8
	//IPrintLnBold( "MASON: We have company, follow my directions" );
	//level.ai_hudson say_dialog( "huds_the_mpla_are_crawlin_0" );
	//level.ai_hudson say_dialog( "huds_stay_low_0" );

	level.ai_hudson waittill( "goal" );
	wait( 2.5 );
	//level.ai_hudson say_dialog( "huds_hold_activity_ahea_0" );
	//level.ai_hudson say_dialog( "huds_keep_quiet_0" );
}

			
//*****************************************************************************
//*****************************************************************************

hudsun_approaches_child_solider_encounter()
{
	flag_wait( "js_hudson_lookout_for_child_soldiers" );

	//IPrintLnBold( "MASON: Take cover behind the log, enemy soldier approaching" );
	//level.ai_hudson thread say_dialog( "huds_we_need_to_hide_0" );
	//level.ai_hudson thread say_dialog( "huds_this_way_behind_t_0", 1.5 );

	level notify( "stop_following_hudson_nag" );

	level thread mason_run_to_log_cover( 10 );	// 8

	// Child soldier reveal
	level thread run_scene( "hudson_child_soldier_intro_move_to_cover" );
	level.ai_hudson waittill( "goal" );
	run_scene( "hudson_child_soldier_intro_move_to_cover_part2" );

	level thread run_scene( "hudson_waits_in_cover_for_player_to_take_cover" );
	flag_wait( "js_child_soldier_scene_complete" );
	end_scene( "hudson_waits_in_cover_for_player_to_take_cover" );
}


//*****************************************************************************
//*****************************************************************************

mason_run_to_log_cover( objective_time )
{
	flag_set( "mason_run_to_log_cover" );

	time_start = gettime();

	while( 1 )
	{
		time = gettime();
		dt = (time - time_start) / 1000;
		
		// Has Mason taken too long to reach the log cover?
		if( dt > objective_time )
		{
			MissionFailed();
			return;
		}

		// Is Mason in the cover position?
		if( flag( "js_mason_in_cover_behind_log" ) )
		{
			break;
		}

		wait( 0.01 );
	}

	// Objective completed
	hide_player_carry();
	//wait( 0.01 );

	run_scene_and_delete( "player_prone_watches_1st_child_soldier_encounter" );

	unhide_player_carry();

	flag_set( "js_child_soldier_scene_complete" );

	set_objective( level.OBJ_MASON_FOLLOW_HUDSON, level.ai_hudson, "follow" );

	//IPrintLnBold( "Child Soldier Scene Complete" );
}


//**************************************************************************************
//**************************************************************************************
// MASON, HUDSON and WOODS wait for an opportunity to move to Stealth Pos 2 (The House )
//**************************************************************************************
//**************************************************************************************

waiting_for_stealth_move_to_house()
{
	flag_wait( "js_child_soldier_scene_complete" );

	// Send hudson to a cover position to give orders
	level thread hudson_waiting_for_stealth_move_to_house();

	wait( 0.1 );

	autosave_by_name( "child_soldier_reveal_started" );

	str_area_safe = "area_clear";

	// Tell the player to use crouch cover
	str_crouch_flag = "player_obeys_stealth_command";
	
	if( level.console )
		level thread helper_message( &"ANGOLA_2_STEALTH_MASON_USE_GRASS_AS_COVER", 6, str_crouch_flag );
	else
		level thread helper_message( &"ANGOLA_2_STEALTH_MASON_USE_GRASS_AS_COVER_PC", 6, str_crouch_flag );

	level thread fail_mission_if_not_in_crouch_cover( str_area_safe, 5.0, 1.5, 3.5 );

	// Activate areas the player can't walk into
	level thread mission_fail_if_not_inside_info_volumes( "stealth_volume_by_log", str_area_safe, 4, "js_player_fails_stealth", "player_breaks_log_stealth_spawner" );

	// Setup some child soldiers idling that will fail the player if they don't get to the house in time
	level thread background_soldier_anims_alert_timeout( "child_soldier_anim_group1", "child_soldier_anim_group1_alerted", "js_moving_to_stealth_house_enter", "js_player_enters_stealth_house", 10, 2.5 );
	level thread background_soldier_anims_alert_timeout( "child_soldier_anim_group2", "child_soldier_anim_group2_alerted", "js_moving_to_stealth_house_enter", "js_player_enters_stealth_house", 10, 2.5 );

	// Wait for the player to obey the crouch command
	while( 1 )
	{
		if( is_mason_stealth_crouched() )
		{
			flag_set( "player_obeys_stealth_command" );			
			break;
		}
		wait( 0.01 );
	}

	wait( 0.5 );									// 1
		
	// Spawn in some bad dudes
	level thread stealth1_bad_dudes_wave1();
	level thread stealth1_bad_dudes_wave2( 1 );		// 2
	level thread stealth1_bad_dudes_wave3( 5 );		// 8

	flag_wait( "js_moving_to_stealth_house_enter" );	

	// Make it safe for the player to leave the area
	// turns off both info volume checks and player being crouched check
	level notify( str_area_safe );


	// Wait for the player to enter the safety of the house

	str_trigger = "player_enters_stealth_house_trigger";
	e_trigger = getent( str_trigger, "targetname" );
	e_trigger waittill( "trigger" );

	flag_set( "js_player_enters_stealth_house" );
}


//**************************************************************************************
//**************************************************************************************

stealth1_bad_dudes_wave1( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "go_house_wave1_a1";
	a_nodes[1] = "go_house_wave1_a2";
	a_nodes[2] = "go_house_wave1_a3";
	level thread ai_run_along_node_array( "go_house_wave1_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_house_wave1_b1";
	a_nodes[1] = "go_house_wave1_b2";
	a_nodes[2] = "go_house_wave1_b3";
	level thread ai_run_along_node_array( "go_house_wave1_b1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_house_wave1_c1";
	a_nodes[1] = "go_house_wave1_c2";
	a_nodes[2] = "go_house_wave1_c3";
	level thread ai_run_along_node_array( "go_house_wave1_c1_spawner", a_nodes, true, false, undefined );
}

stealth1_bad_dudes_wave2( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "go_house_wave2_a1";
	a_nodes[1] = "go_house_wave2_a2";
	a_nodes[2] = "go_house_wave2_a3";
	level thread ai_run_along_node_array( "go_house_wave2_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_house_wave2_b1";
	a_nodes[1] = "go_house_wave2_b2";
	a_nodes[2] = "go_house_wave2_a3";
	level thread ai_run_along_node_array( "go_house_wave2_b1_spawner", a_nodes, true, false, undefined );
}

stealth1_bad_dudes_wave3( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "go_house_wave3_a1";
	a_nodes[1] = "go_house_wave3_a2";
	a_nodes[2] = "go_house_wave3_a3";
	level thread ai_run_along_node_array( "go_house_wave3_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_house_wave3_b1";
	a_nodes[1] = "go_house_wave3_b2";
	a_nodes[2] = "go_house_wave3_a3";
	level thread ai_run_along_node_array( "go_house_wave3_b1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_house_wave3_c1";
	a_nodes[1] = "go_house_wave3_c2";
	a_nodes[2] = "go_house_wave3_a3";
	level thread ai_run_along_node_array( "go_house_wave3_c1_spawner", a_nodes, true, false, undefined );
}

hudson_waiting_for_stealth_move_to_house()
{
	level.ai_hudson.ignoreall = true;
	level.ai_hudson.ignoreme = true;

	level thread hudson_after_log_anim_dialog( 1.5 );


	//***************************************
	// Send Hudson to a cover node by the log
	//***************************************

	nd_node = getnode( "hudson_wait_at_log_node", "targetname" );

	t_color_trigger = getent( "color_hudson_waiting_for_house_move_trigger", "targetname" );
	t_color_trigger activate_trigger();
	level.ai_hudson.goalradius = 48;
	level.ai_hudson force_goal( nd_node, 48 );
	level.ai_hudson waittill( "goal" );

	flag_wait( "player_obeys_stealth_command" );

	wait( 8 );		// 8

	//level thread helper_message( &"ANGOLA_2_STAY_IN_COVER_CHILD_SOLDIERS_AROUND", 6 );

	level thread move_to_house_dialog( 5 );

	wait( 9.5 );		// 10


	//************************************
	// Hudson heads to the House Enterance
	//************************************

	flag_set( "js_moving_to_stealth_house_enter" );	

	wait( 0.25 );	
	//IPrintLnBold( "MASON follow me, lets hide in the building" );


	//***********************************
	// The house is safe, now move inside
	//***********************************
	
	t_color_trigger = getent( "color_hudson_waiting_for_stealth_house_enter_trigger", "targetname" );
	t_color_trigger activate_trigger();
	level.ai_hudson.goalradius = 48;
	
	level thread enter_house_dialog( 7 );

	level.ai_hudson waittill( "goal" );

	flag_set( "js_hudson_in_position_in_building" );

	set_objective( level.OBJ_MASON_FOLLOW_HUDSON, undefined, "delete" );
}

hudson_after_log_anim_dialog( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		level.ai_hudson say_dialog( "huds_gotta_stay_outta_sig_0" );
		level.ai_hudson say_dialog( "huds_stay_in_the_grass_0" );
		level.ai_hudson say_dialog( "huds_stay_low_keep_your_0" );

		wait( 4.5 );
		level.ai_hudson say_dialog( "huds_child_soldiers_lef_0" );
		wait( 1 );
		level.ai_hudson say_dialog( "huds_don_t_move_let_the_0" );
	}
}

move_to_house_dialog( delay )
{
	if( IsDefined(delay) && (delay > 0)  )
	{
		wait( delay );
	}

	level.ai_hudson say_dialog( "huds_okay_we_can_make_0" );
	level.ai_hudson say_dialog( "huds_on_my_lead_we_go_0" );
	level.ai_hudson say_dialog( "huds_now_0" );
}

enter_house_dialog( delay )
{
	if( IsDefined(delay) && (delay > 0)  )
	{
		wait( delay );
	}

	level.ai_hudson say_dialog( "huds_stay_with_me_0" );
	wait( 1 );
	level.ai_hudson say_dialog( "huds_someone_s_coming_s_0" );
}


//******************************************************************************************
//******************************************************************************************
// MASON, HUDSON and WOODS wait for an opportunity to move to Stealth Pos 3 (The Tall Grass)
//******************************************************************************************
//******************************************************************************************

waiting_for_move_to_dense_foliage_area()
{
	level endon( "mason_failed_to_find_cover_in_house" );

	flag_wait( "js_player_enters_stealth_house" );

	level thread fail_player_if_cover_not_taken_inside_house( 10 );

	flag_wait( "js_hudson_in_position_in_building" );

	flag_wait( "js_mason_in_position_in_building" );

	level thread in_house_dialog( 0 );

	wait( 0.1 );

	str_area_safe = "house_area_clear";

	str_crouch_flag = "player_obeys_stealth_command";
	flag_clear( str_crouch_flag );

	if( level.console )
		level thread helper_message( "Mason press [{+stance}] to hide in cover", 6, str_crouch_flag );
	else
		level thread helper_message( "Mason press [{+activate}] to hide in cover", 6, str_crouch_flag );

	level thread fail_mission_if_not_in_crouch_cover( str_area_safe, 5.0, 1.5, 3.5 );
	
	level thread mission_fail_if_not_inside_info_volumes( "stealth_containment_area_b", str_area_safe, 4, "js_player_fails_stealth", undefined );

	// Hudson in Cover giving orders to move to stealth Area 3
	level thread hudson_waiting_for_dense_foliage_move();

	// Wait for the player to obey the crouch command
	while( 1 )
	{
		if( is_mason_stealth_crouched() )
		{
			flag_set( "player_obeys_stealth_command" );
			break;
		}
		wait( 0.01 );
	}

	wait( 0.2 );
		
	// Spawn in some bad dudes
	level thread stealth2_bad_dudes_wave1( 0.1 );
	level thread stealth2_bad_dudes_wave2( 5 );

	flag_wait( "js_mason_ready_to_exit_house" );

	// Make it safe for the player to leave the area
	// turns off both info volume checks and player being crouched check
	level notify( str_area_safe );

	wait( 0.1 );

	flag_set( "js_stealth_house_complete" );
}

in_house_dialog( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	level.ai_hudson say_dialog( "huds_get_down_0" );
	wait( 1 );
	level.ai_hudson say_dialog( "huds_don_t_move_more_pa_0" );
	wait( 2.5 );
	level.ai_hudson say_dialog( "huds_wait_0" );
}


//*****************************************************************************
//*****************************************************************************

fail_player_if_cover_not_taken_inside_house( mission_time_out )
{
	wait( mission_time_out );

	if( flag("js_mason_in_position_in_building") == false )
	{
		level notify( "mason_failed_to_find_cover_in_house" );

		level thread missionary_patroller();
		wait( 4 );
		flag_set( "js_player_fails_stealth" );
		wait( 2 );
		missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
	}
}


//*****************************************************************************
//*****************************************************************************

hudson_waiting_for_dense_foliage_move()
{
	level endon( "mission failed" );
	level endon( "kill_in_cover_checks" );

	// Setup
	level.ai_hudson.ignoreall = true;
	level.ai_hudson.ignoreme = true;

	flag_wait( "player_obeys_stealth_command" );

	// Spawn a patrolling man in the house
	str_category = "dummy_category";
	
	level thread missionary_patroller();

	wait( 7 );	// 7

	//IPrintLnBold( "MASON stay crouched in cover, there are enemy units everywhere" );

	wait( 9 );	// 7

	//IPrintLnBold( "MASON, wait for the guard to clear the area" );
	level.ai_hudson thread say_dialog( "huds_okay_there_s_a_pa_0" );

	wait( 8 );	// 10
	level.ai_hudson thread say_dialog( "huds_go_0" );
	
	//IPrintLnBold( "MASON, lets go, follow me and hide in the dense Grass ahead" );

	flag_set( "js_mason_ready_to_exit_house" );
}


//*****************************************************************************
// The guy follows an animated patrol
// If stealth is broken, he breaks out of the animation and fires at the player
//*****************************************************************************

missionary_patroller()
{
	str_scene = "missionary_patroller";

	level thread run_scene( str_scene );
	wait( 0.01 );

	e_ent = getent( "house_follow_path_and_die_spawner_ai", "targetname" );

	scene_done_flag = ( str_scene + "_done" );

	while( 1 )
	{
		if( flag(scene_done_flag) )
		{
			break;
		}

		if( flag("js_player_fails_stealth") )
		{
			end_scene( str_scene );

			e_ent.ignoreall = true;
			e_ent.favoriteenemy = level.player;
			e_ent.script_ignore_suppression = 1;

			e_ent thread aim_at_target( level.player );
			e_ent thread shoot_at_target( level.player, undefined, 0.2, 3 );
			
			return;
		}
		
		wait( 0.01 );
	}

	e_ent delete();
}


//*****************************************************************************
//*****************************************************************************

stealth2_bad_dudes_wave1( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "go_bushes_wave1_a1_node";
	a_nodes[1] = "go_bushes_wave1_a2_node";
	a_nodes[2] = "go_bushes_wave1_a3_node";
	level thread ai_run_along_node_array( "go_bushes_wave1_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_bushes_wave1_b1_node";
	a_nodes[1] = "go_bushes_wave1_b2_node";
	a_nodes[2] = "go_bushes_wave1_b3_node";
	level thread ai_run_along_node_array( "go_bushes_wave1_b1_spawner", a_nodes, true, false, undefined );
}


//*****************************************************************************
//*****************************************************************************

stealth2_bad_dudes_wave2( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "go_bushes_wave2_a1_node";
	a_nodes[1] = "go_bushes_wave2_a2_node";
	a_nodes[2] = "go_bushes_wave2_a3_node";
	level thread ai_run_along_node_array( "go_bushes_wave2_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_bushes_wave2_b1_node";
	a_nodes[1] = "go_bushes_wave2_b2_node";
	a_nodes[2] = "go_bushes_wave2_b3_node";
	level thread ai_run_along_node_array( "go_bushes_wave2_b1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "go_bushes_wave2_c1_node";
	a_nodes[1] = "go_bushes_wave2_c2_node";
	a_nodes[2] = "go_bushes_wave2_c3_node";
	level thread ai_run_along_node_array( "go_bushes_wave2_c1_spawner", a_nodes, true, false, undefined );
}


//*****************************************************************************
//*****************************************************************************
// SPECIALTY PERK - Intruder for the armery
//					Note the Intruder can also be known as the lock breaker!!!
//*****************************************************************************
//*****************************************************************************

intruder_perk()
{
	//level endon( "event7_blocked_off" );

	level thread setup_beartrap_pickup();

	// Wait for the player to get the perk
	while( 1 )
	{
		if( level.player HasPerk( "specialty_intruder" ) )
		{
			break;
		}
		
		wait( 0.1 );
	}

	// Set the Intruder Objective
	s_intruder = getstruct( "intruder_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder.origin, "interact" );
	
	s_intruder_door_switch = getstruct( "intruder_perk_door01_struct", "targetname" );
	m_intruder_door01 = GetEnt( "perk_intruder", "targetname" );
	
	//trigger_wait( "t_intruder_use" );
	e_trigger = getent( "open_toolshed_trigger", "targetname" );
	e_trigger setCursorHint( "HINT_NOICON" );
	e_trigger SetHintString( "Press [{+activate}] to open the Tools Shed" );
	e_trigger waittill( "trigger" );
	e_trigger delete();
		
	run_scene_and_delete( "intruder" );	
	
	m_intruder_door01 moveto( s_intruder_door_switch.origin, 1.5 );	
	
	set_objective( level.OBJ_INTERACT, s_intruder, "remove" );

	//t_intruder_use = GetEnt( "t_intruder_use", "targetname" );
	//t_intruder_use Delete();
}


//*****************************************************************************
//*****************************************************************************

setup_beartrap_pickup()
{
	e_use_trig = GetEnt( "trigger_beartrap", "targetname" );
	e_use_trig setCursorHint( "HINT_NOICON" );
	e_use_trig SetHintString( "Press [{+activate}] to pickup Beartraps" );
	e_use_trig thread beartrap_trigger_update();
}


//*****************************************************************************
//*****************************************************************************

beartrap_trigger_update()
{
	self waittill( "trigger" );
	
	e_beartrap_model = getent( "beartrap_pickup", "targetname" );
	e_beartrap_model delete();

	level.player_beartrap_toolshed_pickup = true;

	level.player thread say_dialog( "maso_these_animal_traps_s_0", 2 );

	maps\angola_2_beartrap::give_player_beartrap();

	self delete();
}


//*****************************************************************************
//*****************************************************************************
// Sharing GEO with multiple Events so have to turn on/off trigger in areas we 
// move over the save areas of the map
//*****************************************************************************
//*****************************************************************************

switch_off_angola_escape_trigges()
{
	level.a_angola_escape_triggers = [];

	e_trigger = getent( "je_battle1_start_trigger", "targetname" );
	level.a_angola_escape_triggers[ level.a_angola_escape_triggers.size ] = e_trigger;

	e_trigger = getent( "objective_mason_exit_villiage_into_forest_trigger", "targetname" );
	level.a_angola_escape_triggers[ level.a_angola_escape_triggers.size ] = e_trigger;

	for( i=0; i<level.a_angola_escape_triggers.size; i++ )
	{
		t_trigger = level.a_angola_escape_triggers[ i ];
		t_trigger trigger_off();
	}
}

switch_on_angola_escape_trigges()
{
	if( IsDefined(level.a_angola_escape_triggers) )
	{
		for( i=0; i<level.a_angola_escape_triggers.size; i++ )
		{
			t_trigger = level.a_angola_escape_triggers[ i ];
			t_trigger trigger_on();
		}
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

fail_mission_if_player_does_not_follow_hudson()
{
	level endon( "stop_following_hudson_nag" );

	flag_wait( "js_mason_is_carrying_woods" );

	safe_distance = 1400;

	safe_time = gettime();

	nag1 = 0;
	nag1_time = 3;
	nag2 = 0;
	nag2_time = 15;
	nag3 = 0;
	nag3_time = 30;

	while( 1 )
	{
		time = gettime();

		dist = distance( level.player.origin, level.ai_hudson.origin );

		if( dist > safe_distance )
		{
			dt = ( time - safe_time ) / 1000;
			if( (nag1 == 0) && (dt > nag1_time) )
			{
				nag1 = 1;
				IPrintLnBold( "Mason, get back to Woods, you must stay together" );
			}
			if( (nag2 == 0) && (dt > nag2_time) )
			{
				nag2 = 1;
				IPrintLnBold( "Mason, final warning you must protect Woods" );
			}
			if( (nag3 == 0) && (dt > nag3_time) )
			{
				nag3 = 1;
				missionFailedWrapper( &"ANGOLA_2_MISSION_FAILED_LOST_CONTACT_WITH_HUDSON" );
				return;
			}
		}
		else
		{
			safe_time = time;
			nag1 = 0;
			nag2 = 0;
			nag3 = 0;
		}

		wait( 0.01 );
	}
}



//*****************************************************************************
//*****************************************************************************
// DIALOG
//*****************************************************************************
//*****************************************************************************

