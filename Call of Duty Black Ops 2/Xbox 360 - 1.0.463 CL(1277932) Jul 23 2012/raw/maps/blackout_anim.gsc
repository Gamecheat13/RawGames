#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_anim;
#include maps\_turret;
#include maps\_dialog;
#include common_scripts\utility;


#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#define CLIENT_FLAG_INTRO_EXTRA_CAM		11
#define CLIENT_FLAG_MESSIAH_MODE		15

main()
{
	maps\voice\voice_blackout::init_voice();

	// Needs to be Precached
	scene_intro_cctv();
	scene_intro_nag();
	/////

	node_list = array(
		"navy_dead_guy_security_01",
		"navy_dead_guy_security_02",
		"navy_dead_guy_security_03"
	);
	init_wounded_anims( node_list, "security_dead" );
	
	// Meat Shieldage
	meat_shield_player();
	meat_shield_victim();
	meat_shield_gun();
	
	// Mason pt. 1
	mason_part_1_animations();
	
	// Menendez
	// Mason pt. 2
	
	precache_assets();
}

mason_part_1_animations()
{
	scene_intro_interrogation();
	scene_wakeup();
	scene_mason_taser_knuckles();
	scene_hallway_devestation();
	scene_bridge_entry();
	scene_bridge();
	scene_security_level();
	torch_wall_scene();
	scene_server_room();
	console_chair_scenes();
	salazar_kill_animations();
	f38_crash_into_bridge();
	
	level thread scene_menendez_cctv();
}

menendez_animations()
{	
	scene_meat_shield();
	scene_server_room_super_kill();
	scene_meat_shield_aggressors();
	scene_menendez_hack();
	scene_menendez_combat();
	menendez_messiah();
	scene_salute_menendez();
	f35_startup();
	menendez_view_deck();
	rewind();
	
	precache_assets( true );
}

mason_part_2_animations()
{
	player_kick_anim();
	aftermath_scene();
	betrayal_scene();
	gassed_bodies();
	vtol_escape();	
	brute_force();
	
	precache_assets( true );
}

play_wounded_anims( node_list_name, delete_notify )
{
	foreach ( struct_name in level.wounded_scenes[node_list_name] )
	{		
		level thread run_scene_and_delete( struct_name );
	}
	
	level waittill( delete_notify );
	foreach( struct_name in level.wounded_scenes[node_list_name] )
	{
		end_scene( struct_name );
	}
	
	level.wounded_scenes[node_list_name] = undefined;
}

init_wounded_anims( node_list, node_list_name )
{
	if ( !isdefined( level.wounded_scenes ) )
	{
		level.wounded_scenes = [];
	}
	
	level.wounded_scenes[node_list_name] = [];
	
	foreach ( struct_name in node_list )
	{
		struct = GetStruct( struct_name, "targetname" );
		add_scene( struct_name, struct_name, false, false, true );
		
		anim_id = undefined;
		switch( struct.script_noteworthy )
		{
			case "ch_gen_m_wall_armcraddle_leanleft_deathpose":
				anim_id = %generic_human::ch_gen_m_wall_armcraddle_leanleft_deathpose;
				break;
			case "ch_gen_m_wall_headonly_leanleft_deathpose":
				anim_id = %generic_human::ch_gen_m_wall_headonly_leanleft_deathpose;
				break;
			case "ch_gen_m_floor_armup_legaskew_onfront_faceleft_deathpose":
				anim_id = %generic_human::ch_gen_m_floor_armup_legaskew_onfront_faceleft_deathpose;
				break;
			default:
				anim_id = %generic_human::ch_gen_m_wall_headonly_leanleft_deathpose;
				break;
		}
		
		add_actor_model_anim( struct_name + "_model", anim_id, undefined, true, undefined, undefined, "navy_dead_guy" );
		
		ArrayInsert(level.wounded_scenes[node_list_name], struct_name, 0);
	}
}

#using_animtree( "player" );
meat_shield_player()
{
	level.scr_animtree[ "player_body" ] = #animtree;
	level.scr_model[ "player_body" ] = level.player_body_menendez;
	
	level.scr_anim[ "player_body" ][ "mason_stand_loop" ][0] = %player::int_command_meatshield_player_idle;
	level.scr_anim[ "player_body" ][ "mason_move_loop" ][0] = %player::int_command_meatshield_player_forward;
	
	level.scr_anim[ "player_body" ][ "mason_stand_loop_aim" ][0] = %player::int_command_meatshield_player_idle_aiming;
	level.scr_anim[ "player_body" ][ "mason_move_loop_aim" ][0] = %player::int_command_meatshield_player_forward_aiming;
}

#using_animtree( "generic_human" );
meat_shield_victim()
{
	level.scr_anim[ "briggs" ][ "victim_stand_loop" ][0] = %ai_command_meatshield_briggs_idle;
	level.scr_anim[ "briggs" ][ "victim_move_loop" ][0] = %ai_command_meatshield_briggs_forward;
	
	level.scr_anim[ "briggs" ][ "victim_stand_loop_aim" ][0] = %ai_command_meatshield_briggs_idle_aiming;
	level.scr_anim[ "briggs" ][ "victim_move_loop_aim" ][0] = %ai_command_meatshield_briggs_forward_aiming;
}

#using_animtree( "animated_props" );
meat_shield_gun()
{
	level.scr_animtree[ "shield_gun" ] = #animtree;
	level.scr_model[ "shield_gun" ] = "t6_wpn_pistol_judge_prop_world";
	level.scr_anim[ "shield_gun" ][ "gun_stand_loop" ][0] = %animated_props::o_command_meatshield_gun_idle;
	level.scr_anim[ "shield_gun" ][ "gun_move_loop" ][0] = %animated_props::o_command_meatshield_gun_forward;
	
	level.scr_anim[ "shield_gun" ][ "gun_stand_loop_aim" ][0] = %animated_props::o_command_meatshield_gun_idle_aiming;
	level.scr_anim[ "shield_gun" ][ "gun_move_loop_aim" ][0] = %animated_props::o_command_meatshield_gun_forward_aiming;
}

scene_intro_cctv()
{	
	add_scene( "intro_cctv", "intro_interrogation_mirror_node" );
	add_actor_anim( "menendez", %generic_human::ch_command_01_01_observation_cctv_menendez );
	add_actor_anim( "salazar", %generic_human::ch_command_01_01_observation_cctv_salazar );
	add_prop_anim( "intro_handcuffs", %animated_props::o_command_01_01_observation_cctv_handcuffs, undefined, false, true );
		
	add_scene( "intro_player_loop", "intro_interrogation_mirror_node", false, false, true );
	add_player_anim( "player_body", %player::p_command_01_02_observation_loop, false );
	
	add_scene( "intro_playerturn", "intro_interrogation_mirror_node" );
	add_player_anim( "player_body", %player::p_command_01_02_observation_playerturnaround, true, 0, undefined, true, 1, 35, 35, 10, 10 );
	add_prop_anim( "bloody_rag", %animated_props::o_command_01_02_observation_playerturnaround_cloth, "p6_bloody_rag", true );
}

