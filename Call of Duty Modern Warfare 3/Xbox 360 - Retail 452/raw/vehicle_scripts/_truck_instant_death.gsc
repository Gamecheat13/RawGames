#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree( "vehicles" );
main( model, type, classname )
{
	vehicle_scripts\_truck::build_truck( model, type, classname );
	build_truck_instant_death( classname );
	build_life( 2750, 2500, 3000 );
}

build_truck_instant_death( classname )
{
	build_deathmodel( "vehicle_pickup_roobars", "vehicle_pickup_roobars_destroyed", 0.1, classname );
	
		//	build_deathfx( effect, 								tag, 					sound, 				bEffectLooping, 	delay, 			bSoundlooping, waitDelay, stayontag, notifyString )
/*  old
	build_deathfx( "explosions/small_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0 );
	build_deathfx( "fire/firelp_small_pm_a", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0 );
	build_deathfx( "fire/firelp_med_pm", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0 );
	build_deathfx( "fire/firelp_small_pm_a", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0 );
*/
/*  tech
	build_deathfx( "fire/firelp_med_pm", 						"tag_fx_tank", 			"smallfire", 		undefined, 			undefined, 		true, 			0 );
	build_deathfx( "explosions/ammo_cookoff", 					"tag_fx_bed", 			undefined, 			undefined, 			undefined, 		undefined, 		0.5 );
//	build_deathfx( "explosions/ammo_cookoff",					"tag_fx_bed",			undefined,			undefined,			undefined,		undefined,		1 );
	build_deathfx( "explosions/Vehicle_Explosion_Pickuptruck", 	"tag_deathfx", 			"car_explode", 		undefined, 			undefined, 		undefined, 		2.9 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			3 );
	build_deathfx( "fire/firelp_med_pm", 						"tag_fx_cab", 			"fire_metal_medium", undefined, 			undefined, 		true, 			3.01 );
	build_deathfx( "fire/firelp_small_pm_a", 					"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			3.01 );
*/

	build_deathfx( "fire/firelp_med_pm_nolight", 					"tag_body", 			"smallfire", 		undefined, 			undefined, 		true, 			0, true );
	build_deathfx( "explosions/small_vehicle_explosion", 	undefined, 				"car_explode", 		undefined, 			undefined, 		undefined, 		0.1, true );
	build_deathfx( "fire/firelp_small_pm_a", 				"tag_fx_tire_right_r", 	"smallfire", 		undefined, 			undefined, 		true, 			0.1, true );
	build_deathfx( "fire/firelp_med_pm_nolight", 					"tag_fx_cab", 			"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	build_deathfx( "fire/firelp_small_pm_a", 				"tag_engine_left", 		"smallfire", 		undefined, 			undefined, 		true, 			0.11, true );
	
	build_radiusdamage( ( 0, 0, 32 ), 200, 150, 0, false, 2 );
}

/*QUAKED script_vehicle_pickup_roobars_instant_death (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_truck_instant_death::main( "vehicle_pickup_roobars", undefined, "script_vehicle_pickup_roobars_instant_death" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_roobars_truck_instant_death
sound,vehicle_truck,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_roobars"
default:"vehicletype" "truck"
default:"script_team" "allies"
*/

/*QUAKED script_vehicle_pickup_roobars_physics_instant_death (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_truck_instant_death::main( "vehicle_pickup_roobars", "truck_physics", "script_vehicle_pickup_roobars_physics_instant_death" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_pickup_roobars_truck_instant_death
sound,vehicle_truck,vehicle_standard,all_sp
sound,vehicle_car_exp,vehicle_standard,all_sp

defaultmdl="vehicle_pickup_roobars"
default:"vehicletype" "truck_physics"
default:"script_team" "allies"
*/