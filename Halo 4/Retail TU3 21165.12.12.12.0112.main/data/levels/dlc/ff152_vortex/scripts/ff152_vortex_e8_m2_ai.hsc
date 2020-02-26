//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global team DEF_E8_M2_TEAM_CLEANUP = 																brute;
//global team DEF_E8_M2_TEAM_ARTILLERY = 															spare;
global team DEF_E8_M2_TEAM_CORE = 																	covenant;
global real DEF_E8_M2_WATCHER_SPAWN_DISTANCE =											15.0;
global real DEF_E8_M2_WATCHER_SPAWN_SCALE_TIME =										2.0;
global short DEF_E8_M2_PLACE_SAFE_POPULATION_LIMIT_LEVEL_00_INIT =	20;
global short DEF_E8_M2_POOL_POPULATION_LIMIT_LEVEL_00_INIT =				0;
global short DEF_E8_M2_PLACE_SAFE_POPULATION_LIMIT_LEVEL_01_INIT =	20;
global short DEF_E8_M2_POOL_POPULATION_LIMIT_LEVEL_01_INIT =				20;
global short DEF_E8_M2_PLACE_SAFE_POPULATION_LIMIT_LEVEL_02_INIT =	14;
global short DEF_E8_M2_POOL_POPULATION_LIMIT_LEVEL_02_INIT =				20;
global short DEF_E8_M2_PLACE_SAFE_POPULATION_LIMIT_LEVEL_03_INIT =	12;
global short DEF_E8_M2_POOL_POPULATION_LIMIT_LEVEL_03_INIT =				20;
global short DEF_E8_M2_PLACE_SAFE_POPULATION_LIMIT_LEVEL_04_INIT =	0;
global short DEF_E8_M2_POOL_POPULATION_LIMIT_LEVEL_04_INIT =				20;

// spawn priority
global real DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_LEADER = 					050.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_SUPPORT_01 = 			-075.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_LEADER = 							025.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01 = 					-050.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_02 = 					-075.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_03 = 					-100.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_WATCHER = 									-037.5;

global boolean B_e8_m2_ai_mop_up = 																	FALSE;
global short e8_m2_SpawningInPhantom	=	0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_init::: Init
script dormant f_e8_m2_ai_init()
	//dprint( "f_e8_m2_ai_init" );
	thread(f_e8_m2_ai_objectives_lz_watch());
	thread(sys_e8_m2_artillery_reinforcement_weight_watch());
	// set allegiances
	ai_allegiance( covenant, forerunner );
	//ai_allegiance( covenant, DEF_E8_M2_TEAM_ARTILLERY );
	
	ai_allegiance( forerunner, covenant );
	//ai_allegiance( forerunner, DEF_E8_M2_TEAM_ARTILLERY );
	
	//ai_allegiance( DEF_E8_M2_TEAM_ARTILLERY, covenant );
	//ai_allegiance( DEF_E8_M2_TEAM_ARTILLERY, forerunner );

	ai_allegiance( DEF_E8_M2_TEAM_CLEANUP, covenant );
	ai_allegiance( DEF_E8_M2_TEAM_CLEANUP, forerunner );
	//ai_allegiance( DEF_E8_M2_TEAM_CLEANUP, DEF_E8_M2_TEAM_ARTILLERY );

	ai_allegiance( covenant, DEF_E8_M2_TEAM_CLEANUP );
	ai_allegiance( forerunner, DEF_E8_M2_TEAM_CLEANUP );
	//ai_allegiance( DEF_E8_M2_TEAM_ARTILLERY, DEF_E8_M2_TEAM_CLEANUP );
	
	// initialize sub-modules
	wake( f_e8_m2_ai_level_init );
	wake( f_e8_m2_ai_intro_init );
	wake( f_e8_m2_ai_phantoms_init );
	
	// setup trigger
	wake ( f_e8_m2_ai_trigger );
	
end

// === f_e8_m2_ai_trigger::: Trigger
script dormant f_e8_m2_ai_trigger()
	//dprint( "f_e8_m2_ai_trigger" );

	sleep_until( f_spops_mission_start_complete(), 1 );
	//dprint( "f_e8_m2_ai_trigger: START COMPLETE" );
	ai_exit_limbo( ai_ff_all );

end

// === f_e8_m2_ai_trigger::: Trigger
script static short f_e8_m2_ai_enemy_cnt()
	ai_living_count( gr_e8_m2_enemy_unit_all );
end

script static short f_e8_m2_body_count_enemy_all()
	ai_body_count( objectives_e8m2_artillery_01.enemy_gate ) + ai_body_count( objectives_e8m2_artillery_02.enemy_gate ) + ai_body_count( objectives_e8m2_artillery_03.enemy_gate ) + ai_body_count( objectives_e8m2_lz.enemy_gate );
end
script static short f_e8_m2_body_count_enemy_lz()
	ai_body_count( objectives_e8m2_lz.enemy_gate );
end
script static short f_e8_m2_body_count_enemy_artillery()
	ai_body_count( objectives_e8m2_artillery_01.enemy_gate ) + ai_body_count( objectives_e8m2_artillery_02.enemy_gate ) + ai_body_count( objectives_e8m2_artillery_03.enemy_gate );
end

script static void f_e8_m2_ai_watcher_place_fx( ai ai_watcher, object obj_watcher )
	//dprint( "f_e8_m2_ai_watcher_place_fx" );
	
	// music hook
	spops_audio_music_event( 'play_mus_pve_e08m2_ai_watcher_spawning', "play_mus_pve_e08m2_ai_watcher_spawning" );

	// initial fx
	effect_new_on_object_marker( 'levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect', obj_watcher, "" );
	sleep_s( 0.5 );
	effect_new_on_object_marker( 'levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect', obj_watcher, "" );
	sleep_s( 3.0 );
	
	// restore
	object_set_scale( obj_watcher, 0.001, 0 );
	object_hide( obj_watcher, FALSE );

	// scale in
	object_set_scale( obj_watcher, 1.0, seconds_to_frames(DEF_E8_M2_WATCHER_SPAWN_SCALE_TIME) );
	cs_face_player( ai_watcher, TRUE );
  sleep_s( (DEF_E8_M2_WATCHER_SPAWN_SCALE_TIME * 0.50) );
	object_can_take_damage( obj_watcher );
  sleep_s( (DEF_E8_M2_WATCHER_SPAWN_SCALE_TIME * 0.25) );
	cs_face_player( ai_watcher, FALSE );
	ai_braindead( ai_watcher, FALSE );
	ai_set_blind( ai_watcher, FALSE );
	ai_set_deaf( ai_watcher, FALSE );
  sleep_s( 3.0 - (DEF_E8_M2_WATCHER_SPAWN_SCALE_TIME * 0.75) );

	// post fx
	effect_new_on_object_marker( 'levels\firefight\ff90_fortsw\fx\teleport_lg_portal_start_pve.effect', obj_watcher, "" );
  sleep_s( 1.5 );
	effect_new_on_object_marker( 'levels\firefight\ff82_scurve\fx\teleport_lg_portal_no_shake.effect', obj_watcher, "" );

	// setup shooting trigger
	thread( spops_audio_music_ai_shooting('play_mus_pve_e08m2_ai_watcher_attacking', "play_mus_pve_e08m2_ai_watcher_attacking", ai_watcher) );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES: LZ ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_e8_m2_ai_objective_lz_morale = 						DEF_SPOPS_AI_MORALE_TIED;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_e8_m2_ai_objectives_lz_watch()
	sleep(1);
	repeat
		S_e8_m2_ai_objective_lz_morale = spops_ai_morale( objectives_e8m2_lz.unsc_gate, objectives_e8m2_lz.enemy_gate );
	until(false,15);
end
script static short f_e8_m2_ai_objectives_lz_morale()
	S_e8_m2_ai_objective_lz_morale;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES: ARTILLERY ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_unsc_core_enabled::: Checks if any of the the cores are enabled for UNSC attacking
script static boolean f_e8_m2_ai_unsc_core_enabled()
	S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK;
end

// === f_e8_m2_ai_enemy_artillery_reinforcements_enabled::: Checks if the core needs reinforcements
script static boolean f_e8_m2_ai_enemy_artillery_reinforcements_enabled( ai ai_task, object obj_object )
	( ai_task_count(ai_task) >= 10 ) and ((object_recent_damage(obj_object) > 0.0) or (objects_distance_to_object(Players(),obj_object) <= 10.0));
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES: ARTILLERY: 01 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_e8_m2_ai_objective_artillery_01_enabled = 									FALSE;
static boolean B_e8_m2_ai_objective_artillery_01_core_01_enabled = 					FALSE;
static boolean B_e8_m2_ai_objective_artillery_01_core_03_enabled = 					FALSE;
static boolean B_e8_m2_ai_objective_artillery_01_reinforcements_enabled = 					FALSE;
static boolean B_e8_m2_ai_objective_artillery_01_core_01_reinforcements_enabled = 	FALSE;
static boolean B_e8_m2_ai_objective_artillery_01_core_03_reinforcements_enabled = 	FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script startup f_e8_m2_ai_objectives_artillery_01_watch()

	sleep_until( object_get_health(obj_e8m2_artillery_01) > 0.0, 1 );
	repeat
		B_e8_m2_ai_objective_artillery_01_enabled = ( ai_living_count(sq_e8m2_a01_artillery) > 0 );
		B_e8_m2_ai_objective_artillery_01_core_01_enabled = B_e8_m2_ai_objective_artillery_01_enabled and ( object_get_health(obj_e8m2_artillery_01_core_01) > 0.0 );
		B_e8_m2_ai_objective_artillery_01_core_03_enabled = B_e8_m2_ai_objective_artillery_01_enabled and ( object_get_health(obj_e8m2_artillery_01_core_03) > 0.0 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_01_core_01_reinforcements_enabled = B_e8_m2_ai_objective_artillery_01_core_01_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_01.enemy_artillery_gate, obj_e8m2_artillery_01_core_01 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_01_core_03_reinforcements_enabled = B_e8_m2_ai_objective_artillery_01_core_03_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_01.enemy_artillery_gate, obj_e8m2_artillery_01_core_03 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_01_reinforcements_enabled = B_e8_m2_ai_objective_artillery_01_enabled
																																and 
																																(
																																	(
																																		not B_e8_m2_ai_objective_artillery_01_core_01_reinforcements_enabled
																																		and
																																		not B_e8_m2_ai_objective_artillery_01_core_03_reinforcements_enabled
																																	)
																																	or
																																	f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_01.enemy_artillery_gate, obj_e8m2_artillery_01 )
																																);
	until( not B_e8_m2_ai_objective_artillery_01_enabled, 10);

end
script static boolean f_e8_m2_ai_artillery_01_enabled()
	B_e8_m2_ai_objective_artillery_01_enabled;
end
script static boolean f_e8_m2_ai_artillery_01_core_01_enabled()
	B_e8_m2_ai_objective_artillery_01_core_01_enabled;
end
script static boolean f_e8_m2_ai_artillery_01_core_03_enabled()
	B_e8_m2_ai_objective_artillery_01_core_03_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_01_core_01_enabled()
	B_e8_m2_ai_objective_artillery_01_core_01_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_01_core_03_enabled()
	B_e8_m2_ai_objective_artillery_01_core_03_enabled;
end
script static boolean f_e8_m2_ai_artillery_01_enemy_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_01_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_01_core_01_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_01_core_01_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_01_core_03_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_01_core_03_reinforcements_enabled;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES: ARTILLERY: 02 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_e8_m2_ai_objective_artillery_02_enabled = 													FALSE;
static boolean B_e8_m2_ai_objective_artillery_02_core_01_enabled = 									FALSE;
static boolean B_e8_m2_ai_objective_artillery_02_core_03_enabled = 									FALSE;
static boolean B_e8_m2_ai_objective_artillery_02_reinforcements_enabled = 					FALSE;
static boolean B_e8_m2_ai_objective_artillery_02_core_01_reinforcements_enabled = 	FALSE;
static boolean B_e8_m2_ai_objective_artillery_02_core_03_reinforcements_enabled = 	FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script startup f_e8_m2_ai_objectives_artillery_02_watch()

	sleep_until( object_get_health(obj_e8m2_artillery_02) > 0.0, 1 );
	repeat
		B_e8_m2_ai_objective_artillery_02_enabled = ( ai_living_count(sq_e8m2_a02_artillery) > 0 );
		B_e8_m2_ai_objective_artillery_02_core_01_enabled = B_e8_m2_ai_objective_artillery_02_enabled and ( object_get_health(obj_e8m2_artillery_02_core_01) > 0.0 );
		B_e8_m2_ai_objective_artillery_02_core_03_enabled = B_e8_m2_ai_objective_artillery_02_enabled and ( object_get_health(obj_e8m2_artillery_02_core_03) > 0.0 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_02_core_01_reinforcements_enabled = B_e8_m2_ai_objective_artillery_02_core_01_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_02.enemy_artillery_gate, obj_e8m2_artillery_02_core_01 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_02_core_03_reinforcements_enabled = B_e8_m2_ai_objective_artillery_02_core_03_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_02.enemy_artillery_gate, obj_e8m2_artillery_02_core_03 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_02_reinforcements_enabled = B_e8_m2_ai_objective_artillery_02_enabled
																																and 
																																(
																																	(
																																		not B_e8_m2_ai_objective_artillery_02_core_01_reinforcements_enabled
																																		and
																																		not B_e8_m2_ai_objective_artillery_02_core_03_reinforcements_enabled
																																	)
																																	or
																																	f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_02.enemy_artillery_gate, obj_e8m2_artillery_02 )
																																);
	until( not B_e8_m2_ai_objective_artillery_02_enabled, 10 );

end
script static boolean f_e8_m2_ai_artillery_02_enabled()
	B_e8_m2_ai_objective_artillery_02_enabled;
end
script static boolean f_e8_m2_ai_artillery_02_core_01_enabled()
	B_e8_m2_ai_objective_artillery_02_core_01_enabled;
end
script static boolean f_e8_m2_ai_artillery_02_core_03_enabled()
	B_e8_m2_ai_objective_artillery_02_core_03_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_02_core_01_enabled()
	B_e8_m2_ai_objective_artillery_02_core_01_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_02_core_03_enabled()
	B_e8_m2_ai_objective_artillery_02_core_03_enabled;
