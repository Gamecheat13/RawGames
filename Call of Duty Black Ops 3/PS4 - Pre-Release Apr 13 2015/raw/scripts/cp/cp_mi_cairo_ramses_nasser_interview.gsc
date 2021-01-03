#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\lui_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_objectives;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_cairo_ramses_level_start;
#using scripts\cp\cp_mi_cairo_ramses_station_fight;
#using scripts\cp\cp_mi_cairo_ramses_station_walk;
#using scripts\cp\cp_mi_cairo_ramses_fx;
#using scripts\cp\cp_mi_cairo_ramses_sound;
#using scripts\cp\cp_mi_cairo_ramses_utility;

#precache( "objective", "cp_level_ramses_nasser_gather" );
#precache( "lui_menu", "NasserInterviewPIP" );

function main()
{
	flag::init( "khalil_at_nasser_interview" );
	flag::init( "hendricks_at_nasser_interview" );
	flag::init( "skip_nasser_interview" );
	flag::init( "dr_nasser_interview_started" );
	
	precache();

//	level_start::turn_off_reflection_extracam();
	
	level flag::wait_till( "start_coop_logic" );
	
	//TODO: 
//	if(ramses_util::is_demo())
//	{
		level thread start_interview_demo();
//	}
//	else
//	{
//		level thread start_interview_anims();
//	}
	
	// TODO - add a cleanup function to make sure the scenes are cleaned up when appropriate
}

function precache()
{
	// DO ALL PRECACHING HERE
}

function init_heroes( str_objective )
{
	level.ai_hendricks = util::get_hero( "hendricks" );
	level.ai_rachel = util::get_hero( "rachel" );
	level.ai_khalil = util::get_hero( "khalil" );
	
	// TODO - HACK!  Remove this later!
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_rachel ai::set_ignoreall( true );
	level.ai_khalil ai::set_ignoreall( true );
	
	//TODO - HACK! Prevents Hendricks and Rachel from running off when starting from this skipto
	nd_hendricks = GetNode( "hendricks_walkthrough_end", "targetname" );
	level.ai_hendricks setgoal( nd_hendricks.origin, true );
	
	nd_rachel = GetNode( "rachel_walkthrough_end", "targetname" );
	level.ai_rachel setgoal( nd_rachel.origin, true );
		
    skipto::teleport_ai( str_objective );
}

function pre_skipto_anims( b_starting = false )
{	
//	if( !b_starting )
//	{
//	}
	
	level thread scene::init( "cin_ram_02_05_interview_vign_nassersitting" );
}

function start_interview_anims()
{
	level endon( "skip_dr_nasser_interview" );
	
	// TODO - use a scene_func for this, remove the notetrack
	// Notetrack for ch_ram_02_04_interview_vign_khalilgreet_start_khalil
	level waittill( "cin_ram_02_04_walk_1st_introduce_05_complete" );
	
	//s_obj = struct::get ( "obj_nasser_gather", "targetname" );
	//objectives::set( "cp_level_ramses_nasser_gather", s_obj );
	
	level thread rachel_at_computer_scenes();
	level thread khalil_move_to_interview();
	level thread hendricks_move_to_interview();
	level thread player_gather_objective();

	// Wait for Hendricks and Khalil to get near the interview room
	flag::wait_till( "khalil_at_nasser_interview" );
	flag::wait_till( "hendricks_at_nasser_interview" );
	
	// Make sure the player is inside the safehouse before beginning the Nasser Interview
	flag::wait_till( "rs_walkthrough_safehouse_enter" );
	
	//objectives::complete( "cp_level_ramses_nasser_gather", s_obj );
	
	// Play the Dr. Nasser Interview
	level thread scene::play( "cin_ram_02_05_interview_vign_interrogate" );
	//level thread scene::play( "cin_ram_02_04_interview_pip_closeup" );
	//level thread scene::play( "cin_ram_02_04_interview_pip_wide" );
	IPrintLnBold( "Dr. Nasser Interview Started" );
	flag::set( "dr_nasser_interview_started" );
		
	// Turn On Extra Cam	
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "nasser_interview_extra_cam", 1 );
		// Open the UI MENU
		player.nasser_interview_ui = player OpenLUIMenu( "NasserInterviewPIP" );		
	}
	
	// TODO - use a scene_func for this, remove the notetrack
	// Notetrack for cin_ram_02_05_interview_vign_interrogate
	level waittill( "cin_ram_02_05_interview_vign_interrogate_complete" );
	IPrintLnBold( "Dr. Nasser Interview Completed" );
	
	// Turn Off Extra Cam
	foreach( player in level.players )
	{
		player clientfield::set_to_player( "nasser_interview_extra_cam", 0 );	
		if( IsDefined( player.nasser_interview_ui ) )
		{
			player CloseLUIMenu( player.nasser_interview_ui );	
			player.nasser_interview_ui = undefined;
		}
	}
	
	//COMPLETE THE SKIPTO
	skipto::objective_completed( "interview_dr_nasser" );
	
}

