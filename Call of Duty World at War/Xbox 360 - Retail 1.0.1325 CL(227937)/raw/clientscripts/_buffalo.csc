// _buffalo.csc
// Sets up clientside behavior for buffalo

#include clientscripts\_vehicle;

main(model,type)
{
	
	// TODO temp exhaust fx. will need to be replaced
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_lvt" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "buffalo" );
	
}


