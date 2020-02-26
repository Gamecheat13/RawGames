//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
//	Insertion Points:	start (or icr)	- Beginning
//										ibr							- Broken Floor
//										iea							- explosion alley
//										ivb							- Vehicle Bay
//										iju							- Jump Debris
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// =================================================================================================
// =================================================================================================
// MAINTENANCE
// =================================================================================================
// =================================================================================================
// variables
global short S_maintenance_loc = -1;	// Don't use this for logic, just to track the status of the players
global long L_checkpoint_combat_ID_maintenance = 0;

// functions
// === f_maintenance_init::: Initialize
script dormant f_maintenance_init()
	
	// setup cleanup watch
	wake (f_brokenfloor_AI_cleanup);
	wake( f_maintenance_cleanup );

	sleep_until( current_zone_set_fully_active() == S_zoneset_32_broken_34_maintenance, 1 );
	//dprint( "::: f_maintenance_init :::" );
	
	// initialize maintenance loc variable
	S_maintenance_loc = 0;

	// initialize sub areas
	wake( f_maintenance_hall_init );
	
	// initialize modules
	wake( f_maintenance_AI_init );
	wake( f_maintenance_destruction_init );
	wake(f_explode_canister_sounds);

	// initialize sub modules
	wake( f_maintenance_lower_init );
	wake( f_maintenance_upper_init );
	
	// setup functions
	wake( f_maintenance_enter );
	wake( f_maintenance_exit );

end

// === f_maintenance_deinit::: Deinitialize
script dormant f_maintenance_deinit()
	//dprint( "::: f_maintenance_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_init );
	sleep_forever( f_maintenance_exit );

	// deinitialize sub areas
	wake( f_maintenance_hall_deinit );

	// deinitialize modules
	wake( f_maintenance_AI_deinit );
	wake( f_maintenance_destruction_deinit );

	// deinitialize sub modules
	wake( f_maintenance_lower_deinit );
	wake( f_maintenance_upper_deinit );

end

// === f_maintenance_cleanup::: Cleanup area
script dormant f_maintenance_cleanup()
	// XXX
	sleep_until( current_zone_set_fully_active() > S_zoneset_32_broken_34_maintenance, 1 );
	//dprint( "::: f_maintenance_cleanup :::" );
	
	wake ( f_maintenance_ai_cleanup );
	
end

// === f_maintenance_enter::: Entered the area
script dormant f_maintenance_enter()
	sleep_until( volume_test_players(tv_maintenance_lower_start) or volume_test_players(tv_maintenance_upper_start), 1 );
	//dprint( "::: f_maintenance_enter :::" );

	//datamine
	data_mine_set_mission_segment( "m10_END_maintenance_main" );
	
	// setup the combat checkpoint
	//L_checkpoint_combat_ID_maintenance = f_combat_checkpoint_add( gr_maintenance, -1, TRUE, -1, 15.0, -1.0 );
	//game_save();

end

// === f_maintenance_exit: Player is leaving the inittenance area
script dormant f_maintenance_exit()
	sleep_until( volume_test_players(tv_maintenance_exit), 1 );
	//dprint( "::: f_maintenance_exit :::" );
	//thread(f_sprint_tutorial());
	f_unblip_flag(flg_maint_blip_door);
	f_blip_flag(flg_objective_toescapepodbay, "default");
	b_player_passed_exit = TRUE;
	// set split loc progress
	if ( S_maintenance_loc < 3 ) then

		S_maintenance_loc = 3;

		// kill the maintenance combat checkpoint
		thread( f_combat_checkpoint_remove(L_checkpoint_combat_ID_maintenance) );

		// checkpoint
		//game_save();
		sleep( 1 );
		
		// screenshake
		f_mission_screenshakes_ambient_layer_set_inc( DEF_S_AMBIENTSHAKE_STATE_EXPLOSIONALLEY );
		
		if ( not f_B_screenshake_ambient_playing() ) then
			thread( f_screenshake_event_high(-0.5, -1, -3.0, 'sound\environments\solo\m010\ambience\explosions\amb_m10_explosions_large_01') );
			sleep_s( 1.0 );
		end
		
		// VO
	//	wake( f_dialog_Maintenance_End );

	end

end



// -------------------------------------------------------------------------------------------------
// BROKENFLOOR: GENERAL
// -------------------------------------------------------------------------------------------------
// variables

// functions

script static void f_sprint_tutorial()
	
	local real r_time = 0;
	//hud_enable_training(TRUE);
	//hud_set_training_text("m10_sprint_training");
	//hud_show_training_text(TRUE);
	
		r_time = (game_tick_get() + (5 * 30));
		unit_action_test_reset(player0);
		sleep_until ( r_time <= game_tick_get() or unit_action_test_hero_assist(player0));

	sleep_s(1);

	//hud_show_training_text(FALSE);
	//sound_impulse_start (sfx_tutorial_complete, player0, 1);
	
