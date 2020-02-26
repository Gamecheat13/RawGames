//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_pelican_seat_cnt::: XXX
// XXX document params
script static short spops_pelican_seat_cnt( vehicle vh_pelican, string str_seat )
local short s_cnt = 0;

	if ( (str_seat == "ALL") or (str_seat == "TOGGLE") or (str_seat == "UNITS") or (str_seat == "UNITS_LEFT") ) then
		s_cnt = s_cnt + 5;
	end

	if ( (str_seat == "ALL") or (str_seat == "TOGGLE") or (str_seat == "UNITS") or (str_seat == "UNITS_RIGHT") ) then
		s_cnt = s_cnt + 5;
	end

	if ( (str_seat == "ALL") or (str_seat == "CARGO") ) then
		s_cnt = s_cnt + 1;
	end

	// return
	s_cnt;
end
/*
// === spops_pelican_seat_occupied_cnt::: XXX
// XXX document params
script static short spops_pelican_seat_occupied_cnt( vehicle vh_pelican, string str_seat )
local short s_cnt = 0;

	if( object_get_health(vh_pelican) > 0.0 ) then

		if ( (str_seat == "ALL") or (str_seat == "UNITS") or (str_seat == "UNITS_LEFT") ) then
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_l01", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_l02", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_l03", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_l04", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_l05", s_cnt );
		end
	
		if ( (str_seat == "ALL") or (str_seat == "UNITS") or (str_seat == "UNITS_RIGHT") ) then
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_r01", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_r02", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_r03", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_r04", s_cnt );
			s_cnt = sys_spops_vehicle_seat_occupied_cnt( vh_pelican, "pelican_p_r05", s_cnt );
		end
	
		if ( (str_seat == "ALL") or (str_seat == "CARGO") ) then
			s_cnt = sys_spops_vehicle_cargo_occupied_cnt( vh_pelican, "pelican_sc_01", s_cnt );
		end

	end

	// return
	s_cnt;
end
*/

/*
// === spops_pelican_seat_unoccupied_cnt::: XXX
// XXX document params
script static short spops_pelican_seat_unoccupied_cnt( vehicle vh_pelican, string str_seat )
	spops_pelican_seat_cnt( vh_pelican, str_seat ) - spops_pelican_seat_occupied_cnt( vh_pelican, str_seat );
end
*/

/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN: LOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_pelican_load_ai::: XXX
// XXX document params
script static short spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad, string str_seat, string str_seat_toggle_override )
local short s_loaded_cnt = 0;
static string str_seat_toggle = "UNITS_LEFT";
	//dprint( "spops_pelican_load" );
	//dprint( str_seat );

	// check for toggle override
	if ( str_seat_toggle_override != "" ) then
		str_seat_toggle = str_seat_toggle_override;
	end
	
	if ( (vh_pelican != NONE) and (ai_squad != NONE) and (spops_pelican_seat_unoccupied_cnt(vh_pelican, str_seat) > 0) ) then
		local boolean b_placed = FALSE;
	
		// place if not placed
		if ( ai_living_count(ai_squad) <= 0 ) then
			ai_place_in_limbo( ai_squad );
			b_placed = TRUE;
		end

		if ( ai_living_count(ai_squad) > 0 ) then
			local string s_seat_load = str_seat;
			local object_list ol_actors = ai_actors( ai_squad );
			local short s_actor_index = list_count( ol_actors ) - 1;
			local boolean b_loaded = FALSE;
			local ai ai_load = NONE;
			local object obj_load = NONE;

			repeat
			
				// check if there's a seat that can be loaded into
				if ( spops_pelican_seat_unoccupied_cnt(vh_pelican, str_seat) > 0 ) then

					// check if it's toggle and... toggle
					if ( s_seat_load == "TOGGLE" ) then
						//dprint( "spops_pelican_load: TOGGLE" );
					
						// get current set toggle
						s_seat_load = str_seat_toggle;
						//dprint( s_seat_load );
						
						// toggle seats
						if ( str_seat_toggle == "UNITS_RIGHT" ) then
							str_seat_toggle = "UNITS_LEFT";
						else
							str_seat_toggle = "UNITS_RIGHT";
						end
						
					end

					// load
					b_loaded = FALSE;
					obj_load = list_get( ol_actors, s_actor_index );
					if ( s_seat_load == "UNITS_LEFT" ) then
						//dprint( "spops_pelican_load: UNITS_LEFT" );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_l01", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_l02", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_l03", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_l04", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_l05", NONE );
					end
					if ( s_seat_load == "UNITS_RIGHT" ) then
						//dprint( "spops_pelican_load: UNITS_RIGHT" );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_r01", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_r02", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_r03", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_r04", NONE );
						b_loaded = sys_spops_vehicle_load_seat( b_loaded, vh_pelican, obj_load, "pelican_p_r05", NONE );
					end
					if ( s_seat_load == "CARGO" ) then
						//dprint( "spops_pelican_load: CARGO" );
						b_loaded = spops_pelican_load_cargo( vh_pelican, obj_load );
					end

					// increment cnt if loaded
					if ( b_loaded ) then
						s_loaded_cnt = s_loaded_cnt + 1;
						s_actor_index = s_actor_index - 1;
					end

				end

			until( (s_actor_index < 0) or (spops_pelican_seat_unoccupied_cnt(vh_pelican, str_seat) <= 0), 1 );

			// check if any need to be cleaned up
			if ( b_placed and (s_actor_index >= 0) ) then
				repeat
					ai_erase( object_get_ai(list_get(ol_actors, s_actor_index)) );
					s_actor_index = s_actor_index - 1;
				until( s_actor_index < 0, 1 );
			end

		end

	end
	
	// return
	s_loaded_cnt;
