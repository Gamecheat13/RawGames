//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m30_dialog
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// DIALOG
// -------------------------------------------------------------------------------------------------
// DEFINES


// VARIABLES

global boolean b_first_time_dialog_over = FALSE; //this is to trigger the button press the first time through, once they're finished talking.
global boolean b_cryptum_approach_dialog_complete = FALSE;  //this is to tell the player that cortana is finished gabbing as they approach the Cryptum button.
global long l_dlg_m30_plyon_1_lightbridge = DEF_DIALOG_ID_NONE();


// dialog ID variables






// --- END

script dormant f_dialog_m30_callout_banshees_fast_low()
dprint("f_dialog_callout_banshees_fast_low");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES_FAST_LOW", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00176', FALSE, NONE, 0.0, "", "Cortana : Banshees. Fast and low." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_M30_observatory_first()
	dprint("f_dialog_M30_observatory_first");
	b_first_time_through = TRUE;;
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_OBSERVATORY_FIRST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0 );      
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_cryptum_into_00102', FALSE, NONE, 0.0, "", "Master Chief : What were those things?" );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_cryptum_into_00103', FALSE, NONE, 0.0, "", "Cortana : Some sort of advanced defense A.I's." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_cryptum_into_00104', FALSE, NONE, 0.0, "", "Cortana : Related to the Sentinels, I'm guessing, but it's hard to say without a closer look.  " );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\M30_cryptum_into_00107', FALSE, NONE, 0.0, "", "Cortana : C'mon, let's figure out where that transit system dumped us.  " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialogue_m30_insert_into()
	dprint("f_dialogue_m30_insert_into");

	l_dlg_insert_into = dialog_start_foreground( "M30_INSERT_INTO", l_dlg_insert_into, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	dialog_line_cortana( l_dlg_insert_into, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00195', FALSE, NONE, 0.0, "", "Cortana : Put me in the console!" );
	l_dlg_insert_into = dialog_end( l_dlg_insert_into, TRUE, TRUE, "" );
				 
	b_first_time_dialog_over = TRUE;
end


script dormant f_dialog_m30_pat_pickup()
dprint("f_dialog_m30_pat_pickup");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PAT_PICKUP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
                dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pat_00100', FALSE, NONE, 0.0, "", "Cortana : Racks of deployable defense turrets?" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pat_00200', FALSE, NONE, 0.0, "", "Cortana : What exactly were the Forerunners expecting here?" );         
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_m30_pylonone_arrival()
dprint("f_dialog_m30_pylonone_arrival");
		
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_ARRIVAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_arrival_00100', FALSE, NONE, 0.0, "", "Cortana : Have portal, will travel." );
								dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_arrival_00101', FALSE, NONE, 0.0, "", "Master Chief : This is the first pylon?" );
								hud_play_pip_from_tag( "bink\campaign\M30_A_60" );
								dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylonone_arrival_00102', FALSE, NONE, 0.0, "", "Cortana : Negative - this is close as I could get us." );
								dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylonone_arrival_00103', FALSE, NONE, 0.0, "", "Cortana : Hope you don't mind hoofing it a little." );                
								
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script dormant f_dialog_M30_Console_Button_one()
dprint("f_dialog_M30_Console_Button_one");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					l_dialog_id = dialog_start_foreground( "M30_CONSOLE_BUTTON_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00108', FALSE, NONE, 0.0, "", "Cortana : This is Requiem's core, alright, but Infinity is most certainly not here." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00109', FALSE, NONE, 0.0, "", "Cortana : That satellite in the center is amplifying the ship’s broadcasts like a relay." );
						dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00110', FALSE, NONE, 0.0, "", "Master Chief : Maybe we can us it to respond to them." );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00111', FALSE, NONE, 0.0, "", "Cortana : Perhaps." );
						dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00112', FALSE, NONE, 0.0, "", "Cortana : Those beams coming off of it are creating the interference we’ve been experiencing." );
						dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00113', FALSE, NONE, 0.0, "", "Cortana : We’d have to take them out to contact Infinity." );
						dialog_line_chief( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00106', FALSE, NONE, 0.0, "", "Master Chief : Can you get us there?" );
						dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m30\m30_console_button_one_00107', FALSE, NONE, 0.0, "", "Cortana : Opening a gate to the first beam pylon. Pull me and let's go." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_M30_gargoyle_tease()
dprint("f_dialog_M30_gargoyle_tease");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_GARGOYLE_TEASE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_gargoyle_tease_00102', FALSE, NONE, 0.0, "", "Cortana : Contacts!" );
						//	dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_gargoyle_tease_00101', FALSE, NONE, 0.0, "", "Master Chief : Where's it coming from?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );



end





script dormant f_dialog_m30_first_pawn_fight_start()
dprint("f_dialog_m30_first_pawn_fight_start");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_FIRST_PAWN_FIGHT_START", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_first_pawn_fight_start_00100', FALSE, NONE, 0.0, "", "Cortana : AND they're back! " );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_first_pawn_fight_start_00101', FALSE, NONE, 0.0, "", "Cortana : Coming down the walls!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	

end


script dormant f_dialog_M30_knight_post()
dprint("f_dialog_M30_knight_post");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_GRASSY_HILL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_knight_vignette_00101', FALSE, NONE, 0.0, "", "Well he's just a ray of sunshine, isn't he." );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_knight_vignette_00103b', FALSE, NONE, 0.0, "", "From that peek under the hood, I'd say these constructs must be mimetic in nature." );
							
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end


