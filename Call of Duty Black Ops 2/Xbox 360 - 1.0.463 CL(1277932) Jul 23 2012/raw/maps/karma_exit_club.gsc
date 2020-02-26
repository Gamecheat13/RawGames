
#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_anim;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "pip_defalco_in_mall_flag" );
	flag_init( "player_resume_sprint" );
	flag_init( "intro_explosion_dialog" );
	flag_init( "e7_armory_vo_triggered" );
	flag_init( "e7_armory_opened_vo_triggered" );
	flag_init( "event7_complete" );
	flag_init( "exit_club_cleanup" );
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

	skipto_teleport( "skipto_exit_club" );
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
	
	karma2_hide_tower_and_shell();
	
	// Initialization
	spawn_funcs();
	maps\karma_2_anim::exit_club_anims();
	//maps\karma_2_anim::death_poses();

	//***************************
	// Player Progression Cleanup
	//***************************

	level.player.ignoreme = false;
	//setsaveddvar("g_speed", 110);
	//level.player AllowSprint( false );

	//***************************
	//***************************


	level.ai_karma = undefined;
	level.ai_defalco = undefined;


	//*******************************
	// Setup the Hero AI Color Groups
	//*******************************

	level.ai_salazar = init_hero_startstruct( "salazar", "e7_salazar_start" );


	
	//********************
	// Kick off the dialog
	//********************

	//level thread exit_club_dialog();
	level thread maps\karma_enter_mall::e8_enter_mall_vo();

	//****************************
	// Setup the Aniated Sequences
	//****************************
	
	flag_wait( "karma_2_gump_mall" );
	level notify("start_rescue_karma_timer");
	
	level thread maps\createart\karma_2_art::vision_set_change( "sp_karma2_clubexit" );
	// Spawn the AI based on the which of the two enterances the player uses to enter event 9
	level thread intro_explosion_aftermath();
	level thread e7_wave_spawning();
	level thread exit_club_deathposes();
	// Objectives
	level thread exit_club_objectives();
	
	// Perks
	level thread intruder_perk();	

	// Wait for Event 7 to Complete
	// Exiting this function automatically calls the main() function in the next event
	// This linking process is setup by the SkipTo system
	
	level thread exit_club_clean_up();
	
	flag_wait( "event7_complete" );


	//*************************************
	// Misc Cleanup at the end of the event
	//*************************************
	
	event7_cleanup();
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
	
	set_objective( level.OBJECTIVE_EVENT_7_1, undefined, "done" );

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
	delete_scene("intro_explosion_aftermath");
	
	level notify( "kill_anims_e7_part1" );
	level notify( "e7_complete" );
}

exit_club_clean_up()
{
	e_trigger = GetEnt("clean_up_exit_club", "targetname");
	bm_clip = GetEnt( "mall_door_block", "targetname" );
	bm_clip trigger_off();
	bm_clip NotSolid();
	bm_clip ConnectPaths();
	
	e_trigger waittill("trigger");
	
	mall_entry_door_l = GetEnt("mall_entry_door_l", "targetname");
	mall_entry_door_r = GetEnt("mall_entry_door_r", "targetname");
	
	
	mall_entry_door_l RotateYaw ( 130, 0.7, 0.5, 0.2 );
	mall_entry_door_r RotateYaw ( -130, 0.7, 0.5, 0.2 );
	bm_clip trigger_on();
	bm_clip Solid();
	//bm_clip ConnectPaths();
	
    level notify ("exit_club_cleanup");
    stop_exploder( 721 );
   
	
}

//*****************************************************************************
// Ai Waves and Animations
//*****************************************************************************

