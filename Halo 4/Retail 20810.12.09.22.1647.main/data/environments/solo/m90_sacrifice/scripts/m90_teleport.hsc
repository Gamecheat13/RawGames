//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	teleport
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================



// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================


global boolean b_teleport_complete = FALSE;
global boolean b_teleport_special = FALSE;
global boolean b_teleport_platform_done = FALSE;
global boolean b_Teleporter_Active_1 = FALSE;
global boolean b_Teleporter_Active_2 = FALSE;
global boolean b_Teleporter_Active_3 = FALSE;
global boolean b_Teleporter_Active_4 = FALSE;
global boolean b_Teleporter_Active_5 = FALSE;
global boolean b_Teleporter_Active_6 = FALSE;
global boolean b_engineroom_done = FALSE;
global short s_objcon_teleport = 0;
global boolean b_tele_main_front_flush = FALSE;



script startup m90_teleport()		
	if b_debug then 
		print_difficulty(); 
	end
	
	sleep_until( b_arcade_complete , 4 );
	sleep_until( volume_test_players( tv_teleport_init ),3 );
		dprint("== INIT == TELEPORT ==");
		data_mine_set_mission_segment ("m90_teleport");
		set_broadsword_respawns ( false );
		garbage_collect_now();
		zone_set_trigger_volume_enable( "zone_set:teleport_rooms", FALSE);
		zone_set_trigger_volume_enable( "zone_set:walls_teleport_room", FALSE);
		zone_set_trigger_volume_enable( "begin_zone_set:walls_teleport_room", FALSE);
		wake( nar_teleportals_init );

		object_create_folder( dms_teleport );
		//object_create_folder( dms_teleport_trains );
		object_create_folder( crs_teleport );
		sleep(1);
		wake( f_teleport_intro );
		wake( f_teleport_controller );

		wake( f_teleport_setup_portals );
		wake( f_teleport_objcon_controller);

		wake( f_teleport_intro_spawn );
		//wake( f_teleport_intro_intro_surprise );
		wake( f_teleport_cleanup );
		sleep(1);		
		f_m90_game_save_no_timeout();

end


script dormant f_teleport_cleanup()
	sleep_until ( b_teleport_complete	 == TRUE, 1 ); 
		object_destroy_folder( crs_teleport );
		object_destroy_folder( crs_teleport_portals );
		object_destroy_folder( dms_teleport );
		//object_destroy_folder( dms_teleport_trains );
		kill_script(f_engineroom_found_a_success);
		kill_script(f_engineroom_start_bullet_catcher);
		
		ai_erase ( sg_teleport_all );
		f_unblip_flag( flag_teleport_main_up_portal);
		f_unblip_flag ( flag_teleport_main_plat_exit);
		
		
end

script dormant f_teleport_intro_crates()
	sleep_until( volume_test_players( tv_teleport_intro_crate ) or b_arcade_complete,1 );	
		object_create_folder(crs_teleport_intro);
end


script dormant f_teleport_intro_intro_surprise()

		

	sleep_until( volume_test_players( tv_teleport_spawn_surprise ),1 );		
		ai_place_in_limbo( sq_for_arc_dd_knight );
		sleep(5);
		pup_play_show( pup_drop_down_hall );
//pup_play_show( pup_reaction );
			
end



// =================================================================================================
// =================================================================================================
// *** INTRO ***
// =================================================================================================
// =================================================================================================

global long l_intro_pawns_a = -1;
global long l_intro_pawns_b = -1;

script dormant f_teleport_intro_spawn()
	dprint("spawning intros");
	ai_place( sq_for_main_bishop_intro_1 );
	ai_place( sq_for_main_bishop_intro_2 );
	
	sleep_until( ai_task_count(obj_teleport.bi_start) == 0 );
		
		if ( s_objcon_teleport < 20 ) then
			dprint(" ------  beez nest spawn shards -----");
			l_intro_pawns_a = ai_place_with_shards( sq_for_main_intro_pawns_a, 2 );
			l_intro_pawns_b = ai_place_with_shards( sq_for_main_intro_pawns_b, 2 );
		end
end

