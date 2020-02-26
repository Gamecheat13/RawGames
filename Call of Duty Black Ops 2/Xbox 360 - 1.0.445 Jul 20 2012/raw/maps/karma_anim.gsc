
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
	maps\voice\voice_karma::init_voice();
	traversal_anims();
	perk_anims(); // uses Digital Devices - specialty_trespasser
	civilian_anims();

	//arrival_precache_anims();
	checkin_precache_anims();
	dropdown_precache_anims();
	spiderbot_precache_anims();	// 
	construction_precache_anims();  // Event 5 Animations from Hotel Room - Elevator 3 to Club Solar.
	club_precache_anims();

	// NOTE: All other section anims are initialized in the skipto_event
	fx_anims();			// Trees etc......

	level.scr_anim[ "vtol" ][ "gear_up" ][0] 	= %vehicles::v_karma_1_1_vtol_gear_up;
	level.scr_anim[ "vtol" ][ "gear_down" ][0] 	= %vehicles::v_karma_1_1_vtol_gear_down;
	
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
traversal_anims()
{
	level.scr_anim[ "generic" ][ "ai_jump_down_29_01" ]			= %ai_jump_down_29_01;
	level.scr_anim[ "generic" ][ "ai_jump_down_29_02" ]			= %ai_jump_down_29_02;
	level.scr_anim[ "generic" ][ "ai_mantle_on_29" ] 			= %ai_mantle_on_29;
	level.scr_anim[ "generic" ][ "ai_mantle_over_36_down_63" ]	= %ai_mantle_over_36_down_63;
	level.scr_anim[ "generic" ][ "ai_mantle_over_36_down_68" ]	= %ai_mantle_over_36_down_68;
	level.scr_anim[ "generic" ][ "ai_mantle_over_63_down_36" ]	= %ai_mantle_over_63_down_36;
	level.scr_anim[ "generic" ][ "ai_mantle_over_68_down_36" ]	= %ai_mantle_over_68_down_36;
	level.scr_anim[ "generic" ][ "ai_roll_over_bar_44_in" ]		= %ai_roll_over_bar_44_in;
	level.scr_anim[ "generic" ][ "ai_roll_over_bar_44_out" ]	= %ai_roll_over_bar_44_out;
}


