//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// Mission: 					m80_delta
// Insertion Points:	to airlock one	(or ita1)
// Insertion Points:	airlock one 		(or ia1)
// Insertion Points:	to airlock one	(or ita2)
// Insertion Points:	airlock two 		(or ia2)
//									
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** AIRLOCKS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_airlock_waiting_idle_change_chance = 				37.5;
global real R_airlock_waiting_idle_change_chance_seen = 	62.5;
global real R_airlock_waiting_idle_change_chance_angle = 	15.0;
global real R_airlock_waiting_idle_repeat_chance = 				17.5;
global real R_airlock_loading_timeout_time = 							15.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_startup::: Startup
script startup f_airlocks_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_airlocks_startup :::" );

	// init airlocks
	wake( f_airlocks_init );

end

// === f_airlocks_init::: Initialize
script dormant f_airlocks_init()
	//dprint( "::: f_airlocks_init :::" );
	
	// init modules
	wake( f_airlocks_one_init );
	wake( f_airlocks_two_init );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: CURRENT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_airlock_current_index = 										0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_current_index_set::: Set
script static void f_airlocks_current_index_set( short s_index )
	//dprint( "::: f_airlocks_current_index_set :::" );
	if ( S_airlock_current_index != s_index ) then
		S_airlock_current_index = s_index;
		//inspect( s_index );
	end
end

// === f_airlocks_current_index_get::: Get
script static short f_airlocks_current_index_get()
	S_airlock_current_index;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: STATE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_S_AIRLOCK_STATE_INIT = 									0;
global short DEF_S_AIRLOCK_STATE_DEFAULT = 								1;
global short DEF_S_AIRLOCK_STATE_OUTER_OPEN = 						2;
global short DEF_S_AIRLOCK_STATE_LOAD_AI = 								3;
global short DEF_S_AIRLOCK_STATE_OUTER_CLOSE = 						4;
global short DEF_S_AIRLOCK_STATE_EJECT = 									6;
global short DEF_S_AIRLOCK_STATE_INNER_OPEN = 						7;
global short DEF_S_AIRLOCK_STATE_INNER_OPEN_IMMEDIATE = 	8;
global short DEF_S_AIRLOCK_STATE_RESET = 									9;
global short DEF_S_AIRLOCK_STATE_COMPLETE = 							10;

global real DEF_R_AIRLOCK_DOOR_OUTER_OPEN_TIME =					2.25;
global real DEF_R_AIRLOCK_DOOR_OUTER_EJECT_TIME =					1.5;
global real DEF_R_AIRLOCK_DOOR_OUTER_CLOSE_TIME =					2.5;
global real DEF_R_AIRLOCK_DOOR_INNER_OPEN_TIME =					2.0;
global real DEF_R_AIRLOCK_DOOR_INNER_CLOSE_TIME =					2.5;

global real DEF_R_AIRLOCK_DOOR_POS_OPEN_ENOUGH = 					0.50;
global real DEF_R_AIRLOCK_DOOR_POS_VACUUM = 							0.875;
//global real DEF_R_AIRLOCK_DOOR_POS_VACUUM = 							0.750;
global real DEF_R_AIRLOCK_EJECT_TIMER	= 									0.4375;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_state_set::: Set
script static void f_airlocks_state_set( short s_airlock_id, short s_bay_id, short s_state )
	//dprint( "::: f_airlocks_state_set :::" );

	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) != s_state ) then
	
		if ( s_airlock_id == 1 ) then
			f_airlocks_one_state_set( s_bay_id, s_state );
		else
			f_airlocks_two_state_set( s_bay_id, s_state );
		end
	end

end

// === f_airlocks_state_get::: Get
script static short f_airlocks_state_get( short s_airlock_id, short s_bay_id )
local short s_return = DEF_S_AIRLOCK_STATE_INIT;

	if ( s_airlock_id == 1 ) then
		s_return = f_airlocks_one_state_get( s_bay_id );
	else
		s_return = f_airlocks_two_state_get( s_bay_id );
	end

	// return
	s_return;
end

// === f_airlocks_state_get::: Get
script static object_name f_airlocks_door_inner_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_door_inner_get( s_bay_id );
	else
		f_airlocks_two_door_inner_get( s_bay_id );
	end

end

// === f_airlocks_button_get::: Get
script static object_name f_airlocks_button_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_button_get( s_bay_id );
	else
		f_airlocks_two_button_get( s_bay_id );
	end

end

// === f_airlocks_gravity_get::: Get
script static object_name f_airlocks_gravity_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_gravity_get( s_bay_id );
	else
		f_airlocks_two_gravity_get( s_bay_id );
	end

end

// === f_airlocks_vacuum_get::: Get
script static object_name f_airlocks_vacuum_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_vacuum_get( s_bay_id );
	else
		f_airlocks_two_vacuum_get( s_bay_id );
	end

end

// === f_airlocks_state_get::: Get
script static object_name f_airlocks_door_outer_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_door_outer_get( s_bay_id );
	else
		f_airlocks_two_door_outer_get( s_bay_id );
	end

