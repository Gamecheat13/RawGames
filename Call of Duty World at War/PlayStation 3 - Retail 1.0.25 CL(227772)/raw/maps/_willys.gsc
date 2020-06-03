// _jeep.gsc
// Sets up the behavior for the Willys (US), Kubelwagen (German) and the Type 95 scout car (Japanese),
// and the schwimmenwagen.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	build_template( "willys", model, type );
	build_localinit( ::init_local );
	//build_deathmodel( "test_willysjeep_cod3", "test_willysjeep_cod3" );
	build_deathmodel( "vehicle_usa_wheeled_jeep", "vehicle_usa_wheeled_jeep" );
	
	build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_treadfx();
	build_life( 999, 500, 1500 );
	
	if (model == "test_willysjeep_cod3")
	{
		build_team( "allies" );
	}
	else if (model == "vehicle_usa_wheeled_jeep")
	{
		build_team( "allies" );
	}
	else
	{
		build_team( "axis" );
	}
	
	build_aianims( ::setanims , ::set_vehicle_anims );
	build_unload_groups( ::unload_groups );


// SCRIPTER_MOD: JesseS (5/12/2007) - Took out lights
// TODO: Re-add sick lights!
	//build_light( model, "headlight_truck_left", 		"tag_headlight_left", 		"misc/car_headlight_truck_L", 		"headlights" );
	//build_light( model, "headlight_truck_right", 		"tag_headlight_right", 		"misc/car_headlight_truck_R", 		"headlights" );
	//build_light( model, "parkinglight_truck_left_f",	"tag_parkinglight_left_f", 	"misc/car_parkinglight_truck_LF", 	"headlights" );
	//build_light( model, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/car_parkinglight_truck_RF",	"headlights" );
	//build_light( model, "taillight_truck_right",	 	"tag_taillight_right", 		"misc/car_taillight_truck_R", 		"headlights" );
	//build_light( model, "taillight_truck_left",		 	"tag_taillight_left", 		"misc/car_taillight_truck_L", 		"headlights" );

	//build_light( model, "brakelight_truck_right", 		"tag_taillight_right", 		"misc/car_brakelight_truck_R", 		"brakelights" );
	//build_light( model, "brakelight_truck_left", 		"tag_taillight_left", 		"misc/car_brakelight_truck_L", 		"brakelights" );


}

// Anthing specific to this vehicle, used globally.
init_local()
{
	
}

// Animtion set up for vehicle anims
#using_animtree ("tank");
set_vehicle_anims(positions)
{
	return positions;
}


// Animation set up for AI on the tank
// 2/21/07 - THESE ARE TEMP ANIMS
#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i=0;i<4;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";
	positions[2].sittag = "tag_guy0";
	positions[3].sittag = "tag_guy1";
	
//	positions[0].idle = %humvee_passenger_idle_R;
//	positions[1].idle = %humvee_passenger_idle_R;
//	positions[2].idle = %humvee_passenger_idle_R;
//	positions[3].idle = %humvee_passenger_idle_R;
//						
//	positions[0].getout = %humvee_passenger_out_R;
//	positions[1].getout = %humvee_passenger_out_R;
//	positions[2].getout = %humvee_passenger_out_R;
//	positions[3].getout = %humvee_passenger_out_R;
//	
//	positions[0].getin = %humvee_passenger_in_R;
//	positions[1].getin = %humvee_passenger_in_R;
//	positions[2].getin = %humvee_passenger_in_R;
//	positions[3].getin = %humvee_passenger_in_R;
	
	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];


	group = "all";
	unload_groups[ group ][ unload_groups[ group ].size ] = 0;
	unload_groups[ group ][ unload_groups[ group ].size ] = 1;
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;

	
	unload_groups[ "default" ] = unload_groups[ "all" ];
	
	return unload_groups;
}

