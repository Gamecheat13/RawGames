
; =================================================================================================
; =================================================================================================
; *** GLOBALS ***
; =================================================================================================
; =================================================================================================

global string s_music_control 							= "none";

global short s_music_gpost03 								= 0;
global short s_music_bridge02 							= 0;
global short s_music_atrium02 							= 0;

global short s_objmove_gpe_door 						= 0;
global short s_objmove_gpi_door 						= 0;
global short s_objmove_courty_door 					= 0;
global short s_objmove_gun_door 						= 0;
global short s_objmove_gpi_platforms_left 	= 0;
global short s_objmove_gpi_platforms_right 	= 0;


global string s_amb_crater01  							= "f";
global string s_amb_crater02 								= "f";
global string s_amb_vista01 								= "f";
global string s_amb_graveyard01 						= "f";
global string s_amb_gpost01 								=	"f";
global string s_amb_gpost02 								=	"f";
global string s_amb_bridge01  							=	"f";
global string s_amb_bridge02  							=	"f";
global string s_amb_chamber01  							=	"f";
global string s_amb_cyard01   							=	"f";
global string s_amb_cyard02   							=	"f";
global string s_amb_atrium01   							=	"f";

global string s_cruiser_crater   						=	"f";
global string s_cruiser_bridge   						=	"f";
global string s_cruiser_courtyard   				=	"f";

global string s_dm_gpe_door 								= "none";
global string s_dm_gpi_door 								= "none";
global string s_dm_courty_door 							= "none";
global string s_dm_gun_door 								= "none";
global string s_dm_gpi_platforms_left 			= "none";
global string s_dm_gpi_platforms_right 			= "none";

global string s_dm_scanner_up 							= "none";
global string s_dm_scanner_red 							= "none";
global string s_dm_scanner_green 						= "none";
global string s_dm_bridge_elevator 					= "none";
global string s_dm_atrium_elevator 					= "none";
global string s_dm_flush_core 							= "none";
global string s_dm_blue_column_1 						= "none";
global string s_dm_blue_column_2 						= "none";
global string s_dm_blue_column_3 						= "none";
global string s_dm_blue_column_4 						= "none";

global short s_cruiser_crater_sky 					= 0;

// =================================================================================================
// =================================================================================================
// *** AUDIO HOOKS ***
// =================================================================================================
//
script startup m20_audio()
	thread (load_music_for_zone_set());
end

//====================================================
// MUSIC HOOKS - ENCOUNTERS
//====================================================



script static void f_mus_m20_e01_begin()
	dprint("f_mus_m20_e01");
	music_set_state('Play_mus_m20_e01_field');
end

script static void f_mus_m20_e02_begin()
	dprint("f_mus_m20_e02");
	music_set_state('Play_mus_m20_e03_cathedral_interior_1');
end

script static void f_mus_m20_e03_begin()
	dprint("f_mus_m20_e03");
	music_set_state('Play_mus_m20_e05_cathedral_interior_2');
end

script static void f_mus_m20_e04_begin()
	dprint("f_mus_m20_e04");
	music_set_state('Play_mus_m20_e07_bridge_door_open');
end

script static void f_mus_m20_e05_begin()
	dprint("f_mus_m20_e05");
	music_set_state('Play_mus_m20_e09_bridge_elevator_land');
end

script static void f_mus_m20_e06_begin()
	dprint("f_mus_m20_e06");
	music_set_state('Play_mus_m20_e11_courtyard');
end

script static void f_mus_m20_e07_begin()
	dprint("f_mus_m20_e07");
end

script static void f_mus_m20_e08_begin()
	dprint("f_mus_m20_e08");
end

script static void f_mus_m20_e01_finish()
	dprint("f_mus_m20_e01");
	music_set_state('Play_mus_m20_e02_field_end');
end

script static void f_mus_m20_e02_finish()
	dprint("f_mus_m20_e02");
	music_set_state('Play_mus_m20_e04_cathedral_interior_1_end');
end

script static void f_mus_m20_e03_finish()
	dprint("f_mus_m20_e03");
	music_set_state('Play_mus_m20_e06_cathedral_interior_2_end');
end

script static void f_mus_m20_e04_finish()
	dprint("f_mus_m20_e04");
	music_set_state('Play_mus_m20_e08_bridge_end');
end

script static void f_mus_m20_e05_finish()
	dprint("f_mus_m20_e05");
