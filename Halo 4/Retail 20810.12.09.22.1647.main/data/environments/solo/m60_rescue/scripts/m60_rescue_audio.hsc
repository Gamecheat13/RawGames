//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m60_rescue_audio
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

global sound phantom_camera_shake = 'sound\environments\solo\m060\amb_m60_final\amb_m60_screen_shakes\m60_phantom_camera_shake';

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m60_rescue_audio()

	if b_debug then 
		print ("::: M60 - AUDIO :::");
	end
	
	thread(test_audio());
	
	wake(f_music);

end

script static void test_audio()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
end

; =================================================================================================
; *** MUSIC ***
; =================================================================================================

; =================================================================================================
; ENCOUNTERS - MUSIC
; =================================================================================================
script static void f_mus_m60_e01_begin()
	dprint("f_mus_m60_e01");
	music_set_state('Play_mus_m60_e01_trails_1');
end

script static void f_mus_m60_e02_begin()
	dprint("f_mus_m60_e02");
	music_set_state('Play_mus_m60_e03_trails_2');
end

script static void f_mus_m60_e03_begin()
	dprint("f_mus_m60_e03");
	music_set_state('Play_mus_m60_e05_trails_3');
end

script static void f_mus_m60_e04_begin()
	dprint("f_mus_m60_e04");
	music_set_state('Play_mus_m60_e07_boulders');
end

script static void f_mus_m60_e05_begin()
	dprint("f_mus_m60_e05");
	music_set_state('Play_mus_m60_e09_cave');
end

script static void f_mus_m60_e06_begin()
	dprint("f_mus_m60_e06");
	music_set_state('Play_mus_m60_e11_rally');
end

script static void f_mus_m60_e07_begin()
	dprint("f_mus_m60_e07");
	music_set_state('Play_mus_m60_e13_infinity_mech_run');
end

script static void f_mus_m60_e08_begin()
	dprint("f_mus_m60_e08");
	music_set_state('Play_mus_m60_e15_outer_deck');
end

script static void f_mus_m60_e09_begin()
	dprint("f_mus_m60_e09");
end

script static void f_mus_m60_e10_begin()
	dprint("f_mus_m60_e10");
end

script static void f_mus_m60_e11_begin()
	dprint("f_mus_m60_e11");
end

script static void f_mus_m60_e12_begin()
	dprint("f_mus_m60_e12");
end

script static void f_mus_m60_e13_begin()
	dprint("f_mus_m60_e13");
end

script static void f_mus_m60_e14_begin()
	dprint("f_mus_m60_e14");
end

script static void f_mus_m60_e15_begin()
	dprint("f_mus_m60_e15");
end

script static void f_mus_m60_e16_begin()
	dprint("f_mus_m60_e16");
end

script static void f_mus_m60_e01_finish()
	dprint("f_mus_m60_e01");
	music_set_state('Play_mus_m60_e02_trails_1_end');
end

script static void f_mus_m60_e02_finish()
	dprint("f_mus_m60_e02");
	music_set_state('Play_mus_m60_e04_trails_2_end');
end

script static void f_mus_m60_e03_finish()
	dprint("f_mus_m60_e03");
	music_set_state('Play_mus_m60_e06_trails_3_end');
end

script static void f_mus_m60_e04_finish()
	dprint("f_mus_m60_e04");
	music_set_state('Play_mus_m60_e08_boulders_end');
end

script static void f_mus_m60_e05_finish()
	dprint("f_mus_m60_e05");
	music_set_state('Play_mus_m60_e10_cave_end');
end

script static void f_mus_m60_e06_finish()
	dprint("f_mus_m60_e06");
	music_set_state('Play_mus_m60_e12_rally_end');
end

script static void f_mus_m60_e07_finish()
	dprint("f_mus_m60_e07");
	music_set_state('Play_mus_m60_e14_infinity_mech_run_end');
end

script static void f_mus_m60_e08_finish()
	dprint("f_mus_m60_e08");
	music_set_state('Play_mus_m60_e16_outer_deck_end');
end

