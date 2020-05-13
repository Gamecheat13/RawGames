
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M30
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***
// =================================================================================================

global boolean b_didact_portal_open = FALSE;
global boolean b_was_bridge_visited = FALSE;
global boolean b_second_portal_opens = FALSE;
global boolean b_opening_vignette_over = FALSE;
global boolean b_ext1_final_fight_over = FALSE;
global boolean b_pylon_two_cores_down = FALSE;
global boolean b_objective_1_complete = FALSE;
global boolean b_objective_2_complete = FALSE;
global boolean b_objective_3_complete = FALSE;
global boolean b_objective_4_complete = FALSE;
global boolean b_objective_5_complete = FALSE;
global boolean b_relay_cine_done = FALSE;  
global boolean b_one_core_down = FALSE; 
global boolean b_two_core_down = TRUE;
global long l_dlg_insert_into = DEF_DIALOG_ID_NONE();

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M30_narrative_main()

	print ("::: M30 Narrative Start :::");
	wake(M30_grassy_hills_first);
	thread (M30_cryptum_into());
	wake (M30_plylonone_arrival);
	wake (m30_pylonone_reveal);
	//wake (m30_hallway_1_enter);
	wake( m30_prepawn);
	//wake (M30_gargoyle_tease);
	wake(m30_escape_volume_09);
	wake (m30_canyons_1_rock_hallway);	
	//wake (M30_observatory_second);
	wake (M30_observatory_final);
	wake (m30_escape_preportal_01);
	wake (m30_escape_volume_04);
	wake (m30_escape_volume_05);
		wake (m30_escape_volume_06);
			wake (m30_escape_volume_07);
	wake(m30_grassy_hill_over);
	wake (m30_donut_infinity_broadcast);
	wake (f_m30_canyon_terminal);
	thread (m30_insert_into());
	//thread (M30_grassy_hills_second());
	//thread (m30_pylontwo_top_alt());
  wake(m30_plyonone_core_close);
  wake(m30_donut_signal_relay);
  wake(m30_pylonone_hallwaytwo_enter_1);
  wake(M30_pylontwo_elevator_ride);
//	thread (use_boost_VO_prompt(player0));

end

script static void M30_cryptum_into()
  sleep_until( volume_test_players(m30_cryptum_into), 1);

  if (portal_count == 0) then
			sleep_s(1);
			wake (f_dialog_M30_observatory_first);
	  	b_opening_vignette_over = TRUE;
	  else
	  	dprint("insertion");
	  end
	
	wake (chapter_one_display);

end


script dormant M30_observatory_first()
	sleep_until (volume_test_players (M30_observatory) and (portal_count == 0), 1);
   	

	thread(M30_observ_1_nudge());
	b_opening_vignette_over = TRUE;
end


script static void M30_observ_1_nudge()
		sleep_s(60);
		wake(f_dialog_M30_observ_1_nudge);
		thread(M30_observ_1_nudge_2());
end

script static void M30_observ_1_nudge_2()
		sleep_s(60);
		wake(f_dialog_M30_observ_1_nudge_2);
	 thread(M30_observ_1_nudge());
end


script static void m30_insert_into()
  sleep_until( volume_test_players(m30_obswalk), 1);
  
	dprint("m30_insert_into");
	if portal_count == 0 then
	wake(f_dialogue_m30_insert_into);
	end
  
end

script dormant M30_Console_Button_one()
	//triggers when the player activates the button to open portal one.(left)
	dprint ("m30_console_button_one is now awake");
	//wake(f_dialog_M30_Console_Button_one);
	dprint ("cinematic block in begin playing");
	kill_script(M30_observ_1_nudge);
	kill_script(M30_observ_1_nudge_2);

	dialog_end_interrupt(l_dlg_insert_into);
	b_relay_cine_done = TRUE;

	f_start_mission ("cin_m030_relay");
	b_didact_portal_open = TRUE;
	dprint ("relay cinematic done");
	observation_portal_01->f_animate_instant();
	cinematic_exit("cin_m030_relay", FALSE );
	players_weapon_down( -1, 0.25, FALSE ); //this is here temporarily to fix an issue where weapons turn invisible after a cinematic - we're going to have to fix the global cinematic scripts to permanently fix the issue.
 	  


end


script dormant M30_plylonone_arrival()
  sleep_until( volume_test_players(M30_plylonone_arrival), 1);
  

 				wake (m30_objective_1);
 				wake(f_dialog_m30_pylonone_arrival);

				
