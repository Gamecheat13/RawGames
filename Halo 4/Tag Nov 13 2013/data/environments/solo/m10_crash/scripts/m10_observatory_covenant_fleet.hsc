
script dormant f_obs_covenant_fleet_02()
		object_cinematic_visibility( obs_fleet_background, TRUE );
		object_cinematic_visibility( obs_fleet_debris, TRUE );
		object_cinematic_visibility( obs_fleet_crash, TRUE );
		object_cinematic_visibility( obs_fleet_drop_pod, TRUE );
		wake(f_attach_fleet);
end

script dormant f_obs_covenant_fleet()
		object_cinematic_visibility( obs_fleet_background, TRUE );
		object_cinematic_visibility( obs_fleet_debris, TRUE );
		object_cinematic_visibility( obs_fleet_crash, TRUE );
		object_cinematic_visibility( obs_fleet_drop_pod, TRUE );
		wake(f_attach_fleet);
		sleep_until(f_check_device_position(obs_blast_shield, 5, DEF_OBS_WINDOW_FRAME_TOTAL), 1 );
		wake(f_cov_ship_fly_over);
		//dprint("launch covenant fleet animation");
		thread(obs_fleet_background->launch());
		//dprint("obs_fleet_background");
		thread(obs_fleet_debris->launch());
		//dprint("obs_fleet_debris->launch()");
		thread(obs_fleet_crash->launch());
		//dprint("obs_fleet_crash->launch()");
		thread(obs_fleet_drop_pod->launch());
		//dprint("obs_fleet_drop_pod->launch()");
		//wake(fx_drop_pods);
		//wake(f_obs_covenant_fleet_clean_up);
end


script dormant f_attach_fleet()
	f_spawn_folder_sc_observatory_fleet();
	//object_create_folder_anew(sc_observatory_fleet);
	objects_attach( obs_fleet_background, "cov_cruiser_01", obs_cruiser_01, "m_attach");
	objects_attach( obs_fleet_background, "cov_cruiser_02", obs_cruiser_02, "m_attach");
	objects_attach( obs_fleet_background, "cov_cruiser_03", obs_cruiser_03, "m_attach");
	objects_attach( obs_fleet_background, "cov_cruiser_04", obs_cruiser_04, "m_attach");
	objects_attach( obs_fleet_background, "cov_cruiser_05", obs_cruiser_05, "m_attach");
	objects_attach( obs_fleet_background, "cov_cruiser_06", obs_cruiser_06, "m_attach");
	
	//objects_attach( obs_fleet_background, "phantom_1_a", obs_phantom_01, "");
	//objects_attach( obs_fleet_background, "phantom_1_b", obs_phantom_02, "");
	//objects_attach( obs_fleet_background, "phantom_1_c", obs_phantom_03, "");
	//objects_attach( obs_fleet_background, "phantom_2_a", obs_phantom_04, "");
	//objects_attach( obs_fleet_background, "phantom_2_b", obs_phantom_05, "");
	//objects_attach( obs_fleet_background, "phantom_2_c", obs_phantom_06, "");
	//objects_attach( obs_fleet_background, "phantom_3_a", obs_phantom_07, "");
	//objects_attach( obs_fleet_background, "phantom_4_a", obs_phantom_08, "");
	//objects_attach( obs_fleet_background, "phantom_5_a", obs_phantom_09, "");
	//objects_attach( obs_fleet_background, "phantom_6_a", obs_phantom_10, "");
	//objects_attach( obs_fleet_background, "phantom_7_a", obs_phantom_11, "");
	
end

/*script dormant f_attach_pods()
	//dprint("pods attached to device machine");
	objects_attach( obs_fleet_drop_pod, "m_obs_grunt_drop_pod_01", obs_pod_1, "sync_action");
	objects_attach( obs_fleet_drop_pod, "m_obs_grunt_drop_pod_02", obs_pod_2, "sync_action");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_01", beac_pod_1, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_02", beac_pod_2, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_03", beac_pod_3, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_04", beac_pod_4, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_05", beac_pod_5, "fx_impact");
	objects_attach( obs_fleet_drop_pod, "m_beacon_drop_pod_06", beac_pod_6, "fx_impact");
end*/

