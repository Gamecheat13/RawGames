//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
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
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** JACKAL VALLEY ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_valley_init::: Initialize
script dormant f_valley_init()
	dprint( "f_valley_init" );
	
	// setup cleanup
	wake( f_valley_cleanup );

//	sleep_until( current_zone_set_fully_active() == DEF_S_ZONESET_WATERFALL_PRE_VALE(), 1 );

	// init sub modules
	wake( f_valley_supplies_init );
	wake( f_valley_ai_init );
	
	// setup trigger
	wake( f_valley_trigger );
	
end

// === f_valley_deinit::: DeInitialize
script dormant f_valley_deinit()
	dprint( "f_valley_deinit" );

	// shutdown functions
	effects_distortion_enabled = TRUE; 
	kill_script( f_valley_init );
	kill_script( f_valley_trigger );
	kill_script( f_valley_action );
	kill_script( f_valley_chapter );
	kill_script( f_valley_mammoth_stop );
	kill_script( f_valley_blip );

	// deinit sub modules
	wake( f_valley_supplies_deinit );
	wake( f_valley_ai_deinit );
	
end

// === f_valley_cleanup::: Cleanup
script dormant f_valley_cleanup()
//	sleep_until( current_zone_set_fully_active() > DEF_S_ZONESET_VALE_VALE(), 1 );
	sleep_until( volume_test_players(tv_valley_garbage_ai), 1 );
	dprint( "f_valley_cleanup" );

	// deinit main module
	wake( f_valley_deinit );
	
end

// === f_valley_trigger::: Trigger
script dormant f_valley_trigger()
	sleep_until( volume_test_players(tv_spawn_el_citadel), 1 );
	dprint( "f_valley_trigger" );
	
	wake( f_valley_action );
	
end

//// === f_valley_action::: action
script dormant f_valley_action()
	dprint( "f_valley_action" );

	b_snipervalley_started = TRUE;
	data_mine_set_mission_segment ("m40_sniper_alley" );
	effects_distortion_enabled = FALSE; 
	player_set_profile (sniper_jetpack, player0); 
	player_set_profile (sniper_jetpack, player1); 
	player_set_profile (sniper_jetpack, player2); 
	player_set_profile (sniper_jetpack, player3); 
	// wake the ai
	wake( f_valley_ai_spawn );
	
	//stop mammoth
	wake( f_valley_mammoth_stop );

	// checkpoint	
 
		game_save_no_timeout();
	
	// display chapter
	wake( f_valley_chapter );
	
	thread (f_valley_mid_checkpoint());

end

// === f_valley_cleanup::: Cleanup
script dormant f_valley_chapter()
	dprint( "f_valley_chapter" );
	
	sleep_s( 3 );
	cui_hud_set_objective_complete("chapter_08");
	cui_hud_set_new_objective("chapter_09");
	//dprint("CHAPTER 9 title .." );
	//sound_impulse_start( sound\game_sfx\ui\transition_beeps, NONE, 1 );
	//cinematic_set_title( chapter_09 );
	
end

// === f_valley_mammoth_stop::: Mammoth Stop
script dormant f_valley_mammoth_stop()
 sleep_until( volume_test_object ( tv_spawn_el_citadel, main_mammoth )  , 1 );
	unit_recorder_pause_smooth (main_mammoth, TRUE, 2 );
end


// === f_valley_blip::: Blips the valley enterance
script dormant f_valley_blip()

	f_blip_flag( valley_entrance_flag, "recon" );

	sleep_until( volume_test_players(tv_val_enter2), 1 );
	f_unblip_flag( valley_entrance_flag );
	
end

script static void f_valley_mid_checkpoint()
	sleep_until( volume_test_players (tv_valley_objcon_27), 1 );
	game_save_no_timeout();
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: SUPPLIES
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_supplies_create::: Initialize
script dormant f_valley_supplies_init()
	dprint( "f_valley_supplies_init" );

	// supplies
	wake( f_valley_supplies_create );
	ordnance_drop(drop_pod, "storm_sniper_rifle");
	print("::DROPPED ORDNANCE::");
	