end

script dormant M30_gargoyle_tease()
			(sleep_until (volume_test_players (m30_gargoyle_tease), 1));
  			//wake(f_dialog_M30_gargoyle_tease);

    		
end

script dormant m30_prepawn()
  sleep_until	(volume_test_players (m30_prepawn), 1) or (ai_living_count (sq_caves_pawn_intro) == 0);
  				wake(f_dialog_m30_first_pawn_fight_start);   

end

script dormant M30_plyon_1_lightbridge()
	wake(f_dialog_m30_plyon_1_lightbridge);

end



script dormant M30_grassy_hills_start()
	//triggers when 2nd Knight "slides" away.
					//wake(f_dialog_M30_grassy_hills);
					dprint("d");
				

end

script dormant M30_grassy_hills_first()
(sleep_until (volume_test_players (grassy_hills_first), 1));

	wake(f_dialog_M30_grassy_hills);

end

script static void M30_grassy_hills_second()
  (sleep_until (volume_test_players (grassy_hills_second), 1));

	wake(f_dialog_M30_grassy_hills_second);

end


script dormant m30_knight_resurrection()
		wake(f_dialog_m30_knight_resurrection);
end

script dormant m30_playing_catch()
		wake(f_dialog_m30_playing_catch);
end



script dormant m30_hallway_1_enter()
	//triggers when entering hallway 1 or after the grassy hill encounter
  sleep_until (volume_test_players (m30_hallway_1_enter), 1);
	
	dprint ("testing testing");
	wake (f_dialog_M30_hallway_1_enter);   


end

script dormant m30_grassy_hill_over()
	//triggers when entering hallway 1 or after the grassy hill encounter
  sleep_until ( b_grassy_hill_encounter_over, 1);
	sleep_s(2);
	dprint ("grassy hill fight over, knight pip starting");
	wake (f_dialog_M30_hallway_1_enter);


end


script dormant m30_canyons_1_rock_hallway()
	//fires in the rocky transition space before the landing
  sleep_until( volume_test_players(m30_canyons_1_rock_hallway), 1);
  	wake(f_dialog_m30_canyons_1_rock_hallway);

end

script dormant f_m30_canyon_terminal()

	f_narrative_domain_terminal_setup( 1, domain_terminal, domain_terminal_button );
	
	/*
	//fires first time you use the map button
	sleep_until (object_valid (canyon_terminal_button), 1);
	sleep_until (device_get_position(canyon_terminal_button) > 0.0, 1 );
	device_set_power (canyon_terminal_button, 0.0);
		
	local long domain_show = pup_play_show ("pup_m30_domain");
			
	sleep_until(not pup_is_playing(domain_show),1);
		
		if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
		
			dprint ("button press weeee");
			//wake(f_dialog_global_my_first_domain); 
		
		end
		
	SetNarrativeFlagWithFanfareMessageForAllPlayers( 1, TRUE );
	*/
			  
end

script dormant m30_ext1_final_fight_check()
	sleep_until (rear_fight_spawn == TRUE);
	
	sleep (1);
	dprint ("waiting for this encounter to end");
	sleep (1);
	
	sleep_until ((ai_living_count (sq_ext1_knight_5) == 0) and (ai_living_count (sg_ext1_rear_fight_pawns) == 0) and (ai_living_count (sq_ext1_bishop_5) == 0), 1);
	
	sleep (30 * 3);
	
	b_ext1_final_fight_over = TRUE;
	dprint ("b_ext1_final_fight_over = TRUE");

end

script dormant m30_pylonone_hallwaytwo_enter_1()
	
  sleep_until ((b_ext1_final_fight_over == TRUE) or (volume_test_players (m30_pylonone_hallwaytwo_enter)), 1);
  				wake(f_dialog_m30_pylonone_hallwaytwo_enter);
	
end

script dormant m30_pylonone_hallwaytwo_enter()
	
  dprint("d");

	
end



script dormant m30_pylonone_reveal()

  sleep_until( volume_test_players(m30_pylonone_reveal), 1);
  			wake(f_dialog_m30_pylonone_reveal);
       kill_script(m30_objective_1_nudge);

end

script dormant m30_plyonone_core_close()

  sleep_until( (volume_test_players(m30_power_core_1) or volume_test_players(m30_power_core_2) or volume_test_players(m30_power_core_3)), 1);
  			wake(f_dialog_m30_plyonone_core_close);


