
// =================================================================================================
// =================================================================================================
// NARRATIVE SCRIPTING M40
// =================================================================================================
// =================================================================================================b
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================

		global boolean b_leave_without_cortana_1 = FALSE;
		global boolean b_leave_without_cortana_2 = FALSE;
		global boolean b_cortana_retrieved = FALSE;
		global boolean b_mammoth_entered = FALSE;
		global boolean b_objective_1_complete = FALSE;
		global boolean b_objective_2_complete = FALSE;
		global boolean b_objective_3_complete = FALSE;
		global boolean b_objective_4_complete = FALSE;
		global boolean b_objective_5_complete = FALSE;
		global boolean b_objective_6_complete = FALSE;
		global boolean b_objective_7_complete = FALSE;
		global boolean b_objective_8_complete = FALSE;
		global boolean b_objective_9_complete = FALSE;		
		global boolean b_objective_10_complete = FALSE;
		global boolean b_objective_11_complete = FALSE;
		global boolean b_objective_12_complete = FALSE;
		global boolean b_objective_13_complete = FALSE;
		global boolean b_objective_14_complete = FALSE;
		global boolean b_objective_15_complete = FALSE;
		global boolean b_mammoth_going = FALSE;
		global boolean b_door_locked = FALSE; 
		global boolean b_start_white_rabbit = FALSE; 
		global boolean b_gun_in_mammoth = FALSE;
		global boolean b_warthog_gun_in_mammoth = FALSE;
		global boolean m40_map_area_01 = FALSE;
		global boolean m40_map_area_02 = FALSE;
		global boolean m40_map_area_03 = FALSE;
		global boolean m40_map_area_04 = FALSE;
		global boolean m40_map_area_05 = FALSE;
		global boolean b_rail_gun_available = FALSE;
		global boolean b_rail_gun_ready = FALSE;
		global boolean b_rail_gun_reloading = FALSE;
		global boolean b_target_destroyed = FALSE;
		global boolean b_no_line_of_sight = FALSE;
		global boolean b_target_acquired = FALSE;	
		global boolean b_target_missed = FALSE;	
		global boolean cortana_inserted = FALSE;
		global boolean rampancy_pip_over = FALSE;
		global long L_dlg_marine_sniper_line_01 = 							DEF_DIALOG_ID_NONE();
		global long L_dlg_marine_sniper_line_02 = 							DEF_DIALOG_ID_NONE();
		global long L_dlg_marine_sniper_line_03 = 							DEF_DIALOG_ID_NONE();	
		global short mammoth_button_4_short = 0;
		global boolean b_plinth_line_active = FALSE;
		
///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M40_narrative_main()

	print ("::: M40 Narrative Start :::");

	thread( m40_caves_vo_marines() );
	//wake (m40_waterfalls_rampancy_start);
	wake (M40_cit_door_airlock);
	wake (m40_cortana_grotto_door);
	thread (m40_cortana_in_librarian());
	thread (m40_landing_in_battle());
	thread (m40_cortana_citadel_rampancy());
	wake(m40_marine_nudge_outer);
	//wake(m40_sniper_in_the_rocks);
	wake(m40_epic_palmer_order);
	wake(m40_missile_hologram);
	thread(m40_leave_without_cortana());
	wake(m40_second_cannon_approach);
	wake( M40_get_sniper_rifle);
 	wake(m40_lasky_radio_contact);
// 	wake(m40_post_stream);
 	wake( m40_cortana_battery_console);
 	wake(m40_cannon_reveal);
 	thread(m40_marine_rescue());
 	wake(m40_waypoint_terminal);
 	thread(m40_shoot_gun_in_mammoth());
 	thread(m40_warthog_gun());
 	wake(m40_cortana_shield_ahead);
 	thread(f_dialog_m40_target_destroyed());
 	thread(f_dialog_m40_rail_gun_reloading());
 	thread(f_dialog_m40_rail_gun_ready());
 	thread(f_dialog_m40_rail_gun_available());
 	thread(f_dialog_m40_no_line_of_sight());
 	thread(f_dialog_m40_target_acquired());
 	thread(f_dialog_m40_target_missed());

 	
end

script dormant m40_lasky_radio_contact()
     	sleep_until( volume_test_players(tv_cav_player_moves_up), 1);
			
			wake(f_dialog_m40_lasky_radio_contact);

