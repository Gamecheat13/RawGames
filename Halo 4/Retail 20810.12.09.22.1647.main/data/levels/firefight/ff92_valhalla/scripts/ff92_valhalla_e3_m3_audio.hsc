//============================================ VALHALLA FIREFIGHT AUDIO SCRIPT E3 M3 ==========================================
//=============================================================================================================================

script static void f_music_e3m3_start()
	dprint("f_music_e3m3_start");
	music_start('Play_mus_pve_e3m3_start');
end

script static void f_music_e3m3_finish()
	dprint("f_music_e3m3_stop");
	music_stop('Play_mus_pve_e3m3_finish');
end

script static void f_music_e3m3_vignette_1_start()
	dprint("f_music_e3m3_vignette_1_start");
	music_set_state('Play_mus_pve_e3m3_vignette_1_start');
end

script static void f_music_e3m3_vignette_1_finish()
	dprint("f_music_e3m3_vignette_1_finish");
	music_set_state('Play_mus_pve_e3m3_vignette_1_finish');
end

script static void f_music_e3m3_vignette_2_start()
	dprint("f_music_e3m3_vignette_start");
	music_set_state('Play_mus_pve_e3m3_vignette_2_start');
end

script static void f_music_e3m3_vignette_2_finish()
	dprint("f_music_e3m3_vignette_finish");
	music_set_state('Play_mus_pve_e3m3_vignette_2_finish');
end

script static void f_music_e3m3_guards_start()
	dprint("f_music_e3m3_guards_start");
	music_set_state('Play_mus_pve_e3m3_guards_start');
end

script static void f_music_e3m3_loadfriendlies()
	dprint("f_music_e3m3_loadfriendlies");
	music_set_state('Play_mus_pve_e3m3_loadfriendlies');
end

script static void f_music_e3m3_playstart_vo_start()
	dprint("f_music_e3m3_playstart_vo_start");
	music_set_state('Play_mus_pve_e3m3_playstart_vo_start');
end

script static void f_music_e3m3_playstart_vo_finish()
	dprint("f_music_e3m3_playstart_vo_finish");
	music_set_state('Play_mus_pve_e3m3_playstart_vo_finish');
end

script static void f_music_e3m3_topelican_vo()
	dprint("f_music_e3m3_topelican_vo");
	music_set_state('Play_mus_pve_e3m3_topelican_vo');
end

script static void f_music_e3m3_clear_crash_site()
	dprint("f_music_e3m3_clear_crash_site");
	music_set_state('Play_mus_pve_e3m3_clear_crash_site');
end

script static void f_music_e3m3_savedmarines_vo()
	dprint("f_music_e3m3_savedmarines_vo");
	music_set_state('Play_mus_pve_e3m3_savedmarines_vo');
end

script static void f_music_e3m3_getcovloot_vo()
	dprint("f_music_e3m3_getcovloot_vo");
	music_set_state('Play_mus_pve_e3m3_getcovloot_vo');
end

script static void f_music_e3m3_targetshield_vo()
	dprint("f_music_e3m3_targetshield_vo");
	music_set_state('Play_mus_pve_e3m3_targetshield_vo');
end

script static void f_music_e3m3_drop_cov_jammer_shield()
	dprint("f_music_e3m3_drop_cov_jammer_shield");
	music_set_state('Play_mus_pve_e3m3_drop_cov_jammer_shield');
end

script static void f_music_e3m3_shieldsdown_vo()
	dprint("f_music_e3m3_shieldsdown_vo");
	music_set_state('Play_mus_pve_e3m3_shieldsdown_vo');
end

script static void f_music_e3m3_destroyjammers_vo()
	dprint("f_music_e3m3_destroyjammers_vo");
	music_set_state('Play_mus_pve_e3m3_destroyjammers_vo');
end

script static void f_music_e3m3_one_jammer_down()
	dprint("f_music_e3m3_one_jammer_down");
	music_set_state('Play_mus_pve_e3m3_one_jammer_down');
end

script static void f_music_e3m3_two_jammer_down_vo()
	dprint("f_music_e3m3_two_jammer_down_vo");
	music_set_state('Play_mus_pve_e3m3_two_jammer_down_vo');
end

script static void f_music_e3m3_two_jammer_down()
	dprint("f_music_e3m3_two_jammer_down");
	music_set_state('Play_mus_pve_e3m3_two_jammer_down');
end

script static void f_music_e3m3_marinesalive_vo()
	dprint("f_music_e3m3_marinesalive_vo");
	music_set_state('Play_mus_pve_e3m3_marinesalive_vo');
end

script static void f_music_e3m3_marinesdead_vo()
	dprint("f_music_e3m3_marinesdead_vo");
	music_set_state('Play_mus_pve_e3m3_marinesdead_vo');
end

script static void f_music_e3m3_findcontrols_vo()
	dprint("f_music_e3m3_findcontrols_vo");
	music_set_state('Play_mus_pve_e3m3_findcontrols_vo');
end

script static void f_music_e3m3_shielddown2()
	dprint("f_music_e3m3_shielddown2");
	music_set_state('Play_mus_pve_e3m3_shielddown2');
end

script static void f_music_e3m3_grab_fore_item()
	dprint("f_music_e3m3_grab_fore_item");
	music_set_state('Play_mus_pve_e3m3_grab_fore_item');
end

script static void f_music_e3m3_entertower_vo()
	dprint("f_music_e3m3_entertower_vo");
	music_set_state('Play_mus_pve_e3m3_entertower_vo');
end

script static void f_music_e3m3_halsey_vo()
	dprint("f_music_e3m3_halsey_vo");
	music_set_state('Play_mus_pve_e3m3_halsey_vo');
end

script static void f_music_e3m3_activatetech_vo()
	dprint("f_music_e3m3_activatetech_vo");
	music_set_state('Play_mus_pve_e3m3_activatetech_vo');
end

script static void f_music_e3m3_end_event()
	dprint("f_music_e3m3_end_event");
	music_set_state('Play_mus_pve_e3m3_end_event');
end

script static void f_music_e3m3_lightshow_vo()
	dprint("f_music_e3m3_lightshow_vo");
	music_set_state('Play_mus_pve_e3m3_lightshow_vo');
end

script static void f_music_e3m3_power_up_switch_1()
	dprint("f_music_e3m3_power_up_switch_1");
	music_set_state('Play_mus_pve_e3m3_power_up_switch_1');
end

script static void f_music_e3m3_power_up_switch_2()
	dprint("f_music_e3m3_power_up_switch_2");
	music_set_state('Play_mus_pve_e3m3_power_up_switch_2');
end

script static void f_music_e3m3_power_up_switch_3()
	dprint("f_music_e3m3_power_up_switch_3");
	music_set_state('Play_mus_pve_e3m3_power_up_switch_3');
end

script static void f_music_e3m3_switch_1()
	dprint("f_music_e3m3_switch_1");
	music_set_state('Play_mus_pve_e3m3_switch_1');
end

script static void f_music_e3m3_switch_2()
	dprint("f_music_e3m3_switch_2");
	music_set_state('Play_mus_pve_e3m3_switch_2');
end