end

// === f_valley_supplies_deinit::: DeInitialize
script dormant f_valley_supplies_deinit()
	dprint( "f_valley_supplies_deinit" );

	// cleanup
	//wake( f_valley_supplies_destroy );
	
	// deinit functions
	kill_script( f_valley_supplies_init );
	kill_script( f_valley_supplies_create );
	
end

// === f_valley_supplies_create::: Creates the supplies/props in the area
script dormant f_valley_supplies_create()
	dprint( "f_valley_supplies_create" );

	object_create_folder( cr_valley );
	//object_create_folder( scn_valley );
	object_create_folder( wp_valley );
	object_create_folder( eq_valley );

end

// === f_valley_supplies_destroy::: Destroys the supplies/props in the area
script dormant f_valley_supplies_destroy()
	dprint( "f_valley_supplies_destroy" );
	
	object_destroy_folder( cr_valley );
	//object_destroy_folder( scn_valley );

end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_valley_ai_garbage_thread_id = 0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_create::: Initialize
script dormant f_valley_ai_init()
	dprint( "f_valley_ai_init" );
	
	// human and player are allies		
	ai_allegiance( player, human );	
	ai_allegiance( human, player );
	
	// set alliances		
	ai_allegiance( covenant, forerunner );		
	ai_allegiance( forerunner, covenant );

	// set AI lod	
	ai_lod_full_detail_actors( 30 );

	// init sub modules
	wake( f_valley_ai_objcon_init );
	wake( f_valley_ai_orders_init );

end

// === f_valley_ai_deinit::: DeInitialize
script dormant f_valley_ai_deinit()
	dprint( "f_valley_ai_deinit" );

	// kill the garbage collection thread
	kill_thread( L_valley_ai_garbage_thread_id );

	// cleanup
	wake( f_valley_ai_erase );
	
	// deinit functions
	kill_script( f_valley_ai_init );
	kill_script( f_valley_ai_spawn );
	kill_script( f_valley_ai_garbage );

	// deinit sub modules
	wake( f_valley_ai_objcon_deinit );
	wake( f_valley_ai_orders_deinit );
	
end

// === f_valley_ai_spawn::: Spawns in the basic valley AI
script dormant f_valley_ai_spawn()
	dprint( "f_valley_ai_spawn" );
	
	// check the objcon before spawning because the insertion point will force it higher so that it doesn't spawn
	if (( S_valley_ai_objcon <= DEF_VALLEY_AI_OBJCON_ATTACK )
				and
				(ai_living_count(sg_valley) < 1)) then
		
		// pre-valley fight
		//ai_place( sg_valley_pre );
	
		// snipers
		ai_place( sg_valley_sniper );
		wake(f_valley_high_snipers_spawn);
		
		// infantry
		ai_place( sg_valley_infantry );
		
		// start the auto garbage manager
		wake( f_valley_ai_garbage );
		
	end

end

script dormant f_valley_high_snipers_spawn()
	
	sleep_until((ai_living_count(sg_valley)) <= 20);
	ai_place(sg_valley_sniper_high);
	
end

// === f_valley_ai_erase::: Erases all spawned valley AI
script dormant f_valley_ai_erase()
	dprint( "f_valley_ai_erase" );
	f_ai_garbage_erase(sg_valley, 10, 20, -1, -1, TRUE);
	//ai_erase( sg_valley );

end

