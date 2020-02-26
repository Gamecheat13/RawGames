//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m40_invasion_audio
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global sound mammoth_camera_shake_long = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_mammoth_camera_shake_long';
global sound epic_missile_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_epic_missile_camera_shake';
global sound library_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_library_camera_shake';
global sound mammoth_camera_shake_short = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_mammoth_camera_shake_short';
global sound lich_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_lich_camera_shake';
global sound rock_crush_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_rock_crush_camera_shake';
global sound lich_explode_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_lich_explode_camera_shake';
global sound powercave_door_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_powercave_door_camera_shake';
global sound battery_airlock_camera_shake = 'sound\environments\solo\m040\new_m40_tags\amb_m40_screen_shakes\m40_battery_airlock_camera_shake';

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m40_invasion_audio()

	if b_debug then 
		print ("::: M40 - AUDIO :::");
	end
	
	thread(test_audio());

	thread (load_music_for_zone_set());
end

script static void test_audio()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end

; =================================================================================================
; *** MUSIC STUBS ***
; =================================================================================================
script static void f_mus_m40_e01_begin()
	//dprint("f_mus_m40_e01");
	music_set_state('Play_mus_m40_e01_cannon_fobber');
end

script static void f_mus_m40_e02_begin()
	//dprint("f_mus_m40_e02");
	music_set_state('Play_mus_m40_e03_lakeside');
end

script static void f_mus_m40_e03_begin()
	//dprint("f_mus_m40_e03");
	music_set_state('Play_mus_m40_e05_cliffside');
end

script static void f_mus_m40_e04_begin()
	//dprint("f_mus_m40_e04");
	music_set_state('Play_mus_m40_e07_pre_chopper');
end

script static void f_mus_m40_e05_begin()
	//dprint("f_mus_m40_e05");
	music_set_state('Play_mus_m40_e09_chopper_bowl');
end

script static void f_mus_m40_e06_begin()
	//dprint("f_mus_m40_e06");
	music_set_state('Play_mus_m40_e11_sniper_alley');
end

script static void f_mus_m40_e07_begin()
	//dprint("f_mus_m40_e07");
	music_set_state('Play_mus_m40_e13_citadel_ext');
end

script static void f_mus_m40_e08_begin()
	//dprint("f_mus_m40_e08");
	music_set_state('Play_mus_m40_e15_librarian_room');
end

script static void f_mus_m40_e09_begin()
	//dprint("f_mus_m40_e09");
	music_set_state('Play_mus_m40_e17_epic_bowl');
end

//script static void f_mus_m40_e10_begin()
	// dprint("f_mus_m40_e10");
//end

//script static void f_mus_m40_e11_begin()
	//dprint("f_mus_m40_e11");
//end

//script static void f_mus_m40_e12_begin()
	//dprint("f_mus_m40_e12");
//end

//script static void f_mus_m40_e13_begin()
	//dprint("f_mus_m40_e13");
//end

//script static void f_mus_m40_e14_begin()
	//dprint("f_mus_m40_e14");
//end

//script static void f_mus_m40_e15_begin()
	//dprint("f_mus_m40_e15");
//end

//script static void f_mus_m40_e16_begin()
	//dprint("f_mus_m40_e16");
//end

//script static void f_mus_m40_e17_begin()
	//dprint("f_mus_m40_e17");
//end

//script static void f_mus_m40_e18_begin()
	//dprint("f_mus_m40_e18");
//end

script static void f_mus_m40_e01_finish()
	//dprint("f_mus_m40_e01");
	music_set_state('Play_mus_m40_e02_cannon_fobber_end');
end

script static void f_mus_m40_e02_finish()
	//dprint("f_mus_m40_e02");
	music_set_state('Play_mus_m40_e04_lakeside_end');
end

script static void f_mus_m40_e03_finish()
	//dprint("f_mus_m40_e03");
	music_set_state('Play_mus_m40_e06_cliffside_end');
end

script static void f_mus_m40_e04_finish()
	//dprint("f_mus_m40_e04");
	music_set_state('Play_mus_m40_e08_pre_chopper_end');
end

script static void f_mus_m40_e05_finish()
	//dprint("f_mus_m40_e05");
	music_set_state('Play_mus_m40_e10_chopper_bowl_end');
end

script static void f_mus_m40_e06_finish()
	//dprint("f_mus_m40_e06");
	music_set_state('Play_mus_m40_e12_sniper_alley_end');
end

script static void f_mus_m40_e07_finish()
	//dprint("f_mus_m40_e07");
	music_set_state('Play_mus_m40_e14_citadel_ext_end');
end

script static void f_mus_m40_e08_finish()
	//dprint("f_mus_m40_e08");
	music_set_state('Play_mus_m40_e16_librarian_room_end');
end

script static void f_mus_m40_e09_finish()
	//dprint("f_mus_m40_e09");
	music_set_state('Play_mus_m40_e18_epic_bowl_end');
end

//script static void f_mus_m40_e10_finish()
	//dprint("f_mus_m40_e10");
//end

//script static void f_mus_m40_e11_finish()
	//dprint("f_mus_m40_e11");
//end

