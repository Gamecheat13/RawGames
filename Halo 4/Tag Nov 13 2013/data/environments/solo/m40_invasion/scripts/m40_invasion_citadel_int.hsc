//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion_mission_cf
//	Insertion Points:	start 	- Beginning
//	ifo		- fodder
//	ija		- jackal alley
//	ici		- citidel interior
//	iic		- citidel interior
//	ipo		- powercave/ battery room
//	ili		- librarian encounter			
//  ior		- ordnance training					
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CITADEL_INT ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_citadel_int_init::: Initialize
script dormant f_citadel_int_init()

	
	// setup cleanup
	wake( f_citadel_int_cleanup );
	
	sleep_until( current_zone_set_fully_active() >= DEF_S_ZONESET_VALE_HALL(), 1 );
	
	zone_set_trigger_volume_enable("zone_set:zone_set_hall_battery", FALSE);
	zone_set_trigger_volume_enable ( "begin_zone_set:zone_set_battery", FALSE );
	zone_set_trigger_volume_enable ( "begin_zone_set:zone_set_battery_cavern", FALSE );
	effect_attached_to_camera_stop (environments\solo\m40_invasion\fx\dust\particulates.effect);
	
	// init sub modules
	wake( f_citadel_int_doors_init );
	wake( f_citadel_int_elevator_init );
	wake( f_citadel_int_sentinels_init );
//	wake( f_citadel_int_supplies_init );
//	wake( f_citadel_int_ai_init );
	
	// setup trigger
	wake( f_citadel_int_trigger );
	
end

// === f_citadel_int_deinit::: DeInitialize
script dormant f_citadel_int_deinit()


	// shutdown functions
	sleep_forever( f_citadel_int_init );
	sleep_forever( f_citadel_int_trigger );
	sleep_forever( f_citadel_int_action );

	// deinit sub modules
	wake( f_citadel_int_doors_deinit );
	wake( f_citadel_int_elevator_deinit );
	wake( f_citadel_int_sentinels_deinit );
	//wake( f_citadel_int_supplies_deinit );
	//wake( f_citadel_int_ai_deinit );
	
end

// === f_citadel_int_cleanup::: Cleanup
script dormant f_citadel_int_cleanup()
	sleep_until( FALSE, 1 );	// XXX need proper cleanup condition


	// deinit main module
	wake( f_citadel_int_deinit );
	
end

// === f_citadel_int_trigger::: Trigger
script dormant f_citadel_int_trigger()
	sleep_until( volume_test_players(tv_citadel_interior), 1 );

	
	player_set_profile (librarian_profile, player0); 
	player_set_profile (librarian_profile, player1); 
	player_set_profile (librarian_profile, player2); 
	player_set_profile (librarian_profile, player3); 
	
	wake( f_citadel_int_action );

end

// === f_citadel_int_action::: action
script dormant f_citadel_int_action()


	data_mine_set_mission_segment( "m40_citadel_int" );
	
	// XXX OLD VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

	wake( f_batterysetup );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_doors_init::: Initialize
script dormant f_citadel_int_doors_init()


	// init sub modules
	if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END ) then
		wake( f_citadel_int_door_lobby_01_init );
	end

end

// === f_citadel_int_doors_deinit::: DeInitialize
script dormant f_citadel_int_doors_deinit()


	// deinit sub modules
	wake( f_citadel_int_door_lobby_01_deinit );
	wake( f_citadel_int_door_lobby_02_deinit );
	wake( f_citadel_int_door_lobby_03_deinit );
	wake( f_citadel_int_door_elevator_01_deinit );

	wake( f_citadel_int_door_hall01_02_deinit );
	wake( f_citadel_int_door_hall01_03_deinit );
	
	wake( f_citadel_int_door_hall02_01_deinit );
	
	// deinit functions
	kill_script( f_citadel_int_doors_init );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: LOBBY 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_lobby_01_init::: Initialize
script dormant f_citadel_int_door_lobby_01_init()
	sleep_until( object_valid(dm_citadel_int_lobby_door_01), 1 );


	dm_citadel_int_lobby_door_01->close_instant();

	// setup trigger
	wake( f_citadel_int_door_lobby_01_trigger );

end

// === f_citadel_int_door_lobby_01_deinit::: DeInitialize
script dormant f_citadel_int_door_lobby_01_deinit()
	dprint( "f_citadel_int_door_lobby_01_deinit" );

	kill_script( f_citadel_int_door_lobby_01_init );
	kill_script( f_citadel_int_door_lobby_01_trigger );

end

