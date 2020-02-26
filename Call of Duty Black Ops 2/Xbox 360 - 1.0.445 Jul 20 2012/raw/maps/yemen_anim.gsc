#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;
#include maps\yemen_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");

main()
{
	level thread prop_and_vehicle_anims();
	
	// Script sections
	level thread speech_anims();
	//These we are now calling on the fly to save on vars
	//level thread market_anims();
	//level thread terrorist_hunt_anims();
	//level thread metal_storms_anims();
	//level thread morals_anims();
	//level thread morals_rail_anims();
	//level thread hijacked_anims();
	//level thread capture_anims();
	
	level_anims();
	
	precache_assets();
	
	maps\voice\voice_yemen::init_voice();
}

prop_and_vehicle_anims()
{
	add_scene( "menendez_intro_doors", "speech_stage" );
	add_prop_anim( "menendez_chamber_right", %animated_props::o_yemen_01_02_menendez_intro_door_R, undefined, false, true );
	add_prop_anim( "menendez_chamber_left", %animated_props::o_yemen_01_02_menendez_intro_door_L, undefined, false, true );

	add_scene( "speech_opendoors_doors", "speech_stage" );
	add_prop_anim( "menendez_exit_left", %animated_props::o_yemen_01_02_menendez_intro_outside_door_left, undefined, false, true );
	add_prop_anim( "menendez_exit_right", %animated_props::o_yemen_01_02_menendez_intro_outside_door_right, undefined, false, true );
	
	add_scene( "menendez_exit_doors", "speech_stage" );
	add_prop_anim( "menendez_exit_door", %animated_props::o_yemen_01_03_menendez_speech_tower_door, undefined, false, true );

	add_scene( "market_drone_window", "market_align" );
	add_vehicle_anim( "market_drone_window_01", %vehicles::v_yemen_02_02_drones_enter_window_drone_01 );
	
	add_scene( "market_drone_flyby", "market_align" );
	add_vehicle_anim( "market_drone_flyby_01", %vehicles::v_yemen_02_02_drones_enter_flyby_drone_01 );
	add_vehicle_anim( "market_drone_flyby_02", %vehicles::v_yemen_02_02_drones_enter_flyby_drone_02 );
	add_vehicle_anim( "market_drone_flyby_03", %vehicles::v_yemen_02_02_drones_enter_flyby_drone_03 );

	add_scene( "market_drone_ambush", "market_align" );
	add_vehicle_anim( "market_drone_ambush_01", %vehicles::v_yemen_02_02_drones_enter_ambush_drone_01 );
	add_vehicle_anim( "market_drone_ambush_02", %vehicles::v_yemen_02_02_drones_enter_ambush_drone_02 );
	add_vehicle_anim( "market_drone_ambush_03", %vehicles::v_yemen_02_02_drones_enter_ambush_drone_03 );
	
	add_scene( "morals_vtol_crashing", "morals_align" );
	add_vehicle_anim( "morals_vtol_1", %vehicles::fxanim_yemen_vtol2_vtol_anim ); //, false, undefined, undefined, true, "heli_v78_yemen", undefined, undefined, true );
	add_notetrack_custom_function( "market_vtol", undefined, ::turn_off_vehicle_exhaust );
	add_notetrack_custom_function( "market_vtol", undefined, ::turn_off_vehicle_tread_fx );
	add_notetrack_custom_function( "market_vtol", undefined, maps\yemen_market::market_vtol_crash_callback );
	add_notetrack_fx_on_tag( "morals_vtol", undefined, "explosion_midair_heli", "tag_origin" );
	add_notetrack_fx_on_tag( "morals_vtol", undefined, "explosion_midair_heli_engine1", "tag_engine_right" );
	
	add_scene( "market_vtol_loop", "market_vtol_align", false, false, true );
	add_vehicle_anim( "market_vtol", %vehicles::fxanim_yemen_vtol1_veh_loop_anim, false, undefined, undefined, true, "heli_v78_yemen", undefined, undefined, true );
	
	add_scene( "market_vtol_crash", "market_vtol_align" );
	add_vehicle_anim( "market_vtol", %vehicles::fxanim_yemen_vtol1_veh_crash_anim, false, undefined, undefined, true, "heli_v78_yemen", undefined, undefined, true );
	add_notetrack_custom_function( "market_vtol", undefined, ::turn_off_vehicle_exhaust );
	add_notetrack_custom_function( "market_vtol", undefined, ::turn_off_vehicle_tread_fx );
	add_notetrack_custom_function( "market_vtol", undefined, maps\yemen_market::market_vtol_crash_callback );
	add_notetrack_fx_on_tag( "market_vtol", undefined, "explosion_midair_heli", "tag_origin" );
	
	add_scene( "speech_vtol_crash", "speech_vtol", false, false, false, true );
	add_vehicle_anim( "speech_vtol", %vehicles::fxanim_yemen_speech_vtol_anim, true, undefined, undefined, true, undefined, undefined, undefined, true );
	add_notetrack_custom_function( "speech_vtol", undefined, ::turn_off_vehicle_exhaust );
	add_notetrack_custom_function( "speech_vtol", undefined, ::turn_off_vehicle_tread_fx );
//	add_notetrack_custom_function( "speech_vtol", undefined, maps\yemen_market::speech_vtol_crash_callback );
	add_notetrack_fx_on_tag( "speech_vtol", undefined, "explosion_midair_heli", "tag_origin" );
}

