#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\la_utility;

#using_animtree("fxanim_props");

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "flesh_hit" ]				= LoadFX("impacts/fx_flesh_hit");
	
	level._effect[ "sniper_glint" ]				= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	level._effect[ "elec_spark" ]				= LoadFX( "env/electrical/fx_elec_burst_shower_lg_runner" );
	level._effect[ "brute_force_explosion" ]	= LoadFX( "explosions/fx_exp_la_vehicle_generic" );
	level._effect[ "arena_light" ] 				= LoadFX( "env/light/fx_la_light_arena_fill_lg" );
	level._effect[ "drone_smoke_trail" ]		= LoadFX( "trail/fx_trail_la_plane_pieces" );
	level._effect[ "car_explosion" ]			= LoadFX( "explosions/fx_vexp_cougar" );
	level._effect[ "ending_crash_explosion" ]	= LoadFX( "explosions/fx_exp_aerial_lg" );
	
	level._effect[ "vehicle_launch_trail" ]		= LoadFX( "trail/fx_trail_vehicle_push_generic" );
	
	level._effect[ "tanker_explosion" ]			= LoadFX( "explosions/fx_exp_tanker" );
	
	level._effect[ "cougar_crash" ]				= LoadFX( "maps/la/fx_la_cougar_glass_shatter" );
	
	level._effect[ "vehicle_impact_sm" ]		= LoadFX( "destructibles/fx_vehicle_scrape" );
	level._effect[ "vehicle_impact_lg" ]		= LoadFX( "destructibles/fx_vehicle_bump" );
	
	level._effect[ "vehicle_impact_front" ]		= LoadFX( "destructibles/fx_dest_car_front_crunch" );
	level._effect[ "vehicle_impact_rear" ]		= LoadFX( "destructibles/fx_dest_car_rear_crunch" );
	
	
	level._effect[ "siren_light" ]		= LoadFX( "light/fx_vlight_police_car_flashing" );
	
	level._effect[ "intro_warpcover" ] = LoadFX( "explosions/fx_vexp_la_tiara_warpcover" );
	level._effect[ "intro_blackhawk_explode" ] = LoadFX( "explosions/fx_vexp_blackhawk_la_intro" );
	level._effect[ "intro_blackhawk_trail" ] = LoadFX( "fire/fx_vfire_blackhawk_stealth_body" );
	level._effect[ "blackhawk_hit_ground" ] = LoadFX( "maps/la/fx_la_blackhawk_road_scrape" );
	level._effect[ "blackhawk_groundfx" ] = LoadFX( "maps/la/fx_la_treadfx_heli_blackhawk" );
	
	level._effect[ "close_call_drone_explode" ] = LoadFX( "explosions/fx_exp_la_drone_avenger" );
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["f35_env"] = %fxanim_la_f35_env_anim;
	level.scr_anim["fxanim_props"]["bridge_explode"] = %fxanim_la_bridge_explode_anim;
	level.scr_anim["fxanim_props"]["bridge_explode_truck"] = %fxanim_la_bridge_explode_truck_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse"] = %fxanim_la_freeway_collapse_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse_car_01"] = %fxanim_la_freeway_collapse_car_01_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_01"] = %fxanim_la_debris_fall_lrg_01_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_02"] = %fxanim_la_debris_fall_lrg_02_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_03"] = %fxanim_la_debris_fall_lrg_03_anim;
	level.scr_anim["fxanim_props"]["debris_sm_01"] = %fxanim_la_debris_fall_sm_01_anim;
	level.scr_anim["fxanim_props"]["debris_sm_02"] = %fxanim_la_debris_fall_sm_02_anim;
	level.scr_anim["fxanim_props"]["debris_sm_03"] = %fxanim_la_debris_fall_sm_03_anim;
	level.scr_anim["fxanim_props"]["drone_chunks"] = %fxanim_la_drone_chunks_anim;
	level.scr_anim["fxanim_props"]["drone_explode"] = %fxanim_la_drone_explode_anim;
	
//	addnotetrack_customfunction( "fxanim_props", "chunk_impact", maps\la_sam::drone_explode_impact, "drone_explode" );
}