script dormant f_dialog_M30_grassy_hills()
dprint("f_dialog_M30_grassy_hill");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_GRASSY_HILL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_knight_vignette_00104', FALSE, NONE, 0.0, "", "More of them?" );
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_knight_vignette_00106', FALSE, NONE, 0.0, "", "Similar phasing activity at the edge of our sensors. We're about to get busy." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_M30_grassy_hills_second()
dprint("f_dialog_M30_grassy_hill_second");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_GRASSY_HILL_SECOND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00119', FALSE, NONE, 0.0, "", "Cortana : Hostiles!" );
							//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00103', FALSE, NONE, 0.0, "", "Cortana : Incoming!" );
						//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00104', FALSE, NONE, 0.0, "", "Cortana : It's spawning some sort of drone!" );
					//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00105', FALSE, NONE, 0.0, "", "Cortana : Eyes up! In the air!" );
						//	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00106', FALSE, NONE, 0.0, "", "Cortana : Because bad guys weren't bad enough without giving birth to each other?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				// sleep_s(2);
				// wake(f_dialog_M30_grassy_hills_third);
end

script dormant f_dialog_m30_knight_resurrection()
dprint("f_dialog_m30_knight_resurrection");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_KNIGHT_RESURRECTION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_grassy_hills_start_00110', FALSE, NONE, 0.0, "", "Cortana : Is he bringing the big one back to life???" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script dormant f_dialog_m30_playing_catch()
dprint("f_dialog_m30_playing_catch");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_PLAYING_CATCH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_grassy_hills_start_00117', FALSE, NONE, 0.0, "", "Cortana : Careful! It caught the grenade!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

/*script dormant f_dialog_M30_grassy_hills_third()
dprint("f_dialog_M30_grassy_hills_third");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_GRASSY_HILL_THIRD", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00107', FALSE, NONE, 0.0, "", "Cortana : Up on the cliffs! Watching us!" );
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00108', FALSE, NONE, 0.0, "", "Master Chief : Sentinels?" );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_grassy_hills_start_00109', FALSE, NONE, 0.0, "", "Cortana : Negative! Something else!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

				 
end*/



script dormant f_dialog_m30_plyon_1_lightbridge()
dprint("f_dialog_m30_plyon_1_lightbridge");


				
					l_dlg_m30_plyon_1_lightbridge = dialog_start_foreground( "M30_PYLON_1_LIGHTBRIDGE", l_dlg_m30_plyon_1_lightbridge, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    
									dialog_line_chief( l_dlg_m30_plyon_1_lightbridge, 0, TRUE, 'sound\dialog\mission\m30\m30_prepawn_00100', FALSE, NONE, 0.0, "", "Master Chief : Those weren't the same things we saw in the Terminus." );
									dialog_line_cortana( l_dlg_m30_plyon_1_lightbridge, 1, TRUE, 'sound\dialog\mission\m30\m30_pylon_1_lightbridge_00100', FALSE, NONE, 0.0, "", "Cortana : Similar cortical footprint as the tower A.I's." );
									dialog_line_cortana( l_dlg_m30_plyon_1_lightbridge, 2, TRUE, 'sound\dialog\mission\m30\m30_pylon_1_lightbridge_00101', FALSE, NONE, 0.0, "", "Cortana : They're connected, alright." );
							//		dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylon_1_lightbridge_00102', FALSE, NONE, 0.0, "", "Master Chief : Anything else?" );
							//		dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylon_1_lightbridge_00103', FALSE, NONE, 0.0, "", "Cortana : From the way they crawled down those walls?" );
						//			dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_pylon_1_lightbridge_00104', FALSE, NONE, 0.0, "", "Cortana : I'd say they've been here a lot longer than we have." );
				 l_dlg_m30_plyon_1_lightbridge = dialog_end( l_dlg_m30_plyon_1_lightbridge, TRUE, TRUE, "" );
				 
end


script dormant f_dialog_M30_hallway_1_enter()
dprint("f_dialog_M30_hallway_1_enter");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_HALLWAY_1_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_hallway_1_enter_00100', FALSE, NONE, 0.0, "", "Cortana : I've discovered something interesting about our new friends. " );
						hud_play_pip_from_tag( "bink\campaign\M30_B_60" );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_hallway_1_enter_00101a', FALSE, NONE, 0.0, "", "Cortana : When the big ones explode, that momentary flash we're seeing is actually a data purge." );
						dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_hallway_1_enter_00102', FALSE, NONE, 0.0, "", "Master Chief : Can you tap into it?" );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_hallway_1_enter_00106', FALSE, NONE, 0.0, "", "Cortana : So far, I’ve pulled multiple strings referring to the big ones as Promethean Knights." );
						dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_hallway_1_enter_00107', FALSE, NONE, 0.0, "", "Cortana : Beyond that, though, things get a bit dense." );
						
					//	dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\M30_hallway_1_enter_00108', FALSE, NONE, 0.0, "", "Master Chief : Anything on those crawlers or the things that were watching us?" );
					//	dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\M30_hallway_1_enter_00109', FALSE, NONE, 0.0, "", "Cortana : Not yet, but I’ll let you know when I’ve dug in a little more." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end


script dormant f_dialog_m20_callout_ss()
dprint("f_dialog_callout_hostiles");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOSTILES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m20_callout_taking_fire()
dprint("f_dialog_callout_taking_fire");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TAKING_FIRE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00180', FALSE, NONE, 0.0, "", "Cortana : Taking fire." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_canyons_1_rock_hallway()
dprint("f_dialog_m30_canyons_1_rock_hallway");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_CANYONS_1_ROCK_HALLWAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
									hud_play_pip_from_tag( "bink\campaign\M30_C1_60" );
									thread(f_dialog_play_pip_m30_C_subtitles());
									start_radio_transmission( "unidentified_transmission_name" );

									sleep_s(1);
									dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_canyons_1_rock_hallway_00101', FALSE, NONE, 0.0, "", "Cortana : The relay interference is increasing. " );
									dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_canyons_1_rock_hallway_00102', FALSE, NONE, 0.0, "", "Cortana : We must be getting close to the Pylon." );
									end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end

