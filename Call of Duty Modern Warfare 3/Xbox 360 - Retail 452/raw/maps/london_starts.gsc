#include maps\_utility;
#include common_scripts\utility;
#include maps\london_code;

// Music
// - Alley: Bourne Supremacy - 02. The Drop
// - OR Alley: Spy Game - 15. The Long Night
// - Warehouse: Bourne Supremacy - 08. Berlin Foot Chase @ 6:00
// - Or Warehouse: Spy Game - 04. Red Shirt @ 1:30
// - Or Warehouse: Demo - Robert Duncan - 10. Explosive Trucks (remove 1:23 to end)

main()
{
	add_start( "start_of_level" );
	add_start( "post_intro" );
	add_start( "2nd_alley" );
	add_start( "warehouse_breach" );
	add_start( "warehouse_hallway" );
	add_start( "docks_assault" );
	add_start( "docks_assault_ambush" );
	add_start( "docks_assault_streets" );
    add_start( "train_start" );
    add_start( "train_start_ride" );
    add_start( "train_start_first_bend" );
    add_start( "train_start_civilian_fly_by" );
    add_start( "train_start_outside" );
    add_start( "train_start_ghost_station" );
    add_start( "train_crash_end" );
	add_start( "west_station" );
	add_start( "west_ending" );
	add_start( "west_ending_stairs" );
	add_start( "west_ending_explosion" );
	
	/*  
	fake out run from launcher 
    
    add_start( "no_game_tunnel_start" );
    add_start( "no_game_ghost_station" );

    */
}

start_thread()
{
   	thread enter_objectives();
    thread enter_music();
    thread exit_vision();
    thread exit_catchup_startpoints();
    thread exit_fx_volumes();
    thread exit_volume_masks();
}

exit_fx_volumes()
{
//    fx_volume_pause_noteworthy( "london_west_fx_volume" );
    fx_volume_pause_noteworthy( "westminster_tunnels_fx_volume" );
    fx_volume_pause_noteworthy( "westminster_tunnels_crash_fx_volume" );

	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one

	start = level.start_point;
	if ( is_default_start() )
		return;
		
		
	//end-top section
	if ( start == "start_of_level" )
		return;
	if ( start == "post_intro" )
		return;
	if ( start == "2nd_alley" )
		return;
	if ( start == "warehouse_breach" )
		return;
	if ( start == "warehouse_hallway" )
		return;
	if ( start == "docks_assault" )
		return;
	if ( start == "docks_assault_ambush" )
		return;
		
    london_docks_warehouse_volume = GetEntArray( "london_docks_warehouse_volume", "script_noteworthy" );
    delete_destructibles_in_volumes( london_docks_warehouse_volume );
	delete_interactives_in_volumes( london_docks_warehouse_volume );
    delete_exploders_in_volumes( london_docks_warehouse_volume );
    fx_volume_pause_noteworthy( "london_docks_warehouse_volume" );

	if ( start == "docks_assault_streets" )
		return;
    
    
    
	if ( start == "train_start" )
		return;

    london_docks_fx_volume = GetEntArray( "london_docks_fx_volume", "script_noteworthy" );
    delete_destructibles_in_volumes( london_docks_fx_volume );
	delete_interactives_in_volumes( london_docks_fx_volume );
    delete_exploders_in_volumes( london_docks_fx_volume );
    
    fx_volume_pause_noteworthy( "london_docks_fx_volume" );
    fx_volume_restart_noteworthy( "westminster_tunnels_fx_volume" );
    fx_volume_restart_noteworthy( "westminster_tunnels_crash_fx_volume" );

	if ( start == "train_start_ride" )
		return;
	if ( start == "train_start_first_bend" )
		return;
	if ( start == "train_start_civilian_fly_by" )
		return;
	if ( start == "train_start_outside" )
		return;
	if ( start == "train_start_ghost_station" )
		return;
//	if ( start == "train_crash" )
//		return;

    westminster_tunnels_fx_volume = GetEntArray( "westminster_tunnels_fx_volume", "script_noteworthy" );
    delete_destructibles_in_volumes( westminster_tunnels_fx_volume );
    delete_interactives_in_volumes( westminster_tunnels_fx_volume );
    delete_exploders_in_volumes( westminster_tunnels_fx_volume );

    westminster_tunnels_crash_fx_volume = GetEntArray( "westminster_tunnels_crash_fx_volume", "script_noteworthy" );
    delete_destructibles_in_volumes( westminster_tunnels_crash_fx_volume );
    delete_interactives_in_volumes( westminster_tunnels_crash_fx_volume );
    delete_exploders_in_volumes( westminster_tunnels_crash_fx_volume );


    fx_volume_pause_noteworthy( "westminster_tunnels_fx_volume" );
    fx_volume_pause_noteworthy( "westminster_tunnels_crash_fx_volume" );
//    fx_volume_restart_noteworthy( "london_west_fx_volume" );

	if ( start == "train_crash_end" )
		return;
	if ( start == "west_station" )
		return;

	if ( start == "west_ending" )
		return;
	if ( start == "west_ending_stairs" )
		return;
	if ( start == "west_ending_explosion" )
		return;
	AssertMsg( "Unhandled start point " + start );
}