script static void f_mus_m60_e09_finish()
	dprint("f_mus_m60_e09");
end

script static void f_mus_m60_e10_finish()
	dprint("f_mus_m60_e10");
end

script static void f_mus_m60_e11_finish()
	dprint("f_mus_m60_e11");
end

script static void f_mus_m60_e12_finish()
	dprint("f_mus_m60_e12");
end

script static void f_mus_m60_e13_finish()
	dprint("f_mus_m60_e13");
end

script static void f_mus_m60_e14_finish()
	dprint("f_mus_m60_e14");
end

script static void f_mus_m60_e15_finish()
	dprint("f_mus_m60_e15");
end

script static void f_mus_m60_e16_finish()
	dprint("f_mus_m60_e16");
end

script static void f_music_m60_tweak01()
	dprint("f_music_m60_tweak01");
	music_set_state('Play_mus_m60_t01_tweak');
end

script static void f_music_m60_tweak02()
	dprint("f_music_m60_tweak02");
	music_set_state('Play_mus_m60_t02_tweak');
end

script static void f_music_m60_tweak03()
	dprint("f_music_m60_tweak03");
	music_set_state('Play_mus_m60_t03_tweak');
end

script static void f_music_m60_tweak04()
	dprint("f_music_m60_tweak04");
	music_set_state('Play_mus_m60_t04_tweak');
end

script static void f_music_m60_tweak05()
	dprint("f_music_m60_tweak05");
	music_set_state('Play_mus_m60_t05_tweak');
end

script static void f_music_m60_tweak06()
	dprint("f_music_m60_tweak06");
	music_set_state('Play_mus_m60_t06_tweak');
end

script static void f_music_m60_tweak07()
	dprint("f_music_m60_tweak07");
	music_set_state('Play_mus_m60_t07_tweak');
end

script static void f_music_m60_tweak08()
	dprint("f_music_m60_tweak08");
	music_set_state('Play_mus_m60_t08_tweak');
end

script static void f_music_m60_tweak09()
	dprint("f_music_m60_tweak09");
	music_set_state('Play_mus_m60_t09_tweak');
end

script static void f_music_m60_tweak10()
	dprint("f_music_m60_tweak10");
	music_set_state('Play_mus_m60_t10_tweak');
end

//====================================================
// MUSIC HOOKS - ZONE SETS
//====================================================
// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m60_music_progression = 0;

