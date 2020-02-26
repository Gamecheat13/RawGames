// _t34.gsc
// Sets up the behavior for the T34 tank and variants.

#include maps\_vehicle_aianim;
#include maps\_vehicle;

main(model,type)
{
	build_template( "t34", model, type );
	build_localinit( ::init_local );
	build_deathmodel( "vehicle_rus_tracked_t34", "vehicle_rus_tracked_t34_dmg" );
	build_deathmodel( "vehicle_rus_tracked_t34_wet", "vehicle_rus_tracked_t34_dmg_wet" );
	build_deathmodel( "vehicle_rus_tracked_t34_mg", "vehicle_rus_tracked_t34_dmg" );
	build_shoot_shock( "tankblast" );
	build_shoot_rumble( "tank_fire" );
	//build_drive( %abrams_movement, %abrams_movement_backwards, 10 );
	build_exhaust( "vehicle/exhaust/fx_exhaust_t34" );
	//build_deckdust( "dust/abrams_desk_dust" );
	build_deathfx( "vehicle/vexplosion/fx_vexplode_rus_t34", "tag_origin", "explo_metal_rand" );
	build_turret( "allied_coaxial_mg", "tag_front_turretgun_flash", "weapon_machinegun_tiger", false );
	build_treadfx( type );
	build_life( 999, 500, 1500 );
	build_rumble( "tank_rumble", 0.15, 4.5, 600, 1, 1 );
	build_team( "allies" );
	build_mainturret();
	build_compassicon();
	build_vehiclewalk( 6 );
	build_aianims( ::setanims , ::set_vehicle_anims );
	//build_frontarmor( .33 ); //regens this much of the damage from attacks to the front
	
	if( !IsDefined( type ) )
	{
		type = "t34";
	}
	level.vehicletypefancy[type] = &"VEHICLENAME_T34_TANK";
	
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
	// SRS 5/21/2008: updated to include new anim specifications for tank
	positions = [];
	for(i=0;i<9;i++)
		positions[i] = spawnstruct();

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_passenger4";
	positions[2].sittag = "tag_passenger5";
	positions[3].sittag = "tag_passenger6";
	positions[4].sittag = "tag_passenger7";
	positions[5].sittag = "tag_passenger8";
	positions[6].sittag = "tag_passenger9";
	positions[7].sittag = "tag_passenger10";
	positions[8].sittag = "tag_passenger11";
		
	positions[0].idle = %crew_tank1_commander_idle;
	positions[1].idle = %crew_tank1_passenger4_idle;
	positions[2].idle = %crew_tank1_passenger5_idle;
	positions[3].idle = %crew_tank1_passenger6_idle;
	positions[4].idle = %crew_tank1_passenger7_idle;
	positions[5].idle = %crew_tank1_passenger8_idle;
	positions[6].idle = %crew_tank1_passenger9_idle;
	positions[7].idle = %crew_tank1_passenger10_idle;
	positions[8].idle = %crew_tank1_passenger11_idle;
						
	positions[0].getout = %crew_tank1_commander_dismount;
	positions[1].getout = %crew_tank1_passenger4_dismount;
	positions[2].getout = %crew_tank1_passenger5_dismount;
	positions[3].getout = %crew_tank1_passenger6_dismount;
	positions[4].getout = %crew_tank1_passenger7_dismount;
	positions[5].getout = %crew_tank1_passenger8_dismount;
	positions[6].getout = %crew_tank1_passenger9_dismount;
	positions[7].getout = %crew_tank1_passenger10_dismount;
	positions[8].getout = %crew_tank1_passenger11_dismount;
		
	return positions;
}