end



script dormant M30_plyonone_core_one()
  //triggers when the first generator at Pylon one is destroyed.
 		wake(f_dialog_m30_plyonone_core_one);

end




script dormant M30_plyonone_core_two()
	wake(f_dialog_m30_plyonone_core_two);

end

script dormant M30_plyonone_core_three()
  //triggers half way up pylon 
  			wake(f_dialog_m30_pylonone_core_three);
  			
  			kill_script(m30_objective_2_nudge);
  //thread (pip_on());
  
          //  thread (story_blurb_add("domain", "CORTANA: Great. That's all the cores. Head for the top of the pylon."));
          //  sleep_s (3.1);
            
//  thread (pip_on());

end

script static void m30_forts1_ifinity()
 


  		wake(f_dialog_m30_start_ramp_enter);

 
end

	

script static void M30_pylonone_bridgetoelevator()
	// Triggers when the player approches the bridge to the elevator
	// Cortana will advise you on destroying the power cores, depending on whether you've visited this trigger volume before and how many cores have been destroyed
		
		repeat
		sleep_s(12);
			sleep_until (volume_test_players (M30_pylonone_bridgetoelevator), 1);
			
			if (b_was_bridge_visited == TRUE) and (forts_1_generator_count == 0) then
				// on SECOND visit to volume with NO cores destroyed, say:
          //				thread (story_blurb_add("domain", "CORTANA: This shield's not going anywhere until those power cores are all off line."));
          
          wake(f_dialog_m30_pylonone_nocores_down_3);	
				
				
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("SECOND visit to volume with NO cores destroyed");
			
			
	
			elseif (b_was_bridge_visited == TRUE) and (forts_1_generator_count == 1) and (b_one_core_down == TRUE) and (b_two_core_down == FALSE) then
				// on SUBSEQUENT visits to the bridge volume since destroying a SINGLE core, say:		
				//thread (story_blurb_add("domain", "CORTANA: The power cores we need to destroy are down on the ground level."));
				wake(f_dialog_m30_pylonone_nocores_down_2);
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("SUBSEQUENT visits to the bridge volume since destroying a SINGLE core");

			elseif (b_was_bridge_visited == TRUE) and (forts_1_generator_count == 2) and (b_one_core_down == TRUE) and (b_two_core_down == TRUE)then
			  // on SUBSEQUENT visits to the bridge volume since destroying TWO cores, say:
          //				thread (story_blurb_add("domain", "CORTANA: Wishing's not going to make it happen, Chief. Take out those power cores!"));
          
         
		//		wake(f_dialog_m30_pylonone_twocoredown_2);
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("SUBSEQUENT visits to the bridge volume since destroying TWO cores");
			
			elseif (forts_1_generator_count == 0) then
				// on FIRST visit to volume with NO cores destroyed, say:
				
          //				thread (story_blurb_add("domain", "CORTANA: The Prometheans must have activated the Pylon's security protocols."));
          //				sleep_s (5.1); 
          //				thread (story_blurb_add("domain", "CORTANA: I'm tracking three power sources below. Let's take see what we can do about them."));
		
					 			
            
            		wake(f_dialog_m30_pylonone_nocores_down);

    
            

				b_was_bridge_visited = TRUE;
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("FIRST visit to volume with NO cores destroyed");
			
			elseif (forts_1_generator_count == 1) then
				// on FIRST visit since destroying only ONE power core, say:		
          //				thread (story_blurb_add("domain", "CORTANA: Looks like one core wasn't enough. We better take care of those other two as well."));
          				
          wake(f_dialog_m30_pylonone_onecoredown);	
				
				b_was_bridge_visited = TRUE;
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("FIRST visit since destroying only ONE power core");
			
			
			
			elseif (forts_1_generator_count == 2) then
				// on FIRST visit since destroying TWO power cores, say:	
      

					wake(f_dialog_m30_pylonone_twocoredown);

				b_was_bridge_visited = TRUE;
				inspect (forts_1_generator_count);
				inspect (b_was_bridge_visited);
				dprint ("FIRST visit since destroying TWO power cores");
			
			end	
								
		until (forts_1_generator_count == 4);
			
		sleep (1);	
		dprint ("M30_pylonone_bridgetoelevator loop has ended.");

end

script dormant M30_plyonone_elevator_ride()
	//triggers when the elevator button to top of pylon one is activated.
	
		wake(f_dialog_m30_pylonone_elevator_ride);

