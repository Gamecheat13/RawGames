//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m90_dialog
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// DIALOG
// -------------------------------------------------------------------------------------------------
// DEFINES


// VARIABLES


// dialog ID variables

global boolean b_third_gun_destroyed = FALSE;




// --- END



script dormant f_dialog_m90_didact_ship_exterior()
dprint("f_dialog_m90_didact_ship_exterior");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_EXTERIOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       	
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00100', FALSE, NONE, 0.0, "", "Cortana : Broadsword's hull integrity is stable. We'll be SAFE as long as we stay below the Didact's shields." );
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00101', FALSE, NONE, 0.0, "", "Master Chief : Where's the Composer?" );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00102', FALSE, NONE, 0.0, "", "Cortana : Close. I should be able to guide us to it." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_didact_ship_exterior_second()
dprint("f_dialog_m90_didact_ship_exterior_second");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_EXTERIOR_SECOND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
								dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00103', FALSE, NONE, 0.0, "", "Didact : You have not been Composed. Such inoculation should not have been possible." );
								//dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00113', FALSE, NONE, 0.0, "", "Didact : Let us hope the others of your species do not share this talent for resistance, lest stronger means than the Composer prove necessary." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00114', FALSE, NONE, 0.0, "", "Cortana : Locking onto his transmission..." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end



