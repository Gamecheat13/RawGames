// ==============================================================================================================
// ====== E1_M4_Sniperalley_Audio ===============================================================================
// ==============================================================================================================

script static void f_music_e1m2_start()
	dprint("f_music_e1m2_start");
	music_start('Play_mus_pve_e1m2_start');
end

script static void f_music_e1m2_stop()
	dprint("f_music_e1m2_stop");
	music_stop('Stop_mus_pve_e1m2_finish');
end

script static void f_music_e1m2_intro_vignette_start()
	dprint("f_music_e1m2_intro_vignette_start");
	music_set_state('Play_mus_pve_e1m2_intro_vignette_start');
end

script static void f_music_e1m2_intro_vignette_finish()
	dprint("f_music_e1m2_intro_vignette_finish");
	music_set_state('Play_mus_pve_e1m2_intro_vignette_finish');
end

script static void f_music_e1m2_vo_e1m2_playstarts()
	dprint("f_music_e1m2_vo_e1m2_playstarts");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_playstarts');
end

script static void f_music_e1m2_vo_e1m2_computerhint()
	dprint("f_music_e1m2_vo_e1m2_computerhint");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_computerhint');
end

script static void f_music_e1m2_first_object_destruction()
	dprint("f_music_e1m2_e1m2_first_object_destruction");
	music_set_state('Play_mus_pve_e1m2_first_object_destruction');
end

script static void f_music_e1m2_blowing_shields1()
	dprint("f_music_e1m2_e1m2_blowing_shields1");
	music_set_state('Play_mus_pve_e1m2_blowing_shields1');
end

script static void f_music_e1m2_vo_e1m2_shielddown()
	dprint("f_music_e1m2_vo_e1m2_shielddown");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_shielddown');
end

script static void f_music_e1m2_vo_e1m2_whataretheydoing()
	dprint("f_music_e1m2_vo_e1m2_whataretheydoing");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_whataretheydoing');
end

script static void f_music_e1m2_vo_e1m2_secondshield()
	dprint("f_music_e1m2_vo_e1m2_secondshield");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_secondshield');
end

script static void f_music_e1m2_blowing_shields2()
	dprint("f_music_e1m2_e1m2_blowing_shields2");
	music_set_state('Play_mus_pve_e1m2_blowing_shields2');
end

script static void f_music_e1m2_vo_e1m2_secondshielddown()
	dprint("f_music_e1m2_vo_e1m2_secondshielddown");
	music_set_state('Play_mus_pve_e1m2_vo_e1m2_secondshielddown');
end

script static void f_music_e1m2_small_drop_pod()
	dprint("f_music_e1m2_e1m2_small_drop_pod");
	music_set_state('Play_mus_pve_e1m2_small_drop_pod');
end

script static void f_music_e1m2_change_drop_pods()
	dprint("f_music_e1m2_e1m2_change_drop_pods");
	music_set_state('Play_mus_pve_e1m2_change_drop_pods');
end

script static void f_music_e1m2_drop_heavy_weapons()
	dprint("f_music_e1m2_e1m2_drop_heavy_weapons");
	music_set_state('Play_mus_pve_e1m2_drop_heavy_weapons');
end

script static void f_music_e1m2_vo_secure_generator()
	dprint("f_music_e1m2_e1m2_vo_secure_generator");
	music_set_state('Play_mus_pve_e1m2_vo_secure_generator');
end

script static void f_music_e1m2_vo_mark_target()
	dprint("f_music_e1m2_e1m2_vo_mark_target");
	music_set_state('Play_mus_pve_e1m2_vo_mark_target');
end

script static void f_music_e1m2_vo_targetpainted()
	dprint("f_music_e1m2_e1m2_vo_targetpainted");
	music_set_state('Play_mus_pve_e1m2_vo_targetpainted');
end

script static void f_music_e1m2_vo_getsafe()
	dprint("f_music_e1m2_e1m2_vo_getsafe");
	music_set_state('Play_mus_pve_e1m2_vo_getsafe');
end

script static void f_music_e1m2_vo_targethit()
	dprint("f_music_e1m2_e1m2_vo_targethit");
	music_set_state('Play_mus_pve_e1m2_vo_targethit');
end