end



script dormant M30_pylonone_top_enter()
	//triggers at the top of the pylon one elevator.
	sleep_until (volume_test_players (M30_pylonone_top_enter), 1);
	wake(f_dialog_M30_pylonone_top_enter);
				
end

script dormant M30_plyonone_end()

  //*** AFTER ICS ***
		wake(f_dialog_m30_pylonone_end);
		kill_script(m30_objective_1_nudge);
//// Cortana : Go!v
//sound_impulse_start ('sound\dialog\mission\m30\m30_pylonone_end_00107', NONE, 1);
//sleep (sound_impulse_time('sound\dialog\mission\m30\m30_pylonone_end_00107'));  

end	


script dormant M30_observatory_second()
 	//Triggers on the observation deck the second time we arrive on the observation platform.
//	sleep_until (volume_test_players (m30_obswalk_02) and (portal_count == 10), 1);
					wake(f_dialog_m30_observatory_second);
          b_second_portal_opens = TRUE;
          b_second_time_through = TRUE;

	
        
end

script dormant M30_Console_Button_two()
  //triggers when the player activates the button to open portal two.(right)
					dprint("deprecated");  
          //  thread (story_blurb_add("vo", "MASTER CHIEF: I assume that wasn't you."));
          //  	sleep_s (5.1);   
          //	thread (story_blurb_add("domain", "CORTANA: No, it wasn't. (nervous deep breath) Weren't you the one who said one mystery at a time?"));   
          
/*          // Master Chief : I assume that wasn't you.
          dprint( "MASTER CHIEF: I assume that wasn't you." );
          sound_impulse_start ('sound\dialog\mission\m30\m30_console_button_two_00100', NONE, 1);
          sleep (sound_impulse_time('sound\dialog\mission\m30\m30_console_button_two_00100'));
          
          // Cortana : No, it wasn't. 
          dprint( "CORTANA: No, it wasn't." ); 
          sound_impulse_start ('sound\dialog\mission\m30\m30_console_button_two_00101', NONE, 1)/*;
   */      // sleep (sound_impulse_time('sound\dialog\mission\m30\m30_console_button_two_00101')*/);
 /*         
          // Cortana : Weren't you the one who said one mystery at a time?
          dprint( "CORTANA: Weren't you the one who said one mystery at a time?" ); 
          sound_impulse_start ('sound\dialog\mission\m30\m30_console_button_two_00102', NONE, 1);
          sleep (sound_impulse_time('sound\dialog\mission\m30\m30_console_button_two_00102'));	
	*/ 
/*          thread (story_blurb_add("vo", "MASTER CHIEF: I assume that wasn't you?"));			
          sleep_s (3.1);	
          thread (story_blurb_add("domain", "CORTANA: No, it wasn't."));
          sleep_s (3.1);
          						
          thread (story_blurb_add("domain", "CORTANA: : I suppose when an ancient alien planet invites you inside, it would be rude to say no."));					*/

end


script dormant M30_plylontwo_arrival()
	//triggers when the player arrives at Plyon 2 start.

	sleep_until (volume_test_players (M30_plylontwo_arrival), 1);
	
	//thread (pip_on());
	//Hud_play_pip("TEMP_PIP");
	
			wake(m30_objective_4);
			wake(f_dialog_m30_pylontwo_arrival);
			
 										
end


script dormant M30_plyontwo_drop_pods()
	//triggers when first drop pod land in exterior 2.  
	  			
	  			wake(f_dialog_m30_plyontwo_drop_pods);
    
end

script dormant m30_plyontwo_enemy()
	dprint("d");
	//wake(f_dialog_m30_plyontwo_enemy);
end




script dormant M30_start_ramp_enter()
	//triggers after the first drop pod event in exterior 2.
	sleep_until (volume_test_players (M30_start_ramp_enter), 1);	
				//	wake(f_dialog_m30_start_ramp_enter);
	 

end



script dormant M30_canyons_ramp_enter()
	//This fires when the player enters the ramp at end of canyons.

	sleep_until (volume_test_players (M30_canyons_ramp_enter), 1);
						
	wake(f_dialog_m30_pylontwo_transmission_one);
										
end



script dormant M30_pylontwo_hallway_1_enter()
	//triggers when the player enters hallway one (could be on ghost cannot use PIP)
	sleep_until (volume_test_players (M30_pylontwo_hallway_1_enter), 1);
			
							wake(f_dialog_m30_pylontwo_hallway);
				
