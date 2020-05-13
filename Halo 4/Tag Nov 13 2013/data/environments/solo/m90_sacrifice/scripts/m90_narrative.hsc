
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M90
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////

// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M90
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================


global boolean b_first_beam_used = FALSE;
global boolean b_first_beam_left = FALSE;
global boolean b_first_beam_right = FALSE;
global boolean b_leave_without_cortana_1 = FALSE;
global boolean b_leave_without_cortana_2 = FALSE;
global boolean b_leave_without_cortana_3 = FALSE;
global boolean b_cortana_retrieved = FALSE;
global boolean b_m90_b_60_over = FALSE;
global boolean b_chapter_title_1_over = FALSE;


global object pup_player0 = player0;
global object pup_player1 = player1;
global object pup_player2 = player2;
global object pup_player3 = player3;
global long l_dlg_90_wrong_room_2 = DEF_DIALOG_ID_NONE();
global long l_dlg_90_wrong_room_2_background = DEF_DIALOG_ID_NONE();



// =================================================================================================
// *** STARTUP ***
// =================================================================================================

/////////////////////////////////////////////////////////
// LEVEL HOOKS
/////////////////////////////////////////////////////////////////////////////
//// PLEASE PUT YOUR NARRATIVE HOOKS HERE
//// THEY WILL GET ACTIVATED DURING DIFFERENT SECTIONS OF THE MISSION'S INIT
//// THIS WILL HELP US WITH SETUP/CLEANUP/FRAMERATE/AVOIDING MAX THREAD COUNT
/////////////////////////////////////////////////////////////////////////////


script dormant nar_flight_start_init()
	dprint("NAR trench a init");
	thread(nar_ship_start());
		
end

script dormant nar_flight_trench_b_init()
	dprint("NAR trench b init");
	wake(m90_didact_ship_exterior_fourth);
	
	wake(m90_didact_ship_exterior_sixth);
end

script dormant nar_flight_trench_c_init()
	dprint("NAR trench c init");
end

script dormant nar_flight_trench_d_init()
	dprint("NAR trench d init");
	//thread(nar_infinity_cut_back_in());
end

script dormant nar_flight_trench_e_init()
	dprint("NAR trench e init");
		
		
		thread(nar_del_rio_fate());
end

script dormant nar_flight_eye_init()
	dprint("NAR eye init");
	thread(m90_eye_first_gun());
	thread (nar_eye_reveal());
end

script dormant nar_arcade_init()
	dprint("NAR arcade init");
	wake(nar_crash_emerge);
	

	
	thread(m90_didact_ship_leap_of_faith_2());
	//wake(m90_didact_portal_console);
	thread( nar_arcade() );
	thread( nar_dropdown() );
	wake(m90_waypoint_terminal);
	wake(kill_leap_of_faith_vo);
	wake(m90_didact_ship_portals);
end

script dormant nar_teleportals_init()
	dprint("NAR teleportals init");
	thread(nar_teleport_room_2());
	wake(m90_didact_portal_console);
	//thread(didact_malfunctioning_companion());

end

script dormant nar_walls_init()
	dprint("NAR walls init");
	//thread(on_walls_entry());
end

script dormant nar_jump_init()
	dprint("NAR jump init");
	thread(nar_jump());
	thread(nar_jump_love());
	thread(nar_jump_open());
	//thread(pre_eye_composer());

	
	
end

script dormant nar_coldant_init()
	dprint("NAR coldant init");
	thread(dm_plinth_left());
	thread(dm_plinth_right()); 
  wake(m90_eye_insertion_left);
  wake(m90_eye_insertion_right);
end