end

// === f_airlocks_bay_volume_get::: Get
script static trigger_volume f_airlocks_bay_volume_get( short s_airlock_id, short s_bay_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_bay_volume_get( s_bay_id );
	else
		f_airlocks_two_bay_volume_get( s_bay_id );
	end

end

// === f_airlocks_bay_volume_get::: Get
script static trigger_volume f_airlocks_eject_kill_volume_get( short s_airlock_id )

	if ( s_airlock_id == 1 ) then
		f_airlocks_one_eject_kill_volume_get();
	else
		f_airlocks_two_eject_kill_volume_get();
	end

end

script static boolean f_airlock_state_defend( short s_state )
	( DEF_S_AIRLOCK_STATE_LOAD_AI <= s_state ) and ( s_state <= DEF_S_AIRLOCK_STATE_INNER_OPEN );
end

script static void f_airlock_ai_berzerk( object obj_berzerker, trigger_volume tv_airlock )
local ai ai_berzerker = object_get_ai( obj_berzerker );
local long l_timer = 0;

	//dprint( "f_airlock_ai_berzerk" );
	// wait for first berzerk
	sleep_until( (volume_test_object(tv_airlock,obj_berzerker) == FALSE) or (object_get_recent_body_damage(obj_berzerker) > 0.0), 1 );

	// BERZERKER!!!	
	repeat

		// face player
		if ( (object_get_recent_body_damage(obj_berzerker) <= 0.0) and (objects_distance_to_object(Players(),obj_berzerker) >= 2.25) ) then
			cs_face_player( ai_berzerker, TRUE );
			l_timer = timer_stamp( 0.75 );
			sleep_until( timer_expired(l_timer) or (object_get_recent_body_damage(obj_berzerker) > 0.0) or (objects_distance_to_object(Players(),obj_berzerker) <= 2.00), 1 );
			cs_face_player( ai_berzerker, FALSE );
		end

		ai_berserk( ai_berzerker, TRUE );
		l_timer = timer_stamp( 2.0 );
		sleep_until( unit_has_weapon_readied(ai_berzerker, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") or timer_expired(l_timer), 1 );
		dprint( "f_airlock_ai_berzerk: BERZERKER" ); 
	
		// wait for near
		sleep_until( (unit_get_health(ai_berzerker) <= 0.0) or (objects_distance_to_object(Players(),obj_berzerker) <= 2.00) or (not unit_has_weapon_readied(ai_berzerker, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon")), 1 );
		dprint( "f_airlock_ai_berzerk: NEAR/RESET" );

		// min time before re-berzerk
		//if ( unit_has_weapon_readied(ai_berzerker, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") ) then
			l_timer = timer_stamp( 5.0, 7.5 );
		//end

		// now far again
		sleep_until( (unit_get_health(ai_berzerker) <= 0.0) or (((objects_distance_to_object(Players(),obj_berzerker) >= 3.50) or (unit_get_shield(ai_berzerker) >= 0.50)) and timer_expired(l_timer) and (not unit_has_weapon_readied(ai_berzerker, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon"))), 1 );
		dprint( "f_airlock_ai_berzerk: FAR/RESET" ); 

	until ( unit_get_health(ai_berzerker) <= 0.0, 1 );
	//dprint( "f_airlock_ai_berzerk: BERSERKER!!!" );
end

script command_script cs_active_camo_use()
	if ( unit_has_equipment(ai_current_actor, "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		dprint( "cs_active_camo_use: ENABLED" );
		thread( f_active_camo_manager(ai_current_actor) );
	end
end

script static void f_active_camo_manager( ai ai_actor )
local long l_timer = 0;
local object obj_actor = ai_get_object( ai_actor );
	dprint( "cs_active_camo_use: ENABLED" );

	repeat
	
		// activate camo
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, TRUE );
			dprint( "f_active_camo_manager: ACTIVE" ); 
		end
		
		// disable camo
		sleep_until( (unit_get_health(ai_actor) <= 0.0) or (objects_distance_to_object(Players(),obj_actor) <= 3.00) or ((object_get_recent_body_damage(obj_actor) + object_get_recent_shield_damage(obj_actor)) > 0.1), 1 );
		if ( unit_get_health(ai_actor) > 0.0 ) then
			ai_set_active_camo( ai_actor, FALSE );
			dprint( "f_active_camo_manager: DISABLED" ); 
		end
		
		// manage resetting
		if ( unit_get_health(ai_actor) > 0.0 ) then
			l_timer = timer_stamp( 5.0, 10.0 );
			sleep_until( (unit_get_health(ai_actor) <= 0.0) or (timer_expired(l_timer) and unit_has_weapon_readied(ai_actor, "objects\weapons\melee\storm_energy_sword\storm_energy_sword.weapon") and (objects_distance_to_object(Players(),obj_actor) >= 4.0) and (not objects_can_see_object(Players(),obj_actor,25.0))), 1 );
		end
		if ( unit_get_health(ai_actor) > 0.0 ) then
			dprint( "f_active_camo_manager: RESET" ); 
		end
	
	until ( unit_get_health(ai_actor) <= 0.0, 1 );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_setup::: Sets up an airlock
script static void f_airlocks_bay_manage( short s_airlock_id, short s_bay_id, short s_state_start, short s_state_end, ai ai_squad, real r_door_inner_pad_time, cutscene_flag flg_fx_loc_01, cutscene_flag flg_fx_loc_02, cutscene_flag flg_fx_loc_03 )
local object_name obj_door_outer = f_airlocks_door_outer_get( s_airlock_id, s_bay_id );
local object_name obj_door_inner = f_airlocks_door_inner_get( s_airlock_id, s_bay_id );
local object_name obj_door_button = f_airlocks_button_get( s_airlock_id, s_bay_id );

local trigger_volume tv_bay_area = f_airlocks_bay_volume_get( s_airlock_id, s_bay_id );

//local object_name obj_gravity = f_airlocks_gravity_get( s_airlock_id, s_bay_id );
local object_name obj_vacuum = f_airlocks_vacuum_get( s_airlock_id, s_bay_id );

	local short s_state = DEF_S_AIRLOCK_STATE_INIT;
	local long l_button_thread = 0;

	//dprint( "::: f_airlocks_bay_manage: START :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );
	
	// reset to init
	f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_INIT );
	
	// manate states
	repeat
		
		// store state
		s_state = f_airlocks_state_get( s_airlock_id, s_bay_id );

		if ( s_state == DEF_S_AIRLOCK_STATE_INIT ) then
			sys_airlocks_bay_state_init( s_airlock_id, s_bay_id, s_state_start, obj_door_outer, obj_door_inner, obj_door_button, obj_vacuum );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_DEFAULT ) then
			sys_airlocks_bay_state_default( s_airlock_id, s_bay_id, obj_door_outer );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_OUTER_OPEN ) then
			sys_airlocks_bay_state_outer_open( s_airlock_id, s_bay_id, ai_squad, flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03, obj_door_outer, obj_door_button );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_LOAD_AI ) then
			sys_airlocks_bay_state_ai_load( s_airlock_id, s_bay_id, ai_squad, tv_bay_area );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_OUTER_CLOSE ) then
			sys_airlocks_bay_state_outer_close( s_airlock_id, s_bay_id, ai_squad, obj_door_outer, tv_bay_area );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then
			sys_airlocks_bay_state_inner_open( s_airlock_id, s_bay_id, s_state_end, r_door_inner_pad_time, flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03, obj_door_inner, obj_door_button );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_INNER_OPEN_IMMEDIATE ) then
			sys_airlocks_bay_state_inner_open_immediate( s_airlock_id, s_bay_id, s_state_end, obj_door_inner );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_EJECT ) then
			sys_airlocks_bay_state_eject( s_airlock_id, s_bay_id, s_state_end, ai_squad, flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03, obj_door_outer, obj_door_button, tv_bay_area, obj_vacuum );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_RESET ) then
			sys_airlocks_bay_state_reset( s_airlock_id, s_bay_id, s_state_end, obj_door_inner, tv_bay_area );
		end
		if ( s_state == DEF_S_AIRLOCK_STATE_COMPLETE ) then
			sys_airlocks_bay_state_complete( s_airlock_id, s_bay_id );
		end
		
		// wait for change
		sleep_until( (s_state != f_airlocks_state_get(s_airlock_id, s_bay_id)) or (s_airlock_id != f_airlocks_current_index_get()) or (s_state == DEF_S_AIRLOCK_STATE_RESET) or (s_state == DEF_S_AIRLOCK_STATE_COMPLETE), 1 );
	until( s_airlock_id != f_airlocks_current_index_get() or (s_state == DEF_S_AIRLOCK_STATE_RESET) or (s_state == DEF_S_AIRLOCK_STATE_COMPLETE), 1 );

	//dprint( "::: f_airlocks_bay_manage: END :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: INIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_init::: Manage state
script static void sys_airlocks_bay_state_init( short s_airlock_id, short s_bay_id, short s_state_start, object_name obj_door_outer, object_name obj_door_inner, object_name obj_door_button, object_name obj_vacuum )
	
	//dprint( "::: sys_airlocks_bay_state_init :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// setup inner door
	sleep_until( object_valid(obj_door_inner), 1 );
	device_operates_automatically_set( device(obj_door_inner), FALSE );
	device_closes_automatically_set( device(obj_door_inner), FALSE );
	device_set_position( device(obj_door_inner), 0.0 );
	device_set_power( device(obj_door_inner), 0.0 );

	// setup button
	sleep_until( object_valid(obj_door_button), 1 );
	
	// power off, etc. before attach
	device_set_power( device(obj_door_button), 0.0 );
	device_set_position_immediate( device(obj_door_button), 1.0 );
	// attach to door
	objects_attach( obj_door_inner, "button", obj_door_button, "unsc_button_marker" );
	// power and position defaults
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, obj_door_button );

	// setup outer door
	sleep_until( object_valid(obj_door_outer), 1 );
	device_operates_automatically_set( device(obj_door_outer), FALSE );
	device_closes_automatically_set( device(obj_door_outer), FALSE );
	device_set_position( device(obj_door_outer), 0.0 );
	device_set_power( device(obj_door_outer), 0.0 );

	// init gravity
	f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, FALSE );

	// destroy the vacuum
	object_destroy( obj_vacuum );

	// set starting state
	f_airlocks_state_set( s_airlock_id, s_bay_id, s_state_start );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: DEFAULT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_default::: Manage state
script static void sys_airlocks_bay_state_default( short s_airlock_id, short s_bay_id, object_name obj_door_outer )

	//dprint( "::: sys_airlocks_bay_state_default :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, device_get_position(device(obj_door_outer)) == 0.0, NONE );

	// disable gravity inside
	f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, FALSE );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: OUTER OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_outer_open::: Manage state
