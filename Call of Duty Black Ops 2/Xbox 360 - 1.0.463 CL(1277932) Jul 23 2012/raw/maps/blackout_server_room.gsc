/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 1/16/2012
 * Time: 11:43 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_objectives;
#include maps\_glasses;
#include maps\_dialog;
#include maps\blackout_anim;

// internal references
#include maps\blackout_util;
#include maps\createart\blackout_art;

#define CLIENT_FLAG_INTRO_EXTRA_CAM 11

// event-specific flags
init_flags()
{
	flag_init( "mason_vent_start" );
	flag_init( "mason_vent_done" );
	flag_init( "mason_server_room_start" );
}

// skipto init functions
skipto_mason_vent()
{
	skipto_setup();
	skipto_teleport_players( "player_skipto_mason_vent" );
	
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "redshirt1_skipto_mason_vent" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "redshirt2_skipto_mason_vent" );
}

skipto_mason_server_room()
{
	flag_set( "mason_vent_done" );
	flag_set( "mason_server_room_start" );
	
	mason_part_2_animations();
	
	skipto_setup();
	skipto_teleport_players("player_skipto_mason_server_room");
	
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "redshirt1_skipto_mason_server_room" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "redshirt2_skipto_mason_server_room" );
	
	level.ai_redshirt1 set_ignoreall ( true );
	level.ai_redshirt2 set_ignoreall ( true );
}

// skipto run functions
run_mason_vent()
{
	mason_part_2_animations();
	
	run_scene_first_frame( "console_chair_karma_sit_loop" );
	
	clean_up_menendez();
	mason_restore_objectives();
	
	// show the CCTV again.
	level.extra_cam_surfaces[ "cctv" ] Show();
	
	vision_set_vent();
	set_player_mason();
	
	if( IsDefined( level.player_weapons ) )
	{
		level.player TakeAllWeapons();
		
		for( i = 0; i < level.player_weapons.size; i++ )
		{
			level.player GiveWeapon( level.player_weapons[i] );
		}
		level.player SwitchToWeapon( level.player_mason_current_weapon );
	
		level.player AllowPickupWeapons( true );
		level.player SetLowReady( false );
	}
	
	flag_set( "mason_vent_start" );
	
	level.ai_redshirt1	= init_hero( "redshirt1", ::redshirt1_vent_think );
	level.ai_redshirt2	= init_hero( "redshirt2", ::redshirt2_vent_think );
	
	level thread run_scene( "cctv_mason_after_loop" );
	
	wait 0.1;
	
	if ( IsDefined( level.rewind_id ) )
	{
		Stop3DCinematic( level.rewind_id );
	}
	
	autosave_by_name( "vent" );
	
	level thread torch_guy_cutting_wall();
	
	origin = getstruct( "cctv_salazar_kill", "targetname" );
	sm_cam_ent = spawn_model( "tag_origin", origin.origin, origin.angles );
	sm_cam_ent SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	level.salazar = init_hero( "salazar" );
	
	level thread run_scene( "salazar_kill_victims" );
	run_scene( "salazar_kill" );
	
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	level.extra_cam_surfaces[ "cctv" ] Hide();
		
	level thread run_scene( "tele_sal" );
	
	level thread run_scene( "salazar_kill_victims_dead" );
	
	level thread run_scene( "cctv_mason_after_exit" );
		
	set_objective( level.OBJ_SERVER );
	level thread run_first_frame_server_room();
	level thread player_kick_grate();
	level thread menendez_pip();
}

vent_quake()
{
	trigger_wait( "vent_quake_trigger" );
	
	Earthquake( 0.3, 2, level.player.origin, 128 );
	
	level.player PlayRumbleLoopOnEntity( 0, "damage_heavy" );
	wait 0.75;
	
	level.player StopRumble( 0, "damage_heavy" );
}

clean_up_menendez()
{
	cctv_trigger = GetEnt( "mason_security_feed_trigger", "targetname" );
	
	if( IsDefined( cctv_trigger ) )
	{
		cctv_trigger Delete();
	}
	
	axis_array = getaiarray("allies");
	array_delete (axis_array);
	
	axis_array = getaiarray("axis");
	array_delete (axis_array);
}

menendez_pip()
{
	wait 5.5;
	
	level thread run_scene( "pip_eye" );
	
	wait 0.25;
	
	level.pip = extra_cam_init( "pip_eye", undefined, 3/4 );
	
	anim_legnth = GetAnimLength( %generic_human::ch_command_04_07_eyeball_rewind_menendez );
	
	wait anim_legnth - 0.75;
	
	turn_off_extra_cam();
	
	exploder( 3000 );
}


// self = redshirt1
redshirt1_vent_think()
{
	self allowedstances ( "crouch" );
	self.pushable = false;
	self set_ignoreall ( true );
	
	nd_redshirt1_vent_node = GetNode ( "redshirt1_vent_node", "targetname" );
	self thread force_goal ( nd_redshirt1_vent_node, 20 );
}

