//
// file: la_1_fx.gsc
// description: clientside fx script for la_1: setup, special fx functions, etc.
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


// Ambient Effects
precache_createfx_fx()
{
	level._effect["fx_lf_la_1_sun"] 											= loadFX("lens_flares/fx_lf_la_sun2_flight");
	
	// Exploders
	// Event 1: 110 (Gump 1a)
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
	//level._effect["fx_la_platform_collapse_rpg"]					= loadFX("maps/la/fx_la_platform_collapse_rpg_trai");	// 301, 303
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

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}*/


main()
{
	clientscripts\createfx\la_1_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
//	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

