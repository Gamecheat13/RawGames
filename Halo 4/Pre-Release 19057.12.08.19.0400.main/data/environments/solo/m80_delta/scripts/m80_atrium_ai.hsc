//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_atrium (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** ATRIUM: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_ai_init::: Initialize
script dormant f_atrium_ai_init()
	//dprint( "::: f_atrium_ai_init :::" );
	
	// reset allegiance
	ai_allegiance( player, human );
	
	// setup trigger
	wake( f_atrium_ai_trigger );

end

// === f_atrium_ai_deinit::: Deinitialize
script dormant f_atrium_ai_deinit()
	//dprint( "::: f_atrium_ai_deinit :::" );

	// kill functions
	kill_script( f_atrium_ai_init );
	kill_script( f_atrium_ai_trigger );
	kill_script( f_atrium_ai_spawn );

	// erase ai
	ai_erase( sg_atrium );

end

// === f_atrium_ai_trigger::: Trigger
script dormant f_atrium_ai_trigger()
	sleep_until( TRUE, 1 );
	//dprint( "::: f_atrium_ai_trigger :::" );

	// spawn
	wake( f_atrium_ai_spawn );	

end

// === f_atrium_ai_spawn::: Spawns AI for area
script dormant f_atrium_ai_spawn()
	//dprint( "::: f_atrium_ai_spawn :::" );

	// set allegiance
	//ai_allegiance( player, human );
	
	// place marines
	ai_place( sq_atrium_marines.convo1_marine_01 );
	ai_place( sq_atrium_marines.convo3_marine_01 );
	ai_place( sq_atrium_marines.convo3_marine_02 );
	ai_place( sq_atrium_marines.convo_mech_01_marine_01 );
	ai_place( sq_atrium_marines.convo_mech_02_marine_01 );
	ai_place( sq_atrium_marines.convo_mech_03_marine_01 );
	ai_place( sq_atrium_marines.group01_marine_01 );
	ai_place( sq_atrium_marines.group03_marine_01 );
	ai_place( sq_atrium_marines.group03_marine_02 );
	ai_place( sq_atrium_marines.group03_marine_03 );
	ai_place( sq_atrium_marines.group03_marine_04 );
	ai_place( sq_atrium_marines.group03_marine_05 );
	ai_place( sq_atrium_marines.turret_01 );
	ai_place( sq_atrium_marines.turret_02 );
	ai_place( sq_atrium_marines.turret_03 );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object OBJ_atrium_pup_actor = 				NONE;
global object OBJ_atrium_pup_loc = 					NONE;

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS: ACTIONS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static short f_atrium_pick_action( short s_action, long l_pup_id, short s_last_action, boolean b_condition )

	// check invalidate action
	if ( (not b_condition) or pup_is_playing(l_pup_id) or ((s_last_action > 0) and (s_action == s_last_action)) ) then
		s_action = 0;
	end

	// return
	s_action;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS: CHANCE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_chance_vs_distance::: Chance increases based on distance from an object list
script static boolean f_chance_vs_distance( real r_chance_dist_min_less, real r_chance_dist_min, real r_chance_dist_max, real r_chance_dist_max_greater, object_list obj_list, object obj_test, real r_distance_min, real r_distance_max, real r_see_radius )
local real r_distance = objects_distance_to_object( obj_list, obj_test );
local real r_threshold = 0.0;

	if ( (r_see_radius >= 0.0) and objects_can_see_object(obj_list,obj_test,r_see_radius) ) then
		if ( r_distance <= r_distance_min ) then
			r_threshold = r_chance_dist_min_less;
		elseif ( r_distance >= r_distance_max ) then
			r_threshold = r_chance_dist_max_greater;
		else
			r_threshold = r_chance_dist_min + ( (r_chance_dist_max - r_chance_dist_min) * ( (r_distance - r_distance_min) / (r_distance_max - r_distance_min) ) );
		end
		//inspect( r_threshold );
	end

	// return
	real_random_range( r_chance_dist_min, r_chance_dist_max ) <= r_threshold;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS: PANIC
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_atrium_panic_level_low = 	DEF_R_SCREENSHAKE_EVENT_INTENSITY_LOW() * 0.75;
global real R_atrium_panic_level_med = 	DEF_R_SCREENSHAKE_EVENT_INTENSITY_MED();
global real R_atrium_panic_level_high = DEF_R_SCREENSHAKE_EVENT_INTENSITY_HIGH();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_atrium_panic_get::: Gets the current panic level value
script static real f_atrium_panic_get()
	f_R_screenshake_intensity_global_get();