// self = redshirt2
redshirt2_vent_think()
{
	self allowedstances ( "crouch" );
	self.pushable = false;
	self set_ignoreall ( true );
	
	nd_redshirt2_vent_node = getnode ( "redshirt2_vent_node", "targetname" );
	self thread force_goal ( nd_redshirt2_vent_node, 20 );
}

torch_guy_cutting_wall()
{	
	run_scene_first_frame( "torch_wall_panel_first_frame" );
	run_scene_first_frame( "panel_knockdown" );
	
	wall = getent ("crawl_space", "targetname");
	
	wall Hide();
	
	torch_guy = simple_spawn_single( "torch_guy" );
	torch_guy set_ignoreall( true );
	
	torch_guy Attach( "t6_wpn_laser_cutter_prop", "TAG_WEAPON_LEFT" );	
	torch_guy thread welding_fx( "cctv_mason_after_exit" );
	level thread run_scene_and_delete( "torch_wall_loop" );
	
	// TODO:temp wait, need some notetrack
	
	scene_wait( "cctv_mason_after_exit" );
	
	wait 4;	
	
	run_scene( "torch_wall_open" );
	
	level thread run_scene_and_delete( "torch_wall_panel_idle" );
	
	torch_guy Detach( "t6_wpn_laser_cutter_prop", "TAG_WEAPON_LEFT" );
		
	level thread kick_open_wall();
	
	flag_wait( "mason_vent_done");
	torch_guy delete();
}

kick_open_wall()
{
	wall = getent ("crawl_space", "targetname");
	wall NotSolid();
	wall ConnectPaths();
	wall delete();	
}
 
player_kick_grate()
{
	trigger_wait( "player_sit_down_kick" );
	
	level thread run_scene( "panel_knockdown" );
	run_scene( "player_sit_down" );
	
	flag_set( "mason_vent_done" );
}

run_first_frame_server_room()
{
	trigger_wait( "set_up_server_room_trigger" );
	             
	run_scene_first_frame( "console_chair_karma_sit_loop" );
	
	if ( level.is_karma_alive && ! ( level.is_defalco_alive && !level.is_farid_alive ) )
	{
		run_scene_first_frame( "redshirt_01_enter" );
	}
	else
	{
		run_scene_first_frame( "redshirt_01_karma_dead_enter" );
	}
	
	run_scene_first_frame( "redshirt_02_enter" );
	
	level thread defalco_alive_or_not();
	level thread farid_alive_or_not();
	level thread briggs_alive_or_not();
	level thread karma_alive_or_not();
}

run_mason_server_room()
{
	
	trigger_on( "computer_server_use", "targetname" );
	vision_set_mason_serverroom();
	flag_wait( "mason_vent_done");
	flag_set( "mason_server_room_start" );
	
	level.ai_redshirt1 allowedstances ( "stand" );
	level.ai_redshirt2 allowedstances ( "stand" );
	
	set_objective( level.OBJ_SERVER, undefined, "done" );
	
	autosave_by_name( "server_room" );
	
	obj_struct = getstruct( "pip_eye", "targetname" );
	set_objective( level.OBJ_INTERACT, obj_struct.origin, "use" );
		
	level thread computer_server_use();
	level thread harper_alive_or_not();
	
	level aftermath_player();
}

computer_server_use()
{
	computer_server_use = getent ( "computer_server_use", "targetname" );
	computer_server_use SetCursorHint( "HINT_NOICON" );
	computer_server_use SetHintString( &"BLACKOUT_COMPUTER_SERVER_USE" );
	
	trigger_wait ( "computer_server_use" );
	set_objective( level.OBJ_INTERACT, undefined, "done" );
	
	computer_server_use delete();
}

harper_alive_or_not()
{
	if ( level.is_harper_alive )
	{
		flag_wait( "player_loop_started" );
		
		level.harper = init_hero( "harper" );
		
		if ( level.player get_story_stat( "HARPER_SCARRED" ) )
		{
			level.harper SetModel( "c_usa_cia_combat_harper_burned_cin_fb" );
		}
		
		level.harper set_ignoreall( true );
		level.harper set_goalradius( 64 );
		
		level thread aftermath_harper();
		
		level waittill( "start_harper_running" );
		
		run_scene_and_delete( "harper_walk_to_door" );
		
		harper_surrender_start_pos = get_scene_start_pos( "betrayal_surrender_harper", "harper" );
		
		level.harper SetGoalPos( harper_surrender_start_pos );
		level.harper disable_ai_color();
	}
}

defalco_alive_or_not()
{
	if( level.player get_story_stat( "DEFALCO_DEAD_IN_COMMAND_CENTER" ) )
	{
		level.defalco = init_hero( "defalco");
		level thread run_scene_and_delete( "defalco_dead_pose" );
	}
}

