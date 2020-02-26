
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

skipto_jungle_stealth_house()
{
	skipto_teleport_players( "player_skipto_jungle_stealth_house" );

	maps\angola_jungle_stealth::init_stealth_carry_flags();

	maps\angola_jungle_stealth::switch_off_angola_escape_trigges();

	level.player thread maps\createart\angola_art::jungle_stealth();

	// Intruder Perk
	level thread intruder_perk();

	level.ai_woods = init_hero( "woods" );
	level.ai_hudson = init_hero( "hudson" );

	// Color System - Use the color system to move Hudson around
	level.ai_hudson set_force_color( "r" );

	// Take away the players weapons
	level.player thread take_and_giveback_weapons( "give_back_weapons" );

	// Setup Woods/Mason carry
	level thread maps\angola_jungle_stealth_carry::mason_carry_woods();

	// Setup Woods Position
	s_struct = getstruct( "hudson_skipto_jungle_stealth_house", "targetname" );
	level.ai_hudson ForceTeleport( s_struct.origin, s_struct.angles );

	exploder( 200 );
	level notify( "fxanim_vines_start" );

	level.angola2_skipto = true;
}


//*****************************************************************************
//*****************************************************************************

init_flags()
{
	flag_init( "js_moving_to_stealth_dense_foliage_area" );
	flag_init( "js_mason_in_position_in_dense_foliage_area" );
	flag_init( "js_hudson_in_position_in_dense_foliage_area" );

	flag_init( "js_moving_to_final_woods_drop_point" );
	flag_init( "js_mason_in_position_in_woods_drop_off_area" );
	flag_init( "js_hudson_in_position_in_woods_drop_off_area" );

	flag_init( "js_mason_ready_to_enter_village" );

	flag_init( "js_stealth_event_complete" );
}


//*****************************************************************************
//*****************************************************************************

