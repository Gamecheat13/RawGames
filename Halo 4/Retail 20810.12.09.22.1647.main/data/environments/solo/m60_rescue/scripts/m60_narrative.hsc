
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M60
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***

 		global boolean b_objective_1_complete = FALSE;
		global boolean b_objective_2_complete = FALSE;
		global boolean b_objective_3_complete = FALSE;
		global boolean b_objective_4_complete = FALSE;
		global boolean b_objective_5_complete = FALSE;
		global boolean b_objective_6_complete = FALSE;
		global boolean b_xray_pickedup = FALSE;
		global long l_dlg_inifinityberth_mechdata = DEF_DIALOG_ID_NONE();
		global boolean b_mantis_engaged = FALSE;

// =================================================================================================

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M60_narrative_main()
	
	if (game_insertion_point_get() < 22) then
	
	print ("::: M60 Narrative Start :::");

//	thread (m60_1st_fof_ping());
	thread (peak_vo_theview());
	thread (peak_vo_trail_transmission());
	
	wake (audio_vignette_ambush_01);
	//wake (audio_vignette_delrio_explosion);
	wake (crumb_dogtag_scan_01);
	wake (m60_3rd_fof_ping);
	wake (m60_last_fof_ping);
	
	wake (crumb_dogtag_scan_last);
	//wake (boulders_marines_yabro_01);
	wake (boulders_marines_uphigh_01);
	wake (trail_boulders_vo_assistmarines); 
	//wake (lasky_clear_berth);
	wake (boulders_marines_holedup);
	wake (m60_crumb_dogtag_scan2);
	thread (m60_infinity_run_02());
	thread (m60_infinity_run_01());
	thread (m60_trails1_sniper());
  wake(m60_try_to_leave_mechbay);
  wake(m60_infinityberth_enter_mantis);
  wake(m60_rampancy_hall);
  wake(m60_last_fof_proximity);
  thread(m60_hallway_exit());
  wake(covenant_forerun_coop);
  wake(infinityouterdeck_start_alt);
	wake(rally_chief_onme);
	//wake(boulders_tango_uphigh_01);
	wake(m60_xray_post);
/*	wake(swamp_marine_chatter_01);
	wake(swamp_marine_chatter_02);
	wake(swamp_marine_chatter_03);
	wake(swamp_marine_chatter_04);
	wake(swamp_marine_chatter_05);*/
	   thread(m60_infinity_secondary_01());
     thread(m60_infinity_secondary_02());
     thread(m60_infinity_secondary_03());
     thread(m60_infinity_secondary_04());
     thread(m60_infinity_secondary_05());
     thread(m60_infinity_secondary_06());
     thread(m60_infinity_secondary_07());
     wake(infinity_ship_pa_01);
			wake(infinity_ship_pa_02);
			wake(infinity_ship_pa_04);
			wake(infinity_ship_pa_05);
			wake(infinity_ship_pa_06);
			wake(infinity_ship_pa_07);
			wake(m60_waypoint_terminal);
			wake(m60_trails_knight_vignette_pre);
			thread( m60_berth_exit_grunts(inf_cause_gr_kami.spawn_points_0) );
			thread( m60_berth_exit_grunts_02(inf_cause_gr_kami.spawn_points_1) );
	end

end

//3434343434343434343434343434343434343434343434343434343434343434343434343434

////////////////////////////////////NARRATIVE SCRIPTS////////////////////////////

//3434343434343434343434343434343434343434343434343434343434343434343434343434


script static void m60_1st_fof_ping()
	dprint ("doing stuff");
	// some rampancy, then the first IFF waypoint
	//sleep_until (object_valid (crumb_dogtag_01), 1);		
	//objects_attach (crumb_tag_marine_01, "head", crumb_dogtag_01, "");
	
  sleep_until( volume_test_players(m60_1st_fof_ping), 1);
 
		wake(f_dialog_m60_1st_fof_ping);
	
  
    
end

/*script dormant m60_test_vo_wait()
	
		sleep_until(dialog_id_played_check(L_dlg_1st_fof_ping), 1);
 thread (story_blurb_add("other", "SUCCESS!."));
	dprint("SUCCESS!");

end*/

