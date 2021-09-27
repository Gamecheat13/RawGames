#include maps\_vehicle;
#include maps\_vehicle_aianim;
#using_animtree( "vehicles" );

main( model, deathmodel, type, classname )
{
	vehicle_scripts\_technical::build_technical( model, type, classname, "weapon_m2_50cal_center", "50cal_turret_technical" );
	vehicle_scripts\_technical::build_technical_anims();
	if ( IsSubStr( classname , "instant_death" ))
	{
		build_technical_instant_death( model, deathmodel, classname );
		build_life( 2750, 2500, 3000 );
	}
	else
	{
		build_technical_death( model, deathmodel, classname );
	}
}

build_technical_death( model, deathmodel, classname )
{
	build_deathmodel( model, deathmodel, 3, classname );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "fire/firelp_med_pm_nolight", 						"tag_fx_tank", 			"smallfire", 		undefined, 			undefined, 		true, 			0 );
	build_deathfx( "explosions/ammo_cookoff", 					"tag_fx_bed", 			undefined, 			undefined, 			undefined, 		undefined, 		0.5 );
//	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		1 );
	build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck", 	"tag_deathfx", 			"car_explode", 		undefined, 			undefined, 		undefined, 		2.9 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			3 );
	build_deathfx( "fire/firelp_med_pm_nolight_hood", 						"tag_fx_cab", 			"fire_metal_medium", undefined, 			undefined, 		true, 			3.01 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			3.01 );
	
	build_death_badplace( .5, 3, 512, 700, "axis", "allies" );
	build_death_jolt( 2.9 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer> )"
	build_radiusdamage( ( 0, 0, 53 ), 512, 175, 20, true, 2.9 );
}

build_technical_instant_death( model, deathmodel, classname )
{
	build_deathmodel( model, deathmodel, 0.1, classname );
	
	//	build_deathfx( effect, 									tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
	build_deathfx( "fire/firelp_med_pm_nolight", 						"tag_fx_tank", 			"smallfire", 		undefined, 			undefined, 		true, 			0 );
	build_deathfx( "explosions/ammo_cookoff", 					"tag_fx_bed", 			undefined, 			undefined, 			undefined, 		undefined, 		0.1 );
//	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		1 );
	build_deathfx( "explosions/Vehicle_Explosion_technical", 	"tag_deathfx", 			"car_explode", 		undefined, 			undefined, 		undefined, 		0.1 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1 );
	build_deathfx( "fire/firelp_med_pm_nolight", 						"tag_fx_cab", 			"fire_metal_medium", undefined, 		undefined, 		true, 			0.11 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11 );
	
	//build_death_badplace( 0.5, 3, 512, 700, "axis", "allies" );
	build_death_jolt( 0.05 );

	//"Name: build_radiusdamage( <offset> , <range> , <maxdamage> , <mindamage> , <bKillplayer> )"
	build_radiusdamage( ( 0, 0, 53 ), 512, 175, 20, true, 0.05 );
}

/*QUAKED script_vehicle_pickup_technical_payback (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_technical_technical_payback
sound,vehicle_pickup,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_technical_pb_rusted"
default:"vehicletype" "technical"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_pickup_technical_payback_physics (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", "technical_physics", "script_vehicle_pickup_technical_payback_physics" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_technical_technical_payback
sound,vehicle_pickup,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_technical_pb_rusted"
default:"vehicletype" "technical_physics"
default:"script_team" "axis"
*/

/*QUAKED script_vehicle_pickup_technical_payback_instant_death (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_technical_payback::main( "vehicle_pickup_technical_pb_rusted", "vehicle_pickup_technical_pb_destroyed", undefined, "script_vehicle_pickup_technical_payback_instant_death" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_technical_technical_payback
sound,vehicle_pickup,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_technical_pb_rusted"
default:"vehicletype" "technical"
default:"script_team" "axis"
*/
