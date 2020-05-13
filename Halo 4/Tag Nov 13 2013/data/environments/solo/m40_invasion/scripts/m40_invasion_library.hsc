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
global boolean b_librarian_enc = FALSE;
global real r_lib_fast_door_time = 20;
global boolean b_turret_door_closed = TRUE;

global boolean b_lib_exit_audio_done = FALSE;
global boolean b_lib_exit_audio_started = FALSE;
global boolean b_lib_exit_dialog_started = FALSE;
global long cort_show = 0;



// =================================================================================================
// =================================================================================================
// Liberry
// =================================================================================================
// =================================================================================================

script static void lib_debug()
	wake( f_librarian_main );
end

script dormant f_librarian_main()
	zone_set_trigger_volume_enable("begin_zone_set:zone_set_ele_epic", FALSE);
	zone_set_trigger_volume_enable("zone_set:zone_set_ele_epic", FALSE);
	sleep_until( current_zone_set_fully_active() >= DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE(), 1 );
	//sleep_until( volume_test_players (tv_librarian_entrance), 1 );
	//wake(f_vale_domain_press);
   effect_new (environments\solo\m40_invasion\fx\energy\librarian_beam.effect, fx_librarian_beam );
	ai_place (falsetana);
	object_set_scale (object_get_ai(falsetana), 4, 0);
	sleep(1);
		data_mine_set_mission_segment ("m40_librarian" );
		wake( f_lib_crates_init );
		wake (m40_collect_cortana_resistance );
		wake( f_valley_cleanup );
//		thread( f_redlight_on( citadel_lib_exit  ) );
		ai_lod_full_detail_actors( 17 );
		b_testturret = TRUE;
//		thread( storyblurb_display(ch_blurb_lib_cort , 5, FALSE, FALSE) );
		sleep(5 );
		wake( f_librarian_vo );
		b_librarian_enc = TRUE;
		f_unblip_flag ( fg_cavern_route );
		object_create(bt_cortana_librarian );
		game_save_no_timeout( );
		wake( f_lib_objcon_controller );
		kill_volume_enable(kill );
		thread(f_see_cortana());
//		object_destroy(lib_false_cortana );
	object_create(dm_pull_into_beam);
	//sleep(15);
	
	sleep_until( volume_test_players (tv_cortana_beam_cut), 1 );	
	object_hide (falsetana, 1);
	cortana_rampancy_set(0);
	dprint("CUTSCENE" );	
		
	chud_cinematic_fade (0, 30 );
	//sleep_s(1.5 );
	cinematic_show_letterbox (TRUE);
	cinematic_enter( cin_m041_librarian, TRUE );
	switch_zone_set( cin_m041_librarian );
	local long librarian_bink_thread = thread( f_librarian_bink() );
	f_play_cinematic_chain( cin_m041_librarian, cin_m041b_librarian , cin_m041c_librarian, TRUE );
	kill_thread( librarian_bink_thread );

	volume_teleport_players_not_inside(tv_lib_all, fg_tp_to_lib);
	f_insertion_zoneload( DEF_S_ZONESET_LIBRARIAN_VALE(), TRUE );
	object_destroy(dm_pull_into_beam);

	//cinematic_exit( cin_m041c_librarian, TRUE );

	// unrolled from cinematic_exit
	cinematic_exit_pre (TRUE);
	players_hide( -1, TRUE ); // hide the players again
	cinematic_exit_post_keep_letterbox (TRUE);

	g_ics_player = player_get_first_alive();
	
	ai_erase (cavern_sentinels);
	ai_erase (cavern_sentinels_2);
	ai_erase (cavern_sentinels_3);
	ai_erase (cavern_sentinels_4);
	ai_erase (cavern_sentinels_5);
	ai_erase (monitor_kip);

  effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\librarian_beam.effect, fx_librarian_beam );   
	interpolator_start (librarian_light_off);
	local long show = pup_play_show(chief_gift_pup);
//	effect_new (environments\solo\m40_invasion\fx\energy\librarian_beam.effect, fx_librarian_beam );
	effect_kill_from_flag (environments\solo\m40_invasion\fx\energy\librarian_beam.effect, fx_librarian_beam );
	effect_new (environments\solo\m40_invasion\fx\energy\librarian_chief_mutation.effect, fx_librarian_beam );
	thread( f_close_library_lockin() );
	cinematic_tag_fade_in_to_game (cin_m041c_librarian);
	cinematic_show_letterbox (FALSE);
	sleep_until(not pup_is_playing(show),1);

	//Librarian Beam Inactive
  effect_new (environments\solo\m40_invasion\fx\energy\librarian_beam_inactive.effect, fx_librarian_beam );

	players_hide( -1, FALSE );

//		player_disable_movement(TRUE );

		ai_erase( gr_cave_turrets );
//		sleep_s(10 );
//		wake (m41_librarian_cutscene );
//		player_action_test_reset( );
//		player_disable_movement(FALSE );
//		sleep_until( player_action_test_cancel() == TRUE, 1 );
		
		objectives_finish (2);
		objectives_show (3);
		
		wake( f_spawn_liberry_baddies );
		wake(f_dialog_m40_cortana_chief_reunite);
		
//	fade_in(255,255,255,10 );
		chud_cinematic_fade (1, 30 );
		//sleep(30 );
//		cinematic_show_letterbox (FALSE );
		
		game_save( );
		
		sleep_s(1.5 );
		thread( f_get_cortana_interact() );
		sleep_s(1 );
		
		thread(f_mus_m40_e08_begin());
		wake (library_music_end);

end

script static void f_librarian_bink()
	sleep_until(bink_is_playing() == TRUE, 1);
	sleep_s(12);
	cinematic_subtitle( C_M41_00700, 12.2 ); // "Librarian: Mankind spread into the stars with an unexpected, desperate violence. Entire systems fell before the Didact's Warrior. Servants rose to halt the aggression."
	sleep_s(24.1);
	cinematic_subtitle( C_M41_00800, 6.9  ); // "Librarian: When the Didact finally exhausted the humans after a millenia, his sentence was severe."
	sleep_s(9.4);
	cinematic_subtitle( C_M41_00900, 4.4  ); // "Librarian: We had no way of knowing that the Forerunners were not your only enemy."
	sleep_s(6.2);
	cinematic_subtitle( C_M41_01000, 4.8  ); // "Librarian: Humanity hadn't been expanding. They were running."
	sleep_s(7);
	cinematic_subtitle( C_M41_01100, 5.3  ); // "Librarian: Weakened from our conflict, we were no match for the parasite which pursued you."
	sleep_s(7);
	cinematic_subtitle( C_M41_01200, 14.1 ); // "Librarian: The Forerunners made plans for a final, great journey. But the Didact refused to yield our Mantle of Responsibility. He would save all life in the galaxy... at a cost."
	sleep_s(15.7);
	cinematic_subtitle( C_M41_01300, 10  ); // "Librarian: In the Forerunners' quest for transcendence, the Composer had been intended to bridge the organic and digital realms. It would have made us immortal."
	sleep_s(13.4);
	cinematic_subtitle( C_M41_01500, 10.8 ); // "Librarian: But its results soured. The stored personalities fragmented, and our attempts to return them to biological states created only abominations."
	sleep_s(12.7);
	cinematic_subtitle( C_M41_01600, 3.3  ); // "Librarian: Such moral concerns faded from the Didact's attention."
	sleep_s(6);
	cinematic_subtitle( C_M41_01700, 2.5  ); // "Librarian: The Flood only assimilated living tissue."
	sleep_s(4.5);
	cinematic_subtitle( C_M41_01800, 5.2  ); // "Librarian: The Composer would provide the Didact his solution... and his revenge."
end

script static void f_see_cortana()
	sleep_until(volume_test_players_lookat(tv_see_cort, 35, 6), 1);
	sleep(30);
	cortana_rampancy_set(.8);
	sleep(30);
	object_hide (falsetana, 1);
	cortana_rampancy_set(0);
	thread( f_lib_bigshake() );
end

script dormant f_lib_crates_init()
	object_create_folder(lib_crates );
end

script dormant f_lib_crates_cleanup()
	object_destroy_folder(lib_crates );
