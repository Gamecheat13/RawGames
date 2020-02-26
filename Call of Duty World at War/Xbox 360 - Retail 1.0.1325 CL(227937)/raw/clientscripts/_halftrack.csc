// _halftrack.csc
// Sets up clientside behavior for halftrack

#include clientscripts\_vehicle;

main(model,type)
{
	
	// TODO temp exhaust fx. will need to be replaced
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_halftrack", true );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "halftrack" );
	build_rumble( "halftrack", "tank_rumble", 0.15, 4.5, 600, 1, 1 );
}


