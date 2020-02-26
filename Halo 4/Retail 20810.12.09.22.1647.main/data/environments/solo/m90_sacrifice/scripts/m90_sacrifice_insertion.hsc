// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================


////////////////////////
//  INSERTION POINTS
////////////////////////
/*****************************************************************

	start    	// begin
	//TRENCHES
	ita
	itb
	itc
	itd
	ite
	iey				// eye
	
	iof  icr	iha iar// crash interior on foot beginning
	idd			//drop down
	iwa			// walls
	ipo itel 				// portals telport arcade
	iju				// jump begin
	ico				// coldant



*/




// Debug Options
global boolean b_debug 							= TRUE;
global boolean b_breakpoints				= FALSE;
global boolean b_md_print						=	TRUE;
global boolean b_debug_objectives 	= FALSE;
global boolean b_editor 						= editor_mode();
global boolean b_game_emulate				= FALSE;
global boolean b_cinematics 				= TRUE;
global boolean b_editor_cinematics 	= TRUE;
global boolean b_encounters				 	= TRUE;
global boolean b_dialogue 					= TRUE;
global boolean b_skip_intro					=	FALSE;
global boolean b_on_foot_cinematic_set = FALSE;

// Mission Started
global boolean b_mission_started 		=	FALSE;


// Zone Sets
global short s_zoneset_all							= 0;

// Insertion
global short s_start_idx							= 0;
global short s_trench_1_idx							= 1;
global short s_trench_2_idx							= 2;
global short s_eye_trans_idx						= 3;
global short s_eye_idx								= 4;
global short s_crash_idx 							= 5;
global short s_final_idx 							= 6;
global short s_arcade_idx 							= 7;
global short s_arcade_drop_idx 						= 8;
global short s_drop_teleports_idx 					= 9;
global short s_walls_teleport_room_idx 				= 10;
global short s_cin_m092_didact						= 11;
global short s_walls_coldant_idx 					= 12;	
global short s_teleport_rooms_idx 					= 13;
global short s_jump_idx 							= 14;
global short s_cin_m90_cavalry						= 15;
global short s_cin_m91_sacrifice					= 16;
global short s_cin_m93_kiss							= 17;
global short s_ending_game_idx 						= 18;
global short s_cin_m91b_sacrifice					= 19;
global short s_cin_m91_transition					= 20;
global short s_cin_m90_transition					= 21;





//cin_m090_cavalry
//cin_m091_sacrifice
//cin_m091b_sacrifice
//cin_m092_didact
//cin_m093_midnightkiss


/*
global short s_arcade_idx 							= 15;	//
global short s_arcade_drop_idx 					= 16;	// 
global short s_drop_teleports_idx 			= 17;	//
global short s_walls_teleport_room_idx 	= 18;	// 
global short s_teleport_rooms_idx 			= 23;	// 
*/
//global short s_bridges_idx 							= 16;	//



//global short s_jump_idx 								= 25;	//
//global short s_coldant_idx 							= 26;	// 

global short s_insertion_index		= -1;
global short s_zoneset_index			= -1;
//global short s_current_insertion_index 		= -1;
//global short s_insertion_index_start			= 1;
global short INSERTION_INDEX_CINEMATIC_OBS		= -1;
global short INSERTION_INDEX_CINE_CAV			= 0;
global short INSERTION_INDEX_CRASH				= 1;
global short INSERTION_INDEX_JUMP				= 2;

global short INSERTION_INDEX_START				= 3;
global short INSERTION_INDEX_TRENCH_A			= 3;
global short INSERTION_INDEX_TRENCH_B			= 4;
global short INSERTION_INDEX_TRENCH_C			= 5;
global short INSERTION_INDEX_TRENCH_D			= 6;
global short INSERTION_INDEX_TRENCH_E			= 7;
global short INSERTION_INDEX_EYE				= 8;
global short INSERTION_INDEX_DROPDOWN			= 9;
global short INSERTION_INDEX_TELEPORT			= 10;
global short INSERTION_INDEX_WALLS				= 11;
global short INSERTION_INDEX_COLDANT			= 12;
global short INSERTION_INDEX_END				= 13;
global short INSERTION_INDEX_ENGINE_ROOM		= 14;
global short INSERTION_INDEX_NOTLAB				= 15;
global short INSERTION_INDEX_END_CINEMATIC		= 16;
global short INSERTION_INDEX_SPACE_END			= 17;

global short INSERTION_INDEX_CIN_91				= 18;
global short INSERTION_INDEX_CIN_91B			= 19;

global short INSERTION_INDEX_CIN_92				= 20;
global short INSERTION_INDEX_CIN_93				= 21;
//global short s_insertion_index_onfoot_start 		= 1;


// =================================================================================================
// =================================================================================================
// *** INSERTIONS ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// STATION EXIT
// =================================================================================================


script static void icin()
	
	f_insertion_reset( INSERTION_INDEX_CINE_CAV );
end

