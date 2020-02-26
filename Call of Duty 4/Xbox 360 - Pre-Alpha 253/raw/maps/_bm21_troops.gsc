#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bm21_troops", model, type );
	build_localinit( ::init_local );
	
	build_deathmodel( "vehicle_bm21_mobile" );  
	build_deathmodel( "vehicle_bm21_mobile_cover" );
	build_deathmodel( "vehicle_bm21_mobile_bed" );
	build_deathmodel( "vehicle_bm21_mobile_cover_no_bench" );  
	
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );

	build_light( model, "headlight_truck_left", "tag_headlight_left", "misc/lighthaze", 					"headlights" );
	build_light( model, "headlight_truck_right", "tag_headlight_right", "misc/lighthaze", 				"headlights" );
	build_light( model, "headlight_truck_left", 		"tag_headlight_left", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "headlight_truck_right", 		"tag_headlight_right", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "parkinglight_truck_left_f",	"tag_parkinglight_left_f", 	"misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_bm21",	"headlights" );
	build_light( model, "taillight_truck_right",	 	"tag_taillight_right", 		"misc/car_taillight_bm21", 		"headlights" );
	build_light( model, "taillight_truck_left",		 	"tag_taillight_left", 		"misc/car_taillight_bm21", 		"headlights" );

	build_light( model, "brakelight_troops_right", 		"tag_taillight_right", 		"misc/car_taillight_bm21", 		"brakelights" );
	build_light( model, "brakelight_troops_left", 		"tag_taillight_left", 		"misc/car_taillight_bm21", 		"brakelights" );
	
}

init_local()
{
//	maps\_vehicle::lights_on( "headlights" );
//	maps\_vehicle::lights_on( "brakelights" );

}


set_vehicle_anims( positions )
{
	
	positions[ 0 ].vehicle_getoutanim = %bm21_driver_climbout_door;
	positions[ 1 ].vehicle_getoutanim = %bm21_passenger_climbout_door;

		return positions;
}



#using_animtree( "generic_human" );

setanims()
{

/*
bm21_driver_climbout
bm21_driver_climbout_door
bm21_driver_idle
bm21_passenger_climbout
bm21_passenger_climbout_door
bm21_passenger_idle

*/

	positions = [];
	for( i=0;i<10;i++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy1"; //RR
	positions[ 3 ].sittag = "tag_guy2";  //RR
	positions[ 4 ].sittag = "tag_guy3"; //RR
	positions[ 5 ].sittag = "tag_guy4";  //RR
	positions[ 6 ].sittag = "tag_guy5"; //RL
	positions[ 7 ].sittag = "tag_guy6";  //RL
	positions[ 8 ].sittag = "tag_guy7"; //RL
	positions[ 9 ].sittag = "tag_guy8"; //RL

	positions[ 0 ].idle = %bm21_driver_idle;
	positions[ 1 ].idle = %bm21_passenger_idle;
	positions[ 2 ].idle = %pickup_passenger_RR_idle;
	positions[ 3 ].idle = %pickup_passenger_RR_idle;
	positions[ 4 ].idle = %pickup_passenger_RR_idle;
	positions[ 5 ].idle = %pickup_passenger_RR_idle;
	positions[ 6 ].idle = %pickup_passenger_RL_idle;
	positions[ 7 ].idle = %pickup_passenger_RL_idle;
	positions[ 8 ].idle = %pickup_passenger_RL_idle;
	positions[ 9 ].idle = %pickup_passenger_RL_idle;

	positions[ 0 ].getout = %bm21_driver_climbout;
	positions[ 1 ].getout = %bm21_passenger_climbout;
	positions[ 2 ].getout = %pickup_passenger_RR_climb_out;
	positions[ 3 ].getout = %pickup_passenger_RR_climb_out;
	positions[ 4 ].getout = %pickup_passenger_RR_climb_out;
	positions[ 5 ].getout = %pickup_passenger_RR_climb_out;
	positions[ 6 ].getout = %pickup_passenger_RL_climb_out;
	positions[ 7 ].getout = %pickup_passenger_RL_climb_out;
	positions[ 8 ].getout = %pickup_passenger_RL_climb_out;
	positions[ 9 ].getout = %pickup_passenger_RL_climb_out;

//	positions[ 0 ].getin = %pickup_driver_climb_in;
//	positions[ 1 ].getin = %pickup_passenger_climb_in;

	return positions;

}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "all" ] = [];

	group = "passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;

	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;

	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}
