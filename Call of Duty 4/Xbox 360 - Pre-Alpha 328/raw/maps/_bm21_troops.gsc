#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "bm21_troops", model, type );
	build_localinit( ::init_local );

	build_destructible( "vehicle_bm21_mobile_bed_destructible", "vehicle_bm21_mobile_bed" );
	
	build_deathmodel( "vehicle_bm21_mobile", "vehicle_bm21_mobile_dstry" );  
	build_deathmodel( "vehicle_bm21_mobile_cover", "vehicle_bm21_mobile_cover_dstry" );
	build_deathmodel( "vehicle_bm21_mobile_bed", "vehicle_bm21_mobile_bed_dstry" );
	build_deathmodel( "vehicle_bm21_mobile_cover_no_bench", "vehicle_bm21_mobile_cover_dstry" );  
	
//build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	
	// 	build_deathfx( effect, 								tag, 					sound, 								bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "explosions/large_vehicle_explosion", 	undefined, 				"car_explode", 						undefined, 			undefined, 		undefined, 		0 );
	build_deathfx( "fire/firelp_med_pm", 					"tag_fx_tire_right_r", 	"smallfire", 						undefined, 			undefined, 		true, 			0 );
	build_deathfx( "fire/firelp_med_pm", 					"tag_fx_cab", 			"smallfire", 						undefined, 			undefined, 		true, 			0 );
	build_deathfx( "explosions/small_vehicle_explosion", 	"tag_fx_tank", 			"explo_metal_rand", 					undefined, 			undefined, 		undefined, 		2 );

	build_deathquake( 1, 1.6, 500 );
	build_life( 999, 500, 1500 );
	build_team( "axis" );
	build_treadfx();

	
	build_aianims( ::setanims, ::set_vehicle_anims );
	build_unload_groups( ::Unload_Groups );

	build_light( model, "headlight_truck_left", "tag_headlight_left", "misc/lighthaze", 					"headlights" );
	build_light( model, "headlight_truck_right", "tag_headlight_right", "misc/lighthaze", 				"headlights" );
	build_light( model, "headlight_truck_left2", 		"tag_headlight_left", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "headlight_truck_right2", 		"tag_headlight_right", 		"misc/car_headlight_bm21", 		"headlights" );
	build_light( model, "parkinglight_truck_left_f", 	"tag_parkinglight_left_f", 	"misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_bm21", 	"headlights" );
	build_light( model, "taillight_truck_right", 	 	"tag_taillight_right", 		"misc/car_taillight_bm21", 		"headlights" );
	build_light( model, "taillight_truck_left", 		 	"tag_taillight_left", 		"misc/car_taillight_bm21", 		"headlights" );

	build_light( model, "brakelight_troops_right", 		"tag_taillight_right", 		"misc/car_taillight_bm21", 		"brakelights" );
	build_light( model, "brakelight_troops_left", 		"tag_taillight_left", 		"misc/car_taillight_bm21", 		"brakelights" );

	build_drive( %bm21_driving_idle_forward, %bm21_driving_idle_backward, 10 );
	
}

init_local()
{
// 	maps\_vehicle::lights_on( "headlights" );
// 	maps\_vehicle::lights_on( "brakelights" );

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
	for ( i = 0;i < 10;i ++ )
		positions[ i ] = spawnstruct();

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_guy1";// RR
	positions[ 3 ].sittag = "tag_guy2"; // RR
	positions[ 4 ].sittag = "tag_guy3";// RR
	positions[ 5 ].sittag = "tag_guy4"; // RR
	positions[ 6 ].sittag = "tag_guy5";// RL
	positions[ 7 ].sittag = "tag_guy6"; // RL
	positions[ 8 ].sittag = "tag_guy7";// RL
	positions[ 9 ].sittag = "tag_guy8";// RL
	
	
	
	
	positions[ 2 ].exittag = "tag_detach";
	positions[ 3 ].exittag = "tag_detach";
	positions[ 4 ].exittag = "tag_detach";
	positions[ 5 ].exittag = "tag_detach";
	positions[ 6 ].exittag = "tag_detach";
	positions[ 7 ].exittag = "tag_detach";
	positions[ 8 ].exittag = "tag_detach";
	positions[ 9 ].exittag = "tag_detach";

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
	positions[ 2 ].getout = %bm21_guy1_climbout;
	positions[ 3 ].getout = %bm21_guy2_climbout;
	positions[ 4 ].getout = %bm21_guy3_climbout;
	positions[ 5 ].getout = %bm21_guy4_climbout;
	positions[ 6 ].getout = %bm21_guy5_climbout;
	positions[ 7 ].getout = %bm21_guy6_climbout;
	positions[ 8 ].getout = %bm21_guy7_climbout;
	positions[ 9 ].getout = %bm21_guy8_climbout;
	
	positions[ 2 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 3 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 4 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 6 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 7 ].getout_secondary = %bm21_guy_climbout_landing;
	positions[ 8 ].getout_secondary = %bm21_guy_climbout_landing;

	
//xanim,bm21_guy1_climbout
//xanim,bm21_guy2_climbout
//xanim,bm21_guy3_climbout
//xanim,bm21_guy5_climbout
//xanim,bm21_guy6_climbout
//xanim,bm21_guy7_climbout
//xanim,bm21_guy_climbout_landing


	
	positions[ 2 ].explosion_death = %death_explosion_up10;
	positions[ 3 ].explosion_death = %death_explosion_up10;
	positions[ 4 ].explosion_death = %death_explosion_up10;
	positions[ 5 ].explosion_death = %death_explosion_up10;
	positions[ 6 ].explosion_death = %death_explosion_up10;
	positions[ 7 ].explosion_death = %death_explosion_up10;
	positions[ 8 ].explosion_death = %death_explosion_up10;
	positions[ 9 ].explosion_death = %death_explosion_up10;
	

// 	positions[ 0 ].getin = %pickup_driver_climb_in;
// 	positions[ 1 ].getin = %pickup_passenger_climb_in;

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
