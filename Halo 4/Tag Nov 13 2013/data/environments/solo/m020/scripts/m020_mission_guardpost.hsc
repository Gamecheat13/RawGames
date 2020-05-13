; =================================================================================================
; =================================================================================================
; *** GLOBALS ***
; =================================================================================================
; =================================================================================================

; objective control
global short s_objcon_gpi_center = 0;

global boolean b_player_lost_check = FALSE;
global boolean b_player_activated_core_right = FALSE;
global boolean b_player_activated_core_left = FALSE;
global boolean b_terminal_button_pressed = FALSE;
global boolean b_core_check_1 = FALSE;
global boolean b_core_check_2 = FALSE;
global boolean b_bridge_button_hit = FALSE;	// not really needed
global boolean b_first_core_complete = FALSE;
global boolean b_activated_bridge_switch_didact = FALSE;
global boolean b_activated_bridge_switch_librarian = FALSE;

global unit g_ics_player													= NONE;
global unit g_ics_player1													= NONE;
global unit g_ics_player2													= NONE;
global unit g_ics_player3													= NONE;
global unit g_ics_player4													= NONE;

; =================================================================================================
; =================================================================================================
; *** GUARDPOST INTERIOR ***
; =================================================================================================
; =================================================================================================

//WAKE BEGINNING
script dormant f_gp_int_main()
	//OPENS DOOR INTO CATHEDRAL INTERIOR
	wake (f_gp_int_start);
	wake (f_open_gpi_door);

end

//OPEN INNER CATHEDRAL AIRLOCK DOOR
script dormant f_open_gpi_door()
	dprint ("OPENING AIRLOCK DOOR");
	sleep (30*1);
	dm_gpi_airlock_door_02->open();
	dm_gpi_airlock_door_02->auto_trigger_close( tv_back_area, TRUE, TRUE, TRUE );

end


//WAKE CATHEDRAL INTERIOR
script dormant f_gp_int_start()
	dprint (":: BEGIN CATHEDRAL INTERIOR ::");
	
//TURN OFF BOTH CORE BUTTONS AT BEGINNING
	device_set_power (m20_didact_terminal, 0);
	device_set_power (m20_librarian_terminal, 0);
	//device_set_power (map_button_01, 0);
	device_set_power (bridge_switch_didact, 0);
	device_set_power (bridge_switch_librarian, 0);
	dprint ("DISABLED ALL BUTTONS");

	ai_place (sg_gpi_first_sentinels);
		
	ai_allegiance (player, forerunner);
	
	wake (f_ci_door_right_upper_01);
	wake (f_ci_door_right_upper_02);
	wake (f_ci_door_right_lower_01a);
	wake (f_ci_door_right_lower_01b);
	wake (f_ci_door_left_upper_01);
	wake (f_ci_door_left_lower_01a);
	wake (f_ci_door_left_lower_01b);
			
	wake (f_first_sentinels_travel);
	wake (f_sentinels_warp_01);
	wake (f_gpi_first_dead);
	wake (f_gpi_terminal_button_01);
	wake (living_count_terminal_blip);
	wake (f_gpi_mushroom_platforms);
	wake (f_gpi_hex_cover_rise);
	wake (f_amb_rings_spin);
	wake (f_fx_setup_core_beams); // Sets up the core beam effects
	wake (f_post_one_core_activated);

	data_mine_set_mission_segment (m20_guardpost_int);

	//OBJCON FOR FIRST SENTINELS DROPPING IN
	sleep_until (volume_test_players (tv_first_sentinels), 1);
	dprint (":: OBJCON 5 ::");
	s_objcon_gpi_center = 5;
	
	sleep (30*1);
		
	wake (f_dialog_m20_sentinel_intro);
	
	//OBJCON FOR FIRST SENTINELS LEAVING MAIN TERMINAL
	sleep_until (volume_test_players (tv_sentinels_leave_main_terminal), 1);
	dprint (":: OBJCON 8 ::");
	s_objcon_gpi_center = 8;

end	


// ==========================================
// ALL MONSTER CLOSET DOORS
// ==========================================
script dormant f_ci_door_right_upper_01()
	repeat
		sleep_until (
		object_valid(dm_door_right_upper_01) and object_active_for_script(dm_door_right_upper_01) and
		list_count_not_dead (volume_return_objects_by_type (tv_right_door_upper_01, s_objtype_biped)) > 0
		,1);
		dm_door_right_upper_01->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_right_door_upper_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
				
		dm_door_right_upper_01->close();
		dprint ("door closing");
	
	until (1 == 0);

end

script dormant f_ci_door_right_upper_02()
	repeat
		sleep_until (
		object_valid(dm_door_right_upper_02) and object_active_for_script(dm_door_right_upper_02) and
		list_count_not_dead (volume_return_objects_by_type (tv_right_door_upper_02, s_objtype_biped)) > 0
		,1);
		dm_door_right_upper_02->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_right_door_upper_02, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
				
		dm_door_right_upper_02->close();
		dprint ("door closing");

	until (1 == 0);