end

// === f_atrium_panic_check_low::: Checks if the current panic level is low
script static boolean f_atrium_panic_check_low()
	f_atrium_panic_get() >= R_atrium_panic_level_low; 
end
// === f_atrium_panic_check_med::: Checks if the current panic level is medium
script static boolean f_atrium_panic_check_med()
	f_atrium_panic_get() >= R_atrium_panic_level_med;
end
// === f_atrium_panic_check_high::: Checks if the current panic level is high
script static boolean f_atrium_panic_check_high()
	f_atrium_panic_get() >= R_atrium_panic_level_high;
end

// === cs_atrium_combat_panic::: Pushes the AI into a panic state
script command_script cs_atrium_combat_panic()
	//dprint( "$$$ cs_atrium_combat_panic $$$" );
	cs_push_stance( 'panic' );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS: TURRETS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_cs_atrium_turret::: Manages an AI on a turret
script static void f_cs_atrium_turret( ai ai_pilot, object_name obj_turret, point_reference pr_01, point_reference pr_02, point_reference pr_03 )
local long l_timer = 0;
local point_reference pr_last = pr_01;
local point_reference pr_new = 	pr_01;
	//dprint( "::: f_cs_atrium_turret :::" );

	cs_abort_on_damage( ai_pilot, TRUE );
	cs_abort_on_alert( ai_pilot, FALSE );

	// load turret
	//dprint( "::: f_cs_atrium_turret: LOAD :::" );
	sleep_until( object_valid(obj_turret) );
	ai_vehicle_enter_immediate( ai_pilot, unit(obj_turret) );
	vehicle_set_player_interaction( vehicle(obj_turret), "warthog_g", FALSE, FALSE );

	// random aim
	repeat
	
		// pick a random target
		repeat
			//dprint( "::: f_cs_atrium_turret: PT :::" );
			begin_random_count( 1 )
				pr_new = pr_01;
				pr_new = pr_02; 
				pr_new = pr_03;
			end
		until( (pr_new != pr_last) or ai_allegiance_broken(player, human), 1 );
		
		// start a timer
		l_timer = timer_stamp( 5.0, 10.0 );

		// face postition
		cs_aim( ai_pilot, TRUE, pr_new );
		
		// wait for timer
		//dprint( "::: f_cs_atrium_turret: AIM :::" );
		sleep_until( timer_expired(l_timer) or ai_allegiance_broken(player, human), 1 );
		pr_last = pr_new;
		
	until( ai_allegiance_broken(player, human), 1 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
//ATRIUM: AI: CHARACTERS: HELPERS: SALUTE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_atrium_salute_range_start = 	2.5;
global real R_atrium_salute_range_end = 		3.75;
global real R_atrium_salute_angle_start = 	75.0;
global real R_atrium_salute_angle_facing = 	5.0;
global real R_atrium_salute_angle_end = 		95.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean f_atrium_salute_check_start( object obj_marine, long l_timer )
	f_atrium_salute_check(obj_marine, R_atrium_salute_range_start, R_atrium_salute_angle_start, l_timer);
end
script static boolean f_atrium_salute_check_facing( object obj_marine, long l_timer )
	f_atrium_salute_check(obj_marine, R_atrium_salute_range_start, R_atrium_salute_angle_facing, l_timer);
end
script static boolean f_atrium_salute_check_end( object obj_marine )
	not f_atrium_salute_check( obj_marine, R_atrium_salute_range_end, R_atrium_salute_angle_end, 0 );
end

script static boolean f_atrium_salute_check( object obj_marine, real r_distance, real r_angle, long l_timer )
	if ( r_distance < 0.0 ) then
		r_distance = R_atrium_salute_range_end;
	end

	// return
	timer_expired(l_timer)
	and
	( objects_distance_to_object(Players(), obj_marine) <= r_distance )
	and
	objects_can_see_player( obj_marine, r_angle );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: MARINES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_atrium_marine_action_exit_chance = 	37.5;
global real R_atrium_marine_idle_loop_chance = 		65.0;
global long L_atrium_marine_idle_timer = 					0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

script static boolean f_atrium_marine_ready_pistol( unit u_marine )
	unit_has_weapon_readied( u_marine, 'objects\weapons\pistol\storm_magnum\storm_magnum.weapon' ) or
	unit_has_weapon_readied( u_marine, 'objects\weapons\pistol\storm_needler\storm_needler.weapon' ) or
	unit_has_weapon_readied( u_marine, 'objects\weapons\pistol\storm_sticky_detonator\storm_sticky_detonator_pve.weapon' );
end

script static long f_atrium_marine_pup_panic( object obj_marine )
local string_id sid_show = 'pup_atrium_marine_panic_rifle';
local long pup_id = -1;
	
	if ( f_atrium_marine_ready_pistol(object_get_ai(obj_marine)) ) then
		sid_show = 'pup_atrium_marine_panic_pistol';
	end
	sleep_s( 0.0, 0.25 );
	
	OBJ_atrium_pup_actor = obj_marine;
	pup_id = pup_play_show( sid_show );
	
	// return
	pup_id;

end
script static long f_atrium_marine_pup_salute( object obj_marine )
local string_id sid_show = 'pup_atrium_marine_salute_rifle';
local long pup_id = -1;
	
	if ( f_atrium_marine_ready_pistol(object_get_ai(obj_marine)) ) then
		sid_show = 'pup_atrium_marine_salute_pistol';
	end

	OBJ_atrium_pup_actor = obj_marine;
	pup_id = pup_play_show( sid_show );
	
	// return
	pup_id;
	
end
script static long f_atrium_marine_pup_action( object obj_marine )
local string_id sid_show = 'pup_atrium_marine_action_rifle';
local long pup_id = -1;
	
	if ( f_atrium_marine_ready_pistol(object_get_ai(obj_marine)) ) then
		sid_show = 'pup_atrium_marine_action_pistol';
	end

	OBJ_atrium_pup_actor = obj_marine;
	pup_id = pup_play_show( sid_show );
	
	// return
	pup_id;

end
script static void f_atrium_marine_pup_action_timer_stamp( object obj_marine )
	if ( (objects_distance_to_object(Players(), obj_marine) <= 15.0) and objects_can_see_object(Players(), obj_marine, 30.0) ) then
		//dprint( "f_atrium_marine_pup_action_timer_stamp" );
		L_atrium_marine_idle_timer = timer_stamp( 7.5, 10.0 );
	end
end
script static boolean f_atrium_marine_pup_action_timer_active()
	timer_active( L_atrium_marine_idle_timer );
end
script static boolean f_atrium_marine_pup_action_timer_expired()
	timer_expired( L_atrium_marine_idle_timer );
end

script static short f_atrium_marine_state_roll( object obj_marine, short s_min, short s_max, boolean b_force_roll )
static object obj_stored = NONE;
static short s_state = 0;
static short s_state_last = 0;
	
	// if this is a different marine or forced; reroll the state
	if ( (obj_stored != obj_marine) or b_force_roll or (s_state < s_min) or (s_state > s_max) ) then
		s_state = random_range( s_min, s_max );
		if ( s_state == s_state_last ) then
			s_state = 0;
		end
		if ( s_state != 0 ) then
			s_state_last = s_state;
		end
	end

	// return
	s_state;

end

script static void f_cs_atrium_marine_goto( ai ai_marine, point_reference pr_point, real r_range )
	repeat
		//dprint( "f_cs_atrium_marine_goto" );
//		cs_move_towards_point( ai_marine, TRUE, pr_point, r_range );
		cs_go_to( ai_marine, TRUE, pr_point );
	until( (ai_living_count(ai_marine) <= 0) or (objects_distance_to_point(ai_actors(ai_marine),pr_point) <= r_range), 1 );
end

script static long f_cs_atrium_marine_shared( ai ai_marine, point_reference pr_01, point_reference pr_02, point_reference pr_03, point_reference pr_04 )
	thread( sys_cs_atrium_marine_shared(ai_marine, pr_01, pr_02, pr_03, pr_04) );
end
script static void sys_cs_atrium_marine_shared( ai ai_marine, point_reference pr_01, point_reference pr_02, point_reference pr_03, point_reference pr_04 )
local point_reference pr_point = pr_01;
local long l_point_timer = 0;
local long l_salute_timer = 0;
local long l_action_timer = 0;
local long l_pup_id = -1;
local long l_thread_id = 0;
local boolean b_has_pistol = FALSE;
//dprint( "f_cs_atrium_marine_shared" );

	repeat
		sleep_until( (not ai_allegiance_broken(player, human)) and (not f_ai_is_hunting(ai_marine)) and (object_get_recent_body_damage(ai_marine) <= 0.0), 1 );
		//dprint( "f_cs_atrium_marine_shared: START" );
		
		// push alert stance
		cs_push_stance( ai_marine, 'alert' );

		// setup pup
		if ( f_atrium_panic_check_high() ) then
			//dprint( "$$$ f_cs_atrium_marine_shared: PANIC $$$" );

			l_pup_id = f_atrium_marine_pup_panic( ai_get_object(ai_marine) );

			// wait
			sleep_until(
					( unit_get_health(ai_marine) <= 0.0 )
					or
					ai_allegiance_broken( player, human )
					or
					( not pup_is_playing(l_pup_id) )
					or
					f_ai_is_hunting( ai_marine )
				, 1 );

		elseif ( f_atrium_salute_check_start(ai_marine, l_salute_timer) ) then
			//dprint( "$$$ f_cs_atrium_marine_shared: SALUTE: START $$$" ); 
			
			// face the chief
			if ( not f_atrium_salute_check_facing(ai_marine, 0) ) then
				local long l_face_timer = timer_stamp( 3.0 );
				repeat
					cs_stationary_face_player( ai_marine, TRUE );
					sleep_s( 0.5 );
				until( (f_atrium_salute_check_facing(ai_marine, 0) or (not f_atrium_salute_check_start(ai_marine, l_salute_timer))) or timer_expired(l_face_timer) or ai_allegiance_broken(player, human) or f_atrium_panic_check_high() or f_ai_is_hunting(ai_marine), 1 );
			end
		
			// salute
			if ( f_atrium_salute_check_facing(ai_marine, 0) and f_atrium_salute_check_start(ai_marine, l_salute_timer) and (not ai_allegiance_broken(player, human)) and (not f_atrium_panic_check_high()) and (not f_ai_is_hunting(ai_marine)) ) then

				b_has_pistol = f_atrium_marine_ready_pistol( ai_marine );
				l_pup_id = f_atrium_marine_pup_salute( ai_get_object(ai_marine) );

				// wait
				sleep_until(
						( unit_get_health(ai_marine) <= 0.0 )
						or
						ai_allegiance_broken( player, human )
						or
						( not pup_is_playing(l_pup_id) )
						or
						f_atrium_panic_check_high()
						or
						f_ai_is_hunting( ai_marine )
						or
						b_has_pistol != f_atrium_marine_ready_pistol(ai_marine)
					, 1 );
	
				// start salute timer
				if ( not pup_is_playing(l_pup_id) ) then
					l_salute_timer = timer_stamp( 15.0, 30.0 );
				end
	
				// stop facing
				cs_stationary_face_player( ai_marine, FALSE );
			elseif f_atrium_salute_check_start(ai_marine, l_salute_timer) then
				l_salute_timer = timer_stamp( 3.0 );
			end
	
		elseif( timer_expired(l_point_timer) ) then
			//dprint( "$$$ f_cs_atrium_marine_shared: POINT $$$" );
		
			// move to a point
			if ( l_point_timer > 0 ) then
				////dprint( "$$$ f_cs_atrium_marine_shared: POINT: RANDOM $$$" );
				begin_random_count( 1 )
					l_thread_id = thread( f_cs_atrium_marine_goto(ai_marine, pr_01, 0.5) ); 
					l_thread_id = thread( f_cs_atrium_marine_goto(ai_marine, pr_02, 0.5) );
					l_thread_id = thread( f_cs_atrium_marine_goto(ai_marine, pr_03, 0.5) );
					l_thread_id = thread( f_cs_atrium_marine_goto(ai_marine, pr_04, 0.5) );
				end
			else
				////dprint( "$$$ f_cs_atrium_marine_shared: POINT: 0 $$$" );
				l_thread_id = thread( f_cs_atrium_marine_goto(ai_marine, pr_01, 0.5) );
			end
			l_point_timer = timer_stamp( 5.0, 15.0 );
			
			// wait
			sleep_until(
					( unit_get_health(ai_marine) <= 0.0 )
					or
					ai_allegiance_broken( player, human )
					or
					( not isthreadvalid(l_thread_id) )
					or
					timer_expired( l_point_timer )
					or
					f_atrium_salute_check_start( ai_marine, l_salute_timer )
					or
					f_atrium_panic_check_high()
					or
					f_ai_is_hunting( ai_marine )
				, 1 );
		else 
			//dprint( "$$$ f_cs_atrium_marine_shared: ACTION $$$" );
			
			b_has_pistol = f_atrium_marine_ready_pistol( ai_marine );
			l_pup_id = f_atrium_marine_pup_action( ai_marine );
			l_action_timer = timer_stamp( 10.0, 20.0 );
				
			// wait
			sleep_until(
					( unit_get_health(ai_marine) <= 0.0 )
					or
					ai_allegiance_broken( player, human )
					or
					timer_expired( l_action_timer )
					or
					( not pup_is_playing(l_pup_id) )
					or
					f_atrium_salute_check_start( ai_marine, l_salute_timer )
					or
					f_atrium_panic_check_high()
					or
					f_ai_is_hunting( ai_marine )
					or
					b_has_pistol != f_atrium_marine_ready_pistol(ai_marine)
				, 1 );
		end

		// cleanup
		//dprint( "$$$ f_cs_atrium_marine_shared: COMPLETE $$$" );
		if ( pup_is_playing(l_pup_id) ) then
			pup_stop_show( l_pup_id );
		end
		if ( isthreadvalid(l_thread_id) ) then
			kill_thread( l_thread_id );
		end
	
	until( unit_get_health(ai_marine) <= 0.0, 1 );
	//dprint( "$$$ f_cs_atrium_marine_shared: EXIT $$$" );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: CONVO 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_convo1_marine_01()
	//dprint( "$$$ cs_atrium_convo1_marine_01 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_conv_01_marine_01.p0, ps_atrium_conv_01_marine_01.p1, ps_atrium_conv_01_marine_01.p2, ps_atrium_conv_01_marine_01.p3 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: CONVO 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: CONVO 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_convo3_marine_01()
	//dprint( "$$$ cs_atrium_convo3_marine_01 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_conv_03_marine_01.p0, ps_atrium_conv_03_marine_01.p1, ps_atrium_conv_03_marine_01.p2, ps_atrium_conv_03_marine_01.p3 ); 
end
script command_script cs_atrium_convo3_marine_02()
	//dprint( "$$$ cs_atrium_convo3_marine_02 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_conv_03_marine_02.p0, ps_atrium_conv_03_marine_02.p1, ps_atrium_conv_03_marine_02.p2, ps_atrium_conv_03_marine_02.p3 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: CONVO 04
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: CONVO 05
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: MECH 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_convo_mech_01_marine_01()
	//dprint( "$$$ cs_atrium_convo_mech_01_marine_01 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_mech_01_marine_01.p0, ps_atrium_mech_01_marine_01.p1, ps_atrium_mech_01_marine_01.p2, ps_atrium_mech_01_marine_01.p3 );
end 


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: MECH 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_atrium_mech_2_mantis_state = 0;

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_convo_mech_02_marine_01()
local long l_pup_id = 0;
	//dprint( "$$$ cs_atrium_convo_mech_02_marine_01 $$$" );

	// play special show	
	l_pup_id = pup_play_show( 'pup_atrium_mech_02_special_01' ); 
	sleep_until( dialog_id_played_check(L_dlg_mantis_scientist_02) or ai_allegiance_broken(player, human), 1 );
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	sleep_s( 0.25 );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_mech_02_marine_01.p0, ps_atrium_mech_02_marine_01.p1, ps_atrium_mech_02_marine_01.p2, ps_atrium_mech_02_marine_01.p3 );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: MECH 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_convo_mech_03_marine_01()
local long l_pup_id = 0;
	//dprint( "$$$ cs_atrium_convo_mech_03_marine_01 $$$" );

	// play special show	
	l_pup_id = pup_play_show( 'pup_atrium_mech_03_special_01' ); 
	sleep_until( dialog_id_played_check(L_dlg_mantis_inversion) or ai_allegiance_broken(player, human), 1 );
	if ( pup_is_playing(l_pup_id) ) then
		pup_stop_show( l_pup_id );
	end
	sleep_s( 0.25 );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_mech_03_marine_01.p0, ps_atrium_mech_03_marine_01.p1, ps_atrium_mech_03_marine_01.p2, ps_atrium_mech_03_marine_01.p3 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: GROUP 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_group01_marine_01()
	//dprint( "$$$ cs_atrium_group01_marine_01 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group01_marine_01.p0, ps_atrium_group01_marine_01.p1, ps_atrium_group01_marine_01.p2, ps_atrium_group01_marine_01.p3 );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: GROUP 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: GROUP 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_atrium_group_3_state = 0;
