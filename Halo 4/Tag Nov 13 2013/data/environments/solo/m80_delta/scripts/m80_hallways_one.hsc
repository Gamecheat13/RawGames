//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_hallways (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS: ONE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_startup::: Startup
script startup f_hallways_one_startup()
	sleep_until( b_mission_started, 1 );
	//dprint( "::: f_hallways_one_startup :::" );

	// init hallways
	wake( f_hallways_one_init );

end

// === f_hallways_one_init::: Initialize
script dormant f_hallways_one_init()
	//dprint( "::: f_hallways_one_init :::" );
	
	// setup cleanup
	wake( f_hallways_one_cleanup );
	
	// wait for init condition
	sleep_until( (zoneset_current() >= S_ZONESET_ATRIUM_HUB) and (zoneset_current() <= S_ZONESET_TO_AIRLOCK_ONE_B), 1 ); 
	
	// init modules
	wake( f_hallways_one_ai_init );
	wake( f_hallways_one_narrative_init );
	
	// init sub modules
	wake( f_hallways_one_doors_init );
	wake( f_hallways_one_props_init );
	wake( f_hallways_one_puppeteer_init );
	
	// setup trigger
	wake( f_hallways_one_trigger );

end

// === f_hallways_one_deinit::: Deinitialize
script dormant f_hallways_one_deinit()
	//dprint( "::: f_hallways_one_deinit :::" );
	
	// deinit modules
	wake( f_hallways_one_ai_deinit );
	wake( f_hallways_one_narrative_deinit );

	// deinit sub modules
	wake( f_hallways_one_doors_deinit );
	wake( f_hallways_one_props_deinit );
	wake( f_hallways_one_puppeteer_deinit );

	// kill functions
	kill_script( f_hallways_one_init );
	kill_script( f_hallways_one_trigger );

end

// === f_hallways_one_cleanup::: Cleanup
script dormant f_hallways_one_cleanup()
	sleep_until( zoneset_current_active() > S_ZONESET_TO_AIRLOCK_ONE_B, 1 );
	//dprint( "::: f_hallways_one_cleanup :::" );

	// Deinitialize
	wake( f_hallways_one_deinit );

	// collect garbages
	garbage_collect_now();

end

// === f_hallways_one_trigger::: Trigger
script dormant f_hallways_one_trigger()
	sleep_until( zoneset_current_active() >= S_ZONESET_TO_AIRLOCK_ONE, 1 );
	//dprint( "::: f_hallways_one_trigger :::" );

	// trigger action
	wake( f_hallways_one_start );

	// checkpoint
	sleep_until( f_ai_is_defeated(sg_hallways_one_enemies) and (ai_spawn_count(sg_hallways_one_enemies_third) > 0), 1 );
	checkpoint_no_timeout( TRUE, "f_hallways_one_trigger: COMPLETE" );
	
end

// === f_hallways_one_start::: xxx
script dormant f_hallways_one_start()
	//dprint( "::: f_hallways_one_start :::" );

	// setup data mining
	data_mine_set_mission_segment( "m80_Hallways_One" );
	
	// set objective
	f_objective_set( DEF_R_OBJECTIVE_HALLWAYS_ONE(), TRUE, FALSE, FALSE, TRUE );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_atrium_door_exit_trigger" );
	
end

 

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: PUPPETEER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_puppeteer_init::: Init
script dormant f_hallways_one_puppeteer_init()
	//dprint( "::: f_hallways_one_puppeteer_init :::" );
	
	// setup trigger
	wake( f_hallways_one_puppeteer_trigger );
	
end

// === f_hallways_one_puppeteer_deinit::: Deinit
script dormant f_hallways_one_puppeteer_deinit()
	//dprint( "::: f_hallways_one_puppeteer_deinit :::" );
	
	// erase the hub guy
	ai_erase( sq_atrium_hub_humans );
	
	// kill functions
	kill_script( f_hallways_one_puppeteer_init );
	kill_script( f_hallways_one_puppeteer_trigger );
	kill_script( f_hallways_one_puppeteer_action );
	
end

