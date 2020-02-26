#include maps\mp\_utility; 

// fx used by utility scripts
precache_util_fx()
{
	
}

// Scripted effects
precache_scripted_fx()
{
}

// Ambient effects
precache_createfx_fx()
{

//	level._effect["fx_mp_snow_gust_door_low_slow"] 				= loadfx("maps/mp_maps/fx_mp_snow_gust_door_low_slow");
	level._effect["fx_snow_gust_rooftop_slow"]						= loadfx("maps/mp_maps/fx_mp_array_snow_gust_rooftop");
	level._effect["fx_snow_gust_tree_slow"]								= loadfx("maps/mp_maps/fx_mp_array_snow_gust_tree");	
	level._effect["fx_snow_gust_ground_lg_slow_distant"]	= loadfx("env/weather/fx_snow_gust_ground_lg_slow_distant");
	level._effect["fx_snow_windy_heavy_md"] 							= loadfx("env/weather/fx_snow_windy_heavy_md_slow"); 
	level._effect["fx_mp_snow_wall_hvy_os_sm_slow"] 			= loadfx("maps/mp_maps/fx_mp_snow_wall_hvy_os_sm_slow"); 
	level._effect["fx_snow_tree_md_runner"] 							= loadfx("env/weather/fx_snow_tree_md_runner");	 
	level._effect["fx_mp_array_snow_gust_lg_slow_rolling"]= loadfx("maps/mp_maps/fx_mp_array_snow_gust_lg_slow_rolling");		

	level._effect["fx_snow_fog_field_sm"]							    = loadfx("env/weather/fx_snow_fog_field_sm");
//	level._effect["fx_snow_fog_field_lg"]							    = loadfx("env/weather/fx_snow_fog_field_lg");				

	// level._effect["fx_mp_snow_wall_hvy_loop_sm"] 					= loadfx("maps/mp_maps/fx_mp_snow_wall_hvy_loop_sm");

	level._effect["fx_pipe_steam_md"]											= loadfx("env/smoke/fx_pipe_steam_md");	
	level._effect["fx_fumes_vent_xsm_int"]								= loadfx("maps/mp_maps/fx_mp_fumes_vent_xsm_int");
	level._effect["fx_fumes_vent_sm_int"]									= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm_int");
	level._effect["fx_fumes_haze_md"]											= loadfx("maps/mp_maps/fx_mp_fumes_haze_md");
	level._effect["fx_mp_smk_tin_hat_steam_pipe"]					= loadfx("maps/mp_maps/fx_mp_smk_tin_hat_steam_pipe");
	level._effect["fx_smk_plume_md_wht_wispy"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_md_wht_wispy");
		
	level._effect["fx_water_drip_light_short"]						= loadfx("env/water/fx_water_drip_light_short");	
	level._effect["fx_water_drip_light_long"]							= loadfx("env/water/fx_water_drip_light_long");		
	
	level._effect["fx_mp_distortion_wall_heater"] 				= loadfx("maps/mp_maps/fx_mp_distortion_wall_heater");
	
	level._effect["fx_mp_light_dust_motes_md"]						= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	
//	level._effect["fx_light_office_light_01"]							= loadfx("env/light/fx_light_office_light_01");
	level._effect["fx_light_office_light_03"]							= loadfx("env/light/fx_light_office_light_03");
//	level._effect["fx_light_fluorescent_tube_bulb"]				= loadfx("env/light/fx_light_fluorescent_tube_bulb");
	level._effect["fx_light_floodlight_int_blue"]					= loadfx("env/light/fx_light_floodlight_int_blue");
	level._effect["fx_light_tinhat_cage_white"]						= loadfx("env/light/fx_light_tinhat_cage_white");	
	level._effect["fx_light_beacon_red"]									= loadfx("env/light/fx_light_beacon_red_sm");
	
//	level._effect["fx_mp_elec_spark_burst_lg"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");
	level._effect["fx_mp_elec_spark_burst_sm"]						= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]			= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	
}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-100 -150 -100" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}

main()
{
	maps\mp\createfx\mp_array_fx::main();

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();

 	maps\mp\createart\mp_array_art::main();
 	
 	wind_initial_setting();
}