global short S_atrium_group_3_cnt = 0;
global real R_atrium_group_3_start_distance = 0.25;
global long l_atrium_group_3_pup_id = -1;

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_group03_special_01()
	//dprint( "$$$ cs_atrium_group03_special_01 $$$" );

	sleep_until( (volume_test_players(tv_atrium_group03_special_01) or dialog_id_played_check(L_dlg_m80_atrium_defenses_offline)) and (not ai_allegiance_broken(player, human)), 1 );

	// play special show	
	if ( not ai_allegiance_broken(player, human) ) then
		cs_stow( TRUE );
		//dprint( "$$$ cs_atrium_group03_special_01: START!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! $$$" );
		l_atrium_group_3_pup_id = pup_play_show( 'pup_atrium_group_03_special_01' );
		sleep_until( (not pup_is_playing(l_atrium_group_3_pup_id)) or ai_allegiance_broken(player, human), 1 );
		if ( pup_is_playing(l_atrium_group_3_pup_id) ) then
			pup_stop_show( l_atrium_group_3_pup_id );
		end
	end
	
end

script command_script cs_atrium_group03_marine_01()
	//dprint( "$$$ cs_atrium_group03_marine_01 $$$" );
	cs_stow( FALSE );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group03_marine_01.p0, ps_atrium_group03_marine_01.p1, ps_atrium_group03_marine_01.p2, ps_atrium_group03_marine_01.p3 );