script dormant f_teleport_intro()

	//
	sleep_until ( volume_test_players( tv_teleport_intro )	, 1 );

	local long l_timer = timer_stamp( 15 ); 


		sleep_until( dialog_id_played_check(l_teleport_put_in) or timer_expired(l_timer), 1 );
			sleep(2);
			object_create( dc_teleport_intro );
			sleep(3);
			f_blip_object (dc_teleport_intro, "activate");
	//	wake( f_teleport_engineroom_sentinal_spawner );
	//	wake( f_teleport_engineroom_sentinal_spawner_rear );

	sleep_until ( device_get_position( dc_teleport_intro ) != 0 );
		local long insert_show = pup_play_show(pup_cort_insert_1);
		thread(nar_teleport_intro_open());
		f_unblip_object (dc_teleport_intro);
		sleep_until(not pup_is_playing(insert_show));

		
		//dprint("cortana in");
		//sleep(5);
		//effect_new( objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, fx_cortana_rez_insert_1 );
		//object_create( sn_teleport_cortana_intro );
		//sleep(30);

	

		sleep_s(3);
		zone_set_trigger_volume_enable( "zone_set:teleport_rooms", TRUE);
		//f_insertion_zoneload( s_teleport_rooms_idx, INSERTION_INDEX_TELEPORT, TRUE );
		
		sleep_s(2);
		//object_create( cr_teleport_portal_1 );
		thread( f_teleport_open_portal( dm_teleport_portal_init, 0.0, TRUE, flg_none ) );
		object_destroy (sn_teleport_cortana_intro);
		//effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleport.p1);
		sleep_s(1.5);
		b_Teleporter_Active_1 = TRUE;
		f_m90_game_save();
		
end

script static void f_spawn_orb
	sleep(26);
	effect_new_on_object_marker("objects\characters\storm_cortana\fx\orb\cor_orb_persistant_ramp",cr_tele_plinth,m_top_stand);
end






// =================================================================================================
// =================================================================================================
// *** ENGINE ROOM ***
// =================================================================================================
// =================================================================================================
global short s_teleport_plat_wave = 1;
global boolean b_teleport_bishop_pod_a_alive = FALSE;
global boolean b_teleport_reuse_shards = FALSE;
global boolean b_teleport_bishop_bail = FALSE;


script static void debug_engineroom()
	s_objcon_teleport = 20;
	wake(f_teleport_engineroom_init);
end

script dormant f_teleport_engineroom_init()
		dprint("ENGINE ROOM INIT");
		thread(fx_engine_room_beams());
		wake ( f_teleport_engineroom_spawn );
		wake ( f_teleport_engineroom_portal_activate );
		//object_create( dc_teleport_platform );
		//effect_new_at_ai_point ( environments\solo\m10_crash\fx\flash_white.effect, ps_teleport.p1 );
		f_teleport_party_to_next_portal( flag_teleport_1a, flag_teleport_1b, flag_teleport_1c, flag_teleport_1d, ps_teleport.p1, dm_teleport_er_enter );
		//object_destroy ( cr_teleport_portal_1 );		
		f_teleport_return_from_teleport();
		wake( f_teleport_enginerroom_event_wait );
		thread( f_engineroom_start_bullet_catcher() );
		object_destroy_folder( crs_teleport_intro );
		sleep(2);
		f_m90_game_save();
		
		sleep_s(2);

		
end
global boolean b_engineroom_release_hounds = FALSE;
script dormant f_teleport_enginerroom_event_wait()
			pup_play_show(pup_pawn_roar);
	sleep_until( volume_test_players( tv_teleport_er_event), 1);
		ai_place( sq_for_tele_pawnz_intro);	

end

script dormant f_teleport_engineroom_portal_activate()
	sleep_until( volume_test_players( tv_teleport_er_portal_active), 1);
		device_animate_position(  dm_teleport_er_enter , 0 , 1.5, 0.1, 0.0, TRUE );
		sleep( 5 );
		device_animate_position(  dm_teleport_portal_plat_exit , 1 , 1.5, 0.1, 0.0, TRUE );

end

global long l_engineroom_shards_a = -1;
global boolean b_platorm_timer_up = FALSE;
script dormant f_teleport_engineroom_spawn()

	//ai_place( sq_for_tele_pawnz_intro);
	ai_place(sg_engine_room_sentinels);
	ai_place( sq_for_tele_pawnz_intro_b);
	sleep_until( s_objcon_teleport == 20, 2 );
		thread( 		f_mus_m90_e02_start() );
		thread( f_teleport_plat_open_portal() );
	sleep_until( ai_spawn_count(sg_teleport_1) > 3 and ai_living_count( sg_teleport_1 ) <= 1 or b_platorm_timer_up, 2 );
		dprint("**** fight over ****");	
		b_teleport_platform_done = TRUE;

	
end

script static void f_teleport_plat_open_portal()
	
	sleep_rand_s( 30, 40 );
	b_platorm_timer_up = TRUE;
	//dprint("platform timer up");
end





// =================================================================================================
// =================================================================================================
// *** MAIN UP ***
// =================================================================================================
// =================================================================================================
script static void debug_main_up()
	//wake( f_teleport_objcon_controller );

	wake( f_teleport_main_up_init );
	sleep(1);
		s_objcon_teleport = 20;
		wake(f_teleport_objcon_controller);
	//f_teleport_spawn_main_up();
		object_create_folder( dms_teleport );
		//object_create_folder( dms_teleport_trains );
		object_create_folder( crs_teleport );
end

