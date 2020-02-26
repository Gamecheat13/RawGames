
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");
main()
{
	maps\voice\voice_angola_2::init_voice();
	
	//river
	river_heli_attack_animation();
	river_heli_crash();
	
	//section anim functions
	jungle_stealth_anims();
	village_anims();
	jungle_escape_anims();
	boat_ramming_anim();
	finding_woods_anim();
	open_stinger_truck_door();
	barge_destroyed_anims();
	enemy_boat_ramming();
	//call after all scenes are setup 
	precache_assets();
	boat_explosive_death();
	init_angola_anims();
}

enemy_boat_ramming()
{
	
	add_scene("enemy_boat_ram_barge", "main_barge");
	add_vehicle_anim("enemy_ramming_boat", %vehicles::v_ang_06_01_enemy_boat_ram_boat);
	add_actor_anim("enemy_boat_guard_1", %ch_ang_06_01_enemy_boat_ram_guy01, false, true, false, true, "tag_origin" );
	add_actor_anim("enemy_boat_guard_2", %ch_ang_06_01_enemy_boat_ram_guy02, false, true, false, true, "tag_origin" );
	add_actor_anim("enemy_boat_guard_3", %ch_ang_06_01_enemy_boat_ram_guy03, false, true, false, true, "tag_origin" );
	
	add_scene_loop("enemy_boat_driver_idle", "enemy_ramming_boat");
	add_actor_anim( "enemy_boat_guard_driver", %ch_ang_05_05_gunboat_drive_hudson, SCENE_HIDE_WEAPON, true, false, false, "tag_passenger3" );
	
	add_scene_loop("enemy_ramming_boat_idle", "main_barge");
	add_vehicle_anim("enemy_ramming_boat", %vehicles::v_ang_06_01_enemy_boat_ram_idle_boat);
	
	add_scene("enemy_boat_driver_crash", "main_barge");
	add_vehicle_anim("enemy_ramming_boat", %vehicles::v_ang_06_01_enemy_boat_ram_veer_boat);
}

river_heli_crash()
{
	add_scene( "heli_hit_by_missile", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_04_going_down_chopper, false, undefined, "tag_origin");
	add_vehicle_anim( "player_gun_boat", %Vehicles::v_ang_05_04_going_down_gunboat);
	add_player_anim( "player_body_river", %player::ch_ang_05_04_going_down_player, true, 0, "tag_origin");
	

	
	add_scene_loop( "heli_hold_steady", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_04_going_down_idle_chopper);
	add_vehicle_anim( "player_gun_boat", %Vehicles::v_ang_05_04_going_down_gunboat);
	
	
	add_scene( "heli_player_machete_enter", "main_barge");
	add_actor_anim( "machete_dude", %ch_ang_05_04_machete_enemy_enter);
//	
//	add_scene_loop( "heli_player_machete_idle", "main_barge");
//	add_actor_anim( "machete_dude", %ch_ang_05_04_machete_enemy_idle);
	
	add_scene("player_jump_on_boat", "main_barge");
	add_actor_anim( "machete_dude", %ch_ang_05_04_boat_jump_enemy);
	add_player_anim( "player_body_river", %player::ch_ang_05_04_boat_jump_player, true, 0, "tag_origin");
	add_actor_anim( "hudson", %ch_ang_05_04_boat_jump_hudson);
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_04_boat_jump_chopper);
	add_notetrack_custom_function("machete_dude", "stab", ::play_blood_on_machete_dude);
	
	
	add_scene("river_heli_lancing", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_02_first_lancing_chopper_flight_path);
	
}

river_heli_attack_animation()
{
	add_scene_loop( "heli_attack_player_idle", "player_heli" );
	add_player_anim( "player_body_river", %player::ch_ang_05_01_rundown_intro_player_idle, false, undefined, "tag_origin", true, 0, 30, 30, 30, 30);
	
	add_scene("heli_attack_player_intro", "player_heli");
	add_player_anim( "player_body_river", %player::ch_ang_05_01_rundown_intro_player, false, undefined, "tag_origin", true, 0, 10, 10, 10, 10);
	
	add_scene("heli_attack_player_fall", "player_heli");
	add_player_anim( "player_body_river", %player::ch_ang_05_01_rundown_player_hang_on, true, undefined, "tag_origin", false);
	
	add_scene_loop( "heli_attack_hudson_idle", undefined, false, false, true );
	add_actor_anim( "hudson", %ch_ang_05_01_rundown_hudson_idle, SCENE_HIDE_WEAPON );
	
	add_scene( "heli_hover_1", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_02_first_lancing_chopper_loop01);
	
	add_scene( "heli_hover_2", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_02_first_lancing_chopper_loop02);
	
	add_scene( "heli_hover_3", "main_barge");
	add_vehicle_anim( "player_heli", %vehicles::v_ang_05_02_first_lancing_chopper_loop03);
	
	add_scene( "strella_guard_run_truck", "main_barge", false, false, false, true);
	//add_actor_anim( "strella_guy", %ch_ang_05_03_ghaz_cargo_open_MPLA);
	add_vehicle_anim( "strella_truck", %vehicles::v_ang_05_03_ghaz_cargo_open_cargo);
	
	add_scene( "strella_guard_run", "strella_truck");
	add_actor_anim( "strella_guy", %ch_ang_05_03_ghaz_cargo_open_MPLA);
	//add_vehicle_anim( "strella_truck", %vehicles::v_ang_05_03_ghaz_cargo_open_cargo);
	
	
}

