#include maps\_utility;
#include maps\_scene;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_panama::init_voice();
	
	patroller_anims();
	
	//section anim functions
	house_anims();
	airfield_anims();
	motel_anims();
	slums_anims();
	building_anims();
	chase_anims();
	docks_anims();
	
	//call after all scenes are setup
	precache_assets();
}

slums_anims()
{
	add_scene( "slums_ambulance_doors", undefined, false, false, false, true );
	add_vehicle_anim( "ambulence", %vehicles::veh_anim_80s_van_rear_doors_open );
	
	add_scene( "slums_intro_player", "slum_ambulence_scene" );
	add_player_anim( "player_body",		%player::p_pan_04_01_intro_player_approach, true );
	
	add_scene( "slums_intro_mason", "slum_ambulence_scene" );
	add_actor_anim( "mason",			%generic_human::ch_pan_04_01_intro_mason_approach );
	
	add_scene( "slums_intro_noriega", "slum_ambulence_scene" );
	add_actor_anim( "noriega",			%generic_human::ch_pan_04_01_intro_noriaga_approach );
	
	add_scene( "slums_intro_noriega_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "noriega",			%generic_human::ch_pan_04_01_intro_noriaga_loop );
	
	add_scene( "slums_move_overlook_mason", "slum_ambulence_scene" );
	add_actor_anim( "mason",			%generic_human::ch_pan_04_03_to_building_mason );
	
	add_scene( "slums_move_overlook_mason_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "mason",			%generic_human::ch_pan_04_03_to_building_mason_loop);
	
	add_scene( "slums_move_overlook_noriega", "slum_ambulence_scene" );
	add_actor_anim( "noriega",			%generic_human::ch_pan_04_03_to_building_noriega );
	
	add_scene( "slums_move_overlook_noriega_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "noriega",			%generic_human::ch_pan_04_03_to_building_noriega_loop);
	
	add_scene( "slums_overlook_mason", "slums_opening_read_body" );
	add_actor_anim( "mason",			%generic_human::ch_pan_05_01_intro_mason );
	
	add_scene( "slums_overlook_noriega", "slums_opening_read_body" );
	add_actor_anim( "noriega",			%generic_human::ch_pan_05_01_into_noriega );
	
	add_scene( "slums_intro_ambulance_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_beating );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_beating );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_beating );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_beaten, true );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_beaten, true );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_beaten, true );
	
	add_scene( "slums_intro_ambulance_kill", "slum_ambulence_scene" );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_killing );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_killing );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_killing );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_death, true );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_death, true );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_death, true );
	add_notetrack_flag( "amb_digbat_2", "no_return", "ambulance_staff_killed" );
	
	add_scene( "slums_intro_saved_amb_doctor_1", "slum_ambulence_scene" );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_saved, true );
	
	add_scene( "slums_intro_saved_amb_doctor_2", "slum_ambulence_scene" );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_saved, true );
	
	add_scene( "slums_intro_saved_amb_nurse", "slum_ambulence_scene" );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_saved, true );
	
	add_scene( "slums_intro_saved_loop_amb_doctor_1", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_loop, true );
	
	add_scene( "slums_intro_saved_loop_amb_doctor_2", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_loop, true );

	add_scene( "slums_intro_saved_loop_amb_nurse", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_loop, true );
	
	add_scene( "slums_intro_react_amb_digbat_1", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_reaction );
	
	add_scene( "slums_intro_react_amb_digbat_2", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_reaction );
	
	add_scene( "slums_intro_react_amb_digbat_3", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_reaction );
	
	add_scene( "slums_intro_corpses", "slum_ambulence_scene" );
	add_actor_model_anim( "corpse_1", 	%generic_human::ch_pan_04_02_amblulance_dead_civ_1, "c_usa_jungmar_1_fb" );
	add_actor_model_anim( "corpse_2", 	%generic_human::ch_pan_04_02_amblulance_dead_civ_2, "c_usa_jungmar_1_fb" );

	add_scene( "slums_overlook_corpse", "slums_opening_read_body" );
	add_actor_model_anim( "corpse", 	%generic_human::ch_pan_04_03_to_building_dead_guy, "c_usa_jungmar_1_fb" );
	
	add_scene( "slums_strobe_grenade_throw", "5_1_grenade_toss" );
	add_actor_anim( "slums_grenade_thrower", %generic_human::ch_pan_05_01_grenade_throw_soldier, false, true, false, true );
	add_notetrack_custom_function( "slums_grenade_thrower", "attach", maps\panama_slums::e_01_overlook_attach_strobe );
	add_notetrack_custom_function( "slums_grenade_thrower", "detach", maps\panama_slums::e_01_overlook_detach_strobe );
	
	add_scene( "slums_burning_building", "Burning_Building1" );
	add_actor_anim( "slums_soldier_01", %generic_human::ch_pan_05_12_burning_building_soldier01 );
	add_actor_anim( "slums_soldier_02", %generic_human::ch_pan_05_12_burning_building_soldier02 );
	
	add_scene( "slums_burning_building_gascan", "Burning_Building1" );
	add_prop_anim( "slums_gascan", %animated_props::o_pan_05_12_burning_building_gascan, "p6_anim_gas_can", true, true );
	
	add_scene( "slums_scaredcouple_introloop", "5_20_scared_couple", false, false, true );
	add_actor_anim( "scared_man",		%generic_human::ch_pan_05_20_introloop_scaredcouple_man );
	add_actor_anim( "scared_woman",		%generic_human::ch_pan_05_20_introloop_scaredcouple_woman );
	
	add_scene( "slums_scaredcouple_reaction", "5_20_scared_couple" );
	add_actor_anim( "scared_man", 		%generic_human::ch_pan_05_20_reaction_scaredcouple_man );
	add_actor_anim( "scared_woman",		%generic_human::ch_pan_05_20_reaction_scaredcouple_woman );
	
	add_scene( "slums_scaredcouple_outroloop", "5_20_scared_couple", false, false, true );
	add_actor_anim( "scared_man", 		%generic_human::ch_pan_05_20_outroloop_scaredcouple_man );
	add_actor_anim( "scared_woman",		%generic_human::ch_pan_05_20_outroloop_scaredcouple_woman );
	
	add_scene( "parking_jump", "digbat_van_jump" );
	add_actor_anim( "slums_park_digbat_01",			%generic_human::ch_pan_05_23_parking_jump_digbat01 );
	
	add_scene( "parking_window", "digbat_van_jump" );
	add_actor_anim( "slums_park_digbat_02",			%generic_human::ch_pan_05_23_parking_jump_digbat02 );
	
	add_scene( "dumpster_push", "Dumpster_push" );
	add_actor_anim( "slums_dumpster_01",	%generic_human::ch_pan_05_15_dumpster_push_pdf01 );
	add_actor_anim( "slums_dumpster_02",	%generic_human::ch_pan_05_15_dumpster_push_pdf02 );
	add_actor_anim( "slums_dumpster_03",	%generic_human::ch_pan_05_15_dumpster_push_pdf03 );
	add_prop_anim( "slums_dumpster",		%animated_props::o_pan_05_15_dumpster_push_dumpster, undefined, false, true );
	
	add_scene( "brute_force_loop", "5_17_brute_force", false, false, true );
	add_actor_anim( "brute_force",			%generic_human::ch_pan_05_17_bruteforce_loop_sld );
	
	add_scene( "brute_force", "5_17_brute_force" );
	add_player_anim( "player_body",			%player::p_pan_05_17_bruteforce_player, true );
	add_actor_anim( "brute_force", 			%generic_human::ch_pan_05_17_bruteforce_react_sld );
	
	add_scene( "brute_force_props", "5_17_brute_force" );
	add_prop_anim( "debris_1", %animated_props::o_pan_05_17_bruteforce_rubble1, "iw_beam_debris_01", false, true );
	add_prop_anim( "debris_2", %animated_props::o_pan_05_17_bruteforce_rubble2, "iw_beam_debris_01", false, true );
	
	add_scene( "lock_breaker", "Lock_Breaker" );
	add_player_anim( "player_body",			%player::int_specialty_panama_lockbreaker, true );
	add_prop_anim( "lockbreaker", %animated_props::o_specialty_panama_lockbreaker_device, "t6_wpn_lock_pick_view", true );
	
	add_scene( "slums_claymore_plant", "PDF_Claymore" );
	add_actor_anim( "slums_claymore_pdf",				%generic_human::ch_pan_05_16_claymoreplant_pdf );
	add_notetrack_custom_function( "slums_claymore_pdf", "detach", maps\panama_slums::e_16_spawn_claymore );
	
	add_scene( "slums_apt_rummage_loop", "5_21_rummage", false, false, true );
	add_actor_anim( "e_21_digbat_1",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat01 );
	add_actor_anim( "e_21_digbat_2",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat02 );
	add_actor_anim( "e_21_digbat_3",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat03 );
	
	add_scene( "slums_apt_rummage_react", "5_21_rummage" );
	add_actor_anim( "e_21_digbat_1",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat01 );
	add_actor_anim( "e_21_digbat_2",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat02 );
	add_actor_anim( "e_21_digbat_3",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat03 );
	
	add_scene( "beating_loop", "5_22_dig_bat_woman_torture", false, false, true );
	add_actor_anim( "e_22_digbat_1",			%generic_human::ch_pan_05_22_beating_loop_digbat );
	add_actor_anim( "e_22_digbat_2",			%generic_human::ch_pan_05_22_trash_rummaging_loop_digbat );
	
	add_scene( "beating_reaction", "5_22_dig_bat_woman_torture" );
	add_actor_anim( "e_22_digbat_1",			%generic_human::ch_pan_05_22_beating_reaction_digbat );
	add_actor_anim( "e_22_digbat_2",			%generic_human::ch_pan_05_22_trash_reaction_digbat );
	
	add_scene( "beating_corpse", "5_22_dig_bat_woman_torture" );
	add_actor_model_anim( "woman_corpse", 	%generic_human::ch_pan_05_22_beaten_corpse, "c_usa_jungmar_1_fb" );
	
	add_scene( "slums_molotov_throw_left", "e_19_molotov_left" );
	add_actor_anim( "molotov_digbat",			%generic_human::ch_pan_05_19_molotov_throw_digbat );
	add_notetrack_custom_function( "molotov_digbat", "attach", maps\panama_slums::e_19_attach, true );
	add_notetrack_custom_function( "molotov_digbat", "shot", maps\panama_slums::e_19_shot, true );
	
	add_scene( "slums_molotov_throw_right", "e_19_molotov_right" );
	add_actor_anim( "molotov_digbat",			%generic_human::ch_pan_05_19_molotov_throw_digbat );
	
	add_scene( "slums_apc_wall_crash", "APC_StoreCrash" );
	add_vehicle_anim( "slums_apc_building", %vehicles::fxanim_panama_laundromat_apc_anim );
}

