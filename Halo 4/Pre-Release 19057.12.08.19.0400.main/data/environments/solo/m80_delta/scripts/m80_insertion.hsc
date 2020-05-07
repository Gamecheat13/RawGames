//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					m80_delta
//	Insertion Points:	cinematic - 80			(or i80)
//	Insertion Points:	lich ride						(or ilr)
//	Insertion Points:	cinematic - 81			(or i81)
//  Insertion Points:	crash								(or icr)
//  Insertion Points:	horseshoe						(or iho)
//  Insertion Points:	to_lab							(or itl)
//  Insertion Points:	lift								(or ili)
//	Insertion Points:	cinematic - 82			(or i82)
//  Insertion Points:	atrium 							(or iat)
//  Insertion Points:	to airlock one			(or iah)
//  Insertion Points:	airlock one 				(or ia1)
//  Insertion Points:	to airlock one			(or ita2)
//  Insertion Points:	airlock two 				(or ia2)
//	Insertion Points:	lookout							(or ilo)
//	Insertion Points:	guns hallway				(or igh)
//	Insertion Points:	atrium return 			(or iar)
//	Insertion Points:	atrium destruction 	(or iad)
//	Insertion Points:	cinematic - 83			(or i83)
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GLOBALS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// Debug Options
global boolean b_debug 							= FALSE;
//global boolean b_editor 						= editor_mode();
global boolean b_game_emulate				= FALSE;
global boolean b_cinematics 				= TRUE;
global boolean b_editor_cinematics 	= FALSE;
//global boolean s_insertion_index		= 0;
global boolean b_insertion_reset		= TRUE;
global boolean b_mission_started 		=	FALSE;
//global boolean b_insertion_fade_in  = FALSE;
//global boolean b_breakpoints				= FALSE;
//global boolean b_md_//dprint					=	TRUE;
//global boolean b_debug_objectives 	= FALSE;
//global boolean b_encounters				 	= TRUE;
//global boolean b_dialogue 					= TRUE;
//global boolean b_skip_intro					=	FALSE;
//global boolean b_reset_weapons				=	FALSE;

// Insertion Indexes
global short S_INSERTION_INDEX_CIN_80 	  									= 0;
// global short S_INSERTION_INDEX_LICH 												= 1;
global short S_INSERTION_INDEX_CIN_81 	  									= 2;
global short S_INSERTION_INDEX_CRASH 												= 3;
global short S_INSERTION_INDEX_HORSESHOE			 							= 4;
global short S_INSERTION_INDEX_TO_LAB 											= 5;
global short S_INSERTION_INDEX_LAB 						  						= 6;
global short S_INSERTION_INDEX_CIN_82 	  									= 7;
global short S_INSERTION_INDEX_ATRIUM 	  									= 8;
global short S_INSERTION_INDEX_TO_AIRLOCK_ONE 	 						= 9;
global short S_INSERTION_INDEX_AIRLOCK_ONE 	  							= 10;
global short S_INSERTION_INDEX_AIRLOCK_TWO 	  							= 11;
global short S_INSERTION_INDEX_LOOKOUT 	  									= 12;
global short S_INSERTION_INDEX_GUNS_HALLWAY 								= 13;
global short S_INSERTION_INDEX_ATRIUM_RETURN								= 14;
global short S_INSERTION_INDEX_ATRIUM_DESTROYED							= 15;
global short S_INSERTION_INDEX_CIN_83 	  									= 16;
global short S_INSERTION_INDEX_TO_AIRLOCK_TWO								= 17;
/*
// lichride test indexes
global short S_INSERTION_INDEX_LICHRIDE_TEST_DIVE 	  			= 101;
global short S_INSERTION_INDEX_LICHRIDE_TEST_IMPACT 	  		= 102;
global short S_INSERTION_INDEX_LICHRIDE_TEST_TURRETS01 	  	= 103;
global short S_INSERTION_INDEX_LICHRIDE_TEST_EVASION 	  		= 104;
global short S_INSERTION_INDEX_LICHRIDE_TEST_AUTOTURRETS 	  = 105;
global short S_INSERTION_INDEX_LICHRIDE_TEST_DIDACTSHIP 	  = 106;
global short S_INSERTION_INDEX_LICHRIDE_TEST_ASTEROIDS 	  	= 107;
global short S_INSERTION_INDEX_LICHRIDE_TEST_BOARDING01 	  = 108;
global short S_INSERTION_INDEX_LICHRIDE_TEST_TURRETS02 	  	= 109;
global short S_INSERTION_INDEX_LICHRIDE_TEST_NEEDLE 	  		= 110;
global short S_INSERTION_INDEX_LICHRIDE_TEST_BOARDING02 	  = 111;
global short S_INSERTION_INDEX_LICHRIDE_TEST_FLEET 	  			= 112;
global short S_INSERTION_INDEX_LICHRIDE_TEST_FINALTURN 	  	= 113;
global short S_INSERTION_INDEX_LICHRIDE_TEST_CRASH 	  			= 114;
*/

