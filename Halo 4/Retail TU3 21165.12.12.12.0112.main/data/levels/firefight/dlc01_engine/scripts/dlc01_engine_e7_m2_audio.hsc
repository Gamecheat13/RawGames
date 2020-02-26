// =====================================================================================================
//========= ENGINE E7 M2 SFX FIREFIGHT SCRIPT ========================================================
// =====================================================================================================

/*script static void f_audio_hanger_screen_activate_left()
	dprint("f_audio_computer_activate");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_computer_activate_in', cr_e7_m2_hanger_screen_left, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_computer_terminal_loop_01', cr_e7_m2_hanger_screen_left, 1);
end

script static void f_audio_hanger_screen_activate_right()
	dprint("f_audio_computer_activate_02");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_computer_activate_in', cr_e7_m2_hanger_screen_right, 1);
end
	
script static void f_audio_hanger_screen_deactivate_left()
	dprint("f_audio_computer_deactivate");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_computer_deactivate_in', cr_e7_m2_hanger_screen_left, 1);
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_computer_terminal_loop_01'); 
end*/
	
script static void f_audio_ai_activate()	
	dprint("f_audio_ai_activate");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_ai_core_power_on_in', ai_activate, 1);
	
end
	
script static void f_audio_dm_server_large_1_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_large_1, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop',dm_server_large_1, 1);
	
end

script static void f_audio_dm_server_large_1_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in',dm_server_large_1, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	
end

script static void f_audio_dm_server_large_2_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_large_2, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop',dm_server_large_2, 1);
	
end

script static void f_audio_dm_server_large_2_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in',dm_server_large_2, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	
end

script static void f_audio_dm_server_small_1_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_1, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop',dm_server_small_1, 1);
	
end

script static void f_audio_dm_server_small_1_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in',dm_server_small_1, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	
end

script static void f_audio_dm_server_small_2_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_2, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop',dm_server_small_2, 1);
	
end

script static void f_audio_dm_server_small_2_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in',dm_server_small_2, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	
end

script static void f_audio_dm_server_small_3_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_3, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop',dm_server_small_3, 1);
	
end

script static void f_audio_dm_server_small_3_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in', dm_server_small_3, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');

end

script static void f_audio_dm_server_small_4_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_4, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop',dm_server_small_4, 1);
	
end

script static void f_audio_dm_server_small_4_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in',dm_server_small_4, 1);
	//sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	
end
/*
script static void f_audio_dm_server_small_5_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_small_5, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop',dm_server_small_5, 1);
	
end

script static void f_audio_dm_server_small_5_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in',dm_server_small_5, 1);
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	
end

script static void f_audio_dm_server_small_6_start()	
	dprint("f_audio_server_start");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_small_6, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop',dm_server_small_6, 1);
	
end

script static void f_audio_dm_server_small_6_stop()	
	dprint("f_audio_server_stop");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in',dm_server_small_6, 1);
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	
end
*/
script static void f_audio_hanger_door_close(object door)	
	dprint("f_audio_hanger_close");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_blast_door_close_in', door, 1);
	
end

script static void f_audio_dm_piston()	
	dprint("f_audio_dm_piston");
	sound_looping_start (sound\environments\multiplayer\infinityengine\engine_piston_loop, dm_piston01, 1);
	sound_looping_start (sound\environments\multiplayer\infinityengine\engine_piston_loop, dm_piston02, 1);
	sound_looping_start (sound\environments\multiplayer\infinityengine\engine_piston_loop, dm_piston03, 1);
	
end

//script static void f_audio_server_loop()	
	//dprint("f_audio_server_loop");
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server01, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server02, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server03, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server04, 1);	
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server05, 1);
	//sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_ss_server_large_loop', server06, 1);	

//end