intro_explosion_aftermath()
{
	level endon ("exit_club_cleanup");
	
	wait( 0.01 );
	level thread screen_fade_in(2);
	run_scene( "intro_explosion_aftermath" );
	
	wait( 1 );
	level.ai_harper = get_ais_from_scene( "intro_explosion_aftermath", "harper" );
	level.ai_salazar = get_ais_from_scene( "intro_explosion_aftermath", "salazar" );
	a_ai = get_ais_from_scene( "intro_explosion_aftermath", "han" );
	
	scene_wait( "intro_explosion_aftermath" );
	flag_set( "intro_explosion_dialog" );
	
	level.ai_harper post_intro_position( 0 , "harper_exit_club_node" );
	level.ai_salazar post_intro_position( 0 , "salazar_exit_club_node" );
	a_ai post_intro_position( 0 , "security_guard_node" );

//	flag_wait( "player_resume_sprint" );
//	SetSavedDvar( "g_speed", level.default_run_speed );
//	level.player AllowSprint( true );
	
	level.ai_harper set_force_color( "g" );
	level.ai_salazar set_force_color( "g" );
	
}

post_intro_position( delay, node )
{
	wait( delay );

	nd_target = getnode( node, "targetname" );
	self.goalradius = 48;
	self setgoalnode( nd_target );
}

exit_club_deathposes()
{
	level endon ("exit_club_cleanup");
	
	run_scene_first_frame( "deathpose1" );
	run_scene_first_frame( "deathpose2" );
	run_scene_first_frame( "deathpose3" );
	run_scene_first_frame( "deathpose4" );
	run_scene_first_frame( "deathpose5" );
	run_scene_first_frame( "deathpose6" );
	run_scene_first_frame( "deathpose7" );
	run_scene_first_frame( "deathpose8" );
	run_scene_first_frame( "deathpose9" );
	run_scene_first_frame( "deathpose10" );
	run_scene_first_frame( "deathpose11" );
	
}

e7_wave_spawning()
{
	
//	level endon ("exit_club_cleanup");
	//*******************************************
	// Wounded civs running out of club into mall
	//*******************************************

	//level thread wounded_civs_exit_club_then_use_pathnodes( undefined );
	level thread scene_e7_couple_run_to_titanic_area_anim( undefined );
	

	//*************************************************
	// Civs running from the Mall into the titanic area
	//*************************************************

	level thread scene_e7_couple_a_run_from_mall_to_titanic_anim( 0.3 );
	level thread scene_e7_couple_b_run_from_mall_to_titanic_anim( 0.3 );
	//level thread civs_escape_into_mall_then_use_pathnodes( 0.3 );

	
	//****************************************************
	// Wave - Guys animated in the Makeshift Hospital Room
	//****************************************************

	level thread doctor_and_nurse_anim( 0.1, "clean_up_exit_club" );
	level thread wounded_group1_anim( 0.1, "clean_up_exit_club" );
	level thread wounded_group2_anim( 0.1, "clean_up_exit_club" );


	//*****************************************
	// Wave - Guys animated in the Titanic Room
	//*****************************************

//	level thread group4_civs_at_window_anim( 0.1  );			// 0.1
	level thread couple_approach_window_anim( 2.0 );			// 0.1
	level thread single_civ_approach_window_anim( 3.5 );		// 0.1
	
	
	//*****************************************
	// Titanic Event Animations
	//*****************************************
	 
	level thread titanic_event_animations( 4 );
	level thread titanic_event_shrimp();
	//level thread titanic_event_boat();
	//level thread boat_test();
	
	//*****************************************
	//*****************************************
	
	level thread e7_pip_defalco_in_mall();
	
	level thread e8_flanking_helicopters( 0.5 );


	//****************************************************************
	// Door stops player er-entering the area once they enter the mall
	//****************************************************************
	
	door_blocks_player_from_revisiting_event7();
}


//*****************************************************************************
//
//*****************************************************************************

scene_e7_couple_run_to_titanic_area_anim( delay )
{
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring couple_run_to_titanic_area Anim" );

	run_scene_and_delete( "scene_e7_couple_run_to_titanic_area" );
	
	str_scene_name = "scene_e7_couple_run_to_titanic_area_loop";
	level thread run_scene( str_scene_name );

	// Wait for blocking door
	level waittill( "exit_club_cleanup" );
	
	//IPrintLnBold( "REMOVING - scene_e7_couple_run_to_titanic_area" );

	delete_scene( str_scene_name );
}


//*****************************************************************************
// 
//*****************************************************************************

