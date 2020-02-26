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
//IPO
global boolean b_pc_cortana_plugged_in = FALSE;
global boolean b_powercave_exit_finish = FALSE;
global boolean b_pc_battery_sent_loop_active = TRUE;
global boolean b_2nd_myterydoor_closed = FALSE;
global boolean b_pc_batteryofflinevo_done = FALSE;
global boolean b_testturret = FALSE;
global boolean b_battery_effects_on = TRUE;
global boolean b_battery_1_on = TRUE;
global boolean b_battery_2_on = TRUE;
global boolean b_battery_3_on = TRUE;
global boolean b_battery_4_on = TRUE;
global boolean b_battery_5_on = TRUE;
global boolean b_battery_6_on = TRUE;
global boolean b_battery_7_on = TRUE;
global boolean b_battery_8_on = TRUE;
global short s_battery_heartbeat = 0;
global boolean b_powercave_door_exit_open = FALSE;
global boolean b_monitor_ready_exit = FALSE;
global boolean b_cortana_kidnapped = FALSE;

// =================================================================================================
// =================================================================================================
// POWERCAVE POWER CAVE
// =================================================================================================
// =================================================================================================


script static void bat_debug()
	wake( f_batterysetup );
end

/*
script dormant powercave_doors()
	sleep_until( volume_test_players ( tv_hallway_light_vol_5 ), 1 );
	thread (open_battery_door() );		
	sleep_until( volume_test_players ( tv_powercave_center ), 1 );
	thread (close_battery_door() );		
end

script static void open_battery_door()
	device_set_position_track (dm_citadel_int_door_hall02_01, "device:position", 1 );
	device_animate_position( dm_citadel_int_door_hall02_01, 1.0, 2, 0.1, 0.1, TRUE );
	print ("device_animate_position" );
	wake (forerunner_int_chapter_title );
end

script static void close_battery_door()
	device_animate_position( dm_citadel_int_door_hall02_01, 0.0, 2, 0.1, 0.1, TRUE );
	print ("device_animate_position" ); 
end
*/

script dormant f_batterysetup()
	sleep_until( volume_test_players ( tv_battery_setup ), 1 );
		dprint("battery setup" );

//		wake( f_hallway_cutoff_a );
//		wake( f_hallway_cutoff_b );
//		wake( f_hallway_elevator_door );
//		wake( f_setup_door_lights_init );		
		wake( f_powercave_main );
//		wake( f_hallway_lights );
		//wake (powercave_doors );
end

script dormant f_powercave_main()

	wake( f_powercave_vo );
	wake( f_halograms_init );	
	wake (f_librarian_main);
	//object_hide (battery_bridge, TRUE); //Hide lightbridge sound scenery: AUDIO!
	dprint ( "BRIDGE AUDIO DESTROYED!" );
	object_destroy ( battery_bridge );


	//object_create_folder(bat_glow );
	zone_set_trigger_volume_enable ( "zone_set:zone_set_battery_cavern", FALSE );
	zone_set_trigger_volume_enable("zone_set:zone_set_cavern_librarian_vale", FALSE);
	sleep(1 );

	
	sleep_until( volume_test_players (tv_batteryroom_door_entrance), 1 );
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_1);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_2);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_3);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_4);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_5);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_6);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_7);
		effect_new( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_8);
		pup_play_show(bat_power_show);
		ai_place(battery_sentinels);
		//thread( f_pc_battery_sent(pc_sent_clarise) );
		//thread( f_pc_battery_sent_b() );
		//thread( f_pc_battery_monitor() );
		
		wake( f_valley_cleanup );
		
//		sound_looping_start ( "sound\environments\solo\m020\ambience\amb_bridge02", NONE, 1.0 );
		game_save( );
		//thread( f_start_battery_effects() );

		//dprint(":::close doors:::" );
		thread( f_open_powercave_door() );
		
		sleep_s(3 );
		wake (powercave_cinematic_title );
		sleep_s(2 );
		NotifyLevel("battery switch" );
		sleep_s(3 );
	
		wake( f_powercave_switch );
end

script dormant powercave_cinematic_title()
	//sleep_until( volume_test_players (tv_powercave_center), 1 );
		cui_hud_set_objective_complete("chapter_09");
	cui_hud_set_new_objective("chapter_092");
	//cinematic_set_title (chapter_092 );
