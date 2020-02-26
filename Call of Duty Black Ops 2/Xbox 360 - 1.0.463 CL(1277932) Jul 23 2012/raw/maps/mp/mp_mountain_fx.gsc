#include maps\mp\_utility; 

// fx used by utility scripts
precache_util_fx()
{
	
}

// fx prop anim effects
#using_animtree ( "fxanim_props" );
precache_fx_prop_anims()
{
	level.mountain_fxanims = [];
	level.mountain_fxanims["fxanim_mp_lift_anim"]		= %fxanim_mp_lift_anim;
}

// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_mp_snow_blizzard_heavy"] 						= loadfx("maps/mp_maps/fx_mp_snow_blizzard_heavy");
	level._effect["fx_mp_snow_fall_ceiling_window"] 			= loadfx("maps/mp_maps/fx_mp_snow_fall_ceiling_window");

	level._effect["fx_mp_snow_gust_ground_lg"] 						= loadfx("maps/mp_maps/fx_mp_snow_gust_ground_lg");
	level._effect["fx_mp_snow_gust_ground_lg_thin"] 			= loadfx("maps/mp_maps/fx_mp_snow_gust_ground_lg_thin");
	level._effect["fx_mp_snow_gust_ground_sm_os"] 				= loadfx("maps/mp_maps/fx_mp_snow_gust_ground_sm_fast_os");
	level._effect["fx_mp_snow_gust_rooftop"] 							= loadfx("maps/mp_maps/fx_mp_snow_gust_rooftop");
	level._effect["fx_mp_snow_gust_door"] 								= loadfx("maps/mp_maps/fx_mp_snow_gust_door");
	level._effect["fx_mp_snow_gust_door_low"] 						= loadfx("maps/mp_maps/fx_mp_snow_gust_door_low");

	level._effect["fx_mp_snow_wall_hvy_loop_sm"] 					= loadfx("maps/mp_maps/fx_mp_snow_wall_hvy_loop_sm");

//	level._effect["fx_elec_burst_heavy_os"] 							= loadfx("env/electrical/fx_elec_burst_heavy_os");
	level._effect["fx_elec_burst_shower_sm_runner"] 			= loadfx("env/electrical/fx_elec_burst_shower_sm_runner");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]			= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_mp_elec_spark_burst_lg"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");

//	level._effect["fx_light_blink_sm_yllw"] 							= loadfx("env/light/fx_light_blink_sm_yllw");
	level._effect["fx_light_blink_sm_grn"] 								= loadfx("env/light/fx_light_blink_sm_grn");

	level._effect["fx_pipe_steam_md"] 										= loadfx("env/smoke/fx_pipe_steam_md");
	
	level._effect["fx_fumes_vent_xsm_int"]								= loadfx("maps/mp_maps/fx_mp_fumes_vent_xsm_int");
	level._effect["fx_fumes_vent_sm_int"]									= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm_int");
//	level._effect["fx_fumes_vent_sm"]											= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm");
	level._effect["fx_fumes_haze_md"]											= loadfx("maps/mp_maps/fx_mp_fumes_haze_md");
	
	level._effect["fx_water_drip_light_short"]						= loadfx("env/water/fx_water_drip_light_short");	
	
	level._effect["fx_mp_distortion_wall_heater"] 				= loadfx("maps/mp_maps/fx_mp_distortion_wall_heater");
	level._effect["fx_light_floodlight_int_blue"] 				= loadfx("env/light/fx_light_floodlight_int_blue");
	level._effect["fx_light_ray_fan_fast_cool"] 					= loadfx("env/light/fx_light_ray_fan_fast_cool");
	
	level._effect["fx_smk_plume_md_wht_wispy"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_md_wht_wispy");
	
	level._effect["fx_cloud3d_cmls_lg1"]									= loadfx("env/weather/fx_cloud3d_cmls_lg1_dark");
	level._effect["fx_cloud2d_cmls_lg1_dark"]							= loadfx("env/weather/fx_cloud2d_cmls_lg1_dark");
	
}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-110 -150 -110" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}

main()
{
	maps\mp\createfx\mp_mountain_fx::main();

	precache_util_fx();
	precache_createfx_fx();
	precache_fx_prop_anims();

	maps\mp\createart\mp_mountain_art::main();
	
	wind_initial_setting();
}