speech_anims()
{
	// Menendez Intro
	add_scene( "speech_menendez_intro", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_02_menendez_intro_menendez, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_notetrack_level_notify( "menendez_speech", "start_hallway_guards", "start_hallway_guards" );
	
	add_scene( "speech_menendez_walk_hallway", "speech_stage" );
	add_notetrack_custom_function( "menendez_speech", "open_chamber_doors", maps\yemen_speech::menendez_intro_opendoors );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_02_menendez_intro_menendez_hallway_walk, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "speech_player_intro", "speech_stage" );
	add_player_anim( "player_body", %player::p_yemen_01_02_menendez_intro_player, true, 0, undefined, true, 1, 10, 10, 10, 10 );
	add_notetrack_custom_function( "player_body", "give_control", maps\yemen_speech::menendez_intro_unlink_player );
	add_notetrack_custom_function( "player_body", "dof_menendez", maps\createart\yemen_art::dof_menendez );
	add_notetrack_custom_function( "player_body", "dof_room", maps\createart\yemen_art::dof_room );
	
	add_scene( "speech_menendez_hallway_endidle", "speech_stage", false, false, true );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_02_menendez_intro_menendez_end_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "speech_greeter_intro_1", "speech_stage" );
	add_actor_anim( "intro_greeter_1", %generic_human::ch_yemen_01_02_menendez_intro_greet1 );
	add_actor_spawner( "intro_greeter_1", "intro_salute_guy" );
	
	add_scene( "speech_greeter_intro_2", "speech_stage" );
	add_actor_anim( "intro_greeter_2", %generic_human::ch_yemen_01_02_menendez_intro_greet2 );
	add_actor_spawner( "intro_greeter_2", "intro_salute_guy" );
	
	add_scene( "speech_greeter_intro_1_endloop", "speech_stage", false, false, true );
	add_actor_anim( "intro_greeter_1", %generic_human::ch_yemen_01_02_menendez_intro_greet1_endloop, false, false, true );
	
	add_scene( "speech_greeter_intro_2_endloop", "speech_stage", false, false, true );
	add_actor_anim( "intro_greeter_2", %generic_human::ch_yemen_01_02_menendez_intro_greet2_endloop, false, false, true );

	// Salute Anim
	add_scene( "speech_intro_salute", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_1", %generic_human::ch_yemen_01_02_menendez_intro_salute1, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_2", %generic_human::ch_yemen_01_02_menendez_intro_salute2, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_3", %generic_human::ch_yemen_01_02_menendez_intro_salute3, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_a", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_a", %generic_human::ch_yemen_01_02_menendez_intro_salute_A, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_aa", %generic_human::ch_yemen_01_02_menendez_intro_salute_AA, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_b", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_b", %generic_human::ch_yemen_01_02_menendez_intro_salute_B, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_bb", %generic_human::ch_yemen_01_02_menendez_intro_salute_BB, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	// Gropu C has no CC.
	add_scene( "speech_intro_salute_c", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_c", %generic_human::ch_yemen_01_02_menendez_intro_salute_C, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_d", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_d", %generic_human::ch_yemen_01_02_menendez_intro_salute_D, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_dd", %generic_human::ch_yemen_01_02_menendez_intro_salute_DD, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_e", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_e", %generic_human::ch_yemen_01_02_menendez_intro_salute_E, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ee", %generic_human::ch_yemen_01_02_menendez_intro_salute_EE, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_f", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_f", %generic_human::ch_yemen_01_02_menendez_intro_salute_F, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ff", %generic_human::ch_yemen_01_02_menendez_intro_salute_FF, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	// Group G is just GG.
	add_scene( "speech_intro_salute_g", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_gg", %generic_human::ch_yemen_01_02_menendez_intro_salute_GG, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_h", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_h", %generic_human::ch_yemen_01_02_menendez_intro_salute_H, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_hh", %generic_human::ch_yemen_01_02_menendez_intro_salute_HH, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_i", "speech_stage" );
	add_actor_model_anim( "intro_salute_guy_i", %generic_human::ch_yemen_01_02_menendez_intro_salute_I, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ii", %generic_human::ch_yemen_01_02_menendez_intro_salute_II, undefined, !SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	// Salute End Loop
	add_scene( "speech_intro_salute_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_1", %generic_human::ch_yemen_01_02_menendez_intro_salute1_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_2", %generic_human::ch_yemen_01_02_menendez_intro_salute2_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_3", %generic_human::ch_yemen_01_02_menendez_intro_salute3_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );

	add_scene( "speech_intro_salute_a_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_a", %generic_human::ch_yemen_01_02_menendez_intro_salute_A_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_aa", %generic_human::ch_yemen_01_02_menendez_intro_salute_AA_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );

	add_scene( "speech_intro_salute_b_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_b", %generic_human::ch_yemen_01_02_menendez_intro_salute_B_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_bb", %generic_human::ch_yemen_01_02_menendez_intro_salute_BB_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );

	// Group C has no CC
	add_scene( "speech_intro_salute_c_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_c", %generic_human::ch_yemen_01_02_menendez_intro_salute_C_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_d_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_d", %generic_human::ch_yemen_01_02_menendez_intro_salute_D_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_dd", %generic_human::ch_yemen_01_02_menendez_intro_salute_DD_end_loop, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );

	add_scene( "speech_intro_salute_e_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_e", %generic_human::ch_yemen_01_02_menendez_intro_salute_E_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ee", %generic_human::ch_yemen_01_02_menendez_intro_salute_EE_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );

	add_scene( "speech_intro_salute_f_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_f", %generic_human::ch_yemen_01_02_menendez_intro_salute_F_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ff", %generic_human::ch_yemen_01_02_menendez_intro_salute_FF_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	// Group G is just GG.
	add_scene( "speech_intro_salute_g_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_gg", %generic_human::ch_yemen_01_02_menendez_intro_salute_GG_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_h_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_h", %generic_human::ch_yemen_01_02_menendez_intro_salute_H_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_hh", %generic_human::ch_yemen_01_02_menendez_intro_salute_HH_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	add_scene( "speech_intro_salute_i_endloop", "speech_stage", false, false, true );
	add_actor_model_anim( "intro_salute_guy_i", %generic_human::ch_yemen_01_02_menendez_intro_salute_I_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "intro_salute_guy_ii", %generic_human::ch_yemen_01_02_menendez_intro_salute_II_loop_end, undefined, SCENE_DELETE, undefined, undefined, "intro_salute_guy" );
	
	// Speech walk
	add_scene( "speech_walk_with_defalco", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_walk_with_defalco, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_notetrack_flag( "menendez_speech", "enter_vtol", "speech_start_vtol" );
	
	add_scene( "speech_walk_with_defalco_player", "speech_stage" );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_walk_with_defalco, true, 0, undefined, true, 1, 30, 30, 30, 30 );

	add_scene( "speech_walk_with_defalco_defalco", "speech_stage" );
	add_actor_anim( "defalco_speech", %generic_human::ch_yemen_01_03_menendez_speech_defalco_walk_with_defalco, true, false );
	
	add_scene_loop( "speech_walk_stage_guards", "speech_stage" );
	add_actor_model_anim( "stage_guard_01", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_01_loop, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_guard_02", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_02_loop, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_guard_03", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_03_loop, undefined, false, undefined, undefined, "court_terrorists" );
	
	add_scene( "vtols_arrive_stage_guards", "speech_stage" );
	add_actor_model_anim( "stage_guard_01", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_01, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_guard_02", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_02, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_guard_03", %generic_human::ch_yemen_01_04_menendez_shoot_drones_guard_03, undefined, false, undefined, undefined, "court_terrorists" );
	add_notetrack_custom_function( "stage_guard_01", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_guard_02", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_guard_03", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_guard_01", "dead", maps\yemen_speech::drone_remove_collision );
	add_notetrack_custom_function( "stage_guard_02", "dead", maps\yemen_speech::drone_remove_collision );
	add_notetrack_custom_function( "stage_guard_03", "dead", maps\yemen_speech::drone_remove_collision );
	
	add_scene( "stage_backup_guards", "speech_stage" );
	add_actor_model_anim( "stage_backup_01", %generic_human::ch_yemen_01_03_menendez_speech_terrorist1, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_backup_02", %generic_human::ch_yemen_01_03_menendez_speech_terrorist2, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_backup_03", %generic_human::ch_yemen_01_03_menendez_speech_terrorist3, undefined, false, undefined, undefined, "court_terrorists" );
	add_actor_model_anim( "stage_backup_04", %generic_human::ch_yemen_01_03_menendez_speech_terrorist4, undefined, false, undefined, undefined, "court_terrorists" );
	add_notetrack_custom_function( "stage_backup_01", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_backup_02", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_backup_03", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_backup_04", "shoot", maps\yemen_utility::notetrack_drone_shoot );
	add_notetrack_custom_function( "stage_backup_01", "dead", maps\yemen_speech::drone_remove_collision );
	add_notetrack_custom_function( "stage_backup_02", "dead", maps\yemen_speech::drone_remove_collision );
	add_notetrack_custom_function( "stage_backup_03", "dead", maps\yemen_speech::drone_remove_collision );
	add_notetrack_custom_function( "stage_backup_04", "dead", maps\yemen_speech::drone_remove_collision );
	
	add_scene( "speech_walk_no_defalco_player", "speech_stage" );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_walk_no_defalco, true, 0, undefined, true, 1, 30, 30, 30, 30 );
	add_notetrack_custom_function( "player_body", "player_turn", maps\yemen_speech::player_turn );
	add_notetrack_custom_function( "player_body", "menendez_grabs_player", maps\yemen_speech::menendez_grabs_player );
	add_notetrack_custom_function( "player_body", "player_turns_back", maps\yemen_speech::player_turns_back );
	add_notetrack_custom_function( "player_body", "dof_menendez_1", maps\createart\yemen_art::dof_menendez_1 );
	add_notetrack_custom_function( "player_body", "dof_crowd", maps\createart\yemen_art::dof_goons );
	add_notetrack_custom_function( "player_body", "dof_menendez_2", maps\createart\yemen_art::dof_menendez_2 );
	add_notetrack_custom_function( "player_body", "dof_vtol", maps\createart\yemen_art::dof_vtol );
	add_notetrack_custom_function( "player_body", "dof_menendez_3", maps\createart\yemen_art::dof_menendez_3 );
	
	add_scene( "speech_walk_no_defalco", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_walk_no_defalco, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_notetrack_flag( "menendez_speech", "enter_vtol", "speech_start_vtol" );
	add_notetrack_custom_function( "menendez_speech", "open_tower_door", maps\yemen_speech::menendez_exit_opendoors );
	add_notetrack_custom_function( "menendez_speech", "open_outside_doors", maps\yemen_speech::menendez_speech_opendoors );
	add_notetrack_level_notify( "menendez_speech", "start_onstage_terrorists", "speech_backup_spawn" );
	add_notetrack_level_notify( "menendez_speech", "fire", "menendez_fire" );
	
	add_scene( "speech_defalco_endidl", "speech_stage", false, false, true );
	add_actor_anim( "defalco_speech", %generic_human::ch_yemen_01_03_menendez_speech_defalco_endidl, true, true );
	
	// Speech talk
	add_scene( "speech_talk", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_talk, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_talk, true, 0, undefined, true, 1, 20, 20, 20, 20 );
		
	add_scene( "vtols_arrive", "speech_stage" );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_vtol_react, true, 0, undefined, true, 1, 20, 20, 20, 20 );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_vtol_react, false );

	add_scene( "vtols_arrive_defalco", "speech_stage" );
	add_actor_model_anim( "defalco_guard_01", %generic_human::ch_yemen_01_04_defalco_guardL_vtol_leave, undefined, true, undefined, undefined, "intro_salute_guy" );
	add_actor_model_anim( "defalco_guard_02", %generic_human::ch_yemen_01_04_defalco_guardR_vtol_leave, undefined, true, undefined, undefined, "intro_salute_guy" );
	add_actor_anim( "defalco_speech", %generic_human::ch_yemen_01_04_defalco_vtol_leave, true, false, true );
	
	/* Shoot at quadrotors in square */
	add_scene( "shooting_drones_ter1", "speech_stage" );
	add_actor_anim( "shooting_drones_ter1", %generic_human::ch_yemen_02_02_shooting_drones_ter1, false, false, false, false, undefined, "court_terrorists" );
	
	add_scene( "shooting_drones_ter2", "speech_stage" );
	add_actor_anim( "shooting_drones_ter2", %generic_human::ch_yemen_02_02_shooting_drones_ter2, false, false, false, false, undefined, "court_terrorists" );
	
	add_scene( "shooting_drones_ter3", "speech_stage" );
	add_actor_anim( "shooting_drones_ter3", %generic_human::ch_yemen_02_02_shooting_drones_ter3, false, false, false, false, undefined, "court_terrorists" );
	
	add_scene( "shooting_drones_ter4", "speech_stage" );
	add_actor_anim( "shooting_drones_ter4", %generic_human::ch_yemen_02_02_shooting_drones_ter4, false, false, false, false, undefined, "court_terrorists" );
	
	add_scene( "shooting_drones_ter5", "speech_stage" );
	add_actor_anim( "shooting_drones_ter5", %generic_human::ch_yemen_02_02_shooting_drones_ter5, false, false, false, false, undefined, "court_terrorists" );
	
	add_scene( "shooting_drones_ter6", "speech_stage" );
	add_actor_anim( "shooting_drones_ter6", %generic_human::ch_yemen_02_02_shooting_drones_ter6, false, false, false, false, undefined, "court_terrorists" );
	
	level.scr_animtree[ "crowd_guy" ] = #animtree;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_idle" ][0] = %generic_human::ch_yemen_01_03_menendez_speech_crowd_idle_01;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_cheer" ][0] = %generic_human::ch_yemen_01_03_menendez_speech_crowd_idle_02;
	
	level.drones.anims[ "speech_crowd_idle" ][0] = %fakeShooters::ch_yemen_01_03_menendez_speech_crowd_idle_01;
	level.drones.anims[ "speech_crowd_cheer" ][0] = %fakeShooters::ch_yemen_01_03_menendez_speech_crowd_idle_02;
	
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_cheer" ][0]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_fistpump_guy01;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_cheer" ][1]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_fistpump_guy02;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_idle" ][0]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_idle_guy01;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_idle" ][1]		= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_idle_guy02;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_runaway" ][0]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_runaway_guy01;
	level.scr_anim[ "crowd_guy" ][ "speech_crowd_runaway" ][1]	= %fakeshooters::ch_yemen_01_04_menendez_intro_crowd_runaway_guy02;
}

#using_animtree( "animated_props" );
market_anims()
{
	add_scene( "market_hold_belly", "market_hold_belly_align" );
	add_actor_anim( "hold_belly_guy", %generic_human::ch_yemen_02_02_wounded_terrorists_hold_belly );
	
	add_scene( "market_crouch_shot_die", "market_crouch_shot_die_align" );
	add_actor_anim( "crouch_shot_die_guy", %generic_human::ch_yemen_02_02_wounded_crouch_shot_die );
	
	// TABLE FLIPS
	add_scene( "table_flip_01", "table_flip_01", SCENE_REACH );
	add_actor_anim( "table_flip_01", %generic_human::ch_yemen_02_02_table_flip_guy01 );
	add_prop_anim( "table_flip_01_table", %animated_props::o_yemen_02_02_table_flip_table, "p6_street_vendor_goods_table02", false, true, undefined, undefined, true );
	
//	add_scene( "table_flip_02", "table_flip_02", SCENE_REACH );
//	add_actor_anim( "table_flip_02", %generic_human::ch_yemen_02_02_table_flip_guy01 );
//	add_prop_anim( "table_flip_02_table", %animated_props::o_yemen_02_02_table_flip_table, "p6_street_vendor_goods_table02", false, true, undefined, undefined, true );
	
	add_scene( "table_flip_03", "table_flip_03", SCENE_REACH );
	add_actor_anim( "table_flip_03", %generic_human::ch_yemen_02_02_table_flip_guy01 );
	add_prop_anim( "table_flip_03_table", %animated_props::o_yemen_02_02_table_flip_table, "p6_street_vendor_goods_table02", false, true, undefined, undefined, true );
	
	add_scene( "table_flip_04", "table_flip_04", SCENE_REACH );
	add_actor_anim( "table_flip_04", %generic_human::ch_yemen_02_02_table_flip_guy01 );
	add_prop_anim( "table_flip_04_table", %animated_props::o_yemen_02_02_table_flip_table, "p6_street_vendor_goods_table02", false, true, undefined, undefined, true );
	//////////////
	
	add_scene( "car_flip", "car_flip" );
	add_actor_anim( "car_flip_guy01", %generic_human::ch_yemen_02_02_car_flip_guy01, false, false, false, true, undefined, "car_flip_guys" );
	add_notetrack_custom_function( "car_flip_guy01", undefined, maps\yemen_market::car_flip_guy01 );
	add_actor_anim( "car_flip_guy02", %generic_human::ch_yemen_02_02_car_flip_guy02, false, false, false, true, undefined, "car_flip_guys" );
	add_notetrack_custom_function( "car_flip_guy02", undefined, maps\yemen_market::car_flip_guy02 );
	add_prop_anim( "car_flip", %animated_props::v_yemen_02_02_car_flip_car, undefined, false, true, undefined, undefined, true );
	
	add_scene( "pushcart", "pushcart" );
	add_actor_anim( "pushcart_guy01", %generic_human::ch_yemen_02_02_pushcart_guy01 );
	add_notetrack_custom_function( "pushcart_guy01", undefined, maps\yemen_market::pushcart_guy01 );
	add_actor_anim( "pushcart_guy02", %generic_human::ch_yemen_02_02_pushcart_guy02, false, false, false, false, undefined, "pushcart_guy01" );
	add_notetrack_custom_function( "pushcart_guy02", undefined, maps\yemen_market::pushcart_guy02 );
	add_prop_anim( "pushcart_cart", %animated_props::o_yemen_02_02_pushcart_cart, "p6_street_vendor_cover_cart_anim", false, false, undefined, undefined, true );
	
	add_scene( "melee_01", "melee_01_node", SCENE_REACH );
	add_actor_anim( "melee_01_yemeni", %generic_human::ai_melee_R_attack );
	add_actor_anim( "melee_01_terrorist", %generic_human::ai_melee_R_defend );
	
	add_scene( "rolling_door", "align_rolling_door" );
	add_actor_anim( "rolling_door_01", %generic_human::ch_pan_02_12_rolling_door_guy_1 );
	add_notetrack_custom_function( "rolling_door_01", undefined, maps\yemen_market::rolling_door1_01 );
	add_actor_anim( "rolling_door_02", %generic_human::ch_pan_02_12_rolling_door_guy_2 );
	add_notetrack_custom_function( "rolling_door_02", undefined, maps\yemen_market::rolling_door1_02 );
	
	add_scene( "rolling_door2", "align_rolling_door2" );
	add_actor_anim( "rolling_door_2_01", %generic_human::ch_yemen_02_02_roll_under_door_guy01 );
	add_notetrack_custom_function( "rolling_door_2_01", undefined, maps\yemen_market::rolling_door_2_01 );
	add_actor_anim( "rolling_door_2_02", %generic_human::ch_yemen_02_02_roll_under_door_guy02 );
	add_notetrack_custom_function( "rolling_door_2_02", undefined, maps\yemen_market::rolling_door_2_02 );
	
	add_scene( "window_explosion_01", "align_window_explosion_01" );
	add_actor_anim( "window_explosion_01", %generic_human::ch_gen_xplode_death_3, true, false, false, true );
	add_notetrack_exploder( "window_explosion_01", undefined, 890 );
	
	add_scene( "pushcart_right", "pushcart_right" );
	add_actor_anim( "pushcart_right_guy", %generic_human::ch_yemen_02_02_pushcart_right_guy01 );
	add_notetrack_custom_function( "pushcart_right_guy", undefined, maps\yemen_market::pushcart_right_guy );
	add_prop_anim( "pushcart_right_cart", %animated_props::o_yemen_02_02_pushcart_right_cart, "p6_street_vendor_cover_cart_anim", false, false, undefined, undefined, true );
	
	add_scene( "bruteforce_perk", "bruteforce_case" );
	add_player_anim( "player_body", %player::int_specialty_yemen_bruteforce, true );
	add_prop_anim( "bruteforce_case", %animated_props::o_specialty_yemen_bruteforce_cabinet );
	add_prop_anim( "jaws", %animated_props::o_specialty_yemen_bruteforce_jaws, "t6_wpn_jaws_of_life_prop", true );
	add_prop_anim( "sword", %animated_props::o_specialty_yemen_bruteforce_sword, "t6_wpn_pulwar_sword_view", true );
	
	precache_assets( true );
}

terrorist_hunt_anims()
{
	//flag_wait( "terrorist_hunt_start" );
	
	add_scene( "rocket_hall_intro", "rockethall_align" );
	//add_actor_anim( "rocket_hall_hand_guy", %generic_human::ch_yemen_03_03_xm25_hand_gun_char_01 );
	//add_actor_anim( "rocket_hall_guy1", %generic_human::ch_yemen_03_03_xm25_hand_gun_char_01 );
	add_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_intro_char_02, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	add_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_intro_char_03, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	add_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_intro_char_04, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	add_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_intro_char_06, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	add_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_intro_char_07, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	add_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_intro_char_08, undefined, undefined, undefined, undefined, undefined, "rocket_hall_anim_guys" );
	
	add_scene( "rocket_hall_reaction_to_gun", "rockethall_align" );
//	add_optional_actor_anim( "rocket_hall_guy1", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_01 );
	add_optional_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_02 );
//	add_optional_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_03 );
//	add_optional_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_04 );
	add_optional_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_06 );
	add_optional_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_07 );
	add_optional_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_08 );
	//add_optional_actor_anim( "player_body", %player::p_yemen_03_03_xm25_reaction_to_drawing_gun, false, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );

//	add_scene( "rocket_hall_reaction_to_firing", "rockethall_align" );
//	add_optional_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_02 );
//	add_optional_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_03 );
//	add_optional_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_04 );
	
	add_scene( "rocket_hall_death_zone_1", "rockethall_align" );	// these all play if the rocket explodes in zone 1
	add_optional_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_deaths_char_06, false, false, true, !SCENE_ALLOW_DEATH );
	add_optional_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_deaths_char_08, false, false, true, !SCENE_ALLOW_DEATH );
	
	add_scene( "rocket_hall_death_zone_2", "rockethall_align" );
	add_optional_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_deaths_char_02, false, false, true, !SCENE_ALLOW_DEATH );
	add_optional_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_deaths_char_03, false, false, true, !SCENE_ALLOW_DEATH );
	add_optional_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_deaths_char_04, false, false, true, !SCENE_ALLOW_DEATH );
	add_optional_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_deaths_char_07, false, false, true, !SCENE_ALLOW_DEATH );
	
