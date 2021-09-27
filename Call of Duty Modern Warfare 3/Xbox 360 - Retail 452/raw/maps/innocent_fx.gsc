#include common_scripts\utility;
#include maps\_utility;

main()
{
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\innocent_fx::main();

	level_fx();
	westminster_fx();
	treadfx_override();
}

level_fx()
{
	level._effect[ "carbomb_large_innocent" ] 							= LoadFX( "explosions/carbomb_large_innocent" );
	level._effect[ "carbomb_large_innocent_gas_merge" ] 				= LoadFX( "explosions/carbomb_large_innocent_gas_merge" );
	level._effect[ "poison_gas_attack_innocent" ] 						= LoadFX( "smoke/poison_gas_attack_innocent" );
	level._effect[ "poisonous_gas_spillage_innocent" ] 					= LoadFX( "smoke/poisonous_gas_spillage_innocent" );
	level._effect[ "poisonous_gas_sides_innocent" ] 					= LoadFX( "smoke/poisonous_gas_sides_innocent" );
	level._effect[ "poisonous_gas_ground_london_player_innocent" ] 		= LoadFX( "smoke/poisonous_gas_ground_london_player_innocent" );
	level._effect[ "poisonous_gas_spillage_innocent_dood" ] 			= LoadFX( "smoke/poisonous_gas_spillage_innocent_dood" );
}