end
script static boolean f_e8_m2_ai_artillery_02_enemy_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_02_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_02_core_01_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_02_core_01_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_02_core_03_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_02_core_03_reinforcements_enabled;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: OBJECTIVES: ARTILLERY: 03 ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static boolean B_e8_m2_ai_objective_artillery_03_enabled = 													FALSE;
static boolean B_e8_m2_ai_objective_artillery_03_core_01_enabled = 									FALSE;
static boolean B_e8_m2_ai_objective_artillery_03_core_02_enabled = 									FALSE;
static boolean B_e8_m2_ai_objective_artillery_03_reinforcements_enabled = 					FALSE;
static boolean B_e8_m2_ai_objective_artillery_03_core_01_reinforcements_enabled = 	FALSE;
static boolean B_e8_m2_ai_objective_artillery_03_core_02_reinforcements_enabled = 	FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script startup f_e8_m2_ai_objectives_artillery_03_watch()

	sleep_until( object_get_health(obj_e8m2_artillery_03) > 0.0, 1 );
	repeat
		B_e8_m2_ai_objective_artillery_03_enabled = ( ai_living_count(sq_e8m2_a03_artillery) > 0 );
		B_e8_m2_ai_objective_artillery_03_core_01_enabled = B_e8_m2_ai_objective_artillery_03_enabled and ( object_get_health(obj_e8m2_artillery_03_core_01) > 0.0 );
		B_e8_m2_ai_objective_artillery_03_core_02_enabled = B_e8_m2_ai_objective_artillery_03_enabled and ( object_get_health(obj_e8m2_artillery_03_core_02) > 0.0 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_03_core_01_reinforcements_enabled = B_e8_m2_ai_objective_artillery_03_core_01_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_03.enemy_artillery_gate, obj_e8m2_artillery_03_core_01 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_03_core_02_reinforcements_enabled = B_e8_m2_ai_objective_artillery_03_core_02_enabled and f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_03.enemy_artillery_gate, obj_e8m2_artillery_03_core_02 );
		sleep(1);
		B_e8_m2_ai_objective_artillery_03_reinforcements_enabled = B_e8_m2_ai_objective_artillery_03_enabled
																																and 
																																(
																																	(
																																		not B_e8_m2_ai_objective_artillery_03_core_01_reinforcements_enabled
																																		and
																																		not B_e8_m2_ai_objective_artillery_03_core_02_reinforcements_enabled
																																	)
																																	or
																																	f_e8_m2_ai_enemy_artillery_reinforcements_enabled( objectives_e8m2_artillery_03.enemy_artillery_gate, obj_e8m2_artillery_03 )
																																);
	until( not B_e8_m2_ai_objective_artillery_03_enabled, 10 );

end
script static boolean f_e8_m2_ai_artillery_03_enabled()
	B_e8_m2_ai_objective_artillery_03_enabled;
end
script static boolean f_e8_m2_ai_artillery_03_core_01_enabled()
	B_e8_m2_ai_objective_artillery_03_core_01_enabled;
end
script static boolean f_e8_m2_ai_artillery_03_core_02_enabled()
	B_e8_m2_ai_objective_artillery_03_core_02_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_03_core_01_enabled()
	B_e8_m2_ai_objective_artillery_03_core_01_enabled;
end
script static boolean f_e8_m2_ai_unsc_artillery_03_core_02_enabled()
	B_e8_m2_ai_objective_artillery_03_core_02_enabled;
end
script static boolean f_e8_m2_ai_artillery_03_enemy_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_03_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_03_core_01_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_03_core_01_reinforcements_enabled;
end
script static boolean f_e8_m2_ai_enemy_artillery_03_core_02_reinforcements_enabled()
	B_e8_m2_ai_objective_artillery_03_core_02_reinforcements_enabled;
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: LEVEL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e8_m2_ai_level = 						0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// spawn priority

// === f_e8_m2_ai_level_init::: Init
script dormant f_e8_m2_ai_level_init()
	//dprint( "f_e8_m2_ai_level_init" );
	
	// setup trigger
	wake ( f_e8_m2_ai_level_trigger );
	
end

