; =================================================================================================
; =================================================================================================
; *** GLOBALS ***
; =================================================================================================
; =================================================================================================

; Debug Options
global boolean b_debug 							= TRUE;
global boolean b_breakpoints				= FALSE;
global boolean b_md_print						=	TRUE;
global boolean b_debug_objectives 	= FALSE;
global boolean b_editor 						= editor_mode();
global boolean b_game_emulate				= FALSE;
global boolean b_cinematics 				= TRUE;
global boolean b_editor_cinematics 	= FALSE;
global boolean b_encounters				 	= TRUE;
global boolean b_dialogue 					= TRUE;
global boolean b_skip_intro					=	FALSE;
//global boolean s_insertion_index		= 0;

; Mission Started
global boolean b_mission_started 		=	FALSE;

; Insertion

//global short s_cavern_ins_idx 			= 0;	;; default / start
//global short s_mammoth_ins_idx 			= 1;	;; default / start
//global short s_fodder_ins_idx 			= 2;	;; default / start
//global short s_lakeside_ins_idx 		= 3;	;; default / start
////global short s_cliffside_ins_idx 		= 4;	;; default / start
//global short s_prechopper_ins_idx 	= 4;	;; default / start
//global short s_chopper_ins_idx 			= 5;	;; default / start
//global short s_waterfall_ins_idx 		= 6;	;; default / start
//global short s_jackal_ins_idx	 			= 7;	;; default / start
//global short s_citadel_ins_idx			= 8;	;; default / start
////global short s_battery_ins_idx			= 11;	;; default / start
//global short s_powercave_ins_idx		= 9;	;; default / start
////global short s_battery_turr_ins_idx	= 12;	;; default / start
//global short s_librarian_ins_idx		= 10;	;; default / start
//global short s_ordnance_ins_idx			= 11;	;; default / start
//global short s_epic_ins_idx 				= 12;	;; default / start


// INSERTION POINTS
script static short DEF_INSERTION_INDEX_CAVERN()								0;		end
script static short DEF_INSERTION_INDEX_MAMMOTH()								1;		end
script static short DEF_INSERTION_INDEX_FODDER()								2;		end
script static short DEF_INSERTION_INDEX_LAKESIDE()							3;		end
//script static short DEF_INSERTION_INDEX_CLIFFSIDE()							04;		end
script static short DEF_INSERTION_INDEX_PRECHOPPER()						4;		end
script static short DEF_INSERTION_INDEX_CHOPPER()								5;		end
script static short DEF_INSERTION_INDEX_WATERFALL()							6;		end
script static short DEF_INSERTION_INDEX_JACKAL()								7;		end
script static short DEF_INSERTION_INDEX_CITADEL()								8;		end
//script static short DEF_INSERTION_INDEX_BATTERY()								10;		end
script static short DEF_INSERTION_INDEX_POWERCAVE()							9;		end
//script static short DEF_INSERTION_INDEX_BATTERY_TURR						12;		end
script static short DEF_INSERTION_INDEX_LIBRARIAN()							10; 	end
//script static short DEF_INSERTION_INDEX_ORDINANCE()							14;		end
script static short DEF_INSERTION_INDEX_EPIC()									11;		end

// test insertion
//script static short DEF_INSERTION_INDEX_CITADEL_EXT_TEST()			109;		end
//script static short DEF_INSERTION_INDEX_CITADEL_INT()						110;		end
//script static short DEF_INSERTION_INDEX_CITADEL_INT_TEST()			111;		end

// ZONE SET INDEXES
script static short DEF_S_ZONESET_CAV()													0;		end
script static short DEF_S_ZONESET_CAV_TORT_GUN()								1;		end
script static short DEF_S_ZONESET_GUN_FODDER()									2;		end
script static short DEF_S_ZONESET_FODDER()											3;		end
script static short DEF_S_ZONESET_FODDER_CHOPPER()							4;		end
script static short DEF_S_ZONESET_CHOPPER_WATERFALL_PRE()				5;		end
script static short DEF_S_ZONESET_WATERFALL_PRE_VALE()					6;		end
script static short DEF_S_ZONESET_PRE_VALE()										7;		end
script static short DEF_S_ZONESET_VALE_VALE()										8;		end
script static short DEF_S_ZONESET_VALE_HALL()										9;		end
script static short DEF_S_ZONESET_HALL_BATTERY()								10;		end
script static short DEF_S_ZONESET_BATTERY()											11;		end
script static short DEF_S_ZONESET_BATTERY_CAVERN()							12;		end
script static short DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE()				13;		end
script static short DEF_S_ZONESET_LIBRARIAN_VALE()							14;		end
//script static short DEF_S_ZONESET_VALE_INFINITY_REAR()					15;		end
//script static short DEF_S_ZONESET_REAR_ORD_EPIC()								16;		end
//script static short DEF_S_ZONESET_PRE_EPIC()										17;		end
script static short DEF_S_ZONESET_EPIC()												15;		end
script static short DEF_S_ZONESET_EPIC_EXIT()										16;		end
script static short DEF_S_ZONESET_TRACTOR()											20;		end
script static short DEF_S_ZONESET_PRE_CHOP_WATER()							21;		end
script static short DEF_S_ZONESET_WATER_PRE()										22;		end
script static short DEF_S_ZONESET_CIN_INTRO()										23;		end
script static short DEF_S_ZONESET_ELE_EPIC()										24;		end
script static short DEF_S_ZONESET_CIN_M041_LIBRARIAN()					25;		end
script static short DEF_S_ZONESET_CIN_M042_END()								26;		end