// accessible by player (alpha)
script static void ins_opening_cin()
	if b_debug then
		print ("*** INSERTION POINT: OPENING CIN***");
	end
	//s_insertion_index = INSERTION_INDEX_CINE_CAV;
	// Play the intro cinematics here when we get one
	//f_insertion_zoneload( s_start_idx, INSERTION_INDEX_CINE_CAV, FALSE );
	//f_insertion_teleport( pts_insertion_start.p0, pts_insertion_start.p1, pts_insertion_start.p2, pts_insertion_start.p3 );
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			dprint( "CINEMATIC - cin_m090_cavalry: ENTER" );		
			b_OpeningIntroStart = TRUE;
		//	player_disable_movement (TRUE);
			//cinematic_show_letterbox (TRUE);			
			//nar_intro();
			//sleep_s(2);
			
			cinematic_enter( cin_m090_cavalry, TRUE );
			cinematic_suppress_bsp_object_creation( TRUE );
			f_insertion_zoneload( s_cin_m90_cavalry, INSERTION_INDEX_CINE_CAV, FALSE );
			cinematic_suppress_bsp_object_creation( FALSE );
			
			hud_play_global_animtion( screen_fade_out );
			hud_stop_global_animtion( screen_fade_out );
			
			f_start_mission( cin_m090_cavalry );
			cinematic_exit_no_fade( cin_m090_cavalry, TRUE ); 
		
			dprint( "CINEMATIC - cin_m090_cavalry: EXITED" );				
	end

	thread( ins_trench() );
	//thread( ins_crash_on_foot() );
	// music progression doesn't need to be set since this is the beginning of the mission
end




script static void itr()
	f_insertion_reset( INSERTION_INDEX_TRENCH_A );
end

script static void ita()
	f_insertion_reset( INSERTION_INDEX_TRENCH_A );
end




script static void ins_trench()
	if b_debug then
		print ("*** INSERTION POINT: TRENCH A ***");
	end
		player_disable_movement (TRUE);
		//s_insertion_index = INSERTION_INDEX_START;	
		f_insertion_zoneload( s_start_idx, INSERTION_INDEX_TRENCH_A, FALSE );
		f_insertion_playerwait();
		dprint("wot");
		f_space_particles_on( TRUE );
		dprint("tr a teleport");
		f_insertion_teleport( pts_insertion_start.p0, pts_insertion_start.p1, pts_insertion_start.p2, pts_insertion_start.p3 );
		wake ( f_flight_start_init );
		dprint("mission started");
		sleep(1);
		wake(f_trench_main);
		b_Init_Flight = TRUE;
		b_mission_started = TRUE;
		f_bomb_icon( FALSE );
		player_disable_movement (FALSE);

		// music - set progression index so that the region-based music triggering will proceed correctly
		music_start('Play_mus_m90');
		b_m90_music_progression = 20;	
end

// =================================================================================================
// Trench b
// =================================================================================================

script static void itb()
	//ins_trench_b();
	f_insertion_reset( INSERTION_INDEX_TRENCH_B );
end

script static void ins_trench_b()
	if b_debug then
		print ("*** INSERTION POINT: TRENCH B ***");
	end




		f_insertion_zoneload( s_trench_1_idx, INSERTION_INDEX_TRENCH_B, FALSE );
		f_insertion_playerwait();
		f_space_particles_on( TRUE );
		object_teleport_to_ai_point (player0(), ps_trench_b_ins.p0);
		
		object_create(sabre_trench_b);
		sleep(1);
		vehicle_load_magic (sabre_trench_b, "warthog_d", player0());
		
	 	b_mission_started = TRUE;
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );
		wake(f_trench_main);
		music_start('Play_mus_m90');
		b_m90_music_progression = 30;	
end


// =================================================================================================
// Trench C
// =================================================================================================

script static void itc()

	ins_trench_c();
end

script static void ins_trench_c()
	if b_debug then
		print ("*** INSERTION POINT: TRENCH C ***");
	end
	f_m90_reset_completetion_flags();
	s_zoneset_index = s_trench_1_idx;
	
	thread(f_master_cleanup_m90());	
	switch_zone_set ("trench_1");
	
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (s_trans_02) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_zoneset_index	, 1);
	dprint("create sabre");

	if b_debug then 
		print ("::: INSERTION: Finished loading (s_trans_02)");
	end
	
	sleep (1);

	b_mission_started = TRUE;
	object_create(sabre_trench_c);

	object_teleport_to_ai_point (player0(), ps_trench_c.p0);

	sleep(1);	
	vehicle_load_magic (sabre_trench_c, "warthog_d", player0());

	fade_in (0, 0, 0, 0);
	wake(f_trench_main);
	music_start('Play_mus_m90');
	b_m90_music_progression = 50;
end




// =================================================================================================
// Trench D
// =================================================================================================

script static void itd()
	ins_trench_d();
end

script static void ins_trench_d()
	if b_debug then
		print ("*** INSERTION POINT: TRENCH D ***");
	end
	f_m90_reset_completetion_flags();
	s_zoneset_index = s_trench_2_idx;



	
	thread(f_master_cleanup_m90());	
	switch_zone_set ("trench_2");
	
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (trench_d) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_zoneset_index	, 1);
	dprint("create sabre");

	if b_debug then 
		print ("::: INSERTION: Finished loading (trench_d)");
	end
	
	sleep (1);

	b_mission_started = TRUE;
	object_create(sabre_trench_d);

	object_teleport_to_ai_point (player0(), pts_insertion_other.p2);

	sleep(1);	
	vehicle_load_magic (sabre_trench_d, "warthog_d", player0());

	fade_in (0, 0, 0, 0);
	wake(f_trench_main);
	music_start('Play_mus_m90');
	b_m90_music_progression = 70;