scene_intro_nag()
{
	add_scene( "intro_nag_loop", "intro_interrogation_mirror_node", false, false, true );
	add_actor_anim( "menendez", %generic_human::ch_command_01_03_returntointerrogation_menendez_wait );
	add_actor_anim( "salazar", %generic_human::ch_command_01_03_returntointerrogation_salazar_wait );
	add_prop_anim( "intro_handcuffs", %animated_props::o_command_01_03_returntointerrogation_handcuffs_wait, undefined, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_01_03_returntointerrogation_briggs_wait );
	
	/*
	add_scene( "intro_nag_loop_mirror", "intro_interrogation_mirror_node", false, false, true );
	add_actor_anim( "menendez_mirror", %generic_human::ch_command_01_03_returntointerrogation_menendez_wait );
	add_actor_anim( "salazar_mirror", %generic_human::ch_command_01_03_returntointerrogation_salazar_wait );
	add_prop_anim( "intro_handcuffs_mirror", %animated_props::o_command_01_03_returntointerrogation_handcuffs_wait, undefined, false, true );
	*/
	
	add_scene( "intro_briggs_leave", "intro_interrogation_mirror_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_01_03_returntointerrogation_briggs_stepasideandleave, true, false, true );
}

scene_intro_interrogation()
{
	add_scene( "intro_interrogation", "intro_interrogation_mirror_node" );
	add_actor_anim( "menendez", %generic_human::ch_command_01_03_returntointerrogation_player_enter_room_menendez );
	add_actor_anim( "salazar", %generic_human::ch_command_01_03_returntointerrogation_player_enter_room_salazar );
	add_prop_anim( "intro_handcuffs", %animated_props::o_command_01_03_returntointerrogation_player_enter_room_handcuffs, undefined, false, true );
	add_player_anim( "player_body", %player::p_command_01_03_returntointerrogation_player_enter_room, true, 0, undefined, true, 1, 15, 15, 10, 10 );
	add_prop_anim( "interrogation_chair_model", %animated_props::o_command_01_03_returntointerrogation_chair, "com_folding_chair" );
		
	add_scene( "intro_setup_chair", "intro_interrogation_mirror_node" );
	add_prop_anim( "interrogation_chair_model", %animated_props::o_command_01_03_returntointerrogation_chair, "com_folding_chair" );
	
	////////////////////////////////////////////	
	//     big ugly fight scene set-up...     //
	////////////////////////////////////////////
	//
	add_scene( "intro_fight", "intro_interrogation_mirror_node" );
	
	add_actor_anim( "menendez", %generic_human::ch_command_01_05_theprestige_menendez, true, false, true );
	add_actor_anim( "menendez_mirror", %generic_human::ch_command_01_05_theprestige_menendez_mirror, true, false, true );
	
	add_actor_anim( "salazar", %generic_human::ch_command_01_05_theprestige_salazar );
	add_actor_anim( "salazar_mirror", %generic_human::ch_command_01_05_theprestige_salazar_mirror, true, false, true );
	
	add_prop_anim( "intro_handcuffs", %animated_props::o_command_01_05_theprestige_handcuffs, undefined, false, true );
	add_prop_anim( "interrogation_pendant_model", %animated_props::o_command_01_03_returntointerrogation_pendant, "t6_wpn_pendant_prop_damaged", true );
	add_prop_anim( "interrogation_pendant_model_mirror", %animated_props::o_command_01_03_returntointerrogation_pendant_mirror, "t6_wpn_pendant_prop_damaged", true );
	
	add_player_anim( "player_body", %player::p_command_01_05_theprestige_player, true, 0, undefined, true, 1, 80, 80, 25, 25 );
	add_actor_anim( "player_mirror", %generic_human::p_command_01_05_theprestige_player_mirror, true, false, true );
	
	add_notetrack_custom_function( "player_body", "hit", maps\blackout_interrogation::callback_player_knocked_out );
	add_notetrack_flag( "salazar", "switch_off", "intro_disable_camera" );
	add_notetrack_flag( "menendez", "cuff_light", "intro_disable_handcuffs" );
	add_notetrack_custom_function( "menendez", "light_off", maps\blackout_interrogation::notetrack_lights_out );
	add_notetrack_custom_function( "menendez", "light_on", maps\blackout_interrogation::notetrack_lights_on );
	add_notetrack_custom_function( "menendez", "table_shake", maps\blackout_interrogation::notetrack_table_shake );
	add_notetrack_custom_function( "menendez", "light_flicker", maps\blackout_interrogation::notetrack_light_flicker );
	add_notetrack_custom_function( "salazar", "impact", maps\blackout_interrogation::interrogation_break_mirror );
	//
	////////////////////////////////////////////
	//   end big ugly fight scene set-up...   //
	////////////////////////////////////////////
	
}

scene_wakeup()
{
	add_scene( "wakeup_player", "intro_interrogation_node" );
	add_player_anim( "player_body", %player::p_command_02_01_wake_up_mason_wakingup, false, 0, undefined , true, 1, 30, 30, 20, 20 );
	
	add_scene( "wakeup_sal", "intro_interrogation_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_reachingout );
	
	add_scene( "getup_decide", "intro_interrogation_node", false, false, true );
	add_player_anim( "player_body", %player::p_command_02_01_wake_up_mason_idleb4makedecision, false, 0, undefined, true, 1, 30, 30, 20, 20 );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_reachingoutidle );
	
	add_scene( "getup_self", "intro_interrogation_node" );
	add_player_anim( "player_body", %player::p_command_02_01_wake_up_mason_helpdenied, true, 0, undefined, true, 1, 30, 30, 20, 20 );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_helpdenied );
	
	add_scene( "getup_sal", "intro_interrogation_node" );
	add_player_anim( "player_body", %player::p_command_02_01_wake_up_mason_helpaccepted, true, 0, undefined, true, 1, 30, 30, 20, 20 );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_helpaccepted );
	
	add_scene( "sal_locker_walk", "intro_interrogation_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_walktolocker );
	
	add_scene( "sal_locker_stand", "intro_interrogation_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_lockeridle );
	
	add_scene( "sal_door_walk", "intro_interrogation_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_walktodoor );
	
	add_scene( "sal_door_stand", "intro_interrogation_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_cautiousidle );
	
	add_scene( "sal_door_open", "intro_interrogation_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_02_01_wake_up_salazar_dooropen );
	add_player_anim( "player_body", %player::p_command_02_01_wake_up_mason_dooropen, true, 0, undefined, true, 1, 30, 30, 20, 20 );
	add_prop_anim( "interrogation_hallway_door", %animated_props::o_command_02_01_wake_up_pressuredoor_dooropen );
	
	add_scene( "stairfall", "stair_fall" );
	add_actor_anim( "stairfall_spawn", %generic_human::ch_command_02_04_up_the_staircase );
}

scene_mason_taser_knuckles()
{
	
	add_scene( "weapons_locker_idle", "intro_interrogation_node" );
	add_prop_anim( "weapons_locker", %animated_props::o_command_02_02_arm_yourself_wall_unit_loop );
	
	add_scene( "taser_knuckle_get", "knuckle_crate" );
	add_player_anim( "player_body", %player::int_specialty_blackout_lockbreaker, true );
	add_prop_anim( "hack_dongle", %animated_props::o_specialty_blackout_lockbreaker_dongle, "t6_wpn_hacking_dongle_prop", true, true );
	add_prop_anim( "knuckle_puck", %animated_props::o_specialty_blackout_lockbreaker_knuckles, "t6_wpn_tazor_knuckles_prop_view", true, true );
	
	add_scene( "taser_knuckle_crate", "knuckle_crate" );
	add_prop_anim( "knuckle_crate", %animated_props::o_specialty_blackout_lockbreaker_crate );
}

scene_hallway_devestation()
{
	// dead guys in the hallway.
	add_scene( "hallway_dead", "interrogation_hallway_node", false, false, true );
	add_actor_model_anim( "hallway_corpse01", %generic_human::ch_command_02_03_hallway_devastation_usnavy01, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
	add_actor_model_anim( "hallway_corpse02", %generic_human::ch_command_02_03_hallway_devastation_usnavy02, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
//	add_actor_model_anim( "hallway_corpse03", %generic_human::ch_command_02_03_hallway_devastation_usnavy03, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
	add_actor_model_anim( "hallway_corpse04", %generic_human::ch_command_02_03_hallway_devastation_usnavy04, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
	add_actor_model_anim( "hallway_corpse05", %generic_human::ch_command_02_03_hallway_devastation_usnavy11, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
	add_actor_model_anim( "hallway_corpse06", %generic_human::ch_command_02_03_hallway_devastation_usnavy12, undefined, true, undefined, undefined, "observation_hallway_corpse01" );
	add_actor_model_anim( "hallway_enemy04", %generic_human::ch_command_02_03_hallway_devastation_pmc04, undefined, true, undefined, undefined, "observation_hallway_enemy04" );
	
	add_scene( "hallway_cougher", "interrogation_hallway_node", false, false, true );
	add_actor_anim( "observation_hallway_cougher", %generic_human::ch_command_02_03_hallway_devastation_usnavy05_coughblood_loop, true, false, true );
	
	// guys shot down in the hallway
	add_scene( "hallway_entry_victims", "interrogation_hallway_node" );
	add_actor_anim( "observation_hallway_victim01", %generic_human::ch_command_02_03_hallway_devastation_usnavy08 );
	add_actor_anim( "observation_hallway_victim02", %generic_human::ch_command_02_03_hallway_devastation_usnavy09 );
	
	// guys shooting others down in the hallway
	add_scene( "hallway_entry_attackers", "interrogation_hallway_node" );
	add_actor_anim( "observation_hallway_enemy01", %generic_human::ch_command_02_03_hallway_devastation_pmc01 );
	add_actor_anim( "observation_hallway_enemy02", %generic_human::ch_command_02_03_hallway_devastation_pmc02 );
	add_actor_anim( "observation_hallway_enemy03", %generic_human::ch_command_02_03_hallway_devastation_pmc03 );
	
	// drag guy into adjacent room.
	add_scene( "hallway_drag", "interrogation_hallway_node" );
	add_actor_anim( "observation_hallway_surgery01", %generic_human::ch_command_02_03_hallway_devastation_usnavy06, true, false );
	add_actor_anim( "observation_hallway_surgery02", %generic_human::ch_command_02_03_hallway_devastation_usnavy07, true, false );
	add_actor_anim( "observation_hallway_surgery03", %generic_human::ch_command_02_03_hallway_devastation_usnavy10, true, false );
	
	// perform surgery on a guy.
	add_scene( "hallway_surgery", "interrogation_hallway_node", false, false, true );
	add_actor_anim( "observation_hallway_surgery01", %generic_human::ch_command_02_03_hallway_devastation_usnavy06_surgery_loop, true, false, true );
	add_actor_anim( "observation_hallway_surgery02", %generic_human::ch_command_02_03_hallway_devastation_usnavy07_surgery_loop, true, false, true );
	add_actor_anim( "observation_hallway_surgery03", %generic_human::ch_command_02_03_hallway_devastation_usnavy10_surgery_loop, true, false, true );
	
	// salazar hits the road
	add_scene( "salazar_exit", "salazar_exit", true );
	add_actor_anim( "salazar", %generic_human::ch_command_02_07_salazar_exit_sala, false, false, true );
	add_prop_anim( "salazar_exit_door", %animated_props::o_command_02_07_salazar_exit_door );
}

scene_bridge_entry()
{
	add_scene( "crash_heli", undefined, false, false, false, true );
	add_prop_anim( "crash_heli", %animated_props::fxanim_black_chopper_balcony_anim, undefined, false, false );

	level.pyro_scenes = array( "pyro_vtol_01", "pyro_vtol_02", "pyro_vtol_03", "pyro_vtol_04" );

	add_scene( "pyro_vtol_01", undefined, false, false, false, true );
	add_prop_anim( "pyro_vtol_01", %animated_props::fxanim_black_deck_vtol_01_anim, undefined, false, true );
	
	add_scene( "pyro_vtol_02", undefined, false, false, false, true );
	add_prop_anim( "pyro_vtol_02", %animated_props::fxanim_black_deck_vtol_02_anim, undefined, false, true );
	
	add_scene( "pyro_vtol_03", undefined, false, false, false, true );
	add_prop_anim( "pyro_vtol_03", %animated_props::fxanim_black_deck_vtol_03_anim, undefined, false, true );
	
	add_scene( "pyro_vtol_04", undefined, false, false, false, true );
	add_prop_anim( "pyro_vtol_04", %animated_props::fxanim_black_deck_vtol_04_anim, undefined, false, true );
	
	add_scene( "bridge_tackle", "stair_fall" );
	add_actor_anim( "bridge_tackle_pmc_01", %generic_human::ch_command_03_02_sailor_tackle_pmc01 );
	add_actor_anim( "bridge_tackle_pmc_02", %generic_human::ch_command_03_02_sailor_tackle_pmc02 );
	add_actor_anim( "bridge_tackle_sailor", %generic_human::ch_command_03_02_sailor_tackle_sailor );
	add_notetrack_custom_function( "bridge_tackle_sailor", "anim_alertness = alert", maps\blackout_bridge::sailor_kill_decide );
	
	add_scene( "familiar_face", "anim_node_before_cic" );
	add_actor_anim( "familiar_face_woman", %generic_human::ch_command_03_01_sexy_woman_woman, true, false, false, false );
	add_prop_anim( "familiar_face_door", %animated_props::o_command_03_01_sexy_woman_door );
	
	add_scene( "familiar_face_player", "anim_node_before_cic" );
	add_player_anim( "player_body", %player::p_command_03_01_sexy_woman_player, true );
		
	add_scene( "turret_intro", "anim_node_before_cic" );
	add_prop_anim( "pre_bridge_turret", %animated_props::o_command_03_02_turret_reveal_turret, "t6_wpn_turret_cic_world" );
	add_actor_anim( "turret_intro_guy_1", %generic_human::ch_command_03_02_turret_reveal_soldier01, false, true, false, true );
	add_actor_anim( "turret_intro_guy_2", %generic_human::ch_command_03_02_turret_reveal_soldier02, false, true, false, false );
	add_notetrack_custom_function( "pre_bridge_turret", "fire", maps\blackout_bridge::pre_bridge_turret_fire );
	add_notetrack_custom_function( "pre_bridge_turret", "explode", maps\blackout_bridge::pre_bridge_turret_explode );
	
	add_scene( "turret_charge", "anim_node_before_cic" );
	add_actor_anim( "turret_charge", %generic_human::ch_command_03_03_bridge_turret_soldier, false, true, false, true );	
}

scene_bridge()
{
	add_scene( "cic_body_01", "cic_body_node_01", false, false, true );
	add_actor_model_anim( "cic_body_01", %generic_human::ch_ang_07_01_charred_bodies_guy01, undefined, true, undefined, undefined, "cic_body_spawner" );
	
	add_scene( "cic_body_02", "cic_body_node_02", false, false, true );
	add_actor_model_anim( "cic_body_02", %generic_human::ch_ang_07_01_charred_bodies_guy02, undefined, true, undefined, undefined, "cic_body_spawner" );
	
	add_scene( "cic_body_03", "cic_body_node_03", false, false, true );
	add_actor_model_anim( "cic_body_03", %generic_human::ch_ang_07_01_charred_bodies_guy03, undefined, true, undefined, undefined, "cic_body_spawner" );
	
	add_scene( "bridge_hacker", "anim_node_cic" );
	add_player_anim( "player_body", %player::p_command_03_03_CIC_player_hack, true );
	
	add_scene( "cic_hacker_01_loop", "anim_node_cic", false, false, true );
	add_actor_anim( "cic_hacker_01", %generic_human::ch_command_03_03_CIC_hacker_hacker01_idle );
	
	add_scene( "cic_hacker_02_loop", "anim_node_cic", false, false, true );
	add_actor_anim( "cic_hacker_02", %generic_human::ch_command_03_03_CIC_hacker_hacker02_idle );
	
	add_scene( "cic_hacker_03_loop", "anim_node_cic", false, false, true );
	add_actor_anim( "cic_hacker_03", %generic_human::ch_command_03_02_typing_to_cover_typing_loop_pmc_08 );
	
	add_scene( "cic_hacker_01_react", "anim_node_cic" );
	add_actor_anim( "cic_hacker_01", %generic_human::ch_command_03_03_CIC_hacker_hacker01_react );
	
	add_scene( "cic_hacker_02_react", "anim_node_cic" );
	add_actor_anim( "cic_hacker_02", %generic_human::ch_command_03_03_CIC_hacker_hacker02_react );
	
	add_scene( "cic_hacker_03_react", "anim_node_cic" );
	add_actor_anim( "cic_hacker_03", %generic_human::ch_command_03_02_typing_to_cover_pmc_08 );
	
	add_scene( "bridge_flyover", undefined, false, false, false, true );
	add_vehicle_anim( "bridge_harrier", %vehicles::fxanim_black_f38_bridge_flyover_anim, true );
}

scene_security_level()
{
	// ziptied PMCs
	add_scene( "ziptied_pmc_01", "rpg_hit_anim" );
	add_actor_anim( "ziptie_pmc_01", %generic_human::ch_command_03_05_zip_tie_pmc_01, true, false );
	
	add_scene( "ziptied_sailor_01", "rpg_hit_anim" );
	add_actor_anim( "ziptie_sailor_01", %generic_human::ch_command_03_05_zip_tie_Sailor_01, false, false, false, true );
	
	add_scene( "ziptied_sailor_02", "rpg_hit_anim" );
	add_actor_anim( "ziptie_sailor_02", %generic_human::ch_command_03_05_zip_tie_Sailor_02, false, false, false, true );

	add_scene_loop( "ziptied_pmcs_loop", "rpg_hit_anim" );
	add_actor_anim( "ziptie_pmc_02", %generic_human::ch_command_03_05_zip_tie_pmc_02, true, false, true );
	add_actor_anim( "ziptie_pmc_03", %generic_human::ch_command_03_05_zip_tie_pmc_03, true, false, true );
	
	add_scene_loop( "ziptied_sailor_01_loop", "rpg_hit_anim" );
	add_actor_anim( "ziptie_sailor_01", %generic_human::ch_command_03_05_zip_tie_Sailor_01_loop, false, false, true, true );
	
	add_scene_loop( "ziptied_sailor_02_loop", "rpg_hit_anim" );
	add_actor_anim( "ziptie_sailor_02", %generic_human::ch_command_03_05_zip_tie_Sailor_02_loop, false, false, true, true );
	
	add_scene_loop( "ziptied_pmc_01_loop", "rpg_hit_anim" );
	add_actor_anim( "ziptie_pmc_01", %generic_human::ch_command_03_05_zip_tie_pmc_01_loop, true, false, true );
	
	// catwalk RPG hit.
	add_scene( "catwalk_rpg_wait", "rpg_hit_anim", false, false, true );
	add_actor_model_anim( "catwalk_rpg_toast_guy", %generic_human::ch_command_03_04_rpg_idle_sailor, undefined, false, undefined, undefined, "catwalk_rpg_toast_guy" );
	
	add_scene( "catwalk_rpg_hit", "rpg_hit_anim" );
	add_actor_model_anim( "catwalk_rpg_toast_guy", %generic_human::ch_command_03_04_rpg_sailor, undefined, false, undefined, undefined, "catwalk_rpg_toast_guy" );
	
	// Shoved out the window.
	add_scene( "window_throw", "window_throw_anim" );
	add_actor_anim( "window_throw_pmc", %generic_human::ch_command_03_05_window_throw_pmc );
	add_actor_anim( "window_throw_sailor", %generic_human::ch_command_03_05_window_throw_sailor );
	add_notetrack_custom_function( "window_throw_pmc", "break_glass", maps\blackout_security::window_throw_glass_break );
	
	// Shot down the stairs.
	add_scene( "stair_shoot", "stair_shoot_node" );
	add_actor_anim( "stair_shoot_pmc_ai", %generic_human::ch_command_03_05_down_the_stairs, false, false, false, true );

	// Backpedaling toward the player.
	add_scene( "backpedal", "stair_shoot_node" );
	add_actor_anim( "backpedal_pmc_01", %generic_human::ch_command_03_05_PMC_stairs_PMC01 );
	add_actor_anim( "backpedal_pmc_02", %generic_human::ch_command_03_05_PMC_stairs_PMC02 );
	
	// The Engineer
	add_scene( "hacker_wait", "defend_anim_node", true );
	add_actor_anim( "security_hacker", %generic_human::ch_command_03_06_hacker_hacker_start_idle );
	
	add_scene( "hacker_start", "defend_anim_node" );
	add_actor_anim( "security_hacker", %generic_human::ch_command_03_06_hacker_hacker_start );
	
	add_scene( "hacker_hack", "defend_anim_node", false, false, true );
	add_actor_anim( "security_hacker", %generic_human::ch_command_03_06_hacker_hacker_idle );
	
	add_scene( "hacker_done", "defend_anim_node" );
	add_actor_anim( "security_hacker", %generic_human::ch_command_03_06_hacker_hacker_end );
	
	// The Torchcutter
	add_scene( "torchcutters_start", "vent_entrance", true );
	add_actor_anim( "torchcutter_ai", %generic_human::ch_command_03_08_torch_wall_guy_01_in );
	
	add_scene( "torchcutters", "vent_entrance", false, false, true);
	add_actor_anim( "torchcutter_ai", %generic_human::ch_command_03_08_torch_wall_guy_01_loop );
	
	// The CCTV
	add_scene( "cctv_hacker_loop", "vent_entrance", false, false, true );
	add_actor_anim( "cctv_hacker", %generic_human::ch_command_03_08_hacker_hacker01_idle );
	
	add_scene( "cctv_hacker_react", "vent_entrance" );
	add_actor_anim( "cctv_hacker", %generic_human::ch_command_03_08_hacker_hacker01_react );
	
	// door bashes
	add_scene( "door_bash_left_start", "vent_entrance", true );
	add_actor_anim( "door_breach_victim", %generic_human::ch_command_03_06_door_break_enter_sailor );
	add_actor_anim( "door_bash_pmc02", %generic_human::ch_command_03_06_door_break_enter_pmc_03 );
	
	add_scene( "door_bash_left_wait", "vent_entrance", false, false, true );
	add_actor_anim( "door_breach_victim", %generic_human::ch_command_03_06_door_break_sailor_loop );
	add_prop_anim( "defend_door_left", %animated_props::o_command_03_06_door_break_door_01_loop, undefined, false, false );
	add_actor_anim( "door_bash_pmc02", %generic_human::ch_command_03_06_door_break_pmc_03_loop );
	
	add_scene( "door_bash_left", "vent_entrance" );
	add_actor_anim( "door_breach_victim", %generic_human::ch_command_03_06_door_break_sailor_death );
	add_prop_anim( "defend_door_left", %animated_props::o_command_03_06_door_break_door_01_bashopen, undefined, false, false );
	add_actor_anim( "door_bash_pmc02", %generic_human::ch_command_03_06_door_break_pmc_03_death );
	
	add_scene( "door_bash_right", "vent_entrance" );
	add_actor_anim( "door_bash_pmc", %generic_human::ch_command_03_06_door_break_pmc_01 );
	add_prop_anim( "defend_door_right", %animated_props::o_command_03_06_door_break_door_02_bashopen, undefined, false, false );
}

scene_menendez_cctv()
{
	add_scene( "cctv_mason_after_loop", "vent_entrance", false, false, true );
	add_player_anim( "player_body", %player::p_command_06_04_CCTV_player_idle );
	
	add_scene( "cctv_mason_after_exit", "vent_entrance" );
	add_player_anim( "player_body", %player::p_command_06_04_CCTV_player_exit, true );
	
	add_scene( "cctv_first_person_mason", "vent_entrance" );
	add_player_anim( "player_body", %player::p_command_03_08_CCTV_access_player, true, 0, undefined, true, 1, 20, 20, 10, 10 );
	add_notetrack_custom_function( "player_body", "start_clip_1", maps\blackout_security::cctv_turn_on );
	
	add_scene( "cctv_third_person", "menendez_server_anim_node" );
	add_actor_anim( "menendez", %generic_human::ch_command_03_08_CCTV_menendez_dez, false, false, true );	// delete mz because he'll be replaced by the player.
	
	
	level waittill( "story_stats_loaded" );
	
//	if( level.is_defalco_alive )
//	{
//		add_actor_anim( "defalco", %generic_human::ch_command_03_08_CCTV_menendez_guy );
//	}
//	else
//	{
//		add_actor_anim( "defalco_standin", %generic_human::ch_command_03_08_CCTV_menendez_guy );
//	}
	
	if( level.is_defalco_alive )
	{
		add_scene( "cctv_first_person_defalco", "menendez_server_anim_node" );
		add_player_anim( "player_body", %player::p_command_03_08_CCTV_menendez_player, true, 0, undefined, true, 1, 0, 0, 0, 0, true, false ); // don't tween on this one, since it's intended to pop.
		add_actor_anim( "defalco", %generic_human::ch_command_03_08_CCTV_menendez_guy );
		add_prop_anim( "menendez_start_door", %animated_props::o_command_03_08_CCTV_menendez_door, undefined, false, true );
	}
	else
	{
		add_scene( "cctv_first_person_standin", "menendez_server_anim_node" );
		add_player_anim( "player_body", %player::p_command_03_08_CCTV_menendez_player, true, 0, undefined, true, 1, 0, 0, 0, 0, true, false ); // don't tween on this one, since it's intended to pop.
		add_actor_anim( "defalco_standin", %generic_human::ch_command_03_08_CCTV_menendez_guy );
		add_prop_anim( "menendez_start_door", %animated_props::o_command_03_08_CCTV_menendez_door, undefined, false, true );
	}
}

scene_server_room()
{
	add_scene( "briggs_pip", "menendez_server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_01_salazar_PIP_briggs );
	add_actor_anim( "server_worker", %generic_human::ch_command_04_01_salazar_PIP_soldier );
}

// Amazing kill scenes slathered in awesome sauce.
//
scene_server_room_super_kill()
{
	// salazar by himself.
	add_scene( "super_kill_salazar_only", "server_anim_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_shooting_alone );
	
	//////////////////////////////////////
	//		WITH DEFALCO, VERSION A		//
	//////////////////////////////////////
	if( level.is_defalco_alive && level.is_farid_alive && level.is_karma_alive )
	{
		add_scene( "super_kill_alive_a_idle", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_a_karma_computer_loop );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_a_farid_computer_loop );
		
		add_scene( "super_kill_alive_a_react", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_a_karma_reaction );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_a_farid_reaction );
		
		add_scene( "super_kill_alive_a_wait", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_a_karma_reaction_loop );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_a_farid_reaction_loop );
		
		add_scene( "super_kill_alive_a", "server_anim_node" );
		add_actor_anim( "defalco", %generic_human::ch_command_04_04_alive_a_defalco_shooting );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_a_karma_shooting );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_a_farid_shooting );
		
		add_scene( "super_kill_alive_a_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_alive_a_salazar_shooting );
	}
		
	//////////////////////////////////////
	//		WITH DEFALCO, VERSION B		//
	//////////////////////////////////////
	
	if( level.is_defalco_alive && level.is_farid_alive && !level.is_karma_alive )
	{
		add_scene( "super_kill_alive_b_idle", "server_anim_node", false, false, true );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_b_farid_idle );
		
		add_scene( "super_kill_alive_b_react", "server_anim_node" );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_b_farid_reaction );
		
		add_scene( "super_kill_alive_b_wait", "server_anim_node", false, false, true );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_b_farid_reaction_loop );
		
		add_scene( "super_kill_alive_b", "server_anim_node" );
		add_actor_anim( "defalco", %generic_human::ch_command_04_04_alive_b_defalco_shooting );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_alive_b_farid_shooting );
		
		add_scene( "super_kill_alive_b_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_alive_b_salazar_shooting );
	}
	
	//////////////////////////////////////
	//		WITH DEFALCO, VERSION C		//
	//////////////////////////////////////
	
	if( level.is_defalco_alive && !level.is_farid_alive && level.is_karma_alive )
	{
		add_scene( "super_kill_alive_c_idle", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_idle );
		
		add_scene( "super_kill_alive_c_react", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_reaction );
		
		add_scene( "super_kill_alive_c_wait", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_reaction_loop );
		
		add_scene( "super_kill_alive_c", "server_anim_node" );
		add_actor_anim( "defalco", %generic_human::ch_command_04_04_alive_c_defalco_shooting );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_shooting );
		
		add_scene( "super_kill_alive_c_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_alive_c_salazar_shooting );
		
//		add_scene( "super_kill_alive_c_karma_dead_loop", "server_anim_node", false, false, true );
//		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_shooting_dead_loop );
	}
	
	//////////////////////////////////////
	//		W/O DEFALCO, VERSION A		//
	//////////////////////////////////////
	if( !level.is_defalco_alive && level.is_farid_alive && level.is_karma_alive )
	{
		add_scene( "super_kill_dead_a_idle", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_a_karma_idle );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_a_farid_idle );
		
		add_scene( "super_kill_dead_a_react", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_a_karma_reaction );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_a_farid_reaction );
		
		add_scene( "super_kill_dead_a_wait", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_a_karma_reaction_loop );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_a_farid_reaction_loop );
		
		add_scene( "super_kill_dead_a", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_a_karma_shooting );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_a_farid_shooting );
		
		add_scene( "super_kill_dead_a_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_dead_a_salazar_shooting );
	}
	//////////////////////////////////////
	//		W/O DEFALCO, VERSION B		//
	//////////////////////////////////////
	
	if( !level.is_defalco_alive && level.is_farid_alive && !level.is_karma_alive )
	{
		add_scene( "super_kill_dead_b_idle", "server_anim_node", false, false, true );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_b_farid_idle );
		
		add_scene( "super_kill_dead_b_react", "server_anim_node" );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_b_farid_reaction );
		
		add_scene( "super_kill_dead_b_wait", "server_anim_node", false, false, true );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_b_farid_reaction_loop );
		
		add_scene( "super_kill_dead_b", "server_anim_node" );
		add_actor_anim( "farid", %generic_human::ch_command_04_04_dead_b_farid_shooting );
		
		add_scene( "super_kill_dead_b_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_dead_b_salazar_shooting );
	}
	
	//////////////////////////////////////
	//		W/O DEFALCO, VERSION C		//
	//////////////////////////////////////
	
	if( !level.is_defalco_alive && !level.is_farid_alive && level.is_karma_alive )
	{
		add_scene( "super_kill_dead_c_idle", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_c_karma_idle );
		
		add_scene( "super_kill_dead_c_react", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_c_karma_reaction );
		
		add_scene( "super_kill_dead_c_wait", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_c_karma_reaction_loop );
		
		add_scene( "super_kill_dead_c", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_dead_c_karma_shooting );
		
		add_scene( "super_kill_dead_c_salazar", "server_anim_node" );
		add_actor_anim( "salazar", %generic_human::ch_command_04_04_dead_c_salazar_shooting );
	}
}

