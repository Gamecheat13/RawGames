//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion_mission_cf
//	Insertion Points:	start 	- Beginning
//	ifo		- fodder
//	ija		- jackal alley
//	ici		- citidel exterior
//	iic		- citidel interior
//	ipo		- powercave/ battery room
//	ili		- librarian encounter			
//  ior		- ordnance training					
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CITADEL ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_citadel_init::: Initialize
script dormant f_citadel_init()
	dprint( "f_citadel_init" );

	// modules init
	wake( f_valley_init );
	wake( f_citadel_ext_init );
	wake( f_citadel_int_init );
	
	//wake( f_librarian_main );

	// XXX MOVE TO BETTER LOCATION
	// cleanup chopper
	object_destroy( chop_hilltop_crate_01 );
	object_destroy( chop_hilltop_crate_02 );

end

// === f_citadel_deinit::: DeInitialize
script dormant f_citadel_deinit()
	dprint( "f_citadel_deinit" );

	// modules deinit
	wake( f_valley_deinit );
	wake( f_citadel_ext_deinit );
	wake( f_citadel_int_deinit );
	
end

// === f_citadel_cleanup::: Cleanup
script dormant f_citadel_cleanup()
	dprint( "f_citadel_cleanup" );

	// deinit main module
	wake( f_citadel_deinit );
	
end



// XXX OLD REORGANIZE VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

// === el_citadel::: xxx
script dormant el_citadel()

	// call init
	wake( f_citadel_init );

	// XXX OLD REORGANIZE
	wake( f_el_citadel_vo );

end

// XXX these are generic functionality that should be built into the doors
script static void f_redlight_on( object door )
	effect_stop_object_marker ("fx\library\light\light_green\light_green.effect", door, "" );  
	sleep(1 );  
	effect_new_on_object_marker ("fx\library\light\light_red\light_red.effect", door, "" );                               
end

script static void f_greenlight_on( object door )
	effect_stop_object_marker ("fx\library\light\light_red\light_red.effect", door, "" ); 
	sleep(1 );
	effect_new_on_object_marker ("fx\library\light\light_green\light_green.effect", door, "" );                                                  
end

script static void f_doorlight_off( object door )
	effect_stop_object_marker ("fx\library\light\light_green\light_green.effect", door, "" );
	sleep(1 );
	effect_stop_object_marker ("fx\library\light\light_red\light_red.effect", door, "" );                                            
end




// =================================================================================================
// =================================================================================================
// VO 
// =================================================================================================
// =================================================================================================

global boolean b_valley_entrance_vo = FALSE;

script dormant forerunner_int_chapter_title()
	sleep (30 * 2 );
	cinematic_show_letterbox (TRUE );
	sleep (30 * 1 );
//	thread( storyblurb_display(leadin_title_frint, 8, FALSE, FALSE) );
	f_chapter_title_2 (leadin_title_frint);
	sleep (30 * 6 );
	cinematic_show_letterbox (FALSE );
end

script dormant f_el_citadel_vo()
/*
		// 125 : Looks like this is as far as the Longhorn’s going to go. Forerunner objective should be accessible on foot from here - recon the target and if you’re able to locate the source of those cannons, don’t feel like you have to wait on us.
		sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Palmer_04000', NONE, 1 );
		sleep (30 * 11 );
			
		// 126 : Roger that.
		sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_04100', NONE, 1 );
		sleep (30 * 1 );
*/
	sleep_until( volume_test_players (tv_spawn_el_citadel), 1 );
		// 10 : We’ll clear out the rubble for the Longhorn to move forward, Chief. You investigate the area to the left.
		//sound_impulse_start ('sound\dialog\Mission\M40\M_M40_Temp_Marine_01100', NONE, 1 );
		
