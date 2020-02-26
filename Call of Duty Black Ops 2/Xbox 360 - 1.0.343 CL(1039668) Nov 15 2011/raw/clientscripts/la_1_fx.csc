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

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}


main()
{
	clientscripts\createfx\la_1_fx::main();
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