scene_meat_shield_aggressors()
{
	// aggressor number one
	add_scene( "shield_target_1_loop_1", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_idle );
	
	add_scene( "shield_target_1_move_1", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_reaction );
	
	add_scene( "shield_target_1_loop_2", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_reaction_loop );
	
	add_scene( "shield_target_1_move_2", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_a );
	
	add_scene( "shield_target_1_loop_3", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_a_loop );
	
	add_scene( "shield_target_1_move_3", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_b );
	
	add_scene( "shield_target_1_loop_4", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_b_loop );
	
	add_scene( "shield_target_1_move_4", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_c );
	
	add_scene( "shield_target_1_loop_5", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_c_loop );
	
	add_scene( "shield_target_1_move_5", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_d );
	
	add_scene( "shield_target_1_loop_6", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_backstep_d_loop );
	
	// aggressor number two
	add_scene( "shield_target_2_loop_1", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_idle );
	
	add_scene( "shield_target_2_move_1", "server_anim_node" );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_reaction );
	
	add_scene( "shield_target_2_loop_2", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_reaction_loop );
	
	add_scene( "shield_target_2_move_2", "server_anim_node" );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_a );
	
	add_scene( "shield_target_2_loop_3", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_a_loop );
	
	add_scene( "shield_target_2_move_3", "server_anim_node" );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_b );
	
	add_scene( "shield_target_2_loop_4", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_b_loop );
	
	add_scene( "shield_target_2_move_4", "server_anim_node" );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_c );
	
	add_scene( "shield_target_2_loop_5", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_c_loop );
	
	add_scene( "shield_target_2_move_5", "server_anim_node" );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_d );
	
	add_scene( "shield_target_2_loop_6", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_backstep_d_loop );
	
	// aggressor number 3 (Salazar)		
	add_scene( "shield_target_3_loop_1", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_idle );
	
	add_scene( "shield_target_3_move_1", "server_anim_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_reaction );
	
	add_scene( "shield_target_3_loop_2", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_reaction_loop );
	
	add_scene( "shield_target_3_move_2", "server_anim_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_backstep_a );
	
	add_scene( "shield_target_3_loop_3", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_backstep_a_loop );
	
	level.shield_target_scenes = [];
	level.shield_target_scenes[0] = [];
	
	populate_shield_target( 1, 6 );
	populate_shield_target( 2, 6 );
	populate_shield_target( 3, 3 );
}

populate_shield_target( target_index, num_positions )
{
	// populate these automagically.
	for ( i = 1; i <= num_positions; i++ )
	{
		mystruct = SpawnStruct();
		mystruct.loop = "shield_target_" + target_index + "_loop_" + i;
		if ( i != num_positions )	// fifth doesn't have a move.
		{
			mystruct.move = "shield_target_" + target_index + "_move_" + i;
		}
		
		level.shield_target_scenes[target_index-1][i-1] = mystruct;
	}
}

scene_meat_shield()
{
	// briggs and worker sit at desk.
	add_scene( "shield_victim_wait", "server_anim_node", false, false, true );
	add_actor_anim( "server_worker", %generic_human::ch_command_04_02_worker_idle );
	add_actor_anim( "briggs", %generic_human::ch_command_04_02_grabbed_briggs_idle );
	
	// defalco waits for player to grab briggs
	if( level.is_defalco_alive )
	{
		add_scene( "shield_defalco_wait_start", "server_anim_node", true );
		add_actor_anim( "defalco", %generic_human::ch_command_04_02_grab_defalco_approach );
		
		add_scene( "shield_defalco_wait", "server_anim_node", false, false, true );
		add_actor_anim( "defalco", %generic_human::ch_command_04_02_grab_defalco_pilar_loop );
	}
	else
	{
		add_scene( "shield_stand_in_wait_start", "server_anim_node", true );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_04_02_grab_defalco_approach );
		
		add_scene( "shield_stand_in_wait", "server_anim_node", false, false, true );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_04_02_grab_defalco_pilar_loop );
	}
	
	// player grabs briggs.
	add_scene( "shield_start", "server_anim_node" );
	add_prop_anim( "shield_gun", %animated_props::o_command_04_02_grab_briggs_gun, "t6_wpn_pistol_judge_prop_world", false );
	add_player_anim( "player_body", %player::p_command_04_02_grab_briggs, false );
	add_actor_anim( "briggs", %generic_human::ch_command_04_02_grabbed_briggs );
	
	if( level.is_defalco_alive )
	{
		add_scene( "shield_start_worker", "server_anim_node" );
		add_actor_anim( "server_worker", %generic_human::ch_command_04_02_worker_hit );
		add_actor_anim( "defalco", %generic_Human::ch_command_04_02_grab_defalco );
	}
	else
	{
		add_scene( "shield_start_worker_stand_in", "server_anim_node" );
		add_actor_anim( "server_worker", %generic_human::ch_command_04_02_worker_hit );
		add_actor_anim( "defalco_standin", %generic_Human::ch_command_04_02_grab_defalco );
	}
	
	// salazar's animations for the server room.
	add_scene( "salazar_server_start", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_idle );
	
	add_scene( "salazar_turn_around", "server_anim_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_backstep );

	// player and briggs stand still while the fight goes down. also, there's a gun.
	add_scene( "server_fight_shield_loop", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_fight_briggs_loop );
	add_player_anim( "player_body", %player::p_command_04_06_kneecap_fight_loop, undefined, undefined, undefined, true, 1, 15, 5, 15, 0, true );
	add_prop_anim( "shield_gun", %animated_props::o_command_04_06_kneecap_fight_gun_loop, "t6_wpn_pistol_judge_prop_world", false );
	
	// player prepares to kneecap briggs, defalco not included
	add_scene( "kneecap_start_main", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_letgo_briggs );
	add_actor_anim( "salazar", %generic_human::ch_command_04_06_kneecap_letgo_salazar );
	add_prop_anim( "shield_gun", %animated_props::o_command_04_06_kneecap_letgo_gun, "t6_wpn_pistol_judge_prop_world", true );
	add_player_anim( "player_body", %player::p_command_04_06_kneecap_letgo, true );

	add_scene( "shield_start_single", "server_anim_node" );
	add_prop_anim( "shield_gun", %animated_props::o_command_04_02_grab_briggs_gun, "t6_wpn_pistol_judge_prop_world", true );
	add_player_anim( "player_body", %player::p_command_04_02_grab_briggs, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_02_grabbed_briggs );
	add_actor_anim( "server_worker", %generic_human::ch_command_04_02_worker_hit, false, true, true );

	// defalco's part (if he's alive)
	if( level.is_defalco_alive )
	{
		add_scene( "kneecap_start_defalco", "server_anim_node" );
		add_actor_anim( "defalco", %generic_human::ch_command_04_06_kneecap_letgo_defalco );
	}
	
	// wait for the player to shoot
	add_scene( "kneecap_loop_main", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_hit_wait );
	add_actor_anim( "salazar", %generic_human::ch_command_04_06_kneecap_salazar_hit_wait );
	
	// wait for the player to shoot (defalco's pose)
	if( level.is_defalco_alive )
	{
		add_scene( "kneecap_loop_defalco", "server_anim_node", false, false, true );
		add_actor_anim( "defalco", %generic_human::ch_command_04_06_kneecap_defalco_hit_wait );
	}
	
	// briggs if shot fatally
	add_scene( "briggs_shot_fatal", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_headshot );
	
	add_scene( "briggs_shot_fatal_loop", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_deathpose_02 );
	
	// if briggs shot again after nonfatal
	add_scene( "briggs_shot_again", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_hit_kill );
	
	add_scene( "briggs_shot_again_loop", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_deadpose_01 );
	
	// briggs if shot non-fatally
	add_scene( "briggs_shot_nonfatal", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_hit_first );
	
	add_scene( "briggs_shot_nonfatal_loop", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_hit_injured );
	
	// briggs if knocked out by salazar
	add_scene( "briggs_knockout", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_ko );
	add_actor_anim( "salazar", %generic_human::ch_command_04_06_kneecap_salazar_ko );
	
	add_scene( "briggs_knockout_loop", "server_anim_node", false, false, true );
	add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_ko_loop );
	
	add_scene( "salazar_chair_wait", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_06_kneecap_salazar_chair_wait );
}

