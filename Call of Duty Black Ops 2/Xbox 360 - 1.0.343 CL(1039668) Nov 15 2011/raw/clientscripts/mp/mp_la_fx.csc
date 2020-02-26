#include clientscripts\mp\_utility; 

precache_util_fx()
{	
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{

	level._effect["fx_water_fire_sprinkler"]									= loadfx("water/fx_water_fire_sprinkler");
	level._effect["fx_water_fire_sprinkler_splash"]						= loadfx("water/fx_water_fire_sprinkler_splash");
	level._effect["fx_water_fire_sprinkler_sputter"]					= loadfx("water/fx_water_fire_sprinkler_sputter");
	level._effect["fx_water_fire_sprinkler_gush"]							= loadfx("water/fx_water_fire_sprinkler_gush");
	level._effect["fx_water_fire_sprinkler_gush_splash"]			= loadfx("water/fx_water_fire_sprinkler_gush_splash");	
	level._effect["fx_water_step_splash"]											= loadfx("water/fx_water_step_splash");
	level._effect["fx_water_fountian_pool_md"]								= loadfx("water/fx_water_fountain_pool_md");
	
	level._effect["fx_mp_water_drip_light_long"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_long");	
	level._effect["fx_mp_water_drip_light_shrt"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");	

	level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
	
	level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_debris_papers_narrow"]									= loadfx("env/debris/fx_debris_papers_narrow");	
	level._effect["fx_paper_interior_short"]									= loadfx("debris/fx_paper_interior_short");	
	level._effect["fx_paper_burning_fall_slow"]								= loadfx("debris/fx_paper_burning_fall_slow");
	level._effect["fx_leaves_falling_lite"]										= loadfx("env/foliage/fx_leaves_falling_lite");	
	level._effect["fx_leaves_falling_lite_sm_orng"]						= loadfx("foliage/fx_leaves_falling_lite_sm_orng");	
		
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	level._effect["fx_dust_crumble_int_md"]										= loadfx("env/dirt/fx_dust_crumble_int_md");
	level._effect["fx_dust_crumble_lg"]												= loadfx("dirt/fx_dust_crumble_lg");
	
	level._effect["fx_fire_bldg_ext_dist_falling_debris"] 		= loadfx("fire/fx_fire_bldg_ext_dist_falling_debris");	
	level._effect["fx_fire_lg"] 															= loadfx("env/fire/fx_fire_lg");
	level._effect["fx_fire_md"] 															= loadfx("env/fire/fx_fire_md");
	level._effect["fx_fire_sm"] 															= loadfx("env/fire/fx_fire_sm");
	level._effect["fx_fire_detail"] 													= loadfx("env/fire/fx_fire_detail_sm_nodlight");		
	level._effect["fx_fire_bldg_int_dist_xxlg"] 							= loadfx("fire/fx_fire_bldg_int_dist_xxlg");	
	level._effect["fx_fire_bldg_int_dist_xlg"] 								= loadfx("fire/fx_fire_bldg_int_dist_xlg");	
	
	level._effect["fx_mp_smk_haze_linger"]										= loadfx("maps/mp_maps/fx_mp_smk_haze_linger");
	level._effect["fx_mp_fire_ash_falling_lg"]								= loadfx("maps/mp_maps/fx_mp_fire_ash_falling_lg");
	level._effect["fx_mp_fire_ash_falling_door"]							= loadfx("maps/mp_maps/fx_mp_fire_ash_falling_door");	
	
	level._effect["fx_mp_ash_falling_lg"]											= loadfx("maps/mp_maps/fx_mp_ash_falling_lg");
	
	level._effect["fx_smk_field_sm"]													= loadfx("maps/mp_maps/fx_mp_smk_field_sm");
	level._effect["fx_smk_field_md"]													= loadfx("maps/mp_maps/fx_mp_smk_field_md");
	level._effect["fx_smk_field_md_w"]												= loadfx("maps/mp_maps/fx_mp_smk_field_md_w");
	level._effect["fx_mp_smk_haze_linger_xlg"]								= loadfx("maps/mp_maps/fx_mp_smk_haze_linger_xlg");	

	level._effect["fx_mp_smk_plume_detail_blk"]								= loadfx("maps/mp_maps/fx_mp_smk_plume_detail_blk");		
	level._effect["fx_mp_smk_plume_sm_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_sm_blk");	
	level._effect["fx_mp_smk_plume_md_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk");	
	level._effect["fx_mp_smk_plume_lg_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk");	
	level._effect["fx_mp_smk_plume_xxlg_blk_ds"]							= loadfx("maps/mp_maps/fx_mp_la_smk_plume_xxlg_blk_ds");	
	level._effect["fx_mp_smk_smolder_rubble_area"]						= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_area");
	level._effect["fx_mp_smk_smolder_rubble_line"]						= loadfx("maps/mp_maps/fx_mp_smk_smolder_rubble_line");
	level._effect["fx_mp_smk_plume_lg_blk_distant"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_blk_distant");
	level._effect["fx_mp_smk_plume_md_blk_distant"]						= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk_distant");	

	level._effect["fx_fog_low_rising"]												= loadfx("fog/fx_fog_low_rising");	
	
	level._effect["fx_mp_elec_spark_burst_sm"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_sm");
	level._effect["fx_mp_elec_spark_burst_xsm_thin"]					= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_xsm_thin");
	level._effect["fx_mp_elec_spark_burst_md"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_md");
	level._effect["fx_mp_elec_spark_burst_lg"]								= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_lg");
	
	level._effect["fx_light_emrgncy_floodlight"]							= loadfx("light/fx_light_emrgncy_floodlight");
	level._effect["fx_light_recessed_wrm"]										= loadfx("light/fx_light_recessed_wrm");
	level._effect["fx_light_ambulance_blue"]									= loadfx("env/light/fx_light_ambulance_blue");
	level._effect["fx_light_ambulance_red"]										= loadfx("env/light/fx_light_ambulance_red");	
	level._effect["fx_light_ceiling_sqr_wht"]									= loadfx("light/fx_light_ceiling_sqr_wht");	
	level._effect["fx_light_ambulance_red_flash"]							= loadfx("light/fx_light_ambulance_red_flash");	
	level._effect["fx_light_ambulance_blue_flash"]						= loadfx("light/fx_light_ambulance_blue_flash");	
	level._effect["fx_mp_light_flare_la"]											= loadfx("maps/mp_maps/fx_mp_light_flare_la");
	level._effect["fx_light_flourescent_glow_cool"]						= loadfx("light/fx_light_flourescent_glow_cool");	
	level._effect["fx_light_gray_white_ribbon_sm"]						= loadfx("light/fx_light_gray_white_ribbon_sm");	

	level._effect["fx_mp_sun_grays_warm"]											= loadfx("maps/mp_maps/fx_mp_sun_grays_warm");	
	level._effect["fx_mp_sun_flare_warm"]											= loadfx("maps/mp_maps/fx_mp_sun_flare_warm");
	level._effect["fx_mp_sun_flare_warm_hotspot"]							= loadfx("maps/mp_maps/fx_mp_sun_flare_warm_hotspot");	

	level._effect["fx_dest_fire_hydrant_burst"]								= loadfx("maps/mp_maps/fx_mp_fire_hydrant_burst");
	level._effect["fx_water_pipe_spray_splash"]								= loadfx("env/water/fx_water_pipe_spray_splash");	
	level._effect["fx_water_pipe_spray"]											= loadfx("env/water/fx_water_pipe_spray");	
	level._effect["fx_rain_splash_area_100_hvy_lp"]						= loadfx("weather/fx_rain_splash_area_100_hvy_lp");
	
}


main()
{
	clientscripts\mp\createfx\mp_la_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

