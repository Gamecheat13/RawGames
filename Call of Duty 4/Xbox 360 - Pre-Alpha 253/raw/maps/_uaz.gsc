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
//	build_aianims( ::setanims , ::set_vehicle_anims );
//	build_unload_groups( ::Unload_Groups );
	
//	build_light( model, "headlight_truck_left", "tag_headlight_left", "misc/lighthaze", 					"headlights" );
//	build_light( model, "headlight_truck_right", "tag_headlight_right", "misc/lighthaze", 				"headlights" );
}

init_local()
{
}
