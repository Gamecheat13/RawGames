//
// file: mp_stalingrad_fx.csc
// description: clientside fx script for mp_stalingrad: setup, special fx functions, etc.
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
	level._effect["mp_fire_static_small_detail"]			= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_dlight"]										= loadfx("maps/mp_maps/fx_mp_fire_dlight");
	level._effect["mp_fire_dlight_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");
	level._effect["mp_barrel_fire"]										= loadfx("maps/mp_maps/fx_mp_barrel_fire");

	level._effect["mp_ray_light_sm"]									= loadfx("env/light/fx_light_godray_overcast_sm");
	level._effect["mp_ray_light_md"]									= loadfx("maps/mp_maps/fx_mp_ray_overcast_md");
	level._effect["mp_ray_light_md_a"]								= loadfx("maps/mp_maps/fx_mp_ray_overcast_md_a");
	level._effect["mp_ray_light_lg"]									= loadfx("env/light/fx_light_godray_overcast_lg");
	level._effect["light_godray_overcast_xsm"]				= loadfx("env/light/fx_light_godray_overcast_xsm");

	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
	level._effect["mp_electric_sparks"]								= loadfx("maps/mp_maps/fx_mp_electric_sparks_dlight");
	level._effect["mp_light_distant"]									= loadfx("maps/mp_maps/fx_mp_light_distant");
	level._effect["mp_water_drips_hvy_long"]					= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	level._effect["mp_roof_ash_embers"]							  = loadfx("maps/mp_maps/fx_mp_roof_ash_embers");
	
	level._effect["mp_insect_swarm"]									= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["mp_dust_motes"]										= loadfx("maps/mp_maps/fx_mp_ray_motes_lg");
	level._effect["mp_dust_motes_md"]									= loadfx("maps/mp_maps/fx_mp_ray_motes_md");
	level._effect["mp_smoke_brush_smolder_sm"]				= loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_sm");
	level._effect["mp_smoke_sm_slow"]									= loadfx("maps/mp_maps/fx_mp_smoke_sm_slow");
	
	level._effect["mp_light_lamp"]										= loadfx("maps/mp_maps/fx_mp_light_lamp");
	level._effect["mp_light_bulb_sm_no_eo"]						= loadfx("maps/mp_maps/fx_mp_light_bulb_sm_no_eo");
	level._effect["mp_light_bulb_flicker"]						= loadfx("maps/mp_maps/fx_mp_light_bulb_flicker");	
	level._effect["mp_battlesmoke_small"]							= loadfx("maps/mp_maps/fx_mp_battlesmoke_brown_thick_small_area");
	level._effect["mp_elec_wire_spark_lg"]						= loadfx("maps/mp_maps/fx_mp_elec_wire_spark_lg");
	
	level._effect["mp_fog_low_brown"]									= loadfx("maps/mp_maps/fx_mp_fog_low_brown");
	level._effect["mp_fog_low_yellow"]								= loadfx("maps/mp_maps/fx_mp_fog_low_yellow");
	level._effect["mp_blowing_dust_yellow"]						= loadfx("maps/mp_maps/fx_mp_blowing_dust_yellow");
	level._effect["mp_pipe_cloud"]										= loadfx("maps/mp_maps/fx_mp_pipe_cloud");
	level._effect["mp_water_drips_rust"]							= loadfx("maps/mp_maps/fx_mp_water_drips_rust");					
}


main()
{
	clientscripts\mp\createfx\mp_stalingrad_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}