script static void load_music_for_zone_set()

	// wait for first zoneset after the cinematic to load
	sleep_until(b_m60_music_progression > 0 or current_zone_set_fully_active() == zs_peak, 1);
	
	music_start('Play_mus_m60');

	sleep_until(b_m60_music_progression > 10 or volume_test_players (tv_music_r01_peak), 1);
	if b_m60_music_progression <= 10 then		
		sound_set_state('Set_State_M60_peak');
		music_set_state('Play_mus_m60_r01_peak');	
	end
	
	sleep_until(b_m60_music_progression > 20 or volume_test_players (tv_music_r18_trail_a), 1);
	if b_m60_music_progression <= 20 then			
		sound_set_state('Set_State_M60_trail_a');
		music_set_state('Play_mus_m60_r18_trail_a');
	end
	
	sleep_until(b_m60_music_progression > 30 or volume_test_players (tv_music_r02_trail), 1);
	if b_m60_music_progression <= 30 then			
		sound_set_state('Set_State_M60_trail');
		music_set_state('Play_mus_m60_r02_trail');
	end
	
	sleep_until(b_m60_music_progression > 40 or volume_test_players (tv_music_r20_trail_c), 1);
	if b_m60_music_progression <= 40 then			
		sound_set_state('Set_State_M60_trail_c');
		music_set_state('Play_mus_m60_r20_trail_c');
	end
	
	// RALLY POINT BRAVO
	sleep_until(b_m60_music_progression > 50 or volume_test_players (tv_music_r03_trail_boulders), 1);
	if b_m60_music_progression <= 50 then			
		music_set_state('Play_mus_m60_r03_trail_boulders');
		sound_set_state('Set_State_M60_trail_boulders');
	end
	
	sleep_until(b_m60_music_progression > 60 or volume_test_players (tv_music_r04_boulders), 1);
	if b_m60_music_progression <= 60 then	
		music_set_state('Play_mus_m60_r04_boulders');
		sound_set_state('Set_State_M60_boulders');
	end
	
	// tv_music_m60_cave_in is already at a good place
	// sleep_until(volume_test_players (tv_music_r05_boulders_caves), 1);
	//	music_set_state('Play_mus_m60_r05_boulders_caves');

	sleep_until(b_m60_music_progression > 70 or volume_test_players (tv_music_r06_caves), 1);
	if b_m60_music_progression <= 70 then		
		music_set_state('Play_mus_m60_r06_caves');
		sound_set_state('Set_State_M60_caves');
	end
	
	// RALLY POINT CHARLIE
	sleep_until(b_m60_music_progression > 80 or volume_test_players (tv_music_r07_caves_rally), 1);
	if b_m60_music_progression <= 80 then			
		music_set_state('Play_mus_m60_r07_caves_rally');
		sound_set_state('Set_State_M60_caves_rally');
	end
	
	sleep_until(b_m60_music_progression > 90 or volume_test_players (tv_music_r08_rally_point), 1);
	if b_m60_music_progression <= 90 then			
		music_set_state('Play_mus_m60_r08_rally_point');
		sound_set_state('Set_State_M60_rally_point');
	end
	
	sleep_until(b_m60_music_progression > 100 or volume_test_players (tv_music_r09_rally_point_infinity_berth), 1);
	if b_m60_music_progression <= 100 then			
		music_set_state('Play_mus_m60_r09_rally_point_infinity_berth');
		sound_set_state('Set_State_M60_to_infinity_berth');
	end
	
	sleep_until(b_m60_music_progression > 110 or volume_test_players (tv_music_r10_infinity_berth), 1);
	if b_m60_music_progression <= 110 then			
		music_set_state('Play_mus_m60_r10_infinity_berth');
		sound_set_state('Set_State_M60_infinity_berth');
	end
	
	sleep_until(b_m60_music_progression > 120 or volume_test_players (tv_music_r11_infinity_berth_infinity_causeway), 1);
	if b_m60_music_progression <= 120 then			
		music_set_state('Play_mus_m60_r11_infinity_berth_infinity_causeway');
		sound_set_state('Set_State_M60_to_infinity_causeway');
	end
	
	sleep_until(b_m60_music_progression > 130 or volume_test_players (tv_music_r12_infinity_causeway), 1);
	if b_m60_music_progression <= 130 then			
		music_set_state('Play_mus_m60_r12_infinity_causeway');
		sound_set_state('Set_State_M60_infinity_causeway');
	end
		
	sleep_until(b_m60_music_progression > 140 or volume_test_players (tv_music_r13_infinity_causeway_facilities_elevator), 1);
	if b_m60_music_progression <= 140 then			
		music_set_state('Play_mus_m60_r13_infinity_causeway_facilities_elevator');
		sound_set_state('Set_State_M60_to_facilities_elevator');
	end
	
	sleep_until(b_m60_music_progression > 150 or volume_test_players (tv_music_r14_facilities_elevator), 1);
	if b_m60_music_progression <= 150 then	
		music_set_state('Play_mus_m60_r14_facilities_elevator');
		sound_set_state('Set_State_M60_facilities_elevator');
	end
	
	sleep_until(b_m60_music_progression > 160 or volume_test_players (tv_music_r15_facilities_elevator_infinity_outer_deck), 1);
	if b_m60_music_progression <= 160 then					
		music_set_state('Play_mus_m60_r15_facilities_elevator_infinity_outer_deck');
		sound_set_state('Set_State_M60_infinity_outer_deck');
	end
	
	// wait for end cinematic to start
	sleep_until(current_zone_set_fully_active() == zs_cin_m065, 1);
		music_stop('Stop_mus_m60');
end