farid_alive_or_not()
{
	if(  !level.is_harper_alive  )
	{
		level.defalco = init_hero( "farid");
		level thread run_scene_and_delete( "farid_dead_pose" );
	}
}

briggs_alive_or_not()
{
	
	if ( level.is_briggs_alive )
	{
		level.briggs = init_hero( "briggs");
		level.briggs set_ignoreall( true );
		
		level thread aftermath_briggs();

		scene_wait( "player_sit_down" );
		
		level thread aftermath_redshirt02();		
		
		trigger_wait ( "computer_server_use" );
		
		level thread run_scene_and_delete( "aftermath_briggs_walkoff" );
		level thread run_scene_and_delete( "redshirt_02_walkoff" );           	
	}
	else
	{
		level.briggs = init_hero( "briggs");
		level thread run_scene_and_delete( "briggs_dead_pose" );
		
		scene_wait( "player_sit_down" );
		
		level thread aftermath_redshirt02();		
	}
}

karma_alive_or_not()
{
	if ( level.is_karma_alive && !level.is_harper_alive )
	{
		level.karma = init_hero( "karma" );
		level.karma set_ignoreall( true );
		
		karma_head = spawn_model( "c_usa_chloe_head_bruised_cin" );
		level.karma Detach( "c_usa_chloe_head_cin" );
		level.karma Attach( "c_usa_chloe_head_bruised_cin" );
		
		level thread run_scene_and_delete( "aftermath_karma_injured" );
		
		scene_wait( "player_sit_down" );
		
		level thread aftermath_redshirt1_and_karma_getup();
		
		scene_wait ( "player_exit" );
		
		level thread run_scene_and_delete( "karma_computer" );
		run_scene_and_delete( "redshirt1_guard" );
	}
	else
	{
		if( ! ( level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) ) )
		{
			level thread run_scene_and_delete( "karma_dead_pose" );
		}
		
		scene_wait( "player_sit_down" );
		
		run_scene_and_delete( "redshirt_01_karma_dead_enter" );		

		level thread run_scene_and_delete( "redshirt_01_karma_dead_tableloop" );
		
		scene_wait ( "player_exit" );
		
		run_scene_and_delete( "redshirt_01_karma_dead_table_exit" );	
		level thread run_scene_and_delete( "redshirt_01_karma_dead_loop" );
		
	}
}

aftermath_harper()
{
	run_scene_and_delete( "harper_enter" );
	level thread run_scene_and_delete( "harper_loop" );	
}

aftermath_redshirt1_and_karma_getup()
{
	level endon( "player_exit_done" );
	
	run_scene_and_delete( "redshirt_01_enter" );
	run_scene_and_delete( "karma_get_up" );

	if( !flag( "player_exit_done" ) )
	{
		level thread run_scene_and_delete( "karma_wait");
	}
}

aftermath_redshirt02()
{
	trigger = GetEnt( "computer_server_use", "targetname" );
	trigger endon( "trigger" );
	
	if ( level.is_briggs_alive )
	{
		run_scene_and_delete( "redshirt_02_enter" );
		level thread run_scene_and_delete( "redshirt_02_wait" );
	}
	else
	{
		run_scene_and_delete( "redshirt_02_briggs_dead_enter" );
		run_scene_and_delete( "redshirt_02_briggs_dead_loop" );
	}
}

aftermath_briggs()
{
	trigger = GetEnt( "computer_server_use", "targetname" );
	trigger endon( "trigger" );
	
	run_scene_and_delete( "aftermath_briggs_enter" );
	level thread run_scene_and_delete( "aftermath_briggs_wait" );
}

aftermath_player()
{	
	trigger_wait ( "computer_server_use" );

	level.briggs_loop_aftermath = false;
	level.karma_loop_aftermath = false;	
		
	level thread run_scene_and_delete( "console_chair_player_sit" );
	run_scene_and_delete( "player_sit" );
	
	if( level.is_briggs_alive )
	{
		run_scene_and_delete( "player_sit_briggs_alive" );
	}
	else
	{
		level.briggs_loop_aftermath = true;
	}
	
	run_scene( "player_loop" );
	level.briggs_loop_aftermath = false;
	
		
	if( level.is_harper_alive )
	{
		run_scene_and_delete( "player_harper_alive" );
	}
	
	if( !level.is_harper_alive && ! ( level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) ))
	{
		run_scene_and_delete( "player_karma_alive" );
	}
	else if ( ! ( level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) ) ) 
	{
		level.karma_loop_aftermath = true;
	}
	
	server_room_exit = getent ("server_room_exit", "targetname");
	server_room_exit delete();
	
	level notify( "start_harper_running" );
	
	run_scene_and_delete( "player_loop" );
	//level.karma_loop_aftermath = false;
	
	run_scene_and_delete( "player_exit" );
	
	level.player SetLowReady( true );
	level.player AllowSprint( false );
}
