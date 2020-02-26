
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "event7_complete" );
}


//
//	Need an AI to run something when spawned?  Put it here.
init_spawn_funcs()
{
//    add_spawn_function( "intro_drone", ::intro_drone );
}


/* ------------------------------------------------------------------------------------------
	SKIPTO functions
-------------------------------------------------------------------------------------------*/
skipto_exit_club()
{
//	init_hero( "hero_name_here" );

	// Harper progresses from Event 6 into Event 7, the rest of the hero's need to be created
	level.ai_harper = init_hero_startstruct( "harper", "e7_harper_start" );

	start_teleport( "skipto_exit_club" );
}


/* ------------------------------------------------------------------------------------------
//	MAIN functions	
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
-------------------------------------------------------------------------------------------*/
main()
{
	// Temp Development info
	/#
		IPrintLn( "Exit Club" );
	#/
	
	level thread maps\createart\karma_art::karma_fog_sunset();

	// Initialization
	spawn_funcs();
	maps\karma_2_anim::event_07_anims();

	//***************************
	// Player Progression Cleanup
	//***************************

	level.player.ignoreme = false;


	//***************************
	//***************************


	level.ai_karma = undefined;
	level.ai_defalco = undefined;


	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************

	level.ai_salazar = init_hero_startstruct( "salazar", "e7_salazar_start" );
	level.ai_han = init_hero_startstruct( "han", "e7_han_start" );
	level.ai_redshirt1 = init_hero_startstruct( "redshirt1", "e7_redshirt1_start" );
	level.ai_redshirt2 = init_hero_startstruct( "redshirt2", "e7_redshirt2_start" );

	level.ai_han set_force_color( "r" );
	level.ai_redshirt1 set_force_color( "r" );
	level.ai_redshirt2 set_force_color( "r" );

	level.ai_harper set_force_color( "g" );
	level.ai_salazar set_force_color( "g" );


	//****************************
	// Setup the Aniated Sequences
	//****************************
	
	flag_wait( "karma_gump_exit_club_mall" );

	// Spawn the AI based on the which of the two enterances the player uses to enter event 9
	level thread e7_wave_spawning();

	// Objectives
	level thread exit_club_objectives();
	
	// Perks
	level thread intruder_perk();	

	// Wait for Event 7 to Complete
	// Exiting this function automatically calls the main() function in the next event
	// This linking process is setup by the SkipTo system
	
	flag_wait( "event7_complete" );


	//*************************************
	// Misc Cleanup at the end of the event
	//*************************************
	
	event7_cleanup();
}


//*****************************************************************************
// Ai Waves and Animations
//*****************************************************************************

e7_wave_spawning()
{
	//****************************************************
	// Wave - Guys animated in the Makeshift Hospital Room
	//****************************************************

	level thread doctor_and_nurse_anim( 0.1, "e7_cleanup_1_trigger" );
	level thread wounded_group1_anim( 0.1, "e7_cleanup_1_trigger" );
	level thread wounded_group2_anim( 0.1, "e7_cleanup_2_trigger" );


	//*****************************************
	// Wave - Guys animated in the Titanic Room
	//*****************************************

	level thread group4_civs_at_window_anim( 0.1  );			// 0.1
	level thread couple_approach_window_anim( 2.0 );			// 0.1
	level thread single_civ_approach_window_anim( 3.5 );		// 0.1
	
	
	//*****************************************
	// Titanic Event Animations
	//*****************************************
	
	level thread titanic_event_animations( 4 );
	
	
	//*****************************************
	//*****************************************
	
	level thread e7_pip_defalco_in_mall();


	//****************************************************************
	// Door stops player er-entering the area once they enter the mall
	//****************************************************************
	
	door_blocks_player_from_revisiting_event7();
}


//*****************************************************************************
//
//*****************************************************************************

