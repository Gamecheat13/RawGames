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
// MAINTENANCE: HALL
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_hall_init::: Initialize
script dormant f_maintenance_hall_init()
	//dprint( "::: f_maintenance_hall_init :::" );
	
	// init modules
	wake( f_maintenance_hall_AI_init );

	// initialize sub modules
	wake( f_maintenance_hall_jump_init );
	wake( f_maintenance_airlock_init );
	wake( f_maintenance_hall_block01_init );
	wake( f_maintenance_hall_destruction_init );
	//wake( f_maintenance_hall_close_init );

	// setup triggers
	wake( f_maintenance_hall_trigger );
	wake(f_block_off_brokenfloor);
	
	wake (f_objectives_vehicle_bay);
end

// Teleport players forward and cut off the path back to brokenfloor
script dormant f_block_off_brokenfloor()
	sleep_until(volume_test_players(tv_maintenance_jump_area), 1);
	volume_teleport_players_not_inside(tv_maintenance_whole, flg_maintenance_hall_start);
	object_create(door_block_maintenance_upper);
	object_create(door_block_maintenance_lower);
end

script dormant f_objectives_vehicle_bay()
	sleep_until(volume_test_players(tv_near_pry_door), 1);
	thread (f_objective_blip( DEF_R_OBJECTIVE_PRY_POD_DOOR, TRUE, TRUE ));
	//wake( f_dialog_Run_Start );
	thread(f_dialog_catastrophic_depressurization());
			
	sleep_until(LevelEventStatus("last door opened"), 1);
	thread (f_objective_blip( DEF_R_OBJECTIVE_PRY_POD_DOOR, FALSE, TRUE ));
end


// === f_maintenance_hall_deinit::: Deinitialize
script dormant f_maintenance_hall_deinit()
	//dprint( "::: f_maintenance_hall_deinit :::" );
	
	// deinit modules
	wake( f_maintenance_hall_AI_deinit );

	// deinitialize sub modules
	wake( f_maintenance_hall_jump_deinit );
	wake( f_maintenance_airlock_deinit );
	wake( f_maintenance_hall_block01_deinit );
	wake( f_maintenance_hall_destruction_deinit );
	//wake( f_maintenance_hall_close_deinit );

	// shutdown triggers
	sleep_forever( f_maintenance_hall_trigger );

end

// === f_maintenance_hall_trigger::: trigger in area
script dormant f_maintenance_hall_trigger()
	sleep_until( volume_test_players(tv_explosionalley_area), 1 );
	//dprint( "::: f_maintenance_hall_trigger :::" );

	//datamine
	data_mine_set_mission_segment( "m10_END_maintenance_hall" );

end

// === f_maintenance_hall_cleanup::: Cleanup
script dormant f_maintenance_hall_cleanup()
	dprint( "::: f_maintenance_hall_cleanup :::" );

	// XXX

end





// -------------------------------------------------------------------------------------------------
// LIGHTING: DIRECT
// -------------------------------------------------------------------------------------------------
// === f_lighting_bsp18_direct_set::: Sets the direct lighting over time
script static void f_lighting_bsp18_direct_set( real r_time, real r_lighting_bsp18_start, real r_lighting_bsp18_end, short s_rate )
static long l_lighting_bsp18_thread = 0;

	if ( l_lighting_bsp18_thread != 0 ) then
		kill_thread( l_lighting_bsp18_thread );
		l_lighting_bsp18_thread = 0;
	end
	
	// initialize defualt values
	if ( r_lighting_bsp18_start < 0 ) then
		r_lighting_bsp18_start = f_lighting_bsp18_direct_get();
	end
	if ( r_lighting_bsp18_end < 0 ) then
		r_lighting_bsp18_end = f_lighting_bsp18_direct_get();
	end
	if ( s_rate < 0 ) then
		s_rate = 1;
	end
	
	// store the scale target for reset
	//R_lightmap_direct_scale_target = r_lighting_bsp18_end;

	// thread the lighting scale	
	l_lighting_bsp18_thread = thread( f_lighting_bsp18_direct_thread(r_time, r_lighting_bsp18_start, r_lighting_bsp18_end, s_rate) );
	
	// wait for it to finish
	sleep_until( r_lighting_bsp18_end == f_lighting_bsp18_direct_get(), 1 );
	l_lighting_bsp18_thread = 0;
	
end

// === f_lighting_bsp18_direct_get::: Gets the current direct lighting scaler value
script static real f_lighting_bsp18_direct_get()
	get_lightmap_direct_scalar_bsp(18);
end

// === f_lighting_bsp18_direct_thread::: Handles the logic for scaling the lighting
//			NOTE: Do not use this function, use f_lighting_bsp18_direct_set instead
script static void f_lighting_bsp18_direct_thread( real r_time, real r_lighting_bsp18_start, real r_lighting_bsp18_end, short s_rate )
static long l_time_start = 0;
static long l_time_end = 0;

	// get start time	
	l_time_start = game_tick_get();
	
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_time );

	if ( l_time_start != l_time_end ) then
		// make sure the lighting gets to it's starting state
		set_lightmap_direct_scalar_bsp(18, r_lighting_bsp18_start);

		repeat
			// apply lighting
			set_lightmap_direct_scalar_bsp(18, r_lighting_bsp18_start + ( (r_lighting_bsp18_end - r_lighting_bsp18_start) * ((game_tick_get() - l_time_start) / (l_time_end - l_time_start)) ));
		until ( game_tick_get() > l_time_end, s_rate );
	end
	
	// make sure the lighting gets to it's final state
	set_lightmap_direct_scalar_bsp(18, r_lighting_bsp18_end);

