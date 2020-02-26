#include maps\_utility;
#include maps\_scene;
#include maps\_music;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_panama_3::init_voice();
	
	//section anim functions
//	slums_anims();
	building_anims();
	chase_anims();
	docks_anims();
	
	//call after all scenes are setup
	precache_assets();
}

building_anims()
{
	add_scene( "clinic_walk_start_idle", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_startidl );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_startidl );
	
	add_scene( "clinic_walk_door_to_idle", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_door2_idl1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_door2_idl1 );
	//add_notetrack_custom_function( "mason", "kick_door", maps\panama_building::clinic_door_kicked_in );
	//add_notetrack_custom_function( "mason", "start_player_dialogue_1", maps\panama_building::clinic_player_vo_1 );
	
	add_scene( "clinic_walk_idle_1", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_idl1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_idl1 );
	
	add_scene( "clinic_walk_move_to_idle2", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_move2_idl2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_move2_idl2 );
	
	add_scene( "clinic_walk_idle_2", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_idl2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_idl2 );

	add_scene( "clinic_walk_path_v1", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_path_v1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_path_v1 );
	//add_notetrack_custom_function( "mason", "start_player_dialogue_1", maps\panama_building::clinic_player_vo_2 );
	
	add_scene( "clinic_walk_end_idle_v1", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_endidl_v1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_endidl_v1 );
	
	//add_scene( "clinic_gurney", "clinic_entrance" );
	//add_prop_anim( "clinic_gurney", %animated_props::o_pan_06_02_clinic_walkthru_stretcher, undefined, false, true );
	
	add_scene( "crying_woman_idle", "tackle_sequence", false, false, true );
	add_actor_model_anim( "crying_woman", 	%generic_human::ch_pan_06_03_crying_woman_woman );
	
	add_scene( "digbat_tackle", "tackle_sequence" );
	add_actor_anim( "tackle_digbat",	%generic_human::ch_pan_06_04_digbat_tackle_digbat, true, false );
	add_actor_anim( "mason",			%generic_human::ch_pan_06_04_digbat_tackle_mason );
	add_actor_anim( "noriega",			%generic_human::ch_pan_06_04_digbat_tackle_noriega );
	add_player_anim( "player_body",		%player::p_pan_06_04_digbat_tackle_player, false, undefined, undefined, true, 1, 35, 35, 10, 10, true, false );
	//add_prop_anim( "machete", %animated_props::o_pan_06_04_digbat_tackle_machette, "t6_wpn_machete_prop", true, true);
	add_notetrack_fx_on_tag( "tackle_digbat", "shot_hit", "digbat_doubletap", "j_neck" );
	add_notetrack_custom_function( "tackle_digbat", "shot_hit", maps\panama_3_amb::dingbat_shot_sound );
	add_notetrack_custom_function( "tackle_digbat", "break_wall", maps\panama_building::digbat_tackle_wall );
	
	
	add_scene( "digbat_blood_pool", "tackle_sequence" );
	add_actor_model_anim( "tackle_digbat_pool", %ch_pan_06_04_digbat_tackle_digbat_guy_1 );
	
	add_scene( "digbat_blood_pool_loop", "tackle_sequence" );
	add_actor_model_anim( "tackle_digbat_pool", %ch_pan_06_04_digbat_tackle_digbat_guy_1_dead );
	
	add_scene( "digbat_tackle_body", "player_tackle_sequence" );
	add_player_anim( "player_body",		%player::int_digbat_tackle_combat_idle, false, undefined, "tag_origin", true, 1, 35, 35, 10, 10, true, false );
	
	add_scene( "player_digbat_idle", "player_tackle_sequence");
	add_player_anim( "player_body",		%player::int_digbat_tackle_combat_idle, true, undefined, "tag_origin", true, 1, 35, 35, 10, 10, true, false );
	
	add_scene( "digbat_gauntlet_1", "tackle_sequence" );
	add_actor_anim( "digbat_1",			%generic_human::ch_pan_06_05_digbat_defense_digbat01 );
	
	add_scene( "digbat_gauntlet_2", "tackle_sequence" );
	add_actor_anim( "digbat_2",			%generic_human::ch_pan_06_05_digbat_defense_digbat02 );
	
	add_scene( "digbat_gauntlet_3", "tackle_sequence" );
	add_actor_anim( "digbat_3",			%generic_human::ch_pan_06_05_digbat_defense_digbat03 );
	
	add_scene( "digbat_gauntlet_4", "tackle_sequence" );
	add_actor_anim( "digbat_4",			%generic_human::ch_pan_06_05_digbat_defense_digbat04 );
	
	add_scene( "digbat_gauntlet_5", "tackle_sequence" );
	add_actor_anim( "digbat_5",			%generic_human::ch_pan_06_05_digbat_defense_digbat05 );
	
	add_scene( "digbat_gauntlet_6", "tackle_sequence" );
	add_actor_anim( "digbat_6",			%generic_human::ch_pan_06_05_digbat_defense_digbat06 );
	
	add_scene( "digbat_gauntlet_7", "tackle_sequence" );
	add_actor_anim( "digbat_7",			%generic_human::ch_pan_06_05_digbat_defense_digbat07 );
	
	add_scene( "tackle_recover_mason", "tackle_sequence" );
	add_actor_anim( "mason",			%generic_human::ch_pan_06_06_digbat_defend_recover_mason );
	
	add_scene( "tackle_recover_woman", "tackle_sequence" );
	add_actor_model_anim( "crying_woman",		%generic_human::ch_pan_06_06_digbat_defend_recover_woman );
	
	add_scene( "tackle_recover_player", "player_tackle_sequence" );
	add_player_anim( "player_body",		%player::int_digbat_tackle_getup, true );
	
	add_scene( "hallway_flashlights_enter", "soldier_flashlights" );
	add_prop_anim( "hall_flashlight_1", %animated_props::o_pan_06_07_hallway_flashlight1_enter, "tag_origin_animate", true );
	add_prop_anim( "hall_flashlight_2", %animated_props::o_pan_06_07_hallway_flashlight2_enter, "tag_origin_animate", true );
	
	add_scene( "hallway_flashlights_loop", "soldier_flashlights", false, false, true );
	add_prop_anim( "hall_flashlight_1", %animated_props::o_pan_06_07_hallway_flashlight1_searchloop, "tag_origin_animate", true );
	add_prop_anim( "hall_flashlight_2", %animated_props::o_pan_06_07_hallway_flashlight2_searchloop, "tag_origin_animate", true );
	
	add_scene( "stairwell_enter_normal", "soldier_flashlights" );
	add_actor_anim( "mason",			%generic_human::ch_pan_06_08_stairwell_mason_enter_normal );
	
	add_scene( "stairwell_enter_under_fire", "soldier_flashlights" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_08_stairwell_mason_under_fire );
	
	add_scene( "stairwell_climb_stairs", "soldier_flashlights" );
	add_actor_anim( "mason",			%generic_human::ch_pan_06_08_stairwell_mason_climb_stairs );
	
	add_scene( "stairwell_end_idle", "soldier_flashlights", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_08_stairwell_mason_endidl );
}

