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
	level._effect["data_glove_glow"]			= loadFX("light/fx_la_data_glove_glow");
	
	level._effect[ "flesh_hit" ]				= LoadFX("impacts/fx_flesh_hit");
	
	level._effect[ "sniper_glint" ]				= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	level._effect[ "cougar_monitor" ]			= LoadFX( "light/fx_la_cougar_monitor_glow" );
	level._effect[ "ce_f35_fx" ]				= LoadFX( "fire/fx_vfire_fa38_body" );
	level._effect[ "ce_dest_cop_motorcycle" ] = loadFX("maps/la/fx_la_bullet_impact_motorcycle");
	level._effect[ "ce_dest_cop_car_fx" ]		= LoadFX( "maps/la/fx_la_dest_squadcar_intro" );
	level._effect[ "ce_cop_car_marks_left" ]	= LoadFX( "vehicle/treadfx/fx_treadfx_skid_stop_left_runner" );
	level._effect[ "ce_cop_car_marks_right" ]	= LoadFX( "vehicle/treadfx/fx_treadfx_skid_stop_right_runner" );
	level._effect[ "ce_melee_bdog_fx" ]			= LoadFX( "destructibles/fx_claw_melee_back" );
	level._effect[ "ce_bdog_tracer" ]			= LoadFX( "maps/la/fx_la_claw_muzzleflash_intro" );
	level._effect[ "ce_cop_blood_fx_single" ]	= LoadFX( "maps/la/fx_la_policeman_death_intro" );
	level._effect[ "ce_motocop_blood_fx_single" ]	= LoadFX( "maps/la/fx_la_motocop_death_intro" );
	//level._effect[ "ce_bdog_muzzle_flash" ] 	= LoadFx( "weapon/muzzleflashes/fx_heavy_flash_base" );
	level._effect[ "ce_bdog_stun" ] = loadFX("maps/la/fx_claw_stun_electric_intro");
	level._effect[ "ce_bdog_killshot" ]	= loadFX("impacts/fx_la_metalhit_claw_killshot");
	level._effect[ "ce_bdog_death" ] 			= LoadFx( "destructibles/fx_claw_exp_death" );
	level._effect[ "ce_harper_muzflash" ] = loadFX("weapon/muzzleflashes/fx_muz_mstorm_flash_3p_lg_sp");
	level._effect[ "f35_exhaust_fly" ]			= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f38_afterburner" );
	level._effect[ "f35_exhaust_hover_front" ]	= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_front" );
	level._effect[ "f35_exhaust_hover_rear" ]	= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_rear" );
	//level._effect[ "elec_spark" ]				= LoadFX( "env/electrical/fx_elec_burst_shower_lg_runner" );
	level._effect["elec_transformer01_exp"] = loadFX("electrical/fx_elec_transformer_exp_lg_os");
	level._effect["elec_transformer02_exp"] = loadFX("electrical/fx_elec_transformer_exp_md_os");
	level._effect[ "brute_force_explosion" ]	= LoadFX( "explosions/fx_exp_la_vehicle_generic" );
	
	level._effect[ "vehicle_launch_trail" ]		= LoadFX( "trail/fx_trail_vehicle_push_generic" );
	
	level._effect[ "car_explosion" ]			= LoadFX( "vehicle/vexplosion/fx_vexp_apc_m113" );
	level._effect[ "siren_light_bike" ]			= LoadFX( "light/fx_vlight_police_cycle_flashing" );
	level._effect[ "siren_light" ]				= LoadFX( "light/fx_vlight_police_car_flashing" );
	
	level._effect[ "f38crash_slide" ]			= LoadFX( "maps/la/fx_fa38_ground_impact_slide" );
	
	level._effect[ "spire_collapse" ]			= LoadFX( "maps/la/fx_spire_collapse_center_dust" );
	
	level._effect[ "laser_cutter_on" ]			= LoadFX( "props/fx_laser_cutter_on" );
	level._effect[ "laser_cutter_sparking" ]	= LoadFX( "props/fx_laser_cutter_sparking" );
	
	level._effect["la_building_debris_dust_trail"]		= loadFX("dirt/fx_la_building_debris_dust_trail");	// attached to falling chunks from skyscraper02
	level._effect["building_collapse_chunk_debris"]		= loadFX("maps/la/fx_building_collapse_crunch_debris_sm");	// attached to tag_chunks from skyscraper02
	level._effect[ "sam_drone_explode" ] 				= LoadFX( "explosions/fx_la_exp_drone_lg" );	
}

// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["apartment"] = %fxanim_la_apartment_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_01"] = %fxanim_la_debris_fall_lrg_01_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_02"] = %fxanim_la_debris_fall_lrg_02_anim;
	level.scr_anim["fxanim_props"]["debris_lrg_03"] = %fxanim_la_debris_fall_lrg_03_anim;
	level.scr_anim["fxanim_props"]["debris_sm_01"] = %fxanim_la_debris_fall_sm_01_anim;
	level.scr_anim["fxanim_props"]["debris_sm_02"] = %fxanim_la_debris_fall_sm_02_anim;
	level.scr_anim["fxanim_props"]["debris_sm_03"] = %fxanim_la_debris_fall_sm_03_anim;
	level.scr_anim["fxanim_props"]["drone_chunks"] = %fxanim_la_drone_chunks_anim;
	level.scr_anim["fxanim_props"]["f35_env_stay"] = %fxanim_la_f35_env_stay_anim;
	level.scr_anim["fxanim_props"]["f35_env_delete"] = %fxanim_la_f35_env_delete_anim;
	level.scr_anim["fxanim_props"]["f35_walkway"] = %fxanim_la_f35_walkway_anim;
	level.scr_anim["fxanim_props"]["f35_tower_01"] = %fxanim_la_f35_tower_01_anim;
	level.scr_anim["fxanim_props"]["f35_tower_02"] = %fxanim_la_f35_tower_02_anim;
	level.scr_anim["fxanim_props"]["f35_column"] = %fxanim_la_f35_column_anim;
	level.scr_anim["fxanim_props"]["bldg_convoy_block"] = %fxanim_la_bldg_convoy_block_anim;
	level.scr_anim["fxanim_props"]["spire_collapse"] = %fxanim_la_spire_collapse_anim;
	level.scr_anim["fxanim_props"]["f35_la_plaza_crash"] = %fxanim_la_f35_dead_anim;
	level.scr_anim["fxanim_props"]["bldg_collapse_01"] = %fxanim_la_bldg_collapse_01_anim;
	level.scr_anim["fxanim_props"]["skyscraper02_impact"] = %fxanim_la_skyscraper02_impact_anim;
	level.scr_anim["fxanim_props"]["skyscraper02"] = %fxanim_la_skyscraper02_anim;
	level.scr_anim["fxanim_props"]["drone_skyscraper_crash"] = %fxanim_la_drone_skyscraper_crash_anim;
	level.scr_anim["fxanim_props"]["f35_skyscraper_chase"] = %fxanim_la_f35_skyscraper_chase_anim;
	level.scr_anim["fxanim_props"]["alley_power_pole"] = %fxanim_la_alley_power_pole_anim;

	addnotetrack_fxontag( "fxanim_props", "spire_collapse", "spire_glass_break", "spire_collapse", "bend_jnt" );
	
	addnotetrack_level_notify( "fxanim_props", "exploder 10630 #f35_hits_walkway", "f35_walkway_start", "f35_la_plaza_crash" );
	addnotetrack_level_notify( "fxanim_props", "exploder 10631 #f35_hits_ground", "f35_env_start", "f35_la_plaza_crash" );
	addnotetrack_level_notify( "fxanim_props", "exploder 10632 #f35_hits_tower_01", "f35_tower_01_start", "f35_la_plaza_crash" );
	addnotetrack_level_notify( "fxanim_props", "exploder 10633 #f35_hits_tower_02", "f35_tower_02_start", "f35_la_plaza_crash" );
	addnotetrack_level_notify( "fxanim_props", "exploder 10634 #f35_hits_column", "f35_column_start", "f35_la_plaza_crash" );
	
	addnotetrack_fxontag( "fxanim_props", "f35_la_plaza_crash", "exploder 10631 #f35_hits_ground", "f38crash_slide", "tag_gear" );	
	
	addNotetrack_customFunction( "fxanim_props", undefined, maps\la_plaza::f35_crash_fx, "f35_la_plaza_crash" );
	addnotetrack_fxontag( "fxanim_props", "alley_power_pole", "exploder 10522 #transformer01_breaks_off", "elec_transformer01_exp", "tag_transformer01_jnt" );
	addnotetrack_fxontag( "fxanim_props", "alley_power_pole", "exploder 10523 #transformer02_sparks", "elec_transformer02_exp", "tag_transformer02_jnt" );
	
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10782 #bottom_chunks_break", "building_collapse_chunk_debris", "tag_chunk01_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10782 #bottom_chunks_break", "la_building_debris_dust_trail", "chunk04_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10783 #back_chunks_break", "building_collapse_chunk_debris", "tag_chunk02_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10783 #back_chunks_break", "la_building_debris_dust_trail", "chunk06_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10783 #back_chunks_break", "la_building_debris_dust_trail", "chunk07_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10783 #back_chunks_break", "la_building_debris_dust_trail", "chunk08_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10784 #front_chunks_break", "building_collapse_chunk_debris", "tag_chunk03_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10785 #front_top_chunk_break", "building_collapse_chunk_debris", "tag_chunk04_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10785 #front_top_chunk_break", "la_building_debris_dust_trail", "chunk18_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10786 #top_chunk_break", "building_collapse_chunk_debris", "tag_chunk05_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10786 #top_chunk_break", "building_collapse_chunk_debris", "tag_chunk06_jnt" );
	addnotetrack_fxontag( "fxanim_props", "skyscraper02", "exploder 10786 #top_chunk_break", "la_building_debris_dust_trail", "chunk09_jnt" );
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
	level._effect["fx_la_exp_drone_building_secondary"]	= loadFX("explosions/fx_la_exp_drone_building_secondary");	// 10780, offset
	level._effect["fx_la_exp_drone_building_exit"]		= loadFX("explosions/fx_la_exp_drone_building_exit");	// 10780, offset
	level._effect["fx_building_collapse_dust_unsettle"]	= loadFX("maps/la/fx_building_collapse_dust_unsettle");	// 10781
	level._effect["fx_building_collapse_dust_unsettle_detail"]	= loadFX("maps/la/fx_building_collapse_dust_unsettle_detail");	// 10781
	level._effect["fx_building_collapse_crunch_debris_runner"]	= loadFX("maps/la/fx_building_collapse_crunch_debris_runner");	// 10782
	level._effect["fx_building_collapse_crunch_debris_runner_side"]	= loadFX("maps/la/fx_building_collapse_crunch_debris_runner_side");	//10782
	level._effect["fx_building_collapse_aftermath"]			= LoadFX("maps/la/fx_building_collapse_base_dust");	// 790 // 10788, 10788 +0.5 seconds
	level._effect["fx_building_collapse_rolling_dust"]	= loadFX("maps/la/fx_building_collapse_rolling_dust");	// 790 // 10788
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
	level._effect["fx_fire_fuel_sm_smolder"]						= loadFX("fire/fx_fire_fuel_sm_smolder");
	level._effect["fx_fire_fuel_sm_smoke"]					  	= LoadFX("fire/fx_fire_fuel_sm_smoke");	
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