// === f_citadel_int_door_lobby_01_trigger::: Trigger
script dormant f_citadel_int_door_lobby_01_trigger()
	sleep_until( object_valid(dm_citadel_int_lobby_door_01), 1 );
	sleep_until(volume_test_players("begin_zone_set:zone_set_hall_battery") == TRUE);
	sleep(1);
	sleep_until(current_zone_set_fully_active() == -1 and not PreparingToSwitchZoneSet(), 1);
	zone_set_trigger_volume_enable("zone_set:zone_set_hall_battery", TRUE);

	// setup door auto open
	dm_citadel_int_lobby_door_01->open_speed( 3.0 );
	thread( dm_citadel_int_lobby_door_01->auto_distance_open(-5, FALSE) );

	
	// wait until the door starts open and force a zone set switch
	sleep_until( not dm_citadel_int_lobby_door_01->check_close(), 1 );
//	f_insertion_zoneload( DEF_S_ZONESET_HALL_BATTERY(), TRUE );
	
	// wait for the door to open
	sleep_until( dm_citadel_int_lobby_door_01->check_open(), 1 );

	// setup door auto close
	//dm_citadel_int_lobby_door_01->auto_trigger_close( tv_citadel_interior, TRUE, FALSE, TRUE );
	//sound_impulse_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_a_close', dm_citadel_int_lobby_door_01, 1 );
	//sleep_until( dm_citadel_int_lobby_door_01->check_close(), 1 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: LOBBY 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_lobby_02_init::: Initialize
script dormant f_citadel_int_door_lobby_02_init()
	sleep_until( object_valid(dm_citadel_int_lobby_door_02), 1 );


	dm_citadel_int_lobby_door_02->open_instant();

end

// === f_citadel_int_door_lobby_02_deinit::: DeInitialize
script dormant f_citadel_int_door_lobby_02_deinit()


	kill_script( f_citadel_int_door_lobby_02_init );
	kill_script( f_citadel_int_door_lobby_02_close_sentinel );

end