end

script static void f_lib_bigshake()
	camera_shake_all_coop_players( 0.65, 0.65, 2, 2, library_camera_shake );
end

script command_script cs_lib_boss()
	sleep_s(2.5 );
	cs_phase_to_point( pts_lib_phase.p0 ) ;
	sleep(1 );
end

script command_script cs_lib_reserve()
	sleep_s(1 );
	cs_phase_to_point( pts_lib_phase.p1 ) ;
	sleep(1 );
end


script command_script cs_lib_knight_1()
	sleep(10 );
	cs_phase_to_point( pts_lib_phase.p2 ) ;
	sleep(1 );
end


script command_script cs_lib_knight_2()
	cs_phase_to_point( pts_lib_phase.p3 ) ;
	sleep(1 );
end

script command_script cs_lib_legend_1()
	sleep_rand_s(4,6 );
	cs_phase_to_point( pts_lib_phase.p5 ) ;	
	sleep(1 );
end

script command_script cs_lib_legend_2()
	sleep_rand_s(3,5 );
	cs_phase_to_point( pts_lib_phase.p4 ) ;
	sleep(1 );
end


script static void f_close_library_lockin()

	object_move_by_offset ( sn_lib_door_lg_lockin_a, 0.1, 0, 0, -2.0 );
	if not b_turret_door_closed then 
		b_turret_door_closed = TRUE;
//		object_move_by_offset ( sn_pcave_turret_door, 0.1, 0, 0, -2.0 );
		device_set_power (grotto_door, 1 );
		
//		thread( f_redlight_on( sn_pcave_turret_door  ) );
	end
end

script dormant f_lib_objcon_controller()



	sleep_until( volume_test_players (tv_lib_objcon_10) or s_objcon_lib >= 10, 1 );
		if s_objcon_lib <= 10 then
			s_objcon_lib = 10;
			dprint("s_objcon_lib = 10 " );
		end
	
	sleep_until( volume_test_players (tv_lib_objcon_20) or s_objcon_lib >= 20, 1 );
		if s_objcon_lib <= 20 then	
			s_objcon_lib = 20;
			dprint("s_objcon_lib = 20 " );
		end

	game_save_no_timeout( );

	sleep_until( volume_test_players (tv_lib_objcon_25) or s_objcon_lib >= 25, 1 );
		if s_objcon_lib <= 25 then
			s_objcon_lib = 25;
			dprint("s_objcon_lib = 25 " );
		end

	sleep_until( volume_test_players (tv_lib_objcon_30) or s_objcon_lib >= 30, 1 );
		if s_objcon_lib <= 30 then
			s_objcon_lib = 30;
			dprint("s_objcon_lib = 30 " );
		end

	sleep_until( volume_test_players (tv_lib_objcon_40) or s_objcon_lib >= 40, 1 );
		if s_objcon_lib <= 40 then
			s_objcon_lib = 40;
			dprint("s_objcon_lib = 40 " );
		end

end

script static void f_get_cortana_interact()
	sleep(30* 4 );	
	f_blip_object (bt_cortana_librarian, "activate" );
	//object_create (lib_cortana);
	//effect_new (objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, lib_cortana_plinth); 
	//ai_place (lib_cortana_2);
	effect_new (objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, lib_cortana_plinth); 
	//object_set_scale (lib_cortana_2 , .1, 0 );
  cort_show = pup_play_show(lib_cortana_show);
  //object_set_scale (lib_cortana_2 , 1, 10);
	NotifyLevel("liberry cortana active" );
	wake (cortana_late_get );
	wake (f_del_rio_elevator_dialog);
	
	sleep_until( device_get_position(bt_cortana_librarian) != 0,1 );
	device_set_power(bt_cortana_librarian, 0);
		f_unblip_object (bt_cortana_librarian );
		effect_new (objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, lib_cortana_plinth); 
		sleep(2);
		thread(f_global_cortana_hide(lib_cortana_2));
		ai_erase (lib_cortana_2);
		effect_delete_from_flag (objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, lib_cortana_plinth);
			cui_hud_set_objective_complete("chapter_095");
		switch_zone_set ("zone_set_librarian_vale" );
		sleep(30*3 );
		NotifyLevel ("got cortana back in librarian" );
		print("activating door function");
		thread( f_open_liberry_door_exit() );
end

script dormant f_del_rio_elevator_dialog()
	sleep_until( ai_living_count (sg_librarian) < 1 );
	sleep_s(2);
	/*if b_lib_exit_dialog_started == FALSE then
		wake (f_dialog_elevator_delrio);
	end*/
end

script dormant cortana_late_get()
	sleep_s( 7 );
	sleep_until( ai_living_count (sg_librarian) < 1 );
	if (device_get_position(bt_cortana_librarian) == 0) then
		//wake (f_dialog_m40_retrieve_cortana );
		pup_stop_show(cort_show);
		pup_play_show(lib_cortana_show_2);
		print ("f_dialog_m40_retrieve_cortana" );
	else
		sleep(1 );
	end
end

script dormant library_music_end()
	sleep_s (3);
	
	sleep_until( ai_living_count (gr_lib_all) > 0);
	
	sleep_until( ai_living_count (gr_lib_all) < 1
	or
	volume_test_players (tv_librarian_exit), 1
	);
	
	thread(f_mus_m40_e08_finish()); 
end

script dormant f_spawn_liberry_baddies()
	dprint("spawn baddies" );

	ai_place (sq_rush);
	ai_disregard(ai_actors(monitor_kip), TRUE);
	ai_disregard(ai_actors(cavern_sentinels), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_2), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_4), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_5), TRUE);
	sleep (30 * 1);
	
	ai_place (sg_librarian);
	ai_disregard(ai_actors(monitor_kip), TRUE);
	ai_disregard(ai_actors(cavern_sentinels), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_2), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_4), TRUE);
	ai_disregard(ai_actors(cavern_sentinels_5), TRUE);
	
	/*wake( f_lib_legend );
	
		sleep_until(
			ai_spawn_count ( gr_lib_all ) > 0 and 
			ai_living_count ( gr_lib_all ) <= 0
		, 1 );
		
		r_lib_fast_door_time = 10;*/
		
		game_save_no_timeout( );
end
script command_script just_phase_in

	cs_phase_in();
	
end

/*script dormant f_lib_legend()
	//inspect(difficulty_legendary() );
	if (difficulty_legendary() or game_is_cooperative() ) then
		sleep_until(
			ai_spawn_count ( gr_lib_pawn_rush ) > 0 and 
			ai_living_count ( gr_lib_pawn_rush ) <= 0		
		,1 );
		print("about to spawn legend knights" );
		sleep_rand_s(2,7 );
		
		ai_place( sq_for_knight_extra_legend_b );
		ai_place( sq_for_knight_extra_legend_a );
	end


end*/

// activated when player picks up cortana
script static void f_open_liberry_door_exit()

	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_LIBRARIAN_VALE(), 1 );
	
//		thread( f_greenlight_on( citadel_lib_exit  ) );
		//object_move_by_offset ( sn_liberry_door_exit, 4, 0, 0, 1.3 );
	
		//device_set_power (citadel_lib_exit, 1 );
		citadel_lib_exit->open();
		wake( f_lib_exit_doors );
		print("waking vaters");
		wake( f_lib_elevator_2 );	
		//object_create(sn_rear_ord_door );
		sleep(5 );
		
		//print("OPENING DOOOORS NAO");
//		thread( f_open_resetting_door( tv_rear_ord_door, sn_rear_ord_door ) );

end

script dormant f_lib_exit_doors()
	//sleep_until( volume_test_players (tv_librarian_exit), 1 );	// player walks through librarian exit
	
		citadel_lib_exit->auto_trigger_close(tv_librarian_exit, FALSE, TRUE, TRUE); // close the door behind the player
		sleep_until( citadel_lib_exit->check_close(), 1 );
		
		// start streaming in next zone set once the door is completely close
		// zone set switch will be completed when player exits the elevator
		volume_teleport_players_not_inside(tv_librarian_exit, fg_tp_lib_ele);
		sleep(1);
		zone_set_trigger_volume_enable("begin_zone_set:zone_set_ele_epic", TRUE);
		//prepare_to_switch_to_zone_set( f_zoneset_get(DEF_S_ZONESET_ELE_EPIC()) );
		wake (f_lib_elevator_exit); // waits for player to reach bottom of elevator
	