//		storyblurb_display(ch_blurb_sniper_ent_1, 10, FALSE, FALSE );
		//sleep (30 * 5 );
		b_valley_entrance_vo = TRUE;
	sleep_until( volume_test_players (tv_careful_chief), 1 );
		
	sleep_until( b_valley_entrance_vo, 1 );		
		// 127 : Careful, Chief - we’ve got snipers in those rocks.
	//	dprint("Careful, Chief - we’ve got snipers in those rocks." );
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04200', NONE, 1 );
		sleep (30 * 3 );

	sleep_until( volume_test_players (tv_valley_objcon_40) or volume_test_players (tv_cit_entrance_ravine), 1 );	
		// 128 : This installation is deceptively large. It extends deeper into the planet’s surface than I can even detect. Like the tip of a giant pyramid.
		dprint("This installation is deceptively large. It extends deeper into the planet’s surface than I can even detect. Like the tip of a giant pyramid." );
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04300', NONE, 1 );
	//	sleep (30 * 10 );
//		storyblurb_display(ch_blurb_cit_ext_1, 7, FALSE, FALSE );

	//sleep_until( volume_test_players (tv_citent_left_rear) or volume_test_players (tv_citent_right_rear), 1 );			
		
//		storyblurb_display(ch_blurb_citadel_ammo, 8, FALSE, FALSE );
		
end

script dormant f_el_citadel_enter_vo()
	sleep_until( volume_test_players (tv_citadel_ext_airlock_area), 1 );	
		// 129 : Cortana to Infinity. We’ve breached the Forerunner structure and are proceeding inside.
//		sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04400', NONE, 1 );
		//wake (forerunner_int_chapter_title );
		wake (M40_second_promethean_encounter );
	//	sleep (30 * 5 );
		
//		storyblurb_display(ch_blurb_cit_entered, 4, FALSE, FALSE );
		// 130 : This is Del Rio.... barely reading you.... --ansmitting coordinates for...defense grid’s power source... --opy?
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Del_Rio_04500', NONE, 1 );
		//sleep (30 * 8 );
		
		// 131 : Confirming receipt of coordinates, Infinity. Proceeding on mission.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04600', NONE, 1 );
		//sleep (30 * 4 );	
		
	sleep_until( volume_test_players (tv_go_through_that_door), 1 );	
		
		// 132 : Chief, that passageway should lead underne--
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04700', NONE, 1 );
	//	sleep (30 * 3 );
		// 133 : Huh?
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_04800', NONE, 1 );
	//	sleep (30 * 1 );
		
		// 134 : Did you do that?
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_04900', NONE, 1 );
	//	sleep (30 * 1 );
		
		// 135 : Not me. Very strange.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05000', NONE, 1 );
		//sleep (30 * 3 );
		
		// 136 : Um... well THAT’S a new one.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05100', NONE, 1 );
		//sleep (30 * 4 );
		
		// 137 : And you didn’t do that one either?
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_05200', NONE, 1 );
		//sleep (30 * 2 );
		
		// 138 : WHAT ARE YOU ASKING - ‘AM I LOSING THE ABILITY TO KNOW IF I’M OPENING DOORS?!? WELL???’ (recovers) Whoa. OK, this is me shutting up.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05300', NONE, 1 );
		//sleep (30 * 9 );
		
		// 139 : I believe you, Cortana. I’m just used to Forerunner installations trying to keep us out.
		//sound_impulse_start ('sound\dialog\Mission\M40\m_m40_MC_05400', NONE, 1 );
		//sleep (30 * 5 );		

	sleep_until( volume_test_players (tv_elevator_travel_down), 1 );
		// 140 : OK, Chief? This elevator seems to be taking us straight to the coordinates Infinity gave us. Almost like something WANTED us to get those guns offline.
	//	sound_impulse_start ('sound\dialog\Mission\M40\m_m40_Cortana_05500', NONE, 1 );
	//	sleep (30 * 9 );
		
		sleep_until( volume_test_players (tv_battery_setup), 1 );
		// 140 : OK, Chief? This elevator seems to be taking us straight to the coordinates Infinity gave us. Almost like something WANTED us to get those guns offline.
		
		
end