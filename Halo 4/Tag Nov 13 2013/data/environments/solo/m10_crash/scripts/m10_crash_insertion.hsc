//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_insertion
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab / Armory
//										iob							- Observation Deck
//										ifl							- Flank / Prep Room
//										ibe							- Beacon
//										ibr							- Broken Floor
//										iea							- Explosion Alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// NOTE: 	Several of the functions used in m10_crash_insertion use global_insertion.hsc.
//				You can find documentation in that file on how to setup your insertion script
//				so you can use the library of script functions to streamline your insertion script.

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

// Debug Options
global boolean b_debug 							= FALSE;
global boolean b_game_emulate				= FALSE;
global boolean b_insertion_reset		= TRUE;

//global boolean b_breakpoints				= FALSE;
//global boolean b_md_print						= TRUE;
//global boolean b_debug_objectives		= FALSE;
//global boolean b_cinematics 				= TRUE;
//global boolean b_editor_cinematics 	= FALSE;
//global boolean b_encounters					= TRUE;
//global boolean b_dialogue 					= TRUE;
//global boolean b_skip_intro					= FALSE;

//global boolean b_speedrun 					= FALSE;

global short DEF_INSERTION_INDEX_CINEMATIC																		= 0;
global short DEF_INSERTION_INDEX_CRYO 																				= 2;
global short DEF_INSERTION_INDEX_LAB 																					= 3;
global short DEF_INSERTION_INDEX_ELEVATOR_ICS 																= 4;
global short DEF_INSERTION_INDEX_OBSERVATORY 																	= 5;
global short DEF_INSERTION_INDEX_FLANK 																				= 1;
global short DEF_INSERTION_INDEX_FLANK2 																			= 6;
global short DEF_INSERTION_INDEX_BEACONS 																			= 7;
global short DEF_INSERTION_INDEX_BEACONS2 																		= 20;
global short DEF_INSERTION_INDEX_END		 																			= 8;
global short DEF_INSERTION_INDEX_BROKEN 																			= 9;
global short DEF_INSERTION_INDEX_MAINTENANCE_UPPER														= 10;
global short DEF_INSERTION_INDEX_MAINTENANCE_LOWER														= 11;
global short DEF_INSERTION_INDEX_EXPLOSIONALLEY 															= 12;
global short DEF_INSERTION_INDEX_VEHICLEBAY 																	= 13;
global short DEF_INSERTION_INDEX_SPACE		 																		= 14;
global short DEF_INSERTION_INDEX_TEST_PODCHASE																= 99;

// zone indexes
global short S_zoneset_00_cryo_02_hallway_04_armory 												= 0;
global short S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory 							= 2;
global short S_zoneset_08_elevator_14_elevator_16_lookout											= 3;
global short S_zoneset_16_lookout_18_elevator_20_cafe												= 4;
global short S_zoneset_24_corner_26_box_28_airlock													= 5;
global short S_zoneset_28_airlock_30_beacons														= 6;
global short S_zoneset_32_broken_34_maintenance														= 7;
global short S_zoneset_36_hallway_38_vehicle_40_debris												= 8;
global short S_zoneset_40_debris_42_skybox															= 9;
global short S_zoneset_cin_opening																	= 10;

// =================================================================================================
// =================================================================================================
// *** INSERTIONS ***
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// START
// -------------------------------------------------------------------------------------------------
script static void start()
	//dprint( "::: start :::");

	b_insertion_reset = FALSE;
	f_insertion_index_load( game_insertion_point_get() );

end

// -------------------------------------------------------------------------------------------------
// CINEMATIC
// -------------------------------------------------------------------------------------------------
script static void icn()
	f_insertion_reset( DEF_INSERTION_INDEX_CINEMATIC );
end

script static void ins_cine()

	f_insertion_begin( "CINEMATIC" );
	
	cinematic_enter( cin_m010_opening, TRUE );
	cinematic_suppress_bsp_object_creation( TRUE );
	f_insertion_zoneload( S_zoneset_cin_opening, FALSE );
	cinematic_suppress_bsp_object_creation( FALSE );
	
	hud_play_global_animtion (screen_fade_out);
	hud_stop_global_animtion (screen_fade_out);
		
	f_start_mission( cin_m010_opening );
	cinematic_exit_no_fade( cin_m010_opening, TRUE ); 
	dprint( "Cinematic exited!" );

	// start the cryo insertion point
	ins_cryo();

end


// -------------------------------------------------------------------------------------------------
// CRYO
// -------------------------------------------------------------------------------------------------
script static void icr()
	f_insertion_reset( DEF_INSERTION_INDEX_CRYO );
end

