//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// 	Mission: 					m40_invasion_mission_cf
//	Insertion Points:	start 	- Beginning
//	ifo		- fodder
//	ija		- jackal alley
//	ici		- citidel exterior
//	iic		- citidel interior
//	ipo		- powercave/ battery room
//	ili		- librarian encounter			
//  ior		- ordnance training					
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** CITADEL_EXT ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_citadel_ext_init::: Initialize
script dormant f_citadel_ext_init()
	dprint( "f_citadel_ext_init" );
	
	// setup cleanup
	wake( f_citadel_ext_cleanup );

	// init sub modules
	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_PRE_VALE()
or
	current_zone_set_fully_active() == DEF_S_ZONESET_VALE_VALE()
	, 1 ); 
	zone_set_trigger_volume_enable("begin_zone_set:zone_set_hall_battery", FALSE);
	wake( f_citadel_ext_ai_init );
	wake( f_citadel_ext_door_init );
	wake( f_citadel_ext_supplies_init );
	//wake( f_citadel_ext_cover_init );

	
	// setup trigger
	wake( f_citadel_ext_trigger );
	
end

// === f_citadel_ext_deinit::: DeInitialize
script dormant f_citadel_ext_deinit()

	// shutdown functions
	kill_script( f_citadel_ext_init );
	kill_script( f_citadel_ext_trigger );
	kill_script( f_citadel_ext_action );

	// deinit sub modules
	wake( f_citadel_ext_ai_deinit );
	//wake( f_citadel_ext_door_deinit );
	wake( f_citadel_ext_supplies_deinit );
	wake( f_citadel_ext_cover_deinit );
	
end

// === f_citadel_ext_cleanup::: Cleanup
script dormant f_citadel_ext_cleanup()
	sleep_until( current_zone_set_fully_active() > DEF_S_ZONESET_VALE_VALE(), 1 );

	// deinit main module
	wake( f_citadel_ext_deinit );
	
end

// === f_citadel_ext_trigger::: Trigger
script dormant f_citadel_ext_trigger()
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START, 1 );
	
	wake( f_citadel_ext_action );

	//sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START, 1 );	//  XXX do we need this? If so probably best setup with a trigger volume
	// display chapter
	//wake( f_citadel_ext_chapter );
	
end

// === f_citadel_ext_action::: action
script dormant f_citadel_ext_action()

	data_mine_set_mission_segment ("m40_sniper_alley" );

end

// === f_citadel_ext_blip::: Initialize
script dormant f_citadel_ext_blip()
	f_blip_flag( fg_citadel_main_entrance, "recon" );
	// XXX should probably have a VO associated with this
	
	sleep_until( volume_test_players(tv_citadel_ext_airlock_area), 1 );	
	f_unblip_flag( fg_citadel_main_entrance );
	
end

// === f_citadel_ext_unblip::: Unblips all citadel exterior blips
script dormant f_citadel_ext_unblip()

	f_unblip_flag( valley_entrance_flag );
	f_unblip_flag( citadel_exterior_flag );
	f_unblip_flag( fg_citadel_main_entrance );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: DOOR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_door_create::: Initialize
script dormant f_citadel_ext_door_init()
	sleep_until( object_valid(citadel_ent_airlock_01), 1 );

	// setup trigger
	wake( f_citadel_ext_door_trigger );

	// setup lights
	//thread( f_greenlight_on(sn_door_cit_entrance) );
	//thread( f_greenlight_on(sn_door_cit_airlock) );

end

// === f_citadel_ext_door_deinit::: DeInitialize
script dormant f_citadel_ext_door_deinit()
	sleep_until( current_zone_set_fully_active() > DEF_S_ZONESET_VALE_HALL(), 1 );	// This is necessary to let the tasks functions finish before being cleaned up - TWF
	
	// deinit functions
	kill_script( f_citadel_ext_door_init );
	kill_script( f_citadel_ext_door_trigger );
	
end

// === f_citadel_ext_door_trigger::: Manages triggering all the different door states as it airlocks
script dormant f_citadel_ext_door_trigger()

	// setup auto open
	citadel_ent_airlock_01->speed_set_open( 2.5 );
	citadel_ent_airlock_01->auto_trigger_open( tv_citadel_ext_airlock_enterance, FALSE, TRUE, FALSE );
	sleep_until( citadel_ent_airlock_01->check_open(), 1 );
	
	// play the VO
	wake( f_el_citadel_enter_vo );  // XXX function name should be standardized
	
	// close when everyone's inside
	citadel_ent_airlock_01->auto_trigger_close( tv_citadel_ext_airlock_area, FALSE, TRUE, TRUE );
	sleep_until( citadel_ent_airlock_01->check_close(), 1 );

	// start loading DEF_S_ZONESET_VALE_HALL
	volume_teleport_players_not_inside(tv_citadel_ext_airlock_area, fg_vale_hall_tp);

	prepare_to_switch_to_zone_set( f_zoneset_get(DEF_S_ZONESET_VALE_HALL()) );

	// unblip any citadel
	wake( f_citadel_ext_unblip );
	
	// destroy the mammoth for now
	wake( f_valley_supplies_destroy );
	object_destroy( main_mammoth );
	sleep(1);
	sleep_until (not preparingToSwitchZoneSet(), 1); // poll whether async load is complete
	
	// turn on the red lights
	//thread( f_redlight_on(sn_door_cit_entrance) );	// XXX I deleted these old doors.  Need to figure out how to do lights for doors.  Could probably be part of generic door script

	// load vale hall and open the interior doors
	f_insertion_zoneload( DEF_S_ZONESET_VALE_HALL(), TRUE );
	
	citadel_ent_airlock_02->speed_set_open( 2.5 );
	citadel_ent_airlock_02->open();

	// close when everyone's inside
	thread( citadel_ent_airlock_02->auto_trigger_close(tv_citadel_ext_airlock_area, TRUE, FALSE, TRUE) );
	sleep_until( citadel_ent_airlock_02->check_close(), 1 );
	zone_set_trigger_volume_enable("begin_zone_set:zone_set_hall_battery", TRUE);
	// save game
	checkpoint_no_timeout( TRUE, "f_citadel_ext_door_trigger" );
	
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_citadel_ext_ai_bridge_garbage_thread_id = 0;
static long L_citadel_ext_ai_front_garbage_thread_id = 0;
static long L_citadel_ext_ai_mid_garbage_thread_id = 0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_create::: Initialize
script dormant f_citadel_ext_ai_init()
	
	// human and player are allies		
	ai_allegiance( player, human );	
	ai_allegiance( human, player );
	
	// set alliances		
	ai_allegiance( covenant, forerunner );		
	ai_allegiance( forerunner, covenant );

	// set AI lod	
	//ai_lod_full_detail_actors( 30 );

	// init sub modules
	wake( f_citadel_ext_ai_objcon_init );
	//wake( f_citadel_ext_ai_defenses_init );
	
	// setup trigger
	wake( f_citadel_ext_ai_trigger );

end

// === f_citadel_ext_ai_deinit::: DeInitialize
script dormant f_citadel_ext_ai_deinit()

	// cleanup
	wake( f_citadel_ext_ai_erase );
	
	// deinit functions
	kill_script( f_citadel_ext_ai_init );
	kill_script( f_citadel_ext_ai_trigger );
	
	kill_script( f_citadel_ext_ai_bridge_spawn );
	kill_script( f_citadel_ext_ai_bridge_garbage );

	kill_script( f_citadel_ext_ai_front_spawn );
	kill_script( f_citadel_ext_ai_front_garbage );

	kill_script( f_citadel_ext_ai_mid_spawn );
	kill_script( f_citadel_ext_ai_mid_garbage );
	
	kill_script( f_citadel_ext_ai_rear_low_spawn );
	kill_script( f_citadel_ext_ai_rear_top_spawn );

	// deinit sub modules
	wake( f_citadel_ext_ai_objcon_deinit );
	//wake( f_citadel_ext_ai_defenses_deinit );
	
end

