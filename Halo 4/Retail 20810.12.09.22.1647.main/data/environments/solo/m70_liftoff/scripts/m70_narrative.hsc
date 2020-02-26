
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// lich
// =================================================================================================
// =================================================================================================
// variables

		global boolean b_objective_1_complete = FALSE;
		global boolean b_objective_2_complete = FALSE;
		global boolean b_objective_3_complete = FALSE;
		global boolean b_objective_3b_complete = FALSE;
		global boolean b_objective_4_complete = FALSE;
		global boolean b_objective_lich_complete = FALSE;
		global boolean b_gondola_waypoint_1 = FALSE;
		global boolean b_second_stop = FALSE;
		global object g_ics_player = NONE;
		global boolean g_activate_spires = FALSE;
		global short story_button_state_01 = 0;
		global short story_button_state_02 = 0;
		global short didact_ship_vo_state_01 = 0;
		global short defense_spire_vo_state_01 = 0;
		global boolean b_third_flight_near_didact = FALSE;
		global boolean b_first_flight_defense_spires = FALSE;

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M70_narrative_main()
	sleep_until( b_mission_started == TRUE, 1 );
	print ("::: M70 Narrative Start :::");
	wake(f_nar_infinity);
	wake(f_nar_spire_01);
	wake(f_nar_spire_02);
	wake(f_nar_flight_03);
	wake(f_nar_spire_03);
end

script dormant f_nar_infinity()
	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY, 1 );
	thread(story_button_01());
	thread(story_button_02());
	thread( f_m70_infinity_marine_01_trigger(sq_inf_marine_salute_01.paul) );
	thread( f_m70_infinity_marine_02_trigger(sq_inf_marines_stand_01.cory) );
	thread( f_m70_infinity_marine_03_trigger(sq_inf_marine_salute_02.jacob) );
end

script dormant f_nar_flight_03()
	sleep_until( F_Flight_Zone_Active() and s_flight_state >= S_DEF_FLIGHT_STATE_THIRD(), 1);
	dprint("f_nar_flight_03");
	//wake(f_nar_spire_03_exterior);
end

script dormant f_nar_spire_01()
	sleep_until(f_spire_state_active(DEF_SPIRE_01), 1);
	dprint("f_nar_spire_01");
	wake(f_nar_spire01_intro);
end

script dormant f_nar_spire_02()
	sleep_until(f_spire_state_active(DEF_SPIRE_02), 1);
	dprint("f_nar_spire_02");
	wake(f_nar_spire_02_intro);
end

script dormant f_nar_spire_03()
	sleep_until(f_spire_state_active(DEF_SPIRE_03), 1);
	dprint("f_nar_spire_03");
	wake(f_nar_spire_3_intro);
	wake(f_nar_m70_waypoint_terminal);
end

// =================================================================================================
// =================================================================================================
// Cinematic
// =================================================================================================
// =================================================================================================
// functions
script startup narrative_startup()
	dialog_line_temp_blurb_set( TRUE );
	dialog_line_temp_blurb_pad_set( 3.75 );
end

script static void f_cinematic_open()
local string_id sid_cin_name = "cin_M070_Liftoff";
local short s_zoneset_id = DEF_S_ZONESET_CIN_M070_LIFTOFF;
	dprint( "::: f_cinematic_open :::" );
	f_start_mission( sid_cin_name );

  cinematic_exit_no_fade( sid_cin_name, TRUE ); 
end

	
script static void f_cinematic_close()
local string_id sid_cin_name = "cin_M072_End";
local short s_zoneset_id = DEF_S_ZONESET_CIN_M072_END;
	dprint( "::: f_cinematic_close :::" );
	// called from lich sequence

  cinematic_enter( sid_cin_name, FALSE );

  cinematic_suppress_bsp_object_creation( TRUE );
	f_insertion_zoneload( s_zoneset_id, FALSE );
  cinematic_suppress_bsp_object_creation( FALSE );
	sleep (1);

	f_start_mission( sid_cin_name );

  cinematic_exit_no_fade( sid_cin_name, FALSE ); 

end


global real R_infinity_narrative_conversation_trigger_see_dist = 	7.5;
global real R_infinity_narrative_conversation_trigger_near_dist = 5.0;

