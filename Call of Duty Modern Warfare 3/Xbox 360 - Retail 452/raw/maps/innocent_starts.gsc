#include maps\_utility;
#include common_scripts\utility;

init_starts()
{
   	add_start( "train_crash_end",    	maps\london_west::start_train_end,  			"Start Ride - Post Crash",  maps\london_west::train_crash_exit  );
	add_start( "west_station",			maps\london_west::start_west_station,			"Westminster Station",		maps\london_west::west_station	);
 	add_start( "west_ending",			maps\london_west::start_west_ending,			"Westminster",				maps\london_west::west_ending	);
 	add_start( "west_ending_stairs",	maps\london_west::start_west_ending_stairs,		"Westminster Stairs",		maps\london_west::west_ending	);
	add_start( "innocent", 				maps\innocent::start_innocent, 					"innocent", 				maps\innocent::innocent_scene );
}

start_thread()
{
	thread music();
	thread objectives();
	thread vision();
}

objectives()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "train_crash_end":
		case "west_station":
			flag_wait( "got_contact" );
//			flag_wait( "start_lower_station" );
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
//		case "west_ending_explosion":
		case "innocent":
			break;
		default:
			AssertMsg( "Start point " + level.start_point + " isn't handled by enter_objectives" );
	}
}

vision()
{
    vision_set_fog_changes( "london_westminster_station", 0 );
    
	//top section auto generated, do not modify
	waittillframeend;// let the actual start functions run before this one
	start = level.start_point;
	if ( is_default_start() )
		return;
	//end-top section

	vision_set_fog_changes( "london_westminster_station", 0 );
	if ( start == "train_crash_end" )
		return;
	if ( start == "west_station" )
		return;
	if ( start == "west_ending" )
		return;

	vision_set_fog_changes( "london_westminster", 0 );

	if ( start == "west_ending_stairs" )
		return;
	if ( start == "innocent" )
		return;
	AssertMsg( "Unhandled start point " + start );
}

music()
{
	waittillframeend; // let the start points initiate stuff first

	switch ( level.start_point )
	{
		case "default":
		case "train_crash_end":
		case "west_station":
            flag_wait( "start_train_traverse" );
			level notify( "stop_music" );
			MusicStop( 3 );
			wait 3;
			flag_wait( "start_station_music" );
			thread musicplaywrapper( "london_westminster_action1" );
		case "west_ending":
		case "west_ending_stairs":
		case "innocent":
			flag_wait( "truck_explodes" );
//			thread musicplaywrapper( "london_westminster_tragic2" );
			break;
		default:
			AssertMsg( "Start point " + level.start_point + " isn't handled by music" );
	}
}
