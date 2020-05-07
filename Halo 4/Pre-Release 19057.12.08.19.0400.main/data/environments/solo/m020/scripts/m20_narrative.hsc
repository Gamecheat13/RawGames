// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M20
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================

global boolean b_fired_weapon_in_opening = FALSE;
global boolean b_triggered_crater_explore_intro = FALSE;
//global boolean b_used_my_first_domain = FALSE;
global boolean b_explorable_terminal_1 = FALSE;
global boolean b_explorable_terminal_2 = FALSE;
global boolean b_explorable_terminal_3 = FALSE;
global boolean b_been_to_didact_terminal = FALSE;
global boolean b_been_to_librarian_terminal = FALSE;
global boolean b_used_map_terminal_once = FALSE;
global boolean b_button_check = 0;
global boolean b_code_check = FALSE;
global boolean b_ammo_retrieved = FALSE; 
global boolean b_sentinel_deployed = FALSE;
global boolean b_warthog_encountered = FALSE;
global boolean b_objective_1_complete = FALSE;
global boolean b_objective_2_complete = FALSE;
global boolean b_objective_3_complete = FALSE;
global boolean b_cathedral_clear = FALSE;
global long l_dlg_exploreable_terminal_03_pre = DEF_DIALOG_ID_NONE();
global long l_dlg_cathedral_Librarian_terminal = DEF_DIALOG_ID_NONE();


///////////////////////////////////////////////////////////////////////////////////
// PUPPETEER STUFF
///////////////////////////////////////////////////////////////////////////////////

global object pup_player0 = none;
global object pup_player1 = none;
global object pup_player2 = none;
global object pup_player3 = none;


script static void f_get_player( object trigger, unit activator )
	pup_player0 = activator;
end


///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M20_narrative_main()

	print ("::: M20 Narrative Start :::");

	
	thread (exploreable_terminal_02());
	thread (exploreable_terminal_03());
	thread (m20_crater_terminal_2_pre_use());
	thread (m20_crater_terminal_3_pre_use());
	thread (M20_warthog_callout());
	thread (m20_cathedral_reveal());
	thread (m20_graveyard_signal());
	thread (M20_crater_exit());
	thread (m20_didact_term_entrance());
	thread (m20_bridge_elevator());
	thread (m20_courtyard_covenant());
	wake (m20_Cathedral_cutscene_post_use);
	wake (m20_mantle_approach);
	//thread (m20_distress_signal_loop());
	thread (m20_mantle_approach_volume());
	wake (m20_fall_volume);
	thread(m20_halsey_cpu_terminal());
	thread (f_my_first_domain());
	thread (m20_graveyard_vo_a());
	thread (m20_last_stand());
	thread ( m20_courtyard_1stfl());
	wake(M20_warthog_without);
	
	wake(m20_active_cartographer_02);
	thread(m20_console_nudge());
	thread(f_waypoint_equipment_unlock());
	wake( m20_fields_covenant);
	wake(m20_active_camo_line);
	//thread(m20_crater_terminal_2_looping());
 wake(m20_distress_signal_reaction);
	
	
end

/*
script static void crater_phantom_controller()
//	sleep_s(10);
	//ai_place_in_vehicle(phantom_01, phantom_01);
	wake(f_dialog_m20_covenant_scouts);
//	sleep_s(60);
	//ai_place_in_vehicle(phantom_02, phantom_02);
//	sleep_s(60);
	//ai_place_in_vehicle(phantom_01, phantom_02);
//	sleep_s(60);


end*/



script dormant temp_cutscene_m20_crater()
	wake(f_dialog_m20_crater_landing);
	thread (M20_crater_vista());
	print ("FORCE SAVE");
  game_save_immediate();
  
  //PLAY CRASH SPARK EFFECT AFTER CINEMATIC ENDS
  effect_new( "environments\solo\m020\FX\sparks\spark_active_elec_xl.effect", "fx_hero_spark_01");
	effect_new( "environments\solo\m020\FX\sparks\spark_active_elec_xl.effect", "fx_hero_spark_02");

