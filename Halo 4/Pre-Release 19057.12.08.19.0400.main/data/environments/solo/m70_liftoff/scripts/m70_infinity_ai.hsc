//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// infinity_AI
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_infinity_AI_init::: Initialize
script dormant f_infinity_AI_init()
	dprint( "::: f_infinity_AI_init :::" );
	
	// initialize modules

	// initialize sub modules
	
	//wake( f_infinity_AI_marines_init );
	ai_allegiance( player, human );
	
	ai_place ( sg_infinity );
	wake(f_inf_dock_workers);
	
	local long show_marine_01 = pup_play_show(pup_marines_salute_1_2);
	local long show_marine_02 = pup_play_show(pup_marines_salute_3_4);
	local long show_marine_03 = pup_play_show(pup_marines_salute_5_6);
	local long show_marine_04 = pup_play_show(pup_marines_salute_7_8);
	local long show_marine_05 = pup_play_show(pup_spartan_sitting);
	local long show_marine_06 = pup_play_show(pup_marines_work);
	local short show_marine_07 = pup_play_show(pup_marines_work_001);
	local long show_marine_08 = pup_play_show(pup_marines_work_02);
	local long show_marine_09 = pup_play_show(pup_marines_talking_01);
	local long show_marine_10 = pup_play_show(pup_spartan_patrol_01);
	local long show_marine_11 = pup_play_show(pup_spartan_convo_01);
	local long show_marine_12 = pup_play_show(pup_spartan_convo_01);
	local long show_marine_13 = pup_play_show(pup_spartan_patrol_02);
	print("salute");
	sleep_until(ai_allegiance_broken(player, human ), 1);
	ai_allegiance_remove (player, human);
	ai_braindead( sg_infinity, FALSE);
	b_dock_workers_panic = TRUE;
	
	pup_stop_show(show_marine_01);
	pup_stop_show(show_marine_02);
	pup_stop_show(show_marine_03);
	pup_stop_show(show_marine_04);
	pup_stop_show(show_marine_05);
	pup_stop_show(show_marine_06);
	pup_stop_show(show_marine_07);
	pup_stop_show(show_marine_08);
	pup_stop_show(show_marine_09);
	pup_stop_show(show_marine_10);
	pup_stop_show(show_marine_11);
	pup_stop_show(show_marine_12);
	pup_stop_show(show_marine_13);

	
	sleep_until(ai_living_count(sg_infinity) < 15, 1);
	wake(f_inf_hunter_killer);
end

// === f_infinity_AI_deinit::: Deinitialize
script dormant f_infinity_AI_deinit()
	dprint( "::: f_infinity_AI_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_AI_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_infinity_AI_CCC_deinit );
	wake( f_infinity_AI_marines_deinit );

end

script command_script cs_inf_marines()
dprint("cs_inf_marines");
cs_enable_moving(FALSE);
sleep_until(b_dock_workers_panic, 1);
cs_enable_moving(TRUE);
end

script command_script cs_clear()
sleep(5);
end

script dormant f_inf_hunter_killer()
dprint("f_inf_hunter_killer");
thread(f_inf_hunter_killer_01());
thread(f_inf_hunter_killer_02());
thread(f_inf_hunter_killer_03());

end

script static void f_inf_hunter_killer_01()
dprint("f_inf_hunter_killer_01");
end

script static void f_inf_hunter_killer_02()
dprint("f_inf_hunter_killer_02");
end

script static void f_inf_hunter_killer_03()
dprint("f_inf_hunter_killer_03");
end

script dormant f_temp_start

 wake (f_infinity_init);
 print ("GO");

end

// -------------------------------------------------------------------------------------------------
// infinity_AI: CCC
// -------------------------------------------------------------------------------------------------

//inspect(ai_living_count(sg_infinity));
// === f_infinity_AI_marines_deinit::: Deinit
script dormant f_infinity_AI_marines_deinit()
	dprint( "::: f_infinity_AI_marines_deinit :::" );

	// shutdown functions
	ai_erase( sg_infinity );


end


script static void f_player_proximity_time_check(real r_time)
	repeat
	b_dock_workers_play_show = FALSE;
	sleep_until(volume_test_players(tv_dock_worker), 1);
	if volume_test_players(tv_dock_worker) then
		sleep_s(r_time);
		if volume_test_players(tv_dock_worker) then
			b_dock_workers_play_show = TRUE;
		end
	end
	until(b_dock_workers_play_show or ai_allegiance_broken(player, human ), 1);
end


global boolean b_dock_workers_play_show = FALSE; 
global boolean b_dock_workers_panic = FALSE; 

script dormant f_inf_dock_workers()
	dprint("f_inf_conan");
	local long show_dock_idle = 0;
	local long show_dock_worker = 0;
	sleep_until(ai_living_count(sq_inf_dock_worker) > 1, 1);
	show_dock_idle = pup_play_show(pup_dock_idle);
	repeat		

		f_player_proximity_time_check(30);

		//CRATE_UNION
		dprint("CRATE_UNION");
		if ai_living_count(sq_inf_dock_worker) > 1 and not ai_allegiance_broken(player, human) then
			pup_stop_show(show_dock_idle);
			show_dock_worker = pup_play_show(pup_crate_union);
			sleep_until( not pup_is_playing(show_dock_worker), 1);
			show_dock_idle = pup_play_show(pup_dock_idle);
		end

		f_player_proximity_time_check(5);

		//RUGS_WOULD_BE_NICE
		dprint("RUGS_WOULD_BE_NICE");
		if ai_living_count(sq_inf_dock_worker) > 1 and not ai_allegiance_broken(player, human) then
			pup_stop_show(show_dock_idle);
			show_dock_worker = pup_play_show(pup_rugs_would_be_nice);
			sleep_until( not pup_is_playing(show_dock_worker), 1);
			show_dock_idle = pup_play_show(pup_dock_idle);
		end

		f_player_proximity_time_check(5);

		//ANCIENT_EVIL
		dprint("ANCIENT_EVIL");
		sleep_until(volume_test_players(tv_dock_worker), 1);
		if ai_living_count(sq_inf_dock_worker) > 1 and not ai_allegiance_broken(player, human) then
			pup_stop_show(show_dock_idle);
			sleep_until(not pup_is_playing(show_dock_idle), 1);
			show_dock_worker = pup_play_show(pup_wake_ancient_evil);
			sleep_until( not pup_is_playing(show_dock_worker), 1);
			show_dock_idle = pup_play_show(pup_dock_idle);
		end

	until( vehicle_test_players_all(),1);
end
