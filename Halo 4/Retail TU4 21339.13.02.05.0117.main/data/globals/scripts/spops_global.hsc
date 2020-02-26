//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: DAMAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static real object_recent_damage( object obj_object )
	object_get_recent_body_damage( obj_object ) + object_get_recent_shield_damage( obj_object );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: PLAYER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static short spops_player_living_cnt()
	list_count_not_dead( Players() );
end

// === spops_player_has_equipment: Checks if any player has an equipment
script static boolean spops_player_has_equipment( object_definition od_equipment )
	unit_has_equipment( Player0, od_equipment ) or unit_has_equipment( Player1, od_equipment ) or unit_has_equipment( Player2, od_equipment ) or unit_has_equipment( Player3, od_equipment );
end

// === spops_players_all_have_equipment: Checks if all player have an equipment
script static boolean spops_players_all_have_equipment( object_definition od_equipment )
	f_ability_player_cnt( od_equipment ) == game_coop_player_count();
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: DISTANCE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static real objects_distance_to_players( object_list obj_list )
local real r_distance = -1.0;

	// find nearest player distance
	if ( (unit_get_health(player0) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player0) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player0 );
	end
	if ( (unit_get_health(player1) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player1) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player1 );
	end
	if ( (unit_get_health(player2) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player2) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player2 );
	end
	if ( (unit_get_health(player3) > 0.0) and ((r_distance < 0.0) or (objects_distance_to_object(obj_list,player3) < r_distance)) ) then
		r_distance = objects_distance_to_object( obj_list,player3 );
	end

	r_distance;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: ZONESET ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean spops_zoneset_prepare_and_load( zone_set zs_zoneset )
	//if ( current_zone_set() != zs_zoneset ) then
		prepare_to_switch_to_zone_set( zs_zoneset );
//		sleep_until( not PreparingToSwitchZoneSet() or (current_zone_set() != zs_zoneset), 1 );
		sleep_until( not PreparingToSwitchZoneSet(), 1 );
	//end
	//if ( (current_zone_set() == zs_zoneset) and (current_zone_set_fully_active() != zs_zoneset) ) then
		switch_zone_set( zs_zoneset );
	//end
	
	// return
	current_zone_set_fully_active() == zs_zoneset;
end




/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: LEVELEVENT: QUEUE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static string STR_levelevent_queue_event = "";
static short S_levelevent_queue_cnt = 0;
static short S_levelevent_queue_use_cnt = 0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void levelevent_queue_add( string str_level_event, real r_time_out, short s_use_cnt )
local long l_timer = timer_stamp( r_time_out );

	if ( levelevent_queue_event() != "" ) then
		sleep_until( levelevent_queue_event() == "", 1 );
	end
	
	// set event to watch
	STR_levelevent_queue_event = str_level_event;
	S_levelevent_queue_cnt = s_use_cnt;
	S_levelevent_queue_use_cnt = 0;
	
	if ( S_levelevent_queue_cnt != 0 ) then
	
		// notify until done
		repeat
			NotifyLevel( str_level_event );
		until( (levelevent_queue_event() != str_level_event) or (S_levelevent_queue_cnt == 0) or ((r_time_out >= 0.0) and timer_expired(l_timer)), 1 );
	
		// reset level event
		levelevent_queue_reset( str_level_event );
		
	end

end
script static void levelevent_queue_add( string str_level_event, real r_time_out )
	levelevent_queue_add( str_level_event, r_time_out, -1 );
end
script static void levelevent_queue_add( string str_level_event )
	levelevent_queue_add( str_level_event, -1.0, -1 );
end

script static boolean levelevent_queue_receive( string str_level_event )
local boolean b_received = FALSE;

	if ( (STR_levelevent_queue_event == str_level_event) and (S_levelevent_queue_cnt != 0) ) then
		S_levelevent_queue_cnt = S_levelevent_queue_cnt - 1;
		S_levelevent_queue_use_cnt = S_levelevent_queue_use_cnt + 1;
		b_received = TRUE;
	end
	
	// return
	b_received;
end

script static boolean levelevent_queue_wait( string str_level_event, real r_time_out )
local long l_timer = timer_stamp( r_time_out );
	sleep_until( levelevent_queue_receive(str_level_event) or ((r_time_out >= 0) and timer_expired(l_timer)), 1 );
end
script static boolean levelevent_queue_wait( string str_level_event )
	levelevent_queue_wait( str_level_event, -1.0 );
end

script static void levelevent_queue_reset( string str_level_event )
	if ( STR_levelevent_queue_event == str_level_event ) then
		STR_levelevent_queue_event = "";
	end
end
script static void levelevent_queue_reset()
	levelevent_queue_reset( STR_levelevent_queue_event );
end

script static string levelevent_queue_event()
	STR_levelevent_queue_event;
end

script static short levelevent_queue_cnt()
	S_levelevent_queue_cnt;
end

script static short levelevent_queue_use_cnt()
	S_levelevent_queue_use_cnt;
end
*/