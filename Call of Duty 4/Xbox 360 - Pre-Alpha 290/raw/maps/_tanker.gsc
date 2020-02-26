#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "tanker", model, type );
	build_localinit( ::init_local );
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_drive( %bm21_driving_idle_forward, %bm21_driving_idle_backward, 10 );

	build_team( "allies" );
}

init_local()
{
}
