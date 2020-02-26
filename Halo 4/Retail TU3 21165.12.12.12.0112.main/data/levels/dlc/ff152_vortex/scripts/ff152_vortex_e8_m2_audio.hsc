//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// 	Mission: 					SPARTAN OPS: E8M2 - Artillery
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AUDIO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_audio_init::: Init
script dormant f_e8_m2_audio_init()
	dprint( "f_e8_m2_audio_init" );
	
	// initialize sub-modules
	wake( f_e8m2_audio_music_init );

end

/*

// MISSION
+ play_mus_pve_e08m2_start
+ play_mus_pve_e08m2_finish

// OBJECTIVES
+ play_mus_pve_e08m2_objective_lz_first_clear
+ play_mus_pve_e08m2_objective_destroy_artillery
+ play_mus_pve_e08m2_objective_destroy_cores
+ play_mus_pve_e08m2_objective_artillery_all_destroyed
+ play_mus_pve_e08m2_objective_lz_rendezvous
+ play_mus_pve_e08m2_objective_lz_finale_clear
+ play_mus_pve_e08m2_objective_pelican_defend
+ play_mus_pve_e08m2_objective_pelican_rendezvous

// ENCOUNTERS
+ play_mus_pve_e08m2_encounter_lz_first_start
+ play_mus_pve_e08m2_encounter_lz_first_end

// ENCOUNTERS: ARTILLERY - These are tracked on each individual artillery encounter, not the order the player plays them in (that's sandbox).
//	NOTE: Sometimes they will go back to start after going idle from hearing gunfire, etc..
+ play_mus_pve_e08m2_encounter_artillery_01_start
+ play_mus_pve_e08m2_encounter_artillery_01_enemy_leading
+ play_mus_pve_e08m2_encounter_artillery_01_enemy_losing
+ play_mus_pve_e08m2_encounter_artillery_01_idle
+ play_mus_pve_e08m2_encounter_artillery_01_retreat
+ play_mus_pve_e08m2_encounter_artillery_01_end

+ play_mus_pve_e08m2_encounter_artillery_02_start
+ play_mus_pve_e08m2_encounter_artillery_02_idle
+ play_mus_pve_e08m2_encounter_artillery_02_retreat
+ play_mus_pve_e08m2_encounter_artillery_02_end

+ play_mus_pve_e08m2_encounter_artillery_03_start
+ play_mus_pve_e08m2_encounter_artillery_03_idle
+ play_mus_pve_e08m2_encounter_artillery_03_retreat
+ play_mus_pve_e08m2_encounter_artillery_03_end

- play_mus_pve_e08m2_encounter_lz_finale_start
- play_mus_pve_e08m2_encounter_lz_finale_idle
- play_mus_pve_e08m2_encounter_lz_finale_mop_up
- play_mus_pve_e08m2_encounter_lz_finale_end

// ARTILLERY MISSION STATE - This is the mission state for players knowledge of the Artillery
+ play_mus_pve_e08m2_artillery_mission_state_known
+ play_mus_pve_e08m2_artillery_mission_state_infinity_warning
+ play_mus_pve_e08m2_artillery_mission_state_near
+ play_mus_pve_e08m2_artillery_mission_state_too_tough
+ play_mus_pve_e08m2_artillery_mission_state_core_attacked
+ play_mus_pve_e08m2_artillery_mission_state_core_damaged
+ play_mus_pve_e08m2_artillery_mission_state_complete

// ARTILLARY STATE - These are states for the individual 3 artillery
+ play_mus_pve_e08m2_artillery_state_destabilized
+ play_mus_pve_e08m2_artillery_state_dangerous
+ play_mus_pve_e08m2_artillery_state_destroyed

// PHANTOM - Events for the different states of the phantoms
+ play_mus_pve_e08m2_phantom_incoming
+ play_mus_pve_e08m2_phantom_unloading
+ play_mus_pve_e08m2_phantom_defending
+ play_mus_pve_e08m2_phantom_leaving
+ play_mus_pve_e08m2_phantom_kamikaze

// CORES - Events tracked by the individual artillery power cores/conduits
+ play_mus_pve_e08m2_core_outer_piece_damaged
+ play_mus_pve_e08m2_core_outer_piece_destroyed
+ play_mus_pve_e08m2_core_inner_piece_damaged
+ play_mus_pve_e08m2_core_inner_piece_destroyed
+ play_mus_pve_e08m2_core_shell_outer_derezzing
+ play_mus_pve_e08m2_core_shell_outer_destroyed
+ play_mus_pve_e08m2_core_shell_inner_derezzing
+ play_mus_pve_e08m2_core_shell_inner_destroyed
+ play_mus_pve_e08m2_core_shell_armor_derezzing
+ play_mus_pve_e08m2_core_shell_armor_destroyed
+ play_mus_pve_e08m2_core_destroyed

// AI LEVELS - AI levels change based on players destroying the artillery.  With each level it changes the different types of AI that get dropped in via the phantoms.
//	NOTE: Ghosts and Hunters will remain in the Queue until they spawn while others will get shutdown once the level changes.
//	NOTE: Watchers also show up in the mix but they are more hand spawned in.
//	LEVEL 1 - Zero Artillery Destroyed: Grunts, Jackals, Elites, Ghosts
//	LEVEL 2 - One Artillery Destroyed: Grunt, Jackals, Elites, Hunters
//	LEVEL 3 - Two Artillery Destroyed: Grunts, Jackals, Elites, Ghosts
//	LEVEL 4 - All Artillery Destroyed, LZ Enemies: Grunt, Jackals, Elites, Hunters, Wraith
//	LEVEL 5 - This is when all the ai spawning has stopped, just the final guys incoming on the phantom are left
+ play_mus_pve_e08m2_ai_level_01
+ play_mus_pve_e08m2_ai_level_02
+ play_mus_pve_e08m2_ai_level_03
+ play_mus_pve_e08m2_ai_level_04
+ play_mus_pve_e08m2_ai_level_05

// AI ATTACKING - For the more dangerous/unique AI I've hooked up music triggers based on what they're doing and for the conditions that will work for them
+ play_mus_pve_e08m2_ai_artillery_shooting
+ play_mus_pve_e08m2_ai_watcher_spawning
+ play_mus_pve_e08m2_ai_watcher_attacking
+ play_mus_pve_e08m2_ai_ghost_unloading
+ play_mus_pve_e08m2_ai_ghost_attacking
+ play_mus_pve_e08m2_ai_ghost_shooting
+ play_mus_pve_e08m2_ai_hunter_unloading
+ play_mus_pve_e08m2_ai_hunter_attacking
+ play_mus_pve_e08m2_ai_hunter_shooting
+ play_mus_pve_e08m2_ai_wraith_gunner_unloading
+ play_mus_pve_e08m2_ai_wraith_gunner_shooting
+ play_mus_pve_e08m2_ai_wraith_driver_unloading
+ play_mus_pve_e08m2_ai_wraith_driver_attacking
+ play_mus_pve_e08m2_ai_wraith_driver_shooting

// POWER WEAPON DROP - Events for the power weapon drops
- play_mus_pve_e08m2_power_weapon_drop_01
- play_mus_pve_e08m2_power_weapon_drop_02
- play_mus_pve_e08m2_power_weapon_drop_03
spops_audio_music_event( 'play_mus_pve_e08m2_power_weapon_drop_01', "play_mus_pve_e08m2_power_weapon_drop_01" );
spops_audio_music_event( 'play_mus_pve_e08m2_power_weapon_drop_02', "play_mus_pve_e08m2_power_weapon_drop_02" );
spops_audio_music_event( 'play_mus_pve_e08m2_power_weapon_drop_03', "play_mus_pve_e08m2_power_weapon_drop_03" );

*/


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AUDIO: INTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_audio_intro_start::: Start audio for the intro scene
script static void f_e8_m2_audio_intro_start()
	dprint( "f_e8_m2_audio_intro_start" );