// === f_valley_ai_garbage::: Starts the AI garbage collection
script dormant f_valley_ai_garbage()
	sleep_until( volume_test_players(tv_valley_garbage_ai), 1 );
	dprint( "f_valley_ai_garbage" );
	
	L_valley_ai_garbage_thread_id = f_ai_garbage_kill( sg_valley, -1, -1, -1, -1, FALSE );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: OBJCON
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_VALLEY_AI_OBJCON_INIT =         														00;
global short DEF_VALLEY_AI_OBJCON_ORDERS_START =    												01;
global short DEF_VALLEY_AI_OBJCON_ORDERS_ACTIVE =    												02;
global short DEF_VALLEY_AI_OBJCON_ORDERS_JACKAL =    												03;
global short DEF_VALLEY_AI_OBJCON_ORDERS_END =    													05;
global short DEF_VALLEY_AI_OBJCON_ATTACK =         													10;
global short DEF_VALLEY_AI_OBJCON_FRONT_SNIPER_FOLD =          							12;
global short DEF_VALLEY_AI_OBJCON_FRONT_PUSH =          										15;
global short DEF_VALLEY_AI_OBJCON_MID_START =          											20;
global short DEF_VALLEY_AI_OBJCON_MID_SNIPERS =          										23;
global short DEF_VALLEY_AI_OBJCON_MID_PUSH =          											25;
global short DEF_VALLEY_AI_OBJCON_MID_BACK =          											27;
global short DEF_VALLEY_AI_OBJCON_REAR_ATTACK =          										30;
global short DEF_VALLEY_AI_OBJCON_ESCAPE =          												40;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

global short S_valley_ai_objcon = 																					DEF_VALLEY_AI_OBJCON_INIT;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_objcon_create::: Initialize
script dormant f_valley_ai_objcon_init()
	dprint( "f_valley_ai_objcon_init" );

	// wake the valley objcon
	wake( f_valley_ai_objcon_controller );

end

// === f_valley_ai_objcon_deinit::: DeInitialize
script dormant f_valley_ai_objcon_deinit()
	dprint( "f_valley_ai_objcon_deinit" );
	
	// kill functions
	kill_script( f_valley_ai_objcon_init );
	kill_script( f_valley_ai_objcon_controller );
	
	kill_script( f_valley_ai_objcon_control_front_attack );
	kill_script( f_valley_ai_objcon_control_front_sniper_fold );
	kill_script( f_valley_ai_objcon_control_front_push );
	kill_script( f_valley_ai_objcon_control_mid_start );
	kill_script( f_valley_ai_objcon_control_mid_snipers );
	kill_script( f_valley_ai_objcon_control_mid_push );
	kill_script( f_valley_ai_objcon_control_mid_back );
	kill_script( f_valley_ai_objcon_control_rear_attack );
	kill_script( f_valley_ai_objcon_control_escape );
	
end

// === f_valley_ai_objcon_set::: Sets the objcon value and manages any default practices
script static void f_valley_ai_objcon_set( short s_val )
static short 	s_checkpoint_objcon = 			DEF_CITADEL_EXT_AI_OBJCON_INIT;
static long 	l_checkpoint_timer = 				0;
local short 	s_checkpoint_objcon_temp = 	0;

static long 	l_garbage_timer = 					0;

	dprint( "f_valley_ai_objcon_set" );
	
	if( s_val > S_valley_ai_objcon ) then
		S_valley_ai_objcon = s_val;
		inspect( s_val );
		
		// checkpoint
		if ( (s_checkpoint_objcon <= s_val) and (l_checkpoint_timer <= game_tick_get()) ) then

			// figure out what next objcon to check at
			s_checkpoint_objcon_temp = ( s_val / 10 );
			s_checkpoint_objcon = ( s_checkpoint_objcon_temp * 10 ) + 10;
			
			l_checkpoint_timer = game_tick_get() + seconds_to_frames( 60.0 );

			//game_save();

		end

		// collect garbage
		/*if ( l_garbage_timer <= game_tick_get() ) then

			l_garbage_timer = game_tick_get() + seconds_to_frames( 30.0 );
			
			garbage_collect_now();

		end*/
		
	end

end

