//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	SPARTAN OPS: AI
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** SPOPS: BLIP ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

/*
navpoint_default
navpoint_player
navpoint_player_battle_awareness
navpoint_battle_awareness
navpoint_hologram
navpoint_ghost_lock_on
navpoint_locking
navpoint_lock_on
navpoint_airstrike
navpoint_airstrike_locked
navpoint_megalo_default
navpoint_driver
navpoint_passenger
navpoint_passenger_gunner
navpoint_enemy
navpoint_enemy_group
navpoint_enemy_vehicle
navpoint_generic
navpoint_activate
navpoint_ammo
navpoint_goto
navpoint_healthbar
navpoint_neutralize
navpoint_driver
navpoint_passenger
navpoint_passenger_gunner
navpoint_ordnance_drop
navpoint_healthbar_neutralize
navpoint_healthbar_defend
reticule_tracking_default
reticule_locked_on_default
navpoint_random_ordnance_drop
navpoint_defend
navpoint_healthbar_destroy
navpoint_sports_equipment
navpoint_jetpack
navpoint_xray
sticky_detonator_motion_sensor
*/

script static string_id spops_return_blip_type_cui( string str_type )

	static string_id cui_string = "navpoint_goto";

	if str_type == "neutralize" then
		cui_string = "navpoint_neutralize";
	end
	if str_type == "neutralize_health" then
		cui_string = "navpoint_healthbar_neutralize";
	end
	
	// HAX: A,B,C,D need art.
	if str_type == "a" then
		cui_string = "navpoint_goto";
	end
	if str_type == "b" then
		cui_string = "navpoint_goto";
	end
	if str_type == "c" then
		cui_string = "navpoint_goto";
	end
	if str_type == "d" then
		cui_string = "navpoint_goto";
	end
	
	if str_type == "defend" then
		cui_string = "navpoint_defend";
	end
	if str_type == "defend_health" then
		cui_string = "navpoint_healthbar_defend";
	end

	if str_type == "active_camo" then
		cui_string = "navpoint_activecamo";
	end

	if str_type == "destroy" then
		cui_string = "navpoint_destroy";
	end
	if str_type == "destroy_health" then
		cui_string = "navpoint_healthbar_destroy";
	end

	if str_type == "jetpack" then
		cui_string = "navpoint_jetpack";
	end

	if str_type == "ordnance" then
		cui_string = "navpoint_ordnance_drop";
	end
	
	if str_type == "activate" then
		cui_string = "navpoint_activate";
	end
	
	if str_type == "deactivate" then
		cui_string = "navpoint_deactivate";
	end
	
	// HAX: recon needs art
	if str_type == "recon" then
		cui_string = "navpoint_goto";
	end
	
	// HAX: recover needs art
	if str_type == "recover" then
		cui_string = "navpoint_generic";
	end
	
	// HAX: neutralize A,B,C needs art
	if str_type == "neutralize_a" then
		cui_string = "navpoint_neutralize";
	end
	if str_type == "neutralize_b" then
		cui_string = "navpoint_neutralize";
	end
	if str_type == "neutralize_c" then
		cui_string = "navpoint_neutralize";
	end
	
	if str_type == "ammo" then
		cui_string = "navpoint_ammo";
	end
	
	if str_type == "enemy" then
		cui_string = "navpoint_enemy";
	end
	
	if str_type == "enemy_vehicle" then
		cui_string = "navpoint_enemy_vehicle";
	end

	if str_type == "ally" then
		cui_string = "navpoint_ally";
	end
	if str_type == "ally_group" then
		cui_string = "navpoint_ally_group";
	end
	if str_type == "ally_vehicle" then
		cui_string = "navpoint_ally_vehicle";
	end
	
	if str_type == "default" then
		cui_string = "navpoint_goto";
	end
	
	cui_string;
end