script static void ins_cryo()
	f_insertion_begin( "CRYO" );
	f_insertion_zoneload( S_zoneset_00_cryo_02_hallway_04_armory, FALSE );

	// setup the cry area
	wake( f_cryo_init );
	f_insertion_playerwait();
	f_insertion_teleport( ps_cryo_insertion.p0, ps_cryo_insertion.p1, ps_cryo_insertion.p2, ps_cryo_insertion.p3 );
	f_insertion_end();

	//hud_play_global_animtion (m10_hud_off);
	//hud_stop_global_animtion (m10_hud_off);
	
	// force objective index
	b_m10_music_progression = 0;
	wake( f_cryo_main );
	
	// forces setup of mission functions to put game into proper state
	B_player_has_cortana = FALSE;
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_NONE );
	dprint("::: INSERTION: COMPLETE" );
end

// -------------------------------------------------------------------------------------------------
// LAB
// -------------------------------------------------------------------------------------------------
script static void ila()
	f_insertion_reset( DEF_INSERTION_INDEX_LAB );
end

script static void ins_lab()

	f_insertion_begin( "LAB" );
	f_insertion_zoneload( S_zoneset_00_cryo_02_hallway_04_armory, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_lab_insertion.p0, ps_lab_insertion.p1, ps_lab_insertion.p2, ps_lab_insertion.p3 );
	f_insertion_playerprofile( default_respawn, FALSE );
	f_insertion_end();
	
	// force objective index
	b_m10_music_progression = 10;
	wake(f_lab_init );
	
	// forces setup of mission functions to put game into proper state
	B_player_has_cortana = TRUE;
	
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB );
	//dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// ELEVATOR ICS
// -------------------------------------------------------------------------------------------------
script static void iel()
	f_insertion_reset( DEF_INSERTION_INDEX_ELEVATOR_ICS );
end

script static void ins_ICS_elevator()

	f_insertion_begin( "ELEVATOR ICS" );
	f_insertion_zoneload( S_zoneset_00_cryo_02_hallway_04_armory, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_elevator_ICS_insertion.p0, ps_elevator_ICS_insertion.p1, ps_elevator_ICS_insertion.p2, ps_elevator_ICS_insertion.p3 );
	f_insertion_playerprofile( default_respawn, FALSE );
	f_insertion_end();
	
	// force objective index
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 10;
	B_player_has_cortana = TRUE;
	
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB );
	//dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// OBSERVATORY
// -------------------------------------------------------------------------------------------------
script static void iob()
	f_insertion_reset( DEF_INSERTION_INDEX_OBSERVATORY );
end

script static void ins_observatory()

	f_insertion_begin( "OBSERVATORY" );
	f_insertion_zoneload( S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_observatory_insertion.p0, ps_observatory_insertion.p1, ps_observatory_insertion.p2, ps_observatory_insertion.p3 );
	f_insertion_playerprofile( default_respawn, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 20;
	
	//wake( f_observatory_main );
	wake(f_observatory_main_02);
	B_player_has_cortana = TRUE;
	
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB );
	//dprint(":::PLAYER HAS CORTANA:::");
	//dprint("::: INSERTION: COMPLETE" );
	
		R_objective_current_index = DEF_R_OBJECTIVE_GOTO_OBSERVATION;
end

// -------------------------------------------------------------------------------------------------
// FLANK 1
// -------------------------------------------------------------------------------------------------
// RALLY POINT BRAVO
script static void ifl()
	f_insertion_reset( DEF_INSERTION_INDEX_FLANK );
end

script static void ins_flank()

	f_insertion_begin( "FLANK" );
	f_insertion_zoneload( S_zoneset_08_elevator_14_elevator_16_lookout, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_flank_insertion.p0, ps_flank_insertion.p1, ps_flank_insertion.p2, ps_flank_insertion.p3 );
	f_insertion_playerprofile( default_respawn, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	fade_in(0,0,0,0);
	b_m10_music_progression = 40;
	
	thread (f_objective_set( DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS, TRUE, FALSE, TRUE, FALSE ));
	wake( f_flank_main );
	B_player_has_cortana = TRUE;
	
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB );
	//dprint("::: INSERTION: COMPLETE" );
	
	R_objective_current_index = DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS;
end

// -------------------------------------------------------------------------------------------------
// FLANK 2
// -------------------------------------------------------------------------------------------------

script static void ifl2()
	f_insertion_reset( DEF_INSERTION_INDEX_FLANK2 );
end

