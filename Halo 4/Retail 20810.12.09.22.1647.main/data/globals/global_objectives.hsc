// =================================================================================================
// =================================================================================================
// =================================================================================================
// GLOBAL_OBJECTIVES.HSC
// =================================================================================================
// =================================================================================================
// =================================================================================================
// =================================================================================================
// INSTRUCTIONS:
// 1. Add "global_objectives" script to your Scenario
//		- Open your scenario in Sapien 
//		- In the menu bar, open the "Scenarios" menu, then select "Add Mission Script"
//		- Point the dialogue to this file: main\data\globals\global_objectives.hsc
//		* NOTE: It appears you still have to do this to all the child scenarios as well for the scripts to compile.
// 2. Add objective index variables
//		- For each objective add a unique index variable of type real
//			EXAMPLE: global real DEF_R_OBJECTIVE_PODCHASE_GOTO 			= 11.0;
//		* WHAT IS AN OBJECTIVE?
//						Objectives are defined as anytime we blip a something as it's an objective to goto, interact, etc.
//		* NOTE: These can exist in any one of your mission scripts.  For M10 we added an M10_objectives file.
//						These can be of whatever naming convention you want.
//						You can use this by just hard coding the values in your script but it is not reccomended.  Having them defined
//						in one place allows for faster adding/removing of objectives.
//						Each index should be a unique number in your list.  Do not use -1 as that's reserved for no objective.
// 3. Add f_mission_objective_blip function to your mission scripts
//		- Add the function "script boolean void f_mission_objective_blip( real r_index, boolean b_blip )" to one of your mission scripts.
//		* NOTE: This function can be in any one of your mission scripts.  For M10 we added an M10_objectives file.
//						This function handles blipping of the propper index.  For an example of how it works see M10_objectives.hsc
//						The intended purpose of this function is to have one central location where you can quickly iterate on all things related
//						to the blips for the objectives.
//						This function should return TRUE if the objective was blipped/unblipped.
// 4. Add f_mission_objective_title function to your mission scripts
//		- Add the function "script static cutscene_title f_mission_objective_title( real r_index )" to one of your mission scripts
//		* NOTE: This function can be in any one of your mission scripts.  For M10 we added an M10_objectives file.
//						This functions purpose is to return the cinematic title for your objective.  If it's the same title as a previous objective
//						you can either add the title again or just not add one for that index (which returns SID_objective_none by default).
//						Redundantly returning the same title for each "sub-objective" will insure that if you insertion point ahead and it sets up the objective it will display the "new objective" message information again.
//						Objectives can share titles and it's best that they do otherwise you will keep getting "New Objective" messages all the time.
//						The purpose for this is to be able to easily drop in new objectives in one place in your scripts.  Reducing having to dig through scripts to update stuff like this.
// =================================================================================================



// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: SET
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === f_objective_set: Sets the current objective index and handles completing the old and starting the new
//			r_index = objective index you want to set active
//								NOTE: 	You can use DEF_R_OBJECTIVE_NONE to create a new objective but I'm not 100% sure what it will do
//												It will only add the objective if it's not already the same index
//												The title will automatically display if it wasn't the last title.  This way if you skip ahead,
//												it will still remind you of the objective.  Mainly for debug purposes.
//			b_new_msg = do you want to display the "new objective" message
//			b_new_blip = do you want to blip the new objective at the default time
//			b_complete_msg = If there is was previous objective with a different title, do you want to show the complete message 
//			b_complete_unblip = If there is something blipped, do you want to unblip it
script static boolean f_objective_set( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip, real r_blip_delay )
local boolean b_return = FALSE;
	//dprint( "::: f_objective_set :::" );
	//inspect( r_index );

	// complete current index
	if ( (r_index != f_objective_current_index()) and (f_objective_current_index() != DEF_R_OBJECTIVE_NONE) ) then
		f_objective_complete( f_objective_current_index(), b_complete_msg, b_complete_unblip );
	end
	
	// setup the new objective
	if ( (not f_objective_current_check(r_index)) and (not f_objective_starting_check(r_index)) ) then
		
		// set starting objective index
		R_objective_starting_index = r_index;

		if ( r_index != DEF_R_OBJECTIVE_NONE ) then

			// set this as the current objective
			if ( f_objective_starting_check(r_index) ) then
				b_return = TRUE;
				R_objective_current_index = r_index;
			end

			// blip
			if ( b_new_blip ) then
				if ( f_objective_starting_check(r_index) ) then
					thread( f_objective_blip(r_index, TRUE, TRUE, r_blip_delay) );
				end
			end

			// display the title
			if ( (f_mission_objective_title(r_index) != SID_objective_last_title) and (f_mission_objective_title(r_index) != SID_objective_none) ) then
				if ( f_objective_starting_check(r_index) ) then
					//dprint( "::: f_objective_new : TITLE ------------------------------------------------------------------------------- :::" );
					
					// store the last title
					SID_objective_last_title = f_mission_objective_title( r_index );
					cui_hud_set_new_objective( SID_objective_last_title );
					
				end				
			end

		end

		// reset the starting index
		if ( f_objective_starting_check(r_index) ) then
			R_objective_starting_index = DEF_R_OBJECTIVE_NONE;
		end
		
	end

	// return
	b_return;