; Zone Sets
//global short s_zoneset_all					= 0;

; ==========================================s=======================================================
; =================================================================================================
; *** INSERTIONS ***
; =================================================================================================
; =================================================================================================


; =================================================================================================
; CAVERN
; =================================================================================================

script static void ica()
	f_insertion_reset( DEF_INSERTION_INDEX_CAVERN() );
end

script static void ins_cavern()

//	f_insertion_begin( "CAVERN" );
//		f_insertion_zoneload( DEF_S_ZONESET_CIN_INTRO(), FALSE );
//		f_insertion_playerwait();
//		//f_insertion_teleport( XXX.p0, XXX.p1, XXX.p2, XXX.p3 );
//		f_insertion_playerprofile( caverns_profile, FALSE );
//	f_insertion_end();


	f_insertion_begin( "CINEMATIC" );
	
	cinematic_enter( cin_m040_intro, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	switch_zone_set( cin_intro );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
		
	f_start_mission( cin_m040_intro );
	cinematic_exit_no_fade( cin_m040_intro, TRUE ); 
	dprint( "Cinematic exited!" );

//	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
		
//		cinematic_enter(cin_m040_intro, TRUE);
//		cinematic_suppress_bsp_object_creation(TRUE);
//		
////		switch_zone_set (cin_intro);
////		sleep ( 1 );
////		sleep_until (current_zone_set_fully_active() == s_cavern_ins_idx, 1);
////		sleep ( 1 );
//		
//		cinematic_suppress_bsp_object_creation(FALSE);
//		
//		f_start_mission(cin_m040_intro);
//		cinematic_exit_no_fade(cin_m040_intro, TRUE); 
//		
//		print ("Cinematic exited!"); 
//	end

	thread (ins_mammoth());

	// ---------------------------------------------------------------------------------------------

end



; =================================================================================================
; MAMMOTH
; =================================================================================================

script static void ima()
	f_insertion_reset( DEF_INSERTION_INDEX_MAMMOTH() );
end

script static void ins_mammoth()

	f_insertion_begin( "MAMMOTH" );
	f_insertion_zoneload( DEF_S_ZONESET_CAV(), FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_cavern.p0, ps_insertion_cavern.p1,ps_insertion_cavern.p2,ps_insertion_cavern.p3 );
	f_insertion_playerprofile( caverns_profile, FALSE );
	f_insertion_end();

	wake (cavern_cutscene_control);	
	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());	
	
	thread (f_hud_boot_up());
	thread (tort_runover_kills());
	thread (test_pv_out());

	kill_volume_disable (playerkill_soft_lakeside_backtrack);
	soft_ceiling_enable ("caverns_backtrack_01", false);
	soft_ceiling_enable ("caverns_backtrack_02", false);
	soft_ceiling_enable ("caverns_backtrack_03", false);
	soft_ceiling_enable ("cliffside_backtrack_01", false);
	soft_ceiling_enable ("prechop_backtrack_01", false);
	soft_ceiling_enable ("chop_backtrack_01", false);
	soft_ceiling_enable ("prechop_new", false);
		
	effects_distortion_enabled = FALSE; 
	
	thread (fx_skybox_lensflares());
	
	kill_volume_disable (playerkill_soft_fodder_backtrack_01);
	kill_volume_disable (playerkill_soft_prechopper_05);
	
	soft_ceiling_enable (caverns_backtrack_03, false);


	// ---------------------------------------------------------------------------------------------

end



; =================================================================================================
; CANNONFODDER
; =================================================================================================

script static void ifo()
	f_insertion_reset( DEF_INSERTION_INDEX_FODDER() );
end

script static void ins_fodder()

	f_insertion_begin( "FODDER" );
		f_insertion_zoneload( DEF_S_ZONESET_GUN_FODDER(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_fodder.p0, ps_insertion_fodder.p1, ps_insertion_fodder.p2, ps_insertion_fodder.p3 );
		f_insertion_playerprofile( fodder_profile, FALSE );
	f_insertion_end();

	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	b_m40_music_progression = 30;
	object_create_folder (fodder_crates);

	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, tortoise_main_pt.p13);
	
	sleep (1);
		
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_a);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_time_position (main_mammoth, 65);
	unit_recorder_set_playback_rate (main_mammoth, .5);
	unit_recorder_pause (main_mammoth, false);
	
	sleep (1);

	wake (f_fodder_main);
	wake (f_fodder_mammoth_playback);
	
	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());
	thread (f_hud_boot_up());
	thread (tort_runover_kills());
	
	soft_ceiling_enable ("cliffside_backtrack_01", false);
	soft_ceiling_enable ("prechop_backtrack_01", false);
	soft_ceiling_enable ("chop_backtrack_01", false);
				
	object_teleport_to_ai_point (fod_pod_01, pts_fod.tower_location);

	kill_volume_disable (playerkill_soft_lakeside_backtrack);
	kill_volume_disable (playerkill_soft_prechopper_05);

	
	effects_distortion_enabled = FALSE; 
	
	thread (fx_skybox_lensflares());
	
	// ---------------------------------------------------------------------------------------------

end



; =================================================================================================
; LAKESIDE
; =================================================================================================

script static void ila()
	f_insertion_reset( DEF_INSERTION_INDEX_LAKESIDE() );
end