// === f_citadel_ext_ai_trigger::: Trigger
script dormant f_citadel_ext_ai_trigger()

	// for testing purposes check if the objcon has been forced already
	if ( S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_START ) then
	
		sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_SETUP, 1 );
		wake( f_citadel_ext_ai_bridge_spawn );
	
		sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_ATTACK, 1 );
		wake( f_citadel_ext_ai_front_spawn );
		
	end

	if ( S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_END ) then

		sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_START, 1 );
		wake( f_citadel_ext_ai_mid_spawn );
	
		sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_START, 1 );
		wake( f_citadel_ext_ai_rear_low_spawn );
	
		sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, 1 );
		wake( f_citadel_ext_ai_rear_top_spawn );

	end

end

script static void f_pawn_counter( ai pawn, short living_count)
	local short  s_pawn_count = 0;
	local short	 s_pawn_limit = 1;

	repeat
	sleep_s(1.5);
		if (ai_living_count(sg_citadel_ext) <= living_count) and (ai_living_count(sg_citadel_ext_rear_top_pawns) <= 2) and (s_pawn_count != s_pawn_limit) then
			ai_place(pawn);
			s_pawn_count = s_pawn_count + 1;
		end
	until(s_pawn_count == s_pawn_limit);

end


// === f_citadel_ext_ai_erase::: Erases all the citadel exterior AI
script dormant f_citadel_ext_ai_erase()
	
	ai_erase( sg_citadel_ext );
	garbage_collect_now();

end

// === f_citadel_ext_ai_bridge_spawn::: Spawns the default bridge ai
script dormant f_citadel_ext_ai_bridge_spawn()
	sleep_until((ai_living_count(sg_valley)) <= 9);
	
	// place ai
	wake(f_citadel_ext_bridge_sniper_spawn);
	ai_place( sg_citadel_ext_bridge_init );
	
	sleep_until(((ai_living_count(sg_citadel_ext_bridge)) <= 10)
								and
								(volume_test_players( tv_citadel_ext_bridge_knight_spawn)));
	ai_place_in_limbo(sq_cit_xt_br_knight);
	
	/*sleep_until(((ai_living_count(sg_citadel_ext_bridge)) <= 9)
								and
								(S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START));
	ai_place(sq_cit_xt_br_charge_jackals_re);*/
	
	sleep_until(((ai_living_count(sg_citadel_ext_bridge)) <= 9)
								and
								(S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START));
	ai_place(sq_cit_xt_br_re_grunts_1);
	
	sleep_until(((ai_living_count(sg_citadel_ext_bridge)) <= 6)
								and
								(S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START));
	ai_place(sq_cit_xt_br_re_grunts_2);
	

	// setup garbage collection
	wake( f_citadel_ext_ai_bridge_garbage );

end

script dormant f_citadel_ext_bridge_sniper_spawn()
	sleep_until(
		( S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_ATTACK )
			or
			(ai_living_count(sg_valley_knight) < 1)
			or
			(ai_living_count(sg_valley_infantry_midrear) <= 1)
		, 1 );
	ai_place(sg_citadel_ext_front_snipers);

end

// === f_citadel_ext_ai_bridge_garbage::: Garbage collection for the default bridge ai
script dormant f_citadel_ext_ai_bridge_garbage()
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_END, 1 );

	L_citadel_ext_ai_bridge_garbage_thread_id = f_ai_garbage_kill( sg_citadel_ext_bridge, -1, -1, -1, -1, FALSE );

end

// === f_citadel_ext_ai_front_spawn::: Spawns the default front ai
script dormant f_citadel_ext_ai_front_spawn()
	sleep_until((ai_living_count(sg_valley)) <= 18);

	
	// place ai
	//ai_place( sg_citadel_ext_front );

	// setup garbage collection
	wake( f_citadel_ext_ai_front_garbage );

end

// === f_citadel_ext_ai_front_garbage::: Garbage collection for the default front ai
script dormant f_citadel_ext_ai_front_garbage()
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_END, 1 );

	//L_citadel_ext_ai_front_garbage_thread_id = f_ai_garbage_kill( sg_citadel_ext_front, -1, -1, -1, -1, FALSE );

end

// === f_citadel_ext_ai_mid_spawn::: Spawns the default mid ai
script dormant f_citadel_ext_ai_mid_spawn()
	
	// place ai
	ai_place( sg_citadel_ext_mid_turrets );
	ai_place(sq_cit_x_up_rear_jackal_s);
	sleep_until((ai_living_count(sg_citadel_ext)) <= 20);
	wake (f_citadel_ext_ai_ranger_spawn);

	// setup garbage collection
	wake( f_citadel_ext_ai_mid_garbage );

end

// === f_citadel_ext_ai_mid_garbage::: Garbage collection for the default mid ai
script dormant f_citadel_ext_ai_mid_garbage()
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_END, 1 );

	L_citadel_ext_ai_mid_garbage_thread_id = f_ai_garbage_kill( sg_citadel_ext_mid, -1, -1, -1, -1, FALSE );

end

// === f_citadel_ext_ai_rear_low_spawn::: Spawns the default low ai
script dormant f_citadel_ext_ai_rear_low_spawn()
	
	// place ai
	sleep_until((ai_living_count(sg_citadel_ext)) <= 14);
	ai_place( sq_cit_x_low_rear_grunt );
	ai_place( sq_cit_x_low_rear_grunt_2 );
	sleep_until(S_citadel_ext_ai_objcon < DEF_CITADEL_EXT_AI_OBJCON_MID_END );
	ai_place(sq_cit_x_low_rear_pawn_1);
	ai_place(sq_cit_x_low_rear_pawn_2);

	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH_BACK, 1 );

end

// === f_citadel_ext_ai_rear_top_spawn::: Spawns the default top ai
script dormant f_citadel_ext_ai_rear_top_spawn()
	
	// place ai
	f_ai_garbage_erase(sg_citadel_ext_bridge, 10, 20, -1, -1, TRUE);
	wake (f_citadel_ext_ai_knight_guard_spawn);
	sleep_until((ai_living_count(sg_citadel_ext)) <= 18);
	ai_place( sg_citadel_ext_rear_top_init );
	sleep_until((ai_living_count(sg_citadel_ext)) <= 17);
	ai_place(sq_cit_x_up_rear_pawn_1);
	ai_place(sq_cit_x_up_rear_pawn_2);
	f_pawn_counter(sq_cit_x_up_rear_pawn_1, 19);
	sleep_s(1);
	f_pawn_counter( sq_cit_x_up_rear_pawn_2, 20);

end

script dormant f_citadel_ext_ai_knight_guard_spawn()
	
	sleep_until(volume_test_players( tv_citadel_ext_rear_knight_1_spawn ), 1);
	sleep_until((ai_living_count(sg_citadel_ext)) <= 19);
	ai_place_in_limbo(sq_cit_x_up_rear_knight);
	
end

script dormant f_citadel_ext_ai_ranger_spawn()

	sleep_until(volume_test_players(tv_citadel_ext_rear_ranger_spawn), 1);
	ai_place(sg_citadel_ext_rear_rangers);

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_CITADEL_EXT_AI_OBJCON_INIT =         											00;
global short DEF_CITADEL_EXT_AI_OBJCON_SETUP =    													01;

global short DEF_CITADEL_EXT_AI_OBJCON_ATTACK = 														10;

global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START = 											10;
global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_FRONT = 											11;
global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ORDER = 							12;
global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ATTACK = 						15;
global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_JACKAL_PUSH = 								17;
global short DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_END = 												20;

global short DEF_CITADEL_EXT_AI_OBJCON_FRONT_START = 												20;
global short DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND = 											22;
global short DEF_CITADEL_EXT_AI_OBJCON_FRONT_END = 													30;

global short DEF_CITADEL_EXT_AI_OBJCON_MID_START = 													30;
global short DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START = 									31;
global short DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK = 										35;
global short DEF_CITADEL_EXT_AI_OBJCON_MID_END = 														39;

global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_START = 										40;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK = 										41;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH = 											42;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH_BACK = 								43;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT = 							45;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_CAPTURE = 							47;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_END = 											49;

global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_START = 										50;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_01 = 						52;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_PUSH_01 = 							53;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_02 = 						54;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_FINALE = 							57;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_FINALE = 							58;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_FINALE_PUSH = 							59;
global short DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_END = 											60;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

global short S_citadel_ext_ai_objcon = 																			DEF_CITADEL_EXT_AI_OBJCON_INIT;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_create::: Initialize
script dormant f_citadel_ext_ai_objcon_init()

	// wake the citadel_ext objcon
	wake( f_citadel_ext_ai_objcon_controller );