end
script static boolean f_objective_set( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip )
	f_objective_set( r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip, -1.0 );
end

// === f_objective_set_timer: XXX
script static long f_objective_set_timer( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip, real r_time )
	if ( f_objective_set(r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip) ) then
		f_objective_blip_timer( r_index, not b_new_blip, r_time );
	else
		0;
	end
end

// === f_objective_set_timer_reminder: XXX
script static long f_objective_set_timer_reminder( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip )
	f_objective_set_timer( r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip, f_objective_reminder_blip_delay() );
end

// === f_objective_set_trigger_player: XXX
script static long f_objective_set_trigger_player( real r_index, boolean b_new_msg, boolean b_new_blip, boolean b_complete_msg, boolean b_complete_unblip, trigger_volume tv_volume, boolean b_check_all, boolean b_check_in )
	if ( f_objective_set(r_index, b_new_msg, b_new_blip, b_complete_msg, b_complete_unblip) ) then
		f_objective_blip_trigger_players( r_index, not b_new_blip, tv_volume, b_check_all, b_check_in );
	else
		0;
	end
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// DEFINES -----------------------------------------------------------------------------------------
global real DEF_R_OBJECTIVE_NONE 								= -1.0;

// VARIABLES ---------------------------------------------------------------------------------------
global real R_objective_current_index = 				DEF_R_OBJECTIVE_NONE;
global real R_objective_current_index_blipped	= DEF_R_OBJECTIVE_NONE;
global real R_objective_starting_index = 				DEF_R_OBJECTIVE_NONE;
global real R_objective_completing_index = 			DEF_R_OBJECTIVE_NONE;

global string_id SID_objective_none = 					'NONE';
global string_id SID_objective_last_title	= 		SID_objective_none;



// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: COMPLETE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === f_objective_complete: Completes an objective index if it's the current index
//			r_index = objective index you want to complete
//				[r_index == DEF_R_OBJECTIVE_NONE]; r_index = f_objective_current_index()
//			b_msg = do you want to display the objective complete message
//			b_unblip = do you want to unblip this objective index
script static void f_objective_complete( real r_index, boolean b_msg, boolean b_unblip )
	//dprint( "::: f_objective_complete :::" );
	//inspect( r_index );

	// defaults
	if ( r_index == DEF_R_OBJECTIVE_NONE ) then
		r_index = f_objective_current_index();
	end

	// unblip
	if ( b_unblip ) then
		thread( f_objective_blip(r_index, FALSE, TRUE, 0.0) );
	end

	if ( (f_objective_current_check(r_index)) and (not f_objective_completing_check(r_index)) ) then
		// set completing index
		R_objective_completing_index = r_index;

		// check if this objective is trying to start, kill it		
		if ( f_objective_starting_check(r_index) ) then
			R_objective_starting_index = DEF_R_OBJECTIVE_NONE;
		end
	
		if ( b_msg ) then

			// show new objective complete
			if ( f_objective_completing_check(r_index) and (SID_objective_last_title != SID_objective_none) and (f_objective_starting_check(DEF_R_OBJECTIVE_NONE)) ) then
				cui_hud_set_objective_complete( SID_objective_last_title );
			end

		end
	
		// reset the current index if this is still the objective
		if ( f_objective_current_check(r_index) ) then
			R_objective_current_index = DEF_R_OBJECTIVE_NONE;	
		end
		
	end
	