script dormant f_teleport_main_up_init()

		DestroyDynamicTask( l_intro_pawns_a );
		DestroyDynamicTask( l_intro_pawns_b );
		
		f_teleport_main_up_bishop_spawn();
		ai_erase( sg_teleport_intro_bishops );

		f_teleport_party_to_next_portal( flag_teleport_2a, flag_teleport_2b,flag_teleport_2c,flag_teleport_2d,ps_teleport.p2,dm_teleport_dummy_6  );
		thread( f_teleport_spawn_main_up() );
		//object_destroy ( cr_teleport_portal_2 );
		f_teleport_return_from_teleport();
		f_m90_game_save_no_timeout();
	
		sleep_until( ai_spawn_count( sg_teleport_2 ) > 4 and ai_living_count( sq_for_tele_rt_bot_bw ) == 0 and ai_living_count( sq_2c_knight_1 ) and ai_living_count( sq_2b_knight_2 ));
			f_m90_game_save();
end

script dormant f_teleport_main_up_wp()
	//sleep_s( 90 );
	dprint("i would like to blip exit flag");
	if ( not b_Teleporter_Active_3 ) then
		dprint("blip exit flag");
		f_blip_flag( flag_teleport_main_up_portal, "default");
	end
end

script static void f_teleport_main_up_bishop_spawn()
		dprint("adding up bishops" );

		ai_place ( sq_2c_bishop );		
		if ( ai_spawn_count(sg_teleport_intro_bishops) > 0 ) then

			if ( ai_living_count(sg_teleport_intro_bishops) >= 2 ) then

				dprint("adding another bishop to main platform");
				ai_place ( sq_2c_bishop_3 );
			end
			

		end

		sleep(5);
		//RequestAutomatedTurretActivation( ai_vehicle_get(sq_for_tele_up_tur.gustov ) );
end

script static void f_teleport_spawn_main_up()

	wake( f_teleport_force_front_flush );
	sleep_until( volume_test_players( tv_teleport_main_up_enter ) );
		wake( f_teleport_spawn_main_up_2 );
		thread( f_mus_m90_e03_start() );
		sleep(15);
		thread( f_teleport_spawn_main_portal( sq_for_tele_lt_bot_comm , dm_teleport_dummy_2, ps_teleport.dummy_2, flg_none ) );
		sleep( 60 );
		thread( f_teleport_spawn_main_portal( sq_for_tele_rt_top_ranger , dm_teleport_dummy_3, ps_teleport.dummy_3, flg_none ) );
		sleep( 45 );
		
		if ( difficulty_legendary() or coop_players_3() ) then
			//thread( f_teleport_spawn_main_portal( sq_for_tele_rt_bot_bw , dm_teleport_dummy_2, ps_teleport.dummy_2 ) );	
			sleep( 90 );
		end
		//

		ai_place ( sq_2c_bishop_2 );
		sleep(30);
		//ai_place_with_shards( sq_for_tele_up_tur );
	sleep_s(20);
	if not ( coop_players_3() or difficulty_legendary() ) then
		sleep_s( 15 );
	end
	//dprint("halfback flush");
	b_tele_main_front_flush = TRUE;
	
	//NEW FLUSH
	//ai_place_with_shards( sq_for_main_intro_pawns_a, 2 )

end

script dormant f_teleport_force_front_flush()

	sleep_until( volume_test_players( tv_teleport_main_lower_2 ) );
		//b_teleport_force_front_flush = TRUE;
	//	dprint("force front flush");
		//b_tele_main_front_flush = TRUE;

end


script dormant f_teleport_spawn_main_up_2()
		
		ai_place_in_limbo(sq_2b_knight_2);
		sleep(15);
		ai_place_in_limbo(sq_2c_knight_1);
end




script static void f_teleport_spawn_main_portal( ai tele_squad, device dm, point_reference pt0, cutscene_flag fg  )

	//object_create( portal_a );
	//object_create( portal_b );
	thread( f_teleport_open_portal( dm, 3, FALSE, fg ) );
	sleep( 20 );
	ai_place( tele_squad );
	sleep( 35 );
	//object_destroy( portal_a );
	//object_destroy( portal_b );
	
end


// =================================================================================================
// =================================================================================================
// *** NOTLAB ***
// =================================================================================================
// ================================================================================================


script static void debug_notlab()
	//object_create( sentinel_tim );
	object_create_folder(crs_teleport);
	sleep(3);
	wake(f_teleport_notlab_init);

end

script dormant f_teleport_notlab_init()
		wake(f_notlab_weapon_setup);
		sleep(1);
		object_wake_physics ( cr_nl_crate_a );
		object_wake_physics ( cr_nl_crate_b );
		ai_place(sq_for_notlab_sent);
		f_teleport_party_to_next_portal( flag_teleport_3a, flag_teleport_3b, flag_teleport_3c, flag_teleport_3d, ps_teleport.p3,dm_teleport_lab_enter );
		//object_destroy ( cr_teleport_portal_3 );
		wake( f_teleport_lab_sent_wait );
		f_teleport_return_from_teleport();

		f_m90_game_save();
	
	
