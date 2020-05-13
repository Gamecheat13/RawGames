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
global team DEF_E8_M2_TEAM_PELICAN = 				spare;
global team DEF_E8_M2_TEAM_ARTILLERY = 			brute;
global team DEF_E8_M2_TEAM_CORE = 					mule;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
// spawn priority
global real DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_LEADER = 					050.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_SUPPORT_01 = 			075.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_LEADER = 							025.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01 = 					050.0;
global real DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_02 = 					100.0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_init::: Init
script dormant f_e8_m2_ai_init()
	dprint( "f_e8_m2_ai_init" );
	
	// initialize sub-modules
	wake( f_e8_m2_ai_intro_init );
	
	// setup trigger
	wake ( f_e8_m2_ai_trigger );
	
end

// === f_e8_m2_ai_trigger::: Trigger
script dormant f_e8_m2_ai_trigger()
	dprint( "f_e8_m2_ai_trigger" );

	sleep_until( f_spops_mission_start_complete(), 1 );
	dprint( "f_e8_m2_ai_trigger: START COMPLETE" );
	ai_exit_limbo( ai_ff_all );

end

// === f_e8_m2_artillery_unit_state::: Returns the current firing 
script static boolean f_e8_m2_ai_artillery_enabled( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03 )
	object_get_health( obj_artillery ) > 0.0;
end
script static boolean f_e8_m2_ai_artillery_01_enabled()
	f_e8_m2_ai_artillery_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_03 );
end
script static boolean f_e8_m2_ai_artillery_02_enabled()
	f_e8_m2_ai_artillery_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_03 );
end
script static boolean f_e8_m2_ai_artillery_03_enabled()
	f_e8_m2_ai_artillery_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_03 );
end

// === f_e8_m2_ai_unsc_core_enabled::: Checks if unsc
script static boolean f_e8_m2_ai_artillery_enemy_reinforcements_enabled( object_name obj_artillery, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03, ai ai_main_task )
	FALSE;
end
script static boolean f_e8_m2_ai_artillery_01_enemy_reinforcements_enabled()
	f_e8_m2_ai_artillery_enemy_reinforcements_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_03, objectives_e8m2_artillery_01.enemy_artillery_main_combat_unit );
end
script static boolean f_e8_m2_ai_artillery_02_enemy_reinforcements_enabled()
	f_e8_m2_ai_artillery_enemy_reinforcements_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_03, objectives_e8m2_artillery_02.enemy_artillery_main_combat_unit );
end
script static boolean f_e8_m2_ai_artillery_03_enemy_reinforcements_enabled()
	f_e8_m2_ai_artillery_enemy_reinforcements_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_03, objectives_e8m2_artillery_03.enemy_artillery_main_combat_unit );
end

// === f_e8_m2_ai_core_enabled::: Checks if a core task should be enabled
script static boolean f_e8_m2_ai_artillery_core_enabled( object_name obj_artillery, object_name obj_core )
	object_get_health( obj_core ) > 0.0;
end
script static boolean f_e8_m2_ai_artillery_01_core_01_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01 );
end
script static boolean f_e8_m2_ai_artillery_01_core_02_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_02 );
end
script static boolean f_e8_m2_ai_artillery_01_core_03_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_03 );
end
script static boolean f_e8_m2_ai_artillery_02_core_01_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01 );
end
script static boolean f_e8_m2_ai_artillery_02_core_02_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_02 );
end
script static boolean f_e8_m2_ai_artillery_02_core_03_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_03 );
end
script static boolean f_e8_m2_ai_artillery_03_core_01_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01 );
end
script static boolean f_e8_m2_ai_artillery_03_core_02_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_02 );
end
script static boolean f_e8_m2_ai_artillery_03_core_03_enabled()
	f_e8_m2_ai_artillery_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_03 );
end

