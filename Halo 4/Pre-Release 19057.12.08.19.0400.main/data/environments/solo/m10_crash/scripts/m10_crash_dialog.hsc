//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_dialog
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// DIALOG
// -------------------------------------------------------------------------------------------------
// DEFINES
//global short LINE_RANDOM =  0;
//global short DEF_CORTANA_PICK_UP = 7;
//global short DEF_ACTIVATE_CRYO = 10;

// VARIABLES
//global boolean b_dialog_obs_player_see_covenant = FALSE;
//global boolean b_dialog_obs_cheif_says_covenant = FALSE;

// dialog ID variables
global long 	L_dlg_lab_pre_elevator_ics 				= DEF_DIALOG_ID_NONE();

global long 	L_dialog_beacon_enter 						= DEF_DIALOG_ID_NONE();

// --- END
global long 	L_dialog_End_Start 								= DEF_DIALOG_ID_NONE();

global long 	L_dialog_ShipVO_NoPods 						= DEF_DIALOG_ID_NONE();

global long 	L_dialog_PodChase_Start 					= DEF_DIALOG_ID_NONE();

global long 	L_dialog_Breakhall01_Action				= DEF_DIALOG_ID_NONE();
global string STR_dialog_Breakhall01_Action			= "BROKEN_HALL_ACTION";

global long 	L_dialog_BrokenAction_ShipVo 			= DEF_DIALOG_ID_NONE();

global long 	L_dialog_ShipVO_Maintenance 			= DEF_DIALOG_ID_NONE();

global long 	L_dialog_ShipVO_Blackout 					= DEF_DIALOG_ID_NONE();

global long 	L_dialog_ShipVO_VehicleBay 				= DEF_DIALOG_ID_NONE();
global string STR_dialog_ShipVO_VehicleBay			= "SHIPVO_VEHICLEBAY";

global long 	L_dialog_PodChase_End 						= DEF_DIALOG_ID_NONE();
global boolean b_osb_line_fired = FALSE;
global boolean b_elevator_banks_blip = FALSE;
global long l_dlg_m80_intrusion_alert = DEF_DIALOG_ID_NONE();

