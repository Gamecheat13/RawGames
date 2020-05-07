//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_02_audio
// =================================================================================================
// =================================================================================================
// variables

script dormant f_spire_02_audio_INT_init()
	dprint( "::: f_spire_02_audio_EXT_init :::" );

	// initialize modules
	wake(f_spire_02_encounter);
	// initialize sub modules
	//wake( f_spire_02_audio_CCC_init );

end


// === f_spire_02_audio_deinit::: Deinitialize
script dormant f_spire_02_audio_INT_deinit()
	dprint( "::: f_spire_02_audio_deinit :::" );

	// kill functions
	sleep_forever( f_spire_02_audio_INT_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_spire_02_audio_CCC_deinit );

end


script dormant f_spire_02_encounter()
	dprint("f_spire_02_encounter");
	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_START(), 1 );
	
	thread(f_mus_m70_e04_begin());

	sleep_until(S_SP02_OBJ_CON == S_DEF_OBJ_CON_SP02_ZERO_CORE(), 1 );
	
	thread(f_mus_m70_e04_finish());


end