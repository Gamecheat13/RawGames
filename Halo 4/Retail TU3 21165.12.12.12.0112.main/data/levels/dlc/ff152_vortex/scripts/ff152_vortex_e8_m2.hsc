//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** E8M2: MISSION ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================
// ==========================================================================================================================================================

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_INDEX_SPAWN_LOCS_INITIAL = 										90;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === e8_m2_startup::: Startup
script startup f_e8_m2_startup()

	//Wait for start
	object_destroy_folder( cr_e8_m2_artillery_01_cores );
	object_destroy_folder( cr_e8_m2_artillery_02_cores );
	object_destroy_folder( cr_e8_m2_artillery_03_cores );
	if ( f_spops_mission_startup_wait("e8_m2_start") ) then
		dprint( "f_e8_m2_startup" );
		wake( f_e8_m2_init );
	end
	
end

// === e8_m2_init::: Init
script dormant f_e8_m2_init()
	dprint( "f_e8_m2_init" );

	// disable all auto-blips
	b_wait_for_narrative_hud = TRUE;
	
	// set standard mission init
	f_spops_mission_setup( "e8_m2", 'zs_e8_m2_start', gr_e8_m2_all, fld_e8_m2_spawn_init, DEF_E8M2_INDEX_SPAWN_LOCS_INITIAL );

	// initialize modules
	wake( f_e8_m2_artillery_init );
	wake( f_e8_m2_ai_init );
	wake( f_e8_m2_narrative_init );
	wake( f_e8_m2_audio_init );
	wake( f_e8_m2_rendezvous_init );
	wake( f_e8_m2_objectives_init );
	wake( f_e8_m2_ordnance_init );

	// initialize sub-modules
	wake( f_e8_m2_props_init );

	// setup is complete
	f_spops_mission_setup_complete( TRUE );
	
	// setup start trigger
	wake( f_e8_m2_trigger );

end

// === f_e8_m2_trigger::: Trigger
script dormant f_e8_m2_trigger()
	dprint( "f_e8_m2_trigger" );

	sleep_until( f_spops_mission_start_complete(), 1 );
	sleep_s( 1.0 );
	f_e8_m2_objective( R_e8_m2_objective_lz_first_clear );

	// unsc tell you about the artillery	
	//sleep_until( f_e8_m2_ai_intro_enemy_defeated() or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 1 );
	//if ( f_e8_m2_ai_intro_enemy_defeated() ) then
	//	wake( f_e8_m2_dialog_start_cleared_lz );
	//end

	// unsc tell you about the artillery	
	sleep_until( f_e8_m2_ai_intro_enemy_defeated() or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 5 );
	wake( f_e8_m2_dialog_artillery_pointed_out );
	
	// finale fight
	sleep_until( f_e8_m2_artillery_living_cnt() <= 0, 5 );
	wake( f_e8m2_audio_music_encounter_lz_finale );
	
	// win
	sleep_until( (S_e8_m2_ai_level >= 6) and (f_e8_m2_ai_enemy_cnt() <= 0) and (f_e8_m2_ai_phantom_finale_complete()) and (ai_living_count(gr_e8_m2_enemy_phantoms) <= 0), 1 );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_finale_end', "play_mus_pve_e08m2_encounter_lz_finale_end" );
	f_e8_m2_dialog_complete_win();
	
	sleep_until( b_e8_m2_pelican_outro_done );
	f_spops_mission_end_complete( TRUE );

end


script static void test_e8_m2_ending()

	dprint( "test_e8_m2_ending: S_e8_m2_ai_level" );
	inspect( S_e8_m2_ai_level );
	dprint( "test_e8_m2_ending: f_e8_m2_ai_enemy_cnt()" );
	inspect( f_e8_m2_ai_enemy_cnt() );
	dprint( "test_e8_m2_ending: S_e8_m2_phantom_manage_cnt" );
	inspect( S_e8_m2_phantom_manage_cnt );
	dprint( "test_e8_m2_ending: f_e8_m2_ai_phantom_finale_check()" );
	inspect( f_e8_m2_ai_phantom_finale_check() );
	dprint( "test_e8_m2_ending: R_e8_m2_objective_index" );
	inspect( R_e8_m2_objective_index );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: OBJECTIVES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e8_m2_objective_lz_first_clear = 							0.5;
