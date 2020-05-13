//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// DIALOG
// =================================================================================================
// =================================================================================================
// variables

// -------------------------------------------------------------------------------------------------
// INFINITY
// -------------------------------------------------------------------------------------------------
// variables
global long L_dlg_infinity_start = DEF_DIALOG_ID_NONE();
global long L_dlg_flight_launch_start = DEF_DIALOG_ID_NONE();
global long L_dlg_flight_a_tutorial = DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_01 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_02 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_03 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_04 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_05 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_06 =             DEF_DIALOG_ID_NONE();
global long L_dlg_infinity_marine_07 =             DEF_DIALOG_ID_NONE();



// functions

// === f_dlg_infinity_start::: Dialog
script dormant f_dlg_infinity_start()
dprint( "f_dlg_infinity_start" );

	if ( not dialog_foreground_id_active_check(L_dlg_infinity_start) ) then
	
		
		sleep_s(1);
		L_dlg_infinity_start = dialog_start_foreground( "INFINITY_START", L_dlg_infinity_start, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );
												hud_rampancy_players_set( 0.15 );	
												dialog_line_cortana( L_dlg_infinity_start, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00101', TRUE, NONE, 0.0, "", "Cortana : The Didact used this Composer to create the Prometheans from ancient humans." );
												dialog_line_cortana( L_dlg_infinity_start, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00102', TRUE, NONE, 0.0, "", "Cortana : If he wants to finish the job, he'll have to find it first. Our best bet to stop him is keep him firmly on Requiem." );
												dialog_line_cortana( L_dlg_infinity_start, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00103', TRUE, NONE, 0.0, "", "Cortana : Let's hope Lasky didn't skimp on that Pelican." );
												hud_rampancy_players_set( 0.0 );
												

		L_dlg_infinity_start = dialog_end( L_dlg_infinity_start, TRUE, TRUE, "" );
		
	end
  thread(m70_objective_1_nudge());
end



script static void f_dialog_m70_story_button_1( short s_index )


	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( s_index == 1 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_secondary_00100', FALSE, second_console_action_marker, 0.0, "", "Infinity System Voice : We're sorry. Non-essential reporting systems are off-line during departure prep. Recreational information and WarGames standings will return after Infinity is underway.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif ( s_index == 2 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_secondary_00101', FALSE, second_console_action_marker, 0.0, "", "Infinity System Voice : Cargo manifest correction. All pallets bound for Ivanoff Station should be restowed until further notice.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif ( s_index == 3 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_secondary_00102', FALSE, second_console_action_marker, 0.0, "", "Infinity System Voice : Information for all hands regarding Infinity return voyage to Cairo Station, Earth. All personnel are to remain upon Infinity until fully debriefed by their ranking officer. For further information, please contact Lt Cmdr Phillips, Security Deck 1.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
		story_button_state_01 = 0;
	end
	if current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY then
		object_create(story_03_switch);
		sleep_s(0.25);
		thread(story_button_01());
	end
end




script static void f_dialog_m70_story_button_2( short s_index )


	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( s_index == 1 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00100', FALSE, first_console_action_marker, 0.0, "", "Announcer : Wargames simulations, offline.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif( s_index == 2 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00102', FALSE, first_console_action_marker, 0.0, "", "Announcer : Come back later.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif( s_index == 3 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00104', FALSE, first_console_action_marker, 0.0, "", "Announcer : Combat deck information offline.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif ( s_index == 4 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00103', FALSE, first_console_action_marker, 0.0, "", "Announcer : Killing spree postponed.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif ( s_index == 5 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00105', FALSE, first_console_action_marker, 0.0, "", "Announcer : Spartan wargames scoreboard not available during departure.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif ( s_index == 6 ) then
		 l_dialog_id = dialog_start_background("STORY_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_announcer_secondary_00106', FALSE, first_console_action_marker, 0.0, "", "Announcer : Return later for more red versus blue carnage.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );		
		story_button_state_02 = 0;
	end
	if current_zone_set_fully_active() == DEF_S_ZONESET_INFINITY then
		object_create(story_04_switch);
		sleep_s(0.25);
		thread(story_button_02());
	end
end


script static void f_dlg_infinity_dock_pa_01()
dprint("f_dlg_infinity_dock_pa_01");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00100', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : ATTENTION FLIGHT CREWS. PLEASE ENSURE ALL CRAFT RATED GRADE 7 AND HIGHER HAVE BEEN SECURED FOR TRANSIT.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_02()
dprint("f_dlg_infinity_dock_pa_02");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00100', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : ATTENTION FLIGHT CREWS. PLEASE ENSURE ALL CRAFT RATED GRADE 7 AND HIGHER HAVE BEEN SECURED FOR TRANSIT.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_03()
dprint("f_dlg_infinity_dock_pa_03");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00102', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : INFINITY'S ORBITAL DEPARTURE STATUS 'BLUE'. ALL ACTIVE DUTY PERSONNEL MUST REPORT TO DUTY STATIONS IMMEDIATELY.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_04()
dprint("f_dlg_infinity_dock_pa_04");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00103', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : ALL NON-ESSENTIAL PERSONNEL ARE ASKED TO PLEASE RESTRICT INTERDECK TRANSIT UNTIL PLANETARY DEPARTURE IS COMPLETE.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_05()
dprint("f_dlg_infinity_dock_pa_05");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00104', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : ALL PRE-FLIGHT TEAMS: HULL PRESSURIZATION PROTOCOLS ARE NOW IN EFFECT. ALL PERSONNEL ARE ORDERED TO RETURN TO INFINITY.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end


script static void f_dlg_infinity_dock_pa_06()
dprint("f_dlg_infinity_dock_pa_06");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_06", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00105', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : STANDBY FOR TIME CHECK. ON SIGNAL, SHIP TIME WILL BE 19 HOURS 30 MINUTES. STANDBY... MARK.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_07()
dprint("f_dlg_infinity_dock_pa_07");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_07", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00106', FALSE, audio_infinitypa, 0.0, "", "Infinity System Voice : A SIGMA-LEVEL ANOMALY HAS BEEN REPORTED IN MATERIAL DEPLOYMENT BAY F959.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dlg_infinity_dock_pa_08()
dprint("f_dlg_infinity_dock_pa_08");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "INFINITY_DOCK_PA_08", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_pa_00107', FALSE, audio_infinitypa, 0.0, "", "Infinity PA : RESPONSE CREWS ARE EN ROUTE. PLEASE AVOID MDB F959 UNTIL FURTHER NOTICE.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script dormant f_dialog_m70_infinity_marine_01()
	//dprint("f_dialog_m70_infinity_marine_01");
					
            L_dlg_infinity_marine_01 = dialog_start_background("INFINITY_MARINE_01", L_dlg_infinity_marine_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_01, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00140', FALSE, sq_inf_marine_salute_01.tom, 0.0, "", "Uh... sir.", FALSE);
            L_dlg_infinity_marine_01 = dialog_end( L_dlg_infinity_marine_01, TRUE, TRUE, "" );
				
		
		
end

	script dormant f_dialog_m70_infinity_marine_02()
	//dprint("f_dialog_m70_infinity_marine_02");
					
            L_dlg_infinity_marine_02 = dialog_start_background("INFINITY_MARINE_02", L_dlg_infinity_marine_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_02, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00117', FALSE, sq_inf_marine_salute_02.jacob, 0.0, "", "Spartan on deck. Sir.", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_02, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00118', FALSE, sq_inf_marine_salute_02.dan, 0.0, "", "The guys... we respect what you did, Chief.", FALSE);
            L_dlg_infinity_marine_02 = dialog_end( L_dlg_infinity_marine_02, TRUE, TRUE, "" );
				
		
		
end		

	script dormant f_dialog_m70_infinity_marine_03()
	//dprint("f_dialog_m70_infinity_marine_03");
					
            L_dlg_infinity_marine_03 = dialog_start_background("INFINITY_MARINE_03", L_dlg_infinity_marine_03, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_03, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00115', FALSE, sq_inf_spartans_03.spawn_points_0, 0.0, "", "That’s pretty much the way things are going, ain’t it?", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_03, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00116', FALSE, sq_inf_spartans_03.spawn_points_1, 0.0, "", "This is all kinds of wrong, man.", FALSE);
            L_dlg_infinity_marine_03 = dialog_end( L_dlg_infinity_marine_03, TRUE, TRUE, "" );
            sleep_s(15);
				thread( f_m70_infinity_marine_04_trigger(sq_inf_spartans_03.spawn_points_0));
		
		
end		

script dormant f_dialog_m70_infinity_marine_04()
	//dprint("f_dialog_m70_infinity_marine_04");
					
            L_dlg_infinity_marine_04 = dialog_start_background("INFINITY_MARINE_04", L_dlg_infinity_marine_04, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_04, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00121', FALSE, sq_inf_marines_stand_01.cory, 0.0, "", "I thought we came here to figure out what happened with that thing on Ivanoff?", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_04, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00122', FALSE, sq_inf_marines_stand_01.justin, 0.0, "", "Yeah, and now we’re gonna bug out cuz we got a bloody nose. Stupid.", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_04, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00123', FALSE, sq_inf_marines_stand_01.cory, 0.0, "", "FISHDO, man. Keep cashin’ the check.", FALSE);
								
            L_dlg_infinity_marine_04 = dialog_end( L_dlg_infinity_marine_04, TRUE, TRUE, "" );
				
		
		
end		

	script dormant f_dialog_m70_infinity_marine_05()
	//dprint("f_dialog_m70_infinity_marine_05");
					
            L_dlg_infinity_marine_05 = dialog_start_background("INFINITY_MARINE_05", L_dlg_infinity_marine_05, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_05, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00141', FALSE, sq_marines_work_02.tom, 0.0, "", "The old man tried tearing him a new one.", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_05, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00142', FALSE, sq_marines_work_02.chris, 0.0, "", "Good luck with that.", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_05, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00137', FALSE, sq_marines_work_02.tom, 0.0, "", "And good luck on the night watch, Private. The old man is still your superior officer and you will refer to him as such. Are we clear?", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_05, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00138', FALSE, sq_marines_work_02.chris, 0.0, "", "Sir, yes sir.", FALSE);
            L_dlg_infinity_marine_05 = dialog_end( L_dlg_infinity_marine_05, TRUE, TRUE, "" );
            sleep_s(15);
            thread( f_m70_infinity_marine_06_trigger(sq_marines_work_02.chris));

end		

	script dormant f_dialog_m70_infinity_marine_06()
	//dprint("f_dialog_m70_infinity_marine_06");
					
            L_dlg_infinity_marine_06 = dialog_start_background("INFINITY_MARINE_06", L_dlg_infinity_marine_06, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_06, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00139', FALSE, sq_marines_work_03.jesse, 0.0, "", "Look, I fought to get this assignment, I'm just saying-", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_06, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00134', FALSE, sq_marines_work_03.ray, 0.0, "", "A chain of command is still a chain of command.", FALSE);
								dialog_line_npc_ai( L_dlg_infinity_marine_06, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00135', FALSE, sq_marines_work_03.jesse, 0.0, "", "C'mon, who do you think FleetCom's going to side with? Don't be naive.", FALSE);
            L_dlg_infinity_marine_06 = dialog_end( L_dlg_infinity_marine_06, TRUE, TRUE, "" );
				sleep_s(15);
				thread( f_m70_infinity_marine_07_trigger(sq_marines_work_03.ray) );
end		

	script dormant f_dialog_m70_infinity_marine_07()
	//dprint("f_dialog_m70_infinity_marine_07");
					
            L_dlg_infinity_marine_07 = dialog_start_background("INFINITY_MARINE_06", L_dlg_infinity_marine_07, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_infinity_marine_06, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m70\m70_infinity_dock_00136', FALSE, sq_inf_marine_03.sp_01, 0.0, "", "All right, so I know we just unpacked this heap, but we gotta stow the Ivanoff drops again. Word's coming down that we're headed back to Earth first.", FALSE);
            L_dlg_infinity_marine_07 = dialog_end( L_dlg_infinity_marine_07, TRUE, TRUE, "" );

end		



global long l_test_dialog_id = 0;

// === f_dlg_infinity_npc_bark::: Dialog
script static void f_dlg_infinity_npc_bark( trigger_volume tv_trigger, object obj_marine_a, object obj_marine_b )
dprint( "f_dlg_infinity_npc_bark" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
static short s_infinity_npc_bark_index = 0;
local long l_post_reset_timer = 0;

	// make sure the infinity start dialog has played before setting up these triggers
	sleep_until( dialog_id_played_check(L_dlg_infinity_start), 1 );

	repeat
	
		sleep_until( (volume_test_players(tv_trigger) and (not dialog_background_id_active_check(l_dialog_id))) or (dialog_id_invalid_check(l_dialog_id)), 1 ); 

		l_dialog_id = dialog_start_background( "INFINITY_NPC_BARK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP_ALL(), TRUE, "", 0.0 );
		l_test_dialog_id = l_dialog_id;

			// increment bark index
			if ( dialog_background_id_active_check(l_dialog_id) ) then
				s_infinity_npc_bark_index = s_infinity_npc_bark_index + 1;
			end

			dialog_line_npc( l_dialog_id, 1, s_infinity_npc_bark_index == 1, 'sound\dialog\mission\m70\m70_infinity_dock_00117', FALSE, obj_marine_a, 0.0, "", "Marine 5: Spartan on deck. Sir.", FALSE );
			dialog_line_npc( l_dialog_id, 2, s_infinity_npc_bark_index == 1, 'sound\dialog\mission\m70\m70_infinity_dock_00118', FALSE, obj_marine_b, 0.0, "", "Marine 6 : The guys... we respect what you did, Chief.", FALSE );
			
			dialog_line_npc( l_dialog_id, 3, s_infinity_npc_bark_index == 2, 'sound\dialog\mission\m70\m70_infinity_dock_00113', FALSE, obj_marine_a, 0.0, "", "Marine 2 : The old man tried tearing him a new one.", FALSE );
			dialog_line_npc( l_dialog_id, 4, s_infinity_npc_bark_index == 2, 'sound\dialog\mission\m70\m70_infinity_dock_00114', FALSE, obj_marine_b, 0.0, "", "Marine 6 : Good luck with THAT one.", FALSE );
			
			dialog_line_npc( l_dialog_id, 5, s_infinity_npc_bark_index == 3, 'sound\dialog\mission\m70\m70_infinity_dock_00119', FALSE, obj_marine_a, 0.0, "", "Marine 1 : We’re supposed to be the biggest badasses in the fleet, and we’re running away?!?", FALSE  );
			dialog_line_npc( l_dialog_id, 6, s_infinity_npc_bark_index == 3, 'sound\dialog\mission\m70\m70_infinity_dock_00120', FALSE, obj_marine_b, 0.0, "","Marine 2 : What’s so friggin’ tough about this Didact guy anyway? He’s one dude.", FALSE );
			
			dialog_line_npc( l_dialog_id, 7, s_infinity_npc_bark_index == 4, 'sound\dialog\mission\m70\m70_infinity_dock_00121', FALSE, obj_marine_a, 0.0, "", "Marine 3 : I thought we came here to figure out what happened with that thing on Ivanoff?", FALSE );
			dialog_line_npc( l_dialog_id, 8, s_infinity_npc_bark_index == 4, 'sound\dialog\mission\m70\m70_infinity_dock_00122', FALSE, obj_marine_b, 0.0, "", "Marine 4 : Yeah, and now we’re gonna bug out cuz we got a bloody nose. (This is) Stupid.", FALSE );
			dialog_line_npc( l_dialog_id, 9, s_infinity_npc_bark_index == 4, 'sound\dialog\mission\m70\m70_infinity_dock_00123', FALSE, obj_marine_b, 0.0, "", "Marine 3 : FISHDO, man. Keep cashin’ the check.", FALSE );

		l_dialog_id = dialog_end( l_dialog_id, s_infinity_npc_bark_index >= 4, s_infinity_npc_bark_index >= 4, "" );

		if ( s_infinity_npc_bark_index < 4 ) then
			// set the time between that these marines are allowed to speak again
			l_post_reset_timer = game_tick_get() + seconds_to_frames( 7.5 );		
			
			sleep_until( (not volume_test_players(tv_trigger)) or (l_post_reset_timer < game_tick_get()), 1 ); 
		end

	until(  s_infinity_npc_bark_index >= 4, 1 );
	
end

// === f_dlg_infinity_comp_intercom::: Dialog
script dormant f_dlg_infinity_comp_intercom()
dprint( "f_dlg_infinity_comp_intercom" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();

	if ( not dialog_background_id_active_check(l_dialog_id) ) then
	
		l_dialog_id = dialog_start_background( "INFINITY_COMP_INTERCOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00111', FALSE, audio_infinitypa, 0.0, "", "Del Rio : All hands, this is the Captain. Infinity is preparing to depart Requiem and return to UNSC space.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00112', FALSE, audio_infinitypa, 0.0, "", "Del Rio : We mourn the fallen comrades we leave behind, but any victory requires sacrifice. Discipline.", TRUE);
			dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00113', FALSE, audio_infinitypa, 0.0, "", "Del Rio : Most of all, victory requires patience. We have already won the most important battle - we now know the face of the enemy.", TRUE);
			dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00114', FALSE, audio_infinitypa, 0.0, "", "Del Rio : When we meet them again, they will know ours. Del Rio out.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end
	
end

// === f_dlg_infinity_pelican_01::: Dialog
script static void f_dlg_infinity_pelican_01()
dprint( "f_dlg_infinity_pelican_01" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();
	kill_script(infinity_dock_pa_controller);
	sleep_forever(infinity_dock_pa_controller);
	if ( not dialog_background_id_active_check(l_dialog_id) ) then
	
		l_dialog_id = dialog_start_background( "INFINITY_PELICAN_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), TRUE, "", 0.0 );			
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00126', FALSE, pelican_vo_action_marker, 0.0, "", "Infinity System Voice : Attention. All Hands. Final call. Secure all hulls and prepare for immediate departure. Final call.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00127', FALSE, sq_marines_work_04.matt_01, 0.0, "", "Marine 1 : Master Chief, sir.", TRUE);
			dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00128', FALSE, sq_inf_marines_stand_02.st_7, 0.0, "", "Marine 1 : Leave some for us, Chief.", TRUE);
			dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00129', FALSE, sq_inf_marines_stand_02.st_8, 0.0, "", "Marine 2 : Watch your back out there.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		sleep_s(5);
		wake(f_dialog_m70_infinity_marine_05);
	end
end


script static void f_dlg_infinity_pelican_02()
dprint( "f_dlg_infinity_pelican_02" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();
	kill_script(m70_objective_1_nudge);
	sleep_forever(m70_objective_1_nudge);
	wake(f_dlg_flight_launch_start);
	sleep_s(.5);
	if ( not dialog_background_id_active_check(l_dialog_id) ) then
		l_dialog_id = dialog_start_background( "INFINITY_PELICAN_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00130', FALSE, sq_inf_marines_stand_02.st_7, 0.0, "", "Marine 1 : Clear the deck!", TRUE);
		//	dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00131', FALSE, NONE, 0.0, "", "Marine 2 : Clear the deck!", TRUE);
			//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00132', FALSE, sq_inf_marines_stand_02.st_7, 0.0, "", "Marine 1 : Back it up, people!", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00133', FALSE, sq_inf_marines_stand_02.st_8, 0.0, "", "Marine 2 : Lowering the deck elevator. Step off.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end
	
end



/*script dormant f_dialog_m70_infinity_launch_tube()
dprint("f_dialog_m70_infinity_launch_tube");
local long l_dialog_id = L_dlg_flight_launch_start;

            l_dialog_id = dialog_start_foreground( "M70_INFINITY_LAUNCH_TUBE", L_dlg_flight_launch_start, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
								dialog_line_cortana( L_dlg_flight_launch_start, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00100', FALSE, NONE, 0.0, "", "Cortana : Initiating pre-flight diagnostics. Forward Autocannon - Check. Lateral Rail Turrets - Check. Main thrusters - Check. Auxiliary boosters - Check. Alright, keying engines... now." );
								dialog_line_cortana( L_dlg_flight_launch_start, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00101', FALSE, NONE, 0.0, "", "Cortana : It may be a while 'til we find another ride home. You know that, right?" );
								dialog_line_chief( L_dlg_flight_launch_start, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00105', FALSE, NONE, 0.0, "", "Master Chief : 'Seems like old times’?" );
								dialog_line_cortana( L_dlg_flight_launch_start, 3, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00106', FALSE, NONE, 0.0, "", "Cortana : Right. Controls are yours. We are cleared for launch." );
            l_dialog_id = dialog_end( L_dlg_flight_launch_start, TRUE, TRUE, "" );
end*/

// functions
// === f_dlg_flight_a_start::: Dialog
script dormant f_dlg_flight_launch_start()
dprint( "f_dlg_flight_a_start" );
	kill_script(m70_objective_1_nudge);
	sleep_forever(m70_objective_1_nudge);
	kill_script(f_dlg_infinity_pelican_01);
	kill_script(f_dlg_infinity_pelican_02);
	L_dlg_flight_launch_start = dialog_start_foreground( "FLIGHT_A_START", L_dlg_flight_launch_start, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
				dialog_line_cortana( L_dlg_flight_launch_start, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00100', FALSE, NONE, 0.0, "", "Cortana : Initiating pre-flight diagnostics. Forward Autocannon - Check. Lateral Rail Turrets - Check. Main thrusters - Check. Auxiliary boosters - Check. Alright, keying engines... now." );
				sleep_s(3);
				dialog_line_cortana( L_dlg_flight_launch_start, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00101', FALSE, NONE, 0.0, "", "Cortana : It may be a while 'til we find another ride home. You know that, right?" );
				dialog_line_chief( L_dlg_flight_launch_start, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00105', FALSE, NONE, 0.0, "", "Master Chief : It'll be ok." );
				//dialog_line_cortana( L_dlg_flight_launch_start, 3, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00106', FALSE, NONE, 0.0, "", "Cortana : Right. Controls are yours. We are cleared for launch." );
	L_dlg_flight_launch_start = dialog_end( L_dlg_flight_launch_start, TRUE, TRUE, "" );
	thread(m70_objective_2_nudge());
end

// === f_dlg_flight_a_tutorial::: Dialog
script dormant f_dlg_flight_a_tutorial()
 //wake(m70_chapter_1);
//dprint( "f_dlg_flight_a_tutorial" );

kill_script(m70_objective_2_nudge);
	sleep_forever(m70_objective_2_nudge);

end



// -------------------------------------------------------------------------------------------------
// FLIGHT
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// FLIGHT: GENERAL
// -------------------------------------------------------------------------------------------------
// variables



// functions


script dormant f_dlg_m70_first_flight_02()
dprint( "f_dlg_m70_first_flight_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "FIRST_FLIGHT_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00102', FALSE, NONE, 0.0, "", "Cortana : And I was just starting to get used to her." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
end





// === f_dlg_flight_craft_a::: Dialog
script static void f_dlg_flight_didact_kill_warning()
dprint( "f_dlg_flight_craft_a" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 4);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "didact_kill_warning_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00103', FALSE, NONE, 0.0, "", "Cortana : Chief, these new Pelicans may handle a little looser than what you are used to. Better not to run before you can walk." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "didact_kill_warning_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00105', FALSE, NONE, 0.0, "", "Cortana : OK. Since it’s not like you had time to get rated on these new Pelicans, you may want to get a feel for the controls before going head-to-head with the Didact." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "didact_kill_warning_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00104', FALSE, NONE, 0.0, "", "Cortana : Chief, these new Pelicans may handle a little looser than what you are used to. Get a feel for the controls while I scan the area." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end


// === f_dlg_flight_craft_a::: Dialog
script dormant f_dlg_flight_craft_a()
dprint( "f_dlg_flight_craft_a" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_CRAFT_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Watch out! [Craft name]!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
end

// === f_dlg_flight_craft_b::: Dialog
script dormant f_dlg_flight_craft_b()
dprint( "f_dlg_flight_craft_b" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "FLIGHT_CRAFT_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Incoming [craft name]!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
end

// === f_dlg_flight_craft_c::: Dialog
script dormant f_dlg_flight_craft_c()
dprint( "f_dlg_flight_craft_c" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_CRAFT_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: [Craft name] inbound!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
end

// === f_dlg_flight_cannon_warn::: Dialog
script dormant f_dlg_flight_cannon_warn()
dprint( "f_dlg_flight_cannon_warn" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_CANNON_WARN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Energy cannons!  Look out!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
end

// === f_dlg_flight_cannon_tip::: Dialog
script dormant f_dlg_flight_cannon_tip()
dprint( "f_dlg_flight_cannon_tip" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_CANNON_TIP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Chief, ship systems are picking up a massive charge from the location of Didact's ship." );
		dialog_line_chief( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: Engines?" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Not yet.  But things are certainly coming online." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

global long L_dlg_flight_didact_reveal = DEF_DIALOG_ID_NONE();

// === f_dlg_flight_didact_reveal::: Dialog
script dormant f_dlg_flight_didact_reveal()
dprint( "f_dlg_flight_didact_reveal" );
	b_objective_2_complete = TRUE;
	kill_script(m70_objective_2_nudge);
	sleep_forever(m70_objective_2_nudge);
	L_dlg_flight_didact_reveal = dialog_start_foreground( "FLIGHT_DIDACT_REVEAL", L_dlg_flight_didact_reveal, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		//cui_hud_show_radio_transmission_hud( "infinity_transmission_name" );
		//dialog_line_npc( L_dlg_flight_a_tutorial, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00100', FALSE, NONE, 0.0, "", "Infinity Comm : This is Infinity Actual, outbound on a heading of 232 mark 2. Activating sublight engines in 3... 2... 1... ignition.", TRUE);
	//	cui_hud_hide_radio_transmission_hud();
	//	sleep_s(2);
		dialog_line_cortana( L_dlg_flight_didact_reveal, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00106', FALSE, NONE, 0.0, "", "Cortana : Contact. Didact - dead ahead." );
		dialog_line_chief( L_dlg_flight_didact_reveal, 1, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_first_flight_00100', FALSE, NONE, 0.0, "", "Master Chief: How do we get inside those shields?" );
		dialog_line_cortana( L_dlg_flight_didact_reveal, 2, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_first_flight_00101', FALSE, NONE, 0.0, "", "Cortana : Marking two of the larger facilities on your HUD." );
		sleep_s(0.5);
		b_flight_main_spires_blip = TRUE;
		dialog_line_cortana( L_dlg_flight_didact_reveal, 3, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_first_flight_00102', FALSE, NONE, 0.0, "", "Cortana : They're acting as traffic control for resources moving to and from the satellite." );
		thread(f_m70_objective_set(ct_obj_spire_first));
		dialog_line_cortana( L_dlg_flight_didact_reveal, 4, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_first_flight_00103', FALSE, NONE, 0.0, "", "Cortana : If we disrupt their communications,  I can forge an override code and convince it to lower those defenses." );
		
	L_dlg_flight_didact_reveal = dialog_end( L_dlg_flight_didact_reveal, TRUE, TRUE, "" );
	thread(m70_objective_3_nudge());
end



/*// === f_dlg_flight_sentinels_origin::: Dialog
script dormant f_dlg_flight_sentinels_origin_A()
dprint( "f_dlg_flight_sentinels_origin" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
kill_script(m70_objective_2_nudge);
	sleep_forever(m70_objective_2_nudge);
	kill_script(m70_objective_3_nudge);
	sleep_forever(m70_objective_3_nudge);
	l_dialog_id = dialog_start_foreground( "FLIGHT_SENTINELS_ORIGIN_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00109', FALSE, NONE, 0.0, "", "Cortana : Those spires are forming a defensive perimeter around the satellite. Evasive!" );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00111', FALSE, NONE, 0.0, "", "Cortana : Right before they attacked, I intercepted an exchange between those spires and two of the big stationary towers." );
			dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00112', FALSE, NONE, 0.0, "", "Master Chief : Some type of command network?" );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00113', FALSE, NONE, 0.0, "", "Cortana : I think so. Disrupting the Didact's communications could cripple them and give us an open shot at his front door." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			thread(m70_objective_3b_nudge());
	
end*/

script dormant f_dlg_flight_sentinels_origin_B()
dprint( "f_dlg_flight_sentinels_origin_B" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_SENTINELS_ORIGIN_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		//dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: There we go!  Sentinels are coming from these two spires." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end


script dormant f_dlg_flight_third_spire_early()
dprint( "f_dlg_flight_first_spire" );
/*local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	l_dialog_id = dialog_start_foreground( "flight_first_spire", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_early_00100', FALSE, NONE, 0.0, "", "Cortana : The tower we’re approaching is the source of the defense spires. With that much firepower at its desposal, you might want to give it a wide berth." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
	
end

script dormant f_dlg_flight_third_spire_early_2()
dprint( "f_dlg_flight_first_spire" );
/*local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "flight_first_spire", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_early_00100a', FALSE, NONE, 0.0, "", "Cortana : Look. This tower's creating the defense spires. With that much firepower at its disposal, you might want to give it a wide berth." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
	
end

script dormant f_dlg_flight_third_spire_early_3()
dprint( "f_dlg_flight_first_spire_3" );
/*local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "flight_first_spire_", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_early_00100b', FALSE, NONE, 0.0, "", "Cortana : We should steer clear of the production tower. If it starts spitting out more defense spires, we could have our hands full." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
	
end

script dormant f_dlg_flight_first_spire()
dprint( "f_dlg_flight_first_spire" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
b_objective_2_complete = TRUE;
	l_dialog_id = dialog_start_foreground( "f_dlg_flight_first_spire", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00104', FALSE, NONE, 0.0, "", "Cortana : All right. Take us in." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// === f_dlg_flight_spire_collision::: Dialog
script static void f_dlg_flight_spire_collision()
dprint( "f_dlg_flight_spire_collision" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();
static short s_collision_cnt = 0;

	if ( not dialog_foreground_id_active_check(l_dialog_id) and (not dialog_id_invalid_check(l_dialog_id)) ) then

		l_dialog_id = dialog_start_foreground( "FLIGHT_SPIRE_COLLISION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );

			// increment collision count
			if ( dialog_foreground_id_active_check(l_dialog_id) ) then
				s_collision_cnt = s_collision_cnt + 1;
			end

			dialog_line_cortana( l_dialog_id, 1, (s_collision_cnt == 1), NONE, FALSE, NONE, 0.0, "", "CORTANA: Nice flying, cowboy." );
			dialog_line_cortana( l_dialog_id, 2, (s_collision_cnt == 2), NONE, FALSE, NONE, 0.0, "", "CORTANA: Hey! Watch the paint!" );
			dialog_line_cortana( l_dialog_id, 3, (s_collision_cnt == 3), NONE, FALSE, NONE, 0.0, "", "CORTANA: Someday we should return an aircraft in one piece." );
		l_dialog_id = dialog_end( l_dialog_id, s_collision_cnt >= 3, s_collision_cnt >= 3, "" );
		
	end
	
end/*

script dormant f_dlg_first_defense_spire()
dprint( "f_dlg_first_defense_spire" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "first_defense_spire", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_defense_spire_00100', FALSE, NONE, 0.0, "", "Cortana : Nice, Chief, but I wouldn't celebrate just yet. I'm detecting a replacement spire being generated on the far side of the docking area. We'll want to reach the command network before the backup arrives." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end*/


script dormant f_dlg_flight_exit_through_maw()
dprint( "f_dlg_flight_exit_through_maw" );
local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 2);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "flight_exit_through_maw", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_maw_00101', FALSE, NONE, 0.0, "", "Cortana : Careful, there's a gravimetric disturbance near the lip of the shell. I don't know what impact it will have on the Pelican." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "flight_exit_through_maw", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_maw_00102', FALSE, NONE, 0.0, "", "Cortana : Heading right for the exit won't stop the Didact." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );

	end
	
end


script dormant f_dlg_flight_first_spire_approach()
dprint( "f_dlg_first_spire_open" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	kill_script(m70_objective_3_nudge);
	sleep_forever(m70_objective_3_nudge);

	l_dialog_id = dialog_start_foreground( "first_spire_open", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_first_spire_00105', FALSE, NONE, 0.0, "", "Cortana : Set her down." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end






//dialog_foreground_id_line_index_check_greater( long l_dialog_id, short s_line_index )
// -------------------------------------------------------------------------------------------------
// FLIGHT: A
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_flight_a_start::: Dialog
/*script dormant f_dlg_flight_launch_start()
dprint( "f_dlg_flight_a_start" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "FLIGHT_LAUNCH_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00100', FALSE, NONE, 0.0, "", "Cortana : Initiating pre-flight diagnostics. Forward Autocannon - Check." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00101', FALSE, NONE, 0.0, "", "Cortana : It may be a while 'til we find another ride home. You know that, right?" );
								dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00105', FALSE, NONE, 0.0, "", "Master Chief : 'Seems like old times’?" );
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_infinity_launch_tube_00106', FALSE, NONE, 0.0, "", "Cortana : Right. Controls are yours. We are cleared for launch." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	thread(m70_objective_2_nudge()); 
	
end*/

/*
// === f_dlg_flight_a_tutorial::: Dialog
script dormant f_dlg_flight_a_tutorial()
dprint( "f_dlg_flight_a_tutorial" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_A_TUTORIAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       								
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00104', FALSE, NONE, 0.0, "", "Cortana : Chief, these new Pelicans may handle a little looser than what you are used to. Get a feel for the controls while I scan the area." );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00105', FALSE, NONE, 0.0, "", "Cortana : OK. Since it’s not like you had time to get rated on these new Pelicans, you may want to get a feel for the controls before going head-to-head with the Didact." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end*/

script dormant f_dlg_spires_start_moving()
dprint( "f_dlg_spires_start_moving" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "f_dlg_spires_start_moving", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00109', FALSE, NONE, 0.0, "", "Cortana : Those spires are forming a perimeter around the satellite. Evasive!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00111', FALSE, NONE, 0.0, "", "Cortana : Right before they attacked, I intercepted an exchange between those defense spires and two of the  towers descending from the roof." );
		dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00112', FALSE, NONE, 0.0, "", "Master Chief : Some type of command network?" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_first_flight_00113', FALSE, NONE, 0.0, "", "Cortana : I think so. Disrupting their communications could cripple the spires and give us an open shot at the Didact’s front door." );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end




// === f_dlg_flight_a_cov_warning::: Dialog
script dormant f_dlg_flight_a_cov_warning()
dprint( "f_dlg_flight_a_cov_warning" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_A_TUTORIAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Be Carefull Chief, Lots of Covenant craft in the area, protecting their god while he builds his ship." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// === f_dlg_flight_a_incoming::: Dialog
script dormant f_dlg_flight_a_incoming()
dprint( "f_dlg_flight_a_incoming" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_A_INCOMING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Chief!  Incoming Covenant!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// === f_dlg_flight_a_energising::: Dialog
script dormant f_dlg_flight_a_energising()
dprint( "f_dlg_flight_a_energising" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_A_ENERGISING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Changing altitude can help avoid cannon fire." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT: B
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_flight_b_sentinels::: Dialog
script dormant f_dlg_flight_second_didact_ship_01()
dprint( "f_dlg_flight_b_start" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_2_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00103', FALSE, NONE, 0.0, "", "Cortana : The Didact's shields are weakened but I'm detecting increased activity inside the satellite. And something tells me that's probably not a good thing." );
		//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00102', FALSE, NONE, 0.0, "", "Master Chief : What's that forming around the Didact's satellite?" );
	//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00103', FALSE, NONE, 0.0, "", "Cortana : [From the look of those segments,] I'd say he's constructing some type of starship." );
	//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00104', FALSE, NONE, 0.0, "", "Cortana : And at the rate it's coming together, we'd better hurry if we want to stop him from leaving." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
/*
// === f_dlg_flight_b_didact_01::: Dialog
script dormant f_dlg_flight_b_didact_01()
dprint( "f_dlg_flight_b_didact_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_B_DIDACT_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );		
			dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00105', FALSE, NONE, 0.0, "", "Didact : Your continued actions tread in the worlds between honor and foolishness." );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00106', FALSE, NONE, 0.0, "", "Master Chief : Cortana, are you hearing him?" );
			dialog_line_didact( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00107', FALSE, NONE, 0.0, "", "Didact : I will leave this world and retrieve the Composer. You cannot doubt this." );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00108', FALSE, NONE, 0.0, "", "Cortana : I don't hear anything. Didact?" );
			dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00109', FALSE, NONE, 0.0, "", "Didact : So then... which of us does this pointless resistence debase?" );
			dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00110', FALSE, NONE, 0.0, "", "Master Chief : Is it possible you can't hear him because of whatever the Librarian did to me?" );
			dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00111', FALSE, NONE, 0.0, "", "Cortana : Nothing comes out of thin air. If he's talking, I'll find a way to hear him." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end*/

/*// === f_dlg_flight_b_didact_02::: Dialog
script dormant f_dlg_flight_b_didact_02()
dprint( "f_dlg_flight_b_didact_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_B_DIDACT_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_didact ( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "DIDACT: The Librarian's mindstate is sealed away, beyond reach of aiding you, Reclaimer." );
		dialog_line_chief  ( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: I don't need her help." );
		dialog_line_cortana( l_dialog_id, 3, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Who?  Me?" );
		dialog_line_didact ( l_dialog_id, 4, TRUE, NONE, FALSE, NONE, 0.0, "", "DIDACT: Is that so?" );
		dialog_line_cortana( l_dialog_id, 5, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Since when don't you need my help?" );
		dialog_line_didact ( l_dialog_id, 6, TRUE, NONE, FALSE, NONE, 0.0, "", "DIDACT: We shall see." );
		dialog_line_chief  ( l_dialog_id, 7, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: So you can hear me." );
		dialog_line_cortana( l_dialog_id, 8, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Of course I can hear-- (beat)  You...aren't talking to me, are you?" );
		dialog_line_didact ( l_dialog_id, 9, TRUE, NONE, FALSE, NONE, 0.0, "", "DIDACT: I hear all on this world, human.  I see.  I am all." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end*/


// === f_dlg_flight_b_didact_01::: Dialog
script static void f_dlg_flight_second_spire_approach()
dprint( "f_dlg_second_spire_approach" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_SECOND_SPIRE_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );		
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00105', FALSE, NONE, 0.0, "", "Cortana : Set us down." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end


script dormant f_dlg_flight_second_didact_ship_02()
dprint( "f_dlg_second_spire_approach" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_SECOND_DIDACT_SHIP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );		
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00103', FALSE, NONE, 0.0, "", "Cortana : The Didact's shields are weakened but I'm detecting increased activity inside the satellite. And something tells me that's probably not a good thing." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_dlg_second_spire_destroy()
dprint( "f_dlg_second_flight_destroy" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SECOND_FLIGHT_DESTROY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );		
	//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_second_flight_00113', FALSE, NONE, 0.0, "", "Cortana : Good work. ." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end
		

// === f_dlg_flight_b_touchdown::: Dialog
script dormant f_dlg_flight_b_touchdown()
dprint( "f_dlg_flight_b_touchdown" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_B_TOUCHDOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Let's get this done.  I'm tired of not being the only voice in your head." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// FLIGHT: C
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_flight_c_sentinels::: Dialog
/*
script dormant f_dlg_flight_c_sentinels()
dprint( "f_dlg_flight_c_sentinels" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_C_SENTINELS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: There's the final source of Sentinels." );
		dialog_line_cortana( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Didn't see it at first, but I'm putting up a waypoint for it now." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end
*/
// === f_dlg_flight_c_covenant::: Dialog
script dormant f_dlg_flight_third_spire_03()
dprint( "f_dlg_flight_third_spire_03" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_C_COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_didact_00100', FALSE, NONE, 0.0, "", "Didact: Do you truly believe these theatrics can prevent my departure? Embrace your sad fate and retain your nobility. I am already beyond you." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00103', FALSE, NONE, 0.0, "", "Cortana : He knows what we're trying to do.  If we try to get too close to that ship, we're dead." );
		//wake(f_dlg_flight_third_spire_03_background);
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00108', FALSE, NONE, 0.0, "", "Cortana : I… I have an idea.  Head for that waypoint." );
		sleep_s(0.25);
		f_blip_flag(flg_spire_03_approach, "recon");	
		b_cortana_bliped_sp03 = TRUE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

script dormant f_dlg_flight_third_spire_03_background()
dprint( "f_dlg_flight_third_spire_03_background" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_background( "THIRD_SPIRE_03_BACKGROUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\Play_m70_third_flight_00102_rampancy', FALSE, NONE, 0.0, "", "Cortana : DON'T BE RIDICULOUS!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end
/*
// === f_dlg_flight_c_turrets::: Dialog
script dormant f_dlg_flight_c_turrets()
dprint( "f_dlg_flight_c_turrets" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_C_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: It's almost like Didact's getting serious about you." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end*/
/*
// === xxx::: Dialog
script dormant f_dlg_flight_c_destination()
dprint( "f_dlg_flight_c_destination" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "FLIGHT_C_DESTINATION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );		
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_third_flight_00103', FALSE, NONE, 0.0, "", "Cortana : Chief, I'm setting a waypoint!" );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_third_flight_00104', FALSE, NONE, 0.0, "", "Master Chief : Where?" );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_third_flight_00105', FALSE, NONE, 0.0, "", "Cortana : The production tower that created the spires. Just because Didact can't use them anymore doesn't mean we can't. GO." );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_third_flight_00106', FALSE, NONE, 0.0, "", "Cortana : Chief, trust me - our only option to stop Didact is to get to that production spire." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end
*/

// === xxx::: Dialog
script static void f_dlg_flight_c_didact_ship( short s_index)
dprint( "f_dlg_flight_c_didact_ship" );


	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( s_index == 1 ) then
	l_dialog_id = dialog_start_foreground( "FLIGHT_C_DIDACT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_cortana_00101', FALSE, NONE, 0.0, "", "Cortana : The Didact's trying to stop us!" );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00101', FALSE, NONE, 0.0, "", "Master Chief : Divert all power to the engines." );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00102', FALSE, NONE, 0.0, "", "Cortana : It won't matter! The Pelican's breaking up, we have to pull back!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	if ( s_index == 2 ) then
		l_dialog_id = dialog_start_foreground( "FLIGHT_C_DIDACT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00100', FALSE, NONE, 0.0, "", "Cortana : The Pelican can't take much more of this…!" );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00104', FALSE, NONE, 0.0, "", "Master Chief : I don't care how we do it, but we're not letting the Didact leave this planet." );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_third_flight_pelican_00106', FALSE, NONE, 0.0, "", "Cortana : This isn't the way!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	sleep_s(30);
	thread(f_nar_flight_03_didact_ship());
end

script static void f_dlg_flight_01_defense( short s_index)
dprint( "f_dlg_flight_01_defense" );


	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( s_index == 1 ) then
	l_dialog_id = dialog_start_foreground( "FLIGHT_A_DEFENSE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_1st_flight_00101', FALSE, NONE, 0.0, "", "Cortana : Be careful around these smaller defense spires. I'm detecting propulsion units and I'm betting they can outrun us if they want to." );
			
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	if ( s_index == 2 ) then
		l_dialog_id = dialog_start_foreground( "FLIGHT_A_DEFENSE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_1st_flight_00102', FALSE, NONE, 0.0, "", "Cortana : We can hammer on these defense spires all day, but unless we disable those bigger towers, we are not getting on that ship." );
			
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	sleep_s(15);
	thread(f_nar_flight_01_defense());
end


// -------------------------------------------------------------------------------------------------
// SPIRES
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// SPIRE: 01
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_spire_01_enter_reminder::: Dialog
script dormant f_dlg_spire_01_enter_reminder()
dprint( "f_dlg_spire_01_enter_reminder" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_01_ENTER_REMINDER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: What are you waiting for?  The Spire is open." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

// === f_dlg_spire_01_enter_radar::: Dialog
script dormant f_dlg_spire_01_enter_first()
dprint( "f_dlg_spire_01_enter_radar" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
		kill_script(m70_objective_3_nudge);
	sleep_forever(m70_objective_3_nudge);
	l_dialog_id = dialog_start_foreground( "SPIRE_01_ENTER_RADAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire1_gondolas_00100', FALSE, NONE, 0.0, "", "Cortana : This tower's directing traffic to the Didact's satellite through a carrier wave generator located somewhere inside." );
			hud_rampancy_players_set( 0.7 );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_first_spire_00113', FALSE, NONE, 0.0, "", "Cortana : Of course, if Infinity wasn't on its way back to Earth, locating and disabling it would be trivial." );
			dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_first_spire_00114', FALSE, NONE, 0.0, "", "Master Chief : We can handle it." );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_first_spire_00115', FALSE, NONE, 0.0, "", "Cortana : That's hardly the point, is it?" );
			hud_rampancy_players_set( 0.0 );
			thread(f_m70_objective_set(ct_obj_spire_01));
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dlg_spire_01_first_gondola_dock()
dprint( "f_dlg_spire_01_gondola_start_platform" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "START_PLATFORM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00100', FALSE, NONE, 0.0, "", "Cortana : I've found the carrier wave generator. It's on the opposite end of this chamber." );
			
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
	sleep_s(1);
	f_blip_flag(flg_sp01_shield_lock, "neutralize");	
end

global long L_dlg_gondola_enter = DEF_DIALOG_ID_NONE();

script dormant f_dlg_spire_01_first_gondola_nudge()
dprint( "f_dlg_spire_02_gondola_enter" );

	L_dlg_gondola_enter = dialog_start_foreground( "GONDOLA_ENTER", L_dlg_gondola_enter, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( L_dlg_gondola_enter, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00101', FALSE, NONE, 0.0, "", "Cortana : We can use this gondola to cross to the other side. Find the activation switch." );
	L_dlg_gondola_enter = dialog_end( L_dlg_gondola_enter, FALSE, FALSE, "" );
		b_blip_gondola_start = TRUE;

end



script dormant f_dlg_spire_01_gondola_moving()
dprint( "f_dlg_spire_01_gondola_moving" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "GONDOLA_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
	hud_play_pip_from_tag( bink\Campaign\M70_A_60 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00102', FALSE, NONE, 0.0, "", "Cortana : To take a page out of our old playbook, I'm tuning your shields to emit an EMP at the same frequency as the spire communications." );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00122', FALSE, NONE, 0.0, "", "Cortana : All you'll need to do to trigger it is to make contact with the carrier wave generator." );

	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_01_gondola_taking_fire()
dprint( "f_dlg_spire_01_gondola_taking_fire" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "TAKING_FIRE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00103', FALSE, NONE, 0.0, "", "Cortana : Taking fire! Starboard side!" );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end



script dormant f_dlg_spire_01_first_gondola_stop_tower_1()
dprint( "f_dlg_spire_01_covenant_attack" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "GONDOLA_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00104', FALSE, NONE, 0.0, "", "Master Chief : Why are we stopping?" );
		hud_rampancy_players_set( 0.6 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00124', FALSE, NONE, 0.0, "", "Cortana : Stopping?" );
		hud_rampancy_players_set( 0.0 );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00105', FALSE, NONE, 0.0, "", "Cortana : They've... they've overridden the gondola controls!" );
		
		dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00106', FALSE, NONE, 0.0, "", "Master Chief : Light up the Override on the HUD." );
		hud_rampancy_players_set( 0.7 );
		sleep_s(1.5);
		dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00125', FALSE, NONE, 0.0, "", "Master Chief : Cortana, the location of the override." );
		hud_rampancy_players_set( 0.0 );
		dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00126', FALSE, NONE, 0.0, "", "Cortana : Here!" );
		b_gondola_waypoint_1 = TRUE;
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end


script dormant f_dlg_spire1_gondola_button_release()
dprint( "f_dlg_spire1_button_release" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "BUTTON_RELEASE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00107', FALSE, NONE, 0.0, "", "Cortana : OK. The lockout has been released but--" );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
//	thread(f_sp01_null_blips());
	//sleep_s(1);
	//wake(f_dlg_spire_01_first_gondola_tower_1_end);
end

script dormant f_dlg_spire_01_first_gondola_tower_1_end()
dprint( "f_dlg_spire1_button_release_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "BUTTON_RELEASE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00108', FALSE, NONE, 0.0, "", "Master Chief : Where’d they all go?" );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00109', FALSE, NONE, 0.0, "", "Cortana : I'm... not sure. Regardless, the gondola's online. Get onboard while I try to work out what just happened." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_1_gondola_fight_start()
dprint( "f_dlg_spire1_gondola_attack" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "GONDOLA_ATTACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00111', FALSE, NONE, 0.0, "", "Cortana : They're not going to make this easy, are they?" );

	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
end

script dormant f_dlg_spire1_gondola_start_back_up()
dprint( "f_dlg_spire1_gondola_start_back_up" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "GONDOLA_START_BACK_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00112', FALSE, NONE, 0.0, "", "Cortana : OK, start us back up." );

	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end



script dormant f_dlg_spire_01_gondola_covenant_attack_02()
dprint( "f_dlg_spire_01_covenant_attack_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "COVENANT_ATTACK_2	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00134', FALSE, NONE, 0.0, "", "Cortana : We've got another squad moving to override the transport controls." );		
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_01_first_gondola_stop_02()
dprint( "f_dlg_spire_01_stop_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "COVENANT_ATTACK_2	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00127', FALSE, NONE, 0.0, "", "Cortana: Power this crate back up. We're just about to the carrier wave generator." );		
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_01_gondola_didact_scan()
dprint( "f_dlg_spire_01_didact_scan" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	sleep_s(2);
	l_dialog_id = dialog_start_foreground( "DIDACT_SCAN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00128', FALSE, NONE, 0.0, "", "Master Chief : Didact?" );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00113', FALSE, NONE, 0.0, "", "Cortana : So much for going unnoticed. We better step it up." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_01_gondola_carrier_wave_generator()
dprint( "f_dlg_spire_01_carrier_wave_generator" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CARRIER_WAVE_GENERATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00114', FALSE, NONE, 0.0, "", "Cortana : On the platform - that's the carrier wave generator." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00129', FALSE, NONE, 0.0, "", "Cortana : Enter the carrier field to trigger the suit's EMP." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
end


script static void  f_dlg_spire_01_gondola_carrier_wave_generator_02()
dprint( "f_dlg_spire_01_carrier_wave_generator_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "CARRIER_WAVE_GENERATOR_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00131', FALSE, NONE, 0.0, "", "Cortana : Give it a second…" );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
end

script dormant f_dlg_spire_01_gondola_carrier_wave_generator_02a()
dprint( "f_dlg_spire_01_carrier_wave_generator_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CARRIER_WAVE_GENERATOR_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00116', FALSE, NONE, 0.0, "", "Didact : The others scatter like embers over sand. And yet the Librarian's champion is unmoved." );
			sleep_s(0.25);
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire1_gondolas_00102', FALSE, NONE, 0.0, "", "Cortana : Well done. All communications from this tower have ceased" );	
			//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00117', FALSE, NONE, 0.0, "", "Master Chief : Cortana, where's this coming from?" );
			//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00118', FALSE, NONE, 0.0, "", "Cortana : Where’s what coming from?" );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_01_gondola_carrier_wave_generator_02b()
dprint( "f_dlg_spire_01_gondola_carrier_wave_generator_02b" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CARRIER_WAVE_GENERATOR_02b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00119', FALSE, NONE, 0.0, "", "Didact : The mantle of responsibility for the galaxy shelters all, human. But only the Forerunners are its masters." );
		//xxxx
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00117', FALSE, NONE, 0.0, "", "Master Chief : Cortana, where's this coming from?" );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00118', FALSE, NONE, 0.0, "", "Cortana : Where’s what coming from?" );
			//xxx
			dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00120', FALSE, NONE, 0.0, "", "Master Chief : The Didact’s voice." );
			//sleep_s(0.25);
			//dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00132', FALSE, NONE, 0.0, "", "Didact : You and your kind are obstacles to its restoration. For all our sakes, you must accept containment." );
			//sleep_s(0.5);
			dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00121', FALSE, NONE, 0.0, "", "Cortana : I'm not picking up anything, Chief." );
			dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00133', FALSE, NONE, 0.0, "", "Master Chief : He's there. Keep trying." );

	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end


script dormant f_dlg_spire_01_gondola_exit()
dprint( "f_dlg_spire_01_exit" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_01_EXIT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00101', FALSE, NONE, 0.0, "", "Cortana : Covenant air traffic's increasing. If we don't disable the other tower quickly, reaching the Didact could become exponentially more difficult." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_02_first_intro()
dprint( "f_dlg_spire_01_exit" );
	kill_script(m70_objective_3_nudge);
	sleep_forever(m70_objective_3_nudge);
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire1_cores_00100', FALSE, NONE, 0.0, "", "Cortana : Slight complication. There are millions of transmissions passing through this structure, not simply the ones controlling the movement through the satellite's shield." );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire1_cores_00101', FALSE, NONE, 0.0, "", "Master Chief : Can you isolate the satellite communications?" );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00102', FALSE, NONE, 0.0, "", "Cortana : Not quickly, and shutting them all down's not an option. But destroying the system's attenuators should flood the network." );
			hud_rampancy_players_set( 0.7 );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00112', FALSE, NONE, 0.0, "", "Cortana : Of course, if Infinity wasn't on their way back to Earth, they could overload the attenuators remotely." );
			dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00113', FALSE, NONE, 0.0, "", "Master Chief : We'll handle it." );
			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00114', FALSE, NONE, 0.0, "", "Cortana : That's hardly the point." );
			hud_rampancy_players_set( 0.0 );
			f_m70_objective_set(ct_obj_spire_02);
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

script dormant f_dlg_spire_02_first_cores_enter()
dprint( "f_dlg_spire_01_cores_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_02	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00103', FALSE, NONE, 0.0, "", "Cortana : The attenuators are housed in Faraday enclosures. I'd bet there's a release around here somewhere…" );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
	f_blip_flag (flg_spire02_switch, "activate");
	b_spire_02_button_active = TRUE;
end



script dormant f_dlg_spire_02_first_cores_start()
dprint( "f_dlg_spire_01_cores_03" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_03	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00104', FALSE, NONE, 0.0, "", "Cortana : OK, the structure contains three central attenuators. Sever those connections." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end

/*script dormant f_dlg_spire_02_first_cores_phantom_blip()
dprint( "f_dlg_spire_01_cores_04" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_04	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00105', FALSE, NONE, 0.0, "", "Cortana : Multiple contacts on the tracker!" );
			sleep_s(1);
			dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00106', FALSE, NONE, 0.0, "", "Master Chief : Where'd they go?" );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00107', FALSE, NONE, 0.0, "", "Cortana : Unknown. Though I can't imagine very far." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end*/


script dormant f_dlg_spire_02_first_nudge_second_core()
dprint( "f_dlg_spire_01_cores_05" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_05	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00108', FALSE, NONE, 0.0, "", "Cortana : Second attenuator, (LONG DRAWN OUT RAMPANCY DISTORTION, then) up ahead." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end



script dormant f_dlg_spire_02_first_didact_scan()
dprint( "f_dlg_spire_01_cores_06" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_06	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
	
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire1_cores_00102', FALSE, NONE, 0.0, "", "Cortana : Great, the increased signal traffic is almost entirely blocking out the satellite communications. Only one more target left." );
				
				sleep_s(1);
				
				//xxx scan test
				/*
				if volume_test_objects (tv_nar_fx_didact_scan_2a, players()) then
					effect_new (environments\solo\m70_liftoff\fx\scan\dscan_spire2_1.effect, fx_didact_scan_spire2a);
				end		
				
				if volume_test_objects (tv_nar_fx_didact_scan_2b, players()) then
					effect_new (environments\solo\m70_liftoff\fx\scan\dscan_spire2_1.effect, fx_didact_scan_spire2b);
				end
				
				if volume_test_objects (tv_nar_fx_didact_scan_2c, players()) then
					effect_new (environments\solo\m70_liftoff\fx\scan\dscan_spire2_1.effect, fx_didact_scan_spire2c);
				end			
			*/	
			//	sleep_s(1);
		//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00110', FALSE, NONE, 0.0, "", "Cortana : There goes the element of surprise. If the Didact knows we're here, this could get tricky." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end


script dormant f_dlg_spire_02_first_cores_destroyed_3()
dprint( "f_dlg_spire_01_cores_07" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_07	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire1_cores_00111', FALSE, NONE, 0.0, "", "Cortana : That's it! Transmission buffers are overflowing. Get us to the second tower-" );
			dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00116', FALSE, NONE, 0.0, "", "Didact : The others scatter like embers over sand. And yet the Librarian's champion is unmoved." );
			dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00117', FALSE, NONE, 0.0, "", "Master Chief : Cortana, where's this coming from?" );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00118', FALSE, NONE, 0.0, "", "Cortana : Where’s what coming from?" );
			dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00119', FALSE, NONE, 0.0, "", "Didact : The mantle of responsibility for the galaxy shelters all, human. But only the Forerunners are its masters." );
			dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00120', FALSE, NONE, 0.0, "", "Master Chief : The Didact’s voice." );
			//dialog_line_didact( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00132', FALSE, NONE, 0.0, "", "Didact : You and your kind are obstacles to its restoration. For all our sakes, you must accept containment." );
			dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00121', FALSE, NONE, 0.0, "", "Cortana : I'm not picking up anything, Chief." );
			dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m70\m70_spire1_gondolas_00133', FALSE, NONE, 0.0, "", "Master Chief : He's there. Keep trying." );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
end

script dormant f_dlg_spire_02_first_end()
dprint( "f_dlg_spire_01_cores_08" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "CORES_08	", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_all_2nd_flight_00101', FALSE, NONE, 0.0, "", "Cortana : Covenant air traffic's increasing. If we don't disable the other tower quickly, reaching the Didact could become exponentially more difficult." );		
			f_m70_objective_complete(ct_obj_spire_02 );
	l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );

end




// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SPIRE: 02
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_spire_02_entry::: Dialog
script dormant f_dlg_spire_01_enter_second()
dprint( "f_dlg_spire_01_enter_second" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_LANDING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );			
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00100', FALSE, NONE, 0.0, "", "Cortana : This node's different than the previous tower." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_gondolas_00100', FALSE, NONE, 0.0, "", "Cortana : The source of the tower communications is a carrier wave generator located somewhere inside." );
		sleep_s(1);
		thread(f_m70_objective_set(ct_obj_spire_01));
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dlg_spire_01_second_gondola_dock()
dprint( "f_dlg_spire_02_gondola_entry" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_ENTRY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00102', FALSE, NONE, 0.0, "", "Cortana : It looks like the carrier wave generator is located at the far end of this chamber. Find us a way across." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	sleep_s(1);
	f_blip_flag(flg_sp01_shield_lock, "neutralize");

end



script dormant f_dlg_spire_01_second_gondola_nudge()
dprint( "f_dlg_spire_02_gondola_boarded" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_BOARDED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00103', FALSE, NONE, 0.0, "", "Cortana : This gondola should do the trick. Look for its activation switch." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	b_blip_gondola_start = TRUE;
end



script dormant f_dlg_spire_02_gondola_shields()
dprint( "f_dlg_spire_02_gondola_shields" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
		
	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_SHIELDS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
	hud_play_pip_from_tag( bink\Campaign\M70_A_60 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00112', FALSE, NONE, 0.0, "", "Cortana : To take a page out of our old playbook, I'm going to tune your shields to emit an EMP at the same frequency as the communication network." );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00113', FALSE, NONE, 0.0, "", "Cortana : All you'll need to do to trigger it is to make physical contact with the carrier wave generator." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dlg_spire_01_second_gondola_stop_tower_1()
dprint( "f_dlg_spire_02_gondola_covenant_attack" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_COVENANT_ATTACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00104', FALSE, NONE, 0.0, "", "Cortana : Covenant!" );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00105', FALSE, NONE, 0.0, "", "Cortana : The Didact's given them control of the system overrides! You're going to have to wrestle for it." );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00106', FALSE, NONE, 0.0, "", "Cortana : The controls are up there." );
			sleep_s(1);
			dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00114', FALSE, NONE, 0.0, "", "Master Chief : Where?" );
			hud_rampancy_players_set( 0.6 );
			sleep_s(1.5);
			hud_rampancy_players_set( 0.0 );
			dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00115', FALSE, NONE, 0.0, "", "Cortana : Right, sorry. Waypoint!" );
			b_gondola_waypoint_1 = TRUE; 
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dlg_spire_01_second_gondola_tower_1_end()
dprint( "f_dlg_spire_02_gondola_override_1" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_OVERRIDE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00107', FALSE, NONE, 0.0, "", "Cortana : We're in business! Back to the gondola." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dlg_spire_01_second_gondola_stop_tower_2()
dprint( "f_dlg_spire_02_gondola_covenant_attack_2" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_COVENANT_ATTACK_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00108', FALSE, NONE, 0.0, "", "Cortana : They're trying to lockout the gondola controls again!" );
				sleep_s(2);
				dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00111', FALSE, NONE, 0.0, "", "Didact : Your actions tread between honor and foolishness." );
				dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00112', FALSE, NONE, 0.0, "", "Master Chief : Cortana, are you hearing him?" );
				dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00113', FALSE, NONE, 0.0, "", "Cortana : No. Didact?" );
				//dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00114', FALSE, NONE, 0.0, "", "Didact : I will retrieve the Composer and cage humanity, as I did with my Prometheans. You cannot doubt this." );
				//dialog_line_didact( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00115', FALSE, NONE, 0.0, "", "Didact : So then... which of us does this pointless resistence debase?" );
				//dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00116', FALSE, NONE, 0.0, "", "Master Chief : We've got to wrap this up. Where are the other targets?" );
			//	hud_rampancy_players_set( 0.8 );
			//	sleep_s(1);
			//	hud_rampancy_players_set( 0.0 );
			//	dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00117', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );


	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end




script dormant f_dlg_spire_01_second_cortana_gondola_stop_2()
dprint( "f_dlg_spire_02_gondola_power_crate_back" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_POWER_CRATE_BACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00118', FALSE, NONE, 0.0, "", "Master Chief : Cortana!?" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
/*

script dormant f_dlg_spire_02_gondola_control_restored()
dprint( "f_dlg_spire_02_gondola_control_restored" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_CONTROL_RESTORED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00109', FALSE, NONE, 0.0, "", "Cortana : Gondola controls restored. It's docking at the carrier wave generator. Get over there." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/

script dormant f_dlg_spire_02_gondola_trigger_the_emp()
dprint( "f_dlg_spire_02_gondola_trigger_the_emp" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_TRIGGER_THE_EMP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_gondolas_00110', FALSE, NONE, 0.0, "", "Cortana : The carrier wave generator's on top of that platform. You only have to enter field to trigger the EMP." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dlg_spire_01_second_gondola_final_ride()
dprint( "f_dlg_spire_02_gondola_clear" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_gondolas_00101', FALSE, NONE, 0.0, "", "Cortana : We're clear - all transmissions between the towers and the satellite have ceased." );
			sleep_s(1);
			dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00119', FALSE, NONE, 0.0, "", "Didact : You are a fool. Even now, your kind tinkers with the Composer in the shadow of the third ring. Children and fire, whom -" );
		//	hud_rampancy_players_set( 0.6 );
		//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00120', FALSE, NONE, 0.0, "", "Cortana : GOT HIM!" );
		//	hud_rampancy_players_set( 0.0 );
			//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00121', FALSE, NONE, 0.0, "", "Cortana : Finally. Whatever the Librarian did to you expanded your range of hearing." );
		//	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00103', FALSE, NONE, 0.0, "", "Cortana : He's broadcasting on an infrasonic frequency, it's the same one the towers used to communicate with his satellite." );
	//		dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00123', FALSE, NONE, 0.0, "", "Master Chief : Can we use it against him?" );
	//		dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00124', FALSE, NONE, 0.0, "", "Cortana : You bet we can. Next time he pulls that trick, we can track his precise location on the satellite." );
	//		dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00125', FALSE, NONE, 0.0, "", "Cortana : Maybe even turn some of his own toys against him." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dlg_spire_02_second_intro()
dprint( "f_dlg_spire_02_second_intro" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_GONDOLA_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );				
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, there's a lot more comm traffic passing through this tower than just what's servicing the Didact's satellite." );
	//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00101', FALSE, NONE, 0.0, "", "Master Chief : So we shut the entire facility down." );
		//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00102', FALSE, NONE, 0.0, "", "Cortana : Probably not as fast as simply overloading it." );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00101', FALSE, NONE, 0.0, "", "Cortana : These systems use data attenuators to regulate the flow of communications. Destroying those would drown out the defense spire instructions." );
	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00102', FALSE, NONE, 0.0, "", "Cortana : The towers's instructions to the Didact's shields would be drowned in the noise." );
		sleep_s(0.25);
		//hud_rampancy_players_set( 0.5 );
		//sleep_s(2);
		//hud_rampancy_players_set( 0.0 );
		f_m70_objective_set(ct_obj_spire_02);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dlg_spire_02_second_cores_enter()
dprint( "f_dlg_spire_02_second_cores_enter" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_ATTENUATOR_INSIDE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00105', FALSE, NONE, 0.0, "", "Cortana : The tower's attenuator would most likely be housed in a Faraday enclosure." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00106', FALSE, NONE, 0.0, "", "Cortana : Let's see if we can find its controls around here somewhere…" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	f_blip_flag (flg_spire02_switch, "activate");
	b_spire_02_button_active = TRUE;
end


script dormant f_dlg_spire_02_second_cores_start()
dprint( "f_dlg_spire_02_second_cores_start" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_FIRST_BUTTON_PUSHED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00107', FALSE, NONE, 0.0, "", "Cortana : OK, the structure actually contains three central attenuators. We'll have to sever all three connections." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dlg_spire_02_second_cores_destroyed_1()
dprint( "f_dlg_spire_02_second_cores_destroyed_1" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_ATTENUATOR_PUSHED_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
	  dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00108', FALSE, NONE, 0.0, "", "Cortana : Nicely done, Chief. Two more to go." );
		dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00111', FALSE, NONE, 0.0, "", "Didact : Your actions tread between honor and foolishness." );
		dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00112', FALSE, NONE, 0.0, "", "Master Chief : Cortana, are you hearing him?" );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00113', FALSE, NONE, 0.0, "", "Cortana : No. Didact?" );
		//dialog_line_didact( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00114', FALSE, NONE, 0.0, "", "Didact : I will retrieve the Composer and cage humanity, as I did with my Prometheans. You cannot doubt this." );
		//dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00115', FALSE, NONE, 0.0, "", "Didact : So then... which of us does this pointless resistence debase?" );
		//dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00116', FALSE, NONE, 0.0, "", "Master Chief : We've got to wrap this up. Where are the other targets?" );
		//hud_rampancy_players_set( 0.6 );
		//dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00117', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );
	//	dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00118', FALSE, NONE, 0.0, "", "Master Chief : Cortana!?" );
	//	hud_rampancy_players_set( 0.0 );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dlg_spire_02_attenuator_pushed_02()
dprint( "f_dlg_spire_02_attenuator_pushed_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			
end

script dormant f_dlg_spire_02_second_cores_destroyed_3()
dprint( "f_dlg_spire_02_attenuator_pushed_03" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_ATTENUATOR_PUSHED_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00119', FALSE, NONE, 0.0, "", "Didact : You are a fool. Even now, your kind tinkers with the Composer in the shadow of the third ring. Children and fire, who disregard the welfare of the galaxy." );
	//	hud_rampancy_players_set( 0.6 );
	//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00120', FALSE, NONE, 0.0, "", "Cortana : GOT HIM!" );
	//	hud_rampancy_players_set( 0.0 );
		//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00121', FALSE, NONE, 0.0, "", "Cortana : Finally. Whatever the Librarian did to you expanded your range of hearing." );
	//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00103', FALSE, NONE, 0.0, "", "Cortana : He's broadcasting on an infrasonic frequency, it's the same one the towers used to communicate with his satellite." );
//		dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00123', FALSE, NONE, 0.0, "", "Master Chief : Can we use it against him?" );
//		dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00124', FALSE, NONE, 0.0, "", "Cortana : You bet we can. Next time he pulls that trick, we can track his precise location on the satellite." );
//		dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire2_cores_00125', FALSE, NONE, 0.0, "", "Cortana : Maybe even turn some of his own toys against him." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	sleep_s(2);
	wake(f_dlg_spire_02_second_end);
end

script dormant f_dlg_spire_02_second_end()
dprint( "f_dlg_spire_02_cores_leaving" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_CORES_LEAVING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );		
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00104', FALSE, NONE, 0.0, "", "Cortana : Success." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_rev_comm_spire2_cores_00105', FALSE, NONE, 0.0, "", "Cortana : The system's overloading. I don't think we'll be having any more trouble from those shields." );
		f_m70_objective_complete(ct_obj_spire_02 );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_02_button_01::: Dialog
script dormant f_dlg_spire_02_button_01()
dprint( "f_dlg_spire_02_button_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_BUTTON_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: <Says something about Button 1.>" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_02_button_02::: Dialog
script dormant f_dlg_spire_02_button_02()
dprint( "f_dlg_spire_02_button_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA <Says something about Button 2.>" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_02_button_03::: Dialog
script dormant f_dlg_spire_02_button_03()
dprint( "f_dlg_spire_02_button_03" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_02_BUTTON_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: <Says something about Button 3.>" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SPIRE: 03
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// variables
global long L_dlg_spire_03_cortana_02 			= DEF_DIALOG_ID_NONE();
global long L_dlg_spire_03_rampancy_03 			= DEF_DIALOG_ID_NONE();
global long L_dlg_spire_03_take_charge 			= DEF_DIALOG_ID_NONE();
global long L_dlg_spire_03_outro_01 				= DEF_DIALOG_ID_NONE();

// functions
// === f_dlg_spire_03_didact_01::: Dialog
/*script dormant f_dlg_spire_03_didact_01()
dprint( "f_dlg_spire_03_didact_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// On the way in, final reminder of what we're up to as Didact talks again
	l_dialog_id = dialog_start_foreground( "SPIRE_03_DIDACT_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
			dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00100', FALSE, NONE, 0.0, "", "Didact : The Librarian called you Reclaimer." );
			dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire3_00101', FALSE, NONE, 0.0, "", "Master Chief : The Didact's doing it again." );
			dialog_line_didact( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_spire3_00102', FALSE, NONE, 0.0, "", "Didact : And yet all you seek is suffering for those you would protect." );
			dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_spire3_00103', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );
			dialog_line_didact( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_spire3_00104', FALSE, NONE, 0.0, "", "Didact : Such hubris. Your kind are children, interferring in matters-" );
			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_spire3_00105', FALSE, NONE, 0.0, "", "Cortana : GOT HIM!" );
			dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_spire3_00106', FALSE, NONE, 0.0, "", "Cortana : He's broadcasting on an infrasonic frequency." );
			dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m70\m70_spire3_00107', FALSE, NONE, 0.0, "", "Cortana : Outside the range of human hearing, but apparently not all the rules apply to you anymore." );
			dialog_line_chief( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m70\m70_spire3_00108', FALSE, NONE, 0.0, "", "Master Chief : Can we use it against him?" );
			dialog_line_cortana( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m70\m70_spire3_00109', FALSE, NONE, 0.0, "", "Cortana : Yes we can." );
			dialog_line_cortana( l_dialog_id, 10, TRUE, 'sound\dialog\mission\m70\m70_spire3_00110', FALSE, NONE, 0.0, "", "Cortana : Tracking its point of origin. The Didact just painted himself a great big target." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/

// === f_dlg_spire_03_didact_02::: Dialog
script dormant f_dlg_flight_third_spire_03_approach()
dprint( "f_dlg_spire_03_exterior" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_foreground( "SPIRE_03_EXTERIOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_spire3_intro_00100', FALSE, NONE, 0.0, "", "Cortana : Those defense spires we keep running into are being controlled from this tower. Get me to the Control room and we might be able to reposition them to block the Didact's ship from leaving." );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dlg_spire_03_didact_taunt_01()
dprint( "f_dlg_spire_03_didact_taunt_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
		
	l_dialog_id = dialog_start_foreground( "SPIRE_BOTTOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00100', FALSE, NONE, 0.0, "", "Didact : You will relent, human, or you will perish. All in life is choice." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
/*	hud_rampancy_players_set( 0.4 );
		sleep_s(3);
		hud_rampancy_players_set( 0.0 );*/


end

script dormant f_dlg_spire_03_bottom_start()
dprint( "f_dlg_spire_03_top" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_foreground( "SPIRE_03_TOP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );			
  	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00112', FALSE, NONE, 0.0, "", "Cortana : He's altering the tower!" );
  
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end




script dormant f_dlg_spire_03_didact_top_of_tower()
dprint( "f_dlg_spire_03_didact_top_of_tower" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_foreground( "SPIRE_03_DIDACT_02_JETPACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );			
  	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00116', FALSE, NONE, 0.0, "", "Cortana : I'm seeing a control facility at the top of the tower. We need to be there yesterday!" );
  //	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_spire3_00112', FALSE, NONE, 0.0, "", "Cortana : He's altering the tower!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dlg_spire_03_elite_jumpers()
dprint( "f_dlg_spire_03_elite_jumpers" );


	 	if (unit_has_equipment (player0, "objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment")) or (unit_has_equipment (player0, "objects\equipment\storm_jet_pack\storm_jet_pack.equipment"))
	 	
	 	then
				wake(f_dlg_spire_03_didact_attack_02_jetpack);
		else
		    wake(f_dlg_spire_03_didact_attack_02_jetpack_none);
  	end
end




script dormant f_dlg_spire_03_didact_attack_02_jetpack()
dprint( "f_dlg_spire_03_didact_attack_02_jetpack" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_foreground( "SPIRE_03_DIDACT_02_JETPACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );		
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00114', FALSE, NONE, 0.0, "", "Cortana : Chief, your jetpack!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
   
end




script dormant f_dlg_spire_03_didact_attack_02_jetpack_none()
dprint( "f_dlg_spire_03_didact_attack_02_jetpack" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_foreground( "SPIRE_03_DIDACT_02_JETPACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );			
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_spire3_00115', FALSE, NONE, 0.0, "", "Cortana : Grab one of those Elite's jump packs!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	 
end


// === f_dlg_spire_03_rampancy_02::: Dialog
script dormant f_dlg_spire_03_control_room_start()
dprint( "f_dlg_spire_03_rampancy_02" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// Cortana gives instructions then is hit by rampancy
	l_dialog_id = dialog_start_foreground( "SPIRE_03_RAMPANCY_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00101', FALSE, NONE, 0.0, "", "Cortana : Quick, let me at the spire controls." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_03_rampancy_03::: Dialog
script dormant f_dlg_spire_03_rampancy_03()
dprint( "f_dlg_spire_03_rampancy_03" );

	// Something catastrophically bad happens outside the window
	L_dlg_spire_03_rampancy_03 = dialog_start_foreground( "SPIRE_03_RAMPANCY_03", L_dlg_spire_03_rampancy_03, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_chief( L_dlg_spire_03_rampancy_03, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: Cortana!" );
	L_dlg_spire_03_rampancy_03 = dialog_end( L_dlg_spire_03_rampancy_03, TRUE, TRUE, "" );

	// start rampancy loop

end


// === f_dlg_spire_03_chief_01::: Dialog
script dormant f_dlg_spire_03_chief_01()
dprint( "f_dlg_spire_03_chief_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_03_CHIEF_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_chief( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: The optimal path...looks like up is the way to go." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_03_cortana_01::: Dialog
script dormant f_dlg_spire_03_cortana_01()
dprint( "f_dlg_spire_03_cortana_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// Cortana is back in business
	l_dialog_id = dialog_start_foreground( "SPIRE_03_CORTANA_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Hey, you aren't where I told you to go." );

		// XXX TODO - hook up real waypoint
		thread (story_blurb_add("other", "Cortana: <Puts up a waypoint.>") );
		sleep_s (1.5 );

		// XXX TODO - Do wee need to put up a real waypoint here? or remove the old one
		dialog_line_cortana( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Over there, Chief." );
		dialog_line_chief  ( l_dialog_id, 3, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: Are you sure?" );
		dialog_line_cortana( l_dialog_id, 4, TRUE, NONE, FALSE, NONE, 10.0, "", "CORTANA: You don't trust me?" ); // TIME IS PADDED IN THIS LINE

		dialog_line_chief  ( l_dialog_id, 5, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: I trust you." );
		dialog_line_cortana( l_dialog_id, 6, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Took you long enough to say so." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_03_cortana_02::: Dialog
script dormant f_dlg_spire_03_cortana_02()
dprint( "f_dlg_spire_03_cortana_02" );

	// Cortana is slotted and starts trying to close the Maw  - This gets called from CONTROL ROOM hsc
	L_dlg_spire_03_cortana_02 = dialog_start_foreground( "SPIRE_03_CORTANA_02", L_dlg_spire_03_cortana_02, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 0, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00102', FALSE, NONE, 0.0, "", "Cortana : Tapping into the spires' central net." );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 1, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00103', FALSE, NONE, 0.0, "", "Cortana : They're mine." );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 2, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00104', FALSE, NONE, 0.0, "", "Cortana : Now to…" );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 3, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00105', FALSE, NONE, 0.0, "", "Cortana : ...IMPRISON THEM?!?" );
			dialog_line_chief( L_dlg_spire_03_cortana_02, 4, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00106', FALSE, NONE, 0.0, "", "Master Chief : What are you doing?" );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 5, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00107', FALSE, NONE, 0.0, "", "Cortana : -- LIKE HE IMPRISONED HIS PROMETHEANS? LIKE DR. HALSEY IMPRISONED ME??" );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 6, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00108', FALSE, NONE, 0.0, "", "Cortana : Chief?" );
			dialog_line_chief( L_dlg_spire_03_cortana_02, 7, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00109', FALSE, NONE, 0.0, "", "Master Chief : His ship's online! They're leaving!" );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 8, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00110', FALSE, NONE, 0.0, "", "Cortana : Chief, I'm sorry. I don't know what-" );
			dialog_line_chief( L_dlg_spire_03_cortana_02, 9, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00111', FALSE, NONE, 0.0, "", "Master Chief : Track those Liches. We can go across them to get to the Didact's ship." );
			dialog_line_cortana( L_dlg_spire_03_cortana_02, 10, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00112', FALSE, NONE, 0.0, "", "Cortana : Wait. ACROSS them?!?" );
	L_dlg_spire_03_cortana_02 = dialog_end( L_dlg_spire_03_cortana_02, TRUE, TRUE, "" );
	
end

// === f_dlg_spire_03_door_01::: Dialog
script dormant f_dlg_spire_03_door_01()
dprint( "f_dlg_spire_03_door_01" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "SPIRE_03_DOOR_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_rev_spire3_intro_00100', FALSE, NONE, 0.0, "", "Cortana : Those defense spires we keep running into are being controlled from this tower. Get me to the Control room and we might be able to reposition them to block the Didact's ship from leaving." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dlg_spire_03_control_room::: Dialog
script dormant f_dlg_spire_03_control_room()
dprint( "f_dlg_spire_03_control_room" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// Enter the Control Room
	l_dialog_id = dialog_start_foreground( "SPIRE_03_CONTROL_ROOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00101', FALSE, NONE, 0.0, "", "Cortana : Quick, let me at the spire controls." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end


script dormant f_dlg_spire_03_control_room_fail()
dprint( "f_dlg_spire_03_control_room" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	// Enter the Control Room
	l_dialog_id = dialog_start_foreground( "SPIRE_03_CONTROL_ROOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00102', FALSE, NONE, 0.0, "", "Cortana : Tapping into the spires' central net." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00103', FALSE, NONE, 0.0, "", "Cortana : They're mine." );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00104', FALSE, NONE, 0.0, "", "Cortana : Now to…" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00105', FALSE, NONE, 0.0, "", "Cortana : ...IMPRISON THEM?!?" );
		dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00106', FALSE, NONE, 0.0, "", "Master Chief : What are you doing?" );
		dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00107', FALSE, NONE, 0.0, "", "Cortana : -- LIKE HE IMPRISONED HIS PROMETHEANS? LIKE DR. HALSEY IMPRISONED ME??" );
		dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00108', FALSE, NONE, 0.0, "", "Cortana : Chief?" );
		dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00109', FALSE, NONE, 0.0, "", "Master Chief : His ship's online! They're leaving!" );
		dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00110', FALSE, NONE, 0.0, "", "Cortana : Chief, I'm sorry. I don't know what-" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end




// === f_dlg_spire_03_take_charge::: Dialog
script dormant f_dlg_spire_03_take_charge()
dprint( "f_dlg_spire_03_take_charge" );

	// Chief takes charge and pulls Cortana from the console - This gets called from CONTROL ROOM hsc
	L_dlg_spire_03_take_charge = dialog_start_foreground( "SPIRE_03_TAKE_CHARGE", L_dlg_spire_03_take_charge, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
	//	dialog_line_chief  ( L_dlg_spire_03_take_charge, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: I'm getting you out of here." );
		
		if ( dialog_foreground_id_active_check(L_dlg_spire_03_take_charge) ) then
			//thread (story_blurb_add("other", "Cortana is back in Chief's head.") );
			sleep_s( 0.25 );
		end
		dialog_line_chief( L_dlg_spire_03_take_charge, 0, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00111', FALSE, NONE, 0.0, "", "Master Chief : Track those Liches. We can go across them to get to the Didact's ship." );
		hud_rampancy_players_set( 0.25 );	
		dialog_line_cortana( L_dlg_spire_03_take_charge, 1, TRUE, 'sound\dialog\mission\m70\m70_failmoment_00112', FALSE, NONE, 0.0, "", "Cortana : Wait. ACROSS them?!?" );
		dialog_line_cortana( L_dlg_spire_03_take_charge, 3, TRUE, 'sound\dialog\mission\global\global_MC_00100', FALSE, NONE, 0.0, "", "Master Chief : Yes." );
		dialog_line_cortana( L_dlg_spire_03_take_charge, 2, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00100', FALSE, NONE, 0.0, "", "Cortana : Um... there.... there are several Liches moving in formation towards the Didact's ship." );
		hud_rampancy_players_set( 0.0 );	
	L_dlg_spire_03_take_charge = dialog_end( L_dlg_spire_03_take_charge, TRUE, TRUE, "" );
	wake(f_dlg_spire_03_outro_01);
end

// === f_dlg_spire_03_outro_01::: Dialog
global short S_dlg_spire_03_outro_01_blip 				= 2;
script dormant f_dlg_spire_03_outro_01()

	L_dlg_spire_03_outro_01 = dialog_start_foreground( "SPIRE03_OUTRO01", L_dlg_spire_03_outro_01, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( L_dlg_spire_03_outro_01, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00102', FALSE, NONE, 0.0, "", "Cortana : We're only going to have one shot at this." );
			sleep_s(3);
			dialog_line_cortana( L_dlg_spire_03_outro_01, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00103', FALSE, NONE, 0.0, "", "Cortana : Okay, GO!" );
	L_dlg_spire_03_outro_01 = dialog_end( L_dlg_spire_03_outro_01, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// LICH TRAIN
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// LICH: JUMPS
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_lich_jump_01::: Dialog
script dormant f_dlg_lich_jump_01()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dlg_lich_jump_01" );

	// Chief starts to jump across the Liches
	l_dialog_id = dialog_start_foreground( "LICH_JUMP_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
//		dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Chief! What are you doing?!" );
	//	dialog_line_chief  ( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CHIEF: Improvising." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	thread(m70_objective_lich_nudge());
	
end

// === f_dlg_lich_jump_02::: Dialog
script dormant f_dlg_lich_jump_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dlg_lich_jump_02" );

	l_dialog_id = dialog_start_foreground( "LICH_JUMP_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00115', FALSE, NONE, 0.0, "", "Cortana : JUMP NOW!!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	
end


script dormant f_dlg_lich_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dlg_lich_02" );

	l_dialog_id = dialog_start_foreground( "LICH_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00104', FALSE, NONE, 0.0, "", "Cortana : Chief! The second Lich is moving up! Get ready!" );
				dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00105', FALSE, NONE, 0.0, "", "Cortana : Here they come - off to the right." );
				dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00107', FALSE, NONE, 0.0, "", "Cortana : Other side!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	
end


script dormant f_dlg_lich_03()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dlg_lich_03" );
		kill_script(m70_objective_lich_nudge);
	l_dialog_id = dialog_start_foreground( "LICH_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00110', FALSE, NONE, 0.0, "", "Cortana : The Didact's ship's in range! One more jump should get us there!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00111', FALSE, NONE, 0.0, "", "Cortana : Lich! Starboard side!" );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00112', FALSE, NONE, 0.0, "", "Cortana : Lich! Off the Port bow!" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00113', FALSE, NONE, 0.0, "", "Cortana : Line up, Chief!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	
end



// === f_dlg_lich_jump_03::: Dialog
script dormant f_dlg_lich_jump_03()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dlg_lich_jump_03" );

	l_dialog_id = dialog_start_foreground( "LICH_JUMP_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00114', FALSE, NONE, 0.0, "", "Cortana : It's too far!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00115', FALSE, NONE, 0.0, "", "Cortana : JUMP NOW!!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// LICH: SCANNED PLAYER
// -------------------------------------------------------------------------------------------------
// variables
global long L_dlg_scanned_player = DEF_DIALOG_ID_NONE();

// functions
// === f_dlg_lich_scanned_player::: Dialog
script static void f_dlg_lich_scanned_player()
dprint( "f_dlg_lich_scanned_player" );

	// Player has been scanned by the Didact in the lich train; could be on a lich or platform
	L_dlg_scanned_player = dialog_start_foreground( "LICH_SCANNED_PLAYER", L_dlg_scanned_player, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_cortana( L_dlg_scanned_player, 1, TRUE, NONE, FALSE, NONE, 0.25, "", "CORTANA: <TEMP> The Didact knows you're coming!" );
		dialog_line_cortana( L_dlg_scanned_player, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: <TEMP> I'm detecting a weapon firing from the ship!" );
	L_dlg_scanned_player = dialog_end( L_dlg_scanned_player, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// LICH: ATTACK PLATFORM
// -------------------------------------------------------------------------------------------------
// variables
global long L_dlg_attack_platform = DEF_DIALOG_ID_NONE();

// functions
// === f_dlg_lich_attack_platform::: Dialog
script static void f_dlg_lich_attack_platform()
dprint( "f_dlg_lich_attack_platform" );

	// Lich ship has taken damage after the didact scanned it (then attacked it or whatever he's doing)
	L_dlg_attack_platform = dialog_start_foreground( "LICH_attack_platform", L_dlg_attack_platform, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( L_dlg_attack_platform, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: <TEMP> GET OUT OF THERE!!!" );
	L_dlg_attack_platform = dialog_end( L_dlg_attack_platform, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// LICH: SCAN DAMAGE
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_lich_damage_start::: Dialog
script static void f_dlg_lich_damage_start()
dprint( "f_dlg_lich_damage_start" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();

	// Lich ship has taken damage after the didact scanned it (then attacked it or whatever he's doing)
	l_dialog_id = dialog_start_foreground( "LICH_DAMAGE_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
      dialog_line_cortana( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "Cortana : Didact scan damaged the lich's core!" );
	//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00104', FALSE, NONE, 0.0, "", "Cortana : Chief! The second Lich is moving up! Get ready!" );
	//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00105', FALSE, NONE, 0.0, "", "Cortana : Here they come - off to the right." );
	//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00107', FALSE, NONE, 0.0, "", "Cortana : Other side!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// -------------------------------------------------------------------------------------------------
// LICH: ABANDON SHIP!!!
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_dlg_lich_abandon_ship::: Dialog
script static void f_dlg_lich_abandon_ship( trigger_volume tv_volume, short s_line_min, short s_line_max )
dprint( "f_dlg_lich_abandon_ship" );
static long l_dialog_id = DEF_DIALOG_ID_NONE();
static boolean b_line_01_played = FALSE;
static boolean b_line_02_played = FALSE;
static boolean b_line_03_played = FALSE;
static boolean b_line_04_played = FALSE;

	if ( not dialog_foreground_id_active_check(l_dialog_id) ) then
	
		l_dialog_id = dialog_start_foreground( "LICH_ABANDON_SHIP", l_dialog_id, volume_test_players(tv_volume), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );

			static short s_play_line = 0;
			s_play_line = random_range( s_line_min, s_line_max );
	
			// find out if the line is still valid to play, if not, start at the top	
			if ( (s_play_line == 1) and (b_line_01_played) ) then
				s_play_line = s_line_min;
			end
			if ( (s_play_line == 2) and (b_line_02_played) ) then
				s_play_line = s_line_min;
			end
			if ( (s_play_line == 3) and (b_line_03_played) ) then
				s_play_line = s_line_min;
			end
			if ( (s_play_line == 4) and (b_line_04_played) ) then
				s_play_line = s_line_min;
			end


			// play unplayed line
			if ( (s_play_line <= 1) and (not b_line_01_played) ) then
				b_line_01_played = dialog_line_cortana( l_dialog_id, 1, volume_test_players(tv_volume), 'sound\dialog\mission\m70\m70_lichjump_00109', FALSE, NONE, 0.0, "", "Cortana : You can shoot Covenant later! We've got to go NOW!" );
				if ( b_line_01_played ) then
					s_play_line = 5;
				end
			end
			if ( (s_play_line <= 2) and (not b_line_02_played) ) then
				b_line_02_played = dialog_line_cortana( l_dialog_id, 2, volume_test_players(tv_volume), 'sound\dialog\mission\m70\m70_lichjump_00108', FALSE, NONE, 0.0, "", "Cortana : Don't worry about them! The Didact's getting away!" );
				if ( b_line_02_played ) then
					s_play_line = 5;
				end
			end
			if ( (s_play_line <= 3) and (not b_line_03_played) ) then
				b_line_03_played = dialog_line_cortana( l_dialog_id, 3, volume_test_players(tv_volume),'sound\dialog\mission\m70\m70_lichjump_00109', FALSE, NONE, 0.0, "", "Cortana : You can shoot Covenant later! We've got to go NOW!" );
				if ( b_line_03_played ) then
					s_play_line = 5;
				end
			end
			if ( (s_play_line <= 4) and (not b_line_04_played) ) then
				b_line_04_played = dialog_line_cortana( l_dialog_id, 4, volume_test_players(tv_volume), 'sound\dialog\mission\m70\m70_lichjump_00108', FALSE, NONE, 0.0, "", "Cortana : Don't worry about them! The Didact's getting away!" );
				if ( b_line_04_played ) then
					s_play_line = 5;
				end
			end
			
		l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
		
	end
	
end

/*
// === f_dlg_<event>::: Dialog
script dormant f_dlg_<event>()
static long l_dialog_id = DEF_DIALOG_ID_NONE();

	if ( not dialog_xxx_id_active_check(l_dialog_id) ) then
	
		l_dialog_id = dialog_start_xxx( "str_name", l_dialog_id, b_condition, r_style, b_foreground_interruptable, "", 0.0 );
			dialog_line_chief( l_dialog_id, s_line_index, TRUE, NONE, FALSE, NONE, 0.0, "", str_debug );
			dialog_line_cortana( l_dialog_id, s_line_index, TRUE, NONE, FALSE, NONE, 0.0, "", str_debug );
			dialog_line_other( l_dialog_id, s_line_index, TRUE, NONE, FALSE, NONE, 0.0, "", str_debug );
		l_dialog_id = dialog_end( l_dialog_id, b_active_invalidates, "" );
		
	end

end
*/



// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

script static void f_dialog_m70_nudge_1()
dprint( "f_dialog_m70_nudge_1" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 4);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_1_03_a", l_dialog_id, (not b_objective_1_complete), DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00104', FALSE, NONE, 0.0, "", "Cortana : Infinity's going to leave Requiem any minute. We've got to go." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_1_b", l_dialog_id, (not b_objective_1_complete), DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00105', FALSE, NONE, 0.0, "", "Cortana : Get to the Pelican, Chief." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "didact_scientist_03_c", l_dialog_id, (not b_objective_1_complete), DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_infinity_dock_00106', FALSE, NONE, 0.0, "", "Cortana : If we're going to stop the Didact from getting this Composer, we should find that Pelican A-SAP." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );

	end


end

script static void f_dialog_m70_nudge_2()
dprint( "f_dialog_m70_nudge_2" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 6);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_2_a", l_dialog_id, (not b_objective_2_complete), DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m70\m70_infinity_launch_tube_00107', FALSE, NONE, 0.0, "", "Cortana : Initiate the launch sequence, Chief." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_2_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m70\m70_infinity_launch_tube_00109', FALSE, NONE, 0.0, "", "Cortana : Infinity's ready to leave Requiem. If we're doing this, it has to be now." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_2_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m70\m70_infinity_launch_tube_00110', FALSE, NONE, 0.0, "", "Cortana : The Didact won't wait forever. We need to go." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 4 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_2_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m70\m70_infinity_launch_tube_00108', FALSE, NONE, 0.0, "", "Cortana : Look, we can't BOTH have second thoughts. Get us out of here." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 5 then
		l_dialog_id = dialog_start_foreground( "f_dialog_m70_nudge_2_e", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m70\m70_infinity_launch_tube_00111', FALSE, NONE, 0.0, "", "Cortana : What are you waiting for? Launch." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end
script static void f_dialog_m70_nudge_3()
dprint( "f_dialog_m70_nudge_3" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();

		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_3_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_3b", l_dialog_id,  (not b_objective_3b_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_3_complete), 'sound\dialog\mission\m70\m70_rev_all_1st_flight_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, head for one of those locations. Bringing those towers down's the only way we're going to reach the Didact." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_3b_complete, b_objective_3b_complete, "" );
		end

end



script static void f_dialog_m70_nudge_4()
dprint("f_dialog_m70_nudge_4");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_4_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_4", l_dialog_id,  (not b_objective_4_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_4_complete), 'sound\dialog\mission\m70\m70_spire1_gondolas_00110', FALSE, NONE, 0.0, "", "Cortana : Get back to the Gondola, Chief." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_4_complete, b_objective_4_complete, "" );
		end
end



script static void f_dialog_m70_lich_nudge()
dprint("f_dialog_m70_lich_nudge");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_4_complete)) then
					l_dialog_id = dialog_start_foreground( "LICH_NUDGE", l_dialog_id,  (not b_objective_4_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m70\m70_lichjump_00109', FALSE, NONE, 0.0, "", "Cortana : You can shoot Covenant later! We've got to go NOW!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_4_complete, b_objective_4_complete, "" );
		end
end

script static void f_dialog_m70_callout_reinforcements()
dprint("f_dialog_callout_reinforcements");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "REINFORCEMENTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00149', FALSE, NONE, 0.0, "", "Cortana : Reinforcements!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_knight()
dprint("f_dialog_callout_knight");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "KNIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00164', FALSE, NONE, 0.0, "", "Cortana : Knight!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script static void f_dialog_m70_callout_more_knights()
dprint("f_dialog_callout_more_knights");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_KNIGHTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00157', FALSE, NONE, 0.0, "", "Cortana : More knights!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_look_out()
dprint("f_dialog_callout_look_out");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LOOK_OUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00137', FALSE, NONE, 0.0, "", "Cortana : Look out!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_atta_boy()
dprint("f_dialog_callout_atta_boy");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LOOK_OUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00238', FALSE, NONE, 0.0, "", "Cortana : Atta boy, Chief." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script static void f_dialog_m70_callout_stragglers()
dprint("f_dialog_callout_atta_boy");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "STRAGGLERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00246', FALSE, NONE, 0.0, "", "Cortana : We've still got some stragglers." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_more_prometheans()
dprint("f_dialog_callout_more_prometheans");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_PROMETHEANS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00166', FALSE, NONE, 0.0, "", "Cortana : More Prometheans!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_inbound()
dprint("f_dialog_callout_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00128', FALSE, NONE, 0.0, "", "Cortana : Inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m70_callout_covenant()
dprint("f_dialog_m70_callout_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00120', FALSE, NONE, 0.0, "", "Cortana : Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end