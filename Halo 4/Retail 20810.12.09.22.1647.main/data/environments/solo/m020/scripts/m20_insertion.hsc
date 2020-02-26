// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

// Debug Options
global boolean b_debug 							= TRUE;
global boolean b_breakpoints				=	FALSE;
global boolean b_md_print						= TRUE;
global boolean b_debug_objectives 	= FALSE;
global boolean b_editor 						=	editor_mode();
global boolean b_game_emulate				=	FALSE;
global boolean b_cinematics 				=	TRUE;
global boolean b_editor_cinematics 	= FALSE;
global boolean b_encounters					=	TRUE;
global boolean b_dialogue 					=	TRUE;
global boolean b_skip_intro					=	FALSE;

// Mission Started
global boolean b_mission_started 	=	FALSE;

// Insertion
//global short s_insertion_index 	 	= 0;	// default / start
global short s_crater_ins_idx 		=	1;	// in and working
global short s_vista_ins_idx 			=	2;	// in and working
global short s_wreckage_ins_idx		=	3;	// in and working
global short s_field_ins_idx			=	4;	// in and working
global short s_gp_ext_ins_idx 		=	5;	// in and working
global short s_gp_int_ins_idx 		=	6;	// in and working
global short s_bridge_ins_idx 		=	7;	// in and working
global short s_courtyard_ins_idx  =	8;	// in and working
global short s_terminus_ins_idx 	=	9;	// in and working
global short s_intro_cinematic 		=	10;	



// ZONE SETS

global short s_zoneset_crater										=	0;
global short s_zoneset_vista										=	1;
global short s_zoneset_to_wreckage			 				=	2;
global short s_zoneset_wreckage_a								=	3;
global short s_zoneset_to_field			 						=	4;
global short s_zoneset_field			 							=	5;
global short s_zoneset_cathedral_ext			 			=	6;
global short s_zoneset_cathedral_int						=	7;
global short s_zoneset_bridge								 		=	8;
global short s_zoneset_courtyard								=	9;
global short s_zoneset_terminus									=	10;
global short s_zoneset_crater_cinematic					=	11;
global short s_zoneset_cathedral_cinematic			=	12;
global short s_zoneset_tower_cinematic					=	13;
global short s_zoneset_terminus_to_cin_m21				= 	14;
global short s_zoneset_field_to_cathedral				=	15;
global short s_zoneset_field_lean						=	16;

//no zoneset that is equal to these
global short s_zoneset_wreckage_b					 			=	14;
global short s_zoneset_wreckage_c								=	15;
global short s_zoneset_to_cathedral_ext					=	16;
global short s_zoneset_to_bridge 								=	17;
global short s_zoneset_to_courtyard			 				=	18;
global short s_zoneset_to_terminus							=	19;
//XXX TEMP FIX END
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

// =================================================================================================
// =================================================================================================
// *** INSERTIONS ***
// =================================================================================================
// =================================================================================================


// -------------------------------------------------------------------------------------------------
// CINEMATIC
// -------------------------------------------------------------------------------------------------
script static void icn()
		ins_cine();
end

script static void ins_cine()

//	if not( editor_mode() ) then
//	
//		f_insertion_begin( "CINEMATIC" );
//		
//		cinematic_enter( cin_m020_crater, TRUE );
//		cinematic_suppress_bsp_object_creation( TRUE );
//		f_insertion_zoneload( s_zoneset_crater, FALSE );
//		cinematic_suppress_bsp_object_creation( FALSE );
//		
//		f_start_mission( cin_m020_crater );
//		cinematic_exit( cin_m020_crater, TRUE ); 
//		dprint( "Cinematic exited!" );
//	
//		// start the crater
//		ins_crater();
//		wake (temp_cutscene_m20_crater);
//	end	
	dprint ("Unused");
end

// =================================================================================================
// CRATER
// =================================================================================================
script static void icr()
	ins_crater();
end