end

script dormant f_ci_door_right_lower_01a()
	repeat
		sleep_until (
		object_valid(dm_door_right_lower_01a) and object_active_for_script(dm_door_right_lower_01a) and
		list_count_not_dead (volume_return_objects_by_type (tv_right_door_lower_01, s_objtype_biped)) > 0
		,1);
		dm_door_right_lower_01a->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_right_door_lower_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
				
		dm_door_right_lower_01a->close();
		dprint ("door closing");
		
	until (1 == 0);

end

script dormant f_ci_door_right_lower_01b()
	repeat
		sleep_until (
		object_valid(dm_door_right_lower_01b) and object_active_for_script(dm_door_right_lower_01b) and
		list_count_not_dead (volume_return_objects_by_type (tv_right_door_lower_01, s_objtype_biped)) > 0
		,1);
		dm_door_right_lower_01b->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_right_door_lower_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
				
		dm_door_right_lower_01b->close();
		dprint ("door closing");

	until (1 == 0);

end

script dormant f_ci_door_left_upper_01()
	repeat
		sleep_until (
		object_valid(dm_door_left_upper_01) and object_active_for_script(dm_door_left_upper_01) and
		list_count_not_dead (volume_return_objects_by_type (tv_left_door_upper_01, s_objtype_biped)) > 0
		,1);
		dm_door_left_upper_01->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_left_door_upper_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
				
		dm_door_left_upper_01->close();
		dprint ("door closing");

	until (1 == 0);

end

script dormant f_ci_door_left_lower_01a()
	repeat
		sleep_until (
		object_valid(dm_door_left_lower_01a) and object_active_for_script(dm_door_left_lower_01a) and
		list_count_not_dead (volume_return_objects_by_type (tv_left_door_lower_01, s_objtype_biped)) > 0
		,1);
		dm_door_left_lower_01a->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_left_door_lower_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
		
		dm_door_left_lower_01a->close();
		dprint ("door closing");
		
	until (1 == 0);

end

script dormant f_ci_door_left_lower_01b()
	repeat
		sleep_until (
		object_valid(dm_door_left_lower_01b) and object_active_for_script(dm_door_left_lower_01b) and
		list_count_not_dead (volume_return_objects_by_type (tv_left_door_lower_01, s_objtype_biped)) > 0
		,1);
		dm_door_left_lower_01b->open();
		dprint ("door opening");
		
		sleep_until (
		list_count_not_dead(volume_return_objects_by_type(tv_left_door_lower_01, s_objtype_biped)) <= 0
		,1);
		
		sleep (30);
		
		dm_door_left_lower_01b->close();
		dprint ("door closing");
		
	until (1 == 0);

end
// ==========================================


//DEAD COVENANT EVERYWHERE
script dormant f_gpi_first_dead()
	ai_place (sg_gpi_first_dead);
	sleep (30);
	ai_kill_silent (sg_gpi_first_dead);

end

//rotate ambient spinning rings under main terminal glass
script dormant f_amb_rings_spin()
	repeat
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
		object_rotate_by_offset (cathedral_terminal_spinner, 15, 0, 0, 360, 0, 0);
	until (1 == 0);

end


script dormant f_first_sentinels_travel()
	sleep_until (volume_test_players (tv_first_sentinels), 1);
	sleep (30*3);
	thread (first_sentinel_moves_01());
	thread (first_sentinel_moves_02());
	thread (first_sentinel_moves_03());
	thread (first_sentinel_moves_04());
	thread (first_sentinel_moves_05());
	
end

script static void first_sentinel_moves_01()
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_0, TRUE, ps_first_sentinel_01.p0);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_0, TRUE, ps_first_sentinel_01.p1);

end

script static void first_sentinel_moves_02()
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_1, TRUE, ps_first_sentinel_02.p0);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_1, TRUE, ps_first_sentinel_02.p1);

end

script static void first_sentinel_moves_03()
	sleep (30*1);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_2, TRUE, ps_first_sentinel_03.p0);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_2, TRUE, ps_first_sentinel_03.p1);

end

script static void first_sentinel_moves_04()
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_3, TRUE, ps_first_sentinel_04.p0);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_3, TRUE, ps_first_sentinel_04.p1);

end

script static void first_sentinel_moves_05()
	sleep (30*1);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_4, TRUE, ps_first_sentinel_05.p0);
	cs_fly_by (sq_gpi_first_sentinels_01.spawn_points_4, TRUE, ps_first_sentinel_05.p1);

end