salazar_kill_animations()
{
	add_scene( "salazar_kill_wait", "server_anim_node", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_backstep_loop );
	
	add_scene( "salazar_kill", "server_anim_node" );
	add_actor_anim( "salazar", %generic_human::ch_command_04_04_backup_salazar_shooting );
	
	add_scene( "salazar_kill_victims", "server_anim_node" );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_killed );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_killed );
	
	add_scene( "salazar_kill_victims_dead", "server_anim_node", false, false, true );
	add_actor_anim( "meat_shield_target_01", %generic_human::ch_command_04_04_backup_gaurd_01_killed_loop );
	add_actor_anim( "meat_shield_target_02", %generic_human::ch_command_04_04_backup_gaurd_02_killed_loop );
}

scene_menendez_hack()
{
	add_scene( "menendez_hack", "server_anim_node" );
	add_actor_anim( "salazar",		%generic_human::ch_command_04_07_eyeball_salazar );
	add_actor_anim( "m32_handoff_pmc", %generic_human::ch_command_04_07_eyeball_pmc );
	add_player_anim( "player_body",	%player::p_command_04_07_eyeball_player, true, undefined, undefined, true, 1, 15, 5, 15, 0, true );
	add_prop_anim( "player_mask",	%animated_props::o_command_04_07_eyeball_rebreather,	"p6_breather_mask",			true );
	add_prop_anim( "eyeball",		%animated_props::o_command_04_07_eyeball_eyeball,		"p6_celerium_chip_eye",		true, true );
	add_prop_anim( "celerium_chip",	%animated_props::o_command_04_07_eyeball_chip,			"p6_celerium_chip",			true, true );
	add_prop_anim( "player_m32",	%animated_props::o_command_04_07_eyeball_m32,			"t6_wpn_launch_m32_prop",	true, true );
		
	add_notetrack_custom_function( "player_body", "mask_on", maps\blackout_menendez_start::notetrack_menenedez_mask_on );
	add_notetrack_custom_function( "player_body", "start_blink", maps\blackout_menendez_start::notetrack_blink_start );
	add_notetrack_custom_function( "player_body", "end_blink", maps\blackout_menendez_start::notetrack_blink_stop );
	add_notetrack_custom_function( "player_body", "button_01", maps\blackout_menendez_start::notetrack_video_start );
	add_notetrack_custom_function( "player_body", "smash_eye", maps\blackout_menendez_start::notetrack_eyeball_smash );

	if( level.is_defalco_alive && !level.is_farid_alive )
	{
		add_scene( "menendez_hack_defalco", "server_anim_node" );
		add_actor_anim( "defalco",		%generic_human::ch_command_04_07_eyeball_deflaco );
	}
	else
	{
		add_scene( "menendez_hack_standin", "server_anim_node" );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_04_07_eyeball_deflaco );
	}
}