function rachel_at_computer_scenes()
{
	level endon( "interview_dr_nasser_completed" );
	level endon( "rachel_computer_pt2_played" );
	
	//HACK - remove this once we have the new Rachel, Khalil, Hendricks walk through
//	wait 2.0;
	s_teleport = struct::get( "temp_teleport_kane", "targetname" );
//	level.ai_rachel forceteleport( s_teleport.origin, s_teleport.angles );
	level.ai_rachel.goalradius = 32;
	level.ai_rachel ai::force_goal( s_teleport.origin, 20 );
	
	// Send Rachel to computer
	// TODO - change this to a DO REACH in the scene's GDT
//	nd_rachel = GetNode( "rachel_move_to_computer", "targetname" );
//	level.ai_rachel setgoal( nd_rachel.origin, true );
//	level.ai_rachel waittill( "goal" );
//	
//	level thread scene::init( "cin_ram_02_06_interview_vign_rachaelcomputer", level.ai_rachel );	
//
//	// When the player gets near Rachel, she speaks to the player
//	trigger::wait_till( "rs_walkthrough_near_rachel" );
//	
//	level thread scene::play( "cin_ram_02_06_interview_vign_rachaelcomputer", level.ai_rachel );	
}

// TODO - change this to a DO REACH in the scene's GDT
function khalil_move_to_interview()
{
	// HACK - use this for progression until the khalilgreet animation gets updated to the new location
//	wait 1.0;
	s_teleport = struct::get( "temp_teleport_khalil", "targetname" );
//	level.ai_khalil forceteleport( s_teleport.origin, s_teleport.angles );
	level.ai_khalil.goalradius = 32;
	level.ai_khalil ai::force_goal( s_teleport.origin, 20 );
	
	// Send Khalil to window
//	nd_khalil = GetNode( "khalil_move_to_interview", "targetname" );
//	level.ai_khalil setgoal( nd_khalil.origin, true );
//	level.ai_khalil waittill( "goal" );
//	
//	level flag::set( "khalil_at_nasser_interview" );
}

// TODO - change this to a DO REACH in the scene's GDT
function hendricks_move_to_interview()
{
	// Send Hendricks to window
	// HACK - use this for progression until the khalilgreet animation gets updated to the new location
//	wait 3.0;
	s_teleport = struct::get( "temp_teleport_hendricks", "targetname" );
//	level.ai_hendricks forceteleport( s_teleport.origin, s_teleport.angles );
	level.ai_hendricks.goalradius = 32;
	level.ai_hendricks ai::force_goal( s_teleport.origin, 20 );
	
	
//	nd_hendricks = GetNode( "hendricks_move_to_interview", "targetname" );
//	level.ai_hendricks setgoal( nd_hendricks.origin, true );
//	level.ai_hendricks waittill( "goal" );
//	
//	level flag::set( "hendricks_at_nasser_interview" );
}

function player_gather_objective()
{
	// Make sure the player is inside the safehouse before beginning the Nasser Interview
	flag::wait_till( "rs_walkthrough_safehouse_enter" );
	level notify ("interview");  //kills the intro music
	station_fight::close_interview_room_door();
	//objectives::complete( "cp_level_ramses_nasser_gather", s_obj );	
}

