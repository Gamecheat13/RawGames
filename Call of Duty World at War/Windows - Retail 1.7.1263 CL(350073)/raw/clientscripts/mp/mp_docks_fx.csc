//
// file: mp_docks_fx.gsc
// description: clientside fx script for mp_docks: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 


// load fx used by util scripts
precache_util_fx()
{
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{
	level._effect["mp_rain_med_spot_sm"]				= loadfx("maps/mp_maps/fx_mp_rain_med_spot_sm");
	level._effect["mp_rain_med_spot_md"]				= loadfx("maps/mp_maps/fx_mp_rain_med_spot_md");
	level._effect["mp_rain_med_spot_md_short"]	= loadfx("maps/mp_maps/fx_mp_rain_med_spot_md_short");
	level._effect["mp_rain_med_spot_xlg"]				= loadfx("maps/mp_maps/fx_mp_rain_med_spot_xlg");
	level._effect["mp_rain_grnd_splash_sm"]			= loadfx("maps/mp_maps/fx_mp_rain_sm_grnd_splashes");
	level._effect["mp_rain_grnd_splash_med"]		= loadfx("maps/mp_maps/fx_mp_rain_med_grnd_splashes");
	level._effect["mp_rain_wtr_splash_lrg"]			= loadfx("maps/mp_maps/fx_mp_rain_lrg_wtr_splashes");
	
	level._effect["smoke_bank"]									= loadfx("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["smoke_hallway_faint_dark"]		= loadfx("env/smoke/fx_smoke_hallway_faint_dark");

	level._effect["fog_low_floor"]							= loadfx("maps/mp_maps/fx_mp_fog_low_floor_sm");
	
	level._effect["mp_flies_carcass"]						= loadfx("maps/mp_maps/fx_mp_flies_carcass");
	level._effect["mp_light_distant_white_lg"]	= loadfx("maps/mp_maps/fx_mp_light_distant_white_lg");
	level._effect["mp_light_distant_red"]				= loadfx("maps/mp_maps/fx_mp_light_distant_red");
	level._effect["mp_pipe_steam_lg"]						= loadfx("maps/mp_maps/fx_mp_pipe_steam_lg");
	level._effect["mp_smoke_column_short"]			= loadfx("maps/mp_maps/fx_mp_smoke_column_short");
	level._effect["mp_water_spill"]							= loadfx("maps/mp_maps/fx_mp_water_spill");
	level._effect["mp_water_spill_splash"]			= loadfx("maps/mp_maps/fx_mp_water_spill_splash");
	level._effect["mp_water_spill_splash_dir"]	= loadfx("maps/mp_maps/fx_mp_water_spill_splash_dir");
	level._effect["mp_ray_motes_md"]						= loadfx("maps/mp_maps/fx_mp_ray_motes_md");
	level._effect["mp_light_glow_outdoor_lg"]		= loadfx("maps/mp_maps/fx_mp_light_glow_outdoor_long_loop");
	level._effect["mp_water_wake_wide"]					= loadfx("maps/mp_maps/fx_mp_water_wake_wide");
	level._effect["mp_wtr_spill_sm_thin"]				= loadfx("maps/mp_maps/fx_mp_wtr_spill_sm_thin");
	level._effect["mp_water_drips_hvy_long"]		= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	level._effect["mp_water_drips_extra_long"]	= loadfx("maps/mp_maps/fx_mp_water_drips_extra_long");
	level._effect["mp_fog_low_sea"]							= loadfx("maps/mp_maps/fx_mp_fog_low_sea");
	level._effect["mp_fog_low_cube"]						= loadfx("maps/mp_maps/fx_mp_fog_low_cube");
	level._effect["mp_water_drips_hvy_narrow"]	= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_narrow");
	level._effect["mp_lightning_flash"]					= loadfx("maps/mp_maps/fx_mp_lightning_flash");
	
	level._effect["water_rain_distortion"]			= loadfx("env/water/fx_water_rain_distortion");
	level._effect["mp_rain_puddle_sm_long"]			= loadfx("maps/mp_maps/fx_mp_rain_puddle_sm_long");
	
	level._effect["mp_ray_light_sm"]						= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["mp_ray_light_xsm"]						= loadfx("env/light/fx_light_godray_overcast_xsm");
	level._effect["mp_ray_light_md"]						= loadfx("maps/mp_maps/fx_mp_ray_overcast_md_a");
	level._effect["mp_ray_light_lg"]						= loadfx("env/light/fx_light_godray_overcast_lg");
	level._effect["mp_ray_light_md_1sd"]				= loadfx("env/light/fx_light_godray_overcast_md_1sd");
	level._effect["mp_light_glow_rain"]					= loadfx("maps/mp_maps/fx_mp_light_glow_rain");
	level._effect["mp_light_glow_rain_cone"]		= loadfx("maps/mp_maps/fx_mp_light_rain_cone_fog");
	level._effect["mp_light_glow_rain_round"]		= loadfx("maps/mp_maps/fx_mp_light_glow_rain_round");
	level._effect["mp_light_glow_indoor_short"]	= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_loop");
	level._effect["mp_light_lamp"]							= loadfx("maps/mp_maps/fx_mp_light_lamp");
	level._effect["mp_spotlight_md"]						= loadfx("maps/mp_maps/fx_mp_spotlight_md");
	level._effect["mp_spotlight_lrg"]						= loadfx("maps/mp_maps/fx_mp_ray_spotlight_lg");
	level._effect["mp_light_bulb_ceiling_sm"]		= loadfx("maps/mp_maps/fx_mp_light_bulb_ceiling_sm");
	level._effect["mp_light_bulb_sm_no_eo"]			= loadfx("maps/mp_maps/fx_mp_light_bulb_sm_no_eo");
	
	level._effect["mp_fire_small_detail"]				= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_rubble_small"]							= loadfx("maps/mp_maps/fx_mp_fire_rubble_small");
	level._effect["mp_fire_rubble_small_column"]			= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column");
	level._effect["mp_fire_rubble_small_column_smldr"]	= loadfx("maps/mp_maps/fx_mp_fire_rubble_small_column_smldr");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_barrel_fire"]										= loadfx("maps/mp_maps/fx_mp_barrel_fire");
	level._effect["mp_fire_dlight_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");
}


main()
{
	clientscripts\mp\createfx\mp_docks_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	
}