exit_catchup_startpoints()
{

	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	//end-top section
	
	if ( start == "start_of_level" )
		return;

	flag_set( "start_fence_climb" );
	flag_set( "alley_start" );
	flag_set( "uav_focusing_on_player" );
	flag_set( "uav_slamzoom" );
	flag_set( "uav_slamzoom_done" );

	if ( start == "post_intro" )
		return;

	flag_set( "alley_spawn_enemy_cellphone" );

	if ( start == "2nd_alley" )
		return;

	if ( start == "warehouse_breach" )
		return;

	flag_set( "london_warehouse_door_kicked" );
	flag_set( "warehouse_first_hallway" );

	if ( start == "warehouse_hallway" )
		return;

	if ( start == "docks_assault" )
		return;
//	if ( start == "docks_assault_quick" )
//		return;

	flag_set( "warehouse_complete" );
	flag_set( "warehouse_top" );
	flag_set( "warehouse_exit" );
	flag_set( "docks_entrance" );

	if ( start == "docks_assault_ambush" )
		return;

	flag_set( "docks_truck_door_opened" );
	flag_set( "docks_truck_searched" );
	flag_set( "docks_ambush" );
	flag_set( "docks_almost_to_street" );
	flag_set( "docks_littlebird_strafe" );

	if ( start == "docks_assault_streets" )
		return;

	flag_set( "start_train_encounter" );

	if ( start == "train_start" )
		return;
		
    flag_set( "ride_without_wait" );
    flag_set( "player_mounts_car" );
    flag_set( "train_goes" );
    flag_set( "player_mount_car_complete" );
    
	if ( start == "train_start_ride" )
		return;

    flag_set( "riding_train_already" );
    
	if ( start == "train_start_first_bend" )
		return;
	if ( start == "train_start_civilian_fly_by" )
		return;
	if ( start == "train_start_outside" )
		return;
	if ( start == "train_start_ghost_station" )
		return;
//	if ( start == "train_crash" )
//		return;
	if ( start == "train_crash_end" )
		return;
	if ( start == "west_station" )
		return;
	if ( start == "west_ending" )
		return;
	if ( start == "west_ending_stairs" )
		return;
	if ( start == "west_ending_explosion" )
		return;
	AssertMsg( "Unhandled start point " + start );
}

enter_objectives()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "start_of_level":
		case "post_intro":
		case "2nd_alley":
			// Stack Up at the Warehouse
			struct = getstruct( "objective_stack_up", "targetname" );
			Objective_Add( obj( "alley_stack_up" ), "current", &"LONDON_OBJECTIVE_STACK_UP" );
		case "warehouse_breach":
			flag_wait( "london_warehouse_door_kicked" );
			Objective_Complete( obj( "alley_stack_up" ) );
			struct = getstruct( "objective_clear_warehouse", "targetname" );
			Objective_Add( obj( "docks_clear_warehouse" ), "current", &"LONDON_OBJECTIVE_CLEAR_WAREHOUSE" );
		case "warehouse_hallway":
		case "docks_assault":
//		case "docks_assault_quick":
			flag_wait( "warehouse_top" );
			Objective_Complete( obj( "docks_clear_warehouse" ) );

			flag_wait( "warehouse_exit" );
			struct = getstruct( "objective_docks_assault", "targetname" );
			Objective_Add( obj( "docks_assault" ), "current", &"LONDON_OBJECTIVE_ASSAULT_DOCKS" );

			flag_wait( "docks_entrance" );
			// Remove the DOT