end
script static void f_objective_complete( real r_index, boolean b_msg )
	f_objective_complete( r_index, b_msg, TRUE );
end


// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: BLIP
// =================================================================================================
// =================================================================================================
// =================================================================================================

// VARIABLES ---------------------------------------------------------------------------------------
global real R_objective_new_blip_delay = 					0.5;
global real R_objective_reminder_delay = 					120.0;

// FUNCTIONS ---------------------------------------------------------------------------------------
// === f_objective_blip: Blips/unblips an objective index and stores information in the global system
//			NOTE: This calls to the f_mission_objective_blip function and then handles global stuff 
//			r_index = objective index you want to blip
//				[r_index == DEF_R_OBJECTIVE_NONE] 
//					[b_blip == TRUE] 	r_index = f_objective_current_index()
//					[b_blip == FALSE] r_index = f_objective_blipped_index()
//			b_blip = TRUE; turn blip on, FALSE; turn blip off
//			b_ignore_objective_current = TRUE; ignores the check to see if this is the current objective index
//	RETURN: [boolean] TRUE; if object was blipped
script static boolean f_objective_blip( real r_index, boolean b_blip, boolean b_ignore_objective_current, real r_delay )
local boolean b_return = FALSE;
	//dprint( "::: f_objective_blip :::" );
	//inspect( r_index );
	
	// defaults
	if ( r_index == DEF_R_OBJECTIVE_NONE ) then
	
		if ( b_blip ) then
			r_index = f_objective_current_index();
		else
			r_index = f_objective_blipped_index();
		end
		
	end
	if ( r_delay < 0.0 ) then
		r_delay = 0.0;
	end
	
	if ( (r_index != DEF_R_OBJECTIVE_NONE) and (b_ignore_objective_current or f_objective_current_check(r_index)) ) then

		if ( r_delay <= 0.0 ) then
			b_return = f_mission_objective_blip( r_index, b_blip );
		else
			f_objective_blip_timer( r_index, b_blip, r_delay );
			b_return = TRUE;
		end

		// call the mission script blip
		if ( b_return ) then
		
			// set the blip index
			if ( b_blip ) then
				R_objective_current_index_blipped = r_index;
			elseif ( f_objective_blipped_check(r_index) ) then
				R_objective_current_index_blipped = DEF_R_OBJECTIVE_NONE;
			end
			
		end

	end

	// return
	b_return;
end
script static boolean f_objective_blip( real r_index, boolean b_blip, boolean b_ignore_objective_current )
	f_objective_blip( r_index, b_blip, b_ignore_objective_current, 0.0 );
end
script static boolean f_objective_blip( real r_index, boolean b_blip )
	f_objective_blip( r_index, b_blip, FALSE, 0.0 );
end

// === f_objective_new_blip_delay: Default blip time for a new objective
script static real f_objective_new_blip_delay()
	R_objective_new_blip_delay;
end
script static void f_objective_new_blip_delay( real r_delay )
	R_objective_new_blip_delay = r_delay;
end

// === f_objective_reminder_blip_delay: Default blip time for when a player is reminder
script static real f_objective_reminder_blip_delay()
	R_objective_reminder_delay;
end
script static void f_objective_reminder_blip_delay( real r_delay )
	R_objective_reminder_delay = r_delay;
end

// === f_objective_blipped_index: returnes the current objective index
script static real f_objective_blipped_index()
	R_objective_current_index_blipped;
end