//		f_blip_object (bt_librarian_elevator_door, "activate" );
//		sleep_until( device_get_position(bt_librarian_elevator_door) != 0 );
//			f_unblip_object (bt_librarian_elevator_door );
			
//			sleep(10 );
//			wake( f_lib_elevator_2 );				
//			object_move_by_offset ( sn_lib_door_elevator, r_lib_fast_door_time, 0, 0, 3 );		
//			sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_gun_door', sn_liberry_door_exit, 1 );

			//sleep_s( 2 );
end


script dormant f_lib_elevator_2()
//	f_blip_object (bt_lib_elevator_activate, "activate" );
//	sleep_until( device_get_position(bt_lib_elevator_activate) != 0 );
//		f_unblip_object (bt_lib_elevator_activate );		

	// wait for player to enter the elevator
	b_lib_exit_dialog_started = TRUE;
	sleep_until( volume_test_players (tv_lib_elevator_2), 1 );
		
		thread (teleport_show_sc());
		
		sleep(30 );
		wake( f_cleanup_lib );
		wake (m40_elevator_to_ord_talk );

		thread (teleport_players_in_elevator_2());
		
		local long lib_ele = pup_play_show(lib_elevator);

		print("elevator show starting");
		sleep_until(not pup_is_playing(lib_ele));
		sleep_until(not PreparingToSwitchZoneSet(), 1); 
		zone_set_trigger_volume_enable("zone_set:zone_set_ele_epic", TRUE);
		//object_move_to_flag(librarian_elevator_1,25,fg_elevator_2_top );
end

script static void teleport_show_sc()
	sleep_until( volume_test_players (tv_elev_2_exit), 1 );
	pup_play_show(lib_portal_pup);
end

script static void teleport_players_in_elevator_2()

	sleep_until (volume_test_players (tv_players_in_elevator_2), 1);
	
	print ("elevator teleport!");

	if
		volume_test_object (tv_players_in_elevator_2_whole, player0)
	then
			object_teleport (player0, elevator_teleport_01c);
	end
	
	if
		volume_test_object (tv_players_in_elevator_2_whole, player1)
	then
			object_teleport (player1, elevator_teleport_02c);
	end
	
	if
		volume_test_object (tv_players_in_elevator_2_whole, player2)
	then
			object_teleport (player2, elevator_teleport_03c);
	end
	
	if
		volume_test_object (tv_players_in_elevator_2_whole, player3)
	then
			object_teleport (player3, elevator_teleport_04c);
	end
end

// woken when the player enters the library elevator
script dormant f_lib_elevator_exit()
	sleep_until(volume_test_players(tv_lib_elevator_exit), 1); // wait for player to exit elevator
	
	// when the player reaches the hall at the bottom of the elevator, see if the next zone set has finished loading
	// sleep_until (not preparingToSwitchZoneSet(), 1); // poll whether async load is complete
//	f_insertion_zoneload( DEF_S_ZONESET_ELE_EPIC(), TRUE );
	
	// activate the teleporter at the end of the hall
	wake(f_epic_zoneload);
	
	thread (lib_teleport_start() );
	//effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, pts_teleport_lib.p0);
end

script dormant f_cleanup_lib()
	sleep(120 );
	ai_erase(gr_lib_all );
	wake( f_lib_crates_cleanup );
//	wake (ordnance_chapter_title );
//	wake (ordnance_convoy );
	garbage_collect_now( );
end

script static void f_open_resetting_door( trigger_volume tv, object door)
	sleep_until( volume_test_players ( tv ), 1 );
		dprint("opening exit door" );
		sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_gun_door', door, 1 );
		object_move_by_offset ( door, 1.5, 0, 0, 1.1 );	
		sleep(1 );
		thread( f_close_resetting_door( tv, door ) );
end

script static void f_close_resetting_door(trigger_volume tv, object door)
		sleep_s(4 );
		sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_gun_door', door, 1 );
		object_move_by_offset ( door, 1.5, 0, 0, -1.1 );	
		thread( f_open_resetting_door( tv, door ) );
end

// this script is probably in the wrong place but I'm not sure where to put it
// It is for the trigger volume right after the player is teleported out of the library
script dormant f_epic_zoneload()
	sleep_until(volume_test_players ( tv_epic_zoneload ), 1 );
	
	// start zone set switch. It is unfortunate that this has to be done during combat :(
	prepare_to_switch_to_zone_set( f_zoneset_get(DEF_S_ZONESET_EPIC()) );
	
	// sleep_until (not preparingToSwitchZoneSet(), 1); // poll whether async load is complete
	f_insertion_zoneload( DEF_S_ZONESET_EPIC(), TRUE );
	sleep_until (current_zone_set_fully_active() == DEF_S_ZONESET_EPIC());	
	
	effect_new (environments\solo\m40_invasion\fx\energy\tractor_beam.effect, fx_tractor_base );
end

/*
script dormant f_vale_domain_press()
	sleep_until (object_valid (vale_terminal_button), 1);
	sleep_until (device_get_position(vale_terminal_button) > 0.0, 1 );
	pup_play_show(domain_press);
end
*/
// =================================================================================================
// =================================================================================================
// VO 
// =================================================================================================
// =================================================================================================

script dormant f_librarian_vo()

	//move to post cinematic	after grabbing cortana
	sleep_until( LevelEventStatus ("liberry cortana active"), 1		 );
		// 148 : Chief! Up here!
//		storyblurb_display(ch_blurb_librarian_post , 3, FALSE, FALSE );
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06300', NONE, 1 );
	//	sleep (30 * 2 );
		
	sleep_until( LevelEventStatus ("got cortana back in librarian"), 1		 );		
		// 149 : Are you alright?
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_06400', NONE, 1 );
	//	sleep (30 * 1 );
		 
		
		// 150 : I’ll be better once you convince your ancestors to stop shooting at us!
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06500', NONE, 1 );
		//sleep (30 * 4 );
	
	sleep_until( volume_test_players (tv_rear_ord_elevator), 1		 );	
		b_lib_exit_audio_started	= TRUE;
		// 151 : I’m reading our folks just outside. Guess they got through that ravine in one piece.
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06600', NONE, 1 );
	//	sleep (30 * 5 );		
		
		// 152 : Palmer to Master Chief. Welcome back. We’ve just been ‘admiring’ your handiwork.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Palmer_06700', NONE, 1 );
		//sleep (30 * 5 );
		
		// 153 : Chief, this is Del Rio. With those guns off-line, we’re cleared for close air support all the way to the gravity well, but get on it - whatever you did down there pissed the natives off something fierce. We’re taking a beating up here.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Del_Rio_06800', NONE, 1 );
	//	sleep (30 * 11 );
		
		// 154 : Affirmative, Infinity. Moving on to gravity well now.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06900', NONE, 1 );
		//sleep (30 * 3 );
		
		b_lib_exit_audio_done = TRUE;
end










// =================================================================================================
// =================================================================================================
// ORDNANCE TRAINING
// =================================================================================================
// =================================================================================================


