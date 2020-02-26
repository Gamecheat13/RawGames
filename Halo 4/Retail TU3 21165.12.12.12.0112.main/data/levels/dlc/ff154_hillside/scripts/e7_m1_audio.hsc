//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E7M1 - Abort
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AUDIO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_audio_init::: Init
script dormant f_e7m1_audio_init()
	//dprint( "f_e7m1_audio_init" );
	
	// initialize sub-modules
	wake( f_e7m1_audio_music_init );

	//music cue
//	thread (f_e7m1_audio_music_start() );

end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E7M1: AUDIO: MUSIC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

/*
EVENTS

// MISSION
+ play_mus_pve_e07m1_start
+ play_mus_pve_e07m1_finish

// OBJECTIVES
+ play_mus_pve_e07m1_objective_portal_start
+ play_mus_pve_e07m1_objective_portal_end

+ play_mus_pve_e07m1_objective_abort_start

+ play_mus_pve_e07m1_objective_exit_start
+ play_mus_pve_e07m1_objective_exit_end

+ play_mus_pve_e07m1_objective_exit_blip_start
+ play_mus_pve_e07m1_objective_exit_blip_end

+ play_mus_pve_e07m1_objective_barrier_start
+ play_mus_pve_e07m1_objective_barrier_end

+ play_mus_pve_e07m1_objective_barrier_blip_start
+ play_mus_pve_e07m1_objective_barrier_blip_end

+ play_mus_pve_e07m1_objective_lz_start
+ play_mus_pve_e07m1_objective_lz_end

+ play_mus_pve_e07m1_objective_lz_clear_start
+ play_mus_pve_e07m1_objective_lz_clear_mop_up
+ play_mus_pve_e07m1_objective_lz_clear_end

+ play_mus_pve_e07m1_objective_phantom_help_start
+ play_mus_pve_e07m1_objective_phantom_help_end

+ play_mus_pve_e07m1_objective_pickup_start
+ play_mus_pve_e07m1_objective_pickup_ready
+ play_mus_pve_e07m1_objective_pickup_end

// ENCTOUNTER
// ENCTOUNTER: PORTAL
+ play_mus_pve_e07m1_encounter_area_portal_start
+ play_mus_pve_e07m1_encounter_area_portal_end

// ENCTOUNTER: AREAS
//	There are several encounters areas that start, advance, and retreat along the way depending on which ways you go.  Each area increases in difficulty as you push down the hill
//	AREAS: 1A, 2A, 2B, 2C, 2D, 2E, 3A, 3B, 3C, 4A, 4B, 4C, 4E, 4F, 5A, 5B, 5C, 6A, 6B, 6C, 7A, 7B, 7C, 8A
+ play_mus_pve_e07m1_encounter_area_XX_start
+ play_mus_pve_e07m1_encounter_area_XX_advance
+ play_mus_pve_e07m1_encounter_area_XX_retreat
+ play_mus_pve_e07m1_encounter_area_XX_end

// ENCTOUNTER: AREAS
//	Another way to track encounters would be that each area has a spawn level associated with it that determines the types of enemies in that area.  The contents are subject to change but the concept is areas escelate in difficulty
//	LEVEL 1: Grunt, Elite
//	LEVEL 2: Grunt, Jackal, Elite
//	LEVEL 3: Grunt, Jackal, Elite, Ghost
//	LEVEL 4: Grunt, Jackal, Elite, Wraith
//	LEVEL 5: Grunt, Jackal, Elite, Crawler, Ghost
//	LEVEL 6: Grunt, Elite, Crawler, Knight, Watcher, Wraith
//	LEVEL 7: Grunt, Jackal, Crawler, Knight, Watcher
//	LEVEL 8: Grunt, Jackal, Elite, Crawler, Knight, Watcher
+ play_mus_pve_e07m1_encounter_level_#_start
+ play_mus_pve_e07m1_encounter_level_#_advance
+ play_mus_pve_e07m1_encounter_level_#_retreat
+ play_mus_pve_e07m1_encounter_level_#_end

// EVENTS
+ play_mus_pve_e07m1_event_freefall_landed

// EVENTS: WEAPON DROPS
// 	NOTE: NOT CURRENTLY HOOKED UP
- play_mus_pve_e07m1_event_weapon_drop_01
- play_mus_pve_e07m1_event_weapon_drop_02
- play_mus_pve_e07m1_event_weapon_drop_03
spops_audio_music_event( 'play_mus_pve_e07m1_event_weapon_drop_01', "play_mus_pve_e07m1_event_weapon_drop_01" )
spops_audio_music_event( 'play_mus_pve_e07m1_event_weapon_drop_02', "play_mus_pve_e07m1_event_weapon_drop_02" )
spops_audio_music_event( 'play_mus_pve_e07m1_event_weapon_drop_03', "play_mus_pve_e07m1_event_weapon_drop_03" )

// EVENTS: SANDBOX CHANGERS
+ play_mus_pve_e07m1_event_sandbox_changer_enabled
+ play_mus_pve_e07m1_event_sandbox_changer_enemy_goto - NOTE: THIS EVENT IS NOT HOOKED UP YET AND THE SANDBOX CHANGERS ARE ON BY DEFAULT
+ play_mus_pve_e07m1_event_sandbox_changer_enemy_activated
+ play_mus_pve_e07m1_event_sandbox_changer_enemy_cloaked
+ play_mus_pve_e07m1_event_sandbox_changer_ally_activated - NOTE: Integrated but currently disabled because players might not be able to be cloaked by script
+ play_mus_pve_e07m1_event_sandbox_changer_ally_cloaked - NOTE: Integrated but currently disabled because players might not be able to be cloaked by script
+ play_mus_pve_e07m1_event_sandbox_changer_core_destroyed
+ play_mus_pve_e07m1_event_sandbox_changer_disabled

+ play_mus_pve_e07m1_event_barrier_enemy_goto
+ play_mus_pve_e07m1_event_barrier_enemy_open
+ play_mus_pve_e07m1_event_barrier_generator_destroyed
+ play_mus_pve_e07m1_event_barrier_deactivated

+ play_mus_pve_e07m1_event_ally_phantom_start
+ play_mus_pve_e07m1_event_ally_phantom_abort - NOTE: Triggers when the ally phantom takes too much damage.  He flies away and the player fails.

+ play_mus_pve_e07m1_event_enemy_phantom_start
+ play_mus_pve_e07m1_event_enemy_phantom_abort - NOTE: Triggers when the enemy phantoms turrets are all destroyed.  He will fly away.
+ play_mus_pve_e07m1_event_enemy_phantom_destroyed

+ play_mus_pve_e07m1_event_mech_drop_ready
+ play_mus_pve_e07m1_event_mech_drop_released

- play_mus_pve_e07m1_event_tower_destroyed
spops_audio_music_event( 'play_mus_pve_e07m1_event_tower_destroyed', "play_mus_pve_e07m1_event_tower_destroyed" )

- play_mus_pve_e07m1_event_aa_turret_active
- play_mus_pve_e07m1_event_aa_turret_shooting
- play_mus_pve_e07m1_event_aa_turret_deactivated
spops_audio_music_event( 'play_mus_pve_e07m1_event_aa_turret_active', "play_mus_pve_e07m1_event_aa_turret_active" )
spops_audio_music_event( 'play_mus_pve_e07m1_event_aa_turret_shooting', "play_mus_pve_e07m1_event_aa_turret_shooting" )
spops_audio_music_event( 'play_mus_pve_e07m1_event_aa_turret_deactivated', "play_mus_pve_e07m1_event_aa_turret_deactivated" )

+ play_mus_pve_e07m1_spawn_enemy_grunt
+ play_mus_pve_e07m1_spawn_enemy_jackal
+ play_mus_pve_e07m1_spawn_enemy_elite
+ play_mus_pve_e07m1_spawn_enemy_ghost
+ play_mus_pve_e07m1_spawn_enemy_wraith
+ play_mus_pve_e07m1_spawn_enemy_crawler
+ play_mus_pve_e07m1_spawn_enemy_watcher
+ play_mus_pve_e07m1_spawn_enemy_knight

*/

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e7m1_audio_music_init::: Init
script dormant f_e7m1_audio_music_init()
	//dprint( "f_e7m1_audio_music_init" );

	wake( f_e7m1_audio_music_trigger );

