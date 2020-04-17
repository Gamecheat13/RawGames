// =============================================================================================================================
//================== AUDIO SCRIPT ==================================================================
// =============================================================================================================================

// ============================================================
// Vignette
script static void f_music_start_e1_m5_vignette()
	dprint("f_music_start_e1_m5_vignette");
	music_start('Play_mus_pve_e1m5');
end

// ============================================================
// Part 1
script static void f_music_start_e1_m5_1()
	dprint("f_music_start_e1_m5_1");
	music_set_state('Play_mus_pve_e1m5_010_1_start');
end

script static void f_music_ranger_drop_start()
	dprint("f_music_ranger");
	music_set_state('Play_mus_pve_e1m5_020_1_ranger_drop');
end

script static void f_music_source_vo_start()
	dprint("f_music_source_vo_start");
	music_set_state('Play_mus_pve_e1m5_030_1_source_vo_start');
end

script static void f_music_source_vo_stop()
	dprint("f_music_source_vo_stop");
	music_set_state('Play_mus_pve_e1m5_040_1_source_vo_stop');
end

script static void f_music_turn_on_power_title()
	dprint("f_music_turn_on_power_title");
	music_set_state('Play_mus_pve_e1m5_050_1_power_title');
end

script static void f_music_end_e1_m5_1()
	dprint("f_music_end_e1_m5_1");
	music_set_state('Play_mus_pve_e1m5_060_1_end');
end

// ============================================================
// Part 1.5
script static void f_music_e1_m5_1_5_start()
	dprint("f_music_start_e1_m5_1_5");
	music_set_state('Play_mus_pve_e1m5_070_1_5_start');
end

script static void f_music_e1_m5_1_5_switch1()
	dprint("f_music_e1m5_switch1");
	music_set_state('Play_mus_pve_e1m5_080_1_5_switch1');
end

script static void f_music_e1_m5_1_5_switch2()
	dprint("f_music_e1m5_switch2");
	music_set_state('Play_mus_pve_e1m5_090_1_5_switch2');
end

script static void f_music_e1_m5_1_5_end()
	dprint("f_music_end_e1_m5_1_5");
	music_set_state('Play_mus_pve_e1m5_100_1_5_end');
end

// ============================================================
// Part 2
script static void f_music_e1_m5_2_start()
	dprint("f_music_start_e1_m5_2");
	music_set_state('Play_mus_pve_e1m5_110_2_start');
end

script static void f_music_e1_m5_2_clear_base_title()
	dprint("f_music_clear_base_title");
	music_set_state('Play_mus_pve_e1m5_120_2_clear_base_title');
end

script static void f_music_e1_m5_2_move_on_vo_start()
	dprint("f_music_e1_m5_2_move_on_vo_start");
	music_set_state('Play_mus_pve_e1m5_130_2_move_on_vo_start');
end

script static void f_music_e1_m5_2_move_on_vo_end()
	dprint("f_music_e1_m5_2_move_on_vo_end");
	music_set_state('Play_mus_pve_e1m5_140_2_move_on_vo_end');
end

// ============================================================
// Part 3
script static void f_music_e1_m5_3_start()
	dprint("f_music_e1_m5_3_start");
	music_set_state('Play_mus_pve_e1m5_150_3_start');
end

script static void f_music_e1_m5_3_more_shields_vo_start()
	dprint("f_music_e1_m5_3_more_shields_vo_start");
	music_set_state('Play_mus_pve_e1m5_160_3_more_shields_vo_start');
end

script static void f_music_e1_m5_3_more_shields_vo_end()
	dprint("f_music_e1_m5_3_more_shields_vo_end");
	music_set_state('Play_mus_pve_e1m5_170_3_more_shields_vo_end');
end

script static void f_music_e1_m5_3_hack_controls_vo_start()
	dprint("f_music_e1_m5_3_more_shields_vo_start");
	music_set_state('Play_mus_pve_e1m5_180_3_hack_controls_vo_start');
end

script static void f_music_e1_m5_3_hack_controls_vo_end()
	dprint("f_music_e1_m5_3_more_shields_vo_end");
	music_set_state('Play_mus_pve_e1m5_190_3_hack_controls_vo_end');
end

script static void f_music_e1_m5_3_drop_shields_title()
	dprint("f_music_e1_m5_3_drop_shields_title");
	music_set_state('Play_mus_pve_e1m5_200_3_drop_shields_title');
end

script static void f_music_e1_m5_3_hack_didnt_work()
	dprint("f_music_e1_m5_3_hack_didnt_work");
	music_set_state('Play_mus_pve_e1m5_210_3_hack_didnt_work');
end

script static void f_music_e1_m5_3_give_it_a_whack_title()
	dprint("f_music_e1_m5_3_give_it_a_whack_title");
	music_set_state('Play_mus_pve_e1m5_220_3_give_it_a_whack_title');
