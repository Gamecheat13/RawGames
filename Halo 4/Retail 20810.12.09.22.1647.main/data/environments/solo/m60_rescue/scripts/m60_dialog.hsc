
// =================================================================================================
// =================================================================================================
// DIALOGUE SCRIPTING M60
// =================================================================================================
// =================================================================================================


// =================================================================================================
// *** GLOBALS ***

global long l_dlg_m60_plinth_call = DEF_DIALOG_ID_NONE();
global long l_dlg_m60_infinityberth_tocauseway = DEF_DIALOG_ID_NONE();
global long l_dlg_infinityouterdeck_mac_ready = DEF_DIALOG_ID_NONE();
global long L_dlg_1st_fof_ping = DEF_DIALOG_ID_NONE();
	
// =================================================================================================

///////////////////////////////////////////////////////////////////////////////////
// MAIN
///////////////////////////////////////////////////////////////////////////////////
script startup M60_dialogue_main()
	
	if (game_insertion_point_get() < 22) then
	
	print ("::: M60 Dialogue Start :::");
	


	end

end

//3434343434343434343434343434343434343434343434343434343434343434343434343434

////////////////////////////////////DIALOGUE SCRIPTS////////////////////////////

//3434343434343434343434343434343434343434343434343434343434343434343434343434



script dormant f_dialog_m60_1st_fof_ping()
dprint("f_dialog_m60_1st_fof_ping");

					L_dlg_1st_fof_ping = dialog_start_foreground( "M60_1AT_FOF_PING", L_dlg_1st_fof_ping, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( L_dlg_1st_fof_ping, 0, TRUE, 'sound\dialog\mission\m60\1st_fof_ping_00100', FALSE, NONE, 0.0, "", "Cortana : I'm seeing numerous IFF tags below the tree line.  Painting the closest one on your HUD." );
				 L_dlg_1st_fof_ping = dialog_end( L_dlg_1st_fof_ping, TRUE, TRUE, "" );
				 //f_blip_object (crumb_dogtag_01, "recon");
				 dprint("f_dialog_m60_1st_fof_ping end");
end

script dormant f_dialog_m60_the_view()
dprint("f_dialog_m60_the_view");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_THE_VIEW", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_vo_theview_00100', FALSE, NONE, 0.0, "", "Master Chief : That scan's the same one we saw on the Dawn." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(f_dialog_m60_the_view_02);
end
script dormant f_dialog_m60_the_view_02()
dprint("f_dialog_m60_the_view");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_THE_VIEW_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_vo_theview_00200', TRUE, NONE, 0.0, "", "Cortana : Except now, the Didact's free to handle it personally." );						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_vo_trail_transmission()
dprint("f_dialog_m60_vo_trail_transmission");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_VO_TRAIL_TRANSMISSION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );    						
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_vo_trail_transmission_00400', TRUE, NONE, 0.0, "", "Master Chief : Hail Infinity and let them know about the Didact." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_vo_trail_transmission_02()
dprint("f_dialog_m60_vo_trail_transmission");
					
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_VO_TRAIL_TRANSMISSION-02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.0 );    						
						start_radio_transmission( "delrio_transmission_name" );
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_vo_trail_transmission_00200', FALSE, NONE, 0.0, "", "Del Rio : Infinity to Commander Lasky.  We've lost contact with your Pelicans!  Report in!", TRUE);
						end_radio_transmission();
						//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\peak_vo_trail_transmission_00500', FALSE, NONE, 0.0, "", "Cortana : I’m trying but their comms must be malfunctioning." );
				//		dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\peak_vo_trail_transmission_00300', FALSE, NONE, 0.0, "", "Master Chief : They must not have received his distress call." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(f_dialog_m60_vo_trail_transmission_02B);
end

script dormant f_dialog_m60_vo_trail_transmission_02B()
dprint("f_dialog_m60_vo_trail_transmission_02B");
					
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_VO_TRAIL_TRANSMISSION_02B", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.0 );    						
						dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_vo_trail_transmission_00300', FALSE, NONE, 0.0, "", "Master Chief : They must not have received his distress call." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_m60_vignette_ambush_01()
dprint("f_dialog_m60_vignette_ambush_01");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

                        l_dialog_id = dialog_start_background( "M60_VIGNETTE_AMBUSH_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\audio_vignette_ambush_00101_soundstory_live', FALSE, ambush_attachment, 0.0, "", "Ambush Marine 1 : Now they're be--AAAA!!", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
									//wake(f_dialog_m60_vignette_ambush_03);
end




script dormant f_dialog_m60_vignette_ambush_03()
dprint("f_dialog_m60_vignette_ambush_03");
	//sleep_until(volume_test_players(peak_prometheans_appear_cortana), 1);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_VIGNETTE_AMBUSH_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
			//			dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00119', FALSE, NONE, 0.0, "", "Cortana : Hostiles!" );
		//				sleep_s(1);
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\peak_prometheans_appear_00400', FALSE, NONE, 0.0, "", "Master Chief : Lasky?" );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\peak_prometheans_appear_00500', FALSE, NONE, 0.0, "", "Cortana : One of them’s an officer." );
						dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\peak_prometheans_appear_00600', FALSE, NONE, 0.0, "", "Cortana : Check his IFF tag." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script static void f_dialog_m60_vignette_ambush_04()
	dprint("f_dialog_m60_vignette_ambush_04");
	static long l_dialog_id = DEF_DIALOG_ID_NONE();
         
    l_dialog_id = dialog_start_foreground( "M60_VIGNETTE_AMBUSH_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.0 );
	dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\peak_after_iff_00100', FALSE, NONE, 0.0, "", "Cortana : The tag ID’s him as Jiminez, Paolo J." );
	dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\peak_after_iff_00200', FALSE, NONE, 0.0, "", "Master Chief : Then Lasky’s still out there somewhere." );
	
	//sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_in_01', iff_1_attachment, 1 );
//	hud_play_pip_from_tag( "bink\Campaign\M60_A_60" );   										

	thread(m60_vignette_ambush_04_subtitles());
	dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\audio_vignette_ambush_00101_soundstory_recording', FALSE, iff_1_attachment, 0.0, "", "Ambush Marine 2 : I mean, c'mon Sarge.  Who sends recon downrange in the middle of a firefight?", TRUE);
	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );		
			
	sleep_s(21);
//	sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_out_01', iff_1_attachment, 1 );
end

script static void m60_vignette_ambush_04_subtitles()
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m60\audio_vignette_ambush_00101');
	sleep(70);
	dialog_play_subtitle('sound\dialog\mission\m60\audio_vignette_ambush_00102');
	sleep(120);
	dialog_play_subtitle('sound\dialog\mission\m60\audio_vignette_ambush_00103');
	sleep(120);
	dialog_play_subtitle('sound\dialog\mission\m60\audio_vignette_ambush_00104');
end

