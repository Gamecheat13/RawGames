//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_sacrifice
//	Insertion Points:	start (or ist)	- Beginning
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================



script startup f_jump_init()
	sleep_until(volume_test_players(tv_jump_eye_init) or volume_test_players(tv_walls_end),1);
		dprint("INIT::: Jump");
		set_broadsword_respawns ( false );
		data_mine_set_mission_segment ("m90_jump");
		garbage_collect_now();		
		//object_create(dm_jump_tube);
		sleep(1);		
		//object_create(dm_eye_jump_aperture);
		//object_create(dm_eye_core_dome);
		object_create( f_cold_front_door );
		object_create_folder(crs_jump);
		object_create_folder(dms_jump);
		sleep(3);

		
		wake( f_jump_ap_wait );
		thread(f_jump_eye_open());
		
		wake( f_jump_start );
		wake( f_jump_end );
		wake ( nar_jump_init );
		wake( f_jump_setup_portal );
		wake( f_jump_portal_start_wait );
		
		//sleep(60);
		wake(f_jump_waypoint);
		thread(f_jump_on_low_g());
		
		// Narrative
		//thread (nar_jump2());
		
		
		sleep_until(volume_test_players(tv_jump_start_grav),1);
			
			effect_new(environments\solo\m90_sacrifice\fx\energy\m90_cortana_gravlift.effect, flg_jump_tube_bottom);
			effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gravlift_tube.effect, flg_jump_tube_bottom, flg_jump_tube_top);
			game_insertion_point_unlock(2);
			sleep(3);
			f_m90_game_save();
		sleep_until(volume_test_players(tv_jump_init_composer),1);

			thread( f_composer_init_jump() );
			wake( f_jump_setup_harvestors );
			f_m90_game_save_no_timeout();			
			
			sleep_until( object_valid(maya_scripted_m90_composerbridge_crate) ,1);
				object_hide( maya_scripted_m90_composerbridge_crate, TRUE);
end

script dormant f_jump_waypoint()
	sleep_until(volume_test_players(tv_jump_enter),1);

		f_blip_flag(fg_jump_jump_wp,"default");
		f_m90_show_chapter_title( title_the_end );
		
end


script dormant f_jump_coldant_aa()

	object_create( jump_aa_1 );
	object_create( jump_aa_2 );
	object_create( jump_aa_3 );
	object_create( jump_aa_4 );
end

script dormant f_jump_start()
	sleep_until(volume_test_players(tv_jump_lower_weapon),1);
		dprint("activate jump tube");
		f_music_m90_v11_horizontal_jump();
		
		object_create(dm_jump_tube);
		object_create(dm_jump_portal_push);
		object_create(dm_jump_portal_push0);
		f_unblip_flag(fg_jump_jump_wp);
		
		if player_valid( player0 )then
			thread( f_jump_clamp_camera_individ( player0 ) );
			thread( f_jump_end_individ( player0 ) );
		end

		if player_valid( player1 )then		
			thread( f_jump_clamp_camera_individ( player1 ) );
			thread( f_jump_end_individ( player1 ) );		
		end
		if player_valid( player2 )then	
			thread( f_jump_clamp_camera_individ( player2 ) );
			thread( f_jump_end_individ( player2 ) );
		end
		if player_valid( player3 )then		
			thread( f_jump_clamp_camera_individ( player3 ) );
			thread( f_jump_end_individ( player3 ) );	
		end

	
	
		//lower weapon and prevent player from shooting during jump
		dprint("lower weapon");

	
end


script static void f_jump_clamp_camera_individ(unit p)
	sleep_until( volume_test_objects( tv_jump_lower_weapon, p ), 1 );
		dprint("do it");
		player_disable_movement(p,true);
		object_cannot_take_damage( p );
		unit_lower_weapon(p, 30);
		player_control_lock_gaze ( p, ps_jump.pt_mid, 360 );	
		sleep(30);			
		player_control_clamp_gaze ( p, ps_jump.pt_end, 35 );
end

script static void f_jump_end_individ(unit p)
	sleep_until( volume_test_objects( tv_jump_land, p ), 1);
		player_disable_movement(p,false);
		//player_disable_movement(false);
		object_can_take_damage( p );
		unit_raise_weapon(p, 30);	
		sleep(30);			
		player_control_unlock_gaze ( p);
end

script static void f_jump_clear_super_jump_clamps_individ( unit p)
		//player_disable_movement( p,false );
		player_disable_movement( p, false );
		player_control_unlock_gaze ( p);
		object_can_take_damage( p );
		unit_raise_weapon(p, 30);	