script static void ins_crater()
	if b_debug then
		 print ("*** INSERTION POINT: CRATER ***");
	end

	// Play the intro cinematic	
	if (b_cinematics and (not b_editor) or b_editor_cinematics  == TRUE) then
		f_insertion_begin( "CINEMATIC" );
				
		cinematic_enter( cin_m020_crater, TRUE );
		cinematic_suppress_bsp_object_creation( TRUE );
		f_insertion_zoneload( s_zoneset_crater_cinematic, FALSE );
		cinematic_suppress_bsp_object_creation( FALSE );
			
		f_start_mission( cin_m020_crater );
		cinematic_exit( cin_m020_crater, TRUE ); 
		dprint( "Cinematic exited!" );
	end

	s_insertion_index = s_crater_ins_idx;

	// Play the intro cinematics here when we get one
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			print ("*** CINEMATIC PLACEHOLDER ***");
			print ("*** CINEMATIC PLACEHOLDER ***");
	end

	// Switch to correct zone set unless "set_all" is loaded 
	//switch_zone_set ("01_crater");
	//zoneset_load( s_zoneset_crater	, TRUE );
	f_insertion_zoneload( s_zoneset_crater, FALSE );
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (crater) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_crater, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (crater)");
	end
	
	sleep (1);

	b_mission_started = TRUE;
	wake (temp_cutscene_m20_crater);
end

// =================================================================================================
// VISTA
// =================================================================================================
global boolean b_clearing_ins = FALSE;
script static void icl()
	ins_clearing();
end

script static void ins_clearing()
	if b_debug then
		 print ("*** INSERTION POINT: VISTA ***");
	end
	
	//insertion_snap_to_black();
	b_clearing_ins = TRUE;

	s_insertion_index = s_vista_ins_idx;
	
	//// stop earlier scripts from running
	f_crater_cleanup();

	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("03_vista");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (vista) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_vista, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (vista)");
	end
	
	music_start('Play_mus_m20');
	b_m20_music_progression = 20;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_clearing_insertion.player0);
	object_teleport_to_ai_point (player1, ps_clearing_insertion.player1);
	object_teleport_to_ai_point (player2, ps_clearing_insertion.player2);
	object_teleport_to_ai_point (player3, ps_clearing_insertion.player3);

	//// give us a vehicle to drive...
	//object_create (clearing_hog);
		
	b_mission_started = TRUE;
end


// =================================================================================================
// WRECKAGE
// =================================================================================================
global boolean b_graveyard_ins = FALSE;
script static void igy ()
	ins_graveyard();
end
	
script static void ins_graveyard()
	if b_debug then
		 print ("*** INSERTION POINT: WRECKAGE ***");
	end	
	
	//insertion_snap_to_black();
	b_graveyard_ins = TRUE;

	s_insertion_index = s_wreckage_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();

	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("05_wreckage_a");
	sleep (1);

	if b_debug then
		print ("::: INSERTION: Waiting for (wreckage) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_wreckage_a, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end

	if (b_debug) then 
		print ("::: INSERTION: Finished loading (wreckage)");
	end

	music_start('Play_mus_m20');
	b_m20_music_progression = 40;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_graveyard_insertion.player0);
	object_teleport_to_ai_point (player1, ps_graveyard_insertion.player1);
	object_teleport_to_ai_point (player2, ps_graveyard_insertion.player2);
	object_teleport_to_ai_point (player3, ps_graveyard_insertion.player3);

	//// give us a vehicle to drive...
	object_create (gy_hog);

	b_mission_started = TRUE;
end

// =================================================================================================
// FIELD
// =================================================================================================
global boolean b_field_ins = FALSE;
script static void ifi ()
	ins_field();
end
	
script static void ins_field()
	if b_debug then
		 print ("*** INSERTION POINT: FIELD ***");
	end	
	
	//insertion_snap_to_black();
	b_field_ins = TRUE;

	s_insertion_index = s_field_ins_idx;
	
	//// stop earlier scripts from running
	f_crater_cleanup();
	
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("09_field");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (field) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_field, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (field)");
	end

	music_start('Play_mus_m20');
	b_m20_music_progression = 50;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_field_insertion.player0);
	object_teleport_to_ai_point (player1, ps_field_insertion.player1);
	object_teleport_to_ai_point (player2, ps_field_insertion.player2);
	object_teleport_to_ai_point (player3, ps_field_insertion.player3);

	//// give us a vehicle to drive...
	object_create (field_hog);
		
	b_mission_started = TRUE;
end


// =================================================================================================
// GUARDPOST EXTERIOR 
// =================================================================================================
global boolean b_gp_ext_ins = FALSE;
script static void igpe()
	ins_gp_ext();
end
	