// === f_hallways_one_puppeteer_trigger::: Trigger
script dormant f_hallways_one_puppeteer_trigger()
	//sleep_until( (ai_spawn_count(sq_atrium_hub_humans) > 0) and ((zoneset_current_active() == S_ZONESET_ATRIUM_HUB) or (door_atrium_exit_maya->position_not_close_check())), 1 );
	sleep_until( ai_spawn_count(sq_atrium_hub_humans) > 0, 1 );
	//dprint( "::: f_hallways_one_puppeteer_trigger :::" );

	// trigger action
	wake( f_hallways_one_puppeteer_action );
	
	// checkpoint
	sleep_until( f_hallways_one_door_hub_exit_open_get() and (zoneset_current_active() == S_ZONESET_TO_AIRLOCK_ONE), 1 );
	checkpoint_no_timeout( TRUE, "f_hallways_one_puppeteer_trigger: ZONE CHANGE" );
	
end

// === f_hallways_one_puppeteer_action::: Action
script dormant f_hallways_one_puppeteer_action()
local long l_pup_id = -1;
	//dprint( "::: f_hallways_one_puppeteer_action :::" );

	// starting show
	if ( (not ai_allegiance_broken(player, human)) and (not f_ai_is_defeated(sq_atrium_hub_humans)) ) then
		l_pup_id = pup_play_show( 'pup_atrium_hub_start' );
		sleep_until( not pup_is_playing(l_pup_id), 1 );
	end

	// open door
	sleep_until( zoneset_current() == S_ZONESET_TO_AIRLOCK_ONE, 1 );
	repeat
		sleep_until( (not ai_allegiance_broken(player, human)) or (ai_living_count(sq_atrium_hub_humans) <= 0), 1 );

		if ( ai_living_count(sq_atrium_hub_humans) > 0 ) then
		
			l_pup_id = pup_play_show( 'pup_atrium_hub_door_open' );
			sleep_until( not pup_is_playing(l_pup_id), 1 );
		
		end
	
	until( f_hallways_one_door_hub_exit_open_get() or (ai_living_count(sq_atrium_hub_humans) <= 0), 1 );

	// marine is finished
	if ( ai_living_count(sq_atrium_hub_humans) > 0 ) then
		cs_run_command_script( sq_atrium_hub_humans.male, cs_hallways_one_hub_marine_01 );
	end
	
	sleep_until( ai_living_count(sq_atrium_hub_humans) <= 0, 1 );
	wake( f_dialog_m80_post_atrium_officer_killed );
	sleep_s( 1.0 );
	if ( not f_hallways_one_door_hub_exit_open_get() ) then
	
		sleep_until( f_hallways_one_puppeteer_open_ready(), 1 );
		wake( f_dialog_m80_post_atrium_officer_hostile );
		
	end

end

// === f_hallways_one_puppeteer_check_action::: Check if the puppet should get up
script static boolean f_hallways_one_puppeteer_check_action()
static boolean b_return = FALSE;

	if ( not b_return ) then
		b_return = ( ai_living_count(sq_atrium_hub_humans) > 0 ) and ( not ai_allegiance_broken(player, human) ) and ( volume_test_players(tv_hallways_one_hub_pup) or (zoneset_current() == S_ZONESET_TO_AIRLOCK_ONE) );
	end

	// return
	b_return;

end

// === f_hallways_one_puppeteer_open_ready::: Check if the door is ready to open
script static boolean f_hallways_one_puppeteer_open_ready()
static boolean b_ready = FALSE;

	if ( not b_ready ) then
		b_ready = zoneset_prepare_complete( S_ZONESET_TO_AIRLOCK_ONE );
	end
	
	// return
	b_ready;

end

     
     
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: PROPS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_props_init::: Init
script dormant f_hallways_one_props_init()
	//dprint( "::: f_hallways_one_props_init :::" );
	
	// init sub modules
	wake( f_hallways_one_props_a_init );
	wake( f_hallways_one_props_b_init );
	
end

// === f_hallways_one_props_deinit::: Deinit
script dormant f_hallways_one_props_deinit()
	//dprint( "::: f_hallways_one_props_deinit :::" );

	// deinit sub modules
	wake( f_hallways_one_props_a_deinit );
	wake( f_hallways_one_props_b_deinit );
	
	// kill functions
	kill_script( f_hallways_one_props_init );
	