script static void ins_flank2()

	f_insertion_begin( "FLANK2" );
	f_insertion_zoneload( S_zoneset_24_corner_26_box_28_airlock, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_flank2_insertion.p0, ps_flank2_insertion.p1, ps_flank2_insertion.p2, ps_flank2_insertion.p3 );
	f_insertion_playerprofile( default_respawn, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 60;
	
	wake( f_flank_encounter_start );
	thread(f_flank_door_block());
	B_player_has_cortana = TRUE;
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_LAB );
	//dprint("::: INSERTION: COMPLETE" );
	
	R_objective_current_index = DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS;
		
end

// -------------------------------------------------------------------------------------------------
// BEACONS
// -------------------------------------------------------------------------------------------------
script static void ibe()
	f_insertion_reset( DEF_INSERTION_INDEX_BEACONS );
end

script static void ins_beacons()

	f_insertion_begin( "BEACONS" );
	f_insertion_zoneload( S_zoneset_28_airlock_30_beacons, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_beacons_insertion.p0, ps_beacons_insertion.p1, ps_beacons_insertion.p2, ps_beacons_insertion.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 70;
	B_airlock_1_complete = TRUE;
	wake( f_beacon_main );
	B_player_has_cortana = TRUE;
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_BEACON_START );
	//dprint("::: INSERTION: COMPLETE" );
	
	R_objective_current_index = DEF_R_OBJECTIVE_FIND_MISSILE_CONTROLS;
end


// -------------------------------------------------------------------------------------------------
// END
// -------------------------------------------------------------------------------------------------
script static void ind()
	f_insertion_reset( DEF_INSERTION_INDEX_END );
end

script static void ins_end()

	f_insertion_begin( "END" );
	f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_ins_ind.p0, ps_ins_ind.p1, ps_ins_ind.p2, ps_ins_ind.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	f_objective_set( DEF_R_OBJECTIVE_NONE, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 90;
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_BEACON_END );
	//dprint("::: INSERTION: COMPLETE" );
	door_airlock_2_interior->open();
	
end

// -------------------------------------------------------------------------------------------------
// BROKEN FLOOR
// -------------------------------------------------------------------------------------------------
script static void ibr()
	f_insertion_reset( DEF_INSERTION_INDEX_BROKEN );
end

script static void ins_broken_floor()

	f_insertion_begin( "BROKEN FLOOR" );
	f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_ins_ibr.p0, ps_ins_ibr.p1, ps_ins_ibr.p2, ps_ins_ibr.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 90;
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_AIRLOCK );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_END );
	//dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: UPPER
// -------------------------------------------------------------------------------------------------
script static void imu()
	f_insertion_reset( DEF_INSERTION_INDEX_MAINTENANCE_UPPER );
end

script static void ins_maintenance_upper()

	f_insertion_begin( "MAINTENANCE: UPPER" );
	f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_maintenance_upper_insertion.p0, ps_maintenance_upper_insertion.p1, ps_maintenance_upper_insertion.p2, ps_maintenance_upper_insertion.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 90;
	f_brokenfloor_destruction_animate( 1.0, 0.1, 0.1 );
	//f_gravity_set( R_gravity_end );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_BROKEN_ROOM );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE );
	//dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// MAINTENANCE: LOWER
// -------------------------------------------------------------------------------------------------
script static void iml()
	f_insertion_reset( DEF_INSERTION_INDEX_MAINTENANCE_LOWER );
end

script static void ins_maintenance_lower()

	f_insertion_begin( "MAINTENANCE: LOWER" );
	f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_maintenance_lower_insertion.p0, ps_maintenance_lower_insertion.p1, ps_maintenance_lower_insertion.p2, ps_maintenance_lower_insertion.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 90;
	f_brokenfloor_destruction_animate( 1.0, 0.1, 0.1 );
	//f_gravity_set( R_gravity_end );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_BROKEN_ROOM );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE );
	//dprint("::: INSERTION: COMPLETE" );
	
end
// -------------------------------------------------------------------------------------------------
// EXPLOSION ALLEY
// -------------------------------------------------------------------------------------------------
script static void iea()
	f_insertion_reset( DEF_INSERTION_INDEX_EXPLOSIONALLEY );
end

script static void ins_explosion_alley()

	f_insertion_begin( "EXPLOSION ALLEY" );
	f_insertion_zoneload( S_zoneset_32_broken_34_maintenance, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_explosion_alley_insertion.p0, ps_explosion_alley_insertion.p1, ps_explosion_alley_insertion.p2, ps_explosion_alley_insertion.p3 );
	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 90;
	//f_gravity_set( R_gravity_end );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_MAINTENANCE );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_EXPLOSIONALLEY );
	//dprint("::: INSERTION: COMPLETE" );
	
end