end

script static void f_open_powercave_door()

		//sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_gun_door', sn_pcave_battery_door, 1 );
		object_move_by_offset ( sn_pcave_battery_door, 3.5, 0, 0, 3.0 );
		wake (m40_cortana_confusion_powercave_room );
	
end



script dormant f_halograms_init()
	
	//object_create(dm_halogram_cannon_1 );
	//object_create(dm_halogram_cannon_2 );
	//object_create(dm_halogram_cannon_3 );
	//object_create(dm_halogram_cannon_4 );
	sleep(1 );
	wake( f_halogram_light_init );
end


script dormant f_halogram_light_init()

	sleep(1 );

	//CANNON HALOGRAMS
	 	effect_new_at_ai_point ("fx\library\light\light_red\light_red.effect", pts_bat.plight_1 ); 
	 	effect_new_at_ai_point ("fx\library\light\light_red\light_red.effect", pts_bat.plight_3 ); 
end

/*script dormant f_halogram_shutdown()

		object_move_to_flag ( dm_halogram_cannon_1, 2.0, halogram_1 );	
		object_move_to_flag ( dm_halogram_cannon_2, 2.0, halogram_2 );	
		object_move_to_flag ( dm_halogram_cannon_3, 2.0, halogram_3 );	
		object_move_to_flag ( dm_halogram_cannon_4, 2.0, halogram_4 );	
	 	effect_new_at_ai_point ("fx\library\light\light_red\light_red.effect", pts_bat.plight_2 ); 
	 	effect_new_at_ai_point ("fx\library\light\light_red\light_red.effect", pts_bat.plight_4 ); 
end*/

script static void f_activator_get( object trigger, unit activator )
	g_ics_player = activator;

	if ( trigger == domain_terminal_button ) then
		f_narrative_domain_terminal_interact( 3, domain_terminal, domain_terminal_button, activator, 'pup_domain_terminal' );
	end
	
end

script dormant f_powercave_switch()

	NotifyLevel("Activate Battery Console" );
	sleep_s(5);
	object_create(bt_powercave_battery_button );
	f_blip_object (bt_powercave_battery_button, "activate" );
//	device_group_set_immediate (bt_powercave_battery_button, 1 );
	sleep_until( device_get_position(bt_powercave_battery_button) != 0 );
		local long bat_show = pup_play_show(bat_cortana_show);
		//wake (m40_cortana_powercave_plinth_dialogue );
		f_unblip_object (bt_powercave_battery_button );

		sleep(300);
		NotifyLevel("battery offline" );
		//wake( f_halogram_shutdown );
		//thread( f_pc_battery_shutdown_seq() );
		sleep_s(2 );
		thread( f_close_powercave_door() );
		sleep_until(not pup_is_playing(bat_show ));		
		wake( f_drop_off_cortana_pc );	
		wake (m40_cortana_powercave_plinth_trouble );
end

script static void f_close_powercave_door()
	camera_shake_all_coop_players( 0.5, 0.4, 1, 2, powercave_door_camera_shake );
//	thread( f_redlight_on( sn_pcave_battery_door ) );
	//sound_impulse_start ('sound\environments\solo\m020\machines_devices\s_dm_gun_door', sn_pcave_battery_door, 1 );
	object_move_by_offset ( sn_pcave_battery_door, 1.5, 0, 0, -3.0 );
	
	b_2nd_myterydoor_closed = TRUE;
end




script dormant f_drop_off_cortana_pc()
		NotifyLevel("cortana plugged in power cave" );
		b_pc_cortana_plugged_in = TRUE;
		wake( f_pc_disappear_cortana );
		wake( f_close_liberry_door_entrance );
		
		
	sleep_until( LevelEventStatus("cortana disappeared done"), 1 );
		sleep(1);
		sleep_until(not PreparingToSwitchZoneSet(), 1);
		zone_set_trigger_volume_enable ( "zone_set:zone_set_battery_cavern", TRUE );
		//thread( f_insertion_zoneload(DEF_S_ZONESET_BATTERY_CAVERN(), TRUE) );
		
		//sleep_s(2 );
		game_save( );
		objectives_finish (1);
		objectives_show (2);
		
		wake( f_pc_exit_init );
end

