//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// spire_01_INT_FX
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_spire_01_INT_FX_init::: Initialize
script dormant f_spire_01_FX_init()
	dprint( "::: f_spire_01_INT_FX_init :::" );

	// initialize modules

	// initialize sub modules
	//wake( f_spire_01_INT_FX_CCC_init );

end

// === f_spire_01_INT_FX_deinit::: Deinitialize
script dormant f_spire_01_FX_deinit()
	dprint( "::: f_spire_01_INT_FX_deinit :::" );

	// kill functions
	sleep_forever( f_spire_01_FX_init );

	// deinitialize modules

	// deinitialize sub modules
	//wake( f_spire_01_INT_FX_CCC_deinit );

end


/*
// -------------------------------------------------------------------------------------------------
// spire_01_INT_FX: CCC
// -------------------------------------------------------------------------------------------------
// variables
//global boolean <t>_spire_01_INT_FX_<NAME> = <VALUE>;

// functions
// === f_spire_01_INT_FX_CCC_init::: Initialize spire_01_INT_FX: CCC sub module
script dormant f_spire_01_INT_FX_CCC_cleanup()
	dprint( "::: f_spire_01_INT_FX_CCC_cleanup :::" );

	// XXX_TODO

end

// === f_spire_01_INT_FX_CCC_deinit::: Initialize spire_01_INT_FX: CCC sub module
script dormant f_spire_01_INT_FX_CCC_deinit()
	dprint( "::: f_spire_01_INT_FX_CCC_deinit :::" );

	// XXX_TODO

end
*/




// -------------------------------------------------------------------------------------------------
//  Gondola Tether FX Start
// -------------------------------------------------------------------------------------------------
script static void fx_gondola_tether_start()

    // start beam
    effect_new(environments\solo\m70_liftoff\fx\energy\gondola_tether.effect, fx_tether_start);
    effect_new_between_points(environments\solo\m70_liftoff\fx\energy\gondola_tether_beam.effect, fx_tether_start, fx_tether_end);

    effect_new(environments\solo\m70_liftoff\fx\energy\gondola_tether_chargeup.effect, fx_tether_start_chargeup);
    effect_new(environments\solo\m70_liftoff\fx\energy\gondola_tether_chargeup.effect, fx_tether_end_chargeup);

    // start beam intersection glows
    effect_new(environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, fx_tether_start);
    effect_new(environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, fx_tether_end);
 
 		if not object_valid ( gondola_light_beam ) then
		object_create ( gondola_light_beam ); //TURN ON GONDOLA LIGHT BEAM AUDIO
		end
    // start beam intersection glows on gondola
    //effect_new_on_object_marker( environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, GONDOLA_NAME, fx_gondola_beam_front);
    //effect_new_on_object_marker( environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, GONDOLA_NAME, fx_gondola_beam_back);


end

// -------------------------------------------------------------------------------------------------
//  Gondola Tether FX Stop
// -------------------------------------------------------------------------------------------------
script static void fx_gondola_tether_stop()

    // stop beam
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether.effect, fx_tether_start);
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether_beam.effect, fx_tether_start);
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether_chargeup.effect, fx_tether_start_chargeup);
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether_chargeup.effect, fx_tether_end_chargeup);

    // stop beam intersection glows
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, fx_tether_start);
    effect_delete_from_flag(environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, fx_tether_end);

		object_destroy ( gondola_light_beam ); //TURN OFF GONDOLA LIGHT BEAM AUDIO
    // stop beam intersection glows on gondola
    //effect_stop_object_marker( environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, GONDOLA_NAME, fx_gondola_beam_front);
    //effect_stop_object_marker( environments\solo\m70_liftoff\fx\energy\gondola_tether_glow.effect, GONDOLA_NAME, fx_gondola_beam_back);

end


