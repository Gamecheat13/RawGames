//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e8m2_artillery_explosion_warning_range = 								10.0;
static short S_e8m2_artillery_cnt = 																	0;

global object obj_e8m2_artillery_01 = 																NONE;
global object obj_e8m2_artillery_01_core_01 = 												NONE;
global object obj_e8m2_artillery_01_core_03 = 												NONE;
global object obj_e8m2_artillery_02 = 																NONE;
global object obj_e8m2_artillery_02_core_01 = 												NONE;
global object obj_e8m2_artillery_02_core_03 = 												NONE;
global object obj_e8m2_artillery_03 = 																NONE;
global object obj_e8m2_artillery_03_core_01 = 												NONE;
global object obj_e8m2_artillery_03_core_02 = 												NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_init::: Init
script dormant f_e8_m2_artillery_init()
	//dprint( "f_e8_m2_artillery_init" );

	// place artillery
	ai_place( gr_e8_m2_enemy_artillery );

	// set default allegiances
	//ai_allegiance_break( player, DEF_E8_M2_TEAM_ARTILLERY );
	//ai_allegiance_break( DEF_E8_M2_TEAM_ARTILLERY, player );
	//ai_allegiance( covenant, DEF_E8_M2_TEAM_ARTILLERY );
	//ai_allegiance( DEF_E8_M2_TEAM_ARTILLERY, covenant );
	
	// setup triggers
	wake( f_e8_m2_artillery_trigger );
	thread(f_e8_m2_watch_artillery_count());

end

// === f_e8_m2_artillery_trigger::: Trigger
script dormant f_e8_m2_artillery_trigger()
	//dprint( "f_e8_m2_artillery_trigger" );

	// infinity msg about artillery
	sleep_until( ((not volume_test_players_all(tv_e8m2_start_area)) and (spops_player_living_cnt() > 0)) or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN), 1 );
	//dprint( "f_e8_m2_artillery_trigger: WARN" );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN );	
	//wake( f_e8_m2_dialog_artillery_infinity_info );

	sleep_until( S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, 1 );
	//dprint( "f_e8_m2_artillery_trigger: CORE ATTACK" );
	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_01_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_01_shell_03->shell_outer_object() );

	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_02_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_02_shell_03->shell_outer_object() );

	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_03_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_target( cr_e8_m2_artillery_03_shell_02->shell_outer_object() );

	// end
	sleep_until( f_e8_m2_artillery_living_cnt() == 0, 1 );
	//dprint( "f_e8_m2_artillery_trigger: COMPLETE" );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_COMPLETE );

end
global short gE8M2_ArtyLivingCount = 0;

script static void f_e8_m2_watch_artillery_count()
	repeat
		gE8M2_ArtyLivingCount = ai_living_count( gr_e8_m2_enemy_artillery );
	until(false,10);
end
// === f_e8_m2_artillery_living_cnt::: Returns the count of living  artillery
script static short f_e8_m2_artillery_living_cnt()
	gE8M2_ArtyLivingCount;
end

// === f_e8_m2_artillery_living_ratio::: Returns the ratio of living artillery
script static real f_e8_m2_artillery_living_ratio()
	real( ai_living_count(gr_e8_m2_enemy_artillery) ) / real( S_e8m2_artillery_cnt );
end

// === f_e8_m2_artillery_killed_cnt::: Returns the count of killed artillery
script static short f_e8_m2_artillery_killed_cnt()
	S_e8m2_artillery_cnt - ai_living_count( gr_e8_m2_enemy_artillery );
end

// === f_e8_m2_artillery_index_get::: Returns the object for an artillery index
script static object f_e8_m2_artillery_index_get( short s_index )

	if ( s_index == 1 ) then
		obj_e8m2_artillery_01;
	elseif ( s_index == 2 ) then
		obj_e8m2_artillery_02;
	elseif ( s_index == 3 ) then
		obj_e8m2_artillery_03;
	else
		NONE;
	end
	
end

// === f_e8_m2_artillery_nearest_index::: Returns the artillery index nearest an object
script static short f_e8_m2_artillery_nearest_index( object obj_test )
local short s_index = 0;

	if ( object_get_health(obj_test) > 0.0 ) then
		local real r_distance = 0.0;
		local real r_distance_temp = 0.0;

		// 1
		if ( object_get_health(obj_e8m2_artillery_01) > 0.0 ) then
			r_distance_temp = objects_distance_to_object( obj_test, obj_e8m2_artillery_01 );
			if ( (r_distance_temp > 0.0) and ((s_index == 0) or (r_distance_temp < r_distance)) ) then
				s_index = 1;
				r_distance = r_distance_temp;
			end
		end
	
		// 2
		if ( object_get_health(obj_e8m2_artillery_02) > 0.0 ) then
			r_distance_temp = objects_distance_to_object( obj_test, obj_e8m2_artillery_02 );
			if ( (r_distance_temp > 0.0) and ((s_index == 0) or (r_distance_temp < r_distance)) ) then
				s_index = 2;
				r_distance = r_distance_temp;
			end
		end
	
		// 3
		if ( object_get_health(obj_e8m2_artillery_03) > 0.0 ) then
			r_distance_temp = objects_distance_to_object( obj_test, obj_e8m2_artillery_03 );
			if ( (r_distance_temp > 0.0) and ((s_index == 0) or (r_distance_temp < r_distance)) ) then
				s_index = 3;
				r_distance = r_distance_temp;
			end
		end

	end

	// return
	s_index;
	
end

