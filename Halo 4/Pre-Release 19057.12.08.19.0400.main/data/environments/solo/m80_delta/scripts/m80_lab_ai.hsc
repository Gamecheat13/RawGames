//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_lab (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** LAB: AI ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// === f_lab_ai_init::: Initialize
script dormant f_lab_ai_init()
//	//dprint( "::: f_lab_ai_init :::" );
	
	// init sub modules
	wake( f_lab_ai_to_init );
	wake( f_lab_ai_main_init );
	wake( f_lab_ai_objcon_init );

end

// === f_lab_ai_deinit::: Deinitialize
script dormant f_lab_ai_deinit()
//	//dprint( "::: f_lab_ai_deinit :::" );
	
	// deinit sub modules
	wake( f_lab_ai_to_deinit );
	wake( f_lab_ai_main_deinit );
	wake( f_lab_ai_objcon_deinit );

	// kill functions
	kill_script( f_lab_ai_init );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_lab_objcon = 						-1;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_ai_objcon_init::: Initialize
script dormant f_lab_ai_objcon_init()
//	//dprint( "::: f_lab_ai_objcon_init :::" );
	
	// init sub modules
	wake( f_lab_ai_objcon_trigger );

end

// === f_lab_ai_objcon_deinit::: Deinitialize
script dormant f_lab_ai_objcon_deinit()
//	//dprint( "::: f_lab_ai_objcon_deinit :::" );

	// kill functions
	kill_script( f_lab_ai_objcon_init );
	kill_script( f_lab_ai_objcon_trigger );

end

// === f_lab_ai_objcon_trigger::: Triggers objcon states
script dormant f_lab_ai_objcon_trigger()
//	//dprint( "::: f_lab_ai_objcon_trigger :::" );
	
	sleep_until( f_lab_started(), 1 );
	S_lab_objcon = 000;

end

// === f_lab_ai_objcon_set::: Set objcon
script static void f_lab_ai_objcon_set( short s_objcon )
//	//dprint( "::: f_lab_ai_objcon_set :::" );

	if ( s_objcon > S_lab_objcon ) then
		S_lab_objcon = s_objcon;
		//inspect( S_lab_objcon );
	end

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: AI: TO
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_lab_puppeteer_pre_lab_thruster_look_distance = 	8.5;
global real R_lab_puppeteer_pre_lab_thruster_talk_distance = 	6.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_ai_to_init::: Initialize
script dormant f_lab_ai_to_init()
//	//dprint( "::: f_lab_ai_to_init :::" );
	
	// init sub modules
	wake( f_lab_ai_to_trigger );

end

// === f_lab_ai_to_deinit::: Deinitialize
script dormant f_lab_ai_to_deinit()
//	//dprint( "::: f_lab_ai_to_deinit :::" );

	// kill functions
	kill_script( f_lab_ai_to_init );
	kill_script( f_lab_ai_to_trigger );
	//kill_script( f_lab_ai_to_spawn );
	
	// erase ai
	ai_erase( sg_to_lab );

end

// === f_lab_ai_to_trigger::: Trigger
script dormant f_lab_ai_to_trigger()
	sleep_until( zoneset_current_active() >= S_ZONESET_TO_LAB, 1 );
//	//dprint( "::: f_lab_ai_to_trigger :::" );
	
	// init sub modules
//	wake( f_lab_ai_to_spawn );
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_to_lab_scientists );

end
/*
// === f_lab_ai_to_spawn::: Spawn
script dormant f_lab_ai_to_spawn()
//	//dprint( "::: f_lab_ai_to_spawn :::" );

	// set allegiance
	//ai_allegiance( player, human );

	// scientists
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_to_lab_scientists );

end
*/
// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_to_lab_scientist::: Lab scientist
script command_script cs_to_lab_scientist()
local boolean b_allegiance_broken = 	FALSE;
local long l_pup_id = 								-1;
//	//dprint( "$$$ cs_to_lab_scientist $$$" );

	// force low vitality
	unit_set_maximum_vitality( ai_current_actor, object_get_maximum_vitality(ai_current_actor, FALSE) * 0.1375, 0.0 );
	unit_set_current_vitality( ai_current_actor, object_get_maximum_vitality(ai_current_actor, FALSE), 0.0 );
	
	repeat
		
		// store broken state
		b_allegiance_broken = ai_allegiance_broken( player, human );
		
		// set panic stance
		cs_push_stance( 'panic' );

		// play/stop the show	
		if not b_allegiance_broken then
			if ( not pup_is_playing(l_pup_id) ) then
				l_pup_id = pup_play_show( 'pup_to_lab_scientist_thruster' );
			end
		elseif ( pup_is_playing(l_pup_id) ) then
			pup_stop_show( l_pup_id );
		end
	
		// wait for condition change
		sleep_until( (b_allegiance_broken != ai_allegiance_broken(player, human)) or ((not b_allegiance_broken) and (not pup_is_playing(l_pup_id))), 1 );
	
	until( FALSE, 1 );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// LAB: AI: MAIN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_lab_hunter_center_loc = 0;