script static void ins_lakeside()

	f_insertion_begin( "LAKESIDE" );
		f_insertion_zoneload( DEF_INSERTION_INDEX_LAKESIDE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lakeside.p0, ps_insertion_lakeside.p1, ps_insertion_lakeside.p2, ps_insertion_lakeside.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
	f_insertion_end();

	b_m40_music_progression = 40;
	thread (tort_runover_kills());

	//----------------------TORTOISE INSERTION SETUP-------------------------------//
	
	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, tortoise_main_pt.p19);
	
	sleep (1);
		
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_a);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_time_position (main_mammoth, 86);
	unit_recorder_set_playback_rate (main_mammoth, .7);
	unit_recorder_pause (main_mammoth, true);
	
	sleep (1);
	
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
	
//	object_create (empty_equipment_case_01);
//	object_create (empty_equipment_case_02);
//	objects_attach (main_mammoth,  "crate_2fl_front_left", empty_equipment_case_01, "");
//	objects_attach (main_mammoth,  "crate_2fl_front_right", empty_equipment_case_02, "");

	//----------------------MARINE INSERTION SETUP-------------------------------//

	wake (tortoise_lakeside_recorded);
	
	object_create (lakeside_insertion_hog_01);
	object_create (lakeside_insertion_hog_02);	
	wake (lakeside_ins_1_marines_spawn);
	ai_place (lakeside_ins_2_marines);
	sleep (1);
	ai_vehicle_enter_immediate (lakeside_ins_2_marines.guy1, lakeside_insertion_hog_02, "warthog_g");
	
	ai_vehicle_reserve_seat (lakeside_insertion_hog_02, "warthog_d", true);
	
//	wake (lakeside_insertion_hog_blip_timer);
//	wake (lakeside_insertion_hog_unblip);
//	wake (lakeside_insertion_hog_2_unblip);
	
	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());
	thread (f_hud_boot_up());
	thread (tort_runover_kills());
	
	thread(cannon_lakeside_motion_new());
	object_cannot_take_damage (cannon_lakeside_new);
		
	object_create (marines_main_hog_01_veh);
	object_create (marines_main_hog_02_veh);
	
	effects_distortion_enabled = FALSE; 
	
	thread (fx_skybox_lensflares());
	
	soft_ceiling_enable ("cliffside_backtrack_01", false);
	soft_ceiling_enable ("prechop_backtrack_01", false);
	soft_ceiling_enable ("chop_backtrack_01", false);	
	soft_ceiling_enable ("prechop_new", false);
	
	
	//--------------------------ENCOUNTER SETUP------------------------------------//

	wake (f_lakeside_enc);
	
	object_create_folder (lakeside_crates);
	
	object_teleport_to_ai_point (lakeside_pod, lakeside_teleport_pt.lakeside_pod_location);
	
	kill_volume_disable (playerkill_soft_lakeside_backtrack);
	kill_volume_disable (playerkill_soft_prechopper_05);
	
//	cinematic_set_title (chapter_03);	

	sleep (1);
	wake (f_lakeside_enc); // Calling this a second time because first sleep_until is needed obj_state of previous encounter
	player_equipped_jetpack = TRUE;
	
//	thread (m40_target_designator_main());
end



; =================================================================================================
; CLIFFSIDE
; =================================================================================================

/*

script static void icl()
	f_insertion_reset( DEF_INSERTION_INDEX_CLIFFSIDE() );
end

script static void ins_cliffside()

	f_insertion_begin( "CLIFFSIDE" );
		f_insertion_zoneload( DEF_S_ZONESET_FODDER_CHOPPER(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_cliffside.p0, ps_insertion_cliffside.p1, ps_insertion_cliffside.p2, ps_insertion_cliffside.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
	f_insertion_end();

	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
	// Teleport
	ai_lod_full_detail_actors (20);
	print ("waking cliffside scripts"); 
  wake (cliffside_enc_main);
  wake (cliffside_obj_states);
	game_save();
	print ("spawning mammoth");
	object_create (main_mammoth);
	object_cannot_take_damage (main_mammoth);
	object_create (cliffside_barrier_01);	
	object_create (cliffside_barrier_02);	
	object_create (cliffside_antennae_01);		
	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p5);
	sleep (30 * 1);
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);
//	object_create (cannon_2);
//	object_cannot_take_damage (cannon_2);
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0203c);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_time_position (main_mammoth, 7);
	unit_recorder_set_playback_rate (main_mammoth, .8);
	unit_recorder_pause (main_mammoth, true);
	sleep (30 * 1);
	unit_recorder_pause_smooth (main_mammoth, false, 3);	
//	vehicle_set_player_interaction (main_mammoth, "warthog_d", false, false);
	vehicle_set_player_interaction (main_mammoth, "mac_d", false, false);
	wake (cliffside_ins_tortoise_recording);
	wake (main_mammoth_invincible);
	wake (prechopper_tortoise_recorded);
	print ("mammoth cliffside spawning/scripts done");
//	vehicle_set_player_interaction (main_mammoth, "warthog_d", false, false);
//	object_create (empty_equipment_case_01);
//	object_create (empty_equipment_case_02);
//	objects_attach (main_mammoth,  "crate_2fl_front_left", empty_equipment_case_01, "");
//	objects_attach (main_mammoth,  "crate_2fl_front_right", empty_equipment_case_02, "");
	ai_place (cliffside_ins_marines);
	//game_save(); - TWF; Insertion point automatically does this
	sleep (30 * 1);
	wake (f_test_me2);
	// hack until starting profile scripts are working properly
	//unit_add_equipment (player0, default_single_respawn, TRUE, FALSE);
	
	// ---------------------------------------------------------------------------------------------
	
end

*/



