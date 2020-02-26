#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;


/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "event_51_start" );
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
skipto_walkway()
{
	level.ai_salazar = init_hero( "salazar" );

	start_teleport( "skipto_walkway", array(level.ai_salazar) );
}


/* ------------------------------------------------------------------------------------------
	MAIN functions
-------------------------------------------------------------------------------------------*/
//
//	NOTE: This is a blocking function call.  When this function ends, the next function in 
//	your skipto sequence will be called.
main()
{	
	// Temp Development info
	/#
		IPrintLn( "walkway" );
	#/
		
	trigger_on( "t_walkways", "script_noteworthy" );
	trigger_on( "t_dropdown", "script_noteworthy" );
	trigger_off( "t_crc", "script_noteworthy" );		
	trigger_off( "t_constructions", "script_noteworthy" );
	trigger_off( "t_spawn_escalator_guys", "targetname" );
		
	level thread spiderbot_room_objectives();	
	
	flag_wait( "event_51_start" );
}

spiderbot_room_objectives()
{
	trigger_wait( "t_event_51_start" );

	level thread maps\karma_lobby::start_civilians( "civ_kill_walkway" );
	
	run_scene( "scene_p_gear_away" );		
	
	s_obj_door = getstruct( "struct_obj_door" );
	set_objective( level.OBJ_EVENT_5_1a, s_obj_door, "" );
	
	trigger_wait( "t_near_door" );

	set_objective( level.OBJ_EVENT_5_1a, s_obj_door, "done" );
	set_objective( level.OBJ_EVENT_5_1a, s_obj_door, "delete" );
	
	run_scene( "scene_p_open_room_door" );

	level thread sal_walkway_temp_lines();

	objective_breadcrumb( level.OBJ_EVENT_5_1b, "t_event_51_cont" );	

	trigger_wait( "t_event_51_end" );

	set_objective( level.OBJ_EVENT_5_1b, undefined, "done" );
	set_objective( level.OBJ_EVENT_5_1b, undefined, "delete" );		
	
	wait 0.1;
	flag_set( "event_51_start" );	
}

sal_walkway_temp_lines()
{
	IPrintLn( "Sal Audio:  Get to the elevators south west of your position." );
	wait 3;
	IPrintLn( "Sal Audio:  The elevators are under maintenance so youll need to get inside the shaft to make your way down to CRC floor." );
	wait 3;
	IPrintLn( "Sal Audio:  I'll meet you down there." );	
}