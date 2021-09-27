#include maps\_hud_util;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_anim;
#include maps\_utility_chetan;

// *************************************
// GLOBALS
// *************************************

// *************************************
// LEVEL INITIALIZATION
// *************************************

level_precache()
{
	//e3 logo TODO DELETE AFTER e3
	//PrecacheShader( "mw3_full_logo_alpha" );
	
	// Shell Shock
	
	PreCacheShellShock( "default" );
	PreCacheShellShock( "paris_ac130_thermal" );
	PreCacheShellShock( "paris_ac130_enhanced" );
	
	// Shaders
    
    // **TODO -- need to make distinct for AC 130
	
	PreCacheShader( "remotemissile_infantry_target" );
	PreCacheShader( "ac130_hud_diamond" );
	PreCacheShader( "ac130_hud_tag" );
	PreCacheShader( "hud_fofbox_self_sp" );
	PreCacheShader( "uav_vehicle_target" );
	PreCacheShader( "veh_hud_target" );
	PreCacheShader( "overlay_static" );
	PreCacheShader( "ac130_overlay_pip_vignette" );
	PreCacheShader( "ac130_overlay_pip_static_a" );
	PreCacheShader( "ac130_overlay_pip_static_b" );
	PreCacheShader( "ac130_overlay_pip_static_c" );
	PreCacheShader( "compass_map_paris_ac130" );
	PreCacheShader( "compass_map_paris_ac130_intro" );
	PreCacheShader( "compass_map_paris_ac130_courtyard" );
	PreCacheShader( "compass_map_paris_ac130_bridge" );
	
    // Strings
	
	// Mission Fail Messages
	
	PreCacheString( &"PARIS_AC130_PRESS_TO_DROP");
	
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_DELTA_KILLED" );
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_HVI_KILLED" );
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_FRIENDLY_KILLED" );
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_FRIENDLY_SUPPORT" );
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_BUILDING" );
	PreCacheString( &"PARIS_AC130_MISSION_FAIL_HUMVEE_SUPPORT" );
	
	// Mission Objectives
	
	PreCacheString( &"PARIS_AC130_OBJ_INTRO_GET_TO_OSPREY" );
	PreCacheString( &"PARIS_AC130_OBJ_FDR_CLEAR_AREA_FOR_KILO_1_1" );
	PreCacheString( &"PARIS_AC130_OBJ_STREET_CLEAR_STREET_FOR_KILO_1_1" );
	PreCacheString( &"PARIS_AC130_OBJ_RPG_DESTROY_RPG_BUILDING" );
	PreCacheString( &"PARIS_AC130_OBJ_CHASE_ESCORT_KILO_1_1" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK" );
	
	// -- Open Area
	PreCacheString( &"PARIS_AC130_OBJ_FLANK_MG_NEST");
	PreCacheString( &"PARIS_AC130_OBJ_SHOOT_COURTYARD_BUILDING");
	PreCacheString( &"PARIS_AC130_OBJ_FIGHT_THROUGH_COURTYARD");
	PreCacheString( &"PARIS_AC130_DESTROY_ENEMY_TANKS" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_2" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_1" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_DESTROY_TANK_JAV_COMPLETED" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_GET_JAVELIN" );
	PreCacheString( &"PARIS_AC130_OBJ_BRIDGE_PUSH_LZ");
	PreCacheString( &"PARIS_AC130_OBJ_BOARD_THE_LITTLEBIRD");
	PreCacheString( &"PARIS_AC130_OBIT_CUSTOM_TANK_DEATH");
	PreCacheString( &"PARIS_AC130_OBJ_DEFEND_LZ");
	PreCacheString( &"PARIS_AC130_DEATHQUOTE_CHASE_1" );
	PreCacheString( &"PARIS_AC130_DEATHQUOTE_CHASE_2" );
	
	// -- City Area
	
	// **TEMP dialogue
	
	// -- Intro Area

	// -- Open Area
	
	// -- City Area
	
	// Hints
	
	//"Press ^3[{+activate}]^7 to Tackle."
	PreCacheString( &"PARIS_AC130_HINT_INTERACT" );
	
	// Level Intro
	
	//Paris Under Seige
	PreCacheString( &"PARIS_AC130_INTROSCREEN_LINE_1" );
	//Day 5 - 07:42:[{FAKE_INTRO_SECONDS:17}]
	PreCacheString( &"PARIS_AC130_INTROSCREEN_LINE_2" );
	//Sgt. Gary 'Roach' Sanderson
	PreCacheString( &"PARIS_AC130_INTROSCREEN_LINE_3" );
	//AC130 - Warhammer
	PreCacheString( &"PARIS_AC130_INTROSCREEN_LINE_4" );
	
	PreCacheString( &"PARIS_AC130_AIR_SUPPORT_HINT" );
	
	PreCacheString( &"PARIS_AC130_OBJ_THROW_STROBE" );
	//Protect
	PreCacheString( &"PARIS_AC130_OBJ_PROTECT" );
	
	//c130 air strobe pilot VO
	//PreCacheString( &"PARIS_AC130_PLT_READYFORMARK" );
	//PreCacheString( &"PARIS_AC130_PLT_READYFORTARGETS" );
	//PreCacheString( &"PARIS_AC130_PLT_TARGETCONFIRMED" );
	
	// DEV

    // "END PARIS AC-130 SCRIPT"
	PreCacheString( &"PARIS_AC130_END_SCRIPT" );
	
	// Models
	PreCacheModel( "vehicle_mig29_low" );
	PreCacheModel( "vehicle_cobra_helicopter_d" );
	PreCacheModel( "vehicle_blackhawk_crash" );
	PreCacheModel( "vehicle_v22_osprey" );
	PreCacheModel( "test_box" );
	PreCacheModel( "tag_laser" );
	PreCacheModel( "weapon_rpg7" );
	PreCacheModel( "weapon_ak47" );
	PreCacheModel( "weapon_m16" );
	PreCacheModel( "weapon_javelin_obj" );
	PreCacheModel( "angel_flare_rig" );
	PreCacheModel( "ss_n_12_missile" );
	PreCacheModel( "weapon_minigun" ); // **TODO: Temp ... Remove
	PreCacheModel( "viewlegs_generic" );
	PreCacheModel( "viewhands_player_delta" );
	PreCacheModel( "viewhands_delta");
	PreCacheModel( "vehicle_f15_missile" );
	PreCacheModel( "projectile_us_smoke_grenade" );
	PreCacheModel( "vehicle_hummer" );
	PreCacheModel( "vehicle_mi17_woodland_fly_cheap" );
	
	// --- Pristine
	
	PreCacheModel( "ac_prs_enm_barge_a_1" );
	PreCacheModel( "ac_prs_enm_barge_a_2" );
	PreCacheModel( "ac_prs_enm_barge_a_1_dam_animated" );
	PreCacheModel( "ac_prs_enm_barge_a_2_dam_animated" );
	PreCacheModel( "ac_prs_enm_barrels_a_1" );
	PreCacheModel( "ac_prs_enm_barrels_a_2" );
	PreCacheModel( "ac_prs_enm_cargo_crate_a_1" );
	PreCacheModel( "ac_prs_enm_con_digger_a" );
	PreCacheModel( "ac_prs_enm_con_dump_truck_a" );
	PreCacheModel( "ac_prs_enm_crates_a_1" );
	PreCacheModel( "ac_prs_enm_crates_a_2" );
	PreCacheModel( "ac_prs_enm_crates_b_1" );
	PreCacheModel( "ac_prs_enm_crates_b_2" );
	PreCacheModel( "ac_prs_enm_fuel_tank_a" );
	PreCacheModel( "ac_prs_enm_maz_a" );
	PreCacheModel( "ac_prs_enm_mi26_halo_a" );
	PreCacheModel( "ac_prs_enm_missile_boat_a" );
	PreCacheModel( "ac_prs_enm_mobile_crane_a" );
	PreCacheModel( "ac_prs_enm_mstas_a" );
	PreCacheModel( "ac_prs_enm_radar_maz_a" );
	PreCacheModel( "ac_prs_enm_s300v_a" );
	PreCacheModel( "ac_prs_enm_speed_boat_a" );
	PreCacheModel( "ac_prs_enm_storage_bld_a_1" );
	PreCacheModel( "ac_prs_enm_storage_bld_a_2" );
	PreCacheModel( "ac_prs_enm_storage_bld_b" );
	PreCacheModel( "ac_prs_enm_tent_a" );
	PreCacheModel( "ac_prs_enm_tent_b" );
	PreCacheModel( "ac_prs_enm_tent_c" );
	PreCacheModel( "ac_prs_enm_truck_a" );
	PreCacheModel( "ac_prs_enm_watch_tower_a" );
	PreCacheModel( "weapon_m16" );
	PreCacheModel( "vehicle_gaz_tigr_harbor_destroyed" );
	
	// --- Damaged
	
	PreCacheModel( "ac_prs_enm_fuel_tank_a_dam" );
	PreCacheModel( "ac_prs_enm_mi26_halo_a_dam" );
	PreCacheModel( "ac_prs_enm_storage_bld_a_1_dam" );
	PreCacheModel( "ac_prs_enm_storage_bld_a_2_dam" );
	PreCacheModel( "ac_prs_enm_storage_bld_b_dam" );
	PreCacheModel( "ac_prs_enm_tent_a_dam1" );
	PreCacheModel( "ac_prs_enm_tent_b_dam1" );
	PreCacheModel( "ac_prs_enm_tent_c_dam1" );
	PreCacheModel( "ac_prs_enm_truck_a_dam" );
	PreCacheModel( "ac_prs_enm_s300v_dam" );
	
	// Items
	
	PreCacheItem( "m16_ac130_basic" );
	PreCacheItem( "ak47_ac130" );
	PreCacheItem( "ac130_sam" );
	PreCacheItem( "ac130_sam_fast" );
	PreCacheItem( "apache_ac130_turret" );
	PreCacheItem( "hydra_ac130_rocket" );
	PreCacheItem( "rpg" );
	PreCacheItem( "rpg_player" );
	PreCacheItem( "rpg_straight" );
	PreCacheItem( "rpg_straight_ac130" );
	PreCacheItem( "t72_turret" );
	PreCacheItem( "btr80_ac130_turret" );
	PreCacheItem( "f15_20mm" );
	PreCacheItem( "f15_missile" );
	PreCacheItem( "t72_125mm" );
	
	// Slaamzoom FP Assets
	
	PreCacheItem( "usp" );
	PreCacheItem( "usp_no_knife" );
	PreCacheItem( "fraggrenade" );
	PreCacheItem( "flash_grenade" );
	PreCacheItem( "javelin" );
	PreCacheItem( "msr" );
	PreCacheItem( "ac130_40mm_air_support_strobe" );
	PreCacheItem( "ac130_40mm_air_support_strobe_iw" );
	
	//for c130 flying over bridge while player is on ground:
	PreCacheItem( "ac130_40mm" );
	PreCacheItem( "ac130_25mm" );
	PreCacheItem( "ac130_105mm" );

	//PreCacheModel( "viewmodel_base_viewhands" );
	PreCacheModel( "weapon_javelin" );
	
	//bridge crashed jet 
	Precachemodel("vehicle_mig29_destroyed_back_version2");
	Precachemodel("vehicle_mig29_destroyed_front");
	
	//stealth bomber bombs eiffel tower
	PreCacheModel( "vehicle_a10_warthog" );
		
	// Hints	
	add_hint_string( "HINT_interact_button_pressed", &"PARIS_AC130_HINT_INTERACT", ::hint_interact_button );
	
	// Press ^3 [{+actionslot 4}] ^7 to use an air support marker.
	add_hint_string("air_support_hint", &"PARIS_AC130_AIR_SUPPORT_HINT", Maps\paris_ac130_slamzoom::using_strobe);
}

init_listen_player()
{
}

init_listen_global()
{
}

init_globals()
{
	// Globals
	
	level.open_area_drones = [];
	level.open_area_objects = [];
	level.city_area_objects = [];
	level.war_objects = [];
	level.delta = [];
	level.uniform_64 = [];
	level.encounter_enemies = [];
	level.encounter_primary_enemies = [];
	level.encounter_special_enemies = [];
	level.objectives = [];
	
	level.hud_item = [];
	
	level.current_objective = 0;
	level.escort_objective = 0;
	level.encounter_enemies_count = 0;
	level.encounter_primary_enemies_count = 0;
	level.encounter_special_enemies_count = 0;
	level.mission_fail_points = 0;
	level.max_mission_fail_points = 1000;
	level.ambient_aa_fire_short_delay = 0.15;
	level.ambient_aa_fire_tracer_delay = 0.15;
	level.ambient_aa_fire_flash_delay = 0.2;
	
	level.sandman = undefined;
	level.frost = undefined;
    level.hitman = undefined;
    level.gator = undefined;
    level.bishop = undefined;
	level.makarov_number_2 = undefined;
	level.delta_car = undefined;
	level.black_overlay = undefined;
	level.ac130_vehicle = undefined;
	level.chase_main_vehicle = undefined;
	level.chase_second_vehicle = undefined;
	
	level.fdr_enemy_vehicles = [];
	
	level.sandman_fps_pip = undefined;
	level.sandman_shoulder_pip = undefined;
	level.frost_fps_pip = undefined;
	level.frost_shoulder_pip = undefined;
	level.hitman_fps_pip = undefined;
	level.hitman_shoulder_pip = undefined;
	level.gator_fps_pip = undefined;
	level.gator_shoulder_pip = undefined;
	level.bishop_fps_pip = undefined;
	level.bishop_shoulder_pip = undefined;
	
	level.ac130_current_spline = undefined;
	level.ac130_current_spline_section = undefined;
	
	level.enemy_ai_killed = false;
	level.enemy_vehicle_killed = false;
	level.enemy_btr_killed = false;
	level.enemy_hind_killed = false;
	level.enemy_mi17_killed = false;
	level.enemy_t72_killed = false;
	level.enemy_kill_dialogue_enabled = false;
	level.player_hit_building = false;
		
    level.city_area_current_street_slope = 0;
    level.city_area_current_battle_line = 0;
    
    level.city_area_battle_lines = [];
    level.city_area_battle_lines[ 0 ] = getstruct( "city_area_fdr_1_battle_line", "targetname" );
    level.city_area_battle_lines[ 1 ] = getstruct( "city_area_ma_1_battle_line", "targetname" );
    level.city_area_battle_lines[ 2 ] = getstruct( "city_area_ma_2_battle_line", "targetname" );
    level.city_area_battle_lines[ 3 ] = getstruct( "city_area_ma_3_battle_line", "targetname" );
    level.city_area_battle_lines[ 4 ] = getstruct( "city_area_rb_1_battle_line", "targetname" );

	level.city_area_street_slopes = [];

	points = get_ent_array_with_prefix( "city_area_fdr_street_line_", "targetname", 0 );
	level.city_area_street_slopes[ 0 ] = ( points[ 1 ].origin[ 1 ] - points[ 0 ].origin[ 1 ]  ) / ( points[ 1 ].origin[ 0 ] - points[ 0 ].origin[ 0 ] );
	points = get_ent_array_with_prefix( "city_area_ma_street_line_", "targetname", 0 );
	level.city_area_street_slopes[ 1 ] = ( points[ 1 ].origin[ 1 ] - points[ 0 ].origin[ 1 ]  ) / ( points[ 1 ].origin[ 0 ] - points[ 0 ].origin[ 0 ] );
	points = get_ent_array_with_prefix( "city_area_rb_street_line_", "targetname", 0 );
	level.city_area_street_slopes[ 2 ] = ( points[ 1 ].origin[ 1 ] - points[ 0 ].origin[ 1 ]  ) / ( points[ 1 ].origin[ 0 ] - points[ 0 ].origin[ 0 ] );
    
    maps\paris_ac130_pip::pip_init();
}

_init_dvars()
{
	SetDvarIfUninitialized( "mission_fail_enabled", 1 );
	SetDvarIfUninitialized( "pip_enabled", 1 );
}

_init_flags()
{
	// Add Starts
	
	flag_init( "FLAG_start_intro" );
	flag_init( "FLAG_start_ac130" );
	flag_init( "FLAG_start_fdr" );
	flag_init( "FLAG_start_e3" );
	flag_init( "FLAG_start_street" );
	flag_init( "FLAG_start_rpg" );
	flag_init( "FLAG_start_courtyard" );
	flag_init( "FLAG_start_chase" );
	flag_init( "FLAG_start_bridge" );
	flag_init( "FLAG_start_bridge_collapse" );
	
	// ** TEMP Flags for Mission Objectives
	
	// Level Flow
	
	flag_init( "FLAG_building_trigger_mission_failed_on" );
	
	// Ambient
	
	flag_init( "FLAG_ambient_ac130_effects" );
	flag_init( "FLAG_end_ambient_ac130_effects" );
	flag_init( "FLAG_ambient_ac130_close_jets" );
	flag_init( "FLAG_ambient_ac130_close_mi17s" );
	
	// Intro
	
	flag_init( "FLAG_intro_opening_jet_dog_fight_starting" );
	flag_init( "FLAG_intro_opening_jet_dog_fight_finished" );
	flag_init( "FLAG_intro_ambient_jet_dog_fights_active" );
	flag_init( "FLAG_intro_osprey_event" );
	flag_init( "FLAG_intro_osprey_1_crash_ready" );
	flag_init( "FLAG_intro_player_knockout_start" );
	flag_init( "FLAG_intro_player_knockout_started" );
	flag_init( "FLAG_intro_osprey_1_minigun_stop" );
	flag_init( "FLAG_intro_osprey_1_crash_start" );
	flag_init( "FLAG_intro_osprey_1_crash_finished" );
	flag_init( "FLAG_intro_slamout_start" );
	flag_init( "FLAG_intro_ambient_jet_dog_fights_end" );
	flag_init( "FLAG_intro_dialogue_finished" );
	
	// War
	
	flag_init( "FLAG_war_targeting_system" );
	flag_init( "FLAG_war_mark_enemy_targets" );
	flag_init( "FLAG_war_finished" );
	flag_init( "FLAG_war_clean_up" );
	flag_init( "FLAG_war_dialogue_finished" );
	
	// FDR
	
	flag_init( "FLAG_fdr_intro_dialogue_finished" );
	flag_init( "FLAG_fdr_mark_enemy_targets" );
	flag_init( "FLAG_fdr_mark_friendly_targets" );
	flag_init( "FLAG_fdr_ac130_circling_fdr" );
	flag_init( "FLAG_fdr_btrs_spawned" );
	flag_init( "FLAG_fdr_t72s_spawned" );
	flag_init( "FLAG_fdr_enemy_vehicles_killed" );

	flag_init( "FLAG_fdr_delta_ready_to_move_to_street" );
	flag_init( "FLAG_fdr_kill_all_enemies" );
	flag_init( "FLAG_fdr_carpet_bombing_timeout" );
	flag_init( "FLAG_fdr_carpet_bombing_start" );
	flag_init( "FLAG_fdr_carpet_bombing_finished" );
	flag_init( "FLAG_fdr_dialogue_finished" );
	
	// Street
	
	flag_init( "FLAG_street_ma_1_delta_reached" );
	flag_init( "FLAG_street_ma_1_encounter_start" );	
	flag_init( "FLAG_street_ma_1_encounter_complete" );
	flag_init( "FLAG_street_ma_2_delta_move_down" );
	flag_init( "FLAG_street_ma_2_delta_reached" );
	flag_init( "FLAG_street_ma_3_delta_move_down" );
	flag_init( "FLAG_street_ma_1_btr_reminder" );
	flag_init( "FLAG_street_ma_1_btr_reached_end_of_path" );
	flag_init( "FLAG_street_ma_1_btr_killed" );
	flag_init( "FLAG_street_ma_1_helicopter_killed" );
	flag_init( "FLAG_street_ma_1_helicopter_enemies_killed" );
	flag_init( "FLAG_street_ma_2_flank_spawned" );
	flag_init( "FLAG_street_ma_2_flank_killed" );
	flag_init( "FLAG_street_ma_2_encounter_complete" );
	flag_init( "FLAG_street_ma_3_helicopter_sighted" );
	flag_init( "FLAG_street_ma_3_helicopter_1_unloaded" );
	flag_init( "FLAG_street_ma_3_helicopter_1_killed" );
	flag_init( "FLAG_street_ma_3_helicopter_1_enemies_killed" );
	flag_init( "FLAG_street_ma_3_helicopter_2_unloaded" );
	flag_init( "FLAG_street_ma_3_helicopter_2_killed" );
	flag_init( "FLAG_street_ma_3_helicopter_2_enemies_killed" );
	flag_init( "FLAG_street_ma_3_delta_reached" );
	flag_init( "FLAG_street_ma_3_encounter_complete" );

	// Rpg

	flag_init( "FLAG_rpg_delta_move_down" );
	flag_init( "FLAG_rpg_delta_fallback" );
	flag_init( "FLAG_rpg_ac130_angel_flare_start" );
	flag_init( "FLAG_rpg_building_valid_target" );
	flag_init( "FLAG_rpg_building_marked" );
	flag_init( "FLAG_rpg_building_damaged" );
	flag_init( "FLAG_rpg_building_falling_down" );
	flag_init( "FLAG_rpg_building_destroyed" );
	flag_init( "FLAG_rpg_building_callout_dialgoue_finished" );
	flag_init( "FLAG_rpg_building_dialgoue_finished" );
	
	// Courtyard
	
	flag_init( "FLAG_courtyard_slamzoom_out_finished" );
	flag_init( "FLAG_hvt_escape_hvt_captured" );
	
    // Chase
    
    flag_init( "FLAG_chase_rb_delta_exiting_building" );
    flag_init( "FLAG_chase_delta_ready_to_enter_vehicles" );
    flag_init( "FLAG_chase_pfr_encounter_check" );
    flag_init( "FLAG_chase_pfr_encounter_complete" );
    
    flag_init( "FLAG_chase_delta_entered_chase_vehicles" );
    flag_init( "FLAG_chase_main_vehicle_arrived" );
    flag_init( "FLAG_chase_second_vehicle_arrived" );
    flag_init( "FLAG_chase_started" );
    flag_init( "FLAG_chase_encounter_1_complete" );
    flag_init( "FLAG_chase_hinds_finished_shooting_rockets" );
    flag_init( "FLAG_chase_hinds_killed" );
    flag_init( "FLAG_chase_encounter_2_check" );
    flag_init( "FLAG_chase_encounter_2_complete" );
    flag_init( "FLAG_chase_transition_to_slamzoom_in" );
    flag_init( "FLAG_chase_main_vehicle_start_end_chase" );
    flag_init( "FLAG_chase_second_vehicle_start_end_chase" );
    flag_init( "FLAG_chase_vehicles_1_2_killed" );
    flag_init( "FLAG_chase_vehicles_3_4_killed" );
    flag_init( "FLAG_chase_vehicles_5_6_killed" );
    flag_init( "FLAG_chase_vehicles_7_8_killed" );
    flag_init( "FLAG_chase_end_chase" );
    flag_init( "FLAG_chase_dialogue_finished" );
    
    // Delta
    
	flag_init( "FLAG_city_area_pfr_delta_move_down" );
	
	flag_init( "FLAG_delta_spawned" ); // DEBUG
	flag_init( "FLAG_delta_ac130_mission_fail" );
	
	// AC-130
	
	flag_init( "FLAG_ac130_flare_event_started" );
	flag_init( "FLAG_ac130_angel_flare_teleport" );
	flag_init( "FLAG_ac130_shoot_angel_flares_start" );
	flag_init( "FLAG_ac130_shoot_angel_flares_finished" );
	flag_init( "FLAG_ac130_flare_event_finished" );
	
	flag_init( "FLAG_ac130_intro" );
	flag_init( "FLAG_ac130_loop_0" );
	flag_init( "FLAG_ac130_loop_0_to_2" );
	flag_init( "FLAG_ac130_loop_2" );
	flag_init( "FLAG_ac130_loop_2_to_3" );
	flag_init( "FLAG_ac130_loop_3" );
	flag_init( "FLAG_ac130_loop_4" );
	
	flag_init( "FLAG_open_area_slamzoom_out_out" );
	flag_init( "FLAG_open_area_battle_1_end_transition_out" );
	flag_init( "FLAG_open_area_battle_2_end_transition_out" );
	
	// Enemy A.I.
	
	flag_init( "FLAG_monitor_encounter_enemy" );
	flag_init( "FLAG_monitor_encounter_primary_enemy" );
	flag_init( "FLAG_monitor_encounter_special_ai" );
	
	// Enemy Tanks
	
	// Enemy Hind
	
	// Enemy Turrets
	
	// Enemy Drones
	
	flag_init( "FLAG_open_area_drones_panic" ); 
	
	// Player Input
	
	flag_init( "FLAG_interact_button_pressed" );
	
	// Dialogue
	
	flag_init( "FLAG_street_ma_1_dialogue_finished" );
	flag_init( "FLAG_city_area_ma_2_dialogue_finished" );
	
	//steve
	flag_init("player_tackled_hvt");
}

// *************************************
// GENERIC FUNCTIONS - LEVEL SPECIFIC
// *************************************

start_timed_mission_failed( time )
{
	Assert( IsDefined( time ) );
	
	level notify( "LISTEN_timed_mission_failed_end" );
	level endon( "LISTEN_timed_mission_failed_end" );
	
	time = ter_op( time < 0, 10, time );
	
	wait time;
	
	_mission_failed( "@PARIS_AC130_MISSION_FAIL_HVI_KILLED" );
}

end_timed_mission_failed()
{
	level notify( "LISTEN_timed_mission_failed_end" );
}

reset_deltas_health( health )
{
	Assert( IsDefined( health ) );
	
	health = ter_op( health < 1, 1, health );
	
	group = level.delta;
    group[ group.size ] = level.makarov_number_2;
    
    foreach ( guy in group )
    	guy thread ai_friendly_set_health( health );
}
	
get_current_battle_line()
{
	return level.city_area_battle_lines[ level.city_area_current_battle_line ].origin;
}

get_battle_line( _line )
{
	Assert( IsDefined( _line ) );
	
	_line = ter_op( _line < 0, 0, _line );
	_line = ter_op( _line >= level.city_area_battle_lines.size, level.city_area_battle_lines.size - 1, _line );
	
	return level.city_area_battle_lines[ _line ].origin;
}

set_current_battle_line( _line )
{
	Assert( IsDefined( _line ) );
	
	_line = ter_op( _line < 0, 0, _line );
	_line = ter_op( _line >= level.city_area_battle_lines.size, level.city_area_battle_lines.size - 1, _line );
	
	level.city_area_current_battle_line = _line;
}

get_current_street_slope()
{
	return level.city_area_street_slopes[ level.city_area_current_street_slope ];
}

get_street_slope( slope )
{
	Assert( IsDefined( slope ) );
	
	slope = ter_op( slope < 0, 0, slope );
	slope = ter_op( slope >= level.city_area_street_slopes.size, level.city_area_street_slopes.size - 1, slope );
	
	return level.city_area_street_slopes[ slope ];
}

set_current_street_slope( slope ) 
{
	Assert( IsDefined( slope ) );
	
	slope = ter_op( slope < 0, 0, slope );
	slope = ter_op( slope >= level.city_area_street_slopes.size, level.city_area_street_slopes.size - 1, slope );
	
	level.city_area_current_street_slope = slope;
}

// *************************************
// MONITOR - ALL
// *************************************

monitor_encounter_enemies_all( _flag )
{
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );

    count = level.encounter_enemies.size;
    level.encounter_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_enemy" );
    
    while( level.encounter_enemies_count < count && !flag( _flag ) )
    {
        count = level.encounter_enemies.size;
        wait 0.05;
    }
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_enemy" );
    level.encounter_enemies_count = 0;
}