// === f_objective_blipped_check: returns if an objective index
//			r_index = objective index you want to check is blipped
script static boolean f_objective_blipped_check( real r_index )
	f_objective_blipped_index() == r_index;
end

// === f_objective_blip_timer: Waits for a timer to expire before applying the blip/unblip
//		NOTE: The test will automatically shut down if the current objective ID doesn't match
//			r_index = objective index you want to blip/unblip
//			b_blip = TRUE; turn blip on, FALSE; turn blip off
//			r_time = Time (seconds) to delay before blip/unblip
//	RETURN:  [long] Thread ID for the function
script static long f_objective_blip_timer( real r_index, boolean b_blip, real r_time )
	thread( sys_objective_blip_timer(r_index, b_blip, r_time) );
end

// === f_objective_blip_trigger_players: xxx
//		NOTE: The test will automatically shut down if the current objective ID doesn't match
//			r_index = objective index you want to blip/unblip
//			b_blip = TRUE; turn blip on, FALSE; turn blip off
//			tv_volume = Trigger volume to test for players
//			b_check_all = TRUE; Check if ALL players are in/out the trigger, FALSE, Check if ANY players are in/out the trigger
//			b_check_in = TRUE; Checks if the players are IN the trigger, FALSE, Checks if they are OUT of the trigger
//	RETURN:  [long] Thread ID for the function
script static long f_objective_blip_trigger_players( real r_index, boolean b_blip, trigger_volume tv_volume, boolean b_check_all, boolean b_check_in )
	thread( sys_objective_blip_trigger_players(r_index, b_blip, tv_volume, b_check_all, b_check_in) );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// FUNCTIONS ---------------------------------------------------------------------------------------
script static void sys_objective_blip_timer( real r_index, boolean b_blip, real r_time )
local long l_timer = timer_stamp( r_time );

	sleep_until( timer_expired(l_timer) or (not f_objective_current_check(r_index)), 1 );
	f_objective_blip( r_index, b_blip, FALSE );

end

script static void sys_objective_blip_trigger_players( real r_index, boolean b_blip, trigger_volume tv_volume, boolean b_check_all, boolean b_check_in )

	sleep_until( (((not b_check_all) and (volume_test_players(tv_volume) == b_check_in)) or (volume_test_players_all(tv_volume) == b_check_in)) or (not f_objective_current_check(r_index)), 1 );
	//dprint( "sys_objective_blip_trigger_players" );
	f_objective_blip( r_index, b_blip, (not b_blip) or f_objective_current_check(r_index) );

end

// =================================================================================================
// OBJECTIVES: BLIP: CRUMBS
// =================================================================================================
// FUNCTIONS ---------------------------------------------------------------------------------------
script static long f_objective_blip_crumb_blip( real r_objective_index, real r_id, cutscene_flag flg_location, trigger_volume tv_area )
	thread( sys_objective_blip_crumb_blip(r_objective_index, r_id, flg_location, tv_area) );
end

script static boolean f_b_objective_blip_crumb_current_check( real r_objective_index, real r_id )
	f_objective_current_check( r_objective_index ) and (R_objective_blip_crumb_index_current == r_id);
end

script static void f_objective_blip_crumb_reset()
	R_objective_blip_crumb_index_current = DEF_R_objective_blip_crumb_NONE;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// DEFINES -----------------------------------------------------------------------------------------
global real DEF_R_OBJECTIVE_BLIP_CRUMB_NONE							= 0.0;