global real R_e8_m2_objective_destroy_artillery = 					1.0;	// INTEGRATED
global real R_e8_m2_objective_destroy_cores = 							1.5;	// INTEGRATED
global real R_e8_m2_objective_lz_rendezvous = 							2.0;	// INTEGRATED
global real R_e8_m2_objective_lz_finale_clear = 						2.5;	// INTEGRATED
global real R_e8_m2_objective_pelican_defend = 							3.0;	// INTEGRATED
global real R_e8_m2_objective_pelican_rendezvous = 					3.5;	// INTEGRATED

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e8_m2_objective_index = 												0.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_objectives_init::: Init
script dormant f_e8_m2_objectives_init()
	dprint( "f_e8_m2_objectives_init" );

	// setup trigger
	wake( f_e8_m2_objectives_trigger );

end

// === f_e8_m2_objectives_trigger::: Trigger
script dormant f_e8_m2_objectives_trigger()
	dprint( "f_e8_m2_objectives_trigger" );

	// initial clear the lz objective
	f_e8_m2_objectives_wait( R_e8_m2_objective_lz_first_clear, e8_m2_objective_lz_clear, 'play_mus_pve_e08m2_objective_lz_first_clear', "play_mus_pve_e08m2_objective_lz_first_clear" );
	if ( R_e8_m2_objective_index == R_e8_m2_objective_lz_first_clear ) then
		sleep_s( 1 );
		spops_blip_ai( sq_e8m2_lz_enemy_start_01_a, TRUE, "enemy" );
		spops_blip_ai( sq_e8m2_lz_enemy_start_01_b, TRUE, "enemy" );
		spops_blip_ai( sq_e8m2_lz_enemy_start_02_a, TRUE, "enemy" );
		spops_blip_ai( sq_e8m2_lz_enemy_start_02_b, TRUE, "enemy" );
	end

	// wait for objective index and trigger text
	f_e8_m2_objectives_wait( R_e8_m2_objective_destroy_artillery, e8_m2_objective_destroy_artillery, 'play_mus_pve_e08m2_objective_destroy_artillery', "play_mus_pve_e08m2_objective_destroy_artillery" );
	spops_unblip_ai( sq_e8m2_lz_enemy_start_01_a );
	spops_unblip_ai( sq_e8m2_lz_enemy_start_01_b );
	spops_unblip_ai( sq_e8m2_lz_enemy_start_02_a );
	spops_unblip_ai( sq_e8m2_lz_enemy_start_02_b );

	f_e8_m2_objectives_wait( R_e8_m2_objective_destroy_cores, e8_m2_objective_destroy_cores, 'play_mus_pve_e08m2_objective_destroy_cores', "play_mus_pve_e08m2_objective_destroy_cores" );
	
	// complete the artillery objective
	sleep_until( f_e8_m2_artillery_living_cnt() <= 0, 5 );
	cui_hud_set_objective_complete( e8_m2_objective_destroy_artillery );
	spops_audio_music_event( 'play_mus_pve_e08m2_objective_artillery_all_destroyed', "play_mus_pve_e08m2_objective_artillery_all_destroyed" );
	
	f_e8_m2_objectives_wait( R_e8_m2_objective_lz_rendezvous, e8_m2_objective_lz_rendezvous, 'play_mus_pve_e08m2_objective_lz_rendezvous', "play_mus_pve_e08m2_objective_lz_rendezvous" );
	f_e8_m2_objectives_wait( R_e8_m2_objective_lz_finale_clear, e8_m2_objective_lz_clear, 'play_mus_pve_e08m2_objective_lz_finale_clear', "play_mus_pve_e08m2_objective_lz_finale_clear" );

	f_e8_m2_objectives_wait( R_e8_m2_objective_pelican_defend, e8_m2_objective_pelican_defend, 'play_mus_pve_e08m2_objective_pelican_defend', "play_mus_pve_e08m2_objective_pelican_defend" );
	f_e8_m2_objectives_wait( R_e8_m2_objective_pelican_rendezvous, e8_m2_objective_pelican_rendezvous, 'play_mus_pve_e08m2_objective_pelican_rendezvous', "play_mus_pve_e08m2_objective_pelican_rendezvous" );