script static void sys_airlocks_bay_state_outer_open( short s_airlock_id, short s_bay_id, ai ai_squad, cutscene_flag flg_fx_loc_01, cutscene_flag flg_fx_loc_02, cutscene_flag flg_fx_loc_03, object_name obj_door_outer, object_name obj_door_button )
	//dprint( "::: sys_airlocks_bay_state_outer_open :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, obj_door_button );

	// depressurize
	f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, TRUE );
	f_airlocks_gravity_transition( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_OUTER_OPEN, f_audio_airlock_decompression_sfx(), obj_door_button, f_FX_airlock_transition(), flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03 );

	// VO
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_OUTER_OPEN ) then
		thread( f_dialog_m80_bay_ext_airlock_clear(s_bay_id) );
	end

	// open the door m80_airlock_door_02.device_machine
	device_animate_position( device(obj_door_outer), 1.0, DEF_R_AIRLOCK_DOOR_OUTER_OPEN_TIME, 0.1, 0.1, TRUE );
	sound_impulse_start( f_audio_airlock_door_open_sfx(), obj_door_outer, 1.0 );
	
	// disable gravity inside
	sleep_until( (device_get_position(device(obj_door_outer)) > 0.0) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_OUTER_OPEN), 1 );
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_OUTER_OPEN ) then
		f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, FALSE );
	end	
	
	// wait for door to be open enough
	sleep_until( ((ai_living_count(ai_squad) > 0) and (device_get_position(device(obj_door_outer)) >= DEF_R_AIRLOCK_DOOR_POS_OPEN_ENOUGH)) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_OUTER_OPEN), 1 );

	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_OUTER_OPEN ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_LOAD_AI );
	end

