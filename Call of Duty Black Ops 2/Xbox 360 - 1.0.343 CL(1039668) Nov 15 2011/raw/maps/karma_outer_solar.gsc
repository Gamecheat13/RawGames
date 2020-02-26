#include common_scripts\utility;
#include maps\_utility;
#include maps\karma_util;
#include maps\_scene;
#include maps\_objectives;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
    INIT functions
-------------------------------------------------------------------------------------------*/
//
//	Declare event-specific flags here
init_flags()
{
	flag_init( "entered_club" );
	flag_init( "player_at_club" );
	flag_init( "sal_at_club" );
	flag_init( "civ_kill_lounge" );
	flag_init( "civ_kill_outer_solar" );	
	flag_init( "club_door_closed" );
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
skipto_outer_solar()
{
	level.ai_salazar = init_hero( "salazar" );

	start_teleport( "skipto_outer_solar", array(level.ai_salazar) );
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
		IPrintLn( "outer_solar" );
	#/
	
	// Change the skybox to the alternate one
	SetSavedDvar( "r_skyTransition", 1 );
	level thread maps\createart\karma_art::karma_fog_club_entrance();

	maps\karma_anim::club_anims();

	level thread start_civs_outer_solar( "civ_kill_outer_solar" );
	level thread outer_solar_objectives();
	
//	flag_set( "player_among_civilians" );
	level.ai_salazar thread salazar_think();
	
	flag_wait( "entered_club" );
}

outer_solar_objectives()
{
	trigger_wait( "t_event_61_start" );
	
	set_objective( level.OBJ_EVENT_6_1a, level.ai_salazar, "follow" );
	
	trigger_wait( "t_club_entrance" );
	
	clientnotify( "scle" );
	
	flag_set( "player_at_club" );
	
	level thread run_scene_and_delete( "scene_enter_bouncer_door" );
	
	if( !flag( "sal_at_club" ) )
	{
		level thread entrance_door();
	}
	
	trigger_wait( "t_close_entrance_door" );
	
	level thread start_civs_lounge( "civ_kill_lounge" );
	
	trigger_wait( "t_event_61_b" );

//	level thread civ_pop_kill_outside();
	
	set_objective( level.OBJ_EVENT_6_1a, undefined, "done" );
	set_objective( level.OBJ_EVENT_6_1a, undefined, "delete" );
	
	self thread objective_breadcrumb( level.OBJ_EVENT_6_1b, "t_event_61_b" );
	
	level thread run_scene_and_delete( "bouncer_lounge_door_idle" );

	trigger_wait( "t_lounge_door" );
	
	level thread lounge_door();
	end_scene( "bouncer_lounge_door_idle" );
	level run_scene_and_delete( "bouncer_lounge_door_open" );
	level thread run_scene_and_delete( "bouncer_lounge_door_wait" );
	
	trigger_wait( "t_lounge_door_close" );

	end_scene( "bouncer_lounge_door_wait" );
	level thread run_scene_and_delete( "bouncer_lounge_door_close" );

	trigger_wait( "trig_club_hallway" );
	
	set_objective( level.OBJ_EVENT_6_1b, undefined, "done" );
	set_objective( level.OBJ_EVENT_6_1b, undefined, "delete" );		
	
	flag_set( "entered_club" );
}

entrance_door()
{
	solar_door = GetEnt( "solar_door", "targetname" );
	solar_door rotateto( solar_door.angles + (0, 100, 0), 2.5, 0, 0.15 );	
	solar_door waittill( "rotatedone" );
	solar_door connectpaths();
	
	t_close_door = getEnt( "t_close_entrance_door", "targetname" );

	while( true )
	{
		if( level.player istouching( t_close_door )  && level.ai_salazar istouching( t_close_door ) )
		{
			break;
		}
		
		wait 0.1;
	}
	
	solar_door rotateto( solar_door.angles + (0,-100,0), 1, 0, 0.15 );
	
	flag_set( "civ_kill_outer_solar" );		
}

lounge_door()
{
	clientnotify( "scms" );
	
	lounge_door = getEnt( "lounge_door", "targetname");
	lounge_door RotateYaw( 100, 2.5, 0, 0.15 );
	lounge_door waittill( "rotatedone" );	

	trigger_wait( "t_lounge_door_close" );

	lounge_door RotateYaw( -100, 1, 0, 0.15 );
	lounge_door waittill( "rotatedone" );	

	flag_set( "civ_kill_lounge" );
}

salazar_think()
{
	self gun_remove();
	self set_generic_run_anim( "civ_walk" );
	self.disableArrivals = 1;	
	self.disableExits = 1;
	self.disableTurns = 1;
	self.goalradius = 8;
	
	trigger_wait( "t_event_61_start" );
	
	wait 2;	

	nd_01_sal_61 = GetNode( "nd_01_sal_event_61", "targetname" );
	self SetGoalNode( nd_01_sal_61 );
	self waittill( "goal" );
	
	flag_set( "sal_at_club" );
	
	if( !flag( "player_at_club" ) )
	{
		level thread entrance_door();	
	}
	
//	level thread run_scene_and_delete( "scene_sal_club_enter" );
//	level thread run_scene_and_delete( "scene_civ_club_enter" );
	
	nd_02_sal_61 = GetNode( "nd_02_sal_event_61", "targetname" );
	self SetGoalNode( nd_02_sal_61 );
	self waittill( "goal" );
	
	//Salazar at the bar waiting animation.
}

start_civs_outer_solar( str_kill_flag )
{
	//level thread maps\karma_civilians::spawn_civs( "solar_spawn", 30, "solar_initial", 15, str_kill_flag, 1, 3 );

	// Drones
	maps\karma_civilians::assign_civ_spawners( "civ_club_male", "civ_club_female" );
	maps\karma_civilians::assign_civ_drone_spawners( "solar_drones" );
	maps\_drones::drones_setup_unique_anims( "solar_drones", level.drones.anims[ "civ_walk" ] );
	maps\_drones::drones_speed_modifier( "solar_drones", -0.1, 0.1 );

	// Static drones (need to make this a function)
	level thread maps\karma_civilians::spawn_static_drones( "solar_drones", "static_outer_civs" );

	level thread maps\_drones::drones_start( "solar_drones" );
	
	ai_outside_club = simple_spawn( "ai_outside_club", ::ai_logic );
	
	flag_wait( str_kill_flag );
	
	stop_civilians();
	
	foreach( outside_guy in ai_outside_club )
	{
		if( isAlive( outside_guy ) )
		{
			outside_guy Delete();
		}
	}
}

start_civs_lounge( str_kill_flag )
{
	maps\karma_civilians::assign_civ_drone_spawners( "lounge_drones" );	
	
	level thread maps\karma_civilians::spawn_static_drones( "lounge_drones", "static_lounge_bartender" );
	level thread maps\karma_civilians::spawn_static_drones( "lounge_drones", "static_lounge_talk" );
	level thread maps\karma_civilians::spawn_static_drones( "lounge_drones", "static_lounge_drinkers" );
	level thread maps\karma_civilians::spawn_static_drones( "lounge_drones", "static_lounge_bar" );	
	level thread maps\_drones::drones_start( "lounge_drones" );	
	
	ai_lounge = simple_spawn( "ai_lounge", ::ai_logic );
	
	flag_wait( str_kill_flag );	
	
	stop_civilians();

	foreach( lounge_guy in ai_lounge )
	{
		if( isAlive( lounge_guy ) )
		{
			lounge_guy Delete();
		}
	}
}

//	Delete all active civilians, but not spawners or triggers.
stop_civilians()
{
	// Clear out the civs
	level thread maps\_drones::drones_delete_spawned();
	level thread maps\karma_civilians::delete_all_civs();
}

ai_logic()
{
	self gun_remove();
}