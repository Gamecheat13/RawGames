//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_hallways_one (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HALLWAYS: ONE: NARRATIVE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// === f_hallways_one_narrative_init::: Initialize
script dormant f_hallways_one_narrative_init()
	//dprint( "::: f_hallways_one_narrative_init :::" );
	
	// init sub modules
	//wake( f_hallways_one_narrative_scan_init );
	wake( f_hallways_one_narrative_powerloss_init );

end

// === f_hallways_one_narrative_deinit::: Deinitialize
script dormant f_hallways_one_narrative_deinit()
	//dprint( "::: f_hallways_one_narrative_deinit :::" );
	
	// init sub modules
//	wake( f_hallways_one_narrative_scan_deinit );
	wake( f_hallways_one_narrative_powerloss_deinit );

	// kill functions
	kill_script( f_hallways_one_narrative_init );

end


/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: SCAN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_narrative_scan_init::: Init
script dormant f_hallways_one_narrative_scan_init()
	//dprint( "::: f_hallways_one_narrative_scan_init :::" );
	
	// setup trigger
	wake( f_hallways_one_narrative_scan_trigger );
	
end

// === f_hallways_one_narrative_scan_deinit::: Deinit
script dormant f_hallways_one_narrative_scan_deinit()
	//dprint( "::: f_hallways_one_narrative_scan_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_one_narrative_scan_init );
	kill_script( f_hallways_one_narrative_scan_trigger );
	kill_script( f_hallways_one_narrative_scan_action );
	
end

// === f_hallways_one_narrative_scan_trigger::: Trigger
script dormant f_hallways_one_narrative_scan_trigger()
	sleep_until( volume_test_players(tv_hallways_one_didact_scan), 1 );
	//dprint( "::: f_hallways_one_narrative_scan_trigger :::" );

	// trigger action
	wake( f_hallways_one_narrative_scan_action );
	
end

// === f_hallways_one_narrative_scan_action::: Action
script dormant f_hallways_one_narrative_scan_action()
	//dprint( "::: f_hallways_one_narrative_scan_action :::" );

	// scan
	sleep_s( 0.5 );
	f_fx_interior_scan( fx_hallways_didact_scan );
	
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// HALLWAYS: ONE: POWERLOSS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------



// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
script static short DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_NONE()					0;		end
script static short DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_ACTIVE()				1;		end
script static short DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_COMPLETE()			2;		end

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_hallways_one_powerloss_state	= 												DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_NONE();

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hallways_one_narrative_powerloss_init::: Init
script dormant f_hallways_one_narrative_powerloss_init()
	//dprint( "::: f_hallways_one_narrative_powerloss_init :::" );
	
	// setup trigger for powerloss moment
	wake( f_hallways_one_narrative_powerloss_trigger );
	
end

// === f_hallways_one_narrative_powerloss_deinit::: Deinit
script dormant f_hallways_one_narrative_powerloss_deinit()
	sleep_until( not f_hallways_one_narrative_powerloss_active(), 1 );
	//dprint( "::: f_hallways_one_narrative_powerloss_deinit :::" );
	
	// kill functions
	kill_script( f_hallways_one_narrative_powerloss_init );
	kill_script( f_hallways_one_narrative_powerloss_trigger );
	kill_script( f_hallways_one_narrative_powerloss_action );
	
end

// === f_hallways_one_narrative_powerloss_trigger::: Trigger
script dormant f_hallways_one_narrative_powerloss_trigger()
	//dprint( "::: f_hallways_one_narrative_powerloss_trigger :::" );

	sleep_until( volume_test_players(tv_hallways_one_powerloss_force), 1 );
	if ( f_hallways_one_narrative_powerloss_none() ) then
		f_hallways_one_narrative_powerloss_action();
	end

end

script static void f_hallways_one_narrative_powerloss_scale( real r_time, real r_target_ratio, real r_lights_direct_start, real r_lights_indirect_start, real r_lights_low )
local real r_direct = r_lights_direct_start - ( (r_lights_direct_start - r_lights_low) * r_target_ratio );
local real r_indirect = r_lights_direct_start - ( (r_lights_indirect_start - r_lights_low) * r_target_ratio );

	//dprint( "f_hallways_one_narrative_powerloss_scale" );
	inspect( r_direct );
	inspect( r_indirect );
	f_lighting_environment_set( r_time, -1, r_direct, -1, r_indirect, -1 );

end

// === f_hallways_one_narrative_powerloss_action::: Action
script static void f_hallways_one_narrative_powerloss_action()

	if ( f_hallways_one_narrative_powerloss_none() ) then

		local real r_time = 0;
		dprint( "::: f_hallways_one_narrative_powerloss_action: START :::" );
	
		local real r_starting_direct = f_lighting_direct_get();
		local real r_starting_indirect = f_lighting_indirect_get();
		//local real r_lightling_lowest = 0.2;
		local real r_lightling_lowest = 0.1;
	
		S_hallways_one_powerloss_state = DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_ACTIVE();
	
		// powerloss shake
		thread( f_screenshake_event_very_high(-1, -1, -1, f_sfx_hallways_one_power_loss_start()) );
	
		// start lights powering down
		interpolator_start( 'powerdown' );
		f_hallways_one_narrative_powerloss_scale( 0.2, 0.95, r_starting_direct, r_starting_indirect, r_lightling_lowest );
		f_hallways_one_narrative_powerloss_scale( 0.3, 0.0, r_starting_direct, r_starting_indirect, r_lightling_lowest );
		f_hallways_one_narrative_powerloss_scale( 0.175, 0.5, r_starting_direct, r_starting_indirect, r_lightling_lowest );
		f_hallways_one_narrative_powerloss_scale( 0.4, 1.0, r_starting_direct, r_starting_indirect, r_lightling_lowest );
		sleep_s( 3.6 );
		sound_impulse_start( f_sfx_hallways_one_power_loss_end(), NONE, 1 );
		r_time = sound_impulse_time( f_sfx_hallways_one_power_loss_end() );
	
		thread( f_hallways_one_narrative_powerloss_scale(r_time, 0.0, r_starting_direct, r_starting_indirect, r_lightling_lowest) );
		sleep_s( 0.5 );
		S_hallways_one_powerloss_state = DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_COMPLETE();
	//	f_hallways_one_narrative_powerloss_scale( 0.4, 0.0, r_starting_direct, r_starting_indirect, r_lightling_lowest );
		dprint( "::: f_hallways_one_narrative_powerloss_action: END :::" );

	end
	
end

// === f_hallways_one_narrative_powerloss_none::: Checks if the state is none
script static boolean f_hallways_one_narrative_powerloss_none()
	S_hallways_one_powerloss_state == DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_NONE();
end

// === f_hallways_one_narrative_powerloss_active::: Checks if the state is active
script static boolean f_hallways_one_narrative_powerloss_active()
	S_hallways_one_powerloss_state == DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_ACTIVE();
end

// === f_hallways_one_narrative_powerloss_complete::: Checks if the state is complete
script static boolean f_hallways_one_narrative_powerloss_complete()
	S_hallways_one_powerloss_state == DEF_S_HALLWAYS_ONE_POWERLOSS_STATE_COMPLETE();
end