// Zone_set Indexes
global short S_ZONESET_CIN_M80 = 								0;
global short S_ZONESET_CRASH = 									1;
global short S_ZONESET_CRASH_TRANSITION =				2;
global short S_ZONESET_TO_HORSESHOE = 					3;
global short S_ZONESET_HORSESHOE = 							4;
global short S_ZONESET_TO_LAB = 								5;
global short S_ZONESET_LAB = 										6;
global short S_ZONESET_LAB_EXIT = 							7;
global short S_ZONESET_CIN_M82 = 								8;
global short S_ZONESET_ATRIUM = 								9;
global short S_ZONESET_ATRIUM_HUB = 						10;
global short S_ZONESET_TO_AIRLOCK_ONE = 				11;
global short S_ZONESET_TO_AIRLOCK_ONE_B = 			12;
global short S_ZONESET_AIRLOCK_ONE = 						13;
global short S_ZONESET_TO_AIRLOCK_TWO = 				14;
global short S_ZONESET_AIRLOCK_TWO = 						15;
global short S_ZONESET_TO_LOOKOUT = 						16;
global short S_ZONESET_LOOKOUT = 								17;
global short S_ZONESET_LOOKOUT_EXIT = 					18;
global short S_ZONESET_LOOKOUT_HALLWAYS_A	= 		19;
global short S_ZONESET_LOOKOUT_HALLWAYS_B	= 		20;
global short S_ZONESET_ATRIUM_RETURNING = 			21;
global short S_ZONESET_ATRIUM_LOOKOUT = 				22;
global short S_ZONESET_ATRIUM_DAMAGED = 				23;
global short S_ZONESET_MECHROOM_RETURN = 				24;
global short S_ZONESET_COMPOSER_REMOVAL_ENTER = 25;
global short S_ZONESET_COMPOSER_REMOVAL = 			26;
global short S_ZONESET_COMPOSER_REMOVAL_EXIT = 	27;
global short S_ZONESET_CIN_M83 = 								28;


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** INSERTIONS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// -------------------------------------------------------------------------------------------------
// START
// -------------------------------------------------------------------------------------------------
script static void start()
	//dprint( "::: start :::" );

	f_insertion_index_load( game_insertion_point_get() );

end

// ==========================================================================================================================================================
// CINEMATIC - 80
// ==========================================================================================================================================================


script static void i80()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_CIN_80 );
	
end