end


script dormant find_ship_objective()
   	//thread (story_blurb_add("domain", "OBJECTIVE: TRACK DOWN A COVENANT SHIP"));
   	
		thread (m20_objective_1_nudge());

end
script dormant m20_distress_signal_reaction()
    sleep_until( volume_test_players(m20_distress_signal_loop), 1);
	//	dprint ("Mayday signal firing.");
	thread(m20_distress_signal_loop());
	//sleep_s(2);
		//thread(f_dialog_m20_mayday_signal_reaction());

end

script static void m20_distress_signal_loop()
    //sleep_s(5);
    	if ( (objects_distance_to_object(player0, mayday_3d_object) < 4) == TRUE ) then
	//	dprint ("Mayday signal firing.");
			sound_impulse_start( 'sound\dialog\mission\m20\m20_distress_message_00100', mayday_3d_object, 1 );
				//thread(f_dialog_m20_mayday_signal());
			end
			sleep_s(30);
				 thread(m20_distress_signal_loop());
end

    	

/*script static void exploreable_terminal_01()
	//fires when you use explorable terminal 1
	sleep_until (object_valid (explore_button_01), 1);
	sleep_until (device_get_position(explore_button_01) > 0.0, 1 );
	device_set_power (explore_button_01, 0.0);
		
	dprint ("Fire Terminal 1 - Conv 1");

	device_set_power (explore_button_01, 1.0);
	device_set_position( explore_button_01, 0.0);
	thread (exploreable_terminal_01());
	dprint ("Terminal one reset");

end*/

script static void m20_crater_terminal_2_pre_use()
	//triggers as player approaches Terminal 2 History
	
    sleep_until( volume_test_players(m20_crater_terminal_2_pre_use), 1);
    		dprint("m20_crater_terminal_2_pre_use");
 				wake(f_dialog_m20_covenant_signal);

end  