script dormant f_music()
	if b_debug then
		print ("::: M60 - f_music :::");
	end
	
	sleep_until (current_zone_set_fully_active() == zs_peak, 1);
	// Wwise isn't ready when the zoneset is, wait a second
	// Terry will fix this bug soon
	sleep(30 * 1);
	thread (load_music_for_zone_set());
	
	wake (f_m60_music_first_structure);
end

script dormant f_m60_music_first_structure()
	sleep_until (volume_test_players (tv_music_m60_structure), 1);
	thread (f_m60_music_nothing()); // end swamp01 music
	
	wake (f_m60_music_cave_entrance);
end

script dormant f_m60_music_cave_entrance()
	sleep_until (volume_test_players (tv_music_m60_cave_in), 1);
	thread (f_m60_music_tunnel());
	
	wake (f_m60_music_cave_exit);
end

script dormant f_m60_music_cave_exit()
	sleep_until (volume_test_players (tv_music_m60_cave_out), 1);
	thread (f_m60_music_nothing()); // end tunnel music
end

script dormant f_m60_music_tank_start()
	sleep_until (player_in_vehicle (ve_rally_scorpion), 1);
	thread (f_m60_music_tank());
	// tank music fades out in inf_berth
	
	wake (f_m60_music_mechsuit);
end

script dormant f_m60_music_mechsuit()
	sleep_until (device_get_position (mech_switch) != 0);
	
	thread (f_m60_music_mech());
	// mech music fades out in teleport_elevator
end

script static void f_m60_music_start()
	sound_looping_start("sound\environments\solo\m060\music\m_m60_music", NONE, 1.0);
end

script static void f_m60_music_stop()
	sound_looping_stop("sound\environments\solo\m060\music\m_m60_music");
end

script static void f_m60_music_nothing()
	dprint("m60_music - nothing");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf00_nothing", NONE, 1.0);
end

script static void f_m60_music_beginning()
	dprint("m60_music - beginning");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf01_beginning", NONE, 1.0);
end

script static void f_m60_music_swamp01()
	dprint("m60_music - swamp01");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf02_swamp01", NONE, 1.0);
end

script static void f_m60_music_swamp02()
	dprint("m60_music - swamp02");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf04_swamp02", NONE, 1.0);
end

script static void f_m60_music_swamp03()
	dprint("m60_music - swamp03");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf05_swamp03", NONE, 1.0);
end

script static void f_m60_music_tunnel()
	dprint("m60_music - tunnel");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf06_tunnel", NONE, 1.0);
end

script static void f_m60_music_swamp04()
	dprint("m60_music - swamp04");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf07_swamp04", NONE, 1.0);
end

script static void f_m60_music_tank()
	dprint("m60_music - tank");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf08_tank", NONE, 1.0);
end

script static void f_m60_music_mech()
	dprint("m60_music - mech");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf09_mech", NONE, 1.0);
end

// see deckdoor() in m60_rescue_mission.hsc
// ends in mac_fire() in m60_rescue_mission.hsc
script static void f_m60_music_deck()
	dprint("m60_music - deck");
	sound_impulse_start("sound\environments\solo\m060\music\events\m_m60_music_pf10_deck", NONE, 1.0);
end

; =================================================================================================
; *** AMBIENCES ***
; =================================================================================================
script static void f_trigger_ambience(trigger_volume tv, looping_sound amb_tag, string debug_text)
	sleep_until(volume_test_players(tv), 1);
	dprint(debug_text);
	sound_looping_start(amb_tag, NONE, 1.0);
	sleep_until(volume_test_players(tv) == 0, 1);
	sound_looping_stop(amb_tag);
end

// tv_amb_m60_peak																		amb_m60_area_1_01
// tv_amb_m60_peak_bridge 														amb_m60_area_2
// tv_amb_m60_peak_a_ship 														3
// tv_amb_m60_trail_a																	4
// tv_amb_m60_trail_a_2																5_a
// tv_amb_m60_trail_b																	5_b