script dormant f_dialog_m90_didact_ship_exterior_fourth()
dprint("f_dialog_m90_didact_ship_exterior_fourth");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_EXTERIOR_FOURTH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_slipspace_00112', FALSE, NONE, 0.0, "", "Cortana : Cherenkov radiation fluctuating! We're coming out of slipspace." );
							sleep_s(2);

							start_radio_transmission( "fleetcom_transmission_name" );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00100', FALSE, NONE, 0.0, "", "Fleetcom Watch : [At current velocity] - hostile will achieve Earth orbit in 4 minutes." ,TRUE);
							end_radio_transmission();

							start_radio_transmission( "infinity_transmission_name" );
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00101', FALSE, NONE, 0.0, "", "Infinity Comm : Roger. Battle Group Dakota, close on the Forerunner vessel.", TRUE);
							end_radio_transmission();

							wake(f_dialog_m90_didact_ship_exterior_fourth_02);
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00102', FALSE, NONE, 0.0, "", "Cortana : Infinity must have warned them!" );							
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_m90_didact_ship_exterior_fourth_02()
dprint("f_dialog_m90_didact_ship_exterior_fourth_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						sleep_s(2);
            l_dialog_id = dialog_start_background( "DIDACT_SHIP_EXTERIOR_FOURTH_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );                       
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00103', FALSE, NONE, 0.0, "", "Master Chief : Sierra 117 to UNSC Infinity. Captain Del Rio, do you read?" );
							start_radio_transmission( "lasky2_transmission_name" );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00104', FALSE, NONE, 0.0, "", "Lasky : Chief, it's Lasky - is that you?!", TRUE);
							dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00105', FALSE, NONE, 0.0, "", "Master Chief : Affirmative, sir. Where's the Captain?" );
							dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00106', FALSE, NONE, 0.0, "", "Lasky : FleetCom didn't take kindly to his abandoning you on Requiem. I'm afraid I'll have to do.", TRUE);
							dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00107', FALSE, NONE, 0.0, "", "Master Chief : The Didact's got the Composer. We're in a Broadsword carrying a Havok-grade payload, on approach to deliver it." );
							dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00108', FALSE, NONE, 0.0, "", "Lasky : Then let's see if we can grease the wheels for you - all ships, prepare to engage!", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_didact_ship_exterior_sixth()
dprint(" f_dialog_m90_didact_ship_exterior_sixth");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_EXTERIOR_SIXTH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );      
            start_radio_transmission( "lasky2_transmission_name" );                 
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00109', FALSE, NONE, 0.0, "", "Lasky : Chief, the Battle Group's moving to intercept - but at the rate the Didact's ship is advancing, he'll reach the wire [in] T-minus two minutes.", TRUE);
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00110', FALSE, NONE, 0.0, "", "Master Chief : Commander, direct all your ships to the Composer" );
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00111', FALSE, NONE, 0.0, "", "Lasky : Copy that, Chief.", TRUE);
							end_radio_transmission();
							sleep_s(8);							
							start_radio_transmission( "fleetcom_transmission_name" );
							dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00112', FALSE, NONE, 0.0, "", "Fleetcom Watch : Orbital Defense Command, this is FleetCom. Hostile inbound - proceed to Condition Red.", TRUE);
							end_radio_transmission();
							start_radio_transmission( "orbital_transmission_name" );
							dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00114', FALSE, NONE, 0.0, "", "Orbital Defense Command : This is Earth Orbital Defense! MAC defenses ineffective against enemy vessel. It's still approaching.", TRUE);
							end_radio_transmission();
							sleep_s(7);
							start_radio_transmission( "lasky2_transmission_name" );
							dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00116', FALSE, NONE, 0.0, "", "Lasky : Infinity to FleetCom! Battle Group has reached Didact's ship.", TRUE);
							end_radio_transmission();
							start_radio_transmission( "fleetcom_transmission_name" );
							dialog_line_npc( l_dialog_id,6, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00135', FALSE, NONE, 0.0, "", "Fleetcom Watch : All wings, you are cleared to engage.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_didact_ship_exterior_eleventh()
dprint("f_dialog_m90_didact_ship_exterior_eleventh");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_EXTERIOR_ELEVENTH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
            start_radio_transmission( "lasky2_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00117', FALSE, NONE, 0.0, "", "Lasky : Chief, we're tracking you. You're almost on top of it.", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00118', FALSE, NONE, 0.0, "", "Lasky : Cortana, ready the warhead.", TRUE);
							end_radio_transmission();
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00119', FALSE, NONE, 0.0, "", "Cortana : Chief... if we destroy the Composer now, what happens to the crew from Ivanoff?" );
							dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00120', FALSE, NONE, 0.0, "", "Master Chief : They've already been digitized" );
							dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00121', FALSE, NONE, 0.0, "", "Cortana : Exactly. They're not dead. Just... data." );
							//sleep_s(1);
							//dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00122', FALSE, NONE, 0.0, "", "Cortana : It doesn't make us any less real." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_eye_reveal()
dprint("f_dialog_m90_eye_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "EYE_REVEAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00123', FALSE, NONE, 0.0, "", "Cortana : There it is. No- wait…" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


global long l_dialog_eye_closed = DEF_DIALOG_ID_NONE();
script dormant f_dialog_m90_eye_reveal_2()
dprint("f_dialog_m90_eye_reveal_2");
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_eye_closed = dialog_start_foreground( "EYE_REVEAL_2", l_dialog_eye_closed, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_chief( l_dialog_eye_closed, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00125', FALSE, NONE, 0.0, "", "Master Chief : Infinity, the Didact just closed off our entrance to the Composer." );
							start_radio_transmission( "lasky2_transmission_name" );
							dialog_line_npc( l_dialog_eye_closed, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00126', FALSE, NONE, 0.0, "", "Lasky : We could try punching a hole in that hull plating, but Infinity won't be able to get a clear shot with all that flak.", TRUE);
							end_radio_transmission();
							dialog_line_chief( l_dialog_eye_closed, 2, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00127', FALSE, NONE, 0.0, "", "Master Chief : We'll take care of the guns." );
            l_dialog_eye_closed = dialog_end( l_dialog_eye_closed, TRUE, TRUE, "" );
					 
end



script dormant f_dialog_m90_eye_first_gun()
dprint("f_dialog_m90_eye_first_guns");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					sleep_s(2);
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_FIRST_GUNS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    
            start_radio_transmission( "lasky2_transmission_name" );                   
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00128', FALSE, NONE, 0.0, "", "Lasky : Whatever you're doing's working, Chief! Clear up the approach and we can drop close enough to punch a hole in that hull for you.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_eye_second_gun()
dprint("f_dialog_m90_eye_second_gun");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_SECOND_GUN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       							
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00129', FALSE, NONE, 0.0, "", "Cortana : Two cannons neutralized." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00134', FALSE, NONE, 0.0, "", "Cortana : One (two) to go!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end



script dormant f_dialog_m90_eye_third_gun()
dprint("f_dialog_m90_eye_third_gun");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DID_ACT_SHIP_THIRD_GUN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00131', FALSE, NONE, 0.0, "", "Cortana : Only one gun left." );
							start_radio_transmission( "lasky2_transmission_name" );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_flight_section_earth_00130', FALSE, NONE, 0.0, "", "Lasky : Copy, Cortana. Weapons, prepare firing solution! We promised to get the Chief inside that ship and I'm not about to let the man down.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					
	sleep (30 * 2);
	
	b_third_gun_destroyed = TRUE;
					 
end

script static void f_dialog_play_pip_m90_a_subtitles()
	sleep(15);
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_start_00100');
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_start_00101');
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_start_00102');
	sleep(145);
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_start_00103');
	sleep(15);
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_start_00104');
end

script dormant f_dialog_m90_didact_ship_crash_room()
dprint("f_dialog_m90_didact_ship_crash_room");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_CRASH_ROOM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
            hud_play_pip_from_tag( "bink\Campaign\M90_A_60" );       
			thread(f_dialog_play_pip_m90_a_subtitles());
          	
            hud_set_rampancy_intensity(player0, 0.75);
  			hud_set_rampancy_intensity(player1, 0.75);
  			hud_set_rampancy_intensity(player2, 0.75);
  			hud_set_rampancy_intensity(player3, 0.75);
  			
			sleep_s(16);
					//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00100', FALSE, NONE, 0.0, "", "Cortana : I should know what to do now…" );
					//	dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00101', FALSE, NONE, 0.0, "", "Master Chief : We'll have to deploy the warhead manually. How and where?" );
							//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00102', FALSE, NONE, 0.0, "", "Cortana : I always know what to do. I always know what to do!" );
							//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00103', FALSE, NONE, 0.0, "", "Cortana : Chief, just give me/us a second..." );
							//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00104', FALSE, NONE, 0.0, "", "Master Chief : Keep scanning for the Composer. We'll figure it out on the way." );
										// RAMPANCY MOMENT - Cortana throws up a bunch of incorrect waypoints.
							f_blip_flag (flag_wrong_blip_01, "default");
							f_blip_flag (flag_wrong_blip_02, "recon");
							f_blip_flag (flag_wrong_blip_03, "ordinance");
							f_blip_flag (flag_wrong_blip_04, "neutralize");
							f_blip_flag (flag_wrong_blip_05, "recon");
							f_blip_flag (flag_wrong_blip_06, "default");
							f_blip_flag (flag_wrong_blip_07, "ordinance");
							f_blip_flag (flag_wrong_blip_08, "neutralize");
							f_blip_flag (flag_wrong_blip_09, "recon");
							f_blip_flag (flag_wrong_blip_10, "default");
							f_blip_flag (flag_wrong_blip_11, "default");
							f_blip_flag (flag_wrong_blip_12, "neutralize");
							f_blip_flag (flag_wrong_blip_13, "recon");
							f_blip_flag (flag_wrong_blip_14, "ordinance");
							f_blip_flag (flag_wrong_blip_15, "default");
					sleep_s(4);
							f_unblip_flag (flag_wrong_blip_01);
							f_unblip_flag (flag_wrong_blip_02);
							f_unblip_flag (flag_wrong_blip_03);
							f_unblip_flag (flag_wrong_blip_04);
							f_unblip_flag (flag_wrong_blip_05);
							f_unblip_flag (flag_wrong_blip_06);
							f_unblip_flag (flag_wrong_blip_07);
							f_unblip_flag (flag_wrong_blip_08);
							f_unblip_flag (flag_wrong_blip_09);
							f_unblip_flag (flag_wrong_blip_10);
							f_unblip_flag (flag_wrong_blip_11);
							f_unblip_flag (flag_wrong_blip_12);
							f_unblip_flag (flag_wrong_blip_13);
							f_unblip_flag (flag_wrong_blip_14);
							f_unblip_flag (flag_wrong_blip_15);
					hud_set_rampancy_intensity(player0, 0);
  				hud_set_rampancy_intensity(player1, 0);
  				hud_set_rampancy_intensity(player2, 0);
  				hud_set_rampancy_intensity(player3, 0);

            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_m90_didact_ship_scan()
dprint("f_dialog_m90_didact_ship_scan");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_CONSOLE_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							//dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00113', FALSE, NONE, 0.0, "", "Didact : Your ancestors sought to drown the galaxy in their hubris as well, warrior, and look what became of them." );
							dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00114', FALSE, NONE, 0.0, "", "Didact : Where reason does not stop you, perhaps force can at least delay you." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end




script dormant f_dialog_m90_didact_ship_leap_of_faith_1()
dprint("f_dialog_m90_didact_ship_leap_of_faith_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_LEAP_OF_FAITH_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00106', FALSE, NONE, 0.0, "", "Cortana : I recommend entering the doorway to your left." );
							//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00107', FALSE, NONE, 0.0, "", "Master Chief : That doesn't look safe." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_start_00108', FALSE, NONE, 0.0, "", "Cortana : YES" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_m90_didact_ship_leap_of_faith_2()
dprint("f_dialog_m90_didact_ship_leap_of_faith_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_LEAP_OF_FAITH_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       

								 	hud_set_rampancy_intensity(player0, 0.15);
  								hud_set_rampancy_intensity(player1, 0.15);
  								hud_set_rampancy_intensity(player2, 0.15);
  								hud_set_rampancy_intensity(player3, 0.15);
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_leap_down_00105', FALSE, NONE, 0.0, "", "Cortana : The current will slow your descent." );
								hud_set_rampancy_intensity(player0, 0);
				  			hud_set_rampancy_intensity(player1, 0);
				  			hud_set_rampancy_intensity(player2, 0);
				  			hud_set_rampancy_intensity(player3, 0);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_m90_didact_ship_leap_of_faith_3()
dprint("f_dialog_m90_didact_ship_leap_of_faith_3");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_SHIP_LEAP_OF_FAITH_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_leap_down_00101', FALSE, NONE, 0.0, "", "Cortana : Trust me!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_90_dropping_leap_of_faith()
dprint("f_dialog_90_dropping_leap_of_faith");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					wake(f_dialog_90_dropping_leap_of_faith_BACKGROUND);
            l_dialog_id = dialog_start_foreground( "DROPPING_LEAP_OF_FAITH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
            								 	hud_set_rampancy_intensity(player0, 0.15);
  								hud_set_rampancy_intensity(player1, 0.15);
  								hud_set_rampancy_intensity(player2, 0.15);
  								hud_set_rampancy_intensity(player3, 0.15);
            
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_leap_down_00102', FALSE, NONE, 0.0, "", "Cortana : I won't leave you I promise!" );
								hud_set_rampancy_intensity(player0, 0);
				  			hud_set_rampancy_intensity(player1, 0);
				  			hud_set_rampancy_intensity(player2, 0);
				  			hud_set_rampancy_intensity(player3, 0);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script static void f_dialog_play_pip_m90_b_subtitles()
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_portals_00100');
	dialog_play_subtitle('sound\dialog\mission\m90\m90_didactship_portals_00100a');
end

script dormant f_dialog_90_dropping_leap_of_faith_BACKGROUND()
dprint("f_dialog_90_dropping_leap_of_faith");
	sleep_s(.5);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_background( "DROPPING_LEAP_OF_FAITH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00125_WHISPER', FALSE, NONE, 0.0, "", "Cortana : [WHISPER] I'll always take care of you.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 								hud_set_rampancy_intensity(player0, 0);
				  			hud_set_rampancy_intensity(player1, 0);
				  			hud_set_rampancy_intensity(player2, 0);
				  			hud_set_rampancy_intensity(player3, 0);
end

global long l_m90_b_60 = DEF_DIALOG_ID_NONE();

script dormant f_dialog_m90_didact_ship_portals()
	dprint("f_dialog_m90_didact_ship_portals");
	//local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
	hud_play_pip_from_tag( "bink\Campaign\M90_B_60" );     
	thread(f_dialog_play_pip_m90_b_subtitles());
	
          	//l_m90_b_60 = dialog_start_foreground( "DIDACT_SHIP_PORTALS", l_m90_b_60, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
			//dialog_line_cortana( l_m90_b_60, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "Cortana : Still good for something, I guess. I detected an energy signature ahead." );
	sleep_s(13);
							//dialog_line_cortana( l_m90_b_60, 0, TRUE, NONE, FALSE, NONE, 0.0, "", "Cortana : I think it's a transit system like on Requiem. Find a way to access it." );
           // l_m90_b_60 = dialog_end( l_m90_b_60, TRUE, TRUE, "" );
    b_m90_b_60_over = TRUE;				 
end

global long l_teleport_put_in = DEF_DIALOG_ID_NONE();

script dormant f_dialog_m90_didact_portal_console()
dprint("f_dialog_m90_didact_portal_console");
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
					sleep_until (b_m90_b_60_over == TRUE or dialog_id_played_check(l_m90_b_60));
					dprint("portal console line fired");
            l_teleport_put_in = dialog_start_foreground( "DIDACT_PORTAL_CONSOLE", l_teleport_put_in, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       
            hud_set_rampancy_intensity(player0, 0.5);
			  				hud_set_rampancy_intensity(player1, 0.5);
			  				hud_set_rampancy_intensity(player2, 0.5);
			  				hud_set_rampancy_intensity(player3, 0.5);
									dialog_line_cortana( l_teleport_put_in, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00101', FALSE, NONE, 0.0, "", "Cortana : I'll try to route us to the Composer. Put me in the system." );
							 hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
            l_teleport_put_in = dialog_end( l_teleport_put_in, TRUE, TRUE, "" );
					 
end



script dormant f_dialog_m90_didact_portal_console_insertion()
dprint("f_dialog_m90_didact_portal_console_insertion");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					sleep_s(3);
            l_dialog_id = dialog_start_foreground( "DIDACT_PORTAL_CONSOLE_INSERTION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       							
							dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00128', FALSE, NONE, 0.0, "", "Didact : Is this the secret you've kept from me? This... evolved ancilla?" );
							start_radio_transmission( "cortana_transmission_name" );	
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00102', FALSE, cr_tele_plinth, 0.0, "", "Cortana : Didact knows I'm/we're in the system - hurry, go!" );
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end

script dormant f_dialog_m90_didact_portal_console_nudge()
dprint("f_dialog_m90_didact_portal_console_nudge");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "DIDACT_PORTAL_CONSOLE_INSERTION_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
            start_radio_transmission( "cortana_transmission_name" );	                 							
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00103', FALSE, cr_tele_plinth, 0.0, "", "Cortana : I'll find you on the other side. Just go!" );
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end



script dormant f_dialog_m90_wrong_room_1_combat()
dprint("f_dialog_m90_wrong_room_1_combat");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "WRONG_ROOM_1_COMBAT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       							
							//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00105', FALSE, NONE, 0.0, "", "Master Chief : Cortana?" );
							start_radio_transmission( "cortana_transmission_name" );	
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00107', FALSE, NONE, 0.0, "", "Cortana : Portal…" );
							end_radio_transmission();
							dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00104', FALSE, NONE, 0.0, "", "Didact : I sense your malfunctioning companion, human. And yet... she eludes me?" );
							
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_portal_room_2()
dprint("f_dialog_m90_portal_room_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );          
            start_radio_transmission( "cortana_transmission_name" );	             														
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00110', FALSE, NONE, 0.0, "", "Cortana : Can't fight... Didact... and... myself... simultaneously…" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00603', FALSE, NONE, 0.0, "", "Cortana : Opening another portal." );
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					 
end


script dormant f_dialog_m90_portal_room_2_combat()
dprint("f_dialog_m90_portal_room_2_combat");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WRONG_ROOM_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       																	
							dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00113', FALSE, NONE, 0.0, "", "Didact : To deny me, her architecture must be astonishing. Beyond even the Composer's creations…" );
							dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00114', FALSE, NONE, 0.0, "", "Didact : Perhaps you have accomplished more than I assumed." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
					 
end

script dormant f_dialog_m90_wrong_room_2()
dprint("f_dialog_m90_wrong_room_2");

					
					  l_dlg_90_wrong_room_2 = dialog_start_foreground( "WRONG_ROOM_2_COMBAT", l_dlg_90_wrong_room_2, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       																					
					  	wake(f_dialog_m90_wrong_room_2_background);
					  	start_radio_transmission( "cortana_transmission_name" );	
							dialog_line_cortana( l_dlg_90_wrong_room_2, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00115', FALSE, NONE, 0.0, "", "Cortana : I'm sorry, I can't control what they're doing. The stronger threads keep reprioritizing themselves over me." );
							dialog_line_chief( l_dlg_90_wrong_room_2, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00117', FALSE, NONE, 0.0, "", "Master Chief : What about the Didact?" );
							dialog_line_cortana( l_dlg_90_wrong_room_2, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00118', FALSE, NONE, 0.0, "", "Cortana : I can't hide much longer... I'll try to move you to the Composer again." );
							end_radio_transmission();
            l_dlg_90_wrong_room_2 = dialog_end( l_dlg_90_wrong_room_2, TRUE, TRUE, "" );    
					 
end

script dormant f_dialog_m90_wrong_room_2_background()
dprint("f_dialog_m90_wrong_room_2_background");
	
					sleep_s(1);				
					  l_dlg_90_wrong_room_2_background = dialog_start_background( "WRONG_ROOM_2_COMBAT_BACKGROUND", l_dlg_90_wrong_room_2_background, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       																					
					  		hud_set_rampancy_intensity(player0, 0.25);
			  				hud_set_rampancy_intensity(player1, 0.25);
			  				hud_set_rampancy_intensity(player2, 0.25);
			  				hud_set_rampancy_intensity(player3, 0.25);   
					  start_radio_transmission( "halsey_transmission_name" );	
							dialog_line_npc( l_dlg_90_wrong_room_2_background, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00111_WHISPER', FALSE, NONE, 0.0, "", "Cortana : [WHISPER] John, our mother needs us.", TRUE);
							end_radio_transmission();
								hud_set_rampancy_intensity(player0, 0.0);
			  				hud_set_rampancy_intensity(player1, 0.0);
			  				hud_set_rampancy_intensity(player2, 0.0);
			  				hud_set_rampancy_intensity(player3, 0.0);   
			  				start_radio_transmission( "cortana_transmission_name" );	
            l_dlg_90_wrong_room_2_background = dialog_end( l_dlg_90_wrong_room_2_background, TRUE, TRUE, "" );    
					 
end




script dormant f_dialog_m90_portal_room_3()
dprint("f_dialog_m90_portal_room_3");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00120', FALSE, NONE, 0.0, "", "Cortana : Portal open! Far side of the room!" );
						end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_portal_room_3_02()
dprint("f_dialog_m90_portal_room_3_02(");
			sleep_until( volume_test_players(portal_room_3_splinter), 1);
local long l_dialog_id = DEF_DIALOG_ID_NONE();

					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_3_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       																				
					start_radio_transmission( "cortana_transmission_name" );	
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00121', FALSE, NONE, 0.0, "", "Cortana : I have an idea - for both rampancy and the Didact - but if it backfires - I don't-" );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00122', FALSE, NONE, 0.0, "", "Master Chief : It doesn't matter. DO IT." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00123', FALSE, NONE, 0.0, "", "Cortana : Right." );
						dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00124', FALSE, NONE, 0.0, "", "Master Chief : Cortana!?!" );
						dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00125', FALSE, NONE, 0.0, "", "Cortana : It's okay. I'm... I'm okay." );
						end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

global long l_walls_entry = DEF_DIALOG_ID_NONE();
script dormant f_dialog_m90_on_walls_entry()
dprint("f_dialog_m90_on_walls_entry");
			
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_walls_entry = dialog_start_foreground( "ON_WALLS_ENTRY", l_walls_entry, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
						dialog_line_chief( l_walls_entry, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00101', FALSE, NONE, 0.0, "", "Master Chief : Where are you?" );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_00106', FALSE, NONE, 0.0, "", "Cortana : Wait..." );
						start_radio_transmission( "cortana_transmission_name" );	
						dialog_line_cortana( l_walls_entry, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00102', FALSE, NONE, 0.0, "", "Cortana : The Didact's cloaking the Composer from me!" );
						end_radio_transmission();
          l_walls_entry = dialog_end( l_walls_entry, TRUE, TRUE, "" );
					sleep_s(1);
           wake(f_dialog_m90_on_walls_entry_reinforcements);
end

global long l_walls_hold_off = DEF_DIALOG_ID_NONE();

script dormant f_dialog_m90_on_walls_entry_reinforcements()
dprint("f_dialog_m90_on_walls_entry_reinforcements");
			//sleep_until( volume_test_players(walls_entry_reinforcements), 1);
			//wait till the platform is clear
			sleep_until( b_walls_plinth_ready, 1 );
//local long l_walls_hold_off = DEF_DIALOG_ID_NONE();
					l_walls_hold_off = dialog_start_foreground( "ON_WALLS_ENTRY_REINFORCEMENTS", l_walls_hold_off, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
						dialog_line_cortana( l_walls_hold_off, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00105', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Reinforcements!" );
						dialog_line_cortana( l_walls_hold_off, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00106', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Hold them off while I locate the Composer." );
						end_radio_transmission();
          l_walls_hold_off = dialog_end( l_walls_hold_off, TRUE, TRUE, "" );
           
end


script dormant f_dialog_m90_need_time()
dprint("f_dialog_m90_need_time");
			

end

script dormant f_dialog_m90_final_portal_turrets()
dprint("f_dialog_m90_portal_room_3_turrets");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_3_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					  dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_turrets_00102', FALSE, cr_walls_plinth, 0.0, "", "Cortana : I've taken control of the local defense turrets." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\global_chatter_00154', FALSE, NONE, 0.0, "", "Cortana : Chief!" );
					  //dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00116', FALSE, NONE, 0.0, "", "Cortana : The way you came in!" );
					  end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end



script dormant f_dialog_m90_final_portal_wave2()
dprint("f_dialog_m90_final_portal_wave2");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_3_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 //dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00117', FALSE, NONE, 0.0, "", "Cortana : They're flanking us!" );
					 dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00109', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Far end of the catwalk!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_final_portal_wave3()
dprint("f_dialog_m90_final_portal_wave3");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_3_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
						//dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\didact_taunts_00112', FALSE, NONE, 0.0, "", "Didact: If only your kind knew balance, human, instead of this constant desperation and greed." );
						start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0 , TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00120', FALSE, cr_walls_plinth, 0.0, "", "Cortana : SURRENDER THE COMPOSER, DAMN YOU!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_final_portal_wave4()
dprint("f_dialog_m90_final_portal_wave4");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PORTAL_ROOM_4_TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00118', FALSE, cr_walls_plinth, 0.0, "", "Cortana : I can feel him clawing at me in the system. Attempting to separate me (beat) from what is mine..." );
					 dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00120', FALSE, cr_walls_plinth, 0.0, "", "Cortana : SURRENDER THE COMPOSER, DAMN YOU!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_behind_you()
dprint("f_dialog_m90_behind_you");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BEHIND_YOU", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00111', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Chief, behind you!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_on_the_walls()
dprint("f_dialog_m90_on_the_walls");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ON_THE_WALLS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00110', FALSE, cr_walls_plinth, 0.0, "", "Cortana : On the walls!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_from_above()
dprint("f_dialog_m90_from_above");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ON_THE_WALLS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00114', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Coming from above!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_turn_around()
dprint("f_dialog_m90_turn_around");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TURN_AROUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00115', FALSE, cr_walls_plinth, 0.0, "", "Cortana : Turn around!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_came_in()
dprint("f_dialog_m90_turn_around");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TURN_AROUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00116', FALSE, cr_walls_plinth, 0.0, "", "Cortana : The way you came in." );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

/*script dormant f_dialog_m90_leave_without_cortana_1()
dprint("f_dialog_m90_leave_without_cortana_1");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FLANKING_US", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_nudge_00100', FALSE, biped_walls_cortana, 0.0, "", "Cortana : Wait. Chief. I need you to get me. I can't go on my own." );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_leave_without_cortana_2()
dprint("f_dialog_m90_leave_without_cortana_2");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FLANKING_US", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_nudge_00105', FALSE, biped_walls_cortana, 0.0, "", "Cortana : Come back." );
					 dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_nudge_00101', FALSE, biped_walls_cortana, 0.0, "", "Cortana : Please don't leave me!" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_leave_without_cortana_3()
dprint("f_dialog_m90_leave_without_cortana_3");
			
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FLANKING_US", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );     
					start_radio_transmission( "cortana_transmission_name" );	
					 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_nudge_00104', FALSE, biped_walls_cortana, 0.0, "", "Cortana : You think I'll just let you go off all by yourself?" );
					 end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end*/

script dormant f_dialog_m90_final_room_portal()
dprint("f_dialog_m90_final_room_portal");
		sleep_s(2);

					start_radio_transmission( "cortana_transmission_name" );	
						sound_impulse_start_marker('sound\dialog\mission\m90\m90_didactship_portals_defend_00122', biped_walls_cortana, fx_head, 1);
						sleep (sound_impulse_time('sound\dialog\mission\m90\m90_didactship_portals_defend_00122'));
						sound_impulse_start_marker('sound\dialog\mission\m90\m90_didactship_portals_defend_00123', biped_walls_cortana, fx_head, 1);
						sleep (sound_impulse_time('sound\dialog\mission\m90\m90_didactship_portals_defend_00122'));
						end_radio_transmission();
		//				dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00126', FALSE, NONE, 0.0, "", "Cortana : The Composer's on the other side of this portal." );
          
          wake(f_dialog_m90_final_room_portal_rampancy);
          //thread(m90_leave_without_cortana()); 
end
script dormant f_dialog_m90_final_room_portal_rampancy()
		
		 sleep_until (device_get_position(dc_walls_turret_activator) != 0);
//		       kill_script(m90_leave_without_cortana);
  //        sleep_forever(m90_leave_without_cortana);		
		 b_cortana_retrieved = TRUE;
		 sleep_until( volume_test_players(leave_without_cortana), 1);
   			 dprint("f_dialog_m90_final_room_portal_rampancy");
					local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FINAL_ROOM_PORTAL_RAMPANCY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    
			    		  hud_set_rampancy_intensity(player0, 0.25);
			  				hud_set_rampancy_intensity(player1, 0.25);
			  				hud_set_rampancy_intensity(player2, 0.25);
			  				hud_set_rampancy_intensity(player3, 0.25);                   																	
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didactship_portals_defend_00126', FALSE, NONE, 0.0, "", "Cortana : The Composer's on the other side of this portal." );												
							 hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );		
            
end

			  				
			  				
script dormant f_dialog_m90_pre_jump()
dprint("f_dialog_m90_pre_jump");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PRE_JUMP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_jump_00100', FALSE, NONE, 0.0, "", "Master Chief : How do we get over there?" );
								hud_set_rampancy_intensity(player0, 0.25);
			  				hud_set_rampancy_intensity(player1, 0.25);
			  				hud_set_rampancy_intensity(player2, 0.25);
			  				hud_set_rampancy_intensity(player3, 0.25);
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_jump_00101', FALSE, NONE, 0.0, "", "Cortana : There's a conveyor lift, end of the ramp. If we time it right, our momentum should carry us through the low gravity." );
								hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_jump_pip()
dprint("f_dialog_m90_jump_pip");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "JUMP_PIP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       																				
								hud_set_rampancy_intensity(player0, 0.4);
			  				hud_set_rampancy_intensity(player1, 0.4);
			  				hud_set_rampancy_intensity(player2, 0.4);
			  				hud_set_rampancy_intensity(player3, 0.4);
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_jump_00102', FALSE, NONE, 0.0, "", "Cortana : Chief... once that warhead is primed, the window for getting out of here is going to be... pretty slim." );
									  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_jump_00103', FALSE, NONE, 0.0, "", "Master Chief : I know." );
						sleep_s(1);
									hud_set_rampancy_intensity(player0, 0.35);
			  				hud_set_rampancy_intensity(player1, 0.35);
			  				hud_set_rampancy_intensity(player2, 0.35);
			  				hud_set_rampancy_intensity(player3, 0.35);					
			  		sleep_s(1);
			  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
			  		sleep_s(1);
			  			hud_set_rampancy_intensity(player0, 0.75);
			  				hud_set_rampancy_intensity(player1, 0.75);
			  				hud_set_rampancy_intensity(player2, 0.75);
			  				hud_set_rampancy_intensity(player3, 0.75);					
			  		sleep_s(1);
			  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
			  		sleep_s(1);
					//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_jump_00104', FALSE, NONE, 0.0, "", "Cortana : I suppose Dr. Halsey and I should make some improvements to my matrix when we address my rampancy." );
					//	dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_jump_00105', FALSE, NONE, 0.0, "", "Master Chief : Let me know if you need any ideas." );
					//	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_jump_00106', FALSE, NONE, 0.0, "", "Cortana : I'll be sure to do that. Thanks." );
						dialog_line_didact( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_jump_00110', FALSE, NONE, 0.0, "", "Didact : And so... you come at last." );
														hud_set_rampancy_intensity(player0, 0.25);
			  				hud_set_rampancy_intensity(player1, 0.5);
			  				hud_set_rampancy_intensity(player2, 0.5);
			  				hud_set_rampancy_intensity(player3, 0.5);
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_jump_00107', FALSE, NONE, 0.0, "", "Cortana : Activity! Significant slipspace event building under the Composer!" );
									  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
						dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_jump_00108', FALSE, NONE, 0.0, "", "Master Chief : He's powering it up." );
												sleep_s(2);
									hud_set_rampancy_intensity(player0, 0.35);
			  				hud_set_rampancy_intensity(player1, 0.35);
			  				hud_set_rampancy_intensity(player2, 0.35);
			  				hud_set_rampancy_intensity(player3, 0.35);					
			  		sleep_s(1.5);
			  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
			  		sleep_s(2);
			  			hud_set_rampancy_intensity(player0, 0.75);
			  				hud_set_rampancy_intensity(player1, 0.75);
			  				hud_set_rampancy_intensity(player2, 0.75);
			  				hud_set_rampancy_intensity(player3, 0.75);					
			  		sleep_s(2);
			  				hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
			  		
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end

script dormant f_dialog_m90_didact_eye()
dprint("f_dialog_m90_didact_eye");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PRE_JUMP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_jump_00111', FALSE, NONE, 0.0, "", "Master Chief : Why hasn't he fired it yet?" );
						//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_jump_00109', FALSE, NONE, 0.0, "", "Cortana : It must not be ready." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end


script dormant f_dialog_m90_didact_eye_02()
dprint("f_dialog_m90_didact_eye");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PRE_JUMP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );            
								hud_set_rampancy_intensity(player0, 0.5);
			  				hud_set_rampancy_intensity(player1, 0.5);
			  				hud_set_rampancy_intensity(player2, 0.5);
			  				hud_set_rampancy_intensity(player3, 0.5);           														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00100', FALSE, NONE, 0.0, "", "Cortana : The Didact's [cheating!] shielded himself inside the Composer." );
								hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end



script dormant f_dialog_m90_splintering_ics()
dprint("f_dialog_m90_splintering_ics");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "SPLINTERING_ICS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
							//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00101', FALSE, NONE, 0.0, "", "Master Chief : How do we get the warhead in there?" );
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00102', FALSE, NONE, 0.0, "", "Cortana : I've got to do something you're not going to like." );
							//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_eye_00103', FALSE, NONE, 0.0, "", "Master Chief : What?" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_eye_00104', FALSE, NONE, 0.0, "", "Cortana : AAARHRHH!" );
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_eye_00105', FALSE, NONE, 0.0, "", "Cortana : DOOOONNN'TTT…" );
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_eye_00106', FALSE, NONE, 0.0, "", "Cortana : I've been holding on to these pieces of myself so tightly-" );
							
							thread(f_music_m90_v05_rampancy_solution());
							dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m90\m90_eye_00108', FALSE, NONE, 0.0, "", "Cortana : unaware that rampancy was never our problem, but our solution" );
							dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m90\m90_eye_00133', FALSE, NONE, 0.0, "", "Cortana : I don't know about you, but I'm ready for this to be over." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
          
end

script dormant f_dialog_m90_plinth_to_beam()
dprint("f_dialog_m90_plinth_to_beam");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PLINTH_TO_BEAM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00109', FALSE, NONE, 0.0, "", "Master Chief : What did you just do?" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_eye_00110', FALSE, NONE, 0.0, "", "Cortana : I ejected my rampant personality spikes into the ship's systems. If we do that at each conduit, the instability in those copies can overwhelm the Composer's shielding." );
							//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_eye_00111', FALSE, NONE, 0.0, "", "Master Chief : How do we get those pieces of you back?" );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
          
           
end

script dormant f_dialog_m90_plinth_to_beam_02()
dprint("f_dialog_m90_plinth_to_beam_02");
sleep_until( volume_test_players(f_dialog_m90_plinth_to_beam_02) or volume_test_players(f_dialog_m90_plinth_to_beam_01), 1);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "PLINTH_TO_BEAM_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
									
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00189', FALSE, NONE, 0.0, "", "Cortana : Get ready! " );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end



script dormant f_dialog_m90_eye_insertion()
dprint("f_dialog_m90_eye_insertion");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "EYE_INSERTION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );             
													hud_set_rampancy_intensity(player0, 0.5);
			  				hud_set_rampancy_intensity(player1, 0.5);
			  				hud_set_rampancy_intensity(player2, 0.5);
			  				hud_set_rampancy_intensity(player3, 0.5);                  														
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00113', FALSE, NONE, 0.0, "", "Cortana : Now! Before the Didact sends reinforcements." );
								hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);        
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end


script dormant f_dialog_m90_eye_insertion_2()
dprint("f_dialog_m90_eye_insertion_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "EYE_INSERTION_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00114', FALSE, NONE, 0.0, "", "Cortana : Chief, he could fire the Composer at any moment! Plug me in!" );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end


script dormant f_dialog_m90_eye_insertion_3()
dprint("f_dialog_m90_eye_insertion_3");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "EYE_INSERTION_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );            
								hud_set_rampancy_intensity(player0, 0.9);
			  				hud_set_rampancy_intensity(player1, 0.9);
			  				hud_set_rampancy_intensity(player2, 0.9);
			  				hud_set_rampancy_intensity(player3, 0.9);           														
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00115', FALSE, NONE, 0.0, "", "Cortana : YOUR KIND WILL BE COMPOSED UNLESS YOU ACT!" );
								hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           
end



script dormant f_dialog_m90_beam_vignette_1()
dprint("f_dialog_m90_beam_vignette_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				/*	l_dialog_id = dialog_start_foreground( "BEAM_VIGNETTE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00116', FALSE, NONE, 0.0, "", "Cortana : Alright, hold on." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           */
end


script dormant f_dialog_m90_beam_vignette_2()
dprint("f_dialog_m90_beam_vignette_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BEAM_VIGNETTE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00201', FALSE, NONE, 0.0, "", "Cortana : That's it." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
          wake(f_dialog_m90_beam_vignette_3);
           
end

script dormant f_dialog_m90_beam_vignette_3()
dprint("f_dialog_m90_beam_vignette_3");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BEAM_VIGNETTE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00231', FALSE, NONE, 0.0, "", "Cortana : It’s working!" );
					//	dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_eye_00119', FALSE, NONE, 0.0, "", "Didact : So, the ancilla steps into the sun. A remarkable device, yet so tragically misused." );
						//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_eye_00120', FALSE, NONE, 0.0, "", "Cortana : WE ARE NOT A DEVICE!" );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end


script dormant f_dialog_m90_transition_platform()
dprint("f_dialog_m90_transition_platform");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TRANSITION_PLATFORM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						//dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00121', FALSE, NONE, 0.0, "", "Didact : What could have been a noble end instead becomes a pathetic, desperate exercise in futility." );
						dialog_line_didact( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_didact_taunts_00104', FALSE, NONE, 0.0, "", "Didact : You humans sought the Didact; you will have him" );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_eye_00123', FALSE, NONE, 0.0, "", "Cortana : Chief, his ship's in range! Once the barrier's down, you need to get the nuke in there fast!" );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end


script dormant f_dialog_m90_beam_2_02()
dprint("f_dialog_m90_beam_2_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BEAM_2_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );         
								hud_set_rampancy_intensity(player0, 0.5);
			  				hud_set_rampancy_intensity(player1, 0.5);
			  				hud_set_rampancy_intensity(player2, 0.5);
			  				hud_set_rampancy_intensity(player3, 0.5);              														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00124', FALSE, NONE, 0.0, "", "Cortana : Hurry/run/go! Merge me into the vessel!" );
														hud_set_rampancy_intensity(player0, 0);
			  				hud_set_rampancy_intensity(player1, 0);
			  				hud_set_rampancy_intensity(player2, 0);
			  				hud_set_rampancy_intensity(player3, 0);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end


script dormant f_dialog_m90_maelstrom_vignette()
dprint("f_dialog_m90_maelstrom_vignette");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MAELSTROM_VIGNETTE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00125', FALSE, NONE, 0.0, "", "Cortana : One second." );
						dialog_line_didact( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_eye_00128', FALSE, NONE, 0.0, "", "Didact : And yet, still you fail.");
						dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m90\m90_eye_00131', FALSE, NONE, 0.0, "", "Master Chief : Cortana?!?" );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m90\m90_eye_00132', FALSE, NONE, 0.0, "", "Cortana : You've got to destroy it!" );

          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_maelstrom_vignette_over()
dprint("f_dialog_m90_maelstrom_vignette_over");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "MAELSTROM_VIGNETTE_OVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
				//		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_eye_00131', FALSE, NONE, 0.0, "", "Master Chief : Cortana?!?" );
						wake(f_dialog_m90_maelstrom_vignette_background_01);
						sleep_s(1);
						wake(f_dialog_m90_maelstrom_vignette_background_02);
						dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00120_WHISPER', FALSE, NONE, 0.0, "", "Cortana : Save them! Destroy the Composer!", TRUE);
						wake(f_dialog_m90_maelstrom_vignette_background_03);
						wake(nar_grav_lift);
						wake(nar_light_shield_barricadest);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_maelstrom_vignette_background_01()
dprint("f_dialog_m90_maelstrom_vignette_background_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "MAELSTROM_VIGNETTE_BACKGROUND_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00130_WHISPER', FALSE, NONE, 0.0, "", "Cortana:	We're here.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_maelstrom_vignette_background_02()
dprint("f_dialog_m90_maelstrom_vignette_background_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "MAELSTROM_VIGNETTE_BACKGROUND_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00100_WHISPER', FALSE, NONE, 0.0, "", "Cortana:	Get to the Core.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end


script dormant f_dialog_m90_maelstrom_vignette_background_03()
dprint("f_dialog_m90_maelstrom_vignette_background_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "MAELSTROM_VIGNETTE_BACKGROUND_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00102_WHISPER', FALSE, NONE, 0.0, "", "Cortana:	Destroy it.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_light_shield_barricades()
dprint("f_dialog_m90_light_shield_barricades");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LIGHT_SHIELD_BARRICADES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00134_WHISPER', FALSE, NONE, 0.0, "", "Cortana : We will light your way." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00125_WHISPER', FALSE, NONE, 0.0, "", "Cortana : I’ll always take care of you." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_grav_lift()
dprint("f_dialog_m90_grav_lift");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GRAV_LIFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00100', FALSE, NONE, 0.0, "", "Cortana : Prime the nuke." );			
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_grav_lift_background_01()
dprint("f_dialog_m90_grav_lift_background_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "GRAV_LIFT_BACKGROUND_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
					sleep_s(.1);
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00100', FALSE, NONE, 0.0, "", "Cortana:	You can stop him.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_grav_lift_background_02()
dprint("f_dialog_m90_grav_lift_background_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "GRAV_LIFT_BACKGROUND_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00119_WHISPER', FALSE, NONE, 0.0, "", "Cortana:	Place the bomb in the core.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_a_few_more()
dprint("f_dialog_m90_a_few_more");
	wake(f_dialog_m90_rampancy_background_01);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "A-FEW_MORE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00255', FALSE, NONE, 0.0, "", "Cortana: A few more Prometheans." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end


script dormant f_dialog_m90_more_targets()
dprint("f_dialog_m90_more_targets");
	wake(f_dialog_m90_rampancy_background_02);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_TARGETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       														
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00244', FALSE, NONE, 0.0, "", "Cortana: We've still got targets." );
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_rampancy_background_01()
dprint("f_dialog_m90_rampancy_background_01");
	sleep_s(.5);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "RAMPANCY_BACKGROUND_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00113_NORMAL', FALSE, NONE, 0.0, "", "Cortana: Save them. Destroy the Composer.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end

script dormant f_dialog_m90_rampancy_background_02()
dprint("f_dialog_m90_rampancy_background_02");
sleep_s(.5);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "RAMPANCY_BACKGROUND_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );                       														
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m90\m90_rampancy_00170_WHISPER', FALSE, NONE, 0.0, "", "Cortana: We don't want to leave you.", TRUE);
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" )	;
           
end