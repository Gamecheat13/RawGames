// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// GLOBAL INSERTION
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// 	NOTE: Initial setup for your script to use the global_insertion script seems a bit complicated but really it's pretty simple
//				and quick to setup.  Once you do it it can save a lot of time adding insertion points or managing zone set changes.
//				The other benefit was it made the insertion point script use less copy-paste code which became unwieldy when managing
//				mission wide changes to how we were dealing with insertion points.  It also made things like the mission's start()
//				function very clean and easy to use.  Another benefit was by setting up your script with these functions allowed us
//				to use some of it's core functions to streamline scripted loading of zones with the function f_insertion_zoneload().
//				Creating more streamlined code and less bugs.
//				
//				I'd recommend looking at the m10_crash_insertion.hsc script to see how it works in there.  If you run into problems
//				(I may have missed some things) or have any questions, feel free to just ask for help.
//				- ThFrench
//
//	SETUP STEPS:
//	In order for you to use the global_insertion.hsc script you will need to do the following:
//		1) Add the global_insertion.hsc script to all your scenario files
//		2) [optional] Create variables for your insertion point indexes
//			NOTE: This is not mandatory but I'd highly recommend it as it has made adding insertion points
//						significantly easier to manage because it's faster to change the index when adding new ones
//						in one place, rather than changing hard coded variables.
/*
global short DEF_INSERTION_INDEX_<NAME 0>																				= 0;
global short DEF_INSERTION_INDEX_<NAME 1> 																			= 1;
... etc.
*/
//		3) [optional] Create variables for zone set indexes
//			NOTE: Like insertion point indexes not mandatory, but it has saved us headaches tracking down all
//						the references when zone set names change, get moved around in the tag structure, etc.  When
//						a zone name changes, we would change the variable name first which would generate compile errors
//						in the other mission scripts referencing it which made it easy to track down and make sure
//						we fixed all the cases.
//			NOTE: The index numbers should match the order in your mission.scenario file
/*
global short S_zoneset_<zone 0 name> 																					= 0;
global short S_zoneset_<zone 1 name> 																					= 1;
... etc.
*/
//		4) Add the following function to your scripts (usually your insertion point script) and fill out the function information appropriately.
//				NOTE: The purpose of this function is to call the proper insertion point based on which insertion point index you pass into it.
/*
script static void f_insertion_index_load( short s_insertion )
local boolean b_started = FALSE;
	//dprint( "::: f_insertion_index_load :::" );
	//inspect( game_insertion_point_get() );
	
	if (s_insertion == <INSERTION INDEX 0>) then
		b_started = TRUE;
		<insertion point 0 function>();
	end
	if (s_insertion == <INSERTION INDEX 1>) then
		b_started = TRUE;
		<insertion point 1 function>();
	end
	.
	.
	.
	(other insertion point index loads)
	.
	.
	.
	if ( not b_started ) then
		//dprint( "f_insertion_index_load: ERROR: Failed to find insertion point index to load" );
		//inspect( s_insertion );
	end
end
*/
//		5) Add the following function to your scripts (usually your insertion point script) and fill out the function information appropriately.
//				NOTE: The purpose of this function is to take the zone index passed into it and convert it into a real zone set type variable to use
/*
script static zone_set f_zoneset_get( short s_index )
local zone_set zs_return = "<name of default zone set to return>";

	if ( s_index == <zone set 0 index> ) then
	 zs_return = "<zone set 0 name>";
	end
	if ( s_index == <zone set 1 index> ) then
	 zs_return = "<zone set 1 name>";
	end
	.
	.
	.
	(other insertion point index loads)
	.
	.
	.
	
	// return
	zs_return;
end
*/
//
// INSERTION FUNCTIONS:
//		NOTE: As mentioned before it really cleaned up our insertion point script for m10.  Here is the basic structure of a typical insertion point
//					function from m10.  Some of the functions being called are pretty basic (even just for debugging) but will allow for global updates if
//					in the future we need to update something across the game.
//
//		EXAMPLE:
/*
script static void ins_broken_floor()

	// Core insertion functions
	//	NOTE: This handles the standard insertion flow.  At times we would have to do more hand scripted things but that was usually in the case
	//				of special insertion point functions like our opening cinematic function or the cryo startup.
	f_insertion_begin( "BROKEN FLOOR" );
	f_insertion_zoneload( S_zoneset_28_airlock_32_broken, FALSE );
	f_insertion_playerwait();
	f_insertion_teleport( ps_broken_floor_insertion.p0, ps_broken_floor_insertion.p1, ps_broken_floor_insertion.p2, ps_broken_floor_insertion.p3 );
	f_insertion_playerprofile( default_single_jetpack, TRUE );
	f_insertion_end();
	
	// force objective index
	//	NOTE:	We used global_objectives.hsc through our mission, so this is how we would force the current objective for the insertion.  It would auto 
	//				handle cleanup of objectives when jumping between insertion points in meetings, etc. which was very convenient and helped prevent a bunch
	//				of false bugs.
	f_objective_set( DEF_S_OBJECTIVE_NONE, FALSE, FALSE, FALSE, FALSE );
	
	// forces setup of mission functions to put game into proper state
	//	NOTE:	This area was to startup any functions, or do any special case stuff to make the insertion point work
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_END );
	//dprint("::: INSERTION: COMPLETE" );
	
end
*/


// -------------------------------------------------------------------------------------------------
// BASE INSERTION HELPERS
// -------------------------------------------------------------------------------------------------
// --- variables -----------------------------------------------------------------------------------
global short S_insertion_index = 														0;