end

script static boolean f_airlocks_enter_check( short s_airlock_id, short s_bay_id ) 
	device_get_position(device(f_airlocks_door_outer_get(s_airlock_id, s_bay_id))) >= DEF_R_AIRLOCK_DOOR_POS_OPEN_ENOUGH;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: AI LOAD
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_ai_load::: Manage state
script static void sys_airlocks_bay_state_ai_load( short s_airlock_id, short s_bay_id, ai ai_squad, trigger_volume tv_bay_area )
local long l_timer = timer_stamp( R_airlock_loading_timeout_time );
	//dprint( "::: sys_airlocks_bay_state_ai_load :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, NONE );

	// wait for all the actors to be inside
	sleep_until( (ai_living_count(ai_squad) > 0) and (volume_test_objects_all(tv_bay_area,ai_actors(ai_squad))) or timer_expired(l_timer) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_LOAD_AI), 1 );

	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_LOAD_AI ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_OUTER_CLOSE );
	end
	
end

script static boolean f_airlocks_idle_end_check( short s_airlock_id, short s_bay_id ) 
	f_airlocks_state_get( s_airlock_id, s_bay_id ) == DEF_S_AIRLOCK_STATE_EJECT
	or
	device_get_position(device(f_airlocks_door_inner_get(s_airlock_id, s_bay_id))) >= DEF_R_AIRLOCK_DOOR_POS_OPEN_ENOUGH;
end
script static boolean f_airlocks_idle_chance( short s_airlock_id, short s_bay_id, real r_chance )
	( f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT ) and f_chance( r_chance );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: OUTER CLOSE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_outer_close::: Manage state