; =================================================================================================
; PRECHOPPER
; =================================================================================================

script static void ipr()
	f_insertion_reset( DEF_INSERTION_INDEX_PRECHOPPER() );
end

script static void ins_prechopper()

	f_insertion_begin( "PRECHOPPER" );
		f_insertion_zoneload( DEF_S_ZONESET_CHOPPER_WATERFALL_PRE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_prechopper.p0, ps_insertion_prechopper.p1, ps_insertion_prechopper.p2, ps_insertion_prechopper.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
	f_insertion_end();

	b_m40_music_progression = 50;
	thread (tort_runover_kills());

	kill_volume_disable (playerkill_soft_prechop_backtrack);	
	kill_volume_disable (playerkill_soft_prechopper_05);

	//----------------------TORTOISE INSERTION SETUP-------------------------------//

	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p15);
	
	sleep (1);

	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_d);
	unit_recorder_play (main_mammoth);
	unit_recorder_pause (main_mammoth, true);

//	sleep_s (2);
	
	custom_animation_hold_last_frame (main_mammoth, "objects\vehicles\human\storm_mammoth\storm_mammoth.model_animation_graph", "bay:doors:opening", false);

	wake (prechopper_tortoise_recorded_insertion);

	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());
	thread (f_hud_boot_up());
	
	effects_distortion_enabled = FALSE; 
	
	//-------------------------INSERTION MARINES-----------------------------------//
	
	ai_place (insertion_marines);
	
	object_create (ins_marines_hog);
	ai_vehicle_enter_immediate (insertion_marines.passenger, ins_marines_hog, "warthog_g");
	ai_vehicle_enter_immediate (insertion_marines.gunner, ins_marines_hog, "warthog_p");
	teleport_players_into_vehicle (ins_marines_hog);

	//--------------------------ENCOUNTER SETUP------------------------------------//

	wake (spawn_prechopper);
	wake (prechopper_obj_states);
	wake (prechopper_convoy_prep);
	wake (prechop_marine_obj_handoff);
	
	soft_ceiling_enable ("prechop_backtrack_01", false);
	soft_ceiling_enable ("chop_backtrack_01", false);
	soft_ceiling_enable ("prechop_new", false);

	object_create_folder (prechopper_crates);
	
	object_teleport_to_ai_point (prechopper_tower_pod, chopper_smash.pod_location);	
	
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);

	sleep (1);
	
	wake (spawn_prechopper); // Calling this a second time because insertion point starts player past first sleep_volume
	
	thread (prechopper_bubble_creation()); // Creating the bubbles since they would have been created earlier in mission
	
	object_destroy (cannon_lakeside);
	
	object_create (cannon_chopper_new);
	
	thread (fx_skybox_lensflares());
	
	//--------------------------TARGET DESIGNATOR SETUP----------------------------//
	
	sleep (1);
	thread (m40_target_designator_main());
	sleep (1);
	thread (target_designator_unlock());
	
	//-----------------------------------------------------------------------------//
	
 	game_save_no_timeout();

end



; =================================================================================================
; CHOPPER
; =================================================================================================

script static void ich()
	f_insertion_reset( DEF_INSERTION_INDEX_CHOPPER() );
end

script static void ins_chopper()

	f_insertion_begin( "CHOPPER" );
		f_insertion_zoneload( DEF_S_ZONESET_CHOPPER_WATERFALL_PRE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_chopper.p0, ps_insertion_chopper.p1, ps_insertion_chopper.p2, ps_insertion_chopper.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
	f_insertion_end();

	b_m40_music_progression = 60;
	thread (f_hud_boot_up());
	thread (tort_runover_kills());
	thread (honey_i_shrunk_the_forerunner_cannon_again());

	soft_ceiling_enable ("prechop_chop_divider", false);
	soft_ceiling_enable ("prechop_new", false);

	//----------------------TORTOISE INSERTION SETUP-------------------------------//

	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, prechopper_tortoise_route_pt.p10);

	sleep (1);

	unit_recorder_setup_for_unit (main_mammoth, tortoise_0716_e);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_playback_rate (main_mammoth, .7);
	unit_recorder_pause (main_mammoth, true);

	wake (chop_tortoise_recorded_ins);
	thread (new_tort_chopper_part_1_speed_test());
	
	prechop_recording_loaded_2 = true;

	//-------------------------INSERTION MARINES-----------------------------------//

	ai_place (chop_marines_convoy);
	ai_place (chop_dead_marines);

	ai_allegiance (player, human);
	
	object_create (chop_ins_hog_01);	
	ai_vehicle_enter_immediate (chop_marines_convoy.chief_gunner1, chop_ins_hog_01, "warthog_g");
	teleport_players_into_vehicle (chop_ins_hog_01);
	
	effects_distortion_enabled = FALSE; 
	
	//--------------------------ENCOUNTER SETUP------------------------------------//

	wake (chopper_main_script);
	wake (chopper_obj_control_01);
	
	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());
	
	object_can_take_damage (cannon_chopper_new);
	
	object_destroy (prechopper_shield_barrier);
	object_create_folder (chop_crates);
	
	s_bubbles_burst = 3;
	
	object_destroy (cannon_lakeside);
	
	thread (fx_skybox_lensflares());
	
	//--------------------------TARGET DESIGNATOR SETUP----------------------------//
	
	sleep (1);
	thread (m40_target_designator_main());
	sleep (1);
	thread (target_designator_unlock());
	
	//-----------------------------------------------------------------------------//

	game_save_no_timeout();
	kill_volume_disable (playerkill_soft_prechopper_05);

