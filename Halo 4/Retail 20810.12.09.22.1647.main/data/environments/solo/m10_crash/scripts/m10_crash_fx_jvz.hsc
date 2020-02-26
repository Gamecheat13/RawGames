//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_fx_jvz
//	Insertion Points:	start (or icr)	- Beginning
//										ila							- Lab / Armory
//										iob							- Observation Deck
//										ifl							- Flank / Prep Room
//										ibe							- Beacon
//										ibr							- Broken Floor
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
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


//__________________________________________________________________________________
//
//  Script Notes
//__________________________________________________________________________________
//
///////  variables: /////////////////
//  static real x = 1.0;         .......static = local  &  real = float
//
///////  looping: //////////////////
//  repeat
//  .....stuff_to_repeat_here......
//  until(0 == 1);
//
///////  Pausing ///////////////////
//  sleep (....time_in_frames...);
//___________________________________________________________________________________

script startup m10_crash_fx_jvz()

	if b_debug then 
		print ("::: M10 - FX - JVZZ :::");
	end
	sleep (150);
	thread(test_fx_jvzz());
end


script static void test_fx_jvzz()
	print ("::: test FX jvzz:::");

	

	//effect_new( environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, fx_sparks_lockup_2 );
	//effect_new( environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, fx_sparks_lockup_1 );

	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust_02.effect, fx_ell_dustup_1 );
	
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_2 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_3 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_4 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_5 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_6 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_7 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_8 );
	//effect_new( environments\solo\m10_crash\fx\dust_settle\grav_dust.effect, fx_ell_dustup_9 );
	
	//effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g.effect, fx_pod_debris01 );
	//effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g.effect, fx_air_escape01 );

	//effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g_02.effect, fx_pod_debris02 );
    //effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g_02.effect, fx_air_escape02 );
	
	//effect_new( environments\solo\m10_crash\fx\dust_door_open.effect, fx_pb_airlock );
end
