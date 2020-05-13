//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice_audio
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global sound core_hit_camera_shake = 'sound\environments\solo\m090\amb_m90_screen_shakes\m90_core_hit_camera_shake';
global sound coldant_camera_shake_heavy_short = 'sound\environments\solo\m090\amb_m90_screen_shakes\m90_coldant_camera_shake_heavy_short';
global sound coldant_camera_shake_medium_medium = 'sound\environments\solo\m090\amb_m90_screen_shakes\m90_coldant_camera_shake_medium_medium';
global sound eye_beam_camera_shake = 'sound\environments\solo\m090\amb_m90_screen_shakes\m90_eye_beam_camera_shake';

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m90_sacrifice_audio()

	if b_debug then 
		print ("::: M90 - AUDIO :::");
	end
	
	thread(test_fx());
	thread (load_music_for_zone_set());
end

script static void test_audio()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end

// =================================================================================================
// *** MUSIC ***
// =================================================================================================

// =================================================================================================
//     Encounters
// =================================================================================================
script static void f_mus_m90_e01_start()
	dprint("f_mus_m90_e01");
	music_set_state('Play_mus_m90_e01_space_fight');
end

script static void f_mus_m90_e02_start()
	dprint("f_mus_m90_e02");
	music_set_state('Play_mus_m90_e03_arcade');
end

script static void f_mus_m90_e03_start()
	dprint("f_mus_m90_e03");
	music_set_state('Play_mus_m90_e05_teleport');
end

script static void f_mus_m90_e04_start()
	dprint("f_mus_m90_e04");
	music_set_state('Play_mus_m90_e07_walls');
end

script static void f_mus_m90_e05_start()
	dprint("f_mus_m90_e05");
	music_set_state('Play_mus_m90_e09_coldant_west');
end

script static void f_mus_m90_e07_start()
	dprint("f_mus_m90_e07");
	music_set_state('Play_mus_m90_e13_coldant_east');
end

script static void f_mus_m90_e08_start()
	dprint("f_mus_m90_e08");
end

script static void f_mus_m90_e09_start()
	dprint("f_mus_m90_e09");
end

script static void f_mus_m90_e10_start()
	dprint("f_mus_m90_e10");
end

script static void f_mus_m90_e11_start()
	dprint("f_mus_m90_e11");
end

script static void f_mus_m90_e12_start()
	dprint("f_mus_m90_e12");
end

script static void f_mus_m90_e13_start()
	dprint("f_mus_m90_e13");
end

script static void f_mus_m90_e14_start()
	dprint("f_mus_m90_e14");
end

script static void f_mus_m90_e01_finish()
	dprint("f_mus_m90_e01");
	music_set_state('Play_mus_m90_e02_space_fight_end');
end

script static void f_mus_m90_e02_finish()
	dprint("f_mus_m90_e02");
	music_set_state('Play_mus_m90_e04_arcade_end');
end

script static void f_mus_m90_e03_finish()
	dprint("f_mus_m90_e03");
	music_set_state('Play_mus_m90_e06_teleport_end');
end

script static void f_mus_m90_e04_finish()
	dprint("f_mus_m90_e04");
	music_set_state('Play_mus_m90_e08_walls_end');
end

script static void f_mus_m90_e05_finish()
	dprint("f_mus_m90_e05");
	music_set_state('Play_mus_m90_e10_coldant_west_end');
end

script static void f_mus_m90_e07_finish()
	dprint("f_mus_m90_e07");
	music_set_state('Play_mus_m90_e14_coldant_east_end');
end

script static void f_mus_m90_e08_finish()
	dprint("f_mus_m90_e08");
end

script static void f_mus_m90_e09_finish()
	dprint("f_mus_m90_e09");
end

script static void f_mus_m90_e10_finish()
	dprint("f_mus_m90_e10");
end

script static void f_mus_m90_e11_finish()
	dprint("f_mus_m90_e11");
end

script static void f_mus_m90_e12_finish()
	dprint("f_mus_m90_e12");
end

script static void f_mus_m90_e13_finish()
	dprint("f_mus_m90_e13");
end

script static void f_mus_m90_e14_finish()
	dprint("f_mus_m90_e14");
end

script static void f_music_m90_tweak01()
	dprint("f_music_m90_tweak01");
	music_set_state('Play_mus_m90_t01_tweak');