monitor_encounter_enemies_count( count, _flag )
{
    Assert( IsDefined( count ) );
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );
    
    count = gt_op( count, 0 );
    level.encounter_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_enemy" );
    
    while ( level.encounter_enemies_count < count  && !flag( _flag ) )
        wait 0.05;
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_enemy" );
    level.encounter_enemies_count = 0;
}

monitor_encounter_enemies_percent( percent, _flag )
{
	Assert( IsDefined( percent ) );
	Assert( IsDefined( _flag ) && flag_exist( _flag ) );
	
	percent = gt_op( percent, 0 );
	
	while ( !at_least_percent_dead_array( percent, level.encounter_enemies ) && !flag( _flag ) )
		wait 0.05;
	flag_set( _flag );
}

add_encounter_enemy( enemy )
{
    Assert( IsDefined( enemy ) && IsAlive( enemy ) );
    
    level.encounter_enemies = add_to_array( level.encounter_enemies, enemy );
    enemy thread monitor_encounter_enemy_on_death();
}

clear_encounter_enemies()
{
    level.encounter_enemies = array_removedead( level.encounter_enemies );
    level.encounter_enemies = array_removeundefined( level.encounter_enemies );
}

monitor_encounter_enemy_on_death()
{
	self endon( "LISTEN_end_monitor_encounter_enemy_on_death" );
    self waittill( "death", attacker );
    
    if ( ( compare( attacker, level.player ) || compare( attacker, self ) ) &&
         flag( "FLAG_monitor_encounter_enemy" ) ) 
        level.encounter_enemies_count++;      
}

kill_encounter_enemies( interval )
{
    Assert( IsDefined( interval ) );
    
    interval = gt_op( interval, 0.05 );
    
    foreach ( guy in level.encounter_enemies )
    {
        if ( IsDefined( guy ) && IsAlive ( guy ) )
        {
        	guy ai_disable_magic_bullet_shield();
            guy DoDamage( 100000, ( 0, 0, 0 ), level.player );
            wait interval;
        }
    }
}

// *************************************
// MONITOR - PRIMARY
// *************************************

monitor_encounter_primary_enemies_all( _flag )
{
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );

    count = level.encounter_primary_enemies.size;
    level.encounter_primary_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_primary_enemy" );
    
    while( level.encounter_primary_enemies_count < count && !flag( _flag ) )
    {
        count = level.encounter_primary_enemies.size;
        wait 0.05;
    }
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_primary_enemy" );
    level.encounter_primary_enemies_count = 0;
}

monitor_encounter_primary_enemies_count( count, _flag )
{
    Assert( IsDefined( count ) );
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );

    count = gt_op( count, 0 );
    level.encounter_primary_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_primary_enemy" );
    
    while( level.encounter_primary_enemies_count < count && !flag( _flag ) )
        wait 0.05;
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_primary_enemy" );
    level.encounter_primary_enemies_count = 0;
}

monitor_encounter_primary_enemies_percent( percent, _flag )
{
	Assert( IsDefined( percent ) );
	Assert( IsDefined( _flag ) && flag_exist( _flag ) );
	
	percent = gt_op( percent, 0 );
	
	while ( !at_least_percent_dead_array( percent, level.encounter_primary_enemies ) && !flag( _flag ) )
		wait 0.05;
	flag_set( _flag );
}

add_encounter_primary_enemy( enemy )
{
    Assert( IsDefined( enemy ) && IsAlive( enemy ) );
    
    level.encounter_primary_enemies = add_unique_to_array( level.encounter_primary_enemies, enemy );
    enemy thread monitor_encounter_primary_enemy_on_death();
}

add_encounter_primary_enemies( enemies )
{
    Assert( IsDefined( enemies ) && IsArray( enemies ) );
        
    foreach ( guy in enemies )
    {
        level.encounter_primary_enemies = add_unique_to_array( level.encounter_primary_enemies, guy );
        
        if ( IsDefined( guy ) && IsAlive( guy ) )
            guy thread monitor_encounter_primary_enemy_on_death();
    }
}

clear_encounter_primary_enemies()
{
    level.encounter_primary_enemies = array_removedead( level.encounter_primary_enemies );
    level.encounter_primary_enemies = array_removeundefined( level.encounter_primary_enemies );
}

monitor_encounter_primary_enemy_on_death()
{
	self endon( "LISTEN_end_monitor_encounter_primary_enemy_on_death" );
    self waittill( "death", attacker );
    
    if ( ( compare( attacker, level.player ) || compare( attacker, self ) ) &&
         flag( "FLAG_monitor_encounter_primary_enemy" ) ) 
        level.encounter_primary_enemies_count++;      
}

kill_encounter_primary_enemies( interval )
{
    Assert( IsDefined( interval ) );
    
    interval = ter_op( interval < 0.05, 0.05, interval );
    
    foreach ( guy in level.encounter_primary_enemies )
    {
        if ( IsDefined( guy ) && IsAlive ( guy ) )
        {
        	guy ai_disable_magic_bullet_shield();
            guy DoDamage( 10000, ( 0, 0, 0 ), level.player );
            wait interval;
        }
    }
}

encounter_primary_enemies_fallback()
{
	foreach ( guy in level.encounter_primary_enemies )
    {
        if ( IsDefined( guy ) && IsAlive ( guy ) )
            guy thread ai_enemy_street_patrol_fallback();
        wait 0.05;
    }
}

// *************************************
// MONITOR - SPECIAL
// *************************************

monitor_encounter_special_enemies_all( _flag )
{
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );

    count = level.encounter_special_enemies.size;
    level.encounter_special_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_special_ai" );
    
    while( level.encounter_special_enemies_count < count && !flag( _flag ) )
    {
        count = level.encounter_special_enemies.size;
        wait 0.05;
    }
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_special_ai" );
    level.encounter_special_enemies_count = 0;
}

monitor_encounter_special_enemies_count( count, _flag )
{
    Assert( IsDefined( count ) );
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );
      
    count = ter_op( count < 0, 0, count );
    level.encounter_special_enemies_count = 0;
    
    flag_set( "FLAG_monitor_encounter_special_ai" );
    
    while( level.encounter_special_enemies_count < count && !flag( _flag ) )
        wait 0.05;
    flag_set( _flag );
    flag_clear( "FLAG_monitor_encounter_special_ai" );
    level.encounter_special_enemies_count = 0;
}

add_encounter_special_enemy( enemy )
{
    Assert( IsDefined( enemy ) && IsAlive( enemy ) && IsAI( enemy ) );
    
    level.encounter_special_enemies = add_unique_to_array( level.encounter_special_enemies, enemy );
    enemy thread monitor_encounter_special_ai_on_death();
}

add_encounter_special_enemies( enemies )
{
    Assert( IsDefined( enemies ) && IsArray( enemies ) );
        
    foreach ( guy in enemies )
    {
        level.encounter_special_enemies = add_unique_to_array( level.encounter_special_enemies, guy );
        
        if ( IsDefined( guy ) && IsAlive( guy ) && IsAI( guy ) )
            guy thread monitor_encounter_special_ai_on_death();
    }
}

clear_encounter_special_enemies()
{
    level.encounter_special_enemies = array_removedead_or_dying( level.encounter_special_enemies );
    level.encounter_special_enemies = array_removeundefined( level.encounter_special_enemies );
}

monitor_encounter_special_ai_on_death()
{
    self waittill( "death", attacker );
    
    if ( flag( "FLAG_monitor_encounter_special_ai" ) ) 
        level.encounter_special_enemies_count++;      
}

kill_encounter_special_enemies( interval )
{
    Assert( IsDefined( interval ) );
    
    interval = ter_op( interval < 0.05, 0.05, interval );
    
    foreach ( guy in level.encounter_special_enemies )
    {
        if ( IsDefined( guy ) && IsAlive ( guy ) )
        {
        	guy ai_disable_magic_bullet_shield();
            guy DoDamage( 10000, ( 0, 0, 0 ), level.player );
            wait interval;
        }
    }
}

// *************************************
// SPAWNERS
// *************************************

burst_infinite_spawn_ai( initial_count, initial_interval, max_count, interval, _flag, ai_callbacks )
{
    Assert( IsSpawner( self ) );
    Assert( IsDefined( _flag ) && flag_exist( _flag ) );
    
    initial_count = gt_op( initial_count, 0 );
    initial_interval = gt_op( initial_interval, 0.05 );
    max_count = gt_op( max_count, initial_count );
    interval = gt_op( interval, 0.05 );
    
    ais = [];
    
    // Setup array for max enemies spawned
    
    for ( i = 0; i < max_count; i++ )
        ais[ ais.size ] = undefined;
        
    // Spawn a "burst" of ai
    
    for ( i = 0; i < initial_count; i++ )
    {     
        self.count = 1;
        ais[ i ] = self StalingradSpawn();
        
        if ( IsDefined( ais[ i ] ) )
        {
            if ( IsDefined( ai_callbacks ) && IsArray( ai_callbacks ) )
            {
                thread burst_spawn_ai_callback( ai_callbacks, ais[ i ], undefined, "after_spawn", "caller" );
                thread burst_spawn_ai_callback( ai_callbacks, undefined, ais[ i ], "after_spawn", "pass_value" );
            }
            wait initial_interval;
        }
    }
    
    // Replenish ais as they dies
    
    while ( !flag( _flag ) )
    {
        // Check for any dead ai in list
        
        ai_killed = false;
        i = -1;
        
        while ( !ai_killed && !flag( _flag ) )
        {
            foreach ( j, guy in ais )
            {
                if ( !IsDefined( guy ) || !IsAlive( guy ) )
                {
                    ai_killed = true;
                    i = j;
                }
            }
            wait 0.05;
        } 
        
        if ( flag( _flag ) )
            break; 
        wait interval;
        if ( flag( _flag ) )
            break;  
            
        self.count = 1;
        ais[ i ] = self StalingradSpawn();
        
        if ( IsDefined( ais[ i ] ) &&
             IsDefined( ai_callbacks ) && IsArray( ai_callbacks ) )
        {
            thread burst_spawn_ai_callback( ai_callbacks, ais[ i ], undefined, "after_spawn", "caller" );
            thread burst_spawn_ai_callback( ai_callbacks, undefined, ais[ i ], "after_spawn", "pass_value" );
        }  
    }
    
    // Clean up
    
    if ( IsDefined( ai_callbacks ) && IsArray( ai_callbacks ) )
    {
        foreach ( ai in ais )
        {
            if ( IsDefined( ai ) && IsAlive( ai ) )
                ai thread burst_spawn_ai_callback( ai_callbacks, ai, undefined, "before_spawner_cleanup", "caller" );
        }
        thread burst_spawn_ai_callback( ai_callbacks, undefined, ais, "before_spawner_cleanup", "pass_value" );
    }       
    self Delete();
}

burst_spawn_ai_callback( ai_callbacks, caller, pass_value, sequence, _type )
{
    Assert( IsDefined( ai_callbacks ) && IsArray( ai_callbacks ) );
    Assert( IsDefined( sequence ) );
    Assert( IsDefined( _type ) );
    
    // [ sequence ][ type ][ callback ]
    
    if ( IsDefined( ai_callbacks ) &&
         IsDefined( ai_callbacks[ sequence ] ) &&
         IsDefined( ai_callbacks[ sequence ][ _type ] ) )
    {
        foreach ( callback in ai_callbacks[ sequence ][ _type ] )
        {
            switch( _type )
            {
                case "caller":
                        caller thread [[ callback ]]();
                    break;
                case "pass_value":
                        thread [[ callback ]]( pass_value );
                    break;
            }
        }
    }
}

street_enemy_spawner( _flag )
{  
   	points = getstructarray( self.targetname, "targetname" );
   	spawners = [ GetEnt( self.targetname + "_AR", "targetname" ),
   				 GetEnt( self.targetname + "_SMG", "targetname" ),
   				 GetEnt( self.targetname + "_RPG", "targetname" ) ];
   
    k = 0;
    
    for ( i = 0; i < self._initial_count; i++ )
    {
    	k = ter_op( k < points.size, k, 0 );
    	nodes = GetNodeArray( points[ k ].script_noteworthy, "targetname" );
        found_unclaimed_node = false;
        _node = undefined;
        
        while ( !found_unclaimed_node )
        {
            foreach ( node in nodes )
            {
                if ( !IsDefined( node.owner ) )
                { 
                    found_unclaimed_node = true;
                    _node = node;
                    break;
                }
            }
            wait 0.05;
        }
        
        spawner = ter_op( random_chance( 0.5 ), spawners[ 2 ], spawners[ RandomInt( 2 ) ] );
        spawner.count = 1;
        spawner.origin = points[ k ].origin;
        spawner.angles = points[ k ] get_key( "angles" );
        self._ais[ i ] = spawner StalingradSpawn();
        
        if ( !spawn_failed( self._ais[ i ] ) )
        {
            self._ais[ i ] set_goal_node( _node );
            self._ais[ i ].target_radius = points[ k ].radius;
            self._ais[ i ].target_point = points[ k ].origin;
            
            if ( IsDefined( self._ai_callbacks ) && IsArray( self._ai_callbacks ) )
            {
                thread burst_spawn_ai_callback( self._ai_callbacks, self._ais[ i ], undefined, "after_spawn", "caller" );
                thread burst_spawn_ai_callback( self._ai_callbacks, undefined, self._ais[ i ], "after_spawn", "pass_value" );
            }
            wait self._initial_interval;
        }
        k++;
    }
    
    // Replenish ais as they dies
    
    k = 0;
    
    while ( !flag( _flag ) )
    {    	
        // Check for any dead ai in list
        
        ai_killed = false;
        i = -1;
        
        while ( !ai_killed && !flag( _flag ) )
        {
        	self._ais = array_removedead( self._ais );
        	self._ais = array_removeundefined( self._ais );
        	
        	if ( self._ais.size < self._max_count )
        	{
        		ai_killed = true;
        		i = self._ais.size;
        	}
            wait 0.05;
        } 
        
        if ( flag( _flag ) )
            break; 
        wait self._interval;
        if ( flag( _flag ) )
            break; 
        
        // Find unclaimed node
        
        k = ter_op( k < points.size, k, 0 );
    	nodes = GetNodeArray( points[ k ].script_noteworthy, "targetname" );
        found_unclaimed_node = false;
        _node = undefined;
        
        while ( !found_unclaimed_node && !flag( _flag ) )
        {
            foreach ( node in nodes )
            {
                if ( !IsDefined( node.owner ) )
                { 
                    found_unclaimed_node = true;
                    _node = node;
                    break;
                }
            }
            wait 0.05;
        }
        
        if ( flag( _flag ) )
            break; 
        
        spawner = ter_op( random_chance( 0.3 ), spawners[ 2 ], spawners[ RandomInt( 2 ) ] );    
        spawner.count = 1;
        spawner.origin = points[ k ].origin;
        spawner.angles = points[ k ] get_key( "angles" );
        self._ais[ i ] = spawner StalingradSpawn();
        
        if ( !spawn_failed( self._ais[ i ] ) )
        {
            self._ais[ i ] set_goal_node( _node );
            self._ais[ i ].target_radius = points[ k ].radius;
            self._ais[ i ].target_point = points[ k ].origin;
            
            if ( IsDefined( self._ai_callbacks ) && IsArray( self._ai_callbacks ) )
            {
                thread burst_spawn_ai_callback( self._ai_callbacks, self._ais[ i ], undefined, "after_spawn", "caller" );
                thread burst_spawn_ai_callback( self._ai_callbacks, undefined, self._ais[ i ], "after_spawn", "pass_value" );
            }
        }
        k++;  
    }
    
    // Clean up
    
    if ( IsDefined( self._ai_callbacks ) && IsArray( self._ai_callbacks ) )
    {
        foreach ( ai in self._ais )
        {
            if ( IsDefined( ai ) && IsAlive( ai ) )
                thread burst_spawn_ai_callback( self._ai_callbacks, ai, undefined, "before_spawner_cleanup", "caller" );
        }
        thread burst_spawn_ai_callback( self._ai_callbacks, undefined, self._ais, "before_spawner_cleanup", "pass_value" );
    }
    
    foreach ( spawner in spawners )
    	spawner Delete();
    self Delete();
}

building_trigger_reminder()
{
	sounds = [];

	// 2-13 Do not fire directly on the buildings.
	sounds[ sounds.size ] = level.scr_sound[ "plt" ][ "ac130_plt_donotfire" ];
	// 17-1 Careful.  We're not cleared to fire on any buildings.
	sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_notcleared2" ];
    // 17-2 Watch those buildings.  There might be civilians in there.
    sounds[ sounds.size ] = level.scr_sound[ "fco" ][ "ac130_fco_watchbuildings" ]; 
    // 17-3 Crew, we are NOT authorized to fire on the buildings.
    sounds[ sounds.size ] = level.scr_sound[ "plt" ][ "ac130_plt_notauthorized" ];
    
    array = [];
    
    for ( i = 0; i < sounds.size; i++ )
    	array[ array.size ] = i;
    	
    index = 0;
	time_elapsed_before_warning_player = 1.5;
	
	for ( ; ; )
	{
		if ( flag( "FLAG_building_trigger_mission_failed_on" ) && level.player_hit_building )
		{	
			if ( array.size == 0 )
			{
				for ( i = 0; i < sounds.size; i++ )
	    			array[ array.size ] = i;
	    		if ( array.size > 1 )
	    			array = array_remove_index( array, index );
	    	}
	
			index = RandomInt( array.size );
			
			vehicle_scripts\_ac130::playSoundOverRadio( sounds[ array[ index ] ], true, 4.0 );
	    	array = array_remove_index( array, index );
	    	wait time_elapsed_before_warning_player;
	    	level.player_hit_building = false;
		}
		else
			wait 0.05;
	}
}

building_trigger_mission_failed()
{
	self endon( "death" );
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		if ( flag( "FLAG_building_trigger_mission_failed_on" ) && 
			 compare( attacker, level.player ) && 
			 compare( type, "MOD_PROJECTILE" )  )
		{
			if ( damage > 990 )
				level.mission_fail_points += level.max_mission_fail_points / 3; //2 // Fail on 2nd shot
			else 
			if ( damage > 200 )
				level.mission_fail_points += level.max_mission_fail_points / 7; //7 // Fail on 7th shot
			//else
			//	level.mission_fail_points += level.max_mission_fail_points / 60; //20 // Fail on 20th shot
			
			level.player_hit_building = true;
		}
	}
}

rpg_building_trigger_mission_failed()
{
	self endon( "death" );
	
	while ( !flag( "FLAG_rpg_building_valid_target" ) )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		if ( !flag( "FLAG_rpg_building_valid_target" ) &&
			 flag( "FLAG_building_trigger_mission_failed_on" ) && 
			 compare( attacker, level.player ) && 
			 compare( type, "MOD_PROJECTILE" ) )
		{
			if ( damage > 990 )
				level.mission_fail_points += level.max_mission_fail_points / 3; //3 // Fail on 4th shot
			else 
			if ( damage > 200 )
				level.mission_fail_points += level.max_mission_fail_points / 7; //14 // Fail on 14th shot
			//else
			//	level.mission_fail_points += level.max_mission_fail_points / 60; //30 // Fail on 30th shot
			
			level.player_hit_building = true;
		}
	}
}

monitor_mission_fail_points()
{
	level endon( "LISTEN_end_monitor_mission_fail_points" );
	
	current_mission_fail_points = level.mission_fail_points;
	time = GetTime();
	time_before_regen = 6;
	
	for ( ; ; )
	{
		// Check if player's mission fail have changed
		
		if ( level.mission_fail_points < 0 )
			level.mission_fail_points = 0;
		else
		if ( level.mission_fail_points >= level.max_mission_fail_points )
			_mission_failed( "@PARIS_AC130_MISSION_FAIL_BUILDING" );
		
		// Check if it's time to reset the player's mission points
			
		if ( ( ( GetTime() - time ) / 1000 ) > time_before_regen )
		{
			time = GetTime();
			level.mission_fail_points = 0;
		}
		
		if ( current_mission_fail_points != level.mission_fail_points )
		{
			time = GetTime();
			current_mission_fail_points = level.mission_fail_points;
		}
		wait 0.05;
	}
}

monitor_ai_mission_fail_points()
{
	while ( IsDefined( self ) && IsAlive( self ) )
		wait 0.05;
	level.mission_fail_points -= 50;
}

monitor_vehicle_mission_fail_points()
{
	while ( IsDefined( self ) && IsAlive( self ) )
		wait 0.05;
	level.mission_fail_points -= 200;
}

monitor_interact_button()
{
	level endon( "LISTEN_end_monitor_interact_button" );
	
	NotifyOnCommand( "LISTEN_interact_button_pressed", "+usereload" );
	
	for ( ; ; )
	{
		flag_clear( "FLAG_interact_button_pressed" );
		level.player waittill( "LISTEN_interact_button_pressed" );
		flag_set( "FLAG_interact_button_pressed" );
		wait 0.1;
	}
}

hint_interact_button()
{
	return flag( "FLAG_interact_button_pressed" );
}

ai_enemy_kill_dialogue_monitor()
{
	self waittill( "death", attacker );
	if ( compare( attacker, level.player ) )
		level.enemy_ai_killed = true;
}

vehicle_enemy_kill_dialogue_monitor( vehicle_type )
{
	self waittill( "death", attacker );
	if ( compare( attacker, level.player ) )
	{
		level.enemy_vehicle_killed = true;
		
		if ( IsDefined( vehicle_type ) )
		{
			switch ( vehicle_type )
			{
				case "btr":
					level.enemy_btr_killed = true;
					break;
				case "hind":
					level.enemy_hind_killed = true;
					break;
				case "mi17":
					level.enemy_mi17_killed = true;
					break;
				case "t72":
					level.enemy_t72_killed = true;
					break;
			}
		}
	}
}

vehicle_safe_gopath( vehicle )
{
	if ( !IsDefined( vehicle ) )
		return;
		
	vehicle endon( "death" );
	
	if ( IsAlive( vehicle ) )
		thread gopath( vehicle );
}
					
// *************************************
// AC130 - Angel Flare
// *************************************

ac130_angel_flare_event( node_prefix, index )
{
	Assert( IsDefined( node_prefix ) );
	
	flag_set( "FLAG_ac130_flare_event_started" );
	level.player LerpViewAngleClamp( 0, 0, 0, 15, 15, 10, 0 );
	
	level.ac130_thermal_blur = 0;
	level.ac130_enhanced_blur = 0;
	blur = ter_op( flag( "FLAG_ac130_thermal_enabled" ), level.ac130_thermal_blur, level.ac130_enhanced_blur );
	level.player SetBlurForPlayer( blur, 0 );
	
	// Play Beeping Sound
	
	thread ac130_angel_flare_shaking( node_prefix );
	thread ac130_angel_flare_spawn_jets( node_prefix );
	thread ac130_angel_shooting_flares( node_prefix );
	thread ac130_angel_flare_restore_view( node_prefix );
	
	// Check when flare event is "finished"
	
	finish_node = GetVehicleNode( node_prefix + "_event_finished", "script_noteworthy" );
	Assert( IsDefined( finish_node ) );
	finish_node waittill( "trigger" );
	
	level.ac130_thermal_blur = 0.5;
	level.ac130_enhanced_blur = 0.5;
	blur = ter_op( flag( "FLAG_ac130_thermal_enabled" ), level.ac130_thermal_blur, level.ac130_enhanced_blur );
	level.player SetBlurForPlayer( blur, 0 );
	//flag_set( "FLAG_ac130_flare_event_finished" );
}

ac130_angel_flare_shaking( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	// Setup Shaking 
	
	level.player PlayRumbleLoopOnEntity( "damage_light" );
	earthquake_at_ent( 0.1, 4.0, level.player, 1000 );
	level.player StopRumble( "damage_light" );
	
	// Start to rumble and shake a little before flares go off
	
	rumble_node = GetVehicleNode( node_prefix + "_rumble", "script_noteworthy" );
	Assert( IsDefined( rumble_node ) );
	rumble_node waittill( "trigger" );
	
	level.player PlayRumbleLoopOnEntity( "damage_heavy" );
	earthquake_at_ent( 0.16, 4.5, level.player, 1000 );
	level.player StopRumble( "damage_heavy" );
}

ac130_angel_flare_missiles( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	vehicle_spawner = GetEnt( node_prefix + "_missile", "targetname" );
	Assert( IsDefined( vehicle_spawner ) );
	_spots = getstructarray_delete( node_prefix + "_missile", "targetname" );
	spots = [];
	foreach ( spot in _spots )
		if ( compare( level.ac130_current_spline_section, Int( spot.script_parameters ) ) )
			spots[ spots.size ] = spot;
	missiles = [];
	
	foreach ( spot in spots )
	{
		vehicle_spawner.count = 1;
		vehicle_spawner.origin = spot.origin;
		vehicle_spawner.angles = spot get_key( "angles" );
		vehicle_spawner.target = spot.target;
		missiles[ spot.script_index ] = vehicle_spawner spawn_vehicle();
		wait 0.1;
	}
	 
	wait 0.05;
	
	missile_models = [];
	missile_tags = [];
	
	foreach ( i, missile in missiles )
	{	
		missile_models[ i ] = Spawn( "script_model", ( 0, 0, 0 ) );
		missile_models[ i ] SetModel( "ss_n_12_missile" );
		missile_models[ i ].angles = ( -90, 0, 0 );
		missile_models[ i ] DontCastShadows();
	
		missile_tags[ i ] = Spawn( "script_model", missile_models[ i ] GetTagOrigin( "tag_tail" ) );
		missile_tags[ i ] SetModel( "tag_origin" );
		missile_tags[ i ].angles = ( -90, 0, 0 );
	
		missile_models[ i ] LinkTo( missile_tags[ i ], "tag_origin" );
		missile_tags[ i ].origin = missile.origin;
		missile_tags[ i ].angles = missile.angles;
	
		missile_tags[ i ] LinkTo( missile, "tag_origin" );
	}
	
	missiles[ 1 ] delaythread( 0.05, ::ac130_angel_flare_missile_fire, missile_models[ 1 ], missile_tags[ 1 ] );
	missiles[ 2 ] delaythread( 0.5, ::ac130_angel_flare_missile_fire, missile_models[ 2 ], missile_tags[ 2 ] );
	missiles[ 3 ] delaythread( 0.6, ::ac130_angel_flare_missile_fire, missile_models[ 3 ], missile_tags[ 3 ] );
	
	// 10-17 Incoming missile!
    vehicle_scripts\_ac130::playSoundOverRadio( level.scr_sound[ "plt" ][ "ac130_plt_missile" ], true, 10 );
    
	// Clean up
	
	flag_wait( "FLAG_ac130_shoot_angel_flares_finished" );
	
	vehicle_spawner Delete();
}

