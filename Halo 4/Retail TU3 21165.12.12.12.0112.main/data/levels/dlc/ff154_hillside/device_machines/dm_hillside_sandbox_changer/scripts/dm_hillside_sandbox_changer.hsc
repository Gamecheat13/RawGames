// =================================================================================================
// =================================================================================================
// =================================================================================================
// SANDBOX CHANGER
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// MANAGER
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script startup instanced manager()
local long l_thread = 0;
local short s_team = DEF_EFFECT_TEAM_NONE;
local long l_timer = 0;

	dprint( "SANDBOX CHANGER: manager: START" );

	// initialize power
	device_set_power( this, 0.0 );

	// set animation
	device_set_position_track( this, 'any:on', 0.0 );

	// hide the core by default
	object_hide( obj_core, TRUE );
	
	repeat
	
		// set the initial core scale
		object_set_scale( obj_core, 0.001, 0 );
	
		// object hide by default
		object_hide( this, TRUE );
		object_set_physics( this, FALSE );
	
		// wait for it to be ready
		sleep_until( device_get_power(this) > 0.0 );
		notifylevel( "sandbox_changer_enabled" );
		object_dissolve_from_marker( this, 'phase_in', 'dissolve_in' );
		object_set_physics( this, TRUE );
		sleep_s( 0.85 );
		object_hide( this, FALSE );
		
		// set device as usable
		usable( TRUE );
	
		// intialize the switch
		switch_activate_check();
	
		repeat
		
			sleep_until( (effect_team() != DEF_EFFECT_TEAM_NONE) or (device_get_power(this) <= 0.0) or (effect_team() != core_team()) or core_destroyed(), 1 );
			switch_activate_check();
			
			// effect
			if ( (not core_destroyed()) and (device_get_power(this) > 0.0) ) then
				dprint( "SANDBOX CHANGER: manager: ACTION" );
			
				// check if it needs to be auto auto_deactivated
				//auto_deactivate_check();
			
				s_team = effect_team();
				
				// set core team
				dprint( "SANDBOX CHANGER: manager: SET CORE TEAM" );
				sys_core_team( s_team );
			
				// impulse
				if ( (s_team == effect_team()) and (not core_destroyed()) ) then
					dprint( "SANDBOX CHANGER: manager: IMPULSE" );
					l_thread = thread( impulse(s_team) );
					sleep_until( not isthreadvalid(l_thread) or core_destroyed(), 1 );
				end
				
				// post impulse time
				if ( (s_team == effect_team()) and (not core_destroyed()) ) then
					dprint( "SANDBOX CHANGER: manager: POST IMPULSE" );
					l_timer = timer_stamp( impulse_time_post() );
					sleep_until( timer_expired(l_timer) or (s_team != effect_team()), 1 );
				end
				
			end
		
		until( core_destroyed() or (device_get_power(this) <= 0.0), 1 );
		
		// set device as usable
		usable( FALSE );
		
		// make sure the switch is deactivated
		switch_activate_check();
		
		// notify the core was destroyed
		if ( core_destroyed() ) then
			notifylevel( "sandbox_changer_core_destroyed" );
		end
		
		// force the team to be reset back to NONE to disable any active fx
		dprint( "SANDBOX CHANGER: manager: DESTROY" );
		effect_team( DEF_EFFECT_TEAM_NONE );
		sys_core_team( DEF_EFFECT_TEAM_NONE );
		
		object_dissolve_from_marker( this, 'hard_kill', 'dissolve' );
		sleep_s( 0.85 );
		object_hide( this, TRUE );
		object_hide( obj_core, TRUE );
		notifylevel( "sandbox_changer_disabled" );
		
		if ( not core_destroyed() ) then
			object_destroy( this );
		end
	
	until( core_destroyed(), 1 );

	notifylevel( "sandbox_changer_destroyed" );
	
	// destroy
	object_destroy( this );

end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// EFFECT
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// EFFECT: GROUPS
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
global ai AI_NONE = 											object_get_ai( NONE );
global ai AI_effect_group_enemy = 				AI_NONE;
global ai AI_effect_group_ally = 					AI_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void effect_groups( ai ai_enemy, ai ai_ally )

	dprint( "SANDBOX CHANGER: effect_groups" );
	effect_group_enemy( ai_enemy );
	effect_group_ally( ai_ally );
	
end