end

global real R_mammoth_conversation_trigger_see_dist = 	7.5;
global real R_mammoth_narrative_conversation_trigger_near_dist = 5.0;

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
		( r_obj_sees_player_angle > 0.0 )
		and
		(
			objects_can_see_object( obj_character, player0, r_obj_sees_player_angle )
			or
			objects_can_see_object( obj_character, player1, r_obj_sees_player_angle )
			or
			objects_can_see_object( obj_character, player2, r_obj_sees_player_angle )
			or
			objects_can_see_object( obj_character, player3, r_obj_sees_player_angle )
		)
	);

end

script static void m40_caves_vo_marines( )
/*  static boolean b_triggered = FALSE;

	// wait for the character to be valid
	sleep_until( ai_living_count(ai_character) > 0, 1 );
 
	// wait for player to be w/i distance
	sleep_until( b_triggered or (ai_living_count(ai_character) <= 0) or f_narrative_distance_trigger(ai_get_object(ai_character), R_mammoth_conversation_trigger_see_dist, R_mammoth_narrative_conversation_trigger_near_dist, 0.0), 1 );

	// trigger the dialog
	if ( (not b_triggered) and (ai_living_count(ai_character) > 0) and (not ai_allegiance_broken(player, human)) ) then
		b_triggered = TRUE;
		dprint("MARINE VO SHOULD HAVE TRIGGERED");
		thread( f_dialog_m40_landing_marine_chatter());
	end	*/
	sleep_until( volume_test_players(m40_caves_vo_marines), 1);

  m40_map_area_01 = TRUE;
      
end


//triggers at the beginning of the cave section.
/*
script dormant m40_cortana_hall()
			sleep_until( volume_test_players(m40_cortana_hall), 1);
			//wake(f_dialog_m40_cortana_hall);
			//thread (story_blurb_add("domain", "RAMPANCY FX"));
end*/


//triggers at the end of the cave section.

script static void M40_cave_VO_mammoth_reveal()
     	sleep_until( volume_test_players(M40_cave_VO_mammoth_reveal), 1);
     	wake(f_dialog_m40_cortana_mammoth);
      	thread (tort_button_01());
				thread (tort_button_02());
				thread (tort_button_03());
				thread (tort_button_04());
				device_set_power (tortoise_device_button_05, 0);
		    // thread (cortana_hud_rampancy_loop_begin("noise",.001, 1));
      
      
end

script dormant m40_marine_nudge_outer()
     	sleep_until((volume_test_players(marine_nudge_outer) or volume_test_players(marine_nudge_outer_02)), 1);
     	if b_mammoth_entered == FALSE then
      	wake(f_dialog_m40_marine_nudge_outer);
     end
end


script dormant M40_tortoise_enter_first_time()
    	b_mammoth_entered = TRUE;
		//	wake(f_dialog_m40_marine_nudge_inner);
	
end


static short gun_in_mammoth_state = 0;
	
script static void m40_shoot_gun_in_mammoth()
		sleep_until( b_gun_in_mammoth == TRUE );	
		dprint("GUN IN MAMMOTH 1");
		gun_in_mammoth_state = gun_in_mammoth_state + 1;
		thread (f_dialog_m40_gun_in_mammoth( gun_in_mammoth_state ));
		b_gun_in_mammoth = FALSE;
		thread(m40_shoot_gun_in_mammoth());
	
end


script dormant m40_gun_in_mammoth()
 	dprint("deprecated");
end


script dormant M40_marine_warthog()

			wake(f_dialog_m40_marine_warthog);

end

static short marine_warthog_gun_state = 0;
	
script static void m40_warthog_gun()
		sleep_until( b_warthog_gun_in_mammoth == TRUE);
		dprint("WARTHOG GUN IN MAMMOTH 1");
		marine_warthog_gun_state = marine_warthog_gun_state + 1;
		thread(f_dialog_m40_marine_warthog_gun( marine_warthog_gun_state ));
		b_warthog_gun_in_mammoth = FALSE;
		thread(m40_warthog_gun());
	
end

script dormant m40_marine_warthog_gun()
 	dprint("deprecated");
end

script dormant m40_target_designator_callout()
     sleep_until( volume_test_players(m40_target_designator_callout), 1);


