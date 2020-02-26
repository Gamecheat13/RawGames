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

; Zone Set Index
global short zs_portal_idx 			      = 0;	// default / start
global short zs_caves_idx 			      = 1;	// caves
global short zs_exterior1_idx 		    = 2;	// canyon
global short zs_forts_idx 			      = 3;	// forts
global short zs_beam1_idx 			      = 5;	// beam room
global short zs_start2_idx 			      = 6;	// start area 2
global short zs_exterior2_idx 		    = 7;	// exterior 2
global short zs_forts2_idx 			      = 8;	// forts 2
global short zs_beam2_idx 			      = 10;	// beam 2
global short zs_donut_idx 			      = 11;	// donut ring
global short zs_cryptum_idx 			    = 13;	// crpytum interior
global short zs_escape_idx 			      = 14;	// escape
global short zs_cin_m30_idx						= 17; // relay cinematic
global short zs_cin_m31_idx						= 15; // didact cinematic
global short zs_cin_m32_idx						= 16; // end cinematic		

; Insertion Index
global short portal_ins_idx 			    = 0;	// default / start
global short caves_ins_idx 			      = 1;	// caves
global short exterior1_ins_idx 		    = 2;	// canyon
global short forts_ins_idx 			      = 3;	// forts
global short beam1_ins_idx 			      = 4;	// beam room
global short start2_ins_idx 			    = 5;	// start area 2
global short exterior2_ins_idx 		    = 6;	// exterior 2
global short forts2_ins_idx 			    = 7;	// forts 2
global short beam2_ins_idx 			      = 8;	// beam 2
global short donut_ins_idx 			      = 9;	// donut ring
global short cryptum_ins_idx 			    = 10;	// crpytum interior
global short escape_ins_idx 			    = 11;	// escape

; Zone Sets
global short s_zoneset_all					= 0;

; =================================================================================================
; =================================================================================================
; *** INSERTIONS ***
; =================================================================================================
; =================================================================================================

script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
 //dprint( "::: f_insertion_index_load :::" );
 inspect( s_insertion );
 
 if (s_insertion == portal_ins_idx) then
  b_started = TRUE;
  ins_portal();
 end
 if (s_insertion == caves_ins_idx) then
  b_started = TRUE;
  ins_caves();
 end
 if (s_insertion == exterior1_ins_idx) then
  b_started = TRUE;
  ins_exterior1();
 end
 if (s_insertion == forts_ins_idx) then
  b_started = TRUE;
  ins_forts();
 end
 if (s_insertion == beam1_ins_idx) then
  b_started = TRUE;
  ins_beam1();
 end
 if (s_insertion == start2_ins_idx) then
  b_started = TRUE;
  ins_exterior2();
 end
 if (s_insertion == exterior2_ins_idx) then
  b_started = TRUE;
  ins_exterior2();
 end
 if (s_insertion == forts2_ins_idx) then
  b_started = TRUE;
  ins_forts2();
 end 
 if (s_insertion == beam2_ins_idx) then
  b_started = TRUE;
  ins_beam2();
 end 
 if (s_insertion == donut_ins_idx) then
  b_started = TRUE;
  ins_donut();
 end 
 if (s_insertion == escape_ins_idx) then
  b_started = TRUE;
  ins_escape();
 end 

 if ( not b_started ) then
  dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
  inspect( s_insertion );
 end

end

script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "1_start"; 

 if ( s_index == zs_portal_idx ) then
  zs_return = "1_start";
 end
 if ( s_index == zs_caves_idx ) then
  zs_return = "1_caves";
 end
 if ( s_index == zs_exterior1_idx ) then
  zs_return = "1_canyon";
 end
 if ( s_index == zs_forts_idx ) then
  zs_return = "1_forts";
 end
 if ( s_index == zs_beam1_idx ) then
  zs_return = "1_pylon";
 end
 if ( s_index == zs_start2_idx ) then
  zs_return = "2_start";
 end
 if ( s_index == zs_exterior2_idx ) then
  zs_return = "2_canyon";
 end
 if ( s_index == zs_forts2_idx ) then
  zs_return = "2_forts";
 end
 if ( s_index == zs_beam2_idx ) then
  zs_return = "2_pylon";
 end
 if ( s_index == zs_donut_idx ) then
  zs_return = "3_donut";
 end
 if ( s_index == zs_cryptum_idx ) then
  zs_return = "3_cryptum";
 end
 if ( s_index == zs_escape_idx ) then
  zs_return = "4_escape";
 end

 // return
 zs_return;