script dormant f_pc_exit_init()
		object_destroy_folder( cit_elevator );
		sleep_s(2 );
		//cinematic_set_title ( chapter_095 );
		cui_hud_set_objective_complete("chapter_092");
		cui_hud_set_new_objective("chapter_095");
		thread( f_spawn_pc_turrets() );
		sleep_s(1 );
		
		wake( f_open_powercave_door_exit );
		wake( f_blip_powercave_door_exit );
		wake( f_powercave_finished );
		wake( f_tunnel_doors_init );
		wake( f_tunnel_lights );
		//thread( f_pc_grotto_monitor_greeter() );
end

script dormant f_pc_disappear_cortana()

	sleep_until(LevelEventStatus ("cortana disappeared start"), 1 );
		//effect_new( objects\weapons\rifle\storm_mortar\fx\airborne_detonation.effect, fg_cortana_pc_effect );
		sleep(10 );
		object_set_scale ( pc_cortana, 0.01, 5 );
		sleep(5 );
		object_set_scale ( pc_cortana, 0.5, 5 );
		sleep(5 );
		object_set_scale ( pc_cortana, 0.01, 5 );
		sleep(5 );
		//effect_new( objects\weapons\rifle\storm_mortar\fx\airborne_detonation.effect, fg_cortana_pc_effect );
		object_destroy(pc_cortana );
		
end



script dormant f_open_powercave_door_exit()

	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_BATTERY_CAVERN(), 1 );
//		thread( f_greenlight_on( sn_pcave_door_exit  ) );

		
	sleep_until( volume_test_players(tv_powercave_center), 1 );		
		b_monitor_ready_exit = true;
		//sleep_s(1);
		thread( f_extend_pc_angle_bridge() );
		sleep_s(1.75 );
		
		camera_shake_all_coop_players( 0.5, 0.4, 1, 2, powercave_door_camera_shake );

		sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_d_open_close', sn_pcave_door_exit, 1 );	
		object_move_by_offset ( sn_pcave_door_exit, 2, 0, 0, 1.5 );
		b_powercave_door_exit_open = TRUE;
end





script dormant f_blip_powercave_door_exit()
	sleep_s(150 );
	
	
	if not b_powercave_exit_finish then
		f_blip_flag(fg_batterycave_exit, "default" );
		sleep_until( volume_test_players (tv_powercave_door_exit), 1 );	
			f_unblip_flag(fg_batterycave_exit );
	end
end



script dormant f_powercave_finished()		
		sleep_until( volume_test_players (tv_powercave_door_exit), 1 );	
			b_powercave_exit_finish = TRUE;

end
	
script static void f_extend_pc_angle_bridge()
	object_create_folder( angled_light_bridge );
	sound_impulse_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_pc_lightbridge_2_m40_tunnel_light_spawn', power_cave_lightbridge, 1 );
	dprint ( "SPAWN BRIDGE SOUND!" );
	//object_hide ( battery_bridge, FALSE ); //Unhide lightbridge sound scenery: AUDIO!
	if not object_valid( battery_bridge ) then
		object_create( battery_bridge );
	end
	
	sleep(10 );
	object_create( pc_lightbridge_1 );
	sleep(10 );
	object_create( pc_lightbridge_2 );
	sleep(10 );
	object_create( pc_lightbridge_3 );
	
	
	
	object_create( pc_exit_loc_1 );
	object_create( pc_exit_loc_2 );
	object_create( pc_exit_loc_3 );
	object_create( pc_exit_loc_4 );
	object_create( pc_exit_loc_5 );
	object_create( pc_exit_loc_6 );
	
end




