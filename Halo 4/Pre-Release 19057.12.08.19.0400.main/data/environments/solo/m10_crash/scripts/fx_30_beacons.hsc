
// script startup m10_crash_30_beacons_fx()
// sleep (150);


// Beacons Vignette - Archer Missile Tube Door Opening
script static void fx_missile_door_open_vapor()
	//print ("::: M10 - Beacons Vignette - Archer Missile Tube Door Opening Vapor - FX :::");
	effect_new (environments\solo\m10_crash\fx\atmosphere\beac_door_open_vapor.effect, fx_beac_accel_A_main );
end


/// Beacons Vignette - Mag Accelerator Clamp Stuck Sparks ///
script static void fx_clamp_stuck_sparks( boolean b_active )
	if ( b_active ) then
		dprint ("::: M10 - Beacons Vignette - Mag Accelerator Clamp Sparks - FX :::");
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_05 );
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_06 );
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_09 );
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_10 );

		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_02.effect, fx_sparks_lockup_07 );
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_02.effect, fx_sparks_lockup_08 );

		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_03.effect, fx_sparks_lockup_03 );
		effect_new (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_03.effect, fx_sparks_lockup_04 );
	else
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_05 );
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_06 );
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_09 );
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_01.effect, fx_sparks_lockup_10 );

		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_02.effect, fx_sparks_lockup_07 );
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_02.effect, fx_sparks_lockup_08 );

		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_03.effect, fx_sparks_lockup_03 );
		effect_kill_from_flag (environments\solo\m10_crash\fx\sparks\beac_clamp_sparks_03.effect, fx_sparks_lockup_04 );
	end
end


// Turns on/off the sparks that spew out of the magnetic accelerator rails after Master Chief kicks it
script static void fx_mag_accel_sparks( boolean b_active )
	if ( b_active ) then
		//dprint("Spark effects ON");
		effect_new_on_object_marker(environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, beac_2_mag_3, left_sparks);
		effect_new_on_object_marker(environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, beac_2_mag_3, right_sparks);
	else
		//dprint("Spark effects OFF");
		effect_stop_object_marker( environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, beac_2_mag_3, left_sparks );
		effect_stop_object_marker( environments\solo\m10_crash\fx\beacon_stuck\bea_l_stuck.effect, beac_2_mag_3, right_sparks );
	end
end


/// Beacons Vignette - Archer Missile Accelerator Chargeup. After the mag accelerator clamps down and causes the activation ///
// This one also appears to play an effect on one of the other silos.
script static void fx_missile_accel_chargeup()
	dprint ("::: M10 - Beacons Vignette - Archer Missile Accelerator Chargeup - FX :::");
	effect_new (environments\solo\m10_crash\fx\energy\beac_mag_accel_energy.effect, fx_beac_accel_A_clamp_charge );
end


// Archer Missile (formerly called the Beacon) - Jettison Launch
// This function is called from m10_crash_fx.hsc
script static void fx_archer_jettison()
	dprint ("::: M10 - Beacon Jettison Launch - FX :::");
	effect_new_on_object_marker(environments\solo\m10_crash\fx\energy\bea_jettison.effect, archer, m_attach);
end


// Turns on the booster rocket effect of the archer missile
script static void fx_archer_rocket( boolean b_active )
	//dprint("Archer missile booster ON");
	//effect_new_on_object_marker(environments\solo\m10_crash\fx\fire\fire_streaming_large.effect, archer, m_attach);
	
	if ( b_active ) then
		//dprint("Archer missile rocket fire ON");
		effect_new_on_object_marker(environments\solo\m10_crash\fx\energy\archer_missile_thrust.effect, archer, m_attach);
	else
		//dprint("Archer missile rocket fire OFF");
		effect_stop_object_marker( environments\solo\m10_crash\fx\energy\bea_jettison.effect, archer, m_attach );
		effect_stop_object_marker( environments\solo\m10_crash\fx\energy\archer_missile_thrust.effect, archer, m_attach );
	end
end


// Play the archer missile explosion
//script static void fx_beacon_launch()
//	dprint("fx_beacon_launch placeholder until m10_beacon.hsc is checked back in.");
//end
/*script static void fx_archer_detonate()
	dprint("Archer missile EXPLOSION!");
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, archer, m_attach);
end*/