// VARIABLES ---------------------------------------------------------------------------------------
global real R_objective_blip_crumb_index_current				= DEF_R_objective_blip_crumb_NONE;
global cutscene_flag FLG_objective_blip_crumb_flag			= FLG_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void sys_objective_blip_crumb_blip( real r_objective_index, real r_id, cutscene_flag flg_location, trigger_volume tv_area )

	local boolean b_blipped = FALSE;

	repeat
		
		if ( f_objective_current_check(r_objective_index) ) then

			if ( (r_id > R_objective_blip_crumb_index_current) and volume_test_players(tv_area) ) then

				R_objective_blip_crumb_index_current = r_id;
				sleep( 2 );

			elseif ( r_id != R_objective_blip_crumb_index_current ) then

				if ( b_blipped ) then
					f_unblip_flag( flg_location );
					b_blipped = FALSE;
				end

				sleep_until( ((r_id > R_objective_blip_crumb_index_current) and volume_test_players(tv_area)) or (not f_objective_current_check(r_objective_index)), 1 );
				if ( f_objective_current_check(r_objective_index) ) then
					R_objective_blip_crumb_index_current = r_id;
				end

			else
			
				if ( not b_blipped ) then
					f_blip_flag( flg_location, "default" );
					b_blipped = TRUE;
				end
				
				sleep_until( (R_objective_blip_crumb_index_current != r_id) or (not f_objective_current_check(r_objective_index)) or (not volume_test_players(tv_area)), 1 );
				if ( (R_objective_blip_crumb_index_current == r_id) and f_objective_current_check(r_objective_index) ) then
					R_objective_blip_crumb_index_current = DEF_R_objective_blip_crumb_NONE;
					sleep_until( (R_objective_blip_crumb_index_current != DEF_R_objective_blip_crumb_NONE) or volume_test_players(tv_area) or (not f_objective_current_check(r_objective_index)), 1 );
				end

			end

		end

	until( not f_objective_current_check(r_objective_index), 1 );
	
	// make sure it's cleaned up
	if ( b_blipped ) then
		f_unblip_flag( flg_location );
		b_blipped = FALSE;
	end
	
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: MISSION COMPLETE
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === f_objective_mission_missioncomplete::: Handles all the general mission complete
script static void f_objective_missioncomplete()
	f_objective_complete( f_objective_current_index(), FALSE, FALSE );
	B_mission_complete = TRUE;
	end_mission();
end

// === f_objective_missioncomplete_check::: Checks if mission complete has been set
script static boolean f_objective_missioncomplete_check()
	// return
	B_mission_complete;
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// VARIABLES ---------------------------------------------------------------------------------------
global boolean B_mission_complete			 					= FALSE;



// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: PAUSE
// =================================================================================================
// =================================================================================================
// =================================================================================================
global short DEF_OBJECTIVE_PAUSE_PRIMARY = 							1;
global short DEF_OBJECTIVE_PAUSE_SECONDARY = 						2;

script static void f_objective_pause_primary_manage( short s_index, string_id sid_string, real r_show_min, real r_show_max, boolean b_complete_manage, real r_complete_min, real r_complete_max, boolean b_fail_manage, real r_fail_min, real r_fail_max, boolean b_complete_or_fail_cancels )
	sys_objective_pause_manage( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index, sid_string, r_show_min, r_show_max, b_complete_manage, r_complete_min, r_complete_max, b_fail_manage, r_fail_min, r_fail_max, b_complete_or_fail_cancels );
end
script static void f_objective_pause_primary_manage( short s_index, string_id sid_string, real r_show_min, real r_show_max, boolean b_complete_manage, real r_complete_min, real r_complete_max, boolean b_fail_manage, real r_fail_min, real r_fail_max )
	f_objective_pause_primary_manage( s_index, sid_string, r_show_min, r_show_max, b_complete_manage, r_complete_min, r_complete_max, b_fail_manage, r_fail_min, r_fail_max, TRUE );
end

script static void f_objective_pause_secondary_manage( short s_index, string_id sid_string, real r_show_min, real r_show_max, boolean b_complete_manage, real r_complete_min, real r_complete_max, boolean b_fail_manage, real r_fail_min, real r_fail_max, boolean b_complete_or_fail_cancels )
	sys_objective_pause_manage( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index, sid_string, r_show_min, r_show_max, b_complete_manage, r_complete_min, r_complete_max, b_fail_manage, r_fail_min, r_fail_max, b_complete_or_fail_cancels );
