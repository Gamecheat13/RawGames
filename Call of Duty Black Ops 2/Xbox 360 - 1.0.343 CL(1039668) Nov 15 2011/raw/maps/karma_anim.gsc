
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
//	add_scene(	str_scene_name, str_align_targetname, SCENE_REACH, SCENE_GENERIC, SCENE_LOOP, SCENE_ALIGN );
//	add_actor_anim(		str_animname, animation, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG );
//	add_player_anim(	str_animname, animation, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, n_view_fraction, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc, use_tag_angles, b_auto_center );
//	add_prop_anim(		str_animname, animation, str_model, SCENE_DELETE, SCENE_SIMPLE_PROP, a_parts, SCENE_NO_TAG );
//	add_vehicle_anim(	str_animname, animation, SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, SCENE_ANIMATE_ORIGIN, str_vehicletype, str_model, str_destructibledef );

	perk_anims(); // uses Digital Devices - specialty_trespasser
	civilian_anims();
	
	checkin_precache_anims();
	lobby_precache_anims();
	spiderbot_precache_anims();	// 
	construction_precache_anims();  // Event 5 Animations from Hotel Room - Elevator 3 to Club Solar.
	club_precache_anims();
	event_07_precache_anims();
	event_08_precache_anims();
	event_09_precache_anims();
	event_10_precache_anims();