westminster_fx()
{
	level._effect[ "carbomb_large" ]							= LoadFX( "explosions/carbomb_large" );
	level._effect[ "cloud_ash_lite_london" ]					= LoadFX( "weather/cloud_ash_lite_london" );
	level._effect[ "electrical_transformer_spark_runner_lon" ]	= LoadFX( "explosions/electrical_transformer_spark_runner_lon" );
	level._effect[ "electrical_transformer_spark_runner_loop" ]	= LoadFX( "explosions/electrical_transformer_spark_runner_loop" );
	level._effect[ "fire_falling_runner_london" ]				= LoadFX( "fire/fire_falling_runner_london" );
	level._effect[ "fire_falling_runner_point" ]				= LoadFX( "fire/fire_falling_runner_point" );
	level._effect[ "fire_falling_runner_point_far" ]			= LoadFX( "fire/fire_falling_runner_point_far" );
	level._effect[ "fire_sprinkler" ]							= LoadFX( "water/fire_sprinkler" );
	level._effect[ "fire_sprinkler_wide" ]						= LoadFX( "water/fire_sprinkler_wide" );
	level._effect[ "fire_tree_distortion_london" ]				= LoadFX( "fire/fire_tree_distortion_london" );
	level._effect[ "fire_tree_embers_london" ]					= LoadFX( "fire/fire_tree_embers_london" );
	level._effect[ "fire_tree_london" ]							= LoadFX( "fire/fire_tree_london" );
	level._effect[ "fire_tree_slow_london" ]					= LoadFX( "fire/fire_tree_slow_london" );
	level._effect[ "firelp_med_pm" ]							= LoadFX( "fire/firelp_med_pm" );
	level._effect[ "firelp_med_pm_cheap" ]						= LoadFX( "fire/firelp_med_pm_cheap" );
	level._effect[ "firelp_small_pm" ]				 			= LoadFX( "fire/firelp_small_pm" );
	level._effect[ "glass_shatter_london" ] 					= LoadFX( "misc/glass_shatter_london" );
	level._effect[ "ground_fog_london_river" ]					= LoadFX( "smoke/ground_fog_london_river" );
	level._effect[ "heli_dust_poisonous_gas_london" ]			= LoadFX( "treadfx/heli_dust_poisonous_gas_london" );
	level._effect[ "heli_dust_poisonous_gas_london2" ]			= LoadFX( "treadfx/heli_dust_poisonous_gas_london2" );
	level._effect[ "light_blink_london_police_car" ]			= LoadFX( "lights/light_blink_london_police_car" );
	level._effect[ "light_blink_london_police_car_gassy" ]		= LoadFX( "lights/light_blink_london_police_car_gassy" );
	level._effect[ "light_blink_london_police_car_gassy_sat" ]	= LoadFX( "lights/light_blink_london_police_car_gassy_sat" );
	level._effect[ "poison_gas_attack" ]						= LoadFX( "smoke/poison_gas_attack" );
	level._effect[ "poisonous_gas_bubbling_left" ]				= LoadFX( "smoke/poisonous_gas_bubbling_left" );
	level._effect[ "poisonous_gas_bubbling_right" ]				= LoadFX( "smoke/poisonous_gas_bubbling_right" );
	level._effect[ "poisonous_gas_bubbling_small_left" ]		= LoadFX( "smoke/poisonous_gas_bubbling_small_left" );
	level._effect[ "poisonous_gas_bubbling_small_right" ]		= LoadFX( "smoke/poisonous_gas_bubbling_small_right" );
	level._effect[ "poisonous_gas_bubbling_start_left" ]		= LoadFX( "smoke/poison_gas_attack" );
	level._effect[ "poisonous_gas_bubbling_start_right" ]		= LoadFX( "smoke/poisonous_gas_bubbling_start_right" );
	level._effect[ "poisonous_gas_carbomb_cheap" ]				= LoadFX( "explosions/poisonous_gas_carbomb_cheap" );
	level._effect[ "poisonous_gas_carbomb_cheap_loop" ]			= LoadFX( "explosions/poisonous_gas_carbomb_cheap_loop" );
	level._effect[ "poisonous_gas_ground_london_player" ] 		= LoadFX( "smoke/poisonous_gas_ground_london_player" );
	level._effect[ "poisonous_gas_ground_z_fill" ] 				= LoadFX( "smoke/poisonous_gas_ground_z_fill" );
	level._effect[ "poisonous_gas_linger_large_subtle" ]		= LoadFX( "smoke/poisonous_gas_linger_large_subtle" );
	level._effect[ "poisonous_gas_linger_large_thin" ]			= LoadFX( "smoke/poisonous_gas_linger_large_thin" );
	level._effect[ "poisonous_gas_linger_low_thin" ]			= LoadFX( "smoke/poisonous_gas_linger_low_thin" );
	level._effect[ "poisonous_gas_linger_medium_thick_killer" ] = LoadFX( "smoke/poisonous_gas_linger_medium_thick_killer" );
	level._effect[ "poisonous_gas_linger_medium_thick_killer_ins" ] 	= LoadFX( "smoke/poisonous_gas_linger_medium_thick_killer_instant" );
	level._effect[ "poisonous_gas_linger_medium_thick_killer_pulse" ] 	= LoadFX( "smoke/poisonous_gas_linger_medium_thick_killer_pulse" );
	level._effect[ "poisonous_gas_linger_medium_thick_sat" ] 			= LoadFX( "smoke/poisonous_gas_linger_medium_thick_sat" );
	level._effect[ "rain_london" ]								= LoadFX( "weather/rain_london" );
	level._effect[ "rain_splash_lite_128x128" ]					= LoadFX( "weather/rain_splash_lite_128x128" );
	level._effect[ "rain_splash_subtle_128x128" ]				= LoadFX( "weather/rain_splash_subtle_128x128" );
	level._effect[ "rain_splash_subtle_64x64" ]					= LoadFX( "weather/rain_splash_subtle_64x64" );
	level._effect[ "room_smoke_200" ]							= LoadFX( "smoke/room_smoke_200" );
	level._effect[ "room_smoke_400" ]							= LoadFX( "smoke/room_smoke_400" );
	level._effect[ "smoke_fill_linger_subway" ]					= LoadFX( "smoke/smoke_fill_linger_subway" );
	level._effect[ "smoke_fill_linger_subway_gap" ]				= LoadFX( "smoke/smoke_fill_linger_subway_gap" );
	level._effect[ "smoke_fill_linger_subway_rolling" ]			= LoadFX( "smoke/smoke_fill_linger_subway_rolling" );
	level._effect[ "smoke_fill_subway" ]						= LoadFX( "smoke/smoke_fill_subway" );
	level._effect[ "sparks_falling_runner_loop" ]				= LoadFX( "explosions/sparks_falling_runner_loop" );
	level._effect[ "trash_spiral_runner" ]						= LoadFX( "misc/trash_spiral_runner" );

	level._effect[ "sparks_car_scrape_line" ]					= LoadFX( "misc/sparks_car_scrape_line" );
	level._effect[ "sparks_car_scrape_point" ]					= LoadFX( "misc/sparks_car_scrape_point" );

	level._effect[ "lit_poster" ]								= LoadFX( "explosions/tv_flatscreen_explosion" );
}

treadfx_override()
{
	flying_tread_fx_large = "treadfx/heli_dust_default";
	
	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "brick", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "bark", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "carpet", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "cloth", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "concrete", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "dirt", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "flesh", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "foliage", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "glass", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "grass", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "gravel", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "ice", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "metal", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "mud", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "paper", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "plaster", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "rock", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "sand", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "snow", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "water", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "wood", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "asphalt", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "ceramic", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "plastic", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "rubber", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "cushion", 	flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "fruit", 		flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "painted metal", flying_tread_fx_large );
 	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "default", 	flying_tread_fx_large );
	maps\_treadfx::setvehiclefx( "script_vehicle_littlebird_bench", "none", 		flying_tread_fx_large );
}