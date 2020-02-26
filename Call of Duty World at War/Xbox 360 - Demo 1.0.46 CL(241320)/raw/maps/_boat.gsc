// _boat.gsc
// Sets up the behavior for the following aircraft:
//
// US:				?
// Japanese:	Japanese Gunboat
// German:		?
// British:		?
// Russuan: 	?
//

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#include common_scripts\utility;
main( model, type )
{
	build_template( "jap_gunboat", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_jap_ship_gunboat", "vehicle_jap_ship_gunboat" );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 99999, 5000, 15000 );
	build_treadfx();
	
	//build_rumble( "tank_rumble", 0.55, 1.75, 2200, 0.1, 0.1 );	// this works well for pel1, let Jesse know if it breaks your map
	//build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
			
	if (model == "vehicle_jap_ship_gunboat" )
	{
		build_team( "axis" );		
	}
	else
	{
		build_team( "allies" );		
	}

}

// When the vehicle spawns, it calls this function, so put vehicle-specific post-spawn stuff here.
// self = the vehicle
init_local()
{

}
