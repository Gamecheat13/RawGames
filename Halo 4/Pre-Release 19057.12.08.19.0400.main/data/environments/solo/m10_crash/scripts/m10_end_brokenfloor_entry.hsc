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
script static void test_broken_blocker_destruction( real r_pos_final, real r_start_time, real r_full_time, real r_pos_step, real r_rewind_time, real r_between_time )
static real r_test_pos = 0.0;
	//dprint( "::: test_broken_blocker_destruction :::" );

	wake( f_brokenfloor_blocker_start );

	repeat
		if ( r_pos_step >= 0.0 ) then
			repeat
					r_test_pos = device_get_position(dm_broken_brokendoor) + r_pos_step;
					sleep_until( device_get_position(dm_broken_brokendoor) >= r_test_pos, 1 );
					inspect( device_get_position(dm_broken_brokendoor) );
					set( game_speed, 0.0 );
			until( device_get_position(dm_broken_brokendoor) >= r_pos_final, 1 );
		end
		sleep_until( device_get_position(dm_broken_brokendoor) >= r_pos_final, 1 );
		
		if ( r_rewind_time >= 0.0 ) then
			sleep_s( r_between_time );
			device_animate_position( dm_broken_brokendoor, 0.0, r_rewind_time, 1.0, 0, TRUE );
			sleep_until( device_get_position(dm_broken_brokendoor) == 0.0, 1 );
			sleep_s( r_between_time );
			dm_broken_blocker01->animate_start( r_start_time );
			sleep_s( r_between_time );
			dm_broken_blocker01->animate_full( r_start_time );
			sleep_s( r_between_time );
		end
	until ( r_rewind_time < 0.0, 1 );

end
*/

// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: ENTRY
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_brokenfloor_entry_init::: Initialize
script dormant f_brokenfloor_entry_init()
	//dprint( "::: f_brokenfloor_entry_init :::" );

	// initialize modules
	wake( f_brokenfloor_entry_door_init );
	wake( f_brokenfloor_blocker_init );

end

// === f_brokenfloor_entry_deinit::: Deinitialize
script dormant f_brokenfloor_entry_deinit()
	//dprint( "::: f_brokenfloor_entry_deinit :::" );


	// deinitialize modules
	wake( f_brokenfloor_entry_door_deinit );
	wake( f_brokenfloor_blocker_deinit );

end

// === f_brokenfloor_entry_cleanup::: Cleanup
script dormant f_brokenfloor_entry_cleanup()
	dprint( "::: f_brokenfloor_entry_cleanup :::" );

	// XXX

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: ENTRY: JITTER DOOR
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_brokenfloor_entry_door_init::: Initialize
script dormant f_brokenfloor_entry_door_init()
	sleep_until( object_valid(dm_broken_brokendoor), 1 );
	//dprint( "::: f_brokenfloor_entry_door_init :::" );

	// start animating	
	dm_broken_brokendoor->set_jittering( TRUE );
	
end

// === f_end_pathblocker01_deinit::: Deinitialize
script dormant f_brokenfloor_entry_door_deinit()
	//dprint( "::: f_end_pathblocker01_deinit :::" );

	// kill any functions
	sleep_forever( f_brokenfloor_entry_door_init );
	sleep_forever( f_brokenfloor_entry_door_stop );

end

// === f_brokenfloor_entry_door_stop::: start the jitter door
script dormant f_brokenfloor_entry_door_stop()
	//dprint( "::: f_brokenfloor_entry_door_stop :::" );

	if ( object_valid(dm_broken_brokendoor) ) then
		dm_broken_brokendoor->set_jittering( FALSE );
	end
	
	// deinitialize
	wake( f_brokenfloor_entry_door_deinit );

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: ENTRY: BLOCKER
// -------------------------------------------------------------------------------------------------
// variables
global long L_brokenfloor_blocker_rumble_ID = 0;

// functions
// === f_brokenfloor_blocker_init::: Initialize
script dormant f_brokenfloor_blocker_init()
	sleep_until( object_valid(dm_broken_blocker01), 1 );
	//dprint( "::: f_brokenfloor_blocker_init :::" );
	
	wake( f_brokenfloor_blocker_trigger );