script static boolean f_narrative_distance_trigger( object obj_character, real r_distance_see, real r_distance_near, real r_obj_sees_player_angle )

	// defaults
	if ( r_obj_sees_player_angle < 0.0 ) then
		r_obj_sees_player_angle = 25.0;
	end

	// condition
	( not ai_allegiance_broken(player, human) )
	and
	(
		( objects_distance_to_object(Players(),obj_character) <= r_distance_near )
		or
		(
			( objects_distance_to_object(Players(),obj_character) <= r_distance_near )
			and
			objects_can_see_object(Players(),obj_character,25.0)
		)
	)
	and
	(
		( r_obj_sees_player_angle <= 0.0 )
		or
		objects_can_see_player( obj_character, r_obj_sees_player_angle )
	);

end

// =================================================================================================
// =================================================================================================
// infinity_narrative
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_infinity_narrative_init::: Initialize
script dormant f_infinity_narrative_init()
	dprint( "::: f_infinity_narrative_init :::" );

	// initialize modules

	// initialize sub modules
	wake( f_infinity_narrative_npc_barks_init );
	wake( f_infinity_narrative_pelican_init );
	thread (infinity_dock_pa_controller());
	
end

// === f_infinity_narrative_deinit::: Deinitialize
script dormant f_infinity_narrative_deinit()
	dprint( "::: f_infinity_narrative_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_narrative_init );
	sleep_forever(infinity_dock_pa_controller);
	kill_script(infinity_dock_pa_controller);
	// deinitialize modules

	// deinitialize sub modules
	wake( f_infinity_narrative_npc_barks_deinit );
	wake( f_infinity_narrative_pelican_deinit );


end


script static void story_button_01()
  sleep_until (object_valid(story_03_switch) and device_get_position(story_03_switch) != 0);
  object_destroy (story_03_switch);
 	story_button_state_01 = story_button_state_01 + 1;
  thread(f_dialog_m70_story_button_1(story_button_state_01));
end

script static void story_button_02()
   sleep_until (object_valid(story_04_switch) and device_get_position(story_04_switch) != 0);
   object_destroy (story_04_switch);
   story_button_state_02 = story_button_state_02 + 1;
   thread(f_dialog_m70_story_button_2(story_button_state_02));
end

script static void infinity_dock_pa_controller()
	sleep_until( volume_test_players(infinity_dock_pa_controller), 1);
	sleep_s(30);
	thread(f_dlg_infinity_dock_pa_01());
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_03());
	sleep_s(60);
	wake(f_dlg_infinity_comp_intercom);
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_04());
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_05());
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_06());
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_07());
	sleep_s(60);
	thread(f_dlg_infinity_dock_pa_08());

end


// =================================================================================================
// infinity_narrative: NPC barks
// =================================================================================================
// variables
global long L_infinity_narrative_npc_bark_01_thread = 0;
global long L_infinity_narrative_npc_bark_02_thread = 0;
global long L_infinity_narrative_npc_bark_03_thread = 0;
global long L_infinity_narrative_npc_bark_04_thread = 0;


// functions
// === f_infinity_narrative_npc_barks_init::: Initialize
script dormant f_infinity_narrative_npc_barks_init()
	dprint( "::: f_infinity_narrative_npc_barks_init :::" );

	// setup triggers
	L_infinity_narrative_npc_bark_01_thread = thread( f_dlg_infinity_npc_bark(infinity_npcbark_01, NONE, NONE) );	// XXX TODO - Replace NONE with Marine A & B from each group
	L_infinity_narrative_npc_bark_02_thread = thread( f_dlg_infinity_npc_bark(infinity_npcbark_02, NONE, NONE) );	// XXX TODO - Replace NONE with Marine A & B from each group
	L_infinity_narrative_npc_bark_03_thread = thread( f_dlg_infinity_npc_bark(infinity_npcbark_03, NONE, NONE) );	// XXX TODO - Replace NONE with Marine A & B from each group
	L_infinity_narrative_npc_bark_04_thread = thread( f_dlg_infinity_npc_bark(infinity_npcbark_04, NONE, NONE) );	// XXX TODO - Replace NONE with Marine A & B from each group

	// initialize modules

	// initialize sub modules

end

