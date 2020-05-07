//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// Mission: 				m80
//
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// DIALOG
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DIALOG: LICHRIDE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
static boolean b_temp = FALSE;	// THIS IS JUST HERE UNTIL THE FILE GETS USED


/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DIALOG: LICHRIDE: HIJACK
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global long L_dlg_lichride_hijack_enter_start = 				DEF_DIALOG_ID_NONE();
global long L_dlg_lichride_hijack_kill_reminder = 			DEF_DIALOG_ID_NONE();
global long L_dlg_lichride_hijack_control_reminder = 		DEF_DIALOG_ID_NONE();
global long L_dlg_lichride_hijack_control_seen = 				DEF_DIALOG_ID_NONE();
global long L_dlg_lichride_hijack_complete = 						DEF_DIALOG_ID_NONE();

*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// DIALOG: LICHRIDE: HIJACK
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global long L_dlg_crash_landing = 										DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_intro = 									DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_raise = 									DEF_DIALOG_ID_NONE();
global long L_dlg_pre_lab_thruster_intro =						DEF_DIALOG_ID_NONE();
global long L_dlg_prelab_door_controls = 							DEF_DIALOG_ID_NONE();
global long L_dlg_m80_atrium_defenses_offline = 			DEF_DIALOG_ID_NONE();
global long L_dlg_post_atrium_officer = 							DEF_DIALOG_ID_NONE();
global long L_dlg_lookout_rampancy = 									DEF_DIALOG_ID_NONE();
global long L_dlg_lookout_success = 									DEF_DIALOG_ID_NONE();
global long L_dlg_atrium_return = 										DEF_DIALOG_ID_NONE();
global long L_dlg_mantis_scientist_01 = 							DEF_DIALOG_ID_NONE();
global long L_dlg_lab_scientist_01 = 									DEF_DIALOG_ID_NONE();
global long L_dlg_lab_scientist_02 = 									DEF_DIALOG_ID_NONE();
global long L_dlg_lab_scientist_03 = 									DEF_DIALOG_ID_NONE();
global long L_dlg_lab_scientist_04 = 									DEF_DIALOG_ID_NONE();
global long L_dlg_lab_scientist_05 = 									DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_01 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_02 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_03 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_04 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_05 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_horseshoe_scientist_06 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_mantis_scientist_02 = 							DEF_DIALOG_ID_NONE();
global long L_dlg_mantis_inversion = 									DEF_DIALOG_ID_NONE();
global long L_dlg_atrium_group_03_orders = 						DEF_DIALOG_ID_NONE();
global long L_dlg_m80_prelab_composer_02 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_m80_horseshoe_exit_02 = 						DEF_DIALOG_ID_NONE();
global long L_dlg_m80_airlock_hall = 									DEF_DIALOG_ID_NONE();
global long L_dlg_m80_post_atrium =             			DEF_DIALOG_ID_NONE();
global long L_dlg_m80_airlock_two_few_left =     			DEF_DIALOG_ID_NONE();
global long l_dialog_m80_atrium_hallway =     				DEF_DIALOG_ID_NONE();
global long l_dlg_atrium_vignette_composer_leaving =  DEF_DIALOG_ID_NONE();
global long l_dlg_atrium_battle =  										DEF_DIALOG_ID_NONE();
global long l_dlg_atrium_elevator =  									DEF_DIALOG_ID_NONE();


// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