script static void peak_vo_theview()
	//when the player moves to the edge of the cliff Cortana makes a comment about the Didact scanning the INFINITY.
  
  sleep_until( volume_test_players(m60peak_001_vo_theview), 1);
     

		wake(f_dialog_m60_the_view);

end


script static void peak_vo_trail_transmission()
	//triggers when the player walk through the trail at the start of the level.
	
  sleep_until (volume_test_players(peak_vo_trail_transmission), 1);
dprint("VO TRAIL TRANSMISSION");	
	//wake(f_dialog_m60_vo_trail_transmission);
	sleep_s(2);
	wake(f_dialog_m60_vo_trail_transmission_02);
	thread(m60_objective_1_nudge());
		                   
end


script dormant audio_vignette_ambush_01()
	//triggers when nearing early ambush site
	
	sleep_until (volume_test_players(audio_vignette_ambush_01), 1);
	
	// this activates first set of dog tag scripts
	device_set_power (crumb_dogtag_01, 1.0);
	//device_set_power (extra_dogtag_01, 1.0);
	
	
	//thread (story_blurb_add("cutscene", "SOUNDS of an ambush."));
	sleep_s (1.0);
	
	//thread (story_blurb_add("other", "Knight SCREAMS!"));
	sleep_s (2.0);
	
		//thread(f_dialog_m60_vignette_ambush_01());
		
			
	//thread (story_blurb_add("cutscene", "SOUNDS of Marine gunfire giving way to Knight gunfire."));
	wake(Peak_Prometheans_appear_cortana);
	
	
	
end


script dormant Peak_Prometheans_appear_cortana()
	//fires when the prometheans disappear at the end of peak.
  
//  thread (story_blurb_add("other", "(RADIO) DEL RIO: Keep an eye out for hostiles.  We may not be alone here."));
//  sleep_s (5.1);
		sleep_until (volume_test_players (Peak_Prometheans_appear_cortana), 1);
		
		
  
end

script dormant Peak_Prometheans_appear()
   dprint("d");
end


script dormant crumb_dogtag_scan_01()
	//fires when you scan either of first bread crumb dog tags
	sleep_until (object_valid (crumb_dogtag_01), 1);	
	sleep_until (device_get_position(crumb_dogtag_01) > 0.0, 1 );
	
	
	device_set_power (crumb_dogtag_01, 0.0);
	
	wake(m60_peak_after_iff);
	
	f_unblip_object (crumb_dogtag_01);
			thread(f_dialog_m60_vignette_ambush_04());

end

script dormant m60_peak_after_iff()
	sleep_until ((volume_test_players (peak_after_iff) or volume_test_players(peak_prometheans_appear_cortana)), 1);
	
	dprint ("no longer playin' dat pip, son! fixing dem bugs, stoppin' dem pips... it's how we roll halo 4");		
	//hud_play_pip_from_tag( "" );
	
end

/*script dormant dt1_unblip
	sleep_until (volume_test_players (tv_dt1_unblip), 1);
	f_unblip_object (crumb_dogtag_01);
end
*/
script static void m60_trails1_sniper()

	sleep_until (volume_test_players(swamp_marine_chatter_01), 1);
	f_unblip_object (crumb_dogtag_01);
		//wake(f_dialog_m60_sniper_backscatter);
			
			

end

script dormant m60_3rd_fof_ping()
	//fires to activate 3rd marine fof ping
	sleep_until (volume_test_players(m60_3rd_fof_ping), 1);
	
	f_unblip_flag (crumb_locflag_02);
	
		wake(f_dialog_m60_trails_iffcallout);

	
	

end



script dormant m60_trails_knight_vignette_pre()
sleep_until (volume_test_players(knight_vignette_pre), 1);
	wake(f_dialog_m60_trails_knight_vignette);
end