// === f_infinity_narrative_npc_barks_deinit::: Deinitialize
script dormant f_infinity_narrative_npc_barks_deinit()
	dprint( "::: f_infinity_narrative_npc_barks_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_narrative_npc_barks_init );

	kill_thread( L_infinity_narrative_npc_bark_01_thread );
	kill_thread( L_infinity_narrative_npc_bark_02_thread );
	kill_thread( L_infinity_narrative_npc_bark_03_thread );
	kill_thread( L_infinity_narrative_npc_bark_04_thread );

	// deinitialize modules

	// deinitialize sub modules
	wake( f_infinity_narrative_npc_barks_deinit );

end



// =================================================================================================
// infinity_narrative: Pelican
// =================================================================================================
// variables

// functions
// === f_infinity_narrative_pelican_init::: Initialize
script dormant f_infinity_narrative_pelican_init()
	dprint( "::: f_infinity_narrative_pelican_init :::" );
	
	wake( f_infinity_narrative_pelican_trigger );
	
end

// === f_infinity_narrative_pelican_deinit::: Deinitialize
script dormant f_infinity_narrative_pelican_deinit()
	dprint( "::: f_infinity_narrative_pelican_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_narrative_pelican_init );
	sleep_forever( f_infinity_narrative_pelican_trigger );
	sleep_forever( f_infinity_narrative_pelican_action );

	// deinitialize modules

	// deinitialize sub modules

end

// === f_infinity_narrative_pelican_trigger::: Triggers the action
script dormant f_infinity_narrative_pelican_trigger()
	sleep_until( volume_test_players(infinity_pelican_01), 1 );
	dprint( "::: f_infinity_narrative_pelican_trigger :::" );
	
	wake( f_infinity_narrative_pelican_action );
	
end


// === f_infinity_narrative_pelican_action::: Pelican action trigger
script dormant f_infinity_narrative_pelican_action()
	dprint( "::: f_infinity_narrative_pelican_action :::" );
	 thread(f_dlg_infinity_pelican_01());
	
end


script dormant f_infinity_narrative_pelican_02()
	
	dprint( "::: f_dlg_infinity_pelican_02 :::" );
	
	thread(f_dlg_infinity_pelican_02());

	
	
end

script static void f_m70_infinity_marine_01_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_01 );
	end

end

script static void f_m70_infinity_marine_02_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_02 );
	end

end

script static void f_m70_infinity_marine_03_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_03 );
	end

end

script static void f_m70_infinity_marine_04_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_04 );
	end

end

script static void f_m70_infinity_marine_05_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_05 );
	end

end

script static void f_m70_infinity_marine_06_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_06 );
	end

end


script static void f_m70_infinity_marine_07_trigger( ai ai_character )
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_infinity_narrative_conversation_trigger_see_dist, R_infinity_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake( f_dialog_m70_infinity_marine_07 );
	end

end



// =================================================================================================
// =================================================================================================
// flight_narrative
// =================================================================================================
// =================================================================================================


script dormant f_flight_narrative_init()
	dprint( "::: f_flight_narrative_init :::" );
	// initialize sub modules

end

script dormant f_flight_narrative_deinit()
	dprint( "::: f_flight_narrative_deinit :::" );
	// kill functions
	sleep_forever( f_flight_narrative_init );

end

script dormant m70_first_flight()
		kill_script(infinity_dock_pa_controller);
		sleep_forever(infinity_dock_pa_controller);
end

script dormant f_nar_flight_first_didact_reveal()
	if  F_Flight_Zone_Active() then
		wake(f_dlg_flight_didact_reveal);
	end
end

script dormant f_nar_flight_first_spire_approach()
	sleep_until(volume_test_players(tv_flight_spire_01_landing_pad) or volume_test_players(tv_flight_spire_02_landing_pad) or not F_Flight_Zone_Active(), 1);
	//wake(f_dlg_flight_first_spire_approach);
	if  F_Flight_Zone_Active() then
		thread(f_dlg_flight_second_spire_approach());
	end
end

script dormant f_nar_flight_second_didact_ship()
	sleep_until( ( volume_test_players_lookat(tv_didact_warning, 90, 90) and not volume_test_players(tv_flight_spire_01_door) and not volume_test_players(tv_flight_spire_02_door) and vehicle_test_players() ) or not F_Flight_Zone_Active(), 1);
	if  F_Flight_Zone_Active() then
		wake(f_dlg_flight_second_didact_ship_01);
	end
end