end

// -------------------------------------------------------------------------------------------------
// LIGHTING: INDIRECT
// -------------------------------------------------------------------------------------------------
// === f_lighting_bsp18_indirect_set::: Sets the indirect lighting over time
script static void f_lighting_bsp18_indirect_set( real r_time, real r_lighting_bsp18_start, real r_lighting_bsp18_end, short s_rate )
static long l_lighting_bsp18_thread = 0;

	if ( l_lighting_bsp18_thread != 0 ) then
		kill_thread( l_lighting_bsp18_thread );
		l_lighting_bsp18_thread = 0;
	end
	
	// initialize defualt values
	if ( r_lighting_bsp18_start < 0 ) then
		r_lighting_bsp18_start = f_lighting_bsp18_indirect_get();
	end
	if ( r_lighting_bsp18_end < 0 ) then
		r_lighting_bsp18_end = f_lighting_bsp18_indirect_get();
	end
	if ( s_rate < 0 ) then
		s_rate = 1;
	end
	
	// store the scale target for reset
	//R_lightmap_indirect_scale_target = r_lighting_bsp18_end;

	// thread the lighting scale	
	l_lighting_bsp18_thread = thread( f_lighting_bsp18_indirect_thread(r_time, r_lighting_bsp18_start, r_lighting_bsp18_end, s_rate) );
	
	// wait for it to finish
	sleep_until( r_lighting_bsp18_end == f_lighting_bsp18_indirect_get(), 1 );
	l_lighting_bsp18_thread = 0;
	
end

// === f_lighting_bsp18_indirect_get::: Gets the current indirect lighting scaler value
script static real f_lighting_bsp18_indirect_get()
	get_lightmap_indirect_scalar_bsp(18);
end

// === f_lighting_bsp18_indirect_thread::: Handles the logic for scaling the lighting
//			NOTE: Do not use this function, use f_lighting_bsp18_indirect_set instead
script static void f_lighting_bsp18_indirect_thread( real r_time, real r_lighting_bsp18_start, real r_lighting_bsp18_end, short s_rate )
static long l_time_start = 0;
static long l_time_end = 0;

	// get start time	
	l_time_start = game_tick_get();
	
	// get end time	
	l_time_end = l_time_start + seconds_to_frames( r_time );

	if ( l_time_start != l_time_end ) then
		// make sure the lighting gets to it's starting state
		set_lightmap_indirect_scalar_bsp(18, r_lighting_bsp18_start);

		repeat
			// apply lighting
			set_lightmap_indirect_scalar_bsp(18, r_lighting_bsp18_start + ( (r_lighting_bsp18_end - r_lighting_bsp18_start) * ((game_tick_get() - l_time_start) / (l_time_end - l_time_start)) ));
		until ( game_tick_get() > l_time_end, s_rate );
	end
	
	// make sure the lighting gets to it's final state
	set_lightmap_indirect_scalar_bsp(18, r_lighting_bsp18_end);

end




// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: JUMP
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_hall_jump_init::: init
script dormant f_maintenance_hall_jump_init()
	sleep_until( volume_test_players(tv_maintenance_jump_area), 1 );
	//dprint( "::: f_maintenance_hall_jump_init :::" );

	//datamine
	data_mine_set_mission_segment( "m10_END_maintenance_jump" );

end

// === f_maintenance_hall_jump_deinit::: deinit
script dormant f_maintenance_hall_jump_deinit()
	//dprint( "::: f_maintenance_hall_jump_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_hall_jump_init );

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: BLOCK01
// -------------------------------------------------------------------------------------------------
// variables
global real DEF_MAINTENANCE_HALL_ANIM_TIME = 0.75;

// functions
/*
script static void test_maintenance_hall_block( real r_pos_final, real r_play_time, real r_pos_step, real r_rewind_time, real r_between_time )
static real r_test_pos = 0.0;

	if ( r_play_time >= 0.0 ) then
		DEF_MAINTENANCE_HALL_ANIM_TIME = r_play_time;
	end

	wake( f_maintenance_hall_block01_action );

	repeat
		if ( r_pos_step >= 0.0 ) then
			repeat
					r_test_pos = f_maintenance_hall_block_pos() + r_pos_step;
					sleep_until( f_maintenance_hall_block_pos() >= r_test_pos, 1 );
					inspect( f_maintenance_hall_block_pos() );
					set( game_speed, 0.0 );
			until( f_maintenance_hall_block_pos() >= r_pos_final, 1 );
		end
		sleep_until( f_maintenance_hall_block_pos() >= r_pos_final, 1 );

		if ( r_rewind_time >= 0.0 ) then
			sleep_s( r_between_time );
			f_maintenance_hall_block_animate( 0.0, r_rewind_time, 0.1 );
			sleep_until( f_maintenance_hall_block_pos() == 0.0, 1 );
			sleep_s( r_between_time );
			f_maintenance_hall_block_animate_default();
		end
	until ( r_rewind_time < 0.0, 1 );

end
*/
// === f_maintenance_hall_block01_init::: init
script dormant f_maintenance_hall_block01_init()
	//dprint( "::: f_maintenance_hall_block01_init :::" );

	// setup triggers
	wake( f_maintenance_hall_block01_trigger );

