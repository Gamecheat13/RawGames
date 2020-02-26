
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
//	civilian_anims();
	traversal_anims();
	exit_club_precache_anims();
	mall_precache_anims();
	sundeck_precache_anims();
	the_end_precache_anims();
	fx_anims();			// Trees etc......
	
	precache_assets();	
	
	maps\voice\voice_karma_2::init_voice();
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
//	// Event 5
//	// uses Digital Devices - specialty_trespasser
//	add_scene( "trespasser", "align_trespasser" );
//	add_prop_anim( "trespasser_phone", 		%animated_props::o_specialty_trespasser_phone, "test_p_anim_specialty_trespasser_device", true );
//	add_prop_anim( "trespasser_card", 		%animated_props::o_specialty_trespasser_phone, "test_p_anim_specialty_trespasser_card_swipe", true );	
//	add_player_anim( "player_body", 			%player::int_specialty_trespasser, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	
	// Event 7
	// uses Padlocks etc. - specialty_intruder
//	add_scene( "intruder", "align_intruder" );
//	add_prop_anim( "lock_lock_breaker", 		%animated_props::o_specialty_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
//	add_prop_anim( "torch_lock_breaker", 		%animated_props::o_specialty_intruder_torch, "test_p_anim_specialty_lockbreaker_device", true );
//	add_player_anim( "player_body", 			%player::int_specialty_intruder, true );	
	
	add_scene( "intruder", "align_armory_door" );
	add_prop_anim( "intruder_cutter", 			%animated_props::o_specialty_karma_intruder_cutter, "t6_wpn_laser_cutter_prop", SCENE_DELETE );
	add_prop_anim( "intruder_armory_door", %animated_props::o_specialty_karma_intruder_door, undefined, !SCENE_DELETE);
	add_prop_anim( "intruder_stinger", 	%animated_props::o_specialty_karma_intruder_stinger, "t6_wpn_launch_fhj18_world", SCENE_DELETE);
	add_player_anim( "player_body", 			%player::int_specialty_karma_intruder, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA );	
	add_notetrack_custom_function( "intruder_cutter", "zap_start", maps\karma_exit_club::intruder_zap_start );
	add_notetrack_custom_function( "intruder_cutter", "zap_end", maps\karma_exit_club::intruder_zap_end );
	add_notetrack_custom_function( "intruder_cutter", "start", maps\karma_exit_club::intruder_cutter_on );
	
	// Event 8
	// Uses objects - specialty_brutestrength
//	add_scene( "brute", "align_brute_force" );
//	add_prop_anim( "lock_lock_breaker", 		%animated_props::o_specialty_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
//	add_prop_anim( "torch_lock_breaker", 		%animated_props::o_specialty_intruder_torch, "test_p_anim_specialty_lockbreaker_device", true );
//	add_player_anim( "player_body", 			%player::int_specialty_intruder, true );	
	
	add_scene( "brute", "anim_bruteforce_leftdoor" );
	add_prop_anim( "bruteforce_jaws", 			%animated_props::o_specialty_karma_bruteforce_jaws, "t6_wpn_jaws_of_life_prop", !SCENE_DELETE, false, undefined, "tag_origin" );
	add_prop_anim( "anim_bruteforce_rightdoor", %animated_props::o_specialty_karma_bruteforce_rightdoor, undefined, !SCENE_DELETE, false, undefined, "tag_origin");
	add_prop_anim( "anim_bruteforce_leftdoor", 	%animated_props::o_specialty_karma_bruteforce_leftdoor, undefined, !SCENE_DELETE, false, undefined, "tag_origin");
	add_player_anim( "player_body", 			%player::int_specialty_karma_bruteforce, SCENE_DELETE, PLAYER_1, "tag_origin", !SCENE_DELTA );	
}

traversal_anims()
{
	level.scr_anim[ "generic" ][ "ai_roll_over_84_down_40_l" ]			= %ai_roll_over_84_down_40_l;
	level.scr_anim[ "generic" ][ "ai_roll_over_84_down_40_r" ]			= %ai_roll_over_84_down_40_r;
	level.scr_anim[ "generic" ][ "ai_mantle_over_36_down_154" ]			= %ai_mantle_over_36_down_154;
	level.scr_anim[ "generic" ][ "ai_mantle_over_36_down_154_roll" ]	= %ai_mantle_over_36_down_154_roll;
	level.scr_anim[ "generic" ][ "ai_crawl_under_door" ]				= %ai_crawl_under_door;
	level.scr_anim[ "generic" ][ "ai_roll_under_door" ]					= %ai_roll_under_door;
	level.scr_anim[ "generic" ][ "ai_mantle_over_42_down_74_01" ]		= %ai_mantle_over_42_down_74_01;
	level.scr_anim[ "generic" ][ "ai_mantle_over_42_down_74_02" ]		= %ai_mantle_over_42_down_74_02;
	
}

//
//...................
civilian_anims()
{
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
	level.drones.anims[ "civ_walk" ][0]			= %fakeShooters::ai_civ_m_walk_00;
	level.drones.anims[ "civ_walk" ][1]			= %fakeShooters::ai_civ_m_walk_01;
	level.drones.anims[ "civ_walk" ][2]			= %fakeShooters::ai_civ_m_walk_03;
	
	level.drones.anims[ "civ_idle" ][0]			= %fakeShooters::ch_karma_3_4_cividle_01;
	level.drones.anims[ "civ_idle" ][1]			= %fakeShooters::ch_karma_3_4_cividle_02;
	level.drones.anims[ "civ_idle" ][2]			= %fakeShooters::ch_karma_3_4_cividle_03;

}


//*****************************************************************************
//*****************************************************************************
#using_animtree( "generic_human" );
exit_club_precache_anims()
{
}


