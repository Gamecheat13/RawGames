//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
;
; Mission: 					m80_delta
;	Insertion Points:	to_<area> (or itl)
;										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434



// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** MISSION: SHAKES: FX ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real DEF_R_MISSION_SHAKE_FX_START = 								DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_LOW() * 0.75;
static real DEF_R_MISSION_SHAKE_FX_END = 									DEF_R_SCREENSHAKE_AMBIENT_INTENSITY_VERY_LOW() * 0.5;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_mission_shakes_fx_init::: Initialize
script dormant f_mission_shakes_fx_init()
	//dprint( "::: f_mission_shakes_fx_init :::" );
	
	wake( f_mission_shakes_fx_trigger );

end

// === f_mission_shakes_fx_deinit::: Deinitialize
script dormant f_mission_shakes_fx_deinit()
	//dprint( "::: f_mission_shakes_fx_deinit :::" );

	// kill functions
	kill_script( f_mission_shakes_fx_init );
	kill_script( f_mission_shakes_fx_trigger );

end

// === f_mission_shakes_fx_fx::: FX
script dormant f_mission_shakes_fx_trigger()
local short s_zoneset_current = 0;

	repeat
	
		// start
		sleep_until( f_R_screenshake_intensity_global_get() >= DEF_R_MISSION_SHAKE_FX_START, 1 );
		//effect_attached_to_camera_new( '\environments\solo\m80_delta\fx\destruction\falling_debris_player.effect' );
		//dprint( "::: f_mission_shakes_fx_fx: START :::" );

		// store current zone set		
		s_zoneset_current = zoneset_current();

		if ( (s_zoneset_current == S_ZONESET_CRASH or s_zoneset_current == S_ZONESET_CRASH_TRANSITION) ) then
			//dprint( "f_mission_shakes_fx_fx: 02_crash" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small.effect","fx_cr_rumble_rocks_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_cr_rumble_rocks_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_cr_rumble_rocks_3");
		end

		if ( (s_zoneset_current == S_ZONESET_CRASH) or (s_zoneset_current == S_ZONESET_CRASH_TRANSITION) or (s_zoneset_current == S_ZONESET_TO_HORSESHOE) ) then
			//dprint( "f_mission_shakes_fx_fx: 03_to_horseshoe" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_th_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_th_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small","fx_th_rumble_rocks_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small","fx_th_rumble_rocks_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small","fx_th_rumble_rocks_3");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_HORSESHOE) or (s_zoneset_current == S_ZONESET_HORSESHOE) or (s_zoneset_current == S_ZONESET_TO_LAB) ) then
			//dprint( "f_mission_shakes_fx_fx: 04_horseshoe" );
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_1");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_5");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_hs_rumble_rocks_9");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_LAB) or (s_zoneset_current == S_ZONESET_LAB) ) then
			//dprint( "f_mission_shakes_fx_fx: 05_to_lab" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tl_rumble_dust3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tl_rumble_dust6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust9");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust10");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust11");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust12");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tl_rumble_dust13");
		end

		if ( (s_zoneset_current == S_ZONESET_LAB) or (s_zoneset_current == S_ZONESET_LAB_EXIT) ) then
			//dprint( "f_mission_shakes_fx_fx: 06_lab" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_la_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_la_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_la_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_la_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_la_rumble_dust_5");
		end

		//if ( (s_zoneset_current == xxx) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 07_lift" );
		//end

		//if ( (s_zoneset_current == xxx) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 08_lift_view" );
		//end

		if ( (s_zoneset_current == S_ZONESET_ATRIUM) or (s_zoneset_current == S_ZONESET_MECHROOM_RETURN) ) then
			//dprint( "f_mission_shakes_fx_fx: 09_mechroom" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_mr_rumble_dust1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_mr_rumble_dust2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_mr_rumble_dust3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_mr_rumble_dust4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_mr_rumble_dust5");
		end

		if ( (s_zoneset_current == S_ZONESET_ATRIUM) or (s_zoneset_current == S_ZONESET_ATRIUM_HUB) or (s_zoneset_current == S_ZONESET_ATRIUM_LOOKOUT) or (s_zoneset_current == S_ZONESET_ATRIUM_DAMAGED) or (s_zoneset_current == S_ZONESET_MECHROOM_RETURN) ) then
			//dprint( "f_mission_shakes_fx_fx: 10_atrium" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_01");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_02");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_03");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_04");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_05");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_06");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_07");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_08");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_09");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_010");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_011");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_012");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_013");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_014");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_015");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_016");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_017");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_018");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_019");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_020");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_021");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_large","fx_at_rumble_rocks_022");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE) ) then
			//dprint( "f_mission_shakes_fx_fx: 11_to_airlock_one" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_ta_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ta_rumble_dust_8");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE_B) or (s_zoneset_current == S_ZONESET_AIRLOCK_ONE) or (s_zoneset_current == S_ZONESET_TO_AIRLOCK_TWO) ) then
			//dprint( "f_mission_shakes_fx_fx: 12_airlock_one" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_ao_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_ao_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ao_rumble_dust_9");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_AIRLOCK_TWO) or (s_zoneset_current == S_ZONESET_AIRLOCK_TWO) ) then
			//dprint( "f_mission_shakes_fx_fx: 13_to_airlock_two" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_tat_rumble_rocks_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_med","fx_tat_rumble_rocks_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small","fx_tat_rumble_rocks_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tat_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tat_rumble_dust_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tat_rumble_dust_9");
		end

		if ( (s_zoneset_current == S_ZONESET_AIRLOCK_TWO) or (s_zoneset_current == S_ZONESET_TO_LOOKOUT)  ) then
			//dprint( "f_mission_shakes_fx_fx: 14_airlock_two" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_rumble_dust_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_rumble_dust_9");
			
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_1");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_2");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_3");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_4");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_5");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_6");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_7");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_atw_rumble_dust_8");
			//effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_atw_rumble_dust_9");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_LOOKOUT) or (s_zoneset_current == S_ZONESET_LOOKOUT)or (s_zoneset_current == S_ZONESET_LOOKOUT_EXIT) ) then
			//dprint( "f_mission_shakes_fx_fx: 15_lookout" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_lo_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_lo_rumble_dust_8");
		end

		//if ( (s_zoneset_current == S_ZONESET_LOOKOUT) or (s_zoneset_current == S_ZONESET_LOOKOUT_EXIT) or (s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_A) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 16_turrets" );
		//end

		//if ( (s_zoneset_current == xxx) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 17_asteroids" );
		//end

		if ( (s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_B) or (s_zoneset_current == S_ZONESET_ATRIUM_RETURNING) ) then
			//dprint( "f_mission_shakes_fx_fx: 18_atrium_return" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ar_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ar_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ar_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ar_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_rocks_small","fx_ar_rumble_rocks_5");
		end

		//if ( (s_zoneset_current == S_ZONESET_COMPOSER_REMOVAL) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 19_atrium_damaged" );
		//end

		//if ( (s_zoneset_current == xxx) ) then
		//	//dprint( "f_mission_shakes_fx_fx: 20_mechroom_return" );
		//end

		if ( (s_zoneset_current == S_ZONESET_ATRIUM_HUB) or (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE) ) then
			//dprint( "f_mission_shakes_fx_fx: 21_atrium_hub" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ah_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_ah_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_ah_rumble_dust_3");
		end

		if ( (s_zoneset_current == S_ZONESET_LOOKOUT_EXIT) or (s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_A) or (s_zoneset_current == S_ZONESET_LOOKOUT_HALLWAYS_B) ) then
			//dprint( "f_mission_shakes_fx_fx: 22_turret_hub" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_9");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_10");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_11");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_12");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_13");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_th_rumble_dust_14");
		end

		if ( (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE) or (s_zoneset_current == S_ZONESET_TO_AIRLOCK_ONE_B) ) then
			//dprint( "f_mission_shakes_fx_fx: 23_20_airlock_one_b" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tao_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_5");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_6");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_med","fx_tao_rumble_dust_7");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_8");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_tao_rumble_dust_9");
		end

		if ( (s_zoneset_current == S_ZONESET_ATRIUM_RETURNING) or (s_zoneset_current == S_ZONESET_ATRIUM_LOOKOUT) ) then
			//dprint( "f_mission_shakes_fx_fx: 24_atrium_lookout" );
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_alf_rumble_dust_1");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_alf_rumble_dust_2");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_alf_rumble_dust_3");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_alf_rumble_dust_4");
			effect_new("environments\solo\m80_delta\fx\destruction\falling_debris_dust_small","fx_alf_rumble_dust_5");
		end
	
		// stop
		sleep_until( f_R_screenshake_intensity_global_get() < DEF_R_MISSION_SHAKE_FX_END, 1 );
		//effect_attached_to_camera_stop( '\environments\solo\m80_delta\fx\destruction\falling_debris_player.effect' );
		//dprint( "::: f_mission_shakes_fx_fx: STOP :::" );
	
	until( FALSE, 1 );

end