// === f_valley_ai_objcon_controller::: Loads the individual objcon controllers
script dormant f_valley_ai_objcon_controller()
	dprint( "f_valley_ai_objcon_controller" );

	// sets up all the controllers
	wake( f_valley_ai_objcon_control_front_attack );
	wake( f_valley_ai_objcon_control_front_sniper_fold );
	wake( f_valley_ai_objcon_control_front_push );
	wake( f_valley_ai_objcon_control_mid_start );
	wake( f_valley_ai_objcon_control_mid_snipers );
	wake( f_valley_ai_objcon_control_mid_push );
	wake( f_valley_ai_objcon_control_mid_back );
	wake( f_valley_ai_objcon_control_rear_attack );
	wake( f_valley_ai_objcon_control_escape );

end

// === f_valley_ai_objcon_control_front_attack::: controls an objcon
script dormant f_valley_ai_objcon_control_front_attack()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_ATTACK )
			or
			f_ai_sees_enemy( sg_valley_infantry )
			or
			f_ai_sees_enemy( sg_valley_sniper )
		, 1 );
	dprint( "f_valley_ai_objcon_control_front_attack" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_ATTACK );
	thread(f_mus_m40_e06_begin());
	
	// setup low sniper move state
	//wake( f_valley_ai_snipers_low_move );

end

// === f_valley_ai_objcon_control_front_sniper_fold::: controls an objcon
script dormant f_valley_ai_objcon_control_front_sniper_fold()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_FRONT_SNIPER_FOLD )
			or
			( f_ai_killed_cnt(sg_valley_sniper_low) >= 1 )
		, 1 );
	dprint( "f_valley_ai_objcon_control_front_sniper_fold" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_FRONT_SNIPER_FOLD );

end

// === f_valley_ai_objcon_control_front_push::: controls an objcon
script dormant f_valley_ai_objcon_control_front_push()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_FRONT_PUSH )
			or
			volume_test_players( tv_valley_objcon_15 )
			or
			( (f_ai_killed_cnt(sg_valley_infantry_front) + f_ai_killed_cnt(sg_valley_infantry_frontmid)) >= 3 )
			or
			( f_ai_killed_cnt(sg_valley) >= 9 )
		, 1 );
	dprint( "f_valley_ai_objcon_control_front_push" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_FRONT_PUSH );

end

// === f_valley_ai_objcon_control_mid_start::: controls an objcon
script dormant f_valley_ai_objcon_control_mid_start()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_START )
			or
			volume_test_players( tv_valley_objcon_20 )
		, 1 );
	dprint( "f_valley_ai_objcon_control_mid_start" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_MID_START );

end

// === f_valley_ai_objcon_control_mid_snipers::: controls an objcon
script dormant f_valley_ai_objcon_control_mid_snipers()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_SNIPERS )
			or
			( volume_test_players(tv_valley_objcon_23_a) or volume_test_players(tv_valley_objcon_23_b) or volume_test_players(tv_valley_objcon_23_c) )
			or
			(
				( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_START )
				and
				volume_test_players_lookat( tv_valley_objcon_23_look, 35.0, 5.0 )
			)
		, 1 );
	dprint( "f_valley_ai_objcon_control_mid_snipers" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_MID_SNIPERS );

	// setup sniper moves
	//wake( f_valley_ai_snipers_high_front_move );
	//wake( f_valley_ai_snipers_high_back_move );

end

// === f_valley_ai_objcon_control_mid_push::: controls an objcon
script dormant f_valley_ai_objcon_control_mid_push()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_PUSH )
			or
			( volume_test_players(tv_valley_objcon_25) )
		, 1 );
	dprint( "f_valley_ai_objcon_control_mid_push" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_MID_PUSH );

end

// === f_valley_ai_objcon_control_mid_back::: controls an objcon
script dormant f_valley_ai_objcon_control_mid_back()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_BACK )
			or
			volume_test_players( tv_valley_objcon_27 )
		, 1 );
	dprint( "f_valley_ai_objcon_control_mid_back" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_MID_BACK );

end