end

// === f_citadel_ext_ai_objcon_deinit::: DeInitialize
script dormant f_citadel_ext_ai_objcon_deinit()
	
	// kill functions
	kill_script( f_citadel_ext_ai_objcon_init );
	kill_script( f_citadel_ext_ai_objcon_controller );
	
	kill_script( f_citadel_ext_ai_objcon_control_setup );
	
	kill_script( f_citadel_ext_ai_objcon_control_attack );
	
	kill_script( f_citadel_ext_ai_objcon_control_bridge_start );
	kill_script( f_citadel_ext_ai_objcon_control_bridge_front );
	kill_script( f_citadel_ext_ai_objcon_control_bridge_kamikaze_order );
	kill_script( f_citadel_ext_ai_objcon_control_bridge_jackal_push );
	kill_script( f_citadel_ext_ai_objcon_control_bridge_end );
	
	kill_script( f_citadel_ext_ai_objcon_control_front_start );
	kill_script( f_citadel_ext_ai_objcon_control_front_defend );
	kill_script( f_citadel_ext_ai_objcon_control_front_end );
	
	kill_script( f_citadel_ext_ai_objcon_control_mid_start );
	kill_script( f_citadel_ext_ai_objcon_control_mid_knight_start );
	kill_script( f_citadel_ext_ai_objcon_control_mid_pawn_attack );
	kill_script( f_citadel_ext_ai_objcon_control_mid_end );

	kill_script( f_citadel_ext_ai_objcon_control_rear_start );
	kill_script( f_citadel_ext_ai_objcon_control_rear_attack );
	kill_script( f_citadel_ext_ai_objcon_control_rear_push );
	kill_script( f_citadel_ext_ai_objcon_control_rear_push_back );
	kill_script( f_citadel_ext_ai_objcon_control_rear_low_assault );
	kill_script( f_citadel_ext_ai_objcon_control_rear_low_capture );
	kill_script( f_citadel_ext_ai_objcon_control_rear_low_end );
	
	kill_script( f_citadel_ext_ai_objcon_control_rear_top );
	kill_script( f_citadel_ext_ai_objcon_control_rear_push_right_01 );
	kill_script( f_citadel_ext_ai_objcon_control_rear_push_left_01 );
	kill_script( f_citadel_ext_ai_objcon_control_rear_push_right_02 );
	kill_script( f_citadel_ext_ai_objcon_control_rear_finale_right );
	kill_script( f_citadel_ext_ai_objcon_control_rear_finale_left );
	kill_script( f_citadel_ext_ai_objcon_control_rear_end );
	
end

// === f_citadel_ext_ai_objcon_set::: Sets the objcon value and manages any default practices
script static void f_citadel_ext_ai_objcon_set( short s_val )
static short 	s_checkpoint_objcon = 			DEF_CITADEL_EXT_AI_OBJCON_INIT;
static long 	l_checkpoint_timer = 				0;
local short 	s_checkpoint_objcon_temp = 	0;

static long 	l_garbage_timer = 					0;

	
	if( s_val > S_citadel_ext_ai_objcon ) then
		S_citadel_ext_ai_objcon = s_val;
		inspect( s_val );
		
		// checkpoint
		if ( (s_checkpoint_objcon <= s_val) and (l_checkpoint_timer <= game_tick_get()) ) then

			// figure out what next objcon to check at
			s_checkpoint_objcon_temp = ( s_val / 10 );
			s_checkpoint_objcon = ( s_checkpoint_objcon_temp * 10 ) + 10;
			
//			l_checkpoint_timer = game_tick_get() + seconds_to_frames( 60.0 );
//
//			checkpoint_no_timeout( TRUE, "f_citadel_ext_ai_objcon_set" );

		end

		// collect garbage
		/*if ( l_garbage_timer <= game_tick_get() ) then

			l_garbage_timer = game_tick_get() + seconds_to_frames( 30.0 );
			
			garbage_collect_now();

		end*/
		
	end

end

// === f_citadel_ext_ai_objcon_controller::: Loads the individual objcon controllers
script dormant f_citadel_ext_ai_objcon_controller()

	// sets up all the controllers
	// --- SETUP
	wake( f_citadel_ext_ai_objcon_control_setup );
	
	// --- ATTACK
	wake( f_citadel_ext_ai_objcon_control_attack );
	
	// --- BRIDGE
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_SETUP, 1 );
	wake( f_citadel_ext_ai_objcon_control_bridge_start );
	wake( f_citadel_ext_ai_objcon_control_bridge_front );
	wake( f_citadel_ext_ai_objcon_control_bridge_kamikaze_order );
	wake( f_citadel_ext_ai_objcon_control_bridge_jackal_push );
	wake( f_citadel_ext_ai_objcon_control_bridge_end );
	
	// --- FRONT
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START, 1 );
	wake( f_citadel_ext_ai_objcon_control_front_start );
	wake( f_citadel_ext_ai_objcon_control_front_defend );
	wake( f_citadel_ext_ai_objcon_control_front_end );
	
	// --- MID
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_START, 1 );
	wake( f_citadel_ext_ai_objcon_control_mid_start );
	wake( f_citadel_ext_ai_objcon_control_mid_knight_start );
	wake( f_citadel_ext_ai_objcon_control_mid_pawn_attack );
	wake( f_citadel_ext_ai_objcon_control_mid_end );

	// --- REAR
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_START, 1 );
	wake( f_citadel_ext_ai_objcon_control_rear_start );
	wake( f_citadel_ext_ai_objcon_control_rear_attack );
	wake( f_citadel_ext_ai_objcon_control_rear_push );
	wake( f_citadel_ext_ai_objcon_control_rear_push_back );
	wake( f_citadel_ext_ai_objcon_control_rear_low_assault );
	wake( f_citadel_ext_ai_objcon_control_rear_low_capture );
	wake( f_citadel_ext_ai_objcon_control_rear_low_end );
	
	sleep_until( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_START, 1 );
	wake( f_citadel_ext_ai_objcon_control_rear_top );
	wake( f_citadel_ext_ai_objcon_control_rear_push_right_01 );
	wake( f_citadel_ext_ai_objcon_control_rear_push_left_01 );
	wake( f_citadel_ext_ai_objcon_control_rear_push_right_02 );
	wake( f_citadel_ext_ai_objcon_control_rear_finale_right );
	wake( f_citadel_ext_ai_objcon_control_rear_finale_left );
	wake( f_citadel_ext_ai_objcon_control_rear_end );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: SETUP
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_setup::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_setup()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_SETUP )
			or
			volume_test_players( tv_citadel_ext_objcon_01 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_SETUP );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: ATTACK
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_attack::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_attack()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_ATTACK )
			or
			//f_ai_sees_enemy( sg_citadel_ext_front )
			//( f_ai_killed_cnt(sg_citadel_ext_front) >= 1 )
			f_ai_is_partially_defeated(sg_valley, 3 )
			or
			f_valley_ai_knight_defeated()
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_ATTACK );
	thread(f_mus_m40_e07_begin());

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: BRIDGE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_bridge_start::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_bridge_start()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START )
			or
			volume_test_players( tv_citadel_ext_objcon_10 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_START );

end

// === f_citadel_ext_ai_objcon_control_bridge_front::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_bridge_front()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_FRONT )
			or
			volume_test_players( tv_citadel_ext_objcon_11 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_FRONT );

	// delay and then force KAMIKAZE
	//sleep_until( f_ai_sees_enemy(sg_citadel_ext_front), 1 );
	sleep_s( 10.0 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ORDER ); 
	
end

// === f_citadel_ext_ai_objcon_control_bridge_kamikaze_order::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_bridge_kamikaze_order()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ORDER )
			or
			volume_test_players( tv_citadel_ext_objcon_12 )
			or
			(
				 ((f_ai_killed_cnt(sg_citadel_ext_bridge) >= 2 ))
				and
				volume_test_players_lookat(tv_citadel_ext_bridge_orders_see, 25.0, 5.0)
			)
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ORDER );

end

// === f_citadel_ext_ai_objcon_control_bridge_jackal_push::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_bridge_jackal_push()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_JACKAL_PUSH )
			or
			(
				( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ORDER )
				and
				(
					( ai_body_count(obj_citadel_ext_front.bridge_grunt_kamikaze) >= 3 )
					or
					( ai_living_count(sg_citadel_ext_bridge_grunts) <= 3 )
				)
			)
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_JACKAL_PUSH );