script startup M90_narrative_main()
	dprint ("::: M90 Narrative Startup :::");
	
	
	////////////////////////////////////////////////
	//  Activating these in the above hook-ins   * chris french
	// 
	/////////////////////////////////////////

	//wake(kill_leap_of_faith_vo);

  
	//wake(m90_transition_platform);

	//thread(nar_ship_start());
	//thread(nar_infinity_cut_back_in());
	//thread(nar_del_rio_fate());
	//thread(nar_teleport_room_2());
	//thread(nar_jump());
	//thread(nar_jump_love());
	//thread(nar_jump_open());
	//thread(dm_plinth_left());
	//thread(dm_plinth_right()); 
	//wake(m90_didact_ship_exterior_third);
	//wake(m90_didact_ship_exterior_fourth);
	//wake(m90_didact_ship_exterior_fifth);
	//wake(m90_didact_ship_exterior_sixth);
	//wake(nar_crash_emerge);
	//wake(kill_leap_of_faith_vo);
	

	//wake(m90_eye_insertion);
	//thread(m90_eye_first_gun());

end

// =================================================================================================
// *** CUTSCENE 1: INTRO ***
// =================================================================================================

script static void nar_intro()
	//print ("Narrative!");
	  //sleep_until( volume_test_players(tv_flight_into), 1);
	dprint("D");
   /* thread (story_blurb_add("cutscene", "The Didact has loaded the super-weapon 'Composer' onto his moon-sized Starship."));
    sleep_s(6);
    thread (story_blurb_add("cutscene", "Chief and Cortana ready a UNSC Broadsword spacefighter-bomber, and launch in pursuit."));
    sleep_s(6);
    thread (story_blurb_add("cutscene", "MISSION: Locate and Bomb the Composer before it can be used again."));
    sleep_s(6);
    thread (story_blurb_add("cutscene", "But just as they reach the Starship's hull, it suddenly warps into slipspace, destination unknown..."));
    sleep_s(6);*/
    
end

// =================================================================================================
// *** FLIGHT SECTION ***
// =================================================================================================




script static void nar_ship_start()
	
	  sleep_until( volume_test_players(nar_ship_start), 1);
		wake(f_dialog_m90_didact_ship_exterior);
		
end

script static void f_fx_interior_scan( cutscene_flag the_location )

	effect_new (environments\solo\m90_sacrifice\fx\scan\dscan_trench.effect, the_location );

end

script static void nar_ship_growing()
		sleep_until( volume_test_players(nar_ship_changing), 1);
		//thread (story_blurb_add("other", "DIDACT SCAN WASHES OVER THE SHIP"));
			effect_new( environments\solo\m10_crash\fx\scan\didact_scan.effect, fx_exterior_didact_scan );
			sleep_s(1);
			wake(f_dialog_m90_didact_ship_exterior_second);

end



script dormant m90_didact_ship_exterior_fourth()
		sleep_until( volume_test_players(m90_didact_ship_exterior_fourth), 1);
		wake(f_dialog_m90_didact_ship_exterior_fourth);
end


script dormant m90_didact_ship_exterior_sixth()
		sleep_until( volume_test_players(m90_didact_ship_exterior_sixth), 1);
		wake( f_dialog_m90_didact_ship_exterior_sixth);
end




script static void nar_del_rio_fate()
	
	  sleep_until( volume_test_players(nar_del_rio_fate), 1);
			dprint("d");
    	

end



script static void nar_gate_closing()
	//print ("Narrative!");
	  sleep_until( volume_test_players(tv_gate_closing), 1);
	
    	wake(f_dialog_m90_didact_ship_exterior_eleventh);
end


script static void nar_eye_reveal()
	//print ("Narrative!");
	  sleep_until( volume_test_players(tv_eye_reveal), 1);
		wake(f_dialog_m90_eye_reveal);
end


script static void nar_eye_closed()
	//print ("Narrative!");
	
    	wake(f_dialog_m90_eye_reveal_2);
end




script static void nar_help_infinity()
	//print ("Narrative!");
			//wake(f_dialog_m90_eye_first_gun);
			dprint("d");
    	
end


script static void m90_eye_first_gun()
		sleep_until( (s_Cannon_Count == 3), 1);


			wake(f_dialog_m90_eye_first_gun);
    	