/*script static void f_start_battery_effects()

	thread( start_camera_shake_loop( "weak", "short" ) );
	repeat
	
		if b_battery_1_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_1_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_1_e_2 );			
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
		
		if b_battery_2_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_2_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_2_e_2 );
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
		
		if b_battery_3_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_3_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_3_e_2 );	
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
		
		if b_battery_4_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_4_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_4_e_2 );
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
		
		if b_battery_5_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_5_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_5_e_2 );		
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
		
		if b_battery_6_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_6_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_6_e_2 );		
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
				
		if b_battery_7_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_7_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_7_e_2 );		
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end
				
		if b_battery_8_on then
			effect_new( fx\reach\fx_library\cinematics\boneyard\070la_waypoint_arrival\01\slipspace_rupture_carrier.effect, fg_bat_8_e_1 );
//			effect_new( objects\vehicles\covenant\space_phantom\fx\running\cinematic_gravlift_up.effect, fg_bat_8_e_2 );		
			sleep_rand_s(0.25, 0.75 );
			s_battery_heartbeat = s_battery_heartbeat + 1;
		end

		s_battery_heartbeat = s_battery_heartbeat / 2;
		s_battery_heartbeat = 7 - s_battery_heartbeat;

		if s_battery_heartbeat > 5 then
			sleep_s ( s_battery_heartbeat );
		end
		
	until( b_battery_effects_on == FALSE , 1 );
end*/



script static void f_bat_shutdown_beam(object beam_a, object beam_b)
 thread( f_bat_shutdown_beam_up( beam_a ) );
 thread( f_bat_shutdown_beam_down( beam_b ) );
end

script static void f_bat_shutdown_beam_up(object beam)
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', beam, 1.3 );
	object_move_by_offset ( beam, 2, 0, 0, 3.5 );
end

script static void f_bat_shutdown_beam_down(object beam)
	object_move_by_offset ( beam, 2, 0, 0, -3.5 );
end


script static void f_pc_battery_shutdown_seq()

	thread( stop_camera_shake_loop() );
	camera_shake_all_coop_players( 0.65, 0.45, 1, 0.75, battery_airlock_camera_shake );
	sound_impulse_start ('sound\levels\solo\m45\airlock\airlock_repressurize', NONE, 1 );
	//thread( f_bat_shutdown_beam(pc_bat_01_beam_a, pc_bat_01_beam_b) );
	
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_1, 1.3 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_8);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_8);
	interpolator_start( bat_light_01);
	//object_destroy(bat_glow_1 );
	b_battery_1_on = FALSE;
	sleep(26);
	//thread( f_bat_shutdown_beam(pc_bat_02_beam_a, pc_bat_02_beam_b) );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_2, 1.3 );
	//object_destroy(bat_glow_2 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_1);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_1);
	interpolator_start( bat_light_02);

	b_battery_2_on = FALSE;
	sleep(15);	
	
	camera_shake_all_coop_players( 0.65, 0.45, 1, 0.75, battery_airlock_camera_shake );
	sound_impulse_start ('sound\levels\solo\m45\airlock\airlock_repressurize', NONE, 1 );
	//thread( f_bat_shutdown_beam(pc_bat_03_beam_a, pc_bat_03_beam_b) );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_3, 1.3 );
	//object_destroy(bat_glow_3 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_7);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_7);
	interpolator_start( bat_light_03);
	b_battery_3_on = FALSE;
	sleep(28);
	//thread( f_bat_shutdown_beam(pc_bat_04_beam_a, pc_bat_04_beam_b) );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_4, 1.3 );
	//object_destroy(bat_glow_4 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_2);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_2);
	interpolator_start( bat_light_04);
	b_battery_4_on = FALSE;
	sleep(24);	

	camera_shake_all_coop_players( 0.65, 0.45, 1, 0.75, battery_airlock_camera_shake );
	sound_impulse_start ('sound\levels\solo\m45\airlock\airlock_repressurize', NONE, 1 );
	//thread( f_bat_shutdown_beam(pc_bat_05_beam_a, pc_bat_05_beam_b) );
	b_battery_5_on = FALSE;
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_5, 1.3 );
	//object_destroy(bat_glow_5 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_6);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_6);
	interpolator_start( bat_light_05);
	sleep(20);
	//thread( f_bat_shutdown_beam(pc_bat_06_beam_a, pc_bat_06_beam_b) );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_6, 1.3 );
	//object_destroy(bat_glow_6 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_3);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_3);
	interpolator_start( bat_light_06);
	b_battery_6_on = FALSE;
	sleep(28);	
	
	
	camera_shake_all_coop_players( 0.65, 0.45, 1, 0.75, battery_airlock_camera_shake );
	sound_impulse_start ('sound\levels\solo\m45\airlock\airlock_repressurize', NONE, 1 );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_7, 1.3 );
	//thread( f_bat_shutdown_beam(pc_bat_07_beam_a, pc_bat_07_beam_b) );
	//object_destroy(bat_glow_7 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_5);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_5);
	interpolator_start( bat_light_07);
	b_battery_7_on = FALSE;
	sleep(19);
	//thread( f_bat_shutdown_beam(pc_bat_08_beam_a, pc_bat_08_beam_b) );
	sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_m40_battery_power_down', bat_power_8, 1.3 );
	//object_destroy(bat_glow_8 );
	effect_delete_from_flag( environments\solo\m40_invasion\fx\energy\battery_beam.effect, fx_13_glowbeam_4);
	effect_new( environments\solo\m40_invasion\fx\energy\battery_beam_depletion.effect, fx_13_glowbeam_4);
	interpolator_start( bat_light_08);
	b_battery_8_on = FALSE;
	sleep(15);	
	
        object_set_function_variable(missile_hologram, color_change, 1, 0);