ac130_angel_flare_missile_fire( model, _tag )
{
	fx = getfx( "FX_mig_missile_trail" );
	
	PlayFxOnTag( fx, self, "tag_origin" );
	self thread gopath();
	self waittill( "reached_dynamic_path_end" );
	StopFXOnTag( fx, self, "tag_origin" );
	model Delete();
	_tag Delete();
	self Delete();
}

ac130_angel_flare_spawn_jets( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	thread ac130_angel_flare_spawn_migs( node_prefix );
	thread ac130_angel_flare_spawn_f15s( node_prefix );
	
	flag_wait( "FLAG_ac130_shoot_angel_flares_start" );
	
	// F15 shootings at migs
	
	thread ac130_angel_flare_jets_shooting( node_prefix );
	
	// Jet flybys
	
	migs = get_ent_array_with_prefix_1_to_1( node_prefix + "_mig_", "script_noteworthy", 1 );
	f15s = get_ent_array_with_prefix_1_to_1( node_prefix + "_f15_", "script_noteworthy", 1 );
	
	migs[ 1 ] delayThread( 1.5, ::gopath );
	migs[ 2 ] delayThread( 3.5, ::gopath );
	f15s[ 1 ] delayThread( 4.0, ::gopath );
	f15s[ 2 ] delayThread( 5.5, ::gopath );
}

ac130_angel_flare_spawn_migs( node_prefix )
{
	Assert( IsDefined( node_prefix ) );

	mig_spawner = GetEnt( "angle_flare_mig", "targetname" );
	Assert( IsDefined( mig_spawner ) );
	mig_spawner add_spawn_function( ::enemy_mig29_init );
	mig_spawner add_spawn_function( ::enemy_mig29_sonic_boom );
	mig_spawner add_spawn_function( ::enemy_mig29_delete_on_path_end );
	spots = get_ent_array_with_prefix( node_prefix + "_mig_", "targetname", 1 );
	migs = [];
	
	foreach ( i, spot in spots )
	{
		mig_spawner.count = 1;
		mig_spawner.origin = spot.origin;
		mig_spawner.angles = spot get_key( "angles" );
		mig_spawner.target = spot.target;
		
		migs[ i + 1 ] = mig_spawner spawn_vehicle();
		Assert( IsDefined( migs[ i + 1 ] ) );
		
		migs[ i + 1 ].script_noteworthy = spot.targetname;
		wait 0.1;
	}
	mig_spawner Delete();
}

ac130_angel_flare_spawn_f15s( node_prefix )
{
	Assert( IsDefined( node_prefix ) );

	f15_spawner = GetEnt( "angle_flare_f15", "targetname" );
	Assert( IsDefined( f15_spawner ) );
	f15_spawner add_spawn_function( ::friendly_f15_init );
	f15_spawner add_spawn_function( ::friendly_f15_sonic_boom );
	f15_spawner add_spawn_function( ::friendly_f15_delete_on_path_end );
	spots = get_ent_array_with_prefix( node_prefix + "_f15_", "targetname", 1 );
	f15s = [];
	
	foreach ( i, spot in spots )
	{
		f15_spawner.count = 1;
		f15_spawner.origin = spot.origin;
		f15_spawner.angles = spot get_key( "angles" );
		f15_spawner.target = spot.target;
		
		f15s[ i + 1 ] = f15_spawner spawn_vehicle();
		Assert( IsDefined( f15s[ i + 1 ] ) );
		
		f15s[ i + 1 ].script_noteworthy = spot.targetname;
		wait 0.1;
	}
	f15_spawner Delete();
}

ac130_angel_flare_jets_shooting( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	start_points = get_ent_array_with_prefix( node_prefix + "_mig_", "targetname", 1 );
	
	ent_path_list_1 = get_connected_ents( start_points[ 0 ].target );
	ent_path_list_2 = get_connected_ents( start_points[ 0 ].target );
	
	end_points[ 0 ] = get_ents_from_array( "sonic_boom", "script_noteworthy", ent_path_list_1 )[ 0 ];
	end_points[ 1 ] = get_ents_from_array( "sonic_boom", "script_noteworthy", ent_path_list_2 )[ 0 ];
	
	time = 4.0;
	elapsed = 0;
	delay = 0.05;
	
	while ( elapsed < time )
	{
		start = start_points[ RandomInt( start_points.size ) ].origin;
		end = end_points[ RandomInt( end_points.size ) ].origin;
		fwd = VectorNormalize( end - start );
		PlayFX( getfx( "FX_jet_20mm_tracer_close_ac130" ), start, fwd );
		elapsed += delay;
		wait delay;
	}
}

ac130_angel_shooting_flares( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	angel_flare_start = GetVehicleNode( node_prefix + "_fire", "script_noteworthy" );
	Assert( IsDefined( angel_flare_start ) );
	angel_flare_start waittill( "trigger" );
	flag_set( "FLAG_ac130_shoot_angel_flares_start" );
	
	// Shoot flares
	
	thread ac130_angel_flare_burst( 20 );
	delayThread( 1.5, ::ac130_angle_flare_explosions );

	flag_wait( "FLAG_ac130_shoot_angel_flares_finished" );
	level.player delayThread( 6.0, ::stop_loop_sound_on_entity, "missile_warning" );
	level.player delayThread( 6.0, vehicle_scripts\_ac130::hud_lock_on_flash_stop );
}
 					
ac130_angel_flare_burst( flare_count )
{
	// Angel Flare Trails
	
	for( i = 0; i < flare_count; i++ )
	{
		if ( !( i % flare_count ) )
			level.player PlaySound( "ac130_flare_burst" );		  
		thread ac130_angel_flare_shoot_flare();
		wait RandomFloatRange( 0.1, 0.25 );
	}
	flag_set( "FLAG_ac130_shoot_angel_flares_finished" );
}

ac130_angel_flare_shoot_flare()
{
	if ( !IsDefined( level.anim_index ) )
		level.anim_index = 0;

	rig = spawn_anim_model( "angel_flare_rig" );

	rig.origin = level.player.origin + ( 0, 0, 32 );
	rig.angles = level.player GetPlayerAngles() + ( 0, -45, 0 );

	fx_id = getfx( "FX_angel_flare_geotrail" );

	anim_count = level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ].size;
	animation = level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][ level.anim_index % anim_count ];
	level.anim_index++;

	rig SetFlaggedAnim( "flare_anim", animation, 1, 0, 1 );

	wait 0.1;
	PlayFXOnTag( fx_id, rig, "flare_left_top" );
	PlayFXOnTag( fx_id, rig, "flare_right_top" );
	wait 0.05;
	PlayFXOnTag( fx_id, rig, "flare_left_bot" );
	PlayFXOnTag( fx_id, rig, "flare_right_bot" );

	rig waittillmatch( "flare_anim", "end" );

	StopFXOnTag( fx_id, rig, "flare_left_top" );
	StopFXOnTag( fx_id, rig, "flare_right_top" );
	StopFXOnTag( fx_id, rig, "flare_left_bot" );
	StopFXOnTag( fx_id, rig, "flare_right_bot" );
	
	rig Delete();
}

ac130_angle_flare_explosions()
{
	spots = get_connected_ents( "ac130_angel_flare_explosions" );
	deletestructarray_ref( spots );
	
	fx = getfx( "FX_angel_flare_explosion" );
	delay = 0.5;
	
	foreach ( spot in spots )
	{
		fwd = AnglesToForward( spot get_key( "angles" ) );
		PlayFX( fx, spot.origin, fwd );
		level.player PlayRumbleLoopOnEntity( "damage_heavy" );
		level.player delayCall( 0.25, ::StopRumble, "damage_heavy" );
		wait delay;
	}
}

ac130_angel_flare_restore_view( node_prefix )
{
	Assert( IsDefined( node_prefix ) );
	
	// Lerp view back to normal
	
	lerp_transition_node = GetVehicleNode( node_prefix + "_restore_view", "script_noteworthy" );
	Assert( IsDefined( lerp_transition_node ) );
	lerp_transition_node waittill( "trigger" );
	level.player LerpViewAngleClamp( 2, 0.05, 0.05, 
									 level.ac130_default_right_arc, level.ac130_default_left_arc, level.ac130_default_top_arc, level.ac130_default_bottom_arc );
	vehicle_scripts\_ac130::ac130_reset_view_arc();
	SetDvar( "ac130_zoom_enabled", 1 );
	flag_set( "FLAG_ac130_change_weapons_enabled" );
}

fake_vehicle_rumble( parent, classname )
{
	Assert( IsDefined( parent ) );
	Assert( IsDefined( classname ) );
	
	// makes vehicle rumble

	self endon( "kill_rumble_forever" );
		
	rumblestruct = undefined;
	if ( IsDefined( self.vehicle_rumble_unique ) )
	{
		rumblestruct = self.vehicle_rumble_unique;
	}
	else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble_override;
	}
	else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble[ classname ];
	}

	if ( !IsDefined( rumblestruct ) )
	{
		return;
	}

	height = rumblestruct.radius * 2;
	zoffset = -1 * rumblestruct.radius;
	areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger EnableLinkTo();
	areatrigger LinkTo( self );
	self.rumbletrigger = areatrigger;
	self endon( "death" );
// 	( rumble, scale, duration, radius, basetime, randomaditionaltime )

	//.rumbleon is not used anywhere else 
	//and the current behavior is to turn it on by default but respect it if someone turns it off
	if ( !IsDefined( self.rumbleon ) )
		self.rumbleon = true;
		
	if ( IsDefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale;
	else
		self.rumble_scale = 0.15;

	if ( IsDefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration;
	else
		self.rumble_duration = 4.5;

	if ( IsDefined( rumblestruct.radius ) )
	{
		self.rumble_radius = rumblestruct.radius;
	}
	else
	{
		self.rumble_radius = 600;
	}

	if ( IsDefined( rumblestruct.basetime ) )
	{
		self.rumble_basetime = rumblestruct.basetime;
	}
	else
	{
		self.rumble_basetime = 1;
	}

	if ( IsDefined( rumblestruct.randomaditionaltime ) )
	{
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	}
	else
	{
		self.rumble_randomaditionaltime = 1;
	}

	areatrigger.radius = self.rumble_radius;
	while ( 1 )
	{
		areatrigger waittill( "trigger" );
		if ( parent Vehicle_GetSpeed() == 0 || !self.rumbleon )
		{
			wait 0.1;
			continue;
		}

		self PlayRumbleLoopOnEntity( rumblestruct.rumble );

		while ( level.player IsTouching( areatrigger ) && self.rumbleon && parent Vehicle_GetSpeed() > 0 )
		{
			if ( dsq_lt( level.ac130player.origin, self.origin, self.rumble_radius * 0.75 ) )
					flag_set( "FLAG_ac130_rumble" );
			Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( rumblestruct.rumble );
	}
}

fake_jet_rumble( classname )
{
	Assert( IsDefined( classname ) );
	
	// makes vehicle rumble

	self endon( "kill_rumble_forever" );
		
	rumblestruct = undefined;
	if ( IsDefined( self.vehicle_rumble_unique ) )
	{
		rumblestruct = self.vehicle_rumble_unique;
	}
	else if ( IsDefined( level.vehicle_rumble_override ) && IsDefined( level.vehicle_rumble_override[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble_override;
	}
	else if ( IsDefined( level.vehicle_rumble[ classname ] ) )
	{
		rumblestruct = level.vehicle_rumble[ classname ];
	}

	if ( !IsDefined( rumblestruct ) )
	{
		return;
	}

	height = rumblestruct.radius * 2;
	zoffset = -1 * rumblestruct.radius;
	areatrigger = Spawn( "trigger_radius", self.origin + ( 0, 0, zoffset ), 0, rumblestruct.radius, height );
	areatrigger EnableLinkTo();
	areatrigger LinkTo( self );
	self.rumbletrigger = areatrigger;
	self endon( "death" );
// 	( rumble, scale, duration, radius, basetime, randomaditionaltime )

	//.rumbleon is not used anywhere else 
	//and the current behavior is to turn it on by default but respect it if someone turns it off
	if ( !IsDefined( self.rumbleon ) )
		self.rumbleon = true;
		
	if ( IsDefined( rumblestruct.scale ) )
		self.rumble_scale = rumblestruct.scale;
	else
		self.rumble_scale = 0.15;

	if ( IsDefined( rumblestruct.duration ) )
		self.rumble_duration = rumblestruct.duration;
	else
		self.rumble_duration = 4.5;

	if ( IsDefined( rumblestruct.radius ) )
	{
		self.rumble_radius = rumblestruct.radius;
	}
	else
	{
		self.rumble_radius = 600;
	}

	if ( IsDefined( rumblestruct.basetime ) )
	{
		self.rumble_basetime = rumblestruct.basetime;
	}
	else
	{
		self.rumble_basetime = 1;
	}

	if ( IsDefined( rumblestruct.randomaditionaltime ) )
	{
		self.rumble_randomaditionaltime = rumblestruct.randomaditionaltime;
	}
	else
	{
		self.rumble_randomaditionaltime = 1;
	}

	areatrigger.radius = self.rumble_radius;
	while ( 1 )
	{
		areatrigger waittill( "trigger" );
		if ( !self.rumbleon )
		{
			wait 0.1;
			continue;
		}

		self PlayRumbleLoopOnEntity( rumblestruct.rumble );

		while ( level.player IsTouching( areatrigger ) && self.rumbleon )
		{
			if ( dsq_lt( level.ac130player.origin, self.origin, self.rumble_radius * 0.35 ) )
					flag_set( "FLAG_ac130_rumble" );
			Earthquake( self.rumble_scale, self.rumble_duration, self.origin, self.rumble_radius ); // scale duration source radius
			wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
		}
		self StopRumble( rumblestruct.rumble );
	}
}

// *************************************
// FRIENDLY M1A1
// *************************************

friendly_m1a1_init( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self ent_flag_init( "FLAG_m1a1_init" );
	
	self.targetname = value;
	
	self godon();
	
	self thread friendly_m1a1_mission_failed();
	self thread vehicle_scripts\_ac130::add_ac130_vehicle_beacon_effect( "tag_turret" );
	
	self ent_flag_set( "FLAG_m1a1_init" );
}

friendly_m1a1_canon_shoot_at_target_ent( ent )
{
	Assert( IsDefined( ent ) );
	
	self SetTurretTargetEnt( ent );
	wait 0.05;
	self FireWeapon();
}

friendly_m1a1_randomly_target_ents( ents )
{
	Assert( IsDefined( ents ) && IsArray( ents ) && ents.size > 0 );
	
	self notify( "LISTEN_m1a1_end_randomly_target_ents" );
	 
	self endon( "death" );
	self endon( "LISTEN_m1a1_end_randomly_target_ents" );
	
	delay = 3.0;
	
	for ( ; ; )
	{
		ent = get_random_defined_from_array( ents );
		self SetTurretTargetEnt( ent );
		wait delay;
	} 
}

friendly_m1a1_canon_randomly_shoot_on_notify( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self notify( "LISTEN_m1a1_end_randomly_shoot_canon" );
	
	self endon( "death" );
	self endon( "LISTEN_m1a1_end_randomly_shoot_canon" );
	
	notifying_ent = getent_or_struct_or_node( value, key ); 
	Assert( IsDefined( notifying_ent ) );
	
	notifying_ent waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	shooting_time = 6.0;
	non_shooting_time = 8.0;
	fire_interval = 3.0;
	
	wait RandomFloatRange( 0.05, 1.5 );
	
	for ( ; ; )
	{
		elapsed = 0;
		
		while ( elapsed < shooting_time )
		{
			self FireWeapon();
			elapsed += fire_interval;
			wait fire_interval;
		}
		wait non_shooting_time;
		wait 0.05;
	}
}

friendly_m1a1_randomly_shoot_canon()
{
	self endon( "death" );
	self endon( "LISTEN_m1a1_end_randomly_shoot_canon" );
	
	shooting_time = 6.0;
	non_shooting_time = 8.0;
	fire_interval = 3.0;
	
	wait RandomFloatRange( 0.05, 1.5 );
	
	for ( ; ; )
	{
		elapsed = 0;
		
		while ( elapsed < shooting_time )
		{
			self FireWeapon();
			elapsed += fire_interval;
			wait fire_interval;
		}
		wait non_shooting_time;
		wait 0.05;
	}
}

friendly_m1a1_end_randomly_shoot_canon()
{
	self notify( "LISTEN_m1a1_end_randomly_shoot_canon" );
	self ClearTurretTarget();
}

friendly_m1a1_randomly_shoot_mg()
{
	self endon( "death" );
	
	shooting_time = 3.0;
	non_shooting_time = 3.0;
	
	for ( ; ; )
	{
		self thread maps\_vehicle::mgon();
		wait shooting_time;
		self thread maps\_vehicle::mgoff();
		wait non_shooting_time;
		wait 0.05;
	} 
}

friendly_m1a1_stop_on_notify( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
		
	notifying_ent = getent_or_struct_or_node( value, key ); 
	Assert( IsDefined( notifying_ent ) );
	
	notifying_ent waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	self Vehicle_SetSpeed( 0, 5, 5 ); 
}

friendly_m1a1_randomly_look_ahead()
{
	self endon( "death" );
	
	delay = 2.0;
	
	for ( ; ; )
	{
		forward = VectorNormalize( AnglesToForward( self.angles + ( 0, RandomFloatRange( -15, 15 ), 0 ) ) );
		target = self.origin + ( forward * 1024 );
		self SetTurretTargetVec( target );
		wait delay;
	}
}

friendly_m1a1_explode()
{
	self endon( "death" );
	
	ent_path_list = get_connected_ents( self.target );
	explode_node = get_ents_from_array( "explosion", "script_noteworthy", ent_path_list )[ 0 ];
	
	if ( IsDefined( explode_node ) )
	{
		explode_node waittill( "trigger" );
		
		fx = getfx( "FX_m1a1_explosion" );
		pos = self.origin;
		fwd = ( 0, 0, 1 );
		PlayFX( fx, pos, fwd );

		self godoff();
		wait 0.05;
		self DoDamage( 10000, self.origin );
		self notify( "death" );
	}
}

friendly_m1a1_mission_failed()
{
	self endon( "death" );
	self endon( "LISTEN_end_m1a1_mission_failed" );
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		is_player_weapon = false;
		
		if ( IsDefined( weapon ) )
			is_player_weapon = vehicle_scripts\_ac130::is_ac130_weapon( weapon );
		
		if ( is_player_weapon )
			break;
	}
	_mission_failed( "@PARIS_AC130_MISSION_FAIL_FRIENDLY_KILLED" );
}

// *************************************
// FRIENDLY HUMMER
// *************************************

friendly_hummer_init( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self ent_flag_init( "FLAG_hummer_init" );
	
	self set_key( value, key );
	self.script_turret_targets = [];
	
	self godon();
	self ThermalDrawEnable();
	
	self thread friendly_hummer_mission_failed();
	
	self ent_flag_set( "FLAG_hummer_init" );
}

friendly_hummer_on_damage()
{
	self endon( "death" );
	self endon( "LISTEN_end_hummer_script" );
	
	fx = getfx( "FX_hummer_mg_ricochet" );
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		if ( attacker != level.player && random_chance( 0.5 ) )
		{
			v = VectorNormalize( AnglesToForward( self.angles ) );
			position = ( ( 64 * v ) + point );
			PlayFx( fx, position, -1*direction_vec );
		}
	}
}

friendly_hummer_mission_failed()
{
	self endon( "death" );
	self endon( "LISTEN_end_hummer_script" );
	self endon( "LISTEN_end_hummer_mission_failed" );

	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		if ( compare( attacker, level.player ) )
			break;
			
	}
	_mission_failed( "@PARIS_AC130_MISSION_FAIL_FRIENDLY_KILLED" );
}

friendly_hummer_add_turret_target( target ) 
{
	if ( !IsDefined( target ) )
		return;
	if ( IsDefined( target.script_team ) && target.script_team == "allies" )
		return;
		
	self.script_turret_targets = array_removedead( self.script_turret_targets );
	self.script_turret_targets = array_removeundefined( self.script_turret_targets );
	self.script_turret_targets = add_unique_to_array( self.script_turret_targets, target );
}

friendly_hummer_fire_mg()
{
	self endon( "death" );
	self endon( "LISTEN_end_hummer_script" );
	self endon( "LISTEN_hummer_end_fire_mg" );
	
	turret = self.mgturret[ 0 ];
	Assert( IsDefined( turret ) );
	turret SetMode( "manual_ai" );
	
	delay = 0.05;
	focus_time = 1.0;
	
	for ( ; ; )
	{
		self.script_turret_targets = array_removedead( self.script_turret_targets );
		self.script_turret_targets = array_removeundefined( self.script_turret_targets );
	
		target = getClosest( self.origin, self.script_turret_targets );
		_delay = ter_op( IsDefined( target ), delay, 0.05 );
		elapsed = 0;
		
		while ( elapsed < focus_time && IsDefined( target ) && IsAlive( target ) )
		{
			turret SetTargetEntity( target );
			start = turret GetTagOrigin( "tag_flash" );
			end = ter_op( target compare_value( "team", "axis" ), target.origin + ( 0, 0, 64 ), target.origin ) + random_vector( -64, 64 );
			MagicBullet( "minigun_hummer_ac130", start, end );
			
			elapsed += _delay;
			wait _delay;
		}
		wait _delay;
	}
}

friendly_hummer_slide( node )
{
	Assert( IsDefined( node ) );
	
	self endon( "death" );
	self endon( "LISTEN_end_hummer_script" );
	
	node waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	fx = getfx( "FX_hummer_dust_slide" );
	position = self GetTagOrigin( "tag_wheel_back_left" );
	forward = ( 0, 0, 1 );
	PlayFX( fx, position, forward );
	position = self GetTagOrigin( "tag_wheel_back_right" );
	PlayFX( fx, position, forward );
}

friendly_hummer_teleport_and_load( passengers )
{
	Assert( IsDefined( passengers ) );
	
	foreach ( guy in passengers )
	{
		guy notify( "enteredvehicle" );
        self maps\_vehicle_aianim::guy_enter( guy, false );
	}
}

friendly_hummer_set_default()
{
	self notify( "LISTEN_end_hummer_script" );
	
	if ( IsDefined( self.mgturret ) && IsDefined( self.mgturret[ 0 ] ) )
		self.mgturret[ 0 ] ClearTargetEntity();
	self ClearTurretTarget();
	
	if ( IsDefined( self.riders ) )
		foreach ( guy in self.riders )
		{
			if( IsDefined( guy ) && IsDefined( guy.script_startingposition ) && guy.script_startingposition == 4 )
				guy Delete();
		}
}

friendly_hummer_jolt()
{
	self endon( "LISTEN_end_hummer_script" );
	
}

// *************************************
// FRIENDLY F15
// *************************************

friendly_f15_init()
{
	self.f15_path = get_connected_ents( self.target );
	self.f15_current_node = 1;
	self.f15_attached_planes = [];
	
	self ThermalDrawEnable();
	self SetCanDamage( false ); 
	self thread friendly_f15_play_afterburner();
	self thread friendly_f15_track_next_node_in_path();
	self thread friendly_f15_monitor_rumble();
}

friendly_f15_init_cheap()
{
	self.f15_path = get_connected_ents( self.target );
	self.f15_current_node = 1;
	self.f15_attached_planes = [];
	
	self ThermalDrawEnable();
	self DontCastShadows();
	self thread friendly_f15_track_next_node_in_path();
	self thread friendly_f15_monitor_rumble();
	self ent_flag_clear( "contrails" );
}

friendly_f15_init_fake()
{
	self ThermalDrawEnable();
	self thread vehicle_scripts\_f15::playConTrail();
	self thread fake_jet_rumble( "script_vehicle_f15_low" );
}

friendly_f15_track_next_node_in_path()
{
	self endon( "death" );
	
	foreach( i, node in self.f15_path )
	{
		if ( i > 0 )
		{
			node waittill( "trigger" );
			self.f15_current_node = i;
		}
	}
}

friendly_f15_shoot_mg( time, section, look_ahead )
{
	self endon( "death" );
	
	time = gt_op( time, 0.05 );
	section = ter_op( IsDefined( section ), section, "default" );
	look_ahead = gt_op( look_ahead, 1 );
	 
	r_offset = ( 76,-74, 20 );
	l_offset = ( 76, 74, 20 );
	
	r_offset_m = ( 76,-74, 25 );//lower for missile
	l_offset_m = ( 76, 74, 25 );
	
	delay = 0.05;
	elapsed = 0;
	
	fx = getfx( ter_op( section == "ac130", "FX_jet_20mm_tracer_ac130", "FX_jet_20mm_tracer" ) );
	
	while( elapsed < time )
	{
		left = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, l_offset );
		current_node = self.f15_current_node;
		current_node += ter_op( current_node >= self.f15_path.size - look_ahead, 0, look_ahead ); 
		angles = ter_op( section == "ac130",self.angles, self.f15_path[ current_node ].angles );
		fwd = AnglesToForward( angles );
		PlayFX( fx, left, fwd );
		wait delay;
		right = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, r_offset );
		current_node = self.f15_current_node;
		current_node += ter_op( current_node >= self.f15_path.size - look_ahead, 0, look_ahead ); 
		angles = ter_op( section == "ac130",self.angles, self.f15_path[ current_node ].angles );
		fwd = AnglesToForward( angles );
		PlayFX( fx, right, fwd );
		wait delay;
		elapsed += 2 * delay;
	}
}

friendly_f15_shoot_mg_until_target_dead( target, section, look_ahead )
{
	self endon( "death" );
	
	Assert( IsDefined( target ) );
	
	section = ter_op( IsDefined( section ), section, "default" );
	look_ahead = gt_op( look_ahead, 1 );
	 
	r_offset = ( 76,-74, 20 );
	l_offset = ( 76, 74, 20 );
	
	r_offset_m = ( 76,-74, 25 );//lower for missile
	l_offset_m = ( 76, 74, 25 );
	
	delay = 0.05;
	elapsed = 0;
	
	fx_name = ter_op( section == "ac130", "FX_jet_20mm_tracer_ac130", "FX_jet_20mm_tracer" );
	fx = getfx( fx_name );
	
	while( IsDefined( target ) )
	{
		left = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, l_offset );
		current_node = self.f15_current_node;
		current_node += ter_op( current_node >= self.f15_path.size - look_ahead, 0, look_ahead ); 
		angles = ter_op( section == "ac130",self.angles, self.f15_path[ current_node ].angles );
		fwd = AnglesToForward( angles );
		PlayFX( fx, left, fwd );
		wait delay;
		elapsed += delay;
		
		if ( IsDefined( target ) )
		{
			right = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, r_offset );
			current_node = self.f15_current_node;
			current_node += ter_op( current_node >= self.f15_path.size - look_ahead, 0, look_ahead ); 
			angles = ter_op( section == "ac130",self.angles, self.f15_path[ current_node ].angles );
			fwd = AnglesToForward( angles );
			PlayFX( fx, left, fwd );
			wait delay;
			elapsed += delay;
		}
	}
}

