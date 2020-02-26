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
 level._effect["fx_la_exp_gas_station_lg"]        = LoadFX("maps/la/fx_la_exp_gas_station_lg"); 					// exploder 105
 level._effect["fx_la_exp_huge_ground"]           = LoadFX("maps/la/fx_la_exp_huge_ground");    					// exploder 110
 
 level._effect["fx_exp_la2_garage"]               = LoadFX("explosions/fx_exp_la2_garage");
 level._effect["fx_dest_la2_garage_collapse"]     = LoadFX("destructibles/fx_dest_la2_garage_collapse");  	
 level._effect["fx_la2_garage_dust_collapse"]     = LoadFX("maps/la2/fx_la2_garage_dust_collapse");
 level._effect["fx_la2_garage_dust_linger"]       = LoadFX("maps/la2/fx_la2_garage_dust_linger");  
 level._effect["fx_la2_building_collapse_os"]     = LoadFX("maps/la2/fx_la2_building_collapse_os");
 level._effect["fx_la2_crane_spark_burst"]        = LoadFX("maps/la2/fx_la2_crane_spark_burst");  
      
 level._effect["fx_opening_building_dust"]          = LoadFX("maps/la/fx_building_collapse_aftermath"); 
 level._effect["fx_building_collapse_aftermath_sm"] = LoadFX("maps/la/fx_building_collapse_aftermath_sm"); 
 level._effect["fx_la2_ash_windy_heavy_md"]         = LoadFX("maps/la2/fx_la2_ash_windy_heavy_md");
 level._effect["fx_fire_150x600_tall_distant"]      = LoadFX("env/fire/fx_fire_150x600_tall_distant");
 level._effect["fx_la2_debris_papers_fall_burning"] = LoadFX("env/debris/fx_la2_debris_papers_fall_burning");
 level._effect["fx_la2_debris_papers_windy_slow"]   = LoadFX("env/debris/fx_la2_debris_papers_windy_slow");   
 level._effect["fx_debris_papers_fall_burning_xlg"] = LoadFX("env/debris/fx_debris_papers_fall_burning_xlg"); 
 level._effect["fx_fire_fuel_sm"]                   = LoadFX("fire/fx_fire_fuel_sm"); 
 level._effect["fx_fire_fuel_sm_ground"]            = LoadFX("fire/fx_fire_fuel_sm_ground");  
 level._effect["fx_la2_road_flare_distant"]         = LoadFX("light/fx_la2_road_flare_distant");      
   
 level._effect["fx_la2_billboard_glow_med"]         = LoadFX("maps/la2/fx_la2_billboard_glow_med");  
  
 
 level._effect["fx_dog_fight_type1"]              = LoadFX("maps/la/fx_la_aerial_dog_fight_type1");
 level._effect["fx_dog_fight_type1_b"]            = LoadFX("maps/la/fx_la_aerial_dog_fight_type1_b");
 level._effect["fx_dog_fight_type2"]              = LoadFX("maps/la/fx_la_aerial_dog_fight_type2");
 level._effect["fx_dog_fight_type2_b"]            = LoadFX("maps/la/fx_la_aerial_dog_fight_type2_b");
 level._effect["fx_dog_fight_lg"]             		= LoadFX("maps/la/fx_la_aerial_dog_fight_lg"); 
 level._effect["fx_flak_field_50k"]               = LoadFX("maps/la/fx_la_flak_field_50k");
 level._effect["fx_aerial_exp_filler"]            = LoadFX("maps/la/fx_la_exp_aerial_random_filler");
 level._effect["fx_contrail_spawner"]             = LoadFX("maps/la/fx_la_contrail_sky_spawner");
 
 level._effect["fx_la2_tracers_antiair"]          = LoadFX("weapon/antiair/fx_la2_tracers_antiair"); 
 level._effect["fx_la2_tracers_antiair_playspace"] = LoadFX("weapon/antiair/fx_la2_tracers_antiair_playspace");  
 level._effect["fx_la2_tracers_dronekill"]        = LoadFX("weapon/antiair/fx_la2_tracers_dronekill");     
 level._effect["fx_elec_burst_shower_lg_runner"]  = LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");  
 level._effect["fx_la2_elec_burst_xlg_runner"]    = LoadFX("env/electrical/fx_la2_elec_burst_xlg_runner");  
	 