end

script static void f_jump_clear_super_jump_clamps( )
		if player_valid( player0 )then
			thread( f_jump_clear_super_jump_clamps_individ( player0 ) );
		end

		if player_valid( player1 )then		
			thread( f_jump_clear_super_jump_clamps_individ( player1 ) );
		end
		if player_valid( player2 )then	
			thread( f_jump_clear_super_jump_clamps_individ( player2 ) );

		end
		if player_valid( player3 )then		
			thread( f_jump_clear_super_jump_clamps_individ( player3 ) );
		end
end

script dormant f_jump_end()
	sleep_until(volume_test_players(tv_jump_land),1);


	/*
		//f_space_particles_on(FALSE);
		//raise weapon and allow player to shoot again
		unit_raise_weapon(player0, 30);
		unit_raise_weapon(player1, 30);
		unit_raise_weapon(player2, 30);
		unit_raise_weapon(player3, 30);
		player_enable_input(TRUE); 
		
		player_control_unlock_gaze ( player0());
		player_control_unlock_gaze ( player1() );
		player_control_unlock_gaze ( player2() );
		player_control_unlock_gaze ( player3() );	
		hud_show_crosshair (TRUE);	
		*/
end

script dormant f_init_jump_eye_close()
	// makes sure The Eye Aperture is closed before the player arrives. 
	dprint("close eye");
//	device_set_position_track(dm_eye_jump_aperture, 'any:idle', 0.0 );
//	device_animate_position(dm_eye_jump_aperture, 1.0, 0.0, 0.1, 1.0, TRUE );
end

script static void f_jump_eye_open()
	// opens The Eye Aperture in mid-jump. 
	sleep_until(volume_test_players(tv_jump_eye_open),1);
		//object_create (es_jump_flare_light);
		dprint("Something's happening...");
		sleep (30 * 2);
		
		dprint("The Eye is Opening!");
		//device_animate_position(dm_eye_jump_aperture, 0.0, 30.0, 0.1, 1.0, TRUE );
			thread(  f_jump_eye_open_device() );
	sleep_until (volume_test_players (tv_jump_composer_fire), 1);
		dprint("The Dome is Transforming!");
		g_composer_state = 1;

	
end





script dormant f_jump_setup_portal()

	device_set_position_track( dm_jump_portal_enter, 'stop_idle', 0.0 );	
	//device_animate_position(  dm_jump_portal_enter , 1 , 0.1, 0.1, 0.0, TRUE );
end

script dormant f_jump_portal_start_wait()

	sleep_until( volume_test_players( tv_jump_portal_start ) , 1 );
		sleep( 90 );
		thread( f_teleport_close_portal(dm_jump_portal_enter , true, flg_none ));
		//device_animate_position(  dm_jump_portal_enter , 0 , 1.5, 0.1, 0.0, TRUE );
end
/// CLEANUP ----------------------------------------------------------------------------------------



script dormant f_jump_tube_cleanup()

	dprint("CLEANUP::: Jump");

		object_destroy_folder( crs_jump );
		object_destroy( dm_jump_door_1 );
		object_destroy (dm_jump_tube);
		object_destroy (dm_jump_portal_push);
		object_destroy (dm_jump_portal_push0);
		object_destroy (dm_jump_portal_enter);
end



global boolean b_jump_grav_watcher = TRUE;

script static void f_jump_on_low_g()

	repeat
		sleep_until( volume_test_players( tv_jump_low_g_on ) or volume_test_players( tv_jump_low_g_on_2 ),5);
			if not game_is_cooperative() then
				f_m90_set_low_g_r(0.50);
				dprint("gravity low");
			end
		sleep_until(volume_test_players( tv_jump_normal_g_on ) or volume_test_players( tv_jump_normal_g_on_2 ),5);
			dprint("gravity norm");
			f_m90_set_normal_g();	
	until( b_jump_grav_watcher == FALSE, 5 );
	
end