friendly_f15_fake_shoot_mg()
{
	self endon( "death" );
	
	r_offset 	= ( 76,-74, 20 );
	l_offset 	= ( 76, 74, 20 );
	fx 			= getfx( "FX_jet_20mm_tracer_ac130" );
	
	for ( ; ; wait 0.05 )
	{
		left = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, l_offset );
		fwd = AnglesToForward( self.angles );
		PlayFX( fx, left, fwd );
		wait 0.05;
		right = maps\paris_ac130_slamzoom::get_world_relative_offset( self.origin, self.angles, r_offset );
		fwd = AnglesToForward( self.angles );
		PlayFX( fx, right, fwd );
	}
}

friendly_f15_play_afterburner()
{
	self endon( "death" );
	
	afterburner_nodes = get_ents_from_array( "afterburner", "script_noteworthy", self.f15_path );
	
	foreach ( node in afterburner_nodes )
	{
		node waittill( "trigger" );
		
		fx = getfx( "FX_jet_afterburner_ignite" );	
		PlayFxOnTag( fx, self, "tag_engine_right" );
		PlayFxOnTag( fx, self, "tag_engine_left" );
		fx = getfx( "FX_jet_smoke_trail_quick" );
		PlayFxOnTag( fx, self, "tag_engine_right" );
		PlayFxOnTag( fx, self, "tag_engine_left" );
	}
}

friendly_f15_fake_play_afterburner( delay )
{
	self endon( "death" );
	
	delay = gt_op( delay, 0.05 );
	
	wait delay;
	
	if ( !IsDefined( self ) )
		return;
		
	fx = getfx( "FX_jet_afterburner_ignite" );	
	PlayFxOnTag( fx, self, "tag_engine_right" );
	PlayFxOnTag( fx, self, "tag_engine_left" );
	fx = getfx( "FX_jet_smoke_trail_quick" );
	PlayFxOnTag( fx, self, "tag_engine_right" );
	PlayFxOnTag( fx, self, "tag_engine_left" );
}

friendly_f15_fake_sonic_boom( point, sound )
{
	Assert( IsDefined( point ) );
	
	self endon( "death" );
	
	sound = ter_op( IsDefined( sound ), sound, "veh_paris_ac130_jet_sonic_boom" );

	self thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
	waittill_ent_in_range_of_point( self, point, 64.0 );
	level thread play_sound_in_space( sound, point );
}

friendly_f15_sonic_boom( sound )
{
	self endon( "death" );
	
	sound = ter_op( IsDefined( sound ), sound, "veh_paris_ac130_jet_sonic_boom" );
	sonic_boom_nodes = get_ents_from_array( "sonic_boom", "script_noteworthy", self.f15_path );
	
	foreach ( node in sonic_boom_nodes )
		self thread friendly_f15_play_sound_node( node, sound );
	self thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
}

friendly_f15_play_sound_node( node, sound )
{
	Assert( IsDefined( node ) );
	Assert( IsDefined( sound ) );
	
	self endon( "death" );
	
	node waittill( "trigger" );
	node play_sound_in_space( sound );
}

friendly_f15_monitor_rumble()
{
	self endon( "death" );
	
	rumblestruct = level.vehicle_rumble[ "script_vehicle_f15_low" ];
	
	for ( ; ; )
	{
		if ( IsDefined( self.rumbletrigger ) )
		{
			self.rumbletrigger waittill( "trigger" );
			if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
			{
				wait 0.1;
				continue;
			}
	
			while ( level.player IsTouching( self.rumbletrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
			{
				if ( dsq_lt( level.ac130player.origin, self.origin, self.rumble_radius * 0.75 ) )
					flag_set( "FLAG_ac130_rumble" );
				wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
			}
		}
		else
			wait 0.05;
	}
}

friendly_f15_delete_on_path_end()
{
	self endon( "death" );
	
	if ( self.f15_path.size - 1 > 0 )
		self.f15_path[ self.f15_path.size - 1 ] waittill( "trigger" );
	else
		self waittill( "reached_dynamic_path_end" );
		
	foreach ( plane in self.f15_attached_planes )
	{
		if ( IsDefined( plane ) )
		{
			StopFXOnTag( getfx( "FX_f15_fake" ), plane, "tag_origin" );
			plane Delete();
		}
	}
	
	if ( IsDefined( self.f15_parent ) )
		self.f15_parent Delete();
		
	self stop_loop_sound_on_entity( "veh_f15_dist_loop" );
	self Delete();
	self notify( "death" );
}

friendly_f15_fake_delete( time )
{
	if ( !IsDefined( self ) )
		return;
	time = gt_op( time, 0.05 );
	wait time;
	if ( !IsDefined( self ) )
		return;
	self notify( "death" );
	self notify( "kill_rumble_forever" );
	if ( Isdefined( self.tag1 ) )
		self.tag1 Delete();
	if ( Isdefined( self.tag2 ) )
		self.tag2 Delete();
	if ( IsDefined( self.rumbletrigger ) )
		self.rumbletrigger Delete();
	wait 0.05;
	if ( !IsDefined( self ) )
		return;
	self Delete();
}

// *************************************
// FRIENDLY A10
// *************************************

friendly_a10_init()
{
	self.a10_path = get_connected_ents( self.target );
	self.a10_current_node = 1;
	
	self ThermalDrawEnable();
	self SetCanDamage( false );
	self thread friendly_a10_monitor_rumble(); 
}

friendly_a10_sonic_boom( sound )
{
	self endon( "death" );
	
	sound = ter_op( IsDefined( sound ), sound, "veh_paris_ac130_jet_sonic_boom" );
	sonic_boom_nodes = get_ents_from_array( "sonic_boom", "script_noteworthy", self.a10_path );
	
	foreach ( node in sonic_boom_nodes )
		self thread friendly_a10_play_sound_node( node, sound );
}

friendly_a10_play_sound_node( node, sound )
{
	Assert( IsDefined( node ) );
	Assert( IsDefined( sound ) );
	
	self endon( "death" );
	
	node waittill( "trigger" );
	node play_sound_in_space( sound );
}

friendly_a10_monitor_rumble()
{
	self endon( "death" );
	
	rumblestruct = level.vehicle_rumble[ "script_vehicle_a10_warthog" ];
	
	for ( ; ; )
	{
		if ( IsDefined( self.rumbletrigger ) )
		{
			self.rumbletrigger waittill( "trigger" );
			if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
			{
				wait 0.1;
				continue;
			}
	
			while ( level.player IsTouching( self.rumbletrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
			{
				if ( dsq_lt( level.ac130player.origin, self.origin, self.rumble_radius * 0.75 ) )
					flag_set( "FLAG_ac130_rumble" );
				wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
			}
		}
		else
			wait 0.05;
	}
}

friendly_a10_delete_on_path_end()
{
	self endon( "death" );
	
	if ( self.a10_path.size - 1 > 0 )
		self.a10_path[ self.a10_path.size - 1 ] waittill( "trigger" );
	else
		self waittill( "reached_dynamic_path_end" );
	self Delete();
	self notify( "death" );
}

// *************************************
// Enemy truck_a
// *************************************

enemy_barges_move( barges, speed )
{
    Assert( IsDefined( barges ) && IsArray( barges ) );
    Assert( IsDefined( speed ) );
    
    Assert( IsDefined( barges[ 0 ].target ) );
    ent_path_list = get_connected_ents( barges[ 0 ].target );
    Assert( IsDefined( ent_path_list ) && IsArray( ent_path_list ) );
    
    tag_origin = Spawn( "script_model", barges[ 0 ].origin );
    tag_origin SetModel( "tag_origin" );
    tag_origin.angles = VectorToAngles( ent_path_list[ 0 ].origin - barges[ 0 ].origin );
    Assert( IsDefined( barges[ 0 ].script_noteworthy ) );
    tag_origin.targetname = barges[ 0 ].script_noteworthy; 
    
    tag_origin endon( "death" );
    
    foreach ( barge in barges )
        barge LinkTo( tag_origin, "tag_origin" );
        
    i = 0;
    speed = ter_op( speed <= 0, 100.0, speed ); // radiant units / sec
    
    while ( i < ent_path_list.size )
    {
        dist = Distance2D( tag_origin.origin, ent_path_list[ i ].origin );
        time = dist / speed;
        tag_origin MoveTo( ent_path_list[ i ].origin, time );
        angles = VectorToAngles( ent_path_list[ i ].origin - tag_origin.origin );
        tag_origin RotateTo( angles, time );
        wait ( time - 0.05 );
        i++; 
    }
}

enemy_barge_a_1_on_damage()
{
    self endon( "death" );
    
	self.health = 100000;
	self SetCanDamage( true );
	
	min_damage = 500;
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage );
		
		if ( damage > min_damage )
			break;
	}
	
	// fx
	
	fx = getfx( "FX_barge_a_explosion" );
    pos = self.origin;
    dir = ( 0, 0, 1 );
            
    PlayFX( fx, pos, dir );
    
	Assert( IsDefined( self.script_noteworthy ) );
	tag_origin = GetEnt( self.script_noteworthy, "targetname" );
	
	if ( IsDefined( tag_origin ) )
	    tag_origin Delete();
	
	// anim
	
	self Hide();
    self NotSolid();
    damaged_model = Spawn( "script_model", self.origin );
    damaged_model.angles = ( self.angles[ 0 ], self.angles[ 1 ] - 90, self.angles[ 2 ] ); 
	damaged_model SetModel( "ac_prs_enm_barge_a_1_dam_animated" );
	damaged_model.animname = "barge_a";
	damaged_model maps\_anim::setanimtree();
	damaged_model maps\_anim::anim_single( [ damaged_model ], "paris_ac130_barge_sink" );
	
	wait 5.0;
	
	damaged_model Delete();
	self Delete();
}

enemy_barge_a_2_on_damage()
{
    self endon( "death" );
    
	self.health = 100000;
	self SetCanDamage( true );
	
	min_damage = 500;
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
		self waittill( "damage", damage );
		
		if ( damage > min_damage )
			break;
	}
	
	// fx
	
	fx = getfx( "FX_barge_a_explosion" );
    pos = self.origin;
    dir = ( 0, 0, 1 );
            
    PlayFX( fx, pos, dir );
    
	Assert( IsDefined( self.script_noteworthy ) );
	tag_origin = GetEnt( self.script_noteworthy, "targetname" );
	
	if ( IsDefined( tag_origin ) )
	    tag_origin Delete();
	
	// anim
	
	self Hide();
    self NotSolid();
    damaged_model = Spawn( "script_model", self.origin );
    damaged_model.angles = ( self.angles[ 0 ], self.angles[ 1 ] - 90, self.angles[ 2 ] ); 
	damaged_model SetModel( "ac_prs_enm_barge_a_2_dam_animated" );
	damaged_model.animname = "barge_a";
	damaged_model maps\_anim::setanimtree();
	damaged_model maps\_anim::anim_single( [ damaged_model ], "paris_ac130_barge_sink" );
	
	wait 5.0;
	
	damaged_model Delete();
	self Delete();
}

enemy_missile_boat_a_move( speed )
{
    Assert( IsDefined( speed ) );
    
    self endon( "death" );
    
    Assert( IsDefined( self.target ) );
    ent_path_list = get_connected_ents( self.target );
    Assert( IsDefined( ent_path_list ) && IsArray( ent_path_list ) );
        
    i = 0;
    speed = ter_op( speed <= 0, 100.0, speed ); // radiant units / sec
    
    while ( i < ent_path_list.size )
    {
        dist = Distance2D( self.origin, ent_path_list[ i ].origin );
        time = dist / speed;
        self MoveTo( ent_path_list[ i ].origin, time );
        angles = VectorToAngles( ent_path_list[ i ].origin - self.origin );
        self RotateTo( ( angles[ 0 ], angles[ 1 ] - 90, angles[ 2 ] ), time );
        wait ( time - 0.05 );
        i++; 
    }
}

enemy_missile_boat_a_on_damage()
{
    self endon( "death" );
    
	self.health = 100000;
	self SetCanDamage( true );
	
	min_damage = 500;
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
		self waittill( "damage", damage );
		
		if ( damage > min_damage )
			break;
	}
	
    // fx
    
    fx = getfx( "FX_missile_boat_a_explosion" );
    pos = self.origin;
    dir = ( 0, 0, 1 );
   
    PlayFX( fx, pos, dir );

    self.animname = "missle_boat_a";
	self maps\_anim::setanimtree();
	self maps\_anim::anim_single( [ self ], "paris_ac130_ship_sink" );
}

enemy_truck_a_drive( speed, delete_on_finish )
{
    Assert( IsDefined( speed ) );
    Assert( IsDefined( delete_on_finish ) );
    
    self endon( "death" );
    
    Assert( IsDefined( self.target ) );
    ent_path_list = get_connected_ents( self.target );
    Assert( IsDefined( ent_path_list ) && IsArray( ent_path_list ) );
    
    // Align truck to path
    
    i = 0;
    speed = ter_op( speed <= 0, 100.0, speed ); // radiant units / sec
    
    while ( i < ent_path_list.size )
    {         
        dist = Distance2D( self.origin, ent_path_list[ i ].origin );
        time = dist / speed;
        self MoveTo( ent_path_list[ i ].origin, time );
        angles = VectorToAngles( ent_path_list[ i ].origin - self.origin );
        self RotateTo( ( angles[ 2 ], angles[ 1 ] - 90, -1*angles[ 0 ] ), time );
        wait ( time - 0.05 );
        i++;   
    }
    
    if ( delete_on_finish )
        self Delete();
}

enemy_truck_a_on_damage()
{ 
    self endon( "death" );
    
	self.health = 100000;
	self SetCanDamage( true );
	
	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	self waittill( "damage" );
	
    // fx
    
    fx = getfx( "FX_truck_a" );
    pos = self.origin;
    dir = ( 0, 0, 1 );
    
    PlayFX( fx, pos, dir );
    
    fx = getfx( "FX_truck_a_fire_trail" );
    
    PlayFX( fx, pos, dir );
    
    // swap
    
    damaged_model = Spawn( "script_model", self.origin );
    damaged_model SetModel( "test_box" );
    if ( IsDefined( self.angles ) )
        damaged_model.angles = self.angles;
    self Delete();  
}

// *************************************
// Enemy maz_a
// *************************************

enemy_maz_a_drive( speed, delete_on_finish )
{
    Assert( IsDefined( speed ) );
    Assert( IsDefined( delete_on_finish ) );
    
    self endon( "death" );
    
    Assert( IsDefined( self.target ) );
    ent_path_list = get_connected_ents( self.target );
    Assert( IsDefined( ent_path_list ) && IsArray( ent_path_list ) );
    
    // Align truck to path
    
    i = 0;
    speed = ter_op( speed <= 0, 100.0, speed ); // radiant units / sec
    
    while ( i < ent_path_list.size )
    {
        dist = Distance2D( self.origin, ent_path_list[ i ].origin );
        time = dist / speed;
        time_adjustment = time / 10;
        self MoveTo( ent_path_list[ i ].origin, time );
        angles = VectorToAngles( ent_path_list[ i ].origin - self.origin );
        self RotateTo( ( angles[ 0 ], angles[ 1 ] + 90, angles [ 2 ] ), time - time_adjustment );
        wait ( time - 0.05 );
        i++;   
    }
    
    if ( delete_on_finish )
        self Delete();
}

enemy_maz_a_on_damage()
{ 
    self endon( "death" );
    
	self.health = 100000;
	self SetCanDamage( true );
	
	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	self waittill( "damage" );
	
    // fx
    
    fx = getfx( "FX_truck_a" );
    pos = self.origin;
    dir = ( 0, 0, 1 );
    
    PlayFX( fx, pos, dir );
    
    fx = getfx( "FX_truck_a_fire_trail" );
    
    PlayFX( fx, pos, dir );
    
    // swap
    
    damaged_model = Spawn( "script_model", self.origin );
    damaged_model SetModel( "test_box" );
    if ( IsDefined( self.angles ) )
        damaged_model.angles = self.angles;
    self Delete();  
}

// *************************************
// ENEMY BTR
// *************************************

enemy_btr_init( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self godon();
	
	self set_key( value, key );
	
	self.script_btr_passenger_callbacks_on_unload = [];
	
	self ThermalDrawEnable();
	self thread enemy_btr_on_damage();
	self thread enemy_btr_monitor_ac130_fire();
}

enemy_btr_on_damage()
{
	self endon( "death" );
	
	self.health = 10000;

	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self.health = 10000;
	}
}

enemy_btr_monitor_ac130_fire()
{
	self endon( "death" );

	shots_to_kill_40mm = 1;
	shots_from_40mm = 0;
	
    for ( ; ; )
    {
    			  // waittill( "projectile_impact", weapon_name, position, radius );
        level.player waittill( "projectile_impact", weapon_name, position );
        
        range = -1;
        
        switch ( weapon_name )
        {
            case "ac130_40mm_alt2":
                range = 320;
                break;
            case "ac130_105mm_alt2":
                range = 512;
                break;
        	default:
        		continue;
        }
        
        if ( dsq_2d_lt( self.origin, position, range ) )
        {
        	kill_self = false;
        	
        	switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	                shots_from_40mm++;
	                break;
	            case "ac130_105mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
	                kill_self = true;
	                break;
	        }
			
			if ( shots_from_40mm >= shots_to_kill_40mm )
				kill_self = true;
				
			if ( kill_self )
			{
            	self godoff();
				self DoDamage( 10000, ( 0, 0, 0 ), level.player );
				return;
			}
        }
    }
}

enemy_btr_randomly_shoot_at_targets( targets )
{
	Assert( IsDefined( targets ) && IsArray( targets ) && targets.size > 0 );
	
	self endon( "death" );
	self endon( "LISTEN_btr_end_randomly_shoot_at_targets" );
	
	delay = 3.0;
	
	for ( ; ; )
	{
		targets = array_removeundefined( targets );
		targets = array_removedead( targets );
		
		if ( targets.size > 0 )
		{
			self SetTurretTargetEnt( targets[ RandomInt( targets.size ) ] );
			wait delay;
		}
		wait 0.05;
	}
}

// Alt: Doesn't Cleanup spanwers
enemy_btr_load_passengers_alt( passenger_spawner, num_passengers, _teleport )
{
    Assert( IsDefined( passenger_spawner ) );
    
    self endon( "death" );
    
    // Spawn passengers
	
	max_passengers = 4;
	num_passengers = clamp_op( num_passengers, 1, max_passengers );
	_teleport = ter_op( IsDefined( _teleport ), _teleport, false );
    passengers = [];
    _origin = passenger_spawner.origin;
		
	for ( i = 0; i < num_passengers; i++ )
	{
		passenger_spawner.count = 1;
		passenger_spawner.script_startingposition = i;
		passenger_spawner.origin = ( _origin[ 0 ], _origin[ 1 ] + 64.0, _origin[ 2 ] );
		
		if ( passenger_spawner compare_value( "script_drone", 1 ) )
		{
			passengers[ i ] = passenger_spawner SpawnDrone();
			passengers[ i ] UseAnimTree( level.scr_animtree[ "drone" ] );
			passengers[ i ] ThermalDrawEnable();
		}
		else
		{
			passengers[ i ] = passenger_spawner StalingradSpawn();
			spawn_failed( passengers[ i ] );
		}
		wait 0.05;
	}
			
	if ( _teleport )
	{
		foreach ( guy in passengers )
		{
			guy notify( "enteredvehicle" );
	        self maps\_vehicle_aianim::guy_enter( guy, false );
		}
	}
	else
		self vehicle_load_ai( passengers );
	
	self.script_btr_passengers = passengers;
}

enemy_btr_unload()
{
	self endon( "death" );
	
	foreach ( guy in self.script_btr_passengers )
		foreach ( callback in self.script_btr_passenger_callbacks_on_unload )
			if ( IsDefined( guy ) )
				guy thread [[ callback ]]();
				
	self vehicle_unload();
}

enemy_btr_set_passenger_callbacks_on_unload( callbacks )
{
	Assert( IsDefined( callbacks ) && IsArray( callbacks ) );
	self.script_btr_passenger_callbacks_on_unload = callbacks;
}

// *************************************
// ENEMY T72
// *************************************

achieve_menage_a_trois( t72s )
{
	Assert( IsArray( t72s ) && IsDefined( t72s ) );
	
	if ( IsDefined( level.achieve_menage_a_trois ) && 
		 level.achieve_menage_a_trois )
		return;
		
	level.achieve_menage_a_trois 	= false;
	time_delta						= 0.25;
	time_stamps						= [ 0, 0, 0 ];
	
	for ( ; !level.achieve_menage_a_trois; wait 0.05 )
	{
		foreach ( t72 in t72s )
			if ( !IsDefined( t72 ) || level.achieve_menage_a_trois )
				return;
				
		foreach ( i, t72 in t72s )
			if ( time_stamps[ i ] == 0 && t72 ent_flag( "FLAG_t72_killed_by_105mm" ) )
				time_stamps[ i ] = GetTime();
				
		if ( time_stamps[ 1 ] != 0 && 
			 abs( time_stamps[ 0 ] - time_stamps[ 1 ] ) <= time_delta &&
			 abs( time_stamps[ 2 ] - time_stamps[ 1 ] ) <= time_delta )
			level.achieve_menage_a_trois = true;			
	}
	
	level.player player_giveachievement_wrapper( "MENAGE_A_TROIS" );
}

enemy_t72_init( value, key, shots_to_kill_40mm )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self ent_flag_init( "FLAG_t72_init" );
	self ent_flag_init( "FLAG_t72_killed_by_40mm" );
	self ent_flag_init( "FLAG_t72_killed_by_105mm" );
	
	self set_key( value, key );
	self.shots_to_kill_40mm = gt_op( shots_to_kill_40mm, 1 );

	self godon();
	
	self ThermalDrawEnable();
	self thread enemy_t72_on_damage();
	self thread enemy_t72_on_death();
	self thread enemy_t72_monitor_ac130_fire();
	
	self ent_flag_set( "FLAG_t72_init" );
}

enemy_t72_on_damage()
{
	self endon( "death" );
	
	self.health = 10000;
			
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );	
		self.health = 9999;
	}
}

enemy_t72_on_death()
{
	self waittill( "death" );
	if ( IsDefined( self ) )
	{
		self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 10 );
		StopFXOnTag( getfx( "FX_t72_damaged_smoke" ), self, "tag_deathfx" );
	}
}

enemy_t72_monitor_ac130_fire()
{
	self endon( "death" );

	shots_from_40mm = 0;
	
    for ( ; ; )
    {
    			  // waittill( "projectile_impact", weapon_name, position, radius );
        level.player waittill( "projectile_impact", weapon_name, position );
        
        range = -1;
        
        switch ( weapon_name )
        {
            case "ac130_40mm_alt2":
                range = 128;
                break;
            case "ac130_105mm_alt2":
                range = 512;
                break;
        	default:
        		continue;
        }
        
        if ( dsq_2d_lt( self.origin, position, range ) )
        {
        	kill_self = false;
        	
        	switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	                shots_from_40mm++;
	                break;
	            case "ac130_105mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
					self ent_flag_set( "FLAG_t72_killed_by_105mm" );
	                kill_self = true;
	                break;
	        }
			
			switch ( shots_from_40mm )
			{
				case 1:
					PlayFXOnTag( getfx( "FX_t72_damaged_smoke" ), self, "tag_deathfx" );
					break;
			}
			
			if ( shots_from_40mm >= self.shots_to_kill_40mm )
			{
				self ent_flag_set( "FLAG_t72_killed_by_40mm" );
				kill_self = true;
			}
				
			if ( kill_self )
			{
				StopFXOnTag( getfx( "FX_t72_damaged_smoke" ), self, "tag_deathfx" );
            	self godoff();
				self DoDamage( 10000, ( 0, 0, 0 ), level.player );
				self notify( "LISTEN_killed_by_player" );
			}
        }
    }
}

enemy_t72_randomly_shoot_canon_fake2( targets )
{
	Assert( IsDefined( targets ) && IsArray( targets ) );
	
	if ( !IsDefined( self ) )
		return;
	
	self notify( "LISTEN_end_t72_randomly_shoot_canon_fake2" );
	self endon( "death" );
	self endon( "LISTEN_end_t72_randomly_shoot_canon_fake2" );
	
	if ( IsDefined( self.target ) )
	{
		path = get_connected_ents( self.target );
		shoot_node = get_ents_from_array( "shoot", "script_noteworthy", path )[ 0 ];
		
		if ( IsDefined( shoot_node ) )
			shoot_node waittill( "trigger" );
	}
	
	while ( IsDefined( self ) )
	{
		// Do some scanning
		
		delay = 1.5;
		elapsed = 0;
		idle_time = 4.5;
		
		while ( IsDefined( self ) && elapsed < idle_time )
		{
			fwd = VectorNormalize( AnglesToForward( self.angles + ( 0, RandomFloatRange( -15, 15 ), 0 ) ) );
			target = self.origin + ( fwd * 1024 );
			self SetTurretTargetVec( target );
			elapsed += delay;
			wait delay;
		}
	
		if ( !IsDefined( self ) )
			return;
			
		// Acquire Real Target
		
		target = targets[ RandomInt( targets.size ) ].origin + 
				  ( RandomFloatRange( -512, 512 ), RandomFloatRange( -512, 512 ), RandomFloatRange( 128, 256 ) );
		self SetTurretTargetVec( target );
		
		wait RandomFloatRange( 3, 8 );
		
		start = self GetTagOrigin( "tag_flash" );
		end = start + AnglesToForward( self GetTagAngles( "tag_flash" ) ) * 10000;
		MagicBullet( "t72_125mm", start, end );
	}	
}

enemy_t72_randomly_shoot_canon_fake( target )
{
	Assert( IsDefined( target ) );
	
	if ( !IsDefined( self ) )
		return;
		
	self notify( "LISTEN_end_t72_randomly_shoot_canon_fake" );
	self endon( "death" );
	self endon( "LISTEN_end_t72_randomly_shoot_canon_fake" );
	
	self SetTurretTargetVec( target.origin );
	wait 0.5;
	
	start = self GetTagOrigin( "tag_flash" );
	end = start + AnglesToForward( self GetTagAngles( "tag_flash" ) ) * 10000;
	MagicBullet( "t72_125mm", start, end );
}

enemy_t72_shell_on_death()
{
	self waittill( "death" );
	if ( !IsDefined( self ) )
		return;
		
	fwd = ( 0, 0, 1 );
	up = ( 0, 0, 0 );
	
	if ( IsDefined( self.angles ) )
	{
		fwd = AnglesToForward( self.angles );
		up = AnglesToUp( self.angles );
	}
	PlayFX( getfx( "FX_t72_shell_hitting_building" ), self.origin, fwd, up );
}