end
script command_script cs_atrium_group03_marine_02()
	//dprint( "$$$ cs_atrium_group03_marine_02 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group03_marine_02.p0, ps_atrium_group03_marine_02.p1, ps_atrium_group03_marine_02.p2, ps_atrium_group03_marine_02.p3 );
end
script command_script cs_atrium_group03_marine_03()
	//dprint( "$$$ cs_atrium_group03_marine_03 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group03_marine_03.p0, ps_atrium_group03_marine_03.p1, ps_atrium_group03_marine_03.p2, ps_atrium_group03_marine_03.p3 );
end
script command_script cs_atrium_group03_marine_04()
	//dprint( "$$$ cs_atrium_group03_marine_04 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group03_marine_04.p0, ps_atrium_group03_marine_04.p1, ps_atrium_group03_marine_04.p2, ps_atrium_group03_marine_04.p3 );
end
script command_script cs_atrium_group03_marine_05()
	//dprint( "$$$ cs_atrium_group03_marine_05 $$$" );
	f_cs_atrium_marine_shared( ai_current_actor, ps_atrium_group03_marine_05.p0, ps_atrium_group03_marine_05.p1, ps_atrium_group03_marine_05.p2, ps_atrium_group03_marine_05.p3 );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ATRIUM: AI: CHARACTERS: TURRETS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_atrium_turret_01()
	//dprint( "$$$ cs_atrium_turret_01 $$$" );
	f_cs_atrium_turret( ai_current_actor, turret_atrium_1, ps_atrium_turret1.p0, ps_atrium_turret1.p1, ps_atrium_turret1.p2 );