end
		


script dormant M30_pylontwo_reveal()
	//fires when the player first sees pylon 2 while exiting hallway 1 (could be on ghost cannot use PIP)
	//sleep_until (volume_test_players (M30_pylontwo_reveal), 1);	
//	sleep_s(2);
//	wake(f_dialog_m30_pylontwo_reveal);
	kill_script(m30_objective_3_nudge);
	

end					


script dormant m30_pylontwo_banshees()
	//fires when the player first sees pylon 2 while exiting hallway 1 (could be on ghost cannot use PIP)
	//sleep_until (volume_test_players (M30_pylontwo_reveal), 1);	
	wake(f_dialog_m30_pylontwo_banshees);

end				


script dormant M30_pylontwo_core_one()
	//triggers when the first generator at Pylon two is destroyed.     
				wake(f_dialog_m30_pylontwo_core_one);	
				wake(m30_objective_4);

end

script dormant M30_pylontwo_core_two()
	//triggers when the second generator at Pylon two is destroyed.
				wake(f_dialog_m30_pylontwo_core_two);
          //	thread (story_blurb_add("domain", "CORTANA: Second power core offline."));
          	
/*          // Cortana : Second power core offline. Good job, Chief.
          dprint( "CORTANA: Second power core offline. Good job, Chief." ); 
          sound_impulse_start ('sound\dialog\mission\m30\m30_pylontwo_core_two_00100', NONE, 1);
          sleep (sound_impulse_time('sound\dialog\mission\m30\m30_pylontwo_core_two_00100'));*/

end

script dormant M30_pylontwo_core_three()
	//triggers when the third generator at Pylon two is destroyed. 
			wake(f_dialog_m30_pylontwo_core_three);    
			kill_script(m30_objective_4_nudge);
			wake (m30_objective_6);
			

end


script dormant M30_pylontwo_bridgetoelevator()

	sleep_until (volume_test_players (M30_pylontwo_bridgetoelevator), 1);
						
          //	thread (story_blurb_add("domain", "CORTANA: Same protocols as the other pylon. These shields probably run off power cores as well. We better find them."));
        	if (b_pylon_two_cores_down == FALSE) then
 
          dprint("Not dropped cores");
          else 
          dprint("Dropped all the cores");
					end
					dprint("Volume test complete.");
end					


script dormant M30_pylontwo_elevator_ride()
	//triggers when the elevator button to top of pylon two is activated.
	sleep_until (volume_test_players (M30_pylontwo_elevator_ride), 1);

	//Hud_play_pip("TEMP_PIP_DELRIO_STATIC");		
//		thread (pip_on());
			     wake(f_dialog_m30_pylontwo_elevator_ride);
	
end


script dormant m30_pylontwo_top_enter()

	
				dprint("D");
 
						
end	
	
script static void m30_pylontwo_top_alt()

	sleep_until (volume_test_players (m30_pylontwo_top_enter), 1);
				
          //	thread (story_blurb_add("domain", "CORTANA: Quick! Shut it down!"));
         // wake(f_dialog_m30_pylontwo_top_enter);

						
end	
	


script dormant M30_pylontwo_end()

					wake(f_dialog_m30_pylontwo_end);

end

script dormant M30_observatory_final()
	sleep_until (volume_test_players (M30_observatory) and (portal_count == 20), 1);
  
          //	thread (story_blurb_add("domain", "CORTANA: There's got to be some way to control the relay on the satellite! If I can tap into it, I can try to boost our transmission."));
          //	sleep_s (3.1);
          //	thread (story_blurb_add("vo", "MASTER CHIEF: The Covenant are moving their ships towards the satellite too."));
          //	sleep_s (3.1);
          //	thread (story_blurb_add("domain", "CORTANA: I don't understand! Why would they care about a broadcast relay?!? "));
          //	sleep_s (3.1);
          //	thread (story_blurb_add("vo", "MASTER CHIEF: I'll handle them; just find us that control node."));
 					wake (m30_objective_7);
 					wake (f_dialog_m30_observatory_final);

	
	b_final_time_through = TRUE; 

end

//script dormant M30_Console_Button_three()
//	//triggers when the player activates the button to open portal three.(center) 
//	    
////	thread (story_blurb_add("domain", "CORTANA: The Covenant are moving towards to the relay as well. Why?"));    
//end
      