end

// === f_e7m1_audio_music_trigger::: Trigger
script dormant f_e7m1_audio_music_trigger()
	//dprint( "f_e7m1_audio_music_trigger" );

	// mission start
	sleep_until( f_spops_mission_setup_complete(), 1 );
	spops_audio_music_start( 'play_mus_pve_e07m1_start', "play_mus_pve_e07m1_start" );
	
	// setup mission triggers
	wake( f_e7m1_audio_music_changer_trigger );

	// mission complete
	sleep_until( f_spops_mission_end_complete(), 1 );
	spops_audio_music_finish( 'play_mus_pve_e07m1_finish', "play_mus_pve_e07m1_finish" );

end

// === f_e7m1_audio_music_changer_trigger::: Trigger
script dormant f_e7m1_audio_music_changer_trigger()
	//dprint( "f_e7m1_audio_music_changer_trigger" );

	thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_enabled', "play_mus_pve_e07m1_event_sandbox_changer_enabled", "sandbox_changer_enabled", -1) );
	thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_enemy_activated', "play_mus_pve_e07m1_event_sandbox_changer_enemy_activated", "sandbox_changer_enemy_activated", -1) );
	thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_enemy_cloaked', "play_mus_pve_e07m1_event_sandbox_changer_enemy_cloaked", "sandbox_changer_enemy_cloaked", -1) );
	//thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_enemy_activated', "play_mus_pve_e07m1_event_sandbox_changer_ally_activated", "sandbox_changer_ally_activated", -1) );
	//thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_enemy_cloaked', "play_mus_pve_e07m1_event_sandbox_changer_ally_cloaked", "sandbox_changer_ally_cloaked", -1) );
	thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_core_destroyed', "play_mus_pve_e07m1_event_sandbox_changer_core_destroyed", "sandbox_changer_core_destroyed", -1) );
	thread( spops_audio_music_event_notifed('play_mus_pve_e07m1_event_sandbox_changer_disabled', "play_mus_pve_e07m1_event_sandbox_changer_disabled", "sandbox_changer_disabled", -1) );