// === f_e8_m2_artillery_recent_damage::: Returns the recent damage of an artillery
script static real f_e8_m2_artillery_recent_damage( object obj_artillery, object obj_core_01, object obj_core_02 )
local real r_damage = object_recent_damage( obj_artillery );
	
	// add cores
	r_damage = r_damage + object_recent_damage( obj_core_01 );
	r_damage = r_damage + object_recent_damage( obj_core_02 );
	
	// return
	r_damage;
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: REINFORCEMENTS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global real DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE = 						-999.999;
global real DEF_E8M2_ARTILLERY_REINFORCEMENT_DANGER_DISTANCE = 				25.0;

static real R_e8m2_artillery_01_reinforcement_weight = 								DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;
static real R_e8m2_artillery_02_reinforcement_weight = 								DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;
static real R_e8m2_artillery_03_reinforcement_weight = 								DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void sys_e8_m2_artillery_reinforcement_weight_watch()
	repeat
		R_e8m2_artillery_01_reinforcement_weight = sys_e8_m2_artillery_reinforcement_weight( obj_e8m2_artillery_01, obj_e8m2_artillery_01_core_01, obj_e8m2_artillery_01_core_03, objectives_e8m2_artillery_01.unsc_gate, objectives_e8m2_artillery_01.enemy_gate );
		sleep(1);
		R_e8m2_artillery_02_reinforcement_weight = sys_e8_m2_artillery_reinforcement_weight( obj_e8m2_artillery_02, obj_e8m2_artillery_02_core_01, obj_e8m2_artillery_02_core_03, objectives_e8m2_artillery_02.unsc_gate, objectives_e8m2_artillery_02.enemy_gate );
		sleep(1);
		R_e8m2_artillery_03_reinforcement_weight = sys_e8_m2_artillery_reinforcement_weight( obj_e8m2_artillery_03, obj_e8m2_artillery_03_core_01, obj_e8m2_artillery_03_core_02, objectives_e8m2_artillery_03.unsc_gate, objectives_e8m2_artillery_03.enemy_gate );
	until(false,10);
end

script static real f_e8_m2_artillery_01_reinforcement_weight()
	R_e8m2_artillery_01_reinforcement_weight;
end
script static real f_e8_m2_artillery_02_reinforcement_weight()
	R_e8m2_artillery_02_reinforcement_weight;
end
script static real f_e8_m2_artillery_03_reinforcement_weight()
	R_e8m2_artillery_03_reinforcement_weight;
end

script static real sys_e8_m2_artillery_reinforcement_weight( object obj_artillery, object obj_core_01, object obj_core_02, ai ai_ally, ai ai_enemy )

	if ( object_get_health(obj_artillery) > 0.0 ) then
		spops_ai_morale_weight( ai_ally, ai_enemy ) + 
			players_in_object_range( obj_artillery, DEF_E8M2_ARTILLERY_REINFORCEMENT_DANGER_DISTANCE ) + 
			f_e8_m2_artillery_recent_damage( obj_artillery, obj_core_01, obj_core_02 ) + 
			( -1.0 * objects_distance_to_object(Players(), obj_artillery) ) + 
			ai_combat_status( ai_enemy );
	else
		DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;
	end
	
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 01 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_01_living::: Checks if the artillery is alive
script static boolean f_e8_m2_artillery_01_living()
	object_get_health( obj_e8m2_artillery_01 ) > 0.0;
end

script command_script cs_e8_m2_artillery_01()
local long l_thread = 0;
	//dprint( "cs_e8_m2_artillery_01" );

	// load cores
	object_create_anew( cr_e8_m2_artillery_01_shell_01 );
	object_create_anew( cr_e8_m2_artillery_01_shell_03 );
	sleep( 1 );
	sleep_until( object_valid(cr_e8_m2_artillery_01_shell_01) and object_valid(cr_e8_m2_artillery_01_shell_03), 1 );
	
	// store artillery objects
	obj_e8m2_artillery_01 = ai_vehicle_get( ai_current_actor );
	obj_e8m2_artillery_01_core_01 = cr_e8_m2_artillery_01_shell_01->core_object();
	obj_e8m2_artillery_01_core_03 = cr_e8_m2_artillery_01_shell_03->core_object();	
		
	// targetting settings
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_01_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_01_shell_03->shell_outer_object() );
	
	// start managers	
	l_thread = thread( f_e8_m2_artillery_manage(1, ai_current_actor, obj_e8m2_artillery_01, obj_e8m2_artillery_01_core_01, obj_e8m2_artillery_01_core_03, fld_e8_m2_spawn_artillery_01) );

	// setup ai spawn manager
	thread( 
		f_e8m2_ai_place_artillery_locs( 
			obj_e8m2_artillery_01, 
			cr_e8_m2_artillery_01_shell_01->shell_outer_object(), 
			cr_e8_m2_artillery_01_shell_03->shell_outer_object(), 
			'objectives_e8m2_artillery_01', 
			flg_e8m2_artillery_01_spawn_loc, 
			flg_e8m2_artillery_01_core_01_spawn_loc, 
			flg_e8m2_artillery_01_core_01_watcher_loc, 
			flg_e8m2_artillery_01_core_03_spawn_loc, 
			flg_e8m2_artillery_01_core_03_watcher_loc
		)
	);

	// setup blip manager
	thread( f_e8_m2_artillery_blip(1, obj_e8m2_artillery_01, cr_e8_m2_artillery_01_shell_01->shell_outer_object(), cr_e8_m2_artillery_01_shell_03->shell_outer_object()) );
	
	// music
	f_e8m2_audio_music_artillery_encounter( obj_e8m2_artillery_01, objectives_e8m2_artillery_01.enemy_gate, objectives_e8m2_artillery_01.enemy_artillery_main_combat_gate, objectives_e8m2_artillery_01.enemy_core_01_combat_gate, objectives_e8m2_artillery_01.enemy_core_03_combat_gate, 'play_mus_pve_e08m2_encounter_artillery_01_start', "play_mus_pve_e08m2_encounter_artillery_01_start", 'play_mus_pve_e08m2_encounter_artillery_01_idle', "play_mus_pve_e08m2_encounter_artillery_01_idle", 'play_mus_pve_e08m2_encounter_artillery_01_end', "play_mus_pve_e08m2_encounter_artillery_01_end" );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 02 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_02_living::: Checks if the artillery is alive