// === f_valley_ai_objcon_control_rear_attack::: controls an objcon
script dormant f_valley_ai_objcon_control_rear_attack()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_REAR_ATTACK )
			or
			volume_test_players( tv_valley_objcon_30 )
			or
			(
				( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_MID_BACK )
				and
				( ai_living_count(sq_for_knight_officer) > 0 )
				and
				( (ai_living_count(sg_valley_infantry_midrear) + ai_living_count(sg_valley_infantry_rear)) < 3 )
				and
				objects_can_see_object( Players(), sq_for_knight_officer, 22.5 )
			)
		, 1 );
	dprint( "f_valley_ai_objcon_control_rear_attack" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_REAR_ATTACK );

end

// === f_valley_ai_objcon_control_escape::: controls an objcon
script dormant f_valley_ai_objcon_control_escape()

	sleep_until( 
			( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_ESCAPE )
			or
			volume_test_players( tv_valley_objcon_40 )
		, 1 );
	dprint( "f_valley_ai_objcon_control_escape" );
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_ESCAPE );
	thread(f_mus_m40_e06_finish());
	game_save_no_timeout();
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: SNIPERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: SNIPERS: LOW
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_valley_ai_snipers_low_closed =													0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_snipers_low_move::: Manages making the low snipers move
script static void f_valley_ai_snipers_low_move()

	if ( S_valley_ai_snipers_low_closed == 0 ) then
		dprint( "f_valley_ai_snipers_low_move" );
		S_valley_ai_snipers_low_closed = -1;
	
		repeat
			if ( f_valley_ai_snipers_low_closed_set(random_range(1,3 + 1)) ) then 
				sleep_rand_s( 1.0, 4.0 );
			end
		until( ai_living_count(sg_valley_sniper_high) <= 0, 1 );
	end

end

// === f_valley_ai_snipers_low_closed_set::: Sets which gate is closed to the high snipers
script static boolean f_valley_ai_snipers_low_closed_set( short s_val )
local boolean b_return = FALSE;
	dprint( "f_valley_ai_snipers_low_closed_set" );
	
	if ( S_valley_ai_snipers_low_closed != s_val ) then
		S_valley_ai_snipers_low_closed = s_val;
		inspect( s_val );
		b_return = TRUE;
	end

	// return
	b_return;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: SNIPERS: HIGH: FRONT
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_valley_ai_snipers_high_front_closed =													0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_snipers_high_front_move::: Manages making the high snipers move
script static void f_valley_ai_snipers_high_front_move()

	if ( S_valley_ai_snipers_high_front_closed == 0 ) then
		dprint( "f_valley_ai_snipers_high_front_move" );
		S_valley_ai_snipers_high_front_closed = -1;
	
		repeat
			if ( f_valley_ai_snipers_high_front_closed_set(random_range(1,3 + 1)) ) then 
				sleep_rand_s( 1.0, 4.0 );
			end
		until( ai_living_count(sg_valley_sniper_high) <= 0, 1 );
	end

end

// === f_valley_ai_snipers_high_front_closed_set::: Sets which gate is closed to the high snipers
script static boolean f_valley_ai_snipers_high_front_closed_set( short s_val )
local boolean b_return = FALSE;
	dprint( "f_valley_ai_snipers_high_front_closed_set" );
	
	if ( S_valley_ai_snipers_high_front_closed != s_val ) then
		S_valley_ai_snipers_high_front_closed = s_val;
		inspect( s_val );
		b_return = TRUE;
	end

	// return
	b_return;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: SNIPERS: HIGH: BACK
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_valley_ai_snipers_high_back_closed =													0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_snipers_high_back_move::: Manages making the high snipers move
script static void f_valley_ai_snipers_high_back_move()

	if ( S_valley_ai_snipers_high_back_closed == 0 ) then
		dprint( "f_valley_ai_snipers_high_back_move" );
		S_valley_ai_snipers_high_back_closed = -1;
	
		repeat
			if ( f_valley_ai_snipers_high_back_closed_set(random_range(1,3 + 1)) ) then 
				sleep_rand_s( 1.0, 4.0 );
			end
		until( ai_living_count(sg_valley_sniper_high) <= 0, 1 );
	end