end

script static void f_music_m90_tweak02()
	dprint("f_music_m90_tweak02");
	music_set_state('Play_mus_m90_t02_tweak');
end

script static void f_music_m90_tweak03()
	dprint("f_music_m90_tweak03");
	music_set_state('Play_mus_m90_t03_tweak');
end

script static void f_music_m90_tweak04()
	dprint("f_music_m90_tweak04");
	music_set_state('Play_mus_m90_t04_tweak');
end

script static void f_music_m90_tweak05()
	dprint("f_music_m90_tweak05");
	music_set_state('Play_mus_m90_t05_tweak');
end

script static void f_music_m90_tweak06()
	dprint("f_music_m90_tweak06");
	music_set_state('Play_mus_m90_t06_tweak');
end

script static void f_music_m90_tweak07()
	dprint("f_music_m90_tweak07");
	music_set_state('Play_mus_m90_t07_tweak');
end

script static void f_music_m90_tweak08()
	dprint("f_music_m90_tweak08");
	music_set_state('Play_mus_m90_t08_tweak');
end

script static void f_music_m90_tweak09()
	dprint("f_music_m90_tweak09");
	music_set_state('Play_mus_m90_t09_tweak');
end

script static void f_music_m90_tweak10()
	dprint("f_music_m90_tweak10");
	music_set_state('Play_mus_m90_t10_tweak');
end

script static void f_music_m90_v05_rampancy_solution()
	dprint("f_music_m90_v05_rampancy_solution");
	music_set_state('Play_mus_m90_v05_rampancy_solution');
end

script static void f_music_m90_v11_horizontal_jump()
	dprint("f_music_m90_v11_horizontal_jump");
	music_set_state('Play_mus_m90_v11_horizontal_jump');
end

// after exiting chief vs didact cinematic
script static void f_music_m90_v13_vs_didact_1()
	dprint("f_music_m90_v13_vs_didact_1");
	music_set_state('Play_mus_m90_v13_vs_didact_1');
end

// player plants grenade in didact
script static void f_music_m90_v14_vs_didact_2()
	dprint("f_music_m90_v14_vs_didact_2");
	music_set_state('Play_mus_m90_v14_vs_didact_2');
end

// crawl prompt appears
script static void f_music_m90_v14_vs_didact_3()
	dprint("f_music_m90_v14_vs_didact_3");
	music_set_state('Play_mus_m90_v14_vs_didact_3');
end


// =================================================================================================
//     Zonesets
// =================================================================================================

// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m90_music_progression = 0;

