//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 							m10_crash_droppod_ICS
//	Insertion Points:			XXX							- Drop pod
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// Drop Pod ICS
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_droppod_ICS_startup::: Area main initialization
script startup f_droppod_ICS_startup()
	sleep_until( b_mission_started == TRUE );
	//dprint( "::: f_droppod_ICS_startup :::" );

end

// === f_droppod_ICS_start::: Start drop pod ICS
script dormant f_droppod_ICS_start()
	//dprint( "::: f_droppod_ICS_start :::" );
	
	//datamine
	data_mine_set_mission_segment( "m10_ICS_droppod" );

	// display story blurb
	//storyblurb_display( m10_ics_drop_pod, 7, FALSE, FALSE );
	
end

// === f_droppod_ICS_deinit::: Cleanup
script dormant f_droppod_ICS_deinit()
	//dprint( "::: f_droppod_ICS_deinit :::" );

	sleep_forever( f_droppod_ICS_start );

end