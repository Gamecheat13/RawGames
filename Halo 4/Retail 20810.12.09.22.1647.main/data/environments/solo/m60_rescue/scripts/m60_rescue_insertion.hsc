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
global boolean b_insertion_reset		= TRUE;

; Mission Started
global boolean b_mission_started 		=	FALSE;

; Insertion
global short s_intro_cinematic 				= 0;	;; intro cutscene
global short s_peak_ins_idx 					= 1;	;; default / start
global short s_plains_ins_idx 				= 2;	;; plains / trails 2
global short s_trails_2_ins_idx				= 3;	;; trails 3
global short s_boulders_a_ins_idx 		= 4;	;; boulders
global short s_caves_a_ins_idx   	  	= 5;	;; caves
global short s_rally_ins_idx        	= 6;	;; rally
global short s_infinity_ins_idx     	= 7;	;; infinity berth
global short s_infinity_deck_ins_idx 	= 8;	;; outer deck
global short s_mid_cinematic	 				= 9;	;; middle cutscene
global short s_end_cinematic	 				= 10; ;; end cutscene
global short s_rally_demo_ins_idx			= 11; ;;rally demo

; Zone Sets
global short zs_peak							= 0;
global short zs_trail_c						= 16;
global short zs_trail_boulders		= 2;
global short zs_boulders			= 3;
global short zs_caves							= 4;
global short zs_caves_rally				= 5;
global short zs_infinity_berth		= 8;
global short zs_infinity_ele			= 11;
global short zs_outer_deck				= 13;
global short zs_cin_m060					= 17;
global short zs_trail_a						= 18;
global short zs_cin_m062					= 19;
global short zs_cin_m065					= 20;
global short zs_rally_demo				= 7;
global short zs_inf_airlock				= 14;
global short zs_cin_m062_trail			= 25;

script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
 //dprint( "::: f_insertion_index_load :::" );
 inspect( s_insertion );
 
 
 if (s_insertion == s_intro_cinematic and not b_game_emulate and editor_mode()) then
 	b_started = TRUE;
  ins_cliff();
 end
 
 if (s_insertion == s_intro_cinematic) then
 	b_started = TRUE;
  ins_cine();
 end
 if (s_insertion == s_peak_ins_idx) then
  b_started = TRUE;
  ins_cliff();
 end
 if (s_insertion == s_plains_ins_idx) then
  b_started = TRUE;
  ins_plains();
 end
 if (s_insertion == s_trails_2_ins_idx) then
  b_started = TRUE;
  ins_trails_2();
 end
 if (s_insertion == s_boulders_a_ins_idx) then
  b_started = TRUE;
  ins_boulders_a();
 end
 if (s_insertion == s_caves_a_ins_idx) then
  b_started = TRUE;
  ins_caves_a();
 end
 if (s_insertion == s_rally_ins_idx) then
  b_started = TRUE;
  ins_rally();
 end
 if (s_insertion == s_infinity_ins_idx) then
  b_started = TRUE;
  ins_infinity();
 end 
 if (s_insertion == s_infinity_deck_ins_idx) then
  b_started = TRUE;
  ins_infinity_deck();
 end 
 if (s_insertion == s_rally_demo_ins_idx) then
  b_started = TRUE;
  ins_rally_demo();
 end 


 if ( not b_started ) then
  dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
  inspect( s_insertion );
 end

end

script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "peak"; 

 if ( s_index == zs_cin_m060 ) then
  zs_return = "cin_m60_peak";
 end
 if ( s_index == zs_peak ) then
  zs_return = "peak";
 end
 if ( s_index == zs_trail_c ) then
  zs_return = "trail_c";
 end
 if ( s_index == zs_trail_boulders ) then
  zs_return = "trail_boulders";
 end
 if ( s_index == zs_caves ) then
  zs_return = "caves";
 end
 if ( s_index == zs_caves_rally ) then
  zs_return = "caves_rally";
 end
 if ( s_index == zs_infinity_berth ) then
  zs_return = "infinity_berth";
 end
 if ( s_index == zs_outer_deck ) then
  zs_return = "infinity_outer_deck";
 end
 if ( s_index == zs_rally_demo ) then
  zs_return = "rally_point_infinity_berth";
 end
 // return
 zs_return;