script dormant f_jump_setup_harvestors()

	object_create(sn_jump_harv_01);
	object_create(sn_jump_harv_02);
	object_create(sn_jump_harv_03);
	object_create(sn_jump_harv_04);
	object_create(sn_jump_harv_05);
	//object_create(sn_jump_harv_06);
	object_create(sn_jump_harv_07);
	object_create(sn_jump_harv_08);
	object_create(sn_jump_harv_09);
	object_create(sn_jump_harv_10);
	flock_create(jump_flock_1);
	flock_create(jump_flock_2);
	//flock_create(jump_flock_3);
	flock_create(jump_flock_4);
	flock_create(jump_flock_5);
	flock_create(jump_flock_6);
	flock_create(jump_flock_7);

	sleep(3);
	wake( f_jump_harvey_09 );	
	thread( f_jump_harv_loop(sn_jump_harv_09,sn_jump_harv_09) );
	thread(f_move_harvestors(sn_jump_harv_01, ps_jump.p_h1));
	thread( f_jump_harv_loop(sn_jump_harv_01,sn_jump_harv_01) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_02, ps_jump.p_h2));
	thread( f_jump_harv_loop(sn_jump_harv_02,sn_jump_harv_02) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_03, ps_jump.p_h6));
	thread( f_jump_harv_loop(sn_jump_harv_03,sn_jump_harv_03) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_04, ps_jump.p_h4));
	thread( f_jump_harv_loop(sn_jump_harv_04,sn_jump_harv_04) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_05, ps_jump.p_h5));
	thread( f_jump_harv_loop(sn_jump_harv_05,sn_jump_harv_05) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_07, ps_jump.p_h7));
	thread( f_jump_harv_loop(sn_jump_harv_07,sn_jump_harv_07) );
	sleep(30);
	thread(f_move_harvestors(sn_jump_harv_08, ps_jump.p_h3));
	thread( f_jump_harv_loop(sn_jump_harv_08,sn_jump_harv_08) );
	thread( f_jump_harv_loop(sn_jump_harv_10,sn_jump_harv_10) );
end

script dormant f_jump_harvey_09()

	sleep_until( volume_test_players( tv_jump_prepare_end) , 1);

		thread(f_m90_rotate_xyz(sn_jump_harv_09, 5, 5, 5, 60, 0, 0));

		sleep_s(3);
		thread( f_move_harvestors(sn_jump_harv_09, ps_jump.p_h9_end));
		
		thread(f_m90_rotate_xyz(sn_jump_harv_10, 7, 5, 5, -45, 0, 0));
		sleep_s(4);
		thread( f_move_harvestors(sn_jump_harv_10, ps_jump.p_h10_end));
end

script static void f_move_harvestors(object o_harvestor, point_reference p_point)
	object_move_to_point(o_harvestor, 160, p_point);
end
	


script dormant f_jump_cleanup_harvestors()

	object_destroy(sn_jump_harv_01);
	object_destroy(sn_jump_harv_02);
	object_destroy(sn_jump_harv_03);
	object_destroy(sn_jump_harv_04);
	object_destroy(sn_jump_harv_05);
	object_destroy(sn_jump_harv_06);
	object_destroy(sn_jump_harv_07);
	object_destroy(sn_jump_harv_08);
	object_destroy(sn_jump_harv_09);
	object_destroy(sn_jump_harv_10);
	
	
	flock_delete(jump_flock_1);
	flock_delete(jump_flock_2);
	//flock_create(jump_flock_3);
	flock_delete(jump_flock_4);
	flock_delete(jump_flock_5);
	flock_delete(jump_flock_6);
	flock_delete(jump_flock_7);
end

script static void f_jump_flash()

	//effect_new_at_ai_point (environments\solo\m10_crash\fx\flash_white.effect, ps_jump.jump_launch);
	//effect_new_at_ai_point (environments\solo\m10_crash\fx\energy\beac_mag_accel_energy.effect, ps_jump.jump_launch);
	sleep(1);
end


script dormant f_jump_ap_wait()

	thread( f_setup_eye_piece( maya_ap_jump_plt_01, 0 ));
	thread(f_setup_eye_piece( maya_ap_jump_plt_02, 0 ));	
	thread(f_setup_eye_piece( maya_ap_jump_plt_03, 0 ));
	thread(f_setup_eye_piece( maya_ap_jump_plt_04, 0 ));
	
	thread(f_setup_eye_piece( maya_ap_jump_01, 0.01 ));
	thread(f_setup_eye_piece( maya_ap_jump_02, 0.01 ));	
	thread(f_setup_eye_piece( maya_ap_jump_03, 0.01 ));
	thread(f_setup_eye_piece( maya_ap_jump_04, 0.01 ));
			

	
	sleep(1);
end