//script static void f_mus_m40_e12_finish()
	//dprint("f_mus_m40_e12");
//end

//script static void f_mus_m40_e13_finish()
	//dprint("f_mus_m40_e13");
//end

//script static void f_mus_m40_e14_finish()
	//dprint("f_mus_m40_e14");
//end

//script static void f_mus_m40_e15_finish()
	//dprint("f_mus_m40_e15");
//end

//script static void f_mus_m40_e16_finish()
	//dprint("f_mus_m40_e16");
//end

//script static void f_mus_m40_e17_finish()
	//dprint("f_mus_m40_e17");
//end

//script static void f_mus_m40_e18_finish()
	//dprint("f_mus_m40_e18");
//end

script static void f_music_m40_tweak01()
	//dprint("f_music_m40_tweak01");
	music_set_state('Play_mus_m40_t01_tweak');
end

script static void f_music_m40_tweak02()
	//dprint("f_music_m40_tweak02");
	music_set_state('Play_mus_m40_t02_tweak');
end

script static void f_music_m40_tweak03()
	//dprint("f_music_m40_tweak03");
	music_set_state('Play_mus_m40_t03_tweak');
end

script static void f_music_m40_tweak04()
	//dprint("f_music_m40_tweak04");
	music_set_state('Play_mus_m40_t04_tweak');
end

script static void f_music_m40_tweak05()
	//dprint("f_music_m40_tweak05");
	music_set_state('Play_mus_m40_t05_tweak');
end

script static void f_music_m40_tweak06()
	//dprint("f_music_m40_tweak06");
	music_set_state('Play_mus_m40_t06_tweak');
end

script static void f_music_m40_tweak07()
	//dprint("f_music_m40_tweak07");
	music_set_state('Play_mus_m40_t07_tweak');
end

script static void f_music_m40_tweak08()
	//dprint("f_music_m40_tweak08");
	music_set_state('Play_mus_m40_t08_tweak');
end

script static void f_music_m40_tweak09()
	//dprint("f_music_m40_tweak09");
	music_set_state('Play_mus_m40_t09_tweak');
end

script static void f_music_m40_tweak10()
	//dprint("f_music_m40_tweak10");
	music_set_state('Play_mus_m40_t10_tweak');
end


script static void f_music_m40_v13_mammoth_start()
	music_set_state('Play_mus_m40_v13_mammoth_start');
end

// ==================== Region-based music triggers ============================
// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m40_music_progression = 0;

script static void load_music_for_zone_set()
	sleep_until(b_m40_music_progression > 0 or current_zone_set_fully_active() == DEF_S_ZONESET_CAV(), 1);
		
	music_start('Play_mus_m40');

	sleep_until(b_m40_music_progression > 10 or volume_test_players (tv_music_r01_cave), 1);
	if b_m40_music_progression <= 10 then	
		sound_set_state('Set_State_M40_cav');
		music_set_state('Play_mus_m40_r01_cav');
	end
		
	sleep_until(b_m40_music_progression > 20 or volume_test_players (tv_music_r02_cav_tort_gun), 1);
	if b_m40_music_progression <= 20 then
		sound_set_state('Set_State_M40_cav_tort_gun');
		music_set_state('Play_mus_m40_r02_cav_tort_gun');
	end
	
	sleep_until(b_m40_music_progression > 30 or volume_test_players (tv_music_r03_gun_fodder), 1);
	if b_m40_music_progression <= 30 then
		sound_set_state('Set_State_M40_gun_fodder');
		music_set_state('Play_mus_m40_r03_gun_fodder');
	end
	
	sleep_until(b_m40_music_progression > 40 or volume_test_players (tv_music_r05_fodder_chopper), 1);
	if b_m40_music_progression <= 40 then		
		sound_set_state('Set_State_M40_fodder_chopper');
		music_set_state('Play_mus_m40_r05_fodder_chopper');
	end
	
	sleep_until(b_m40_music_progression > 50 or volume_test_players (tv_music_r22_pre_chop_water), 1);
	if b_m40_music_progression <= 50 then
		sound_set_state('Set_State_M40_pre_chop_water');
		music_set_state('Play_mus_m40_r22_pre_chop_water');
	end
	
	sleep_until(b_m40_music_progression > 60 or volume_test_players (tv_music_r06_chopper_waterfall_pre), 1);
	if b_m40_music_progression <= 60 then
		sound_set_state('Set_State_M40_chopper_waterfall_pre');
		music_set_state('Play_mus_m40_r06_chopper_waterfall_pre');
	end
	
	sleep_until(b_m40_music_progression > 70 or volume_test_players (tv_music_r07_waterfall_pre_vale), 1);
	if b_m40_music_progression <= 70 then
		sound_set_state('Set_State_M40_waterfall_pre_vale');
		music_set_state('Play_mus_m40_r07_waterfall_pre_vale');
	end
	
	sleep_until(b_m40_music_progression > 80 or volume_test_players (tv_music_r08_pre_vale), 1);
	if b_m40_music_progression <= 80 then
		sound_set_state('Set_State_M40_pre_vale');
		music_set_state('Play_mus_m40_r08_pre_vale');
	end
	
	sleep_until(b_m40_music_progression > 90 or volume_test_players (tv_music_r09_vale_vale), 1);
	if b_m40_music_progression <= 90 then
		sound_set_state('Set_State_M40_vale_vale');
		music_set_state('Play_mus_m40_r09_vale_vale');
	end
	
	sleep_until(b_m40_music_progression > 100 or volume_test_players (tv_music_r12_battery), 1);
	if b_m40_music_progression <= 100 then
		sound_set_state('Set_State_M40_battery');
		music_set_state('Play_mus_m40_r12_battery');
	end
	
	sleep_until(b_m40_music_progression > 110 or volume_test_players (tv_music_r13_battery_cavern), 1);
	if b_m40_music_progression <= 110 then
		sound_set_state('Set_State_M40_battery_cavern');
		music_set_state('Play_mus_m40_r13_battery_cavern');
	end
	
	sleep_until(b_m40_music_progression > 120 or volume_test_players (tv_music_r14_cavern_librarian_vale), 1);
	if b_m40_music_progression <= 120 then
		sound_set_state('Set_State_M40_cavern_librarian_vale');
		music_set_state('Play_mus_m40_r14_cavern_librarian_vale');
	end
	
	sleep_until(b_m40_music_progression > 130 or volume_test_players (tv_music_r24_ele_epic), 1);
	if b_m40_music_progression <= 130 then
		sound_set_state('Set_State_M40_ele_epic');
		music_set_state('Play_mus_m40_r24_ele_epic');
	end
	
	sleep_until(b_m40_music_progression > 140 or volume_test_players (tv_music_r19_epic), 1);
	if b_m40_music_progression <= 140 then
		sound_set_state('Set_State_M40_epic');
		music_set_state('Play_mus_m40_r19_epic');
	end
	
	sleep_until(b_m40_music_progression > 150 or volume_test_players (tv_music_r20_epic_exit), 1);
	if b_m40_music_progression <= 150 then
		sound_set_state('Set_State_M40_epic_exit');
		music_set_state('Play_mus_m40_r20_epic_exit');
	end
	
	sleep_until(current_zone_set_fully_active() == DEF_S_ZONESET_CIN_M042_END(), 1);
		music_stop('Stop_mus_m40');
