#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;
#include maps\_glasses;


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "event_54_start" );
	flag_init( "eye_scan_confirm" );
	flag_init( "eye_scan" );	
	flag_init( "close_door" );	
	flag_init( "player_minority_report" );
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
skipto_crc()
{
	level.ai_salazar = init_hero( "salazar" );

	start_teleport( "skipto_crc", array(level.ai_salazar) );
}

/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{
	/#
		IPrintLn( "crc" );
	#/
	
	level thread maps\createart\karma_art::karma_fog_atrium();
	maps\karma_anim::construction_anims();

	level.ai_salazar = init_hero( "salazar" );
	start_teleport( "skipto_crc", array(level.ai_salazar) );

	// Turn off previous triggers so they wont execute events.
	trigger_off( "t_dropdown", "script_noteworthy" );
	
	level thread gulliver_door();

	//-------------------------------------------------------------------------------------------
	// Animation of player putting spiderbot screen away.
	//-------------------------------------------------------------------------------------------
	run_scene( "scene_p_gear_away" );

//	trigger_wait( "t_crc_entrance" );
	
	level thread eye_scan_bink();		
	
	s_obj_crc_door = getstruct( "struct_obj_crc_door" );
	set_objective( level.OBJ_EVENT_5_4, s_obj_crc_door, "" );
	
	trigger_wait( "t_eye_scan_crc" );
	
	// Animation of player walking to scanner and running eye scan to enter CRC room.
	//SOUND - Shawn J
	level.player playsound ("evt_eye_scanner");	
	
	level thread run_scene( "scene_p_eye_scan" );
	level thread player_crc_door();	
	
	wait 1.15;
	
	flag_set( "eye_scan" );
	
	flag_wait( "eye_scan_confirm" );	
	level thread close_crc_door();	
	
	crc_entry_battle();
	
	
	
	// Waits till animation is complete to open door.
	
	set_objective( level.OBJ_ENTER_CRC, undefined, "done" );
	set_objective( level.OBJ_EVENT_5_4, s_obj_crc_door, "done" );
	set_objective( level.OBJ_EVENT_5_4, s_obj_crc_door, "delete" );
	
	s_obj_computer = getstruct( "struct_obj_computer" );
	set_objective( level.OBJ_EVENT_5_5, s_obj_computer, "" );	
	
	// Function for Salazar to do things inside CRC.
	level thread sal_crc_in();
	
	// Function for LobbyShootout Bink shot.
	level thread lobby_shootout();
	
	level thread sal_crc_temp_lines();
	
	trigger_wait( "t_minority_report" );
	
	flag_set( "player_minority_report" );

	thread scene_description();
	
	// Animation of player accessing computer and looking for Karma.
//	load_movie( "default", false, false );
	Start3DCinematic("crc_test_V6", true, false);
	
	run_scene( "scene_p_comp_karma" );	
	
	set_objective( level.OBJ_EVENT_5_5, s_obj_computer, "done" );
	set_objective( level.OBJ_EVENT_5_5, s_obj_computer, "delete" );
	
	Stop3DCinematic();	
	
	// Ends that animation of Salazar accessing another computer.
	end_scene( "scene_sal_loop_comp" );		
	
	flag_set( "event_54_start" );
}

eye_scan_bink()
{
	flag_wait( "eye_scan" );
	
	//SOUND - Shawn J
	//level.player playsound ("evt_eye_scan");	
	
	level thread trespasser_perk();	

	level thread play_bink_on_hud_glasses_karma("eye_scan");
	
	wait(4);

	flag_set( "eye_scan_confirm" );	
//	Stop3DCinematic();	
//
//	scan_eyes_hud Destroy();
}

// CRC door opening and closing function.
player_crc_door()
{
	s_door_open = GetStruct( "crc_door_open", "targetname" );
	s_door_close = GetStruct( "crc_door_close", "targetname" );	
	m_crc_door = GetEnt( "crc_door", "targetname" );
	
	flag_wait( "eye_scan_confirm" );
	
	m_crc_door moveto( s_door_open.origin, 1.5 );
	
	m_crc_door connectpaths();
	
	flag_wait( "close_door" );
	
	m_crc_door moveto( s_door_close.origin, 1.5 );
	
	m_crc_door disconnectpaths();	
}