script static void f_audio_dm_server_small_1()
	dprint("f_audio_dm_server_small_1");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_1, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop', dm_server_small_1, 1);
	
	sleep_until( (device_get_position(dm_server_small_1) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in', dm_server_small_1, 1);
	object_create(engine_server_hum_03);
	

end

script static void f_audio_dm_server_small_2()
	dprint("f_audio_dm_server_small_2");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_2, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop', dm_server_small_2, 1);
	
	sleep_until( (device_get_position(dm_server_small_2) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in', dm_server_small_2, 1);
	object_create(engine_server_hum_04);

end

script static void f_audio_dm_server_small_3()
	dprint("f_audio_dm_server_small_3");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_3, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop', dm_server_small_3, 1);
	
	sleep_until( (device_get_position(dm_server_small_3) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in', dm_server_small_3, 1);
	object_create(engine_server_hum_05);

end


script static void f_audio_dm_server_small_4()
	dprint("f_audio_dm_server_small_4");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_start_in', dm_server_small_4, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop', dm_server_small_4, 1);
	
	sleep_until( (device_get_position(dm_server_small_4) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\amb_engine_server_raise_small_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\amb_engine_server_raise_small_stop_in', dm_server_small_4, 1);
	object_create(engine_server_hum_06);

end


script static void f_audio_dm_server_large_1()
	dprint("f_audio_dm_server_large_1");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_large_1, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop', dm_server_large_1, 1);
	
	sleep_until( (device_get_position(dm_server_large_1) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in', dm_server_large_1, 1);
	object_create(engine_server_hum_01);
	
end

script static void f_audio_dm_server_large_2()
	dprint("f_audio_dm_server_large_2");
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_start_in', dm_server_large_2, 1);
	sound_looping_start ( 'sound\environments\multiplayer\infinityengine\engine_server_loop', dm_server_large_2, 1);
	
	sleep_until( (device_get_position(dm_server_large_2) >= 0.9), 1 );
	
	sound_looping_stop ( 'sound\environments\multiplayer\infinityengine\engine_server_loop');
	sound_impulse_start ( 'sound\environments\multiplayer\infinityengine\events\engine_server_stop_in', dm_server_large_2, 1);
	object_create(engine_server_hum_02);
	
end
	
	

// =====================================================================================================
//========= ENGINE E7 M2 AUDIO FIREFIGHT SCRIPT ========================================================
// =====================================================================================================

script static void f_music_e07m2_start()
	dprint("f_music_e07m2_start");
	music_start('Play_mus_pve_e07m2_start');
end

script static void f_music_e7m2_finish()
	dprint("f_music_e07m2_finish");
	music_set_state('Play_mus_pve_e07m2_finish');
end

script static void f_music_e7m2_vignette_start()
	dprint("f_music_e7m2_vignette_start");
	music_set_state('Play_mus_pve_e7m2_vignette_start');
end

script static void f_music_e7m2_vignette_finish()
	dprint("f_music_e7m2_vignette_finish");
	music_set_state('Play_mus_pve_e7m2_vignette_finish');
end

script static void f_music_e07m2_intro()
	dprint("Play_mus_pve_e07m2_INTRO");
	music_start('Play_mus_pve_e07m2_intro');
end

script static void f_music_e07m2_playstart()
	dprint("Play_mus_pve_e07m2_playstart");
	music_set_state('Play_mus_pve_e07m2_playstart');
end

script static void f_music_e07m2_hitcontrols()
	dprint("Play_mus_pve_e07m2_hitcontrols");
	music_set_state('Play_mus_pve_e07m2_hitcontrols');
end

script static void f_music_e07m2_dontwork()
	dprint("Play_mus_pve_e07m2_dontwork");
	music_set_state('Play_mus_pve_e07m2_dontwork');
end

script static void f_music_e07m2_gettoserver()
	dprint("Play_mus_pve_e07m2_gettoserver");
	music_set_state('Play_mus_pve_e07m2_gettoserver');
end

script static void f_music_e07m2_liftraised()
	dprint("Play_mus_pve_e07m2_liftraised");
	music_set_state('Play_mus_pve_e07m2_liftraised');
end

script static void f_music_e07m2_morebadguys()
	dprint("Play_mus_pve_e07m2_morebadguys");
	music_set_state('Play_mus_pve_e07m2_morebadguys');
end

script static void f_music_e07m2_roomclear()
	dprint("Play_mus_pve_e07m2_roomclear");
	music_set_state('Play_mus_pve_e07m2_roomclear');
end

script static void f_music_e07m2_cyclebegun()
	dprint("Play_mus_pve_e07m2_cyclebegun");
	music_set_state('Play_mus_pve_e07m2_cyclebegun');
end

script static void f_music_e07m2_datalink()
	dprint("Play_mus_pve_e07m2_datalink");
	music_set_state('Play_mus_pve_e07m2_datalink');
end

script static void f_music_e07m2_infinityblow()
	dprint("Play_mus_pve_e07m2_infinityblow");
	music_set_state('Play_mus_pve_e07m2_infinityblow');
end

script static void f_music_e07m2_hangarreturn()
	dprint("Play_mus_pve_e07m2_hangarreturn");
	music_set_state('Play_mus_pve_e07m2_hangarreturn');
end

script static void f_music_e07m2_control_activate()
	dprint("Play_mus_pve_e07m2_control_activate");
	music_set_state('Play_mus_pve_e07m2_control_activate');
end

script static void f_music_e07m2_silence()
	dprint("Play_mus_pve_e07m2_silence");
	music_set_state('Play_mus_pve_e07m2_silence');
end

// =====================================================================================================
//========= SCURVE E7 M5 AUDIO FIREFIGHT SCRIPT ========================================================
// =====================================================================================================

script static void f_music_e07m5_start()
	dprint("Play_mus_pve_e07m5_start");
	music_set_state('Play_mus_pve_e07m5_start');
end	

script static void f_music_e07m5_server_room()
	dprint("Play_mus_pve_e07m5_server_room");
	music_set_state('Play_mus_pve_e07m5_server_room');
end	

script static void f_music_e07m5_clean_stragglers()
	dprint("Play_mus_pve_e07m5_clean_stragglers");
	music_set_state('Play_mus_pve_e07m5_clean_stragglers');
end	

script static void f_music_e07m5_secure_server()
	dprint("Play_mus_pve_e07m5_secure_server");
	music_set_state('Play_mus_pve_e07m5_secure_server');
end	
	
script static void f_music_e07m5_towards_hangar()
	dprint("Play_mus_pve_e07m5_towards_hangar");
	music_set_state('Play_mus_pve_e07m5_towards_hangar');
end

script static void f_music_e07m5_hangar_hunters()
	dprint("Play_mus_pve_e07m5_hangar_hunters");
	music_set_state('Play_mus_pve_e07m5_hangar_hunters');
end

script static void f_music_e07m5_overrides_down()
	dprint("Play_mus_pve_e07m5_overrides_down");
	music_set_state('Play_mus_pve_e07m5_overrides_down');
end		

script static void f_music_e07m5_activated()
	dprint("Play_mus_pve_e07m5_activated");
	music_set_state('Play_mus_pve_e07m5_activated');
end	

script static void f_music_e07m5_you_win()
	dprint("Play_mus_pve_e07m5_you_win");
	music_set_state('Play_mus_pve_e07m5_you_win');
end	

script static void f_music_e07m5_infinity_01()
	dprint("Play_mus_pve_e07m5_infinity_01");
	music_set_state('Play_mus_pve_e07m5_infinity_01');
end

script static void f_music_e07m5_infinity_02()
	dprint("Play_mus_pve_e07m5_infinity_02");
	music_set_state('Play_mus_pve_e07m5_infinity_02');
end

script static void f_music_e07m5_infinity_03()
	dprint("Play_mus_pve_e07m5_infinity_03");
	music_set_state('Play_mus_pve_e07m5_infinity_03');
end

script static void f_music_e07m5_finish()
	dprint("Play_mus_pve_e07m5_finish");
	music_set_state('Play_mus_pve_e07m5_finish');
end	

script static void f_music_e07m5_hunters_down()
	dprint("Play_mus_pve_e07m5_hunters_down");
	music_set_state('Play_mus_pve_e07m5_hunters_down');
end	

script static void f_music_e07m5_hangar_clear()
	dprint("Play_mus_pve_e07m5_hangar_clear");
	music_set_state('Play_mus_pve_e07m5_hangar_clear');
end	

script static void f_music_e07m5_ending()
	dprint("Play_mus_pve_e07m5_ending");
	music_set_state('Play_mus_pve_e07m5_ending');
end	

script static void f_music_e07m5_start_knights()
	dprint("Play_mus_pve_e07m5_start_knights");
	music_set_state('Play_mus_pve_e07m5_start_knights');
end	


// =====================================================================================================
//========= SCURVE E7 M4 AUDIO FIREFIGHT SCRIPT ========================================================
// =====================================================================================================


script static void f_music_e07m4_start()
	dprint("Play_mus_pve_e07m4_start");
	music_set_state('Play_mus_pve_e07m4_start');
end	


script static void f_music_e07m4_lockprogress()
	dprint("Play_mus_pve_e07m4_lockprogress");
	music_set_state('Play_mus_pve_e07m4_lockprogress');
end	


script static void f_music_e07m4_lockdone()
	dprint("Play_mus_pve_e07m4_lockdone");
	music_set_state('Play_mus_pve_e07m4_lockdone');
end

	
script static void f_music_e07m4_seal_engine()
	dprint("Play_mus_pve_e07m4_seal_engine");
	music_set_state('Play_mus_pve_e07m4_seal_engine');
end	


script static void f_music_e07m4_incore()
	dprint("Play_mus_pve_e07m4_incore");
	music_set_state('Play_mus_pve_e07m4_incore');
end	

script static void f_music_e07m4_hunters()
	dprint("Play_mus_pve_e07m4_hunters");
	music_set_state('Play_mus_pve_e07m4_hunters');
end	

script static void f_music_e07m4_enablecore()
	dprint("Play_mus_pve_e07m4_enablecore");
	music_set_state('Play_mus_pve_e07m4_enablecore');
end	

script static void f_music_e07m4_3rdoverride()
	dprint("Play_mus_pve_e07m4_3rdoverride");
	music_set_state('Play_mus_pve_e07m4_3rdoverride');
end

script static void f_music_e07m4_gunsonline()
	dprint("Play_mus_pve_e07m4_gunsonline");
	music_set_state('Play_mus_pve_e07m4_gunsonline');
end

script static void f_music_e07m4_gotocore()
	dprint("Play_mus_pve_e07m4_gotocore");
	music_set_state('Play_mus_pve_e07m4_gotocore');
end

script static void f_music_e07m4_ending()
	dprint("Play_mus_pve_e07m4_ending");
	music_set_state('Play_mus_pve_e07m4_ending');
end

script static void f_music_e07m4_finish()
	dprint("Play_mus_pve_e07m4_finish");
	music_set_state('Play_mus_pve_e07m4_finish');
end


// =====================================================================================================
//========= SCURVE E7 M3 AUDIO FIREFIGHT SCRIPT ========================================================
// =====================================================================================================


script static void f_music_e07m3_start()
	dprint("Play_mus_pve_e07m3_start");
	music_set_state('Play_mus_pve_e07m3_start');
end

script static void f_music_e07m3_playstart()
	dprint("Play_mus_pve_e07m3_playstart");
	music_set_state('Play_mus_pve_e07m3_playstart');
end


script static void f_music_e07m3_nukeprogress_1()
	dprint("Play_mus_pve_e07m3_nukeprogress_1");
	music_set_state('Play_mus_pve_e07m3_nukeprogress_1');
end


script static void f_music_e07m3_firstalert()
	dprint("Play_mus_pve_e07m3_firstalert");
	music_set_state('Play_mus_pve_e07m3_firstalert');
end


script static void f_music_e07m3_fightending()
	dprint("Play_mus_pve_e07m3_fightending");
	music_set_state('Play_mus_pve_e07m3_fightending');
end


script static void f_music_e07m3_enterserver()
	dprint("Play_mus_pve_e07m3_enterserver");
	music_set_state('Play_mus_pve_e07m3_enterserver');
end


script static void f_music_e07m3_disarmed()
	dprint("Play_mus_pve_e07m3_disarmed");
	music_set_state('Play_mus_pve_e07m3_disarmed');
end


script static void f_music_e07m3_2nddisarmed()
	dprint("Play_mus_pve_e07m3_2nddisarmed");
	music_set_state('Play_mus_pve_e07m3_2nddisarmed');
end


script static void f_music_e07m3_ending()
	dprint("Play_mus_pve_e07m3_ending");
	music_set_state('Play_mus_pve_e07m3_ending');
end


script static void f_music_e07m3_finish()
	dprint("Play_mus_pve_e07m3_finish");
	music_set_state('Play_mus_pve_e07m3_finish');
end


script static void f_music_e07m3_server_silence()
	dprint("Play_mus_pve_e07m3_server_silence");
	music_set_state('Play_mus_pve_e07m3_server_silence');
end

script static void f_music_e07m3_silence()
	dprint("Play_mus_pve_e07m3_silence");
	music_set_state('Play_mus_pve_e07m3_silence');
end
	

// =====================================================================================================
//========= ZERO G SFX ========================================================
// =====================================================================================================



//script static void f_sound_mode_normal_G()
	
	//dprint( "Setting sound mode to: Normal Gravity" );
	//sound_impulse_start( 'sound\storm\states\zero_g\set_state_high_gravity', NONE, 1 );								// Normal, no fx applied
	
//end


//script static void f_sound_mode_low_G()
	
	//dprint( "Setting sound mode to: Low Gravity" );
	//sound_impulse_start( 'sound\storm\states\zero_g\set_state_low_gravity', NONE, 1 );							// Low gravity, moderate fx applied

//end


//script static void f_sound_mode_zero_G()
	
	//dprint( "Setting sound mode to: Zero Gravity" );
	//sound_impulse_start( 'sound\storm\states\zero_g\set_state_no_gravity', NONE, 1 );									// Zero G, full fx applied
	
//end