boat_ramming_anim()
{
	
	add_scene("player_unlock_gun", "main_convoy_escort_boat_medium_1");
	add_player_anim( "player_body_river", %player::int_angola_brute_strength, true, undefined, "tag_origin", false);
	
	add_scene( "hudson_walk_to_wheel_origin", "main_convoy_escort_boat_medium_1");
	add_actor_anim( "hudson",  %ch_ang_05_04_boat_approach_wheel_hudson, false, true, false, true, "tag_origin");

	add_scene_loop("hudson_idle_wheel", "main_convoy_escort_boat_medium_1");
	add_actor_anim( "hudson", %ch_ang_05_05_gunboat_drive_hudson, false, true, false, true, "tag_origin" );
	
	add_scene_loop("hudson_drive_wheel", "main_convoy_escort_boat_medium_1", false, false, true);
	add_vehicle_anim( "player_gun_boat", %vehicles::v_ang_05_05_gunboat_drive_wheel, false, undefined, undefined, false);
	
	add_scene_loop("hudson_idle_steering", "main_convoy_escort_boat_medium_1");
	add_actor_anim( "hudson", %ch_ang_06_01_gunboat_wait_hudson, false, true, false, true, "tag_origin" );
	
//	add_scene("player_hold_position", "main_convoy_escort_boat_medium_1");
//	add_player_anim( "player_body_river", %player::ch_ang_06_01_gunboat_brace_player, true, undefined, "tag_origin", false);
	
	add_scene("boat_ram_barge_hudson", "main_barge");
	add_actor_anim( "hudson", %ch_ang_06_01_gunboat_ram_hudson, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	
	add_scene("boat_ram_barge_player", "main_barge");
	add_player_anim( "player_body_river", %player::ch_ang_06_01_gunboat_ram_player, true, undefined, "tag_origin", false, 0, 180, 180, 180, 180, undefined, undefined, true);
	add_notetrack_custom_function( "player_body_river", "boat_ram_snapshot_on", maps\angola_2_amb::sndBoatRamSnapshotOn );
	add_notetrack_custom_function( "player_body_river", "boat_ram_snapshot_off", maps\angola_2_amb::sndBoatRamSnapshotOff );	
	
	add_scene("boat_ram_barge_medium_boat", "main_barge");
	add_vehicle_anim( "player_gun_boat", %vehicles::v_ang_06_01_gunboat_ram_boat);
	
//	add_scene_loop("boat_rammed_idle", "main_barge");
//	add_actor_anim( "hudson", %ch_ang_06_01_gunboat_idle_hudson, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
//	add_vehicle_anim( "player_gun_boat", %vehicles::v_ang_06_01_gunboat_idle_boat);
	
	add_scene("player_jump_on_barge", "main_barge");
	add_player_anim( "player_body_river", %player::ch_ang_06_01_gunboat_jump_player, true, undefined, "tag_origin", false);
	
	add_scene("hudson_jump_on_barge", "main_barge");
	add_actor_anim( "hudson", %ch_ang_06_01_gunboat_jump_hudson, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	add_vehicle_anim( "player_gun_boat", %vehicles::v_ang_06_01_gunboat_jump_boat);
	
	add_scene("bye_bye_gun_boat", "main_barge");
	add_vehicle_anim( "player_gun_boat", %vehicles::v_ang_06_01_gunboat_veer_boat);
	
	add_scene("boat_ramming_guard_right_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_enemy03, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_guard_right_second",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_enemy04, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_driver_left_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_gunboat01_driver, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_driver_right_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_gunboat02_driver, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_guard_left_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_enemy01, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_guard_left_second",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_enemy02, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_gunner_left_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_gunboat01_gunner, false, true, false, false, "tag_origin");
	
	add_scene("boat_ramming_gunner_right_first",  "main_convoy_escort_boat_medium_1");
	add_actor_anim( "generic", %ch_ang_05_06_boat_battle_gunboat02_gunner, false, true, false, false, "tag_origin");
}

open_stinger_truck_door()
{
	add_scene("player_find_truck", "main_barge");
	add_prop_anim( "strella_truck", %animated_props::v_ang_06_02_get_strella_cargo);
	add_player_anim( "player_body_river", %player::ch_ang_06_02_get_strella_player, true, undefined, "tag_origin", false);
	
	add_scene("player_wheel_house_shell_shock", "main_barge");
	add_vehicle_anim( "strella_truck", %vehicles::v_ang_06_02_wheelhouse_hit_cargo);
	add_player_anim( "player_body_river", %player::ch_ang_06_02_wheelhouse_hit_player, true, undefined, "tag_origin", false);
	
}

finding_woods_anim()
{
	
	add_scene("player_find_woods", "main_barge");
	add_player_anim( "player_body_river", %player::p_ang_06_02_find_woods_player, true, undefined, "tag_origin", false);
//	add_vehicle_anim( "woods_truck", %vehicles::v_ang_06_02_find_woods_cargo);
	add_notetrack_level_notify("player_body_river", "spawn_hind", "spawn_hind");
	add_notetrack_level_notify("player_body_river", "open_door", "open_door");
	add_notetrack_level_notify("player_body_river", "vision_set", "change_vision");
	add_notetrack_custom_function( "player_body_river", "sndActivateSnapshot", maps\angola_2_amb::sndFindWoodsSnapshot );
	add_notetrack_custom_function( "player_body_river", "sndActivateRoom", maps\angola_2_amb::sndFindWoodsRoom );
	add_notetrack_level_notify( "player_body_river", "sndDeactivateSnapshot", "sndDeactivateSnapshot" );
	add_notetrack_level_notify( "player_body_river", "sndDeactivateRoom", "sndDeactivateRoom" );
	
	add_scene("container_find_woods", "main_barge");
	add_prop_anim( "woods_container", %animated_props::v_ang_06_02_find_woods_shipping_container);
	
	add_scene("player_find_woods_fake", "lighting_barge");
	add_player_anim( "player_body_river", %player::p_ang_06_02_find_woods_player, true, undefined, "tag_origin", false);
	add_vehicle_anim( "woods_lighting_truck", %vehicles::v_ang_06_02_find_woods_cargo);
	//add_notetrack_level_notify("player_body_river", "spawn_hind", "spawn_hind");
	
	add_scene("player_find_woods_part2", "main_barge");
	add_player_anim( "player_body_river", %player::p_ang_06_02_find_woods_part2_player, true, undefined, "tag_origin", false);
	
	add_scene("player_woods_body_idle_1", "main_barge");
	add_prop_anim("body_1", %animated_props::ch_ang_06_02_find_woods_body01, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_2", "main_barge");
	add_prop_anim("body_2", %animated_props::ch_ang_06_02_find_woods_body02, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_3", "main_barge");
	add_prop_anim("body_3", %animated_props::ch_ang_06_02_find_woods_body03, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_4", "main_barge");
	add_prop_anim("body_4", %animated_props::ch_ang_06_02_find_woods_body04, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_5", "main_barge");
	add_prop_anim("body_5", %animated_props::ch_ang_06_02_find_woods_body05, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_6", "main_barge");
	add_prop_anim("body_6", %animated_props::ch_ang_06_02_find_woods_body06, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");
	
	add_scene("player_woods_body_idle_7", "main_barge");
	add_prop_anim("body_7", %animated_props::ch_ang_06_02_find_woods_body07, "c_usa_jungmar_barechest_fb", false, false, undefined, "tag_origin");

	
//	add_scene("player_woods_body_idle_fake", "lighting_barge");
//	add_prop_anim("body_1_fake", %animated_props::ch_ang_06_02_find_woods_body01, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_2_fake", %animated_props::ch_ang_06_02_find_woods_body02, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_3_fake", %animated_props::ch_ang_06_02_find_woods_body03, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_4_fake", %animated_props::ch_ang_06_02_find_woods_body04, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_5_fake", %animated_props::ch_ang_06_02_find_woods_body05, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_6_fake", %animated_props::ch_ang_06_02_find_woods_body06, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
//	add_prop_anim("body_7_fake", %animated_props::ch_ang_06_02_find_woods_body07, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");

	
	add_scene("hero_find_woods", "main_barge");
	add_actor_anim( "hudson", %ch_ang_06_02_find_woods_hudson, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	add_actor_anim( "woods", %ch_ang_06_02_find_woods_woods, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	
	add_scene("hero_find_woods_fake", "lighting_barge");
	add_actor_anim( "hudson_fake", %ch_ang_06_02_find_woods_hudson, SCENE_HIDE_WEAPON, false, true, true, "tag_origin" );
	add_notetrack_level_notify("hudson_fake", "truck_hit", "truck_hit");
	add_actor_anim( "woods_fake", %ch_ang_06_02_find_woods_woods, SCENE_HIDE_WEAPON, false, true, true, "tag_origin" );
	
	add_scene_loop("hudson_wood_idle", "main_barge");
	add_actor_anim( "hudson", %ch_ang_06_02_find_woods_idle_hudson, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	add_actor_anim( "woods", %ch_ang_06_02_find_woods_idle_woods, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
	
	add_scene_loop("dead_body_idle_1", "main_barge");
	add_prop_anim("body_1", %animated_props::ch_ang_06_02_find_woods_idle_body01, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_2", "main_barge");
	add_prop_anim("body_2", %animated_props::ch_ang_06_02_find_woods_idle_body02, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_3", "main_barge");
	add_prop_anim("body_3", %animated_props::ch_ang_06_02_find_woods_idle_body03, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_4", "main_barge");
	add_prop_anim("body_4", %animated_props::ch_ang_06_02_find_woods_idle_body04, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_5", "main_barge");
	add_prop_anim("body_5", %animated_props::ch_ang_06_02_find_woods_idle_body05, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_6", "main_barge");
	add_prop_anim("body_6", %animated_props::ch_ang_06_02_find_woods_idle_body06, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	
	add_scene_loop("dead_body_idle_7", "main_barge");
	add_prop_anim("body_7", %animated_props::ch_ang_06_02_find_woods_idle_body07, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");

	
	
	add_scene_loop("dead_body_idle_loop", "main_barge");
	add_prop_anim("body_1", %animated_props::ch_ang_06_02_find_woods_body01_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_2", %animated_props::ch_ang_06_02_find_woods_body02_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_3", %animated_props::ch_ang_06_02_find_woods_body03_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_4", %animated_props::ch_ang_06_02_find_woods_body04_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_5", %animated_props::ch_ang_06_02_find_woods_body05_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_6", %animated_props::ch_ang_06_02_find_woods_body06_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_7", %animated_props::ch_ang_06_02_find_woods_body07_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_8", %animated_props::ch_ang_06_02_find_woods_body08_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_9", %animated_props::ch_ang_06_02_find_woods_body09_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_10", %animated_props::ch_ang_06_02_find_woods_body10_test, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_actor_anim( "woods", %ch_ang_06_02_find_woods_woods_test, SCENE_HIDE_WEAPON, true, false, true, "tag_origin" );
//  add_vehicle_anim( "woods_container", %vehicles::v_ang_06_02_find_woods_container_test);
	
}


barge_destroyed_anims()
{
	add_scene("player_hind_shell_shock", "swim_to_shore");
	add_player_anim( "player_body_river", %player::ch_ang_06_04_hind_attacks_player, true, undefined);
	add_actor_anim( "hudson", %ch_ang_06_04_hind_attacks_hudson, false, true, false, true );
	add_actor_anim( "woods", %ch_ang_06_04_hind_attacks_woods, SCENE_HIDE_WEAPON, true, false, true );
	//add_vehicle_anim( "main_barge", %vehicles::v_ang_06_04_hind_attacks_barge);
	
	add_scene_loop("barge_sinking_idle", "swim_to_shore");
	add_vehicle_anim( "main_barge", %vehicles::v_ang_06_04_hind_attacks_barge);
	
	add_scene("player_saving_hinds", "swim_to_shore");
	add_player_anim( "player_body_river", %player::ch_ang_06_04_hind_attacks_dive_player, true, undefined);
	add_actor_anim( "hudson", %ch_ang_06_04_hind_attacks_dive_hudson, false, true, false, true );
	add_actor_anim( "woods", %ch_ang_06_04_hind_attacks_dive_woods, SCENE_HIDE_WEAPON, true, false, true );
	//add_vehicle_anim( "main_barge", %vehicles::v_ang_06_04_hind_attacks_dive_barge);
	
	add_scene("player_swim_to_shore", "swim_to_shore");
	add_player_anim( "player_body_river", %player::ch_ang_06_04_swim_player, true, undefined);
	add_actor_anim( "hudson", %ch_ang_06_04_swim_hudson, false, true, false, true );
	add_actor_anim( "woods", %ch_ang_06_04_swim_woods, SCENE_HIDE_WEAPON, true, false, true );
	add_notetrack_custom_function("woods", "cough", ::play_woods_water_fx);
	//add_vehicle_anim( "main_barge", %vehicles::v_ang_06_04_swim_barge);
	
	add_scene("hind_crash_on_shore", "swim_to_shore");
	add_vehicle_anim( "river_hind", %vehicles::v_ang_06_04_hind_crash_hind);
	
	
	add_scene("woods_truck_flip", "main_barge");
	add_prop_anim("woods_container", %animated_props::fxanim_angola_barge_gaz66_anim, undefined, false, false, undefined, "tag_origin");
	
	add_scene( "strella_truck_flip", "main_barge", false, false, false, true);
	add_prop_anim( "strella_truck", %animated_props::fxanim_angola_barge_gaz66_02_anim);
	
	add_scene("wheel_house_explosion", "main_barge");
	add_prop_anim("barge_wheel_house",  %animated_props::fxanim_angola_barge_wheelhouse_anim, undefined, false, false, undefined, "tag_origin");
	
	add_scene("barge_aft_explosion", "main_barge");
	add_prop_anim("barge_aft",  %animated_props::fxanim_angola_barge_aft_debris_anim, undefined, false, false, undefined, "tag_origin");
	
	add_scene("barge_side_explosion", "main_barge");
	add_prop_anim("barge_side_damage",  %animated_props::fxanim_angola_barge_side_debris_anim, undefined, false, false, undefined, "tag_origin");
	
	
	add_scene("barge_bodies_explosion", "main_barge");
	add_prop_anim("body_1", %animated_props::ch_ang_06_02_find_woods_attack_body01, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_2", %animated_props::ch_ang_06_02_find_woods_attack_body02, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_3", %animated_props::ch_ang_06_02_find_woods_attack_body03, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_4", %animated_props::ch_ang_06_02_find_woods_attack_body04, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_5", %animated_props::ch_ang_06_02_find_woods_attack_body05, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_6", %animated_props::ch_ang_06_02_find_woods_attack_body06, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
	add_prop_anim("body_7", %animated_props::ch_ang_06_02_find_woods_attack_body07, "c_usa_jungmar_barechest_fb", true, false, undefined, "tag_origin");
}

boat_explosive_death()
{	
	level.scr_anim[ "chase_boat_gunner_front" ][ "front_death" ]	= %ai_crew_gunboat_front_gunner_death_front;
	level.scr_anim[ "chase_boat_gunner_back" ][ "back_death" ]	= %ai_crew_gunboat_rear_gunner_death_right;		
}

play_woods_water_fx( guy )
{
	PlayFXOnTag( level._effect[ "woods_cough_water" ], guy, "j_lip_top_ri");
	
}

play_blood_on_machete_dude( guy )
{
	PlayFXOnTag( level._effect[ "head_blood" ], guy, "J_head");
	//guy Detach(guy.headmodel);
//	guy attach("c_vtn_nva_head_gib_spawn", "J_SpineUpper");
//	fake_head = spawn("script_model", guy GetTagOrigin( "j_head" ) );
//	fake_head setmodel("c_vtn_nva_head_gib_spawn");
	level.player PlayRumbleOnEntity( "angola_hind_ride" );
	
	
	wait(8);
	level notify("machete_guy_dead");
	
}


//*****************************************************************************
//*****************************************************************************

jungle_stealth_anims()
{
	// 3 dead bodies by the chopper at the start of the stealth section
	add_scene( "chopper_dead_body1", "swim_to_shore", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "chopper_dead_body1", %ch_ang_07_01_charred_bodies_guy01, undefined, SCENE_HIDE_WEAPON );

	add_scene( "chopper_dead_body2", "swim_to_shore", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "chopper_dead_body2", %ch_ang_07_01_charred_bodies_guy02, undefined, SCENE_HIDE_WEAPON );

	add_scene( "chopper_dead_body3", "swim_to_shore", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "chopper_dead_body3", %ch_ang_07_01_charred_bodies_guy03, undefined, SCENE_HIDE_WEAPON );

	// Hudson moves to the rock blockage
	add_scene( "hudson_moves_to_rock_blockage", "hudson_mantle", SCENE_REACH  );
	add_actor_anim( "hudson", %ch_ang_07_02_hudson_mantle_climb_hudson );

	// Hudson at the rock blockage, looping
	add_scene( "hudson_moves_to_rock_blockage_loop", "hudson_mantle", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "hudson", %ch_ang_07_02_hudson_mantle_loop_hudson );

	add_scene( "hudson_climb_rock_blockage", "hudson_mantle" );
	add_actor_anim( "hudson", %ch_ang_07_02_hudson_mantle_hudson );

	add_scene( "mason_woods_climb_rock_blockage", "hudson_mantle" );
	add_actor_anim( "woods", %ch_ang_07_02_hudson_mantle_woods, SCENE_HIDE_WEAPON );
	add_player_anim( "player_body", %player::ch_ang_07_02_hudson_mantle_player, SCENE_DELETE );

	// Hudson runs to the Hind Pilot and Shoots himf
	add_scene( "pilot_execution_hudson", "hudson_shoot_pilot", SCENE_REACH );
	add_actor_anim( "hudson", %ch_ang_07_02_hind_pilot_hudson );
	
	// Play the scene on 1st frame until Hudson scene starts
	add_scene( "pilot_execution_pilot", "hudson_shoot_pilot" );
	add_actor_model_anim( "crashed_hind_pilot", %ch_ang_07_02_hind_pilot_pilot );
			
	// Player picks up woods on the beach
	add_scene( "j_stealth_player_picks_up_woods", "swim_to_shore" );
	add_actor_anim( "woods", %ch_ang_07_01_carry_woods_woods_pickup, SCENE_HIDE_WEAPON );
	add_player_anim( "player_body", %player::ch_ang_07_01_carry_woods_player_pickup, SCENE_DELETE );

	// Player pust woods down at the end of the Stealth Event
	add_scene( "j_stealth_player_puts_down_woods", "woods_cover" );
	add_actor_anim( "woods", %ch_ang_07_03_village_woods, SCENE_HIDE_WEAPON );
	add_actor_anim( "hudson", %ch_ang_07_03_village_hudson );
	add_player_anim( "player_body", %player::p_ang_07_03_village, SCENE_DELETE );

	add_scene( "j_stealth_hudson_woods_sit_down_loop", "woods_cover", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "woods", %ch_ang_07_03_village_woods_cycle, SCENE_HIDE_WEAPON );
	add_actor_anim( "hudson", %ch_ang_07_03_village_hudson_cycle );
	
	// Hudson exits the water at start of the jungle_stealth event
	add_scene( "j_stealth_player_picks_up_woods_hudson_watches", "swim_to_shore" );
	add_actor_anim( "hudson", %ch_ang_07_01_river_bank_hudson );

	// Hudson will spot an enemy on patrol and will signal the player to hault. He will take position in the hiding spot to the left
	add_scene( "hudson_child_soldier_intro_move_to_cover", "child_soldier_intro", SCENE_REACH );
	add_actor_anim( "hudson", %ch_ang_07_02_hiding_spot_hault_hudson );
	add_scene( "hudson_child_soldier_intro_move_to_cover_part2", "child_soldier_intro" );
	add_actor_model_anim( "guy_soldier", %ch_ang_07_02_hiding_spot_hault_guy, undefined, SCENE_DELETE );

	// The enemy will stand in position, idling while Hudson lays prone, waiting for the player to get the hiding spot
	add_scene( "hudson_waits_in_cover_for_player_to_take_cover", "child_soldier_intro", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "hudson", %ch_ang_07_02_hiding_spot_wait_hudson );
	add_actor_model_anim( "guy_soldier", %ch_ang_07_02_hiding_spot_wait_guy, undefined, SCENE_DELETE );
			
	// Once the player reaches bump trigger next to Hudson, the player will quickly go prone with Woods and will observe the child soldier scene take place
	add_scene( "player_prone_watches_1st_child_soldier_encounter", "child_soldier_intro" );
	add_player_anim( "player_body", %player::ch_ang_07_02_hiding_spot_scene_player, SCENE_DELETE, 0, undefined, true, 1, 30, 30, 15, 15 );
	add_actor_anim( "hudson", %ch_ang_07_02_hiding_spot_scene_hudson );
	add_actor_anim( "woods", %ch_ang_07_02_hiding_spot_scene_woods, SCENE_HIDE_WEAPON );
	add_actor_model_anim( "guy_soldier", %ch_ang_07_02_hiding_spot_scene_guy, undefined, SCENE_DELETE );
	add_actor_anim( "child_soldier_1", %ch_ang_07_02_hiding_spot_scene_child01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE);
	add_actor_anim( "child_soldier_2", %ch_ang_07_02_hiding_spot_scene_child02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_3", %ch_ang_07_02_hiding_spot_scene_child03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_4", %ch_ang_07_02_hiding_spot_scene_child04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );


	// Child Soldier partol anims
	add_scene( "child_soldier_anim_group1", "child_soldier_anim_group_1_struct", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "go_house_ambient_child1_spawner", %ch_ang_09_01_child_patrol_A_kid01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "go_house_ambient_child2_spawner", %ch_ang_09_01_child_patrol_A_kid02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	add_scene( "child_soldier_anim_group1_alerted", "child_soldier_anim_group_1_struct" );
	add_actor_anim( "go_house_ambient_child1_spawner", %ch_ang_09_01_child_patrol_A_kid01_alert, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "go_house_ambient_child2_spawner", %ch_ang_09_01_child_patrol_A_kid02_alert, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	add_scene( "child_soldier_anim_group2", "child_soldier_anim_group_2_struct", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "go_house_ambient_child3_spawner", %ch_ang_09_01_child_patrol_B_kid01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "go_house_ambient_child4_spawner", %ch_ang_09_01_child_patrol_B_kid02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	add_scene( "child_soldier_anim_group2_alerted", "child_soldier_anim_group_2_struct" );
	add_actor_anim( "go_house_ambient_child3_spawner", %ch_ang_09_01_child_patrol_B_kid01_alert, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "go_house_ambient_child4_spawner", %ch_ang_09_01_child_patrol_B_kid02_alert, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );


	// Monastary patrolling soldier
	add_scene( "missionary_patroller", "missionary_soldier" );
	add_actor_anim( "house_follow_path_and_die_spawner", %ch_ang_07_03_monestary_patrol_guy01 );

	// Perks
	intruder_perk_anim();
			
	// Setup the Mason/Woods carry animations
	player_stealth_carry_anims();
	woods_stealth_carry_anims();
}


//*****************************************************************************
// uses Padlocks etc. - specialty_intruder
//*****************************************************************************

intruder_perk_anim()
{
	add_scene( "intruder", "align_intruder" );
	add_prop_anim( "lock_lock_breaker", 		%animated_props::o_specialty_panama_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
	add_prop_anim( "torch_lock_breaker", 		%animated_props::o_specialty_panama_intruder_boltcutter, "t6_wpn_boltcutters_prop_view", true );
	add_player_anim( "player_body", 			%player::int_specialty_panama_intruder, SCENE_DELETE );	
}


//*****************************************************************************
//*****************************************************************************

village_anims()
{
	player_meatshield_anims();
	menendez_meatshield_anims();

	// Animator placed ambient soldiers in the village

	add_scene( "village_ambient_cargo_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_cargo_guy1_spawner", %ch_ang_07_03_village_ambientA_cargo_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_cargo_guy2_spawner", %ch_ang_07_03_village_ambientA_cargo_guy02, undefined, SCENE_DELETE );

	add_scene( "village_ambient_inspect_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_inspect_guy1_spawner", %ch_ang_07_03_village_ambientA_inspect_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_inspect_guy2_spawner", %ch_ang_07_03_village_ambientA_inspect_guy02, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_inspect_guy3_spawner", %ch_ang_07_03_village_ambientA_inspect_guy03, undefined, SCENE_DELETE );

	add_scene( "village_ambient_patrol_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_patrol_guy1", %ch_ang_07_03_village_ambientA_patrol_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_patrol_guy2", %ch_ang_07_03_village_ambientA_patrol_guy02, undefined, SCENE_DELETE );

	add_scene( "village_ambient_smoker_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_smoker_guy1_spawner", %ch_ang_07_03_village_ambientA_smokers_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_smoker_guy2_spawner", %ch_ang_07_03_village_ambientA_smokers_guy02, undefined, SCENE_DELETE );

	add_scene( "village_ambient_inspect_b_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_inspect_b_guy1_spawner", %ch_ang_07_03_village_ambientB_inspect_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_inspect_b_guy2_spawner", %ch_ang_07_03_village_ambientB_inspect_guy02, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_inspect_b_guy3_spawner", %ch_ang_07_03_village_ambientB_inspect_guy03, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_inspect_b_guy4_spawner", %ch_ang_07_03_village_ambientB_inspect_guy04, undefined, SCENE_DELETE );

	add_scene( "village_ambient_patrol_b_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_patrol_b_guy1_spawner", %ch_ang_07_03_village_ambientB_patrol_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_patrol_b_guy2_spawner", %ch_ang_07_03_village_ambientB_patrol_guy02, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_patrol_b_guy3_spawner", %ch_ang_07_03_village_ambientB_patrol_guy03, undefined, SCENE_DELETE );

	add_scene( "village_ambient_smoker_b_guys", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_smoker_b_guy1_spawner", %ch_ang_07_03_village_ambientB_smokers_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_smoker_b_guy2_spawner", %ch_ang_07_03_village_ambientB_smokers_guy02, undefined, SCENE_DELETE );
	
	add_scene( "village_truck_unloading", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_vehicle_anim( "village_gaz_unloading", %vehicles::v_ang_07_03_village_ambientA_gaz_truck, SCENE_DELETE);

	add_scene( "village_truck_unpacking", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_vehicle_anim( "village_gaz_unpacking", %vehicles::v_ang_07_03_village_ambientB_gaz_truck, SCENE_DELETE);
	
	
	// Additional ambient soliders placed by MikeA to make it look more dense
			
	add_scene( "village_background_2guys", "village_background_node1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_background_guy1_spawner", %ch_ang_07_03_village_patrol_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_background_guy2_spawner", %ch_ang_07_03_village_patrol_guy02, undefined, SCENE_DELETE );

	add_scene( "village_background_2guys_part2", "village_background_node2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "village_background_guy3_spawner", %ch_ang_07_03_village_patrol_guy01, undefined, SCENE_DELETE );
	add_actor_model_anim( "village_background_guy4_spawner", %ch_ang_07_03_village_patrol_guy02, undefined, SCENE_DELETE );

	

	// Player Enters Menendez's Radio Room
		
	add_scene( "player_climb_into_radio_room", "meat_shield" );
	add_player_anim( "player_body", %player::ch_ang_08_01_radio_room_enter_player, SCENE_DELETE );
	
	add_scene( "menendez_radio_room_idle", "meat_shield", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "menendez", %ch_ang_08_01_radio_room_idle_menendez );


	// MEATSHIELD STARTS

	add_scene( "player_grabs_menendez", "meat_shield" );
	add_actor_model_anim( "menendez", %ch_ang_08_01_radio_room_encounter_menendez );
	add_player_anim( "player_body", %player::ch_ang_08_01_radio_room_encounter_player );
	
	add_scene( "meatshield_enemy_attack", "meat_shield" );
	add_actor_anim( "guy_soldier", %ch_ang_08_01_radio_room_encounter_adult );
	//add_actor_anim( "guy_soldier2", %ch_ang_08_01_radio_room_encounter_adult02 );
	//add_actor_anim( "guy_soldier3", %ch_ang_08_01_radio_room_encounter_adult03 );
	//add_actor_anim( "guy_soldier4", %ch_ang_08_01_radio_room_encounter_adult04 );
	add_actor_anim( "child_soldier_1", %ch_ang_08_01_radio_room_encounter_child01 );
	add_actor_anim( "child_soldier_2", %ch_ang_08_01_radio_room_encounter_child02 );
	add_actor_anim( "child_soldier_3", %ch_ang_08_01_radio_room_encounter_child03 );
	add_actor_anim( "child_soldier_4", %ch_ang_08_01_radio_room_encounter_child04 );
	add_prop_anim( "menendez_door", %animated_props::o_ang_08_01_radio_room_encounter_door, undefined, !SCENE_DELETE, SCENE_SIMPLE_PROP );

	add_scene( "meatshield_enemy_attack_ai2", "meat_shield" );
	add_actor_anim( "guy_soldier2", %ch_ang_08_01_radio_room_encounter_adult02 );
	add_notetrack_custom_function( "guy_soldier2", "threat", ::guy_soldier2_meatshield_threat );
	add_notetrack_custom_function( "guy_soldier2", "not_threat", ::guy_soldier2_meatshield_not_threat );

	add_scene( "meatshield_enemy_attack_ai2_variation", "meat_shield" );
	add_actor_anim( "guy_soldier2", %ch_ang_08_01_radio_room_encounter_B_adult02 );
	add_notetrack_custom_function( "guy_soldier2", "threat", ::guy_soldier2_meatshield_threat );
	add_notetrack_custom_function( "guy_soldier2", "not_threat", ::guy_soldier2_meatshield_not_threat );

	add_scene( "meatshield_enemy_attack_ai3", "meat_shield" );
	add_actor_anim( "guy_soldier3", %ch_ang_08_01_radio_room_encounter_adult03 );
	add_notetrack_custom_function( "guy_soldier3", "threat", ::guy_soldier3_meatshield_threat );
	add_notetrack_custom_function( "guy_soldier3", "not_threat", ::guy_soldier3_meatshield_not_threat );

	add_scene( "meatshield_enemy_attack_ai4", "meat_shield" );
	add_actor_anim( "guy_soldier4", %ch_ang_08_01_radio_room_encounter_adult04 );
	add_notetrack_custom_function( "guy_soldier4", "threat", ::guy_soldier4_meatshield_threat );
	add_notetrack_custom_function( "guy_soldier4", "not_threat", ::guy_soldier4_meatshield_not_threat );

	add_scene( "meatshield_enemy_attack_ai4_variation", "meat_shield" );
	add_actor_anim( "guy_soldier4", %ch_ang_08_01_radio_room_encounter_B_adult04 );
	add_notetrack_custom_function( "guy_soldier4", "threat", ::guy_soldier4_meatshield_threat );
	add_notetrack_custom_function( "guy_soldier4", "not_threat", ::guy_soldier4_meatshield_not_threat );
	
	add_scene( "meatshield_enemy_retreat", "meat_shield" );
	add_actor_anim( "guy_soldier", %ch_ang_08_01_radio_room_escape_adult, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "guy_soldier2", %ch_ang_08_01_radio_room_escape_adult02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	//add_actor_anim( "guy_soldier3", %ch_ang_08_01_radio_room_escape_adult03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_1", %ch_ang_08_01_radio_room_escape_child01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_2", %ch_ang_08_01_radio_room_escape_child02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_3", %ch_ang_08_01_radio_room_escape_child03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "child_soldier_4", %ch_ang_08_01_radio_room_escape_child04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_prop_anim( "nada", %animated_props::o_ang_08_01_radio_room_escape_grenade, "weapon_m67_grenade", SCENE_DELETE, SCENE_SIMPLE_PROP );
	add_actor_model_anim( "menendez", %ch_ang_08_01_radio_room_escape_menendez, undefined, SCENE_DELETE );
	add_player_anim( "player_body", %player::ch_ang_08_01_radio_room_escape_player, SCENE_DELETE );
	add_notetrack_custom_function( "player_body", "shoot_menendez", ::shoot_menendez_muzzle_flash );
	add_notetrack_custom_function( "player_body", "explosion", ::meatshield_grenade_explosion );

	add_scene( "meatshield_enemy_retreat_guy4", "meat_shield" );
	add_actor_anim( "guy_soldier4", %ch_ang_08_01_radio_room_escape_adult04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );	
}

shoot_menendez_muzzle_flash( guy )
{
	PlayFXOnTag( level._effect["def_muzzle_flash"], level.mason_meatshield_weapon, "tag_fx" );
}

meatshield_grenade_explosion( guy )
{
	level notify( "meatshield_grenade_explosion" );
}

guy_soldier2_meatshield_threat( guy )
{
	//IPrintLnBold( "GUY2 - Threat" );
	guy.meatshield_threat = true;
}
guy_soldier2_meatshield_not_threat( guy )
{
	//IPrintLnBold( "GUY2 - Not Threat" );
	guy.meatshield_threat = false;
}
guy_soldier3_meatshield_threat( guy )
{
	//IPrintLnBold( "GUY3 - Threat" );
	guy.meatshield_threat = true;
}
guy_soldier3_meatshield_not_threat( guy )
{
	//IPrintLnBold( "GUY3 - Not Threat" );
	guy.meatshield_threat = false;
}
guy_soldier4_meatshield_threat( guy )
{
	//IPrintLnBold( "GUY4 - Threat" );
	guy.meatshield_threat = true;
}
guy_soldier4_meatshield_not_threat( guy )
{
	//IPrintLnBold( "GUY4 - Not Threat" );
	guy.meatshield_threat = false;
}


//*****************************************************************************
//*****************************************************************************

#using_animtree( "player" );
player_meatshield_anims()
{
	//Rig setup
	level.scr_animtree[ "player_body" ] = #animtree;
	
	level.scr_model[ "player_body" ] = level.player_interactive_hands;

	level.scr_anim[ "player_body" ][ "mason_move_loop" ][0] = %player::ch_ang_08_01_meatshield_idle_player;
	// todo - add turn anims?
}

#using_animtree("generic_human");
menendez_meatshield_anims()
{
	level.scr_anim[ "menendez" ][ "walk" ][0] = %ch_ang_08_01_meatshield_idle_menendez;
}


//*****************************************************************************
//*****************************************************************************

jungle_escape_anims()
{
	// Climb Up Tree
	add_scene( "player_climb_up_tree_60", undefined );
	add_player_anim( "player_body", %player::int_tree_climb_20, SCENE_DELETE );	

	// Climb Down Tree
	add_scene( "player_climb_down_tree_60", undefined );
	add_player_anim( "player_body", %player::int_tree_climb_down_20, SCENE_DELETE );

	// Climb Up Tree
	add_scene( "player_climb_up_tree_10", undefined );
	add_player_anim( "player_body", %player::int_tree_climb_10, SCENE_DELETE );	

	// Climb Down Tree
	add_scene( "player_climb_down_tree_10", undefined );
	add_player_anim( "player_body", %player::int_tree_climb_down_10, SCENE_DELETE );

	// New Climb Up Tree
	add_scene( "player_climb_up_tree_new", undefined );
	add_player_anim( "player_body", %player::int_angola_climb_tree_up, SCENE_DELETE );	

	// New Climb Down Tree
	add_scene( "player_climb_down_tree_new", undefined );
	add_player_anim( "player_body", %player::int_angola_climb_tree_down, SCENE_DELETE );
	
	// Defend Area 1: Enemy Alerted
	add_scene( "je_defend1_enemy_alerted", "woods_cover" );
	add_actor_anim( "guy_soldier", %ch_ang_10_03_escape_alerted_guy01 );

	// Defend Area 2 to 3 move: Enemy Alerted
	add_scene( "je_defend2_enemy_alerted", "woods_cover" );
	add_actor_anim( "guy_soldier", %ch_ang_10_03_escape_alerted_guy02 );

		
	// Hudson and Woods waiting to begin the Jungle Escape path
	add_scene( "hudson_woods_jungle_escape_begin_loop", "regroup_to_defend_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "hudson", %ch_ang_10_01_escape_hudson_cycle_bg );
	add_actor_anim( "woods", %ch_ang_10_01_escape_woods_cycle_bg, SCENE_HIDE_WEAPON );

	// Mason, explains to Hudson that the evacuation call has been made
	add_scene( "mason_meets_hudson_and_woods_at_start", "defend_2" );
	add_actor_anim( "hudson", %ch_ang_10_01_escape_hudson_01 );
	add_actor_anim( "woods", %ch_ang_10_01_escape_woods_01, SCENE_HIDE_WEAPON );

	// *** CUT ***
	//add_scene( "mason_meets_hudson_and_woods_at_start_player", "regroup_to_defend_1" );
	//add_player_anim( "player_body", %player::p_ang_10_01_escape, true );

	// Hudson and Woods Reach the 1st rest point in the Jungle Escape path
	add_scene( "hudson_woods_jungle_escape_stop_01_loop", "defend_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	//add_actor_anim( "hudson", %ch_ang_10_01_escape_hudson_cycle_02 );
	add_actor_anim( "woods", %ch_ang_10_01_escape_woods_cycle_02, SCENE_HIDE_WEAPON );


	// Beartrap Animations
	jungle_escape_beartrap_animations();


	//***********************************************************
	// Hudson and Woods start the journey to the 2nd defend point
	//***********************************************************

	add_scene( "hudson_and_woods_jungle_escape_move_defend_2", "defend_2", SCENE_REACH );
	add_actor_anim( "hudson", %ch_ang_10_02_escape_hudson );
	add_actor_anim( "woods", %ch_ang_10_02_escape_woods, SCENE_HIDE_WEAPON );

	// Hudson and Woods Reach the 2nd defend point in the Jungle Escape path
	add_scene( "hudson_woods_jungle_escape_stop_02_loop", "defend_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	//add_actor_anim( "hudson", %ch_ang_10_02_escape_hudson_cycle_end );
	add_actor_anim( "woods", %ch_ang_10_02_escape_woods_cycle_end, SCENE_HIDE_WEAPON );


	//***********************************************************
	// Hudson and Woods start the journey to the 3rd defend point
	//***********************************************************

	add_scene( "hudson_and_woods_jungle_escape_move_defend_3", "defend_2", SCENE_REACH );
	add_actor_anim( "hudson", %ch_ang_10_03_escape_hudson );
	add_actor_anim( "woods", %ch_ang_10_03_escape_woods, SCENE_HIDE_WEAPON );

	// Hudson and Woods Reach the 2nd defend point in the Jungle Escape path
	add_scene( "hudson_woods_jungle_escape_stop_03_loop", "defend_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	//add_actor_anim( "hudson", %ch_ang_10_03_escape_hudson_cycle_end );
	add_actor_anim( "woods", %ch_ang_10_03_escape_woods_cycle_end, SCENE_HIDE_WEAPON );


	//***********************************************************
	// Hudson and Woods start the journey to the beach evac point
	//***********************************************************

	add_scene( "hudson_and_woods_jungle_escape_beach_evac", "helicopter_land" );
	add_actor_anim( "hudson", %ch_ang_10_04_beach_hudson );
	add_actor_anim( "woods", %ch_ang_10_04_beach_woods, SCENE_HIDE_WEAPON );

	add_scene( "hudson_and_woods_jungle_escape_beach_collapse", "helicopter_land", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "hudson", %ch_ang_10_04_beach_wait_hudson );
	add_actor_anim( "woods", %ch_ang_10_04_beach_wait_woods, SCENE_HIDE_WEAPON );

	
	//***********************************************************
	// Final 'Hind" Scene animations
	//***********************************************************

	add_scene( "hind_attack_end_scene", "helicopter_land" );
	add_actor_anim( "savimbi", %ch_ang_10_04_chopper_savimbi );
	add_actor_anim( "hind_dummy_pilot", %ch_ang_10_04_chopper_enemy );
	//add_vehicle_anim( "hind_end_angola_scene", %vehicles::v_ang_10_04_chopper_hind );
	add_vehicle_anim( "hind_end_level", %vehicles::v_ang_10_04_chopper_hind );
	
	add_actor_anim( "woods", %ch_ang_10_04_chopper_woods );
	add_actor_anim( "hudson", %ch_ang_10_04_chopper_hudson, SCENE_HIDE_WEAPON );
	add_player_anim( "player_body", %player::ch_ang_10_04_chopper_player, true, 0, undefined, true, 1, 45, 45, 10, 10 );
	
	add_notetrack_custom_function( "player_body", "dof1", maps\createart\angola_art::angola2_finale_dof1 );
	add_notetrack_custom_function( "player_body", "dof2", maps\createart\angola_art::angola2_finale_dof2 );
	add_notetrack_custom_function( "player_body", "dof3", maps\createart\angola_art::angola2_finale_dof3 );
	
	add_notetrack_custom_function( "player_body", "fade_out", maps\angola_2::level_fade_out );
	add_notetrack_custom_function( "hind_dummy_pilot", "shot", ::woods_shoots_pistol_effect );
}

woods_shoots_pistol_effect( guy )
{
	wait( 2.1 );
	PlayFXOnTag( level._effect["woods_muzzleflash"], level.woods_weapon, "tag_fx" );
}


//*****************************************************************************
//*****************************************************************************

jungle_escape_beartrap_animations()
{

/*
	// Mason Primes the Bear Trap with the explosive mortar
	add_scene( "beartrap_idle_open", "beartrap" );
	add_prop_anim( "fake_beartrap", %animated_props::o_beartrap_idle_open );
*/


	//********************************************************************
	// WE NEED TO CREATE UNIQUE INSTANCES OF THE BEARTRAP SCENE ANIMATIONS
	// BECAUSE MULTIPLE TRAPS COULD BE ACTIVE AT THE SAME TIME
	//********************************************************************

	level.beartrap_anim_index = 1;
	level.beartrap_max_num = 5;

	// TRAP1 - AI beartrap Caught Start
	add_scene( "trap1_ai_beartrap_caught", "beartrap1", !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_hit, SCENE_HIDE_WEAPON );
	add_scene( "trap1_ai_beartrap_caught_loop", "beartrap1", !SCENE_REACH, SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_pain_idle, SCENE_HIDE_WEAPON );

	// TRAP2 - AI beartrap Caught Start
	add_scene( "trap2_ai_beartrap_caught", "beartrap2", !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_hit, SCENE_HIDE_WEAPON );
	add_scene( "trap2_ai_beartrap_caught_loop", "beartrap2", !SCENE_REACH, SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_pain_idle, SCENE_HIDE_WEAPON );

	// TRAP3 - AI beartrap Caught Start
	add_scene( "trap3_ai_beartrap_caught", "beartrap3", !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_hit, SCENE_HIDE_WEAPON );
	add_scene( "trap3_ai_beartrap_caught_loop", "beartrap3", !SCENE_REACH, SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_pain_idle, SCENE_HIDE_WEAPON );

	// TRAP4 - AI beartrap Caught Start
	add_scene( "trap4_ai_beartrap_caught", "beartrap4", !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_hit, SCENE_HIDE_WEAPON );
	add_scene( "trap4_ai_beartrap_caught_loop", "beartrap4", !SCENE_REACH, SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_pain_idle, SCENE_HIDE_WEAPON );

	// TRAP5 - AI beartrap Caught Start
	add_scene( "trap5_ai_beartrap_caught", "beartrap5", !SCENE_REACH, SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_hit, SCENE_HIDE_WEAPON );
	add_scene( "trap5_ai_beartrap_caught_loop", "beartrap5", !SCENE_REACH, SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "generic", %ai_wounded_beartrap_pain_idle, SCENE_HIDE_WEAPON );


	//**********************************************************************
	// Multiple instances on the beartrap being primed by a mortar animation
	//**********************************************************************

	// TRAP1 - Mason Primes the Bear Trap with the explosive mortar
	add_scene( "trap1_add_mortar", "beartrap1" );
	add_player_anim( "player_body", %player::int_beartrap_mortar_plant, SCENE_DELETE );	
	add_prop_anim( "mortar1", %animated_props::o_beartrap_mortar_plant_mortar, "t6_wpn_mortar_shell_prop_view" );
	//add_prop_anim( "beartrap_fake", %animated_props::o_beartrap_mortar_plant_trap );

	// TRAP2 - Mason Primes the Bear Trap with the explosive mortar
	add_scene( "trap2_add_mortar", "beartrap2" );
	add_player_anim( "player_body", %player::int_beartrap_mortar_plant, SCENE_DELETE );	
	add_prop_anim( "mortar2", %animated_props::o_beartrap_mortar_plant_mortar, "t6_wpn_mortar_shell_prop_view" );
	//add_prop_anim( "beartrap_fake", %animated_props::o_beartrap_mortar_plant_trap );

	// TRAP3 - Mason Primes the Bear Trap with the explosive mortar
	add_scene( "trap3_add_mortar", "beartrap3" );
	add_player_anim( "player_body", %player::int_beartrap_mortar_plant, SCENE_DELETE );	
	add_prop_anim( "mortar3", %animated_props::o_beartrap_mortar_plant_mortar, "t6_wpn_mortar_shell_prop_view" );
	//add_prop_anim( "beartrap_fake", %animated_props::o_beartrap_mortar_plant_trap );

	// TRAP4 - Mason Primes the Bear Trap with the explosive mortar
	add_scene( "trap4_add_mortar", "beartrap4" );
	add_player_anim( "player_body", %player::int_beartrap_mortar_plant, SCENE_DELETE );	
	add_prop_anim( "mortar4", %animated_props::o_beartrap_mortar_plant_mortar, "t6_wpn_mortar_shell_prop_view" );
	//add_prop_anim( "beartrap_fake", %animated_props::o_beartrap_mortar_plant_trap );

	// TRAP5 - Mason Primes the Bear Trap with the explosive mortar
	add_scene( "trap5_add_mortar", "beartrap5" );
	add_player_anim( "player_body", %player::int_beartrap_mortar_plant, SCENE_DELETE );	
	add_prop_anim( "mortar5", %animated_props::o_beartrap_mortar_plant_mortar, "t6_wpn_mortar_shell_prop_view" );
	//add_prop_anim( "beartrap_fake", %animated_props::o_beartrap_mortar_plant_trap );
}


//*****************************************************************************
//*****************************************************************************

// self = beartrap
set_beartrap_anim_names()
{
	self.str_anim_name_ai_caught = "trap" + level.beartrap_anim_index + "_ai_beartrap_caught";
	self.str_anim_name_ai_caught_loop = self.str_anim_name_ai_caught + "_loop";
	self.str_anim_name_add_mortar = "trap" + level.beartrap_anim_index + "_add_mortar";

	level.beartrap_anim_index++;
	if( level.beartrap_anim_index > level.beartrap_max_num )
	{
		level.beartrap_anim_index = 1;
	}
}


//*****************************************************************************
//*****************************************************************************

get_beartrap_targetname_from_scene_name( str_scene_name )
{
	if( isSubStr(str_scene_name, "trap1") )
	{
		str_targetname = "beartrap1";
	}
	else if( isSubStr(str_scene_name, "trap2") )
	{
		str_targetname = "beartrap2";
	}
	else if( isSubStr(str_scene_name, "trap3") )
	{
		str_targetname = "beartrap3";
	}
	else if( isSubStr(str_scene_name, "trap4") )
	{
		str_targetname = "beartrap4";
	}
	else
	{
		str_targetname = "beartrap5";
	}
	return( str_targetname );
}


//*****************************************************************************
//*****************************************************************************

#using_animtree("generic_human");
init_angola_anims()
{
	level.scr_anim[ "misc_patrol" ][ "walk" ] = %patrol_jog;
	level.scr_anim[ "alerted_patrol" ][ "walk" ] = %patrol_jog_360;
	level.scr_anim[ "stand_and_look_around" ][ "stand" ] = %patrol_bored_react_walkstop;
}


//*****************************************************************************
//*****************************************************************************

#using_animtree( "player" );
player_stealth_carry_anims()
{
	//Rig setup
	level.scr_animtree[ "player_body" ] = #animtree;

	level.scr_model[ "player_body" ] = level.player_interactive_hands;
	
	level.scr_anim[ "player_body" ][ "mason_carry_idle" ][0] = %player::ch_ang_07_01_carry_woods_player_idle;
	level.scr_anim[ "player_body" ][ "mason_carry_run" ][0]	= %player::ch_ang_07_01_carry_woods_player;
	level.scr_anim[ "player_body" ][ "mason_carry_coughing" ][0] = %player::ch_ang_07_01_carry_woods_player_cough;

	level.scr_anim[ "player_body" ][ "mason_carry_crouch_idle" ][0] = %player::ch_ang_07_01_carry_woods_player_crouch_idle;
	level.scr_anim[ "player_body" ][ "mason_carry_crouch_in" ][0] = %player::ch_ang_07_01_carry_woods_player_crouch_in;
	level.scr_anim[ "player_body" ][ "mason_carry_crouch_out" ][0] = %player::ch_ang_07_01_carry_woods_player_crouch_out;
	level.scr_anim[ "player_body" ][ "mason_carry_crouch_walk" ][0] = %player::ch_ang_07_01_carry_woods_player_crouch_walk;
}


//*****************************************************************************
//*****************************************************************************

#using_animtree("generic_human");
woods_stealth_carry_anims()
{
	// Mason Carry Woods
	level.scr_anim[ "woods" ][ "mason_carry_idle" ][0]	= %ch_ang_07_01_carry_woods_woods_idle;
	level.scr_anim[ "woods" ][ "mason_carry_run" ][0]	= %ch_ang_07_01_carry_woods_woods;
	level.scr_anim[ "woods" ][ "mason_carry_coughing" ][0]	= %ch_ang_07_01_carry_woods_woods_cough;

	level.scr_anim[ "woods" ][ "mason_carry_crouch_idle" ][0] = %ch_ang_07_01_carry_woods_woods_crouch_idle;
	level.scr_anim[ "woods" ][ "mason_carry_crouch_in" ][0]	= %ch_ang_07_01_carry_woods_woods_crouch_in;
	level.scr_anim[ "woods" ][ "mason_carry_crouch_out" ][0] = %ch_ang_07_01_carry_woods_woods_crouch_out;
	level.scr_anim[ "woods" ][ "mason_carry_crouch_walk" ][0] = %ch_ang_07_01_carry_woods_woods_crouch_walk;
}