end
   
     
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: PROPS: A
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_props_a_init::: Init
script dormant f_hallways_one_props_a_init()
	sleep_until( zoneset_current_active() == S_ZONESET_TO_AIRLOCK_ONE, 1 );
	//dprint( "::: f_hallways_one_props_a_init :::" );

	object_create_folder( 'crates_to_airlock_one_a' );
	//object_create_folder( 'scenery_to_airlock_one_a' );
	//object_create_folder( 'equipment_to_airlock_one_a' );
	//object_create_folder( 'weapons_to_airlock_one_a' );
	
end

// === f_hallways_one_props_a_deinit::: Deinit
script dormant f_hallways_one_props_a_deinit()
	//dprint( "::: f_hallways_one_props_a_deinit :::" );

	object_destroy_folder( 'crates_to_airlock_one_a' );
	//object_destroy_folder( 'scenery_to_airlock_one_a' );
	
	// kill functions
	kill_script( f_hallways_one_props_a_init );
	
end
    
     
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: PROPS: B
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_props_b_init::: Init
script dormant f_hallways_one_props_b_init()
	sleep_until( (S_ZONESET_TO_AIRLOCK_ONE <= zoneset_current_active()) and (zoneset_current_active() <= S_ZONESET_TO_AIRLOCK_ONE_B), 1 );
	//dprint( "::: f_hallways_one_props_b_init :::" );
	
	object_create_folder( 'crates_to_airlock_one_b' );
//	object_create_folder( 'scenery_to_airlock_one_b' );
	object_create_folder( 'equipment_to_airlock_one_b' );
	object_create_folder( 'weapons_to_airlock_one_b' );
	object_create_folder( 'vehicles_to_airlock_one_b' );
	
end

// === f_hallways_one_props_b_deinit::: Deinit
script dormant f_hallways_one_props_b_deinit()
	//dprint( "::: f_hallways_one_props_b_deinit :::" );

	// create	
	object_destroy_folder( 'crates_to_airlock_one_b' );
//	object_destroy_folder( 'scenery_to_airlock_one_b' );
	
	// kill functions
	kill_script( f_hallways_one_props_b_init );
	
end   
     

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_hallways_one_doors_break_time = 0.75;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_doors_init::: Init
script dormant f_hallways_one_doors_init()
	//dprint( "::: f_hallways_one_doors_init :::" );
	
	// init sub modules
	wake( f_hallways_one_door_hub_exit_init );
	wake( f_hallways_one_door_mid_init );
	wake( f_hallways_one_door_last_init );
	
end

// === f_hallways_one_doors_deinit::: Deinit
script dormant f_hallways_one_doors_deinit()
	//dprint( "::: f_hallways_one_doors_deinit :::" );

	// deinit sub modules
	wake( f_hallways_one_door_hub_exit_deinit );
	wake( f_hallways_one_door_mid_deinit );
	wake( f_hallways_one_door_last_deinit );
	
	// kill functions
	kill_script( f_hallways_one_doors_init );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: DOOR: HUB EXIT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_hallways_one_door_hub_exit_open = FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_door_hub_exit_init::: Init
script dormant f_hallways_one_door_hub_exit_init()
	sleep_until( object_valid(door_atrium_hub_exit_maya) and object_active_for_script(door_atrium_hub_exit_maya), 1 );
	//dprint( "::: f_hallways_one_door_hub_exit_init :::" );

	// setup trigger
	wake( f_hallways_one_door_hub_exit_trigger );
	
end

// === f_hallways_one_door_hub_exit_deinit::: Deinit
script dormant f_hallways_one_door_hub_exit_deinit()
	//dprint( "::: f_hallways_one_door_hub_exit_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_one_door_hub_exit_init );
	kill_script( f_hallways_one_door_hub_exit_trigger );
	
end

