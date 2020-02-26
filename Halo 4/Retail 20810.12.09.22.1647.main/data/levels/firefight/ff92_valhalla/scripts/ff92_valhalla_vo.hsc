//=============================================================================================================================
//============================================ SNIPER ALLEY VALHALLA VO SCRIPT ===============================================
//=============================================================================================================================

global boolean b_game_v_defend = FALSE;
global boolean b_play_bb1_line = FALSE;

// VO Event scripts for VALHALLA
//=============================================================================================================================
//================================================== MISSION 3 :  =======================================================
//=============================================================================================================================

script continuous f_m3_conv_1
	sleep_until (LevelEventStatus("m3_start_defend_1"), 1);
	vo_oyo_m3_p1();
	vo_oyo_m3_r1();
	vo_oyo_m3_p2();
	b_game_v_defend = true;
	b_play_bb1_line = true;
end

script continuous f_m3_conv_2
	sleep_until (LevelEventStatus("m3_start_defend_2"), 1);
//	sound_looping_stop (music_start);
//	sleep(30 * 1);
	vo_oyo_m3_r2();
	vo_oyo_m3_p3();
end

//script continuous f_m3_flav_1
//	sleep_until (volume_test_players (unit_spawn_1), 1);
//	if (b_game_v_defend == true) then
//		if (b_play_bb1_line == true) then
//			ai_set_objective (guards_6, obj_survival);
//			sleep(30 * 3);
//			vo_oyo_m3_bb1();
//			vo_oyo_m3_p4();
//			vo_oyo_m3_bb2();
//			sleep_forever();
//		end
//	end
//end

script continuous f_m3_flav_2
	sleep_until (LevelEventStatus("enemies_spawn_1"), 1);
	sleep(30 * 6);
	vo_oyo_m3_p5();
end

script continuous f_m3_conv_3
	sleep_until (LevelEventStatus("spartan_arrival"), 1);
	print("_____________________spartans are here");
	sleep(30 * 20); // temp
	vo_oyo_m3_m1_1();
	vo_oyo_m3_m2_1();
	vo_oyo_m3_m3_1();
	vo_oyo_m3_m2_2();
	vo_oyo_m3_m3_3();
	f_m3_conv_4();
end

script static void f_m3_conv_4
	//sleep_until (LevelEventStatus("enemies_spawn_2_more"), 1);
	sleep(30 * 5);
	vo_oyo_m3_p6();
end

script continuous f_m3_conv_5
	sleep_until (LevelEventStatus("weapon_drop_no"), 1);
	vo_oyo_m3_p7();
	vo_oyo_m3_d1();
	vo_oyo_m3_p8();
end

script continuous f_m3_flav_3
	sleep_until (LevelEventStatus("enemies_spawn_3_knights"), 1);
	sleep(30 * 5);
	vo_oyo_m3_bb_3();
	vo_oyo_m3_p9();
	vo_oyo_m3_bb4();
end

//script continuous f_m3_flav_4
//	sleep_until (volume_test_players (unit_spawn_2), 1);
//	if (b_game_v_defend == true) then
//		vo_oyo_m3_p10();
//		sleep_forever();
//	end
//end

script continuous f_m3_conv_6
	sleep_until (LevelEventStatus("m3_end_defend"), 1);
	vo_oyo_m3_p11();
	vo_oyo_m3_r3();
	vo_oyo_m3_bb5();
	vo_oyo_m3_p12();
	b_game_v_defend = false;
end

//=============================================================================================================================
//================================================== MISSION 4 : ESCAPE =======================================================
//=============================================================================================================================
script continuous f_m4_conv_1
	sleep_until (LevelEventStatus("m4_start_escape"), 1);
	vo_oyo_m4_p1();
	vo_oyo_m4_bb1();
	vo_oyo_m4_p2();
	vo_oyo_m4_p3();
end

script continuous f_m4_conv_2
	sleep_until (LevelEventStatus("m4_shield_blocked"), 1);
	vo_oyo_m4_r1();
	vo_oyo_m4_p4();
	vo_oyo_m4_r2();
	