script static void ins_gp_ext()
	if b_debug then
		 print ("*** INSERTION POINT: GPE ***");
	end	
	
	//insertion_snap_to_black();
	b_gp_ext_ins = TRUE;

	s_insertion_index = s_gp_ext_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();
	f_drive_cleanup();
		
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("11_cathedral_ext");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (cathedral exterior) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_cathedral_ext, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (cathedral exterior)");
	end

	music_start('Play_mus_m20');
	b_m20_music_progression = 70;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_gp_ext_insertion.player0);
	object_teleport_to_ai_point (player1, ps_gp_ext_insertion.player1);
	object_teleport_to_ai_point (player2, ps_gp_ext_insertion.player2);
	object_teleport_to_ai_point (player3, ps_gp_ext_insertion.player3);

	//// give us a vehicle to drive...
	object_create (gpe_hog);

	b_mission_started = TRUE;
end

// =================================================================================================
// GUARDPOST INTERIOR
// =================================================================================================
global boolean b_gp_int_ins = FALSE;
script static void igpi()
	ins_gp_int();
end
	
// RALLY POINT BRAVO
script static void ins_gp_int()
	if b_debug then
		 print ("*** INSERTION POINT: GPI ***");
	end
	
	//insertion_snap_to_black();
	b_gp_int_ins = TRUE;
	
	s_insertion_index = s_gp_int_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();
	f_drive_cleanup();
	f_gp_ext_cleanup();
		
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("13_cathedral_int");
	sleep (1);
			
	if b_debug then
		print ("::: INSERTION: Waiting for (cathedral interior) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_cathedral_int, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end

	if (b_debug) then 
		print ("::: INSERTION: Finished loading (cathedral interior)");
	end
	
	music_start('Play_mus_m20');
	b_m20_music_progression = 80;
	
	SetSkyObjectOverride("");
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_gp_int_insertion.player0);
	object_teleport_to_ai_point (player1, ps_gp_int_insertion.player1);
	object_teleport_to_ai_point (player2, ps_gp_int_insertion.player2);
	object_teleport_to_ai_point (player3, ps_gp_int_insertion.player3);

	unit_add_equipment (player0, default_coop_respawn, TRUE, FALSE);
	unit_add_equipment (player1, default_coop_respawn, TRUE, FALSE);
	unit_add_equipment (player2, default_coop_respawn, TRUE, FALSE);
	unit_add_equipment (player3, default_coop_respawn, TRUE, FALSE);
		
	wake (f_gp_int_main);
	
end

// =================================================================================================
// BRIDGE
// =================================================================================================
global boolean b_bridge_ins = FALSE;
script static void ibr() 
	ins_bridge();
end

script static void ins_bridge()

	if b_debug then
		 print ("*** INSERTION POINT: BRDIGE ***");
	end	
	
	//insertion_snap_to_black();
	b_bridge_ins = TRUE;

	s_insertion_index = s_bridge_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();
	f_drive_cleanup();
	f_gp_ext_cleanup();
	f_gp_int_cleanup();
		
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("15_bridge");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (to_bridge) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_bridge, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (to_bridge)");
	end
	
	music_start('Play_mus_m20');
	b_m20_music_progression = 100;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_bridge_insertion.player0);
	object_teleport_to_ai_point (player1, ps_bridge_insertion.player1);
	object_teleport_to_ai_point (player2, ps_bridge_insertion.player2);
	object_teleport_to_ai_point (player3, ps_bridge_insertion.player3);
	
	thread (f_start_bridge_encounter());

end

// =================================================================================================
// COURTYARD
// =================================================================================================
global boolean b_courtyard_ins = FALSE;
script static void icy()
	ins_courtyard();
end
	
script static void ins_courtyard()
	if b_debug then
		 print ("*** INSERTION POINT: COURTYARD ***");
	end	
	
	//insertion_snap_to_black();
	b_courtyard_ins = TRUE;

	s_insertion_index = s_courtyard_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();
	f_drive_cleanup();
	f_gp_ext_cleanup();
	f_gp_int_cleanup();
	f_bridge_cleanup();
		
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("17_courtyard");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (to_courtyard) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_courtyard, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (to_courtyard)");
	end

	// Teleport
	object_teleport_to_ai_point (player0, ps_courtyard_insertion.player0);
	object_teleport_to_ai_point (player1, ps_courtyard_insertion.player1);
	object_teleport_to_ai_point (player2, ps_courtyard_insertion.player2);
	object_teleport_to_ai_point (player3, ps_courtyard_insertion.player3);
	
	wake (f_courtyard_main);
	
	courtyard_door->open();
	
	music_start('Play_mus_m20');
	b_m20_music_progression = 110;
	thread (f_mus_m20_e06_begin());
	
	courtyard_door->auto_trigger_close( tv_court_door_close, TRUE, TRUE, TRUE );
	
	sleep_until( courtyard_door->check_close(), 1 );
	dprint ("door has closed");
		