doctor_and_nurse_anim( delay, str_kill_ai_trigger )
{
	str_scene_name = "scene_e7_doctor_and_nurse_loop";

	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold(( "Staring Doctor and Nurse Anim" );

	level thread run_scene_and_delete( str_scene_name );
	
	if( IsDefined(str_kill_ai_trigger) )
	{
		e_trigger = GetEnt( str_kill_ai_trigger, "targetname" );
		e_trigger waittill( "trigger" );

		//IPrintLnBold( "REMOVING - Doctor and Nurse Anim" );
	
		a_ents = [];
		a_ents[ a_ents.size ] = GetEnt( "e7_doctor_ai", "targetname" );
		a_ents[ a_ents.size ] = GetEnt( "e7_nurse_ai", "targetname" );

		kill_scene_and_ents_after_time( str_scene_name, 0.1, a_ents );
	}
}


//*****************************************************************************
//
//*****************************************************************************

wounded_group1_anim( delay, str_kill_ai_trigger )
{
	str_scene_name = "scene_e7_wounded_group1";

	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring Wounded Group1 Anim" );

	level thread run_scene_and_delete( str_scene_name );
	
	if( IsDefined(str_kill_ai_trigger) )
	{
		e_trigger = GetEnt( str_kill_ai_trigger, "targetname" );
		e_trigger waittill( "trigger" );

		//IPrintLnBold( "REMOVING - Wounded Group 1" );
		
		end_scene( str_scene_name );
	}
}


//*****************************************************************************
//
//*****************************************************************************

wounded_group2_anim( delay, str_kill_ai_trigger )
{
	str_scene_name = "scene_e7_wounded_group2";

	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring Wounded Group2 Anim" );

	level thread run_scene_and_delete( str_scene_name );
	
	if( IsDefined(str_kill_ai_trigger) )
	{
		e_trigger = GetEnt( str_kill_ai_trigger, "targetname" );
		e_trigger waittill( "trigger" );

		//IPrintLnBold( "REMOVING - Wounded Group 2" );

		end_scene( str_scene_name );
	}
}


//*****************************************************************************
//
//*****************************************************************************

group4_civs_at_window_anim( delay )
{
	str_scene_name = "scene_e7_civs_at_window_loop";

	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring 4 Civ Groups Anim" );

	level thread run_scene_and_delete( str_scene_name );
	
	// Wait for blocking door
	level waittill( "event7_blocked_off" );
	
	//IPrintLnBold( "REMOVING - Group4 Civs at Window" );

	// Helps stop hitches
	wait( 0.6 );
	end_scene( str_scene_name );
}


//*****************************************************************************
//
//*****************************************************************************

couple_approach_window_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring Couple Approaches Window Anim" );

	run_scene_and_delete( "scene_e7_couple_approach_window_part1" );
	
	str_scene_name = "scene_e7_couple_approach_window_part2_loop";
	level thread run_scene_and_delete( str_scene_name );

	// Wait for blocking door
	level waittill( "event7_blocked_off" );
	
	//IPrintLnBold( "REMOVING - Couple Window Approach" );

	a_ents = [];
	a_ents[ a_ents.size ] = GetEnt( "e7_civ1_watch_escape_ai", "targetname" );
	a_ents[ a_ents.size ] = GetEnt( "e7_civ2_watch_escape_ai", "targetname" );
		
	kill_scene_and_ents_after_time( str_scene_name, 0.1, a_ents );
}


//*****************************************************************************
//
//*****************************************************************************

single_civ_approach_window_anim( delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring Single Civilian Approaching Window Anim" );

	run_scene_and_delete( "scene_e7_single_approach_window_part1" );
	
	str_scene_name = "scene_e7_single_approach_window_part2_loop";
	level thread run_scene_and_delete( str_scene_name );
	
	// Wait for blocking door
	level waittill( "event7_blocked_off" );

	
	//IPrintLnBold( "REMOVING - Single Civ Approach Window" );

	a_ents = [];
	a_ents[ a_ents.size ] = GetEnt( "e7_civ_approach_window_ai", "targetname" );
		
	kill_scene_and_ents_after_time( str_scene_name, 0.1, a_ents );
}


//*****************************************************************************
//
//*****************************************************************************

exit_club_objectives()
{
	wait( 0.01 );
	
	t_trigger = getent( "trigger_end_event7", "targetname" );
	str_struct_name = t_trigger.target;
	s_struct = getstruct( str_struct_name, "targetname" );
	
	set_objective( level.OBJECTIVE_EVENT_7_1, s_struct, "" );
	t_trigger waittill( "trigger" );
	
	set_objective( level.OBJECTIVE_EVENT_7_1, undefined, "delete" );

	// Progress to Event 8
	autosave_by_name( "karma_exit_club" );
	wait( 0.1 );
	flag_set( "event7_complete" );
}