script static void ins_cine_80()

	f_insertion_begin( "CINEMATIC - 080_opening" );

	cinematic_enter( cin_m080_opening, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	f_insertion_zoneload( S_ZONESET_CIN_M80, FALSE );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion( screen_fade_out );
	hud_stop_global_animtion( screen_fade_out );
	
	f_start_mission( cin_m080_opening );
	//cinematic_exit_no_fade( cin_m080_opening, TRUE ); 

	//dprint( "CINEMATIC - 080_opening: EXITED" );

	// start the next insertion point
	//ins_lich();
	ins_cine_81();

end

// ==========================================================================================================================================================
// CINEMATIC - 81
// ==========================================================================================================================================================


script static void i81()

	f_insertion_reset( S_INSERTION_INDEX_CIN_81 );
	//b_reset_weapons = TRUE;
		
end

script static void ins_cine_81()

	f_insertion_begin( "CINEMATIC - 081_crash" );

	cinematic_enter_no_fade( cin_m081_crash, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	f_insertion_zoneload( S_ZONESET_CIN_M80, TRUE );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion( screen_fade_out );
	hud_stop_global_animtion( screen_fade_out );
	
	f_start_mission( cin_m081_crash );
	
	f_insertion_zoneload( S_ZONESET_CRASH, TRUE );
	f_insertion_teleport( ps_insertion_crash.p0, ps_insertion_crash.p1, ps_insertion_crash.p2, ps_insertion_crash.p3 );
	cinematic_exit_no_fade( cin_m081_crash, TRUE ); 

	//dprint( "CINEMATIC - 081_crash: EXITED" );

	// start the next insertion point
	ins_crash();

end


// ==========================================================================================================================================================
// CRASH
// ==========================================================================================================================================================


script static void icr()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_CRASH );

end

script static void ins_crash()

	// disable input
	player_enable_input( FALSE );

	f_insertion_begin( "CRASH" );
		f_insertion_zoneload( S_ZONESET_CRASH, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_crash.p0, ps_insertion_crash.p1, ps_insertion_crash.p2, ps_insertion_crash.p3 );
		f_insertion_playerprofile( profile_ar_magnum_shield_2_0, FALSE );
	f_insertion_end();

	b_m80_music_progression = 20;
	
	// start the mission
	f_crash_puppeteer_start_action();

	// enable input
	player_enable_input( TRUE );

end


// ==========================================================================================================================================================
// HORSESHOE
// ==========================================================================================================================================================


script static void iho()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_HORSESHOE );

end

script static void ins_horseshoe()

	f_insertion_begin( "TO_HORSESHOE" );
		f_insertion_zoneload( S_ZONESET_TO_HORSESHOE, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_horseshoe.p0, ps_insertion_horseshoe.p1, ps_insertion_horseshoe.p2, ps_insertion_horseshoe.p3 );
		f_insertion_playerprofile( profile_ar_magnum_shield_2_0, FALSE );
	f_insertion_end();

	b_m80_music_progression = 30;
	
	// setup
	f_objective_set( DEF_R_OBJECTIVE_CRASH_EXIT(), TRUE, TRUE, FALSE, FALSE );
	
end


// ==========================================================================================================================================================
// TO_LAB
// ==========================================================================================================================================================


script static void itl()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_TO_LAB );

end

script static void ins_to_lab()

	f_insertion_begin( "TO LAB" );
		f_insertion_zoneload( S_ZONESET_TO_LAB, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_to_lab.p0, ps_insertion_to_lab.p1, ps_insertion_to_lab.p2, ps_insertion_to_lab.p3 );
		f_insertion_playerprofile( profile_ar_magnum_shield_2_0, FALSE );
	f_insertion_end();

	b_m80_music_progression = 50;
end


// ==========================================================================================================================================================
// LIFT
// ==========================================================================================================================================================


script static void ilb()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_LAB );

end

script static void ins_lab()

	f_insertion_begin( "LAB" );
		f_insertion_zoneload( S_ZONESET_LAB, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lab.p0, ps_insertion_lab.p1, ps_insertion_lab.p2, ps_insertion_lab.p3 );
		f_insertion_playerprofile( profile_ar_magnum_shield_2_0, FALSE );
	f_insertion_end();

	b_m80_music_progression = 60;
end


// ==========================================================================================================================================================
// CINEMATIC - 82
// ==========================================================================================================================================================
// RALLY POINT BRAVO

script static void i82()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_CIN_82 );
	
end