//	checkin_anims();
//	lobby_anims();	// Enter tower elevator and get to your hotel room.
//	spiderbot_anims();	// 
//	construction_anims();  // Event 5 Animations from Hotel Room - Elevator 3 to Club Solar.
//	club_anims();
//	event_07_anims();
//	event_08_anims();
//	event_09_anims();
//	event_10_anims();

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
//	level.scr_anim[ "generic" ][ "civ_walk" ][0]			= %ch_karma_3_4_civwalk_01;
//	level.scr_anim[ "generic" ][ "civ_walk" ][1]			= %ch_karma_3_4_civwalk_02;
//	level.scr_anim[ "generic" ][ "civ_walk" ][2]			= %ch_karma_3_4_civwalk_03;
	level.scr_anim[ "generic" ][ "civ_walk" ][0]			= %ai_civ_m_walk_00;
	level.scr_anim[ "generic" ][ "civ_walk" ]				= %ai_civ_m_walk_00;
	
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
//    level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ch_karma_3_4_cividle_01;
//	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %ch_karma_3_4_cividle_02;
//	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %ch_karma_3_4_cividle_03;
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ai_civ_m_idle_stand_00;
	
	
	level.scr_anim[ "generic" ][ "civ_checkin_idle_1" ][0]			= %ch_karma_3_4_cividle_01;
	level.scr_anim[ "generic" ][ "civ_checkin_idle_2" ][0]			= %ch_karma_3_4_cividle_02;
	
	level.scr_anim[ "generic" ][ "pause" ][0]				= %ch_karma_3_4_cividle_01;
	level.scr_anim[ "generic" ][ "pause" ][1]				= %ch_karma_3_4_cividle_02;
	level.scr_anim[ "generic" ][ "pause" ][2]				= %ch_karma_3_4_cividle_03;
	
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;

	level.scr_anim[ "generic" ][ "girl_dance" ][0]			= %Ch_karma_6_2_dancing_girl_01;
	level.scr_anim[ "generic" ][ "girl_dance" ][1]			= %Ch_karma_6_2_dancing_girl_02;
	level.scr_anim[ "generic" ][ "girl_dance" ][2]			= %Ch_karma_6_2_dancing_girl_03;
	level.scr_anim[ "generic" ][ "girl_dance" ][3]			= %Ch_karma_6_2_dancing_girl_04;
	
	level.scr_anim[ "generic" ][ "guy_dance" ][0]			= %Ch_karma_6_2_dancing_guy_01;
	level.scr_anim[ "generic" ][ "guy_dance" ][1]			= %Ch_karma_6_2_dancing_guy_02;
	level.scr_anim[ "generic" ][ "guy_dance" ][2]			= %Ch_karma_6_2_dancing_guy_03;
	level.scr_anim[ "generic" ][ "guy_dance" ][3]			= %Ch_karma_6_2_dancing_guy_04;

	level.scr_anim[ "generic" ][ "couple_a_girl_dance" ]	= %Ch_karma_6_2_couple_dancing_A_girl;
	level.scr_anim[ "generic" ][ "couple_a_guy_dance" ]		= %Ch_karma_6_2_couple_dancing_A_guy;
	level.scr_anim[ "generic" ][ "couple_b_girl_dance" ]	= %Ch_karma_6_2_couple_dancing_B_girl;
	level.scr_anim[ "generic" ][ "couple_b_guy_dance" ]		= %Ch_karma_6_2_couple_dancing_B_guy;
	level.scr_anim[ "generic" ][ "couple_c_girl_dance" ]	= %Ch_karma_6_2_couple_dancing_C_girl;
	level.scr_anim[ "generic" ][ "couple_c_guy_dance" ]		= %Ch_karma_6_2_couple_dancing_C_guy;
	level.scr_anim[ "generic" ][ "couple_d_girl_dance" ]	= %Ch_karma_6_2_couple_dancing_D_girl;
	level.scr_anim[ "generic" ][ "couple_d_guy_dance" ]		= %Ch_karma_6_2_couple_dancing_D_guy;	
	
	//
	// DRONE civ normal anims
	//
	level.drones.anims[ "civ_walk" ][0]			= %fakeShooters::ch_karma_3_4_civwalk_01;
	level.drones.anims[ "civ_walk" ][1]			= %fakeShooters::ch_karma_3_4_civwalk_02;
	level.drones.anims[ "civ_walk" ][2]			= %fakeShooters::ch_karma_3_4_civwalk_03;
	
	level.drones.anims[ "civ_idle" ][0]			= %fakeShooters::ch_karma_3_4_cividle_01;
	level.drones.anims[ "civ_idle" ][1]			= %fakeShooters::ch_karma_3_4_cividle_02;
	level.drones.anims[ "civ_idle" ][2]			= %fakeShooters::ch_karma_3_4_cividle_03;

	//
	// DRONE single dancers anim
	//
	level.drones.anims[ "girl_dance" ][0]			= %fakeShooters::ch_karma_6_2_dancing_girl_01;
	level.drones.anims[ "girl_dance" ][1]			= %fakeShooters::ch_karma_6_2_dancing_girl_02;
	level.drones.anims[ "girl_dance" ][2]			= %fakeShooters::ch_karma_6_2_dancing_girl_03;
	level.drones.anims[ "girl_dance" ][3]			= %fakeShooters::ch_karma_6_2_dancing_girl_04;	
	
	level.drones.anims[ "guy_dance" ][0]			= %fakeShooters::ch_karma_6_2_dancing_guy_01;
	level.drones.anims[ "guy_dance" ][1]			= %fakeShooters::ch_karma_6_2_dancing_guy_02;
	level.drones.anims[ "guy_dance" ][2]			= %fakeShooters::ch_karma_6_2_dancing_guy_03;
	level.drones.anims[ "guy_dance" ][3]			= %fakeShooters::ch_karma_6_2_dancing_guy_04;
	
	//
	// DRONE couple dancers anim
	//
	level.drones.anims[ "couple_a_girl_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_a_girl;
	level.drones.anims[ "couple_a_guy_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_a_guy;
	level.drones.anims[ "couple_b_girl_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_b_girl;
	level.drones.anims[ "couple_b_guy_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_b_guy;
	level.drones.anims[ "couple_c_girl_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_C_girl;
	level.drones.anims[ "couple_c_guy_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_C_guy;
	level.drones.anims[ "couple_d_girl_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_D_guy;
	level.drones.anims[ "couple_d_guy_dance" ]			= %fakeShooters::ch_karma_6_2_couple_dancing_D_guy;
	
	//
	// DRONE extreme dancers anim
	//
	level.drones.anims[ "extreme_dancer_a" ]					= %fakeShooters::ch_karma_6_2_extreme_dancer_a;
	level.drones.anims[ "extreme_dancer_a_spectator_01" ]		= %fakeShooters::ch_karma_6_2_extreme_dancer_a_spectator_01;
	level.drones.anims[ "extreme_dancer_a_spectator_02" ]		= %fakeShooters::ch_karma_6_2_extreme_dancer_a_spectator_02;
	level.drones.anims[ "extreme_dancer_b" ]					= %fakeShooters::Ch_karma_6_2_extreme_dancer_B;
	level.drones.anims[ "extreme_dancer_b_spectator_01" ]		= %fakeShooters::Ch_karma_6_2_extreme_dancer_B_spectator_01;
	level.drones.anims[ "extreme_dancer_b_spectator_02" ]		= %fakeShooters::Ch_karma_6_2_extreme_dancer_B_spectator_02;
	level.drones.anims[ "extreme_dancer_b_spectator_03" ]		= %fakeShooters::Ch_karma_6_2_extreme_dancer_B_spectator_03;

	//
	// DRONE bouncer anim
	//	
	level.drones.anims[ "bouncer_club_a" ]		= %fakeShooters::ch_karma_6_2_bouncer_01;
	level.drones.anims[ "bouncer_club_b" ]		= %fakeShooters::ch_karma_6_2_bouncer_02;
	
	//
	//DRONE people chat anim
	//
	level.drones.anims[ "people_bar" ][0]		= %fakeShooters::ch_karma_6_2_3peopleatbar_01;
	level.drones.anims[ "people_bar" ][1]		= %fakeShooters::ch_karma_6_2_3peopleatbar_02;
	level.drones.anims[ "people_bar" ][2]		= %fakeShooters::ch_karma_6_2_3peopleatbar_03;
	
	//
	//DRONE bartender anim
	//
	level.drones.anims[ "bartender_a" ]		= %fakeShooters::ch_karma_6_2_bartender_01;
	level.drones.anims[ "bartender_b" ]		= %fakeShooters::ch_karma_6_2_bartender_02;
	
	//
	//DRONE djay anim
	//
	level.drones.anims[ "djay" ]			= %fakeShooters::ch_karma_6_2_deejay;

	//
	//DRONE girl guy chat anim
	//
//	level.drones.anims[ "girl_talk_a" ]			= %fakeShooters::ch_karma_6_2_guystalkingtogirl_girl_01;  //seated slouch
//	level.drones.anims[ "guy_talk_a" ]			= %fakeShooters::ch_karma_6_2_guystalkingtogirl_guy_01; //seated comfort
	level.drones.anims[ "girl_talk_b" ]			= %fakeShooters::ch_karma_6_2_guystalkingtogirl_girl_02;
	level.drones.anims[ "guy_talk_b" ]			= %fakeShooters::ch_karma_6_2_guystalkingtogirl_guy_02;	
	
	//
	//DRONE djay anim
	//
	level.drones.anims[ "stand_drinker" ][0]			= %fakeShooters::ch_karma_6_2_standing_drinker_01;
	level.drones.anims[ "stand_drinker" ][1]			= %fakeShooters::ch_karma_6_2_standing_drinker_02;
	level.drones.anims[ "stand_drinker" ][2]			= %fakeShooters::ch_karma_6_2_standing_drinker_03;
	
}

//
// 	Checkin Scenes - heading through security, Total Recall
//	Only ones that require an asset to be precaced
checkin_precache_anims()
{
	add_scene( "player_put_on_glasses", "intro_landing" );
	add_player_anim( "player_body", 			%player::p_karma_2_1_intr_walkin, SCENE_DELETE );
	add_prop_anim( "glasses",					%animated_props::o_karma_2_1_intr_walkin_sunglasses, "p6_sunglasses", SCENE_DELETE );

}


//
// 	Checkin Scenes - heading through security, Total Recall
checkin_anims()
{
	// Friendlies Walking from Landing Pad to Elevator 1
	//-------------------------------------------------------------------------------------------------
	// Section 1 Walk & Idle	
	//-------------------------------------------------------------------------------------------------
	add_scene( "team_walk_intro", "intro_landing" );
	add_actor_anim( "harper",		%ch_karma_2_1_intr_squad_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar",		%ch_karma_2_1_intr_squad_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "han",			%ch_karma_2_1_intr_squad_05, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt1",	%ch_karma_2_1_intr_squad_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_2_1_intr_squad_02, SCENE_HIDE_WEAPON );
	
	add_scene( "team_intro_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_2_1_idle_scanner_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar",		%ch_karma_2_1_idle_scanner_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "han",			%ch_karma_2_1_idle_scanner_05, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt1",	%ch_karma_2_1_idle_scanner_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_2_1_idle_scanner_02, SCENE_HIDE_WEAPON );

	//-------------------------------------------------------------------------------------------------
	// Section 2 Walk & Idle	
	//-------------------------------------------------------------------------------------------------	
	add_scene( "section_walk_2_1", "intro_landing" );
	add_actor_anim( "harper",		%ch_karma_2_1_intr_squad_pt2_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar",		%ch_karma_2_1_intr_squad_pt2_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "han",			%ch_karma_2_1_intr_squad_pt2_05, SCENE_HIDE_WEAPON );
	
	add_scene( "section_walk_2_1_redshirt", "intro_landing" );
	add_actor_anim( "redshirt1",	%ch_karma_2_1_intr_squad_pt2_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_2_1_intr_squad_pt2_02, SCENE_HIDE_WEAPON );
	

	add_scene( "section_walk_2_1_security", "intro_landing" );
	add_actor_anim( "security_01", 			%ch_karma_2_3_security_checks_blockers_04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "section_idle_2_1", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_2_1_idle_reception_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "han",			%ch_karma_2_1_idle_reception_05, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar",		%ch_karma_2_1_idle_reception_01, SCENE_HIDE_WEAPON );
	
	
	add_scene( "section_idle_2_1_redshirt", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "redshirt1",	%ch_karma_2_1_idle_reception_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_2_1_idle_reception_02, SCENE_HIDE_WEAPON );
	
	// Ambient workers
	add_scene( "worker_01_intro", "intro_landing" );
	add_actor_anim( "worker_01", %ch_karma_2_1_tarmac_worker_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_02", %ch_karma_2_1_tarmac_worker_02, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_03", %ch_karma_2_1_tarmac_worker_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_04", %ch_karma_2_1_tarmac_worker_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_05", %ch_karma_2_1_tarmac_worker_05, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_06", %ch_karma_2_1_tarmac_worker_06, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_07", %ch_karma_2_1_tarmac_worker_07, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_08", %ch_karma_2_1_tarmac_worker_08, SCENE_HIDE_WEAPON );
	add_prop_anim( "checkin_forklift", %animated_props::o_karma_2_1_tarmac_worker_forklift);
	add_prop_anim( "checkin_metalstorm", %animated_props::o_karma_2_1_tarmac_worker_metalstorm);
	
	
	add_scene( "worker_01_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "worker_01", %ch_karma_2_1_tarmac_worker_idle_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_02", %ch_karma_2_1_tarmac_worker_idle_02, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_03", %ch_karma_2_1_tarmac_worker_idle_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_04", %ch_karma_2_1_tarmac_worker_04_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_05", %ch_karma_2_1_tarmac_worker_05_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_06", %ch_karma_2_1_tarmac_worker_06_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_07", %ch_karma_2_1_tarmac_worker_07_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "worker_08", %ch_karma_2_1_tarmac_worker_08_idle, SCENE_HIDE_WEAPON );
	add_prop_anim( "checkin_forklift", %animated_props::o_karma_2_1_tarmac_worker_forklift_idle);
	add_prop_anim( "checkin_metalstorm", %animated_props::o_karma_2_1_tarmac_worker_metalstorm_idle);
	


	
	///////////////////////////////////////////////////////////////////////
	// Security guard loops
	
	// Left-side entrance
	add_scene( "security_01_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_01", %ch_karma_2_3_security_checks_blockers_04_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "security_02", %ch_karma_2_2_security_02, SCENE_HIDE_WEAPON);
	add_actor_anim( "security_03", %ch_karma_2_2_security_usher_idle);
	add_actor_anim( "security_04", %ch_karma_2_3_security_checks_blockers_02_idle);
	add_actor_anim( "security_05", %ch_karma_2_2_security_05 );

	//	Explosives workers and security scene
	
	// Explosives_workers intro and idle could be one scene since they're the same length,
	//	but I'm running each of these actors through an individual scene for compactness
	add_scene( "explosives_worker1_intro", "intro_landing" );
	add_actor_anim( "explosives_worker1", %ch_karma_2_1_blockers_enter_guy_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2", %ch_karma_2_1_blockers_enter_guy_02, SCENE_HIDE_WEAPON );
	
	//add_scene( "explosives_worker2_intro", "intro_landing" );
	
	add_scene( "explosives_worker1_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "explosives_worker1", %ch_karma_2_1_blockers_picking_up_items_guy_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2", %ch_karma_2_1_blockers_picking_up_items_guy_02, SCENE_HIDE_WEAPON );
	
	//add_scene( "explosives_worker2_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );

	add_scene( "explosives_workers_enter_scanner", "intro_landing" );
	add_actor_anim( "explosives_worker1",	%ch_karma_2_3_blockers_enter_scanner_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2",	%ch_karma_2_3_blockers_enter_scanner_02, SCENE_HIDE_WEAPON );
	add_actor_anim( "security_03", 			%ch_karma_2_3_security_usher_blockers );

	add_scene( "explosives_workers_enter_scanner_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "explosives_worker1", %ch_karma_2_3_blockers_enter_scanner_idle_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2", %ch_karma_2_3_blockers_enter_scanner_idle_02, SCENE_HIDE_WEAPON );

	add_scene( "explosives_workers_enter_scanner_alert", "intro_landing" );
	add_actor_anim( "explosives_worker1",	%ch_karma_2_3_blockers_alert_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2",	%ch_karma_2_3_blockers_alert_02, SCENE_HIDE_WEAPON );
	add_actor_anim( "security_03", 			%ch_karma_2_3_security_checks_blockers_01, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON);
	add_actor_anim( "security_04", 			%ch_karma_2_3_security_checks_blockers_02, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON);
	add_actor_anim( "security_05", 			%ch_karma_2_3_security_checks_blockers_03, !SCENE_HIDE_WEAPON );
	add_notetrack_custom_function("explosives_worker1", "in_scanner", maps\karma_checkin::inside_scanner );
	add_notetrack_custom_function("explosives_worker2", "in_scanner", maps\karma_checkin::inside_scanner );
	add_notetrack_custom_function("security_03", 		"in_scanner", maps\karma_checkin::inside_scanner );
	add_notetrack_custom_function("security_04", 		"in_scanner", maps\karma_checkin::inside_scanner );

	add_scene( "security_05_post_alert_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_05",			%ch_karma_2_3_security_05_after_alert_idle, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	add_scene( "security_01_enter_scanner_alert", "intro_landing" );
	add_actor_anim( "security_01", 			%ch_karma_2_3_security_checks_blockers_04, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

	add_scene( "security_01_post_alert_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_01",			%ch_karma_2_3_security_checks_blockers_04_alert_idle, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "security_01_post_alert_point", "intro_landing" );
	add_actor_anim( "security_01",			%ch_karma_2_3_security_checks_blockers_04_point, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "security_04_post_alert_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_04",			%ch_karma_2_3_security_checks_blockers_02_after_idle , !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	
	
	add_scene( "receptionist_a_talk", "intro_landing" );
	add_actor_anim( "receptionist_a",	%ch_karma_2_5_checkin_receptionist_talkingidle_A, SCENE_HIDE_WEAPON );
	add_actor_anim( "receptionist_b",	%ch_karma_2_5_checkin_receptionist_talkingidle_B, SCENE_HIDE_WEAPON );

	add_scene( "receptionist_idles", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "receptionist_a",		%ch_karma_2_5_checkin_receptionist_idle_A, SCENE_HIDE_WEAPON, false, true );
	add_actor_anim( "receptionist_b",		%ch_karma_2_5_checkin_receptionist_idle_B, SCENE_HIDE_WEAPON, false, true );	

	//-------------------------------------------------------------------------------------------------
	// Section 3 Walk & Idle	
	//-------------------------------------------------------------------------------------------------	
	add_scene( "section_walk_3", "intro_landing" );
	add_actor_anim( "harper",		%ch_karma_2_1_intr_squad_pt3_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar",		%ch_karma_2_1_intr_squad_pt3_01, SCENE_HIDE_WEAPON );
	
	add_scene( "section_walk_3_hans", "intro_landing" );
	add_actor_anim( "han",			%ch_karma_2_1_intr_squad_pt3_05, SCENE_HIDE_WEAPON );
	
	add_scene( "section_walk_3_redshirt", "intro_landing" );
	add_actor_anim( "redshirt1",	%ch_karma_2_1_intr_squad_pt3_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_2_1_intr_squad_pt3_02, SCENE_HIDE_WEAPON );

	add_scene( "tower_lift_wait", "align_player", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_wait1_harp, SCENE_HIDE_WEAPON );	
	add_actor_anim( "salazar",		%ch_karma_3_1_going_down_wait1_sala, SCENE_HIDE_WEAPON );
	
	add_scene( "tower_lift2_wait", "align_han", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "redshirt1",	%ch_karma_3_1_going_down_wait1_guy1, SCENE_HIDE_WEAPON );
	add_actor_anim( "redshirt2",	%ch_karma_3_1_going_down_wait1_guy2, SCENE_HIDE_WEAPON );
	
	add_scene( "tower_lift2_hans_wait", "align_han", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "han",			%ch_karma_3_1_going_down_wait1_han,  SCENE_HIDE_WEAPON );	

	// Elevator arrives, Harper and Salazar enter elevator
	add_scene( "tower_lift_enter", "align_player" );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_enter_harp );
	add_actor_anim( "salazar",		%ch_karma_3_1_going_down_enter_sala );
	
	// Wait for player to enter
	add_scene( "tower_lift_enter_wait", "align_player", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_wait2_harp );
	add_actor_anim( "salazar",		%ch_karma_3_1_going_down_wait2_sala );

	// Player enters
	add_scene( "tower_lift_workers_run", "align_player" );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_harp );
	add_actor_anim( "salazar",		%ch_karma_3_1_going_down_sala );
	add_actor_anim( "explosives_worker1",	%ch_karma_3_1_going_down_civ1, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "explosives_worker2",	%ch_karma_3_1_going_down_civ2, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// Han's group gets in
	add_scene( "tower_lift2_enter", "align_han" );
	add_actor_anim( "han",			%ch_karma_3_1_going_down_enter_han );
	add_actor_anim( "redshirt1",	%ch_karma_3_1_going_down_enter_guy1 );
	add_actor_anim( "redshirt2",	%ch_karma_3_1_going_down_enter_guy2 );
	
	// Riding elevator
	add_scene( "tower_lift_descent_wait", "align_player", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_loop_harp );
	add_actor_anim( "salazar",		%ch_karma_3_1_going_down_loop_sala );
	
	
	add_scene( "tower_lift2_descent_wait", "align_han", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "han",			%ch_karma_3_1_going_down_loop_han );
	add_actor_anim( "redshirt1",	%ch_karma_3_1_going_down_loop_guy1 );
	add_actor_anim( "redshirt2",	%ch_karma_3_1_going_down_loop_guy2 );

	precache_assets( true );
}
	

//
// 	Enter tower elevator and get to your hotel room.
//	Only ones that require an asset to be precached, like anims with spawned props
lobby_precache_anims()
{	
}


//
// 	Enter tower elevator and get to your hotel room.
lobby_anims()
{	
	// Exit elevator
	add_scene( "tower_lift_exit", "align_player"  );
	add_actor_anim( "harper",		%ch_karma_3_4_elevator_exit_harp );
	add_actor_anim( "salazar",		%ch_karma_3_4_elevator_exit_sala );
	add_actor_anim( "karma",		%ch_karma_3_4_elevator_exit_karm );
	add_actor_anim( "civilian1",	%ch_karma_3_4_elevator_exit_civ1 );

	// Wait for player to leave
	add_scene( "tower_lift_exit_wait", "align_player", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",		%ch_karma_3_4_elevator_exit_wait_sala, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "karma",		%ch_karma_3_4_elevator_exit_wait_karm, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "civilian1",	%ch_karma_3_4_elevator_exit_wait_civ1, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// farid calls player
	add_scene( "first_farid_call", "generic_align" );
	add_actor_anim( "farid",						%ch_karma_3_4_farid_closeup );
	add_prop_anim( "farid_camera",				%animated_props::o_karma_farid_closeup_camera );  //"origin_animate_jnt"
/*
	// Harper opens the room door
	add_scene( "open_hotel_room_harper", "align_spiderbot_gear", true );
	add_actor_anim( "harper",		%ch_karma_3_4_room_open_door_harper );

	// Player opens the room door
	add_scene( "open_hotel_room_player", "align_spiderbot_gear", true );
	add_player_anim( "player_body",	%player::p_karma_3_4_room_open_door_player, SCENE_DELETE );
*/

	// Player climbs up elevator hatch
	add_scene( "player_climb_hatch", "align_rappel_cable" );
	add_player_anim( "player_body",				%player::p_karma_5_2_elevator_player_hatch01, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	// Teammates hang out waiting for you to rappel
	add_scene( "team_hatch_idle", "align_rappel_cable", !SCENE_REACH, undefined, SCENE_LOOP );
	add_actor_anim( "harper",					%ch_karma_5_2_elevator_harper_hatch01_idl );
	add_actor_anim( "salazar",					%ch_karma_5_2_elevator_salazar_hatch01_idl );
	// Player rappeling down the elevator shaft.
	add_scene( "player_rappel", "align_rappel_cable" );
	add_player_anim( "player_body", 			%player::p_karma_5_2_elevator_player_hatch02, !SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "salazar",					%ch_karma_5_2_elevator_salazar_hatch02_idl );

	// These 4 scenes all start at once, but need to be separate due to different end times.
	//	They need to be separate because the enemies start shooting at different times.
	// Player opens door
	add_scene( "player_pry_open", "align_takedown" );
	add_player_anim( "player_body", 			%player::p_karma_5_2_elevator_encounter_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN  );
	add_notetrack_custom_function("player_body", "door_open", maps\karma_dropdown::pry_open_doors );
	// Enemies surprise player
	add_scene( "elevator_encounter1", "align_takedown" );
	add_actor_anim( "dropdown_guard1",			%ch_karma_5_2_elevator_encounter_terrorist_01 );

	add_scene( "elevator_encounter2", "align_takedown" );
	add_actor_anim( "dropdown_guard2",			%ch_karma_5_2_elevator_encounter_terrorist_02 );

	add_scene( "elevator_encounter3", "align_takedown" );
	add_actor_anim( "dropdown_hacker",			%ch_karma_5_2_elevator_encounter_hacker );

	// Harper waits outside the spiderbot setup room
	add_scene( "harper_wait_outside_spiderbot", "align_spiderbot_gear", SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_4_hotel_room_wait_outside_harper );
	
	// Harper waits outside the spiderbot setup room
	add_scene( "harper_go_inside_spiderbot", "align_spiderbot_gear", SCENE_REACH );
	add_actor_anim( "harper",		%ch_karma_4_1_hotel_room_enter_harper );

	// Harper waits for us to get in place
	add_scene( "harper_wait_vent_spiderbot", "align_spiderbot_gear", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_4_1_hotel_room_wait_idle_harper );
	
	add_scene( "harper_wait", "align_spiderbot_gear", false, false, true );
	add_actor_anim( "harper", 		%ch_karma_4_1_hotel_room_set_bot_harper_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	add_scene( "open_crc_lobby_entry_elevator", "align_rappel_cable", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, true);
	add_prop_anim( "atrium_to_crc_entry_elevator", %animated_props::o_karma_3_1_elevator_open);
	
	add_scene( "open_crc_lobby_exit_elevator", "align_rappel_cable", !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, true);
	add_prop_anim( "atrium_to_crc_exit_elevator", %animated_props::o_karma_3_1_elevator_open);
	

	precache_assets( true );
}


//
//
spiderbot_precache_anims()
{
	// Spiderbot setup	
	add_scene( "set_spiderbot", "align_spiderbot_gear" );
//	add_actor_anim( "harper", 		%ch_karma_4_1_hotel_room_set_bot_harper, SCENE_HIDE_WEAPON );
	add_player_anim( "player_body", %player::p_karma_4_1_hotel_room_set_bot, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_prop_anim( "briefcase", 	%animated_props::o_karma_4_1_hotel_room_set_bot_briefcase, "test_p_anim_karma_briefcase" );
	add_prop_anim( "pad", 			%animated_props::o_karma_4_1_hotel_room_set_bot_pad, "test_p_anim_karma_pad" );
	add_prop_anim( "hotel_room_vent", %animated_props::o_karma_4_1_hotel_room_set_bot_vent );
	add_prop_anim( "anim_bot",		%animated_props::o_karma_4_1_hotel_room_set_bot_spiderbot, "veh_t6_spider_large", true );

}


//
//	Spiderbot 
//		Hotel Room spiderbot prep
spiderbot_anims()
{
/*
	// Enter Hotel room
	add_scene( "hotel_room_enter_player", "align_spiderbot_gear" );
	add_player_anim( "player_body", %player::p_karma_4_1_hotel_room_enter_player, !SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 0.8, 45, 45, 75, 45 );

	add_scene( "hotel_room_enter_harper", "align_spiderbot_gear" );
	add_actor_anim( "harper", %ch_karma_4_1_hotel_room_enter_harper, SCENE_HIDE_WEAPON );

	add_scene( "hotel_room_wait_harper", "align_spiderbot_gear", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper", %ch_karma_4_1_hotel_room_wait_idle_harper, SCENE_HIDE_WEAPON );
*/

	// Terrorists planting bombs
	add_scene( "planting_bombs", "align_bombplant", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "bomb_planter1",		%ch_karma_4_2_hallway_bombs_terrorist_01, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "bomb_planter2",		%ch_karma_4_2_hallway_bombs_terrorist_02, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "bomb_planter3",		%ch_karma_4_2_hallway_bombs_terrorist_03, !SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	// Suspicious Dudes
	add_scene( "scene_suspicious_guys", "atrium_entrance" );
	add_actor_anim( "suspicious_guy_1",			%ch_karma_4_2_suspicious_guards_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_2",			%ch_karma_4_2_suspicious_guards_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_3",			%ch_karma_4_2_suspicious_guards_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guys_camera", 	%ch_karma_4_2_suspicious_guards_camera, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "scene_suspicious_guys_leaving", "atrium_entrance" );
	add_actor_anim( "suspicious_guy_1",			%ch_karma_4_6_suspicious_guards_part2_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_2",			%ch_karma_4_6_suspicious_guards_part2_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_3",			%ch_karma_4_6_suspicious_guards_part2_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guys_camera", 	%ch_karma_4_6_suspicious_guards_part2_camera, SCENE_HIDE_WEAPON );

/*	
	// IT Guys
	add_scene( "it_guy1_idle", "it_chair_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "it_guy1",		%ch_karma_4_7_it_security_idle_guy01, SCENE_HIDE_WEAPON );

	add_scene( "it_guy2_idle", "it_chair_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "it_guy2",		%ch_karma_4_7_it_security_idle_guy02, SCENE_HIDE_WEAPON );

	add_scene( "it_guy1_react", "it_chair_align" );
	add_actor_anim( "it_guy1",		%ch_karma_4_7_it_security_react_guy01, SCENE_HIDE_WEAPON );
	add_notetrack_custom_function("it_guy1", "alarm", maps\karma_spiderbot::alarm_pressed );	

	add_scene( "it_guy2_react", "it_chair_align" );
	add_actor_anim( "it_guy2",		%ch_karma_4_7_it_security_react_guy02, SCENE_HIDE_WEAPON );
	add_notetrack_custom_function("it_guy2", "alarm", maps\karma_spiderbot::alarm_pressed );	

	add_scene( "it_guy1_shock_run", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_guy1",		%ch_karma_4_7_it_security_runshock_guy01, SCENE_HIDE_WEAPON );

	add_scene( "it_guy2_shock_run", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_guy2",		%ch_karma_4_7_it_security_runshock_guy01, SCENE_HIDE_WEAPON );

	add_scene( "it_guy1_shock_stationary", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_guy1",		%ch_karma_4_7_it_security_sitshock_guy01, SCENE_HIDE_WEAPON );

	add_scene( "it_guy2_shock_stationary", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_guy2",		%ch_karma_4_7_it_security_sitshock_guy01, SCENE_HIDE_WEAPON );
*/

	// IT Manager
	add_scene( "it_mgr_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_crc_manager_loop_guy1 );

	add_scene( "it_mgr_surprise", "align_computer" );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_crc_manager_guy1 );
	add_vehicle_anim( "spiderbot",	%vehicles::ch_karma_4_8_crc_manager_spiderbot, !SCENE_DELETE );
/*
	add_scene( "it_mgr_react", "gulliver_align" );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_guy01, SCENE_HIDE_WEAPON );
	add_notetrack_custom_function("it_mgr", "alarm", maps\karma_spiderbot::alarm_pressed );	
*/	
	add_scene( "it_mgr_shock_run", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_runshock_guy01, SCENE_HIDE_WEAPON );

	add_scene( "it_mgr_shock_stationary", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_standshock_guy01, SCENE_HIDE_WEAPON );
	
	add_scene( "it_mgr_twitch_idle", undefined, !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_twitchidle_guy01, SCENE_HIDE_WEAPON );

	add_scene( "eye_scan", "gulliver_align" );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_eyescan_guy01, SCENE_HIDE_WEAPON );
	add_vehicle_anim( "spiderbot",	%vehicles::p_karma_4_8_it_manager_eyescan_spiderbot, !SCENE_DELETE );
//	add_vehicle_anim( "spiderbot",	%vehicles::p_karma_4_8_it_manager_eyescan_spiderbot, !SCENE_DELETE, SCENE_NO_HIDE_PARTS, SCENE_NO_TAG, !SCENE_ANIMATE_ORIGIN, "spiderbot_large", "veh_t6_spider_large" );
	add_player_anim( "player_body",	%player::p_karma_4_8_it_manager_eyescan_playercam, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN  );

	precache_assets( true );
}


/* ------------------------------------------------------------------------------------------
	Event 5 Animations from Hotel Room - Elevator 3 to Club Solar.
-------------------------------------------------------------------------------------------*/
construction_precache_anims()
{
	// Player putting away gear in hotel room.
	add_scene( "scene_p_gear_away", "align_spiderbot_gear" );
	add_player_anim( "player_body",		%player::p_karma_4_1_hotel_room_exit, SCENE_DELETE );
	add_prop_anim( "briefcase", 		%animated_props::o_karma_4_1_hotel_room_exit_briefcase, "test_p_anim_karma_briefcase", SCENE_DELETE );
	add_prop_anim( "pad", 				%animated_props::o_karma_4_1_hotel_room_exit_pad, "test_p_anim_karma_pad", SCENE_DELETE );	
	add_prop_anim( "hotel_room_vent", 	%animated_props::o_karma_4_1_hotel_room_exit_vent );
	add_actor_anim( "salazar", 			%ch_karma_4_1_hotel_room_exit_harper );
}

construction_anims()
{
	
/*	
	// Player opening door activated by bump trigger.
	add_scene( "scene_p_open_room_door", "align_spiderbot_gear" );
	add_player_anim( "player_body",			%player::p_karma_5_1_door_open_player, SCENE_DELETE );
	
	add_notetrack_custom_function("player_body", "door_open", ::door_open );
*/

	// farid calls again
	add_scene( "second_farid_call", "generic_align" );
	add_actor_anim( "farid",				%ch_karma_5_2_farid_closeup_2 );
	add_prop_anim( "farid_camera",				%animated_props::o_karma_farid_closeup_camera );  //"origin_animate_jnt"
	
	// Player opening CRC door using eye scan.
	add_scene( "scene_p_eye_scan", "align_crc_door" );
	add_player_anim( "player_body",			%player::p_karma_5_3_retinal_scan_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	
	// Salazar at the computer terminal.
	add_scene( "scene_sal_intro_comp", "align_computer" );
	add_actor_anim( "salazar",				%ch_karma_5_4_crc_hack_intro_sala );
	
	add_scene( "scene_sal_loop_comp", "align_computer", false, false, true );
	add_actor_anim( "salazar",				%ch_karma_5_4_crc_hack_loop_sala );
	
//	add_scene( "scene_sal_throw_gun", "align_computer" );
//	add_actor_anim( "salazar",				%ch_karma_5_4_crc_hack_end_sala );
	
	
	// Player accessing the computer main frame (Minority Report)
	add_scene( "scene_p_comp_karma", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "salazar",					%ch_karma_5_4_crc_hack_end_sala );
	add_prop_anim( "crc_screen", 				%animated_props::o_karma_5_4_crc_mainframe_screen );	
	
	// Lobby Shootout
	add_scene( "scene_lobby_shootout", "align_elevator_last" );
	add_actor_anim( "assault_shooter",		%ch_karma_5_4_security_takedown_enemy_01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "shotgun_shooter",		%ch_karma_5_4_security_takedown_enemy_02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_01",		%ch_karma_5_4_security_takedown_guard_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_02",		%ch_karma_5_4_security_takedown_guard_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_03",		%ch_karma_5_4_security_takedown_guard_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );	
	
	// Salazar opening crc door from the inside.
	add_scene( "scene_sal_ready_crc_door", "align_crc_door" );
	add_actor_anim( "salazar",					%ch_karma_5_6_exitcrc_enter_sala );
	
	add_scene( "scene_sal_loop_crc_door", "align_crc_door", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_4_exit_crc_salazar_startidl );
	
	add_scene( "scene_sal_exit_crc_door", "align_crc_door");
	add_actor_anim( "salazar",					%ch_karma_5_4_exit_crc_salazar);
	add_actor_anim( "victim",					%ch_karma_5_4_exit_crc_guard1 );
	add_actor_anim( "guard_02_reaction",		%ch_karma_5_4_exit_crc_guard2 );
	add_player_anim( "player_body",			%player::p_karma_5_4_exit_crc_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
//	add_notetrack_custom_function( "player_body",	"show_weapon", ::show_weapon_func );
	
	// Guards reaction infront of CRC door when victim is shot in the head.
	add_scene( "scene_guard_reaction_crc_door", "align_takedown" );
	add_actor_anim( "guard_03_reaction",		%ch_karma_5_6_exitcrc_reaction_guard3 );
	add_actor_anim( "guard_lead_reaction",	%ch_karma_5_6_exitcrc_reaction_guardlead );	
	
	add_scene( "e5_guards_cover_fire", "align_hallway" );
	add_actor_anim( "creeper_1", 					%ch_karma_5_6_corner_guards_guy1 );
	add_actor_anim( "creeper_2", 			%ch_karma_5_6_corner_guards_guy2 );
	
	add_scene( "e5_elevator_guard_flash_exit", "align_hallway" );
	add_actor_anim( "ai_con_site_elevator_guard_1", 			%ch_karma_5_6_elevator_guards_guy3 );
	add_actor_anim( "ai_con_site_elevator_guard_2", 			%ch_karma_5_6_elevator_guards_guy2 );
	add_actor_anim( "smoke_grenade_guy_02", 			%ch_karma_5_6_elevator_guards_guy1 );
	add_notetrack_custom_function( "smoke_grenade_guy_02",	"throw_flash", maps\karma_construction::throw_flash_bang );
	
	
	//guard balcony into the guard room.
	add_scene("e5_balcony_guard_death", "align_hallway", SCENE_REACH);
	add_actor_anim( "ai_con_dead_balcony_guy", 			%ch_karma_5_4_balcony_death_guy01 , undefined, undefined, undefined, true);
	
	
	
	
	// Salazar stealth takedown in the construction site.
	add_scene( "scene_sal_takedown", "align_takedown" );
	add_actor_anim( "salazar", 					%ch_karma_5_6_salazar_takedown_sala );
	add_actor_anim( "salazar_victim", 			%ch_karma_5_6_salazar_takedown_grd1 );
	
	// Salazar & Player at elevator 3 anims.
	add_scene( "scene_sal_elevator_enter", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_enter_sala );
	
	add_scene( "scene_sal_elevator_wait", "align_elevator_last", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_wait_sala );

	add_scene( "scene_sal_elevator_button", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_pressbutton_sala );
	
	add_scene( "scene_sal_elevator_pack", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_packing_sala );		

	add_scene( "scene_sal_elevator_idle", "align_elevator_last", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_loop_sala );	
	
	add_scene( "scene_sal_elevator_comment", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_comment_sala );	

	add_scene( "scene_sal_elevator_exit", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_exit_sala );		

	add_scene( "scene_p_elevator_03", "align_elevator_last" );
	add_player_anim( "player_body", 			%player::p_karma_5_7_elevator_enter_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );

	precache_assets( true );
	}	
	
	
/* ------------------------------------------------------------------------------------------
	Event 6 Animations inside Club Solar.
-------------------------------------------------------------------------------------------*/
club_precache_anims()
	{
}

club_anims()
{
	add_scene( "scene_enter_bouncer_door", "align_entrance_solar" );
	add_actor_anim( "bouncer",					%ch_karma_6_1_badge_bouncer );
	
	add_scene( "bouncer_lounge_door_idle", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_loop );

	add_scene( "bouncer_lounge_door_open", "club_lobby" );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door );
	
	add_scene( "bouncer_lounge_door_wait", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_wait );
	
	add_scene( "bouncer_lounge_door_close", "club_lobby" );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_close );


	// Group dancing
	add_scene( "group_dancing", undefined, !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, !SCENE_ALIGN  );
	add_multiple_generic_props_from_radiant( "m_civ_club_group1",	%animated_props::ch_karma_6_2_group_dancing_01 );

	// Civs on the dance floor
	add_scene( "club_dance_civs_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "dance_civ1", 		%ch_karma_6_3_clubsolar_loop_civ1 );
	add_actor_anim( "dance_civ2", 		%ch_karma_6_3_clubsolar_loop_civ2 );
	add_actor_anim( "dance_civ3", 		%ch_karma_6_3_clubsolar_loop_civ3 );
	add_actor_anim( "dance_civ4", 		%ch_karma_6_3_clubsolar_loop_civ4 );
	add_actor_anim( "dance_civ5", 		%ch_karma_6_3_clubsolar_loop_civ5 );

	// Karma and Harper
	add_scene( "harper_and_karma_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper", 					%ch_karma_6_3_clubsolar_loop_harper );
	add_actor_anim( "karma",					%ch_karma_6_3_clubsolar_loop_karma );
	
	// Defalco enters and takes Karma	
	add_scene( "defalco_takes_karma", "dance_floor" );
	add_player_anim( "player_body", 		%player::p_karma_6_3_clubsolar_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, SCENE_DELTA, 1, 15, 15, 15, 15, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_actor_anim( "harper", 				%ch_karma_6_3_clubsolar_harper );
	add_actor_anim( "karma", 				%ch_karma_6_3_clubsolar_karma, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "defalco",		 		%ch_karma_6_3_clubsolar_defalco, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_guard_1",			%ch_karma_6_3_clubsolar_guard1);
	add_actor_anim( "club_guard_2",			%ch_karma_6_3_clubsolar_guard2);
	add_actor_anim( "club_guard_3",			%ch_karma_6_3_clubsolar_guard3);
	add_actor_anim( "defalco_bodyguard1", 	%ch_karma_6_3_clubsolar_bodyguard1, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "defalco_bodyguard2", 	%ch_karma_6_3_clubsolar_bodyguard2, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_dj",				%ch_karma_6_3_clubsolar_dj );
	addNotetrack_customFunction( "player_body", "escape_left",  maps\karma_inner_solar::corral_left );
	addNotetrack_customFunction( "player_body", "escape_right", maps\karma_inner_solar::corral_right);

	// Dance floor civs react to terrorists
	add_scene( "club_dance_civs_react", "dance_floor" );
	add_actor_anim( "dance_civ1", 			%ch_karma_6_3_clubsolar_civ1 );
	add_actor_anim( "dance_civ2", 			%ch_karma_6_3_clubsolar_civ2 );
	add_actor_anim( "dance_civ3", 			%ch_karma_6_3_clubsolar_civ3 );
	add_actor_anim( "dance_civ4", 			%ch_karma_6_3_clubsolar_civ4 );
	add_actor_anim( "dance_civ5", 			%ch_karma_6_3_clubsolar_civ5 );

	// NOTE: "dance_civ"11-13 will be deleted at the end of the scene
	// Civs corralled right
	add_scene( "civs_corralled_right", "dance_floor" );
	add_actor_anim( "dance_civ6",			%ch_karma_6_3_clubsolar_escape_right_civ1, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ7",			%ch_karma_6_3_clubsolar_escape_right_civ2, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ8",			%ch_karma_6_3_clubsolar_escape_right_civ3, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ11",			%ch_karma_6_3_clubsolar_escape_right_civ4, SCENE_HIDE_WEAPON );
	add_actor_anim( "club_guard_4",			%ch_karma_6_3_clubsolar_escape_right_guard );

	// Civs corralled left
	add_scene( "civs_corralled_left", "dance_floor" );
	add_actor_anim( "dance_civ9",			%ch_karma_6_3_clubsolar_escape_left_civ1, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ12",			%ch_karma_6_3_clubsolar_escape_left_civ2, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ10",			%ch_karma_6_3_clubsolar_escape_left_civ3, SCENE_HIDE_WEAPON );
	add_actor_anim( "dance_civ13",			%ch_karma_6_3_clubsolar_escape_left_civ4, SCENE_HIDE_WEAPON );
	add_actor_anim( "club_guard_5",			%ch_karma_6_3_clubsolar_escape_left_guard );

	// Harper on the ground
	add_scene( "harper_unconscious_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",					%ch_karma_6_3_clubsolar_prone_loop_harper );

	// Civs cower
	add_scene( "club_dance_civs_cower_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "dance_civ1", %ch_karma_6_3_clubsolar_civcower_idle_01, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ2", %ch_karma_6_3_clubsolar_civcower_idle_02, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ3", %ch_karma_6_3_clubsolar_civcower_idle_03, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ4", %ch_karma_6_3_clubsolar_civcower_idle_04, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ5", %ch_karma_6_3_clubsolar_civcower_idle_05, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ6", %ch_karma_6_3_clubsolar_civcower_idle_06, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ7", %ch_karma_6_3_clubsolar_civcower_idle_07, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ8", %ch_karma_6_3_clubsolar_civcower_idle_08, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ9", %ch_karma_6_3_clubsolar_civcower_idle_09, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ10", %ch_karma_6_3_clubsolar_civcower_idle_10, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );

	add_scene( "club_dance_civs_run", "dance_floor" );
	add_actor_anim( "dance_civ1", %ch_karma_6_3_clubsolar_civcower_run_01, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ2", %ch_karma_6_3_clubsolar_civcower_run_02, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ3", %ch_karma_6_3_clubsolar_civcower_run_03, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ4", %ch_karma_6_3_clubsolar_civcower_run_04, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ5", %ch_karma_6_3_clubsolar_civcower_run_05, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ6", %ch_karma_6_3_clubsolar_civcower_run_06, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ7", %ch_karma_6_3_clubsolar_civcower_run_07, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ8", %ch_karma_6_3_clubsolar_civcower_run_08, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ9", %ch_karma_6_3_clubsolar_civcower_run_09, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );
	add_actor_anim( "dance_civ10", %ch_karma_6_3_clubsolar_civcower_run_10, SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, SCENE_ALIGN );

	// 	NOTE: One of the "club_terrorist" guys will change his animname to "melee_target" just before the player melees them
	add_scene( "club_melee_back", "generic_align" );
	add_actor_anim( "melee_target", %ai_contextual_melee_kill_back_from_crouch );
	add_player_anim( "player_body", %player::int_contextual_melee_kill_back_from_crouch, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );

	// 	NOTE: One of the "club_terrorist" guys will change his animname to "melee_target" just before the player melees them
	add_scene( "club_melee_front", "generic_align" );
	add_actor_anim( "melee_target", %ai_contextual_melee_kill_front_from_crouch );
	add_player_anim( "player_body", %player::int_contextual_melee_kill_front_from_crouch, SCENE_DELETE );

	add_scene( "bullet_time_bullet_spin", undefined, !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim( "bullet", %animated_props::o_karma_6_6_bullettime_bullet_spin );	//, "anim_glo_bullet_tip" );
//	add_prop_anim( "camera", %animated_props::o_karma_6_6_bullettime_bullet_cam );
	
	//----------------------------------
	// Meatshield Sequence
	// 	NOTE: One of the "club_terrorist" guys will change his animname to "meatshield_enemy" after the melee kill
	add_scene( "club_meatshield_intro", "dance_floor" );
	add_actor_anim( "meatshield_enemy", %ch_karma_6_3_clubsolar_meatshield_guard_moving );
	add_actor_anim( "harper",			%ch_karma_6_3_clubsolar_meatshield_harper_unconscious );

	add_scene( "club_meatshield_struggle", "dance_floor" );
	add_actor_anim( "meatshield_enemy", %ch_karma_6_3_clubsolar_meatshield_guard_struggle );
	add_actor_anim( "harper",			%ch_karma_6_3_clubsolar_meatshield_harper_struggle );

	add_scene( "club_meatshield_conclusion", "dance_floor" );
	add_actor_anim( "meatshield_enemy", %ch_karma_6_3_clubsolar_meatshield_guard_showdown );
	add_actor_anim( "harper",			%ch_karma_6_3_clubsolar_meatshield_harper_showdown );

	precache_assets( true );
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
	add_actor_anim( "e7_civ4_window_loop_1", %ch_karma_7_2_civs_watch_escape_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_civ4_window_loop_2", %ch_karma_7_2_civs_watch_escape_02, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_civ4_window_loop_3", %ch_karma_7_2_civs_watch_escape_03, SCENE_HIDE_WEAPON );
	add_actor_anim( "e7_civ4_window_loop_4", %ch_karma_7_2_civs_watch_escape_04, SCENE_HIDE_WEAPON );


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

	//*****************************************************
	// Defalco drags karma (with security) through the mall
	//*****************************************************

	add_scene( "scene_event8_defalco_karma_intro", "mall_intro" );
	add_actor_anim( "defalco", %ch_karma_8_1_karma_dragged_defalco, SCENE_HIDE_WEAPON );
	add_actor_anim( "karma", %ch_karma_8_1_karma_dragged_karma, SCENE_HIDE_WEAPON );
	add_actor_anim( "e8_solder1_start_anim", %ch_karma_8_1_karma_dragged_bodyguard1, SCENE_HIDE_WEAPON );
	add_actor_anim( "e8_solder2_start_anim", %ch_karma_8_1_karma_dragged_bodyguard2, SCENE_HIDE_WEAPON );
	
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

// sb42
	add_scene( "scene_event8_stair_rush_girl_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_start );
	add_scene( "scene_event8_stair_rush_girl_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_idl );
	add_scene( "scene_event8_stair_rush_girl_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_a", %ch_karma_9_1_stair_rush_girl_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_girl_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_start );
	add_scene( "scene_event8_stair_rush_girl_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_idl );
	add_scene( "scene_event8_stair_rush_girl_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_girl_b", %ch_karma_9_1_stair_rush_girl_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy1_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_start );
	add_scene( "scene_event8_stair_rush_guy1_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_idl );
	add_scene( "scene_event8_stair_rush_guy1_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_a", %ch_karma_9_1_stair_rush_guy1_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy1_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_start );
	add_scene( "scene_event8_stair_rush_guy1_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_idl );
	add_scene( "scene_event8_stair_rush_guy1_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy1_b", %ch_karma_9_1_stair_rush_guy1_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy2_a_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_start );
	add_scene( "scene_event8_stair_rush_guy2_a_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_idl );
	add_scene( "scene_event8_stair_rush_guy2_a_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_a", %ch_karma_9_1_stair_rush_guy2_a_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy2_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_start );
	add_scene( "scene_event8_stair_rush_guy2_b_idle", "courtyard_civ_escape_mall", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_idl );
	add_scene( "scene_event8_stair_rush_guy2_b_stairs", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy2_b", %ch_karma_9_1_stair_rush_guy2_b_stairs, undefined, SCENE_DELETE );

	add_scene( "scene_event8_stair_rush_guy3_b_start", "courtyard_civ_escape_mall" );
	add_actor_model_anim( "stair_rush_guy3_b", %ch_karma_9_1_stair_rush_guy3_b_start );
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
	add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_guard1 );
	add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_guard2 );
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
	add_actor_anim( "enemy_soldier_end_level_left", %ch_karma_10_1_standoff_death_guard1 );
	add_actor_anim( "enemy_soldier_end_level_right", %ch_karma_10_1_standoff_death_guard2 );
	

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


