// _type97.gsc
// Sets up the behavior for the Type 97 Tank and variants.

#include maps\mp\_vehicles;

main(model,type)
{
	build_template( "type97", model, type );
	build_exhaust( "vehicle/exhaust/fx_exhaust_t97" );
	build_treadfx( type );
	build_rumble( "tank_rumble_mp", 0.1, 2, 500, 0.1, 0 );
}