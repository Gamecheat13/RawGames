#include maps\_vehicle;

main( model, type, classname, turret_model, turret_info )
{
	vehicle_scripts\_technical::build_technical( model, type, classname, turret_model, turret_info );
	build_technical_m2_anims();
	build_technical_m2_death( classname );
}

build_technical_m2_anims()
{
	build_aianims( ::setanims, ::set_vehicle_anims );
}

build_technical_m2_death( classname )
{
	build_deathmodel( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", 0.1, classname );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "fire/firelp_med_pm_nolight", 						"tag_fx_tank", 			"smallfire", 		undefined, 			undefined, 		true, 			0 );
//	build_deathfx( "explosions/ammo_cookoff", 					"tag_fx_bed", 			undefined, 			undefined, 			undefined, 		undefined, 		0.05 );
//	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		1 );
	build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck", 	"tag_deathfx", 			"car_explode", 		undefined, 			undefined, 		undefined, 		0.1 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1 );
	build_deathfx( "fire/firelp_med_pm_nolight", 						"tag_fx_cab", 			"fire_metal_medium", undefined, 			undefined, 		true, 		0.11 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11 );
	
	//build_death_badplace( .5, 3, 512, 700, "axis", "allies" );
	build_death_jolt( 0.05 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer> )"
	build_radiusdamage( ( 0, 0, 53 ), 512, 300, 20, true, 0.05 );
}

set_vehicle_anims( positions )
{
	return positions;
}

#using_animtree( "generic_human" );
setanims()
{
	positions = [];
	for ( i = 0; i < 3; i++ )
		positions[ i ] = SpawnStruct();
/*
rough pass

technical_driver_duck
technical_driver_idle
technical_driver_climb_out


technical_passenger_duck
technical_passenger_idle


technical_passenger_climb_out
technical_turret_aim_2
technical_turret_aim_8
technical_turret_death
technical_turret_jam
technical_turret_turn_L
technical_turret_turn_R
door_technical_driver_climb_out
door_technical_passenger_climb_out
*/
//	positions[ 0 ].getout_delete = true;

	positions[ 0 ].sittag = "tag_driver";
	positions[ 1 ].sittag = "tag_gunner";
	positions[ 2 ].sittag = "tag_passenger";

	positions[ 0 ].idle[ 0 ] = %technical_driver_idle;
	positions[ 0 ].idle[ 1 ] = %technical_driver_duck;
	positions[ 0 ].idleoccurrence[ 0 ] = 1000;
	positions[ 0 ].idleoccurrence[ 1 ] = 100;

	positions[ 0 ].death = %technical_driver_fallout;
	positions[ 2 ].death = %technical_passenger_fallout;

	positions[ 0 ].unload_ondeath = .9;
	positions[ 1 ].unload_ondeath = .9;// doesn't have unload but lets other parts know not to delete him.
	positions[ 2 ].unload_ondeath = .9;

/*  no anim for machine gun guy just yet
	positions[ 1 ].idle[ 0 ] = %technical_driver_idle;
	positions[ 1 ].idle[ 1 ] = %technical_driver_duck;
	positions[ 1 ].idleoccurrence[ 0 ] = 1000;
	positions[ 1 ].idleoccurrence[ 1 ] = 100;
*/	
	positions[ 2 ].idle[ 0 ] = %technical_passenger_idle;
	positions[ 2 ].idle[ 1 ] = %technical_passenger_duck;
	positions[ 2 ].idleoccurrence[ 0 ] = 1000;
	positions[ 2 ].idleoccurrence[ 1 ] = 100;

	positions[ 0 ].getout = %technical_driver_climb_out;
//	positions[ 1 ].getout = %humvee_passenger_out_L;
	positions[ 2 ].getout = %technical_passenger_climb_out;

	positions[ 0 ].getin = %pickup_driver_climb_in;
	//positions[ 1 ].getin = %humvee_passenger_in_L;
	//positions[ 2 ].getin = %humvee_passenger_in_R;

//	positions[ 1 ].deathscript = ::deleteme;

//	positions[ 0 ].explosion_death = %death_explosion_left11;
//	positions[ 1 ].explosion_death = %death_explosion_back13;
//	positions[ 2 ].explosion_death = %death_explosion_right13;
//
//	positions[ 0 ].explosion_death_offset = (0,0,-24);
//	positions[ 1 ].explosion_death_offset = (-16,0,-24);
//	positions[ 2 ].explosion_death_offset = (0,0,-24);
//		
//	positions[ 0 ].explosion_death_ragdollfraction = .3;
//	positions[ 1 ].explosion_death_ragdollfraction = .3;
//	positions[ 2 ].explosion_death_ragdollfraction = .3;

	positions[ 1 ].mgturret = 0;// which of the turrets is this guy going to use

	return positions;
}


/*QUAKED script_vehicle_pickup_technical_m2 (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_technical_m2::main( "vehicle_pickup_technical_pb_rusted", undefined, "script_vehicle_pickup_technical_m2", "weapon_truck_m2_50cal_mg", "m2_50cal_turret_technical" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_technical_m2
sound,vehicle_pickup,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_technical_pb_rusted"
default:"vehicletype" "technical"
default:"script_team" "axis"
*/