enemy_t72_randomly_look_ahead()
{
	self endon( "death" );
	
	delay = 2.0;
	
	for ( ; ; )
	{
		forward = VectorNormalize( AnglesToForward( self.angles + ( 0, RandomFloatRange( -15, 15 ), 0 ) ) );
		target = self.origin + ( forward * 1024 );
		self SetTurretTargetVec( target );
		wait delay;
	}
}

enemy_t72_explode()
{
	self endon( "death" );
	
	ent_path_list = get_connected_ents( self.target );
	explode_node = get_ents_from_array( "explosion", "script_noteworthy", ent_path_list )[ 0 ];
	
	if ( IsDefined( explode_node ) )
	{
		explode_node waittill( "trigger" );
		
		fx = getfx( "FX_t72_explosion" );
		pos = self.origin;
		forward = ( 0, 0, 1 );
		PlayFX( fx, pos, forward );

		self godoff();
		wait 0.05;
		self DoDamage( 10000, self.origin );
		self notify( "death" );
	}
}

// *************************************
// ENEMY MI17
// *************************************

#using_animtree( "generic_human" );
enemy_mi17_init( value, key, mi17_state )
{
    Assert( IsDefined( value ) );
    Assert( IsDefined( key ) );

	mi17_state = ter_op( IsDefined( mi17_state ), mi17_state, "STATE_air" );
	
	self ent_flag_init( "FLAG_helicopter_init" );
	self ent_flag_init( "FLAG_helicopter_pilot_loaded" );
	self ent_flag_init( "FLAG_helicopter_passengers_loaded" );
	self ent_flag_init( "FLAG_helicopter_passengers_unloading" );
	self ent_flag_init( "FLAG_helicopter_passengers_unloaded" );
	self ent_flag_init( "FLAG_helicopter_drop_off_passengers" );
	self ent_flag_init( "FLAG_helicopter_instant_death" );
	self ent_flag_init( "FLAG_helicopter_instant_death_40mm" );
	self ent_flag_init( "FLAG_helicopter_instant_death_105mm" );
	self ent_flag_init( "FLAG_helicopter_die" );
	
	// STATEs
	// -- STATE_ground:          mi17 grounded, not doing anything
	// -- STATE_ground_loading:  Soldiers currently loading into mi17
	// -- STATE_air:             mi17 airborne, stationary or traveling
	// -- STATE_air_unloading:   Soldiers currently unloading from mi17
	
	switch( mi17_state )
	{
		case "STATE_ground":
		case "STATE_ground_loading":
		case "STATE_air":
		case "STATE_air_unloading":
			break;
		default:
			mi17_state = "STATE_ground";
			break;
	}
	
	self.script_mi17_state = mi17_state;
	self.script_mi17_passenger_callback_on_unload = [];
	self.mi17_path = get_connected_ents( self.target );
	self set_key( value, "script_noteworthy" );
	
	self ThermalDrawEnable();
	self thread enemy_mi17_on_damage();
	self thread enemy_mi17_on_death();
	self thread enemy_mi17_monitor_ac130_fire();
	
	self ent_flag_set( "FLAG_helicopter_init" );
}

enemy_mi17_init_cheap()
{
	self ent_flag_init( "FLAG_helicopter_init" );
	self ent_flag_init( "FLAG_helicopter_pilot_loaded" );
	self ent_flag_init( "FLAG_helicopter_passengers_loaded" );
	
	self.script_mi17_state = "STATE_air";
	
	self ThermalDrawEnable();
	self godon();
	self SetCanDamage( false );
	
	self ent_flag_set( "FLAG_helicopter_init" );
	self ent_flag_set( "FLAG_helicopter_passengers_loaded" );
}

enemy_mi17_init_linked( parent )
{
	Assert( IsDefined( parent ) );
	
	self.mi17_parent = parent;
	self.mi17_attached_helis = [];
	self.mi17_path = get_connected_ents( self.target );

	parent Hide();
	self LinkTo( parent );
	self ThermalDrawEnable();
	self SetCanDamage( false );
	self thread enemy_mi17_fake_delete_on_path_end();
}

enemy_mi17_attach_fake_helis( num_helis )
{
	num_helis = clamp_op( num_helis, 0, 3 );
	
	if ( num_helis == 0 )
		return;
	else
	{
		fwd = AnglesToForward( self.angles );
		right = AnglesToRight( self.angles );
		up = AnglesToUp( self.angles );
					// fwd, right, up
		offsets = [ [  -1024, -512,  96 ],
					[ -2048, -256, -96 ],
					[ -4096,  256,  32 ],
					[ -6144,  128, -32 ] ];
					  
		helis = [];
		
		for ( i = 0; i < num_helis; i++ )
		{
			helis[ i ] = Spawn( "script_model", self.origin + offsets[ i ][ 0 ] * fwd + offsets[ i ][ 1 ] * right + offsets[ i ][ 2 ] * up );
			helis[ i ].angles = self.angles + ( 0, 0, RandomFloatRange( -90, 90 ) );
			helis[ i ] SetModel( "vehicle_mi17_woodland_fly_cheap" );
			helis[ i ] ThermalDrawEnable();
			helis[ i ] NotSolid();
			helis[ i ] LinkTo( self, "tag_origin" );
		}
		self.mi17_attached_helis = helis;
	}
}

enemy_mi17_on_damage()
{
    self endon( "death" );
    self endon( "LISTEN_helicopter_end_on_damage" );
    
	self.health = 2 * self.healthbuffer;
	self SetCanDamage( true );
	
	min_damage_25mm 			= 1500;
	damage_recieved_by_player 	= 0;
	
	while( damage_recieved_by_player < min_damage_25mm )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self.health = 2 * self.healthbuffer;
		
		if ( compare( attacker, level.player ) && IsDefined( weapon ) )
		{
			switch ( weapon )
		    {
		    	case "ac130_25mm_alt2":
		    		damage_recieved_by_player += damage;
		    		break;
		        case "ac130_40mm_alt2":
		        	self ent_flag_set( "FLAG_helicopter_instant_death_40mm" );
		        	self ent_flag_set( "FLAG_helicopter_instant_death" );
					damage_recieved_by_player = 1500;
		            break;
		        case "ac130_105mm_alt2":
		        	self ent_flag_set( "FLAG_helicopter_instant_death_105mm" );
		        	self ent_flag_set( "FLAG_helicopter_instant_death" );
					damage_recieved_by_player = 1500;
		            break;
		    	default:
		    		continue;
		    }
		}
	}
	
	if ( Target_IsTarget( self ) )
    	Target_Remove( self );
	
	self ent_flag_set( "FLAG_helicopter_die" );
	
	if ( IsDefined( self.script_mi17_passengers ) )
	{
		foreach ( ai in self.script_mi17_passengers )
		{
		    if ( IsDefined( ai ) && IsAlive( ai ) )
		    {
		    	ai ai_disable_magic_bullet_shield();
		    	ai DoDamage( 10000, ai.origin, level.player );
			}
		    wait RandomFloatRange( 2.0, 3.0 );
		}
	}
}

enemy_mi17_on_death()
{
	self ent_flag_wait( "FLAG_helicopter_die" );
	self notify( "LISTEN_killed_by_player" );
		
	// Handle helicopter death and passenger deaths
	
	switch ( self.script_mi17_state )
	{
		case "STATE_ground":
			break;
		case "STATE_ground_loading":
			break;
		case "STATE_air":
			// Possible things to happen as the helicopter crashes
			// - 
			
			self notify( "LISTEN_helicopter_dying" );
			
			if ( !self ent_flag( "FLAG_helicopter_instant_death" ) )
			{
				self thread helicopter_crash_move();
				self waittill( "crash_done" );
			}
			
			if ( IsDefined( self.script_mi17_pilot ) )
			{
				self.script_mi17_pilot ai_disable_magic_bullet_shield();;
			    self.script_mi17_pilot notify( "death", level.player );
			    self.script_mi17_pilot Delete();
			}
	
			if ( self ent_flag( "FLAG_helicopter_passengers_unloaded" ) && 
			     IsDefined( self.script_mi17_passengers ) )
			{
				self.script_mi17_passengers = array_removedead( self.script_mi17_passengers );
				self.script_mi17_passengers = array_removeundefined( self.script_mi17_passengers );
		
				foreach ( ai in self.script_mi17_passengers )
				{
					ai ai_disable_magic_bullet_shield();
				    ai DoDamage( 10000, ai.origin );
				}
			}
			break;
		case "STATE_air_unloading":
			if ( !self ent_flag( "FLAG_helicopter_instant_death" ) )
			{
		    	self thread helicopter_crash_move();
				self waittill( "crash_done" );
			}
			break;
	}
	
	// **TODO: damage ent / ai in a given range of the explosion
	// **TODO: apply a physic force also, PhysicsExplosionSphere
	// **TODO: if only explosion effect, do not make random
	// **TODO: change to proper destroyed model
	
	// Play appropriate fx on death
	
	if ( !IsDefined( self ) )
		return;
	
	PlayFX( getfx( "FX_mi17_explosion" ), self.origin + ( 0, 0, -64 ) );
	PlayFX( getfx( "FX_40mm_metal_impact_a" ), self.origin + ( 0, 0, -64 ) );
	level thread play_sound_in_space( "scn_ac130_helicopter_exp", self.origin );
	if ( self ent_flag( "FLAG_helicopter_instant_death_40mm" ) )
		level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	if ( self ent_flag( "FLAG_helicopter_instant_death_105mm" ) )
		level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
	self notify( "death", level.player );
	self notify( "newpath" );
	self notify( "crash_done" );
	self Delete();
}

enemy_mi17_monitor_ac130_instant_death()
{
	self endon( "death" );
	
	while ( !self ent_flag( "FLAG_helicopter_instant_death" ) && !self ent_flag( "FLAG_helicopter_die" ) )
		wait 0.05;
	self ent_flag_set( "FLAG_helicopter_die" );
}

enemy_mi17_monitor_ac130_fire()
{
	self endon( "death" );
	
	self thread enemy_mi17_monitor_ac130_instant_death();
	
    for ( ; ; )
    {
    	level.player waittill ( "missile_fire", projectile, weapon_name ); 
        
        if ( IsDefined( projectile ) && IsDefined( weapon_name ) )
        {
        	switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	flags = [ "FLAG_helicopter_instant_death", "FLAG_helicopter_instant_death_40mm" ];
	            	self thread set_flags_delete_ent_in_range( projectile, 256, flags );
	                break;
	            case "ac130_105mm_alt2":
	            	flags = [ "FLAG_helicopter_instant_death", "FLAG_helicopter_instant_death_105mm" ];
	            	self thread set_flags_delete_ent_in_range( projectile, 256, flags );
	                break;
	        	default:
	        		continue;
	        }
	    }
    }
}