global short S_dlg_crash_landing_objective_line_index = 7;
//global short S_dlg_crash_landing_objective_blip_index = 8;
script dormant f_dialog_m80_crash_landing()
local long l_timer = 0;
//dprint("f_dialog_m80_crash_landing");
					
            L_dlg_crash_landing = dialog_start_foreground( "CRASH_LANDING", L_dlg_crash_landing, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );
            			hud_rampancy_players_set( 0.25 );
								dialog_line_cortana( L_dlg_crash_landing, 0, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00100', FALSE, NONE, 0.0, "", "Cortana: I’m sorry - I just... can't stop them!" );
            			hud_rampancy_players_set( 0.50 );
								dialog_line_cortana( L_dlg_crash_landing, 1, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00102', FALSE, NONE, 0.0, "", "Cortana: It's like a thousand of me arguing all at once!" );
            			hud_rampancy_players_set( 0.0 );
						//		dialog_line_chief( L_dlg_crash_landing, 2, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00101', FALSE, NONE, 0.0, "", "Master Chief: I know." );
						//		dialog_line_cortana( L_dlg_crash_landing, 3, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00103', FALSE, NONE, 0.0, "", "Cortana: That this station is already lost, that we’ll never find Halsey…" );
						//		dialog_line_chief( L_dlg_crash_landing, 4, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00104', FALSE, NONE, 0.0, "", "Master Chief: You got us here. That’s all that matters." );
								
								hud_play_pip_from_tag( "bink\campaign\M80_A_60");
								start_radio_transmission( "tillson_transmission_name");
								l_timer = timer_stamp( frames_to_seconds(sound_max_time('sound\dialog\mission\m80\m80_crashlanding_00106_pip.sound')) );
								
								dialog_line_chief_subtitle( L_dlg_crash_landing, 2, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00105.sound', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson, are you there?" );
								dialog_line_npc_subtitle( L_dlg_crash_landing, 3, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00106.sound', FALSE, NONE, 0.0, "", "Dr. Tillson: Oh, thank god! When your signal cut off I di-", TRUE);
								dialog_line_chief_subtitle( L_dlg_crash_landing, 4, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00107.sound', FALSE, NONE, 0.0, "", "Master Chief: Doctor, listen to me -you have to issue the order to evacuate the station." );
								dialog_line_npc_subtitle( L_dlg_crash_landing, 5, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00108.sound', FALSE, NONE, 0.0, "", "Dr. Tillson: We’ve been trying! The Covenant... they’ve already taken over the landing bays.", TRUE);
								dialog_line_chief_subtitle( L_dlg_crash_landing, 7, TRUE, 'sound\dialog\mission\m80\m80_crashlanding_00109.sound', FALSE, NONE, 0.0, "", "Master Chief: Send me your coordinates. I’ll see what I can do about clearing an evac route on my way to you." );
								//dialog_line_chief( L_dlg_crash_landing, 8, TRUE, NONE, FALSE, NONE, 0.0, "", "Master Chief: One one seven out." );
								
								dprint( "f_dialog_m80_crash_landing: pip time remaining" );
								inspect( timer_remaining(l_timer) );
								
								sleep_until( timer_expired(l_timer), 1 );
								end_radio_transmission();

            L_dlg_crash_landing = dialog_end( L_dlg_crash_landing, TRUE, TRUE, "" );
					

end

global short S_dlg_horseshoe_intro_objective_line_index = 1;
script dormant f_dialog_m80_horseshoe_intro()
//dprint("f_dialog_m80_horseshoe_intro");
					
					if ( not f_objective_current_check(DEF_R_OBJECTIVE_HORSESHOE_SHIELD()) ) then

            L_dlg_horseshoe_intro = dialog_start_foreground( "HORSESHOE_INTRO", L_dlg_horseshoe_intro, (not shield_controls_on), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_chief( L_dlg_horseshoe_intro, 0, (not shield_controls_on), 'sound\dialog\mission\m80\m80_horseshoe_00100', FALSE, NONE, 0.0, "", "Master Chief: What can we do to keep the Covenant out?" );
								dialog_line_cortana( L_dlg_horseshoe_intro, 1, (not shield_controls_on), 'sound\dialog\mission\m80\m80_horseshoe_00101', FALSE, NONE, 0.0, "", "Cortana: The Harbormaster Controls can erect an emergency barricade over the bay, but we’ll have to locate them." );
            L_dlg_horseshoe_intro = dialog_end( L_dlg_horseshoe_intro, TRUE, TRUE, "" );

					end

end
/*
global short S_dlg_horseshoe_center_restock_blip_line_index = 2;
script dormant f_dialog_m80_horseshoe_center_restock()
//dprint("f_dialog_m80_horseshoe_center_restock");
					
            L_dlg_horseshoe_center_restock = dialog_start_foreground( "HORSESHOE_CENTER_RESTOCK", L_dlg_horseshoe_center_restock, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_npc( L_dlg_horseshoe_center_restock, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00102', FALSE, NONE, 0.0, "", "Scientist 1: A Spartan? Thank the frickin’ UNSC.", TRUE);
								dialog_line_chief( L_dlg_horseshoe_center_restock, 1, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00103', FALSE, NONE, 0.0, "", "Master Chief: Where are the Harbormaster Controls?" );
								dialog_line_npc( L_dlg_horseshoe_center_restock, 2, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00104', FALSE, NONE, 0.0, "", "Scientist 1: End of the second platform but what’s that gonna do?!?", TRUE);
            L_dlg_horseshoe_center_restock = dialog_end( L_dlg_horseshoe_center_restock, TRUE, TRUE, "" );
					

end
*/
script dormant f_dialog_m80_horseshoe_scientist_01()
	//dprint("f_dialog_m80_horseshoe_scientist_01");
					
            L_dlg_horseshoe_scientist_01 = dialog_start_background("HORSESHOE_SCIENTIST_01", L_dlg_horseshoe_scientist_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_horseshoe_scientist_01, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00105', FALSE, humans_hs_center_oni_civ.spawn_points_1, 0.0, "", "Where's Jesse?!? JESSE!!", FALSE);
            L_dlg_horseshoe_scientist_01 = dialog_end( L_dlg_horseshoe_scientist_01, TRUE, TRUE, "" );
				thread( f_horseshoe_narrative_scientist_01_trigger(humans_hs_center_oni_civ.spawn_points_1) );
		
		
end
script dormant f_dialog_m80_quarantine_on()
//dprint("f_dialog_m80_horseshoe_wrong_platform");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "QUARANTINE_ON", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_sysvoice_00101', FALSE, m80_quarantine_01_target, 0.0, "", "System Voice: Emergency quarantine in effect. Stand by." , TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_quarantine_off()
//dprint("f_dialog_m80_horseshoe_wrong_platform");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "QUARANTINE_OFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_sysvoice_00102', FALSE, m80_quarantine_01_target, 0.0, "", "System Voice: Emergency quarantined released!" , TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_horseshoe_scientist_02()
	//dprint("f_dialog_m80_horseshoe_scientist_02");
					
            L_dlg_horseshoe_scientist_02 = dialog_start_background("HORSESHOE_SCIENTIST_02",  L_dlg_horseshoe_scientist_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai(  L_dlg_horseshoe_scientist_02, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00114', FALSE, humans_hs_right_sci_flee.spawn_points_1, 0.0, "", "SCIENTIST: They're killing everybody!", FALSE);
             L_dlg_horseshoe_scientist_02 = dialog_end(  L_dlg_horseshoe_scientist_02, TRUE, TRUE, "" );
				//thread( f_horseshoe_narrative_scientist_02_trigger(humans_hs_right_sci_flee.spawn_points_1) );
		
		
end

script dormant f_dialog_m80_horseshoe_scientist_03()
	//dprint("f_dialog_m80_horseshoe_scientist_03");
					
            L_dlg_horseshoe_scientist_03 = dialog_start_background("HORSESHOE_SCIENTIST_03", L_dlg_horseshoe_scientist_03, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_horseshoe_scientist_03, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_00106', FALSE, humans_hs_right_sci_flee.spawn_points_4, 0.0, "", "SCIENTIST: Don’t leave us!", FALSE);
            L_dlg_horseshoe_scientist_03 = dialog_end( L_dlg_lab_scientist_03, TRUE, TRUE, "" );
				thread( f_horseshoe_narrative_scientist_03_trigger(humans_hs_right_sci_flee.spawn_points_4) );
		
		
end

script dormant f_dialog_m80_horseshoe_scientist_04()
	//dprint("f_dialog_m80_horseshoe_scientist_04");
					
            L_dlg_horseshoe_scientist_04 = dialog_start_background("HORSESHOE_SCIENTIST_04", L_dlg_horseshoe_scientist_04, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_horseshoe_scientist_04, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00101', FALSE, humans_hs_right_sci_flee.spawn_points_3, 0.0, "", "SCIENTIST: How is this even happening?", FALSE);
            L_dlg_horseshoe_scientist_04 = dialog_end( L_dlg_lab_scientist_04, TRUE, TRUE, "" );
				thread( f_horseshoe_narrative_scientist_04_trigger(humans_hs_right_sci_flee.spawn_points_3) );
		
		
end

script dormant f_dialog_m80_horseshoe_scientist_05()
	//dprint("f_dialog_m80_horseshoe_scientist_05");
					
            L_dlg_horseshoe_scientist_05 = dialog_start_background("HORSESHOE_SCIENTIST_05", L_dlg_horseshoe_scientist_05, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_horseshoe_scientist_05, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00110', FALSE, humans_hs_center_oni_civ.spawn_points_0, 0.0, "", "SCIENTIST: How'd the UNSC get here so fast?", FALSE);
            L_dlg_horseshoe_scientist_05 = dialog_end( L_dlg_lab_scientist_05, TRUE, TRUE, "" );
				thread( f_horseshoe_narrative_scientist_05_trigger(humans_hs_center_oni_civ.spawn_points_0) );
		
		
end
script dormant f_dialog_m80_horseshoe_scientist_06()
	//dprint("f_dialog_m80_horseshoe_scientist_06");
					
            L_dlg_horseshoe_scientist_06 = dialog_start_background("HORSESHOE_SCIENTIST_03", L_dlg_horseshoe_scientist_06, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_horseshoe_scientist_06, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_scream_00101', FALSE, humans_hs_right_sci_flee.spawn_points_2, 0.0, "", "SCIENTIST: Scream", FALSE);
            L_dlg_horseshoe_scientist_06 = dialog_end( L_dlg_horseshoe_scientist_06, TRUE, TRUE, "" );
			//	thread( f_horseshoe_narrative_scientist_06_trigger(humans_hs_right_sci_flee.spawn_points_2) );
		
		
end

/*
script static void f_dlg_scientist_01()
//dprint( "f_dlg_scientist_01" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_background( "didact_scientist_01_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00100', FALSE, NONE, 0.0, "", "Scientist 1: There's more of them!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_background( "didact_scientist_01_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00110', FALSE, NONE, 0.0, "", "Scientist 1: How'd the UNSC get here so fast?" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_background( "didact_scientist_01_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00106', FALSE, NONE, 0.0, "", "Scientist 1: It's a Spartan!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif s_random == 4 then
		l_dialog_id = dialog_start_background( "didact_scientist_01_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00112', FALSE, NONE, 0.0, "", "Scientist 1: Fight back!!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end


script static void f_dlg_scientist_03()
//dprint( "f_dlg_scientist_03" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_background( "didact_scientist_03_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00101', FALSE, NONE, 0.0, "", "Scientist 3: We can't stay here!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_background( "didact_scientist_03_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00105', FALSE, NONE, 0.0, "", "Scientist 3: Where's Jesse?!? JESSE!!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_background( "didact_scientist_03_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00107', FALSE, NONE, 0.0, "", "Scientist 3: You've got to help me!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif s_random == 4 then
		l_dialog_id = dialog_start_background( "didact_scientist_03_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00113', FALSE, NONE, 0.0, "", "Scientist 3: The Covenant just wasted one of the security teams! What chance do a bunch of archeologists have?!?" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end


script static void f_dlg_scientist_05()
//dprint( "f_dlg_scientist_05" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_background( "didact_scientist_05_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00102', FALSE, NONE, 0.0, "", "Scientist 5: This has to be a misunderstanding! We've got diplomatic status!");
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_background( "didact_scientist_05_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00104', FALSE, NONE, 0.0, "", "Scientist 5: You have to help me get back to my lab! I'm not just going to abandon all the work I've done in there!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_background( "didact_scientist_05_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00109', FALSE, NONE, 0.0, "", "Scientist 5: Give HIM your gun!" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif s_random == 4 then
		l_dialog_id = dialog_start_background( "didact_scientist_05_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00115', FALSE, NONE, 0.0, "", "Scientist 5: These hingeheads gotta want something, right???" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end


script static void f_dlg_scientist_04()
//dprint( "f_dlg_scientist_04" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "didact_scientist_04_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00103', FALSE, NONE, 0.0, "", "Scientist 4: How is this even happening?", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "didact_scientist_04_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00108', FALSE, NONE, 0.0, "", "Scientist 4: PLEASE! Protect us!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "didact_kill_warning_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00114', FALSE, NONE, 0.0, "", "Scientist 4: They're killing everybody!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif s_random == 4 then
		l_dialog_id = dialog_start_foreground( "didact_scientist_04_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_scientist_00111', FALSE, NONE, 0.0, "", "Scientist 4: What the hell do you think  you're doing?!? This is a RESEARCH lab, you idiots!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end
*/


script dormant f_dialog_m80_horseshoe_snipers()
//dprint("f_dialog_m80_horseshoe_snipers");
local long L_dlg_m80_horseshoe_snipers = DEF_DIALOG_ID_NONE();
					
            L_dlg_m80_horseshoe_snipers = dialog_start_foreground( "HORSESHOE_SNIPERS", L_dlg_m80_horseshoe_snipers, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
            		dialog_line_npc_ai( L_dlg_m80_horseshoe_snipers, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_snipers_00100', FALSE, sq_hs_left_ally_1.spawn_points_0, 0.0, "", "Scientist 1: Where are the other station cops?!?", FALSE);
            		dialog_line_npc_ai( L_dlg_m80_horseshoe_snipers, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_snipers_00101', FALSE, sq_hs_left_ally_2.spawn_points_0, 0.0, "", "Ivanoff Security 1: We need backup! Bay 7 Duty Port Baker!", FALSE);
            		dialog_line_npc_ai( L_dlg_m80_horseshoe_snipers, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_snipers_00102', FALSE, sq_hs_left_ally_2.spawn_points_0, 0.0, "", "Ivanoff Security 2: Spartan? How many of you are there?", FALSE);
            		dialog_line_npc_ai( L_dlg_m80_horseshoe_snipers, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_snipers_00103', FALSE, sq_hs_left_ally_2.spawn_points_0, 0.0, "", "Ivanoff Security 3: Guys, we can't hold this position!", FALSE);
            		dialog_line_npc_ai( L_dlg_m80_horseshoe_snipers, 4, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_snipers_00104', FALSE, sq_hs_left_ally_2.spawn_points_0, 0.0, "", "Ivanoff Security 2: Fall back! Fall back!", FALSE);
            L_dlg_m80_horseshoe_snipers = dialog_end( L_dlg_m80_horseshoe_snipers, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_horseshoe_premature()
//dprint("f_dialog_m80_horseshoe_premature");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HORSESHOE_PREMATURE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00105', FALSE, humans_hs_center_oni_civ.spawn_points_1, 0.0, "", "Scientist 1: Wait - where are you going?!?", TRUE);
					  		//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00106', FALSE, NONE, 0.0, "", "Scientist 2: Don’t leave us!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



global short S_dlg_horseshoe_raise_blip_index = 1;
script dormant f_dialog_m80_horseshoe_raise()
//dprint("f_dialog_m80_horseshoe_raise");
					
            L_dlg_horseshoe_raise = dialog_start_foreground( "HORSESHOE_RAISE", L_dlg_horseshoe_raise, (not shield_controls_on), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( L_dlg_horseshoe_raise, 1, (not shield_controls_on), 'sound\dialog\mission\m80\m80_horseshoe_00107', FALSE, NONE, 0.0, "", "Cortana: That's it! Raise the barricade!" );
            L_dlg_horseshoe_raise = dialog_end( L_dlg_horseshoe_raise, TRUE, TRUE, "" );
end



script dormant f_dialog_m80_horseshoe_wrong_platform()
//dprint("f_dialog_m80_horseshoe_wrong_platform");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HORSESHOE_WRONG_PLATFORM", l_dialog_id, (not shield_controls_on), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, (not shield_controls_on), 'sound\dialog\mission\m80\m80_horseshoe_00107a', FALSE, NONE, 0.0, "", "Cortana: Wrong platform, Chief! Dock controls are on the other one!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_horseshoe_nudge()
//dprint("f_dialog_m80_horseshoe_nudge");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HORSESHOE_NUDGE", l_dialog_id, (not shield_controls_on), DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, (not shield_controls_on), 'sound\dialog\mission\m80\m80_horseshoe_00107b', FALSE, NONE, 0.0, "", "Cortana: Now, before they collect for another assault! Raise the shields!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

/*
script dormant f_dialog_m80_horseshoe_shield_up()
//dprint("f_dialog_m80_horseshoe_shield_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				kill_script(f_horseshoe_narrative_nudge);	
				sleep_forever(f_horseshoe_narrative_nudge);
				sleep_forever(f_dialog_m80_horseshoe_wrong_platform);
				sleep_forever(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
            l_dialog_id = dialog_start_foreground( "HORSESHOE_SHIELD_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00107d', FALSE, NONE, 0.0, "", "Cortana: That will hold them off for a while." );	
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				wake(f_dialog_m80_horseshoe_exit);
				
end
*/

script dormant f_dialog_m80_shields_countdown()
//dprint("f_dialog_m80_shields_countdown");
local long l_dialog_id = DEF_DIALOG_ID_NONE();				
            l_dialog_id = dialog_start_background( "SHIELDS_COUNTDOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00107c', FALSE, shields_countdown, 0.0, "", "Ivanoff System Voice: Warning. Emergency Harbor Barricade engaged. Enacting in 5. 4. 3. 2. 1.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					kill_script(f_horseshoe_narrative_nudge);	
				sleep_forever(f_horseshoe_narrative_nudge);
				sleep_forever(f_dialog_m80_horseshoe_intro);
				sleep_forever(f_dialog_m80_horseshoe_wrong_platform);
				sleep_forever(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
				kill_script(f_dialog_m80_horseshoe_intro);
end
		


script dormant f_dialog_m80_horseshoe_exit()
//dprint("f_dialog_m80_horseshoe_exit");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					kill_script(f_horseshoe_narrative_nudge);	
				sleep_forever(f_horseshoe_narrative_nudge);
				sleep_forever(f_dialog_m80_horseshoe_wrong_platform);
				sleep_forever(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
				kill_script(f_horseshoe_narrative_wrong_platform);
				sleep_forever(f_dialog_m80_horseshoe_intro);
				kill_script(f_dialog_m80_horseshoe_intro);
				shield_controls_on = TRUE;
            l_dialog_id = dialog_start_foreground( "HORSESHOE_EXIT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
          //  		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00107c', FALSE, NONE, 0.0, "", "Ivanoff System Voice: Warning. Emergency Harbor Barricade engaged. Enacting in 5. 4. 3. 2. 1.", TRUE);
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00108', FALSE, NONE, 0.0, "", "Cortana: Dr. Tillson. Bay 7 is secure." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00109', FALSE, NONE, 0.0, "", "Cortana: You can begin prepping the evac shuttles. " );
								start_radio_transmission( "tillson_transmission_name");
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00110', FALSE, NONE, 0.0, "", "Dr. Tillson: Really?? That’s- that’s incredible!", TRUE);
								//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00111', FALSE, NONE, 0.0, "", "Dr. Tillson: Tim, Bay 7!", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
            thread(f_dialog_m80_horseshoe_exit_02());
end

script static void f_dialog_m80_horseshoe_exit_02()
	if ( L_dlg_m80_horseshoe_exit_02 == DEF_DIALOG_ID_NONE() ) then
    L_dlg_m80_horseshoe_exit_02 = dialog_start_background("BAY_7_TIM", L_dlg_m80_horseshoe_exit_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc( L_dlg_m80_horseshoe_exit_02, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00112', FALSE, 	NONE, 0.0, "", "Tim (Ivanoff PA): All hands! Bay 7, Level C-5 is cleared and available for evac! Again, this is not a drill! Bay 7, C-5!", TRUE);
    L_dlg_m80_horseshoe_exit_02 = dialog_end( L_dlg_m80_horseshoe_exit_02, TRUE, TRUE, "" ); 
	end
end

script dormant f_dialog_m80_prelab_composer()
//dprint("f_dialog_m80_prelab_composer");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "PRELAB_COMPOSER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_prelab_00100', FALSE, NONE, 0.0, "", "Cortana: He doesn’t know where the Composer is!" );
								thread(f_dialog_m80_prelab_composer_02());
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_prelab_00101', FALSE, NONE, 0.0, "", "Cortana: Didact knows the humans possess it but not where it is or if it’s active." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_prelab_00102', FALSE, NONE, 0.0, "", "Cortana: That’s why he sent the Covenant! They’re expendable..." );
								
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_m80_prelab_composer_02()
	if ( L_dlg_m80_prelab_composer_02 == DEF_DIALOG_ID_NONE() ) then
    L_dlg_m80_prelab_composer_02 = dialog_start_background("PRE_LAB_THRUSTER_INTRO", L_dlg_m80_prelab_composer_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc( L_dlg_m80_prelab_composer_02, 0, TRUE, 'sound\dialog\mission\m80\m80_prelab_00103', FALSE, NONE, 0.0, "", "Ivanoff PA: Attention! Station security’s just broken through to Emergency Station 12, A-11. Lifeboat access there is limited but functional! ES12, A-11!", TRUE);
    L_dlg_m80_prelab_composer_02 = dialog_end( L_dlg_m80_prelab_composer_02, TRUE, TRUE, "" ); 
	end
end


script static void f_dialog_pre_lab_thruster_intro()
	if ( L_dlg_pre_lab_thruster_intro == DEF_DIALOG_ID_NONE() ) then
    L_dlg_pre_lab_thruster_intro = dialog_start_background("PRE_LAB_THRUSTER_INTRO", L_dlg_pre_lab_thruster_intro, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc_ai( L_dlg_pre_lab_thruster_intro, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_thrusters_00101', FALSE, sq_to_lab_scientist_thruster.scientist, 0.0, "", "SCIENTIST: Help us! A pair of hunters forced their way in.", FALSE);
				dialog_line_npc_ai( L_dlg_pre_lab_thruster_intro, 1, not ai_allegiance_broken(player, human) and (f_ability_player_cnt('objects\equipment\storm_thruster_pack\storm_thruster_pack.equipment') <= 0), 'sound\dialog\mission\m80\m80_thrusters_00102', FALSE, sq_to_lab_scientist_thruster.scientist, 0.0, "", "SCIENTIST: Take this. It's calibrated for heavy armor.", FALSE);
				sleep_s( 0.5 );
				dialog_line_npc_ai( L_dlg_pre_lab_thruster_intro, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_thrusters_00105', FALSE, sq_to_lab_scientist_thruster.scientist, 0.0, "", "SCIENTIST: Please - help them!", FALSE);
    L_dlg_pre_lab_thruster_intro = dialog_end( L_dlg_pre_lab_thruster_intro, TRUE, TRUE, "" ); 
	end
end

script dormant f_dialog_m80_prelab_supply()
//dprint("f_dialog_m80_prelab_supply");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "PRELAB_SUPPLY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                 
            		start_radio_transmission( "tillson_transmission_name");
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_prelab_00104', FALSE, NONE, 0.0, "", "Dr. Tillson: It’s Sandy. I’m at the lab but something’s going on in there; the door controls aren’t responding. ", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_prelab_00105', FALSE, NONE, 0.0, "", "Dr. Tillson: Are you out there?", TRUE);
								end_radio_transmission();
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_prelab_00106', FALSE, NONE, 0.0, "", "Cortana: Almost, Doctor." );
            			hud_rampancy_players_set( 0.25 );
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_prelab_00107', FALSE, NONE, 0.0, "", "Cortana: It’s all going to be OK!" );
            			hud_rampancy_players_set( 0.0 );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end


script dormant f_dialog_m80_lab_hunter()
//dprint("f_dialog_m80_lab_hunter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "LAB_HUNTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00175', FALSE, NONE, 0.0, "", "Cortana: Hunters!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



global short S_dlg_prelab_door_controls_objective_line_index = 3;
script dormant f_dialog_m80_prelab_door_controls()
//dprint("f_dialog_m80_prelab_door_controls");
						sleep_s(3);
            L_dlg_prelab_door_controls = dialog_start_foreground( "PRELAB_DOOR_CONTROLS", L_dlg_prelab_door_controls, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );  
              
            		start_radio_transmission( "tillson_transmission_name");
								dialog_line_npc( L_dlg_prelab_door_controls, 0, TRUE, 'sound\dialog\mission\m80\m80_prelab_00108', FALSE, NONE, 0.0, "", "Dr. Tillson: Spartan? Are you alright?", TRUE);
								dialog_line_npc( L_dlg_prelab_door_controls, 1, TRUE, 'sound\dialog\mission\m80\m80_prelab_00109', FALSE, NONE, 0.0, "", "Dr. Tillson: It sounds like the end of the world out there!", TRUE);
								end_radio_transmission();
								dialog_line_chief( L_dlg_prelab_door_controls, 2, TRUE, 'sound\dialog\mission\m80\m80_prelab_00110', FALSE, NONE, 0.0, "", "Master Chief: Cortana. Door controls?" );
								dialog_line_cortana( L_dlg_prelab_door_controls, 3, TRUE, 'sound\dialog\mission\m80\m80_prelab_00111', FALSE, NONE, 0.0, "", "Cortana: Unintelligible rampancy garble." );
								dialog_line_cortana( L_dlg_prelab_door_controls, 4, TRUE, 'sound\dialog\mission\m80\m80_lab_door_prompt_00100', FALSE, NONE, 0.0, "", "Cortana: Over there!" );
								
            L_dlg_prelab_door_controls = dialog_end( L_dlg_prelab_door_controls, TRUE, TRUE, "" );
				wake(m80_lab_announcement);
end

script dormant f_dialog_m80_lab_announcement()
//dprint("f_dialog_m80_atrium_lab_announcement");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
				l_dialog_id = dialog_start_foreground( "ATRIUM_SCIENTISTS_COMPOSER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       			
						//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00100', FALSE, NONE, 0.0, "", "Ivanoff System Voice: Please be aware. Forerunner specimens should not be removed from Containment Lattice manually.", TRUE);
						//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00101', FALSE, NONE, 0.0, "", "Ivanoff System Voice: Use of the Examination Armature is mandatory.", TRUE);
			   l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
   
				
end


script static void f_dialog_m80_findings_abstract_fr_1534()
//dprint("f_dialog_m80_findings_abstract_fr_1534");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

		l_dialog_id = dialog_start_background("LAB_ABSTRACT_FR_1534", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								

			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00102', FALSE, lab_terminal_3, 0.0, "", "Scientist 5: Specimen 1534.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00103', FALSE, lab_terminal_3, 0.0, "", "Scientist 5: Initial findings suggest an imaging component, perhaps a piece of some large device or possibly a vehicle of some sort.", TRUE);
			dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00104', FALSE, lab_terminal_3, 0.0, "", "Scientist 5: Reticular hazing also implies use as a beam focuser; could have done double-duty as a weapon sight.", TRUE);
			dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00105', FALSE, lab_terminal_3, 0.0, "", "Scientist 5: Passing off to SPEC-WAR for further testing.", TRUE);
   l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						object_create(device_control_lab_terminal3);
							device_set_position_immediate(device_control_lab_terminal3, 0);
							thread(m80_control_lab_terminal3());
end

script static void f_dialog_m80_lab_specimen_fr_2006()
//dprint("f_dialog_m80_lab_specimen_fr_2006");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_background("LAB_SPECUMEN_FR_2006", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
			dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00106', FALSE, lab_terminal_1, 0.0, "", "Tim (Ivanoff PA): OK... Specimen 2006…", TRUE);
			dialog_line_radio( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00107', FALSE, lab_terminal_1, 0.0, "", "Tim (Ivanoff PA): Artifact is believed to be the Activation Index for Gamma Halo, based on anecdotal information from Alpha and Delta Halo mission logs.", TRUE);
			dialog_line_radio( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00108', FALSE, lab_terminal_1, 0.0, "", "Tim (Ivanoff PA): Key component in the activation and firing of the Halo weapon, a few of us have been speculating lately if it has secondary and tertiary purposes as well.", TRUE);
			dialog_line_radio( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00109', FALSE, lab_terminal_1, 0.0, "", "Tim (Ivanoff PA): Theories still forthcoming.", TRUE);
   l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						object_create(device_control_lab_terminal1);
							device_set_position_immediate(device_control_lab_terminal1, 0);
							thread(m80_control_lab_terminal1());
end

script static void f_dialog_m80_lab_specimen_fr_0815()
//dprint("f_dialog_m80_lab_specimen_fr_0815");
local long l_dialog_id = DEF_DIALOG_ID_NONE();


	l_dialog_id = dialog_start_background("LAB_SPECUMEN_FR_0815", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00110', FALSE, lab_terminal_2, 0.0, "", "Dr. Tillson: Specimen Eight-Fifteen, though that’s a bit misleading as we’ve been seeing these things all over the Halo.", TRUE);
				dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00111', FALSE, lab_terminal_2, 0.0, "", "Dr. Tillson: Icon is similar to other Forerunner glyphs, with the noted exception of a strong, vertical extrusion.", TRUE);
				dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00112', FALSE, lab_terminal_2, 0.0, "", "Dr. Tillson: Going to send this to Linguistics, but... I don’t know. My gut’s telling me there’s something else here.", TRUE);
				
				if IsNarrativeFlagSetOnAnyPlayer(13) == TRUE and (b_mantle_lab_object == FALSE) then
						dialog_line_cortana(l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_mantle_object_00101', FALSE, NONE, 0.0, "", "Cortana: It’s the same symbol we saw on Requiem. The Mantle of Responsibility. But what's it doing here?");
						b_mantle_lab_object = TRUE;
				end
		
   l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
      				object_create(device_control_lab_terminal2);
							device_set_position_immediate(device_control_lab_terminal2, 0);
							thread(m80_control_lab_terminal2());
					
end

script static void f_dialog_m80_lab_computer_04()
//dprint("f_dialog_m80_lab_computer_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "LAB_COMPUTER_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00100', FALSE, lab_terminal_4, 0.0, "", "Ivanoff System Voice: I’m sorry. We are currently experiencing system-wide outages. If you require immediate assistance, contact Infrastructure, 048.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				object_create(device_control_lab_terminal4);
				device_set_position_immediate(device_control_lab_terminal4, 0);
				thread(m80_control_lab_terminal4());
end

script static void f_dialog_m80_lab_halsey_audiolog()
//dprint("f_dialog_m80_lab_halsey_audiolog");
local long l_dlg_halsey_audiolog = DEF_DIALOG_ID_NONE();

	l_dlg_halsey_audiolog = dialog_start_background("LAB_HALSEY_AUDIOLOG", l_dlg_halsey_audiolog, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
                     			
				dialog_line_npc( l_dlg_halsey_audiolog, 0, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00113', FALSE, audio_log_object, 0.0, "", "Dr. Halsey: Catherine Halsey, personal observations - December 15, 2554.", TRUE);
				dialog_line_npc( l_dlg_halsey_audiolog, 1, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00114', FALSE, audio_log_object, 0.0, "", "Dr. Halsey: While the survey crews examining Gamma Halo may be what pass for experts at ONI now, they are woefully out of their league for a task of this scale.", TRUE);
				dialog_line_npc( l_dlg_halsey_audiolog, 2, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00115', FALSE, audio_log_object, 0.0, "", "Dr. Halsey: There has been one, somewhat startling discovery, however.", TRUE);
				dialog_line_npc( l_dlg_halsey_audiolog, 3, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00116', FALSE, audio_log_object, 0.0, "", "Dr. Halsey: One of the teams stumbled upon a device remarkably similar to the AI Matrix Compiler currently in use by the UNSC.", TRUE);
				dialog_line_npc( l_dlg_halsey_audiolog, 4, TRUE, 'sound\dialog\mission\m80\m80_lab_secondary_story_00117', FALSE, audio_log_object, 0.0, "", "Dr. Halsey: Seeing as how I designed that particular compiler, this finding, needless to say, has piqued my curiosity.", TRUE);
   l_dlg_halsey_audiolog = dialog_end( l_dlg_halsey_audiolog, TRUE, TRUE, "" );
   				object_create(device_control_lab_audiolog_sw);
	device_set_position_immediate(device_control_lab_audiolog_sw, 0);
	thread(m80_lab_halsey_audiolog());
				
end


script dormant f_dialog_m80_atrium_hallway()
dprint("f_dialog_m80_atrium_hallway VO function");
					
            l_dialog_m80_atrium_hallway = dialog_start_background( "ATRIUM_HALLWAY", l_dialog_m80_atrium_hallway, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
							dialog_line_radio( l_dialog_m80_atrium_hallway, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_hallway_00100', FALSE, NONE, 0.0, "", "STATION PA: Attention, attention. Lifeboat 12, A-11 is now filled to capacity and about to depart. Do not head to 12, A-11 - we're prepping additional shuttles out of Bay 7, C-5. Again, Lifeboat 12, A-11 is exausted and about to launch.", TRUE);
            l_dialog_m80_atrium_hallway = dialog_end( l_dialog_m80_atrium_hallway, TRUE, TRUE, "" );
			dprint("f_atrium_narrative_trigger VO complete");
end

/*
script dormant f_dialog_m80_atrium_enter()
//dprint("f_dialog_m80_atrium_enter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_00100', FALSE, NONE, 0.0, "", "Cortana: (Damnit) I should have known it wasn’t something small. Stupid." );

							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_00101', FALSE, NONE, 0.0, "", "Master Chief: What the Librarian showed me WAS small. This wasn’t you." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/


script dormant f_dialog_m80_atrium_scientist_01()
//dprint("f_dialog_m80_atrium_scientists");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "_SCIENTISTS_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_scientists_00100', FALSE, sq_lab_security_02.01, 0.0, "", "Scientist 1: Look, forget about the hardware. Get the data!", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_lab_scientist_01()
//dprint("f_dialog_m80_mantis_scientist_01");
					
            L_dlg_lab_scientist_01 = dialog_start_background("LAB_SCIENTIST", L_dlg_lab_scientist_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_lab_scientist_01, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_scientists_00100', FALSE, sq_lab_scientists.01, 0.0, "", "Scientist 1: Look, forget about the hardware. Get the data!", FALSE);
            L_dlg_lab_scientist_01 = dialog_end( L_dlg_lab_scientist_01, TRUE, TRUE, "" );
				//thread( f_lab_narrative_scientist_01_trigger(sq_lab_scientists.01) );
		
		
end



script dormant f_dialog_m80_lab_scientist_02()
	//dprint("f_dialog_m80_mantis_scientist_02");
					
            L_dlg_lab_scientist_02 = dialog_start_background("LAB_SCIENTIST", L_dlg_lab_scientist_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_lab_scientist_02, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_scientists_00103', FALSE, sq_lab_scientists.02, 0.0, "", "Scientist 4: I swear, just once it would be nice to have an assignment that doesn't end in people shooting at the science team.", FALSE);
            L_dlg_lab_scientist_02 = dialog_end( L_dlg_lab_scientist_02, TRUE, TRUE, "" );
				thread( f_lab_narrative_scientist_02_trigger(sq_lab_scientists.02) );
		
		
end

script dormant f_dialog_m80_lab_scientist_03()
	//dprint("f_dialog_m80_mantis_scientist_03");
					
            L_dlg_lab_scientist_03 = dialog_start_background("LAB_SCIENTIST", L_dlg_lab_scientist_03, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_lab_scientist_03, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00106', FALSE, sq_lab_security_02.01, 0.0, "", "Scientist 1: It's a Spartan!", FALSE);
            L_dlg_lab_scientist_03 = dialog_end( L_dlg_lab_scientist_03, TRUE, TRUE, "" );
				thread( f_lab_narrative_scientist_03_trigger(sq_lab_security_02.01) );
		
		
end

script dormant f_dialog_m80_lab_scientist_04()
	//dprint("f_dialog_m80_mantis_scientist_04");
					
            L_dlg_lab_scientist_04 = dialog_start_background("LAB_SCIENTIST", L_dlg_lab_scientist_04, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_lab_scientist_03, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_horseshoe_scientist_00102', FALSE, sq_lab_scientists.03, 0.0, "", "Scientist 5: This has to be a misunderstanding! We've got diplomatic status!", FALSE);
            L_dlg_lab_scientist_04 = dialog_end( L_dlg_lab_scientist_04, TRUE, TRUE, "" );
				thread( f_lab_narrative_scientist_04_trigger(sq_lab_scientists.03) );
		
		
end

script dormant f_dialog_m80_lab_scientist_05()
	//dprint("f_dialog_m80_mantis_scientist_05");
					
            L_dlg_lab_scientist_05 = dialog_start_background("LAB_SCIENTIST", L_dlg_lab_scientist_05, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc_ai( L_dlg_lab_scientist_05, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\M80_atrium_composer_00102', FALSE, sq_lab_scientists.02, 0.0, "", "Scientist 2: Is everyone OK?", FALSE);
            L_dlg_lab_scientist_05 = dialog_end( L_dlg_lab_scientist_05, TRUE, TRUE, "" );
				//thread( f_lab_narrative_scientist_05_trigger(sq_lab_scientists.02) );
		
		
end


script dormant f_dialog_m80_atrium_scientist_02()
	//dprint("f_dialog_m80_atrium_scientists");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_SCIENTISTS_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_scientists_00101', FALSE, NONE, 0.0, "", "Scientist 2: The Covenant already knew about this station. Why are they suddenly so interested in it now?", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_atrium_scientist_03()
//dprint("f_dialog_m80_atrium_scientists");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_SCIENTISTS_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_scientists_00102', FALSE, NONE, 0.0, "", "Scientist 3: Kenneth? I'm getting all sorts of wonky readings off the artifact. Not like when Jan's team disappeared. This is different.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_atrium_scientist_04()
//dprint("f_dialog_m80_atrium_scientists");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_SCIENTISTS_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_scientists_00103', FALSE, NONE, 0.0, "", "Scientist 4: I swear, just once it would be nice to have an assignment that doesn't end in people shooting at the science team.", FALSE);								
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_atrium_scientist_05()
//dprint("f_dialog_m80_atrium_scientists");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_SCIENTISTS_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_scientists_00104', FALSE, NONE, 0.0, "", "Scientist 5: Just in the last 5 minutes, I've seen a 300% spike in Cherenkov radiation. I'm still trying to figure out what it is...", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end


script dormant f_dialog_m80_mantis_scientist_01()
//dprint("f_dialog_m80_mantis_scientist_01");
					
            L_dlg_mantis_scientist_01 = dialog_start_background("MANTIS_SCIENTIST", L_dlg_mantis_scientist_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		sleep_until( S_atrium_mech_2_mantis_state > 2, 1 );              								
            		sleep_s( 0.25 );
								dialog_line_npc_ai( L_dlg_mantis_scientist_01, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_mantis_conversation1_00100', FALSE, sq_atrium_marines.convo_mech_02_marine_01, 0.0, "", "Marine 1: I thought you were the Mantis expert!", FALSE);
								dialog_line_npc( L_dlg_mantis_scientist_01, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_mantis_conversation1_00101', FALSE, bpd_atrium_mech_02, 0.0, "", "Mantis Pilot: I know how to use it to haul cargo, not shoot Covenant!", FALSE);
            L_dlg_mantis_scientist_01 = dialog_end( L_dlg_mantis_scientist_01, TRUE, TRUE, "" );
				thread( f_atrium_narrative_mantis_02_trigger(sq_atrium_marines.convo_mech_02_marine_01) );
	//thread( f_atrium_narrative_mantis_02_trigger(sq_atrium_scientists.convo_mech_02_female_01) );
		
		
end


script dormant f_dialog_m80_mantis_scientist_02()
//dprint("f_dialog_m80_mantis_scientist_02");
					
            L_dlg_mantis_scientist_02 = dialog_start_background("MANTIS_SCIENTIST_02", L_dlg_mantis_scientist_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( L_dlg_mantis_scientist_02, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_mantis_conversation2_00100', FALSE, bpd_atrium_mech_02, 0.0, "", "Mantis Pilot: The watch commander said he was sending down someone who knew how to use the weapons on these things.", FALSE);
								//dialog_line_npc_ai( L_dlg_mantis_scientist_02, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_mantis_conversation2_00101', FALSE, sq_atrium_marines.convo_mech_02_marine_01, 0.0, "", "Marine 1: Are you kidding? The watch commander's probably dead already!", FALSE);
            L_dlg_mantis_scientist_02 = dialog_end( L_dlg_mantis_scientist_02, TRUE, TRUE, "" ); 
				
			
end




script dormant f_dialog_m80_mantis_inversion_01()
//dprint("f_dialog_m80_mantis_inversion_01");
					
    L_dlg_mantis_inversion = dialog_start_background("MANTIS_INVERSION_01", L_dlg_mantis_inversion, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc_ai( L_dlg_mantis_inversion, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00100', FALSE, sq_atrium_marines.convo_mech_03_marine_01, 0.0, "", "MARINE X: We need to test the Mantis controls.", FALSE);
				dialog_line_npc_ai( L_dlg_mantis_inversion, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00101', FALSE, sq_atrium_marines.convo_mech_03_marine_01, 0.0, "", "MARINE X: Can you try looking up for me?", FALSE);
				sleep_s( 0.75 );
				dialog_line_npc( L_dlg_mantis_inversion, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00102', FALSE, bpd_atrium_mech_03, 0.0, "", "Mantis Pilot: On it...", FALSE);

				STR_atrium_mech_look_requested = "DOWN";
				sleep_until( STR_atrium_mech_look_direction == "DOWN", 1 );
				
				dialog_line_npc( L_dlg_mantis_inversion, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00103', FALSE, bpd_atrium_mech_03, 0.0, "", "Mantis Pilot: What idiot inverted the controls!?!?!", FALSE);

				STR_atrium_mech_look_requested = "";
				sleep_s( 0.5 );
				dialog_line_npc_ai( L_dlg_mantis_inversion, 4, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00104', FALSE, sq_atrium_marines.convo_mech_03_marine_01, 0.0, "", "MARINE X: There's a switch in the options panel you can toggle.", FALSE);
				sleep_s( 0.5 );
				dialog_line_npc( L_dlg_mantis_inversion, 5, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00105', FALSE, bpd_atrium_mech_03, 0.0, "", "Mantis Pilot: Yeah, yeah... I just found it.", FALSE);
				
				STR_atrium_mech_look_requested = "UP";
				sleep_until( STR_atrium_mech_look_direction == "UP", 1 );
				sleep_s( 0.5 );
				
				dialog_line_npc( L_dlg_mantis_inversion, 6, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00106', FALSE, bpd_atrium_mech_03, 0.0, "", "Mantis Pilot: Way better!!!", FALSE);
				sleep_s( 0.5 );

				STR_atrium_mech_look_requested = "";

				dialog_line_npc( L_dlg_mantis_inversion, 8, not ai_allegiance_broken(player, human),'sound\dialog\mission\m80\m80_atrium_mantis_soldiers_00107', FALSE, bpd_atrium_mech_03, 0.0, "", "Mantis Pilot: It just doesn't make any sense.  This thing's a mech, not a plane.", FALSE);
    L_dlg_mantis_inversion = dialog_end( L_dlg_mantis_inversion, TRUE, TRUE, "" ); 
			
end




global boolean B_dlg_atrium_group_03_orders_marine_02_move = FALSE;
global boolean B_dlg_atrium_group_03_orders_marine_03_move = FALSE;
global boolean B_dlg_atrium_group_03_orders_marine_04_move = FALSE;
global boolean B_dlg_atrium_group_03_orders_marine_05_move = FALSE;
script dormant f_dialog_m80_atrium_group_03_orders()

//	sleep_until( (S_atrium_group_3_state == 0) and pup_is_playing(l_atrium_group_3_pup_id), 1 );
    L_dlg_atrium_group_03_orders = dialog_start_background("ATRIUM_GROUP_03_ORDERS", L_dlg_atrium_group_03_orders, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );
    
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00100', FALSE, sq_atrium_marines.group03_marine_01, 0.25, "", "MARINE 01: Tillson just radioed. This whole thing's sideways.", FALSE);
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00101', FALSE, sq_atrium_marines.group03_marine_01, 0.5, "", "MARINE 01: Orders are to keep the Covenant away from the artifact, no ifs ands or buts.", FALSE);
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00102', FALSE, sq_atrium_marines.group03_marine_01, 0.125, "", "MARINE 01: Cox, Edwards - you two take the flanks.", FALSE);
    	
    	B_dlg_atrium_group_03_orders_marine_02_move = TRUE;
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00107', FALSE, sq_atrium_marines.group03_marine_02, 0.125, "", "MARINE 02: Sir.", FALSE);
    	
    	B_dlg_atrium_group_03_orders_marine_03_move = TRUE;
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 4, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00108', FALSE, sq_atrium_marines.group03_marine_03, 0.5, "", "MARINE 03: Yes sir!", FALSE);
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 5, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00104', FALSE, sq_atrium_marines.group03_marine_01, 0.125, "", "MARINE 01: French, lock down the far edge.", FALSE);
    	
    	B_dlg_atrium_group_03_orders_marine_04_move = TRUE;
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 6, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00110', FALSE, sq_atrium_marines.group03_marine_04, 0.75, "", "MARINE 04: On it sir.", FALSE);
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 7, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00105', FALSE, sq_atrium_marines.group03_marine_01, 0.25, "", "MARINE 01: Warner, keep your eyes peeled but mainly just stay out of my way.", FALSE);
    	
    	B_dlg_atrium_group_03_orders_marine_05_move = TRUE;
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 8, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00109', FALSE, sq_atrium_marines.group03_marine_05, 0.5, "", "MARINE 05: Uhhh, yes sir.", FALSE);
    	dialog_line_npc_ai( L_dlg_atrium_group_03_orders, 9, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00106', FALSE, sq_atrium_marines.group03_marine_01, 0.5, "", "MARINE 01: Keep it safe, gentlemen. Go.!", FALSE);
    	
    L_dlg_atrium_group_03_orders = dialog_end( L_dlg_atrium_group_03_orders, TRUE, TRUE, "" ); 

end




script static void f_dialog_m80_atrium_computer_01()
//dprint("f_dialog_m80_atrium_computer_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_COMPUTER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00100', FALSE, atrium_computer_crate_01, 0.0, "", "Ivanoff System Voice: I’m sorry. We are currently experiencing system-wide outages. If you require immediate assistance, contact Infrastructure, 048.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				object_create(device_control_atrium_science1);
				device_set_position_immediate(device_control_atrium_science1, 0);
				thread(f_atrium_narrative_science_1());
end


script  static void f_dialog_m80_atrium_computer_02()
//dprint("f_dialog_m80_atrium_computer_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_COMPUTER_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00101', FALSE, cr_atrium_terminal_group_01, 0.0, "", "Scientist 1: Fourteen Thirty One hours. I don’t know what’s happening topside, but I was in the middle of rerunning the Gilwood-Elman Tests and the artifact started...", FALSE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00102', FALSE, cr_atrium_terminal_group_01, 0.0, "", "Scientist 1: I don’t know WHAT it’s doing. Rerunning the sensor leads now.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
   object_create(device_control_atrium_science2);
	device_set_position_immediate(device_control_atrium_science2, 0);
				thread(f_atrium_narrative_science_2());
end

script  static void f_dialog_m80_atrium_computer_03()
//dprint("f_dialog_m80_atrium_computer_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_COMPUTER_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00103', FALSE, cr_atrium_terminal_conv_05, 0.0, "", "Scientist 2: Phosphorous Test 72. We had some luck yesterday breaking the connection between the artifact and the surrounding terrain.", FALSE);
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00104', FALSE, cr_atrium_terminal_conv_05, 0.0, "", "Scientist 2: Gonna see if adjusting the elemental density - what the hell was that?", FALSE);								
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				object_create(device_control_atrium_science3);
				device_set_position_immediate(device_control_atrium_science3, 0);
				thread(f_atrium_narrative_science_3());
end


script  static void f_dialog_m80_atrium_computer_04()
//dprint("f_dialog_m80_atrium_computer_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_COMPUTER_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       																
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00105', FALSE, cr_atrium_terminal_group_02, 0.0, "", "Tim (Ivanoff PA): This is Tim Pherson. Sandy asked me to make an addendum to the last observation long on Specimen 1101.", FALSE);
							dialog_line_radio( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00106', FALSE, cr_atrium_terminal_group_02, 0.0, "", "Tim (Ivanoff PA): We’re still going over the logs now, but we now believe the transmission stopped emanating from the artifact at approximately 0900 on the 21st.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				object_create(device_control_atrium_science4);

				device_set_position_immediate(device_control_atrium_science4, 0);
				thread(f_atrium_narrative_science_4());
end


script  static void f_dialog_m80_atrium_computer_05()
//dprint("f_dialog_m80_atrium_computer_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "ATRIUM_COMPUTER_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00107', FALSE, atrium_computer_crate_05, 0.0, "", "Scientist 3: Something big’s happening outside the station.", FALSE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_computer_00108', FALSE, atrium_computer_crate_05, 0.0, "", "Scientist 3: I’m initiating a full redundancy cycle on the chromatics data, but in the event it doesn’t go through, I’m going to store a hard dump of the same up in the #31 Maintenance shed!", FALSE);					
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				object_create(device_control_atrium_science5);
				device_set_position_immediate(device_control_atrium_science5, 0);
				thread(f_atrium_narrative_science_5());
end


script dormant f_dialog_m80_ivanoff_pa_01()
//dprint("f_dialog_m80_ivanoff_pa_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "IVANOFF_PA_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00100', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): Any Ivanoff personnel upwards of AA-11, please report in to Ops!", TRUE);
							dialog_line_radio( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00101', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): We’ve lost all sensor contact up there and need to figure out who’s still up there!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end




script dormant f_dialog_m80_ivanoff_pa_03()
//dprint("f_dialog_m80_ivanoff_pa_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "IVANOFF_PA_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				 				dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00102', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): Station personnel! Additional Lifestations have just been secured on P-22 and P-23.", TRUE);
				 				dialog_line_radio( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00103', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): Be safe and get to those boats, folks-nothing on this station is worth losing your lives over.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end




script dormant f_dialog_m80_ivanoff_pa_05()
//dprint("f_dialog_m80_ivanoff_pa_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "IVANOFF_PA_5", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				 				dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00104', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): Attention, attention, this is Ops - additional Covenant forces have  just broken through on F-Deck!", TRUE);
				 				dialog_line_radio( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_system_voice_00105', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): Repeat - we have lost control of F-deck and anyone still down there should get out, immediately!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



/*
script dormant f_dialog_m80_atrium_scientists_composer()
//dprint("f_dialog_m80_atrium_scientists_composer");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_SCIENTISTS_COMPOSER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00100', FALSE, NONE, 0.0, "", "SCIENTIST: OH!", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00101', FALSE, NONE, 0.0, "", "SCIENTIST: Whe the?", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00102', FALSE, NONE, 0.0, "", "SCIENTIST: Is everybody OK?", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/





global short S_dlg_atrium_defenses_offline_objective_line_index = 4;

script dormant f_dialog_m80_atrium_defenses_offline()
//dprint("f_dialog_m80_atrium_defenses_offline");
					
            L_dlg_m80_atrium_defenses_offline = dialog_start_foreground( "ATRIUM_DEFENSES_OFFLINE", L_dlg_m80_atrium_defenses_offline, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
								dialog_line_chief( L_dlg_m80_atrium_defenses_offline, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00103', FALSE, NONE, 0.0, "", "Master Chief: Doctor, what was that?" );
								//hud_play_pip_from_tag( "bink\campaign\M80_C_60" );
								
								start_radio_transmission( "tillson_transmission_name");
								
								dialog_line_npc( L_dlg_m80_atrium_defenses_offline, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00104', FALSE, NONE, 0.0, "", "Dr. Tillson: The Covenant- the Covenant shot down the first evac shuttle...", TRUE);
								dialog_line_cortana( L_dlg_m80_atrium_defenses_offline, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00105', FALSE, NONE, 0.0, "", "Cortana: The station should be equipped with outer turrets." );
								//dialog_line_chief( L_dlg_m80_atrium_defenses_offline, 3, TRUE, 'sound\dialog\mission\m80\M80_atrium_composer_00106', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson, you said the defenses were offline?" );
								dialog_line_cortana( L_dlg_m80_atrium_defenses_offline, 3, TRUE, 'sound\dialog\mission\m80\M80_atrium_composer_00107', FALSE, NONE, 0.0, "", "Cortana: If we can reactivate them, I can program the station's defenses to provide cover for the evacuation." );
								dialog_line_npc( L_dlg_m80_atrium_defenses_offline, 4, TRUE, 'sound\dialog\mission\m80\M80_atrium_composer_00108', FALSE, NONE, 0.0, "", "Dr. Tillson: OK... OK, I'll send you the coordinates.", TRUE);
								
								end_radio_transmission();
								
								wake(f_dialog_m80_atrium_group_03_orders);
							//	dialog_line_chief( L_dlg_m80_atrium_defenses_offline, 6, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00109', FALSE, NONE, 0.0, "", "Master Chief: Cortana, are you... sure this is something you can do?" );
            //			hud_rampancy_players_set( 0.5 );
						////			dialog_line_cortana( L_dlg_m80_atrium_defenses_offline, 7, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00110', FALSE, NONE, 0.0, "", "Cortana: EVEN HE CAN'T TRUST YOU/US. " );
            //			hud_rampancy_players_set( 0.0 );
           // 			sleep_s(1);
					//			dialog_line_cortana( L_dlg_m80_atrium_defenses_offline, 8, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00111', FALSE, NONE, 0.0, "", "Cortana: Chief... please. I can still help. I can." );
					//			dialog_line_chief( L_dlg_m80_atrium_defenses_offline, 9, TRUE, 'sound\dialog\mission\m80\m80_atrium_composer_00112', FALSE, NONE, 0.0, "", "Master Chief: I know that. And I do. Trust you." );
            L_dlg_m80_atrium_defenses_offline = dialog_end( L_dlg_m80_atrium_defenses_offline, TRUE, TRUE, "" );


	// setup reminder dialog
//	wake( f_VO_atrium_leavingdelay );

				
end

global short S_dlg_post_atrium_officer_last_line_index = 1;
script dormant f_dialog_m80_post_atrium_officer()
//dprint("f_dialog_m80_post_atrium_officer");

	            L_dlg_post_atrium_officer = dialog_start_background( "POST_ATRIUM_OFFICER", L_dlg_post_atrium_officer, not ai_allegiance_broken(player, human), DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );   
								//dialog_line_npc_ai( L_dlg_post_atrium_officer, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m80\m80_atrium_soldiers_00110', FALSE, sq_atrium_hub_humans.male, 0.0, "", "OFFICER: Sir!", FALSE);
								// wait for the door to start opening
								sleep_until( f_hallways_one_door_hub_exit_open_get() or ai_allegiance_broken(player, human) or f_ai_is_defeated(sq_atrium_hub_humans), 1 );
								sleep_s( 0.5 );
								dialog_line_chief( L_dlg_post_atrium_officer, 0, (not ai_allegiance_broken(player, human)) and (not f_ai_is_defeated(sq_atrium_hub_humans)), 'sound\dialog\mission\m80\m80_officer_00100', FALSE, NONE, 0.0, "", "Master Chief: Officers, seal the door behind me. The Covenant can't be allowed to reach the artifact." );
								dialog_line_npc_ai( L_dlg_post_atrium_officer, 1, (not ai_allegiance_broken(player, human)) and (door_atrium_hub_exit_maya->position_not_close_check()), 'sound\dialog\mission\m80\m80_atrium_soldiers_00107', FALSE, sq_atrium_hub_humans.male, 0.0, "", "OFFICER: Yes, sir.", FALSE);
            L_dlg_post_atrium_officer = dialog_end( L_dlg_post_atrium_officer, TRUE, TRUE, "" );
//dprint("f_dialog_m80_post_atrium_officer: END");
				
end

script dormant f_dialog_m80_post_atrium_officer_killed()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint("f_dialog_m80_post_atrium_officer_hostile");

	           // l_dialog_id = dialog_start_foreground( "POST_ATRIUM_OFFICER_KILLED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.25 );   
								//dialog_line_cortana( l_dialog_id, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Chief, I'm not sure that was necessary." );
            	//l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end





script dormant f_dialog_m80_post_atrium_officer_hostile()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint("f_dialog_m80_post_atrium_officer_hostile");

	            //l_dialog_id = dialog_start_foreground( "POST_ATRIUM_OFFICER_HOSTILE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );   
								// wait for player to be in the room and door closed behind them
								//dialog_line_cortana( l_dialog_id, 1, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: Let me see if I can get the door for you." );
								//sleep_s( 1.5 );

								sleep_until( f_hallways_one_puppeteer_open_ready(), 1 );
								// force the next area to open
								f_hallways_one_door_hub_exit_open_set();

								// wait for the other door to start opening
								//sleep_s( 0.5 );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, NONE, FALSE, NONE, 0.0, "", "CORTANA: There you go." );

            //l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end


script dormant f_dialog_m80_post_atrium()
//dprint("f_dialog_m80_post_atrium");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
  	if ( L_dlg_m80_post_atrium == DEF_DIALOG_ID_NONE() ) then
    L_dlg_m80_post_atrium = dialog_start_background("POST_ATRIUM_SOLDIER", L_dlg_m80_airlock_hall, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc( L_dlg_m80_post_atrium, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_soldiers_00110', FALSE, sq_atrium_hub_humans.male, 0.0, "", "Sir!", TRUE);
				dialog_line_chief( L_dlg_m80_post_atrium, 1, TRUE, 'sound\dialog\mission\m80\m80_officer_00100', FALSE, NONE, 0.0, "", "Master Chief: Officer, seal the door.");
    L_dlg_m80_post_atrium = dialog_end( L_dlg_m80_post_atrium, TRUE, TRUE, "" ); 
    
	end
end


script dormant f_dialog_m80_airlock_hallways_1()
//dprint("f_dialog_m80_airlock_hallways_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_HALLWAYS_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
							dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_hallways_1_00100', FALSE, NONE, 0.0, "", "Didact: You impress me, human. Your singular valor will be preserved and studied, once your Composition has been completed." );
							//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_airlock_hallways_1_00101', FALSE, NONE, 0.0, "", "Cortana: The battlenet's directing all troops to our position!" );
							
							// powerloss moment
							if ( f_hallways_one_narrative_powerloss_none() ) then
								f_hallways_one_narrative_powerloss_action();
							end
							sleep_until( f_hallways_one_narrative_powerloss_complete() );
							
				//		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_airlock_hallways_1_00102', FALSE, NONE, 0.0, "", "Cortana: That's going to slow us down..." );
							dialog_line_cortana( l_dialog_id, 3, (door_to_airlock_one_mid_way->position_open_check() == FALSE) and (volume_test_players(tv_hallway_one_access_found_a) == FALSE) and (volume_test_players(tv_hallway_one_access_found_b) == FALSE), 'sound\dialog\mission\m80\m80_airlock_hallways_1_00104', FALSE, NONE, 0.0, "", "Cortana: The power loss triggered an automatic lockdown. Find the auxiliary access tunnel." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				thread(f_dialog_m80_airlock_hall());
end


script static void f_dialog_m80_airlock_hall()
//dprint("f_dialog_m80_airlock_hall");

	if ( L_dlg_m80_airlock_hall == DEF_DIALOG_ID_NONE() ) then
    L_dlg_m80_airlock_hall = dialog_start_background("BAY_7_TIM", L_dlg_m80_airlock_hall, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
				dialog_line_npc( L_dlg_m80_airlock_hall, 0, TRUE, 'sound\dialog\mission\m80\m80_horseshoe_00112', FALSE, NONE, 0.0, "", "Tim (Ivanoff PA): All hands! Bay 7, Level C-5 is cleared and available for evac! Again, this is not a drill! Bay 7, C-5!", TRUE);
    L_dlg_m80_airlock_hall = dialog_end( L_dlg_m80_airlock_hall, TRUE, TRUE, "" ); 
	end
end

script dormant f_dialog_m80_airlock_covenant_assault()
static boolean b_triggered = FALSE;
//dprint("f_dialog_m80_airlock_covenant_assault");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					if ( not b_triggered ) then
						b_triggered = TRUE;

            l_dialog_id = dialog_start_foreground( "AIRLOCK_COVENANT_ASSAULT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
						//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00101', FALSE, NONE, 0.0, "", "Cortana: They’ve stopped. Let’s get to the defense grid before the Didact directs more troops our way." );
							sleep_s( 0.25 );
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00102', FALSE, NONE, 0.0, "", "Cortana: I think that’s the last of them." );
							
							// blip exit
							if ( f_objective_current_index() < DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT() ) then
								f_objective_set( DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT(), TRUE, FALSE, FALSE, TRUE );
							end

							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\global_chatter_00130', FALSE, NONE, 0.0, "", "Cortana: Let's go." );
							
							f_objective_blip( DEF_R_OBJECTIVE_AIRLOCKS_ONE_EXIT(), TRUE );
							
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
//				wake(m80_airlock_1_didact_scan);

					end
					
end

/*
script dormant f_dialog_m80_airlock_1_post()
//dprint("f_dialog_m80_airlock_1_post");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_1_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
														dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00102', FALSE, NONE, 0.0, "", "Cortana: The blast doors are back up. Let's get to the defense grid before the Didact directs more troops this way.");
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/

/*
script dormant f_dialog_m80_airlock_didact_contact()
//dprint("f_dialog_m80_airlock_didact_contact");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_DIDACT_CONTACT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
							dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00103', FALSE, NONE, 0.0, "", "Didact: Your scampering brings you no further glory, warrior.from itself. " );
							dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00104', FALSE, NONE, 0.0, "", "Didact: Despite her misguided efforts, even the Librarian understood the effectiveness of the Composer in protecting mankind." );
							dialog_line_didact( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_00105', FALSE, NONE, 0.0, "", "Didact: I do not ask for surrender, but concede the device. Speed your people to their fate." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/

script dormant f_dialog_m80_airlock_hallways_2()
//dprint("f_dialog_m80_airlock_hallways_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_HALLWAYS_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
							dialog_line_radio( l_dialog_id, 0, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100', FALSE, NONE, 0.0, "", "Scientist 1: Spartan! In here! They've got us cut off!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script static void f_dialog_m80_bay_ext_airlock_clear( short s_bay_id )
	if ( s_bay_id == 1 ) then
		f_dialog_m80_bay_3_ext_airlock_clear();
	end
	if ( s_bay_id == 2 ) then
		f_dialog_m80_bay_2_ext_airlock_clear();
	end
	if ( s_bay_id == 3 ) then
		f_dialog_m80_bay_1_ext_airlock_clear();
	end
end

script static void f_dialog_m80_bay_int_airlock_clear( short s_bay_id )
	if ( s_bay_id == 1 ) then
		f_dialog_m80_bay_3_int_airlock_clear();
	end
	if ( s_bay_id == 2 ) then
		f_dialog_m80_bay_2_int_airlock_clear();
	end
	if ( s_bay_id == 3 ) then
		f_dialog_m80_bay_1_int_airlock_clear();
	end
end

script static void f_dialog_m80_bay_1_ext_airlock_clear()
//dprint("f_dialog_m80_bay_1_ext_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_1_EXT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00100', FALSE, airlock_1_system_1, 0.0, "", "Ivanoff System Voice: Bay 1. Exterior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end

script static void f_dialog_m80_bay_1_int_airlock_clear()
//dprint("f_dialog_m80_bay_1_int_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_1_INT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00101', FALSE, airlock_1_system_1, 0.0, "", "Ivanoff System Voice: Bay 1. Interior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end

script static void f_dialog_m80_bay_2_ext_airlock_clear()
//dprint("f_dialog_m80_bay_2_ext_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_2_EXT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00102', FALSE, airlock_1_system_2, 0.0, "", "Ivanoff System Voice: Bay 2. Exterior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end

script static void f_dialog_m80_bay_2_int_airlock_clear()
//dprint("f_dialog_m80_bay_2_int_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_2_INT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00103', FALSE, airlock_1_system_2, 0.0, "", "Ivanoff System Voice: Bay 2. Interior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end
script static void f_dialog_m80_bay_3_ext_airlock_clear()
//dprint("f_dialog_m80_bay_3_ext_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_3_EXT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00104', FALSE, airlock_1_system_3, 0.0, "", "Ivanoff System Voice: Bay 3. Exterior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end

script static void f_dialog_m80_bay_3_int_airlock_clear()
//dprint("f_dialog_m80_bay_3_int_airlock_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "BAY_3_INT_AIRLOCK_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       								
							dialog_line_radio( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_1_systemvoice_00105', FALSE, airlock_1_system_3, 0.0, "", "Ivanoff System Voice: Bay 3. Interior airlock, clear.", FALSE);
            l_dialog_id = dialog_end( l_dialog_id, FALSE, FALSE, "" );
				
end

script dormant f_dialog_m80_airlock_hallways_scientist_01()
//dprint("f_dialog_m80_airlock_hallways_scientist_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HALLWAYS_SCIENTIST_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
							dialog_line_npc( l_dialog_id, 0, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100a', FALSE, NONE, 0.0, "", "Scientist 2: HEY! It’s the military!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
script dormant f_dialog_m80_airlock_hallways_scientist_01b()
//dprint("f_dialog_m80_airlock_hallways_scientist_01b");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HALLWAYS_SCIENTIST_01b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
							dialog_line_npc( l_dialog_id, 1, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100b', FALSE, NONE, 0.0, "", "Scientist 3: Help us, please!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_airlock_hallways_scientist_02()
//dprint("f_dialog_m80_airlock_hallways_scientist_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "HALLWAYS_SCIENTIST_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
							dialog_line_npc( l_dialog_id, 0, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human) and (b_scientist_save == FALSE)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100c', FALSE, NONE, 0.0, "", "Scientist 1: No!", TRUE);
							dialog_line_npc( l_dialog_id, 1, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human) and (b_scientist_save == FALSE)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100d', FALSE, NONE, 0.0, "", "Scientist 3: No - wait!", TRUE);
							dialog_line_npc( l_dialog_id, 2, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human) and (b_scientist_save == FALSE)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100e', FALSE, NONE, 0.0, "", "Scientist 2: Don’t GO!", TRUE);
							dialog_line_npc( l_dialog_id, 3, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human) and (b_scientist_save == FALSE)), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00100f', FALSE, NONE, 0.0, "", "Scientist 4: Wait! Come back!!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_airlock_hallways_2_rescue()
//dprint("f_dialog_airlock_hallways_2_rescue");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_HALLWAYS_2_RESCUE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
            		// XXX NEED TO HOOKUP PROPER LINE FOR MALE/FEMALE
	            	if ( f_hallways_two_puppeteer_human_reward_speaker_male() ) then
									dialog_line_npc( l_dialog_id, 0, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)) and (obj_hallway_two_reward_opener != NONE), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00101', FALSE, obj_hallway_two_reward_opener, 0.0, "", "Scientist 2: They ran! The security team assigned to us, the second the Covenant! How could they do that?", TRUE);
	            	else
									dialog_line_npc( l_dialog_id, 0, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)) and (obj_hallway_two_reward_opener != NONE), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00101', FALSE, obj_hallway_two_reward_opener, 0.0, "", "Scientist 2: They ran! The security team assigned to us, the second the Covenant! How could they do that?", TRUE);
	            	end
	            	sleep_s(1);
								dialog_line_chief( l_dialog_id, 1, (ai_living_count(sg_to_airlock_two_protect) > 0) and (not ai_allegiance_broken(player, human)) and (obj_hallway_two_reward_opener != NONE), 'sound\dialog\mission\m80\m80_airlock_hallways_2_00102', FALSE, obj_hallway_two_reward_opener, 0.0, "", "Master Chief: Find Dr. Tillson. She'll get you to the evacuation area." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end



script dormant f_dialog_m80_airlock_2_call_bluff()
//dprint("f_dialog_m80_airlock_2_call_bluff");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_2_CALL_BLUFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
            
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\M80_airlock_hallways_1_00101', FALSE, NONE, 0.0, "", "Cortana: The battlenet's directing all troops to our position!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_airlock_2_system_lockdown()
//dprint("f_dialog_airlock_2_system_lockdown");
					
                               								
            			hud_rampancy_players_set( 0.5 );
									sleep_s(1);
            			hud_rampancy_players_set( 0.0 );
            
				
end

script dormant f_dialog_airlock_2_back_online()
//dprint("f_dialog_airlock_2_back_online");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "AIRLOCK_2_SYSTEM_LOCKDOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_airlock_2_00103', FALSE, NONE, 0.0, "", "Cortana: Essential system power's back online. We've got to get to the defense grid before we lose it again!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_airlock_two_few_left()
//dprint("f_dialog_m80_airlock_two_few_left");
					
            L_dlg_m80_airlock_two_few_left = dialog_start_foreground( "AIRLOCK_2_FEW_LEFT", L_dlg_m80_airlock_two_few_left, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
									dialog_line_cortana( L_dlg_m80_airlock_two_few_left, 0, ai_living_count(sg_airlock_two_units) > 1, NONE, FALSE, NONE, 0.0, "", "CORTANA: A couple left chief." );
            L_dlg_m80_airlock_two_few_left = dialog_end( L_dlg_m80_airlock_two_few_left, TRUE, TRUE, "" );
				
end


script dormant f_dialog_lookout_hallway()
//dprint("f_dialog_lookout_hallway");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "LOOKOUT_HALLWAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
					      dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_lookout_hallway_00101', FALSE, NONE, 0.0, "", "Cortana: Maybe the Great and Powerful Didact shouldn't misplace his things!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end





global short S_dlg_lookout_rampancy_blip_line_index = 2;
script dormant f_dialog_lookout_rampancy()
//dprint("f_dialog_airlock_2_back_online");
									
            L_dlg_lookout_rampancy = dialog_start_foreground( "AIRLOCK_2_SYSTEM_LOCKDOWN", L_dlg_lookout_rampancy, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
									dialog_line_cortana( L_dlg_lookout_rampancy, 0, TRUE, 'sound\dialog\mission\m80\m80_lookout_00100', FALSE, NONE, 0.0, "", "Cortana: That's the main defense console. " );
            			hud_rampancy_players_set( 0.75 );
            			wake(f_dialog_lookout_hallway_background);
									dialog_line_cortana( L_dlg_lookout_rampancy, 1, TRUE, 'sound\dialog\mission\m80\m80_lookout_00101', FALSE, NONE, 0.0, "", "Cortana: My intervention is the prerequisite for success." );
            			hud_rampancy_players_set( 0.0 );
									sleep_until( f_ai_is_defeated(sg_guns_start_elites), 1 );
									dialog_line_cortana( L_dlg_lookout_rampancy, 2, TRUE, 'sound\dialog\mission\m80\m80_lookout_00101a', FALSE, NONE, 0.0, "", "Cortana: Insert me into the defense grid." );
            L_dlg_lookout_rampancy = dialog_end( L_dlg_lookout_rampancy, TRUE, TRUE, "" );
				
end

script dormant f_dialog_lookout_hallway_background()
//dprint("f_dialog_lookout_hallway");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "LOOKOUT_HALLWAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
					      dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m90_rampancy_00143_WHISPER', FALSE, NONE, 0.0, "", "Cortana: [WHISPER] Why should we save them?" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

global short S_dlg_lookout_success_hack_complete_line_index = 4;
global short S_dlg_lookout_success_cortana_done_line_index = 7;
script static void f_dialog_lookout_success()
local long l_timer = 0;
//dprint("f_dialog_lookout_success");
									
            L_dlg_lookout_success = dialog_start_foreground( "AIRLOCK_2_SYSTEM_LOCKDOWN", L_dlg_lookout_success, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
							dialog_line_chief( L_dlg_lookout_success, 0, TRUE, 'sound\dialog\mission\m80\m80_lookout_00102', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson, are you there?" );
							
							hud_play_pip_from_tag( 'bink\campaign\M80_D_60' );
							start_radio_transmission( "tillson_transmission_name");

							l_timer = timer_stamp( frames_to_seconds(sound_max_time('sound\dialog\mission\m80\m80_lookout_00103_pip.sound')) );

							dialog_line_npc_subtitle( L_dlg_lookout_success, 1, TRUE, 'sound\dialog\mission\m80\m80_lookout_00103.sound', FALSE, NONE, 0.0, "", "Dr. Tillson: I’m here. Any luck?", TRUE);
							dialog_line_chief_subtitle( L_dlg_lookout_success, 2, TRUE, 'sound\dialog\mission\m80\m80_lookout_00104.sound', FALSE, NONE, 0.0, "", "Master Chief: Cortana’s bringing the defense grid online now." );
							dialog_line_cortana_subtitle( L_dlg_lookout_success, 3, TRUE, 'sound\dialog\mission\m80\m80_lookout_00104a.sound', FALSE, NONE, 0.0, "", "Cortana: Okay. That’s it. They're back up." );
							dialog_line_npc_subtitle( L_dlg_lookout_success, 4, TRUE, 'sound\dialog\mission\m80\m80_lookout_00105.sound', FALSE, NONE, 0.0, "", "Dr. Tillson: I hear it! We’ll broadcast the final evac orders.", TRUE);
							dialog_line_chief_subtitle( L_dlg_lookout_success, 5, TRUE, 'sound\dialog\mission\m80\m80_lookout_00106.sound', FALSE, NONE, 0.0, "", "Master Chief: The nuke?" );
							dialog_line_npc_subtitle( L_dlg_lookout_success, 6, TRUE, 'sound\dialog\mission\m80\m80_lookout_00107.sound', FALSE, NONE, 0.0, "", "Dr. Tillson: We’re rigging it now. Meet us back on the upper platform and we’ll help you get it to the artifact.", TRUE);
								
							dprint( "f_dialog_lookout_success: pip time remaining" );
							inspect( timer_remaining(l_timer) );
							
							sleep_until( timer_expired(l_timer), 1 );
							end_radio_transmission();
							
							sleep_s( 0.5 );
							dialog_line_cortana( L_dlg_lookout_success, 7, TRUE, 'sound\dialog\mission\m80\m80_lookout_00108', FALSE, bp_guns_cortana, 0.0, "", "Cortana: Pull me, Chief." );
            L_dlg_lookout_success = dialog_end( L_dlg_lookout_success, TRUE, TRUE, "" );

				wake(m80_atrium_return_hallway);
end


/*
script dormant f_dialog_atrium_return()
//dprint("f_dialog_atrium_return");
					
            L_dlg_atrium_return = dialog_start_background( "ATRIUM_RETURN", L_dlg_atrium_return, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
								//	dialog_line_npc( L_dlg_atrium_return, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00100', FALSE, ai_get_object(sg_guns_hallway_teaser.human_01), 0.0, "", "Scientist 5: I'm still here! Dear God, please, somebody hear me...", TRUE);
            L_dlg_atrium_return = dialog_end( L_dlg_atrium_return, TRUE, TRUE, "" );
				 
end
*/

script dormant f_dialog_atrium_return_covenant()
//dprint("f_dialog_atrium_return_covenant");
local long l_dlg_atrium_return_covenant = DEF_DIALOG_ID_NONE();
					
           l_dlg_atrium_return_covenant = dialog_start_background( "ATRIUM_RETURN_COVENANT", l_dlg_atrium_return_covenant, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
					 			dialog_line_npc( l_dlg_atrium_return_covenant, 0, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00101', FALSE, sq_guns_hallway_3_upper.spawn_points_0, 0.0, "", "Grunt 1: [Our sacrifice for] the Didact’s [glory!]", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant, 1, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00102', FALSE, sq_guns_hallway_3_upper.spawn_points_1, 0.0, "", "Grunt 2: [Brothers! Earn your place in the garden of the] Didact!", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant, 2, (ai_living_count(sq_guns_hallway_1_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00103', FALSE, sq_guns_hallway_1_upper.spawn_points_0, 0.0, "", "Elite 1: The Composer [will deliver only the devout!]", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant, 3, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00104', FALSE, NONE, 0.0, "", "Multiple Grunts: The Didact shelters all! The Didact shelters all!", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant, 4, (ai_living_count(sq_guns_hallway_1_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00105', FALSE, sq_guns_hallway_1_upper.spawn_points_0, 0.0, "", "Elite 1: [Slay the] Librarian’s [Pet!]", TRUE);
            l_dlg_atrium_return_covenant = dialog_end( l_dlg_atrium_return_covenant, TRUE, TRUE, "" );
				
end


script dormant f_dialog_atrium_return_covenant_02()
//dprint("f_dialog_atrium_return_covenant_02");
local long l_dlg_atrium_return_covenant_02 = DEF_DIALOG_ID_NONE();
					
            l_dlg_atrium_return_covenant_02 = dialog_start_background( "ATRIUM_RETURN_COVENANT_02", l_dlg_atrium_return_covenant_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
					 			dialog_line_npc( l_dlg_atrium_return_covenant_02, 0, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00106', FALSE, sq_guns_hallway_3_upper.spawn_points_0, 0.0, "", "Grunt 1: COM-PO-SER!!!", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant_02, 1, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00109', FALSE, NONE, 0.0, "", "Multiple Grunts: DIDACT DIDACT DIDACT!!!", TRUE);
            l_dlg_atrium_return_covenant_02 = dialog_end( l_dlg_atrium_return_covenant_02, TRUE, TRUE, "" );
				
end

script dormant f_dialog_atrium_return_covenant_03()
//dprint("f_dialog_atrium_return_covenant_03");
				
local long l_dlg_atrium_return_covenant_03 = DEF_DIALOG_ID_NONE();
					
            l_dlg_atrium_return_covenant_03 = dialog_start_background( "ATRIUM_RETURN_COVENANT_02", l_dlg_atrium_return_covenant_03, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dlg_atrium_return_covenant_03, 0, (ai_living_count(sq_guns_hallway_3_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00107', FALSE, sq_guns_hallway_3_upper.spawn_points_1, 0.0, "", "Grunt 2: DIDACT, [WE SERVE!!]", TRUE);
								dialog_line_npc( l_dlg_atrium_return_covenant_03, 1, (ai_living_count(sq_guns_hallway_1_upper) > 0), 'sound\dialog\mission\m80\m80_atrium_hallway_00108', FALSE, sq_guns_hallway_1_upper.spawn_points_0, 0.0, "", "Elite 1: COM-PO-SER!!!", TRUE);
            l_dlg_atrium_return_covenant_03 = dialog_end( l_dlg_atrium_return_covenant_03, TRUE, TRUE, "" );
				
end


script dormant f_dialog_atrium_return_hallway()
//dprint("f_dialog_atrium_return_hallway");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					sleep_s(2);
            l_dialog_id = dialog_start_foreground( "ATRIUM_RETURN_HALLWAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                   								
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00101', FALSE, NONE, 0.0, "", "Cortana: Chief, if we pull this off and actually get back to Halsey? Please... don't tell her how bad I got. Please?" );	
									dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00103', FALSE, NONE, 0.0, "", "Master Chief: I won't say anything." );
									//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00103', FALSE, NONE, 0.0, "", "Cortana: Daughters don't like to disappoint their mothers." );
									dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00103a', FALSE, NONE, 0.0, "", "Cortana: Thank you." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_atrium_battle()
//dprint("f_dialog_atrium_battle");
				   
            l_dlg_atrium_battle = dialog_start_foreground( "ATRIUM_RETURN_HALLWAY", l_dlg_atrium_battle, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
									dialog_line_chief( l_dlg_atrium_battle, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00104b', FALSE, NONE, 0.0, "", "Master Chief: They found the Composer." );
            			hud_rampancy_players_set( 0.75 );
									dialog_line_cortana( l_dlg_atrium_battle, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00105', FALSE, NONE, 0.0, "", "Cortana: STOP THEM, CHIEF! YOU CAN'T LET THEM TELL HIM! HE'S NOT REASONABLE!!!" );
            			hud_rampancy_players_set( 0.0 );
            			sleep_s(5);
            			dialog_line_chief( l_dlg_atrium_battle, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00109a', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson. The Composer's location's compromised!" );
									dialog_line_chief( l_dlg_atrium_battle, 3, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00109b', FALSE, NONE, 0.0, "", "Master Chief: You've got to get the nuke down here!" );
									start_radio_transmission( "tillson_transmission_name");
									 dialog_line_npc( l_dlg_atrium_battle, 4, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00110', FALSE, NONE, 0.0, "", "Dr. Tillson: It's -- it's not ready yet!", TRUE);
									 end_radio_transmission();

								  dialog_line_chief( l_dlg_atrium_battle, 5, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00111', FALSE, NONE, 0.0, "", "Master Chief: Ready or not, I need it NOW. Chief out." );

            l_dlg_atrium_battle = dialog_end( l_dlg_atrium_battle, TRUE, TRUE, "" );
				
end

script dormant f_dialog_atrium_battle_post()
//dprint("f_dialog_atrium_battle_post");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										
            				dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_end_00100', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson! Where's the warhead? Dr. Tillson!" );
            				sleep_s(1);
										dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_end_00101', FALSE, NONE, 0.0, "", "Cortana: Head back to the elevator platform. I'll keep trying to raise her." );
								  	//dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m80\m80_atrium_return_00112', FALSE, NONE, 0.0, "", "Cortana: You can take the mobile research platform up to Tillson's position." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

									// set the exit objective
									f_objective_set( DEF_R_OBJECTIVE_ELEVATOR_ENTER(), TRUE, FALSE, TRUE, TRUE );
				
end

script dormant f_dialog_atrium_vignette_destruction_start()
//dprint("f_dialog_atrium_vignette_destruction_start");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  l_dialog_id = dialog_start_foreground( "ATRIUM_VIGNETTE_DESTRUCTION_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								

		//sleep_until( not B_dialog_atrium_vignette_paused, 1 );
		//dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00100a', FALSE, NONE, 0.0, "", "Didact: Fellow combatant." );
		//sleep_until( not B_dialog_atrium_vignette_paused, 1 );
		//dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00100b', FALSE, NONE, 0.0, "", "Didact: The Mantle shelters all, but to warriors, there inevitably comes a time like this." );
		//sleep_until( not B_dialog_atrium_vignette_paused, 1 );
		//dialog_line_didact( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00100c', FALSE, NONE, 0.0, "", "Didact: Take comfort that your defeat serves an entire galaxy." );
		
		// ### as thing is breaking
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00101', FALSE, NONE, 0.0, "", "Cortana: CHIEF - IMMENSE CASIMIR WAVE BUILDING INSIDE THE DIDACT'S VESSEL!" );

  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_atrium_vignette_composer_removal_start()
//dprint("f_dialog_atrium_vignette_composer_removal_start");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  l_dialog_id = dialog_start_foreground( "ATRIUM_VIGNETTE_COMPOSER_REMOVAL_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								

		// ### as Didact starts stuff
		dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00102', FALSE, NONE, 0.0, "", "Master Chief: What's he doing" );
		
		//sleep_s(5);
		//sleep_until( not B_dialog_atrium_vignette_paused, 1 );
		//dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00103', FALSE, NONE, 0.0, "", "Master Chief: Dr. Tillson, this is Sierra One One Seven! (no answer) Dr. Tillson, come in!" );
		//sleep_until( not B_dialog_atrium_vignette_paused, 1 );
		//dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00104', FALSE, NONE, 0.0, "", "Cortana: The channel's overloaded. No one knows what's happening..." );

  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

global short S_dlg_atrium_vignette_elevator_restart_index = 12;
global short S_dlg_atrium_vignette_composer_leaving_blip_index = 13;
script dormant f_dialog_atrium_vignette_composer_leaving()
//dprint("f_dialog_atrium_vignette_composer_leaving");
  l_dlg_atrium_vignette_composer_leaving = dialog_start_foreground( "ATRIUM_VIGNETTE_COMPOSER_LEAVING", l_dlg_atrium_vignette_composer_leaving, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
			// ### composer almost out of frame
			dialog_line_chief( l_dlg_atrium_vignette_composer_leaving, 7, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00105', FALSE, NONE, 0.0, "", "Master Chief: Cortana, see if you can raise Tillson. Get me a status on the rest of the station." );
			
			hud_rampancy_players_set( 0.99 );
			sleep_s( 0.25 );
			dialog_line_cortana( l_dlg_atrium_vignette_composer_leaving, 8, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00106', FALSE, NONE, 0.0, "", "Cortana: ...I can't believe he did that..." );
			dialog_line_chief( l_dlg_atrium_vignette_composer_leaving, 9, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00107', FALSE, NONE, 0.0, "", "Master Chief: Cortana, I need that info!" );
			sleep_s( 0.5 );
			dialog_line_chief( l_dlg_atrium_vignette_composer_leaving, 10, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00108', FALSE, NONE, 0.0, "", "Master Chief: Look... don't think about the Didact, don't think about the Composer - only focus on finding me Tillson." );
			dialog_line_cortana( l_dlg_atrium_vignette_composer_leaving, 11, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00109', FALSE, NONE, 0.0, "", "Cortana: Tillson. Sandra K. Female, 51 years of age. Doctor of Archeology, Pegasi Institu--" );
			hud_rampancy_players_set( 0.0 );
			dialog_line_cortana( l_dlg_atrium_vignette_composer_leaving, 12, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00110', FALSE, NONE, 0.0, "", "Cortana: Got her - biosignature stable on 350-Level, B-Deck." );
			sleep_s( 0.5 );
			dialog_line_chief( l_dlg_atrium_vignette_composer_leaving, 13, TRUE, 'sound\dialog\mission\m80\m80_atrium_final_vignette_00111', FALSE, NONE, 0.0, "", "Master Chief: Thank you, Cortana." );

  l_dlg_atrium_vignette_composer_leaving = dialog_end( l_dlg_atrium_vignette_composer_leaving, TRUE, TRUE, "" );
				
end

script dormant f_dialog_M80_callout_banshees()
dprint("f_dialog_M80_callout_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00126', FALSE, NONE, 0.0, "", "Cortana: Banshees!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m80_atrium_battle_01()
//dprint("f_dialog_m80_atrium_battle_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00102', FALSE, NONE, 0.0, "", "Cortana: They're throwing everything they've got at us to get the Composer." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_atrium_battle_02()
//dprint("f_dialog_m80_atrium_battle_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00101', FALSE, NONE, 0.0, "", "Cortana: Another wave!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_atrium_battle_03()
//dprint("f_dialog_m80_atrium_battle_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00100', FALSE, NONE, 0.0, "", "Cortana: They just keep coming…" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

/*
script dormant f_dialog_m80_atrium_battle_04()
//dprint("f_dialog_m80_atrium_battle_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00103', FALSE, NONE, 0.0, "", "Cortana: Such passion. Desire…" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/

/*
script dormant f_dialog_m80_atrium_battle_05()
//dprint("f_dialog_m80_atrium_battle_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00104', FALSE, NONE, 0.0, "", "Cortana: Protect the Composer." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/

script dormant f_dialog_m80_atrium_battle_06()
//dprint("f_dialog_m80_atrium_battle_06");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_06", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00105', FALSE, NONE, 0.0, "", "Cortana: Keep them away from it!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_m80_atrium_battle_07()
//dprint("f_dialog_m80_atrium_battle_07");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_07", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00108', FALSE, NONE, 0.0, "", "Cortana: Where is he??" );
										//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00111', FALSE, NONE, 0.0, "", "Cortana: He didn't even send his Prometheans in…" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
/*
script dormant f_dialog_m80_atrium_battle_leaving_01()
//dprint("f_dialog_m80_atrium_battle_leaving_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_LEAVING_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00107', FALSE, NONE, 0.0, "", "Cortana: Where are they going?" );
										dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00110', FALSE, NONE, 0.0, "", "Cortana: I don't understand!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

script dormant f_dialog_m80_atrium_battle_leaving_02()
//dprint("f_dialog_m80_atrium_battle_leaving_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "ATRIUM_BATTLE_LEAVING_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00109', FALSE, NONE, 0.0, "", "Cortana: They're retreating!" );
										dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_battle_00112', FALSE, NONE, 0.0, "", "Cortana: This line of action defies reason!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end
*/

script dormant f_dialog_m80_atrium_elevator()
//dprint("f_dialog_m80_atrium_battle_leaving_02");
					
            l_dlg_atrium_elevator = dialog_start_foreground( "ATRIUM_ELEVATOR", l_dlg_atrium_elevator, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
										dialog_line_cortana( l_dlg_atrium_elevator, 0, TRUE, 'sound\dialog\mission\m80\m80_elevator_return_00100', FALSE, NONE, 0.0, "", "Cortana: The Havok mines'll be in one of the cargo bays. Start us up." );
            l_dlg_atrium_elevator = dialog_end( l_dlg_atrium_elevator, TRUE, TRUE, "" );
				
end





// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

/*
script static void f_dialog_m80_nudge_1()
//dprint("f_dialog_m80_nudge_1");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_1", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m80_nudge_2()
//dprint("f_dialog_m80_nudge_2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_2", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m80_nudge_3()
//dprint("f_dialog_m80_nudge_3");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_3", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m80_nudge_4()
//dprint("f_dialog_m80_nudge_4");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_4", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m80_nudge_5()
//dprint("f_dialog_m80_nudge_5");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

*/