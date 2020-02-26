
// =================================================================================================
// m10 LAB
// =================================================================================================
global boolean B_didact_scan = FALSE;
global boolean b_scan_done = FALSE;

script dormant f_lab_init()
	sleep_until (b_mission_started == TRUE);
	//wake(f_weapons_armory);
	//wake(f_end_of_hall);
	wake(f_lab_main);
end

 script dormant f_lab_main()
	dprint  ("::: LAB EVENT START :::");
	f_star_make_create();
	object_create(fud_star_map);
	//thread(f_lab_save());
	thread(f_cryo_door_block());
	//	if S_insertion_index == DEF_INSERTION_INDEX_LAB then
 	//	sleep_until (current_zone_set_fully_active() == S_zoneset_04_armory_06_hallway, 1);
	//	else
	sleep_until (current_zone_set_fully_active() == S_zoneset_00_cryo_02_hallway_04_armory, 1);
	//	end
		//dprint  ("::: GHOST MOMENT :::");
	//DATA MINE
	data_mine_set_mission_segment ("m10_lab");
	//wake(f_ghost_mon);
	//dprint  ("::: GHOST MONITOR :::");
	sleep_until (volume_test_players(tv_ghost_mon), 1);

	wake(f_scan_timer);
	wake (f_scan_event_begin);	

	// set co-op profiles
	thread(f_loadout_set ("default"));
end

script dormant f_ghost_mon()
	sleep_until( volume_test_players_lookat(tv_ghost_mon, 2, 2), 1);
	fx_ghost_mon();
end

script dormant f_scan_timer()
	sleep_s(real_random_range(5, 7));
	if B_didact_scan == FALSE then
	B_didact_scan = TRUE;
	else
	sleep(1);
	end
end

script dormant f_scan_event_begin()
	dprint("::: DIDACT EVENT :::");
	sleep_until (volume_test_players(tv_ghost_mon) or B_didact_scan == TRUE, 1);
	B_didact_scan = TRUE;
	wake(f_dialog_lab_didact_event);	
end

script dormant f_scan_event_real()

	//sleep_s(0.5);
	
	thread(f_screenshake_ambient_pause( TRUE, FALSE, 0.0 ));
	thread(f_screenshake_event_med(-3, -1, -0.1, sfx_didact_pre_scan()));
	object_destroy(fud_star_map);
	thread(fx_arm_didact_scan());
	thread(f_star_map_flicker());
	//thread( f_screenshake_event_very_low(-0.125, 1.5, -1.5, NONE) );
	thread(f_screenshake_event_high(0, -1, -0.5, sfx_didact_scan()));
	sleep(sound_impulse_time(sfx_didact_scan()) - (2 * 30));
	thread(f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB ));
	thread(f_screenshake_ambient_pause( FALSE, TRUE, 0.0 ));
	sleep_s(1);
	//dprint("run open door");
	//f_insertion_zoneload( 2, TRUE );
	sleep_s(3.5);
	(b_scan_done = TRUE);
	sleep(1);
	f_star_make_create();
	//effect_new(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
	object_create(fud_star_map);
	wake(f_lab_door);
	game_save_no_timeout();
	sleep_s(1);
	f_objective_set( DEF_R_OBJECTIVE_GOTO_OBSERVATION, TRUE, FALSE, FALSE, FALSE );
	//NotifyLevel("librarian moment");
	sleep_until (volume_test_players(tv_elevator_pre), 1);
	//zoneset
	//wake(f_dialog_lab_pre_elevator_ics);
end
	
//Librarian
script dormant f_lab_door()
	//dprint("open lab door");
	door_librarian_event->open_fast();
	//dprint("open lab door open");
end

script static void f_cryo_door_block()
	sleep_until(volume_test_players(tv_ghost_mon) == TRUE);
	volume_teleport_players_not_inside(tv_cryo_door_block, flg_cryo_blocker_door );
	object_create(door_block_cryo);
	f_unblip_object(cryo_switch_4);
	f_unblip_object(cryo_switch_3);
	f_unblip_object(cryo_switch_2);
end

script static void f_star_map_flicker()
	print("flicker time");
	repeat
	//dprint("not working");
		effect_kill_from_flag(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
		sleep(1);
		effect_kill_from_flag(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
		sleep(5);
		effect_new(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
		sleep(7);
		effect_kill_from_flag(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
		sleep(1);
		effect_kill_from_flag(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
		sleep(5);
		effect_new(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
	until
		(b_scan_done == TRUE);

end

script static void f_lab_save()
	sleep_until(volume_test_players(tv_fud_rumble));
	game_save_no_timeout();
end

script static void f_star_make_create()
	dprint("::BUILDING STAR MAP::");
	effect_new(environments\solo\m10_crash\fx\holograms\starmap_new.effect, fx_arm_starmap_new );
end

/*
DIDACT SCAN EVENT REFERENCE
Script:
E:\Corinth\Midnight\Main\data\environments\solo\m10_crash\scripts\m10_crash_fx.hsc

Function:
fx_arm_didact_scan()

Effect:
E:\Corinth\Midnight\Main\tags\environments\solo\m10_crash\fx\scan\didact_scan.effect
*/