// === f_citadel_int_door_lobby_02_close_sentinel::: opens the door
script dormant f_citadel_int_door_lobby_02_close_sentinel()
	sleep_until( object_valid(dm_citadel_int_lobby_door_02), 1 );


	dm_citadel_int_lobby_door_02->close_speed( 3.0 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: LOBBY 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_lobby_03_init::: Initialize
script dormant f_citadel_int_door_lobby_03_init()
	sleep_until( object_valid(dm_citadel_int_lobby_door_03), 1 );


	dm_citadel_int_lobby_door_03->close_instant();

end

// === f_citadel_int_door_lobby_03_deinit::: DeInitialize
script dormant f_citadel_int_door_lobby_03_deinit()


	kill_script( f_citadel_int_door_lobby_03_init );
	kill_script( f_citadel_int_door_lobby_03_open_sentinel );

end

// === f_citadel_int_door_lobby_03_open_sentinel::: opens the door
script dormant f_citadel_int_door_lobby_03_open_sentinel()
	sleep_until( object_valid(dm_citadel_int_lobby_door_03), 1 );

	dm_citadel_int_lobby_door_03->open_speed(3.0);
	dm_citadel_int_lobby_door_03->open();
	sleep(1);

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: ELEVATOR 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_elevator_01_init::: Initialize
script dormant f_citadel_int_door_elevator_01_init()
	sleep_until( object_valid(dm_citadel_int_elev_door_01), 1 );


	sleep( 1 );
	dm_citadel_int_elev_door_01->close_instant();

end

// === f_citadel_int_door_elevator_01_deinit::: DeInitialize
script dormant f_citadel_int_door_elevator_01_deinit()


	kill_script( f_citadel_int_door_elevator_01_init );
	kill_script( f_citadel_int_door_elevator_01_open_sentinel );

end
// === f_citadel_int_door_elevator_01_open_sentinel::: opens the door
script dormant f_citadel_int_door_elevator_01_open_sentinel()

	dm_citadel_int_elev_door_01->open_speed(3.0);
	dm_citadel_int_elev_door_01->open();
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: HALL01 02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_hall01_02_init::: Initialize
script dormant f_citadel_int_door_hall01_02_init()
	sleep_until( object_valid(dm_citadel_int_door_hall01_02), 1 );

	dm_citadel_int_door_hall01_02->open_instant();

end

// === f_citadel_int_door_hall01_02_deinit::: DeInitialize
script dormant f_citadel_int_door_hall01_02_deinit()

	kill_script( f_citadel_int_door_hall01_02_init );
	kill_script( f_citadel_int_door_hall01_02_close_sentinel );

end

// === f_citadel_int_door_hall01_02_close_sentinel::: opens the door
script static void f_citadel_int_door_hall01_02_close_sentinel( object obj_sentinel )
	sleep_until( object_valid(dm_citadel_int_door_hall01_02) and ( (obj_sentinel == NONE) or volume_test_players (tv_citadel_int_hall01_door_02_close2 ) or volume_test_object(tv_citadel_int_hall01_door_02_close,obj_sentinel) ), 1 );
	dm_citadel_int_door_hall01_02->close_speed( 1.5 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: HALL01 03
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_hall01_03_init::: Initialize
script dormant f_citadel_int_door_hall01_03_init()
	sleep_until( object_valid(dm_citadel_int_door_hall01_03), 1 );

	dm_citadel_int_door_hall01_03->close_instant();

end

// === f_citadel_int_door_hall01_03_deinit::: DeInitialize
script dormant f_citadel_int_door_hall01_03_deinit()
	kill_script( f_citadel_int_door_hall01_03_init );
	kill_script( f_citadel_int_door_hall01_03_open_sentinel );

end

// === f_citadel_int_door_hall01_03_open_sentinel::: opens the door
script dormant f_citadel_int_door_hall01_03_open_sentinel()
	sleep_until( object_valid(dm_citadel_int_door_hall01_03), 1 );
	dm_citadel_int_door_hall01_03->open_speed( 3.0 );
	dm_citadel_int_door_hall01_03->open();
	dm_citadel_int_door_hall01_03_em_open_bool = true;
	object_can_take_damage( ai_get_object(sq_citadel_int_sentinels_02) );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: DOORS: HALL02 01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_door_hall02_01_init::: Initialize
script dormant f_citadel_int_door_hall02_01_init()
	sleep_until( object_valid(dm_citadel_int_door_hall02_01), 1 );

	dm_citadel_int_door_hall02_01->close_instant();

end

// === f_citadel_int_door_hall02_01_deinit::: DeInitialize
script dormant f_citadel_int_door_hall02_01_deinit()

	kill_script( f_citadel_int_door_hall02_01_init );
	kill_script( f_citadel_int_door_hall02_01_open_sentinel );

end

// === f_citadel_int_door_hall02_01_open_sentinel::: opens the door
script dormant f_citadel_int_door_hall02_01_open_sentinel()
	sleep_until( object_valid(dm_citadel_int_door_hall02_01), 1 );
	dm_citadel_int_door_hall02_01->open_speed( 3.0 );
	dm_citadel_int_door_hall02_01->open();

	// wait until we start streaming the next zoneset, then make sure the door is shut
	sleep_until (current_zone_set() == DEF_S_ZONESET_BATTERY_CAVERN(), 1);
	device_animate_position (dm_citadel_int_door_hall02_01, 0, 0, 0, 0, FALSE);

	// turn off backtracking trigger volume (this is only there to teleport the player standing in the door anyway)
	zone_set_trigger_volume_enable("zone_set:zone_set_battery", FALSE);
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: ELEVATOR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_elevator_init::: Initialize
script dormant f_citadel_int_elevator_init()

	if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END ) then
		// setup trigger
		wake( f_citadel_int_elevator_trigger );
	end

end

// === f_citadel_int_elevator_deinit::: DeInitialize
script dormant f_citadel_int_elevator_deinit()
	
	// deinit functions
	kill_script( f_citadel_int_elevator_init );
	
end

// === f_citadel_int_elevator_trigger::: Trigger
script dormant f_citadel_int_elevator_trigger()
	sleep_until( (S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_ACTION) and object_valid(dm_citadel_int_elev_door_01) and dm_citadel_int_elev_door_01->check_open(), 1 );
	
	// deinit functions
	wake( f_citadel_int_elevator_action );
	
end

// === f_citadel_int_elevator_action::: Action
script dormant f_citadel_int_elevator_action()
	
	// blip the elevator
	wake( f_citadel_int_elevator_blip );
	
	thread (teleport_players_in_elevator());
	
	sleep_until( object_valid(dm_citadel_int_elev_door_01), 1 );
	wake( f_citadel_int_elevator_unblip );
	dm_citadel_int_elev_door_01->auto_trigger_close( tv_citadel_int_elevator_shaft, TRUE, TRUE, TRUE );
//	sound_impulse_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\amb_doors_a_close', dm_citadel_int_elev_door_01, 1 );
	sleep_until( dm_citadel_int_elev_door_01->check_close(), 1 );
	
	// finish with the lobby sentinel
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END );

	// unblip the elevator
	//wake( f_citadel_int_elevator_unblip );

	// short delay
	sleep_s( 0.5 );

	// XXX not sure exactly what this is; was there before - TWF
	wake( m40_cortana_elevator_confusion );

	// move the elevator
	local long ele_1 = pup_play_show(cit_int_elevator_1);
	// sound_looping_start ( 'sound\environments\solo\m040\new_m40_tags\amb_m40_machines\ambience\amb_m40_lib_elevator_1desert_ele_02_loop', cit_int_elevator_1, 1 );
		
	// wait for it to have stopped

	sleep_until(not pup_is_playing(ele_1),1);
	
	// short delay
	//sleep_s( 0.5 );
	
	// open the bottom DOOR
	sleep_until( object_valid(dm_citadel_int_elev_door_02), 1 );
	dm_citadel_int_elev_door_02->open_speed( 3.0 );
	dm_citadel_int_elev_door_02->open();
	sleep_until( dm_citadel_int_elev_door_02->check_open(), 1 );
	
	// close the door behind everyone
	sleep_until( object_valid(dm_citadel_int_elev_door_02), 1 );
	dm_citadel_int_elev_door_02->auto_trigger_close( tv_int_elevator_shaft_entire, TRUE, FALSE, TRUE );
	sleep_until( dm_citadel_int_elev_door_02->check_close(), 1 );

	// save game
	sleep_until (volume_test_players (tv_battery_setup), 1);
	game_save_no_timeout();
	