scene_e7_couple_a_run_from_mall_to_titanic_anim( delay )
{
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring scene_e7_couple_a_run_from_mall_to_titanic Anim" );

	run_scene_and_delete( "scene_e7_couple_a_run_from_mall_to_titanic" );
	
	str_scene_name = "scene_e7_couple_a_run_from_mall_to_titanic_loop";
	level thread run_scene( str_scene_name );

	// Wait for blocking door
	level waittill( "exit_club_cleanup" );
	
	//IPrintLnBold( "REMOVING - scene_e7_couple_a_run_from_mall_to_titanic" );

	delete_scene( str_scene_name );
}


//*****************************************************************************
// 
//*****************************************************************************

scene_e7_couple_b_run_from_mall_to_titanic_anim( delay )
{
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}

	//IPrintLnBold( "Staring scene_e7_couple_b_run_from_mall_to_titanic Anim" );

	run_scene_and_delete( "scene_e7_couple_b_run_from_mall_to_titanic" );
	
	str_scene_name = "scene_e7_couple_b_run_from_mall_to_titanic_loop";
	level thread run_scene( str_scene_name );

	// Wait for blocking door
	level waittill( "exit_club_cleanup" );
	
	//IPrintLnBold( "REMOVING - scene_e7_couple_b_run_from_mall_to_titanic" );

	delete_scene( str_scene_name );
}


//*****************************************************************************
//
//*****************************************************************************

civs_escape_into_mall_then_use_pathnodes( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	//IPrintLnBold( "Staring Civs Escape into Mall" );
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );
	
	str_scene_name = "scene_e7_civs_escape_into_mall";
	
	level thread run_scene( str_scene_name );
	wait( 1 );
	a_ai = get_ais_from_scene( str_scene_name );
	scene_wait( str_scene_name );
	
	n_node = getnode( "e7_civ_exit_club_path_end", "targetname" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] thread run_to_node_and_die( n_node );
	}
}


//*****************************************************************************
//
//*****************************************************************************

wounded_civs_exit_club_then_use_pathnodes( delay )
{
	if( IsDefined(delay) && (delay > 0) )
	{
		wait( delay );
	}
	
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );
	
	str_scene_name = "scene_e7_wounded_civs_exit_club";
	
	level thread run_scene( str_scene_name );
	wait( 1 );
	a_ai = get_ais_from_scene( str_scene_name );
	scene_wait( str_scene_name );
	
	n_node = getnode( "e7_civ_exit_club_path_end", "targetname" );
	for( i=0; i<a_ai.size; i++ )
	{
		a_ai[i] thread run_to_node_and_die( n_node );
	}
}


//*****************************************************************************
//
//*****************************************************************************

doctor_and_nurse_anim( delay, str_kill_ai_trigger )
{
	str_scene_name = "scene_e7_doctor_and_nurse_loop";

	if( IsDefined(delay) && (delay > 0) )
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
	
		end_scene( str_scene_name );
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
	
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );

	run_scene_and_delete( "scene_e7_couple_approach_window_part1" );
	
	str_scene_name = "scene_e7_couple_approach_window_part2_loop";
	level thread run_scene( str_scene_name );

	// Wait for blocking door
	level waittill( "exit_club_cleanup" );
	
	//IPrintLnBold( "REMOVING - Couple Window Approach" );

	delete_scene( str_scene_name );
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
	
	e_trigger = getent( "intro_run_civs", "targetname" );
	e_trigger waittill( "trigger" );

	run_scene_and_delete( "scene_e7_single_approach_window_part1" );
	
	str_scene_name = "scene_e7_single_approach_window_part2_loop";
	level thread run_scene( str_scene_name );
	
	// Wait for blocking door
	level waittill( "exit_club_cleanup" );

	//IPrintLnBold( "REMOVING - Single Civ Approach Window" );
	
	delete_scene( str_scene_name );
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
//*****************************************************************************

e7_pip_defalco_in_mall()
{
	flag_wait( "pip_defalco_in_mall_flag" );
	
	level thread pip_karma_event( "e7_defalco_extra_cam_struct", "scene_event8_defalco_karma_intro" );
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
	level waittill( "exit_club_cleanup" );
	
	//IPrintLnBold( "REMOVING - Titanic Moment DOCKA and B" );
		
	wait( 0.5 );	// Helps stop hitches
	end_scene( str_scene1_name );
	wait( 0.5 );	// Helps stop hitches
	end_scene( str_scene2_name );
}