//	sound_looping_stop ( "sound\environments\solo\m020\ambience\amb_bridge02" );

	b_battery_effects_on = FALSE;
end

script static void f_zone_num()
	inspect(current_zone_set_fully_active() );
end


/////////////////////////
// GROTTO
////////////////////////

/*script static void grotto_debug()
			thread( f_spawn_pc_turrets() );
			wake( f_close_liberry_door_entrance );	
			wake( f_tunnel_doors_init );	
			//thread( f_pc_grotto_monitor_greeter() );	
			wake( f_tunnel_lights );
end*/

script dormant f_tunnel_lights()

	
	object_create( tun_light_0 );
	sleep_until( volume_test_players ( tv_tunnel_light_1 ), 1 );	
		object_destroy( tun_light_0 );
		object_create( tun_light_1 );

	sleep_until( volume_test_players ( tv_tunnel_light_2 ), 1 );	
		object_destroy( tun_light_1 );
		object_create( tun_light_2 );

	sleep_until( volume_test_players ( tv_tunnel_light_3 ), 1 );	
		object_destroy( tun_light_2 );
		object_create( tun_light_3 );

	sleep_until( volume_test_players ( tv_tunnel_light_4 ), 1 );	
		object_destroy( tun_light_3 );
		object_create( tun_light_4 );

	sleep_until( volume_test_players ( tv_tunnel_light_5 ), 1 );	
		object_destroy( tun_light_4 );
		object_create( tun_light_5 );

end

script dormant f_tunnel_doors_init()
	sleep_until(volume_test_players(tv_tunnel_open_a),1 );
		//object_move_by_offset ( sn_tunnel_door_a, 2, 0, 0, 1.5 );
	sleep_until(volume_test_players(tv_tunnel_open_b),1 );
	sound_impulse_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_d_open_close', sn_tunnel_door_b, 1 );
	object_move_by_offset (sn_tunnel_door_b, 3, 0, -.6, 1.5 );
end

script static void f_spawn_pc_turrets()

	sleep_until(volume_test_players(tv_cave_spawn_turret),1 );
//		thread( f_greenlight_on( sn_pcave_turret_door  ) );
	//	ai_place( for_pc_turret_01_false );
		//ai_place( for_pc_turret_01 );
		//ai_place( for_pc_turret_02 );
		sleep(10 );
		//ai_erase(for_pc_turret_01_false );
		b_pc_battery_sent_loop_active = FALSE;
		
		//cleanup just in case
		f_unblip_flag(fg_batterycave_exit );
end

/*script static void ActivateTurret(ai turretPilot, unit turretVeh)
  unit_open (turretVeh );
  unit_set_current_vitality (turretVeh, 99999, 0 );
  object_cannot_take_damage (ai_vehicle_get_from_spawn_point(turretPilot) );
  sleep_until( object_get_health (turretVeh) <= 0, 1 ); 
	  dprint ("Turret Destroyed" );
	  ai_braindead (turretPilot, TRUE );
	  ai_disregard (ai_actors (turretPilot), TRUE );
	  unit_close (turretVeh );
end


script command_script cs_stay_in_turret
  print("Initializing Turret." );
  
  
  cs_enable_targeting (TRUE );
  cs_shoot (TRUE );
  cs_enable_moving (TRUE );
  cs_enable_looking (TRUE );
  cs_aim_player (TRUE );
  cs_abort_on_damage (FALSE );
  cs_abort_on_alert (FALSE );
  ai_cannot_die (ai_current_actor, TRUE );
  object_cannot_take_damage (ai_vehicle_get_from_spawn_point(ai_current_actor) );  
  ai_disregard (ai_actors (ai_current_actor), TRUE );
  cs_shoot (FALSE );
  cs_aim_player (ai_current_actor,TRUE );
  sleep_until(b_testturret, 3 );
 		ai_cannot_die (ai_current_actor, FALSE );

end*/