// Fires
 level._effect["fx_la2_fire_window_lg"]           = LoadFX("env/fire/fx_la2_fire_window_lg");  
 level._effect["fx_la2_fire_window_xlg"]          = LoadFX("env/fire/fx_la2_fire_window_xlg");
 level._effect["fx_la2_fire_lg"]                  = LoadFX("env/fire/fx_la2_fire_lg"); 
 level._effect["fx_la2_fire_xlg"]                 = LoadFX("env/fire/fx_la2_fire_xlg");    
 level._effect["fx_la2_fire_line_xlg"]            = LoadFX("env/fire/fx_la2_fire_line_xlg"); 

 level._effect["fx_smk_fire_md_gray_int"]         = LoadFX("env/smoke/fx_smk_fire_md_gray_int");
 level._effect["fx_smk_fire_md_black"]            = LoadFX("env/smoke/fx_smk_fire_md_black");
 level._effect["fx_smk_fire_lg_black"]            = LoadFX("env/smoke/fx_smk_fire_lg_black");
 level._effect["fx_smk_fire_lg_white"]            = LoadFX("env/smoke/fx_smk_fire_lg_white");
 level._effect["fx_fire_column_creep_xsm"]        = LoadFX("env/fire/fx_fire_column_creep_xsm");
 level._effect["fx_fire_column_creep_sm"]         = LoadFX("env/fire/fx_fire_column_creep_sm");
 level._effect["fx_fire_wall_md"]            			= LoadFX("env/fire/fx_fire_wall_md");
 level._effect["fx_fire_ceiling_md"]           		= LoadFX("env/fire/fx_fire_ceiling_md");
 level._effect["fx_fire_line_xsm"]           		  = LoadFX("env/fire/fx_fire_line_xsm");
 level._effect["fx_fire_line_sm"]           		  = LoadFX("env/fire/fx_fire_line_sm");
 level._effect["fx_fire_line_md"]             		= LoadFX("env/fire/fx_fire_line_md");
 level._effect["fx_fire_sm_smolder"]              = LoadFX("env/fire/fx_fire_sm_smolder");
 level._effect["fx_fire_md_smolder"]              = LoadFX("env/fire/fx_fire_md_smolder");
 level._effect["fx_ash_embers_heavy"]             = LoadFX("env/fire/fx_ash_embers_heavy");
 level._effect["fx_embers_up_dist"]               = LoadFX("env/fire/fx_embers_up_dist");
 level._effect["fx_embers_falling_sm"]            = LoadFX("env/fire/fx_embers_falling_sm");
 level._effect["fx_embers_falling_md"]            = LoadFX("env/fire/fx_embers_falling_md"); 
 level._effect["fx_la2_smolder_mortar_crater"]    = LoadFX("env/fire/fx_la2_smolder_mortar_crater"); 
 level._effect["fx_la2_fire_palm"]                = LoadFX("env/fire/fx_la2_fire_palm");   
 level._effect["fx_la2_fire_palm_detail"]         = LoadFX("env/fire/fx_la2_fire_palm_detail");       
 
// Smoke
 level._effect["fx_la_smk_cloud_med"]             = LoadFX("env/smoke/fx_la_smk_cloud_med"); 
 level._effect["fx_la_smk_cloud_xlg"]             = LoadFX("env/smoke/fx_la_smk_cloud_xlg");
 level._effect["fx_la_smk_cloud_battle_lg"]       = LoadFX("env/smoke/fx_la_smk_cloud_battle_lg");   
 level._effect["fx_smoke_building_med"]           = LoadFX("env/smoke/fx_la_smk_plume_buidling_med");
 level._effect["fx_smoke_building_xlg"]           = LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");
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
 
}

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}


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