//	add_scene( "rocket_hall_death_zone_3", "rockethall_align" );
//	add_optional_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_deaths_char_07 );
//
//	add_scene( "rocket_hall_death_zone_4", "rockethall_align" );
//	add_optional_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_deaths_char_07 );

	precache_assets( true );
}

metal_storms_anims()
{
	add_scene( "courtyard_balcony_deaths", "metalstorms_align" );
	add_actor_anim( "courtyard_balcony_guy_1", %generic_human::ch_yemen_04_01_xplode_death_guy1 );
	add_actor_anim( "courtyard_balcony_guy_2", %generic_human::ch_yemen_04_01_xplode_death_guy2 );
	add_actor_anim( "courtyard_balcony_guy_3", %generic_human::ch_yemen_04_01_xplode_death_guy3 );
	add_actor_anim( "courtyard_balcony_guy_4", %generic_human::ch_yemen_04_01_xplode_death_guy4 );
	
	precache_assets( true );
}

morals_anims()
{
	add_scene( "morals_menendez_wait", "morals_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_01_waiting_menendez, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_prop_anim( "fhj_morals", %animated_props::o_yemen_05_01_waiting_fhj18, "t6_wpn_launch_fhj18_world" );
	
	add_scene( "morals_menendez_call_farid", "morals_align" );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_01_call_farid_menendez, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_prop_anim( "fhj_morals", %animated_props::o_yemen_05_01_call_farid_fhj18 );
			
	add_scene( "morals_menendez_call_farid_idle", "morals_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_01_call_farid_idle_menendez, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_prop_anim( "fhj_morals", %animated_props::o_yemen_05_01_call_farid_idle_fhj18 );
	
	add_scene( "morals_shoot_vtol", "morals_align" );
	add_player_anim( "player_body", %player::p_yemen_05_01_shoot_vtol_player, !SCENE_DELETE, undefined, undefined, true, 1, 10, 10, 10, 10, false, false, true );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_01_shoot_vtol_menendez, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );	
	add_prop_anim( "fhj_morals", %animated_props::o_yemen_05_01_shoot_vtol_fhj18 );
	add_notetrack_custom_function( "menendez_morals", "fire_rocket", maps\yemen_morals::morals_shoot_vtol_fire_rocket );
	add_notetrack_custom_function( "player_body", "dof_1", maps\createart\yemen_art::dof_shoot_vtol1 );
	add_notetrack_custom_function( "player_body", "dof_2", maps\createart\yemen_art::dof_shoot_vtol2 );
	
	add_scene( "morals_capture_approach", "morals_align" );
	add_player_anim( "player_body", %player::p_yemen_05_03_capture_approach_player );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_capture_approach_harper );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_capture_approach_menendez );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_capture_approach_redshirt01 );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_capture_approach_redshirt02 );
	add_prop_anim( "fhj_morals", %animated_props::o_yemen_05_03_capture_approach_fhj18, "t6_wpn_launch_fhj18_world" );
	add_prop_anim( "morals_fn57", %animated_props::o_yemen_05_03_capture_approach_fn57, "t6_wpn_pistol_fiveseven_prop" );
	add_notetrack_custom_function( "player_body", "dof_3", maps\createart\yemen_art::dof_shoot_vtol3 );
	
	add_scene( "morals_capture", "morals_align" );
	add_player_anim( "player_body", %player::p_yemen_05_03_capture_player );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_capture_harper );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_capture_menendez );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_capture_redshirt01 );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_capture_redshirt02 );
	add_prop_anim( "morals_fn57", %animated_props::o_yemen_05_03_capture_fn57 );
	add_notetrack_custom_function( "player_body", "start_choice", maps\yemen_morals::morals_capture_start_choice );
	add_notetrack_custom_function( "player_body", "dof_4", maps\createart\yemen_art::dof_shoot_vtol4 );
	add_notetrack_custom_function( "player_body", "dof_5", maps\createart\yemen_art::dof_shoot_vtol5 );
	

	add_scene( "morals_shoot_menendez", "morals_align" );
	add_player_anim( "player_body", %player::p_yemen_05_04_shoot_menendez_player, SCENE_DELETE );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_04_shoot_menendez_harper );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_04_shoot_menendez_menendez, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_04_shoot_menendez_redshirt01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_04_shoot_menendez_redshirt02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_prop_anim( "morals_fn57", %animated_props::o_yemen_05_04_shoot_menendez_fn57, undefined, SCENE_DELETE );
	add_notetrack_custom_function( "player_body", "dof_6", maps\createart\yemen_art::dof_shoot_vtol6 );
	add_notetrack_custom_function( "player_body", "dof_7", maps\createart\yemen_art::dof_shoot_vtol7 );
	add_notetrack_custom_function( "player_body", "dof_8", maps\createart\yemen_art::dof_shoot_vtol8 );
	add_notetrack_custom_function( "player_body", "dof_9", maps\createart\yemen_art::dof_shoot_vtol9 );
	add_notetrack_custom_function( "player_body", "dof_10", maps\createart\yemen_art::dof_shoot_vtol10 );
	
	add_scene( "morals_shoot_harper", "morals_align" );
	add_player_anim( "player_body", %player::p_yemen_05_04_shoot_harper_player );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_04_shoot_harper_harper );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_04_shoot_harper_menendez, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_04_shoot_harper_redshirt01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_04_shoot_harper_redshirt02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_prop_anim( "morals_fn57", %animated_props::o_yemen_05_04_shoot_harper_fn57, undefined, SCENE_DELETE );
	add_notetrack_custom_function( "player_body", "explosion", maps\yemen_morals::morals_shoot_harper_explosion );
