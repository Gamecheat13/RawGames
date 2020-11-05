#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "f35_light" ]					  	= LoadFX( "maps/la/fx_light_f35_ignore_z" );
	level._effect[ "drone_muzzle_flash" ] 				= LoadFX( "weapon/muzzleflashes/fx_rifle1_flash_base_creek" );
	level._effect[ "cougar_damage_smoke" ]				= LoadFX( "vehicle/vfire/fx_vsmoke_cougar_loop" );
	level._effect[ "dogfight_building_explosion" ] 		= LoadFX("maps/la/fx_la_exp_gas_station_lg"); 
	level._effect[ "dogfight_building_smoke" ] 			= LoadFX("maps/la/fx_building_collapse_aftermath"); 
	level._effect[ "plane_crash_smoke_concrete" ] 		= LoadFX( "impacts/fx_la_bldg_concrete_rocket_loop" );
	level._effect[ "plane_crash_smoke_glass" ] 			= LoadFX( "impacts/fx_la_bldg_glass_rocket_loop" );
	level._effect[ "plane_crash_smoke_distant" ] 		= LoadFX( "impacts/fx_la_bldg_concrete_rocket_1shot" );
	level._effect[ "vehicle_launch_trail" ] 			= LoadFX( "trail/fx_trail_vehicle_push_generic" );
	level._effect[ "crane_slam" ]						= LoadFX( "maps/la/fx_la_debris_crane_slam" );
	level._effect[ "eject_building_hit" ]				= LoadFX( "maps/la/fx_la_player_eject_impact_bldg" );
	level._effect[ "midair_collision_explosion" ]		= LoadFX( "maps/la2/fx_la2_exp_midair_collision" );
	level._effect[ "chaff" ]							= LoadFX( "vehicle/vexplosion/fx_heli_chaff" );
	level._effect[ "embers_on_player_in_f35_vtol" ]	 	= LoadFX( "maps/la2/fx_la2_f35_floating_embers" );
	level._effect[ "embers_on_player_in_f35_plane" ]	= LoadFX( "maps/la2/fx_la2_f35_floating_embers_conventional" );
	level._effect[ "ejection_seat_rocket" ]				= LoadFX( "maps/la2/fx_la2_f35_seat_eject_rocket" );
	level._effect[ "plane_deathfx_large" ]				= LoadFX( "explosions/fx_exp_aerial_dist" );
	level._effect[ "plane_deathfx_huge" ]				= LoadFX( "explosions/fx_exp_aerial_lg_dist" );
	level._effect[ "bigrig_death" ]						= LoadFX( "vehicle/vfire/fx_vfire_la2_18wheeler" );
	level._effect[ "drone_building_impact_paper_concrete" ] = LoadFX( "impacts/fx_la_drone_crash_concrete" );
	level._effect[ "drone_building_impact_paper_glass" ]= LoadFX( "impacts/fx_la_drone_crash_glass" );
	level._effect[ "siren_light" ]						= LoadFX( "light/fx_vlight_police_car_flashing" );
	
	// fxanim fx
	level._effect[ "parking_garage_pillar" ]			= LoadFX( "destructibles/fx_dest_la2_garage_pillar" );
	level._effect[ "parking_garage_wall" ]			  = LoadFX( "destructibles/fx_dest_la2_garage_wall" );	
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["crane_collapse"] = %fxanim_la_crane_collapse_anim; 
	addNotetrack_customFunction( "fxanim_props", "crane_fx_start", ::crane_rooftop_fx, "crane_collapse" );
	level.scr_anim["fxanim_props"]["crane_collapse_env"] = %fxanim_la_crane_collapse_env_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_top1"] = %fxanim_la_garage_pillar_top1_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_top2"] = %fxanim_la_garage_pillar_top2_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_mid1"] = %fxanim_la_garage_pillar_mid1_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_mid2"] = %fxanim_la_garage_pillar_mid2_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_btm1"] = %fxanim_la_garage_pillar_btm1_anim;
	level.scr_anim["fxanim_props"]["garage_pillar_btm2"] = %fxanim_la_garage_pillar_btm2_anim;
	level.scr_anim["fxanim_props"]["garage_roof"] = %fxanim_la_garage_roof_anim;
	level.scr_anim["fxanim_props"]["garage_corner"] = %fxanim_la_garage_corner_anim;
	level.scr_anim["fxanim_props"]["palm_lrg_destroy01"] = %fxanim_gp_tree_palm_lrg_dest01_anim;
	level.scr_anim["fxanim_props"]["palm_lrg_destroy02"] = %fxanim_gp_tree_palm_lrg_dest02_anim;
	level.scr_anim["fxanim_props"]["signal_tower"] = %fxanim_la_signal_tower_anim;
	level.scr_anim["fxanim_props"]["billboard_pillar_top01"] = %fxanim_la_billboard_pillar_top01_anim;
	level.scr_anim["fxanim_props"]["billboard_pillar_top02"] = %fxanim_la_billboard_pillar_top02_anim;

	// F35 panels
	level.scr_anim[ "fxanim_props" ][ "f35_panels_break" ] 			= %fxanim_la_cockpit_panels_break_anim;
	level.scr_anim[ "fxanim_props" ][ "f35_panels_break_loop" ][0] 	= %fxanim_la_cockpit_panels_loop_anim;
}

crane_rooftop_fx( e_crane )
{
	PlayFXOnTag( level._effect[ "crane_slam" ], e_crane, "crane_fx_jnt" );
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

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-172 28 0" );			// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5);	// change 0.5 to your desired wind strength percentage

}

main()
{
	initModelAnims();
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\la_2_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
}

