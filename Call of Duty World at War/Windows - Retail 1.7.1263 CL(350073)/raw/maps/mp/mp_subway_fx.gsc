#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_subway_art::main();
	precacheFX();
	spawnFX();
}

precacheFX()
{
	////////////////////////////////////////FX_DEPT///////////////////////////////////////
//	level._effect["mp_fire_distant_150_150"]					= loadfx("maps/mp_maps/fx_mp_fire_150x150_tall_distant");
//	level._effect["mp_fire_distant_150_600"]					= loadfx("maps/mp_maps/fx_mp_fire_150x600_tall_distant");
	level._effect["mp_fire_static_small_detail"]			= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_rubble_small"]							= loadfx("maps/mp_maps/fx_mp_fire_rubble_small");
	level._effect["mp_fire_rubble_small_column"]			= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column");
	level._effect["mp_fire_rubble_small_column_smldr"]	= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column_smldr");
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
//	level._effect["mp_fire_rubble_md_lowsmk"]					= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_lowsmk");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
//	level._effect["mp_ray_fire_thin"]									= loadfx("maps/mp_maps/fx_mp_ray_fire_thin");
	level._effect["mp_ray_fire_ribbon"]								= loadfx("maps/mp_maps/fx_mp_ray_fire_ribbon");

	level._effect["mp_ray_light_sm"]									= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["mp_ray_light_md"]									= loadfx("maps/mp_maps/fx_mp_ray_overcast_md");
	level._effect["mp_ray_light_lg"]									= loadfx("env/light/fx_light_godray_overcast_lg");
	level._effect["mp_ray_light_md_1sd"]							= loadfx("env/light/fx_light_godray_overcast_md_1sd");
	level._effect["mp_smoke_fire_column"]							= loadfx("maps/mp_maps/fx_mp_smoke_fire_column");
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
//	level._effect["mp_smoke_plume_lg_shadow"]					= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg_shd");
	level._effect["mp_smoke_hall"]										= loadfx("maps/mp_maps/fx_mp_smoke_hall");
	level._effect["mp_electric_sparks"]								= loadfx("maps/mp_maps/fx_mp_electric_sparks_dlight");
	
	level._effect["mp_water_spill"]										= loadfx("maps/mp_maps/fx_mp_water_spill");
//	level._effect["mp_water_spill_splash"]						= loadfx("maps/mp_maps/fx_mp_water_spill_splash");
	level._effect["mp_water_spill_long"]						= loadfx("maps/mp_maps/fx_mp_water_spill_long");
	level._effect["mp_water_drips_hvy_long"]				= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	level._effect["mp_water_spill_splatter"]				= loadfx("maps/mp_maps/fx_mp_water_spill_splatter");
	
	level._effect["mp_ash_falling_windy"]							= loadfx("maps/mp_maps/fx_mp_ash_falling_windy");
	
	level._effect["mp_dust_motes"]										= loadfx("maps/mp_maps/fx_mp_ray_motes_lg");
	
	level._effect["mp_ray_flare_md"]									= loadfx("maps/mp_maps/fx_mp_ray_flare_md");
	level._effect["mp_battlesmoke_falling"]						= loadfx("maps/mp_maps/fx_mp_battlesmoke_falling");
	level._effect["mp_smoke_crater"]									= loadfx("maps/mp_maps/fx_mp_smoke_crater");
	level._effect["mp_pipe_steam"]										= loadfx("maps/mp_maps/fx_mp_pipe_steam");
	level._effect["mp_pipe_steam_random"]						= loadfx("maps/mp_maps/fx_mp_pipe_steam_random");
	
	level._effect["mp_light_glow_indoor_short"]				= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_loop");
//	level._effect["mp_light_glow_indoor_short_blinky"]	= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_blinky");
	level._effect["mp_light_glow_outdoor_long"]				= loadfx("maps/mp_maps/fx_mp_light_glow_outdoor_long_loop");
	
	level._effect["mp_dust_spill_runner"]							= loadfx("maps/mp_maps/fx_mp_dust_spill_runner");
	
	level._effect["mp_light_corona_cool"]							= loadfx("maps/mp_maps/fx_mp_light_corona_cool");
	level._effect["mp_light_lamp"]										= loadfx("maps/mp_maps/fx_mp_light_lamp");
	level._effect["mp_light_corona_bulb_ceiling"]			= loadfx("maps/mp_maps/fx_mp_light_corona_bulb_ceiling");
}

spawnFX()
{
	maps\mp\createfx\mp_subway_fx::main();
}    