end





/*
script dormant m40_jetpack_callout()
     sleep_until( volume_test_players(m40_jetpack_callout), 1);
			wake(f_dialog_m40_jetpack_callout);

end*/

//triggers when the player enters the MAMMOTH near PALMER and LASKY.

script static void m40_caves_tort_meet_palmer()
//     	sleep_until( volume_test_players(lasky_vignette_dialogue), 1);
			sleep_until (palmer_vignette == true);
		//	wake(f_dialog_m40_lasky_vignette);
						wake(f_dialog_m40_jetpack_callout);


end

script static void tort_button_01()
                sleep_until (device_get_position(tortoise_device_button_01) != 0);
                object_destroy (tortoise_device_button_01);

                	thread(f_dialog_m40_mammoth_button_1());
end

script static void tort_button_02()
                sleep_until (device_get_position(tortoise_device_button_02) != 0);
                object_destroy (tortoise_device_button_02);
                
                	thread(f_dialog_m40_mammoth_button_2());
end

script static void tort_button_03()
                sleep_until (device_get_position(tortoise_device_button_03) != 0);
                object_destroy (tortoise_device_button_03);
                	thread(f_dialog_m40_mammoth_button_3());
end

script static void tort_button_04()
                sleep_until (device_get_position(tortoise_device_button_04) != 0);
                object_destroy (tortoise_device_button_04);
                mammoth_button_4_short = mammoth_button_4_short + 1;
                
                	thread(f_dialog_m40_mammoth_button_4(mammoth_button_4_short));
end

/*
script static void tort_button_05()
                sleep_until (device_get_position(tortoise_device_button_05) != 0);
                device_set_power (tortoise_device_button_05, 0);
                thread(f_dialog_m40_mammoth_button_5());
end*/

// triggers when the player pass a group of marines in the cave.
// removing for UR4 because it stomps on m40_caves_vo_marines (- jacob)

//script static void m40_caves_marines_bark()
//     	sleep_until( volume_test_players(m40_caves_VO_marines_bark), 1);
//     
//			thread (story_blurb_add("vo", "MARINES: Good to have you with us chief."));
//      
//      sleep_s (10);
//end

// triggers after the MAMMOTH breaks out of the caves section.

script static void m40_caves_tort_VO_delrio_radio()
     	sleep_until( volume_test_players(m40_caves_tort_VO_delrio_radio), 1);
  		

/*			thread (story_blurb_add("vo", "DEL RIO (RADIO): starts the mission. reminds player they need to take out the AA guns so INFINITY can knock out the tractor beam."));
      
      sleep_s (5.5);
      
      thread (story_blurb_add("vo", "DEL RIO (RADIO): Their success is critical to escaping requiem. "));
      
      sleep_s (5.5);
      
      thread (story_blurb_add("vo", "LASKY: rallies the troops. They won't let the mission fail. "));
      
      sleep_s (5.5);*/

		dprint("d");
end

// VO triggers when the MAMMOTH sequence is activated.

script dormant m40_caves_tort_VO_breakout()
     
				//	thread (story_blurb_add("other", "LASTKY DEMONSTRATES THE TARGET DESIGNATOR AND CLEARS OUT THE TOP OF THE ROCK SLIDE WITH IT."));
      
      sleep_s (5);
     
end

//VO triggers when the Mammoth sequence is activated.

script dormant M40_cave_tort_rockslide()
     
					thread (story_blurb_add("other", "LASTKY DEMONSTRATES THE TARGET DESIGNATOR AND CLEARS OUT THE TOP OF THE ROCK SLIDE WITH IT."));

      
     
end

//need to trigger when the pelican sequence starts.

script dormant M40_gun_fodder_pelican_down()
						
  					wake(f_dialog_m40_pelican_vignette);

    

end

script dormant m40_cannon_reveal()
  sleep_until( volume_test_players(m40_cannon_reveal), 1);
	//wake(f_dialog_m40_cannon_reveal);
end



script dormant m40_cannon_fodder()
  
	wake(f_dialog_M40_cannon_fodder);
end



script dormant M40_mammoth_in_range()
  
	wake(f_dialog_M40_mammoth_in_range);
	//thread(m40_warthog_forget());
	wake(m40_del_rio_ping);
	m40_map_area_01 = FALSE;
	m40_map_area_02 = TRUE;
	
