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
// MAINTENANCE: DESTRUCTION: TEST
// -------------------------------------------------------------------------------------------------
/*
script static void test_maintenance_destruction( real r_pos_final, real r_rewind_time, real r_between_time )
static real r_test_pos = 0.0;
static boolean b_test_order = FALSE;

	wake( f_maintenance_destruction_rack_init );
	wake( f_maintenance_destruction_crate_init );
	sleep( 1 );

	wake( f_maintenance_destruction_action );

	repeat
		if ( r_rewind_time >= 0.0 ) then

			sleep_s( r_between_time );
			device_animate_position( dm_maintenance_ramp_near, 0.0, r_rewind_time, 0.1, 0, TRUE );
			device_animate_position( dm_maintenance_ramp_far, 0.0, r_rewind_time, 0.1, 0, TRUE );
			sleep_until( f_maintenance_destruction_ramps_pos() == 0.0, 1 );

			sleep_s( r_between_time );

			if ( b_test_order ) then
				f_maintenance_destruction_ramp01_action();
			else
				f_maintenance_destruction_ramp02_action();
			end
			
			sleep_rand_s( 1, 1.5 );
			
			if ( b_test_order ) then
				f_maintenance_destruction_ramp02_action();
			else
				f_maintenance_destruction_ramp01_action();
			end

			// swap order
			b_test_order = not b_test_order;
		end
	until ( r_rewind_time < 0.0, 1 );

end
*/


// -------------------------------------------------------------------------------------------------
// MAINTENANCE: DESTRUCTION
// -------------------------------------------------------------------------------------------------
// variables
global long L_maintenance_rumble_ID = 0;
global real R_maintenance_ramp_time_near = 1.0;
global real R_maintenance_ramp_time_far = 0.75;
global boolean B_maintenance_destruction_started = FALSE;

// functions
script static boolean f_B_maintenance_destruction_loaded()
	object_valid(dm_maintenance_ramp_near) and object_valid(dm_maintenance_ramp_far);
end

// === f_maintenance_destruction_init::: initialize the upperramps setting
script dormant f_maintenance_destruction_init()
	sleep_until( object_valid(dm_maintenance_ramp_near) and object_valid(dm_maintenance_ramp_far), 1 );
	//dprint( "::: f_maintenance_destruction_init :::" );

	//wake( f_maintenance_destruction_rack_init );

	wake( f_maintenance_destruction_crate_init );

	wake( f_maintenance_destruction_trigger );
	
end

script dormant f_explode_canister_sounds()

	thread(f_canister_explode_snd_call(cr_maintenance_fuel_can_03));
	thread(f_canister_explode_snd_call(cr_maintenance_fuel_can_05));
	thread(f_canister_explode_snd_call(grunt_killer));
	thread(f_canister_explode_snd_call(grunt_killer2));
	thread(f_canister_explode_snd_call(fuel_can_u_1));
	thread(f_canister_explode_snd_call(fuel_can_u_2));
	thread(f_canister_explode_snd_call(fuel_can_u_3));

end

script static void f_canister_explode_snd_call(object canister)
	sleep_until(object_get_health(canister) <= 0);
	thread(sfx_unsc_canister_explode_maintenance_hall(canister));
end



// === f_maintenance_destruction_rack_init::: setup the racks
/*script dormant f_maintenance_destruction_rack_init()
	//dprint( "::: f_maintenance_destruction_rack_init :::" );
	// racks
	//thread( dm_maintenance_rack_near_01->open(0.0) );

	//thread( dm_maintenance_rack_near_02->chain_open_eject(dm_maintenance_ramp_near, 0.25, 0.0, -1, cr_maintenance_rack_near_02, tv_maintenance_warthog_destroy_near, 1.0) );
	//thread( dm_maintenance_rack_near_03->chain_open_eject(dm_maintenance_rack_near_02, -1, -1, -1, cr_maintenance_rack_near_03, tv_maintenance_warthog_destroy_near, 1.0) );
	//thread( dm_maintenance_rack_near_04->chain_open_eject(dm_maintenance_rack_near_03, -1, -1, -1, cr_maintenance_rack_near_04, tv_maintenance_warthog_destroy_near, 0.1) );

	//thread( dm_maintenance_rack_far_01->chain_open_eject(dm_maintenance_ramp_far, 0.125, 0.0, -1, cr_maintenance_rack_far_01, tv_maintenance_warthog_destroy_far, 1.0) );
//	thread( dm_maintenance_rack_far_02->chain_open_eject(dm_maintenance_rack_far_01, -1, -1, -1, cr_maintenance_rack_far_02, tv_maintenance_warthog_destroy_far, 1.0) );
//	thread( dm_maintenance_rack_far_03->chain_open_eject(dm_maintenance_rack_far_02, -1, -1, -1, cr_maintenance_rack_far_03, tv_maintenance_warthog_destroy_far, 0.1) );
//	thread( dm_maintenance_rack_far_04->chain_open_eject(dm_maintenance_rack_far_03, -1, -1, -1, cr_maintenance_rack_far_04, tv_maintenance_warthog_destroy_far, 1.0) );

end*/