// -------------------------------------------------------------------------------------------------
// VEHICLE BAY
// -------------------------------------------------------------------------------------------------
script static void ivb()
	f_insertion_reset( DEF_INSERTION_INDEX_VEHICLEBAY );
end

script static void ins_vehicle_bay()

	f_insertion_begin( "VEHICLE BAY" );
	f_insertion_zoneload( S_zoneset_36_hallway_38_vehicle_40_debris, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_vehicle_bay_insertion.p0, ps_vehicle_bay_insertion.p1, ps_vehicle_bay_insertion.p2, ps_vehicle_bay_insertion.p3 );
//	f_insertion_playerprofile( default_single_sniper, FALSE );
	f_insertion_end();
	
	// force objective index
	//f_objective_set( DEF_R_OBJECTIVE_REACH_ESCAPE_PODS, FALSE, TRUE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	b_m10_music_progression = 100;
	//f_gravity_set( R_gravity_end );
	wake( f_maintenance_airlock_init );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_VEHICLEBAY );
	//dprint("::: INSERTION: COMPLETE" );
	
end

//// -------------------------------------------------------------------------------------------------
//// SPACE
//// -------------------------------------------------------------------------------------------------
//script static void isp()
//	f_insertion_reset( DEF_INSERTION_INDEX_SPACE );
//end
//
//script static void ins_space()
//
//	f_insertion_begin( "POD CHASE" );
//	f_insertion_zoneload( S_zoneset_40_debris_42_skybox, FALSE );
//	f_insertion_playerwait();
//	//f_gravity_set( R_gravity_space );
//	f_insertion_teleport( ps_ins_iju.p0, ps_ins_iju.p1, ps_ins_iju.p2, ps_ins_iju.p3 );
//	f_insertion_playerprofile( default_single_sniper, FALSE );
//	f_insertion_end();
//	
//	// force objective index
//	//f_objective_set( DEF_R_OBJECTIVE_NONE, FALSE, FALSE, FALSE, FALSE );
//
//	// forces setup of mission functions to put game into proper state
//	wake( f_debris_FUD_destruction_action );
//	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_SPACE );
//	//dprint("::: INSERTION: COMPLETE" );
//	
//end
//
//// -------------------------------------------------------------------------------------------------
//// TEST PODCHASE
//// -------------------------------------------------------------------------------------------------
//script static void itpc()
//	f_insertion_reset( DEF_INSERTION_INDEX_TEST_PODCHASE );
//end
//
//script static void ins_test_podchase()
//
//	f_insertion_begin( "TEST POD CHASE" );
//	f_insertion_zoneload( S_zoneset_40_debris_42_skybox, FALSE );
//	f_insertion_playerwait();
//	f_insertion_teleport( ps_ins_tpc.p0, ps_ins_tpc.p1, ps_ins_tpc.p2, ps_ins_tpc.p3 );
//	f_insertion_playerprofile( default_single_sniper, FALSE );
//	f_insertion_end();
//	
//	/*
//	// force objective index
//	f_objective_set( DEF_R_OBJECTIVE_NONE, FALSE, FALSE, FALSE, FALSE );
//
//	// forces setup of mission functions to put game into proper state
//	f_gravity_set( R_gravity_podchase );
//	wake( f_vehiclebay_destruction_skip );
//	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_VEHICLEBAY );
//	//dprint("::: INSERTION: COMPLETE" );
//	*/
//
//	f_gravity_set( 0.0 );
//
//	dprint( ">>>>> CREATE TEST BOX" );
//	f_object_create( dm_podchase_test_box, TRUE );
//	object_cinematic_visibility(dm_podchase_test_box, true);
//	object_set_always_active( dm_podchase_test_box, TRUE );
//
//	dprint( ">>>>> ATTACH TEST BOX" );
//	object_set_physics( player_get(0), FALSE ); 
//	objects_attach( dm_podchase_test_box, "m_player0", player_get(0), "" );
//	
//	device_set_position_track( dm_podchase_test_box, 'any:idle', 0 );
//	
//	test_podchase_box();
//	
//end
//
//script static void test_podchase_box()
//
//	dprint( ">>>>> MOVE TEST BOX" );
//	repeat
//
//		sleep_s( 0.5 );
//		//objects_detach( dm_podchase_test_box, player_get(0) );
//		//object_set_physics( player_get(0), TRUE ); 
//		device_animate_position( dm_podchase_test_box, 1.0, 30.0, 0.1, 0, TRUE );
//		sleep_until( device_get_position(dm_podchase_test_box) == 1.0 );
//
//		//object_set_physics( player_get(0), FALSE ); 
//		//objects_attach( dm_podchase_test_box, "m_player0", player_get(0), "" );
//		device_animate_position( dm_podchase_test_box, 0.0, 2.5, 0.1, 0, TRUE );
//		sleep_until( device_get_position(dm_podchase_test_box) == 0.0 );
//
//	until( FALSE, 1 );
//
//end



