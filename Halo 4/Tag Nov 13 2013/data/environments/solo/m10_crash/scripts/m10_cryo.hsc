
// =================================================================================================
// CRYO
// =================================================================================================

// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
//FIX  57 AND 375
//FIX BEACON 141 AND 442 and 444 and 449
//FIX OBSERVATORY 117 AND 313
global short s_cryo_switch_power = 0;
global short s_obj_cryo = 0;
global object g_ics_player_2 = NONE;
global object g_ics_player_3 = NONE;
global object g_ics_player_4 = NONE;
global object g_sc_cryo_tube_2 = NONE;
global object g_sc_cryo_tube_3 = NONE;
global object g_sc_cryo_tube_4 = NONE;
//DEFINE CRYO OBJECTIVES
global short DEF_CORTANA_CONVO = 8;
global short DEF_CORTANA_TAKEN = 9;

global boolean b_training_look_done = FALSE;
global boolean b_cryo_released = FALSE;
global boolean b_look_up = FALSE;
global boolean b_player_exit_cryo = FALSE;

global boolean invert_bool = false;
global boolean b_fud_rumble_small = FALSE;
global boolean b_fud_rumble_big = FALSE;

// =================================================================================================
// =================================================================================================

script dormant f_cryo_init()
	sleep_until (current_zone_set_fully_active() == S_zoneset_00_cryo_02_hallway_04_armory, 1);
	//dprint  ("::: f_cryo_init :::");
//DATA MINE
	data_mine_set_mission_segment ("m10_cryo");
// Staging
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	f_gravity_set( R_gravity_cryo );	
	f_zero_g_crate();
//	thread(fx_cryotube_light_hold());
	thread(fx_cryo_room_fog());

end

script dormant f_cryo_main()
	sleep_until (current_zone_set_fully_active() == S_zoneset_00_cryo_02_hallway_04_armory, 1);
	sleep_until(b_mission_started == TRUE, 1);
	hud_play_global_animtion (m10_hud_off);
	hud_stop_global_animtion (m10_hud_off);
	g_ics_player = player_get_first_valid();
	g_ics_player_2 = none;
	g_sc_cryo_tube_2 = none;
	if g_ics_player!=player1 then
		g_ics_player_2 = player1;
		g_sc_cryo_tube_2 = sc_cryo_tube_2;
	end
	g_ics_player_3 = none;
	g_sc_cryo_tube_3 = none;
	if g_ics_player!=player2 then
		g_ics_player_3 = player2;
		g_sc_cryo_tube_3 = sc_cryo_tube_3;
	end
	g_ics_player_4 = none;
	g_sc_cryo_tube_4 = none;
	if g_ics_player!=player3 then
		g_ics_player_4 = player3;
		g_sc_cryo_tube_4 = sc_cryo_tube_4;
	end
	
	object_create(fake_holo);
		
	fade_out( 0, 0, 0, 0 );
	//hud_show_radar (FALSE);
	//hud_show_shield (FALSE);
	//hud_show_weapon (FALSE);
	//hud_show_crosshair (FALSE);
	dprint("GIVE STARTING PROFILE");
	f_give_starting_profile();
	effect_new_on_object_marker(environments\solo\m10_crash\fx\screen\fx_cryo_wake_screen.effect, g_ics_player, "" );
	local long show = pup_play_show(cryotube);

		
end

script static void f_make_vulnerable( object player )
	sleep(30);
	object_can_take_damage(player);
end

script static void f_destroy_fake_holo()
	object_destroy(fake_holo);
end

script static void f_give_starting_profile()
	unit_add_equipment (player0, sp_start_mission, TRUE, TRUE);
	unit_add_equipment (player1, sp_start_mission, TRUE, TRUE);
	unit_add_equipment (player2, sp_start_mission, TRUE, TRUE);
	unit_add_equipment (player3, sp_start_mission, TRUE, TRUE);
end

