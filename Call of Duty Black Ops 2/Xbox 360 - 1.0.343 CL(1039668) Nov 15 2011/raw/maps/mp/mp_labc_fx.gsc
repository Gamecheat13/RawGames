#include maps\mp\_utility; 

precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{

	level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
	
	level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_leaves_falling_lite"]										= loadfx("env/foliage/fx_leaves_falling_lite");	
	
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	level._effect["fx_dust_crumble_int_md"]										= loadfx("env/dirt/fx_dust_crumble_int_md");
	level._effect["fx_dust_crumble_lg"]												= loadfx("dirt/fx_dust_crumble_lg");
	
	level._effect["fx_mp_fire_sm_smolder_low"] 								= loadfx("maps/mp_maps/fx_mp_fire_sm_smolder_low");
	level._effect["fx_fire_lg"] 															= loadfx("env/fire/fx_fire_lg");
	level._effect["fx_fire_md"] 															= loadfx("env/fire/fx_fire_md");
	level._effect["fx_fire_sm"] 															= loadfx("env/fire/fx_fire_sm");
	level._effect["fx_fire_detail_sm"] 												= loadfx("env/fire/fx_fire_detail_sm_nodlight");
	level._effect["fx_mp_fire_sm_smolder_low"] 								= loadfx("maps/mp_maps/fx_mp_fire_sm_smolder_low");	
	
	level._effect["fx_fire_ember_column_md"]									= loadfx("env/fire/fx_fire_ember_column_md");
	level._effect["fx_ash_embers_light"]											= loadfx("maps/mp_maps/fx_mp_fire_ash_embers");

	level._effect["fx_mp_smk_haze_linger"]										= loadfx("maps/mp_maps/fx_mp_smk_haze_linger");
	level._effect["fx_mp_fire_ash_falling_lg"]								= loadfx("maps/mp_maps/fx_mp_fire_ash_falling_lg");
	level._effect["fx_smk_field_sm"]													= loadfx("maps/mp_maps/fx_mp_smk_field_sm");
	level._effect["fx_smk_field_md"]													= loadfx("maps/mp_maps/fx_mp_smk_field_md");
	level._effect["fx_smk_field_md_w"]												= loadfx("maps/mp_maps/fx_mp_smk_field_md_w");
	level._effect["fx_mp_smk_plume_sm_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_sm_blk");	
	level._effect["fx_mp_smk_plume_md_grey"]									= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk");	
	level._effect["fx_mp_smk_plume_lg_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk");	
	level._effect["fx_mp_smk_smolder_rubble_area"]						= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_area");
	
	level._effect["fx_fog_low_rising"]												= loadfx("fog/fx_fog_low_rising");	

	level._effect["fx_mp_elec_spark_burst_sm"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_mp_elec_spark_burst_md"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_md");
	level._effect["fx_mp_elec_spark_burst_lg"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");
	
	level._effect["fx_light_ambulance_blue"]									= loadfx("env/light/fx_light_ambulance_blue");
	level._effect["fx_light_ambulance_red"]										= loadfx("env/light/fx_light_ambulance_red");	
	level._effect["fx_light_ceiling_sqr_wht"]									= loadfx("light/fx_light_ceiling_sqr_wht");	
	level._effect["fx_light_ambulance_red_flash"]							= loadfx("light/fx_light_ambulance_red_flash");	
	level._effect["fx_light_ambulance_blue_flash"]						= loadfx("light/fx_light_ambulance_blue_flash");	

	level._effect["fx_dest_fire_hydrant_burst"]								= loadfx("maps/mp_maps/fx_mp_fire_hydrant_burst");
	level._effect["fx_water_pipe_spray_splash"]								= loadfx("env/water/fx_water_pipe_spray_splash");	
	level._effect["fx_water_pipe_spray"]											= loadfx("env/water/fx_water_pipe_spray");	
	level._effect["fx_rain_splash_area_100_hvy_lp"]						= loadfx("weather/fx_rain_splash_area_100_hvy_lp");	

	level._effect["fx_test_sun_flare"]												= loadfx("test/fx_test_sun_flare");		
	level._effect["fx_test_sun_grays"]												= loadfx("test/fx_test_sun_grays");			

}

main()
{

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	
	maps\mp\createfx\mp_labc_fx::main();
	maps\mp\createart\mp_labc_art::main();

	wind_initial_setting();
	
}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-90 -90 -90" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}
