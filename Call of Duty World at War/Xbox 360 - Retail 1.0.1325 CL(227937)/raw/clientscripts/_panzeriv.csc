// _panzeriv.csc
// Sets up clientside behavior for the panzeriv

#include clientscripts\_vehicle; 

main( model, type )
{
	if( !IsDefined( type ) )
	{
		type = "panzeriv"; 
	}

	build_shoot_rumble( type, "tank_fire" ); 
	build_shoot_shock( type, "tankblast" ); 
	
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_panzerIV", true ); 
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" ); 
	build_treadfx( type ); 
	build_rumble( type, "tank_rumble", 0.15, 4.5, 600, 1, 1 ); 	
}