end


script static void nar_eye_defense_update()
	//print ("Narrative!");
	
    	wake(f_dialog_m90_eye_second_gun);
end

script dormant m90_eye_third_gun()
	//print ("Narrative!");
			wake(f_dialog_m90_eye_third_gun);
    	
end


script static void nar_eye_defense_success()
	//print ("Narrative!");
	dprint("d");
    //	thread (story_blurb_add("vo", "UNSC: Woo-hoo!.  Major defenses cleared.  Infinity incoming!"));
	//	wake(f_dialog_m90_eye_last_gun);
		
end

// =================================================================================================
// =================================================================================================
// =================================================================================================
// =================================================================================================
// *** CUTSCENE 2: CRASH *** 91
// =================================================================================================
// =================================================================================================
// =================================================================================================
// =================================================================================================

script static void nar_infinity_cutscene()
	//print ("Narrative!");
	
    /*	thread (story_blurb_add("cutscene", "CUTSCENE: UNSC Infinity bombards the Didact Ship's Eye."));
    	sleep_s(5);
    	thread (story_blurb_add("cutscene", "CUTSCENE: Chief steers towards a small breach in the hull."));
    	sleep_s(5);
    	thread (story_blurb_add("vo", "CHIEF: Hold on!!!"));
    	sleep_s(5);
    	thread (story_blurb_add("cutscene", "CUTSCENE: Chief crashes through the opening..."));
    	sleep_s(5);
    	thread (story_blurb_add("cutscene", "CUTSCENE: The Chief wakes up and emerges from the wreckage."));
    	sleep_s(5);
    	thread (story_blurb_add("vo", "CHIEF: We keep moving... and we find a way."));
    	sleep_s(3);*/
	dprint("d");    	
end


// =================================================================================================
// *** ON-FOOT SECTION ***
// =================================================================================================
// Chief and Cortana emerge from the Broadsword, deep inside the Didact's hip. 
// Bomb destroyed and plans dashed, they continue grim but determined, on foot towards the Eye of the ship. 


script dormant nar_crash_emerge()
	//print ("Narrative!");
	  //sleep_until( volume_test_players(nar_crash_emerge), 1);	
	  sleep_until( b_arcade_cin_intro_done, 1);	
    	wake(f_dialog_m90_didact_ship_crash_room);
    	
end






script static void nar_arcade()
	//print ("Narrative!");
	sleep_until( volume_test_players(m90_didact_ship_console_nudge), 1);
			effect_new (environments\solo\m90_sacrifice\fx\scan\dscan_crash.effect, flag_didact01_scan );
			wake(f_dialog_m90_didact_ship_scan);
    	//thread (story_blurb_add("vo", "CORTANA: Chief.  You're going to have to jump down this shaft! Grav lift powered?."));

end

script static void nar_dropdown()
	//print ("Narrative!");
	sleep_until( volume_test_players(tv_nar_dropdown), 1);
			wake(f_dialog_m90_didact_ship_leap_of_faith_1);
		

end

script static void m90_didact_ship_leap_of_faith_2()
	sleep_until( volume_test_players(thread_leap_of_faith_nudge), 1);

		sleep_s(3);
		wake(f_dialog_m90_didact_ship_leap_of_faith_2);
		thread(m90_didact_ship_leap_of_faith_3());

end

script static void m90_didact_ship_leap_of_faith_3()
		sleep_s(10);
		wake(f_dialog_m90_didact_ship_leap_of_faith_3);

end


script dormant kill_leap_of_faith_vo()
	//print ("Narrative!");
	sleep_until( volume_test_players(tv_kill_leap_of_faith_vo), 1);
	kill_script(m90_didact_ship_leap_of_faith_2);
	sleep_forever(m90_didact_ship_leap_of_faith_2);
	kill_script(m90_didact_ship_leap_of_faith_3);
	sleep_forever(m90_didact_ship_leap_of_faith_3);
	wake(f_dialog_90_dropping_leap_of_faith);