end


// =================================================================================================
// Trench E
// =================================================================================================

script static void ite()
	ins_trench_e();
end

script static void ins_trench_e()
	if b_debug then
		print ("*** INSERTION POINT: TRENCH E***");
	end
	f_m90_reset_completetion_flags();
	s_zoneset_index = s_trench_2_idx;



	
	thread(f_master_cleanup_m90());	
	switch_zone_set ("trench_2");
	
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (trench_d) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_zoneset_index	, 1);
	dprint("create sabre");

	if b_debug then 
		print ("::: INSERTION: Finished loading (trench_d)");
	end
	
	sleep (1);

	b_mission_started = TRUE;
	object_create(sabre_trench_e);

	object_teleport_to_ai_point (player0(), pts_insertion_other.p0);

	sleep(1);	
	vehicle_load_magic (sabre_trench_e, "warthog_d", player0());

	fade_in (0, 0, 0, 0);
	wake(f_trench_main);
	music_start('Play_mus_m90');
	b_m90_music_progression = 80;
end
// =================================================================================================
// EYE
// =================================================================================================

script static void iey()
	ins_eye();
end

script static void ins_eye()
	if b_debug then
		print ("*** INSERTION POINT: EYE ***");
	end
		f_m90_reset_completetion_flags();
	s_zoneset_index = s_eye_trans_idx	;


	
	// Switch to correct zone set unless "set_all" is loaded 
	
	//create_player_ships (v_ship0, v_ship1, v_ship2, v_ship3);
	//load_player_ships (v_ship0, v_ship1, v_ship2, v_ship3);
	
	thread(f_master_cleanup_m90());	
	//switch_zone_set ("tren_e_eye");
	switch_zone_set ("eye_trans");
	sleep (1);
	
	if b_debug then
		print ("::: INSERTION: Waiting for (to_eye) to fully load...");
	end
		
	sleep_until (current_zone_set_fully_active() == s_zoneset_index	, 1);
	dprint("create sabre");

	if b_debug then 
		print ("::: INSERTION: Finished loading (tench_b_split)");
	end
	
	sleep (1);

	b_mission_started = TRUE;
	object_create(eye_sabre_1);
	object_create(eye_sabre_2);
	object_create(eye_sabre_3);
	object_create(eye_sabre_4);

	f_insertion_teleport( ins_eye_pts.p0, ins_eye_pts.p1, ins_eye_pts.p2, ins_eye_pts.p3 );
	sleep(1);	
	load_player_ships( eye_sabre_1, eye_sabre_3, eye_sabre_4, eye_sabre_4 );
	fade_in (0, 0, 0, 0);
	dprint("wake trench?");
	wake(f_trench_main);
	music_start('Play_mus_m90');
	b_m90_music_progression = 100;
end

script static void icin_91()
	f_insertion_reset( INSERTION_INDEX_CIN_91 );
end

script static void ins_cin_91()
	if b_debug then
		print ("*** INSERTION POINT: CIN 91***");
	end

	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			dprint( "CINEMATIC - cin_m091_sacrifice: ENTER" );		
			f_space_particles_on( false );
////			SetSkyObjectOverride("NONE");
			//f_insertion_teleport( ps_crash_start_ins.p0, ps_crash_start_ins.p1, ps_crash_start_ins.p2, ps_crash_start_ins.p3 );
			cinematic_enter( cin_m091_sacrifice, TRUE );
			cinematic_suppress_bsp_object_creation( TRUE );
			f_insertion_zoneload( s_cin_m91_sacrifice, INSERTION_INDEX_CIN_91, FALSE );
			cinematic_suppress_bsp_object_creation( FALSE );
			
			hud_play_global_animtion( screen_fade_out );
			hud_stop_global_animtion( screen_fade_out );
			
			f_start_mission( cin_m091_sacrifice );
			dprint("CINEMATIC - START EXIT");
			//cinematic_exit_no_fade( cin_m091_sacrifice, TRUE ); 
		
			dprint( "CINEMATIC - cin_m091_sacrifice: EXITED" );				
	end
	b_Eye_Complete = TRUE;
	thread( ins_cin_91b() );
	//thread( ins_crash_on_foot() );
end


script static void icin_91b()
	f_insertion_reset( INSERTION_INDEX_CIN_91b );
end

script static void ins_cin_91b()
	if b_debug then
		print ("*** INSERTION POINT: CIN 91b***");
	end

	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			dprint( "CINEMATIC - cin_m091b_sacrifice: ENTER" );		
			f_space_particles_on( false );
			//f_insertion_teleport( ps_crash_start_ins.p0, ps_crash_start_ins.p1, ps_crash_start_ins.p2, ps_crash_start_ins.p3 );
			cinematic_enter( cin_m091b_sacrifice, TRUE );
			cinematic_suppress_bsp_object_creation( TRUE );
			f_insertion_zoneload( s_cin_m91b_sacrifice, INSERTION_INDEX_CIN_91b, FALSE );
			cinematic_suppress_bsp_object_creation( FALSE );
			
			hud_play_global_animtion( screen_fade_out );
			hud_stop_global_animtion( screen_fade_out );
			
			f_start_mission( cin_m091b_sacrifice );
			f_insertion_zoneload( s_arcade_idx, INSERTION_INDEX_CRASH,  FALSE );
			f_insertion_teleport_invincible_forever( ps_crash_start_ins.p0, ps_crash_start_ins.p1, ps_crash_start_ins.p2, ps_crash_start_ins.p3 );
			cinematic_exit_no_fade( cin_m091b_sacrifice, TRUE ); 
		
			dprint( "CINEMATIC - cin_m091b_sacrifice: EXITED" );				
	end

	thread( ins_crash_on_foot() );