//if one sentinel is killed, warp out the rest in a cascade
script dormant f_sentinels_warp_01()
	sleep_until (ai_living_count (sq_gpi_first_sentinels_01) < 5);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_3);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_4);

end

script dormant f_sentinels_warp_left()
	sleep_until (ai_living_count (sq_sentinel_core_left_01) < 3);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);

end

script dormant f_sentinels_warp_right()
	sleep_until (ai_living_count (sq_sentinel_core_right_01) < 3);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_0);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_1);
	sleep (30);
	ai_kill (sq_gpi_first_sentinels_01.spawn_points_2);

end


// ===============================================================================
// HEX COVER ANIMATION

//SET HEX COVER TO RISE
script dormant f_gpi_hex_cover_rise()
	sleep_until (volume_test_players (tv_gpi_devmach_begin), 1);
	
	sleep (30*1);
	
	dprint ("HEX COVER RISE");
	cat_hex_l_01->animate();
	cat_hex_r_02->animate();
	sleep (60);
	cat_hex_l_03->animate();
	sleep (60);
	cat_hex_r_03->animate();
	sleep (60);
	cat_hex_r_01->animate();
	sleep (60);
	cat_hex_l_02->animate();

end


//MUSHROOM PLATFORMS RISE
script dormant f_gpi_mushroom_platforms()
	sleep_until (volume_test_players (tv_gpi_devmach_begin), 1);
	dprint ("MUSHROOMS RISE");
	cat_rise_plat_01->animate();
	sleep (30);
	cat_rise_plat_03->animate();
	sleep (30);
	cat_rise_plat_02->animate();
	sleep (30);
	cat_rise_plat_04->animate();

end


//SET HEX COVER TO RISE
script dormant f_gpi_hex_cover_fall()
	dprint ("hex cover falling");
	sleep (30);
	thread (f_hex_fall_01());
	sleep (30);
	thread (f_hex_fall_02());
	sleep (30);
	thread (f_hex_fall_03());
	sleep (30);
	thread (f_hex_fall_04());
	sleep (30);
	thread (f_hex_fall_05());
	sleep (30);
	thread (f_hex_fall_06());
		
end
	
script static void f_hex_fall_01()
	cat_hex_l_01->de_animate();
end

script static void f_hex_fall_02()
	cat_hex_r_02->de_animate();
end

script static void f_hex_fall_03()
	cat_hex_l_03->de_animate();
end

script static void f_hex_fall_04()
	cat_hex_r_03->de_animate();
end

script static void f_hex_fall_05()
	cat_hex_r_01->de_animate();
end

script static void f_hex_fall_06()
	cat_hex_l_02->de_animate();
end

//RIGHT CORE HEX RISES
script dormant f_gpi_hex_cover_right()
	cat_hex_r_01->animate();
	sleep (30*1);
	cat_hex_l_02->animate();
	sleep (30*2);
	cat_hex_r_03->animate();

end

//LEFT CORE HEX RISES
script dormant f_gpi_hex_cover_left()
	cat_hex_l_01->animate();
	sleep (30*2);
	cat_hex_r_02->animate();
	sleep (30*1);
	cat_hex_l_03->animate();

end

// END OF HEX COVER ANIMATION
//=================================================


//BLIPS MAIN TERMINAL
script dormant living_count_terminal_blip()
	dprint ("waiting for player to reach terminal");
	
	//CORTANA CALLS OUT AND BLIPS MAIN TERMINAL
	sleep_until (volume_test_players (tv_gpi_objcon_30), 1);
	dprint ("CALLING OUT MAIN TERMINAL");
	
	sleep (30*2);
	
	f_blip_object (map_button_01, "activate");
	
	//WAKES CORTANA TELLING CHIEF ABOUT THE TERMINAL (in narrative script)
	sleep_until (volume_test_players (tv_front_pad), 1);
	dprint ("player has reached terminal");
	
	//wake (f_dialog_m20_cathedral_map_open);

end


// ===============================================================================
// ACTIVATE MAIN TERMINAL
// ===============================================================================
script dormant f_gpi_terminal_button_01()
	sleep_until (object_valid (map_button_01), 1);
	sleep_until (device_get_position (map_button_01) > 0.0, 1);
	device_set_power (map_button_01, 0);
	device_set_position( map_button_01, 0.0);
	f_unblip_object (map_button_01);
	
	dprint ("MAIN TERMINAL ACTIVATED");
	
	
	//PLAYER LOD
	streamer_pin_tag("objects\characters\storm_masterchief\storm_masterchief.biped", 0);
	
//WAKE NARRATIVE DIALOG SCRIPT
	wake (f_map_button_dialog);
	
//ENABLE CORE BRIDGE BUTTONS
	wake (f_gpi_bridge_button_didact);
	wake (f_gpi_bridge_button_librarian);
	dprint ("BRIDGE BUTTON UI ACTIVE");
	