//script dormant f_obs_covenant_fleet_clean_up()
//	sleep_until(device_get_position(obs_fleet_background) == 1);
//	object_destroy(obs_fleet_background);
//	sleep_until(device_get_position(obs_fleet_debris) == 1);
//	object_destroy(obs_fleet_debris);
//	sleep_until(device_get_position(obs_fleet_crash) == 1);
//	object_destroy(obs_fleet_crash);
//	//sleep_until(device_get_position(obs_fleet_drop_pod) == 1);
//	//objects_detach(obs_fleet_drop_pod, beac_pod_1 );
//	//objects_detach(obs_fleet_drop_pod, beac_pod_2 );
//	//objects_detach(obs_fleet_drop_pod, beac_pod_3 );
//	//objects_detach(obs_fleet_drop_pod, beac_pod_4 );
//	//objects_detach(obs_fleet_drop_pod, beac_pod_5 );
//	//objects_detach(obs_fleet_drop_pod, beac_pod_6 );
//	//object_destroy(obs_fleet_drop_pod);
////	object_destroy(maw_door);
//	object_destroy(ambient_debris);
//	f_destroy_folder_sc_observatory_fleet();
//end


script static void f_spawn_folder_sc_observatory_fleet()
object_create_anew(obs_cruiser_01);
object_create_anew(obs_cruiser_02);
object_create_anew(obs_cruiser_03);
object_create_anew(obs_cruiser_04);
object_create_anew(obs_cruiser_05);
object_create_anew(obs_cruiser_06);
//object_create_anew(obs_phantom_01);
//object_create_anew(obs_phantom_02);
//object_create_anew(obs_phantom_03);
//object_create_anew(obs_phantom_04);
//object_create_anew(obs_phantom_05);
//object_create_anew(obs_phantom_06);
//object_create_anew(obs_phantom_07);
//object_create_anew(obs_phantom_08);
//object_create_anew(obs_phantom_09);
//object_create_anew(obs_phantom_10);
//object_create_anew(obs_phantom_11);
end

//script static void f_destroy_folder_sc_observatory_fleet()
//object_destroy(obs_cruiser_01);
//object_destroy(obs_cruiser_02);
//object_destroy(obs_cruiser_03);
//object_destroy(obs_cruiser_04);
//object_destroy(obs_cruiser_05);
//object_destroy(obs_cruiser_06);
//object_destroy(obs_phantom_01);
//object_destroy(obs_phantom_02);
//object_destroy(obs_phantom_03);
//object_destroy(obs_phantom_04);
//object_destroy(obs_phantom_05);
//object_destroy(obs_phantom_06);
//object_destroy(obs_phantom_07);
//object_destroy(obs_phantom_08);
//object_destroy(obs_phantom_09);
//object_destroy(obs_phantom_10);
//object_destroy(obs_phantom_11);
//end

/*script dormant fx_drop_pods()
sleep_until(f_check_device_position(obs_fleet_drop_pod, 550, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 01:::");
sound_impulse_start( sound\environments\solo\m010\scripted\events\m10_cruiser_launch_pod, NONE, 1 );
wake(fx_beac_pod_01);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 602, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 02:::");
wake(fx_beac_pod_02);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 665, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 03:::");
wake(fx_beac_pod_03);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 727, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 04:::");
wake(fx_beac_pod_04);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 790, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 05:::");
wake(fx_beac_pod_05);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 835, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 06:::");
sound_impulse_start( sound\environments\solo\m010\scripted\events\m10_cruiser_launch_pod, NONE, 1 );
wake(fx_obs_pod_01);
sleep_until(f_check_device_position(obs_fleet_drop_pod, 837, DEF_OBS_FLEET_FRAME_TOTAL), 1);
//dprint(":::FIRE FX POD 07:::");
wake(fx_obs_pod_02);
end*/