// tv_amb_m60_trail_b_cliff 													6
// tv_amb_m60_trail_c_bog															7
// tv_amb_m60_trail_c_hills														8
// tv_amb_m60_trail_c_rocky 													9
// tv_amb_m60_trail_c_stairs 			 										10
// tv_amb_m60_trail_c_stairs_ledge 										11
// tv_amb_m60_trail_c_fort														12
// tv_amb_m60_trail_c_ship														13
// tv_amb_m60_trail_c_treefort_entrance 							14
// tv_amb_m60_trail_c_treefort												15
// tv_amb_m60_trail_c_treefort_exit										16
// tv_amb_m60_boulders_hideaway												17
// tv_amb_m60_boulders_entrance												18
// tv_amb_m60_caves_entrance													19
// tv_amb_m60_caves																		20
// tv_amb_m60_tunnel_to_bog														21_a
// tv_amb_m60_stairs_to_bog														21_b
// tv_amb_m60_bog_path																22
// tv_amb_m60_bog_fort																23
// tv_amb_m60_bog_1																		24
// tv_amb_m60_bog_2																		25
// tv_amb_m60_rally_point_1														26
// tv_amb_m60_rally_point_2														27
// tv_amb_m60_rally_point_3														28
// tv_amb_m60_rally_point_4														29
// tv_amb_m60_infinity_vehicle_bay										30
// tv_amb_m60_infinity_entrance_middle_room						31
// tv_amb_m60_infinity_hanger													32
// tv_amb_m60_infinity_air_lock												33
// tv_amb_m60_infinity_causeway												34
// tv_amb_m60_infinity_causeway_hangar								35
// tv_amb_m60_infinity_causeway_hallway_to_elevator		36
// tv_amb_m60_infinity_elevator												37
// tv_amb_m60_infinity_room_to_outer_deck							38
// tv_amb_m60_infinity_outer_deck_upper								39
// tv_amb_m60_infinity_outer_deck_lower 							40

script continuous f_amb_m60_peak()
  f_trigger_ambience(tv_amb_m60_peak, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_1_01", 
  	"tv_amb_m60_peak - amb_m60_area_1_01");
end

script continuous f_amb_m60_peak_bridge()
  f_trigger_ambience(tv_amb_m60_peak_bridge, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_2", 
  	"tv_amb_m60_peak - amb_m60_area_2");
end

script continuous f_amb_m60_peak_a_ship()
  f_trigger_ambience(tv_amb_m60_peak_a_ship, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_3", 
  	"tv_amb_m60_peak_a_ship - amb_m60_area_3");
end

script continuous f_amb_m60_trail_a()
  f_trigger_ambience(tv_amb_m60_trail_a, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_4", 
  	"tv_amb_m60_trail_a - amb_m60_area_4");
end

script continuous f_amb_m60_trail_a_2()
  f_trigger_ambience(tv_amb_m60_trail_a_2, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_5a", 
  	"tv_amb_m60_trail_a_2 - amb_m60_area_5a");
end

script continuous f_amb_m60_trail_b()
  f_trigger_ambience(tv_amb_m60_trail_b, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_5b", 
  	"tv_amb_m60_trail_b - amb_m60_area_5b");
end

script continuous f_amb_m60_trail_b_cliff()
  f_trigger_ambience(tv_amb_m60_trail_b_cliff, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_6", 
  	"tv_amb_m60_trail_b - amb_m60_area_6");
end

script continuous f_amb_m60_trail_c_bog()
  f_trigger_ambience(tv_amb_m60_trail_c_bog, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_7", 
  	"tv_amb_m60_trail_c - amb_m60_area_7");
end

script continuous f_amb_m60_trail_c_hills()
  f_trigger_ambience(tv_amb_m60_trail_c_hills, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_8", 
  	"tv_amb_m60_trail_c_ship - amb_m60_area_8");
end

script continuous f_amb_m60_trail_c_rocky()
  f_trigger_ambience(tv_amb_m60_trail_c_rocky, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_9", 
  	"tv_amb_m60_trail_c_ship - amb_m60_area_9");
end