//WAKE BOTH SENTINEL PRE-CORE SENTINELS
	wake (sentinel_core_right);
	wake (sentinel_core_left);
	
//WAKE ALL POST-CORE ENCOUNTER POSSIBILITIES
	wake (f_post_core_encounter_right);
	wake (f_post_core_encounter_left);
	wake (f_post_core_encounter_both);
		
	b_terminal_button_pressed = TRUE;
	
	sleep (30*8);
	
	ai_kill (sg_gpi_first_sentinels);
	
end


//THIS GETS WOKEN BY NARRATIVE SCRIPT
script dormant m20_blip_terminal_locations()
	f_blip_flag (flag_left_core, "activate");
	f_blip_flag (flag_right_core, "activate");
	
	//STOP LOD
	streamer_unpin_tag("objects\characters\storm_masterchief\storm_masterchief.biped", 0);
	
	//ACTIVATE CORES
	wake (f_gp_int_core_01);
	wake (f_gp_int_core_02);
	
end


script dormant m20_blip_core_right()
	dprint ("starting right core blip timer");
	sleep (30*12);
	dprint ("right core blipped and active");
	f_blip_flag (flag_right_core, "activate");
	wake (f_gp_int_core_01);
	
end

script dormant m20_blip_core_left()
	dprint ("starting left core blip timer");
	sleep (30*12);
	dprint ("left core blipped and active");
	f_blip_flag (flag_left_core, "activate");
	wake (f_gp_int_core_02);
	
end


//SENTINEL FIRST ENCOUNTER CORE RIGHT (didact)
script dormant sentinel_core_right()
	sleep_until (volume_test_players (tv_sentinel_core_right), 1);
	ai_place (sq_sentinel_core_right_01);
	wake (f_sentinels_warp_right);

//shut off other side spawner
	sleep_forever (sentinel_core_left);
		
end


//RIGHT SIDE SENTINELS MOVE
script command_script sv_entinel_core_right_01()
	object_set_scale (sq_sentinel_core_right_01.spawn_points_0, 0.01, 0);
	object_set_scale (sq_sentinel_core_right_01.spawn_points_0, 1, 60);
	
	cs_fly_by (sentinel_core_right_01.p0);
	cs_fly_by (sentinel_core_right_01.p1);
	cs_fly_by (sentinel_core_right_01.p2);
	cs_fly_by (sentinel_core_right_01.p6);
	cs_fly_by (sentinel_core_right_01.p3);
	cs_fly_by (sentinel_core_right_01.p4);
	cs_fly_by (sentinel_core_right_01.p5);
	
	object_set_scale (sq_sentinel_core_right_01.spawn_points_0, 0.01, 60);
	ai_kill (sq_sentinel_core_right_01.spawn_points_0);	

end

script command_script sv_entinel_core_right_02()
	object_set_scale (sq_sentinel_core_right_01.spawn_points_1, 0.01, 0);
	object_set_scale (sq_sentinel_core_right_01.spawn_points_1, 1, 60);
	
	cs_fly_by (sentinel_core_right_02.p0);
	cs_fly_by (sentinel_core_right_02.p1);
	cs_fly_by (sentinel_core_right_02.p2);
	cs_fly_by (sentinel_core_right_02.p6);
	cs_fly_by (sentinel_core_right_02.p3);
	cs_fly_by (sentinel_core_right_02.p4);
	cs_fly_by (sentinel_core_right_02.p5);
	
	object_set_scale (sq_sentinel_core_right_01.spawn_points_1, 0.01, 60);
	ai_kill (sq_sentinel_core_right_01.spawn_points_1);	

end

script command_script sv_entinel_core_right_03()
	object_set_scale (sq_sentinel_core_right_01.spawn_points_2, 0.01, 0);
	object_set_scale (sq_sentinel_core_right_01.spawn_points_2, 1, 60);
	
	cs_fly_by (sentinel_core_right_03.p0);
	cs_fly_by (sentinel_core_right_03.p1);
	cs_fly_by (sentinel_core_right_03.p2);
	cs_fly_by (sentinel_core_right_03.p6);
	cs_fly_by (sentinel_core_right_03.p3);
	cs_fly_by (sentinel_core_right_03.p4);
	cs_fly_by (sentinel_core_right_03.p5);
	
	object_set_scale (sq_sentinel_core_right_01.spawn_points_2, 0.01, 60);
	ai_kill (sq_sentinel_core_right_01.spawn_points_2);	

end


