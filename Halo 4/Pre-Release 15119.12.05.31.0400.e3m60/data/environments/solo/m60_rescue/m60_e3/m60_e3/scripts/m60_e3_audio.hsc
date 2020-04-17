//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m60_rescue (E3 DEMO!)
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

static long S_zoneset_peak = 0;
static long S_zoneset_trail = 1;
static long S_zoneset_trail_a = 2;
static long S_zoneset_trail_b = 3;
static long S_zoneset_trail_c = 4;

; =================================================================================================
; Startup
; =================================================================================================
script startup f_audio_main()
	music_stop('Stop_mus_e3');
	wake(f_zone_set_peak);
	wake(f_zone_set_trail);
	wake(f_zone_set_trail_a);
	wake(f_zone_set_trail_b);
	wake(f_zone_set_trail_c);
end

; =================================================================================================
; SFX
; =================================================================================================
script static void f_audio_knight_in_distance()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_knight_in_distance', NONE, 1);
end

script static void f_audio_elite_giving_orders()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_elite_giving_orders', NONE, 1);
end

script static void f_audio_knight_scream_for_crawlers()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_knight_scream_for_crawlers', NONE, 1);
end

script static void f_audio_knight_scream_for_crawler_retreat()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_knight_scream_for_crawler_retreat', NONE, 1);
end

script static void f_audio_chief_jumped_down_into_fog()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_jumped_down', NONE, 1);
end

script static void f_audio_second_threat()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_second_threat', NONE, 1);
end

script static void f_audio_activate_forerunner_vision()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_activate_forerunner_vision', NONE, 1);
end

; =================================================================================================
; Mix Changes
; =================================================================================================
script static void f_audio_mute_guns()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_mute_all_weapons', NONE, 1);
end

script static void f_audio_unmute_guns()
	sound_impulse_start('sound\environments\solo\m060_e3\events\m60_e3_unmute_all_weapons', NONE, 1);
end

; =================================================================================================
; MUSIC - Zone Set
; =================================================================================================

// Zone set driven music cues
script dormant f_zone_set_peak()
	sleep_until(current_zone_set_fully_active() == S_zoneset_peak, 1);
	music_set_state('Play_mus_e3_r02_peak');
	music_start('Play_mus_e3');
	
	sleep_until(volume_test_players(tv_dialog_starter), 1);
	sound_impulse_start('sound\environments\solo\m060_e3\events\e3m60_vig01_feets', NONE, 1);
end

script dormant f_zone_set_trail()
	sleep_until(current_zone_set_fully_active() == S_zoneset_trail, 1);
	music_set_state('Play_mus_e3_r03_trail');
end

script dormant f_zone_set_trail_a()
	sleep_until(current_zone_set_fully_active() == S_zoneset_trail_a, 1);
	music_set_state('Play_mus_e3_r04_trail_a');
end

script dormant f_zone_set_trail_b()
	sleep_until(current_zone_set_fully_active() == S_zoneset_trail_b, 1);
	music_set_state('Play_mus_e3_r05_trail_b');
end

script dormant f_zone_set_trail_c()
	sleep_until(current_zone_set_fully_active() == S_zoneset_trail_c, 1);
	music_set_state('Play_mus_e3_r06_trail_c');
end

; =================================================================================================
; MUSIC - Encounters
; =================================================================================================
; Redundant with vignette
; script static void f_mus_m60_e01_begin()
;	music_set_state('Play_mus_e3_e01_covenant');
; end

script static void f_mus_m60_e3_e02_begin()
	music_set_state('Play_mus_e3_e02_pawn_swarm');
end

script static void f_mus_m60_e3_e03_begin()
	music_set_state('Play_mus_e3_e03_bishop');
end

script static void f_mus_m60_e3_e04_final_begin()
	music_set_state('Play_mus_e3_e04_final');
end

; Redundant with vignette
;script static void f_mus_m60_e01_finish()
;	music_set_state('Stop_mus_e3_e01_covenant');
;end

script static void f_mus_m60_e3_e02_finish()
	music_set_state('Stop_mus_e3_e02_pawn_swarm');
end

script static void f_mus_m60_e3_e03_finish()
	music_set_state('Stop_mus_e3_e03_bishop');
end

script static void f_mus_m60_e3_e04_final_finish()
	music_set_state('Stop_mus_e3_e04_final');
end

; =================================================================================================
; MUSIC - Non-Puppeteer Vignette
; =================================================================================================
script static void f_mus_picked_up_forerunner_rifle_begin()
	music_set_state('Play_mus_e3_v03_fr_weapon_pickup');
end

script static void f_mus_picked_up_forerunner_rifle_finish()
	sleep(sound_impulse_time('sound\dialog\mission\e3_demo\e3_demo_00133a'));
	sleep_s(3);
	music_set_state('Stop_mus_e3_v03_fr_weapon_pickup');
end

script static void f_mus_overwhelm_begin()
	music_set_state('play_mus_e3_v04_fr_vision_overwhelm');
end

script static void f_mus_overwhelm_finish()
	music_set_state('stop_mus_e3_v04_fr_vision_overwhelm');
end