//	sound_impulse_start('sound\storm\multiplayer\pve\events\mp_pve_e3m2_vin_sfx_intro', NONE, 1 );
	
end

// === f_e8_m2_audio_intro_end::: End audio for the intro scene
script static void f_e8_m2_audio_intro_end()
	dprint( "f_e8_m2_audio_intro_end" );
end



// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AUDIO: MUSIC ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8m2_audio_music_init::: Init
script dormant f_e8m2_audio_music_init()
	dprint( "f_e8m2_audio_music_init" );

	wake( f_e8m2_audio_music_trigger );

end

// === f_e8m2_audio_music_trigger::: Trigger
script dormant f_e8m2_audio_music_trigger()
	dprint( "f_e8m2_audio_music_trigger" );

	// mission start
	sleep_until( f_spops_mission_setup_complete(), 1 );
	spops_audio_music_start( 'play_mus_pve_e08m2_start', "play_mus_pve_e08m2_start" );
	
	// setup general triggers
	wake( f_e8m2_audio_music_artillery_triggers );

	// mission complete
	sleep_until( f_spops_mission_end_complete(), 1 );
	spops_audio_music_finish( 'play_mus_pve_e08m2_finish', "play_mus_pve_e08m2_finish" );

end

// === f_e8m2_audio_music_encounter::: Manages music for an encounter start/stop
script static void f_e8m2_audio_music_artillery_encounter( object obj_artillery, ai ai_enemy_task, ai ai_enemy_combat_main_task, ai ai_enemy_combat_core_01_task, ai ai_enemy_combat_core_02_task, sound_event se_music_artillery_start, string str_debug_artillery_start, sound_event se_music_artillery_idle, string str_debug_artillery_idle, sound_event se_music_artillery_end, string str_debug_artillery_end )
	thread( sys_e8m2_audio_music_artillery_encounter(obj_artillery, ai_enemy_task, ai_enemy_combat_main_task, ai_enemy_combat_core_01_task, ai_enemy_combat_core_02_task, se_music_artillery_start, str_debug_artillery_start, se_music_artillery_idle, str_debug_artillery_idle, se_music_artillery_end, str_debug_artillery_end) );