script static void ins_cine_82()

	f_insertion_begin( "CINEMATIC - 082_docslab" );

	// unlock insertion point
	game_insertion_point_unlock( S_INSERTION_INDEX_CIN_82 );

	if( editor_mode() == FALSE or b_editor_cinematics ) then

		cinematic_enter_no_fade(cin_m082_docslab, TRUE);
		cinematic_suppress_bsp_object_creation(TRUE);
		f_insertion_zoneload( S_ZONESET_CIN_M82, FALSE );
		cinematic_suppress_bsp_object_creation(FALSE);
	
		f_start_mission(cin_m082_docslab);
		
		f_insertion_zoneload( S_ZONESET_ATRIUM, TRUE );
		f_insertion_teleport( ps_insertion_atrium.p0, ps_insertion_atrium.p1, ps_insertion_atrium.p2, ps_insertion_atrium.p3 );
		
		cinematic_exit(cin_m082_docslab, TRUE); 
		print ("Cinematic exited!");

	end

	ins_atrium();

end


// ==========================================================================================================================================================
// ATRIUM
// ==========================================================================================================================================================


script static void iat()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_ATRIUM );

end

script static void ins_atrium()

	f_insertion_begin( "ATRIUM" );
		f_insertion_zoneload( S_ZONESET_ATRIUM, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_atrium.p0, ps_insertion_atrium.p1, ps_insertion_atrium.p2, ps_insertion_atrium.p3 );
		if( not b_mission_started ) then
			f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
		end
	f_insertion_end();

	b_m80_music_progression = 80;
end


// ==========================================================================================================================================================
// TO AIRLOCK ONE
// ==========================================================================================================================================================


script static void iah()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_TO_AIRLOCK_ONE );

end

script static void ins_hallway_one()

	f_insertion_begin( "HALLWAYS ONE" );
		f_insertion_zoneload( S_ZONESET_ATRIUM_HUB, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_to_airlock_one.p0, ps_insertion_to_airlock_one.p1, ps_insertion_to_airlock_one.p2, ps_insertion_to_airlock_one.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	// setup
	b_m80_music_progression = 90;
	b_atrium_exited = TRUE;
	zoneset_prepare( S_ZONESET_TO_AIRLOCK_ONE );	
	
	//main
	//f_sfx_crash_start();

end


// ==========================================================================================================================================================
// AIRLOCK ONE
// ==========================================================================================================================================================


script static void ia1()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_AIRLOCK_ONE );

end

script static void ins_airlock_one()

	f_insertion_begin( "AIRLOCK ONE" );
		f_insertion_zoneload( S_ZONESET_TO_AIRLOCK_ONE_B, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_airlock_one.p0, ps_insertion_airlock_one.p1, ps_insertion_airlock_one.p2, ps_insertion_airlock_one.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_atrium_exited = TRUE;
	S_hallways_one_powerloss_state = DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_COMPLETE();  
	b_m80_music_progression = 120;
	
	//main
	wake( f_hallways_init );
//	wake( f_checktrigger_close_door_airlock_one_enter );
	//f_sfx_crash_start();

end


// ==========================================================================================================================================================
// TO AIRLOCK TWO
// ==========================================================================================================================================================


script static void ita2()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_TO_AIRLOCK_TWO );

end

script static void ins_to_airlock_two()

	f_insertion_begin( "HALLWAYS TWO" );
		f_insertion_zoneload( S_ZONESET_TO_AIRLOCK_TWO, TRUE );
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_to_airlock_two.p0, ps_insertion_to_airlock_two.p1, ps_insertion_to_airlock_two.p2, ps_insertion_to_airlock_two.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_m80_music_progression = 140;
	b_atrium_exited = TRUE;
	//main
	//f_sfx_crash_start();

end

// ==========================================================================================================================================================
// AIRLOCK TWO
// ==========================================================================================================================================================


script static void ia2()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_AIRLOCK_TWO );

end

