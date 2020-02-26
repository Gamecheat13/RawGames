#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

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
	
	level._effect[ "intro_cougar_godrays" ]		= LoadFX( "maps/la/fx_la_cougar_intro_godrays" );
	level._effect[ "intro_warp_smoke" ]			= LoadFX( "maps/la/fx_la_cougar_intro_smk_warp" );
	
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
	
	
	level._effect[ "siren_light" ]				= LoadFX( "light/fx_vlight_police_car_flashing" );
	
	level._effect[ "intro_warpcover" ] 			= LoadFX( "explosions/fx_vexp_la_tiara_warpcover" );
	level._effect[ "intro_blackhawk_explode" ] 	= LoadFX( "explosions/fx_vexp_blackhawk_la_intro" );
	level._effect[ "intro_blackhawk_trail" ] 	= LoadFX( "fire/fx_vfire_blackhawk_stealth_body" );
	level._effect[ "blackhawk_hit_ground" ] 	= LoadFX( "maps/la/fx_la_blackhawk_road_scrape" );
	level._effect[ "blackhawk_groundfx" ] 		= LoadFX( "maps/la/fx_la_treadfx_heli_blackhawk" );
	
	level._effect[ "close_call_drone_explode" ] = LoadFX( "explosions/fx_exp_la_drone_avenger" );
	level._effect[ "sam_drone_explode" ] 		= LoadFX( "explosions/fx_la_exp_drone_lg" );	
 	
	level._effect[ "cougar_dome_light" ]		= LoadFX( "light/fx_vlight_la_cougar_int_spot" );
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["f35_env"] = %fxanim_la_f35_env_anim;
	level.scr_anim["fxanim_props"]["bridge_explode"] = %fxanim_la_bridge_explode_anim;
	level.scr_anim["fxanim_props"]["bridge_explode_truck"] = %fxanim_la_bridge_explode_truck_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse"] = %fxanim_la_freeway_collapse_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse_car_01"] = %fxanim_la_freeway_collapse_car_01_anim;
	level.scr_anim["fxanim_props"]["freeway_wall"] = %fxanim_la_freeway_wall_anim;
	level.scr_anim["fxanim_props"]["freeway_wall_car"] = %fxanim_la_freeway_wall_car_anim;
	level.scr_anim["fxanim_props"]["freeway_cars"] = %fxanim_la_freeway_cars_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_01"] = %fxanim_la_debris_fall_lrg_01_short_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_02"] = %fxanim_la_debris_fall_lrg_02_short_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_03"] = %fxanim_la_debris_fall_lrg_03_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_01"] = %fxanim_la_debris_fall_sm_01_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_02"] = %fxanim_la_debris_fall_sm_02_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_03"] = %fxanim_la_debris_fall_sm_03_short_anim;
	level.scr_anim["fxanim_props"]["drone_chunks"] = %fxanim_la_drone_chunks_anim;
	level.scr_anim["fxanim_props"]["drone_explode"] = %fxanim_la_drone_explode_anim;
	
	addnotetrack_customfunction( "fxanim_props", "chunk_impact", maps\la_sam::drone_explode_impact, "drone_explode" );
}

