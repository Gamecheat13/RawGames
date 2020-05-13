//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_guns_hallway (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GUNS: HALLWAY: NARRATIVE ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// === f_guns_hallway_narrative_init::: Initialize
script dormant f_guns_hallway_narrative_init()
	//dprint( "::: f_guns_hallway_narrative_init :::" );
	
	// init sub modules
	if ( zoneset_current_active() < S_ZONESET_LOOKOUT_HALLWAYS_B ) then
		wake( f_guns_hallway_narrative_scan_init );
		wake( f_guns_hallway_narrative_didact_init );
	end

end

// === f_guns_hallway_narrative_deinit::: Deinitialize
script dormant f_guns_hallway_narrative_deinit()
	//dprint( "::: f_guns_hallway_narrative_deinit :::" );

	// deinit sub modules
	wake( f_guns_hallway_narrative_scan_deinit );
	wake( f_guns_hallway_narrative_didact_deinit );

	// kill functions
	kill_script( f_guns_hallway_narrative_init );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: NARRATIVE: SCAN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_narrative_scan_init::: Init
script dormant f_guns_hallway_narrative_scan_init()
	//dprint( "::: f_guns_hallway_narrative_scan_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_narrative_scan_trigger );
	
end

// === f_guns_hallway_narrative_scan_deinit::: Deinit
script dormant f_guns_hallway_narrative_scan_deinit()
	//dprint( "::: f_guns_hallway_narrative_scan_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_narrative_scan_init );
	kill_script( f_guns_hallway_narrative_scan_trigger );
	//kill_script( f_guns_hallway_narrative_scan_action );
	
end

// === f_guns_hallway_narrative_scan_trigger::: Trigger
script dormant f_guns_hallway_narrative_scan_trigger()
	sleep_until( volume_test_players(tv_close_door_hallways_exit), 1 );
	//dprint( "::: f_guns_hallway_narrative_scan_trigger :::" );
	
	// action
	//wake( f_guns_hallway_narrative_scan_action );
	
end
/*
// === f_guns_hallway_narrative_scan_action::: Action
script dormant f_guns_hallway_narrative_scan_action()
	//dprint( "::: f_guns_hallway_narrative_scan_action :::" );
	
	sleep_s( 1.5 );
	effect_new( environments\solo\m80_delta\fx\scan\dscan_post_atrium.effect, fx_lookout_didact_scan );
	
end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// GUNS: HALLWAY: NARRATIVE: DIDACT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_guns_hallway_narrative_didact_init::: Init
script dormant f_guns_hallway_narrative_didact_init()
	//dprint( "::: f_guns_hallway_narrative_didact_init :::" );
	
	// setup trigger
	wake( f_guns_hallway_narrative_didact_trigger );
	
end

// === f_guns_hallway_narrative_didact_deinit::: Deinit
script dormant f_guns_hallway_narrative_didact_deinit()
	//dprint( "::: f_guns_hallway_narrative_didact_deinit :::" );
	
	// kill functions
	kill_script( f_guns_hallway_narrative_didact_init );
	kill_script( f_guns_hallway_narrative_didact_trigger );
	//kill_script( f_guns_hallway_narrative_didact_action );
	
end

// === f_guns_hallway_narrative_didact_trigger::: Trigger
script dormant f_guns_hallway_narrative_didact_trigger()
	sleep_until( f_guns_hallway_mid(), 1 );
	//dprint( "::: f_guns_hallway_narrative_didact_trigger :::" );
	
	// action
	//wake( f_guns_hallway_narrative_didact_action );
	
end
/*
// === f_guns_hallway_narrative_didact_action::: Action
script dormant f_guns_hallway_narrative_didact_action()
	//dprint( "::: f_guns_hallway_narrative_didact_action :::" );
	
	sleep_s( 5.0 );
	effect_new( environments\solo\m80_delta\fx\scan\dscan_post_atrium.effect, fx_lookout_didact_scan );
	wake( f_dialog_lookout_hallway );
	
end
*/