end

// === f_explosionalley_blocker01_deinit::: Cleanup
script dormant f_maintenance_hall_block01_deinit()
	//dprint( "::: f_explosionalley_blocker01_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_hall_block01_init );
	sleep_forever( f_maintenance_hall_block01_trigger );
	sleep_forever( f_maintenance_hall_block01_action );

end

// === f_maintenance_hall_block_animate::: Plays the destruction
script static real f_maintenance_hall_block_pos()
static real r_return = 0.0;

	if ( object_valid(dm_maintenance_hall_block_01) ) then
		r_return = device_get_position(dm_maintenance_hall_block_01);
	/*elseif ( object_valid(dm_maintenance_hall_block_02) ) then
		r_return = device_get_position(dm_maintenance_hall_block_02);*/
	end

	// return
	r_return;

end
script static void f_maintenance_hall_block_animate( real r_position, real r_time, real r_blend )
	if ( object_valid(dm_maintenance_hall_block_01) ) then
		device_animate_position( dm_maintenance_hall_block_01, r_position, r_time, r_blend, 0, TRUE );
	end
	/*if ( object_valid(dm_maintenance_hall_block_02) ) then
		device_animate_position( dm_maintenance_hall_block_02, r_position, r_time, r_blend, 0, TRUE );
	end*/
end
script static void f_maintenance_hall_block_animate_default()
	f_maintenance_hall_block_animate( 1.0, DEF_MAINTENANCE_HALL_ANIM_TIME, 0.1 );
end

// === f_maintenance_hall_block01_trigger::: Triggers the event
script dormant f_maintenance_hall_block01_trigger()
	sleep_until( volume_test_players(tv_maintenance_hall_block01) or (volume_test_objects(tv_explosionalley_block01_ai,ai_actors(gr_maintenance_explosionalley))), 1 );
	//dprint( "::: f_maintenance_hall_block01_trigger :::" );

	// trigger the action
	wake( f_maintenance_hall_block01_action );

end

// === f_maintenance_hall_block01_action::: Collapses blocker01
script dormant f_maintenance_hall_block01_action()
	//dprint( "::: f_maintenance_hall_block01_action :::" );
	
	// make the AI dive if necessary
	//wake( f_maintenance_hall_AI_destruction_dive );

	// create an explosion
	f_explosion_flag_large( flg_explosionalley_block01, TRUE, TRUE );

	f_maintenance_hall_block_animate_default();

	//dprint( "::: f_maintenance_hall_block01_action:DONE :::" );

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: DESTRUCTION
// -------------------------------------------------------------------------------------------------
// variables
global short S_maintenance_hall_explosion_total 		= 0;
global short S_maintenance_hall_explosion_trigger 	= -1;
global long L_maintenance_hall_explosion_timer 			= 0;
global short L_maintenance_hall_explosion_fired 		= 0;
global long L_maintenance_hall_rumble_ID 						= 0;
global real R_mh_destruction_delay_s 								= 0.375;
global real r_mh_destruction_delay_l 								= 0.75;

// functions
// === f_maintenance_hall_destruction_init::: Sets up explosion alley area
script dormant f_maintenance_hall_destruction_init()
	//dprint ( "::: f_maintenance_hall_destruction_init :::" );

	// setup triggers
	wake( f_maintenance_hall_destruction_trigger );
	
	f_maintenance_hall_destruction_setup( TRUE );

end

// === f_maintenance_hall_destruction_deinit::: Deinit
script static void f_maintenance_hall_destruction_setup( boolean b_setup )
//static long l_explosion_01 = 0;
static long l_explosion_02 = 0;
static long l_explosion_03 = 0;
static long l_explosion_04 = 0;
//static long l_explosion_05 = 0;
//static long l_explosion_06 = 0;
static long l_explosion_07 = 0;
static long l_explosion_08 = 0;
static long l_explosion_09 = 0;
static long l_explosion_10 = 0;
static long l_explosion_11 = 0;
static long l_explosion_12 = 0;
//static long l_explosion_13 = 0;
static long l_explosion_14 = 0;
//static long l_explosion_15 = 0;
//static long l_explosion_16 = 0;
static long l_explosion_17 = 0;
static long l_explosion_18 = 0;
//static long l_explosion_19 = 0;
//static long l_explosion_20 = 0;
//static long l_explosion_21 = 0;
//static long l_explosion_22 = 0;
//static long l_explosion_23 = 0;

	if ( b_setup ) then
		// setup explosion triggers