script dormant f_nar_flight_second_spire_approach()
	if f_check_first_spire(DEF_SPIRE_01) then
		sleep_until(volume_test_players(tv_flight_spire_02_landing_pad) or not F_Flight_Zone_Active(), 1);
	elseif f_check_first_spire(DEF_SPIRE_02) then
		sleep_until(volume_test_players(tv_flight_spire_01_landing_pad) or not F_Flight_Zone_Active(), 1);
	end
	if F_Flight_Zone_Active() then
		thread(f_dlg_flight_second_spire_approach());
	end
end

script dormant f_nar_flight_third_spire()
	sleep_until(volume_test_players(tv_flight_spire_03_door), 1);
	wake(f_dlg_flight_third_spire_03_approach);
end


script dormant f_nar_spire_03_exterior()
	dprint( "::: f_nar_spire_03_exterior :::" );
  //sleep_until(volume_test_players(spire_03_exterior), 1 );
	wake(f_dlg_flight_third_spire_03);
	thread(f_music_m70_v07_didact_voice_8());

end

script static void f_nar_flight_03_didact_ship()
  sleep_until ( b_third_flight_near_didact == TRUE);
 	didact_ship_vo_state_01 = didact_ship_vo_state_01 + 1;
  thread(f_dlg_flight_c_didact_ship(didact_ship_vo_state_01));
end

script static void f_nar_flight_01_defense()
                sleep_until ( b_first_flight_defense_spires == TRUE);
                 defense_spire_vo_state_01 = defense_spire_vo_state_01 + 1;
                thread(f_dlg_flight_c_didact_ship(didact_ship_vo_state_01));
end


// =================================================================================================
// =================================================================================================
// spire_01_narrative
// =================================================================================================
// =================================================================================================
// variables
// functions


script dormant f_nar_spire01_intro()
	dprint( "::: f_nar_spire01_intro :::" );
  sleep_until(volume_test_players(tv_nar_sp01_intro), 1 );
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire_01_enter_first);
	else
		sleep_s(2);
		wake(f_dlg_spire_01_enter_second);	
	end
	
	sleep_until(volume_test_players(tv_nar_sp01_gondola_start), 1 );
	sleep_s(1);
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire_01_first_gondola_dock);
	else
		wake(f_dlg_spire_01_second_gondola_dock);
	end 
	
	
	dprint( "::: f_nar_spire_01_gondola_enter :::" );
	sleep_until(volume_test_players(tv_nar_sp01_gondola_enter), 1 );
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire_01_first_gondola_nudge);
	else
		wake(f_dlg_spire_01_second_gondola_nudge);	
	end
	
	sleep_s(1);
	
	sleep_until(sp01_gondola_moving == TRUE, 1);
	wake(f_dlg_spire_02_gondola_shields);

end

global boolean tower_01_start_gondola_back_up = FALSE;

script dormant f_nar_spire_01_gondola_first_stop()
	sleep_until(volume_test_players(tv_nar_gondola_stop_01), 1);
	dprint( "::: f_spire_01_gondola_attack :::" );
	f_unblip_flag(flg_sp01_shield_lock);
	sleep_s(4);
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire_01_first_gondola_stop_tower_1);
	else
		wake(f_dlg_spire_01_second_gondola_stop_tower_1);	
	end
	
	sleep_until(device_get_position(dc_spire01_tower_01) != 0, 1);
	
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire1_gondola_button_release);
		//sleep_until(volume_test_players(tv_nar_gondola_fight_01), 1 );
	else
		wake(f_dlg_spire_01_second_gondola_tower_1_end); 
	end
	sleep_s(5);
	sleep_until(tower_01_start_gondola_back_up, 1);
	
	sleep_s(0.25);
	
	wake(f_dlg_spire1_gondola_start_back_up);
	
	sleep_until(ai_living_count(sg_gondola_01) > 0, 1);
	
	sleep_s(0.75);
	
	wake(f_dlg_spire_1_gondola_fight_start);
	
	
end


