#include maps\_utility;
#include maps\_scene;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_panama_2::init_voice();
	
	//section anim functions
	slums_anims();
	vehicle_prop_anims();

	//call after all scenes are setup
	precache_assets();
}

vehicle_prop_anims()
{
	add_scene( "truck_hood_up" );
	add_actor_anim( "anim_truck_hood", %animated_props::veh_anim_pickup_hood_open );
	
	add_scene( "car_driver_door_open" );
	add_actor_anim( "anim_car_door", %animated_props::veh_anim_80s_hatchback_door_open );
}

slums_anims()
{
//	add_scene( "slums_ambulance", "slum_ambulence_scene", false, false, true );
	add_scene( "slums_ambulance", "slum_ambulence_scene_2" );
	add_prop_anim( "ambulence", %animated_props::v_pan_04_02_amblulance_van );
	
//	add_scene( "slums_ambulance_doors", undefined, false, false, false, true );
//	add_vehicle_anim( "ambulence", %vehicles::veh_anim_80s_van_rear_doors_open );
			
	add_scene( "slums_intro_player", "slum_ambulence_scene" );
	add_player_anim( "player_body", %player::p_pan_04_01_intro_player_approach, true );
	add_notetrack_custom_function( "player_body", "show_arms", maps\panama_slums::intro_show_gun );
	
	add_scene( "slums_intro", "slum_ambulence_scene" );
	add_actor_anim( "mason", %generic_human::ch_pan_04_01_intro_mason_approach );
	add_actor_anim( "noriega", %generic_human::ch_pan_04_01_intro_noriaga_approach );
	
	add_scene( "slums_intro_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "mason", %generic_human::ch_pan_04_01_intro_mason_approach_cycle );
	add_actor_anim( "noriega", %generic_human::ch_pan_04_01_intro_noriaga_approach_cycle );
		
	add_scene( "slums_into_building", "slum_ambulence_scene" );
	add_actor_anim( "mason", %generic_human::ch_pan_04_03_to_building_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_04_03_to_building_noriega );
	add_prop_anim( "noriega_hat", %animated_props::o_pan_04_03_to_building_hat, "c_usa_milcas_woods_cap" );
	add_prop_anim( "noriega_pistol", %animated_props::o_pan_04_03_to_building_pistol, "t6_wpn_pistol_m1911_prop_view" );
	
	add_scene_loop( "slums_into_building_wait", "slum_ambulence_scene" );
	add_actor_anim( "mason", %generic_human::ch_pan_04_03_to_building_mason_wait );
	add_actor_anim( "noriega", %generic_human::ch_pan_04_03_to_building_noriega_wait );
	add_prop_anim( "noriega_hat", %animated_props::o_pan_04_03_to_building_noriega_hat_wait, "c_usa_milcas_woods_cap" );
	add_prop_anim( "noriega_pistol", %animated_props::o_pan_04_03_to_building_noriega_pistol_wait, "t6_wpn_pistol_m1911_prop_view" );
	
	add_scene( "slums_noriega_pistol", "slum_ambulence_scene" );
	add_actor_anim( "mason", %generic_human::ch_pan_05_01_noriega_pistol_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_01_noriega_pistol_noriega );
	add_prop_anim( "noriega_hat", %animated_props::o_pan_05_01_noriega_pistol_hat, "c_usa_milcas_woods_cap", true );
	add_prop_anim( "noriega_pistol", %animated_props::o_pan_05_01_noriega_pistol_pistol, "t6_wpn_pistol_m1911_prop_view", true );
	
	add_scene_loop( "slums_noriega_pistol_wait", "slum_ambulence_scene" );
	add_actor_anim( "mason", %generic_human::ch_pan_05_01_noriega_pistol_mason_wait );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_01_noriega_pistol_noriega_wait );
	add_prop_anim( "noriega_hat", %animated_props::o_pan_05_01_noriega_pistol_hat_wait, "c_usa_milcas_woods_cap", true );
	add_prop_anim( "noriega_pistol", %animated_props::o_pan_05_01_noriega_pistol_pistol_wait, "t6_wpn_pistol_m1911_prop_view", true );
	
    add_scene( "player_door_kick", "struct_player_kick" );
    add_player_anim( "player_body", %player::int_player_kick, true );
 	//add_notetrack_flag( "player_body", "kick_impact", "slums_rotate_door" );
   
    add_scene( "player_door_kick_door", "struct_player_door" );
    add_prop_anim( "player_blocker_door", %animated_props::o_panama_player_kick_door, undefined, false, true );

	
	/* TODO: DELETE ALL THESE ANIMS IF WE DON'T NEED THEM ANYMORE
	add_scene( "slums_move_overlook_mason", "slum_ambulence_scene" );
	add_actor_anim( "mason",			%generic_human::ch_pan_04_03_to_building_mason );
	
	add_scene( "slums_move_overlook_mason_loop", "slums_opening_read_body", false, false, true );
	add_actor_anim( "mason",			%generic_human::ch_pan_05_01_intro_mason_loop);
	
	add_scene( "slums_move_overlook_noriega", "slum_ambulence_scene" );
	add_actor_anim( "noriega",			%generic_human::ch_pan_04_03_to_building_noriega );
	
	add_scene( "slums_move_overlook_noriega_loop", "slums_opening_read_body", false, false, true );
	add_actor_anim( "noriega",			%generic_human::ch_pan_05_01_into_noriega_loop);
	
	add_scene( "slums_overlook_mason", "slums_opening_read_body" );
	add_actor_anim( "mason",			%generic_human::ch_pan_05_01_intro_mason );
//	add_notetrack_custom_function( "mason", "start_fire", maps\panama_slums::intro_overlook_gun_fire );
	//add_notetrack_custom_function( "mason", "door_open", maps\panama_slums::intro_overlook_door );
	add_notetrack_custom_function( "mason", "start_player_dialogue_1", maps\panama_slums::intro_player_vo_1 );
	add_notetrack_custom_function( "mason", "start_player_dialogue_2", maps\panama_slums::intro_player_vo_2 );
	
	add_scene( "slums_overlook_noriega", "slums_opening_read_body" );
	add_actor_anim( "noriega",			%generic_human::ch_pan_05_01_into_noriega );
	//add_notetrack_flag( "noriega", "objective_start", "slums_update_objective" );
	
	*/
	
	add_scene( "slums_intro_ambulance_loop_1", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_beating );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_2_beaten, true );
	
	add_scene( "slums_intro_ambulance_loop_2", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_beating );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_1_beaten, true );
	
	add_scene( "slums_intro_ambulance_loop_control", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_beating );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_beaten, true );

	add_scene( "slums_intro_digbat_fight", "slum_ambulence_scene" );
	add_actor_anim( "amb_digbat_4", %generic_human::ch_pan_04_01_intro_dig_bat_fight );

	add_scene( "slums_intro_digbat_loop", "slum_ambulence_scene", false, false, true );
	add_actor_anim( "amb_digbat_4", %generic_human::ch_pan_04_01_intro_dig_bat_beatdown_loop );
	
	add_scene( "slums_intro_react_amb_digbat_4", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_4",	%generic_human::ch_pan_04_02_amblulance_digbat_3_reaction );
	
	add_scene( "slums_intro_civ_3_fight", "slum_ambulence_scene" );
	add_actor_anim( "amb_doctor_3", %generic_human::ch_pan_04_01_intro_civ_fight );
	
//	add_scene( "slums_intro_civ_4_loop", "slum_ambulence_scene", false, false, true );
	add_scene( "slums_intro_civ_4_loop", "slum_ambulence_scene" );
	add_actor_anim( "amb_doctor_4", %generic_human::ch_pan_04_01_intro_civ_2_dead_loop );

///
	
	add_scene( "slums_intro_ambulance_kill", "slum_ambulence_scene_2" );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_killing );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_killing );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_killing );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_death, true );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_death, true );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_death, true );
	add_notetrack_flag( "amb_digbat_2", "no_return", "ambulance_staff_killed" );
	
	add_scene( "slums_intro_saved_amb_doctor_1", "slum_ambulence_scene_2" );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_saved, true );
	
	add_scene( "slums_intro_saved_amb_doctor_2", "slum_ambulence_scene_2" );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_saved, true );
	
	add_scene( "slums_intro_saved_amb_nurse", "slum_ambulence_scene_2" );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_saved, true );
	
	add_scene( "slums_intro_saved_loop_amb_doctor_1", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_doctor_1",		%generic_human::ch_pan_04_02_amblulance_doc_1_loop, true );
	
	add_scene( "slums_intro_saved_loop_amb_doctor_2", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_doctor_2",		%generic_human::ch_pan_04_02_amblulance_doc_2_loop, true );

	add_scene( "slums_intro_saved_loop_amb_nurse", "slum_ambulence_scene_2", false, false, true );
	add_actor_anim( "amb_nurse",		%generic_human::ch_pan_04_02_amblulance_nurse_loop, true );
	
	add_scene( "slums_intro_react_amb_digbat_1", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_1",		%generic_human::ch_pan_04_02_amblulance_digbat_1_reaction );
	
	add_scene( "slums_intro_react_amb_digbat_2", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_2",		%generic_human::ch_pan_04_02_amblulance_digbat_2_reaction );
	
	add_scene( "slums_intro_react_amb_digbat_3", undefined, false, false, false, true );
	add_actor_anim( "amb_digbat_3",		%generic_human::ch_pan_04_02_amblulance_digbat_3_reaction );
	
	add_scene( "slums_intro_corpses", "slum_ambulence_scene_2" );
	add_actor_model_anim( "amb_corpse_1", 	%generic_human::ch_pan_04_02_amblulance_dead_civ_1 );
	add_actor_model_anim( "amb_corpse_2", 	%generic_human::ch_pan_04_02_amblulance_dead_civ_2 );

	add_scene( "civs_building_01", "collapsed_bldg" );
	add_actor_anim( "fire_civ_01", %generic_human::ch_pan_04_02_civs_building_civ_01 );
	
	add_scene( "civs_building_02", "collapsed_bldg" );
	add_actor_anim( "fire_civ_02", %generic_human::ch_pan_04_02_civs_building_civ_02 );
			
	add_scene( "civs_building_03", "collapsed_bldg" );
	add_actor_anim( "fire_civ_03", %generic_human::ch_pan_04_02_civs_building_civ_03 );

	add_scene( "civs_building_04", "collapsed_bldg" );
	add_actor_anim( "fire_civ_04", %generic_human::ch_pan_04_02_civs_building_civ_04 );	
			
	add_scene( "civs_building_05", "collapsed_bldg" );
	add_actor_anim( "fire_civ_05", %generic_human::ch_pan_04_02_civs_building_civ_05 );	

	add_scene( "civs_building_06", "collapsed_bldg" );
	add_actor_anim( "fire_civ_06", %generic_human::ch_pan_04_02_civs_building_civ_06 );	
	
	add_scene( "parking_jump", "digbat_van_jump_2" );
	add_actor_anim( "slums_park_digbat_01",			%generic_human::ch_pan_05_23_parking_jump_digbat01 );
	
	add_scene( "parking_window", "digbat_van_jump" );
	add_actor_anim( "slums_park_digbat_02",			%generic_human::ch_pan_05_23_parking_jump_digbat02 );
	
	add_scene( "dumpster_push", "Dumpster_push" );
	add_actor_anim( "slums_dumpster_01",	%generic_human::ch_pan_05_15_dumpster_push_pdf01 );
	add_actor_anim( "slums_dumpster_02",	%generic_human::ch_pan_05_15_dumpster_push_pdf02 );
	add_actor_anim( "slums_dumpster_03",	%generic_human::ch_pan_05_15_dumpster_push_pdf03 );
	add_prop_anim( "slums_dumpster",		%animated_props::o_pan_05_15_dumpster_push_dumpster, undefined, false, true );
	
	add_scene( "brute_force", "5_17_brute_force" );
	add_actor_model_anim( "brute_force",	%generic_human::ai_specialty_panama_bruteforce_deadguy, undefined, false, undefined, undefined, "brute_force" );
	add_prop_anim( "brute_force_gate", %animated_props::o_specialty_panama_bruteforce_gate, undefined, false );
	add_prop_anim( "brute_force_strobe", %animated_props::o_specialty_panama_bruteforce_strobe, "t6_wpn_ir_strobe_world", true );
	
	add_scene( "brute_force_player", "5_17_brute_force" );
	add_player_anim( "player_body", %player::int_specialty_panama_bruteforce, true );
	add_prop_anim( "brute_force_crowbar", %animated_props::o_specialty_panama_bruteforce_crowbar, "t6_wpn_crowbar_prop", true );
	
	add_scene( "slums_apt_rummage_loop", "5_21_rummage", false, false, true );
	add_actor_anim( "e_21_digbat_1",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat01 );
	add_actor_anim( "e_21_digbat_2",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat02 );
	add_actor_anim( "e_21_digbat_3",			%generic_human::ch_pan_05_21_apt_rummage_loop_digbat03 );
	
	add_scene( "slums_apt_rummage_react", "5_21_rummage" );
	add_actor_anim( "e_21_digbat_1",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat01 );
	add_actor_anim( "e_21_digbat_2",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat02 );
	add_actor_anim( "e_21_digbat_3",			%generic_human::ch_pan_05_21_apt_rummage_reaction_digbat03 );
	
	add_scene( "beating_loop", "digbat_beating_1", false, false, true, true );
	add_actor_anim( "e_22_digbat",			%generic_human::ch_pan_05_22_beating_loop_digbat );
	
	add_scene( "beating_reaction", "digbat_beating_1" );
	add_actor_anim( "e_22_digbat",			%generic_human::ch_pan_05_22_beating_reaction_digbat );
	
	add_scene( "beating_corpse", "digbat_beating_1" );
	add_actor_model_anim( "e_22_corpse", 	%generic_human::ch_pan_05_22_beaten_corpse );
	
	add_scene( "slums_molotov_throw_left", "e_19_molotov_left" );
	add_actor_anim( "molotov_digbat",			%generic_human::ch_pan_05_19_molotov_throw_digbat );
	add_notetrack_custom_function( "molotov_digbat", "attach", maps\panama_slums::e_19_attach, true );
	add_notetrack_custom_function( "molotov_digbat", "shot", maps\panama_slums::e_19_shot, true );
	
	add_scene( "slums_molotov_throw_right", "e_19_molotov_right" );
	add_actor_anim( "molotov_digbat",			%generic_human::ch_pan_05_19_molotov_throw_digbat );
	
	add_scene( "slums_molotov_throw_left_alley", "e_19_molotov_alley_left" );
	add_actor_anim( "molotov_digbat",			%generic_human::ch_pan_05_19_molotov_throw_digbat );
	
	add_scene( "slums_apc_wall_crash", "APC_StoreCrash" );
	add_vehicle_anim( "slums_apc_building", %vehicles::fxanim_panama_laundromat_apc_anim );
	
	level.scr_anim[ "generic" ][ "exchange_surprise_0" ]			 = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "exchange_surprise_1" ]			 = %exposed_idle_reactB;
	level.scr_anim[ "generic" ][ "exchange_surprise_2" ]			 = %exposed_idle_twitch;
	level.scr_anim[ "generic" ][ "exchange_surprise_3" ]			 = %exposed_idle_twitch_v4;
 	level.surprise_anims = 4;	
 	
 	add_scene( "slums_breach_exit", "clinic_entrance" );
 	add_actor_anim( "mason", %generic_human::ch_pan_06_02_clinic_walkthru_mason_entry );
 	add_actor_anim( "noriega", %generic_human::ch_pan_06_02_clinic_walkthru_noriega_entry );
 	add_notetrack_custom_function( "mason", "kick_door", maps\panama_slums::notetrack_function_end_mission );
 	add_notetrack_custom_function( "mason", "kick_door", ::rotate_the_clinic_door );
 	
 	//critical path anims
 	add_scene( "slums_critical_path_before_library", "anim_moment_4", true );
 	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_stairs_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_stairs_noriega );
	
	add_scene( "slums_critical_path_first_car", "anim_moment_1", true );
	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_car_enter_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_car_enter_noriega );
	
	add_scene_loop( "slums_critical_path_first_car_idle", "anim_moment_1" );
	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_car_idle_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_car_idle_noriega );
	
	add_scene( "slums_critical_path_first_car_exit", "anim_moment_1" );
	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_car_exit_mason );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_car_exit_noriega );
	
	//TODO: for this moment, we might need to make both of them idle for a second
	add_scene( "slums_critical_path_to_barrels_from_wall_mason", "struct_start_after_barrels_noriega", false ); //-- this one starts from cover
	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_barrel_mason );
	add_scene( "slums_critical_path_to_barrels_from_wall_noriega", "struct_start_after_barrels_mason", false ); //-- this one starts from cover
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_barrel_noriega );
	
	add_scene( "slums_critical_path_along_the_wall_mason", "struct_align_wall_mason", true );
	add_actor_anim( "mason", %generic_human::ch_pan_05_cover_wall_mason );
	add_scene( "slums_critical_path_along_the_wall_noriega", "struct_align_wall_noriega", true );
	add_actor_anim( "noriega", %generic_human::ch_pan_05_cover_wall_noriega );
}

rotate_the_clinic_door( guy )
{
	e_door = GetEnt( "clinic_frontdoor", "targetname" );
	e_rotator = GetEnt( "clinic_door_rotator", "targetname" );
	
	e_door LinkTo( e_rotator );
	
	e_rotator RotateYaw( -110, 0.8, 0.05, .75 );
}