end



script dormant f_teleport_lab_sent_wait()
	
	sleep_until( volume_test_players( tv_tele_lab_sent ) );
		device_animate_position(  dm_teleport_lab_enter , 0 , 1.5, 0.1, 0.0, TRUE );
		sleep( 5 );
		device_animate_position(  dm_teleport_lab_exit , 1 , 1.5, 0.1, 0.0, TRUE );
		sleep( 30 * 2 );
		nar_teleport_special_weapons();

		f_m90_game_save();
end


script dormant f_notlab_weapon_setup()


	objects_attach(   cr_notlab_hammer_holder, "m_weapon_large",   wp_notlab_hammer, "");
	objects_attach(   cr_notlab_weapon_holder_a, "m_weapon_medium",   wp_notlab_weapon_a, "");
	objects_attach(   cr_notlab_weapon_holder_a, "m_weapon_large",   wp_notlab_weapon_a_2, "");	


	objects_attach(   cr_notlab_weapon_holder_b, "m_weapon_medium",   wp_notlab_weapon_b_1, "");
	objects_attach(   cr_notlab_weapon_holder_b, "m_weapon_large",   wp_notlab_weapon_b_2, "");	
	
	objects_attach(   cr_notlab_weapon_holder_c, "m_weapon_large",  wp_notlab_weapon_c , "");
	objects_attach(   cr_notlab_weapon_holder_c_2, "m_weapon_large",  wp_notlab_weapon_c_2 , "");
	sleep(3);
	
	thread(f_rotate_weapon_holder( cr_notlab_hammer_holder ));

	
end

script static void f_rotate_weapon_holder( object_name rack )

	repeat
		object_rotate_by_offset( rack,1,0,0,10,0,0);
	until( b_notlab_weapon_rotate == FALSE, 1);

end

global boolean b_notlab_weapon_rotate = TRUE;



// =================================================================================================
// =================================================================================================
// *** MAIN DOWN ***
// =================================================================================================
// =================================================================================================


script static void debug_down()
	s_objcon_teleport = 45;
	wake( f_teleport_objcon_controller_down );
	wake( f_teleport_main_down_init );
	object_create_folder( crs_teleport );
end

script dormant f_teleport_main_down_init()
		//effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_teleport.p4);
		
		f_teleport_party_to_next_portal( flag_teleport_4a, flag_teleport_4b,flag_teleport_4c,flag_teleport_4d,ps_teleport.p4,dm_teleport_lab_to_main );
		ai_erase( sg_teleport_all );	//clear all previous spawns
		sleep(1);
		b_notlab_weapon_rotate = false;
		ai_place ( sg_teleport_4 );
		//f_m90_game_save();	
		object_destroy ( cr_teleport_portal_4 );
		zone_set_trigger_volume_enable( "zone_set:walls_teleport_room", TRUE);
		zone_set_trigger_volume_enable( "begin_zone_set:walls_teleport_room", TRUE);
		sleep(3);	
		player_enable_input ( TRUE );
		pup_play_show( teleport_down_knight_marz ); 

		sleep_until( ai_living_count( sg_teleport_4 ) <= 0 );
			f_m90_game_save();
end



script command_script cs_teleport_main_down_knight()

	cs_stow (true);
	cs_abort_on_alert (true);
	cs_abort_on_damage (true);
	cs_enable_moving (false);
	sleep_forever();	
end


script command_script cs_teleport_drop_down_knight()
	cs_phase_in();
	//cs_stow (true);
	cs_abort_on_alert (true);
	cs_abort_on_damage (true);

	sleep_forever();	
end

// =================================================================================================
// =================================================================================================
// *** EXIT ***
// =================================================================================================
// =================================================================================================