script static void f_dialog_play_pip_m30_C_subtitles()
	dialog_play_subtitle('sound\dialog\mission\m30\m30_delrio_transmission_full_00101');
end

script dormant f_dialog_m30_pylonone_hallwaytwo_enter()
	dprint("f_dialog_m30_pylonone_hallwaytwo_enter");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_PYLONONE_HALLWAYTWO_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	
	//		dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00100', FALSE, NONE, 0.0, "", "Master Chief : Is it just me, or are we seeing more of these things the closer we get to that pylon?" );
	//		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00101', FALSE, NONE, 0.0, "", "Cortana : It’s possible the Prometheans don’t want us using their relay--" );
	
	sleep_s(2);

	hud_set_rampancy_intensity(player0, 0.4);
	hud_set_rampancy_intensity(player1, 0.4);
	hud_set_rampancy_intensity(player2, 0.4);
	hud_set_rampancy_intensity(player3, 0.4);

  	sleep_s(3);

	dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00102', FALSE, NONE, 0.0, "", "Master Chief : What’s that distortion?" );

	hud_set_rampancy_intensity(player0, 0);
  	hud_set_rampancy_intensity(player1, 0);
  	hud_set_rampancy_intensity(player2, 0);
  	hud_set_rampancy_intensity(player3, 0);
			
	hud_play_pip_from_tag( bink\campaign\M30_D_60 );
	thread(f_dialog_play_pip_m30_d_subtitles());

	sleep_s(3);
	
	hud_set_rampancy_intensity(player0, 0.2);
	hud_set_rampancy_intensity(player1, 0.2);
	hud_set_rampancy_intensity(player2, 0.2);
	hud_set_rampancy_intensity(player3, 0.2);
	
	sleep_s(3);
	hud_set_rampancy_intensity(player0, 0);
	hud_set_rampancy_intensity(player1, 0);
	hud_set_rampancy_intensity(player2, 0);
	hud_set_rampancy_intensity(player3, 0);
	
	sleep_s(16);
	
	//		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00103', FALSE, NONE, 0.0, "", "Cortana : That’s...me. Something about moving through those portals is increasing the load on my systems." );
	//		dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00104', FALSE, NONE, 0.0, "", "Master Chief : Are you-- are you going to be OK?" );
	//		dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00105', FALSE, NONE, 0.0, "", "Cortana : Don't worry." );
		//	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00106', FALSE, NONE, 0.0, "", "Cortana : I’ve held off rampancy this long, haven’t I?" );
	//		dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_hallway_2_enter_00107', FALSE, NONE, 0.0, "", "Master Chief : Who said I was worried?" );
					
		
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_play_pip_m30_d_subtitles()
	sleep(90);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_hallway_2_enter_00103');
	sleep(9);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_hallway_2_enter_00104');
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_hallway_2_enter_00105');
	sleep(20);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_hallway_2_enter_00106');
end