building_anims()
{
	add_scene( "clinic_walk_start_idle", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_startidl );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_startidl );
	
	add_scene( "clinic_walk_door_to_idle", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_door2_idl1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_door2_idl1 );
	add_notetrack_custom_function( "mason", "kick_door", maps\panama_building::clinic_door_kicked_in );
	
	add_scene( "clinic_walk_idle_1", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_idl1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_idl1 );
	
	add_scene( "clinic_walk_move_to_idle2", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_move2_idl2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_move2_idl2 );
	
	add_scene( "clinic_walk_idle_2", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_idl2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_idl2 );
	
	add_scene( "clinic_walk_move_to_split", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_move2split );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_move2split );
	
	add_scene( "clinic_walk_path_v1", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_path_v1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_path_v1 );
	
	add_scene( "clinic_walk_path_v2", "clinic_entrance" );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_path_v2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_path_v2 );
	
	add_scene( "clinic_walk_end_idle_v1", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_endidl_v1 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_endidl_v1 );
	
	add_scene( "clinic_walk_end_idle_v2", "clinic_entrance", false, false, true );
	add_actor_anim( "mason", 			%generic_human::ch_pan_06_02_clinic_walkthru_mason_endidl_v2 );
	add_actor_anim( "noriega", 			%generic_human::ch_pan_06_02_clinic_walkthru_noriega_endidl_v2 );
	
	add_scene( "crying_woman_idle", "tackle_sequence", false, false, true );
	add_actor_anim( "crying_woman", 	%generic_human::ch_pan_06_03_crying_woman_woman );
	
	add_scene( "digbat_tackle_crying_woman_idle", "tackle_sequence", false, false, true );
	add_actor_anim( "crying_woman",		%generic_human::ch_pan_06_04_digbat_tackle_woman );
	
	add_scene( "digbat_tackle", "tackle_sequence" );
	add_actor_anim( "tackle_digbat",	%generic_human::ch_pan_06_04_digbat_tackle_digbat );
	add_actor_anim( "mason",			%generic_human::ch_pan_06_04_digbat_tackle_mason );
	add_player_anim( "player_body",		%player::p_pan_06_04_digbat_tackle_player, false, undefined, undefined, true, 1, 35, 35, 10, 10, true, false );
	add_notetrack_fx_on_tag( "tackle_digbat", "shot_hit", "digbat_doubletap", "j_neck" );
	add_notetrack_custom_function( "tackle_digbat", "shot_hit", maps\panama_amb::dingbat_shot_sound );
	
	add_scene( "digbat_tackle_body", "tackle_sequence", false, false, true );
	add_player_anim( "player_body",		%player::int_digbat_tackle_combat_idle, false, undefined, undefined, true, 1, 35, 35, 10, 10, true, false );
	
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
	add_actor_anim( "crying_woman",		%generic_human::ch_pan_06_06_digbat_defend_recover_woman );
	
	add_scene( "tackle_recover_player", "tackle_sequence" );
	add_player_anim( "player_body",		%player::p_pan_06_06_digbat_defend_recover_player, true );
	
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
	add_actor_anim( "marine_struggler1", %generic_human::ch_pan_07_01_fight_soldier1 );
	add_actor_anim( "marine_struggler2", %generic_human::ch_pan_07_01_fight_soldier2 );
	
	add_scene( "noriega_fight_mason", "save_noriega" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_01_fight_mason );
	
	add_scene( "noriega_fight_player", "save_noriega" );
	add_player_anim( "player_body", %player::p_pan_07_01_fight_player, false, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "noriega_hanging", "save_noriega", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_02_rescue_noriega_hangidl );
	
	add_scene( "dead_soldier_fell", "save_noriega", false, false, true );
	add_actor_anim( "marine_struggler1", %generic_human::ch_pan_07_02_rescue_soldier1_deadloop );
	
	add_scene( "noriega_saved", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_02_rescue_noriega_rescue );
	add_player_anim( "player_body", %player::p_pan_07_02_rescue_player_rescue, false, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "marine_search_party", "save_noriega" );
	add_actor_anim( "marine_searcher1", %generic_human::ch_pan_07_02_rescue_soldier2_enter );
	add_actor_anim( "marine_searcher2", %generic_human::ch_pan_07_02_rescue_soldier3_enter );
	
	add_scene( "noriega_falls", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_02_rescue_noriega_fall );
	
	add_scene( "noriega_runs_from_apache", "door_baracade" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_03_apache_attack_noriega );
	
	add_scene( "noriega_balcony_jump", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_jump );
	
	add_scene( "noriega_balcony_idle", "save_noriega", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_waitidle );
	
	add_scene( "player_look_apache", "door_baracade" );
	add_player_anim( "player_body", %player::p_pan_07_03_apache_attack_player, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "mason_runs_from_apache", "door_baracade" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_03_apache_attack_mason );
	
	add_scene( "mason_waits_for_jump", "door_baracade", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_03_apache_attack_mason_waitidl );
	
	add_scene( "player_jump_landing", "save_noriega" );
	add_player_anim( "player_body", %player::p_pan_07_04_jump_player, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "player_jump_landing_idle", "jump_land", false, false, true );
	add_player_anim( "player_body", %player::p_pan_07_04_jump_player_loop, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "mason_balcony_jump", "save_noriega" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_04_jump_mason_jump );
	
	add_scene( "noriega_balcony_run", "save_noriega" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_run2door );
	
	add_scene( "mason_watch_watertower", "jump_land", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_04_jump_mason_watch_watertower );
	
	add_scene( "noriega_roof_door_wait", "jump_land", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_04_jump_noriega_waitidle );
	
	add_scene( "mason_roof_regroup", "jump_land" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_04_jump_mason_run2noriega );
	
	add_scene( "enter_burning_building", "mason_door_kick" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_06_burning_building_mason_move2grab );
	add_actor_anim( "mason", %generic_human::ch_pan_07_06_burning_building_noriega_move2grab );
	
	add_scene( "burning_building_door_idle", "mason_door_kick", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_06_burning_building_mason_grabidl );
	add_actor_anim( "mason", %generic_human::ch_pan_07_06_burning_building_noriega_grabidl );
	
	add_scene( "burning_building_run_noriega", "mason_door_kick" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_06_burning_building_noriega_runthru );
	
	add_scene( "burning_building_run_mason", "mason_door_kick" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_06_burning_building_mason_runthru );
	
	add_scene( "burning_building_stairs_idle", "mason_door_kick", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_06_burning_building_mason_waitstairs );
	
	add_scene( "backdraft_slide", "mason_door_kick" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_06_burning_building_mason_backdraftslide );
	
	add_scene( "player_slide_jump", "mason_door_kick" );
	add_player_anim( "player_body", %player::p_pan_07_06_burning_building_player, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_notetrack_flag( "player_body", "slow_mo_start", "slide_slow_start" );
	add_notetrack_flag( "player_body", "slow_mo_stop", "slide_slow_end" );
	
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
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_startidl, false, false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_startidl, false, false, false, true );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_guard3_startidl, false, false, false, true );
	add_actor_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_guard4_startidl, false, false, false, true );
	add_actor_anim( "guard_prisoner", %generic_human::ch_pan_07_09_checkpoint_prisonerguard_standidl, false, false, false, true );
	
	add_scene( "checkpoint_ally_walkout", "slums_checkpoint" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_walkout );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_walkout );
	
	add_scene( "checkpoint_stop", "slums_checkpoint" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_stop );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_stop );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_stop, false, false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_stop, false, false, false, true );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_guard3_stop, false, false, false, true );
	add_actor_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_guard4_stop, false, false, false, true );
	add_actor_anim( "guard_prisoner", %generic_human::ch_pan_07_09_checkpoint_prisonerguard_stop, false, false, false, true );
	
	add_scene( "checkpoint_stop_idle_allies_guard_group2", "slums_checkpoint", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_stopidl );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_stopidl );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_guard3_stopidl, false, false, false, true );
	add_actor_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_guard4_stopidl, false, false, false, true );
	add_actor_anim( "guard_prisoner", %generic_human::ch_pan_07_09_checkpoint_prisonerguard_stopidl, false, false, false, true );
	
	add_scene( "checkpoint_stop_idle_guard_group1", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_stopidl, false, false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_stopidl, false, false, false, true );
	
	add_scene( "checkpoint_advance", "slums_checkpoint" );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_advance, false, false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_advance, false, false, false, true );
	
	add_scene( "checkpoint_cleared_mason", "slums_checkpoint" );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_cleared );
	
	add_scene( "checkpoint_cleared_noriega", "slums_checkpoint" );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_cleared );
	
	add_scene( "checkpoint_cleared_guard_prisoner", "slums_checkpoint" );
	add_actor_anim( "guard_prisoner", %generic_human::ch_pan_07_09_checkpoint_prisonerguard_cleared, false, false, false, true );
	
	add_scene( "checkpoint_cleared_guards_group1", "slums_checkpoint" );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_cleared, false, false, false, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_cleared, false, false, false, true );
	
	add_scene( "checkpoint_cleared_guards_group2", "slums_checkpoint" );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_guard3_cleared, false, false, false, true );
	add_actor_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_guard4_cleared, false, false, false, true );
	
	add_scene( "checkpoint_end_idle_mason", "slums_checkpoint", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_07_09_checkpoint_mason_endidl );
	
	add_scene( "checkpoint_end_idle_noriega", "slums_checkpoint", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_07_09_checkpoint_noriega_endidl );
	
	add_scene( "checkpoint_end_idle_guards_group1", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard1", %generic_human::ch_pan_07_09_checkpoint_guard1_endidl, false, false, true, true );
	add_actor_anim( "checkpoint_guard2", %generic_human::ch_pan_07_09_checkpoint_guard2_endidl, false, false, true, true );
	
	add_scene( "checkpoint_end_idle_guards_group2", "slums_checkpoint", false, false, true );
	add_actor_anim( "checkpoint_guard3", %generic_human::ch_pan_07_09_checkpoint_guard3_endidl, false, false, true, true );
	add_actor_anim( "checkpoint_guard4", %generic_human::ch_pan_07_09_checkpoint_guard4_endidl, false, false, true, true );
	
	add_scene( "checkpoint_end_idle_guard_prisoner", "slums_checkpoint", false, false, true );
	add_actor_anim( "guard_prisoner", %generic_human::ch_pan_07_09_checkpoint_prisonerguard_standidl, false, false, true, true );
	
	add_scene( "checkpoint_civ_lineup", "slums_checkpoint", false, false, true );
	add_actor_anim( "lineup_civ1", %generic_human::ch_pan_07_09_checkpoint_lineup_civ1, true, false, true, true );
	add_actor_anim( "lineup_civ2", %generic_human::ch_pan_07_09_checkpoint_lineup_civ2, true, false, true, true );
	add_actor_anim( "lineup_civ3", %generic_human::ch_pan_07_09_checkpoint_lineup_civ3, true, false, true, true );
	add_actor_anim( "lineup_civ4", %generic_human::ch_pan_07_09_checkpoint_lineup_civ4, true, false, true, true );
	add_actor_anim( "lineup_civ5", %generic_human::ch_pan_07_09_checkpoint_lineup_civ5, true, false, true, true );
	
	add_scene( "prisoners_idle", "slums_checkpoint", false, false, true );
	add_actor_anim( "prisoner1", %generic_human::ch_pan_07_09_checkpoint_prisoner1_sitidl, true, false, true, true );
	add_actor_anim( "prisoner2", %generic_human::ch_pan_07_09_checkpoint_prisoner2_sitidl, true, false, true, true );
	add_actor_anim( "prisoner3", %generic_human::ch_pan_07_09_checkpoint_prisoner3_sitidl, true, false, true, true );
	add_actor_anim( "prisoner4", %generic_human::ch_pan_07_09_checkpoint_prisoner4_sitidl, true, false, true, true );
	
	add_scene( "tough_guys", "slums_checkpoint", false, false, true );
	add_actor_anim( "tough_guy1", %generic_human::ch_pan_07_09_checkpoint_tough1, true, false, true, true );
	add_actor_anim( "tough_guy2", %generic_human::ch_pan_07_09_checkpoint_tough2, true, false, true, true );
	add_actor_anim( "tough_guy3", %generic_human::ch_pan_07_09_checkpoint_tough3, true, false, true, true );
}