// Salazar doing things inside CRC.
sal_crc_in()
{
	level endon( "player_minority_report" );

	level.ai_salazar change_movemode( "cqb_sprint" );
	level.ai_salazar.goalradius = 8;
	
	nd_sal_comp = GetNode( "nd_sal_computer", "targetname" );
	level.ai_salazar SetGoalNode( nd_sal_comp );
	level.ai_salazar waittill( "goal" );
	
	run_scene( "scene_sal_intro_comp" );
	
	// Animation of Salazar looking through another computer for bad guys.
	level thread run_scene( "scene_sal_loop_comp" );
//	dialog here?
//	flag_set( "sal_hurry_up" );	
}

// Makes sure door closes after entering CRC room.
close_crc_door()
{
	trigger_wait( "t_event_55_start" );
	
	flag_set( "close_door" );
}

sal_crc_temp_lines()
{
	wait 5;
	
	IPrintLn( "Sal Audio:  Find Karma.  I'll use the other terminal and see what I can come up with." );
	
	flag_wait( "player_minority_report" );
	
	//SOUND - Shawn J
	level.player playsound ("evt_ui_wall");	
	
	wait 20;
	
	IPrintLn( "Sal Audio:  Shit, we got company.  They must know that we're looking for Karma." );
	
	wait 7;
	
	IPrintLn( "Sal Audio:  Harper, get to Karma.  She is at Club Solar." );	
}

// Temporary scene description of what player is seeing while accessing computer main frame.
scene_description()
{
	IPrintLn( "Player boots up main computer and starts to type in Karma in search field.  No Match...types other words." );
	
	wait 8;
	
	IPrintLn( "Player gets a match of Karma.  Tattoo match." );
	
	wait 3;
	
	IPrintLn( "Player goes through some footage and identifies who Karma is.  One of the footage sees Karma stepping into elevator while Player is walking out.  Finds her location" );	
	
	wait 11;
	
	IPrintLn( "A video surveillance footage pops up in player's screen of security guards with body armor killing Al-Jinan guards." );
	
}

gulliver_door()
{
	s_gulliver_open = getstruct( "gulliver_door_open", "targetname" );
	m_gulliver_door = GetEnt( "gulliver_door", "targetname" );
	
	trigger_wait( "t_gulliver_door" );
	
	m_gulliver_door moveto( s_gulliver_open.origin, 1.5 );
}

// Lobby shootout BINK
lobby_shootout()
{
	s_e3_left_open = getstruct( "e3_left_side_open", "targetname" );
	s_e3_right_open = getstruct( "e3_right_side_open", "targetname" );
	s_e3_left_close = getstruct( "e3_left_side_close", "targetname" );
	s_e3_right_close = getstruct( "e3_right_side_close", "targetname" );	
	e_e3_left_door = GetEnt( "e3_left_side", "targetname" );
	e_e3_right_door = GetEnt( "e3_right_side", "targetname" );		
	
	flag_wait( "player_minority_report" );	
	
	wait 14;
	
	e_e3_left_door moveto( s_e3_left_open.origin, 1.5 );
	e_e3_right_door moveto( s_e3_right_open.origin, 1.5 );	
	
	wait 1.5;
	
	run_scene( "scene_lobby_shootout" );
	
	e_e3_left_door moveto( s_e3_left_close.origin, 1.5 );	
	e_e3_right_door moveto( s_e3_right_close.origin, 1.5 );	
}

//blocking call, start the crc_battle
crc_entry_battle()
{
	level.a_crc_enemy_guard = [];
	e_entry_guard = simple_spawn_single("crc_intro_guard");
	level.a_crc_enemy_guard[level.a_crc_enemy_guard.size] = e_entry_guard;
	
	e_entry_guard thread crc_entry_guard_battle();
	crc_inside_guard_battle();
	//trigger_wait("start_crc_battle_trigger");
	
	while(1)
	{
		if(level.a_crc_enemy_guard.size == 0)
		{
			break;
		}
		else
		{
			level.a_crc_enemy_guard = array_removedead(level.a_crc_enemy_guard);
		}
		
		wait(0.5);	
	}
	
}

crc_inside_guard_battle()
{
   trigger_wait("start_crc_battle_trigger");
   a_crc_internal_guards = simple_spawn("crc_guard_group_1");
   
   for(i = 0; i < a_crc_internal_guards.size; i++)
   {
   		a_crc_internal_guards[i].fixednode = true;
   	    level.a_crc_enemy_guard[level.a_crc_enemy_guard.size] = a_crc_internal_guards[i];
   }
	
}