script dormant f_dialog_m30_pylonone_reveal()
dprint("f_dialog_m30_pylonone_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_REVEAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pyloneone_reveal_00102', FALSE, NONE, 0.0, "", "Cortana : That's the target, but looks like the entrance is shielded." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pyloneone_reveal_00103', FALSE, NONE, 0.0, "", "Cortana : Not like that's stopped you before." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pyloneone_reveal_00104', FALSE, NONE, 0.0, "", "Cortana : Let's figure out how to take it down." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m30_plyonone_core_close()
dprint("f_dialog_m30_plyonone_core_close");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
				 b_one_core_down = TRUE;
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_CORE_CLOSE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_one_00100', FALSE, NONE, 0.0, "", "Cortana : One of the shield's power cores. Take it out." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end




script dormant f_dialog_m30_plyonone_core_one()
dprint("f_dialog_m30_plyonone_core_one");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_CORE_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_one_00103', FALSE, NONE, 0.0, "", "Cortana : I read two more cores on our level." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_one_00104', FALSE, NONE, 0.0, "", "Cortana : Hit them before you climb all the way up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m30_plyonone_core_two()
dprint("f_dialog_m30_plyonone_core_two");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 b_two_core_down = TRUE;
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_CORE_TWO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    	
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_two_00100', FALSE, NONE, 0.0, "", "Cortana : Well done, Chief. One to go." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_pylonone_nocores_down()
dprint("f_dialog_m30_pylonone_nocores_down");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_NOCORES_DOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    			
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00100', FALSE, NONE, 0.0, "", "Cortana : The Prometheans must have activated the pylon's security protocols." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00101', FALSE, NONE, 0.0, "", "Cortana : I'm tracking three power sources below. Let's see what we can do about them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_pylonone_nocores_down_2()
dprint("f_dialog_m30_pylonone_nocores_down_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 l_dialog_id = dialog_start_foreground( "M30_PYLONONE_NOCORES_DOWN_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );      				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00103', FALSE, NONE, 0.0, "", "Cortana : Wishing's not going to make it happen, Chief. Take out those power cores!" );
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dialog_M30_pylonone_nocores_down_3()
dprint("f_dialog_M30_pylonone_nocores_down_3");

local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_NOCORES_DOWN_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00102', FALSE, NONE, 0.0, "", "Cortana : This shield's not going anywhere until those power cores are all offline." );
							
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end


script dormant f_dialog_m30_pylonone_onecoredown()
dprint("f_dialog_m30_pylonone_onecoredown");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_ONECOREDOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00104', FALSE, NONE, 0.0, "", "Cortana : Looks like one core wasn't enough. We'd better take care of those other two as well." );
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dialog_m30_pylonone_twocoredown()
dprint("f_dialog_m30_pylonone_twocoredown");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_TWOCOREDOWN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
					  	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00105', FALSE, NONE, 0.0, "", "Cortana : Shield's still up. Well, you know what they say: third time's the charm.." );
							//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00106', FALSE, NONE, 0.0, "", "Cortana : Let's get that last power core down so we can get upstairs..");
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_pylonone_twocoredown_2()
dprint("f_dialog_m30_pylonone_twocoredown");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_TWOCOREDOWN_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
					  	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_bridgetoelevator_00106', FALSE, NONE, 0.0, "", "Cortana : Let's get that last power core down so we can get upstairs.");
							
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m30_pylonone_core_three()
dprint("f_dialog_m30_pylonone_core_three");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_CORE_THREE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00100', FALSE, NONE, 0.0, "", "Cortana : Great. That's all the cores. Head for the top of the pylon." );
					l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

				
end

script static void f_dialog_play_pip_m30_e_subtitles()
	dialog_play_subtitle('sound\dialog\mission\m30\m30_delrio_transmission_full_00102');
end

script dormant f_dialog_m30_start_ramp_enter()
	dprint("f_dialog_m30_start_ramp_enter");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_START_RAMP_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00104', FALSE, NONE, 0.0, "", "Cortana : Chief, look at this:" );
						
						hud_play_pip_from_tag( "bink\campaign\M30_E_60" );
						thread(f_dialog_play_pip_m30_e_subtitles());
						
						start_radio_transmission( "delrio_transmission_name" );
						//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_delrio_transmission_full_00102', FALSE, NONE, 0.0, "", "Del Rio :  [we're ap]proaching a la[rge cel]estial bod[y of F]orerunner ori[gin. The pla]netoid's metallic", TRUE);
						sleep_s(2);
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00106', FALSE, NONE, 0.0, "", "Cortana : That’s Requiem." );
						end_radio_transmission();
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00107', FALSE, NONE, 0.0, "", "Cortana : They’re not inside at all - they’re moving into orbit." );
						
						//dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00108', FALSE, NONE, 0.0, "", "Master Chief : Can you respond?" );
						//dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_pylonone_core_three_00109', FALSE, NONE, 0.0, "", "Cortana : Not until we get these beams down." );
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_pylonone_elevator_ride()
	dprint("f_dialog_m30_pylonone_elevator_ride");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_PYLONONE_ELEVATOR_RIDE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	
	hud_play_pip_from_tag( "bink\campaign\M30_F_60" );
	thread(f_dialog_play_pip_m30_f_subtitles());
						
	start_radio_transmission( "delrio_transmission_name" );
					
						sleep_s(5.5);
	
	//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00100', FALSE, NONE, 0.0, "", "Del Rio : Captain Andrew Del Rio hailing survivors of the (garbled) Forward Unto Dawn", TRUE);
	end_radio_transmission();
						
	
	dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00101', FALSE, NONE, 0.0, "", "Master Chief : Did he say Forward Unto Dawn?" );
	dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00102', FALSE, NONE, 0.0, "", "Cortana : They must have intercepted our distress beacon!" );
	dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00103', FALSE, NONE, 0.0, "", "Master Chief : The beacon was pulled into Requiem with us." );
	dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00104', FALSE, NONE, 0.0, "", "Master Chief : If they try to follow it…" );
	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00110', FALSE, NONE, 0.0, "", "Cortana : ...they’ll get caught in gravity well." );
  	dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_pylonone_elevator_ride_00107', FALSE, NONE, 0.0, "", "Cortana: I'll keep trying to warn them; you just get that beam down." );
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_play_pip_m30_f_subtitles()
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylonone_elevator_ride_00100');
end

script dormant f_dialog_M30_pylonone_top_enter()
		dprint("f_dialog_M30_pylonone_top_enter");
		local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_TOP_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylonone_elevator_ride_00108', FALSE, NONE, 0.0, "", "Cortana : See if you can disable the beam mechanism." );
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );


end

script dormant f_dialog_m30_pylonone_end()
dprint("f_dialog_m30_pylonone_end");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONONE_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylonone_end_00108', FALSE, NONE, 0.0, "", "Cortana : It’s working - the signal from the relay is starting to clear up." );
						start_radio_transmission( "delrio_transmission_name" );
						dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylonone_end_00109', FALSE, NONE, 0.0, "", "Del Rio : eetcom Actual. We’ve detected a UNSC beacon coming from somewhere INSIDE the planet", TRUE);
						end_radio_transmission();
						dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylonone_end_00110', FALSE, NONE, 0.0, "", "Master Chief : They haven’t hit the gravity well yet." );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylonone_end_00111', FALSE, NONE, 0.0, "", "Cortana : There’s still too much interference to warn them." );
						dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylonone_end_00112', FALSE, NONE, 0.0, "", "Cortana : We’ve got to disable that other beam before they’re pulled in like we were." );
				//		dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00106', FALSE, NONE, 0.0, "", "Cortana : We can’t go directly to the second pylon, but I’ve instructed the portal network to route us back through the central hub." );
					//	dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00107', FALSE, NONE, 0.0, "", "Cortana : Or at least, I think that’s what I told it." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end




script dormant f_dialog_m30_observatory_second()
dprint("f_dialog_m30_observatory_second");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_observatory_second", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00108', FALSE, NONE, 0.0, "", "Cortana : I was wondering why Infinity hadn’t encountered the Covenant yet." );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00109', FALSE, NONE, 0.0, "", "Master Chief : What are they doing here?" );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00110', FALSE, NONE, 0.0, "", "Cortana : They’re heading to the second pylon as well." );
						dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00111', FALSE, NONE, 0.0, "", "Master Chief : That can’t be a coincidence." );
					//	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00112', FALSE, NONE, 0.0, "", "Cortana : Weren’t you the one who said one mystery at a time?" );
					//	dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00113', FALSE, NONE, 0.0, "", "Master Chief : Was I?" );
					//	dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\m30_observatory_second_00114', FALSE, NONE, 0.0, "", "Cortana : C’mon. Into the portal." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_plyontwo_drop_pods()
