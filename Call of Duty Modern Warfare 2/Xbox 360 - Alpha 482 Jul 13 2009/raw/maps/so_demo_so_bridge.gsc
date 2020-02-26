#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\so_bridge_code;
#include maps\so_demo_so_bridge_code;
#include maps\_specialops;

// ---------------------------------------------------------------------------------
//	Init
// ---------------------------------------------------------------------------------
main()
{
	default_start( ::start_so_demoman );
	add_start( "so_demoman", ::start_so_demoman, "Demolition Man" );

	PreCacheShader( "waypoint_targetneutral" );

	maps\so_bridge_fx::main();
	maps\createart\so_bridge_art::main();
	maps\so_bridge_anim::main();
	maps\so_bridge_precache::main();
	
	maps\_attack_heli::preLoad();
	maps\_load::main();

	common_scripts\_sentry::main();

	maps\_compass::setupMiniMap("compass_map_so_bridge");

	thread maps\so_bridge_amb::main();
}

// ---------------------------------------------------------------------------------
//	Challenge Initializations
// ---------------------------------------------------------------------------------
start_so_demoman()
{
	so_demoman_init();

	thread music_loop( "bridge_parkade_fight", 271 );

	thread enable_escape_warning();
	thread enable_escape_failure();
	
	thread enable_challenge_timer( "so_demoman_start", "so_demoman_complete" );

	thread fade_challenge_in();
	thread fade_challenge_out( "so_demoman_complete" );

	array_thread( level.players, ::hud_display_cars_remaining );
	array_thread( level.players, ::hud_display_time_bonus );
	array_thread( level.players, ::hud_display_cars_hint );
		
	enable_uav_resources();
	enable_ambient_uavs();
	
	thread enable_bridge_collapse();
	enable_missile_attack_taxi();

	enable_rappel_bridge();
	enable_rappel_bridge_seek();

	enable_troop_flood();
	enable_attack_heli();
	
	enable_rappel_heli_close();
	enable_rappel_heli_far();
}

so_demoman_init()
{
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_demoman_setup_regular();		break;	// Regular
		case 2:	so_demoman_setup_hardened();	break;	// Hardened
		case 3:	so_demoman_setup_veteran();		break;	// Veteran
	}

	enemy_list = getentarray( "player_seek_stages", "script_noteworthy" );
	enemy_list = array_merge( enemy_list, getentarray( "upper_level_enemies", "script_noteworthy" ) );
	enemy_list = array_merge( enemy_list, getentarray( "rappel_bridge_seek", "script_noteworthy" ) );
	enemy_list = array_merge( enemy_list, getentarray( "rappel_bridge", "script_noteworthy" ) );
	enemy_list = array_add( enemy_list, getent( "kill_heli", "targetname" ) );
	array_thread( enemy_list, ::add_spawn_function, ::register_bridge_enemy );
	
	level.vehicle_list = getentarray( "vehicle_undestroyed", "script_noteworthy" );
	level.vehicle_list = array_add( level.vehicle_list, getent( "missile_taxi", "script_noteworthy" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_1" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_3" ) );
	level.vehicle_list = array_add( level.vehicle_list, vehicle_get_slide_car( "slide_car_4" ) );
	foreach ( vehicle in level.vehicle_list )
	{
		if ( vehicle.classname != "script_model" )
			level.vehicle_list = array_remove( level.vehicle_list, vehicle );
	}
	array_thread( level.vehicle_list, ::vehicle_alive_think );

	level.bonus_time_amount = 30;
	level.bonus_count_goal = 5;
	
	level.default_sprint = getdvar( "player_sprintSpeedScale" );
	level.player_sprint_scale = 2;
	setSavedDvar( "player_sprintUnlimited", "1" );
	setSavedDvar( "player_sprintSpeedScale", level.player_sprint_scale );

	foreach ( player in level.players )
		player thread player_wait_for_fire();
}

so_demoman_setup_regular()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_REGULAR" );
}

so_demoman_setup_hardened()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_HARDENED" );
}

so_demoman_setup_veteran()
{
	objective_add( 1, "current", &"SO_DEMO_SO_BRIDGE_OBJ_VETERAN" );
}