end

// === f_citadel_ext_ai_objcon_control_bridge_end::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_bridge_end()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_END )
			or
			f_ai_is_partially_defeated( sg_citadel_ext_bridge, 2 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_END );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: FRONT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_front_start::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_front_start()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_START )
			or
			volume_test_players( tv_citadel_ext_objcon_20 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_FRONT_START );

	// setup cover
	//wake( f_citadel_ext_cover_front_setup );

end

// === f_citadel_ext_ai_objcon_control_front_defend::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_front_defend()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND )
			or
			volume_test_players( tv_citadel_ext_objcon_22 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND );

end

// === f_citadel_ext_ai_objcon_control_front_push::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_front_end()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_FRONT_END ));

	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_FRONT_END );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: MID
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_mid_start::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_mid_start()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_START )
			or
			volume_test_players( tv_citadel_ext_objcon_30 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_START );

	// setup cover
	wake( f_citadel_ext_cover_mid_setup );

end

// === f_citadel_ext_ai_objcon_control_mid_knight_start::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_mid_knight_start()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START )
			or
			volume_test_players( tv_citadel_ext_objcon_31 )
			or
			(
				( S_citadel_ext_ai_objcon == DEF_CITADEL_EXT_AI_OBJCON_MID_START )
				/*and
				( ai_living_count(sq_cit_ext_front_knight_01) <= 0 )*/

				and
				volume_test_players_lookat(tv_citadel_ext_mid_orders_see, 25.0, 5.0)
			)
		, 1 );
	
	if ( not volume_test_players(tv_citadel_ext_objcon_31) ) then
		sleep_s( 1.0 );
	end
	
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_KNIGHT_START );

	// place the knight
	ai_place_in_limbo( sq_cit_ext_mid_knight_01 );

end

// === f_citadel_ext_ai_objcon_control_mid_pawn_attack::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_mid_pawn_attack()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK );

	// spawn in the pawns
	if ( ai_living_count(sq_cit_ext_mid_knight_01) > 0 ) then
		ai_place( sg_citadel_ext_mid_pawns );
	end

	//ai_place( sg_citadel_ext_mid_grunts );

end


// === f_citadel_ext_ai_objcon_control_mid_end::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_mid_end()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_MID_END )
			or
			volume_test_players( tv_citadel_ext_objcon_39 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_END );

	// blip the citatel enterance	
	wake( f_citadel_ext_blip ); 	// XXX need to figure out if this is the best place to trigger this

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: REAR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

static long L_citadel_ext_ai_rear_push_timer = 																0;
static short S_citadel_ext_ai_rear_push_living = 															0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_rear_start::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_start()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_START )
			or
			volume_test_players( tv_citadel_ext_objcon_40 )
			or
			(
				( f_ai_killed_cnt(sg_citadel_ext_rear) > 0 )
				and
				f_ai_sees_enemy( sg_citadel_ext_rear )
			)
			/*
			*/
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_START );

	// setup cover
	wake( f_citadel_ext_cover_rear_setup );

end

// === f_citadel_ext_ai_objcon_control_rear_attack::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_attack()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK )
			or
			(
				( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_START )
				and
				f_ai_sees_enemy( sg_citadel_ext_rear )
			)
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK );
	
	// store living count for push
	S_citadel_ext_ai_rear_push_living = ai_living_count( sg_citadel_ext_rear );

	// start push timer
	L_citadel_ext_ai_rear_push_timer = game_tick_get() + seconds_to_frames( real_random_range(2.0, 3.0) );

end

// === f_citadel_ext_ai_objcon_control_rear_push::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_push()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH )
			or
			(
				( S_citadel_ext_ai_rear_push_living > 0 )
				and
				( ai_living_count(sg_citadel_ext_rear) < S_citadel_ext_ai_rear_push_living )
			)			
			or
			(
				( L_citadel_ext_ai_rear_push_timer != 0 )
				and
				( L_citadel_ext_ai_rear_push_timer <= game_tick_get() )
			)			
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH );

end

// === f_citadel_ext_ai_objcon_control_rear_push_back::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_push_back()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH_BACK )
			or
			volume_test_players( tv_citadel_ext_objcon_43 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH_BACK );

end

// === f_citadel_ext_ai_objcon_control_rear_low_assault::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_low_assault()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT )
			or
			volume_test_players( tv_citadel_ext_objcon_45_a )
			or
			volume_test_players( tv_citadel_ext_objcon_45_b )
			or
			volume_test_players( tv_citadel_ext_objcon_45_c )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT );

end

// === f_citadel_ext_ai_objcon_control_rear_low_capture::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_low_capture()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_CAPTURE )
			or
			volume_test_players( tv_citadel_ext_objcon_47 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_CAPTURE );

end

// === f_citadel_ext_ai_objcon_control_rear_low_end::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_low_end()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_END )
			or
			volume_test_players( tv_citadel_ext_objcon_49_a )
			or
			volume_test_players( tv_citadel_ext_objcon_49_b )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_END );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 2 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: OBJCON: CONTROL: REAR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_objcon_control_rear_top::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_top()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_START )
			or
			volume_test_players( tv_citadel_ext_objcon_50 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_START );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_push_right_01::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_push_right_01()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_01 )
			or
			volume_test_players( tv_citadel_ext_objcon_52 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_01 );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_finale::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_push_left_01()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_PUSH_01 )
			or
			volume_test_players( tv_citadel_ext_objcon_53 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_PUSH_01 );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_push_right_02::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_push_right_02()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_02 )
			or
			volume_test_players( tv_citadel_ext_objcon_54 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_PUSH_02 );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_finale_right::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_finale_right()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_FINALE )
			or
			volume_test_players( tv_citadel_ext_objcon_57 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_RIGHT_FINALE );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_finale_left::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_finale_left()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_FINALE )
			or
			volume_test_players( tv_citadel_ext_objcon_58 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_LEFT_FINALE );
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 1 );

end

// === f_citadel_ext_ai_objcon_control_rear_finale_push::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_finale_push()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_FINALE_PUSH )
			or
			volume_test_players( tv_citadel_ext_objcon_59_a )
			or
			volume_test_players( tv_citadel_ext_objcon_59_b )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_FINALE_PUSH );

end

// === f_citadel_ext_ai_objcon_control_rear_end::: controls an objcon
script dormant f_citadel_ext_ai_objcon_control_rear_end()

	sleep_until( 
			( S_citadel_ext_ai_objcon >= DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_END )
			or
			volume_test_players( tv_citadel_ext_objcon_60 )
		, 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_END );
	thread(f_mus_m40_e07_finish());
	
	// increment lives of pawns
	f_citadel_ext_pawn_rear_recycle_lives_inc( -1, 3 );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: GRUNTS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: GRUNTS: KAMIKAZE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_citadel_ext_grung_bridge_kamikaze::: COMMAND SCRIPT
script command_script cs_citadel_ext_grunt_bridge_kamikaze()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	//thread( f_citadel_ext_grung_bridge_kamikaze_trigger(ai_current_actor,real_random_range(12.5,15.0)) );
	
	ai_grunt_kamikaze( ai_current_actor );

end

// === f_citadel_ext_grung_bridge_kamikaze_trigger::: Triggers the kamikaze mode
script static void f_citadel_ext_grung_bridge_kamikaze_trigger( ai ai_grunt, real r_range )
static long l_timer = 0;
static boolean b_triggered = FALSE;

	/*sleep_until( (ai_living_count(ai_grunt) == 0) or b_triggered or (objects_distance_to_object(Players(), ai_grunt) <= 7.5) or ((objects_distance_to_object(Players(), ai_grunt) <= r_range) and objects_can_see_object(Players(), ai_grunt, 15.0)), 1 );
	sleep_until( (ai_living_count(ai_grunt) == 0) or (game_tick_get() >= l_timer) or (objects_distance_to_object(Players(), ai_grunt) <= 7.5), 1 );*/
	
	if ( ai_living_count(ai_grunt) != 0 ) then
	
		/*if ( not b_triggered ) then*/
			b_triggered = TRUE;
			l_timer = game_tick_get() + seconds_to_frames( real_random_range(0.75, 1.0) );
		//end
	
		ai_grunt_kamikaze( ai_grunt );
		
	end

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: KNIGHT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
	
// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object OBJ_citadel_ext_bridge_order =													NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_citadel_ext_front_knight_order_kamikaze::: COMMAND SCRIPT
script command_script cs_citadel_ext_front_knight_order_kamikaze()

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	// phase to the point
	cs_phase_to_point( ps_citadel_ext_orders.kamikaze_phase );

	// setup the puppeteer
	thread( f_citadel_ext_front_knight_order_kamikaze(ai_current_actor) );

end

// === f_citadel_ext_front_knight_order_kamikaze::: Handles the knight ordering the Grunt Kamikaze
script static void f_citadel_ext_front_knight_order_kamikaze( object obj_knight )
local long l_pup_id = 0;

	OBJ_citadel_ext_bridge_order = obj_knight;
	
	l_pup_id = pup_play_show( "pup_citadel_ext_bridge_order" );

	sleep_until( not pup_is_playing(l_pup_id), 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_BRIDGE_KAMIKAZE_ATTACK );
	
end

// === cs_citadel_ext_mid_knight_place::: COMMAND SCRIPT
script command_script cs_citadel_ext_mid_knight_place()
local long l_pup_id = 0;

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	object_hide( ai_current_actor, FALSE );
	cs_phase_in();
	
	l_pup_id = pup_play_show( "pup_citadel_ext_mid_order" );

	sleep_until( not pup_is_playing(l_pup_id), 1 );
	f_citadel_ext_ai_objcon_set( DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK );

end

// === cs_citadel_ext_knight_place_generic::: COMMAND SCRIPT
script command_script cs_citadel_ext_knight_place_generic()
static long l_timer = 0;

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	// randomly delay to just give variety
	sleep_until( l_timer <= game_tick_get(), 1 );
	l_timer = game_tick_get() + seconds_to_frames( real_random_range(0.25, 0.50) );
	
	// unhide and phase in
	object_hide( ai_current_actor, FALSE );
	cs_phase_in();

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: SNIPERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: SNIPERS: FRONT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_citadel_ext_ai_snipers_front_closed =													0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_snipers_front_move::: Manages making the front snipers move
script static void f_citadel_ext_ai_snipers_front_move()

	if ( S_citadel_ext_ai_snipers_front_closed == 0 ) then
		S_citadel_ext_ai_snipers_front_closed = -1;
		end

end

// === f_citadel_ext_ai_snipers_front_closed_set::: Sets which gate is closed to the high snipers
script static boolean f_citadel_ext_ai_snipers_front_closed_set( short s_val )
local boolean b_return = FALSE;
	
	if ( S_citadel_ext_ai_snipers_front_closed != s_val ) then
		S_citadel_ext_ai_snipers_front_closed = s_val;
		inspect( s_val );
		b_return = TRUE;
	end

	// return
	b_return;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: PAWN
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: PAWN: REAR
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

static long L_citadel_ext_rear_pawn_recycle_thread = 												0;

static boolean B_citadel_ext_rear_pawn_recycle_enabled = 										TRUE;

static short S_citadel_ext_rear_pawn_recycle_units_min = 										7;
static short S_citadel_ext_rear_pawn_recycle_units_max = 										9;

static short S_citadel_ext_rear_pawn_recycle_squad_max = 										3;
static short S_citadel_ext_rear_pawn_recycle_group_max = 										22;

static short S_citadel_ext_rear_pawn_recycle_lives = 												10;
static short S_citadel_ext_rear_pawn_recycle_lives_inc_default = 						5;

static short S_citadel_ext_rear_pawn_recycle_garbage_collect_cnt =					10;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_pawn_rear_recycle::: Manages recycling the pawns to keep them filled in
/*script static void f_citadel_ext_pawn_rear_recycle()
local short s_garbage_cnt = 0;
	dprint( "f_citadel_ext_pawn_rear_recycle" );
	
	// initialize total lives by subtracting the count already spawned
	S_citadel_ext_rear_pawn_recycle_lives = S_citadel_ext_rear_pawn_recycle_lives - ai_spawn_count( sg_citadel_ext_rear_top_pawns );
	
	repeat
	
		// wait for it to be time to recycle
		//	- recycler is enabled
		//	- the current number of pawns is below their min
		//	- the total citadel exterior is below the ai max
		//	- there are free lives
		sleep_until( B_citadel_ext_rear_pawn_recycle_enabled and (S_citadel_ext_rear_pawn_recycle_lives > 0) and (ai_living_count(sg_citadel_ext_rear_top_pawns) <= S_citadel_ext_rear_pawn_recycle_units_min) and (ai_living_count(sg_citadel_ext) < S_citadel_ext_rear_pawn_recycle_group_max), 1 );
		//dprint( "f_citadel_ext_pawn_rear_recycle: START!" );
		
		repeat
			//dprint( "f_citadel_ext_pawn_rear_recycle: UNIT TRY" );

			// try and place a new pawn
			begin_random_count( 1 )
				begin
					if ( ai_living_count(sq_cit_ext_top_pawn_01) < S_citadel_ext_rear_pawn_recycle_squad_max ) then
						//dprint( "f_citadel_ext_pawn_rear_recycle: UNIT SQUAD 01" );
						ai_place( sq_cit_ext_top_pawn_01, 1 );
						S_citadel_ext_rear_pawn_recycle_lives = S_citadel_ext_rear_pawn_recycle_lives - 1;
						s_garbage_cnt = s_garbage_cnt + 1;
					end
				end
				begin
					if ( ai_living_count(sq_cit_ext_top_pawn_02) < S_citadel_ext_rear_pawn_recycle_squad_max ) then
						//dprint( "f_citadel_ext_pawn_rear_recycle: UNIT SQUAD 02" );
						ai_place( sq_cit_ext_top_pawn_02, 1 );
						S_citadel_ext_rear_pawn_recycle_lives = S_citadel_ext_rear_pawn_recycle_lives - 1;
						s_garbage_cnt = s_garbage_cnt + 1;
					end
				end			
				begin
					if ( ai_living_count(sq_cit_ext_top_pawn_03) < S_citadel_ext_rear_pawn_recycle_squad_max ) then
						//dprint( "f_citadel_ext_pawn_rear_recycle: UNIT SQUAD 03" );
						ai_place( sq_cit_ext_top_pawn_03, 1 );
						S_citadel_ext_rear_pawn_recycle_lives = S_citadel_ext_rear_pawn_recycle_lives - 1;
						s_garbage_cnt = s_garbage_cnt + 1;
					end
				end	
			end
		
		until ( (S_citadel_ext_rear_pawn_recycle_lives <= 0) or (not B_citadel_ext_rear_pawn_recycle_enabled) or (ai_living_count(sg_citadel_ext_rear_top_pawns) >= S_citadel_ext_rear_pawn_recycle_units_max) or (ai_living_count(sg_citadel_ext) >= S_citadel_ext_rear_pawn_recycle_group_max), 1 );

		// check garbage collect	
		if ( s_garbage_cnt >= S_citadel_ext_rear_pawn_recycle_garbage_collect_cnt ) then
			dprint( "f_citadel_ext_pawn_rear_recycle: GARBAGE!!!" );
			s_garbage_cnt = 0;
			garbage_collect_now();
		end

		//dprint( "f_citadel_ext_pawn_rear_recycle: END!" );

	until( FALSE, 1 );
	
end*/

// === f_citadel_ext_pawn_rear_recycle::: Increments the number of lives the rear pawns have
script static void f_citadel_ext_pawn_rear_recycle_lives_inc( short s_cnt, short s_mod )

	// defaults
	if ( s_cnt < 0 ) then
		s_cnt = S_citadel_ext_rear_pawn_recycle_lives_inc_default;
	end
	
	S_citadel_ext_rear_pawn_recycle_lives = S_citadel_ext_rear_pawn_recycle_lives + ( s_cnt * s_mod );

	inspect( S_citadel_ext_rear_pawn_recycle_lives );

end

// === cs_citadel_ext_pawn_rear_place::: COMMAND SCRIPT
//script command_script cs_citadel_ext_pawn_rear_place()

	/*if ( L_citadel_ext_rear_pawn_recycle_thread == 0 ) then
		L_citadel_ext_rear_pawn_recycle_thread = thread( f_citadel_ext_pawn_rear_recycle() );
	end*/