script dormant f_close_liberry_door_entrance()
//eee

	sleep_until( volume_test_players (tv_turretroom_enter) , 1 );
		// start to load the next zone set
		//( f_zoneset_get(DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE()) );

//		thread( f_redlight_on( sn_pcave_turret_door  ) );
		//thread (f_close_giant_door( sn_grotto_block_off ) );

		object_destroy( tun_light_5 );
		object_create (sn_pcave_door_exit_2);
			
	// wait for the zone set to load then do the switch
	sleep(1);
	sleep_until (not preparingToSwitchZoneSet(), 1); // poll whether async load is complete
	zone_set_trigger_volume_enable("zone_set:zone_set_cavern_librarian_vale", TRUE);
	//f_insertion_zoneload( DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE(), TRUE );
	
	// Open the grotto door when the player gets close enough
	sleep_until( volume_test_players (tv_grotto_open_door), 1 );
		ai_erase(battery_sentinels);

//		thread( f_greenlight_on( grotto_door  ) );
	sleep_until( current_zone_set_fully_active() >= DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE(), 1 );
		//ai_place (cavern_sentinels_3);	

		ai_place (cavern_sentinels_4);
		ai_place (cavern_sentinels_5);	
		wake( f_lib_crates_init );
		if b_turret_door_closed then 
			b_turret_door_closed = FALSE;
			// sound_impulse_start ('sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_c_open', grotto_door, 1 );
//			object_move_by_offset ( sn_pcave_turret_door, 3, 0, 0, 2.0 );
		device_set_power (grotto_door, 0 );
		end

//		thread( f_redlight_on( sn_pcave_door_exit  ) );
		sound_impulse_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_d_open_close', sn_pcave_door_exit, 1 );
		object_move_by_offset ( sn_pcave_door_exit, 3, 0, -.6, 1.5 );
		f_cleanup_powercave( );
		
end

script static void f_cleanup_powercave()
	//object_destroy(dm_halogram_cannon_1 );
	//object_destroy(dm_halogram_cannon_2 );
	//object_destroy(dm_halogram_cannon_3 );
	//object_destroy(dm_halogram_cannon_4 );
	object_destroy_folder(battery_beams );
end


/*script static void f_pc_grotto_monitor_greeter()
	sleep_until(volume_test_players(tv_tunnel_exit),1 );

		object_rotate_by_offset ( sn_grotto_monitor_mort, 0.75, 0.75, 0.75, 90, 0, 0 );
		object_move_to_flag ( sn_grotto_monitor_mort, 3, fg_flyto_door_a );
		object_rotate_by_offset ( sn_grotto_monitor_mort, 0.5, 0.5, 0.5, 180, 0, 0 );
		
		repeat 
			object_rotate_by_offset ( sn_grotto_monitor_mort, 0.25, 0.25, 0.25, 0, -45, 0 );
			object_move_to_flag ( sn_grotto_monitor_mort, 1, fg_flyto_door_b );
			object_move_to_flag ( sn_grotto_monitor_mort, 0.55, fg_flyto_door_a );
			object_rotate_by_offset ( sn_grotto_monitor_mort, 0.25, 0.25, 0.25, 0, 45, 0 );
			object_move_to_flag ( sn_grotto_monitor_mort, 0.33, fg_flyto_door_b );
			
			object_move_to_flag ( sn_grotto_monitor_mort, 0.55, fg_flyto_door_a );
			object_rotate_by_offset ( sn_grotto_monitor_mort, 0.25, 0.25, 0.25, 0, -25, 0 );
			object_move_to_flag ( sn_grotto_monitor_mort, 0.75, fg_flyto_door_b );
			object_move_to_flag ( sn_grotto_monitor_mort, 0.65, fg_flyto_door_a );
			object_rotate_by_offset ( sn_grotto_monitor_mort, 0.25, 0.25, 0.25, 0, 25, 0 );
		until( current_zone_set_fully_active() >= DEF_S_ZONESET_LIBRARIAN_VALE(),1 );

end*/