// Ambient Effects
precache_createfx_fx()
{
	// Exploders
	// Event 1: 110 (Gump 1a)
	level._effect["fx_drone_path_avenger"]							= LoadFX("maps/la/fx_la_aerial_drone_path_avenger");	// 55
	// Event 2: They're Here (Gump 1b)
	level._effect["fx_la_distortion_cougar_exit"]				= loadFX("maps/la/fx_la_distortion_cougar_exit");	// 1001
	level._effect["fx_la_cougar_slip_falling_debris"]		= loadFX("maps/la/fx_la_cougar_slip_falling_debris");	// 201
	level._effect["fx_dust_la_kickup_cougar_slip"]			= loadFX("dirt/fx_dust_la_kickup_cougar_slip");	// 202
	level._effect["fx_exp_cougar_fall"]									= loadFX("explosions/fx_exp_la_cougar_fall");	// 203
	// Event 3: High Road, Low Road (Gump 1b)
	level._effect["fx_la_dust_rappel"]									= LoadFX("maps/la/fx_la_dust_rappel");	// 310,311
		// car alarm lights: 399
	// Event 4: Fast Lane (Gump 1c)
	level._effect["fx_la_exp_overpass_lower_lg"]				= LoadFX("maps/la/fx_la_exp_overpass_lower_lg");	// 10410
		// Debris impact: 10411
	level._effect["fx_dest_concrete_crack_dust_lg"]			= loadFX("destructibles/fx_dest_concrete_crack_dust_lg");	// 10421-10430
	level._effect["fx_overpass_collapse_ground_impact"]	= loadFX("maps/la/fx_overpass_collapse_ground_impact");	// 10431-10439
	// Event 5: No Way Out (Gump 1c)
	// Event 6: Through the Plaza to Staples Center (Gump 1c)
	// Event 7: Staples Center (Gump 1c)
	level._effect["fx_building_collapse_aftermath"]			= LoadFX("maps/la/fx_building_collapse_base_dust");	// 790
	level._effect["fx_building_fall_dust_wave"]					= LoadFX("maps/la/fx_building_collapse_debis_cloud");	// 790
	level._effect["fx_drone_wall_impact"]								= loadFX("impacts/fx_drone_wall_impact");	// 10700
	
	
	// Ambient
	// level._effect["fx_dog_fight_type1"]									= LoadFX("maps/la/fx_la_aerial_dog_fight_type1");
	// level._effect["fx_dog_fight_type1_b"]								= LoadFX("maps/la/fx_la_aerial_dog_fight_type1_b");
	// level._effect["fx_dog_fight_type2"]									= LoadFX("maps/la/fx_la_aerial_dog_fight_type2");
	// level._effect["fx_dog_fight_type2_b"]								= LoadFX("maps/la/fx_la_aerial_dog_fight_type2_b");
	// level._effect["fx_dog_fight_lg"]										= LoadFX("maps/la/fx_la_aerial_dog_fight_lg"); 
	// level._effect["fx_aerial_exp_filler"]								= LoadFX("maps/la/fx_la_exp_aerial_random_filler");
	//level._effect["fx_contrail_spawner"]								= LoadFX("maps/la/fx_la_contrail_sky_spawner");
	level._effect["fx_flak_field_50k"]									= LoadFX("maps/la/fx_la_flak_field_50k");
	
	level._effect["fx_concrete_crumble_area_sm"]				= loadFX("dirt/fx_concrete_crumble_area_sm");
	level._effect["fx_la_overpass_debris_area_md"]			= LoadFX("maps/la/fx_la_overpass_debris_area_md");
	level._effect["fx_la_overpass_debris_area_lg"]			= LoadFX("maps/la/fx_la_overpass_debris_area_lg");
	level._effect["fx_la_overpass_debris_area_md_line"]	= loadFX("maps/la/fx_la_overpass_debris_area_md_line");
	level._effect["fx_la_overpass_debris_area_md_line_wide"]= loadFX("maps/la/fx_la_overpass_debris_area_md_line_wide");
	level._effect["fx_la_overpass_debris_area_xlg"]			= LoadFX("maps/la/fx_la_overpass_debris_area_xlg");
	level._effect["fx_la_overpass_debris_area_lg_os"]		= loadFX("maps/la/fx_la_overpass_debris_area_lg_os");
	 
	// Fire
//	level._effect["fx_fire_column_creep_xsm"]						= LoadFX("env/fire/fx_fire_column_creep_xsm");
//	level._effect["fx_fire_column_creep_sm"]						= LoadFX("env/fire/fx_fire_column_creep_sm");
//	level._effect["fx_fire_wall_md"]										= LoadFX("env/fire/fx_fire_wall_md");
//	level._effect["fx_fire_ceiling_md"]									= LoadFX("env/fire/fx_fire_ceiling_md");
//	level._effect["fx_ash_embers_heavy"]								= LoadFX("env/fire/fx_ash_embers_heavy");
//	level._effect["fx_embers_up_dist"]									= LoadFX("env/fire/fx_embers_up_dist");
//	level._effect["fx_la2_fire_window_lg"]							= LoadFX("env/fire/fx_la2_fire_window_lg");
//	level._effect["fx_la2_fire_lg"]											= LoadFX("env/fire/fx_la2_fire_lg");
	level._effect["fx_fire_line_xsm"]										= LoadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_fuel_sm"]										= loadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_fire_line_sm"]										= LoadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_fuel_sm_line"]								= loadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm_ground"]							= loadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_line_md"]										= LoadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]									= LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]									= LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_embers_falling_sm"]								= LoadFX("env/fire/fx_embers_falling_sm");
	level._effect["fx_embers_falling_md"]								= LoadFX("env/fire/fx_embers_falling_md");
	level._effect["fx_la2_fire_window_xlg"]							= LoadFX("env/fire/fx_la2_fire_window_xlg");
	level._effect["fx_la2_fire_line_xlg"]								= LoadFX("env/fire/fx_la2_fire_line_xlg");
	level._effect["fx_debris_papers_fall_burning_xlg"]	= LoadFX("debris/fx_paper_burning_ash_falling_xlg");
	level._effect["fx_ash_falling_xlg"]									= loadFX("debris/fx_ash_falling_xlg");
	
	// Smoke
	level._effect["fx_smoke_building_xlg"]							= LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");