//end

/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: AI: DEFENSES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

static boolean B_citadel_ext_defenses_active = 															FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_ai_defenses_create::: Initialize
script dormant f_citadel_ext_ai_defenses_init()
	dprint( "f_citadel_ext_ai_defenses_init" );

	// wake the citadel_ext defenses
	//wake( f_citadel_ext_ai_defenses_trigger );

end

// === f_citadel_ext_ai_defenses_deinit::: DeInitialize
script dormant f_citadel_ext_ai_defenses_deinit()
	dprint( "f_citadel_ext_ai_defenses_deinit" );
	
	// kill functions
	kill_script( f_citadel_ext_ai_defenses_init );
	kill_script( f_citadel_ext_ai_defenses_trigger );
	
end

// === f_citadel_ext_ai_defenses_trigger::: Trigger
script dormant f_citadel_ext_ai_defenses_trigger()

	repeat
	
		// wait for the trigger to switch states
		sleep_until( volume_test_players(tv_citadel_ext_defenses) != B_citadel_ext_defenses_active, 1 );
		dprint( "f_citadel_ext_ai_defenses_trigger" );
		
		f_citadel_ext_ai_defenses_active( not B_citadel_ext_defenses_active );
		
	until( FALSE, 1 );
	
end

// === f_citadel_ext_ai_defenses_active::: Sets the defenses active/deactive
script static void f_citadel_ext_ai_defenses_active( boolean b_active )
static long l_target_tread = 0;
static long l_deactivate_thread = 0;
	dprint( "f_citadel_ext_ai_defenses_active" );
	
	if ( b_active != B_citadel_ext_defenses_active ) then
		B_citadel_ext_defenses_active = b_active;
		
		if ( b_active ) then
			
			// kill deactivation thread
			kill_thread( l_deactivate_thread );
		
			if ( ai_living_count(sq_citadel_ext_defenses_01) <= 0 ) then
				dprint( "f_citadel_ext_ai_defenses_active: SPAWN" );
				
				ai_place( sq_citadel_ext_defenses_01 );
				sleep_until( ai_living_count(sq_citadel_ext_defenses_01) > 0, 1 );
				
			end
			
			if ( not isthreadvalid(l_target_tread) ) then
				dprint( "f_citadel_ext_ai_defenses_active: SETUP TARGETING" );
				
				l_target_tread = thread( f_citadel_ext_ai_defenses_targeting() );
				
			end

		else
			dprint( "f_citadel_ext_ai_defenses_active: SHUTDOWN" );
			
			// shut down targeting
			kill_thread( l_target_tread );
			
			// setup the deactivation thread
			l_deactivate_thread = thread( f_citadel_ext_ai_defenses_deactivate() );

		end
		
	end
	
end

// === cs_citadel_ext_defenses_place::: COMMAND SCRIPT
script command_script cs_citadel_ext_defenses_place()
	dprint( "cs_citadel_ext_defenses_place" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	
	// wait a short time; this seems to fix them not showing up
	sleep_s( 0.125 );

	// activate the turret	
	AutomatedTurretActivate( ai_vehicle_get(ai_current_actor) );

end

// === f_citadel_ext_ai_defenses_targeting::: Paints player targets for the turrets
script static void f_citadel_ext_ai_defenses_targeting()
	dprint( "f_citadel_ext_ai_defenses_targeting" );


	// Iniitialize targeting
	cs_shoot( sq_citadel_ext_defenses_01, FALSE, Player0() );
	cs_shoot( sq_citadel_ext_defenses_01, FALSE, Player1() );
	cs_shoot( sq_citadel_ext_defenses_01, FALSE, Player2() );
	cs_shoot( sq_citadel_ext_defenses_01, FALSE, Player3() );

	// mark players as targets for turrets
	repeat
	
		cs_shoot( sq_citadel_ext_defenses_01, volume_test_object(tv_citadel_ext_defenses,Player0()), Player0() );
		cs_shoot( sq_citadel_ext_defenses_01, volume_test_object(tv_citadel_ext_defenses,Player1()), Player1() );
		cs_shoot( sq_citadel_ext_defenses_01, volume_test_object(tv_citadel_ext_defenses,Player2()), Player2() );
		cs_shoot( sq_citadel_ext_defenses_01, volume_test_object(tv_citadel_ext_defenses,Player3()), Player3() );
		
	until( ai_living_count(sq_citadel_ext_defenses_01) <= 0, 1 );

end

// === f_citadel_ext_ai_defenses_deactivate::: Disables the turrets
script static void f_citadel_ext_ai_defenses_deactivate()
	dprint( "f_citadel_ext_ai_defenses_deactivate" );

	// wait a little bit of time
	sleep_s( 1.5 );

	// erase the squad
	ai_erase( sq_citadel_ext_defenses_01 );

end*/

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: SUPPLIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_supplies_create::: Initialize
script dormant f_citadel_ext_supplies_init()
	// supplies
	wake( f_citadel_ext_supplies_create );
	
end

// === f_citadel_ext_supplies_deinit::: DeInitialize
script dormant f_citadel_ext_supplies_deinit()

	// cleanup
	wake( f_citadel_ext_supplies_destroy );
	
	// deinit functions
	kill_script( f_citadel_ext_supplies_init );
	kill_script( f_citadel_ext_supplies_create );
	
end

// === f_citadel_ext_supplies_create::: Creates the supplies/props in the area
script dormant f_citadel_ext_supplies_create()

	object_create_folder( cr_citadel_ext );
	//object_create_folder( scn_citadel_ext );
	object_create_folder( wp_citadel_ext );
	object_create_folder( eq_citadel_ext );

end

// === f_citadel_ext_supplies_destroy::: Destroys the supplies/props in the area
script dormant f_citadel_ext_supplies_destroy()
	
	object_destroy_folder( cr_citadel_ext );
	//object_destroy_folder( scn_citadel_ext );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// CITADEL_EXT: COVER
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_citadel_ext_cover_create::: Initialize
//script dormant f_citadel_ext_cover_init()
	
	// ??? Anything
	
//end

// === f_citadel_ext_cover_deinit::: DeInitialize
script dormant f_citadel_ext_cover_deinit()
	
	// kill functions
	//kill_script( f_citadel_ext_cover_front_setup );
	kill_script( f_citadel_ext_cover_mid_setup );
	kill_script( f_citadel_ext_cover_rear_setup );
	
end
// === f_citadel_ext_move_obj_trigger::: Sets up the trigger for the moving objects
script static void f_citadel_ext_move_obj_trigger( object obj_object, short s_objcon_min, short s_objcon_max, real r_distance_min, real r_distance_max, real r_move_t, real r_move_x, real r_move_y, real r_move_z, real r_rotate_t, real r_rotate_y, real r_rotate_p, real r_rotate_r )
	thread( sys_citadel_ext_move_obj_trigger(obj_object, s_objcon_min, s_objcon_max, r_distance_min, r_distance_max, r_move_t, r_move_x, r_move_y, r_move_z, r_rotate_t, r_rotate_y, r_rotate_p, r_rotate_r ) );
end

// === sys_citadel_ext_move_obj_trigger::: Manages the moving objects
script static void sys_citadel_ext_move_obj_trigger( object obj_object, short s_objcon_min, short s_objcon_max, real r_distance_min, real r_distance_max, real r_move_t, real r_move_x, real r_move_y, real r_move_z, real r_rotate_t, real r_rotate_y, real r_rotate_p, real r_rotate_r )
static long l_timer = 0;
	
	// hide the object
	object_hide( obj_object, TRUE );

	sleep_until( (S_citadel_ext_ai_objcon >= s_objcon_min) and (l_timer <= game_tick_get()) and ((S_citadel_ext_ai_objcon > s_objcon_max) or ((objects_distance_to_object(ai_actors(sg_citadel_ext), obj_object) <= r_distance_max) and (objects_distance_to_object(ai_actors(sg_citadel_ext), obj_object) >= r_distance_min) and (objects_distance_to_object(Players(), obj_object) >= r_distance_min))), 1 );
	
	if ( S_citadel_ext_ai_objcon <= s_objcon_max ) then

		// unhide
		object_hide( obj_object, FALSE );
		
		l_timer = game_tick_get() + seconds_to_frames( real_random_range(0.75, 1.25) );

		if ( (r_move_x + r_move_y + r_move_z) != 0.0 ) then
			object_move_by_offset( obj_object, r_move_t, r_move_x, r_move_y, r_move_z );
		end
		if ( (r_rotate_y + r_rotate_p + r_rotate_r) != 0.0 ) then
			object_rotate_by_offset( obj_object, r_rotate_t, r_rotate_t, r_rotate_t, r_rotate_y, r_rotate_p, r_rotate_r );
		end

	end

end

// === f_citadel_ext_cover_front_setup::: Sets up the front cover objects
//script dormant f_citadel_ext_cover_front_setup()

	// setup cover triggers
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_front_01, DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND, DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND, 0.75, 5.75, real_random_range(3.00,3.25), 0.0, 0.0, real_random_range(1.75,2.25), 0.0, 0.0, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_front_02, DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND, DEF_CITADEL_EXT_AI_OBJCON_FRONT_DEFEND, 0.75, 5.75, real_random_range(2.50,2.75), 0.0, 0.0, real_random_range(1.25,1.75), 0.0, 0.0, 0.0, 0.0 );