end

script static void teleport_players_in_elevator()

	sleep_until (volume_test_players (tv_elevator_mid), 1);
	
	print ("elevator teleport!");

	if
		volume_test_object (tv_int_lobby_full, player0)
	then
			object_teleport (player0, elevator_teleport_01b);
	end
	
	if
		volume_test_object (tv_int_lobby_full, player1)
	then
			object_teleport (player1, elevator_teleport_02b);
	end
	
	if
		volume_test_object (tv_int_lobby_full, player2)
	then
			object_teleport (player2, elevator_teleport_03b);
	end
	
	if
		volume_test_object (tv_int_lobby_full, player3)
	then
			object_teleport (player3, elevator_teleport_04b);
	end
end

// === f_citadel_int_elevator_blip::: Blip
script dormant f_citadel_int_elevator_blip()

	// blip
	f_blip_flag( fg_go_to_elevator, "default" );

end

// === f_citadel_int_elevator_unblip::: Blip
script dormant f_citadel_int_elevator_unblip()
	sleep_until(volume_test_players(tv_citadel_int_elevator_shaft));
	// kill the blip function so it won't run anymore
	kill_script( f_citadel_int_elevator_blip );
	
	// unblip
	f_unblip_flag( fg_go_to_elevator );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINELS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinels_init::: Initialize
script dormant f_citadel_int_sentinels_init()

	// init sub modules
	wake( f_citadel_int_sentinel_objcon_init );

end

// === f_citadel_int_sentinels_deinit::: DeInitialize
script dormant f_citadel_int_sentinels_deinit()

	// deinit sub modules
	wake( f_citadel_int_sentinel_objcon_deinit );
	
	// deinit functions
	kill_script( f_citadel_int_sentinels_init );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: OBJECT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

global object OBJ_citadel_int_sentinel_01	=																	NONE;
global object OBJ_citadel_int_sentinel_02	=																	NONE;
global object OBJ_citadel_int_sentinel_03	=																	NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinel_01_set::: Sets
script static void f_citadel_int_sentinel_01_set( object obj_sentinel )
	OBJ_citadel_int_sentinel_01 = obj_sentinel;
end

// === f_citadel_int_sentinel_02_set::: Sets
script static void f_citadel_int_sentinel_02_set( object obj_sentinel )
	OBJ_citadel_int_sentinel_02 = obj_sentinel;
end

// === f_citadel_int_sentinel_03_set::: Sets
script static void f_citadel_int_sentinel_03_set( object obj_sentinel )
	OBJ_citadel_int_sentinel_03 = obj_sentinel;
end

// === cs_citadel_int_sentinal_set_01::: COMMAND SCRIPT; sets the sentinel 01 object
script command_script cs_citadel_int_sentinal_set_01()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	f_citadel_int_sentinel_01_set( ai_current_actor );

end

// === cs_citadel_int_sentinal_set_02::: COMMAND SCRIPT; sets the sentinel 02 object
script command_script cs_citadel_int_sentinal_set_02()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	f_citadel_int_sentinel_02_set( ai_current_actor );

end

// === cs_citadel_int_sentinal_set_03::: COMMAND SCRIPT; sets the sentinel 03 object
script command_script cs_citadel_int_sentinal_set_03()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	f_citadel_int_sentinel_03_set( ai_current_actor );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_CITADEL_INT_SENTINEL_OBJCON_INIT =         								00;

global short DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_START = 									10;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_ACTION = 								15;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END = 										19;

global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_START = 								20;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_ACTION = 								25;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_DOOR_03 = 							27;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END = 									29;

global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_START = 								30;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_ACTION = 								35;
global short DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END = 									39;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

global short S_citadel_int_sentinel_objcon = 																DEF_CITADEL_INT_SENTINEL_OBJCON_INIT;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinel_objcon_create::: Initialize
script dormant f_citadel_int_sentinel_objcon_init()

	// wake the valley objcon
	wake( f_citadel_int_sentinel_objcon_controller );

end