// === f_e8_m2_ai_level_trigger::: Init
script dormant f_e8_m2_ai_level_trigger()
	//dprint( "f_e8_m2_ai_level_trigger" );
	// setup trigger
	
	// level 1 -----------------------------------------------------------------------------------------------------
	sleep_until( S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN, 1 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 01" );
	f_e8_m2_ai_pool_max_elite_basic( 1, 2, 3, 4, 1.0, 1.0, 1.25, 1.5 );
	if ( f_e8_m2_artillery_killed_cnt() == 0 ) then
		f_e8_m2_ai_level( 1 );
		spops_audio_music_event( 'play_mus_pve_e08m2_ai_level_01', "play_mus_pve_e08m2_ai_level_01" );
	end

	// setup first phantom
	sleep_until( (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK) or (f_e8_m2_body_count_enemy_artillery() >= 1) or (S_e8_m2_ai_level > 1), 10 );
	f_e8_m2_ai_phantoms_manage_cnt( 1, 25 );

	// level 2 -----------------------------------------------------------------------------------------------------
	sleep_until( f_e8_m2_artillery_killed_cnt() >= 1, 1 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 02" );
	//f_e8_m2_ai_pool_max_inc( -1 );
	
	// set spawn pools
	f_e8_m2_ai_pool_max_elite_basic( 1, 2, 3, 4, 1.0, 1.0, 1.25, 1.5 );
	f_e8_m2_ai_pool_lives_ghost( 2, 2, 2, 2, 1.0, 1.0, 1.0, 1.0 );
	f_e8_m2_ai_pool_lives_watcher( 2, 2, 3, 3, 1.0, 1.0, 1.5, 2.0 );
	f_e8_m2_ai_pool_max_watcher( 2, 2, 3, 3, 1.0, 1.0, 1.5, 2.0 );
	
	if ( f_e8_m2_artillery_killed_cnt() == 1 ) then
		f_e8_m2_ai_level( 2 );
		f_e8_m2_ai_phantoms_manage_cnt( 1, 25 );
		spops_audio_music_event( 'play_mus_pve_e08m2_ai_level_02', "play_mus_pve_e08m2_ai_level_02" );
	end

	// level 3 -----------------------------------------------------------------------------------------------------
	sleep_until( f_e8_m2_artillery_killed_cnt() >= 2, 1 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 03" );
	//f_e8_m2_ai_pool_max_inc( -1 );

	// set spawn pools
	f_e8_m2_ai_pool_max_elite_basic( 1, 2, 3, 4, 1.0, 1.0, 1.25, 1.5 );
	f_e8_m2_ai_pool_lives_hunter( 2, 2, 2, 2, 1.0, 1.0, 1.0, 1.0 );
	f_e8_m2_ai_pool_lives_watcher( 2, 2, 3, 3, 1.0, 1.0, 1.5, 2.0 );
	f_e8_m2_ai_pool_max_watcher( 3, 3, 4, 4, 1.0, 1.0, 1.5, 2.0 );

	if ( f_e8_m2_artillery_killed_cnt() == 2 ) then
		f_e8_m2_ai_level( 3 );
		f_e8_m2_ai_phantoms_manage_cnt( 1, 30 );
		spops_audio_music_event( 'play_mus_pve_e08m2_ai_level_03', "play_mus_pve_e08m2_ai_level_03" );
	end
	
	// level 4 -----------------------------------------------------------------------------------------------------
	sleep_until( f_e8_m2_artillery_killed_cnt() >= 3, 10 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 04" );
	f_e8_m2_ai_level( 4 );
	spops_audio_music_event( 'play_mus_pve_e08m2_ai_level_04', "play_mus_pve_e08m2_ai_level_04" );

	// level 5 -----------------------------------------------------------------------------------------------------
	sleep_until( R_e8_m2_objective_index >= R_e8_m2_objective_lz_finale_clear, 1 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 05" );
	local long l_timer = timer_stamp( 90.0 );
	f_e8_m2_ai_level( 5 );

	// wait for phantoms to be done or time to expire
	sleep_until( f_e8_m2_ai_phantom_lz_complete() or timer_expired(l_timer), 10 );
	//dprint( "f_e8_m2_ai_level_trigger: LEVEL 06: KAMIKAZE" );
	f_e8_m2_ai_level( 6 );
	spops_audio_music_event( 'play_mus_pve_e08m2_ai_level_05', "play_mus_pve_e08m2_ai_level_05" );
	f_e8_m2_ai_phantoms_manage_cnt( 0, -1 );

	// setup the kamikaze phantom
	thread( f_e8_m2_ai_phantom_kamikaze_show() );

	// mop up
	//sq_e8m2_pool_wraith_01
	sleep_until( f_e8_m2_rendezvous_complete() and (not f_e8_m2_ai_phantom_finale_check()) and (f_e8_m2_ai_enemy_cnt() <= spops_ai_mop_up_cnt()), 10 );
	B_e8_m2_ai_mop_up = TRUE;
	//dprint( "f_e8_m2_ai_level_trigger: MOP UP" );
	if ( f_e8_m2_ai_enemy_cnt() > 0 ) then

		spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_finale_mop_up', "play_mus_pve_e08m2_encounter_lz_finale_mop_up" );
		f_e8_m2_dialog_mop_up();
		if ( f_e8_m2_ai_enemy_cnt() > 0 ) then
			spops_blip_ai( gr_e8_m2_enemy_unit_all, TRUE, "enemy" );
		end

	end

end

// === f_e8_m2_ai_level::: xxx
script static void f_e8_m2_ai_level( short s_val )

	if ( s_val > S_e8_m2_ai_level ) then
		//dprint( "f_e8_m2_ai_level" );
		//inspect( s_val );
		S_e8_m2_ai_level = s_val;
	end
	
end
//script static short f_e8_m2_ai_level()
//	S_e8_m2_ai_level;
//end

// === f_e8_m2_ai_level::: xxx
script static void f_e8_m2_ai_level_wait( short s_level, boolean b_condition )
	sleep_until( (s_level == S_e8_m2_ai_level) == b_condition, 1 );
end
script static void f_e8_m2_ai_level_wait( short s_level )
	f_e8_m2_ai_level_wait( s_level, TRUE );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOMS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e8_m2_phantom_manage_cnt = 							0;
static string STR_e8_m2_phantom_status_load_start = 		"e8_m2_phantom_status_load_start";
static string STR_e8_m2_phantom_status_load_end = 			"e8_m2_phantom_status_load_end";
static string STR_e8_m2_phantom_status_deliver_start = 	"e8_m2_phantom_status_deliver_start";
static string STR_e8_m2_phantom_status_deliver_unload = "e8_m2_phantom_status_deliver_unload";
static string STR_e8_m2_phantom_status_deliver_end = 		"e8_m2_phantom_status_deliver_end";
static string STR_e8_m2_phantom_status_defend_start = 	"e8_m2_phantom_status_defend_start";
static string STR_e8_m2_phantom_status_defend_end = 		"e8_m2_phantom_status_defend_end";
static string STR_e8_m2_phantom_status_exit_start = 		"e8_m2_phantom_status_exit_start";
static string STR_e8_m2_phantom_status_exit_end = 			"e8_m2_phantom_status_exit_end";

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_phantoms_init::: Init
script dormant f_e8_m2_ai_phantoms_init()
	//dprint( "f_e8_m2_ai_phantoms_init" );
	
	// setup trigger
	wake ( f_e8_m2_ai_phantoms_trigger );
	
end

// === f_e8_m2_ai_phantoms_trigger::: Init
script dormant f_e8_m2_ai_phantoms_trigger()
local ai ai_phantom = NONE;
local point_reference pr_place_loc = ps_e8_m2_phantom_place;
	//dprint( "f_e8_m2_ai_phantoms_trigger" );
	
	sleep_until( S_e8_m2_phantom_manage_cnt > 0, 1 );
	
	repeat
		sleep_until( f_e8_m2_ai_phantoms_active_cnt() < S_e8_m2_phantom_manage_cnt, 10 );
		//dprint( "f_e8_m2_ai_phantoms_trigger: SEARCHING" );
		
		// select a random location
		if ( f_e8_m2_ai_phantoms_active_cnt() < S_e8_m2_phantom_manage_cnt ) then

			begin_random_count( 1 )
			
				begin
					ai_phantom = sq_e8m2_phantom_01_a;
					pr_place_loc = ps_e8_m2_phantom_place.a;
				end
				begin
					ai_phantom = sq_e8m2_phantom_01_b;
					pr_place_loc = ps_e8_m2_phantom_place.b;
				end
				begin
					ai_phantom = sq_e8m2_phantom_01_c;
					pr_place_loc = ps_e8_m2_phantom_place.c;
				end
				
			end

		end
		
		// place
		if ( f_e8_m2_ai_phantoms_active_cnt() < S_e8_m2_phantom_manage_cnt ) then
			if ( ai_living_count(ai_phantom) <= 0 ) then
				//dprint( "f_e8_m2_ai_phantoms_trigger: PLACE" );
				ai_place( ai_phantom );
			end
		end
		
	until( FALSE, 1 );
end

// === f_e8_m2_ai_phantoms_living_cnt::: Counts the active phantoms
//script static short f_e8_m2_ai_phantoms_manage_cnt()
//	S_e8_m2_phantom_manage_cnt;
//end
script static void f_e8_m2_ai_phantoms_manage_cnt( short s_val, short s_body_count )

	if ( S_e8_m2_phantom_manage_cnt != s_val ) then
	
		//dprint( "f_e8_m2_ai_phantoms_manage_cnt" );
		S_e8_m2_phantom_manage_cnt = s_val;
		//inspect( s_val );
	end
	
	// setup auto disable
	if ( (S_e8_m2_phantom_manage_cnt > 0) and (s_body_count > 0) ) then
		thread( sys_e8_m2_ai_phantoms_manage_disable_body_count(S_e8_m2_ai_level, s_body_count) );
	end

end

// === f_e8_m2_ai_phantoms_living_cnt::: Counts the active phantoms
script static short f_e8_m2_ai_phantoms_active_cnt()
local short s_cnt = 0;

	if ( ai_living_count(sq_e8m2_phantom_01_a) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( ai_living_count(sq_e8m2_phantom_01_b) > 0 ) then
		s_cnt = s_cnt + 1;
	end
	if ( ai_living_count(sq_e8m2_phantom_01_c) > 0 ) then
		s_cnt = s_cnt + 1;
	end

	// return
	s_cnt;
end

// === f_e8_m2_ai_phantom_point_loc::: Gets an artillery drop location
script static point_reference f_e8_m2_ai_phantom_point_loc( object obj_reference, point_reference pr_point_set )
local point_reference pr_point = ai_point_set_get_point( pr_point_set, 0 );;

	repeat

		begin_random_count( 1 )
			pr_point = ai_point_set_get_point( pr_point_set, random_range(0, ai_get_point_count(pr_point_set) - 1) );
			pr_point = ai_random_smart_point( pr_point_set, 10.0, 25.0, 30.0 );
			pr_point = ai_nearest_point( obj_reference, pr_point_set );
		end
	
	until( objects_distance_to_point(obj_reference, pr_point) >= 0.0, 6 );

	// return
	pr_point;
end

// === f_e8_m2_ai_phantom_artillery_weighted_get::: Gets the artillery that needs reinforcements
script static short f_e8_m2_ai_phantom_artillery_weighted_get()
local short s_index = 0;
local real r_weight = DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;
local real r_weight_temp = DEF_E8M2_ARTILLERY_REINFORCEMENT_WEIGHT_NONE;

	r_weight_temp = f_e8_m2_artillery_01_reinforcement_weight();
	if ( r_weight_temp > r_weight ) then
		r_weight = r_weight_temp;
		s_index = 1;
	end

	r_weight_temp = f_e8_m2_artillery_02_reinforcement_weight();
	if ( r_weight_temp > r_weight ) then
		r_weight = r_weight_temp;
		s_index = 2;
	end

	r_weight_temp = f_e8_m2_artillery_03_reinforcement_weight();
	if ( r_weight_temp > r_weight ) then
		r_weight = r_weight_temp;
		s_index = 3;
	end

	// return
	s_index;
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e8_m2_ai_phantom_start()
local vehicle vh_phantom = spops_ai_get_vehicle( ai_current_actor );
local ai ai_squad = ai_get_squad_safe( ai_current_actor );
local boolean b_cargo = TRUE;
local short s_loaded_cnt = 0;

	// ----------------------------------------------------------
	//	INIT
	// ----------------------------------------------------------
	object_set_scale( vh_phantom, 0.0001, 0 );
	object_hide( vh_phantom, TRUE );
	object_cannot_take_damage( vh_phantom );
	ai_braindead( ai_get_squad(ai_current_actor), TRUE );
	ai_set_blind( ai_get_squad(ai_current_actor), TRUE );
	ai_set_deaf( ai_get_squad(ai_current_actor), TRUE );
	cs_ignore_obstacles( TRUE );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	object_immune_to_friendly_damage(  vh_phantom, TRUE );
	
	// ----------------------------------------------------------
	//	LOAD
	// ----------------------------------------------------------
	// wait for good time to start loading
	//dprint( "cs_e8_m2_ai_phantom_start: LOAD: PRE" );
	sleep_until(
		( not f_e8_m2_ai_phantom_loading_check() )
		and
		(
			( not f_e8_m2_ai_phantom_delivering_check() )
			or
			( f_e8_m2_artillery_living_cnt() == 0 )
		)
	, 1 );
	//dprint( "cs_e8_m2_ai_phantom_start: LOAD: START" );

	if ( S_e8_m2_phantom_manage_cnt > 0 ) then

		// set as loading phantom
		f_e8_m2_ai_phantom_loading( vh_phantom );
	
		// notify start
		NotifyLevel( STR_e8_m2_phantom_status_load_start );
		
		repeat

			// check if cargo still needs loading
			if ( b_cargo ) then
				b_cargo = not spops_phantom_cargo_occupied( vh_phantom );
			end

			sleep_until( (ai_living_count(gr_e8_m2_all) < S_e8_m2_ai_spawn_pool_phantom_max) or (f_e8_m2_artillery_living_cnt() == 0), 10 );
			
			s_loaded_cnt = f_e8m2_ai_place_phantom( vh_phantom, s_loaded_cnt, b_cargo );

		until( ((s_loaded_cnt >= 6) and (s_loaded_cnt >= ai_living_count(gr_e8_m2_enemy_unit_all))) or (f_e8_m2_artillery_living_cnt() == 0), 10 );
		
		if ( f_e8_m2_artillery_living_cnt() == 0 ) then
			b_e8_m2_phantom_loading_extractable = TRUE;
			sleep_until( FALSE );
		end
		
		// reset loading phantom because this one is done
		f_e8_m2_ai_phantom_loading_reset( vh_phantom );
	
		// notify end
		NotifyLevel( STR_e8_m2_phantom_status_load_end );
	
		//dprint( "cs_e8_m2_ai_phantom_start: LOAD: END" );
	end

	// check if the phantom is not loaded and destroy it if it's empty
	if ( (s_loaded_cnt == 0) and (object_at_marker(vh_phantom, "small_cargo01") == NONE) and (object_at_marker(vh_phantom, "small_cargo02") == NONE) and (object_at_marker(vh_phantom, "large_cargo") == NONE) ) then
		//dprint( "cs_e8_m2_ai_phantom_start: ERASE" );
		//inspect( ai_living_count(ai_squad) );
		//inspect( spops_phantom_occupied_cargo_cnt(vh_phantom, "CARGO") );
		object_destroy( vh_phantom );
		ai_erase( ai_current_actor );
	end

	// ----------------------------------------------------------
	//	DELIVER
	// ----------------------------------------------------------
	local short s_artillery_index = 0;
	local object obj_artillery = NONE;
	
	// wait for no one to be delivering
	sleep_until( (not f_e8_m2_ai_phantom_delivering_check()) and (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 6 );
	//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: START" );
	
	// set as delivering phantom
	f_e8_m2_ai_phantom_delivering( vh_phantom );
	
	// dialog
	thread( f_e8_m2_dialog_phantom() );

	// notify load start
	NotifyLevel( STR_e8_m2_phantom_status_deliver_start );

	// wait for no one to be defending
	sleep_until( not f_e8_m2_ai_phantom_defending_check(), 6 );
	spops_audio_music_event( 'play_mus_pve_e08m2_phantom_incoming', "play_mus_pve_e08m2_phantom_incoming" );

	// calculate which artillery needs reinforcements
	repeat
		s_artillery_index = f_e8_m2_ai_phantom_artillery_weighted_get();
	until( (s_artillery_index != 0) or (f_e8_m2_artillery_living_cnt() == 0), 1 );
	//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: LOC" );
	//inspect( s_artillery_index );
	
	// grab a deliver location
	local point_reference pr_drop_loc = f_e8_m2_ai_phantom_deliver_artillery_index_loc( vh_phantom, s_artillery_index );
	static point_reference pr_drop_last = ps_e8_m2_lz_phantom_deliver_xtr.top;
	
	// if this is the same as the last loc, give it another college try to get a different one
	if ( pr_drop_loc == pr_drop_last ) then
		//dprint( "cs_e8_m2_ai_phantom_start: RE-ROLL" );
		pr_drop_loc = f_e8_m2_ai_phantom_deliver_artillery_index_loc( vh_phantom, s_artillery_index );
	end

	// restore settings
	object_can_take_damage( vh_phantom );
	ai_braindead( ai_get_squad(ai_current_actor), FALSE );
	ai_set_blind( ai_get_squad(ai_current_actor), FALSE );
	ai_set_deaf( ai_get_squad(ai_current_actor), FALSE );
	object_hide( vh_phantom, FALSE );

	// scale in
	object_set_scale( vh_phantom, 1.0, seconds_to_frames(3.0) );
	sleep_s( 0.5 );
	
	// if LZ fly to the start location first
	if ( f_e8_m2_ai_phantom_deliver_loc_is_lz(pr_drop_loc) ) then
		cs_fly_by( ps_e8_m2_lz_phantom_deliver_xtr.top, 15.0 );
		cs_vehicle_speed( 0.75 );
	end

	// fly to drop off location
	repeat
	
		// get artillery obj
		obj_artillery = f_e8_m2_artillery_index_get( s_artillery_index );
	
		//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: FLY" );
		//inspect( objects_distance_to_point(vh_phantom, pr_drop_loc) );
		
		cs_fly_to( pr_drop_loc );

		// check if ai needs a new location
		if ( (s_artillery_index != 0) and (object_get_health(obj_artillery) <= 0.0) and (f_e8_m2_artillery_living_cnt() > 0) ) then
			//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: LOC: NEW" );
		
			// try and grab an artillery that needs it the most
			s_artillery_index = f_e8_m2_ai_phantom_artillery_weighted_get();

			// if no one needs backup, add to the nearest
			if ( (s_artillery_index == 0) and (f_e8_m2_artillery_living_cnt() > 0) ) then
				s_artillery_index = f_e8_m2_artillery_nearest_index( vh_phantom );
			end
			
			// get new location
			pr_drop_loc = f_e8_m2_ai_phantom_deliver_artillery_index_loc( vh_phantom, s_artillery_index );
			//inspect( s_artillery_index );

			// if LZ fly to the start location first
			if ( f_e8_m2_ai_phantom_deliver_loc_is_lz(pr_drop_loc) ) then
				cs_fly_by( ps_e8_m2_lz_phantom_deliver_xtr.top, 10.0 );
			end
		
		end
		
	until( (objects_distance_to_point(vh_phantom, pr_drop_loc) <= 7.5), 1 );

	// store last loc
	pr_drop_last = pr_drop_loc;

	cs_vehicle_speed( 0.25 );
	cs_fly_to_and_dock( pr_drop_loc, pr_drop_loc, 2.5 );
	cs_vehicle_speed( 1.0 );

	//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: UNLOAD" );
	NotifyLevel( STR_e8_m2_phantom_status_deliver_unload );
	spops_audio_music_event( 'play_mus_pve_e08m2_phantom_unloading', "play_mus_pve_e08m2_phantom_unloading" );

	// disable ai
	ai_braindead( ai_current_actor, TRUE );
	ai_set_blind( ai_current_actor, TRUE );
	ai_set_deaf( ai_current_actor, TRUE );
	
	sleep_s( 1.0 );
	spops_phantom_unload( vh_phantom );
	
	// enable ai
	ai_braindead( ai_current_actor, FALSE );
	ai_set_blind( ai_current_actor, FALSE );
	ai_set_deaf( ai_current_actor, FALSE );
	
	// reset delivering phantom because this one is done
	f_e8_m2_ai_phantom_delivering_reset( vh_phantom );

	// notify end
	NotifyLevel( STR_e8_m2_phantom_status_deliver_end );

	//dprint( "cs_e8_m2_ai_phantom_start: DELIVER: END" );

	// ----------------------------------------------------------
	//	DEFEND
	// ----------------------------------------------------------

	if ( f_e8_m2_ai_phantom_defend_enabled() and (not f_e8_m2_ai_phantom_defending_check()) ) then
		f_e8_m2_ai_phantom_defending( vh_phantom );
		spops_audio_music_event( 'play_mus_pve_e08m2_phantom_defending', "play_mus_pve_e08m2_phantom_defending" );
		thread( f_e8_m2_ai_phantom_defend_manage(ai_current_actor, vh_phantom) );
	else
		cs_run_command_script( ai_current_actor, cs_e8_m2_ai_phantom_exit );
	end

end

script command_script cs_e8_m2_ai_phantom_exit()
local vehicle vh_phantom = spops_ai_get_vehicle( ai_current_actor );
local real r_scale_time = real_random_range( 4.0, 5.0 );
	//dprint( "cs_e8_m2_ai_phantom_exit" );
	cs_ignore_obstacles ( TRUE );
	// check for kamikaze

	NotifyLevel( STR_e8_m2_phantom_status_exit_start );
	spops_audio_music_event( 'play_mus_pve_e08m2_phantom_leaving', "play_mus_pve_e08m2_phantom_leaving" );

	local point_reference pr_exit_loc = ai_nearest_point( vh_phantom, ps_e8_m2_lz_phantom_deliver );
	if ( objects_distance_to_point(vh_phantom, pr_exit_loc) <= 10.0 ) then
		//dprint( "cs_e8_m2_ai_phantom_exit: IN LZ" );
		
		if ( f_e8_m2_ai_phantom_deliver_loc_is_lz_left(pr_exit_loc) ) then
			pr_exit_loc = ps_e8_m2_lz_phantom_deliver_xtr.l_top;
		elseif ( f_e8_m2_ai_phantom_deliver_loc_is_lz_right(pr_exit_loc) ) then
			pr_exit_loc = ps_e8_m2_lz_phantom_deliver_xtr.r_top;
		else
			pr_exit_loc = ps_e8_m2_lz_phantom_deliver_xtr.top;
		end
		cs_face ( TRUE, pr_exit_loc );
		sleep_s(3);
		cs_fly_by( ai_current_actor, TRUE, pr_exit_loc );
		cs_face ( FALSE, pr_exit_loc );
	end

	//dprint( "cs_e8_m2_ai_phantom_exit: LEAVING" );
	cs_vehicle_speed( 1.0 );
	pr_exit_loc = f_e8_m2_ai_phantom_point_loc( vh_phantom, ps_e8_m2_phantom_exit_near );
	cs_face ( TRUE, pr_exit_loc );
	//sleep_s(3);
	cs_fly_by( ai_current_actor, TRUE, pr_exit_loc );
	cs_face ( FALSE, pr_exit_loc );
	//dprint( "f_e8_m2_ai_phantom_exit: EXIT" );
	pr_exit_loc = ai_nearest_point( vh_phantom, ps_e8_m2_phantom_exit_far );
	object_set_scale( vh_phantom, 0.0001, seconds_to_frames(r_scale_time) );
	cs_fly_by( ai_current_actor, FALSE, pr_exit_loc );
	sleep_s( r_scale_time );

	NotifyLevel( STR_e8_m2_phantom_status_exit_end );

	//dprint( "f_e8_m2_ai_phantom_exit: CLEANUP" );
	object_destroy( vh_phantom );

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_e8_m2_ai_phantoms_manage_disable_body_count( short s_level, short s_body_count )
	
	s_body_count = f_e8_m2_body_count_enemy_all() + s_body_count;

	sleep_until( (S_e8_m2_ai_level > s_level) or (S_e8_m2_phantom_manage_cnt <= 0) or (f_e8_m2_body_count_enemy_all() >= s_body_count), 10 );
	if ( S_e8_m2_ai_level == s_level ) then
		S_e8_m2_phantom_manage_cnt = 0;
	end

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: INIT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: LOAD ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static object OBJ_e8_m2_phantom_loading = 						NONE;
static boolean b_e8_m2_phantom_loading_extractable = 	FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_phantom_loading::: xxx
script static void f_e8_m2_ai_phantom_loading( object obj_phantom )

	if ( obj_phantom != OBJ_e8_m2_phantom_loading ) then
		//dprint( "f_e8_m2_ai_phantom_loading" );
		OBJ_e8_m2_phantom_loading = obj_phantom;
	end
	
end
script static object f_e8_m2_ai_phantom_loading()
	OBJ_e8_m2_phantom_loading;
end
script static void f_e8_m2_ai_phantom_loading_reset( object obj_phantom )
	if ( f_e8_m2_ai_phantom_loading() == obj_phantom ) then
		f_e8_m2_ai_phantom_loading( NONE );
	end
end
script static boolean f_e8_m2_ai_phantom_loading_check()
	object_get_health( f_e8_m2_ai_phantom_loading() ) > 0.0;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: DELIVER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static object OBJ_e8_m2_phantom_delivering = 						NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_phantom_delivering::: xxx
script static void f_e8_m2_ai_phantom_delivering( object obj_phantom )

	if ( obj_phantom != OBJ_e8_m2_phantom_delivering ) then
		//dprint( "f_e8_m2_ai_phantom_delivering" );
		OBJ_e8_m2_phantom_delivering = obj_phantom;
	end
	
end
script static object f_e8_m2_ai_phantom_delivering()
	OBJ_e8_m2_phantom_delivering;
end
script static void f_e8_m2_ai_phantom_delivering_reset( object obj_phantom )
	if ( f_e8_m2_ai_phantom_delivering() == obj_phantom ) then
		f_e8_m2_ai_phantom_delivering( NONE );
	end
end
script static boolean f_e8_m2_ai_phantom_delivering_check()
	object_get_health( f_e8_m2_ai_phantom_delivering() ) > 0.0;
end

// === f_e8_m2_ai_phantom_deliver_artillery_index_loc::: xxx
script static point_reference f_e8_m2_ai_phantom_deliver_artillery_index_loc( object obj_reference, short s_index )

	if ( s_index == 1 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a01_phantom_deliver );
	elseif ( s_index == 2 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a02_phantom_deliver );
	elseif ( s_index == 3 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a03_phantom_deliver );
	else
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_lz_phantom_deliver );
	end

end

// === f_e8_m2_ai_phantom_deliver_loc_is_lz::: Checks if the location for a drop is at the LZ
script static boolean f_e8_m2_ai_phantom_deliver_loc_is_lz( point_reference pr_loc )
	f_e8_m2_ai_phantom_deliver_loc_is_lz_left(pr_loc) or f_e8_m2_ai_phantom_deliver_loc_is_lz_right(pr_loc);
end

// === f_e8_m2_ai_phantom_deliver_loc_is_lz::: Checks if the location for a drop is at the LZ
script static boolean f_e8_m2_ai_phantom_deliver_loc_is_lz_left( point_reference pr_loc )
	( ps_e8_m2_lz_phantom_deliver.l_0 == pr_loc ) or ( ps_e8_m2_lz_phantom_deliver.l_1 == pr_loc );
end

// === f_e8_m2_ai_phantom_deliver_loc_is_lz::: Checks if the location for a drop is at the LZ
script static boolean f_e8_m2_ai_phantom_deliver_loc_is_lz_right( point_reference pr_loc )
	( ps_e8_m2_lz_phantom_deliver.r_0 == pr_loc ) or ( ps_e8_m2_lz_phantom_deliver.r_1 == pr_loc );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: DEFEND ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static object OBJ_e8_m2_phantom_defending = 						NONE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static boolean f_e8_m2_ai_phantom_defend_enabled()
	FALSE;
	//( f_e8_m2_artillery_living_cnt() > 0 ) and ( (S_e8_m2_ai_level > 2) and (S_e8_m2_ai_level < 4) ) or ( (S_e8_m2_ai_level == 2) and f_e8_m2_ai_phantom_loading_check() );
end

// === f_e8_m2_ai_phantom_defend_manage::: xxx
script static void f_e8_m2_ai_phantom_defend_manage( ai ai_driver, vehicle vh_phantom )

	local short s_artillery_index = 0;
	local object obj_artillery = 0;
	local long l_timer = timer_stamp( 45.0, 60.0 );

	NotifyLevel( STR_e8_m2_phantom_status_defend_start );

	// get an artillery who needs help
	s_artillery_index = f_e8_m2_ai_phantom_artillery_weighted_get();
		
	if ( s_artillery_index != 0 ) then
	
		//dprint( "f_e8_m2_ai_phantom_defend" );
		
		//inspect( s_artillery_index );
		obj_artillery = f_e8_m2_artillery_index_get( s_artillery_index );
		cs_vehicle_speed( ai_driver, 0.25 );
		cs_fly_to( ai_driver, TRUE, f_e8_m2_ai_phantom_defend_artillery_index_loc( vh_phantom, s_artillery_index ) );
		cs_vehicle_speed( ai_driver, 0.125 );
		
		sleep_until( f_e8_m2_ai_phantom_delivering_check() or timer_expired(l_timer) or (not f_e8_m2_ai_phantom_defending_check()) or (spops_phantom_turrets_occupied_cnt(vh_phantom) <= 1), 6);
		
	end

	if ( object_get_health(vh_phantom) > 0.0 ) then
		f_e8_m2_ai_phantom_defending_reset( vh_phantom );
		NotifyLevel( STR_e8_m2_phantom_status_defend_end );
		cs_run_command_script( ai_driver, cs_e8_m2_ai_phantom_exit );
	end

end

// === f_e8_m2_ai_phantom_defend_artillery_index_loc::: xxx
script static point_reference f_e8_m2_ai_phantom_defend_artillery_index_loc( object obj_reference, short s_index )

	if ( s_index == 1 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a01_phantom_defend );
	elseif ( s_index == 2 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a02_phantom_defend );
	elseif ( s_index == 3 ) then
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_a03_phantom_defend );
	else
		f_e8_m2_ai_phantom_point_loc( obj_reference, ps_e8_m2_lz_phantom_defend );
	end

end

// === f_e8_m2_ai_phantom_defending::: xxx
script static void f_e8_m2_ai_phantom_defending( object obj_phantom )

	if ( obj_phantom != OBJ_e8_m2_phantom_defending ) then
		//dprint( "f_e8_m2_ai_phantom_defending" );
		OBJ_e8_m2_phantom_defending = obj_phantom;
	end
	
end
script static object f_e8_m2_ai_phantom_defending()
	OBJ_e8_m2_phantom_defending;
end
script static void f_e8_m2_ai_phantom_defending_reset( object obj_phantom )
	if ( obj_phantom == OBJ_e8_m2_phantom_defending ) then
		f_e8_m2_ai_phantom_defending( NONE );
	end
end
script static boolean f_e8_m2_ai_phantom_defending_check()
	object_get_health( f_e8_m2_ai_phantom_defending() ) > 0.0;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: EXIT ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: LZ ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static long L_e8_m2_ai_phantom_lz_a_loading = 						0;
static long L_e8_m2_ai_phantom_lz_b_loading = 						0;
global short S_e8_m2_ai_phantom_lz_waiting = 							2;
global short S_e8_m2_ai_phantom_lz_delivering = 					0;
global short S_e8_m2_ai_phantom_lz_dropping = 						0;
global boolean B_e8_m2_ai_phantom_lz_drop_ready = 				FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script dormant f_e8_m2_ai_phantom_lz_start()
	//dprint( "f_e8_m2_ai_phantom_lz_start" );

	f_e8_m2_ai_phantoms_manage_cnt( 0, -1 );

	// adjust ai counts
	S_e8_m2_ai_spawn_pool_grunt_lives = 0;
	S_e8_m2_ai_spawn_pool_grunt_max = 0;
	f_e8_m2_ai_pool_lives_elite_leader( -1, -1, -1, -1, 1.0, 1.0, 1.0, 1.0 );
	f_e8_m2_ai_pool_lives_elite_basic( -1, -1, -1, -1, 1.0, 1.0, 1.0, 1.0 );
	f_e8_m2_ai_pool_max_elite_leader( 10, 10, 10, 10, 1.0, 1.0, 1.0, 1.0 );
	f_e8_m2_ai_pool_max_elite_basic( 10, 10, 10, 10, 1.0, 1.0, 1.0, 1.0 );

	// make so no phantoms are not still delivering
	sleep_until( (f_e8_m2_rendezvous_state() >= DEF_E8M2_RENDEZVOUS_STATE_PHANTOMS) and (not f_e8_m2_ai_phantom_delivering_check()), 6 );
	
	// wait for phantoms to have left the area
	sleep_until( not volume_test_objects(tv_e8_m2_play_area_rough, ai_actors(gr_e8_m2_enemy_phantoms)), 15 );
	
	// start the phantoms
	S_e8_m2_ai_spawn_pool_phantom_max = 18;
	wake( f_e8_m2_ai_phantom_lz_a_start );
	wake( f_e8_m2_ai_phantom_lz_b_start );

end
	
script static boolean f_e8_m2_ai_phantom_lz_complete()
	S_e8_m2_ai_phantom_lz_waiting <= 0;
end

script dormant f_e8_m2_ai_phantom_lz_a_start()
	//dprint( "f_e8_m2_ai_phantom_lz_a_start" );

	sleep_until( L_e8_m2_ai_phantom_lz_b_loading != 0, 1 );
	sleep_until( ai_living_count(sq_e8m2_phantom_lz_b) <= 0, 10 );
	ai_place( sq_e8m2_phantom_lz_a );

end
script static void f_e8_m2_ai_phantom_lz_a_load( vehicle vh_phantom )
	sleep_until( not isthreadvalid(L_e8_m2_ai_phantom_lz_b_loading), 1 );
	L_e8_m2_ai_phantom_lz_a_loading = thread( f_e8_m2_ai_phantom_load_lz(vh_phantom) );
end
script static boolean f_e8_m2_ai_phantom_lz_a_load_complete()
	( L_e8_m2_ai_phantom_lz_a_loading != 0 ) and ( not isthreadvalid(L_e8_m2_ai_phantom_lz_a_loading) );
end

script dormant f_e8_m2_ai_phantom_lz_b_start()
	//dprint( "f_e8_m2_ai_phantom_lz_b_start" );
	f_e8_m2_ai_pool_max_inc( 4 ); // make room for vehicles
	ai_place( sq_e8m2_phantom_lz_b );

end
script static void f_e8_m2_ai_phantom_lz_b_load( vehicle vh_phantom )
	
	L_e8_m2_ai_phantom_lz_b_loading = thread( f_e8_m2_ai_phantom_load_lz(vh_phantom) );
end
script static boolean f_e8_m2_ai_phantom_lz_b_load_complete()
	( L_e8_m2_ai_phantom_lz_b_loading != 0 ) and ( not isthreadvalid(L_e8_m2_ai_phantom_lz_b_loading) );
end

script static void f_e8_m2_ai_phantom_cargo_swap( object obj_phantom_a, object obj_phantom_b, string_id sid_marker )
local object obj_swap = object_at_marker( obj_phantom_a, sid_marker );

	if ( obj_swap != NONE ) then
		//dprint( "f_e8_m2_ai_phantom_cargo_swap: SWAP" );
		objects_detach( obj_phantom_a, obj_swap );
		sleep( 1 );
		objects_attach( obj_phantom_b, sid_marker, obj_swap, "" );
	end

end

script command_script cs_e8_m2_ai_phantom_lz_a()
local vehicle vh_phantom = spops_ai_get_vehicle( ai_current_actor );
local ai ai_placed = NONE;
local boolean b_loaded = FALSE;
	
	//dprint( "cs_e8_m2_ai_phantom_lz_a: INIT" );
	object_set_scale( vh_phantom, 0.0001, 0 );
	object_hide( vh_phantom, TRUE );
	object_cannot_take_damage( vh_phantom );
	object_cannot_die( vh_phantom, TRUE );
	ai_braindead( ai_get_squad(ai_current_actor), TRUE );
	ai_set_blind( ai_get_squad(ai_current_actor), TRUE );
	ai_set_deaf( ai_get_squad(ai_current_actor), TRUE );
	cs_ignore_obstacles( TRUE );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	object_immune_to_friendly_damage( vh_phantom, TRUE );

	// try to load hunters if they haven't loaded already
	b_loaded = ( object_at_marker(vh_phantom, "small_cargo01") != NONE ) or ( object_at_marker(vh_phantom, "small_cargo02") != NONE ) or ( object_at_marker(vh_phantom, "large_cargo") != NONE );
	if ( (not b_loaded) and (ai_placed == NONE) and (ai_living_count(gr_e8_m2_enemy_hunter_pool) <= 1) ) then
	
		// hunter 01
		ai_placed = f_e8_m2_ai_pool_hunter( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: HUNTER 01 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo01", ai_get_object(ai_placed), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo01", ai_placed );
			//s_cnt = s_cnt + 1;
			
			// place hunter 2
			ai_placed = f_e8_m2_ai_pool_hunter( S_e8_m2_ai_level );
		end

		// hunter 02
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: HUNTER 02 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo02", ai_get_object(ai_placed), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo02", ai_placed );
			//s_cnt = s_cnt + 1;
		end
		
	end
	
	// take anything from the loading phantom
	b_loaded = ( object_at_marker(vh_phantom, "small_cargo01") != NONE ) or ( object_at_marker(vh_phantom, "small_cargo02") != NONE ) or ( object_at_marker(vh_phantom, "large_cargo") != NONE );
	if ( (not b_loaded) and f_e8_m2_ai_phantom_loading_check() ) then
		sleep_until( b_e8_m2_phantom_loading_extractable or (not f_e8_m2_ai_phantom_loading_check()), 1 );
		if ( f_e8_m2_ai_phantom_loading_check() ) then
			//dprint( "cs_e8_m2_ai_phantom_lz_a: CARGO SWAP" );
			f_e8_m2_ai_phantom_cargo_swap( f_e8_m2_ai_phantom_loading(), vh_phantom, "small_cargo01" );
			f_e8_m2_ai_phantom_cargo_swap( f_e8_m2_ai_phantom_loading(), vh_phantom, "small_cargo02" );
			f_e8_m2_ai_phantom_cargo_swap( f_e8_m2_ai_phantom_loading(), vh_phantom, "large_cargo" );
		end
	end
	if ( f_e8_m2_ai_phantom_loading_check() ) then
		object_destroy( f_e8_m2_ai_phantom_loading() );
	end

	// try to load ghosts if they haven't loaded already
	b_loaded = ( object_at_marker(vh_phantom, "small_cargo01") != NONE ) or ( object_at_marker(vh_phantom, "small_cargo02") != NONE ) or ( object_at_marker(vh_phantom, "large_cargo") != NONE );
	if ( (not b_loaded) and (ai_placed == NONE) and (ai_living_count(gr_e8_m2_enemy_ghost_pool) <= 1) ) then
		// ghost 01
		ai_placed = f_e8_m2_ai_pool_ghost( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: GHOST 01 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo01", ai_vehicle_get_from_squad(ai_placed, 0), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo01", ai_placed );
			//s_cnt = s_cnt + 1;

			// place second ghost
			ai_placed = f_e8_m2_ai_pool_ghost( S_e8_m2_ai_level );
		end

		// ghost 02
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: GHOST 02 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo02", ai_vehicle_get_from_squad(ai_placed, 0), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo02", ai_placed );
			//s_cnt = s_cnt + 1;
		end

	end
	
	// setup loading
	thread( f_e8_m2_ai_phantom_lz_a_load(vh_phantom) );

	// restore settings
	//dprint( "cs_e8_m2_ai_phantom_lz_a: RESTORE" );
	object_can_take_damage( vh_phantom );
	ai_braindead( ai_get_squad(ai_current_actor), FALSE );
	ai_set_blind( ai_get_squad(ai_current_actor), FALSE );
	ai_set_deaf( ai_get_squad(ai_current_actor), FALSE );
	object_hide( vh_phantom, FALSE );

	// scale in
	object_set_scale( vh_phantom, 1.0, seconds_to_frames(3.0) );

	//dprint( "cs_e8_m2_ai_phantom_lz_a: INCOMING" );
	S_e8_m2_ai_phantom_lz_delivering = S_e8_m2_ai_phantom_lz_delivering + 1;
	cs_fly_by( ps_e8m2_phantom_lz_a.in_00, 7.5 );
	cs_fly_by( ps_e8m2_phantom_lz_a.in_01, 7.5 );
	cs_fly_by( ps_e8m2_phantom_lz_a.in_02, 7.5 );
	cs_vehicle_speed( 0.50 );
	cs_fly_by( ps_e8m2_phantom_lz_a.in_03, 5.0 );

	// wait for turn to deliver	
	sleep_until( f_e8_m2_ai_phantom_lz_a_load_complete(), 1 );
	S_e8_m2_ai_phantom_lz_dropping = S_e8_m2_ai_phantom_lz_dropping + 1;

	sleep_until( B_e8_m2_ai_phantom_lz_drop_ready and (not f_e8_m2_ai_phantom_delivering_check()), 1 );
	//dprint( "cs_e8_m2_ai_phantom_lz_a: DROP" );
	f_e8_m2_ai_phantom_delivering( vh_phantom );
	cs_vehicle_speed( 0.25 );
	cs_fly_to_and_dock( ps_e8m2_phantom_lz_a.drop_00, ps_e8m2_phantom_lz_a.drop_00, 2.5 );

	//dprint( "cs_e8_m2_ai_phantom_lz_a: UNLOAD" );
	spops_phantom_unload( vh_phantom );
	f_e8_m2_ai_phantom_delivering_reset( vh_phantom );
	sleep_s( 3.0 );
	sleep_until( f_e8_m2_ai_phantom_delivering_check() or (ai_living_count(sq_e8m2_phantom_lz_b) <= 0), 10 );

	//dprint( "cs_e8_m2_ai_phantom_lz_a: OUT" );
	cs_vehicle_speed( 0.50 );
	cs_fly_by( ps_e8m2_phantom_lz_a.out_00, 5.0 );
	cs_vehicle_speed( 1.0 );
	cs_fly_by( ps_e8m2_phantom_lz_a.out_01, 5.0 );
	S_e8_m2_ai_phantom_lz_waiting = S_e8_m2_ai_phantom_lz_waiting - 1;
	cs_fly_by( ps_e8m2_phantom_lz_a.out_02, 5.0 );
	
	object_set_scale( vh_phantom, 0.0001, seconds_to_frames(5.0) );
	cs_fly_by( ps_e8m2_phantom_lz_a.out_03, 7.5 );

	//dprint( "cs_e8_m2_ai_phantom_lz_a: COMPLETE" );
	effects_perf_armageddon = 0;
	object_destroy( vh_phantom );
	
end

script command_script cs_e8_m2_ai_phantom_lz_b()
local vehicle vh_phantom = spops_ai_get_vehicle( ai_current_actor );
local ai ai_placed = NONE;
	
	//dprint( "cs_e8_m2_ai_phantom_lz_b: INIT" );
	object_set_scale( vh_phantom, 0.0001, 0 );
	object_hide( vh_phantom, TRUE );
	object_cannot_take_damage( vh_phantom );
	object_cannot_die( vh_phantom, TRUE );
	ai_braindead( ai_get_squad(ai_current_actor), TRUE );
	ai_set_blind( ai_get_squad(ai_current_actor), TRUE );
	ai_set_deaf( ai_get_squad(ai_current_actor), TRUE );
	cs_ignore_obstacles( TRUE );
	cs_abort_on_alert( FALSE );
	cs_abort_on_damage( FALSE );
	object_immune_to_friendly_damage( vh_phantom, TRUE );
	effects_perf_armageddon = 1;

	//dprint( "cs_e8_m2_ai_phantom_lz_b: LOAD: WRAITH" );
	f_e8_m2_ai_pool_lives_wraith( 1, 1, 1, 1, 1.0, 1.0, 1.0, 1.0 );
	ai_placed = NONE;
	repeat
		ai_placed = f_e8_m2_ai_pool_wraith( S_e8_m2_ai_level );
	until( ai_placed != NONE, 1 );
	spops_phantom_load_cargo_large( vh_phantom, ai_vehicle_get_from_squad(ai_placed, 0) );
	f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "large_cargo", ai_placed );
	
	// setup loading
	thread( f_e8_m2_ai_phantom_lz_b_load(vh_phantom) );

	// restore settings
	//dprint( "cs_e8_m2_ai_phantom_lz_b: RESTORE" );
	object_can_take_damage( vh_phantom );
	ai_braindead( ai_get_squad(ai_current_actor), FALSE );
	ai_set_blind( ai_get_squad(ai_current_actor), FALSE );
	ai_set_deaf( ai_get_squad(ai_current_actor), FALSE );
	object_hide( vh_phantom, FALSE );

	// scale in
	object_set_scale( vh_phantom, 1.0, seconds_to_frames(3.0) );

	//dprint( "cs_e8_m2_ai_phantom_lz_b: INCOMING" );
	S_e8_m2_ai_phantom_lz_delivering = S_e8_m2_ai_phantom_lz_delivering + 1;
	cs_fly_by( ps_e8m2_phantom_lz_b.in_00, 7.5 );
	cs_fly_by( ps_e8m2_phantom_lz_b.in_01, 7.5 );
	cs_fly_by( ps_e8m2_phantom_lz_b.in_02, 7.5 );
	cs_vehicle_speed( 0.50 );
	cs_fly_by( ps_e8m2_phantom_lz_b.in_03, 5.0 );
	
	// wait for turn to deliver	
	sleep_until( f_e8_m2_ai_phantom_lz_b_load_complete(), 1 );
	S_e8_m2_ai_phantom_lz_dropping = S_e8_m2_ai_phantom_lz_dropping + 1;

	sleep_until( B_e8_m2_ai_phantom_lz_drop_ready and (not f_e8_m2_ai_phantom_delivering_check()), 1 );
	//dprint( "cs_e8_m2_ai_phantom_lz_b: DROP" );
	f_e8_m2_ai_phantom_delivering( vh_phantom );
	cs_vehicle_speed( 0.25 );
	cs_fly_to_and_dock( ps_e8m2_phantom_lz_b.drop_00, ps_e8m2_phantom_lz_b.drop_00, 3.0 );

	//dprint( "cs_e8_m2_ai_phantom_lz_b: UNLOAD" );
	spops_phantom_unload( vh_phantom );
	f_e8_m2_ai_phantom_delivering_reset( vh_phantom );
	sleep_s( 3.0 );
	sleep_until( f_e8_m2_ai_phantom_delivering_check() or (ai_living_count(sq_e8m2_phantom_lz_a) <= 0), 1 );
	
	// start lz watchers
	wake( f_e8_m2_ai_lz_watchers_start );

	//dprint( "cs_e8_m2_ai_phantom_lz_b: OUT" );
	cs_vehicle_speed( 0.25 );
	S_e8_m2_ai_phantom_lz_waiting = S_e8_m2_ai_phantom_lz_waiting - 1;
	cs_fly_by( ps_e8m2_phantom_lz_b.out_00, 5.0 );
	cs_vehicle_speed( 0.50 );
	cs_fly_by( ps_e8m2_phantom_lz_b.out_01, 5.0 );
	cs_vehicle_speed( 1.0 );
	cs_fly_by( ps_e8m2_phantom_lz_b.out_02, 5.0 );
	cs_fly_by( ps_e8m2_phantom_lz_b.out_03, 7.5 );
	object_set_scale( vh_phantom, 0.0001, seconds_to_frames(5.0) );
	cs_fly_by( ps_e8m2_phantom_lz_b.out_04, 7.5 );

	//dprint( "cs_e8_m2_ai_phantom_lz_b: COMPLETE" );
	object_destroy( vh_phantom );
	
end

script static void f_e8_m2_ai_phantom_load_lz( vehicle vh_phantom )
local ai ai_placed = NONE;
local short s_cnt = 0;
local short s_tot = 0;
local short s_unspawned = 0;
	e8_m2_SpawningInPhantom = e8_m2_SpawningInPhantom + 1;
	sleep(10); // make sure the loc placement script, if running, finishes spawning its guy.
	// elite leaders
	s_cnt = sys_e8_m2_ai_pool_count_set( 0, 0, 1, 1,1, 1 );
	s_tot = s_cnt + sys_e8_m2_ai_pool_count_set( 0, 0, 1, 2, 2, 2 );
	s_tot = s_tot +  sys_e8_m2_ai_pool_count_set( 0, 0, 2, 2, 2, 2 );
	sleep_until((ai_living_count(gr_e8_m2_all) < (S_e8_m2_ai_spawn_pool_phantom_max)-s_tot), 15 );
	
	
	repeat

		ai_placed = f_e8_m2_ai_pool_elite_leader( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			spops_phantom_load_ai( vh_phantom, ai_placed, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE );
			f_e8m2_ai_place_phantom_seat_switch( vh_phantom, ai_placed );
			s_cnt = s_cnt - 1;
		else
			s_unspawned = s_cnt;
			s_cnt = 0;
		end

	until( s_cnt <= 0, 3 );
	
	// elite basic
	s_cnt = s_unspawned + sys_e8_m2_ai_pool_count_set( 0, 0, 1, 2, 3, 4 );
	s_unspawned = 0;
	//sleep_until( (ai_living_count(gr_e8_m2_all) < (S_e8_m2_ai_spawn_pool_phantom_max-s_cnt)), 10 );
	repeat
		ai_placed = f_e8_m2_ai_pool_elite_basic( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			spops_phantom_load_ai( vh_phantom, ai_placed, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE );
			f_e8m2_ai_place_phantom_seat_switch( vh_phantom, ai_placed );
			s_cnt = s_cnt - 1;
		else
			s_unspawned = s_cnt;
			s_cnt = 0;
		end

	until( s_cnt <= 0, 3 );
	
	// jackal
	s_cnt = s_unspawned + sys_e8_m2_ai_pool_count_set( 0, 0, 2, 2, 4, 4 );
	//sleep_until( (ai_living_count(gr_e8_m2_all) < (S_e8_m2_ai_spawn_pool_phantom_max-s_cnt)), 10 );
	repeat
		ai_placed = f_e8_m2_ai_pool_jackal( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			spops_phantom_load_ai( vh_phantom, ai_placed, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE );
			f_e8m2_ai_place_phantom_seat_switch( vh_phantom, ai_placed );
			s_cnt = s_cnt - 1;
		else
			s_unspawned = s_cnt;
			s_cnt = 0;
		end

	until( s_cnt <= 0, 3 );
	
	e8_m2_SpawningInPhantom = e8_m2_SpawningInPhantom - 1;

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: PHANTOM: FINALE ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global object OBJ_e8_m2_phantom_finale = 								NONE;
global boolean B_e8_m2_phantom_kamikaze_setup = 				FALSE;
global boolean B_e8_m2_phantom_kamikaze_start = 				FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_phantom_finale::: xxx
script static void f_e8_m2_ai_phantom_finale( object obj_phantom )

	if ( obj_phantom != OBJ_e8_m2_phantom_finale ) then
		//dprint( "f_e8_m2_ai_phantom_finale" );
		OBJ_e8_m2_phantom_finale = obj_phantom;
	end
	
end
script static object f_e8_m2_ai_phantom_finale()
	OBJ_e8_m2_phantom_finale;
end
script static boolean f_e8_m2_ai_phantom_finale_check()
	object_get_health( OBJ_e8_m2_phantom_finale ) > 0.0;
end
script static boolean f_e8_m2_ai_phantom_finale_on_kamikaze_run()
	B_e8_m2_phantom_kamikaze_start and f_e8_m2_ai_phantom_finale_check();
end
script static boolean f_e8_m2_ai_phantom_finale_complete()
	B_e8_m2_phantom_kamikaze_start and (not f_e8_m2_ai_phantom_finale_check() );
end

script static void f_e8_m2_ai_phantom_kamikaze_explode( object obj_phantom )
	//dprint( "f_e8_m2_ai_phantom_kamikaze_explode" );
	damage_new( 'objects\vehicles\covenant\storm_phantom\damage_effects\storm_phantom_death_explosion.damage_effect', flg_e8_m2_kamikzae_explode );
	spops_phantom_destroy( obj_phantom );
end

script static void f_e8_m2_ai_phantom_kamikaze_show()

	//dprint( "f_e8_m2_ai_phantom_kamikaze_show: WAIT" );
	sleep_until( (not dialog_foreground_active_check()) and f_e8_m2_ai_phantom_lz_complete(), 1 );
	
	// play the show
	//dprint( "f_e8_m2_ai_phantom_kamikaze_show: SHOW" );
	B_e8_m2_phantom_kamikaze_start = TRUE;
	pup_play_show( 'pup_e8_m2_phantom_crash' );
	sleep_s( 1.0 );
	//dprint( "f_e8_m2_ai_phantom_kamikaze_show: DESTROY" );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: SWITCH ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_e8_m2_ai_switch( ai ai_actor, string_id sid_objective_current, boolean b_dialog )
local string_id sid_objective = NONE;
local object obj_target = NONE;
local object obj_actor = ai_get_object( ai_actor );
local object_list ol_squad = ai_actors( ai_get_squad_safe(ai_actor) );
static short s_switch_dlg = 0;
	//dprint( "cs_e8_m2_ai_switch" );
	
	if ( f_e8_m2_ai_artillery_01_enabled() and ((obj_target == NONE) or (objects_distance_to_object(ol_squad,obj_e8m2_artillery_01) < objects_distance_to_object(ol_squad,obj_target))) ) then
		//dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_01" );
		sid_objective = 'objectives_e8m2_artillery_01';
		obj_target = obj_e8m2_artillery_01;
	end
	if ( f_e8_m2_ai_artillery_02_enabled() and ((obj_target == NONE) or (objects_distance_to_object(obj_actor,obj_e8m2_artillery_02) < objects_distance_to_object(obj_actor,obj_target))) ) then
		//dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_02" );
		sid_objective = 'objectives_e8m2_artillery_02';
		obj_target = obj_e8m2_artillery_02;
	end
	if ( f_e8_m2_ai_artillery_03_enabled() and ((obj_target == NONE) or (objects_distance_to_object(obj_actor,obj_e8m2_artillery_03) < objects_distance_to_object(obj_actor,obj_target))) ) then
		//dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_03" );
		sid_objective = 'objectives_e8m2_artillery_03';
		obj_target = obj_e8m2_artillery_03;
	end
	if ( f_e8_m2_artillery_living_cnt() <= 0 ) then
		sid_objective = 'objectives_e8m2_lz';
	end

	// switch objectives
	if ( (sid_objective != NONE) and (sid_objective_current != sid_objective) ) then
		//dprint( "cs_e8_m2_ai_switch: SWITCH" );
		
		// dialog
		if ( b_dialog and (f_e8_m2_artillery_killed_cnt() != s_switch_dlg) ) then
			//dprint( "cs_e8_m2_ai_switch: DIALOG" );
			s_switch_dlg = f_e8_m2_artillery_killed_cnt();
			thread( f_e8_m2_dialog_ai_switch() );
		end
	
		ai_set_objective( ai_get_squad_safe(ai_actor), sid_objective );
	end
	
end
script static void f_e8_m2_ai_switch( ai ai_actor, string_id sid_objective_current )
	f_e8_m2_ai_switch( ai_actor, sid_objective_current, FALSE );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e8_m2_ai_enemy_garbage()
	//dprint( "cs_e8_m2_ai_enemy_garbage" );
	
	ai_set_team( ai_current_actor, DEF_E8_M2_TEAM_CLEANUP );
	ai_set_team( ai_get_squad_safe(ai_current_actor), DEF_E8_M2_TEAM_CLEANUP );
	spops_ai_garbage_erase( ai_get_squad_safe(ai_current_actor) );
	
end
script command_script cs_e8_m2_ai_switch_unsc_lz()
	//dprint( "cs_e8_m2_ai_switch_unsc_lz" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_lz' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_01()
	//dprint( "cs_e8_m2_ai_switch_unsc_artillery_01" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_01' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_02()
	//dprint( "cs_e8_m2_ai_switch_unsc_artillery_02" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_02' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_03()
	//dprint( "cs_e8_m2_ai_switch_unsc_artillery_03" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_03' );
end

script command_script cs_e8_m2_ai_switch_enemy_lz()
	//dprint( "cs_e8_m2_ai_switch_enemy_lz" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_lz' );
end

script command_script cs_e8_m2_ai_switch_enemy_artillery_01()
	//dprint( "cs_e8_m2_ai_switch_enemy_artillery_01" );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_artillery_01_retreat', "play_mus_pve_e08m2_encounter_artillery_01_retreat" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_01', TRUE );
end

script command_script cs_e8_m2_ai_switch_enemy_artillery_02()
	//dprint( "cs_e8_m2_ai_switch_enemy_artillery_02" );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_artillery_02_retreat', "play_mus_pve_e08m2_encounter_artillery_02_retreat" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_02', TRUE );
end

script command_script cs_e8_m2_ai_switch_enemy_artillery_03()
	//dprint( "cs_e8_m2_ai_switch_enemy_artillery_03" );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_artillery_03_retreat', "play_mus_pve_e08m2_encounter_artillery_03_retreat" );
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_03', TRUE );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: INTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_intro_init::: Init
script dormant f_e8_m2_ai_intro_init()
	//dprint( "f_e8_m2_ai_intro_init" );

	// setup trigger
	wake( f_e8_m2_ai_intro_trigger );

end

// === f_e8_m2_ai_intro_trigger::: Trigger
script dormant f_e8_m2_ai_intro_trigger()
	//dprint( "f_e8_m2_ai_intro_trigger" );

	// place
	sleep_until( f_spops_mission_intro_complete() and b_players_are_alive(), 1 );
	wake( f_e8_m2_ai_intro_spawn_enemy );
	
	// encounter started
	sleep_until( (ai_task_count(objectives_e8m2_lz.enemy_combat_gate) > 0) or f_e8_m2_ai_intro_enemy_defeated() or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 1 );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_first_start', "play_mus_pve_e08m2_encounter_lz_first_start" );

	// encounter complete
	sleep_until( f_e8_m2_ai_intro_enemy_defeated() or (S_e8m2_artillery_state >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 6 );
	spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_first_end', "play_mus_pve_e08m2_encounter_lz_first_end" );
	if ( not f_e8_m2_ai_intro_enemy_defeated() ) then
		spops_ai_garbage_erase( sq_e8m2_lz_enemy_start_01_a );
		spops_ai_garbage_erase( sq_e8m2_lz_enemy_start_01_b );
		spops_ai_garbage_erase( sq_e8m2_lz_enemy_start_02_a );
		spops_ai_garbage_erase( sq_e8m2_lz_enemy_start_02_b );
	end

end

script static boolean f_e8_m2_ai_intro_enemy_defeated()
	f_ai_is_defeated( sq_e8m2_lz_enemy_start_01_a ) and f_ai_is_defeated( sq_e8m2_lz_enemy_start_01_b ) and f_ai_is_defeated( sq_e8m2_lz_enemy_start_02_a ) and f_ai_is_defeated( sq_e8m2_lz_enemy_start_02_b );
end

// === f_e8_m2_ai_intro_spartans_load::: Unloads the spartans
script dormant f_e8_m2_ai_intro_spartans_unload()
local long l_timer = 0;
	//dprint( "f_e8_m2_ai_intro_spartans_unload" );

	sleep_until( spops_player_living_cnt() > 0, 1 );

	ai_place( sq_e8m2_lz_unsc_01 );
	ai_place( sq_e8m2_lz_unsc_02 );
	ai_place( sq_e8m2_lz_unsc_03 );
	ai_place( sq_e8m2_lz_unsc_04 );
	
	// spartans greet the players
	sleep_until( f_e8_m2_ai_intro_enemy_defeated(), 6 );
	l_timer = timer_stamp( 30.0 );
	
	// wait for a good moment
	sleep_until( timer_expired(l_timer) or ((not dialog_foreground_active_check()) and (spops_player_living_cnt() > 0) and (objects_distance_to_players(ai_actors(gr_e8_m2_unsc_spartans)) <= 10.0)), 6 );
	
	if ( not timer_expired(l_timer) ) then
		wake( f_e8_m2_dialog_spartans_start );
	end

end

// === f_e8_m2_ai_intro_spawn_enemy::: Spawn
script dormant f_e8_m2_ai_intro_spawn_enemy()
	//dprint( "f_e8_m2_ai_intro_spawn_enemy" );

	// place
	ai_place( sq_e8m2_lz_enemy_start_01_a );
	ai_place( sq_e8m2_lz_enemy_start_01_b );
	ai_place( sq_e8m2_lz_enemy_start_02_a );
	ai_place( sq_e8m2_lz_enemy_start_02_b );
	
	// setup active camo
	spops_ai_active_camo_manager( sq_e8m2_lz_enemy_start_01_a );
	spops_ai_secondary_sword_manage( sq_e8m2_lz_enemy_start_01_a, ai_combat_status_visible, -10.0, 0.0, -1.0 );

	spops_ai_active_camo_manager( sq_e8m2_lz_enemy_start_02_a );
	spops_ai_secondary_sword_manage( sq_e8m2_lz_enemy_start_02_a, ai_combat_status_visible, -10.0, 0.0, -1.0 );

end

// === f_e8_m2_ai_intro_placed::: Checks if the initial group was placed
script static boolean f_e8_m2_ai_intro_placed()
	( ai_spawn_count( sq_e8m2_lz_enemy_start_01_a ) > 0 )
	and
	( ai_spawn_count( sq_e8m2_lz_enemy_start_01_b ) > 0 )
	and
	( ai_spawn_count( sq_e8m2_lz_enemy_start_02_a ) > 0 )
	and
	( ai_spawn_count( sq_e8m2_lz_enemy_start_02_b ) > 0 );
end

// === f_e8_m2_ai_intro_start::: Start audio for the intro scene
script static void f_e8_m2_ai_intro_start()
	dprint( "f_e8_m2_ai_intro_start" );
	
end

// === f_e8_m2_ai_intro_end::: End audio for the intro scene
script static void f_e8_m2_ai_intro_end()
	dprint( "f_e8_m2_ai_intro_end" );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: INTRO: PELICANS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === XXX::: XXX
script static void f_e8_m2_ai_pelican_init( object obj_pelican )

	ai_object_set_team( obj_pelican, human );
	ai_object_enable_targeting_from_vehicle( obj_pelican, TRUE );
	ai_object_set_targeting_bias( obj_pelican, 0.50 );

end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: LZ: WATCHER ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global boolean B_e8_m2_ai_lz_watchers_complete = 								FALSE;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_lz_watchers_start::: Start
script dormant f_e8_m2_ai_lz_watchers_start()
	//dprint( "f_e8_m2_ai_lz_watchers_start" );

	//f_e8_m2_ai_pool_lives_watcher( -1, -1, -1, -1, 1.0, 1.0, 1.0, 1.0 );
	S_e8_m2_ai_spawn_pool_watcher_lives = -1;
	wake( f_e8_m2_ai_lz_watchers_trigger );

end

// === f_e8_m2_ai_lz_watchers_trigger::: Start
script dormant f_e8_m2_ai_lz_watchers_trigger()
local ai ai_placed = NONE;
local object obj_placed = NONE;
local long l_timer = 0;
local cutscene_flag flg_loc = flg_e8_m2_watcher_lz_01;
local cutscene_flag flg_last = flg_e8_m2_watcher_lz_01;
local real r_delay = 1.0;

	//sleep_until( (L_e8_m2_ai_phantom_lz_a_loading != 0) and (L_e8_m2_ai_phantom_lz_b_loading != 0), 1 );
	//dprint( "f_e8_m2_ai_lz_watchers_trigger" );
	S_e8_m2_ai_spawn_pool_loc_max = 17;

	f_e8_m2_ai_pool_max_watcher( 2, 3, 3, 4, 1.0, 1.0, 1.0, 1.0 );
	repeat
		
		//dprint( "f_e8_m2_ai_lz_watchers_trigger: DELAY" );
		l_timer = timer_stamp( r_delay );
		inspect( r_delay );
		sleep_until( ((e8_m2_SpawningInPhantom <=0) and timer_expired(l_timer) and (ai_living_count(gr_e8_m2_all) < S_e8_m2_ai_spawn_pool_loc_max)) or f_e8_m2_ai_phantom_lz_complete(), 10 );

		if ( not f_e8_m2_ai_phantom_lz_complete() ) then
			f_e8_m2_ai_pool_max_watcher( 2, 3, 3, 4, 1.0, 1.0, 1.0, 1.0 );
			r_delay = r_delay * 1.125;
			if ( r_delay > 4.0 ) then
				r_delay = 4.0;
			end

			ai_placed = f_e8_m2_ai_pool_watcher( S_e8_m2_ai_level );
			//dprint( "f_e8_m2_ai_lz_watchers_trigger: PLACED?" );
			if ( ai_placed != NONE ) then
				//dprint( "f_e8_m2_ai_lz_watchers_trigger: PLACED" );
				obj_placed = ai_get_object( ai_placed );
				
				// scale
				object_set_scale( obj_placed, 0.0001, 0 );
	
				// get a flag to spawn at
				repeat
					flg_loc = f_e8_m2_ai_lz_watchers_loc_flag();
				until( flg_loc != flg_last, 1 );
				flg_last = flg_loc;
				
				// move
				object_move_to_flag( obj_placed, 0, flg_loc );
				sleep( 1 );
				
				// post move						
				thread( sys_e8m2_ai_place_loc_watcher_post(flg_loc, ai_placed, 'objectives_e8m2_lz') );
				
				// wait
				l_timer = timer_stamp( 3.0, 5.0 );
				sleep_until( timer_expired(l_timer) or f_e8_m2_ai_phantom_lz_complete(), 6 );
			end

		end

	until( f_e8_m2_ai_phantom_lz_complete(), 1 );

	//dprint( "f_e8_m2_ai_lz_watchers_trigger: COMPLETE" );
	B_e8_m2_ai_lz_watchers_complete = TRUE;

end

// === f_e8_m2_ai_lz_watchers_loc_flag::: Gets a location flag for the watcher to spawn
script static cutscene_flag f_e8_m2_ai_lz_watchers_loc_flag()
	begin_random_count( 1 )
		flg_e8_m2_watcher_lz_01;
		flg_e8_m2_watcher_lz_02;
		flg_e8_m2_watcher_lz_03;
		flg_e8_m2_watcher_lz_04;
		flg_e8_m2_watcher_lz_05;
		flg_e8_m2_watcher_lz_06;
		flg_e8_m2_watcher_lz_07;
	end
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: POOL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
global short S_e8_m2_ai_spawn_pool_grunt_lives = 								-1;
global short S_e8_m2_ai_spawn_pool_grunt_max = 									-1;

global short S_e8_m2_ai_spawn_pool_jackal_lives = 							-1;
global short S_e8_m2_ai_spawn_pool_jackal_max = 								-1;

global short S_e8_m2_ai_spawn_pool_elite_basic_lives = 					-1;
global short S_e8_m2_ai_spawn_pool_elite_basic_max = 						-1;

global short S_e8_m2_ai_spawn_pool_elite_leader_lives = 				3;
global short S_e8_m2_ai_spawn_pool_elite_leader_max = 					3;

global short S_e8_m2_ai_spawn_pool_hunter_lives = 							0;
global short S_e8_m2_ai_spawn_pool_hunter_max = 								3;

global short S_e8_m2_ai_spawn_pool_ghost_lives = 								0;
global short S_e8_m2_ai_spawn_pool_ghost_max = 									3;

global short S_e8_m2_ai_spawn_pool_wraith_lives = 							0;
global short S_e8_m2_ai_spawn_pool_wraith_max = 								1;

global short S_e8_m2_ai_spawn_pool_watcher_lives = 							0;
global short S_e8_m2_ai_spawn_pool_watcher_max = 								6;

global short S_e8_m2_ai_spawn_pool_loc_max = 										17;
global short S_e8_m2_ai_spawn_pool_phantom_max = 								17;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_e8_m2_ai_pool_max_inc( short s_inc )
	S_e8_m2_ai_spawn_pool_loc_max = S_e8_m2_ai_spawn_pool_loc_max + s_inc;
	S_e8_m2_ai_spawn_pool_phantom_max = S_e8_m2_ai_spawn_pool_phantom_max + s_inc;
end

script static short sys_e8_m2_ai_pool_count_set( short s_val, short s_max, short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
local short s_cnt = 0;
	// This has been hammered flat because changing the pool counts interacts poorly with trying to tune the total number of AI.
	s_val = s_player_02;
	
	// return
	s_val;
end
script static short sys_e8_m2_ai_pool_count_set( short s_val, short s_max, short s_player_01, short s_player_02, short s_player_03, short s_player_04 )
	sys_e8_m2_ai_pool_count_set( s_val, s_max, s_player_01, s_player_02, s_player_03, s_player_04, 1.0, 1.0, 1.0, 1.0 );
end

script static void f_e8_m2_ai_pool_lives_elite_basic( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_elite_basic_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_elite_basic_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_lives_elite_basic" );
	//inspect( S_e8_m2_ai_spawn_pool_elite_basic_lives );
end
script static void f_e8_m2_ai_pool_max_elite_basic( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_elite_basic_max = sys_e8_m2_ai_pool_count_set( 0, 3, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_max_elite_basic" );
	//inspect( S_e8_m2_ai_spawn_pool_elite_basic_max );
end

script static void f_e8_m2_ai_pool_lives_elite_leader( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_elite_leader_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_elite_leader_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_lives_elite_leader" );
	//inspect( S_e8_m2_ai_spawn_pool_elite_leader_lives );
end
script static void f_e8_m2_ai_pool_max_elite_leader( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_elite_leader_max = sys_e8_m2_ai_pool_count_set( 0, 3, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_max_elite_leader" );
	//inspect( S_e8_m2_ai_spawn_pool_elite_leader_max );
end

script static void f_e8_m2_ai_pool_lives_hunter( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_hunter_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_hunter_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_lives_hunter" );
	//inspect( S_e8_m2_ai_spawn_pool_hunter_lives );
end
script static void f_e8_m2_ai_pool_max_hunter( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_hunter_max = sys_e8_m2_ai_pool_count_set( 0, 3, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_max_hunter" );
	//inspect( S_e8_m2_ai_spawn_pool_hunter_max );
end

script static void f_e8_m2_ai_pool_lives_ghost( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_ghost_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_ghost_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_lives_ghost" );
	//inspect( S_e8_m2_ai_spawn_pool_ghost_lives );
end
script static void f_e8_m2_ai_pool_max_ghost( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_ghost_max = sys_e8_m2_ai_pool_count_set( 0, 3, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_max_ghost" );
	//inspect( S_e8_m2_ai_spawn_pool_ghost_max );
end

script static void f_e8_m2_ai_pool_lives_wraith( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_wraith_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_wraith_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_lives_wraith" );
	//inspect( S_e8_m2_ai_spawn_pool_wraith_lives );
end

script static void f_e8_m2_ai_pool_lives_watcher( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_watcher_lives = sys_e8_m2_ai_pool_count_set( S_e8_m2_ai_spawn_pool_watcher_lives, -1, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	dprint( "f_e8_m2_ai_pool_lives_watcher" );
	inspect( S_e8_m2_ai_spawn_pool_watcher_lives );
end
script static void f_e8_m2_ai_pool_max_watcher( short s_player_01, short s_player_02, short s_player_03, short s_player_04, real r_easy_mod, real r_normal_mod, real r_heroic_mod, real r_legendary_mod )
	S_e8_m2_ai_spawn_pool_watcher_max = sys_e8_m2_ai_pool_count_set( 0, 6, s_player_01, s_player_02, s_player_03, s_player_04, r_easy_mod, r_normal_mod, r_heroic_mod, r_legendary_mod );
	//dprint( "f_e8_m2_ai_pool_max_watcher" );
	//inspect( S_e8_m2_ai_spawn_pool_watcher_max );
end

// === f_e8_m2_ai_pool_elite::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_cov_weak( short s_level )
local ai ai_pool = NONE;

	begin_random
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_grunt( s_level );
			end
		end
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_jackal( s_level );
			end
		end
	end
	
	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_elite::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_cov_any( short s_level )
local ai ai_pool = NONE;

	begin_random
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_grunt( s_level );
			end
		end
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_jackal( s_level );
			end
		end
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_elite_basic( s_level );
			end
		end
		begin
			if ( (ai_pool == NONE) and (s_level > 3) ) then
				ai_pool = f_e8_m2_ai_pool_elite_leader( s_level );
			end
		end
	end
	
	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_grunt::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_grunt( short s_level )
local ai ai_pool = NONE;
static object obj_grunt_01 = NONE;
static object obj_grunt_02 = NONE;
static object obj_grunt_03 = NONE;
static object obj_grunt_04 = NONE;
static object obj_grunt_05 = NONE;
static object obj_grunt_06 = NONE;
static object obj_grunt_07 = NONE;
static object obj_grunt_08 = NONE;
static object obj_grunt_09 = NONE;
static object obj_grunt_10 = NONE;
static object obj_grunt_11 = NONE;
static object obj_grunt_12 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_grunt_lives != 0) and ((S_e8_m2_ai_spawn_pool_grunt_max < 0) or (ai_living_count(gr_e8_m2_enemy_grunt) < S_e8_m2_ai_spawn_pool_grunt_max)) ) then
	
		if ( object_get_health(obj_grunt_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_grunt_01;
			ai_place_in_limbo( ai_pool );
			obj_grunt_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_02;
			ai_place_in_limbo( ai_pool );
			obj_grunt_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_03;
			ai_place_in_limbo( ai_pool );
			obj_grunt_03 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_04) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_04;
			ai_place_in_limbo( ai_pool );
			obj_grunt_04 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_05) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_05;
			ai_place_in_limbo( ai_pool );
			obj_grunt_05 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_06) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_06;
			ai_place_in_limbo( ai_pool );
			obj_grunt_06 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_07) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_07;
			ai_place_in_limbo( ai_pool );
			obj_grunt_07 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_08) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_08;
			ai_place_in_limbo( ai_pool );
			obj_grunt_08 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_09) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_09;
			ai_place_in_limbo( ai_pool );
			obj_grunt_09 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_10) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_10;
			ai_place_in_limbo( ai_pool );
			obj_grunt_10 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_11) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_11;
			ai_place_in_limbo( ai_pool );
			obj_grunt_11 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_grunt_12) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_grunt_12;
			ai_place_in_limbo( ai_pool );
			obj_grunt_12 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_grunt_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_grunt_lives = S_e8_m2_ai_spawn_pool_grunt_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_jackal::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_jackal( short s_level )
local ai ai_pool = NONE;
static object obj_jackal_01 = NONE;
static object obj_jackal_02 = NONE;
static object obj_jackal_03 = NONE;
static object obj_jackal_04 = NONE;
static object obj_jackal_05 = NONE;
static object obj_jackal_06 = NONE;
static object obj_jackal_07 = NONE;
static object obj_jackal_08 = NONE;
static object obj_jackal_09 = NONE;
static object obj_jackal_10 = NONE;
static object obj_jackal_11 = NONE;
static object obj_jackal_12 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_jackal_lives != 0) and ((S_e8_m2_ai_spawn_pool_jackal_max < 0) or (ai_living_count(gr_e8_m2_enemy_jackal) < S_e8_m2_ai_spawn_pool_jackal_max)) ) then
	
		if ( object_get_health(obj_jackal_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_jackal_01;
			ai_place_in_limbo( ai_pool );
			obj_jackal_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_02;
			ai_place_in_limbo( ai_pool );
			obj_jackal_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_03;
			ai_place_in_limbo( ai_pool );
			obj_jackal_03 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_04) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_04;
			ai_place_in_limbo( ai_pool );
			obj_jackal_04 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_05) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_05;
			ai_place_in_limbo( ai_pool );
			obj_jackal_05 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_06) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_06;
			ai_place_in_limbo( ai_pool );
			obj_jackal_06 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_07) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_07;
			ai_place_in_limbo( ai_pool );
			obj_jackal_07 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_08) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_08;
			ai_place_in_limbo( ai_pool );
			obj_jackal_08 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_09) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_09;
			ai_place_in_limbo( ai_pool );
			obj_jackal_09 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_10) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_10;
			ai_place_in_limbo( ai_pool );
			obj_jackal_10 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_11) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_11;
			ai_place_in_limbo( ai_pool );
			obj_jackal_11 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_jackal_12) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_jackal_12;
			ai_place_in_limbo( ai_pool );
			obj_jackal_12 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_jackal_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_jackal_lives = S_e8_m2_ai_spawn_pool_jackal_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_elite::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_elite( short s_level )
local ai ai_pool = NONE;

	begin_random
		begin
			if ( ai_pool == NONE ) then
				ai_pool = f_e8_m2_ai_pool_elite_basic( s_level );
			end
		end
		begin
			if ( (ai_pool == NONE) and (s_level > 3) ) then
				ai_pool = f_e8_m2_ai_pool_elite_leader( s_level );
			end
		end
	end

	// return
	ai_pool;
end

script static boolean f_e8_m2_can_spawn_elite_basic()
	local boolean can = ( (S_e8_m2_ai_spawn_pool_elite_basic_lives != 0) and ((S_e8_m2_ai_spawn_pool_elite_basic_max < 0) or (ai_living_count(gr_e8_m2_enemy_elite_basic) < S_e8_m2_ai_spawn_pool_elite_basic_max)) );
	can;
end
// === f_e8_m2_ai_pool_elite_basic::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_elite_basic( short s_level )
local ai ai_pool = NONE;
static object obj_elite_basic_01 = NONE;
static object obj_elite_basic_02 = NONE;
static object obj_elite_basic_03 = NONE;
static object obj_elite_basic_04 = NONE;
static object obj_elite_basic_05 = NONE;
static object obj_elite_basic_06 = NONE;

	if ( f_e8_m2_can_spawn_elite_basic()) then 
	
		if ( object_get_health(obj_elite_basic_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_elite_01;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_basic_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_elite_02;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_basic_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_elite_03;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_03 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_basic_04) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_elite_04;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_04 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_basic_05) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_elite_05;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_05 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_basic_06) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_elite_06;
			ai_place_in_limbo( ai_pool );
			obj_elite_basic_06 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_elite_basic_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_elite_basic_lives = S_e8_m2_ai_spawn_pool_elite_basic_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_elite_leader::: Gets an ai of this type
script static boolean f_e8_m2_can_spawn_elite_leader()
	local boolean can =  ( (S_e8_m2_ai_spawn_pool_elite_leader_lives != 0) and ((S_e8_m2_ai_spawn_pool_elite_leader_max < 0) or (ai_living_count(gr_e8_m2_enemy_elite_leader) < S_e8_m2_ai_spawn_pool_elite_leader_max)) );
	can;
end
	
script static ai f_e8_m2_ai_pool_elite_leader( short s_level )
local ai ai_pool = NONE;
static object obj_elite_leader_01 = NONE;
static object obj_elite_leader_02 = NONE;
static object obj_elite_leader_03 = NONE;

	if (f_e8_m2_can_spawn_elite_leader()) then 
	
		if ( object_get_health(obj_elite_leader_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_leader_01;
			ai_place_in_limbo( ai_pool );
			obj_elite_leader_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_leader_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_leader_02;
			ai_place_in_limbo( ai_pool );
			obj_elite_leader_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_elite_leader_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_leader_03;
			ai_place_in_limbo( ai_pool );
			obj_elite_leader_03 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_elite_leader_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_elite_leader_lives = S_e8_m2_ai_spawn_pool_elite_leader_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_hunter::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_hunter( short s_level )
local ai ai_pool = NONE;
static object obj_hunter_01 = NONE;
static object obj_hunter_02 = NONE;
static object obj_hunter_03 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_hunter_lives != 0) and ((S_e8_m2_ai_spawn_pool_hunter_max < 0) or (ai_living_count(gr_e8_m2_enemy_hunter) < S_e8_m2_ai_spawn_pool_hunter_max)) ) then 

		if ( object_get_health(obj_hunter_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_hunter_01;
			ai_place( ai_pool );
			obj_hunter_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_hunter_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_hunter_02;
			ai_place( ai_pool );
			obj_hunter_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_hunter_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_hunter_03;
			ai_place( ai_pool );
			obj_hunter_03 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_hunter_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_hunter_lives = S_e8_m2_ai_spawn_pool_hunter_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_watcher::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_watcher( short s_level )
local ai ai_pool = NONE;
static object obj_watcher_01 = NONE;
static object obj_watcher_02 = NONE;
static object obj_watcher_03 = NONE;
static object obj_watcher_04 = NONE;
static object obj_watcher_05 = NONE;
static object obj_watcher_06 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_watcher_lives != 0) and ((S_e8_m2_ai_spawn_pool_watcher_max < 0) or (ai_living_count(gr_e8_m2_enemy_watcher) < S_e8_m2_ai_spawn_pool_watcher_max)) ) then 

		if ( object_get_health(obj_watcher_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_watcher_01;
			ai_place_in_limbo( ai_pool );
			obj_watcher_01 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_watcher_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_watcher_02;
			ai_place_in_limbo( ai_pool );
			obj_watcher_02 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_watcher_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_watcher_03;
			ai_place_in_limbo( ai_pool );
			obj_watcher_03 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_watcher_04) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_watcher_04;
			ai_place_in_limbo( ai_pool );
			obj_watcher_04 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_watcher_05) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_watcher_05;
			ai_place_in_limbo( ai_pool );
			obj_watcher_05 = ai_get_object( ai_pool );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_watcher_06) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_watcher_06;
			ai_place_in_limbo( ai_pool );
			obj_watcher_06 = ai_get_object( ai_pool );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_watcher_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_watcher_lives = S_e8_m2_ai_spawn_pool_watcher_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_ghost::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_ghost( short s_level )
local ai ai_pool = NONE;
static object obj_ghost_01 = NONE;
static object obj_ghost_02 = NONE;
static object obj_ghost_03 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_ghost_lives != 0) and ((S_e8_m2_ai_spawn_pool_ghost_max < 0) or (ai_living_count(gr_e8_m2_enemy_ghost) < S_e8_m2_ai_spawn_pool_ghost_max)) ) then 

		if ( object_get_health(obj_ghost_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_ghost_01;
			ai_place( ai_pool );
			obj_ghost_01 = ai_vehicle_get_from_squad( ai_pool, 0 );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_ghost_02) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_ghost_02;
			ai_place( ai_pool );
			obj_ghost_02 = ai_vehicle_get_from_squad( ai_pool, 0 );
		end
		if ( (ai_pool == NONE) and (object_get_health(obj_ghost_03) <= 0.0) ) then
			ai_pool = sq_e8m2_pool_ghost_03;
			ai_place( ai_pool );
			obj_ghost_03 = ai_vehicle_get_from_squad( ai_pool, 0 );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_ghost_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_ghost_lives = S_e8_m2_ai_spawn_pool_ghost_lives - 1;
		end

	end

	// return
	ai_pool;
end

// === f_e8_m2_ai_pool_wraith::: Gets an ai of this type
script static ai f_e8_m2_ai_pool_wraith( short s_level )
local ai ai_pool = NONE;
static object obj_wraith_01 = NONE;

	if ( (S_e8_m2_ai_spawn_pool_wraith_lives != 0) and ((S_e8_m2_ai_spawn_pool_wraith_max < 0) or (ai_living_count(gr_e8_m2_enemy_wraith) < S_e8_m2_ai_spawn_pool_wraith_max)) ) then 
	
		if ( object_get_health(obj_wraith_01) <= 0.0 ) then
			ai_pool = sq_e8m2_pool_wraith_01;
			ai_place( ai_pool );
			obj_wraith_01 = ai_vehicle_get_from_squad( ai_pool, 0 );
		end
		
		// decrement lives cnt
		if ( (ai_pool != NONE) and (S_e8_m2_ai_spawn_pool_wraith_lives > 0) ) then
			S_e8_m2_ai_spawn_pool_wraith_lives = S_e8_m2_ai_spawn_pool_wraith_lives - 1;
		end

	end

	// return
	ai_pool;
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: POOL: LOC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
static short DEF_E8_M2_AI_PLACE_LOC_SCALE_TIME_DEFAULT = 							20;

// === f_e8m2_ai_place_loc::: Places an ai at a location
//script static long f_e8m2_ai_place_loc( cutscene_flag flg_loc, real r_priority, short s_cnt, string_id sid_objective, short s_level_max, real r_conditional_distance, real r_conditional_angle, real r_force_distance, boolean b_grunt, boolean b_jackal, boolean b_elite_basic, boolean b_elite_leader, boolean b_watcher )
//	thread( sys_e8m2_ai_place_loc(flg_loc, r_priority, s_cnt, sid_objective, s_level_max, r_conditional_distance, r_conditional_angle, r_force_distance, b_grunt, b_jackal, b_elite_basic, b_elite_leader, b_watcher );
//end
script static long f_e8m2_ai_place_loc_leader( cutscene_flag flg_loc, object obj_parent, short s_cnt, string_id sid_objective, short s_level_max )
	thread( sys_e8m2_ai_place_loc(flg_loc, obj_parent, 2.5, s_cnt, sid_objective, s_level_max, 17.5, 30.0, 25.0, FALSE, FALSE, FALSE, TRUE, FALSE) );
end
script static long f_e8m2_ai_place_loc_support( cutscene_flag flg_loc, object obj_parent, short s_cnt, string_id sid_objective, short s_level_max )
	thread( sys_e8m2_ai_place_loc(flg_loc, obj_parent, 10.0, s_cnt, sid_objective, s_level_max, 22.5, 30.0, 30.0, TRUE, TRUE, TRUE, FALSE, FALSE) );
end
script static long f_e8m2_ai_place_loc_watcher( cutscene_flag flg_loc, object obj_parent, short s_cnt, string_id sid_objective, short s_level_max, boolean b_damage_wait )

	/*
	// wait for damage
	if ( b_damage_wait ) then
		local real r_parent_health = object_get_health( obj_parent );
		//dprint( "f_e8m2_ai_place_loc_watcher: WATCHER 01: WAIT" );
		inspect( r_parent_health );
		sleep_until( object_get_health(obj_parent) < r_parent_health, 1 );
		//dprint( "f_e8m2_ai_place_loc_watcher: WATCHER 01: GO!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
	end
	*/
	thread( sys_e8m2_ai_place_loc(flg_loc, obj_parent, 5.0, s_cnt, sid_objective, s_level_max, 5.0, -30.0, 999.999, FALSE, FALSE, FALSE, FALSE, TRUE) );

end

// === f_e8_m2_ai_enemy_artillery_place::: Manages the placement for artillery enemies
script static boolean f_e8m2_ai_place_artillery_locs( object obj_artillery, object obj_core_01, object obj_core_02, string_id sid_objective, cutscene_flag flg_leader, cutscene_flag flg_core_support_01, cutscene_flag flg_core_watcher_01, cutscene_flag flg_core_support_02, cutscene_flag flg_core_watcher_02 )

	// place a leader
	f_e8m2_ai_place_loc_leader( flg_leader, obj_artillery, 1, sid_objective, 4 );
	
	sleep_until( S_e8_m2_ai_level >= 1, 1 );
	f_e8m2_ai_place_loc_support( flg_core_support_01, obj_core_01, 1, sid_objective, 3 );
	sleep(1);
	f_e8m2_ai_place_loc_support( flg_core_support_02, obj_core_02, 1, sid_objective, 3 );
	
	sleep_until( S_e8_m2_ai_level >= 2, 1 );
	f_e8m2_ai_place_loc_support( flg_core_support_01, obj_core_01, 1, sid_objective, 3 );
	sleep(1);
	f_e8m2_ai_place_loc_support( flg_core_support_02, obj_core_02, 1, sid_objective, 3 );

	f_e8m2_ai_place_loc_watcher( flg_core_watcher_01, obj_core_01, 1, sid_objective, 3, TRUE );
	sleep(1);
	f_e8m2_ai_place_loc_watcher( flg_core_watcher_02, obj_core_02, 1, sid_objective, 3, TRUE );
	
	sleep_until( S_e8_m2_ai_level >= 3, 1 );
	f_e8m2_ai_place_loc_support( flg_core_support_01, obj_core_01, 1, sid_objective, 3 );
	sleep(1);
	f_e8m2_ai_place_loc_support( flg_core_support_02, obj_core_02, 1, sid_objective, 3 );

end

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
// === f_e8m2_ai_place_loc::: Sets the min and max safe distances defaults
script static void sys_e8m2_ai_place_loc( cutscene_flag flg_loc, object obj_parent, real r_priority, short s_cnt, string_id sid_objective, short s_level_max, real r_conditional_distance, real r_conditional_angle, real r_force_distance, boolean b_grunt, boolean b_jackal, boolean b_elite_basic, boolean b_elite_leader, boolean b_watcher )
static real r_place_priority = 99999.99999;
static real r_place_distance = 99999.99999;
local boolean b_conditional_distance_check = ( r_conditional_distance < 0.0 );
local boolean b_conditional_angle_check = ( r_conditional_angle < 0.0 );
local boolean b_force_distance_check = ( r_force_distance < 0.0 );
local boolean b_placed_elite = FALSE;
local boolean b_placed_watcher = FALSE;
local real r_distance = 0.0;
local ai ai_placed = NONE;
local object obj_placed = NONE;

	//dprint( "sys_e8m2_ai_place_loc: START" );

	// force distances/angle to be possitive
	r_conditional_distance = abs_r( r_conditional_distance );
	r_conditional_angle = abs_r( r_conditional_angle );
	r_force_distance = abs_r( r_force_distance );

	repeat
	
		sleep_until( 
			( S_e8_m2_ai_level > s_level_max )
			or
			( object_get_health(obj_parent) <= 0.0 )
			or
			(
				( e8_m2_SpawningInPhantom <= 0) 
				and 
				( r_priority <= r_place_priority )
				and
				( ai_living_count(gr_e8_m2_all) < S_e8_m2_ai_spawn_pool_loc_max )
				and
				( spops_player_living_cnt() > 0 )
				and
				sys_e8m2_ai_place_loc_check( r_place_distance, flg_loc, r_conditional_distance, b_conditional_distance_check, r_conditional_angle, b_conditional_angle_check, r_force_distance, b_force_distance_check )
			)
		, 10 );
	
		if ( (S_e8_m2_ai_level <= s_level_max) and (object_get_health(obj_parent) > 0.0) ) then
			r_place_priority = r_priority;
			r_distance = objects_distance_to_flag( Players(), flg_loc );
			r_place_distance = r_distance;
			//dprint( "sys_e8m2_ai_place_loc: CLAIMED" );
			sleep( 1 );

			if ( (r_place_priority == r_priority) and (r_place_distance == r_distance) ) then

				// reset place vars
				//dprint( "sys_e8m2_ai_place_loc: MATCH" );
				r_place_priority = 99999.99999;
				r_place_distance = 99999.99999;
				
				if ( ai_living_count(gr_e8_m2_enemy_unit_all) < S_e8_m2_ai_spawn_pool_loc_max ) then
	
					// initialize variables				
					ai_placed = NONE;
					b_placed_elite = FALSE;
					b_placed_watcher = FALSE;
					
					// get an ai
					begin_random
					
						begin
							if ( b_grunt and (ai_placed == NONE) ) then
								ai_placed = f_e8_m2_ai_pool_grunt( S_e8_m2_ai_level );
							end
						end
						begin
							if ( b_jackal and (ai_placed == NONE) ) then
								ai_placed = f_e8_m2_ai_pool_jackal( S_e8_m2_ai_level );
							end
						end
						begin
							if ( b_elite_basic and (ai_placed == NONE) ) then
								ai_placed = f_e8_m2_ai_pool_elite_basic( S_e8_m2_ai_level );
								if ( ai_placed != NONE ) then
									b_placed_elite = TRUE;
								end
							end
						end
						begin
							if ( b_elite_leader and (ai_placed == NONE) ) then
								ai_placed = f_e8_m2_ai_pool_elite_leader( S_e8_m2_ai_level );
								if ( ai_placed != NONE ) then
									b_placed_elite = TRUE;
								end
							end
						end
						begin
							if ( b_watcher and (ai_placed == NONE) ) then
								ai_placed = f_e8_m2_ai_pool_watcher( S_e8_m2_ai_level );
								if ( ai_placed != NONE ) then
									b_placed_watcher = TRUE;
								end
							end
						end
						
					end

					// post-placed
					if ( ai_placed != NONE ) then
						//dprint( "sys_e8m2_ai_place_loc: PLACED" );
					
						// decrement spawn cnt
						s_cnt = s_cnt - 1;
						
						// get object
						obj_placed = ai_get_object( ai_placed );
						
						// scale
						object_set_scale( obj_placed, 0.0001, 0 );
						
						// move
						object_move_to_flag( obj_placed, 0, flg_loc );
						
						// special elite stuff
						if ( b_placed_elite ) then
						
							spops_ai_active_camo_manager( ai_placed );
							spops_ai_secondary_sword_manage( ai_placed, ai_combat_status_visible, -10.0, 0.0, -1.0 );
							
						end
	
						// non watcher post
						if ( not b_placed_watcher ) then
	
							object_set_scale( obj_placed, 1.0, DEF_E8_M2_AI_PLACE_LOC_SCALE_TIME_DEFAULT );
							ai_exit_limbo( ai_placed );
	
							// set objective					
							ai_set_objective( ai_placed, sid_objective );
	
						end
	
						// watcher post
						if ( b_placed_watcher ) then
	
							//sleep( 1 );
							//object_move_by_offset( obj_placed, 0, 0.0, 0.0, 0.20 );
							thread( sys_e8m2_ai_place_loc_watcher_post(flg_loc, ai_placed, sid_objective) );
						end
					
					end
				
				end
				
			end
		
		end
	
	until ( (S_e8_m2_ai_level > s_level_max) or (object_get_health(obj_parent) <= 0.0) or (s_cnt <= 0), 1 );

	//dprint( "sys_e8m2_ai_place_loc: END" );

end

script static boolean sys_e8m2_ai_place_loc_check( real r_place_distance, cutscene_flag flg_loc, real r_conditional_distance, boolean b_conditional_distance_check, real r_conditional_angle, boolean b_conditional_angle_check, real r_force_distance, boolean b_force_distance_check )
static real r_distance = 0.0;

	// get distance
	r_distance = objects_distance_to_flag( Players(), flg_loc );
	( r_distance < r_place_distance ) or ( ((r_distance >= r_force_distance) == b_force_distance_check) or (((r_distance >= r_conditional_distance) == b_conditional_distance_check) and (objects_can_see_flag(Players(), flg_loc, r_conditional_angle) == b_conditional_angle_check)) );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: POOL: PHANTOM ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static short f_e8m2_ai_place_phantom( vehicle vh_phantom, short s_cnt, boolean b_cargo )
local boolean b_placed = FALSE;
local ai ai_placed = NONE;

	// ghosts
	if ( b_cargo and (ai_placed == NONE) and (ai_living_count(gr_e8_m2_enemy_ghost_pool) <= 1) ) then

		// ghost 01
		ai_placed = f_e8_m2_ai_pool_ghost( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: GHOST 01 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo01", ai_vehicle_get_from_squad(ai_placed, 0), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo01", ai_placed );
			//s_cnt = s_cnt + 1;

			// place second ghost
			ai_placed = f_e8_m2_ai_pool_ghost( S_e8_m2_ai_level );
		end

		// ghost 02
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: GHOST 02 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo02", ai_vehicle_get_from_squad(ai_placed, 0), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo02", ai_placed );
			//s_cnt = s_cnt + 1;
		end

	end

	if ( b_cargo and (ai_placed == NONE) and (ai_living_count(gr_e8_m2_enemy_hunter_pool) <= 1) ) then
	
		// hunter 01
		ai_placed = f_e8_m2_ai_pool_hunter( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: HUNTER 01 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo01", ai_get_object(ai_placed), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo01", ai_placed );
			//s_cnt = s_cnt + 1;
			
			// place hunter 2
			ai_placed = f_e8_m2_ai_pool_hunter( S_e8_m2_ai_level );
		end

		// hunter 02
		if ( ai_placed != NONE ) then
			//dprint( "f_e8m2_ai_place_phantom: HUNTER 02 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" );
			objects_attach( vh_phantom, "small_cargo02", ai_get_object(ai_placed), "" );
			f_e8m2_ai_place_phantom_cargo_switch( vh_phantom, "small_cargo02", ai_placed );
			//s_cnt = s_cnt + 1;
		end
		
	end
	
	// place basics
	if ( ai_placed == NONE ) then
	
		ai_placed = f_e8_m2_ai_pool_cov_any( S_e8_m2_ai_level );
		if ( ai_placed != NONE ) then
			spops_phantom_load_ai( vh_phantom, ai_placed, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, FALSE );
			f_e8m2_ai_place_phantom_seat_switch( vh_phantom, ai_placed );
			s_cnt = s_cnt + 1;
		end
		
	end

	// return
	s_cnt;
