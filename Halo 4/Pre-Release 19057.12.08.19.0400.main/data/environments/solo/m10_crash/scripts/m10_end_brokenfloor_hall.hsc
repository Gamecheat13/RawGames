//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: DESTRUCTION: TEST
// -------------------------------------------------------------------------------------------------
/*
script static void test_broken_hall_destruction( real r_pos_final, real r_hall_time, real r_ceiling_time, real r_pos_step, real r_rewind_time, real r_between_time )
static real r_test_floor_pos = 0.0;
static real r_test_ceiling_pos = 0.0;
	//dprint( "::: test_broken_hall_destruction :::" );

	wake( f_brokenfloor_hall_init );
	wake( f_brokenfloor_hall_ceiling_action );
	wake( f_brokenfloor_hall_floor_action );

	repeat
		if ( r_pos_step >= 0.0 ) then
			repeat
					r_test_ceiling_pos = device_get_position(dm_broken_ceiling01) + r_pos_step;
					r_test_floor_pos = device_get_position(dm_broken_hall01) + r_pos_step;
					sleep_until( (device_get_position(dm_broken_ceiling01) >= r_test_ceiling_pos) and (device_get_position(dm_broken_hall01) >= r_test_floor_pos), 1 );
					inspect( device_get_position(dm_broken_hall01) );
					inspect( device_get_position(dm_broken_ceiling01) );
					set( game_speed, 0.0 );
			until( (device_get_position(dm_broken_hall01) >= r_pos_final) and (device_get_position(dm_broken_ceiling01) >= r_pos_final), 1 );
		end
		sleep_until( (device_get_position(dm_broken_hall01) >= r_pos_final) and (device_get_position(dm_broken_ceiling01) >= r_pos_final), 1 );
		if ( r_rewind_time >= 0.0 ) then
			sleep_s( r_between_time );
			device_animate_position( dm_broken_hall01, 0.0, r_rewind_time, 1.0, 0, TRUE );
			device_animate_position( dm_broken_ceiling01, 0.0, r_rewind_time, 1.0, 0, TRUE );
			f_brokenfloor_hall_ceiling_attach();
			sleep_s( r_between_time );
			dm_broken_hall01->animate_full( r_hall_time );
			dm_broken_ceiling01->animate_full( r_ceiling_time );
		end
	until ( r_rewind_time < 0.0, 1 );

end
*/
// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: HALL
// -------------------------------------------------------------------------------------------------
// variables
global short S_brokenfloor_hall_actions = 0;
global long L_brokenfloor_hall_rumble_low_ID = 0;
global long L_brokenfloor_hall_rumble_med_ID = 0;
// XXX replace 2 with 1 rumble trigger

// functions
// === f_brokenfloor_hall_init::: Initialize
script dormant f_brokenfloor_hall_init()
	//dprint( "::: f_brokenfloor_hall_init :::" );

	// initialize modules
	wake( f_brokenfloor_hall_ceiling_init );
	wake( f_brokenfloor_hall_floor_init );
	wake( f_brokenfloor_hall_post_init );
	
	// setup trigger
	wake( f_brokenfloor_hall_cleanup );
	wake( f_brokenfloor_hall_trigger );
	
end

// === f_brokenfloor_hall_deinit::: Deinitialize
script dormant f_brokenfloor_hall_deinit()
	//dprint( "::: f_brokenfloor_hall_deinit :::" );

	// kill functions
	sleep_forever( f_brokenfloor_hall_init );
	sleep_forever( f_brokenfloor_hall_cleanup );
	sleep_forever( f_brokenfloor_hall_trigger );
	sleep_forever( f_brokenfloor_hall_action );
	
	// deinitialize modules
	wake( f_brokenfloor_hall_ceiling_deinit );
	wake( f_brokenfloor_hall_floor_deinit );
	wake( f_brokenfloor_hall_post_deinit );

end

// === f_brokenfloor_hall_cleanup::: Cleanup
script dormant f_brokenfloor_hall_cleanup()
	dprint( "::: f_brokenfloor_hall_cleanup :::" );

	// XXX

end

// === f_brokenfloor_hall_trigger::: Triggers the event
script dormant f_brokenfloor_hall_trigger()
	sleep_until( volume_test_players(tv_breakinghallway_start), 1 );
	//dprint( "::: f_brokenfloor_hall_trigger :::" );

	//datamine
	data_mine_set_mission_segment( "m10_END_BrokenFloor_Hall" );

	// soften the trigger
	sleep_rand_s( 0.1, 0.25 );										

	// start the action
	wake( f_brokenfloor_hall_action );
	
	sleep( 1 );
	sleep_until( volume_test_players(tv_breakinghallway_area), 1 );
	if ( L_brokenfloor_hall_rumble_low_ID != 0 ) then
		L_brokenfloor_hall_rumble_low_ID = f_mission_screenshakes_rumble_low( -0.25 );
	end