end


// -------------------------------------------------------------------------------------------------
// MAINTENANCE: LOWER
// -------------------------------------------------------------------------------------------------
// variables
global long l_maintenance_lower_weprack01 = 0;
global long l_maintenance_lower_weprack02 = 0;

// functions
// === f_maintenance_lower_init::: Area master initialization
script dormant f_maintenance_lower_init()
	//dprint( "::: f_maintenance_lower_init :::" );

	// prep the trigger
	wake( f_maintenance_lower_trigger );

	// setup triggers for racks
	/*sleep_until( object_valid(dm_maintenance_lower_wep01a), 1 );
	l_maintenance_lower_weprack01 = thread( dm_maintenance_lower_wep01a->auto_trigger_open(tv_maintenance_lower_wepracks, FALSE, TRUE, FALSE) );
	
	sleep_until( object_valid(dm_maintenance_lower_wep01b), 1 );
	l_maintenance_lower_weprack02 = thread( dm_maintenance_lower_wep01b->auto_trigger_open(tv_maintenance_lower_wepracks, FALSE, TRUE, FALSE) );*/

end

// === f_maintenance_lower_deinit::: Area master cleanup
script dormant f_maintenance_lower_deinit()
	//dprint( "::: f_maintenance_lower_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_lower_init );
	sleep_forever( f_maintenance_lower_trigger );

end

// === f_maintenance_lower_start::: trigger for lower
script dormant f_maintenance_lower_trigger()
	sleep_until( volume_test_players(tv_maintenance_lower_start), 1 );
	//dprint( "::: f_maintenance_lower_start :::" );

	// set which floor the player is "commited" to
	if ( S_maintenance_loc <= 0 ) then
		S_maintenance_loc = 1;
	end

end

// === f_maintenance_lower_hasplayers::: Returns if there are players in the lower area
script static boolean f_maintenance_lower_hasplayers()
	volume_test_players(tv_maintenance_lower_start) or volume_test_players(tv_maintenance_lower_area);
end



// -------------------------------------------------------------------------------------------------
// MAINTENANCE: UPPER
// -------------------------------------------------------------------------------------------------
// variables

// functions
// === f_maintenance_upper_init::: Split upper area initialization
script dormant f_maintenance_upper_init()
	//dprint( "::: f_maintenance_upper_init :::" );

	// setup any sub modules
	wake( f_maintenance_upper_trigger );

	// setup triggers for racks
	/*sleep_until( object_valid(dm_maintenance_upper_wep01a), 1 );
	thread( dm_maintenance_upper_wep01a->auto_distance_open(-12.5, FALSE) );
	sleep_until( object_valid(dm_maintenance_upper_wep01b), 1 );
	thread( dm_maintenance_upper_wep01b->chain_parent_open(dm_maintenance_upper_wep01a, dm_maintenance_upper_wep01a->close_position(), dm_maintenance_upper_wep01b->S_chain_state_greater()) );

	sleep_until( object_valid(dm_maintenance_upper_wep02a), 1 );
	thread( dm_maintenance_upper_wep02a->auto_distance_open( -12.5, FALSE) );
	sleep_until( object_valid(dm_maintenance_upper_wep02b), 1 );
	thread( dm_maintenance_upper_wep02b->chain_parent_open( dm_maintenance_upper_wep02a, dm_maintenance_upper_wep02a->close_position(), dm_maintenance_upper_wep02b->S_chain_state_greater()) );*/

end

// === f_maintenance_upper_deinit::: Area master cleanup
script dormant f_maintenance_upper_deinit()
	//dprint( "::: f_maintenance_upper_deinit :::" );

	// kill functions
	sleep_forever( f_maintenance_upper_init );
	sleep_forever( f_maintenance_upper_trigger );

end

// === f_maintenance_upper_trigger::: Handles anything for when the player enters the area
script dormant f_maintenance_upper_trigger()
	sleep_until( volume_test_players(tv_maintenance_upper_start), 1 );
	//dprint( "::: f_maintenance_upper_trigger :::" );

	// set which floor the player is "commited" to
	if ( S_maintenance_loc <= 0 ) then
		S_maintenance_loc = 2;
	end

end

// === f_maintenance_upper_hasplayers::: Returns if there are players in the upper area
script static boolean f_maintenance_upper_hasplayers()
	volume_test_players(tv_maintenance_upper_start) or volume_test_players(tv_maintenance_upper_area);
end

