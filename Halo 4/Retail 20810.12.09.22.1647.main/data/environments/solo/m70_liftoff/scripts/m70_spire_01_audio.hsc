//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_01_INT_audio
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_spire_01_INT_audio_init::: Initialize
script dormant f_spire_01_audio_init()
	dprint( "::: f_spire_01_INT_audio_init :::" );

	// initialize modules
	wake(f_spire_01_encounter_audio);
	// initialize sub modules
	//wake( f_spire_01_INT_audio_CCC_init );

end

// === f_spire_01_INT_audio_deinit::: Deinitialize
script dormant f_spire_01_audio_deinit()
	dprint( "::: f_spire_01_INT_audio_deinit :::" );

	// kill functions
	sleep_forever( f_spire_01_audio_init );
	sleep_forever(f_spire_01_encounter_audio);
	// deinitialize modules

	// deinitialize sub modules
	//wake( f_spire_01_INT_audio_CCC_deinit );

end


script dormant f_spire_01_encounter_audio()
	dprint("f_spire_01_encounter_audio");
	sleep_until(object_valid(dm_sp01_gondola), 1);
	sleep_s(1);
	sleep_until( sp01_gondola_moving, 1 );
	thread(f_mus_m70_e02_begin());
	//xxx need to update volume
	sleep_until(volume_test_players(tv_sp01_int_to_ext), 1);
	
	thread(f_mus_m70_e03_finish());
end