// ---------------------------------------------------------------------------------
//	Enable/Disable events
// ---------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------

custom_eog_summary()
{
/*	seconds = 0;
	m_seconds = ( level.challenge_end_time - level.challenge_start_time );

	if ( isdefined( level.challenge_end_time ) && isdefined( level.challenge_start_time ) )
		seconds = int( m_seconds / 1000 );
		
	minutes = 0;
	while ( seconds >= 60 )
	{
		minutes++ ;
		seconds -= 60;
	}
	if ( seconds < 10 )
		seconds = "0" + seconds;
	
	foreach ( player in level.players )
	{
		player set_custom_eog_summary( 1, 1, "@SPECIAL_OPS_UI_TIME" );
		player set_custom_eog_summary( 1, 2, minutes + ":" + seconds );
		                                                        	
		player set_custom_eog_summary( 2, 1, "@SPECIAL_OPS_UI_DIFFICULTY" );
		switch( player.gameskill )
		{
			case 0:
			case 1:	player set_custom_eog_summary( 2, 2, "Regular" ); break;
			case 2:	player set_custom_eog_summary( 2, 2, "Hardened" ); break;
			case 3:	player set_custom_eog_summary( 2, 2, "Veteran" ); break;
		}
		
		player set_custom_eog_summary( 3, 1, "Easy/Solid Kills:" );
		player set_custom_eog_summary( 3, 2, player.solid_kills );
		
		player set_custom_eog_summary( 4, 1, "Heartless Kills:" );
		player set_custom_eog_summary( 4, 2, player.heartless_kills );
		
		player set_custom_eog_summary( 5, 1, "Highest Combo:" );
		player set_custom_eog_summary( 5, 2, player.highest_combo + "x" );
		
		player set_custom_eog_summary( 6, 1, "Total Score:" );
		player set_custom_eog_summary( 6, 2, hud_convert_to_points( player.total_score ) );
	}*/
}

// ---------------------------------------------------------------------------------
enable_uav_resources()
{
	array_thread( getvehiclenodearray( "uav_sound", "script_noteworthy" ), maps\_ucav::plane_sound_node );
	array_thread( getvehiclenodearray( "fire_missile", "script_noteworthy" ), maps\_ucav::fire_missile_node );
}

enable_ambient_uavs()
{
	flag_set( "so_ambient_uavs" );

	thread delayThread( 2, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_01" );
	thread delayThread( 8, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_02" );
	thread delayThread( 20, ::spawn_vehicle_from_targetname_and_drive, "ucav_flyover_03" );
}

// ---------------------------------------------------------------------------------
enable_rappel_bridge()
{
	flag_set( "so_rappel_bridge" );
	array_spawn_function_noteworthy( "rappel_bridge" , ::ai_rappel_think );
}

// ---------------------------------------------------------------------------------
enable_rappel_bridge_seek()
{
	flag_set( "so_rappel_bridge_seek" );
	array_spawn_function_noteworthy( "rappel_bridge_seek" , ::ai_rappel_think, true );
}

// ---------------------------------------------------------------------------------
enable_bridge_collapse()
{
	flag_set( "so_bridge_collapse" );

	precacheModel( "vehicle_coupe_gold" );

	thread collapsed_section_shakes();
	thread bridge_collapse_prep();

	getent( "bridge_collapse", "targetname" ) waittill( "trigger" );
	level notify( "bridge_collapse" );
}

// ---------------------------------------------------------------------------------
enable_missile_attack_taxi()
{
	flag_set( "so_missile_attack_taxi" );
	thread missile_taxi_moves();
}

// ---------------------------------------------------------------------------------
enable_attack_heli()
{
	flag_set( "so_attack_heli" );
	thread attack_heli();
}

// ---------------------------------------------------------------------------------
enable_troop_flood()
{
	flag_set( "so_flood_spawner" );
}

// ---------------------------------------------------------------------------------
enable_rappel_heli_close()
{
	flag_set( "so_rappel_heli_close" );
}

// ---------------------------------------------------------------------------------
enable_rappel_heli_far()
{
	flag_set( "so_rappel_heli_far" );
}