docks_anims()
{
	add_scene( "docks_drive", "docks_car_path" );
	add_vehicle_anim( "blackops_jeep_docks", %vehicles::v_pan_08_01_gate_crash_jeep, false );
	//add_actor_anim( "gate_guard1", %generic_human::ch_pan_08_01_gatecrash_guard1 );
	//add_actor_anim( "gate_guard2", %generic_human::ch_pan_08_01_gatecrash_guard2 );
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
	add_prop_anim( "anim_sniper_rifle", %animated_props::o_pan_08_01_jeep_rifle_grab_rifle, "t6_wpn_sniper_m82_world", true );
	
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
	
	add_scene( "mount_sniper_turret", "take_the_shot" );
	add_player_anim( "player_body", %player::p_pan_08_06_take_the_shot_player_pickup_gun, true, 0, undefined, true, 0, 15, 15, 15, 15 );
	
	add_scene( "sniper_walk", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_walk );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_walk );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_walk );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_walk, "p6_anim_burlap_sack" );
	
	add_scene( "sniper_start_idle", "bag_on_head", false, false, true );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_firstidl );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_firstidl );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_firstidl );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_firstidl, "p6_anim_burlap_sack", true );
	
	add_scene( "sniper_shot", "bag_on_head" );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_shot );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_shot );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_shot );

	add_scene( "sniper_shot_idle", "bag_on_head", false, false, true );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_08_07_sniper_guard1_secondidl );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_08_07_sniper_guard2_secondidl );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_08_07_sniper_mason_secondidl );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_08_07_sniper_sack_secondidl, "p6_anim_burlap_sack" );

	add_scene( "betrayed", "bag_on_head" );
	add_actor_anim( "noriega", %generic_human::ch_pan_09_01_betrayed_noriega, false, false, true );
	add_actor_anim( "sniper_guard1_ai", %generic_human::ch_pan_09_01_betrayed_gaurd_1, false, false, true );
	add_actor_anim( "sniper_guard2_ai", %generic_human::ch_pan_09_01_betrayed_gaurd_2, false, false, true );
	add_player_anim( "player_body", %player::p_pan_09_01_betrayed_player, false, 0, undefined, true, 0, 15, 15, 15, 15 );
	add_prop_anim( "burlap_sack", %animated_props::o_pan_09_01_betrayed_sack, "p6_anim_burlap_sack", true );
	add_notetrack_flag( "player_body", "fade_in", "docks_betrayed_fade_in" );
	add_notetrack_flag( "player_body", "fade_out", "docks_betrayed_fade_out" );
	add_notetrack_custom_function( "player_body", "shot_1", maps\panama_docks::swap_player_body_dmg1 );
	add_notetrack_custom_function( "player_body", "shot_2", maps\panama_docks::swap_player_body_dmg2 );
	
	add_scene( "betrayed_mason_body", "bag_on_head", false, false, true );
	add_actor_anim( "mason_prisoner_ai", %generic_human::ch_pan_09_01_betrayed_mason );
	
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
	//add_actor_anim( "final_cin_skinner", %generic_human::ch_pan_09_01_recovered_skinner, false, false, false, true, "origin_animate_jnt" );
	add_actor_model_anim( "final_cin_skinner", %generic_human::ch_pan_09_01_recovered_skinner, "c_usa_seal80s_skinner_fb", false, "origin_animate_jnt" );
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