//	level._effect["fx_smk_plume_lg_gray_wispy_dist"]		= loadFX("smoke/fx_smk_plume_lg_gray_wispy_dist");
//	level._effect["fx_la_smk_low_distant_xlg"]					= loadFX("env/smoke/fx_la_smk_low_distant_xlg");
//	level._effect["fx_la_smk_plume_distant_xlg"]				= loadFX("env/smoke/fx_la_smk_plume_distant_xlg");
//	level._effect["fx_la2_smk_bld_wall_right_sm"]				= loadFX("smoke/fx_la2_smk_bld_wall_right_sm");
	level._effect["fx_smk_fire_xlg_black_dist"]					= loadFX("env/smoke/fx_smk_fire_xlg_black_dist");
	level._effect["fx_smk_plume_md_blk_wispy_dist"]			= loadFX("smoke/fx_smk_plume_md_blk_wispy_dist");
	level._effect["fx_smk_plume_lg_blk_wispy_dist"]			= loadFX("smoke/fx_smk_plume_lg_blk_wispy_dist");
	level._effect["fx_smk_plume_md_gray_wispy_dist"]		= loadFX("smoke/fx_smk_plume_md_gray_wispy_dist");
	level._effect["fx_smk_battle_lg_gray_slow"]					= loadFX("smoke/fx_smk_battle_lg_gray_slow");
	level._effect["fx_smk_smolder_gray_fast"]						= loadFX("smoke/fx_smk_smolder_gray_fast");
	level._effect["fx_smk_smolder_gray_slow"]						= loadFX("smoke/fx_smk_smolder_gray_slow");
	level._effect["fx_smk_fire_md_black"]								= LoadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]								= LoadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]								= LoadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_la_smk_cloud_xlg"]								= loadFX("smoke/fx_la1_smk_cloud_xlg_dist");
	level._effect["fx_la1_smk_battle_freeway"]					= loadFX("smoke/fx_la1_smk_battle_freeway");
	level._effect["fx_la_smk_plume_buidling_thin"]			= loadFX("env/smoke/fx_la_smk_plume_buidling_thin");
	level._effect["fx_la_smk_plume_buidling_med"]				= loadFX("env/smoke/fx_la_smk_plume_buidling_med");
	level._effect["fx_la_smk_low_distant_med"]					= loadFX("env/smoke/fx_la_smk_low_distant_med");
	level._effect["fx_la_smk_plume_distant_med"]				= loadFX("env/smoke/fx_la_smk_plume_distant_med");
	level._effect["fx_la_smk_plume_distant_lg"]					= loadFX("env/smoke/fx_la_smk_plume_distant_lg");
	level._effect["fx_la2_smk_bld_wall_right_xlg"]			= loadFX("smoke/fx_la2_smk_bld_wall_right_xlg");
	
	// Other
	level._effect["fx_elec_burst_shower_sm_runner"]			= loadFX("env/electrical/fx_elec_burst_shower_sm_runner");
	level._effect["fx_elec_burst_shower_lg_runner"]			= loadFX("env/electrical/fx_elec_burst_shower_lg_runner");
	level._effect["fx_la_road_flare"]										= loadFX("light/fx_la_road_flare");
	level._effect["fx_vlight_car_alarm_headlight_os"]		= loadFX("light/fx_vlight_car_alarm_headlight_os");
	level._effect["fx_vlight_car_alarm_taillight_os"]		= loadFX("light/fx_vlight_car_alarm_taillight_os");
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "155 -84 0" );		// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);			// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);			// change 10000 to your wind's upper bound
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
	maps\createfx\la_1b_fx::main();

	wind_initial_setting();
}

createfx_setup()
{
//	load_gump( "la_1_gump_1b" );
		
	m_cougar_crawl = Spawn( "script_model", (0, 0, 0) );
	m_cougar_crawl SetModel( "veh_t6_mil_cougar_destroyed" );
	
	animation = %animated_props::v_la_03_01_cougarcrawl_cougar;
	s_align = get_struct( "align_cougar_crawl" );
	
	m_cougar_crawl.origin = GetStartOrigin( s_align.origin, (0, 0, 0), animation );
	m_cougar_crawl.angles = GetStartAngles( s_align.origin, (0, 0, 0), animation );
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
	LoadFX( "bio/player/fx_footstep_dust" );
}
