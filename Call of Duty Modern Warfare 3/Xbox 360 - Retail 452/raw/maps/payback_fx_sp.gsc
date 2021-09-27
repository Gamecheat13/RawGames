#include maps\_utility;
#include maps\_sandstorm;
#include maps\_shg_fx;
#include common_scripts\utility;
main()
{
///////////////
// Intro
///////////////
	// Treadfx
	level._effect["pb_jeep_trail"] 									= loadfx("treadfx/pb_jeep_trail");	
	level._effect["pb_jeep_trail_water"] 							= loadfx("treadfx/pb_jeep_trail_water");	
	level._effect["pb_jeep_trail_water_left"] 						= loadfx("treadfx/pb_jeep_trail_water_left");	
	level._effect["pb_jeep_trail_road"] 							= loadfx("treadfx/pb_jeep_trail_road");	
	level._effect["pb_jeep_trail_road_skid"] 						= loadfx("treadfx/pb_jeep_trail_road_skid");		
	level._effect["tread_water_ac130"] 								= loadfx("treadfx/tread_water_ac130");
	level._effect["sand_vehicle_impact"] 							= loadfx("Sand/sand_vehicle_impact");
	level._effect["tread_water_jeep"]								= loadfx("treadfx/tread_water_jeep");
	// Birds
	///level._effect["birds_takeoff_seagull"]						= loadfx("misc/birds_takeoff_seagull");	
	///level._effect["bird_seagull_flock_large"] 					= loadfx("misc/bird_seagull_flock_large");
	// Gate
	level._effect["gate_metal_impact"]								= loadfx("maps/payback/gate_metal_impact");
	level._effect["car_glass_large_moving"]							= loadfx("props/car_glass_large_moving");
	// Chopper
	//level._effect["a10_explosion"] 									= loadfx("explosions/a10_explosion");
	level._effect["f15_missile"] 									= loadfx("smoke/smoke_geotrail_sidewinder");
	// Wall
	level._effect["sand_wall_payback_still_lg"] 					= loadfx("sand/sand_wall_payback_still_lg");
///////////////
/// Docks
///////////////
	// Mortar
	level._effect["mortar_flash_120"] 									= loadfx("muzzleflashes/mortar_flash_120");
	level._effect["mortarexp_mud_nofire"] 							= loadfx("explosions/mortarexp_mud_nofire");
	level._effect["mortarExp_water"] 								= loadfx("explosions/mortarExp_water");
	// Barrels
	level._effect["aerial_explosion_large_linger"] 					= loadfx("explosions/aerial_explosion_large_linger");
	// Guard tower?
	level._effect["thick_building_fire_small"] 						= loadfx("fire/thick_building_fire_small");
	// Ambient
	///level._effect["trash_spiral_runner_nodust"] 					= loadfx("misc/trash_spiral_runner_nodust");
///////////////
//	Breach
///////////////
	// Gas
	level._effect["payback_spark_sm"] 								= loadfx("maps/payback/payback_spark_sm");
	level._effect["payback_interrogation_gas_runner_0"] 			= loadfx("maps/payback/payback_interrogation_gas_runner_0");
	level._effect["payback_interrogation_gas1"] 					= loadfx("maps/payback/payback_interrogation_gas1");
	level._effect["payback_interrogation_gas2"] 					= loadfx("maps/payback/payback_interrogation_gas2");
	level._effect["payback_interrogation_gas3"] 					= loadfx("maps/payback/payback_interrogation_gas3");
	level._effect["payback_interrogation_gas4"] 					= loadfx("maps/payback/payback_interrogation_gas4");
	///level._effect["poisonous_gas_ground_payback_200_light"]		= loadfx("smoke/poisonous_gas_ground_payback_200_light");	
	// Blood / Impacts / Firing
	level._effect["waraabe_head_shot"] 								= loadfx("maps/payback/waraabe_head_shot");
	level._effect["waraabe_blood_drips"] 							= loadfx("maps/payback/waraabe_blood_drips");
	level._effect["waraabe_leg_shot"] 								= loadfx("maps/payback/waraabe_leg_shot");
	level._effect["flesh_hit_splat_exaggerated2"]				= loadfx("impacts/flesh_hit_splat_exaggerated2");
	level._effect["pistol_muzzle_flash"] 							= loadfx("muzzleflashes/pistolflash");
	level._effect["pistol_shell_eject"] 							= loadfx("shellejects/pistol");
	level._effect["waraabe_leg_kick"]								= loadfx("maps/payback/waraabe_leg_kick");
	level._effect["flesh_hit_body_fatal_exit"]						= loadfx("impacts/flesh_hit_body_fatal_exit");	
	// Breach
	level._effect["breach_door_payback"]					 		= loadfx("explosions/breach_door_payback");
///////////////
//	Chopper Impacts
///////////////
	level._effect["remote_chopper_default"]							= loadfx("explosions/remote_chopper_default");
	level._effect["remote_chopper_dirt"]							= loadfx("explosions/remote_chopper_dirt");
	level._effect["remote_chopper_metal"]							= loadfx("explosions/remote_chopper_metal");
	level._effect["remote_chopper_water"]							= loadfx("explosions/remote_chopper_water");
	level._effect["thermal_body_gib"] 								= loadfx("impacts/thermal_body_gib");
	level._effect["wood_plank2"] 									= loadfx("props/wood_plank2");
	level._effect["fire_smoke_trail_L"] 							= loadfx("fire/fire_smoke_trail_L");
///////////////
// Water //
///////////////
	///level._effect["water_wake_pb"]				 				= loadfx("water/water_wake_pb");
	///level._effect["water_wake_pb2"]				 				= loadfx("water/water_wake_pb2");
	///level._effect["water_wake_wave_runner"]				 		= loadfx("water/water_wake_wave_runner");
	///level._effect["water_wake_wave_runner_sm"]				 	= loadfx("water/water_wake_wave_runner_sm");
	///level._effect["water_wave_splash_runner"] 					= loadfx("water/water_wave_splash_runner");	
///////////////
// Rescue //
///////////////
	level._effect["dust_kickup"] 									= loadfx("dust/dust_kickup_slide_runner");
	level._effect["dust_kickup_player"] 							= loadfx("dust/dust_kickup_slide_runner_player");
	level._effect["jeep_screen_glow_01"] 							= loadfx("misc/jeep_screen_glow_01");	
	level._effect["payback_headlights_view"]						= loadfx("maps/payback/payback_headlights_view");
	level._effect["car_taillight_uaz_pb"] 							= loadfx("misc/car_taillight_uaz_pb");
	
///////////////
// Construction //
///////////////
	// Wall
	///level._effect["wall_dust_crumble"]					 		= loadfx("dust/wall_dust_crumble");
	///level._effect["payback_sand_wall_impact"]					= loadfx("maps/payback/payback_sand_wall_impact");
	level._effect["payback_sand_wall_shake"]					 	= loadfx("maps/payback/payback_sand_wall_shake");
	///level._effect["roof_debris"] 								= loadfx("misc/roof_debris");
	// Chopper crash
	///level._effect["heli_rotor_rooftop"]					 		= loadfx("maps/payback/heli_rotor_rooftop");
	level._effect["fx_sparks_impact"]					 			= loadfx("maps/payback/fx_sparks_impact");
	///level._effect["payback_const_chopper_wood_splint"]			= loadfx("maps/payback/payback_const_chopper_wood_splint");
	///level._effect["payback_const_chopper_wood_splintb"]			= loadfx("maps/payback/payback_const_chopper_wood_splintb");
	level._effect["payback_const_chopper_spark_runner"]				= loadfx("maps/payback/payback_const_chopper_spark_runner");
	///level._effect["payback_const_chopper_concrete_splat"]		= loadfx("maps/payback/payback_const_chopper_concrete_splat");
	///level._effect["payback_const_chopper_concrete_splatb"]		= loadfx("maps/payback/payback_const_chopper_concrete_splatb");
	level._effect["helicopter_explosion_secondary_small"] 			= loadfx("explosions/helicopter_explosion_secondary_small");
	level._effect["smoke_geotrail_rpg"] 							= loadfx("smoke/smoke_geotrail_rpg");
	// Rappel //
	level._effect["debri_explosion"] 								= loadfx("explosions/debri_explosion");
	// Sandstorm
	level._effect["sand_wall_payback_still"] 						= loadfx("sand/sand_wall_payback_still");
///////////////
// Sandstorm //
///////////////
	// Windows
	///level._effect["payback_window_glow"]					 		= loadfx("maps/payback/payback_window_glow");
	///level._effect["payback_window_glow2"]					 	= loadfx("maps/payback/payback_window_glow2");
	///level._effect["payback_window_glow2_rt90"]					= loadfx("maps/payback/payback_window_glow2_rt90");		
	///level._effect["payback_window_glow3"]					 	= loadfx("maps/payback/payback_window_glow3");
	///level._effect["payback_window_glow4"]					 	= loadfx("maps/payback/payback_window_glow4");
	// Glows
	///level._effect["horizon_fireglow_sm"]							= loadfx("maps/payback/horizon_fireglow_sm");
	///level._effect["horizon_fireglow"]							= loadfx("maps/payback/horizon_fireglow");	
	///level._effect["horizon_fireglow_corner"]						= loadfx("maps/payback/horizon_fireglow_corner");		
	///level._effect["horizon_fireglow_lg"]							= loadfx("maps/payback/horizon_fireglow_lg");
	// Drifts / debris
	level._effect["sand_rooftop_aftermath_close"] 					= loadfx("dust/sand_rooftop_aftermath_close");
	level._effect["sand_rooftop_aftermath"] 						= loadfx("dust/sand_rooftop_aftermath");
	///level._effect["payback_blown_debris1"] 						= loadfx("maps/payback/payback_blown_debris1");
	///level._effect["sand_spray_rooftop_oriented_dark_runner"] 	= loadfx("sand/sand_spray_rooftop_oriented_dark_runner");
	// Lights
	///level._effect["payback_light_street_flicker"]				= loadfx("maps/payback/payback_light_street_flicker");
 	///level._effect["payback_light_street"]					 	= loadfx("maps/payback/payback_light_street"); 	
	///level._effect["flare_ambient"]								= loadfx("misc/flare_ambient_payback");
	level._effect["lights_point_white_payback"] 					= loadfx("misc/light_glow_white_payback");
	level._effect["lights_flashlight_sandstorm_offset"] 			= loadfx("lights/lights_flashlight_sandstorm_offset");
 		// Jeep
		level._effect["lights_flashlight_sandstorm"] 				= loadfx("lights/lights_flashlight_sandstorm");
	// Fires
	///level._effect["electrical_transformer_blacksmoke_fire"] 		= loadfx("fire/electrical_transformer_blacksmoke_fire");
 	///level._effect["payback_powerline_runner"]					= loadfx("maps/payback/payback_powerline_runner"); 	
	///level._effect["payback_fire_transformer_md"] 				= loadfx("maps/payback/payback_fire_transformer_md");
  	///level._effect["payback_fire_ground_embers"]					= loadfx("maps/payback/payback_fire_ground_embers");
		// Crash
 		///level._effect["heli_crash_fire_payback"] 				= loadfx("fire/heli_crash_fire_payback");
 		///level._effect["payback_fire_sm_runner"]					= loadfx("maps/payback/payback_fire_sm_runner");	/// 
 		/// 
 	
///////////////
// City //
///////////////
	///level._effect["sand_spray_detail_oriented_runner_400x400_puff"] = loadfx("sand/sand_spray_detail_oriented_runner_400x400_puff");
	///level._effect["sand_spray_detail_oriented_runner_0x0"] 		= loadfx("sand/sand_spray_detail_oriented_runner_0x0");
	level._effect["sand_wall_payback_still_md"] 					= loadfx("sand/sand_wall_payback_still_md");
	level._effect["rock_impact_large"] 								= loadfx("explosions/rock_impact_large");
	level._effect["rollcar_fire_hood"] 								= loadfx("fire/firelp_med_pm_nolight_hood");
	level._effect["rollcar_fire_body"]	 							= loadfx("explosions/ammo_cookoff");
	level._effect["rollcar_death"] 									= loadfx("explosions/Vehicle_Explosion_Pickuptruck");
	///level._effect["payback_car_blacksmoke_wind"] 				= loadfx("maps/payback/payback_car_blacksmoke_wind");
	level._effect["sand_extreme_placed"] 							= loadfx("sand/sand_extreme_placed");
	
	
///////////////
// Ambient //
///////////////
	///level._effect["gnats"] 							 			= loadfx("misc/gnats");	
	///level._effect["paper_blowing_trash"]							= loadfx("misc/paper_blowing_trash");
	///level._effect["paper_blowing_trash_fast"] 					= loadfx("misc/paper_blowing_trash_fast");
	///level._effect["sand_blowing"] 								= loadfx("sand/sand_blowing");
	///level._effect["leaves_blowing_light"] 						= loadfx("misc/leaves_blowing_light");
	level._effect["blank"]											= loadfx("misc/blank");
	///level._effect["sand_blowing_dark"] 							= loadfx("sand/sand_blowing_dark");
	///level._effect["light_dust_motes_blowing"]					= loadfx("dust/light_dust_motes_blowing");
	///level._effect["light_dust_motes_blowing_slow"]				= loadfx("dust/light_dust_motes_blowing_slow");
	///level._effect["payback_sand_spray_detail"]					= loadfx("maps/payback/payback_sand_spray_detail");
	///level._effect["payback_sand_rooftop"]					 	= loadfx("maps/payback/payback_sand_rooftop");			
	///level._effect["payback_sand_rooftop_sm"]					 	= loadfx("maps/payback/payback_sand_rooftop_sm");
	///level._effect["payback_fog_ground_200_lite"]					= loadfx("maps/payback/payback_fog_ground_200_lite");
	///level._effect["firelp_med_pm_nolight_pb"] 						= loadfx("fire/firelp_med_pm_nolight_pb");
	///level._effect["payback_car_blacksmoke_wind"] 				= loadfx("maps/payback/payback_car_blacksmoke_wind");
	///level._effect["payback_water_drips"]							= loadfx("maps/payback/payback_water_drips");		
	///level._effect["light_drips_slow"]								= loadfx("maps/payback/light_drips_slow");	
	///level._effect["payback_insects"]								= loadfx("maps/payback/payback_insects");
	level._effect["payback_barrel_exp_sandstorm"]					= loadfx("props/barrel_exp_sandstorm");
	level._effect["payback_small_vehicle_explosion"]				= loadfx("explosions/small_vehicle_explosion_pb");
	level._effect["payback_vehicle_explosion_pickuptruck"]			= loadfx("explosions/vehicle_explosion_pickuptruck_pb");
	level._effect["payback_firelp_small_pm_a_pb"]					= loadfx("fire/firelp_small_pm_a_pb");
	
	/* This is in common
	if ( !getdvarint("r_reflectionProbeGenerate") )
		maps\createfx\payback_fx::main();
		
	if ( !isdefined( level.createFXent ) )
		level.createFXent = [];
	*/
	
	treadfx_override();
	maps\_sandstorm::blizzard_main();
	level thread convertOneShot(); // for using "Z" to convert oneshot to exploders in createFX mode
	
}