scene_menendez_combat()
{
	// the opening slaughter.
	if( level.is_defalco_alive && !level.is_farid_alive )
	{
		add_scene_loop( "hangar_slaughter_wait_defalco", "hangar_control_room_anim" );
		add_actor_anim( "defalco", %generic_human::ch_command_05_02_sacrafice_pmc_01_loop );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_sacrafice_pmc_02_loop );
	}
	else
	{
		add_scene_loop( "hangar_slaughter_wait_standin", "hangar_control_room_anim" );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_05_02_sacrafice_pmc_01_loop );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_sacrafice_pmc_02_loop );
	}
	
	add_scene_loop( "hangar_slaughter_wait_pmc", "server_anim_node" );
	add_actor_anim( "m32_handoff_pmc", %generic_human::ch_command_04_07_eyeball_pmc_loop );
	
	if( level.is_defalco_alive && !level.is_farid_alive )
	{
		add_scene( "hangar_slaughter_defalco", "hangar_control_room_anim" );
		add_actor_anim( "defalco", %generic_human::ch_command_05_02_sacrafice_pmc_01 );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_sacrafice_pmc_02 );
	}
	else
	{
		add_scene( "hangar_slaughter_standin", "hangar_control_room_anim" );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_05_02_sacrafice_pmc_01 );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_sacrafice_pmc_02 );
	}
	
	add_scene( "hangar_slaughter_victims", "hangar_control_room_anim" );
	add_actor_anim( "slaughter_sailor_01", %generic_human::ch_command_05_02_sacrafice_sailor_01 );
	add_actor_anim( "slaughter_sailor_02", %generic_human::ch_command_05_02_sacrafice_sailor_02 );
	add_actor_anim( "slaughter_sailor_03", %generic_human::ch_command_05_02_sacrafice_sailor_03 );
	
	// control tower kills //
	{
		add_scene( "hangar_salazar_kill_01", "hangar_control_room_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_hangar_control_salazar_01 );
		
		add_scene( "hangar_salazar_kill_01_victim", "hangar_control_room_anim" );
		add_actor_anim( "hangar_victim_01", %generic_human::ch_command_05_02_hangar_control_pmc_01 );
		add_notetrack_custom_function( "hangar_victim_01", "start_shoot", maps\blackout_util::become_vulnerable_callback );
		add_notetrack_custom_function( "hangar_victim_01", "end_shoot", maps\blackout_util::become_vulnerable_callback );
	}	
	
	if( level.is_defalco_alive && !level.is_farid_alive )
	{
		add_scene_loop( "hangar_defalco_kill_01_idle", "hangar_control_room_anim", true );
		add_actor_anim( "hangar_victim_02", %generic_human::ch_command_05_02_hangar_control_pmc_02_idle );
		
		add_scene( "hangar_defalco_kill_01", "hangar_control_room_anim" );
		add_actor_anim( "defalco", %generic_human::ch_command_05_02_hangar_control_defalco_01 );
		
		add_scene( "hangar_defalco_kill_01_victim", "hangar_control_room_anim" );
		add_actor_anim( "hangar_victim_02", %generic_human::ch_command_05_02_hangar_control_pmc_02 );
		add_notetrack_custom_function( "hangar_victim_02", "start_shoot", maps\blackout_util::become_vulnerable_callback );
		add_notetrack_custom_function( "hangar_victim_02", "end_shoot", maps\blackout_util::become_vulnerable_callback );
	}
	else
	{
		add_scene( "hangar_standin_kill_01_idle", "hangar_control_room_anim" );
		add_actor_anim( "hangar_victim_02", %generic_human::ch_command_05_02_hangar_control_pmc_02_idle );
		
		add_scene( "hangar_standin_kill_01", "hangar_control_room_anim" );
		add_actor_anim( "defalco_standin", %generic_human::ch_command_05_02_hangar_control_defalco_01 );
		
		add_scene( "hangar_standin_kill_01_victim", "hangar_control_room_anim" );
		add_actor_anim( "hangar_victim_02", %generic_human::ch_command_05_02_hangar_control_pmc_02 );
		add_notetrack_custom_function( "hangar_victim_02", "start_shoot", maps\blackout_util::become_vulnerable_callback );
		add_notetrack_custom_function( "hangar_victim_02", "end_shoot", maps\blackout_util::become_vulnerable_callback );
	}
	
	{
		add_scene( "hangar_salazar_kill_02", "hangar_control_room_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_05_02_hangar_control_salazar_02 );
		
		add_scene( "hangar_salazar_kill_02_victim", "hangar_control_room_anim" );
		add_actor_anim( "hangar_victim_03", %generic_human::ch_command_05_02_hangar_control_pmc_03 );
		add_notetrack_custom_function( "hangar_victim_03", "start_shoot", maps\blackout_util::become_vulnerable_callback );
		add_notetrack_custom_function( "hangar_victim_03", "end_shoot", maps\blackout_util::become_vulnerable_callback );
	}
	
	
	add_scene( "hangar_balcony_kill_victim", "hangar_control_room_anim" );
	add_actor_anim( "hangar_victim_04", %generic_human::ch_command_05_02_hangar_control_sailor_01 );
	
	add_scene( "hangar_balcony_kill", "hangar_control_room_anim" );
	add_actor_anim( "hangar_attacker_01", %generic_human::ch_command_05_02_hangar_control_pmc_04 );
	
	// grenade sacrifice scene //
	
	add_scene( "hangar_sacrifice_sailor", "hangar_control_room_anim" );
	add_actor_anim( "sacrifice_sailor", %generic_human::ch_command_05_02_sacrafice_sailor_04 );
	
	add_scene( "hangar_sacrifice_pmc", "hangar_control_room_anim" );
	add_actor_anim( "sacrifice_pmc", %generic_human::ch_command_05_02_sacrafice_pmc_03 );
	                              
	add_scene( "control_room_hacker_01_loop", "hangar_control_room_anim", true, false, true );
	add_actor_anim( "hangar_attacker_01", %generic_human::ch_command_03_03_obs_deck_hacker_hacker02_idle );
	
	add_scene( "control_room_hacker_02_loop", "hangar_control_room_anim", true, false, true );
	add_actor_anim( "hangar_hack_pmc02", %generic_human::ch_command_03_03_obs_deck_hacker_hacker03_idle );
	
	add_scene( "crowbar_attack", "hangar_control_room_anim" );
	add_actor_anim( "crowbar_attacker", %generic_human::ch_command_05_03_attacked_soldier_attack );
	add_prop_anim( "attack_crowbar", %animated_props::o_command_05_03_attacked_crowbar_attack, "paris_crowbar_02", true, true );
	add_notetrack_custom_function( "crowbar_attacker", "animation_end", maps\blackout_menendez_combat::crowbar_attacker_done );
	
	add_scene( "crowbar_attack_success", "hangar_control_room_anim" );
	add_actor_anim( "crowbar_attacker", %generic_human::ch_command_05_03_attacked_soldier_success );
	add_prop_anim( "attack_crowbar", %animated_props::o_command_05_03_attacked_crowbar_success, "paris_crowbar_02", true, true );
}

scene_salute_menendez()
{
	level.salutes = [];
	
	for ( i = 1; i <= 3; i++ )
	{
		actor_name = "salute_right_" + i;
		
		scene_start_name = "salute_right_start_" + i;
		scene_name = "salute_right_" + i;
		scene_end_name = "salute_right_done_" + i;
		
		add_scene( scene_start_name, undefined, false, false, false, true );
		add_actor_anim( actor_name, %generic_human::ai_expossed_2_salute_r );
		
		add_scene( scene_name, undefined, false, false, true, true );
		add_actor_anim( actor_name, %generic_human::ai_salute_idle, false, true, true );
		
		add_scene( scene_end_name, undefined, false, false, false, true );
		add_actor_anim( actor_name, %generic_human::ai_salute_r_2_expossed );
		
		// store it for easy access.
		level.salutes[ actor_name ] = SpawnStruct();
		level.salutes[ actor_name ].start = scene_start_name;
		level.salutes[ actor_name ].loop = scene_name;
		level.salutes[ actor_name ].end = scene_end_name;
	}
	
	for ( i = 1; i <= 3; i++ )
	{
		actor_name = "salute_left_" + i;
		
		scene_start_name = "salute_left_start_" + i;
		scene_name = "salute_left_" + i;
		scene_end_name = "salute_left_done_" + i;
		
		add_scene( scene_start_name, undefined, false, false, false, true );
		add_actor_anim( actor_name, %generic_human::ai_expossed_2_salute_l );
		
		add_scene( scene_name, undefined, false, false, true, true );
		add_actor_anim( actor_name, %generic_human::ai_salute_idle );
		
		add_scene( scene_end_name, undefined, false, false, false, true );
		add_actor_anim( actor_name, %generic_human::ai_salute_l_2_expossed );
		
		// store it for easy access.
		level.salutes[ actor_name ] = SpawnStruct();
		level.salutes[ actor_name ].start = scene_start_name;
		level.salutes[ actor_name ].loop = scene_name;
		level.salutes[ actor_name ].end = scene_end_name;
	}
}

menendez_messiah()
{
	add_scene( "F35_startup_vehicle", "hanger_anim" );
	add_vehicle_anim( "F35", %vehicles::v_command_05_04_boarding_plane_f35, undefined, undefined, undefined, true );
	
	add_scene_loop( "pmc_wait_at_hanger", "hanger_anim", true );
	add_actor_anim( "plane_pmc1", %generic_human::ch_command_05_04_boarding_plane_pmc02_idle);
	add_actor_anim( "plane_pmc2", %generic_human::ch_command_05_04_boarding_plane_pmc03_idle);
	add_actor_anim( "plane_pmc3", %generic_human::ch_command_05_04_boarding_plane_pmc04_idle);
	add_actor_anim( "plane_pmc4", %generic_human::ch_command_05_04_boarding_plane_pmc05_idle);
	
	if( level.is_defalco_alive )
	{
		add_scene( "defalco_wait_at_hanger", "hanger_anim", true, false, true);
		add_actor_anim( "defalco", %generic_human::ch_command_05_04_boarding_plane_defalco_idle);
	}
	add_scene( "salazar_greet_menendez", "hanger_anim", true, false, true);
	add_actor_anim( "salazar", %generic_human::ch_command_05_04_boarding_plane_salazar_idle, true);
	
	if( level.is_defalco_alive )
	{
		add_scene( "defalco_greet_menendez", "hanger_anim");
		add_actor_anim( "defalco", %generic_human::ch_command_05_04_boarding_plane_defalco );
	}
	
	add_scene( "pmc_walkto_elevator", "hanger_anim");
	add_actor_anim( "plane_pmc1", %generic_human::ch_command_05_04_boarding_plane_pmc02_walk);
	add_actor_anim( "plane_pmc2", %generic_human::ch_command_05_04_boarding_plane_pmc03_walk);
	add_actor_anim( "plane_pmc3", %generic_human::ch_command_05_04_boarding_plane_pmc04_walk);
	add_actor_anim( "plane_pmc4", %generic_human::ch_command_05_04_boarding_plane_pmc05_walk);
	add_actor_anim( "salazar", %generic_human::ch_command_05_04_boarding_plane_salazar_walkandturn, true, false, false);
	
	add_scene( "pmc_prepare_elevator", "hanger_anim");
	add_actor_anim( "plane_pmc1", %generic_human::ch_command_05_04_boarding_plane_pmc02_prepare);
	add_actor_anim( "plane_pmc2", %generic_human::ch_command_05_04_boarding_plane_pmc03_prepare);
	add_actor_anim( "plane_pmc3", %generic_human::ch_command_05_04_boarding_plane_pmc04_prepare);
	add_actor_anim( "plane_pmc4", %generic_human::ch_command_05_04_boarding_plane_pmc05_prepare);	
}

f35_startup()
{
	add_scene( "F35_startup", "F35" );
	add_player_anim( "player_body", %player::ch_command_05_04_boarding_plane_menendez, true, 0, "tag_driver", false, 100, 30, 30, 30, 30, true, true);	
}

torch_wall_scene()
{
	add_scene( "torch_wall_loop", "vent_entrance", false, false, true );
	add_actor_anim( "torch_guy", %generic_human::ch_command_03_08_torch_wall_guy_01_loop, true );

	add_scene( "torch_wall_open", "vent_entrance", false, false, false );
	add_actor_anim( "torch_guy", %generic_human::ch_command_03_08_torch_wall_guy_01_open, true, true );
	add_prop_anim( "panel", %animated_props::o_command_03_08_torch_vent_open, "p6_mason_vent_panel" );
	
	add_scene( "torch_wall_panel_first_frame", "vent_entrance"  );
	add_prop_anim( "panel", %animated_props::o_command_03_08_torch_vent_open, "p6_mason_vent_panel" );
	add_prop_anim( "torch_wall", %animated_props::o_command_03_08_torch_vent_open, "p6_mason_vent", false, true );
	
	add_scene( "torch_wall_panel_open", "vent_entrance"  );
	add_prop_anim( "panel", %animated_props::o_command_03_08_torch_vent_open, "p6_mason_vent_panel" );
	
	add_scene( "torch_wall_panel_idle", "vent_entrance", false, false, true );
	add_prop_anim( "panel", %animated_props::o_command_03_08_torch_vent_idle, "p6_mason_vent_panel" );
}

player_kick_anim()
{
	add_scene( "player_sit_down", "vent_exit" );
	add_player_anim( "player_body", %player::p_command_03_08_vent_kick_in, true, 0, undefined, true, 1, 35, 35, false, false);
	
	add_scene( "panel_knockdown", "vent_exit" );
	add_prop_anim( "crawl_space_exit", %animated_props::o_command_03_08_vent_kick_vent, "p6_mason_vent", false, true );
	add_prop_anim( "crawl_space_exit_panel", %animated_props::o_command_03_08_vent_kick_vent, "p6_mason_vent_panel", false, true );
	
	//crawl_space_exit
	
//	
//	add_scene( "player_kick_wait", "vent_exit" );
//	add_player_anim( "player_body", %player::p_command_03_08_vent_kick_idle, false, 0, undefined, false, 1, 35, 35, false, false );
//	
//	add_scene( "first_player_kick", "vent_exit" );
//	add_player_anim( "player_body", %player::p_command_03_08_vent_kick_1, false, 0, undefined, true, 1, 35, 35, false, false );
//	
//	add_scene( "second_player_kick", "vent_exit" );
//	add_player_anim( "player_body", %player::p_command_03_08_vent_kick_2, false, 0, undefined, true, 1, 35, 35, false, false );
//	
//	add_scene( "last_player_kick", "vent_exit" );
//	add_player_anim( "player_body", %player::p_command_03_08_vent_kick_3, true, 0, undefined, true, 1, 35, 35, false, false );
//	add_notetrack_custom_function( "player_body", "kick_vent", ::kick_open_vent );	
}

kick_open_vent()
{
	vent = GetEnt ("crawl_space_exit", "targetname");
	vent NotSolid();
	vent ConnectPaths();
	vent delete();	
}

aftermath_scene()
{	
	add_scene( "pip_eye", "server_anim_node" );
	add_actor_anim( "menendez", %generic_human::ch_command_04_07_eyeball_rewind_menendez, true, false, true );
	add_prop_anim( "eyeball",		%animated_props::o_command_04_07_eyeball_rewind_eyeball, "p6_celerium_chip_eye", true, true );
	add_prop_anim( "pendent",		%animated_props::o_command_04_07_eyeball_rewind_pendant, "t6_wpn_pendant_prop_damaged", true, true );
	
	add_scene( "redshirt_02_briggs_dead_enter", "server_anim_node", true);
	add_actor_anim( "redshirt2", %generic_human::ch_command_06_03_aftermath_redshirt_02_brigs_dead_enter);
	
	add_scene( "redshirt_02_briggs_dead_loop", "server_anim_node", false, false, true);
	add_actor_anim( "redshirt2", %generic_human::ch_command_06_03_aftermath_redshirt_02_brigs_dead_loop);
	
	if( !level.is_farid_alive || level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) )
	{
		add_scene( "redshirt_01_karma_dead_enter", "server_anim_node" );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_karma_dead_enter);
		
		add_scene( "redshirt_01_karma_dead_loop", "server_anim_node", false, false, true);
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_karma_dead_loop);
		
		add_scene( "redshirt_01_karma_dead_tableloop", "server_anim_node", false, false, true);
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_karma_dead_tableloop);
	
		add_scene( "redshirt_01_karma_dead_table_exit", "server_anim_node" );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_karma_dead_table_exit);	
	}
	
	if( !( level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) )  && !level.is_farid_alive )
	{	
		add_scene( "karma_dead_pose", "server_anim_node", false, false, true );
		add_actor_anim( "karma", %generic_human::ch_command_04_04_alive_c_karma_shooting_dead_loop, true, false);
	}
	else if( !( level.player get_story_stat( "KARMA_DEAD_IN_KARMA" ) ) )
	{
		add_scene( "player_karma_alive", "server_anim_node" );
		add_player_anim( "player_body", %player::p_command_06_03_aftermath_computer_karma_alive, false, undefined, undefined );
	
		add_scene( "aftermath_karma_injured", "server_anim_node", false, false, true);
		add_actor_anim( "karma", %generic_human::ch_command_06_03_aftermath_karma_injured_loop, true, false);	
		
		add_scene( "karma_get_up", "server_anim_node" );
		add_actor_anim( "karma", %generic_human::ch_command_06_03_aftermath_karma_get_up);
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_get_up);
		
		add_scene( "karma_wait", "server_anim_node", false, false, true);
		add_actor_anim( "karma", %generic_human::ch_command_06_03_aftermath_karma_standing_loop, true, false);
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_standing_loop);
		
		add_scene( "karma_computer", "server_anim_node", false, false, true);
		add_actor_anim( "karma", %generic_human::ch_command_06_03_aftermath_karma_computer_loop, true, false);
	}
	
	if( level.is_harper_alive )
	{
		add_scene( "player_harper_alive", "server_anim_node" );
		add_player_anim( "player_body", %player::p_command_06_03_aftermath_computer_harper_alive, false, undefined, undefined );
		
		add_scene( "harper_enter", "server_anim_node", true);
		add_actor_anim( "harper", %generic_human::ch_command_06_03_aftermath_harper_enter);
		
		add_scene( "harper_loop", "server_anim_node", false, false, true);
		add_actor_anim( "harper", %generic_human::ch_command_06_03_aftermath_harper_loop);
		
		add_scene( "harper_walk_to_door", "server_anim_node", true);
		add_actor_anim( "harper", %generic_human::ch_command_06_03_aftermath_harper_walk_to_door);
		
		add_scene( "harper_door_loop", "server_anim_node", false, false, true);
		add_actor_anim( "harper", %generic_human::ch_command_06_03_aftermath_harper_door_loop);
		
		add_scene( "harper_open_door", "server_anim_node");
		add_actor_anim( "harper", %generic_human::ch_command_06_03_aftermath_harper_open_door);
	}
	
	if( level.player get_story_stat( "DEFALCO_DEAD_IN_COMMAND_CENTER" ) )
	{
		add_scene( "defalco_dead_pose", "server_anim_node", false, true, true );
		add_actor_anim( "defalco", %generic_human::ch_command_04_01_dead_pose_c, true, false );
	}
	
	if( !level.is_harper_alive )
	{
		add_scene( "farid_dead_pose", "server_anim_node", false, true, true );
		add_actor_anim( "farid", %generic_human::ch_command_04_01_dead_pose_d, true, false );
	}
	
	if ( !level.is_briggs_alive )
	{
		add_scene( "briggs_dead_pose", "server_anim_node", false, true, true );
		add_actor_anim( "briggs", %generic_human::ch_command_04_06_kneecap_briggs_deadpose_01, true, false );
	}
	else
	{
		add_scene( "aftermath_briggs_enter", "server_anim_node", false);
		add_actor_anim( "briggs", %generic_human::ch_command_06_03_aftermath_briggs_enter_loop, true, false);
		
		add_scene( "aftermath_briggs_wait", "server_anim_node", false, false, true);
		add_actor_anim( "briggs", %generic_human::ch_command_06_03_aftermath_briggs_wait_for_player, true, false);
	}
	
	add_scene( "redshirt_02_enter", "server_anim_node" );
	add_actor_anim( "redshirt2", %generic_human::ch_command_06_03_aftermath_redshirt_02_enter);
	
	add_scene( "redshirt_02_wait", "server_anim_node", false, false, true);
	add_actor_anim( "redshirt2", %generic_human::ch_command_06_03_aftermath_redshirt_02_wait_for_player);
	
	add_scene( "player_sit", "server_anim_node");
	add_player_anim( "player_body", %player::p_command_06_03_aftermath_sit, false, undefined, undefined );
	
	if ( level.is_briggs_alive )
	{
		add_scene( "player_sit_briggs_alive", "server_anim_node");
		add_player_anim( "player_body", %player::p_command_06_03_aftermath_sit_briggs_alive, false, undefined, undefined );
	}
	
	add_scene( "player_loop", "server_anim_node" );
	add_player_anim( "player_body", %player::p_command_06_03_aftermath_computer_loop, false, undefined, undefined );
	addnotetrack_customfunction( "player_body", "play_sect_without_his_access_c_0", ::aftermath_vo1);
	addnotetrack_customfunction( "player_body", "play_sect_we_ll_need_our_tech_0", ::aftermath_vo2 );
	
	add_scene( "player_exit", "server_anim_node");
	add_player_anim( "player_body", %player::p_command_06_03_aftermath_computer_exit, true, undefined, undefined, true );
	
	if ( level.is_briggs_alive )
	{
		add_scene( "aftermath_briggs_walkoff", "server_anim_node" );
		add_actor_anim( "briggs", %generic_human::ch_command_06_03_aftermath_briggs_walk_off, true, false, true);
	}
	
	add_scene( "redshirt_02_walkoff", "server_anim_node", true);
	add_actor_anim( "redshirt2", %generic_human::ch_command_06_03_aftermath_redshirt_02_walk_off, true, false, true);
	
	add_scene( "redshirt_01_enter", "server_anim_node" );
	add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_enter);
	
	add_scene( "redshirt1_guard", "server_anim_node");
	add_actor_anim( "redshirt1", %generic_human::ch_command_06_03_aftermath_redshirt_01_move_gaurding);
}