//LEFT SIDE SENTINELS MOVE
script command_script sv_entinel_core_left_01()
	object_set_scale (sq_sentinel_core_left_01.spawn_points_0, 0.01, 0);
	object_set_scale (sq_sentinel_core_left_01.spawn_points_0, 1, 60);
	
	cs_fly_by (sentinel_core_right_01.p4);
	cs_fly_by (sentinel_core_right_01.p3);
	cs_fly_by (sentinel_core_right_01.p6);
	cs_fly_by (sentinel_core_right_01.p2);
	cs_fly_by (sentinel_core_right_01.p1);
	cs_fly_by (sentinel_core_right_01.p0);
	cs_fly_by (sentinel_core_right_01.p7);
	
	object_set_scale (sq_sentinel_core_left_01.spawn_points_0, 0.01, 60);
	ai_kill (sq_sentinel_core_left_01.spawn_points_0);	

end

script command_script sv_entinel_core_left_02()
	object_set_scale (sq_sentinel_core_left_01.spawn_points_1, 0.01, 0);
	object_set_scale (sq_sentinel_core_left_01.spawn_points_1, 1, 60);
	
	cs_fly_by (sentinel_core_right_02.p4);
	cs_fly_by (sentinel_core_right_02.p3);
	cs_fly_by (sentinel_core_right_02.p6);
	cs_fly_by (sentinel_core_right_02.p2);
	cs_fly_by (sentinel_core_right_02.p1);
	cs_fly_by (sentinel_core_right_02.p0);
	cs_fly_by (sentinel_core_right_02.p7);
	
	object_set_scale (sq_sentinel_core_left_01.spawn_points_1, 0.01, 60);
	ai_kill (sq_sentinel_core_left_01.spawn_points_1);	

end

script command_script sv_entinel_core_left_03()
	object_set_scale (sq_sentinel_core_left_01.spawn_points_2, 0.01, 0);
	object_set_scale (sq_sentinel_core_left_01.spawn_points_2, 1, 60);
	
	cs_fly_by (sentinel_core_right_03.p4);
	cs_fly_by (sentinel_core_right_03.p3);
	cs_fly_by (sentinel_core_right_03.p6);
	cs_fly_by (sentinel_core_right_03.p2);
	cs_fly_by (sentinel_core_right_03.p1);
	cs_fly_by (sentinel_core_right_03.p0);
	cs_fly_by (sentinel_core_right_03.p7);
	
	object_set_scale (sq_sentinel_core_left_01.spawn_points_2, 0.01, 60);
	ai_kill (sq_sentinel_core_left_01.spawn_points_2);	

end



//SENTINEL FIRST ENCOUNTER CORE LEFT (librarian)
script dormant sentinel_core_left()
	sleep_until (volume_test_players (tv_sentinel_core_left), 1);
	ai_place (sq_sentinel_core_left_01);
	wake (f_sentinels_warp_left);

//shut off other side spawner
	sleep_forever (sentinel_core_right);

end


// ===============================================================================
// ACTIVATE CORE BRIDGE SWITCHES
// ===============================================================================

//ACTIVATE DIDACT BRIDGE
script dormant f_gpi_bridge_button_didact()
	device_set_power (bridge_switch_didact, 1);
	dprint ("didact bridge ready");
	
//activate lightbridge
	sleep_until (device_get_position (bridge_switch_didact) > 0.0, 1);
	device_set_power (bridge_switch_didact, 0);
	b_activated_bridge_switch_didact = TRUE;
	
	pup_play_show ("pup_bridge_switch_didact");
	
	sleep (30*2);
	
	object_dissolve_from_marker (bridge_switch_didact, phase_out, button_marker);
	object_create (bridge_didact);
		
	sleep(10);
	object_destroy(bridge_switch_didact);
	object_destroy(bridge_switch_didact_fake);
end


//ACTIVATE LIBRARIAN BRIDGE
script dormant f_gpi_bridge_button_librarian()
	device_set_power (bridge_switch_librarian, 1);
	dprint ("librarian bridge ready");
	
//activate lightbridge
	sleep_until (device_get_position (bridge_switch_librarian) > 0.0, 1);
	device_set_power (bridge_switch_librarian, 0);	
	b_activated_bridge_switch_librarian = TRUE;
	
	pup_play_show ("pup_bridge_switch_librarian");
	
	sleep (30*2);

	object_dissolve_from_marker (bridge_switch_librarian, phase_out, button_marker);
	object_create (bridge_librarian);

	sleep(10);
	object_destroy(bridge_switch_librarian);
	object_destroy(bridge_switch_librarian_fake);
end


script static void kill_didact_button()
	sleep(10);
	object_destroy (bridge_switch_didact);
	object_destroy (bridge_switch_didact_fake);
end