end



; =================================================================================================
; WATERFALL
; =================================================================================================


script static void iwa()
	f_insertion_reset( DEF_INSERTION_INDEX_WATERFALL() );
end

script static void ins_waterfall()

	f_insertion_begin( "WATERFALL" );
		f_insertion_zoneload( DEF_S_ZONESET_CHOPPER_WATERFALL_PRE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_waterfall.p0, ps_insertion_waterfall.p1, ps_insertion_waterfall.p2, ps_insertion_waterfall.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
	f_insertion_end();

	b_m40_music_progression = 70;
	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
	// Teleport
	print ("spawning waterfall"); 

	print ("spawning mammoth");
	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, waterfall_pt.p2);
	//unit_add_equipment (player0, default_single_respawn, TRUE, FALSE);

	thread (f_hud_boot_up());
	thread (tort_runover_kills());
	
	sleep (30 * 1);

	teleport_players_into_vehicle (waterfall_ins_hog);
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_e);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_time_position (main_mammoth, 15);
	unit_recorder_set_playback_rate (main_mammoth, .7);
	unit_recorder_pause (main_mammoth, true);
	sleep (30 * 1);
	unit_recorder_pause_smooth (main_mammoth, false, 3);	

	print ("mammoth prechopper spawning/scripts done");
	wake (spawn_waterfall_01);
	wake (el_citadel);
	wake (waterfall_tortoise_recorded);
	wake (M40_waterfalls_warning);
	
	wake (main_mammoth_invincible);
	
	effects_distortion_enabled = FALSE; 
	
	thread (fx_skybox_lensflares());
	
	//game_save(); - TWF; Insertion point automatically does this
	
	// ---------------------------------------------------------------------------------------------
	
end



; =================================================================================================
; JACKAL EXT
; =================================================================================================

script static void ija()
	f_insertion_reset( DEF_INSERTION_INDEX_JACKAL() );
end

// RALLY POINT BRAVO
script static void ins_jackal()

	f_insertion_begin( "JACKAL EXT" );
		f_insertion_zoneload( DEF_S_ZONESET_PRE_VALE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( pts_ins_val.p0, pts_ins_val.p1, pts_ins_val.p2, pts_ins_val.p3 );
		f_insertion_playerprofile( sniper_jetpack, FALSE );
	f_insertion_end();

	b_m40_music_progression = 80;
	
	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
//	vehicle_set_player_interaction (main_mammoth, "warthog_d", false, false);
	
	object_create (main_mammoth);
	object_teleport_to_ai_point (main_mammoth, waterfall_pt.p0);
	
	sleep (1);
		
	unit_recorder_setup_for_unit (main_mammoth, tortoise_0526_f);
	unit_recorder_play (main_mammoth);
	unit_recorder_set_time_position (main_mammoth, 112);
	unit_recorder_pause (main_mammoth, true);


	wake (el_citadel);
	wake (main_mammoth_invincible);

	thread (f_hud_boot_up());
	
	thread (m40_dg_check());
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);

	sleep_s (3);
	
	thread (tort_bipeds());
	
	thread (fx_skybox_lensflares());
	//wake (el_citadel);
	//ai_place (sniper_jackals);
	//wake (post_librarian);
	//wake (forerunner_enc);
	//game_save(); - TWF; Insertion point automatically does this
	
	// hack until starting profile scripts are working properly
	//unit_add_equipment (player0, sniper_jetpack, TRUE, FALSE);
	
	// ---------------------------------------------------------------------------------------------

end



; =================================================================================================
; CITADEL EXT
; =================================================================================================

script static void ice()
	f_insertion_reset( DEF_INSERTION_INDEX_CITADEL() );
end

script static void ins_citadel()

	f_insertion_begin( "CITADEL EXT" );
		f_insertion_zoneload( DEF_S_ZONESET_VALE_VALE(), FALSE );
		f_insertion_playerwait();
		if ( S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_START ) then
			f_insertion_teleport( pts_ins_citext.p0, pts_ins_citext.p1, pts_ins_citext.p2, pts_ins_citext.p3 );
		else
			f_insertion_teleport( pts_ins_citext_t.p0, pts_ins_citext_t.p1, pts_ins_citext_t.p2, pts_ins_citext_t.p3 );
		end
		f_insertion_playerprofile( sniper_jetpack, FALSE );
	f_insertion_end();

	b_m40_music_progression = 90;
	
	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
	// Teleport
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);

	thread (f_hud_boot_up());
	
	// set the valley objcon so it knows not to spawn
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_ESCAPE );

	//wake (f_citadel_ext_main);
	wake (el_citadel);
	
	thread (fx_skybox_lensflares());
	//game_save(); - TWF; Insertion point automatically does this
	
	// ---------------------------------------------------------------------------------------------
	
end

//; =================================================================================================
//; CITADEL EXT: TEST
//; =================================================================================================
//
//script static void ice_t()
//	f_insertion_reset( DEF_INSERTION_INDEX_CITADEL_EXT_TEST() );
//end
//
//script static void ins_citadel_test()
//
//	// force the objcon to be higher so I can check to skip loading stuff
//	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START );
//	
//	ins_citadel();
//	
//end