end

script static void f_mus_m20_e06_finish()
	dprint("f_mus_m20_e06");
	music_set_state('Play_mus_m20_e12_courtyard_end');
end

script static void f_mus_m20_e07_finish()
	dprint("f_mus_m20_e07");
end

script static void f_mus_m20_e08_finish()
	dprint("f_mus_m20_e08");
end

script static void f_music_m20_tweak01()
	dprint("f_music_m20_tweak01");
	music_set_state('Play_mus_m20_t01_tweak');
end

script static void f_music_m20_tweak02()
	dprint("f_music_m20_tweak02");
	music_set_state('Play_mus_m20_t02_tweak');
end

script static void f_music_m20_tweak03()
	dprint("f_music_m20_tweak03");
	music_set_state('Play_mus_m20_t03_tweak');
end

script static void f_music_m20_tweak04()
	dprint("f_music_m20_tweak04");
	music_set_state('Play_mus_m20_t04_tweak');
end

script static void f_music_m20_tweak05()
	dprint("f_music_m20_tweak05");
	music_set_state('Play_mus_m20_t05_tweak');
end

script static void f_music_m20_tweak06()
	dprint("f_music_m20_tweak06");
	music_set_state('Play_mus_m20_t06_tweak');
end

script static void f_music_m20_tweak07()
	dprint("f_music_m20_tweak07");
	music_set_state('Play_mus_m20_t07_tweak');
end

script static void f_music_m20_tweak08()
	dprint("f_music_m20_tweak08");
	music_set_state('Play_mus_m20_t08_tweak');
end

script static void f_music_m20_tweak09()
	dprint("f_music_m20_tweak09");
	music_set_state('Play_mus_m20_t09_tweak');
end

script static void f_music_m20_tweak10()
	dprint("f_music_m20_tweak10");
	music_set_state('Play_mus_m20_t10_tweak');
end

script static void f_music_m20_v01_floating_tower()
	dprint("f_music_m20_v01_floating_tower");
	music_set_state('Play_mus_m20_v01_floating_tower');
end

// this will always be 0 unless an insertion point is used
// in that case, it is used to skip past the trigger volumes that precede the selected insertion point
global short b_m20_music_progression = 0;