end

; =================================================================================================
; *** MUSIC ***
; =================================================================================================
script dormant f_music()
	dprint ("::: M40 - f_music :::");
	
	sleep_until (LevelEventStatus("Music Drama A Start"), 1);
	dprint ("Started M40 Music - Drama A");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_drama_a', NONE, 1);
	
	sleep_until (LevelEventStatus("Music Battle A Start"), 1);
	dprint ("Stopped M40 Music - Drama A");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_drama_a');
	dprint ("Started M40 Music - Battle A");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_battle_a', NONE, 1);
	
	sleep_until (LevelEventStatus("Music Battle A Stop"), 1);
	dprint ("Stopped M40 Music - Battle A");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_battle_a');
	
	sleep_until (LevelEventStatus("Music Battle A (Part 2) Start"), 1);
	dprint ("Stopped M40 Music - Battle A");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_battle_a', NONE, 1);
	
	sleep_until (LevelEventStatus("Music Battle B Start"), 1);
	dprint ("Stopped M40 Music - Battle A");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_battle_a');
	dprint ("Started M40 Music - Battle B");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_battle_b', NONE, 1);
	
	sleep_until (LevelEventStatus("Music Battle B Stop"), 1);
	dprint ("Stopped M40 Music - Battle B");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_battle_b');
end

script static void f_music_m40_drama_a_start()
	dprint ("Started M40 Music - Drama A");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_drama_a', NONE, 1);
	f_music_m40_battle_a_stop();
	f_music_m40_battle_b_stop();
end

script static void f_music_m40_drama_a_stop()
	dprint ("Stopped M40 Music - Drama A");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_drama_a');
end

script static void f_music_m40_battle_a_start()
	dprint ("Started M40 Music - Battle A");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_battle_a', NONE, 1);
	f_music_m40_drama_a_stop();
	f_music_m40_battle_b_stop();
end

script static void f_music_m40_battle_a_stop()
	dprint ("Stopped M40 Music - Battle A");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_battle_a');
end

script static void f_music_m40_battle_b_start()
	dprint ("Started M40 Music - Battle B");
	sound_looping_start ('sound\environments\solo\m040\music\m40_music_battle_b', NONE, 1);
	f_music_m40_drama_a_stop();
	f_music_m40_battle_a_stop();
end

script static void f_music_m40_battle_b_stop()
	dprint ("Stopped M40 Music - Battle B");
	sound_looping_stop ('sound\environments\solo\m040\music\m40_music_battle_b');
end

; =================================================================================================
; *** AMBIENCES ***
; =================================================================================================
script static void f_trigger_ambience(trigger_volume tv, looping_sound amb_tag, string debug_text)
	sleep_until(volume_test_players(tv), 1);
	sound_looping_start(amb_tag, NONE, 1.0);
	sleep_until(volume_test_players(tv) == 0, 1);
	sound_looping_stop(amb_tag);
end