// Ambient Effects
precache_createfx_fx()
{
	// Exploders
	// Event 1: 110 (Gump 1a)
	level._effect["fx_la_drone_avenger_invasion"]					= LoadFX("maps/la/fx_la_drone_avenger_invasion");	// 55
	level._effect["fx_la_drones_above_city"]							= loadFX("maps/la/fx_la_drones_above_city");
	// Event 2: They're Here (Gump 1b)
	level._effect["fx_la_distortion_cougar_exit"]					= LoadFX("maps/la/fx_la_distortion_cougar_exit");	// 1001
	level._effect["fx_la_post_cougar_crash_sunbeam"]			= loadFX("light/fx_la_post_cougar_crash_sunbeam");	// 1001
	level._effect["fx_la_cougar_slip_falling_debris"]			= LoadFX("maps/la/fx_la_cougar_slip_falling_debris");	// 201
	level._effect["fx_dust_la_kickup_cougar_slip"]				= LoadFX("dirt/fx_dust_la_kickup_cougar_slip");	// 202
	level._effect["fx_exp_cougar_fall"]										= LoadFX("explosions/fx_exp_la_cougar_fall");	// 203
	// Event 3: High Road, Low Road (Gump 1b)
	level._effect["fx_la_dust_rappel"]										= LoadFX("maps/la/fx_la_dust_rappel");	// 310,311
		// car alarm lights: 399
	// Event 4: Fast Lane (Gump 1c)
	level._effect["fx_la_exp_overpass_lower_lg"]					= LoadFX("maps/la/fx_la_exp_overpass_lower_lg");	// 10410
		// Debris impact: 10411
	level._effect["fx_dest_concrete_crack_dust_lg"]				= LoadFX("destructibles/fx_dest_concrete_crack_dust_lg");	// 10421-10430
	level._effect["fx_overpass_collapse_ground_impact"]		= LoadFX("maps/la/fx_overpass_collapse_ground_impact");	// 10431-10439
	
	
	// Ambient
	level._effect["fx_flak_field_50k"]										= LoadFX("maps/la/fx_la_flak_field_50k");
	level._effect["fx_la1_tracers_dronekill"]							= loadFX("weapon/antiair/fx_la1_tracers_dronekill");
	level._effect["fx_la1_rocket_dronekill"]							= loadFX("weapon/antiair/fx_la1_rocket_dronekill");
	
	level._effect["fx_concrete_crumble_area_sm"]					= LoadFX("dirt/fx_concrete_crumble_area_sm");
	level._effect["fx_la_overpass_debris_area_md"]				= LoadFX("maps/la/fx_la_overpass_debris_area_md");
	level._effect["fx_la_overpass_debris_area_lg"]				= LoadFX("maps/la/fx_la_overpass_debris_area_lg");
	level._effect["fx_la_overpass_debris_area_md_line"]		= LoadFX("maps/la/fx_la_overpass_debris_area_md_line");
	level._effect["fx_la_overpass_debris_area_md_line_wide"]= LoadFX("maps/la/fx_la_overpass_debris_area_md_line_wide");
	level._effect["fx_la_overpass_debris_area_xlg"]				= LoadFX("maps/la/fx_la_overpass_debris_area_xlg");
	level._effect["fx_la_overpass_debris_area_lg_os"]			= LoadFX("maps/la/fx_la_overpass_debris_area_lg_os");
	 
	// Fire
	level._effect["fx_fire_line_xsm"]											= LoadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_fuel_sm"]											= LoadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_fire_line_sm"]											= LoadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_fuel_sm_line"]									= LoadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm_ground"]								= LoadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_line_md"]											= LoadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]										= LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]										= LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_embers_falling_sm"]									= LoadFX("env/fire/fx_embers_falling_sm");
	level._effect["fx_embers_falling_md"]									= LoadFX("env/fire/fx_embers_falling_md");
	level._effect["fx_la2_fire_window_xlg"]								= LoadFX("env/fire/fx_la2_fire_window_xlg");
	level._effect["fx_la2_fire_line_xlg"]									= LoadFX("env/fire/fx_la2_fire_line_xlg");
	level._effect["fx_debris_papers_fall_burning_xlg"]		= LoadFX("debris/fx_paper_burning_ash_falling_xlg");
	level._effect["fx_ash_falling_xlg"]										= LoadFX("debris/fx_ash_falling_xlg");
	level._effect["fx_embers_up_dist"]										= loadFX("env/fire/fx_embers_up_dist");
	
	// Smoke
	level._effect["fx_smoke_building_xlg"]								= LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");
	level._effect["fx_smk_fire_xlg_black_dist"]						= LoadFX("env/smoke/fx_smk_fire_xlg_black_dist");
	level._effect["fx_smk_plume_md_blk_wispy_dist"]				= LoadFX("smoke/fx_smk_plume_md_blk_wispy_dist");
	level._effect["fx_smk_plume_lg_blk_wispy_dist"]				= LoadFX("smoke/fx_smk_plume_lg_blk_wispy_dist");
	level._effect["fx_smk_plume_md_gray_wispy_dist"]			= LoadFX("smoke/fx_smk_plume_md_gray_wispy_dist");
	level._effect["fx_smk_battle_lg_gray_slow"]						= LoadFX("smoke/fx_smk_battle_lg_gray_slow");
	level._effect["fx_smk_smolder_gray_fast"]							= LoadFX("smoke/fx_smk_smolder_gray_fast");
	level._effect["fx_smk_smolder_gray_slow"]							= LoadFX("smoke/fx_smk_smolder_gray_slow");
	level._effect["fx_smk_fire_md_black"]									= LoadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]									= LoadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]									= LoadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_la_smk_cloud_xlg"]									= LoadFX("smoke/fx_la1_smk_cloud_xlg_dist");
	level._effect["fx_la1_smk_battle_freeway"]						= LoadFX("smoke/fx_la1_smk_battle_freeway");
	level._effect["fx_la_smk_plume_buidling_thin"]				= LoadFX("env/smoke/fx_la_smk_plume_buidling_thin");
	level._effect["fx_la_smk_plume_buidling_med"]					= LoadFX("env/smoke/fx_la_smk_plume_buidling_med");
	level._effect["fx_la_smk_low_distant_med"]						= LoadFX("env/smoke/fx_la_smk_low_distant_med");
	level._effect["fx_la_smk_plume_distant_med"]					= LoadFX("env/smoke/fx_la_smk_plume_distant_med");
	level._effect["fx_la_smk_plume_distant_lg"]						= LoadFX("env/smoke/fx_la_smk_plume_distant_lg");
	level._effect["fx_la2_smk_bld_wall_right_xlg"]				= LoadFX("smoke/fx_la2_smk_bld_wall_right_xlg");
	level._effect["fx_la1_vista_smoke_plume_01_right"]		= loadFX("smoke/fx_la1_vista_smoke_plume_01_right");
	level._effect["fx_la1_vista_smoke_plume_02_right"]		= loadFX("smoke/fx_la1_vista_smoke_plume_02_right");
	level._effect["fx_la1_vista_smoke_plume_01_left"]			= loadFX("smoke/fx_la1_vista_smoke_plume_01_left");
	level._effect["fx_la1_vista_smoke_plume_02_left"]			= loadFX("smoke/fx_la1_vista_smoke_plume_02_left");
	
	// Other
	level._effect["fx_elec_burst_shower_sm_runner"]				= LoadFX("env/electrical/fx_elec_burst_shower_sm_runner");
	level._effect["fx_elec_burst_shower_lg_runner"]				= LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");
	level._effect["fx_la_road_flare"]											= LoadFX("light/fx_la_road_flare");
	level._effect["fx_vlight_car_alarm_headlight_os"]			= LoadFX("light/fx_vlight_car_alarm_headlight_os");
	level._effect["fx_vlight_car_alarm_taillight_os"]			= LoadFX("light/fx_vlight_car_alarm_taillight_os");
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
	maps\createfx\la_1_fx::main();

	wind_initial_setting();
}

createfx_setup()
{
	load_gump( "la_1_gump_1b" );
		
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