// === f_hallways_one_door_hub_exit_trigger::: Trigger
script dormant f_hallways_one_door_hub_exit_trigger()
local long l_thread = 0;
	//dprint( "::: f_hallways_one_door_hub_exit_trigger :::" );

	// condition
	sleep_until( f_hallways_one_door_hub_exit_open_get(), 1 );
	
	// open
	door_atrium_hub_exit_maya->speed_open( 5.5 );
	door_atrium_hub_exit_maya->zoneset_auto_open_setup( S_ZONESET_TO_AIRLOCK_ONE, TRUE, TRUE, -1, S_ZONESET_TO_AIRLOCK_ONE, TRUE );
	repeat
		sleep_until( f_hallways_one_narrative_powerloss_active() == FALSE, 1 );
	
		// power		
		door_atrium_hub_exit_maya->power_auto_enabled( TRUE );

		// open		
		kill_thread( l_thread );
		l_thread = thread( door_atrium_hub_exit_maya->open() );

		// wait	
		sleep_until( door_atrium_hub_exit_maya->position_open_check() or f_hallways_one_narrative_powerloss_active(), 1 );

		// powerloss
		if ( f_hallways_one_narrative_powerloss_active() ) then

			// power		
			door_atrium_hub_exit_maya->power_auto_enabled( FALSE );
			door_atrium_hub_exit_maya->power_active( FALSE );

			// stop
			door_atrium_hub_exit_maya->stop( R_hallways_one_doors_break_time );
			
		end

	until ( door_atrium_hub_exit_maya->position_open_check() or (object_valid(door_atrium_hub_exit_maya) == FALSE), 1 );

	// checkpoint
	checkpoint_no_timeout( TRUE, "f_hallways_one_door_hub_exit_trigger" );

	// close
	repeat
		sleep_until( f_hallways_one_narrative_powerloss_active() == FALSE, 1 );
	
		// power		
		door_atrium_hub_exit_maya->power_auto_enabled( TRUE );

		// close
		kill_thread( l_thread );
		l_thread = thread( door_atrium_hub_exit_maya->auto_trigger_close(tv_hallways_one_hub_area, TRUE, FALSE, TRUE) );

		// wait	
		sleep_until( door_atrium_hub_exit_maya->position_close_check() or f_hallways_one_narrative_powerloss_active(), 1 );

		// powerloss
		if ( f_hallways_one_narrative_powerloss_active() ) then

			// power		
			door_atrium_hub_exit_maya->power_auto_enabled( FALSE );
			door_atrium_hub_exit_maya->power_active( FALSE );

			// stop
			door_atrium_hub_exit_maya->stop( R_hallways_one_doors_break_time );
			
		end

	until( door_atrium_hub_exit_maya->position_close_check() or (object_valid(door_atrium_hub_exit_maya) == FALSE), 1 );
	
	// restore allegiance in case player broke it in atrium
	ai_allegiance( player, human );
	
	// deinit pup
	wake( f_hallways_one_puppeteer_deinit );

	// force closed
	door_atrium_hub_exit_maya->close_immediate();
	
	// cleanup hub HAX
//	kill_script( f_hallways_one_puppeteer_action );

end

script static void f_hallways_one_door_hub_exit_open_set()
	B_hallways_one_door_hub_exit_open = TRUE;
end

script static boolean f_hallways_one_door_hub_exit_open_get()
	B_hallways_one_door_hub_exit_open;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: DOOR: MID
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_door_mid_init::: Init
script dormant f_hallways_one_door_mid_init()
	sleep_until( object_valid(door_to_airlock_one_mid_way) and object_active_for_script(door_to_airlock_one_mid_way), 1 );
	//dprint( "::: f_hallways_one_door_mid_init :::" );

	// setup door
	//door_to_airlock_one_mid_way->speed_setup( 5.0 );
	
	// setup trigger
	wake( f_hallways_one_door_mid_trigger );
	
end

// === f_hallways_one_door_mid_deinit::: Deinit
script dormant f_hallways_one_door_mid_deinit()
	//dprint( "::: f_hallways_one_door_mid_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_one_door_mid_init );
	kill_script( f_hallways_one_door_mid_trigger );
	
end

script static boolean f_hallways_one_door_close_check()
	f_hallways_one_narrative_powerloss_active()
	or 
	(
		( f_ai_killed_cnt(sg_hallways_one_enemies) >= 1 )
		and 
		( not volume_test_players(tv_hallways_one_mid_behind) )
		and
		volume_test_objects( tv_hallways_one_mid_behind, ai_actors(sg_hallways_one_enemies) )
		and
		( not volume_test_objects(tv_hallways_one_mid_front, ai_actors(sg_hallways_one_enemies)) ) 
	);