end

// === f_valley_ai_snipers_high_back_closed_set::: Sets which gate is closed to the high snipers
script static boolean f_valley_ai_snipers_high_back_closed_set( short s_val )
local boolean b_return = FALSE;
	dprint( "f_valley_ai_snipers_high_back_closed_set" );
	
	if ( S_valley_ai_snipers_high_back_closed != s_val ) then
		S_valley_ai_snipers_high_back_closed = s_val;
		inspect( s_val );
		b_return = TRUE;
	end

	// return
	b_return;

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: PRE
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

//global object OBJ_valley_orders_jackal_00 = 																NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === cs_valley_pre_warn::: COMMAND SCRIPT
script command_script cs_valley_pre_warn()
	dprint( "cs_valley_pre_warn" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

//OBJ_valley_orders_jackal_00 = sq_valley_front_00;

	pup_play_show( "pup_valley_pre_warn" );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// JACKAL VALLEY: AI: ORDERS
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_valley_player_saw_knight_orders =													FALSE;

global object OBJ_valley_orders_jackal_00 = 																NONE;
global object OBJ_valley_orders_jackal_01 = 																NONE;
global object OBJ_valley_orders_jackal_02 = 																NONE;
global object OBJ_valley_orders_jackal_03 = 																NONE;
global object OBJ_valley_orders_jackal_04 = 																NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_valley_ai_orders_create::: Initialize
script dormant f_valley_ai_orders_init()
	dprint( "f_valley_ai_orders_init" );

	// setup trigger
	wake( f_valley_ai_orders_trigger );
	
end

// === f_valley_ai_orders_deinit::: DeInitialize
script dormant f_valley_ai_orders_deinit()
	dprint( "f_valley_ai_orders_deinit" );
	
	// kill functions
	kill_script( f_valley_ai_orders_trigger );
	kill_script( f_valley_ai_orders_action );
	
end

// === f_valley_ai_orders_trigger::: Triggers the orders event
script dormant f_valley_ai_orders_trigger()
	sleep_until( volume_test_players(tv_valley_lower_area) or volume_test_players(tv_valley_knight_event_los) or f_valley_ai_orders_player_watching() or (S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_ORDERS_START), 1 );
	dprint( "f_valley_ai_orders_trigger" );
	
	// setup the knight
	wake( f_valley_ai_orders_action );
	
end

// === f_valley_ai_orders_trigger::: Action that starts the knight giving orders
script dormant f_valley_ai_orders_action()
local long l_blind_thread = 0;
local long l_see_thread = 0;
local long l_pup_id = 		0;

	dprint( "f_valley_ai_orders_action" );
	 
	// setup the knight
	if ( S_valley_ai_objcon < DEF_VALLEY_AI_OBJCON_ESCAPE ) then	// This check makes it so when using the insertion point this event is disabled - TWF

		// minor delay
		sleep_rand_s( 0.25, 0.5 );
	
		// place the knight
		ai_place( sq_for_knight_officer );
		sleep_until( S_valley_ai_objcon >= DEF_VALLEY_AI_OBJCON_ORDERS_START, 1 );
		ai_set_blind( sq_for_knight_officer, TRUE );
		ai_set_blind( sg_valley_infantry_front, TRUE );
		
		// start a thread to cancel blind
		l_blind_thread = thread( f_valley_ai_orders_blind_restore() );
	
		// start a thread to see if the player sees the event
		//l_see_thread = thread( f_valley_ai_orders_watch_player_sees() );
	
		// assign AI to puppeteer
		// - Do not assign jackal objects if hostile
		if ( S_valley_ai_objcon < DEF_VALLEY_AI_OBJCON_ATTACK ) then
			OBJ_valley_orders_jackal_00 = sq_valley_front_00;
			OBJ_valley_orders_jackal_01 = sq_valley_front_01;
			OBJ_valley_orders_jackal_02 = sq_valley_front_02;
			//OBJ_valley_orders_jackal_03 = sq_valley_front_03;
			//OBJ_valley_orders_jackal_04 = sq_valley_front_04;
		end
	
		// play the puppeteer
		sleep_s( 0.5 );
		l_pup_id = pup_play_show( "pup_valley_order_knight" );
		sleep_until( not pup_is_playing(l_pup_id), 1 );
		
		// Make sure sequence is set to being over
		f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_ORDERS_END );
	
		// make sure the knight went back
		//thread( f_valley_ai_orders_knight_phase_back() );
		cs_run_command_script (sq_for_knight_officer, f_valley_ai_orders_knight_phase_back);
	
		// kill temp threads
		kill_thread( l_blind_thread );
		kill_thread( l_see_thread );
	
		// thread the conversation that the event has happened	
		thread( M40_covenant_and_promethean() );

	end
	
	