end

script static void f_music_e1_m5_3_shields_hacked()
	dprint("f_music_e1_m5_3_give_it_a_whack_title");
	music_set_state('Play_mus_pve_e1m5_230_3_shields_hacked');
end

script static void f_music_e1_m5_3_blow_up_shields()
	dprint("f_music_e1_m5_3_blow_up_shields");
	music_set_state('Play_mus_pve_e1m5_240_3_blow_up_shields');
end

// ============================================================
// Part 3
script static void f_music_e1_m5_4_start()
	dprint("f_music_e1_m5_4_start");
	music_set_state('Play_mus_pve_e1m5_250_4_start');
end

script static void f_music_e1_m5_4_foundcrew_vo_start()
	dprint("f_music_e1_m5_4_foundcrew_vo_start");
	music_set_state('Play_mus_pve_e1m5_260_4_foundcrew_vo_start');
end

script static void f_music_e1_m5_4_foundcrew_vo_end()
	dprint("f_music_e1_m5_4_foundcrew_vo_end");
	music_set_state('Play_mus_pve_e1m5_270_4_foundcrew_vo_end');
end

script static void f_music_e1_m5_4_get_artifact_title()
	dprint("f_music_e1_m5_4_get_artifact_title");
	music_set_state('Play_mus_pve_e1m5_280_4_get_artifact_title');
end

// ============================================================
// Dropship VO
script static void f_music_e1_m5_4_dropship_vo_start()
	dprint("f_music_e1_m5_4_foundcrew_vo_start");
	music_set_state('Play_mus_pve_e1m5_290_4_dropship_vo_start');
end

script static void f_music_e1_m5_4_dropship_vo_end()
	dprint("f_music_e1_m5_4_foundcrew_vo_end");
	music_set_state('Play_mus_pve_e1m5_300_4_dropship_vo_end');
end

// ============================================================
// Part 5
script static void f_music_e1_m5_5_start()
	dprint("f_music_e1_m5_5_start");
	music_set_state('Play_mus_pve_e1m5_310_5_start');
end

script static void f_music_e1_m5_5_animate_device()
	dprint("f_music_e1_m5_5_artifact_vo_start");
	music_set_state('Play_mus_pve_e1m5_320_5_animate_device');
end

script static void f_music_e1_m5_5_artifact_vo_start()
	dprint("f_music_e1_m5_5_artifact_vo_start");
	music_set_state('Play_mus_pve_e1m5_330_5_artifact_vo_start');
end

script static void f_music_e1_m5_5_artifact_vo_end()
	dprint("f_music_e1_m5_5_artifact_vo_end");
	music_set_state('Play_mus_pve_e1m5_340_5_artifact_vo_end');
end

// ============================================================
// Part 6
script static void f_music_e1_m5_6_start()
	dprint("f_music_e1_m5_6_start");
	music_set_state('Play_mus_pve_e1m5_350_6_start');
end

script static void f_music_e1_m5_6_lz_clear_title()
	dprint("f_music_e1_m5_6_lz_clear_title");
	music_set_state('Play_mus_pve_e1m5_360_6_lz_clear_title');
end

script static void f_music_e1_m5_6_pelican_vo_start()
	dprint("f_music_e1_m5_6_pelican_vo_start");
	music_set_state('Play_mus_pve_e1m5_370_6_pelican_vo_start');
end

script static void f_music_e1_m5_6_pelican_vo_end()
	dprint("f_music_e1_m5_6_pelican_vo_end");
	music_set_state('Play_mus_pve_e1m5_380_6_pelican_vo_end');
end

script static void f_music_e1_m5_6_takeoff()
	dprint("f_music_e1_m5_6_takeoff");
	music_set_state('Play_mus_pve_e1m5_390_6_takeoff');
end

script static void f_music_e1_m5_6_end()
	dprint("f_music_end_e1_m5_6_end");
	music_stop('Stop_mus_pve_e1m5');
end

script static void f_sfx_e1_m5_pelican_land(object pelican)
	dprint("f_sfx_e1_m5_pelican_land");
	sound_impulse_start('sound\environments\multiplayer\pve\ep_01_mission_05\events\sfx_e1_m5_pelican_land', pelican, 1);
end

script static void f_sfx_e1_m5_pelican_takeoff(object pelican)
	dprint("f_sfx_e1_m5_pelican_takeoff");
	sound_impulse_start('sound\environments\multiplayer\pve\ep_01_mission_05\events\sfx_e1_m5_pelican_takeoff', pelican, 1);
end

script static void f_sfx_e1_m5_crawler_first_appearance()
	dprint("f_sfx_e1_m5_crawler_first_appearance");
	sound_impulse_start('sound\environments\multiplayer\pve\ep_01_mission_05\events\sfx_e1_m5_crawler_first_appearance', NONE, 1);
end