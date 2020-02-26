#include common_scripts\utility;
#include maps\_utility;
#include maps\_specialops;
#include maps\so_escape_airport_code;
#include maps\airport_code;

/*------------------- tweakables -------------------*/

CONST_seeker_accuracy_nerf = 0.65;	// % of accuracy multiplier

CONST_regular_obj	= &"SO_ESCAPE_AIRPORT_OBJ_REGULAR";
CONST_hardened_obj	= &"SO_ESCAPE_AIRPORT_OBJ_HARDENED";
CONST_veteran_obj	= &"SO_ESCAPE_AIRPORT_OBJ_VETERAN";

/*------------------- tweakables -------------------*/

main()
{
	level.so_compass_zoom = "close";
	
	// Special Op mode deleting all original spawn triggers, vehicles and spawners
	//	::type_script_model_civilian
	//	::type_spawners
	//	::type_vehicle
	//	::type_spawn_trigger
	//	::type_trigger
	
	so_delete_all_by_type( ::type_spawn_trigger, ::type_vehicle, ::type_spawners, ::type_script_model_civilian );
	
	default_start( ::start_so_escape );
	add_start( "so_escape", ::start_so_escape );
	
	maps\createart\airport_art::main();
	maps\createfx\airport_audio::main();
	maps\createfx\airport_fx::main();
	maps\airport_fx::main();
	
	common_scripts\_destructible_types_anim_light_fluo_on::main();
	
	maps\_load::main();
	
	maps\_compass::setupMiniMap( "compass_map_airport" );
}

start_so_escape()
{
	so_escape_airport_init();

	foreach( enemy_group, delete_num in level.enemy_remove_trigs )
		thread past_enemy_remove( enemy_group, delete_num );
	
	music_loop( "airport_anticipation", 45 );
	
	thread fade_challenge_in();
	thread fade_challenge_out( "escaped_terminal" );
	thread enable_triggered_start( "start_terminal" );
	thread enable_triggered_complete( "escaped_trigger", "escaped_terminal", "all" );
	thread enable_challenge_timer( "start_terminal", "escaped_terminal" );
}

so_escape_airport_init()
{
	flag_init( "escaped_terminal" );
	flag_init( "start_terminal" );
	flag_init( "challenge_success" );

	/*dummy*/flag_init( "escaped_trigger" );
	
	thread glass_elevator_setup();
	
	level.seeker_accuracy_nerf = CONST_seeker_accuracy_nerf;
	level.enemy_remove_trigs = [];
	
	add_global_spawn_function( "axis", ::enemy_register );
	
	// enemy_move_to_struct( move trigger, seek_goalradius, stay, duration of stay before seeking )
	
	// security stairs wave
	array_spawn_function_noteworthy( "security_stairs", 		::enemy_seek_player, 512 );
	level.enemy_remove_trigs[ "security_stairs" ] 				= 0;	// <= 0 means remove all
	
	// riotshield wave at the shops
	array_spawn_function_noteworthy( "riotshield_shops", 		::enemy_move_to_struct, "riotshield_shops", 512 );
	level.enemy_remove_trigs[ "riotshield_shops" ] 				= 1;
	
	// accompanying security to riotshield wave
	array_spawn_function_noteworthy( "security_accompanying_riotshield_shops", 	::enemy_seek_player, 1024 );
	level.enemy_remove_trigs[ "security_accompanying_riotshield_shops" ] 	= 0;
	
	// secuirty wave and ambush wave at the shops
	array_spawn_function_noteworthy( "security_shops", 			::enemy_seek_player, 1024 );
	level.enemy_remove_trigs[ "security_shops" ] 				= 1;
	level.enemy_remove_trigs[ "security_shops_ambush" ] 		= 0;
	
	// riotshield wave coming from the ground floor towards resturaunts
	array_spawn_function_noteworthy( "riotshield_ground", 		::enemy_move_to_struct, undefined, 1024, true, 20 );
	level.enemy_remove_trigs[ "riotshield_ground" ] 			= undefined;

	// security wave coming from the ground floor towards resturaunts
	array_spawn_function_noteworthy( "security_ground", 		::enemy_seek_player, 1024 );
	level.enemy_remove_trigs[ "security_ground" ] 				= undefined;

	// security wave coming from the ground floor towards resturaunts
	array_spawn_function_noteworthy( "security_elevator", 		::enemy_seek_player, 1500 );
	level.enemy_remove_trigs[ "security_elevator" ] 			= undefined;
	
	array_spawn_function_noteworthy( "riotshield_exit", 		::enemy_move_to_struct, undefined, 512, true, 60 );
		
	hide_destroyed_parts();
	
	assert( isdefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:	// Easy
		case 1:	so_setup_regular();		break;	// Regular
		case 2:	so_setup_hardened();	break;	// Hardened
		case 3:	so_setup_veteran();		break;	// Veteran
	}

	escape_obj_origin = getstruct( "terminal_objective", "script_noteworthy" ).origin;
	Objective_Add( 1, "current", level.challenge_objective, escape_obj_origin );
}

so_setup_regular()
{
	level.challenge_objective 	= CONST_regular_obj;
}

so_setup_hardened()
{
	level.challenge_objective 	= CONST_hardened_obj;
}

so_setup_veteran()
{
	level.challenge_objective 	= CONST_veteran_obj;
}