/*
script dormant f_dialog_check_obs_player_see_covenant()
	volume_test_players_lookat(tv_obs_skybox_event, 50, 50);
	b_dialog_obs_player_see_covenant = TRUE;
end
script dormant f_prep_rumble()
	sleep_s(5.5);
	b_fud_rumble_small = TRUE;
end
*/
script static void f_dialog_m80_intrusion_alert()
dprint("f_dialog_m80_intrusion_alert");

					
            l_dlg_m80_intrusion_alert = dialog_start_background( "INTRUSION_ALERT", l_dlg_m80_intrusion_alert, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_npc( l_dlg_m80_intrusion_alert, 0, TRUE, 'sound\dialog\mission\m10\m10_fud_hologram_00105', FALSE, fud_switch, 0.0, "", "System Voice : Intrusion alert.", TRUE);
							dialog_line_npc( l_dlg_m80_intrusion_alert, 1, TRUE, 'sound\dialog\mission\m10\m10_fud_hologram_00105', FALSE, fud_switch, 0.0, "", "System Voice : Intrusion alert.", TRUE);
            l_dlg_m80_intrusion_alert = dialog_end( l_dlg_m80_intrusion_alert, TRUE, TRUE, "" );
           

            if b_fud_active == FALSE then
							thread(fud_intrustion_loop());
						end
end


// === out of the tube
script dormant f_dialogue_player_has_control()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialogue_player_has_control" );
	
	hud_play_pip_from_tag( bink\campaign\M10_A_60 );
				sleep_s(9);
				thread(f_screenshake_event_med(-3, -1, -0.1, sfx_rumble_cryo()));


	
end

// === f_dialog_lab_didact_event
script dormant f_dialog_lab_didact_event()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_lab_didact_event" );
	l_dialog_id = dialog_start_foreground( "DIDACT_EVENT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		dialog_line_chief  ( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00100', FALSE, NONE, 0.0, "", "Master Chief : How long was I out?" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00101', FALSE, NONE, 0.0, "", "Cortana : 4 years, 7 months, 10 days." );
		//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00107', FALSE, NONE, 0.0, "", "Master Chief : If the UNSC hasn't responded to our rescue beacon by now, they're not going to." );
		dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00106', FALSE, NONE, 0.0, "", "Master Chief : They should have found us by now." );
		//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00102', FALSE, NONE, 0.0, "", "Cortana : Rescue beacons are still transmitting but" );

		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		wake(f_dialog_lab_didact_scan);
end


// === f_dialog_lab_didact_scan
script dormant f_dialog_lab_didact_scan()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_lab_didact_scan" );
		sleep_until( volume_test_players(vo_didact_scan), 1);
	l_dialog_id = dialog_start_foreground( "DIDACT_SCAN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		// beging the scan here
		if ( dialog_foreground_id_active_check(l_dialog_id) ) then
			wake (f_scan_event_real);
		end

		// delay for chief to react
		sleep_s(1);
		
dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00103', FALSE, NONE, 0.0, "", "Master Chief : What's that?" );
dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00104', FALSE, NONE, 0.0, "", "Cortana : Sensor scan, high intensity! Doesn't match any known patterns." );
dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00104a', FALSE, NONE, 0.0, "", "Master Chief : How close are we to the Observation Deck?" );
dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lab_didact_event_00105', FALSE, NONE, 0.0, "", "Cortana : It's directly above us." );
	thread(m10_objective_1_nudge());
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
end

script dormant f_dialog_m10_elevator_in_sight()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dialog_elevator_in_sight" );
	kill_script(m10_objective_2_nudge);
	sleep_forever(m10_objective_1_nudge);
	   kill_script(m10_objective_2_nudge);
   sleep_forever(m10_objective_1_nudge);
		b_objective_2_complete = TRUE;
	l_dialog_id = dialog_start_foreground( "ELEVATOR_IN_SIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_pre_elevator_ics_00102a', FALSE, NONE, 0.0, "", "Cortana : The elevator doors look sealed tight." );
	//	dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_pre_elevator_ics_00103', FALSE, NONE, 0.0, "", "Master Chief: Not a problem." );

		//if ( dialog_foreground_id_active_check(l_dialog_id) ) then
			NotifyLevel("obs waypoint set");
		//end

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
end


/*// === f_dialog_lab_pre_elevator_ics
script dormant f_dialog_lab_pre_elevator_ics()
//dprint( "f_dialog_lab_pre_elevator_ics" );

	L_dlg_lab_pre_elevator_ics = dialog_start_foreground( "ELEVATOR_PRE_ICS", L_dlg_lab_pre_elevator_ics, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );		
		if ( dialog_foreground_id_active_check(L_dlg_lab_pre_elevator_ics) ) then
			sleep_until (volume_test_players(tv_elevator_lobby) or volume_test_players_lookat(tv_elevator_ICS_door_lookat, 15.0, 5.0) or (not dialog_foreground_id_active_check(L_dlg_lab_pre_elevator_ics)), 1);
		end
		
		dialog_line_cortana( L_dlg_lab_pre_elevator_ics, 0, not f_B_elevator_ICS_started(), 'sound\dialog\mission\m10\m10_pre_elevator_ics_00102', FALSE, NONE, 0.0, "", "Cortana : Those doors look sealed tight." );
		dialog_line_chief  ( L_dlg_lab_pre_elevator_ics, 1, not f_B_elevator_ICS_started(), 'sound\dialog\mission\m10\m10_pre_elevator_ics_00103', FALSE, NONE, 0.0, "", "Master Chief : Not a problem." );
	L_dlg_lab_pre_elevator_ics = dialog_end( L_dlg_lab_pre_elevator_ics, TRUE, TRUE, "" );

end*/

// === f_dialog_elevator_ics_pry
script dormant f_dialog_elevator_ics_pry()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_elevator_ics_pry" );

	l_dialog_id = dialog_start_foreground( "ELEVATOR_PRY", l_dialog_id, not dialog_foreground_id_active_check(L_dlg_lab_pre_elevator_ics), DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\Mission\M10\m_m10_mc_0015', FALSE, NONE, 0.0, "", "MASTER CHIEF: 7 : <sound of prying the door open>" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_observatory_start
script dormant f_dialog_observatory_start()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_start" );
		
		kill_script(m10_objective_3_nudge);
		kill_script(m10_objective_1_nudge);
		sleep_forever(m10_objective_1_nudge);
		sleep_forever(m10_objective_3_nudge);
	l_dialog_id = dialog_start_foreground( "OBSERVATORY_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_observatory_00100', FALSE, NONE, 0.0, "", "Cortana : That's the last of them." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_observatory_00101', FALSE, NONE, 0.0, "", "Cortana : Find the override for the blast shields so we can see what we're up against." );

		//if ( dialog_foreground_id_active_check(l_dialog_id) ) then
			NotifyLevel("obs waypoint set");
		//end

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
end

/*// === f_dialog_observatory_start
script dormant f_dialog_observatory_start_optional()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_start_optional" );

	sleep_s (5);
	sleep_until (volume_test_players (tv_obs_optional_start_dia));
	
	l_dialog_id = dialog_start_foreground( "OBSERVATORY_START_OPT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_observatory_00102', FALSE, NONE, 0.0, "", "Cortana : The good news is these Covenant aren't outfitted like standard military." );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_observatory_00103', FALSE, NONE, 0.0, "", "Cortana : It's possible we just came across a rogue salvage ship." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/


//// === f_dialog_observatory_start
//script dormant f_dialog_observatory_cleared_pre_open()
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
//
//	l_dialog_id = dialog_start_foreground( "OBSERVATORY_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0005b', FALSE, NONE, 0.0, "", "CORTANA: 108 : I’ve got to restart the power grid if we’re going to bring the Dawn’s sensor array back online." );
//		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0005c', FALSE, NONE, 0.0, "", "CORTANA: 109 : Jack me into that console!" );
//
//		if ( dialog_foreground_id_active_check(l_dialog_id) ) then
//			sleep(5);
//		end
//
//	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
//
//end

// === f_dialog_observatory_get_objective_beacon_start
script dormant f_dialog_observatory_try_to_leave_optional()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_get_objective_beacon" );
	sleep_until (volume_test_players (tv_enter_obs));
	
	kill_script(m10_objective_1_nudge);
	l_dialog_id = dialog_start_foreground( "OBS_TRY_TO_LEAVE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_observatory_pods_00102', FALSE, NONE, 0.0, "", "Cortana : The decompression put the room into lockdown." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_observatory_pods_00103', FALSE, NONE, 0.0, "", "Cortana : It’ll take a few minutes to repressurize." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_observatory_get_objective_beacon
global boolean GI_DEMO_END_VO_COMPLETE = false;
script dormant f_dialog_observatory_get_objective_beacon_main()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_get_objective_beacon" );
		kill_script(m10_objective_5_nudge);
		sleep_forever(m10_objective_5_nudge);
	l_dialog_id = dialog_start_foreground( "OBS_ELEVATOR02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00100', FALSE, NONE, 0.0, "", "Master Chief : We need to get off this ship." );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00101', FALSE, NONE, 0.0, "", "Cortana : We've got bigger problems." );
			dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_elevator_00106', FALSE, NONE, 0.0, "", "Cortana : We’ve got a Cruiser on an intercept course." );
			//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00103', FALSE, NONE, 0.0, "", "Cortana : If we don't do something about that, we're not going anywhere." );
			dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00101_5', FALSE, NONE, 0.0, "", "Cortana : Head for the elevator banks." );
			b_elevator_banks_blip = TRUE;
				if b_used_fud_holgoram == FALSE then
			dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00104', FALSE, NONE, 0.0, "", "Master Chief : Are any of the ship-to-ship defenses online?" );
			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00105', FALSE, NONE, 0.0, "", "Cortana : Only the Hyperion missiles, but we'll have to fire them manually from the outer hull." );
			else
			dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m10\m10_elevator_00113', FALSE, NONE, 0.0, "", "Master Chief : Didn’t the ship’s sensors say there were still weapons systems online?" );
			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m10\m10_elevator_00114', FALSE, NONE, 0.0, "", "Cortana : Yes, but since the ship was torn in half, we can’t access the weapons stations. We’ll have to fire them manually from the outer hull." );
			end
			b_get_objective_beacon = TRUE;
		//	dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m10\m10_elevator_00108', FALSE, NONE, 0.0, "", "Master Chief : Can they take down the cruiser?" );
		//	dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m10\m10_elevator_00107', FALSE, NONE, 0.0, "", "Cortana : Normally, they wouldn’t do much but luckily for us, their shields are down." );
			//dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m10\m10_elevator_00103', FALSE, NONE, 0.0, "", "Cortana : Assuming they don't raise them, that missile is going to come as one heck of a surprise." );
			
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	GI_DEMO_END_VO_COMPLETE = true;

end


script dormant f_dialog_observatory_get_objective_beacon_alt()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_get_objective_beacon_alt" );
	l_dialog_id = dialog_start_foreground( "OBS_ELEVATOR02_ALT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_elevator_00109', FALSE, NONE, 0.0, "", "Master Chief : Those ships could get us back to UNSC space." );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_elevator_00110', FALSE, NONE, 0.0, "", "Cortana : ‘Could’ is a generous word... especially since that large Cruiser heading our way will almost certainly blow us out of the sky long before that." );
			if b_used_fud_holgoram == FALSE then
			dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_observatory_get_objective_beacon_00104', FALSE, NONE, 0.0, "", "Master Chief : Are any of the ship-to-ship defenses online?" );
			dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m10\m10_elevator_00111', FALSE, NONE, 0.0, "", "Cortana : No, but why should that stop us? Head for the elevators." );
			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m10\m10_elevator_00112', FALSE, NONE, 0.0, "", "Cortana : The Hyperion missiles technically still have power, but we’ll have to fire them manually from the outer deck." );
			else
			dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_elevator_00113', FALSE, NONE, 0.0, "", "Master Chief : Didn’t the ship’s sensors say there were still weapons systems online?" );
			dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m10\m10_elevator_00114', FALSE, NONE, 0.0, "", "Cortana : Yes, but since the ship was torn in half, we can’t access the weapons stations. We’ll have to fire them manually from the outer hull." );
			end
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			
		
end

script dormant f_dialog_m10_post_second_elevator()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
		kill_script(m10_objective_6_nudge);
		sleep_forever(m10_objective_6_nudge);
		kill_script(m10_objective_7_nudge);
		sleep_forever(m10_objective_7_nudge);
dprint( "f_dialog_m10_post_second_elevator" );

	l_dialog_id = dialog_start_foreground( "POST_SECOND_ELEVATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
				sleep_s(1);
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_elevator_00104', FALSE, NONE, 0.0, "", "Cortana : More of them!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			
end

script static void f_dialog_m10_observ_atmosphere_breach()
dprint("f_dialog_m10_observ_atmosphere_breach");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "ATMOSPHERE_BREACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_observatory_pods_00105', FALSE, NONE, 0.0, "", "System Voice : Warning. Atmosphere breach.", TRUE);
													dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_observatory_pods_00106', FALSE, NONE, 0.0, "", "System Voice : Activating emergency barricades.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script dormant f_dialog_m10_observ_stragglers()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dialog_m10_observ_stragglers" );

	l_dialog_id = dialog_start_foreground( "OBSERV_STRAGGLERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_blastshield_moreenemies_00100', FALSE, NONE, 0.0, "", "Cortana : I'm still reading some stragglers. Clear them out." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			
end


// === f_dialog_m10_lookout_combat
script dormant f_dialog_m10_lookout_combat()

	// wait until a bunch of people are dead and the player is in a certain spot
	sleep_until(volume_test_players(f_dialog_lookout), 1);

	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dialog_m10_lookout_combat" );
	l_dialog_id = dialog_start_foreground( "LOOKOUT_COMBAT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lookout_shields_00101', FALSE, NONE, 0.0, "", "Cortana : That cruiser's shields are down" );
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_lookout_shields_00102', FALSE, NONE, 0.0, "", "Cortana : Assuming they don't raise them, that missile's going to be one heck of a surprise." );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
//	sleep_s(15);
	//wake(f_dialog_lookout_linger);
end


/*script dormant f_dialog_lookout_linger()
		sleep_until(volume_test_players(f_dialog_lookout), 1);
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  dprint( "f_dialog_lookout_linger" );
	l_dialog_id = dialog_start_foreground( "LOOKOUT_LINGER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lookout_00104', FALSE, NONE, 0.0, "", "Master Chief : There's something out there." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_lookout_00105', FALSE, NONE, 0.0, "", "Cortana : A large celestial body." );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_lookout_00106', FALSE, NONE, 0.0, "", "Cortana : Maybe the Covenant's base of operations?" );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end*/

script dormant f_dialog_lookout_post()
	sleep_until(volume_test_players(lookout_post), 1);
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  dprint( "f_dialog_lookout_post" );
	l_dialog_id = dialog_start_foreground( "LOOKOUT_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_lookout_00102', FALSE, NONE, 0.0, "", "Master Chief : These Covenant seem more fanatical than the ones we've fought before." );
		//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_lookout_00103', FALSE, NONE, 0.0, "", "Cortana : It HAS been four years. Who knows what they've gotten up to?" );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m10_cafe()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  dprint( "f_dialog_m10_cafe" );
	l_dialog_id = dialog_start_foreground( "M10_CAFE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_cafe_00100', FALSE, NONE, 0.0, "", "Master Chief : How far to the missile?" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_cafe_00101', FALSE, NONE, 0.0, "", "Cortana : We're just about there." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m10_cafe_lookout()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  dprint( "f_dialog_m10_cafe_lookout" );
	l_dialog_id = dialog_start_foreground( "M10_CAFE_LOOKOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\global_chatter_00137', FALSE, NONE, 0.0, "", "Cortana : Look out!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



// === f_dialog_observatory_get_objective_beacon
script dormant f_dialog_observatory_pre_airlock()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_observatory_get_objective_beacon" );

	l_dialog_id = dialog_start_foreground( "OBS_PRE_AIRLOCK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_elevator_00100', FALSE, NONE, 0.0, "", "Cortana : Luckily, their shields are down." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_elevator_00103', FALSE, NONE, 0.0, "", "Cortana : Assuming they don't raise them, that Archer missile is going to come as one heck of a surprise." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_beacon_prep
/*script dormant f_dialog_beacon_prep()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_beacon_prep" );

	l_dialog_id = dialog_start_foreground( "BEACON_PREP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00100', FALSE, NONE, 0.0, "", "Cortana : The auxiliary launch station should be to your left out of the airlocks." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00101', FALSE, NONE, 0.0, "", "Cortana : You'll have to prime the launch for--" );
		dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00102', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00103', FALSE, NONE, 0.0, "", "Cortana : It's nothing. Just get to the launch station." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/


//=== f_dialog_beacon_controls
script dormant f_dialog_beacon_launch_beacon()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	
	l_dialog_id = dialog_start_foreground( "BEACON_LAUNCH_BEACON", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_crash_objective_00107', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to find the missile controls." );
			//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_launch_beacon_01_00101', FALSE, NONE, 0.0, "", "Cortana : We've got to fire that missile NOW!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
		

//=== f_dialog_beacon_controls
script dormant f_dialog_beacon_controls()
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	
	l_dialog_id = dialog_start_foreground( "BEACON_BEACON01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_controls_00102', FALSE, NONE, 0.0, "", "Cortana : Launch the missile!" );
			
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

// === f_dialog_beacon_get_objective_magac
script dormant f_dialog_beacon_get_objective_magac()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_beacon_get_objective_magac" );

	l_dialog_id = dialog_start_foreground( "BEACON_MAGAC", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, on the deck!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00101', FALSE, NONE, 0.0, "", "Cortana : Phantoms!" );
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00101_2', FALSE, NONE, 0.0, "", "Cortana : You'll have to hold them off long enough to fire the missile!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end
/*
// === f_dialog_fix_blast_door
script dormant f_dialog_fix_blast_door()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	kill_script(m10_objective_8_nudge);
	sleep_forever(m10_objective_8_nudge);
//dprint( "f_dialog_fix_blast_door" );

	l_dialog_id = dialog_start_foreground( "FIX_BLAST_DOOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00103', FALSE, NONE, 0.0, "", "Cortana : Great. The blast door's jammed. The missile won't fire until it's cleared." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00102', FALSE, NONE, 0.0, "", "Cortana : Get down there! " );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end	*/
		
 //=== f_dialog_beacon_launch_beacon_02
/*script dormant f_dialog_beacon_launch_beacon_02()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "f_dialog_beacon_launch_beacon_02" );

	l_dialog_id = dialog_start_foreground( "BEACON_BEACON02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
	//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0022', beac_control_plinth, 0.0, "", "CORTANA: 32 : Yes!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0023', beac_control_plinth, 0.0, "", "CORTANA: 33 : Beacon away!" );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/


// === f_dialog_beacon_get_objective_leave_beacon
script dormant f_dialog_beacon_get_objective_leave_beacon()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_beacon_get_objective_leave_beacon" );
	kill_script(m10_objective_9_nudge);
	sleep_forever(m10_objective_9_nudge);
	l_dialog_id = dialog_start_foreground( "BEACON_COMPLETE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
		//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00100', FALSE, NONE, 0.0, "", "Cortana : GO GO GO!" );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00101', FALSE, NONE, 0.0, "", "Cortana : It's using a gravity well to pull us inside the surface! " );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00106', FALSE, NONE, 0.0, "", "Cortana : We've got to hurry; the second we cross the dome's event horizon, its atmosphere is going to tear us apart." );
		//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00102', FALSE, NONE, 0.0, "", "Cortana : We've got to get off the Dawn!" );
		dialog_line_chief	 ( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00103', FALSE, NONE, 0.0, "", "Master Chief : Where are the closest escape pods?" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00104', FALSE, NONE, 0.0, "", "Cortana : Aft vehicle bay!" );
		dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00107', FALSE, NONE, 0.0, "", "Cortana : I’m tagging the closest airlock-go!" );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
/*
script dormant f_dialog_vo_airlock_return()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
 dprint( "f_dialog_vo_airlock_return" );

	l_dialog_id = dialog_start_foreground( "AIRLOCK_RETURN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00106', FALSE, NONE, 0.0, "", "Cortana : We've got to hurry; the second we cross the dome's event horizon, its atmosphere is going to tear us apart." );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end*/




//// === f_dialog_End_Start: Dialog
//script dormant f_dialog_End_Start()
////dprint( "::: f_dialog_End_Start :::" );
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
//	sleep_until( dialog_id_played_check(L_dialog_ShipVO_NoPods), 1 );
//
//	l_dialog_id = dialog_start_foreground( "END_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00106', FALSE, NONE, 0.0, "", "Cortana : We've got to hurry; the second we cross the dome's event horizon, its atmosphere is going to tear us apart." );
//		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00107', FALSE, NONE, 0.0, "", "Cortana : I’m tagging the closest airlock - Go!" );
//
//		if ( dialog_foreground_id_active_check(L_dialog_End_Start) ) then
//			sleep_until( ((current_zone_set_fully_active() == S_zoneset_28_airlock_32_broken) and (not(door_airlock_2_interior->check_close()))) or (not dialog_foreground_id_active_check(L_dialog_End_Start)), 1 );
//		end
//
//			dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00103', FALSE, NONE, 0.0, "", "Master Chief : Where are the closest escape pods?" );
//		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_leave_beacon_00104', FALSE, NONE, 0.0, "", "Cortana : Aft vehicle bay!" );
//		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
//
//end

// === f_dialog_Breakhall01_Action: Dialog
script dormant f_dialog_Breakhall01_Action()
//dprint( "::: f_dialog_Breakhall01_Action :::" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();

	l_dialog_id = dialog_start_foreground( "BREAKHALL_ACTION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
				dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_vehicle_bay_airlock_00100', FALSE, NONE, 0.0, "", "Cortana : We’re almost there!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_BrokenAction_Post: Dialog
script dormant f_dialog_BrokenAction_Post()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_BrokenAction_Post :::" );

	// fire up the ship vo
	//wake( f_dialog_BrokenAction_ShipVo );

	// Make sure the Breakhall01 Action vo is disabled
	L_dialog_Breakhall01_Action = dialog_disable( STR_dialog_Breakhall01_Action, L_dialog_Breakhall01_Action, 1.0, TRUE );
	sleep_forever( f_dialog_Breakhall01_Action );

	l_dialog_id = dialog_start_foreground( "BROKENACTION_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.25 );
	
		// wait for the ship VO to have finished
		//sleep_until( dialog_id_played_check(L_dialog_BrokenAction_ShipVo), 1 );

		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_broken_hall_00100', FALSE, NONE, 0.0, "", "System Voice : Danger - gravity system failure imminent.", TRUE);
		dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_broken_hall_00101', FALSE, NONE, 0.0, "", "System Voice : Proceed to nearest emergency lifestation.", TRUE);
		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_broken_hall_00102', FALSE, NONE, 0.0, "", "Cortana : All but one of the grav generators just went dark!" );
		dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_broken_hall_00103', FALSE, NONE, 0.0, "", "Master Chief : Just keep me pointed at that vehicle bay." );
		b_blip_maintenance = TRUE;
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_BrokenAction_ship_vo: Dialog
script dormant f_dialog_BrokenAction_ShipVo()
//dprint( "::: f_dialog_BrokenAction_ship_vo :::" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_Maintenance_End :::" );

	l_dialog_id = dialog_start_foreground( "BROKENACTION_SHIPVO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00105', FALSE, NONE, 0.0, "", "System Voice : Please immediately proceed to the nearest lifestation.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00114', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 25%.", TRUE);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end


// === f_dialog_Maintenance_End: Dialog
script dormant f_dialog_Maintenance_End()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_Maintenance_End :::" );

	l_dialog_id = dialog_start_foreground( "MAINTENANCE_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.25 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_maintenance_end_00100', FALSE, NONE, 0.0, "", "Cortana : The starboard bulkhead’s collapsing!" );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_maintenance_end_00101', FALSE, NONE, 0.0, "", "Cortana : If that goes, the hull won’t be enough to hold us together!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
end

// === f_dialog_Run_Start: Dialog
script dormant f_dialog_Run_Start()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
dprint( "::: f_dialog_Run_Start :::" );
	kill_script(m10_objective_10_nudge);
	sleep_forever(m10_objective_10_nudge);
	b_objective_10_complete = TRUE;
	l_dialog_id = dialog_start_foreground( "RUN_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_vehicle_bay_airlock_00100', FALSE, NONE, 0.0, "", "Cortana : We’re almost there!" );
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_catastrophic_depressurization()
dprint("f_dialog_catastrophic_depressurization");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
	kill_script(m10_objective_10_nudge);
	sleep_forever(m10_objective_10_nudge);
	b_objective_10_complete = TRUE;
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "SHIPVO_CATASTROPHIC_DEPRESSURIZATION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00213', FALSE, NONE, 0.0, "", "System Voice: Warning. Catastrophic depressurization.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dialog_system_depressurization()
dprint("f_dialog_system_depressurization");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "SHIPVO_DEPRESSURIZATION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00212', FALSE, NONE, 0.0, "", "System Voice: Warning. System depressurization.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dialog_emergency_weapon_cache()
dprint("f_dialog_emergency_weapon_cache");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "EMERGENCY_WEAPON_CACHE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_weaponscrate_00100', FALSE, NONE, 0.0, "", "System Voice: Emergency weapon cache deployed.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

// === f_dialog_VehicleBay_Airlock: Dialog
script dormant f_dialog_VehicleBay_Airlock()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_VehicleBay_Airlock :::" );
	kill_script(m10_objective_10_nudge);
	sleep_forever(m10_objective_10_nudge);
	b_objective_10_complete = TRUE;
	l_dialog_id = dialog_start_foreground( "VEHICLEBAY_AIRLOCK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
	//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_vehicle_bay_airlock_00102', FALSE, NONE, 0.0, "", "Cortana : There! The escape pods are on the far side of that vehicle bay!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


// === f_dialog_PodChase_Start: Dialog
script dormant f_dialog_rail_sequence()
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_rail_sequence :::" );
	l_dialog_id = dialog_start_foreground( "RAIL_BEGIN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.5 );
			//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_vehicle_bay_airlock_00101', FALSE, NONE, 0.0, "", "Cortana : Just once I wish you'd to take me somewhere NICE." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end
/*
// === f_dialog_PodChase_End: Dialog
script dormant f_dialog_PodChase_End()
//dprint( "::: f_dialog_PodChase_End :::" );

	L_dialog_PodChase_End = dialog_start_foreground( "PODCHASE_END", L_dialog_PodChase_End, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
		//dialog_line_cortana( L_dialog_PodChase_End, 0, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0043a', FALSE, NONE, 0.0, "", "CORTANA: 58a : We're too late to escape the planet's gravity well." );
		dialog_line_cortana( L_dialog_PodChase_End, 1, TRUE, 'sound\dialog\Mission\M10\m_m10_cortana_0043b', FALSE, NONE, 0.0, "", "CORTANA: 58b : We'll have to aim for a planetary insertion and hope for the best!" );
	L_dialog_PodChase_End = dialog_end( L_dialog_PodChase_End, TRUE, TRUE, "" );
	
end*/

// === f_dialog_ShipVO_NoPods: Dialog
script dormant f_dialog_ShipVO_NoPods()		// INTEGRATED
//dprint( "::: f_dialog_ShipVO_NoPods :::" );
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( not dialog_background_id_active_check(L_dialog_ShipVO_NoPods) ) then

//dprint( "::: f_dialog_VehicleBay_Airlock :::" );

	l_dialog_id = dialog_start_foreground( "SHIPVO_NOPODS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00100', FALSE, NONE, 0.0, "", "System Voice: Emergency escape pods have been depleted in this area.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00111', FALSE, NONE, 0.0, "", "System Voice: Please board one of the remaining emergency escape vehicles in an orderly fashion.", TRUE);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
end



// === f_dialog_ShipVO_Maintenance: Dialog
script dormant f_dialog_ShipVO_Maintenance()	// INTEGRATED
//dprint( "::: f_dialog_ShipVO_Maintenance :::" );
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( not dialog_background_id_active_check(L_dialog_ShipVO_Maintenance) ) then
	
		L_dialog_ShipVO_Maintenance = dialog_start_background( "SHIPVO_MAINTENANCE", L_dialog_ShipVO_Maintenance, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.125 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00102', FALSE, NONE, 0.0, "", "System Voice: Warning.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00103', FALSE, NONE, 0.0, "", "System Voice: Hull integrity at 20%.", TRUE);
			dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_escape_00104', FALSE, NONE, 0.0, "", "System Voice: Initiating emergency shutdown of all Class 5 subsystems.", TRUE);
			dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_escape_00101', FALSE, NONE, 0.0, "", "System Voice: Nearest lifestation is available on Deck 107-C-17.", TRUE);
		L_dialog_ShipVO_Maintenance = dialog_end( L_dialog_ShipVO_Maintenance, TRUE, TRUE, "" );
		
	end

end

// === f_dialog_ShipVO_ExplosionAlley: Dialog
script dormant f_dialog_ShipVO_ExplosionAlley()	// INTEGRATED
static long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "::: f_dialog_ShipVO_ExplosionAlley :::" );

	if ( not dialog_background_id_active_check(l_dialog_id) ) then
	
		l_dialog_id = dialog_start_background( "SHIPVO_EXPLOSIONALLEY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.125 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00102', FALSE, NONE, 0.0, "", "System Voice: Warning.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00106', FALSE, NONE, 0.0, "", "System Voice: Critical ship damage.", TRUE);
			dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_escape_00107', FALSE, NONE, 0.0, "", "System Voice: Hull integrity at 5%.", TRUE);
			dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_escape_00109', FALSE, NONE, 0.0, "", "System Voice: Personnel are advised to evacuate immediately.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
	end

end

// === f_dialog_ShipVO_Blackout: Dialog
script dormant f_dialog_ShipVO_Blackout()	// INTEGRATED
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( not dialog_background_id_active_check(L_dialog_ShipVO_Blackout) ) then
	
		L_dialog_ShipVO_Blackout = dialog_start_background( "SHIPVO_BLACKOUT", L_dialog_ShipVO_Blackout, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.125 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00102', FALSE, NONE, 0.0, "", "System Voice: Warning.", TRUE);
			dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00108', FALSE, NONE, 0.0, "", "System Voice: Hull collapse is imminent.", TRUE);
		L_dialog_ShipVO_Blackout = dialog_end( L_dialog_ShipVO_Blackout, TRUE, TRUE, "" );
		
	end

end

// === xxx: Dialog
script dormant f_dialog_ShipVO_VehicleBay()	// INTEGRATED
//dprint( "::: f_dialog_ShipVO_VehicleBay :::" );
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( not dialog_background_id_active_check(L_dialog_ShipVO_VehicleBay) ) then
	
		L_dialog_ShipVO_VehicleBay = dialog_start_background( STR_dialog_ShipVO_VehicleBay, L_dialog_ShipVO_VehicleBay, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.125 );
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00110', FALSE, NONE, 0.0, "", "System Voice: Lifestation C-17.", TRUE);
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00111', FALSE, NONE, 0.0, "", "System Voice: Please board one of the remaining emergency escape vehicles in an orderly fashion.", TRUE);
		L_dialog_ShipVO_VehicleBay = dialog_end( L_dialog_ShipVO_VehicleBay, TRUE, TRUE, "" );
		
	end

end


//----------------------------- BEACON -------------------------------------------------------------------------

script dormant f_dialog_airlock_beacon()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_elevator_ics_pry" );

	l_dialog_id = dialog_start_foreground( "AIRLOCK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00100', FALSE, NONE, 0.0, "", "Cortana : The auxiliary launch station should be to your left out of the airlocks." );
		hud_rampancy_players_set( 0.05 );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00101', FALSE, NONE, 0.0, "", "Cortana : You'll have to prime the launch for" );
		hud_rampancy_players_set( 0.0 );
		dialog_line_chief ( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00102', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );
		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m10\m10_beacon_prep_00103', FALSE, NONE, 0.0, "", "Cortana : It's nothing. Just get to the launch station." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_beacon_enter()

		print ("blip missile control");
		NotifyLevel("blip missile control");
end

script dormant f_dialog_vo_planet_reveal()

local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_elevator_ics_pry" );

	l_dialog_id = dialog_start_foreground( "BEACON ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
			//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_outer_deck_covenant_00100', FALSE, NONE, 0.0, "", "Cortana : Covenant boarding parties!" );
		//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_outer_deck_covenant_00101a', FALSE, NONE, 0.0, "", "Cortana : They're looking for a way inside!" );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_enter_00100', FALSE, NONE, 0.0, "", "Cortana : Uh - I'm sorry. Did I miss a Forerunner planet at some point?" );
		dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_enter_00101', FALSE, NONE, 0.0, "", "Master Chief : One thing at a time." );
		//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m10\m10_beacon_enter_02101', FALSE, NONE, 0.0, "", "Master Chief : The missile controls." );
		//dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m10\m10_beacon_enter_00102', FALSE, NONE, 0.0, "", "Cortana : Right. First things first." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_near_missile_room()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_elevator_ics_pry" );

	l_dialog_id = dialog_start_foreground( "NEAR MISSiLE ROOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_controls_00100', FALSE, NONE, 0.0, "", "Cortana : The launch station's there!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	

end
script dormant f_dialog_kill_zone()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_kill_zone" );

	l_dialog_id = dialog_start_foreground( "KILL_ZONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.0 );
				//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_controls_00101', FALSE, NONE, 0.0, "", "Cortana : They're in the kill zone!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dialog_missile_launched()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_missile_launched" );
			sleep_s(2);
			dprint ("Cortana: Launch initiated!");
			sound_impulse_start ('sound\dialog\mission\m10\m10_beacon_controls_00103', NONE, 1);
			sleep (sound_impulse_time('sound\dialog\mission\m10\m10_beacon_controls_00103'));
	//l_dialog_id = dialog_start_foreground( "NEAR MISSiLE ROOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
			//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_controls_00103', FALSE, NONE, 0.0, "", "Cortana : Launch initiated!" );
	//l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_magec_jam()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//dprint( "f_dialog_elevator_ics_pry" );

	l_dialog_id = dialog_start_foreground( "PHANTOM BARK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 );
		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00103', FALSE, NONE, 0.0, "", "Cortana : Great. The blast door's jammed. The missile won't fire until it's cleared." );
		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_beacon_get_objective_magac_00102', FALSE, NONE, 0.0, "", "Cortana : Get down there!" );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

script static void f_dialog_m10_objective_1()
dprint("f_dialog_m10_objective_1");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_1_complete), 'sound\dialog\mission\m10\m10_crash_objective_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to get us up to the Observation Deck." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m10_objective_2()
dprint("f_dialog_m10_objective_2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_2_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id,  (not b_objective_2_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_2_complete), 'sound\dialog\mission\m10\m10_crash_objective_00101', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to activate the elevator so we can get moving." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_2_complete, b_objective_2_complete, "" );
		end
end

script static void f_dialog_m10_objective_3()
dprint("f_dialog_m10_objective_3");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_3_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id,  (not b_objective_3_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_3_complete), 'sound\dialog\mission\m10\m10_crash_objective_00102', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to clear out all these Covenant." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_3_complete, b_objective_3_complete, "" );
		end
end


script static void f_dialog_m10_objective_4()
dprint("f_dialog_m10_objective_4");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_4_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_4", l_dialog_id,  (not b_objective_4_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_4_complete), 'sound\dialog\mission\m10\m10_crash_objective_00103', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to activate the blast door." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_4_complete, b_objective_4_complete, "" );
		end
end

script static void f_dialog_m10_objective_5()
dprint("f_dialog_m10_objective_5");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_5_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_5", l_dialog_id,  (not b_objective_5_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_5_complete), NONE, FALSE, NONE, 0.0, "", "Cortana: Chief, you need to take out these Covenant before we can move on." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
		end
end

script static void f_dialog_m10_objective_6()
dprint("f_dialog_m10_objective_6");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_6_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_6", l_dialog_id,  (not b_objective_6_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_6_complete), 'sound\dialog\mission\m10\m10_crash_objective_00105', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to get to the elevator." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_6_complete, b_objective_6_complete, "" );
		end
end

script static void f_dialog_m10_objective_7()
dprint("f_dialog_m10_objective_7");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_7_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_7", l_dialog_id,  (not b_objective_7_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_7_complete), 'sound\dialog\mission\m10\m10_crash_objective_00106', FALSE, NONE, 0.0, "", "Cortana : Chief, get in the elevator." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_7_complete, b_objective_7_complete, "" );
		end
end

script static void f_dialog_m10_objective_8()
dprint("f_dialog_m10_objective_8");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_8_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_8", l_dialog_id,  (not b_objective_8_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_8_complete), NONE, FALSE, NONE, 0.0, "", "Cortana: Chief, you need to find the missile controls." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_8_complete, b_objective_8_complete, "" );
		end
end

script static void f_dialog_m10_objective_9()
dprint("f_dialog_m10_objective_9");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_9_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_7", l_dialog_id,  (not b_objective_9_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_9_complete), 'sound\dialog\mission\m10\m10_crash_objective_00108', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to initiate the manual launch." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_9_complete, b_objective_9_complete, "" );
		end
end

script static void f_dialog_m10_objective_10()
dprint("f_dialog_m10_objective_10");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_10_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_10", l_dialog_id,  (not b_objective_10_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, (not b_objective_10_complete), 'sound\dialog\mission\m10\m10_crash_objective_00109', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to get us to the escape pods." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_10_complete, b_objective_10_complete, "" );
		end
end



// =================================================================================================
// =================================================================================================
// SHIP STATUS
// =================================================================================================
// =================================================================================================


script static void f_dialog_m10_hull_integrity_30()
dprint("f_dialog_m10_hull_integrity_30");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "HULL_INTEGRITY_30", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00115', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 30%.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script static void f_dialog_m10_hull_integrity_25()
dprint("f_dialog_m10_hull_integrity_25");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "HULL_INTEGRITY_25", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00114', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 25%.", TRUE);
													dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m10\m10_escape_00105', FALSE, NONE, 0.0, "", "System Voice : Please immediately proceed to the nearest lifestation.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script static void f_dialog_m10_hull_integrity_20()
dprint("f_dialog_m10_hull_integrity_20");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "HULL_INTEGRITY_20", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00103', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 20%.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script static void f_dialog_m10_hull_integrity_15()
dprint("f_dialog_m10_hull_integrity_15");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "HULL_INTEGRITY_15", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00113', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 15%.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script static void f_dialog_m10_hull_integrity_10()
dprint("f_dialog_m10_hull_integrity_10");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "HULL_INTEGRITY_10", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
													dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m10\m10_escape_00112', FALSE, NONE, 0.0, "", "System Voice : Hull integrity at 10%.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end