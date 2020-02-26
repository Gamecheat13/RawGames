//// =============================================================================================================================
// ============================================ CAVERNS SCRIPT ========================================================
// =============================================================================================================================

script startup caverns

	print( "caverns_startup" );
	
	
	// setup defaults
	f_spops_mission_startup_defaults();
	
	// track mission flow
	f_spops_mission_flow();
	
	object_set_scale(caverns_app_oct, 0.6, 1);
	thread(f_cavern_dust_on());
end

global object g_ics_player = NONE;

script static void f_activator_get( object trigger, unit activator )
	dprint("*activator*");
	g_ics_player = activator;
end

// ==============================================================================================================
//====== OTHER SCRIPTS ===============================================================================
// ==============================================================================================================

script static void f_cavern_dust_on()
	sleep_until(volume_test_players(t_cavern_dust), 1);
	print ("--- Attaching dust FX to the Camera - turning it on ---");
	effect_attached_to_camera_new( levels\dlc\ff153_caverns\fx\dust\dlc_dust_particulates.effect );
	thread(f_cavern_dust_off());
end

script static void f_cavern_dust_off()
	sleep_until(volume_test_players(t_cavern_dust) == FALSE, 1);
	print ("--- Detaching dust FX from Camera - turning it off ---");
	effect_attached_to_camera_stop( levels\dlc\ff153_caverns\fx\dust\dlc_dust_particulates.effect );
	thread(f_cavern_dust_on());
end