end

// === f_brokenfloor_blocker_deinit::: Deinitialize
script dormant f_brokenfloor_blocker_deinit()
	//dprint( "::: f_brokenfloor_blocker_deinit :::" );

	// kill any functions
	sleep_forever( f_brokenfloor_blocker_init );
	sleep_forever( f_brokenfloor_blocker_trigger );
	sleep_forever( f_brokenfloor_blocker_force );
	sleep_forever( f_brokenfloor_blocker_timer );
	sleep_forever( f_brokenfloor_blocker_action );

end

// === f_brokenfloor_blocker_trigger::: Trigger the event
script dormant f_brokenfloor_blocker_trigger()
	sleep_until(  volume_test_players(tv_end_pathblocker01_start), 1 );
	//dprint( "::: f_brokenfloor_blocker_trigger :::" );

	wake( f_brokenfloor_blocker_start );

end

// === f_brokenfloor_blocker_trigger::: Trigger the event
script dormant f_brokenfloor_blocker_start()
	//dprint( "::: f_brokenfloor_blocker_trigger :::" );

	//datamine
	data_mine_set_mission_segment( "m10_END_BrokenFloor_Entry" );

	L_brokenfloor_blocker_rumble_ID = f_mission_screenshakes_rumble_low( -0.125 );

	// setup functions to trigger the action
	wake( f_brokenfloor_blocker_force );
	wake( f_brokenfloor_blocker_timer );

	static long l_timer = game_tick_get() + seconds_to_frames( 2.5 );
	sleep_until( (l_timer < game_tick_get()) or volume_test_players(tv_end_pathblocker01_force) or volume_test_players_lookat(tv_end_pathblocker01_force, 25.0, 5.0), 1 );
	
	// move it a little bit
	dm_broken_blocker01->animate_start( -1 );

end

// === f_brokenfloor_blocker_force::: force the action to trigger
script dormant f_brokenfloor_blocker_force()

	sleep_until( volume_test_players(tv_end_pathblocker01_force), 1 );
	//dprint( "::: f_brokenfloor_blocker_force :::" );
	sleep_forever( f_brokenfloor_blocker_timer );
	wake( f_brokenfloor_blocker_action );

end	

// === f_brokenfloor_blocker_timer::: waits for timer to trigger
script dormant f_brokenfloor_blocker_timer()

	sleep_rand_s( .5, .875 );
	//dprint( "::: f_brokenfloor_blocker_timer :::" );
	sleep_forever( f_brokenfloor_blocker_force );
	wake( f_brokenfloor_blocker_action );

end	

// === f_brokenfloor_blocker_action::: Makes the pathblocker animate
script dormant f_brokenfloor_blocker_action()
	//dprint( "::: f_brokenfloor_blocker_action :::" );

	// create an explosion
	f_explosion_flag_large( flg_end_start_pathblocker01, TRUE, TRUE );
	sleep_s( 0.25 );
		
	thread( f_screenshake_event_high(-0.75, -1, -1.25, sfx_broken_path_blocker()) );		// XXX make 3d
	//print(":shakeshakeshake:");
	//camera_shake_all_coop_players( 0.2, 0.2, 1, 0.1);
	
	// animate the device
	dm_broken_blocker01->animate_full( -1 );
	
	// stop the jitter door
	wake( f_brokenfloor_entry_door_stop );
	
	// star fire	
	effect_new( "environments\solo\m10_crash\fx\fire\fire_wall_burning_close.effect", "fx_32_fire_blocker");
	effect_new( "environments\solo\m10_crash\fx\fire\fire_interior.effect", "fx_32_fire_blocker1");
	thread (f_do_fire_damage_on_trigger( tv_fire_broken ));

	sleep_rand_s( 0.5, 1.25 );
	L_brokenfloor_blocker_rumble_ID = f_screenshake_rumble_global_remove( L_brokenfloor_blocker_rumble_ID, -1, 0.5 );
	
	// cleanup the sub area
	wake( f_brokenfloor_blocker_deinit );
	
end
