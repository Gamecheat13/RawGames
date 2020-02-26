//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m70
//
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// DIDACT
// =================================================================================================
// =================================================================================================
// defines

// variables
// debug

// functions
// === f_didact_startup::: Auto startup
script startup f_didact_startup()
	sleep_until( b_mission_started == TRUE, 1 );
	dprint( "::: f_didact_startup :::" );
	
	// setup cleanup
	wake( f_didact_cleanup );
	
	sleep_until( (current_zone_set_fully_active() >= DEF_S_ZONESET_INFINITY_EXT) and (current_zone_set_fully_active() <= DEF_S_ZONESET_SPIRE_03_EXT), 1 );

	// wake init
	wake( f_didact_init );
	
end

// === f_didact_init::: Initialize
script dormant f_didact_init()
	dprint( "::: f_didact_init :::" );
	
	// init sub modules
	wake( f_didact_ship_init );
	wake( f_didact_attack_init );

end

// === f_didact_deinit::: Deinitialize
script dormant f_didact_deinit()
	dprint( "::: f_didact_deinit :::" );

	// kill functions
	sleep_forever( f_didact_init );

	// init sub modules
	wake( f_didact_ship_deinit );
	wake( f_didact_attack_deinit );

end

// === f_didact_cleanup::: Cleanup area
script dormant f_didact_cleanup()
	sleep_until( f_objective_missioncomplete_check(), 1 );
	dprint( "::: f_didact_cleanup :::" );

	wake( f_didact_deinit );
	
end

// =================================================================================================
// DIDACT: SHIP
// =================================================================================================
// === f_didact_ship_init::: Initialize
script dormant f_didact_ship_init()
//sleep_until( object_valid(dm_didact_ship_01), 1 );
	dprint( "::: f_didact_ship_init :::" );
	
	//device_set_position_track( dm_didact_ship_01, "m70_liftoff", 0.0 );

end

// === f_didact_ship_deinit::: Deinitialize
script dormant f_didact_ship_deinit()
	dprint( "::: f_didact_ship_deinit :::" );

	// kill functions
	sleep_forever( f_didact_ship_init );

end

// =================================================================================================
// DIDACT: ATTACK
// =================================================================================================
// === f_didact_attack_init::: Initialize
script dormant f_didact_attack_init()
	dprint( "::: f_didact_attack_init :::" );

end

// === f_didact_attack_deinit::: Deinitialize
script dormant f_didact_attack_deinit()
	dprint( "::: f_didact_attack_deinit :::" );

	// kill functions
	sleep_forever( f_didact_attack_init );

end

// === f_didact_attack_target::: Makes Didact ship attack the target
script static void f_didact_attack_target()

	if ( not dialog_id_played_check(L_dlg_scanned_player)) then
		sleep_until( dialog_id_played_check(L_dlg_scanned_player) or dialog_foreground_id_line_index_check_greater_equel(L_dlg_scanned_player, 2), 1 );
	end
	
	// sleep a brief moment to simulate projectile
	sleep_rand_s( 1.25, 1.75 );

	dprint( "::: f_didact_attack_target :::" );
	// XXX

end