// === f_citadel_int_sentinel_objcon_deinit::: DeInitialize
script dormant f_citadel_int_sentinel_objcon_deinit()
	
	// kill functions
	kill_script( f_citadel_int_sentinel_objcon_init );
	kill_script( f_citadel_int_sentinel_objcon_controller );

	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_start );
	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_action );
	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_end );

	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_start );
	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_action );
	kill_script( f_citadel_int_sentinel_objcon_controller_hall01_door_03 );
	kill_script( f_citadel_int_sentinel_objcon_controller_lobby_end );

	kill_script( f_citadel_int_sentinel_objcon_controller_hall02_start );
	kill_script( f_citadel_int_sentinel_objcon_controller_hall02_action );
	kill_script( f_citadel_int_sentinel_objcon_controller_hall02_end );
	
end

// === f_citadel_int_sentinel_objcon_set::: Sets the objcon value and manages any default practices
script static void f_citadel_int_sentinel_objcon_set( short s_val )
	
	if( s_val > S_citadel_int_sentinel_objcon ) then
		S_citadel_int_sentinel_objcon = s_val;
		inspect( s_val );
	end

end

// === f_citadel_int_sentinel_objcon_controller::: Controller
script dormant f_citadel_int_sentinel_objcon_controller()

	// setup any objcon controllers
	if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END ) then
		wake( f_citadel_int_sentinel_objcon_controller_lobby_start );
		wake( f_citadel_int_sentinel_objcon_controller_lobby_action );
		wake( f_citadel_int_sentinel_objcon_controller_lobby_end );
	end

	if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END ) then
		sleep_until( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END, 1 );
		wake( f_citadel_int_sentinel_objcon_controller_hall01_start );
		wake( f_citadel_int_sentinel_objcon_controller_hall01_action );
		wake( f_citadel_int_sentinel_objcon_controller_hall01_door_03 );
		wake( f_citadel_int_sentinel_objcon_controller_hall01_end );
	end

	if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END ) then
		sleep_until( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END, 1 );
		wake( f_citadel_int_sentinel_objcon_controller_hall02_start );
		wake( f_citadel_int_sentinel_objcon_controller_hall02_action );
		wake( f_citadel_int_sentinel_objcon_controller_hall02_end );
	end
			
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: OBJCON: LOBBY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinel_objcon_controller_lobby_start::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_lobby_start()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_START )
			or
			(
				object_valid( dm_citadel_int_lobby_door_01 )
				and
				( not (dm_citadel_int_lobby_door_01->check_close()) )
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_START );

	// setup the doors
	wake( f_citadel_int_door_lobby_02_init );
	wake( f_citadel_int_door_lobby_03_init );
	wake( f_citadel_int_door_elevator_01_init );

	// do the initial placement
	ai_place( sq_citadel_int_sentinels_01.lobby_00 );
	
	// Respawn new guys if necessary
	repeat

		// wait for the need for another 
		sleep_until( (ai_living_count(sq_citadel_int_sentinels_01) <= 0) or (S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END), 1 );

		if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END ) then
			sleep_until(volume_test_players_lookat(tv_sentinel_spawn, 40, 40) == FALSE);
					ai_place( sq_citadel_int_sentinels_01.lobby_02);
			sleep_until( ai_living_count(sq_citadel_int_sentinels_01) > 0, 1 );
		end
	until( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END, 1 );
			
end

// === f_citadel_int_sentinel_objcon_controller_lobby_action::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_lobby_action()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_ACTION )
			or
			volume_test_players( tv_citadel_int_lobby )
			or
			(
				object_valid( dm_citadel_int_lobby_door_01 )
				and
				( device_get_position(dm_citadel_int_lobby_door_01) >= 0.75 )
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_ACTION );

	// setup narrative
	wake( m40_cortana_confusion_citadel );

end