script static void sys_airlocks_bay_state_outer_close( short s_airlock_id, short s_bay_id, ai ai_squad, object_name obj_door_outer, trigger_volume tv_bay_area )
	//dprint( "::: sys_airlocks_bay_state_outer_close :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, NONE );

	// delay
	sleep_s( 0.25 );

	// close the door m80_airlock_door_02.device_machine
	device_animate_position( device(obj_door_outer), 0.0, DEF_R_AIRLOCK_DOOR_OUTER_CLOSE_TIME, 0.1, 0.1, TRUE );
	sound_impulse_start( f_audio_airlock_door_close_sfx(), obj_door_outer, 1.0 );

	// wait for the door to close
	sleep_until( (device_get_position(device(obj_door_outer)) <= 0.0) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_OUTER_CLOSE), 1 );

	// safety kill any ai related to this group if they get closed out
	if ( (ai_living_count(ai_squad) > 0) and (not volume_test_objects_all(tv_bay_area,ai_actors(ai_squad))) ) then
		local object_list ol_squad = ai_actors( ai_squad );
		local short s_index = list_count( ol_squad );
		
		repeat

			s_index = s_index - 1;
			if ( not volume_test_object(tv_bay_area, list_get(ol_squad,s_index)) ) then
				ai_kill( object_get_ai(list_get(ol_squad,s_index)) );
			end

		until( s_index <= 0, 1 );
		
	end

	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_OUTER_CLOSE ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_INNER_OPEN );
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: INNER OPEN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_inner_open::: Manage state
script static void sys_airlocks_bay_state_inner_open( short s_airlock_id, short s_bay_id, short s_state_end, real r_door_inner_pad_time, cutscene_flag flg_fx_loc_01, cutscene_flag flg_fx_loc_02, cutscene_flag flg_fx_loc_03, object_name obj_door_inner, object_name obj_door_button )
local long l_timer = 0;
	//dprint( "::: sys_airlocks_bay_state_inner_open :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, TRUE, obj_door_button );
	
	if ( s_airlock_id == 1 ) then
		sleep_until( f_airlocks_one_entered(), 1 );
	end

	// start the timer
	l_timer = timer_stamp( 5.0 + r_door_inner_pad_time );
	sleep_until( (timer_expired(l_timer) and (device_get_power(device(obj_door_button)) != 0.0)) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_INNER_OPEN), 1 );

	// set button state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then
		f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, obj_door_button );
	end
	
	if ( s_airlock_id == 2 ) then
		sleep_until( f_airlocks_two_entered(), 1 );
	end

	// disable gravity inside
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then
		f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, FALSE );
	end

	// open the door m80_airlock_door_01b_light_attached
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then

		// vo
		thread( f_dialog_m80_bay_int_airlock_clear(s_bay_id) );

		f_airlocks_gravity_transition( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_INNER_OPEN, f_audio_airlock_compression_sfx(), obj_door_button, f_FX_airlock_transition(), flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03 );
		sleep_s( 0.5 );
		device_animate_position( device(obj_door_inner), 1.0, DEF_R_AIRLOCK_DOOR_INNER_OPEN_TIME, 0.1, 0.1, TRUE );
		sound_impulse_start( f_audio_airlock_inner_door_open_sfx(), obj_door_inner, 1.0 );
		f_audio_airlock_movement_loop_start(obj_door_inner);
		sleep_until( (device_get_position(device(obj_door_inner)) >= DEF_R_AIRLOCK_DOOR_POS_OPEN_ENOUGH) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_INNER_OPEN), 1 );
	end

	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, s_state_end );
	end

	sound_impulse_start( f_audio_airlock_inner_door_open_end_sfx(), obj_door_inner, 1.0 );
	f_audio_airlock_movement_loop_stop();	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: INNER OPEN IMMEDIATE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_inner_open_immediate::: Manage state
script static void sys_airlocks_bay_state_inner_open_immediate( short s_airlock_id, short s_bay_id, short s_state_end, object_name obj_door_inner )
	//dprint( "::: sys_airlocks_bay_state_inner_open_immediate :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, NONE );
	
	// disable gravity
	f_airlocks_low_gravity_enabled_set( s_airlock_id, s_bay_id, FALSE );
	
	// open
	device_animate_position( device(obj_door_inner), 1.0, 0.0, 0.0, 0.0, TRUE );
	
	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN_IMMEDIATE ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, s_state_end );
	end
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: EJECT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_eject::: Manage state
script static void sys_airlocks_bay_state_eject( short s_airlock_id, short s_bay_id, short s_state_end, ai ai_squad, cutscene_flag flg_fx_loc_01, cutscene_flag flg_fx_loc_02, cutscene_flag flg_fx_loc_03, object_name obj_door_outer, object_name obj_door_button, trigger_volume tv_bay_area, object_name obj_vacuum )
local object_list ol_squad = ai_actors( ai_squad );
local object obj_unit = 0;
local long l_timer = 0;
local short s_index = 0;
	//dprint( "::: sys_airlocks_bay_state_eject :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, obj_door_button );
	thread( f_airlocks_gravity_transition(s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_EJECT, f_audio_airlock_decompression_sfx(), obj_door_button, f_FX_airlock_transition(), flg_fx_loc_01, flg_fx_loc_02, flg_fx_loc_03) );

	// open m80_airlock_door_02.device_machine
	sleep_s( 0.5 );
	device_animate_position( device(obj_door_outer), 1.0, DEF_R_AIRLOCK_DOOR_OUTER_EJECT_TIME, 0.1, 0.1, TRUE );
	sound_impulse_start( f_audio_airlock_door_open_sfx(), obj_door_outer, 1.0 );
	
	// play fx & disable gravity
	sleep_until( (device_get_position(device(obj_door_outer)) > 0.0) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT), 1 );

	// start vacuum	
	sleep_until( (device_get_position(device(obj_door_outer)) >= DEF_R_AIRLOCK_DOOR_POS_VACUUM) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT), 1 );
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_EJECT ) then
		object_create( obj_vacuum );
		object_hide( obj_vacuum, TRUE );
		sound_impulse_start(f_audio_airlock_jettison_sfx(), obj_door_outer, 1.0);
	end	
	
	// wait until they're all gone
	l_timer = timer_stamp( 7.5 );
	sleep_until( (ai_living_count(ai_squad) <= 0) or (volume_test_objects(tv_bay_area, ai_actors(ai_squad)) == FALSE) or timer_expired(l_timer) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT), 1 );
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_EJECT ) then
		sleep_s( 1.0 );
		device_animate_position( device(obj_door_outer), 0.0, DEF_R_AIRLOCK_DOOR_OUTER_CLOSE_TIME, 0.1, 0.1, TRUE );
		sound_impulse_start( f_audio_airlock_door_close_sfx(), obj_door_outer, 1.0 );
		sleep_until( (device_get_position(device(obj_door_outer)) <= 0.0) or (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT), 1 );
		ai_kill( ai_squad );
		/*
		// make sure everyone's dead
		if ( ai_living_count(ai_squad) > 0 ) then
			ol_squad = ai_actors( ai_squad );
			s_index = list_count( ol_squad ) - 1;
			repeat
		  	ai_kill( object_get_ai(list_get(ol_squad, s_index)) );
				s_index = s_index - 1;
			until ( s_index < 0, 1 );
		end
		*/
	end

	// destroy the vacuum
	object_destroy( obj_vacuum );

	// set next state
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_EJECT ) then
		f_airlocks_state_set( s_airlock_id, s_bay_id, s_state_end );
	end
	
