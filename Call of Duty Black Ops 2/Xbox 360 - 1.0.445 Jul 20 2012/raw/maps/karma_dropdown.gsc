#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_glasses;
#include maps\_objectives;
#include maps\_scene;
#include maps\karma_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
init_flags()
{
	flag_init( "setup_spiderbot" );		// set by trigger
	flag_init( "ambush_attack" );
	flag_init( "dropdown_end" );
	flag_init( "harper_goto_vent" );	// set by trigger
	flag_init( "dropdown_elevator_open" );
	flag_init( "dropdown_early_exit" );
}

init_spawn_funcs()
{
	add_global_spawn_function( "axis", ::change_movemode, "cqb_run" );
	add_spawn_function_group( "dropdown_patrol", "targetname", ::ambush_guy_think );
}

/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_dropdown()
{
	/#
		IPrintLn( "elevator_1" );
	#/
	
	level.ai_salazar		= init_hero( "salazar_pistol" );
	
	// Put the elevator in place
	bm_lift_left = setup_elevator( "tower_lift_left", "tower_elevator_1", "cleanup_dropdown" );
	s_dest = GetStruct( "tower_lift_left_bottom", "targetname" );
		
	flag_set( "elevator_reached_construction" );

	wait( 0.05 );	// let the elevators get setup
	bm_lift_left.origin = s_dest.origin;
	flag_set( "dropdown_elevator_open" );
	
	skipto_teleport( "skipto_dropdown" );	
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
main()
{
	maps\karma_anim::dropdown_anims();
	level thread dropdown_objectives();
	
	//Disable color triggers for use during construction battle after the CRC room
	trigger_off( "construction_battle_color_triggers", "script_noteworthy" );

	SetSavedDvar( "g_speed", level.default_run_speed );
	flag_set( "player_act_normally" );

	// Teleport Salazar behind you
	level.ai_salazar thread ally_dropdown_think( GetNode( "salazar_dropdown_goal", "targetname" ) );

	a_dropdown_elevator_doors = GetEntArray( "construction_elevator_door", "targetname" );
	
	foreach( e_door in a_dropdown_elevator_doors )
	{
		e_door NotSolid();
		e_door ConnectPaths();
		e_door Delete();
	}
	flag_wait( "dropdown_elevator_open" );
	
	// Open the elevator door
	CONST n_door_move_time = 1.0;
	CONST n_door_move_accel = 0.2;
	CONST n_door_move_decel = 0.5;
	
	bm_lift_left = GetEnt( "tower_lift_left",  "targetname" );
	bm_lift_left  thread elevator_move_doors( true, n_door_move_time, n_door_move_accel, n_door_move_decel );

	level thread run_scene_and_delete( "tower_elevator_open" );
	level thread run_scene_and_delete( "elevator_encounter1" );
	level thread run_scene_and_delete( "elevator_encounter2" );
	
	clientnotify ("construction_line");
	flag_wait_or_timeout( "dropdown_early_exit", 3.0 );
	
	if( flag( "dropdown_early_exit" ) )
	{
		end_scene( "elevator_encounter1" );
		end_scene( "elevator_encounter2" );
	}
	
	flag_set( "draw_weapons" );
	scene_wait( "elevator_encounter1" );
	wait 1.0;
	
	if( !flag( "elevator_encounter2_done" ) )
	{
		end_scene( "elevator_encounter2" );
	}
	
	flag_set( "ambush_attack" );

	// Kill them all
	waittill_ai_group_ai_count( "dropdown_patrol", 0 );

	level thread farid_comm();
   	level.ai_salazar thread salazar_vent_wait();

   	flag_wait( "salazar_wait_vent_spiderbot_started" );

	bm_lift_left thread elevator_move_doors( false, n_door_move_time, n_door_move_accel, n_door_move_decel );
	level thread run_scene_and_delete( "tower_elevator_close" );

	trigger_wait( "t_setup_spiderbot" );

	flag_set( "setup_spiderbot" );

	//SOUND - Shawn J
	level.player playsound ("evt_spiderbot_intro");	

//	thread play_movie("spider_bootup", false, false, undefined, false, "bootup_done" );
	cin_id = play_movie_on_surface_async( "spider_bootup", true, false );
	
	run_scene_and_delete( "set_spiderbot" );
	end_scene( "salazar_wait_vent_spiderbot" );

	Stop3DCinematic( cin_id );
	
	cleanup_ents( "cleanup_dropdown" );
	
	level thread autosave_now( "karma_spiderbot" );
}

salazar_unholster_sidearm( ent )
{
	level.ai_salazar gun_switchto( "fiveseven_sp", "right" );
}

//
//	Teleport ally behind you and wait for combat
//	self is the ally
ally_dropdown_think( nd_dest )
{
	self change_movemode( "cqb_run" );

	self force_goal( nd_dest, 8, false );
}


//-------------------------------------------------------------------------------------------
// Elevator to front CRC objectives.
//-------------------------------------------------------------------------------------------
dropdown_objectives()
{
//	objective_breadcrumb( level.OBJ_FIND_CRC, "t_dropdown_start" );
	waittill_ai_group_ai_count( "dropdown_patrol", 0 );
	
	set_objective( level.OBJ_FIND_CRC, level.ai_salazar, "follow" );
	flag_wait( "salazar_wait_vent_spiderbot_started" );

	set_objective( level.OBJ_FIND_CRC, GetEnt( "t_setup_spiderbot", "targetname" ), "breadcrumb" );
	flag_wait( "setup_spiderbot" );
	
	set_objective( level.OBJ_FIND_CRC, undefined, "done" );	

	flag_set( "dropdown_end" );	
}


//
//	Notetrack callback function
//	Open the elevator doors
pry_open_doors( ai_callback )
{
//	thread run_scene( "dropdown_exit_elevator_open" );
	thread run_scene_and_delete( "tower_elevator_open" );
	
	e_fake_elevator = GetEnt( "construction_elevator", "targetname" );
	e_fake_elevator thread elevator_move_doors( true, 1.0, 0.5, 0.0, true );
	level clientnotify("audio_line_on"); //notify to turn construction area line emitters on
	level notify ("occlude_off"); //turn off occluded emitter in front of elev
}

//
//
ambush_guy_think()
{
	self disable_react();
	self force_goal( GetNode( self.target, "targetname" ), 8, false );
}

//
//	Hang around for a bit and then delete
//	self is salazar
salazar_vent_wait()
{
	//TODO TEMP HAX until we can kill scene threads properly
	s_align = GetStruct( "align_spiderbot_gear", "targetname" );
	self set_goalradius( 8 );
	self SetGoalPos( GetStartOrigin( s_align.origin, s_align.angles, %generic_human::ch_karma_4_1_hotel_room_enter_harper ), GetStartAngles( s_align.origin, s_align.angles, %generic_human::ch_karma_4_1_hotel_room_enter_harper ) );
	self waittill( "goal" );	
	flag_wait( "salazar_goto_vent" );

	// salazar waits outside the spiderbot setup room
	run_scene_and_delete( "salazar_go_inside_spiderbot" );

	// salazar waits for us to get in place
	run_scene_and_delete( "salazar_wait_vent_spiderbot" );
	
	level.ai_salazar thread run_scene_and_delete( "salazar_wait" );
	flag_wait( "near_bombs" );
	
	end_scene( "salazar_wait" );
	delete_hero( level.ai_salazar );
}

/////////////////////////////////////////////////////////////////////
//	D I A L O G
/////////////////////////////////////////////////////////////////////

farid_comm()
{
	level.player say_dialog( "fari_section_i_m_in_0", 1.0 );		//Section.  I'm in.
	level.player say_dialog( "sect_go_ahead_1", 0.5 );				//Go ahead.
	level.player say_dialog( "fari_al_jinan_recently_em_0", 0.5 );	//Colossus recently employed Private Military Contractors to augment its regular security team - all ex-Cuban militia.
	level.player say_dialog( "sect_no_shit_we_just_r_0", 0.5 );		//No shit.   We just ran into some of them.
	level.player say_dialog( "sect_they_re_working_for_0");			//Watch for anything suspicious - we need to know their objective.
}
