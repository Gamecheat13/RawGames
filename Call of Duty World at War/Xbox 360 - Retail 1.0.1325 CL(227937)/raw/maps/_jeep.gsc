// _jeep.gsc
// Sets up the behavior for the Willys (US), Kubelwagen (German), Horch (German) and the Type 95 scout car (Japanese),
// and the schwimmenwagen.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
main(model,type)
{
	build_template( "jeep", model, type );
	build_localinit( ::init_local );

	build_deathmodel( "vehicle_usa_wheeled_jeep", "vehicle_usa_wheeled_jeep" );
	build_deathmodel( "vehicle_ger_wheeled_horch1a", "vehicle_ger_wheeled_horch1a" );
	build_deathmodel( "vehicle_ger_wheeled_horch1a_backseat", "vehicle_ger_wheeled_horch1a_backseat" );
	build_deathmodel( "vehicle_ger_wheeled_horch1a_winter_backseat", "vehicle_ger_wheeled_horch1a_winter_backseat" );
	build_exhaust( "vehicle/exhaust/fx_exhaust_horch" );

	build_deathquake( 0.5, 1.0, 400 );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	
	if (model == "vehicle_usa_wheeled_jeep")
	{
		build_deathfx( "vehicle/vexplosion/fx_Vexplode_willyjeep", undefined, "explo_metal_rand" );		
		build_team( "allies" );
	}
	else
	{
		build_team( "axis" );
		build_deathfx( "vehicle/vexplosion/fx_vexplode_ger_horch", "tag_origin", "explo_metal_rand" );
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


// Animation set up for AI on the jeep

#using_animtree ("generic_human");
setanims ()
{
	positions = [];
	for(i=0;i<4;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger";
	positions[2].sittag = "tag_passenger2";
	positions[3].sittag = "tag_passenger3";
	
	positions[0].idle = %crew_jeep1_driver_drive_idle;
	positions[1].idle = %crew_jeep1_passenger1_drive_idle;
	positions[2].idle = %crew_jeep1_passenger2_drive_idle;
	positions[3].idle = %crew_jeep1_passenger3_drive_idle;

	positions[0].drive_under_fire = %crew_jeep1_driver_drive_under_fire;
	positions[1].drive_under_fire = %crew_jeep1_passenger1_drive_under_fire;
	positions[2].drive_under_fire = %crew_jeep1_passenger2_drive_under_fire;
	positions[3].drive_under_fire = %crew_jeep1_passenger3_drive_under_fire;

	positions[0].death_shot = %crew_jeep1_driver_death_shot;
	positions[1].death_shot = %crew_jeep1_passenger1_death_shot;
	positions[2].death_shot = %crew_jeep1_passenger2_death_shot;
	positions[3].death_shot = %crew_jeep1_passenger3_death_shot;

	positions[0].death_fire = %crew_jeep1_driver_death_fire;
	positions[1].death_fire = %crew_jeep1_passenger1_death_fire;
	positions[2].death_fire = %crew_jeep1_passenger2_death_fire;
	positions[3].death_fire = %crew_jeep1_passenger3_death_fire;
      
	positions[0].getout = %crew_jeep1_driver_climbout;
	positions[1].getout = %crew_jeep1_passenger1_climbout;
	positions[2].getout = %crew_jeep1_passenger2_climbout;
	positions[3].getout = %crew_jeep1_passenger3_climbout;

	positions[0].getin = %crew_jeep1_driver_climbin;
	positions[1].getin = %crew_jeep1_passenger1_climbin;
	positions[2].getin = %crew_jeep1_passenger2_climbin;
	positions[3].getin = %crew_jeep1_passenger3_climbin;
	
	positions[0].start = %crew_jeep1_driver_start;
	positions[1].start = %crew_jeep1_passenger1_start;
	positions[2].start = %crew_jeep1_passenger2_start;
	positions[3].start = %crew_jeep1_passenger3_start;	

	positions[0].stop = %crew_jeep1_driver_stop;
	positions[1].stop = %crew_jeep1_passenger1_stop;
	positions[2].stop = %crew_jeep1_passenger2_stop;
	positions[3].stop = %crew_jeep1_passenger3_stop;
	
	positions[0].turn_left_light = %crew_jeep1_driver_turn_left_light;
	positions[1].turn_left_light = %crew_jeep1_passenger1_turn_left_light;
	positions[2].turn_left_light = %crew_jeep1_passenger2_turn_left_light;
	positions[3].turn_left_light = %crew_jeep1_passenger3_turn_left_light;
	
	positions[0].turn_left_heavy = %crew_jeep1_driver_turn_left_heavy;
	positions[1].turn_left_heavy = %crew_jeep1_passenger1_turn_left_heavy;
	positions[2].turn_left_heavy = %crew_jeep1_passenger2_turn_left_heavy;
	positions[3].turn_left_heavy = %crew_jeep1_passenger3_turn_left_heavy;	
	
	positions[0].turn_right_light = %crew_jeep1_driver_turn_right_light;
	positions[1].turn_right_light = %crew_jeep1_passenger1_turn_right_light;
	positions[2].turn_right_light = %crew_jeep1_passenger2_turn_right_light;
	positions[3].turn_right_light = %crew_jeep1_passenger3_turn_right_light;
	
	positions[0].turn_right_heavy = %crew_jeep1_driver_turn_right_heavy;
	positions[1].turn_right_heavy = %crew_jeep1_passenger1_turn_right_heavy;
	positions[2].turn_right_heavy = %crew_jeep1_passenger2_turn_right_heavy;
	positions[3].turn_right_heavy = %crew_jeep1_passenger3_turn_right_heavy;		
	
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