end



// =================================================================================================
//      00    N    N    FFFFF                
//     0  0   NN   N    F
//    0    0  N N  N    F
//    0    0  N  N N    FFF
//     0  0   N   NN    F
//      00    N    N    F
// =================================================================================================


// =================================================================================================
// DIDACT SHIP INTERIOR
// =================================================================================================


script static void icr()
		f_insertion_reset( INSERTION_INDEX_CRASH );

end

script static void iar()
		f_insertion_reset( INSERTION_INDEX_CRASH );
		
end

// RALLY POINT BRAVO
script static void ins_crash_on_foot()
	if b_debug then
		print ("*** INSERTION POINT: DIDCAT HALLS CRASH ***");
	end
		garbage_collect_now();
		sleep(1);
		b_Eye_Complete = TRUE;
		thread( f_eye_flight_cleanup() );
		sleep(1);
////		SetSkyObjectOverride("NONE");
		f_insertion_zoneload( s_arcade_idx, INSERTION_INDEX_CRASH,  TRUE );
		f_insertion_playerwait();
		f_space_particles_on( false );

		f_insertion_teleport( ps_crash_start_ins.p0, ps_crash_start_ins.p1, ps_crash_start_ins.p2, ps_crash_start_ins.p3 );
		f_insertion_playerprofile( default_single_respawn, FALSE );
		
	 	b_mission_started = TRUE;

	 	b_Eye_Complete = TRUE;
		
		b_TransitionCinEnd = TRUE; 	
	 	//if not b_on_foot_cinematic_set then
	 	f_m90_bomb_attach();
	 	f_m90_set_normal_g();	
	 	fade_in (0, 0, 0, 0);
	 	//end
		f_bomb_icon( TRUE );
		hud_play_global_animtion (screen_fade_in);
	
		hud_stop_global_animtion (screen_fade_in);
		
		music_start('Play_mus_m90');
		b_m90_music_progression = 110;
end


// =================================================================================================
// drop down
// =================================================================================================


script static void idd()
		f_insertion_reset( INSERTION_INDEX_DROPDOWN );
end

script static void ins_drop_down()
	if b_debug then
		print ("*** INSERTION POINT: Drop Down ***");
	end
		
		f_insertion_zoneload( s_arcade_drop_idx, INSERTION_INDEX_DROPDOWN, FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );
	
		f_insertion_teleport( ps_drop_down_ins.p0, ps_drop_down_ins.p1, ps_drop_down_ins.p2, ps_drop_down_ins.p3 );
		f_insertion_playerprofile( default_forerunner, FALSE );
	 	b_mission_started = TRUE;
		f_m90_set_normal_g();
	 	object_create( dm_dropdown_phantom );
	 	wake ( f_dropdown_finish_wait );
	 	f_m90_bomb_attach();
	 	f_bomb_icon( TRUE );
	 	b_arcade_complete = TRUE;
	 	fade_in (0, 0, 0, 0);

		music_start('Play_mus_m90');
		b_m90_music_progression = 120;
end



// =================================================================================================
// ENGINE ROOM
// =================================================================================================
script static void ier()
		f_insertion_reset( INSERTION_INDEX_ENGINE_ROOM );
end

script static void ins_engineroom()
	if b_debug then
		print ("*** INSERTION POINT: ENGINE ROOM ***");
	end


		f_insertion_zoneload( s_teleport_rooms_idx,INSERTION_INDEX_ENGINE_ROOM,  FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );

		f_insertion_teleport( ps_portals_ins.pER_1, ps_portals_ins.pER_2, ps_portals_ins.pER_3, ps_portals_ins.pER_4 );
		f_insertion_playerprofile( default_forerunner, FALSE );
	 	b_mission_started = TRUE;
		f_m90_set_normal_g();	
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		object_create_folder( dms_teleport );

		object_create_folder( crs_teleport );
		
		music_start('Play_mus_m90');
		b_m90_music_progression = 130;
end

// =================================================================================================
// NOTLAB
// =================================================================================================
script static void inl()
		f_insertion_reset( INSERTION_INDEX_NOTLAB );
end

script static void ins_notlab()
	if b_debug then
		print ("*** INSERTION POINT: NOTLAB ***");
	end


		f_insertion_zoneload( s_teleport_rooms_idx,INSERTION_INDEX_NOTLAB,  FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );

		f_insertion_teleport( ps_portals_ins.pNL_1, ps_portals_ins.pNL_2, ps_portals_ins.pNL_3, ps_portals_ins.pNL_4 );
		f_insertion_playerprofile( default_forerunner, FALSE );
	 	b_mission_started = TRUE;
		f_m90_set_normal_g();	
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		dprint("==== FOR ART ONLY . NOT GAMEPLAY ===");
		object_create_folder( dms_teleport );

		object_create_folder( crs_teleport );
		music_start('Play_mus_m90');
		b_m90_music_progression = 140;