//			Objective_Add( obj( "docks_assault" ), "current", &"LONDON_OBJECTIVE_ASSAULT_DOCKS", ( 0, 0, 0 ) );
		case "docks_assault_ambush":
			flag_wait( "docks_open_truck_door" );
			Objective_State( obj( "docks_assault" ), "done" );

			struct = getstruct( "objective_docks_truck", "targetname" );
			Objective_Add( obj( "docks_open_truck" ), "current", &"LONDON_OBJECTIVE_TRUCK_DOOR", struct.origin );

			flag_wait( "docks_truck_door_opened" );
			Objective_State( obj( "docks_open_truck" ), "done" );
			flag_wait( "docks_ambush" );
		case "docks_assault_streets":
			struct = getstruct( "objective_chase_hostiles", "targetname" );
			Objective_Add( obj( "chase_hostiles" ), "current", &"LONDON_OBJECTIVE_CHASE_HOSTILES" );
//			flag_wait( "docks_almost_to_street" );
//			struct = getstruct( "objective_hostiles_to_station", "targetname" );
//			Objective_Add( obj( "chase_hostiles" ), "current", &"LONDON_OBJECTIVE_CHASE_HOSTILES_TO_STATION", struct.origin );

			//flag_wait( "docks_enemy_fallback" );
			//struct = getstruct( "objective_docks_truck", "targetname" );
			//Objective_Add( obj( "chase_hostiles" ), "current", &"LONDON_OBJECTIVE_CHASE_HOSTILES", struct.origin );
		case "train_start":
		    flag_wait( "transition_to_train" );
//			Objective_Complete( obj( "chase_hostiles" ) );
		    //Get the bad guy!
		case "train_start_ride":
//		    player_car_goes = GetEnt( "truck_load_use_trigger", "targetname" );
//		    Objective_Add( obj( "train_chase" ), "current",   &"LONDON_OBJECTIVE_TRAIN_CHASE", player_car_goes GetOrigin() );
		    flag_wait_either( "last_guy_running_to_train", "train_goes" );
		    player_car_goes = GetEnt( "truck_load_use_trigger", "targetname" );
		    Objective_State( obj( "train_chase" ), "empty" );
		    //Get to the truck!
		    Objective_Add( obj( "get_in_truck" ), "current",       &"LONDON_OBJECTIVE_TRAIN_TAILGATE", player_car_goes GetOrigin() );
		    Objective_Position( obj( "get_in_truck" ), player_car_goes GetOrigin() );
            flag_wait( "player_mount_car_complete" );
			Objective_State( obj( "get_in_truck" ), "done" );
		case "train_start_first_bend":
		case "train_start_civilian_fly_by":
		case "train_start_outside":
		case "train_start_ghost_station":
//		case "train_crash":
		    Objective_Add( obj( "stop_the_train" ), "current",       &"LONDON_OBJECTIVE_TRAIN_STOP_TRAIN"  );
            flag_wait( "train_crashed" );
			Objective_State( obj( "stop_the_train" ), "done" );
		case "train_crash_end":
		case "west_station":
			flag_wait( "start_train_traverse" );
			flag_wait( "start_lower_station" );
			//Clear Westminster Station
			Objective_Add( obj( "clear_station" ), "current",      &"LONDON_OBJECTIVE_CLEAR_STATION" );
			Objective_OnEntity( obj( "clear_station" ), level.sas_leader );
			flag_wait( "reached_station_exit" );
			Objective_State( obj( "clear_station" ), "done" );
		case "west_ending":
		case "west_ending_stairs":
			flag_wait( "setup_blockade" );
			struct = getstruct( "ending_stackup_objective", "targetname" );
			Objective_Add( obj( "blockade" ), "current", &"LONDON_OBJECTIVE_SETUP_BLOCKADE", struct.origin );

			flag_wait( "ending_player_in_position" );
			Objective_State( obj( "blockade" ), "done" );
		case "west_ending_explosion":
			break;
		default:
			AssertMsg( "Start point " + level.start_point + " isn't handled by enter_objectives" );
	}
}

enter_music()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "start_of_level":
		case "post_intro":
		case "2nd_alley":
		case "warehouse_breach":
			MusicPlayWrapper( "london_uav", 0 );
		    flag_wait( "london_warehouse_door_kicked" );
            musicplaywrapper( "london_warehouse" );
		case "warehouse_hallway":
		case "docks_assault":
//		case "docks_assault_quick":
		case "docks_assault_ambush":
		case "docks_assault_streets":
			flag_wait( "docks_littlebird_strafe" );
			thread music_play( "london_battle_loop" );
		case "train_start":
		case "train_start_ride":
			flag_wait( "train_goes" );
		case "train_start_first_bend":
		    thread music_play( "london_train_chase_music" );
		case "train_start_civilian_fly_by":
		case "train_start_outside":
		case "train_start_ghost_station":