// ===============================================================================
// ACTIVATE RIGHT CORE (DIDACT)
// ===============================================================================
script dormant f_gp_int_core_01()
	device_set_power (m20_didact_terminal, 1);

	sleep_until (device_get_position (m20_didact_terminal) > 0.0, 1);
	b_player_activated_core_right = TRUE;
	device_set_power (m20_didact_terminal, 0);
	sleep_forever (m20_blip_core_right);
	
	//disable bridge button
	if device_get_power (bridge_switch_didact) == 1 then
		dprint ("bridge power was on, shutting off...");
		sleep_forever (f_gpi_bridge_button_didact);
		device_set_power (bridge_switch_didact, 0);
		object_dissolve_from_marker (bridge_switch_didact, phase_out, button_marker);
		dprint ("completed bridge button dissolve");
	else
		dprint ("bridge power was off, ignoring...");
	end
		
	f_unblip_flag (flag_right_core);
			
	pup_play_show ("pup_m20_didact_terminal");
	
	//core platform moves down
	thread (f_didact_lift_anim());
		
	sleep (30*2);
	
	object_dissolve_from_marker (m20_didact_terminal, phase_out, button_marker);
	thread(kill_didact_button());
	
	f_fx_activate_core_beam_left(); // This is named "left" because the bsp structure is called "left"
	
	if (b_core_check_1 == TRUE) and (b_core_check_2 == FALSE) then
				b_core_check_2 = TRUE;
				wake(f_Cathedral_Didact_terminal);
	elseif (b_core_check_1 == FALSE) and (b_core_check_2 == FALSE) then
	      b_core_check_1 = TRUE;
	      wake(f_Cathedral_Librarian_terminal);
	end
	
	dprint ("activated didact core");
	
	if volume_test_objects (tv_damage_players_01, player0) then
	damage_objects (player0, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_01, player1) then
	damage_objects (player1, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_01, player2) then
	damage_objects (player2, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_01, player3) then
	damage_objects (player3, "body", 80); 
	end
			
	garbage_collect_now();
	
end

//play didact elevator sound
script static void f_didact_lift_anim()
	sleep_s (1.5);
	
	device_set_position_track( dm_core_lift_didact, 'any:idle', 0 );
	device_animate_position( dm_core_lift_didact, 1.0, 18.0, 0.0, 0.0, FALSE );
	
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_elevator_start', dm_core_lift_didact, 1 ); //AUDIO!
	sound_looping_start ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_elevator_loop', dm_core_lift_didact, 1 ); //AUDIO!
	
	sleep_until (device_get_position (dm_core_lift_didact) == 1, 1);
	
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_elevator_end', didact_core_elevator, 1 ); //AUDIO!
	sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_elevator_loop' ); //AUDIO!
	
	sleep (30);

	object_create (bridge_didact_lower);

	game_save_no_timeout();

	sleep (30);
	object_destroy (bridge_didact);
	dprint ("completed didact core");
	
	sleep (30*3);
	wake (f_gpi_hex_cover_right);
	
end

script static void kill_librarian_button()
	sleep(10);
	object_destroy (bridge_switch_librarian);
	object_destroy (bridge_switch_librarian_fake);
end


// ===============================================================================
// ACTIVATE LEFT CORE (LIBRARIAN)
// ===============================================================================
script dormant f_gp_int_core_02()
	device_set_power (m20_librarian_terminal, 1);

	sleep_until (device_get_position (m20_librarian_terminal) > 0.0, 1);
	b_player_activated_core_left = TRUE;
	device_set_power (m20_librarian_terminal, 0);
	sleep_forever (m20_blip_core_left);
		
	//disable bridge button
	if device_get_power (bridge_switch_librarian) == 1 then
		dprint ("bridge power was on, shutting off...");
		sleep_forever (f_gpi_bridge_button_librarian);
		device_set_power (bridge_switch_librarian, 0);
		object_dissolve_from_marker (bridge_switch_librarian, phase_out, button_marker);
		dprint ("completed bridge button dissolve");
	else
		dprint ("bridge power was off, ignoring...");
	end
		
	f_unblip_flag (flag_left_core);

	pup_play_show ("pup_m20_librarian_terminal");

	//core platform moves down
	thread (f_librarian_lift_anim());
		
	sleep (30*2);
		
	object_dissolve_from_marker (m20_librarian_terminal, phase_out, button_marker);
	thread(kill_librarian_button());
		
	f_fx_activate_core_beam_right(); // This is named "right" because the bsp structure is called "right"
	
	if (b_core_check_1 == TRUE) and (b_core_check_2 == FALSE) then
				b_core_check_2 = TRUE;
				wake(f_Cathedral_Didact_terminal);
	elseif (b_core_check_1 == FALSE) and (b_core_check_2 == FALSE) then
	      b_core_check_1 = TRUE;
	      wake(f_Cathedral_Librarian_terminal);
	end
		
	dprint ("activated librarian core");
	
	if volume_test_objects (tv_damage_players_02, player0) then
	damage_objects (player0, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_02, player1) then
	damage_objects (player1, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_02, player2) then
	damage_objects (player2, "body", 80); 
	end
	
	if volume_test_objects (tv_damage_players_02, player3) then
	damage_objects (player3, "body", 80); 
	end
		
	garbage_collect_now();
	