// =================================================================================================
// =================================================================================================
// *** GENERAL ***
// =================================================================================================
// =================================================================================================
script dormant f_teleport_controller()


	////// Portal 1 into Engine Room Platform Combat  /////////
	sleep_until ( volume_test_players( tv_teleport_1 ) and b_Teleporter_Active_1 == TRUE, 1 );
		thread( f_dropdown_stop_fall_damage( FALSE ) ); //make sure everyone has this flagged cleared from dropdown edge cases
		object_destroy_folder( dms_arcade );
		wake( f_teleport_engineroom_init );	
		sleep (30 * 2);

		nar_teleport_bad_1();
	
	sleep_until ( b_teleport_platform_done == TRUE );

		nar_teleport_plat_1();
		sleep( 30 * 2 );
		//object_create (cr_teleport_portal_2);
		thread( f_teleport_open_portal(dm_teleport_portal_plat_exit , 0 , FALSE, flag_engineroom_exit ));
		sleep_s( 1.5 );
		b_Teleporter_Active_2 = TRUE;
		f_m90_game_save_no_timeout();
		
	/////  Portal 2 into Main Combat Bottom  //////////
	sleep_until ( volume_test_players( tv_teleport_2 ) and b_Teleporter_Active_2 == TRUE, 1 );
		ai_erase(sg_engine_room_sentinels);
		ai_erase(sg_teleport_1);
		b_engineroom_done = TRUE;
		kill_thread( l_feo_good_thread );
		kill_thread( l_feo_bad_thread );
		thread( f_mus_m90_e02_finish() );
		wake( f_teleport_main_up_init );	
		sleep (30 * 2);
	
		sleep_until( s_objcon_teleport > 30, 1 );
		//dprint("wtf");
			//object_create (cr_teleport_portal_3);
			
			thread( f_teleport_open_portal( dm_teleport_portal_main_exit_1, 0, FALSE, flag_teleport_main_up_portal ) );
			sleep_s(2);
			b_Teleporter_Active_2 = TRUE;
			wake( f_teleport_main_up_wp );
	
	///// Portal 3 into NOTLAB Area /////
	sleep_until ( volume_test_players( tv_teleport_3 )and b_Teleporter_Active_2 == TRUE, 1 );
		f_unblip_flag( flag_teleport_main_up_portal);
		thread( 		nar_teleport_special() );
		thread( f_mus_m90_e03_finish() );
		wake( f_teleport_notlab_init );	
		//sleep (30 * 2);	

		 thread( f_teleport_close_portal( dm_teleport_portal_main_exit_1, FALSE, flag_teleport_main_up_portal ) );
		sleep(1);
		sleep_until( dialog_id_played_check(l_dlg_90_wrong_room_2) , 1 );
		sleep_s (1);
		if player_count() > 1 then
			sleep_s( 14 );
		end 
		//object_create (cr_teleport_portal_4);
		thread( f_teleport_open_portal( dm_teleport_lab_exit, 0, FALSE, flag_lab_exit ) );
		sleep_s(2);
		b_Teleporter_Active_3 = TRUE;
				
	/////// Portal 4 Back to Main Platform Reverse  /////
	sleep_until ( volume_test_players( tv_teleport_4 ) and b_Teleporter_Active_3 == TRUE, 1 );		
		garbage_collect_now();
		wake( f_teleport_main_down_init );

		

		//sleep_s(7);
		//sleep_until( ai_living_count( sq_for_main_dwn_commander ) == 0, 1 );
		sleep_rand_s(12,20);
		
		//nar_teleport_plat_1();
		//object_create (cr_teleport_portal_5);
		
		thread( f_teleport_open_portal( dm_teleport_portal_main_exit_2, 0, FALSE, flag_teleport_main_plat_exit ) );
		sleep_s(2);
		thread( nar_teleport_reenter() );
		b_Teleporter_Active_5 = TRUE;
		sleep( 15 );
		f_blip_flag ( flag_teleport_main_plat_exit, "default" );	
		
	////// Portal 5  	/ Onwards into Wallz ////// /////
	sleep_until ( volume_test_players( tv_teleport_5 ) and b_Teleporter_Active_5 == TRUE, 1 );
		f_unblip_flag ( flag_teleport_main_plat_exit);
		//thread( f_mus_m90_e04_finish() );
		//object_destroy (cr_teleport_portal_5);
		//f_teleport_return_from_teleport();
		//nar_teleport_finally_out();


		object_create_folder(dms_walls);
		object_create_folder(crs_walls);
		//f_insertion_zoneload( s_walls_teleport_room_idx, INSERTION_INDEX_TELEPORT, TRUE );
		sleep(1);
		f_teleport_party_to_next_portal( flag_teleport_6a,  flag_teleport_6b, flag_teleport_6c, flag_teleport_6d, ps_teleport.p1, dm_walls_enter);
		
		f_teleport_return_from_teleport();
		b_teleport_complete = TRUE;
		f_m90_game_save();

		b_Teleporter_Active_6 = TRUE;
end


script static void f_teleport_party_to_next_portal( cutscene_flag tele_flag_1,cutscene_flag tele_flag_2,cutscene_flag tele_flag_3,cutscene_flag tele_flag_4, point_reference pt, object_name dm_portal )
	player_enable_input ( FALSE );

	fade_out(0,0,0,0);

	sleep(20);
	if ( player_valid( player0() ) ) then	
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player0, 1 ); //AUDIO!
		object_teleport( player0(), tele_flag_1 );
	end
	
	if ( player_valid( player1() ) ) then	
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player1, 1 ); //AUDIO!
		object_teleport( player1(), tele_flag_2 );
	end
	
	if ( player_valid( player2() ) ) then	
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player2, 1 ); //AUDIO!
		object_teleport( player2(), tele_flag_3 );
	end
	
	if ( player_valid( player3() ) ) then
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player3, 1 ); //AUDIO!
		object_teleport( player3(), tele_flag_4 );
	end
	
	fade_in(0,0,0,8);
	screen_effect_new(environments\solo\m90_sacrifice\fx\portal\parts\portal_exit_sfx.area_screen_effect, tele_flag_1);