//end

// === f_citadel_ext_cover_mid_setup::: Sets up the mid cover objects
script dormant f_citadel_ext_cover_mid_setup()
local real r_move_offset = 0;

	// setup cover triggers
	r_move_offset = real_random_range( 1.25, 1.75 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_mid_01, DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_MID_END, 0.875, 5.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );

	r_move_offset = real_random_range( 1.00,1.25 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_mid_02, DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_MID_END, 0.875, 3.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, real_random_range(1.25,1.50), -90, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_mid_03, DEF_CITADEL_EXT_AI_OBJCON_MID_PAWN_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_MID_END, 0.875, 3.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, real_random_range(1.25,1.50), 90, 0.0, 0.0 );

end

// === f_citadel_ext_cover_rear_setup::: Sets up the rear cover objects
script dormant f_citadel_ext_cover_rear_setup()
local real r_move_offset = 0;

	// setup cover triggers
	r_move_offset = real_random_range( 1.25, 1.50 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_01, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH_BACK, 0.875, 5.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	r_move_offset = 0.675;
//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_02l, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 5.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_02r, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 5.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	r_move_offset = real_random_range( 0.5, 0.675 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_03l, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_END, 0.875, 5.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_03r, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_END, 0.875, 5.25, real_random_range(2.25,2.50), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	r_move_offset = real_random_range( 0.675, 1.25 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_04l, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 5.25, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_04r, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 5.25, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	r_move_offset = real_random_range( 0.675, 1.25 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_05l, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 4.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_05r, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_BACK_ASSAULT, 0.875, 4.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	r_move_offset = real_random_range( 0.675, 0.75 );
	//f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_06, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_PUSH, DEF_CITADEL_EXT_AI_OBJCON_REAR_TOP_START, 0.875, 4.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	
	/*
	r_move_offset = real_random_range( r_move_offset + real_random_range(0.25, 0.375), 1.25 );
	f_citadel_ext_move_obj_trigger( cr_citadel_ext_column_rear_07, DEF_CITADEL_EXT_AI_OBJCON_REAR_LOW_ATTACK, DEF_CITADEL_EXT_AI_OBJCON_REAR_FINALE, 0.75, 6.50, real_random_range(2.75,3.00), 0.0, 0.0, r_move_offset, 0.0, 0.0, 0.0, 0.0 );
	*/

end


// XXX OLD REORGANIZE VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV


/*

// =================================================================================================
// =================================================================================================
// CITADEL EXTERIOR
// =================================================================================================
// =================================================================================================

global boolean b_val_mid_bridge = FALSE;
global boolean b_citadel_jak_backup = FALSE;
global boolean b_cit_door_knight_show = TRUE;
global boolean b_cit_vanboss_show = TRUE;
global boolean b_cit_grunt_advance = FALSE;
global boolean b_move_cit_sniper_forward = FALSE;

script dormant f_citadel_ext_main()

	// need to be somewhat part of the valley set
//		wake( f_spawn_rearsnipers );



	sleep_until( volume_test_players ( tv_citadel_ext_objcon_10 ), 1 );

		data_mine_set_mission_segment ("m40_citadel_ext" );
		garbage_collect_now();
		wake( f_save_citadel_ext_start );
		//wake( f_citadel_savevol );
		//wake( f_citadel_entrance_doors );
		b_citadel_started = TRUE;
		ai_allegiance (covenant, forerunner );	
		ai_allegiance (forerunner, covenant );
		
		sleep(1 );
		dprint("spawn citadel entrance ai" );
		
	
		//ai_erase(gr_snipers_valley );
//		ai_erase(sg_val_recycle_early );
//		sleep(3 );
//		wake( f_spawn_citext_first );	
		sleep_s( 1 );
	
		s_objcon_citext = 10;
//		wake( f_citadelentrance_control );
//		wake( f_citadelentrance_battle );
//		wake( f_spawn_low_boss_vanguard );
		
		wake( f_setmidbridge );
		wake( f_set_cit_jack_backup );
		
		//if ( difficulty_legendary() or difficulty_heroic() ) then
			//wake( f_citext_spawnfrontfiller );
		//end
		//wake( f_citext_spawnfrontfiller );
end


script dormant f_spawn_rearsnipers()
	sleep_until( ( volume_test_players ( tv_spawn_val_rear ) ), 1 );
//		ai_place( sq_cov_sniper_cit1 );

		if (difficulty_legendary() or game_is_cooperative() ) then
			ai_place( sq_cov_sniper_cit2 );
		end
		//ai_place( sq_cov_sniper_cit2 );
		//ai_place( sq_valley_sniper_high_02 );
		
		

	sleep_until( volume_test_players(tv_val_knight_base), 1 ); 
		b_move_cit_sniper_forward = TRUE;
end
*/


/*
script dormant f_setmidbridge()

	sleep_until( volume_test_players( tv_val_mid_bridge ) , 1 );
		b_val_mid_bridge = TRUE;
		
end

script command_script cs_citadel_vanguard_boss()
	sleep_s(3 );
	cs_phase_to_point( pts_citext_phase_pts.p11 ) ;
	sleep_rand_s( 6,9 );
	b_cit_vanboss_show = FALSE;
end

script command_script cs_citadel_floor_knight_1()

	cs_phase_to_point( pts_citext_phase_pts.p1 ) ;
	sleep(1 );
end

script command_script cs_citadel_floor_knight_2()

	cs_phase_to_point( pts_citext_phase_pts.p12 ) ;
	sleep(1 );
end


script dormant f_spawn_citext_first()
	//sleep_s(999 );

	ai_place( sq_cov_intro_grunts_2 );
	sleep(10 );
	ai_place( sq_cov_intro_grunts_1 );
	sleep(10 );
	ai_place( sq_cov_intro_grunts_3 );
	ai_place( sq_cov_intro_grunts_4 );
	ai_place( sq_cov_jackals_intro );
	ai_place( sq_cov_plasma_turret );
	sleep_s(3 );
	ai_place( gr_second_jackals );
end
*/

	/*
script command_script cs_cit_deadbishop()
	sleep(4 );

	ai_kill (ai_current_actor );
end


script dormant f_set_cit_jack_backup()

		sleep_until(

			( ai_spawn_count ( gr_intro_jackals ) > 0 and 
			ai_living_count ( gr_intro_jackals ) <= 0  ) or
			
			( ai_spawn_count ( gr_intro_grunts ) > 0 and 
			ai_living_count ( gr_intro_grunts ) <= 2	)
			, 3
		 );
		dprint( "send in backup" );
		b_citadel_jak_backup = TRUE;
end

script dormant f_save_citadel_ext_start()
	dprint("waiting to save for citadel exterior" );
		sleep_until(

			ai_spawn_count ( sg_rear_jackals ) > 0 and ai_living_count ( sg_rear_jackals ) <= 0 and
			ai_spawn_count ( sg_valley_knight ) > 0 and ai_living_count ( sg_valley_knight ) <= 0 and
			ai_spawn_count ( sg_mid_jackals ) > 0 and ai_living_count ( sg_mid_jackals ) <= 0 and
			ai_spawn_count ( sg_valley_sniper_high ) > 0 and ai_living_count ( sg_valley_sniper_high ) <= 0 and
			ai_spawn_count ( sg_valley ) > 0 and ai_living_count ( sg_valley ) <= 3 		
			, 3
		 );
		
		//
		dprint("valley cleared" );
		if s_objcon_citext < 20 then
			game_save_no_timeout( );
		end
		
		
end
	*/
 
/*
script dormant f_citadel_savevol()
	//repeat
	sleep_until( volume_test_players( tv_citext_save_vol ) and ( game_safe_to_save() == TRUE ), 10 );
						
	//until( s_objcon_citext > 60 );
	dprint("game save" );
	game_save( );
end
*/
/*
script dormant f_citadelentrance_control()
//	wake( f_open_citadel_door );
	//wake( f_citadel_objcon_controller );
	dprint("f_citadelentrance_control running" );
	//wake( f_citext_secondwave );
	//wake( f_citext_spawnfrontfiller );
	
	//wake( f_blip_citadel_entrance );
	sleep(10 );
end


script dormant f_citadel_entrance_doors()
	//dprint("DOORS?" );
	object_create(citadel_ent_airlock_01 );
	object_create(citadel_ent_airlock_02 );
	sleep(1 );
end

script dormant f_citadel_entrance_doors_destroy()
	object_destroy(citadel_ent_airlock_01 );
	object_destroy(citadel_ent_airlock_02 );
end
*/







	/*
script dormant f_citadel_objcon_controller()
	
	sleep_until( volume_test_players (tv_citadel_ext_objcon_15) or s_objcon_citext >= 15, 1 );
		if s_objcon_citext <= 15 then
			s_objcon_citext = 15;
			dprint("s_objcon_citext = 15 " );
		end

	sleep_until( volume_test_players (tv_citadel_ext_objcon_20) or s_objcon_citext >= 20, 1 );
		if s_objcon_citext <= 20 then
			s_objcon_citext = 20;
			dprint("s_objcon_citext = 20 " );
		end

	sleep_until( volume_test_players (tv_citadel_ext_objcon_30) or s_objcon_citext >= 30, 1 );
		if s_objcon_citext <= 30 then
			s_objcon_citext = 30;
			dprint("s_objcon_citext = 30 " );
		end
		
	sleep_until( volume_test_players (tv_citadel_ext_objcon_40)  or s_objcon_citext >= 40 , 1 );
		if s_objcon_citext <= 40 then
			s_objcon_citext = 40;
			dprint("s_objcon_citext = 40 " );
		end


	sleep_until( volume_test_players (tv_citadel_ext_objcon_43)  or s_objcon_citext >= 45, 1 );
		if s_objcon_citext <= 45 then
			s_objcon_citext = 45;
			dprint("s_objcon_citext = 45 " );
		end
	

	sleep_until( volume_test_players (tv_citadel_ext_objcon_50) or s_objcon_citext >= 50, 1 );
		if s_objcon_citext <= 50 then
			s_objcon_citext = 50;
			dprint("s_objcon_citext = 50 " );
		end	

	sleep_until( volume_test_players (tv_citadel_ext_objcon_60) or s_objcon_citext >= 60, 1 );
		if s_objcon_citext <= 60 then
			s_objcon_citext = 60;	
			dprint("s_objcon_citext = 60 " );
		end

end
	*/

/*
script dormant f_citext_spawnfrontfiller()
	ai_place( sq_cov_intro_grunts_filler );			
end
*/

/*
script dormant f_citext_secondwave()
	sleep_s(6 );
	ai_place( sq_for_intro_knight_1 );
	ai_place( sq_cov_grunt_door_rear );
	wake( f_save_citadel_exterior_intro );
end
*/
/*

script dormant f_save_citadel_exterior_intro()



	sleep_until(
			ai_spawn_count ( gr_intro_grunts ) > 0 and 
			ai_living_count ( gr_intro_grunts ) <= 0  and
			ai_spawn_count ( gr_intro_knights ) > 0 and 
			ai_living_count ( gr_intro_knights ) <= 0 and
			ai_spawn_count ( gr_intro_jackals ) > 0 and 
			ai_living_count ( gr_intro_jackals ) <= 0  
		 );
		dprint("all intro cit ext dead" );
		game_save_no_timeout( );
end

script dormant f_save_citadel_ext_middle()
	
		sleep_until(

			ai_spawn_count ( gr_cit_floor_knights ) > 0 and 
			ai_living_count ( gr_cit_floor_knights ) <= 0 and
			ai_spawn_count ( gr_cit_floor_pawns ) > 0 and 
			ai_living_count ( gr_cit_floor_pawns ) <= 0 and
//			ai_spawn_count ( sq_cov_plasma_turret ) > 0 and 
			ai_living_count ( sq_cov_plasma_turret ) <= 0 				
			, 2 
		 );

		dprint("citadel floor cleared" );
		game_save( );		
		
		sleep_until(
			ai_spawn_count ( gr_cit_boss_vanguard ) > 0 and 
			ai_living_count ( gr_cit_boss_vanguard ) <= 0			
			, 2
		 );
		
		
		dprint("citadel vanguard cleared" );
		
			game_save_no_timeout( );

		
end
script dormant f_save_citadel_exterior_complete()

	sleep_until(
			ai_spawn_count ( gr_cit_ext_all ) > 0 and 
			ai_living_count ( gr_cit_ext_all ) <= 0
		 );
		dprint("all cit ext dead" );
		game_save_no_timeout( );
end

script dormant f_citadelentrance_battle()
	sleep_until( s_objcon_citext >= 30, 1 );
		//dprint("spawning entrance wave 1" );
		ai_place( sq_for_cit_knight_floor_1 );
		ai_place( sq_for_cit_ent_pawn_floor_1 );
		ai_place( sq_for_cit_ent_pawn_floor_2 );	
	
		sleep(3 );	
		//
		
		
		if ( difficulty_legendary() or game_is_cooperative() ) then
			ai_place( sq_for_cit_knight_floor_2 );		
		end
		
		wake( f_save_citadel_ext_middle );
		
end


script dormant f_spawn_low_boss_vanguard()


	sleep_until( s_objcon_citext >= 30, 1 );

		ai_place( sq_for_cit_knight_boss );
		//ai_place( sq_for_cit_ent_pawn_3 );
		wake( f_spawn_door_peeps );
		ai_place( sq_cov_grunt_vanguard );	
		ai_place( sq_for_cit_vanguard_jaks_1 );	
		if ( difficulty_legendary()  or game_is_cooperative() ) then

			//ai_place( sq_cov_grunt_door_lower );
			ai_place( sq_for_pawn_snipers_1 );	
		end	
	
	
	wake ( f_save_citadel_exterior_complete );
	
end


script dormant f_spawn_door_peeps()
	ai_place( sq_for_cit_knight_door_guard_1 );
	sleep(1 );
	ai_place( sq_for_cit_knight_door_guard_2 );
	
end

script command_script cs_citadel_door_knight_1()
	sleep_rand_s( 1,3 );
	cs_phase_to_point( pts_citext_phase_pts.p9 ) ;
	sleep_rand_s(5,8 );
	b_cit_door_knight_show = FALSE;
end

script command_script cs_citadel_door_knight_2()
	sleep_rand_s( 1, 3 );
	cs_phase_to_point( pts_citext_phase_pts.p10 ) ;
	sleep(1 );
end

script static boolean f_cit_door_knights_should_retreat()

	static boolean knights_should_retreat = FALSE;
	
	if ( ai_spawn_count(sq_for_cit_knight_door_guard_1) > 0 and 
			 ai_spawn_count(sq_for_cit_knight_door_guard_2) > 0 and 
		( unit_get_shield(sq_for_cit_knight_door_guard_1 ) < 0.95 or unit_get_shield(sq_for_cit_knight_door_guard_2) < 0.95 )) then
		dprint("doors knights retreating" );
		knights_should_retreat = TRUE;
	end
	
	knights_should_retreat;

end

script static boolean f_cit_boss_knight_should_retreat()

	static boolean boss_should_retreat = FALSE;
	
	if (  ai_spawn_count(sq_for_cit_knight_boss) > 0 and unit_get_shield(sq_for_cit_knight_boss) < 0.98  ) then
		boss_should_retreat = TRUE;
	end
	
	boss_should_retreat;

end
*/