/*script dormant fx_obs_pod_01()
//shoot
fx_droppod_cov_elite_launch(obs_pod_1, TRUE);
fx_droppod_cov_elite_trail(obs_pod_1, TRUE);
sleep(15);
fx_droppod_cov_elite_launch(obs_pod_1, FALSE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 950, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_elite_trail(obs_pod_1, FALSE);
fx_droppod_cov_elite_impact(obs_pod_1, TRUE);
sleep_s(2);
fx_droppod_cov_elite_impact(obs_pod_1, FALSE);
end*/

/*script dormant fx_obs_pod_02()
//shoot
fx_droppod_cov_elite_launch(obs_pod_2, TRUE);
fx_droppod_cov_elite_trail(obs_pod_2, TRUE);
sleep(15);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 950, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_elite_trail(obs_pod_2, FALSE);
fx_droppod_cov_elite_impact(obs_pod_2, TRUE);
sleep_s(2);
fx_droppod_cov_elite_impact(obs_pod_2, FALSE);
end

script dormant fx_beac_pod_01()
//shoot
fx_droppod_cov_squad_launch(beac_pod_1, TRUE);
fx_droppod_cov_squad_trail(beac_pod_1, TRUE);
sleep(15);
fx_droppod_cov_squad_launch(beac_pod_1, FALSE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 580, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_squad_trail(beac_pod_1, FALSE);
fx_droppod_cov_squad_impact(beac_pod_1, TRUE);
sleep_s(1);
fx_droppod_cov_squad_impact(beac_pod_1, FALSE);
end

script dormant fx_beac_pod_02()
//shoot
fx_droppod_cov_squad_launch(beac_pod_2, TRUE);
fx_droppod_cov_squad_trail(beac_pod_2, TRUE);
sleep(15);
fx_droppod_cov_squad_launch(beac_pod_2, FALSE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 632, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_squad_trail(beac_pod_2, FALSE);
fx_droppod_cov_squad_impact(beac_pod_2, TRUE);
sleep_s(2);
fx_droppod_cov_squad_impact(beac_pod_2, FALSE);
end

script dormant fx_beac_pod_03()
//shoot
fx_droppod_cov_squad_launch(beac_pod_3, TRUE);
fx_droppod_cov_squad_trail(beac_pod_3, TRUE);
sleep(15);
fx_droppod_cov_squad_launch(beac_pod_3, FALSE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 691, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_squad_trail(beac_pod_3, FALSE);
fx_droppod_cov_squad_impact(beac_pod_3, TRUE);
sleep_s(2);
fx_droppod_cov_squad_impact(beac_pod_3, FALSE);
end

script dormant fx_beac_pod_04()
//shoot
fx_droppod_cov_squad_launch(beac_pod_4, TRUE);
fx_droppod_cov_squad_trail(beac_pod_4, TRUE);
sleep(15);
fx_droppod_cov_squad_launch(beac_pod_4, FALSE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 755, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_squad_trail(beac_pod_4, FALSE);
fx_droppod_cov_squad_impact(beac_pod_4, TRUE);
sleep_s(2);
fx_droppod_cov_squad_impact(beac_pod_4, FALSE);
end

script dormant fx_beac_pod_05()
//shoot
fx_droppod_cov_squad_launch(beac_pod_5, TRUE);
fx_droppod_cov_squad_trail(beac_pod_5, FALSE);
sleep(15);
fx_droppod_cov_squad_launch(beac_pod_5, TRUE);
//land
sleep_until(f_check_device_position(obs_fleet_drop_pod, 810, DEF_OBS_FLEET_FRAME_TOTAL), 1);
fx_droppod_cov_squad_trail(beac_pod_5, FALSE);
fx_droppod_cov_squad_impact(beac_pod_5, TRUE);
sleep_s(2);
fx_droppod_cov_squad_impact(beac_pod_5, FALSE);
end

/*
script dormant fx_beac_pod_06()
fx_ droppod_cov_squad_launch(beac_pod_6, b_active);
fx_ droppod_cov_squad_trail(beac_pod_6, b_active);
fx_ droppod_cov_squad_impact(beac_pod_6, b_active);
end
*/