end

script static boolean f_airlocks_eject_end_check( short s_airlock_id, short s_bay_id ) 
	( f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT );
end
script static boolean f_airlocks_eject_suction_check( short s_airlock_id, short s_bay_id, object obj_puppet ) 
	( f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_EJECT );
end
script static void f_airlocks_eject_suction_start( short s_airlock_id, short s_bay_id, object obj_puppet ) 
	if ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_EJECT ) then
		thread( sys_airlocks_eject_suction_start(obj_puppet, f_airlocks_bay_volume_get(s_airlock_id, s_bay_id), f_airlocks_eject_kill_volume_get(s_airlock_id)) );
	end
end
script static void sys_airlocks_eject_suction_start( object obj_puppet, trigger_volume tv_bay, trigger_volume tv_kill )
	local long l_timer = 0;

	// force decloak
	if ( unit_has_equipment(object_get_ai(obj_puppet), "objects\equipment\storm_active_camo\storm_active_camo.equipment") ) then
		ai_set_active_camo( object_get_ai(obj_puppet), FALSE );
	end

	if ( volume_test_object(tv_bay, obj_puppet) ) then
		l_timer = timer_stamp( 10.0 );
	
		// scale
		sleep_until( (not volume_test_object(tv_bay, obj_puppet)) or timer_expired(l_timer), 1 );
		object_set_scale( obj_puppet, 0.01, random_range(30, 50) );
		
		// kill
		sleep_until( volume_test_object(tv_kill, obj_puppet) or timer_expired(l_timer), 1 );
		
	end
	l_timer = timer_stamp( 0.5 );
	pup_kill_biped( obj_puppet, TRUE );
	
	// confirm kill
	sleep_until( (object_get_health(obj_puppet) <= 0.0) or timer_expired(l_timer), 1 );
	if ( object_get_health(obj_puppet) > 0.0 ) then
		ai_kill( object_get_ai(obj_puppet) );
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: RESET
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_reset::: Manage state
script static void sys_airlocks_bay_state_reset( short s_airlock_id, short s_bay_id, short s_state_end, object_name obj_door_inner, trigger_volume tv_bay_area )
local long l_door_thread = 0;
local boolean b_closing = FALSE;
local boolean b_delayed = FALSE;
	//dprint( "::: sys_airlocks_bay_state_reset :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, NONE );
	
	// delay
	sleep_s( 0.5 );
	
	// get the door closed
	if ( device_get_position(device(obj_door_inner)) > 0.0 ) then 
		sleep_until( (device_get_position(device(obj_door_inner)) >= 1.0) or (list_count_not_dead(volume_return_objects_by_type(tv_bay_area, s_objtype_biped)) <= 0), 1 );
		sleep_s( 1.0 );

		repeat
			b_closing = list_count_not_dead(volume_return_objects_by_type(tv_bay_area, s_objtype_biped)) <= 0; 
			
			// animate the door m80_airlock_door_01b_light_attached
			if ( b_closing ) then
				device_animate_position( device(obj_door_inner), 0.0, DEF_R_AIRLOCK_DOOR_INNER_CLOSE_TIME, 0.1, 0.1, TRUE );
			else
				device_animate_position( device(obj_door_inner), 1.0, DEF_R_AIRLOCK_DOOR_INNER_OPEN_TIME, 0.1, 0.1, TRUE );
				sound_impulse_start( f_audio_airlock_inner_door_open_sfx(), obj_door_inner, 1.0 );
				f_audio_airlock_movement_loop_start(obj_door_inner);
			end
			
			// wait for change
			sleep_until( (device_get_position(device(obj_door_inner)) <= 0.0) or (b_closing != (list_count_not_dead(volume_return_objects_by_type(tv_bay_area, s_objtype_biped)) <= 0)), 1 );
			
			f_audio_airlock_movement_loop_stop();
			if ( b_closing) then
				sound_impulse_start( f_audio_airlock_inner_door_close_end_sfx(), obj_door_inner, 1.0 );
			else
				sound_impulse_start( f_audio_airlock_inner_door_open_end_sfx(), obj_door_inner, 1.0 );
			end
			
		until( device_get_position(device(obj_door_inner)) <= 0.0, 1 );
	end

	// start checkpoint
	checkpoint_no_timeout( TRUE, "sys_airlocks_bay_state_reset" );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: STATE: COMPLETE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === sys_airlocks_bay_state_complete::: Manage state