end

script continuous f_m4_conv_3
	sleep_until (LevelEventStatus("m4_shield_blocked_2"), 1);
	print("___________________no luck here");
	sleep(30 * 10);
	vo_oyo_m4_r3();
	vo_oyo_m4_p5();
end

script continuous f_m4_conv_4
	sleep_until (LevelEventStatus("m4_shield_down"), 1);
	vo_oyo_m4_p6();
end

//script continuous f_m4_conv_5
//	sleep_until (LevelEventStatus("m4_shield_down_2"), 1);
//	thread(start_camera_shake_loop ("heavy", "low"));
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_10);
//	sleep (30 * 1);
//	effect_new_on_ground (objects\props\covenant\drop_pod_elite_cheap\fx\destruction\explosion.effect, forcefield_10);
//	object_destroy_folder (dm_f_shields_2);
//	stop_camera_shake_loop();
//	vo_oyo_m4_r4();
//	vo_oyo_m4_p7();
//	vo_oyo_m4_p8();	
//end

script continuous f_m4_conv_6
	sleep_until (LevelEventStatus("m4_end_escape"), 1);
	vo_oyo_m4_d1();
	vo_oyo_m4_p9();
	vo_oyo_m4_d2();
	vo_oyo_m4_p10();
end

script continuous f_m3_conv_4_escape
	sleep_until (LevelEventStatus("enemies_spawn_2_more"), 1);
	vo_oyo_m3_p6();
end

// ==============================================================================================================
// ====== E3_m3_VALHALLA =============================================================================
// ==============================================================================================================
script continuous f_e3_m3_start_true  //setting the mission 
	sleep_until (LevelEventStatus("e1_m4_start_true"), 1);
	NotifyLevel ("start_intro");
	mission_is_e3_m3 = true;
end

script continuous f_e1_m4_d_1
	sleep_until (LevelEventStatus("e1_m4_d_1"), 1);
	cinematic_set_title (e1_m4_d_1);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_2);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_3);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_4);	
end

script continuous f_e1_m4_d_5
	sleep_until (LevelEventStatus("e1_m4_d_5"), 1);
	cinematic_set_title (e1_m4_d_5);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_6);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_7);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_8);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_9);
end

script continuous f_e1_m4_d_10
	sleep_until (LevelEventStatus("e1_m4_d_10"), 1);
	cinematic_set_title (e1_m4_d_10);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_11);
end

script continuous f_e1_m4_d_12
	sleep_until (LevelEventStatus("e1_m4_d_12"), 1);
	cinematic_set_title (e1_m4_d_12);
end

script continuous f_e1_m4_d_13
	sleep_until (LevelEventStatus("e1_m4_d_13"), 1);
	cinematic_set_title (e1_m4_d_13);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_14);
	sleep(30 * 5);
	//cinematic_set_title (e1_m4_d_15);
	//sleep(30 * 5);
	cinematic_set_title (e1_m4_d_16);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_17);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_18);
end

script continuous f_e1_m4_d_19
	sleep_until (LevelEventStatus("e1_m4_d_19"), 1);
	cinematic_set_title (e1_m4_d_19);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_20);
end

script continuous f_e1_m4_d_21
	sleep_until (LevelEventStatus("e1_m4_d_21"), 1);
	cinematic_set_title (e1_m4_d_21);
end

script continuous f_e1_m4_d_22
	sleep_until (LevelEventStatus("e1_m4_d_22"), 1);
	cinematic_set_title (e1_m4_d_22);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_23);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_24);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_25);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_26);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_27);
end

script continuous f_e1_m4_d_28
	sleep_until (LevelEventStatus("e1_m4_d_28"), 1);
	cinematic_set_title (e1_m4_d_28);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_29);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_30);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_31);	
end

script continuous f_e1_m4_d_30
	sleep_until (LevelEventStatus("e1_m4_d_30"), 1);
	cinematic_set_title (e1_m4_d_30);
	sleep(30 * 5);
	cinematic_set_title (e1_m4_d_31);	
end