global boolean B_lab_hunters_hunting = FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_lab_ai_main_init::: Initialize
script dormant f_lab_ai_main_init()
//	//dprint( "::: f_lab_ai_main_init :::" );
	
	// init sub modules
	wake( f_lab_ai_main_trigger );

end

// === f_lab_ai_main_deinit::: Deinitialize
script dormant f_lab_ai_main_deinit()
//	//dprint( "::: f_lab_ai_main_deinit :::" );

	// kill functions
	kill_script( f_lab_ai_main_init );
	kill_script( f_lab_ai_main_trigger );
	//kill_script( f_lab_ai_main_spawn );
	kill_script( f_lab_ai_main_human_spawn );
	kill_script( f_lab_ai_main_enemy_spawn );
	kill_script( f_lab_ai_main_enemy_center_shift );
	kill_script( f_lab_ai_main_enemy_hunting_watch );
	
	// erase ai
	ai_erase( sg_lab );

end

// === f_lab_ai_main_trigger::: Trigger
script dormant f_lab_ai_main_trigger()
	sleep_until( zoneset_current_active() >= S_ZONESET_LAB, 1 );
//	//dprint( "::: f_lab_ai_main_trigger :::" );
	
	// init sub modules
//	wake( f_lab_ai_main_spawn );
	wake( f_lab_ai_main_human_spawn );
	wake( f_lab_ai_main_enemy_spawn );

end

/*
// === f_lab_ai_main_spawn::: Spawn
script dormant f_lab_ai_main_spawn()
//	//dprint( "::: f_lab_ai_main_spawn :::" );

	// phantoms
	wake( f_lab_ai_main_human_spawn );
	wake( f_lab_ai_main_enemy_spawn );

end
*/
// === f_lab_ai_main_human_spawn::: Spawn
script dormant f_lab_ai_main_human_spawn()
//	//dprint( "::: f_lab_ai_main_human_spawn :::" );

	//ai_allegiance( player, human );

	// place
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_lab_security_01 );
		object_cannot_take_damage( ai_actors(sq_lab_security_01) );
		units_set_maximum_vitality( ai_actors(sq_lab_security_01), object_get_maximum_vitality(sq_lab_security_01.01, FALSE) * 1.25, 0.0 );
		units_set_current_vitality( ai_actors(sq_lab_security_01), object_get_maximum_vitality(sq_lab_security_01.01, FALSE), 0.0 );

	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_lab_security_02 );
		object_cannot_take_damage( ai_actors(sq_lab_security_02) );
		unit_set_maximum_vitality( sq_lab_security_02.01, object_get_maximum_vitality(sq_lab_security_02.01, FALSE) * 0.75, 0.0 );
		unit_set_current_vitality( sq_lab_security_02.01, object_get_maximum_vitality(sq_lab_security_02.01, FALSE), 0.0 );

	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sq_lab_scientists );
		object_cannot_take_damage( ai_actors(sq_lab_scientists) );
		cs_push_stance( sq_lab_scientists, 'panic' );
		unit_set_maximum_vitality( sq_lab_scientists.01, object_get_maximum_vitality(sq_lab_scientists.01, FALSE) * real_random_range(0.50,0.75), 0.0 );
		unit_set_current_vitality( sq_lab_scientists.01, object_get_maximum_vitality(sq_lab_scientists.01, FALSE), 0.0 );

		unit_set_maximum_vitality( sq_lab_scientists.02, object_get_maximum_vitality(sq_lab_scientists.02, FALSE) * real_random_range(0.50,0.75), 0.0 );
		unit_set_current_vitality( sq_lab_scientists.02, object_get_maximum_vitality(sq_lab_scientists.02, FALSE), 0.0 );

		unit_set_maximum_vitality( sq_lab_scientists.03, object_get_maximum_vitality(sq_lab_scientists.03, FALSE) * real_random_range(0.50,0.75), 0.0 );
		unit_set_current_vitality( sq_lab_scientists.03, object_get_maximum_vitality(sq_lab_scientists.03, FALSE), 0.0 );

		unit_set_maximum_vitality( sq_lab_scientists.04, object_get_maximum_vitality(sq_lab_scientists.04, FALSE) * real_random_range(0.50,0.75), 0.0 );
		unit_set_current_vitality( sq_lab_scientists.04, object_get_maximum_vitality(sq_lab_scientists.04, FALSE), 0.0 );

	// undo any pre-setup
	sleep_until( f_lab_started(), 1 );
		object_can_take_damage( ai_actors(sq_lab_security_01) );
		object_can_take_damage( ai_actors(sq_lab_security_02) );
		object_can_take_damage( ai_actors(sq_lab_scientists) );