// === f_citadel_int_sentinel_objcon_controller_lobby_end::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_lobby_end()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END )
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_LOBBY_END );
	
	// erases the sentinel
	ai_kill( sq_citadel_int_sentinels_01 );
			
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: OBJCON: HALL01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinel_objcon_controller_hall01_start::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall01_start()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_START )
			or
			(
				object_valid( dm_citadel_int_elev_door_02 )
				and
				dm_citadel_int_elev_door_02->check_open()
			)
			or
			(
				object_valid( dm_citadel_int_door_hall01_01 )
				and
				( device_get_position(dm_citadel_int_door_hall01_01) > 0.0 )
			)
		, 1 );

	// start loading DEF_S_ZONESET_BATTERY
	prepare_to_switch_to_zone_set( f_zoneset_get(DEF_S_ZONESET_BATTERY()) );

	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_START );

	sleep_until (not preparingToSwitchZoneSet(), 1); // poll whether async load is complete
	
	f_insertion_zoneload( DEF_S_ZONESET_BATTERY(), TRUE );

	// setup the doors
	wake( f_citadel_int_door_hall01_02_init );
	wake( f_citadel_int_door_hall01_03_init );
	
	// place sentinel 01 (door 02 close)
	ai_place( sq_citadel_int_sentinels_01.hall01_00 );
	ai_place( sq_citadel_int_sentinels_02.hall01_00 );
	sleep(1);
	object_cannot_take_damage( ai_get_object(sq_citadel_int_sentinels_02) );
	// Respawn new guys if necessary
	repeat

		// wait for the need for another 
		sleep_until( ((ai_living_count(sq_citadel_int_sentinels_02) + ai_living_count(sg_citadel_int_sentinels_03)) <= 0) or (S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END), 1 );

		if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END ) then
					
					sleep_until(volume_test_players_lookat(tv_sentinel_spawn_hall_02, 40, 40) == FALSE);
					ai_place( sq_citadel_int_sentinels_02.hall01_01);

			
			sleep_until( ai_living_count(sq_citadel_int_sentinels_02) > 0, 1 );
			
		end
		
	until( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END, 1 );
			
end

// === f_citadel_int_sentinel_objcon_controller_hall01_action::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall01_action()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_ACTION )
			or
			volume_test_players( tv_citadel_int_hall01 )
			or
			(
				object_valid( dm_citadel_int_door_hall01_01 )
				and
				( device_get_position(dm_citadel_int_door_hall01_01) >= 0.75 )
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_ACTION );

end

// === f_citadel_int_sentinel_objcon_controller_hall01_door_03::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall01_door_03()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_DOOR_03 )
			or
			(
				( S_citadel_int_sentinel_objcon == DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_ACTION )
				and
				object_valid( dm_citadel_int_door_hall01_02 )
				and
				dm_citadel_int_door_hall01_02->check_close()
				and
				(
					(
						object_valid( dm_citadel_int_door_hall01_03 )
						and
						objects_can_see_object( Players(), dm_citadel_int_door_hall01_03, 15.0 )
					)
					or
					(
						( OBJ_citadel_int_sentinel_02 != NONE )
						and
						(
							objects_can_see_object( Players(), OBJ_citadel_int_sentinel_02, 7.5 )
							or 
							( objects_distance_to_object(Players(), OBJ_citadel_int_sentinel_02) < 7.5 )
						)
					)
					or
					(
						( OBJ_citadel_int_sentinel_03 != NONE )
						and
						(
							objects_can_see_object( Players(), OBJ_citadel_int_sentinel_03, 7.5 )
							or 
							( objects_distance_to_object(Players(), OBJ_citadel_int_sentinel_03) < 7.5 )
						)
					)
				)
			)			
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_DOOR_03 );
			
end

// === f_citadel_int_sentinel_objcon_controller_hall01_end::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall01_end()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END )
			or
			(
				( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_ACTION )
				and
				object_valid( dm_citadel_int_door_hall01_03 )
				and
				dm_citadel_int_door_hall01_03->check_open()
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END );
			
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: OBJCON: HALL02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_int_sentinel_objcon_controller_hall02_start::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall02_start()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_START )
			or
			(
				( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL01_END )
				and
				object_valid( dm_citadel_int_door_hall01_03 )
				and
				dm_citadel_int_door_hall01_03->check_open()
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_START );

	// clear stored sentinel objects
	f_citadel_int_sentinel_01_set( ai_get_object(sg_citadel_int_sentinels_01) );
	f_citadel_int_sentinel_02_set( ai_get_object(sg_citadel_int_sentinels_02) );
	f_citadel_int_sentinel_03_set( ai_get_object(sg_citadel_int_sentinels_03) );

	// setup the doors
	wake( f_citadel_int_door_hall02_01_init );

	// Respawn new guys if necessary
	repeat

		// wait for the need for another 
		sleep_until( (ai_living_count(sg_citadel_int_sentinels_01) <= 0) or (ai_living_count(sg_citadel_int_sentinels_02) <= 0) or (ai_living_count(sg_citadel_int_sentinels_03) <= 0) or (S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END), 1 );

		if ( S_citadel_int_sentinel_objcon < DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END ) then
		
			if ( ai_living_count(sg_citadel_int_sentinels_01) <= 0 ) then

				begin_random_count( 1 )
					begin
						ai_place( sq_citadel_int_sentinels_01.hall02_01 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_01.hall02_02 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_01.hall02_03 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_01.hall02_04 );
					end
				end
				dprint( "f_citadel_int_sentinel_objcon_controller_hall02_start: SENTINEL 01 REPLACED" );
				f_citadel_int_sentinel_01_set( ai_get_object(sg_citadel_int_sentinels_01) );
			end
	
			if ( ai_living_count(sq_citadel_int_sentinels_02) <= 0 ) then
					sleep_until(volume_test_players_lookat(tv_sentinel_spawn_hall_02, 40, 40) == FALSE);
				begin_random_count( 1 )
					begin
						ai_place( sq_citadel_int_sentinels_02.hall01_01 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_02.hall01_02 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_02.hall01_03 );
					end
					begin
						ai_place( sq_citadel_int_sentinels_02.hall01_04 );
					end
				end
				dprint( "f_citadel_int_sentinel_objcon_controller_hall02_start: SENTINEL 02 REPLACED" );
				f_citadel_int_sentinel_02_set( ai_get_object(sg_citadel_int_sentinels_02) );
			end
	
			if ( ai_living_count(sg_citadel_int_sentinels_03) <= 0 ) then
				begin_random_count( 1 )
					begin
						ai_place( sg_citadel_int_sentinels_03.hall02_01 );
					end
					begin
						ai_place( sg_citadel_int_sentinels_03.hall02_02 );
					end
					begin
						ai_place( sg_citadel_int_sentinels_03.hall02_03 );
					end
					begin
						ai_place( sg_citadel_int_sentinels_03.hall02_04 );
					end
				end
				dprint( "f_citadel_int_sentinel_objcon_controller_hall02_start: SENTINEL 03 REPLACED" );
				f_citadel_int_sentinel_03_set( ai_get_object(sg_citadel_int_sentinels_03) );
			end
			
		end
		
	until( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END, 1 );
	