// === f_e8_m2_ai_unsc_core_enabled::: Checks if unsc
script static boolean f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( object_name obj_artillery, object_name obj_core, object_name obj_core_01, object_name obj_core_02, object_name obj_core_03, ai ai_main_task )
	FALSE;
end
script static boolean f_e8_m2_ai_enemy_artillery_01_core_01_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_03, objectives_e8m2_artillery_01.enemy_core_01_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_01_core_02_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_03, objectives_e8m2_artillery_01.enemy_core_02_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_01_core_03_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_03, cr_e8_m2_artillery_01_core_01, cr_e8_m2_artillery_01_core_02, cr_e8_m2_artillery_01_core_03, objectives_e8m2_artillery_01.enemy_core_03_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_02_core_01_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_03, objectives_e8m2_artillery_02.enemy_core_01_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_02_core_02_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_03, objectives_e8m2_artillery_02.enemy_core_02_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_02_core_03_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_03, cr_e8_m2_artillery_02_core_01, cr_e8_m2_artillery_02_core_02, cr_e8_m2_artillery_02_core_03, objectives_e8m2_artillery_02.enemy_core_03_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_03_core_01_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_03, objectives_e8m2_artillery_03.enemy_core_01_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_03_core_02_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_03, objectives_e8m2_artillery_03.enemy_core_02_combat_unit );
end
script static boolean f_e8_m2_ai_enemy_artillery_03_core_03_reinforcements_enabled()
	f_e8_m2_ai_enemy_artillery_core_reinforcements_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_03, cr_e8_m2_artillery_03_core_01, cr_e8_m2_artillery_03_core_02, cr_e8_m2_artillery_03_core_03, objectives_e8m2_artillery_03.enemy_core_03_combat_unit );
end

// === f_e8_m2_ai_unsc_core_enabled::: Checks if any of the the cores are enabled for UNSC attacking
script static boolean f_e8_m2_ai_unsc_core_enabled()
	f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_CORE_ATTACK;
end

// === f_e8_m2_ai_unsc_core_enabled::: Checks if a specific core is enabled for UNSC attacking
script static boolean f_e8_m2_ai_unsc_core_enabled( object_name obj_artillery, object_name obj_core )
	object_get_health( obj_core ) > 0.0;
end
script static boolean f_e8_m2_ai_unsc_artillery_01_core_01_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_01 );
end
script static boolean f_e8_m2_ai_unsc_artillery_01_core_02_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_02 );
end
script static boolean f_e8_m2_ai_unsc_artillery_01_core_03_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_01, cr_e8_m2_artillery_01_core_03 );
end
script static boolean f_e8_m2_ai_unsc_artillery_02_core_01_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_01 );
end
script static boolean f_e8_m2_ai_unsc_artillery_02_core_02_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_02 );
end
script static boolean f_e8_m2_ai_unsc_artillery_02_core_03_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_02, cr_e8_m2_artillery_02_core_03 );
end
script static boolean f_e8_m2_ai_unsc_artillery_03_core_01_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_01 );
end
script static boolean f_e8_m2_ai_unsc_artillery_03_core_02_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_02 );
end
script static boolean f_e8_m2_ai_unsc_artillery_03_core_03_enabled()
	f_e8_m2_ai_unsc_core_enabled( vh_e8_m2_artillery_03, cr_e8_m2_artillery_03_core_03 );
end