// =================================================================================================
// =================================================================================================
// UTILITY
// =================================================================================================
// =================================================================================================
// -------------------------------------------------------------------------------------------------
// XXX
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// XXX
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// INSERTION LOAD INDEX
// -------------------------------------------------------------------------------------------------
script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	//dprint( "::: f_insertion_index_load :::" );
	inspect( game_insertion_point_get() );
	
	if (s_insertion == DEF_INSERTION_INDEX_CINEMATIC) then
		b_started = TRUE;
		ins_cine();
	end
	if (s_insertion == DEF_INSERTION_INDEX_CRYO) then
		b_started = TRUE;
		ins_cryo();
	end
	if (s_insertion == DEF_INSERTION_INDEX_LAB) then
		b_started = TRUE;
		ins_lab();
	end
	if (s_insertion == DEF_INSERTION_INDEX_ELEVATOR_ICS) then
		b_started = TRUE;
		ins_ICS_elevator();
	end
	if (s_insertion == DEF_INSERTION_INDEX_OBSERVATORY) then
		b_started = TRUE;
		ins_observatory();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLANK) then
		b_started = TRUE;
		ins_flank();
	end
	if (s_insertion == DEF_INSERTION_INDEX_FLANK2) then
		b_started = TRUE;
		ins_flank2();
	end
	if (s_insertion == DEF_INSERTION_INDEX_BEACONS) then
		b_started = TRUE;
		ins_beacons();
	end
	if (s_insertion == DEF_INSERTION_INDEX_END) then
		b_started = TRUE;
		ins_end();
	end
	if (s_insertion == DEF_INSERTION_INDEX_BROKEN) then
		b_started = TRUE;
		ins_broken_floor();
	end
	if (s_insertion == DEF_INSERTION_INDEX_MAINTENANCE_UPPER) then
		b_started = TRUE;
		ins_maintenance_upper();
	end
	if (s_insertion == DEF_INSERTION_INDEX_MAINTENANCE_LOWER) then
		b_started = TRUE;
		ins_maintenance_lower();
	end
	if (s_insertion == DEF_INSERTION_INDEX_EXPLOSIONALLEY) then
		b_started = TRUE;
		ins_explosion_alley();
	end
	if (s_insertion == DEF_INSERTION_INDEX_VEHICLEBAY) then
		b_started = TRUE;
		ins_vehicle_bay();
	end
//	if (s_insertion == DEF_INSERTION_INDEX_SPACE) then
//		b_started = TRUE;
//		ins_space();
//	end
//	if (s_insertion == DEF_INSERTION_INDEX_TEST_PODCHASE) then
//		b_started = TRUE;
//		ins_test_podchase();
//	end
	
	if ( not b_started ) then
		dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		inspect( s_insertion );
	end

end

script static zone_set f_zoneset_get( short s_index )
	local zone_set zs_return = "00_cryo_02_hallway_04_armory";

	if ( s_index == S_zoneset_00_cryo_02_hallway_04_armory ) then
	 zs_return = "00_cryo_02_hallway_04_armory";
	end
	if ( s_index == S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory ) then
	 zs_return = "06_hallway_08_elevator_10_elevator_12_observatory";
	end
	if ( s_index == S_zoneset_08_elevator_14_elevator_16_lookout ) then
	 zs_return = "08_elevator_14_elevator_16_lookout";
	end
	if ( s_index == S_zoneset_16_lookout_18_elevator_20_cafe ) then
	 zs_return = "16_lookout_18_elevator_20_cafe";
	end
	if ( s_index == S_zoneset_24_corner_26_box_28_airlock ) then
	 zs_return = "24_corner_26_box_28_airlock";
	end
	if ( s_index == S_zoneset_28_airlock_30_beacons ) then
	 zs_return = "28_airlock_30_beacons";
	end
	if ( s_index == S_zoneset_32_broken_34_maintenance ) then
	 zs_return = "32_broken_34_maintenance";
	end
	if ( s_index == S_zoneset_36_hallway_38_vehicle_40_debris ) then
	 zs_return = "36_hallway_38_vehicle_40_debris";
	end
	if ( s_index == S_zoneset_40_debris_42_skybox ) then
	 zs_return = "40_debris_42_skybox";
	end
	if ( s_index == S_zoneset_cin_opening ) then
	 zs_return = "cin_opening";
	end
	
	// return
	zs_return;
end