end

// =================================================================================================
// WALLS
// =================================================================================================
script static void iwa()
		f_insertion_reset( INSERTION_INDEX_WALLS );
end

script static void ins_walls()
	if b_debug then
		print ("*** INSERTION POINT: walls ***");
	end

		b_teleport_complete = TRUE;

		f_insertion_zoneload( s_walls_coldant_idx, INSERTION_INDEX_WALLS,  FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );
	
		f_insertion_teleport( ps_walls_ins.p0, ps_walls_ins.p1, ps_walls_ins.p2, ps_walls_ins.p3 );
		f_insertion_playerprofile( default_forerunner, FALSE );
	 	b_mission_started = TRUE;
		f_bomb_icon( TRUE );
		sleep(1);
		dprint("create dms walls");
		object_create_folder( dms_walls );
		object_create_folder( crs_walls );
		f_m90_set_normal_g();
		sleep(1);
		f_m90_bomb_attach();
		b_teleport_complete = TRUE;
	 	fade_in (0, 0, 0, 0);
		
		music_start('Play_mus_m90');
		b_m90_music_progression = 140;

end


// =================================================================================================
// Portals over madison county
// =================================================================================================
script static void ipo()
		f_insertion_reset( INSERTION_INDEX_TELEPORT );
end

script static void itp()
		f_insertion_reset( INSERTION_INDEX_TELEPORT );
end

script static void ins_portals()
	if b_debug then
		print ("*** INSERTION POINT: PORTALS ***");
	end

		b_arcade_complete = TRUE;
		f_insertion_zoneload( s_drop_teleports_idx,INSERTION_INDEX_TELEPORT,  FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );

		f_insertion_teleport( ps_portals_ins.p0, ps_portals_ins.p1, ps_portals_ins.p2, ps_portals_ins.p3 );
		f_insertion_playerprofile( default_forerunner, FALSE );
	 	b_mission_started = TRUE;
		f_bomb_icon( TRUE );
		f_m90_set_normal_g();	
		b_m90_b_60_over = TRUE;
		wake( f_teleport_intro_crates );
		f_m90_bomb_attach();
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );

		
end



// =================================================================================================
// JUMP
// =================================================================================================
// RALLY POINT CHARLIE
script static void iju()
	//ins_jump();
	f_insertion_reset( INSERTION_INDEX_JUMP );
end

script static void ins_jump()
	if b_debug then
		print ("*** INSERTION POINT: JUMP ***");
	end
////		SetSkyObjectOverride("m90_sky");
		b_walls_complete = TRUE;
		f_insertion_zoneload( s_jump_idx, INSERTION_INDEX_JUMP, FALSE );
		f_insertion_playerwait();
		f_fx_activate_beams();
		f_space_particles_on( false );
	
		f_insertion_teleport( ps_the_jump_ins.p0, ps_the_jump_ins.p1, ps_the_jump_ins.p2, ps_the_jump_ins.p3 );
		f_insertion_playerprofile( forerunner_power, FALSE );
	 	b_mission_started = TRUE;
		f_bomb_icon( TRUE );
		f_m90_set_normal_g();	
		f_m90_bomb_attach();
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );

		wake(f_jump_init);
		music_start('Play_mus_m90');
		b_m90_music_progression = 160;
end


// =================================================================================================
// COLDANT
// =================================================================================================
script static void ico()
	f_insertion_reset( INSERTION_INDEX_COLDANT );
end

script static void ins_coldant()
	if b_debug then
		print ("*** INSERTION POINT: COLDANT ***");
	end
////		SetSkyObjectOverride("m90_sky");
		b_walls_complete = TRUE;

		f_insertion_zoneload( s_final_idx, INSERTION_INDEX_COLDANT, FALSE );
		f_insertion_playerwait();
		f_fx_activate_beams();
		f_space_particles_on( false );
	
		f_insertion_teleport( ps_coldant_ins.p0, ps_coldant_ins.p1, ps_coldant_ins.p2, ps_coldant_ins.p3 );
		f_insertion_playerprofile( forerunner_power, FALSE );
	 	b_mission_started = TRUE;
		f_bomb_icon( TRUE );
	 	dprint("---- fade in ----");
		f_m90_set_normal_g();
		f_m90_bomb_attach();
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );
		f_jump_set_doors();
		music_start('Play_mus_m90');
		b_m90_music_progression = 170;
end


script static void icin_92()
	f_insertion_reset( INSERTION_INDEX_CIN_92 );
end

script static void ins_cin_92()
	if b_debug then
		print ("*** INSERTION POINT: CIN 92***");
	end

	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
		dprint( "CINEMATIC - cin_m092_didact: ENTER" );
		
		thread(f_fx_shield_cleanup()); // cleans the shield effects out of the bsp
			
		cinematic_enter( cin_m092_didact, TRUE );
		f_m90_bomb_detach();
		pup_stop_show( l_didact_loop_pup );	
		//cinematic_suppress_bsp_object_creation( TRUE );
		//f_insertion_zoneload( s_cin_m092_didact, INSERTION_INDEX_CIN_92, FALSE );
		//cinematic_suppress_bsp_object_creation( FALSE );
		
		hud_play_global_animtion( screen_fade_out );
		hud_stop_global_animtion( screen_fade_out );
		
		f_start_mission( cin_m092_didact );
		cinematic_exit_no_fade( cin_m092_didact, TRUE ); 
	
		dprint( "CINEMATIC - cin_m092_didact: EXITED" );				
	end

	//f_insertion_zoneload( s_final_idx, INSERTION_INDEX_COLDANT, FALSE );
	//f_insertion_playerwait();
	f_insertion_teleport( ps_ins_cinematic_end.p4, ps_ins_cinematic_end.p5, ps_ins_cinematic_end.p6, ps_ins_cinematic_end.p7 );
	wake( f_comp_start_ics );

