// _tiger.csc
// Sets up clientside behavior for the tiger

#include clientscripts\_vehicle;

main(model,type)
{
	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_tiger" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "see2_tiger" );
	build_rumble( "see2_tiger", "tank_rumble", 0.15, 4.5, 600, 1, 1 );
}