script continuous f_amb_m60_trail_c_stairs()
  f_trigger_ambience(tv_amb_m60_trail_c_stairs, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_10", 
  	"tv_amb_m60_trail_c_stairs - amb_m60_area_10");
end

script continuous f_amb_m60_trail_c_stairs_ledge()
  f_trigger_ambience(tv_amb_m60_trail_c_stairs_ledge, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_11", 
  	"tv_amb_m60_trail_c_stairs_ledge - amb_m60_area_11");
end

script continuous f_amb_m60_trail_c_fort()
  f_trigger_ambience(tv_amb_m60_trail_c_fort, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_12", 
  	"tv_amb_m60_trail_c_fort - amb_m60_area_12");
end

script continuous f_amb_m60_trail_c_ship()
  f_trigger_ambience(tv_amb_m60_trail_c_fort, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_13", 
  	"tv_amb_m60_trail_c_ship - amb_m60_area_13");
end

script continuous f_amb_m60_trail_c_treefort_entrance()
  f_trigger_ambience(tv_amb_m60_trail_c_treefort_entrance, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_14", 
  	"tv_amb_m60_trail_c_treefort_entrance - amb_m60_area_14");
end

script continuous f_amb_m60_trail_c_treefort()
  f_trigger_ambience(tv_amb_m60_trail_c_treefort, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_15", 
  	"tv_amb_m60_trail_c_treefort - amb_m60_area_15");
end

script continuous f_amb_m60_trail_c_treefort_exit()
  f_trigger_ambience(tv_amb_m60_trail_c_treefort_exit, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_16", 
  	"tv_amb_m60_trail_c_treefort_exit - amb_m60_area_16");
end

script continuous f_amb_m60_boulders_hideaway()
  f_trigger_ambience(tv_amb_m60_boulders_hideaway, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_17", 
  	"tv_amb_m60_boulders_hideaway - amb_m60_area_17");
end

script continuous f_amb_m60_boulders_entrance()
  f_trigger_ambience(tv_amb_m60_boulders_hideaway, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_18", 
  	"tv_amb_m60_boulders_entrance - amb_m60_area_18");
end

script continuous f_amb_m60_caves_entrance()
  f_trigger_ambience(tv_amb_m60_caves_entrance, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_19", 
  	"tv_amb_m60_caves_entrance - amb_m60_area_19");
end

script continuous f_amb_m60_caves()
  f_trigger_ambience(tv_amb_m60_caves, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_20", 
  	"tv_amb_m60_caves - amb_m60_area_20");
end

script continuous f_amb_m60_caves_tunnel_to_bog()
  f_trigger_ambience(tv_amb_m60_caves_tunnel_to_bog, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_21a", 
  	"tv_amb_m60_caves_tunnel_to_bog - amb_m60_area_21a");
end

script continuous f_amb_m60_caves_stairs_to_bog()
  f_trigger_ambience(tv_amb_m60_caves_stairs_to_bog, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_21b", 
  	"tv_amb_m60_caves_stairs_to_bog - amb_m60_area_21b");
end

script continuous f_amb_m60_bog_path()
  f_trigger_ambience(tv_amb_m60_bog_path, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_22", 
  	"tv_amb_m60_bog_path - amb_m60_area_22");
end

script continuous f_amb_m60_bog_fort()
  f_trigger_ambience(tv_amb_m60_bog_fort, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_23", 
  	"tv_amb_m60_bog_fort - amb_m60_area_23");
end

script continuous f_amb_m60_bog_1()
  f_trigger_ambience(tv_amb_m60_bog_1, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_24", 
  	"tv_amb_m60_bog_1 - amb_m60_area_24");
end

script continuous f_amb_m60_bog_2()
  f_trigger_ambience(tv_amb_m60_bog_2, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_25", 
  	"tv_amb_m60_bog_2 - amb_m60_area_25");
end

script continuous f_amb_m60_rally_point_1()
  f_trigger_ambience(tv_amb_m60_rally_point_1, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_26", 
  	"tv_amb_m60_rally_point_1 - amb_m60_area_26");
end