//		if ( l_explosion_01 == 0 ) then
//			l_explosion_01 = thread( f_maintenance_hall_explosion_trigger(01, flg_maintenance_hall_explosion_01, cr_maintenance_hall_wall_01, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_01", R_mh_destruction_delay_s, 1, FALSE, 1) );
//		end
		if ( l_explosion_02 == 0 ) then
			l_explosion_02 = thread( f_maintenance_hall_explosion_trigger(02, flg_maintenance_hall_explosion_02, cr_maintenance_hall_wall_02, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_02", R_mh_destruction_delay_s, 1, FALSE, 1) );
		end
		if ( l_explosion_03 == 0 ) then
			l_explosion_03 = thread( f_maintenance_hall_explosion_trigger(03, flg_maintenance_hall_explosion_03, cr_maintenance_hall_wall_03, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_03", R_mh_destruction_delay_s, 1, FALSE, 1) );
		end
		if ( l_explosion_04 == 0 ) then
			l_explosion_04 = thread( f_maintenance_hall_explosion_trigger(04, flg_maintenance_hall_explosion_04, cr_maintenance_hall_wall_04, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_04", R_mh_destruction_delay_s, 1, TRUE, 2) );
		end
//		if ( l_explosion_05 == 0 ) then
//			l_explosion_05 = thread( f_maintenance_hall_explosion_trigger(05, flg_maintenance_hall_explosion_05, cr_maintenance_hall_wall_05, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_05", R_mh_destruction_delay_s, 1, TRUE, 2) );
//		end
//		if ( l_explosion_06 == 0 ) then
//			l_explosion_06 = thread( f_maintenance_hall_explosion_trigger(06, flg_maintenance_hall_explosion_06, cr_maintenance_hall_wall_06, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_06", R_mh_destruction_delay_s, 1, TRUE, 2) );
//		end
		if ( l_explosion_07 == 0 ) then
			l_explosion_07 = thread( f_maintenance_hall_explosion_trigger(07, flg_maintenance_hall_explosion_07, cr_maintenance_hall_wall_07, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_07", R_mh_destruction_delay_s, 1, TRUE, 2) );
		end
		if ( l_explosion_08 == 0 ) then
			l_explosion_08 = thread( f_maintenance_hall_explosion_trigger(08, flg_maintenance_hall_explosion_08, NONE, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_08", r_mh_destruction_delay_l, 3, TRUE, 3) );
		end
		if ( l_explosion_09 == 0 ) then
			l_explosion_09 = thread( f_maintenance_hall_explosion_trigger(09, flg_maintenance_hall_explosion_09, NONE, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_09", r_mh_destruction_delay_l, 1, TRUE, 3) );
		end
		if ( l_explosion_10 == 0 ) then
			l_explosion_10 = thread( f_maintenance_hall_explosion_trigger(10, flg_maintenance_hall_explosion_10, NONE, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_10", r_mh_destruction_delay_l, 2, TRUE, 3) );
		end
		if ( l_explosion_11 == 0 ) then
			l_explosion_11 = thread( f_maintenance_hall_explosion_trigger(11, flg_maintenance_hall_explosion_11, NONE, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_11", r_mh_destruction_delay_l, 1, TRUE, 3) );
		end
		if ( l_explosion_12 == 0 ) then
			l_explosion_12 = thread( f_maintenance_hall_explosion_trigger(12, flg_maintenance_hall_explosion_12, cr_maintenance_hall_wall_12, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_12", R_mh_destruction_delay_s, 1, TRUE, 4) );
		end
//		if ( l_explosion_13 == 0 ) then
//			l_explosion_13 = thread( f_maintenance_hall_explosion_trigger(13, flg_maintenance_hall_explosion_13, cr_maintenance_hall_wall_13, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_13", R_mh_destruction_delay_s, 1, TRUE, 4) );
//		end
		if ( l_explosion_14 == 0 ) then
			l_explosion_14 = thread( f_maintenance_hall_explosion_trigger(14, flg_maintenance_hall_explosion_14, cr_maintenance_hall_wall_14, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_14", R_mh_destruction_delay_s, 1, TRUE, 5) );
		end
//		if ( l_explosion_15 == 0 ) then
//			l_explosion_15 = thread( f_maintenance_hall_explosion_trigger(15, flg_maintenance_hall_explosion_15, cr_maintenance_hall_wall_15, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_15", R_mh_destruction_delay_s, 1, TRUE, 5) );
//		end
//		if ( l_explosion_16 == 0 ) then
//			l_explosion_16 = thread( f_maintenance_hall_explosion_trigger(16, flg_maintenance_hall_explosion_16, cr_maintenance_hall_wall_16, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_16", R_mh_destruction_delay_s, 1, TRUE, 5) );
//		end
		if ( l_explosion_17 == 0 ) then
			l_explosion_17 = thread( f_maintenance_hall_explosion_trigger(17, flg_maintenance_hall_explosion_17, cr_maintenance_hall_wall_17, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_17", R_mh_destruction_delay_s, 1, TRUE, 5) );
		end
		if ( l_explosion_18 == 0 ) then
			l_explosion_18 = thread( f_maintenance_hall_explosion_trigger(18, flg_maintenance_hall_explosion_18, cr_maintenance_hall_wall_18, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_18", R_mh_destruction_delay_s, 1, TRUE, 5) );
		end
//		if ( l_explosion_19 == 0 ) then
//			l_explosion_19 = thread( f_maintenance_hall_explosion_trigger(19, flg_maintenance_hall_explosion_19, cr_maintenance_hall_wall_19, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_19", R_mh_destruction_delay_s, 1, TRUE, 5) );
//		end
//		if ( l_explosion_20 == 0 ) then
//			l_explosion_20 = thread( f_maintenance_hall_explosion_trigger(20, flg_maintenance_hall_explosion_20, cr_maintenance_hall_wall_20, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_20", R_mh_destruction_delay_s, 1, TRUE, 6) );
//		end
//		if ( l_explosion_21 == 0 ) then
//			l_explosion_21 = thread( f_maintenance_hall_explosion_trigger(21, flg_maintenance_hall_explosion_21, cr_maintenance_hall_wall_21, FX_explosion_large, DMG_explosion_large, "maintenance_hall_explosion_21", R_mh_destruction_delay_s, 1, TRUE, 6) );
//		end
//		if ( l_explosion_22 == 0 ) then
//			l_explosion_22 = thread( f_maintenance_hall_explosion_trigger(22, flg_maintenance_hall_explosion_22, cr_maintenance_hall_wall_22, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_22", R_mh_destruction_delay_s, 1, TRUE, 6) );
//		end
//		if ( l_explosion_23 == 0 ) then
//			l_explosion_23 = thread( f_maintenance_hall_explosion_trigger(23, flg_maintenance_hall_explosion_23, cr_maintenance_hall_wall_23, FX_explosion_sparks, DMG_explosion_large, "maintenance_hall_explosion_23", R_mh_destruction_delay_s, 1, TRUE, 6) );
//		end
	else
//		if ( l_explosion_01 != 0 ) then
//			kill_thread( l_explosion_01 );
//			l_explosion_01 = 0;
//		end
		if ( l_explosion_02 != 0 ) then
			kill_thread( l_explosion_02 );
			l_explosion_02 = 0;
		end
		if ( l_explosion_03 != 0 ) then
			kill_thread( l_explosion_03 );
			l_explosion_03 = 0;
		end
		if ( l_explosion_04 != 0 ) then
			kill_thread( l_explosion_04 );
			l_explosion_04 = 0;
		end
//		if ( l_explosion_05 != 0 ) then
//			kill_thread( l_explosion_05 );
//			l_explosion_05 = 0;
//		end
//		if ( l_explosion_06 != 0 ) then
//			kill_thread( l_explosion_06 );
//			l_explosion_06 = 0;
//		end
		if ( l_explosion_07 != 0 ) then
			kill_thread( l_explosion_07 );
			l_explosion_07 = 0;
		end
		if ( l_explosion_08 != 0 ) then
			kill_thread( l_explosion_08 );
			l_explosion_08 = 0;
		end
		if ( l_explosion_09 != 0 ) then
			kill_thread( l_explosion_09 );
			l_explosion_09 = 0;
		end
		if ( l_explosion_10 != 0 ) then
			kill_thread( l_explosion_10 );
			l_explosion_10 = 0;
		end
		if ( l_explosion_11 != 0 ) then
			kill_thread( l_explosion_11 );
			l_explosion_11 = 0;
		end
		if ( l_explosion_12 != 0 ) then
			kill_thread( l_explosion_12 );
			l_explosion_12 = 0;
		end
//		if ( l_explosion_13 != 0 ) then
//			kill_thread( l_explosion_13 );
//			l_explosion_13 = 0;
//		end
		if ( l_explosion_14 != 0 ) then
			kill_thread( l_explosion_14 );
			l_explosion_14 = 0;
		end
//		if ( l_explosion_15 != 0 ) then
//			kill_thread( l_explosion_15 );
//			l_explosion_15 = 0;
//		end
//		if ( l_explosion_16 != 0 ) then
//			kill_thread( l_explosion_16 );
//			l_explosion_16 = 0;
//		end
		if ( l_explosion_17 != 0 ) then
			kill_thread( l_explosion_17 );
			l_explosion_17 = 0;
		end
		if ( l_explosion_18 != 0 ) then
			kill_thread( l_explosion_18 );
			l_explosion_18 = 0;
		end
//		if ( l_explosion_19 != 0 ) then
//			kill_thread( l_explosion_19 );
//			l_explosion_19 = 0;
//		end
//		if ( l_explosion_20 != 0 ) then
//			kill_thread( l_explosion_20 );
//			l_explosion_20 = 0;
//		end
//		if ( l_explosion_21 != 0 ) then
//			kill_thread( l_explosion_21 );
//			l_explosion_21 = 0;
//		end
//		if ( l_explosion_22 != 0 ) then
//			kill_thread( l_explosion_22 );
//			l_explosion_22 = 0;
//		end
//		if ( l_explosion_23 != 0 ) then
//			kill_thread( l_explosion_23 );
//			l_explosion_23 = 0;
//		end
	
	end
end

// === f_maintenance_hall_destruction_deinit::: Deinit
script dormant f_maintenance_hall_destruction_deinit()
	//dprint( "::: f_maintenance_hall_destruction_deinit :::" );

	// shut down all the events just in case
	f_maintenance_hall_destruction_setup( FALSE );

	// kill functions
	sleep_forever( f_maintenance_hall_destruction_init );
	sleep_forever( f_maintenance_hall_destruction_trigger_player );
	sleep_forever( f_maintenance_hall_destruction_trigger_AI );

end

// === f_maintenance_hall_destruction_trigger::: Deinit
script dormant f_maintenance_hall_destruction_trigger()
	//dprint( "::: f_maintenance_hall_destruction_trigger :::" );
	// setup triggers
	wake( f_maintenance_hall_destruction_trigger_player );
	wake( f_maintenance_hall_destruction_trigger_AI );

	sleep_until( f_maintenance_hall_destruction_active(), 1 );
	sleep_rand_s( 0.25, 0.333 );		
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_EXPLOSION_ALLEY );
	L_maintenance_hall_rumble_ID = f_mission_screenshakes_rumble_high( -0.125 );	// XXX make stronger if you're in the hall
	
	wake( f_dialog_ShipVO_ExplosionAlley );
	
	thread( f_lighting_bsp18_direct_set(0.5, -1, 0.10, 1) );
	thread( f_lighting_bsp18_indirect_set(0.5, -1, 0.10, 1) );
	sleep_s( 0.5 );
	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );

	sleep_until( f_maintenance_hall_destruction_complete(), 1 );
	sleep_rand_s( 0.5, 0.75 );										
	thread( f_lighting_bsp18_direct_set(2.5, -1, 0.75, 1) );
	thread( f_lighting_bsp18_indirect_set(2.5, -1, 0.75, 1) );
	
	if ( not volume_test_players(tv_vehiclebay_airlock_area) ) then
		f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	end

	thread( fx_explosionalley_destruction(FALSE) );
	
	L_maintenance_hall_rumble_ID = f_screenshake_rumble_global_remove( L_maintenance_hall_rumble_ID, -1, 1.5 );
	
	wake( f_maintenance_hall_destruction_deinit );

end

script static void f_maintenance_hall_explosion_trigger( short s_index, cutscene_flag flg_loc, object obj_object, effect fx_tag, damage dmg_tag, string str_notify, real r_delay, short s_next_min, boolean B_check_area, short s_sfx_state )
	// increment total
	S_maintenance_hall_explosion_total = S_maintenance_hall_explosion_total + 1;

	// wait for event conditions
	sleep_until( (L_maintenance_hall_explosion_timer <= game_tick_get()) and ((S_maintenance_hall_explosion_trigger >= s_index) or ((objects_distance_to_flag(players(),flg_loc) <= 3.75) and (volume_test_players(tv_explosionalley_area) or (not B_check_area)))), 1 );
	
	if ( S_maintenance_hall_explosion_trigger <= s_index) then
		S_maintenance_hall_explosion_trigger = s_index;
	end

	if ( S_maintenance_hall_explosion_trigger == s_index ) then
	
		// set the sfx state
		thread( sfx_explosion_alley_destruction(s_sfx_state) );

		if ( (objects_distance_to_flag(players(),flg_loc) > 1.875) or (player_count() == 0) ) then
		
			// start the timer
			L_maintenance_hall_explosion_timer = game_tick_get() + seconds_to_frames(r_delay);
			
			if ( obj_object != NONE ) then
				object_set_physics( obj_object, TRUE );
			end
			
			if ( fx_tag != NONE ) then
				effect_new( fx_tag, flg_loc );
			end
	
			if ( dmg_tag != NONE ) then
				damage_new( dmg_tag, flg_loc );
			end
			
		
			if ( str_notify != "" ) then
				NotifyLevel( str_notify );
			end
			
			L_maintenance_hall_explosion_fired = L_maintenance_hall_explosion_fired + 1;
			
		end
		
		S_maintenance_hall_explosion_trigger = S_maintenance_hall_explosion_trigger + random_range( s_next_min, 2 );
		
	end

end

script dormant test_explosion_alley()
static real l_time = game_tick_get();

	wake( f_maintenance_hall_destruction_init );

	if ( S_maintenance_hall_explosion_trigger <= 1 ) then
		S_maintenance_hall_explosion_trigger = 1;
	end

	sleep_until ( f_maintenance_hall_destruction_complete(), 1 );
	//dprint( "----------------------------------------" );
	//dprint( "::: test_explosion_alley: TOTAL TIME :::" );
	//dprint( "----------------------------------------" );
	inspect( frames_to_seconds(game_tick_get() - l_time) );
	//dprint( "----------------------------------------" );
	//dprint( "::: test_explosion_alley: TOTAL FIRED :::" );
	//dprint( "----------------------------------------" );
	inspect( L_maintenance_hall_explosion_fired );

end

// === f_maintenance_hall_destruction_active::: Checks if the destruciton is active
script static boolean f_maintenance_hall_destruction_active()
	(S_maintenance_hall_explosion_trigger > -1) and (not f_maintenance_hall_destruction_complete());
end
// === f_maintenance_hall_destruction_complete::: Checks if the destruciton is complete
script static boolean f_maintenance_hall_destruction_complete()
	(S_maintenance_hall_explosion_trigger > S_maintenance_hall_explosion_total) and (S_maintenance_hall_explosion_total > 0);
end

// === f_maintenance_hall_destruction_trigger_player::: Triggers the destruction action
script dormant f_maintenance_hall_destruction_trigger_player()
static long l_timer 	= 0;

	sleep_until( volume_test_players(tv_explosionalley_area) or f_maintenance_hall_destruction_active(), 1 );
	//dprint( "::: f_maintenance_hall_destruction_trigger_player :::" );

	if ( not f_maintenance_hall_destruction_active() ) then
		thread( fx_explosionalley_destruction(TRUE) );
	
		// start the destruction
		S_maintenance_hall_explosion_trigger = 0;

		// wait to start	
		l_timer = game_tick_get() + seconds_to_frames( 5.0 );
		sleep_until( (l_timer <= game_tick_get()) or (volume_test_players(tv_ea_destruction_player_force)) or (S_maintenance_hall_explosion_trigger > 0), 1 );

//		if ( (not f_maintenance_hall_destruction_complete()) and volume_test_players(tv_explosionalley_area) ) then
//			// VO
//			wake( f_dialog_Run_Start );
//		end

		if ( S_maintenance_hall_explosion_trigger == 0 ) then
			sleep_forever( f_maintenance_hall_destruction_trigger_AI );

			// start the first trigger
			S_maintenance_hall_explosion_trigger = 1;
		end

	end
			
end

// === f_maintenance_hall_destruction_trigger_AI::: Triggers the destruction action
script dormant f_maintenance_hall_destruction_trigger_AI()
	sleep_until( volume_test_objects( tv_ea_destruction_ai_force, ai_actors(gr_maintenance_explosionalley) ) or f_maintenance_hall_destruction_active(), 1 );
	//dprint( "::: f_maintenance_hall_destruction_trigger_AI :::" );
	
	if ( not f_maintenance_hall_destruction_active() ) then
		thread( fx_explosionalley_destruction(TRUE) );

		// start the destruction
		S_maintenance_hall_explosion_trigger = 0;

		// give them a little wiggle room
		sleep_rand_s( 0.75, 1.5 );

		if ( S_maintenance_hall_explosion_trigger == 0 ) then
			sleep_forever( f_maintenance_hall_destruction_trigger_player );

			// start the first trigger
			S_maintenance_hall_explosion_trigger = 1;
		end
	end	

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: AIRLOCK
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_airlock_init::: Initialize
script dormant f_maintenance_airlock_init()
	//dprint( "::: f_maintenance_airlock_init :::" );

	// initialize sub modules
	wake( f_maintenance_airlock_door01_init );
	wake( f_maintenance_airlock_door02_init );
	wake( f_maintenance_airlock_blackout_init );

	// setup triggers
	wake( f_maintenance_airlock_trigger_vo );
	
end

// === f_maintenance_airlock_trigger_vo::: Initialize
script dormant f_maintenance_airlock_trigger_vo()
	sleep_until( volume_test_players(tv_vehiclebay_airlock_area), 1 );
	//dprint( "::: f_maintenance_airlock_trigger_vo :::" );

	wake( f_dialog_VehicleBay_Airlock );
end

// === f_maintenance_airlock_deinit::: Deinitialize
script dormant f_maintenance_airlock_deinit()
	//dprint( "::: f_maintenance_airlock_deinit :::" );

	// kill any functions
	sleep_forever( f_maintenance_airlock_init );
	sleep_forever( f_maintenance_airlock_trigger_vo );

	// deinitialize sub modules
	wake( f_maintenance_airlock_door01_deinit );
	wake( f_maintenance_airlock_door02_deinit );
	wake( f_maintenance_airlock_blackout_deinit );

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: AIRLOCK: DOORS: 01
// -------------------------------------------------------------------------------------------------
// variables
global real DEF_MAINTENANCE_HALL_01_CLOSE_POS = 0.125;

// functions
// === f_maintenance_airlock_door01_init::: Initialize
script dormant f_maintenance_airlock_door01_init()
	sleep_until( object_valid(dm_maintenance_hall_door01), 1 );
	//dprint( "::: f_maintenance_airlock_door01_init :::" );
	
	// when the door is open
	wake( f_maintenance_airlock_door01_autoopen );

end

// === f_maintenance_airlock_door01_deinit::: Deinitialize
script dormant f_maintenance_airlock_door01_deinit()
	//dprint( "::: f_maintenance_airlock_door01_deinit :::" );

	// kill any functions
	sleep_forever( f_maintenance_airlock_door01_init );
	sleep_forever( f_maintenance_airlock_door01_autoopen );
	sleep_forever( f_maintenance_airlock_door01_autoclose );
	sleep_forever( f_maintenance_airlock_door01_trigger );
	sleep_forever( f_maintenance_airlock_door01_action );

end

// === f_maintenance_airlock_door01_opened::: Handles auto opening the door
script dormant f_maintenance_airlock_door01_autoopen()

	if ( not volume_test_players_all(tv_vehiclebay_airlock_area) ) then
		// setup auto open
		dm_maintenance_hall_door01->speed_set( (dm_maintenance_hall_door01->speed_fast() + dm_maintenance_hall_door01->speed_very_fast()) / 2 );
		thread( dm_maintenance_hall_door01->auto_distance_open(-7.5, FALSE) );
		sleep_until( dm_maintenance_hall_door01->check_open(), 1 );
		//dprint( "::: f_maintenance_airlock_door01_opened :::" );
	
		// Setup auto close
		wake( f_maintenance_airlock_door01_autoclose );
	end

	// Setup auto close trigger
	wake( f_maintenance_airlock_door01_trigger );

end

// === f_maintenance_airlock_door01_autoclose::: Closes the door behind the players
script dormant f_maintenance_airlock_door01_autoclose()
	sleep_until( (not volume_test_objects(tv_vehiclebay_airlock_area,ai_actors(gr_maintenance_explosionalley))) and volume_test_players_all(tv_vehiclebay_airlock_area), 1 );
	// close the door when all players are in
	dm_maintenance_hall_door01->auto_trigger_close( tv_vehiclebay_airlock_area, TRUE, TRUE, TRUE );
	//dprint( "::: f_maintenance_airlock_door01_autoclose :::" );
	
end	

// === f_maintenance_airlock_door01_trigger::: Closes the door behind the players
script dormant f_maintenance_airlock_door01_trigger()
	sleep_until( device_get_position(dm_maintenance_hall_door01) <= DEF_MAINTENANCE_HALL_01_CLOSE_POS, 1 );

	// close the door when all players are in
	//dprint( "::: f_maintenance_airlock_door01_trigger :::" );
	sfx_end_alarm_set( DEF_S_END_ALARM_STATE_BLACKOUT );
	
	// action
	wake( f_maintenance_airlock_door01_action );
	
end	

// === f_maintenance_airlock_door01_action::: Action
script dormant f_maintenance_airlock_door01_action()
	//dprint( "::: f_maintenance_airlock_door01_action :::" );
	
		//datamine
	data_mine_set_mission_segment( "m10_END_vehiclebay_airlock" );

	// blackout
	wake( f_maintenance_airlock_blackout_action );

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: CHECKPOINT
// -------------------------------------------------------------------------------------------------
// === f_maintenance_airlock_checkpoint::: Checkpoint
script dormant f_maintenance_airlock_checkpoint()
static boolean b_checkpoint = FALSE;
	//dprint( "::: f_maintenance_airlock_checkpoint :::" );

	if ( not b_checkpoint ) then
		game_save();
		sleep( 1 );
		
		transition_fov( -1, -1, 0.0, -1 );
		//render_default_lighting = FALSE;
	end

end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: BLACKOUT
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_airlock_blackout_init::: Initialize
script dormant f_maintenance_airlock_blackout_init()
	dprint( "::: f_maintenance_airlock_blackout_init :::" );

end

// === f_maintenance_airlock_blackout_deinit::: Deinitialize
script dormant f_maintenance_airlock_blackout_deinit()
	//dprint( "::: f_maintenance_airlock_blackout_deinit :::" );

	sleep_forever( f_maintenance_airlock_blackout_init );
	sleep_forever( f_maintenance_airlock_blackout_action );

end

// === f_maintenance_airlock_blackout_action::: Do the blackout event
script dormant f_maintenance_airlock_blackout_action()
static real r_blackout_lighting_start_time = 1.0;
static real r_blackout_lighting_start_level = 0.0;
static real r_blackout_lighting_return_time = 3.125;
static real r_blackout_lighting_return_level = 0.125;

	//dprint( "::: f_maintenance_airlock_blackout_action :::" );

	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );

	// blackout VO
	wake( f_dialog_ShipVO_Blackout );
	sleep_until( dialog_id_played_check(L_dialog_ShipVO_Blackout), 1 );
	
	// xxx blackout
	thread( sfx_vehiclebay_blackout() );
	thread( f_lighting_bsp18_direct_set(r_blackout_lighting_start_time, -1, r_blackout_lighting_start_level, 1) );
	thread( f_lighting_bsp18_indirect_set( r_blackout_lighting_start_time, -1, r_blackout_lighting_start_level, 1) );
	sleep_s( r_blackout_lighting_start_time );
	
	// load the zone
	//f_insertion_zoneload( S_zoneset_36_hallway_38_vehicle_40_debris, TRUE );

	sleep_until( B_sfx_blackout_complete or B_maintenance_airlock_ICS_started, 1 );

	sleep_s( 0.75 );
	thread( f_lighting_bsp18_direct_set(r_blackout_lighting_return_time, -1, r_blackout_lighting_return_level, 1) );
	thread( f_lighting_bsp18_indirect_set(r_blackout_lighting_return_time, -1, r_blackout_lighting_return_level, 1) );

	sleep_s( 0.5 );
	if ( not B_maintenance_airlock_ICS_started ) then
		thread( f_objective_set(DEF_R_OBJECTIVE_PRY_POD_DOOR, FALSE, TRUE, FALSE, TRUE) );
		f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_BLACKOUT );
	end
	
	//wake( f_maintenance_airlock_checkpoint );

end


// -------------------------------------------------------------------------------------------------
// MAINTENANCE: HALL: DOORS: 02
// -------------------------------------------------------------------------------------------------
// variables
global boolean B_maintenance_airlock_ICS_started = FALSE;

// functions
// === f_maintenance_airlock_door02_init::: Initialize
script dormant f_maintenance_airlock_door02_init()

	wake( f_maintenance_airlock_door02_trigger );
	
end
	
// === f_maintenance_airlock_door02_deinit::: Deinitialize
script dormant f_maintenance_airlock_door02_deinit()
	//dprint( "::: f_maintenance_airlock_door02_deinit :::" );

	// kill any functions
	sleep_forever( f_maintenance_airlock_door02_init );
	sleep_forever( f_maintenance_airlock_door02_trigger );

end
	
// === f_maintenance_airlock_door02_trigger::: Trigger for the ICS door
script dormant f_maintenance_airlock_door02_trigger()
	sleep_until( volume_test_players(tv_spacesuck)==true, 1 );
	f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_NONE );
	f_screenshake_ambient_pause( TRUE, FALSE, 0.0 );
	sleep(1);
	// load the zone
	thread( dm_maintenance_hall_door01->close_instant() );
	f_insertion_zoneload( S_zoneset_36_hallway_38_vehicle_40_debris, TRUE );

//	wake (f_dialog_rail_sequence);

	g_ics_player=player_get_first_alive();
	pup_play_show(vehicle_bay);
end

script static void f_force_scenery_door()
		//dprint("open sn door");
		scenery_animation_start ( sn_maintenance_door_02, environments\solo\m10_crash\scenery\m10_ics_elevator_door01\m10_ics_elevator_door01  ,"m10_ics_elevator_door01");
end

script static void f_title_card_display()
	music_stop('Stop_mus_m10'); 
	cui_load_screen( 'environments\solo\m10_crash\ui\m10_ending_logo.cui_screen' );
	sleep_s(6.5);

	game_won();
end