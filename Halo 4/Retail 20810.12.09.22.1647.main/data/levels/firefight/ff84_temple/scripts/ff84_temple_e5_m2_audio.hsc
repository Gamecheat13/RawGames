//=============================================================================================================================
//============================================ TEMPLE E5_M2 FIREFIGHT AUDIO SCRIPT ============================================
//=============================================================================================================================

script static void f_music_e5m2_start()
	dprint("f_music_e5m2_start");
	music_start('Play_mus_pve_e5m2_start');
end

script static void f_music_e5m2_finish()
	dprint("f_music_e5m2_finish");
	music_stop('Play_mus_pve_e5m2_finish');
end

script static void f_music_e5m2_vignette_start()
	dprint("f_music_e5m2_vignette_start");
	music_set_state('Play_mus_pve_e5m2_vignette_start');
end

script static void f_music_e5m2_vignette_finish()
	dprint("f_music_e5m2_vignette_finish");
	music_set_state('Play_mus_pve_e5m2_vignette_finish');
end

script static void f_music_e5m2_first_bonobo_event()
	dprint("f_music_e5m2_first_bonobo_event");
	music_set_state('Play_mus_pve_e5m2_first_bonobo_event');
end

script static void f_music_e5m2_intro_vo_start()
	dprint("f_music_e5m2_intro_vo_start");
	music_set_state('Play_mus_pve_e5m2_intro_vo_start');
end

script static void f_music_e5m2_intro_vo_finish()
	dprint("f_music_e5m2_intro_vo_finish");
	music_set_state('Play_mus_pve_e5m2_intro_vo_finish');
end

script static void f_music_e5m2_convo_fightstart_vo()
	dprint("f_music_e5m2_convo_fightstart_vo");
	music_set_state('Play_mus_pve_e5m2_convo_fightstart_vo');
end

script static void f_music_e5m2_wont_open_vo()
	dprint("f_music_e5m2_wont_open_vo");
	music_set_state('Play_mus_pve_e5m2_wont_open_vo');
end

script static void f_music_e5m2_wontopen_callback()
	dprint("f_music_e5m3_wontopen_callback");
	music_set_state('Play_mus_pve_e5m3_wontopen_callback');
end

script static void f_music_e5m2_opendoor_callback()
	dprint("f_music_e5m2_opendoor_callback");
	music_set_state('Play_mus_pve_e5m2_opendoor_callback');
end

script static void f_music_e5m2_dooropen_vo()
	dprint("f_music_e5m2_dooropen_vo");
	music_set_state('Play_mus_pve_e5m2_dooropen_vo');
end

script static void f_music_e5m2_dooropen_callback()
	dprint("f_music_e5m2_dooropen_callback");
	music_set_state('Play_mus_pve_e5m2_dooropen_callback');
end

script static void f_music_e5m2_lottadropships_vo()
	dprint("f_music_e5m3_lottadropships_vo");
	music_set_state('Play_mus_pve_e5m2_lottadropships_vo');
end

script static void f_music_e5m2_hunters_vo()
	dprint("f_music_e5m2_hunters_vo");
	music_set_state('Play_mus_pve_e5m2_hunters_vo');
end

script static void f_music_e5m2_wrapup_vo_1()
	dprint("f_music_e5m2_wrapup_vo_1");
	music_set_state('Play_mus_pve_e5m2_wrapup_vo_1');
end

script static void f_music_e5m2_wrapup_vo_2()
	dprint("f_music_e5m2_wrapup_vo_2");
	music_set_state('Play_mus_pve_e5m2_wrapup_vo_2');
end

script static void f_music_e5m2_pelican_vo()
	dprint("f_music_e5m2_pelican_vo");
	music_set_state('Play_mus_pve_e5m2_pelican_vo');
end

script static void f_music_e5m2_spawn_bridge()
	dprint("f_music_e5m2_spawn_bridge");
	music_set_state('Play_mus_pve_e5m2_spawn_bridge');
end

script static void f_music_e5m2_place_marines()
	dprint("f_music_e5m2_place_marines");
	music_set_state('Play_mus_pve_e5m2_place_marines');
end

script static void f_music_e5m2_marinehelp()
	dprint("f_music_e5m2_marinehelp");
	music_set_state('Play_mus_pve_e5m2_marinehelp');
end

script static void f_music_e5m2_shielddoor()
	dprint("f_music_e5m2_shielddoor");
	music_set_state('Play_mus_pve_e5m2_shielddoor');
end