//		case "train_crash":
		case "train_crash_end":
		case "west_station":
            flag_wait( "start_train_traverse" );
			level notify( "stop_music" );
			MusicStop( 3 );
//			wait 3;
//			flag_wait( "start_station_music" );
//			thread musicplaywrapper( "london_westminster_action1" );
		case "west_ending":
//			flag_wait( "truck_explodes" );
//			MusicStop( 0.0 );
		case "west_ending_stairs":
		case "west_ending_explosion":
			break;
		default:
			AssertMsg( "Start point " + level.start_point + " isn't handled by enter_music" );
	}
}

exit_vision()
{
    vision_set_fog_changes( "london_docks", 0 );
    
	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;

	//end-top section
	if ( start == "start_of_level" )
		return;
	if ( start == "post_intro" )
		return;
	if ( start == "2nd_alley" )
		return;
	if ( start == "warehouse_breach" )
		return;
	if ( start == "warehouse_hallway" )
		return;
	if ( start == "docks_assault" )
		return;
//	if ( start == "docks_assault_quick" )
//		return;
	if ( start == "docks_assault_ambush" )
		return;

    vision_set_fog_changes( "london_construction_street", 20 );
	if ( start == "docks_assault_streets" )
		return;
	if ( start == "train_start" )
		return;
    vision_set_fog_changes( "westminster_tunnel", 0 );
	if ( start == "train_start_ride" )
		return;
    vision_set_fog_changes( "westminster_tunnel", 0 );
	if ( start == "train_start_first_bend" )
		return;
    vision_set_fog_changes( "westminster_tunnel", 0 );
	if ( start == "train_start_civilian_fly_by" )
		return;

    vision_set_fog_changes( "westminster_tunnel_outside", 0 );
	if ( start == "train_start_outside" )
		return;
    vision_set_fog_changes( "westminster_tunnel", 0 );
	if ( start == "train_start_ghost_station" )
		return;
//	if ( start == "train_crash" )
//		return;
	vision_set_fog_changes( "london_westminster_station", 0 );
	if ( start == "train_crash_end" )
		return;
	if ( start == "west_station" )
		return;
	if ( start == "west_ending" )
		return;
	if ( start == "west_ending_stairs" )
		return;

	vision_set_fog_changes( "london_westminster", 0 );
	if ( start == "west_ending_explosion" )
		return;
	AssertMsg( "Unhandled start point " + start );
}

exit_volume_masks()
{
	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	//end-top section
	if ( start == "start_of_level" )
		return;
	if ( start == "post_intro" )
		return;
	if ( start == "2nd_alley" )
		return;
	if ( start == "warehouse_breach" )
		return;
	if ( start == "warehouse_hallway" )
		return;
	if ( start == "docks_assault" )
		return;
//	if ( start == "docks_assault_quick" )
//		return;
	if ( start == "docks_assault_ambush" )
		return;
	if ( start == "docks_assault_streets" )
		return;
		
    westminster_tunnels_fx_volume = GetEnt( "westminster_tunnels_fx_volume", "script_noteworthy" );
	westminster_tunnels_fx_volume activate_destructibles_in_volume();
	westminster_tunnels_fx_volume activate_interactives_in_volume();
	westminster_tunnels_fx_volume activate_exploders_in_volume();
	
    westminster_tunnels_crash_fx_volume = GetEnt( "westminster_tunnels_crash_fx_volume", "script_noteworthy" );
	westminster_tunnels_crash_fx_volume activate_destructibles_in_volume();
	westminster_tunnels_crash_fx_volume activate_interactives_in_volume();
	westminster_tunnels_crash_fx_volume activate_exploders_in_volume();

	if ( start == "train_start" )
		return;
	if ( start == "train_start_ride" )
		return;
	if ( start == "train_start_first_bend" )
		return;
	if ( start == "train_start_civilian_fly_by" )
		return;
	if ( start == "train_start_outside" )
		return;
	if ( start == "train_start_ghost_station" )
		return;
		
//    london_west_fx_volume = GetEnt( "london_west_fx_volume", "script_noteworthy" );
//	london_west_fx_volume activate_destructibles_in_volume();
//	london_west_fx_volume activate_interactives_in_volume();
//	london_west_fx_volume activate_exploders_in_volume();
		
//	if ( start == "train_crash" )
//		return;
	if ( start == "train_crash_end" )
		return;
	if ( start == "west_station" )
		return;
	if ( start == "west_ending" )
		return;
	if ( start == "west_ending_stairs" )
		return;
	if ( start == "west_ending_explosion" )
		return;
	AssertMsg( "Unhandled start point " + start );
}
