// =================================================================================================
// startup
// =================================================================================================
script startup f_m70_audio_startup()
	sleep_until( b_mission_started == TRUE, 1 );
	thread (load_music_for_zone_set());
end

// =================================================================================================
// Gondola ride
// =================================================================================================
script static void f_audio_gondola_moving_start()
	print("f_audio_gondola_moving_start");
	sound_impulse_start('tags\sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_gondola_start_st', NONE, 1);

	sound_looping_start_marker('sound\environments\solo\m070\amb_m70_final\amb_m70_machines\machine_m70_gondola_back_moving', dm_sp01_gondola, audio_gon_back, 1);
	sound_looping_start_marker('sound\environments\solo\m070\amb_m70_final\amb_m70_machines\machine_m70_gondola_front_moving', dm_sp01_gondola, audio_gon_front, 1);
end

script static void f_audio_gondola_moving_stop()
	print("f_audio_gondola_moving_stop");
	sound_impulse_start('\tags\sound\environments\solo\m070\amb_m70_final\amb_m70_machines\events\machine_m70_gondola_end_st', NONE, 1);

	sound_looping_stop('sound\environments\solo\m070\amb_m70_final\amb_m70_machines\machine_m70_gondola_back_moving');
	sound_looping_stop('sound\environments\solo\m070\amb_m70_final\amb_m70_machines\machine_m70_gondola_front_moving');
end

// =================================================================================================
// Global screen shake audio
// =================================================================================================
global sound m70_camera_shake_medium = 'sound\environments\solo\m070\amb_m70_final\amb_m70_screen_shakes\m70_camera_shake_medium';
global sound m70_camera_shake_weak = 'sound\environments\solo\m070\amb_m70_final\amb_m70_screen_shakes\m70_camera_shake_weak.';
global sound gondola_camera_shake = 'sound\environments\solo\m070\amb_m70_final\amb_m70_screen_shakes\m70_gondola_camera_shake';
global sound emp_hit_camera_shake = 'sound\environments\solo\m070\amb_m70_final\amb_m70_screen_shakes\m70_emp_hit_camera_shake';
global sound emp_pop_camera_shake = 'sound\environments\solo\m070\amb_m70_final\amb_m70_screen_shakes\m70_emp_pop_camera_shake';

// =================================================================================================
// music encounter hooks
// =================================================================================================
script static void f_mus_m70_e01_begin()
	dprint("f_mus_m70_e01");
	music_set_state('Play_mus_m70_e01_exterior_platforms');
end

script static void f_mus_m70_e02_begin()
	dprint("f_mus_m70_e02");
	music_set_state('Play_mus_m70_e03_spire1');
end

script static void f_mus_m70_e03_begin()
	dprint("f_mus_m70_e03");
	music_set_state('Play_mus_m70_e05_spire2');
end

script static void f_mus_m70_e04_begin()
	dprint("f_mus_m70_e04");
	music_set_state('Play_mus_m70_e07_spire3');
end

script static void f_mus_m70_e05_begin()
	dprint("f_mus_m70_e05");
	music_set_state('Play_mus_m70_e09_lich_train');
end

script static void f_mus_m70_e06_begin()
	dprint("f_mus_m70_e06");
end

script static void f_mus_m70_e07_begin()
	dprint("f_mus_m70_e07");
end

script static void f_mus_m70_e08_begin()
	dprint("f_mus_m70_e08");
end

script static void f_mus_m70_e09_begin()
	dprint("f_mus_m70_e09");
end

script static void f_mus_m70_e10_begin()
	dprint("f_mus_m70_e10");
end

script static void f_mus_m70_e01_finish()
	dprint("f_mus_m70_e01");
	music_set_state('Play_mus_m70_e02_exterior_platforms_end');
end

script static void f_mus_m70_e02_finish()
	dprint("f_mus_m70_e02");
	music_set_state('Play_mus_m70_e04_spire1_end');
end

script static void f_mus_m70_e03_finish()
	dprint("f_mus_m70_e03");
	music_set_state('Play_mus_m70_e06_spire2_end');
end

script static void f_mus_m70_e04_finish()
	dprint("f_mus_m70_e04");
	music_set_state('Play_mus_m70_e08_spire3_end');
end

script static void f_mus_m70_e05_finish()
	dprint("f_mus_m70_e05");
	music_set_state('Play_mus_m70_e10_lich_train_end');
end

script static void f_mus_m70_e06_finish()
	dprint("f_mus_m70_e06");
end

script static void f_mus_m70_e07_finish()
	dprint("f_mus_m70_e07");
end

script static void f_mus_m70_e08_finish()
	dprint("f_mus_m70_e08");