script static void f_jump_eye_open_device()
	//dprint("close?");

	local real r_OPEN_TIME = 25.0;
	local real r_CLOSE_TIME = 18.0;


	device_animate_position( maya_ap_jump_plt_01 , 1.0,r_OPEN_TIME, 0.1, 0.0, FALSE );
	device_animate_position( maya_ap_jump_plt_02 , 1.0,r_OPEN_TIME, 0.1, 0.0, FALSE );
	device_animate_position( maya_ap_jump_plt_03 , 1.0,r_OPEN_TIME, 0.1, 0.0, FALSE );
	device_animate_position( maya_ap_jump_plt_04 , 1.0,r_OPEN_TIME, 0.1, 0.0, FALSE );

	sleep_s( 2 );
	//interpolator_start ( 'jump_moonlight' );
	sleep_s( 3);
	//derez plug //m90_jumpvista_plug
	thread(f_jump_derez_plug());
	sleep_s( 11);
	
	device_animate_position( maya_ap_jump_01, 1.0,r_CLOSE_TIME, 0.1, 0.0, FALSE );		
	device_animate_position( maya_ap_jump_02, 1.0,r_CLOSE_TIME, 0.1, 0.0, FALSE );
	device_animate_position( maya_ap_jump_03, 1.0,r_CLOSE_TIME, 0.1, 0.0, FALSE );
	device_animate_position( maya_ap_jump_04, 1.0,r_CLOSE_TIME, 0.1, 0.0, FALSE );

	sleep_s( r_CLOSE_TIME ) ;
	f_jump_cleanup_eye_ap();
end


script static void f_jump_derez_plug()
	thread(	f_m90_global_rezin( m90_jumpvista_plug , fx_derez ));
	sleep_s(3);
	object_destroy(m90_jumpvista_plug);
end


script static void f_jump_cleanup_eye_ap()
	dprint("clean up eye ap");
	
	object_destroy(maya_ap_jump_plt_01);
	object_destroy(maya_ap_jump_plt_02);
	object_destroy(maya_ap_jump_plt_03);
	object_destroy(maya_ap_jump_plt_04);
	
	object_destroy(m90_jumpvista_plug);
	
end

script static void f_jump_set_doors()
	dprint("force set jump doors");
	device_set_position_track( maya_ap_jump_01, 'any:idle', 0.0 );	
	device_set_position_track( maya_ap_jump_02, 'any:idle', 0.0 );	
	device_set_position_track( maya_ap_jump_03, 'any:idle', 0.0 );	
	device_set_position_track( maya_ap_jump_04, 'any:idle', 0.0 );	
	device_animate_position( maya_ap_jump_01, 1.0, 0, 0.1, 1.0, FALSE );		
	device_animate_position( maya_ap_jump_02, 1.0, 0, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_jump_03, 1.0, 0, 0.1, 1.0, FALSE );
	device_animate_position( maya_ap_jump_04, 1.0, 0, 0.1, 1.0, FALSE );
	
end


script static void harv()
	
	//f_init_harvestor( sn_jump_harv_01);
	//scenery_animation_idle( sn_jump_harv_01 );
	repeat
	scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle");
	//device_animate_overlay( sn_jump_harv_01, 0.0, 2.5, 0, 0 );
	sleep_s(1);
	scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:2:combat:any:idle:open");
	sleep_s(1);
	scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open");
	//device_animate_overlay( sn_jump_harv_01, 0.0, 2.5, 0, 0 );
	sleep_s(1);
	scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open:2:combat:any:idle");
	sleep_s(1);
	//scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open:2:combat:any:idle");
	until ( 1 == 0 , 10 );
	
end

script static void f_jump_harv_loop( scenery harv, object_name harv_obj)
	
	//f_init_harvestor( sn_jump_harv_01);
	//scenery_animation_idle( sn_jump_harv_01 );
	repeat
		scenery_animation_start(harv, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle");
		//device_animate_overlay( sn_jump_harv_01, 0.0, 2.5, 0, 0 );
		sleep_rand_s(3,8);
		scenery_animation_start(harv, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:2:combat:any:idle:open");
		sleep_s(1);
		scenery_animation_start(harv, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open");
		//device_animate_overlay( sn_jump_harv_01, 0.0, 2.5, 0, 0 );
		sleep_rand_s(2,3);
		scenery_animation_start(harv, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open:2:combat:any:idle");
		sleep_s(3);
	//scenery_animation_start(sn_jump_harv_01, objects\vehicles\forerunner\storm_harvester\storm_harvester, "combat:any:idle:open:2:combat:any:idle");
	until ( not object_valid( harv_obj ) , 10 );
	
end

// === f_init: init function
script static void f_init_harvestor( device obj)

	// set it's base overlay animation to 'any:idle'
		device_set_overlay_track( obj, 'combat:any:idle' );
		device_animate_overlay( obj, 0.0, 2.5, 0, 0 );
		
		sleep(90);
end

