//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion_mission_cf
//	Insertion Points:	start 	- Beginning
//	ifo		- fodder
//	ija		- jackal alley
//	ici		- citidel exterior
//	iic		- citidel interior
//	ipo		- powercave/ battery room
//	ili		- librarian encounter			
//  ior		- ordnance training					
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// =================================================================================================
// CANNON FODDER
// =================================================================================================
// =================================================================================================

global short s_objcon_fod = 0;
global short s_objcon_citext = 0;
global short s_objcon_lib = 0;
global short s_objcon_ord = 0;
global short s_val_player_loc = 0;
global boolean b_fodder_clear = FALSE;
global boolean b_event_1	= FALSE;
global boolean b_event_2	= FALSE;
global boolean b_intro_grunts_run = FALSE;
global boolean b_citadel_started = FALSE;
global boolean b_snipervalley_started = FALSE;
global boolean b_kami_grunts = FALSE;

global short s_fod_tort_area = 0;





// fodder insertion point --- ifo ---
//spawning the cannon fodder squads
script dormant f_fodder_main()
	data_mine_set_mission_segment ("m40_fodder" );
	wake (f_fodder_control );
	wake (f_fodder_control_tort_control );
	wake (f_fodder_cleanup );
	wake (f_lakeside_enc );
	
	sleep_until( volume_test_players (tv_spawn_cfodder), 1 );

		wake( f_fodder_vo );
		sleep_forever (m40_caves_tort_meet_palmer );
		
		thread( f_spawn_fod_initial() );
		
		sleep(5 );

		game_save_no_timeout();
	
end

script static void f_spawn_fod_initial()
	
	sleep_until( volume_test_players (tv_spawn_tort), 1 );

	object_create_folder (lakeside_crates);
	
	ai_place (front_grunts );
	ai_place (front_jaks ); 
	ai_place (lower_plat_jak );	
	ai_place (tower_jak);
	ai_place (rear_fod_sq );
	ai_place (mid_fod_sq);
	ai_place (rear_fod_turret );	
	
	//object_create (fodder_hidden_ghost_01);
	//object_create (fodder_hidden_ghost_02);
		
	wake (blip_fod);
		
	wake (mid_fod_sq_bonus_close);	
	
	object_wake_physics (dead_lakeside_jackal_01);
	object_wake_physics (dead_lakeside_jackal_02);
	
	object_damage_damage_section (downed_pelican, "engine_lf", 2000);
	
	ai_set_blind (rear_fod_turret, true);
	
	sleep_until (ai_living_count (fod_master) < 4
	or
	s_objcon_fod >= 35);
	
	object_create (lakeside_beam_rifle_rest);

	
	ai_set_blind (rear_fod_turret, false);

end

script dormant blip_fod()
	if
		volume_test_players (tv_spawn_tort)
	then
		sleep_s(3);
		f_blip_flag (fod_encounter_blip_flag_01, "neutralize");
		sleep(20);
		f_blip_flag (fod_encounter_blip_flag_02, "neutralize");
		sleep(20);
		f_blip_flag (fod_encounter_blip_flag_03, "neutralize");
		thread (unblip_fod_by_deaths_front());
		thread (unblip_fod_by_deaths_mid());
		thread (unblip_fod_by_deaths_rear());
	end
end

script static void unblip_fod_by_deaths_front()
	sleep_until (ai_living_count (front_jaks) < 2
	and
	ai_living_count (front_grunts) < 2);
	
	f_unblip_flag (fod_encounter_blip_flag_01);
end

script static void unblip_fod_by_deaths_mid()
	sleep_until (ai_living_count (lower_plat_jak) < 2
	and
	ai_living_count (tower_jak) < 1
	and
	ai_living_count (mid_fod_sq_fill_close) < 1);
	
	f_unblip_flag (fod_encounter_blip_flag_02);
end

script static void unblip_fod_by_deaths_rear()
	sleep_until (ai_living_count (mid_fod_sq) < 2
	and
	ai_living_count (mid_fod_sq_fill_far) < 2);
	
	f_unblip_flag (fod_encounter_blip_flag_03);
end

script dormant mid_fod_sq_bonus_close()
	sleep_until (ai_living_count (fod_master) < 15
	or
	s_objcon_fod > 29
	);
	if
		s_objcon_fod < 30
	then
		ai_place (mid_fod_sq_fill_close);
		print ("mid_fod_sq_fill_CLOSE bonus placed");
	else
		print ("player too far ahead, fod bonus not spawning");
	end
	wake (mid_fod_sq_bonus_far);
end

script dormant mid_fod_sq_bonus_far()
	sleep_until (ai_living_count (fod_master) < 15
	or
	s_objcon_fod > 34
	);
	if
		s_objcon_fod < 35
	then
		ai_place (mid_fod_sq_fill_far);
		print ("mid_fod_sq_fill_FAR bonus placed");
	else
		print ("player too far ahead, fod bonus not spawning");
	end
