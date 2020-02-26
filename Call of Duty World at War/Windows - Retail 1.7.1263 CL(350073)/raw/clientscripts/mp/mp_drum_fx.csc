//
// file: mp_drum_fx.csc
// description: clientside fx script for mp_drum: setup, special fx functions, etc.

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
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_dlight"]										= loadfx("maps/mp_maps/fx_mp_fire_dlight");
	level._effect["mp_fire_dlight_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");
	level._effect["mp_roof_ash_embers"]							  = loadfx("maps/mp_maps/fx_mp_roof_ash_embers");
	
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
	level._effect["mp_smoke_plume_med"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_med_slow_def");
	level._effect["mp_smoke_sm_slow"]									= loadfx("maps/mp_maps/fx_mp_smoke_sm_slow");
	level._effect["mp_smoke_crater"]									= loadfx("maps/mp_maps/fx_mp_smoke_crater");

	level._effect["mp_ray_light_sm"]									= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["light_godray_overcast_xsm"]				= loadfx("env/light/fx_light_godray_overcast_xsm");
	level._effect["mp_ray_slit"]											= loadfx("maps/mp_maps/fx_mp_ray_slit");	

	level._effect["mp_water_drips_hvy_long"]					= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	level._effect["mp_water_drips_rust"]							= loadfx("maps/mp_maps/fx_mp_water_drips_rust");
	level._effect["mp_water_wake_wide"]								= loadfx("maps/mp_maps/fx_mp_water_wake_wide");
	level._effect["mp_water_shimmers"]								= loadfx("maps/mp_maps/fx_mp_water_shimmers");
	level._effect["mp_water_wake_pillar"]							= loadfx("maps/mp_maps/fx_mp_water_wake_pillar");
	level._effect["mp_wavebreak_runner"]							= loadfx("maps/mp_maps/fx_mp_wavebreak_runner");
	
	level._effect["mp_dust_motes"]										= loadfx("maps/mp_maps/fx_mp_ray_motes_lg");
	level._effect["mp_dust_motes_md"]									= loadfx("maps/mp_maps/fx_mp_ray_motes_md");
	
	level._effect["mp_light_glow_indoor_short_red"]		= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_short_red");
	level._effect["mp_flashlight_yellow"]							= loadfx("maps/mp_maps/fx_mp_flashlight_yellow");
	
	level._effect["mp_elec_spark_runner"]							= loadfx("maps/mp_maps/fx_mp_elec_spark_runner");
	level._effect["mp_pipe_steam_lg"]									= loadfx("maps/mp_maps/fx_mp_pipe_steam_lg");	
	level._effect["mp_insect_swarm"]									= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["mp_fog_low_brown_thick"]						= loadfx("maps/mp_maps/fx_mp_fog_low_brown_thick");
	level._effect["mp_sea_mist_rolling"]							= loadfx("maps/mp_maps/fx_mp_sea_mist_rolling");
	level._effect["mp_birds_circling"]								= loadfx("maps/mp_maps/fx_mp_birds_circling");
	level._effect["mp_sea_mine"]											= loadfx("maps/mp_maps/fx_mp_sea_mine");
	level._effect["mp_seaweed"]												= loadfx("maps/mp_maps/fx_mp_seaweed");						
}


main()
{
	clientscripts\mp\createfx\mp_drum_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	precache_util_fx();
	precache_createfx_fx();
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}