end


script static void f_teleport_player_to_next_portal( unit player_teleport, cutscene_flag tele_flag, point_reference pt )
	local long player_index = -1;
	
	if player_teleport == player0 then
		player_index	=  player_00 ;
	elseif player_teleport == player1 then
		player_index	=  player_01 ;
	elseif player_teleport == player2 then
		player_index	=  player_02 ;
	elseif player_teleport == player3 then
		player_index	=  player_03 ;
	else
		player_index	=  player_00 ;
	end
	
//	effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, pt);
	//player_enable_input ( FALSE );
		fade_out_for_player ( player_get( player_index ) );
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player0, 1 ); //AUDIO!
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player1, 1 ); //AUDIO!
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player2, 1 ); //AUDIO!
		sound_impulse_start ( 'sound\environments\solo\m090\amb_m90_device_machines\events\amb_m90_dm_portal_flash', player3, 1 ); //AUDIO!
		object_teleport( player_get( player_index ), tele_flag );
		fade_in_for_player ( player_get( player_index ) );
end


script static void f_teleport_return_from_teleport()
		sleep(10);	
		player_enable_input ( TRUE );

end

script dormant f_teleport_objcon_controller()

	garbage_collect_now();
	sleep_until (volume_test_players (tv_teleport_objcon_10) or s_objcon_teleport >= 10, 1);
		if s_objcon_teleport <= 10 then
			s_objcon_teleport = 10;
			dprint("s_objcon_teleport = 10 ");
		end
					
	sleep_until (volume_test_players (tv_teleport_objcon_20) or s_objcon_teleport >= 20, 1);
		if s_objcon_teleport <= 20 then
			s_objcon_teleport = 20;
			dprint("s_objcon_teleport = 20 ");
		end
			
	sleep_until (volume_test_players (tv_teleport_objcon_30) or s_objcon_teleport >= 30, 1);
		if s_objcon_teleport <= 30 then 
			s_objcon_teleport = 30;
			dprint("s_objcon_teleport = 30 ");
		end
		

		
	sleep_until (volume_test_players (tv_teleport_objcon_40) or s_objcon_teleport >= 40, 1);
		if s_objcon_teleport <= 40 then 
			s_objcon_teleport = 40;
			dprint("s_objcon_teleport = 40 ");
		end
		
	sleep_until( b_Teleporter_Active_3 == TRUE );
		dprint("teleport 3 was activated");
		
		wake(f_teleport_objcon_controller_down);
end

script dormant f_teleport_objcon_controller_down()
	// MAIN PLATFORM REVERSE
	
	sleep_until (volume_test_players (tv_teleport_objcon_45) or s_objcon_teleport >= 45, 1);
		if s_objcon_teleport <= 45 then 
			s_objcon_teleport = 45;
			dprint("s_objcon_teleport = 45 ");
		end	

	sleep_until (volume_test_players (tv_teleport_objcon_47) or s_objcon_teleport >= 47, 1);
		if s_objcon_teleport <= 47 then 
			s_objcon_teleport = 47;
			dprint("s_objcon_teleport = 47 ");
		end	


		
	sleep_until (volume_test_players (tv_teleport_objcon_50) or s_objcon_teleport >= 50, 1);
		if s_objcon_teleport <= 50 then 
			s_objcon_teleport = 50;
			dprint("s_objcon_teleport = 50 ");
		end		

	//wake( f_teleport_main_down_turrets );

	sleep_until (volume_test_players (tv_teleport_objcon_60) or s_objcon_teleport >= 60, 1);
		if s_objcon_teleport <= 60 then 
			s_objcon_teleport = 60;
			dprint("s_objcon_teleport = 60 ");
		end
		ai_place( sq_for_main_dwn_mid_bishop );

	
	sleep_until (volume_test_players (tv_teleport_objcon_70) or s_objcon_teleport >= 70, 1);
		if s_objcon_teleport <= 70 then 
			s_objcon_teleport = 70;
			dprint("s_objcon_teleport = 70 ");
		end


end

global boolean b_engineroom_catcher_success = TRUE;
global boolean b_engineroom_catcher_reset = FALSE;
global boolean b_bullet_timer_up = FALSE;
global boolean b_bullet_timer_active = FALSE;
global short s_bullet_count = 0;
global boolean b_engineroom_next = TRUE;


