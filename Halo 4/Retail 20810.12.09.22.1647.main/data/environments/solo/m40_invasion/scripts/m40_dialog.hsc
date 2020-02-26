//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m40_dialog
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// DIALOG
// -------------------------------------------------------------------------------------------------
// DEFINES


// VARIABLES


// dialog ID variables






// --- END
/*

script static void  f_dialog_m40_landing_marine_chatter()
dprint("f_dialog_m40_landing_marine_chatter");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "LANDING_MARINE_CHATTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
																			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_arrival_00103', FALSE, marines_misc_sq.bill, 0.0, "", "Marine 1 : Welcome back to the fight, Chief.", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end

end*/



script dormant f_dialog_m40_lasky_radio_contact()
dprint("f_dialog_m40_lasky_radio_contact");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
            l_dialog_id = dialog_start_foreground( "LASKY_RADIO_CONTACT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
							//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_arrival_00100', FALSE, NONE, 0.0, "", "Lasky : Chief, Lasky. We've had a bit of a complication.", TRUE);
							//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_arrival_00101a', FALSE, NONE, 0.0, "", "Lasky : Link up with Cmdr. Palmer and I in the Mammoth, A-SAP.", TRUE);
								
							start_radio_transmission( "palmer_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00100', FALSE, NONE, 0.0, "", "Palmer : Chief. Spartan Sarah Palmer in Infinity CIC. Commander Lasky's waiting for you on the Mammoth.", TRUE);
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_arrival_00102', FALSE, NONE, 0.0, "", "Master Chief : On our way." );
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					

end

script dormant f_dialog_m40_cortana_hall()
dprint("f_dialog_m40_cortana_hall");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_HALL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.25 );              					
							//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_arrival_00104', FALSE, NONE, 0.0, "", "Cortana : You realize they don't see you as any more real than those Prometheans.");
						//	dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_arrival_00105', FALSE, NONE, 0.0, "", "Master Chief : What do you mean?");
							//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_arrival_00106', FALSE, NONE, 0.0, "", "Cortana : We're artificial to them. Assets.");
							//dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_arrival_00108', FALSE, NONE, 0.0, "", "Master Chief : I don't follow." );
							//dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_arrival_00109', FALSE, NONE, 0.0, "", "Cortana : Never mind. Let's just finish this and get out of here.");
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m40_cortana_mammoth()
dprint("f_dialog_m40_cortana_mammoth");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_MAMMOTH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_rollout_00100', FALSE, NONE, 0.0, "", "Cortana : Well. SOMEONE's overcompensating." );	
						
							start_radio_transmission( "gypsyone_transmission_name" );
							//sound_impulse_start( 'sound\storm\vo\play_1_99_01_in_squelch', NONE, 1 );
								
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_intheair_00100a', FALSE, NONE, 0.0, "", "Pilot 1 : Papa Foxtrot Seven Six Six to Spartan Palmer, we’re finally in the air.", TRUE);
							end_radio_transmission();
							//sound_impulse_start( 'sound\storm\vo\play_1_99_02_out_squelch', NONE, 1 );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

//script dormant f_dialog_m40_marine_nudge_inner()
//	dprint("f_dialog_m40_marine_nudge_inner");
/*local long L_dlg_marine_nudge_inner_01 = DEF_DIALOG_ID_NONE();

            L_dlg_marine_nudge_inner_01 = dialog_start_background("MARINE_NUDGE_INNER", L_dlg_marine_nudge_inner_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc( L_dlg_marine_nudge_inner_01, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00100', FALSE, tort_marines.scott, 0.0, "", "Marine 2 : Master Chief, sir! The XO is looking for you up on the action deck.", TRUE);
            L_dlg_marine_nudge_inner_01 = dialog_end( L_dlg_marine_nudge_inner_01, TRUE, TRUE, "" );*/
				
		
		
//end


script dormant f_dialog_m40_marine_nudge_outer()
dprint("f_dialog_m40_marine_nudge_outer");
local long L_dlg_m40_marine_nudge_outer = DEF_DIALOG_ID_NONE();

            L_dlg_m40_marine_nudge_outer = dialog_start_background("MARINE_NUDGE_OUTER", L_dlg_m40_marine_nudge_outer, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		dialog_line_npc( L_dlg_m40_marine_nudge_outer, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00100', FALSE, marines_main_hog_01b_sq.hog_01_gunner, 0.0, "", "Stacker: Chief! Commander Lasky's looking for you up in the Mammoth.", TRUE);
            L_dlg_m40_marine_nudge_outer = dialog_end( L_dlg_m40_marine_nudge_outer, TRUE, TRUE, "" );


end

script static void f_dialog_m40_gun_in_mammoth( short s_index )


	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	if ( s_index == 1 ) then
		 l_dialog_id = dialog_start_background("GUN_IN_MAMMOTH_a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00200', FALSE, tort_marines.aaron, 0.0, "", "Mammoth Marine 1 : Hey Chief - 'no fighting in the war room' or however that goes.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	if ( s_index == 2 ) then
		 l_dialog_id = dialog_start_background("GUN_IN_MAMMOTH_b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00201', FALSE, tort_marines.randall, 0.0, "", "Mammoth Marine 2 : Check your fire!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	if ( s_index == 3 ) then
		 l_dialog_id = dialog_start_background("GUN_IN_MAMMOTH_c", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00202', FALSE, tort_marines.brandon, 0.0, "", "Mammoth Marine 3 : Hey! They call it a safety for a reason!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	if ( s_index == 4 ) then
		 l_dialog_id = dialog_start_background("GUN_IN_MAMMOTH_d", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00203', FALSE,tort_marines.whitman, 0.0, "", "Mammoth Marine 1 : Not everyone's got armor, man!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
		
		static short gun_in_mammoth_state = 0;
	end


end


script static void f_dialog_m40_mammoth_button_1()
dprint( "f_dialog_m40_mammoth_button_1" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();



	if m40_map_area_01 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_1_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_one_00100', FALSE, tort_button_01_attachment, 0.0, "", "Mammoth System Voice : TACREP, six-digit grid November Uniform Seven Four Two, Four Five Four. Gypsy Company, Forward Operation Base. Enclosed rocky valley, bounded on four sides. Visibilty, poor. Encampment suitablity, good.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_02 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_1_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_one_00101', FALSE, tort_button_01_attachment, 0.0, "", "Mammoth System Voice : TACREP, six-digit grid November Uniform Seven Two Two, Four Nine Seven. Battle Position Alpha, cliffside Area of Operations with line of sight to Enemy Artillary. Enemy encampments on site. Visability, good. Mobility potential, fair - terrain bisected by chemical river, impassible by smaller vehicles.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_03 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_1_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_one_00102', FALSE, tort_button_01_attachment, 0.0, "", "Mammoth System Voice : TACREP, six-digit grid November Uniform Seven Two Two, Three Zero Five. Canyon pass en route to Battle Position Baker. Limited avenues of approach. High ground prevalent. Visibility, fair. Defensibility, poor.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif m40_map_area_04 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_1_D", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_one_00103', FALSE, tort_button_01_attachment, 0.0, "", "Mammoth System Voice : TACREP, six-digit grid November Uniform Seven One Two, Three Two Nine. Battle Position Baker, northwest of central Mesa with line of sight to Enemy Artillary. Heavy enemy resistance. Mobility potential, high. Defensibility, fair.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );

	elseif m40_map_area_05 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_1_E", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );         
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_one_00104', FALSE, tort_button_01_attachment, 0.0, "", "Mammoth System Voice : TACREP, six-digit grid November Uniform Seven Zero Two, Four Eight Six. Multiple tributary waterfalls en route to Battle Position Corona. Mobility, poor. Area impassible for all ground forces save Mammoth. Visibilty, high.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	object_create (tortoise_device_button_01);
		objects_attach (main_mammoth,  "device_button_03", tortoise_device_button_01, "");
	thread(tort_button_01());

	
end


script static void f_dialog_m40_mammoth_button_2()
dprint( "f_dialog_m40_mammoth_button_2" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();



	if m40_map_area_01 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_2_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_two_00100', FALSE, tort_button_02_attachment, 0.0, "", "Mammoth System Voice : Intel assessment - Mammoth F.O.B. Nearest location to particle cannon network accessible by air. Numerous rock slides have created a natural defensive position.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_02 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_2_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_two_00101', FALSE, tort_button_02_attachment, 0.0, "", "Mammoth System Voice : Intel assessment - Battle Position Alpha. Mammoth has encountered an artificial river of unknown origin. Preliminary analysis reveals toxic levels of Glutaraldehyde and Strontium 90. Industrial application likely. All personnel are advised to avoid contact with the substance until further notice.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_03 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_2_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_two_00102', FALSE, tort_button_02_attachment, 0.0, "", "Mammoth System Voice : Intel assessment - Observation Grid 6. Gypsy Company has encountered Covenant shield blockade along the Mammoth’s avenue of approach. The blockade’s design contains previously unseen properties consistent with recently discovered Forerunner technologies.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	
	elseif m40_map_area_04 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_2_D", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_two_00103', FALSE, tort_button_02_attachment, 0.0, "", "Mammoth System Voice : Intel assessment - Battle Position Baker. Mammoth has encountered new Covenant CTV, provisionally referred to as a Lich. The ship appears to be a heavily-armed mobile deployment platform - Mammoth sensor data has been cataloged and transmitted to Infinity for further analysis.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_05 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_2_E", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_two_00104', FALSE, tort_button_02_attachment, 0.0, "", "Mammoth System Voice : Intel assessment - Observation Grid 8. Forward sensors have detected enemy command post responsible for the particle cannon network. High neutrino concentration suggests the installation is utilizing a form of slipspace communication to coordinate the weapons.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
		object_create (tortoise_device_button_02);
			objects_attach (main_mammoth,  "device_button_04", tortoise_device_button_02, "");
					thread(tort_button_02());
		
end


script static void f_dialog_m40_mammoth_button_3()
dprint( "f_dialog_m40_mammoth_button_3" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();


	if m40_map_area_01 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_3_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_three_00100', FALSE, tort_button_03_attachment, 0.0, "", "Mammoth System Voice : Mammoth Forward Operating Base. In order to neutralize the Forerunner Gravity Well, Gypsy Company will disable the weapon’s defense network; a system of anti-air particle cannnons controlled from a central command post.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_02 == TRUE  then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_3_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_three_00101', FALSE, tort_button_03_attachment, 0.0, "", "Mammoth System Voice : Objective Alpha. Forerunner Mobile Particle Cannon. Positioned roughly 150 meters off the deck, enemy artillary emits a phased charge capable of sustained force of undetermined strength.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_03 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_3_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_three_00102', FALSE, tort_button_03_attachment, 0.0, "", "Mammoth System Voice : Mammoth Mission Status Report. Neutralizing the first particle cannon has yielded additional intel on other nodes in the defense system. Cannon network extends wider than previously thought, and data implies that its orientation may be configurable, capable of deploying resources across great distances.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_04 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_3_D", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_three_00103', FALSE, tort_button_03_attachment, 0.0, "", "Mammoth System Voice : Objective Bravo. Increased proximity to gravity well has yielded new data around its operation. The gravimetric effects of the main generator are seemingly being multiplied by particles within the planet’s atmosphere. This would seem to reinforce Infinity’s observations as to the Gravity Well’s range of operations extending far beyond line of sight.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif m40_map_area_05 == TRUE then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_3_E", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_three_00104', FALSE, tort_button_03_attachment, 0.0, "", "Mammoth System Voice : Mammoth Mission Status Report. With air access greatly expanded, Shadow and Castle Companies have been deployed to broaden the battlespace, drawing attention away from Gypsy Company. Both Shadow and Castle have been augmented with Spartan IV fireteams, increasing their overall strength by 30%.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
		object_create (tortoise_device_button_03);
		objects_attach (main_mammoth,  "device_button_05", tortoise_device_button_03, "");
		thread(tort_button_03());
end

script static void f_dialog_m40_mammoth_button_4( short s_index )
dprint( "f_dialog_m40_mammoth_button_4" );

	local long l_dialog_id = DEF_DIALOG_ID_NONE();



		if ( s_index == 1 ) then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_4_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_four_00100', FALSE, tort_button_04_attachment, 0.0, "", "Mammoth System Voice : Lasky, Thomas J. Commander, UNSC Infinity. Service Number 77698-41073-TL. Acting Ground Commander, Gypsy Company, Requiem.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
			
	object_create (tortoise_device_button_04);
	objects_attach (main_mammoth,  "device_button_06", tortoise_device_button_04, "");
	thread(tort_button_04());
		elseif ( s_index == 2 ) then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_4_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_four_00101', FALSE, tort_button_04_attachment, 0.0, "", "Mammoth System Voice : Palmer, Sarah E. Spartan Commander, deployment, UNSC Infinity. Service Number Redacted, Grade 2 or above. Acting Tactical Lead, Gypsy Company, Requiem.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
		elseif ( s_index == 3 ) then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_4_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_four_00102', FALSE, tort_button_04_attachment, 0.0, "", "Mammoth System Voice : Stacker, Marcus P. Master Sergeant, UNSC Marine Corp, deployment - UNSC Infinity. Service Number 41009-31545-MS. Mammoth Infantry Lead, Gypsy Company, Requiem.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif ( s_index == 4 ) then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_4_D", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_four_00103', FALSE, tort_button_04_attachment, 0.0, "", "Mammoth System Voice : Bobrov, Elena K. Staff Sergeant, UNSC Marine Corp, deployment - UNSC Infinity. Service number 91532-11116-EB. Mammoth Driver, Gypsy Company, Requiem.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif ( s_index == 5 ) then
		l_dialog_id = dialog_start_background("MAMMOTH_BUTTON_4_E", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );   
			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_button_four_00104', FALSE, tort_button_04_attachment, 0.0, "", "Mammoth System Voice : Scudieri, Carlo M. Sergeant, UNSC Marine Corp, deployment - UNSC Infinity. Service number 93071-28339-CS. Mammoth Navigator, Gypsy Company, Requiem.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
		mammoth_button_4_short = 0;
		
	end
	
	object_create (tortoise_device_button_04);
	objects_attach (main_mammoth,  "device_button_06", tortoise_device_button_04, "");
	thread(tort_button_04());
end

script dormant f_dialog_m40_marine_warthog()
dprint("f_dialog_m40_marine_warthog");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MARINE_WARTHOG", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00101', FALSE, tort_marines.whitman, 0.0, "", "Marine 4 : Sorry, sir. Vehicles are to remain on the Mammoth until further notice. [We've got] Orders.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script static void f_dialog_m40_marine_warthog_gun( short s_index )
		dprint("WARTHOG GUN IN MAMMOTH 2");
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 4);
	;
	if ( s_index == 1 ) then
			dprint("WARTHOG GUN IN MAMMOTH 3");
		l_dialog_id = dialog_start_background( "WARTHOG_GUN_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00207', FALSE, tort_marines.whitman, 0.0, "", "Marine 4 : Somebody get him off of there!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	if ( s_index == 2 ) then
		l_dialog_id = dialog_start_background( "WARTHOG_GUN_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00205', FALSE, tort_marines.randall, 0.0, "", "Mammoth Marine 2 : I get it! You never met a trigger you didn't like! Point taken!", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end
	if ( s_index == 3 ) then
		l_dialog_id = dialog_start_background( "WARTHOG_GUN_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00206', FALSE, tort_marines.randall, 0.0, "", "Mammoth Marine 2 : How long were you in cryo sleep again!??", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
		static short marine_warthog_gun_state = 0;
	end


end




/*script dormant f_dialog_m40_lasky_vignette()
dprint("f_dialog_m40_lasky_vignette");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LASKY_VIGNETTE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00102', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Chief.  Unfortunately for us, we've got to bring down a couple of the particle cannons manually before we can get to the command post.", TRUE);
								//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00103', FALSE, NONE, 0.0, "", "Lasky : Grab one of the target designators from below.", TRUE);
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00104', FALSE, NONE, 0.0, "", "Lasky : Once we're in range, we'll deploy Gypsy Company to provide cover while you ID firing solutions for the MiniMAC.", TRUE);
								//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00105', FALSE, NONE, 0.0, "", "Palmer : And Chief? I'd pick up a jet pack if I were you.", TRUE);
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00106', FALSE, NONE, 0.0, "", "Palmer : Having seen the terrain, you're gonna need it.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end*/

script dormant f_dialog_m40_jetpack_callout()
dprint("f_dialog_m40_jetpack_callout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						sleep_s(10);
            l_dialog_id = dialog_start_foreground( "JETPACK_CALLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );         
            start_radio_transmission( "palmer_transmission_name" );      
            
            
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00102', FALSE, NONE, 0.0, "", "Palmer : Chief, Palmer again. The Mammoth’s got jetpacks onboard. If I were down there, I’d want one.", TRUE);
								end_radio_transmission();
							//								sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_02_out_squelch', NONE, 1 );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						

end



script dormant f_dialog_m40_del_rio_radio()
dprint("f_dialog_m40_del_rio_radio");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
  		
            l_dialog_id = dialog_start_foreground( "DEL_RIO_RADIO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
            		//sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
								start_radio_transmission( "delrio_transmission_name" );
								hud_play_pip_from_tag( bink\Campaign\M40_A_60 );
								thread(f_dialog_play_pip_m40_a_subtitles());
								
								sleep_s(15);
				//				dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00109', FALSE, NONE, 0.0, "", "Del Rio : Gypsy Company, this is Captain Del Rio.", TRUE);
								end_radio_transmission();
								//sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_02_out_squelch', NONE, 1 );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
  			wake(f_dialog_m40_lasky_initiate);
end

script static void f_dialog_play_pip_m40_a_subtitles()
	sleep_s(0.02);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_mammoth_int_00109');
	sleep_s(0.04);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_mammoth_int_00110');
	sleep_s(2.21);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_mammoth_int_00111');
end

script dormant f_dialog_m40_lasky_initiate()
dprint("f_dialog_m40_lasky_initiate");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LASKY_INITIATE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
            					start_radio_transmission( "lasky_transmission_name" );
            				//	hud_rampancy_players_set( 0.15 );
            					dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00112', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : OK, Gypsy - time to work for it.  Let's shake some dirt.", TRUE);
            				//	sleep_s(2);
									//		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00210', FALSE, NONE, 0.0, "", "Lasky : Chief, that's our cue. We could use you on one of the deck guns - who knows what we're going into.", TRUE);
											end_radio_transmission();
										//	hud_rampancy_players_set( 0.0 );
											b_mammoth_going = TRUE;
																		//sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_02_out_squelch', NONE, 1 );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dialog_m40_cannon_reveal()
dprint("f_dialog_m40_cannon_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CANNON_REVEAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
              start_radio_transmission( "lasky_transmission_name" );                    												
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_gun_vista_00100', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Lasky to Infinity.", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_gun_vista_00101', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : We have visual on the first target.", TRUE);
							end_radio_transmission();
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_gun_vista_00102', FALSE, NONE, 0.0, "", "Cortana : The Forerunners certainly don't do things halfway, do they?" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m40_pelican_vignette()
dprint("f_dialog_m40_pelican_vignette");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
//			sleep_until(b_mammoth_going == TRUE);
            l_dialog_id = dialog_start_foreground( "PELICAN_VIGNETTE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_pelican_00100', FALSE, NONE, 0.0, "", "Pelican Pilot : This is Papa Foxtrot Seven Six Six on low approach.", TRUE);
								//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_pelican_00101', FALSE, NONE, 0.0, "", "Pelican Pilot : Target in sight.", TRUE);
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_pelican_00102', FALSE, NONE, 0.0, "", "Lasky : Pelican, clear out!", TRUE);
								//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_pelican_00103', FALSE, NONE, 0.0, "", "Lasky : First cannon is still hot! REPEAT - FIRST CANNON--", TRUE);								
								//sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
								start_radio_transmission( "palmer_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00103', FALSE, NONE, 0.0, "", "Palmer : Captain Del Rio, targeting Pelicans are in position near the particle cannons, waiting for the Mammoth’s mini-MAC to take them out.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00105', FALSE, NONE, 0.0, "", "Palmer : Seven Six Six, lose some altitude. You’re inside the kill box!", TRUE);
								end_radio_transmission();
								start_radio_transmission( "gypsyone_transmission_name" );
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_intheair_00101', FALSE, NONE, 0.0, "", "Pilot 1 : Almost got target lock. Just a little more…", TRUE);
								end_radio_transmission();
								start_radio_transmission( "palmer_transmission_name" );
								dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00107', FALSE, NONE, 0.0, "", "Palmer : Pelican! Fall back!", TRUE);
								end_radio_transmission();
								start_radio_transmission( "gypsyone_transmission_name" );
								print ("PELICAN DEATH SCREAM 1");
								dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_intheair_00102', FALSE, NONE, 0.0, "", "Pilot 1 : [scream]", TRUE);
								print ("PELICAN DEATH SCREAM 2");
								dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_pelicandrama_00104', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky: Infinty! Pelicans down!", TRUE);
								dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m40\m40_pelicandrama_00105', FALSE, NONE, 0.0, "", "Del Rio: Get to the crash site and retrieve that target designator, Gypsy. You've got no chance of clearing those guns without it.", TRUE);
								//dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00108', FALSE, NONE, 0.0, "", "Palmer : Gypsy-Seven’s crew IFF tags all still read green. Hopefully the target designator’s still in one piece too.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
            sleep_s(2);
            wake(m40_cannon_fodder);
		

end




								


script dormant f_dialog_M40_cannon_fodder()
dprint("f_dialog_M40_cannon_fodder");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CANNON_FODDER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
            		start_radio_transmission( "lasky_transmission_name" );                  											
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00100', FALSE, NONE, 0.0, "", "Palmer : All teams - we've got Covenant squads, digging in on the ridgeline.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00101', FALSE, NONE, 0.0, "", "Palmer : Weapons free, people!", TRUE);
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00103', FALSE, NONE, 0.0, "", "Lasky : I think your Forerunner friend knows we're gunning for his gravity well.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_M40_mammoth_in_range()
dprint("f_dialog_M40_mammoth_in_range");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "MAMMOTH_IN_RANGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );              
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								         																		
            start_radio_transmission( "lasky_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00211', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Alright, Chief, Mammoth's just about in range.", TRUE);
							//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_mammoth_int_00212', FALSE, NONE, 0.0, "", "Lasky : Once we're in position, it's up to you to site the gun up with the target designator.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						sleep_s(3);
						wake(f_dialog_m40_pelican_contact);
end


script static void f_dialog_M40_mammoth_in_range_02()
		wake(f_dialog_m40_mammoth_in_range_marine_04);
		

end


script dormant f_dialog_m40_mammoth_in_range_marine_01()
dprint("f_dialog_m40_mammoth_in_range_marine_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MAMMOTH_IN_RANGE_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00213', FALSE, tort_marines.brandon, 0.0, "", "Mammoth Marine 3 : Bailey's open!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_mammoth_in_range_marine_02()
dprint("f_dialog_m40_mammoth_in_range_marine_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MAMMOTH_IN_RANGE_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00214', FALSE, tort_marines.whitman, 0.0, "", "Mammoth Marine 4 : Bailey's open!", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_mammoth_in_range_marine_03()
dprint("f_dialog_m40_mammoth_in_range_marine_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MAMMOTH_IN_RANGE_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00215', FALSE, tortoise_jetpacker_01.billy, 0.0, "", "Mammoth Spartan IV-A : Bailey's open.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_mammoth_in_range_marine_04()
dprint("f_dialog_m40_mammoth_in_range_marine_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MAMMOTH_IN_RANGE_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		if lakeside_warthog_deploy == true then
															dialog_line_npc( l_dialog_id, 3, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00216', FALSE, tortoise_jetpacker_01.billy, 0.0, "", "Mammoth Spartan IV-A : Warthogs free!", TRUE);
								end
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_mammoth_in_range_marine_05()
dprint("f_dialog_m40_mammoth_in_range_marine_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_background("MAMMOTH_IN_RANGE_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
            		if lakeside_warthog_deploy == true then
															dialog_line_npc( l_dialog_id, 4, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_mammoth_int_00217', FALSE, tortoise_jetpacker_02.cliff, 0.0, "", "Mammoth Spartan IV-B : Mongooses free!", TRUE);
								end
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_pelican_contact()
dprint("f_dialog_m40_pelican_contact");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

l_dialog_id = dialog_start_foreground( "PELICAN_CONTACT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 ); 
//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00104', FALSE, NONE, 0.0, "", "Pelican Pilot : This is... Papa Foxtrot Seven Six... Six.", TRUE);
//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00105', FALSE, NONE, 0.0, "", "Pelican Pilot : Does... anyone... read?", TRUE);
//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00106', FALSE, NONE, 0.0, "", "Cortana : It's the Pelican team!" );
//	dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00200', FALSE, NONE, 0.0, "", "Lasky : Gypsy Company - we’ve got wounded out there. Chief, give me a perimeter around that crash site.", TRUE);
//sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );

start_radio_transmission( "palmer_transmission_name" );
dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00110', FALSE, NONE, 0.0, "", "Palmer : There's Gypsy-Seven's Pelican, out in the muck. Anyone still alive?", TRUE);
end_radio_transmission();
start_radio_transmission( "gypsyone_transmission_name" );
dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_pilot2_ver_00101', FALSE, NONE, 0.0, "", "Pilot #2: We're here! We're alive! We've got the target designator.", TRUE);
end_radio_transmission();
dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_ver_mc_00101', FALSE, NONE, 0.0, "", "Master Chief : I'll get to them and retrieve the designator." );
l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

//blipping the target designator for jacob
f_blip_object (m40_lakeside_target_laser, "recon");
wake (lakeside_objective_prompt);

end




								

script dormant f_dialog_m40_warthog_forget()
dprint("f_dialog_m40_warthog_forget");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "WARTHOG_FORGET", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_cannon_fodder_00107', FALSE, NONE, 0.0, "", "Cortana : With that many fast movers out there, you’re probably going to want to grab something with wheels." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m40_lakeside_end_nudge()
dprint("f_dialog_m40_lakeside_end_nudge");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LAKESIDE_END_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_objective_nudge_lakeside_00111', FALSE, NONE, 0.0, "", "Cortana : All teams are moving back to the Mammoth. Let's go." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m40_del_rio_ping()
dprint("f_dialog_m40_del_rio_ping");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "DEL_RIO_PING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
					//		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00119', FALSE, NONE, 0.0, "", "Del Rio : Lasky, this is Del Rio. What's the hold up?", TRUE);
					//		dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00120', FALSE, NONE, 0.0, "", "Lasky : Infinity, we’ve located Pelican Seven Six Six’s crash site. Sending in ground forces to secure survivors.", TRUE);
					//		dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00121', FALSE, NONE, 0.0, "", "Del Rio : We don’t have time for this, Commander. Wrap it up. Del Rio out.", TRUE);
					//		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00102', FALSE, NONE, 0.0, "", "Cortana : Somebody want to tell that guy he's not the only one who wants to get home?!?");
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

					
/*script dormant f_dialog_M40_lake_reaction()
dprint("f_dialog_M40_lake_reaction");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LAKE_REACTION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       											
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00202', FALSE, NONE, 0.0, "", "Cortana : Chief, stop! That liquid's corrosive!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end*/

script dormant f_dialog_m40_marine_rescue()
dprint("f_dialog_m40_marine_rescue");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "MARINE_RESCUE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       																		
            	start_radio_transmission( "gypsyone_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00103', FALSE, pelican_marines.guy1, 0.0, "", "Pelican Pilot : I didn't think anyone would hear me.", TRUE);
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00104', FALSE, NONE, 0.0, "", "Master Chief : Sit tight, marine. We'll get you out of here." );
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00203', FALSE, pelican_marines.guy1, 0.0, "", "Pelican Pilot : Thanks, Master Chief. We owe you one.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						

end

script dormant f_dialog_m40_fodder_dropship_appear()
dprint("f_dialog_m40_fodder_dropship_appear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "DROPSHIP_APPEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								         
            			start_radio_transmission( "lasky_transmission_name" );  
									dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00105', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Eyes up, Gypsy! Dropships, on approach.", TRUE);
									end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end
						

						
script dormant f_dialog_M40_lakeside_all_clear()
dprint("f_dialog_M40_lakeside_all_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LAKESIDE_ALL_CLEAR_DIALOGUE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
            		start_radio_transmission( "lasky_transmission_name" );                     
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00200', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Alright, Master Chief. We're clear. Mini-MAC's at your disposal - take out that particle cannon.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end						



script dormant f_dialog_m40_tutorial_1()
dprint("f_dialog_m40_tutorial_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TUTORIAL_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								
            	start_radio_transmission( "lasky_transmission_name" );                    
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00109', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Chief, you've got the designator - we're on your clock here.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_tutorial_miss()
dprint("f_dialog_m40_tutorial_miss");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TUTORIAL_MISS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );       
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								    
            	start_radio_transmission( "palmer_transmission_name" );            
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00110', FALSE, NONE, 0.0, "", "Palmer : Shot wide. Correct and fire for effect.", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end



script dormant f_dialog_m40_tutorial_2()
dprint("f_dialog_m40_tutorial_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TUTORIAL_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );        
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								       
            start_radio_transmission( "lasky_transmission_name" );        													
									dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00111', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Target intact! Reloading - give it another round, Chief.", TRUE);
						end_radio_transmission();			
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m40_tutorial_3()
dprint("f_dialog_m40_tutorial_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TUTORIAL_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );        
            //sound_impulse_start( 'sound\dialog\mission\m10\play_1_99_01_in_squelch', NONE, 1 );
								               													
            start_radio_transmission( "lasky_transmission_name" );        		
									dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00112', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Target suppressed. Nicely done, Chief.", TRUE);
						end_radio_transmission();			
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_rollout()
dprint("f_dialog_m40_rollout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "ROLLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       													
            
								
            start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00114', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Gypsy Company. This stream ahead'll be toxic for anything other than the Mammoth.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00113', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Suggest you roll up behind us and use the Bailey to pass through.", TRUE);
								end_radio_transmission();			
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_post_stream()
dprint("f_dialog_m40_tutorial_post_stream");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "POST_STREAM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
            		start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00115', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Lasky to Infinity, first contact cleared but no joy on additional targets.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00116', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Gypsy moving on to secondary battle position but requesting evac for casualties.", TRUE);
								end_radio_transmission();
								start_radio_transmission( "palmer_transmission_name" );
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_palmer_ver_00112', FALSE, NONE, 0.0, "", "Palmer : I’m on it, Commander. Palmer out.", TRUE);
								end_radio_transmission();
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00117', FALSE, NONE, 0.0, "", "Del Rio : Affirmative, Mr. Lasky.", TRUE);
								//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_lakeside_00118', FALSE, NONE, 0.0, "", "Del Rio : We'll get an extract down there pronto. Infinity out.", TRUE);
								//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lakeside_pelican_00100', FALSE, NONE, 0.0, "", "Pelican Pilot 2 : Papa Foxtrot Seven Six Six, this is Papa Foxtrot One Three Five. Inbound on your position for immediate evac.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						

end



script dormant f_dialog_M40_lakeside_tort_assault_dialogue()
dprint("f_dialog_M40_lakeside_tort_assault_dialogue");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LAKESIDE_TORT_ASSAULT_DIALOGUE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );       			
							start_radio_transmission( "lasky_transmission_name" );                
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_cliffside_00100', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Covenant boarding party inbound!", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_cliffside_00101', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Fireteams, all boots on deck!", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_cliffside_00102', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Do not let them into the Mammoth!", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end			


script dormant f_dialog_m40_boarding_party()
dprint("f_dialog_m40_boarding_party");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "BOARDING_PARTY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            
								                       
            		start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_cliffside_00103', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Gypsy company! We’ve got incoming, trying to block the Mammoth!", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_pre_chopper_01()
dprint("f_dialog_m40_pre_chopper_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRE_CHOPPER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00100', FALSE, NONE, 0.0, "", "Cortana : Force field!  Barricading the far side of this canyon.");
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00103', FALSE, NONE, 0.0, "", "Cortana : I'm seeing three power sources. Shut them down so the Mammoth can move through.");
						
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
		
end

script dormant f_dialog_m40_pre_chopper_one_down()
dprint("f_dialog_m40_pre_chopper_one_down");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRE_CHOPPER_ONE_DOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00104', FALSE, NONE, 0.0, "", "Cortana : Good. Two more.");
						
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
		
end

script dormant f_dialog_m40_pre_chopper_two_down()
dprint("f_dialog_m40_pre_chopper_one_down");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRE_CHOPPER_ONE_DOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00106', FALSE, NONE, 0.0, "", "Cortana : Two for two. Finish 'em off.");
						
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
		
end

script dormant f_dialog_m40_pre_chopper_all_down()
dprint("f_dialog_m40_pre_chopper_one_down");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRE_CHOPPER_ONE_DOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00108', FALSE, NONE, 0.0, "", "Cortana : Shield disabled. Mammoth, the path is clear.");
						
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
		
end

script dormant f_dialog_m40_prechopper_waiting()
dprint("f_dialog_m40_prechopper_waiting");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRECHOPPER_WAITING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
            
								
            		start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_pre_chopper_00105', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Mammoth holding position.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_pre_chopper_00106', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Whenever you're ready to proceed, Chief.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_prechopper_done()
dprint("f_dialog_m40_prechopper_done");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PRECHOPPER_DONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );           
            start_radio_transmission( "lasky_transmission_name" );            
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_pre_chopper_00108', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Gypsy Company, moving out.", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end



script dormant f_dialog_m40_second_cannon_approach()
dprint("f_dialog_m40_second_cannon_approach");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SECOND_CANNON_APPROACH", l_dialog_id, (chopper_cannon_alive == TRUE ), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00100', FALSE, NONE, 0.0, "", "Cortana : Lasky, Cortana. " );
							//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00101', FALSE, NONE, 0.0, "", "Cortana : There's a lot of buzz on the battlenet." );
							//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00102', FALSE, NONE, 0.0, "", "Cortana : Apparently the Covenant weren't expecting us to get this close to the gravity well." );
							
								
								start_radio_transmission( "lasky_transmission_name" );
							//	dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00103', FALSE, NONE, 0.0, "", "Lasky : Let's not look a gift horse in the mouth.", TRUE);
							
								dialog_line_npc( l_dialog_id, 0, (chopper_cannon_alive == TRUE ), 'sound\dialog\mission\m40\m40_chopper_bowl_00104', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Chief, get us a firing solution on that particle cannon before the Covenant get their act together.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_second_cannon_fire_one()
dprint("f_dialog_m40_second_cannon_fire_one");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CANNON_FIRE_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       	
            
								
            start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00105', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Solid hit. Finish her off.", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_second_cannon_fire_two()
dprint("f_dialog_m40_second_cannon_fire_two");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SECOND_CANNON_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
            
								
            start_radio_transmission( "lasky_transmission_name" );                     
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00106', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Shot's good.", TRUE);
							sleep_s(3);
							//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00107', FALSE, NONE, 0.0, "", "Lasky : Target is down.", TRUE);
							//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00108', FALSE, NONE, 0.0, "", "Lasky : Infinity, second cannon has been-", TRUE);
							//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00109', FALSE, NONE, 0.0, "", "Lasky : (-)what??", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00110', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : All units! Unidentified Covenant vehicle incoming!", TRUE);
							//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00111', FALSE, NONE, 0.0, "", "Lasky : Keep a hard posture, people - this sucker casts a hell of a shadow!", TRUE);
							//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00112', FALSE, NONE, 0.0, "", "Cortana : Commander, what is it?");
							//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00113', FALSE, NONE, 0.0, "", "Lasky : Unknown! Craft is some new type of CTV we haven't seen before!", TRUE);
							sleep_s(8);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00114', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Mammoth's hit! Forward traction offline! Primary power controls offline!", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_lich_plan()
dprint("f_dialog_m40_lich_plan");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_PLAN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       								
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00115', FALSE, NONE, 0.0, "", "Cortana : The Mammoth won't last long out in the open like that." );
							//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00117', FALSE, NONE, 0.0, "", "Master Chief : The designator?" );
							//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00118', FALSE, NONE, 0.0, "", "Cortana : I doubt it. The MiniMAC took the brunt of the attack." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_broken_gun()
dprint("f_dialog_m40_broken_gun");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "BROKEN_GUN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       								
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00119', FALSE, NONE, 0.0, "", "Cortana : Negative response." );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00120', FALSE, NONE, 0.0, "", "Cortana : The barrage must have damaged the MAC controls." );
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00121', FALSE, NONE, 0.0, "", "Cortana : Without that gun, the only way to bring the ship down will be from the inside." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_hold_the_hill()
dprint("f_dialog_m40_hold_the_hill");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "HOLD_THE_HILL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       								
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00149', FALSE, NONE, 0.0, "", "Cortana : Reinforcements! " );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\global_chatter_00147', FALSE, NONE, 0.0, "", "Cortana : Hold them off!" );

            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m40_lich_pass()
dprint("f_dialog_m40_lich_pass");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_PASS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );        
            
								
            start_radio_transmission( "lasky_transmission_name" );               	
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00122', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Chief, watch your six - you've got aggressor vehicles heading your way.", TRUE);
						end_radio_transmission();
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00123', FALSE, NONE, 0.0, "", "Cortana : She's coming around for another pass! Watch it!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_lich_stops()
dprint("f_dialog_m40_lich_stops");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_STOPS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       	
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00124', FALSE, NONE, 0.0, "", "Cortana : The ship's settling in over the mesa." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00125', FALSE, NONE, 0.0, "", "Cortana : There's a grav lift into the belly of that ship. Time it right, and we should be able to ride it inside." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00126', FALSE, NONE, 0.0, "", "Cortana : Time it right, and we should be able to ride it inside." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
					thread(f_dialog_m40_lich_stops_jetpack());
end





script static void f_dialog_m40_lich_stops_jetpack()
dprint("f_dialog_m40_lich_stops_jetpack");
                                sleep_until (volume_test_players (tv_chopper_hilltop), 1);                        
                sleep_s(30);
											 if ((player_in_lich == false) and (lich_alive_state == true)) then
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_STOPS_JETPACK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                               
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_chopper_bowl_00200', FALSE, NONE, 0.0, "", "Cortana : This is taking too long. Maybe try using the jetpack to get up there." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
           	f_blip_flag (jetpack_help_flag, "recon");
						sleep_until (volume_test_players (tv_jetpack_help)
						or
						volume_test_players (tv_lich_bottom)						
						or
						volume_test_players (tv_lich_middle_01)
						or
						volume_test_players (tv_lich_middle_01)
						, 1);  
						f_unblip_flag (jetpack_help_flag);
						f_blip_flag (jetpack_help_flag_lich, "recon");
						sleep_until (volume_test_players (tv_lich_bottom)
						or
						volume_test_players (tv_lich_middle_01)
						or
						volume_test_players (tv_lich_middle_01)
						, 1);  						
						f_unblip_flag (jetpack_help_flag_lich);
						f_unblip_flag (jetpack_help_flag);
                                                else
                                                                print ("player in lich, dialogue not playing");
                                                end

end


script dormant f_dialog_m40_lich_boarding()
dprint("f_dialog_m40_lich_boarding");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						kill_script(f_dialog_m40_lich_stops_jetpack);
            l_dialog_id = dialog_start_foreground( "LICH_BOARDING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       	
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lich_boarding_00100', FALSE, NONE, 0.0, "", "Cortana : Alright, now let's bring her down." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_lich_boarding_00101', FALSE, NONE, 0.0, "", "Cortana : There's bound to be a weak point around here somewhere. Have a look." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_lich_head_out()
dprint("f_dialog_m40_lich_head_out");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_HEAD_OUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       	
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lich_boarding_00102', FALSE, NONE, 0.0, "", "Cortana : That did it! Time to make an exit!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_lich_going_to_blow()
dprint("f_dialog_m40_lich_going_to_blow");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LICH_GOING_TO_BLOW", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       	
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_lich_boarding_00103', FALSE, NONE, 0.0, "", "Cortana : Abandon ship, Chief! It's going to blow!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_descent_on_mesa()
dprint("f_dialog_m40_descent_on_mesa");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "DESCENT_ON_MESA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
            
								
                start_radio_transmission( "lasky_transmission_name" );               
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00100', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Thanks, Chief. It was getting a bit dicey there for a minute.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00101', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : All hands, form up on us.", TRUE);
								end_radio_transmission();
								start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00102', FALSE, NONE, 0.0, "", "Del Rio : Lasky, this is Infinity. Status.", TRUE);
								end_radio_transmission();
								start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00103', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Mammoth's in pretty bad shape.", TRUE);
								dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00104', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : She'll make it to the objective as long as nobody starts throwing rocks at us.", TRUE);
								end_radio_transmission();
								start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00105', FALSE, NONE, 0.0, "", "Del Rio : Not a chance we can take.", TRUE);
								dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00106', FALSE, NONE, 0.0, "", "Del Rio : I'm sending teams out pull some of their fire off you so you can make it to the gravity well.", TRUE);
								end_radio_transmission();
								start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00107', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Roger that, sir. Gypsy, let's move.", TRUE);
								end_radio_transmission();
		            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						sleep_s(1);
						wake(f_dialog_m40_chopper_cleared_background);

end						


script dormant f_dialog_m40_chopper_cleared_background()
dprint("f_dialog_m40_chopper_cleared_background");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
								
					l_dialog_id = dialog_start_background( "DESCENT_ON_MESA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00108', FALSE, NONE, 0.0, "", "Del Rio : Shadow Company, Castle Company.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00109', FALSE, NONE, 0.0, "", "Del Rio : Put some pressure on those other particle cannons.", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_post_chopper_00111_soundstory', FALSE, NONE, 0.0, "", "Shadow Leader : Lima Charlie, Captain. Approaching primary objective.", TRUE);
	
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_stream_crossing()
dprint("f_dialog_m40_stream_crossing");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STREAM_CROSSING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
            
								
            		start_radio_transmission( "lasky_transmission_name" );                    
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00100', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : OK, folks. Terrain's too rough around these tributaries", TRUE);
								//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00101', FALSE, NONE, 0.0, "", "Lasky : Terrain's too rough around these tributaries.", TRUE);
								//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00102', FALSE, NONE, 0.0, "", "Lasky : Assault force, return to the Mammoth. ", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00103', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Anyone not aboard is getting left.", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_stream_crossing_2()
dprint("f_dialog_m40_stream_crossing_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STREAM_CROSSING_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
            
								
            start_radio_transmission( "lasky_transmission_name" );                     
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00104', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : OK, sealing her up.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00105', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Mammoth is mobile.", TRUE);								
								//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00105a', FALSE, NONE, 0.0, "", "Lasky : Master Chief, is everything alright?", TRUE);
								//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00105b', FALSE, NONE, 0.0, "", "Lasky : You go flying off when you’ve got a nice, cushy ride, people’ll start to take it personally.", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						
end



script dormant f_dialog_m40_canyon_rampancy()
dprint("f_dialog_m40_canyon_rampancy");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						
            l_dialog_id = dialog_start_foreground( "STREAM_CROSSING_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       

								hud_rampancy_players_set(0.75);
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m90_rampancy_00180_ANGRY', FALSE, NONE, 0.0, "", "Cortana : They don't care about you - they replaced you!" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00112', FALSE, NONE, 0.0, "", "Cortana : Blast it!" );
								hud_rampancy_players_set(0.0);
								dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_waterfall_00113', FALSE, NONE, 0.0, "", "Master Chief : It's OK." );

								hud_play_pip_from_tag( bink\Campaign\M40_B_60 );
								thread(f_dialog_play_pip_m40_b_subtitles());

            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	    rampancy_pip_over = TRUE;
end
						

script static void f_dialog_play_pip_m40_b_subtitles()
	sleep_s(0.5);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00114');
	sleep_s(2.30);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00116');
	sleep_s(0.30);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00117');
	sleep_s(1.30);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00118');
	sleep_s(1.20);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00119');
	sleep_s(1.35);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00120');
	sleep_s(1.45);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_waterfall_00121');
end

script dormant f_dialog_m40_citadel_investigate()
dprint("f_dialog_m40_citadel_investigate");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CITADEL_INVESTIGATE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
            
								                    
            start_radio_transmission( "lasky_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_pre_citadel_00100', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : One One Seven, Lasky.", TRUE);
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_pre_citadel_00101', FALSE, NONE, 0.0, "", "Master Chief : Go, Commander." );
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00200', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Chief. We've got significant blockage up ahead. Think this is about it for the Mammoth.", TRUE);
/*							wake(f_dialog_m40_marine_sniper_line_01);
							
						//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00201a', FALSE, NONE, 0.0, "", "Cortana : More snipers." );
							wake(f_dialog_m40_marine_sniper_line_02);
							wake(f_dialog_m40_marine_sniper_line_03);*/
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00204', FALSE, NONE, 0.0, "", "Cortana : The command post for the particle cannons is through that trench." );
							dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00205', FALSE, NONE, 0.0, "", "Master Chief : Sir, I can move faster alone." );
							dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00207', FALSE, NONE, 0.0, "", "Cortana : We'll see you back on Infinity, Commander." );
							dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m40\m40_lasky_new_targetdesignator_00109', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Lasky out.", TRUE);
						end_radio_transmission();	
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
						

end

script dormant f_dialog_m40_marine_sniper_line_01()
	//dprint("f_dialog_m40_marine_sniper_line_01");
					
            L_dlg_marine_sniper_line_01 = dialog_start_background("MARINE_SNIPER_01", L_dlg_marine_sniper_line_01, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc( L_dlg_marine_sniper_line_01, 0, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00201', FALSE, NONE, 0.0, "", "Mammoth Marine 1 : Snipers!", TRUE);
            L_dlg_marine_sniper_line_01 = dialog_end( L_dlg_marine_sniper_line_01, TRUE, TRUE, "" );

			
end

script dormant f_dialog_m40_marine_sniper_line_02()
	//dprint("f_dialog_m40_marine_sniper_line_02");
					
            L_dlg_marine_sniper_line_02 = dialog_start_background("MARINE_SNIPER_02", L_dlg_marine_sniper_line_02, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc( L_dlg_marine_sniper_line_02, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_sniper_alley_00202', FALSE, NONE, 0.0, "", "Mammoth Marine 2 : In the rocks.", TRUE);
            L_dlg_marine_sniper_line_02 = dialog_end( L_dlg_marine_sniper_line_02, TRUE, TRUE, "" );
				
		
		
end

script dormant f_dialog_m40_marine_sniper_line_03()
	//dprint("f_dialog_m40_marine_sniper_line_03");
					
            L_dlg_marine_sniper_line_03 = dialog_start_background("MARINE_SNIPER_03", L_dlg_marine_sniper_line_03, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );         
								dialog_line_npc( L_dlg_marine_sniper_line_03, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m40\m40_sniper_alley_00203', FALSE, NONE, 0.0, "", "Mammoth Marine 3 : We're boxed in!", TRUE);
            L_dlg_marine_sniper_line_03 = dialog_end( L_dlg_marine_sniper_line_03, TRUE, TRUE, "" );
				
		
		
end


script dormant f_dialog_m40_sniper_shot()
dprint("f_dialog_m40_get_sniper_shot");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SNIPER_SHOT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00209', FALSE, NONE, 0.0, "", "Cortana : Nice. You bought the Mammoth some time. Let's get to that command post before reinforcements show." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00209a', FALSE, NONE, 0.0, "", "Cortana : Careful. There may be more in here." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m40_get_sniper_rifle()
dprint("f_dialog_m40_get_sniper_rifle");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SNIPER_RIFLE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_pre_citadel_00106', FALSE, NONE, 0.0, "", "Cortana : Who knows what's hiding up in those rocks." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_pre_citadel_00107', FALSE, NONE, 0.0, "", "Cortana : You might want to grab a sniper rifle before we go in there." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end




/*script dormant f_dialog_m40_sniper_in_the_rocks()
dprint("f_dialog_m40_stream_crossing");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SNIPER_CROSSING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
												dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00100', FALSE, NONE, 0.0, "", "Cortana : Snipers, in the rocks." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end



script dormant f_dialog_m40_sniper_in_the_rocks_alt()
dprint("f_dialog_m40_sniper_in_the_rocks_alt");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SNIPER_CROSSING_ALT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00101', FALSE, NONE, 0.0, "", "Cortana : Shooters, in the rocks." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

*/
//end


script dormant f_dialog_m40_covenant_and_promethean()
dprint("f_dialog_m40_covenant_and_promethean");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

// NOTE: You can use f_valley_ai_orders_player_saw() [boolean] to check if the player actually saw the event, if not the dialog should probably change - TWF
//				In the script this function will get triggered as soon as the player starts seeing it or after the event is over


            l_dialog_id = dialog_start_foreground( "COVENANT_PROMETHEAN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00115', FALSE, NONE, 0.0, "", "Cortana : Heads up!" );
			
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m40_a_team()
dprint("f_dialog_m40_a_team");
local long l_dialog_id = DEF_DIALOG_ID_NONE();


            l_dialog_id = dialog_start_foreground( "A_TEAM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.25 );                       
								//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sniper_alley_00103', FALSE, NONE, 0.0, "", "Cortana : Didact must really not want us to leave if he's sending in his A-Team to stop us." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_cit_door_airlock()
dprint("m40_dialog_cit_door_airlock");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CIT_DOOR_AIRLOCK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_lobby_00100', FALSE, NONE, 0.0, "", "Cortana : Cortana to Infinity. We're entering the Forerunner structure." );
								
								
								start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_lobby_00101', FALSE, NONE, 0.0, "", "Del Rio : ... Del Rio... --ansmitting coordinates for...defense grid's power source... --opy?", TRUE);
								end_radio_transmission();
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_citadel_lobby_00102', FALSE, NONE, 0.0, "", "Cortana : Breaking up but coordinates received, Infinity." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m40_confusion_citadel()
dprint("m40_dialog_confusion_citadel");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

//            l_dialog_id = dialog_start_foreground( "CONFUSION_CITADEL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
//								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00100', FALSE, NONE, 0.0, "", "Cortana : These passages seem to run all through the structure." );
//								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00101', FALSE, NONE, 0.0, "", "Cortana : Well that was rude." );
//								sleep_s(5);
//								//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00102', FALSE, NONE, 0.0, "", "Cortana : I don't suppose they offer turndown service as well." );
///*								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00103', FALSE, NONE, 0.0, "", "Master Chief : This could be a trap." );
//								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00104', FALSE, NONE, 0.0, "", "Cortana : You say that like there's a second possibility." );*/
//            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

/*script dormant f_dialog_m40_sentinel_color()
dprint("f_dialog_m40_sentinel_color");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SENTINEL_COLOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00106', FALSE, NONE, 0.0, "", "Cortana : Chief, hold up." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00107', FALSE, NONE, 0.0, "", "Cortana : Those sentinels are still the same blue color as the ones we saw earlier, before the Didact took control of the Prometheans." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m40_sentinel_color_2()
dprint("f_dialog_m40_sentinel_color_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "SENTINEL_COLOR_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00106a', FALSE, NONE, 0.0, "", "Cortana : Chief, don't shoot." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00107', FALSE, NONE, 0.0, "", "Cortana : Those sentinels are still the same blue color as the ones we saw earlier, before the Didact took control of the Prometheans." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end*/




script dormant f_dialog_m40_cortana_elevator_confusion()
dprint("f_dialog_m40_cortana_elevator_confusion");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "ELEVATOR_CONFUSION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
								//	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_elevator_00100', FALSE, NONE, 0.0, "", "Cortana : OK, so this is a new one." );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_elevator_00101', FALSE, NONE, 0.0, "", "Cortana : This elevator should take us directly to the coordinates Infinity provided. Almost like those Sentinels WANTED us to get the guns offline." );
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00103', FALSE, NONE, 0.0, "", "Master Chief : This could be a trap." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_citadel_doors_00104', FALSE, NONE, 0.0, "", "Cortana : You say that like there's a second possibility." );
												
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_battery_reveal()
dprint("f_dialog_m40_battery_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "BATTERY_REVEAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00100', FALSE, NONE, 0.0, "", "Cortana : We've reached the coordinates. This looks like the place." );
									//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00102', FALSE, NONE, 0.0, "", "Cortana : The particle cannon network uses these arrays for targeting and guidance." );								
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script static void f_dialog_m40_battery_console()
sleep_s(300);
dprint("f_dialog_m40_battery_console");
				if cortana_inserted == FALSE then
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	
            l_dialog_id = dialog_start_foreground( "BATTERY_CONSOLE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00101', FALSE, NONE, 0.0, "", "Cortana : That console's active - let me at it." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			end

end



script dormant f_dialog_m40_cortana_powercave_plinth_dialogue()
dprint("f_dialog_m40_cortana_powercave_plinth_dialogue");
	cortana_inserted = TRUE;
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PLINTH_DIALOG", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );                       																	
								
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_vale_citadel_00107', FALSE, NONE, 0.0, "", "Cortana : Hm. I didn't expect something this dangerous to be unencrypted." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00104', FALSE, NONE, 0.0, "", "Cortana : ...TECHNICALLY." );
								object_hide(missile_hologram, TRUE);
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00105', FALSE, NONE, 0.0, "", "Cortana : Cortana to Infinity. The generators are offline. How's it look from up there?" );
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00106', FALSE, NONE, 0.0, "", "Cortana : Infinity??" );
								dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00108', FALSE, NONE, 0.0, "", "Master Chief : Cortana-" );
								dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00109', FALSE, NONE, 0.0, "", "Cortana : Something's in here-" );
								dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00110a', FALSE, NONE, 0.0, "", "Cortana : CHIEF!" );
								
											
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m40_chief_cortana_gone()
dprint("f_dialog_m40_chief_cortana_gone");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CHIEF_CORTANA_GONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_citadel_battery_00111', FALSE, NONE, 0.0, "", "Master Chief : Cortana? Cortana!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
            
end

script dormant f_dialog_m40_cortana_to_chief()
dprint("f_dialog_m40_cortana_to_chief");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_TO_CHIEF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\M40_global_chatter_00154', FALSE, falsetana, 0.0, "", "Cortana: Chief!" );
								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\M40_global_chatter_00214', FALSE, NONE, 0.0, "", "Cortana: Get me out of here!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
            
end


script dormant f_dialog_m40_librarian_to_chief()
dprint("f_dialog_librarian_to_chief");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LIBRARIAN_TO_CHIEF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00100', FALSE, NONE, 0.0, "", "Master Chief : Cortana?!?" );
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00101', FALSE, NONE, 0.0, "", "Librarian : Your ancilla is safe, Reclaimer.", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00102', FALSE, NONE, 0.0, "", "Librarian : Use of your armor's neural link is required for this simulation, and so separating you was a necessity.", TRUE);
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
            
end



script dormant f_dialog_m40_cortana_chief_reunite()
dprint("f_dialog_cortana_chief_reunite");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						
						sleep_s(6);
						sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00103', lib_cortana_2, fx_head, 1);
           /* l_dialog_id = dialog_start_foreground( "CORTANA_CHIEF_REUNITE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );			
            dprint("Chief! Up here!");		  
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00103', FALSE, lib_cortana_2, 0.0, "", "Cortana : Chief! Up here!" );

            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
            
					thread(f_dialog_m40_cortana_chief_reunite_02());
					
end

script static void f_dialog_m40_cortana_chief_reunite_02()
dprint("f_dialog_m40_cortana_chief_reunite_02");
	sleep_s(15);
	
			if b_cortana_retrieved == FALSE then
			sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00106', lib_cortana_2, fx_head, 1);
/*						local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_CHIEF_REUNITE_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  


											dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00106', FALSE, lib_cortana_2, 0.0, "", "Cortana : Pick me up, Chief." );

            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
       end
end



script dormant f_dialog_m40_retrieved_cortana()
dprint("f_dialog_m40_retrieved_cortana");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "RETRIEVED_CORTANA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );				
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00111', FALSE, NONE, 0.0, "", "Master Chief : How do we get out of here?" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00112', FALSE, NONE, 0.0, "", "Cortana : Elevator - back of the chamber." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m40_leave_without_cortana_1()
dprint("f_dialog_m40_leave_without_cortana");
if b_plinth_line_active == FALSE then
	b_plinth_line_active = TRUE;
	sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00107', lib_cortana_2, fx_head, 1);
	sleep (sound_impulse_time('sound\dialog\mission\m40\m40_librarian_room_00107'));
	b_plinth_line_active = FALSE;
	end
/*local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LEAVE_WITHOUT_CORTANA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
							 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00107', FALSE, lib_cortana_2, 0.0, "", "Cortana : Any time you're ready." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
end


script dormant f_dialog_m40_retrieve_cortana()
dprint("f_dialog_m40_leave_without_cortana");
	if b_plinth_line_active == FALSE then
	b_plinth_line_active = TRUE;
	sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00108', lib_cortana_2, fx_head, 1);
		sleep (sound_impulse_time('sound\dialog\mission\m40\m40_librarian_room_00108'));
		b_plinth_line_active = FALSE;
		  end
/*local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LEAVE_WITHOUT_CORTANA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					   
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00108', FALSE, lib_cortana_2, 0.0, "", "Cortana : Good work. Now come get me and let's get out of here." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
  
end

script dormant f_dialog_m40_leave_without_cortana_2()
dprint("f_dialog_m40_leave_without_cortana_2");
	if b_plinth_line_active == FALSE then
	b_plinth_line_active = TRUE;
	sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00109', lib_cortana_2, fx_head, 1);
		sleep (sound_impulse_time('sound\dialog\mission\m40\m40_librarian_room_00109'));
		b_plinth_line_active = FALSE;
		  end
		
/*	
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LEAVE_WITHOUT_CORTANA_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
							  dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00109', FALSE, lib_cortana_2, 0.0, "", "Cortana : Um, are we forgetting something?" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
end

script dormant f_dialog_m40_leave_without_cortana_3()
	dprint("f_dialog_m40_leave_without_cortana_3");
		if b_plinth_line_active == FALSE then
	b_plinth_line_active = TRUE;
	sound_impulse_start_marker('sound\dialog\mission\m40\m40_librarian_room_00110', lib_cortana_2, fx_head, 1);
		sleep (sound_impulse_time('sound\dialog\mission\m40\m40_librarian_room_00110'));
		b_plinth_line_active = FALSE;
		  end
	
/*	local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LEAVE_WITHOUT_CORTANA_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );					  
						   dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_librarian_room_00110', FALSE, lib_cortana_2, 0.0, "", "Cortana : How about NOT leaving the little blue girl behind?" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
end


script dormant f_dialog_elevator_delrio()
	dprint("f_dialog_elevator_delrio");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
						
	hud_play_pip_from_tag( bink\Campaign\M40_C_60 );
	thread(f_dialog_play_pip_m40_c_subtitles());

	sleep_s(10);
	hud_rampancy_players_set( 0.4 );
	sleep_s(2);
	hud_rampancy_players_set( 0.0 );
            
end

script static void f_dialog_play_pip_m40_c_subtitles()
	sleep_s(0.07);
	dialog_play_subtitle('sound\dialog\mission\m40\m40_portal_elevator_00100');
	dialog_play_subtitle('sound\dialog\mission\m40\m40_portal_elevator_00101');
	dialog_play_subtitle('sound\dialog\mission\m40\m40_portal_elevator_00102');
	dialog_play_subtitle('sound\dialog\mission\m40\m40_portal_elevator_00103');
end

script dormant f_dialog_m40_landing_in_battle()

dprint("f_dialog_m40_landing_in_battle");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "LANDING_IN_BATTLE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00100', FALSE, NONE, 0.0, "", "Master Chief : Sierra 117 to Infinity, what's our status?" );
								
								
								start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00102', FALSE, NONE, 0.0, "", "Del Rio : We're taking a beating up here.", TRUE);
								dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00103', FALSE, NONE, 0.0, "", "Master Chief : Does Infinity have a shot on the gravity well?" );
								dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00104', FALSE, NONE, 0.0, "", "Del Rio : Negative. We can get there, but we'll never be able to get a target lock with all the air traffic we're seeing.", TRUE);
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00200', FALSE, NONE, 0.0, "", "Cortana : Captain, what if we can spot the target for you with the laser designator?");
								dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00201', FALSE, NONE, 0.0, "", "Del Rio : Yes! TAC-COM, find the Chief coordinates for somewhere with line of sight!", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_epic_palmer_order()
dprint("f_dialog_m40_epic_palmer_order");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "PALMER_ORDER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            start_radio_transmission( "delrio_transmission_name" );
            			dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00204', FALSE, NONE, 0.0, "", "Del Rio : Move your ass, Spartan!", TRUE);
            end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_target_gravity_well()
dprint("f_dialog_m40_target_gravity_well");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TARGET_GRAVITY_WELL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            start_radio_transmission( "delrio_transmission_name" );
            		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00202', FALSE, NONE, 0.0, "", "Del Rio : Get up that hill, Spartan!", TRUE);
            end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_target_gravity_well_2()
dprint("f_dialog_m40_target_gravity_well");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TARGET_GRAVITY_WELL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            start_radio_transmission( "delrio_transmission_name" );
            		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00203', FALSE, NONE, 0.0, "", "Del Rio : One One Seven, status!", TRUE);
            end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m40_target_gravity_well_3()
dprint("f_dialog_m40_target_gravity_well");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "TARGET_GRAVITY_WELL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            start_radio_transmission( "delrio_transmission_name" );
            		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00204', FALSE, NONE, 0.0, "", "Move your ass, Spartan!", TRUE);
            end_radio_transmission();		
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_cortana_shield_ahead()
dprint("f_dialog_m40_cortana_clearing_ravine");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_SHIELD_AHEAD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );						
            	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00109', FALSE, NONE, 0.0, "", "Cortana : Looks like we're blocked! Chief, head down and find a way to destroy that shield!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_cortana_shield_destroyed_one()
dprint("f_dialog_m40_cortana_clearing_ravine");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_SHIELD_DESTROYED_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );						
            	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00110', FALSE, NONE, 0.0, "", "Cortana : Shield's weakening! Keep it up!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m40_cortana_clearing_ravine()
dprint("f_dialog_m40_cortana_clearing_ravine");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CORTANA_CLEARING_RAVINE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );						
            	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00108', FALSE, NONE, 0.0, "", "Cortana : There's a clearing just past this ravine." );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00109', FALSE, NONE, 0.0, "", "Cortana : We can get eyes on the gravity well up there!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end





script dormant f_dialog_m40_clear_out_the_bowl()
dprint("f_dialog_m40_clear_out_the_bowl");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "CLEAR_OUT_THE_BOWL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
            start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00110', FALSE, NONE, 0.0, "", "Del Rio : Del Rio to Gypsy.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00111', FALSE, NONE, 0.0, "", "Del Rio : Stop screwing around down there.", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_epic_bowl_00112', FALSE, NONE, 0.0, "", "Del Rio : Infinity can't take much more of this abuse.", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m40_epic_end()
dprint("f_dialog_m40_epic_end");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "EPIC_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            
            		//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00102a', FALSE, NONE, 0.0, "", "Cortana : OK, this is going to be tricky. Once you line up the shot, it’ll be up to you to guide the ordnance all the way down to the target." );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00100', FALSE, NONE, 0.0, "", "Cortana : Infinity, we're at the gravity well!" );						
								start_radio_transmission( "delrio_transmission_name" );
								hud_play_pip_from_tag( bink\Campaign\M40_D_60 );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00101', FALSE, NONE, 0.0, "", "Del Rio : Then paint that damn target so we can get out of here!", TRUE);
								end_radio_transmission();
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00102', FALSE, NONE, 0.0, "", "Cortana : You heard him, Chief - line up the shot!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m40_epic_end_nudge()
dprint("f_dialog_m40_epic_end_nudge");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "EPIC_END_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00102c', FALSE, NONE, 0.0, "", "Cortana : Do it! Use the target designator!" );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m40_epic_end_fired()
dprint("f_dialog_m40_epic_end_fired");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "EPIC_END_FIRED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
            start_radio_transmission( "delrio_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00103', FALSE, NONE, 0.0, "", "Del Rio : Target locked! Firing for effect!", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m40_epic_end_hit()
dprint("f_dialog_m40_epic_end_hit");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "EPIC_END_HIT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00104', FALSE, NONE, 0.0, "", "Cortana : Infinity, the shield is down!" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_tractor_beam_00105', FALSE, NONE, 0.0, "", "Cortana : The gravity well is all yours." );
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_stacker_01()
dprint("f_dialog_m40_stacker_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STACKER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
             start_radio_transmission( "stacker_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00108', FALSE, NONE, 0.0, "", "Sgt. Stacker : I’m reading Sierra One One Seven on-sensor.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00109', FALSE, NONE, 0.0, "", "Sgt. Stacker : Everyone form up on the Chief!", TRUE);
								end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_stacker_02()
dprint("f_dialog_m40_stacker_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STACKER_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
            start_radio_transmission( "stacker_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00110', FALSE, NONE, 0.0, "", "Sgt. Stacker : Clear this area. Push up the hill, marines!", TRUE);	
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00116', FALSE, NONE, 0.0, "", "Sgt. Stacker : You WILL prosecute these Covenant with extreme prejudice, soldier!", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_stacker_03()
dprint("f_dialog_m40_stacker_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STACKER_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
            start_radio_transmission( "stacker_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00111', FALSE, NONE, 0.0, "", "Sgt. Stacker : First line clear, check it off. Push forward!", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00112', FALSE, NONE, 0.0, "", "Sgt. Stacker : All eyes on the Chief, he’s lead dog!", TRUE);
							end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_stacker_04()
dprint("f_dialog_m40_stacker_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STACKER_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
								
            start_radio_transmission( "stacker_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00113', FALSE, NONE, 0.0, "", "Sgt. Stacker : Second line clear, this ain't a picnic. Let's move up!", TRUE);
						end_radio_transmission();		
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_stacker_05()
dprint("f_dialog_m40_stacker_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

            l_dialog_id = dialog_start_foreground( "STACKER_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );
            				
            start_radio_transmission( "stacker_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00114', FALSE, NONE, 0.0, "", "Sgt. Stacker : All right, that’s the last of 'em. No dessert, huh? Nothing left? Well done, marines.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m40\m40_sgtstacker_00115', FALSE, NONE, 0.0, "", "Sgt. Stacker : Chief, we’ll cover you from here.", TRUE);
						end_radio_transmission();
            l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end







// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

script static void f_dialog_m40_nudge_1()
dprint("f_dialog_m40_nudge_1");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_1", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m40_nudge_2()
dprint("f_dialog_m40_nudge_2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_2", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_3()
dprint("f_dialog_m40_nudge_3");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_3", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m40_nudge_4()
dprint("f_dialog_m40_nudge_4");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_4", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_5()
dprint("f_dialog_m40_nudge_5");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m40_nudge_6()
dprint("f_dialog_m40_nudge_6");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_6", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_7()
dprint("f_dialog_m40_nudge_7");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_7", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_8()
dprint("f_dialog_m40_nudge_8");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_8", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_9()
dprint("f_dialog_m40_nudge_9");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_9", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_10()
dprint("f_dialog_m40_nudge_10");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_10", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_11()
dprint("f_dialog_m40_nudge_11");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_11", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_12()
dprint("f_dialog_m40_nudge_12");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_12", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_13()
dprint("f_dialog_m40_nudge_13");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_13", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m40_nudge_14()
dprint("f_dialog_m40_nudge_14");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_14", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end


script static void f_dialog_m40_nudge_15()
dprint("f_dialog_m40_nudge_15");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_15", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================
   	  
   	  
script static void f_dialog_m40_palmer_off_map_01()
	dprint("f_dialog_m40_palmer_off_map_01");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
   	  				
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00100', FALSE, NONE, 0.0, "", "Palmer : Fight's not over yet, Spartan. Head back to the battle.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end   
                     
script static void f_dialog_m40_palmer_off_map_02()
	dprint("f_dialog_m40_palmer_off_map_02");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00101', FALSE, NONE, 0.0, "", "Palmer : Is something wrong, Master Chief?", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end       

script static void f_dialog_m40_palmer_off_map_03()
	dprint("f_dialog_m40_palmer_off_map_03");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00102', FALSE, NONE, 0.0, "", "Palmer : This is Palmer, the Mammoth's undefended! All boots, back in the fight.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end                               

script static void f_dialog_m40_palmer_off_map_04()
	dprint("f_dialog_m40_palmer_off_map_04");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00103', FALSE, NONE, 0.0, "", "Palmer : You're picking a helluva time to go for a walk. Get back there!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end   

script static void f_dialog_m40_palmer_off_map_05()
	dprint("f_dialog_m40_palmer_off_map_05");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00104', FALSE, NONE, 0.0, "", "Palmer : Return to the battle perimeter, soldier.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end   

script static void f_dialog_m40_palmer_off_map_06()
	dprint("f_dialog_m40_palmer_off_map_06");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00105', FALSE, NONE, 0.0, "", "Palmer : Chief, you need to hold that battle position!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end   

script static void f_dialog_m40_palmer_off_map_07()
	dprint("f_dialog_m40_palmer_off_map_07");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00106', FALSE, NONE, 0.0, "", "Palmer : Back to the action, One One Seven.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script static void f_dialog_m40_palmer_off_map_08()
	dprint("f_dialog_m40_palmer_off_map_08");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_palmer_nudges_00107', FALSE, NONE, 0.0, "", "Palmer : The fun's the other way, Master Chief. Turn it around.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script static void f_dialog_m40_target_missed()
sleep_until (b_target_missed == TRUE);
	dprint("f_dialog_m40_target_missed");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then
   	  l_dialog_id = dialog_start_background( "M40_TARGET_MISSED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00102', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Target missed!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
			 l_dialog_id = dialog_start_background( "M40_TARGET_MISSED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00103', FALSE, NONE, 0.0, "", "Cortana: Target wide!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
sleep_s(2);
thread(f_dialog_m40_target_missed());

end  

script static void f_dialog_m40_target_acquired()
sleep_until (b_target_acquired == TRUE);
	dprint("f_dialog_m40_target_acquired");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then 
   	  l_dialog_id = dialog_start_background( "M40_TARGET_MISSED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00101', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Target acquired!", TRUE);
						end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then 
   	  l_dialog_id = dialog_start_background( "M40_TARGET_MISSED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00102', FALSE, NONE, 0.0, "", "Cortana : Target acquired!");
						
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	thread(f_dialog_m40_target_acquired());
end  


script static void f_dialog_m40_no_line_of_sight()
	sleep_until (b_no_line_of_sight == TRUE);
	dprint("f_dialog_m40_no_line_of_sight");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then 
   	  l_dialog_id = dialog_start_background( "M40_NO_LINE_OF_SIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00103', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : No line of sight on target!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			end_radio_transmission();
	elseif s_random == 2 then
	  l_dialog_id = dialog_start_background( "M40_NO_LINE_OF_SIGHT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00104', FALSE, NONE, 0.0, "", "Cortana : No line of sight on target!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	end
	thread(f_dialog_m40_no_line_of_sight());
end  

script static void f_dialog_m40_target_destroyed()
	sleep_until (b_target_destroyed == TRUE);
	dprint("f_dialog_m40_target_destroyed");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then   
   	  l_dialog_id = dialog_start_background( "M40_TARGET_DESTROYED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00104', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Target destroyed!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
   	  l_dialog_id = dialog_start_background( "M40_TARGET_DESTROYED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00105', FALSE, NONE, 0.0, "", "Cortana : Target destroyed!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );	
	end
	thread(f_dialog_m40_target_destroyed());
end  

script static void f_dialog_m40_rail_gun_reloading()
	sleep_until (b_rail_gun_reloading == TRUE);
	dprint("f_dialog_m40_rail_gun_reloading");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then   
   	  l_dialog_id = dialog_start_background( "M40_TARGET_DESTROYED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
   	
   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00105', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Rail gun reloading!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
			l_dialog_id = dialog_start_background( "M40_TARGET_DESTROYED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00106', FALSE, NONE, 0.0, "", "Cortana: Rail gun reloading!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end
	thread(f_dialog_m40_rail_gun_reloading());
end  

script static void f_dialog_m40_rail_gun_ready()
sleep_until (b_rail_gun_ready == TRUE);
	dprint("f_dialog_m40_rail_gun_ready");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then   
   	  l_dialog_id = dialog_start_background( "M40_RAIL_GUN_READY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00106', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Rail gun ready to fire!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
			l_dialog_id = dialog_start_background( "M40_RAIL_GUN_READY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00107', FALSE, NONE, 0.0, "", "Cortana: Rail gun ready to fire!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		end
		thread(f_dialog_m40_rail_gun_ready());
end  


script static void f_dialog_m40_rail_gun_available()
	sleep_until (b_rail_gun_available == TRUE);
	dprint("f_dialog_m40_rail_gun_available");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then   
   	  l_dialog_id = dialog_start_background( "M40_RAIL_GUN_AVAILABLE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00107', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Rail gun available!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
   	  l_dialog_id = dialog_start_background( "M40_RAIL_GUN_AVAILABLE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00108', FALSE, NONE, 0.0, "", "Cortana: Rail gun available!");
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

	end
	thread(f_dialog_m40_rail_gun_available());
	
end  


script dormant f_dialog_40_good_job()
	dprint("f_dialog_40_good_job");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_GOOD_JOB", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_forcefield_00107', FALSE, NONE, 0.0, "", "Cortana : Good job, Chief." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_wraith()
	dprint("f_dialog_40_wraith");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_WRAITH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00125', FALSE, NONE, 0.0, "", "Cortana: Wraith!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  


script dormant f_dialog_40_target_those_phantoms()
	dprint("f_dialog_40_target_those_phantoms");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_TARGET_THOSE_PHANTOMS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00101', FALSE, NONE, 0.0, "", "Cortana: Target those Phantoms for the Rail Gun to shoot down!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_heavy_gear()
	dprint("f_dialog_40_heavy_gear");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  start_radio_transmission( "delrio_transmission_name" );
   	  l_dialog_id = dialog_start_background( "M40_HEAVY_GEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_gauss_00100', FALSE, NONE, 0.0, "", "Del Rio: Gypsy, local air space secure. I'm sending down some heavy gear.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			end_radio_transmission();
end  
script dormant f_dialog_40_gauss_hog_01()
	dprint("f_dialog_40_heavy_gear");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_TARGET_GAUSS_HOG_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_gauss_00101', FALSE, tort_marines.aaron, 0.0, "", "Marine 1: Gauss Hog, ready to roll!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_gauss_hog_02()
	dprint("f_dialog_40_heavy_gear");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_TARGET_GAUSS_HOG_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_gauss_00102', FALSE, tort_marines.randall, 0.0, "", "Marine 2: Gauss Hog available, sir.", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_light_em_up()
	dprint("f_dialog_40_light_em_up");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_LIGHT_EM_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00119', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Covenant, dug in on the left! Light 'em up!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end  

script dormant f_dialog_40_banshees_left()
	dprint("f_dialog_40_banshees_left");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_BANSHEES_LEFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

   	   	  start_radio_transmission( "lasky_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00120', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky : Banshees, left of the Mammoth!", TRUE);
									end_radio_transmission();
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end  

script dormant f_dialog_40_take_out_banshees()
	dprint("f_dialog_40_take_out_banshees");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_take_out_banshees", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
   	   	  
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_marine_00100', FALSE, tort_marines.randall, 0.0, "", "Marine 2: Someone take out those Banshees!", TRUE);
					
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end  

script dormant f_dialog_40_clear_out_those()
	dprint("f_dialog_40_clear_out_those");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_CLEAR_OUT_THOSE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00109', FALSE, NONE, 0.0, "", "Cortana: Clear out these enemies!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_target_forerunner()
	dprint("f_dialog_40_clear_out_those");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_CLEAR_OUT_THOSE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00110', FALSE, NONE, 0.0, "", "Cortana: Chief, target that Forerunner cannon." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  


script dormant f_dialog_40_use_the_designator()
	dprint("f_dialog_40_use_the_designator");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  local short s_random = 0;
  	  
	s_random = random_range(1, 2);

	if s_random == 1 then   
   	     	  l_dialog_id = dialog_start_background( "M40_USE_THE_DESIGNATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );

						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_lasky_00110', FALSE, Marines_lasky.lasky, 0.0, "", "Lasky: Use the designator on the cannon!", TRUE);
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	elseif s_random == 2 then
   	  l_dialog_id = dialog_start_background( "M40_USE_THE_DESIGNATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00111', FALSE, NONE, 0.0, "", "Cortana: Use the designator on the cannon!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	end

end  

script dormant f_dialog_40_marker_on_hud()
	dprint("f_dialog_40_marker_on_hud");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_MARKER_ON_HUD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00113', FALSE, NONE, 0.0, "", "Cortana: Get to the marker on your HUD, Chief." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_40_marker_on_hud_02()
	dprint("f_dialog_40_marker_on_hud_02");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_MARKER_ON_HUD_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m40\m40_global_Cortana_00114', FALSE, NONE, 0.0, "", "Cortana: Chief, we need to take out that target marked on your HUD." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  


script dormant f_dialog_40_phantom_on_approah()
	dprint("f_dialog_40_phantom_on_approah");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
  	  
   	  l_dialog_id = dialog_start_background( "M40_PHANTOM_ON_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00107', FALSE, NONE, 0.0, "", "Cortana: Phantom on approach!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end  

script dormant f_dialog_m40_more_covenant()
dprint("f_dialog_callout_more_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00121', FALSE, NONE, 0.0, "", "Cortana : More Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_banshees()
dprint("f_dialog_callout_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00126', FALSE, NONE, 0.0, "", "Cortana : Banshees!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_well_done()
dprint("f_dialog_callout_well_done");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WELL_DONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00135', FALSE, NONE, 0.0, "", "Cortana : Well done." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_come_in_handy()
dprint("f_dialog_callout_move_left");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MOVE_LEFT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00143', FALSE, NONE, 0.0, "", "Cortana : That could come in handy." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_hold_them_off()
dprint("f_dialog_callout_hold_them_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOLD_THEM_OFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00147', FALSE, NONE, 0.0, "", "Cortana : Hold them off!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_last_of_them()
dprint("f_dialog_callout_last_of_them");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LAST_OF_THEM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00182', FALSE, NONE, 0.0, "", "Cortana : That's the last of them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_reinforcements_inbound()
dprint("f_dialog_callout_reinforcements_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "REINFORCEMENTS_INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00110', FALSE, NONE, 0.0, "", "Cortana : Reinforcements, Chief. And something tells me they won’t be the last." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_clean_em_up()
dprint("f_dialog_m40_clean_em_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CLEAN_EM_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00245', FALSE, NONE, 0.0, "", "Cortana : Clean 'em up!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m40_we_still_got_targets()
dprint("f_dialog_m40_we_still_got_targets");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "STILL_GOT_TARGETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00244', FALSE, NONE, 0.0, "", "Cortana : We’ve still got targets!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