end
script static void f_objective_pause_secondary_manage( short s_index, string_id sid_string, real r_show_min, real r_show_max, boolean b_complete_manage, real r_complete_min, real r_complete_max, boolean b_fail_manage, real r_fail_min, real r_fail_max )
	f_objective_pause_secondary_manage( s_index, sid_string, r_show_min, r_show_max, b_complete_manage, r_complete_min, r_complete_max, b_fail_manage, r_fail_min, r_fail_max, TRUE );
end

script static void f_objective_pause_primary_set( short s_index, string_id sid_string )
	sys_objective_pause_set( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index, sid_string );
end
script static void f_objective_pause_secondary_set( short s_index, string_id sid_string )
	sys_objective_pause_set( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index, sid_string );
end

script static void f_objective_pause_primary_show( short s_index )
	sys_objective_pause_show( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index );
end
script static void f_objective_pause_secondary_show( short s_index )
	sys_objective_pause_show( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index );
end

script static void f_objective_pause_primary_show_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_show_manage( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index, r_min, r_max );
end
script static void f_objective_pause_secondary_show_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_show_manage( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index, r_min, r_max );
end

script static void f_objective_pause_primary_complete( short s_index )
	sys_objective_pause_complete( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index );
end
script static void f_objective_pause_secondary_complete( short s_index )
	sys_objective_pause_complete( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index );
end

script static void f_objective_pause_primary_complete_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_complete_manage( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index, r_min, r_max );
end
script static void f_objective_pause_secondary_complete_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_complete_manage( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index, r_min, r_max );
end

script static void f_objective_pause_primary_fail( short s_index )
	sys_objective_pause_fail( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index );
end
script static void f_objective_pause_secondary_fail( short s_index )
	sys_objective_pause_fail( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index );
end

script static void f_objective_pause_primary_fail_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_fail_manage( DEF_OBJECTIVE_PAUSE_PRIMARY, s_index, r_min, r_max );
end
script static void f_objective_pause_secondary_fail_manage( short s_index, real r_min, real r_max )
	sys_objective_pause_fail_manage( DEF_OBJECTIVE_PAUSE_SECONDARY, s_index, r_min, r_max );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_objective_pause_manage( short s_type, short s_index, string_id sid_string, real r_show_min, real r_show_max, boolean b_complete_manage, real r_complete_min, real r_complete_max, boolean b_fail_manage, real r_fail_min, real r_fail_max, boolean b_complete_or_fail_cancels )
local long l_show_thread = 0;
	//dprint( "sys_objective_pause_manage" );
	
	// setup
	sys_objective_pause_set( s_type, s_index, sid_string );
	
	// show the objective
	l_show_thread = thread( sys_objective_pause_show_manage(s_type, s_index, r_show_min, r_show_max) );
	sleep_until( not isthreadvalid(l_show_thread), 1 );
	
	// fail and complete
	if ( b_complete_manage or b_fail_manage ) then
		local long l_complete_thread = 0;
		local long l_fail_thread = 0;

		// start complete thread
		if ( b_complete_manage ) then
			l_complete_thread = thread( sys_objective_pause_complete_manage(s_type, s_index, r_complete_min, r_complete_max) );
		end

		// start fail thread
		if ( b_fail_manage ) then
			l_fail_thread = thread( sys_objective_pause_fail_manage(s_type, s_index, r_fail_min, r_fail_max) );
		end
		
		// wait for a success
		sleep_until( ((not isthreadvalid(l_complete_thread)) and (b_complete_manage)) or ((not isthreadvalid(l_fail_thread)) and (b_fail_manage)), 1 );
		
		// check cancel
		if ( b_complete_or_fail_cancels ) then
			kill_thread( l_complete_thread );
			kill_thread( l_fail_thread );
		end

		// wait for all to finish
		if ( isthreadvalid(l_complete_thread) or isthreadvalid(l_fail_thread) ) then
			sleep_until( (not isthreadvalid(l_complete_thread)) and (not isthreadvalid(l_fail_thread)), 1 );
		end

	end
	
end
script static void sys_objective_pause_show_manage( short s_type, short s_index, real r_min, real r_max )

	sleep_until( f_objective_check_range(r_min, r_max), 1 );
	sys_objective_pause_show( s_type, s_index );
	