end

// === f_citadel_int_sentinel_objcon_controller_hall02_action::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall02_action()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_ACTION )
			or
			(
				volume_test_players( tv_hall02_door_01_sentinel_open )
				and
				(
					(
						object_valid( dm_citadel_int_door_hall02_01 )
						and
						objects_can_see_object( Players(), dm_citadel_int_door_hall02_01, 15.0 )
					)
					or
					(
						( OBJ_citadel_int_sentinel_01 != NONE )
						and
						(
							objects_can_see_object( Players(), OBJ_citadel_int_sentinel_01, 7.5 )
							or 
							( objects_distance_to_object(Players(), OBJ_citadel_int_sentinel_01) < 7.5 )
						)
					)
					or
					(
						( OBJ_citadel_int_sentinel_02 != NONE )
						and
						(
							objects_can_see_object( Players(), OBJ_citadel_int_sentinel_02, 7.5 )
							or 
							( objects_distance_to_object(Players(), OBJ_citadel_int_sentinel_02) < 7.5 )
						)
					)
					or
					(
						( OBJ_citadel_int_sentinel_03 != NONE )
						and
						(
							objects_can_see_object( Players(), OBJ_citadel_int_sentinel_03, 7.5 )
							or 
							( objects_distance_to_object(Players(), OBJ_citadel_int_sentinel_03) < 7.5 )
						)
					)
				)
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_ACTION );

end

// === f_citadel_int_sentinel_objcon_controller_hall02_end::: Controller
script dormant f_citadel_int_sentinel_objcon_controller_hall02_end()

	sleep_until( 
			( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END )
			or
			(
				( S_citadel_int_sentinel_objcon >= DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_ACTION )
				and
				object_valid( dm_citadel_int_door_hall02_01 )
				and
				dm_citadel_int_door_hall02_01->check_open()
			)
		, 1 );
	f_citadel_int_sentinel_objcon_set( DEF_CITADEL_INT_SENTINEL_OBJCON_HALL02_END );
		
	// setup auto door close
	thread( dm_citadel_int_door_hall02_01->auto_trigger_close(tv_hall02_door_01_sentinel_close, TRUE, TRUE, TRUE) );
	sleep_until(dm_citadel_int_door_hall02_01 -> check_close(), 1);
	zone_set_trigger_volume_enable ( "begin_zone_set:zone_set_battery_cavern", TRUE );
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: AI
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: AI: LOBBY
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_citadel_int_sentinal_lobby_door_02_close::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_lobby_door_02_close()
	sleep_until( object_valid(dm_citadel_int_lobby_door_02), 1 );

	thread (close_first_cit_int_door());

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	// store the sentinel object
	f_citadel_int_sentinel_01_set( ai_current_actor );
	object_cannot_take_damage( ai_get_object(ai_current_actor) );

	repeat
		cs_fly_to_and_face( ps_citadel_int_sentinels.lobby_door_02_move, ps_citadel_int_sentinels.lobby_door_02_face, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.lobby_door_02_move) <= 0.25, 1 );

	// XXX need scan fx
	// XXX need some animation on the sentinel
	cs_shoot_point(TRUE, pts_sent_shoot.p0);
//	wake( f_citadel_int_door_lobby_02_close_sentinel );

	object_can_take_damage( ai_get_object(ai_current_actor) );

end

