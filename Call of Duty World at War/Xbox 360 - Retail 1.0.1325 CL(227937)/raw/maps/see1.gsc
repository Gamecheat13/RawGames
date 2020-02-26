

////////////////////////// Seelow 1 ////////////////////////////
////////////////////////////////////////////////////////////////
/* 

Scripter: Alex Liu
Builder: Jason Schoonover

*/
////////////////////////////////////////////////////////////////

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\see1_code;

#include maps\see1_opening;
#include maps\see1_event1;
#include maps\see1_event2;
#include maps\see1_event3;
#include maps\_music;


#using_animtree( "generic_human" );

////////////////////////////////////////////////////////////////
// Preliminary Setup
//

main()
{


// General Flags

	// set this flag when all setup is done, and we can start the main() from specific event gsc
	flag_init( "initial_setup_done" );
	


// OPENING specific
	flag_init( "molotov_tossed" );
	flag_init( "opening_german1_killed" );
	flag_init( "opening_german2_killed" );
	flag_init( "opening_german1_spared" );
	flag_init( "opening_german2_spared" );

// EVENT 2 specific
	flag_init( "ev2_player_fired" );
	flag_init( "river_halfway_reached" );

	flag_init( "ev2_tank1_spawned" );
	flag_init( "ev2_tank2_spawned" );
	flag_init( "ev2_tank3_spawned" );
	flag_init( "ev2_tank4_spawned" );
	flag_init( "ev2_tank5_spawned" );

	flag_init( "ev2_tank1_at_end" );
	flag_init( "ev2_tank2_at_end" );
	flag_init( "ev2_tank3_at_end" );
	flag_init( "ev2_tank4_at_end" );
	flag_init( "ev2_tank5_at_end" );

	flag_init( "ev2_tank1_destroyed" );
	flag_init( "ev2_tank2_destroyed" );
	flag_init( "ev2_tank3_destroyed" );
	flag_init( "ev2_tank4_destroyed" );
	flag_init( "ev2_tank5_destroyed" );

	flag_init( "ev2_tank_friend_in_position" );

	flag_init( "barn_door_anim_ready" );

	level.ev2_tank_1_can_mount = false;
	level.ev2_tank_2_can_mount = false;
	level.ev2_tank_3_can_mount = false;
	level.ev2_player_mounted = false;

	flag_init( "tank_ride_over" );
	flag_init( "tank3_in_position_after_ride" );

// Event 3 Specific

	flag_init( "ev3_halftrack1_mg_killed" );
	flag_init( "ev3_halftrack2_mg_killed" );
	flag_init( "ev3_player_chase" );

	flag_init( "ev3_player_passes_barrier" );
	flag_init( "ev3_flood_spawners_end" );
	flag_init( "truck3_unloading" );

	flag_init( "ending_tank_ready" );
	flag_init( "reznov_on_tank" );

// skip tos

	add_start( "event0", ::start_opening, &"START_SEE1_1_OPENING" );	// burning forest
	add_start( "event1", ::start_event1, &"START_SEE1_2_BURNING_FOREST" );	// burning forest
	add_start( "event2", ::start_event2, &"START_SEE1_3_TANK_BATTLE" );	// farm area
	add_start( "event3", ::start_event3, &"START_SEE1_4_CAMP" );	// camp
	add_start( "outro", ::start_event3_outro, &"START_SEE1_5_OUTRO" );	// outro
	default_start( ::start_opening ); 		// opening buring field sequence

// misc setups

	// This sets up the loading screens, etc.
	level.campaign = "russian";

	// get rid of dynamic water. It's enabled by default and automatically consumes 100,000 polys
	setdvar( "r_watersim_enabled", "0" );

	// setup vehicle
	maps\_t34::main( "vehicle_rus_tracked_t34", "t34" );			// main Russian tank
	maps\_halftrack::main( "vehicle_ger_tracked_halftrack", undefined, false );		// mg mounted halftrack  vehicle_halftrack_mg_woodland
	maps\_truck::main( "vehicle_ger_wheeled_opel_blitz", "opel" ); 	// german truck
	maps\_destructible_opel_blitz::init();

	// setup tank mantling on tiger tank
	// NOTE: Only king tiger supports mantling right now. This could be changed to something else
	PrecacheModel( "viewmodel_rus_guard_player" );
	//PrecacheModel( "viewmodel_rus_guard_arms" );

	maps\_tiger::main( "vehicle_ger_tracked_king_tiger" );
	//maps\_tankmantle::init_models( "viewmodel_rus_guard_player", "fraggrenade" );
	//level.vehicle_shoot_shock[ "vehicle_ger_tracked_king_tiger_d_inter" ] =  "tankblast";

	// Setup russian planes
	// NOTE: This may get taken out
	maps\_stuka::main("vehicle_rus_airplane_il2", "stuka");

 	// setup drones
	level.drone_weaponlist_axis = [];
	level.drone_weaponlist_axis[0] = "gewehr43";
	level.drone_spawnFunction["allies"] = maps\see1_code::custom_drone_spawn_allies;
	level.drone_spawnFunction["axis"] = maps\see1_code::custom_drone_spawn_axis;
	maps\_drones::init();	

	// deployable lmg crew
	maps\_mganim::main();

	// max number of friendlies
	level.maxfriendlies = 3;	// this changes to 5 after opening

	// make fire spread faster on vegetations
	// NOTE: This does not seem to work currently
	setsaveddvar( "fire_spread_probability", 0.9 );

	// threat bias setup
	createthreatbiasgroup("players");	
	createthreatbiasgroup("squad");		// squad with the player

	// cache anything needed
	precache_items();

	//level thread get_explosion_death_dir_test();

	// DEBUG: To check number of live AIs while playing, uncomment this
	//level thread debug_ai_counter();

	//level thread debug_model_debug();

// Standard Setups

	maps\see1_fx::main();		// must be before _load::main
	maps\_load::main();			// must be before the other stuff here
	maps\see1_anim::main();
	level thread maps\see1_amb::main();
	maps\see1_status::main();

	//level.vehicle_shoot_shock[ "vehicle_ger_tracked_king_tiger_d_inter" ] = "tankblast";
	//level.vehicle_mantlefx["vehicle_ger_tracked_king_tiger_d_inter"]["implode"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_implode" );
	//level.vehicle_mantlefx["vehicle_ger_tracked_king_tiger_d_inter"]["cookoff"] 	= LoadFx( "vehicle/vexplosion/fx_vexplode_tiger_turret_cookoff" );
	//level.vehicle_mantlefx["vehicle_ger_tracked_king_tiger_d_inter"]["smoke"] 		= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_billow" );
	//level.vehicle_mantlefx["vehicle_ger_tracked_king_tiger_d_inter"]["smolder"] 	= LoadFx( "vehicle/vfire/fx_vsmoke_tiger_smolder" );

	maps\_vehicle::build_treadfx();


	// initial setup for plane and napalm drops
	level.plane_bomb_model[ "stuka" ] = "aircraft_bomb";
	level.plane_bomb_fx[ "stuka" ] 	= level._effect["dirt_blow_up"];
	level.plane_bomb_sound[ "stuka" ] = "temp_sound"; // temp
	maps\_planeweapons::build_bomb_explosions( "stuka", randomfloatrange(.3,.5), 3, 1000, 700, 250, 1000 );


// once all loading is done, start the level

	// This flag will be set in one of the start functions, once all the setup is done
	flag_wait( "initial_setup_done" );
	


/*
	level.introblack = NewHudElem(); 
	level.introblack.x = 0; 
	level.introblack.y = 0; 
	level.introblack.horzAlign = "fullscreen"; 
	level.introblack.vertAlign = "fullscreen"; 
	level.introblack.foreground = true; 
	level.introblack SetShader( "black", 640, 480 ); 
*/
	//level.introblack FadeOverTime( 1 );
	//level.introblack.alpha = 0; 

	// By now all AIs and players have been setup. level.start_point has been defined. Start the level
	switch( level.start_point )
	{
		case "opening":	opening_main();
		case "event1":	event1_main();
		case "event2":	event2_main();
		case "event3":	event3_main();
		case "event3_outro":	event3_outro_test();
	}
}