script static void effect_group_enemy( ai ai_effect_group )

	if ( AI_effect_group_enemy != ai_effect_group ) then
		dprint( "SANDBOX CHANGER: effect_group_enemy" );
		AI_effect_group_enemy = ai_effect_group;
	end

end
script static ai effect_group_enemy()
	AI_effect_group_enemy;
end

script static void effect_group_ally( ai ai_effect_group )

	if ( AI_effect_group_ally != ai_effect_group ) then
		dprint( "SANDBOX CHANGER: effect_group_ally" );
		AI_effect_group_ally = ai_effect_group;
	end

end
script static ai effect_group_ally()
	AI_effect_group_ally;
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// EFFECT: TEAM
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// DEFINES -----------------------------------------------------------------------------------------
global short DEF_EFFECT_TEAM_NONE = 			0;
global short DEF_EFFECT_TEAM_ENEMY = 			1;
global short DEF_EFFECT_TEAM_ALLY = 			2;

// VARIABLES ---------------------------------------------------------------------------------------
instanced short S_effect_team = 							DEF_EFFECT_TEAM_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void effect_team( short s_val )

	if ( S_effect_team != s_val ) then
		dprint( "SANDBOX CHANGER: effect_team" );
		inspect( s_val );
		S_effect_team = s_val;
		
		if ( S_effect_team == DEF_EFFECT_TEAM_ENEMY ) then
			notifylevel( "sandbox_changer_enemy_activated" );
		end
		if ( S_effect_team == DEF_EFFECT_TEAM_ALLY ) then
			notifylevel( "sandbox_changer_ally_activated" );
		end
		
	end

end
script static instanced short effect_team()
	S_effect_team;
end

script static instanced void effect_team_ally( boolean b_val )
	if ( effect_team_ally() != b_val ) then
		if ( b_val ) then
			effect_team( DEF_EFFECT_TEAM_ALLY );
		end
		if ( (not b_val) and (effect_team() == DEF_EFFECT_TEAM_ALLY) ) then
			effect_team( DEF_EFFECT_TEAM_NONE );
		end
	end
end
script static instanced boolean effect_team_ally()
	S_effect_team == DEF_EFFECT_TEAM_ALLY;
end

script static instanced void effect_team_enemy( boolean b_val )
	if ( effect_team_enemy() != b_val ) then
		if ( b_val ) then
			effect_team( DEF_EFFECT_TEAM_ENEMY );
		end
		if ( (not b_val) and (effect_team() == DEF_EFFECT_TEAM_ENEMY) ) then
			effect_team( DEF_EFFECT_TEAM_NONE );
		end
	end
end
script static instanced boolean effect_team_enemy()
	S_effect_team == DEF_EFFECT_TEAM_ENEMY;
end

script static instanced void effect_team_none( boolean b_val )
	if ( effect_team_none() != b_val ) then
		if ( b_val ) then
			effect_team( DEF_EFFECT_TEAM_NONE );
		end
		if ( (not b_val) and (effect_team() == DEF_EFFECT_TEAM_NONE) ) then
			effect_team( DEF_EFFECT_TEAM_NONE );
		end
	end
end
script static instanced boolean effect_team_none()
	S_effect_team == DEF_EFFECT_TEAM_NONE;
end

