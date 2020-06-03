// _sherman.csc
// Sets up clientside behavior for the sherman

#include clientscripts\mp\_vehicle;

main(model,type)
{
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_sherman" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( "sherman_mp" );
	build_rumble( "sherman_mp", "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
	build_treadfx( "sherman_mp_flm" );
	build_rumble( "sherman_mp_flm", "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
	build_treadfx( "sherman_mp_mg" );
	build_rumble( "sherman_mp_mg", "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
}