script dormant m60_xray_intro()
	//fired after X-ray scene Knight is killed
	
	
	//f_unblip_flag (crumb_locflag_03);
	
  //thread (story_blurb_add("cutscene", "MARINE/KNIGHT VIGNETTE - KNIGHT DROPS AA"));

   if not (unit_has_equipment (player0, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision.equipment")) then

		wake(f_dialog_m60_xray_intro);
		
	end		
end

script dormant m60_xray_post()	
//	sleep_until (object_valid (x_ray_placeholder), 1);	

//	sleep_until ((device_get_position(x_ray_placeholder) > 0.0), 1);
	
	//device_set_power (x_ray_placeholder, 0.0);
	sleep_until (volume_test_players(m60_xray_intro), 1);
		sleep_until ( 
		unit_has_equipment (player0, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player1, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player2, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
		or unit_has_equipment (player3, "objects\equipment\storm_forerunner_vision\storm_forerunner_vision_pve.equipment")
	, 1);		
				//Hud_play_pip("TEMP_PIP");
				wake(f_dialog_m60_xray_intro_2);
				b_xray_pickedup = TRUE;
			//Hud_play_pip("");
			if IsNarrativeFlagSetOnAnyPlayer(49) == FALSE then
					SetNarrativeFlagOnLocalPlayers( 49, TRUE );
					dprint("Forerunner Vision acquired");
					
			end
end	


script dormant m60_crumb_dogtag_scan2()

	sleep_until (object_valid (crumb_dogtag_02), 1);	
	sleep_until (device_get_position(crumb_dogtag_02) > 0.0, 1 );

	device_set_power (crumb_dogtag_02, 0.0);
	
	f_unblip_flag (crumb_locflag_iff_02);
		wake(f_dialog_m60_crumb_dogtag_scan2);
		
end



script dormant audio_vignette_delrio_explosion()
	//triggers after X-ray drop, hear explosion over radio, then in real time
	
	sleep_until (volume_test_players(audio_vignette_delrio_explosion), 1);

		wake(f_dialog_audio_vignette_pre_explosion);

end


script dormant m60_last_fof_ping()
	//fires to activate last marine fof ping
	sleep_until (volume_test_players(m60_last_fof_ping), 1);
	
	f_unblip_flag (crumb_locflag_last); 
	wake(f_dialog_m60_last_fof_ping);
	
	

	
end


script dormant last_fof_callout()
	//Cortana calls out the last dog tag
	sleep_until (volume_test_players(last_fof_callout), 1);
		wake(f_dialog_m60_last_fof_ping);
		thread(m60_lost_player_loop());
end

script static void m60_lost_player_loop()
	sleep_s(300);
	thread(m60_lost_player_fof_callout_01());
end


script static void m60_lost_player_fof_callout_01()
	//Call out for lost player
	
		wake(f_dialog_m60_last_fof_ping_2);
		sleep_s(300);
		thread(m60_lost_player_fof_callout_02());
end

script static void m60_lost_player_fof_callout_02()
	//Call out for lost player

		wake(f_dialog_m60_last_fof_ping_3);
		sleep_s(300);
		thread(m60_lost_player_fof_callout_01());
end

script dormant m60_last_fof_proximity()
	//In proximity of last fof
	sleep_until (volume_test_players(m60_last_fof_proximity), 1);
	
		wake(f_dialog_m60_last_fof_callout);
		kill_script(m60_lost_player_loop);
		kill_script(m60_lost_player_fof_callout_01);
		kill_script(m60_lost_player_fof_callout_02);
end

global zone_set cinZS = "trail_c_to_cinematic";
script dormant crumb_dogtag_scan_last()
	//fires when you scan last bread crumb dog tag
	sleep_until (object_valid (crumb_dogtag_last), 1);
	sleep_until (device_get_position(crumb_dogtag_last) > 0.0, 1 );
	device_set_power (crumb_dogtag_last, 0.0);
	
	prepare_to_switch_to_zone_set(cinZS);
	
	f_unblip_flag (crumb_locflag_last);
	
//	thread (story_blurb_add("other", "PIP: SSgt. Sullivan, Brendan K.  - 2557-07-22 12:42:11."));
	
		wake(f_dialog_m60_dogtag_scan_last);
	
	
end

script dormant m60_last_fof_reveal()
	 wake(f_dialog_m60_last_fof_reveal);
	//group of IFF blips appear in front of Chief
	f_blip_object (sq_vig_s4.s5, "recon");
	sleep_s (0.75);
	f_blip_object (sq_vig_s4.s1, "recon");
	sleep_s (0.5);
	f_blip_object (sq_vig_s4.s2, "recon");
	sleep_s (0.25);
	f_blip_object (sq_vig_s4.s3, "recon");
	sleep_s (0.1);
	f_blip_object (sq_vig_s4.s4, "recon");
	
	sleep_s (2.0);
	player_action_test_reset();

	// M62_introductions Cutscene

	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
		
		cinematic_enter ("cin_m062_introductions", TRUE);
		
		switch_zone_set (cin_m62_bunker);
		sleep ( 1 );
		sleep_until (current_zone_set_fully_active() == zs_cin_m062, 1);
		sleep ( 1 );

		cinematic_suppress_bsp_object_creation(TRUE);

		f_load_cin_m62_trail();
		f_start_mission ("cin_m062_introductions");
		
		cinematic_suppress_bsp_object_creation(FALSE);
		
		cinematic_exit_no_fade(cin_m062_introductions, TRUE); 
		kill_script(m60_objective_1_nudge);
		b_objective_1_complete = TRUE;
		
		print ("Cinematic exited!"); 
		
	end
  
  wake (f_laskytemp);
	
	f_unblip_flag (lasky_ping_01);
	f_unblip_flag (lasky_ping_02);
	f_unblip_flag (lasky_ping_03);
	f_unblip_flag (lasky_ping_04);
	f_unblip_flag (lasky_ping_05);
	wake(m60_landing_marine_vo);

end

script dormant m60_landing_marine_vo()
		sleep_until (volume_test_players(landing_marine_vo), 1);
		//thread(f_dialog_m60_bunker_exit_marines());
		
	//	thread(f_dialog_m60_marines_bunker_01());
		//thread(f_dialog_m60_marines_bunker_02());
		
		
end


script static void m60_hallway_exit()
		sleep_until (volume_test_players(landing_marine_vo), 1);
		//thread(f_dialog_m60_bunker_exit_marines());
		wake(f_dialog_m60_spartan_armor_comment);
	//	thread(f_dialog_m60_marines_bunker_01());
		
		thread(m60_objective_2_nudge());
		
end

script dormant boulders_marines_yabro_01()
	//would be good idea to script this so it can be fired by any close, living marine
	sleep_until (volume_test_players(boulders_marines_yabro_01), 1);
	
/*	thread (story_blurb_add("domain", "MARINE #1: Wow. I didn't think I believed in ghosts..."));
	sleep_s (5.1);
	
	thread (story_blurb_add("vo", "MARINE #2: Yeah, well, if this means I'm dead, my wife is gonna kill me."));	*/
	
	//worried that we won't have room for following line
	//thread (story_blurb_add("domain", "CORTANA: Chief, its hard to get a reading under this canopy, but I think there's a clearing big enough for a dropship due east of here."));	

end


script dormant boulders_marines_yabro_02()
	//fires when first boulders squad is dead
	//would be good idea to script this so it can be fired by any close, living marine
	
	dprint("d");
	
end


script dormant boulders_marines_uphigh_01()
	//fires as you turn corner after ramps near start of boulders
	sleep_until (volume_test_players(m60_preboulders_radio), 1);
//	object_hide( cortana_temp_plinth, TRUE );
		wake(f_dialog_m60_preboulders_radio);
			
end

script dormant boulders_tango_uphigh_01()
	//fires as you see knight on the rock
	sleep_until (volume_test_players(boulders_marines_uphigh_01), 1);
			
			wake(f_dialog_m60_boulders_uphigh);

end

script dormant trail_boulders_vo_assistmarines()
	//fires as you come upon Marines on the hill
  sleep_until( volume_test_players(m60trail_boulders_016_vo_assistmarines), 1);
      wake(f_dialog_m60_boulders_assistmarines);

end

script dormant boulders_marines_holedup()

	sleep_until( volume_test_players(boulders_marines_holedup), 1);

	thread(f_dialog_m60_boulders_marines_holedup());
	thread(f_dialog_m60_boulders_marines_holedup2());
	//sleep_s(2);
	//thread(f_dialog_m60_boulders_marines_holedup_cortana());

end




script dormant cortana_plinth_callout()
	//fires when last wave guarding hill is dead
     
  kill_script(m60_objective_2_nudge);
  sleep_forever(m60_objective_2_nudge);
  b_objective_1_complete = TRUE;
  
	wake(f_dialog_m60_plinth_callout);
		

end



script static void m60_objective_3_nudge()
		sleep_until( volume_test_players(cortana_emplacements), 1);
			if b_objective_3_complete == FALSE then
						thread(f_dialog_m60_nudge_3());
			end
			sleep_s(15);
				if b_objective_3_complete == FALSE then
					thread( m60_objective_3_nudge());
			end
end


script static void cortana_plinth_callout_2()
	//If player delays
    sleep_s(90);
	 wake(f_dialog_m60_plinth_callout_02);
		
         
end

script dormant cortana_plinth_appear()

	sleep_until (device_get_position (lightbridge_active) != 0);
	sleep_s(5);
		wake(f_dialog_m60_plinth_progress);
//		object_create(cortana_temp_plinth);
	  dprint("plinth appear fire");
//		object_hide( cortana_temp_plinth, FALSE );
	
//		object_hide( cortana_temp_plinth, TRUE );

end

script dormant cortana_plinth_rampant_01()
	//fires after 1st of 4 enemy waves is dead
		dprint("D");	
	//	wake(f_dialog_m60_plinth_ambush);
end

script dormant cortana_plinth_rampant_01a()		
	//fires after first wave
			
		dprint("d");
end


script dormant cortana_plinth_rampant_02()
	//fires after 2nd of 4 enemy waves is dead
		//sleep_s(3);
		//wake(f_dialog_m60_plinth_progress_02);
		dprint("d");
  
end
	

script dormant cortana_plinth_rampant_03()
	//fires after 3rd of 4 enemy waves is dead
	
	wake(f_dialog_m60_plinth_progress_03);
	
end


script dormant boulders_plinth_finished()
	//fires when Cortana has finished with the plinth
	     

		wake(f_dialog_m60_plinth_complete);
	kill_script(m60_objective_3_nudge);
  b_objective_3_complete = TRUE;

end

script dormant m60_rampancy_hall()
		sleep_until( volume_test_players(rampancy_hall), 1);
		
		wake(f_dialog_m60_rampancy_hall);

end


script dormant covenant_forerun_coop()
	// this should probably fire when the first wave in the cave is dead
	sleep_until( volume_test_players(covenant_forerun_coop), 1);
	wake(f_dialog_m60_covenant_forerun_coop);
	
end

script dormant covenant_forerun_coop_2()

	wake(f_dialog_m60_covenant_forerun_coop_02);

end

script dormant cortana_cave_cleared()
	// Cortana VO for when the LZ is cleared and the Pelican can come in
		wake(f_dialog_m60_pelican_approach_lasky);
		
	
end



script dormant pelican_chief_welcome()
	// Fires as you board the Pelican
	dprint("d");
	 wake(f_dialog_m60_pelican_chief_welcome);
		
end	


script dormant m60_on_pelican_vo()
 dprint("d");
	//wake(f_dialog_m60_rally_pelican);
	
end

script dormant rally_chief_onme()
	// fires when Chief is dropped off by Pelican
	sleep_until (volume_test_players(chief_pelican_touch_down), 1);
			wake(f_dialog_m60_rally_chief_onme);
  
  wake(m60_scorpionenter);
/*	wake(marine_rally_chatter_01);
	wake(marine_rally_chatter_02);
	wake(marine_rally_chatter_03);
	wake(marine_rally_chatter_04);*/

end

script dormant m60_scorpionenter()
		sleep_until (player_in_vehicle (ve_rally_scorpion), 1);
		
			wake(f_dialog_m60_scorpionenter);


end




script static void m60_infinity_run_01()
			sleep_until (volume_test_players(rally_chief_onme), 1);
		wake(f_dialog_m60_infinityrun);

end

script static void m60_infinity_run_02()
			sleep_until (volume_test_players(m60_infinity_run_02), 1);
			wake(f_dialog_m60_infinityrun_02);
end


script static void m60_infinity_ext_cleared()
dprint("d");
		//wake(f_dialog_m60_infinity_ext_cleared);
end


script static void m60_infinity_run_03()
		sleep_s(7);
		wake(f_dialog_m60_infinity_ext_02);

end





script dormant lasky_clear_berth()
	//fires as you approach berth
	sleep_until (volume_test_players(lasky_clear_berth), 1);
	

	//  wake(f_dialog_m60_infinity_ext);
		
end



script static void inifinityberth_tocauseway()
  //fire when berth, inside and out, is clear
     wake(f_dialog_m60_infinityberth_tocauseway);

     kill_script(m60_objective_4_nudge);
     sleep_forever(m60_objective_4_nudge);
  		b_objective_4_complete = TRUE;
      
end




script static void inifinityberth_mechdata()
     sleep_until( volume_test_players(m60infinity_berth_030_pip_mechdata), 1);
     sleep_s(30); 
     if b_mantis_engaged == FALSE then
		 	thread(infinitybirth_VO_trigger());
     end
end

script static void infinitybirth_VO_trigger()
		wake(f_dialog_m60_inifinityberth_mechdata);

end

script dormant m60_infinityberth_enter_mantis()
     //Fires if you push the mech button
     	sleep_until (object_valid (mech_switch), 1);
			sleep_until (device_get_position(mech_switch) > 0.0, 1 );
		wake(f_dialog_m60_inifinityberth_system_mech);
		thread(m60_objective_5_nudge()); 
		b_mantis_engaged = TRUE;
		sleep_forever(inifinityberth_mechdata);
		kill_script(inifinityberth_mechdata);
		
				object_create(infinity_secondary_01);
		object_create(infinity_secondary_04);
		object_create(infinity_secondary_05);
     
end



script dormant m60_try_to_leave_mechbay()
     sleep_until( volume_test_players(m60_try_to_leave_mechbay), 1);
     
			wake(f_dialog_m60_inifinityberth_try_to_leave);

end




script dormant trail_xray_pickup()
//fires when the player picks up the x-ray ability for the first time.
	
		dprint("d");

end


script dormant trail_xray_use()
//fires when the player uses the xray ability for the first time.
		dprint("d");
	//thread (story_blurb_add("vo", "CORTANA: Comments on how the device works and what Chief should do next."));
			
end


script static void inifinitycauseway_broadswordassault()
   // fires upon entering the Mantis
		kill_script(m60_try_to_leave_mechbay);
		wake(f_dialog_m60_inifinityberth_enter_mech);
		
     
end

global real R_berth_narrative_conversation_trigger_see_dist = 	7.5;
global real R_berth_narrative_conversation_trigger_near_dist = 5.0;

script static boolean f_berth_narrative_distance_trigger( object obj_character, real r_distance_see, real r_distance_near )
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
	( not ai_allegiance_broken(player, human) );
end

script  static void m60_berth_exit_grunts(ai ai_character)
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_berth_narrative_distance_trigger(ai_get_object(ai_character), R_berth_narrative_conversation_trigger_see_dist, R_berth_narrative_conversation_trigger_near_dist), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(f_dialog_m60_berth_exit_grunts);
	end

end
     

script  static void m60_berth_exit_grunts_02 (ai ai_character)
static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_berth_narrative_distance_trigger(ai_get_object(ai_character), R_berth_narrative_conversation_trigger_see_dist, R_berth_narrative_conversation_trigger_near_dist), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		wake(f_dialog_m60_berth_exit_grunts_02);
	end

end
     

script static void inifinitycauseway_broadswordassault_end()
	//this should fire at the beginning of the Broadsword vignette
     
	dprint("d");
		
  
end

script dormant m60_infinitycauseway_stomp()
	  sleep_until( volume_test_players(m60_infinitycauseway_stomp), 1);
     
	//wake(f_dialog_m60_infinitycauseway_stomp);
		
  
end



script static void inifinitycauseway_defendthedeck()
	//this should fire at beginning of elevator to deck
    kill_script(m60_objective_5_nudge);
		sleep_forever(m60_objective_5_nudge); 
	  wake(f_dialog_m60_infinity_elevator);

end


script static void inifinityouterdeck_gun1()

dprint("");
end

script static void inifinityouterdeck_gun2()
dprint("");

end

script dormant infinityouterdeck_start()
	// fires upon reaching the outer deck
	dprint("d");
	
end


script dormant infinityouterdeck_start_alt()
	// fires upon reaching the outer deck
			sleep_until( volume_test_players(infinityouterdeck_start), 1);
		wake(f_dialog_m60_jammer_01);
		kill_script(m60_objective_5_nudge);
		sleep_forever(m60_objective_5_nudge);
  		b_objective_5_complete = TRUE;
  thread(m60_objective_6_nudge()); 


	
end

script dormant m60_infinityouterdeck_first_jammer()
	// fires upon taking out first jammer
			
		wake(f_dialog_m60_jammer_02);


end


script dormant m60_infinityouterdeck_second_jammer()
	// fires upon taking out second jammer
			

		wake(f_dialog_m60_jammer_03);
		
end


script dormant m60_infinityouterdeck_third_jammer()
	// fires upon taking out third jammer
			
	wake(f_dialog_m60_jammer_04);
end

script dormant m60_infinityouterdeck_guns_begin()
	// fires when the guns first begin to warm
			
			wake(f_dialog_m60_delrio_warning);
end



script dormant m60_infinityouterdeck_first_gun_online()
	// fires when first gun online
			
			wake(f_dialog_m60_infinityouterdeck_gunsonline);

end
script dormant m60_infinityouterdeck_second_gun_online()
	// fires when second gun online
			
			
		wake(f_dialog_m60_inifinitycauseway_second_gun);

end




script dormant m60_infinityouterdeck_firing_controls()
	// fires before final action of player to initiate controls

			wake(f_dialog_m60_infinityouterdeck_mac_ready);

end




script static void inifinityouterdeck_gun3()
  // fire when 3rd gun online
     dprint("d");
	wake(f_dialog_m60_infinityouterdeck_success);
		kill_script(f_dialog_m60_nudge_6);
  		b_objective_6_complete = TRUE;

end

script dormant m60_waypoint_terminal()
	//fires when you click the terminal in vale
	f_narrative_domain_terminal_setup( 2, domain_terminal, domain_terminal_button );
//	sleep_until (object_valid (terminal_button), 1);
//	sleep_until (device_get_position(terminal_button) > 0.0, 1 );
//	device_set_power (terminal_button, 0.0);
//		if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
//			wake(f_dialog_global_my_first_domain); 
//		end
//		SetNarrativeFlagWithFanfareMessageForAllPlayers( 2, TRUE );
end

// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script static void m60_objective_1_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m60_nudge_1());
			end
				if b_objective_1_complete == FALSE then
					thread( m60_objective_1_nudge());
			end
end

script static void m60_objective_2_nudge()
			dprint("Nudge fired");
			sleep_s(300);
			if b_objective_2_complete == FALSE then
						thread(f_dialog_m60_nudge_2());
			end
				if b_objective_2_complete == FALSE then
					thread( m60_objective_2_nudge());
			end
end



script static void m60_objective_4_nudge()
			dprint("Nudge fired");
			sleep_s(300);
			if b_objective_4_complete == FALSE then
						thread(f_dialog_m60_nudge_4());
			end
				if b_objective_4_complete == FALSE then
					thread( m60_objective_4_nudge());
			end
end



script static void m60_objective_5_nudge()
			dprint("Nudge fired");
			sleep_s(120);
			if b_objective_5_complete == FALSE then
						thread(f_dialog_m60_nudge_5());
			end
				if b_objective_5_complete == FALSE then
					thread( m60_objective_5_nudge());
			end
end


script static void m60_objective_6_nudge()
			dprint("Nudge fired");
			sleep_s(600);
			if b_objective_6_complete == FALSE then
						thread(f_dialog_m60_nudge_6());
			end
				if b_objective_6_complete == FALSE then
					thread( m60_objective_6_nudge());
			end
end



// =================================================================================================
// =================================================================================================
// SOUND STORY	
// =================================================================================================
// =================================================================================================



script dormant swamp_marine_chatter_01()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(swamp_marine_chatter_01), 1);
	

	  wake(f_dialog_m60_swamp_marine_1);
		
end

script dormant swamp_marine_chatter_02()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(swamp_marine_chatter_02), 1);
	

	  wake(f_dialog_m60_swamp_marine_2);
		
end


script dormant swamp_marine_chatter_03()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(swamp_marine_chatter_03), 1);
	

	  wake(f_dialog_m60_swamp_marine_3);
		
