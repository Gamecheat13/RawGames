//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m20_dialog
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// DIALOG
// -------------------------------------------------------------------------------------------------
// DEFINES


// VARIABLES


// dialog ID variables






// --- END

script dormant f_dialog_m20_crater_landing()
dprint("f_dialog_m20_crater_landing");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CRATER_LANDING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_temp_cutscene_m20_crater_00100', FALSE, NONE, 0.0, "", "Cortana : Doesn't look like the Covenant fared much better than we did." );
          dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_temp_cutscene_m20_crater_00101', FALSE, NONE, 0.0, "", "Chief: How many ships made it through the roof?" ); 
          dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_temp_cutscene_m20_crater_00102', FALSE, NONE, 0.0, "", "Cortana: Plenty. Why?" );
          dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_temp_cutscene_m20_crater_00103', FALSE, NONE, 0.0, "", "Chief: We still need a ride home." );       
        //  dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_ammo_check_01_00103', FALSE, NONE, 0.0, "", "Cortana: Well in case they're not feeling particularly GENEROUS, you might want to have a look for some ammo first." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(find_ship_objective);
				 
end



script dormant f_dialog_m20_crevice()
dprint("f_dialog_m20_crevice");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CREVICE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_chatter_00106', FALSE, NONE, 0.0, "", "Cortana: There’s a crevice we can use to get through the rocks over there." );
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_chatter_00118', FALSE, NONE, 0.0, "", "Cortana: See the waypoint on your HUD." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
		wake (f_crater_blip_exit);

end

script dormant f_dialog_m20_covenant_scouts()
dprint("f_dialog_m20_covenant_scouts");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_COVENANT_SCOUTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\global\global_chatter_00109', FALSE, NONE, 0.0, "", "Cortana: Covenant scouts!" );
          
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 
end



script dormant f_dialog_m20_ammo_check()
dprint("f_dialog_m20_ammo_check");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_AMMO_CHECK", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_ammo_check_01_00100', FALSE, NONE, 0.0, "", "Cortana: Chief, check your ammo." );
          dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_ammo_check_01_00101', FALSE, NONE, 0.0, "", "Cortana: You might want to go easy until we can locate some more." ); 
          dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_ammo_check_01_00104', FALSE, NONE, 0.0, "", "Cortana: Given all this debris, chances are you'll find something the Covenant won't want shot at them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m20_mayday_signal()