end

script static long f_e8m2_ai_place_phantom_cargo_switch( vehicle vh_phantom, string_id sid_marker, ai ai_attached )
	thread( sys_e8m2_ai_place_phantom_cargo_switch(vh_phantom, sid_marker, ai_attached) );
end	

script static long f_e8m2_ai_place_phantom_seat_switch( vehicle vh_phantom, ai ai_attached )
	thread( sys_e8m2_ai_place_phantom_seat_switch(vh_phantom, ai_attached) );
end	

// SYSTEMS $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
script static void sys_e8m2_ai_place_phantom_cargo_switch( vehicle vh_phantom, string_id sid_marker, ai ai_attached )

	sleep_until( object_at_marker(vh_phantom,sid_marker) != NONE, 1 );
	//dprint( "sys_e8m2_ai_place_phantom_cargo_switch: LOADED" );

	sleep_until( object_at_marker(vh_phantom,sid_marker) == NONE, 1 );
	//dprint( "sys_e8m2_ai_place_phantom_cargo_switch: UNLOADED" );
	f_e8_m2_ai_switch( ai_attached, NONE );

end

script static void sys_e8m2_ai_place_phantom_seat_switch( vehicle vh_phantom, ai ai_attached )

	// wait until in vehicle
	sleep_until( unit_in_vehicle(ai_attached), 1 );
	//dprint( "sys_e8m2_ai_place_phantom_seat_switch: LOADED" );
	
	// wait for vehicle exit
	sleep_until( not unit_in_vehicle(ai_attached), 1 );
	//dprint( "sys_e8m2_ai_place_phantom_seat_switch: UNLOADED" );
	f_e8_m2_ai_switch( ai_attached, NONE );

end

script static void sys_e8m2_ai_place_loc_watcher_post( cutscene_flag flg_loc, ai ai_placed, string_id sid_objective )

	// portal fx
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_start_pve.effect', flg_loc );
	sleep_s( 0.50 );
	effect_new( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	sleep_s( 0.25 );
	
	// scale in
	object_set_scale( ai_get_object(ai_placed), 1.0, 50 );
	
	// set objective
	ai_set_objective( ai_placed, sid_objective );
	
	// exit limbo
	ai_exit_limbo( ai_placed );
	
	// kill fx
	sleep_s( 0.50 );
	effect_kill_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );
	effect_delete_from_flag( 'levels\dlc\ff153_caverns\fx\portal\teleport_lg_portal_no_shake.effect', flg_loc );

end