//*****************************************************************************
// Misc cleanup at the end of the Event
//*****************************************************************************

event7_cleanup()
{
	level notify( "kill_anims_e7_part1" );
}


//*****************************************************************************
//
//*****************************************************************************

//Need an AI to run something when spawned?  Put it here.
spawn_funcs()
{
//	add_spawn_function_veh( "intro_drone", ::intro_drone );
}


//*****************************************************************************
//-----------------------------------SPECIALTY PERK----------------------------
//*****************************************************************************

intruder_perk()
{	
	if( !level.player HasPerk( "specialty_intruder" ) )
	{
		return;
	}

	s_intruder_us_pos = getstruct( "intruder_use_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_us_pos.origin, "interact" );	
	
	s_intruder_door_open = getstruct( "intruder_perk_door01_struct", "targetname" );
	m_intruder_door01 = GetEnt( "intruder_perk_door01", "targetname" );
	
	trigger_wait( "t_intruder_use" );
	
	run_scene_and_delete( "intruder" );	
	
	m_intruder_door01 moveto( s_intruder_door_open.origin, 1.5 );	
	
	set_objective( level.OBJ_INTERACT, s_intruder_us_pos, "remove" );

	t_intruder_use = GetEnt( "t_intruder_use", "targetname" );
	t_intruder_use Delete();

	s_intruder_door02_open = getstruct( "intruder_perk_door02_struct", "targetname" );
	m_intruder_door02 = GetEnt( "intruder_perk_door02", "targetname" );
	
	trigger_wait( "t_intruder_door02" );
	
	m_intruder_door02 moveto( s_intruder_door02_open.origin, 1.5 );
	
	t_intruder_door02 = GetEnt( "t_intruder_door02", "targetname" );
	t_intruder_door02 Delete();	
}


//*****************************************************************************
//*****************************************************************************

e7_pip_defalco_in_mall()
{
	e_trigger = getent( "e7_pip_defalco_in_mall", "targetname" );
	e_trigger waittill( "trigger" );
	
	time = 6;
	level thread pip_karma_event( 0.01, "e7_defalco_extra_cam_struct", time );
	
	wait( 0.1 );
	
	clientNotify( "fov_zoom_e7_defalco_chase" );

	str_scene_name = "scene_event8_defalco_karma_intro";
	level thread run_scene( str_scene_name );
	
	// Make sure the ents don't get killed in the fire fight
	wait( 0.1 );
	a_ents = get_ais_from_scene( str_scene_name );
	for( i=0; i<a_ents.size; i++ )
	{
		a_ents[i].health = 10000;
	}
	
	wait( time + 1 );
	end_scene( str_scene_name );
}


//*****************************************************************************
//*****************************************************************************

titanic_event_animations( delay )
{
	str_scene1_name = "scene_e7_titanic_moment_docka_loop";
	str_scene2_name = "scene_e7_titanic_moment_dockb_loop";

	if( IsDefined(delay) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Starting Titanic Moment DOCKA and B" );

	level thread run_scene_and_delete( str_scene1_name );
	level thread run_scene_and_delete( str_scene2_name );
	
	// Wait for the blocking door to close
	level waittill( "event7_blocked_off" );
	
	//IPrintLnBold( "REMOVING - Titanic Moment DOCKA and B" );
		
	wait( 0.5 );	// Helps stop hitches
	end_scene( str_scene1_name );
	wait( 0.5 );	// Helps stop hitches
	end_scene( str_scene2_name );
}


//*****************************************************************************
// Close a door that stops the player re-entering Event 7
//*****************************************************************************

door_blocks_player_from_revisiting_event7()
{
	e_trigger = GetEnt( "e7_cleanup_3_trigger", "targetname" );
	e_trigger waittill( "trigger" );

	//IPrintLnBold( "Closing door to Event 7" );
	
	wait( 5 );

	e_door = getent( "e7_exit_door_blocker", "targetname" );
	
	dir = anglestoup( e_door.angles );
	v_destination_pos = e_door.origin - (dir*(42*3) );
	time = 2;
	e_door moveto( v_destination_pos, time, 0.5, 0.5 );
	
	level notify( "event7_blocked_off" );
}