dprint("f_dialog_m30_plyontwo_drop_pods");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_DROP_PODS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_drop_pods_00100', FALSE, NONE, 0.0, "", "Cortana : Drop pods!" );
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_plyontwo_enemy()
dprint("f_dialog_m30_plyontwo_enemy");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_ENEMY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_pylontwo_drop_pods_00102', FALSE, NONE, 0.0, "", "Cortana : The enemy of my enemy." );
					dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_pylontwo_drop_pods_00103', FALSE, NONE, 0.0, "", "Master Chief : They're ALL our enemy." );
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end


script dormant f_dialog_m30_pylontwo_transmission_one()
dprint("f_dialog_m30_pylontwo_transmission_one");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_TRANSMISSION_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
									
									start_radio_transmission( "delrio_transmission_name" ); 

									hud_play_pip_from_tag( "bink\campaign\M30_I_60" );
									thread(f_dialog_play_pip_m30_i_subtitles());

										// dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_start_ramp_enter_00100', FALSE, NONE, 0.0, "", "Del Rio : Fleetcom, we have detected what appears to be wreckage from the UNSC For-", TRUE);
										sleep_s(5);
										end_radio_transmission();
									dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_start_ramp_enter_00101', FALSE, NONE, 0.0, "", "Cortana : The relay's signal is breaking up again. We're almost to the beam." );
										
				  l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_play_pip_m30_i_subtitles()
	// sleep_s(1);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_delrio_transmission_full_00104');
end

script dormant f_dialog_m30_pylontwo_arrival()
dprint("f_dialog_m30_pylontwo_arrival");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_ARRIVAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_arrival_00107', FALSE, NONE, 0.0, "", "Cortana : Sounds like the Prometheans don’t want the Covenant here either." );
						hud_play_pip_from_tag( bink\campaign\M30_H_60 );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_arrival_00108', FALSE, NONE, 0.0, "", "Cortana : The battlenet’s already lighting up with reports of resistance all around the pylon." );
						//dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_arrival_00109', FALSE, NONE, 0.0, "", "Master Chief : Good. Maybe they’ll keep each other busy long enough for us to get that beam down." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_pylontwo_reveal()