script static void m20_crater_terminal_2_looping()
		//		dprint("f_dialog_m20_covenant_signal_loop START");
				if ( (objects_distance_to_object(player0, forerunner_terminal_2) < 4) == TRUE) then
 //   		dprint("f_dialog_m20_covenant_signal_loop");
 					//	cui_hud_show_radio_transmission_hud( "jul_transmission_name" );
 						sound_impulse_start( 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00111', fore_terminal_2_target, 1 );
 						//thread(f_dialog_m20_covenant_signal_loop());
 					//	sleep_s(3);
 					//	cui_hud_hide_radio_transmission_hud();
 				end
				sleep_s(8);
				thread(m20_crater_terminal_2_looping());
			//	dprint("f_dialog_m20_covenant_signal_loop RETHREADED");
end  


script static void exploreable_terminal_02()
	//fires when you use explorable terminal 2
	sleep_until (object_valid (explore_button_04), 1);
	sleep_until (device_get_position(explore_button_04) > 0.0, 1 );
	device_set_power (explore_button_04, 0.0);
	
	dprint ("Fire Terminal 2 - Conv 1");
	b_code_check = TRUE;
				wake(f_dialog_m20_exploreable_terminal_02);
				
	//device_set_power (explore_button_04, 1.0);
	//device_set_position( explore_button_04, 0.0);
	//thread (exploreable_terminal_04());
	dprint ("Terminal two reset");
	
end


script static void exploreable_terminal_03()
	//fires when you use explorable terminal 3
	
	sleep_until (object_valid (explore_button_07), 1);
	sleep_until (device_get_position(explore_button_07) > 0.0, 1 );
	device_set_power (explore_button_07, 0.0);
	
          thread(f_dialog_m20_exploreable_terminal_03_0a());

	//device_set_power (explore_button_07, 1.0);
	//device_set_position( explore_button_07, 0.0);
	//thread (exploreable_terminal_07());
	dprint ("Terminal three reset");

end
script static void m20_halsey_cpu_terminal()
	//fires when you use explorable terminal 3
	
	sleep_until (object_valid (halsey_cpu_terminal_button), 1);
	sleep_until (device_get_position(halsey_cpu_terminal_button) > 0.0, 1 );
	object_destroy(halsey_cpu_terminal_button);
	
          thread(f_dialog_m20_halsey_cpu_terminal_button_02());


end



script static void m20_crater_terminal_1_post_use()
	//triggers after terminal 1 UNSC - CENTER - is completed.
    sleep_until( volume_test_players(m20_crater_terminal_3_post_use) == 0, 1);
      sleep_until( player_action_test_cancel() == TRUE, 1);
      
      sleep_s (1.5);
    
    	wake(f_dialog_m20_crater_terminal_1_post_use);

end


script static void m20_crater_terminal_3_pre_use()
	//triggers as player approaches Terminal 3 Orders - LEFT SIDE FROM CRASH.

    sleep_until( volume_test_players(m20_crater_terminal_3_pre_use), 1);
    
			wake(f_dialog_m20_exploreable_terminal_03_pre);
end 


script static void m20_crater_terminal_3_post_use()
	//trigger volume around Terminal 3 Orders - LEFT SIDE - activates after the player uses terminal 3.
    sleep_until( volume_test_players(m20_crater_terminal_3_post_use), 1);
      
      sleep_s (1.5);
      wake(f_dialog_m20_crater_terminal_3_post_use);
   	
end


script static void m20_crater_exit()
    sleep_until( volume_test_players(m20_crater_exit), 1);
    b_triggered_crater_explore_intro == TRUE;
    	
    	wake(f_dialog_m20_first_infinity_signal);
    	
    	
		
end


script static void m20_crater_vista()
	//play chapter title for M20
	//sleep_until( volume_test_players(tv_vista_letterbox), 1);
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox( TRUE );
	sleep_s(1.5);
	cinematic_set_title( chapter_text_1 );
	hud_stop_global_animtion (screen_fade_out);
	f_music_m20_v01_floating_tower();
	sleep_s(3.5);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);		
	cinematic_show_letterbox( FALSE );

	// triggered when the player enters the vista.
	sleep_until( volume_test_players(m20_crater_vista), 1);
	//wake(f_dialog_m20_vista_exchange);
	
	// this music trigger should fire when the player first sees the floating tower vista!
	thread(f_music_m20_v01_floating_tower()); 
end	
			

script static void m20_burned_out_warthog()
		sleep_until( volume_test_players(burned_out_warthog), 1);
		if b_warthog_encountered == FALSE then
				wake(f_dialog_m20_burnedout_warthog);
				b_warthog_encountered = TRUE;
		end
end

script static void  M20_warthog_callout()
    
    sleep_until( volume_test_players(M20_warthog_callout), 1);
    	
				wake(f_dialog_m20_warthog_01);
				
    //fires as you enter a Warthog by the FUD
    
    sleep_until(vehicle_test_seat_unit_list(veh_vista_warthog_01, warthog_d, players() ) or vehicle_test_seat_unit_list(veh_vista_warthog_02, warthog_d, players() ) , 1);
				wake(f_dialog_m20_warthog_02);
		
    
    
    
end


script dormant M20_warthog_without()
		sleep_until( volume_test_players(test_in_warthog), 1);
		dprint("Hit warthog volume");
		//if not (vehicle_test_seat_unit_list(veh_vista_warthog_01, warthog_d, players())  or vehicle_test_seat_unit_list(veh_vista_warthog_02, warthog_d, players()))  then
		if not (unit_in_vehicle(player0) or unit_in_vehicle(player1) or unit_in_vehicle(player2) or unit_in_vehicle(player3)) then
				wake(f_dialog_m20_warthog_return);
				dprint("Fired Warthog VO");
    end
end

script static void m20_graveyard_vo_a()
	//triggered during the first part of the driving sequence if not in Warthog.
   
  sleep_until( volume_test_players (m20_graveyard_vo_a));
  sleep_s(2);
  wake(f_dialog_m20_graveyard_Rampancy_start);
  b_triggered_crater_explore_intro == TRUE;
  sleep_s(4);
  
