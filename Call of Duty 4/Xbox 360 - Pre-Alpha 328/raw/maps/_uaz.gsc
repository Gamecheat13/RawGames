#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type, no_death )
{
	build_template( "uaz", model, type );
	build_localinit( ::init_local );
		
	build_destructible( "vehicle_uaz_hardtop_destructible", "vehicle_uaz_hardtop" );
	build_destructible( "vehicle_uaz_light_destructible", "vehicle_uaz_light" );
	build_destructible( "vehicle_uaz_open_destructible", "vehicle_uaz_open" );
	build_destructible( "vehicle_uaz_open_for_ride", "vehicle_uaz_open" );
	build_destructible( "vehicle_uaz_fabric_destructible", "vehicle_uaz_fabric" );
	
	if ( !isdefined( no_death ) )
	{
		build_deathmodel( "vehicle_uaz_fabric", "vehicle_uaz_fabric_dsr" );
		build_deathmodel( "vehicle_uaz_hardtop", "vehicle_uaz_hardtop_dsr" );
		build_deathmodel( "vehicle_uaz_open", "vehicle_uaz_open_dsr" );
		build_deathmodel( "vehicle_uaz_hardtop_thermal", "vehicle_uaz_hardtop_thermal" );
		build_deathmodel( "vehicle_uaz_open_for_ride" );
		build_deathfx( "explosions/small_vehicle_explosion", undefined, "explo_metal_rand" );
	}
	
	build_radiusdamage( (0,0,32) , 300, 200, 100, false );
	build_drive( %uaz_driving_idle_forward, %uaz_driving_idle_backward, 10 );
	build_deathquake( 1, 1.6, 500 );

	
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_aianims( ::setanims , ::set_vehicle_anims );
}

init_local()
{
}


set_vehicle_anims( positions )
{
		return positions;
}



#using_animtree( "generic_human" );

setanims()
{

	positions = [];
	for( i=0;i<6;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy0"; //RR
	positions[ 3 ].sittag = "tag_guy1";  //RR
	positions[ 4 ].sittag = "tag_guy2"; //RR
	positions[ 5 ].sittag = "tag_guy3";  //RR

	positions[ 0 ].idle = %bm21_driver_idle;
	positions[ 1 ].idle = %technical_passenger_idle;
	positions[ 2 ].idle = undefined;
	positions[ 3 ].idle = undefined;
	positions[ 4 ].idle = undefined;
	positions[ 5 ].idle = undefined;
	
	positions[ 0 ].getout = %pickup_driver_climb_out;
	positions[ 1 ].getout = %pickup_passenger_climb_out;
	positions[ 2 ].getout = %pickup_passenger_RR_climb_out;
	positions[ 3 ].getout = %pickup_passenger_RL_climb_out;

	return positions;

}