end

// === f_hallways_one_door_mid_trigger::: Trigger
script dormant f_hallways_one_door_mid_trigger()
local long l_thread = 0;
local boolean b_condition = FALSE;
local long l_timer = 0;
local short s_enemy_cnt = 0;
	//dprint( "::: f_hallways_one_door_mid_trigger :::" );

	// condition
	sleep_until( ai_spawn_count(sg_hallways_one_enemies) > 0, 1 );

	// open
	repeat
		sleep_until( f_hallways_one_narrative_powerloss_active() == FALSE, 1 );

		// power		
		door_to_airlock_one_mid_way->power_auto_enabled( TRUE );

		// open		
		kill_thread( l_thread );
		l_thread = thread( door_to_airlock_one_mid_way->open() );

		// wait	
		sleep_until( door_to_airlock_one_mid_way->position_open_check() or f_hallways_one_narrative_powerloss_active(), 1 );

		// powerloss
		if ( f_hallways_one_narrative_powerloss_active() ) then

			// power		
			door_to_airlock_one_mid_way->power_auto_enabled( FALSE );
			door_to_airlock_one_mid_way->power_active( FALSE );

			// stop
			door_to_airlock_one_mid_way->stop( R_hallways_one_doors_break_time );
			
		end

	until ( door_to_airlock_one_mid_way->position_open_check() or (object_valid(door_to_airlock_one_mid_way) == FALSE), 1 );

	// door close condtion
	repeat
		b_condition = f_hallways_one_door_close_check();
		l_timer = timer_stamp( 0.75 );
		s_enemy_cnt = ai_living_count(sg_hallways_one_enemies);
		sleep_until( f_hallways_one_narrative_powerloss_active() or (f_hallways_one_door_close_check() != b_condition) or (b_condition and timer_expired(l_timer)) or (ai_living_count(sg_hallways_one_enemies) != s_enemy_cnt), 1 );
	until( f_hallways_one_narrative_powerloss_active() or (b_condition and timer_expired(l_timer)) or (ai_living_count(sg_hallways_one_enemies) <= 0), 1 );

	if ( f_hallways_one_narrative_powerloss_active() ) then
		door_to_airlock_one_mid_way->power_auto_enabled( TRUE );
		door_to_airlock_one_mid_way->power_active( FALSE );
	end

	// close
	thread( door_to_airlock_one_mid_way->close() );

	sleep_until( f_hallways_one_narrative_powerloss_active(), 1 );
	door_to_airlock_one_mid_way->power_auto_enabled( TRUE );
	door_to_airlock_one_mid_way->power_active( FALSE );



/*
	// door close condtion
	repeat
		b_condition = f_hallways_one_door_close_check();
		l_timer = timer_stamp( 0.75 );
		s_enemy_cnt = ai_living_count(sg_hallways_one_enemies);
		sleep_until( (f_hallways_one_door_close_check() != b_condition) or (b_condition and timer_expired(l_timer)) or (ai_living_count(sg_hallways_one_enemies) != s_enemy_cnt), 1 );
	until( (b_condition and timer_expired(l_timer)) or (ai_living_count(sg_hallways_one_enemies) <= 0), 1 );

	// close
	if ( f_hallways_one_door_close_check() ) then
		repeat
			sleep_until( f_hallways_one_narrative_powerloss_active() == FALSE, 1 );
	
			// power		
			door_to_airlock_one_mid_way->power_auto_enabled( TRUE );
	
			// close		
			kill_thread( l_thread );
			l_thread = thread( door_to_airlock_one_mid_way->close() );
	
			// wait	
			sleep_until( door_to_airlock_one_mid_way->position_close_check() or f_hallways_one_narrative_powerloss_active(), 1 );
	
			// powerloss
			if ( f_hallways_one_narrative_powerloss_active() ) then
	
				// power		
				door_to_airlock_one_mid_way->power_auto_enabled( FALSE );
				door_to_airlock_one_mid_way->power_active( FALSE );
	
				// stop
				door_to_airlock_one_mid_way->stop( R_hallways_one_doors_break_time );
				
			end
	
		until ( door_to_airlock_one_mid_way->position_close_check() or (object_valid(door_to_airlock_one_mid_way) == FALSE), 1 );
	end
*/
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: DOOR: LAST
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_hallways_one_door_last_init::: Init
script dormant f_hallways_one_door_last_init()
	sleep_until( object_valid(door_to_airlock_one_exit) and object_active_for_script(door_to_airlock_one_exit), 1 );
	//dprint( "::: f_hallways_one_door_last_init :::" );

	// setup door
	door_to_airlock_one_exit->speed_setup( 5.0 );
	
	if ( zoneset_current() < S_ZONESET_TO_AIRLOCK_ONE_B ) then

		// setup trigger
		wake( f_hallways_one_door_last_trigger );
	
		// setup auto disable	
		door_to_airlock_one_exit->auto_enabled_zoneset( FALSE, S_ZONESET_TO_AIRLOCK_ONE_B, -1 );

		// force closed
		sleep_until( zoneset_current() >= S_ZONESET_TO_AIRLOCK_ONE_B, 1 );
		kill_script( f_hallways_one_door_last_trigger );
		
		sleep_until( object_valid(door_to_airlock_one_exit) and object_active_for_script(door_to_airlock_one_exit), 1 );
		door_to_airlock_one_exit->close_immediate();

	end
	
