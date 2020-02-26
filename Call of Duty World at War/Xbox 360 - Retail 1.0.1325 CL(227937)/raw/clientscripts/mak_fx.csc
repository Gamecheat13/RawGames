//
// file: mak_fx.gsc
// description: clientside fx script for mak: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "brick",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "carpet",     LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "cloth",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete",   LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "dirt",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "foliage",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "gravel",     LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "grass",      LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "ice",        LoadFx( "bio/player/fx_footstep_snow" ) );
	clientscripts\_utility::setFootstepEffect( "metal",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "mud",        LoadFx( "bio/player/fx_footstep_mud" ) );
	clientscripts\_utility::setFootstepEffect( "paper",      LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "plaster",    LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "rock",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "sand",       LoadFx( "bio/player/fx_footstep_sand" ) );
	clientscripts\_utility::setFootstepEffect( "snow",       LoadFx( "bio/player/fx_footstep_snow" ) );
	clientscripts\_utility::setFootstepEffect( "water",      LoadFx( "bio/player/fx_footstep_water" ) );
	clientscripts\_utility::setFootstepEffect( "wood",       LoadFx( "bio/player/fx_footstep_dust" ) );
}

// --- QUINN SECTION ---//
precache_createfx_fx()
{
	level._effect["insects_lantern1"] = LoadFX( "bio/insects/fx_insects_lantern_1" );
	level._effect["insects_lantern2"] = LoadFX( "bio/insects/fx_insects_lantern_2" );
	level._effect["campfire_smolder"] = LoadFX( "env/fire/fx_fire_campfire_smolder" );
	level._effect["campfire_medium"] = LoadFX( "maps/mak/fx_fire_camp_med" ); 
	level._effect["chimney_smoke"] = LoadFX( "maps/mak/fx_smoke_chimney_med" );
	level._effect["chimney_smoke_large"] = LoadFX( "env/smoke/fx_smoke_wood_chimney_lrg" );
	level._effect["searchlight_1"] = LoadFX( "misc/fx_spotlight_large" );
	level._effect["bats_circling"] = LoadFX( "bio/animals/fx_bats_circling" );
	level._effect["bats_swarm"] = LoadFX( "bio/animals/fx_bats_circling_swarm" );
	level._effect["floor_rays_large"] = LoadFX( "maps/mak/fx_ray_linear_large" );
	level._effect["floor_rays_medium"] = LoadFX( "maps/mak/fx_ray_linear_med" );
	level._effect["plume_collapse_dust"] = LoadFX( "explosions/fx_dust_cloud_plume_1" );
	level._effect["mist_rolling"] = LoadFX( "maps/mak/fx_fog_rolling_thin" );
	level._effect["mist_rolling2"] = LoadFX( "maps/mak/fx_fog_rolling_thin2" );  
	level._effect["fire_barrel_medium"] = LoadFX( "env/fire/fx_fire_barrel_med" );
	level._effect["fire_barrel_small"] = LoadFX( "env/fire/fx_fire_barrel_small" );
	level._effect["glow_outdoor"] = LoadFX( "env/light/fx_glow_lampost_white_dim_static" );
	level._effect["glow_indoor"] = LoadFX( "env/light/fx_light_indoor_white_static" );
	level._effect["insects_swarm"] = LoadFX( "maps/mak/fx_insects_swarm" );
	level._effect["glow_spotlight"] = LoadFX( "env/light/fx_glow_spotlight_white_dim_static" );
	level._effect["sys_e_smoke_trail"] = LoadFX( "maps/mak/fx_sys_element_smoke_tail_small" );
	level._effect["fire_debris_small"] = LoadFX( "maps/mak/fx_fire_debris_small" ); 
	level._effect["fire_debris_med"] = LoadFX( "maps/mak/fx_fire_debris_med" );  
	level._effect["fire_debris_large"] = LoadFX( "maps/mak/fx_fire_debris_large" ); 
	level._effect["fire_debris_large_direct"] = LoadFX( "maps/mak/fx_fire_debris_large_directional" );  
	level._effect["glow_indoor_spot"] = LoadFX( "maps/mak/fx_light_glow_lantern_spot" ); 
	level._effect["fire_debris_large_single"] = LoadFX( "maps/mak/fx_fire_debris_large_single" );
	level._effect["fire_debris_ash_cloud"] = LoadFX( "maps/mak/fx_fire_debris_ash_cloud" );
	level._effect["fire_embers_patch"] = LoadFX( "maps/mak/fx_fire_debris_embers_patch" );
	level._effect["fire_embers_patch2"] = LoadFX( "maps/mak/fx_fire_debris_embers_patch2" );
	level._effect["fire_debris_med_line"] = LoadFX( "maps/mak/fx_fire_debris_med_line" ); 
	level._effect["fire_debris_med_line2"] = LoadFX( "maps/mak/fx_fire_debris_med_line2" ); 
	level._effect["fire_debris_med_line3"] = LoadFX( "maps/mak/fx_fire_debris_med_line3" ); 
	level._effect["fire_water_medium"] = LoadFX( "maps/mak/fx_fire_water_med" ); 
	level._effect["fire_water_small"] = LoadFX( "maps/mak/fx_fire_water_small" ); 
	level._effect["fire_smoke_column1"] = LoadFX( "maps/mak/fx_smoke_column" );
	level._effect["fire_smoke_column2"] = LoadFX( "maps/mak/fx_smoke_column2" ); 
	level._effect["fire_hut_d_light"] = LoadFX( "maps/mak/fx_fire_hut_d_light" );   
	level._effect["god_ray_moon1"] = LoadFX( "maps/mak/fx_ray_linear_large_moon" ); 
	level._effect["god_ray_moon2"] = LoadFX( "maps/mak/fx_ray_linear_large_moon2" );
	level._effect["god_ray_moon3"] = LoadFX( "maps/mak/fx_ray_linear_large_moon3" );
	level._effect["god_ray_moon4"] = LoadFX( "maps/mak/fx_ray_linear_large_moon4" ); 
	level._effect["god_ray_fire"] = LoadFX( "maps/mak/fx_ray_linear_fire_small" ); 
	level._effect["god_ray_fire2"] = LoadFX( "maps/mak/fx_ray_linear_fire_medium" );        
	level._effect["smoke_ambiance_indoor"] = LoadFX( "maps/mak/fx_smoke_ambiance_indoor" );  
	level._effect["water_flow"] = LoadFX( "maps/mak/fx_water_wake_flow" );  
	level._effect["water_splash_rocks"] = LoadFX( "maps/mak/fx_water_splash_rocks" ); 
	level._effect["water_wake_mist"] = LoadFX( "maps/mak/fx_water_wake_mist" );          
	level._effect["water_wake_ripples"] = LoadFX( "maps/mak/fx_water_ripples_small" ); 
	level._effect["lantern_on_global"]	= LoadFX( "env/light/fx_lights_lantern_on" );
	level._effect["glow_candle"] = LoadFX( "env/light/fx_dlight_candle_glow" );
}

