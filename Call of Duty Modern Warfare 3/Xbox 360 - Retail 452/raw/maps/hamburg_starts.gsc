#include maps\_utility;
#include common_scripts\utility;
#include maps\hamburg_code;

main()
{
	add_start( "ride_in" );
    add_start( "beach_landing" );
    add_start( "hot_buildings"  );
    add_start( "tank_path_pre_bridge" );	
    add_start( "tank_path_bridge"  );
    add_start( "tank_path_blackout"  );
    add_start( "hamburg_garage" );
    add_start( "hamburg_garage_post_entrance" );
//    add_start( "hamburg_garage_three" );
	add_start( "hamburg_garage_pre_ramp" );
    add_start( "hamburg_garage_ramp" );
    add_start( "hamburg_end_ramp" );
    add_start( "hamburg_end_street" );
    add_start( "hamburg_end_streetcorner" );
    add_start( "hamburg_end_nest" );
    add_start( "hamburg_end_ambush" );
    add_start( "hamburg_end" );
    add_start( "next_level" );
    
}

start_thread()
{
	thread enter_ambient_stuff();	
	thread exit_flag_catchup();
	thread enter_masking();
	thread enter_objectives();
}

enter_objectives()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "ride_in":
		case "beach_landing":
		case "hot_buildings":
		case "tank_path_pre_bridge":
			//Clear the way for tanks.
			flag_wait( "player_unloaded" );
			Objective_Add( obj( "scout_for_tanks" ), "current", &"HAMBURG_CLEAR_THE_WAY_FOR_TANKS", level.sandman.origin );
			Objective_OnEntity( obj( "scout_for_tanks" ), level.sandman );
			// is cleared in the script.
		case "tank_path_bridge":
			//tank objective "hop_on_the_tank" handled in the script. 
		case "tank_path_blackout":
		case "hamburg_garage":
		case "hamburg_garage_post_entrance":
		case "hamburg_garage_pre_ramp":
		case "hamburg_garage_ramp":
//		case "tank_crash_exit":
		case "hamburg_end_ramp":
		case "hamburg_end_street":
		case "hamburg_end_streetcorner":
		case "hamburg_end_nest":
		case "hamburg_end_ambush":
		case "hamburg_end":
		case "next_level":
			break;
		default:
			AssertMsg("Start point " + level.start_point + " isn't handled by enter_objectives" );
	}
}

enter_masking()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "ride_in":
		case "beach_landing":
		case "hot_buildings":
			flag_wait( "player_ready_for_hot_buildings" );
		case "tank_path_pre_bridge":
		case "tank_path_bridge":
		case "tank_path_blackout":
			activate_destructibles_in_volumes_noteworthy( "bridge_and_before_garage_area" );
			flag_wait( "player_ready_for_parking_lot" );
//		case "tank_path_before_garage":
//			activate_destructibles_in_volumes_noteworthy( "strafe_building_1_fx_volume" );
//			activate_destructibles_in_volumes_noteworthy( "strafe_building_2_fx_volume" );
			activate_destructibles_in_volumes_noteworthy( "parking_lot_area" );
		case "hamburg_garage":
//		case "hamburg_garage_two":
//		case "hamburg_garage_three":
//		case "hamburg_pre_ramp":
		case "hamburg_garage_post_entrance":
		case "hamburg_garage_pre_ramp":
		case "hamburg_garage_ramp":
//		case "tank_crash_exit":
		case "hamburg_end_ramp":
		case "hamburg_end_street":
		case "hamburg_end_streetcorner":
		case "hamburg_end_nest":
		case "hamburg_end_ambush":
		case "hamburg_end":

			flag_wait( "tank_path_bridge" );
			activate_destructibles_in_volumes_noteworthy( "garage_area" );
			flag_wait( "tank_crash_exit" );
			remove_global_spawn_function( "allies", ::brave_soul );
			activate_destructibles_in_volumes_noteworthy( "hamburg_b_area" );
		case "next_level":
			break;
		default:
			AssertMsg("Start point " + level.start_point + " isn't handled by enter_masking" );
	}
}

enter_ambient_stuff()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "ride_in":
			thread music_play( "hamburg_intro" );
		case "beach_landing":
		 	thread opening_fakefire_machinegun();
		case "hot_buildings":
		 	thread glory_tank_spawn();
		 	//thread open_area_ambient_flak();
		case "tank_path_pre_bridge":
		case "tank_path_bridge":
			flag_wait( "player_ready_for_hot_buildings" );
			kill_flak_runners();
		case "tank_path_blackout":
		case "hamburg_garage":
		case "hamburg_garage_post_entrance":
		case "hamburg_garage_pre_ramp":
		case "hamburg_garage_ramp":
//		case "tank_crash_exit":
		case "hamburg_end_ramp":
		case "hamburg_end_street":
		case "hamburg_end_streetcorner":
		case "hamburg_end_nest":
		case "hamburg_end_ambush":
		case "hamburg_end":
		case "next_level":
			break;
		default:
			AssertMsg("Start point " + level.start_point + " isn't handled by enter_ambient" );
	}
}

exit_flag_catchup()
{
	
	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	//end-top section
	
	if ( start == "ride_in" )
		return;
	
	flag_set( "player_unloaded" );
	
	set_ambient( "hamburg_beach" );

	flag_set( "pause_sentry_turrets" );
	if ( start == "beach_landing" )
		return;
		
	flag_set( "glory_tank_ready_for_death" );		
	if ( start == "hot_buildings" )
		return;


		
	set_ambient( "hamburg_tankgun_city" );
		
	if ( start == "tank_path_pre_bridge" )
		return;
	
	flag_set( "player_ready_for_parking_lot" );
		
	if ( start == "tank_path_bridge" )
		return;
		
	flag_set( "tank_path_bridge" );

//	if ( IsDefined( level.player_tank ) )
//		level.player_tank riders_godoff();
	
	
	array_delete( GetEntArray( "no_mans_land", "targetname" ) );
	no_mans_land_player_reset();
	
	array_delete( GetEntArray( "bridge_spawn_triggers", "targetname" ) );

	if ( start == "tank_path_blackout" )
		return;
		
	flag_set( "tank_path_before_garage" );	
	set_ambient( "hamburg_tankgun_garage" );
	
	if ( start == "hamburg_garage" )
		return;
		
	flag_set( "in_garage" );
	flag_set( "start_garage_section" );
	
	if ( start == "hamburg_garage_post_entrance" )
		return;
	if ( start == "hamburg_garage_pre_ramp" )
		return;
	if ( start == "hamburg_garage_ramp" )
		return;
//	if ( start == "tank_crash_exit" )
//		return;

	flag_set( "tank_crash_exit" );	
	if ( start == "hamburg_end_ramp" )
		return;
	if ( start == "hamburg_end_street" )
		return;
	if ( start == "hamburg_end_streetcorner" )
		return;
	if ( start == "hamburg_end_nest" )
		return;
	if ( start == "hamburg_end_ambush" )
		return;
	if ( start == "hamburg_end" )
		return;
	if ( start == "next_level" )
		return;
	AssertMsg( "Unhandled start point " + start );
}