//====================================================
// MUSIC HOOKS - ZONE SETS
//====================================================
script static void load_music_for_zone_set()
	sleep_until(b_m20_music_progression > 0 or current_zone_set_fully_active() == s_zoneset_crater, 1);
	
	music_start('Play_mus_m20');
	
	sleep_until(b_m20_music_progression > 10 or volume_test_players (tv_music_r01_crater), 1);
	if b_m20_music_progression <= 10 then
		sound_set_state('Set_State_M20_Crater');
		music_set_state('Play_mus_m20_r01_crater');
	end

	// Player enters cave to vista
	sleep_until(b_m20_music_progression > 20 or volume_test_players (tv_music_r02_crater_clearing), 1);
	if b_m20_music_progression <= 20 then
		sound_set_state('Set_State_M20_Crater_Clearing');
		music_set_state('Play_mus_m20_r02_crater_clearing');
	end
	
	//  exit cave and see vista
	// sleep_until(volume_test_players (tv_music_r03_clearing), 1);
	//	music_set_state('Play_mus_m20_r03_clearing');

	// Just before entering wreckage
	sleep_until(b_m20_music_progression > 30 or volume_test_players (tv_music_r04_clearing_graveyard), 1);
	if b_m20_music_progression <= 30 then
		sound_set_state('Set_State_M20_Crater_Graveyard');
		music_set_state('Play_mus_m20_r04_clearing_graveyard');
	end

	// In wreckage
	sleep_until(b_m20_music_progression > 40 or volume_test_players (tv_music_r05_graveyard), 1);
	if b_m20_music_progression <= 40 then
		sound_set_state('Set_State_M20_Graveyard');
		music_set_state('Play_mus_m20_r05_graveyard');
	end
	
	// Right before exiting wreckage and entering cave
	sleep_until(b_m20_music_progression > 50 or volume_test_players (tv_music_r06_graveyard_guardpostext), 1);
	if b_m20_music_progression <= 50 then
		sound_set_state('Set_State_M20_Graveyard2');
		music_set_state('Play_mus_m20_r06_graveyard_guardpostext');
	end
	
	// Exit cave and enter field before the guardpost exterior
	sleep_until(b_m20_music_progression > 60 or volume_test_players (tv_music_r07_guardpostext), 1);
	if b_m20_music_progression <= 60 then
		sound_set_state('Set_State_M20_Guardpost_Exterior_Field');
		music_set_state('Play_mus_m20_r07_guardpostext');
	end
	
	// cathedral/guardpost exterior
	sleep_until(b_m20_music_progression > 70 or volume_test_players (tv_music_r08_guardpostext_guardpostint), 1);
	if b_m20_music_progression <= 70 then
		sound_set_state('Set_State_M20_Guardpost_Exterior');
		music_set_state('Play_mus_m20_r08_guardpostext_guardpostint');
	end
	
	// RALLY POINT BRAVO
	// enter cathedral/guardpost interior
	sleep_until(b_m20_music_progression > 80 or volume_test_players (tv_music_r09_guardpostint), 1);
	if b_m20_music_progression <= 80 then
		sound_set_state('Set_State_M20_Guardpost_Interior');
		music_set_state('Play_mus_m20_r09_guardpostint');
	end
	
	// enter last room before going back outside
	sleep_until(b_m20_music_progression > 90 or volume_test_players (tv_music_r10_guardpostint_bridge), 1);
	if b_m20_music_progression <= 90 then
		sound_set_state('Set_State_M20_Guardpost_To_Bridge');
		music_set_state('Play_mus_m20_r10_guardpostint_bridge');
	end
	
	// exit the cathedral/guardpost and enter the bridge area
	sleep_until(b_m20_music_progression > 100 or volume_test_players (tv_music_r11_bridge), 1);
	if b_m20_music_progression <= 100 then
		sound_set_state('Set_State_M20_Bridge');
		music_set_state('Play_mus_m20_r11_bridge');
	end
	
	// after entering the door at the end of the bridge
	sleep_until(b_m20_music_progression > 110 or volume_test_players (tv_music_r13_courtyard), 1);
	if b_m20_music_progression <= 110 then
		sound_set_state('Set_State_M20_Courtyard');
		music_set_state('Play_mus_m20_r13_courtyard');
	end
	
	// exit courtyard (enter zoneset terminus)
	sleep_until(b_m20_music_progression > 120 or volume_test_players (tv_music_r15_atrium), 1);
	if b_m20_music_progression <= 120 then
		sound_set_state('Set_State_M20_Atrium');
	 	music_set_state('Play_mus_m20_r15_atrium');
	end

	sleep_until(current_zone_set_fully_active() == s_zoneset_tower_cinematic, 1);
		music_stop('Stop_mus_m20'); 
end

script dormant f_music_start()
	 sound_looping_start ("sound\environments\solo\m020\music\m20_music", NONE, 1.0);
end


script dormant f_music_crater01()
	sleep_until (volume_test_players (tv_music_CRATER01) == 1, 1);
	dprint ("::: music tv - CRATER01 :::");
	s_music_control = "CRATER01";
end


script dormant f_music_vista01()
	sleep_until (volume_test_players (tv_music_vista01) == 1, 1);
	dprint ("::: music tv - VISTA01 :::");
	s_music_control = "VISTA01";
	sound_looping_start ("sound\environments\solo\m020\music\vista1", NONE, 1.0);
end