//
//
perk_anims()
{
	// Event 5
	// uses Digital Devices - specialty_trespasser
	add_scene( "trespasser", "align_trespasser" );
	add_prop_anim( "trespasser_phone", 		%animated_props::o_specialty_karma_lockbreaker_dongle, "t6_wpn_hacking_dongle_prop", false );
	add_player_anim( "player_body", 		%player::int_specialty_karma_lockbreaker, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
}


//
//...................
civilian_anims()
{
	level.scr_anim[ "civ_male" ][ "v0" ][ "idle" ]		= %ai_civ_m_idle_stand_00;
	level.scr_anim[ "civ_male" ][ "v0" ][ "walk" ]		= %ai_civ_m_walk_00;
	level.scr_anim[ "civ_male" ][ "v0" ][ "bump" ]		= %ai_civ_m_bump_00;
	level.scr_anim[ "civ_male" ][ "v0" ][ "turn_l" ]	= %ai_civ_m_turn_l_00;
	level.scr_anim[ "civ_male" ][ "v0" ][ "turn_r" ]	= %ai_civ_m_turn_r_00;

	level.scr_anim[ "civ_male" ][ "v1" ][ "idle" ]		= %ai_civ_m_idle_stand_01;
	level.scr_anim[ "civ_male" ][ "v1" ][ "walk" ]		= %ai_civ_m_walk_01;
	level.scr_anim[ "civ_male" ][ "v1" ][ "bump" ]		= %ai_civ_m_bump_01;
	level.scr_anim[ "civ_male" ][ "v1" ][ "turn_l" ]	= %ai_civ_m_turn_l_01;
	level.scr_anim[ "civ_male" ][ "v1" ][ "turn_r" ]	= %ai_civ_m_turn_r_01;

	level.scr_anim[ "civ_male" ][ "v3" ][ "idle" ]		= %ai_civ_m_idle_stand_03;
	level.scr_anim[ "civ_male" ][ "v3" ][ "walk" ]		= %ai_civ_m_walk_03;
	level.scr_anim[ "civ_male" ][ "v3" ][ "bump" ]		= %ai_civ_m_bump_03;
	level.scr_anim[ "civ_male" ][ "v3" ][ "turn_l" ]	= %ai_civ_m_turn_l_03;
	level.scr_anim[ "civ_male" ][ "v3" ][ "turn_r" ]	= %ai_civ_m_turn_r_03;

	level.scr_anim[ "civ_male" ][ "drink" ][ "idle" ]	= %ai_civ_m_idle_stand_drink_00;
	level.scr_anim[ "civ_male" ][ "drink" ][ "walk" ]	= %ai_civ_m_walk_drink_00;
	level.scr_anim[ "civ_male" ][ "drink" ][ "bump" ]	= %ai_civ_m_bump_drink_00;
	level.scr_anim[ "civ_male" ][ "drink" ][ "turn_l" ]	= %ai_civ_m_turn_l_drink_00;
	level.scr_anim[ "civ_male" ][ "drink" ][ "turn_r" ]	= %ai_civ_m_turn_r_drink_00;

	level.scr_anim[ "civ_male" ][ "phone" ][ "idle" ]	= %ai_civ_m_idle_stand_phone1_00;
	level.scr_anim[ "civ_male" ][ "phone" ][ "walk" ]	= %ai_civ_m_walk_phone1_00;
	level.scr_anim[ "civ_male" ][ "phone" ][ "bump" ]	= %ai_civ_m_bump_phone1_00;
	level.scr_anim[ "civ_male" ][ "phone" ][ "turn_l" ]	= %ai_civ_m_turn_l_phone1_00;
	level.scr_anim[ "civ_male" ][ "phone" ][ "turn_r" ]	= %ai_civ_m_turn_r_phone1_00;

	level.scr_anim[ "civ_female" ][ "v0" ][ "idle" ]		= %ai_civ_f_idle_stand_00;
	level.scr_anim[ "civ_female" ][ "v0" ][ "walk" ]		= %ai_civ_f_walk_00;
	level.scr_anim[ "civ_female" ][ "v0" ][ "bump" ]		= %ai_civ_f_bump_00;
	level.scr_anim[ "civ_female" ][ "v0" ][ "turn_l" ]		= %ai_civ_f_turn_l_00;
	level.scr_anim[ "civ_female" ][ "v0" ][ "turn_r" ]		= %ai_civ_f_turn_r_00;

	level.scr_anim[ "civ_female" ][ "v1" ][ "idle" ]		= %ai_civ_f_idle_stand_01;
	level.scr_anim[ "civ_female" ][ "v1" ][ "walk" ]		= %ai_civ_f_walk_01;
	level.scr_anim[ "civ_female" ][ "v1" ][ "bump" ]		= %ai_civ_f_bump_01;
	level.scr_anim[ "civ_female" ][ "v1" ][ "turn_l" ]		= %ai_civ_f_turn_l_01;
	level.scr_anim[ "civ_female" ][ "v1" ][ "turn_r" ]		= %ai_civ_f_turn_r_01;

	level.scr_anim[ "civ_female" ][ "v2" ][ "idle" ]		= %ai_civ_f_idle_stand_02;
	level.scr_anim[ "civ_female" ][ "v2" ][ "walk" ]		= %ai_civ_f_walk_02;
	level.scr_anim[ "civ_female" ][ "v2" ][ "bump" ]		= %ai_civ_f_bump_02;
	level.scr_anim[ "civ_female" ][ "v2" ][ "turn_l" ]		= %ai_civ_f_turn_l_02;
	level.scr_anim[ "civ_female" ][ "v2" ][ "turn_r" ]		= %ai_civ_f_turn_r_02;

	level.scr_anim[ "civ_female" ][ "drink" ][ "idle" ]		= %ai_civ_f_idle_stand_drink_00;
	level.scr_anim[ "civ_female" ][ "drink" ][ "walk" ]		= %ai_civ_f_walk_drink_00;
	level.scr_anim[ "civ_female" ][ "drink" ][ "bump" ]		= %ai_civ_f_bump_drink_00;
	level.scr_anim[ "civ_female" ][ "drink" ][ "turn_l" ]	= %ai_civ_f_turn_l_drink_00;
	level.scr_anim[ "civ_female" ][ "drink" ][ "turn_r" ]	= %ai_civ_f_turn_r_drink_00;

	level.scr_anim[ "civ_female" ][ "phone" ][ "idle" ]		= %ai_civ_f_idle_stand_phone1_00;
	level.scr_anim[ "civ_female" ][ "phone" ][ "walk" ]		= %ai_civ_f_walk_phone1_00;
	level.scr_anim[ "civ_female" ][ "phone" ][ "bump" ]		= %ai_civ_f_bump_phone1_00;
	level.scr_anim[ "civ_female" ][ "phone" ][ "turn_l" ]	= %ai_civ_f_turn_l_phone1_00;
	level.scr_anim[ "civ_female" ][ "phone" ][ "turn_r" ]	= %ai_civ_f_turn_r_phone1_00;

	level.scr_anim[ "hero" ][ "briefcase" ][ "walk" ]		= %ai_civ_m_walk_briefcase_00;
	level.scr_anim[ "hero" ][ "briefcase" ][ "idle" ]		= %ai_civ_m_idle_briefcase_00;
		
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;

	level.scr_anim[ "generic" ][ "civ_idle_talk" ][0]		= %ch_karma_3_4_cividle_01;	// converse
	level.scr_anim[ "generic" ][ "civ_idle_talk" ][1]		= %ch_karma_3_4_cividle_02;	// arms crossed

	level.scr_anim[ "generic" ][ "civ_idle_alone" ][0]		= %ch_karma_3_4_cividle_02;	// arms crossed
	level.scr_anim[ "generic" ][ "civ_idle_alone" ][1]		= %ch_karma_3_4_cividle_03;	// phone

	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;


	level.scr_anim[ "club_pmc4" ][ "death" ] 				= %exposed_death_firing_02;
	level.scr_anim[ "club_pmc5" ][ "death" ] 				= %ai_death_shotgun_spinr;
	level.scr_anim[ "club_pmc6" ][ "death" ] 				= %ai_death_flyback;
	level.scr_anim[ "club_pmc7" ][ "death" ] 				= %stand_death_chest_spin;
	level.scr_anim[ "club_pmc8" ][ "death" ] 				= %exposed_death_falltoknees_02;
	level.scr_anim[ "club_pmc9" ][ "death" ] 				= %exposed_death_firing;
	level.scr_anim[ "salazar_target1" ][ "death" ]			= %ai_death_sniper_4;
	level.scr_anim[ "player_target1" ][ "death" ]			= %stand_death_chest_spin;

	//---------------------------------------------------------------
	// DRONE anims
	//
	
	// karma_anim is now happening before _load, so we need to define these drone anims
	level.drones = SpawnStruct();
	
	level.drones.anims[ "civ_walk" ][0]			= %fakeShooters::ai_civ_m_walk_00;
	level.drones.anims[ "civ_walk" ][1]			= %fakeShooters::ai_civ_m_walk_01;
	level.drones.anims[ "civ_walk" ][2]			= %fakeShooters::ai_civ_m_walk_03;

	// Dancing Girls
	level.drones.anims[ "dance_duo_girl1" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_duo_girl_a;
	level.drones.anims[ "dance_duo_girl2" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_duo_girl_b;
	level.drones.anims[ "dance_pole_girl1" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_pole_girl01;
	level.drones.anims[ "dance_pole_girl2" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_pole_girl02;
	level.drones.anims[ "dance_solo_girl1" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_solo;
	level.drones.anims[ "dance_wall_girl1" ] = %fakeShooters::ch_karma_6_2_shadow_dancers_wall;

	// hotel lobby area
	level.drones.anims[ "cafe_window_guy1" ]	= %fakeShooters::ch_karma_2_cafe_window_guy01;
	level.drones.anims[ "cafe_window_guy2" ]	= %fakeShooters::ch_karma_2_cafe_window_guy02;
	level.drones.anims[ "cafe_window_guy3" ]	= %fakeShooters::ch_karma_2_cafe_window_guy03;
	level.drones.anims[ "cafe_window_guy4" ]	= %fakeShooters::ch_karma_2_cafe_window_guy04;
	level.drones.anims[ "cafe_window_girl1" ]	= %fakeShooters::ch_karma_2_cafe_window_girl01;
	level.drones.anims[ "cafe_window_girl2" ]	= %fakeShooters::ch_karma_2_cafe_window_girl02;
	level.drones.anims[ "cafe_window_girl3" ]	= %fakeShooters::ch_karma_2_cafe_window_girl03;
	level.drones.anims[ "cafe_window_girl4" ]	= %fakeShooters::ch_karma_2_cafe_window_girl04;
	level.drones.anims[ "hotel_wait_female" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_female_idle_2;

	// Outside Waiting in line to enter the lobby
	level.drones.anims[ "outside_wait_guy1" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_male_idle_1;
	level.drones.anims[ "outside_wait_guy2" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_male_idle_2;
	level.drones.anims[ "outside_wait_guy3" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_male_idle_3;
	level.drones.anims[ "outside_wait_girl1" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_female_idle_1;
	level.drones.anims[ "outside_wait_girl2" ]	= %fakeShooters::ch_karma_6_2_outersolar_wait_female_idle_2;
	
	level.drones.anims[ "club_stand_girl1" ]	= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_female_01;	// left hand on hips
	level.drones.anims[ "club_stand_guy1" ]		= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_male_01;	// head nodding, swaying
	level.drones.anims[ "club_stand_guy2" ]		= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_male_02;	// 

	// Standing club idles, lightly dancing
	level.drones.anims[ "club_rail_girl1" ]		= %fakeShooters::ch_karma_6_1_club_rail_idles_female_01;	//
	level.drones.anims[ "club_rail_girl2" ]		= %fakeShooters::ch_karma_6_1_club_rail_idles_female_02;	//
	level.drones.anims[ "club_rail_guy2" ]		= %fakeShooters::ch_karma_6_1_club_rail_idles_male_02;		//
	level.drones.anims[ "club_rail_guy3" ]		= %fakeShooters::ch_karma_6_1_club_rail_idles_male_03;		//
	
	// Seated Bench
	level.drones.anims[ "bench_left_girl1" ]	= %fakeShooters::ch_karma_6_1_bench_left_civs_girl01;	// lean on elbow
	level.drones.anims[ "bench_left_girl2" ]	= %fakeShooters::ch_karma_6_1_bench_left_civs_girl02;	// lean forward
	level.drones.anims[ "bench_left_girl3" ]	= %fakeShooters::ch_karma_6_1_bench_left_civs_girl03;	// hands on tables
	level.drones.anims[ "bench_left_girl4" ]	= %fakeShooters::ch_karma_6_1_bench_left_civs_girl04;	// hands on tables
	level.drones.anims[ "bench_left_guy1" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy01;	// seated looking left
	level.drones.anims[ "bench_left_guy2" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy02;	// looking left
	level.drones.anims[ "bench_left_guy3" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy03;	// leaning back
	level.drones.anims[ "bench_left_guy4" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy04;	// leaning back
	level.drones.anims[ "bench_left_guy5" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy05;	// legs spread
	level.drones.anims[ "bench_left_guy6" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_guy06;	// leaning back

	// Seated Club
	level.drones.anims[ "club_seated_girl1" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_girl_01;	// looking side to side
	level.drones.anims[ "club_seated_girl2" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_girl_02;	// looking right
	level.drones.anims[ "club_seated_guy1" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_guy_01;	// slight look right
	level.drones.anims[ "club_seated_guy2" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_guy_02;	// one leg up
	level.drones.anims[ "club_seated_guy3" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_guy_03;	// looking right
	level.drones.anims[ "club_seated_guy4" ]	= %fakeShooters::ch_karma_6_2_ambient_club_seated_guy_04;	// one toe down

	level.drones.anims[ "club_bench_girl1" ]	= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_girl1;	// looks right
	level.drones.anims[ "club_bench_girl2" ]	= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_girl2;	// 
	level.drones.anims[ "club_bench_girl3" ]	= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_girl3;	// 
	level.drones.anims[ "club_bench_guy1" ]		= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_guy1;	// looks left and right
	level.drones.anims[ "club_bench_guy2" ]		= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_guy2;	// bored
	level.drones.anims[ "club_bench_guy3" ]		= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_guy3;	// long bored, looks left and right
	level.drones.anims[ "club_bench_guy4" ]		= %fakeShooters::ch_karma_6_2_ambientclub_bench_idle_guy4;	// cross-legged

	// Single dancers;  girl_dance4 and guy_dance5 go together as a couple, nodes should face each other and have a little distance
	level.drones.anims[ "girl_dance1" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_female01;
	level.drones.anims[ "girl_dance2" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_female02;
	level.drones.anims[ "girl_dance3" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_female03;
	level.drones.anims[ "girl_dance4" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_female04;	

	level.drones.anims[ "guy_dance1" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_male01;
	level.drones.anims[ "guy_dance2" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_male02;
	level.drones.anims[ "guy_dance3" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_male03;
	level.drones.anims[ "guy_dance4" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_male04;
	level.drones.anims[ "guy_dance5" ]			= %fakeShooters::ch_karma_6_3_clubsolar_clubdancer_male05;

	// Standing Gogo watchers
	level.drones.anims[ "club_gogo_couple_girl1" ]	= %fakeShooters::ch_karma_6_2_gogo_watcher_couple_girl_1;	// goes with guy_1
	level.drones.anims[ "club_gogo_couple_girl2" ]	= %fakeShooters::ch_karma_6_2_gogo_watcher_couple_girl_2;	// goes with guy_2
	level.drones.anims[ "club_gogo_couple_guy1" ]	= %fakeShooters::ch_karma_6_2_gogo_watcher_couple_guy_1;	// goes with girl_1
	level.drones.anims[ "club_gogo_couple_guy2" ]	= %fakeShooters::ch_karma_6_2_gogo_watcher_couple_guy_2;	// goes with girl_2
	level.drones.anims[ "club_gogo_solo_guy_1" ]	= %fakeShooters::ch_karma_6_2_gogo_watcher_solo_guy_1;		// 

	// Dancers
	level.drones.anims[ "shadow_dance1" ]		= %fakeShooters::ch_karma_6_2_shadow_dancer_01;
	level.drones.anims[ "shadow_dance2" ]		= %fakeShooters::ch_karma_6_2_shadow_dancer_02;
	level.drones.anims[ "shadow_dance3" ]		= %fakeShooters::ch_karma_6_2_shadow_dancer_03;

	// bouncer anim
	level.drones.anims[ "bouncer_club_a" ]		= %fakeShooters::ch_karma_6_2_bouncer_01;
	level.drones.anims[ "bouncer_club_b" ]		= %fakeShooters::ch_karma_6_2_bouncer_02;

	// people chat anim
	level.drones.anims[ "people_bar1" ]			= %fakeShooters::ch_karma_6_2_3peopleatbar_01;
	level.drones.anims[ "people_bar2" ]			= %fakeShooters::ch_karma_6_2_3peopleatbar_02;
	level.drones.anims[ "people_bar3" ]			= %fakeShooters::ch_karma_6_2_3peopleatbar_03;

	// bartender anim
	level.drones.anims[ "bartender" ]			= %fakeShooters::ch_karma_6_2_outer_solar_bartender;

	// Girl couple kissing	
	level.drones.anims[ "girl_kiss1" ]			= %fakeShooters::ch_karma_6_2_kissing_girls_01;
	level.drones.anims[ "girl_kiss2" ]			= %fakeShooters::ch_karma_6_2_kissing_girls_02;
	level.drones.anims[ "girl_kiss_b1" ]		= %fakeShooters::ch_karma_6_3_girls_kissing_girl1;
	level.drones.anims[ "girl_kiss_b2" ]		= %fakeShooters::ch_karma_6_3_girls_kissing_girl2;



	level.drones.anims[ "cower_crouch" ]		= %fakeShooters::ai_civ_m_idle_crouch_cower_01;
	level.drones.anims[ "cower_stand" ]			= %fakeShooters::ai_civ_m_idle_stand_cower_01;
	level.drones.anims[ "cower_on_side" ]		= %fakeShooters::ch_karma_6_3_cower_loop;
		
	//////////////////////////////////////////////////////
	/// OLD ANIMS TO REPLACE
	/// ///////////////////////////////////////////////////

	// still used by someone for now
	level.drones.anims[ "stand_drinker" ]	= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_female_01;
	level.drones.anims[ "girl_talk_b" ]			= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_female_01;
	level.drones.anims[ "guy_talk_b" ]			= %fakeShooters::ch_karma_6_1_club_ambient_generic_idles_male_01;	
	level.drones.anims[ "seated_b_girl1" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_girl01;	// seated, talks to the left
	level.drones.anims[ "seated_c_girl1" ]		= %fakeShooters::ch_karma_6_1_bench_left_civs_girl01;	// seated, talks right, beckons front
}


setup_drone_run_anims()
{
	level.drone_cycle_override = [];
	level.drone_cycle_override[0] = %fakeShooters::civilian_run_hunched_A;
	level.drone_cycle_override[1] = %fakeShooters::civilian_run_hunched_B;
	level.drone_cycle_override[2] = %fakeShooters::civilian_run_hunched_C;
	level.drone_cycle_override[3] = %fakeShooters::civilian_run_upright;
	level.drone_cycle_override[4] = %fakeShooters::civilian_run_hunched_dodge;
	level.drone_cycle_override[5] = %fakeShooters::civilian_run_hunched_flinch;
}

set_blend_in_out_times( time )
{
	self anim_set_blend_in_time( time );
	self anim_set_blend_out_time( time );
}

//
//
//
arrival_precache_anims()
{
	add_scene( "final_approach_stairs_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_prop_anim( "vtol_stairs", %animated_props::o_karma_1_1_final_approach_stairs, "veh_t6_vtol_karma_stairs" );
}


//
//	Squad flies in and lands at Al-Jinan
//
arrival_anims()
{
	// Final approach
	add_scene( "final_approach_plane", "intro_landing" );
	add_vehicle_anim( "player_vtol", %vehicles::v_karma_1_1_final_approach_vtol, !SCENE_DELETE );
	add_notetrack_flag("player_vtol", "hide_cabin", "hide_cabin");

	add_scene( "final_approach_squad", "player_vtol" );
	//add_player_anim( "player_body", %player::p_karma_1_1_final_approach, !SCENE_DELETE, PLAYER_1, "tag_origin", SCENE_DELTA, 0.5, 150, 150, 140, 120, SCENE_USE_TAG_ANGLES );
	add_player_anim( "player_body", %player::p_karma_1_1_final_approach, !SCENE_DELETE, PLAYER_1, "tag_origin", !SCENE_DELTA );
	add_actor_anim( "harper",		%ch_karma_1_1_final_approach_harper, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_1_1_final_approach_salazar, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag",		%animated_props::o_karma_1_1_final_approach_salazar,	undefined, !SCENE_DELETE, false, undefined, "tag_origin" );
	add_prop_anim( "harper_briefcase",	%animated_props::o_karma_1_1_final_approach_harper, 	undefined, !SCENE_DELETE, false, undefined, "tag_origin" );
	add_prop_anim( "player_briefcase",	%animated_props::o_karma_1_1_final_approach_briefcase,	"p6_spiderbot_case_anim", SCENE_DELETE, false, undefined, "tag_origin" );
	
	add_notetrack_custom_function( "player_body", "vtol_dof_1",	maps\createart\karma_art::vtol_dof_1 );
	add_notetrack_custom_function( "player_body", "vtol_dof_2",	maps\createart\karma_art::vtol_dof_2 );
	add_notetrack_custom_function( "player_body", "vtol_dof_3",	maps\createart\karma_art::vtol_dof_3 );
	
	add_scene( "final_approach_pilots", "player_vtol" );
	add_actor_model_anim( "pilot",			%ch_karma_1_1_final_approach_leftpilot, undefined, !SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "copilot",		%ch_karma_1_1_final_approach_rightpilot, undefined, !SCENE_DELETE, "tag_origin" );

	// Landed scenes
	add_scene( "final_approach_plane_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC );
	add_vehicle_anim( "player_vtol", %vehicles::v_karma_1_1_final_approach_landing_idle_vtol, !SCENE_DELETE );
	add_notetrack_flag("player_vtol", "hide_cockpit", "hide_cockpit");
	add_notetrack_custom_function( "player_vtol", "vtol_door_audio",	maps\karma_amb::vtol_doors_open );

	add_scene( "landing_player", "player_vtol" );
	add_player_anim( "player_body",	%player::p_karma_1_1_final_approach_landing, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA );
	add_prop_anim( "glasses", %animated_props::o_karma_2_1_intr_walkin_sunglasses, undefined, true, false, undefined, "tag_origin" );
	add_notetrack_flag("player_body", "glasses_tint", "glasses_tint");
	add_notetrack_flag("player_body", "tint_gone", "tint_gone");
	add_notetrack_flag("player_body", "headsupdisplay", "headsupdisplay");
	add_notetrack_flag("player_body", "start_workers", "start_workers");
	add_notetrack_flag("player_body", "glasses_on", "glasses_on");
	add_notetrack_flag("player_body", "glasses_off", "glasses_off");
	add_notetrack_flag("player_body", "sndStartPAVox", "sndStartPAVox");
	
	add_notetrack_custom_function( "player_body", "vtol_dof_4",	maps\createart\karma_art::vtol_dof_4 );
	
	add_scene( "landing_pilots", "player_vtol" );
	add_actor_model_anim( "pilot",			%ch_karma_1_1_final_approach_landing_leftpilot, undefined, !SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "copilot",		%ch_karma_1_1_final_approach_landing_rightpilot, undefined, !SCENE_DELETE, "tag_origin" );

	add_scene( "landing_pilots_idle", "player_vtol", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "pilot",			%ch_karma_1_1_final_approach_landing_idle_leftpilot, undefined, SCENE_DELETE, "tag_origin" );
	add_actor_model_anim( "copilot",		%ch_karma_1_1_final_approach_landing_idle_rightpilot, undefined, SCENE_DELETE, "tag_origin" );

	add_scene( "landing_squad", "intro_landing" );
	add_actor_anim( "harper",		%ch_karma_1_1_final_approach_landing_harper, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_1_1_final_approach_landing_salazar, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_1_1_final_approach_landing_salazar );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_1_1_final_approach_landing_harper );
	
	add_scene( "landing_squad_alt", "intro_landing" );
	add_actor_anim( "harper",		%ch_karma_1_1_final_approach_landing_harper_alt, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_1_1_final_approach_landing_salazar_alt, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_1_1_final_approach_landing_salazar );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_1_1_final_approach_landing_harper );


	// Ambient workers
	add_scene( "worker_01_intro", "intro_landing" );
	add_actor_model_anim( "worker_01", %ch_karma_2_1_tarmac_worker_01, undefined, undefined, undefined, undefined, "intro_workers" );
	//add_actor_model_anim( "worker_02", %ch_karma_2_1_tarmac_worker_02, undefined, undefined, undefined, undefined, "intro_workers");
	//add_actor_model_anim( "worker_03", %ch_karma_2_1_tarmac_worker_03, undefined, undefined, undefined, undefined, "intro_workers");
	add_actor_model_anim( "worker_07", %ch_karma_2_1_tarmac_worker_07, undefined, undefined, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_08", %ch_karma_2_1_tarmac_worker_08, undefined, undefined, undefined, undefined, "intro_workers");
	
	add_scene( "worker_walking_intro", "intro_landing" );
	add_actor_model_anim( "worker_02", %ch_karma_2_1_tarmac_worker_02, undefined, undefined, undefined, undefined, "intro_workers");
	add_actor_model_anim( "worker_03", %ch_karma_2_1_tarmac_worker_03, undefined, undefined, undefined, undefined, "intro_workers");

	add_scene( "worker_forklift_intro", "intro_landing" );
	add_actor_model_anim( "worker_04", %ch_karma_2_1_tarmac_worker_04, undefined, undefined, undefined, undefined, "intro_workers" );
	add_prop_anim( "checkin_forklift", %animated_props::o_karma_2_1_tarmac_worker_forklift );
	add_prop_anim( "checkin_metalstorm", %animated_props::o_karma_2_1_tarmac_worker_metalstorm );
	
	add_scene( "worker_metalstorm_intro", "intro_landing" );
	add_actor_model_anim( "worker_05", %ch_karma_2_1_tarmac_worker_05, undefined, undefined, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_06", %ch_karma_2_1_tarmac_worker_06, undefined, undefined, undefined, undefined, "intro_workers" );
	
	add_scene( "worker_01_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "worker_01", %ch_karma_2_1_tarmac_worker_idle_01, undefined, true, undefined, undefined, "intro_workers" );
	//add_actor_model_anim( "worker_02", %ch_karma_2_1_tarmac_worker_idle_02, undefined, true, undefined, undefined, "intro_workers" );
	//add_actor_model_anim( "worker_03", %ch_karma_2_1_tarmac_worker_03_idle , undefined, true, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_07", %ch_karma_2_1_tarmac_worker_07_idle, undefined, true, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_08", %ch_karma_2_1_tarmac_worker_08_idle, undefined, true, undefined, undefined, "intro_workers" );
	
	add_scene( "worker_walking_intro_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "worker_02", %ch_karma_2_1_tarmac_worker_idle_02, undefined, true, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_03", %ch_karma_2_1_tarmac_worker_03_idle , undefined, true, undefined, undefined, "intro_workers" );

	add_scene( "worker_forklift_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "worker_04", %ch_karma_2_1_tarmac_worker_04_idle, undefined, true, undefined, undefined, "intro_workers" );
	add_prop_anim( "checkin_forklift", %animated_props::o_karma_2_1_tarmac_worker_forklift_idle,  undefined, SCENE_DELETE );
	add_prop_anim( "checkin_metalstorm", %animated_props::o_karma_2_1_tarmac_worker_metalstorm_idle,  undefined, SCENE_DELETE );

	add_scene( "worker_metalstorm_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "worker_05", %ch_karma_2_1_tarmac_worker_05_idle, undefined, true, undefined, undefined, "intro_workers" );
	add_actor_model_anim( "worker_06", %ch_karma_2_1_tarmac_worker_06_idle, undefined, true, undefined, undefined, "intro_workers" );
	
	//new ambiant added by Pokee
	add_scene( "intro_workers", "intro_workers", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers", %ch_karma_2_1_tarmac_worker_idle_02, undefined, true, undefined, undefined, "intro_workers");
	
	add_scene( "intro_workers2", "intro_workers2", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers2", %ch_karma_2_1_blockers_picking_up_items_guy_02, undefined, true, undefined, undefined, "intro_workers");
	
	add_scene( "intro_workers3", "intro_workers3", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers3", %ch_karma_2_cafe_window_guy03, undefined, true, undefined, undefined, "intro_workers");
	
	add_scene( "intro_workers4", "intro_workers4", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers4", %ch_karma_2_1_tarmac_worker_08_idle, undefined, true, undefined, undefined, "intro_workers");
	
	add_scene( "intro_workers5", "intro_workers5", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers5", %ch_karma_2_1_blockers_picking_up_items_guy_01, undefined, true, undefined, undefined, "intro_workers");
	
//	add_scene( "intro_workers6", "intro_workers6", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
//	add_actor_model_anim( "intro_workers6", %ch_karma_3_4_cividle_03, undefined, true, undefined, undefined, "intro_workers");
//	
//	add_scene( "intro_workers7", "intro_workers7", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
//	add_actor_model_anim( "intro_workers7", %ch_karma_6_2_3peopleatbar_01, undefined, true, undefined, undefined, "intro_workers");
//	
	add_scene( "intro_workers8", "intro_workers8", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "intro_workers8", %ch_karma_2_cafe_window_guy04, undefined, true, undefined, undefined, "intro_workers");
	
	// security scanner animation
	add_scene( "security_left", "intro_landing" );
	add_actor_anim( "security_01", 			%ch_karma_2_2_security_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "security_left_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_01", 			%ch_karma_2_2_security_01_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	
	add_scene( "security_left_alert", "intro_landing" );
	add_actor_anim( "security_01", 			%ch_karma_2_2_security_01_alert, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_notetrack_flag("security_01", "gate_alert", "gate_alert");
	add_notetrack_flag("security_01", "gate_open", "gate_open");
	
	add_scene( "security_left_alert_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_01", 			%ch_karma_2_2_security_01_alert_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "security_middle_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_02", 			%ch_karma_2_2_security_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_prop_anim( "scanner_metalstorm", %animated_props::o_karma_2_2_security_metalstorm );
	
	add_scene( "security_right_idle", "intro_landing1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_03", 			%ch_karma_2_2_security_02_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_notetrack_custom_function("security_03", 		"in_scanner", maps\karma_checkin::inside_scanner );

	add_scene( "security_middle_alert", "intro_landing" );
	add_actor_anim( "security_02", 			%ch_karma_2_2_security_03_alert, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_prop_anim( "scanner_metalstorm", %animated_props::o_karma_2_2_security_03_alert_metalstorm );
	
	add_scene( "security_middle_alert_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_02", 			%ch_karma_2_2_security_03_alert_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_prop_anim( "scanner_metalstorm", %animated_props::o_karma_2_2_security_03_alert_idle_metalstorm, undefined, SCENE_DELETE );
	
	add_scene( "securityR_and_workers_alert", "intro_landing1" );
	add_actor_anim( "security_03", 			%ch_karma_2_2_security_02_alert, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_actor_anim( "explosives_worker1",	%ch_karma_2_3_blockers_alert_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2",	%ch_karma_2_3_blockers_alert_02, SCENE_HIDE_WEAPON );
	add_notetrack_custom_function("explosives_worker1", "in_scanner", maps\karma_checkin::inside_scanner );
	add_notetrack_custom_function("explosives_worker2", "in_scanner", maps\karma_checkin::inside_scanner );
	add_notetrack_flag("explosives_worker1", "alert", "alert");
	
	add_scene( "securityR_and_workers_alert_idle", "intro_landing1", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "security_03", 			%ch_karma_2_2_security_02_alert_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
	add_actor_anim( "explosives_worker1",	%ch_karma_2_3_left_worker_idle, SCENE_HIDE_WEAPON );
	add_actor_anim( "explosives_worker2",	%ch_karma_2_3_right_worker_idle, SCENE_HIDE_WEAPON );


	precache_assets( true );
}


//
// 	Checkin Scenes - heading through security, Total Recall
//	Only ones that require an asset to be precaced
checkin_precache_anims()
{
	add_scene( "explosives_workers_intro", "intro_landing" );
	add_actor_anim( "intro_explosives_worker1", 	%ch_karma_2_1_blockers_enter_guy_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "intro_explosives_worker2", 	%ch_karma_2_1_blockers_enter_guy_02, SCENE_HIDE_WEAPON );
	add_prop_anim(  "worker_toolbox", 		%animated_props::o_karma_2_1_blockers_enter_toolbox, "test_p_anim_karma_toolbox", !SCENE_DELETE );

	add_scene( "explosives_workers_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "intro_explosives_worker1", 	%ch_karma_2_1_blockers_picking_up_items_guy_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "intro_explosives_worker2", 	%ch_karma_2_1_blockers_picking_up_items_guy_02, SCENE_HIDE_WEAPON );
	add_prop_anim(  "worker_toolbox", 		%animated_props::o_karma_2_1_blockers_picking_up_items_toolbox, "test_p_anim_karma_toolbox", !SCENE_DELETE );
	add_prop_anim(  "worker_hammer", 		%animated_props::o_karma_2_1_blockers_picking_up_items_hammer, "test_p_anim_karma_hammer", SCENE_DELETE );
	add_prop_anim(  "worker_wrench", 		%animated_props::o_karma_2_1_blockers_picking_up_items_wrench, "test_p_anim_karma_wrench", SCENE_DELETE );

	add_scene( "tower_elevator_close", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim(  "tower_elevator", 		%animated_props::o_karma_3_elevator_1_door_close );
	
	add_scene( "tower_elevator_open", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim(  "tower_elevator", 		%animated_props::o_karma_3_elevator_1_door_open );
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
	add_actor_anim( "salazar_pistol",		%ch_karma_2_1_intr_squad_01, SCENE_HIDE_WEAPON );
	add_actor_anim( "harper",		%ch_karma_2_1_intr_squad_04, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_2_1_intr_squad_01 );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_2_1_intr_squad_04 );
	add_notetrack_flag("harper", "left_alert_trigger", "left_alert_trigger");
	
	// scanner securities and matal storm.
	add_scene( "team_intro_idle", "intro_landing", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_2_1_idle_scanner_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_2_1_idle_scanner_01, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_2_1_idle_scanner_01 );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_2_1_idle_scanner_04 );
	

	//-------------------------------------------------------------------------------------------------
	// Section 2 Walk & Idle	
	//-------------------------------------------------------------------------------------------------	
	add_scene( "section_walk_2_1", "tower_interior" );
	add_actor_anim( "harper",		%ch_karma_2_1_intr_squad_pt2_04, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_2_1_intr_squad_pt2_01, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_2_1_intr_squad_pt2_01 );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_2_1_intr_squad_pt2_04 );
	//add_notetrack_flag("salazar_pistol", "pa_welcome_salazar_mas_0", "pa_welcome_salazar_mas_0");
	//add_notetrack_flag("salazar_pistol", "thats_alright_sw_008", "thats_alright_sw_008");
	//add_notetrack_flag("salazar_pistol", "this_place_is_stil_001", "this_place_is_stil_001");
	//add_notetrack_flag("salazar_pistol", "pa_visit_our_exclusive_0", "pa_visit_our_exclusive_0");
	//add_notetrack_flag("salazar_pistol", "pa_or_maybe_just_take_t_0", "pa_or_maybe_just_take_t_0");
	add_notetrack_flag( "salazar_pistol", "sndPlayPAWelcome", "sndPlayPAWelcome" );
	
	//player railing animation
	add_scene( "player_railing", "tower_interior" );
	add_player_anim( "player_body",	%player::p_karma_2_3_grab_railing, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA );
	
	
	// Hotel front lobby Area and Receptionists
	add_scene( "receptionist_left", "tower_interior" );
	add_actor_model_anim( "receptionist_a", %ch_karma_2_5_checkin_receptionist, undefined, undefined, undefined, undefined, "receptionist");
		
	add_scene( "receptionist_left_idle", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "receptionist_a", %ch_karma_2_5_checkin_receptionist_idle_a, undefined, true, undefined, undefined, "receptionist");
	
	add_scene( "hotel_security_front", "hotel_security_front", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "hotel_security_front", %ch_karma_2_3_security_checks_blockers_02_idle, undefined, true, undefined, undefined, "checkin_worker_new");
	
	add_scene( "hotel_reception_civs", "hotel_reception_civs",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "hotel_reception_civs1",	%ch_karma_6_1_coatcheck_girl01,	undefined, SCENE_DELETE, undefined, undefined, "hotel_female_rich1" );
	add_actor_model_anim( "hotel_reception_civs2",	%ch_karma_6_1_coatcheck_guy02,	undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich1" );
	add_actor_model_anim( "hotel_reception_civs3",	%ch_karma_6_1_coatcheck_guy03,	undefined, SCENE_DELETE, undefined, undefined, "receptionist" );
	
	add_scene( "hotel_ladywalking", "tower_interior");
	add_actor_anim( "hotel_ladywalking", %ch_karma_2_1_ladywalking,  SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "hotel_female_dress" );
	
	add_scene( "hotel_ladywalking_idle", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_anim( "hotel_ladywalking", %ch_karma_2_1_ladywalking_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, undefined, undefined, "hotel_female_dress" );
	
	add_scene( "hotel_goto_railing", "tower_interior");
	add_actor_anim( "hotel_goto_railing", %ch_karma_3_1_civ_goto_railing,  SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "hotel_male_rich2" );
	
	add_scene( "hotel_goto_railing_idle", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_anim( "hotel_goto_railing", %ch_karma_3_1_civ_goto_railing_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, undefined, undefined, "hotel_male_rich2" );
	
	// Hotel Elevator lobby Area
	add_scene( "elevator_civs", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "cafe_ai1", %ch_karma_2_cafe_idles_guy01, 				undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich3");
	add_actor_model_anim( "cafe_ai2", %ch_karma_2_cafe_idles_girl01, 				undefined, SCENE_DELETE, undefined, undefined, "hotel_female_rich3");
	add_actor_model_anim( "cafe_ai3", %ch_karma_2_cafe_idles_guy02, 				undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich4");
	add_actor_model_anim( "cafe_ai4", %ch_karma_2_cafe_idles_girl02, 				undefined, SCENE_DELETE, undefined, undefined, "hotel_female_rich4");
	add_actor_model_anim( "forward_ai1", %ch_karma_3_4_civs_forward_railing_guy01,	undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich5");
	add_actor_model_anim( "forward_ai2", %ch_karma_3_4_civs_forward_railing_guy02,	undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich6");
	//add_actor_model_anim( "forward_rail_ai1", %ch_karma_3_4_civs_lean_railing_guy01, undefined, true, undefined, undefined, "hotel_male");
	add_actor_model_anim( "forward_rail_ai2", %ch_karma_3_4_civs_lean_railing_guy02, undefined, SCENE_DELETE, undefined, undefined, "hotel_female_rich5");
		
	add_scene( "lobby_guy8", "lobby_guy8", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "lobby_guy8", %ch_karma_2_3_security_checks_blockers_02_idle, undefined, SCENE_DELETE, undefined, undefined, "checkin_worker_new");
	
	add_scene( "lobby_guy14", "lobby_guy14", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "lobby_guy14", %ch_karma_2_cafe_idles_guy01, undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich3");
	
	add_scene( "lobby_guy15", "lobby_guy15", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "lobby_guy15", %ch_karma_3_4_civs_lean_railing_guy01, undefined, SCENE_DELETE, undefined, undefined, "hotel_male_rich1");
	//add_actor_model_anim( "lobby_guy15_1", %ch_karma_3_4_civs_lean_railing_guy02, undefined, true, undefined, undefined, "hotel_male");
	
	add_scene( "hotel_goto_girl_idle1", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_anim( "hotel_goto_girl", %ch_karma_3_1_civ_goto_railing_girl_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "hotel_female_rich1" );
	
	add_scene( "hotel_goto_girl_walk", "tower_interior");
	add_actor_anim( "hotel_goto_girl", %ch_karma_3_1_civ_goto_railing_girl, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "hotel_female_rich1" );
	
	add_scene( "hotel_goto_girl_idle2", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP);
	add_actor_anim( "hotel_goto_girl", %ch_karma_3_1_civ_goto_railing_girl_afteridle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, undefined, undefined, "hotel_female_rich1" );
	

	//-------------------------------------------------------------------------------------------------
	// Section 3 Walk & Idle	
	//-------------------------------------------------------------------------------------------------	
	add_scene( "tower_lift_wait", "tower_interior", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_wait1_harp, SCENE_HIDE_WEAPON );	
	add_actor_anim( "salazar_pistol",		%ch_karma_3_1_going_down_wait1_sala, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_3_1_going_down_wait1_sala );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_3_1_going_down_wait1_harp );
	
	// Elevator arrives, Harper and Salazar enter elevator
	add_scene( "tower_lift_enter", "align_player" );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_enter_harp, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_3_1_going_down_enter_sala, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_3_1_going_down_enter_sala );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_3_1_going_down_enter_harp );

	// Wait for player to enter
	add_scene( "tower_lift_enter_wait", "align_player", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_wait2_harp, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_3_1_going_down_wait2_sala, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_3_1_going_down_wait2_sala );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_3_1_going_down_wait2_harp );

	// Player enters
	add_scene( "tower_lift_workers_run", "align_player" );
	add_actor_anim( "harper",		%ch_karma_3_1_going_down_harp, SCENE_HIDE_WEAPON );
	add_actor_anim( "salazar_pistol",		%ch_karma_3_1_going_down_sala, SCENE_HIDE_WEAPON );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_3_1_going_down_sala );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_3_1_going_down_harp );
	
	add_scene( "tower_lift_harper_exit", "align_player" );
	add_actor_anim( "harper", %generic_human::ch_karma_3_4_eleveator_exit_harper, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_prop_anim( "harper_briefcase", %animated_props::o_karma_3_4_eleveator_exit_harper );
	
	add_scene( "tower_lift_karma_exit", "align_tbone" );
	add_actor_anim( "karma", %generic_human::ch_karma_3_4_eleveator_exit_karma, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "tower_lift_salazar_exit", "align_player" );
	add_actor_anim( "salazar_pistol", %generic_human::ch_karma_3_4_eleveator_exit_salazar, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_prop_anim( "duffle_bag", %animated_props::o_karma_3_4_eleveator_exit_salazar );
	add_notetrack_custom_function( "salazar_pistol", "pistol_appear", maps\karma_dropdown::salazar_unholster_sidearm );
	add_notetrack_flag( "salazar_pistol", "elevator_stop", "dropdown_elevator_open" );
	add_notetrack_flag( "salazar_pistol", "elevator_close", "harper_exit_close" );

	precache_assets( true );
}
	

//
// 	Exit elevator 
//	Only ones that require an asset to be precached, like anims with spawned props
dropdown_precache_anims()
{	
}


//
// 	Exit tower elevator and make way to spiderbot area
dropdown_anims()
{
//	add_scene( "lobby_elevator_close", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
//	add_prop_anim(  "lobby_elevator", 		%animated_props::o_karma_3_elevator_1_door_close );
//	
//	add_scene( "lobby_elevator_open", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
//	add_prop_anim(  "lobby_elevator", 		%animated_props::o_karma_3_elevator_1_door_open );
//
//	// Exit elevator
//	add_scene( "tower_lift_exit_squad", "align_lobby_lift_left"  );
//	add_actor_anim( "harper",		%ch_karma_3_4_elevator_exit_harp, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
//	add_actor_anim( "salazar",		%ch_karma_3_4_elevator_exit_sala, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
//
//	add_scene( "tower_lift_exit", "align_lobby_lift_left"  );
//	add_actor_anim( "karma",		%ch_karma_3_4_elevator_exit_karm );
//	add_actor_anim( "civilian1",	%ch_karma_3_4_elevator_exit_civ1 );
//	
//	// Wait for player to leave
//	add_scene( "tower_lift_exit_wait", "align_lobby_lift_left", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
//	add_actor_anim( "karma",		%ch_karma_3_4_elevator_exit_wait_karm, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
//	add_actor_anim( "civilian1",	%ch_karma_3_4_elevator_exit_wait_civ1, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
//
//	// Player climbs up elevator hatch
//	add_scene( "player_climb_hatch", "align_rappel_cable" );
//	add_player_anim( "player_body",				%player::p_karma_5_2_elevator_player_hatch01, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
//	// Teammates hang out waiting for you to rappel
//	add_scene( "team_hatch_idle", "align_rappel_cable", !SCENE_REACH, undefined, SCENE_LOOP );
//	add_actor_anim( "harper",					%ch_karma_5_2_elevator_harper_hatch01_idl, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
//	add_actor_anim( "salazar",					%ch_karma_5_2_elevator_salazar_hatch01_idl, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );
//	// Player rappeling down the elevator shaft.
//	add_scene( "player_rappel", "align_rappel_cable" );
//	add_player_anim( "player_body", 			%player::p_karma_5_2_elevator_player_hatch02, !SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
//	add_actor_anim( "salazar",					%ch_karma_5_2_elevator_salazar_hatch02_idl, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
//
//	add_scene( "dropdown_entry_elevator_open", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
//	add_prop_anim(  "atrium_to_crc_entry_elevator",	%animated_props::o_karma_3_elevator_2_door_1_open );
//
//	add_scene( "dropdown_exit_elevator_open", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
//	add_prop_anim(  "atrium_to_crc_exit_elevator",	%animated_props::o_karma_3_elevator_2_door_2_open );

	// These 4 scenes all start at once, but need to be separate due to different end times.
	//	They need to be separate because the enemies start shooting at different times.
	// Player opens door
//	add_scene( "player_pry_open", "align_dropdown" );
//	add_player_anim( "player_body", 			%player::p_karma_5_2_elevator_encounter_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN  );
//	add_notetrack_custom_function("player_body", "door_open", maps\karma_dropdown::pry_open_doors );
	// Enemies surprise player
	add_scene( "elevator_encounter1", "align_dropdown" );
	add_actor_anim( "dropdown_guard1",			%ch_karma_5_2_elevator_encounter_terrorist_01 );

	add_scene( "elevator_encounter2", "align_dropdown" );
	add_actor_anim( "dropdown_guard2",			%ch_karma_5_2_elevator_encounter_terrorist_02 );

//	add_scene( "elevator_encounter3", "align_dropdown" );
//	add_actor_anim( "dropdown_hacker",			%ch_karma_5_2_elevator_encounter_hacker );

	// salazar waits outside the spiderbot setup room
	add_scene( "salazar_wait_outside_spiderbot", "align_spiderbot_gear", SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar_pistol",		%ch_karma_3_4_hotel_room_wait_outside_harper );
	
	// salazar waits outside the spiderbot setup room
	add_scene( "salazar_go_inside_spiderbot", "align_spiderbot_gear", SCENE_REACH );
	add_actor_anim( "salazar_pistol",		%ch_karma_4_1_hotel_room_enter_harper );

	// salazar waits for us to get in place
	add_scene( "salazar_wait_vent_spiderbot", "align_spiderbot_gear", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar_pistol",		%ch_karma_4_1_hotel_room_wait_idle_harper );
	
	add_scene( "salazar_wait", "align_spiderbot_gear", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar_pistol", 		%ch_karma_4_1_hotel_room_set_bot_harper_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

//	// Suspicious Dudes
//	add_scene( "scene_suspicious_guys", "atrium_entrance" );
//	add_actor_anim( "suspicious_guy_1",			%ch_karma_4_2_suspicious_guards_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
//	add_actor_anim( "suspicious_guy_2",			%ch_karma_4_2_suspicious_guards_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
//	add_actor_anim( "suspicious_guy_3",			%ch_karma_4_2_suspicious_guards_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
//	add_actor_anim( "suspicious_guys_camera", 	%ch_karma_4_2_suspicious_guards_camera, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	precache_assets( true );
}


//
//
spiderbot_precache_anims()
{
	// Spiderbot setup	
	add_scene( "set_spiderbot", "align_spiderbot_gear" );
	add_actor_anim( "salazar_pistol", 		%ch_karma_4_1_hotel_room_set_bot_harper, SCENE_HIDE_WEAPON );
	add_player_anim( "player_body", %player::p_karma_4_1_hotel_room_set_bot, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	add_prop_anim( "briefcase", 	%animated_props::o_karma_4_1_hotel_room_set_bot_briefcase, "p6_spiderbot_case_anim" );
	add_prop_anim( "pad", 			%animated_props::o_karma_4_1_hotel_room_set_bot_pad, "p6_anim_spiderbot_pad" );
	add_prop_anim( "hotel_room_vent", %animated_props::o_karma_4_1_hotel_room_set_bot_vent );
	add_prop_anim( "anim_bot",		%animated_props::o_karma_4_1_hotel_room_set_bot_spiderbot, "veh_t6_spider_large", true );
}


//
//	Spiderbot 
//		Hotel Room spiderbot prep
spiderbot_anims()
{
	// Terrorists planting bombs
	add_scene( "planting_bombs", "align_bombplant", !SCENE_REACH );
	add_actor_anim( "bomb_planter1",		%ch_karma_4_2_hallway_bombs_terrorist_01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "bomb_planter2",		%ch_karma_4_2_hallway_bombs_terrorist_02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "bomb_planter3",		%ch_karma_4_2_hallway_bombs_terrorist_03, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "scene_suspicious_guys_leaving", "atrium_entrance" );
	add_actor_anim( "suspicious_guy_1",			%ch_karma_4_6_suspicious_guards_part2_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_2",			%ch_karma_4_6_suspicious_guards_part2_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guy_3",			%ch_karma_4_6_suspicious_guards_part2_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "suspicious_guys_camera", 	%ch_karma_4_6_suspicious_guards_part2_camera, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// IT Manager
	add_scene( "it_mgr_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_crc_manager_loop_guy1, SCENE_HIDE_WEAPON );

	add_scene( "it_mgr_vent_open", "align_computer" );
	add_vehicle_anim( "spiderbot",	%vehicles::ch_karma_4_8_spiderbotdrop_spiderbot, !SCENE_DELETE );
	add_prop_anim( "crc_vent", 		%animated_props::o_karma_4_8_spiderbotdrop_vent, undefined, !SCENE_DELETE );

	add_scene( "it_mgr_surprise", "align_computer" );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_crc_manager_guy1, SCENE_HIDE_WEAPON );
	add_vehicle_anim( "spiderbot",	%vehicles::ch_karma_4_8_crc_manager_spiderbot, !SCENE_DELETE );
	add_notetrack_custom_function("spiderbot", "start_slow", maps\karma_spiderbot::spiderbot_slow_mo );	
	
	add_scene( "it_mgr_twitch_idle", undefined, !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP, !SCENE_ALIGN );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_twitchidle_guy01, SCENE_HIDE_WEAPON );

	add_scene( "eye_scan", "align_computer" );
	add_actor_anim( "it_mgr",		%ch_karma_4_8_it_manager_eyescan_guy01, SCENE_HIDE_WEAPON, !SCENE_DELETE );
	add_vehicle_anim( "spiderbot",	%vehicles::p_karma_4_8_it_manager_eyescan_spiderbot, !SCENE_DELETE );
	add_notetrack_custom_function("spiderbot", "start_scan", maps\karma_spiderbot::play_eye_scan_fx );	
	
	add_scene( "spiderbot_smash", "align_computer" );
	add_actor_anim( "it_mgr",				%ch_karma_4_8_spiderbot_smash_guy01, !SCENE_DELETE );
	add_vehicle_anim( "spiderbot",			%vehicles::p_karma_4_8_spiderbot_smash_spiderbot, !SCENE_DELETE );
	add_actor_anim( "spiderbot_smasher",	%ch_karma_4_8_spiderbot_smash_terrorist, SCENE_DELETE );
	add_notetrack_custom_function("spiderbot_smasher", "stomp", maps\karma_spiderbot::spiderbot_squashed );	

	////////////////////////////////////////////
	// 	S P I D E R   S T O M P
	// LDS: We need to build a data structure to store all of our animations
	//			These should consist of the following:
	//			- Two Delta animations that govern the front/back component of the stomp
	//			- Three Additive animations that govern the left/right component of the 
	//				stomp and stomp return
	//			- Two Delta animations that govern the front/back component of the stomp
	//				return
	//			- Ten Delta animations that handle turning the actor to face the stomp 
	//				position
	// NOTE: We still need a 180 turn for the right.
	level.stomp_anims = [];
	level.stomp_anims["idle"] = %ai_spider_stomper_idle;
	// stomps
	level.stomp_anims["left"]["stomp_f"] 		= %ai_spider_stomper_stomp_f_leftfoot;
	level.stomp_anims["left"]["stomp_b"] 		= %ai_spider_stomper_stomp_b_leftfoot;
	level.stomp_anims["left"]["stomp_c"] 		= %ai_spider_stomper_stomp_c_add_leftfoot;
	level.stomp_anims["left"]["stomp_lr"] 		= %ai_spider_stomper_stomp_l_add_leftfoot;
	level.stomp_anims["right"]["stomp_f"] 		= %ai_spider_stomper_stomp_f_rightfoot;
	level.stomp_anims["right"]["stomp_b"] 		= %ai_spider_stomper_stomp_b_rightfoot;
	level.stomp_anims["right"]["stomp_c"] 		= %ai_spider_stomper_stomp_c_add_rightfoot;
	level.stomp_anims["right"]["stomp_lr"] 		= %ai_spider_stomper_stomp_r_add_rightfoot;

	// stomp returns
	level.stomp_anims["left"]["return_f"] 		= %ai_spider_stomper_stomp_f_2_idle_leftfoot;
	level.stomp_anims["left"]["return_b"] 		= %ai_spider_stomper_stomp_b_2_idle_leftfoot;
	level.stomp_anims["right"]["return_f"] 		= %ai_spider_stomper_stomp_f_2_idle_rightfoot;
	level.stomp_anims["right"]["return_b"] 		= %ai_spider_stomper_stomp_b_2_idle_rightfoot;

	// turns
	level.stomp_anims["left"]["turn_small"] 	= %ai_spider_stomper_smallturn_l;
	level.stomp_anims["right"]["turn_small"] 	= %ai_spider_stomper_smallturn_r;
	level.stomp_anims["left"]["turn_45"] 		= %ai_spider_stomper_turn_45l;
	level.stomp_anims["right"]["turn_45"] 		= %ai_spider_stomper_turn_45r;
	level.stomp_anims["left"]["turn_90"] 		= %ai_spider_stomper_turn_90l;
	level.stomp_anims["right"]["turn_90"] 		= %ai_spider_stomper_turn_90r;
	level.stomp_anims["left"]["turn_135"] 		= %ai_spider_stomper_turn_135l;
	level.stomp_anims["right"]["turn_135"] 		= %ai_spider_stomper_turn_135r;
	level.stomp_anims["left"]["turn_180"] 		= %ai_spider_stomper_turn_180l;
	level.stomp_anims["right"]["turn_180"]		= %ai_spider_stomper_turn_180l;

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
	add_prop_anim( "briefcase", 		%animated_props::o_karma_4_1_hotel_room_exit_briefcase, "p6_spiderbot_case_anim", SCENE_DELETE );
	add_prop_anim( "pad", 				%animated_props::o_karma_4_1_hotel_room_exit_pad, "p6_anim_spiderbot_pad", SCENE_DELETE );	
	add_prop_anim( "hotel_room_vent", 	%animated_props::o_karma_4_1_hotel_room_exit_vent );
	add_actor_anim( "salazar", 			%ch_karma_4_1_hotel_room_exit_harper, SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
}

construction_anims()
{
	// Player opening CRC door using eye scan.
	add_scene( "scene_p_eye_scan", "align_crc_door" );
	add_player_anim( "player_body",			%player::p_karma_5_3_crc_enter_scan_player );
	add_actor_anim( "salazar",				%ch_karma_5_3_crc_enter_scan_sala );
		
	add_scene( "scene_p_eye_scan_breach", "align_crc_door" );
	add_actor_anim( "salazar",				%generic_human::ch_karma_5_1_breach_sala );
	add_player_anim( "player_body", %player::p_karma_5_1_breach_player, true );
	add_prop_anim( "crc_flashbang", %animated_props::o_karma_5_3_crc_enter_breach_flashbang, "t6_wpn_grenade_flash_prop_view" );
	add_notetrack_flag( "salazar", "flashbang_explode", "crc_flash_out" );
	
	// Salazar at the computer terminal.
	add_scene( "scene_sal_intro_comp", "align_trespasser", true );
	add_actor_anim( "salazar",				%ch_karma_5_4_crc_hack_intro_sala );
	
	add_scene( "scene_sal_loop_comp", "align_trespasser", false, false, true );
	add_actor_anim( "salazar",				%ch_karma_5_4_crc_hack_loop_sala );
	
	// Player accessing the computer main frame (Minority Report)
	add_scene( "crc1", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc1_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle01,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc2", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_02,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc2_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle02,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc3", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_03,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc3_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle03,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc4", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_04,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc4_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle04,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc5", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_07,  SCENE_DELETE, PLAYER_1 );

	add_scene( "crc5_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle05,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc6", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_06,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc6_idle", "align_computer", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_idle06,  !SCENE_DELETE, PLAYER_1 );

	add_scene( "crc7", "align_computer" );
	add_player_anim( "player_body",			%player::p_karma_5_4_crc_mainframe_player_07,  SCENE_DELETE, PLAYER_1 );

	// Lobby Shootout
	add_scene( "scene_lobby_shootout", "align_elevator_last" );
	add_actor_anim( "assault_shooter",		%ch_karma_5_4_security_takedown_enemy_01, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "shotgun_shooter",		%ch_karma_5_4_security_takedown_enemy_02, !SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_01",		%ch_karma_5_4_security_takedown_guard_01, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_02",		%ch_karma_5_4_security_takedown_guard_02, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "lobby_guard_03",		%ch_karma_5_4_security_takedown_guard_03, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );	
	
	// Salazar opening crc door from the inside.
	add_scene( "scene_sal_ready_crc_door", "align_crc_door", true );
	add_actor_anim( "salazar",					%ch_karma_5_6_exitcrc_enter_sala );
	
	add_scene( "scene_sal_loop_crc_door", "align_crc_door", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_4_exit_crc_salazar_startidl );
	
	add_scene( "scene_sal_exit_crc_door", "align_crc_door");
	add_actor_anim( "salazar",					%generic_human::ch_karma_5_4_construction_intro_sala);
	
	add_scene( "scene_victim1_exit_crc_door", "align_crc_door");
	add_actor_anim( "victim1",					%generic_human::ch_karma_5_4_construction_intro_pmc01 );
	
	add_scene( "scene_victim2_exit_crc_door", "align_crc_door");
	add_actor_anim( "victim2",					%generic_human::ch_karma_5_4_construction_intro_pmc02 );
	add_notetrack_level_notify( "victim2", "bloody_tarp_start", "bloody_tarp_start" );
	
	add_scene( "scene_player_exit_crc_door", "align_crc_door");
	add_player_anim( "player_body",				%player::p_karma_5_4_construction_intro_player, SCENE_DELETE);
	add_notetrack_attach( "player_body", "knife_on", "t6_wpn_knife_melee", "tag_weapon1" );
	add_notetrack_fx_on_tag( "player_body", "knife_stab", "crc_neck_stab_blood", "tag_knife_fx" );
	add_notetrack_fx_on_tag( "player_body", "knife_slash", "crc_neck_slash_blood", "tag_knife_fx" );
	add_notetrack_detach( "player_body", "knife_off", "t6_wpn_knife_melee", "tag_weapon1" );
	add_notetrack_flag( "player_body", "dim_lights", "crc_lights_out" );
	
	// Guards reaction infront of CRC door when victim is shot in the head.
	add_scene( "scene_guard_reaction_crc_door", "align_takedown" );
	add_actor_anim( "guard_03_reaction",		%ch_karma_5_6_exitcrc_reaction_guard3 );
	add_actor_anim( "guard_lead_reaction",	%ch_karma_5_6_exitcrc_reaction_guardlead );	
	
	add_scene( "e5_guards_cover_fire", "align_hallway2", true );
	add_actor_anim( "creeper_1", 					%ch_karma_5_6_corner_guards_guy1 );
	add_actor_anim( "creeper_2", 			%ch_karma_5_6_corner_guards_guy2 );
	
	add_scene( "escalator_door_kick", "align_office_kick" );
	add_actor_anim( "guard_door_kick", %generic_human::ch_karma_5_6_door_kick_guy1 );
	
	add_scene( "call_reinforcements", "align_hallway", true );
	add_actor_anim( "guard_reinforcements", %generic_human::ch_karma_5_6_radio_soldier_guy1 );
	
	add_scene( "e5_elevator_guard_flash_exit", "align_hallway", true );
	add_actor_anim( "ai_con_site_elevator_guard_1", 			%ch_karma_5_5_elevator_exit_pmc01 );
	add_actor_anim( "ai_con_site_elevator_guard_2", 			%ch_karma_5_5_elevator_exit_pmc02 );

	//guard balcony into the guard room.
	add_scene("e5_balcony_guard_death", "align_hallway");
	add_actor_anim( "ai_con_dead_balcony_guy", 			%ch_karma_5_4_balcony_death_guy01);

	// Salazar stealth takedown in the construction site.
	add_scene( "scene_sal_takedown", "align_takedown" );
	add_actor_anim( "salazar", 					%ch_karma_5_6_salazar_takedown_sala );
	add_actor_anim( "salazar_victim", 			%ch_karma_5_6_salazar_takedown_grd1 );
	
	// Salazar & Player at elevator 3 anims.
	add_scene( "scene_sal_elevator_enter", "align_elevator_last", true );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_enter_sala );
	
	add_scene( "scene_sal_elevator_wait", "align_elevator_last", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_wait_sala );

	add_scene( "scene_sal_elevator_button", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_pressbutton_sala );
	
	add_scene( "scene_sal_elevator_pack", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_packing_sala );		

	add_scene( "scene_sal_elevator_idle", "align_elevator_last", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_loop_sala, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON);	
	
	add_scene( "scene_sal_elevator_comment", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_comment_sala );	

	add_scene( "scene_sal_elevator_exit", "align_elevator_last" );
	add_actor_anim( "salazar",					%ch_karma_5_7_elevator_exit_sala );		

	add_scene( "scene_p_elevator_03", "align_elevator_last" );
	add_player_anim( "player_body", 			%player::p_karma_5_7_elevator_enter_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
	
	add_scene( "club_elevator_open", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim(  "club_elevator_model",	%animated_props::o_karma_3_elevator_1_door_open );
	
	add_scene( "club_elevator_close", undefined, !SCENE_REACH, !SCENE_GENERIC, !SCENE_LOOP, !SCENE_ALIGN );
	add_prop_anim(  "club_elevator_model",	%animated_props::o_karma_3_elevator_1_door_close );

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
	// Harper PIP
	add_scene( "harper_finds_karma", "dance_floor" );
	add_actor_model_anim( "harper_body",	%ch_karma_6_1_harper_pip_harper,		"c_usa_masonjr_karma_viewbody", SCENE_DELETE );
	add_actor_model_anim( "karma",			%ch_karma_6_1_harper_pip_karma,			undefined, !SCENE_DELETE, undefined, undefined, "karma" );
	add_actor_model_anim( "pip_dancer7",	%ch_karma_6_1_harper_pip_dancer_07,		undefined, SCENE_DELETE, undefined, undefined, "club_male6" );
	add_actor_model_anim( "pip_dancer8",	%ch_karma_6_1_harper_pip_dancer_08,		undefined, SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_model_anim( "pip_dancer9",	%ch_karma_6_1_harper_pip_dancer_09,		undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	// Outer Solar entrance
	add_scene( "outer_solar_bouncer", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_bouncer",	%ch_karma_6_2_outersolar_bouncer,		undefined, SCENE_DELETE, undefined, undefined, "club_bouncer" );

	add_scene( "main_bouncer_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "club_main_enterance_bouncer",	%ch_karma_6_1_club_bouncer_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

	add_scene( "main_bouncer_moveout", "club_lobby" );
	add_actor_anim( "club_main_enterance_bouncer",	%ch_karma_6_1_club_bouncer_moveout, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

	add_scene( "main_bouncer_moveout_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "club_main_enterance_bouncer",	%ch_karma_6_1_club_bouncer_moveout_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

	add_scene( "main_bouncer_moveback", "club_lobby" );
	add_actor_anim( "club_main_enterance_bouncer",	%ch_karma_6_1_club_bouncer_moveback, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON );

	add_scene( "main_bouncer_moveback_complete_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "club_main_enterance_bouncer",	%ch_karma_6_1_club_bouncer_loop, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	add_scene( "outer_solar_girl01", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_girl01",		%ch_karma_6_2_outersolar_girl01_sit,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );

	add_scene( "outer_solar_girl02", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_girl02",		%ch_karma_6_2_outersolar_girl02_sit,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );

	add_scene( "outer_solar_girl03", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_girl03",		%ch_karma_6_2_outersolar_girl03_sit,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );
	
	add_scene( "outsol_dancer_a", "outside_club",		!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outsol_dancer_a",		%ch_karma_6_2_outersolar_gogo_dancer_a,	undefined, SCENE_DELETE, undefined, undefined, "club_shadow_dancer" );
	
	add_scene( "outsol_dancer_b", "outside_club",		!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outsol_dancer_b",		%ch_karma_6_2_outersolar_gogo_dancer_b,	undefined, SCENE_DELETE, undefined, undefined, "club_shadow_dancer" );

	add_scene( "outer_solar_guy01", "outside_club", 	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_guy01",		%ch_karma_6_2_outersolar_guy01_sit,		undefined, SCENE_DELETE, undefined, undefined, "club_male6" );

	add_scene( "outer_solar_guy02", "outside_club", 	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_guy02",		%ch_karma_6_2_outersolar_guy02_sit,		undefined, SCENE_DELETE, undefined, undefined, "club_male2" );

	add_scene( "outer_solar_guy03", "outside_club", 	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_guy03",		%ch_karma_6_2_outersolar_guy03_sit,		undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	add_scene( "outer_solar_guy04", "outside_club", 	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_guy04",		%ch_karma_6_2_outersolar_guy04_sit,		undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	add_scene( "outer_solar_line_guy01", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_line_guy01",	%ch_karma_6_2_outersolar_line_guy01,	undefined, SCENE_DELETE, undefined, undefined, "club_male5" );

	add_scene( "outer_solar_line_guy02", "outside_club",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_solar_line_guy02",	%ch_karma_6_2_outersolar_line_guy02,	undefined, SCENE_DELETE, undefined, undefined, "club_male6" );

	// Coat Check Area
	add_scene( "outer_solar_coatcheck_area_2guys", "club_lobby",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "coatcheck_guy1",	%ch_karma_6_1_coatcheck_guy01,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );
	add_actor_model_anim( "coatcheck_guy2",	%ch_karma_6_1_coatcheck_guy02,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	add_scene( "outer_solar_coatcheck_area_couple", "club_lobby",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "coatcheck_couple_man",	%ch_karma_6_1_coatcheck_guy03,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );
	add_actor_model_anim( "coatcheck_couple_woman",	%ch_karma_6_1_coatcheck_girl01,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );

	// Idles seated at the bar
	add_scene( "outer_solar_bar_seated", "club_lobby",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "drinks_seated_girl01",	%ch_karma_6_1_round_seated_areas_2_girl01_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );
	add_actor_model_anim( "drinks_seated_girl02",	%ch_karma_6_1_round_seated_areas_2_girl02_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );
	add_actor_model_anim( "drinks_seated_guy01",	%ch_karma_6_1_round_seated_areas_2_guy01_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );
	add_actor_model_anim( "drinks_seated_guy02",	%ch_karma_6_1_round_seated_areas_2_guy02_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male5" );
	add_actor_model_anim( "drinks_seated_guy03",	%ch_karma_6_1_round_seated_areas_2_guy03_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male6" );

	// Enter Bar
	add_scene( "outer_solar_enter_bar_a", "club_lobby" );
	add_actor_model_anim( "enter_bar_girl01",	%ch_karma_6_1_round_seated_areas_1_girl01,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );
	add_scene( "outer_solar_enter_bar_a_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "enter_bar_girl01",	%ch_karma_6_1_round_seated_areas_1_girl01_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );

	add_scene( "outer_solar_enter_bar_b", "club_lobby" );
	add_actor_model_anim( "enter_bar_girl02",	%ch_karma_6_1_round_seated_areas_1_girl02,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );
	add_scene( "outer_solar_enter_bar_b_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "enter_bar_girl02",	%ch_karma_6_1_round_seated_areas_1_girl02_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );

	add_scene( "outer_solar_enter_bar_c", "club_lobby" );
	add_actor_model_anim( "enter_bar_guy01",	%ch_karma_6_1_round_seated_areas_1_guy01,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );
	add_scene( "outer_solar_enter_bar_c_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "enter_bar_guy01",	%ch_karma_6_1_round_seated_areas_1_guy01_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );

	add_scene( "outer_solar_enter_bar_d", "club_lobby" );
	add_actor_model_anim( "enter_bar_guy02",	%ch_karma_6_1_round_seated_areas_1_guy02,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );
	add_scene( "outer_solar_enter_bar_d_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "enter_bar_guy02",	%ch_karma_6_1_round_seated_areas_1_guy02_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	add_scene( "outer_solar_enter_bar_e", "club_lobby" );
	add_actor_model_anim( "enter_bar_guy03",	%ch_karma_6_1_round_seated_areas_1_guy03,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );
	add_scene( "outer_solar_enter_bar_e_loop", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "enter_bar_guy03",	%ch_karma_6_1_round_seated_areas_1_guy03_idle,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	outer_bar_aligned_anims();
	

	// Solar Lounge left
	// Solar Lounge right

	// Inner Solar bar civs
	add_scene( "bar_e", "dance_floor",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_e_bartender1",	%ch_karma_6_2_bartender_01,		undefined, SCENE_DELETE, undefined, undefined, "civ_bartender" );
	add_actor_model_anim( "bar_e_girl1",		%ch_karma_6_2_barcivs_e_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_model_anim( "bar_e_guy1",			%ch_karma_6_2_barcivs_e_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );
	add_actor_model_anim( "bar_e_guy2",			%ch_karma_6_2_barcivs_e_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );
	
	add_scene( "bar_c", "dance_floor",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_c_bartender2",	%ch_karma_6_2_bartender_02,	undefined, SCENE_DELETE, undefined, undefined, "civ_bartender" );
	add_actor_model_anim( "bar_c_guy1",			%ch_karma_6_2_barcivs_c_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "bar_c_guy2",			%ch_karma_6_2_barcivs_c_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light1" );

	add_scene( "bar_a_girl2", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_a_girl2",		%ch_karma_6_2_barcivs_a_girl2,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );

	add_scene( "bar_a_guy1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_a_guy1",			%ch_karma_6_2_barcivs_a_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light3" );

	add_scene( "bar_b_guy1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_b_guy1",			%ch_karma_6_2_barcivs_b_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "bar_d_girl1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_d_girl1",		%ch_karma_6_2_barcivs_d_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );

	add_scene( "bar_d_guy2", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_d_guy2",			%ch_karma_6_2_barcivs_d_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	add_scene( "bar_f_girl1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_f_girl1",		%ch_karma_6_2_barcivs_f_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light3" );

	add_scene( "bar_f_guy1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_f_guy1",			%ch_karma_6_2_barcivs_f_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );

	add_scene( "bar_f_guy2", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_f_guy2",			%ch_karma_6_2_barcivs_f_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "bar_g_girl1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_g_girl1",		%ch_karma_6_2_barcivs_g_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );

	add_scene( "bar_g_guy1", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_g_guy1",			%ch_karma_6_2_barcivs_g_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light3" );

	add_scene( "bar_g_guy2", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "bar_g_guy2",			%ch_karma_6_2_barcivs_g_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light1" );

				
	// 	Inner Solar Entrance Bouncer
	add_scene( "bouncer_lounge_door_idle", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_loop );

	add_scene( "bouncer_lounge_door_open", "club_lobby" );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door );
	
	add_scene( "bouncer_lounge_door_wait", "club_lobby", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_wait );
	
	add_scene( "bouncer_lounge_door_close", "club_lobby" );
	add_actor_anim( "lounge_bouncer",			%ch_karma_6_2_bouncer_opens_door_close, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// Ambient interactions
//	add_scene( "club_female_denied", "dance_floor" );
//	add_actor_anim( "club_female_denied",		%ch_karma_6_2_denied_female, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON);
//
//	add_scene( "club_female_denied_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
//	add_actor_anim( "club_female_denied",		%ch_karma_6_2_denied_female_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	// Group dancing
	level.scr_anim[ "generic" ][ "group_dancing1" ] = %animated_props::ch_karma_6_2_group_dancing_01;
	level.scr_anim[ "generic" ][ "group_dancing2" ] = %animated_props::ch_karma_6_2_group_dancing_02;

	// Civ reactions
	//	A
	add_scene( "club_react_a_start_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "club_react_a_male1",		%ch_karma_6_2_ambientclub_a_sit_guy_idle, 		undefined, !SCENE_DELETE, undefined, undefined, "club_male5" );
	add_actor_anim( "club_react_a_male2",			%ch_karma_6_2_ambientclub_a_dance_guy_idle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male2" );
	add_actor_anim( "club_react_a_male3",			%ch_karma_6_2_ambientclub_a_stand_guy_idle, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male3" );
	
	add_scene( "club_react_a_react", "dance_floor" );
	add_actor_model_anim( "club_react_a_male1",		%ch_karma_6_2_ambientclub_a_sit_guy_react, 		undefined, !SCENE_DELETE );
	add_actor_anim( "club_react_a_male2",			%ch_karma_6_2_ambientclub_a_dance_guy_react,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_a_male3",			%ch_karma_6_2_ambientclub_a_stand_guy_react, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_react_a_end_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "club_react_a_male1",		%ch_karma_6_2_ambientclub_a_sit_guy_endidle, 	undefined, SCENE_DELETE  );
	add_actor_anim( "club_react_a_male2",			%ch_karma_6_2_ambientclub_a_dance_guy_endidle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_a_male3",			%ch_karma_6_2_ambientclub_a_stand_guy_endidle, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	//	B
	add_scene( "club_react_b_start_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "club_react_b_female1",	%ch_karma_6_2_ambientclub_b_couple_girl1_idle,	undefined, !SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_anim( "club_react_b_female2",			%ch_karma_6_2_ambientclub_b_couple_girl2_idle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female2" );
	add_actor_anim( "club_react_b_male1",			%ch_karma_6_2_ambientclub_b_couple_guy1_idle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male5" );
	add_actor_anim( "club_react_b_male2",			%ch_karma_6_2_ambientclub_b_couple_guy2_idle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male2" );
	add_actor_anim( "club_react_b_male3",			%ch_karma_6_2_ambientclub_b_solo_guy_idle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male3" );
		
	add_scene( "club_react_b_react", "dance_floor" );
	add_actor_model_anim( "club_react_b_female1",	%ch_karma_6_2_ambientclub_b_couple_girl1_react,	undefined, !SCENE_DELETE );
	add_actor_anim( "club_react_b_female2",		%ch_karma_6_2_ambientclub_b_couple_girl2_react,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_b_male1",		%ch_karma_6_2_ambientclub_b_couple_guy1_react,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_b_male2",		%ch_karma_6_2_ambientclub_b_couple_guy2_react,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_b_male3",		%ch_karma_6_2_ambientclub_b_solo_guy_react,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_react_b_end_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "club_react_b_female1",	%ch_karma_6_2_ambientclub_b_couple_girl1_endidle,	undefined, SCENE_DELETE );
	add_actor_anim( "club_react_b_female2",		%ch_karma_6_2_ambientclub_b_couple_girl2_endidle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_b_male1",		%ch_karma_6_2_ambientclub_b_couple_guy1_endidle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_b_male2",		%ch_karma_6_2_ambientclub_b_couple_guy2_endidle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_b_male3",		%ch_karma_6_2_ambientclub_b_solo_guy_endidle,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	
	//	C
	add_scene( "club_react_c_start_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "club_react_c_female1",	%ch_karma_6_2_ambientclub_c_couple_girl1_idle,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_anim( "club_react_c_female2",	%ch_karma_6_2_ambientclub_c_couple_girl2_idle,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female2" );
	add_actor_anim( "club_react_c_male1",		%ch_karma_6_2_ambientclub_c_couple_guy1_idle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male5" );
	add_actor_anim( "club_react_c_male2",		%ch_karma_6_2_ambientclub_c_couple_guy2_idle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male2" );
		
	add_scene( "club_react_c_react", "dance_floor" );
	add_actor_anim( "club_react_c_female1",	%ch_karma_6_2_ambientclub_c_couple_girl1_react,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_c_female2",	%ch_karma_6_2_ambientclub_c_couple_girl2_react,			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_c_male1",		%ch_karma_6_2_ambientclub_c_couple_guy1_react,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "club_react_c_male2",		%ch_karma_6_2_ambientclub_c_couple_guy2_react,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_react_c_end_idle", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "club_react_c_female1",	%ch_karma_6_2_ambientclub_c_couple_girl1_endidle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_c_female2",	%ch_karma_6_2_ambientclub_c_couple_girl2_endidle,		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_c_male1",		%ch_karma_6_2_ambientclub_c_couple_guy1_endidle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "club_react_c_male2",		%ch_karma_6_2_ambientclub_c_couple_guy2_endidle,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// Seductive Woman
	add_scene( "seductive_woman_intro",	"dance_floor" );
	add_actor_anim( "seductive_woman",	%ch_karma_6_2_seductive_woman, 		SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female3" );

	add_scene( "seductive_woman_loop", 	"dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "seductive_woman",	%ch_karma_6_2_seductive_woman_idle, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female3" );

				
	// Dance floor parters
	// 		Group A
	add_scene( "club_dance_parters_a_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "male_dancer4",			%ch_karma_6_3_player_enters_club_maledancer04_loop, 				SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male_light3" );

	add_scene( "club_dance_parters_a_react", "dance_floor" );
	add_actor_anim( "male_dancer4",			%ch_karma_6_3_player_enters_club_maledancer04_reaction, 			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_dance_parters_a_endloop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "male_dancer4",			%ch_karma_6_3_player_enters_club_maledancer04_afterreaction_loop, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// 		Group B
	add_scene( "club_dance_parters_b_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "female_dancer1",		%ch_karma_6_3_player_enters_club_femaledancer01_loop, 				SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female_light1" );
	add_actor_anim( "male_dancer3",			%ch_karma_6_3_player_enters_club_maledancer03_loop, 				SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male_light2" );

	add_scene( "club_dance_parters_b_react", "dance_floor" );
	add_actor_anim( "female_dancer1",		%ch_karma_6_3_player_enters_club_femaledancer01_reaction, 			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_anim( "male_dancer3",			%ch_karma_6_3_player_enters_club_maledancer03_reaction, 			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_dance_parters_b_endloop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "female_dancer1",		%ch_karma_6_3_player_enters_club_femaledancer01_afterreaction_loop,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
	add_actor_anim( "male_dancer3",			%ch_karma_6_3_player_enters_club_maledancer03_afterreaction_loop, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );

	// 		Group C
	add_scene( "club_dance_parters_c_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "male_dancer2",			%ch_karma_6_3_player_enters_club_maledancer02_loop, 				SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_male_light1" );

	add_scene( "club_dance_parters_c_react", "dance_floor" );
	add_actor_anim( "male_dancer2",			%ch_karma_6_3_player_enters_club_maledancer02_reaction, 			SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );

	add_scene( "club_dance_parters_c_endloop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "male_dancer2",			%ch_karma_6_3_player_enters_club_maledancer02_afterreaction_loop, 	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE );
		
	// Club Encounter Idles
	add_scene( "dj_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "club_dj",		%ch_karma_6_3_player_enters_club_dj_loop,			undefined, !SCENE_DELETE, undefined, undefined, "club_dj" );

	add_scene( "club_encounter_harper_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "harper", 			%ch_karma_6_3_player_enters_club_harper_loop, 	SCENE_HIDE_WEAPON,  !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE );
	add_actor_model_anim( "karma",		%ch_karma_6_3_player_enters_club_karma_loop,			undefined, !SCENE_DELETE, undefined, undefined, "karma" );

	add_scene( "club_encounter_hostages_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "female_hostage1",	%ch_karma_6_3_player_enters_club_hostage_female01_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_model_anim( "female_hostage2",	%ch_karma_6_3_player_enters_club_hostage_female02_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_female3" );

	add_scene( "club_encounter_dancers1_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "male_dancer1", 	%ch_karma_6_3_player_enters_club_maledancer01_loop,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "club_encounter_dancers2_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "female_dancer2", 	%ch_karma_6_3_player_enters_club_femaledancer02_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_female_light2" );
	add_actor_model_anim( "female_dancer3", 	%ch_karma_6_3_player_enters_club_femaledancer03_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_female_light3" );
	add_actor_model_anim( "female_dancer4", 	%ch_karma_6_3_player_enters_club_femaledancer04_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_female_light1" );
	add_actor_model_anim( "male_dancer5", 	%ch_karma_6_3_player_enters_club_maledancer05_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "male_dancer6", 	%ch_karma_6_3_player_enters_club_maledancer06_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light3" );
	add_actor_model_anim( "male_dancer7", 	%ch_karma_6_3_player_enters_club_maledancer07_loop,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "club_encounter_dancers3_loop", "dance_floor", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "male_dancer12", 	%ch_karma_6_3_player_enters_club_maledancer12_loop,		undefined, !SCENE_DELETE, undefined, undefined, "club_male_light4" );

	// Club encounter
	add_scene( "club_encounter_player", "dance_floor" );
	add_player_anim( "player_body", 	%player::p_karma_6_3_player_enters_club_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
		add_notetrack_level_notify(    "player_body", "bar_shelves1", "fxanim_club_bar_shelves_01_start" );
		add_notetrack_custom_function( "player_body", "dof_1",	maps\createart\karma_art::defalco_encounter_dof01 );
		add_notetrack_custom_function( "player_body", "dof_2",	maps\createart\karma_art::defalco_encounter_dof02 );
		add_notetrack_custom_function( "player_body", "dof_3",	maps\createart\karma_art::defalco_encounter_dof03 );
		add_notetrack_custom_function( "player_body", "dof_4",	maps\createart\karma_art::defalco_encounter_dof04 );
		add_notetrack_custom_function( "player_body", "dof_5",	maps\createart\karma_art::defalco_encounter_dof05 );
		add_notetrack_custom_function( "player_body", "dof_6",	maps\createart\karma_art::defalco_encounter_dof06 );
		add_notetrack_flag( 		   "player_body", "dof_5", "club_rear_flee" );
		add_notetrack_custom_function( "player_body", "start_fullcrowd_flee",	maps\karma_inner_solar::start_crowd_flee );

	//TODO Should still be able to see DJ and Hostage that was killed, but I'm deleteing them for Alpha.
	add_scene( "club_encounter", "dance_floor" );
	add_actor_anim( "harper", 			%ch_karma_6_3_player_enters_club_harper, 	SCENE_HIDE_WEAPON, SCENE_GIVE_BACK_WEAPON );
	add_actor_model_anim( "karma",		%ch_karma_6_3_player_enters_club_karma,			undefined, SCENE_DELETE );
	add_actor_anim( "defalco", 			%ch_karma_6_3_player_enters_club_defalco,	undefined, undefined, SCENE_DELETE );
	add_notetrack_custom_function( "defalco", "start_dj_death",		maps\karma_inner_solar::shoot_dj );
	add_notetrack_custom_function( "defalco", "start_hostage_death",	maps\karma_inner_solar::shoot_hostage );
	add_notetrack_custom_function( "defalco", "club_music_snapshot", ::club_music_snapshot );
	add_actor_anim( "club_pmc1", 		%ch_karma_6_3_player_enters_club_pmc, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
	add_actor_model_anim( "club_dj", 		%ch_karma_6_3_player_enters_club_dj,				undefined, !SCENE_DELETE, undefined, undefined, "club_dj" );
	add_actor_model_anim( "female_hostage1", %ch_karma_6_3_player_enters_club_hostage_female01,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_model_anim( "female_hostage2", %ch_karma_6_3_player_enters_club_hostage_female02,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );
	add_actor_model_anim( "male_dancer12", 	%ch_karma_6_3_player_enters_club_maledancer12,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "club_encounter_dancers2", "dance_floor" );
	add_actor_model_anim( "female_dancer2", %ch_karma_6_3_player_enters_club_femaledancer02,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );
	add_actor_model_anim( "female_dancer3", %ch_karma_6_3_player_enters_club_femaledancer03,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light3" );
	add_actor_model_anim( "female_dancer4", %ch_karma_6_3_player_enters_club_femaledancer04,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light1" );
	add_actor_model_anim( "male_dancer5", 	%ch_karma_6_3_player_enters_club_maledancer05,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "male_dancer6", 	%ch_karma_6_3_player_enters_club_maledancer06,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light3" );
	add_actor_model_anim( "male_dancer7", 	%ch_karma_6_3_player_enters_club_maledancer07,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );

	add_scene( "club_encounter_dancers3", "dance_floor" );
	add_actor_model_anim( "female_dancer5", %ch_karma_6_3_player_enters_club_femaledancer05,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );
	add_actor_model_anim( "male_dancer8", 	%ch_karma_6_3_player_enters_club_maledancer08,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light1" );
	add_actor_model_anim( "male_dancer9", 	%ch_karma_6_3_player_enters_club_maledancer09,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "male_dancer10", 	%ch_karma_6_3_player_enters_club_maledancer10,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );
	add_actor_model_anim( "male_dancer11", 	%ch_karma_6_3_player_enters_club_maledancer11,		undefined, SCENE_DELETE, undefined, undefined, "club_male_light3" );

	add_scene( "club_encounter_hostage_flee", "dance_floor" );
	add_actor_model_anim( "fleeing_female01", %ch_karma_6_3_player_enters_club_hostage_flee_female01,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light1" );
	add_actor_model_anim( "fleeing_female02", %ch_karma_6_3_player_enters_club_hostage_flee_female02,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light3" );
	add_actor_model_anim( "fleeing_female03", %ch_karma_6_3_player_enters_club_hostage_flee_female03,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );
	add_actor_model_anim( "fleeing_female04", %ch_karma_6_3_player_enters_club_hostage_flee_female04,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light1" );
	add_actor_model_anim( "fleeing_female05", %ch_karma_6_3_player_enters_club_hostage_flee_female05,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light3" );
	add_actor_model_anim( "fleeing_female06", %ch_karma_6_3_player_enters_club_hostage_flee_female06,	undefined, SCENE_DELETE, undefined, undefined, "club_female_light2" );
	add_actor_model_anim( "fleeing_male01",	%ch_karma_6_3_player_enters_club_hostage_flee_male01,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light4" );
	add_actor_model_anim( "fleeing_male02",	%ch_karma_6_3_player_enters_club_hostage_flee_male02,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light3" );
	add_actor_model_anim( "fleeing_male03", %ch_karma_6_3_player_enters_club_hostage_flee_male03,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light1" );
	add_actor_model_anim( "fleeing_male04", %ch_karma_6_3_player_enters_club_hostage_flee_male04,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light3" );
	add_actor_model_anim( "fleeing_male05", %ch_karma_6_3_player_enters_club_hostage_flee_male05,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "fleeing_male06", %ch_karma_6_3_player_enters_club_hostage_flee_male06,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light1" );
	add_actor_model_anim( "fleeing_male07", %ch_karma_6_3_player_enters_club_hostage_flee_male07,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light4" );
	add_actor_model_anim( "fleeing_male08", %ch_karma_6_3_player_enters_club_hostage_flee_male08,	undefined, SCENE_DELETE, undefined, undefined, "club_male_light2" );
	add_actor_model_anim( "fleeing_male09", %ch_karma_6_3_player_enters_club_hostage_flee_male09,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light4" );
	add_actor_model_anim( "fleeing_male10", %ch_karma_6_3_player_enters_club_hostage_flee_male10,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light3" );
	add_actor_model_anim( "fleeing_male11", %ch_karma_6_3_player_enters_club_hostage_flee_male11,	undefined, !SCENE_DELETE, undefined, undefined, "club_male_light2" );
//	add_actor_anim( "fleeing_female01", %ch_karma_6_3_player_enters_club_hostage_flee_female01,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light1" );
//	add_actor_anim( "fleeing_female02", %ch_karma_6_3_player_enters_club_hostage_flee_female02,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light3" );
//	add_actor_anim( "fleeing_female03", %ch_karma_6_3_player_enters_club_hostage_flee_female03,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light2" );
//	add_actor_anim( "fleeing_female04", %ch_karma_6_3_player_enters_club_hostage_flee_female04,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light1" );
//	add_actor_anim( "fleeing_female05", %ch_karma_6_3_player_enters_club_hostage_flee_female05,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light3" );
//	add_actor_anim( "fleeing_female06", %ch_karma_6_3_player_enters_club_hostage_flee_female06,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_female_light2" );
//	add_actor_anim( "fleeing_male01",	%ch_karma_6_3_player_enters_club_hostage_flee_male01,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light4" );
//	add_actor_anim( "fleeing_male02",	%ch_karma_6_3_player_enters_club_hostage_flee_male02,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light3" );
//	add_actor_anim( "fleeing_male03",	%ch_karma_6_3_player_enters_club_hostage_flee_male03,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light1" );
//	add_actor_anim( "fleeing_male04",	%ch_karma_6_3_player_enters_club_hostage_flee_male04,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light3" );
//	add_actor_anim( "fleeing_male05",	%ch_karma_6_3_player_enters_club_hostage_flee_male05,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light2" );
//	add_actor_anim( "fleeing_male06",	%ch_karma_6_3_player_enters_club_hostage_flee_male06,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light1" );
//	add_actor_anim( "fleeing_male07",	%ch_karma_6_3_player_enters_club_hostage_flee_male07,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light4" );
//	add_actor_anim( "fleeing_male08",	%ch_karma_6_3_player_enters_club_hostage_flee_male08,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light2" );
//	add_actor_anim( "fleeing_male09",	%ch_karma_6_3_player_enters_club_hostage_flee_male09,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light4" );
//	add_actor_anim( "fleeing_male10",	%ch_karma_6_3_player_enters_club_hostage_flee_male10,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light3" );
//	add_actor_anim( "fleeing_male11",	%ch_karma_6_3_player_enters_club_hostage_flee_male11,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, SCENE_ALLOW_DEATH, SCENE_NO_TAG, "club_male_light2" );
	
	// Bar Fight
	add_scene( "bar_fight_player", "dance_floor" );
	add_player_anim( "player_body", 	%player::p_karma_6_3_clubsolar_barfight_player, SCENE_DELETE, PLAYER_1, SCENE_NO_TAG, !SCENE_DELTA, undefined, undefined, undefined, undefined, undefined, !SCENE_USE_TAG_ANGLES, !SCENE_AUTO_CENTER, SCENE_USE_CAMERA_TWEEN );
		add_notetrack_level_notify( "player_body", "bar_shelves2", "fxanim_club_bar_shelves_02_start" );

	add_scene( "bar_fight_harper", "dance_floor" );
	add_actor_anim( "harper", 			%ch_karma_6_3_clubsolar_barfight_harper, 				!SCENE_HIDE_WEAPON );
		add_notetrack_flag("harper", "stand_up", "bar_fight_stand");
		add_notetrack_custom_function( "harper", "start_slowmo",	maps\karma_inner_solar::bullet_time );
		add_notetrack_custom_function( "harper", "start_1stgunshot",	maps\karma_inner_solar::shoot_pmc2 );
		add_notetrack_custom_function( "harper", "start_2ndgunshot",	maps\karma_inner_solar::shoot_pmc3 );
		add_notetrack_custom_function( "harper", "start_3rdgunshot",	maps\karma_inner_solar::shoot_pmc1 );

	add_scene( "bar_fight_pmcs", "dance_floor" );
	add_actor_anim( "club_pmc1",		%ch_karma_6_3_clubsolar_barfight_pmc, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
		add_notetrack_custom_function( "club_pmc1", "pmc_getshot",	maps\karma_inner_solar::killed_by_harper );
	add_actor_anim( "club_pmc2", 		%ch_karma_6_3_clubsolar_barfight_pmc02, !SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
		add_notetrack_custom_function( "club_pmc2", "pmc_getshot",	maps\karma_inner_solar::killed_by_harper );
	add_actor_anim( "club_pmc3", 		%ch_karma_6_3_clubsolar_barfight_pmc03, !SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE, !SCENE_ALLOW_DEATH );
		add_notetrack_custom_function( "club_pmc3", "pmc_getshot",	maps\karma_inner_solar::killed_by_harper );

	add_scene( "bar_fight_pmc4", "dance_floor" );
	add_actor_anim( "club_pmc4",		%ch_karma_6_3_clubsolar_barfight_pmc04, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc5", "dance_floor" );
	add_actor_anim( "club_pmc5",		%ch_karma_6_3_clubsolar_barfight_pmc05, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc6", "dance_floor" );
	add_actor_anim( "club_pmc6",		%ch_karma_6_3_clubsolar_barfight_pmc06, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc7", "dance_floor" );
	add_actor_anim( "club_pmc7",		%ch_karma_6_3_clubsolar_barfight_pmc07, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc8", "dance_floor" );
	add_actor_anim( "club_pmc8",		%ch_karma_6_3_clubsolar_barfight_pmc08, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc9", "dance_floor" );
	add_actor_anim( "club_pmc9",		%ch_karma_6_3_clubsolar_barfight_pmc09, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	
	add_scene( "bar_fight_pmc10", "dance_floor" );
	add_actor_anim( "club_pmc10",		%ch_karma_6_3_clubsolar_barfight_pmc10, 	!SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );
	add_actor_anim( "female_hostage3",	%ch_karma_6_3_clubsolar_barfight_pmc10_a, 	SCENE_HIDE_WEAPON, undefined, !SCENE_DELETE );

	precache_assets( true );
}


outer_bar_aligned_anims()
{
	add_scene( "outer_bar_e", "outer_solar_bar_bartender_align",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_e_bartender1",	%ch_karma_6_2_bartender_01,		undefined, SCENE_DELETE, undefined, undefined, "civ_bartender" );
	add_actor_model_anim( "outer_bar_e_girl1",		%ch_karma_6_2_barcivs_e_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );
	add_actor_model_anim( "outer_bar_e_guy1",			%ch_karma_6_2_barcivs_e_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );
	add_actor_model_anim( "outer_bar_e_guy2",			%ch_karma_6_2_barcivs_e_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	add_scene( "outer_bar_c", "outer_solar_bar_bartender_right_align",	!SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_c_bartender2",	%ch_karma_6_2_bartender_02,	undefined, SCENE_DELETE, undefined, undefined, "civ_bartender" );
	//add_actor_model_anim( "outer_bar_c_guy1",			%ch_karma_6_2_barcivs_c_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );
	//add_actor_model_anim( "outer_bar_c_guy2",			%ch_karma_6_2_barcivs_c_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male6" );

	// girl on far left sitting
	add_scene( "outer_bar_a_girl2", "outer_solar_bar_far_left_girl_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_a_girl2",		%ch_karma_6_2_barcivs_a_girl2,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );

	// guy standing on far left talking close to girl
	add_scene( "outer_bar_a_guy1", "outer_solar_bar_far_left_girl_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_a_guy1",			%ch_karma_6_2_barcivs_a_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	// guy to left arm on table
	add_scene( "outer_bar_b_guy1", "outer_solar_bar_left_guy_left_arm_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_b_guy1",			%ch_karma_6_2_barcivs_b_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	// girl just left of center behind a chair
	add_scene( "outer_bar_d_girl1", "outer_solar_bar_bartender_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_d_girl1",		%ch_karma_6_2_barcivs_d_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female1" );
	
	// guy center of bar, sitting
	add_scene( "outer_bar_d_guy2", "outer_solar_bar_guy_center_sitting_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_d_guy2",			%ch_karma_6_2_barcivs_d_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	// girl on the far right sitting down at the bar
	add_scene( "outer_bar_f_girl1", "outer_solar_bar_girl_far_right_sitting_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_f_girl1",		%ch_karma_6_2_barcivs_f_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female3" );

	// Guy sitting drinking at bar, drinking
	add_scene( "outer_bar_f_guy1", "outer_solar_bar_guy_far_right_sitting_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_f_guy1",			%ch_karma_6_2_barcivs_f_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male2" );

	// Man standing a litttle to the right, away from the bar a  bit
	add_scene( "outer_bar_f_guy2", "outer_solar_bar_guy_far_right_sitting_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_f_guy2",			%ch_karma_6_2_barcivs_f_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male4" );

	// Girl sitting middle right
	add_scene( "outer_bar_g_girl1", "outer_solar_bar_girl_sits_middle_right_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_g_girl1",		%ch_karma_6_2_barcivs_g_girl1,	undefined, SCENE_DELETE, undefined, undefined, "club_female2" );

	// Guys standing a little right to center
	add_scene( "outer_bar_g_guy1", "outer_solar_bar_girl_sits_middle_right_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_g_guy1",			%ch_karma_6_2_barcivs_g_guy1,	undefined, SCENE_DELETE, undefined, undefined, "club_male3" );

	// Another guys standing a little right to center
	add_scene( "outer_bar_g_guy2", "outer_solar_bar_guy_2nd_chair_from_right_align", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_model_anim( "outer_bar_g_guy2",			%ch_karma_6_2_barcivs_g_guy2,	undefined, SCENE_DELETE, undefined, undefined, "club_male5" );

	// Seductive Woman
	add_scene( "outer_seductive_woman_intro", "outer_solar_seductive_woman" );
	add_actor_anim( "seductive_woman",	%ch_karma_6_2_seductive_woman_outerbar,	SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, !SCENE_DELETE, undefined, undefined, "club_female3" );

	add_scene( "outer_seductive_woman_loop", 	"outer_solar_seductive_woman", !SCENE_REACH, !SCENE_GENERIC, SCENE_LOOP );
	add_actor_anim( "seductive_woman",	%ch_karma_6_2_seductive_woman_idle_outerbar, SCENE_HIDE_WEAPON, !SCENE_GIVE_BACK_WEAPON, SCENE_DELETE, undefined, undefined, "club_female3" );


}

club_music_snapshot(bro)
{
	clientnotify( "sndDuckSolar" );
}