// Accept / Cancel Button 
script static void f_check_choice (player player_num, string_id display_title)
	chud_show_screen_training (player_num, display_title);
	sleep(5);
	unit_action_test_reset (player_num);
	sleep_until	(unit_action_test_context_primary (player_num) or unit_action_test_rotate_weapons (player_num), 1);
	sleep(5);
	//dprint ("player has given input");
	chud_show_screen_training (player_num, "");
	sleep(5);

end

script dormant f_invert_choice() // doesn't invert anything, just unlocks the device
	f_blip_object_for_player (g_ics_player, cryo_switch, "Engage Manual Release");
	device_group_set_immediate(cryo_lock, 1);
end

script dormant f_blip_multi()
	wake (f_blip_p2);
	wake (f_blip_p3);
	wake (f_blip_p4);
end

script dormant f_blip_p2()
	if player_valid(unit(g_ics_player_2)) then
		f_blip_object_for_player (g_ics_player_2, cryo_switch_2, "Engage Manual Release");
		device_group_set_immediate(cryo_lock_2, 1);
	end
end

script dormant f_blip_p3()
	if player_valid(unit(g_ics_player_3)) then
		f_blip_object_for_player (g_ics_player_3, cryo_switch_3, "Engage Manual Release");
		device_group_set_immediate(cryo_lock_3, 1);
	end
end

script dormant f_blip_p4()
	if player_valid(unit(g_ics_player_4)) then
		f_blip_object_for_player (g_ics_player_4, cryo_switch_4, "Engage Manual Release");
		device_group_set_immediate(cryo_lock_4, 1);
	end
end

script static void f_ask_to_confirm (player player_num)                
                
                f_check_choice (player_num, m10_tutorial_choose_setting);
                
                if player_action_test_context_primary() then
                                //dprint ("camera settings accepted");
                                sleep(30*1);       
                                f_set_look_pref (player_num);
                                
                elseif player_action_test_rotate_weapons() then
                                //dprint ("camera settings rejected");
                                sleep(30*1);
                                f_look_rejected (player_num);
                                //chud_show_screen_training (player_num, "");
                end

end

//Look Prefrence Accepted
script static void f_set_look_pref (player player_num)
                chud_show_screen_training (player_num, "");
                sleep (5);
                f_hud_training_timed (player_num, m10_tutorial_set_look, 3);
                sleep (5);
                //NotifyLevel ("look training done");
                b_training_look_done = TRUE;
end

//Look Prefrence Rejected
script static void f_look_rejected (player player_num)
                //dprint ("No I dont like it like that");
                chud_show_screen_training (player_num, "m10_tutorial_set_inverted");
                player_invert_look (player_num);
                sleep (5);
                chud_show_screen_training (player_num, "m10_tutorial_look_around");
                sleep (5);
                
                f_check_choice (player_num, m10_tutorial_choose_setting);
                
                if player_action_test_context_primary() then
                                //dprint ("camera settings accepted");
                                sleep(30*1);       
                                f_set_look_pref (player_num);
                                
                elseif player_action_test_rotate_weapons() then
                                //dprint ("camera settings rejected 2");
                                sleep(30*1);
                                f_look_rejected_2 (player_num);
                end
                
                f_hud_training_timed (player_num, m10_tutorial_set_look, 3);
                
end

script static void f_look_rejected_2 (player player_num)
                //dprint ("No I dont like it like that");
                chud_show_screen_training (player_num, "m10_tutorial_set_inverted");
                player_invert_look (player_num);
                sleep (5);
                chud_show_screen_training (player_num, m10_tutorial_look_around);
                sleep (5);
                f_hud_training_timed (player_num, m10_tutorial_set_look, 3);
                NotifyLevel ("look training done");
                b_training_look_done = TRUE;
//            f_ask_to_confirm (player_num);
                
end