//; =================================================================================================
//; CITADEL INT
//; =================================================================================================
//
//script static void ici()
//	f_insertion_reset( DEF_INSERTION_INDEX_CITADEL_INT() );
//end
//
//script static void ins_citadel_int()
//
//	f_insertion_begin( "CITADEL INT" );
//		f_insertion_zoneload( DEF_S_ZONESET_VALE_HALL(), FALSE );
//		f_insertion_playerwait();
//		f_insertion_teleport( pts_ins_citint.p0, pts_ins_citint.p1, pts_ins_citint.p2, pts_ins_citint.p3 );
//		f_insertion_playerprofile( sniper_jetpack, FALSE );
//	f_insertion_end();
//
//	// forces setup of mission functions to put game into proper state
//	// insertion setup block -----------------------------------------------------------------------
//	
//	// Teleport
//	sleep_forever (M40_tortoise_enter_first_time);
//	sleep_forever (m40_caves_tort_meet_palmer);
//
//	wake( f_citadel_int_init );
//	//game_save(); - TWF; Insertion point automatically does this
//	
//	// ---------------------------------------------------------------------------------------------
//	
//end

//; =================================================================================================
//; CITADEL INT: TEST 01
//; =================================================================================================
//
//script static void ici_t()
//	f_insertion_reset( DEF_INSERTION_INDEX_CITADEL_INT_TEST() );
//end
//
//script static void ins_citadel_int_t01()
//
//	f_insertion_begin( "CITADEL INT: TEST 01" );
//		f_insertion_zoneload( DEF_S_ZONESET_HALL_BATTERY(), FALSE );
//		f_insertion_playerwait();
//		f_insertion_teleport( pts_ins_citint_t01.p0, pts_ins_citint_t01.p1, pts_ins_citint_t01.p2, pts_ins_citint_t01.p3 );
//		f_insertion_playerprofile( sniper_jetpack, FALSE );
//	f_insertion_end();
//
//	// forces setup of mission functions to put game into proper state
//	// insertion setup block -----------------------------------------------------------------------
//	
//	// force sentinel objcon forward
//	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_START );
//	
//	// Teleport
//	sleep_forever (M40_tortoise_enter_first_time);
//	sleep_forever (m40_caves_tort_meet_palmer);
//
//	wake( f_citadel_int_init );
//	//game_save(); - TWF; Insertion point automatically does this
//	
//	// ---------------------------------------------------------------------------------------------
//	
//end
; =================================================================================================
; POWERCAVE
; =================================================================================================

script static void ipo()
	f_insertion_reset( DEF_INSERTION_INDEX_POWERCAVE() );
end

