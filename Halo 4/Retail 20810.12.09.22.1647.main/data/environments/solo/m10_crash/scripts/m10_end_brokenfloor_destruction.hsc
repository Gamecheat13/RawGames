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
script static void test_broken_destruction( real r_pos_final, real r_play_time, real r_pos_step, real r_rewind_time, real r_between_time )
static real r_test_pos = 0.0;

	if ( r_play_time >= 0.0 ) then
		DEF_BROKEN_ROOM_ANIM_TIME = r_play_time;
	end

	wake( f_brokenfloor_destruction_action );

	repeat
		if ( r_pos_step >= 0.0 ) then
			repeat
					r_test_pos = f_brokenfloor_destruction_pos() + r_pos_step;
					sleep_until( f_brokenfloor_destruction_pos() >= r_test_pos, 1 );
					inspect( f_brokenfloor_destruction_pos() );
					set( game_speed, 0.0 );
			until( f_brokenfloor_destruction_pos() >= r_pos_final, 1 );
		end
		sleep_until( f_brokenfloor_destruction_pos() >= r_pos_final, 1 );
		if ( r_rewind_time >= 0.0 ) then
			sleep_s( r_between_time );
			f_brokenfloor_destruction_animate( 0.0, r_rewind_time, 0.1 );
			sleep_until( f_brokenfloor_destruction_pos() == 0.0, 1 );
			sleep_s( r_between_time );
			f_brokenfloor_destruction_animate_default();
		end
	until ( r_rewind_time < 0.0, 1 );

end
*/

//player_action_test_jump to step?
//player_action_test_melee
// reset?

// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: DESTRUCTION
// -------------------------------------------------------------------------------------------------
// variables
global real DEF_BROKEN_ROOM_ANIM_TIME = 6.0; // 12.5
global boolean B_brokenfloor_destruction_active = FALSE;
global long L_brokenfloor_rumble_id = 0;
global boolean b_blip_maintenance = FALSE;
global boolean b_player_passed_exit = FALSE;

// functions
// === f_brokenfloor_destruction_init::: Initialize
script dormant f_brokenfloor_destruction_init()
	thread(f_blip_maintenance());
	thread(f_maintenance_blip_check());
	sleep_until( object_valid(dm_broken_room01) and object_valid(dm_broken_room02) and object_valid(dm_broken_room03), 1 );
	
	// initialize modules
	wake( f_brokenfloor_destruction_trigger );

end

// === f_brokenfloor_destruction_deinit::: Deinitialize
script dormant f_brokenfloor_destruction_deinit()
	//dprint( "::: f_brokenfloor_destruction_deinit :::" );

	// kill functions
	sleep_forever( f_brokenfloor_destruction_init );
	sleep_forever( f_brokenfloor_destruction_trigger );
	sleep_forever( f_brokenfloor_destruction_force );
	sleep_forever( f_brokenfloor_destruction_timer );
	sleep_forever( f_brokenfloor_destruction_action );

end

// === f_brokenfloor_destruction_trigger::: starts the events
script dormant f_brokenfloor_destruction_trigger()
	sleep_until( volume_test_players(tv_broken_enter) or (volume_test_players(tv_broken_lookat_area) and volume_test_players_lookat(tv_broken_lookat_target, 25.0, 2.5)), 1 );
	//dprint( "::: f_brokenfloor_destruction_trigger :::" );

	// soften the trigger
	sleep_rand_s( 0.0, 0.125 );

	B_brokenfloor_destruction_active = TRUE;

	// screenshake
	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_BROKEN );
	L_brokenfloor_rumble_id = f_mission_screenshakes_rumble_med( -0.25 );

	// wake the force trigger
	wake( f_brokenfloor_destruction_force );
	
	// start the timer
	wake( f_brokenfloor_destruction_timer );

end	

// === f_brokenfloor_destruction_force::: force the action to trigger
script dormant f_brokenfloor_destruction_force()

	sleep_until( volume_test_players(tv_broken_room_force01) or (ai_strength(gr_broken_start) <= 0.75) or (volume_test_objects(tv_broken_exit,ai_actors(gr_broken_start))), 1 );
	//dprint( "::: f_brokenfloor_destruction_force :::" );
	sleep_forever( f_brokenfloor_destruction_timer );
	wake( f_brokenfloor_destruction_action );

end	

// === f_brokenfloor_destruction_timer::: waits for timer to trigger
script dormant f_brokenfloor_destruction_timer()
static long l_lookat_timer = 0;
static real r_destruction_delay = real_random_range(4.0, 5.0);
static real r_look_time = 3.0;

	// setup pre-destruction sfx
	thread( sfx_brokenfloor_destruction_pre(r_destruction_delay + r_look_time) );

	// min timer
	sleep_s( r_destruction_delay );
	
	// make max timer for look at trigger
	l_lookat_timer = game_tick_get() + seconds_to_frames( r_look_time );
	sleep_until( (l_lookat_timer <= game_tick_get()) or (volume_test_players(tv_broken_lookat_area) and volume_test_players_lookat(tv_broken_lookat_target, 25.0, 2.5)), 1 );
	
	//dprint( "::: f_brokenfloor_destruction_timer :::" );
	sleep_forever( f_brokenfloor_destruction_force );
	wake( f_brokenfloor_destruction_action );

end	