script static void f_engineroom_start_bullet_catcher()

	repeat
		//dprint("WAITING TO START");
		sleep_s(6);
		//sleep_until( not b_bullet_timer_active, 1);
			//dprint("a");
			//dprint("START");
			f_engineroom_reset_bullets();
			sleep(1);
			//thread( f_engineroom_start_bullet_timer());
			
			repeat
				if s_bullet_count < 1 or s_bullet_count > 2 then
					f_engineroom_create_catcher( 1 );
					
				else
					f_engineroom_create_catcher( 2 );
				end
					sleep(1);
					f_engineroom_found_a_success();
					sleep(1);
					//dprint("huh");
					kill_thread( l_feo_good_thread );
					kill_thread( l_feo_bad_thread );
					object_destroy( cr_bullet_left );		
					object_destroy( cr_bullet_right );
					b_catcher_halt = FALSE;
				sleep(15);
			until( s_bullet_count == 4 or not b_engineroom_catcher_success or b_engineroom_done, 1 );
		
		if not b_engineroom_catcher_success then
			//dprint("catcher failure");
			sleep(1);
		end
			
		
	until( b_engineroom_done or b_engineroom_catcher_success, 1);
		if b_engineroom_catcher_success then
				//dprint("TOTAL SUCCESS!!!!");
				f_er_sentinel_event();
		end
end
//1 left
//2 right
script static void f_engineroom_create_catcher( short s_type_good )
		local object catcher_good = NONE;
		local object catcher_bad = NONE;
		
		object_create( cr_bullet_left );		
		object_create( cr_bullet_right );
		sleep(1);
		if s_type_good == 1 then
			
			catcher_good = cr_bullet_left;
			catcher_bad = cr_bullet_right;
			//dprint("left catcher");
		else
			catcher_good = cr_bullet_right;
			catcher_bad = cr_bullet_left;
			//dprint("right catcher");
		end
		sleep(1);
		//sleep_until( object_get_health( catcher ) <= 0 , 1 );
		//	object_destroy(catcher);
		s_bullet_count = s_bullet_count + 1;
		l_feo_good_thread = thread(f_engineroom_organizer( catcher_good, TRUE ));
		l_feo_bad_thread = thread(f_engineroom_organizer( catcher_bad, FALSE ));
			//sleep(15);
			//dprint("boom");
end

global long l_feo_good_thread = -1;
global long l_feo_bad_thread = -1;
global boolean b_good_catcher_done_1st = FALSE;
global boolean b_bad_catcher_done_1st = FALSE;
global boolean b_catcher_halt = FALSE;

script static void f_engineroom_organizer( object catcher, boolean b_good )
	inspect(object_get_health( catcher ));
	local boolean b_right = TRUE;
	if catcher == cr_bullet_left then
		b_right = FALSE;
	end
	
	sleep_until( object_get_health( catcher ) <= 0 , 1 );
		object_destroy( catcher );
		if not b_catcher_halt then
			if b_good then
				if not b_bad_catcher_done_1st then
					b_good_catcher_done_1st = TRUE;
					b_catcher_halt = TRUE;
					
					if b_right then
						effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flag_engineroom_effect_right);
					else
						effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, flag_engineroom_effect_left);
					end
					
					//dprint("good catcher done 1st");
				end
			else
				if not b_good_catcher_done_1st then
					b_bad_catcher_done_1st = TRUE;
					b_catcher_halt = TRUE;
					//print("bad catcher done 1st");
				end
			end
		end
	
end

script static void f_engineroom_found_a_success()
		//local boolean b_success = FALSE;
		
		sleep_until( b_good_catcher_done_1st or b_bad_catcher_done_1st, 1 );
			//if b_good_catcher_done_1st then
				//dprint("SUCCESS");
				
				if b_good_catcher_done_1st then
					//dprint("SUCCESS");
				//	if unit_has_weapon_readied( player0, 'objects\weapons\pistol\storm_stasis_pistol\storm_stasis_pistol.weapon' ) then
						thread(f_m90_trans_beep());
						//effect_new( environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, );
				//	end
						dprint("");
				end
				b_engineroom_catcher_success = b_good_catcher_done_1st;
				b_good_catcher_done_1st = FALSE;
				b_bad_catcher_done_1st = FALSE;
				sleep(3);
end



script static void f_engineroom_reset_bullets()
	dprint("");
	dprint("RESET");
	s_bullet_count = 0;
	b_bullet_timer_active = FALSE;
	b_bullet_timer_up = FALSE;
	b_good_catcher_done_1st = FALSE;
	b_bad_catcher_done_1st = FALSE;
	b_catcher_halt = FALSE;
	kill_thread( l_feo_good_thread );
	kill_thread( l_feo_bad_thread );
	
	object_destroy( cr_bullet_left );		
	object_destroy( cr_bullet_right );
end


script static void f_er_sentinel_event()
	ai_place(sq_ers_kenzie);
end

script command_script cs_sentinel_kenzie()
	//dprint("kenzie, naptime");
	cs_fly_to(ps_engine_room_sent.p1);
	cs_fly_to(ps_engine_room_sent.p0);
	cs_fly_to(ps_engine_room_sent.p2);

	//sleep( 3 );
	if( not b_engineroom_done and object_get_health( sq_ers_kenzie ) > 0 ) then
		//dprint("nite nite kenzie");
		ai_place( sq_ers_kenzie_2 );
		
	end
	sleep(1);
	ai_erase( sq_ers_kenzie );
