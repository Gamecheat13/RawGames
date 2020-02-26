// _truck.csc
// Sets up clientside behavior for trucks

#include clientscripts\_vehicle;

main(model,type)
{
	
	// there are several different types of truck. default to model94 if none is specified
	if( !isdefined( type ) )
	{
		type = "model94";	
	}
	
	one_exhaust = undefined;
	if( type == "model94" || type == "opel" )
	{
		one_exhaust = true;	
	}	
	
	// TODO temp exhaust fx. will need to be replaced
	build_exhaust( model, "vehicle/exhaust/fx_exhaust_generic_truck", one_exhaust );
	//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx( type );
	
}