enemy_mi17_drop_off()
{
    self endon( "death" );
    self endon( "LISTEN_helicopter_dying" );
   
   	// Initialization + Loading Pilot / Passengers
   	
    self ent_flag_wait( "FLAG_helicopter_init" );
    self ent_flag_wait( "FLAG_helicopter_pilot_loaded" );
    self ent_flag_wait( "FLAG_helicopter_passengers_loaded" );
    
	thread gopath( self );

	// Unload at drop off point
	
	drop_off = get_ents_from_array( "drop_off", "targetname", self.mi17_path )[ 0 ];
	drop_off = ter_op( IsDefined( drop_off ), drop_off, get_ents_from_array( "drop_off", "script_noteworthy", self.mi17_path )[ 0 ] );
    
    waittill_ent1_in_range_of_ent2( self, drop_off, 32 );
    self Vehicle_SetSpeedImmediate( 0, 30, 30 );
    //self SetHoverParams( 0, 0, 0 );
	self ent_flag_wait_or_timeout( "FLAG_helicopter_drop_off_passengers", 2.0 );
	self.script_mi17_state = "STATE_air_unloading";
	self vehicle_unload();
    self ent_flag_set( "FLAG_helicopter_passengers_unloading" );
    
    // Do passenger callbacks
    
	foreach ( guy in self.script_mi17_passengers )
		if ( IsDefined( guy ) )
			foreach ( callback in self.script_mi17_passenger_callback_on_unload	)
				guy thread [[ callback ]]();
    			
	// script notify: 'jumpedout' - when ai comes down from rappel
	
	waittill_ents_notified_timeout( self.script_mi17_passengers, "jumpedout", 15 );
	self ent_flag_set( "FLAG_helicopter_passengers_unloaded" );
	self notify( "LISTEN_helicopter_passengers_unloaded" );
			
	wait 3; // wait for ropes to fall
	wait 5;
	
	next_node = getstruct( drop_off.target, "targetname" );
	speed = next_node get_key( "speed" );
	speed = ter_op( IsDefined( speed ), speed, 30 ); 
	self Vehicle_SetSpeed( speed, speed * 0.5, speed * 0.5 );
	
	self notify( "LISTEN_helicopter_resume_path" );
	self.script_mi17_state = "STATE_air";
	
	timeout = 30.0;
	
	self waittill_any_timeout( timeout, "reached_dynamic_path_end" );
	
	while ( within_fov_of_players( self.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
		wait 0.05;
	self Delete();
}

enemy_mi17_street_drop_off()
{
    self endon( "death" );
    self endon( "LISTEN_helicopter_dying" );
   
   	// Initialization + Loading Pilot / Passengers
   	
    self ent_flag_wait( "FLAG_helicopter_init" );
    self ent_flag_wait( "FLAG_helicopter_pilot_loaded" );
    self ent_flag_wait( "FLAG_helicopter_passengers_loaded" );
    
	thread gopath( self );

	// Unload at drop off point
	
	drop_off = get_ents_from_array( "_drop_off", "targetname", self.mi17_path )[ 0 ];
	drop_off = ter_op( IsDefined( drop_off ), drop_off, get_ents_from_array( "drop_off", "script_noteworthy", self.mi17_path )[ 0 ] );
    
    waittill_ent1_in_range_of_ent2( self, drop_off, 32 );
    self Vehicle_SetSpeedImmediate( 0, 30, 30 );
    //self SetHoverParams( 0, 0, 0 );
	self ent_flag_wait_or_timeout( "FLAG_helicopter_drop_off_passengers", 2.0 );
	self.script_mi17_state = "STATE_air_unloading";
	self vehicle_unload();
    self ent_flag_set( "FLAG_helicopter_passengers_unloading" );
    	
	// script notify: 'jumpedout' - when ai comes down from rappel
	
	waittill_ents_notified_timeout( self.script_mi17_passengers, "jumpedout", 15 );
	self ent_flag_set( "FLAG_helicopter_passengers_unloaded" );
	self notify( "LISTEN_helicopter_passengers_unloaded" );
	
	if ( IsDefined( self.script_mi17_passengers ) && IsArray( self.script_mi17_passengers ) )
	{
		self.script_mi17_passengers = array_removedead( self.script_mi17_passengers );
		self.script_mi17_passengers = array_removeundefined( self.script_mi17_passengers );
		
		foreach ( guy in self.script_mi17_passengers )
			guy thread ai_enemy_street_patrol_monitor_battle_line();
	}
			
	wait 3; // wait for ropes to fall
	wait 5;
	self Vehicle_SetSpeedImmediate( 30, 30, 30 );
	self notify( "LISTEN_helicopter_resume_path" );
	self.script_mi17_state = "STATE_air";
	
	timeout = 120.0;
	
	self waittill_any_timeout( timeout, "reached_dynamic_path_end" );
	
	while ( within_fov_of_players( self.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
		wait 0.05;
	self notify( "death", level.player );
	self Delete();
}

enemy_mi17_load_pilot( pilot_spawner )
{
    Assert( IsDefined( pilot_spawner ) );
    
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_helicopter_init" );
	
	if ( IsDefined( pilot_spawner ) )
	{
		// Spawn and load pilot
		
		pilot = undefined;
		
		if ( IsDefined( pilot_spawner.script_drone ) && pilot_spawner.script_drone )
		{
			pilot = pilot_spawner SpawnDrone();
			pilot UseAnimTree( level.scr_animtree[ "drone" ] );
			pilot ThermalDrawEnable();
		}
		else
		{
			pilot = pilot_spawner StalingradSpawn();
			spawn_failed( pilot );
		}
		
		Assert( IsDefined( pilot ) );
		
		self vehicle_load_ai( [ pilot ], true );
		
		// Store reference to pilot
		
		self.script_mi17_pilot = pilot;
	}

    pilot_spawner Delete();
    self ent_flag_set( "FLAG_helicopter_pilot_loaded" );
}

// Alt: Doesn't Cleanup spanwer
enemy_mi17_load_pilot_alt( pilot_spawner )
{
    Assert( IsDefined( pilot_spawner ) );
    
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_helicopter_init" );

	if ( IsDefined( pilot_spawner ) )
	{
		// Spawn and load pilot
		
		pilot_spawner.count = 1;
		pilot = undefined;
		
		if ( IsDefined( pilot_spawner.script_drone ) && pilot_spawner.script_drone )
		{
			pilot = pilot_spawner SpawnDrone();
			pilot UseAnimTree( level.scr_animtree[ "drone" ] );
			pilot ThermalDrawEnable();
		}
		else
		{
			pilot = pilot_spawner StalingradSpawn();
			spawn_failed( pilot );	
		}
		
		Assert( IsDefined( pilot ) );
		
		self vehicle_load_ai( [ pilot ], true );
		
		// Store reference to pilot
		
		self.script_mi17_pilot = pilot;
	}
    self ent_flag_set( "FLAG_helicopter_pilot_loaded" );
}

// Alt: Doesn't Cleanup spanwers
enemy_mi17_quick_load_passengers_alt( passenger_spawner, num_passengers )
{
    Assert( IsDefined( passenger_spawner ) );
    
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_helicopter_init" );
    self ent_flag_wait( "FLAG_helicopter_pilot_loaded" );
    
    // Spawn passengers
	
	num_passengers = gt_op( num_passengers, 1 );
    passengers = [];
    starting_position = 1;
    _origin = passenger_spawner.origin;
		
	for ( i = 0; i < num_passengers; i++ )
	{
		passenger_spawner.count = 1;
		passenger_spawner.script_startingposition = starting_position;
		passenger_spawner.origin = ( _origin[ 0 ], _origin[ 1 ] + 64.0, _origin[ 2 ] );
		
		if ( passenger_spawner compare_value( "script_drone", 1 ) )
		{
			passengers[ i ] = passenger_spawner SpawnDrone();
			passengers[ i ] UseAnimTree( level.scr_animtree[ "drone" ] );
			passengers[ i ] ThermalDrawEnable();
		}
		else
		{
			passengers[ i ] = passenger_spawner StalingradSpawn();
			spawn_failed( passengers[ i ] );
		}
		starting_position++;
		wait 0.05;
	}
	
	self vehicle_load_ai( passengers );
	
	self.script_mi17_passengers = passengers;
        
	self ent_flag_set( "FLAG_helicopter_passengers_loaded" );
}

enemy_mi17_load_passengers( passenger_spawners )
{
    Assert( IsDefined( passenger_spawners ) && IsArray( passenger_spawners ) );
    
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_helicopter_init" );
    self ent_flag_wait( "FLAG_helicopter_pilot_loaded" );
		
	// Spawn passengers
	
    passengers = [];
		
	foreach ( i, spawner in passenger_spawners )
	{
		passengers[ i ] = spawner StalingradSpawn();
		spawn_failed( passengers[ i ] );
	}
	
	waittillframeend;
		
	// Make passengers move to mi17
		
    passenger_nodes = [];
    
	foreach ( i, passenger in passengers )
	{
		passenger thread ai_enemy_passenger_monitor_vehicle( self );
		
		if ( IsDefined( passenger.script_noteworthy ) )
		{
			node = GetNode( passenger.script_noteworthy + "_dest", "targetname" );
				
			if ( IsDefined( node ) )
			{
				passenger_nodes[ i ] = node;
				node.script_is_occupied = "1"; 
				passenger maps\_spawner::go_to_node_set_goal_node( node );
					
				if ( IsDefined( passenger.script_node_occupied ) )
					self.script_node_occupied.script_is_occupied = "0";
						
				self.script_node_occupied = node;
			}
			else // should find a unoccupied node close to mi17 and go to that
				continue;
		}
	}
		
	// Wait till the passengers move into position
		
	timeout = 20;
	range = 16.0;
	
	foreach ( i, passenger in passengers )
	{
		if ( IsAlive( passenger ) && IsDefined( passenger_nodes[ i ] ) )
		{
			thread notify_ai_when_in_range_of_ent( passenger, passenger_nodes[ i ], range, "LISTEN_ai_goal_reached" );
			/*
			_flag = "FLAG_passenger_" + i; 
			self ent_flag_init( _flag );
			self thread set_flag_ai_in_2d_range_of_ent_timeout( passenger, passenger_nodes[ i ], range, _flag, timeout );
			*/
		}	
	}
	
	waittill_ents_notified_timeout( passengers, "LISTEN_ai_goal_reached", timeout );
	
	// ** Animations maybe needed for entering mi17
		
	// Remove dead ai / or ai who timed out from the passenger list
	/*	**TODO: Fix this so it checks properly
	passengers_to_remove = [];
		
	foreach ( i , passenger in passengers )
	{
		if ( !( self ent_flag_exist( "FLAG_ent_LISTEN_ai_goal_reached" ) ) || !( self ent_flag( "FLAG_ent_LISTEN_ai_goal_reached" ) ) )
			passengers_to_remove[ passengers_to_remove.size ] = passenger;
	}
		
	passengers = array_remove_array( passengers, passengers_to_remove );*/
	passengers = array_removeDead( passengers );
	passengers = array_removeundefined( passengers );
		
	if ( passengers.size > 0 )
	{
	    self.script_mi17_state = "STATE_ground_loading";
		self vehicle_load_ai( passengers );
		
		// Set passengers to loaded
		
		foreach( passenger in passengers )
		{
		    if ( passenger ent_flag_exist( "FLAG_ai_loaded_in_vehicle" ) )
		        passenger ent_flag_set( "FLAG_ai_loaded_in_vehicle" );
		}	
		
		// Store reference to passengers
				
		self.script_mi17_passengers = passengers;
	}

    // Clean up spawners
    
    foreach ( spawner in passenger_spawners )
        spawner Delete();
        	
    self ent_flag_set( "FLAG_helicopter_passengers_loaded" );
}

enemy_mi17_gopath_and_die( delay )
{
    self endon( "death" );
	
	self ent_flag_wait( "FLAG_helicopter_init" );
	self ent_flag_wait( "FLAG_helicopter_pilot_loaded" );
	self ent_flag_wait( "FLAG_helicopter_passengers_loaded" );
	
	wait RandomFloat( gt_op( delay, 0 ) );
	self.script_mi17_state = "STATE_air";
	thread gopath( self );
	self thread enemy_mi17_delete_on_path_end();
	
	path = get_connected_ents( self.target );
	death_node = get_ents_from_array( "ready_to_die", "script_noteworthy", path )[ 0 ];
	
	if ( IsDefined( death_node ) )
	{
		death_node waittill( "trigger" );
		self notify( "LISTEN_helicopter_ready_to_die" );
	}
	
	while ( within_fov_of_players( self.origin, cos( GetDvarFloat( "cg_fov" ) ) ) )
		wait 0.05;
	self Delete();
	self notify( "death" );
}

enemy_mi17_delete_on_path_end()
{
	self endon( "death" );
	self waittill( "reached_dynamic_path_end" );
	
	if ( IsDefined( self.script_mi17_pilot ) )
	{
		self.script_mi17_pilot ai_disable_magic_bullet_shield();
		self.script_mi17_pilot notify( "death", level.player );
		self.script_mi17_pilot Delete();
	}
	
	if ( IsDefined( self.script_mi17_passengers ) )
	{
		foreach ( ai in self.script_mi17_passengers )
		{
		    if ( IsDefined( ai ) )
		    {
		    	ai ai_disable_magic_bullet_shield();
		    	ai notify( "death", level.player );
		    	ai Delete();
		    }
		}
	}
	wait 0.05;
	self Delete();
	self notify( "death", level.player );
}

enemy_mi17_fake_delete_on_path_end()
{
	self endon( "death" );
	
	if ( self.mi17_path.size - 1 > 0 )
		self.mi17_path[ self.mi17_path.size - 1 ] waittill( "trigger" );
		
	foreach ( heli in self.mi17_attached_helis )
		if ( IsDefined( heli ) )
			heli Delete();
	
	if ( IsDefined( self.mi17_parent ) )
		self.mi17_parent Delete();
	self Delete();
	self notify( "death" );
}

enemy_mi17_set_passenger_callbacks_on_unload( callbacks )
{
	Assert( IsDefined( callbacks ) && IsArray( callbacks ) );
	self.script_mi17_passenger_callback_on_unload = callbacks;
}

// *************************************
// ENEMY TECHNICAL
// *************************************

enemy_gaz_init()
{
	self ent_flag_init( "FLAG_gaz_init" );
	self ent_flag_init( "FLAG_gaz_crash" );
	
	self godon();
	
	self.veh_pathtype = "constrained";
	
	self delayCall( 1.0, ::ThermalDrawEnable );
	self thread enemy_gaz_on_damage();
	self thread enemy_gaz_on_death();
	self thread enemy_gaz_monitor_ac130_fire();
	
	self ent_flag_set( "FLAG_gaz_init" );
}

enemy_gaz_on_damage()
{
	self endon( "death" );
	
	self SetCanDamage( true );
     
    for ( ; ; )
    {
    	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	    self waittill( "damage", damage, attacker );
	   	 
	   	if  ( compare( attacker, level.player ) )
	   	{
	   		self notify( "LISTEN_killed_by_player" );
	   		break;
	   	}
    }

   	if ( !( self ent_flag( "FLAG_gaz_crash" ) ) )
	{
		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    	self ThermalDrawDisable();
		
		fx = getfx( "FX_gaz_hurt_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_gaz_on_fire" );
		PlayFXOnTag( fx, self, "tag_engine_left" );
		PlayFXOnTag( fx, self, "tag_engine_right" );
		
		self ent_flag_set( "FLAG_gaz_crash" );
	}
}

enemy_gaz_monitor_ac130_fire()
{
	self endon( "death" );

    for ( ; ; )
    {
    			  // waittill( "projectile_impact", weapon_name, position, radius );
        level.player waittill( "projectile_impact", weapon_name, position );
        
        range = 0;
        
        switch ( weapon_name )
        {
        	case "ac130_25mm_alt2":
        		range = 128;
        		break;
            case "ac130_40mm_alt2":
                range = 320;
                break;
            case "ac130_105mm_alt2":
                range = 768;
                break;
        	default:
        		continue;
        }
        
        if ( weapon_name == "ac130_40mm_alt2" && dsq_2d_lt( self.origin, position, 256 ) )
    	{
    		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
    		self ThermalDrawDisable();
    		self notify( "death", level.player );
    		self notify( "LISTEN_killed_by_player" );
    		return;
    	}
    	
        if ( weapon_name == "ac130_105mm_alt2" && dsq_2d_lt( self.origin, position, 512 ) )
    	{
    		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
    		self ThermalDrawDisable();
    		self notify( "death", level.player );
    		self notify( "LISTEN_killed_by_player" );
    		return;
    	}
    	
        if ( dsq_2d_lt( self.origin, position, range ) )
        {
        	if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		self ThermalDrawDisable();
    		self notify( "LISTEN_killed_by_player" );
    		
    		switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	                break;
	            case "ac130_105mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
	                break;
	        }
	        	
        	if ( !( self ent_flag( "FLAG_gaz_crash" ) ) )
        	{
        		fx = getfx( "FX_gaz_hurt_explosion" );
				position = self.origin;
				forward = ( 0, 0, 1 );
				PlayFx( fx, position, forward );
				
				fx = getfx( "FX_gaz_on_fire" );
				PlayFXOnTag( fx, self, "tag_engine_left" );
				PlayFXOnTag( fx, self, "tag_engine_right" );
				
				self ent_flag_set( "FLAG_gaz_crash" );
			}
			return;
        }
    }
}

enemy_gaz_on_death()
{
	self waittill( "death", attacker );

	if ( IsDefined( self.script_technical_passengers ) )
	{
		self.script_technical_passengers = array_removedead( self.script_technical_passengers );
		self.script_technical_passengers = array_removeundefined( self.script_technical_passengers );

		foreach ( ai in self.script_technical_passengers )
		{
			ai ai_disable_magic_bullet_shield();
			if ( compare( attacker, level.player ) )
		    	ai DoDamage( 10000, ai.origin, level.player );
		    else
		    	ai DoDamage( 10000, ai.origin );
		}
	}
			
	fx = getfx( "FX_gaz_death_explosion" );
	position = self.origin;
	forward = ( 0, 0, 1 );
	PlayFx( fx, position, forward );
	
	fx = getfx( "FX_gaz_on_fire" );	
	StopFXOnTag( fx, self, "tag_engine_left" );
	StopFXOnTag( fx, self, "tag_engine_right" );
	
	wait 0.1;
	PhysicsExplosionSphere( self.origin, 768, 768, 4 );
}

enemy_gaz_load_passengers( passenger_spawners )
{
	Assert( IsDefined( passenger_spawners ) && IsArray( passenger_spawners ) );
	
	self endon( "death" );
	
	passengers = [];
    
	foreach ( i, spawner in passenger_spawners )
	{
		if ( IsDefined( spawner.script_drone ) && spawner.script_drone )
		{
			passengers[ passengers.size ] = spawner SpawnDrone();
			passengers[ i ] UseAnimTree( level.scr_animtree[ "drone" ] );
			passengers[ i ] ThermalDrawEnable();
		}
		else
			passengers[ passengers.size ] = spawner StalingradSpawn();
	}
	self thread vehicle_load_ai( passengers );
	self.script_technical_passengers = passengers;
	
	// Clean up
	
	foreach ( spawner in passenger_spawners )
		spawner Delete();
}

// Alt: Doesn't Cleanup spanwers
enemy_gaz_load_passengers_alt( passenger_spawner, num_passengers )
{
    Assert( IsDefined( passenger_spawner ) );
    
    self endon( "death" );
    
    // Spawn passengers
	
	max_passengers = 2;
	num_passengers = clamp_op( num_passengers, 1, max_passengers );
    passengers = [];
    _origin = passenger_spawner.origin;
		
	for ( i = 0; i < num_passengers; i++ )
	{
		passenger_spawner.count = 1;
		passenger_spawner.script_startingposition = i;
		passenger_spawner.origin = ( _origin[ 0 ], _origin[ 1 ] + 64.0, _origin[ 2 ] );
		passengers[ i ] = passenger_spawner StalingradSpawn();
		spawn_failed( passengers[ i ] );
		wait 0.05;
	}
	
	self vehicle_load_ai( passengers );
	
	self.script_technical_passengers = passengers;
}

enemy_gaz_crash_path( crash_node_prefix )
{
	Assert( IsDefined( crash_node_prefix ) );
	
	self endon( "death" );
	
	self ent_flag_wait( "FLAG_gaz_crash" );
	
	// Switch to crash path
	
	crash_node_in = GetVehicleNode( crash_node_prefix + "_in", "script_noteworthy" );
	Assert( IsDefined( crash_node_in ) );
	crash_node_out = GetVehicleNode( crash_node_prefix + "_out", "script_noteworthy" );
	Assert( IsDefined( crash_node_out ) );
	
	// self switch_vehicle_between_paths( crash_node_in, crash_node_out );
	self switch_vehicle_between_paths_lerp( crash_node_in, crash_node_out );
	
	// "Destory" vehicle at end of crash path
	
	crash_node_end = GetVehicleNode( crash_node_prefix + "_end", "script_noteworthy" );
	Assert( IsDefined( crash_node_end ) );
	
	crash_node_end waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	self godoff();
	self DoDamage( 10000, ( 0, 0, 0 ) );
}

enemy_gaz_last_crash_path( crash_node_prefix )
{
	Assert( IsDefined( crash_node_prefix ) );
	
	self endon( "death" );
	
	if ( Target_IsTarget( self )  )
    	Target_Remove( self );
    self ThermalDrawDisable();
    			
	// Switch to crash path
	
	crash_node_in = GetVehicleNode( crash_node_prefix + "_in", "script_noteworthy" );
	Assert( IsDefined( crash_node_in ) );
	crash_node_out = GetVehicleNode( crash_node_prefix + "_out", "script_noteworthy" );
	Assert( IsDefined( crash_node_out ) );
	
	//self switch_vehicle_between_paths( crash_node_in, crash_node_out );
	self switch_vehicle_between_paths_lerp( crash_node_in, crash_node_out );
	
	// FX to play if vehicle was not damage by player
	
	if ( !( self ent_flag( "FLAG_gaz_crash" ) ) )
	{
		fx = getfx( "FX_gaz_hurt_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_gaz_on_fire" );
		PlayFXOnTag( fx, self, "tag_engine_left" );
		PlayFXOnTag( fx, self, "tag_engine_right" );
	}
			
	// "Destory" vehicle at end of crash path
	
	crash_node_end = GetVehicleNode( crash_node_prefix + "_end", "script_noteworthy" );
	Assert( IsDefined( crash_node_end ) );
	
	crash_node_end waittill( "trigger", triggerer );
	Assert( self == triggerer );
		
	self godoff();
	self DoDamage( 10000, ( 0, 0, 0 ) );
}

enemy_gaz_fire_mg( target )
{
	Assert( IsDefined( target ) );
	
	self endon( "death" );
	
	turret = self.mgturret[ 0 ];
	Assert( IsDefined( turret ) );
	turret SetMode( "manual_ai" );
	turret SetTargetEntity( target, ( 0, 0, 128 ) );
	
	delay = 0.1;
	
	for ( ; ; )
	{
		_delay = ter_op( IsDefined( target ), delay, 0.05 );
		
		if ( IsDefined( target ) )
		{
			start = turret GetTagOrigin( "tag_flash" );
			end = target.origin + ( 0, 0, 64 );
			MagicBullet( "btr80_ac130_turret", start, end );
		}
		wait _delay;
	}
}

enemy_gaz_slide( node )
{
	Assert( IsDefined( node ) );
	
	self endon( "death" );
	
	node waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	fx = getfx( "FX_gaz_dust_slide" );
	position = self GetTagOrigin( "tag_wheel_back_left" );
	forward = ( 0, 0, 1 );
	PlayFX( fx, position, forward );
	position = self GetTagOrigin( "tag_wheel_back_right" );
	PlayFX( fx, position, forward );
}

// *************************************
// ENEMY BM21
// *************************************

enemy_bm21_cheap_init( value, key )
{
	self ent_flag_init( "FLAG_bm21_init" );
	self ent_flag_init( "FLAG_bm21_passengers_loaded" );
	self ent_flag_init( "FLAG_bm21_passengers_unloaded" );
	
	self.script_bm21_passenger_callbacks_on_unload = [];
	
	if ( IsDefined( value ) && IsDefined( key ) )
		self set_key( value, key );
	
	self godon();
	self ThermalDrawEnable();
	self SetCanDamage( true );
	self thread enemy_bm21_cheap_on_damage();
	self thread enemy_bm21_cheap_on_death();
	
	self ent_flag_set( "FLAG_bm21_init" );
}

enemy_bm21_cheap_on_damage()
{
	self endon( "death" );
	
	self.health = 10000;
	shots_to_kill_25mm = 10;
	shots_from_25mm = 0;
	kill_self = false;
	
    for ( ; ; )
    {
    	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	    self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	   	 
	   	if  ( compare( attacker, level.player ) )
	   	{
	   		if ( compare( weapon, "ac130_105mm_alt2" ) || 
	   			 compare( weapon, "ac130_40mm_alt2" ) )
				kill_self = true;
			else
			if ( compare( weapon, "ac130_25mm_alt2" ) )
				shots_from_25mm++;
			
			if ( shots_from_25mm >= shots_to_kill_25mm )
				kill_self = true;
				
			if ( kill_self )
			{
            	self godoff();
				self DoDamage( 10000, ( 0, 0, 0 ), level.player );
			}
	   		break;
	   	}
    }
}

enemy_bm21_cheap_on_death()
{
	self ent_flag_wait( "FLAG_bm21_init" );
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		if ( self ent_flag( "FLAG_bm21_passengers_unloaded" ) && IsDefined( self.script_bm21_passengers ) )
		{
			self.script_bm21_passengers = array_removedead( self.script_bm21_passengers );
			self.script_bm21_passengers = array_removeundefined( self.script_bm21_passengers );
	
			foreach ( ai in self.script_bm21_passengers )
			{
				ai ai_disable_magic_bullet_shield();
			    ai DoDamage( 10000, ai.origin, level.player );
			}
		}
				
		fx = getfx( "FX_bm21_hurt_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_bm21_on_fire" );	
		StopFXOnTag( fx, self, "tag_engine_left" );
		StopFXOnTag( fx, self, "tag_engine_right" );
		
		wait 0.1;
		PhysicsExplosionSphere( self.origin, 768, 768, 4 );
		self SetModel( "vehicle_bm21_mobile_bed_dstry" );
		self ThermalDrawDisable();
	}
	/*
	wait 3.0;
	fixed_link = Spawn( "script_model", self.origin );
	fixed_link LinkTo( 
	*/
}

enemy_bm21_init()
{
	self ent_flag_init( "FLAG_bm21_init" );
	self ent_flag_init( "FLAG_bm21_crash" );
	self ent_flag_init( "FLAG_bm21_passengers_loaded" );
	self ent_flag_init( "FLAG_bm21_passengers_unloaded" );
	
	self godon();
	
	self.veh_pathtype = "constrained";
	self.script_bm21_passenger_callbacks_on_unload = [];
	
	self SetCanDamage( true );
	self delayCall( 1.0, ::ThermalDrawEnable );
	self thread enemy_bm21_on_damage();
	self thread enemy_bm21_on_death();
	self thread enemy_bm21_monitor_ac130_fire();
	
	self ent_flag_set( "FLAG_bm21_init" );
}

enemy_bm21_on_damage()
{
	self endon( "death" );
	
    for ( ; ; )
    {
    	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	    self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	   	 
	   	if  ( compare( attacker, level.player ) )
	   	{
	   		self notify( "LISTEN_killed_by_player" );
	   		break;
	   	}
    }
    
   	if ( !( self ent_flag( "FLAG_bm21_crash" ) ) )
	{
		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    	self ThermalDrawDisable();
		
		fx = getfx( "FX_bm21_hurt_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_bm21_on_fire" );
		PlayFXOnTag( fx, self, "tag_engine_left" );
		PlayFXOnTag( fx, self, "tag_engine_right" );
		
		self ent_flag_set( "FLAG_bm21_crash" );
	}
}

enemy_bm21_monitor_ac130_fire()
{
	self endon( "death" );

    for ( ; ; )
    {
    			  // waittill( "projectile_impact", weapon_name, position, radius );
        level.player waittill( "projectile_impact", weapon_name, position );
        
        range = 0;
        
        switch ( weapon_name )
        {
        	case "ac130_25mm_alt2":
        		range = 128;
        		break;
            case "ac130_40mm_alt2":
                range = 320;
                break;
            case "ac130_105mm_alt2":
                range = 768;
                break;
        	default:
        		continue;
        }
        
        if ( weapon_name == "ac130_40mm_alt2" && dsq_2d_lt( self.origin, position, 256 ) )
    	{
    		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
    		self ThermalDrawDisable();
    		self notify( "death", level.player );
    		self notify( "LISTEN_killed_by_player" );
    		return;
    	}
    	
        if ( weapon_name == "ac130_105mm_alt2"  && dsq_2d_lt( self.origin, position, 512 ) )
    	{
    		if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
    		self ThermalDrawDisable();
    		self notify( "death", level.player );
    		self notify( "LISTEN_killed_by_player" );
    		return;
    	}
        	
        if ( dsq_2d_lt( self.origin, position, range ) )
        {
        	if ( Target_IsTarget( self )  )
    			Target_Remove( self );
    		self ThermalDrawDisable();
    		self notify( "LISTEN_killed_by_player" );
    		
    		switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	                break;
	            case "ac130_105mm_alt2":
	            	level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
	                break;
	        }
	        	
            if ( !( self ent_flag( "FLAG_bm21_crash" ) ) )
			{
				fx = getfx( "FX_bm21_hurt_explosion" );
				position = self.origin;
				forward = ( 0, 0, 1 );
				PlayFx( fx, position, forward );
				
				fx = getfx( "FX_bm21_on_fire" );
				PlayFXOnTag( fx, self, "tag_engine_left" );
				PlayFXOnTag( fx, self, "tag_engine_right" );
				
				self ent_flag_set( "FLAG_bm21_crash" );
			}
        }
    }
}

enemy_bm21_on_death()
{
	self ent_flag_wait( "FLAG_bm21_init" );
	self waittill( "death", attacker );
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
		self notify( "LISTEN_killed_by_player" );
	
	if ( IsDefined( self ) )
	{
		if ( self ent_flag( "FLAG_bm21_passengers_unloaded" ) && IsDefined( self.script_bm21_passengers ) )
		{
			self.script_bm21_passengers = array_removedead( self.script_bm21_passengers );
			self.script_bm21_passengers = array_removeundefined( self.script_bm21_passengers );
	
			foreach ( ai in self.script_bm21_passengers )
			{
				ai ai_disable_magic_bullet_shield();
			    if ( compare( attacker, level.player ) )
		    		ai DoDamage( 10000, ai.origin, level.player );
		    	else
		    		ai DoDamage( 10000, ai.origin );
			}
		}
				
		fx = getfx( "FX_bm21_death_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_bm21_on_fire" );	
		StopFXOnTag( fx, self, "tag_engine_left" );
		StopFXOnTag( fx, self, "tag_engine_right" );
		
		wait 0.1;
		PhysicsExplosionSphere( self.origin, 768, 768, 4 );
		self SetModel( "vehicle_bm21_mobile_bed_dstry" );
		self ThermalDrawDisable();
	}
	/*
	wait 3.0;
	fixed_link = Spawn( "script_model", self.origin );
	fixed_link LinkTo( 
	*/
}

enemy_bm21_load_passengers( passenger_spawners )
{
	Assert( IsDefined( passenger_spawners ) && IsArray( passenger_spawners ) );
	
	self endon( "death" );
	
	self ent_flag_wait( "FLAG_bm21_init" );
	
	passengers = [];
    
	foreach ( i, spawner in passenger_spawners )
	{
		if ( spawner compare_value( "script_drone", 1 ) )
		{
			passengers[ i ] = spawner SpawnDrone();
			passengers[ i ] UseAnimTree( level.scr_animtree[ "drone" ] );
			passengers[ i ] ThermalDrawEnable();
		}
		else
		{
			passengers[ i ] = spawner StalingradSpawn();
			spawn_failed( passengers[ i ] );
		}
	}
	self thread vehicle_load_ai( passengers );
	_flag = "FLAG_bm21_passengers_loaded";
	thread waittill_ents_notified_set_flag_timeout( self.script_mi17_passengers, "enteredvehicle", _flag, 15 );
	self.script_bm21_passengers = passengers;
	
	// Clean up
	
	foreach ( spawner in passenger_spawners )
		spawner Delete();
}

// Alt: Doesn't Cleanup spanwers
enemy_bm21_load_passengers_alt( passenger_spawner, num_passengers, _teleport )
{
    Assert( IsDefined( passenger_spawner ) );
    
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_bm21_init" );
    
    // Spawn passengers
	
	max_passengers = 10;
	num_passengers = clamp_op( num_passengers, 1, max_passengers );
	_teleport = ter_op( IsDefined( _teleport ), _teleport, false );
    passengers = [];
    _origin = passenger_spawner.origin;
		
	for ( i = 0; i < num_passengers; i++ )
	{
		passenger_spawner.count = 1;
		passenger_spawner.script_startingposition = i;
		passenger_spawner.origin = ( _origin[ 0 ], _origin[ 1 ] + 64.0, _origin[ 2 ] );
		
		if ( passenger_spawner compare_value( "script_drone", 1 ) )
		{
			passengers[ i ] = passenger_spawner SpawnDrone();
			passengers[ i ] UseAnimTree( level.scr_animtree[ "drone" ] );
			passengers[ i ] ThermalDrawEnable();
		}
		else
		{
			passengers[ i ] = passenger_spawner StalingradSpawn();
			spawn_failed( passengers[ i ] );
		}
		wait 0.05;
	}
			
	if ( _teleport )
	{
		foreach ( guy in passengers )
		{
			guy notify( "enteredvehicle" );
	        self maps\_vehicle_aianim::guy_enter( guy, false );
		}
		self ent_flag_set( "FLAG_bm21_passengers_loaded" );
	}
	else
	{
		self vehicle_load_ai( passengers );
		_flag = "FLAG_bm21_passengers_loaded";
		thread waittill_ents_notified_set_flag_timeout( passengers, "enteredvehicle", _flag, 15 );
	}
		
	self.script_bm21_passengers = passengers;
}

enemy_bm21_unload()
{
	self endon( "death" );
	
	self ent_flag_wait( "FLAG_bm21_init" );
	
	foreach ( guy in self.script_bm21_passengers )
		foreach ( callback in self.script_bm21_passenger_callbacks_on_unload )
			if ( IsDefined( guy ) )
				guy thread [[ callback ]]();
				
	_flag = "FLAG_bm21_passengers_unloaded";
	thread waittill_ents_notified_set_flag_timeout( self.script_bm21_passengers, "unload", _flag, 15 );
	self vehicle_unload();
}

enemy_bm21_set_passenger_callbacks_on_unload( callbacks )
{
	Assert( IsDefined( callbacks ) && IsArray( callbacks ) );
	self.script_bm21_passenger_callbacks_on_unload = callbacks;
}

enemy_bm21_gopath_and_die()
{
    self endon( "death" );
	
	if ( IsDefined( self.target ) )
	{
		node = GetVehicleNode( self.target, "targetname" );
		self switch_vehicle_path( node );
	}
	else
	{
		thread gopath( self );
	}
	
	// **HACK: this maybe a little hacky
	self ent_flag_wait( "FLAG_bm21_crash" );
	wait 1.0;
	self godoff();
	self DoDamage( 10000, ( 0, 0, 0 ), level.player );
}

enemy_bm21_crash_path( crash_node_prefix )
{
	Assert( IsDefined( crash_node_prefix ) );
	
	self endon( "death" );
	
	self ent_flag_wait( "FLAG_bm21_crash" );
	
	// Switch to crash path
	
	crash_node_in = GetVehicleNode( crash_node_prefix + "_in", "script_noteworthy" );
	Assert( IsDefined( crash_node_in ) );
	crash_node_out = GetVehicleNode( crash_node_prefix + "_out", "script_noteworthy" );
	Assert( IsDefined( crash_node_out ) );
	
	//switch_vehicle_between_paths( crash_node_in, crash_node_out );
	self switch_vehicle_between_paths_lerp( crash_node_in, crash_node_out );
	
	// "Destory" vehicle at end of crash path
	
	crash_node_end = GetVehicleNode( crash_node_prefix + "_end", "script_noteworthy" );
	Assert( IsDefined( crash_node_end ) );
	
	crash_node_end waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	self godoff();
	self DoDamage( 10000, ( 0, 0, 0 ) );
}

enemy_bm21_last_crash_path( crash_node_prefix )
{
	Assert( IsDefined( crash_node_prefix ) );
	
	self endon( "death" );
	
	if ( Target_IsTarget( self )  )
    	Target_Remove( self );
    self ThermalDrawDisable();
    	
	// Switch to crash path
	
	crash_node_in = GetVehicleNode( crash_node_prefix + "_in", "script_noteworthy" );
	Assert( IsDefined( crash_node_in ) );
	crash_node_out = GetVehicleNode( crash_node_prefix + "_out", "script_noteworthy" );
	Assert( IsDefined( crash_node_out ) );
	
	//switch_vehicle_between_paths( crash_node_in, crash_node_out );
	self switch_vehicle_between_paths_lerp( crash_node_in, crash_node_out );
	
	// FX to play if vehicle was not damage by player
	
	if ( !( self ent_flag( "FLAG_bm21_crash" ) ) )
	{
		fx = getfx( "FX_bm21_hurt_explosion" );
		position = self.origin;
		forward = ( 0, 0, 1 );
		PlayFx( fx, position, forward );
		
		fx = getfx( "FX_bm21_on_fire" );
		PlayFXOnTag( fx, self, "tag_engine_left" );
		PlayFXOnTag( fx, self, "tag_engine_right" );
	}
			
	// "Destory" vehicle at end of crash path
	
	crash_node_end = GetVehicleNode( crash_node_prefix + "_end", "script_noteworthy" );
	Assert( IsDefined( crash_node_end ) );
	
	crash_node_end waittill( "trigger", triggerer );
	Assert( self == triggerer );
		
	self godoff();
	self DoDamage( 10000, ( 0, 0, 0 ) );
}

enemy_bm21_slide( node )
{
	Assert( IsDefined( node ) );
	
	self endon( "death" );
	
	node waittill( "trigger", triggerer );
	Assert( self == triggerer );
	
	fx = getfx( "FX_bm21_dust_slide" );
	position = self GetTagOrigin( "tag_wheel_back_left" );
	forward = ( 0, 0, 1 );
	PlayFX( fx, position, forward );
	position = self GetTagOrigin( "tag_wheel_back_right" );
	PlayFX( fx, position, forward );
}

// *************************************
// ENEMY HIND
// *************************************

enemy_hind_init( value, key )
{
	if ( IsDefined( value ) )
	{
		key = ter_op( IsDefined( key ), key, "targetname" );
		self set_key( value, key );
	}
	
	ent_flag_init( "FLAG_helicopter_die" );
	ent_flag_init( "FLAG_helicopter_instant_death" );
	ent_flag_init( "FLAG_helicopter_instant_death_40mm" );
	ent_flag_init( "FLAG_helicopter_instant_death_105mm" );
	ent_flag_init( "FLAG_hind_dying" );
	
	self.hind_path = get_connected_ents( self.target );
	
	self ThermalDrawEnable();
	self godon();
	self thread enemy_hind_on_damage();
	self thread enemy_hind_on_death();
	self thread enemy_hind_monitor_ac130_fire();
}

enemy_hind_on_damage()
{
    self endon( "death" );
    self endon( "LISTEN_helicopter_end_on_damage" );
    
	self.health = 2 * self.healthbuffer;
	self SetCanDamage( true );
	
	min_damage_25mm 			= 1500;
	damage_recieved_by_player 	= 0;
	
	while( damage_recieved_by_player < min_damage_25mm )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self.health = 2 * self.healthbuffer;
		
		if ( compare( attacker, level.player ) && IsDefined( weapon ) )
		{
			switch ( weapon )
		    {
		    	case "ac130_25mm_alt2":
		    		damage_recieved_by_player += damage;
		    		break;
		        case "ac130_40mm_alt2":
		        	self ent_flag_set( "FLAG_helicopter_instant_death_40mm" );
		        	self ent_flag_set( "FLAG_helicopter_instant_death" );
					damage_recieved_by_player = 1500;
		            break;
		        case "ac130_105mm_alt2":
		        	self ent_flag_set( "FLAG_helicopter_instant_death_105mm" );
		        	self ent_flag_set( "FLAG_helicopter_instant_death" );
					damage_recieved_by_player = 1500;
		            break;
		    	default:
		    		continue;
		    }
		}
	}
	
	self godoff();
	
	if ( Target_IsTarget( self ) )
    	Target_Remove( self );
	
	self ent_flag_set( "FLAG_helicopter_die" );
	self ent_flag_set( "FLAG_hind_dying" );
}

enemy_hind_on_death()
{
	self ent_flag_wait( "FLAG_helicopter_die" );

	if ( !self ent_flag( "FLAG_helicopter_instant_death" ) )
	{
		self DoDamage( 100000, self.origin, level.player );
		self notify( "LISTEN_killed_by_player" );
		return;
	}
			
	if ( !IsDefined( self ) )
		return;
	
	PlayFX( getfx( "FX_mi17_explosion" ), self.origin + ( 0, 0, -64 ) );
	PlayFX( getfx( "FX_hind_air_explosion" ), self.origin + ( 0, 0, -64 ) );
	level thread play_sound_in_space( "scn_ac130_helicopter_exp", self.origin );
	if ( self ent_flag( "FLAG_helicopter_instant_death_40mm" ) )
		level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
	if ( self ent_flag( "FLAG_helicopter_instant_death_105mm" ) )
		level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
	self notify( "death", level.player );
	self notify( "LISTEN_killed_by_player" );
	self notify( "newpath" );
	self notify( "crash_done" );
	self Delete();
}

enemy_hind_monitor_ac130_instant_death()
{
	self endon( "death" );
	
	while ( !self ent_flag( "FLAG_helicopter_instant_death" ) && !self ent_flag( "FLAG_helicopter_die" ) )
		wait 0.05;
	self ent_flag_set( "FLAG_helicopter_die" );
}

enemy_hind_monitor_ac130_fire()
{
	self endon( "death" );
	
	self thread enemy_hind_monitor_ac130_instant_death();
	
    for ( ; ; )
    {
    	level.player waittill ( "missile_fire", projectile, weapon_name ); 
        
        if ( IsDefined( projectile ) && IsDefined( weapon_name ) )
        {
        	switch ( weapon_name )
	        {
	            case "ac130_40mm_alt2":
	            	flags = [ "FLAG_helicopter_instant_death", "FLAG_helicopter_instant_death_40mm" ];
	            	self thread set_flags_delete_ent_in_range( projectile, 256, flags );
	                break;
	            case "ac130_105mm_alt2":
	            	flags = [ "FLAG_helicopter_instant_death", "FLAG_helicopter_instant_death_105mm" ];
	            	self thread set_flags_delete_ent_in_range( projectile, 256, flags );
	                break;
	        	default:
	        		continue;
	        }
	    }
    }
}