end



script dormant m90_waypoint_terminal()
	//fires when you click the terminal in vale
/*
	sleep_until (object_valid (terminal_button), 1);
	sleep_until (device_get_position(terminal_button) > 0.0, 1 );
	device_set_power (terminal_button, 0.0);
			if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
				wake(f_dialog_global_my_first_domain); 
			end
		SetNarrativeFlagWithFanfareMessageForAllPlayers( 6, TRUE );
*/
	f_narrative_domain_terminal_setup( 6, domain_terminal, terminal_button );
end


script dormant m90_didact_ship_portals()
     sleep_until( volume_test_players(m90_didact_ship_portals), 1);	
		wake(f_dialog_m90_didact_ship_portals);
end


script static void nar_teleport_intro()
		dprint("d");
    //	wake(f_dialog_m90_didact_portal_console);
end

script dormant m90_didact_portal_console()
		sleep_until( volume_test_players(m90_didact_portal_console), 1);	
			wake(f_dialog_m90_didact_portal_console);

end

script static void nar_teleport_intro_open()
			
			wake(f_dialog_m90_didact_portal_console_insertion);
			wake(m90_didact_portal_console_nudge);
			
end


script dormant m90_didact_portal_console_nudge()
			sleep_s(30);
			wake(f_dialog_m90_didact_portal_console_nudge);
			
end

script static void didact_malfunctioning_companion()
		sleep_until( volume_test_players(didact_malfunctioning_companion), 1);	
		//wake(f_dialog_m90_wrong_room_1);
		
end

script static void on_walls_entry()
		//sleep_until( volume_test_players(on_walls_entry), 1);	
		wake(f_dialog_m90_on_walls_entry);
		
end
script static void nar_teleport_bad_1()
		kill_script(m90_didact_portal_console_nudge);
end


script static void nar_teleport_plat_1()
			wake(f_dialog_m90_wrong_room_1_combat);
end

script static void nar_teleport_room_2()
			sleep_until( volume_test_players(nar_teleport_room_2), 1);
			wake(f_dialog_m90_portal_room_2);
			sleep_s(3);
			wake(m90_portal_room_2_combat);
end

script dormant m90_portal_room_2_combat()
			dprint("d");
			//wake(f_dialog_m90_portal_room_2_combat);
			
end


script static void nar_teleport_special()
 		wake(f_dialog_m90_wrong_room_2);
end



script static void nar_teleport_special_weapons()
dprint("d");
   // 	thread (story_blurb_add("domain", "CORTANA: Let me help you with those."));
end



script static void nar_teleport_reenter()
    	wake(f_dialog_m90_portal_room_3);
end

script static void m90_portal_room_3_02()
    	dprint("d");
end	


script static void nar_walls_need_time()
 
 	wake(f_dialog_m90_need_time);
end


script static void nar_walls_turrets()
	wake(f_dialog_m90_final_portal_turrets);
end

script static void nar_walls_incoming()
    	dprint("d");
end



script static void nar_walls_portal_open()
    	wake(f_dialog_m90_final_room_portal);
end

/*script static void m90_leave_without_cortana()
				sleep_s(10);
		     sleep_until( volume_test_players(leave_without_cortana), 1);
		     
		      if (b_leave_without_cortana_1 == TRUE) and (b_leave_without_cortana_2 == TRUE) and (b_cortana_retrieved == FALSE) then
			    	wake(f_dialog_m90_leave_without_cortana_3);
			    	b_leave_without_cortana_1 = FALSE;		
						b_leave_without_cortana_2 = FALSE;		 
		     elseif (b_leave_without_cortana_1 == TRUE) and (b_leave_without_cortana_2 == FALSE) and (b_cortana_retrieved == FALSE) then
		    		wake(f_dialog_m90_leave_without_cortana_2);
		    		b_leave_without_cortana_2 = TRUE;		     
			  elseif (b_leave_without_cortana_1 == FALSE) and (b_leave_without_cortana_2 == FALSE) and (b_cortana_retrieved == FALSE) then
		    		wake(f_dialog_m90_leave_without_cortana_1);
		    		b_leave_without_cortana_1 = TRUE;
				end
		//	sleep_s(10);
		//	thread(m90_leave_without_cortana());
end*/