treadfx_override()
{
	//override for intro
	maps\_treadfx::setallvehiclefx("script_vehicle_payback_hind", "treadfx/heli_sand_pb");		
}
setup_sandstorm_replacement_fx()
{
	level.breakables_fx[ "barrel" ][ "explode" ] = loadfx( "props/barrel_exp_sandstorm" );
 	
	level.vtclassname = "script_vehicle_pickup_technical_payback";
	level.vehicle_death_fx[ level.vtclassname ] = [];
	maps\_vehicle::build_deathfx( "explosions/vehicle_explosion_pickuptruck_pb", "tag_deathfx", "car_explode", undefined, undefined, undefined, 2.9 );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm_nolight", "tag_fx_tank", "smallfire", undefined, undefined, true, 0 );
	maps\_vehicle::build_deathfx( "explosions/ammo_cookoff", "tag_fx_bed", undefined, undefined, undefined, undefined, 0.5 );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a_pb", "tag_fx_tire_right_r", "smallfire", undefined, undefined, true, 3 );
	maps\_vehicle::build_deathfx( "fire/firelp_med_pm_nolight_hood", "tag_fx_cab", "fire_metal_medium", undefined, undefined, true, 3.01 );
	maps\_vehicle::build_deathfx( "fire/firelp_small_pm_a_pb", "tag_engine_left", "smallfire", undefined, undefined, true, 3.01 );
	
	level.vtclassname = "script_vehicle_uaz_fabric";
	level.vehicle_death_fx[ level.vtclassname ] = [];
	maps\_vehicle::build_deathfx( "explosions/small_vehicle_explosion_pb", undefined, "explo_metal_rand" );
	
	index = common_scripts\_destructible_types::getInfoIndex( "vehicle_80s_hatch1_green" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx_filename" ][ 0 ][ 0 ] = "explosions/small_vehicle_explosion_pb";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx" ][ 0 ][ 0 ] = getfx("payback_small_vehicle_explosion");	// alias of fx
	}
	
	index = common_scripts\_destructible_types::getInfoIndex( "vehicle_pickup" );
	if ( index > -1 )
	{
		level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx_filename" ][ 0 ][ 0 ] = "explosions/small_vehicle_explosion_pb";	// path of fx file
		level.destructible_type[ index ].parts[ 0 ][ 4 ].v[ "fx" ][ 0 ][ 0 ] = getfx("payback_small_vehicle_explosion");	// alias of fx
	}
}