script static void ins_powercave()

	f_insertion_begin( "POWERCAVE" );
		f_insertion_zoneload( DEF_S_ZONESET_BATTERY(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( pts_bat.p1, pts_bat.p2, pts_bat.p3, pts_bat.p4 );
		f_insertion_playerprofile( jetpack_profile, FALSE );
	f_insertion_end();

	b_m40_music_progression = 100;
	
	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
	// Teleport
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);

	//game_save(); - TWF; Insertion point automatically does this
	wake(f_powercave_main);
	wake (f_librarian_main);
	
	wake (main_mammoth_invincible);

	thread (f_hud_boot_up());
	
	// ---------------------------------------------------------------------------------------------
	
end



; =================================================================================================
; LIBRARIAN ROOM
; =================================================================================================

script static void ili()
	f_insertion_reset( DEF_INSERTION_INDEX_LIBRARIAN() );
end

script static void ins_librarian()

	f_insertion_begin( "LIBRARIAN ROOM" );
		f_insertion_zoneload( DEF_S_ZONESET_LIBRARIAN_VALE(), FALSE );
		f_insertion_playerwait();
		f_insertion_teleport( pts_lib_ins.p0, pts_lib_ins.p1, pts_lib_ins.p2, pts_lib_ins.p3 );
		f_insertion_playerprofile( librarian_profile, FALSE );
	f_insertion_end();

	b_m40_music_progression = 120;
	
	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------
	
	// Teleport
	sleep_forever (M40_tortoise_enter_first_time);
	sleep_forever (m40_caves_tort_meet_palmer);
	object_create_folder(lib_crates);
	
	wake (main_mammoth_invincible);

//	wake (post_librarian);
	wake (f_librarian_main);

	thread (f_hud_boot_up());
	
	// ---------------------------------------------------------------------------------------------

end



//; =================================================================================================
//; ORDNANCE TRAINING
//; =================================================================================================
//
//script static void ior()
//	f_insertion_reset( DEF_INSERTION_INDEX_ORDINANCE() );
//end
//
//script static void ins_ordnance()
//
//	f_insertion_begin( "ORDNANCE TRAINING" );
//		f_insertion_zoneload( DEF_S_ZONESET_REAR_ORD_EPIC(), FALSE );
//		f_insertion_playerwait();
//		f_insertion_teleport( pts_ord.p0, pts_ord.p1, pts_ord.p2, pts_ord.p3 );
//		f_insertion_playerprofile( jetpack_profile, FALSE );
//	f_insertion_end();
//
//	// forces setup of mission functions to put game into proper state
//	// insertion setup block -----------------------------------------------------------------------
//	
//	// Teleport
//	sleep_forever (M40_tortoise_enter_first_time);
//	sleep_forever (m40_caves_tort_meet_palmer);
////	vehicle_set_player_interaction (main_mammoth, "warthog_d", false, false);
////	vehicle_set_player_interaction (main_mammoth_2, "mac_d", false, false);
////	wake (ordnance_convoy);
////	wake (epic_approach_dialogue);
//	//game_save(); - TWF; Insertion point automatically does this
//	
//	// ---------------------------------------------------------------------------------------------
//
//end



; =================================================================================================
; EPIC
; =================================================================================================

script static void iep()
	f_insertion_reset( DEF_INSERTION_INDEX_EPIC() );
end

script static void ins_epic()

	f_insertion_begin( "EPIC" );
	f_insertion_zoneload( DEF_S_ZONESET_EPIC(), FALSE );
	f_insertion_playerwait();
//	f_insertion_teleport( ps_insertion_epic.p0, ps_insertion_epic.p1, ps_insertion_epic.p2, ps_insertion_epic.p3 );
	f_insertion_playerprofile( jetpack_profile, FALSE );
	f_insertion_end();

//	f_insertion_begin( "MAMMOTH" );
//	f_insertion_zoneload( DEF_S_ZONESET_CAV(), FALSE );
//	f_insertion_playerwait();
//	f_insertion_teleport( ps_insertion_cavern.p0, ps_insertion_cavern.p1,ps_insertion_cavern.p2,ps_insertion_cavern.p3 );
//	f_insertion_playerprofile( caverns_profile, FALSE );
//	f_insertion_end();


	// forces setup of mission functions to put game into proper state
	// insertion setup block -----------------------------------------------------------------------

	b_m40_music_progression = 140;

	thread (fx_epic_skybox_lensflares());
	
	// Teleport
	object_teleport (player0(), epic_teleport_flag_01); // TWF - COULD NOT CHANGE THIS TO USE STANDARD SYTEM BECUASE IT'S FLAGS INSTEAD OF A POINT SET
	object_teleport (player1(), epic_teleport_flag_02);
	object_teleport (player2(), epic_teleport_flag_03);
	object_teleport (player2(), epic_teleport_flag_04);

	thread (f_hud_boot_up());
	
	wake (backup_ending_script);

	//fade_out (255,255,255,5);
	sleep (30 * .7);
	wake (epic_main_script);
	wake (epic_obj_control);
	
	effects_distortion_enabled = FALSE; 
	
	wake (main_mammoth_invincible);
	
	thread (m40_dg_check());
	
	// ---------------------------------------------------------------------------------------------

end



// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================
// -------------------------------------------------------------------------------------------------
// INSERTION LOAD INDEX
// -------------------------------------------------------------------------------------------------
script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	//dprint( "::: f_insertion_index_load :::" );
	inspect( game_insertion_point_get() );
	
	if ( s_insertion == DEF_INSERTION_INDEX_CAVERN() ) then
		b_started = TRUE;
		ins_cavern();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_MAMMOTH() ) then
		b_started = TRUE;
		ins_mammoth();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_FODDER() ) then
		b_started = TRUE;
		ins_fodder();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_LAKESIDE() ) then
		b_started = TRUE;
		ins_lakeside();
	end
//	if ( s_insertion == DEF_INSERTION_INDEX_CLIFFSIDE() ) then
//		b_started = TRUE;
//		ins_cliffside();
//	end
	if ( s_insertion == DEF_INSERTION_INDEX_PRECHOPPER() ) then
		b_started = TRUE;
		ins_prechopper();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_CHOPPER() ) then
		b_started = TRUE;
		ins_chopper();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_WATERFALL() ) then
		b_started = TRUE;
		ins_waterfall();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_JACKAL() ) then
		b_started = TRUE;
		ins_jackal();
	end
	if ( s_insertion == DEF_INSERTION_INDEX_CITADEL() ) then
		b_started = TRUE;
		ins_citadel();
	end
//	if ( s_insertion == DEF_INSERTION_INDEX_CITADEL_EXT_TEST() ) then
//		b_started = TRUE;
//		ins_citadel_test();
//	end
//	if ( s_insertion == DEF_INSERTION_INDEX_CITADEL_INT() ) then
//		b_started = TRUE;
//		ins_citadel_int();
//	end
//	if ( s_insertion == DEF_INSERTION_INDEX_CITADEL_INT_TEST() ) then
//		b_started = TRUE;
//		ins_citadel_int_t01();
//	end
	/*
	if ( s_insertion == DEF_INSERTION_INDEX_BATTERY() ) then
		b_started = TRUE;
		ins_xxx();
	end
	*/
	if ( s_insertion == DEF_INSERTION_INDEX_POWERCAVE() ) then
		b_started = TRUE;
		ins_powercave();
	end
	/*
	if ( s_insertion == DEF_INSERTION_INDEX_BATTERY_TURR() ) then
		b_started = TRUE;
		ins_xxx();
	end
	*/
	if ( s_insertion == DEF_INSERTION_INDEX_LIBRARIAN() ) then
		b_started = TRUE;
		ins_librarian();
	end
//	if ( s_insertion == DEF_INSERTION_INDEX_ORDINANCE() ) then
//		b_started = TRUE;
//		ins_ordnance();
//	end
	if ( s_insertion == DEF_INSERTION_INDEX_EPIC() ) then
		b_started = TRUE;
		ins_epic();
	end

	if ( not b_started ) then
		dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		inspect( s_insertion );
	end