end



script static void icin_93()
	f_insertion_reset( INSERTION_INDEX_CIN_93 );
end

script static void ins_cin_93()
	if b_debug then
		print ("*** INSERTION POINT: CIN 93***");
	end
		
	if (b_cinematics and (not b_editor) or (b_editor_cinematics)) then
			dprint( "CINEMATIC - cin_m093_kiss: ENTER" );		

			thread( f_cold_maelstrom_kill() );
			cinematic_enter( cin_m093_mk, TRUE );
			cinematic_suppress_bsp_object_creation( TRUE );
			
			f_insertion_zoneload( s_cin_m93_kiss, INSERTION_INDEX_CIN_93, FALSE );
			f_insertion_teleport_invincible_forever( ps_space_ending.p4, ps_space_ending.p5, ps_space_ending.p6, ps_space_ending.p7 );
			cinematic_suppress_bsp_object_creation( FALSE );
			
			hud_play_global_animtion( screen_fade_out );
			hud_stop_global_animtion( screen_fade_out );
			
			f_end_cinematic( cin_m093_mk );
			//cinematic_exit_no_fade( cin_m093_mk, TRUE ); 
		
			dprint( "CINEMATIC - cin_m093_kiss: EXITED" );				
	end

	//thread( ins_space_end() );
	//wake( f_m90_ending );
	game_won();
end





// =================================================================================================
// COLDANT
// =================================================================================================
script static void icin_end()
	f_insertion_reset( INSERTION_INDEX_END_CINEMATIC );
end

script static void ins_end_cinematic()
	if b_debug then
		print ("*** INSERTION POINT: CINEMATIC END ***");
	end

		
		f_insertion_zoneload( s_final_idx, INSERTION_INDEX_COLDANT, FALSE );
		f_insertion_playerwait();
		f_space_particles_on( false );
		thread(f_coldant_create_bridge() );
		f_insertion_teleport( ps_ins_cinematic_end.p0, ps_ins_cinematic_end.p1, ps_ins_cinematic_end.p2, ps_ins_cinematic_end.p3 );
		f_insertion_playerprofile( forerunner_power, FALSE );
	 	b_mission_started = TRUE;

	 	dprint("---- fade in ----");
	 	f_bomb_icon( TRUE );
		f_m90_set_normal_g();	
		f_m90_bomb_attach();
		thread( f_cold_maelstrom_all() );
		l_pup_composer = pup_play_show(pup_composer);
		g_composer_state = 5;
		//thread( f_cold_shield_kill() );
	 	fade_in (0, 0, 0, 0);
		sleep( 1 );
		f_jump_cleanup_eye_ap();
		wake(f_comp_enter_core);

end





// =================================================================================================
// SPACE END
// =================================================================================================
script static void iend()
	f_insertion_reset( INSERTION_INDEX_SPACE_END );
	
end

script static void ins_space_end()
	if b_debug then
		print ("*** INSERTION POINT: SPACE END ***");
	end
		fade_out(1,1,1,0 );
		//sleep(45);
		thread( f_cold_cleanup() );
		physics_set_gravity( 0.0 );
		
		//object_teleport_to_ai_point( player1(), ps_space_ending.p0 );
		f_insertion_zoneload( s_ending_game_idx, INSERTION_INDEX_SPACE_END, FALSE );
		volume_teleport_players_not_inside ( tv_sacrifice_space_vol, cf_floater_end );
		//f_insertion_teleport( ps_space_ending.p0, ps_space_ending.p1, ps_space_ending.p2, ps_space_ending.p3 );
		//f_insertion_playerwait();
		f_space_particles_on( false );
		//f_m90_set_normal_g();	
		
		
		//f_insertion_playerprofile( forerunner_power, FALSE );
	 	b_mission_started = TRUE;

		f_bomb_icon( FALSE );
		sleep( 1 );
		wake(f_space_end_init);
end
// =================================================================================================
// =================================================================================================
// *** CLEANUP ***
// =================================================================================================
// =================================================================================================

// =================================================================================================
// STATION
// =================================================================================================

script static void f_trench_cleanup()
	sleep_forever (f_trench_cleanup);
end

// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================

// =================================================================================================
// Loadouts
// =================================================================================================