house_anims()
{
	//Player getting out of Hummer
	add_scene( "player_exits_hummer", "front_yard_align" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_01_01_intro_out_of_hummer_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	//place vehicle animation here
	add_vehicle_anim( "player_hummer", %vehicles::v_pan_01_01_intro_out_of_hummer_hum1, false );
	
	//Mason Getting out of Hummer
	add_scene( "mason_exits_hummer", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_out_of_hummer_mason, true );
	
	add_scene( "mason_hummer_scene", "front_yard_align" );
	add_vehicle_anim( "mason_hummer", %vehicles::v_pan_01_01_intro_out_of_hummer_hum2, false );

	//Skinner/Jane Arguing
	add_scene( "skinner_jane_argue_loop", "front_yard_align", false, false, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_argue_idle_skinner, true, false, false, true );
	add_actor_anim( "jane", %generic_human::ch_pan_01_01_intro_argue_idle_jane, true, false, false, true );
	
	//Skinner waves player around
	add_scene( "skinner_waves_us_back", "front_yard_align" );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_frontdoor_skinner, true, false, true, true );
	add_actor_anim( "jane", %generic_human::ch_pan_01_01_intro_frontdoor_jane, true, false, true, true );
	
	//Mason idles the gate
	add_scene( "mason_opens_gate_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_gate_idle_mason, true, false, false, true );
	
	//Mason opens the gate to dog
	add_scene( "mason_opens_gate", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_tobackyard_mason, true );
	
	add_scene( "dog_gate", "front_yard_align" );
	add_actor_anim( "skinners_dog", %dog::ch_pan_01_01_intro_tobackyard_dog, false, false, true );
	
	add_scene( "jane_gate", "front_yard_align" );
	add_actor_anim( "jane", %generic_human::ch_pan_01_01_intro_tobackyard_jane, true, false, true, true );
	
	//Skinner walkiing with beers
	add_scene( "skinner_with_beers", "front_yard_align" );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_tobackyard_skinner, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_tobackyard_beer, "p6_anim_beer_pack", false, false );
	//add_prop_anim( str_animname, animation, str_model, do_delete, is_simple_prop, a_parts, str_tag )
	
	//Mason and Skinner beer idle
	add_scene( "mason_beer_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_drinking_idle_mason, true );
	
	add_scene( "skinner_beer_loop", "front_yard_align", false, false, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_drinking_idle_skinner, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_drinking_idle_beer, "p6_anim_beer_pack", false, false );
	
	add_scene( "fake_woods_grabs_bag", "front_yard_align" );
	add_actor_model_anim( "fake_woods", %generic_human::ch_pan_01_01_intro_get_bag_woods, "c_usa_milcas_woods_fb", true );

	//Player and Full Woods grabs bag
	add_scene( "player_grabs_bag", "front_yard_align" );
	add_prop_anim( "bag", %animated_props::o_pan_01_01_intro_get_bag_bag, "p6_anim_duffle_bag" );
	add_prop_anim( "pajamas", %animated_props::o_pan_01_01_intro_get_bag_pajamas, "p6_anim_cloth_pajamas" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_01_01_intro_get_bag_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	//Mason/Skinner bag anim
	add_scene( "mason_bag_anim", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_get_bag_mason, true );
	
	add_scene( "skinner_bag_anim", "front_yard_align" );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_get_bag_skinner, true );
	add_prop_anim( "beer", %animated_props::o_pan_01_01_intro_get_bag_beer, "p6_anim_beer_pack", false, false );

	//Mason and Skinner trashcan idles
	add_scene( "mason_trashcan_loop", "front_yard_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_trash_idle_mason, true );
	
	add_scene( "skinner_trashcan_loop", "front_yard_align", false, false, true );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_trash_idle_skinner, true );

	//Player/Mason/Skinner walk to frontyard
	add_scene( "player_frontyard_walk", "front_yard_align" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_01_01_intro_end_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	add_scene( "mason_frontyard_walk", "front_yard_align" );
	add_actor_anim( "mason", %generic_human::ch_pan_01_01_intro_end_mason, true );
	
	add_scene( "skinner_frontyard_walk", "front_yard_align" );
	add_actor_anim( "skinner", %generic_human::ch_pan_01_01_intro_end_skinner, true );
}

airfield_anims()
{
	/*
Align Nodes
beach area - boat_landing_align
first blood area - first_blood_align

boat_landing_align_temp

mason_hangar
seal_standoff
hangar_roof
control_room
hangar_fight


	 */

	add_scene( "zodiac_approach_boat", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_player", %animated_props::o_pan_02_01_beach_approach_zodiac, undefined, true );

	add_scene( "zodiac_approach_seals", "m_intro_zodiac_player" );
	add_actor_anim( "ai_zodiac_seal_1", %generic_human::ch_pan_02_01_beach_approach_seal_1, true, false, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_seal_2", %generic_human::ch_pan_02_01_beach_approach_seal_2, true, false, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_seal_3", %generic_human::ch_pan_02_01_beach_approach_seal_3, true, false, true, true, "origin_animate_jnt" );
	
	add_scene( "zodiac_approach_mason", "m_intro_zodiac_player" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_01_beach_approach_mason, true, true, false, false, "origin_animate_jnt" );
	
	add_scene( "zodiac_dismount_mason", "boat_landing_align_temp" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_01_beach_approach_mason_dismount );
		
	add_scene( "zodiac_approach_player", "m_intro_zodiac_player" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = "origin_animate_jnt";
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 80;
	n_left_arc = 60;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_01_beach_approach_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );

	add_scene( "zodiac_dismount_player", "boat_landing_align_temp" );
	add_player_anim( "player_body", %player::p_pan_02_01_beach_approach_player_dismount, true );
	
	//BOAT 1
	add_scene( "zodiac_approach_seal_boat_1", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_1", %animated_props::o_pan_02_01_beach_approach_zodiac_1 );
	
	add_scene( "zodiac_approach_seal_group_1", "m_intro_zodiac_1", false, false, true );
	add_actor_anim( "ai_zodiac_boat_1_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_1_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );
	
	//BOAT 2
	add_scene( "zodiac_approach_seal_boat_2", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_2", %animated_props::o_pan_02_01_beach_approach_zodiac_2 );
	
	add_scene( "zodiac_approach_seal_group_2", "m_intro_zodiac_2", false, false, true  );
	add_actor_anim( "ai_zodiac_boat_2_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_2_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );
	
	//BOAT 3
	add_scene( "zodiac_approach_seal_boat_3", "boat_landing_align_temp" );
	add_prop_anim( "m_intro_zodiac_3", %animated_props::o_pan_02_01_beach_approach_zodiac_3 );
	
	add_scene( "zodiac_approach_seal_group_3", "m_intro_zodiac_3", false, false, true  );
	add_actor_anim( "ai_zodiac_boat_3_seal_1", %generic_human::ch_pan_02_01_zodiac_crew_idle_1, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_2", %generic_human::ch_pan_02_01_zodiac_crew_idle_2, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_3", %generic_human::ch_pan_02_01_zodiac_crew_idle_3, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_4", %generic_human::ch_pan_02_01_zodiac_crew_idle_4, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_5", %generic_human::ch_pan_02_01_zodiac_crew_idle_5, true, true, true, true, "origin_animate_jnt" );
	add_actor_anim( "ai_zodiac_boat_3_seal_6", %generic_human::ch_pan_02_01_zodiac_crew_idle_6, true, true, true, true, "origin_animate_jnt" );

	//player contextual kill
	add_scene( "player_grate", "first_blood_align" );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_in, true );
	
	add_scene( "player_melee_loop", "first_blood_align", false, false, true );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_loop, true );
	
	add_scene( "player_melee_grab_kill", "first_blood_align" );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_grab_gaurd, true );
	
	add_scene( "player_button_wait", "first_blood_align" );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_button_loop, true );	
	
	add_scene( "player_melee_kill", "first_blood_align" );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_kills, true );	

	add_scene( "player_melee_no_kill", "first_blood_align" );
	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_no_kill, true );	
	
	//guard 1, the guy the player kills
	add_scene( "guard_01_walkup", "first_blood_align" );
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_gaurd_01_walkup );
	
	add_scene( "guard_01_loop", "first_blood_align", false, false, true );
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_gaurd_01_loop );
	
	add_scene( "guard_01_grab_kill", "first_blood_align" ); 
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_grabbed );
	
	add_scene( "guard_01_button_wait", "first_blood_align" ); 
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_button_loop );
	
	add_scene( "guard_01_kill", "first_blood_align" ); 
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_killed_guard01 );
	
	add_scene( "guard_01_no_kill", "first_blood_align" ); 
	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_guard01_no_kill );
	
	//guard 2
	add_scene( "guard_02_loop", "first_blood_align", false, false, true );
	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_gaurd_02_loop );
	
	add_scene( "guard_02_kill", "first_blood_align" ); 
	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_killed_guard02 );
	
	//guard 3, booth guy
	add_scene( "guard_03_loop", "first_blood_align", false, false, true );
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_loop );
	
	add_scene( "guard_03_button_wait", "first_blood_align" );
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_button_loop );	
	
	add_scene( "guard_03_kill", "first_blood_align" ); 
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_killed );	
	
	add_scene( "guard_03_no_kill", "first_blood_align" ); 
	add_actor_anim( "guard_3", %generic_human::ch_pan_02_03_guards_gaurd_03_lives );
					
	//mason
	add_scene( "mason_melee_loop", "first_blood_align", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_loop );	

	add_scene( "mason_melee_kill", "first_blood_align" ); 
	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_kills );		
	