end
script static void sys_objective_pause_complete_manage( short s_type, short s_index, real r_min, real r_max )

	sleep_until( f_objective_check_range(r_min, r_max), 1 );
	sys_objective_pause_complete( s_type, s_index );
	
end
script static void sys_objective_pause_fail_manage( short s_type, short s_index, real r_min, real r_max )

	sleep_until( f_objective_check_range(r_min, r_max), 1 );
	sys_objective_pause_fail( s_type, s_index );
	
end

script static void sys_objective_pause_set( short s_type, short s_index, string_id sid_string )
	
	if ( s_type == DEF_OBJECTIVE_PAUSE_PRIMARY ) then
		//dprint( "sys_objective_pause_set: PRIMARY" );
		objectives_set_string( s_index, sid_string );
	else
		//dprint( "sys_objective_pause_set: SECONDARY" );
		objectives_secondary_set_string( s_index, sid_string );
	end
	inspect( s_index );
	inspect( sid_string );
	
end
script static void sys_objective_pause_show( short s_type, short s_index )
	//dprint( "sys_objective_pause_show" );

	if ( s_type == DEF_OBJECTIVE_PAUSE_PRIMARY ) then
		//dprint( "sys_objective_pause_show: PRIMARY" );
		objectives_show( s_index );
	else
		//dprint( "sys_objective_pause_show: SECONDARY" );
		objectives_secondary_show( s_index );
	end
	inspect( s_index );
	
end
script static void sys_objective_pause_complete( short s_type, short s_index )
	//dprint( "sys_objective_pause_complete" );

	if ( s_type == DEF_OBJECTIVE_PAUSE_PRIMARY ) then
		//dprint( "sys_objective_pause_complete: PRIMARY" );
		objectives_finish( s_index );
	else
		//dprint( "sys_objective_pause_complete: SECONDARY" );
		objectives_secondary_finish( s_index );
	end
	inspect( s_index );
	
end
script static void sys_objective_pause_fail( short s_type, short s_index )
	//dprint( "sys_objective_pause_fail" );

	if ( s_type == DEF_OBJECTIVE_PAUSE_PRIMARY ) then
		//dprint( "sys_objective_pause_fail: PRIMARY" );
		objectives_unavailable( s_index );
	else
		//dprint( "sys_objective_pause_fail: SECONDARY" );
		objectives_secondary_unavailable( s_index );
	end
	inspect( s_index );
	
end



// =================================================================================================
// =================================================================================================
// =================================================================================================
// OBJECTIVES: CHECK
// =================================================================================================
// =================================================================================================
// =================================================================================================

// FUNCTIONS ---------------------------------------------------------------------------------------
// === f_objective_current_index: returns the current objective index
script static real f_objective_current_index()
	R_objective_current_index;
end

// === f_objective_current_check: returns if the objective index is the current
//			r_index = objective index you want to check is current
script static boolean f_objective_current_check( real r_index )
	f_objective_current_index() == r_index;
end

// === f_objective_check_range: returns true if the current objective is within the range
//			r_index = objective index to check within low/high range
//			r_index_low = low objective index you want to check within
//			r_index_high = high objective index you want to check within
script static boolean f_objective_check_range( real r_index, real r_index_low, real r_index_high )
	( r_index != DEF_R_OBJECTIVE_NONE ) and ((r_index_low <= r_index) or (r_index_low < 0.0)) and ((r_index <= r_index_high) or (r_index_high < 0.0));
end
script static boolean f_objective_check_range( real r_index_low, real r_index_high )
	f_objective_check_range( f_objective_current_index(), r_index_low, r_index_high );
end

// === f_objective_starting_check: returns if the objective index is starting
//			r_index = objective index you want to check is starting
script static boolean f_objective_starting_check( real r_index )
	R_objective_starting_index == r_index;
end

// === f_objective_completing_check: returns if the objective index is completing
//			r_index = objective index you want to check is completing
script static boolean f_objective_completing_check( real r_index )
	R_objective_completing_index == r_index;
end
