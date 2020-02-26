#include maps\mp\_utility;

main()
{
	maps\mp\createart\mp_bgate_art::main();
	precacheFX();
	spawnFX();
}


precacheFX()
{
	level._effect["mp_fire_static_small_detail"]			= loadfx("maps/mp_maps/fx_mp_fire_small_detail");
	level._effect["mp_fire_rubble_md_smk"]						= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
	level._effect["mp_fire_rubble_detail_grp"]				= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
	level._effect["mp_fire_column_xsm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_xsm");
//	level._effect["mp_fire_column_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_column_sm");
	level._effect["mp_fire_dlight"]										= loadfx("maps/mp_maps/fx_mp_fire_dlight");
	level._effect["mp_fire_dlight_sm"]								= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");
	level._effect["mp_fire_dlight_orange"]			  		= loadfx("maps/mp_maps/fx_mp_fire_dlight_orange");	
	level._effect["mp_barrel_fire"]										= loadfx("maps/mp_maps/fx_mp_barrel_fire");
	level._effect["mp_fire_150x150_tall_distant"]	    = loadfx("maps/mp_maps/fx_mp_fire_150x150_tall_distant");
	level._effect["mp_fire_150x600_tall_distant"]	    = loadfx("maps/mp_maps/fx_mp_fire_150x600_tall_distant");
	level._effect["mp_embers_patch"]	                = loadfx("maps/mp_maps/fx_mp_embers_patch");
	level._effect["mp_roof_ash_embers"]							  = loadfx("maps/mp_maps/fx_mp_roof_ash_embers");	

	level._effect["mp_ray_light_sm"]									= loadfx("env/light/fx_light_godray_overcast_sm");
//	level._effect["mp_ray_light_md"]									= loadfx("maps/mp_maps/fx_mp_ray_overcast_md");
//	level._effect["mp_ray_light_md_a"]								= loadfx("maps/mp_maps/fx_mp_ray_overcast_md_a");
//	level._effect["mp_ray_light_lg"]									= loadfx("env/light/fx_light_godray_overcast_lg");
	level._effect["light_godray_overcast_xsm"]				= loadfx("env/light/fx_light_godray_overcast_xsm");	

	level._effect["mp_smoke_plume_med_wide"]  				= loadfx("maps/mp_maps/fx_mp_smoke_plume_med_wide");
	level._effect["mp_smoke_plume_med_slow_def"]  		= loadfx("maps/mp_maps/fx_mp_smoke_plume_med_slow_def");				
	level._effect["mp_smoke_plume_lg"]								= loadfx("maps/mp_maps/fx_mp_smoke_plume_lg");
	level._effect["mp_smoke_crater"]								  = loadfx("maps/mp_maps/fx_mp_smoke_crater");
	level._effect["mp_electric_sparks"]								= loadfx("maps/mp_maps/fx_mp_electric_sparks_dlight");
//	level._effect["mp_light_distant"]									= loadfx("maps/mp_maps/fx_mp_light_distant");
	level._effect["mp_water_drips_hvy_long"]					= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long");
	
	level._effect["mp_insect_swarm"]									= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["mp_dust_motes"]										= loadfx("maps/mp_maps/fx_mp_ray_motes_lg");
	level._effect["mp_dust_motes_md"]									= loadfx("maps/mp_maps/fx_mp_ray_motes_md");
	level._effect["mp_dust_falling_fx_runner"]				= loadfx("maps/mp_maps/fx_mp_dust_falling_fx_runner");
	level._effect["mp_dust_spill_far_runner"]			  	= loadfx("maps/mp_maps/fx_mp_dust_spill_far_runner");			
	level._effect["mp_smoke_brush_smolder_sm"]				= loadfx("maps/mp_maps/fx_mp_smoke_brush_smolder_sm");
	level._effect["mp_smoke_sm_slow"]									= loadfx("maps/mp_maps/fx_mp_smoke_sm_slow");

	level._effect["mp_light_lamp"]										= loadfx("maps/mp_maps/fx_mp_light_lamp");
	level._effect["mp_light_lamp_no_eo"]			  			= loadfx("maps/mp_maps/fx_mp_light_lamp_no_eo");
	level._effect["mp_light_bulb_sm_no_eo"]			 			= loadfx("maps/mp_maps/fx_mp_light_bulb_sm_no_eo");
	level._effect["mp_light_glow_lantern"]			  		= loadfx("maps/mp_maps/fx_mp_light_glow_lantern");
	level._effect["mp_light_bulb_flicker"]						= loadfx("maps/mp_maps/fx_mp_light_bulb_flicker");	
	level._effect["mp_battlesmoke_small"]							= loadfx("maps/mp_maps/fx_mp_battlesmoke_brown_thick_small_area");
	level._effect["mp_elec_wire_spark_lg"]						= loadfx("maps/mp_maps/fx_mp_elec_wire_spark_lg");
	level._effect["mp_battlesmoke_thick_large_area"]	= loadfx("maps/mp_maps/fx_mp_battlesmoke_thick_large_area");	
	
	level._effect["mp_fog_low_brown"]									= loadfx("maps/mp_maps/fx_mp_fog_low_brown");
	level._effect["mp_fog_low_yellow"]								= loadfx("maps/mp_maps/fx_mp_fog_low_yellow");
//	level._effect["mp_blowing_dust_yellow"]						= loadfx("maps/mp_maps/fx_mp_blowing_dust_yellow");
	level._effect["mp_pipe_cloud"]										= loadfx("maps/mp_maps/fx_mp_pipe_cloud");
	level._effect["mp_water_drips_rust"]							= loadfx("maps/mp_maps/fx_mp_water_drips_rust");	
	
	level._effect["mp_flak_field"]							      = loadfx("maps/mp_maps/fx_mp_flak_field");		
	level._effect["mp_flak_field_flash"]							= loadfx("maps/mp_maps/fx_mp_flak_field_flash");		
	level._effect["tracers_flak88_amb"]						   	= loadfx("maps/ber3/fx_tracers_flak88_amb");	
	
	level._effect["mp_ash_and_embers"]								= loadfx("maps/mp_maps/fx_mp_ash_falling_large");
	level._effect["mp_ash_only"]							      	= loadfx("maps/mp_maps/fx_mp_ash_only_large");								
}

spawnFX()
{
	maps\mp\createfx\mp_bgate_fx::main();
}