script static void close_first_cit_int_door()
		sleep_until (volume_test_players (tv_first_cit_door_close), 1);
		dm_citadel_int_lobby_door_02->close_speed( 3.0 );
end

// === cs_citadel_int_sentinal_lobby_door_03_open::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_lobby_door_03_open()
	sleep_until( object_valid(dm_citadel_int_lobby_door_03), 1 );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	f_citadel_int_sentinel_01_set( ai_current_actor );
	object_can_take_damage( ai_get_object(ai_current_actor) );

	repeat
		cs_fly_to_and_face( ps_citadel_int_sentinels.lobby_door_03_move, ps_citadel_int_sentinels.lobby_door_03_face, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.lobby_door_03_move) <= 1.25, 3 );
	cs_shoot_point(TRUE, pts_sent_shoot.p1);
	// XXX need scan fx
	// XXX need some animation on the sentinel

	wake( f_citadel_int_door_lobby_03_open_sentinel );

end

// === cs_citadel_int_sentinal_lobby_elevator_door_01_open::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_lobby_elevator_door_01_open()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	f_citadel_int_sentinel_01_set( ai_current_actor );
	object_can_take_damage( ai_get_object(ai_current_actor) );

	repeat
		cs_fly_to_and_face( ps_citadel_int_sentinels.elevator_door_01_move, ps_citadel_int_sentinels.elevator_door_01_face, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.elevator_door_01_move) <= 1, 3 );
	cs_shoot_point(TRUE, pts_sent_shoot.p2);
	// XXX need scan fx
	// XXX need some animation on the sentinel

	wake( f_citadel_int_door_elevator_01_open_sentinel );

end

script command_script cs_go_through_door()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	cs_fly_to(ps_go_through_door.p0);
	
end

script command_script cs_go_through_door_2()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	cs_fly_to(ps_go_through_door.p1);
	cs_fly_to_and_face(ps_go_through_door.p2,ps_go_through_door.p1);
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: AI: HALL01
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_citadel_int_sentinal_hall01_door_02_close::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_hall01_door_02_close()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	// temprorarily cannot take damage
	object_cannot_take_damage( ai_get_object(ai_current_actor) );
	
	// setup door to auto close
	thread( f_citadel_int_door_hall01_02_close_sentinel(ai_get_object(ai_current_actor)) );
	
	// now he can take damage
	object_can_take_damage( ai_get_object(ai_current_actor) );

	// fly to point 01
	repeat
		cs_fly_to( ps_citadel_int_sentinels.hall01_door_02_move_01, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.hall01_door_02_move_01) <= 1, 3 );

	// fly to point 02
	repeat
		cs_fly_to( ps_citadel_int_sentinels.hall01_door_02_move_02, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.hall01_door_02_move_02) <= 1, 3 );

	// cleanup
	sleep_until( dm_citadel_int_door_hall01_02->check_close(), 1 );
	
	ai_erase( ai_current_actor );

end

// === cs_citadel_int_sentinal_hall01_door_03_open::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_hall01_door_03_open()

	thread (dm_citadel_int_door_hall01_03_em_open());

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	repeat
		cs_fly_to_and_face( ps_citadel_int_sentinels.hall01_door_03_move, ps_citadel_int_sentinels.hall01_door_03_face, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.hall01_door_03_move) <= 1, 3 );
	cs_shoot_point(TRUE, pts_sent_shoot.p0);
	// XXX need scan fx
	// XXX need some animation on the sentinel

	wake( f_citadel_int_door_hall01_03_open_sentinel );

end

script static void dm_citadel_int_door_hall01_03_em_open()
	sleep_s(10);
	if
		dm_citadel_int_door_hall01_03_em_open_bool == FALSE
	then
//		dm_citadel_int_door_hall01_03->open_speed( 3.0 );
		dm_citadel_int_door_hall01_03->open();
	end
end	

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_INT: SENTINEL: AI: HALL02
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_citadel_int_sentinal_hall02_door_01_open::: COMMAND SCRIPT
script command_script cs_citadel_int_sentinal_hall02_door_01_open()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	object_cannot_take_damage( ai_get_object(ai_current_actor) );

	thread (open_bat_door());

	repeat
		cs_fly_to_and_face( ps_citadel_int_sentinels.hall02_door_01_move, ps_citadel_int_sentinels.hall02_door_01_face, 0.125 );
	until( objects_distance_to_point(ai_current_actor,ps_citadel_int_sentinels.hall02_door_01_move) <= 0.25, 1 );
	cs_shoot_point(TRUE, pts_sent_shoot.p4);
	// XXX need scan fx
	// XXX need some animation on the sentinel
	object_can_take_damage( ai_get_object(ai_current_actor) );


end

script static void open_bat_door()
	sleep_until (volume_test_players (tv_battery_door_open), 1);
	wake( f_citadel_int_door_hall02_01_open_sentinel );
end