script static boolean f_B_maintenance_destruction_near_racks_open()
	(current_zone_set_fully_active() == S_zoneset_32_broken_34_maintenance);
end

// === f_maintenance_destruction_rack_init::: setup the racks
script dormant f_maintenance_destruction_crate_init()
	//dprint( "::: f_maintenance_destruction_crate_init :::" );

	thread( m10_maintenance_dropcrate_n01->chain_release(dm_maintenance_ramp_near, 0.875, NONE, 0.5, 1.25) );
	thread( m10_maintenance_dropcrate_n02->chain_release(dm_maintenance_ramp_near, 0.875, NONE, 0.5, 1.25) );
	//thread( m10_maintenance_dropcrate_n03->chain_release(dm_maintenance_ramp_near, 0.875, NONE, 0.5, 1.25) );

	thread( m10_maintenance_dropcrate_f01->chain_release(dm_maintenance_ramp_far, 0.875, NONE, 0.5, 1.25) );
	thread( m10_maintenance_dropcrate_f02->chain_release(dm_maintenance_ramp_far, 0.875, NONE, 0.5, 1.25) );
	thread( m10_maintenance_dropcrate_f03->chain_release(dm_maintenance_ramp_far, 0.875, NONE, 0.5, 1.25) );

//	objects_physically_attach( dm_maintenance_ramp_near, "m_attach_crate_01", m10_maintenance_dropcrate_l01, "m_attach" );
//	objects_physically_attach( dm_maintenance_ramp_near, "m_attach_crate_02", m10_maintenance_dropcrate_l02, "m_attach" );
//	objects_physically_attach( dm_maintenance_ramp_near, "m_attach_crate_03", m10_maintenance_dropcrate_l03, "m_attach" );
	//objects_physically_attach( dm_maintenance_ramp_near, "m_attach_crate_04", m10_maintenance_dropcrate_l04, "m_attach" );
//	objects_physically_attach( dm_maintenance_ramp_near, "m_attach_crate_05", m10_maintenance_dropcrate_l05, "m_attach" );
	
//	objects_physically_attach( dm_maintenance_ramp_near, "m_terminal_attach", cr_maintenance_terminal_01, "m_attach" );

//	thread( m10_maintenance_dropcrate_l01->chain_release(dm_maintenance_ramp_near, dm_maintenance_ramp_near->drop_frame_random(), dm_maintenance_ramp_near, 0.0, 0.125) );
//	thread( m10_maintenance_dropcrate_l02->chain_release(dm_maintenance_ramp_near, 0.00, NONE, 0.5, 2.5) );
//	thread( m10_maintenance_dropcrate_l03->chain_release(dm_maintenance_ramp_near, dm_maintenance_ramp_near->drop_frame_random(), dm_maintenance_ramp_near, 0.0, 0.125) );
	//thread( m10_maintenance_dropcrate_l04->chain_release(dm_maintenance_ramp_near, dm_maintenance_ramp_near->drop_frame_random(), dm_maintenance_ramp_near, 0.0, 0.125) );
//	thread( m10_maintenance_dropcrate_l05->chain_release(dm_maintenance_ramp_near, dm_maintenance_ramp_near->drop_frame_random(), dm_maintenance_ramp_near, 0.0, 0.125) );
	
end

// === f_maintenance_destruction_deinit::: cleansup the break ramps
script dormant f_maintenance_destruction_deinit()
	//dprint( "::: f_maintenance_destruction_deinit :::" );

	sleep_forever( f_maintenance_destruction_init );
	sleep_forever( f_maintenance_destruction_trigger );
	sleep_forever( f_maintenance_destruction_start );
	sleep_forever( f_maintenance_destruction_force );
	sleep_forever( f_maintenance_destruction_action );
	sleep_forever( f_maintenance_destruction_ramp01_action );
	sleep_forever( f_maintenance_destruction_ramp02_action );

end

// === f_maintenance_destruction_trigger::: sets up the things that trigger the ramp to break
script dormant f_maintenance_destruction_trigger()
	sleep_until( volume_test_players(tv_maintenance_lower_start) or volume_test_players(tv_maintenance_upper_start), 1);
	//dprint( "::: f_maintenance_destruction_trigger :::" );
	
	sleep_rand_s( 0.5, 1.5 );										// wait a short random so the player doesn't feel the trigger
	wake( f_maintenance_destruction_start );
	
end