end

script static void m20_blip_terminal()
		dprint("m20_blip_terminal threaded");
		sleep (30*4);
		wake(f_dialog_m20_blip_terminal);

end

script dormant m20_guardpostex_covenant_c()

     	wake(f_dialog_m20_guardpostex_covenant_c);

end

script dormant m20_fields_covenant()
     	sleep_until( volume_test_players( m20_cathedral_reveal), 1);
			wake(f_dialog_m20_callout_hostiles);

end


script static void m20_graveyard_signal()
     	sleep_until( volume_test_players(m20_graveyard_signal), 1);
			wake(f_dialog_m20_graveyard_signal);

end


script static void m20_cathedral_reveal()
	//triggered when the player sees the catherdral for the first time. Cov landing in courtyard.
     	sleep_until( volume_test_players(m20_cathedral_reveal), 1);
     	sleep_forever(m20_objective_1_nudge);
			//wake(f_dialog_m20_cathedral_reveal);
			dprint("dialog cathedral reveal");
					
end

script dormant m20_active_camo_line()
	
		
	sleep_until ( unit_has_equipment (player0, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_active_camo\storm_active_camo_m20.equipment")
	, 1);	

		wake(f_dialog_m20_camo_pickup);


end

script static void m20_active_camo_puppet()
	//CALLED FROM _MISSION. DISABLING FOR SCOPING REASONS
		dprint("Active Camo equipped");

		// set the puppeteer puppet as the activator
		pup_player0 = player0;
		
			pup_play_show( 'active_camo' );

end

     		
script static void m20_console_nudge()
	sleep_until( volume_test_players(tv_gpi_objcon_30), 1);
	wake(f_dialog_m20_console_nudge);
end

script dormant m20_cathedral_map_open()
	//triggers after enemies at the map terminal are killed.
	dprint ("m20 cathedral map open fired");
			

end


script static void m20_mantle_approach_volume()
	//triggers on button below map terminal in cathedral
     	sleep_until( volume_test_players(mantle_room_trigger), 1);	
			dprint("Mantle room reached");
			//thread (story_blurb_add("vo", "THE ROOM IS ADORNED WITH FORERUNNER RELIGIOUS ICONOGRAPHY."));
	
end


script dormant m20_mantle_approach()
	//triggers on button below map terminal in cathedral
	sleep_until (object_valid (mantle_approach_button), 1);	
	sleep_until (device_get_position(mantle_approach_button) > 0.0, 1 );
	device_set_power (mantle_approach_button, 0.0);
	dprint("Mantle triggered.");

	wake(f_dialog_m20_mantle_approach);
	
end

script dormant f_map_button_dialog()
//fires first time you use the map button (called from mission_guardpost script)
	dprint ("Map Terminal 1 - Conv 1");

	object_hide (crate_antenna_01, TRUE);
	
	b_used_map_terminal_once = TRUE;

	local long show=pup_play_show(pup_m20_25a);
	sleep_until(not pup_is_playing(show),1);
	show=pup_play_show(pup_m20_25b);
	
	//WAIT UNTIL M20.25 CINEMATIC IS OVER
	sleep_until(not pup_is_playing(show),1);
	game_save_immediate();
	
	sound_impulse_start ( 'sound\environments\solo\m020\amb_m20_machines\machine_m20_shutdown', cathedral_terminal_spinner, 1 ); //AUDIO!
	
	wake(f_dialog_m20_map_button_03);
	object_hide (crate_antenna_01, FALSE);
	
	//SET OBJECTIVES
	sleep (30*3);
	
	wake (f_gpi_hex_cover_fall);
	wake(f_map_complete);
	
	sleep (30*2);
	
	cui_hud_set_new_objective (objective_4);
	   
end


script dormant f_map_complete()
	dprint ("waiting for blip");
		b_objective_1_complete = TRUE;
		objectives_finish (0);
   	//thread (story_blurb_add("domain", "OBJECTIVE: RESTORE POWER TO THE CARTOGRAPHER"));
   	sleep_forever(m20_objective_1_nudge);
		//thread(m20_objective_2_nudge()); //Moving to dialogue, after cortana talks/blips
    //device_set_power (map_button_01, 0.0);
	  //device_set_position( map_button_01, 0.0);

	  //disabling the second button press option, threading dialog now
	  thread(m20_blip_terminal());
	  
	  //wake(f_map_button_dialog_post);
	//  wake(m20_librarian_term_entrance);
	  	  
	  
	//SCRIPT PLAYER LOD HERE

	  
end

script dormant f_map_button_dialog_post()
  sleep_until (object_valid (map_button_01), 1);	
	sleep_until (device_get_position(map_button_01) > 0.0, 1 );
	device_set_power (map_button_01, 0.0);
	wake(f_dialog_m20_map_button_post);
	dprint ("Map Terminal 1 - Post");

end




//triggers the map terminal CUTSCENE
script dormant f_m20_cathedral_map()
	sleep_until( device_get_position( map_button_01 ) > 0.0, 1 );
	device_set_power( map_button_01, 0.0);
  player_action_test_reset();
  kill_script(f_Cathedral_Didact_terminal_post_use);

	local long insert_show = pup_play_show(pup_luminary_exit_press);
	sleep_until(not pup_is_playing(insert_show));
		
	dprint ("playing 20.5 cinematic");

  if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then

		cinematic_enter ("cin_m0205_cathedral", TRUE);
		
		switch_zone_set ("cin_m205_cathedral_zs");
		sleep ( 1 );
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
		sleep ( 1 );

		cinematic_suppress_bsp_object_creation(TRUE);

		f_start_mission ("cin_m0205_cathedral");

		cinematic_suppress_bsp_object_creation(FALSE);

		wake (f_gp_int_teleport_player);	

		cinematic_exit ("cin_m0205_cathedral", TRUE); 

		print ("cinematic exited!"); 

	end 

end


script static void m20_didact_term_entrance()
//IF Chief approaches FIRST CORE
	sleep_until( (volume_test_players(m20_didact_term_entrance) or volume_test_players(m20_wake_lib_sentinels)), 1);
			if (b_player_activated_core_right == TRUE) or (b_player_activated_core_left == TRUE) then
				wake(f_dialog_m20_Cathedral_didact_terminal_pre_use);

			end

end

/*script dormant m20_librarian_term_entrance()
//If Chief approaches Librarian terminal
	sleep_until( (volume_test_players(m20_didact_term_entrance) or volume_test_players(m20_wake_lib_sentinels)), 1);
			if (b_player_activated_core_right == FALSE) and (b_player_activated_core_left == FALSE) then
				wake(f_dialog_m20_librarian_pre);
			end

end*/




script dormant f_Cathedral_Librarian_terminal()
//Triggered the FIRST terminal in the cathedral.
	dprint("First terminal dialogue fired");
		wake(f_dialog_m20_Cathedral_Librarian_terminal_01);
		sleep_s(1);
		wake(f_dialog_m20_Cathedral_Librarian_terminal);
		
		b_been_to_Librarian_terminal = TRUE;

end


script dormant f_Cathedral_Didact_terminal()
	//Triggered the the SECOND terminal in the cathedral.
		dprint("second terminal dialogue");

		thread(f_dialog_m20_Cathedral_didact_terminal_02());
		
		wake(f_dialog_m20_Cathedral_didact_terminal);
		
		b_been_to_didact_terminal = TRUE;
    //thread(f_Cathedral_Didact_terminal_post_use());
end



script static void f_Cathedral_Didact_terminal_post_use()
  sleep_s(90);
	wake(f_dialog_m20_Cathedral_didact_terminal_post_use);

end

script dormant m20_active_cartographer()
	
    sleep_until( volume_test_players(tv_front_pad), 1);
    
    	if b_cathedral_clear == FALSE then 
					wake(f_dialog_m20_cartographer_finish_covenant);
			end
		
end

script dormant m20_active_cartographer_02()
		dprint("ACTIVE CARTOGRAPHER WOKEN");
		sleep_until (b_cathedral_clear == TRUE);
  	dprint("ACTIVE CARTOGRAPHER TRIGGERED");
    
					wake(f_dialog_m20_cartographer_cutscene_pre_use);

		
end

script dormant m20_didact_title()
	//triggered on Infinity contact
    		//hud_play_global_animtion (screen_fade_out);
    		kill_script(m20_objective_2_nudge);
    		sleep_forever(m20_objective_2_nudge);
    		b_objective_2_complete = TRUE;
    		objectives_finish (1); 
/*    cinematic_show_letterbox( TRUE );
    cinematic_set_title( chapter_text_2 );
	hud_stop_global_animtion (screen_fade_out);
	sleep (30 * 9);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);		
	cinematic_show_letterbox( FALSE );*/
end

script dormant m20_Cathedral_cutscene_post_use()
	//triggers after M20 cathedral cutscene is completed, by volume for now.
    sleep_until( volume_test_players(m20_Cathedral_cutscene_post_use), 1);
    wake(f_dialog_m20_Cathedral_cutscene_post_use);
			//	thread (story_blurb_add(Ftitle"domain", "OBJECTIVE: FIGHT YOUR WAY TO THE TERMINUS"));
			thread(m20_objective_3_nudge());
    sleep_s(1);
    
    hud_play_global_animtion (screen_fade_out);
    cinematic_show_letterbox( TRUE );
    sleep_s(1.5);    
		cinematic_set_title( chapter_text_2 );
		hud_stop_global_animtion (screen_fade_out);
    sleep_s(3.5);
		hud_play_global_animtion (screen_fade_in);
		hud_stop_global_animtion (screen_fade_in);		
		cinematic_show_letterbox( FALSE );
		
end


script static void m20_bridge_elevator()
   sleep_until( volume_test_players(tv_vo_scouts), 1);
     	wake(f_dialog_m20_bridge_elevator);
			thread(m20_objective_3_nudge());
end


script static void m20_bridge_sentinel_death()
		dprint("d");
     	//wake(f_dialog_M20_bridge_post);
     	//kill_script(f_dialog_M20_bridge_end);

end


script dormant m20_fall_volume()
     	sleep_until( (volume_test_players(fall_volume_1)) or (volume_test_players(fall_volume_2)), 1);
     			wake(f_dialog_m20_fall_volume);
				
end

//script dormant m20_banshees()
//	
//     	sleep_until( volume_test_players(m20_banshees), 1);
//     			wake(/*f_dialog_m20_phantom_on_approach_02*/);
//
//end


script static void M20_bridge_end()
	// CMS TRYING NEW BRIDGE_END
	sleep_until( volume_test_players(m20_bridge_end), 1);                          

end


script static void m20_courtyard_covenant()
     	sleep_until( volume_test_players(m20_hallway_trigger), 1);
					wake(f_dialog_m20_courtyard_covenant);
         
end

script static void m20_courtyard_entrance()
	hud_play_global_animtion (screen_fade_out);
	cinematic_show_letterbox( TRUE );
	sleep_s(1.5);
	cinematic_set_title( chapter_text_3 );	
	hud_stop_global_animtion (screen_fade_out);
  sleep_s(3.5);
	hud_play_global_animtion (screen_fade_in);
	hud_stop_global_animtion (screen_fade_in);		
	cinematic_show_letterbox( FALSE );
	
	cui_hud_set_new_objective (objective_6);
	objectives_show_up_to (3);
	objectives_finish (2);
	
end


script static void m20_courtyard_1stfl()
     	sleep_until( volume_test_players(m20_courtyard_1stfl), 1);
			wake(f_dialog_m20_courtyard_1stfl);

end

script static void m20_last_stand()

	sleep_until( volume_test_players(m20_last_stand), 1);
	//wake(f_dialog_m20_last_stand);
    	
	sleep_s(3);
	
	//object_hide( temp_cutscene_M21_tower, TRUE );
	wake(f_dialog_m20_door_approach);
	sleep_s(2);
	//wake(m20_hunters_dead);

end


script dormant m20_hunters_dead()
	//thread (story_blurb_add("domain", "CHIEF FIGHTS SOME HUNTERS. RAWR."));
	dprint("d");	
end

script dormant m20_atrium_ent()
  
	wake(f_dialog_m20_atrium_ent);

end		  
		  
script static void f_my_first_domain()
	f_narrative_domain_terminal_setup( 0, domain_terminal, domain_terminal_button );
	/*
	//fires first time you use the map button
	sleep_until (object_valid (myfirstdomain_button), 1);
	sleep_until (device_get_position(myfirstdomain_button) > 0.0, 1 );
	device_set_power (myfirstdomain_button, 0.0);
	pup_play_show ("pup_m20_domain");
		if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
			wake(f_dialog_global_my_first_domain); 
		end
		SetNarrativeFlagWithFanfareMessageForAllPlayers( 0, TRUE );
		object_destroy(myfirstdomain_button);
	*/
end

script static void m20_atrium_waypoint()
	 sleep_until( volume_test_players(m20_atrium_ent), 1);
	wake(m20_atrium_waypoint_kill);
	sleep_s(30);
	wake(f_dialog_m20_atrium_waypoint);
end

script dormant m20_atrium_waypoint_kill()
  sleep_until( volume_test_players(m20_atrium_waypoint_kill), 1);
	kill_script(m20_atrium_waypoint);
	sleep_forever(m20_atrium_waypoint);
	dprint("m20_atrium_waypoint killed");

end


//BEGIN ENDING CINEMATIC / CUTSCENE
script dormant cutscene_m21_tower()

	dprint( "Cinematic entered!" );
	
	b_objective_3_complete = TRUE;
	
  player_action_test_reset();
	
if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then

	cinematic_enter ("cin_m021_tower", TRUE);
	
	switch_zone_set ("cin_m21_tower_zs");
	sleep ( 1 );
	sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	sleep ( 1 );

	cinematic_suppress_bsp_object_creation(TRUE);

	f_start_mission ("cin_m021_tower");

	cinematic_suppress_bsp_object_creation(FALSE);

	cinematic_exit_no_fade ("cin_m021_tower", TRUE); 

	print ("Cinematic exited!"); 

end 

	//END LEVEL!
	game_won();

end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script static void m20_objective_1_nudge()
			print("m20_objective_1_nudge threaded");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
					thread(f_dialog_m20_objective_1());
			end
				if b_objective_1_complete == FALSE then
					thread(m20_objective_1_nudge());
			end
end

script static void m20_objective_2_nudge()
			print("m20_objective_2_nudge threaded");
			sleep_s(900);
			if b_objective_2_complete == FALSE then
						thread(f_dialog_m20_objective_2());
			end
			if b_objective_2_complete == FALSE then
						thread(m20_objective_2_nudge());
			end
end

script static void m20_objective_3_nudge()
			print("m20_objective_3_nudge threaded");
			sleep_s(900);
			if b_objective_3_complete == FALSE then
						thread(f_dialog_m20_objective_3());
			end
			if b_objective_1_complete == FALSE then
					thread(m20_objective_3_nudge());
			end
end



global boolean b_phantom_1_took_damage = FALSE;
global boolean b_phantom_2_took_damage = FALSE;
global boolean b_phantom_3_took_damage = FALSE;

global boolean b_phantom_1_active = FALSE;
global boolean b_phantom_2_active = FALSE;
global boolean b_phantom_3_active = FALSE;


//=========================================================
//CRATER AMBIENT PHANTOMS FLY
//=========================================================
script command_script crater_phantom_fly_0()
                dprint ("SPAWNED PHANTOM 01");

                cs_ignore_obstacles (TRUE);
                object_set_variant (ai_vehicle_get( ai_current_actor ), ("chin_gun_light") );
                cs_vehicle_speed (0.5);
                
                cs_fly_by (phantom_puppet.p0);
                cs_fly_by (phantom_puppet.p1);
                cs_fly_by (phantom_puppet.p2);
                cs_fly_by (phantom_puppet.p3);
                cs_fly_by (phantom_puppet.p4);
                cs_fly_by (phantom_puppet.p5);
                cs_fly_by (phantom_puppet.p6);
                
                b_phantom_1_active = FALSE;
                ai_erase(phantom_01);
                
end

script command_script crater_phantom_fly_1()
                dprint ("SPAWNED PHANTOM 02");

                cs_ignore_obstacles (TRUE);
                object_set_variant (ai_vehicle_get( ai_current_actor ), ("chin_gun_light") );
                cs_vehicle_speed (0.5);
                
                cs_fly_by (phantom_puppet_2.p0);
                cs_fly_by (phantom_puppet_2.p1);
                cs_fly_by (phantom_puppet_2.p2);
                cs_fly_by (phantom_puppet_2.p3);
                cs_fly_by (phantom_puppet_2.p4);
                cs_fly_by (phantom_puppet_2.p5);
                cs_fly_by (phantom_puppet_2.p6);

                b_phantom_2_active = FALSE;
                ai_erase(phantom_02);
                
end

script command_script crater_phantom_fly_2()
                dprint ("SPAWNED PHANTOM 03");

                cs_ignore_obstacles (TRUE);
                object_set_variant (ai_vehicle_get( ai_current_actor ), ("chin_gun_light") );
                cs_vehicle_speed (0.5);
                
                cs_fly_by (phantom_puppet_3.p0);
                cs_fly_by (phantom_puppet_3.p2);
                cs_fly_by (phantom_puppet_3.p3);
                cs_fly_by (phantom_puppet_3.p4);
                cs_fly_by (phantom_puppet_3.p5);
                cs_fly_by (phantom_puppet_3.p6);

                b_phantom_3_active = FALSE;
                ai_erase(phantom_03);
                
end

//=========================================================
//CHECK IF PHANTOMS HAVE BEEN SHOT
//=========================================================
script dormant crater_phantom_check_01()
                dprint ("waiting for damage on phantom 01");
                sleep_until (unit_get_health (ai_vehicle_get_from_spawn_point (phantom_01.spawn_points_0)) < 1 and b_phantom_1_active, 1);
                
                b_phantom_1_took_damage = TRUE;
                
                dprint ("PHANTOM 01 SEES PLAYER");
                ai_set_deaf (phantom_01, 0);
                ai_set_blind (phantom_01, 0);
                
end

script dormant crater_phantom_check_02()
                dprint ("waiting for damage on phantom 02");
                sleep_until (unit_get_health (ai_vehicle_get_from_spawn_point (phantom_02.spawn_points_0)) < 1 and b_phantom_2_active, 1);
                b_phantom_2_took_damage = TRUE;

                dprint ("PHANTOM 02 SEES PLAYER");
                ai_set_deaf (phantom_01, 0);
                ai_set_blind (phantom_01, 0);
                
end

script dormant crater_phantom_check_03()
                dprint ("waiting for damage on phantom 03");
                sleep_until (unit_get_health (ai_vehicle_get_from_spawn_point (phantom_03.spawn_points_0)) < 1 and b_phantom_3_active, 1);
                b_phantom_3_took_damage = TRUE;
                
                dprint ("PHANTOM 03 SEES PLAYER");
                ai_set_deaf (phantom_02, 0);
                ai_set_blind (phantom_02, 0);

end

//=========================================================
//SPAWN DROP SHIP
//=========================================================
script dormant spawn_phantom_on_damage()
                sleep_until (b_phantom_1_took_damage or b_phantom_2_took_damage or b_phantom_3_took_damage, 1);
                
                sleep (30*5);

                ai_place (crater_phantom_01);
                
                sleep_forever (spawn_crater_phantom);

end


// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()

		wake(f_waypoint_global_equipment_unlock);
end