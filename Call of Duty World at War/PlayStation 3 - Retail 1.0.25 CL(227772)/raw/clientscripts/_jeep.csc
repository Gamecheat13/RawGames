// _jeep.csc
// Sets up clientside behavior for jeeps

#include clientscripts\_vehicle;

main(model,type)
{
	
	// there are several different types of jeep. default to regular jeep if none is specified
	if( !isdefined( type ) )
	{
		type = "jeep";	
	}
	
	one_exhaust = undefined;
	if( type == "horch" )
	{
		one_exhaust = true;	
	}
	
	// TODO temp exhaust fx. will need to be replaced
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_horch", one_exhaust );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( type );
	
}