end

// === f_e7m1_audio_music_encounter::: Manages music for an encounter start/stop
script static void f_e7m1_audio_music_area_encounter( ai ai_enemy_task, ai ai_enemy_combat_task, sound_event se_music_area_start, string str_debug_area_start, sound_event se_music_area_end, string str_debug_area_end, sound_event se_music_level_start, string str_debug_level_start, sound_event se_music_level_end, string str_debug_level_end )
	thread( sys_e7m1_audio_music_area_encounter(ai_enemy_task, ai_enemy_combat_task, se_music_area_start, str_debug_area_start, se_music_area_end, str_debug_area_end, se_music_level_start, str_debug_level_start, se_music_level_end, str_debug_level_end) );
end
script static void sys_e7m1_audio_music_area_encounter( ai ai_enemy_task, ai ai_enemy_combat_task, sound_event se_music_area_start, string str_debug_area_start, sound_event se_music_area_end, string str_debug_area_end, sound_event se_music_level_start, string str_debug_level_start, sound_event se_music_level_end, string str_debug_level_end )

	// start area
	sleep_until( ai_task_count(ai_enemy_task) > 0, 10 );

	// start area event
	sleep_until( ai_task_count(ai_enemy_combat_task) > 0, 10 );
	spops_audio_music_event( se_music_area_start, str_debug_area_start );
	spops_audio_music_event( se_music_level_start, str_debug_level_start );

	// wait for area to be finished
	repeat
		sleep_until( ai_task_count(ai_enemy_combat_task) <= 0, 15 );
		sleep( 15 );
	until( ai_task_count(ai_enemy_task) <= 0, 10 );

	// stop area event
	spops_audio_music_event( se_music_area_end, str_debug_area_end );
	spops_audio_music_event( se_music_level_end, str_debug_level_end );

end