titanic_event_shrimp()
{
	level endon ( "exit_club_cleanup" );
	
	e_trigger = GetEnt("exit_club_shrimp", "targetname");
	e_trigger waittill( "trigger" );
	
	while(1)
	{
		
		exploder( 721 );
		wait 5;
	}
}
titanic_event_boat()
{
	level endon ( "exit_club_cleanup" );
	
	e_trigger = GetEnt("exit_club_shrimp", "targetname");
	e_trigger waittill( "trigger" );
	
	level thread setup_boat( "karma_life_boat", "boat_goal");
	level thread setup_boat( "karma_life_boat1", "boat_goal1");
	
	
}

setup_boat(m_boat, nd_goal)
{
	m_boat = getent( m_boat, "targetname" );
	nd_node = getstruct( nd_goal, "targetname");
	nd_node_org = nd_node.origin;
	m_boat moveto( nd_node_org, 4 , 0.5, 0.5 );
	PlayFXOnTag( level._effect["fx_kar_boat_wake1"], m_boat, "tag_origin"  );
	m_boat waittill ("movedone");
        
    m_boat Delete();
}

boat_test()
{
	level endon ( "exit_club_cleanup" );
	
	e_trigger = GetEnt("exit_club_shrimp", "targetname");
	e_trigger waittill( "trigger" );
	
	while( true )
    {
        spawn_lift_boat( "boat", RandomIntRange( 6, 7 ) );
        
        wait RandomIntRange( 2, 4 );

	}
}

//spawn script model boat
spawn_lift_boat( str_drone_pos, n_move_time )
{
	level endon ( "exit_club_cleanup" );
	
    a_drone_pos = GetStructArray( str_drone_pos, "targetname" );
    
    foreach( s_drone_pos in a_drone_pos )
    {
        m_drone = Spawn( "script_model", s_drone_pos.origin );
        m_drone.angles = (0,-90,0);
        
        m_drone SetModel( "p6_boat_small_closed" );
        
        s_drone_target = GetStruct( s_drone_pos.target, "targetname" );
        
        PlayFXOnTag( level._effect["fx_kar_boat_wake1"], m_drone, "tag_origin"  );
        
        m_drone MoveTo( s_drone_target.origin, n_move_time );
        
        m_drone waittill ("movedone");
        
        m_drone Delete();
    }
}

//*****************************************************************************
// Close a door that stops the player re-entering Event 7
//*****************************************************************************