script static void f_insertion_teleport( point_reference pr_p0, point_reference pr_p1, point_reference pr_p2, point_reference pr_p3 )
	
	physics_set_gravity( 0.0 );
	object_cannot_take_damage( players() );
	if ( player_valid( player0() ) ) then
		dprint("player 1 valid");
		object_teleport_to_ai_point( player0(), pr_p0 );
	end

	if ( player_valid( player1() ) ) then
	dprint("player 2 valid");
		object_teleport_to_ai_point( player1(), pr_p1 );
	end
	if ( player_valid( player2() ) ) then
	dprint("player 3 valid");
		object_teleport_to_ai_point( player2(), pr_p2 );
	end
	if ( player_valid( player3() ) ) then
	dprint("player 4 valid");
		object_teleport_to_ai_point( player3(), pr_p3 );
	end
	if not ( player_valid( player0() )) and not ( player_valid( player1() )) and not ( player_valid( player2() )) and not ( player_valid( player3() ) ) then
		dprint("NO PLAYER IS VALID, ABANDON SHIP");
	end
	sleep( 1 );
	physics_set_gravity( 1.0 );
	object_can_take_damage( players() );
end

script static void f_insertion_teleport_invincible_forever( point_reference pr_p0, point_reference pr_p1, point_reference pr_p2, point_reference pr_p3 )
	
	physics_set_gravity( 0.0 );
	object_cannot_take_damage( players() );
	if ( player_valid( player0() ) ) then
		dprint("player 1 valid");
		object_teleport_to_ai_point( player0(), pr_p0 );
	end

	if ( player_valid( player1() ) ) then
	dprint("player 2 valid");
		object_teleport_to_ai_point( player1(), pr_p1 );
	end
	if ( player_valid( player2() ) ) then
	dprint("player 3 valid");
		object_teleport_to_ai_point( player2(), pr_p2 );
	end
	if ( player_valid( player3() ) ) then
	dprint("player 4 valid");
		object_teleport_to_ai_point( player3(), pr_p3 );
	end
	if not ( player_valid( player0() )) and not ( player_valid( player1() )) and not ( player_valid( player2() )) and not ( player_valid( player3() ) ) then
		dprint("NO PLAYER IS VALID, ABANDON SHIP");
	end
	sleep( 1 );

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




script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "start";
	if ( s_index == s_cin_m90_cavalry ) then
		zs_return = "cin_m90_cavalry";
	end
	if ( s_index == s_start_idx ) then
	 zs_return = "start";
	end
	if ( s_index == s_trench_1_idx ) then
	 zs_return = "trench_1";
	end
	if ( s_index == s_trench_2_idx ) then
	 zs_return = "trench_2";
	end
	if ( s_index == s_eye_trans_idx ) then
	 zs_return = "eye_trans";
	end
	if ( s_index == s_cin_m91_sacrifice ) then
	 zs_return = "cin_m91_sacrifice";
	end
	if ( s_index == s_cin_m91b_sacrifice ) then
	 zs_return = "cin_m91b_sacrifice";
	end
	if ( s_index == s_eye_idx ) then
	 zs_return = "eye";
	end
	if ( s_index == s_jump_idx ) then
	 zs_return = "jump";
	end
	if ( s_index == s_final_idx ) then
	 zs_return = "final";
	end
	if ( s_index == s_arcade_idx ) then
	 zs_return = "arcade";
	end
	if ( s_index == s_arcade_drop_idx ) then
	 zs_return = "arcade_drop";
	end
	if ( s_index == s_drop_teleports_idx ) then
	 zs_return = "drop_teleports";
	end
	if ( s_index == s_walls_teleport_room_idx ) then
	 zs_return = "walls_teleport_room";
	end
	if ( s_index == s_teleport_rooms_idx ) then
	 zs_return = "teleport_rooms";
	end	
	if ( s_index == s_walls_coldant_idx ) then
	 zs_return = "walls_coldant";
	end		
	if ( s_index == s_cin_m91_sacrifice ) then
	 zs_return = "cin_m91_sacrifice";
	end
	if ( s_index == s_cin_m092_didact ) then
	 zs_return = "cin_m092_didact";
	end
	if ( s_index == s_cin_m93_kiss ) then
	 zs_return = "cin_m93_kiss";
	end	
	if ( s_index == s_ending_game_idx ) then
	 zs_return = "ending_game";
	end
	// return
	zs_return;
end  


script static void f_insertion_zoneload( short s_index, short s_insertion_index_def, boolean b_check_loaded )

	// set the insertion index variable
	s_insertion_index = s_insertion_index_def;
	//s_insertion_index = s_index;  /// bad for me  s_insertion_index != s_index
	// Switch to correct zone set unless "set_all" is loaded 
	dprint( "::: INSERTION: LOAD ZONE" );
	if ( (not b_check_loaded) or (current_zone_set_fully_active() != s_insertion_index) ) then
		
		switch_zone_set( f_zoneset_get(s_index) );
		sleep( 1 );

		dprint( "::: INSERTION: Waiting for zone set to fully load..." );
		sleep_until( current_zone_set_fully_active() == s_index, 1 );
		dprint( "::: INSERTION: Finished loading zone set" );
		sleep( 1 );
	end
	
end

script static void f_insertion_playerwait()

	if ( editor_mode() ) then
		dprint( "::: INSERTION: PLAYER WAIT" );
		sleep_until( player_count() > 0, 1 );
	end
	
end

script static void f_insertion_reset( short s_index )
	f_m90_reset_completetion_flags();
	sleep(1);
	game_insertion_point_set( s_index );
	if ( b_game_emulate or (not editor_mode()) ) then
		dprint("map reset");
		map_reset();
	else
		dprint("insertion index load");
		f_insertion_index_load( s_index );
	end
	