script static void nar_jump()
	//print ("Narrative!");
	sleep_until( volume_test_players(tv_nar_jump_start), 1);
		wake(f_dialog_m90_pre_jump);
end

script static void nar_jump_love()
	sleep_until( volume_test_players(tv_nar_jump_love), 1);
		wake(f_dialog_m90_jump_pip);

end

script static void nar_jump_open()
	sleep_until( volume_test_players(tv_nar_jump_open), 1);
	//	thread (story_blurb_add("other", "THE ROOF OPENS UP AND THE EYE BEGINS TO POWER UP. THE DIDACT IS ALMOST READY."));

end

/*script static void pre_eye_composer()
	sleep_until( volume_test_players(pre_eye_composer), 1);
		wake(f_dialog_m90_didact_eye);

end
		*/
		


script static void nar_jump2()
	//print ("Narrative!");
	sleep_until( volume_test_players(tv_nar_jump_start), 1);
		/*
		
  	thread (story_blurb_add("domain", "CORTANA: Chief, look! The Composer! But how do we get there?"));
  	sleep_s(6); 
   	thread (story_blurb_add("vo", "CHIEF: I got this."));
   	sleep_s(3);
   	thread (story_blurb_add("other", "CHIEF USES THE MANCANNON TO ENTER A STREAM THAT LEADS TO THE EYE."));	
	sleep_until( volume_test_players(tv_nar_jump_love), 1);
		thread (story_blurb_add("other", "CHIEF AND CORTANA SHARE A MOMENT."));
		sleep_s(2);
		thread (story_blurb_add("domain", "CORTANA: Chief... The Didact... he'll be out there, won't he?"));
		sleep_s(6); 
		thread (story_blurb_add("vo", "CHIEF: Focus on the Composer. If we face the Didact, we'll find a way... together."));
		sleep_s(6); 
		thread (story_blurb_add("domain", "CORTANA: And if we can't... John... I don't know if I'm ready..."));
		sleep_s(6); 
		thread (story_blurb_add("vo", "CHIEF: Nobody ever is, Cortana. But we all reach the end, some day."));
		sleep_s(6); 
		thread (story_blurb_add("domain", "CORTANA: No, John... it's just that... I'm just not ready... to lose y--"));
	
	sleep_until( volume_test_players(tv_nar_jump_open), 1);
		thread (story_blurb_add("other", "THE ROOF OPENS UP AND THE EYE BEGINS TO POWER UP. THE DIDACT IS ALMOST READY."));
		sleep_s(2);
		thread (story_blurb_add("vo", "CHIEF: Cortana! Something's happening!"));
		sleep_s(6); 
		thread (story_blurb_add("domain", "CORTANA: The Composer... it's preparing to fire!"));
		sleep_s(8); 
   	thread (story_blurb_add("vo", "CHIEF: No!!!"));
		sleep_s(6); 
		thread (story_blurb_add("domain", "CORTANA: If we can just reach the Composer's controls, maybe I can--"));
		sleep_s(5); 
		thread (story_blurb_add("vo", "CHIEF: No time for maybes, Cortana. It needs to be stopped... at any cost."));
		sleep_s(6); 
		thread (story_blurb_add("domain", "CORTANA: John...you can't mean...?"));
		sleep_s(6); 
		thread (story_blurb_add("vo", "CHIEF: I think we both knew this was a one-way trip."));*/
		
end