// blip a cinematic flag
script static void spops_blip_flag( cutscene_flag flg_flag, boolean b_blip, string str_type, string_id sid_title, real r_offset )
	
	if ( navpoint_is_tracking_flag(flg_flag) != b_blip ) then
	
		if ( b_blip ) then

			// set offset
			if ( r_offset != 0.0 ) then
				navpoint_cutscene_flag_set_vertical_offset( flg_flag, r_offset );
			end
		
			// blip without title
			if ( sid_title == NONE ) then
				navpoint_track_flag_named( flg_flag, spops_return_blip_type_cui(str_type) );
			end
			
			// blip without 
			if ( sid_title != NONE ) then
				navpoint_track_flag_named_with_string( flg_flag, spops_return_blip_type_cui(str_type), sid_title );
			end
			
		else
		
			navpoint_track_flag( flg_flag, FALSE );
			
		end
		
		// play sound
		sound_impulse_start( sfx_blip, NONE, 1 );
		
	end

end
script static void spops_blip_flag( cutscene_flag flg_flag, boolean b_blip, string str_type, string_id sid_title )
	spops_blip_flag( flg_flag, b_blip, str_type, sid_title, 0.0 );
end
script static void spops_blip_flag( cutscene_flag flg_flag, boolean b_blip, string str_type )
	spops_blip_flag( flg_flag, b_blip, str_type, NONE, 0.0 );
end
script static void spops_blip_flag( cutscene_flag flg_flag, boolean b_blip )
	spops_blip_flag( flg_flag, b_blip, "default", NONE, 0.0 );
end
script static void spops_blip_flag( cutscene_flag flg_flag )
	spops_blip_flag( flg_flag, TRUE, "default", NONE, 0.0 );
end

script static void spops_unblip_flag( cutscene_flag flg_flag )
	spops_blip_flag( flg_flag, FALSE, "default", NONE, 0.0 );
end

// blip a cinematic object
script static void spops_blip_object( object obj_object, boolean b_blip, string str_type, string_id sid_title, real r_offset )
	
	if ( navpoint_is_tracking_object(obj_object) != b_blip ) then
	
		if ( b_blip ) then

			// set offset
			if ( r_offset != 0.0 ) then
				navpoint_object_set_vertical_offset( obj_object, r_offset );
			end
		
			// blip without title
			if ( sid_title == NONE ) then
				navpoint_track_object_named( obj_object, spops_return_blip_type_cui(str_type) );
			end
			
			// blip without 
			if ( sid_title != NONE ) then
				navpoint_track_object_named_with_string( obj_object, spops_return_blip_type_cui(str_type), sid_title );
			end
			
		else
		
			navpoint_track_object( obj_object, FALSE );
			
		end
		
		// play sound
		sound_impulse_start( sfx_blip, NONE, 1 );
		
	end

end
script static void spops_blip_object( object obj_object, boolean b_blip, string str_type, string_id sid_title )
	spops_blip_object( obj_object, b_blip, str_type, sid_title, 0.0 );
end
script static void spops_blip_object( object obj_object, boolean b_blip, string str_type )
	spops_blip_object( obj_object, b_blip, str_type, NONE, 0.0 );
end
script static void spops_blip_object( object obj_object, boolean b_blip )
	spops_blip_object( obj_object, b_blip, "default", NONE, 0.0 );
end
script static void spops_blip_object( object obj_object )
	spops_blip_object( obj_object, TRUE, "default", NONE, 0.0 );
end

script static void spops_unblip_object( object obj_object )
	spops_blip_object( obj_object, FALSE, "default", NONE, 0.0 );
end

// blip a object_list
script static void spops_blip_object_list( object_list ol_objects, boolean b_blip, string str_type, string_id sid_title, real r_offset )
local short s_index = list_count( ol_objects ) - 1;

	if ( s_index >= 0 ) then
	
		repeat

			spops_blip_object( list_get(ol_objects,s_index), b_blip, str_type, sid_title, r_offset );
			s_index = s_index - 1;

		until ( s_index < 0, 1 );
		
	end

end
script static void spops_blip_object_list( object_list obj_object_list, boolean b_blip, string str_type, string_id sid_title )
	spops_blip_object_list( obj_object_list, b_blip, str_type, sid_title, 0.0 );