end

// === f_lab_ai_main_enemy_spawn::: Spawn
script dormant f_lab_ai_main_enemy_spawn()
//	//dprint( "::: f_lab_ai_main_enemy_spawn :::" );

	// place
	f_ai_spawn_delay_wait( TRUE, -1 );
	ai_place( sg_lab_hunters );
		object_cannot_take_damage( ai_actors(sg_lab_hunters) );

	// undo any pre-setup
	sleep_until( f_lab_started(), 1 );
		object_can_take_damage( ai_actors(sg_lab_hunters) );
		
	// sets up the shift cycler
	wake( f_lab_ai_main_enemy_center_shift );
	wake( f_lab_ai_main_enemy_hunting_watch );

end

// === f_lab_ai_main_enemy_center_shift::: Sets a flag which keeps the center Hunter moving more
script dormant f_lab_ai_main_enemy_center_shift()

	repeat
	
		S_lab_hunter_center_loc = random_range( 1, 3 );
		sleep_s( 2.5, 5.0 );
	
	until( f_lab_completed(), 1 );

end

// === f_lab_ai_main_enemy_hunting_watch::: Watches for when the hunters have been hunting for too long
script dormant f_lab_ai_main_enemy_hunting_watch()
local long l_timer = 0;
	//dprint( "::: f_lab_ai_main_enemy_hunting_watch :::" );

	sleep_until( f_lab_started(), 1 );
	repeat
	
		B_lab_hunters_hunting = ( ai_combat_status(sg_lab_hunters) <= ai_combat_status_uninspected ) and ( l_timer != 0 );
	
		if ( B_lab_hunters_hunting ) then
		
			//dprint( "::: f_lab_ai_main_enemy_hunting_watch: HUNTING :::" );
//			sleep_until( (ai_combat_status(sg_lab_hunters) > ai_combat_status_uninspected) and (volume_test_players_all(tv_lab_in_control_room) == FALSE) and volume_test_players(tv_lab_door_enter_close_in), 1 );
			sleep_until( (ai_combat_status(sg_lab_hunters) > ai_combat_status_uninspected) and volume_test_players(tv_lab_door_enter_close_in), 1 );
			l_timer = 0;
			
		else
		
			//dprint( "::: f_lab_ai_main_enemy_hunting_watch: FIGHTING :::" );
			sleep_until( ai_combat_status(sg_lab_hunters) <= ai_combat_status_uninspected, 1 );

			// start timer			
			//dprint( "::: f_lab_ai_main_enemy_hunting_watch: HUNTING TIMER :::" );
			l_timer = timer_stamp( 30.0 );
			
			sleep_until( timer_expired(l_timer) or (ai_combat_status(sg_lab_hunters) > ai_combat_status_uninspected), 1 );
			
			if ( ai_combat_status(sg_lab_hunters) > ai_combat_status_uninspected ) then
			
				//dprint( "::: f_lab_ai_main_enemy_hunting_watch: RETURN TO FIGHTING :::" );
				l_timer = 0;
				
			end
			
	 end 		
	
	until( f_lab_completed(), 1 );

end

script static boolean f_lab_ai_main_enemy_center_loc_use( short s_loc )
	( (S_lab_hunter_center_loc != s_loc) and not volume_test_players(tv_lab_area_center) );
end