// === f_e8_m2_ai_artillery_setup::: Sets up default artillery placement
script static void f_e8_m2_ai_artillery_setup( long l_thread, object_name obj_artillery, ai ai_artillery_squad_leader, ai ai_artillery_squad_support, cutscene_flag flg_artillery_spawn, ai ai_core_01_squad_leader, ai ai_core_01_squad_support, cutscene_flag flg_core_01_spawn, ai ai_core_02_squad_leader, ai ai_core_02_squad_support, cutscene_flag flg_core_02_spawn, ai ai_core_03_squad_leader, ai ai_core_03_squad_support, cutscene_flag flg_core_03_spawn )
local real r_chance = 50.0;
	dprint( "f_e8_m2_ai_artillery_setup" );

	// wait for intial placement
	sleep_until( f_e8_m2_ai_intro_placed(), 1 );

	// level 1
	dprint( "f_e8_m2_ai_artillery_setup: LEVEL 01" );
	thread( spops_ai_place_safe(l_thread, ai_artillery_squad_leader, flg_artillery_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_LEADER, 1, 1, -1, r_chance) );
	thread( spops_ai_place_safe(l_thread, ai_artillery_squad_support, flg_artillery_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_01_squad_leader, flg_core_01_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_LEADER, 1, 1, -1, r_chance) );
	thread( spops_ai_place_safe(l_thread, ai_core_01_squad_support, flg_core_01_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_02_squad_leader, flg_core_02_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_LEADER, 1, 1, -1, r_chance) );
	thread( spops_ai_place_safe(l_thread, ai_core_02_squad_support, flg_core_02_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_03_squad_leader, flg_core_03_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_LEADER, 1, 1, -1, r_chance) );
	thread( spops_ai_place_safe(l_thread, ai_core_03_squad_support, flg_core_03_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	// level 2
	sleep_until( f_e8_m2_ai_level() >= 2, 1 );
	dprint( "f_e8_m2_ai_artillery_setup: LEVEL 02" );
	thread( spops_ai_place_safe(l_thread, ai_artillery_squad_support, flg_artillery_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_ARTILLERY_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_01_squad_support, flg_core_01_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_02_squad_support, flg_core_02_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_03_squad_support, flg_core_03_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_01, 1, 1, -1, r_chance) );

	// level 3
	sleep_until( f_e8_m2_ai_level() >= 3, 1 );
	dprint( "f_e8_m2_ai_artillery_setup: LEVEL 03" );
	thread( spops_ai_place_safe(l_thread, ai_core_01_squad_support, flg_core_01_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_02, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_02_squad_support, flg_core_02_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_02, 1, 1, -1, r_chance) );

	thread( spops_ai_place_safe(l_thread, ai_core_03_squad_support, flg_core_03_spawn, DEF_E8_M2_AI_SPAWN_PRIORITY_CORE_SUPPORT_02, 1, 1, -1, r_chance) );

end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e8_m2_ai_elite_place()
	dprint( "cs_e8_m2_ai_elite_place" );
end
script command_script cs_e8_m2_ai_jackal_place()
	dprint( "cs_e8_m2_ai_jackal_place" );
end
script command_script cs_e8_m2_ai_grunt_place()
	dprint( "cs_e8_m2_ai_grunt_place" );
end

// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: LEVEL ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
script static short f_e8_m2_ai_level()
	4 - f_e8_m2_artillery_living_cnt();
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: SWITCH ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
script static void f_e8_m2_ai_switch( ai ai_actor, string_id sid_objective_current )
local string_id sid_objective = 'objectives_e8m2_lz';
local object obj_target = NONE;
local object obj_actor = ai_get_object( ai_current_actor );
local object_list ol_squad = ai_actors( ai_get_squad(ai_current_actor) );
	dprint( "cs_e8_m2_ai_switch" );
	
	if ( (object_get_health(vh_e8_m2_artillery_01) > 0.0) and ((obj_target == NONE) or (objects_distance_to_object(ol_squad,vh_e8_m2_artillery_01) < objects_distance_to_object(ol_squad,obj_target))) ) then
		dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_01" );
		sid_objective = 'objectives_e8m2_artillery_01';
		obj_target = vh_e8_m2_artillery_01;
	end
	if ( (object_get_health(vh_e8_m2_artillery_02) > 0.0) and ((obj_target == NONE) or (objects_distance_to_object(obj_actor,vh_e8_m2_artillery_02) < objects_distance_to_object(obj_actor,obj_target))) ) then
		dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_02" );
		sid_objective = 'objectives_e8m2_artillery_02';
		obj_target = vh_e8_m2_artillery_02;
	end
	if ( (object_get_health(vh_e8_m2_artillery_03) > 0.0) and ((obj_target == NONE) or (objects_distance_to_object(obj_actor,vh_e8_m2_artillery_03) < objects_distance_to_object(obj_actor,obj_target))) ) then
		dprint( "cs_e8_m2_ai_switch: objectives_e8m2_artillery_03" );
		sid_objective = 'objectives_e8m2_artillery_03';
		obj_target = vh_e8_m2_artillery_03;
	end

	// switch objectives
	if ( sid_objective_current != sid_objective ) then
		ai_set_objective( ai_get_squad(ai_current_actor), sid_objective );
	end
	
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
script command_script cs_e8_m2_ai_switch_unsc_lz()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_lz' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_01()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_01' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_02()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_02' );
end
script command_script cs_e8_m2_ai_switch_unsc_artillery_03()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_03' );
end
script command_script cs_e8_m2_ai_switch_enemy_lz()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_lz' );
end
script command_script cs_e8_m2_ai_switch_enemy_artillery_01()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_01' );
end
script command_script cs_e8_m2_ai_switch_enemy_artillery_02()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_02' );
end
script command_script cs_e8_m2_ai_switch_enemy_artillery_03()
	f_e8_m2_ai_switch( ai_current_actor, 'objectives_e8m2_artillery_03' );
end


// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** E8M2: AI: INTRO ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_e8_m2_ai_intro_init::: Init
script dormant f_e8_m2_ai_intro_init()
	dprint( "f_e8_m2_ai_intro_init" );

	// setup trigger
	wake( f_e8_m2_ai_intro_trigger );

end

// === f_e8_m2_ai_intro_trigger::: Trigger
script dormant f_e8_m2_ai_intro_trigger()
	dprint( "f_e8_m2_ai_intro_trigger" );

	// set alliances for pelican
	ai_allegiance( player, DEF_E8_M2_TEAM_PELICAN );
	ai_allegiance( DEF_E8_M2_TEAM_PELICAN, player );
	ai_allegiance( human, DEF_E8_M2_TEAM_PELICAN );
	ai_allegiance( DEF_E8_M2_TEAM_PELICAN, human );

	// trigger action
	wake( f_e8_m2_ai_intro_spawn );
	
	// make vulnerable
	sleep_until( f_spops_mission_start_complete(), 1 );
	object_can_take_damage( ai_actors(gr_e8_m2_lz) );

	// unsc tell you about the artillery	
	sleep_until( f_ai_is_defeated(gr_e8_m2_lz_enemy) or (f_e8_m2_artillery_state() >= DEF_E8M2_ARTILLERY_STATE_KNOWN), 1 );
	wake( f_e8_m2_dialog_artillery_soldiers_info );

end

// === f_e8_m2_ai_intro_spawn::: Spawn
script dormant f_e8_m2_ai_intro_spawn()
	dprint( "f_e8_m2_ai_intro_spawn" );

	// place
	ai_place( gr_e8_m2_lz );
	object_cannot_take_damage( ai_actors(gr_e8_m2_lz) );

end

// === f_e8_m2_ai_intro_placed::: Checks if the initial group was placed
script static boolean f_e8_m2_ai_intro_placed()
	ai_spawn_count( gr_e8_m2_lz ) > 0;
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

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static string STR_e8_m2_ai_intro_pelican_01_state =  "";

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------

// === XXX::: XXX
script static void f_e8_m2_ai_pelican_01_state( string str_state )
	if ( STR_e8_m2_ai_intro_pelican_01_state != str_state ) then
		dprint( "f_e8_m2_ai_intro_start:" );
		dprint( str_state );
		STR_e8_m2_ai_intro_pelican_01_state = str_state;
	end
end

// === XXX::: XXX
script static string f_e8_m2_ai_pelican_01_state()
	STR_e8_m2_ai_intro_pelican_01_state;
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_e8_m2_ai_intro_pelican_01::: Command script
script command_script cs_e8_m2_ai_intro_pelican_01()
local vehicle vh_pelican = ai_vehicle_get( ai_current_actor );

	// create warthog
	if ( not object_valid(vh_e8_m2_warthog_lz_01) ) then
		object_create( vh_e8_m2_warthog_lz_01 );
	end

	// load warthog
	vehicle_load_magic( vh_pelican, "pelican_lc", vh_e8_m2_warthog_lz_01 );

	// wait for start
	sleep_until( f_spops_mission_start_complete(), 1 );

	// wait for him to be ready to leave
	sleep_until( f_e8_m2_ai_pelican_01_state() == "GO", 1 );

	// fly to warthog drop spot
	cs_vehicle_speed( 0.25 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_01.p0_loc, 2.0 );

	cs_vehicle_speed( 0.1250 );
	cs_fly_to_and_dock( ps_e8_m2_ai_intro_pelican_01.p1_loc, ps_e8_m2_ai_intro_pelican_01.p1_face,0.25 );

	// ready to drop warthog
	sleep_until( f_e8_m2_ai_pelican_01_state() == "WARTHOG", 1 );
	vehicle_unload( vh_pelican, "pelican_lc" );
	sleep_s( 1.5 );

	// fly to leaving location
	f_e8_m2_ai_pelican_01_state( "LEAVING" );
	cs_vehicle_speed( 0.125 );
	dprint( "cs_e8_m2_ai_intro_pelican_01: p2_loc" );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_01.p2_loc, 1.0 );

	cs_vehicle_speed( 0.1875 );
	dprint( "cs_e8_m2_ai_intro_pelican_01: p3_loc" );
	cs_fly_to_and_dock( ps_e8_m2_ai_intro_pelican_01.p3_loc, ps_e8_m2_ai_intro_pelican_01.p3_face,0.5 );

	// explode
	sleep_until( f_e8_m2_ai_pelican_01_state() == "EXPLODE", 1 );
	// xxx temp until i can blow it up
	object_destroy( vh_pelican );
	ai_erase( ai_current_actor );

end

// === cs_e8_m2_ai_intro_pelican_02::: Command script
script command_script cs_e8_m2_ai_intro_pelican_02()
local vehicle vh_pelican = ai_vehicle_get( ai_current_actor );
local long l_timer = 0;

	// create warthog
	if ( not object_valid(vh_e8_m2_warthog_lz_02) ) then
		object_create( vh_e8_m2_warthog_lz_02 );
	end

	// load warthog
	vehicle_load_magic( vh_pelican, "pelican_lc", vh_e8_m2_warthog_lz_02 );

	// wait for start
	sleep_until( f_spops_mission_start_complete(), 1 );

	// unload
	sleep_s( 2.0 );
	vehicle_unload( vh_pelican, "pelican_lc" );
	sleep_s( 1.5 );

	// exit
	cs_vehicle_speed( 0.125 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_02.p0, 2.0 );
	cs_vehicle_speed( 0.250 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_02.p1, 2.0 );
	cs_vehicle_speed( 0.375 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_02.p2, 2.0 );
	cs_vehicle_speed( 0.500 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_02.p3, 2.0 );
	cs_vehicle_speed( 0.675 );
	object_set_scale( vh_pelican, 0.001, seconds_to_frames(7.5) );
	l_timer = timer_stamp( 7.5 );
	cs_fly_by( ps_e8_m2_ai_intro_pelican_02.p4, 2.0 );
	
	// wait for it to be gone
	sleep_until( timer_expired(l_timer), 1 );
	object_destroy( vh_pelican );
	ai_erase( ai_current_actor );

end