script dormant f_dialog_m60_vignette_ambush_05()
dprint("f_dialog_m60_vignette_ambush_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_VIGNETTE_AMBUSH_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_sniper_backscatter()
dprint("f_dialog_m60_sniper_backscatter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SNIPER_BACKSCATTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\trails1_sniper_00101', FALSE, NONE, 0.0, "", "Cortana : Sniper!" );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\trails1_sniper_00102', FALSE, NONE, 0.0, "", "Cortana : Backscatter, refracting off the mist." );
						//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\trails1_sniper_00103', FALSE, NONE, 0.0, "", "Cortana : It could indicate they’re using an alternate weapon sighting." );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\trails1_sniper_00107', FALSE, NONE, 0.0, "", "Cortana : Stay sharp." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_trails_knight_vignette()
dprint("f_dialog_m60_trails_knight_vignette");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_KNIGHT_VIGNETTE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
				 dialog_line_npc(l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00117_soundstory', FALSE, trails_knight_vignette, 0.0, "", "Swamp Marine: Hostiles in the fog!", TRUE);
		
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
			
end

script dormant f_dialog_m60_trails_iffcallout()
dprint("f_dialog_m60_trails_iffcallout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_TRAILS_IFFCALLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\trails_iffcallout_00100', FALSE, NONE, 0.0, "", "Cortana : We’ve got another IFF on the far side of this thicket." );
				
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 f_blip_object (crumb_dogtag_02, "recon");
end


script dormant f_dialog_m60_xray_intro()
dprint("f_dialog_m60_xray_intro");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_XRAY_INTRO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, (b_xray_pickedup == FALSE), 'sound\dialog\mission\m60\xray_intro_00100', FALSE, NONE, 0.0, "", "Cortana : Hold up; what was that he dropped on the ground over there?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_xray_intro_2()
	sleep_until(volume_test_players(m60_xray_intro_02), 1);
dprint("f_dialog_m60_xray_intro_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();

					l_dialog_id = dialog_start_foreground( "M60_XRAY_INTRO_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\xray_intro_00200', FALSE, NONE, 0.0, "", "Cortana : Very clever. It's a quantum imager." );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\xray_intro_00300', FALSE, NONE, 0.0, "", "Cortana : This is what they've been using to see through the fog." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\xray_intro_00400', FALSE, NONE, 0.0, "", "Cortana : More Prometheans down in the mist." );
					//	dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\xray_intro_00500', FALSE, NONE, 0.0, "", "Cortana : Try using the Imager to target them." );
						//dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\xray_intro_00600', FALSE, NONE, 0.0, "", "Cortana : Let's see if we can use their own tech against them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

				 
end

script dormant f_dialog_m60_crumb_dogtag_scan2()
	dprint("f_dialog_m60_crumb_dogtag_scan2");
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
		f_unblip_object (crumb_dogtag_02);
		l_dialog_id = dialog_start_foreground( "M60_DOGTAG_SCAN2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
		
		hud_play_pip_from_tag( "bink\Campaign\M60_B_60" );
		thread(m60_crumb_dogtag_scan2_subtitles());
			
		sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_in_01', iff_2_attachment, 1 );  
		dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\crumb_dogtag_scan2_00100_soundstory', FALSE, iff_2_attachment, 0.0, "", "Lasky : We should get eyes out there looking for the others.", TRUE);
		sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_out_01', iff_2_attachment, 1 );
		//	dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\crumb_dogtag_scan2_00101', FALSE, iff_2_attachment, 0.0, "", "Palmer : Peters, you heard Commander Lasky.", TRUE);
	//		dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\crumb_dogtag_scan2_00102', FALSE, iff_2_attachment, 0.0, "", "CPO Peters : CFB, ma’am. Bulldogs! On me! We're going for a walk!", TRUE);
	//		hud_play_pip_from_tag( "" );
	
			dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\xray_after_iff_00100', FALSE, NONE, 0.0, "", "Cortana : Lasky’s been through here, recently by the timestamp." );
	 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void m60_crumb_dogtag_scan2_subtitles()
	sleep(60);
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan2_00100');
	sleep(10);
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan2_00101');
	sleep(10);
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan2_00102');
end

script dormant f_dialog_audio_vignette_pre_explosion()
dprint("f_dialog_audio_vignette_pre_explosion");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_AUDIO_VIGNETTE_PRE_EXPLOSION", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 ); 
						start_radio_transmission( "raptorleader_transmission_name" );   
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00100', FALSE, NONE, 0.0, "", "Raptor Leader : Team 4, this is team leader.", TRUE);
						dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00101', FALSE, NONE, 0.0, "", "Raptor Leader : Deploy to southwest flank.", TRUE);
						dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00102', FALSE, NONE, 0.0, "", "Raptor Leader : Secure the wire.", TRUE);
						dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00103', FALSE, NONE, 0.0, "", "Raptor Leader : Team 3, move to reinforce.", TRUE);
						dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00104', FALSE, NONE, 0.0, "", "Raptor Leader : Team 2, report in.", TRUE);
						dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00105', FALSE, NONE, 0.0, "", "Raptor Leader : Team 2? Briggs, if you read this, we’ve got EC’s in the open south of Position Bravo.", TRUE);
						dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\audio_vignette_pre_explosion_00106', FALSE, NONE, 0.0, "", "Raptor Leader : Team 4 is relocating with intent to suppress, so watch your fire.", TRUE);
						dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00100', FALSE, NONE, 0.0, "", "Del Rio : Del Rio to Raptor Leader! What the hell is going on out there?!?", TRUE);
						end_radio_transmission();
						
						start_radio_transmission( "raptorleader_transmission_name" );
						dialog_line_npc( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00101', FALSE, NONE, 0.0, "", "Raptor Leader : Sir, ground forces cannot reach battle position!", TRUE);
						dialog_line_npc( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00102', FALSE, NONE, 0.0, "", "Raptor Leader : That sphere is deploying hostile elements across --", TRUE);
						end_radio_transmission();
						
						start_radio_transmission( "delrio_transmission_name" );
						dialog_line_npc( l_dialog_id, 10, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00103', FALSE, NONE, 0.0, "", "Del Rio : Shore up that perimeter NOW, Lieutenant!", TRUE);
						end_radio_transmission();
						
						start_radio_transmission( "raptorleader_transmission_name" );
						dialog_line_npc( l_dialog_id, 11, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00104', FALSE, NONE, 0.0, "", "Raptor Leader : Aye sir, we're doing--Corporal, what's that--", TRUE);
						end_radio_transmission();
						
						start_radio_transmission( "infinitymarine_transmission_name" );
						dialog_line_npc( l_dialog_id, 12, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00105', FALSE, NONE, 0.0, "", "Marine Voice : Incoming!", TRUE);
						thread (story_blurb_add("other", "SOUND OF EXPLOSION OVER THE RADIO.."));
						end_radio_transmission();
						
						start_radio_transmission( "delrio_transmission_name" );
						dialog_line_npc( l_dialog_id, 13, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00106', FALSE, NONE, 0.0, "", "Del Rio : Raptor? Raptor Leader, respond!", TRUE);
						dialog_line_npc( l_dialog_id, 14, TRUE, 'sound\dialog\mission\m60\audio_vignette_delrio_explosion_00107', FALSE, NONE, 0.0, "", "Del Rio : Comm, get them back on the line!", TRUE);
						end_radio_transmission();
						
						dialog_line_cortana( l_dialog_id, 15, TRUE, 'sound\dialog\mission\m60\audio_vignette_post_explosion_00100', FALSE, NONE, 0.0, "", "Cortana : For someone who just woke up, this Didact’s not wasting any time." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_last_fof_ping()
dprint("f_dialog_m60_last_fof_ping");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_LAST_FOF_PING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\last_fof_ping_00100', FALSE, NONE, 0.0, "", "Cortana : I've got another IFF tag, but as far as I can tell we're moving into a choke point.  This may end up as a dead end." );
						f_blip_flag (crumb_locflag_last, "recon");
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_last_fof_ping_2()
dprint("f_dialog_m60_last_fof_ping_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_LAST_FOF_PING_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\last_fof_ping_00101', FALSE, NONE, 0.0, "", "Cortana : The transponder is above us, in the trees. Look for a way up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_last_fof_ping_3()
dprint("f_dialog_m60_last_fof_ping_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_LAST_FOF_PING_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\last_fof_ping_00102', FALSE, NONE, 0.0, "", "Cortana : Thermal imaging indicates recent activity through here, leading up into the trees." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_last_fof_callout()
dprint("f_dialog_m60_last_fof_ping_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_LAST_FOF_PING_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\last_fof_callout_00100', FALSE, NONE, 0.0, "", "Cortana : That’s the Friend-Or-Foe tag, but where’s whoever it belongs to?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_dogtag_scan_last()
	dprint("f_dialog_m60_dogtag_scan_last");
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();
	l_dialog_id = dialog_start_foreground( "M60_DOGTAG_SCAN_LAST", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
	
	hud_play_pip_from_tag( "bink\Campaign\M60_C_60" );
	thread(m60_dogtag_scan_last_subtitles());
	
	sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_in_01', iff_3_attachment, 1 );
	dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\crumb_dogtag_scan_last_00100_soundstory', FALSE, iff_3_attachment, 0.0, "", "Radio Marine : XO! We got it!", TRUE);
	sound_impulse_start( 'sound\storm\vo\ui_pip_squelch_out_01', iff_3_attachment, 1 );

	l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
	hud_play_pip_from_tag( "" );

	wake(m60_last_fof_reveal);
end

script static void m60_dogtag_scan_last_subtitles()
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00100');
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00101');
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00102');
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00103');
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00104');
	dialog_play_subtitle('sound\dialog\mission\m60\crumb_dogtag_scan_last_00105');
end

script dormant f_dialog_m60_last_fof_reveal()
dprint("f_dialog_m60_last_fof_reveal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_LAST_FOF_PING_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\last_fof_reveal_00101', FALSE, NONE, 0.0, "", "Cortana : Chief, they’re friendlies!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script static void f_dialog_m60_marines_bunker_01()
dprint("f_dialog_m60_marines_bunker_01");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "MARINES_BUNKER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\bunker_exit_marines_00100', FALSE, sq_trail3_hum.spawn_points_2, 0.0, "", "Bunker Marine 4 : Holy crap.", TRUE);
														dialog_line_npc( l_dialog_id, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\bunker_exit_marines_00101', FALSE, sq_trail3_hum.spawn_points_3, 0.0, "", "Bunker Marine 5 : Sir? Are you really ‘Him’?", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end




script static void f_dialog_m60_marines_bunker_02()
dprint("f_dialog_m60_marines_bunker_02");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "MARINES_BUNKER_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\bunker_exit_marines_00102', FALSE, NONE, 0.0, "", "Bunker Marine 1 : I didn’t think I believed in ghosts...", TRUE);
														dialog_line_npc( l_dialog_id, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\bunker_exit_marines_00103', FALSE, NONE, 0.0, "", "Bunker Marine 3 : Yeah, well, if this means I’m dead, my wife is gonna kill me.", TRUE);
														dialog_line_npc( l_dialog_id, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\bunker_exit_marines_00104', FALSE, NONE, 0.0, "", "Bunker Marine 2 : You thought HE was one of the Fours?", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end


 
script dormant f_dialog_m60_spartan_armor_comment()
dprint("f_dialog_m60_spartan_armor_comment");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SPARTAN_ARMOR_COMMENT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );   
				 /*hud_rampancy_players_set( 0.25 ); 					
				 sleep_s(1);
				 hud_rampancy_players_set( 0.0 );	*/
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\spartan_armor_comment_00104', FALSE, NONE, 0.0, "", "Cortana : A topographical scan of the area shows a break in the foliage NORTH of here." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\spartan_armor_comment_00105', FALSE, NONE, 0.0, "", "Cortana : Should be big enough to bring in a dropship for evac." );
						//dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\spartan_armor_comment_00106', FALSE, NONE, 0.0, "", "Cortana : Of course, I don’t know how many SPARTANS they can fit on there..." );
						//dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\spartan_armor_comment_00107', FALSE, NONE, 0.0, "", "Master Chief : You noticed that too, huh?" );
				//		dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\spartan_armor_comment_00108', FALSE, NONE, 0.0, "", "Cortana : Apparently we were easier to replace than to rescue." );
					
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script static void f_dialog_m60_boulders_marines_holedup()
dprint("f_dialog_m60_boulders_marines_holedup");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "BOULDERS_MARINES_HOLDUP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
														dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\boulders_marines_holedup_00102', FALSE, sq_marine_bou_a_1.talker2, 0.0, "", "Bunker Marine 5 : I thought he was dead.", TRUE);
														dialog_line_npc( l_dialog_id, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\boulders_marines_holedup_00103', FALSE, sq_marine_bou_a_1.talker3, 0.0, "", "Bunker Marine 2 : Holy mother of", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end

script static void f_dialog_m60_boulders_marines_holedup2()
dprint("f_dialog_m60_boulders_marines_holedup2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();

            if ( not dialog_background_id_active_check(l_dialog_id) ) then
            
                        l_dialog_id = dialog_start_background( "BOULDERS_MARINES_HOLDUP2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE_ALL(), TRUE, "", 0.0 );
                            dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\boulders_marines_holedup_00100', FALSE, sq_marine_bou_a_1.talker, 0.0, "", "Bunker Marine 1 : Who's that?", TRUE);
														dialog_line_npc( l_dialog_id, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\boulders_marines_holedup_00101', FALSE, sq_marine_bou_a_1.talker1, 0.0, "", "Bunker Marine 4 : What. The. What?", TRUE);
                        l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
                        
            end
end
script static void f_dialog_m60_boulders_marines_holedup_cortana()
dprint("f_dialog_m60_boulders_marines_holedup_cortana");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_HOLEDUP_CORTANA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\boulders_marines_holedup_00108', FALSE, NONE, 0.0, "", "Cortana : Hold firm, marines. We've got your back." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end





script dormant f_dialog_m60_preboulders_radio()
dprint("f_dialog_m60_preboulders_radio");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PREBOULDERS_RADIO", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );  
				//	start_radio_transmission( "marine_transmission_name" );  
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\preboulders_radio_00100_soundstory', FALSE, infinity_overrun_radio, 0.0, "", "[Infantry Marine 1] Pull back! Infinity’s being overrun! [Infantry Marine 2] Ship’s as big as a city, how the hell’s it being overrun?", TRUE);
				//		dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\preboulders_radio_00101', FALSE, infinity_overrun_radio, 0.0, "", "Infantry Marine 1 : Infinity’s being overrun!", TRUE);
						//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\preboulders_radio_00102', FALSE, infinity_overrun_radio, 0.0, "", "Infantry Marine 2 : Ship’s as big as a city, how the hell’s it being overrun?", TRUE);
			//		end_radio_transmission();	
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_boulders_uphigh()
dprint("f_dialog_m60_boulders_uphigh");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_BOULDERS_UPHIGH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\boulders_uphigh_00100', FALSE, NONE, 0.0, "", "Cortana : Tango! Up high!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_boulders_assistmarines()
dprint("f_dialog_m60_boulders_assistmarines");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					
					l_dialog_id = dialog_start_foreground( "M60_BOULDERS_ASSISTMARINES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
					hud_play_pip_from_tag( "bink\Campaign\M60_D_60" );
					start_radio_transmission( "lasky_transmission_name" );
					dialog_play_subtitle('sound\dialog\mission\m60\boulders_assistmarines_00100');
						//dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\boulders_assistmarines_00100', FALSE, NONE, 0.0, "", "Lasky : Chief, Lasky.  We're getting reports of friendlies pinned down near your position.  Can you assist?", TRUE);
						//sleep_s(5);
					end_radio_transmission();	
					//hud_play_pip_from_tag( "" );
					
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\boulders_assistmarines_00200', FALSE, NONE, 0.0, "", "Cortana : Commander, this is Cortana.  We're on our way." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
end


script dormant f_dialog_m60_boulders_uphigh_callout()
dprint("f_dialog_m60_boulders_uphigh");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_BOULDERS_UPHIGH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_callout_00100', FALSE, NONE, 0.0, "", "Cortana : Emplacements, top of the hill!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_plinth_callout()
sleep_until( volume_test_players(cortana_emplacements), 1);

dprint("f_dialog_m60_plinth_callout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_CALLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_callout_00101', FALSE, NONE, 0.0, "", "Cortana : The marines got trapped trying to get through these doors. Look for an interface" );
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_plinth_callout_02()
dprint("f_dialog_m60_plinth_callout");
local long l_dlg_m60_plinth_call = DEF_DIALOG_ID_NONE();
					l_dlg_m60_plinth_call = dialog_start_foreground( "M60_PLINTH_CALLOUT", l_dlg_m60_plinth_call, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dlg_m60_plinth_call, 0, TRUE, 'sound\dialog\mission\m60\plinth_callout_00103', FALSE, NONE, 0.0, "", "Cortana : Chief - terminal, by the door. Jack me into it." );
				 l_dlg_m60_plinth_call = dialog_end( l_dlg_m60_plinth_call, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_plinth_ambush()
dprint("f_dialog_m60_plinth_ambush");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_AMBUSH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_holdthehillprompt_00101', FALSE, boulders_plinth, 0.0, "", "Cortana : Giving up this location’s not an option, Chief. Lock it down!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_plinth_progress()
dprint("f_dialog_m60_plinth_progress");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_PROGRESS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_progress_00101', FALSE, boulders_plinth, 0.0, "", "Cortana : These doors open into a cave system with a space large enough for an LZ." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\plinth_progress_00102', FALSE, boulders_plinth, 0.0, "", "Cortana : Hold them off long enough for me to open them up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script dormant f_dialog_m60_plinth_progress_03()
dprint("f_dialog_m60_plinth_progress_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_PROGRESS_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					   dialog_line_chief( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_progress_00105', FALSE, NONE, 0.0, "", "Master Chief : Cortana? How close are we?" );
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_progress_00106', FALSE, boulders_plinth, 0.0, "", "Cortana : YOU DO YOUR JOB AND I’LL DO MINE, OK?!?" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_plinth_complete()
dprint("f_dialog_m60_plinth_complete");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_PROGRESS_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					    dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\plinth_progress_00107', FALSE, boulders_plinth, 0.0, "", "Cortana: Got it! Passageway's unlocked - come and get me!" );
					  	
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_rampancy_hall()
dprint("f_dialog_m60_rampancy_hall");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_RAMPANCY_HALL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    											    
					
					hud_play_pip_from_tag( "bink\Campaign\M60_E_60" );
					hud_rampancy_players_set( 0.50 );
					thread(f_dialog_play_pip_m60_e_subtitles());
					
					sleep_s(4);

					hud_rampancy_players_set( 0.0 );		
					
					//	dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00104', FALSE, NONE, 0.0, "", "Dr. Halsey : -you’re patterned off of me, Cortana; of course you’ll take care of him-", TRUE);
					//	hud_play_pip_from_tag( "" );
					//	dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00105a', FALSE, NONE, 0.0, "", "Cortana : You said you wanted to see Dr. Halsey…" );
					//	dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00106', FALSE, NONE, 0.0, "", "Cortana : Does that seem alright to you?" );
					//	dialog_line_chief( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00107', FALSE, NONE, 0.0, "", "Master Chief : Cortana…" );
					//	dialog_line_cortana( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00108', FALSE, NONE, 0.0, "", "Cortana : Don’t worry." );
				//		dialog_line_cortana( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00109', FALSE, NONE, 0.0, "", "Cortana : I’m taking care of it." );
					//	dialog_line_cortana( l_dialog_id, 10, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00110', FALSE, NONE, 0.0, "", "Cortana : It’s Ok." );
					
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_play_pip_m60_e_subtitles()
	sleep(64);
	dialog_play_subtitle('sound\dialog\mission\m60\rampancy_hall_00100');
	dialog_play_subtitle('sound\dialog\mission\m60\rampancy_hall_00101');
	sleep(37);
	dialog_play_subtitle('sound\dialog\mission\m60\rampancy_hall_00102');
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m60\rampancy_hall_00103');
end

script dormant f_dialog_m60_covenant_forerun_coop()
dprint("f_dialog_m60_covenant_forerun_coop");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_COVENANT_FORERUN_COOP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    												
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00112', FALSE, NONE, 0.0, "", "Cortana : Knight! Wait - what's he doing?" );
						dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00114', FALSE, NONE, 0.0, "", "Master Chief : Covenant?" );
						sleep_s(2);
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00115', FALSE, NONE, 0.0, "", "Cortana : They’re working with the Prometheans!" );
						//dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\rampancy_hall_00116', FALSE, NONE, 0.0, "", "Cortana : Just what we needed." );					  
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
  


script dormant f_dialog_m60_covenant_forerun_coop_02()
dprint("f_dialog_m60_plinth_progress");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PLINTH_PROGRESS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					   dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\cave_combat_00100', FALSE, NONE, 0.0, "", "Cortana : I’m shocked how quickly the Didact has unified these Covenant!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_pelican_approach_lasky()
dprint("f_dialog_m60_pelican_approach_lasky");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PELICAN_APPROACH_LASKY", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    											  
						//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\cave_cleared_00100', FALSE, NONE, 0.0, "", "Cortana : Cortana to Lasky. LZ is secured." );
							
						start_radio_transmission( "lasky_transmission_name" );
						hud_play_pip_from_tag( "bink\Campaign\M60_F_60" );
						thread(f_dialog_play_pip_m60_f_subtitles());

						sleep_s(31);
						end_radio_transmission();
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script static void f_dialog_play_pip_m60_f_subtitles()
	dialog_play_subtitle('sound\dialog\mission\m60\cave_cleared_00100');
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00100');
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00101');
	sleep(3);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00102');
	sleep(36);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00103');
	sleep(1);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00104');
	sleep(4);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00105');
	sleep(34);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00106');
	sleep(31);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00107');
	sleep(15);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00108');
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m60\pelican_approach_lasky_00109');
end

script dormant f_dialog_m60_pelican_chief_welcome()
dprint("f_dialog_m60_pelican_chief_welcome");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_PELICAN_CHIEF_WELCOME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    					
						start_radio_transmission( "pelican595_transmission_name" );	
					   dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\pelican_chief_welcome_00100', FALSE, NONE, 0.0, "", "Pelican Pilot : This is Pelican 595. We have the Chief on board and are outbound for Rally Point Alpha Sierra Foxtrot.", TRUE);
					  end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


/*script dormant f_dialog_m60_rally_pelican()
dprint("f_dialog_m60_rally_pelican");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
		hud_play_pip_from_tag( "bink\Campaign\M60_G_60" );
					l_dialog_id = dialog_start_foreground( "M60_RALLY_PELICAN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						start_radio_transmission( "lasky_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\rally_pelican_00100', FALSE, NONE, 0.0, "", "Lasky : Lasky to 117.", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\rally_pelican_00101', FALSE, NONE, 0.0, "", "Lasky : We’re dusting off now, en route to Rally Point.", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\rally_pelican_00102', FALSE, NONE, 0.0, "", "Lasky : What’s your status?", TRUE);
							dialog_line_chief( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\rally_pelican_00103', FALSE, NONE, 0.0, "", "Master Chief : The Rally Point’s under attack, Commander." );
							dialog_line_chief( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\rally_pelican_00104', FALSE, NONE, 0.0, "", "Master Chief : I’d suggest diverting if I were you." );
							dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m60\rally_pelican_00105', FALSE, NONE, 0.0, "", "Lasky : 10-4, Master Chief.", TRUE);
							dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\rally_pelican_00106', FALSE, NONE, 0.0, "", "Lasky : Correcting our approach and will rendezvous at Infinity.", TRUE);
							dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m60\rally_pelican_00107', FALSE, NONE, 0.0, "", "Lasky : Lasky out.", TRUE);
						 end_radio_transmission();
						 hud_play_pip_from_tag( "" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end*/

script dormant f_dialog_m60_rally_chief_onme()
dprint("f_dialog_m60_rally_chief_onme");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_RALLY_CHIEF_ONME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					  dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\rally_chief_onme_00100', FALSE, sq_hum_rally_infantry.p0, 0.0, "", "Spartan IV - A : Crimson team!  Sierra 117 is on the ground.  Form up on him!", TRUE);
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\rally_chief_onme_00101', FALSE, NONE, 0.0, "", "Cortana : Weapons free, Chief!" );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\rally_chief_onme_00102', FALSE, NONE, 0.0, "", "Cortana : Let ‘em have it!" );
						//dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\rally_chief_onme_00103', FALSE, NONE, 0.0, "", "Spartan IV - A : Dash tens - on the Chief.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_rally_spartans()
dprint("f_dialog_m60_rally_spartans");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_RALLY_SPARTANS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					 // dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_soundstory_00123', FALSE, sq_hum_rally_infantry.p1, 0.0, "", "Spartan 1 : It's on now!", TRUE);
						//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00124', FALSE, NONE, 0.0, "", "Spartan 2 : Everybody gear up!", TRUE);
					//	dialog_line_npc( l_dialog_id, 1, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_soundstory_00126', FALSE, sq_hum_rally_infantry.p2, 0.0, "", "Spartan 2 : Remember your training, people!", TRUE);
					//	dialog_line_npc( l_dialog_id, 2, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_soundstory_00127', FALSE, sq_hum_rally_infantry.p3, 0.0, "", "Marine 2 : ROE suspended -- weapons free!", TRUE);
						dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_spartanchatter_00106', FALSE, sq_hum_rally_infantry.p0, 0.0, "", "Spartan IV-C : Ground teams, be advised. The Master Chief is on the field. Advancing.", TRUE);
				//		dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\m60_spartanchatter_00101', FALSE, NONE, 0.0, "", "Spartan IV-B : Master Chief, Crimson Team’s at your disposal. Lead the way.", TRUE);
				//		dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m60\m60_spartanchatter_00102', FALSE, NONE, 0.0, "", "Spartan IV-C : Where do you want us, sir?", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
			



script dormant f_dialog_m60_scorpionenter()
dprint("f_dialog_m60_scorpionenter");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SCORPIONENTER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					 		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_scorpionenter_00103', FALSE, NONE, 0.0, "", "Cortana : We're good to go, Chief. Let’s show these Spartans how it's done." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 wake(f_dialog_m60_rally_spartans);
end	



script dormant f_dialog_m60_infinityrun()
dprint("f_dialog_m60_infinityrun");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYRUN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
				start_radio_transmission( "lasky_transmission_name" );	
					dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityrun_00100', FALSE, NONE, 0.0, "", "Lasky: 117, Lasky. We're touching down just north of your position. Proceed to Starboard Hanger 2-19 and we'll link up with you there.", TRUE);
				end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinityrun_02()
dprint("f_dialog_m60_infinityrun_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYRUN_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_ext_00100', FALSE, NONE, 0.0, "", "Cortana : Commander, the hangar bay doors are sealed tight." );
					start_radio_transmission( "lasky_transmission_name" );
					dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinity_ext_00101a', FALSE, NONE, 0.0, "", "Lasky : Roger, Cortana. We'll find a way inside and free up one of the mooring platforms. XO out.", TRUE);
					//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinity_ext_00101', FALSE, NONE, 0.0, "", "Lasky : They must have initiated quarantine protocols.", TRUE);
				//	dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\infinity_ext_00102', FALSE, NONE, 0.0, "", "Lasky : We’ll find a way inside and open them up for you.", TRUE);
					//dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinity_ext_00103', FALSE, NONE, 0.0, "", "Lasky : XO out.", TRUE);
					end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ext()
dprint("f_dialog_m60_infinity_ext");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_EXT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    					
					start_radio_transmission( "lasky_transmission_name" );	
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_ext_00104', FALSE, NONE, 0.0, "", "Lasky : Chief, Lasky.", TRUE);
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinity_ext_00105', FALSE, NONE, 0.0, "", "Lasky : We’re inside!", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\lasky_clear_berth_00100', FALSE, NONE, 0.0, "", "Lasky : Clear out the area and we'll open her up for you.", TRUE);
					end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ext_cleared()
dprint("f_dialog_m60_infinity_ext_cleared");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_EXT_CLEARED", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						start_radio_transmission( "lasky_transmission_name" );
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_infinity_ext_00105b', FALSE, NONE, 0.0, "", "Lasky : Opening the bay doors now!", TRUE);
						end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end
						

script dormant f_dialog_m60_infinity_ext_02()
dprint("f_dialog_m60_infinity_ext_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_EXT_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 ); 
					start_radio_transmission( "lasky_transmission_name" );   						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\lasky_clear_berth_00101', FALSE, NONE, 0.0, "", "Lasky : Secure the bay from those Covenant, and I’ll release the lockdown into the ship.", TRUE);
					end_radio_transmission();
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinityberth_tocauseway()
dprint("f_dialog_m60_infinityberth_tocauseway");
local long l_dlg_m60_infinityberth_tocauseway = DEF_DIALOG_ID_NONE();
					l_dlg_m60_infinityberth_tocauseway = dialog_start_foreground( "M60_INFINITYBERTH_TOCAUSEWAY", l_dlg_m60_infinityberth_tocauseway, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
					
			  		hud_play_pip_from_tag( "bink\Campaign\M60_H_60" );
					thread(f_dialog_play_pip_m60_h_subtitles());
					
			  		start_radio_transmission( "delrio_transmission_name" );

					sleep_s(35);
					
					end_radio_transmission();
					hud_play_pip_from_tag( "" );
					
				 l_dlg_m60_infinityberth_tocauseway = dialog_end( l_dlg_m60_infinityberth_tocauseway, TRUE, TRUE, "" );
				 thread (inifinityberth_mechdata());
end

script static void f_dialog_play_pip_m60_h_subtitles()
	sleep(25);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00100');
	sleep(5);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00101');
	sleep(30);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00102');
	sleep(5);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00103');
	sleep(20);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00104');
	sleep(20);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00105');
	sleep(5);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00106');
	sleep(25);
	dialog_play_subtitle('sound\dialog\mission\m60\infinityberth_tocauseway_00107');
end

script dormant f_dialog_m60_inifinityberth_mechdata()
dprint("f_dialog_m60_inifinityberth_mechdata");

					l_dlg_inifinityberth_mechdata = dialog_start_foreground( "M60_INFINITYBERTH_MECHDATA", l_dlg_inifinityberth_mechdata, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dlg_inifinityberth_mechdata, 0, TRUE, 'sound\dialog\mission\m60\infinityberth_premech_00100', FALSE, NONE, 0.0, "", "Cortana : That deployment console should open the Mantis bay." );
				 l_dlg_inifinityberth_mechdata = dialog_end ( l_dlg_inifinityberth_mechdata, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_inifinityberth_system_mech()
dprint("f_dialog_m60_inifinityberth_system_mech");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYBERTH_SYSTEM_MECH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00108', FALSE, NONE, 0.0, "", "Infinity System Voice : Warning. Operation of Mantis Armored Defense System prohibited without prior approval.", TRUE);
							//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00101', FALSE, NONE, 0.0, "", "Cortana : Just how you like them: big, ugly, and overflowing with machine guns and rocket launchers." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end




script dormant f_dialog_m60_inifinityberth_enter_mech()
dprint("f_dialog_m60_inifinityberth_mechdata");
		dialog_end_interrupt(l_dlg_inifinityberth_mechdata);
		sleep_forever(f_dialog_m60_inifinityberth_mechdata);
		kill_script(f_dialog_m60_inifinityberth_mechdata);
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYBERTH_ENTER_MECH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00102', FALSE, NONE, 0.0, "", "Cortana : The hatch to the maintenance causeway is jammed." );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00104', FALSE, NONE, 0.0, "", "Cortana : Let’s do something about it." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end





script dormant f_dialog_m60_inifinityberth_try_to_leave()
dprint("f_dialog_m60_inifinityberth_mechdata");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYBERTH_MECHDATA", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00105', FALSE, NONE, 0.0, "", "Cortana : The captain promised you firepower." );
						dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00106', FALSE, NONE, 0.0, "", "Cortana : This sure seems like an appropriate use for it." );
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinityberth_mechdata_00107', FALSE, NONE, 0.0, "", "Cortana : Look for the Mantis controls." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinitycauseway_stomp()
dprint("f_dialog_m60_infinitycauseway_stomp");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYCAUSEWAY_STOMP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinitycauseway_stomp_00100', FALSE, NONE, 0.0, "", "Cortana : You know, if shooting doesn’t work, you can always try stepping on them." );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinitycauseway_stomp_00101', FALSE, NONE, 0.0, "", "Cortana : You ARE bigger than they are, after all." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_inifinitycauseway_broadswordassault_end()
dprint("f_dialog_m60_inifinitycauseway_broadswordassault_end");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYCAUSEWAY_BROADSWORDASSAULT_END", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\inifinitycauseway_broadswordassault_end_00700', FALSE, NONE, 0.0, "", "Cortana : There's a cargo elevator at the far end of the causeway. That'll take us out to the deck." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinity_elevator()
dprint("f_dialog_m60_infinity_elevator");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_ELEVATOR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    													
					    start_radio_transmission( "lasky_transmission_name" );
								dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00100', FALSE, NONE, 0.0, "", "Lasky : Chief, it's Lasky.  Come in!", TRUE);
								dialog_line_chief( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00101', FALSE, NONE, 0.0, "", "Master Chief : Go, commander." );
								dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00102', FALSE, NONE, 0.0, "", "Lasky : Chief, we’ve identified several Covenant jamming devices on the outer hull.", TRUE);
								dialog_line_cortana( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00103', FALSE, NONE, 0.0, "", "Cortana : That might be how they’re blocking the Infinity’s defenses." );
								dialog_line_npc( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00104', FALSE, NONE, 0.0, "", "Lasky : Exactly what we were thinking. ", TRUE);
								dialog_line_npc( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00105', FALSE, NONE, 0.0, "", "Lasky : Neutralize them so we can get our guns back online and show them that satellite we’re more than just a big paperweight.", TRUE);
							end_radio_transmission();
								dialog_line_cortana( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\infinity_elevator_00106', FALSE, NONE, 0.0, "", "Cortana : We're on it, Commander.  Cortana out." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_berth_exit_grunts()
//dprint("f_dialog_m60_berth_exit_grunts");
local long l_dlg_m60_berth_exit_grunts = DEF_DIALOG_ID_NONE();
					
            l_dlg_m60_berth_exit_grunts = dialog_start_background( "ATRIUM_RETURN_COVENANT_02", l_dlg_m60_berth_exit_grunts, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
								dialog_line_npc( l_dlg_m60_berth_exit_grunts, 1, TRUE, 'sound\dialog\mission\m80\m80_atrium_hallway_00109', FALSE, NONE, 0.0, "", "Multiple Grunts : DIDACT DIDACT DIDACT!!!", TRUE);
            l_dlg_m60_berth_exit_grunts = dialog_end( l_dlg_m60_berth_exit_grunts, TRUE, TRUE, "" );
           // thread( f_berth_narrative_distance_trigger(inf_cause_gr_kami.spawn_points_0) );
				
end


script dormant f_dialog_m60_berth_exit_grunts_02()
//dprint("f_dialog_m60_berth_exit_grunts");
local long l_dlg_m60_berth_exit_grunts = DEF_DIALOG_ID_NONE();
					
            l_dlg_m60_berth_exit_grunts = dialog_start_background( "ATRIUM_RETURN_COVENANT_02", l_dlg_m60_berth_exit_grunts, TRUE, DEF_DIALOG_STYLE_QUEUE(), TRUE, "", 0.25 );                       								
					 			dialog_line_npc( l_dlg_m60_berth_exit_grunts, 0, TRUE, 'sound\dialog\mission\m80\m80_atrium_hallway_00106', FALSE, inf_cause_gr_kami.spawn_points_1, 0.0, "", "Grunt 1 : COM-PO-SER!!!", TRUE);
            l_dlg_m60_berth_exit_grunts = dialog_end( l_dlg_m60_berth_exit_grunts, TRUE, TRUE, "" );
           // thread( f_berth_narrative_distance_trigger(inf_cause_gr_kami.spawn_points_0) );
				
end
script dormant f_dialog_m60_jammer_01()
dprint("f_dialog_m60_jammer_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_JAMMER_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_start_00100', FALSE, NONE, 0.0, "", "Cortana : I see the jammers. Three of them. Shoot them down." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_jammer_02()
dprint("f_dialog_m60_jammer_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_JAMMER_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_start_00101', FALSE, NONE, 0.0, "", "Cortana : First jammer disabled!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_jammer_03()
dprint("f_dialog_m60_jammer_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_JAMMER_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_start_00102', FALSE, NONE, 0.0, "", "Cortana : That’s two!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_jammer_04()
dprint("f_dialog_m60_jammer_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_JAMMER_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_start_00103', FALSE, NONE, 0.0, "", "Cortana : That’s it - jammers neutralized." );
						//dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_start_00104', FALSE, NONE, 0.0, "", "Cortana : Hold off the Covenant while the gun batteries cycle up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_gunsprompt()
dprint("f_dialog_m60_gunsprompt");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_GUNSPROMPT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_gunsprompt_00103', FALSE, NONE, 0.0, "", "Cortana : Hold firm, Chief! Don’t give them an inch!" );
							dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\m60_gunsprompt_00104', FALSE, NONE, 0.0, "", "Cortana : Elements targeting the guns! Push them back!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_delrio_warning()
dprint("f_dialog_m60_delrio_warning");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_DELRIO_WARNING", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    										
					start_radio_transmission( "delrio_transmission_name" );									
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_delrio_warning_00100', FALSE, NONE, 0.0, "", "Del Rio : Del Rio to Master Chief. The rate that satellite’s searching our systems just doubled! I think it knows what we’re up to.", TRUE);						
						//dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_delrio_warning_00102', FALSE, NONE, 0.0, "", "Del Rio : I think it knows what we’re up to.", TRUE);
					end_radio_transmission();
						dialog_line_cortana( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_delrio_warning_00103', FALSE, NONE, 0.0, "", "Cortana : The Didact’s not letting go without a fight." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinityouterdeck_gunsonline()
dprint("f_dialog_m60_infinityouterdeck_gunsonline");
//local long l_dialog_id = DEF_DIALOG_ID_NONE();
			//		l_dialog_id = dialog_start_foreground( "M60_INFINITYCAUSEWAY_GUNSONLINE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    													
				//		dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_gunsonline_00100', FALSE, NONE, 0.0, "", "Cortana : Gun battery one, online and cleared to fire!" );
				//		dialog_line_cortana( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_gunsonline_00101', FALSE, NONE, 0.0, "", "Cortana : Keep your eyes peeled." );
			//	 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_inifinitycauseway_second_gun()
dprint("f_dialog_m60_inifinitycauseway_second_gun");

//local long l_dialog_id = DEF_DIALOG_ID_NONE();
			/*		l_dialog_id = dialog_start_foreground( "M60_INFINITYCAUSEWAY_SECOND_GUN", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_gunsonline_00102', FALSE, NONE, 0.0, "", "Cortana : Second gun’s hot!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );*/
end

script dormant f_dialog_m60_infinityouterdeck_mac_warmup()
dprint("f_dialog_m60_infinityouterdeck_mac_warmup");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYOUTERDECK_MAC_WARMUP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    													
							//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_warmup_00104', FALSE, NONE, 0.0, "", "Cortana : Chief, take out the rest of the Covenant." );

				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_infinityouterdeck_mac_ready()
dprint("f_dialog_m60_infinityouterdeck_mac_ready");
local long l_dlg_infinityouterdeck_mac_ready = DEF_DIALOG_ID_NONE();
					l_dlg_infinityouterdeck_mac_ready = dialog_start_foreground( "M60_INFINITYOUTERDECK_MAC_READY", l_dlg_infinityouterdeck_mac_ready, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    													
						start_radio_transmission( "delrio_transmission_name" );
							dialog_line_npc( l_dlg_infinityouterdeck_mac_ready, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_ready_00100', FALSE, NONE, 0.0, "", "Del Rio : Captain Del Rio to Sierra 117.", TRUE);
							dialog_line_npc( l_dlg_infinityouterdeck_mac_ready, 1, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_ready_00101', FALSE, NONE, 0.0, "", "Del Rio : The MAC network’s reading operational but our EM relays are malfunctioning.  You’ll have to reinitiate the link manually.", TRUE);
							//dialog_line_cortana( l_dlg_infinityouterdeck_mac_ready, 2, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_ready_00103', FALSE, NONE, 0.0, "", "Cortana : The auxilliary firing controls are at the top of the center platform." );
							//dialog_line_npc( l_dlg_infinityouterdeck_mac_ready, 2, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_ready_00101a', FALSE, NONE, 0.0, "", "Del Rio : The Mass Driver network's reading operational, but our EM relays are malfunctioning.", TRUE);
							//dialog_line_npc( l_dlg_infinityouterdeck_mac_ready, 2, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_mac_ready_00102', FALSE, NONE, 0.0, "", "Del Rio : You’ll have to reinitiate the link manually.", TRUE);
						end_radio_transmission();	
				 l_dlg_infinityouterdeck_mac_ready = dialog_end( l_dlg_infinityouterdeck_mac_ready, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinityouterdeck_success()
dprint("f_dialog_m60_infinityouterdeck_success");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITYOUTERDECK_SUCCESS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    		
					dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00099', FALSE, NONE, 0.0, "", "Cortana : That's it. MAC controls restored!" );
					  start_radio_transmission( "delrio_transmission_name" ); 											
							dialog_line_npc( l_dialog_id, 1, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00100', FALSE, NONE, 0.0, "", "Del Rio : Forward MAC controls - get that damn orb away from my ship.", TRUE);
							dialog_line_npc( l_dialog_id, 2, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00101', FALSE, NONE, 0.0, "", "Del Rio : All cannons.", TRUE);
							dialog_line_npc( l_dialog_id, 3, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00102', FALSE, NONE, 0.0, "", "Del Rio : Fire at will.", TRUE);
							sleep_s(3);
							dialog_line_cortana( l_dialog_id, 4, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00103', FALSE, NONE, 0.0, "", "Cortana : It's working." );
							dialog_line_cortana( l_dialog_id, 5, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00104', FALSE, NONE, 0.0, "", "Cortana : The Didact's retreating!" );
							dialog_line_npc( l_dialog_id, 6, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00105', FALSE, NONE, 0.0, "", "Del Rio : Del Rio to Infinity All Hands.", TRUE);
							dialog_line_npc( l_dialog_id, 7, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00106', FALSE, NONE, 0.0, "", "Del Rio : We are Condition Yellow.", TRUE);
							dialog_line_npc( l_dialog_id, 8, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00107', FALSE, NONE, 0.0, "", "Del Rio : Stand down.", TRUE);
							dialog_line_npc( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00108', FALSE, NONE, 0.0, "", "Del Rio : Section heads report in, begin damage assessment.", TRUE);
						end_radio_transmission();	
							//dialog_line_cortana( l_dialog_id, 9, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00109', FALSE, NONE, 0.0, "", "Cortana : We better get inside." );
						//	dialog_line_cortana( l_dialog_id, 10, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00110', FALSE, NONE, 0.0, "", "Cortana : They’re bound to have questions." );
							//dialog_line_chief( l_dialog_id, 11, TRUE, 'sound\dialog\mission\m60\infinityouterdeck_success_00111', FALSE, NONE, 0.0, "", "Master Chief : They’re not the only ones." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_n60_callout_banshees()
dprint("f_dialog_callout_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00126', FALSE, NONE, 0.0, "", "Cortana : Banshees!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


// =================================================================================================
// =================================================================================================
// NUDGES
// =================================================================================================
// =================================================================================================

script static void f_dialog_m60_nudge_1()
dprint("f_dialog_m60_nudge_1");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_1_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_1", l_dialog_id,  (not b_objective_1_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_laskyprompt_00100', FALSE, NONE, 0.0, "", "Cortana : If Lasky’s transmission was any indication, his people need our help. We’ve got to find them ASAP." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_1_complete, b_objective_1_complete, "" );
		end
end

script static void f_dialog_m60_nudge_2()
dprint("f_dialog_m60_nudge_2");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_2_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_2", l_dialog_id,  (not b_objective_2_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_lzprompt_00101', FALSE, NONE, 0.0, "", "Cortana : These teams won’t last for long out here. Finding an LZ should be our top priority." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_2_complete, b_objective_2_complete, "" );
		end
end



script static void f_dialog_m60_nudge_3()
dprint("f_dialog_m60_nudge_3");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_3_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_3", l_dialog_id,  (not b_objective_3_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
								dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_holdthehillprompt_00101', FALSE, NONE, 0.0, "", "Cortana : Giving up this location’s not an option, Chief. Lock it down!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_3_complete, b_objective_3_complete, "" );
		end
end

script static void f_dialog_m60_nudge_4()
dprint("f_dialog_m60_nudge_4");
/*static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_4_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_4", l_dialog_id,  (not b_objective_4_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 							
								//dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_infinityprompt_00100', FALSE, NONE, 0.0, "", "Cortana : Chief, I’m reading all sorts of chatter from Infinity! We’ve got to get up there!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_4_complete, b_objective_4_complete, "" );
		end*/
end


script static void f_dialog_m60_nudge_5()
local short s_random = 0;
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	s_random = random_range(1, 5);
	
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_5_complete)) then
				if s_random == 1 then
					l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_5_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_outerdeckprompt_00100', FALSE, NONE, 0.0, "", "Cortana : Infinity TAC-COM is reporting additional contacts on the outer deck! Pick it up, Chief!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
				elseif s_random == 2 then
				l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_5_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_outerdeckprompt_00101', FALSE, NONE, 0.0, "", "Cortana : Cortana : Chief, we can’t let the Didact get access to Infinity’s data stores! Let’s get topside!" );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
				elseif s_random == 3 then
					l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_5_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_outerdeckprompt_00102', FALSE, NONE, 0.0, "", "Cortana : We’re not doing Infinity any good down here if the Didact’s linked in from the outer hull." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
				
				elseif s_random == 4 then
					l_dialog_id = dialog_start_foreground( "NUDGE_5", l_dialog_id,  (not b_objective_5_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_outerdeckprompt_00103', FALSE, NONE, 0.0, "", "Cortana : The Captain said the Didact’s linked in from the outer deck. That’s where we want to be." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_5_complete, b_objective_5_complete, "" );
					
				
				end
		end
end

script static void f_dialog_m60_nudge_6()
dprint("f_dialog_m60_nudge_6");
static long l_dialog_id = DEF_DIALOG_ID_NONE();
		if ( (not dialog_foreground_id_active_check(l_dialog_id)) and  (not b_objective_6_complete)) then
					l_dialog_id = dialog_start_foreground( "NUDGE_6", l_dialog_id,  (not b_objective_6_complete), DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.0 ); 
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_gunsprompt_00102', FALSE, NONE, 0.0, "", "Cortana : We just need to hold them off until the defenses are back online." );
				 l_dialog_id = dialog_end( l_dialog_id, b_objective_6_complete, b_objective_6_complete, "" );
		end
end





// =================================================================================================
// =================================================================================================
// SOUND STORY
// =================================================================================================
// =================================================================================================



script dormant f_dialog_m60_swamp_marine_1()
dprint("f_dialog_m60_swamp_marine_1");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SWAMP_MARINE_1", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00100_soundstory', FALSE, swamp_marine_1, 0.0, "", "Swamp Marine 1: What the hell are these things?!?", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_swamp_marine_2()
dprint("f_dialog_m60_swamp_marine_2");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SWAMP_MARINE_2", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00103_soundstory', FALSE, swamp_marine_2, 0.0, "", "Swamp Marine 4 : What happened to Lasky?", TRUE);

				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_swamp_marine_3()
dprint("f_dialog_m60_swamp_marine_3");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SWAMP_MARINE_3", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00107_soundstory', FALSE, swamp_marine_3, 0.0, "", "[Swamp Marine 3] Covenant? [Swamp Marine 4] Something else! [Swamp Marine 5] They look Forerunner!", TRUE);
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_swamp_marine_4()
dprint("f_dialog_m60_swamp_marine_4");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SWAMP_MARINE_4", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00113_soundstory', FALSE, swamp_marine_4, 0.0, "", "[Swamp Marine 4] Multiple contacts! [Swamp Marine 5] 12 o'clock! 4 o'clock! 9 o'clock! [Swamp Marine 1] These things are everywhere!", TRUE);
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_swamp_marine_5()
dprint("f_dialog_m60_swamp_marine_5");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_SWAMP_MARINE_5", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_soundstory_00119_soundstory', FALSE, swamp_marine_5, 0.0, "", "Somebody woke up the locals!", TRUE);
						
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script static void f_dialog_m60_rally_point_01
dprint( "f_dialog_m60_rally_point_01" );
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

	
		l_dialog_id = dialog_start_foreground( "f_dialog_m60_rally_point_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_spartanchatter_00103', FALSE, sq_hum_rally_infantry.p3, 0.0, "", "Spartan IV-D : I've got the Chief’s back.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );

		



end



script static void f_dialog_m60_rally_point_02
dprint( "f_dialog_m60_rally_point_02" );
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

		l_dialog_id = dialog_start_foreground( "f_dialog_m60_rally_point_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_spartanchatter_00104', FALSE, sq_hum_rally_infantry.p0, 0.0, "", "Spartan IV-A : Covering fire.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );


end

script static void f_dialog_m60_rally_point_03
dprint( "f_dialog_m60_rally_point_03" );
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();

		l_dialog_id = dialog_start_foreground( "f_dialog_m60_rally_point_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_spartanchatter_00105', FALSE, sq_hum_rally_infantry.p1, 0.0, "", "Spartan IV-B : Suppressing fire.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );



end

script static void f_dialog_m60_rally_point_04
dprint( "f_dialog_m60_rally_point_04" );
	
	local long l_dialog_id = DEF_DIALOG_ID_NONE();


		l_dialog_id = dialog_start_foreground( "f_dialog_m60_rally_point_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_SKIP(), TRUE, "", 0.0 );
			dialog_line_npc( l_dialog_id, 0, not ai_allegiance_broken(player, human), 'sound\dialog\mission\m60\m60_spartanchatter_00107', FALSE, sq_hum_rally_infantry.p3, 0.0, "", "Spartan IV-D : Bravo zulu, 117.", TRUE);
		l_dialog_id = dialog_end( l_dialog_id, TRUE, FALSE, "" );


end

script dormant f_dialog_m60_infinity_ship_pa_01()
dprint("f_dialog_m60_infinity_ship_pa_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00100', FALSE, audio_infinitypa1, 0.0, "", "Ship PA : ALERT. HULL BREACH ON DECKS 13 SECTOR 5, DECK 25 SECTOR 12, DECK 131 SECTOR 7, DECK 270, DECK 895", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ship_pa_02()
dprint("f_dialog_m60_infinity_ship_pa_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00102', FALSE, audio_infinitypa2, 0.0, "", "Ship PA : INTRUSION ALERT. INTRUSION ALERT. SECURITY REQUESTED IN FORWARD WEAPON BATTERY, DECK 2, SECTOR 15.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ship_pa_03()
dprint("f_dialog_m60_infinity_ship_pa_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00103', FALSE, audio_infinitypa4, 0.0, "", "Ship PA : MEDICAL EMERGENCY. ANY AVAILABLE MEDICAL STAFF TO REPORT TO SOUTH PROMENADE, MAIN KIOSK.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinity_ship_pa_04()
dprint("f_dialog_m60_infinity_ship_pa_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
							dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00104', FALSE, audio_infinitypa3, 0.0, "", "Ship PA : FIRE SUPPRESSION SYSTEMS FAILURE. MANUAL INTERVENTION REQUIRED. PLEASE CONTACT FIRE SAFETY WARDEN FOR YOUR SECTOR IMMEDIATELY.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ship_pa_05()
dprint("f_dialog_m60_inifinitycauseway_second_gun");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
					dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00105', FALSE, audio_infinitypa5, 0.0, "", "Ship PA : WARNING - UNSC INFINITY HAS DESCENDED BELOW MINIMUM SAFE ALTITUDE. INTERNAL ATMOSPHERIC PRESSURE UNSTABLE.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_infinity_ship_pa_06()
dprint("f_dialog_m60_infinity_ship_pa_06");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_06", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
					dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00106', FALSE, audio_infinitypa6, 0.0, "", "Ship PA : ATTENTION, MASS DEPLOYMENT BAY VESSELS. EMERGENCY MOORING PROCEDURE INITIATED. BAY DOORS WILL NOT RESPOND TO TRAFFIC CONTROL REQUESTS.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_infinity_ship_pa_07()
dprint("f_dialog_m60_infinity_ship_pa_07");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_background( "M60_SHIP_PA_07", l_dialog_id, TRUE, DEF_DIALOG_STYLE_PLAY(), FALSE, "", 0.25 );    						
					dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\infinity_shippa_00101', FALSE, audio_infinitypa7, 0.0, "", "Ship PA : CONDITION RED. ALL PERSONNEL TO EMERGENCY STATIONS. CONDITION RED -- ALL PERSONNEL TO EMERGENCY STATIONS.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

// =================================================================================================
// =================================================================================================
// SECONDARY ELEMENTS
// =================================================================================================
// =================================================================================================



script static void f_dialog_m60_infinity_secondary_01()
dprint("f_dialog_m60_infinity_secondary_01");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_01", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00100', FALSE, audio_infinity_secondary_pa01, 0.0, "", "Infinity System Voice : Access denied. Huragok population reserve accepts absolutely no personnel during category three emergency states and higher.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 object_create(infinity_secondary_01);
				 thread(m60_infinity_secondary_01());
				 
end

script static void f_dialog_m60_infinity_secondary_02()
dprint("f_dialog_m60_infinity_secondary_02");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_02", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00101', FALSE, audio_infinity_secondary_pa02, 0.0, "", "Infinity System Voice : Sub-vessel deployment bay is currently off limits to unauthorized personnel. Please see the local Deck Officer for further assistance.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 object_create(infinity_secondary_02);
				 thread(m60_infinity_secondary_02());
end


script static void f_dialog_m60_infinity_secondary_03()
dprint("f_dialog_m60_infinity_secondary_03");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_03", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00102', FALSE, audio_infinity_secondary_pa03, 0.0, "", "Infinity System Voice : Maintenance requests concerning the Mark Ten Macedon Z-PROTOTYPE Forerunner engine cannot be processed at this time.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 object_create(infinity_secondary_03);
				 thread(m60_infinity_secondary_03());
end


script static void f_dialog_m60_infinity_secondary_04()
dprint("f_dialog_m60_infinity_secondary_04");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_04", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00103', FALSE, audio_infinity_secondary_pa04, 0.0, "", "Infinity System Voice : Welcome to the Infinty Shipwide Waypoint Network. For information concerning--- I’m sorry. We are currently having difficulties processing your request due to the high volume of ---", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 object_create(infinity_secondary_04);
				 thread(m60_infinity_secondary_04());
				 
end

script static void f_dialog_m60_infinity_secondary_05()
dprint("f_dialog_m60_infinity_secondary_05");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_05", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00104', FALSE, audio_infinity_secondary_pa05, 0.0, "", "Infinity System Voice : Infinity Shipwide Waypoint Network currently offline.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 object_create(infinity_secondary_05);
				 thread(m60_infinity_secondary_05());
end

script static void f_dialog_m60_infinity_secondary_06()
dprint("f_dialog_m60_infinity_secondary_06");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_06", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00105', FALSE, audio_infinity_secondary_pa06, 0.0, "", "Infinity System Voice : All S-deck access is restricted until shipwide quarantine has been lifted.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
				 
				 object_create(infinity_secondary_06);
				 thread(m60_infinity_secondary_06());
end

script static void f_dialog_m60_infinity_secondary_07()
dprint("f_dialog_m60_infinity_secondary_07");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_INFINITY_SECONDARY_07", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
						dialog_line_npc( l_dialog_id, 0, TRUE, 'sound\dialog\mission\m60\m60_secondary_00106', FALSE, audio_infinity_secondary_pa07, 0.0, "", "Infinity System Voice : Cargo Unit, Lot 225. Destination: Ivanoff Station. Please consult the Manifest Director if you require immediate access.", TRUE);
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );

				 object_create(infinity_secondary_07);
				 thread(m60_infinity_secondary_07());
end


// =================================================================================================
// =================================================================================================
// CORTANA GLOBALS
// =================================================================================================
// =================================================================================================

script dormant f_dialog_m60_watchers_callout()
dprint("f_dialog_m60_watchers_callout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_WATCHERS_CALLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00162', FALSE, NONE, 0.0, "", "Cortana : Watchers!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_turrets_callout()
dprint("f_dialog_m60_turrets_callout");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_TURRETS_CALLOUT", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00177', FALSE, NONE, 0.0, "", "Cortana : Turrets!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_find_some_cover()
dprint("f_dialog_m60_find_some_cover");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "M60_FIND_SOME_COVER", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    						
							dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00132', FALSE, NONE, 0.0, "", "Cortana : Find some cover!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_callout_additional_forerunners()
dprint("f_dialog_m60_callout_additional_forerunners");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ADDITIONAL_FORERUNNERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00170', FALSE, NONE, 0.0, "", "Cortana : Additional Forerunners inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_callout_on_top_of_us()
dprint("f_dialog_m60_callout_on_top_of_us");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "ADDITIONAL_FORERUNNERS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00153', FALSE, NONE, 0.0, "", "Cortana :	They’re almost on top of us!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_last_of_them()
dprint("f_dialog_m60_callout_last_of_them");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LAST_OF_THEM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00182', FALSE, NONE, 0.0, "", "Cortana : That's the last of them." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_clean_em_up()
dprint("f_dialog_m60_callout_last_of_them");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "LAST_OF_THEM", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00182', FALSE, NONE, 0.0, "", "Cortana : Clean ‘em up." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_ghosts()
dprint("f_dialog_callout_ghosts");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GHOSTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00127', FALSE, NONE, 0.0, "", "Cortana : Ghosts!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_wraith()
dprint("f_dialog_callout_wraith");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WRAITH", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00125', FALSE, NONE, 0.0, "", "Cortana : Wraith!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_inbound()
dprint("f_dialog_callout_inbound");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "INBOUND", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00128', FALSE, NONE, 0.0, "", "Cortana : Inbound!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_callout_were_almost_there()
dprint("f_dialog_callout_were_almost_there");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WERE_ALMOST_THERE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00151', FALSE, NONE, 0.0, "", "Cortana : We're almost there!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_finish_them_off()
dprint("f_dialog_callout_finish_them_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "FINISH_THEM_OFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00248', FALSE, NONE, 0.0, "", "Cortana : Finish them off." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_how_its_done()
dprint("f_dialog_callout_finish_them_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOW_ITS_DONE", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00239', FALSE, NONE, 0.0, "", "Cortana : That’s how it’s done." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_callout_combined_squads()
dprint("f_dialog_callout_combined_squads");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "COMBINED_SQUADS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00172', FALSE, NONE, 0.0, "", "Cortana : Combined squads!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end


script dormant f_dialog_m60_callout_knights()
dprint("f_dialog_callout_knights");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "KNIGHTS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00156', FALSE, NONE, 0.0, "", "Cortana : Knights!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_turrets()
dprint("f_dialog_callout_turrets");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "TURRETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00177', FALSE, NONE, 0.0, "", "Cortana : Turrets!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_heads_up()
dprint("f_dialog_callout_heads_up");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HEADS_UP", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00115', FALSE, NONE, 0.0, "", "Cortana : Heads up!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_banshees()
dprint("f_dialog_callout_banshees");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "BANSHEES", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00126', FALSE, NONE, 0.0, "", "Cortana : Banshees!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_hold_them_off()
dprint("f_dialog_callout_hold_them_off");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "HOLD_THEM_OFF", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00147', FALSE, NONE, 0.0, "", "Cortana : Hold them off!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_callout_more_time()
dprint("f_dialog_callout_more_time");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "MORE_TIME", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00148', FALSE, NONE, 0.0, "", "Cortana : Just a few more minutes!" );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end



script dormant f_dialog_m60_still_seeing_targets()
dprint("f_dialog_still_seeing_targets");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "STILL_SEEING_TARGETS", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00247', FALSE, NONE, 0.0, "", "Cortana : I'm still seeing targets." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_go_to_terminal()
dprint("f_dialog_go_to_terminal");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "GO_TO_TERMINAL", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00222', FALSE, NONE, 0.0, "", "Cortana : Go to the terminal." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end

script dormant f_dialog_m60_were_all_clear()
dprint("f_dialog_were_all_clear");
local long l_dialog_id = DEF_DIALOG_ID_NONE();
					l_dialog_id = dialog_start_foreground( "WERE_ALL_CLEAR", l_dialog_id, TRUE, DEF_DIALOG_STYLE_QUEUE(), FALSE, "", 0.25 );    
						dialog_line_cortana( l_dialog_id, 0, TRUE, 'sound\dialog\mission\global\global_chatter_00183', FALSE, NONE, 0.0, "", "Cortana : OK, we're clear." );
				 l_dialog_id = dialog_end( l_dialog_id, TRUE, TRUE, "" );
end