script dormant f_nar_spire_gondola_ride_02()
	dprint( "::: f_nar_spire_gondola_ride_02 :::" );
	sleep_until(volume_test_players(tv_tower_02_area), 1);
	if f_check_first_spire(DEF_SPIRE_01) == TRUE then
		wake(f_dlg_spire_01_gondola_covenant_attack_02);
	else
		wake(f_dlg_spire_01_second_gondola_stop_tower_1);	
		thread(f_music_m70_v07_didact_voice_3());
	end
	
	sleep_until( not sp01_gondola_moving, 1);
	
	if f_check_first_spire(DEF_SPIRE_01) then
		wake(f_dlg_spire_01_first_gondola_stop_02);
		sleep_s(0.5);
		f_blip_flag( flg_sp01_tw02_switch,"activate");	
	else
		wake(f_dlg_spire_01_second_gondola_stop_tower_2);	
		sleep_s(0.5);
		f_blip_flag( flg_sp01_tw02_switch,"activate");	
	end
	
	sleep_until(device_get_position(dc_spire01_tower_02) != 0, 1);
	
	sleep_s(1.75);
	//xxx scan test
	//if f_check_first_spire(DEF_SPIRE_01) then
		//effect_new (environments\solo\m70_liftoff\fx\scan\dscan_spire1_1.effect, fx_didact_scan_spire1);
		//sleep_s(0.75);
		//wake(f_dlg_spire_01_gondola_didact_scan);
	//end
	
end

script static void f_nar_spire_gondola_pre_carrier_wave_generator()
	dprint("f_nar_spire_gondola_pre_carrier_wave_generator");
	sleep_until(volume_test_players_lookat(tv_spire01_final_shieldbreak, 40, 40) or volume_test_players(tv_spire01_final_shieldbreak), 1);
		f_blip_flag(flg_sp01_shield_lock, "recon");
		if not volume_test_players(tv_spire01_final_shieldbreak) then
			if f_check_first_spire(DEF_SPIRE_01) == TRUE then
				wake(f_dlg_spire_01_gondola_carrier_wave_generator);
			else
				wake(f_dlg_spire_02_gondola_trigger_the_emp);
			end
		end
	sleep_until(volume_test_players(tv_spire01_final_shieldbreak), 1);
	
	if not b_sp01_deactivated then
		thread(f_dlg_spire_01_gondola_carrier_wave_generator_02());
	end
end

script dormant f_nar_spire_gondola_carrier_wave_generator()
	dprint( "::: f_nar_spire_gondola_carrier_wave_generator :::" );
	if not b_sp01_deactivated then
		f_nar_spire_gondola_pre_carrier_wave_generator();
	end
	
	sleep_until(b_sp01_deactivated, 1);
	
	thread(f_m70_objective_complete(ct_obj_spire_01));
	
	if f_check_first_spire(DEF_SPIRE_01) == TRUE then
		wake(f_dlg_spire_01_gondola_carrier_wave_generator_02a);
		thread(f_music_m70_v07_didact_voice_1());
		sleep_s(0.5);
		b_sp01_bishop_attack = TRUE;
		sleep_until(b_final_gondola_ride, 1);
		sleep_s(5);
		wake(f_dlg_spire_01_gondola_carrier_wave_generator_02b);
		
		sleep_until(volume_test_players(tv_nar_sp01_exit), 1 );	
		
		wake(f_dlg_spire_01_gondola_exit);
		
		thread(f_m70_objective_set(ct_obj_pelican_return));
		
	else
		sleep_s(0.5);
		b_sp01_bishop_attack = TRUE;
		sleep_until(ai_is_shooting(sg_sp01_exit_bishops) or ai_combat_status(sg_sp01_exit_bishops) >= 9 or b_final_gondola_ride, 1);
		
		if not b_final_gondola_ride and ai_living_count(sg_sp01_exit_bishops) > 0 then
			thread(f_dialog_m70_callout_look_out());
		end
		
		sleep_until(b_final_gondola_ride, 1);
		sleep_s(5);
		wake(f_dlg_spire_01_second_gondola_final_ride);	
		thread(f_music_m70_v07_didact_voice_4());
		
		sleep_until(volume_test_players(tv_nar_sp01_exit), 1 );	
		
		thread(f_m70_objective_set(ct_obj_pelican_return));
	end
	sleep_s(1);

end

// =================================================================================================
// =================================================================================================
// spire_02_narrative
// =================================================================================================
// =================================================================================================

