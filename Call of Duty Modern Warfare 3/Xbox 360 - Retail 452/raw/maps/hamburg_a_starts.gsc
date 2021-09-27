#include maps\_utility;
#include maps\hamburg_code;
#include maps\hamburg_landing_zone;
#include maps\hamburg_intro;

main()
{
	describe_start( "ride_in",					::empty,				"Ride In", 			::intro_ride_in );
    describe_start( "beach_landing",			::do_on_foot_start,		"Beach",			::tank_path_beach );
    describe_start( "hot_buildings",			::do_on_foot_start,		"Hot Buildings",	::tank_path_hot_buildings );
    describe_start( "tank_path_pre_bridge",		::do_on_foot_start,		"Bridge",  			::tank_path_pre_bridge );
    describe_start( "tank_path_bridge",			::do_on_foot_start,		"Bridge",  			::tank_path_bridge );
    describe_start( "tank_path_blackout",		::put_player_on_tank,	"Black Out",  		::tank_path_blackout );
    describe_start( "hamburg_garage",			maps\hamburg_garage::common_garage_player_on_tank,	"garage entrance",		maps\hamburg_garage::garage_entrance );
	describe_start( "hamburg_garage_post_entrance",		maps\hamburg_garage::common_garage_player_on_tank, 	"garage post entrance",	maps\hamburg_garage::garage_combat_area );
//	describe_start( "hamburg_garage_three",		maps\hamburg_garage::common_garage_player_on_tank, 	"tank through the garage 3",	maps\hamburg_garage::garage_flashbang );
	describe_start( "hamburg_garage_pre_ramp",	maps\hamburg_garage::common_garage_player_on_tank, 	"garage pre ramp",	maps\hamburg_garage::garage_pre_ramp );
	describe_start( "hamburg_garage_ramp",		maps\hamburg_garage::common_garage_player_on_tank, 	"garage ramp",	maps\hamburg_garage::garage_ramp );
/* 
	stuff for iw_launcher.
	add_start( "tank_crash_exit" );
*/
}

empty()
{	
	
}

