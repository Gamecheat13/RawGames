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

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}


main()
{
	clientscripts\createfx\la_1b_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	footsteps();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