end
script static void sys_e8m2_audio_music_artillery_encounter( object obj_artillery, ai ai_enemy_task, ai ai_enemy_combat_main_task, ai ai_enemy_combat_core_01_task, ai ai_enemy_combat_core_02_task, sound_event se_music_artillery_start, string str_debug_artillery_start, sound_event se_music_artillery_idle, string str_debug_artillery_idle, sound_event se_music_artillery_end, string str_debug_artillery_end )
local boolean b_active = FALSE;

	repeat

		// start artillery event
		sleep_until( (((ai_task_count(ai_enemy_combat_main_task) > 0) or (ai_task_count(ai_enemy_combat_core_01_task) > 0) or (ai_task_count(ai_enemy_combat_core_02_task) > 0)) != b_active) or ((not b_active) and (object_get_health(obj_artillery) <= 0.0)), 1 );

		// toggle active
		b_active = ( not b_active ) and ( object_get_health(obj_artillery) > 0.0 );

		if ( object_get_health(obj_artillery) > 0.0 ) then
	
			if ( b_active ) then
				spops_audio_music_event( se_music_artillery_start, str_debug_artillery_start );
			end
			if ( not b_active ) then
				spops_audio_music_event( se_music_artillery_idle, str_debug_artillery_idle );
			end

		end
	
	until( (not b_active) and (object_get_health(obj_artillery) <= 0.0), 15 );
	
	// end
	spops_audio_music_event( se_music_artillery_end, str_debug_artillery_end );

end

// === f_e8m2_audio_music_trigger::: Trigger
script dormant f_e8m2_audio_music_artillery_triggers()

	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_outer_piece_damaged', "play_mus_pve_e08m2_core_outer_piece_damaged", "POWER_SPHERE_OUTER_SHELL_PIECE_DAMAGED") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_outer_piece_destroyed', "play_mus_pve_e08m2_core_outer_piece_destroyed", "POWER_SPHERE_OUTER_SHELL_PIECE_DESTROYED") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_outer_derezzing', "play_mus_pve_e08m2_core_shell_outer_derezzing", "POWER_SPHERE_OUTER_SHELL_DEREZ") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_outer_destroyed', "play_mus_pve_e08m2_core_shell_outer_destroyed", "POWER_SPHERE_OUTER_SHELL_DESTROYED") );
	
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_inner_piece_damaged', "play_mus_pve_e08m2_core_inner_piece_damaged", "POWER_SPHERE_INNER_SHELL_PIECE_DAMAGED") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_inner_piece_destroyed', "play_mus_pve_e08m2_core_inner_piece_destroyed", "POWER_SPHERE_INNER_SHELL_PIECE_DESTROYED") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_inner_derezzing', "play_mus_pve_e08m2_core_shell_inner_derezzing", "POWER_SPHERE_INNER_SHELL_DEREZ") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_inner_destroyed', "play_mus_pve_e08m2_core_shell_inner_destroyed", "POWER_SPHERE_INNER_SHELL_DESTROYED") );
	
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_armor_derezzing', "play_mus_pve_e08m2_core_shell_armor_derezzing", "POWER_SPHERE_ARMOR_DEREZ") );
	thread( spops_audio_music_event_notifed('play_mus_pve_e08m2_core_shell_armor_destroyed', "play_mus_pve_e08m2_core_shell_armor_destroyed", "POWER_SPHERE_ARMOR_DESTROYED") );

end

// === f_e8m2_audio_music_encounter_lz_finale::: Manages music for final encounter
script dormant f_e8m2_audio_music_encounter_lz_finale()

	repeat
	
		// wait for encounter to Start
		sleep_until( ai_task_count(objectives_e8m2_lz.enemy_combat_gate) > 0, 15 );	
		spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_finale_start', "play_mus_pve_e08m2_encounter_lz_finale_start" );
		
		repeat
		
			if ( ai_task_count(objectives_e8m2_lz.enemy_combat_lead_gate) > 0 ) then
				spops_audio_music_event( 'play_mus_pve_e08m2_encounter_artillery_01_enemy_leading', "play_mus_pve_e08m2_encounter_artillery_01_enemy_leading" );
				sleep_until( ai_task_count(objectives_e8m2_lz.enemy_combat_lead_gate) <= 0, 15 );
			elseif ( ai_task_count(objectives_e8m2_lz.enemy_combat_lose_gate) > 0 ) then
				spops_audio_music_event( 'play_mus_pve_e08m2_encounter_artillery_01_enemy_losing', "play_mus_pve_e08m2_encounter_artillery_01_enemy_losing" );
				sleep_until( ai_task_count(objectives_e8m2_lz.enemy_combat_lose_gate) <= 0, 15 );
			end
		
		until( ai_task_count(objectives_e8m2_lz.enemy_combat_gate) <= 0, 15 );

		// switch to idle
		spops_audio_music_event( 'play_mus_pve_e08m2_encounter_lz_finale_idle', "play_mus_pve_e08m2_encounter_lz_finale_idle" );
	
	until( FALSE, 15 );

end