end

// === f_brokenfloor_hall_action::: plays the action
script dormant f_brokenfloor_hall_action()

	// rumble
	L_brokenfloor_hall_rumble_low_ID = f_mission_screenshakes_rumble_low( -0.25 );
	
	// start the ceiling timer
	wake( f_brokenfloor_hall_ceiling_timer );

	// wait for all the actions to have triggered
	sleep_until( S_brokenfloor_hall_actions == 0, 1);

	// play dialog
	
	

	// soften the shutdown
	sleep_rand_s( 0.125, 0.225 );

	L_brokenfloor_hall_rumble_med_ID = f_screenshake_rumble_global_remove( L_brokenfloor_hall_rumble_med_ID, -1, 0.0 );
	L_brokenfloor_hall_rumble_low_ID = f_screenshake_rumble_global_remove( L_brokenfloor_hall_rumble_low_ID, -1, 0.5 );

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: HALL: CEILING
// -------------------------------------------------------------------------------------------------
// === f_brokenfloor_hall_ceiling_init::: Initialize
script dormant f_brokenfloor_hall_ceiling_init()
	sleep_until( object_valid(dm_broken_ceiling01), 1 );
	//dprint( "::: f_brokenfloor_hall_ceiling_init :::" );

	// increment action count
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions + 1;
	
	// attach monitors
	f_brokenfloor_hall_ceiling_attach();

	// setup force trigger
	wake( f_brokenfloor_hall_ceiling_force );

end

// === f_brokenfloor_hall_ceiling_attach::: Attach monitors to the ceiling
script static void f_brokenfloor_hall_ceiling_attach()
static long l_ceiling_thread = 0;
static long l_hall_thread = 0;
	//dprint( "::: f_brokenfloor_hall_ceiling_attach :::" );

	// attach monitor 01
	sleep_until( object_valid(cr_broken_ceiling01_monitor01), 1 );
	objects_physically_attach(dm_broken_ceiling01, "front_monitor_marker", cr_broken_ceiling01_monitor01, "monitor_marker" );
	if ( l_ceiling_thread != 0 ) then
		kill_thread( l_ceiling_thread );
		l_ceiling_thread = 0;
	end
	l_ceiling_thread = thread(dm_broken_ceiling01->front_monitor_detach(cr_broken_ceiling01_monitor01) );

	// attach monitor 02
	sleep_until( object_valid(cr_broken_ceiling01_monitor02), 1 );
	objects_physically_attach(dm_broken_ceiling01, "rear_monitor_marker", cr_broken_ceiling01_monitor02, "monitor_marker" );
	if ( l_hall_thread != 0 ) then
		kill_thread( l_hall_thread );
		l_hall_thread = 0;
	end
	l_hall_thread = thread(dm_broken_ceiling01->rear_monitor_detach(cr_broken_ceiling01_monitor02) );

end

// === f_brokenfloor_hall_ceiling_deinit::: Deinitialize
script dormant f_brokenfloor_hall_ceiling_deinit()

	// cleaning up, decrement counter
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions - 1;

	// kill functions
	sleep_forever( f_brokenfloor_hall_ceiling_init );
	sleep_forever( f_brokenfloor_hall_ceiling_force );
	sleep_forever( f_brokenfloor_hall_ceiling_timer );
	sleep_forever( f_brokenfloor_hall_ceiling_action );

end

// === f_brokenfloor_hall_ceiling_force::: force the action to trigger
script dormant f_brokenfloor_hall_ceiling_force()
	sleep_until( volume_test_players(tv_breakinghall01_ceiling_force), 1 );
	//dprint( "::: f_brokenfloor_hall_ceiling_force :::" );
	
	sleep_forever( f_brokenfloor_hall_ceiling_timer );
	wake( f_brokenfloor_hall_ceiling_action );

end	

// === f_brokenfloor_hall_ceiling_timer::: waits for timer to trigger
script dormant f_brokenfloor_hall_ceiling_timer()

	sleep_rand_s( 0.0, 0.125 );
	sleep_forever( f_brokenfloor_hall_ceiling_force );
	wake( f_brokenfloor_hall_ceiling_action );

end	

// === f_brokenfloor_hall_ceiling_action::: Plays the ceiling action
script dormant f_brokenfloor_hall_ceiling_action()

	if ( object_valid(dm_broken_ceiling01) ) then
		// animate
		dm_broken_ceiling01->animate_full( -1 );
	end

	// start the floor timer
	wake( f_brokenfloor_hall_floor_timer );

	// cleanup
	wake( f_brokenfloor_hall_ceiling_deinit );

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: HALL: FLOOR
// -------------------------------------------------------------------------------------------------
// === f_brokenfloor_hall_floor_init::: Initialize
script dormant f_brokenfloor_hall_floor_init()
	sleep_until( object_valid(dm_broken_hall01), 1 );
	//dprint( "::: f_brokenfloor_hall_floor_init :::" );

	// increment action count
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions + 1;

	// setup force trigger
	wake( f_brokenfloor_hall_floor_force );

