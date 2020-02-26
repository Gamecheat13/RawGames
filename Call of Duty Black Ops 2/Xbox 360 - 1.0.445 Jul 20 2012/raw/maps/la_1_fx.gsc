#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_scene;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

#using_animtree("fxanim_props");

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "cellphone_glow" ]			= LoadFX( "light/fx_la_p6_cell_phone_glow" );
	level._effect[ "blood_spit" ]				= LoadFX( "blood/fx_blood_spit_lt" );
	level._effect[ "sec_drool" ]				= LoadFX( "blood/fx_blood_drool_slow" );
	
	level._effect["data_glove_glow"]	= loadFX("light/fx_la_data_glove_glow");
	
	level._effect[ "squibs_concrete" ]			= LoadFX( "weapon/fake/fx_fake_ap_tracer_impact_concrete" );
	level._effect[ "squibs_metal" ]				= LoadFX( "weapon/fake/fx_fake_ap_tracer_impact_metal" );
	
	level._effect[ "f35_exhaust_fly" ]			= LoadFX( "vehicle/exhaust/fx_exhaust_la2_f35_afterburner" );
	level._effect[ "f35_exhaust_hover_front" ]	= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_front" );
	level._effect[ "f35_exhaust_hover_rear" ]	= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_rear" );
	
	level._effect[ "flesh_hit" ]				= LoadFX("impacts/fx_flesh_hit");
	level._effect[ "rocket_explode" ]			= LoadFX("weapon/rocket/fx_rocket_xtreme_exp_default_la");
	level._effect[ "rocket_trail_2x" ]			= LoadFX( "trail/fx_geotrail_sidewinder_missile_la" );
	
	level._effect[ "sniper_glint" ]				= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	level._effect[ "intro_cougar_godrays" ]		= LoadFX( "maps/la/fx_la_cougar_intro_godrays" );
	level._effect[ "intro_warp_smoke" ]			= LoadFX( "maps/la/fx_la_cougar_intro_smk_warp" );
	
	level._effect[ "magic_cop_car_left" ]		= LoadFX( "maps/la/fx_la_cougar_intro_passing_cop_left" );
	level._effect[ "magic_cop_car_right" ]		= LoadFX( "maps/la/fx_la_cougar_intro_passing_cop_right" );
	
	level._effect[ "windshield_blood" ]			= LoadFX( "maps/la/fx_la_cougar_intro_windshield_blood" );
	level._effect[ "windshield_crack" ]			= LoadFX( "maps/la/fx_la_cougar_intro_windshield_crack" );
	
	level._effect[ "ambush_explosion" ]			= LoadFX( "explosions/fx_exp_la_around_cougar" );
	
	level._effect[ "vehicle_launch_trail" ]		= LoadFX( "trail/fx_trail_vehicle_push_generic" );
	
	//level._effect[ "tanker_explosion" ]			= LoadFX( "explosions/fx_exp_tanker" );
	
	level._effect[ "cougar_crash" ]				= LoadFX( "maps/la/fx_la_cougar_glass_shatter" );
	
	level._effect[ "vehicle_impact_sm" ]		= LoadFX( "destructibles/fx_vehicle_scrape" );
	level._effect[ "vehicle_impact_lg" ]		= LoadFX( "destructibles/fx_vehicle_bump" );
	
	level._effect[ "vehicle_impact_front" ]		= LoadFX( "destructibles/fx_dest_car_front_crunch" );
	level._effect[ "vehicle_impact_rear" ]		= LoadFX( "destructibles/fx_dest_car_rear_crunch" );	
	
	//-- TODO: remove this old effect if everything works
	//level._effect[ "siren_light" ]				= LoadFX( "light/fx_vlight_police_car_flashing" );
	level._effect[ "siren_light" ]				= LoadFX( "light/fx_vlight_t6_police_car_siren" );
	level._effect[ "siren_light_intro" ]		= LoadFX( "light/fx_vlight_police_car_flashing_la_intro" );
	
	level._effect[ "siren_light_bike" ]			= LoadFX( "light/fx_vlight_police_cycle_flashing" );
	level._effect[ "siren_light_bike_intro" ]	= LoadFX( "light/fx_vlight_police_cycle_flashing_la_intro" );
	
	level._effect[ "cougar_dashboard" ]			= LoadFX( "light/fx_vlight_cougar_dashboard" );
	
	level._effect[ "intro_warpcover" ] 			= LoadFX( "explosions/fx_vexp_la_tiara_warpcover" );
	level._effect[ "intro_blackhawk_explode" ] 	= LoadFX( "explosions/fx_vexp_blackhawk_la_intro" );
	level._effect[ "intro_blackhawk_trail" ] 	= LoadFX( "fire/fx_vfire_blackhawk_stealth_body" );
	level._effect[ "blackhawk_hit_ground" ] 	= LoadFX( "maps/la/fx_la_blackhawk_road_scrape" );
	level._effect[ "blackhawk_groundfx" ] 		= LoadFX( "maps/la/fx_la_treadfx_heli_blackhawk" );
	
	//level._effect[ "close_call_drone_explode" ] = LoadFX( "explosions/fx_exp_la_drone_avenger" );	// This isn't used anywhere
	level._effect[ "exp_la_drone_hit_by_missile" ] = loadFX("explosions/fx_exp_la_drone_hit_by_missile");
	level._effect[ "sam_drone_explode" ] 		= LoadFX( "explosions/fx_la_exp_drone_lg" );
	level._effect[ "sam_drone_explode_shockwave" ]	= LoadFX( "explosions/fx_exp_la_shockwave_view" );		
 	
	level._effect[ "cougar_dome_light" ]		= LoadFX( "light/fx_vlight_la_cougar_int_spot" );
	level._effect[ "cougar_monitor" ]			= LoadFX( "light/fx_la_cougar_monitor_glow" );
	level._effect[ "intro_dust" ]				= LoadFX( "maps/la/fx_la_cougar_intro_dust_motes" );
	
	level._effect[ "falling_sparks_tiny" ]		= LoadFX( "electrical/fx_elec_falling_sparks_tiny_os" );
	
	level._effect[ "fa38_drone_crash" ]			= LoadFX( "maps/la/fx_la_fa38_intro_drone_crash" );
	level._effect[ "fa38_car_scrape_side" ]		= LoadFX( "electrical/fx_la_fa38_intro_car_scrape_side" );
	level._effect[ "fa38_car_scrape_roof" ]		= LoadFX( "electrical/fx_la_fa38_intro_car_scrape_roof" );
	
	level._effect[ "intro_krail_scrape" ]		= LoadFX( "destructibles/fx_la_intro_krail_car_scrape" );
	
	level._effect[ "torso_fire" ]				= LoadFX( "env/fire/fx_fire_player_torso" );
	
	level._effect[ "cc_policeman_death" ] = loadFX("impacts/fx_body_fatal_exit_y");
	
	level._effect[ "bigrig_brake_light" ]			= LoadFX( "light/fx_vlight_brakelight_18wheeler" );
	level._effect["18wheeler_tire_smk_rt"]	= loadFX("smoke/fx_vsmk_tire_brake_18wheeler_rt");
	level._effect["18wheeler_tire_smk_lf"]	= loadFX("smoke/fx_vsmk_tire_brake_18wheeler_lf");
	level._effect["smk_fire_trail_vehicle_falling"]		= loadFX("trail/fx_smk_fire_trail_vehicle_falling");
	level._effect["sniper_bus_window_shatter"]	= loadFX("maps/la/fx_bus_windows_shatter");
	level._effect["platform_collapse_rpg_trail"] =	loadFX("maps/la/fx_la_platform_collapse_rpg_trail");
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["bridge_explode"] = %fxanim_la_bridge_explode_anim;
	level.scr_anim["fxanim_props"]["bridge_explode_truck"] = %fxanim_la_bridge_explode_truck_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse"] = %fxanim_la_freeway_collapse_anim;
	level.scr_anim["fxanim_props"]["freeway_collapse_car_01"] = %fxanim_la_freeway_collapse_car_01_anim;
	level.scr_anim["fxanim_props"]["freeway_wall"] = %fxanim_la_freeway_wall_anim;
	level.scr_anim["fxanim_props"]["freeway_wall_car"] = %fxanim_la_freeway_wall_car_anim;
	level.scr_anim["fxanim_props"]["freeway_cars_01"] = %fxanim_la_freeway_cars_01_anim;
	level.scr_anim["fxanim_props"]["freeway_cars_02"] = %fxanim_la_freeway_cars_02_anim;
	level.scr_anim["fxanim_props"]["freeway_drone"] = %fxanim_la_freeway_drone_anim;
	level.scr_anim["fxanim_props"]["freeway_fa38"] = %fxanim_la_freeway_fa38_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_01"] = %fxanim_la_debris_fall_lrg_01_short_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_02"] = %fxanim_la_debris_fall_lrg_02_short_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_03"] = %fxanim_la_debris_fall_lrg_03_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_01"] = %fxanim_la_debris_fall_sm_01_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_02"] = %fxanim_la_debris_fall_sm_02_short_anim;
	level.scr_anim["fxanim_props"]["debris_sm_03"] = %fxanim_la_debris_fall_sm_03_short_anim;
	level.scr_anim["fxanim_props"]["drone_krail"] = %fxanim_la_drone_krail_anim;
	level.scr_anim["fxanim_props"]["police_car_flip"] = %fxanim_la_police_car_flip_anim;
	level.scr_anim["fxanim_props"]["suv_flip"] = %fxanim_la_suv_flip_anim;
	level.scr_anim["fxanim_props"]["police_car_f35"] = %fxanim_la_police_car_f35_anim;
	level.scr_anim["fxanim_props"]["billboard_pillar_top03"] = %fxanim_la_billboard_pillar_top03_anim;
	level.scr_anim["fxanim_props"]["f35_blast_chunks"] = %fxanim_la_f35_blast_chunks_anim;
	level.scr_anim["fxanim_props"]["billboard_drone_shoot"] = %fxanim_la_billboard_drone_shoot_anim;
	level.scr_anim["fxanim_props"]["cougar_fall_debris"] = %fxanim_la_cougar_fall_debris_anim;
	level.scr_anim["fxanim_props"]["streetlight01"] = %fxanim_la_streetlight01_anim;
	level.scr_anim["fxanim_props"]["streetlight02"] = %fxanim_la_streetlight02_anim;
	level.scr_anim["fxanim_props"]["freeway_chunks_fall"] = %fxanim_la_freeway_chunks_fall_anim;
	level.scr_anim["fxanim_props"]["road_sign_snipe_01"] = %fxanim_la_road_sign_snipe_01_anim;
	level.scr_anim["fxanim_props"]["road_sign_snipe_02"] = %fxanim_la_road_sign_snipe_02_anim;
	level.scr_anim["fxanim_props"]["road_sign_snipe_03"] = %fxanim_la_road_sign_snipe_03_anim;
	level.scr_anim["fxanim_props"]["road_sign_snipe_04"] = %fxanim_la_road_sign_snipe_04_anim;
	level.scr_anim["fxanim_props"]["sniper_drone_crash_chunks"] = %fxanim_la_sniper_drone_crash_chunks_anim;
	level.scr_anim["fxanim_props"]["sniper_drone_crash_drone"] = %fxanim_la_sniper_drone_crash_drone_anim;
	level.scr_anim["fxanim_props"]["sniper_bus"] = %fxanim_la_sniper_bus_anim;
	level.scr_anim["fxanim_props"]["sniper_trains"] = %fxanim_la_sniper_trains_anim;
	level.scr_anim["fxanim_props"]["sniper_trains_02"] = %fxanim_la_sniper_trains_02_anim;
	level.scr_anim["fxanim_props"]["sniper_freeway"] = %fxanim_la_sniper_freeway_anim;
	level.scr_anim["fxanim_props"]["sniper_rappel_rope"] = %fxanim_la_sniper_rappel_rope_anim;
	
	addnotetrack_customfunction( "fxanim_props", "chunk_impact", maps\la_sam::drone_explode_impact, "drone_explode" );
}