script dormant f_nar_spire_02_intro()
	dprint( "::: f_nar_spire_02_intro :::" );
	sleep_until(volume_test_players(tv_sp02_nar_intro), 1 );
	if f_check_first_spire(DEF_SPIRE_02) then
		wake(f_dlg_spire_02_first_intro);	
	else
		wake(f_dlg_spire_02_second_intro);
	end
		
	sleep_until(volume_test_players(tv_sp02_nar_cores_enter), 1 );
	if f_check_first_spire(DEF_SPIRE_02) then
		wake(f_dlg_spire_02_first_cores_enter);	
	else
		wake(f_dlg_spire_02_second_cores_enter);		
	end
	
	sleep_until(object_valid(dc_sp02_core_control) and device_get_position(dc_sp02_core_control)> 0.0, 1);
	if f_check_first_spire(DEF_SPIRE_02) == TRUE then
		wake(f_dlg_spire_02_first_cores_start);	
	else
		wake(f_dlg_spire_02_second_cores_start);		
	end
  
  sleep_until(S_SP02_CORES_DESTROYED >= 1, 1);
  
  if f_check_first_spire(DEF_SPIRE_02) then
  	dprint("old_phantom_blip");
  	//wake(f_sp02_phantom_blip);
		//wake(f_dlg_spire_02_first_cores_phantom_blip);	
	else
		wake(f_dlg_spire_02_second_cores_destroyed_1);
		thread(f_music_m70_v07_didact_voice_5());
	end
	
	sleep_s(1);
	
  wake(f_nar_spire_02_nudge_second_core);
   
  sleep_until(S_SP02_CORES_DESTROYED >= 2, 1);
 	if f_check_first_spire(DEF_SPIRE_02) then
		wake(f_dlg_spire_02_first_didact_scan);	
	end
   	
	sleep_until(S_SP02_CORES_DESTROYED >= 3, 1);
  if f_check_first_spire(DEF_SPIRE_02) == TRUE then
		wake(f_dlg_spire_02_first_cores_destroyed_3);	
		thread(f_music_m70_v07_didact_voice_2());
	else
		wake(f_dlg_spire_02_second_cores_destroyed_3);
		thread(f_music_m70_v07_didact_voice_6());
	end
	
	sleep_until(volume_test_players(tv_sp02_nar_intro), 1 );
	if f_check_first_spire(DEF_SPIRE_02) == TRUE then
		wake(f_dlg_spire_02_first_end);	
	end
	
end

script dormant f_nar_spire_02_nudge_second_core()
	dprint( "::: f_nar_spire_02_nudge_second_core :::" );
	if f_check_first_spire(DEF_SPIRE_02) then
		sleep_s(5);
		sleep_until((volume_test_players(tv_spire02_core_01) or volume_test_players(tv_spire02_core_02) or volume_test_players(tv_spire02_core_03)), 1 );
		if S_SP02_CORES_DESTROYED < 2 then
			wake(f_dlg_spire_02_first_nudge_second_core);	
		end
	end
end



// =================================================================================================
// =================================================================================================
// spire_03
// =================================================================================================
// =================================================================================================
// variables

script dormant f_nar_spire_3_intro()
	sleep_until(volume_test_players(tv_nar_spire_03_intro), 1 );
	
  //thread(f_m70_chapter_title(ch_spire_03));
  thread(f_chapter_title(ch_spire_03));
	sleep_until(volume_test_players(tv_nar_sp03_bottom_lift), 1 );
	
	thread(f_m70_objective_set(ct_obj_spire_03));
	sleep_s(3);
	
	wake(f_dlg_spire_03_didact_taunt_01);
	thread(f_music_m70_v07_didact_voice_7());
	
	sleep_until(volume_test_players(tv_sp03_bridge_fall_02) or volume_test_players(tv_sp03_bridge_fall_03), 1 );
	
	wake(f_dlg_spire_03_bottom_start);
	
	sleep_until(volume_test_players(tv_nar_sp03_get_to_the_top), 1 );
//xxx scan test
	//effect_new (environments\solo\m70_liftoff\fx\scan\dscan_spire3_1.effect, fx_didact_scan_spire3);
	sleep_s(1);
	wake(f_dlg_spire_03_didact_top_of_tower);
	
	sleep_until( volume_test_players(tv_nar_sp03_control_room), 1 );
	
	wake( f_dlg_spire_03_control_room_start );
end


//:: ICS SCRIPTS

