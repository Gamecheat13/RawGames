// _artillery.csc
// Sets up clientside behavior for artillery

#include clientscripts\_vehicle;

main(model,type)
{
	
	// there are several different types of artillery. default to at47 if none is specified
	if( !isdefined( type ) )
	{
		type = "at47";	
	}
	
	// TODO temp exhaust fx. will need to be replaced
	//build_exhaust( model, "vehicle/exhaust/fx_exhaust_sherman" );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( type );
	
}