script static void f_music_e5m2_shielddoor_vo()
	dprint("f_music_e5m2_shielddoor_vo");
	music_set_state('Play_mus_pve_e5m2_shielddoor_vo');
end

script static void f_music_e5m2_carrier_vo()
	dprint("f_music_e5m2_carrier_vo");
	music_set_state('Play_mus_pve_e5m2_carrier_vo');
end

script static void f_music_e5m2_hackshields()
	dprint("f_music_e5m2_hackshields");
	music_set_state('Play_mus_pve_e5m2_hackshields');
end

script static void f_music_e5m2_shoot_door_objective_maybe()
	dprint("f_music_e5m2_shoot_door_objective_maybe");
	music_set_state('Play_mus_pve_e5m2_shoot_door_objective_maybe');
end

script static void f_music_e5m2_shield_barrier_down()
	dprint("f_music_e5m2_shield_barrier_down");
	music_set_state('Play_mus_pve_e5m2_shield_barrier_down');
end

script static void f_music_e5m2_marinefight_vo()
	dprint("f_music_e5m2_marinefight_vo");
	music_set_state('Play_mus_pve_e5m2_marinefight_vo');
end

script static void f_music_e5m2_spawn_commandos()
	dprint("f_music_e5m2_spawn_commandos");
	music_set_state('Play_mus_pve_e5m2_spawn_commandos');
end

script static void f_music_e5m2_barrier_kill()
	dprint("f_music_e5m2_barrier_kill");
	music_set_state('Play_mus_pve_e5m2_barrier_kill');
end

script static void f_music_e5m2_commando_adds_1()
	dprint("f_music_e5m2_commando_adds_1");
	music_set_state('Play_mus_pve_e5m2_commando_adds_1');
end

script static void f_music_e5m2_commando_adds_2()
	dprint("f_music_e5m2_commando_adds_2");
	music_set_state('Play_mus_pve_e5m2_commando_adds_2');
end

script static void f_music_e5m2_int_door_arrival()
	dprint("f_music_e5m2_int_door_arrival");
	music_set_state('Play_mus_pve_e5m2_int_door_arrival');
end

script static void f_music_e5m2_opendoor_vo()
	dprint("f_music_e5m2_opendoor_vo");
	music_set_state('Play_mus_pve_e5m2_opendoor_vo');
end

script static void f_music_e5m2_enable_panel()
	dprint("f_music_e5m2_opendoor_vo");
	music_set_state('Play_mus_pve_e5m2_enable_panel');
end

script static void f_music_e5m2_objective_3a_maybe()
	dprint("f_music_e5m2_objective_3a_maybe");
	music_set_state('Play_mus_pve_e5m2_objective_3a_maybe');
end

script static void f_music_e5m2_panel_accessed()
	dprint("f_music_e5m2_panel_accessed");
	music_set_state('Play_mus_pve_e5m2_panel_accessed');
end

script static void f_music_e5m2_open_interior_doors()
	dprint("f_music_e5m2_open_interior_doors");
	music_set_state('Play_mus_pve_e5m2_open_interior_doors');
end

script static void f_music_e5m2_blitz_shake_and_vo()
	dprint("f_music_e5m2_blitz_shake_and_vo");
	music_set_state('Play_mus_pve_e5m2_blitz_shake_and_vo');
end

script static void f_music_e5m2_start_blitz()
	dprint("f_music_e5m2_start_blitz");
	music_set_state('Play_mus_pve_e5m2_start_blitz');
end

script static void f_music_e5m2_reenable_blips()
	dprint("f_music_e5m2_reenable_blips");
	music_set_state('Play_mus_pve_e5m2_reenable_blips');
end

script static void f_music_e5m2_blitz_done()
	dprint("f_music_e5m2_blitz_done");
	music_set_state('Play_mus_pve_e5m2_blitz_done');
end

script static void f_music_e5m2_ext2_start()
	dprint("f_music_e5m2_ext2_start");
	music_set_state('Play_mus_pve_e5m2_ext2_start');
end

script static void f_music_e5m2_hunters_play_vo()
	dprint("f_music_e5m2_hunters_play_vo");
	music_set_state('Play_mus_pve_e5m2_hunters_play_vo');
end

script static void f_music_e5m2_ext2_almost_done()
	dprint("f_music_e5m2_ext2_almost_done");
	music_set_state('Play_mus_pve_e5m2_ext2_almost_done');
end

script static void f_music_e5m2_all_combat_done()
	dprint("f_music_e5m2_all_combat_done");
	music_set_state('Play_mus_pve_e5m2_all_combat_done');
end