debug_model_debug()
{
	wait( 5 );

	players = get_players();

	while( 1 )
	{
		all_models = getentarray( "script_model", "classname" );
		for( i = 0; i < all_models.size; i++ )
		{
			if( all_models[i].model == "char_rus_guard_body1_2" )
			{
				line( players[0].origin, all_models[i].origin, ( 0.9, 0.9, 0.9 ), false );
				print3d( all_models[i].origin + (0,0,40), "*2*", ( 0.9, 0.9, 0.9 ), 1, 3 );
			}
			if( all_models[i].model == "char_rus_guard_body1_1" )
			{
				line( players[0].origin, all_models[i].origin, ( 0.9, 0.9, 0.9 ), false );
				print3d( all_models[i].origin + (0,0,40), "*1*", ( 0.9, 0.9, 0.9 ), 1, 3 );
			}
		}
		wait( 0.05 );
	}
}


// anything particular that needs to be pre-cached
precache_items()
{
	// drone models
	character\char_rus_r_rifle::precache();
	character\char_ger_wrmcht_k98::precache();

	precachemodel( "weapon_rus_molotov_grenade" );
	precachemodel( "weapon_ger_g43_rifle" );

	// panzershreck rocket
	precachemodel( "weapon_ger_panzershreck_rocket" );
	precachemodel( "weapon_ger_panzerschreck_at_obj" );

	// tiger intermediate model
	//precachemodel( "vehicle_ger_tracked_king_tiger_d_inter" );
	precachemodel( "vehicle_ger_wheeled_opel_blitz_d" );
	precachemodel( "vehicle_ger_wheeled_opel_blitz" );

	// russian plane
	precachemodel( "vehicle_rus_airplane_il2" );

	// used in intro anim
	precachemodel( "static_berlin_ger_knife" );
	precachemodel( "anim_seelow_pocketwatch" );
	precachemodel( "static_berlin_books_diary" );

	precachemodel( "anim_seelow_barndoorkick" );
	precachemodel( "anim_seelow_barndoortank" );

	precachemodel("aircraft_bomb");

	precachemodel("weapon_ger_panzerschreck_at");

	precachemodel("mounted_ger_mg42_bipod_mg");
	precachemodel("mounted_ger_fg42_bipod_lmg");

	// tank gears (These are loaded in _t34.csc)
	precachemodel( "vehicle_rus_tracked_t34_seta_body" );
	precachemodel( "vehicle_rus_tracked_t34_seta_turret" );
	precachemodel( "vehicle_rus_tracked_t34_setb_body" );
	precachemodel( "vehicle_rus_tracked_t34_setb_turret" );
	precachemodel( "vehicle_rus_tracked_t34_setc_body" );
	precachemodel( "vehicle_rus_tracked_t34_setc_turret" );	

	precacheRumble("artillery_rumble");
	precacheRumble("damage_heavy");

	// objective strings
	level.obj1_string = &"SEE1_OBJECTIVE1";		// to river
	level.obj2_string = &"SEE1_OBJECTIVE2";		// Choose path
	level.obj1b_string = &"SEE1_OBJECTIVE1_B";		
	level.obj1c_string = &"SEE1_OBJECTIVE1_C";		

	level.obj3a_string = &"SEE1_OBJECTIVE3A"; 	// Eliminate enemy tanks 4
	level.obj3b_string = &"SEE1_OBJECTIVE3B"; 	// Eliminate enemy tanks 3
	level.obj3c_string = &"SEE1_OBJECTIVE3C"; 	// Eliminate enemy tanks 2
	level.obj3d_string = &"SEE1_OBJECTIVE3D"; 	// Eliminate enemy tanks 1
	level.obj3e_string = &"SEE1_OBJECTIVE3E"; 	// Eliminate enemy tanks done
	level.obj4_string = &"SEE1_OBJECTIVE4"; 	// Regroup at barn
	level.obj5_string = &"SEE1_OBJECTIVE5"; 	// Destroy last tank

	level.obj6_string = &"SEE1_OBJECTIVE6"; 	// follow zeitzev into barn
	level.obj7_string = &"SEE1_OBJECTIVE7"; 	// charge up the road

	level.obj8_string = &"SEE1_OBJECTIVE8"; 	// Enter camp
	level.obj9_string = &"SEE1_OBJECTIVE9"; 	// Clear Camp
	level.obj10a_string = &"SEE1_OBJECTIVE10A"; 	// halftracks 2 of 2
	level.obj10b_string = &"SEE1_OBJECTIVE10B"; 	// halftracks 1 of 2
	level.obj10c_string = &"SEE1_OBJECTIVE10C"; 	// halftracks done
	level.obj11_string = &"SEE1_OBJECTIVE11"; 	// to train station
	level.obj12_string = &"SEE1_OBJECTIVE12"; 	// to train station
}