// --- functions -----------------------------------------------------------------------------------
// === f_insertion_begin: Start of your insertion block.  For now, mainly for debugging purposes.
//			str_debug = String name of the insertion point for debugging
//	RETURNS:  void
script static void f_insertion_begin( string str_debug )

	//dprint( "INSERTION POINT: --------------------------------------" );
	dprint( str_debug );
	//dprint( "-------------------------------------------------------" );

end

// === f_insertion_reset: Used by the start() and shorthand insertion functions (like icr()) to
//												reset the map and set the correct insertion index to load after.
//			s_index = insertion index to load
//	RETURNS:  void
script static void f_insertion_reset( short s_index )

	game_insertion_point_set( s_index );
	//game_initial_zone_set( f_zoneset_get(s_index) );
	
	if ( b_game_emulate or (not editor_mode()) ) then
		map_reset();
	else
		f_insertion_index_load( s_index );
	end
	
end

// === f_insertion_zoneload: Loads an insertion index
//			s_index = zone set index to load
//			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
//	RETURNS:  void
script static void f_insertion_zoneload( short s_index, boolean b_check_loaded )
	zoneset_load( s_index, b_check_loaded );
end
script static void f_insertion_zoneload( short s_index )
	zoneset_load( s_index, FALSE );
end

// === f_insertion_zoneload_prepare: Prepares zone set for loading
//			s_index = zone set index to load
//			b_check_loaded = TRUE; will not try and reload if zone set is already loaded, FALSE; will load zone set even if it's already loaded
//	RETURNS:  void
script static void f_insertion_zoneload_prepare( short s_index, boolean b_check_loaded )
	zoneset_prepare( s_index, b_check_loaded );
end
script static void f_insertion_zoneload_prepare( short s_index )
	zoneset_prepare( s_index, FALSE );
end

// === f_insertion_playerwait: If the game is in editor mode, it will wait for a player to be ready before finishing the insertion point
//															which makes debugging events, etc. a bit easier to have them all startup reliably at the same time.
//	RETURNS:  void
script static void f_insertion_playerwait()

	//if ( editor_mode() ) then
		//dprint( "::: INSERTION: PLAYER WAIT" );
		sleep_until( player_valid_count() >= player_count(), 1 );
	//else
		//sleep( 1 );
	//end
	
end

// === f_insertion_teleport: Teleports players to the point references
//			pr_p#(0-3) = Point reference to put player 0-3 at
//	RETURNS:  void
script static void f_insertion_teleport( point_reference pr_p0, point_reference pr_p1, point_reference pr_p2, point_reference pr_p3 )

	//dprint( "::: INSERTION: TELEPORT" );
	//if ( player_is_in_game( player0 ) ) then
		//dprint( "::: INSERTION: TELEPORT: P0" );
		object_teleport_to_ai_point( player0, pr_p0 );
	//end
	//if ( player_is_in_game( player1 ) ) then
		//dprint( "::: INSERTION: TELEPORT: P1" );
		object_teleport_to_ai_point( player1, pr_p1 );
	//end
	//if ( player_is_in_game( player2 ) ) then
		//dprint( "::: INSERTION: TELEPORT: P2" );
		object_teleport_to_ai_point( player2, pr_p2 );
	//end
	//if ( player_is_in_game( player3 ) ) then
		//dprint( "::: INSERTION: TELEPORT: P3" );
		object_teleport_to_ai_point( player3, pr_p3 );
	//end
	sleep( 1 );
	
end

// === f_insertion_playerprofile: Adds startup profile equipment to the players
//			sp_profile = Equipment profile to give everyone
//			b_wait_equipment = TRUE; will wait for player to have equipment before returning, useful if you need to check their equipment immediately after
//													the insertion has finished loading
//	RETURNS:  void
script static void f_insertion_playerprofile( starting_profile sp_profile, boolean b_wait_equipment )

	// set the starting profile
	player_set_profile( sp_profile );

	//dprint( "::: INSERTION: STARTING PROFILE" );
	if ( player_is_in_game(player0) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P0" );
		unit_add_equipment( player0, sp_profile, TRUE, FALSE );
		if ( b_wait_equipment and (not unit_has_any_equipment(player0)) ) then
			sleep_until( unit_has_any_equipment(player0), 1 );
		end
	end
	if ( player_is_in_game(player1) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P1" );
		unit_add_equipment( player1, sp_profile, TRUE, FALSE );
		if ( b_wait_equipment and (not unit_has_any_equipment(player1)) ) then
			sleep_until( unit_has_any_equipment(player1), 1 );
		end
	end
	if ( player_is_in_game(player2) ) then
		//dprint( "::: INSERTION: STARTING PROFILE: P2" );
		unit_add_equipment( player2, sp_profile, TRUE, FALSE );
		if ( b_wait_equipment and (not unit_has_any_equipment(player2)) ) then
			sleep_until( unit_has_any_equipment(player2), 1 );
		end
	end
	if ( player_is_in_game(player3) )then
		//dprint( "::: INSERTION: STARTING PROFILE: P3" );
		unit_add_equipment( player3, sp_profile, TRUE, FALSE );
		if ( b_wait_equipment and (not unit_has_any_equipment(player3)) ) then
			sleep_until( unit_has_any_equipment(player3), 1 );
		end
	end
	
	sleep( 1 );
	
end
script static void f_insertion_playerprofile( starting_profile sp_profile )
	f_insertion_playerprofile( sp_profile, FALSE );
end

// === f_insertion_end: Handles finishing any default insertion point startup cleanup
//	RETURNS:  void
script static void f_insertion_end()

	//dprint("::: INSERTION: START" );
	b_mission_started = TRUE;
	sleep( 1 );
	game_save();
	
end