script static void ins_airlock_two()

	f_insertion_begin( "AIRLOCK TWO" );
		f_insertion_zoneload( S_ZONESET_AIRLOCK_TWO, TRUE );
	
		//init
		//f_lichride_beat_set( DEF_R_LICHRIDE_BEAT_END() );
	
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_airlock_two.p0, ps_insertion_airlock_two.p1, ps_insertion_airlock_two.p2, ps_insertion_airlock_two.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_atrium_exited = TRUE;
	b_m80_music_progression = 150;
	
	//main
	wake( f_hallways_init );
//	wake( f_checktrigger_movingtowards_airlock_two );
	//f_sfx_crash_start();

end


// ==========================================================================================================================================================
// LOOKOUT
// ==========================================================================================================================================================


script static void ilo()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_LOOKOUT );

end

script static void ins_lookout()

	f_insertion_begin( "LOOKOUT" );
		f_insertion_zoneload( S_ZONESET_TO_LOOKOUT, TRUE );
	
		//init
		//f_lichride_beat_set( DEF_R_LICHRIDE_BEAT_END() );
	
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_lookout.p0, ps_insertion_lookout.p1, ps_insertion_lookout.p2, ps_insertion_lookout.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_m80_music_progression = 150;
	b_atrium_exited = TRUE;
	//main
	//f_sfx_crash_start();
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_OFFLINE() );

end


// ==========================================================================================================================================================
// GUNS HALLWAY
// ==========================================================================================================================================================


script static void igh()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_GUNS_HALLWAY );

end

script static void ins_guns_hallway()

	f_insertion_begin( "GUNS HALLWAY" );
		f_insertion_zoneload( S_ZONESET_LOOKOUT_EXIT, TRUE );
	
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_guns_hallway.p0, ps_insertion_guns_hallway.p1, ps_insertion_guns_hallway.p2, ps_insertion_guns_hallway.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_m80_music_progression = 160;
	b_atrium_exited = TRUE;
	B_guns_turrets_reactivated = TRUE;
	//main
	//f_sfx_crash_start();
end


// ==========================================================================================================================================================
// ATRIUM RETURN
// ==========================================================================================================================================================


script static void iar()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_ATRIUM_RETURN );

end

script static void ins_atrium_return()

	f_insertion_begin( "ATRIUM RETURN" );
		f_insertion_zoneload( S_ZONESET_ATRIUM_LOOKOUT, TRUE );
	
		//init
		//f_lichride_beat_set( DEF_R_LICHRIDE_BEAT_END() );
	
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_atrium_return.p0, ps_insertion_atrium_return.p1, ps_insertion_atrium_return.p2, ps_insertion_atrium_return.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	b_m80_music_progression = 180;
	b_atrium_exited = TRUE;
	B_guns_turrets_reactivated = TRUE;
	//main
	//f_sfx_crash_start();
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_CLOSE() );

end


// ==========================================================================================================================================================
// ATRIUM DESTROYED
// ==========================================================================================================================================================

script static void iad()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_ATRIUM_DESTROYED );

end

script static void ins_atrium_destroyed()

	f_insertion_begin( "ATRIUM DESTROYED" );
		f_insertion_zoneload( S_ZONESET_ATRIUM_DAMAGED, TRUE );
	
		//init
		//f_lichride_beat_set( DEF_R_LICHRIDE_BEAT_END() );
	
		f_insertion_playerwait();
		f_insertion_teleport( ps_insertion_atrium_destroyed.p0, ps_insertion_atrium_destroyed.p1, ps_insertion_atrium_destroyed.p2, ps_insertion_atrium_destroyed.p3 );
		f_insertion_playerprofile( profile_ar_magnum_thruster_2_0, FALSE );
	f_insertion_end();
	
	//main
	b_atrium_exited = TRUE;
	B_guns_turrets_reactivated = TRUE;
	b_m80_music_progression = 190;

	//wake( f_atriumreturn_init_doors );