// Alt: Doesn't Cleanup spanwer
enemy_hind_load_pilot_alt( pilot_spawner )
{
    Assert( IsDefined( pilot_spawner ) );
    
    self endon( "death" );

	if ( IsDefined( pilot_spawner ) )
	{
		// Spawn and load pilot
		
		pilot_spawner.count = 1;
		pilot = undefined;

		if ( pilot_spawner compare_value( "script_drone", 1 ) )
		{
			pilot = pilot_spawner SpawnDrone();
			pilot UseAnimTree( level.scr_animtree[ "drone" ] );
			pilot ThermalDrawEnable();
		}
		else
		{
			pilot = pilot_spawner StalingradSpawn();
			spawn_failed( pilot );	
		}
		
		Assert( IsDefined( pilot ) );
		
		self vehicle_load_ai( [ pilot ], true );
	}
}

enemy_hind_shoot_rocket_at_target( target )
{
	Assert ( IsDefined( target ) );
	
	if ( !IsDefined( self ) )
		return;
	if ( self ent_flag( "FLAG_hind_dying" ) )
		return;
		
	start = ter_op( RandomInt( 2 ), self GetTagOrigin( "tag_flash_side_1" ), self GetTagOrigin( "tag_flash_side_2" ) );
    end = target.origin;
    rocket = MagicBullet( "rpg_straight_ac130", start, end );
    rocket thread enemy_hind_rocket_impact( target );
}

enemy_hind_stop_and_shoot_rockets( look_at, targets )
{
	Assert( IsDefined( look_at ) );
	Assert( IsDefined( targets ) && IsArray ( targets ) );
	
	self endon( "death" );
	
	if ( self ent_flag( "FLAG_hind_dying" ) )
		return;
		
	stop = get_ents_from_array( "stop", "script_noteworthy", self.hind_path )[ 0 ];
	Assert( IsDefined( stop ) );

	self SetLookAtEnt( look_at );
    
    waittill_ent1_in_range_of_ent2( self, stop, 64 );
    self Vehicle_SetSpeedImmediate( 0, 30, 30 );
    
    delay = 1.0;
    
    foreach ( target in targets )
    {
    	if ( self ent_flag( "FLAG_hind_dying" ) )
			return;
			
    	start = ter_op( RandomInt( 2 ), self GetTagOrigin( "tag_flash_side_1" ), self GetTagOrigin( "tag_flash_side_2" ) );
    	end = target.origin;
    	rocket = MagicBullet( "rpg_straight", start, end );
    	rocket thread enemy_hind_rocket_impact( target );
    	wait delay; 
    }
    self notify( "LISTEN_hind_finished_shooting_rockets" );
}

enemy_hind_rocket_impact( target )
{
	Assert( IsDefined( target ) );
	
	self waittill( "death" );
	
	forward = -1 * AnglesToForward( self.angles );
	position = target.origin;
	fx = getfx( "FX_hind_rocket_hitting_building" );
	
	PlayFX( fx, position, forward );
}

enemy_hind_fire_mg( target )
{
	Assert( IsDefined( target ) );
	
	self endon( "death" );

	delay = 0.1;
	
	for ( ; ; )
	{
		_delay = ter_op( IsDefined( target ), delay, 0.05 );
		
		if ( IsDefined( target ) )
		{
			start = self GetTagOrigin( "tag_flash" );
			end = target.origin;
			MagicBullet( "btr80_ac130_turret", start, end );
		}
		wait _delay;
	}
}

enemy_hind_gopath_and_die()
{
	self endon( "death" );
	thread gopath( self );
	
	die_node = get_ents_from_array( "die", "script_noteworthy", self.hind_path )[ 0 ];
	
	if ( IsDefined( die_node ) )
		die_node waittill( "trigger" );
	else
		self waittill( "reached_dynamic_path_end" );
		
	if ( Target_IsTarget( self ) )
		Target_Remove( self );
	self DoDamage( 10000, self.origin );
	self notify( "death" );	
}

// *************************************
// ENEMY MIG29
// *************************************

enemy_mig29_init()
{
	self.mig29_path = get_connected_ents( self.target );
	self.mig29_attached_planes = [];
	
	self ThermalDrawEnable();
	self SetCanDamage( false ); 
	self thread enemy_mig29_play_afterburner();
	self thread enemy_mig29_monitor_rumble();
}

enemy_mig29_init_cheap()
{
	self.mig29_path = get_connected_ents( self.target );
	self.mig29_attached_planes = [];
	
	self ThermalDrawEnable();
	self thread enemy_mig29_monitor_rumble();
}

enemy_mig29_init_fake()
{
	self ThermalDrawEnable();
	self thread vehicle_scripts\_f15::playConTrail();
	self thread fake_jet_rumble( "script_vehicle_mig29_low" );
}

enemy_mig29_play_afterburner()
{
	self endon( "death" );
	
	afterburner_nodes = get_ents_from_array( "afterburner", "script_noteworthy", self.mig29_path );
	
	foreach ( node in afterburner_nodes )
 	{
		node waittill( "trigger" );
		
		fx = getfx( "FX_jet_afterburner_ignite" );	
		PlayFxOnTag( fx, self, "tag_engine_right" );
		PlayFxOnTag( fx, self, "tag_engine_left" );
		fx = getfx( "FX_jet_smoke_trail_quick" );
		PlayFxOnTag( fx, self, "tag_engine_right" );
		PlayFxOnTag( fx, self, "tag_engine_left" );	
	}
}

enemy_mig29_fake_play_afterburner( delay )
{
	self endon( "death" );
	
	delay = gt_op( delay, 0.05 );
	
	wait delay;
	
	if ( !IsDefined( self ) )
		return;
		
	fx = getfx( "FX_jet_afterburner_ignite" );	
	PlayFxOnTag( fx, self, "tag_engine_right" );
	PlayFxOnTag( fx, self, "tag_engine_left" );
	fx = getfx( "FX_jet_smoke_trail_quick" );
	PlayFxOnTag( fx, self, "tag_engine_right" );
	PlayFxOnTag( fx, self, "tag_engine_left" );
}

enemy_mig29_fake_sonic_boom( point, sound )
{
	Assert( IsDefined( point ) );
	
	self endon( "death" );
	
	sound = ter_op( IsDefined( sound ), sound, "veh_paris_ac130_jet_sonic_boom" );

	self thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
	waittill_ent_in_range_of_point( self, point, 64.0 );
	level thread play_sound_in_space( sound, point );
}

enemy_mig29_fake_damage_and_explode()
{
	self endon( "death" );
	
	fx = getfx( "FX_mig29_on_fire" );
	PlayFXOnTag( fx, self, "tag_origin" );
	wait RandomFloatRange( 1.0, 3.0 );
	fx = getfx( "FX_mig29_air_explosion" );
	pos = self.origin;
	fwd = AnglesToForward( self.origin );
	PlayFX( fx, pos, fwd );
	self stop_loop_sound_on_entity( "veh_f15_dist_loop" );
	self Delete();
	self notify( "death" );
}

enemy_mig29_sonic_boom( sound )
{
	self endon( "death" );
	
	sound = ter_op( IsDefined( sound ), sound, "veh_paris_ac130_jet_sonic_boom" );
	sonic_boom_nodes = get_ents_from_array( "sonic_boom", "script_noteworthy", self.mig29_path );
		
	foreach ( node in sonic_boom_nodes )
		self thread enemy_mig29_play_sound_node( node, sound );
	self thread play_loop_sound_on_entity( "veh_f15_dist_loop" );
}

enemy_mig29_play_sound_node( node, sound )
{
	Assert( IsDefined( node ) );
	Assert( IsDefined( sound ) );
	
	self endon( "death" );
	
	node waittill( "trigger" );
	node play_sound_in_space( sound );
}

enemy_mig29_damaged()
{
	self endon( "death" );
	
	damage_node = get_ents_from_array( "fire", "script_noteworthy", self.mig29_path )[ 0 ];
	
	if ( IsDefined( damage_node ) )
	{
		damage_node waittill( "trigger" );
		
		fx = getfx( "FX_mig29_on_fire" );
		PlayFXOnTag( fx, self, "tag_origin" );
	}
}

enemy_mig29_explode()
{
	self endon( "death" );
	
	explode_node = get_ents_from_array( "explosion", "script_noteworthy", self.mig29_path )[ 0 ];
	
	if ( IsDefined( explode_node ) )
	{
		explode_node waittill( "trigger" );
		
		fx = getfx( "FX_mig29_air_explosion" );
		pos = self.origin;
		fwd = AnglesToForward( self.origin );
		PlayFX( fx, pos, fwd );

		self stop_loop_sound_on_entity( "veh_f15_dist_loop" );
		self Delete();
		self notify( "death" );
	}
}

enemy_mig29_randomly_die( damage_delay, explosion_delay, chance )
{
	self endon( "death" );
	
	damage_delay = gt_op( damage_delay, 0.05 );
	explosion_delay = gt_op( explosion_delay, 0.05 );
	chance = gt_op( chance, 0 );
	
	wait damage_delay;
	
	if ( random_chance( chance ) )
	{
		fx = getfx( "FX_mig29_on_fire" );
		PlayFXOnTag( fx, self, "tag_origin" );
		
		wait explosion_delay;
		
		fx = getfx( "FX_mig29_air_explosion" );
		pos = self.origin;
		fwd = ( 0, 0, 1 );
		PlayFX( fx, pos, fwd );
		
		self Delete();
		self notify( "death" );
	}
}

enemy_mig29_monitor_rumble()
{
	self endon( "death" );
	
	rumblestruct = level.vehicle_rumble[ "script_vehicle_f15_low" ];
	
	for ( ; ; )
	{
		if ( IsDefined( self.rumbletrigger ) )
		{
			self.rumbletrigger waittill( "trigger" );
			if ( self Vehicle_GetSpeed() == 0 || !self.rumbleon )
			{
				wait 0.1;
				continue;
			}
	
			while ( level.player IsTouching( self.rumbletrigger ) && self.rumbleon && self Vehicle_GetSpeed() > 0 )
			{
				if ( dsq_lt( level.ac130player.origin, self.origin, self.rumble_radius * 0.75 ) )
					flag_set( "FLAG_ac130_rumble" );
				wait( self.rumble_basetime + RandomFloat( self.rumble_randomaditionaltime ) );
			}
		}
		else
			wait 0.05;
	}
}

enemy_mig29_delete_on_path_end()
{
	self endon( "death" );
	
	if ( self.mig29_path.size - 1 > 0 )
		self.mig29_path[ self.mig29_path.size - 1 ] waittill( "trigger" );
	else
		self waittill( "reached_dynamic_path_end" );
		
	foreach ( plane in self.mig29_attached_planes )
	{
		if ( IsDefined( plane ) )
		{
			
			StopFXOnTag( getfx( "FX_mig29_fake" ), plane, "tag_origin" );
			plane Delete();
		}
	}
	
	if ( IsDefined( self.mig29_parent ) )
		self.mig29_parent Delete();
			
	self stop_loop_sound_on_entity( "veh_f15_dist_loop" );
	self Delete();
	self notify( "death" );
}

enemy_mig29_fake_delete( time )
{
	if ( !IsDefined( self ) )
		return;
	time = gt_op( time, 0.05 );
	wait time;
	if ( !IsDefined( self ) )
		return;
	self notify( "death" );
	self notify( "kill_rumble_forever" );
	if ( Isdefined( self.tag1 ) )
		self.tag1 Delete();
	if ( Isdefined( self.tag2 ) )
		self.tag2 Delete();
	if ( IsDefined( self.rumbletrigger ) )
		self.rumbletrigger Delete();
	wait 0.05;
	if ( !IsDefined( self ) )
		return;
	self Delete();
}

// *************************************
// AI - FRIENDLY
// *************************************

#using_animtree( "generic_human" );
ai_friendly_init( value, key )
{
    Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self ent_flag_init( "FLAG_ai_init" );
	self ent_flag_init( "FLAG_ai_scripted" );
	self ent_flag_init( "FLAG_ai_reached_path_end" );
	
	self.script_default_accuracy = self.accuracy;
	self.script_default_baseaccuracy = self.baseaccuracy;
	self.script_default_goalradius = self.goalradius;
	
	self.accuracy = 1.0;
	self.baseaccuracy = 500000;
	self.health = 20000;
	self set_key( value, key );
	self.enemy_damage_recieved = 0;
	
	self deletable_magic_bullet_shield();
	self set_goal_radius( 4.0 );
	
	self ent_flag_set( "FLAG_ai_scripted" );
	self ent_flag_set( "FLAG_ai_init" );
}

ai_friendly_set_health( health )
{
	health = ter_op( IsDefined( health ) && health > 1, health, 1 );
	
	self.health = health;
	self.maxhealth = health;
	self.enemy_damage_recieved = 0;
}

ai_friendly_on_damage( friendly_type )
{
	Assert( IsDefined( friendly_type ) );

    self endon( "death" );
    self endon( "LISTEN_end_ai_scripts" );
     
    while ( self.enemy_damage_recieved < self.maxhealth )
    {
    	// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	    self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
	    
	    if ( flag( "FLAG_delta_ac130_mission_fail" ) &&
	    	 !compare( attacker, self ) && 
	    	 !( attacker compare_value( "team", "allies" ) ) && 
	    	 !compare( weapon, "ac130_25mm_alt2" ) && 
	    	 !compare( weapon, "ac130_40mm_alt2" ) && 
	    	 !compare( weapon, "ac130_105mm_alt2" ) )
	    	self.enemy_damage_recieved += damage;
    }

	friendly_type = ter_op( friendly_type == 0 || friendly_type == 1, friendly_type, 1 );    
    msg = ter_op( friendly_type, "@PARIS_AC130_MISSION_FAIL_DELTA_KILLED", "@PARIS_AC130_MISSION_FAIL_HVI_KILLED" );
    
    _mission_failed( msg );
}

ai_friendly_dive_from_explosion_go_to_goal( delay, node, _flag, goal_pos )
{
	Assert( IsDefined( node ) );	
	Assert( IsDefined( _flag ) && flag_exist( _flag ) );
	Assert( IsDefined( goal_pos ) );
	
	self.ignoreme = true;
	self.ignoreall = true;
	self.disableArrivals = true;
	self.disableExits = true;
	
	self clear_parent_ai();
	self clear_child_ai();
	self SetGoalPos( goal_pos );
	
	node.origin = self.origin;
	
	node maps\_anim::anim_generic( self, "corner_standR_explosion_divedown" );
	
	while ( !flag( _flag ) )
	{
		self maps\_anim::anim_generic( self, "corner_standR_explosion_idle" );
	}
	
	delay = ter_op( IsDefined( delay ) && delay > 0.05, delay, 0.05 );
	elapsed = 0;
	anim_length = GetAnimLength( getanim_generic( "corner_standR_explosion_idle" ) );
	
	while ( elapsed < delay )
	{
		self maps\_anim::anim_generic( self, "corner_standR_explosion_idle" );
		elapsed += anim_length;
	}
	
	self maps\_anim::anim_generic( self, "corner_standR_explosion_standup" );
	wait 0.05;
	//self.disableArrivals = false;
	//self.disableExits = false;
}

ai_friendly_push_forward( time )
{
	self notify( "LISTEN_end_ai_friendly_push_forward" );
	self endon( "LISTEN_end_ai_friendly_push_forward" );
	
	time = gt_op( time, 0.05 );
	
	self thread ai_ignoreall( time );
	self thread ai_ignoresuppression( time );
	self set_forcegoal();
	self delayThread( time, ::unset_forcegoal );
	self set_badplaceawareness( 0 );
	self delayThread( time, ::unset_badplaceawareness );
}

ai_friendly_monitor_laser()
{
	self endon( "death" );
	self endon( "LISTEN_end_ai_scripts" );
	
	self LaserAltOn();
	
	laser_on = false;
	
	for ( ; ; )
	{
		if ( flag( "FLAG_ac130_player_in_ac130" ) )
		{
			if ( flag( "FLAG_ac130_thermal_enabled" ) && !laser_on )
			{
				self LaserForceOn();
				laser_on = true;
			}
			else
			if ( flag( "FLAG_ac130_enhanced_vision_enabled" ) && laser_on )
			{
				self LaserForceOff();
				laser_on = false;
			}
		}
		wait 0.05;
	}
}

ai_friendly_set_default()
{
	self ent_flag_clear( "FLAG_ai_scripted" );
	
	self.accuracy = self.script_default_accuracy;
	self.baseaccuracy = self.script_default_baseaccuracy;
	self.goalradius = self.script_default_goalradius;
}

ai_friendly_set_scripted()
{
	self ent_flag_set( "FLAG_ai_scripted" );
	
	self.accuracy = 1.0;
	self.baseaccuracy = 500000;
	self.enemy_damage_recieved = 0;
	self set_goal_radius( 4.0 );
}

// *************************************
// AI - FRIENDLY - HUMMER
// *************************************

ai_friendly_hummer_init()
{
	if ( !IsDefined( self.magic_bullet_shield ) )
		self deletable_magic_bullet_shield();
	else
	if ( !self.magic_bullet_shield )
		self magic_bullet_shield( true );
}

// *************************************
// AI - FRIENDLY - GAURD + HOSTAGE - adapted from _carry_ai
// *************************************

// parent_animset: array consisting of
// -- idle anim with child
// -- start interaction anim name at current location
// -- movement anim name between current location and end location
// -- end interaction anim name at end locatoin

//
// child_animset: array consisting of
// -- idle anim with parent
// -- start interaction anim name at current location
// -- movement anim name between current location and end location
// -- end interaction anim name at end locatoin

set_parent_ai( parent_animset )
{
	Assert( IsAI( self ) && IsAlive( self )  );
	Assert( IsDefined( parent_animset ) && IsArray( parent_animset ) && parent_animset.size >= 3 );
	
	self.parent_ai_animset = parent_animset;
}

clear_parent_ai()
{
	Assert( IsAI( self ) && IsAlive( self ) );
	
	if ( IsDefined( self.parent_ai_animset ) )
	{
		foreach ( _anim in self.parent_ai_animset )
		{
			if ( IsArray( _anim ) )
			{
				foreach ( a in _anim )
				{
					if ( IsDefined( self.parent_ai_node  ) )
						self.parent_ai_node notify( "LISTEN_stop_" + a );
					self notify( "LISTEN_stop_" + a );
				}
			}
			else
			{		
				if ( IsDefined( self.parent_ai_node  ) )
					self.parent_ai_node notify( "LISTEN_stop_" + _anim );
				self notify( "LISTEN_stop_" + _anim );
			}
		}
	}
	
	self.allowpain = true;
	self.disableBulletWhizbyReaction = false;
	self.ignoreall = false;
	self.grenadeawareness = 1;
	self setFlashbangImmunity( false );
	self.dontMelee = undefined;
	self.neverEnableCqb = undefined;
	self.disablearrivals = undefined;
	self.disableexits = undefined;
	self.nododgemove = false;
	self PushPlayer( true );
		
	self.parent_ai_animset = undefined;
	
	self notify ( "LISTEN_end_parent_child_ai_behavior" );
}

set_child_ai( node, child_animset )
{
	Assert( IsAI( self ) && IsAlive( self ) );
	Assert( Isdefined( node ) );
	Assert( IsDefined( child_animset ) && IsArray( child_animset ) && child_animset.size == 4 );
	
	self animscripts\shared::DropAIWeapon();
	self.child_ai_node = node;
	self.child_ai_animset = child_animset;
	
	idle_animname = child_animset[ 0 ];
	
	if ( IsDefined( self.animname ) )
		node thread anim_loop( [ self ], idle_animname, "LISTEN_stop_" + idle_animname );
	else
		node thread anim_generic_loop( self, idle_animname, "LISTEN_stop_" + idle_animname );
	self.allowdeath = true;
}

clear_child_ai()
{
	Assert( IsAI( self ) && IsAlive( self ) );
	
	if ( IsDefined( self.child_ai_animset ) && IsArray( self.child_ai_animset ) )
	{
		foreach ( _anim in self.child_ai_animset )
		{
			if ( IsArray( _anim ) )
			{
				foreach ( a in _anim )
				{
					if ( IsDefined( self.child_ai_node  ) )
						self.child_ai_node notify( "LISTEN_stop_" + a );
					self notify( "LISTEN_stop_" + a );
				}
			}
			else
			{
				if ( IsDefined( self.child_ai_node ) )
					self.child_ai_node notify( "LISTEN_stop_" + _anim );
				self notify( "LISTEN_stop_" + _anim );
			}
		}
	}
	
	self.child_ai_node = undefined;
	self.child_ai_animset = undefined;
	self UnLink();
	self VisibleSolid();
}

parent_ai_go_to_child_ai( child_ai )
{
	Assert( IsDefined( self ) && IsAI( self ) && IsAlive( self ) );
	Assert( IsDefined( child_ai ) && IsAI( child_ai ) && IsAlive( child_ai ) );
	AssertEX( IsDefined( child_ai.child_ai_node ) , "You need to call set_child_ai() to set child_ai.child_ai_node" );
	AssertEX( IsDefined( self.parent_ai_animset ), "You need to call set_parent_ai() to set self.parent_ai_animset" );
	
	self endon( "death" );
	self endon ( "LISTEN_end_parent_child_ai_behavior" );
	
	start_interact_animanme = self.parent_ai_animset[ 1 ];
	idle_animname = self.parent_ai_animset[ 0 ];
	self.parent_ai_node = child_ai.child_ai_node;
	
	old_goal_radius = self.goalradius;
	self.goalradius = 64;
	self SetGoalPos( child_ai.child_ai_node.origin );
	self waittill( "goal" );
		
	// Parent A.I. moves to Child A.I. 
	
	if ( IsDefined( self.animname ) )
		foreach ( _anim in start_interact_animanme )
			child_ai.child_ai_node anim_reach( [ self ], _anim );
	else
		foreach ( _anim in start_interact_animanme )
			child_ai.child_ai_node anim_generic_reach( self, _anim );
		
	if ( IsDefined( idle_animname ) )
		child_ai.child_ai_node thread anim_generic_loop( self, idle_animname, "LISTEN_stop_" + idle_animname );
	self.goalradius = old_goal_radius;
	wait 0.05;
}

parent_ai_and_child_ai_go_to_node( child_ai, node, parent_ai_free )
{
	Assert( IsDefined( self ) && IsAI( self ) && IsAlive( self ) );
	Assert( IsDefined( child_ai ) && IsAI( child_ai ) && IsAlive( child_ai ) );
	Assert( IsDefined( node ) );
	AssertEX( IsDefined( self.parent_ai_animset ), "You need to call set_child_ai() to set child_ai.child_ai_animset" );
	AssertEX( IsDefined( child_ai.child_ai_animset ), "You need to call set_child_ai() to set child_ai.child_ai_animset" );
	AssertEX( IsDefined( child_ai.child_ai_node ), "You need to call set_child_ai() to set child_ai.child_ai_node" );

	self endon( "death" );
	self endon ( "LISTEN_end_parent_child_ai_behavior" );
	
	parent_ai_free = ter_op( IsDefined( parent_ai_free ), parent_ai_free, false );
	child_ai.child_ai_interacting_with_parent_ai = true;
	self.parent_ai_node = child_ai.child_ai_node;
	
	// Stop Parent A.I. and Child A.I. Idle wait anim
	
	if ( IsDefined( self.parent_ai_animset[ 0 ] ) )
	{
		self notify( "LISTEN_stop_" + self.parent_ai_animset[ 0 ] );
		child_ai.child_ai_node notify( "LISTEN_stop_" + self.parent_ai_animset[ 0 ] );
	}
	
	child_ai notify( "LISTEN_stop_" + child_ai.child_ai_animset[ 0 ] );
	child_ai.child_ai_node notify( "LISTEN_stop_" + child_ai.child_ai_animset[ 0 ] );
	wait 0.05;
	
	// Parent A.I. interacts with Child A.I. at start
	
	AssertEX( child_ai.child_ai_animset[ 1 ].size == self.parent_ai_animset[ 1 ].size, "Parent and Child A.I. must have the same number of interact animations" );
	
	child_ai.allowdeath = true;
	foreach( i, _anim in child_ai.child_ai_animset[ 1 ] )
	{
		child_ai.child_ai_node thread anim_generic( child_ai, _anim );
		child_ai.child_ai_node anim_generic( self, self.parent_ai_animset[ 1 ][ i ] );
	}
	
	self.dontMelee = true;
	child_ai InvisibleNotSolid();
	
	// Set Parent A.I. run / movement anim
	
	if ( IsDefined( self.animname ) )
		self thread set_run_anim( self.parent_ai_animset[ 2 ], true );
	else
		self thread set_generic_run_anim( self.parent_ai_animset[ 2 ], true );

	// Turn Off Parent A.I. normal behavior
	
	//setsaveddvar( "ai_friendlyFireBlockDuration", 0 );
	self animmode( "none" );
	self.allowpain = false;
	self.disableBulletWhizbyReaction = true;
	self.ignoreall = true;
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self setFlashbangImmunity( true );
	self.neverEnableCqb = true;
	self.disablearrivals = true;
	self.disableexits = true;
	self.nododgemove = true;
	
	self disable_cqbwalk();

	self.oldgoal = self.goalradius;
	
	// Link Child A.I. to Parent A.I. and play movement anim
	
	self thread link_child_ai( child_ai );
	
	// Parent A.I. travel along a linked list if defined
	
	self.ignoresuppression = true;
	self.disablearrivals = true;
	
	ent_path_list = [ node ];
	
	// Some checks in case root node shares key, value pair with multiple ents
	
	if ( IsDefined( node.target ) )
		ent_path_list = array_combine( ent_path_list, get_connected_ents( node.target ) );
	ent_path_list = array_removeundefined( ent_path_list );
	
	self.goalradius = 64;
		
	foreach( i, _node in ent_path_list )
	{
		if ( i == ( ent_path_list.size - 1 ) )
			continue;
		self SetGoalPos( _node.origin );
		self waittill( "goal" );
	}
	
	node = ent_path_list[ ent_path_list.size - 1 ];
	
	// Parent A.I. moves to node

	node anim_generic_Reach( self, self.parent_ai_animset[ 3 ] );
	
	// Stop Child A.I. idle and movement anim
	
	child_ai.child_ai_node = node;
	self.parent_ai_node = child_ai.child_ai_node;
	child_ai notify( "LISTEN_stop_" + child_ai.child_ai_animset[ 2 ] );
	node notify( "LISTEN_stop_" + child_ai.child_ai_animset[ 0 ] );
	wait 0.05;
	
	// UnLink Child A.I.
	
	child_ai UnLink();
	
	self.ignoresuppression = false;
	self.disablearrivals = false;
	self.goalradius = self.oldgoal;
	
	// Parent A.I. interacts with Child A.I. at destination
	
	self thread clear_run_anim();
	child_ai.child_ai_node thread anim_generic( self, self.parent_ai_animset[ 3 ] );
	child_ai.child_ai_node anim_generic( child_ai, child_ai.child_ai_animset[ 3 ] );
	
	if ( parent_ai_free )
	{
	}
	else
	{
		//setsaveddvar( "ai_friendlyFireBlockDuration", 2000 );
		self.allowpain = true;
		self.disableBulletWhizbyReaction = false;
		self.ignoreall = false;
		//self.ignoreme = false;
		self.grenadeawareness = 1;
		self setFlashbangImmunity( false );
		self.dontMelee = undefined;
		self.neverEnableCqb = undefined;
		self.disablearrivals = undefined;
		self.disableexits = undefined;
		self.nododgemove = false;
		self PushPlayer( false );
	}
	
	child_ai VisibleSolid();

	// Set Child A.I. to Idle
	
	child_ai.child_ai_node thread anim_generic_loop( child_ai, child_ai.child_ai_animset[ 0 ], "LISTEN_stop_" + child_ai.child_ai_animset[ 0 ] );
	child_ai.allowdeath = true;
	child_ai.child_ai_interacting_with_parent_ai = undefined;
	
	// Set Parent A.I. to idle
	
	if ( parent_ai_free )
		child_ai.child_ai_node thread anim_generic_loop( self, self.parent_ai_animset[ 0 ], "LISTEN_stop_" + self.parent_ai_animset[ 0 ] );
	
	self notify( "LISTEN_parent_and_child_reached_goal" );
}