//	add_scene( "first_blood_guards_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_arguing_guard01, false, true, false, false );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_arguing_guard02, false, true, false, false );
//	
//	add_scene( "first_blood_guard_1_reaction", "first_blood_align" );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_reaction_guard01, false, true, false, false );
//	
//	add_scene( "first_blood_guard_2_reaction", "first_blood_align" );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_reaction_guard02, false, true, false, false );
//
//	add_scene( "mason_cliff_mantle", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_mantle_cliff_mason );
//
//	add_scene( "mason_cliff_approach", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_in );
//	
//	add_scene( "mason_cliff_loop", "first_blood_align", false, false, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_loop );
//
//	add_scene( "player_cliff_kill", "first_blood_align" );
//	add_player_anim( "player_body", %player::p_pan_02_03_guards_player_kills, true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_kills );
//	add_actor_anim( "guard_1", %generic_human::ch_pan_02_03_guards_killed_guard01 );
//	add_actor_anim( "guard_2", %generic_human::ch_pan_02_03_guards_killed_guard02 );
//
//	add_scene( "mason_cliff_crawl", "first_blood_align", true );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_crawls );
//
//	add_scene( "mason_cliff_reaction", "first_blood_align" );
//	add_actor_anim( "mason", %generic_human::ch_pan_02_03_guards_mason_reacts );
	
	add_scene( "mason_standoff_fence_kick", "hangar_hatch", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_07_fence_kick_mason );
	add_notetrack_custom_function( "mason", "door_kick", maps\panama_airfield::open_ladder_door );
	
	add_scene( "mason_standoff_arrival", "hangar_hatch", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_enter_mason );
	
	add_scene( "mason_standoff_loop", "hangar_hatch", true, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_loop_mason );

	add_scene( "mason_standoff_exit", "hangar_hatch" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_07_hangar_ladder_exit_mason );

	add_scene( "pdf_ladder_loop", "hangar_hatch", false, false, true );
	add_actor_anim( "ladder_pdf", %generic_human::ch_pan_02_07_hangar_ladder_soldier_loop );
	add_notetrack_custom_function( "ladder_pdf", "muzzle_flash", maps\panama_airfield::extra_muzzle_flash );

	add_scene( "pdf_ladder_reaction", "hangar_hatch" );
	add_actor_anim( "ladder_pdf", %generic_human::ch_pan_02_07_hangar_ladder_soldier_reaction );

	//ladder hatch
	add_scene( "ladder_hatch", "hangar_hatch" );
	add_prop_anim( "ladder_hatch", %animated_props::o_pan_02_07_hangar_ladder_door_hatch, "p6_anim_hangar_hatch" );
	
	//Player opening hatch
	add_scene( "player_opens_hatch", "hangar_hatch" );

	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_07_hangar_ladder_door_open_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );


	add_scene( "player_exits_hatch", "hangar_hatch" );
	
	b_do_delete = true;
	n_player_number = 0;
	str_tag = undefined;
	b_do_delta = true;
	n_view_fraction = 0;
	n_right_arc = 30;
	n_left_arc = 30;
	n_top_arc = 30;
	n_bottom_arc = 30;
	b_use_tag_angles = true;
	
	add_player_anim( "player_body", %player::p_pan_02_07_hangar_ladder_door_exit_player,
	                b_do_delete,  n_player_number, str_tag, b_do_delta, n_view_fraction,
	                n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, b_use_tag_angles );
	
	//slide anim
	add_scene( "rooftop_slide_1", "hangar_roof", true );
	add_actor_anim( "slide_guy_1", %generic_human::ch_pan_02_08_rooftop_slide_guy01 );
	
	add_scene( "rooftop_slide_2", "hangar_roof", true );
	add_actor_anim( "slide_guy_2", %generic_human::ch_pan_02_08_rooftop_slide_guy02 );
	
	//seal_standoff = align_node
	add_scene( "seal_standoff_loop", "seal_standoff", false, false, true );
	add_actor_anim( "seal_1", %generic_human::ch_pan_02_07_standoff_seal_01, false, true, false, true );
	add_actor_anim( "seal_2", %generic_human::ch_pan_02_07_standoff_seal_02, false, true, false, true );
	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_standoff_seal_03, false, true, false, true );
	add_actor_anim( "seal_4", %generic_human::ch_pan_02_07_standoff_seal_04, false, true, false, true );
	add_actor_anim( "seal_5", %generic_human::ch_pan_02_07_standoff_seal_05, false, true, false, true );
	add_actor_anim( "seal_6", %generic_human::ch_pan_02_07_standoff_seal_06, false, true, false, true );
	add_actor_anim( "seal_7", %generic_human::ch_pan_02_07_standoff_seal_07, false, true, false, true );
	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_standoff_seal_08, false, true, false, true );
	
	add_scene( "seal_rescue_1", "seal_standoff" );
	add_actor_anim( "seal_rescue_guy_1", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_1, false, true, false, true );
	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_8, false, true, false, true );
	
	add_scene( "seal_rescue_1_dies", "seal_standoff" );
	add_actor_anim( "seal_rescue_guy_1", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_1_dies, false, true, false, true );
	add_actor_anim( "seal_8", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_8_dies, false, true, false, true );
	
	add_scene( "seal_rescue_2", "seal_standoff" );
	add_actor_anim( "seal_rescue_guy_2", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_2, false, true, false, true );
	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_3, false, true, false, true );
	
	add_scene( "seal_rescue_2_dies", "seal_standoff" );
	add_actor_anim( "seal_rescue_guy_2", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_2_dies, false, true, false, true );
	add_actor_anim( "seal_3", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_3_dies, false, true, false, true );
	
	add_scene( "seal_rescue_3", "seal_standoff" );
	add_actor_anim( "seal_rescue_guy_3", %generic_human::ch_pan_02_07_bravo_assist_seal_rescue_4, false, true, false, true );
	add_actor_anim( "seal_5", %generic_human::ch_pan_02_07_bravo_assist_seal_injured_5, false, true, false, true );

	add_scene( "mason_skylight_approach", "hangar_roof", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_approach_mason );

	add_scene( "mason_skylight_loop", "hangar_roof", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_loop_mason );
	
	add_scene( "mason_skylight_jump_in", "hangar_roof" );
	add_actor_anim( "mason", %generic_human::ch_pan_02_08_skylight_entry_mason );