script static void f_activator_get( object obj_control, unit activator )
	g_ics_player = activator;
	
	if ( obj_control == dc_terminal_domain ) then
		f_narrative_domain_terminal_interact( 4, cr_70_domain, dc_terminal_domain, activator, 'pup_domain_terminal' );
	end
	
end

script static void f_activator_cannot_take_damage()
	object_cannot_take_damage (g_ics_player);	
end

script static void f_activator_can_take_damage()
	object_can_take_damage (g_ics_player);	
end


//=============================
//Narrative Terminal
//=============================
//xxx once tom checks in

script dormant f_nar_m70_waypoint_terminal()
    f_narrative_domain_terminal_setup( 4, cr_70_domain, dc_terminal_domain );
end


/*
//xxxx using global function now
script dormant f_nar_m70_waypoint_terminal()
	
	sleep_until (object_valid (dc_terminal_domain), 1);
	device_set_power(dc_terminal_domain, 1.0);
	sleep_until(device_get_position(dc_terminal_domain) > 0.0, 1);
	device_set_power (dc_terminal_domain, 0.0);
	
	local long show_domain_terminal = pup_play_show("pup_m70_domain");
	
	sleep_until(not pup_is_playing(show_domain_terminal), 1);
	
	if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
		wake(f_dialog_global_my_first_domain); 
	end
	
	SetNarrativeFlagWithFanfareMessageForAllPlayers( 4, TRUE );
	
end

*/
	
//=============================
//Chapter Title
//=============================
script static void f_m70_chapter_title(cutscene_title chapter_title)
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox (TRUE);
	sleep_s (1.5);
	cinematic_set_title (chapter_title);
	hud_stop_global_animtion (screen_fade_out);
	sleep_s (3.5);     
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);
	cinematic_show_letterbox (FALSE);
end



//f_chapter_title();





// =================================================================================================
// =================================================================================================
// fx
// =================================================================================================
// =================================================================================================


script static void f_fx_interior_scan( cutscene_flag the_location )

	effect_new( environments\solo\m10_crash\fx\scan\didact_scan.effect, the_location );

end

script dormant m70_exit_through_maw()
	wake(f_dlg_flight_exit_through_maw);
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


//xxx
script static void m70_objective_1_nudge()
			dprint("Nudge fired");
			sleep_s(120);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m70_nudge_1());
			end
				if b_objective_1_complete == FALSE then
					thread( m70_objective_1_nudge());
			end
end
//xxx fix it
script static void m70_objective_2_nudge()
			dprint("Nudge fired");
			sleep_s(120);
			if b_objective_2_complete == FALSE then
						thread(f_dialog_m70_nudge_2());
			end
				if b_objective_2_complete == FALSE then
					thread( m70_objective_2_nudge());
			end
end

script static void m70_objective_3_nudge()
			dprint("Nudge fired");
			sleep_s(300);
			if b_objective_3_complete == FALSE then
						thread(f_dialog_m70_nudge_3());
			end
				if b_objective_3_complete == FALSE then
					thread( m70_objective_3_nudge());
			end
end


script static void m70_objective_4_nudge()
			dprint("Nudge fired");
			sleep_s(300);
			if b_objective_4_complete == FALSE then
						thread(f_dialog_m70_nudge_4());
			end
				if b_objective_4_complete == FALSE then
					thread( m70_objective_4_nudge());
			end
end


script static void m70_objective_lich_nudge()
			dprint("Nudge fired");
			sleep_s(60);
			if b_objective_lich_complete == FALSE then
						thread(f_dialog_m70_lich_nudge());
			end
				if b_objective_lich_complete == FALSE then
					thread( m70_objective_4_nudge());
			end
end


// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()
		wake(f_waypoint_global_equipment_unlock);
end






// -------------------------------------------------------------------------------------------------
// spire_03_INT_narrative: Dialog Triggers
// -------------------------------------------------------------------------------------------------
// === f_spire_03_INT_narrative_dlg_triggers_init::: Init

// === f_spire_03_INT_narrative_dlg_trigger_chief_01::: Dialog Trigger
//script dormant f_spire_03_INT_narrative_dlg_trigger_chief_01()
	//sleep_until( volume_test_players(tv_spire_3_chief_01), 1 );
	//wake( f_dlg_spire_03_chief_01 );
//end