end

script command_script cs_atrium_turret_02()
	//dprint( "$$$ cs_atrium_turret_02 $$$" );
	f_cs_atrium_turret( ai_current_actor, turret_atrium_2, ps_atrium_turret2.p0, ps_atrium_turret2.p1, ps_atrium_turret2.p2 );
end

script command_script cs_atrium_turret_03()
	//dprint( "$$$ cs_atrium_turret_03 $$$" );
	f_cs_atrium_turret( ai_current_actor, turret_atrium_3, ps_atrium_turret3.p0, ps_atrium_turret3.p1, ps_atrium_turret3.p2 );
end





/*
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// COMMAND SCRIPTS
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------


script command_script cs_atrium_scientist_working_on_mech_1()
	sleep_until( object_valid(atrium_clipboard_1), 1 );
	objects_attach( ai_current_actor, "left_hand", atrium_clipboard_1, "left_low" );
end

script command_script cs_atrium_scientist_with_clipboard_1()
	sleep_until( object_valid(atrium_clipboard_2), 1 );
	objects_attach( ai_current_actor, "right_hand", atrium_clipboard_2, "right_mid" );
end

script command_script cs_atrium_scientist_with_clipboard_2()
	sleep_until( object_valid(atrium_clipboard_3), 1 );
	objects_attach( ai_current_actor, "left_hand", atrium_clipboard_3, "bottom" );
end
*/