script dormant m30_donut_enter()

	sleep_until (volume_test_players (m30_donut_enter), 1);
	
          //	thread (story_blurb_add("domain", "CORTANA: Chief, the Covenant are making a push for something on the far side of the satellite."));	
          //	sleep_s (5.1);
          //	thread (story_blurb_add("vo", "MASTER CHIEF: The relay controls?"));	
          //	sleep_s (2.1);
          //	thread (story_blurb_add("domain", "CORTANA: Way too coincidental to be anything else!"));	
    

          wake(f_dialog_m30_donut_enter);

end


script dormant m30_donut_infinity_broadcast()
	sleep_until ((volume_test_players (m30_donut_infinity_broadcast) or volume_test_players(m30_donut_infinity_broadcast_2)), 1);
		wake(f_dialog_m30_donut_infinity_broadcast);

end


script dormant m30_donut_signal_relay()
	sleep_until ((volume_test_players (m30_donut_signal_relay)), 1);
	sleep_until ((volume_test_players_lookat(m30_donut_signal_look, 25, 2.5)), 1);

		wake(f_dialog_m30_donut_signal_relay);

end


script dormant m30_cryptum_approach()

	sleep_until (
	
	ai_living_count (finaL_fore_1) <= 0 and
	ai_living_count (final_fore_2) <= 0 and
	ai_living_count (final_fore_3) <= 0 and
	ai_living_count (final_fore_4) <= 0 and
	ai_living_count (left_cov_final_fight) <= 0 and
	ai_living_count (right_cov_final_fight) <= 0 and
	volume_test_players (tv_cryptum_final_approach)
	
	, 1);
	
	//wake (M30_cryptum_open_trigger);
	wake(f_dialog_m30_cryptum_approach);
    
	
	
end

script dormant M30_cryptum_open_trigger()

	//triggers when the player pushes the button to open the cryptum.  
	//sleep_until (volume_test_players (M30_cryptum_open_trigger), 1);  
	//sleep_until (b_cryptum_cinematic_go == TRUE);
	kill_script(m30_objective_5_nudge);
	f_unblip_flag (cryptum_obj_flag);
	
	dprint( "Cinematic entered!" );
	
	f_start_mission ("cin_m031_didact");
	
	//cinematic_exit ("cin_m031_didact", TRUE);
	/*
	dprint ("is it fading?");
	
	sleep (5);
	
	dprint ("FADE THE FUCK OUT");
	
	fade_out (0, 0, 0, 1);
	
	sleep (90);
	
	dprint ("NOW YOU FUCKED UP");
	
	players_weapon_down( -1, 0.25, FALSE ); //this is here temporarily to fix an issue where weapons turn invisible after a cinematic - we're going to have to fix the global cinematic scripts to permanently fix the issue.

	sleep (30);
	*/
	
	// Cover the load here. We've done pretty much all we can for this one.
	EnableMidmissionLoadScreenForDVDOnly(true);
	switch_zone_set ("4_escape"); 
	
	b_escape_started = TRUE;	// sets the scripting up for escape
	
	sleep_until (current_zone_set_fully_active() == zs_escape_idx, 1);
	EnableMidmissionLoadScreenForDVDOnly(false);
	
	sleep (1);
				
	object_teleport (player0, flag_escape_a);
	object_teleport (player1, flag_escape_b);
	object_teleport (player2, flag_escape_c);
	object_teleport (player3, flag_escape_d);
	print ("TELEPORT TO ESCAPE!");
	//cinematic_exit ("cin_m031_didact", TRUE);
  				
end

script dormant M30_escape_open_vignette()
	//play opening vignette
	
	sleep_until (volume_test_players (m30_escape_open_vignette), 1);
	
	
	wake (chapter_four_display);

	

end


script dormant m30_escape_volume_01()

	sleep_until (volume_test_players (m30_escape_volume_01), 1);
	
          //	thread (story_blurb_add("domain", "CORTANA: Grab one of those Ghosts! We have to find a portal out of here before the whole network shuts down."));
          //	sleep_s (10.1);
          //	thread (story_blurb_add("domain", "CORTANA: Hang on. I'm going to channel energy from your shields to overdrive the Ghost's boost."));	
          //	sleep_s (5.1);	
          //	thread (story_blurb_add("domain", "CORTANA: Done! Now floor it! And whatever you do, don't let up on the gas!"));	
 
				wake(f_dialog_m30_escape_volume_01_a);
          
	sleep_until (unit_in_vehicle_type (player0, 26), 1);
          
				wake(f_dialog_m30_escape_volume_01_b);
			
				
