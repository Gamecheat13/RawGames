// _amtank.csc
// Sets up clientside behavior for amtank

#include clientscripts\_vehicle;

main(model,type)
{
	
	// TODO temp exhaust fx. will need to be replaced
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_lvt" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "amtank" );
	build_rumble( "amtank", "tank_rumble", 0.15, 4.5, 600, 1, 1 );	
}