end




; =================================================================================================
; PORTAL
; =================================================================================================

script static void ipo()
	f_insertion_reset( portal_ins_idx );
end

script static void ins_portal()

	f_insertion_begin( "OBSERVATION DECK" );
	f_insertion_zoneload( zs_portal_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py1_start.p0, ps_insertion_py1_start.p1, ps_insertion_py1_start.p2, ps_insertion_py1_start.p3 );
	
	b_m30_music_progression = 0;
	pup_play_show ("obs_portal");
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player0, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player1, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player2, 1);
	sound_impulse_start(sound\environments\solo\m030\amb_m30_beta\amb_m30_machines\amb_m30_machine_forerunner_portal_flash, player3, 1);
	
	dprint ("portal flash!");	
	f_insertion_playerprofile( default_SP, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	SetSkyObjectOverride("");
	
	zone_set_trigger_volume_enable ("begin_zone_set:2_start", FALSE);
	zone_set_trigger_volume_enable ("zone_set:2_start", FALSE);
	
	zone_set_trigger_volume_enable ("begin_zone_set:3_donut", FALSE);
	zone_set_trigger_volume_enable ("zone_set:3_donut", FALSE);
	
end


; =================================================================================================
; CAVES
; =================================================================================================

script static void ica()
	f_insertion_reset( caves_ins_idx );
end

script static void ins_caves()

	f_insertion_begin( "CAVES" );
	f_insertion_zoneload( zs_caves_idx, FALSE );
	f_insertion_playerwait();
	
	b_m30_music_progression = 20;
	f_insertion_teleport( ps_insertion_py1_caves.p0, ps_insertion_py1_caves.p1, ps_insertion_py1_caves.p2, ps_insertion_py1_caves.p3 );
	f_insertion_playerprofile( default_SP, FALSE );
	dprint ("default player profile set");
	f_insertion_end();
	
	music_start('Play_mus_m30');
	SetSkyObjectOverride("");
	
	self_illum_color_setting_set(1);
	
	effects_distortion_enabled = 1;
	
end

; =================================================================================================
; EXTERIOR 1
; =================================================================================================
// RALLY POINT BRAVO
script static void ie1()
	f_insertion_reset( exterior1_ins_idx );
end

script static void ins_exterior1()
	
	f_insertion_begin( "EXTERIOR 1" );
	f_insertion_zoneload( zs_exterior1_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py1_ext.p0, ps_insertion_py1_ext.p1, ps_insertion_py1_ext.p2, ps_insertion_py1_ext.p3 );
	f_insertion_playerprofile( default_FR, FALSE );
	dprint ("ext1 player profile set");
	f_insertion_end();

	b_m30_music_progression = 30;
	SetSkyObjectOverride("");
		
	sleep_forever (m30_hallway_1_enter);
	thread (f_door_hallway_1_out_open());
	
	effects_distortion_enabled = 0;
	
	self_illum_color_setting_set(1);
	
end

; =================================================================================================
; FORTS
; =================================================================================================

script static void ifo1()
	f_insertion_reset( forts_ins_idx );
end

script static void ins_forts()
	
	f_insertion_begin( "FORTS 1" );
	f_insertion_zoneload( zs_forts_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py1_forts.p0, ps_insertion_py1_forts.p1, ps_insertion_py1_forts.p2, ps_insertion_py1_forts.p3 );
	f_insertion_playerprofile( default_FR, FALSE );
	f_insertion_end();
	
	b_m30_music_progression = 40;
	SetSkyObjectOverride("");
	
	thread (f_door_hallway_2_out_open());
	
	effects_distortion_enabled = 0;
	
	self_illum_color_setting_set(1);
	
end

; =================================================================================================
; BEAM 1
; =================================================================================================

script static void ib1()
	f_insertion_reset( beam1_ins_idx );
end

script static void ins_beam1()
	
	f_insertion_begin( "PYLON 1" );
	f_insertion_zoneload( zs_beam1_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py1_beam.p0, ps_insertion_py1_beam.p1, ps_insertion_py1_beam.p2, ps_insertion_py1_beam.p3 );
	f_insertion_playerprofile( default_FR, FALSE );
	f_insertion_end();
		
	wake (f_pylon1_setup);
	object_hide (forts1_reclaimer, TRUE);

	b_m30_music_progression = 50;
	SetSkyObjectOverride("");
		
	effects_distortion_enabled = 1;

	self_illum_color_setting_set(1);

	// Move the pylon beam effects into place
	pup_play_show(pyelectric_05);

end

; =================================================================================================
; EXTERIOR 2
; =================================================================================================
// RALLY POINT CHARLIE
script static void ie2()
	f_insertion_reset( exterior2_ins_idx );
end

script static void ins_exterior2()
	
	f_insertion_begin( "EXTERIOR 2" );
	f_insertion_zoneload( zs_start2_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py2_caves.p0, ps_insertion_py2_caves.p1, ps_insertion_py2_caves.p2, ps_insertion_py2_caves.p3 );
	f_insertion_playerprofile( default_FR, FALSE );
	f_insertion_end();
	
	b_m30_music_progression = 70;
	SetSkyObjectOverride("");
	
	effects_distortion_enabled = 1;
	self_illum_color_setting_set(1);	
		
end

; =================================================================================================
; FORTS 2
; =================================================================================================

script static void ifo2()
	f_insertion_reset( forts2_ins_idx );
end

script static void ins_forts2()
	
	zone_set_trigger_volume_enable ("zone_set:2_elevator:*", FALSE);
	
	//wake (forts2_streaming_warp);
	
	f_insertion_begin( "FORTS 2" );
	f_insertion_zoneload( zs_forts2_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py2_forts.p0, ps_insertion_py2_forts.p1, ps_insertion_py2_forts.p2, ps_insertion_py2_forts.p3 );
	f_insertion_playerprofile( default_BOTH, FALSE );
	f_insertion_end();
	
	b_m30_music_progression = 80;
	effects_distortion_enabled = 0;
	self_illum_color_setting_set(1);
	
	sleep (30 * 2);
	
	door_hallway_3_out->open_default();
	
end

; =================================================================================================
; BEAM 2
; =================================================================================================

script static void ib2()
	f_insertion_reset( beam2_ins_idx );
end

script static void ins_beam2()
	
	f_insertion_begin( "PYLON 2" );
	f_insertion_zoneload( zs_beam2_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_py2_beam.p0, ps_insertion_py2_beam.p1, ps_insertion_py2_beam.p2, ps_insertion_py2_beam.p3 );
	f_insertion_playerprofile( default_BOTH, FALSE );
	f_insertion_end();
	
	b_m30_music_progression = 90;
	SetSkyObjectOverride("");
	wake (f_pylon2_setup);
	object_hide (forts2_reclaimer, TRUE);
	effects_distortion_enabled = 1;
	self_illum_color_setting_set(1);
	
end


; =================================================================================================
; DONUT
; =================================================================================================
// RALLY POINT DELTA
script static void ido()
	f_insertion_reset( donut_ins_idx );
end

script static void ins_donut()
	
	f_insertion_begin( "DONUT" );
	f_insertion_zoneload( zs_donut_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_donut.p0, ps_insertion_donut.p1, ps_insertion_donut.p2, ps_insertion_donut.p3 );
	f_insertion_playerprofile( default_BOTH, FALSE );
	f_insertion_end();
	
	pup_play_show ("donut_portal");
	
	b_m30_music_progression = 100;
	SetSkyObjectOverride("");
	
	effects_distortion_enabled = 1;
	
	self_illum_color_setting_set(1);	
		
end

; =================================================================================================
; ESCAPE
; =================================================================================================

script static void ies()
	f_insertion_reset( escape_ins_idx );
end

script static void ins_escape()
	
	f_insertion_begin( "ESCAPE" );
	f_insertion_zoneload( zs_escape_idx, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_escape.p0, ps_insertion_escape.p1, ps_insertion_escape.p2, ps_insertion_escape.p3 );
	f_insertion_playerprofile( default_BOTH, FALSE );
	f_insertion_end();
	
	b_m30_music_progression = 120;
	SetSkyObjectOverride("");
	
	effects_distortion_enabled = 1;
	
	self_illum_color_setting_set(1);
	
end


// =================================================================================================
// =================================================================================================
// *** CLEANUP ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// PORTAL
// =================================================================================================

//script static void f_portal_cleanup()
//	sleep_forever (f_portal_main);
//end

// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================

// =================================================================================================
// Loadouts
// =================================================================================================
/*

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

// =================================================================================================
// Insertion Fade
// =================================================================================================

global boolean b_insertion_fade_in = FALSE;
script dormant f_insertion_fade_in

	sleep_until (b_insertion_fade_in);
	// this is a global script
	insertion_fade_to_gameplay();
end
