
// betty bomber vehicle script

#include maps\_vehicle;
#include common_scripts\utility;
main( model, type )
{	
	// set up the vehicle. (see _vehicle for nicely commented explanations of these functions.)
	build_template( "betty", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_jap_airplane_betty_static", "vehicle_jap_airplane_betty_static" );  // TODO change to actual deathmodel when we get it
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );  // TODO change to actual explosion fx/sound when we get it
	build_life( 99999, 5000, 15000 );
	build_team( "allies" );

}

// When the vehicle spawns, it calls this function, so put vehicle-specific post-spawn stuff here.
// self = the vehicle
init_local()
{

}
