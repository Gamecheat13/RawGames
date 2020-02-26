#include maps\mp\_utility;

main()
{  
	maps\mp\createart\mp_nachtfeuer_art::main();
	precacheFX();
	spawnFX();
}

precacheFX()
{
	//---------------------------------------FX_DEPT---------------------------------------------------------
	
	level._effect["mp_battlesmoke_lg"]								= loadfx("maps/mp_maps/fx_mp_battlesmoke_thin_lg");
	level._effect["mp_fire_distant_150_150"]					= loadfx("maps/mp_maps/fx_mp_fire_150x150_tall_distant");
	level._effect["mp_fire_distant_150_600"]					= loadfx("maps/mp_maps/fx_mp_fire_150x600_tall_distant");
	level._effect["mp_fire_static_small_detail"]			= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_window_smk_rt"]						= loadfx("maps/mp_maps/fx_mp_fire_window_smk_rt");
	level._effect["mp_fire_window_smk_lf"]						= loadfx("maps/mp_maps/fx_mp_fire_window_smk_lf");
	level._effect["mp_fire_window"]										= loadfx("maps/mp_maps/fx_mp_fire_window");
	level._effect["mp_fire_rubble_small"]							= loadfx("maps/mp_maps/fx_mp_fire_rubble_small");
	level._effect["mp_fire_rubble_small_column_smldr"]	= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column_smldr");
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_rubble_md_lowsmk"]					= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_lowsmk");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_ray_spotlight_lg"]							= loadfx("maps/mp_maps/fx_mp_ray_spotlight_lg");
	level._effect["mp_ray_fire_thin"]									= loadfx("maps/mp_maps/fx_mp_ray_fire_thin");
	level._effect["mp_ray_fire_ribbon"]								= loadfx("maps/mp_maps/fx_mp_ray_fire_ribbon");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_column_lg"]								= loadfx("maps/mp_maps/fx_mp_fire_column_lg");
	
	level._effect["mp_ray_light_xsm"]									= loadfx("maps/mp_maps/fx_mp_ray_moon_xsm");
	level._effect["mp_ray_light_sm"]									= loadfx("maps/mp_maps/fx_mp_ray_moon_sm");
	level._effect["mp_ray_light_md"]									= loadfx("maps/mp_maps/fx_mp_ray_moon_md");
	level._effect["mp_ray_light_lg"]									= loadfx("maps/mp_maps/fx_mp_ray_moon_lg");
	level._effect["mp_ray_light_lg_1sd"]							= loadfx("maps/mp_maps/fx_mp_ray_moon_lg_1sd");
	
	level._effect["mp_smoke_fire_column"]							= loadfx("maps/mp_maps/fx_mp_smoke_fire_column");
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
	level._effect["mp_smoke_hall"]										= loadfx("maps/mp_maps/fx_mp_smoke_hall");
	level._effect["mp_ash_and_embers"]								= loadfx("maps/mp_maps/fx_mp_ash_falling_large");
	level._effect["mp_light_glow_indoor_short"]				= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_loop");
	level._effect["mp_light_glow_outdoor_long"]				= loadfx("maps/mp_maps/fx_mp_light_glow_outdoor_long_loop");
	level._effect["mp_insects_lantern"]								= loadfx("maps/mp_maps/fx_mp_insects_lantern");
	
	level._effect["mp_electric_sparks"]								= loadfx("maps/mp_maps/fx_mp_electric_sparks");
	level._effect["mp_water_spill"]										= loadfx("maps/mp_maps/fx_mp_water_spill");
	level._effect["mp_water_spill_splash"]						= loadfx("maps/mp_maps/fx_mp_water_spill_splash");
	
	level._effect["a_fire_ceiling_100_100"]						= loadfx("env/fire/fx_fire_ceiling_100x100");
	level._effect["a_smokebank_thick_dist1"]					= loadfx("maps/ber3/fx_smokebank_thick_dist1");
	
	level._effect["a_debris_papers_windy"]						= loadfx("maps/mp_maps/fx_mp_debris_papers_windy");
	level._effect["a_embers_falling_sm"]							= loadfx("env/fire/fx_embers_falling_sm");
	
	level._effect["a_tracers_flak88_amb"]							= loadfx("maps/ber3/fx_tracers_flak88_amb");
	level._effect["mp_flak_field"]										= loadfx("maps/mp_maps/fx_mp_flak_field");
	level._effect["mp_flak_field_flash"]							= loadfx("maps/mp_maps/fx_mp_flak_field_flash");
}

spawnFX()
{
	maps\mp\createfx\mp_nachtfeuer_fx::main();
}