script static void f_wake_cryo_objects()

	object_wake_physics(cr_cryo_01);
	object_wake_physics(cr_cryo_02);
	object_wake_physics(cr_cryo_03);
	object_wake_physics(cr_cryo_04);
	object_wake_physics(cr_cryo_05);
	object_wake_physics(cr_cryo_06);
	object_wake_physics(cr_cryo_07);
	object_wake_physics(cr_cryo_08);
	object_wake_physics(cr_cryo_09);
	object_wake_physics(cr_cryo_10);
	object_wake_physics(cr_cryo_14);
	object_wake_physics(cr_cryo_15);
	object_wake_physics(cr_cryo_16);
	object_wake_physics(cryo_mag);
	sleep (1);

	f_cryo_crate_drop();
end

script static void 	f_wake_cryo_objects_2()
	
repeat
	object_wake_physics(cr_cryo_01);
	object_wake_physics(cr_cryo_02);
	//object_wake_physics(cr_cryo_03);
	object_wake_physics(cr_cryo_04);
	object_wake_physics(cr_cryo_05);
	object_wake_physics(cr_cryo_06);
	object_wake_physics(cr_cryo_07);
	object_wake_physics(cr_cryo_08);
	object_wake_physics(cr_cryo_09);
	object_wake_physics(cr_cryo_10);
	object_wake_physics(cr_cryo_14);
	object_wake_physics(cr_cryo_15);
	object_wake_physics(cr_cryo_16);
	object_wake_physics(cryo_mag);
until (g_cortana_pull_handle == true, 1);

end

script static void f_cryo_crate_drop()
	object_set_velocity(cr_cryo_01, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_02, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_03, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_04, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_05, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_06, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_07, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_08, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_09, 0, 0.1, .1);
	object_set_velocity(cr_cryo_10, 0, 0.1, .1);
	object_set_velocity(cr_cryo_14, 0, 0.1, .1);
	object_set_velocity(cr_cryo_15, 0, 0.1, 0.1);
	object_set_velocity(cr_cryo_16, 0, 0.1, 0.1);
	object_set_velocity(cryo_mag, 0, 0.1, 0.1);

end

script static void f_gravity()
	f_wake_cryo_objects();
	f_gravity_set_time( R_gravity_default, 2, FALSE );
	fx_camera_set( NONE );
	sleep (1);
	fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
	sleep(2);
	thread(f_wake_cryo_objects_2());
end 

script static void f_zero_g_crate()
	triggerobjs_setvelocity_rand( tv_cryo, s_objtype_weapon + s_objtype_crate, 0.25, 0.5, 0.15, 0.25, 0.05, 0.1);
end

// BOOT HUD
script dormant f_hud_boot_up()
	hud_play_global_animtion (m10_hud_on);
	hud_stop_global_animtion (m10_hud_on);
end

script static void f_cryo_ruble_cortana_react()
	thread(sys_screenshake_global_add( 0.3, -0.001, 1.5, -1.5, sfx_cryo_ruble_cortana_react()));
end

script static sound sfx_cryo_ruble_cortana_react()
	sound\environments\solo\m010\scripted\events\m10_cryo_rumble;
end

script static void f_blip_object_for_player (player player_num, object obj, string type)
	chud_track_object_with_priority( obj, f_return_blip_type(type) );
	
	navpoint_track_object_for_player_named (player_num, obj, f_return_blip_type_cui (type));
end

script static void f_hide_cortana( object cor )
	// scale down and fade out cortana over 6 frames
	local real scale=render_hologram_screen_bound_scale;
	render_hologram_screen_bound_scale=scale*1.5; // scale up the bounding box by 50%. otherwise the mini-cortana sticks out of the box a bit
	object_set_scale(cor,0.0001,6);
	sleep(1);
	SetObjectRealVariable(cor,VAR_OBJ_LOCAL_A,0.2);
	sleep(1);
	SetObjectRealVariable(cor,VAR_OBJ_LOCAL_A,0.4);
	sleep(1);
	SetObjectRealVariable(cor,VAR_OBJ_LOCAL_A,0.6);
	sleep(1);
	SetObjectRealVariable(cor,VAR_OBJ_LOCAL_A,0.8);
	sleep(1);
	SetObjectRealVariable(cor,VAR_OBJ_LOCAL_A,1);
	render_hologram_screen_bound_scale=scale;
end