script static void sys_airlocks_bay_state_complete( short s_airlock_id, short s_bay_id )
	//dprint( "::: sys_airlocks_bay_state_complete :::" );
	//inspect( s_airlock_id );
	//inspect( s_bay_id );

	// set button state
	f_airlocks_button_enabled_set( s_airlock_id, s_bay_id, FALSE, NONE );
	
	// start checkpoint
	checkpoint_no_timeout( TRUE, "sys_airlocks_bay_state_complete" );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BAY: MANAGER: HELPERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_bay_outer_button_pressed::: Called when an ai presses a button
script static void f_airlocks_bay_outer_button_pressed( short s_airlock_id, short s_bay_id )
	//dprint( "::: f_airlocks_bay_outer_button_pressed :::" );

	if ( (f_airlocks_state_get(s_airlock_id, s_bay_id) < DEF_S_AIRLOCK_STATE_OUTER_OPEN) and (f_airlocks_state_get(s_airlock_id, s_bay_id) != DEF_S_AIRLOCK_STATE_INIT) ) then
		//dprint( "::: f_airlocks_bay_outter_button_pressed: SET :::" );
		f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_OUTER_OPEN );
	end
   
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: GRAVITY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_low_gravity_enabled_set::: Set
script static void f_airlocks_low_gravity_enabled_set( short s_airlock_id, short s_bay_id, boolean b_enable )
local object_name obj_gravity = f_airlocks_gravity_get( s_airlock_id, s_bay_id );
	//dprint( "::: f_airlocks_low_gravity_enabled_set :::" );

	if ( b_enable != f_airlocks_low_gravity_enabled_get(obj_gravity) ) then

		if ( b_enable ) then
			object_create( obj_gravity );
			object_hide( obj_gravity, TRUE );
		else
			object_destroy( obj_gravity );
		end
		
		// inspect
		//inspect( b_enable );
	end

end

// === f_airlocks_low_gravity_enabled_get::: Get
script static boolean f_airlocks_low_gravity_enabled_get( object_name obj_gravity )
	object_valid( obj_gravity );
end