//	add_prop_anim( "m_skylight_door", %animated_props::o_pan_02_08_skylight_entry_door );
	
	add_scene( "mason_hangar_door_kick", "hangar_doorkick_align", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_09_door_kick_mason );
	add_prop_anim( "hangar_door_mason", %animated_props::ch_pan_02_09_door_kick_door, undefined, false, true );
	
	add_scene( "player_intruder", "control_room" );
	add_player_anim( "player_body", %player::int_specialty_panama_intruder, true );
	add_prop_anim( "boltcutter_intruder", %animated_props::o_specialty_panama_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true );
	add_prop_anim( "lock_intruder", %animated_props::o_specialty_panama_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
	
	add_scene( "pdf_door_reaction_0", undefined, false, false, false, true );
	add_actor_anim( "pdf_0", %generic_human::ch_pan_02_09_hangar_door_reactions_1 );
	
	add_scene( "pdf_door_reaction_1", undefined, false, false, false, true );
	add_actor_anim( "pdf_1", %generic_human::ch_pan_02_09_hangar_door_reactions_2 );
	
	add_scene( "pdf_door_reaction_2", undefined, false, false, false, true );
	add_actor_anim( "pdf_2", %generic_human::ch_pan_02_09_hangar_door_reactions_3 );

	add_scene( "seal_group_1_hangar_entry", "seal_standoff" );
	add_actor_anim( "seal_guy_1", %generic_human::ch_pan_02_11_seal_hangar_entry_seal01, false, true, false, true );
	add_actor_anim( "seal_guy_2", %generic_human::ch_pan_02_11_seal_hangar_entry_seal02, false, true, false, true );

	add_scene( "seal_group_2_hangar_entry", "seal_standoff" );
	add_actor_anim( "seal_guy_3", %generic_human::ch_pan_02_11_seal_hangar_entry_seal03, false, true, false, true );
	add_actor_anim( "seal_guy_4", %generic_human::ch_pan_02_11_seal_hangar_entry_seal04, false, true, false, true );

	//Unloading boxes off of Gaz66
	add_scene( "unloading_gaz66_truck_loop", undefined, false, false, true, true );
	add_vehicle_anim( "unloading_gaz", %vehicles::v_pan_02_04_unloading_gaz66_loop, false, undefined, "tag_origin" );

	add_scene( "truck_guy_1_loop", "unloading_gaz", false, false, true, true );
	add_actor_anim( "truck_pdf_1", %generic_human::ch_pan_02_04_unloading_guy1_loop, true, true, false, false, "tag_origin_animate_jnt" );
	
	add_scene( "truck_guy_2_loop", "unloading_gaz", false, false, true, true );
	add_actor_anim( "truck_pdf_2", %generic_human::ch_pan_02_04_unloading_guy2_loop, true, true, false, false, "tag_origin_animate_jnt" );
	
	//reaction
	add_scene( "truck_pdf_1_reaction", "unloading_gaz", false, false, false, true );
	add_actor_anim( "truck_pdf_1", %generic_human::ch_pan_02_04_unloading_guy1_reaction, false, true );

	add_scene( "truck_pdf_2_reaction", "unloading_gaz", false, false, false, true );
	add_actor_anim( "truck_pdf_2", %generic_human::ch_pan_02_04_unloading_guy2_reaction, false, true );

	add_scene( "unloading_box_loop", "unloading_gaz", false, false, true );
	add_prop_anim( "the_box", %animated_props::o_pan_02_04_unloading_box_loop, "anim_jun_ammo_box", true, true, undefined, "tag_origin_animate_jnt" );

	add_scene( "shoulder_bash", "motel_path_bash", true );
	add_actor_anim( "mason", %generic_human::ch_pan_02_10_shoulder_bash_mason );
	
	add_scene( "learjet_explosion", "vh_lear_jet" );
	add_vehicle_anim( "vh_lear_jet", %fxanim_props::fxanim_panama_private_jet_anim );
		
}