end

// -------------------------------------------------------------------------------------------------
// ZONE SET GET
// -------------------------------------------------------------------------------------------------
script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "zone_set_cav";

	if ( s_index == DEF_S_ZONESET_CAV() ) then
	 zs_return = "zone_set_cav";
	end
	if ( s_index == DEF_S_ZONESET_CAV_TORT_GUN() ) then
	 zs_return = "zone_set_cav_tort_gun";
	end
	if ( s_index == DEF_S_ZONESET_GUN_FODDER() ) then
	 zs_return = "zone_set_gun_fodder";
	end
	if ( s_index == DEF_S_ZONESET_FODDER() ) then
	 zs_return = "zone_set_fodder";
	end
	if ( s_index == DEF_S_ZONESET_FODDER_CHOPPER() ) then
	 zs_return = "zone_set_fodder_chopper";
	end
	if ( s_index == DEF_S_ZONESET_CHOPPER_WATERFALL_PRE() ) then
	 zs_return = "zone_set_chopper_waterfall_pre";
	end
	if ( s_index == DEF_S_ZONESET_WATERFALL_PRE_VALE() ) then
	 zs_return = "zone_set_waterfall_pre_vale";
	end
	if ( s_index == DEF_S_ZONESET_PRE_VALE() ) then
	 zs_return = "zone_set_pre_vale";
	end
	if ( s_index == DEF_S_ZONESET_VALE_VALE() ) then
	 zs_return = "zone_set_vale_vale";
	end
	if ( s_index == DEF_S_ZONESET_VALE_HALL() ) then
	 zs_return = "zone_set_vale_hall";
	end
	if ( s_index == DEF_S_ZONESET_HALL_BATTERY() ) then
	 zs_return = "zone_set_hall_battery";
	end
	if ( s_index == DEF_S_ZONESET_BATTERY() ) then
	 zs_return = "zone_set_battery";
	end
	if ( s_index == DEF_S_ZONESET_BATTERY_CAVERN() ) then
	 zs_return = "zone_set_battery_cavern";
	end
	if ( s_index == DEF_S_ZONESET_CAVERN_LIBRARIAN_VALE() ) then
	 zs_return = "zone_set_cavern_librarian_vale";
	end
	if ( s_index == DEF_S_ZONESET_LIBRARIAN_VALE() ) then
	 zs_return = "zone_set_librarian_vale";
	end
//	if ( s_index == DEF_S_ZONESET_VALE_INFINITY_REAR() ) then
//	 zs_return = "zone_set_vale_infinity_rear";
//	end
//	if ( s_index == DEF_S_ZONESET_REAR_ORD_EPIC() ) then
//	 zs_return = "zone_set_rear_ord_epic";
//	end
//	if ( s_index == DEF_S_ZONESET_PRE_EPIC() ) then
//	 zs_return = "zone_set_pre_epic";
//	end
	if ( s_index == DEF_S_ZONESET_EPIC() ) then
	 zs_return = "zone_set_epic";
	end
	if ( s_index == DEF_S_ZONESET_EPIC_EXIT() ) then
	 zs_return = "zone_set_epic_exit";
	end
	if ( s_index == DEF_S_ZONESET_TRACTOR() ) then
	 zs_return = "zone_set_tractor";
	end
	if ( s_index == DEF_S_ZONESET_PRE_CHOP_WATER() ) then
	 zs_return = "zone_set_pre_chop_water";
	end
	if ( s_index == DEF_S_ZONESET_WATER_PRE() ) then
	 zs_return = "zone_set_water_pre";
	end
	if ( s_index == DEF_S_ZONESET_CIN_INTRO() ) then
	 zs_return = "cin_intro";
	end
	if ( s_index == DEF_S_ZONESET_ELE_EPIC() ) then
	 zs_return = "zone_set_ele_epic";
	end
	if ( s_index == DEF_S_ZONESET_CIN_M041_LIBRARIAN() ) then
	 zs_return = "cin_m041_librarian";
	end
	if ( s_index == DEF_S_ZONESET_CIN_M042_END() ) then
	 zs_return = "cin_m042_end";
	end

	// return
	zs_return;
end


// =================================================================================================
// =================================================================================================
// *** CLEANUP ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// LANDING
// =================================================================================================

//script static void f_landing_cleanup()
	//sleep_forever (f_landing_main);
//end

// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================

/*
// =================================================================================================
// Loadouts
// =================================================================================================
script static void f_loadout_set (string area)
	if (area == "default") then
		if (game_is_cooperative()) then
			unit_add_equipment (player0, default_coop, TRUE, FALSE);
			unit_add_equipment (player1, default_coop, TRUE, FALSE);
			unit_add_equipment (player2, default_coop, TRUE, FALSE);
			unit_add_equipment (player3, default_coop, TRUE, FALSE);
			player_set_profile (default_coop_respawn, player0);
			player_set_profile (default_coop_respawn, player1);
			player_set_profile (default_coop_respawn, player2);
			player_set_profile (default_coop_respawn, player3);
		else
			player_set_profile (default_single_respawn, player0);
		end
	end
end
/*
/*
// =================================================================================================
// Insertion Fade
// =================================================================================================

global boolean b_insertion_fade_in = FALSE;
script dormant f_insertion_fade_in

	sleep_until (b_insertion_fade_in);
	// this is a global script
	insertion_fade_to_gameplay();
end
*/
