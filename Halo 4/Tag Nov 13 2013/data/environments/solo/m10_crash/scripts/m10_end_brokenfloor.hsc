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
// BROKENFLOOR
// =================================================================================================
// =================================================================================================
// variables

// functions
// === f_brokenfloor_init::: Initialize
script dormant f_brokenfloor_init()
	
	// setup cleanup watch
	wake( f_brokenfloor_cleanup );

	sleep_until(current_zone_set_fully_active()==S_zoneset_32_broken_34_maintenance, 1 );
	//dprint( "::: f_brokenfloor_init :::" );

	// initialize sub areas
	wake( f_block_off_airlock );
	wake( f_brokenfloor_entry_init );
	wake( f_brokenfloor_hall_init );
	
	// initialize modules
	wake( f_brokenfloor_AI_init );
	wake( f_brokenfloor_destruction_init );

	// setup checkpoint
	//wake( f_brokenfloor_checkpoint );
	wake( f_brokenfloor_wepracks );

end

script dormant f_block_off_airlock()
	sleep_until(volume_test_players(tv_broken_exit), 1);
	volume_teleport_players_not_inside(tv_broken_teleport_region, flg_broken_teleport);
	object_create(door_block_airlock);
end

// === f_brokenfloor_deinit::: Deinitialize
script dormant f_brokenfloor_deinit()

	// kill functions
	sleep_forever( f_brokenfloor_init );
	sleep_forever( f_brokenfloor_checkpoint );

	// deinitialize sub areas
	wake( f_brokenfloor_entry_deinit );
	wake( f_brokenfloor_hall_deinit );

	// deinitialize modules
	wake( f_brokenfloor_AI_deinit );
	wake( f_brokenfloor_destruction_deinit );

end

// === f_brokenfloor_checkpoint::: Checkpoint
script dormant f_brokenfloor_checkpoint()
	sleep_until( volume_test_players(tv_broken_checkpoint_enter), 1 );
	//dprint( "::: f_brokenfloor_checkpoint-enter :::" );
	
	//datamine
	data_mine_set_mission_segment( "m10_END_brokenfloor_main" );
	
	// checkpoint
	game_save();
	sleep( 1 );

	sleep_until( volume_test_players(tv_broken_checkpoint_exit), 1 );
	//dprint( "::: f_brokenfloor_checkpoint-exit :::" );
	
	// checkpoint
	game_save();
	sleep( 1 );

end

// === f_brokenfloor_wepracks::: Weaponracks
script dormant f_brokenfloor_wepracks()
	sleep_until( object_valid(dm_broken_weprack_open00), 1 );
	//dprint( "::: f_brokenfloor_wepracks-dm_broken_weprack_open00 :::" );
	thread( dm_broken_weprack_open00->open_instant() );
	sleep_until( object_valid(dm_broken_weprack_open01), 1 );
	//dprint( "::: f_brokenfloor_wepracks-dm_broken_weprack_open01 :::" );
	thread( dm_broken_weprack_open01->open_instant() );
	sleep_until( object_valid(dm_broken_weprack_open02), 1 );
	//dprint( "::: f_brokenfloor_wepracks-dm_broken_weprack_open02 :::" );
	thread( dm_broken_weprack_open02->open_instant() );
	sleep_until( object_valid(dm_broken_weprack_open03), 1 );
	//dprint( "::: f_brokenfloor_wepracks-dm_broken_weprack_open03 :::" );
	thread( dm_broken_weprack_open03->open_instant() );
end

// === f_brokenfloor_cleanup::: Cleanup area
script dormant f_brokenfloor_cleanup()
	// XXX
	sleep_until( current_zone_set_fully_active() > S_zoneset_32_broken_34_maintenance, 1 );
	//dprint( "::: f_brokenfloor_cleanup :::" );
	
	// cleanup sub areas
	wake( f_brokenfloor_entry_cleanup );
	wake( f_brokenfloor_hall_cleanup );

	// deinit the area
	wake ( f_brokenfloor_deinit );
	
end