// === f_airlocks_gravity_transition::: Handles all the audio and fx for an airlock transition
script static void f_airlocks_gravity_transition( short s_airlock_id, short s_bay_id, short s_state, sound snd_sound, object obj_sound, effect fx_effect, cutscene_flag flg_fx_loc_01, cutscene_flag flg_fx_loc_02, cutscene_flag flg_fx_loc_03 )
	//dprint( "::: f_airlocks_gravity_transition :::" );

	// start the sound
	sound_impulse_start( snd_sound, obj_sound, 1.0 );

	// start fx
	effect_new( fx_effect, flg_fx_loc_01 );
	effect_new( fx_effect, flg_fx_loc_02 );
	effect_new( fx_effect, flg_fx_loc_03 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// AIRLOCKS: BUTTON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_airlocks_button_enabled_set::: Set
script static void f_airlocks_button_enabled_set( short s_airlock_id, short s_bay_id, boolean b_enable, object_name obj_door_button )

	if( obj_door_button == NONE ) then
		obj_door_button = f_airlocks_button_get( s_airlock_id, s_bay_id );
	end

	//dprint( "::: f_airlocks_button_enabled_set :::" );

	if ( b_enable ) then
//		if ( b_enable != f_airlocks_button_enabled_get(obj_door_button) ) then
//			thread( f_airlocks_button_manage(s_airlock_id, s_bay_id, obj_door_button) );
//		end
		device_set_power( device(obj_door_button), 1.0 );
		device_set_position_immediate( device(obj_door_button), 0.0 );
	else
		device_set_power( device(obj_door_button), 0.0 );
		device_set_position_immediate( device(obj_door_button), 1.0 );
	end

end

// === f_airlocks_button_enabled_get::: Get
script static boolean f_airlocks_button_enabled_get( object_name obj_door_button )
	( device_get_power(device(obj_door_button)) != 0.0 );
end

// === f_airlock_control_action::: Button press
script static void f_airlock_control_action( object obj_control, unit u_activator )
	dprint( "::: f_airlock_control_action :::" );
	
	// manage control
	if ( (device_get_power(device(obj_control)) > 0.0) and (device_get_position(device(obj_control)) == 0.0) and (unit_get_health(u_activator) > 0.0) ) then
		dprint( "::: f_airlock_control_action: START :::" );
		local long l_pup_id = -1; 
		local short s_airlock_id = 0;
		local short s_bay_id = 0;
	
		// disable power
		device_set_power( device(obj_control), 0.0 );
	
		// prepare pup
		p_player_puppet = u_activator;
		p_button_puppet = obj_control;
	
		// play the show
		dprint( "::: f_airlock_control_action: PLAY SHOW :::" );
		l_pup_id = pup_play_show( 'pup_airlock_button' );

		// get airlock ID
		if ( (obj_control == button_airlock_one_inner_1) or (obj_control == button_airlock_one_inner_2) or (obj_control == button_airlock_one_inner_3) ) then
			s_airlock_id = 01;
		else
			s_airlock_id = 02;
		end
	
		// get bay ID
		if ( (obj_control == button_airlock_one_inner_1) or (obj_control == button_airlock_two_inner_1) ) then
			s_bay_id = 01;
		elseif ( (obj_control == button_airlock_one_inner_2) or (obj_control == button_airlock_two_inner_2) ) then
			s_bay_id = 02;
		else
			s_bay_id = 03;
		end

		// wait for show or device change
		dprint( "::: f_airlock_control_action: WAIT FIRST :::" );
		dprint( "::: f_airlock_control_action: s_airlock_id :::" );
		inspect( s_airlock_id );
		dprint( "::: f_airlock_control_action: s_bay_id :::" );
		inspect( s_bay_id );
		sleep_until( not pup_is_playing(l_pup_id) or (device_get_position(device(obj_control)) == 1.0) or (unit_get_health(u_activator) <= 0.0), 1 );
		dprint( "::: f_airlock_control_action: PASSED WAIT ONE :::" );
		dprint( "::: f_airlock_control_action: PUP PLAYING :::" );
		inspect( pup_is_playing(l_pup_id) );
		dprint( "::: f_airlock_control_action: ACTIVATOR HEALTH :::" );
		inspect( unit_get_health(u_activator) );
		dprint( "::: f_airlock_control_action: DEVICE POSITION :::" );
		inspect( device_get_position(device(obj_control)) );
		
		// evaluate state
		if ( device_get_position(device(obj_control)) == 0.0 ) then
			dprint( "::: f_airlock_control_action: POSITION STILL 0.0 :::" );
			// failed, reset
			if ( (f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_DEFAULT) or (f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN) ) then
				dprint( "::: f_airlock_control_action: RESET :::" );
				device_set_power( device(obj_control), 1.0 );
			end
		elseif ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_DEFAULT ) then
			dprint( "::: f_airlock_control_action: OUTER OPEN :::" );
			f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_OUTER_OPEN );
		elseif ( f_airlocks_state_get(s_airlock_id, s_bay_id) == DEF_S_AIRLOCK_STATE_INNER_OPEN ) then
			dprint( "::: f_airlock_control_action: EJECT :::" );
			f_airlocks_state_set( s_airlock_id, s_bay_id, DEF_S_AIRLOCK_STATE_EJECT );
		elseif ( unit_get_health(u_activator) <= 0.0 ) then
			dprint( "::: f_airlock_control_action: UNIT DEAD :::" );
		end
		
		// end puppet active
		sleep_until( (not pup_is_playing(l_pup_id)) or (unit_get_health(u_activator) <= 0.0), 1 );	
		dprint( "::: f_airlock_control_action: FINISHING :::" );
		dprint( "::: f_airlock_control_action: PUP PLAYING :::" );
		inspect( pup_is_playing(l_pup_id) );
		dprint( "::: f_airlock_control_action: ACTIVATOR HEALTH :::" );
		inspect( unit_get_health(u_activator) );

		f_button_user_active( u_activator, FALSE );
		
		// make sure the show is dead
		if ( pup_is_playing(l_pup_id) ) then
		dprint( "::: f_airlock_control_action: STOP SHOW :::" );
			pup_stop_show( l_pup_id );
		end
		
	end
	dprint( "::: f_airlock_control_action: COMPLETE :::" );

end

// === f_airlock_control_action_pressed::: Button press
script static void f_airlock_control_action_pressed( object obj_user, object obj_control )
//	dprint( "::: f_airlock_control_action_pressed :::" );
	if ( (object_get_health(obj_user) > 0.0) and (obj_control != NONE) ) then
//	dprint( "::: f_airlock_control_action_pressed: VALID :::" );
		device_set_position_immediate( device(obj_control), 1.0 );
//	else
//		breakpoint( "::: f_airlock_control_action_pressed: OBJECT IS INVALID :::" );
//		sleep( 1 );
		//dprint( "::: f_airlock_control_action_pressed: OBJECT IS INVALID :::" );
	end
end