end


script dormant swamp_marine_chatter_04()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(swamp_marine_chatter_04), 1);
	

	  wake(f_dialog_m60_swamp_marine_4);
		
end


script dormant swamp_marine_chatter_05()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(swamp_marine_chatter_05), 1);
	

	 wake(f_dialog_m60_swamp_marine_5);
		
end

/*

script dormant marine_rally_chatter_01()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(marine_rally_chatter_01), 1);

			thread(f_dialog_m60_rally_point_01());

		
end

script dormant marine_rally_chatter_02()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(marine_rally_chatter_02), 1);
	

	 thread(f_dialog_m60_rally_point_02());
		
end


script dormant marine_rally_chatter_03()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(marine_rally_chatter_03), 1);
	

	 thread(f_dialog_m60_rally_point_03());
		
end


script dormant marine_rally_chatter_04()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(marine_rally_chatter_04), 1);
	

	 thread(f_dialog_m60_rally_point_04());
		
end*/



script dormant infinity_ship_pa_01()
	
	sleep_until (volume_test_players(infinity_ship_pa_01), 1);
	

		wake(f_dialog_m60_infinity_ship_pa_01);
		
end



script dormant infinity_ship_pa_02()
	
	sleep_until (volume_test_players(infinity_ship_pa_02), 1);
	

	 wake(f_dialog_m60_infinity_ship_pa_02);
		
