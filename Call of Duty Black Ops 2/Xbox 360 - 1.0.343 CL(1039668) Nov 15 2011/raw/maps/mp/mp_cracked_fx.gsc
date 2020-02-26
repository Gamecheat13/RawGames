#include maps\mp\_utility; 

// fx used by utility scripts
precache_util_fx()
{
	
}

// Scripted effects
precache_scripted_fx()
{
	level._effect["fx_rotor_main"] = LoadFx( "vehicle/props/fx_cobra_rotor_main_run_mp" );
	level._effect["fx_rotor_tail"] = LoadFx( "vehicle/props/fx_cobra_rotor_small_run_mp" );
}

// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_fire_lg"] 											= loadfx("env/fire/fx_fire_lg");
	level._effect["fx_fire_md"] 											= loadfx("env/fire/fx_fire_md");
	level._effect["fx_fire_sm"] 											= loadfx("env/fire/fx_fire_sm");
	level._effect["fx_fire_detail_sm"] 								= loadfx("env/fire/fx_fire_detail_sm_nodlight");
	level._effect["fx_mp_fire_sm_smolder_low"] 				= loadfx("maps/mp_maps/fx_mp_fire_sm_smolder_low");	
	
	level._effect["fx_fire_ember_column_md"]					= loadfx("env/fire/fx_fire_ember_column_md");
	level._effect["fx_ash_embers_light"]							= loadfx("maps/mp_maps/fx_mp_fire_ash_embers");

	level._effect["fx_smk_field_sm"]									= loadfx("maps/mp_maps/fx_mp_smk_field_sm");
	level._effect["fx_smk_field_md"]									= loadfx("maps/mp_maps/fx_mp_smk_field_md");
//	level._effect["fx_smk_field_lg"]									= loadfx("env/smoke/fx_smk_field_lg");

	level._effect["fx_smk_smolder_sm"]								= loadfx("maps/mp_maps/fx_mp_smk_smolder_sm");
	
	level._effect["fx_smk_vent"]											= loadfx("env/smoke/fx_smk_vent");	
	level._effect["fx_mp_smk_plume_xsm_grey"]					= loadfx("maps/mp_maps/fx_mp_smk_plume_xsm_grey");	
	level._effect["fx_mp_smk_plume_md_grey"]					= loadfx("maps/mp_maps/fx_mp_smk_plume_md_grey");	
	level._effect["fx_mp_smk_plume_lg_grey"]					= loadfx("maps/mp_maps/fx_mp_smk_plume_lg_grey");	
//	level._effect["fx_mp_smk_plume_xlg_grey_distant"]	= loadfx("maps/mp_maps/fx_mp_smk_plume_xlg_grey_distant");

	level._effect["fx_mp_elec_spark_power_line"]			= loadfx("maps/mp_maps/fx_mp_elec_spark_power_line");	
	level._effect["fx_mp_elec_spark_burst_md"]				= loadfx("maps/mp_maps/fx_mp_elec_spark_burst_md");		
	level._effect["fx_leaves_falling_lite"]						= loadfx("env/foliage/fx_leaves_falling_lite");
	level._effect["fx_mp_insects_swarm_lightsource"]	= loadfx("maps/mp_maps/fx_mp_insects_swarm_lightsource");	
	level._effect["fx_insect_swarm"]									= loadfx("maps/mp_maps/fx_mp_insect_swarm");
	level._effect["fx_insects_swarm_md_light"]				= loadfx("bio/insects/fx_insects_swarm_md_light");
	level._effect["fx_debris_papers"]									= loadfx("env/debris/fx_debris_papers");
	level._effect["fx_debris_papers_lg"]							= loadfx("env/debris/fx_debris_papers_lg");
	level._effect["fx_fumes_vent_sm"]									= loadfx("maps/mp_maps/fx_mp_fumes_vent_sm");
	level._effect["fx_fumes_haze_md"]									= loadfx("maps/mp_maps/fx_mp_fumes_haze_md");
	level._effect["fx_pipe_steam_md"]									= loadfx("env/smoke/fx_pipe_steam_md");

//	level._effect["fx_mp_fog_ground_md"]							= loadfx("maps/mp_maps/fx_mp_fog_ground_md");		

	level._effect["fx_dust_crumble_int_sm"]						= loadfx("env/dirt/fx_dust_crumble_int_sm");
	level._effect["fx_dust_crumble_int_md"]						= loadfx("env/dirt/fx_dust_crumble_int_md");
	
	level._effect["fx_mp_light_dust_motes_md"]				= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
//	level._effect["fx_light_godray_lrg_warm"]					= loadfx("env/light/fx_light_godray_lrg_warm");
	level._effect["fx_light_godray_md_warm"]					= loadfx("env/light/fx_light_godray_md_warm");
//	level._effect["fx_light_godray_sm_warm"]					= loadfx("env/light/fx_light_godray_sm_warm");
	
	level._effect["fx_seagulls_shore_distant"]				= loadfx("bio/animals/fx_seagulls_shore_distant");
	
	level._effect["fx_light_office_light_03"]							= loadfx("env/light/fx_light_office_light_03");
//	level._effect["fx_light_fluorescent_tube_bulb"]				= loadfx("env/light/fx_light_fluorescent_tube_bulb");
//	level._effect["fx_light_fluorescent_tube_bulb_set"]		= loadfx("env/light/fx_light_fluorescent_tube_bulb_set");
//	level._effect["fx_light_floodlight_int_blue"]					= loadfx("env/light/fx_light_floodlight_int_blue");
//	level._effect["fx_light_floodlight_ext_warm"]					= loadfx("env/light/fx_light_floodlight_ext_warm");
	level._effect["fx_light_tinhat_cage_white"]						= loadfx("env/light/fx_light_tinhat_cage_white");	
	
//	level._effect["fx_sand_windy_fast_sm_os"]							= loadfx("maps/mp_maps/fx_mp_sand_windy_fast_sm_os");
	level._effect["fx_sand_windy_fast_door_os"]						= loadfx("maps/mp_maps/fx_mp_sand_windy_fast_door_os");
//	level._effect["fx_sand_windy_heavy_sm"]								= loadfx("maps/mp_maps/fx_mp_sand_windy_heavy_sm");
	
	level._effect["fx_water_river_shore"]								= loadfx("maps/creek/fx_water_river_shore");
}

wind_initial_setting()
{
SetDvar( "enable_global_wind", 1); // enable wind for your level
SetDvar( "wind_global_vector", "-110 -100 -110" );    // change "0 0 0" to your wind vector
SetDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}

main()
{
	// art file would be called here
	
	precache_util_fx();
	precache_createfx_fx();
	precache_scripted_fx();
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\mp\createfx\mp_cracked_fx::main();
	
	maps\mp\createart\mp_cracked_art::main();
	
	wind_initial_setting();
}