end

// === f_brokenfloor_hall_floor_deinit::: Deinitialize
script dormant f_brokenfloor_hall_floor_deinit()
	//dprint( "::: f_brokenfloor_hall_floor_deinit :::" );

	// action triggered, decrement action count
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions - 1;

	// kill functions
	sleep_forever( f_brokenfloor_hall_floor_init );
	sleep_forever( f_brokenfloor_hall_floor_force );
	sleep_forever( f_brokenfloor_hall_floor_timer );
	sleep_forever( f_brokenfloor_hall_floor_action );

end

// === f_brokenfloor_hall_floor_force::: If player is nearing the end, force the break to happen
script dormant f_brokenfloor_hall_floor_force()

	sleep_until( volume_test_players(tv_breakinghallway_force), 1 );
	//dprint( "::: f_brokenfloor_hall_floor_force :::" );
	sleep_forever( f_brokenfloor_hall_floor_timer );
	wake( f_brokenfloor_hall_floor_action );

end

// === f_brokenfloor_hall_floor_timer::: Timer that triggers the floor break
script dormant f_brokenfloor_hall_floor_timer()

	sleep_rand_s( 2.5, 3.5 );
	//dprint( "::: f_brokenfloor_hall_floor_timer :::" );
	sleep_forever( f_brokenfloor_hall_floor_force );
	wake( f_brokenfloor_hall_floor_action );

end

// === f_brokenfloor_hall_floor_action::: Handles the all the animations, etc. for when the floor breaks
script dormant f_brokenfloor_hall_floor_action()
	//dprint( "::: f_brokenfloor_hall_floor_action :::" );
	
	if ( object_valid(dm_broken_hall01) ) then
		// trigger the explosion at the end of the hallway
		thread( f_explosion_flag_small(flg_breakinghallway_explosion01a, TRUE, FALSE) );
		
		// shake the camera
		thread( f_screenshake_event_med(-0.75, -1, -0.125, sfx_breaking_hallway()) );	// XXX make stronger if you're in the area
		
		// animate the floor to move
		dm_broken_hall01->animate_full( -1 );
	end

	// post explosion
	wake( f_brokenfloor_hall_post_timer );

	// cleanup
	wake( f_brokenfloor_hall_floor_deinit );

end



// -------------------------------------------------------------------------------------------------
// HALLWAY: POST
// -------------------------------------------------------------------------------------------------
// === f_brokenfloor_hall_post_init::: Module initialization
script dormant f_brokenfloor_hall_post_init()
	//dprint( "::: f_brokenfloor_hall_post_init :::" );

	// increment action count
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions + 1;

	// setup force trigger
	wake( f_brokenfloor_hall_post_force );

end

// === f_brokenfloor_hall_post_deinit::: Deinitialize
script dormant f_brokenfloor_hall_post_deinit()
	//dprint( "::: f_brokenfloor_hall_post_deinit :::" );

	// cleaning up, decrement counter
	S_brokenfloor_hall_actions = S_brokenfloor_hall_actions - 1;

	// kill functions
	sleep_forever( f_brokenfloor_hall_post_init );
	sleep_forever( f_brokenfloor_hall_post_force );
	sleep_forever( f_brokenfloor_hall_post_timer );
	sleep_forever( f_brokenfloor_hall_post_action );

end

// === f_brokenfloor_hall_post_force::: If player is nearing the end, force the break to happen
script dormant f_brokenfloor_hall_post_force()

	sleep_until( volume_test_players(tv_breakinghallway_force), 1 );
	//dprint( "::: f_brokenfloor_hall_post_force :::" );
	sleep_forever( f_brokenfloor_hall_post_timer );
	wake( f_brokenfloor_hall_post_action );

end

// === f_breakinghall01_post_timer::: If player is nearing the end, force the break to happen
script dormant f_brokenfloor_hall_post_timer()

	sleep_rand_s( 0.1, 0.15 );
	//dprint( "::: f_breakinghall01_post_timer :::" );
	sleep_forever( f_brokenfloor_hall_post_force );
	wake( f_brokenfloor_hall_post_action );

end

// === f_brokenfloor_hall_post_action::: Handles the all the animations, etc. for when the floor breaks
script dormant f_brokenfloor_hall_post_action()
	//dprint( "::: f_brokenfloor_hall_post_action :::" );

	thread( f_explosion_flag_large(flg_breakinghallway_explosion01b, TRUE, TRUE) );

	// cleanup
	wake( f_brokenfloor_hall_post_deinit );

end