end
script static void f_e8_m2_objectives_wait( real r_index, string_id sid_objective, sound_event se_music, string str_music )

	sleep_until( R_e8_m2_objective_index >= r_index, 6 );
	
	if ( R_e8_m2_objective_index == r_index ) then
		f_new_objective( sid_objective );
		spops_audio_music_event( se_music, str_music );
		//cui_hud_set_new_objective( sid_objective );
	end
	
end

// === f_e8_m2_objective::: Set/get the objective index
script static void f_e8_m2_objective( real r_val )
	
	if ( r_val > R_e8_m2_objective_index ) then
	
		dprint( "f_e8_m2_objective" );
		R_e8_m2_objective_index = r_val;
		//inspect( R_e8_m2_objective_index );
		
	end
	
end
script static real f_e8_m2_objective()
	R_e8_m2_objective_index;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: PROPS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_props_init::: Init
script dormant f_e8_m2_props_init()
	dprint( "f_e8_m2_props_init" );

	// doors
	object_create_folder_anew( e6m4_cr_doors );
	object_create_folder_anew(vortex_doors);								// ==== TJP - moved doors to west structure to different folder

	// load folders
	object_create_folder_anew( fld_e8_m2_crates_default );
	object_create_folder_anew( fld_e8_m2_crates_damaged );
	object_create_folder_anew( fld_e8_m2_crates_weapon_racks );
	object_create_folder_anew( e9_m1_hunter_doors ); 

/*
	// destroy the cores from the previous mission
	thread( f_e8_m2_props_core_damage(cr_e8m2_core_01_damaged) );
	thread( f_e8_m2_props_core_damage(cr_e8m2_core_02_damaged) );
	thread( f_e8_m2_props_core_damage(cr_e8m2_core_03_damaged) );
	// damage the barriers	
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_01) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_02) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_03) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_04) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_05) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_06) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_07) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_08) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_09) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_10) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_11) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_12) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_13) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_14) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_15) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_16) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_17) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_18) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_19) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_20) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_21) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_22) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_23) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_24) );
	thread( f_e8_m2_props_barrier_damage(cr_e8m2_cov_barrier_25) );
	sleep( 10 );
	garbage_collect_unsafe();
*/	
end
/*
script static void f_e8_m2_props_core_damage( object_name obj_object )

	sleep_until( object_valid(obj_object), 1 );
	dprint( "f_e8_m2_props_core_damage" );
	damage_object( obj_object, "default", 10000.0 );

end
script static void f_e8_m2_props_barrier_damage( object_name obj_object )

	sleep_until( object_valid(obj_object), 1 );
	//dprint( "f_e8_m2_props_barrier_damage" );
	sleep( random_range(1,3) );
	begin_random_count( random_range(1,3) )
		damage_object( obj_object, "right", 10000.0 );
		damage_object( obj_object, "left", 10000.0 );
		damage_object( obj_object, "middle", 10000.0 );
	end

end
*/