chase_anims()
{
	add_scene( "noriega_fight", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_01_fight_noriega );
	add_notetrack_flag( "noriega", "wall_contact", "clinic_wall_contact" );
	add_actor_anim( "marine_struggler1", %generic_human::ch_pan_07_01_fight_soldier1, false, false, false, false );
	add_actor_anim( "marine_struggler2", %generic_human::ch_pan_07_01_fight_soldier2, false, false, true, false );
	add_notetrack_flag( "marine_struggler1", "wall_contact", "clinic_break_window" );
	
	add_scene( "noriega_fight_mason", "save_noriega" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_01_fight_mason );
	
	add_scene( "noriega_fight_player", "save_noriega" );
	add_player_anim( "player_body", %player::p_pan_07_01_fight_player, true, 0, undefined, false, 0, 15, 15, 15, 15 );
	
	add_scene( "noriega_hanging", "save_noriega", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_02_rescue_noriega_hangidl );
	
	add_scene( "dead_soldier_fell", "save_noriega", false, false, true );
	add_actor_anim( "marine_struggler1", %generic_human::ch_pan_07_02_rescue_soldier1_deadloop, false, false, true, true );
	
	add_scene( "noriega_saved", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_01_help_noriega_noriega );
	add_player_anim( "player_body", %player::ch_pan_07_01_help_noriega_player, true, 0, undefined, false, 0, 15, 15, 15, 15 );
	add_notetrack_custom_function( "player_body", "sndChangeMusicState", ::sndChangeToApacheMusicState );
	add_actor_anim( "mason", %generic_human::ch_pan_07_01_help_noriega_mason );
	
	add_scene( "noriega_saved_marine", "save_noriega" );
	add_actor_anim( "marine_searcher1", %generic_human::ch_pan_07_01_help_noriega_guy01, false, false, true, false );
	add_actor_anim( "marine_searcher2", %generic_human::ch_pan_07_01_help_noriega_guy02, false, false, true, false );
	
	add_scene( "noriega_saved_irstrobe", "save_noriega");
	add_prop_anim( "ir_strobe", %animated_props::o_pan_07_01_help_noriega_strobe , "t6_wpn_ir_strobe_world", true, true );
	//add_notetrack_flag( "player_body", "play_mason_apacheattack_anim", "start_mason_run" );
	
	add_scene( "marine_search_party", "save_noriega" );
	add_actor_anim( "marine_searcher1", %generic_human::ch_pan_07_01_help_noriega_guy01_wait, false, false, true, false );
	add_actor_anim( "marine_searcher2", %generic_human::ch_pan_07_01_help_noriega_guy01_wait, false, false, true, false );
	
	add_scene( "noriega_falls", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_01_help_noriega_noriega_wait );
	
	add_scene( "noriega_runs_from_apache", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_03_apache_attack_noriega );
	

	
	add_scene( "noriega_balcony_idle", "save_noriega", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_01_help_noriega_noriega_idle, false, true, false, true );
	
	add_scene( "player_look_apache", "save_noriega" );
	add_player_anim( "player_body", %player::p_pan_07_03_apache_attack_player, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "mason_runs_from_apache", "save_noriega" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_03_apache_attack_mason );
	
	add_scene( "mason_waits_for_jump", "save_noriega", true, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_01_help_noriega_mason_wait );
	
	add_scene( "mason_noreiga_wall_hug", "wallhug_align_node");
	add_actor_anim( "mason", %generic_human::ch_pan_07_03_wall_hug_guy_02 );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_03_wall_hug_guy_01 );
	
	add_scene( "noriega_balcony_jump", "save_noriega", true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_jump, false, true, false, true );
	
	add_scene( "player_jump_landing", "building_jump" );
	add_player_anim( "player_body", %player::p_pan_07_04_jump_player, true );
	
	add_scene( "mason_balcony_jump", "building_jump" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_04_jump_mason_jump );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_run2door );
	
	
	add_scene( "checkpoint_husband", "wheelbarrow_align" );
	add_actor_anim( "checkpoint_husband", %generic_human::ch_pan_07_09_checkpoint_husband_pleading, true, false, false, true );
	add_actor_anim( "checkpoint_dead_wife", %generic_human::ch_pan_07_09_checkpoint_wife_dead, true, false, false, true );
	add_prop_anim( "checkpoint_wheelbarrow", %animated_props::o_pan_07_09_checkpoint_wheelbarrow, "p6_anim_wheelbarrow" );
	
	add_scene( "checkpoint_husband_idle", "wheelbarrow_align", false, false, true );
	add_actor_anim( "checkpoint_husband", %generic_human::ch_pan_07_09_checkpoint_husband_pleading_idle, true, false, true, true );
	add_actor_anim( "checkpoint_dead_wife", %generic_human::ch_pan_07_09_checkpoint_wife_dead_idle, true, false, true, true );
	add_prop_anim( "checkpoint_wheelbarrow", %animated_props::o_pan_07_09_checkpoint_wheelbarrow_idle, "p6_anim_wheelbarrow", true );
	
	add_scene( "checkpoint_start_idle_allies", "slums_checkpoint", true, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_startidl );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_startidl );
	
	add_scene( "checkpoint_start_idle_guards", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_slums_checkpoint_guard_loop);
	
	//TODO: This scene temporarily deletes the AI until the timing of the checkpoint can be addressed properly. Necessary for cleaning up
	//before transitioning to the docks.
	add_scene( "checkpoint_ally_walkout", "slums_checkpoint" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_slums_checkpoint_mason, false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_slums_checkpoint_noriega, true, true );
	//add_notetrack_flag( "mason", "fade_out", "checkpoint_fade_now" );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_slums_checkpoint_guard );
	
	add_scene( "checkpoint_player_walkout", "slums_checkpoint" );
	add_player_anim( "player_body", %player::ch_pan_07_09_slums_checkpoint_player, true);

	//TODO: This scene temporarily deletes the AI until the timing of the checkpoint can be addressed properly. Necessary for cleaning up
	//before transitioning to the docks.
	add_scene( "checkpoint_advance_guard2", "slums_checkpoint" );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_advance, false, false, true, true );
	
	add_scene( "checkpoint_cleared_guard2", "slums_checkpoint" );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_cleared, false, false, false, true );
	
	add_scene( "checkpoint_end_idle_guard2", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_endidl, false, false, true, true );
	
	add_scene( "gate2_guards", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_gateb_guard1, false, false, true, true );
	add_actor_model_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_gateb_guard2, undefined, true );
	add_actor_model_anim( "checkpoint_guard5", %generic_human::ch_pan_07_09_checkpoint_gateb_guard3, undefined, true );
	
	//TODO: This scene temporarily deletes the AI until the timing of the checkpoint can be addressed properly. Necessary for cleaning up
	//before transitioning to the docks.
	add_scene( "checkpoint_lineup", "slums_checkpoint" );
	add_actor_anim( "checkpoint_civ_female1", %generic_human::ch_pan_07_09_checkpoint_lineup_girl1, true, false, true, true );
	add_actor_anim( "checkpoint_civ_female2", %generic_human::ch_pan_07_09_checkpoint_lineup_girl2, true, false, true, true );
	add_actor_anim( "checkpoint_civ_male1", %generic_human::ch_pan_07_09_checkpoint_lineup_guy1, true, false, true, true );
	add_actor_anim( "checkpoint_civ_male2", %generic_human::ch_pan_07_09_checkpoint_lineup_guy2, true, false, true, true );
	add_actor_anim( "checkpoint_soldier1", %generic_human::ch_pan_07_09_checkpoint_lineup_soldier1, false, false, true, true );
	
	add_scene( "checkpoint_lineup_idle", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_civ_female1", %generic_human::ch_pan_07_09_checkpoint_lineup_girl1_idl, true, false, true, true );
	add_actor_anim( "checkpoint_civ_female2", %generic_human::ch_pan_07_09_checkpoint_lineup_girl2_idl, true, false, true, true );
	add_actor_anim( "checkpoint_civ_male1", %generic_human::ch_pan_07_09_checkpoint_lineup_guy1_idl, true, false, true, true );
	add_actor_anim( "checkpoint_civ_male2", %generic_human::ch_pan_07_09_checkpoint_lineup_guy2_idl, true, false, true, true );
	add_actor_anim( "checkpoint_soldier1", %generic_human::ch_pan_07_09_checkpoint_lineup_soldier1_idl, false, false, true, true );
	
	add_scene( "checkpoint_triage", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_medic1", %generic_human::ch_pan_07_09_checkpoint_medical_guy1, true, false, true, true );
	add_actor_model_anim( "checkpoint_patient1", %generic_human::ch_pan_07_09_checkpoint_medical_guy2, undefined, true );
	add_actor_model_anim( "checkpoint_patient2", %generic_human::ch_pan_07_09_checkpoint_medical_guy3, undefined, true );
	add_actor_anim( "checkpoint_medic2", %generic_human::ch_pan_07_09_checkpoint_medical_guy4, true, false, true, true );
	
	add_scene( "checkpoint_patrol1", "slums_checkpoint" );
	add_actor_anim( "checkpoint_patroller1", %generic_human::ch_pan_07_09_checkpoint_patrol_soldier1, false, false, true, true );
	
	add_scene( "checkpoint_patrol2", "slums_checkpoint" );
	add_actor_anim( "checkpoint_patroller2", %generic_human::ch_pan_07_09_checkpoint_patrol_soldier2, false, false, true, true );
	
	add_scene( "checkpoint_patrol3", "slums_checkpoint" );
	add_actor_anim( "checkpoint_patroller3", %generic_human::ch_pan_07_09_checkpoint_patrol_soldier3, false, false, false, true );
	
	add_scene( "checkpoint_patrol3_idle", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_patroller3", %generic_human::ch_pan_07_09_checkpoint_patrol_soldier3_idl, false, false, true, true );
	
	add_scene( "checkpoint_sitgroup", "slums_checkpoint", false, false, true );
	add_actor_model_anim( "checkpoint_civ_female3", %generic_human::ch_pan_07_09_checkpoint_sitgroup_girl1, undefined, true );
	add_actor_model_anim( "checkpoint_civ_female4", %generic_human::ch_pan_07_09_checkpoint_sitgroup_girl2, undefined, true );
	add_actor_model_anim( "checkpoint_civ_male3", %generic_human::ch_pan_07_09_checkpoint_sitgroup_guy1, undefined, true );
	add_actor_model_anim( "checkpoint_civ_male4", %generic_human::ch_pan_07_09_checkpoint_sitgroup_guy2, undefined, true );
	add_actor_model_anim( "checkpoint_civ_male5", %generic_human::ch_pan_07_09_checkpoint_sitgroup_guy3, undefined, true );
	add_actor_model_anim( "checkpoint_medic3", %generic_human::ch_pan_07_09_checkpoint_sitgroup_soldier1, undefined, true );
	
	add_scene( "checkpoint_soldiers_resting", "slums_checkpoint", false, false, true );
	add_actor_model_anim( "checkpoint_soldier3", %generic_human::ch_pan_07_09_checkpoint_soldiers_rest_1, undefined, true );
	add_actor_model_anim( "checkpoint_soldier4", %generic_human::ch_pan_07_09_checkpoint_soldiers_rest_2, undefined, true );
	add_actor_model_anim( "checkpoint_soldier5", %generic_human::ch_pan_07_09_checkpoint_soldiers_rest_3, undefined, true );
	add_actor_model_anim( "checkpoint_soldier6", %generic_human::ch_pan_07_09_checkpoint_soldiers_rest_4, undefined, true );
	
	//TODO: This scene temporarily deletes the AI until the timing of the checkpoint can be addressed properly. Necessary for cleaning up
	//before transitioning to the docks.
	add_scene( "checkpoint_tieup", "slums_checkpoint" );
	//add_actor_anim( "checkpoint_civ_male6", %generic_human::ch_pan_07_09_checkpoint_tieup_guy1, true, false, true, true );
	//add_actor_anim( "checkpoint_soldier7", %generic_human::ch_pan_07_09_checkpoint_tieup_soldier1, false, false, true, true );
	add_actor_anim( "checkpoint_soldier8", %generic_human::ch_pan_07_09_checkpoint_tieup_soldier2, false, false, true, true );
	
	add_scene( "checkpoint_tieup_soldier3", "slums_checkpoint" );
	add_actor_anim( "checkpoint_soldier9", %generic_human::ch_pan_07_09_checkpoint_tieup_soldier3, false, false, true, true );
	
	add_scene( "checkpoint_tieup_idle", "slums_checkpoint", false, false, true );
	//add_actor_anim( "checkpoint_civ_male6", %generic_human::ch_pan_07_09_checkpoint_tieup_guy1_idl, true, false, true, true );
	add_actor_anim( "checkpoint_soldier7", %generic_human::ch_pan_07_09_checkpoint_tieup_soldier1_idl, false, false, true, true );
	add_actor_anim( "checkpoint_soldier8", %generic_human::ch_pan_07_09_checkpoint_tieup_soldier2_idl, false, false, true, true );
}

docks_anims()
{
	add_scene( "docks_drive", "docks_car_path" );
	add_vehicle_anim( "blackops_jeep_docks", %vehicles::v_pan_08_01_gate_crash_jeep, false );
	//add_prop_anim( "docks_entrance", %animated_props::o_pan_08_01_gatecrash_gate, "fxanim_panama_gate_entrance_mod" );
	
	add_scene( "docks_drive_player", "docks_car_path" );
	add_player_anim( "player_body", %player::p_pan_08_01_gate_crash_player, true/*, 0, "origin_animate_jnt"*/, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "gate_player_unload", "docks_car_path" );
	add_vehicle_anim( "blackops_jeep_docks", %vehicles::v_pan_08_01_jeep_exit_jeep, false );
	add_player_anim( "player_body", %player::p_pan_08_01_jeep_exit_player, true );
	
	add_scene( "jeep_player_transition", "docks_car_path" );
	add_player_anim( "player_body", %player::p_pan_08_01_jeep_stage_two_player, true );
	
	add_scene( "jeep_player_rifle", "docks_car_path" );
	add_player_anim( "player_body", %player::p_pan_08_01_jeep_rifle_grab_player, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_vehicle_anim( "blackops_jeep_docks", %vehicles::v_pan_08_01_jeep_rifle_grab_jeep, false );
	add_prop_anim( "anim_sniper_rifle", %animated_props::o_pan_08_01_jeep_rifle_grab_rifle, "t6_wpn_sniper_m82_world", true, true );
	
	
	
	add_scene( "player_jeep_rail_jeep", "dock_rail");
	add_prop_anim( "player_jeep", %animated_props::v_pan_08_01_jeepride_jeep );
	
	
	add_scene( "player_jeep_rail", "player_jeep");
	add_player_anim( "player_body", %player::p_pan_08_01_jeepride, false, 0, "tag_origin"); //, undefined, undefined, true, 1, 45, 45, 40, 10, true, false );
	add_actor_anim( "noriega", %generic_human::ch_pan_08_01_jeepride_guy01, false, false, false, true, "tag_origin" );
	add_notetrack_level_notify("player_body", "Give_Weapon", "attach_weapon");
	add_notetrack_level_notify("player_body", "Bullet_Time_Start", "viewmodel_on");
	add_notetrack_level_notify("player_body", "Bullet_Time_End", "viewmodel_off");
	
	add_scene_loop( "player_jeep_idle_loop", "player_jeep");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_01_jeepride_guy01_cycle, false, false, false, true, "tag_origin");
	add_player_anim( "player_body", %player::p_pan_08_01_jeepride_cycle, false);
	
	
	add_scene_loop( "player_jeep_jeep_idle", "dock_rail");
	add_prop_anim( "player_jeep", %animated_props::v_pan_08_01_jeepride_jeep_cycle );
	
	
	add_scene( "player_jeep_idle_end", "player_jeep");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_01_jeepride_guy01_end, false, false, false, true, "tag_origin");
	add_player_anim( "player_body", %player::p_pan_08_01_jeepride_end, true);
	
	
	add_scene( "player_jeep_jeep_idle_end", "dock_rail");
	add_prop_anim( "player_jeep", %animated_props::v_pan_08_01_jeepride_jeep_end );
	
	
	add_scene( "elevator_bottom_open", "elevator_ride" );
	add_prop_anim( "docks_elevator", %animated_props::o_pan_08_05_elevator_defend_elevator_opendoors );
	
	add_scene( "elevator_bottom_open_idle", "elevator_ride", false, false, true );
	add_prop_anim( "docks_elevator", %animated_props::o_pan_08_05_elevator_defend_elevator_openidl );
	
	add_scene( "elevator_bottom_close", "elevator_ride" );
	add_prop_anim( "docks_elevator", %animated_props::o_pan_08_05_elevator_defend_elevator_closedoors );
	
	add_scene( "elevator_top_open", "elevator_ride" );
	add_prop_anim( "docks_elevator", %animated_props::o_pan_08_06_elevator_ride_elevator_opendoors );
	
	add_scene( "elevator_top_close", "elevator_ride" );
	add_prop_anim( "docks_elevator", %animated_props::o_pan_08_06_elevator_ride_elevator_closedoors );
	
	
	add_scene( "noriega_walk_to_elevator", "elevator_bottom_align", true);
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_elevator_approach_noriega );
	
	add_scene( "noriega_enter_elevator", "elevator_bottom_align", true);
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_elevator_enter_noriega );
	
	add_scene_loop( "noriega_idle_elevator", "docks_elevator");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_elevator_idle_noriega, false, true, false, true, "tag_origin" );
	
	add_scene( "noriega_exit_elevator", "take_the_shot");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_elevator_exit_noriega );
	
	add_scene_loop( "noriega_idle_sniper_door", "take_the_shot");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_take_the_shot_noriega_wait );
	
	add_scene_loop( "sniper_idle_door", "take_the_shot");
	add_actor_anim( "end_roof_sniper", %generic_human::ch_pan_08_06_take_the_shot_guy01_idle, false, false, false, true );
	
	add_scene( "noriega_kill_guard_give_sniper", "take_the_shot");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_take_the_shot_noriega );
	add_player_anim( "player_body",  %player::ch_pan_08_06_take_the_shot_player, true);
	add_actor_anim( "end_roof_sniper", %generic_human::ch_pan_08_06_take_the_shot_guy01, false, false, false, true );
	
	add_scene_loop( "noriega_idle_woods_snipe", "take_the_shot");
	add_actor_anim( "noriega", %generic_human::ch_pan_08_06_take_the_shot_noriega_loop, true, true );
	
	add_scene( "mount_sniper_turret", "take_the_shot" );
	add_player_anim( "player_body", %player::p_pan_08_06_take_the_shot_player_pickup_gun, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_prop_anim( "anim_sniper_rifle", %animated_props::o_pan_08_06_take_the_shot_rifle, "t6_wpn_sniper_m82_world", true, true );
	
	add_scene( "sniper_walk", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_walk );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_walk );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_walk );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_walk, "p6_anim_burlap_sack" );
	add_notetrack_flag( "mason_prisoner_ai", "start_shoot", "sniper_start_timer" );
	add_notetrack_flag( "mason_prisoner_ai", "stop_shoot", "sniper_stop_timer" );
	
	add_scene( "sniper_start_idle", "bag_on_head", false, false, true );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_firstidl );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_firstidl );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_firstidl );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_firstidl, "p6_anim_burlap_sack", true );
	
	add_scene( "sniper_shot", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_shot );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_shot );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_shot );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_shot, "p6_anim_burlap_sack" );
	
	add_scene( "sniper_injured_shot", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_injured_shot );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_injured_shot );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_injured_shot );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_injured_shot, "p6_anim_burlap_sack" );

	add_scene( "sniper_shot_idle", "bag_on_head", false, false, true );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_secondidl );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_secondidl );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_secondidl );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_secondidl, "p6_anim_burlap_sack" );

	add_scene( "sniper_injured_last_shot", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_injured_last_shot );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_injured_last_shot );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_injured_last_shot );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_injured_last_shot, "p6_anim_burlap_sack" );
	
	add_scene( "betrayed", "walk_align" );
	add_actor_anim( "noriega", %generic_human::ch_pan_09_01_betrayed_noriega );
	add_actor_anim( "menendez", %generic_human::ch_pan_09_01_betrayed_menendez);
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_09_01_betrayed_gaurd_1);
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_09_01_betrayed_gaurd_2);
	add_prop_anim( "betrayal_right_door", %animated_props::o_pan_09_01_betrayed_rightdoor);
	add_prop_anim( "betrayal_left_door", %animated_props::o_pan_09_01_betrayed_leftdoor);
	add_player_anim( "player_body", %player::p_pan_09_01_betrayed_player, false, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_notetrack_flag( "player_body", "fade_in", "docks_betrayed_fade_in" );
	add_notetrack_flag( "player_body", "fade_out", "docks_betrayed_fade_out" );
	add_notetrack_custom_function( "player_body", "shot_1", maps\panama_docks::swap_player_body_dmg1 );
	add_notetrack_custom_function( "player_body", "shot_2", maps\panama_docks::swap_player_body_dmg2 );
	add_notetrack_custom_function( "player_body", "shot_3", maps\panama_docks::swap_player_body_dmg3 );
	
	add_scene( "betrayed_sack", "bag_on_head" );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_09_01_betrayed_sack, "p6_anim_burlap_sack" );
	
	add_scene( "betrayed_mason_body", "walk_align", false, false, true );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_09_01_betrayed_mason, true, false );
	
	add_scene( "final_cin_seals1_intro_idle", "final_cin_littlebird1", false, false, true );
	add_actor_anim( "final_cin_seal1", %generic_human::ch_pan_09_01_recovered_guy_1_loop, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_seal2", %generic_human::ch_pan_09_01_recovered_guy_2_loop, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_seals2_intro_idle", "final_cin_littlebird2", false, false, true );
	add_actor_anim( "final_cin_seal3", %generic_human::ch_pan_09_01_recovered_guy_1_loop, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_seal4", %generic_human::ch_pan_09_01_recovered_guy_2_loop, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_seals1_unload", "final_cin_littlebird1" );
	add_actor_anim( "final_cin_seal1", %generic_human::ch_pan_09_01_recovered_guy_1, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_seal2", %generic_human::ch_pan_09_01_recovered_guy_2, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_seals2_unload", "final_cin_littlebird2" );
	add_actor_anim( "final_cin_seal3", %generic_human::ch_pan_09_01_recovered_guy_1, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_seal4", %generic_human::ch_pan_09_01_recovered_guy_2, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_pilots1_idle", "final_cin_littlebird1", false, false, true );
	add_actor_anim( "final_cin_pilot1", %generic_human::ch_pan_09_01_recovered_pilot_1_loop, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_pilot2", %generic_human::ch_pan_09_01_recovered_pilot_2_loop, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_pilots2_idle", "final_cin_littlebird2", false, false, true );
	add_actor_anim( "final_cin_pilot3", %generic_human::ch_pan_09_01_recovered_pilot_1_loop, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_pilot4", %generic_human::ch_pan_09_01_recovered_pilot_2_loop, false, false, false, true, "origin_animate_jnt" );

	add_scene( "final_cin_skinner_medic", "final_cin_littlebird1" );
	//add_actor_model_anim( "final_cin_skinner", %generic_human::ch_pan_09_01_recovered_skinner, "c_usa_seal80s_skinner_fb", false, "origin_animate_jnt" );
	add_actor_anim( "final_cin_medic", %generic_human::ch_pan_09_01_recovered_medic, false, false, false, true, "origin_animate_jnt" );

	add_scene( "final_cin_seals3", "final_cin_littlebird2" );
	add_actor_anim( "final_cin_seal5", %generic_human::ch_pan_09_01_recovered_guy_3, false, false, false, true, "origin_animate_jnt" );
	add_actor_anim( "final_cin_seal6", %generic_human::ch_pan_09_01_recovered_guy_4, false, false, false, true, "origin_animate_jnt" );
	
	add_scene( "final_cin_mason", "bag_on_head", false, false, true );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_09_01_recovered_mason_loop );
	
	add_scene( "final_cin_player", "bag_on_head" );
	add_player_anim( "player_body", %player::p_pan_09_01_recovered_player, false, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_notetrack_flag( "player_body", "fade_in", "docks_final_cin_fade_in" );
	add_notetrack_flag( "player_body", "fade_out", "docks_final_cin_fade_out" );
	
	add_scene( "final_cin_chopper1", "bag_on_head" );
	add_vehicle_anim( "final_cin_littlebird1", %vehicles::v_pan_09_01_recovered_chopper_1, false );
	add_notetrack_flag( "final_cin_littlebird1", "landed", "docks_final_cin_landed1" );
	
	add_scene( "final_cin_chopper2", "bag_on_head" );
	add_vehicle_anim( "final_cin_littlebird2", %vehicles::v_pan_09_01_recovered_chopper_2, false );
	add_notetrack_flag( "final_cin_littlebird2", "landed", "docks_final_cin_landed2" );
}

sndChangeToApacheMusicState( dude )
{
	setmusicstate("PANAMA_APACHE");
}