end


script dormant infinity_ship_pa_03()
	
	sleep_until (volume_test_players(infinity_ship_pa_04), 1);
	

	 wake(f_dialog_m60_infinity_ship_pa_03);
		
end


script dormant infinity_ship_pa_04()
	
	sleep_until (volume_test_players(infinity_ship_pa_03), 1);
	

	 wake(f_dialog_m60_infinity_ship_pa_04);
		
end

script dormant infinity_ship_pa_05()
	
	sleep_until (volume_test_players(infinity_ship_pa_05), 1);
	

	 wake(f_dialog_m60_infinity_ship_pa_05);
		
end


script dormant infinity_ship_pa_06()
	//Plays a random swamp marine chatter
	sleep_until (volume_test_players(infinity_ship_pa_06), 1);
	

	 wake(f_dialog_m60_infinity_ship_pa_06);
		
end


script dormant infinity_ship_pa_07()
	
	sleep_until (volume_test_players(infinity_ship_pa_07), 1);
	

		wake(f_dialog_m60_infinity_ship_pa_07);
		
end

script static void m60_infinity_secondary_01()

	sleep_until (object_valid (infinity_secondary_01), 1);	
	sleep_until (device_get_position(infinity_secondary_01) > 0.0, 1 );
	object_destroy( infinity_secondary_01 );
	
	
		thread(f_dialog_m60_infinity_secondary_01());
		