end

script static void f_mus_m70_e09_finish()
	dprint("f_mus_m70_e09");
end

script static void f_mus_m70_e10_finish()
	dprint("f_mus_m70_e10");
end

script static void f_music_m70_tweak01()
	dprint("f_music_m70_tweak01");
	music_set_state('Play_mus_m70_t01_tweak');
end

script static void f_music_m70_tweak02()
	dprint("f_music_m70_tweak02");
	music_set_state('Play_mus_m70_t02_tweak');
end

script static void f_music_m70_tweak03()
	dprint("f_music_m70_tweak03");
	music_set_state('Play_mus_m70_t03_tweak');
end

script static void f_music_m70_tweak04()
	dprint("f_music_m70_tweak04");
	music_set_state('Play_mus_m70_t04_tweak');
end

script static void f_music_m70_tweak05()
	dprint("f_music_m70_tweak05");
	music_set_state('Play_mus_m70_t05_tweak');
end

script static void f_music_m70_tweak06()
	dprint("f_music_m70_tweak06");
	music_set_state('Play_mus_m70_t06_tweak');
end

script static void f_music_m70_tweak07()
	dprint("f_music_m70_tweak07");
	music_set_state('Play_mus_m70_t07_tweak');
end

script static void f_music_m70_tweak08()
	dprint("f_music_m70_tweak08");
	music_set_state('Play_mus_m70_t08_tweak');
end

script static void f_music_m70_tweak09()
	dprint("f_music_m70_tweak09");
	music_set_state('Play_mus_m70_t09_tweak');
end

script static void f_music_m70_tweak10()
	dprint("f_music_m70_tweak10");
	music_set_state('Play_mus_m70_t10_tweak');
end

// ========================================
// Vignette music events
// ========================================
script static void f_music_m70_v08_gondola_stop()
	dprint("f_music_m70_v08_gondola_stop");
	music_set_state('Play_mus_m70_v08_gondola_stop');
end

script static void f_music_m70_v07_didact_voice_1()
	dprint("f_music_m70_v07_didact_voice_1");
	music_set_state('Play_mus_m70_v07_didact_voice_1');
end

script static void f_music_m70_v07_didact_voice_2()
	dprint("f_music_m70_v07_didact_voice_2");
	music_set_state('Play_mus_m70_v07_didact_voice_2');
end

script static void f_music_m70_v07_didact_voice_3()
	dprint("f_music_m70_v07_didact_voice_3");
	music_set_state('Play_mus_m70_v07_didact_voice_3');
end

script static void f_music_m70_v07_didact_voice_4()
	dprint("f_music_m70_v07_didact_voice_4");
	music_set_state('Play_mus_m70_v07_didact_voice_4');
end

script static void f_music_m70_v07_didact_voice_5()
	dprint("f_music_m70_v07_didact_voice_5");
	music_set_state('Play_mus_m70_v07_didact_voice_5');
end

script static void f_music_m70_v07_didact_voice_6()
	dprint("f_music_m70_v07_didact_voice_6");
	music_set_state('Play_mus_m70_v07_didact_voice_6');
end

script static void f_music_m70_v07_didact_voice_7()
	dprint("f_music_m70_v07_didact_voice_7");
	music_set_state('Play_mus_m70_v07_didact_voice_7');
end

script static void f_music_m70_v07_didact_voice_8()
	dprint("f_music_m70_v07_didact_voice_8");
	music_set_state('Play_mus_m70_v07_didact_voice_8');
end

script static void f_music_m70_v09_didact_ship()
	dprint("f_music_m70_v09_didact_ship");
	music_set_state('Play_mus_m70_v09_didact_ship');
end

// =================================================================================================
// music zoneset hooks
// =================================================================================================
// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m70_music_progression = 0;