end




script dormant m40_del_rio_ping()
      	sleep_until( volume_test_players(m40_del_rio_ping), 1);
     		//	wake(f_dialog_m40_del_rio_ping);
end


 


// first blockade - Triggers when the covenant armor is visable.

script dormant M40_fodder_armor_appear()
    
    dprint("d"); 
		//wake(f_dialog_m40_first_encounter);					
			

//restructured this line for UR, removed this part: LASKY: orders chief to take it out. (- jacob)

end

/*//Initiates near the tar lake
script static void M40_lake_reaction()
      	sleep_until( volume_test_players(M40_lake_reaction), 1);
    		sleep_until ((volume_test_players_lookat(lake_facing_volume, 25, 2.5)), 1);
 			//wake(f_dialog_M40_lake_reaction);
      
end*/




//Initiates if player enters the lakeside combat without a warthog
script static void m40_warthog_forget()
   sleep_until( volume_test_players(m40_warthog_forget), 1);
    	
 		//	wake(f_dialog_m40_warthog_forget);
      
end


script static void m40_marine_rescue()
sleep_until( volume_test_players(m40_marine_rescue), 1);

		if
		ai_living_count (pelican_marines) > 0
		and
		(volume_test_object (m40_marine_rescue, pelican_marines.guy1)
		or
		volume_test_object (m40_marine_rescue, pelican_marines.guy3)
		or
		volume_test_object (m40_marine_rescue, pelican_marines.guy4)
		or
		volume_test_object (m40_marine_rescue, pelican_marines.guy5))
		then 
			wake(f_dialog_m40_marine_rescue);
		else
			print ("Pelican Marines are dead, VO not playing");
		end
		
end



// first blockade - Triggers when the drop ship is visable.

script dormant M40_fodder_dropship_appear()
     				wake(f_dialog_m40_fodder_dropship_appear);
						
      


end

// first blockade - Triggers when a few enemies are left.

script dormant M40_fodder_cleanup()
     
						thread (story_blurb_add("other", "LASKY ORDERS THAT THE LAST OF THE ENEMIES BE CLEANED UP."));
      


end

//first blockade - Triggers once Enemy forces are eliminated. PALMER readies the rail gun. LASKY orders chief to mount the gauss gun and blow the AA gun out of the sky!

script dormant M40_fodder_railgun_ready()
     				
					
						
						wake(f_dialog_m40_tutorial_1);

end

script dormant M40_lakeside_tort_assault_dialogue()
      wake(f_dialog_M40_lakeside_tort_assault_dialogue);
			


end

//first area - triggers once the player activates thr RAIL GUN. 

script dormant M40_fodder_railgun_charge()
     
			thread (story_blurb_add("other", "THE RAIL GUN BEGINS TO PRIME."));
     
      


end

script dormant M40_lakeside_vehicles_deploy()
     
     
	//		thread (story_blurb_add("other", "WARTHOGS ARE DEPLOYED FOR CHIEF TO USE."));

		thread(f_dialog_M40_mammoth_in_range_02());
      
end


script dormant M40_fodder_railgun_automated()
     
			
			wake(f_dialog_m40_tutorial_2);
      

  
  
end


script dormant M40_fodder_railgun_automated_2()
     
     wake(f_dialog_m40_tutorial_3);

end


script dormant m40_second_cannon_approach()
		sleep_until( volume_test_players(m40_second_cannon_approach), 1);
		dprint("chopper line hit");
		if chopper_cannon_alive == TRUE then
		dprint("chopper line triggered");
			wake(f_dialog_m40_second_cannon_approach);
		end
	m40_map_area_03 = FALSE;
	m40_map_area_04 = TRUE;
end




script dormant M40_lakeside_prep_rollout()
     
      wake(f_dialog_m40_rollout);
			//thread (story_blurb_add("other", "MAMMOTH IS USED AS A BRIDGE ACROSS THE TAR.")); 
      sleep_s (5);
      


end

script dormant m40_post_stream()
	sleep_until( volume_test_players(m40_post_stream), 1);
		wake(f_dialog_m40_post_stream);
			m40_map_area_02 = FALSE;
			m40_map_area_03 = TRUE;
end

script dormant M40_lakeside_rollout()
     
