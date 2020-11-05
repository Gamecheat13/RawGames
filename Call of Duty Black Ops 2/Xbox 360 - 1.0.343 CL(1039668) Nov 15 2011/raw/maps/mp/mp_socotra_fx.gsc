#include maps\mp\_utility;

precache_util_fx()
{
}

precache_scripted_fx()
{
}

// Ambient Effects
precache_createfx_fx()
{

	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	level._effect["fx_light_gray_stain_glss_blue"]						= loadfx("light/fx_light_gray_stain_glss_blue");
	level._effect["fx_light_gray_stain_glss_purple"]					= loadfx("light/fx_light_gray_stain_glss_purple");
	level._effect["fx_light_gray_stain_glss_warm_sm"]					= loadfx("light/fx_light_gray_stain_glss_warm_sm");	
	level._effect["fx_mp_sun_flare_socotra"]									= loadfx("maps/mp_maps/fx_mp_sun_flare_socotra");		
	level._effect["fx_light_gray_blue_ribbon"]									= loadfx("light/fx_light_gray_blue_ribbon");			

	level._effect["fx_insects_butterfly_flutter"]							= loadfx("bio/insects/fx_insects_butterfly_flutter");
	level._effect["fx_insects_butterfly_static_prnt"]					= loadfx("bio/insects/fx_insects_butterfly_static_prnt");
	level._effect["fx_insects_roaches_short"]									= loadfx("bio/insects/fx_insects_roaches_short");
	level._effect["fx_insects_fly_swarm_lng"]									= loadfx("bio/insects/fx_insects_fly_swarm_lng");
	level._effect["fx_insects_fly_swarm"]											= loadfx("bio/insects/fx_insects_fly_swarm");
	level._effect["fx_insects_swarm_md_light"]								= loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_seagulls_circle_below"]									= loadfx("bio/animals/fx_seagulls_circle_below");	
	level._effect["fx_seagulls_circle_swarm"]									= loadfx("bio/animals/fx_seagulls_circle_swarm");

	level._effect["fx_leaves_falling_lite_sm"]								= loadfx("foliage/fx_leaves_falling_lite_sm");
	level._effect["fx_debris_papers"]													= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_debris_papers_narrow"]									= loadfx("env/debris/fx_debris_papers_narrow");

	level._effect["fx_mp_smk_plume_sm_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_sm_blk");
	level._effect["fx_mp_smk_plume_md_blk"]										= loadfx("maps/mp_maps/fx_mp_smk_plume_md_blk");
	level._effect["fx_smk_cigarette_room_amb"]								= loadfx("smoke/fx_smk_cigarette_room_amb");	
	level._effect["fx_smk_smolder_gray_slow_shrt"]						= loadfx("smoke/fx_smk_smolder_gray_slow_shrt");

	level._effect["fx_fire_fuel_sm"]													= loadfx("fire/fx_fire_fuel_sm");
	
	level._effect["fx_mp_water_drip_light_long"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_long");
	level._effect["fx_mp_water_drip_light_shrt"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");
	level._effect["fx_water_faucet_on"]												= loadfx("water/fx_water_faucet_on");
	level._effect["fx_water_faucet_splash"]										= loadfx("water/fx_water_faucet_splash");	
	level._effect["fx_mp_waves_shorebreak_socotra"]						= loadfx("maps/mp_maps/fx_mp_waves_shorebreak_socotra");	
	level._effect["fx_mp_water_shoreline_socotra"]						= loadfx("maps/mp_maps/fx_mp_water_shoreline_socotra");		
	
	level._effect["fx_mp_sand_kickup_md"]											= loadfx("maps/mp_maps/fx_mp_sand_kickup_md");
	level._effect["fx_mp_sand_kickup_thin"]										= loadfx("maps/mp_maps/fx_mp_sand_kickup_thin");
	level._effect["fx_mp_sand_windy_heavy_sm_slow"]						= loadFX("maps/mp_maps/fx_mp_sand_windy_heavy_sm_slow");
	level._effect["fx_sand_ledge"]														= loadFX("dirt/fx_sand_ledge");
	level._effect["fx_sand_ledge_sml"]												= loadFX("dirt/fx_sand_ledge_sml");
	level._effect["fx_sand_ledge_md"]													= loadFX("dirt/fx_sand_ledge_md");
	level._effect["fx_sand_ledge_wide_distant"]								= loadFX("dirt/fx_sand_ledge_wide_distant");
	level._effect["fx_sand_windy_heavy_md"]										= loadFX("dirt/fx_sand_windy_heavy_md");
	level._effect["fx_sand_swirl_sm_runner"]									= loadFX("dirt/fx_sand_swirl_sm_runner");
	level._effect["fx_sand_moving_in_air_md"]									= loadFX("dirt/fx_sand_moving_in_air_md");
	level._effect["fx_sand_moving_in_air_pcloud"]							= loadFX("dirt/fx_sand_moving_in_air_pcloud");	
		
}

main()
{

	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();

	maps\mp\createfx\mp_socotra_fx::main();
	maps\mp\createart\mp_socotra_art::main();

	wind_initial_setting();
}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}