end

// === f_valley_ai_orders_watch_player_sees::: Watches for the player to see the orders being given
script static void f_valley_ai_orders_watch_player_sees()
	sleep_until( f_valley_ai_orders_player_watching(), 1 );
	dprint( "f_valley_ai_orders_watch_player_sees" );

	B_valley_player_saw_knight_orders = TRUE;

	// thread the conversation that the event has happened	
	thread( M40_covenant_and_promethean() );

end

// === f_valley_ai_orders_blind_restore::: Watches if the player gets too close and turns off blind
script static void f_valley_ai_orders_blind_restore()
local short s_living_cnt = ai_living_count( sg_valley );

	sleep_until( f_ai_sees_enemy(sg_valley) or (ai_living_count(sg_valley) < s_living_cnt) or (objects_distance_to_object(Players(),sq_for_knight_officer) <= 12.5), 1 );
	dprint( "f_valley_ai_orders_blind_restore" );

	// restore sight
	ai_set_blind( sq_for_knight_officer, FALSE );
	ai_set_blind( sg_valley_infantry_front, FALSE );

end

// === f_valley_ai_orders_player_saw::: Checks if the player saw the knight give the orders
script static boolean f_valley_ai_orders_player_saw()
	B_valley_player_saw_knight_orders;
end

// === f_valley_ai_orders_player_saw::: Checks if the player is watching the knight orders event
script static boolean f_valley_ai_orders_player_watching()
	volume_test_players_lookat(tv_valley_knight_event, 25.0, 5.0);
end

// === cs_valley_knight_placement::: COMMAND SCRIPT
script command_script cs_valley_knight_placement()
	dprint( "cs_valley_knight_placement" );

	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );

	object_hide( ai_current_actor, FALSE );
	cs_phase_in();
	
	// set orders to start
	f_valley_ai_objcon_set( DEF_VALLEY_AI_OBJCON_ORDERS_START );

end

// === f_valley_ai_orders_knight_phase_back::: Phases the knight back to his home
script command_script f_valley_ai_orders_knight_phase_back()
static boolean b_phased = FALSE;
	
	if ( not b_phased ) then
		b_phased = TRUE;
		
		// phase knight to the back		
		dprint( "f_valley_ai_orders_knight_phase_back" );
		
		// phase to point
		sleep(15);
		cs_phase_to_point( sq_for_knight_officer, TRUE, pts_val_thes.knight_teleport_back );
		ai_erase(sq_for_knight_officer);
				
	/*	// temprorarily braindead to help clear his ai
		ai_braindead( sq_for_knight_officer, TRUE );
		
		// wait a little bit
		sleep( 3 );
		
		// Unblind him in case he's still blind
		ai_set_blind( sq_for_knight_officer, FALSE );
		
		// force berserk to false in case he triggered it pre-teleport
		ai_berserk( sq_for_knight_officer, FALSE );
		
		// give him his brain back
		ai_braindead( sq_for_knight_officer, FALSE );*/

	end
	
end

script static boolean f_valley_ai_knight_defeated()
	f_ai_is_defeated( sq_for_knight_officer );
end



// =================================================================================================
// =================================================================================================
// EL CITADEL JACKAL VALLEY   IJA
// =================================================================================================
// =================================================================================================