script static void nar_coldant_intro()
	//Called after initializing Coldant. 
	//print ("Narrative!");
	 // sleep_until( volume_test_players(tv_nar_coldant), 1);
	   wake(f_dialog_m90_didact_eye_02);


end

script static void nar_coldant_switch()
	 		//thread (story_blurb_add("other", "CORTANA ASKS CHIEF TO INSERT HER INTO THE SYSTEM."));
	 		dprint("d");
			
end



script static void nar_coldant_mancannons_on()
	 		wake(f_dialog_m90_splintering_ics);
end



script dormant m90_eye_insertion_left()
   sleep_until( volume_test_players(m90_eye_insertion_left), 1);
   
   	if b_first_beam_used == TRUE then
		
				wake(f_dialog_m90_beam_2_02);
				
			else
			
				wake(f_dialog_m90_eye_insertion);
    		thread(m90_eye_insertion_2());
		end
end


script dormant m90_eye_insertion_right()
   sleep_until( volume_test_players(m90_eye_insertion_right), 1);
   
   	if b_first_beam_used == TRUE then
		
				wake(f_dialog_m90_beam_2_02);
				
			else
			
				wake(f_dialog_m90_eye_insertion);
    		thread(m90_eye_insertion_2());
		end
end


script static void m90_eye_insertion_2()
	sleep_s(30);
	wake(f_dialog_m90_eye_insertion_2);
	thread(m90_eye_insertion_3());
end

script static void  m90_eye_insertion_3()
	sleep_s(30);
	wake(f_dialog_m90_eye_insertion_3);
end


script dormant m90_plinth_to_beam()
	sleep_s(1);
		
			wake(f_dialog_m90_plinth_to_beam);
			wake(f_dialog_m90_plinth_to_beam_02);

end


script dormant m90_transition_platform()
		//sleep_until( volume_test_players(f_dialog_m90_transition_platform), 1);
			wake(f_dialog_m90_transition_platform);

end



script static void dm_plinth_left()

	sleep_until ( b_cold_left_plinth_ready, 1 );
        kill_script(m90_eye_insertion_2);
        kill_script(m90_eye_insertion_3);
			if b_first_beam_used == FALSE then
				b_first_beam_used = TRUE;
				b_first_beam_left = TRUE;
	 	//		wake(f_dialog_m90_beam_vignette_1);
	 			sleep_s(7);
	 			wake(f_dialog_m90_beam_vignette_2);
			
			end
			
			
end

script static void dm_plinth_right()

	sleep_until ( b_cold_right_plinth_ready, 1 );
        kill_script(m90_eye_insertion_2);
       kill_script(m90_eye_insertion_3);
			if  b_first_beam_used == FALSE then
				b_first_beam_used = TRUE;
				b_first_beam_right = TRUE;
	 		//	wake(f_dialog_m90_beam_vignette_1);
	 			sleep_s(7);
	 			wake(f_dialog_m90_beam_vignette_2);
			
			end
			
end







script static void nar_coldant_progress()
	//Called after initializing Coldant. Triggered as player incrementally solves Composer Beam puzzle. 
	//print ("Narrative!");
	
	// Composer Core count starts at 2, and counts down as each is destroyed. 
	sleep_until ((composer_core_count == 1), 1);
		// First Core is destroyed. 
		//thread (story_blurb_add("domain", "CORTANA: That's one beam down!"));
    sleep_s(6); 
   // thread (story_blurb_add("domain", "CORTANA: The Composer is destabilizing... let's deactivate the final beam!"));
    sleep_s(6); 

	sleep_until ((composer_core_count == 0), 1);
		// All Cores destroyed. Puzzle solved, Composer open. 
		//thread (story_blurb_add("domain", "CORTANA: That's it! The Composer is overloading!"));
    sleep_s(6); 
    //thread (story_blurb_add("domain", "CORTANA: Let's get back to the main platform, we can access the Composer's core from there!"));
    sleep_s(6); 

end