//			thread (story_blurb_add("vo", "PALMER: We're bringing the Tortoise up to form a bridge across the lake."));
      dprint("d");
     
//     	thread (story_blurb_add("vo", "PALMER: Grab a vehicle or stay on the Tortoise, Chief.."));
//      
//      sleep_s (5);

end

script dormant m40_pre_chopper_01()
     dprint("d");

     // wake(f_dialog_m40_pre_chopper_01);

      
end


script dormant m40_prechopper_waiting()
     
dprint("d");
    //  wake(f_dialog_m40_prechopper_waiting);

      
end

script dormant m40_prechopper_done()
     

      wake(f_dialog_m40_prechopper_done);

      
end



//Blockade area - varous other warning warning for the MAC gun???



//Mammoth Bridge - As the chief uses the mammoth as a bridge the electronics on the interior sputter and flicker. Cortana and chief recognize this from earlier levels, but with the didact out who could it be?

// /chopper Bowl - triggers when the player enters the chopper bowl. Laskey should radio to the player that a large unidentified Covenant vehicle is nearby.

//The rail gun takes out the second cannon

script dormant M40_second_cannon_fire_one()
     
		
      wake(f_dialog_m40_second_cannon_fire_one);
      sleep_s (5);

end




script dormant M40_chopper_Rail_gun()
     
		
      wake(f_dialog_m40_second_cannon_fire_two);
      sleep_s (5);

end




script dormant M40_lakeside_all_clear()
     
		
      wake(f_dialog_M40_lakeside_all_clear);

end


script static void M40_chopper_lich_warning()
     

      wake(f_dialog_m40_pre_chopper_01);

      
end

//chopper Bowl - triggers when the lich is revealed.

     
script dormant M40_chopper_lich_reveal()
      wake(f_dialog_m40_lich_plan);
     
end

script dormant m40_broken_gun()

		wake(f_dialog_m40_broken_gun);
end

//Chopper Bowl - Triggers when Covenant board the MAMMOTH.

script dormant M40_chopper_mammoth_boarding()
     	wake(f_dialog_m40_lich_pass);

end

//Chopper Bowl - Triggers when Covenant baording party is cleared from MAMMOTH.

script dormant M40_chopper_mammoth_boarding_done()
     
//			thread (story_blurb_add("vo", "Nice work, Master Chief. Come to the Mammoth to get a JETPACK"));
//      
//      sleep_s (5);
      
			cinematic_set_title (chapter_07);
      
end
      
//Chopper Bowl - triggers when the lich moves into position over the central mound.

script dormant M40_chopper_lich_over_mound()
     
     wake(f_dialog_m40_lich_stops);
     
			
      
end


script dormant m40_lich_boarding()
     
     wake(f_dialog_m40_lich_boarding);


end



script dormant m40_lich_head_out()
     
     wake(f_dialog_m40_lich_head_out);


end


script dormant m40_lich_going_to_blow ()
	dprint("D");     
//     wake(f_dialog_m40_lich_going_to_blow);


end


script dormant M40_chopper_go_to_citadel()
			
			sleep_s(3);
     
     wake(f_dialog_m40_descent_on_mesa);
			//thread (story_blurb_add("other", "DEL RIO REITERATES THAT WE ARE HEADED FOR THE CENTRAL CANNON CONTROLS IN THE CITADEL."));
      
     

end

script dormant m40_chopper_cleared()

     //wake(f_dialog_m40_chopper_cleared);
				m40_map_area_04 = FALSE;
	m40_map_area_05 = TRUE;
      
     

end



script dormant m40_boarding_party()

					wake(f_dialog_m40_boarding_party);
					
end


script dormant m40_waterfalls_rampancy_start()
					sleep_until( volume_test_players(m40_waterfalls_rampancy), 1);
					wake(f_dialog_m40_canyon_rampancy);
				
end

script dormant M40_waterfalls_warning()
//Mammoth pauses at tar stream to load up

     	sleep_until( volume_test_players(tv_waterfall_02), 1);
			wake(f_dialog_m40_stream_crossing);
			
      

end

script dormant M40_waterfalls_ready()
//Mammoth is filled and ready to go

			wake(f_dialog_m40_stream_crossing_2);



end