end


script static void m60_infinity_secondary_02()

	sleep_until (object_valid (infinity_secondary_02), 1);	
	sleep_until (device_get_position(infinity_secondary_02) > 0.0, 1 );
	object_destroy( infinity_secondary_02 );
	
	
	
		thread(f_dialog_m60_infinity_secondary_02());
		
end

script static void m60_infinity_secondary_03()

	sleep_until (object_valid (infinity_secondary_03), 1);	
	sleep_until (device_get_position(infinity_secondary_03) > 0.0, 1 );
	object_destroy( infinity_secondary_03 );
	
	
		thread(f_dialog_m60_infinity_secondary_03());
		
end

script static void m60_infinity_secondary_04()

	sleep_until (object_valid (infinity_secondary_04), 1);	
	sleep_until (device_get_position(infinity_secondary_04) > 0.0, 1 );
	object_destroy( infinity_secondary_04 );
	
	
	
		thread(f_dialog_m60_infinity_secondary_04());
		
end

script static void m60_infinity_secondary_05()

	sleep_until (object_valid (infinity_secondary_05), 1);	
	sleep_until (device_get_position(infinity_secondary_05) > 0.0, 1 );
	object_destroy( infinity_secondary_05 );
	
	
	
		thread(f_dialog_m60_infinity_secondary_05());
		
end


script static void m60_infinity_secondary_06()

	sleep_until (object_valid (infinity_secondary_06), 1);	
	sleep_until (device_get_position(infinity_secondary_06) > 0.0, 1 );
	object_destroy( infinity_secondary_06 );
	
	
		thread(f_dialog_m60_infinity_secondary_06());
		
end

script static void m60_infinity_secondary_07()

	sleep_until (object_valid (infinity_secondary_07), 1);	
	sleep_until (device_get_position(infinity_secondary_07) > 0.0, 1 );
	object_destroy( infinity_secondary_07 );
	
	
		thread(f_dialog_m60_infinity_secondary_07());
		
end


// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()

		wake(f_waypoint_global_equipment_unlock);
end