end

//objective control
script dormant f_fodder_control()
	//dprint("fodder_control:::active" );
	sleep_until( ( volume_test_players ( tv_fod_objcon_10 ) or ( s_objcon_fod >=  10 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  10 ) then 
				dprint(" ::: fod ::: objective control 010" );
				s_objcon_fod = 10;
		end

//		thread(f_mus_m40_e01_begin);

	
	sleep_until( ( volume_test_players ( tv_fod_objcon_20 ) or ( s_objcon_fod >=  20 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  20 ) then 
				dprint(" ::: fod ::: objective control 020" );
				s_objcon_fod = 20;
		end
		//dprint("::: spawning sq_cov_fod_grunts_hiding and sq_cov_fod_jackals_02" );

	sleep_until( ( volume_test_players ( tv_fod_objcon_30 ) or ( s_objcon_fod >=  30 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  30 ) then 
				dprint(" ::: fod ::: objective control 030" );
				s_objcon_fod = 30;
		end

	
	
	garbage_collect_now( );
	
	sleep_until( ( volume_test_players ( tv_fod_objcon_33 ) or ( s_objcon_fod >=  33 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  33 ) then 
				dprint(" ::: fod ::: objective control 033" );
				s_objcon_fod = 33;
		end
			
	sleep_until( ( volume_test_players ( tv_fod_objcon_35 ) or ( s_objcon_fod >=  35 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  35 ) then 
				dprint(" ::: fod ::: objective control 035" );
				s_objcon_fod = 35;
		end
		garbage_collect_now( );
	sleep_until( ( volume_test_players ( tv_fod_objcon_37 ) or ( s_objcon_fod >=  37 )  ), 1 );	
		// -------------------------------------------------
		if ( s_objcon_fod <=  37 ) then 
				dprint(" ::: fod ::: objective control 037" );
				s_objcon_fod = 37;
		end	
	sleep_until( ( volume_test_players ( tv_fod_objcon_40 ) or ( s_objcon_fod >=  40 )  ), 1 );		
		// -------------------------------------------------
		if ( s_objcon_fod <=  40 ) then 
				dprint(" ::: fod ::: objective control 040" );
				s_objcon_fod = 40;
		end

end

script dormant f_fodder_control_tort_control()
	//dprint("fodder_control:::active" );
	//sleep_until( volume_test_object ( tv_fod_objcon_10, sq_fod_lake_tortoise ) or  ( volume_test_object ( tv_fod_objcon_10, tortoise_main ) ), 1 );	
		// -------------------------------------------------
		//dprint("tort 10" );
	
	sleep_until( volume_test_object ( tv_fod_objcon_20, main_mammoth ), 5 );	
		// -------------------------------------------------
		//dprint("tort 20" );
		s_fod_tort_area = 20;

	sleep_until( volume_test_object ( tv_fod_objcon_30, main_mammoth ) , 5 );	
		dprint("tort 30" );	
		s_fod_tort_area = 30;
	sleep_until( volume_test_object ( tv_fod_objcon_33, main_mammoth ) , 5 );	
		dprint("tort 33" );	
		s_fod_tort_area = 33;
		
	sleep_until( volume_test_object ( tv_fod_objcon_35, main_mammoth ) , 5 );	
		dprint("tort 35" );	
		s_fod_tort_area = 35;
	sleep_until( volume_test_object ( tv_fod_objcon_37, main_mammoth ) , 5 );	
		// -------------------------------------------------
		dprint("tort 37" );
		s_fod_tort_area = 37;
	
	sleep_until( volume_test_object ( tv_fod_objcon_40, main_mammoth )  , 1 );		
		// -------------------------------------------------
		dprint("tort 40" );
		s_fod_tort_area = 40;
end

/*//////////////////////////////////////////////////
		GIANT VEHICLE TORTOISE MOVES THROUGH FODDER
*///////////////////////////////////////////////////

script dormant f_fodder_mammoth_playback()
	dprint("f_fodder_mammoth_playback running" );
	sleep_s(1);
	wake (tortoise_lakeside_recorded );
	dprint("MAMMOTH!!!!! Running on Fodder scripts" );
	unit_recorder_set_playback_rate_smooth (main_mammoth, .3, 4 );
	dprint("Tortoise at .3 speed" );
	sleep_until( volume_test_object (tv_fod_objcon_30, main_mammoth), 1);	
	unit_recorder_set_playback_rate_smooth (main_mammoth, .1, 1 );
	dprint("Tortoise at .1 speed" );
	
//	sleep_until( volume_test_object (tv_fod_objcon_33, main_mammoth), 1);	
		if 
			(volume_test_players (tv_tortoise_middle_01)
			or
			volume_test_players (tv_tortoise_bottom_01))
		then
			print ("player inside mammoth, stopping for a moment");
			unit_recorder_pause_smooth (main_mammoth, TRUE, 2 );
			tort_stopped = TRUE;
			sleep_until (not (volume_test_players (tv_tortoise_middle_01))
			and (not (volume_test_players (tv_tortoise_bottom_01))
			)
			or
			ai_living_count (fod_master) < 9
			);	
			sleep_s(6);
			unit_recorder_pause_smooth (main_mammoth, FALSE, 2 );
			tort_stopped = FALSE;
		end	

	print ("player outside mammoth, it continues");
	sleep_until( volume_test_object (tv_fod_objcon_35, main_mammoth)
	or
	ai_living_count (fod_master) < 5
	);	

	f_unblip_flag (fod_encounter_blip_flag_01);
	f_unblip_flag (fod_encounter_blip_flag_02);
	f_unblip_flag (fod_encounter_blip_flag_03);
	
//	sleep_until( volume_test_object (tv_fod_objcon_37, main_mammoth) 
//	or
//	ai_living_count (fod_master) < 7
//	);	

	unit_recorder_set_playback_rate_smooth (main_mammoth, .6, 3 );
	dprint("Tortoise at .6 speed" );

	sleep_until( volume_test_object (tv_fod_objcon_35, main_mammoth), 1);	
	unit_recorder_set_playback_rate_smooth (main_mammoth, .3, 3 );
	dprint("Tortoise at .3 speed" );

	if 
		game_coop_player_count() == 1
	then
		thread (tort_fodder_repeating_speed_test());
		dprint("tort_fodder_repeating_speed_test" );
	end

	sleep_until( volume_test_object (tv_fod_objcon_37, main_mammoth)
	or
	ai_living_count (fod_master) < 2
	);	
	unit_recorder_set_playback_rate_smooth (main_mammoth, .6, 3 );
	dprint("Tortoise at .6 speed" );
end

script static void f_pause_play_tort_playback( real time )
	unit_recorder_pause_smooth (main_mammoth, TRUE, 2 );
		sleep_s( time );
		sleep_until( any_players_in_vehicle() , 1 );
	unit_recorder_pause_smooth (main_mammoth, FALSE, 2 );
end

script dormant f_fodder_cleanup()
	sleep_until( volume_test_players ( tv_lakeside_04 ) , 1 );
		dprint("cleanup fodder" );
		garbage_collect_now( );
end

script static void tort_fodder_repeating_speed_test()
	print ("***************** Fodder Custom Speed Test for Single Player *****************");		
	repeat
		if
			(not (volume_test_players (tv_tortoise_top_01))
			and
			not (volume_test_players (tv_tortoise_middle_01))
			and
			not (volume_test_players (tv_tortoise_bottom_01))
			and
			objects_distance_to_object (player0, main_mammoth) < 20)
		then
			unit_recorder_set_playback_rate_smooth (main_mammoth, .1, 3);		
			print ("Player on the ground near the Tortoise...");
			print ("TORT SPEED REPEATING = .1");

		elseif
			(volume_test_players (tv_tortoise_top_01)
			or
			volume_test_players (tv_tortoise_middle_01)
			or
			volume_test_players (tv_tortoise_bottom_01))
		then
			unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 4);
			print ("Player on the Tortoise...");
			print ("TORT SPEED REPEATING = .2");
			
		elseif
			(not (volume_test_players (tv_tortoise_top_01))
			and
			not (volume_test_players (tv_tortoise_middle_01))
			and
			not (volume_test_players (tv_tortoise_bottom_01))
			and
			objects_distance_to_object (player0, main_mammoth) > 20)
		then

			if
				objects_distance_to_point (player0, tort_top_patrol.rear) > objects_distance_to_point (player0, tort_top_patrol.front)
			then
				unit_recorder_set_playback_rate_smooth (main_mammoth, .7, 4);		
				print ("Player really far ahead of Tortoise...");
				print ("TORT SPEED REPEATING = 1.2");
			elseif
				objects_distance_to_point (player0, tort_top_patrol.rear) < objects_distance_to_point (player0, tort_top_patrol.front)
			then
				unit_recorder_set_playback_rate_smooth (main_mammoth, .1, 4);		
				print ("Player really far behind of Tortoise...");
				print ("TORT SPEED REPEATING = .1");
			end
			
		else
			print ("Tort Speed Test unsure what to do. Where's the Tortoise?");		
		end
		
		sleep (30 * 4);
		
	until (volume_test_object (tv_tort_jackal, main_mammoth), 1);		
	print ("Tort Fodder Speed Test Done");
end

// =================================================================================================
// =================================================================================================
// DEBUG
// =================================================================================================
// =================================================================================================

// =================================================================================================
// =================================================================================================
// VO 
// =================================================================================================
// =================================================================================================

script dormant f_fodder_vo()
	sleep(1 );			
end