script dormant M40_citadel_investigate()
			sleep_until( rampancy_pip_over == TRUE);
     	sleep_until( volume_test_players(M40_citadel_investigate), 1);
     	wake(f_dialog_m40_citadel_investigate);

end



script dormant m40_sniper_shot()

	wake(f_dialog_m40_sniper_shot);
	
end

script dormant M40_get_sniper_rifle()
     	sleep_until( volume_test_players(m40_sniper_rifle), 1);
     	dprint("sniper volume fired");
		  // if not (unit_has_weapon (player0, objects\weapons\rifle\storm_sniper_rifle\storm_sniper_rifle.weapon)) then
			//	dprint("no gun");
					//wake(f_dialog_m40_get_sniper_rifle);
		//	end	
end

/*script dormant m40_sniper_in_the_rocks()

     	sleep_until( volume_test_players(tv_careful_chief), 1);

		wake(f_dialog_m40_sniper_in_the_rocks);

end
*/


script static void M40_covenant_and_promethean()
static boolean b_triggered = FALSE;
			
			if ( not b_triggered ) then
				b_triggered = TRUE;
				
				// delay
				sleep_s( 0.25 );
				
      	wake(f_dialog_m40_covenant_and_promethean);
			end
      

end


script dormant m40_a_team()
		sleep_until( volume_test_players(forerunner_installation), 1);
			dprint("d");
      	//wake(f_dialog_m40_a_team);

      

end


script dormant M40_second_promethean_encounter()

			//thread (story_blurb_add("other", "CORTANA POINTS OUT HOW THE PROMETHEANS REALLY DON'T WANT THEM INSIDE."));
		dprint("d");

end




script dormant M40_cit_door_airlock()
	sleep_until (volume_test_players(tv_citadel_ext_airlock_area), 1);	
			wake(f_dialog_m40_cit_door_airlock);
			//thread (story_blurb_add("other", "CHIEF AND CORTANA SUCCESSFULLY BREACH THE FACILITY."));
		
				
end


script dormant m40_cortana_confusion_citadel()
	sleep_until( dm_citadel_int_lobby_door_02->check_close(), 1);	
	
//			thread (story_blurb_add("other", "A SENTINEL CLOSES THE DOOR."));
      
   //   wake(f_dialog_m40_confusion_citadel);

end


script dormant m40_cortana_sentinel_confusion()

			thread (story_blurb_add("other", "A SENTINEL MYSTERIOUSLY OPENS THE DOOR FOR CHIEF AND CORTANA."));
      
      sleep_s (10);

end



script dormant m40_cortana_elevator_confusion()
				
			
      wake(f_dialog_m40_cortana_elevator_confusion);
     // thread(m40_sentinel_color());
      //thread(m40_sentinel_color_2());
      

end



/*script static void m40_sentinel_color()
    sleep_until( player_action_test_primary_trigger() == TRUE, 1);
    sleep_until( volume_test_players(lower_hall_enter), 1);
      wake(f_dialog_m40_sentinel_color);
			kill_script(m40_sentinel_color_2);
      

end

script static void m40_sentinel_color_2()
	sleep_until( volume_test_players(lower_hall_enter), 1);
      wake(f_dialog_m40_sentinel_color_2);
      kill_script(m40_sentinel_color);

end*/




script static void m40_cortana_citadel_rampancy()
			sleep_until( volume_test_players(tv_pc_hallway_ambient), 1);
			
      
      sleep_s (15);

end

script dormant m40_cortana_confusion_powercave_room()

     	sleep_until( volume_test_players(cortana_confusion_powercave_room), 1);
			wake(f_dialog_m40_battery_reveal);
		 ai_place (battery_sentinel);	
		 
   

end


script dormant m40_waypoint_terminal()
	//fires when you click the terminal in vale
	/*
	sleep_until (object_valid (vale_terminal_button), 1);
	sleep_until (device_get_position(vale_terminal_button) > 0.0, 1 );
	device_set_power (vale_terminal_button, 0.0);
			if (IsNarrativeFlagSetOnAnyPlayer(0) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(1) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(2) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(3) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(4) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(5) == FALSE) and (IsNarrativeFlagSetOnAnyPlayer(6) == FALSE)then
				wake(f_dialog_global_my_first_domain); 
			end
		SetNarrativeFlagWithFanfareMessageForAllPlayers( 3, TRUE );
	*/
	f_narrative_domain_terminal_setup( 3, domain_terminal, domain_terminal_button );