//DEMO FUNCTIONS DOWN HERE

//TODO: as we get the real functions, make sure that anything duplicated between
//actual level logic and the demo gets put in a shared area
function start_interview_demo()
{
	//level thread scene::play( "cin_ram_02_04_interview_vign_khalilgreet" );
	
	level thread hack_heroes_after_anim(); //TODO: REMOVE THIS
	
	//s_obj = struct::get ( "obj_nasser_gather", "targetname" );
	//objectives::set( "cp_level_ramses_nasser_gather", s_obj );


	// Make sure the player is inside the safehouse before beginning the Nasser Interview, then hit notetrack
	level waittill( "fade_introduce_down" );
	flag::wait_till( "rs_walkthrough_safehouse_enter" );
	//objectives::complete( "cp_level_ramses_nasser_gather", s_obj );
	
	//-- These currently run twice
	level thread rachel_at_computer_scenes(); //TODO: re-implement this after the demo
	level thread khalil_move_to_interview();
	level thread hendricks_move_to_interview();	
		
	level thread player_gather_objective();
	
	
	//TODO: Remove when we get an animation
	wait 3; //then give the player a couple beats to temp in for the animation that will go here
	
	//TODO: find out if we actually want to put an "in the interest of time" thing here
	level thread connection_interrupted();
	level notify( "player_at_fade_down" );	
	level util::clientNotify ("inv");
	util::screen_fade_out();
	
	level thread cleanup_introduce_anims();
	
	level notify ("interview");  //kills the intro music and activates a custom snapshot
		
	//-- will cleanup some of the animations
	level flag::set( "station_walk_cleanup" );
	
	//-- prep for the next version of the station
	level thread station_fight::intermediate_prop_state_show();
	
	//COMPLETE THE SKIPTO
	skipto::objective_completed( "interview_dr_nasser" );
}

function hack_heroes_after_anim()
{
	level endon( "cin_ram_02_04_walk_1st_introduce_05_complete" );
	level waittill( "fade_introduce_down" );
	
	util::wait_network_frame();
	
	level thread rachel_at_computer_scenes(); //TODO: re-implement this after the demo
	level thread khalil_move_to_interview();
	level thread hendricks_move_to_interview();	
}

function connection_interrupted()
{
	level ramses_util::post_fx_transitions( "dni_futz", "cp_ramses1_fs_connectioninterrupted" );
}

function cleanup_introduce_anims()
{
	a_introduce_anims = [];
	if ( !isdefined( a_introduce_anims ) ) a_introduce_anims = []; else if ( !IsArray( a_introduce_anims ) ) a_introduce_anims = array( a_introduce_anims ); a_introduce_anims[a_introduce_anims.size]="cin_ram_02_04_walk_1st_introduce_01";;
	if ( !isdefined( a_introduce_anims ) ) a_introduce_anims = []; else if ( !IsArray( a_introduce_anims ) ) a_introduce_anims = array( a_introduce_anims ); a_introduce_anims[a_introduce_anims.size]="cin_ram_02_04_walk_1st_introduce_02";;
	if ( !isdefined( a_introduce_anims ) ) a_introduce_anims = []; else if ( !IsArray( a_introduce_anims ) ) a_introduce_anims = array( a_introduce_anims ); a_introduce_anims[a_introduce_anims.size]="cin_ram_02_04_walk_1st_introduce_03";;
	if ( !isdefined( a_introduce_anims ) ) a_introduce_anims = []; else if ( !IsArray( a_introduce_anims ) ) a_introduce_anims = array( a_introduce_anims ); a_introduce_anims[a_introduce_anims.size]="cin_ram_02_04_walk_1st_introduce_04";;
	if ( !isdefined( a_introduce_anims ) ) a_introduce_anims = []; else if ( !IsArray( a_introduce_anims ) ) a_introduce_anims = array( a_introduce_anims ); a_introduce_anims[a_introduce_anims.size]="cin_ram_02_04_walk_1st_introduce_05";;
	
	foreach( str_anim in a_introduce_anims )
	{
		if( scene::is_active( str_anim ) )
		{
			scene::stop( str_anim );
		}
	}
}

