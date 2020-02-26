// _truck.gsc
// Sets up the behavior for the Opel Blitz (German), Model 94 (Japanese) and GMC (Allied) trucks and variants.
// The Katyusha is seperate from this.

#include maps\_vehicle_aianim;
#include maps\_vehicle;
#using_animtree( "vehicles" );
main( model, type )
{
	build_template( "truck", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_ger_wheeled_opel_blitz", "vehicle_ger_wheeled_opel_blitz_d" );
	build_deathmodel( "vehicle_ger_wheeled_covered_opel_blitz", "vehicle_ger_wheeled_covered_opel_blitz_d" );
	build_deathmodel( "vehicle_ger_wheeled_opel_blitz_winter", "vehicle_ger_wheeled_opel_blitz_winter" );	
	build_deathmodel( "vehicle_jap_wheeled_type94", "vehicle_jap_wheeled_type94_dmg" );
	build_deathmodel( "vehicle_usa_wheeled_gmc_truck", "vehicle_usa_wheeled_gmc_truck" );
	build_deathmodel( "vehicle_usa_wheeled_gmc_truck_winter", "vehicle_usa_wheeled_gmc_truck_winter" );
// MikeD (12/20/2007): Commented this out, as build_predeathfx is no longer supported
//	build_predeathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );
	build_exhaust( "vehicle/exhaust/fx_exhaust_generic_truck" );
	
	if (model == "vehicle_ger_wheeled_opel_blitz")
	{
		build_deathfx( "vehicle/vexplosion/fx_vexplode_opel_blitz", "tag_origin", "explo_metal_rand" );
	}
	else if (model == "vehicle_jap_wheeled_type94")
	{
		build_deathfx( "vehicle/vexplosion/fx_vexplode_jap_t94", "tag_origin", "explo_metal_rand" );
	}
	else
	{
		build_deathfx( "explosions/large_vehicle_explosion", undefined, "explo_metal_rand" );	
	}
	build_deathquake( 0.6, 1.0, 600 );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	build_radiusdamage( (0,0,0), 400, 200, 40, 1 );
	
	if (model == "vehicle_usa_wheeled_gmc_truck"  )
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

init_local()
{
	// SCRIPTER_MOD: JesseS (5/14/2007) - work around for unloadgroup, set a delay and then set the unlodagroup to set it
	// something other than default.
	//wait (0.5);
	//self.unload_group = "all"; 
	
	// SCRIPTER_MOD: JesseS (5/14/200) - 
	// guy_blowup gets called when vehicle blows up, thats why guys are disappearing when the truck explodes

}

set_vehicle_anims( positions )
{
	
	// SCRIPTER_MOD: JesseS (5/12/2007) - Took out anim references
	positions[ 0 ].vehicle_getoutanim = %v_opelblitz_driverdoor_climbout;
//	positions[ 1 ].vehicle_getoutanim = %door_pickup_passenger_climb_out;
//	positions[ 2 ].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
//	positions[ 3 ].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
//
//	positions[ 0 ].vehicle_getinanim = %door_pickup_driver_climb_in;
//	positions[ 1 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
	//positions[ 2 ].vehicle_getinanim = %door_pickup_driver_climb_in;
	//positions[ 3 ].vehicle_getinanim = %door_pickup_passenger_climb_in;
		return positions;

}


#using_animtree( "generic_human" );

setanims()
{
	positions = [];
	num_positios = 10;
	
	for( i =0 ;i < num_positios; i++ )
	{
		positions[ i ] = spawnstruct();
	}
	//	positions[ 0 ].getout_delete = true;
	
	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_passenger";	 
	positions[ 2 ].sittag = "tag_passenger2";
	positions[ 3 ].sittag = "tag_passenger3";
	positions[ 4 ].sittag = "tag_passenger4";
	positions[ 5 ].sittag = "tag_passenger5";
	positions[ 6 ].sittag = "tag_passenger6";
	positions[ 7 ].sittag = "tag_passenger7";
	positions[ 8 ].sittag = "tag_passenger8";
	positions[ 9 ].sittag = "tag_passenger9";

	
	positions[ 0 ].getout = %crew_truck_driver_climbout;
	positions[ 1 ].getout = %crew_truck_passenger_climbout;
	positions[ 2 ].getout = %crew_truck_guy1_climbout;
	positions[ 3 ].getout = %crew_truck_guy2_climbout;
	positions[ 4 ].getout = %crew_truck_guy3_climbout;
	positions[ 5 ].getout = %crew_truck_guy4_climbout;
	positions[ 6 ].getout = %crew_truck_guy5_climbout;
	positions[ 7 ].getout = %crew_truck_guy6_climbout;
	positions[ 8 ].getout = %crew_truck_guy7_climbout;
	positions[ 9 ].getout = %crew_truck_guy8_climbout;

	positions[ 2 ].getout_combat =  %crew_truck_guy1_climbout_fast;	
	positions[ 3 ].getout_combat =  %crew_truck_guy2_climbout_fast;
	positions[ 6 ].getout_combat =  %crew_truck_guy5_climbout_fast;
	positions[ 7 ].getout_combat =  %crew_truck_guy6_climbout_fast;

	positions[ 0 ].getin = %crew_truck_driver_climbin;
	positions[ 1 ].getin = %crew_truck_passenger_climbin;
	positions[ 2 ].getin = %crew_truck_guy1_climbin; 
	positions[ 3 ].getin = %crew_truck_guy2_climbin; 
	positions[ 4 ].getin = %crew_truck_guy3_climbin; 
	positions[ 5 ].getin = %crew_truck_guy4_climbin; 
	positions[ 6 ].getin = %crew_truck_guy5_climbin; 
	positions[ 7 ].getin = %crew_truck_guy6_climbin; 
	positions[ 8 ].getin = %crew_truck_guy7_climbin; 
	positions[ 9 ].getin = %crew_truck_guy8_climbin; 	

	positions[ 0 ].idle = %crew_truck_driver_sit_idle;
	positions[ 1 ].idle = %crew_truck_passenger_sit_idle;
	positions[ 2 ].idle = %crew_truck_guy1_sit_idle;
	positions[ 3 ].idle = %crew_truck_guy2_sit_idle;
	positions[ 4 ].idle = %crew_truck_guy3_sit_idle;
	positions[ 5 ].idle = %crew_truck_guy4_sit_idle;
	positions[ 6 ].idle = %crew_truck_guy5_sit_idle;
	positions[ 7 ].idle = %crew_truck_guy6_sit_idle;
	positions[ 8 ].idle = %crew_truck_guy7_sit_idle;
	positions[ 9 ].idle = %crew_truck_guy8_sit_idle;

	positions[ 0 ].drive_idle = %crew_truck_driver_drive_idle;
	positions[ 1 ].drive_idle = %crew_truck_passenger_drive_idle;               
	positions[ 2 ].drive_idle = %crew_truck_guy1_drive_sit_idle;                
	positions[ 3 ].drive_idle = %crew_truck_guy2_drive_sit_idle;                
	positions[ 4 ].drive_idle = %crew_truck_guy3_drive_sit_idle;                
	positions[ 5 ].drive_idle = %crew_truck_guy4_drive_sit_idle;                
	positions[ 6 ].drive_idle = %crew_truck_guy5_drive_sit_idle;                
	positions[ 7 ].drive_idle = %crew_truck_guy6_drive_sit_idle;                
	positions[ 8 ].drive_idle = %crew_truck_guy7_drive_sit_idle;                
	positions[ 9 ].drive_idle = %crew_truck_guy8_drive_sit_idle;                
                                                 
	positions[ 0 ].drive_reaction = %crew_truck_driver_drive_reaction;
	positions[ 1 ].drive_reaction = %crew_truck_passenger_drive_reaction;
	positions[ 2 ].drive_reaction = %crew_truck_guy1_drive_reaction; 
	positions[ 3 ].drive_reaction = %crew_truck_guy2_drive_reaction; 
	positions[ 4 ].drive_reaction = %crew_truck_guy3_drive_reaction;   
	positions[ 5 ].drive_reaction = %crew_truck_guy4_drive_reaction; 
	positions[ 6 ].drive_reaction = %crew_truck_guy5_drive_reaction; 
	positions[ 7 ].drive_reaction = %crew_truck_guy6_drive_reaction; 
	positions[ 8 ].drive_reaction = %crew_truck_guy7_drive_reaction; 
	positions[ 9 ].drive_reaction = %crew_truck_guy8_drive_reaction; 

	positions[ 0 ].death_shot = %crew_truck_driver_death_shot;
	positions[ 1 ].death_shot = %crew_truck_passenger_death_shot;
	positions[ 2 ].death_shot = %crew_truck_guy1_death_shot; 
	positions[ 3 ].death_shot = %crew_truck_guy2_death_shot; 
	positions[ 4 ].death_shot = %crew_truck_guy3_death_shot;   
	positions[ 5 ].death_shot = %crew_truck_guy4_death_shot; 
	positions[ 6 ].death_shot = %crew_truck_guy5_death_shot; 
	positions[ 7 ].death_shot = %crew_truck_guy6_death_shot; 
	positions[ 8 ].death_shot = %crew_truck_guy7_death_shot; 
	positions[ 9 ].death_shot = %crew_truck_guy8_death_shot; 

	positions[ 0 ].death_fire = %crew_truck_driver_death_fire;
	positions[ 1 ].death_fire = %crew_truck_passenger_death_fire;
	positions[ 2 ].death_fire = %crew_truck_guy1_death_fire; 
	positions[ 3 ].death_fire = %crew_truck_guy2_death_fire; 
	positions[ 4 ].death_fire = %crew_truck_guy3_death_fire;   
	positions[ 5 ].death_fire = %crew_truck_guy4_death_fire; 
	positions[ 6 ].death_fire = %crew_truck_guy5_death_fire; 
	positions[ 7 ].death_fire = %crew_truck_guy6_death_fire; 
	positions[ 8 ].death_fire = %crew_truck_guy7_death_fire; 
	positions[ 9 ].death_fire = %crew_truck_guy8_death_fire; 

	positions[ 2 ].explosion_death = %death_explosion_forward13;
	positions[ 3 ].explosion_death = %death_explosion_left11;
	positions[ 4 ].explosion_death = %death_explosion_left11;
	positions[ 5 ].explosion_death = %death_explosion_back13;
	positions[ 6 ].explosion_death = %death_explosion_forward13;
	positions[ 7 ].explosion_death = %death_explosion_right13;
	positions[ 8 ].explosion_death = %death_explosion_right13;

	// TODO add drive_stand_idle and stand_idle_default for just guyXs

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups[ "all" ] = [];
	unload_groups[ "passengers" ] = [];
	unload_groups[ "rear_passengers" ] = [];	

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

	group = "rear_passengers";
	unload_groups[ group ][ unload_groups[ group ].size ] = 2;
	unload_groups[ group ][ unload_groups[ group ].size ] = 3;
	unload_groups[ group ][ unload_groups[ group ].size ] = 4;
	unload_groups[ group ][ unload_groups[ group ].size ] = 5;
	unload_groups[ group ][ unload_groups[ group ].size ] = 6;
	unload_groups[ group ][ unload_groups[ group ].size ] = 7;
	unload_groups[ group ][ unload_groups[ group ].size ] = 8;
	unload_groups[ group ][ unload_groups[ group ].size ] = 9;	
	
	unload_groups[ "default" ] = unload_groups[ "passengers" ];
	
	return unload_groups;
}