// =================================================================================================
// =================================================================================================
// VO 
// =================================================================================================
// =================================================================================================


script dormant f_powercave_vo()
		
	sleep_until( volume_test_players (tv_batteryroom_door_entrance), 1 );
		// 141 : There, along the back wall.
		sleep_s( 3 );

		//sleep (30 * 2 );
		
	sleep_until( LevelEventStatus("Activate Battery Console"), 1 );		
//		sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05600', NONE, 1 );
	//	sleep_s( 3 );
		//jack me into that console
	//	sound_impulse_start ('sound\environments\solo\m010\vo\M_M10_Cortana_03120', NONE, 1 );
	//	sleep (30 * 6 );
 
		
//		storyblurb_display(ch_blurb_powercave  , 3, FALSE, FALSE );
	sleep_until( LevelEventStatus("battery offline"), 1 );
		// 142 : Cortana to Infinity. The generators are offline. How’s it look from up there?
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05700', NONE, 1 );
	//	sleep (30 * 5 );
		
		// 143 : ---ccopmlished --ortana! ---uns dis---! ---port--- yspy Comp---
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Del_Rio_05800', NONE, 1 );
	//	sleep (30 * 5 );
		
		// 144 : From the sounds of things we did OK. Now to get back to Gypsy Company and see about that gravity well.
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05900', NONE, 1 );
	//	sleep (30 * 5 );
		
		b_pc_batteryofflinevo_done = TRUE;
//		storyblurb_display(ch_blurb_powercave_off  , 4, FALSE, FALSE );
		
//a little to early
/*
	sleep_until( b_2nd_myterydoor_closed , 1 );
		// 145 : Alright, this has officially stopped being cute! It’s about time I showed this place who’s ‘Boss’! Jack me into one of those consoles.
		sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06000', NONE, 1 );
		sleep (30 * 8 );	
*/
	sleep_until( b_pc_cortana_plugged_in and b_pc_batteryofflinevo_done, 1 );
		dprint("This... this isn’t right. Where is this coming fr-- (sudden shock) WAIT! WA-WA--WAAAAAAAAAIT!!!!" );
		// 146 : This... this isn’t right. Where is this coming fr-- (sudden shock) WAIT! WA-WA--WAAAAAAAAAIT!!!!
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_06100', NONE, 1 );
	//	sleep (30 * 7 );
		
		NotifyLevel("cortana disappeared start" );
		// 147 : Cortana! Cortana, what’s happening? Cortana?!?
		dprint("Cortana! Cortana, what’s happening? Cortana?!?" );
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_06200', NONE, 1 );
	//	sleep (30 * 4 );
		
		NotifyLevel("cortana disappeared done" );

end


/*script static void pc_halogram_1()
	device_set_overlay_track( dm_halogram_cannon_1, 'any:pew' );
	//device_animate_overlay( dm_cannon_1, 1, 27.5, 0, 0 );
	//sleep( 30 * 27.5 );
	device_animate_overlay( dm_halogram_cannon_1, 27, 0.1, 0, 0 );

end

script static void pc_halogram_2()
	device_set_position_track( dm_halogram_cannon_2, 'any:pew', 0 );
	print("setposition" );
	sleep_s(3 );
	print("heh" );
	device_set_power( dm_halogram_cannon_2, 0.0 );
	sleep_s(3 );
	print( "go back" );
	device_set_power( dm_halogram_cannon_2, 1.0 );
	device_animate_position( dm_halogram_cannon_2, 0.0, 10.0, 0.0, 0.0, TRUE );

	/*
	device_set_overlay_track( dm_halogram_cannon_2, 'any:pew' );
	device_animate_overlay( dm_halogram_cannon_2, 10.0, 10.0, 0.0, 0.0 );
	print("setposition" );
	sleep_s(5 );
	print("heh" );
	device_set_power( dm_halogram_cannon_2, 0.0 );
	sleep_s(5 );
	print( "go back" );
	device_set_power( dm_halogram_cannon_2, 1.0 );
	device_animate_overlay( dm_halogram_cannon_2, 0.0, 10.0, 0.0, 0.0 );
	*/
//end