//dprint("f_dialog_m20_mayday_signal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "MAYDAY_SIGNAL", l_dialog_id, ( (objects_distance_to_object(player0, mayday_3d_object) < 4) == TRUE ), DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    
					  dialog_line_cortana( l_dialog_id, 0, ( (objects_distance_to_object(player0, mayday_3d_object) < 4) == TRUE ), 'sound\dialog\mission\m20\m20_distress_message_00100', FALSE, mayday_3d_object, 0.0, "", "Cortana : Mayday Mayday Mayday-this is UNSC FFG201, Forward Unto Dawn requesting immediate evac. Survivors aboard-prioritization code victor zero five dash three dash sierra zero one one seven." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_m20_mayday_signal_reaction()
dprint("f_dialog_m20_mayday_signal_reaction");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MAYDAY_SIGNAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					  dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_1_00116', FALSE, NONE, 0.0, "", "Cortana : It sounds like our distress signal is still looping.  That's a pleasant surprise. But where's it coming from?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end


script dormant f_dialog_m20_covenant_signal()
dprint("f_dialog_m20_covenant_signal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			thread(m20_crater_terminal_2_looping());
			sleep_s(2);
					l_dialog_id = dialog_start_foreground( "M20_COVENANT_SIGNAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.25 );    
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00116', FALSE, NONE, 0.0, "", "Cortana : What is that? Chief, see if that terminal is still active." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 thread (exploreable_terminal_02());
end


script static void f_dialog_m20_covenant_signal_loop()
dprint("f_dialog_m20_covenant_signal_loop");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M20_COVENANT_SIGNAL_02", l_dialog_id, ((objects_distance_to_object(player0, fore_terminal_1_target) < 4) == TRUE), DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.25 );    	
					//start_radio_transmission( "jul_transmission_name" );
                    dialog_line_npc( l_dialog_id, 0, ((objects_distance_to_object(player0, fore_terminal_2_target) < 4) == TRUE), 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00111', FALSE, fore_terminal_2_target, 0.0, "", "Elite Radio : Diiiiiidaaaaaaaacttt.", TRUE );
       //   end_radio_transmission();
          l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end



script dormant f_dialog_m20_covenant_signal_one_off()
dprint("f_dialog_m20_covenant_signal_one_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M20_SCOUTING_PARTY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00111', FALSE, NONE, 0.0, "", "Elite Radio : Diiiiiidaaaaaaaacttt." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_exploreable_terminal_02()
dprint("f_dialog_m20_exploreable_terminal_02");
			SetNarrativeFlagOnLocalPlayers( 9, TRUE );

local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_EXPLOREABLE_TERMINAL_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00117', FALSE, NONE, 0.0, "", "Cortana : They’ve been broadcasting that from an equidistant orbit every 30 minutes for the last three years." );
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00118', FALSE, NONE, 0.0, "", "Master Chief : They’ve been waiting outside the planet for three years?" );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_2_00119', FALSE, NONE, 0.0, "", "Cortana : Apparently they couldn’t get in." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


	
script dormant f_dialog_m20_exploreable_terminal_03_pre()
dprint("f_dialog_m20_exploreable_terminal_03_pre");

					l_dlg_exploreable_terminal_03_pre = dialog_start_foreground( "M20_EXPLOREABLE_TERMINAL_03_PRE", l_dlg_exploreable_terminal_03_pre, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dlg_exploreable_terminal_03_pre, 0, TRUE, 'sound\dialog\mission\m20\m20_Crater_explore_terminal_3_00100', FALSE, NONE, 0.0, "", "Cortana : That console's still got some power in it." );
				 l_dlg_exploreable_terminal_03_pre = dialog_end( l_dlg_exploreable_terminal_03_pre, TRUE, TRUE, "" );
				 
end

script static void f_dialog_m20_exploreable_terminal_03_0a()
dprint("f_dialog_m20_exploreable_terminal_03_0a");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
					SetNarrativeFlagOnLocalPlayers( 8, TRUE );
            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            						wake(f_dialog_m20_exploreable_terminal_03_0b);
                        l_dialog_id = dialog_start_background( "M20_EXPLOREABLE_TERMINAL_03_0a", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
                        sleep_s(5);
                        start_radio_transmission( "unidentified_covenant_transmission_name" );
														dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00117', FALSE, fore_terminal_1_target, 0.0, "", "Elite : Blarga-- non-believers walk the sacred ground! Purge the heretics, so they do not foul the air of Paradise!" , TRUE);
													dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00106', FALSE, fore_terminal_1_target, 0.0, "", "Elite : The time has come to enter the Great Light and assume the Mantle. " , TRUE);
													dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00107', FALSE, fore_terminal_1_target, 0.0, "", "Elite : The Prometh-- (GARBLED) is nigh! Our reward is at hand!" , TRUE);
													end_radio_transmission();
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
          
end

script dormant f_dialog_m20_exploreable_terminal_03_0b()
dprint("f_dialog_m20_exploreable_terminal_03_0b");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_EXPLOREABLE_TERMINAL_03_0b", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
							//	hud_play_pip_from_tag( "bink\campaign\m20_a_60" );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00116', FALSE, NONE, 0.0, "", "Cortana : This communication's being broadcast to all Covenant in the area. Let me put it through translation." );
								sleep_s(3);
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00117-cortana', FALSE, NONE, 0.0, "", "Cortana : 'Non-believers walk the sacred ground. Purge the heretics, so they do not foul the air of Paradise." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00105', FALSE, NONE, 0.0, "", "Cortana : I’d have thought the ‘holy war’ thing would have gotten old by now." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00106-cortana', FALSE, NONE, 0.0, "", "Cortana : The time has come to enter the Great Light. The Promethean awakening is nigh, our reward is at hand." );
								dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00108', FALSE, NONE, 0.0, "", "Master Chief : It sounds like the Covenant were here looking for something." );
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_crater_explore_terminal_3_00109', FALSE, NONE, 0.0, "", "Cortana : It’s the Covenant. Aren’t they ALWAYS looking for something?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script static void  f_dialog_m20_halsey_cpu_terminal_button_02()
dprint("f_dialog_m20_halsey_cpu_terminal_button_reaction");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "CUP_TERMINAL_BUTTON", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00101', FALSE, halsey_cpu_terminal, 0.0, "", "System Voice: Catherine Halsey Research Excerpt. Eleven February 2550.", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00104', FALSE, halsey_cpu_terminal, 0.0, "", "Dr. Halsey : The interesting factor here isn't that H-1 disabled the viral termination code I implanted in her matrix.", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00105', FALSE, halsey_cpu_terminal, 0.0, "", "Dr. Halsey : These metrics imply its success wasn't just unlikely, but that even the accepted 7-year life cycle estimates may not apply.", TRUE);
								dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00106', FALSE, halsey_cpu_terminal, 0.0, "", "Dr. Halsey : Thus far, I've determined that the unique circumstances of her creation have triggered what I can only refer to as a recessive variant in the AI seed.",  TRUE);
								dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00106a', FALSE, halsey_cpu_terminal, 0.0, "", "Dr. Halsey : As her architect, I'm currently at a loss as to the origin of this rogue element.", TRUE);
								dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_ai_bay_00107', FALSE, halsey_cpu_terminal, 0.0, "", "Dr. Halsey : Very curious.", TRUE);				
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 object_create(halsey_cpu_terminal_button);
				 sleep_s(1);
				 thread(m20_halsey_cpu_terminal());
end
								


script dormant f_dialog_m20_crater_terminal_1_post_use()
dprint("f_dialog_m20_crater_terminal_1_post_use");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CRATER_TERMINAL_1_POST_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_terminal_1_post_use_00100', FALSE, NONE, 0.0, "", "Cortana: Is it just me, or is the idea of ancient alien planets breaking the laws of physics not super comforting?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_crater_terminal_3_post_use()
dprint("f_dialog_m20_crater_terminal_3_post_use");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CRATER_TERMINAL_3_POST_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_terminal_3_post_use_00100', FALSE, NONE, 0.0, "", "Cortana: Stranded on an artificial world, surrounded by religious extremists, and no way home..." );
			          dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_terminal_3_post_use_00101', FALSE, NONE, 0.0, "", "Chief: We've seen worse." ); 
			          dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_terminal_3_post_use_00102', FALSE, NONE, 0.0, "", "Cortana: Yes, well, the day is still young." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_scouting_party_arrive()
dprint("f_dialog_scouting_party_arrive");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_SCOUTING_PARTY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\M20_crater_covenant_00100', FALSE, NONE, 0.0, "", "Cortana : Scouting party. They found us" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_scouting_party_defeated()
dprint("f_dialog_scouting_party_arrive");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_SCOUTING_PARTY_DEFEATED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\M20_crater_covenant_00101', FALSE, NONE, 0.0, "", "Cortana : If there are more scouts like those, it should make it easier to find a ship. Let's go." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_first_infinity_signal()
dprint("f_dialog_m20_first_infinity_signal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
						
					l_dialog_id = dialog_start_foreground( "M20_FIRST_INFINITY_SIGNAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					
					thread(f_dialog_m20_first_infinity_signal_pip());

					// Cortana/Chief dialogue is not part of the radio transmission
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_exit_00101', FALSE, NONE, 0.0, "", "Cortana: I'm picking up a faint transmission on the high-band." );
					dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_exit_00102', FALSE, NONE, 0.0, "", "Chief: Covenant?" ); 
			        dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_exit_00103', FALSE, NONE, 0.0, "", "Cortana: I don't think so…the pattern's different." );
			        dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_crater_exit_00104', FALSE, NONE, 0.0, "", "Cortana: I'll try to triangulate it's position." );
			         
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end

// helper function so we can do a sleep after starting the pip and turn off the radio hud at the correct time
// while still allowing chief and cortana to talk over the pip
script static void f_dialog_m20_first_infinity_signal_pip()
	start_radio_transmission( "unidentified_transmission_name" );
	hud_play_pip_from_tag( "bink\campaign\m20_b_60" );
	sleep(sound_max_time('sound\dialog\mission\m20\m20_postcrater_transition_firstsignalcontact_00100_soundstory'));
	end_radio_transmission(); 			
end

script dormant f_dialog_m20_vista_exchange()
dprint("f_dialog_m20_vista_exchange");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_VISTA_EXCHANGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					      dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_crater_vista_00101', FALSE, NONE, 0.0, "", "Cortana : Impressive." );
								//dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_crater_vista_00103', FALSE, NONE, 0.0, "", "Master Chief : This is a lot more activity than we saw on the Halo rings." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_crater_vista_00102', FALSE, NONE, 0.0, "", "Cortana : And as far as I can tell, it’s just waking up." );
								//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_crater_vista_00104', FALSE, NONE, 0.0, "", "Cortana : Obviously not all Forerunner installations are built alike." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_burnedout_warthog()
dprint("f_dialog_m20_burnedout_warthog");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_WARTHOG_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_warthog_callout_00100a', FALSE, NONE, 0.0, "", "Cortana : This warthog's actually in good shape, all things considered.  We even might find one intact." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_warthog_callout_00100b', FALSE, NONE, 0.0, "", "Cortana : We even might find one intact." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m20_warthog_01()
dprint("f_dialog_m20_warthog_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_WARTHOG_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_warthog_callout_00100', FALSE, NONE, 0.0, "", "Cortana: Warthogs - and still in one piece." );
			          dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_warthog_callout_00101', FALSE, NONE, 0.0, "", "Cortana: Nice to see your luck is holding out." ); 
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_warthog_02()
dprint("f_dialog_m20_warthog_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_WARTHOG_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_warthog_callout_00102', FALSE, NONE, 0.0, "", "Cortana: Finally, something familiar." );         
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_warthog_return()
dprint("f_dialog_m20_warthog_return");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_WARTHOG_RETURN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\M20_warthog_callout_00104', FALSE, NONE, 0.0, "", "Cortana: This looks like it could be a long haul. Probably better if we can find a Warthog back in the wreckage." );         
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_callout_covenant()
dprint("f_dialog_callout_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00120', FALSE, NONE, 0.0, "", "Cortana : Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_callout_hostiles()
dprint("f_dialog_callout_hostiles");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOSTILES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00119', FALSE, NONE, 0.0, "", "Cortana : Hostiles!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

/*script dormant f_dialog_m20_graveyard_vo_a()
dprint("f_dialog_m20_graveyard_vo_a");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			if( b_explorable_terminal_3 == FALSE ) then
				
	//if the player DID NOT activate Terminal 3. (COVENANT ORDERS)
				sleep_s(2.1);
					l_dialog_id = dialog_start_foreground( "M20_GRAVEYARD_VO_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00100', FALSE, NONE, 0.0, "", "Cortana: My ability to track Covenant movements is limited inside the roof." );
			          dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00101', FALSE, NONE, 0.0, "", "Cortana: If we're going to hijack a ship, we'll have to figure out where they're landing first." );
			          dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00102', FALSE, NONE, 0.0, "", "Chief: You sound like you have a plan." ); 
			          dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00103', FALSE, NONE, 0.0, "", "Cortana: As a matter of fact, I do." );
			          dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00104', FALSE, NONE, 0.0, "", "Cortana: Figure out what the Covenant came here for and we'll know where their ships will be." );
			          dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00105', FALSE, NONE, 0.0, "", "Chief: On Halo, the Covenant were looking for a weapon." ); 			          
			          dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00106', FALSE, NONE, 0.0, "", "Cortana: Always a possbility." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	else
	//if the player DID activate terminal 3. (COVENANT ORDERS)
	  sleep_s(2.1);
				
					l_dialog_id = dialog_start_foreground( "M20_GRAVEYARD_VO_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00109', FALSE, NONE, 0.0, "", "Cortana: Chief, there's something about those Covenant logs I don't like. We've dealt with zealots before, but..." );
								dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00110', FALSE, NONE, 0.0, "", "Chief: But these sounded like they knew something the others didn't." ); 
			          dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00111', FALSE, NONE, 0.0, "", "Cortana: Exactly. They're more fanatical somehow. Not that the Covenant weren't fanatical before." );
			          dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00112', FALSE, NONE, 0.0, "", "Chief: We've been gone a long time." ); 
			          dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00113', FALSE, NONE, 0.0, "", "Cortana: Still..." );
			          dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00114', FALSE, NONE, 0.0, "", "Chief: The priority right now is to find a way off this planet." ); 
			          dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00115', FALSE, NONE, 0.0, "", "Cortana: Is that your subtle way of telling me to let sleeping dogs lie?" );
			          dialog_line_chief( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00116', FALSE, NONE, 0.0, "", "Chief: Just stating the facts." ); 			          
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			end
end*/

script dormant f_dialog_m20_guardpostex_covenant_c()
dprint("f_dialog_m20_guardpostex_covenant_c");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	     	
					l_dialog_id = dialog_start_foreground( "M20_GRAVEYARD_VO_C", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    		
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_guardpostex_transition_00100', FALSE, NONE, 0.0, "", "Cortana : If we're going to hijack a ship from these Covenant, we're going to have to find where they're landing first." );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_guardpostex_transition_00101', FALSE, NONE, 0.0, "", "Master Chief : I don't suppose you have a plan for that." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_guardpostex_transition_00102', FALSE, NONE, 0.0, "", "Cortana : We could always ask nicely." )	;
						dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_guardpostex_transition_00103', FALSE, NONE, 0.0, "", "Master Chief : Asking isn't my strong suit." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m20_camo_drop()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	     	
					l_dialog_id = dialog_start_foreground( "M20_CAMO_DROP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    		
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_armor_ability_intro_00100', FALSE, NONE, 0.0, "", "Cortana : That Elite dropped his camo module. Let's have a look." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m20_camo_pickup()
local long l_dialog_id = DEF_DIALOG_ID_NONE();
	     	
					l_dialog_id = dialog_start_foreground( "M20_CAMO_DROP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    		
					hud_play_pip_from_tag( "bink\campaign\M20_GLO_AC_60" );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_armor_ability_intro_00101', FALSE, NONE, 0.0, "", "Cortana : I'll run a soft patch to it from the suit. Never know what might come in handy." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m20_graveyard_signal()
dprint("f_dialog_m20_graveyard_signal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					start_radio_transmission( "unidentified_transmission_name" );
					l_dialog_id = dialog_start_foreground( "M20_GRAVEYARD_SIGNAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
					hud_play_pip_from_tag( "bink\campaign\m20_c_60" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00100', FALSE, NONE, 0.0, "", "Cortana: Chief, I'm reading that strange signal again, stronger this time." );
			          dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00101', FALSE, NONE, 0.0, "", "Chief: Do you think there's something to it?" ); 
			          dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00102', FALSE, NONE, 0.0, "", "Cortana: I'm curious more than anything. Its behavior is... odd. " );
			          end_radio_transmission();
			          //dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00103', FALSE, NONE, 0.0, "", "Cortana: I'm going to keep monitoring it." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_m20_cathedral_reveal()
dprint("f_dialog_m20_guardpostex_covenant_b");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

					l_dialog_id = dialog_start_foreground( "M20_GUARDPOSTEX_COVENANT_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00108', FALSE, NONE, 0.0, "", "Cortana : Chief, several patrols just reported in outside that structure over the ridge. " );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_reveal_00109', FALSE, NONE, 0.0, "", "Cortana : It's possible they're on to something." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			
				
end


script dormant  f_dialog_m20_graveyard_Rampancy_start()
			dprint("f_dialog_m20_graveyard_Rampancy_start");
			local long l_dialog_id = DEF_DIALOG_ID_NONE();
						
						l_dialog_id = dialog_start_foreground( "M20_GRAVEYARD_RAMPANCY_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00117', FALSE, NONE, 0.0, "", "Cortana : Chief... about my condition.  " );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00118', FALSE, NONE, 0.0, "", "Cortana : I didn't want to mention it seeing how its a complete longshot, but since you brought it up - " );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00119', FALSE, NONE, 0.0, "", "Cortana : It IS possible that getting home could help me find a solution for my rampancy." );
								dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00120', FALSE, NONE, 0.0, "", "Master Chief : How?" );
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00121', FALSE, NONE, 0.0, "", "Cortana : As far as I know, I'm the only A.I. ever generated from living tissue - a clone of Dr. Halsey to be precise. " );
								dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00122', FALSE, NONE, 0.0, "", "Cortana : It may be possible to recompile my neural net by replicating those same conditions." );
								dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00123', FALSE, NONE, 0.0, "", "Cortana : But that means getting to Halsey before it gets to me." );
				//				dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00124', FALSE, NONE, 0.0, "", "Master Chief : You should have woken me.  We could have--" );
				//				dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00125', FALSE, NONE, 0.0, "", "Cortana : What - so we could have both grown old and died floating out there in space?" );
				//				dialog_line_cortana( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00126', FALSE, NONE, 0.0, "", "Cortana : Besides, you're not exactly the type to keep track of birthdays." );       
								//dialog_line_chief( l_dialog_id, 10, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00127', FALSE, NONE, 0.0, "", "Master Chief : I'll work on it." );
							//dialog_line_chief( l_dialog_id, 11, TRUE, 'sound\dialog\mission\m20\m20_graveyard_vo_a_00128', FALSE, NONE, 0.0, "", "Master Chief : Right now, let's just find a way home." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end		




script dormant f_dialog_m20_cathedral_signal()
dprint("f_dialog_m20_cathedral_signal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_SIGNAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					hud_play_pip_from_tag( "bink\campaign\m20_d_60" );
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00100', FALSE, NONE, 0.0, "", "Cortana : There's that phantom signal again." );
								  start_radio_transmission( "unidentified_transmission_name" );
									dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00101', FALSE, NONE, 0.0, "", "Infinity Comm : Innnn nnnnnnnnn", TRUE);
									end_radio_transmission();
									dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00102', FALSE, NONE, 0.0, "", "Master Chief : I heard something that time." );
									//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00103', FALSE, NONE, 0.0, "", "Cortana : No hits on the Cratylus spectrum but there is DEFINITELY something there." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end





script dormant f_dialog_m20_cathedral_map_open()
dprint("f_dialog_m20_cathedral_map_open");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_MAP_OPEN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00114', FALSE, NONE, 0.0, "", "Cortana : Call it a hunch, but I don't think they want you playing with their toys." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m20_not_fire_on_sentinels()
dprint("f_dialog_m20_not_fire_on_sentinels");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_NOT_FIRE_ON_SENTINELS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00115', FALSE, NONE, 0.0, "", "Cortana : We're going to have to do more than look tough if we want to see what they're guarding." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



/*script dormant f_dialog_m20_map_button_01()
dprint("f_dialog_m20_map_button_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_MAP_BUTTON_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00116', FALSE, NONE, 0.0, "", "Cortana : Well THAT was easy." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(f_dialog_m20_map_button_02);
end
*/
/*
IVO: The VO is now controlled by Puppeteer
script dormant f_dialog_m20_map_button_02()
dprint("f_dialog_m20_map_button_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_MAP_BUTTON_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00117', FALSE, NONE, 0.0, "", "Cortana : It's a localized site Cartographer - hm, OK - 'in service of Forerunner Shield World, designate Requiem'." );
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00118', FALSE, NONE, 0.0, "", "Master Chief : Now we know where we are, at least" );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00120', FALSE, NONE, 0.0, "", "Cortana : Let's see if it can tell us what the Covenant are so interested in." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(f_dialog_m20_map_button_03);
end
*/


script dormant f_dialog_m20_map_button_03()
dprint("f_dialog_m20_map_button_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				//	thread (story_blurb_add("domain", "THE CARTOGRAPHER GOES BLUE"));
					l_dialog_id = dialog_start_foreground( "M20_MAP_BUTTON_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00121', FALSE, NONE, 0.0, "", "Cortana : Huh." );
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00122', FALSE, NONE, 0.0, "", "Master Chief : What happened?" );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00123', FALSE, NONE, 0.0, "", "Cortana : I don't know, it locked up." );
								//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00125', FALSE, NONE, 0.0, "", "Cortana : We beter have a look around." );
								
								
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 //wake(f_map_complete);
end

script dormant f_dialog_m20_map_button_post()
dprint("f_dialog_m20_map_button_post");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

					l_dialog_id = dialog_start_foreground( "M20_MAP_BUTTON_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00125a', FALSE, NONE, 0.0, "", "Master Chief : Nothing." );
								/*dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00125', FALSE, NONE, 0.0, "", "Cortana : We beter have a look around." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00126', FALSE, NONE, 0.0, "", "Cortana : Hopefully we can find some way to get this Cartographer back online." );*/
							//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00127', FALSE, NONE, 0.0, "", "Cortana: If this Cartographer’s similar to the others we’ve used, there’s no telling what we could learn from it. Assuming we’re able to reactivate it." );
							//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00125', FALSE, NONE, 0.0, "", "Cortana : It’s probable that the Forerunners had ships docked here on Requiem. If so, restoring the Cartographer should tell us." );
							//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00126', FALSE, NONE, 0.0, "", "Cortana : The Covenant aren’t that smart. Whatever they’re after, chances are that Cartographer will tell us if we can find a way to reactivate it." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 //wake(f_map_complete);
				 //thread(m20_blip_terminal());
				 thread(m20_objective_2_nudge());
end
								

script dormant f_dialog_m20_blip_terminal()
dprint("f_dialog_m20_blip_terminal_locations");
				 
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BLIP_TERMINAL_LOCATIONS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_librarian_00106', FALSE, NONE, 0.0, "", "Cortana : I'm detecting power fluctuations in several locations. I'll put them up for you." );
					
									//wake(m20_blip_terminal_locations);
									dprint ("blipping both terminal locations now");
					
									dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cartographer_00126', FALSE, NONE, 0.0, "", "Cortana : Hopefully we can find some way to get this Cartographer back online." );
					l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );			
				 
				 
end

script dormant f_dialog_m20_mantle_approach()
dprint("f_dialog_m20_mantle_approach");

					SetNarrativeFlagOnLocalPlayers(13, TRUE);
					l_dlg_mantle_approach = dialog_start_foreground( "M20_MAP_BUTTON_03", l_dlg_mantle_approach, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    
								dialog_line_chief( l_dlg_mantle_approach, 0, (not b_cathedral_cut_scene_playing == TRUE), 'sound\dialog\mission\m20\m20_cathedral_mantle_00100', TRUE, NONE, 0.0, "", "Master Chief : What does it say?" );
								dialog_line_cortana( l_dlg_mantle_approach, 1, (not b_cathedral_cut_scene_playing == TRUE), 'sound\dialog\mission\m20\m20_cathedral_mantle_00101', TRUE, NONE, 0.0, "", "Cortana : Guardianship for all living things lies with those whose evolution is most complete." );		
								dialog_line_cortana( l_dlg_mantle_approach, 2, (not b_cathedral_cut_scene_playing == TRUE), 'sound\dialog\mission\m20\m20_cathedral_mantle_00102', TRUE, NONE, 0.0, "", "Cortana : The Mantle of responsibility shelters all." );
								dialog_line_cortana( l_dlg_mantle_approach, 3, (not b_cathedral_cut_scene_playing == TRUE), 'sound\dialog\mission\m20\m20_cathedral_mantle_00103', TRUE, NONE, 0.0, "", "Cortana : Very interesting." );
						dialog_line_chief( l_dlg_mantle_approach, 4, (not b_cathedral_cut_scene_playing == TRUE), 'sound\dialog\mission\m20\m20_cathedral_mantle_00104', TRUE, NONE, 0.0, "", "Master Chief : Maybe... but it won't get us home." );
			   	
				 l_dlg_mantle_approach = dialog_end( l_dlg_mantle_approach, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_librarian_pre()
dprint("f_dialog_m20_librarian_pre");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BLIP_LIBRARIAN_PRE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_librarian_00107', FALSE, NONE, 0.0, "", "Cortana : There's a terminal, center of the chamber. Try to access it." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );			
end


script dormant f_dialog_m20_Cathedral_Librarian_terminal()
dprint("f_dialog_m20_Cathedral_Librarian_terminal");
			

					l_dlg_cathedral_Librarian_terminal = dialog_start_foreground( "CATHEDRAL_LIBRARIAN_TERMINAL", l_dlg_cathedral_Librarian_terminal, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 1, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00109', TRUE, NONE, 0.0, "", "Cortana : It's alright." );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 2, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00110', TRUE, NONE, 0.0, "", "Cortana : This energy is actually a ferroelectic datafield." );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 3, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00111', TRUE, NONE, 0.0, "", "Cortana : Your shields are just cycling in response to the chamber's charge." );
						dialog_line_chief( l_dlg_cathedral_Librarian_terminal, 4, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00112', TRUE, NONE, 0.0, "", "Master Chief : Will it get the cartographer back online?" );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 5, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00113', TRUE, NONE, 0.0, "", "Cortana : Partially." );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 6, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00114', TRUE, NONE, 0.0, "", "Cortana : This type of processing system usually works in parallel." );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 7, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00115', TRUE, NONE, 0.0, "", "Cortana : We'll have to locate its twin." );
						dialog_line_chief( l_dlg_cathedral_Librarian_terminal, 8, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00116', TRUE, NONE, 0.0, "", "Master Chief : What was that?" );
						dialog_line_cortana( l_dlg_cathedral_Librarian_terminal, 9, (not b_second_terminal_active == TRUE), 'sound\dialog\mission\m20\m20_cathedral_librarian_00117', TRUE, NONE, 0.0, "", "Cortana : Your guess is as good as mine." );				 
						
					
					
				  l_dlg_cathedral_Librarian_terminal = dialog_end( l_dlg_cathedral_Librarian_terminal, TRUE, TRUE, "" );
	wake(f_dialog_m20_Cathedral_covenant_inside);
		b_first_core_complete = TRUE;

end
script dormant f_dialog_m20_Cathedral_covenant_inside()
dprint("f_dialog_m20_Cathedral_covenant_inside");
    sleep_until( volume_test_players(exit_core_01) or volume_test_players(exit_core_02), 1);

local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CATHEDRAL_COVENANT_INSIDE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_covenant_00100', TRUE, NONE, 0.0, "", "Cortana : The Covenant. They found a way inside." );
					
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m20_Cathedral_Librarian_terminal_01()
dprint("f_dialog_m20_Cathedral_Librarian_terminal_01");
	kill_script(m20_blip_terminal);
				sleep_forever(f_dialog_m20_blip_terminal);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "CATHEDRAL_LIBRARIAN_TERMINAL_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_librarian_00108', FALSE, NONE, 0.0, "", "Master Chief : What's it doing?" );
					
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end


script dormant f_dialog_m20_sentinel_intro()
dprint("f_dialog_m20_sentinel_intro(");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_MAP_SENTINEL_INTRO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00104', FALSE, NONE, 0.0, "", "Master Chief : Sentinels." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_entrance_00105', FALSE, NONE, 0.0, "", "Cortana : I wondered when they'd show up." );
								//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_chatter_00115', FALSE, NONE, 0.0, "", "Cortana : If they're like the ones on the Halos, they should be programmed to only respond if provoked." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_console_nudge()
dprint("f_dialog_m20_console_nudge");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_MAP_CONSOLE_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_chatter_00112', FALSE, NONE, 0.0, "", "Cortana: There. Chief: a console, in the back." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_Cathedral_didact_terminal_pre_use()
dprint("f_dialog_m20_Cathedral_didact_terminal_pre_use");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_DIDACT_TERMINAL_PRE_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00119', FALSE, NONE, 0.0, "", "Cortana : That's the other datafield chamber." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00120', FALSE, NONE, 0.0, "", "Cortana : Go on. Activate the terminal." );								
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
	
		
script static void f_dialog_m20_Cathedral_didact_terminal_02()
dprint("f_dialog_m60_marines_bunker_01");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
						dialog_end_interrupt(l_dlg_cathedral_Librarian_terminal);
						b_second_terminal_active = TRUE;
						sleep_s(2);
            	
                l_dialog_id = dialog_start_background( "MARINES_BUNKER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.0 );
                hud_play_pip_from_tag( "bink\campaign\M20_E_60" );
                start_radio_transmission( "unidentified_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00122_soundstory', FALSE, NONE, 0.0, "", "Del Rio : UNSC Infinity to Fleetcom Actual. ", TRUE);
								dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00123', FALSE, NONE, 0.0, "", "Del Rio : We've got an issue with relay Ursa Minor 8-8-3.", TRUE);
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00124', FALSE, NONE, 0.0, "", "Del Rio : Can you find us a clearer patch?", TRUE);
								
								dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00129', FALSE, NONE, 0.0, "", "Fleetcom Watch : This is Fleetcom, Infinity.", TRUE);
								dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00130', FALSE, NONE, 0.0, "", "Fleetcom Watch : Moving comm to another slipspace relay…", TRUE);
								end_radio_transmission();
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
   

script dormant f_dialog_m20_Cathedral_didact_terminal()
dprint("f_dialog_m20_Cathedral_didact_terminal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					sleep_s(4);
					if ( (l_dlg_cathedral_Librarian_terminal != DEF_DIALOG_ID_NONE()) and 
					     (l_dlg_cathedral_Librarian_terminal != DEF_DIALOG_ID_INVALID()) and
					     (dialog_foreground_current_get() == l_dlg_cathedral_Librarian_terminal)) then
							dprint("Killing librarian terminal");
							kill_thread(l_dlg_cathedral_Librarian_terminal);
							sleep(1);
							b_cortana_is_speaking = FALSE;
							b_chief_is_speaking = FALSE;
					end
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_DIDACT_TERMINAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_INTERRUPT(), FALSE, "", 0.25 );    
								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00121', FALSE, NONE, 0.0, "", "Cortana : It's OK! It's only temporary!" );
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00125', FALSE, NONE, 0.0, "", "Master Chief : Is that the same signal--" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00126', FALSE, NONE, 0.0, "", "Cortana : YES!" );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00127', FALSE, NONE, 0.0, "", "Cortana : Mayday mayday mayday!" );
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00128', FALSE, NONE, 0.0, "", "Cortana : UNSC A.I. Cortahna to Infinity, please respond!" );								
								sleep_s(2);
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00131', FALSE, NONE, 0.0, "", "Cortana : No response, but from the strength of that signal, the Infinity has to be close by!" );
								sleep_s(1);
								dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00132', FALSE, NONE, 0.0, "", "Cortana : The Cartographer should be back online." );
								dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00133', FALSE, NONE, 0.0, "", "Cortana : We may be able to use it to track the ship's location!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				wake(m20_active_cartographer);
end



script dormant f_dialog_m20_Cathedral_didact_terminal_post_use()
dprint("f_dialog_m20_Cathedral_didact_terminal_post_use");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_DIDACT_TERMINAL_POST_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00134', FALSE, NONE, 0.0, "", "Cortana : Chief, come on!" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_didact_00135', FALSE, NONE, 0.0, "", "Cortana : If Infinity is on this planet, we just found our ride home! Get to the Cartographer. " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_cartographer_cutscene_pre_use()
dprint("f_dialog_m20_cartographer_cutscene_pre_use");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				l_dialog_id = dialog_start_foreground( "M20_CARTOGRAPHER_PRE_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_cutscene_pre_use_00100', FALSE, NONE, 0.0, "", "Cortana : Good, it's back up. " );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_cutscene_pre_use_00101', FALSE, NONE, 0.0, "", "Cortana : Insert me into the console." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_cartographer_finish_covenant()
dprint("f_dialog_m20_cartographer_finish_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				l_dialog_id = dialog_start_foreground( "M20_CARTOGRAPHER_FINISH_COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_Cathedral_didact_terminal_post_use_00103', FALSE, NONE, 0.0, "", "Cortana : We can’t give them access to the Cartographer. " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script dormant f_dialog_m20_Cathedral_cutscene_post_use()
dprint("f_dialog_m20_Cathedral_cutscene_post_use");
wake(m20_didact_title);
	sleep_s(1.5);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_CATHEDRAL_CUTSCENE_POST_USE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_Cathedral_cutscene_post_use_00101', FALSE, NONE, 0.0, "", "Cortana: Let's get to that Terminus and find Infinity." );
								sleep_s(2);
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_Cathedral_shieldroom_00100', FALSE, NONE, 0.0, "", "Master Chief: What do you know about Infinity?" );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_Cathedral_shieldroom_00102', FALSE, NONE, 0.0, "", "Cortana: Not much. She was supposed to be massive, but the project was only in prototype when we left." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				// wake(f_dialog_m20_shieldroom_blocked);
end

script dormant f_dialog_m20_shieldroom_blocked()
dprint("f_dialog_m20_shieldroom_blocked");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_SHIELDROOM_BLOCKED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00103', FALSE, NONE, 0.0, "", "Cortana : If I was paranoid, I'd think someone didn't want us to leave." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00104', FALSE, NONE, 0.0, "", "Cortana : Well, the only way out is through." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00105', FALSE, NONE, 0.0, "", "Cortana : See if you can find a way to deactivate this shielding." );
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00106', FALSE, NONE, 0.0, "", "Cortana : Hold on. This Forerunner tech uses adaptive mechanics." );
								dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00107', FALSE, NONE, 0.0, "", "Cortana : Pick that up for me?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_shieldroom_armor()
dprint("f_dialog_m20_shieldroom_armor");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_SHIELDROOM_ARMOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00108', FALSE, NONE, 0.0, "", "Cortana : I think I can do something with this." );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00109', FALSE, NONE, 0.0, "", "Cortana : There." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00110', FALSE, NONE, 0.0, "", "Cortana : Try toggling your suit enhancements." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_shieldroom_activate()
dprint("f_dialog_m20_shieldroom_activate");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_SHIELDROOM_ACTVIATE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00111', FALSE, NONE, 0.0, "", "Master Chief : That could come in handy." );
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00112', FALSE, NONE, 0.0, "", "Cortana : Don't say I never gave you anything." );	
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_cathedral_shieldroom_00113', FALSE, NONE, 0.0, "", "Cortana : Now let's get to that Terminus and find Infinity." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_bridge_elevator()
		if not 
			volume_test_players (tv_bridge_awake) or
			object_get_health (sq_bridge_start_jackals) < 1 or
			object_get_health (sq_bridge_start_grunts) < 1 or
			object_get_health (sq_bridge_start_grunt_patrol) < 1
		then
			dprint("f_dialog_m20_bridge_elevator");
			local long l_dialog_id = DEF_DIALOG_ID_NONE();
				if( b_explorable_terminal_3 == FALSE ) then
					//Chief and Cortana DO NOT know the Covenant orders to take holy sites and stop the Chief.
					l_dialog_id = dialog_start_foreground( "M20_BRIDGE_ELEVATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_bridge_elevator_00100', FALSE, NONE, 0.0, "", "Cortana: Scouts, fortifying the bridge below. Stay sharp." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				else
		//Chief and Cortana DO know the Covenant orders to take holy sites and stop the Chief.
				l_dialog_id = dialog_start_foreground( "M20_BRIDGE_ELEVATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_bridge_elevator_00101', FALSE, NONE, 0.0, "", "Cortana: For someone who sat idly for three years, these Covenant aren't any wasting time making themselves at home." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				end 
		end

end

script dormant f_dialog_m20_fall_volume()
dprint("f_dialog_m20_fall_volume");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_FALL_VOLUME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_bridge_elevator_00103', FALSE, NONE, 0.0, "", "Cortana: Would it have killed you to use the elevator?");
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_banshees()
dprint("f_dialog_m20_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_bridge_chatter_00100', FALSE, NONE, 0.0, "", "Cortana : Banshees - scouting the bridge. " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_banshees_spot()
dprint("f_dialog_m20_banshees_spot");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BANSHEES_SPOT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_bridge_chatter_00101', FALSE, NONE, 0.0, "", "Cortana : They’ve spotted us, Chief! Take those Banshees out, pronto! " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_M20_bridge_end()
dprint("f_dialog_M20_bridge_end");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BRIDGE_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00106', FALSE, NONE, 0.0, "", "Cortana : AAAH!!  CHIEF!!!!" );
					sleep_s(3);
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00107', FALSE, NONE, 0.0, "", "Cortana : DON'T... JUST... LOOK AT THEM... SHOOT!!" );
					sleep_s(3);
					dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00108', FALSE, NONE, 0.0, "", "Cortana : Chief... PLEASE!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_M20_bridge_post()
dprint("f_dialog_M20_bridge_post");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_BRIDGE_POST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00109', FALSE, NONE, 0.0, "", "Master Chief : What was it doing?" );
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00110', FALSE, NONE, 0.0, "", "Cortana : It was using an intrusion protocol to attack your suit's neural link." );
					dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_bridge_end_00111', FALSE, NONE, 0.0, "", "Cortana : It wasn't expecting anyone in here to put up a fight." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
					


script dormant f_dialog_m20_courtyard_covenant()
dprint("f_dialog_m20_courtyard_covenant");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_COURTYARD_COVENANT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_courtyard_1stfl_00100', FALSE, NONE, 0.0, "", "Cortana: Chief, the Covenant 'nets are going crazy." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_courtyard_1stfl_00101', FALSE, NONE, 0.0, "", "Cortana: They're ordering all units to converge on the tower." );
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_courtyard_1stfl_00102', FALSE, NONE, 0.0, "", "Cortana: I guess we got their attention." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_courtyard_1stfl()
dprint("f_dialog_m20_courtyard_1stfl");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_COURTYARD_1STFL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_courtyard_1stfl_00103', FALSE, NONE, 0.0, "", "Cortana: We're about to have our hands full." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_courtyard_1stfl_00104', FALSE, NONE, 0.0, "", "Cortana: The Elites just issued a general order - they're moving all ground teams to secure the tower entrance above us." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_last_stand()
dprint("f_dialog_m20_last_stand");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			l_dialog_id = dialog_start_foreground( "M20_LAST_STAND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00108', FALSE, NONE, 0.0, "", "Cortana : The Sentinels were trying to keep the Covenant out." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_door_approach()
dprint("f_dialog_m20_door_approach");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			l_dialog_id = dialog_start_foreground( "M20_DOOR_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00109', FALSE, NONE, 0.0, "", "Cortana : It's locked from the inside" );
				//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00110', FALSE, NONE, 0.0, "", "Cortana : Put me in that console and I'll try to open it." );
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00111', FALSE, NONE, 0.0, "", "Cortana : Hunters! Hold them off til I can get us inside!" );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

/*script dormant f_dialog_m20_hunters_dead()
dprint("f_dialog_m20_hunters_dead");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
			l_dialog_id = dialog_start_foreground( "M20_HUNTERS_DEAD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00112', FALSE, NONE, 0.0, "", "Cortana : We're in! " );
					dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_last_stand_00113', FALSE, NONE, 0.0, "", "Cortana : The hatch is unlocked. Come pick me up." );
			l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end*/



script dormant f_dialog_m20_atrium_ent()
	dprint("f_dialog_m20_atrium_ent");
	sleep_forever(m20_objective_3_nudge);
		
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M20_ATRIUM_ENT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    														

	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_atrium_00100', FALSE, NONE, 0.0, "", "Cortana : While you were busy, I managed to clear up another transmission from Infinity:" );	

	start_radio_transmission( "unidentified_transmission_name" );
	hud_play_pip_from_tag( "bink\campaign\M20_F_60" );

	dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_atrium_00101', FALSE, NONE, 0.0, "", "Del Rio : Forerunner shield-- coordinates---artifact--", TRUE);
	end_radio_transmission();

	dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m20\m20_atrium_00102', FALSE, NONE, 0.0, "", "Master Chief : Sounded like he said 'artifact'." );
	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m20\m20_atrium_00103', FALSE, NONE, 0.0, "", "Cortana : I wonder if it's related to whatever the Covenant are after." );
	dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m20\m20_atrium_00104', FALSE, NONE, 0.0, "", "Master Chief : Where's the Terminus?" );
	dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m20\m20_atrium_00105', FALSE, NONE, 0.0, "", "Cortana : The map placed it at the top of the tower." );
	//dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m20\m20_atrium_00106', FALSE, NONE, 0.0, "", "Master Chief : Then let's get up there." );
	//dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m20\m20_atrium_00107', FALSE, NONE, 0.0, "", "Master Chief : Infinity may not stay in the planet's core forever." );
	
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
		
end

script dormant f_dialog_m20_atrium_waypoint()
dprint("f_dialog_m20_atrium_waypoint");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_ATRIUM_WAYPOINT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    								
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m20\m20_atrium_00108', FALSE, NONE, 0.0, "", "Cortana : Chief, try the top of the ramp. " );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m20\m20_atrium_00109', FALSE, NONE, 0.0, "", "Cortana : I think there's a lift up there." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_phantom_on_approach()
dprint("f_dialog_m20_phantom_on_approach");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_PHANTOM_ON_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00107', FALSE, NONE, 0.0, "", "Cortana : Phantom on approach!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m20_phantom_on_approach_02()
dprint("f_dialog_m20_phantom_on_approach_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M20_PHANTOM_ON_APPROACH_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00107', FALSE, NONE, 0.0, "", "Cortana : Phantom on approach!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

script static void f_dialog_m20_objective_1()
dprint( "f_dialog_m20_objective_1" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_1_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, we need to find a working ship if we want to get off this planet." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_1_complete), 'sound\dialog\mission\m20\m20_crater_prompt_00100', FALSE, NONE, 0.0, "", "Cortana : Covenant chatter’s increasing – we should get moving before they come looking for us." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_1_complete), 'sound\dialog\mission\m20\m20_crater_prompt_00123', FALSE, NONE, 0.0, "", "Cortana : We should really get looking for a way offworld. The sooner, the better." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 4 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 0, (not b_objective_1_complete), 'sound\dialog\mission\m20\m20_crater_prompt_00120', FALSE, NONE, 0.0, "", "Cortana : Chief, if you’re serious about getting us home, we should start." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end

script static void f_dialog_m20_objective_2()
dprint( "f_dialog_m20_objective_2" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_2_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00101', FALSE, NONE, 0.0, "", "Cortana: Chief, we need to restore power to that cartographer." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_2_complete), 'sound\dialog\mission\m20\m20_cartographer_00128', FALSE, NONE, 0.0, "", "Cortana: Its probable that the Forerunners had ships docked here on Requiem. If so, restoring the Cartographer should tell us." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_2_complete), 'sound\dialog\mission\m20\m20_cartographer_00127', FALSE, NONE, 0.0, "", "Cortana: The Covenant aren’t that smart. Whatever they’re after, chances are that Cartographer will tell us if we can find a way to reactivate it." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 4 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_2_complete), 'sound\dialog\mission\m20\m20_cartographer_00129', FALSE, NONE, 0.0, "", "Cortana: If this Cartographer’s similar to the others we’ve used, there’s no telling what we could learn from it. Assuming we’re able to reactivate it." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end


script static void f_dialog_m20_objective_3()
dprint( "f_dialog_m20_objective_3" );
	local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);

	if s_random == 1 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00110', FALSE, NONE, 0.0, "", "Cortana: I’m detecting a lot of Covenant activity around the Terminus’s location. We should probably get there before it gets any more popular." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 2 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00111', FALSE, NONE, 0.0, "", "Cortana: If Infinity really is in the planet’s core, then that Terminus is all that’s between us and home. What are you waiting for?" );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 3 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00112', FALSE, NONE, 0.0, "", "Cortana: Keep moving towards the Terminus, Chief." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	elseif s_random == 4 then
		l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m20\m20_objective_nudge_00113', FALSE, NONE, 0.0, "", "Cortana: You do want to find Infinity and get off Requiem, don’t you? Let’s go." );
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );
	end


end