// === f_maintenance_destruction_start::: starts the destruction
script dormant f_maintenance_destruction_start()
	//dprint( "::: f_maintenance_destruction_start :::" );

	wake (f_garbage_collect_under_maintenence);
	
	// pause the combat checkpoint
	f_combat_checkpoint_pause( "", TRUE );

	// start rumbling to make things seem "spooky"
	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_MAINTENANCE );
	L_maintenance_rumble_ID = f_mission_screenshakes_rumble_med( -1.0 ); // XXX setup so it's stronger on the platforms
	

	// setup triggers that force the destruction
	wake( f_maintenance_destruction_force );
	wake( f_maintenance_destruction_timer );

end

// === f_maintenance_destruction_force::: Triggers that force the destruction
script dormant f_maintenance_destruction_force()
	sleep_until( (ai_living_fraction(gr_maintenance) < 0.9) or volume_test_players(tv_maintenance_upper_force) or volume_test_players(tv_maintenance_lower_force), 1 );
	//dprint( "::: f_maintenance_destruction_force :::" );

	// setup and break
	sleep_rand_s( 0.1, 0.333 );										// wait a short random so the player doesn't feel the trigger
	sleep_forever( f_maintenance_destruction_timer );
	wake( f_maintenance_destruction_action );

end

// === f_maintenance_destruction_timer::: Triggers that force the destruction
script dormant f_maintenance_destruction_timer()
static long l_lookat_timer = 0;
static real r_destruction_delay = real_random_range(  3.5, 5.25 );
static real r_look_time = 5.5;

	// setup pre-destruction sfx
	thread( sfx_maintenance_destruction_pre(r_destruction_delay + r_look_time) );

	// min timer
	sleep_s( r_destruction_delay );
	// make max timer for look at trigger
	l_lookat_timer = game_tick_get() + seconds_to_frames(5.5);
	sleep_until( 
		(l_lookat_timer <= game_tick_get())
			or
		(volume_test_players(tv_maintenance_upper_start) and volume_test_players_lookat(tv_maintenance_upper_force, 25.0, 2.5))
			or
		((volume_test_players(tv_maintenance_lower_lookat_area01) or volume_test_players(tv_maintenance_lower_lookat_area02)) and volume_test_players_lookat(tv_maintenance_upper_force, 25.0, 2.5))
	, 1 );
	//dprint( "::: f_maintenance_destruction_timer :::" );

	sleep_forever( f_maintenance_destruction_force );
	wake( f_maintenance_destruction_action );

end