/*global short m40_OrdnanceClump = 14;
global boolean b_ord_moveout	= FALSE;
global boolean b_ord_leader_dead = FALSE;
global boolean b_convoy_retreat = FALSE;
global boolean b_ord_training_complete = FALSE;
global ai ai_ord_gauss_driver = NONE;
global boolean b_ord_hog_1_dropped = FALSE;
global boolean b_ord_hog_2_dropped = FALSE;
global real MAX_ORD_COV_WRAITH_SPEED = 0.28;

script dormant ordnance_convoy()
	sleep_until( volume_test_players (tv_ord_citadel_exit), 1 );
		data_mine_set_mission_segment ("m40_ordnance" );
		wake( f_destroy_sniper_val_crates );
		thread( m40_infinity_main() );
		garbage_collect_now( );
		object_destroy( cannon );
		object_destroy( cannon_2 );
		thread( f_chapter_10() );
		wake( f_ordnance_vo );
//		wake (epic_approach_dialogue );
		wake (epic_main_script );
		wake (epic_obj_control );
		wake (epic_secondary_script );
		wake (epic_tertiary_script );
		wake (blip_last_epic_wraith );
		wake (backup_ending_script );
		wake (m40_convoy_dialogue );
		wake (m40_convoy_dialogue_2 );

		//object_create(dm_ss_infinity );

		print (":::convoy::" );
		game_save( );
		ai_lod_full_detail_actors( 22 );
		wake( f_spawn_pelicans );
//		ai_place( sq_tort_ord );
		object_create (main_mammoth_2 );
		object_cannot_take_damage (main_mammoth_2 );
		print ("Ordnance Tortoise cannot take damage" );
		sleep(5 );
//		unit_recorder_load( m40_sq_tort_ord );
//		unit_recorder_play_on_unit(ai_vehicle_get_from_squad(sq_tort_ord,0) );
		unit_recorder_setup_for_unit (main_mammoth_2, main_mammoth_12_11_11_p2 );
		unit_recorder_play (main_mammoth_2 );
		sleep (1 );
		unit_recorder_pause (main_mammoth_2, TRUE );
		vehicle_set_player_interaction (main_mammoth_2, "mac_d", FALSE, FALSE );
		vehicle_set_player_interaction (main_mammoth_2, "warthog_d", FALSE, FALSE );
		wake( f_ord_mammoth_controller );
		
		//sleep(5 );
		//ai_place( sq_unsc_tort_marines );
		ai_place( sq_unsc_ord_mong );
		
		garbage_collect_now( );
		sleep(10 );
		//ai_place( sq_cov_ord_wraith_leader );
		wake( f_ord_objcon_controller );

		sleep(20 );
		wake( f_ord_spawn_flyby_phantom );
		wake( f_failsafe_moveout );
		wake( f_ordnance_phantom_event );
		//wake( f_blip_ordnance_moveout );
		
		sleep_until( volume_test_players (tv_epic_01), 1 );
			game_save( );
			dprint( "passing marines to epic" );
			ai_set_objective(sq_unsc_ord_hog_drop_1, epic_marine_convoy_obj );
			ai_set_objective(sq_unsc_ord_hog_drop_2, epic_marine_convoy_obj );
			ai_set_objective(sq_unsc_ord_mong, epic_marine_convoy_obj );
			ai_set_objective(gr_ord_human, epic_marine_convoy_obj );
end

script dormant f_spawn_pelicans()
	sleep_until( s_infinity_progress >= 3 , 1 );
		ai_place( sq_unsc_ord_pelican_1 );
		object_hide(sq_unsc_ord_pelican_1 , TRUE );
		sleep_s(6 );
		ai_place( sq_unsc_ord_pelican_2 );
		object_hide(sq_unsc_ord_pelican_2 , TRUE );

end

script static void f_chapter_10()
	sleep_s(10 );

	sound_impulse_start( sound\game_sfx\ui\transition_beeps, NONE, 1 );

	cinematic_set_title (chapter_10 );

end

script dormant ordnance_chapter_title()
	sleep_until( volume_test_players (tv_chapter_title_ord), 1 );
	cinematic_show_letterbox (TRUE );
	sleep (30 * 1 );
	thread( storyblurb_display(leadin_title_ord, 8, FALSE, FALSE) );
	sleep (30 * 6 );
	cinematic_show_letterbox (FALSE );
	end

script dormant f_ordnance_training_main()
	game_save( );
end

script dormant f_failsafe_moveout()

	sleep_until( b_ord_hog_2_dropped, 1 );	
		sleep_until( volume_test_players ( tv_ord_move_out ) or any_players_in_vehicle(), 1 );
			dprint("::: player is moving on" );
			b_ord_moveout = TRUE;
			ai_set_objective( sq_unsc_ord_hog_drop_1, obj_marine_ord );
			ai_set_objective( sq_unsc_ord_hog_drop_2, obj_marine_ord );		
end



script dormant f_blip_ordnance_moveout()
	sleep_until( b_ord_moveout , 1 );
		dprint("blip move out spot" );
		sleep_s(2 );
		f_blip_flag ( fg_ord_move_out, "default" );
	//sleep_until( s_objcon_ord >= 10, 1 );
	//	f_unblip_flag ( fg_ord_move_out );
		//f_blip_flag ( fg_ord_move_out, "default" );
	sleep_until( s_objcon_ord >= 20, 1 );
		f_unblip_flag ( fg_ord_move_out );
end

script dormant f_blip_ordnance_moveout2()
	f_blip_flag ( fg_ord_move_out_2, "default" );
	f_unblip_object (ai_ord_gauss_driver );
	sleep_until( epic_obj_state > 9 );
		f_unblip_flag ( fg_ord_move_out_2 );
end

script dormant f_ord_mammoth_controller()

	sleep(1 );
	//dprint("wait mammoth" );
	sleep_until( b_ord_hog_2_dropped, 1 );			
		sleep_until(volume_test_players(tv_tortoise_top_01) or b_ord_moveout , 1 );
		sleep(120 );
	unit_recorder_pause_smooth (main_mammoth_2, FALSE, 2 );
		//dprint("go mammoth" );
	sleep_until( volume_test_object (tv_ord_mammoth_10, main_mammoth_2) , 1 );
		//dprint("wait mammoth" );
	unit_recorder_pause_smooth (main_mammoth_2, TRUE, 2 );
		unit_recorder_set_playback_rate_smooth (main_mammoth_2, .5, 1 );
		//f_pause_play_tort_playback( 5 );		
	sleep_until( b_ord_training_complete and any_players_in_vehicle(), 1 );
		sleep(60 );
	unit_recorder_pause_smooth (main_mammoth_2, FALSE, 2 );
	wake (epic_tortoise_recorded );
	wake (epic_tort_arrival_guarantee );
		//dprint("go mammoth" );
end


//script command_script cs_ord_tortoise()
//	cs_vehicle_speed (0.6 );
//	ai_braindead(object_get_ai(sq_tort_ord) ,TRUE );
//
//end


script command_script cs_ord_gauss_hog_drop_1()
		ai_ord_gauss_driver = f_ai_get_vehicle_driver ( sq_unsc_ord_hog_drop_1 );
		sleep(1 );
		sleep_until( b_ord_hog_1_dropped == TRUE );			
			sleep_s(2 );
			ai_ord_gauss_driver = f_ai_get_vehicle_driver ( sq_unsc_ord_hog_drop_1 );
			ai_vehicle_exit ( ai_ord_gauss_driver );
			wake( f_ord_reserve_hog_1_seat );
			ai_vehicle_enter(ai_ord_gauss_driver, ai_vehicle_get_from_squad (sq_unsc_ord_hog_drop_1, 0), "warthog_p" );
end

script dormant f_ord_reserve_hog_1_seat()
	ai_vehicle_reserve_seat (ai_vehicle_get_from_squad (sq_unsc_ord_hog_drop_1, 0), "warthog_d", TRUE );
	sleep_until( any_players_in_vehicle() or b_ord_moveout == TRUE,1 );
		ai_vehicle_reserve_seat (ai_vehicle_get_from_squad (sq_unsc_ord_hog_drop_1, 0), "warthog_d", FALSE );
end

script command_script cs_ord_war_dog()
		sleep(1 );
		sleep_until( b_ord_hog_2_dropped == TRUE, 1 );	
			sleep(45 );
			dprint("wardog 2 dropped" );
			cs_go_to( pts_ord_marines.p_wardog );
end

script command_script cs_ord_wraith_1()
	//dprint("slow down" );
	sleep(5 );
	cs_vehicle_speed ( MAX_ORD_COV_WRAITH_SPEED );
	cs_vehicle_boost ( FALSE );
	cs_go_to_and_face (pts_ord.pt_wraith_1, pts_ord.pt_WraithLeaderPostion );
	ai_braindead(ai_current_actor ,TRUE );
	sleep(1 );

end

script command_script cs_ord_wraith_2()

	sleep(5 );
	cs_vehicle_speed ( MAX_ORD_COV_WRAITH_SPEED );
	cs_vehicle_boost ( FALSE );

	cs_go_to_and_face (pts_ord.pt_wraith_4, pts_ord.pt_WraithLeaderPostion );
	ai_braindead(ai_current_actor ,TRUE );		
end

script command_script cs_ord_wraith_3()

	sleep(5 );
	cs_vehicle_speed ( MAX_ORD_COV_WRAITH_SPEED );
	cs_vehicle_boost ( FALSE );

	cs_go_to_and_face (pts_ord.pt_wraith_2, pts_ord.pt_WraithLeaderPostion );
	ai_braindead(ai_current_actor ,TRUE );
end

script command_script cs_ord_wraith_4()
	sleep(5 );
	cs_vehicle_speed ( MAX_ORD_COV_WRAITH_SPEED );
	cs_vehicle_boost ( FALSE );

	cs_go_to_and_face (pts_ord.pt_wraith_4, pts_ord.pt_WraithLeaderPostion );
	ai_braindead(ai_current_actor ,TRUE );
end

script command_script cs_ord_ghost()
	sleep(5 );
	cs_vehicle_speed (0.5 );
	cs_vehicle_boost ( TRUE );
	// (TRUE, pts_ord.pt_WraithLeaderPostion );
	//ai_braindead(ai_current_actor ,TRUE );
	
	//sleep_until( volume_test_players (tv_ord_objcon_10), 1 );
		//ai_braindead(ai_current_actor ,FALSE );
end

script command_script cs_ord_ghost_1()
	sleep(30 );
	cs_vehicle_speed ( 0.5 );
	cs_vehicle_boost ( TRUE );

	//cs_go_to (pts_ord.pt_ghost_1 );
	//sleep_s(2 );
	//ai_braindead(ai_current_actor ,TRUE );
end

script command_script cs_ord_ghost_2()
	sleep(5 );
	cs_vehicle_speed ( 0.5 );
	cs_vehicle_boost ( TRUE );

	//cs_go_to_and_face (pts_ord.pt_ghost_2, pts_ord.pt_WraithLeaderPostion );
	//sleep_s(2 );
	//ai_braindead(ai_current_actor ,TRUE );
end

script command_script cs_ord_ghost_3()
	sleep(30 );
	cs_vehicle_speed ( 0.5 );
	cs_vehicle_boost ( TRUE );

	//cs_go_to_and_face (pts_ord.pt_ghost_3, pts_ord.pt_WraithLeaderPostion );
	//sleep_s(2 );
	//ai_braindead(ai_current_actor ,TRUE );
end

script command_script cs_ord_ghost_4()
	sleep(5 );
	cs_vehicle_speed ( 0.5 );
	cs_vehicle_boost ( TRUE );

	//cs_go_to_and_face (pts_ord.pt_ghost_4, pts_ord.pt_WraithLeaderPostion );
	//sleep_s(2 );
end



script command_script cs_ord_wraith_leader()

	cs_vehicle_speed (0.01 );
	sleep(1) ;
	ai_place( ai_current_actor );
	ai_braindead(ai_current_actor ,TRUE );
	ai_set_blind (ai_current_actor, TRUE );
	cs_vehicle_boost ( FALSE );	

end



script dormant f_ord_objcon_controller()

	sleep_until( volume_test_players ( tv_ord_hopon_vo ) or s_objcon_ord >= 5, 1 );
		if s_objcon_ord <= 5 then 
			s_objcon_ord = 5;
		end
		dprint("s_objcon_ord = 5 " );
		//sleep_s(3 );

	sleep_until( volume_test_players (tv_ord_objcon_10) or s_objcon_ord >= 10, 1 );

		if s_objcon_ord <= 10 then 
			s_objcon_ord = 10;
		end
		dprint("s_objcon_ord = 10 " );

		ai_place( sq_cov_ord_wraith_leader );		
		sleep(10 );
		wake( f_leader_watcher );
		wake( f_ord_spawn_cov_convoy );


	sleep_until( volume_test_players (tv_ord_objcon_20) or s_objcon_ord >= 20, 1 );
		if s_objcon_ord <= 20 then
			s_objcon_ord = 20;
			dprint("s_objcon_ord = 20 " );
		end
			
		thread( f_blip_targeter() );

	sleep_until( volume_test_players (tv_ord_objcon_30) or s_objcon_ord >= 30, 1 );
		if s_objcon_ord <= 30 then 
			s_objcon_ord = 30;
			dprint("s_objcon_ord = 30 " );
		end

	sleep_until( volume_test_players (tv_ord_objcon_40) or s_objcon_ord >= 40, 1 );
		if s_objcon_ord <= 40 then 
			s_objcon_ord = 40;
			dprint("s_objcon_ord = 40 " );
		end
		f_unblip_object (ord_target_laser );


	sleep_until( volume_test_players (tv_ord_objcon_50) or s_objcon_ord >= 50, 1 );
		if s_objcon_ord <= 50 then 
			s_objcon_ord = 50;
			dprint("s_objcon_ord = 50 " );
		end
		
			
		
		garbage_collect_now( );


	sleep_until( volume_test_players (tv_ord_objcon_60) or s_objcon_ord >= 60, 1 );
		if s_objcon_ord <= 60 then 
			s_objcon_ord = 60;
			dprint("s_objcon_ord = 60 " );
		end
		

	sleep_until( volume_test_players (tv_epic_01) or s_objcon_ord >= 70, 1 );
		if s_objcon_ord <= 70 then 
			s_objcon_ord = 70;
			dprint("s_objcon_ord = 70 " );
		end

end



//gr_ord_wraith_leader
script dormant f_ord_spawn_flyby_phantom()
	sleep(30 );

	ai_place( sq_cov_ord_phantom_3 );
	ai_place( sq_cov_ord_phantom_2 );
	ai_place( sq_cov_ord_phantom_1 );
	
	sleep(10 );
	ai_set_clump (gr_cov_phantom, m40_OrdnanceClump );
	ai_designer_clump_perception_range (10 );
end

script dormant f_ord_spawn_cov_convoy()
	
	sleep(2 );
	dprint("spawn wraith ground spawners" );
	ai_place( sq_cov_ord_wraith_1 );

	sleep(5 );
	ai_set_clump (gr_ordnance_cov, m40_OrdnanceClump );
	ai_designer_clump_perception_range (100 );

	sleep(5 );
	ai_place( sq_cov_ord_shade_1 );
	ai_place( sq_cov_ord_shade_2 );
	ai_place( sq_cov_ord_shade_3 );
end




global boolean b_ord_ammo_drop = FALSE;
global boolean b_ord_ammo_pickup = FALSE;


script static void f_blip_targeter()

	game_save( );
	NotifyLevel ("ordnance ammo drop" );


	thread( f_ord_drop_pod() );
	b_ord_ammo_drop = TRUE;
	sleep_s(2.0 );
	sleep_until( object_get_at_rest (ord_target_laser) , 1 );
		f_blip_weapon (ord_target_laser, 75, 100 );

		b_ord_ammo_pickup = TRUE;
		wake( f_blip_leader_wraith );
end

script static void f_ord_drop_pod()
		//dprint("test, pod" );
		object_create(ord_drop_pod );
		thread( f_ord_drop_pod_effect() );
		object_move_to_flag( ord_drop_pod, 1, fg_ord_cap_loc );
		object_create(ord_target_laser );
		dprint ("Waiting for the player to pick up the target locator" );
		sleep_until( unit_has_weapon (player0, objects\weapons\pistol\storm_target_laser\storm_target_laser.weapon) );
		player_action_test_reset( );
		sleep (1 );
		sleep_until( ai_living_count (sq_cov_ord_wraith_leader.general) > 0
		and		
		player_action_test_rotate_weapons() == TRUE
		, 1 );
		dprint ("I think the player switched weapons (lost the locator) and the enemies are still alive!" );
		player_action_test_reset( );
//		wake (f_ord_drop_pod_effect_2 );
		wake (second_target_locator );
end

script dormant second_target_locator()
		wake (m40_second_target_locator_dialogue );
		sleep_s(5 );
		object_create(ord_drop_pod_2 );
		thread( f_ord_drop_pod_effect() );
		object_move_to_flag( ord_drop_pod_2, 1, fg_ord_cap_loc_2 );
		effect_new_at_ai_point ( fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect, pts_ord_marines.pt_pod_drop_2 );
		object_create(ord_target_laser_2 );
		f_blip_weapon (ord_target_laser_2, 75, 100 );
		wake (sleep_for_extra_target_locators );
		sleep_until( unit_has_weapon (player0, objects\weapons\pistol\storm_target_laser\storm_target_laser.weapon) );
		player_action_test_reset( );
		sleep (1 );
		sleep_until( ai_living_count (sq_cov_ord_wraith_leader.general) > 0
		and		
		player_action_test_rotate_weapons() == TRUE
		, 1 );
		dprint ("I think the player switched weapons AGAIN! He's doing it on purpose now" );
		player_action_test_reset( );
		wake (m40_third_target_locator_dialogue );
		sleep_s(6 );		
		b_ord_leader_dead = TRUE;
end

script dormant sleep_for_extra_target_locators()
	sleep_until( volume_test_players (tv_ord_objcon_50), 1 );
	sleep_forever (second_target_locator );
	sleep_forever (m40_second_target_locator_dialogue );
	sleep_forever (m40_third_target_locator_dialogue );
end


script static void f_ord_drop_pod_effect()
	sleep_s(0.95 );
	effect_new_at_ai_point ( fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect, pts_ord_marines.pt_pod_drop );
end

//script dormant f_ord_drop_pod_effect_2()
//	sleep_s(0.95 );
//	effect_new_at_ai_point ( fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect, pts_ord_marines.pt_pod_drop_2 );
//end


/*
script dormant ss_infinity_engine_control()
	dprint("test,ship" );
	object_function_set( 0, 0.2 );

	sleep_until( 0.8 >= device_get_position (ss_infinity) ,1 );

	object_function_set (0, 0.01 );
end

script static void f_kill_leader_ord()
	ai_kill(gr_ord_wraith_leader );
end

script dormant f_leader_watcher()
	wake( f_leader_wraith_dead );
	sleep_until( ai_spawn_count(sq_cov_ord_wraith_leader.general) and ai_living_count(sq_cov_ord_wraith_leader.general) < 1 ,1 );
		dprint(":::leader dead" );
		b_ord_leader_dead = TRUE;
end

script dormant f_leader_wraith_dead()

	sleep_until( b_ord_leader_dead == TRUE, 1 );
		sleep(5 );
		ai_set_objective( sq_cov_ord_wraith_leader, obj_cov_ord );
		ai_set_blind (sq_cov_ord_wraith_leader , FALSE );	
		ai_set_deaf (sq_cov_ord_wraith_leader , FALSE );
		
		ai_set_objective( gr_ordnance_cov, obj_cov_ord );
		ai_set_blind (gr_ordnance_cov , FALSE );
		ai_set_deaf (gr_ordnance_cov , FALSE );	
		ai_braindead( gr_ordnance_cov , FALSE );
		f_unblip_object (ord_target_laser );
		wake( f_cleanup_ord );
		sleep(30*2 );
		
		b_convoy_retreat = TRUE;
		
		b_ord_training_complete = TRUE;
		dprint("ordnance training over  ... move out" );
		game_save_no_timeout( );
		wake( f_blip_ordnance_moveout2 );
		sleep(30*90 );
		//dprint("recycling" );
		kill_volume_enable(kill_recycle_ord_convoy );
		sleep(5 );
		add_recycling_volume(kill_recycle_ord_convoy, 5, 20 );
		garbage_collect_now( );	
end 

script dormant f_blip_leader_wraith()

	//f_blip_ai(sq_cov_ord_wraith_leader );	
	
	f_blip_object_until_dead( object_get_ai(sq_cov_ord_wraith_leader.general ) );
		
		b_ord_leader_dead = TRUE;


end

script dormant f_cleanup_ord()
	sleep_until( volume_test_players (tv_epic_00), 1 );
		ai_erase(gr_ordnance_cov );
		sleep(5 );
		thread (f_recycle_ord() );
		garbage_collect_now( );

end

script static void f_recycle_ord()
	add_recycling_volume(recycle_ord_1 , 10, 5 );
end

global real Phantom_Scale_Out_Time  = 8;

script command_script cs_cov_ord_reinforce_phantom()
	print("phantom:::" );
	cs_vehicle_speed ( 1.0 );
	cs_vehicle_boost ( 1 );
	cs_ignore_obstacles ( 1 );

	ai_disregard ( ai_actors (sq_cov_ord_phantom_1), TRUE );
	ai_braindead(ai_current_actor ,TRUE );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );


	sleep_until( volume_test_players (tv_ord_spawn_phantom), 1 );
		sleep_s(6.0 );
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_1_spawn', sq_cov_ord_phantom_1, 1);
		
		ai_braindead(ai_current_actor ,FALSE );
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 * 6 );
		cs_vehicle_boost ( 1 );
		ai_place( sq_cov_ord_drop_ghost_1 );
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_1.fantomas), "phantom_sc02", ai_vehicle_get_from_starting_location  (sq_cov_ord_drop_ghost_1.ord_ghost_drop_1) );
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_1.fantomas), "phantom_sc01", ai_vehicle_get_from_starting_location  (sq_cov_ord_drop_ghost_1.ord_ghost_drop_2) );
		
		cs_vehicle_speed( 1.0 );
		cs_vehicle_speed_instantaneous(1.0 );
		cs_vehicle_boost ( 0 );
		cs_ignore_obstacles ( 1 );
		//cs_fly_by (pts_ord.p_ph_2 );
		cs_fly_by (pts_ord.p_ph_3 );
		cs_fly_by (pts_ord.p_ph_4 );
		cs_fly_by (pts_ord.p_ph_5 );
		cs_fly_to (pts_ord.p_ph_DropOff );
	
		sleep(30 );
		vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_1.fantomas), "phantom_sc01" );
		vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_1.fantomas), "phantom_sc02" );	
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_1_takeoff', sq_cov_ord_phantom_1, 1);
		ai_set_objective(sq_cov_ord_drop_ghost_1, obj_cov_ord );
		cs_fly_by (pts_ord.p_ph_7 );
		cs_fly_to_and_face (pts_ord.p_ph_8,pts_ord.p_ph_9 );
		cs_fly_by (pts_ord.p_ph_9 );
		cs_vehicle_boost ( 1 );
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * Phantom_Scale_Out_Time );
	
		sleep_s( Phantom_Scale_Out_Time );
		ai_erase ( sq_cov_ord_phantom_1 );
			
end


script command_script cs_cov_ord_reinforce_phantom2()
	print("phantom:::" );
	cs_vehicle_speed ( 1.0 );
	cs_vehicle_boost ( 1 );
	cs_ignore_obstacles ( 1 );

	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );
	
	sleep_until( volume_test_players (tv_ord_spawn_phantom), 1 );
		sleep_s(3.0 );
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_2_spawn', sq_cov_ord_phantom_2, 1);
		ai_place( sq_cov_ord_drop_ghost_2 );
	
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_2.fantomas), "phantom_sc02", ai_vehicle_get_from_starting_location  (sq_cov_ord_drop_ghost_2.ord_ghost_drop_1) );
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_2.fantomas), "phantom_sc01", ai_vehicle_get_from_starting_location  (sq_cov_ord_drop_ghost_2.ord_ghost_drop_2) );
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 * 6 );
	
		cs_vehicle_speed( 1.0 );
		cs_vehicle_speed_instantaneous(1.0 );
		cs_vehicle_boost ( 0 );
		cs_ignore_obstacles ( 1 );
		//cs_fly_by (pts_ord.p_ph_2 );
		cs_fly_by (pts_ord.p_ph2_1 );
		cs_fly_by (pts_ord.p_ph2_2 );
		//cs_fly_by (pts_ord.p_ph2_3 );
		cs_fly_to (pts_ord.p_ph2_DropOff );
		//cs_fly_by (pts_ord.p_ph2_4 );
	
		sleep(30 );
		vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_2.fantomas), "phantom_sc01" );
		vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_2.fantomas), "phantom_sc02" );	
		
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_2_takeoff', sq_cov_ord_phantom_2, 1);
		ai_set_objective(sq_cov_ord_drop_ghost_2, obj_cov_ord );
		cs_fly_by (pts_ord.p_ph2_4 );
		//cs_fly_to_and_face (pts_ord.p_ph2_4,pts_ord.p_ph2_5 );
		cs_fly_by (pts_ord.p_ph2_5 );
		cs_vehicle_boost ( 1 );
		
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * Phantom_Scale_Out_Time );
	
		sleep_s( Phantom_Scale_Out_Time );
		ai_erase ( sq_cov_ord_phantom_2 );
	
end


script command_script cs_cov_ord_reinforce_phantom3()
	print("phantom:::" );
	cs_vehicle_speed ( 1 );
	cs_vehicle_boost ( 1 );
	cs_ignore_obstacles ( 1 );
	cs_vehicle_speed_instantaneous(1.0 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 0 );
	

	sleep_until( volume_test_players (tv_ord_spawn_early_phant), 1 );
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 * 6 );
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_3_spawn', sq_cov_ord_phantom_3, 1);
		
		sleep_s(2.5 );
		ai_place( sq_cov_ord_wraith_2 );
		
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_3.fantomas), "phantom_sc02", ai_vehicle_get_from_starting_location  (sq_cov_ord_wraith_2.wraithdriver) );
		//vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_cov_ord_phantom_2.fantomas), "phantom_sc01", ai_vehicle_get_from_starting_location  (sq_cov_ord_drop_ghost_2.ord_ghost_drop_2) );
			
		cs_vehicle_speed( 1.0 );		
		cs_vehicle_boost ( 0 );
		cs_ignore_obstacles ( 1 );
		//cs_fly_by (pts_ord.p_ph_2 );
		cs_fly_by (pts_ord.p_ph3_1 );
		//cs_fly_by (pts_ord.p_ph3_DropOff );
		cs_fly_to (pts_ord.p_ph3_DropOff );
		sleep(5 );
		vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_3.fantomas), "phantom_sc02" );
		//vehicle_unload (ai_vehicle_get (sq_cov_ord_phantom_2.fantomas), "phantom_sc02" );	
		sound_impulse_start('sound\environments\solo\m040\new_m40_tags\amb_m40_ships\amb_m40_ord_phantom_3_takeoff', sq_cov_ord_phantom_3, 1);
		cs_fly_by (pts_ord.p_ph3_3 );	
		cs_fly_to_and_face (pts_ord.p_ph3_4,pts_ord.p_ph3_5 );
		cs_fly_by (pts_ord.p_ph3_5 );
		cs_vehicle_boost ( 1 );
		
		object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * Phantom_Scale_Out_Time );
	
		sleep_s( Phantom_Scale_Out_Time );
		ai_erase ( sq_cov_ord_phantom_3 );
	
end


script dormant f_ordnance_phantom_event()
	sleep_until( s_objcon_ord >= 20 and s_infinity_progress >= 8 and b_ord_leader_dead == FALSE and s_objcon_ord <= 50 );
		ai_place( sq_cov_ord_phantom_event );
end

script command_script cs_cov_ord_phantom_event()
	print("phantom:::" );
	cs_vehicle_speed ( 1 );
	cs_vehicle_boost ( 1 );
	cs_ignore_obstacles ( 1 );
	cs_vehicle_speed_instantaneous(1.0 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), .30, 0 );

		
		cs_fly_by (pts_ord_events.pStart );
			damage_object (unit_get_vehicle(ai_current_actor), engine_right, 500 );			
			effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, pts_ord_events.pStart );
			object_rotate_by_offset(unit_get_vehicle(ai_current_actor),0.1,0.25,0.1,0,45,0 );
		cs_fly_by (pts_ord_events.p3 );
			damage_object (unit_get_vehicle(ai_current_actor), chin_gun, 10000 );
			damage_object (unit_get_vehicle(ai_current_actor), turret, 10000 );
			damage_object (unit_get_vehicle(ai_current_actor), engine_left, 500 );
			effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, pts_ord_events.p3 );
			object_rotate_by_offset(unit_get_vehicle(ai_current_actor),0.1,0.25,0.1,0,45,0 );
		cs_fly_by (pts_ord_events.p1 );
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), .50, 30 );
			damage_object (unit_get_vehicle(ai_current_actor), hull, 500 );
			effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, pts_ord_events.p1 );
			object_rotate_by_offset(unit_get_vehicle(ai_current_actor),0.25,0.25,0.1,0,-45,0 );
		cs_fly_by (pts_ord_events.p0 );
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), .90, 30 );	
			object_rotate_by_offset(unit_get_vehicle(ai_current_actor),0.1,0.25,0.25,0,45,45 );
		cs_fly_to_and_face (pts_ord_events.pEnd,pts_ord_events.pEndFace );
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), .90, 30 );			
			damage_object (unit_get_vehicle(ai_current_actor), hull, 10000 );
			damage_object (unit_get_vehicle(ai_current_actor), engine_left, 10000 );
			damage_object (unit_get_vehicle(ai_current_actor), engine_right, 10000 );
			effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, pts_ord_events.pEnd );
		
		object_destroy( unit_get_vehicle(sq_cov_ord_phantom_event) );
		sleep(10 );
		effect_new_at_ai_point (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, pts_ord_events.pEnd );
end
//



global boolean b_ss_vixen_take_off = FALSE;

script command_script cs_hum_ord_reinforce_pelican_1()
	//print("pelican:::" );

	//cs_vehicle_speed_instantaneous(1.0 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.001, 0 );
	sleep(30 );
	object_hide(sq_unsc_ord_pelican_1 , FALSE );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 * 18 );
	cs_vehicle_speed ( 0.33 );
	cs_vehicle_boost ( 0 );
	cs_ignore_obstacles ( 1 );		
		//sleep_s(2.5 );
	ai_place( sq_unsc_ord_hog_drop_1 );
	object_set_scale ( ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_1.driver), 0.01, 0 );
	object_set_scale ( ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_1.driver), 1.0, 30 * 18 );
		vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_unsc_ord_pelican_1.ss_vixen), "pelican_lc", ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_1.driver) );

				
		cs_vehicle_boost ( 0 );
		cs_ignore_obstacles ( 1 );
		//print("fly birdy" );
		cs_fly_by (pts_ord_pelicans.p0 );
		sleep(30 );
		cs_fly_by (pts_ord_pelicans.p1 );
		cs_vehicle_speed( 0.75 );
		sleep(10 );
		cs_fly_by (pts_ord_pelicans.p11 );
		//sleep(10 );
		cs_vehicle_speed( 0.75 );	
		cs_fly_to (pts_ord_pelicans.drop_1 );
		cs_fly_to_and_face (pts_ord_pelicans.drop_1, pts_ord_pelicans.p3 );
		sleep(60 );
		vehicle_hover (ai_vehicle_get (ai_current_actor),  TRUE );
		sleep_until( not volume_test_players(tv_pelican_landing_1),1 );
		
			vehicle_unload (ai_vehicle_get (sq_unsc_ord_pelican_1.ss_vixen), "pelican_lc" );
			sleep(10 );
		//	dprint( "pelican dropping wardog" );
			b_ord_hog_1_dropped = TRUE;			
			//cs_fly_by (pts_ord.p_ph3_3 );	
			//cs_fly_to_and_face (pts_ord.p_ph3_4,pts_ord.p_ph3_5 );
			//cs_fly_by (pts_ord.p_ph3_5 );
			cs_vehicle_boost ( 1 );
			sleep_s(3 );
			vehicle_hover (ai_vehicle_get (ai_current_actor),  FALSE );
			cs_vehicle_speed ( 1 );
			cs_fly_to (pts_ord_pelicans.p9 );
			
			b_ss_vixen_take_off = TRUE;
			
			cs_fly_to_and_face (pts_ord_pelicans.p9,pts_ord_pelicans.p10 );
			object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * 15 );
			cs_fly_to (pts_ord_pelicans.p10 );
			
			cs_fly_to (pts_ord_pelicans.p12 );
			//sleep_s(4 );
			//object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * 20 );
			cs_fly_to (pts_ord_pelicans.p15 );
			sleep_s( 15 );
			ai_erase ( sq_unsc_ord_pelican_1 );
		
end

script command_script cs_hum_ord_reinforce_pelican_2()
	//print("pelican2:::" );

	//cs_vehicle_speed_instantaneous(1.0 );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.001, 0 );
	sleep(30 );
	object_hide(sq_unsc_ord_pelican_1 , FALSE );
	object_set_scale ( ai_vehicle_get ( ai_current_actor ), 1.0, 30 * 18 );
	cs_vehicle_speed ( 0.33 );
	cs_vehicle_boost ( 0 );
	cs_ignore_obstacles ( 1 );		
		//sleep_s(2.5 );
	ai_place( sq_unsc_ord_hog_drop_2 );
	object_set_scale ( ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_2.driver), 0.01, 0 );
	object_set_scale ( ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_2.driver), 1.0, 30 * 18 );
	vehicle_load_magic (ai_vehicle_get_from_spawn_point (sq_unsc_ord_pelican_2.ss_coquitlam), "pelican_lc", ai_vehicle_get_from_starting_location  (sq_unsc_ord_hog_drop_2.driver) );

				
		cs_vehicle_boost ( 0 );
		cs_ignore_obstacles ( 1 );
		//print("fly birdy" );
		cs_fly_by (pts_ord_pelicans.p4 );
		sleep(30 );
		cs_fly_by (pts_ord_pelicans.p5 );
		cs_vehicle_speed( 0.50 );
		sleep(10 );
		cs_fly_by (pts_ord_pelicans.p6 );
		//sleep(10 );
		cs_vehicle_speed( 0.50 );	
		cs_fly_to (pts_ord_pelicans.drop_2 );
		cs_fly_to_and_face (pts_ord_pelicans.drop_2, pts_ord_pelicans.drop_1 );
		sleep(60 );
		vehicle_hover (ai_vehicle_get (ai_current_actor),  TRUE );
		sleep_until( not volume_test_players(tv_pelican_landing_2),1 );
		
			vehicle_unload (ai_vehicle_get (sq_unsc_ord_pelican_2.ss_coquitlam), "pelican_lc" );
			sleep(10 );
			dprint( "pelican dropping wardog2" );
			b_ord_hog_2_dropped = TRUE;				

			//cs_fly_by (pts_ord.p_ph3_3 );	
			//cs_fly_to_and_face (pts_ord.p_ph3_4,pts_ord.p_ph3_5 );
			//cs_fly_by (pts_ord.p_ph3_5 );
			cs_vehicle_boost ( 1 );
			
			sleep_until( b_ss_vixen_take_off == TRUE , 1 );
				sleep_s(4 );
				vehicle_hover (ai_vehicle_get (ai_current_actor),  FALSE );
				cs_vehicle_speed ( 1 );
				cs_fly_to (pts_ord_pelicans.p13 );
				cs_fly_to_and_face (pts_ord_pelicans.p13,pts_ord_pelicans.p14 );
				object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * 15 );
				cs_fly_to (pts_ord_pelicans.p14 );
				cs_fly_to (pts_ord_pelicans.p15 );
				//cs_fly_to (pts_ord_pelicans.p12 );
				//sleep_s(4 );
				//object_set_scale ( ai_vehicle_get ( ai_current_actor ), 0.01, 30 * 20 );
			
				sleep_s( 15 );
				ai_erase ( sq_unsc_ord_pelican_2 );
		
end
*/


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


