#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_angola::init_voice();
	angola_temp_vo();
	
	//section anim functions
	riverbed_anims();
	savannah_anims();
	savannah_end_anims();
	savimbi_ride_anims();

	//call after all scenes are setup 
	precache_assets();
}

angola_temp_vo()
{
	//add_dialog( "savimbi_ready", "Savimbi: They are readying for another attack!  Prepare yourselves!" );
	//add_dialog( "savimbi_hold", "Savimbi: Hold the line!" );
	add_dialog( "savimbi_warning", "Savimbi: MASON! Come back! Stay with the convoy!" );
	//add_dialog( "savimbi_attack", "Savimbi: NOW! Kill them!" );
	add_dialog( "hudson_incoming", "Hudson: Coming to your position ETA 1 Minute." );
	//add_dialog( "hudson_arrive", "Hudson: Looks like you could use some help Mason." );
	//add_dialog( "mason_arrive", "Mason: About fucking time Hudson!" );
	//add_dialog( "hudson_ready", "Hudson: Ready to make a run, tell me when." );
	//add_dialog( "mason_ready", "Mason: Do it now!" );
	//add_dialog( "savimbi_final", "Savimbi: Hurry Mason!! It is time to make the final charge!" );
}

savimbi_ride_anims()
{
	add_scene( "savimbi_ride_idle", "savimbi_buffel", false, false, true );
	add_actor_anim( "savimbi", %generic_human::ch_ang_01_01_intro_savimbi_buffelidle, false, undefined, false, true, "tag_rear_door_l" );
	
	add_scene( "savimbi_ride_rally", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_01_01_intro_savimbi_rally, false, undefined, false, true, "tag_rear_door_l" );
	
	/*add_scene( "savimbi_fire_start", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_01_savimbi_fires_start, false, undefined, false, true, "tag_rear_door_l" );
	
	add_scene( "savimbi_fire_loop", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_01_savimbi_fires_loop, false, undefined, false, true, "tag_rear_door_l" );
	add_notetrack_custom_function( "savimbi", "fire_mgl", maps\angola_utility::savimbi_fire_mgl );
	
	add_scene( "savimbi_fire_stop", "savimbi_buffel");
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_01_savimbi_fires_end, false, undefined, false, true, "tag_rear_door_l" );*/
	
	add_scene( "savimbi_fire_mgl", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_01_savimbi_fires, false, undefined, false, true, "tag_rear_door_l" );
	add_notetrack_custom_function( "savimbi", "fire_mgl", maps\angola_utility::savimbi_fire_mgl );	
	
	add_scene( "savimbi_join_battle", "savimbi_buffel");
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_01_savimbi_joins_savimbi, false, undefined, false, true, "tag_rear_door_l" );
	add_notetrack_custom_function( "savimbi", "spawn_enemy", maps\angola_savannah::savimbi_buffel_spawn_enemy );
	add_notetrack_custom_function( "savimbi", "detatch_mgl", maps\angola_savannah::savimbi_buffel_drop_mgl );	
	
	add_scene( "savimbi_join_battle_enemy", "savimbi_buffel");
	add_actor_anim( "savimbi_enemy", %generic_human::ch_ang_03_01_savimbi_joins_enemy, false, false, false, true );
		
	add_scene( "savimbi_climb_on_again", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_05_lead_vehicle_climb_savimbi );
	
}