#using_animtree( "generic_human" );
patroller_anims()
{
	level.scr_anim[ "generic" ][ "bored_idle" ][ 0 ]			 	 = %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_walk" ]					 = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "smoke_idle" ][ 0 ]			 	 = %patrol_bored_idle_smoke;
	
	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			 = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			 = %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "exchange_surprise_2" ]			 = %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			 = %exposed_idle_twitch_v4;
	level.surprise_anims = 4;
}

//add_scene( str_scene_name, str_align_targetname, do_reach, do_generic, do_loop, do_not_align )
//add_prop_anim( str_animname, animation, str_model, do_delete, is_simple_prop, a_parts, str_tag )
//add_actor_anim( str_animname, animation, do_hide_weapon, do_give_back_weapon, do_delete, do_not_allow_death, str_tag )
//add_player_anim( str_animname, animation, do_delete, n_player_number, str_tag, do_delta, n_view_fraction, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, use_tag_angles, b_auto_center )

motel_anims()
{
	//Player Breach
	add_scene( "player_breach_intro", "motel_room" );
	add_player_anim( "player_body", %player::p_pan_03_01_old_friends_player_intro, true );

	add_scene( "player_breach_xcool", "motel_room" );
	add_player_anim( "player_body", %player::p_pan_03_01_xcool_player );

	add_scene( "player_breach_xcool_loop", "motel_room", false, false, true );
	add_player_anim( "player_body", %player::p_pan_03_01_xcool_playe_alt_wait );

	add_scene( "player_breach_xcool_end", "motel_room" );
	add_player_anim( "player_body", %player::p_pan_03_01_xcool_playe_end, true );

	//MASON BREACH
	add_scene( "mason_door_approach", "motel_room", true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_approach );

	add_scene( "mason_door_loop", "motel_room", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_door_loop );

	add_scene( "mason_breach_intro", "motel_room", true );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_old_friends_mason_intro );

	add_scene( "mason_breach_xcool", "motel_room" );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_xcool_mason );
	add_prop_anim( "bag", %animated_props::o_pan_03_01_xcool_bag, "p6_anim_duffle_bag" );
	add_prop_anim( "pajamas", %animated_props::o_pan_03_01_xcool_pajamas, "p6_anim_duffle_bag" );

	add_scene( "mason_breach_xcool_alt_1", "motel_room" );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_xcool_mason_alt_1 );

	add_scene( "mason_breach_xcool_alt_2", "motel_room" );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_xcool_mason_alt_2 );
	
	add_scene( "mason_breach_xcool_end", "motel_room" );
	add_actor_anim( "mason", %generic_human::ch_pan_03_01_xcool_mason_end );
	
	//THUG 1
	add_scene( "thug_1_intro", "motel_room" );
	add_actor_anim( "thug_1", %generic_human::ch_pan_03_01_old_friends_guy_1_intro );

	//THUG 2
	add_scene( "thug_2_intro", "motel_room" );
	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_intro );

	add_scene( "thug_2_shot", "motel_room" );
	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_shot );

	add_scene( "thug_2_death_loop", "motel_room", false, false, true );
	add_actor_anim( "thug_2", %generic_human::ch_pan_03_01_old_friends_guy_2_dead_loop );

	//THUG 3
	add_scene( "thug_3_intro", "motel_room" );
	add_actor_anim( "thug_3", %generic_human::ch_pan_03_01_old_friends_guy_3_intro );

	//THUG 4 ( surprise enemy )
	add_scene( "thug_4_intro", "motel_room" );
	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_intro );

	add_scene( "thug_4_shot", "motel_room" );
	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_shot );

	add_scene( "thug_4_shot_loop", "motel_room", false, false, true );
	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_old_friends_supprise_enemy_shot_loop );
	
	add_scene( "thug_4_crawl", "motel_room" );
	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_xcool_supprise_enemy_crawl );

	add_scene( "thug_4_killed", "motel_room" );
	add_actor_anim( "thug_4", %generic_human::ch_pan_03_01_xcool_supprise_enemy_killed ); //Notetrack “bullet_hit”
	
	//NORIEGA
	add_scene( "noriega_intro", "motel_room" );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_old_friends_noriega_intro );

	add_scene( "noriega_intro_loop", "motel_room", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_old_friends_noriega_intro_loop );

	add_scene( "noriega_intro_xcool", "motel_room" );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_xcool_noriega );
	add_prop_anim( "motel_table", %animated_props::o_pan_03_01_xcool_table, undefined, false, true ); //Tag_origin_animate

	add_scene( "noriega_intro_xcool_loop", "motel_room", false, false, true );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_xcool_noriega_alt_wait );

	add_scene( "noriega_intro_xcool_end", "motel_room" );
	add_actor_anim( "noriega", %generic_human::ch_pan_03_01_xcool_noriega_end ); //“bang” notetrack for the end
}