exit_club_anims()
{
	// wounded_civs
	// civs_exiting_tag_align
	// boat_escape


	//***********************************************
	// Intro Karma2 scene, explosion aftermath
	//***********************************************

	add_scene( "intro_explosion_aftermath", "align_door_shove" );
	add_player_anim( "player_body",	%player::p_karma_7_explosion_aftermath_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 1, 80, 80, 30, 15, SCENE_USE_TAG_ANGLES);
	add_actor_anim( "harper",		%ch_karma_7_explosion_aftermath_harper, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, false);
	add_actor_anim( "salazar",		%ch_karma_7_explosion_aftermath_salazar, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, false );
	add_actor_anim( "han",			%ch_karma_7_explosion_aftermath_guard, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
	add_prop_anim( "armory_door_right", %animated_props::o_karma_7_explosion_aftermath_armorydoor, undefined, !SCENE_DELETE);
	add_prop_anim( "intro_double_door_left", %animated_props::o_karma_7_explosion_aftermath_doubledoor_left, undefined, !SCENE_DELETE);


	//***********************************************
	// Two civilians walk to window - In Titanic Area
	//***********************************************

	add_scene( "scene_e7_couple_run_to_titanic_area", "boat_escape" );
	add_actor_model_anim( "e7_couple_run_to_titanic_area_1", %ch_karma_7_2_civs_watch_escape_08a, undefined, undefined, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "e7_couple_run_to_titanic_area_2", %ch_karma_7_2_civs_watch_escape_08b, undefined, undefined, undefined, undefined, "mall_male_rich1"  );
	
	add_scene( "scene_e7_couple_run_to_titanic_area_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_couple_run_to_titanic_area_1", %ch_karma_7_2_civs_watch_escape_08a_idle, undefined, true, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "e7_couple_run_to_titanic_area_2", %ch_karma_7_2_civs_watch_escape_08b_idle, undefined, true, undefined, undefined, "mall_male_rich1" );


	//**********************************************
	// CoupleA running from the mall to titanic area
	//**********************************************

	add_scene( "scene_e7_couple_a_run_from_mall_to_titanic", "boat_escape" );
	add_actor_model_anim( "e7_couple_a1_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_10a, undefined, undefined, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "e7_couple_a2_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_10b, undefined, undefined, undefined, undefined, "mall_male_rich2"  );
	
	add_scene( "scene_e7_couple_a_run_from_mall_to_titanic_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_couple_a1_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_10a_idle, undefined, true, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "e7_couple_a2_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_10b_idle, undefined, true, undefined, undefined, "mall_male_rich2" );


	//**********************************************
	// CoupleB running from the mall to titanic area
	//**********************************************

	add_scene( "scene_e7_couple_b_run_from_mall_to_titanic", "boat_escape" );
	add_actor_model_anim( "e7_couple_b1_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_11a, undefined, undefined, undefined, undefined, "mall_female_pants" );
	add_actor_model_anim( "e7_couple_b2_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_11b, undefined, undefined, undefined, undefined, "mall_female_rich1" );
	
	add_scene( "scene_e7_couple_b_run_from_mall_to_titanic_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_couple_b1_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_11a_idle, undefined, true, undefined, undefined, "mall_female_pants");
	add_actor_model_anim( "e7_couple_b2_run_from_mall_to_titaic", %ch_karma_7_2_civs_watch_escape_11b_idle, undefined, true, undefined, undefined, "mall_female_rich1" );


	//*******************************************
	// civs_escape_into_mall - then use pathnodes
	//*******************************************

//	add_scene( "scene_e7_civs_escape_into_mall", "boat_escape" );
//	add_actor_anim( "e7_civs_escape_mall_a", %ch_karma_7_2_civs_watch_escape_09a );
//	add_actor_anim( "e7_civs_escape_mall_b", %ch_karma_7_2_civs_watch_escape_09b );


	//********************
	// Wounded Group1 anim
	//********************

	add_scene( "scene_e7_wounded_group1", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP ); 
	add_actor_model_anim( "e7_wounded_man_1", %ch_karma_7_1_civs_treated_01, undefined, true, undefined, undefined, "mall_male_rich2" );
	add_actor_model_anim( "e7_wounded_woman_1", %ch_karma_7_1_civs_treated_02,  undefined, true, undefined, undefined, "mall_female_rich1" );
	add_actor_model_anim( "e7_wounded_man_2", %ch_karma_7_1_civs_treated_03, undefined, true, undefined, undefined, "mall_male_rich1" );
	add_actor_model_anim( "e7_wounded_woman_2", %ch_karma_7_1_civs_treated_04,  undefined, true, undefined, undefined, "mall_female_rich2" );
	add_actor_model_anim( "e7_wounded_man_3", %ch_karma_7_1_civs_treated_05, undefined, true, undefined, undefined, "mall_male_rich1" );
	add_actor_model_anim( "e7_wounded_woman_3", %ch_karma_7_1_civs_treated_06, undefined, true, undefined, undefined, "mall_female_pants" );
	add_actor_model_anim( "e7_wounded_man_4", %ch_karma_7_1_civs_treated_07, undefined, true, undefined, undefined, "mall_male_rich2" );


	//********************
	// Wounded Group2 anim
	//********************

	add_scene( "scene_e7_wounded_group2", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP ); 
	add_actor_model_anim( "e7_wounded_woman_4", %ch_karma_7_1_civs_treated_08, undefined, true, undefined, undefined, "mall_female_rich1");
	add_actor_model_anim( "e7_wounded_man_5", %ch_karma_7_1_civs_treated_09, undefined, true, undefined, undefined, "mall_male_rich2");
	add_actor_model_anim( "e7_wounded_woman_5", %ch_karma_7_1_civs_treated_10, undefined, true, undefined, undefined, "mall_female_pants" );
	add_actor_model_anim( "e7_wounded_man_6", %ch_karma_7_1_civs_treated_11, undefined, true, undefined, undefined, "mall_male_rich1" );
	add_actor_model_anim( "e7_wounded_woman_6", %ch_karma_7_1_civs_treated_12,  undefined, true, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "e7_wounded_man_7", %ch_karma_7_1_civs_treated_13,  undefined, true, undefined, undefined, "mall_male_rich2");
	add_actor_model_anim( "e7_wounded_woman_7", %ch_karma_7_1_civs_treated_14,  undefined, true, undefined, undefined, "mall_female_pants");
	add_actor_model_anim( "e7_wounded_man_8", %ch_karma_7_1_civs_treated_15,  undefined, true, undefined, undefined, "mall_male_rich2" );


	//***************************************************
	// Doctor and Nurse anim - In Hospital Area - Looping
	//***************************************************

	add_scene( "scene_e7_doctor_and_nurse_loop", "wounded_civs", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_doctor", %ch_karma_7_1_civs_treated_doctor, undefined, true, undefined, undefined, "mall_female_rich1");
	//add_actor_model_anim( "e7_nurse", %ch_karma_7_1_civs_treated_nurse, undefined, SCENE_DELETE );


	//*****************************************************************
	// Four civilians already at the window - In Titanic Area - Looping
	//*****************************************************************
	
//	add_scene( "scene_e7_civs_at_window_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
//	add_actor_model_anim( "e7_civ4_window_loop_1", %ch_karma_7_2_civs_watch_escape_01, undefined, SCENE_DELETE );
//	add_actor_model_anim( "e7_civ4_window_loop_2", %ch_karma_7_2_civs_watch_escape_02, undefined, SCENE_DELETE );
//	add_actor_model_anim( "e7_civ4_window_loop_3", %ch_karma_7_2_civs_watch_escape_03, undefined, SCENE_DELETE );
//	add_actor_model_anim( "e7_civ4_window_loop_4", %ch_karma_7_2_civs_watch_escape_04, undefined, SCENE_DELETE );


	//***********************************************
	// Two civilians walk to window - In Titanic Area
	//***********************************************

	add_scene( "scene_e7_couple_approach_window_part1", "boat_escape" );
	add_actor_model_anim( "e7_civ1_watch_escape", %ch_karma_7_2_civs_watch_escape_05, undefined, undefined, undefined, undefined, "mall_female_pants" );
	add_actor_model_anim( "e7_civ2_watch_escape", %ch_karma_7_2_civs_watch_escape_06, undefined, undefined, undefined, undefined, "mall_male_rich1");
	
	add_scene( "scene_e7_couple_approach_window_part2_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_civ1_watch_escape", %ch_karma_7_2_civs_watch_escape_05_idle, undefined, true, undefined, undefined, "mall_female_pants");
	add_actor_model_anim( "e7_civ2_watch_escape", %ch_karma_7_2_civs_watch_escape_06_idle, undefined, true, undefined, undefined, "mall_male_rich1" );


	//***********************************************
	// Single guy approaches window - In Titanic Area
	//***********************************************

	add_scene( "scene_e7_single_approach_window_part1", "boat_escape" );
	add_actor_model_anim( "e7_civ_approach_window", %ch_karma_7_2_civs_watch_escape_07, undefined, undefined, undefined, undefined, "mall_female_dress" );

	add_scene( "scene_e7_single_approach_window_part2_loop", "boat_escape", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "e7_civ_approach_window", %ch_karma_7_2_civs_watch_escape_07_idle,  undefined, true, undefined, undefined, "mall_female_dress" );


	//***********************************************
	//
	//***********************************************

//	add_scene( "scene_e7_wounded_civs_exit_club", "wounded_civs" );
//	add_actor_anim( "stair_rush_girl_a", %ch_karma_7_1_civs_exiting_01 );
//	add_actor_anim( "stair_rush_guy1_a", %ch_karma_7_1_civs_exiting_02 );
			

	//***********************************************
	// Titanic Moment Animations
	//***********************************************

	add_scene( "scene_e7_titanic_moment_docka_loop", "titanic_moment", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "evac_docka_civ01", %ch_karma_7_1_evac_docka_civ01, undefined, true, undefined, undefined, "mall_male_rich1" );
	add_actor_model_anim( "evac_docka_civ02", %ch_karma_7_1_evac_docka_civ02, undefined, true, undefined, undefined, "mall_male_rich2" );
	add_actor_model_anim( "evac_docka_civ03", %ch_karma_7_1_evac_docka_civ03, undefined, true, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "evac_docka_civ04", %ch_karma_7_1_evac_docka_civ04, undefined, true, undefined, undefined, "mall_female_rich1" );
	add_actor_model_anim( "evac_docka_civ05", %ch_karma_7_1_evac_docka_civ05, undefined, true, undefined, undefined, "mall_female_dress" );
	add_actor_model_anim( "evac_docka_civ06", %ch_karma_7_1_evac_docka_civ06, undefined, true, undefined, undefined, "mall_male_rich2" );
	add_actor_model_anim( "evac_docka_civ07", %ch_karma_7_1_evac_docka_civ07, undefined, true, undefined, undefined, "mall_female_rich2" );
	add_actor_model_anim( "evac_docka_civ08", %ch_karma_7_1_evac_docka_civ08, undefined, true, undefined, undefined, "mall_male_rich2" );
	add_actor_model_anim( "evac_docka_civ09", %ch_karma_7_1_evac_docka_civ09, undefined, true, undefined, undefined, "mall_female_pants" );
	add_actor_model_anim( "evac_docka_securityguard", %ch_karma_7_1_evac_docka_securityguard, undefined, SCENE_DELETE, undefined, undefined, "han" );

	add_scene( "scene_e7_titanic_moment_dockb_loop", "titanic_moment", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "evac_dockb_civ01", %ch_karma_7_1_civ_evac_dockb_civ_01, undefined, true, undefined, undefined, "mall_male_rich1" );
	add_actor_model_anim( "evac_dockb_civ02", %ch_karma_7_1_civ_evac_dockb_civ_02, undefined, true, undefined, undefined, "mall_male_rich2");
	add_actor_model_anim( "evac_dockb_civ03", %ch_karma_7_1_civ_evac_dockb_civ_03, undefined, true, undefined, undefined, "mall_female_dress");
	add_actor_model_anim( "evac_dockb_civ04", %ch_karma_7_1_civ_evac_dockb_civ_04, undefined, true, undefined, undefined, "mall_female_pants");
	add_actor_model_anim( "evac_dockb_civ05", %ch_karma_7_1_civ_evac_dockb_civ_05, undefined, true, undefined, undefined, "mall_male_rich1");
	add_actor_model_anim( "evac_dockb_civ06", %ch_karma_7_1_civ_evac_dockb_civ_06, undefined, true, undefined, undefined, "mall_female_rich2" );
	add_actor_model_anim( "evac_dockb_securityguard1", %ch_karma_7_1_civ_evac_dockb_securityguard, undefined, SCENE_DELETE, undefined, undefined, "han" );


	//*****************************************************
	// Defalco drags karma (with security) through the mall
	//*****************************************************

	add_scene( "scene_event8_defalco_karma_intro", "mall_first_pip" );
	add_actor_anim( "defalco",			%ch_karma_7_pip_security_feed_defalco, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "karma", 			%ch_karma_7_pip_security_feed_karma, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "defalco_escort", 	%ch_karma_7_pip_security_feed_pmc01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	//add_actor_anim( "e8_solder2_start_anim", %ch_karma_8_1_karma_dragged_bodyguard2, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "deathpose1", "deadguy1" );
	add_actor_model_anim( "deadguy1", %generic_human::ch_gen_m_floor_armdown_legspread_onback_deathpose, undefined, false, undefined, undefined, "rich_male_1" );
	
	add_scene( "deathpose2", "deadguy2" );
	add_actor_model_anim( "deadguy2", %generic_human::ch_gen_f_floor_onfront_armdown_legstraight_deathpose, undefined, false, undefined, undefined, "mall_female_dress" );
	
	add_scene( "deathpose3", "deadguy3" );
	add_actor_model_anim( "deadguy3", %generic_human::ch_gen_m_floor_armstomach_onrightside_deathpose, undefined, false, undefined, undefined, "rich_male_2" );
	
	add_scene( "deathpose4", "deadguy4" );
	add_actor_model_anim( "deadguy4", %generic_human:: ch_gen_f_wall_leanleft_armstomach_legstraight_deathpose, undefined, false, undefined, undefined, "mall_female_rich2" );
	
	add_scene( "deathpose5", "deadguy5" );
	add_actor_model_anim( "deadguy5", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "rich_female_4" );
	
	add_scene( "deathpose6", "deadguy6" );
	add_actor_model_anim( "deadguy6", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "rich_female_5" );
	
	add_scene( "deathpose7", "deadguy7" );
	add_actor_model_anim( "deadguy7", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "mall_female_dress" );
	
	add_scene( "deathpose8", "deadguy8" );
	add_actor_model_anim( "deadguy8", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "rich_female_2" );
	
	add_scene( "deathpose9", "deadguy9" );
	add_actor_model_anim( "deadguy9", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "rich_female_1" );
	
	add_scene( "deathpose10", "deadguy10" );
	add_actor_model_anim( "deadguy10", %generic_human::ch_gen_m_floor_armdown_onfront_deathpose, undefined, false, undefined, undefined, "rich_male_2" );
	
	add_scene( "deathpose11", "deadguy11" );
	add_actor_model_anim( "deadguy11", %generic_human::ch_gen_m_floor_armover_onrightside_deathpose, undefined, false, undefined, undefined, "rich_male_3" );
	
	
	precache_assets( true );
}

	
//*****************************************************************************
//*****************************************************************************
	
#using_animtree( "generic_human" );
mall_precache_anims()
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
	
	add_scene( "terrorist_rappel_left1", "bridge_rappel1", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left1",	%generic_human::ai_rappel_02 );
	add_prop_anim( "terrorist_rappel_rope_left1", %animated_props::o_ai_rappel_rope02, "iw_prague_rope_rappel_building" );
	
	add_scene( "terrorist_rappel_left2", "bridge_rappel2", SCENE_REACH );
	add_actor_anim( "terrorist_rappel_left2",	%generic_human::ai_rappel_02 );
	add_prop_anim( "terrorist_rappel_rope_left4", %animated_props::o_ai_rappel_rope02, "iw_prague_rope_rappel_building" );
}


mall_anims()
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


	//*************************************************
	// Defalco drag 2 - on bridge in swimming pool area
	//*************************************************

	add_scene( "scene_event9_defalco_karma_bridge", "anim_align_pip2" );
	add_actor_anim( "defalco", 			%ch_karma_8_pip_exiting_the_mall_defalco, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "karma",			%ch_karma_8_pip_exiting_the_mall_karma, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE  );
	add_actor_anim( "defalco_escort",	%ch_karma_8_pip_exiting_the_mall_pmc01,!SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE  );
	//add_actor_model_anim( "e8_solder2_start_anim", %ch_karma_8_1_karma_dragged_guard02_b, 	undefined, SCENE_DELETE );


	//***************************
	// End of Event 8 Door Breach
	//***************************

	add_scene( "scene_event8_door_breach", "gate_lift" );
	add_player_anim( "player_body",		%player::p_karma_9_1_gate_lift, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA );
	add_notetrack_flag("player_body", "start_gatepull", "start_gatepull");
	add_prop_anim( "security_gate", 	%animated_props::o_karma_9_1_gate_lift, undefined, !SCENE_DELETE );
	//add_actor_model_anim( "e7_doctor", %ch_karma_9_1_gate_lift_civ_01, undefined, SCENE_DELETE );

	add_scene( "scene_event8_door_breach_harper", "gate_lift" );
	add_actor_anim( "harper",		 	%ch_karma_9_1_gate_lift_harper, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON  );
	
	add_scene( "scene_event8_door_breach_salazar", "gate_lift", SCENE_REACH );
	add_actor_anim( "salazar", 			%ch_karma_9_1_gate_lift_salazar_intro, SCENE_HIDE_WEAPON);
	
	add_scene( "scene_event8_door_breach_salazar_idle", "gate_lift", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar", 			%ch_karma_9_1_gate_lift_salazar_idle, SCENE_HIDE_WEAPON );
	
	add_scene( "scene_event8_door_breach_salazar_end", "gate_lift" );
	add_actor_anim( "salazar",			%ch_karma_9_1_gate_lift_salazar, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "scene_event8_civ_escape1", "gate_lift" );
	add_actor_anim( "stair_rush_girl_a", %ch_karma_9_1_gate_lift_civ_01);
	
	add_scene( "scene_event8_civ_escape2", "gate_lift" );
	add_actor_anim( "stair_rush_guy1_a", %ch_karma_9_1_gate_lift_civ_02);
	
	add_scene( "scene_event8_civ_escape3", "gate_lift" );
	add_actor_anim( "stair_rush_girl_b", %ch_karma_9_1_gate_lift_civ_03);
	
	add_scene( "scene_event8_civ_escape4", "gate_lift" );
	add_actor_anim( "stair_rush_guy1_b", %ch_karma_9_1_gate_lift_civ_04);
	
	add_scene( "scene_event8_civ_escape5", "gate_lift" );
	add_actor_anim( "stair_rush_girl_extra1", %ch_karma_9_1_gate_lift_civ_05);
	
	add_scene( "scene_event8_civ_escape6", "gate_lift" );
	add_actor_anim( "stair_rush_guy2_a", %ch_karma_9_1_gate_lift_civ_06);
	
	add_scene( "scene_event8_civ_escape7", "gate_lift" );
	add_actor_anim( "stair_rush_guy_extra1", %ch_karma_9_1_gate_lift_civ_07);
	
	add_scene( "scene_event8_civ_escape8", "gate_lift" );
	add_actor_anim( "stair_rush_guy2_b", %ch_karma_9_1_gate_lift_civ_08);
	
	add_scene( "scene_event8_civ_escape9", "gate_lift" );
	add_actor_anim( "stair_rush_guy3_b", %ch_karma_9_1_gate_lift_civ_09);

	//*************************************************
	// E8 Wounded Civs Groupa
	//*************************************************

	add_scene( "scene_e8_wounded_civ_1", "e8_wounded_civ_groupa_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_1", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_2", "e8_wounded_civ_groupa_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_2", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_3", "e8_wounded_civ_groupa_3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_3", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_4", "e8_wounded_civ_groupa_4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_4", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_5", "e8_wounded_civ_groupa_5", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_5", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );


	//*************************************************
	// E8 Wounded Civs Groupb
	//*************************************************

	add_scene( "scene_e8_wounded_civ_b1", "e8_wounded_civ_groupb_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_6", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_b2", "e8_wounded_civ_groupb_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_7", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_b3", "e8_wounded_civ_groupb_3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_8", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_b4", "e8_wounded_civ_groupb_4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_9", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_b5", "e8_wounded_civ_groupb_5", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_10", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_b6", "e8_wounded_civ_groupb_6", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_11", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );


	//*************************************************
	// E8 Wounded Civs Groupc
	//*************************************************

	add_scene( "scene_e8_wounded_civ_c1", "e8_wounded_civ_groupc_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_1", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_c2", "e8_wounded_civ_groupc_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_2", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_c3", "e8_wounded_civ_groupc_3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_3", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e8_wounded_civ_c4", "e8_wounded_civ_groupc_4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_4", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************
sundeck_precache_anims()
{
	// temp for testing
	//**************************
	//	Defalco and Karma at helipad
	//**************************
	add_scene( "defalco_karma_helipad", "new_ending" );
	add_actor_model_anim( "defalco",	%ch_karma_9_pip_evac_deck_defalco,	undefined, SCENE_DELETE );
	add_actor_model_anim( "karma",		%ch_karma_9_pip_evac_deck_karma,	undefined, SCENE_DELETE );
	add_actor_model_anim( "pmc01",		%ch_karma_9_pip_evac_deck_pmc01,	undefined, SCENE_DELETE, undefined, undefined, "scene_pmc" );
}

sundeck_anims()
{
	//**********************************************************************
	// Injured civilian animations - Running past player fire fight at start
	//**********************************************************************

	add_scene( "sundeck_civ_injured_and_helper", "event9_civ_ambient" );
	add_actor_anim( "civ_female_rich", 	%ch_karma_9_1_civcouple_helper );
	add_actor_anim( "civ_male_rich", 	%ch_karma_9_1_civcouple_injured );
	
	add_scene( "sundeck_civ_injured_and_helper_idle", "event9_civ_ambient", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_female_rich",	%ch_karma_9_1_civcouple_helper_idle,	undefined, SCENE_DELETE );
	add_actor_model_anim( "civ_male_rich", 		%ch_karma_9_1_civcouple_injured_idle,	undefined, SCENE_DELETE );


	//**********************************************************************
	// Rocks execution Animation
	//**********************************************************************

	add_scene( "sundeck_rocks_execution", "event9_civ_ambient" );
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

//	add_scene( "scene_e9_balcony_blowup_ledge_fall", "event9_corner_bldg" );
//	add_actor_model_anim( "civ_left_balcony_blowup_male_1", %ch_karma_9_2_helicopter_balcony_a_guard01, undefined );
//	add_actor_model_anim( "civ_left_balcony_blowup_female_1", %ch_karma_9_2_helicopter_balcony_a_guard02, undefined );

	add_scene( "scene_e9_balcony_blowup_stairs_stumble", "event9_corner_bldg" );
	add_actor_anim( "civ_left_balcony_blowup_stairs_stumble_1", %ch_karma_9_2_helicopter_balcony_b_guard01, undefined, undefined, undefined, undefined, undefined, "sp_enemy_shotgun" );
	add_actor_anim( "civ_left_balcony_blowup_stairs_stumble_2", %ch_karma_9_2_helicopter_balcony_b_guard02, undefined, undefined, undefined, undefined, undefined, "sp_enemy_assault" );

	//**************************
	// Jumpdown attack
	//**************************
	add_scene( "sundeck_jump_attack_intro", "generic_align" );
	add_player_anim( "player_body", 			%player::p_karma_9_2_enemy_pounce_player, 	!SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "jump_attack_pmc",			%ch_karma_9_2_enemy_pounce_pmc,	undefined,	undefined,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH, undefined,	"sp_enemy_pistol" );
	add_actor_model_anim( "jump_attack_body",	%ch_karma_9_2_enemy_pounce_deadbody_drop, undefined, !SCENE_DELETE, undefined, undefined, 				"security_guard" );

	add_scene( "sundeck_jump_attack_failure", "generic_align" );
	add_player_anim( "player_body", 			%player::p_karma_9_2_enemy_pounce_player_failure, 	!SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "jump_attack_pmc",			%ch_karma_9_2_enemy_pounce_pmc_failure,	undefined,	undefined,	!SCENE_DELETE,	!SCENE_ALLOW_DEATH, undefined,	"sp_enemy_pistol" );
	add_actor_model_anim( "jump_attack_body",	%ch_karma_9_2_enemy_pounce_deadbody_failure, undefined, !SCENE_DELETE, undefined, undefined, 				"security_guard" );

	add_scene( "sundeck_jump_attack_success", "generic_align" );
	add_player_anim( "player_body", 			%player::p_karma_9_2_enemy_pounce_player_success, 	SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "jump_attack_pmc",			%ch_karma_9_2_enemy_pounce_pmc_success,	undefined,	undefined,	!SCENE_DELETE,	SCENE_ALLOW_DEATH, undefined,	"sp_enemy_pistol" );
	add_actor_model_anim( "jump_attack_body",	%ch_karma_9_2_enemy_pounce_deadbody_success, undefined, !SCENE_DELETE, undefined, undefined, 				"security_guard" );

	//*************************************************
	// Defalco drag 3 - on bridge in swimming pool area
	//*************************************************

	add_scene( "sundeck_defalco_karma_end_stairs", "e9_defalco_stairs" );
	add_actor_model_anim( "defalco", %ch_karma_8_1_karma_dragged_defa_c, undefined, SCENE_DELETE );
	add_actor_model_anim( "karma", %ch_karma_8_1_karma_dragged_karma_c, undefined, SCENE_DELETE );
	add_actor_model_anim( "e8_solder1_start_anim", %ch_karma_8_1_karma_dragged_guard01_c, undefined, SCENE_DELETE );
	add_actor_model_anim( "e8_solder2_start_anim", %ch_karma_8_1_karma_dragged_guard02_c, undefined, SCENE_DELETE );

	
	//*************************************************
	// E9 Wounded Civs Groupa
	//*************************************************

	add_scene( "scene_e9_wounded_civ_1", "e9_wounded_civ_groupa_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_1", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_2", "e9_wounded_civ_groupa_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_2", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_3", "e9_wounded_civ_groupa_3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_3", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_4", "e9_wounded_civ_groupa_4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_4", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );


	//*************************************************
	// E9 Wounded Civs Groupb
	//*************************************************

	add_scene( "scene_e9_wounded_civ_b1", "e9_wounded_civ_groupb_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_1", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_b2", "e9_wounded_civ_groupb_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_2", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_b3", "e9_wounded_civ_groupb_3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_3", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_b4", "e9_wounded_civ_groupb_4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_4", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_b5", "e9_wounded_civ_groupb_5", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_5", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_b6", "e9_wounded_civ_groupb_6", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_6", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );


	//*************************************************
	// E9 Wounded Civs Groupc
	//*************************************************

	add_scene( "scene_e9_wounded_civ_c1", "e9_wounded_civ_groupc_1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_1", %ch_karma_9_1_woundedciv_a, undefined, SCENE_DELETE );

	add_scene( "scene_e9_wounded_civ_c2", "e9_wounded_civ_groupc_2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "civ_wounded_2", %ch_karma_9_1_woundedciv_c, undefined, SCENE_DELETE );

	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************
the_end_precache_anims()
{
	add_scene( "ending_shoot_karma", "new_ending", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "defalco",				%ch_karma_10_1_waitingforplayershot_defa, !SCENE_HIDE_WEAPON );
	add_actor_anim( "defalco_escort_left",	%ch_karma_10_1_waitingforplayershot_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "defalco_escort_right",	%ch_karma_10_1_waitingforplayershot_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "karma",				%ch_karma_10_1_waitingforplayershot_karma, SCENE_HIDE_WEAPON  );
	add_prop_anim( "karma_organ",			%animated_props::ch_karma_10_1_waitingforplayershot_karma, "c_usa_chloe_lynch_organs_fb", true);
	add_prop_anim( "karma_hitbox",			%animated_props::ch_karma_10_1_waitingforplayershot_karma, "c_usa_chloe_lynch_organs_hit_fb", true);
}

the_end_anims()
{
	//***************
	// Event10 Dialog
	//***************
	add_dialog( "caution_mason_defaloc", "Mason don't let Defalco escape with Karma" );
	add_dialog( "mason_stay_back", "Mason, stay back or i'll blow up the Ship" );

	//***************
	// Setup Event 10
	//***************
	player_hdg = 45;			// 60
	player_pitch_up = 30;		// 75
	player_pitch_down = 30;		// 45
	
	//******************************************
	// STANDOFF SETUP FOR PLAYER - get in perfect position for shot
	//******************************************
	add_scene( "escape_start_squad", "new_ending" );
	add_actor_anim( "salazar", %ch_karma_10_1_intro_salazar );
	add_actor_anim( "harper", %ch_karma_10_1_intro_harper );
	
	// player has smaller frame range than squad, so he has his own scene
	add_scene( "escape_start_player", "new_ending" );
	add_prop_anim( "ending_weapon", %animated_props::o_karma_10_1_intro_ballista, "t6_wpn_sniper_ballista_prop_view", SCENE_DELETE );	
	add_player_anim( "player_body", %player::p_karma_10_1_intro_player, SCENE_DELETE );
	
	add_notetrack_custom_function( "ending_weapon", undefined, maps\karma_the_end::_detach_ballista_model, false );
	add_notetrack_custom_function( "player_body", undefined, ::vo_escape_start_player, false );

	//******************************************
	// STANDOFF SETUP - Defalco walks towards the VTOL
	//******************************************
	
	add_scene( "escape_start", "new_ending" );
	add_actor_anim( "defalco", 				%ch_karma_10_1_intro_defa,	!SCENE_HIDE_WEAPON );
	add_actor_anim( "defalco_escort_left",	%ch_karma_10_1_intro_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
	add_actor_anim( "defalco_escort_right",	%ch_karma_10_1_intro_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE);
	add_actor_anim( "karma",				%ch_karma_10_1_intro_karma, SCENE_HIDE_WEAPON );
	add_prop_anim( "karma_organ",			%animated_props::ch_karma_10_1_intro_karma, "c_usa_chloe_lynch_organs_fb", !SCENE_DELETE );
	add_prop_anim( "karma_hitbox",			%animated_props::ch_karma_10_1_intro_karma, "c_usa_chloe_lynch_organs_hit_fb", !SCENE_DELETE );	
	
	add_notetrack_custom_function( "defalco", undefined, maps\karma_the_end::_create_streamer_hint_on_ent, false );
		
	//***************************************************************************************************
	// GUARD DEATH ANIMS - originally set up for Karma death scenario, so uses its frame range. These
	//				are set up as their own scene everywhere else to make sure _scene doesn't return early
	//***************************************************************************************************
	add_scene( "escape_guard_deaths", "new_ending" );
	add_actor_anim( "defalco_escort_left", %ch_karma_10_1_hitfatal_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "defalco_escort_right", %ch_karma_10_1_hitfatal_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );	
	add_notetrack_custom_function( "defalco_escort_left", "get_shot", maps\karma_the_end::_pmc1_shot_by_salazar, true );
	add_notetrack_custom_function( "defalco_escort_right", "get_shot", maps\karma_the_end::_pmc2_shot_by_harper, true );

	//***************************************************************
	// Karma wounded; leaves on VTOL with Defalco
	// squad on different frame ranges - using 'ending_squad_arrives_late' scene
	//***************************************************************
	add_scene( "ending_karma_wounded", "new_ending" );
	add_actor_anim( "karma", %ch_karma_10_1_hitwounded_karma, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	

	//***************************************************************
	// SUCCESS - Karma disabled
	//***************************************************************
	
	add_scene( "ending_success", "new_ending" );
	add_actor_anim( "harper", %ch_karma_10_1_hitsuccess_harper );
	add_actor_anim( "karma", %ch_karma_10_1_hitsuccess_karma );
	add_actor_anim( "salazar", %ch_karma_10_1_hitfatal_salazar );

	add_notetrack_flag( "defalco", "in_boat", "e10_close_vtol_door");
	add_notetrack_flag( "defalco", "fire", "e10_defalco_fires");	// flag used by sound


	//***************************************************************
	// Karma Killed
	//***************************************************************

	add_scene( "ending_karma_killed", "new_ending", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP );
	add_actor_anim( "harper", %ch_karma_10_1_hitfatal_harper );
	add_actor_anim( "karma", %ch_karma_10_1_hitfatal_karma );
	add_actor_anim( "salazar", %ch_karma_10_1_hitfatal_salazar );
	add_actor_anim( "defalco_escort_left", %ch_karma_10_1_hitfatal_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "defalco_escort_right", %ch_karma_10_1_hitfatal_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_notetrack_custom_function( "defalco", "door_close", maps\karma_the_end::_defalco_vtol_close_bay, true );

	
	//***************************************************************
	// FAILURE - Delfalco Killed
	//***************************************************************

	add_scene( "ending_defalco_killed", "new_ending", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP);
	add_actor_anim( "defalco", %ch_karma_10_1_defalcoshot_defalco, !SCENE_HIDE_WEAPON  );
	add_actor_anim( "karma", %ch_karma_10_1_defalcoshot_karma, SCENE_HIDE_WEAPON  );	
	add_actor_anim( "harper", %ch_karma_10_1_defalcoshot_harper );
	add_actor_anim( "salazar", %ch_karma_10_1_defalcoshot_salazar );
	add_actor_anim( "defalco_escort_left", %ch_karma_10_1_hitfatal_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "defalco_escort_right", %ch_karma_10_1_hitfatal_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	
	add_notetrack_custom_function( "defalco", "detonate", maps\karma_the_end::_defalco_detonates_all_explosives, true );


	//***************************************************************
	// Defalco Shot
	//***************************************************************

	add_scene( "ending_defalco_wounded", "new_ending" );
	add_actor_anim( "defalco_escort_left", %ch_karma_10_1_hitfatal_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "defalco_escort_right", %ch_karma_10_1_hitfatal_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "harper", %ch_karma_10_1_hitfatal_harper );
	add_actor_anim( "karma", %ch_karma_10_1_hitwounded_karma, SCENE_HIDE_WEAPON  );
	add_actor_anim( "salazar", %ch_karma_10_1_hitfatal_salazar );	

	//***************************************************************
	// Timeout (Failure to Shoot)
	//***************************************************************

	add_scene( "ending_timeout_defalco", "new_ending" );
	add_actor_anim( "defalco", %generic_human::ch_karma_10_1_timeout_defa, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "ending_timeout_karma", "new_ending" );
	add_actor_anim( "karma", %ch_karma_10_1_timeout_karma, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "ending_timeout_guards", "new_ending" );
	add_actor_anim( "defalco_escort_left", %generic_human::ch_karma_10_1_timeout_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_anim( "defalco_escort_right", %ch_karma_10_1_timeout_pmc02, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_notetrack_custom_function( "defalco_escort_left", "door_close", maps\karma_the_end::_defalco_vtol_close_bay, true );
	
	// squad on different frame ranges
	add_scene( "ending_squad_arrives_late", "new_ending" );
	add_actor_anim( "salazar", %ch_karma_10_1_timeout_salazar );	
	add_actor_anim( "harper", %ch_karma_10_1_timeout_harper );	
	
	// special scene for karma wounded scenario
	add_scene( "ending_harper_arrives_late", "new_ending" );
	add_actor_anim( "harper", %ch_karma_10_1_timeout_harper );		
	
	//**************************************************************
	// Shot missed
	//**************************************************************

	
	// Defalco shoots Salazar -> idles in VTOL
	add_scene( "ending_defalco_shoots_salazar", "new_ending" );
	add_actor_anim( "defalco", %ch_karma_10_1_hitfatal_defa, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "ending_salazar_gets_shot", "new_ending" );
	add_actor_anim( "salazar", %ch_karma_10_1_hitfatal_salazar, !SCENE_HIDE_WEAPON );
	
	// VTOL anims
	level.scr_anim[ "defalco_osprey" ][ "vtol_cargo_bay_closes" ] = %vehicles::v_karma_10_1_vtol_doors;
	level.scr_anim[ "defalco_osprey" ][ "vtol_landing_gear_retracts" ] = %vehicles::v_karma_10_1_vtol_wheels;
	
	// VTOL idles
	add_scene( "ending_vtol_idle_timeout_defalco_and_karma", "defalco_osprey", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "defalco", %generic_human::ch_karma_10_1_invtol_defalco, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_guy4" );
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_invtol_karma, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_guy1" );
	
	add_scene( "ending_vtol_idle_timeout_guards", "defalco_osprey", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );	
	add_actor_anim( "defalco_escort_left", %generic_human::ch_karma_10_1_invtol_pmc01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_guy2" );
	add_actor_anim( "defalco_escort_right", %generic_human::ch_karma_10_1_invtol_pmc02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_guy3" );	
	
	add_scene( "ending_vtol_idle_defalco", "defalco_osprey", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );	
	add_actor_anim( "defalco", %generic_human::ch_karma_10_1_invtol_defalco2, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_guy4" );

	add_scene( "ending_vtol_idle_karma", "defalco_osprey", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );	
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_invtol_karma2, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH, "tag_cargo_hatch_low" );
	
	// player reaction 
	add_scene( "player_shot_reaction", "new_ending" );
	add_player_anim( "player_body", %player::p_karma_10_1_player_runtoend, SCENE_DELETE );
	add_notetrack_custom_function( "player_body", undefined, maps\karma_the_end::_attach_ballista_model, false );
	
	//*****************************************************************
	// END SCENES
	//*****************************************************************
	add_scene( "player_ending_success", "new_ending" );
	add_player_anim( "player_body", %player::p_karma_10_1_player_hitsuccess_finale, SCENE_DELETE );
	
	add_notetrack_custom_function( "player_body", undefined, maps\karma_the_end::vo_salazar_shot_karma_success, false );
	add_notetrack_custom_function( "player_body", undefined, maps\karma_the_end::vo_ending_karma_success, false );

	
	add_scene( "ending_salazar_idle", "new_ending", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );	
	add_actor_anim( "salazar", %generic_human::ch_karma_10_1_hitfatal_salazar_vtol_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );	
	
	add_scene( "ending_success_idle", "new_ending", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper", %generic_human::ch_karma_10_1_hitsuccess_harper_vtol_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_hitsuccess_karma_vtol_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );

	add_scene( "ending_success_aftermath", "new_ending" );
	add_actor_anim( "harper", %generic_human::ch_karma_10_1_hitsuccess_harper_vtol_aftermath, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_hitsuccess_karma_vtol_aftermath, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "plane_vtol", %vehicles::v_karma_10_1_vtol_endcameravtol );
	
	
	
	add_scene( "player_ending_karma_dead", "new_ending" );
	add_player_anim( "player_body", %player::p_karma_10_1_player_hitfatal_finale, SCENE_DELETE );
	
	add_notetrack_custom_function( "player_body", "play_end_anim", maps\karma_the_end::_play_final_player_anim, false );
	add_notetrack_custom_function( "player_body", undefined, maps\karma_the_end::vo_salazar_shot_karma_dead, false );
	add_notetrack_custom_function( "player_body", undefined, maps\karma_the_end::vo_ending_karma_dead, false );

	
	add_scene( "ending_failure_idle", "new_ending", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper", %generic_human::ch_karma_10_1_hitfatal_harper_vtol_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_hitfatal_karma_vtol_idle, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	
	add_scene( "ending_failure_aftermath", "new_ending" );
	add_actor_anim( "harper", %generic_human::ch_karma_10_1_hitfatal_harper_vtol_aftermath, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_anim( "karma", %generic_human::ch_karma_10_1_hitfatal_karma_vtol_aftermath, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_vehicle_anim( "plane_vtol", %vehicles::v_karma_10_1_vtol_endcameravtol_v2 );
	
	precache_assets( true );
}


//*****************************************************************************
//*****************************************************************************

vo_escape_start_player()
{
	e_farid = level.player;
	e_harper = get_ent( "harper_ai", "targetname", true );
	e_player = level.player;
	
	e_farid say_dialog( "fari_whatever_attack_cord_0" );  // Whatever attack Cordis Die is planning, she is part of it. You CANNOT let them take her.
	
	e_harper say_dialog( "harp_he_s_right_section_0" );  // He's right, Section. We need to take her down.
	
	e_player say_dialog( "sect_you_take_the_guards_0", 0.5 );  // You take the guards. I'll take the girl.
	
	e_harper say_dialog( "harp_just_try_not_to_kill_0", 0.5 );  // Try not to kill her
}