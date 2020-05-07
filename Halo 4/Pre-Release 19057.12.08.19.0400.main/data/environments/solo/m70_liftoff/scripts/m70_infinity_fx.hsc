//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// infinity_FX
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_infinity_FX_init::: Initialize
script dormant f_infinity_FX_init()
	dprint( "::: f_infinity_FX_init :::" );

	// initialize modules

	// initialize sub modules
	//wake( f_infinity_FX_CCC_init );

end

// === f_infinity_FX_deinit::: Deinitialize
script dormant f_infinity_FX_deinit()
	dprint( "::: f_infinity_FX_deinit :::" );

	// kill functions
	sleep_forever( f_infinity_FX_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_infinity_FX_CCC_deinit );

end


/*
// -------------------------------------------------------------------------------------------------
// infinity_FX: CCC
// -------------------------------------------------------------------------------------------------
// variables
//global boolean <t>_infinity_FX_<NAME> = <VALUE>;

// functions
// === f_infinity_FX_CCC_init::: Initialize infinity_FX: CCC sub module
script dormant f_infinity_FX_CCC_cleanup()
	dprint( "::: f_infinity_FX_CCC_cleanup :::" );

	// XXX_TODO

end

// === f_infinity_FX_CCC_deinit::: Initialize infinity_FX: CCC sub module
script dormant f_infinity_FX_CCC_deinit()
	dprint( "::: f_infinity_FX_CCC_deinit :::" );

	// XXX_TODO

end
*/