//
////////////////////////////////////////////////////////////////

start_opening()
{
	if( is_german_build() == false )
	{
		level thread players_connect_opening();
	}

	share_screen( get_host(), true, true );

	spawn_friendlies();
	//wait( 0.5 );
	//share_screen( get_host(), true, true );

	if( is_german_build() )
	{
		teleport_friendlies( "german_build_hero1_start", "german_build_hero2_start", "german_build_friend_start" );
		teleport_players( "german_build_player_start" );
	}
	else
	{
		teleport_friendlies( "opening_hero1_start", "opening_hero2_start", "opening_friend_start" );
		teleport_players( "opening_player_start" );
		players_connect_opening();
	}
	prepare_players();

	level.start_point = "opening";
	flag_set( "initial_setup_done" );
}


players_connect_opening()
{
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i] allowstand(true);
		players[i] allowcrouch(false);
		players[i] allowprone(false);
		players[i] setstance("stand");
		players[i] disableWeapons();
		players[i] SetClientDvar( "hud_showStance", "0" ); 
		players[i] SetClientDvar( "compass", "0" ); 
		players[i] SetClientDvar( "ammoCounterHide", "1" );
		players[i] setClientDvar( "miniscoreboardhide", "1" );
	}
}

start_event1()
{
	//  
	spawn_friendlies();
	wait( 0.5 );
	teleport_friendlies( "event1_hero1_start", "event1_hero2_start", "event1_friend_start" );
	teleport_players( "event1_player_start" );
	prepare_players();

	objective_add( 1, "current", level.obj1_string, ( 3537, -2243, -913 ) );

	level.start_point = "event1";
	flag_set( "initial_setup_done" );
}

start_event2()
{
	// 
	spawn_friendlies();
	teleport_friendlies( "event2_hero1_start", "event2_hero2_start", "event2_friend_start" );
	teleport_players( "event2_player_start" );
	prepare_players();
	level.start_point = "event2";
	flag_set( "initial_setup_done" );
}

start_event3()
{
	// 
	spawn_friendlies();
	teleport_friendlies( "event3_hero1_start", "event3_hero2_start", "event3_friend_start" );
	teleport_players( "event3_player_start" );
	prepare_players();

	level.start_point = "event3";
	flag_set( "initial_setup_done" );
}

start_event3_outro()
{
	// 
	spawn_friendlies();
	teleport_friendlies( "event3_hero1_start", "event3_hero2_start", "event3_friend_start" );
	teleport_players( "event3_player_start" );
	prepare_players();

	level.start_point = "event3_outro";
	flag_set( "initial_setup_done" );
}