script continuous f_amb_m60_rally_point_2()
  f_trigger_ambience(tv_amb_m60_rally_point_2, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_27", 
  	"tv_amb_m60_rally_point_2 - amb_m60_area_27");
end

script continuous f_amb_m60_rally_point_3()
  f_trigger_ambience(tv_amb_m60_rally_point_3, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_28", 
  	"tv_amb_m60_rally_point_3 - amb_m60_area_28");
end

script continuous f_amb_m60_rally_point_4()
  f_trigger_ambience(tv_amb_m60_rally_point_4, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_29", 
  	"tv_amb_m60_rally_point_4 - amb_m60_area_29");
end

script continuous f_amb_m60_infinity_vehicle_bay()
  f_trigger_ambience(tv_amb_m60_infinity_vehicle_bay, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_30", 
  	"tv_amb_m60_infinity_vehicle_bay - amb_m60_area_30");
end

script continuous f_amb_m60_infinity_entrance_middle_room()
  f_trigger_ambience(tv_amb_m60_infinity_entrance_middle_room, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_31", 
  	"tv_amb_m60_infinity_entrance_middle_room - amb_m60_area_31");
end

script continuous f_amb_m60_infinity_hanger()
  f_trigger_ambience(tv_amb_m60_infinity_hanger, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_32", 
  	"tv_amb_m60_infinity_hanger - amb_m60_area_32");
end

// tv_amb_m60_infinity_causeway_hangar								35
// tv_amb_m60_infinity_causeway_hallway_to_elevator		36
// tv_amb_m60_infinity_elevator												37
// tv_amb_m60_infinity_room_to_outer_deck							38

script continuous f_amb_m60_infinity_air_lock()
  f_trigger_ambience(tv_amb_m60_infinity_air_lock, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_33", 
  	"tv_amb_m60_infinity_air_lock - amb_m60_area_33");
end

script continuous f_amb_m60_infinity_causeway()
  f_trigger_ambience(tv_amb_m60_infinity_causeway, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_34", 
  	"tv_amb_m60_infinity_causeway_1 - amb_m60_area_34");
end

script continuous f_amb_m60_infinity_causeway_hanger()
  f_trigger_ambience(tv_amb_m60_infinity_causeway_hanger, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_35", 
  	"tv_amb_m60_infinity_causeway_hanger - amb_m60_area_35");
end

script continuous f_amb_m60_infinity_causeway_hallway_to_elevator()
  f_trigger_ambience(tv_amb_m60_infinity_causeway_hallway_to_elevator, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_36", 
  	"tv_amb_m60_infinity_causeway_hallway_to_elevator - amb_m60_area_36");
end

script continuous f_amb_m60_infinity_elevator()
  f_trigger_ambience(tv_amb_m60_infinity_elevator, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_37", 
  	"tv_amb_m60_infinity_elevator - amb_m60_area_37");
end

// tv_amb_m60_infinity_outer_deck_upper								39
// tv_amb_m60_infinity_outer_deck_lower 							40

script continuous f_amb_m60_infinity_room_to_outer_deck()
  f_trigger_ambience(tv_amb_m60_infinity_room_to_outer_deck, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_38", 
  	"tv_amb_m60_infinity_room_to_outer_deck - amb_m60_area_38");
end

script continuous f_amb_m60_infinity_outer_deck_upper()
  f_trigger_ambience(tv_amb_m60_infinity_outer_deck_upper, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_39", 
  	"tv_amb_m60_infinity_outer_deck_upper - amb_m60_area_39");
end

script continuous f_amb_m60_infinity_outer_deck_lower()
  f_trigger_ambience(tv_amb_m60_infinity_outer_deck_lower, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_39", 
  	"tv_amb_m60_infinity_outer_deck_upper - amb_m60_area_39");
end

script continuous f_amb_m60_infinity_outer_deck_sky()
  f_trigger_ambience(tv_amb_m60_infinity_outer_deck_sky, 
  	"sound\environments\solo\m060\ambience\amb_m60_area_40", 
  	"tv_amb_m60_infinity_outer_deck_upper - amb_m60_area_40");
end