script static void load_music_for_zone_set()
	sleep_until(b_m90_music_progression > 0 or current_zone_set_fully_active() == s_start_idx, 1);

	music_start('Play_mus_m90');	
	
	sleep_until(b_m90_music_progression > 10 or volume_test_players (tv_music_r01_start), 1);
	if b_m90_music_progression <= 10 then
		music_set_state('Play_mus_m90_r01_start');
		sound_set_state('Set_State_M90_start');
	end
	
	sleep_until(b_m90_music_progression > 20 or volume_test_players (tv_music_r02_trans_01), 1);
	if b_m90_music_progression <= 20 then
		music_set_state('Play_mus_m90_r02_trans_01');
		sound_set_state('Set_State_M90_trans_01');
	end
	
	sleep_until(b_m90_music_progression > 30 or volume_test_players (tv_music_r03_trench_b), 1);
	if b_m90_music_progression <= 30 then
		music_set_state('Play_mus_m90_r03_trench_b');
		sound_set_state('Set_State_M90_trench_b');
	end
	
	sleep_until(b_m90_music_progression > 40 or volume_test_players (tv_music_r04_trans_02), 1);
	if b_m90_music_progression <= 40 then
		music_set_state('Play_mus_m90_r04_trans_02');
		sound_set_state('Set_State_M90_trans_02');
	end
	
	sleep_until(b_m90_music_progression > 50 or volume_test_players (tv_music_r05_trench_c), 1);
	if b_m90_music_progression <= 50 then
		music_set_state('Play_mus_m90_r05_trench_c');
		sound_set_state('Set_State_M90_trench_c');
	end
	
	sleep_until(b_m90_music_progression > 60 or volume_test_players (tv_music_r06_trans_03), 1);
	if b_m90_music_progression <= 60 then
		music_set_state('Play_mus_m90_r06_trans_03');
		sound_set_state('Set_State_M90_trans_03');
	end
	sleep_until(b_m90_music_progression > 70 or volume_test_players (tv_music_r07_trench_d), 1);
	if b_m90_music_progression <= 70 then
		music_set_state('Play_mus_m90_r07_trench_d');
		sound_set_state('Set_State_M90_trench_d');
	end
	
	sleep_until(b_m90_music_progression > 80 or volume_test_players (tv_music_r08_trans_04_e), 1);
	if b_m90_music_progression <= 80 then
		music_set_state('Play_mus_m90_r08_trans_04_e');
		sound_set_state('Set_State_M90_trans_04_e');
	end

	// 	// Play_mus_m90_r09_tren_e_eye
		
	// player enters last trench before the eye
	sleep_until(b_m90_music_progression > 90 or volume_test_players (tv_music_r10_eye_trans), 1);
	if b_m90_music_progression <= 90 then
	  music_set_state('Play_mus_m90_r10_eye_trans');
	  sound_set_state('Set_State_M90_eye_trans');
	end

	// player enters large 'eye' area	
	sleep_until(b_m90_music_progression > 100 or volume_test_players (tv_music_r11_eye), 1);
	if b_m90_music_progression <= 100 then
	  music_set_state('Play_mus_m90_r11_eye');
	  sound_set_state('Set_State_M90_eye');
	end
	
	// cinematic

	// RALLY POINT BRAVO
	// insertion point crash- player is out of saber
	sleep_until(b_m90_music_progression > 110 or volume_test_players (tv_music_r18_arcade), 1);
	if b_m90_music_progression <= 110 then
		music_set_state('Play_mus_m90_r18_arcade');
		sound_set_state('Set_State_M90_arcade');
	end

	// Player enters room right before the big jump down	
	sleep_until(b_m90_music_progression > 120 or volume_test_players (tv_music_r14_arcade_drop), 1);
	if b_m90_music_progression <= 120 then	
		music_set_state('Play_mus_m90_r14_arcade_drop');
		sound_set_state('Set_State_M90_arcade_drop');
	end

	// teleport rooms	
	sleep_until(b_m90_music_progression > 130 or volume_test_players (tv_music_r19_teleport_rooms), 1);
	if b_m90_music_progression <= 130 then	
		music_set_state('Play_mus_m90_r19_teleport_rooms');
		sound_set_state('Set_State_M90_teleport_rooms');
	end

	// Player is about to exit portal room - might move this back a bit	
	sleep_until(b_m90_music_progression > 140 or volume_test_players (tv_music_r16_walls_teleport), 1);
	if b_m90_music_progression <= 140 then	
		music_set_state('Play_mus_m90_r16_walls_teleport');
		sound_set_state('Set_State_M90_walls_teleport');
	end

	//	Player enters 'coldant' room- wallz insertions point
	// Cortana says "the didact is cloaking the composer"	
	sleep_until(b_m90_music_progression > 150 or volume_test_players (tv_music_r17_teleport_coldant), 1);
	if b_m90_music_progression <= 150 then
		music_set_state('Play_mus_m90_r17_teleport_coldant');
		sound_set_state('Set_State_M90_teleport_coldant');
	end
	
	// RALLY POINT CHARLIE
	// jump- right before giant jump where you have a conversation
	sleep_until(b_m90_music_progression > 160 or volume_test_players (tv_music_r20_jump), 1);
	if b_m90_music_progression <= 160 then 
		music_set_state('Play_mus_m90_r20_jump');
		sound_set_state('Set_State_M90_jump');
	end

	// when player enters the final area, where cortana first 'splinters' herself	
	sleep_until(b_m90_music_progression > 170 or volume_test_players (tv_music_r13_final), 1);
	if b_m90_music_progression <= 170 then
		music_set_state('Play_mus_m90_r13_final');
		sound_set_state('Set_State_M90_final');
	end
	
	// when player gets up onto the big light-bridge
	sleep_until(b_m90_music_progression > 180 or volume_test_players (tv_music_r21_light_bridge), 1);
	if b_m90_music_progression <= 180 then
		music_set_state('Play_mus_m90_r21_bridge');
	end
	
	sleep_until(current_zone_set_fully_active() == s_ending_game_idx, 1);
		music_stop('Stop_mus_m90');
end