end

script static void f_insertion_playerprofile( starting_profile sp_profile, boolean b_wait_equipment )

	//dprint( "::: INSERTION: STARTING PROFILE" );
	if ( player_valid( player0() ) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P0" );
		unit_add_equipment( player0(), sp_profile, TRUE, FALSE );
	end
	if ( player_valid( player1() ) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P1" );
		unit_add_equipment( player1(), sp_profile, TRUE, FALSE );
	end
	if ( player_valid( player2() ) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P2" );
		unit_add_equipment( player2(), sp_profile, TRUE, FALSE );
	end
	if ( player_valid( player3() ) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P3" );
		unit_add_equipment( player3(), sp_profile, TRUE, FALSE );
	end
	
	if ( b_wait_equipment ) then
		if ( player_valid( player0() ) ) then
			sleep_until( unit_has_any_equipment(player0()), 1 );
		end
		if ( player_valid( player2() ) ) then
			sleep_until( unit_has_any_equipment(player1()), 1 );
		end
		if ( player_valid( player3() ) ) then
			sleep_until( unit_has_any_equipment(player2()), 1 );
		end
		if ( player_valid( player3() ) ) then
			sleep_until( unit_has_any_equipment(player3()), 1 );
		end
	end
	
	sleep( 1 );
	
end



script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	dprint( "::: f_insertion_index_load :::" );
	inspect( game_insertion_point_get() );
	
	if (s_insertion == INSERTION_INDEX_CINE_CAV or s_insertion == INSERTION_INDEX_CINEMATIC_OBS) then
		b_started = TRUE;
		ins_opening_cin();
	end
	if (s_insertion == INSERTION_INDEX_START) then
		b_started = TRUE;
		ins_trench();
	end
	if (s_insertion == INSERTION_INDEX_TRENCH_A) then
		b_started = TRUE;
		ins_trench();
	end
	if (s_insertion == INSERTION_INDEX_TRENCH_B) then
		b_started = TRUE;
		ins_trench_b();
	end
	if (s_insertion == INSERTION_INDEX_TRENCH_C) then
		b_started = TRUE;
		ins_trench_c();
	end
	if (s_insertion == INSERTION_INDEX_TRENCH_D) then
		b_started = TRUE;
		ins_trench_d();
	end
	if (s_insertion == INSERTION_INDEX_TRENCH_E) then
		b_started = TRUE;
		ins_trench_e();
	end
	if (s_insertion == INSERTION_INDEX_EYE) then
		b_started = TRUE;
		ins_eye();
	end
	
	if (s_insertion == INSERTION_INDEX_CIN_91) then
		b_started = TRUE;
		ins_cin_91();
	end

	if (s_insertion == INSERTION_INDEX_CIN_91b) then
		b_started = TRUE;
		ins_cin_91b();
	end
		
	if (s_insertion == INSERTION_INDEX_CRASH) then
		b_started = TRUE;
		ins_crash_on_foot();
	end
	if (s_insertion == INSERTION_INDEX_DROPDOWN) then
		b_started = TRUE;
		ins_drop_down();
	end
	if (s_insertion == INSERTION_INDEX_TELEPORT) then
		b_started = TRUE;
		ins_portals();
	end
	if (s_insertion == INSERTION_INDEX_NOTLAB) then
		b_started = TRUE;
		ins_notlab();
	end	
	
	if (s_insertion == INSERTION_INDEX_ENGINE_ROOM) then
		b_started = TRUE;
		ins_engineroom();
	end		

	if (s_insertion == INSERTION_INDEX_WALLS) then
		b_started = TRUE;
		ins_walls();
	end
	if (s_insertion == INSERTION_INDEX_JUMP) then
		b_started = TRUE;
		ins_jump();
	end

	if (s_insertion == INSERTION_INDEX_COLDANT) then
		b_started = TRUE;
		ins_coldant();
	end

	if (s_insertion == INSERTION_INDEX_CIN_92) then
		b_started = TRUE;
		ins_cin_92();
	end
	
	
	if (s_insertion == INSERTION_INDEX_CIN_93) then
		b_started = TRUE;
		ins_cin_93();
	end

	
	if (s_insertion == INSERTION_INDEX_END_CINEMATIC) then
		b_started = TRUE;
		ins_end_cinematic();
	end

	if (s_insertion == INSERTION_INDEX_SPACE_END) then
		b_started = TRUE;
		dprint("NO LONGER AVAILABLE");
		//ins_space_end();
	end

	/*
	if (s_insertion == INSERTION_INDEX_END) then
		b_started = TRUE;
		ins_space();
	end
*/
	
	if ( not b_started ) then
		dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		inspect( s_insertion );
	end

end

script static void f_m90_reset_completetion_flags()
	dprint("reseting completion flags");
	b_Eye_Complete = FALSE;
	b_trench_a_complete = FALSE;
	b_trench_b_complete = FALSE;
	b_trench_d_complete = FALSE;
	b_trench_e_complete = FALSE;
	b_walls_complete = FALSE;
	b_arcade_complete = FALSE;
	b_teleport_complete = FALSE;
	b_coldant_complete = FALSE;
	b_Init_Flight = FALSE;
	
	
	thread( f_flight_stop_direction_check() );
end