dprint("f_dialog_m30_pylontwo_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_REVEAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						//dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_reveal_00100', FALSE, NONE, 0.0, "", "Master Chief : The Covenant beat us here." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_reveal_00101', FALSE, NONE, 0.0, "", "Cortana : It appears that the Pylon's security slowed them down. " );
					
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script dormant f_dialog_m30_pylontwo_banshees()
dprint("f_dialog_m30_pylontwo_banshee");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_BANSHEE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\M30_pylontwo_banshees_00100', FALSE, NONE, 0.0, "", "Cortana : Eyes up! We've got Banshees! " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end



script dormant f_dialog_m30_pylontwo_bridgetoelevator()
dprint("f_dialog_m30_pylontwo_bridgetoelevator");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_BRIDGETOELEVATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_bridgetoelevator_00100', FALSE, NONE, 0.0, "", "Cortana : Same protocols as the other pylon." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_bridgetoelevator_00101', FALSE, NONE, 0.0, "", "Cortana : These shields probably run off power cores as well." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_bridgetoelevator_00102', FALSE, NONE, 0.0, "", "Cortana : We better find them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 

end

script dormant f_dialog_m30_pylontwo_core_one()
dprint("f_dialog_m30_pylontwo_core_one");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_CORE_ONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_core_one_00100', FALSE, NONE, 0.0, "", "Cortana : Power core down. Shield's weak, but still online." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_core_one_00101', FALSE, NONE, 0.0, "", "Cortana : This is just like the other pylon." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_core_one_00102', FALSE, NONE, 0.0, "", "Cortana : Take out the other two power cores and we can access the pylon." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_pylontwo_core_two()
dprint("f_dialog_m30_pylontwo_core_two");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_CORE_TWO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_core_two_00100', FALSE, NONE, 0.0, "", "Cortana : Second power core offline. Good job, Chief." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_pylontwo_core_three()
dprint("f_dialog_m30_pylontwo_core_three");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_CORE_THREE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    				
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_core_three_00100', FALSE, NONE, 0.0, "", "Cortana : That'll do it. Shields should be down. Get up to that beam!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_pylontwo_hallway()
dprint("f_dialog_m30_pylontwo_hallway");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_HALLWAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					start_radio_transmission( "delrio_transmission_name" );
					hud_play_pip_from_tag( "bink\campaign\M30_J_60" );
					thread(f_dialog_play_pip_m30_j_subtitles());
					
								//					dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_delrio_transmission_full_00104J_pip', FALSE, NONE, 0.0, "", "Del Rio : light source is an aperture of some sort. Will advise once we've reached", TRUE);					
									sleep_s(5);
									end_radio_transmission();
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00106', FALSE, NONE, 0.0, "", "Cortana : They’ve found the opening." );
					//	dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00107', FALSE, NONE, 0.0, "", "Master Chief : How close are they?" );
					//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00108', FALSE, NONE, 0.0, "", "Cortana : 800,000 kilometers. ETA, six minutes, give or take." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00109', FALSE, NONE, 0.0, "", "Cortana : We can still warn them but we’re going to have to hurry up to that relay once the beam is down." );
						//dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00107', FALSE, NONE, 0.0, "", "Master Chief : Are you sure we can use the relay to contact the ship?" );
						//dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00108', FALSE, NONE, 0.0, "", "Cortana : Not particularly, but we don’t have much of a choice, do we?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_play_pip_m30_j_subtitles()
	// sleep_s(1);
	dialog_play_subtitle('sound\dialog\mission\m30\m30_delrio_transmission_full_00104');
end

script dormant f_dialog_m30_pylontwo_hallway_ghost()
dprint("f_dialog_m30_pylontwo_hallway_ghost");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
				 
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_HALLWAY_GHOST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
						 start_radio_transmission( "delrio_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00105', FALSE, NONE, 0.0, "", "Del Rio : light source is an aperture of some sort. Will advise once we've reached", TRUE);
						end_radio_transmission();
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00106', FALSE, NONE, 0.0, "", "Cortana : They’ve found the opening." );
					//	dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00107', FALSE, NONE, 0.0, "", "Master Chief : How close are they?" );
					//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00108', FALSE, NONE, 0.0, "", "Cortana : 800,000 kilometers. ETA, six minutes, give or take." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00109', FALSE, NONE, 0.0, "", "Cortana : We can still warn them but we’re going to have to hurry up to that relay once the beam is down." );
						//dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00107', FALSE, NONE, 0.0, "", "Master Chief : Are you sure we can use the relay to contact the ship?" );
						//dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_hallway_1_enter_00108', FALSE, NONE, 0.0, "", "Cortana : Not particularly, but we don’t have much of a choice, do we?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

end

script static void f_dialog_play_pip_m30_k_subtitles()
	sleep_s(0.04);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00105');
	sleep_s(1.06);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00106');
	sleep_s(0.03);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00107');
	sleep_s(0.11);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00108');
	
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00109');
	sleep_s(0.15);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00110');
	sleep_s(1.01);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00111');
	sleep_s(0.29);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00112');
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00113');
	sleep_s(0.16);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00114');
	sleep_s(1.25);
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00115');
	dialog_play_subtitle('sound\dialog\mission\m30\M30_pylontwo_elevator_ride_00116');
end

script dormant f_dialog_m30_pylontwo_elevator_ride()
	dprint("f_dialog_m30_pylontwo_elevator_ride");

	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_ELEVATOR_RIDE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    

	hud_play_pip_from_tag( "bink\campaign\M30_K_60" );
	thread(f_dialog_play_pip_m30_k_subtitles());
								
	start_radio_transmission( "delrio_transmission_name" );
	//		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00105', FALSE, NONE, 0.0, "", "Del Rio : UNSC Infinity to Survivor, Forward Unto Dawn.", TRUE);
	//		dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00106', FALSE, NONE, 0.0, "", "Del Rio : Reading a faint IFF tag near the planetary core. Do you read?", TRUE);
			//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00107', FALSE, NONE, 0.0, "", "Cortana : The planet’s core? They know we’re here!");
	//		dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00108', FALSE, NONE, 0.0, "", "Cortana : Infinity, this is UNSC AI Cortana!" );
	//	dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00109', FALSE, NONE, 0.0, "", "Cortana : Do not approach Forerunner planet! Repeat, do not approach--" );
	//	dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00111', FALSE, NONE, 0.0, "", "Del Rio : We read you but you’re breaking up!", TRUE);
	//	dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00112', FALSE, NONE, 0.0, "", "Del Rio : Helm, increase speed by point-seven. Get us in there.", TRUE);
	sleep_s(53);
	
	hud_play_pip_from_tag( "" );
	end_radio_transmission();
				
	//	dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00113', FALSE, NONE, 0.0, "", "Cortana : NEGATIVE, INFINITY! DO NOT ENTER THE PLANET!" );	
	//dialog_line_npc( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00114', FALSE, NONE, 0.0, "", "Del Rio : If you can hear us, keep transmitting-", TRUE);
	 
	//	dialog_line_cortana( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00115', FALSE, NONE, 0.0, "", "Cortana : NO!" );	
	//	dialog_line_cortana( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_elevator_ride_00116', FALSE, NONE, 0.0, "", "Cortana : Chief, you’ve got to get that beam down NOW." );	
	 
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_pylontwo_top_enter()
dprint("f_dialog_m30_pylontwo_top_enter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_TOP_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00113', FALSE, NONE, 0.0, "", "Cortana : Quick! Shut it down!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m30_pylontwo_end()
dprint("f_dialog_m30_pylontwo_end");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_PYLONTWO_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00114', FALSE, NONE, 0.0, "", "Cortana : Cortana to Infinity, do you copy?" );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00115', FALSE, NONE, 0.0, "", "Cortana : Come in, Infinity!" );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00116', FALSE, NONE, 0.0, "", "Cortana : The interference is gone, but your suit’s transmitter's not strong enough." );
						dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00117', FALSE, NONE, 0.0, "", "Master Chief : Route us up to the relay satellite." );
						dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_pylontwo_end_00118', FALSE, NONE, 0.0, "", "Cortana : Already done! Go!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_observatory_final()
dprint("f_dialog_m30_observatory_final");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_OBSERVATORY_FINAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_observatory_final_00106', FALSE, NONE, 0.0, "", "Cortana : Once we’re on the satellite, there’s bound to be a central control point." );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_observatory_final_00107', FALSE, NONE, 0.0, "", "Master Chief : The Covenant are moving towards the relay too." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_observatory_final_00108', FALSE, NONE, 0.0, "", "Cortana : This doesn’t make any sense!" );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_observatory_final_00109', FALSE, NONE, 0.0, "", "Cortana : Why would they care about a broadcast relay?!?" );
						dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_observatory_final_00110', FALSE, NONE, 0.0, "", "Master Chief : I’ll handle them; you just find us that control node." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_donut_enter()
dprint("f_dialog_m30_donut_enter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_DONUT_ENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_donut_enter_00103', FALSE, NONE, 0.0, "", "Master Chief : How much time?" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_donut_enter_00104', FALSE, NONE, 0.0, "", "Cortana : A minute or two, max!" );
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_donut_enter_00105', FALSE, NONE, 0.0, "", "Cortana : The Covenant are making a push for something on the far side of the satellite!" );
							//dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_donut_enter_00106', FALSE, NONE, 0.0, "", "Master Chief : The control node?" );
							//dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_donut_enter_00107', FALSE, NONE, 0.0, "", "Cortana : As good a bet as any!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_donut_signal_relay()
dprint("f_dialog_m30_donut_signal_relay");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_DONUT_SIGNAL_RELAY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_donut_context_00100', FALSE, NONE, 0.0, "", "Master Chief : Is that the signal relay?" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_donut_context_00101', FALSE, NONE, 0.0, "", "Cortana : Yes. Now we just have to hope we can use it to warn Infinity before it's too late!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_donut_infinity_broadcast()
dprint("f_dialog_m30_donut_infinity_broadcast");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_DONUT_INFINITY_BROADCAST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_donut_transit_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, you need to hear this!" );
							start_radio_transmission( "infinity_transmission_name" );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_donut_transit_00101', FALSE, NONE, 0.0, "", "Infinity Comm : We're detecting a slight gravimetric disturbance near the planetary entrance.", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_donut_transit_00102', FALSE, NONE, 0.0, "", "Infinity Comm : Suggest altering approach vector, 43K-750K-12k.", TRUE);
							end_radio_transmission();
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_donut_transit_00103', FALSE, NONE, 0.0, "", "Cortana : They're not diverting from the opening! Hurry, Chief!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_cryptum_approach()
dprint("f_dialog_m30_cryptum_approach");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_CRYPTUM_APPROACH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_cryptum_approach_00100', FALSE, NONE, 0.0, "", "Cortana : That's it!" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_cryptum_approach_00101', FALSE, NONE, 0.0, "", "Cortana : Wait, this isn't a typical Forerunner interface! I don't--" );
							dialog_line_chief( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\M30_cryptum_approach_00105', FALSE, NONE, 0.0, "", "Master Chief : We don't have time." );
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_cryptum_approach_00103', FALSE, NONE, 0.0, "", "Cortana : The handles! Grab the handles!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
	b_cryptum_approach_dialog_complete = TRUE;

end



script dormant f_dialog_m30_escape_open_vignette()
dprint("f_dialog_m30_escape_open_vignette");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_OPEN_VIGNETTE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_open_vignette_00103', FALSE, NONE, 0.0, "", "Cortana : That -- Didact -- he manipulated Infinity’s signal to get us to release him!" );
							dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_escape_open_vignette_00104', FALSE, NONE, 0.0, "", "Master Chief : Later! What’s happening?" );
							dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_escape_open_vignette_00105', FALSE, NONE, 0.0, "", "Cortana : Moving the satellite into slipspace destabilized the core." );
							dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_escape_open_vignette_00106', FALSE, NONE, 0.0, "", "Cortana : We’ve got to find a portal out of here before the whole network collapses!" );
						//	dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_escape_open_vignette_00102', FALSE, NONE, 0.0, "", "Cortana : Phantom!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_escape_volume_01_a()
dprint("f_dialog_m30_escape_volume_01_a");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_01_A", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_volume_01_00100', FALSE, NONE, 0.0, "", "Cortana : Grab one of those ghosts! " );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_leave_ghost()
dprint("f_dialog_m30_leave_ghost");
		sleep_s(3);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_LEAVE_GHOST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00116', FALSE, NONE, 0.0, "", "Cortana : Chief, what are you doing?!?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_escape_volume_01_b()
dprint("f_dialog_m30_escape_volume_01_b");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_01_B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_volume_01_00102', FALSE, NONE, 0.0, "", "Cortana : Hang on, I'm going to channel energy from your shields to overdrive the Ghost's boost." );
						thread (player_escape_shield_stun (player0));
						thread (player_escape_shield_stun (player1));
						thread (player_escape_shield_stun (player2));
						thread (player_escape_shield_stun (player3));
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_escape_volume_01_00103', FALSE, NONE, 0.0, "", "Cortana : Done - now floor it! " );
						//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_escape_volume_01_00104', FALSE, NONE, 0.0, "", "Cortana : And whatever you do, don't let up on the gas!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_escape_destruction_02()
dprint("f_dialog_m30_escape_destruction_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_DESTRUCTION_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00100', FALSE, NONE, 0.0, "", "Cortana : Emergency broadcast from Infinity!");
							start_radio_transmission( "delrio_transmission_name" );
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00101', FALSE, NONE, 0.0, "", "Del Rio : Fleetcom, this is Infinity! ", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00102', FALSE, NONE, 0.0, "", "Del Rio : We are encountering an unidentifiable gravimetric disturbance and are being pulled INSIDE a planet of FORERUNNER origin!", TRUE);
							dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00103', FALSE, NONE, 0.0, "", "Del Rio : Possible contact with UNSC Forward Unto Dawn! ", TRUE);
							dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00104', FALSE, NONE, 0.0, "", "Del Rio : Jettisoning complete log beacons at our last known!", TRUE);
							end_radio_transmission();
							dialog_line_chief( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00105', FALSE, NONE, 0.0, "", "Master Chief : Cortana, we need to get up there." );
							dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m30\m30_escape_infinity_1_00106', FALSE, NONE, 0.0, "", "Cortana : It's not like I can get out and push!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				
end


script dormant f_dialog_m30_escape_volume_02()
dprint("f_dialog_m30_escape_volume_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00106', FALSE, NONE, 0.0, "", "Cortana : This is no time to be timid, Chief! Gun it!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_escape_volume_03()
dprint("f_dialog_m30_escape_volume_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_volume_03_00100', FALSE, NONE, 0.0, "", "Cortana : Portal, up ahead!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_escape_volume_03a()
dprint("f_dialog_m30_escape_volume_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00100', FALSE, NONE, 0.0, "", "Cortana : This is going to be tight!!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_escape_volume_04()
dprint("f_dialog_m30_escape_volume_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00101', FALSE, NONE, 0.0, "", "Cortana : Keep going! Keep going!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m30_escape_volume_05()
dprint("f_dialog_m30_escape_volume_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00103', FALSE, NONE, 0.0, "", "Cortana : I didn't think we were gonna make it for a second." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m30_escape_volume_06()
dprint("f_dialog_m30_escape_volume_06");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_06", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00102', FALSE, NONE, 0.0, "", "Cortana : Don't worry about them! Just keep going!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m30_escape_volume_07()
dprint("f_dialog_m30_escape_volume_07");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_07", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00107', FALSE, NONE, 0.0, "", "Cortana : The core's not going to last much longer!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m30_escape_volume_08()
dprint("f_dialog_m30_escape_volume_08");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_08", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00111', FALSE, NONE, 0.0, "", "Cortana : The core's just an artificial construct, like the rest of the planet! It's trying to compensate for the loss of the satellite!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m30_escape_volume_09()
dprint("f_dialog_m30_escape_volume_09");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_09", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00108', FALSE, NONE, 0.0, "", "Cortana : I know this thing can go faster than this. Now, push it!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script dormant f_dialog_m30_pre_portal_01()
dprint("f_dialog_m30_pre_portal_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_VOLUME_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_escape_00113', FALSE, NONE, 0.0, "", "Cortana : There has to be a portal close by." );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m30\M30_escape_00114', FALSE, NONE, 0.0, "", "Master Chief : Cortana, we need to get up there." );
					//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m30\M30_escape_00115', FALSE, NONE, 0.0, "", "Cortana : There has to be a portal close by." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m30_pre_portal_02()
dprint("f_dialog_m30_escape_preportal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M30_ESCAPE_PREPORTAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\m30_escape_preportal_00100', FALSE, NONE, 0.0, "", "Cortana : We're not going to make it!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================


script dormant f_dialog_M30_observ_1_nudge()
	dprint("f_dialog_M30_observ_1_nudge");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_OBSERV_1_NUDGE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_obswalk_00108', FALSE, NONE, 0.0, "", "Cortana : Chief, I'm not going to be much help if you don't insert me into that console." );	
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	b_first_time_dialog_over = TRUE;
end

script dormant f_dialog_M30_observ_1_nudge_2()
	dprint("f_dialog_M30_observ_1_nudge_2");

	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M30_OBSERV_1_NUDGE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	 dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m30\M30_obswalk_00109', FALSE, NONE, 0.0, "", "Cortana : Weren't you the one that said you wanted to get us home? Put me in there, already." );	
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	
	b_first_time_dialog_over = TRUE;
end

script static void f_dialog_m30_objective_1()
dprint("f_dialog_m30_objective_1");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_1", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_1_complete), 'sound\dialog\mission\m30\m30_pylonone_prompt_00100', FALSE, NONE, 0.0, "", "Cortana: Chief, we won't be able to contact Infinity if we don't get to that pylon and take it down." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end



script static void f_dialog_m30_objective_2()
dprint("f_dialog_m30_objective_2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and (not b_objective_2_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_2", l_dialog_id,  (not b_objective_2_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_2_complete), 'sound\dialog\mission\m30\M30_cryptum_objective_00101', FALSE, NONE, 0.0, "", "Cortana: Chief, you need to destroy the power cores if we're going to take that pylon down." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_2_complete, b_objective_2_complete, "" );
		end
end

script static void f_dialog_m30_objective_3()
dprint("f_dialog_m30_objective_3");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and (not b_objective_3_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m30\M30_pylontwo_prompts_00103', FALSE, NONE, 0.0, "", "Cortana: Chief, there is a second pylon causing inference. We need to bring it down." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_3_complete, b_objective_3_complete, "" );
		end
end

script static void f_dialog_m30_objective_4()
dprint("f_dialog_m30_objective_4");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and (not b_objective_3_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_3", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_3_complete), 'sound\dialog\mission\m30\M30_cryptum_objective_00103', FALSE, NONE, 0.0, "", "Cortana: 	Chief, this is just like last time. Destroy the power cores to take down the pylon." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_3_complete, b_objective_3_complete, "" );
		end
end

script static void f_dialog_m30_objective_5()
dprint("f_dialog_m30_objective_5");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and (not b_objective_5_complete)) then
					l_dialog_id = dialog_start_foreground( "OBJECTIVE_5", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 1, (not b_objective_5_complete), 'sound\dialog\mission\m30\M30_donut_enter_00103', FALSE, NONE, 0.0, "", "Cortana: Chief, we need to get to those relay controls!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
		end
end


/*script static void f_dialog_m60_callout_find_some_cover()
dprint("f_dialog_callout_find_some_cover");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FIND_SOME_COVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00132', FALSE, NONE, 0.0, "", "Cortana : Find some cover!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m60_callout_atta_boy_chief()
dprint("f_dialog_callout_find_some_cover");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FIND_SOME_COVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00132', FALSE, NONE, 0.0, "", "Cortana : Atta boy, Chief" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m60_callout_only_a_few_more_left()
dprint("f_dialog_callout_find_some_cover");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FIND_SOME_COVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00132', FALSE, NONE, 0.0, "", "Cortana : Only a few more left" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end*/