betrayal_scene()
{	
	add_scene( "betrayal_surrender_waving_loop", "hanger_anim", false, false, true);
	add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_waving_loop, true );
	
	add_scene( "betrayal_dolly_zoom_pose_loop", "player_dolly_zoom", false, false, true );
	add_player_anim( "player_body", %player::p_command_06_06_betrayal_player_end, true, 0, "tag_origin"  );
	
	add_scene( "betrayal_speech_player", "player_dolly_zoom" );
	add_player_anim( "player_body", %player::p_command_06_06_betrayal_player_speach, false, 0, "tag_origin" );
	
	add_scene( "betrayal_speech_sal", "hanger_anim" );
	add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_speach, true );
	
	add_scene( "betrayal_surrender_sal_idle_loop", "hanger_anim", false, false, true);
	add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_idle, true );
	
	if( level.is_harper_alive )
	{
		add_scene( "betrayal_surrender_harper", "hanger_anim" );
		add_actor_anim( "harper", %generic_human::ch_command_06_06_betrayal_harper_surrender );
		add_notetrack_custom_function( "harper", "start_punched", ::play_sal_punched );
		
		add_scene( "betrayal_surrender_punched", "hanger_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_punched, true );
		
		add_scene( "betrayal_surrender_harper_idle_loop", "hanger_anim", false, false, true);
		add_actor_anim( "harper", %generic_human::ch_command_06_06_betrayal_harper_wait_loop );
		
		add_scene( "betrayal_shot", "hanger_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_shot, true );
		add_actor_anim( "harper", %generic_human::ch_command_06_06_betrayal_harper_shot );
	}
	else
	{
		add_scene( "betrayal_redshirt_walkup", "hanger_anim" );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_06_betrayal_redshirt_01_surrender );
		
		add_scene( "betrayal_redshirt_wait_loop", "hanger_anim", false, false, true );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_06_betrayal_redshirt_01_wait_loop );
		
		add_scene( "betrayal_sal_hands_down", "hanger_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_hands_down, true );
		
		add_scene( "betrayal_sal_captured", "hanger_anim" );
		add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_lives, true );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_06_betrayal_redshirt_01_lives );
		
		add_scene( "betrayal_sal_captured_loop", "hanger_anim", false, false, true );
		add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_lives_loop, true );
		add_actor_anim( "redshirt1", %generic_human::ch_command_06_06_betrayal_redshirt_01_lives_loop );
	}

	add_scene( "tele_sal", "hanger_anim" );
	add_actor_anim( "salazar", %generic_human::ch_command_06_06_betrayal_salazar_surrender, true );
}