script static boolean f_e8_m2_artillery_02_living()
	object_get_health( obj_e8m2_artillery_02 ) > 0.0;
end

script command_script cs_e8_m2_artillery_02()
local long l_thread = 0;
	//dprint( "cs_e8_m2_artillery_02" );

	// load cores
	object_create_anew( cr_e8_m2_artillery_02_shell_01 );
	object_create_anew( cr_e8_m2_artillery_02_shell_03 );
	sleep( 1 );
	sleep_until( object_valid(cr_e8_m2_artillery_02_shell_01) and object_valid(cr_e8_m2_artillery_02_shell_03), 1 );
	
	// store artillery objects
	obj_e8m2_artillery_02 = ai_vehicle_get( ai_current_actor );
	obj_e8m2_artillery_02_core_01 = cr_e8_m2_artillery_02_shell_01->core_object();
	obj_e8m2_artillery_02_core_03 = cr_e8_m2_artillery_02_shell_03->core_object();	
		
	// targetting settings
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_02_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_02_shell_03->shell_outer_object() );

	// start managers	
	l_thread = thread( f_e8_m2_artillery_manage(2, ai_current_actor, obj_e8m2_artillery_02, obj_e8m2_artillery_02_core_01, obj_e8m2_artillery_02_core_03, fld_e8_m2_spawn_artillery_02) );

	// setup ai spawn manager
	thread(
		f_e8m2_ai_place_artillery_locs( 
			obj_e8m2_artillery_02, 
			cr_e8_m2_artillery_02_shell_01->shell_outer_object(), 
			cr_e8_m2_artillery_02_shell_03->shell_outer_object(), 
			'objectives_e8m2_artillery_02', 
			flg_e8m2_artillery_02_spawn_loc, 
			flg_e8m2_artillery_02_core_01_spawn_loc, 
			flg_e8m2_artillery_02_core_01_watcher_loc, 
			flg_e8m2_artillery_02_core_03_spawn_loc, 
			flg_e8m2_artillery_02_core_03_watcher_loc
		)
	);

	// setup blip manager
	thread( f_e8_m2_artillery_blip(2, obj_e8m2_artillery_02, cr_e8_m2_artillery_02_shell_01->shell_outer_object(), cr_e8_m2_artillery_02_shell_03->shell_outer_object()) );
	
	// music
	f_e8m2_audio_music_artillery_encounter( obj_e8m2_artillery_02, objectives_e8m2_artillery_02.enemy_gate, objectives_e8m2_artillery_02.enemy_artillery_main_combat_gate, objectives_e8m2_artillery_02.enemy_core_01_combat_gate, objectives_e8m2_artillery_02.enemy_core_03_combat_gate, 'play_mus_pve_e08m2_encounter_artillery_02_start', "play_mus_pve_e08m2_encounter_artillery_02_start", 'play_mus_pve_e08m2_encounter_artillery_02_idle', "play_mus_pve_e08m2_encounter_artillery_02_idle", 'play_mus_pve_e08m2_encounter_artillery_02_end', "play_mus_pve_e08m2_encounter_artillery_02_end" );

end
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: 03 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_03_living::: Checks if the artillery is alive
script static boolean f_e8_m2_artillery_03_living()
	object_get_health( obj_e8m2_artillery_03 ) > 0.0;
end

script command_script cs_e8_m2_artillery_03()
local long l_thread = 0;
	//dprint( "cs_e8_m2_artillery_03" );

	// load cores
	object_create_anew( cr_e8_m2_artillery_03_shell_01 );
	object_create_anew( cr_e8_m2_artillery_03_shell_02 );
	sleep( 1 );
	sleep_until( object_valid(cr_e8_m2_artillery_03_shell_01) and object_valid(cr_e8_m2_artillery_03_shell_02), 1 );
	
	// store artillery objects
	obj_e8m2_artillery_03 = ai_vehicle_get( ai_current_actor );
	obj_e8m2_artillery_03_core_01 = cr_e8_m2_artillery_03_shell_01->core_object();
	obj_e8m2_artillery_03_core_02 = cr_e8_m2_artillery_03_shell_02->core_object();
		
	// targetting settings
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_03_shell_01->shell_outer_object() );
	f_e8_m2_artillery_core_shell_init( cr_e8_m2_artillery_03_shell_02->shell_outer_object() );

	// start managers	
	l_thread = thread( f_e8_m2_artillery_manage(3, ai_current_actor, obj_e8m2_artillery_03, obj_e8m2_artillery_03_core_01, obj_e8m2_artillery_03_core_02, fld_e8_m2_spawn_artillery_03) );

	// setup ai spawn manager
	thread(
		f_e8m2_ai_place_artillery_locs( 
			obj_e8m2_artillery_03, 
			cr_e8_m2_artillery_03_shell_01->shell_outer_object(), 
			cr_e8_m2_artillery_03_shell_02->shell_outer_object(), 
			'objectives_e8m2_artillery_03', 
			flg_e8m2_artillery_03_spawn_loc, 
			flg_e8m2_artillery_03_core_01_spawn_loc, 
			flg_e8m2_artillery_03_core_01_watcher_loc, 
			flg_e8m2_artillery_03_core_02_spawn_loc, 
			flg_e8m2_artillery_03_core_02_watcher_loc
		)
	);

	// setup blip manager
	thread( f_e8_m2_artillery_blip(3, obj_e8m2_artillery_03, cr_e8_m2_artillery_03_shell_01->shell_outer_object(), cr_e8_m2_artillery_03_shell_02->shell_outer_object()) );
	
	// music
	f_e8m2_audio_music_artillery_encounter( obj_e8m2_artillery_03, objectives_e8m2_artillery_03.enemy_gate, objectives_e8m2_artillery_03.enemy_artillery_main_combat_gate, objectives_e8m2_artillery_03.enemy_core_01_combat_gate, objectives_e8m2_artillery_03.enemy_core_02_combat_gate, 'play_mus_pve_e08m2_encounter_artillery_03_start', "play_mus_pve_e08m2_encounter_artillery_03_start", 'play_mus_pve_e08m2_encounter_artillery_03_idle', "play_mus_pve_e08m2_encounter_artillery_03_idle", 'play_mus_pve_e08m2_encounter_artillery_03_end', "play_mus_pve_e08m2_encounter_artillery_03_end" );
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: STABILITY: STATE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE = 						0;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED = 			1;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS = 				2;
global short DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED = 				3;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e8m2_artillery_01_stability_state =									DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
static short S_e8m2_artillery_02_stability_state =									DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
static short S_e8m2_artillery_03_stability_state =									DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script startup f_e8_m2_artillery_01_state_watch()
local long l_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
	sleep_until( object_get_health(obj_e8m2_artillery_01) > 0.0, 1 );
	repeat
		S_e8m2_artillery_01_stability_state = sys_e8_m2_artillery_unit_state( obj_e8m2_artillery_01, obj_e8m2_artillery_01_core_01, obj_e8m2_artillery_01_core_03 );
		l_state = f_e8_m2_artillery_state_changed( l_state, S_e8m2_artillery_01_stability_state );
	until( S_e8m2_artillery_01_stability_state == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED, 1 );
