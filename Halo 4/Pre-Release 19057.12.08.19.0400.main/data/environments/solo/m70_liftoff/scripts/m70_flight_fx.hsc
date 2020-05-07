//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// flight_FX
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_flight_FX_init::: Initialize
script dormant f_flight_FX_init()
	dprint( "::: f_flight_FX_init :::" );

	// initialize modules

	// initialize sub modules
	//wake( f_flight_FX_CCC_init );

end

// === f_flight_FX_deinit::: Deinitialize
script dormant f_flight_FX_deinit()
	dprint( "::: f_flight_FX_deinit :::" );

	// kill functions
	sleep_forever( f_flight_FX_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_flight_FX_CCC_deinit );

end

script static void f_flight_didact_kill_effect()
	effect_new(environments\solo\m70_liftoff\fx\cryptum\cryptum_pulse.effect, flg_didact_center );
end