//global boolean b_knight_escape = FALSE;
//global boolean b_jaklead = FALSE;
//global boolean b_sniper_low_front = FALSE;
//global boolean b_sniper_lowrear_front = TRUE;
//global boolean b_sniper_highleft_front = FALSE;
//global boolean b_sniper_cit_front = FALSE;
//global boolean b_sniper_rearfar_front = FALSE;
//global boolean b_sniper_midfar_front = FALSE;
//global boolean b_sniper_frontright_front = FALSE;
//global boolean b_last_resort = FALSE;
//global boolean b_sniper_midhide_front = TRUE;
//global boolean b_cover_grunts = FALSE;
//global boolean b_val_leftwall_forward = FALSE;
//global boolean b_stopthisloop = FALSE;

/*
// === XXX::: xxx
script dormant f_blip_citadel()

	f_blip_flag( citadel_exterior_flag, "recon" );
	
	sleep_until( volume_test_players(tv_citadel_exterior), 1 );
	f_unblip_flag( citadel_exterior_flag );		
	
end
*/


/*
script static void f_set_var_b_leftwall_fallback()
	wake( f_set_clear_wall_loop );
	
	repeat
		sleep_until( volume_test_players(tv_sniperval_sniperwall) or volume_test_players(tv_val_ledge_special), 5 );
			//print("snipers up" );
			b_val_leftwall_forward = TRUE;
		sleep_until( not ( volume_test_players(tv_sniperval_sniperwall) or volume_test_players(tv_val_ledge_special) ),5 );
			sleep_rand_s( 1.0, 4.0 );
			//print("snipers back" );
			b_val_leftwall_forward = FALSE;
	until( b_stopthisloop == TRUE );
end

script dormant f_set_clear_wall_loop()

	sleep_until(			
			ai_spawn_count(sg_valley_sniper_low) > 0 and ai_living_count(sg_valley_sniper_low) <= 0
			,1 );
			
		b_stopthisloop = TRUE;
end
*/

/*

script command_script knight_teleport()
	print ("knight is teleporting" );	
	cs_phase_to_point (pts_val_thes.pk_teleport );
end
*/

/*
script static void xyz()
	
	ai_place( sq_for_knight_officer );
	sleep_s( 1.0 );
	//thespian_performance_activate(thespian_knight_intro );
end



script command_script cs_valley_sniper()
	cs_force_combat_status( 3 );
end
*/

/*
script dormant f_sniperalley_control()

	dprint("valley_control:::active" );

	//wake( f_findplayer_leftside_01 );	
	//wake( f_findplayer_low_front_sniper );	


end
*/

/*
script dormant f_findplayer_leftside_01()


	sleep_until( volume_test_players ( tv_valley_objcon_25 ) or volume_test_players ( tv_valley_objcon_25_a ) or volume_test_players ( tv_valley_objcon_25_b ) , 1 );
	
	//run exposed sniper to the rear
	b_sniper_midhide_front = FALSE;
	
	//bring snipers forward
	b_sniper_rearfar_front = TRUE;
	b_sniper_midfar_front = TRUE;

	b_last_resort = TRUE;
end
*/

/*
script dormant f_jak_low_front_sniper()

	sleep_until( S_valley_ai_objcon > 20 or 
	
		( ai_living_count(sq_valley_sniper_mid_01) <= 0 and 
			ai_living_count(sq_valley_sniper_low_01) <= 0
		)
	
	 ,1 );
				
		//dprint("MOVE UP HIDING SNIPER" );
		b_sniper_low_front = TRUE;
end
*/


/*

script dormant f_findplayer_low_front_sniper()
	
	sleep_until( volume_test_players ( tv_val_low_snipe_forward ) ,1 );
		b_sniper_low_front = TRUE;
	
end

script static void branch_abort()
		sleep(1 );
end
*/


//possible to make ai shoot at player for shore
//cs_shoot <ai> <boolean> <object>