end

// === f_hallways_one_door_last_deinit::: Deinit
script dormant f_hallways_one_door_last_deinit()
	//dprint( "::: f_hallways_one_door_last_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_one_door_last_init );
	kill_script( f_hallways_one_door_last_trigger );
	
end

// === f_hallways_one_door_last_trigger::: Trigger
script dormant f_hallways_one_door_last_trigger()
	//dprint( "::: f_hallways_one_door_last_trigger :::" );

	// startup condition
	sleep_until(
		(
			( f_hallways_one_narrative_powerloss_active() == FALSE )
			and
			(
				f_ai_is_defeated( sg_hallways_one_enemies_first )
				or
				(
					f_hallways_one_narrative_powerloss_complete()
					and
					volume_test_players( tv_hallway_one_access_found_b )
				)
				or
				(
					f_hallways_one_narrative_powerloss_none()
					and
					( objects_distance_to_object(Players(), door_to_airlock_one_exit) <= 8.75 )
					and
					objects_can_see_object( Players(), door_to_airlock_one_exit, 15.0 )
				)
			)
		)
	, 1 );

	// open
	repeat
		sleep_until( (f_hallways_one_narrative_powerloss_active() == FALSE) and object_valid(door_to_airlock_one_exit) and object_active_for_script(door_to_airlock_one_exit), 1 );
	
		// power		
		door_to_airlock_one_exit->power_auto_enabled( TRUE );

		// open	
		door_to_airlock_one_exit->open( -1.0, FALSE );

		// wait	
		sleep_until( door_to_airlock_one_exit->position_open_check() or f_hallways_one_narrative_powerloss_active(), 1 );

		// powerloss
		if ( f_hallways_one_narrative_powerloss_active() ) then

			// power		
			door_to_airlock_one_exit->power_auto_enabled( FALSE );
			door_to_airlock_one_exit->power_active( FALSE );

			// stop
			door_to_airlock_one_exit->stop( R_hallways_one_doors_break_time );
			
		end

	until ( (f_hallways_one_narrative_powerloss_active() == FALSE) and door_to_airlock_one_exit->position_open_check(), 1 );

	// close
	sleep_until( f_hallways_one_narrative_powerloss_complete() and object_valid(door_to_airlock_one_exit) and object_active_for_script(door_to_airlock_one_exit), 1 );
	door_to_airlock_one_exit->open( -1.0, FALSE );
	door_to_airlock_one_exit->zoneset_auto_close_setup( S_ZONESET_TO_AIRLOCK_ONE_B, TRUE, TRUE, -1, S_ZONESET_TO_AIRLOCK_ONE_B, TRUE );
	door_to_airlock_one_exit->auto_trigger_close( tv_door_to_airlock_one_exit_close_out, TRUE, FALSE, TRUE );

end