end

//LIBRARIAN ELEVATOR MOVES DOWN
script static void f_librarian_lift_anim()
	sleep_s (1.5);
	
	device_set_position_track( dm_core_lift_librarian, 'any:idle', 0 );
	device_animate_position( dm_core_lift_librarian, 1.0, 18.0, 0.0, 0.0, FALSE );

	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_elevator_start', dm_core_lift_librarian, 1 ); //AUDIO!
	sound_looping_start ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_elevator_loop', dm_core_lift_librarian, 1 ); //AUDIO!
	
	sleep_until (device_get_position (dm_core_lift_librarian) == 1, 1);
	
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\amb_m20_machine_elevator_end', dm_core_lift_librarian, 1 ); //AUDIO!
	sound_looping_stop ( 'sound\environments\solo\m020\amb_m20_machines\ambience\amb_m20_machine_elevator_loop' ); //AUDIO!
	
	sleep (30);
	object_create (bridge_librarian_lower);
	
	game_save_no_timeout();
	
	sleep (30);
	object_destroy (bridge_librarian);
	dprint ("completed librarian core");
	
	sleep (30*3);
	wake (f_gpi_hex_cover_left);
	
end


// ===============================================================================
// ENEMY ENCOUNTERS
// ===============================================================================

//RIGHT CORE ACTIVATED (DIDACT)
script dormant f_post_core_encounter_right()
	sleep_until (b_player_activated_core_right == TRUE, 1);
	sleep_forever (f_post_core_encounter_left);
	sleep_forever (f_map_button_dialog_post);
	dprint ("right core completed, spawning left");
	ai_place (sg_gpi_left);

end

//right side grunts move through points
script command_script cs_ci_grunt_rs_01()
	dprint ("moving to point");
	cs_go_to (ps_ci_grunts.p0);

end

script command_script cs_ci_grunt_ls_01()
	dprint ("moving to point");
	cs_go_to (ps_ci_grunts.p6);

end


//LEFT CORE ACTIVATED (LIBRARIAN)
script dormant f_post_core_encounter_left()
	sleep_until (b_player_activated_core_left == TRUE, 1);
	sleep_forever (f_post_core_encounter_right);
	sleep_forever (f_map_button_dialog_post);
	dprint ("left core completed, spawning right");
	ai_place (sg_gpi_right);
	
end


//ONE CORE ACTIVATED
script dormant f_post_one_core_activated()
	sleep_until (
	b_player_activated_core_right == TRUE or 
	b_player_activated_core_left == TRUE
	, 1);
		
	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e02_begin());	

end


//BOTH CORES ACTIVATED
script dormant f_post_core_encounter_both()
	sleep_until (
	b_player_activated_core_right == TRUE and 
	b_player_activated_core_left == TRUE
	, 1);
	
//kill previous core's VO
	sleep_forever (f_dialog_m20_Cathedral_Librarian_terminal);
	
//SPAWN ENEMIES	
	dprint ("spawning middle");
	ai_place (sg_gpi_middle);
	
	//limit spawns based on enemy count
	if (ai_living_count (sq_gpi_grunts_rs_01) <= 0 and ai_living_count (sq_gpi_grunts_rs_02) <= 0) then
		ai_place (sq_gpi_middle_right_grunts_01);
		dprint ("SPAWNING EXTRA SQUAD");
	end
	
	if (ai_living_count (sq_gpi_jackals_rs_01) <= 0) then
		ai_place (sq_gpi_middle_right_jackals_01);
		dprint ("SPAWNING EXTRA SQUAD");
	end
	
	if (ai_living_count (sq_gpi_grunts_ls_01) <= 0 and ai_living_count (sq_gpi_grunts_ls_02) <= 0) then
		ai_place (sq_gpi_middle_left_grunts_01);
		dprint ("SPAWNING EXTRA SQUAD");
	end
	
	if (ai_living_count (sq_gpi_jackals_ls_01) <= 0) then
		ai_place (sq_gpi_middle_left_jackals_01);
		dprint ("SPAWNING EXTRA SQUAD");
	end
	
	//cleanup any left-over elites from first encounter
	f_ai_garbage_erase (sq_gpi_elite_rs_01, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_gpi_elite_rs_02, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_gpi_elite_ls_01, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sq_gpi_elite_ls_02, 10, -1, -1, -1, FALSE);
	

	dprint ("PLAY MUSIC!");
	thread (f_mus_m20_e03_begin());	
	
	sleep_until (volume_test_players (tv_gpi_objcon_10), 1);
	dprint ("spawning end");
	ai_place (sg_gpi_end);
	
	thread (cathedral_int_enemy_cleanup());
	
	wake (f_objcon_gpi_center);
	wake (f_return_to_main_terminal);