end

script startup f_e8_m2_artillery_02_state_watch()
local long l_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
	sleep_until( object_get_health(obj_e8m2_artillery_02) > 0.0, 1 );
	repeat
		S_e8m2_artillery_02_stability_state = sys_e8_m2_artillery_unit_state( obj_e8m2_artillery_02, obj_e8m2_artillery_02_core_01, obj_e8m2_artillery_02_core_03 );
		l_state = f_e8_m2_artillery_state_changed( l_state, S_e8m2_artillery_02_stability_state );
	until( S_e8m2_artillery_02_stability_state == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED, 1 );
end

script startup f_e8_m2_artillery_03_state_watch()
local long l_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
	sleep_until( object_get_health(obj_e8m2_artillery_03) > 0.0, 1 );
	repeat
		S_e8m2_artillery_03_stability_state = sys_e8_m2_artillery_unit_state( obj_e8m2_artillery_03, obj_e8m2_artillery_03_core_01, obj_e8m2_artillery_03_core_02 );
		l_state = f_e8_m2_artillery_state_changed( l_state, S_e8m2_artillery_03_stability_state );
	until( S_e8m2_artillery_03_stability_state == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED, 1 );
end

script static short f_e8_m2_artillery_state_changed( short s_state_local, short s_state_global )

	if ( s_state_global > s_state_local ) then
		s_state_local = s_state_global;

		if ( s_state_local == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_state_destabilized', "play_mus_pve_e08m2_artillery_state_destabilized" );
		end
		if ( s_state_local == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_state_dangerous', "play_mus_pve_e08m2_artillery_state_dangerous" );
		end
		if ( s_state_local == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_state_destroyed', "play_mus_pve_e08m2_artillery_state_destroyed" );
		end

	end

	// return
	s_state_local;

end

script static short f_e8_m2_artillery_index_state( short s_index )
local short s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED;

	if ( s_index == 1 ) then
		s_state = S_e8m2_artillery_01_stability_state;
	end
	if 	( s_index == 2 ) then 
		s_state = S_e8m2_artillery_02_stability_state;
	end
	if ( s_index == 3 ) then 
		s_state = S_e8m2_artillery_03_stability_state;
	end

	// return
	s_state;
end

script static short f_e8_m2_artillery_object_state( object obj_artillery )
local short s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED;

	if ( obj_artillery == obj_e8m2_artillery_01 ) then
		s_state = S_e8m2_artillery_01_stability_state;
	end
	if ( obj_artillery == obj_e8m2_artillery_02 ) then
		s_state = S_e8m2_artillery_02_stability_state;
	end
	if ( obj_artillery == obj_e8m2_artillery_03 ) then
		s_state = S_e8m2_artillery_03_stability_state;
	end

	// return
	s_state;
end

// === sys_e8_m2_artillery_unit_state::: Returns the current stability state 
script static short sys_e8_m2_artillery_unit_state( object obj_artillery, object obj_core_01, object obj_core_02 )
local short s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED;

	if ( object_get_health(obj_artillery) > 0.0 ) then
		if ( (object_get_health(obj_core_01) > 0.0) and (object_get_health(obj_core_02) > 0.0) ) then
			s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE;
		elseif ( (object_get_health(obj_core_01) <= 0.0) and (object_get_health(obj_core_02) <= 0.0) ) then
			s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS;
		end
	else
		s_state = DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED;
	end
	
	// return
	s_state;
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: MANAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global real R_e8m2_artillery_blip_range = 							25.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_manage::: Manages the artillery logic
script static void f_e8_m2_artillery_manage( short s_index, ai ai_artillery, object obj_artillery, object obj_core_01, object obj_core_02, folder fld_spawn_locs )
local long l_damage_thread = 0;
	//dprint( "f_e8_m2_artillery_manage" );

	// targetting settings
	//ai_object_set_team( obj_artillery, DEF_E8_M2_TEAM_ARTILLERY );
	//ai_object_enable_targeting_from_vehicle( obj_artillery, TRUE );
	ai_object_set_targeting_bias( obj_artillery, 0.75 );

	// increment artillery cnt
	S_e8m2_artillery_cnt = S_e8m2_artillery_cnt + 1;

	// manage cores
	thread( f_e8_m2_artillery_core_manage(s_index, obj_artillery, obj_core_01) );
	thread( f_e8_m2_artillery_core_manage(s_index, obj_artillery, obj_core_02) );

	// wait for mission start
	sleep_until( f_spops_mission_start_complete(), 1 );

	// setup spawn location watchers
	thread( f_e8_m2_artillery_manage_spawn_locs(s_index, fld_spawn_locs, obj_artillery) );

	// setup attack manager	
	thread( f_e8_m2_artillery_manage_attack(s_index, ai_artillery, obj_artillery, obj_core_01, obj_core_02) );

	// damage watch
	l_damage_thread = thread( f_e8_m2_artillery_state_damage_watch(DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH, obj_artillery, DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_RECENT_CURRENT, DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_RECENT_TOTAL, DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_HEALTH, DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_SHIELD) );

	// near
	sleep_until( (f_e8_m2_artillery_index_state(s_index) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or ((objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artillery_blip_range) and (spops_player_living_cnt() > 0)), 1 );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_NEAR );
	
	// too tough
	sleep_until( (f_e8_m2_artillery_index_state(s_index) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH), 1 );
	ai_object_set_targeting_bias( obj_artillery, 0.25 );
	//dprint( "f_e8_m2_artillery_manage: TOO TOUGH" );
	if ( (f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED) and (object_get_health(obj_artillery) > 0.0) ) then
		thread( f_e8_m2_dialog_artillery_tough() );
	end
	
	// core damaged
	sleep_until( (f_e8_m2_artillery_index_state(s_index) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE) or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED), 1 );
	//dprint( "f_e8_m2_artillery_manage: DAMAGED" );
	if ( f_e8_m2_artillery_index_state(s_index) <= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED ) then
		thread( f_e8_m2_dialog_artillery_core_attacked(s_index) );
	end
	
	// Switch blip
	sleep_until( (object_get_health(obj_artillery) <= 0.0) or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK) or (f_e8_m2_artillery_index_state(s_index) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED), 1 );
	//dprint( "f_e8_m2_artillery_manage: SWITCH BLIP" );
	f_e8_m2_artillery_state( DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK );
	f_e8_m2_objective( R_e8_m2_objective_destroy_cores );
	
	// Destroyed
	sleep_until( object_get_health(obj_artillery) <= 0.0, 1 );
	//dprint( "f_e8_m2_artillery_manage: DESTROYED" );
	
	// make sure the ai is dead
	ai_erase( ai_artillery );
	sleep_until( ai_living_count(ai_artillery) <= 0, 1 );

	// ordnance drop
	//if ( f_e8_m2_artillery_living_cnt() > 0 ) then
	//	thread( f_e8_m2_ordnance_drop(f_e8_m2_artillery_killed_cnt(), s_index) );
	//end

	// setup near final vo
	if ( f_e8_m2_artillery_living_cnt() == 1 ) then
		wake( f_e8_m2_dialog_artillery_near_final );
	end

	// destroyed vo
	thread( f_e8_m2_dialog_artillery_destroyed() );

	// clean up threads
	kill_thread( l_damage_thread );

end

// === f_e8_m2_artillery_manage_spawn_locs::: Manages the spawn locations for an artillery
script static void f_e8_m2_artillery_manage_spawn_locs( short s_index, folder fld_spawn_locs, object obj_artillery )
static short s_active_cnt = 0;
	//dprint( "f_e8_m2_artillery_manage_spawn_locs" );

	// wait to activate
	sleep_until(
		(
			( spops_player_living_cnt() > 0 )
			and
			( objects_distance_to_object(Players(),obj_artillery) <= R_e8m2_artillery_blip_range )
		)
		or
		( f_e8_m2_artillery_index_state(s_index) > DEF_E8M2_ARTILLERY_STABILITY_STATE_STABLE )
	, 10 );

	// activate
	//dprint( "f_e8_m2_artillery_manage_spawn_locs: ACTIVATE" );
	object_create_folder( fld_spawn_locs );
	s_active_cnt = s_active_cnt + 1;

	// wait to deactivate
	sleep_until( (f_e8_m2_artillery_index_state(s_index) >= DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTROYED) and ((s_active_cnt > 1) or (f_e8_m2_artillery_living_cnt() <= 0)), 6 );

	// deactivate
	//dprint( "f_e8_m2_artillery_manage_spawn_locs: DEACTIVATE" );
	object_destroy_folder( fld_spawn_locs );
	s_active_cnt = s_active_cnt - 1;

	// setup final spawn points
	if ( (f_e8_m2_artillery_living_cnt() <= 0) and (s_active_cnt == 0) ) then
		//dprint( "f_e8_m2_artillery_manage_spawn_locs: FINAL" );
		object_destroy_folder( fld_e8_m2_spawn_init );
		sleep(1);
		object_create_folder( fld_e8_m2_spawn_rendezvous );
	end

end

// === f_e8_m2_artillery_manage_attack::: Manages the artillery attack logic
script static void f_e8_m2_artillery_manage_attack( short s_index, ai ai_artillery, object obj_artillery, object obj_core_01, object obj_core_02 )
static boolean b_warned_destablized = FALSE;
local long l_timer = 0;

	//dprint( "f_e8_m2_artillery_manage_attack: START" );
	//inspect( ai_living_count(ai_artillery) );
	
	repeat

		// wait for firing
		sleep_until( ai_is_shooting(ai_artillery) or (f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS), 1 );
		//dprint( "f_e8_m2_artillery_manage_attack: SHOOTING" );
		spops_audio_music_event( 'play_mus_pve_e08m2_ai_artillery_shooting', "play_mus_pve_e08m2_ai_artillery_shooting" );
		
		if ( f_e8_m2_artillery_index_state(s_index) < DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED ) then
			thread( f_e8_m2_dialog_artillery_fire() );
		end
		if ( (not b_warned_destablized) and (f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DESTABILIZED) ) then
			b_warned_destablized = TRUE;
			thread( f_e8_m2_dialog_artillery_destabilized(s_index) );
		end

		// wait for not firing
		sleep_until( (not ai_is_shooting(ai_artillery)) or (f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS), 1 );
		
	until( f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS, 1 );

	// disable turret firing
	ai_braindead( ai_artillery, TRUE );
	ai_set_blind( ai_artillery, TRUE );
	ai_set_deaf( ai_artillery, TRUE );

	// cores destroyed
	if ( (f_e8_m2_artillery_index_state(s_index) == DEF_E8M2_ARTILLERY_STABILITY_STATE_DANGEROUS) and (object_get_health(obj_core_01) <= 0.0) and (object_get_health(obj_core_02) <= 0.0) ) then
		local long l_thread = -1;
		l_thread = thread(f_e8_m2_dialog_artillery_cores_destroyed( s_index ));
		sleep_until( not IsThreadValid(l_thread), 1 );
	end

	// delay before explodes
	//l_timer = timer_stamp( 2.5 );

	// warning dialog
	thread( f_e8_m2_dialog_artillery_dangerous(s_index, obj_artillery) );
	sleep_s( 1.0 );
	sleep_until( timer_expired(l_timer) and (not isthreadvalid(L_e8_m2_dialog_artillery_dangerous)), 1 );

	// disable turret firing
	ai_braindead( ai_artillery, FALSE );
	ai_set_blind( ai_artillery, FALSE );
	ai_set_deaf( ai_artillery, FALSE );

	// destroy the artillery
	//dprint( "f_e8_m2_artillery_manage_attack: DESTROY!!!" );
	ai_kill_silent( ai_artillery );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: BLIP ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_blip::: Manages a cores blip states
script static void f_e8_m2_artillery_blip( short s_index, object obj_artillery, object obj_core_01, object obj_core_02 )
local long l_thread = 0;
	
	// attack artillery blip
	sleep_until( R_e8_m2_objective_index >= R_e8_m2_objective_destroy_artillery, 6 );
	if ( (S_e8m2_artillery_state < DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK) and (object_get_health(obj_artillery) > 0.0) and ((object_get_health(obj_core_01) > 0.0) or (object_get_health(obj_core_02) > 0.0)) ) then
	
		l_thread = thread( sys_spops_blip_auto_thread() );
		thread( f_e8_m2_artillery_blip_attack( player0, s_index, obj_artillery, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_attack( player1, s_index, obj_artillery, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_attack( player2, s_index, obj_artillery, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_attack( player3, s_index, obj_artillery, l_thread) );
	
		sleep_until( S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, 6 );
		kill_thread( l_thread );
		sleep( 1 );
		
	end
	
	// attack cores blip
	sleep_until( S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, 6 );
	if ( (object_get_health(obj_artillery) > 0.0) and ((object_get_health(obj_core_01) > 0.0) or (object_get_health(obj_core_02) > 0.0)) ) then
	
		l_thread = thread( sys_spops_blip_auto_thread() );
		thread( f_e8_m2_artillery_blip_core( player0, s_index, obj_artillery, obj_core_01, obj_core_02, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_core( player1, s_index, obj_artillery, obj_core_01, obj_core_02, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_core( player2, s_index, obj_artillery, obj_core_01, obj_core_02, l_thread) );
		sleep(1);
		thread( f_e8_m2_artillery_blip_core( player3, s_index, obj_artillery, obj_core_01, obj_core_02, l_thread) );
	
		sleep_until( (object_get_health(obj_artillery) <= 0.0) or ((object_get_health(obj_core_01) <= 0.0) and (object_get_health(obj_core_02) <= 0.0)), 6 );
		kill_thread( l_thread );
		sleep( 1 );
		
	end
	
	// complete
	kill_thread( l_thread );

end

script static void f_e8_m2_artillery_blip_attack( player p_player, short s_index, object obj_artillery, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local boolean b_blip = FALSE;
		local string_id sid_type = NONE;

		repeat

			if ( b_blip and (sid_type != 'navpoint_healthbar_neutralize') ) then
				sid_type = 'navpoint_healthbar_neutralize';
				navpoint_track_object_for_player_named( p_player, obj_artillery, sid_type );				
			end
			if ( (not b_blip) and (sid_type != 'navpoint_goto') ) then
				sid_type = 'navpoint_goto';
				navpoint_track_object_for_player_named( p_player, obj_artillery, sid_type );				
			end

			// wait for change
			sleep_until( (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)) or (b_blip != sys_e8_m2_artillery_blip_check(p_player, s_index, f_e8_m2_artillery_nearest_index(p_player), obj_artillery)), 6 );
			
			// store blip condition
			b_blip = sys_e8_m2_artillery_blip_check( p_player, s_index, f_e8_m2_artillery_nearest_index(p_player), obj_artillery );
		
		until( (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
		// unblip
		navpoint_track_object_for_player( p_player, obj_artillery, FALSE );
	
	end

end

script static void f_e8_m2_artillery_blip_core( player p_player, short s_index, object obj_artillery, object obj_core_01, object obj_core_02, long l_thread )

	if ( player_is_in_game(p_player) and IsThreadValid(l_thread) ) then
		local string_id sid_blip_artillery = NONE;
		local string_id sid_blip_01 = NONE;
		local string_id sid_blip_02 = NONE;
		local short s_artillery_nearest = 0;

		repeat

			// get the nearest artillery
			s_artillery_nearest = f_e8_m2_artillery_nearest_index( p_player );

			// blip artillery			
			if ( (s_artillery_nearest != s_index) and (sid_blip_artillery != 'navpoint_goto') ) then
				sid_blip_artillery = 'navpoint_goto';
				navpoint_track_object_for_player_named( p_player, obj_artillery, sid_blip_artillery );
			end
			if ( (s_artillery_nearest == s_index) and (sid_blip_artillery != NONE) ) then
				sid_blip_artillery = NONE;
				navpoint_track_object_for_player( p_player, obj_artillery, FALSE );
			end
		
			// blip cores			
			sid_blip_01 = sys_e8_m2_artillery_blip_core( p_player, s_index, s_artillery_nearest, obj_core_01, sid_blip_01 );
			sid_blip_02 = sys_e8_m2_artillery_blip_core( p_player, s_index, s_artillery_nearest, obj_core_02, sid_blip_02 );
		
		until( (not IsThreadValid(l_thread)) or (not player_is_in_game(p_player)), 1 );
		
		// unblip
		navpoint_track_object_for_player( p_player, obj_artillery, FALSE );
		navpoint_track_object_for_player( p_player, obj_core_01, FALSE );
		navpoint_track_object_for_player( p_player, obj_core_02, FALSE );
		
		// temp final blip
		if ( object_get_health(obj_artillery) > 0.0 ) then
			navpoint_track_object_for_player_named( p_player, obj_artillery, 'navpoint_neutralize' );
		end
	
	end

end

script static boolean sys_e8_m2_artillery_blip_check( player p_player, short s_artillery_index, short s_nearest_index, object obj_damage )
	(S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_NEAR) and ((s_artillery_index == s_nearest_index ) or ( (object_recent_damage(obj_damage) > 0.0) and objects_can_see_object(p_player, obj_damage, 15.0)) );
end

script static string_id sys_e8_m2_artillery_blip_core( player p_player, short s_artillery_index, short s_nearest_index, object obj_core, string_id sid_type )

	if ( (sid_type != 'navpoint_healthbar_neutralize') and (obj_core != NONE) and sys_e8_m2_artillery_blip_check(p_player, s_artillery_index, s_nearest_index, obj_core) ) then
		sid_type = 'navpoint_healthbar_neutralize';
		navpoint_track_object_for_player_named( p_player, obj_core, sid_type );				
	elseif ( (sid_type != NONE) and ((obj_core == NONE) or (not sys_e8_m2_artillery_blip_check(p_player, s_artillery_index, s_nearest_index, obj_core))) ) then
		sid_type = NONE;
		navpoint_track_object_for_player( p_player, obj_core, FALSE );		
	end

	// return
	sid_type;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: CORE: SHELL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_core_shell_init::: Initializes a core shell
script static void f_e8_m2_artillery_core_shell_init( object obj_shell )
	//dprint( "f_e8_m2_artillery_core_shell_init" );
		
	// targetting settings
	ai_object_set_team( obj_shell, DEF_E8_M2_TEAM_CORE );
	ai_object_enable_targeting_from_vehicle( obj_shell, FALSE );
	ai_object_set_targeting_bias( obj_shell, 0.0 );

end

// === f_e8_m2_artillery_core_shell_target::: Sets a shell to be targetable
script static void f_e8_m2_artillery_core_shell_target( object obj_shell )
	//dprint( "f_e8_m2_artillery_core_shell_target" );

	ai_object_enable_targeting_from_vehicle( obj_shell, TRUE );
	ai_object_set_targeting_bias( obj_shell, 0.75 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: CORE: MANAGE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_core_manage::: Manages core logic
script static void f_e8_m2_artillery_core_manage( short s_index, object obj_artillery, object obj_core )
local long l_damage_thread = 0;
	//dprint( "f_e8_m2_artillery_core_manage" );
	
	// wait for mission start
	sleep_until( f_spops_mission_start_complete(), 1 );
	//ai_object_set_team( obj_core, DEF_E8_M2_TEAM_CORE );
	//ai_magically_see_object( gr_e8_m2_enemy_artillery, obj_core );
	
	// damage watch
	l_damage_thread = thread( f_e8_m2_artillery_state_damage_watch(DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED, obj_core, 0.025, 0.075, 0.90, -1) );

	// setup core attack	
	sleep_until( S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK, 1 );
	//ai_allegiance_break( player, DEF_E8_M2_TEAM_CORE );
	
	/*
	ai_allegiance_break( DEF_E8_M2_TEAM_CORE, player );
	ai_allegiance_remove( player, DEF_E8_M2_TEAM_CORE );
	ai_allegiance_remove( DEF_E8_M2_TEAM_CORE, player );
	ai_allegiance_break( human, DEF_E8_M2_TEAM_CORE );
	ai_allegiance_break( DEF_E8_M2_TEAM_CORE, human );
	ai_allegiance_remove( human, DEF_E8_M2_TEAM_CORE );
	ai_allegiance_remove( DEF_E8_M2_TEAM_CORE, human );
	ai_magically_see_object( gr_e8_m2_unsc_spartans, obj_core );
	ai_object_enable_targeting_from_vehicle( obj_core, TRUE );
	ai_object_set_targeting_bias( obj_core, 1.0 );
	*/

	// core damaged
	sleep_until( (object_get_health(obj_artillery) <= 0.0) or (object_get_health(obj_core) <= 0.0), 1 );
	kill_thread( l_damage_thread );

	// destroyed dialog
	if ( (object_get_health(obj_artillery) > 0.0) and (object_get_health(obj_core) <= 0.0) ) then
		thread( f_e8_m2_dialog_artillery_core_destroyed(obj_artillery) );
	end
	
	// make sure the core is destroyed
	f_e8_m2_artillery_core_fade_out( obj_core, TRUE );
	
	// music hook
	spops_audio_music_event( 'play_mus_pve_e08m2_core_destroyed', "play_mus_pve_e08m2_core_destroyed" );

end

// === f_e8_m2_artillery_core_fade_out::: Fades out the core and destroys it
script static void f_e8_m2_artillery_core_fade_out( object obj_core, boolean b_destroy )
	//dprint( "f_e8_m2_artillery_core_fade_out" );
	
	if ( object_get_health(obj_core) > 0.0 ) then
		local long l_timer = timer_stamp( 1.0 );
		object_set_scale( obj_core, 0.001, seconds_to_frames(0.5) );
		sleep_until( timer_expired(l_timer) or (object_get_health(obj_core) <= 0.0), 1 );
	end
	if ( b_destroy and (object_get_health(obj_core) > 0.0) ) then
		object_destroy( obj_core );
	end
	
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: ARTILLERY: STATE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global short DEF_E8M2_ARTILLERY_STATE_NONE = 												0;
global short DEF_E8M2_ARTILLERY_STATE_KNOWN = 											1;
global short DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN = 							2;
global short DEF_E8M2_ARTILLERY_STATE_NEAR = 												3;
global short DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH = 									4;
global short DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK = 								5;
global short DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED = 								6;
global short DEF_E8M2_ARTILLERY_STATE_COMPLETE = 										999;

global real DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_RECENT_CURRENT	= 		0.009;
global real DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_RECENT_TOTAL	= 			DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_RECENT_CURRENT * ( 1 + (real(player_count()) * 0.5) );
global real DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_HEALTH	= 						0.120;
global real DEF_E8M2_ARTILLERY_DAMAGE_TRIGGER_SHIELD	= 						-1.0;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e8m2_artillery_state = 															DEF_E8M2_ARTILLERY_STATE_NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_artillery_state::: Sets the state of the artillery
script static void f_e8_m2_artillery_state( short s_state )

	if ( s_state > S_e8m2_artillery_state ) then
		//dprint( "f_e8_m2_artillery_state" );
		//inspect( s_state );
		S_e8m2_artillery_state = s_state;
		
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_KNOWN ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_known', "play_mus_pve_e08m2_artillery_mission_state_known" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_INFINITY_WARN ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_infinity_warning', "play_mus_pve_e08m2_artillery_mission_state_infinity_warning" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_NEAR ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_near', "play_mus_pve_e08m2_artillery_mission_state_near" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_TOO_TOUGH ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_too_tough', "play_mus_pve_e08m2_artillery_mission_state_too_tough" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_core_attacked', "play_mus_pve_e08m2_artillery_mission_state_core_attacked" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_CORE_DAMAGED ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_core_damaged', "play_mus_pve_e08m2_artillery_mission_state_core_damaged" );
		end
		if ( s_state == DEF_E8M2_ARTILLERY_STATE_COMPLETE ) then
			spops_audio_music_event( 'play_mus_pve_e08m2_artillery_mission_state_complete', "play_mus_pve_e08m2_artillery_mission_state_complete" );
		end
		
	end
	
end

// === f_e8_m2_artillery_state::: Gets the state of the artillery
//script static short f_e8_m2_artillery_state()
//	S_e8m2_artillery_state;
//end

// === f_e8_m2_artillery_state_damage_watch::: Watches different types of damage and sets a state when thresholds are met
script static void f_e8_m2_artillery_state_damage_watch( short s_state, object obj_object, real r_recent_current, real r_recent_total, real r_health, real r_shield )
local real r_dmg_recent = 0.0;
local real r_dmg_temp = 0.0;
local real r_dmg_recent_total = 0.0;

	repeat
	
		sleep_until(
				( S_e8m2_artillery_state >= s_state )
				or
				( r_dmg_recent != object_recent_damage(obj_object) )
				or
				( object_get_health(obj_object) <= 0.0 )
			, 1 );
	
		// sum up total recent damage
		r_dmg_temp = object_recent_damage( obj_object );
		if ( r_dmg_temp < r_dmg_recent ) then
			r_dmg_recent_total = r_dmg_recent_total + r_dmg_recent;
		end
		r_dmg_recent = r_dmg_temp;
		
		//dprint( "f_e8_m2_artillery_state_damage_watch" );
		inspect( r_dmg_recent );
		inspect( r_dmg_recent_total );
		//inspect( object_get_health(obj_object) );
		//inspect( object_get_shield(obj_object) );
	
	until( 
			( S_e8m2_artillery_state >= s_state )
			or
			( object_get_health(obj_object) <= 0.0 )
			or
			(
				( r_recent_current >= 0.0 )
				and
				( r_dmg_recent >= r_recent_current )
			)
			or
			(
				( r_recent_total >= 0.0 )
				and
				( r_dmg_recent_total >= r_recent_total )
			)
			or
			(
				( r_health >= 0.0 )
				and
				( r_health >= object_get_health(obj_object) )
			)
			or
			(
				( r_shield >= 0.0 )
				and
				( r_shield >= object_get_shield(obj_object) )
			)
		, 10 );

	// set the new state
	//dprint( "f_e8_m2_artillery_state_damage_watch: DONE" );
	f_e8_m2_artillery_state( s_state );

end

/*
script static void test_recent_damage( object obj_test )
local real r_dmg = object_recent_damage( obj_test );
local real r_dmg_tmp = 0.0;

	repeat

		sleep_until( r_dmg != object_recent_damage(obj_test), 1 );
		r_dmg_tmp = object_recent_damage( obj_test );
		if ( r_dmg_tmp > r_dmg ) then
			//dprint( "-" );
			//inspect( r_dmg_tmp );
			//inspect( object_get_health(obj_test) );
			//inspect( object_get_health(obj_test) * object_get_maximum_vitality(obj_test, TRUE) );
			//inspect( object_get_shield(obj_test) );
		end
		r_dmg = r_dmg_tmp;
		
	until( FALSE, 1 );

end
*/