end


script dormant m30_escape_destruction_01()
	//triggers when the level first begins falling apart. 
	    print("d");
	//thread (story_blurb_add("domain", "CORTANA: AND the planet is falling apart.  Great."));
//	sleep_s (5.1);
	//thread (story_blurb_add("domain", "CORTANA: You'd better step on it Chief!"));

end

script static void use_boost_VO_prompt (player p_player)
	repeat
  	sleep_until (unit_in_vehicle_type (p_player, 26), 1);

    unit_action_test_reset (p_player);
                
    if (unit_action_test_grenade_trigger (p_player)) then
    sleep (30 * 3);
    
    else
    thread(story_blurb_add("domain", "CORTANA: You'd better step on it Chief!"));
		sleep (1);
  
  	end

  until (b_escape_over == TRUE);

end

/*

script dormant m30_escape_destruction_02()
    sleep_until (volume_test_players (m30_escape_destruction_02), 1);
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_destruction_02);

	else
		// nothing happens
		sleep(1);
		
	end
	
end*/

script dormant m30_escape_destruction_03()
	//Cortana comments about the walls closing in on you
	//thread (story_blurb_add("domain", "CORTANA: Whoooaa.  This is gonna be tight!"));
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_03a);

	else
		// nothing happens
		sleep(1);
		
	end
	
end

script dormant m30_escape_volume_02()
	//Cortana shouts at player to get moving
	sleep_until (volume_test_players (m30_escape_volume_02), 1);
	
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_02);

	else
		// nothing happens
		sleep(1);
		
	end
				
end

script dormant m30_escape_volume_04()
	
	sleep_until (volume_test_players (m30_escape_volume_04), 1);
	
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_04);

	else
		// nothing happens
		sleep(1);
		
	end
	
	
end



script dormant m30_escape_volume_05()
	//Cortana: I have to admit, I didn't quite think we were going to make that one.
	sleep_until (volume_test_players (m30_escape_volume_05), 1);
	
	
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_destruction_02);

	else
		// nothing happens
		sleep(1);
		
	end
 
	
end

script dormant m30_escape_volume_06()
	//Cortana: If I had a grandmother, I’m sure she would drive faster than this!
	sleep_until (volume_test_players (m30_escape_volume_06), 1);
	
	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_06);

	else
		// nothing happens
		sleep(1);
		
	end
 
	
end


script dormant m30_escape_volume_07()
	//Cortana: I don't have to pull up the schematics on this thing to know can go faster than this! Now, push it!
	sleep_until (volume_test_players (m30_escape_volume_07), 1);
	print("d");

	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_07);

	else
		// nothing happens
		sleep(1);
		
	end
	
end


script dormant m30_escape_volume_08()
	//Cortana: This is going to be tight!
	sleep_until (volume_test_players (m30_escape_volume_08), 1);

	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_08);

	else
		// nothing happens
		sleep(1);
		
	end
 
	
end


script dormant m30_leave_ghost()

     wake(f_dialog_m30_leave_ghost);

end

script dormant m30_escape_volume_09()
	//Cortana: This is going to be tight!
	sleep_until (volume_test_players (m30_escape_volume_09), 1);

	if (unit_in_vehicle_type(player0, 26) == TRUE) then
	  
			wake(f_dialog_m30_escape_volume_04);

	else
		// nothing happens
		sleep(1);
		
	end
 
	
end

script dormant m30_escape_volume_03()
	//Cortana's last "come on, lets' go!"
	sleep_until (volume_test_players (m30_escape_volume_03), 1);

	wake(f_dialog_m30_escape_volume_03);
	
end

script dormant m30_escape_preportal_01()

sleep_until (volume_test_players ( m30_escape_preportal_01), 1);


					wake(f_dialog_m30_pre_portal_01);		
end	

script dormant m30_escape_preportal_02()

sleep_until (volume_test_players (m30_escape_preportal_02), 1);


					wake(f_dialog_m30_pre_portal_02);		
end	



