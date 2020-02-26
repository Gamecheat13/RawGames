// _katyusha.csc
// Sets up clientside behavior for the katyusha

#include clientscripts\_vehicle;

main(model,type)
{
	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_rus_rocket_truck", true );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "katyusha" );
	
}