link_child_ai( child_ai )
{
	Assert( IsDefined( child_ai ) && IsAI( child_ai ) && IsAlive( child_ai ) );
	AssertEX( IsDefined( child_ai.child_ai_animset ), "You need to call set_child_ai() to set child_ai.child_ai_animset" );
	
	self endon( "death" );
	child_ai endon( "death" );
	
	child_ai LinkTo( self, "tag_origin" );

	// wait for Parent A.I. to get a path and start move script
	//wait 0.05;
	
	child_ai thread anim_generic_loop( child_ai, child_ai.child_ai_animset[ 2 ], "LISTEN_stop_" + child_ai.child_ai_animset[ 2 ] );
}

// *************************************
// AI - ENEMY
// *************************************

ai_enemy_fallback( goal, goal_radius, min_goal_reached_radius, max_goal_reached_radius )
{
	Assert( IsDefined( goal ) );
	
	self endon( "death" );
	
	goal_radius = gt_op( goal_radius, 0 );
	min_goal_reached_radius = gt_op( min_goal_reached_radius, 0 );
	max_goal_reached_radius = clamp_op( max_goal_reached_radius, 0, min_goal_reached_radius );
	
	old_fixednode = self.fixednode;
	self.fixednode = false;
	self set_ignoreSuppression( true );
	self thread ai_ignoreall( 3.0 );
	self set_forcegoal();
	self delayThread( 3.0, ::unset_forcegoal );
	self set_goal_radius( goal_radius );
	self SetGoalPos( goal.origin );
	self waittill( "goal" );
	
	self.fixednode = old_fixednode;
	self set_ignoreSuppression( false );
	self set_goal_radius( RandomIntRange( min_goal_reached_radius, max_goal_reached_radius ) );
}

// *************************************
// AI - ENEMY - CHASE
// *************************************

ai_enemy_chase_init()
{ 
    self ent_flag_init( "FLAG_ai_init" );
    
    self deletable_magic_bullet_shield();
    
    self ent_flag_set( "FLAG_ai_init" );
}

// *************************************
// AI - ENEMY - RPG
// *************************************

ai_enemy_rpg_init( value, key )
{
	Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	    
    self ent_flag_init( "FLAG_ai_init" );
    
    self.script_noteworthy = value;
    self.ignoreall = true;
    self.ignoreme = true;
    
    self thread ai_enemy_rpg_on_damage();
    self thread ai_enemy_rpg_hide_and_shoot();
    self thread ai_enemy_rpg_monitor_ac130_weapon_fire();
    self ThermalDrawEnable();
    self SetCanDamage( true );
    
    self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_rpg_on_damage()
{
    // possibly fling rpg out of window
}

ai_enemy_rpg_monitor_ac130_weapon_fire()
{
	self endon( "death" );
	self endon( "LISTEN_end_ai_monitor_ac130" );
	
	while ( IsDefined( self ) )
	{
				  // waittill( "projectile_impact", weapon_name, position, radius );
	    level.player waittill( "projectile_impact", weapon_name, position );
        
        if ( !IsDefined( self ) )
        	return;
        	
        range = -1;
            
	    switch ( weapon_name )
	    {
	        case "ac130_25mm_alt2":
	            range = 256;
	            break;
	   		case "ac130_40mm_alt2":
	   			range = 768;
	   			break;
	   		case "ac130_105mm_alt2":
	   			range = 1536;
	   			break;
	    }
	    
	    if ( dsq_2d_lt( self.origin, position, range ) )
	    {
	    	self DoDamage( 10000, self.origin );
	    }
	}
}

ai_enemy_rpg_hide_and_shoot()
{
    self endon( "death" );
	
	rpg_targets = getstructarray( "rpg_ma_4_enemy_rpg_target_1", "targetname" );
	rpg_targets_alt = getstructarray( "rpg_ma_4_enemy_rpg_target_2", "targetname" );
	rpg_start = getstruct( self.script_noteworthy + "_start", "targetname" );
	
	first_shot = true;
	
	for ( ; ; )
	{
		if ( flag( "FLAG_rpg_delta_fallback" ) )
			rpg_targets = rpg_targets_alt;
									
		self maps\_anim::anim_generic( self, "RPG_conceal_idle" );
		self maps\_anim::anim_generic( self, "RPG_conceal_2_standL" );
		
		if ( first_shot )
		{
			first_shot = false;
			self thread maps\_anim::anim_generic( self, "RPG_stand_twitch_v1" );
		}
		else
		{
			count = RandomIntRange( 3, 10 );
			
			while ( count > 0 )
			{
				self maps\_anim::anim_generic( self, "RPG_stand_twitch_v1" );
				count--;
			}
			self thread maps\_anim::anim_generic( self, "RPG_stand_twitch_v1" );
		}
		MagicBullet( "rpg_straight_ac130", rpg_start.origin, rpg_targets[ RandomInt( rpg_targets.size ) ].origin );
		level thread play_sound_in_space( "weap_rpg_fire_npc", self.origin );
		self maps\_anim::anim_generic( self, "RPG_standL_2_conceal" );
	}
}

ai_enemy_rpg_stand_loop()
{
	self notify( "LISTEN_ai_end_loop_anim" );
	self endon( "death" );
	self endon( "LISTEN_ai_end_loop_anim" );
	
	while ( IsDefined( self ) )
		self maps\_anim::anim_generic( self, "RPG_stand_twitch_v1" );
}

ai_enemy_rpg_shoot_at_target( target )
{
	Assert( IsDefined( target ) );
	 
	MagicBullet( "rpg_straight_ac130", self GetTagOrigin( "tag_flash" ), target.origin );
}

ai_enemy_rpg_unlimited_ammo()
{
	Assert( IsDefined( self.a.rockets ) );
	
	self endon( "death" );
	
	max_ammo = 1;
	
	for ( ; ; )
	{
	    if ( IsDefined( self.a.rockets ) )
	    	self.a.rockets  = max_ammo;
		wait 0.05;
	}
}

ai_enemy_rpg_drone_init()
{
	self Attach( "weapon_rpg7", "TAG_WEAPON_RIGHT" );
	self UseAnimTree( level.scr_animtree[ "drone" ] );
	self ThermalDrawEnable();
	self SetCanDamage( true );
	self thread ai_enemy_rpg_stand_loop();
	self thread ai_enemy_rpg_drone_on_damage();
	self thread ai_enemy_rpg_drone_monitor_ac130_weapon_fire();
}

ai_enemy_rpg_drone_on_damage()
{
	self endon( "death" );
	
	for ( ; ; )
	{
		// waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags, weapon );
		
		if ( compare( attacker,level.player ) )
			break;
	}
	
	if ( Target_IsTarget( self ) )
    	Target_Remove( self );
    	
	self StartRagdoll();
    
	wait 10;
	
	while( IsDefined( self ) )
	{
		if ( !within_fov_of_players( self.origin, GetDvarFloat( "cg_fov" ) ) )
		{
			self Delete();
			self notify( "death", level.player );
		}
		wait 5;
	}
}

ai_enemy_rpg_drone_monitor_ac130_weapon_fire()
{
	self endon( "death" );
	self endon( "LISTEN_end_ai_monitor_ac130" );
	
	while ( IsDefined( self ) )
	{
				  // waittill( "projectile_impact", weapon_name, position, radius );
	    level.player waittill( "projectile_impact", weapon_name, position );
        
        if ( !IsDefined( self ) )
        	return;
        	
        range = -1;
            
	    switch ( weapon_name )
	    {
	        case "ac130_25mm_alt2":
	            range = 256;
	            break;
	   		case "ac130_40mm_alt2":
	   			range = 768;
	   			break;
	   		case "ac130_105mm_alt2":
	   			range = 1536;
	   			break;
	    }
	    
	    if ( dsq_2d_lt( self.origin, position, range ) )
	    {
	    	if ( Target_IsTarget( self ) )
    			Target_Remove( self );
    	
	    	self StartRagdoll();
    
			wait 10;
			
			while( IsDefined( self ) )
			{
				if ( !within_fov_of_players( self.origin, GetDvarFloat( "cg_fov" ) ) )
				{
					self Delete();
					self notify( "death", level.player );
				}
				wait 5;
			}
			return;
	    }
	}
}

ai_enemy_pilot_init( value, key )
{
    Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self.script_noteworthy = value; 
	
	self ent_flag_init( "FLAG_ai_init" );
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_passenger_init( value, key )
{
    Assert( IsDefined( value ) );
	Assert( IsDefined( key ) );
	
	self ent_flag_init( "FLAG_ai_init" );
	self ent_flag_init( "FLAG_ai_loaded_in_vehicle" );
	self ent_flag_init( "FLAG_ai_unloaded_from_vehicle" );
	
	self.script_noteworthy = value;
	
	self deletable_magic_bullet_shield();
	self thread ai_enemy_passenger_on_damage();
	self thread ai_enemy_passenger_monitor_ac130_weapon_fire();
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_passenger_on_damage()
{
    self endon( "death" );
    
    self ent_flag_wait( "FLAG_ai_init" );
    
    for ( ; ; )
    {
        // waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	    self waittill( "damage", damage, attacker );

	    if ( attacker == level.player || !( self compare_value( "magic_bullet_shield", true ) ) )
	    { 
	    	self ai_disable_magic_bullet_shield();   
	    
	        if ( IsDefined( self.damageweapon ) )
	        {
	            switch( self.damageweapon )
	            {
	                case "ac130_25mm_alt2":
	                    if ( random_chance( .50 ) )
	                    {
		                    num_crawls = RandomIntRange( 2, 3 );
		                    crawl_angle = 0;
		                    crawl_array = ter_op( RandomInt( 2 ), level.scr_anim[ "crawl_death_1" ], level.scr_anim[ "crawl_death_2" ] );

		                    self ai_end_cover_behavior();
		                    self endon( "killanimscript" );
		                    wait 0.05;
		                    self force_crawling_death( crawl_angle, num_crawls, crawl_array );
		                    self notify( "LISTEN_ai_dying" );
		                }
	                    break;
	            }    
	        }
	        wait 0.05;
		    self DoDamage( 1000, self.origin, level.player );
        }
    }
}

ai_enemy_passenger_on_unload()
{
	self endon( "death" );
	
	self ent_flag_wait( "FLAG_ai_unloaded_from_vehicle" );
}

ai_enemy_passenger_monitor_ac130_weapon_fire()
{
	self endon( "death" );
	self endon( "LISTEN_end_ai_monitor_ac130" );
	
	self ent_flag_wait( "FLAG_ai_init" );
	
	while( IsAlive( self ) )
	{
	    self waittill( "LISTEN_projectile_impact", position );
    
		// Check if ai is severly hurt
		        
	    if ( IsDefined( self.script_weapon_used_against_me ) )
	    {
		    weapon_name = self.script_weapon_used_against_me;
		    is_in_range = false;
		             
		    switch ( weapon_name )
		    {
		        case "ac130_25mm_alt2":
		            is_in_range = false;
		            break;
		        case "ac130_40mm_alt2":
		        case "ac130_105mm_alt2":
		            range = 250;
		            is_in_range = dsq_lt( self.origin, position, range );
		            break;
		    }
		            
		    if ( is_in_range )
		    {
		        num_crawls = 20;
		        crawl_angle = 0;
		        crawl_array = ter_op( RandomInt( 2 ), level.scr_anim[ "crawl_death_1" ], level.scr_anim[ "crawl_death_2" ] );
		            
		        self animscripts\shared::DropAllAIWeapons();
		        self force_crawling_death( crawl_angle, num_crawls, crawl_array );
		        self notify( "LISTEN_ai_dying" );
		        wait 0.05;
		        self DoDamage( 1000, self.origin, level.player );
			    return;
		    }
	    }
	}
}

ai_enemy_passenger_monitor_vehicle( vehicle )
{
    Assert( IsDefined( vehicle ) );
    
    self endon( "death" );

    vehicle waittill_any( "death", "LISTEN_death", "LISTEN_helicopter_pickup" );
    
    if ( !( self ent_flag( "FLAG_ai_loaded_in_vehicle" ) ) )
    {
        return_spot = GetNode( self.script_noteworthy + "_return", "targetname" );
        
        if ( IsDefined( return_spot ) )
        {
            self set_goal_node( return_spot );
            
            range = 16.0;
            waittill_ai_in_range_of_ent( self, return_spot, range );
            self Delete();
        }
    }
}

// *************************************
// AI - ENEMY ROUNDABOUT
// *************************************

ai_enemy_roundabout()
{
	self ent_flag_init( "FLAG_ai_init" );
	
	self deletable_magic_bullet_shield();
	self thread ai_enemy_roundabout_on_damage();
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_roundabout_on_damage()
{
    self endon( "death" );
    
    for ( ; ; )
    {
        // waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	    self waittill( "damage", damage, attacker );

	    if ( attacker == level.player || !( self compare_value( "magic_bullet_shield", true ) ) )
	    {    
	        self ai_disable_magic_bullet_shield();
	    
	        if ( IsDefined( self.damageweapon ) )
	        {
	            switch( self.damageweapon )
	            {
	                case "ac130_25mm_alt2":
	                    if ( random_chance( .50 ) )
	                    {
		                    num_crawls = RandomIntRange( 2, 3 );
		                    crawl_angle = 0;
		                    crawl_array = ter_op( RandomInt( 2 ), level.scr_anim[ "crawl_death_1" ], level.scr_anim[ "crawl_death_2" ] );

		                    self ai_end_cover_behavior();
		                    self endon( "killanimscript" );
		                    wait 0.05;
		                    self force_crawling_death( crawl_angle, num_crawls, crawl_array );
		                    self notify( "LISTEN_ai_dying" );
		                }
	                    break;
	            }    
	        }
	        wait 0.05;
		    self DoDamage( 1000, self.origin, level.player );
        }
    }
}

// *************************************
// AI - ENEMY STREET PATROL
// *************************************

ai_enemy_street_patrol_init()
{
	self ent_flag_init( "FLAG_ai_init" );
	
	self deletable_magic_bullet_shield();
	self thread ai_enemy_street_patrol_on_damage();
	self thread ai_enemy_street_patrol_monitor_battle_line();
	self thread ai_enemy_street_patrol_monitor_ac130_weapon_fire();
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_street_patrol_on_damage()
{
    self endon( "death" );
    
    for ( ; ; )
    {
        // waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	    self waittill( "damage", damage, attacker );

	    if ( compare( attacker, level.player ) || self compare_value( "magic_bullet_shield", false ) )
	    {    
	        self ai_disable_magic_bullet_shield();
	    
	        if ( IsDefined( self.damageweapon ) )
	        {
	            switch( self.damageweapon )
	            {
	                case "ac130_25mm_alt2":
	                    if ( random_chance( .75 ) )
	                    {
		                    num_crawls = RandomIntRange( 2, 3 );
		                    crawl_angle = 0;
		                    crawl_array = ter_op( RandomInt( 2 ), level.scr_anim[ "crawl_death_1" ], level.scr_anim[ "crawl_death_2" ] );

		                    self ai_end_cover_behavior();
		                    self endon( "killanimscript" );
		                    wait 0.05;
		                    self force_crawling_death( crawl_angle, num_crawls, crawl_array );
		                    self notify( "LISTEN_ai_dying" );
		                }
	                    break;
	            }    
	        }
	        wait 0.05;
		    self DoDamage( 1000, self.origin, level.player );
        }
    }
}

ai_enemy_street_patrol_monitor_ac130_weapon_fire()
{
	self endon( "death" );
	self endon( "LISTEN_end_ai_monitor_ac130" );
	
	while ( IsDefined( self ) )
	{
				  // waittill( "projectile_impact", weapon_name, position, radius );
	    level.player waittill( "projectile_impact", weapon_name, position );
        
        if ( !IsDefined( self ) )
        	return;
        	
        range = -1;
            
	    switch ( weapon_name )
	    {
	   		case "ac130_40mm_alt2":
	   			range = 384;
	   			break;
	   		case "ac130_105mm_alt2":
	   			range = 768;
	   			break;
	    }
	    
	    if ( dsq_2d_lt( self.origin, position, range, 96.0 ) )
	    {
	    	self DoDamage( 10000, self.origin, level.player );
	    }
	}
}

ai_enemy_street_patrol_monitor_battle_line()
{
	self endon( "death" );
	
	crossed_battle_line = false;
	
	while ( !crossed_battle_line )
	{
		// y = mx + b --> b = y - mx  
		
		battle_line = get_current_battle_line();
		m = get_current_street_slope();
		b = battle_line[ 1 ] - ( m * battle_line[ 0 ] ); // intercept of current battle line
    
    	is_on_left = is_ent_left_of_2d_line( self, m, b );
   		
   		if ( ( m > 0 && is_on_left ) || ( m < 0 && !is_on_left ) )
   			crossed_battle_line = true;
    	wait 0.05;
	}	
	self ai_make_pixie();
	self delayCall( 10.0, ::DoDamage, 10000, self.origin );
}

ai_enemy_street_patrol_run_away_and_die()
{
	self endon( "death" );
	
	wait 10;
	
	self ai_make_pixie();
	
	goal = GetNode( "city_area_run_and_die", "targetname" );
	Assert( IsDefined( goal ) );
	
	self set_goal_node( goal );
	
	while( IsDefined( self ) )
	{
		if ( !within_fov_of_players( self.origin, cos( 55 ) ) )
			self DoDamage( 10000, ( 0, 0, 0 ) );
		wait 5;
	}
}

ai_enemy_street_patrol_fallback()
{
	self endon( "death" );

	time = 0.05;
	_line = level.city_area_current_battle_line + 1;
	_line = ter_op( _line >= level.city_area_battle_lines.size, level.city_area_battle_lines.size - 1, _line );
	
	// Get next battle line, ai will try to fall back behind this battle line
	
	battle_line = get_battle_line( _line );
	
	slope = 1;
	
	switch ( _line )
	{
		case 1:
		case 2:
		case 3:
			slope = 1;
			break;
		case 4:
			slope = 2;
			break;
	}
	
	// Get the current battle line

	// y = mx + b --> b = y - mx  

	m = get_street_slope( slope );
	b = battle_line[ 1 ] - ( m * battle_line[ 0 ] ); // intercept of current battle line

	// First search for a cover node to fall back to
	
	nodes = GetNodesInRadius( self.origin, 2048.0, 0.0 );
	cover_nodes = [];
	path_nodes = [];
	
	foreach ( node in nodes )
	{	
		if ( is_ent_left_of_2d_line( node, m, b ) )
		{
			if ( IsDefined( node.targetname ) && IsSubStr( node.targetname, "enemy" ) )
				cover_nodes[ cover_nodes.size ] = node;
			if ( !IsDefined( node.targetname ) )
				path_nodes[ path_nodes.size ] = node;
		}
	}
	
	cover_nodes = SortByDistance( cover_nodes, self.origin );
	node_found = undefined;
	
	foreach ( node in cover_nodes )
		if ( !IsDefined( node.owner ) )
			node_found = node;
			
	if ( ( level.city_area_current_battle_line + 1 ) < level.city_area_battle_lines.size  && IsDefined( node_found ) )
	{
		self set_goal_node( node_found );
		self thread ai_timed_death_out_of_sight( 5, 1.0 );
	}		
	else if ( path_nodes.size > 0 )
	{
		path_nodes = SortByDistance( path_nodes, self.origin );
		self set_goal_node( path_nodes[ path_nodes.size - 1 ] );
		self thread ai_timed_death_out_of_sight( 10, 1.0 );
	}
}

ai_enemy_street_add_hud_target()
{
	self endon( "death" );
	
	while ( IsDefined( self ) && dsq_2d_lt( self.origin, self.target_point, self.target_radius ) )
		wait 0.05;
	vehicle_scripts\_ac130::hud_add_targets( [ self ] );
}

// *************************************
// AI - ENEMY STREET FLANKING
// *************************************

ai_enemy_street_flanking_init()
{
	self ent_flag_init( "FLAG_ai_init" );
	
	self deletable_magic_bullet_shield();
	//self thread ai_enemy_street_flanking_on_damage();
	self thread ai_enemy_street_patrol_on_damage();
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_enemy_street_flanking_on_damage()
{
    self endon( "death" );
    
    for ( ; ; )
    {
        // waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, dflags );
	    self waittill( "damage", damage, attacker );
	    
        if ( self.damagetaken > self.maxhealth )
        {
        	self ai_disable_magic_bullet_shield();
        	
        	if ( IsDefined( self.damageweapon ) )
        	{
	            switch( self.damageweapon )
	            {
	                case "ac130_25mm_alt2":
	                    if ( random_chance( .50 ) )
	                    {
		                    num_crawls = RandomIntRange( 2, 3 );
		                    crawl_angle = 0;
		                    crawl_array = ter_op( RandomInt( 2 ), level.scr_anim[ "crawl_death_1" ], level.scr_anim[ "crawl_death_2" ] );

		                    self ai_end_cover_behavior();
		                    self endon( "killanimscript" );
		                    wait 0.05;
		                    self force_crawling_death( crawl_angle, num_crawls, crawl_array );
		                    self notify( "LISTEN_ai_dying" );
		                }
	                    break;
	            }
       		}    
        }
        wait 0.05;
	    self DoDamage( 1000, self.origin, level.player );
    }
}

// *************************************
// AI - ENEMY MI17 STREET PATROL
// *************************************

ai_enemy_mi17_street_patrol_init()
{
	self ent_flag_init( "FLAG_ai_init" );
	
	//self deletable_magic_bullet_shield();
	self thread ai_enemy_street_patrol_on_damage();
	
	self ent_flag_set( "FLAG_ai_init" );
}

ai_timed_death_out_of_sight( time, check_frequency )
{
	self endon( "death" );
	
	Assert( IsDefined( time ) );
	Assert( IsDefined( check_frequency ) );
	
	time = ter_op( time < 0.05, 0.05, time );
	check_frequency = ter_op( check_frequency < 0.05, 0.05, check_frequency );
	
	self ai_make_pixie();
	
	elapsed = 0;
	
	while ( IsDefined( self ) && elapsed < time )
	{
		if ( !within_fov_of_players( self.origin, cos( 55 ) ) )
		{
			self DoDamage( 10000, ( 0, 0, 0 ) );
		}
		elapsed += check_frequency;
		wait check_frequency;
	}
}

// *************************************
// AI - GENERIC
// *************************************

ai_ignore_all_after_spawn()
{
	self.ignoreall = true;
	self.ignoreme = true;
	wait 5.0;
	
	if ( IsDefined( self ) )
	{
		self.ignoreall = false;
		self.ignoreme = false;
	}
}

ai_switch_team_after_spawn()
{
	self.team = "team3";
	wait 5.0;
	
	if ( IsDefined( self ) )
		self.team = "axis";
}

ai_make_pixie()
{
	self ai_disable_magic_bullet_shield();
	self.health = 1;	
}

ai_disable_magic_bullet_shield()
{
    if ( self compare_value( "magic_bullet_shield", true ) )
	    self stop_magic_bullet_shield();
}

ai_set_goal_on_notify( goal, type, _notify, min_radius, max_radius, delay )
{
	Assert( IsDefined( goal ) );
	Assert( IsDefined( _notify ) );
	
	type = ter_op( compare( type, "position" ), "position", type );
	min_radius = gt_op( min_radius, 0 );
	max_radius = gt_op( max_radius, min_radius + 0.05 );
	delay = gt_op( delay, 0.05 );
	
	self endon( "death" );
	
	self waittill( _notify );
	wait delay;
	self set_goal_radius( RandomFloatRange( min_radius, max_radius ) );
	
	switch( type )
	{
		case "entity":
			self set_goal_ent( goal );
			break;
		case "node":
			self set_goal_node( goal );
			break;
		case "position":
			self set_goal_pos( goal.origin );
			break;
	}
}

ai_ignoreall( time )
{
	self notify( "LISTEN_end_ai_ignoreall" );
	
	self endon( "LISTEN_end_ai_ignoreall" );
	self endon( "death" );
	
	time = ter_op( IsDefined( time ), time, 0.05 );
	time = ter_op( time > 0, time, 0.05 );
	
	self set_ignoreall( true );
	self delaythread( time, ::set_ignoreall, false );
}

ai_ignoresuppression( time )
{
	self notify( "LISTEN_end_ai_ignoresuppression" );
	
	self endon( "LISTEN_end_ai_ignoresuppression" );
	self endon( "death" );
	
	time = ter_op( IsDefined( time ), time, 0.05 );
	time = ter_op( time > 0, time, 0.05 );
	
	self set_ignoresuppression( true );
	self delaythread( time, ::set_ignoresuppression, false );
}

// *************************************
// AC-130 - HUD
// *************************************

// *************************************
// AC-130
// *************************************

ac130_projectile_callback( weapon, trace )
{
	if ( !IsDefined( weapon ) || !IsDefined( trace ) )
		return;
	
	play_sound = false;
	
	if ( IsDefined( trace[ "position" ] ) && IsDefined( trace[ "surfacetype" ] ) && trace[ "surfactype" ] == "metal" )
	{
		if ( IsDefined( trace[ "entity" ] ) && IsDefined( trace[ "entity" ].classname ) )
		{
			if ( !IsSubStr( trace[ "entity" ].classname, "mi17" ) ||
			    !IsSubStr( trace[ "entity" ].classname, "t72" ) ||
			    !IsSubStr( trace[ "entity" ].classname, "hind" ) ||
			    !IsSubStr( trace[ "entity" ].classname, "btr" ) )
				{
					play_sound = true;
				}
			else
				return;
		}
		else
		{
			play_sound = true;
		}
	}
	else
		return;
		
	if ( play_sound )
	{
		self waittill( "death" );
		if ( IsDefined( self ) && IsDefined( self.origin ) &&
			 dsq_lt( self.origin, trace[ "position" ], 128 ) )
		{
			switch ( weapon )
			{
				case "ac130_40mm_alt2":
					level thread play_sound_in_space( "exp_ac130_40mm_metal", self.origin );
					break;
				case "ac130_105mm_alt2":
					level thread play_sound_in_space( "exp_ac130_105mm_metal", self.origin );
					break;
			}
		}
	}
}