script dormant M30_escape_volume_end()
	
	dprint("TRIGGER HIT - ESCAPE IS OVER");

	b_escape_over = TRUE;

	if object_get_health (player0) <= 0 then
		game_safe_to_respawn (TRUE, player0);
		fade_in_for_player (player0);
	end
	
	if object_get_health (player1) <= 0 then
		game_safe_to_respawn (TRUE, player1);
		fade_in_for_player (player1);
	end
	
	if object_get_health (player2) <= 0 then
		game_safe_to_respawn (TRUE, player2);
		fade_in_for_player (player2);
	end
	
	if object_get_health (player3) <= 0 then
		game_safe_to_respawn (TRUE, player3);
		fade_in_for_player (player3);
	end

	cinematic_show_letterbox (TRUE);
	cinematic_enter ("cin_m032_end", TRUE);
	
	switch_zone_set ("cin_m032_end");
	
	sleep_until (current_zone_set_fully_active() == zs_cin_m32_idx, 1);
	
	f_start_mission ("cin_m032_end");
	
	cinematic_exit_no_fade ("cin_m032_end", TRUE);

	game_won();
	
end



// =================================================================================================
// =================================================================================================
// OBJECTIVES
// =================================================================================================
// ===================================

script dormant m30_objective_1()

	objectives_show (0); 

	dprint ("objective: PROCEED TO THE FIRST PYLON");
	cui_hud_set_new_objective ("m30_objective_1");
	
 	thread(m30_objective_1_nudge());
	
end


script dormant m30_objective_2()

	cui_hud_set_objective_complete ("m30_objective_1");

	dprint ("objective: DESTROY THE POWER CORES");
	cui_hud_set_new_objective ("m30_objective_2");
	
	thread(m30_objective_2_nudge());
	
end


script dormant m30_objective_3()
	
	cui_hud_set_objective_complete ("m30_objective_2");
	
	dprint ("objective: SHUT DOWN THE FIRST BEAM ARRAY");
 	cui_hud_set_new_objective ("m30_objective_3");

end


script dormant m30_objective_4()
	
	objectives_finish (0); 

	objectives_show (1);
	 
	cui_hud_set_objective_complete ("m30_objective_3");
	
	dprint ("objective: PROCEED TO THE SECOND PYLON");
 	cui_hud_set_new_objective ("m30_objective_4");
 	
 	

end


script dormant m30_objective_5()
	
	cui_hud_set_objective_complete ("m30_objective_4");
	
	dprint ("objective: DESTROY THE POWER CORES");
 	cui_hud_set_new_objective ("m30_objective_5");
 	
 	thread(m30_objective_4_nudge());

end

script dormant m30_objective_6()
	
	cui_hud_set_objective_complete ("m30_objective_5");
	
	dprint ("objective: SHUT DOWN THE SECOND BEAM ARRAY");
 	cui_hud_set_new_objective ("m30_objective_6");

end

script dormant m30_objective_7()
	
	objectives_finish (1);
	
	objectives_show (2);
	
	cui_hud_set_objective_complete ("m30_objective_6");
	
	dprint ("objective: REACH THE RELAY CONTROLS");
 	cui_hud_set_new_objective ("m30_objective_7");

end

script dormant m30_objective_8()
	
	objectives_finish (2);
	
	objectives_show (3);
	
	cui_hud_set_objective_complete ("m30_objective_7");
	
	dprint ("objective: ESCAPE!");
 	cui_hud_set_new_objective ("m30_objective_8");

end

// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================



script static void m30_objective_1_nudge()
			dprint("Nudge fired");
			sleep_s(600);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m30_objective_1());
			end
			
			thread(m30_objective_1_nudge());
end

script static void m30_objective_2_nudge()
			
			sleep_s(900);
			if b_objective_2_complete == FALSE then
						thread(f_dialog_m30_objective_2());
			end
			if b_objective_2_complete == FALSE then
					thread(m30_objective_2_nudge());
			end
end

script static void m30_objective_3_nudge()
			
			sleep_s(900);
			if b_objective_3_complete == FALSE then
						thread(f_dialog_m30_objective_3());
			end
			if b_objective_3_complete == FALSE then
					thread(m30_objective_3_nudge());
			end
end


script static void m30_objective_4_nudge()
			
			sleep_s(900);
			if b_objective_4_complete == FALSE then
						thread(f_dialog_m30_objective_4());
			end
			if b_objective_4_complete == FALSE then
					thread(m30_objective_4_nudge());
			end
end

script static void m30_objective_5_nudge()
			
			sleep_s(900);
			if b_objective_5_complete == FALSE then
						thread(f_dialog_m30_objective_5());
			end
				if b_objective_5_complete == FALSE then
					thread(m30_objective_5_nudge());
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