play_sal_punched( guy )
{
	run_scene( "betrayal_surrender_punched" );
	run_scene( "betrayal_surrender_sal_idle_loop" );
}

startfov( guy )
{
	level.player thread lerp_fov_overtime( 1.5, 100 );
}

midfov( guy )
{
	level.player thread lerp_fov_overtime( 1.5, 30 );	
}

endfov( guy )
{
	level.player thread lerp_fov_overtime( 1.5, 60 );
}

gassed_bodies()
{
	add_scene( "victim01_floor_idle", "gas_victim_01", false, false, true );
	add_actor_anim( "aftermath_dead_1", %generic_human::ch_command_06_05_gassed_victims_victim01_floor_idle, true, false);	
	
	add_scene( "victim01_transition", "gas_victim_01" );
	add_actor_anim( "aftermath_dead_1", %generic_human::ch_command_06_05_gassed_victims_victim01_transition, true, false);	
	
	add_scene( "victim01_recover_idle", "gas_victim_01", false, false, true );
	add_actor_anim( "aftermath_dead_1", %generic_human::ch_command_06_05_gassed_victims_victim01_recover_idle, true, false, true);	
	
	add_scene( "victim02_floor_idle", "gas_victim_02", false, false, true );
	add_actor_anim( "aftermath_dead_2", %generic_human::ch_command_06_05_gassed_victims_victim02_floor_idle, true, false);	
	
	add_scene( "victim02_transition", "gas_victim_02" );
	add_actor_anim( "aftermath_dead_2", %generic_human::ch_command_06_05_gassed_victims_victim02_transition, true, false);	
	
	add_scene( "victim02_recover_idle", "gas_victim_02", false, false, true );
	add_actor_anim( "aftermath_dead_2", %generic_human::ch_command_06_05_gassed_victims_victim02_recover_idle, true, false, true);	
	
	add_scene( "victim03_floor_idle", "gas_victim_03", false, false, true );
	add_actor_anim( "aftermath_dead_3", %generic_human::ch_command_06_05_gassed_victims_victim04_floor_idle, true, false);	
	
	add_scene( "victim03_transition", "gas_victim_03" );
	add_actor_anim( "aftermath_dead_3", %generic_human::ch_command_06_05_gassed_victims_victim04_transition, true, false);	
	
	add_scene( "victim03_recover_idle", "gas_victim_03", false, false, true );
	add_actor_anim( "aftermath_dead_3", %generic_human::ch_command_06_05_gassed_victims_victim04_recover_idle, true, false, true);	
	
	add_scene( "victim04_floor_idle", "gas_victim_04", false, false, true );
	add_actor_anim( "aftermath_dead_4", %generic_human::ch_command_06_05_gassed_victims_victim05_floor_idle, true, false);	
	
	add_scene( "victim04_transition", "gas_victim_04" );
	add_actor_anim( "aftermath_dead_4", %generic_human::ch_command_06_05_gassed_victims_victim05_transition, true, false);	
	
	add_scene( "victim04_recover_idle", "gas_victim_04", false, false, true );
	add_actor_anim( "aftermath_dead_4", %generic_human::ch_command_06_05_gassed_victims_victim05_recover_idle, true, false, true);	
	
	add_scene( "victim05_floor_idle", "gas_victim_05", false, false, true );
	add_actor_anim( "aftermath_dead_5", %generic_human::ch_command_06_05_gassed_victims_victim06_floor_idle, true, false);	
	
	add_scene( "victim05_transition", "gas_victim_05" );
	add_actor_anim( "aftermath_dead_5", %generic_human::ch_command_06_05_gassed_victims_victim06_transition, true, false);	
	
	add_scene( "victim05_recover_idle", "gas_victim_05", false, false, true );
	add_actor_anim( "aftermath_dead_5", %generic_human::ch_command_06_05_gassed_victims_victim06_recover_idle, true, false, true);	
	
	add_scene( "victim06_floor_idle", "gas_victim_06", false, false, true );
	add_actor_anim( "aftermath_dead_6", %generic_human::ch_command_06_05_gassed_victims_victim07_floor_idle, true, false);	
	
	add_scene( "victim06_transition", "gas_victim_06" );
	add_actor_anim( "aftermath_dead_6", %generic_human::ch_command_06_05_gassed_victims_victim07_transition, true, false);	
	
	add_scene( "victim06_recover_idle", "gas_victim_06", false, false, true );
	add_actor_anim( "aftermath_dead_6", %generic_human::ch_command_06_05_gassed_victims_victim07_recover_idle, true, false, true);	
	
	add_scene( "victim07_floor_idle", "gas_victim_07", false, false, true );
	add_actor_anim( "aftermath_dead_7", %generic_human::ch_command_06_05_gassed_victims_victim08_floor_idle, true, false);	
	
	add_scene( "victim07_transition", "gas_victim_07" );
	add_actor_anim( "aftermath_dead_7", %generic_human::ch_command_06_05_gassed_victims_victim08_transition, true, false);	
	
	add_scene( "victim07_recover_idle", "gas_victim_07", false, false, true );
	add_actor_anim( "aftermath_dead_7", %generic_human::ch_command_06_05_gassed_victims_victim08_recover_idle, true, false, true);	
	
	add_scene( "victim08_floor_idle", "gas_victim_08", false, false, true );
	add_actor_anim( "aftermath_dead_8", %generic_human::ch_command_06_05_gassed_victims_victim09_floor_idle, true, false);	
	
	add_scene( "victim08_transition", "gas_victim_08" );
	add_actor_anim( "aftermath_dead_8", %generic_human::ch_command_06_05_gassed_victims_victim09_transition, true, false);	
	
	add_scene( "victim08_recover_idle", "gas_victim_08", false, false, true );
	add_actor_anim( "aftermath_dead_8", %generic_human::ch_command_06_05_gassed_victims_victim09_recover_idle, true, false, true);	
	
	add_scene( "victim09_floor_idle", "gas_victim_09", false, false, true );
	add_actor_anim( "aftermath_dead_9", %generic_human::ch_command_06_05_gassed_victims_victim01_floor_idle, true, false);	
	
	add_scene( "victim09_transition", "gas_victim_09" );
	add_actor_anim( "aftermath_dead_9", %generic_human::ch_command_06_05_gassed_victims_victim01_transition, true, false);	
	
	add_scene( "victim09_recover_idle", "gas_victim_09", false, false, true );
	add_actor_anim( "aftermath_dead_9", %generic_human::ch_command_06_05_gassed_victims_victim01_recover_idle, true, false, true);	
	
	add_scene( "victim10_floor_idle", "gas_victim_10", false, false, true );
	add_actor_anim( "guy1", %generic_human::ch_command_06_05_gassed_victims_victim02_floor_idle, true, false);	
	
	add_scene( "victim10_transition", "gas_victim_10" );
	add_actor_anim( "guy1", %generic_human::ch_command_06_05_gassed_victims_victim02_transition, true, false);	
	
	add_scene( "victim10_recover_idle", "gas_victim_10", false, false, true );
	add_actor_anim( "guy1", %generic_human::ch_command_06_05_gassed_victims_victim02_recover_idle, true, false, true);	
	
	add_scene( "victim11_floor_idle", "gas_victim_11", false, false, true );
	add_actor_anim( "guy2", %generic_human::ch_command_06_05_gassed_victims_victim05_floor_idle, true, false);	
	
	add_scene( "victim11_transition", "gas_victim_11" );
	add_actor_anim( "guy2", %generic_human::ch_command_06_05_gassed_victims_victim05_transition, true, false);	
	
	add_scene( "victim11_recover_idle", "gas_victim_11", false, false, true );
	add_actor_anim( "guy2", %generic_human::ch_command_06_05_gassed_victims_victim05_recover_idle, true, false, true);	
	
	add_scene( "victim12_floor_idle", "gas_victim_12", false, false, true );
	add_actor_anim( "guy3", %generic_human::ch_command_06_05_gassed_victims_victim04_floor_idle, true, false);	
	
	add_scene( "victim12_transition", "gas_victim_12" );
	add_actor_anim( "guy3", %generic_human::ch_command_06_05_gassed_victims_victim04_transition, true, false);	
	
	add_scene( "victim12_recover_idle", "gas_victim_12", false, false, true );
	add_actor_anim( "guy3", %generic_human::ch_command_06_05_gassed_victims_victim04_recover_idle, true, false, true);	
}