// Ambient Effects
precache_createfx_fx()
{
	level._effect["fx_lf_la_1_sun"] 											= loadFX("lens_flares/fx_lf_la_sun2_flight");
	
	// Exploders
	// Event 1: 110 (Gump 1a)
	// intro fires and smokes: 10
	level._effect["fx_la_drone_avenger_invasion"]					= LoadFX("maps/la/fx_la_drone_avenger_invasion");	// 55
	level._effect["fx_ridiculously_large_exp_dist"]				= loadFX("explosions/fx_ridiculously_large_exp_dist");	// 204
	level._effect["fx_la1_smk_us_bank_top"]								= loadFX("smoke/fx_la1_smk_us_bank_top");	// 204
	// Event 2: They're Here (Gump 1b)
	level._effect["fx_la_distortion_cougar_exit"]					= LoadFX("maps/la/fx_la_distortion_cougar_exit");	// 1001
	level._effect["fx_la_post_cougar_crash_fire_spotlight"]			= loadFX("light/fx_la_post_cougar_crash_fire_spotlight");	// 1001
	level._effect["fx_elec_ember_shower_os_la_runner"]		= loadFX("electrical/fx_elec_ember_shower_os_la_runner");	// 1001
	level._effect["fx_la_cougar_slip_falling_debris"]			= LoadFX("maps/la/fx_la_cougar_slip_falling_debris");	// 201
	level._effect["fx_dust_la_kickup_cougar_slip"]				= LoadFX("dirt/fx_dust_la_kickup_cougar_slip");	// 202
	level._effect["fx_exp_cougar_fall"]										= LoadFX("explosions/fx_exp_la_cougar_fall");	// 203
	level._effect["fx_rocket_xtreme_exp_default_la"]			= loadFX("explosions/fx_rocket_xtreme_exp_rock_cheap");	// 210 - 213
	// SAM random damage effects: lamp post electric bursts: 220, 221
	level._effect["fx_vexp_gen_up_stage1_small"]					= loadFX("explosions/fx_vexp_gen_up_stage1_small");	// 222
	level._effect["fx_vexp_gen_up_stage3_medium"]					= loadFX("explosions/fx_vexp_gen_up_stage3_medium");	// 223
	level._effect["fx_vexp_gen_up_stage3_small"]					= loadFX("explosions/fx_vexp_gen_up_stage3_small");	// 224
	level._effect["fx_la2_fire_palm_detail"]							= loadFX("env/fire/fx_la2_fire_palm_detail");	// 225, 226
	level._effect["fx_la1_dest_billboard_drone"]					= loadFX("destructibles/fx_la1_dest_billboard_drone");	// 10351, 10352, 10353
	// Event 3: High Road, Low Road (Gump 1b)
	level._effect["fx_la_dust_rappel"]										= LoadFX("maps/la/fx_la_dust_rappel");	// 310,311
	// Non-windblown smoke and fire before F35 arrives: 312
	level._effect["fx_la_f35_vtol_distortion"]						= loadFX("maps/la/fx_la_f35_vtol_distortion");	// 313
	level._effect["fx_fire_fuel_sm_line_windblown"]				= loadFX("fire/fx_fire_fuel_sm_line_windblown");	// 313
	level._effect["fx_smk_fire_md_black_windblown"]				= loadFX("smoke/fx_smk_fire_md_black_windblown");	// 313
	level._effect["fx_exp_la_fa38_intro_shockwave_view"]	= loadFX("explosions/fx_exp_la_fa38_intro_shockwave_view");	// 314
	level._effect["fx_la_f35_vtol_distortion_takeoff"]		= loadFX("maps/la/fx_la_f35_vtol_distortion_takeoff");	// 20315
	//level._effect["fx_la_platform_collapse_rpg"]					= loadFX("maps/la/fx_la_platform_collapse_rpg");	// 301, 303 - Play .5 seconds before impact
	level._effect["fx_exp_la_around_cougar"]							= LoadFX( "explosions/fx_exp_la_around_cougar" );	// 302
	level._effect["fx_la_rocket_exp_concrete_overhang"]		= loadFX("explosions/fx_la_rocket_exp_concrete_overhang");	// 304
	level._effect["fx_la_platform_collapse_car_impact"]		= loadFX("maps/la/fx_la_platform_collapse_car_impact");	// 305
	level._effect["fx_exp_la_drone_avenger_wall"]					= loadFX("explosions/fx_exp_la_drone_avenger_wall");	//10365
		// fires from Cougar hit by semi: 320
		// fires for Cougar in G20_fail: 330
	level._effect["fx_vexp_cougar_la_1_g20_fail"]					= loadFX("explosions/fx_vexp_cougar_la_1_g20_fail");	// 330
	level._effect["fx_la1_smk_cougar_g20_fail"]						= loadFX("smoke/fx_la1_smk_cougar_g20_fail");	// 330
	level._effect["fx_light_glow_highway_sign_led"]				= loadFX("light/fx_light_glow_highway_sign_led");	// 360, 361, 363
	level._effect["fx_light_glow_highway_sign_led_long"]	= loadFX("light/fx_light_glow_highway_sign_led_long");	// 362
	level._effect["fx_elec_led_sign_dest_sm"]							= loadFX("electrical/fx_elec_led_sign_dest_sm");	// 10363
	level._effect["fx_overpass_collapse_falling_debris"]	= loadFX("maps/la/fx_overpass_collapse_falling_debris");	// 10370
	level._effect["fx_freeway_chunks_impact_init"]				= loadFX("maps/la/fx_freeway_chunks_impact_init");	// 10371
		// car alarm lights: 399
	// Event 4: Fast Lane (Gump 1c)
	level._effect["fx_la_exp_overpass_lower_lg"]					= LoadFX("maps/la/fx_la_exp_overpass_lower_lg");	// 10410
		// Debris impact: 10411
	level._effect["fx_dest_concrete_crack_dust_lg"]				= LoadFX("destructibles/fx_dest_concrete_crack_dust_lg");	// 10421-10430
	level._effect["fx_overpass_collapse_ground_impact"]		= LoadFX("maps/la/fx_overpass_collapse_ground_impact");	// 10431-10439
	level._effect["fx_overpass_collapse_dust_large"]			= loadFX("maps/la/fx_overpass_collapse_dust_large");	// 10431, 10435
	level._effect["fx_exp_la_drone_avenger_ground"]				= loadFX("explosions/fx_exp_la_drone_avenger_ground");	// 520?
	level._effect["fx_exp_la_drone_hit_by_missile_overpass"] = loadFX("explosions/fx_exp_la_drone_hit_by_missile_overpass");	// 442
	//Falling Car
	level._effect["fx_la_car_falling_dust_sparks"]				= LoadFX("maps/la/fx_la_car_falling_dust_sparks");	// 500
	level._effect["fx_la_car_falling_impact"]				      = LoadFX("maps/la/fx_la_car_falling_impact");       // 510
		
	// Ambient
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
	level._effect["fx_fire_fuel_xsm"]											= loadFX("fire/fx_fire_fuel_xsm");
	level._effect["fx_fire_fuel_sm"]											= LoadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_fire_fuel_sm_smolder"]							= loadFX("fire/fx_fire_fuel_sm_smolder");
	//level._effect["fx_fire_fuel_sm_tall"]									= loadFX("fire/fx_fire_fuel_sm_tall");
	level._effect["fx_fire_line_sm"]											= LoadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_fuel_sm_line"]									= LoadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm_ground"]								= LoadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_line_md"]											= LoadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]										= LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]										= LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_embers_falling_md"]									= LoadFX("env/fire/fx_embers_falling_md");
	//level._effect["fx_fire_window_xlg"]										= LoadFX("fire/fx_fire_window_xlg");
	level._effect["fx_la2_fire_line_xlg"]									= LoadFX("env/fire/fx_la2_fire_line_xlg");
	level._effect["fx_debris_papers_fall_burning_xlg"]		= LoadFX("debris/fx_paper_burning_ash_falling_xlg");
	level._effect["fx_ash_falling_xlg"]										= LoadFX("debris/fx_ash_falling_xlg");
	level._effect["fx_ash_embers_falling_detail_long"]		= loadFX("debris/fx_ash_embers_falling_detail_long");
	//level._effect["fx_embers_up_dist"]										= loadFX("env/fire/fx_embers_up_dist");
	
	// Smoke
	//level._effect["fx_smoke_building_xlg"]								= LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");
	level._effect["fx_smk_fire_xlg_black_dist"]						= LoadFX("smoke/fx_smk_fire_xlg_black_dist");
	level._effect["fx_smk_plume_md_blk_wispy_dist"]				= LoadFX("smoke/fx_smk_plume_md_blk_wispy_dist");
	//level._effect["fx_smk_plume_md_blk_wispy_dist_slow"]	= loadFX("smoke/fx_smk_plume_md_blk_wispy_dist_slow");
	level._effect["fx_smk_plume_lg_blk_wispy_dist"]				= LoadFX("smoke/fx_smk_plume_lg_blk_wispy_dist");
	level._effect["fx_smk_plume_md_gray_wispy_dist"]			= LoadFX("smoke/fx_smk_plume_md_gray_wispy_dist");
	level._effect["fx_smk_plume_md_gray_wispy_dist_slow"]	= loadFX("smoke/fx_smk_plume_md_gray_wispy_dist_slow");
	level._effect["fx_smk_battle_lg_gray_slow"]						= LoadFX("smoke/fx_smk_battle_lg_gray_slow");
	level._effect["fx_smk_smolder_gray_fast"]							= LoadFX("smoke/fx_smk_smolder_gray_fast");
	level._effect["fx_smk_smolder_gray_slow"]							= LoadFX("smoke/fx_smk_smolder_gray_slow");
	level._effect["fx_smk_fire_md_black"]									= LoadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]									= LoadFX("smoke/fx_smk_fire_lg_black");
	//level._effect["fx_smk_fire_lg_white"]									= LoadFX("smoke/fx_smk_fire_lg_white");
	//level._effect["fx_la_smk_cloud_xlg"]									= LoadFX("smoke/fx_la1_smk_cloud_xlg_dist");
	level._effect["fx_la1_smk_battle_freeway"]						= LoadFX("smoke/fx_la1_smk_battle_freeway");
	//level._effect["fx_la_smk_plume_buidling_thin"]				= LoadFX("env/smoke/fx_la_smk_plume_buidling_thin");
	level._effect["fx_la_smk_plume_buidling_med"]					= LoadFX("smoke/fx_smk_plume_building_md_slow");
	//level._effect["fx_la_smk_plume_distant_med"]					= LoadFX("env/smoke/fx_la_smk_plume_distant_med");
	//level._effect["fx_la_smk_plume_distant_lg"]						= LoadFX("env/smoke/fx_la_smk_plume_distant_lg");
	//level._effect["fx_la2_smk_bld_wall_right_xlg"]				= LoadFX("smoke/fx_la2_smk_bld_wall_right_xlg");
	level._effect["fx_la_smk_plume_distant_xxlg_white"]		= loadFX("smoke/fx_la_smk_plume_distant_xxlg_white");
	
	// Building Destruction
	level._effect["fx_smk_bldg_lg"]											= loadFX("smoke/fx_smk_bldg_lg");
	level._effect["fx_fire_bldg_lg_dist"]								= loadFX("fire/fx_fire_bldg_lg_dist");
	level._effect["fx_smk_bldg_lg_dist_dark"]						= loadFX("smoke/fx_smk_bldg_lg_dist_dark");
	level._effect["fx_fire_bldg_xlg_dist"]							= loadFX("fire/fx_fire_bldg_xlg_dist");
	level._effect["fx_smk_bldg_xlg_dist"]								= loadFX("smoke/fx_smk_bldg_xlg_dist");
	level._effect["fx_fire_bldg_xxlg_dist"]							= loadFX("fire/fx_fire_bldg_xxlg_dist");
	level._effect["fx_smk_bldg_xxlg_dist"]							= loadFX("smoke/fx_smk_bldg_xxlg_dist");
	level._effect["fx_fire_bldg_xxlg_dist_tall"]				= loadFX("fire/fx_fire_bldg_xxlg_dist_tall");
	level._effect["fx_smk_bldg_xxlg_dist_tall"]					= loadFX("smoke/fx_smk_bldg_xxlg_dist_tall");
	
	// Other
	level._effect["fx_elec_transformer_sparks_runner"]	= loadFX("electrical/fx_elec_transformer_sparks_runner");
	level._effect["fx_la_drones_above_city"]							= loadFX("maps/la/fx_la_drones_above_city");
	level._effect["fx_elec_burst_shower_sm_runner"]				= LoadFX("env/electrical/fx_elec_burst_shower_sm_runner");
	level._effect["fx_elec_burst_shower_lg_runner"]				= LoadFX("env/electrical/fx_elec_burst_shower_lg_runner");
	level._effect["fx_la_road_flare"]											= LoadFX("light/fx_la_road_flare");
	level._effect["fx_la_road_flare_blue"]								= loadFX("light/fx_la_road_flare_blue");	// Event 3
	level._effect["fx_vlight_car_alarm_headlight_os"]			= LoadFX("light/fx_vlight_car_alarm_headlight_os");
	level._effect["fx_vlight_car_alarm_taillight_os"]			= LoadFX("light/fx_vlight_car_alarm_taillight_os");
	level._effect["fx_paper_windy_slow"]									= loadFX("debris/fx_paper_windy_slow");
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "155 -84 0" );		// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);			// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 16000);			// change 10000 to your wind's upper bound
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
	exploder( EXPLODER_FREEWAY_DESTRUCTION );
	
	// Since we're not doing the full init, just set the skipto name
	level.skipto_point = ToLower( GetDvar( "skipto" ) );
	if ( level.skipto_point == "" )
	{
		level.skipto_point = "intro";
	}
	
	maps\la_utility::load_gumps();	
}

createfx_setup_gump1a()
{
}

createfx_setup_gump1b()
{
	run_scene_first_frame( "cougar_crawl" );
	run_scene_first_frame( "cougar_crawl_harper" );
	
	level waittill( "gump_flushed" );
	
	delete_scene_all( "cougar_crawl" );
	delete_scene_all( "cougar_crawl_harper" );
}

createfx_setup_gump1c()
{
	level thread run_scene( "freeway_bigrig_entry" );
	
	run_scene( "low_road_intro" );
	run_scene( "grouprappel_tbone" );
	
	level waittill( "gump_flushed" );
	
	delete_scene_all( "low_road_intro" );
	delete_scene_all( "grouprappel_tbone" );
	delete_scene_all( "freeway_bigrig_entry" );
}

createfx_setup_gump1d()
{
}

footsteps()
{
	LoadFX( "bio/player/fx_footstep_dust" );
	LoadFX( "bio/player/fx_footstep_dust" );
}
