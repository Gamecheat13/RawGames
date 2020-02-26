//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// flight_audio
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_flight_audio_init::: Initialize
script dormant f_flight_audio_init()
	dprint( "::: f_flight_audio_init :::" );

	// initialize modules
	thread(f_flight_encounter());
	// initialize sub modules
	//wake( f_flight_audio_CCC_init );

end

// === f_flight_audio_deinit::: Deinitialize
script dormant f_flight_audio_deinit()
	dprint( "::: f_flight_audio_deinit :::" );

	// kill functions
	sleep_forever( f_flight_audio_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_flight_audio_CCC_deinit );

end

script static void f_flight_encounter()
	dprint("f_flight_encounter");
	sleep_until(f_Flight_Zone_Active(), 1);

	thread( f_mus_m70_e01_begin() );
	
	sleep_until(  not f_Flight_Zone_Active(), 1);
	
	thread( f_mus_m70_e01_finish() );
end