door_blocks_player_from_revisiting_event7()
{
	e_trigger = GetEnt( "trigger_end_event8_1", "targetname" );
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


//*****************************************************************************
//*****************************************************************************

exit_club_dialog()
{
	level endon( "e7_complete" );

	//*************
	// Intro Dialog
	//*************
	flag_wait( "intro_explosion_dialog" );

	level.player say_dialog( "fari_what_happened_0" );				// Farid: What happened?
	level.ai_harper  say_dialog( "harp_defalco_detonated_a_0" );	// Harper: DeFalco detonated a fucking bomb outside the nightclub!  He has the girl.
	level.player say_dialog( "sect_patch_us_into_the_se_0" );		// Mason: Patch us into the security cameras for this deck.
//	level.ai_harper  say_dialog( "harp_these_dumbass_mall_c_0" );	// Harper: These dumbass mall cops don't stand a chance against mercs.
	
	flag_set( "pip_defalco_in_mall_flag" );
	level.player say_dialog( "sect_there_he_s_in_the_0" );			// Mason: There - He's in the Mall!
	level.player say_dialog( "sect_let_s_go_1" );					// Mason: Let's go.
	
	flag_set( "player_resume_sprint" );	
}


//*****************************************************************************
//*****************************************************************************
// SPECIALTY PERK - Intruder for the armery
//*****************************************************************************
//*****************************************************************************

// Note the Intruder can also be known as the lock breaker!!!

intruder_perk()
{
	level endon( "exit_club_cleanup" );

	// Wait for the perk to arrive
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
	
	GetEnt( "t_intruder_use", "targetname" ) SetHintString( &"KARMA_2_PERK" );
	trigger_wait( "t_intruder_use" );
	
	t_intruder_use = GetEnt( "t_intruder_use", "targetname" );
	t_intruder_use Delete();
	
	intruder_blocker_clip = GetEnt( "intruder_blocker_clip", "targetname" );
	intruder_blocker_clip trigger_off();
	
	run_scene( "intruder" );	
	
	scene_wait( "intruder" );
	set_objective( level.OBJ_INTERACT, s_intruder, "remove" );

	level.player GiveWeapon( "fhj18_dpad_sp" );
	level.player SetActionSlot( 3, "weapon", "fhj18_dpad_sp" );
	level.player GiveMaxAmmo( "fhj18_dpad_sp" );
	
	delete_scene( "intruder" );
	
	//level thread intruder_hint();
}

intruder_zap_start( m_cutter ) // notetrack = "zap_start"
{
	m_cutter play_fx( "cutter_spark", undefined, undefined, "stop_fx", true, "tag_fx" );
	//fx_laser_cutter_on
}

intruder_zap_end( m_cutter ) // notetrack = "zap_end"
{
	m_cutter notify( "stop_fx" );
}

intruder_cutter_on( m_cutter ) // notetrack = "start"
{
	m_cutter play_fx( "cutter_on", undefined, undefined, undefined, true, "tag_fx" );
}


intruder_hint()
{
	level endon( "intruder_selected" );
	
	level thread hint_timer( "intruder_selected" );
	screen_message_create( &"KARMA_2_INTRUDER_SELECT" );
	
	while ( !level.player ActionSlotOneButtonPressed() )
	{
		wait .05;
	}
	
	screen_message_delete();
	level notify( "intruder_selected" );

}

hint_timer( str_notify )
{
	level endon( str_notify );
	
	wait 3;
	
	screen_message_delete();
}


//*****************************************************************************
// Helicopter paths in the Titanic room
//*****************************************************************************

e8_flanking_helicopters( delay1 )
{
	e_trigger = getent( "e7_pip_defalco_in_mall", "targetname" );
	e_trigger waittill( "trigger" );

	if( IsDefined(delay1) && (delay1 > 0)) 
	{
		wait( delay1 );
	}
	
//	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( "e7_little_bird_1" );
//	e_heli SetSpeed( 0, 10, 10 );
//	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, "e7_little_bird_1_start", (42*3), true );
//	heli_sound = spawn ("script_origin", e_heli.origin);
//	heli_sound linkto (e_heli);
//	heli_sound PlaySound("evt_club_heli_flyby", "sound_done");
//	level waittill ("sound_done");
//	heli_sound delete();
	
	level thread setup_heli( "e7_little_bird_1", "e7_little_bird_1_start");
	level thread setup_heli( "e7_little_bird_2", "e7_little_bird_2_start");
	level thread setup_heli( "e7_little_bird_3", "e7_little_bird_3_start");
	level thread setup_heli( "e7_little_bird_4", "e7_little_bird_4_start");

}

setup_heli(v_heli_name, nd_heli_node)
{
	e_heli = maps\_vehicle::spawn_vehicle_from_targetname( v_heli_name );
	e_heli SetSpeed( 0, 10, 10 );
	e_heli thread helicopter_fly_down_attack_path( 0, 0, undefined, 15, nd_heli_node, (42*3), true );
	heli_sound = spawn ("script_origin", e_heli.origin);
	heli_sound linkto (e_heli);
	heli_sound PlaySound("evt_club_heli_flyby", "sound_done");
	level waittill ("sound_done");
	heli_sound delete();
}

//*****************************************************************************
//*****************************************************************************

karma2_hide_tower_and_shell()
{
//	e_tower = getent( "tower_hide", "targetname" );
	e_shell = getent( "shell_hide", "targetname" );
//	e_tower hide();
	e_shell hide();
}


//*****************************************************************************
//*****************************************************************************

karma2_show_tower_and_shell()
{
//	e_tower = getent( "tower_hide", "targetname" );
	e_shell = getent( "shell_hide", "targetname" );
//	e_tower show();
	e_shell show();
}