event1()
{
	// Huts
	level._effect["hut1_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_large" ); 
	level._effect["hut2_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_med" ); 
	level._effect["hut3_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_xlarge" ); 
	level._effect["hut4_explosion"] 		 = LoadFx( "maps/mak/fx_explosion_charge_xlarge_main" ); 
	level._effect["hut4_smoke_trail"] 		 = LoadFX( "maps/mak/fx_sys_element_smoke_tail_med_emitter" ); 

	level._effect["corner_hut_explosion"]	 = LoadFX( "maps/mak/fx_explosion_charge_med_corner" ); 
	level.scr_sound["corner_hut_explosion"] = "exp_hut_corner"; 

	level._effect["shed_barrel_explosion"]	 = LoadFX( "maps/mak/fx_explosion_barrel_small" ); 
	level._effect["barrel_explosion"]		 = LoadFX( "destructibles/fx_barrelExp" ); 
	level._effect["barrel_trail"]			 = LoadFx( "destructibles/fx_dest_fire_trail_med" ); 

	// Tower Collapse
	level._effect["hut1_collapse"] 			 = LoadFx( "maps/mak/fx_fire_ewok_collapse_group" ); 
	level._effect["hut1_splash"] 			 = LoadFx( "maps/mak/fx_fire_ewok_splash_plume" ); 
	level._effect["hut1_smoke"] 			 = LoadFx( "maps/mak/fx_fire_ewok_smoke" ); 
	level._effect["hut1_fire_large"] 		 = LoadFx( "maps/mak/fx_fire_ewok_large" ); 
	level._effect["hut1_fire_medium"] 		 = LoadFx( "maps/mak/fx_fire_ewok_medium" ); 
	level._effect["hut1_fire_pole"] 		 = LoadFx( "maps/mak/fx_fire_ewok_medium_pole" ); 

	// Under Hut
	level._effect["under_hut"]				 = LoadFX( "maps/mak/fx_fire_hut_collapse_small" ); 

	// Guy 2 Shed
	level._effect["guy2shed"]				 = LoadFX( "maps/mak/fx_collapse_dust_plume_4" ); 
}	

event2()
{
	level._effect["birds_fly"] 				= LoadFx( "maps/pel2/fx_birds_tree_panic" );
}

event4()
{
	level._effect["truck_fuel_spill"] 		= LoadFx( "maps/mak/fx_fire_fuel_spill" );
	level._effect["truck_fuel_spill_fire"]	= LoadFx( "maps/mak/fx_fire_fuel_ground_emitter" );
}

event6()
{
	level._effect["tower_impact"]			= LoadFx( "maps/mak/fx_collapse_dust_plume_3" );
	level._effect["end_barrel_explosion"]	= LoadFx( "destructibles/fx_barrelExp" );
	level._effect["large_water_squib"]		= LoadFx( "impacts/large_waterhit" );
	level._effect["small_water_squib"]		= LoadFx( "impacts/small_waterhit" );
	level._effect["end_hut_explosion1"]		= LoadFx( "maps/mak/fx_explosion_charge_xlarge_2" );
	level._effect["end_hut_explosion2"]		= LoadFx( "maps/mak/fx_explosion_charge_xlarge_2_ending" );
}

main()
{
	clientscripts\createfx\mak_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	
	footsteps();
	
	precache_createfx_fx();
	
	event1();
	event2();
	event4();
	event6();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