end

//CLEAN UP BEGINNING ENEMIES
script static void cathedral_int_enemy_cleanup()
	dprint ("attempting to clean up cathedral start");
	f_ai_garbage_erase (sg_gpi_right, 10, -1, -1, -1, FALSE);
	f_ai_garbage_erase (sg_gpi_left, 10, -1, -1, -1, FALSE);
	
end

//OBJCON MAIN CENTER
script dormant f_objcon_gpi_center()
	dprint ("CENTER OBJCON ACTIVE");

	sleep_until (volume_test_players (tv_gpi_objcon_10), 1);
	dprint (":: OBJCON 10 ::");
	s_objcon_gpi_center = 10;
	
	sleep_until (volume_test_players (tv_gpi_objcon_20), 1);
	dprint (":: OBJCON 20 ::");
	s_objcon_gpi_center = 20;

	sleep_until (volume_test_players (tv_gpi_objcon_30), 1);
	dprint (":: OBJCON 30 ::");
	s_objcon_gpi_center = 30;

end


// ===============================================================================
// BOTH CORES ACTIVATED -- RETURN TO MAIN TERMINAL
// ===============================================================================

//BLIP MAIN TERMINAL AFTER ALL ENEMIES DEAD AND RESET SWITCH
script dormant f_return_to_main_terminal()
//after upper platform enemies are dead, blip the main terminal again
	sleep_until (
		(ai_living_count (sg_gpi_end) == 0
		and ai_living_count (sq_gpi_middle_right_sniper) == 0
		and ai_living_count (sq_gpi_middle_right_grunt_02) == 0
		and ai_living_count (sq_gpi_middle_right_grunt_03) == 0
		and ai_living_count (sq_gpi_middle_left_grunt_02) == 0
		and ai_living_count (sq_gpi_middle_left_grunt_03) == 0)
	, 1);
	
	game_save_no_timeout();
	
	sleep (30*1);
	
	//STOP MUSIC
	thread (f_mus_m20_e02_finish());
	thread (f_mus_m20_e03_finish());
	
	b_cathedral_clear = TRUE;
	
	sleep (30*2);

	f_blip_object (map_button_01, "activate");

	device_set_position (map_button_01, 0);
	device_set_power (map_button_01, 1);
			
	//wake narrative 'return to terminal' script
	wake (f_m20_cathedral_map);
			
	//remove all enemies from scene' to get ready for cutscene
	sleep_until (device_get_position (map_button_01) > 0.0, 1);
	
	garbage_collect_now();
	
	ai_erase (sg_gpi_right);
	ai_erase (sg_gpi_left);
	ai_erase (sg_gpi_middle);
	ai_kill (sg_gpi_sentinel_core_a);
	ai_kill (sg_gpi_sentinel_core_b);
	ai_erase (sg_gpi_end);
	ai_erase (sq_gpi_middle_right_grunts_01);
	ai_erase (sq_gpi_middle_right_jackals_01);
	ai_erase (sq_gpi_middle_left_grunts_01);
	ai_erase (sq_gpi_middle_left_jackals_01);
	
end


//AFTER CUTSCENE IN NARRATIVE SCRIPT, THIS GETS WOKEN
script dormant f_gp_int_teleport_player()
	f_unblip_object (map_button_01);
	garbage_collect_now();

//TELEPORT PLAYER
	object_teleport_to_ai_point (player0(), exit_gp_int.p0);
	object_teleport_to_ai_point (player1(), exit_gp_int.p1);
	object_teleport_to_ai_point (player2(), exit_gp_int.p2);
	object_teleport_to_ai_point (player3(), exit_gp_int.p3);
	
	fade_in (0, 0, 0, 5);
	
	interpolator_stop_all();
	
	zone_set_trigger_volume_enable ("begin_zone_set:15_bridge", TRUE);
	
	game_save_no_timeout();
	
	sleep (30*3);
	
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	dprint ("finished streaming");
	
	zone_set_trigger_volume_enable ("zone_set:15_bridge", TRUE);
	dprint ("ZONESET HAS CHANGED");
	
	thread (f_start_bridge_encounter());	
	
end

script static void f_activator_get( object trigger, unit activator )
	dprint(" -activator- ");
	if trigger==bridge_switch_didact then
		g_ics_player1 = activator;
	elseif trigger==m20_didact_terminal then
		g_ics_player2 = activator;
	elseif trigger==bridge_switch_librarian then
		g_ics_player3 = activator;
	elseif trigger==m20_librarian_terminal then
		g_ics_player4 = activator;
	else
		g_ics_player = activator;
	end
	
	if ( trigger == domain_terminal_button ) then
		f_narrative_domain_terminal_interact( 0, domain_terminal, domain_terminal_button, activator, 'pup_domain_terminal' );
	end
	
end