end

script dormant m40_cortana_battery_console()

     	sleep_until( volume_test_players(m40_cortana_battery_console), 1);
			thread(f_dialog_m40_battery_console());
			
   

end



script dormant m40_missile_hologram()

	sleep_until (object_valid (bt_powercave_battery_button), 1);
	sleep_until (device_get_position(bt_powercave_battery_button) > 0.0, 1 );
	cortana_inserted = TRUE;
	sleep_forever(f_dialog_m40_battery_console);
	
	
end



script dormant m40_cortana_powercave_plinth_dialogue()
			
			
			
      wake(f_dialog_m40_cortana_powercave_plinth_dialogue);


end

script dormant m40_cortana_powercave_plinth_trouble()

			//thread (story_blurb_add("other", "CORTANA IS SUCKED INTO THE SYSTEM, VANISHING."));
			wake(m40_sentinel_carrot);

 end
      
      
 script dormant m40_sentinel_carrot()  
    sleep_until( volume_test_players(tv_powercave_center), 1);
		//	thread (story_blurb_add("other", "A SENTINEL TRIGGERS A LIGHT BRIDGE AND THEN FLIES THROUGH A NEARBY DOOR."));
       b_start_white_rabbit = TRUE;
       	ai_erase (sg_citadel_int_sentinels);
       	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_BATTERY_CAVERN(), 1 );
        ai_place (cavern_sentinels);
        sleep(15);
        ai_place (cavern_sentinels_2);		
        ai_place (monitor_kip);
       
end


script dormant m40_cortana_grotto_door()
     	sleep_until( volume_test_players(tv_grotto_open_door), 1);
		//	thread (story_blurb_add("other", "NUMEROUS SENTINELS FLY IN AND OUT THROUGH THE MASSIVE DOOR."));

end



script static void m40_leave_without_cortana()
		     sleep_until( volume_test_players(leave_without_cortana), 1);
		     
		      if (b_leave_without_cortana_1 == TRUE) and (b_leave_without_cortana_2 ==TRUE) and (b_cortana_retrieved == FALSE) then
			    	wake(f_dialog_m40_leave_without_cortana_3);
			    	b_leave_without_cortana_1 = FALSE;		
						b_leave_without_cortana_2 = FALSE;		 
		     elseif (b_leave_without_cortana_1 == TRUE) and (b_leave_without_cortana_2 == FALSE) and (b_cortana_retrieved == FALSE) then
		    		wake(f_dialog_m40_leave_without_cortana_2);
		    		b_leave_without_cortana_2 = TRUE;		     
			  elseif (b_leave_without_cortana_1 == FALSE) and (b_leave_without_cortana_2 == FALSE) and (b_cortana_retrieved == FALSE) then
		    		wake(f_dialog_m40_leave_without_cortana_1);
		    		b_leave_without_cortana_1 = TRUE;
				end
			sleep_s(10);
			thread(m40_leave_without_cortana());
end


script static void m40_cortana_in_librarian()
	sleep_until (volume_test_players (m40_cortana_in_librarian), 1);	
    wake(f_dialog_m40_cortana_to_chief);
   	//	wake(f_dialog_m40_librarian_to_chief);

end




script dormant m40_cortana_shield_ahead()
	sleep_until (volume_test_players (cortana_shield_ahead), 1);	
    
   		wake(f_dialog_m40_cortana_shield_ahead);

end



script dormant m40_collect_cortana_resistance()
	sleep_until (device_get_position(bt_cortana_librarian) > 0.0, 1);
	wake(f_dialog_m40_retrieved_cortana);
	b_cortana_retrieved = TRUE;
	kill_script(m40_leave_without_cortana);
	
end



script dormant m40_elevator_to_ord_talk()
	
			
      wake(f_dialog_elevator_delrio);
      
      

end

script static void m40_landing_in_battle()
     	sleep_until( volume_test_players(m40_landing_in_battle), 1);
      dprint("m40_landing_in_battle");
			
			wake(f_dialog_m40_landing_in_battle);
end

/*
script static void m40_convoy_dialogue()

     sleep_until( volume_test_players(tv_epic_01), 1);
     	wake(f_dialog_m40_clear_out_the_bowl);
			
      
      sleep_s (18);
  
end*/

