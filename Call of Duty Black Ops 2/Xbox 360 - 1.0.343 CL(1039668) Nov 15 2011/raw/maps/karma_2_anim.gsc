
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

//#using_animtree ("generic_human");
main()
{
	perk_anims(); // uses Digital Devices - specialty_trespasser
	civilian_anims();
	
	event_07_precache_anims();
	event_08_precache_anims();
	event_09_precache_anims();
	event_10_precache_anims();

	fx_anims();			// Trees etc......
	
	precache_assets();	
}

#using_animtree("fxanim_props");
//
//...................
fx_anims()
{
	level.scr_anim["fxanim_props"]["coco02_tree_a"] = %fxanim_gp_tree_palm_coco02_dest01_sm_anim;
	level.scr_anim["fxanim_props"]["coco02_tree_b"] = %fxanim_gp_tree_palm_coco02_dest02_sm_anim;
}

#using_animtree("generic_human");
//
//
perk_anims()
{
	// Event 5
	// uses Digital Devices - specialty_trespasser
	add_scene( "trespasser", "align_trespasser" );
	add_prop_anim( "trespasser_phone", 		%animated_props::o_specialty_trespasser_phone, "test_p_anim_specialty_trespasser_device", true );
	add_prop_anim( "trespasser_card", 		%animated_props::o_specialty_trespasser_phone, "test_p_anim_specialty_trespasser_card_swipe", true );	
	add_player_anim( "player_body", 			%player::int_specialty_trespasser, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	
	// Event 7
	// uses Padlocks etc. - specialty_intruder
	add_scene( "intruder", "align_intruder" );
	add_prop_anim( "lock_lock_breaker", 		%animated_props::o_specialty_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
	add_prop_anim( "torch_lock_breaker", 		%animated_props::o_specialty_intruder_torch, "test_p_anim_specialty_lockbreaker_device", true );
	add_player_anim( "player_body", 			%player::int_specialty_intruder, SCENE_DELETE );	

	// Event 8
	// Uses objects - specialty_brutestrength
	add_scene( "brute", "align_brute" );
}


//
//...................
civilian_anims()
{
	level.scr_anim[ "generic" ][ "civ_walk" ][0]			= %ch_karma_3_4_civwalk_01;
	level.scr_anim[ "generic" ][ "civ_walk" ][1]			= %ch_karma_3_4_civwalk_02;
	level.scr_anim[ "generic" ][ "civ_walk" ][2]			= %ch_karma_3_4_civwalk_03;
	level.scr_anim[ "generic" ][ "civ_walk" ]				= %ch_karma_3_4_civwalk_01;
	
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
    level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ch_karma_3_4_cividle_01;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %ch_karma_3_4_cividle_02;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %ch_karma_3_4_cividle_03;
	
	
	level.scr_anim[ "generic" ][ "civ_checkin_idle_1" ][0]			= %ch_karma_3_4_cividle_01;
	level.scr_anim[ "generic" ][ "civ_checkin_idle_2" ][0]			= %ch_karma_3_4_cividle_02;
	
	level.scr_anim[ "generic" ][ "pause" ][0]				= %ch_karma_3_4_cividle_01;
	level.scr_anim[ "generic" ][ "pause" ][1]				= %ch_karma_3_4_cividle_02;
	level.scr_anim[ "generic" ][ "pause" ][2]				= %ch_karma_3_4_cividle_03;
	
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;

	//
	// DRONE civ normal anims
	//
	level.drones.anims[ "civ_walk" ][0]			= %fakeShooters::ch_karma_3_4_civwalk_01;
	level.drones.anims[ "civ_walk" ][1]			= %fakeShooters::ch_karma_3_4_civwalk_02;
	level.drones.anims[ "civ_walk" ][2]			= %fakeShooters::ch_karma_3_4_civwalk_03;
	
	level.drones.anims[ "civ_idle" ][0]			= %fakeShooters::ch_karma_3_4_cividle_01;
	level.drones.anims[ "civ_idle" ][1]			= %fakeShooters::ch_karma_3_4_cividle_02;
	level.drones.anims[ "civ_idle" ][2]			= %fakeShooters::ch_karma_3_4_cividle_03;

}



//*****************************************************************************
//*****************************************************************************
#using_animtree( "generic_human" );
event_07_precache_anims()
{
}


event_07_anims()
{
	// wounded_civs
	// civs_exiting_tag_align
	// boat_escape


	//********************
	// Wounded Group1 anim
	//********************

	add_scene( "scene_e7_wounded_group1", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP ); 
	
	add_actor_model_anim( "e7_wounded_man_1", %ch_karma_7_1_civs_treated_01, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_1", %ch_karma_7_1_civs_treated_02, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_2", %ch_karma_7_1_civs_treated_03, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_2", %ch_karma_7_1_civs_treated_04, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_3", %ch_karma_7_1_civs_treated_05, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_3", %ch_karma_7_1_civs_treated_06, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_4", %ch_karma_7_1_civs_treated_07, undefined, SCENE_DELETE );



	//********************
	// Wounded Group2 anim
	//********************

	add_scene( "scene_e7_wounded_group2", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP ); 

	add_actor_model_anim( "e7_wounded_woman_4", %ch_karma_7_1_civs_treated_08, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_5", %ch_karma_7_1_civs_treated_09, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_5", %ch_karma_7_1_civs_treated_10, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_6", %ch_karma_7_1_civs_treated_11, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_6", %ch_karma_7_1_civs_treated_12, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_7", %ch_karma_7_1_civs_treated_13, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_woman_7", %ch_karma_7_1_civs_treated_14, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_wounded_man_8", %ch_karma_7_1_civs_treated_15, undefined, SCENE_DELETE );


	//***************************************************
	// Doctor and Nurse anim - In Hospital Area - Looping
	//***************************************************

	add_scene( "scene_e7_doctor_and_nurse_loop", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "e7_doctor", %ch_karma_7_1_civs_treated_doctor, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_nurse", %ch_karma_7_1_civs_treated_nurse, SCENE_HIDE_WEAPON );


	//*****************************************************************
	// Four civilians already at the window - In Titanic Area - Looping
	//*****************************************************************
	
	add_scene( "scene_e7_civs_at_window_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_civ4_window_loop_1", %ch_karma_7_2_civs_watch_escape_01, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_civ4_window_loop_2", %ch_karma_7_2_civs_watch_escape_02, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_civ4_window_loop_3", %ch_karma_7_2_civs_watch_escape_03, undefined, SCENE_DELETE );
	add_actor_model_anim( "e7_civ4_window_loop_4", %ch_karma_7_2_civs_watch_escape_04, undefined, SCENE_DELETE );


	//***********************************************
	// Two civilians walk to window - In Titanic Area
	//***********************************************

	add_scene( "scene_e7_couple_approach_window_part1", "boat_escape" );
	add_actor_anim( "e7_civ1_watch_escape", %ch_karma_7_2_civs_watch_escape_05, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_civ2_watch_escape", %ch_karma_7_2_civs_watch_escape_06, SCENE_HIDE_WEAPON );
	
	add_scene( "scene_e7_couple_approach_window_part2_loop", "boat_escape", false, false, true  );
	add_actor_anim( "e7_civ1_watch_escape", %ch_karma_7_2_civs_watch_escape_05_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_civ2_watch_escape", %ch_karma_7_2_civs_watch_escape_06_idle, SCENE_HIDE_WEAPON );


	//***********************************************
	// Single guy approaches window - In Titanic Area
	//***********************************************

	add_scene( "scene_e7_single_approach_window_part1", "boat_escape" );
	add_actor_anim( "e7_civ_approach_window", %ch_karma_7_2_civs_watch_escape_07, SCENE_HIDE_WEAPON );

	add_scene( "scene_e7_single_approach_window_part2_loop", "boat_escape", !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "e7_civ_approach_window", %ch_karma_7_2_civs_watch_escape_07_idle, SCENE_HIDE_WEAPON );


	//***********************************************
	// Titanic Moment Animations
	//***********************************************

	add_scene( "scene_e7_titanic_moment_docka_loop", "titanic_moment", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "evac_docka_civ01", %ch_karma_7_1_evac_docka_civ01, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ02", %ch_karma_7_1_evac_docka_civ02, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ03", %ch_karma_7_1_evac_docka_civ03, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ04", %ch_karma_7_1_evac_docka_civ04, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ05", %ch_karma_7_1_evac_docka_civ05, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ06", %ch_karma_7_1_evac_docka_civ06, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ07", %ch_karma_7_1_evac_docka_civ07, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ08", %ch_karma_7_1_evac_docka_civ08, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_civ09", %ch_karma_7_1_evac_docka_civ09, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_docka_securityguard", %ch_karma_7_1_evac_docka_securityguard, undefined, SCENE_DELETE );

	add_scene( "scene_e7_titanic_moment_dockb_loop", "titanic_moment", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "evac_dockb_civ01", %ch_karma_7_1_civ_evac_dockb_civ_01, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_civ02", %ch_karma_7_1_civ_evac_dockb_civ_02, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_civ03", %ch_karma_7_1_civ_evac_dockb_civ_03, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_civ04", %ch_karma_7_1_civ_evac_dockb_civ_04, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_civ05", %ch_karma_7_1_civ_evac_dockb_civ_05, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_civ06", %ch_karma_7_1_civ_evac_dockb_civ_06, undefined, SCENE_DELETE );
	add_actor_model_anim( "evac_dockb_securityguard", %ch_karma_7_1_civ_evac_dockb_securityguard, undefined, SCENE_DELETE );


	//*****************************************************
	// Defalco drags karma (with security) through the mall
	//*****************************************************

	add_scene( "scene_event8_defalco_karma_intro", "mall_intro" );
	add_actor_anim( "defalco", %ch_karma_8_1_karma_dragged_defalco, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "karma", %ch_karma_8_1_karma_dragged_karma, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "e8_solder1_start_anim", %ch_karma_8_1_karma_dragged_bodyguard1, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "e8_solder2_start_anim", %ch_karma_8_1_karma_dragged_bodyguard2, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	precache_assets( true );
}

	
//*****************************************************************************
//*****************************************************************************
	
#using_animtree( "generic_human" );
event_08_precache_anims()
{
	//*******************************************************
	// Misc civilians at the Start of Event 8
	//*******************************************************
	
	add_scene( "scene_e8_intro_civ_couple_1", "mall_intro" );
	//add_actor_anim( "e7_wounded_man_1", %ch_karma_8_1_upper_level_escape_01 );
	//add_actor_anim( "e7_wounded_woman_1", %ch_karma_8_1_upper_level_escape_02 );
	add_actor_model_anim( "e7_wounded_man_1", %ch_karma_8_1_upper_level_escape_01, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );
	add_actor_model_anim( "e7_wounded_woman_1", %ch_karma_8_1_upper_level_escape_02, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );

	add_scene( "scene_e8_intro_civ_couple_2", "mall_intro" );
	//add_actor_anim( "e7_wounded_man_2", %ch_karma_8_1_upper_level_escape_03 );
	//add_actor_anim( "e7_wounded_woman_2", %ch_karma_8_1_upper_level_escape_04 );
	add_actor_model_anim( "e7_wounded_man_2", %ch_karma_8_1_upper_level_escape_03, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );
	add_actor_model_anim( "e7_wounded_woman_2", %ch_karma_8_1_upper_level_escape_04, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );

	add_scene( "scene_e8_intro_civ_single_1", "mall_intro" );
	//add_actor_anim( "e7_wounded_man_3", %ch_karma_8_1_upper_level_escape_05 );
	add_actor_model_anim( "e7_wounded_man_3", %ch_karma_8_1_upper_level_escape_05, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );

	add_scene( "scene_e8_intro_civ_single_2", "mall_intro" );
	//add_actor_anim( "e7_wounded_woman_4", %ch_karma_8_1_upper_level_escape_06 );
	add_actor_model_anim( "e7_wounded_woman_4", %ch_karma_8_1_upper_level_escape_06, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );
	
	add_scene( "scene_e8_intro_civ_single_3", "mall_intro" );
	//add_actor_anim( "e7_wounded_man_4", %ch_karma_8_1_upper_level_escape_07 );
	add_actor_model_anim( "e7_wounded_man_4", %ch_karma_8_1_upper_level_escape_07, "c_usa_hillaryclinton_g20_fb", SCENE_HIDE_WEAPON );
}


event_08_anims()
{
	//*******************************************************
	// Soldiers enter fighting cover at the start of the mall
	//*******************************************************

	add_scene( "scene_e8_intro_guard1", "mall_intro" );
	add_actor_anim( "e8_start_anim_guard1", %ch_karma_8_1_karma_dragged_guard1 );
	add_scene( "scene_e8_intro_guard2", "mall_intro" );
	add_actor_anim( "e8_start_anim_guard2", %ch_karma_8_1_karma_dragged_guard2 );
	add_scene( "scene_e8_intro_guard3", "mall_intro" );
	add_actor_anim( "e8_start_anim_guard3", %ch_karma_8_1_karma_dragged_guard3 );
	add_scene( "scene_e8_intro_guard4", "mall_intro" );
	add_actor_anim( "e8_start_anim_guard4", %ch_karma_8_1_karma_dragged_guard4 );


	//*******************************************************
	// Bad guy shoots security at start
	//*******************************************************

	add_scene( "scene_event8_mall_execution", "mall_intro" );
	add_actor_anim( "guard_rocks_executioner", %ch_karma_8_1_railing_toss_enemy );
	add_actor_anim( "civ_executed_on_rocks", %ch_karma_8_1_railing_toss_security, SCENE_HIDE_WEAPON );
		
	
// sb42
/*
ch_karma_9_1_stair_rush_guard_idl
*/

	//**********************************************************************
	// Big group of civs trapped in Event 9 waitng for the door breach
	//**********************************************************************

	add_scene( "scene_event8_stair_rush_girl_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_girl_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_idl );
	add_scene( "scene_event8_stair_rush_girl_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_girl_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_girl_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_idl );
	add_scene( "scene_event8_stair_rush_girl_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy1_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_guy1_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_idl );
	add_scene( "scene_event8_stair_rush_guy1_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy1_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_guy1_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_idl );
	add_scene( "scene_event8_stair_rush_guy1_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy2_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_guy2_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_idl );
	add_scene( "scene_event8_stair_rush_guy2_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy2_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_guy2_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_idl );
	add_scene( "scene_event8_stair_rush_guy2_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy3_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy3_b", %ch_karma_9_1_stair_rush_guy3_b_start, undefined, SCENE_DELETE );
	add_scene( "scene_event8_stair_rush_guy3_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy3_b", %ch_karma_9_1_stair_rush_guy3_b_idl );
	add_scene( "scene_event8_stair_rush_guy3_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy3_b", %ch_karma_9_1_stair_rush_guy3_b_stairs, undefined, SCENE_DELETE );

	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************


//*****************************************************************************
//*****************************************************************************
event_09_precache_anims()
{
}

event_09_anims()
{
	setup_strength_test_ai_anims();
	setup_strength_test_player_anims();


	//**********************************************************************
	// Injured civilian animations - Running past player fire fight at start
	//**********************************************************************

	add_scene( "scene_event9_civ_injured_and_helper_part1", "event9_civ_ambient" );
	add_actor_model_anim( "civ_male_rich", %ch_karma_9_1_civcouple_helper, undefined );
	add_actor_model_anim( "civ_female_rich", %ch_karma_9_1_civcouple_injured, undefined );
	
	add_scene( "scene_event9_civ_injured_and_helper_part2", "event9_civ_ambient", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_male_rich", %ch_karma_9_1_civcouple_helper_idle, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_female_rich", %ch_karma_9_1_civcouple_injured_idle, undefined, SCENE_DELETE );


	//**********************************************************************
	// Rocks execution Animation
	//**********************************************************************

	add_scene( "scene_event9_rocks_execution", "event9_civ_ambient" );
	add_actor_anim( "guard_rocks_executioner", %ch_karma_9_1_rockdeath_civ );
	add_actor_anim( "civ_executed_on_rocks", %ch_karma_9_1_rockdeath_enemy, SCENE_HIDE_WEAPON );
	

	//******************************
	// Group of 4 civilians escaping
	//******************************

	add_scene( "scene_civilian_group4_escape_begin_loop", "civi_escape_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_escape_1", %ch_karma_9_1_civ_helper_idle, undefined );
	add_actor_model_anim( "civ_escape_2", %ch_karma_9_1_civ_hurryup_idle, undefined );
	add_actor_model_anim( "civ_escape_3", %ch_karma_9_1_civ_injured_idle, undefined );
	add_actor_model_anim( "civ_escape_4", %ch_karma_9_1_civ_labored_idle, undefined );
		
	add_scene( "scene_civilian_group4_escape_running", "civi_escape_1" );
	add_actor_model_anim( "civ_escape_1", %ch_karma_9_1_civ_helper_escape, undefined );
	add_actor_model_anim( "civ_escape_2", %ch_karma_9_1_civ_hurryup_escape, undefined );
	add_actor_model_anim( "civ_escape_3", %ch_karma_9_1_civ_injured_escape, undefined );
	add_actor_model_anim( "civ_escape_4", %ch_karma_9_1_civ_labored_escape, undefined );
	
	add_scene( "scene_civilian_group4_escape_end_loop", "civi_escape_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_escape_1", %ch_karma_9_1_civ_helper_escape_idle, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_escape_2", %ch_karma_9_1_civ_hurryup_escape_idle, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_escape_3", %ch_karma_9_1_civ_injured_escape_idle, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_escape_4", %ch_karma_9_1_civ_labored_escape_idle, undefined, SCENE_DELETE );
	

	//******************************
	// 4 stage animations - Group 1
	//******************************	

	add_scene( "scene_civilian_left_stairs_group1_begin_loop", "crazed_civilians", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_left_stairs_male_1", %ch_karma_9_2_escalator_civ_a1_start_idl, undefined );
	add_actor_model_anim( "civ_left_stairs_female_1", %ch_karma_9_2_escalator_civ_a2_start_idl, undefined );

	add_scene( "scene_civilian_left_stairs_group1_run", "crazed_civilians" );
	add_actor_model_anim( "civ_left_stairs_male_1", %ch_karma_9_2_escalator_civ_a1_run2base, undefined );
	add_actor_model_anim( "civ_left_stairs_female_1", %ch_karma_9_2_escalator_civ_a2_run2base, undefined );

	add_scene( "scene_civilian_left_stairs_group1_begin_loop_mid", "crazed_civilians", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_left_stairs_male_1", %ch_karma_9_2_escalator_civ_a1_base_idl, undefined );
	add_actor_model_anim( "civ_left_stairs_female_1", %ch_karma_9_2_escalator_civ_a2_base_idl, undefined );

	add_scene( "scene_civilian_left_stairs_group1_run_and_exit", "crazed_civilians" );
	add_actor_model_anim( "civ_left_stairs_male_1", %ch_karma_9_2_escalator_civ_a1_run_escalator, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_left_stairs_female_1", %ch_karma_9_2_escalator_civ_a2_run_escalator, undefined, SCENE_DELETE );


	//******************************
	// 4 stage animations - Group 2
	//******************************	

	add_scene( "scene_civilian_left_stairs_group2_begin_loop", "crazed_civilians", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_left_stairs_male_2", %ch_karma_9_2_escalator_civ_b1_start_idl, undefined );
	add_actor_model_anim( "civ_left_stairs_female_2", %ch_karma_9_2_escalator_civ_b2_start_idl, undefined );

	add_scene( "scene_civilian_left_stairs_group2_run", "crazed_civilians" );
	add_actor_model_anim( "civ_left_stairs_male_2", %ch_karma_9_2_escalator_civ_b1_run2base, undefined );
	add_actor_model_anim( "civ_left_stairs_female_2", %ch_karma_9_2_escalator_civ_b2_run2base, undefined );

	add_scene( "scene_civilian_left_stairs_group2_begin_loop_mid", "crazed_civilians", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_left_stairs_male_2", %ch_karma_9_2_escalator_civ_b1_base_idl, undefined );
	add_actor_model_anim( "civ_left_stairs_female_2", %ch_karma_9_2_escalator_civ_b2_base_idl, undefined );

	add_scene( "scene_civilian_left_stairs_group2_run_and_exit", "crazed_civilians" );
	add_actor_model_anim( "civ_left_stairs_male_2", %ch_karma_9_2_escalator_civ_b1_run_escalator, undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_left_stairs_female_2", %ch_karma_9_2_escalator_civ_b2_run_escalator, undefined, SCENE_DELETE );
	

	//*****************************
	// Balcony fling at start of E9
	//*****************************

	add_scene( "scene_e9_start_balcony_fling", "courtyard_civ_escape_mall" );
	add_actor_anim( "balcony_fight_fling_enemy", %ch_karma_9_1_balcony_fling_enemy );
	add_actor_model_anim( "balcony_fight_fling_friendly", %ch_karma_9_1_balcony_fling_security, undefined );
	

	//*******************************************
	// Balcony fling blowup during 1st half of E9
	//*******************************************

	add_scene( "scene_e9_balcony_blowup_ledge_fall", "event9_corner_bldg" );
	add_actor_model_anim( "civ_left_balcony_blowup_male_1", %ch_karma_9_2_helicopter_balcony_a_guard01, undefined );
	add_actor_model_anim( "civ_left_balcony_blowup_female_1", %ch_karma_9_2_helicopter_balcony_a_guard02, undefined );

	add_scene( "scene_e9_balcony_blowup_stairs_stumble", "event9_corner_bldg" );
	add_actor_anim( "civ_left_balcony_blowup_stairs_stumble_1", %ch_karma_9_2_helicopter_balcony_b_guard01, undefined );
	add_actor_anim( "civ_left_balcony_blowup_stairs_stumble_2", %ch_karma_9_2_helicopter_balcony_b_guard02, undefined );

	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************
event_10_precache_anims()
{
}

event_10_anims()
{
	//***************
	// Event10 Dialog
	//***************

	add_dialog( "caution_mason_defaloc", "Mason don't let Defalco escape with Karma" );
	add_dialog( "mason_stay_back", "Mason, stay back or i'll blow up the Ship" );


	//***************
	// Setup Event 10
	//***************

	//player_hdg = 65;			// 60
	//player_pitch_up = 30;		// 75
	//player_pitch_down = 40;		// 45
	

	//******************************************
	// STANDOFF SETUP - Defalco starts the scene
	//******************************************

	add_scene( "scene_event10_start", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_setup_defa, SCENE_HIDE_WEAPON );
	add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_setup_guard1 );
	add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_setup_guard2 );
	add_actor_anim( "harper", %ch_karma_10_1_standoff_setup_harper );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_setup_karm, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar", %ch_karma_10_1_standoff_setup_salazar );
//	add_player_anim( "player_body", %player::p_karma_10_1_standoff_setup_player, !SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 0.8, player_hdg, player_hdg, player_pitch_up, player_pitch_down );
	add_prop_anim( "fake_player", %animated_props::p_karma_10_1_standoff_setup_player );
		

	//***************************************************************
	// Defalco walks backwards with karma and security guards
	// Player should shoot karma and break out of anim into hit react
	// If the player fails to shoot Karma its a mission failure
	//***************************************************************
	
	add_scene( "scene_event10_standoff_shoot_karma", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_defa, SCENE_HIDE_WEAPON );
	add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_guard1, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_guard2, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "harper", %ch_karma_10_1_standoff_harper );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_karm, SCENE_HIDE_WEAPON  );
	add_actor_anim( "salazar", %ch_karma_10_1_standoff_sala );
	//add_player_anim( "player_body", %player::p_karma_10_1_standoff_player, !SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 0.8, player_hdg, player_hdg, player_pitch_up, player_pitch_down );
	add_prop_anim( "fake_player", %animated_props::p_karma_10_1_standoff_player );
	

	//***************************************************************
	// Karma shot on ground idle loop
	//***************************************************************

	add_scene( "scene_event10_karma_idle_shot_loop", "new_ending", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_prone_karma, SCENE_HIDE_WEAPON );


	//***************************************************************
	// Salazar shot on ground idle loop
	//***************************************************************
	
	add_scene( "scene_event10_salazar_idle_shot_loop", "new_ending", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar", %ch_karma_10_1_standoff_prone_salazar, SCENE_HIDE_WEAPON );
	
		
	//***************************************************************************************************
	// GUARD DEATH ANIMS - Unaligned, Harper and Salazar shoot the guards, play these death anims on them
	//***************************************************************************************************

	add_scene( "scene_event10_standoff_death_guard", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_death_guard1, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_death_guard2, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	

	//***************************************************************
	// SUCCESS - Karma disabled
	//***************************************************************
	
	add_scene( "scene_event10_standoff_success", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_success_defalco, SCENE_HIDE_WEAPON );
	add_actor_anim( "harper", %ch_karma_10_1_standoff_success_harper );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_success_karma );
	add_actor_anim( "salazar", %ch_karma_10_1_standoff_success_salazar );
	add_prop_anim( "fake_player", %animated_props::p_karma_10_1_standoff_success_player );


	//***************************************************************
	// SUCCESS - Karma disabled Part 2
	//***************************************************************
	
	add_scene( "scene_event10_standoff_success_part2", "new_ending" );
	//add_actor_anim( "defalco", %ch_karma_10_1_standoff_success_defalco, SCENE_HIDE_WEAPON );
	add_actor_anim( "harper", %ch_karma_10_3_ending_harper );
	add_actor_anim( "karma", %ch_karma_10_3_ending_karma );
	add_actor_anim( "salazar", %ch_karma_10_3_ending_salazar );
	add_actor_anim( "han", %ch_karma_10_3_ending_medic );
	add_prop_anim( "fake_player", %animated_props::p_karma_10_3_ending_player );
	//add_prop_anim( "plane_osprey", %animated_props::v_karma_10_3_ending_vtol );
	//add_vehicle_anim( "plane_vtol", %vehicles::v_karma_10_3_ending_vtol, true, undefined, "tag_origin" );
	add_vehicle_anim( "plane_vtol", %vehicles::v_karma_10_3_ending_vtol );
	

	//***************************************************************
	// FAILURE - Karma Killed
	//***************************************************************

	add_scene( "scene_event10_standoff_karma_killed", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_karma_shot_fail_defa, SCENE_HIDE_WEAPON  );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_karma_shot_fail_karm, SCENE_HIDE_WEAPON  );


	//***************************************************************
	// FAILURE - Defalco Shot
	//***************************************************************

	add_scene( "scene_event10_standoff_defalco_shot", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_success_defalco, SCENE_HIDE_WEAPON );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_success_karma );


	//***************************************************************
	// FAILURE - Failure to Shoot
	//***************************************************************

	add_scene( "scene_event10_standoff_failure_to_shoot", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_standoff_escape_defa, SCENE_HIDE_WEAPON  );
	//add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_escape_guard1 );
	//add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_escape_guard2 );
	add_actor_anim( "harper", %ch_karma_10_1_standoff_escape_harper );
	add_actor_anim( "karma", %ch_karma_10_1_standoff_escape_karm, SCENE_HIDE_WEAPON  );
	add_actor_anim( "salazar", %ch_karma_10_1_standoff_escape_sala );
	//add_player_anim( "player_body", %player::p_karma_10_1_standoff_escape_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 0.8, player_hdg, player_hdg, player_pitch_up, player_pitch_down );
	add_prop_anim( "fake_player", %animated_props::p_karma_10_1_standoff_escape_player );

	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************

setup_strength_test_ai_anims()
{
	// Setup the anims for the Enemy strength text attacker
	level.scr_anim["e_strength_enemy"]["strength_test_start"] = %ch_khe_E3_nvaturretDive_nva01;
	level.scr_anim["e_strength_enemy"]["strength_test_loop"][0] = %ch_khe_E3_nvaturretDive_choke_nva01;
	level.scr_anim["e_strength_enemy"]["strength_test_success"] = %ch_khe_E3_nvaturretDive_success_nva01;
	addNotetrack_customFunction( "e_strength_enemy", "boom", maps\karma_util::nva_boom, "strength_test_success" );
}

setup_strength_test_player_anims()
{
	// Setup marine full body
	//level.scr_model["player_body"] = level.player_interactive_model;
	//level.scr_animtree["player_body"] = #animtree;

	// Setup marine interactive hands
	//level.scr_model["player_hands"] = level.player_interactive_hands;
	//level.scr_animtree["player_hands"] = #animtree;

	// Player strength test anims
	level.scr_anim["player_body"]["strength_test_start"] = %player::ch_khe_E3_nvaturretDive_player;
	level.scr_anim["player_body"]["strength_test_loop"][0] = %player::ch_khe_E3_nvaturretDive_choke_player;
	level.scr_anim["player_body"]["strength_test_success"] = %player::ch_khe_E3_nvaturretDive_success_player;
}