end
script static void spops_blip_object_list( object_list obj_object_list, boolean b_blip, string str_type )
	spops_blip_object_list( obj_object_list, b_blip, str_type, NONE, 0.0 );
end
script static void spops_blip_object_list( object_list obj_object_list, boolean b_blip )
	spops_blip_object_list( obj_object_list, b_blip, "default", NONE, 0.0 );
end
script static void spops_blip_object_list( object_list obj_object_list )
	spops_blip_object_list( obj_object_list, TRUE, "default", NONE, 0.0 );
end

script static void spops_unblip_object_list( object_list obj_object_list )
	spops_blip_object_list( obj_object_list, FALSE, "default", NONE, 0.0 );
end

// blip a ai
script static void spops_blip_ai( ai ai_squad, boolean b_blip, string str_type, string_id sid_title, real r_offset )
	spops_blip_object_list( ai_actors(ai_squad), b_blip, str_type, sid_title, r_offset );
end
script static void spops_blip_ai( ai ai_squad, boolean b_blip, string str_type, string_id sid_title )
	spops_blip_ai( ai_squad, b_blip, str_type, sid_title, 0.0 );
end
script static void spops_blip_ai( ai ai_squad, boolean b_blip, string str_type )
	spops_blip_ai( ai_squad, b_blip, str_type, NONE, 0.0 );
end
script static void spops_blip_ai( ai ai_squad, boolean b_blip )
	spops_blip_ai( ai_squad, b_blip, "default", NONE, 0.0 );
end
script static void spops_blip_ai( ai ai_squad )
	spops_blip_ai( ai_squad, TRUE, "default", NONE, 0.0 );
end

script static void spops_unblip_ai( ai ai_squad )
	spops_blip_ai( ai_squad, FALSE, "default", NONE, 0.0 );
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_thread()
	sleep_until( FALSE );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: FLAG
// -------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_flag( player p_player, cutscene_flag flg_target, string_id sid_type, string_id sid_title, boolean b_blip )
	
	// set blip
	if ( not b_blip ) then
		navpoint_track_flag_for_player( p_player, flg_target, b_blip );
	else
		sleep( 1 );
		if ( sid_title == "" ) then
			navpoint_track_flag_for_player_named( p_player, flg_target, sid_type );
		else
			navpoint_track_flag_for_player_named_with_string( p_player, flg_target, sid_type, sid_title );
		end
	end