script dormant m40_second_target_locator_dialogue()

		//	thread (story_blurb_add("vo", "LASKY: Whoops, hey Chief, don't switch weapons, just call in the air strike. Sending in another laser designator."));
      
      sleep_s (10);
      
end

script dormant m40_third_target_locator_dialogue()

	//		thread (story_blurb_add("vo", "LASKY: You switched weapons again? The ordnance launching tube is jammed, you'll need to just move forward for now."));
      
      sleep_s (10);
      
end


script dormant m40_target_gravity_well()

     
				wake(f_dialog_m40_target_gravity_well);


      
end

script dormant m40_cortana_clearing_ravine()

     	sleep_until( volume_test_players(m40_cortana_clearing_ravine), 1);
				wake(f_dialog_m40_cortana_clearing_ravine);
				

      
end

script dormant m40_epic_end_missile_dialogue()

     	sleep_until( volume_test_players(tv_epic_05), 1);
				
				
			
      sleep_s (8);

           
end

script dormant m40_epic_palmer_order()

     	sleep_until( volume_test_players( m40_epic_palmer_order), 1);

				
				wake(f_dialog_m40_epic_end);
      sleep_s (8);
        
end


script dormant m40_epic_end()
sleep_until( volume_test_players(tv_tractor_01), 1);

			 // wake(f_dialog_m40_epic_end);
      sleep_s (8);

           
end

script static void m40_marine_backup_dialogue()
     
		//	thread (story_blurb_add("vo", "LASKY: We're sending in some reinforcements, Chief. We'll mark them on your HUD when they arrive."));
      
      sleep_s (5);
      
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script static void m40_objective_1_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_1());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_1_nudge());
			end
end

script static void m40_objective_2_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_2());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_2_nudge());
			end
end


script static void m40_objective_3_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_3());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_3_nudge());
			end
end


script static void m40_objective_4_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_4());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_4_nudge());
			end
end



script static void m40_objective_5_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_5());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_5_nudge());
			end
end


script static void m40_objective_6_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_6());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_6_nudge());
			end
end


script static void m40_objective_7_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_7());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_7_nudge());
			end
end



script static void m40_objective_8_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_8());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_8_nudge());
			end
end



script static void m40_objective_9_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_9());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_9_nudge());
			end
end


script static void m40_objective_10_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_10());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_10_nudge());
			end
end


script static void m40_objective_11_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_11());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_11_nudge());
			end
end




script static void m40_objective_12_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_12());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_12_nudge());
			end
end



script static void m40_objective_13_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_13());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_13_nudge());
			end
end



script static void m40_objective_14_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_14());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_14_nudge());
			end
end



script static void m40_objective_15_nudge()
			dprint("Nudge fired");
			sleep_s(900);
			if b_objective_1_complete == FALSE then
						thread(f_dialog_m40_nudge_15());
			end
				if b_objective_1_complete == FALSE then
					thread( m40_objective_15_nudge());
			end
end



script static void m40_palmer_off_map_nudge()
dprint( "m40_palmer_off_map_nudge" );
	local short s_random = 0;

	s_random = random_range(1, 8);

	if s_random == 1 then
		
		thread(f_dialog_m40_palmer_off_map_01());
		
	elseif s_random == 2 then
		
		thread(f_dialog_m40_palmer_off_map_02());
		
	elseif s_random == 3 then
	
		thread(f_dialog_m40_palmer_off_map_03());
	
	elseif s_random == 4 then

		thread(f_dialog_m40_palmer_off_map_04());
	

	elseif s_random == 5 then

		thread(f_dialog_m40_palmer_off_map_05());

	elseif s_random == 6 then

		thread(f_dialog_m40_palmer_off_map_06());
		
	elseif s_random == 7 then

		thread(f_dialog_m40_palmer_off_map_07());
		
	elseif s_random == 8 then

		thread(f_dialog_m40_palmer_off_map_08());	
		
	end
		
end



// =================================================================================================
// =================================================================================================
// SECONDARY STORY ELEMENTS
// =================================================================================================
// ======================================



// =================================================================================================
// =================================================================================================
// Armor Abilities
// =================================================================================================
// =================================================================================================


script static void f_waypoint_equipment_unlock()

		wake(f_waypoint_global_equipment_unlock);
end