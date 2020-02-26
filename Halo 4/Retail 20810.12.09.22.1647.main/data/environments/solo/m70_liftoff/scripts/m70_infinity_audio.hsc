//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// infinity_audio
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_infinity_audio_init::: Initialize
script dormant f_infinity_audio_init()
	dprint( "::: f_infinity_audio_init :::" );

	// initialize modules

	// initialize sub modules
	//wake( f_infinity_audio_CCC_init );

end

// === f_infinity_audio_deinit::: Deinitialize
script dormant f_infinity_audio_deinit()
	dprint( "::: f_infinity_audio_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_audio_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_infinity_audio_CCC_deinit );

end


/*
// -------------------------------------------------------------------------------------------------
// infinity_audio: CCC
// -------------------------------------------------------------------------------------------------
// variables
//global boolean <t>_infinity_audio_<NAME> = <VALUE>;

// functions
// === f_infinity_audio_CCC_init::: Initialize infinity_audio: CCC sub module
script dormant f_infinity_audio_CCC_cleanup()
	dprint( "::: f_infinity_audio_CCC_cleanup :::" );

	// XXX_TODO

end

// === f_infinity_audio_CCC_deinit::: Initialize infinity_audio: CCC sub module
script dormant f_infinity_audio_CCC_deinit()
	dprint( "::: f_infinity_audio_CCC_deinit :::" );

	// XXX_TODO

end
*/