//	wake( f_open_mechroom_elevator_open );
//	f_test_elevator();	
	//f_sfx_crash_start();
	f_audio_asteroid_guns_set( DEF_R_AUDIO_ASTEROID_GUNS_CLOSE() );
	f_objective_set( DEF_R_OBJECTIVE_ELEVATOR_ENTER(), TRUE, FALSE, TRUE, TRUE );
	
end


// ==========================================================================================================================================================
// CINEMATIC - 83
// ==========================================================================================================================================================


script static void i83()

	//b_reset_weapons = TRUE;
	f_insertion_reset( S_INSERTION_INDEX_CIN_83 );
	
end

script static void ins_cine_83()

	f_insertion_begin( "CINEMATIC - 083_encryption" );

	if( editor_mode() == FALSE or b_editor_cinematics ) then

		cinematic_enter(m083a, TRUE);
		cinematic_suppress_bsp_object_creation(TRUE);
		f_insertion_zoneload( S_ZONESET_CIN_M83, FALSE );
		cinematic_suppress_bsp_object_creation(false);
	
		f_start_mission(m083a);
		
		cinematic_exit_no_fade(m083a, TRUE);
		print ("Cinematic exited!");
	
	end

	music_start('Play_mus_m80' );
	b_atrium_exited = TRUE;
	B_guns_turrets_reactivated = TRUE;
	//f_sfx_crash_start();	

	game_won();
	
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// UTILITY
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// -------------------------------------------------------------------------------------------------
// INSERTION LOAD INDEX
// -------------------------------------------------------------------------------------------------

script static void f_insertion_index_load( short s_insertion )
	//dprint( "::: f_insertion_index_load :::" );

	local boolean b_started = FALSE;
	
	//inspect( s_insertion );
	
	if( s_insertion == S_INSERTION_INDEX_CIN_80 ) then
		b_started = TRUE;
		ins_cine_80();
	end
//	if( s_insertion == S_INSERTION_INDEX_LICH ) then
//		b_started = TRUE;
//		ins_lich();
//		ins_cine_81();
//	end
	if( s_insertion == S_INSERTION_INDEX_CIN_81 ) then
		b_started = TRUE;
		ins_cine_81();
	end
	if( s_insertion == S_INSERTION_INDEX_CRASH ) then
		b_started = TRUE;
		ins_crash();
	end
	if( s_insertion == S_INSERTION_INDEX_HORSESHOE ) then
		b_started = TRUE;
		ins_horseshoe();
	end
	if( s_insertion == S_INSERTION_INDEX_TO_LAB ) then
		b_started = TRUE;
		ins_to_lab();
	end
	if( s_insertion == S_INSERTION_INDEX_LAB ) then
		b_started = TRUE;
		ins_lab();
	end
	if( s_insertion == S_INSERTION_INDEX_CIN_82 ) then
		b_started = TRUE;
		ins_cine_82();
	end
	if( s_insertion == S_INSERTION_INDEX_ATRIUM ) then
		b_started = TRUE;
		ins_atrium();
	end
	if( s_insertion == S_INSERTION_INDEX_TO_AIRLOCK_ONE ) then
		b_started = TRUE;
		ins_hallway_one();
	end
	if( s_insertion == S_INSERTION_INDEX_AIRLOCK_ONE ) then
		b_started = TRUE;
		ins_airlock_one();
	end
	if( s_insertion == S_INSERTION_INDEX_TO_AIRLOCK_TWO ) then
		b_started = TRUE;
		ins_to_airlock_two();
	end	
	if( s_insertion == S_INSERTION_INDEX_AIRLOCK_TWO ) then
		b_started = TRUE;
		ins_airlock_two();
	end
	if( s_insertion == S_INSERTION_INDEX_LOOKOUT ) then
		b_started = TRUE;
		ins_lookout();
	end
	if( s_insertion == S_INSERTION_INDEX_GUNS_HALLWAY ) then
		b_started = TRUE;
		ins_guns_hallway();
	end
	if( s_insertion == S_INSERTION_INDEX_ATRIUM_RETURN ) then
		b_started = TRUE;
		ins_atrium_return();
	end
	if( s_insertion == S_INSERTION_INDEX_ATRIUM_DESTROYED ) then
		b_started = TRUE;
		ins_atrium_destroyed();
	end
	if( s_insertion == S_INSERTION_INDEX_CIN_83 ) then
		b_started = TRUE;
		ins_cine_83();
	end
	if ( not b_started ) then
		//dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		//inspect( s_insertion );
		b_started = TRUE;
		ins_cine_80();		
	end

