//
// file: la_2_fx.gsc
// description: clientside fx script for la_2: setup, special fx functions, etc.
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


// --- FX DEPT SECTION ---//
precache_createfx_fx()
{
// Exploders
// level._effect["fx_la_exp_gas_station_lg"]        = LoadFX("maps/la/fx_la_exp_gas_station_lg"); 					// exploder 105
// level._effect["fx_la_exp_huge_ground"]           = LoadFX("maps/la/fx_la_exp_huge_ground");    					// exploder 110
// level._effect["fx_la2_f35_vtol_take_off"]        = LoadFX("maps/la2/fx_la2_f35_vtol_take_off");           // exploder 470 
 
 level._effect["fx_la2_exp_building_hero"]        = LoadFX("maps/la2/fx_la2_exp_building_hero");
 level._effect["fx_la2_exp_crumble_building_hero"] = LoadFX("maps/la2/fx_la2_exp_crumble_building_hero");  
 level._effect["fx_exp_la2_garage"]               = LoadFX("explosions/fx_exp_la2_garage");
 level._effect["fx_dest_la2_garage_collapse"]     = LoadFX("destructibles/fx_dest_la2_garage_collapse");  	
 level._effect["fx_la2_garage_dust_collapse"]     = LoadFX("maps/la2/fx_la2_garage_dust_collapse");
 level._effect["fx_la2_garage_dust_linger"]       = LoadFX("maps/la2/fx_la2_garage_dust_linger");  
 level._effect["fx_la2_building_collapse_os"]     = LoadFX("maps/la2/fx_la2_building_collapse_os");
 level._effect["fx_la2_crane_spark_burst"]        = LoadFX("maps/la2/fx_la2_crane_spark_burst");  
 level._effect["fx_la2_dest_billboard_bottom"]    = LoadFX("destructibles/fx_la2_dest_billboard_bottom");   
 level._effect["fx_la2_dest_billboard_top_impact"]= LoadFX("destructibles/fx_la2_dest_billboard_top_impact");
 level._effect["fx_la2_f38_swarm"]                = LoadFX("maps/la2/fx_la2_f38_swarm"); 
 level._effect["fx_la2_debris_falling"]           = LoadFX("maps/la2/fx_la2_debris_falling");  
 level._effect["fx_la2_drone_swarm_exp"]          = LoadFX("maps/la2/fx_la2_drone_swarm_exp");
 level._effect["fx_la2_f38_swarm_formation"]      = LoadFX("maps/la2/fx_la2_f38_swarm_formation");    
 level._effect["fx_la2_explo_field"]              = LoadFX("maps/la2/fx_la2_explo_field");
 level._effect["fx_la2_f38_swarm_distant"]        = LoadFX("maps/la2/fx_la2_f38_swarm_distant"); 
 
 level._effect["fx_la2_spot_harper"]              = LoadFX("light/fx_la2_spot_harper");          
      
 level._effect["fx_la2_smoke_intro_aftermath"]      = LoadFX("maps/la2/fx_la2_smoke_intro_aftermath"); 
 level._effect["fx_la2_smoke_intro_aftermath_sm"]   = LoadFX("maps/la2/fx_la2_smoke_intro_aftermath_sm"); 	 	
 level._effect["fx_building_collapse_aftermath_sm"] = LoadFX("maps/la/fx_building_collapse_aftermath_sm"); 
 level._effect["fx_la2_ash_windy_heavy_sm"]         = LoadFX("maps/la2/fx_la2_ash_windy_heavy_sm"); 
 level._effect["fx_la2_ash_windy_heavy_md"]         = LoadFX("maps/la2/fx_la2_ash_windy_heavy_md");
 level._effect["fx_la2_debris_papers_fall_burning"] = LoadFX("env/debris/fx_la2_debris_papers_fall_burning");
 level._effect["fx_la2_debris_papers_windy_slow"]   = LoadFX("env/debris/fx_la2_debris_papers_windy_slow");   
 level._effect["fx_la2_debris_papers_fall_burning_xlg"] = LoadFX("env/debris/fx_la2_debris_papers_fall_burning_xlg"); 
 level._effect["fx_fire_fuel_sm"]                   = LoadFX("fire/fx_fire_fuel_sm");
 level._effect["fx_fire_fuel_sm_smolder"]           = LoadFX("fire/fx_fire_fuel_sm_smolder");  
 level._effect["fx_la2_fire_fuel_sm"]					  	  = LoadFX("maps/la2/fx_la2_fire_fuel_sm");	   
 level._effect["fx_la2_road_flare_distant"]         = LoadFX("light/fx_la2_road_flare_distant");        
 level._effect["fx_la2_billboard_glow_med"]         = LoadFX("maps/la2/fx_la2_billboard_glow_med");
 level._effect["fx_la2_light_beacon_red"]           = LoadFX("light/fx_la2_light_beacon_red");       
 level._effect["fx_la2_light_beacon_white"]         = LoadFX("light/fx_la2_light_beacon_white");
 level._effect["fx_la2_light_beacon_blue"]          = LoadFX("light/fx_la2_light_beacon_blue");   
 level._effect["fx_la2_light_beacon_red_blink"]     = LoadFX("light/fx_la2_light_beacon_red_blink"); 
 level._effect["fx_la2_light_beacon_blue_blink"]    = LoadFX("light/fx_la2_light_beacon_blue_blink");
 level._effect["fx_la2_light_beam_streetlamp_intro"] = LoadFX("maps/la2/fx_la2_light_beam_streetlamp_intro");          
  
 level._effect["fx_contrail_spawner"]             = LoadFX("maps/la/fx_la_contrail_sky_spawner");
 
 level._effect["fx_la2_tracers_antiair"]          = LoadFX("weapon/antiair/fx_la2_tracers_antiair"); 
 level._effect["fx_la2_tracers_antiair_playspace"] = LoadFX("weapon/antiair/fx_la2_tracers_antiair_playspace");  
 level._effect["fx_la2_tracers_dronekill"]        = LoadFX("weapon/antiair/fx_la2_tracers_dronekill");     
 level._effect["fx_elec_burst_shower_lg_runner"]  = LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");  
 level._effect["fx_la2_elec_burst_xlg_runner"]    = LoadFX("env/electrical/fx_la2_elec_burst_xlg_runner"); 
 level._effect["fx_la2_elec_spark_runner_sm"]     = LoadFX("electrical/fx_la2_elec_spark_runner_sm");    
	 
// Fires
 level._effect["fx_la2_fire_window_lg"]           = LoadFX("env/fire/fx_la2_fire_window_lg");  
 level._effect["fx_la2_fire_window_xlg"]          = LoadFX("env/fire/fx_la2_fire_window_xlg");
 level._effect["fx_la2_fire_lg"]                  = LoadFX("env/fire/fx_la2_fire_lg"); 
 level._effect["fx_la2_fire_xlg"]                 = LoadFX("env/fire/fx_la2_fire_xlg");    
 level._effect["fx_la2_fire_line_xlg"]            = LoadFX("env/fire/fx_la2_fire_line_xlg"); 
 level._effect["fx_la2_ember_column"]             = LoadFX("env/fire/fx_la2_ember_column"); 
 level._effect["fx_la2_smolder_mortar_crater"]    = LoadFX("env/fire/fx_la2_smolder_mortar_crater"); 
 level._effect["fx_la2_fire_palm"]                = LoadFX("env/fire/fx_la2_fire_palm");   
 level._effect["fx_la2_fire_palm_detail"]         = LoadFX("env/fire/fx_la2_fire_palm_detail"); 
 level._effect["fx_la2_fire_veh"]                 = LoadFX("env/fire/fx_la2_fire_veh");  
 level._effect["fx_la2_fire_veh_sm"]              = LoadFX("env/fire/fx_la2_fire_veh_sm");           
 
// Smoke
 level._effect["fx_la_smk_cloud_med"]             = LoadFX("env/smoke/fx_la_smk_cloud_med"); 
 level._effect["fx_la_smk_cloud_xlg"]             = LoadFX("env/smoke/fx_la_smk_cloud_xlg");
 level._effect["fx_la_smk_cloud_battle_lg"]       = LoadFX("env/smoke/fx_la_smk_cloud_battle_lg");   
 level._effect["fx_smoke_building_med"]           = LoadFX("env/smoke/fx_la2_smk_plume_building_med");
 level._effect["fx_smoke_building_xlg"]           = LoadFX("env/smoke/fx_la2_smk_plume_building_xlg");
 level._effect["fx_la_smk_plume_buidling_hero"]   = LoadFX("env/smoke/fx_la_smk_plume_buidling_hero"); 
 level._effect["fx_la_smk_low_distant_med"]       = LoadFX("env/smoke/fx_la_smk_low_distant_med");  
 level._effect["fx_la_smk_low_distant_xlg"]       = LoadFX("env/smoke/fx_la_smk_low_distant_xlg"); 
 level._effect["fx_la_smk_plume_distant_med"]     = LoadFX("env/smoke/fx_la_smk_plume_distant_med");  
 level._effect["fx_la_smk_plume_distant_lg"]      = LoadFX("env/smoke/fx_la_smk_plume_distant_lg"); 
 level._effect["fx_la_smk_plume_distant_xlg"]     = LoadFX("env/smoke/fx_la_smk_plume_distant_xlg");
 level._effect["fx_la2_smk_bld_wall_right_sm"]   = LoadFX("smoke/fx_la2_smk_bld_wall_right_sm");  
 level._effect["fx_la2_smk_bld_wall_left_xlg"]    = LoadFX("smoke/fx_la2_smk_bld_wall_left_xlg");   
 level._effect["fx_la2_smk_bld_wall_right_xlg"]   = LoadFX("smoke/fx_la2_smk_bld_wall_right_xlg");  
 level._effect["fx_la2_smk_bld_wall_north_lg"]    = LoadFX("smoke/fx_la2_smk_bld_wall_north_lg"); 
 level._effect["fx_la2_vista_smoke_plume_01_right"] = LoadFX("smoke/fx_la2_vista_smoke_plume_01_right");  
 level._effect["fx_la2_vista_smoke_plume_01_left"]  = LoadFX("smoke/fx_la2_vista_smoke_plume_01_left");     
 
 level._effect["fx_lf_la_sun2"]                     = LoadFX("lens_flares/fx_lf_la_sun2");  
 level._effect["fx_lf_la_sun2_flight"]                     = LoadFX("lens_flares/fx_lf_la_sun2_flight");  
 
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}*/


main()
{
	clientscripts\createfx\la_2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