end
script static short spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad, string str_seat )
	spops_pelican_load_ai( vh_pelican, ai_squad, str_seat, "" );
end
script static short spops_pelican_load_ai( vehicle vh_pelican, ai ai_squad )
	spops_pelican_load_ai( vh_pelican, ai_squad, "TOGGLE", "" );
end

// === spops_vehicle_load_seat::: XXX
// XXX document params
script static boolean spops_pelican_load_cargo( vehicle vh_pelican, object obj_load )
	//dprint( "spops_pelican_load_cargo" );
	spops_vehicle_load_seat( vh_pelican, obj_load, "pelican_lc", "pelican_sc_01" );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PELICAN: UNLOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_spops_pelican_unload_unit_delay_default = 0.25;
static real R_spops_pelican_unload_cargo_delay_default = 0.25;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === spops_pelican_unload::: XXX
// XXX document params
script static void spops_pelican_unload( vehicle vh_pelican, string str_seat, real r_delay, short s_cnt )
local boolean b_unload_units = ( str_seat == "ALL" ) or ( str_seat == "UNITS" ) or ( str_seat == "LEFT" ) or ( str_seat == "RIGHT" );
local long l_thread_left = 0;
local long l_thread_right = 0;
local long l_thread_cargo = 0;
local long l_timer = 0;
local boolean b_door_open = FALSE;

	if ( b_unload_units ) then
		//dprint( "spops_pelican_unload: OPEN" );
		if ( not unit_is_playing_custom_animation(vh_pelican) ) then
			b_door_open = TRUE;
			//custom_animation_hold_last_frame( vh_pelican, "objects\vehicles\human\storm_pelican\storm_pelican.model_animation_graph", "vehicle:door_open_close", FALSE );
			//sleep( 47 );
		end
	end

	if ( (str_seat == "ALL") or (str_seat == "UNITS") or (str_seat == "UNITS_LEFT") ) then
		l_thread_left = thread( spops_pelican_unload_units_left(vh_pelican, r_delay) );
	end

	if ( (str_seat == "ALL") or (str_seat == "UNITS") or (str_seat == "UNITS_RIGHT") ) then
		l_thread_right = thread( spops_pelican_unload_units_right(vh_pelican, r_delay) );
	end

	if ( (str_seat == "ALL") or (str_seat == "CARGO") ) then
		l_thread_cargo = thread( spops_pelican_unload_cargo(vh_pelican, r_delay) );
	end

	// wait until they are all unloaded
	sleep_until( (not isthreadvalid(l_thread_left)) and (not isthreadvalid(l_thread_right)) and (not isthreadvalid(l_thread_cargo)), 1 );

	if ( b_unload_units and b_door_open ) then
		//dprint( "spops_pelican_unload: CLOSE" );
		// hook up door close
		sleep_s( 2.0 );
	end

end
script static void spops_pelican_unload( vehicle vh_pelican, string str_seat, real r_delay )
	spops_pelican_unload( vh_pelican, str_seat, -1.0, -1 );
end
script static void spops_pelican_unload( vehicle vh_pelican, string str_seat )
	spops_pelican_unload( vh_pelican, str_seat, -1.0, -1 );
end
script static void spops_pelican_unload( vehicle vh_pelican )
	spops_pelican_unload( vh_pelican, "ALL", -1.0, -1 );
end

// === spops_pelican_unload_units_left::: XXX
// XXX document params
script static void spops_pelican_unload_units_left( vehicle vh_pelican, real r_delay )
	//dprint( "spops_pelican_unload_units_left" );

	begin_random
		spops_pelican_unload_seat( vh_pelican, "pelican_p_l01", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_l02", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_l03", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_l04", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_l05", r_delay );
	end

end

// === spops_pelican_unload_units_right::: XXX
// XXX document params
script static void spops_pelican_unload_units_right( vehicle vh_pelican, real r_delay )
	//dprint( "spops_pelican_unload_units_right" );

	begin_random
		spops_pelican_unload_seat( vh_pelican, "pelican_p_r01", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_r02", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_r03", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_r04", r_delay );
		spops_pelican_unload_seat( vh_pelican, "pelican_p_r05", r_delay );
	end

end

// === spops_pelican_unload_cargo::: XXX
// XXX document params
script static void spops_pelican_unload_cargo( vehicle vh_pelican, real r_delay )
	//dprint( "spops_pelican_unload_cargo" );

	spops_pelican_unload_seat( vh_pelican, "pelican_lc", r_delay );

end

// === spops_pelican_unload_seat::: XXX
// XXX document params
script static void spops_pelican_unload_seat( vehicle vh_pelican, unit_seat_mapping usm_seat, real r_delay )

	if ( vehicle_test_seat(vh_pelican, usm_seat) ) then

		vehicle_unload( vh_pelican, usm_seat );
		sleep_s( r_delay );

	end

end

// === spops_pelican_unload_unit_delay_default::: xxx
// XXX document params
script static void spops_pelican_unload_unit_delay_default( real r_delay )

	if ( r_delay != R_spops_pelican_unload_unit_delay_default ) then

		//dprint( "spops_ai_morale_ally_player_distance_default:" );
		//inspect( r_delay );
		R_spops_pelican_unload_unit_delay_default = r_delay;

	end

end
script static real spops_pelican_unload_unit_delay_default()
	R_spops_pelican_unload_unit_delay_default;
end
*/