/* 
	Plays the external explosions on the covenant cruisers in the Maw vignette. This particular function is for the "fx_explode_XX" markers
	that are located on the surface of the ship, as opposed to the fx_cov_cruiser_explosions2() function that is for the "fx_ship_explodeXX" markers that
	are for the internal explosions of the ship.
	
	inputs:
		oCruiser 	The name of the device machine that is getting the effect
		nMarker		The marker number (1-8) that gets the explosion
*/
script static void fx_cov_cruiser_explosions( object oCruiser, short nMarker )
	//dprint("Cruiser external explosion");	
	if (1 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_01);
	elseif (2 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_02);
	elseif (3 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_03);
	elseif (4 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_04);
	elseif (5 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_05);
	elseif (6 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_06);
	elseif (7 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_01.effect, oCruiser, fx_explode_07);
	elseif (8 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_02.effect, oCruiser, fx_explode_08);
	end
end


/* 
	Plays the internal explosions on the covenant cruisers in the Maw vignette.	
	inputs:
		oCruiser 	The name of the device machine that is getting the effect
		nMarker		The marker number (1-11) that gets the explosion
*/
script static void fx_cov_cruiser_explosions2( object oCruiser, short nMarker )
	//dprint("Cruiser internal explosion");	
	if (1 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode01);
	elseif (2 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode02);
	elseif (3 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode03);
	elseif (4 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode04);
	elseif (5 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode05);
	elseif (6 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode06);
	elseif (7 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode07);
	elseif (8 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode08);
	elseif (9 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode09);
	elseif (10 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode10);
	elseif (11 == nMarker) then
		effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, oCruiser, fx_ship_explode11);
	end
end


script static void fx_play_all_cruiser_explosions()
	dprint("fx_play_all_cruiser_explosions()");	

	/*local short nMarker = 1; 
	repeat
		dprint("in repeat");
		fx_cov_cruiser_explosions2(beacon_ship2, nMarker);
		nMarker = nMarker + 1;
	until(11 == nMarker);*/
	
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode01);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode02);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode03);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode04);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode05);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode06);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode07);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode08);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode09);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode10);
	effect_new_on_object_marker(environments\solo\m10_crash\fx\explosions\beac_cruiser_explode_lg_03.effect, beacon_ship1, fx_ship_explode11);	
end

/// Beacons Vignette - MAW Opening Debris Suck ///	
script static void fx_maw_debris_suck()
	dprint ("::: M10 - Beacons Vignette - MAW Opening Debris Suck - FX :::");

	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_01.effect, fx_maw_debris_sm_01 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_02.effect, fx_maw_debris_sm_03 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_01.effect, fx_maw_debris_med_01 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_01.effect, fx_maw_debris_lg_01 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_03.effect, fx_maw_debris_lg_03 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_01.effect, fx_maw_debris_lg_05 );

	sleep(30 * 0.3);

	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_02.effect, fx_maw_debris_sm_02 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_02.effect, fx_maw_debris_med_02 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_sm_01.effect, fx_maw_debris_sm_04 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_03.effect, fx_maw_debris_lg_02 );
	effect_new (environments\solo\m10_crash\fx\debris\beac_maw_debris_02.effect, fx_maw_debris_lg_04 );
end













/// Cortana Plinth Floor Glow - 01 ///
script static void fx_cortana_plinth_glow_beac_01()
	print ("::: M10 - Cortana Plinth Floor Glow 01 - FX :::");
//	effect_new( objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, fx_cortana_plinth_beac_01 );
end


/// Cortana Plinth Floor Glow - 02 ///
script static void fx_cortana_plinth_glow_beac_02()
	print ("::: M10 - Cortana Plinth Floor Glow 02 - FX :::");
//	effect_new( objects\characters\storm_cortana\fx\plinth\cor_plinth_glow.effect, fx_cortana_plinth_beac_02 );
end


/// Cortana Rez-in - 01 ///
script static void fx_cortana_rez_beac_01()
	print ("::: M10 - Cortana Rez-in 01 - FX :::");
//	effect_new( objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, fx_cortana_rez_beac_01 );
end


/// Cortana Rez-in - 02 ///
script static void fx_cortana_rez_beac_02()
	print ("::: M10 - Cortana Rez-in 02 - FX :::");
//	effect_new( objects\characters\storm_cortana\fx\rez\cor_rez_in.effect, fx_cortana_rez_beac_02 );
end







// Commented out until FX are ready for the sequence.

//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_A_clamp_01 );
//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_A_clamp_02 );
//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_A_clamp_03 );

//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_B_clamp_01 );
//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_B_clamp_02 );
//	effect_new (environments\solo\m10_crash\fx\electric\bea_electric_clamp.effect, fx_beac_accel_B_clamp_03 );

// end


