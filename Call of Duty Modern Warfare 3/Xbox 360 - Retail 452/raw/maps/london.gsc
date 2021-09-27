#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\london_code;

/*

london.map>
    london_sky_vis.map>
    london_script.map>
    london_art.map>
    london_docks_script.map>
        london_docs_geo.map>
            london_UPPER_REFERENCE.map> <-DO NOT COMPILE
    westminster_script.map>
        westminster_geo.map>
            london_UPPER_REFERENCE.map> <-DO NOT COMPILE
    london_west_script.map>
        london_west_geo.ap>
            london_UPPER_REFERENCE.map> <-DO NOT COMPILE

Just so we can see the sky and shared script entites from everywhere, visibility in the geo maps. Those guys can Step Down in Radiant to see the sky without having to step up to the top level.
london_UPPER_REFERENCE.map>
   london_art.map>
   london_sky_vis>
   london_script>

Now a Sectioned off Test map would look like this:

wesminster.map>
    london_sky_vis.map>
    london_script.map>
    london_art.map>
    westminster_script.map>
        westminster_geo.map>
            london_UPPER_REFERENCE.map> <-DO NOT COMPILE

We make an exception for london_UPPER_REFERENCE as a prefab that can be Loaded drawn multiple(hidden referenced layers) shared assets anyway.

This structure makes stepping down into the geometry layer faster. Partitioning those sections and managing becomes a lot easier.

REFERENCE Layers as a style should be giant ugly uppercase. This to make them pop in changelists.            
`
In much the same way a test sections script should not look a whole lot different than root london.gsc but with the other start descriptions pulled out.

*/

main()
{
	test_ending_gas();

	// Level Callbacks so innocent and london can play nicely
	level.level_callbacks = [];
	add_callback( "westminster_anim", maps\westminster_tunnels_anim::main );
	add_callback( "force_door_shut", maps\westminster_tunnels_anim::force_door_shut );
	add_callback( "manage_player_position", maps\westminster_truck_movement::manage_player_position );
	add_callback( "stop_manage_player_position", maps\westminster_truck_movement::stop_manage_player_position );

	// Any custom starts that need to do something before _load.
//	starts_preload_init();
	maps\createart\london_art::main();
	maps\london_precache::main();
	maps\london_fx::main();

	level_precache();

	maps\london_docks::pre_load();

	

	maps\westminster_tunnels::pre_load();
//	maps\london_west::pre_load();
    
	maps\london_docks_script_starts::main();
    maps\westminster_starts::main();
    
//	describe_start( "west_station",			maps\london_west::start_west_station,			"Westminster Station",		maps\london_west::west_station	);
// 	describe_start( "west_ending",			maps\london_west::start_west_ending,			"Westminster",				maps\london_west::west_ending	);
// 	describe_start( "west_ending_stairs",	maps\london_west::start_west_ending_stairs,		"Westminster Stairs",		maps\london_west::west_ending	);
// 	describe_start( "west_ending_explosion",maps\london_west::start_west_ending_explosion,	"Westminster Explosion" );
	
	maps\london_starts::main();

	SetSavedDvar( "sm_lightscore_eyeprojectdist", 4000 );
	SetSavedDvar( "sm_qualitySpotShadow", 1 );
	SetSavedDvar( "r_specularColorScale", 2 );
	SetSavedDvar( "sm_sunShadowScale", 0.5 );

	SetNorthYaw( 90 );

	maps\_load::main();
	
	init_level();
	
	maps\london_starts::start_thread();
}

test_ending_gas()
{
/#
	if ( GetDvar( "test_ending_gas" ) != "1" )
	{
		return;
	}

	PrecacheModel( "vehicle_uk_delivery_truck_flir" );

	foreach ( index, struct in level.struct )
	{
		if ( Isdefined( struct.script_noteworthy ) )
		{
			if ( struct.script_noteworthy == "createfx_ending_truck" )
			{
				model = Spawn( "script_model", struct.origin );
				model.angles = struct.angles;
				model SetModel( "vehicle_uk_delivery_truck_flir" );
			}
		}
	}

	thread test_ending_gas_thread();
#/
}

test_ending_gas_thread()
{
/#
	while ( 1 )
	{
		wait( 2 );
		level.player vision_set_fog_changes( "london_westminster_post_explosion", 1 );

		while ( !level.player UseButtonPressed() )
		{
			wait( 0.05 );
		}

		exploder( "ending_gas_start" );
		wait( 2 );

		while ( !level.player UseButtonPressed() )
		{
			wait( 0.05 );
		}

		stop_exploder( "ending_gas_start" );

		exploder( "ending_gas_small" );

		wait( 2 );
		while ( !level.player UseButtonPressed() )
		{
			wait( 0.05 );
		}
		stop_exploder( "ending_gas_small" );

		exploder( "ending_gas_full" );

		wait( 2 );
		while ( !level.player UseButtonPressed() )
		{
			wait( 0.05 );
		}

		stop_exploder( "ending_gas_full" );
	}
#/
}

//starts_preload_init()
//{
//	if ( GetDvar( "start" ) == "west_ending_explosion" )
//	{
//		level.ending_preload_cars = [];
//		cars = [];
//
//		foreach ( index, struct in level.struct )
//		{
//			if ( !IsDefined( struct.script_noteworthy ) )
//			{
//				continue;
//			}
//
//			if ( struct.script_noteworthy == "ending_static_cars" )
//			{
//				cars[ cars.size ] = struct;
//			}
//		}
//
//		foreach ( car in cars )
//		{
//			struct = SpawnStruct();
//			struct.origin = car.origin;
//			struct.angles = car.angles;
//			level.ending_preload_cars[ car.script_index ] = struct;
//		}
//	}
//}