riverbed_anims()
{
	add_scene( "level_intro_player", "trapped_man" );
	add_player_anim( "player_body", %player::ch_ang_01_01_intro_player, SCENE_DELETE, 0, undefined, false, 1, 20, 20, 20, 20 );
	add_actor_model_anim( "burning_man", %generic_human::ch_ang_01_01_intro_burnguy );
	//add_vehicle_anim( "intro_buffel", %vehicles::v_ang_01_01_intro_buffel );
	add_notetrack_flag( "player_body", "head_look", "player_looking_at_burning_man" );
	add_notetrack_flag( "player_body", "look_savimbi_01", "player_looking_at_savimbi" );
	add_notetrack_flag( "player_body", "reveal", "player_looking_at_savimbi_reveal" );
	add_notetrack_flag( "player_body", "hit_window", "player_hit_window" );
	add_notetrack_flag( "player_body", "start_text", "show_introscreen_title" );
	
	add_scene( "level_intro_fake_player", "extracam" );
	add_actor_anim( "fake_mason", %generic_human::ch_ang_01_01_intro_reflection_player, true, false, true, true );
	
	add_scene( "level_intro_savimbi", "trapped_man");
	add_actor_anim( "savimbi", %generic_human::ch_ang_01_01_intro_savimbi, true, false );
	
	add_scene( "level_intro_savimbi_part2", "savimbi_buffel" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_01_01_intro_savimbi_part02, true, false, false, true, "tag_rear_door_l" );
	
	add_scene( "level_intro_savimbi_buffel", "trapped_man" );
	add_vehicle_anim( "savimbi_buffel", %vehicles::v_ang_01_01_intro_buffel02 );
		
	add_scene( "level_intro_soldier_1", "trapped_man" );
	add_actor_anim( "intro_soldier_1", %generic_human::ch_ang_01_01_intro_guy01 );
	
	add_scene( "level_intro_soldier_2", "trapped_man" );
	add_actor_anim( "intro_soldier_2", %generic_human::ch_ang_01_01_intro_guy02 );
	
	add_scene( "level_intro_soldier_3", "trapped_man" );
	add_actor_anim( "intro_soldier_3", %generic_human::ch_ang_01_01_intro_guy03 );

	add_scene( "level_intro_soldier_4", "trapped_man" );
	add_actor_anim( "intro_soldier_4", %generic_human::ch_ang_01_01_intro_guy04 );
	
	add_scene( "level_intro_soldier_5", "trapped_man" );
	add_actor_anim( "intro_soldier_5", %generic_human::ch_ang_01_01_intro_guy05 );
			
	add_scene( "level_intro_soldier_6", "trapped_man" );
	add_actor_anim( "intro_soldier_6", %generic_human::ch_ang_01_01_intro_guy06 );
			
	add_scene( "level_intro_soldier_7", "trapped_man" );
	add_actor_anim( "intro_soldier_7", %generic_human::ch_ang_01_01_intro_guy07 );
	
		
	//looping ambient animations for the starting area	
	add_scene( "riverbed_ambience_1", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_1", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy01 );
	
	add_scene( "riverbed_ambience_2", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_2", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy02 );
	
	add_scene( "riverbed_ambience_3", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_3", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy04 );
	
	add_scene( "riverbed_ambience_4", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_4", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy05 );
	add_prop_anim( "riverbed_ambience_4_box", %animated_props::o_ang_01_05_riverbed_vignettes_A_crates, "anim_jun_ammo_box" );
	
	add_scene( "riverbed_ambience_5", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_5", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy06 );
	
	add_scene( "riverbed_ambience_6", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_6", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy07 );
	
	add_scene( "riverbed_ambience_7", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_7", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy08 );
	
	add_scene( "riverbed_ambience_8", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_8", %generic_human::ch_ang_01_05_riverbed_vignettes_A_guy09 );
	
	add_scene( "riverbed_ambience_9", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_ambience_9", %generic_human::ch_ang_1_10_wave_to_savannah_guy01 );
	
	/*add_scene( "riverbed_ambience_vehicles", "trapped_man" );
	add_vehicle_anim( "riverbed_ambient_1_truck",  %vehicles::v_ang_01_05_riverbed_vignettes_A_gaz01_truck );
	add_vehicle_anim( "riverbed_ambient_1_cargo",  %vehicles::v_ang_01_05_riverbed_vignettes_A_gaz01_cargo );
	add_vehicle_anim( "riverbed_ambient_2_truck",  %vehicles::v_ang_01_05_riverbed_vignettes_A_gaz02_truck );
	add_vehicle_anim( "riverbed_ambient_2_cargo",  %vehicles::v_ang_01_05_riverbed_vignettes_A_gaz02_cargo );*/
	
	//Dead Bodies
	add_scene( "riverbed_corpses_driver", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_driver", %generic_human::ch_ang_01_05_riverbed_corpses_driver );
	
	add_scene( "riverbed_corpses_1", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_1", %generic_human::ch_ang_01_05_riverbed_corpses_guy01 );
	
	add_scene( "riverbed_corpses_2", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_2", %generic_human::ch_ang_01_05_riverbed_corpses_guy02 );
	
	add_scene( "riverbed_corpses_3", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_3", %generic_human::ch_ang_01_05_riverbed_corpses_guy03 );
	
	add_scene( "riverbed_corpses_4", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_4", %generic_human::ch_ang_01_05_riverbed_corpses_guy04 );
	
	add_scene( "riverbed_corpses_5", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_5", %generic_human::ch_ang_01_05_riverbed_corpses_guy05 );
	
	add_scene( "riverbed_corpses_6", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_6", %generic_human::ch_ang_01_05_riverbed_corpses_guy06 );
	
	add_scene( "riverbed_corpses_7", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_7", %generic_human::ch_ang_01_05_riverbed_corpses_guy07 );
	
	add_scene( "riverbed_corpses_8", "trapped_man", false, false, true );
	add_actor_model_anim( "riverbed_corpses_8", %generic_human::ch_ang_01_05_riverbed_corpses_guy08 );
	
	//lockbreaker related animations
	add_scene( "lockbreaker", "lockbreaker_buffel" );
	add_prop_anim( "lockbreaker_buffel",  %animated_props::o_specialty_angola_lockbreaker_buffel );
	
	add_scene( "lockbreaker_interact", "lockbreaker_buffel" );
	add_vehicle_anim( "lockbreaker_buffel",  %vehicles::o_specialty_angola_lockbreaker_buffel );
	add_player_anim( "player_body", %player::int_specialty_angola_lockbreaker, true );
	add_prop_anim( "lockbreaker", %animated_props::o_specialty_angola_lockbreaker_device, "t6_wpn_lock_pick_view", true );
}

savannah_anims()
{
	add_scene_loop( "hudson_ride_idle", undefined, false, false, true );
	add_actor_anim( "hudson", %ch_ang_05_01_rundown_hudson_idle, SCENE_HIDE_WEAPON );
	
	add_scene( "unita_wait", "field_charge", false, false, true );
	add_actor_anim( "unita_01", %generic_human::ch_ang_02_02_zulu_clash_guy01_idle, true, false, false, true );
	add_actor_anim( "unita_02", %generic_human::ch_ang_02_02_zulu_clash_guy04_idle, true, false, false, true );
	add_actor_anim( "unita_03", %generic_human::ch_ang_02_02_zulu_clash_guy05_idle, true, false, false, true );
	add_actor_anim( "unita_04", %generic_human::ch_ang_02_02_zulu_clash_guy08_idle, true, false, false, true );
	add_actor_anim( "unita_05", %generic_human::ch_ang_02_02_zulu_clash_guy11_idle, true, false, false, true );
	add_actor_anim( "unita_06", %generic_human::ch_ang_02_02_zulu_clash_guy13_idle, true, false, false, true );
	
	add_scene( "initial_charge", "field_charge" );
	add_actor_anim( "unita_01", %generic_human::ch_ang_02_02_zulu_clash_guy01, true, false, undefined, true );
	add_actor_anim( "unita_02", %generic_human::ch_ang_02_02_zulu_clash_guy04, true, false, undefined, true );
	add_actor_anim( "mpla_01", %generic_human::ch_ang_02_02_zulu_clash_guy03, true, false, undefined, true );
	add_actor_anim( "mpla_02", %generic_human::ch_ang_02_02_zulu_clash_guy02, true, false, undefined, true );
	add_actor_anim( "unita_03", %generic_human::ch_ang_02_02_zulu_clash_guy05, true, false, undefined, true );
	add_actor_anim( "mpla_03", %generic_human::ch_ang_02_02_zulu_clash_guy06, true, false, undefined, true );
	add_actor_anim( "mpla_04", %generic_human::ch_ang_02_02_zulu_clash_guy07, true, false, undefined, true );
	add_actor_anim( "unita_04", %generic_human::ch_ang_02_02_zulu_clash_guy08, true, false, undefined, true );
	add_actor_anim( "mpla_05", %generic_human::ch_ang_02_02_zulu_clash_guy09, true, false, undefined, true );
	add_actor_anim( "mpla_06", %generic_human::ch_ang_02_02_zulu_clash_guy10, true, false, undefined, true );
	add_actor_anim( "unita_05", %generic_human::ch_ang_02_02_zulu_clash_guy11, true, false, undefined, true );
	add_actor_anim( "mpla_07", %generic_human::ch_ang_02_02_zulu_clash_guy12, true, false, undefined, true );
	add_actor_anim( "unita_06", %generic_human::ch_ang_02_02_zulu_clash_guy13, true, false, undefined, true );
	add_actor_anim( "mpla_08", %generic_human::ch_ang_02_02_zulu_clash_guy14, true, false, undefined, true );	
	
	add_scene( "player_board_buffel", "savimbi_buffel" );
	add_player_anim( "player_body", %player::ch_ang_03_05_lead_vehicle_climb_player, true, 0, "tag_origin" );
	add_actor_anim( "savimbi", %generic_human::ch_ang_03_05_lead_vehicle_command_savimbi, false, false, false, true, "tag_rear_door_l" );
	
	add_scene( "player_ride_buffel", "savimbi_buffel", false, false, true );
	add_player_anim( "player_body", %player::ch_ang_03_05_lead_vehicle_buffel_idle_player, true, 0, "tag_rear_door_l", true, 1, 20, 50, 20, 20 );
	
	add_scene( "post_heli_run_fight", "eland_destroy" );
	add_actor_anim( "eland_destroy_friendly", %generic_human::ch_ang_03_04_close_encounter_UNITA, true, false );
	add_actor_anim( "eland_destroy_enemy", %generic_human::ch_ang_03_04_close_encounter_MLPA, true, false );
	//add_notetrack_custom_function( "eland_destroy_enemy", "mortar", maps\angola_savannah::savannah_destroy_eland );
	
	add_scene( "destroy_eland", undefined, undefined, undefined, undefined, true );
	add_vehicle_anim( "eland_hero", %vehicles::fxanim_angola_eland_explode_anim );
	
	/*add_scene( "eland_fire", undefined, undefined, undefined, undefined, true );
	add_vehicle_anim( "eland_destroy", %vehicles::fxanim_angola_eland_shoot_anim );*/

	add_scene( "eland_hero_fire", undefined, undefined, undefined, undefined, true );
	add_vehicle_anim( "eland_hero", %vehicles::fxanim_angola_eland_hero_shoot_anim );
	add_notetrack_custom_function( "eland_hero", "eland_hero_shoot", maps\angola_savannah::eland_hero_shoot );	
	
	add_scene( "buffel_tip", undefined, undefined, undefined, undefined, true );
	add_vehicle_anim( "riverbed_convoy_buffel", %vehicles::fxanim_angola_buffel_tip_anim );

	add_scene( "buffel_tip_idle", undefined, undefined, undefined, true, true );
	add_vehicle_anim( "riverbed_convoy_buffel", %vehicles::fxanim_angola_buffel_tip_dead_anim, undefined, undefined, undefined, true );	
	
	add_scene( "buffel_tip_guys", "riverbed_convoy_buffel" );
	add_actor_model_anim( "buffel_flip_guy1", %generic_human::ch_ang_03_02_buffel_explosion_guy01, undefined, undefined, "tag_origin", undefined, "buffel_flip_guy" );
	add_actor_model_anim( "buffel_flip_guy2", %generic_human::ch_ang_03_02_buffel_explosion_guy02, undefined, undefined, "tag_origin", undefined, "buffel_flip_guy" );
	add_actor_model_anim( "buffel_flip_guy3", %generic_human::ch_ang_03_02_buffel_explosion_guy03, undefined, undefined, "tag_origin", undefined, "buffel_flip_guy" );	
	
	add_scene( "mpla_shoot_heli_0", undefined, !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "generic", %ch_ang_02_03_mpla_shooters_guy_01 );
	add_notetrack_custom_function( "generic", "start_fire", maps\angola_savannah::start_heli_fire );
	add_notetrack_custom_function( "generic", "end_fire", maps\angola_savannah::stop_heli_fire );

	add_scene( "mpla_shoot_heli_1", undefined, !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "generic", %ch_ang_02_03_mpla_shooters_guy_02 );
	add_notetrack_custom_function( "generic", "start_fire", maps\angola_savannah::start_heli_fire );
	add_notetrack_custom_function( "generic", "end_fire", maps\angola_savannah::stop_heli_fire );	

	add_scene( "mpla_shoot_heli_2", undefined, !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "generic", %ch_ang_02_03_mpla_shooters_guy_03 );
	add_notetrack_custom_function( "generic", "start_fire", maps\angola_savannah::start_heli_fire );
	add_notetrack_custom_function( "generic", "end_fire", maps\angola_savannah::stop_heli_fire );	
	
	add_scene( "hill_fight_01", undefined );
	add_actor_anim( "hill_fight_mpla_01", %generic_human::ch_ang_02_01_clash_fight_a_guy01, true, false );
	add_actor_anim( "hill_fight_unita_01", %generic_human::ch_ang_02_01_clash_fight_a_guy02, true, false );
	
	add_scene( "hill_fight_02", undefined );
	add_actor_anim( "hill_fight_mpla_02", %generic_human::ch_ang_02_01_clash_fight_b_guy01, true, false );
	add_actor_anim( "hill_fight_unita_02", %generic_human::ch_ang_02_01_clash_fight_b_guy02, true, false );
	
	add_scene( "hill_fight_03", undefined );
	add_actor_anim( "hill_fight_mpla_03", %generic_human::ch_ang_02_01_clash_fight_c_character_01_lives, true, false );
	add_actor_anim( "hill_fight_unita_03", %generic_human::ch_ang_02_01_clash_fight_c_character_02_dies, true, false );
	
	add_scene( "hill_fight_04", undefined );
	add_actor_anim( "hill_fight_mpla_04", %generic_human::ch_ang_02_01_clash_fight_d_character_01, true, false );
	add_actor_anim( "hill_fight_unita_04", %generic_human::ch_ang_02_01_clash_fight_d_character_02, true, false );
	
	add_scene( "hill_fight_05", undefined );
	add_actor_anim( "hill_fight_mpla_05", %generic_human::ch_ang_02_01_clash_fight_a_guy01, true, false );
	add_actor_anim( "hill_fight_unita_05", %generic_human::ch_ang_02_01_clash_fight_a_guy02, true, false );
	
	add_scene( "hill_fight_06", undefined );
	add_actor_anim( "hill_fight_mpla_06", %generic_human::ch_ang_02_01_clash_fight_b_guy01, true, false );
	add_actor_anim( "hill_fight_unita_06", %generic_human::ch_ang_02_01_clash_fight_b_guy02, true, false );
}

savannah_end_anims()
{
	add_scene( "return_to_buffel", "savimbi_buffel_end" );
	add_player_anim( "player_body", %player::ch_ang_03_07_victory_shots_player, SCENE_DELETE, 0, undefined, true, 1, 20, 20, 20, 20  );
	add_actor_anim( "victory_savimbi", %generic_human::ch_ang_03_07_victory_shots_savimbi, false, false, false, true );
	add_actor_anim( "mpla_end_01", %generic_human::ch_ang_03_07_victory_shots_mpla01 );
	add_actor_anim( "mpla_end_02", %generic_human::ch_ang_03_07_victory_shots_mpla02 );
	
	add_scene( "buffel_ride_end", "savimbi_buffel_end", false, false, true );
	add_player_anim( "player_body", %player::ch_ang_03_05_lead_vehicle_buffel_idle_player, true, 0, "tag_rear_door_l", true, 1, 20, 50, 20, 20 );
	add_actor_anim( "victory_savimbi", %generic_human::ch_ang_01_01_intro_savimbi_buffelidle, false, false, true, true, "tag_rear_door_l" );
	
	add_scene( "savannah_ending", "buffel_stop_point_v2" );
	add_player_anim( "player_body", %player::p_ang_04_01_player_landing, true, 0, undefined, true, 1, 20, 20, 20, 20 );
	add_actor_anim( "savimbi", %generic_human::ch_ang_04_01_savimbi_landing, false, false, false, true );
	add_actor_anim( "hudson", %generic_human::ch_ang_04_01_hudson_landing, false, false, false, true );
	add_actor_model_anim( "savannah_soldier", %generic_human::ch_ang_04_01_soldier_landing, undefined, undefined, undefined, undefined, "savannah_ending_soldier" );
	add_vehicle_anim( "hudson_helicopter_end", %vehicles::v_ang_04_01_helicopter_landing );
	add_notetrack_flag( "player_body", "end_scene", "end_angola" );
	
	add_scene( "savannah_kill_shots_friendly", "buffel_stop_point_v2" );
	add_actor_anim( "landing_soldier1", %generic_human::ch_ang_04_01_landing_guy01 );
	add_actor_anim( "landing_soldier2", %generic_human::ch_ang_04_01_landing_guy02 );
	add_actor_anim( "landing_soldier3", %generic_human::ch_ang_04_01_landing_guy03 );
	add_actor_anim( "landing_soldier4", %generic_human::ch_ang_04_01_landing_guy04 );
	add_actor_anim( "landing_soldier5", %generic_human::ch_ang_04_01_landing_guy05 );
	add_actor_anim( "landing_soldier6", %generic_human::ch_ang_04_01_landing_guy06 );
	add_actor_anim( "landing_soldier7", %generic_human::ch_ang_04_01_landing_guy07 );
	
	add_scene( "savannah_kill_shots_enemy", "buffel_stop_point_v2" );
	add_actor_model_anim( "landing_enemy1", %generic_human::ch_ang_04_01_landing_enemy01, undefined, undefined, undefined, undefined, "mpla_end_01" );
	add_actor_model_anim( "landing_enemy2", %generic_human::ch_ang_04_01_landing_enemy02, undefined, undefined, undefined, undefined, "mpla_end_01" );
	add_actor_model_anim( "landing_enemy3", %generic_human::ch_ang_04_01_landing_enemy03, undefined, undefined, undefined, undefined, "mpla_end_01" );
	add_actor_model_anim( "landing_enemy4", %generic_human::ch_ang_04_01_landing_enemy04, undefined, undefined, undefined, undefined, "mpla_end_01" );
	add_actor_model_anim( "landing_enemy5", %generic_human::ch_ang_04_01_landing_enemy05, undefined, undefined, undefined, undefined, "mpla_end_01" );
	
	add_scene( "savannah_ending_cheer", "buffel_stop_point_v2", false, false, true );
	add_actor_model_anim( "victory_soldier1", %generic_human::ch_ang_03_07_victory_shots_unita01, undefined, undefined, undefined, undefined, "savannah_ending_soldier" );
	add_actor_model_anim( "victory_soldier2", %generic_human::ch_ang_03_07_victory_shots_unita02, undefined, undefined, undefined, undefined, "savannah_ending_soldier" );
	add_actor_model_anim( "victory_soldier3", %generic_human::ch_ang_03_07_victory_shots_unita03, undefined, undefined, undefined, undefined, "savannah_ending_soldier" );
	add_actor_model_anim( "victory_soldier4", %generic_human::ch_ang_03_07_victory_shots_unita04, undefined, undefined, undefined, undefined, "savannah_ending_soldier" );
	
	add_scene( "savannah_ending_buffel", "buffel_stop_point_v2" );
	add_vehicle_anim( "savimbi_buffel_end", %vehicles::v_ang_04_01_helicopter_buffel );
	
	add_scene( "savannah_ending_helicopter_idle", "buffel_stop_point_v2" );
	add_vehicle_anim( "hudson_helicopter_end", %vehicles::v_ang_04_01_helicopter_idle_landing );
}