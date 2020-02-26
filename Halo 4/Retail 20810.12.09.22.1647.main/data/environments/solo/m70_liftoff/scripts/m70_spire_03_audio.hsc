//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_03_INT_audio
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_spire_03_INT_audio_init::: Initialize
script dormant f_spire_03_audio_init()
	dprint( "::: f_spire_03_INT_audio_init :::" );
	//sleep_until()
	
	wake(f_spire_03_encounter_audio);
	// initialize modules

	// initialize sub modules
	//wake( f_spire_03_INT_audio_CCC_init );

end

// === f_spire_03_INT_audio_deinit::: Deinitialize
script dormant f_spire_03_audio_deinit()
	dprint( "::: f_spire_03_INT_audio_deinit :::" );

	// kill functions
	sleep_forever( f_spire_03_audio_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_spire_03_INT_audio_CCC_deinit );

end


script dormant f_spire_03_encounter_audio()
	dprint("f_spire_03_encounter_audio");

end
