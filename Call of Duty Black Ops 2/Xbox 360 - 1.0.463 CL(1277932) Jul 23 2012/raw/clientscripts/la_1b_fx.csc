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
	level._effect["fx_lf_la_sun1"] 											= loadFX("lens_flares/fx_lf_la_sun2_flight");
	level._effect[ "fx_sniper_glint" ]				= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	// Exploders
	// Event 5: No Way Out (Gump 1?)
	level._effect["fx_ce_bdog_grenade_exp"]							= loadFX("explosions/fx_grenadeexp_blacktop");	// 505, 506
	level._effect["fx_elec_transformer_exp_lg_os"]			= loadFX("electrical/fx_elec_transformer_exp_lg_os");	// 10521
	level._effect["fx_la_elec_live_wire_long"]					= loadFX("electrical/fx_la_elec_live_wire_long");	// 10521
	level._effect["fx_la_elec_live_wire_arc"]						= loadFX("electrical/fx_la_elec_live_wire_arc");	// 10521
	level._effect["fx_la_elec_live_wire_arc_angled"]		= loadFX("electrical/fx_la_elec_live_wire_arc_angled");	// 10521
	// Event 6: Through the Plaza to Staples Center (Gump 1?)
	level._effect["fx_fa38_bridge_crash"]								= loadFX("maps/la/fx_fa38_bridge_crash");	// 10630
	level._effect["fx_fa38_ground_impact"]							= loadFX("maps/la/fx_fa38_ground_impact");	// 10631
	level._effect["fx_fa38_plane_slide_stop_dust"]			= loadFX("maps/la/fx_fa38_plane_slide_stop_dust");	// 10631 + 1.8 seconds
	level._effect["fx_la1_f38_cockpit_fire"]						= loadFX("maps/la/fx_la1_f38_cockpit_fire");	// 10631
	// Event 7: Staples Center (Gump 1?)
	level._effect["fx_spire_collapse_base"]							= loadFX("maps/la/fx_spire_collapse_base");	// 10621
	//level._effect["fx_drone_wall_impact"]								= loadFX("impacts/fx_drone_wall_impact");	// 10700
	level._effect["fx_la_exp_drone_building_impact"]		= loadFX("explosions/fx_la_exp_drone_building_impact");	// 10780
	level._effect["fx_la_exp_drone_building_secondary"]		= loadFX("explosions/fx_la_exp_drone_building_secondary");	// 10780, offset
	level._effect["fx_la_exp_drone_building_exit"]		= loadFX("explosions/fx_la_exp_drone_building_exit");	// 10780, offset
	level._effect["fx_building_collapse_dust_unsettle"]	= loadFX("maps/la/fx_building_collapse_dust_unsettle");	// 10781
	level._effect["fx_building_collapse_dust_unsettle_detail"]	= loadFX("maps/la/fx_building_collapse_dust_unsettle_detail");	// 10781
	level._effect["fx_building_collapse_crunch_debris_sm"]	= loadFX("maps/la/fx_building_collapse_crunch_debris_sm");	// 10781
	level._effect["fx_building_collapse_crunch_debris_runner"]	= loadFX("maps/la/fx_building_collapse_crunch_debris_runner");	// 10782
	level._effect["fx_building_collapse_crunch_debris_runner_side"]	= loadFX("maps/la/fx_building_collapse_crunch_debris_runner_side");	//10782
	level._effect["fx_building_collapse_aftermath"]			= LoadFX("maps/la/fx_building_collapse_base_dust");	// 790 // 10788, 10788 +0.5 seconds
	level._effect["fx_building_collapse_rolling_dust"]	= loadFX("maps/la/fx_building_collapse_rolling_dust");	// 790 // 10788
	level._effect["fx_la_building_debris_dust_trail"]		= loadFX("dirt/fx_la_building_debris_dust_trail");	// attach to falling objects
	level._effect["fx_la1b_smk_signal"]		              = loadFX("smoke/fx_la1b_smk_signal");	
	
	
	// Ambient
	level._effect["fx_concrete_crumble_area_sm"]				= loadFX("dirt/fx_concrete_crumble_area_sm");
	level._effect["fx_la_overpass_debris_area_md_line"]	= loadFX("maps/la/fx_la_overpass_debris_area_md_line");
	level._effect["fx_la_overpass_debris_area_md_line_wide"]= loadFX("maps/la/fx_la_overpass_debris_area_md_line_wide");
	//level._effect["fx_ash_embers_falling_detail_long"]	= loadFX("debris/fx_ash_embers_falling_detail_long");
	level._effect["fx_dust_crumble_sm_runner"]					= loadFX("dirt/fx_dust_crumble_sm_runner");
	level._effect["fx_dust_crumble_md_runner"]					= loadFX("dirt/fx_dust_crumble_md_runner");
	level._effect["fx_embers_falling_sm"]								= loadFX("env/fire/fx_embers_falling_sm");
	level._effect["fx_embers_falling_md"]								= loadFX("env/fire/fx_embers_falling_md");
	level._effect["fx_paper_windy_slow"]								= loadFX("debris/fx_paper_windy_slow");
	
	// Fire
	//level._effect["fx_fire_line_xsm"]										= LoadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_fuel_xsm"]										= loadFX("fire/fx_fire_fuel_xsm");
	level._effect["fx_fire_fuel_sm"]										= loadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_fire_fuel_sm_smoke"]					  	= LoadFX("fire/fx_fire_fuel_sm_smoke");		
	level._effect["fx_fire_fuel_sm_smolder"]						= loadFX("fire/fx_fire_fuel_sm_smolder");
	//level._effect["fx_fire_fuel_sm_tall"]								= loadFX("fire/fx_fire_fuel_sm_tall");
	//level._effect["fx_fire_line_sm"]										= LoadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_fuel_sm_line"]								= loadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm_ground"]							= loadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_line_md"]										= LoadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]									= LoadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]									= LoadFX("env/fire/fx_fire_md_smolder");
	level._effect["fx_la2_fire_window_xlg"]							= LoadFX("env/fire/fx_la2_fire_window_xlg");
	//level._effect["fx_la2_fire_line_xlg"]								= LoadFX("env/fire/fx_la2_fire_line_xlg");
	level._effect["fx_debris_papers_fall_burning_xlg"]	= LoadFX("debris/fx_paper_burning_ash_falling_xlg");
	level._effect["fx_ash_falling_xlg"]									= loadFX("debris/fx_ash_falling_xlg");
	level._effect["fx_embers_column_md"]								= loadFX("env/fire/fx_embers_column_md");
	
	// Smoke
	level._effect["fx_smoke_building_xlg"]							= LoadFX("env/smoke/fx_la_smk_plume_buidling_xlg");
	level._effect["fx_smk_fire_xlg_black_dist"]					= loadFX("smoke/fx_smk_fire_xlg_black_dist");
	level._effect["fx_smk_plume_md_blk_wispy_dist"]			= loadFX("smoke/fx_smk_plume_md_blk_wispy_dist");
	//level._effect["fx_smk_plume_lg_blk_wispy_dist"]			= loadFX("smoke/fx_smk_plume_lg_blk_wispy_dist");
	//level._effect["fx_smk_plume_md_gray_wispy_dist"]		= loadFX("smoke/fx_smk_plume_md_gray_wispy_dist");
	level._effect["fx_smk_battle_lg_gray_slow"]					= loadFX("smoke/fx_smk_battle_lg_gray_slow");
	level._effect["fx_smk_smolder_gray_fast"]						= loadFX("smoke/fx_smk_smolder_gray_fast");
	level._effect["fx_smk_smolder_gray_slow"]						= loadFX("smoke/fx_smk_smolder_gray_slow");
	level._effect["fx_smk_smolder_rubble_lg"]						= loadFX("smoke/fx_smk_smolder_rubble_lg");
	level._effect["fx_smk_smolder_rubble_xlg"]					= loadFX("smoke/fx_smk_smolder_rubble_xlg");
	level._effect["fx_smk_fire_md_black"]								= LoadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]								= LoadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]								= LoadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_la_smk_cloud_xlg"]								= loadFX("smoke/fx_la1_smk_cloud_xlg_dist");
	level._effect["fx_la1b_smk_plume_buidling_thin"]		= loadFX("env/smoke/fx_la1b_smk_plume_buidling_thin");
	level._effect["fx_la1b_smk_bldg_med_near"]			= loadFX("smoke/fx_la1b_smk_bldg_med_near");
	level._effect["fx_la_smk_low_distant_med"]					= loadFX("env/smoke/fx_la_smk_low_distant_med");
	level._effect["fx_la_smk_plume_distant_med"]				= loadFX("env/smoke/fx_la_smk_plume_distant_med");
	//level._effect["fx_la_smk_plume_distant_lg"]					= loadFX("env/smoke/fx_la_smk_plume_distant_lg");
	level._effect["fx_smk_bldg_xlg_dist_dark"]					= loadFX("smoke/fx_smk_bldg_xlg_dist_dark");
	level._effect["fx_smk_field_room_md"]								= loadFX("smoke/fx_smk_field_room_md");
	level._effect["fx_smk_linger_lit"]									= loadFX("smoke/fx_smk_linger_lit");
	level._effect["fx_smk_linger_lit_z"]								= loadFX("smoke/fx_smk_linger_lit_z");
	
	// Building Destruction
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
	level._effect["fx_elec_burst_shower_sm_runner"]			= loadFX("env/electrical/fx_elec_burst_shower_sm_runner");
	level._effect["fx_elec_burst_shower_lg_runner"]			= loadFX("env/electrical/fx_elec_burst_shower_lg_runner");
	level._effect["fx_la2_elec_burst_xlg_runner"]				= LoadFX("env/electrical/fx_la2_elec_burst_xlg_runner");
	level._effect["fx_la2_debris_papers_fall_burning"]	= LoadFX("env/debris/fx_la2_debris_papers_fall_burning");
	level._effect["fx_la_road_flare"]										= loadFX("light/fx_la_road_flare");
	level._effect["fx_la_building_rocket_hit"]					= loadFX("maps/la/fx_la_building_rocket_hit");
	level._effect["fx_la_aerial_dog_fight_runner"]			= loadFX("maps/la/fx_la_aerial_dog_fight_runner");
	level._effect["fx_la_aerial_straight_runner"]				= loadFX("maps/la/fx_la_aerial_straight_runner");
	level._effect["fx_la1_f38_swarm"]										= loadFX("maps/la/fx_la1_f38_swarm");
	level._effect["fx_water_fire_sprinkler_dribble"]		= loadFX("water/fx_water_fire_sprinkler_dribble");
	level._effect["fx_water_fire_sprinkler_dribble_spatter"]	= loadFX("water/fx_water_fire_sprinkler_dribble_spatter");
	level._effect["fx_water_spill_sm_splash"]						= loadFX("water/fx_water_spill_sm_splash");
	level._effect["fx_light_recessed"]									= loadFX("light/fx_light_recessed");
	level._effect["fx_water_pipe_broken_gush"]					= loadFX("water/fx_water_pipe_broken_gush");
	level._effect["fx_dust_kickup_md_runner"]						= loadFX("dirt/fx_dust_kickup_md_runner");
	level._effect["fx_dust_kickup_sm_runner"]						= loadFX("dirt/fx_dust_kickup_sm_runner");
	level._effect["fx_water_splash_detail"]							= loadFX("water/fx_water_splash_detail_md");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ), "bigdog" );
}*/


main()
{
	clientscripts\createfx\la_1b_fx::main();
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