end

; =================================================================================================
; =================================================================================================
; *** INSERTIONS ***
; =================================================================================================
; =================================================================================================

; =================================================================================================
; INTRO CINEMATIC
; =================================================================================================


script static void icc()
	f_insertion_reset( s_intro_cinematic );
end

script static void ins_cine()

	f_insertion_begin( "CINEMATIC" );
	
	cinematic_enter( cin_m060_infinityrescue, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	f_insertion_zoneload( zs_cin_m060, FALSE );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
	hud_stop_global_animtion (screen_fade_out);
		
	f_start_mission( cin_m060_infinityrescue );
	cinematic_exit_no_fade( cin_m060_infinityrescue, TRUE ); 
	dprint( "Cinematic exited!" );

	// start the cliff insertion point
	ins_cliff();

end

; =================================================================================================
; PEAK
; =================================================================================================

/*script static void icl()
	ins_cliff();
end

script static void ins_cliff()
	if b_debug then
		print ("*** INSERTION POINT: CLIFF ***");
	end

	s_insertion_index = s_peak_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("peak");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (peak) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_peak_ins_idx, 1);
	
//	object_teleport_to_ai_point (player0(), ps_insertion_cliff.p0);
//	object_teleport_to_ai_point (player1(), ps_insertion_cliff.p1);
//	object_teleport_to_ai_point (player2(), ps_insertion_cliff.p2);
//	object_teleport_to_ai_point (player3(), ps_insertion_cliff.p3);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (peak)");
	end
	
	sleep (1);

	// HAX: look for a better way to return to gameplay
	
	hud_play_global_animtion (screen_fade_out);

	insertion_fade_to_gameplay();
	
	sleep (30);
	
	cinematic_show_letterbox (TRUE);
	
	hud_stop_global_animtion (screen_fade_out);

	b_mission_started = TRUE;
	
	sleep (30);
	
	cinematic_set_title (peakletterbox);
	
	sleep (30 * 13);
	
	cinematic_show_letterbox (FALSE);
	
	hud_play_global_animtion (screen_fade_in);
	
	hud_stop_global_animtion (screen_fade_in);
	
	thread(m60_1st_fof_ping());
	
end
*/

script static void icl()
	f_insertion_reset( s_peak_ins_idx );
end

script static void ins_cliff()

	soft_ceiling_enable ("softwall_blocker_peak_a", FALSE);
	soft_ceiling_enable ("softwall_blocker_trail_c", FALSE);

	f_insertion_begin( "PEAK" );
	f_insertion_zoneload( zs_peak, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_cliff.p0, ps_insertion_cliff.p1, ps_insertion_cliff.p2,ps_insertion_cliff.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();
	
	hud_play_global_animtion (screen_fade_out);

	object_create (intro_cryptum);
	wake (cryptum_fx_peak);
	
	insertion_fade_to_gameplay();
	
	wake (f_cliff_main);
	wake (f_thicket_main);
	
  hud_play_global_animtion (screen_fade_out);
  cinematic_show_letterbox (TRUE);
  sleep_s (1.5);
  cinematic_set_title (peakletterbox);
  thread(m60_1st_fof_ping());
  hud_stop_global_animtion (screen_fade_out);
  sleep_s (3.5);     
  hud_play_global_animtion (screen_fade_in);
  hud_stop_global_animtion (screen_fade_in);
  cinematic_show_letterbox (FALSE);
	
	sleep (30 * 5);
	
	cui_hud_set_new_objective (chtitleintro);
	
	f_blip_object (crumb_dogtag_01, "recon");
	
	ai_allegiance(player, human);

	effects_distortion_enabled = 0;

end

; =================================================================================================
; PLAINS
; =================================================================================================

/*script static void ipa()
	ins_plains();
end

script static void ins_plains()
	if b_debug then
		print ("*** INSERTION POINT: PLAINS ***");
	end

	s_insertion_index = s_plains_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("trail_c");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (trail_c) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_plains_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (trail_c)");
	end
	
	sleep (1);

	// Teleport
	object_teleport_to_ai_point (player0(), ps_insertion_plains.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_plains.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_plains.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_plains.p3);

	b_mission_started = TRUE;
	
	wake (f_trailstwo_main);
	
end
*/

script static void ipa()
	f_insertion_reset( s_plains_ins_idx );
end

script static void ins_plains()

	wake (f_plains);

	wake (f_trailstwo_main);

	ai_allegiance(player, human);

	f_insertion_begin( "PLAINS" );
	f_insertion_zoneload( zs_trail_c, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_plains.p0, ps_insertion_plains.p1,ps_insertion_plains.p2,ps_insertion_plains.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	music_start('Play_mus_m60');
	b_m60_music_progression = 10;
	effects_distortion_enabled = 0;

end

; =================================================================================================
; TRAILS 2
; =================================================================================================

/*script static void it2()
	ins_trails_2();
end

script static void ins_trails_2()
	if b_debug then
		print ("*** INSERTION POINT: TRAILS 2 ***");
	end

	s_insertion_index = s_boulders_a_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("trail_boulders");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (trail_boulders) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_boulders_a_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (trail_boulders)");
	end
	
	sleep (1);

	// Teleport
	object_teleport_to_ai_point (player0(), ps_insertion_t2.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_t2.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_t2.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_t2.p3);

	wake (trail_2);

	b_mission_started = TRUE;
end
*/

script static void it2()
	f_insertion_reset( s_trails_2_ins_idx );
end

// RALLY POINT BRAVO
script static void ins_trails_2()

//	device_set_power (door_treehouse_exit, 0);

	wake (f_laskytemp);

	ai_allegiance(player, human);

	f_insertion_begin( "TRAILS 3" );
	f_insertion_zoneload( zs_trail_boulders, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_t2.p0, ps_insertion_t2.p1,ps_insertion_t2.p2,ps_insertion_t2.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

//	device_set_power (door_treehouse_exit, 0);

	music_start('Play_mus_m60');	
	b_m60_music_progression = 50;
	effects_distortion_enabled = 0;
	
end

; =================================================================================================
; BOULDERS_A
; =================================================================================================

/*script static void iba()
	ins_boulders_a();
end

script static void ins_boulders_a()
	if b_debug then
		print ("*** INSERTION POINT: BOULDERS A ***");
	end

	s_insertion_index = s_boulders_a_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("trail_boulders");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (trail_boulders) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_boulders_a_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (trail_boulders)");
	end
	
	sleep (1);

	// Teleport
	object_teleport_to_ai_point (player0(), ps_insertion_boulder_a.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_boulder_a.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_boulder_a.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_boulder_a.p3);

	b_mission_started = TRUE;
end

*/

script static void iba()
	f_insertion_reset( s_boulders_a_ins_idx );
end

script static void ins_boulders_a()

	wake (d_start);

	ai_allegiance(player, human);

	f_insertion_begin( "BOULDER" );
	f_insertion_zoneload( zs_trail_boulders, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_boulder_a.p0, ps_insertion_boulder_a.p1,ps_insertion_boulder_a.p2,ps_insertion_boulder_a.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	music_start('Play_mus_m60');
	b_m60_music_progression = 60;
	effects_distortion_enabled = 0;

end


; =================================================================================================
; CAVES_A
; =================================================================================================

/*script static void ica()
	ins_caves_a();
end

script static void ins_caves_a()
	if b_debug then
		print ("*** INSERTION POINT: CAVES A ***");
	end

	s_insertion_index = s_caves_a_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("caves");
	sleep (1);
	wake (f_caves_main);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (boulders_caves) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_caves_a_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (boulders_caves)");
	end
	
	sleep (1);

	// Teleport
	object_teleport_to_ai_point (player0(), ps_insertion_caves_a.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_caves_a.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_caves_a.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_caves_a.p3);

	b_mission_started = TRUE;
end
*/

script static void ica()
	f_insertion_reset( s_caves_a_ins_idx );
end

script static void ins_caves_a()

	wake (f_caves_main);

	ai_allegiance(player, human);

	f_insertion_begin( "CAVES" );
	f_insertion_zoneload( zs_caves, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_caves_a.p0, ps_insertion_caves_a.p1,ps_insertion_caves_a.p2,ps_insertion_caves_a.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	effects_distortion_enabled = 0;
	
	music_start('Play_mus_m60');
	b_m60_music_progression = 70;
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

end


; =================================================================================================
; RALLY POINT
; =================================================================================================

/*script static void irp()
	ins_rally();
end

script static void ins_rally()
	if b_debug then
		print ("*** INSERTION POINT: RALLY POINT ***");
	end

	s_insertion_index = s_rally_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("caves_rally");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (rally_point) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_rally_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (rally_point)");
	end
	
	sleep (1);

	// Teleport
	
	//render_atmosphere_fog (0);
	
	effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );

	unit_add_equipment (player0, rally_profile, TRUE, FALSE);

	object_teleport_to_ai_point (player0(), ps_insertion_rally.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_rally.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_rally.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_rally.p3);

	b_mission_started = TRUE;

	ai_place (sq_rally_pel_2);
	
	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "mongoose_d", player0);
	
	sleep_until (vehicle_test_seat (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), "mongoose_d"), 1);
	
	wake (f_rally_main);
	
	fade_in (0, 0, 0, 90);
	
	data_mine_set_mission_segment("m60_rally");

	sleep (30 * 3);

	hud_play_global_animtion (screen_fade_out);
	
	sleep (15);
	
	cinematic_show_letterbox (TRUE);
	
	hud_stop_global_animtion (screen_fade_out);
	
	effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );
	
	wake (f_rally_main);
	
	sleep (30 * 3);
	
	cinematic_set_title (rallyletterbox);
	
	sleep (30 * 10);

	cinematic_show_letterbox (false);

	hud_play_global_animtion (screen_fade_in);
	
	hud_stop_global_animtion (screen_fade_in);
	
end

*/

script static void irp()
	f_insertion_reset( s_rally_ins_idx );
end

// RALLY POINT CHARLIE
script static void ins_rally()

	fade_out (0, 0, 0, 0);

	f_insertion_begin( "RALLY" );
	f_insertion_zoneload( zs_caves_rally, FALSE );
	f_insertion_playerwait();
	
	f_insertion_teleport( ps_insertion_rally.p0, ps_insertion_rally.p1,ps_insertion_rally.p2,ps_insertion_rally.p3 );
	f_insertion_playerprofile( rally_profile, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	ai_allegiance(player, human);

	effects_distortion_enabled = 0;
	music_start('Play_mus_m60');
	b_m60_music_progression = 80;
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

/*	ai_place (sq_rally_pel_2);
	
	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_l05", player0);
	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_l04", player1);
	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_r05", player2);
	vehicle_load_magic ((ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), "pelican_p_r04", player3);

	sleep_until (player_in_vehicle (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver)), 1);

*/

	wake (f_rally_main);

/*	fade_in (0, 0, 0, 120);
	
//	vehicle_set_player_interaction (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), "pelican_p_l05", 0, 0);
	
//	ai_vehicle_reserve (ai_vehicle_get_from_spawn_point (sq_rally_pel_2.driver), TRUE);
	
	data_mine_set_mission_segment("m60_rally");

	hud_play_global_animtion (screen_fade_out);
	
	sleep (15);
	
	cinematic_show_letterbox (TRUE);
	
	hud_stop_global_animtion (screen_fade_out);
	
//	wake (f_rally_main);
	
	sleep (30 * 3);
	
	cinematic_set_title (rallyletterbox);
	
	sleep (30 * 10);

	cinematic_show_letterbox (false);

	hud_play_global_animtion (screen_fade_in);
	
	hud_stop_global_animtion (screen_fade_in);
*/
end

; =================================================================================================
; INFINITY
; =================================================================================================

/*script static void ipi()
	ins_infinity();
end

script static void ins_infinity()
	if b_debug then
		print ("*** INSERTION POINT: INFINITY ***");
	end

	s_insertion_index = s_infinity_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("infinity_berth_infinity_causeway");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (infinity_berth_infinity_causeway) to fully load...");
	end
	
	render_atmosphere_fog (FALSE); 	
	wake (inf_cause);	
	sleep_until (current_zone_set_fully_active() == s_infinity_ins_idx, 1);
	
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (rally_point_infinity_berth)");
	end
	
	sleep (1);

	// Teleport
	object_teleport_to_ai_point (player0(), ps_insertion_infinity.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_infinity.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_infinity.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_infinity.p3);

	b_mission_started = TRUE;
end

*/

script static void ipi()
	f_insertion_reset( s_infinity_ins_idx );
end

script static void ins_infinity()

	//render_atmosphere_fog (FALSE); 	
	wake (inf_cause);	

	f_insertion_begin( "INFINITY" );
	f_insertion_zoneload( zs_inf_airlock, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_infinity.p0, ps_insertion_infinity.p1,ps_insertion_infinity.p2,ps_insertion_infinity.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	effects_distortion_enabled = 0;
	music_start('Play_mus_m60');
	b_m60_music_progression = 100;
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

end

; =================================================================================================
; INFINITY DECK
; =================================================================================================

/*script static void ipd()
	ins_infinity_deck();
end

script static void ins_infinity_deck()
	if b_debug then
		print ("*** INSERTION POINT: INFINITY DECK***");
	end

	s_insertion_index = s_infinity_deck_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end
	
	// Switch to correct zone set unless "set_all" is loaded 
	
	switch_zone_set ("infinity_outer_deck");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (facilities_elevator_infinity_outer_deck) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_infinity_deck_ins_idx, 1);
	
	if b_debug then 
		print ("::: INSERTION: Finished loading (facilities_elevator_infinity_outer_deck)");
	end
	
	sleep (1);

	// Teleport
	render_atmosphere_fog (FALSE);
	object_create (decktest);
	wake (outer_deck);
	object_teleport_to_ai_point (player0(), ps_insertion_deck.p0);
	object_teleport_to_ai_point (player1(), ps_insertion_deck.p1);
	object_teleport_to_ai_point (player2(), ps_insertion_deck.p2);
	object_teleport_to_ai_point (player3(), ps_insertion_deck.p3);

	object_create (temp_mech);
	
	thread (act_2_cleanup());
	
	b_mission_started = TRUE;
end
*/

script static void ipd()
	f_insertion_reset( s_infinity_deck_ins_idx );
end

script static void ins_infinity_deck()

//	render_atmosphere_fog (FALSE);
	object_create (decktest);
	wake (outer_deck);

//	object_create (temp_mech);
	
	thread (act_2_cleanup());

	ai_allegiance(player, human);

	f_insertion_begin( "INFINITY" );
	f_insertion_zoneload( zs_outer_deck, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_deck.p0, ps_insertion_deck.p1,ps_insertion_deck.p2,ps_insertion_deck.p3 );
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	effects_distortion_enabled = 0;
	music_start('Play_mus_m60');
	b_m60_music_progression = 160;
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);

end

; =================================================================================================
; RALLY DEMO
; =================================================================================================

script static void ird()
	f_insertion_reset(s_rally_demo_ins_idx);
end

script static void ins_rally_demo()
	thread (act_2_cleanup());

	ai_allegiance(player, human);

	f_insertion_begin( "RALLY DEMO" );
	f_insertion_zoneload( zs_rally_demo, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_insertion_demo.p0, ps_insertion_demo.p1,ps_insertion_demo.p2,ps_insertion_demo.p3);
	effect_attached_to_camera_new ( environments\solo\m60_rescue\fx\embers\embers_ambient_floating );
	effect_attached_to_camera_stop(environments\solo\m60_rescue\fx\ambient_life\forest_player_gnats.effect);
	f_insertion_playerprofile( default_coop, FALSE );
	dprint ("default player profile set");
	f_insertion_end();

	object_create (veh_demo);
	
	wake (f_bowl_setup);
	effects_distortion_enabled = 0;

end

// =================================================================================================
// =================================================================================================
// *** CLEANUP ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// CLIFF
// =================================================================================================

script static void f_cliff_cleanup()
	sleep_forever (f_cliff_main);
end

// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================

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

// =================================================================================================
// Insertion Fade
// =================================================================================================

global boolean b_insertion_fade_in = FALSE;
script dormant f_insertion_fade_in

	sleep_until (b_insertion_fade_in);
	// this is a global script
	insertion_fade_to_gameplay();
end