// === f_brokenfloor_destruction_explosions_secondary::: First set of explosions
script static void f_brokenfloor_destruction_explosions_secondary()
	// XXX trigger from animation

	//dprint( "::: f_brokenfloor_destruction_explosions_secondary :::" );
	sleep_rand_s( 0.1, 0.25 );
	f_explosion_flag_large( flg_broken_destruction_explosion_01a, TRUE, TRUE );
	sleep_rand_s( 0.1, 0.125 );
	f_explosion_flag_large( flg_broken_destruction_explosion_01b, TRUE, TRUE );
	sleep_rand_s( 0.1, 0.25 );
	f_explosion_flag_large( flg_broken_destruction_explosion_02a, TRUE, TRUE );

end

// === f_brokenfloor_destruction_animate::: Plays the destruction
script static void f_brokenfloor_destruction_animate( real r_position, real r_time, real r_blend )
	device_animate_position( dm_broken_room01, r_position, r_time, r_blend, 0, TRUE );
	device_animate_position( dm_broken_room02, r_position, r_time, r_blend, 0, TRUE );
	device_animate_position( dm_broken_room03, r_position, r_time, r_blend, 0, TRUE );
end
script static void f_brokenfloor_destruction_animate_default()
	f_brokenfloor_destruction_animate( 1.0, DEF_BROKEN_ROOM_ANIM_TIME, 0.1 );
end

// === f_brokenfloor_destruction_pos::: Returns the position of the broken floor destruction
script static real f_brokenfloor_destruction_pos()
static real r_pos = 0.0;

	if ( r_pos < 1.0 ) then
		if ( object_valid(dm_broken_room01) ) then
			r_pos = (device_get_position(dm_broken_room01) + device_get_position(dm_broken_room02) + device_get_position(dm_broken_room03))/3;
		elseif ( current_zone_set_fully_active() > S_zoneset_32_broken_34_maintenance ) then
			r_pos = 1.0;
		end
	end
	
	// Returns
	r_pos;
end

// === f_brokenfloor_destruction_started::: Returns if the broken floor destruction has started
script static boolean f_brokenfloor_destruction_started()
	f_brokenfloor_destruction_pos() > 0;
end

// === f_brokenfloor_destruction_action::: Plays the destruction
script dormant f_brokenfloor_destruction_action()
	dprint( "::: f_brokenfloor_destruction_action :::" );

	f_combat_checkpoint_pause( "", TRUE );

	// shake and sfx
	thread( f_screenshake_event_high(-0.75, -1, -2.0, sfx_broken_room_destruction()) );		// XXX make stronger if you're in the room or 3d

	// make AI respond to destruction
	wake( f_brokenfloor_AI_start_destruction );

	// starting explosion
	//dprint( "::: f_brokenfloor_destruction_action-a :::" );
	f_explosion_flag_large( flg_broken_destruction_explosion_00a, TRUE, TRUE );
	sleep_s( 0.25 );

	// destroy the pathing mesh

	// break the floor
	thread( f_brokenfloor_destruction_animate_default() );

	// temporarily do zero gravity
	sleep_until( f_brokenfloor_destruction_pos() >= 0.07125, 1);
	//f_gravity_set( 0.0 );
	// kill the AI
	wake( f_brokenfloor_AI_start_kill );
	thread( triggerobjs_setvelocity_rand(tv_broken_physics, s_objtype_biped + s_objtype_weapon + s_objtype_equipment + s_objtype_crate, 0.75, 2.25, 0.75, 2.25, 0.75, 2.25) );	

	// secondary explosion & kick physics
	sleep_until( f_brokenfloor_destruction_pos() >= 0.175, 1);
	thread( f_brokenfloor_destruction_explosions_secondary() );

	// set real gravity
	//dprint( "::: f_brokenfloor_destruction_action-i:::" );
	sleep_until( f_brokenfloor_destruction_pos() >= 0.375, 1);
	//f_gravity_set_time( R_gravity_end, 1.0, FALSE );
	
	// response VO
	sleep_until( f_brokenfloor_destruction_pos() >= 0.45, 1);
	thread( triggerobjs_wakephysics(tv_broken_physics, 0) );
	wake( f_dialog_BrokenAction_Post );

	dprint( "::: f_brokenfloor_destruction_action-j:::" );
	sleep_until( f_B_brokenfloor_destruction_destroyed(), 1 );
	//dprint( "::: f_brokenfloor_destruction_action-k:::" );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_BROKEN_ROOM );
	sleep_rand_s( 0.75, 1.25 );

	// kill the rumble	
	f_screenshake_ambient_pause( FALSE, TRUE, 0.0 );
	L_brokenfloor_rumble_id = f_screenshake_rumble_global_remove( L_brokenfloor_rumble_id, -1, 1.5 );
	
	B_brokenfloor_destruction_active = FALSE;

	f_combat_checkpoint_pause( "", FALSE );

end

script static boolean f_B_brokenfloor_destruction_moving()
	(f_brokenfloor_destruction_pos() > 0.0) and (f_brokenfloor_destruction_pos() < 1.0);
end

script static boolean f_B_brokenfloor_destruction_destroyed()
	(f_brokenfloor_destruction_pos() == 1.0);
end

script static boolean f_B_brokenfloor_destruction_active()
	B_brokenfloor_destruction_active;
end

script static void f_blip_maintenance()
	sleep_until(b_blip_maintenance == TRUE);
	if b_player_passed_exit == FALSE then
		f_blip_flag(flg_maint_blip_door, "default");
		sleep_until(volume_test_players(tv_unblip_maintenance));
		f_unblip_flag(flg_maint_blip_door);
	end
end

script static void f_maintenance_blip_check()
	sleep_until(volume_test_players(tv_maintenance_exit));
	b_player_passed_exit = TRUE;
end