main()
{
	init_flags();

	// Jungle Stealth Objectives
	level thread angola_stealth_house_objectives();

	// Mason moves to Stealth Position 3 (in the dense bushes)
	level thread hudson_moves_to_dense_foliage_cover3();
		
	// Mason waits to move to the Woods Final Drop off Area
	level thread waiting_for_move_to_woods_drop_off_point();

	// End of carry
	level thread hudson_drops_off_woods_and_hudson_at_village_enterance();
	
	flag_wait( "js_stealth_event_complete" );
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

angola_stealth_house_objectives()
{
	wait( 0.1 );
	

	//****************************************************
	// Move to Stealth Hide Area 3 - The Interactive Grass
	// - Triggers Woods coughing
	//****************************************************

	t_trigger = getent( "objective_mason_goto_stealth_area3_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_RUN_TO_COVER3_OBJECTIVE, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_RUN_TO_COVER3_OBJECTIVE, undefined, "delete" );


	//*************************
	// Woods has a coughing fit
	//*************************

	flag_set( "woods_carry_cough" );
	//SOUND - Shawn J
	clientNotify ("chsr");
	level.player PlayRumbleOnEntity( "damage_light" );

	flag_set( "js_mason_in_position_in_dense_foliage_area" );

	autosave_by_name( "mason_reaches_stealth_event3" );


	//***************************************************************************************
	// Wait for the command from Hudson to move to the Final Woods Drop Off destination point
	//***************************************************************************************

	s_struct = getstruct( "exit_grass_objective_struct", "targetname" );

	set_objective( level.OBJ_MASON_IN_COVER3_POSITION, s_struct, "" );
	flag_wait( "js_moving_to_final_woods_drop_point" );
	set_objective( level.OBJ_MASON_IN_COVER3_POSITION, undefined, "delete" );

	wait( 0.1 );


	//*****************************
	// Move to Woods Drop Off Point
	//*****************************

	t_trigger = getent( "objective_mason_goto_woods_drop_off_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_RUN_TO_SAFETY_ROCKS_OBJECTIVE, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_RUN_TO_SAFETY_ROCKS_OBJECTIVE, undefined, "delete" );

	flag_set( "js_mason_in_position_in_woods_drop_off_area" );

	autosave_by_name( "js_mason_in_position_in_woods_drop_off_area" );


	//******************************
	// Head to the Village Enterance
	//******************************

	flag_wait( "js_mason_ready_to_enter_village" );
		
	t_trigger = getent( "objective_mason_goto_village_enterance_trigger", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	set_objective( level.OBJ_MASON_ENTER_THE_VILLAGE, s_struct, "" );

	t_trigger waittill( "trigger" );
	set_objective( level.OBJ_MASON_ENTER_THE_VILLAGE, undefined, "delete" );


	//***********************
	// End of Stealth Section
	//***********************

	wait( 0.1 );

	flag_set( "js_stealth_event_complete" );
}


//******************************************************************************************
//******************************************************************************************
// MASON, HUDSON and WOODS wait for an opportunity to move to Stealth Pos 3 (The Tall Grass)
//******************************************************************************************
//******************************************************************************************

hudson_moves_to_dense_foliage_cover3()
{
	//*******************************************************
	// Hudson Moves to the dense foliage cover, leading Mason
	//*******************************************************
	
	t_color_trigger = getent( "color_hudson_waiting_for_stealth4_trigger", "targetname" );
	t_color_trigger activate_trigger();
	level.ai_hudson.goalradius = 48;

	flag_set( "js_moving_to_stealth_dense_foliage_area" );

	level thread exit_church_dialog( 3.5 );

	wait( 0.1 );
	
	level.ai_hudson waittill( "goal" );

	flag_set( "js_hudson_in_position_in_dense_foliage_area" );
}

exit_church_dialog( delay )
{
	If( IsDefined(delay) && (delay > 0) )
	{	
		wait( delay );
	}

	level.ai_hudson say_dialog( "huds_stay_with_me_1" );
}


//**********************************************************************************
//**********************************************************************************
// MASON, HUDSON and WOODS are in the DENSE FOLIAGE AREA, waiting to move on
//**********************************************************************************
//**********************************************************************************

waiting_for_move_to_woods_drop_off_point()
{
	flag_wait( "js_mason_in_position_in_dense_foliage_area" );

	flag_wait( "js_hudson_in_position_in_dense_foliage_area" );

	// Wait for the player to stop coughing
	woods_has_coughing_problem();

	str_area_safe = "dense_foliage_area_clear";
	str_crouch_flag = "player_obeys_stealth_command";
	flag_clear( str_crouch_flag );

	// Tell the player to go grouched in the grass cover
	if( level.console )
		level thread helper_message( &"ANGOLA_2_STEALTH_MASON_USE_GRASS_AS_COVER", 6, str_crouch_flag );
	else
		level thread helper_message( &"ANGOLA_2_STEALTH_MASON_USE_GRASS_AS_COVER_PC", 6, str_crouch_flag );

	level thread woods_coughing_dialog();

	wait( 0.5 );

	level thread kill_player_if_standing_inside_volume( "stealth_dense_foliage_cant_stand_volume", str_area_safe, 2.6, "player_breaks_grass_stealth_spawner" );

	level thread fail_mission_if_not_in_crouch_cover( str_area_safe, 5.0, 1.5, 3.5 );

	level thread mission_fail_if_not_inside_info_volumes( "stealth_dense_foliage_cover_volume", str_area_safe, undefined, undefined, undefined );

	// Hudson in Cover giving orders to move to final drop off point
	level thread hudson_waiting_for_woods_drop_off_move();

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

	wait( 1 );
		
	// Spawn in some bad dudes
	//level thread stealth3_bad_dudes_wave1( 0.1 );

	easy_version = true;

	if( easy_version == true )
	{
		level thread stealth3_searching_grass_dudes_easy();
	}
	else
	{
		level thread stealth3_searching_grass_dudes_hard();
	}

	flag_wait( "js_moving_to_final_woods_drop_point" );	

	// Make it safe for the player to leave the area
	// turns off both info volume checks and player being crouched check
	level notify( str_area_safe );
}

woods_has_coughing_problem()
{
	wait( 2.5 );	// 3

	//IPrintLnBold( "MASON, whats wrong with Woods, he'll give our position away" );
	level.ai_hudson thread say_dialog( "huds_mason_where_you_go_0" );

	while( 1 )
	{
		if( flag("woods_carry_cough") == false )
		{
			break;
		}
		wait( 0.01 );
	}
}

woods_coughing_dialog()
{
	wait( 0.5 );

	level.ai_hudson say_dialog( "huds_get_down_1" );
	level.ai_hudson say_dialog( "huds_patrols_all_around_0" );

	wait( 1 );
	level.ai_hudson say_dialog( "huds_keep_low_or_they_ll_0" );
	wait( 1.5 );
	level.ai_hudson say_dialog( "huds_don_t_let_them_run_i_0" );
}

hudson_waiting_for_woods_drop_off_move()
{
	level endon( "mission failed" );

	// Setup
	level.ai_hudson.ignoreall = true;
	level.ai_hudson.ignoreme = true;

	flag_wait( "player_obeys_stealth_command" );

	wait( 1.5 );	// 4

	//IPrintLnBold( "MASON, Avoid the Soldiers searching the grass" );

	wait( 6 );
	
			
	//*******************************************************
	// Hudson Moves to the dense foliage cover, leading Mason
	//*******************************************************
	
	t_color_trigger = getent( "color_hudson_waiting_for_woods_dropoff_trigger", "targetname" );
	t_color_trigger activate_trigger();
	level.ai_hudson.goalradius = 48;
	
	e_trigger = getent( "stealth_grass_complete_trigger", "targetname" );
	e_trigger waittill( "trigger" );
	
	flag_set( "js_moving_to_final_woods_drop_point" );

	// Turn off stealth system
	level notify( "reset_patrol" );

	wait( 1 );
	//IPrintLnBold( "MASON, we're clear, run for the rocks ahead" );
	level.ai_hudson thread say_dialog( "huds_follow_me_0" );

	level.ai_hudson waittill( "goal" );

	flag_set( "js_hudson_in_position_in_woods_drop_off_area" );
}

stealth3_bad_dudes_wave1( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	a_nodes = [];
	a_nodes[0] = "tall_grass_wave1_a1_node";
	a_nodes[1] = "tall_grass_wave1_a2_node";
	a_nodes[2] = "tall_grass_wave1_a3_node";
	level thread ai_run_along_node_array( "tall_grass_wave1_a1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "tall_grass_wave1_b1_node";
	a_nodes[1] = "tall_grass_wave1_b2_node";
	a_nodes[2] = "tall_grass_wave1_b3_node";
	a_nodes[3] = "tall_grass_wave1_b4_node";
	level thread ai_run_along_node_array( "tall_grass_wave1_b1_spawner", a_nodes, true, false, undefined );

	a_nodes = [];
	a_nodes[0] = "tall_grass_wave1_c1_node";
	a_nodes[1] = "tall_grass_wave1_c2_node";
	a_nodes[2] = "tall_grass_wave1_c3_node";
	level thread ai_run_along_node_array( "tall_grass_wave1_c1_spawner", a_nodes, true, false, undefined );
}


//*****************************************************************************
//*****************************************************************************

stealth3_searching_grass_dudes_easy()
{
	view_dot = 0.90;		// 0.91
	vis_dist = 110;			// 130

	for( i=0; i<3; i++ )
	{
		if( i == 0 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass1_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node4";
			level thread stealth_search_for_player( 0.01, "find_player_in_grass1_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
		else if (i == 1 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass2_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node4";
			level thread stealth_search_for_player( 5, "find_player_in_grass2_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
		else if (i == 2 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass4_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node4";
			level thread stealth_search_for_player( 10, "find_player_in_grass3_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

stealth3_searching_grass_dudes_hard()
{
	view_dot = 0.90;		// 0.91
	vis_dist = 130;			// 130

	nums = [];

	rval = randomint( 1000 );
	if( rval < 333 )
	{
		nums[nums.size] = 1;
		nums[nums.size] = 2;
		nums[nums.size] = 3;
		nums[nums.size] = 4;
	}
	else if( rval < 666 )
	{
		nums[nums.size] = 4;
		nums[nums.size] = 1;
		nums[nums.size] = 2;
		nums[nums.size] = 3;
	}
	else
	{
		nums[nums.size] = 3;
		nums[nums.size] = 2;
		nums[nums.size] = 1;
		nums[nums.size] = 4;
	}
	
	for( i=0; i<nums.size; i++ )
	{
		choice = nums[ i ];

		if( choice == 1 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass1_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass1_node4";
			level thread stealth_search_for_player( 0.01, "find_player_in_grass1_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
		else if (choice == 2 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass2_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass2_node4";
			level thread stealth_search_for_player( 2, "find_player_in_grass2_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
		else if (choice == 3 )
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass3_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass3_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass3_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass3_node4";
			level thread stealth_search_for_player( 7, "find_player_in_grass3_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
		else
		{
			a_nodes = [];
			a_nodes[a_nodes.size] = "find_player_in_grass4_node1";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node2";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node3";
			a_nodes[a_nodes.size] = "find_player_in_grass4_node4";
			level thread stealth_search_for_player( 12, "find_player_in_grass4_spawner", view_dot, vis_dist, a_nodes, 2 );
		}
	}
}


//*****************************************************************************
//*****************************************************************************

stealth_search_for_player( delay, str_spawnername, view_dot, vis_dist, a_nodes, fail_delay_time )
{
	if( IsDefined(delay) & (delay > 0)  )
	{
		wait( delay );
	}

	e_spawner = getent( str_spawnername, "targetname" );
	e_ai = simple_spawn_single( e_spawner );

	e_ai.ignoreall = true;
	e_ai.script_ignore_suppression = 1;
	e_ai.dontmelee = true;
	e_ai change_movemode( "cqb_walk" );
	e_ai.moveplaybackrate = 0.3;

	e_ai thread fail_mission_if_player_visible( view_dot, vis_dist, fail_delay_time );
	
	for( i=0; i<a_nodes.size; i++ )
	{
		n_node = getnode( a_nodes[i], "targetname" );
		e_ai SetGoalNode( n_node );
		e_ai.goalradius = 64;
		e_ai waittill( "goal" );
	}
	
	e_ai delete();
}

// self = ai
fail_mission_if_player_visible( view_dot, vis_dist, fail_delay_time )
{
	self endon( "death" );

	while( 1 )
	{
		dist = distance( self.origin, level.player.origin );

		v_forward = anglestoforward( self.angles );
		v_dir = vectornormalize( level.player.origin - self.origin );
		dot = vectordot( v_forward, v_dir );

		//IPrintLnBold( "DIST: " + dist, "  DOT: " + dot );

		if( (dist < vis_dist) && (dot > view_dot) )
		{
			// If the AI is behind the player it, skip it
			v_forward = anglestoforward( level.player.angles );
			v_dir = vectornormalize( self.origin - level.player.origin );
			dot = vectordot( v_forward, v_dir );
			if( dot > 0.2 )
			{
				self.favoriteenemy = level.player;
				self thread aim_at_target( level.player );
				self thread shoot_at_target( level.player, undefined, 0.2, fail_delay_time+1 );
				wait( fail_delay_time );
				missionfailedwrapper( &"ANGOLA_2_PLAYER_COVER_BROKEN_SPOTTED" );
			}
			else
			{
				//IPrintLnBold( "AI SAFETY DOT" );
			}
		}
		wait( 0.01 );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

hudson_drops_off_woods_and_hudson_at_village_enterance()
{
	flag_wait( "js_mason_in_position_in_woods_drop_off_area" );

	wait( 0.25 );
	
	kill_player_carry();
	wait( 0.01 );

	//IPrintLnBold( "END OF PLAYER CARRY" );

	run_scene( "j_stealth_player_puts_down_woods" );
	level thread run_scene( "j_stealth_hudson_woods_sit_down_loop" );

	// Give the player his weapons back
	level.player notify( "give_back_weapons" );

	// Swap to the primary weapon
	wait( 0.1 );

	// The player lost the rocket launcher on the boat
	// Make sure they have a good machine gun for the jungle escape battle
	if( !IsDefined(level.angola2_skipto) )
	{
		primary_weapons = level.player GetWeaponsListPrimaries();
		if( !IsDefined(primary_weapons) || (primary_weapons.size < 2) )
		{
			level.player GiveWeapon( "m16_sp" );
			level.player SwitchToWeapon( "m16_sp" );
		}
	}
	
	// End of Section
	flag_set( "js_mason_ready_to_enter_village" );
}