menendez_view_deck()
{		
	add_scene( "menendez_f38", "hanger_anim" );
	add_vehicle_anim( "F35", %vehicles::v_command_05_06_flight_deck_f35_liftoff, false, undefined, undefined, true );
	
	add_scene( "menendez_f38_elevator", "hanger_anim" );
	add_prop_anim( "menendez_elevator", %animated_props::o_command_05_04_boarding_plane_elevator, undefined, false, true );
	
	add_scene( "menendez_load_f38", "F35" );
	add_player_anim( "player_body", %player::p_command_05_04_boarding_plane_menendez, true, 0, "origin_animate_jnt" );
	add_notetrack_custom_function( "player_body", "mask_off", maps\blackout_menendez_start::notetrack_menendez_mask_off );
	add_notetrack_custom_function( "player_body", "Detach_ladder", ::detatch_f38_parts );
	add_notetrack_custom_function( "player_body", "Start_crash", ::spawn_crash_f38 );
	
	//detatch_f38_parts
	//spawn_crash_f38
	
	add_scene( "menendez_reflection", "F35_reflection" );
	add_actor_anim( "menendez", %generic_human::ch_command_05_04_boarding_plane_menendez, true, false, true, true );	
	add_notetrack_custom_function( "menendez", "f35_client_notify", maps\blackout_amb::f35_snapshot_notify_start );//kevin adding notetrack calls
	
}

rewind()
{
	add_scene( "rewind_meatshield", "server_anim_node" );
	add_actor_anim( "briggs", %generic_human::ch_command_04_02_grabbed_briggs_rewind );
	
	if( ! ( level.player get_story_stat( "DEFALCO_DEAD_IN_KARMA" ) ) )
	{
		add_actor_anim( "defalco", %generic_human::ch_command_04_02_grab_defalco_rewind );
	}
	
	add_actor_anim( "server_worker", %generic_human::ch_command_04_02_worker_hit_rewind );
	add_player_anim( "player_body", %player::p_command_04_02_grab_briggs_rewind );
	
	add_scene( "rewind_cctv", "menendez_server_anim_node" );
	add_player_anim( "player_body", %player::p_command_03_08_CCTV_menendez_player_rewind, true );
	
	if( ! ( level.player get_story_stat( "DEFALCO_DEAD_IN_KARMA" ) ) )
	{
		add_actor_anim( "defalco", %generic_human::ch_command_03_08_CCTV_menendez_guy_rewind );
	}
	
	add_scene( "rewind_plane", "F35" );
	add_player_anim( "player_body", %player::p_command_05_04_boarding_plane_rewind_menendez, false, 0, "origin_animate_jnt" );
	
	add_scene( "rewind_mask", "server_anim_node" );
	add_player_anim( "player_body", %player::p_command_04_07_gasmask_rewind_menendez );
	add_actor_anim( "salazar",		%generic_human::ch_command_04_07_gasmask_rewind_salazar );
	add_prop_anim( "player_mask",	%animated_props::o_command_04_07_gasmask_rewind_rebreather,	"p6_breather_mask",		true );
	add_prop_anim( "player_m32",	%animated_props::o_command_04_07_gasmask_rewind_m32,		"t6_wpn_launch_m32_prop",	true, true );
	add_actor_anim( "m32_handoff_pmc", %generic_human::ch_command_04_07_gasmask_rewind_pmc, true, false, true );
	
	add_scene( "rewind_eye", "server_anim_node" );
	add_player_anim( "player_body", %player::p_command_04_07_eyeball_rewind_player );
	add_prop_anim( "eyeball",		%animated_props::o_command_04_07_eyeball_rewind_eyeball,		"p6_celerium_chip_eye",		true, true );
}

brute_force()
{	
	add_scene( "brute_force_move", "brute_force_computer_struct" );
	add_player_anim( "player_body", %player::int_specialty_blackout_bruteforce, true );
	add_prop_anim( "brute_force_jaws", %animated_props::o_specialty_blackout_bruteforce_jaws, "t6_wpn_jaws_of_life_prop", true );
	add_prop_anim( "brute_force_debris", %animated_props::o_specialty_blackout_bruteforce_debris );
	
	add_scene( "brute_force_launch", "brute_force_computer_struct" );
	add_player_anim( "player_body", %player::int_specialty_blackout_bruteforce_console, true );

	add_scene( "brute_force_f38", "anim_node_deck1" );
	add_vehicle_anim( "brute_force_f38", %vehicles::v_command_07_04_brute_force_plane, true );
	addnotetrack_customfunction( "brute_force_f38", "explode", maps\blackout_deck::brute_force_explosions );
}

vtol_escape()
{
	add_scene( "player_vtol_escape", "player_vtol" );
	add_player_anim( "player_body", %player::p_command_07_07_anderson_vtol_player, false, 0, "tag_origin" );
	
	add_scene( "player_vtol_escape_loop", "player_vtol", false, false, true );
	add_player_anim( "player_body", %player::p_command_07_07_anderson_vtol_player_loop, true, 0, "tag_origin", true, 1, 90, 20, 20, 20, true );
	
	add_scene( "vtol_taxi", "anim_node_deck2"  );
	add_vehicle_anim( "player_vtol", %vehicles::v_command_07_07_anderson_vtol_x78_taxi );
	add_notetrack_custom_function( "player_vtol", "start_harper_get_on", ::play_harper_get_on );

	add_scene( "anderson_idle", "player_vtol", false, false, true );
	add_actor_anim( "anderson", %generic_human::ch_command_07_07_anderson_vtol_anderson_idle, true, false, false, true, "tag_origin" );
	
	add_scene( "anderson_end", "player_vtol" );
	add_actor_anim( "anderson", %generic_human::ch_command_07_07_anderson_vtol_anderson_end, true, false, false, true, "tag_origin" );
	//
	//ch_command_07_07_anderson_vtol_anderson_idle
	
	if( level.is_harper_alive )
	{
		add_scene( "harper_ground_loop", "anim_node_deck2", false, false, true );
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_harper_ground_loop );
	
		add_scene( "harper_enter_vtol", "anim_node_deck2");
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_harper_enter );
		
		add_scene( "harper_get_on_vtol", "player_vtol");
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_harper_get_on, true, false, false, true, "tag_origin" );
		
		add_scene( "harper_nag", "player_vtol", false, false, true );
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_harper_nag, true, false, false, true, "tag_origin" );
		
		add_scene( "harper_vtol_escape", "player_vtol" );
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_harper_end, true, false, false, true, "tag_origin" );
		
		add_scene( "harper_vtol_idle", "player_vtol", false, false, true );
		add_actor_anim( "harper", %generic_human::ch_command_07_07_anderson_vtol_idle_harper, true, false, false, true, "tag_origin" );
	}

	add_scene( "vtol_takeoff", "anim_node_deck2"  );
	add_vehicle_anim( "player_vtol", %vehicles::v_command_07_07_anderson_vtol_x78_takeoff_01 );
}

play_harper_get_on( guy )
{
	if ( level.is_harper_alive )
	{
		level run_scene( "harper_enter_vtol" );
		level.harper thread say_dialog( "harp_come_on_man_0" );
		level run_scene( "harper_get_on_vtol" );
		level run_scene( "harper_nag" );	
	}
}

f38_crash_into_bridge()
{	
	add_scene( "fa38_crash", "fx_anim_f38_crash_struct" );
	add_vehicle_anim( "fa38_flyover", %vehicles::fxanim_black_f38_bridge_crash_anim );
	add_notetrack_custom_function( "fa38_flyover", "exploder 10680 #start_shooting", ::f38_fire_guns );
	add_notetrack_level_notify( "fa38_flyover", "exploder 10681 #stop_shooting", "f38_stop_firing" );
	add_notetrack_custom_function( "fa38_flyover", "exploder 10681 #stop_shooting", ::f38_crash_rocket_notetrack );
	
}

console_chair_scenes()
{
	add_scene( "console_chair_idle", "server_anim_node" );
	add_prop_anim( "console_chair", %animated_props::o_command_06_03_aftermath_chair_player_idle, "p6_console_chair_swivel" );
	
	add_scene( "console_chair_player_sit", "server_anim_node" );
	add_prop_anim( "console_chair", %animated_props::o_command_06_03_aftermath_chair_player_sit, "p6_console_chair_swivel" );
	
	add_scene( "console_chair_karma_sit_loop", "server_anim_node" );
	add_prop_anim( "console_chair", %animated_props::o_command_06_03_aftermath_chair_karma_sit_loop, "p6_console_chair_swivel" );
}

f38_crash_rocket_notetrack()
{
	rocket_start = getstruct( "f38_rocket_struct", "targetname" );
	fa38 = GetEnt( "fa38_flyover", "targetname" );
	fa38 veh_magic_bullet_shield();
	
	wait 0.7;
	
	MagicBullet( "usrpg_magic_bullet_cmd_sp", rocket_start.origin, fa38.origin, undefined, fa38 );
}

f38_fire_guns()
{
	level endon( "f38_stop_firing" );
	
	fa38 = GetEnt( "fa38_flyover", "targetname" );
	
	while( 1 )
	{
		fa38 fire_turret( 1 );
		fa38 fire_turret( 2 );
	
		wait 0.1;
	}
}

aftermath_vo1( guy )
{
	if( level.briggs_loop_aftermath )
	{
		level.player say_dialog( "sect_without_his_access_c_0 " );
		level.player say_dialog( "sect_damn_we_re_locked_0 " );
	}
}

aftermath_vo2( guy )
{
	if( level.karma_loop_aftermath )
	{
		level.player say_dialog( "sect_we_ll_need_our_tech_0" );
	}
}

#define REFLECTION_WIDTH 32
#define REFLECTION_HEIGHT 18

detatch_f38_parts( guy )
{
	level.f35 DetachAll();
	
	level.f35 Attach( "veh_t6_air_fa38_extracam", "tag_canopy" );
	
	origin = getstruct( "reflection_cam", "targetname" );	
	sm_cam_ent = spawn_model( "tag_origin", origin.origin, origin.angles );
	
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	SetSavedDvar( "r_extracam_custom_aspectratio", REFLECTION_WIDTH / REFLECTION_HEIGHT );
	sm_cam_ent SetClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
	scene_wait( "menendez_load_f38");
	
	sm_cam_ent ClearClientFlag( CLIENT_FLAG_INTRO_EXTRA_CAM );
	
}

spawn_crash_f38( guy ) 
{
	run_scene( "fa38_crash" );
}