// -------------------------------------------------------------------------------------------------
// EFFECT: TEAM: GROUP
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced ai effect_team_group()
local ai ai_group = AI_NONE;

	if ( effect_team() == DEF_EFFECT_TEAM_ENEMY ) then
		ai_group = effect_group_enemy();
	end
	if ( effect_team() == DEF_EFFECT_TEAM_ALLY ) then
		ai_group = effect_group_ally();
	end

	// return
	ai_group;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void impulse( short s_team )
	
	if ( effect_team() != DEF_EFFECT_TEAM_NONE ) then
		local ai ai_group = effect_team_group();
		local long l_timer_start = 0;
		local long l_timer_end = 0;
		local string str_notify_msg = "";
		local long l_thread = GetCurrentThreadID();
	
		dprint( "SANDBOX CHANGER: impulse: START" );
		
		// set notify message
		if ( s_team == DEF_EFFECT_TEAM_ENEMY ) then
			str_notify_msg = "sandbox_changer_enemy_cloaked";
		end
		if ( s_team == DEF_EFFECT_TEAM_ALLY ) then
			str_notify_msg = "sandbox_changer_ally_cloaked";
		end
		
		// trigger the fx
		effect_new_on_object_marker( 'levels\dlc\shared\effects\cloaking_field_device_spawn.effect', this, 'fx_mkr' );
		l_timer_start = game_tick_get();
		l_timer_end = timer_stamp( impulse_time() );

		// impact the players
		if ( s_team == DEF_EFFECT_TEAM_ALLY ) then
			impulse_objlist_index( Players(), 0, 3, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( Players(), 1, 3, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( Players(), 2, 3, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( Players(), 3, 3, l_timer_start, l_timer_end, l_thread, str_notify_msg );
		end
		
		// impact the group
		if ( ai_group != AI_NONE ) then
			local object_list obj_list = ai_actors( ai_group );
			local short s_index_max = list_count( obj_list ) - 1;
			
			// only impacts 20 since that's the squad limit, this can easily be increased
			impulse_objlist_index( obj_list, 0, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 1, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 2, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 3, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 4, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 5, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 6, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 7, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 8, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 9, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 10, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 11, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 12, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 13, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 14, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 15, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 16, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 17, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 18, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 19, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			impulse_objlist_index( obj_list, 20, s_index_max, l_timer_start, l_timer_end, l_thread, str_notify_msg );
			
		end
		
		// wait for the effect to finish or team changes
		sleep_until( timer_expired(l_timer_end) or (s_team != effect_team()), 1 );
		l_timer_end = timer_stamp( impulse_time_active() );
		
		// wait for the effect time to finish
		if ( timer_expired(l_timer_end) ) then
			effect_new_on_object_marker( 'levels\dlc\shared\effects\cloaking_field_device.effect', this, 'fx_mkr' );
			sleep( 1 );
		end

		// kill the spawn effect
		effect_kill_object_marker( 'levels\dlc\shared\effects\cloaking_field_device_spawn.effect', this, 'fx_mkr' );

		sleep_until( timer_expired(l_timer_end) or (s_team != effect_team()), 1 );

		// kill old effect
		effect_kill_object_marker( 'levels\dlc\shared\effects\cloaking_field_device.effect', this, 'fx_mkr' );

		dprint( "SANDBOX CHANGER: impulse: END" );

	end
	
end
script static instanced void impulse_objlist_index( object_list obj_list, short s_index, short s_index_max, long l_timer_start, long l_timer_end, long l_thread, string str_notify_msg )

	if ( s_index <= s_index_max ) then
		dprint( "SANDBOX CHANGER: impulse_objlist_index" );
		thread( impulse_object(unit(list_get(obj_list, s_index)), l_timer_start, l_timer_end, l_thread, str_notify_msg) );
	end
	
end
script static instanced void impulse_object( object obj_object, long l_timer_start, long l_timer_end, long l_thread, string str_notify_msg )
	
	// wait for effect to hit the unit
	dprint( "SANDBOX CHANGER: impulse_object" );
	sleep_until( (not isthreadvalid(l_thread)) or timer_expired(l_timer_end) or (object_get_health(obj_object) <= 0.0) or (objects_distance_to_object(obj_object, obj_core) <= impulse_range_calc(l_timer_start,l_timer_end)), 1 );
	if ( isthreadvalid(l_thread) and (not timer_expired(l_timer_end)) and (object_get_health(obj_object) > 0.0) ) then

		// CAMO ON
		// XXX ignore active camo players
		// unit_has_equipment <unit> <object_definition>
		sys_spops_object_active_camo_inc( obj_object, 1 );
		notifylevel( str_notify_msg );
		sleep_until( (not isthreadvalid(l_thread)) or (object_get_health(obj_object) <= 0.0), 1 );
		// CAMO OFF
		sys_spops_object_active_camo_inc( obj_object, -1 );
		
	end
	
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: RANGE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_range = 						10.0;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_range( real r_val )

	if ( R_impulse_range != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_range" );
		R_impulse_range = r_val;
	end

end
script static real impulse_range()
	R_impulse_range;
end

script static real impulse_range_calc( real r_time_start, real r_time_end )
	R_impulse_range * ( (real(game_tick_get()) - r_time_start) / (r_time_end - r_time_start) );
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: TIME
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_time = 						0.5;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_time( real r_val )

	if ( R_impulse_time != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_time" );
		R_impulse_time = r_val;
	end

end
script static real impulse_time()
	R_impulse_time;
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: TIME: ACTIVE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_time_active = 						7.5;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_time_active( real r_val )

	if ( R_impulse_time_active != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_time_active" );
		R_impulse_time_active = r_val;
	end

end
script static real impulse_time_active()
	R_impulse_time_active;
end

/*
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: TIME: TURN ON
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_time_turn_on = 						0.5;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_time_turn_on( real r_val )

	if ( R_impulse_time_turn_on != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_time_turn_on" );
		R_impulse_time_turn_on = r_val;
	end

end
script static real impulse_time_turn_on()
	R_impulse_time_turn_on;
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: TIME: TURN ON
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_time_turn_off = 						0.5;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_time_turn_off( real r_val )

	if ( R_impulse_time_turn_off != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_time_turn_off" );
		R_impulse_time_turn_off = r_val;
	end

end
script static real impulse_time_turn_off()
	R_impulse_time_turn_off;
end
*/


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// IMPULSE: DELAY: POST
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_impulse_time_post = 						2.5;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void impulse_time_post( real r_val )

	if ( R_impulse_time_post != r_val ) then
		dprint( "SANDBOX CHANGER: impulse_time_post" );
		R_impulse_time_post = r_val;
	end

end
script static real impulse_time_post()
	R_impulse_time_post;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// CORE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
instanced object obj_core = 								object_at_marker( this, 'sphere_pos' );
instanced short S_core_team = 							DEF_EFFECT_TEAM_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced object core()
	obj_core;
end

script static instanced boolean core_destroyed()
	object_get_health( obj_core ) <= 0.0;
end

script static instanced short core_team()
	S_core_team;
end

script static instanced void sys_core_team( short s_team )

	if ( S_core_team != s_team ) then
		local long l_timer = 0;
		
		dprint( "SANDBOX CHANGER: sys_core_team: START" );
		inspect( s_team );
		
		// set core team
		S_core_team = s_team;

		// transition orb color
		if ( s_team == DEF_EFFECT_TEAM_ENEMY ) then
			l_timer = timer_stamp( core_time_transition() );
			object_set_function_variable (obj_core, 'color_change', 0.001, 1);
		end
		if ( s_team == DEF_EFFECT_TEAM_ALLY ) then
			l_timer = timer_stamp( core_time_transition() );
			object_set_function_variable (obj_core, 'color_change', 1.0, 1);
		end

		// activate
		if ( (S_core_team != DEF_EFFECT_TEAM_NONE) and (s_team == effect_team()) and (device_get_position(this) != 1.0) ) then
			dprint( "SANDBOX CHANGER: sys_core_team: ACTIVATE" );
			device_animate_position_relative( this, 1.0, core_time_on(), 0.0, 0.0, TRUE );
			
			object_can_take_damage( obj_core );
			object_hide( obj_core, FALSE );
			object_cannot_die( obj_core, TRUE );
			object_set_scale( obj_core, 1.0, seconds_to_frames(core_time_on() * 0.5) );
			//ACTIVATION SOUND
			Sound_impulse_start( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e7m1_cloakingdevice_activate_mnde843', this, 1.0 );
			
			sleep_until( (device_get_position(this) == 1.0) or (s_team != effect_team()), 1 );
			object_cannot_die( obj_core, FALSE );
		end

		// auto_deactivate
		if ( (S_core_team == DEF_EFFECT_TEAM_NONE) and (s_team == effect_team()) and (device_get_position(this) != 0.0) ) then
			dprint( "SANDBOX CHANGER: sys_core_team: DEACTIVATE" );
			device_animate_position_relative( this, 0.0, core_time_off(), 0.0, 0.0, TRUE );
			
			object_set_scale( obj_core, 0.001, seconds_to_frames(core_time_off() * 0.5) );
			//DEACTIVATION SOUND
			Sound_impulse_start( 'sound\environments\multiplayer\dlc1_hillside\dm\spops_dm_e7m1_cloakingdevice_deactivate_mnde843', this, 1.0 );
			
			sleep_until( (device_get_position(this) == 0.0) or (s_team != effect_team()), 1 );
			object_cannot_take_damage( obj_core );
			object_hide( obj_core, TRUE );
		end
		
		// wait for full transition
		sleep_until( timer_expired(l_timer) or (s_team != effect_team()), 1 );
		dprint( "SANDBOX CHANGER: sys_core_team: END" );

	end

end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// CORE: TIME: ON
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_core_time_on = 						129.0 / 30.0;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void core_time_on( real r_val )

	if ( R_core_time_on != r_val ) then
		dprint( "SANDBOX CHANGER: core_time_on" );
		R_core_time_on = r_val;
	end

end
script static real core_time_on()
	R_core_time_on;
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// CORE: TIME: OFF
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_core_time_off = 						( 129.0 / 30.0 ) * 0.75;

// FUNCTIoffS ---------------------------------------------------------------------------------------
script static void core_time_off( real r_val )

	if ( R_core_time_off != r_val ) then
		dprint( "SANDBOX CHANGER: core_time_off" );
		R_core_time_off = r_val;
	end

end
script static real core_time_off()
	R_core_time_off;
end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// CORE: TIME: TRANSITION
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_core_time_transition = 						0.5;

// FUNCTItransitionS ---------------------------------------------------------------------------------------
script static void core_time_transition( real r_val )

	if ( R_core_time_transition != r_val ) then
		dprint( "SANDBOX CHANGER: core_time_transition" );
		R_core_time_transition = r_val;
	end

end
script static real core_time_transition()
	R_core_time_transition;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// SWITCH
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
instanced device dc_switch = 								device( object_at_marker(this, 'panel_mkr') );

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced device switch()
	dc_switch;
end

script static instanced void switch_activate_check()

	// Can't get player working for now, forcing switch to be deactivated
	device_set_power( dc_switch, 0.0 );
	/*
	device_get_power(this) > 0.0
	
	if ( (effect_team() != DEF_EFFECT_TEAM_ALLY) and (device_get_power(dc_switch) != 1.0) ) then
		dprint( "SANDBOX CHANGER: switch_activate_check: ACTIVATE" );
		device_set_power( dc_switch, 1.0 );
	end
	
	if ( (effect_team() == DEF_EFFECT_TEAM_ALLY) and (device_get_power(dc_switch) != 0.0) ) then
		dprint( "SANDBOX CHANGER: switch_activate_check: DEACTIVATE" );
		device_set_power( dc_switch, 0.0 );
	end
	*/

end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// AUTO DEACTIVATE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void auto_deactivate_check()

	if ( effect_team() != DEF_EFFECT_TEAM_NONE ) then
		local real r_distance = 99999.0;
		local ai ai_group = effect_team_group();

		// get players distance		
		if ( (effect_team() == DEF_EFFECT_TEAM_ALLY) and (list_count_not_dead(Players()) > 0) ) then
			r_distance = objects_distance_to_object( Players(), this );
		end
		
		// get ai group distance
		if ( ai_living_count(ai_group) > 0 ) then
			r_distance = lower_r( r_distance, objects_distance_to_object(ai_actors(ai_group), this) );
		end
		
		// set auto auto_deactivate
		if ( r_distance >= auto_deactivate_distance() ) then
			effect_team( DEF_EFFECT_TEAM_NONE );
		end

	end

end


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// AUTO DEACTIVATE: DISTANCE: ALLY
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
static real R_auto_deactivate_distance = 						50.0;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static void auto_deactivate_distance( real r_val )

	if ( R_auto_deactivate_distance != r_val ) then
		dprint( "SANDBOX CHANGER: auto_deactivate_distance" );
		R_auto_deactivate_distance = r_val;
	end

end
script static real auto_deactivate_distance()
	R_auto_deactivate_distance;
end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// USE
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
instanced boolean B_usable = 								FALSE;
instanced ai AI_using = 										AI_NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void usable( boolean b_val )

	if ( B_usable != b_val ) then
		dprint( "SANDBOX CHANGER: usable" );
		B_usable = b_val;
	end

end
script static instanced boolean usable()
	B_usable;
end

script static instanced void user_ai( ai ai_users )

	if ( AI_using != ai_users ) then
		dprint( "SANDBOX CHANGER: user_ai" );
		AI_using = ai_users;
	end

end
script static instanced ai user_ai()
	AI_using;
end

script static instanced boolean use_check_enemy( real r_player_distance )
	B_usable and ( not effect_team_enemy() ) and ( not core_destroyed() ) and ( (ai_living_count(AI_using) > 0) or (objects_distance_to_object(Players(), this) >= r_player_distance) );
end