/*
global boolean b_ord_airsupport_audio_done = FALSE;
global boolean b_ord_hopongauss_audio_done = FALSE;
global boolean b_ord_convoy_audio_done = FALSE;

script dormant f_ordnance_vo()
	
	sleep_until( s_objcon_ord >= 5 and ( b_lib_exit_audio_done or not b_lib_exit_audio_started), 1 );		
		b_lib_exit_audio_done = FALSE;
		// 6 : Hop on the Gauss hog, Chief, I think we’re gonna need it.
		//dprint("Hop on the Gauss hog, Chief, I think we’re gonna need it." );
		//sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_00700', NONE, 1 );
		//sleep (30 * 3 );
		 
	//	storyblurb_display(ch_blurb_infinity_intro, 4, FALSE, FALSE );
		//sleep_s(4 );
		b_ord_hopongauss_audio_done = TRUE;
	
		
	sleep_until( b_ord_hopongauss_audio_done, 1 );		
		b_lib_exit_audio_done = FALSE;
		sleep_s(1 );
			// 20 : The UNSC Infinity is in orbit and moving to provide air support. We’ll let you know when it’s available, Master Chief.
			dprint("The UNSC Infinity is in orbit and moving to provide air support. We’ll let you know when it’s available, Master Chief." );
		sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_02100', NONE, 1 );
		sleep (30 * 5 );
		
		//ch_blurb_ordnance_intro
//		storyblurb_display(ch_blurb_ordnance_intro, 4, FALSE, FALSE );
		b_ord_airsupport_audio_done = TRUE;
	
	sleep_until( s_objcon_ord >= 10 and b_ord_airsupport_audio_done, 1 );		
		// 155 : Infinity’s got us covered from above, but we’re going to have to paint the targets for her. Requesting an ammo drop with some laser designators.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_07000', NONE, 1 );
		//sleep (30 * 8 );
		// 5 : A Covenant convoy up ahead! Sir, we should use the Infinity’s air support to get the jump on them.ch_blurb_ordnance_introch_blurb_ordnance_introch_blurb_ordnance_intro
		sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_00600', NONE, 1 );
		sleep (30 * 5 );		
		// 156 : Those Covenant haven’t detected us yet, but that won’t last long whenever that ammo drop gets down here.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_07100', NONE, 1 );
		//sleep (30 * 5 );
		b_ord_convoy_audio_done = TRUE;
	//sleep_until( LevelEventStatus ("ordnance ammo drop"), 1 );
	//sleep(10 );	
	sleep_until( b_ord_convoy_audio_done and b_ord_ammo_drop, 1 );
		 
//		storyblurb_display(ch_blurb_ordnance, 4, FALSE, FALSE );
		if not b_ord_ammo_pickup then
			// 157 : Special delivery. Grab one of those laser designators so we can start calling down some ordinance.
			dprint("Special delivery. Grab one of those laser designators so we can start calling down some ordinance." );
			sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_07200', NONE, 1 );
			sleep (30 * 6 );
		end

	sleep_until( b_ord_leader_dead, 1 );	
		//sleep(30*5 );		
		// 97 : Very thorough, Master Chief. Hope my folks are taking notes. Proceed to next sector. Palmer out.
		if s_objcon_ord <= 40 then
			sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Palmer_01200', NONE, 1 );
		end

end

script static void bleh()

	flock_destination_set_enabled (flocks_inf_falcons, move_to_fight, TRUE );
	flock_destination_set_enabled (flocks_inf_falcons, start_inf, FALSE );
end

script static void meh()

	flock_destination_set_enabled (flocks_inf_falcons, move_to_fight, FALSE );
	flock_destination_set_enabled (flocks_inf_falcons, start_inf, TRUE );
end

script static void bah()

	flock_create(ord_bbs_banshee );

end

script static void a_cannon_loop()
//	device_set_position_track( dm_cannon_1, 'any:pew', 0 );
sleep(1 );
//any:pew
end

script static void a_cannon_shoot_test()
	//device_set_overlay_track( dm_cannon_1, 'any:pew' );
	//device_animate_overlay( dm_cannon_1, 1, 27.5, 0, 0 );
	sleep( 30 * 27.5 );
	//device_animate_overlay( dm_cannon_1, 0.1, 0.1, 0, 0 );

end
*/


/*
// 20 : The UNSC Infinity is in orbit and moving to provide air support. We’ll let you know when it’s available, Master Chief.
sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_02100', NONE, 1 );
sleep (30 * 5 );

// 5 : A Covenant convoy up ahead! Sir, we should use the Infinity’s air support to get the jump on them.
sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_00600', NONE, 1 );
sleep (30 * 5 );
*/