end

// =================================================================================================
// TERMINUS
// =================================================================================================
global boolean b_atrium_ins = FALSE;
script static void iat ()
	ins_atrium();
end
	
script static void ins_atrium()
	if b_debug then
		 print ("*** INSERTION POINT: TERMINUS ***");
	end	
	
	//insertion_snap_to_black();
	b_atrium_ins = TRUE;

	s_insertion_index = s_terminus_ins_idx;

	//// stop earlier scripts from running
	f_crater_cleanup();
	f_drive_cleanup();
	f_gp_ext_cleanup();
	f_gp_int_cleanup();
	f_bridge_cleanup();
	f_courtyard_cleanup();
		
	// Switch to correct zone set unless "set_all" is loaded 
	switch_zone_set ("19_terminus");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (terminus) to fully load...");
		//sleep_until (current_zone_set_fully_active() == s_zoneset_terminus, 1);
		sleep_until (preparingToSwitchZoneSet() == FALSE, 1);
	end
	
	if (b_debug) then 
		print ("::: INSERTION: Finished loading (terminus)");
	end

	music_start('Play_mus_m20');
	b_m20_music_progression = 120;
	
	// Teleport
	object_teleport_to_ai_point (player0, ps_atrium_insertion.player0);
	object_teleport_to_ai_point (player1, ps_atrium_insertion.player1);
	object_teleport_to_ai_point (player2, ps_atrium_insertion.player2);
	object_teleport_to_ai_point (player3, ps_atrium_insertion.player3);
	
	b_mission_started = TRUE;
	
	sleep (30*4);
	
	wake (f_terminus_main);
	
end



// =================================================================================================
// =================================================================================================
// *** CLEANUP ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// Crashsite
// =================================================================================================

script static void f_crater_cleanup()
	sleep_forever (f_crater_main);
end

// =================================================================================================
// Drive 
// =================================================================================================

script static void f_drive_cleanup()
	sleep_forever (f_drive_main);
end

// =================================================================================================
// Guardpost Ext 
// =================================================================================================

script static void f_gp_ext_cleanup()
	sleep_forever (f_gp_ext_main);
end

// =================================================================================================
// Guardpost Int 
// =================================================================================================

script static void f_gp_int_cleanup()
	sleep_forever (f_gp_int_main);
end


// =================================================================================================
// Bridge
// =================================================================================================

script static void f_bridge_cleanup()
	sleep_forever (f_bridge_main);
end

// =================================================================================================
// Courtyard
// =================================================================================================

script static void f_courtyard_cleanup()
	sleep_forever (f_courtyard_main);
end


// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================

// =================================================================================================
// Loadouts
// =================================================================================================

// =================================================================================================
// Loadouts
// =================================================================================================
/*
script static void f_loadout_set (string area)

	if area == "start" then
		player_set_profile (sp_start_mission, player0);
	  player_set_profile (sp_start_mission, player1);
	  player_set_profile (sp_start_mission, player2);
	  player_set_profile (sp_start_mission, player3);
	  
	elseif area == "default" or area == "NONE" then
		player_set_profile (default_respawn, player0);
		player_set_profile (default_respawn, player1);
		player_set_profile (default_respawn, player2);
		player_set_profile (default_respawn, player3);

	elseif area == "beacon" then
		player_set_profile (default_single_sniper, player0);
		player_set_profile (default_single_sniper, player1);
		player_set_profile (default_single_sniper, player2);
		player_set_profile (default_single_sniper, player3);
	end

end
*/

//OLD LOADOUT SCRIPT
script static void f_loadout_set (string area)

	if area == "default" then
		if game_is_cooperative() then
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
script dormant f_insertion_fade_in()

	sleep_until (b_insertion_fade_in, 1);
	
	// this is a global script
	insertion_fade_to_gameplay();
end

// -------------------------------------------------------------------------------------------------
// INSERTION LOAD INDEX
// -------------------------------------------------------------------------------------------------
script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	//dprint( "::: f_insertion_index_load :::" );
	inspect( game_insertion_point_get() );
	
	if (s_insertion == s_intro_cinematic) then
		b_started = TRUE;
		ins_cine();
	end
	
	if ( not b_started ) then
		dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		inspect( s_insertion );
	end

end

script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "01_crater";

	if ( s_index == s_zoneset_crater  ) then
	 zs_return = "01_crater";
	end
	
	// return
	zs_return;
end