end


script command_script cs_sentinel_kenzie_2()
	//dprint("night night kenzie");
	sleep_until( b_engineroom_done, 1 );
	cs_fly_to(ps_engine_room_sent.p8);
	cs_fly_to(ps_engine_room_sent.p9);
	cs_fly_to(ps_engine_room_sent.p10);
	object_create( wp__weapon_a_br1 );
	object_create( wp__weapon_a_br2 );
	object_create( wp__weapon_a_br3 );
	sleep(1);
	ai_erase(sq_ers_kenzie_2);

end

script static void f_teleport_manual_open( device dm, cutscene_flag fg )
		effect_new_on_object_marker(  'environments\solo\m90_sacrifice\fx\portal\portal_start.effect', dm, "fx_portal" );	
		sleep(15);
		effect_new_on_object_marker(  'environments\solo\m90_sacrifice\fx\portal\portal_main.effect', dm, "fx_portal" );	
		screen_effect_new(  'environments\solo\m90_sacrifice\fx\portal\parts\portal_sfx.area_screen_effect', fg  );	
		
		sleep_s(2);
end  

script static void f_teleport_manual_close( device dm, cutscene_flag fg )
		effect_new_on_object_marker( 'environments\solo\m90_sacrifice\fx\portal\portal_off.effect', dm, "fx_portal" );
		sleep(15);
		effect_stop_object_marker(  'environments\solo\m90_sacrifice\fx\portal\portal_main.effect', dm, "fx_portal" );
		screen_effect_delete(  'environments\solo\m90_sacrifice\fx\portal\parts\portal_sfx.area_screen_effect', fg  );	
		sleep_s(2);
end

script dormant f_teleport_setup_portals()
	sleep(3);
	//device_set_position_track( dm_teleport_portal_init, 'open:portal', 0.0 );
	device_set_position_track( dm_teleport_portal_init, 'open_portal', 0.0 );
	device_set_position_track( dm_teleport_portal_main_exit_1, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_portal_main_exit_2, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_lab_exit, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_portal_plat_exit, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_portal_to_walls, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_lab_to_main, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_er_enter, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_lab_enter, 'stop_idle', 0.0 );
	
	device_set_position_track( dm_teleport_dummy_1, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_dummy_2, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_dummy_3, 'stop_idle', 0.0 );	
	device_set_position_track( dm_teleport_dummy_4, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_dummy_5, 'stop_idle', 0.0 );
	device_set_position_track( dm_teleport_dummy_6, 'stop_idle', 0.0 );	
		
	//device_animate_position(  dm_teleport_portal_init , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_portal_main_exit_1 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_portal_main_exit_2 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_lab_exit , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_portal_plat_exit , 0 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_portal_to_walls , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_lab_to_main , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_er_enter , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_lab_enter , 1 , 0.1, 0.1, 0.0, TRUE );
	
	device_animate_position(  dm_teleport_dummy_1 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_dummy_2 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_dummy_3 , 1 , 0.1, 0.1, 0.0, TRUE );	
	device_animate_position(  dm_teleport_dummy_4 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_dummy_5 , 1 , 0.1, 0.1, 0.0, TRUE );
	device_animate_position(  dm_teleport_dummy_6 , 1 , 0.1, 0.1, 0.0, TRUE );		
end


script static void f_teleport_open_portal( device dm, real r_time_open, boolean b_from_ground, cutscene_flag fg )
	//device_set_position_track( portal_structure, 'any:idle', 0.0 );
	if b_from_ground then
		dprint("from ground");
		device_animate_position(  dm , 1 , 1.5, 0.1, 0.0, TRUE );
		sleep_s(1.5);
		f_teleport_manual_open( dm, fg );
	else
		f_teleport_manual_open( dm, fg );
	end

	if r_time_open > 0 then
		sleep( r_time_open );
		f_teleport_close_portal( dm, FALSE, fg );
	end
end

script static void f_teleport_close_portal( device dm, boolean b_into_ground, cutscene_flag fg )

		//object_create(dm_teleport_portal_init);
		if b_into_ground then
			dprint("SWITCHING TRACKS!!!!");
			device_set_position_track( dm, 'open:portal', 0.0 );
			device_animate_position(  dm , 1 , 0.0, 0.1, 0.0, TRUE );
			sleep(1);			
			device_animate_position(  dm , 0 , 3.0, 0.1, 0.0, TRUE );
		else
			//device_set_position_track( dm, 'stop_idle', 0.0 );
			f_teleport_manual_close( dm, fg );
		end

end


script static void f_port()
	object_create( test_portal );
			device_set_position_track( test_portal, 'open_portal', 0.0 );
			//device_animate_position(  test_portal , 1 , 5, 0.1, 0.0, TRUE );
	
	sleep(1);
end