/*
// THIS FUNCTION IS FOR SETTING UP THE CRATES AS DESTROYED IN SAPIEN
script static void f_e8_m2_props_explosions() 
	//sleep_s( 5.0 );
	thread( f_e6m4_hilltop_explosion() );
	sleep_s( 1.0 );
	thread( f_e6m4_pit_explosion() );
	sleep_s( 1.0 );
	thread( f_e6m4_fingers_explosion() );
	
	object_create( cr_e8m2_explode_fuel_tank_01 );
	object_create( cr_e8m2_explode_fuel_tank_02 );
	object_create( cr_e8m2_explode_fuel_tank_03 );
	object_create( cr_e8m2_explode_fuel_tank_04 );
	object_create( cr_e8m2_explode_fuel_tank_05 );
	object_create( cr_e8m2_core_01_damaged );
	object_create( cr_e8m2_core_02_damaged );
	object_create( cr_e8m2_core_03_damaged );
	sleep_s( 1.0 );
	damage_object( cr_e8m2_explode_fuel_tank_01, "default", 10000.0 );
	damage_object( cr_e8m2_explode_fuel_tank_02, "default", 10000.0 );
	damage_object( cr_e8m2_explode_fuel_tank_03, "default", 10000.0 );
	damage_object( cr_e8m2_explode_fuel_tank_04, "default", 10000.0 );
	damage_object( cr_e8m2_explode_fuel_tank_05, "default", 10000.0 );
	damage_object( cr_e8m2_core_01_damaged, "default", 10000.0 );
	damage_object( cr_e8m2_core_02_damaged, "default", 10000.0 );
	damage_object( cr_e8m2_core_03_damaged, "default", 10000.0 );

end
*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ORDNANCE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static real R_e8_m2_ornance_distance_player_min = 												1.0;
static real R_e8_m2_ornance_distance_ai_min = 														1.0;
static short S_e8_m2_ornance_active_cnt = 																0;
static real R_e8_m2_ornance_marker_time = 																60.0;
static boolean B_e8_m2_ornance_dropping = 																FALSE;
static short S_e8_m2_ornance_cnt = 																				0;
static short S_e8_m2_ornance_basic_cnt = 																	0;
static short S_e8_m2_ornance_grenade_cnt = 																0;
static short S_e8_m2_ornance_heavy_cnt = 																	0;
static short S_e8_m2_ornance_armor_cnt = 																	0;
static short S_e8_m2_ornance_level_min = 																	1;
static short S_e8_m2_ornance_level_max = 																	6;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === f_e8_m2_ordnance_init::: Init
script dormant f_e8_m2_ordnance_init()
	dprint( "f_e8_m2_ordnance_init" );
	
	// set the drop pod object
	ordnance_set_droppod_object( 'levels\dlc\ff152_vortex\crates\spops_ordnance_e8m2\unsc_weapons_pod_e8m2.scenery', 'objects\weapons\pistol\storm_target_laser\projectiles\marker_round_droppod.effect' );
	
end

// === f_e8_m2_ordnance_drop::: Manages dropping ordnance
script static void f_e8_m2_ordnance_drop( short s_level, short s_area )
local long l_thread = 0;

	// wait for no other areas to be dropping
	sleep_until( not B_e8_m2_ornance_dropping, 10 );
	B_e8_m2_ornance_dropping = TRUE;
	S_e8_m2_ornance_active_cnt = S_e8_m2_ornance_active_cnt + 1;
	dprint( "f_e8_m2_ordnance_drop: START" );
	//inspect( s_level );
	
	// make sure players are alive
	sleep_until( spops_player_living_cnt() > 0, 1 );
	l_thread = thread( f_e8_m2_dialog_ordnance(s_level) );
	
	// set the counts
	dprint( "f_e8_m2_ordnance_drop: COUNTS" );
	if ( s_level == 1 ) then
		S_e8_m2_ornance_basic_cnt = bound_s( game_coop_player_count(), 2, 3 );
		S_e8_m2_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e8_m2_ornance_heavy_cnt = bound_s( game_coop_player_count(), 2, 3 );
		S_e8_m2_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 1 );
	end
	if ( s_level == 2 ) then
		S_e8_m2_ornance_basic_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e8_m2_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e8_m2_ornance_heavy_cnt = bound_s( game_coop_player_count(), 1, 3 );
		S_e8_m2_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 1 );
	end
	if ( s_level == 3 ) then
		S_e8_m2_ornance_basic_cnt = bound_s( game_coop_player_count(), 1, 3 );
		S_e8_m2_ornance_grenade_cnt = bound_s( game_coop_player_count(), 1, 2 );
		S_e8_m2_ornance_heavy_cnt = bound_s( game_coop_player_count(), 2, 4 );
		S_e8_m2_ornance_armor_cnt = bound_s( game_coop_player_count(), 1, 1 );
		
		if ( cr_e8m2_rvb->interacted() ) then
			S_e8_m2_ornance_heavy_cnt = S_e8_m2_ornance_heavy_cnt + 1;
		end
		
	end
	S_e8_m2_ornance_cnt = S_e8_m2_ornance_basic_cnt + S_e8_m2_ornance_grenade_cnt + S_e8_m2_ornance_heavy_cnt + S_e8_m2_ornance_armor_cnt;
	//inspect( S_e8_m2_ornance_cnt );
	
	// start dropping
	dprint( "f_e8_m2_ordnance_drop: DROPPING" );
	//inspect( s_area );
	
	// wait for dialog to finish
	sleep( 1 );
	sleep_until( not isthreadvalid(l_thread), 1 );
	
	// setup marker blips
	if ( S_e8_m2_ornance_active_cnt == 1 ) then
		ordnance_show_nav_markers( TRUE );
	end
	
	// lz
	if ( s_area == 0 ) then
	
		begin_random
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_01 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_02 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_03 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_04 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_05 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_06 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_07 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_08 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_09 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_10 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_11 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_12 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_13 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_14 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_15 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_16 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_lz_17 );
		end
		
	end

	// artillery
	if ( s_area == 1 ) then
	
		begin_random
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_01 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_02 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_03 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_04 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_05 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_06 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_07 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_08 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_09 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_10 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_11 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_12 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_13 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_14 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_15 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a01_16 );
		end
		
	end
	if ( s_area == 2 ) then
	
		begin_random
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_01 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_02 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_03 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_04 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_05 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_06 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_07 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_08 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_09 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_10 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_11 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_12 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_13 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_14 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a02_15 );
		end
		
	end
	if ( s_area == 3 ) then
	
		begin_random
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_01 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_02 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_03 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_04 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_05 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_06 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_07 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_08 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_09 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_10 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_11 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_12 );
			sys_e8_m2_ordnance_drop_send( s_level, flg_e8m2_ordnance_a03_13 );
		end
		
	end
	B_e8_m2_ornance_dropping = FALSE;
	
	dprint( "f_e8_m2_ordnance_drop: POST" );
	if ( s_area != 0 ) then
		sleep_s( R_e8_m2_ornance_marker_time );
	end
	if ( s_area == 0 ) then
		sleep_until( B_e8_m2_ai_mop_up or f_e8_m2_ai_phantom_finale_on_kamikaze_run(), 1 );
	end

	dprint( "f_e8_m2_ordnance_drop: SHUTDOWN" );
	S_e8_m2_ornance_active_cnt = S_e8_m2_ornance_active_cnt - 1;
	if ( S_e8_m2_ornance_active_cnt == 0 ) then
		ordnance_show_nav_markers( FALSE );
	end

end

script static void sys_e8_m2_ordnance_drop_send( short s_level, cutscene_flag flg_loc )
local string_id sid_drop = NONE;

	if ( (S_e8_m2_ornance_cnt > 0) and ((spops_player_living_cnt() <= 0) or (objects_distance_to_flag(Players(),flg_loc) > R_e8_m2_ornance_distance_player_min)) and ((objects_distance_to_flag(ai_actors(ai_ff_all),flg_loc) > R_e8_m2_ornance_distance_ai_min) or (ai_living_count(ai_ff_all) <= 0)) ) then

		// get an ordnance to drop
		begin_random
	
			begin
				if ( (sid_drop == NONE) and (S_e8_m2_ornance_heavy_cnt > 0) ) then
					sid_drop = sys_e8_m2_ordnance_drop_heavy( s_level );
					if ( sid_drop != NONE ) then
						S_e8_m2_ornance_heavy_cnt = S_e8_m2_ornance_heavy_cnt - 1;
					end
				end
			end
			begin
				if ( (sid_drop == NONE) and (S_e8_m2_ornance_grenade_cnt > 0) ) then
					sid_drop = sys_e8_m2_ordnance_drop_grenade( s_level );
					if ( sid_drop != NONE ) then
						S_e8_m2_ornance_grenade_cnt = S_e8_m2_ornance_grenade_cnt - 1;
					end
				end
			end
			begin
				if ( (sid_drop == NONE) and (S_e8_m2_ornance_basic_cnt > 0) ) then
					sid_drop = sys_e8_m2_ordnance_drop_basic( s_level );
					if ( sid_drop != NONE ) then
						S_e8_m2_ornance_basic_cnt = S_e8_m2_ornance_basic_cnt - 1;
					end
				end
			end
			begin
				if ( (sid_drop == NONE) and (S_e8_m2_ornance_armor_cnt > 0) ) then
					sid_drop = sys_e8_m2_ordnance_drop_armor( s_level );
					if ( sid_drop != NONE ) then
						S_e8_m2_ornance_armor_cnt = S_e8_m2_ornance_armor_cnt - 1;
					end
				end
			end
	
		end

		// do the drop	
		if ( sid_drop != NONE ) then
			ordnance_drop( flg_loc, sid_drop );
			sleep_s( 0.25 );
			S_e8_m2_ornance_cnt = S_e8_m2_ornance_cnt - 1;
		end
	
	end

end

script static string_id sys_e8_m2_ordnance_drop_basic( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	begin_random
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_assault_rifle', sid_drop, sid_drop_last );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_battle_rifle', sid_drop, sid_drop_last );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_dmr', sid_drop, sid_drop_last );
	end

	// store last drop
	sid_drop_last = sid_drop;

	// return
	sid_drop;
end

script static string_id sys_e8_m2_ordnance_drop_grenade( short s_level )
	// return
	'grenade_doublefrag';
end

script static string_id sys_e8_m2_ordnance_drop_heavy( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	begin_random
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_sticky_grenade_launcher', sid_drop, sid_drop_last, s_level, 3, 3, TRUE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_lmg', sid_drop, sid_drop_last );
	end

	// store last drop
	if ( s_level >= 3 ) then
		sid_drop_last = sid_drop;
	end

	// return
	sid_drop;
end

script static string_id sys_e8_m2_ordnance_drop_armor( short s_level )
local string_id sid_drop = NONE;
static string_id sid_drop_last = NONE;

	begin_random
	
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_active_shield', sid_drop, sid_drop_last, s_level, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, TRUE, spops_players_all_have_equipment('objects\equipment\storm_active_shield\storm_active_shield_pve.equipment'), FALSE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_auto_turret', sid_drop, sid_drop_last, s_level, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, TRUE, spops_player_has_equipment('objects\equipment\storm_auto_turret\storm_auto_turret_pve.equipment'), FALSE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_hologram', sid_drop, sid_drop_last, s_level, 1, 2, TRUE, (f_e8_m2_artillery_living_cnt() > 1) and spops_players_all_have_equipment('objects\equipment\storm_hologram\storm_hologram.equipment'), FALSE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_jet_pack', sid_drop, sid_drop_last, s_level, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, TRUE, (f_e8_m2_artillery_living_cnt() > 1) and spops_players_all_have_equipment('objects\equipment\storm_jet_pack\storm_jet_pack_pve.equipment'), FALSE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_regen_field', sid_drop, sid_drop_last, s_level, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, TRUE, spops_player_has_equipment('objects\equipment\storm_regen_field\storm_regen_field.equipment'), FALSE );
		sid_drop = sys_e8_m2_ordnance_drop_obj_check( 'storm_thruster_pack', sid_drop, sid_drop_last, s_level, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, TRUE, spops_players_all_have_equipment('objects\equipment\storm_thruster_pack\storm_thruster_pack_pve.equipment'), FALSE );
		
	end

	// store last drop
	sid_drop_last = sid_drop;

	// return
	sid_drop;
end

script static string_id sys_e8_m2_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last, short s_level, short s_level_min, short s_level_max, boolean b_level_test, boolean b_condition, boolean b_condition_test )

	if ( (sid_current == NONE) and (sid_object != sid_last) and (b_condition == b_condition_test) and (((s_level_min <= s_level) and (s_level <= s_level_max)) == b_level_test) ) then
		sid_current = sid_object;
	end
	
	sid_current;
end
script static string_id sys_e8_m2_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last, short s_level, short s_level_min, short s_level_max, boolean b_level_test )
	sys_e8_m2_ordnance_drop_obj_check( sid_object, sid_current, sid_last, s_level, s_level_min, s_level_max, b_level_test, TRUE, TRUE );
end
script static string_id sys_e8_m2_ordnance_drop_obj_check( string_id sid_object, string_id sid_current, string_id sid_last )
	sys_e8_m2_ordnance_drop_obj_check( sid_object, sid_current, sid_last, -1, S_e8_m2_ornance_level_min, S_e8_m2_ornance_level_max, FALSE, TRUE, TRUE );
end