script static void load_music_for_zone_set()
	sleep_until( b_m70_music_progression > 0 or current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY, 1 );

	music_start('Play_mus_m70');
	
	sleep_until(b_m70_music_progression > 10 or volume_test_players (tv_music_r01_00_infinity), 1);
	if b_m70_music_progression <= 10 then		
		music_set_state('Play_mus_m70_r01_00_infinity');
		sound_set_state('Set_State_M70_infinity');
	end
	
	sleep_until(b_m70_music_progression > 20 or volume_test_players (tv_music_r02_00_infinity_exterior), 1);
	if b_m70_music_progression <= 20 then				
		music_set_state('Play_mus_m70_r02_00_infinity_exterior');
		sound_set_state('Set_State_M70_infinity_exterior');
	end
		
	// spire 1 and 2 can be completed in any order
	thread (load_spire_1_music());
	thread (load_spire_2_music());
	
	// now wait until the player enters spire 3
	sleep_until(b_m70_music_progression > 70 or volume_test_players (tv_music_r09_spire_3_exterior), 1);
	if b_m70_music_progression <= 70 then		
		music_set_state('Play_mus_m70_r09_spire_3_exterior');
		sound_set_state('Set_State_M70_spire_3_exterior');
	end
	
	// RALLY POINT DELTA
	sleep_until(b_m70_music_progression > 80 or volume_test_players (tv_music_r10_spire_3_interior_a), 1);
	if b_m70_music_progression <= 80 then				
		music_set_state('Play_mus_m70_r10_spire_3_interior_a');
		sound_set_state('Set_State_M70_spire_3_interior_a');
	end
	
	sleep_until(b_m70_music_progression > 90 or volume_test_players (tv_music_r11_spire_3_interior_b), 1);
	if b_m70_music_progression <= 90 then				
		music_set_state('Play_mus_m70_r11_spire_3_interior_b');
		sound_set_state('Set_State_M70_spire_3_interior_b');
	end
	
	sleep_until(b_m70_music_progression > 100 or volume_test_players (tv_music_r12_spire_3_interior_c), 1);
	if b_m70_music_progression <= 100 then				
		music_set_state('Play_mus_m70_r12_spire_3_interior_c');
		sound_set_state('Set_State_M70_spire_3_interior_c');
	end
	
	sleep_until(b_m70_music_progression > 110 or volume_test_players (tv_music_r13_spire_3_interior_d), 1);
	if b_m70_music_progression <= 110 then				
		music_set_state('Play_mus_m70_r13_spire_3_interior_d');
		sound_set_state('Set_State_M70_spire_3_interior_d');
	end
	
	sleep_until(b_m70_music_progression > 120 or volume_test_players (tv_music_r14_spire_3_exit), 1);
	if b_m70_music_progression <= 120 then				
		music_set_state('Play_mus_m70_r14_spire_3_exit');
		sound_set_state('Set_State_M70_spire_3_exit');
	end	
	
	// chief jumping off the platform triggers the cinematic start
	sleep_until(B_lich_chief_jumped == TRUE, 1);
		music_stop('Stop_mus_m70');
end

script static void load_spire_1_music()
	// RALLY POINT BRAVO
	sleep_until(b_m70_music_progression > 30 or volume_test_players (tv_music_r03_spire_1_exterior), 1);
	if b_m70_music_progression <= 30 then	
		music_set_state('Play_mus_m70_r03_spire_1_exterior');
		sound_set_state('Set_State_M70_spire_1_exterior');
	end
	
	sleep_until(b_m70_music_progression > 40 or volume_test_players (tv_music_r04_spire_1_interior_a), 1);
	if b_m70_music_progression <= 40 then	
		music_set_state('Play_mus_m70_r04_spire_1_interior_a');
		sound_set_state('Set_State_M70_spire_1_interior_a');
	end
	
	sleep_until(volume_test_players (tv_music_r05_spire_1_interior_b), 1);
		music_set_state('Play_mus_m70_r05_spire_1_interior_b');
		sound_set_state('Set_State_M70_spire_1_interior_b');
		
	sleep_until(volume_test_players (tv_music_r15_spire_1_exit), 1);
		music_set_state('Play_mus_m70_r03_spire_1_exit');
		sound_set_state('Set_State_M70_spire_1_exit');
		
end

script static void load_spire_2_music()
	//  RALLY POINT CHARLIE
	sleep_until(b_m70_music_progression > 50 or volume_test_players (tv_music_r06_spire_2_exterior), 1);
	if b_m70_music_progression <= 50 then	
		music_set_state('Play_mus_m70_r06_spire_2_exterior');
		sound_set_state('Set_State_M70_spire_2_exterior');
	end
	
	sleep_until(b_m70_music_progression > 60 or volume_test_players (tv_music_r07_spire_2_interior_a), 1);
	if b_m70_music_progression <= 60 then		
		music_set_state('Play_mus_m70_r07_spire_2_interior_a');
		sound_set_state('Set_State_M70_spire_2_interior_a');
	end
		
	sleep_until(volume_test_players (tv_music_r08_spire_2_interior_b), 1);
		music_set_state('Play_mus_m70_r08_spire_2_interior_b');
		sound_set_state('Set_State_M70_spire_2_interior_b');
		
	sleep_until(volume_test_players (tv_music_r16_spire_2_exit), 1);
		music_set_state('Play_mus_m70_r06_spire_2_exit');
		sound_set_state('Set_State_M70_spire_2_exit');
end