script static void nar_coldant_walk_into_beam()
    	//thread (story_blurb_add("domain", "CORTANA: Walk into the beam Chief.  I think your suit will overload the power stream."));
    	dprint("d");
end

script dormant nar_light_shield_barricadest()
 sleep_until( volume_test_players(f_dialog_m90_plinth_to_beam_02) or volume_test_players(f_dialog_m90_plinth_to_beam_01)  , 1);

	wake(f_dialog_m90_light_shield_barricades);

end

script dormant nar_grav_lift()
 sleep_until( volume_test_players(grav_lift_volume), 1);

	wake(f_dialog_m90_grav_lift);

end

// =================================================================================================
// *** CUTSCENE 3: SACRIFICE ***
// =================================================================================================

script static void nar_m90_core()
//	Called when player reaches Composer Core. Currently set up as a teleport within Coldant. 
    	dprint("d");
	
	//sleep_s(6);
	
end






script static void nar_m90_end()
//	Called from inside Coldant script, after Chief presses "the button" to end the game. 
//	This is the final "cinematic". Expect to be chopped up into multiple sequences, with ICS, at a later date. 
	
	//	print ("Narrative!");
	//sleep_s(3);
		
	//story_blurb_add_cutscene("MISSION COMPLETE: Thanks for playing.");
	//sleep_s(6);
	//story_blurb_add_cutscene("ROLL CREDITS");
	//sleep_s(6);
	//dprint("M90 mission complete");
	b_M90_COMPLETE = TRUE;
        	
end


// =================================================================================================
// *** REFERENCE - DO NOT USE ***
// =================================================================================================

script static void intro_cutscene_blurb()
	//print ("Narrative!");
	  sleep_until( volume_test_players(tv_cutscene_hello_1), 1);
	
	  thread (pip_on());
	
	   sleep_s (5);

    //thread (story_blurb_add("other", "OTHER: Howdy, Armando."));
    thread (story_blurb_clear());
end

script static void second_cutscene_blurb()
	//print ("Narrative!");
	  sleep_until( volume_test_players(tv_cutscene_hello_2), 1);
	
	  thread (pip_on());
	
	   sleep_s (5);

    //thread (story_blurb_add("domain", "DOMAIN: As you can see, we now have working simple blurbs."));
end

script static void third_cutscene_blurb()
	//print ("Narrative!");
	  sleep_until( volume_test_players(tv_cutscene_hello_3), 1);
	
	  thread (pip_on());
	
	   sleep_s (5);

    thread (story_blurb_add("cutscene", "CUTSCENE: I suppose I should add something pithy here, but I'm just happy its working."));
end


// =================================================================================================
// *** PUPPETEER SCENES ***
// =================================================================================================

global short g_composer_state = 0;
global boolean g_composer_fire = false;
global boolean g_hide_prompt = false;
global short g_kill_player = 0;
global boolean g_take_cortana= false;

script static void f_show_stick_prompt( object pup )
	unit_action_test_reset(pup);
	chud_show_screen_training(pup,"tutorial_climbstick");
	sleep(1);
	g_hide_prompt = false;
	sleep_until(unit_action_test_move_relative_fwd(pup) or g_hide_prompt,1);
	chud_show_screen_training(pup,"");
end

script static void f_show_grenade_prompt( object pup )
	unit_action_test_reset(pup);
	chud_show_screen_training(pup,"mantis_board_grenade");
	sleep(1);
	g_hide_prompt = false;
	sleep_until(unit_action_test_grenade_trigger(pup) or g_hide_prompt,1);
	
	// only play this music trigger if the play succesfully plants the grenade
	if (g_hide_prompt == false) then
		thread(f_music_m90_v14_vs_didact_2());
	end
	
	chud_show_screen_training(pup,"");
end

script static void didact_ics_end_letterbox()
	sleep (30);
	
	cinematic_show_letterbox (TRUE);
end

// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()

		wake(f_waypoint_global_equipment_unlock);
end
