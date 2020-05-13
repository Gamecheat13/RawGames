//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m40_invasion_fx
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// *** GLOBALS ***
// =================================================================================================
// =================================================================================================

//

// =================================================================================================
// =================================================================================================
// *** START-UP ***
// =================================================================================================
// =================================================================================================

script startup m40_invasion_fx()

	if b_debug then 
		print ("::: M40 - FX :::");
	end
	
	thread(test_fx());
end

script static void test_fx()
	print ("::: test FX :::");
	//effect_new( cinematics\cin_verticalslice\fx\rig_spark_pipe.effect, test_fx );
	effect_attached_to_camera_new( environments\solo\m40_invasion\fx\dust\particulates.effect );
end


script static void fx_skybox_lensflares()
	print ("fx_skybox_lensflares");
	effect_new(environments\solo\m40_invasion\fx\lens_flare\skylensflare1.effect, fx_skybox_lakeflare);
	effect_new(environments\solo\m40_invasion\fx\lens_flare\skylensflare2.effect, fx_skyboxflare);
end


// ===========================================================
// Tractor Beam Destruction Vignette Dust and Debris FX
// ===========================================================

//	Falling Debris and Dust Impacts
script static void fx_tractor_fall_debris()
	dprint("play_fx_tractor_beam_falling_debris()");
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_03);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_02);
	sleep(6);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_02.effect, air_strike_destruction, fx_destruct_debris_01);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_04);
	sleep(8);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_05);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_02.effect, air_strike_destruction, fx_destruct_debris_09);
//	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_06);
	sleep(30);
	effect_new(environments\solo\m40_invasion\fx\dust\tractor_debris_impact_01.effect, fx_tractor_impact_01);
	effect_new(environments\solo\m40_invasion\fx\dust\tractor_debris_impact_01.effect, fx_tractor_impact_02);
	sleep(15);
	effect_new(environments\solo\m40_invasion\fx\dust\tractor_debris_impact_02.effect, fx_tractor_impact_03);
	sleep(10);
	effect_new(environments\solo\m40_invasion\fx\dust\tractor_debris_impact_01.effect, fx_tractor_impact_04);
	sleep(15);
	effect_new(environments\solo\m40_invasion\fx\dust\tractor_debris_impact_02.effect, fx_tractor_impact_05);
	sleep(20);
	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_02.effect, air_strike_destruction, fx_destruct_debris_07);
//	effect_new_on_object_marker(environments\solo\m40_invasion\fx\dust\tractor_dust_falling_debris_01.effect, air_strike_destruction, fx_destruct_debris_08);
end