end

script static zone_set f_zoneset_get( short s_index )

	local zone_set zs_return = "crash";

	if ( s_index == S_ZONESET_CIN_M80 ) then
		zs_return = "cin_m80";
	end
	if ( s_index == S_ZONESET_CRASH ) then
		zs_return = "crash";
	end
	if ( s_index == S_ZONESET_TO_HORSESHOE ) then
		zs_return = "to_horseshoe";
	end
	if ( s_index == S_ZONESET_HORSESHOE ) then
		zs_return = "horseshoe";
	end
	if ( s_index == S_ZONESET_TO_LAB ) then
		zs_return = "to_lab";
	end
	if ( s_index == S_ZONESET_LAB ) then
		zs_return = "lab";
	end
	if ( s_index == S_ZONESET_LAB_EXIT ) then
		zs_return = "lab_exit";
	end
	if ( s_index == S_ZONESET_CIN_M82 ) then
		zs_return = "cin_m82";
	end
	if ( s_index == S_ZONESET_ATRIUM ) then
		zs_return = "atrium";
	end
	if ( s_index == S_ZONESET_ATRIUM_HUB ) then
		zs_return = "atrium_hub";
	end
	if ( s_index == S_ZONESET_TO_AIRLOCK_ONE ) then
		zs_return = "to_airlock_one";
	end
	if ( s_index == S_ZONESET_TO_AIRLOCK_ONE_B ) then
		zs_return = "to_airlock_one_b";
	end
	if ( s_index == S_ZONESET_AIRLOCK_ONE ) then
		zs_return = "airlock_one";
	end
	if ( s_index == S_ZONESET_TO_AIRLOCK_TWO ) then
		zs_return = "to_airlock_two";
	end
	if ( s_index == S_ZONESET_AIRLOCK_TWO ) then
		zs_return = "airlock_two";
	end
	if ( s_index == S_ZONESET_TO_LOOKOUT ) then
		zs_return = "to_lookout";
	end
	if ( s_index == S_ZONESET_LOOKOUT ) then
		zs_return = "lookout";
	end
	if ( s_index == S_ZONESET_LOOKOUT_EXIT ) then
		zs_return = "lookout_exit";
	end
	if ( s_index == S_ZONESET_LOOKOUT_HALLWAYS_A ) then
		zs_return = "lookout_hallways_a";
	end
	if ( s_index == S_ZONESET_LOOKOUT_HALLWAYS_B ) then
		zs_return = "lookout_hallways_b";
	end
	if ( s_index == S_ZONESET_ATRIUM_RETURNING ) then
		zs_return = "atrium_returning";
	end
	if ( s_index == S_ZONESET_ATRIUM_LOOKOUT ) then
		zs_return = "atrium_lookout";
	end
	if ( s_index == S_ZONESET_ATRIUM_DAMAGED ) then
		zs_return = "atrium_damaged";
	end
	if ( s_index == S_ZONESET_MECHROOM_RETURN ) then
		zs_return = "mechroom_return";
	end
	if ( s_index == S_ZONESET_COMPOSER_REMOVAL ) then
		zs_return = "composer_removal";
	end
	if ( s_index == S_ZONESET_COMPOSER_REMOVAL_EXIT ) then
		zs_return = "composer_removal_exit";
	end
	if ( s_index == S_ZONESET_CIN_M83 ) then
		zs_return = "cin_m83";
	end

	zs_return;

end

