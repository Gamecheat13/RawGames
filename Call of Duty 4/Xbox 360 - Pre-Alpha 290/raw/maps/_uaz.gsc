#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "uaz", model, type );
	build_localinit( ::init_local );
		
	build_deathmodel( "vehicle_uaz_fabric", "vehicle_uaz_fabric_dsr" );
	build_deathmodel( "vehicle_uaz_hardtop", "vehicle_uaz_hardtop_dsr" );
	build_deathmodel( "vehicle_uaz_open", "vehicle_uaz_open_dsr" );
	build_deathmodel( "vehicle_uaz_open_for_ride" );
	
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	
	build_treadfx();
	build_life( 999, 500, 1500 );
	build_team( "allies" );
	build_aianims( ::setanims , ::set_vehicle_anims );
//	build_unload_groups( ::Unload_Groups );
	
//	build_light( model, "headlight_truck_left", "tag_headlight_left", "misc/lighthaze", 					"headlights" );
//	build_light( model, "headlight_truck_right", "tag_headlight_right", "misc/lighthaze", 				"headlights" );
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
	positions[ 1 ].idle = undefined;
	positions[ 2 ].idle = undefined;
	positions[ 3 ].idle = undefined;
	positions[ 4 ].idle = undefined;
	positions[ 5 ].idle = undefined;

	return positions;

}