script dormant f_music_graveyard01()
	sleep_until (volume_test_players (tv_music_graveyard01) == 1, 1);
	dprint ("::: music tv - GRAVEYARD01 :::"); 
	s_music_control = "GRAVEYARD01";
	sound_looping_start ("sound\environments\solo\m020\music\graveyard01", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\vista1");
end

script dormant f_music_gpost01()
	sleep_until (volume_test_players (tv_music_gpost01) == 1, 1);
	dprint ("::: sound tv - GPOST01 :::"); 
	s_music_control = "GPOST01";
	sound_looping_start ("sound\environments\solo\m020\music\gpost01", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\graveyard01");
end

script dormant f_music_gpost04()
	sleep_until (volume_test_players (tv_music_gpost04) == 1, 1);
	dprint ("::: music tv - GPOST04 :::");
	s_music_control = "GPOST04";
	sound_looping_start ("sound\environments\solo\m020\music\gpost04", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\gpost01");
end

script dormant f_music_gpost02()
	sleep_until (volume_test_players (tv_music_gpost02) == 1, 1);
	dprint ("::: music tv - GPOST02 :::");
	s_music_control = "GPOST02";
	sound_looping_start ("sound\environments\solo\m020\music\gpost02", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\gpost04");
end

script dormant f_music_gpost03_e()
	sleep_until (s_music_gpost03 == 1, 1);
	dprint  ("::: music tv - GPOST03 :::");
	s_music_control = "GPOST03";
	sound_looping_start ("sound\environments\solo\m020\music\gpost03", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\gpost02");
end


script dormant f_music_gpost05()
	dprint ("::: music tv - GPOST05 :::");
end

script dormant f_music_bridge01()
	sleep_until (volume_test_players (tv_music_bridge01) == 1, 1);
	dprint ("::: music tv - BRIDGE01 :::");
	s_music_control = "BRIDGE01";
	sound_looping_start ("sound\environments\solo\m020\music\bridge_01", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\gpost04");
end

script dormant f_music_bridge02_e()
	sleep_until (s_music_bridge02 == 1, 1);
	dprint ("::: music tv - BRIDGE02 :::");
	s_music_control = "BRIDGE02";
	sound_looping_start ("sound\environments\solo\m020\music\bridge_02", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\bridge_01");
end

script dormant f_music_cyard02()
	sleep_until (volume_test_players (tv_music_cyard02) == 1, 1);
	dprint ("::: music tv - CYARD02 :::");
	s_music_control = "CYARD02";
	sound_looping_start ("sound\environments\solo\m020\music\cyard02", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\bridge_02");
end

script dormant f_music_atrium01()
	sleep_until (volume_test_players (tv_music_atrium01) == 1, 1);
	dprint ("::: music tv - ATRIUM01 :::"); 
	s_music_control = "ATRIUM01";
	sound_looping_start ("sound\environments\solo\m020\music\atrium01", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\cyard02");
end

script dormant f_music_atrium02_e()
	sleep_until (s_music_atrium02 == 1, 1);
	dprint  ("::: music tv - ATRIUM02 :::");
	s_music_control = "ATRIUM02";
	sound_looping_start ("sound\environments\solo\m020\music\atrium02", NONE, 1.0);
	sound_looping_stop ("sound\environments\solo\m020\music\atrium01");
end




//====================================================
//			AMB
//====================================================

script static void f_amb_crater01()
	repeat	
		sleep_until (volume_test_players (tv_amb_crater01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_crater01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_crater01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_crater01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_crater02()
	repeat	
		sleep_until (volume_test_players (tv_amb_crater02));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_crater02", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_crater02) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_crater02");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_vista01()
	repeat	
		sleep_until (volume_test_players (tv_amb_vista01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_vista01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_vista01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_vista01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_graveyard01()
	repeat	
		sleep_until (volume_test_players (tv_amb_graveyard01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_graveyard01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_graveyard01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_graveyard01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_gpost01()
	repeat	
		sleep_until (volume_test_players (tv_amb_gpost01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_gpost01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_gpost01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_gpost01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_gpost02()
	repeat	
		sleep_until (volume_test_players (tv_amb_gpost02));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_gpost02", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_gpost02) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_gpost02");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_bridge01()
	repeat	
		sleep_until (volume_test_players (tv_amb_bridge01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_bridge01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_bridge01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_bridge01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_bridge02()
	repeat	
		sleep_until (volume_test_players (tv_amb_bridge02));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_bridge02", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_bridge02) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_bridge02");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_chamber01()
	repeat	
		sleep_until (volume_test_players (tv_amb_chamber01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_chamber01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_chamber01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_chamber01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_cyard01()
	repeat	
		sleep_until (volume_test_players (tv_amb_cyard01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_cyard01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_cyard01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_cyard01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_cyard02()
	repeat	
		sleep_until (volume_test_players (tv_amb_cyard02));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_cyard02", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_cyard02) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_cyard02");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_amb_atrium01()
	repeat	
		sleep_until (volume_test_players (tv_amb_atrium01));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_atrium01", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_amb_atrium01) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_atrium01");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end


//=========================================================================
//		CRUISERS
//=========================================================================

script static void f_cruiser_crater()
	repeat	
		sleep_until (volume_test_players (tv_cruiser_crater) == 1 and s_cruiser_crater_sky == 1);
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_cruiser_crater", NONE, 1.0);
		sleep_until (volume_test_players (tv_cruiser_crater) == 1 and s_cruiser_crater_sky == 0);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_cruiser_crater");
	until (1 == 0, 1);
end



script static void f_cruiser_bridge()
	repeat	
		sleep_until (volume_test_players (tv_cruiser_bridge));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_cruiser_bridge", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_cruiser_bridge) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_cruiser_bridge");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end

script static void f_cruiser_courtyard()
	repeat	
		sleep_until (volume_test_players (tv_cruiser_courtyard));
		sound_looping_start ("sound\environments\solo\m020\ambience\amb_cruiser_courtyard", NONE, 1.0);
		print ("SOUND_LOOPING_START");
		sleep_until (volume_test_players (tv_cruiser_courtyard) == FALSE);
		sound_looping_stop ("sound\environments\solo\m020\ambience\amb_cruiser_courtyard");
		print ("SOUND_LOOPING_END");
	until (1 == 0, 1);
end



//====================================================
//			Device machines
//====================================================


script dormant f_dm_gpe_door()
	sleep_until (s_objmove_gpe_door == 1, 1);
	dprint ("::: dm tv - GPE DOOR :::");
	s_dm_gpe_door = "PLAY";
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_gpe_door", NONE, 1);
end

script dormant f_dm_gpi_door()
	sleep_until (s_objmove_gpi_door == 1, 1);
	dprint ("::: dm tv - GPI DOOR :::");
	s_dm_gpi_door = "PLAY";
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_gpi_door", NONE, 1);
end


script dormant f_dm_courty_door()
	sleep_until (s_objmove_courty_door == 1, 1);
	dprint ("::: dm tv - COURTYARD DOOR :::");
	s_dm_courty_door = "PLAY";
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_courty_door", NONE, 1);
end

script dormant f_dm_gun_door()
	sleep_until (s_objmove_gun_door == 1, 1);
	dprint  ("::: music tv - GUN DOOR :::");
	s_dm_gun_door = "PLAY";
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_gun_door", NONE, 1);
end

script dormant f_atrium_elevator_audio()
	dprint ("::: Elevator Atrium -- VO Start:::");
	sleep (30 * 2);
end

//====================================================
// other devices that just have variables
//====================================================

script dormant f_dm_scanner()
	sleep_until (s_dm_scanner_up == "PLAY", 1);
	dprint ("::: starting scanner sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_scanner_up", NONE, 1);
end

script dormant f_dm_scanner_red()
	sleep_until (s_dm_scanner_red == "PLAY", 1);
	dprint ("::: starting scanner red sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_scanner_red", NONE, 1);
end

script dormant f_dm_scanner_green()
	sleep_until (s_dm_scanner_green == "PLAY", 1);
 	dprint ("::: starting scanner green sound :::");
 	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_scanner_green", NONE, 1);
end

script dormant f_dm_bridge_elevator()
	sleep_until (s_dm_bridge_elevator == "PLAY", 1);
	dprint ("::: starting bridge elevator sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_bridge_elevator", NONE, 1);
end

script dormant f_dm_atrium_elevator()
	sleep_until (s_dm_atrium_elevator == "PLAY", 1);
	dprint ("::: starting atrium elevator sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_atrium_elevator", NONE, 1);      
end

script dormant f_dm_flush_core()
	sleep_until (s_dm_flush_core == "PLAY", 1);
	dprint ("::: starting flush core sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_flush_core", NONE, 1);
end

script dormant f_dm_blue_column_1()
	sleep_until (s_dm_blue_column_1 == "PLAY", 1);
	dprint ("::: starting blue column 1 sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_blue_column_1", NONE, 1);
end

script dormant f_dm_blue_column_2()
	sleep_until (s_dm_blue_column_2 == "PLAY", 1);
	dprint ("::: starting blue column 2 sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_blue_column_2", NONE, 1);
end

script dormant f_dm_blue_column_3()
	sleep_until (s_dm_blue_column_3 == "PLAY", 1);
	dprint ("::: starting blue column 3 sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_blue_column_3", NONE, 1);
end

script dormant f_dm_blue_column_4()
	sleep_until (s_dm_blue_column_4 == "PLAY", 1);
	dprint ("::: starting blue column 4 sound :::");
	sound_impulse_start ("sound\environments\solo\m020\machines_devices\s_dm_blue_column_4", NONE, 1);
end
      