crc_entry_guard_battle()
{
	self endon("death");
	
	s_entry_guard_target = getent("crc_guard_shoot_at_ent", "targetname");
	nd_entry_guard_dest = getnode("crc_guard_1_dest_node", "targetname");
	nd_entry_guard_node = getnode("crc_guard_1_node", "targetname");
	
	
	self.fixednode = true;
	self SetGoalNode(nd_entry_guard_node);
	self.ignoreall = true;
	self.ignoreme = true;
	self AimAtPos(s_entry_guard_target.origin);
	
	self shoot_at_target(s_entry_guard_target, undefined, 0.1, 2.5);
	
	//wait(2);
	
	self SetGoalNode(nd_entry_guard_dest);
	nd_sal_crc = getnode("crc_sal_cover_node", "targetname");
	level.ai_salazar SetGoalNode(nd_sal_crc);
	
	self Waittill("goal");
	self.ignoreall = false;
	self.ignoreme = false;
	


}

play_bink_on_hud_glasses_karma( bink_name, duration, is_looping, is_in_memory, endon_notify )
{
	assert( IsDefined( bink_name ), "Undefined Bink name" );

	if( isdefined( is_looping ) )
	{
		assert( IsDefined( endon_notify ) , "if is a looping cinematic, then an endon notify must be defined" );
	}

	if( isdefined( duration ) )
	{
		is_looping = true;
	}

	if( !isdefined( is_looping ) )
	{
		is_looping = false;	
	}

	if( !isdefined(is_in_memory ) )
	{
		is_in_memory = false;	
	}

	temp_hud = create_on_screen_bink_hud(320, 0, 400, 480, "mtl_karma_retina_bink");	
		
	Start3DCinematic(bink_name, is_looping, is_in_memory);

	if( isdefined( duration ) )
	{
		wait(duration);
	}
	else if( isdefined( is_looping ) && is_looping != false )
	{
		self waittill(endon_notify);
	}
	else
	{
		level waittill("cine_notify", num);
		duration = GetCinematicTimeRemaining();
		wait(duration);
	}

		Stop3DCinematic();
		temp_hud destroy();
}




//-----------------------------------------------------------------------------------------------
//-----------------------------------SPECIALTY PERK---------------------------------
//-----------------------------------------------------------------------------------------------
trespasser_perk()
{	
	if( !level.player HasPerk( "specialty_trespasser" ) )  // actually specialty_trespasser
	{
		return;
	}
	
	s_trespasser_door_pos = getstruct( "trespasser_door_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_trespasser_door_pos.origin, "interact" );
	
	trigger_wait( "t_trespasser_door" );
	
	set_objective( level.OBJ_INTERACT, s_trespasser_door_pos, "remove" );

	t_trespasser_door = GetEnt( "t_trespasser_door", "targetname" );
	t_trespasser_door Delete();
	
	// Comment out scene because there is no animation yet.
	//run_scene( "trespasser" );
	wait 1;
	
	m_intruder_door = GetEnt( "trespasser_door", "targetname" );
	m_intruder_door Delete();
	
	s_trespasser_reward_pos = getstruct( "trespasser_reward_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_trespasser_reward_pos.origin, "interact" );	
	
	trigger_wait( "trespasser_use_reward_pos" );
	
	set_objective( level.OBJ_INTERACT, s_trespasser_reward_pos, "remove" );
	
	t_trespasser_reward = GetEnt( "trespasser_use_reward_pos", "targetname" );
	t_trespasser_reward Delete();
	
	flag_set( "trespasser_reward_enabled" );
	
}

//-----------------------------------------------------------------------------------------------
//-----------------------------------CHALLENGES--------------------------------------
//---------------------------------------------------------------retrieve spiderbot-------
retrieve_bot_challenge( str_notify ) // self == player
{
	self endon( "retrieve_bot_challenge_complete" );
	
	m_spiderbot_temp = GetEnt( "spiderbot_temp", "targetname" );
	
	trigger_wait( "t_spiderbot" );
	
	// run_scene of animation picking up bot and putting it away

	m_spiderbot_temp Hide();
	
	self notify( str_notify );
	
	level notify( "retrieve_bot_challenge_complete" );
}