// === f_maintenance_destruction_action::: Breaks the split platforms
script dormant f_maintenance_destruction_action()
	//dprint( "::: f_maintenance_destruction_action :::" );

	//wake( f_fuel_can_trigger_setup );

	// check to see if there's a player in the upper area, if so play the upper sequence
	/*
	if ( f_maintenance_upper_hasplayers() ) then

		// break the upper floor 02 - this allows the plyaer to see it happen across from them before it happens to him
		thread( f_maintenance_destruction_ramp02_action() );
	
		// break the upper floor 01 which the player is likely standing on
		sleep_rand_s( 1, 1.5 );
		thread( f_maintenance_destruction_ramp01_action() );

	else
	*/
		// break the upper floor 01 which the player is likely standing on
		thread( f_maintenance_destruction_ramp01_action() );

		sleep_rand_s( 1, 1.5 );
		thread( f_maintenance_destruction_ramp02_action() );
	/*
	end
	*/
	
	// pause the combat checkpoint
	f_combat_checkpoint_pause( "", FALSE );

	sleep_until( f_maintenance_destruction_ramp01_destroyed() or f_maintenance_destruction_ramp02_destroyed(), 1 );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_MAINTENANCE );

	wake( f_dialog_ShipVO_Maintenance );

	sleep_until( f_maintenance_destruction_ramp01_destroyed() and f_maintenance_destruction_ramp02_destroyed());
	f_screenshake_ambient_pause( FALSE, FALSE, 0.0 );

	
	// stop rumbling

	L_maintenance_rumble_ID = f_screenshake_rumble_global_remove( L_maintenance_rumble_ID, -1, 1.5 );
	print("Playing Matt's Screenshake");
	//L_maintenance_rumble_ID = f_screenshake_ambient_add( 0.1, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), -0.5, -1, -3.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_01', 0.0, 1, "amb_m10_explosions_medium_01" );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_END );
	L_maintenance_rumble_ID = f_screenshake_ambient_add( 0.1, DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_MED(), -0.5, -1, -3.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_medium_01', 0.0, 1, "amb_m10_explosions_medium_01" );
	
	// cleanup all the breakramps since we're now done with the event
	wake( f_maintenance_destruction_deinit );

end

script static real f_maintenance_destruction_ramp01_pos()
static real r_pos = 0.0;

	if ( r_pos < 1.0 ) then
		if ( object_valid(dm_maintenance_ramp_near) ) then
			r_pos = device_get_position( dm_maintenance_ramp_near );
		elseif ( current_zone_set_fully_active() > S_zoneset_32_broken_34_maintenance ) then
			r_pos = 1.0;
		end
	end

	// return
	r_pos;
	
end

script static real f_maintenance_destruction_ramp02_pos()
static real r_pos = 0.0;

	if ( r_pos < 1.0 ) then
		if ( object_valid(dm_maintenance_ramp_far) ) then
			r_pos = device_get_position( dm_maintenance_ramp_far );
		elseif ( current_zone_set_fully_active() > S_zoneset_32_broken_34_maintenance ) then
			r_pos = 1.0;
		end
	end

	// return
	r_pos;

end

// === f_maintenance_destruction_ramp01_destroyed::: Returns if the ramp is broken
script static boolean f_maintenance_destruction_ramp01_destroyed()
	f_maintenance_destruction_ramp01_pos() > 0.0;
end

// === f_maintenance_destruction_ramp02_destroyed::: Returns if the ramp is broken
script static boolean f_maintenance_destruction_ramp02_destroyed()
	f_maintenance_destruction_ramp02_pos() > 0.0;
end

// === f_maintenance_destruction_ramps_pos::: Returns the average position of the ramps
script static real f_maintenance_destruction_ramps_pos()
	(f_maintenance_destruction_ramp01_pos() + f_maintenance_destruction_ramp02_pos())/2;
end

// === f_maintenance_destruction_ramp01_action::: Function to handle all the breaking of the upper floor piece 01
script static void f_maintenance_destruction_ramp01_action()
	sleep_until( object_valid(dm_maintenance_ramp_near), 1 );
	dprint( "::: f_maintenance_destruction_ramp01_action :::" );

	if ( not f_maintenance_destruction_ramp01_destroyed() ) then
		B_maintenance_destruction_started = TRUE;

		thread( f_screenshake_event_high(-0.125, -1, -1.0, sfx_maintenance_ramp_near_destruction()) );  // XXX make stronger if you're on the ramp
	
		// rotate the floor
		sleep_s( 0.125 );
		dm_maintenance_ramp_near->break( R_maintenance_ramp_time_near, tv_maintenance_ramp_near_top_physics, tv_maintenance_ramp_near_bottom_physics );

	end

end

// === a::: Function to handle all the breaking of the upper floor piece 02
script static void f_maintenance_destruction_ramp02_action()
	sleep_until( object_valid(dm_maintenance_ramp_far), 1 );
	dprint( "::: f_maintenance_destruction_ramp02_action :::" );

	if ( not f_maintenance_destruction_ramp02_destroyed() ) then
		B_maintenance_destruction_started = TRUE;

		thread( f_screenshake_event_high(-0.125, -1, -1.0, sfx_maintenance_ramp_far_destruction()) );  // XXX make stronger if you're on the ramp

		// rotate the floor
		sleep_s( 0.125 );
		dm_maintenance_ramp_far->break( R_maintenance_ramp_time_far, tv_maintenance_ramp_far_top_physics, tv_maintenance_ramp_far_bottom_physics );

	end

end

script static boolean f_B_maintenance_destruction_started()
	f_maintenance_destruction_ramp01_destroyed() or f_maintenance_destruction_ramp02_destroyed();
end

script static boolean f_B_maintenance_destruction_done()
	f_maintenance_destruction_ramps_pos() == 1.0;
end

script static void f_fuel_can_trigger( object o_fuelcan )

	sleep_until( (o_fuelcan == NONE) or (objects_distance_to_object(ai_get_object(gr_maintenance_lower_grunts),o_fuelcan) <= 2.0) or (objects_distance_to_object(ai_get_object(gr_maintenance_upper_grunts),o_fuelcan) <= 2.0), 1 );
	if ( o_fuelcan != NONE ) then
		damage_objects( o_fuelcan, "", 1000 );
	end
	
end

script dormant f_garbage_collect_under_maintenence()

	repeat
		add_recycling_volume (tv_garbage_maintenence_garbage, 0, 1);
	until (1 == 0, 10);

end

//script dormant f_fuel_can_trigger_setup()
//
//	sleep_rand_s( 0.5, 1.0 );
//	sleep_until( B_maintenace_AI_room_lower_chaos, 1 );
////	thread( f_fuel_can_trigger(cr_maintenance_fuel_can_01) );
////	thread( f_fuel_can_trigger(cr_maintenance_fuel_can_02) );
//	thread( f_fuel_can_trigger(cr_maintenance_fuel_can_03) );
////	thread( f_fuel_can_trigger(cr_maintenance_fuel_can_04) );
//	thread( f_fuel_can_trigger(cr_maintenance_fuel_can_05) );
//	
//end