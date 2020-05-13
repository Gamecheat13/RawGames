//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_cryptum_audio
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================
global looping_sound amb_current = "";

global sound donut_camera_shake_weak = 'sound\environments\solo\m030\amb_m30_beta\amb_m30_screen_shakes\m30_donut_camera_shake_weak';
global sound donut_camera_shake_medium = 'sound\environments\solo\m030\amb_m30_beta\amb_m30_screen_shakes\m30_donut_camera_shake_medium';
global sound escape_camera_shake_weak = 'sound\environments\solo\m030\amb_m30_beta\amb_m30_screen_shakes\m30_escape_camera_shake_weak';
global sound escape_camera_shake_strong = 'sound\environments\solo\m030\amb_m30_beta\amb_m30_screen_shakes\m30_escape_camera_shake_strong';
global sound exterior_2_camera_shake = 'sound\environments\solo\m030\amb_m30_beta\amb_m30_screen_shakes\m30_exterior_2_camera_shake';

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m30_cryptum_audio()

	if b_debug then 
		print ("::: M30 - AUDIO :::");
	end

	thread (test_audio());
	thread (load_music_for_zone_set());
end

// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m30_music_progression = 0;
global long l_music_zone_set_thread_id = 0;

// This function runs in an endless loop and watches for zone set changes so it can set the approriate audio states
script static void load_music_for_zone_set()
	sleep_until(b_m30_music_progression > 0 or current_zone_set_fully_active() == zs_portal_idx, 1);
	music_start('Play_mus_m30');
	
	sleep_until(b_m30_music_progression > 10 or volume_test_players (tv_music_r01_start), 1);
	if b_m30_music_progression <= 10 then
		music_set_state('Play_mus_m30_r01_start');
		music_set_state('Play_mus_m30_r16_observationdeck_1');
		sound_set_state('Set_State_M30_Observation_Deck');
	end

	sleep_until(b_m30_music_progression > 20 or volume_test_players (tv_music_r02_caves), 1);
	if b_m30_music_progression <= 20 then
		music_set_state('Play_mus_m30_r02_caves');
		sound_set_state('Set_State_M30_Caves');
	end

	
	// RALLY POINT BRAVO
	sleep_until(b_m30_music_progression > 30 or volume_test_players (tv_music_r03_canyon), 1);
	if b_m30_music_progression <= 30 then
		music_set_state('Play_mus_m30_r03_canyon');
		sound_set_state('Set_State_M30_Canyon');
	end
	
	sleep_until(b_m30_music_progression > 40 or volume_test_players (tv_music_r04_forts), 1);
	if b_m30_music_progression <= 40 then
		l_music_zone_set_thread_id = thread (music_for_forts());
		sound_set_state('Set_State_M30_Forts1');
	end
	
	sleep_until(b_m30_music_progression > 50 or volume_test_players (tv_music_r17_observationdeck), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 50 then
		l_music_zone_set_thread_id = thread (music_for_beam1_obs_deck());
		sound_set_state('Set_State_M30_Beam1');
	end
	
	// RALLY POINT CHARLIE
	sleep_until(b_m30_music_progression > 60 or volume_test_players (tv_music_r07_start), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 60 then
		music_set_state('Play_mus_m30_r07_start');
		sound_set_state('Set_State_M30_Start2');
	end
	
	sleep_until(b_m30_music_progression > 70 or volume_test_players (tv_music_r08_canyon), 1);
	if b_m30_music_progression <= 70 then
		music_set_state('Play_mus_m30_r08_canyon');
		sound_set_state('Set_State_M30_Exterior2');
	end
	
	sleep_until(b_m30_music_progression > 80 or volume_test_players (tv_music_r09_forts), 1);
	if b_m30_music_progression <= 80 then
		l_music_zone_set_thread_id = thread (music_for_forts_2());
		sound_set_state('Set_State_M30_Forts2');
	end
	
	sleep_until(b_m30_music_progression > 90 or volume_test_players (tv_music_r18_observationdeck_3), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 90 then
		l_music_zone_set_thread_id = thread (music_for_beam2_obs_deck());
		sound_set_state('Set_State_M30_Beam2');
	end
	
	// RALLY POINT DELTA
	sleep_until(b_m30_music_progression > 100 or volume_test_players (tv_music_r12_donut), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 100 then
		l_music_zone_set_thread_id = thread (music_for_donut());
		sound_set_state('Set_State_M30_Donut');
	end

	sleep_until(b_m30_music_progression > 110 or volume_test_players (tv_music_r14_cryptum), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 110 then
		music_set_state('Play_mus_m30_r14_cryptum');
		sound_set_state('Set_State_M30_Cryptum');
	end
	
	sleep_until(b_m30_music_progression > 120 or volume_test_players (tv_music_r15_escape), 1);
	if (l_music_zone_set_thread_id != 0) then // kill old thread
	  	kill_thread (l_music_zone_set_thread_id);
	  	l_music_zone_set_thread_id = 0;
	end
	if b_m30_music_progression <= 120 then
		sound_set_state('Set_State_M30_Escape');
		music_set_state('Play_mus_m30_r15_escape');
	end
	
	sleep_until(current_zone_set_fully_active() == zs_cin_m32_idx, 1);
	music_stop('Stop_mus_m30'); 
end

script static void test_audio()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end

// REMOVE ME patridu
script static void dprint (string s)
	if b_debug then
		print (s);
	end
end

; =================================================================================================
; *** TEMP VOICE OVER ***
; =================================================================================================

script dormant voice_over_1()
	// This represents the opening cinematic dialogue. No player control. 
	sleep_until (volume_test_players (tv_vo1), 1);
	//player_disable_movement (TRUE);
	thread (placeholdercinematic());
	sleep (30);
	
	// 157 : Where did those things come from?
//	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_MC_00100', NONE, 1);
//	print ("Where did those things come from?");
//	sleep (30 * 1.244);
	// 159 : Cor-?
//	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_MC_00300', NONE, 1);
//	print ("Cor-?");
//	sleep (30 * 0.53);
	// 160 : I'm here. The portal must've... initiated a memory spike or... well, sorry.
//	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_Cortana_00400', NONE, 1);
//	print ("I'm here. The portal must've... initiated a memory spike or... well, sorry.");
//	sleep (30 * 6.347);
	// 161 : What about those creatures?
//	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_MC_00500', NONE, 1);
//	print ("What about those creatures?");
//	sleep (30 * 1.205);
	// 162 : You know as much as I do. One thing's for sure - whatever they are, they really don't like people messing with their things.
//	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_Cortana_00600', NONE, 1);
//	print ("You know as much as I do. One thing's for sure - whatever they are, they really don't like people messing with their things.");
//	sleep (30 * 5.739);
	
	/*  (EDITED around UR#2. Lots of dialogue trimmed out.)	
	
	// 163 : Hm. I jumped us to the coordinates for the Reclaimer symbol, and now I'm not getting anything from the Covenant battlenets. And by that, I mean NOTHING. There's no sign of them whatsoever.
	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_Cortana_00700', NONE, 1);
	print ("Hm. I jumped us to the coordinates for the Reclaimer symbol, and now I'm not getting anything from the Covenant battlenets. And by that, I mean NOTHING. There's no sign of them whatsoever.");
	sleep (30 * 9.301);
	// 164 : Where could they have gone?
	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_MC_00800', NONE, 1);
	print ("Where could they have gone?");
	sleep (30 * 0.89);
	// 165 : I don't think THEY went anywhere.
	sound_impulse_start ('sound\dialog\Mission\m30\M_M30_Cortana_00900', NONE, 1);
	print ("I don't think THEY went anywhere.");
	sleep (30 * 1.944);	

	*/	

	//player_disable_movement (FALSE);
end

script static void placeholdercinematic()
	cinematic_set_title (placeholder_cinematic);	
	sleep (30 * 20);
end
	
script static void pylon1_complete_text()
	// Cinematic text for when player steps out of portal from Pylon 1 and arrives in 20_start.
	cinematic_set_title (dash1);
	sleep (30 * 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	cinematic_set_title (obj_complete);
	sleep (30 * 3);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash1);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (new_obj);
	sleep (30 * 4);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (chcryptumstart2);
end

script static void pylon2_complete_text()
	cinematic_set_title (dash1);
	sleep (30 * 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	cinematic_set_title (obj_complete);
	sleep (30 * 3);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash1);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (new_obj);
	sleep (30 * 4);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (chcryptumstart3);
end
	
script static void donut_complete_text()
	cinematic_set_title (dash1);
	sleep (30 * 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	cinematic_set_title (obj_complete);
	sleep (30 * 3);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash1);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (dash2);
	sleep (30 * 1);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (new_obj);
	sleep (30 * 4);
	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	cinematic_set_title (chescape);
end


; =================================================================================================
; *** AMBIENCES ***
; =================================================================================================
; See acoustic sectors in Sapien

; =================================================================================================
; *** MIXER STATES ***
; =================================================================================================

// script states for encounters in caves
/* script static void mixer_caves_encounters()
	sleep_until (b_first_pawn_fight_started, 1); // sleep until pawn squad is placed
	sound_set_state('Set_State_  Caves_Encounter1'); // This is the pawn encounter, the first encounter in m30

	sleep_until (b_first_pawn_fight_over, 1);
	music_set_state('Set_State_M30_Caves'); // restore caves state once the fight is over

	sleep_until (b_grassy_hill_encounter_started, 1); // this is the 2nd encounter, with knights and bishops spawning on the hill
	sound_set_state('Set_State_Caves_Encounter2');
	sleep_until (b_grassy_hill_encounter_over, 1);
	
	music_set_state('Set_State_M30_Caves'); // restore caves state once the fight is over
end */

// script states for encounters in canyon
/* script static void mixer_canyon_encounters()
	sleep_until (b_ext1_final_fight_started, 1); 
	sound_set_state('Set_State_Mixer_Canyon_Encounter2');
	sleep_until (b_ext1_final_fight_over, 1);
	
	sleep_until (b_ext1_final_fight_started, 1); 
	sound_set_state('Set_State_Mixer_Canyon_Encounter2');
	sleep_until (b_ext1_final_fight_over, 1);
	
	music_set_state('Set_State_M30_Canyon'); 
end */

; =================================================================================================
; *** MUSIC ***
; =================================================================================================

// ****** COMPLEX MUSIC STATES ******
script static void music_for_forts()
	music_set_state('Play_mus_m30_r04_forts');
	sleep_until (b_forts1_has_ended == TRUE, 1);
	music_set_state('Play_mus_m30_r05_elevator');
	sleep_until (device_get_position (pylon1_elevator) >= 0.85);
	music_set_state('Play_mus_m30_r06_pylon');
end

// set state when each generator is destoyed
script static void music_forts1_destroy1()
	music_set_state('Play_mus_m30_e07a_forts_destroy_1');
end

script static void music_forts1_destroy2()
	music_set_state('Play_mus_m30_e07b_forts_destroy_2');
end

script static void music_forts1_destroy3()
	music_set_state('Play_mus_m30_e07c_forts_destroy_3');
end

script static void music_forts2_destroy1()
	music_set_state('Play_mus_m30_e13a_forts_2_destroy_1');
end

script static void music_forts2_destroy2()
	music_set_state('Play_mus_m30_e13b_forts_2_destroy_2');
end

script static void music_forts2_destroy3()
	music_set_state('Play_mus_m30_e13c_forts_2_destroy_3');
end

script static void music_for_forts_2()
	music_set_state('Play_mus_m30_r09_forts');
	sleep_until (b_forts2_has_ended == TRUE, 1);
	music_set_state('Play_mus_m30_r10_elevator');
	sleep_until (device_get_position (pylon2_elevator) >= 0.85);
	music_set_state('Play_mus_m30_r11_pylon');
end

script static void music_for_beam1_obs_deck()
	sleep_until(volume_test_players(tv_pylon_1_exit) and (portal_count == 10), 1);
	dprint("music_for_beam1_obs_deck - set state");
	music_set_state('Play_mus_m30_r17_observationdeck_2');
end

script static void music_for_beam2_obs_deck()
	sleep_until(volume_test_players(tv_pylon_2_exit) and (portal_count == 20), 1);
	dprint("music_for_beam2_obs_deck - set state");
	music_set_state('Play_mus_m30_r18_observationdeck_3');
end

script static void music_for_donut()
	music_set_state('Play_mus_m30_r12_donut');
end

script static void f_mus_m30_r19_escape_section2()
	dprint("f_mus_m30_r19_escape_section2");
	music_set_state('Play_mus_m30_r19_escape1');
end

script static void f_mus_m30_r20_escape_section3()
	dprint("f_mus_m30_r20_escape_section3");
	music_set_state('Play_mus_m30_r20_escape2');
end

script static void f_mus_m30_r21_escape_section4()
	dprint("f_mus_m30_r21_escape_section4");
	music_set_state('Play_mus_m30_r21_escape3');
end

script static void f_mus_m30_r22_escape_section5()
	dprint("f_mus_m30_r22_escape_section5");
	music_set_state('Play_mus_m30_r22_escape4');
end

// ****** START MUSIC ******
// First pawn encounter
script static void f_mus_m30_e01_start()
	dprint("f_mus_m30_e01");
	music_set_state('Play_mus_m30_e01_caves_a');
	sound_set_state('Set_State_M30_Caves_Encounter1'); 
end

// Grassy hill encounter
script static void f_mus_m30_e02_start()
	dprint("f_mus_m30_e02");
	music_set_state('Play_mus_m30_e03_caves_b');
	sound_set_state('Set_State_M30_Caves_Encounter2'); 
end

script static void f_mus_m30_e03_start()
	dprint("f_mus_m30_e03");
	music_set_state('Play_mus_m30_e05_exterior_1');
	sound_set_state('Set_State_M30_Exterior1_Encounter1'); 
end

script static void f_mus_m30_e04_start()
	dprint("f_mus_m30_e04");
	music_set_state('Play_mus_m30_e07_forts_1');
	sound_set_state('Set_State_M30_Forts1_Encounter1'); 
end

script static void f_mus_m30_e05_start()
	dprint("f_mus_m30_e05");
	music_set_state('Play_mus_m30_e09_exterior_2a');
	sound_set_state('Set_State_M30_Exterior2_Encounter1'); 
end

script static void f_mus_m30_e06_start()
	dprint("f_mus_m30_e06");
	music_set_state('Play_mus_m30_e11_exterior_2b');
	sound_set_state('Set_State_M30_Exterior2_Encounter2'); 
end

script static void f_mus_m30_e07_start()
	dprint("f_mus_m30_e07");
	music_set_state('Play_mus_m30_e13_forts_2');
	sound_set_state('Set_State_M30_Forts2_Encounter1'); 
end

script static void f_mus_m30_e08_start()
	dprint("f_mus_m30_e08");
	music_set_state('Play_mus_m30_e15_donut_a');
	sound_set_state('Set_State_M30_Donut_A_Encounter'); 
end

script static void f_mus_m30_e09_start()
	dprint("f_mus_m30_e09");
	music_set_state('Play_mus_m30_e17_donut_b_left');
	sound_set_state('Set_State_M30_Donut_B_Left_Encounter'); 
end

script static void f_mus_m30_e10_start()
	dprint("f_mus_m30_e10");
	music_set_state('Play_mus_m30_e19_donut_b_right');
	sound_set_state('Set_State_M30_Donut_B_Right_Encounter'); 
end

script static void f_mus_m30_e11_start()
	dprint("f_mus_m30_e11");
	music_set_state('Play_mus_m30_e21_donut_final');
	sound_set_state('Set_State_M30_Donut_Final_Encounter'); 
end

// not currently used since Play_mus_m30_r15_escape has just been set
script static void f_mus_m30_e12_start()
	dprint("f_mus_m30_e12");
	music_set_state('Play_mus_m30_e23_escape');
end


// ****** FINISH MUSIC ******
script static void f_mus_m30_e01_finish()
	dprint("f_mus_m30_e01");
	music_set_state('Play_mus_m30_e02_caves_a_end');
	sound_set_state('Set_State_M30_Caves');
end

script static void f_mus_m30_e02_finish()
	dprint("f_mus_m30_e02");
	music_set_state('Play_mus_m30_e04_caves_b_end');
	sound_set_state('Set_State_M30_Caves');
end

script static void f_mus_m30_e03_finish()
	dprint("f_mus_m30_e03");
	music_set_state('Play_mus_m30_e06_exterior_1_end');
	sound_set_state('Set_State_M30_Exterior1');
end

script static void f_mus_m30_e04_finish()
	dprint("f_mus_m30_e04");
	music_set_state('Play_mus_m30_e08_forts_1_end');
	sound_set_state('Set_State_M30_Forts1');
end

script static void f_mus_m30_e05_finish()
	dprint("f_mus_m30_e05");
	music_set_state('Play_mus_m30_e10_exterior_2a_end');
	sound_set_state('Set_State_M30_Exterior2');
end

script static void f_mus_m30_e06_finish()
	dprint("f_mus_m30_e06");
	music_set_state('Play_mus_m30_e12_exterior_2b_end');
	sound_set_state('Set_State_M30_Exterior2');
end

script static void f_mus_m30_e07_finish()
	dprint("f_mus_m30_e07");
	music_set_state('Play_mus_m30_e14_forts_2_end');
	sound_set_state('Set_State_M30_Forts2');
end

script static void f_mus_m30_e08_finish()
	dprint("f_mus_m30_e08");
	music_set_state('Play_mus_m30_e16_donut_a_end');
	sound_set_state('Set_State_M30_Donut');
end

script static void f_mus_m30_e09_finish()
	dprint("f_mus_m30_e09");
	music_set_state('Play_mus_m30_e18_donut_b_left_end');
	sound_set_state('Set_State_M30_Donut');
end

script static void f_mus_m30_e10_finish()
	dprint("f_mus_m30_e10");
	music_set_state('Play_mus_m30_e20_donut_b_right_end');
	sound_set_state('Set_State_M30_Donut');
end

script static void f_mus_m30_e11_finish()
	dprint("f_mus_m30_e11");
	music_set_state('Play_mus_m30_e22_donut_final_end');
	sound_set_state('Set_State_M30_Donut');
end

script static void f_mus_m30_e12_finish()
	dprint("f_mus_m30_e12");
	music_set_state('Play_mus_m30_e24_escape_end');
end

// ****** MUSIC TWEAKS ******
script static void f_music_m30_tweak01()
	dprint("f_music_m30_tweak01");
	music_set_state('Play_mus_m30_t01_tweak');
end

script static void f_music_m30_tweak02()
	dprint("f_music_m30_tweak02");
	music_set_state('Play_mus_m30_t02_tweak');
end

script static void f_music_m30_tweak03()
	dprint("f_music_m30_tweak03");
	music_set_state('Play_mus_m30_t03_tweak');
end

script static void f_music_m30_tweak04()
	dprint("f_music_m30_tweak04");
	music_set_state('Play_mus_m30_t04_tweak');
end

script static void f_music_m30_tweak05()
	dprint("f_music_m30_tweak05");
	music_set_state('Play_mus_m30_t05_tweak');
end

script static void f_music_m30_tweak06()
	dprint("f_music_m30_tweak06");
	music_set_state('Play_mus_m30_t06_tweak');
end

script static void f_music_m30_tweak07()
	dprint("f_music_m30_tweak07");
	music_set_state('Play_mus_m30_t07_tweak');
end

script static void f_music_m30_tweak08()
	dprint("f_music_m30_tweak08");
	music_set_state('Play_mus_m30_t08_tweak');
end

script static void f_music_m30_tweak09()
	dprint("f_music_m30_tweak09");
	music_set_state('Play_mus_m30_t09_tweak');
end

script static void f_music_m30_tweak10()
	dprint("f_music_m30_tweak10");
	music_set_state('Play_mus_m30_t10_tweak');
end