end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: FLAG: TRIGGER
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_flag_trigger( cutscene_flag flg_target, string str_type, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, "", 0.0, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_trigger( cutscene_flag flg_target, string str_type, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, "", 0.0, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_title_trigger( cutscene_flag flg_target, string str_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, sid_title, 0.0, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_title_trigger( cutscene_flag flg_target, string str_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, sid_title, 0.0, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_offset_trigger( cutscene_flag flg_target, string str_type, real r_offset, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, "", r_offset, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_offset_trigger( cutscene_flag flg_target, string str_type, real r_offset, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, "", r_offset, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_title_offset_trigger( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_trigger( flg_target, str_type, sid_title, r_offset, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_title_offset_trigger( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_cutscene_flag_set_vertical_offset( flg_target, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_flag_title_offset_trigger(player0, flg_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_trigger(player1, flg_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_trigger(player2, flg_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_trigger(player3, flg_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_flag_title_offset_trigger( player p_player, cutscene_flag flg_target, string_id sid_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in, long l_thread )

	// wait for the player to be in the game
	if ( not player_is_in_game(p_player) ) then
		sleep_until( player_is_in_game(p_player) or (not IsThreadValid(l_thread)), 10 );
	end

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_flag_title_offset_trigger_blip(p_player, flg_target, tv_volume, b_blip_in, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 10 );
	
			// store blip condition
			b_blip = sys_spops_blip_auto_flag_title_offset_trigger_blip( p_player, flg_target, tv_volume, b_blip_in, l_thread );
			
			// blip
			sys_spops_blip_auto_flag( p_player, flg_target, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 6 );
		
	end

end
script static boolean sys_spops_blip_auto_flag_title_offset_trigger_blip( player p_player, cutscene_flag flg_target, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	( volume_test_object(tv_volume, p_player) == b_blip_in ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: FLAG: DISTANCE
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_flag_distance( cutscene_flag flg_target, string str_type, real r_distance, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, "", 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_distance( cutscene_flag flg_target, string str_type, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, "", 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_title_distance( cutscene_flag flg_target, string str_type, string_id sid_title, real r_distance, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, sid_title, 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_title_distance( cutscene_flag flg_target, string str_type, string_id sid_title, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, sid_title, 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_offset_distance( cutscene_flag flg_target, string str_type, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, "", r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_offset_distance( cutscene_flag flg_target, string str_type, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, "", r_offset, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_flag_title_offset_distance( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_flag_title_offset_distance( flg_target, str_type, sid_title, r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_flag_title_offset_distance( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_cutscene_flag_set_vertical_offset( flg_target, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_flag_title_offset_distance(player0, flg_target, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_distance(player1, flg_target, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_distance(player2, flg_target, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_distance(player3, flg_target, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_flag_title_offset_distance( player p_player, cutscene_flag flg_target, string_id sid_type, string_id sid_title, real r_distance, boolean b_blip_in, long l_thread )

	// wait for the player to be in the game
	if ( not player_is_in_game(p_player) ) then
		sleep_until( player_is_in_game(p_player) or (not IsThreadValid(l_thread)), 1 );
	end

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_flag_title_offset_distance_blip(p_player, flg_target, r_distance, b_blip_in, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
	
			// store blip condition
			b_blip = sys_spops_blip_auto_flag_title_offset_distance_blip( p_player, flg_target, r_distance, b_blip_in, l_thread );
			
			// blip
			sys_spops_blip_auto_flag( p_player, flg_target, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 1 );
		
	end

end
script static boolean sys_spops_blip_auto_flag_title_offset_distance_blip( player p_player, cutscene_flag flg_target, real r_distance, boolean b_blip_in, long l_thread )
	( (objects_distance_to_flag(p_player,flg_target) <= r_distance) == b_blip_in ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: FLAG: DISTANCE: TOGGLE
// -------------------------------------------------------------------------------------------------
script static long spops_blip_auto_flag_distance_toggle( cutscene_flag flg_target, string str_type_in, string str_type_out, real r_distance )
	spops_blip_auto_flag_distance_toggle( flg_target, str_type_in, str_type_out, r_distance, 0 );
end
script static long spops_blip_auto_flag_distance_toggle( cutscene_flag flg_target, string str_type_in, string str_type_out, real r_distance, long l_thread )
	l_thread = spops_blip_auto_flag_title_offset_distance( flg_target, str_type_in, "", 0.0, r_distance, TRUE, l_thread );
	l_thread = spops_blip_auto_flag_title_offset_distance( flg_target, str_type_out, "", 0.0, r_distance, FALSE, l_thread );
	l_thread;
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: FLAG: EQUIPMENT
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_flag_equipment( cutscene_flag flg_target, string str_type, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, "", 0.0, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_flag_equipment( cutscene_flag flg_target, string str_type, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, "", 0.0, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_flag_title_equipment( cutscene_flag flg_target, string str_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, sid_title, 0.0, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_flag_title_equipment( cutscene_flag flg_target, string str_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, sid_title, 0.0, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_flag_offset_equipment( cutscene_flag flg_target, string str_type, real r_offset, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, "", r_offset, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_flag_offset_equipment( cutscene_flag flg_target, string str_type, real r_offset, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, "", r_offset, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_flag_title_offset_equipment( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_flag_title_offset_equipment( flg_target, str_type, sid_title, r_offset, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_flag_title_offset_equipment( cutscene_flag flg_target, string str_type, string_id sid_title, real r_offset, object_definition od_equipment, boolean b_blip_has, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_cutscene_flag_set_vertical_offset( flg_target, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_flag_title_offset_equipment(player0, flg_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_equipment(player1, flg_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_equipment(player2, flg_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_flag_title_offset_equipment(player3, flg_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_flag_title_offset_equipment( player p_player, cutscene_flag flg_target, string_id sid_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_flag_title_offset_equipment_blip(p_player, flg_target, od_equipment, b_blip_has, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
			// store blip condition
			b_blip = sys_spops_blip_auto_flag_title_offset_equipment_blip( p_player, flg_target, od_equipment, b_blip_has, l_thread );
			
			// blip
			sys_spops_blip_auto_flag( p_player, flg_target, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 1 );
	
	end

end
script static boolean sys_spops_blip_auto_flag_title_offset_equipment_blip( player p_player, cutscene_flag flg_target, object_definition od_equipment, boolean b_blip_has, long l_thread )
	( unit_has_equipment(p_player,od_equipment) == b_blip_has ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end


// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT
// -------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_object( player p_player, object obj_target, string_id sid_type, string_id sid_title, boolean b_blip )
	
	// set blip
	if ( not b_blip ) then
		navpoint_track_object_for_player( p_player, obj_target, b_blip );
	else
		sleep( 1 );
		if ( sid_title == "" ) then
			navpoint_track_object_for_player_named( p_player, obj_target, sid_type );
		else
			navpoint_track_object_for_player_named_with_string( p_player, obj_target, sid_type, sid_title );
		end
	end

end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: TRIGGER
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_object_trigger( object obj_target, string str_type, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, "", 0.0, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_object_trigger( object obj_target, string str_type, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, "", 0.0, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_title_trigger( object obj_target, string str_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, sid_title, 0.0, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_object_title_trigger( object obj_target, string str_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, sid_title, 0.0, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_offset_trigger( object obj_target, string str_type, real r_offset, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, "", r_offset, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_object_offset_trigger( object obj_target, string str_type, real r_offset, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, "", r_offset, tv_volume, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_title_offset_trigger( object obj_target, string str_type, string_id sid_title, real r_offset, trigger_volume tv_volume, boolean b_blip_in )
	spops_blip_auto_object_title_offset_trigger( obj_target, str_type, sid_title, r_offset, tv_volume, b_blip_in, 0 );
end
script static long spops_blip_auto_object_title_offset_trigger( object obj_target, string str_type, string_id sid_title, real r_offset, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_object_set_vertical_offset( obj_target, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_object_title_offset_trigger(player0, obj_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_trigger(player1, obj_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_trigger(player2, obj_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_trigger(player3, obj_target, sid_type, sid_title, tv_volume, b_blip_in, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_object_title_offset_trigger( player p_player, object obj_target, string_id sid_type, string_id sid_title, trigger_volume tv_volume, boolean b_blip_in, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_object_title_offset_trigger_blip(p_player, obj_target, tv_volume, b_blip_in, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
			// store blip condition
			b_blip = sys_spops_blip_auto_object_title_offset_trigger_blip( p_player, obj_target, tv_volume, b_blip_in, l_thread );
			
			// blip
			sys_spops_blip_auto_object( p_player, obj_target, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 1 );
	
	end

end
script static boolean sys_spops_blip_auto_object_title_offset_trigger_blip( player p_player, object obj_target, trigger_volume tv_volume, boolean b_blip_in, long l_thread )
	( volume_test_object(tv_volume, p_player) == b_blip_in ) and ( obj_target != NONE ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: TRIGGER: TOGGLE
// -------------------------------------------------------------------------------------------------
script static long spops_blip_auto_object_trigger_toggle( object obj_target, string str_type_in, string str_type_out, trigger_volume tv_volume, long l_thread )
	l_thread = spops_blip_auto_object_trigger( obj_target, str_type_in, tv_volume, TRUE, l_thread );
	l_thread = spops_blip_auto_object_trigger( obj_target, str_type_out, tv_volume, FALSE, l_thread );
	l_thread;
end
script static long spops_blip_auto_object_trigger_toggle( object obj_target, string str_type_in, string str_type_out, trigger_volume tv_volume )
	spops_blip_auto_object_trigger_toggle( obj_target, str_type_in, str_type_out, tv_volume, 0 );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: DISTANCE
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_object_distance( object obj_target, string str_type, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, "", 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_distance( object obj_target, string str_type, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, "", 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_title_distance( object obj_target, string str_type, string_id sid_title, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, sid_title, 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_title_distance( object obj_target, string str_type, string_id sid_title, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, sid_title, 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_offset_distance( object obj_target, string str_type, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, "", r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_offset_distance( object obj_target, string str_type, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, "", r_offset, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_title_offset_distance( object obj_target, string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, sid_title, r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_title_offset_distance( object obj_target, string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target, obj_target, str_type, sid_title, r_offset, r_distance, b_blip_in, 0 );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: TARGET: DISTANCE
// -------------------------------------------------------------------------------------------------

script static long spops_blip_auto_object_target_distance( object obj_target_blip, object obj_target_distance, string str_type, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, "", 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_target_distance( object obj_target_blip, object obj_target_distance, string str_type, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, "", 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_target_title_distance( object obj_target_blip, object obj_target_distance, string str_type, string_id sid_title, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, sid_title, 0.0, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_target_title_distance( object obj_target_blip, object obj_target_distance, string str_type, string_id sid_title, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, sid_title, 0.0, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_target_offset_distance( object obj_target_blip, object obj_target_distance, string str_type, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, "", r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_target_offset_distance( object obj_target_blip, object obj_target_distance, string str_type, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, "", r_offset, r_distance, b_blip_in, l_thread );
end

script static long spops_blip_auto_object_target_title_offset_distance( object obj_target_blip, object obj_target_distance, , string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in )
	spops_blip_auto_object_target_title_offset_distance( obj_target_blip, obj_target_distance, str_type, sid_title, r_offset, r_distance, b_blip_in, 0 );
end
script static long spops_blip_auto_object_target_title_offset_distance( object obj_target_blip, object obj_target_distance, string str_type, string_id sid_title, real r_offset, real r_distance, boolean b_blip_in, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_object_set_vertical_offset( obj_target_blip, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_object_target_title_offset_distance(player0, obj_target_blip, obj_target_distance, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_target_title_offset_distance(player1, obj_target_blip, obj_target_distance, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_target_title_offset_distance(player2, obj_target_blip, obj_target_distance, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	thread( sys_spops_blip_auto_object_target_title_offset_distance(player3, obj_target_blip, obj_target_distance, sid_type, sid_title, r_distance, b_blip_in, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_object_target_title_offset_distance( player p_player, object obj_target_blip, object obj_target_distance, string_id sid_type, string_id sid_title, real r_distance, boolean b_blip_in, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_object_title_offset_distance_blip(p_player, obj_target_distance, r_distance, b_blip_in, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
	
			// store blip condition
			b_blip = sys_spops_blip_auto_object_title_offset_distance_blip( p_player, obj_target_distance, r_distance, b_blip_in, l_thread );
			
			// blip
			sys_spops_blip_auto_object( p_player, obj_target_blip, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 1 );
		
	end

end
script static boolean sys_spops_blip_auto_object_title_offset_distance_blip( player p_player, object obj_target, real r_distance, boolean b_blip_in, long l_thread )
	( (objects_distance_to_object(p_player,obj_target) <= r_distance) == b_blip_in ) and ( obj_target != NONE ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: DISTANCE: TOGGLE
// -------------------------------------------------------------------------------------------------
script static long spops_blip_auto_object_distance_toggle( object obj_target, string str_type_in, string str_type_out, real r_distance, long l_thread )
	l_thread = spops_blip_auto_object_title_offset_distance( obj_target, str_type_in, "", 0.0, r_distance, TRUE, l_thread );
	l_thread = spops_blip_auto_object_title_offset_distance( obj_target, str_type_out, "", 0.0, r_distance, FALSE, l_thread );
	l_thread;
end
script static long spops_blip_auto_object_distance_toggle( object obj_target, string str_type_in, string str_type_out, real r_distance )
	spops_blip_auto_object_distance_toggle( obj_target, str_type_in, str_type_out, r_distance, 0 );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: EQUIPMENT
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_object_equipment( object obj_target, string str_type, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, "", 0.0, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_object_equipment( object obj_target, string str_type, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, "", 0.0, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_object_title_equipment( object obj_target, string str_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, sid_title, 0.0, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_object_title_equipment( object obj_target, string str_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, sid_title, 0.0, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_object_offset_equipment( object obj_target, string str_type, real r_offset, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, "", r_offset, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_object_offset_equipment( object obj_target, string str_type, real r_offset, object_definition od_equipment, boolean b_blip_has, long l_thread )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, "", r_offset, od_equipment, b_blip_has, l_thread );
end

script static long spops_blip_auto_object_title_offset_equipment( object obj_target, string str_type, string_id sid_title, real r_offset, object_definition od_equipment, boolean b_blip_has )
	spops_blip_auto_object_title_offset_equipment( obj_target, str_type, sid_title, r_offset, od_equipment, b_blip_has, 0 );
end
script static long spops_blip_auto_object_title_offset_equipment( object obj_target, string str_type, string_id sid_title, real r_offset, object_definition od_equipment, boolean b_blip_has, long l_thread )
	local string_id sid_type = spops_return_blip_type_cui( str_type );
	//inspect( sid_type );

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_object_set_vertical_offset( obj_target, r_offset );
	end

	// setup blip on players
	thread( sys_spops_blip_auto_object_title_offset_equipment(player0, obj_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_equipment(player1, obj_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_equipment(player2, obj_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	thread( sys_spops_blip_auto_object_title_offset_equipment(player3, obj_target, sid_type, sid_title, od_equipment, b_blip_has, l_thread) );
	
	// sound
	sound_impulse_start( sfx_blip, NONE, 1 );
	
	// return
	l_thread;
	
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_object_title_offset_equipment( player p_player, object obj_target, string_id sid_type, string_id sid_title, object_definition od_equipment, boolean b_blip_has, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = false;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_object_title_offset_equipment_blip(p_player, obj_target, od_equipment, b_blip_has, l_thread)) or (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
			// store blip condition
			b_blip = sys_spops_blip_auto_object_title_offset_equipment_blip( p_player, obj_target, od_equipment, b_blip_has, l_thread );
			
			// blip
			sys_spops_blip_auto_object( p_player, obj_target, sid_type, sid_title, b_blip );
		
		until( ((not IsThreadValid(l_thread)) or (not player_is_in_game(p_player))) and (not b_blip), 1 );
	
	end

end
script static boolean sys_spops_blip_auto_object_title_offset_equipment_blip( player p_player, object obj_target, object_definition od_equipment, boolean b_blip_has, long l_thread )
	( unit_has_equipment(p_player,od_equipment) == b_blip_has ) and ( obj_target != NONE ) and IsThreadValid( l_thread ) and player_is_in_game( p_player );
end

// -------------------------------------------------------------------------------------------------
// BLIPS: AUTO: OBJECT: RECENT DAMAGE
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static long spops_blip_auto_object_recent_damage( object obj_target, string str_type, real r_recent_damage, boolean b_blip_damage, long l_thread )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, 0.0, r_recent_damage, b_blip_damage, l_thread );
end
script static long spops_blip_auto_object_recent_damage( object obj_target, string str_type, real r_recent_damage, boolean b_blip_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, 0.0, r_recent_damage, b_blip_damage );
end
script static long spops_blip_auto_object_recent_damage( object obj_target, string str_type, real r_recent_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, 0.0, r_recent_damage );
end
script static long spops_blip_auto_object_recent_damage( object obj_target, string str_type )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, 0.0 );
end

script static long spops_blip_auto_object_title_recent_damage( object obj_target, string str_type, string_id sid_title, real r_recent_damage, boolean b_blip_damage, long l_thread )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, 0.0, r_recent_damage, b_blip_damage, l_thread );
end
script static long spops_blip_auto_object_title_recent_damage( object obj_target, string str_type, string_id sid_title, real r_recent_damage, boolean b_blip_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, 0.0, r_recent_damage, b_blip_damage );
end
script static long spops_blip_auto_object_title_recent_damage( object obj_target, string str_type, string_id sid_title, real r_recent_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, 0.0, r_recent_damage );
end
script static long spops_blip_auto_object_title_recent_damage( object obj_target, string str_type, string_id sid_title )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, 0.0 );
end

script static long spops_blip_auto_object_offset_recent_damage( object obj_target, string str_type, real r_offset, real r_recent_damage, boolean b_blip_damage, long l_thread )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, r_offset, r_recent_damage, b_blip_damage, l_thread );
end
script static long spops_blip_auto_object_offset_recent_damage( object obj_target, string str_type, real r_offset, real r_recent_damage, boolean b_blip_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, r_offset, r_recent_damage, b_blip_damage );
end
script static long spops_blip_auto_object_offset_recent_damage( object obj_target, string str_type, real r_offset, real r_recent_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, r_offset, r_recent_damage );
end
script static long spops_blip_auto_object_offset_recent_damage( object obj_target, string str_type, real r_offset )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, NONE, r_offset );
end

script static long spops_blip_auto_object_title_offset_recent_damage( object obj_target, string str_type, string_id sid_title, real r_offset, real r_recent_damage, boolean b_blip_damage, long l_thread )

	// create a new thread if needed
	if ( l_thread == 0 ) then
		l_thread = thread( sys_spops_blip_auto_thread() );
	end
	
	// adjust offset
	if ( r_offset != 0.0 ) then
		navpoint_object_set_vertical_offset( obj_target, r_offset );
	end
	
	thread( sys_spops_blip_auto_object_recent_damage(obj_target, str_type, sid_title, r_offset, r_recent_damage, b_blip_damage, l_thread) );
	
	// return
	l_thread;
	
end
script static long spops_blip_auto_object_title_offset_recent_damage( object obj_target, string str_type, string_id sid_title, real r_offset, real r_damage, boolean b_blip_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, r_offset, r_damage, b_blip_damage, 0 );
end
script static long spops_blip_auto_object_title_offset_recent_damage( object obj_target, string str_type, string_id sid_title, real r_offset, real r_damage )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, r_offset, r_damage, TRUE, 0 );
end
script static long spops_blip_auto_object_title_offset_recent_damage( object obj_target, string str_type, string_id sid_title, real r_offset )
	spops_blip_auto_object_title_offset_recent_damage( obj_target, str_type, sid_title, r_offset, 0.001, TRUE, 0 );
end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_spops_blip_auto_object_recent_damage( object obj_target, string str_type, string_id sid_title, real r_offset, real r_recent_damage, boolean b_blip_damage, long l_thread )

	if ( IsThreadValid(l_thread) ) then
		local boolean b_blip = FALSE;
	
		repeat
		
			// wait for change
			sleep_until( (b_blip != sys_spops_blip_auto_object_recent_damage_blip(obj_target, r_recent_damage, b_blip_damage, l_thread)) or (not IsThreadValid(l_thread)), 1 );
			
			// store blip condition
			b_blip = sys_spops_blip_auto_object_recent_damage_blip( obj_target, r_recent_damage, b_blip_damage, l_thread );
			
			// blip
			spops_blip_object( obj_target, b_blip, str_type, sid_title, r_offset );
		
		until( ((not IsThreadValid(l_thread)) or (object_get_health(obj_target) <= 0.0)) and (not b_blip), 1 );
	
	end

end
script static boolean sys_spops_blip_auto_object_recent_damage_blip( object obj_target, real r_recent_damage, boolean b_blip_damage, long l_thread )
	( (object_recent_damage(obj_target) >= r_recent_damage) == b_blip_damage ) and ( object_get_health(obj_target) > 0.0 ) and IsThreadValid( l_thread );
end
