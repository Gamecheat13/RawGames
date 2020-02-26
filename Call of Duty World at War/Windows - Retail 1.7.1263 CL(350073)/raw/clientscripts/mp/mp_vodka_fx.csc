#include clientscripts\mp\_utility;

precache_util_fx()
{	
}

precache_scripted_fx()
{
}

precache_createfx_fx()
{  
		level._effect["mp_fire_small"]							        = loadfx("maps/mp_maps/fx_mp_fire_small_noglow");		
		level._effect["mp_fire_medium"]							        = loadfx("maps/mp_maps/fx_mp_fire_medium_noglow");	
		level._effect["mp_fire_large"]							        = loadfx("maps/mp_maps/fx_mp_fire_large_noglow");
		level._effect["mp_barrel_fire"]							        = loadfx("maps/mp_maps/fx_mp_barrel_fire");
		level._effect["mp_fire_rubble_md_smk"]							= loadfx("maps/mp_maps/fx_mp_fire_rubble_md_smk");
		level._effect["mp_fire_rubble_detail_grp"]					= loadfx("maps/mp_maps/fx_mp_fire_rubble_detail_grp");
		level._effect["mp_fire_xl_distant"]									= loadfx("env/fire/fx_fire_xlarge_distant");
		
		level._effect["mp_roof_ash_embers"]							  	= loadfx("maps/mp_maps/fx_mp_roof_ash_embers");
		level._effect["mp_roof_embers"]							  			= loadfx("maps/mp_maps/fx_mp_roof_embers_falling");	
		level._effect["mp_dust_motes"]							  			= loadfx("maps/mp_maps/fx_mp_dust_mote_pcloud_md");
		
		level._effect["mp_water_drips_hvy_narrow"]					= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_narrow");
		level._effect["mp_water_drips_hvy_long"]						= loadfx("maps/mp_maps/fx_mp_water_drips_hvy_long_col");

		level._effect["mp_fog_low"]													= loadfx("maps/mp_maps/fx_mp_fog_low");

		level._effect["mp_smoke_plume_med_slow_smolder"]		= loadfx("maps/mp_maps/fx_mp_smoke_plume_med_slow_smolder");
		level._effect["mp_smoke_plume_sm_fst_blk"]					= loadfx("maps/mp_maps/fx_mp_smoke_plume_sm_fast_blk");
		level._effect["mp_smoke_plume_md_fst_blk"]					= loadfx("maps/mp_maps/fx_mp_smoke_plume_md_fast_blk");	
		level._effect["mp_smoke_thick_indoor"]							= loadfx("maps/mp_maps/fx_mp_smoke_thick_indoor");		
		level._effect["mp_smoke_crater"]										= loadfx("maps/mp_maps/fx_mp_smoke_crater");

		level._effect["mp_insects_lantern"]									= loadfx("maps/mp_maps/fx_mp_insects_lantern");
		level._effect["mp_insect_swarm"]										= loadfx("maps/mp_maps/fx_mp_insect_swarm");		
				
		level._effect["mp_pipe_steam_lg"]						  			= loadfx("maps/mp_maps/fx_mp_pipe_steam_lg");	
		level._effect["mp_pipe_steam_random"]						  	= loadfx("maps/mp_maps/fx_mp_pipe_steam_random");	
	  
		level._effect["mp_elec_wire_spark_lg"]							= loadfx("maps/mp_maps/fx_mp_elec_wire_spark_lg");
		
		level._effect["mp_light_lantern_day"]								= loadfx("maps/mp_maps/fx_mp_light_glow_lantern_day");	
		level._effect["mp_light_glow_indoor"]								= loadfx("maps/mp_maps/fx_mp_light_glow_indoor_soft");
		level._effect["mp_ray_fire_thin"]										= loadfx("maps/mp_maps/fx_mp_ray_fire_thin");
		level._effect["mp_ray_fire_ribbon"]									= loadfx("maps/mp_maps/fx_mp_ray_fire_ribbon");
		level._effect["mp_light_lamp_yellow"]						 		= loadfx("maps/mp_maps/fx_mp_light_lamp_yellow");		
		level._effect["mp_godray_yellow_small"]						  = loadfx("maps/mp_maps/fx_mp_godray_yellow_small");	
		level._effect["mp_godray_yellow_xsmall"]						= loadfx("maps/mp_maps/fx_mp_godray_yellow_xsmall");	
		level._effect["mp_godray_yellow_xsmall_wide"]				= loadfx("maps/mp_maps/fx_mp_godray_yellow_xsmall_wide");
	  level._effect["mp_fire_dlight"]						  				= loadfx("maps/mp_maps/fx_mp_fire_dlight");
	  level._effect["mp_fire_dlight_sm"]						  		= loadfx("maps/mp_maps/fx_mp_fire_dlight_sm");  
}

main()
{
	clientscripts\mp\createfx\mp_vodka_fx::main();
	clientscripts\mp\_fx::reportNumEffects();
	precache_util_fx();
	precache_createfx_fx();
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

 