//	add_notetrack_custom_function( "player_body", "spawn_vtol", maps\yemen_morals::morals_shoot_harper_spawn_vtol );
add_notetrack_custom_function( "player_body", "dof_11", maps\createart\yemen_art::dof_shoot_vtol11 );
add_notetrack_custom_function( "player_body", "dof_12", maps\createart\yemen_art::dof_shoot_vtol12 );
add_notetrack_custom_function( "player_body", "dof_13", maps\createart\yemen_art::dof_shoot_vtol13 );
add_notetrack_custom_function( "player_body", "dof_14", maps\createart\yemen_art::dof_shoot_vtol14 );
add_notetrack_custom_function( "player_body", "dof_15", maps\createart\yemen_art::dof_shoot_vtol15 );
	
	add_scene( "morals_shoot_harper_vtol", "morals_align" );
	add_vehicle_anim( "morals_shoot_harper_vtol", %vehicles::v_yemen_05_04_shoot_harper_vtol, SCENE_DELETE );
	add_prop_anim( "morals_shoot_harper_rocket", %animated_props::o_yemen_05_04_shoot_harper_missle, "iw_proj_sidewinder_missile_x2", SCENE_DELETE );
	
/*	level.scr_model["morals_gun"] = "t6_wpn_pistol_m1911_view";
	level.scr_animtree["morals_gun"] = #animtree;
	
	// Gun fire anims
	level.scr_anim[ "player_body" ][ "thumb_to_hammer_up" ] = %player::int_yemen_05_03_aim_at_han_thumb_idle_2_up;
	level.scr_anim[ "player_body" ][ "thumb_to_hammer_down" ] = %player::int_yemen_05_03_aim_at_han_thumb_up_2_idle;
	level.scr_anim[ "player_body" ][ "hammer_down_2_up" ] = %player::int_yemen_05_03_aim_at_han_hammer_down_2_up;
	level.scr_anim[ "player_body" ][ "hammer_up_2_down" ] = %player::int_yemen_05_03_aim_at_han_hammer_up_2_down;
	level.scr_anim[ "player_body" ][ "hammer_finish" ] = %player::int_yemen_05_03_aim_at_han_hammerfinish ;
	
	level.scr_anim[ "morals_gun" ][ "hammer_down_2_up" ] = %animated_props::o_yemen_05_03_aim_at_han_gun_hammer_down_2_up;
	level.scr_anim[ "morals_gun" ][ "hammer_up_2_down" ] = %animated_props::o_yemen_05_03_aim_at_han_gun_hammer_up_2_down;
	
	level.scr_anim[ "player_body" ][ "morals_fire" ] = %player::int_yemen_05_03_aim_at_han_fire;
	level.scr_anim[ "morals_gun" ][ "morals_fire" ] = %animated_props::o_yemen_05_03_aim_at_han_fire_gun;
	
	//flag_wait( "morals_start" );

//	add_scene( "morals_vtol_wreck", "morals_align" );
//	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_02_vtol_wreck_menendez );
//	add_player_anim( "player_body", %player::p_yemen_05_02_vtol_wreck, false, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );
//
//	add_scene( "morals_pilot_torture", "morals_align" );
//	add_actor_anim( "pilot_morals", %generic_human::ch_yemen_05_02_vtol_wreck_pilot, false, false, true );
//	add_actor_anim( "terrorist_morals_01", %generic_human::ch_yemen_05_02_vtol_wreck_terrorist_01, false, false, true );
//	add_actor_anim( "terrorist_morals_02", %generic_human::ch_yemen_05_02_vtol_wreck_terrorist_02, false, false, true );
//	add_actor_anim( "terrorist_morals_03", %generic_human::ch_yemen_05_02_vtol_wreck_terrorist_03, false, false, true );

	add_scene( "morals_execution_approach", "morals_align" );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_execution_menendez );
	add_player_anim( "player_body", %player::p_yemen_05_03_execution, false, undefined, undefined, true, 1, 45, 10, 15, 15, true, true );

	add_scene( "morals_execution_approach_others", "morals_align" );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_execution_terrorist_01 );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_execution_terrorist_02 );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_execution_harper, true, false );
	add_actor_anim( "defalco_morals", %generic_human::ch_yemen_05_03_execution_defalco, true, false );
*/	
	add_scene( "morals_execution_pilot", "morals_align" );
	add_actor_anim( "pilot_morals", %generic_human::ch_yemen_05_03_execution_pilot02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_01", %generic_human::ch_yemen_05_03_execution_pilot01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_02", %generic_human::ch_yemen_05_03_execution_pilot03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "terrorist_morals_03", %generic_human::ch_yemen_05_03_execution_pilot04, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

/*	
//	add_scene( "morals_aim_at_harper", "morals_align" );
//	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_aim_at_han_menendez );
//	add_actor_anim( "defalco_morals", %generic_human::ch_yemen_05_03_aim_at_han_defalco );
//	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_aim_at_han_han );
//	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_aim_at_han_terrorist_01 );
//	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_aim_at_han_terrorist_02 );
//	add_player_anim( "player_body", %player::p_yemen_05_03_aim_at_han, false, undefined, undefined, false );

	add_scene( "morals_execution_aim_at_harper", "morals_align", false, false, true );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_execution_loop_menendez );
	add_actor_anim( "defalco_morals", %generic_human::ch_yemen_05_03_execution_loop_defalco, true, false );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_execution_loop_harper, true, false );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_execution_loop_terrorist_01 );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_execution_loop_terrorist_02 );
	//add_player_anim( "player_body", %player::p_yemen_05_03_execution_loop, false, undefined, undefined, false );
	
	add_scene( "morals_execution_harper_saved", "morals_align" );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_execution_menendez_no, false, true, true );
	add_actor_anim( "defalco_morals", %generic_human::ch_yemen_05_03_execution_defalco_no, false, true, true );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_execution_harper_no, false, true, true );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_execution_terrorist_01_no, false, true, true );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_execution_terrorist_02_no, false, true, true );
	add_player_anim( "player_body", %player::p_yemen_05_02_execution_no, true, undefined, undefined, false );
	
	add_scene( "morals_execution_harper_shot", "morals_align" );
	add_actor_anim( "menendez_morals", %generic_human::ch_yemen_05_03_execution_menendez_yes, true, true, true );
	add_actor_anim( "defalco_morals", %generic_human::ch_yemen_05_03_execution_defalco_yes, true, true, true );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_03_execution_harper_yes );
	add_actor_anim( "terrorist_morals_04", %generic_human::ch_yemen_05_03_execution_terrorist_01_yes, true, true, true );
	add_actor_anim( "terrorist_morals_05", %generic_human::ch_yemen_05_03_execution_terrorist_02_yes, true, true, true );
//	add_player_anim( "player_body", %player::p_yemen_05_03_execution_yes, false, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );

*/

	add_scene( "morals_outcome_farid_lives", "morals_align" );
	add_actor_anim( "farid_morals", %generic_human::ch_yemen_05_05_farid_alive_farid, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_05_farid_alive_harper, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "mason_morals", %generic_human::ch_yemen_05_05_farid_alive_mason, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "morals_salazar", %generic_human::ch_yemen_05_05_farid_alive_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_player_anim( "player_body", %player::p_yemen_05_05_farid_alive_player, SCENE_DELETE );

//	add_scene( "morals_execution_harper_dies", "morals_align" );
//	add_actor_anim( "farid_morals", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_farid, false, false, true );
//	add_actor_anim( "mason_morals", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_mason, false, false, true );
////	add_prop_anim( "player_farid_body", %player::p_yemen_05_05_mason_intro_hpr_dies_farid, "c_usa_cia_masonjr_viewbody", true );
//	add_player_anim( "player_body", %player::p_yemen_05_05_mason_intro_hpr_dies_mason, false, undefined, undefined, true, 1, 45, 10, 15, 15, true, true );
//	add_notetrack_custom_function( "player_body", "switch_mason", maps\yemen_utility::switch_player_to_mason );
//	
//	add_scene( "morals_execution_harper_dies_others", "morals_align" );
//	add_actor_anim( "morals_salazar", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_salazar, false, false, true );
//	add_actor_anim( "harper_morals", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_harper, false, false, true );
	
	precache_assets( true );
}

morals_rail_anims()
{
	flag_wait( "morals_rail_start" );
	
	add_scene( "mason_intro_harper_dies", "morals_align" );
	add_actor_model_anim( "morals_rail_harper", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_harper, undefined, false, undefined, undefined, "morals_rail_harper" );
	add_actor_anim( "morals_intro_salazar", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_salazar );
	
	add_scene( "mason_intro_harper_dies_loop", "morals_align", false, false, true );
	add_actor_model_anim( "morals_rail_harper", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_harper_loop, undefined, false, undefined, undefined, "morals_rail_harper" );
	add_actor_anim( "morals_rail_salazar", %generic_human::ch_yemen_05_05_mason_intro_hpr_dies_salazar_loop, false );
	
	add_scene( "mason_intro_harper_lives", "morals_align" );
	add_actor_model_anim( "morals_rail_harper", %generic_human::ch_yemen_05_05_mason_intro_hpr_lives_harper, undefined, false, undefined, undefined, "morals_rail_harper" );
	add_actor_anim( "morals_rail_salazar", %generic_human::ch_yemen_05_05_mason_intro_hpr_lives_salazar, false, true, false, true );
	add_actor_model_anim( "morals_rail_soldier", %generic_human::ch_yemen_05_05_mason_intro_hpr_lives_soldier, undefined, false, undefined, undefined, "capture_ally" );
	add_notetrack_custom_function( "morals_rail_soldier", "start", maps\yemen_capture::give_me_a_gun ); 
	add_vehicle_anim( "morals_rail_vtol", %vehicles::v_yemen_05_05_mason_intro_hpr_lives_vtol );
	add_player_anim( "player_body", %player::p_yemen_05_05_mason_intro_hpr_lives_mason, true, undefined, undefined, true, 1, 45, 10, 15, 15, true, true  );
	add_prop_anim( "morals_rail_rope", %animated_props::o_yemen_05_05_mason_intro_hpr_lives_rope, "fxanim_war_sing_rappel_rope_01_mod" );
	
	precache_assets( true );
}

hijacked_anims()
{
	flag_wait( "hijacked_start" );
	
//	// This is strictly for bink capture
//	// TODO: comment out after bink is captured
//	add_scene( "menendez_hack", "menendez_surrender", false, false, true );
//	add_actor_model_anim( "menendez_hijacked", %generic_human::ch_yemen_07_01_menendez_hack_menendez, undefined, false, undefined, undefined, "capture_menendez" );
//	
//	// Also for bink capture - this is seperate because the model in the first one needs a gun and this one doesn't
//	add_scene( "pilot_hack", "menendez_surrender", false, false, true );
////	add_actor_model_anim( "pilot_hijacked", %generic_human::p_yemen_07_01_menendez_hack_pilot, undefined, false, undefined, undefined, "capture_ally" );
//	add_player_anim( "player_body", %player::p_yemen_07_01_menendez_hack_pilot, true, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );
	
	// Soldier hangs off of bridge
	add_scene( "hijacked_bridge_hang", "bridge_fall", false, false, true );
	add_actor_model_anim( "hijacked_soldier_hang", %generic_human::ch_yemen_07_01_bridge_fall, undefined, false, undefined, undefined, "capture_ally" );
	
	// Soldier falls from bridge
	add_scene( "hijacked_bridge_fall", "bridge_fall" );
	add_actor_model_anim( "hijacked_soldier_hang", %generic_human::ch_yemen_07_01_bridge_fall, "hijacked_soldier_hang", true );
	
	precache_assets( true );
}

capture_anims()
{
	flag_wait( "hijacked_bridge_fell" ); // load anims when bridge crumbles
	
	/* ---------------------------------------------------------------------------------------------------
	 * Sit Rep - Soldier pulls us in
	 * About this: This is named funny so it falls in line with naming convention of the carnage anims
	 * Why: because I wrote a system to play looped anims since there are a bunch of them
	 * **************************************************************************************************/
	add_scene( "carnage_a_wounded_00_loop", "s_capture_test_sitrep", false, false, true );
	add_actor_model_anim( "pulled_in", %generic_human::ch_yemen_08_01_pull_to_cover_american_loop, undefined, false, undefined, undefined, "capture_ally" );
	
//	add_scene( "soldier_sitrep", "s_capture_test_sitrep" );
//	add_actor_model_anim( "pulled_in", %generic_human::ch_yemen_08_01_pull_to_cover_american, undefined, false );
	
	/*-----------
 	 * Carnage
	 ***********/
	// 01-03 a loops
	add_scene( "carnage_a_wounded_01_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_a_01", %generic_human::ch_yemen_08_01_carnage_a_wounded01_loop, undefined, false, undefined, undefined, "capture_ally" );
	add_actor_model_anim( "medic_a_01", %generic_human::ch_yemen_08_01_carnage_a_wounded01_medic_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_a_wounded_02_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_a_02", %generic_human::ch_yemen_08_01_carnage_a_wounded02_loop, undefined, false, undefined, undefined, "capture_ally" );
	add_actor_model_anim( "medic_a_02", %generic_human::ch_yemen_08_01_carnage_a_wounded02_medic_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_a_wounded_03_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_a_03", %generic_human::ch_yemen_08_01_carnage_a_wounded03_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 04 a drag then loop -- this one is set up a little funny because we are using a guy that used to do something else but may do other stuff
	add_scene( "carnage_a_wounded_04_drag", "sit_rep" );
	add_actor_model_anim( "drag_a_04", %generic_human::ch_yemen_08_01_carnage_a_wounded04_drag, undefined, false, undefined, undefined, "capture_ally" );
//	add_actor_model_anim( "medic_a_04", %generic_human::ch_yemen_08_01_carnage_a_wounded04_medic_drag, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_a_sitrep_04_drag", "sit_rep" );
	add_actor_model_anim( "sitrep_guy", %generic_human::ch_yemen_08_01_pull_to_cover_american, undefined, false, undefined, undefined, "capture_ally" );
	add_notetrack_custom_function( "sitrep_guy", "start", maps\yemen_capture::give_me_a_gun ); 
	
	add_scene( "carnage_a_wounded_04_drag_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "drag_a_04", %generic_human::ch_yemen_08_01_carnage_a_wounded04_loop, undefined, false );
//	add_actor_model_anim( "medic_a_04", %generic_human::ch_yemen_08_01_carnage_a_wounded04_medic_loop, undefined, false );
	
	add_scene( "carnage_a_sitrep_04_drag_loop", "sit_rep" );
	add_actor_model_anim( "sitrep_guy", %generic_human::ch_yemen_08_01_pull_to_cover_american_loop, undefined, false );
	
	// 05 a loop
	add_scene( "carnage_a_wounded_05_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_a_05", %generic_human::ch_yemen_08_01_carnage_a_wounded05_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 06 a loop
	add_scene( "carnage_a_wounded_06_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_a_06", %generic_human::ch_yemen_08_01_carnage_a_wounded06_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 07 ready loop, run, then death loop
	add_scene( "carnage_a_wounded_07_loop", "sit_rep", undefined, undefined, true  );
	add_actor_model_anim( "wounded_a_07", %generic_human::ch_yemen_08_01_carnage_a_wounded07_startloop, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_a_wounded_07_run", "sit_rep" );
	add_actor_model_anim( "wounded_a_07", %generic_human::ch_yemen_08_01_carnage_a_wounded07_run, "wounded_a_07", false );
	add_notetrack_custom_function( "wounded_a_07", "start", maps\yemen_capture::turret_attacks_runner );
	
	add_scene( "carnage_a_wounded_07_run_loop", "sit_rep", undefined, undefined, true  );
	add_actor_model_anim( "wounded_a_07", %generic_human::ch_yemen_08_01_carnage_a_wounded07_endloop, undefined, false );
	
	// 01 b loop
	// Setup - first frame give me a gun
	add_scene( "carnage_b_wounded_01_loop_setup", "sit_rep", undefined, undefined );
	add_actor_model_anim( "wounded_b_01", %generic_human::ch_yemen_08_01_carnage_b_wounded01_loop, undefined, false, undefined, undefined, "capture_ally" );
	add_notetrack_custom_function( "wounded_b_01", "start", maps\yemen_capture::give_me_a_gun );
	
	add_scene( "carnage_b_wounded_01_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_01", %generic_human::ch_yemen_08_01_carnage_b_wounded01_loop, undefined, false );
	
	// 02 b drag then loop
	add_scene( "carnage_b_wounded_02_drag", "sit_rep" );
	add_actor_model_anim( "drag_b_02", %generic_human::ch_yemen_08_01_carnage_b_wounded02_drag, undefined, false, undefined, undefined, "capture_ally" );
	add_actor_model_anim( "medic_b_02", %generic_human::ch_yemen_08_01_carnage_b_wounded02_medic_drag, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_b_wounded_02_drag_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "drag_b_02", %generic_human::ch_yemen_08_01_carnage_b_wounded02_loop, undefined, false );
	add_actor_model_anim( "medic_b_02", %generic_human::ch_yemen_08_01_carnage_b_wounded02_medic_loop, undefined, false );
	
	// 03 b loop
	add_scene( "carnage_b_wounded_03_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_03", %generic_human::ch_yemen_08_01_carnage_b_wounded03_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 04 b crawl then loop
	add_scene( "carnage_b_wounded_04_crawl", "sit_rep" );
	add_actor_model_anim( "crawl_b_04", %generic_human::ch_yemen_08_01_carnage_b_wounded04_crawl, undefined, false, undefined, undefined, "capture_ally" );
	
	add_scene( "carnage_b_wounded_04_crawl_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "crawl_b_04", %generic_human::ch_yemen_08_01_carnage_b_wounded04_loop, undefined, false );
	
	// 05 b loop
	add_scene( "carnage_b_wounded_05_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_05", %generic_human::ch_yemen_08_01_carnage_b_wounded05_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 06 b loop
	add_scene( "carnage_b_wounded_06_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_06", %generic_human::ch_yemen_08_01_carnage_b_wounded06_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 07 b loop
	add_scene( "carnage_b_wounded_07_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_07", %generic_human::ch_yemen_08_01_carnage_b_wounded07_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 08 b loop
	add_scene( "carnage_b_wounded_08_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_08", %generic_human::ch_yemen_08_01_carnage_b_wounded08_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// 09 b loop
	add_scene( "carnage_b_wounded_09_loop", "sit_rep", undefined, undefined, true );
	add_actor_model_anim( "wounded_b_09", %generic_human::ch_yemen_08_01_carnage_b_wounded09_loop, undefined, false, undefined, undefined, "capture_ally" );
	
	// Menendez surrenders
	add_scene( "surrender_menendez", "menendez_surrender" );
	add_actor_model_anim( "capture_menendez", %generic_human::ch_yemen_08_02_surrender_men, undefined, false, undefined, undefined, "capture_menendez" );
	add_prop_anim( "capture_handcuffs", %animated_props::o_yemen_08_02_surrender_handcuffs, "p6_anim_handcuffs" );
	
	// HACK: scene with no headlook so player is facing the right way when the next scene starts
	add_scene( "surrender_menendez_player_setup", "menendez_surrender" );
	add_player_anim( "player_body", %player::p_yemen_08_02_surrender_plyr, false, undefined, undefined, true, 1, 0, 0, 0, 0, false, false );
	
	add_scene( "surrender_menendez_player", "menendez_surrender" );
	add_player_anim( "player_body", %player::p_yemen_08_02_surrender_plyr, false, undefined, undefined, true, 1, 25, 25, 25, 15, false, false );
	add_notetrack_custom_function( "player_body", "weapon_down", ::lower_weapon );
	
	add_scene( "surrender_menendez_idle", "menendez_surrender", false, false, true );
	add_actor_model_anim( "capture_menendez", %generic_human::ch_yemen_08_02_surrender_men_idle, undefined, false, undefined, undefined, "capture_menendez" );
	
	precache_assets( true );
}

level_anims()
{
	// intruder anims
	add_scene( "intruder", "intruder_gate" );
	add_player_anim( "player_body", %player::int_specialty_yemen_intruder, true );
	add_prop_anim( "intruder_cutter", %animated_props::o_specialty_yemen_intruder_cutter, "t6_wpn_laser_cutter_prop", true );
	add_prop_anim( "intruder_gate", %animated_props::o_specialty_yemen_intruder_rightgate );
}

// Lower player weapon during capture scene
lower_weapon( player )
{
	level.player DisableWeapons();
	level.player HideViewModel();
}
