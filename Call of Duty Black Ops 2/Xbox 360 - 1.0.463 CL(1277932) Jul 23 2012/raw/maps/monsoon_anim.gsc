#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");

#define PLAYER_BODY_PARAMS false, 0, undefined, true, 1, 2, 20, 20, 20
main()
{
	intro_anims();
	wingsuit_anims();
	ruins_anims();
	lab_entrance_anims();
	asd_intro_anims();
	lab_defend_anims();
	celerium_chamber_anims();
	
	perk_anims();
	
	precache_assets();
	
	maps\voice\voice_monsoon::init_voice();
}

//custom overrides for the level
custom_patrol_init()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %ai_patrolwalk_rain_walk_01;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %ai_patrolwalk_rain_walk_02;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %ai_patrolwalk_rain_walk_2_idle;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %ai_patrolwalk_rain_idle_2_walk;
	//level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;

	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %ai_patrolwalk_rain_stand_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %ai_patrolwalk_rain_stand_idle_datapad;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %ai_patrolwalk_rain_stand_idle_earpiece;
	//level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	//level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	//level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;

	level.scr_anim[ "generic" ][ "patrol_idle_slip" ]		= %ai_patrolwalk_slip_a;
	level.scr_anim[ "generic" ][ "patrol_idle_converse_a" ]	= %ai_patrolwalk_conversation_1;
	level.scr_anim[ "generic" ][ "patrol_idle_converse_b" ]	= %ai_patrolwalk_conversation_2;
	level.scr_anim[ "generic" ][ "patrol_idle_datapad" ]	= %ai_patrolwalk_rain_stand_idle_datapad;
	level.scr_anim[ "generic" ][ "patrol_idle_earpiece" ]	= %ai_patrolwalk_rain_stand_idle_earpiece;
}

perk_anims()
{
	add_scene( "bruteforce_perk", "lab_defend" );
	add_player_anim( "player_body", %player::int_specialty_monsoon_bruteforce, true );
	add_prop_anim( "bruteforce_jaws", %animated_props::o_specialty_monsoon_bruteforce_jaws, "t6_wpn_jaws_of_life_prop", true );
	add_notetrack_flag( "player_body", "hack_complete", "open_asd_door" );
	add_notetrack_custom_function( "player_body", "jaws_on", maps\monsoon_util::monsoon_light_rumble );
	add_notetrack_custom_function( "player_body", "jaws_into_hatch", maps\monsoon_util::monsoon_heavy_rumble );
	add_notetrack_custom_function( "player_body", "hatch_open", maps\monsoon_util::monsoon_heavy_rumble );
	
	add_scene( "bruteforce_perk_asd_door", "lab_defend" );
	add_prop_anim( "asd_door", %animated_props::o_specialty_monsoon_bruteforce_door, "p6_asd_charger_door" );
	
	add_scene( "intruder_perk", "heli_turret" );
	add_player_anim( "player_body", %player::int_specialty_monsoon_intruder, true );
	add_prop_anim( "intruder_cutter", %animated_props::o_specialty_monsoon_intruder_cutter, "t6_wpn_laser_cutter_prop", true );
}

intro_anims()
{
	// Intro
	add_scene( "cliff_intro", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffintro_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffintro_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::nanoglove_impact );
	add_notetrack_custom_function( "player_body", "player_look", maps\monsoon_intro::cliff_intro_harper_intro );
	
	// Harper Swing
	add_scene( "cliff_swing_1_idle", "eagle_eye_align", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing1_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing1_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_1", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing1_harper );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing1_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "success_window_start_1", maps\monsoon_intro::cliff_swing_success_window_assist_start );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "fail_1", maps\monsoon_intro::cliff_swing_harper_1_fail );
	
	add_scene( "cliff_swing_1_fail", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing1_fail_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing1_fail_player,PLAYER_BODY_PARAMS );
	
	// Player Swing
	add_scene( "cliff_swing_2_idle", "eagle_eye_align", false, false, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing2_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing2_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_2", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing2_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing2_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "flying_rumble", maps\monsoon_intro::cliff_swing_flying_rumble );
	add_notetrack_custom_function( "player_body", "success_window_start_2", maps\monsoon_intro::cliff_swing_success_window_grab_start );
	add_notetrack_custom_function( "player_body", "fail_2", maps\monsoon_intro::cliff_swing_player_1_fail );
	
	add_scene( "cliff_swing_2_fail", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing2_fail_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing2_fail_player, PLAYER_BODY_PARAMS );
	
	// Harper Swing 2
	add_scene( "cliff_swing_3_idle", "eagle_eye_align", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing3_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing3_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_3", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing3_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing3_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "success_window_start_3", maps\monsoon_intro::cliff_swing_success_window_assist_start );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "fail_3", maps\monsoon_intro::cliff_swing_harper_2_fail );
	
	add_scene( "cliff_swing_3_fail", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing3_fail_harper );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing3_fail_player,PLAYER_BODY_PARAMS );
	
	// Player Swing 2
	add_scene( "cliff_swing_4_idle", "eagle_eye_align", false, false, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing4_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing4_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_4", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing4_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing4_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "flying_rumble", maps\monsoon_intro::cliff_swing_flying_rumble );
	add_notetrack_custom_function( "player_body", "success_window_start_4", maps\monsoon_intro::cliff_swing_success_window_grab_start );
	add_notetrack_custom_function( "player_body", "fail_4", maps\monsoon_intro::cliff_swing_player_2_fail );
	
	add_scene( "cliff_swing_4_fail", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing4_fail_harper );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing4_fail_player, PLAYER_BODY_PARAMS );
	
	// Harper Swing 3
	add_scene( "cliff_swing_5_idle", "eagle_eye_align", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing5_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing5_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_5", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing5_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing5_player, PLAYER_BODY_PARAMS );
	add_notetrack_custom_function( "player_body", "success_window_start_5", maps\monsoon_intro::cliff_swing_success_window_assist_start );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "fail_5", maps\monsoon_intro::cliff_swing_harper_3_fail );
	
	add_scene( "cliff_swing_5_fail", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing5_fail_harper );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing5_fail_player,PLAYER_BODY_PARAMS );
	
	// Player Swing 3
	add_scene( "cliff_swing_6_idle", "eagle_eye_align", false, false, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing6_idle_harper, true );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing6_idle_player, PLAYER_BODY_PARAMS );
	
	add_scene( "cliff_swing_6_player", "eagle_eye_align" );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing6_player, true, 0, undefined, true, 1, 2, 20, 20, 20 );
	add_notetrack_custom_function( "player_body", "rumble", maps\monsoon_intro::single_rumble );
	add_notetrack_custom_function( "player_body", "flying_rumble", maps\monsoon_intro::cliff_swing_6_flying_rumble );
	add_notetrack_custom_function( "player_body", "success_window_start_6", maps\monsoon_intro::cliff_swing_6_landing );
	
	add_scene( "cliff_swing_6", "eagle_eye_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing6_harper, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_01_01_cliffswing6_salazar, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_01_01_cliffswing6_redshirt, true );
}

wingsuit_anims()
{
	// Intro
	add_scene( "squirrel_intro_idle", "eagle_eye_align", false, false, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_squirrelsuitintro_idle_harper, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_01_01_squirrelsuitintro_idle_salazar, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_01_01_squirrelsuitintro_idle_redshirt, true );
	
	// Player put on suit
	add_scene( "player_equip_suit", "equip_suit" );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing_putsonsuit, true );
	
	// Leap of faith
	add_scene( "leap_of_faith", "eagle_eye_align" );
	add_player_anim( "player_body", %player::p_mon_01_01_cliffswing_flight, true );
	add_actor_anim( "harper", %generic_human::ch_mon_01_01_cliffswing_harper_flight, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_01_01_cliffswing_salazar_flight, true );
	
	// Wingsuit flight
	add_scene( "harper_fwd_idle", undefined, false, false, true, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_02_01_squirrelflight_fwd_idle, true );
	
	add_scene( "salazar_fwd_idle", undefined, false, false, true, true  );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_01_squirrelflight_fwd_idle, true );
	
	add_scene( "harper_slowdown_idle", undefined, false, false, true, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_02_01_squirrelflight_slowdown_idle, true );
	
	add_scene( "salazar_slowdown_idle", undefined, false, false, true, true  );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_01_squirrelflight_slowdown_idle, true );
	
	add_scene( "harper_speedup_idle", undefined, false, false, true, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_02_01_squirrelflight_speedup_idle, true );
	
	add_scene( "salazar_speedup_idle", undefined, false, false, true, true  );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_01_squirrelflight_speedup_idle, true );
	
	add_scene( "harper_turnleft_idle", undefined, false, false, true, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_02_01_squirrelflight_turnleft_idle, true );
	
	add_scene( "salazar_turnleft_idle", undefined, false, false, true, true  );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_01_squirrelflight_turnleft_idle, true );
	
	add_scene( "harper_turnright_idle", undefined, false, false, true, true  );
	add_actor_anim( "harper", %generic_human::ch_mon_02_01_squirrelflight_turnright_idle, true );
	
	add_scene( "salazar_turnright_idle", undefined, false, false, true, true  );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_01_squirrelflight_turnright_idle, true );
	
	// Landing
	add_scene( "wingsuit_landing_player", "landing_harper" );
	add_player_anim( "player_body", %player::p_mon_02_04_flight, true );
	
	add_scene( "wingsuit_landing_harper", "landing_harper" );
	add_actor_anim( "harper", %generic_human::ch_mon_02_04_flight_harper, false, true );
	
	add_scene( "wingsuit_landing_harper_loop", "landing_harper", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_02_04_landing_harper_nag );
		
	// Camo Intro
	add_scene( "camo_intro_player", "landing_harper" );
	add_actor_anim( "harper", %generic_human::ch_mon_02_04_landing_harper, false, true );
	add_player_anim( "player_body", %player::p_mon_02_04_landing, true );
	
	add_scene( "camo_intro_enemy", "landing_harper" );
	add_actor_anim( "lz_patroller_1", %generic_human::ch_mon_02_04_landing_patrol_01 );
	add_actor_anim( "lz_patroller_2", %generic_human::ch_mon_02_04_landing_patrol_02 );
	add_actor_anim( "lz_invisible_patroller", %generic_human::ch_mon_02_04_landing_invisible_patrol );
	add_notetrack_flag( "lz_patroller_2", "invisible", "predator_ai_suit_on" );
	
	add_scene( "camo_intro_squad", "landing_harper" );
	add_actor_anim( "salazar", %generic_human::ch_mon_02_04_landing_jumper_01, false, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_02_04_landing_jumper_02, false, true );	
}

ruins_anims()
{
	level.scr_anim[ "generic" ][ "camo_stealth_loop_1" ][ 0 ] = %ch_mon_04_01_camo_battle_intro_tent_guy_cycle_01;
	level.scr_anim[ "generic" ][ "camo_stealth_react_1" ] = %ch_mon_04_01_camo_battle_intro_tent_guy_reaction_01;	
	level.scr_anim[ "generic" ][ "camo_stealth_loop_2" ][ 0 ] = %ch_mon_04_01_camo_battle_intro_tent_guy_cycle_02;
	level.scr_anim[ "generic" ][ "camo_stealth_react_2" ] = %ch_mon_04_01_camo_battle_intro_tent_guy_reaction_02;	
	level.scr_anim[ "generic" ][ "camo_stealth_loop_3" ][ 0 ] = %ch_mon_04_01_camo_battle_intro_tent_guy_cycle_03;
	level.scr_anim[ "generic" ][ "camo_stealth_react_3" ] = %ch_mon_04_01_camo_battle_intro_tent_guy_reaction_03;
	level.scr_anim[ "generic" ][ "camo_stealth_loop_4" ][ 0 ] = %ch_mon_04_01_camo_battle_intro_unpacking_guy_cycle_01;
	level.scr_anim[ "generic" ][ "camo_stealth_react_4" ] = %ch_mon_04_01_camo_battle_intro_unpacking_guy_reaction_01;	
	
	add_scene( "salazar_shoots_heli", "salazar_shoots_heli" );
	add_actor_anim( "salazar", %generic_human::ch_mon_04_02_salazar_shoots_helicopter_intro_salazar );
	add_actor_anim( "harper", %generic_human::ch_mon_04_02_salazar_shoots_helicopter_intro_harper );
	add_notetrack_custom_function( "salazar", "fire", maps\monsoon_ruins::helipad_battle_salazar_titus );
	
	add_scene( "heli_turret_retreat", "ruins_guard_house_entrance" );
	add_actor_anim( "heli_retreat", %generic_human::ch_mon_04_04_turret_react_soldier );
	
	//EMP sequence
	add_scene( "harper_emp_intro", "mudslide_center_1", true );
	add_actor_anim( "harper", %generic_human::ch_mon_05_04_helicopter_battle_harper_approach );
	
	add_scene( "harper_emp_loop", "mudslide_center_1", true, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_05_04_helicopter_battle_harper_idle02 );
	
	add_scene( "equip_emp", "mudslide_center_1" );
	add_actor_anim( "harper", %generic_human::ch_mon_05_04_helicopter_battle_harper_give_grenade );
	add_player_anim( "player_body", %player::p_mon_05_04_helicopter_battle_player_take_grenade, true );
		
	add_scene( "salazar_door_loop", "main_doors", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_05_08_main_doors_salazar_cycle );
	
	add_scene( "crosby_door_loop", "main_doors", false, false, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_05_08_main_doors_redshirt_cycle );
	
	add_scene( "harper_door_intro", "main_doors" );
	add_actor_anim( "harper", %generic_human::ch_mon_05_08_main_doors_hudson_intro );
	
	add_scene( "harper_door_loop", "main_doors", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_05_08_main_doors_hudson_cycle );
	
	add_scene( "harper_door_shoots", "main_doors" );
	add_actor_anim( "harper", %generic_human::ch_mon_05_08_main_doors_hudson_hudsonhasgun );
	add_notetrack_custom_function( "harper", "fire_titus", maps\monsoon_ruins::inner_ruins_harper_titus );
				
	add_scene( "harper_door_player", "main_doors" );
	add_actor_anim( "harper", %generic_human::ch_mon_05_08_main_doors_hudson_playerhasgun );
	
	add_scene( "salazar_enter_door", "main_doors" );
	add_actor_anim( "salazar", %generic_human::ch_mon_05_08_main_doors_salazar_outro );
	
	add_scene( "crosby_enter_door", "main_doors" );
	add_actor_anim( "crosby", %generic_human::ch_mon_05_08_main_doors_redshirt_outro );
	
	add_scene( "harper_enter_door", "main_doors" );
	add_actor_anim( "harper", %generic_human::ch_mon_05_08_main_doors_hudson_outro );
	
	add_scene( "ruin_collapse_death_left", undefined, false, true, false, true );
	add_actor_anim( "generic", %generic_human::ch_mon_05_07_mudslide_ai_tower_death );	
	
	add_scene( "ruin_collapse_death_right", undefined, false, true, false, true );
	add_actor_anim( "generic", %generic_human::ch_mon_05_07_mudslide_ai_tower_death_right );
	
	// near heli crash wounded
	add_scene( "post_heli_death_wall", "post_heli_death_wall", false, false, true );
	add_actor_anim( "heli_wounded_1", %generic_human::ch_gen_m_wall_rightleg_wounded );

	add_scene( "post_heli_death_leg", "post_heli_death_leg", false, false, true );
	add_actor_anim( "heli_wounded_2", %generic_human::ch_gen_m_floor_leftleg_wounded );
	
	add_scene( "post_heli_death_head", "post_heli_death_head", false, false, true );
	add_actor_anim( "heli_wounded_3", %generic_human::ch_gen_m_floor_head_wounded );
}

lab_entrance_anims()
{		
	add_scene( "salazar_lab_entry_intro", "lab_entrance", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_06_03_lab_entry_salazar_intro );	
	
	add_scene( "salazar_lab_entry_loop", "lab_entrance", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_06_03_lab_entry_salazar_cycle );	
	
	add_scene( "salazar_lab_entry_exit", "lab_entrance" );
	add_actor_anim( "salazar", %generic_human::ch_mon_06_03_lab_entry_salazar_exit );		
}

asd_intro_anims()
{
	//Clean Room Door
	add_scene( "asd_intro_harper_intro", "asd_intro", true );
	add_actor_anim( "harper", %generic_human::ch_mon_07_01_ASD_intro_harper_intro );
	
	add_scene( "asd_intro_harper_loop", "asd_intro", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_07_01_ASD_intro_harper_cycle );
	
	add_scene( "asd_intro_crosby_intro", "asd_intro", true );
	add_actor_anim( "crosby", %generic_human::ch_mon_07_01_ASD_intro_redshirt_intro );	

	add_scene( "asd_intro_crosby_loop", "asd_intro", false, false, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_07_01_ASD_intro_redshirt_cycle );
	
	add_scene( "asd_intro_salazar_intro", "asd_intro", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_07_01_ASD_intro_salazar_intro );
	
	add_scene( "asd_intro_salazar_loop", "asd_intro", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_07_01_ASD_intro_salazar_cycle );

	//ASD Intro
	add_scene( "asd_intro_player_intro", "asd_intro" );
	add_player_anim( "player_body", %player::p_mon_07_01_ASD_intro, true );
	add_notetrack_custom_function( "player_body", "shatter_glass", maps\monsoon_lab::destory_asd_window );
	add_notetrack_exploder( "player_body", "shatter_glass", 1250 );
	
	add_scene( "asd_intro_harper_int_player", "asd_intro" );
	add_actor_anim( "harper", %generic_human::ch_mon_07_01_ASD_intro_harper_interaction_with_player );
	add_notetrack_custom_function( "harper", "grenade_explodes", maps\monsoon_lab::asd_grenade_defense );
	
	//lab_cover_flip_1
	add_scene( "harper_railing_throw", "lab_harper_flip" );
	add_actor_anim( "harper", %generic_human::ch_mon_08_01_harper_flip_death_harper );
	add_actor_anim( "railing_guy", %generic_human::ch_mon_08_01_harper_flip_death_soldier, true, false, false, true );
	
	add_scene( "stair_tumble_death", "lab_stair_tumble" );
	add_actor_anim( "stair_tumble_guy", %generic_human::ch_mon_08_01_lab_stair_tumble_death, true, false, false, true );
	
	add_scene( "window_jumper_1", "lab_window_jump", true );
	add_actor_anim( "window_jump_guy1", %generic_human::ch_mon_08_01_window_jump_entrance_soldier01 );

	add_scene( "window_jumper_2", "lab_window_jump", true );
	add_actor_anim( "window_jump_guy2", %generic_human::ch_mon_08_01_window_jump_entrance_soldier02 );

	//elevator anims
	add_scene( "harper_elevator_enter", "elevator_regroup", true );
	add_actor_anim( "harper", %generic_human::ch_mon_08_02_elevator_regroup_harper_enter, false, false, false, false, "tag_origin" );
	
	add_scene( "harper_elevator_idle", "elevator_regroup", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_08_02_elevator_regroup_harper_idle, false, false, false, false, "tag_origin" );
	
	add_scene( "harper_elevator_exit", "elevator_regroup" );
	add_actor_anim( "harper", %generic_human::ch_mon_08_02_elevator_regroup_harper_exit, false, false, false, false, "tag_origin" );
	
	add_scene( "harper_elevator_loop", "lift_bottom_align", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_08_02_elevator_regroup_harper_idle_2 );	
	
	add_scene( "harper_elevator_fire", "lift_bottom_align" );
	add_actor_anim( "harper", %generic_human::ch_mon_08_02_elevator_regroup_harper_fire );	
	add_notetrack_custom_function( "harper", "fire_titus", maps\monsoon_lab::harper_titus_asd );
	
	add_scene( "salazar_elevator_enter", "elevator_regroup", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_08_02_elevator_regroup_salazar_enter, false, false, false, false, "tag_origin" );
	
	add_scene( "salazar_elevator_idle", "elevator_regroup", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_08_02_elevator_regroup_salazar_idle, false, false, false, false, "tag_origin" );
	
	add_scene( "salazar_elevator_exit", "elevator_regroup" );
	add_actor_anim( "salazar", %generic_human::ch_mon_08_02_elevator_regroup_salazar_exit, false, false, false, false, "tag_origin" );	
	
	add_scene( "crosby_elevator_enter", "elevator_regroup", true );
	add_actor_anim( "crosby", %generic_human::ch_mon_08_02_elevator_regroup_crosby_enter, false, false, false, false, "tag_origin" );
	
	add_scene( "crosby_elevator_idle", "elevator_regroup", false, false, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_08_02_elevator_regroup_crosby_idle, false, false, false, false, "tag_origin" );
	
	add_scene( "crosby_elevator_exit", "elevator_regroup" );
	add_actor_anim( "crosby", %generic_human::ch_mon_08_02_elevator_regroup_crosby_exit, false, false, false, false, "tag_origin" );		
	
	add_scene( "player_lift_interact", "elevator_regroup" );
	add_player_anim( "player_body", %player::p_mon_08_02_elevator_regroup_panel, true );
}

lab_defend_anims()
{
	//approach to console
	add_scene( "harper_console_approach", "celerium_door", true );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_01_isaac_defend_harper_console_approach );
	
	add_scene( "crosby_console_approach", "celerium_door", true );	
	add_actor_anim( "crosby", %generic_human::ch_mon_09_01_isaac_defend_crosby_console_approach );
	
	add_scene( "salazar_console_approach", "celerium_door", true );	
	add_actor_anim( "salazar", %generic_human::ch_mon_09_01_isaac_defend_salazar_console_approach );	
	
//	add_scene( "isaac_console_approach", "celerium_door" );	
//	add_actor_anim( "isaac", %generic_human::ch_mon_09_01_isaac_defend_isaac_console_approach, true );
	
	//idle at console
	add_scene( "harper_console_loop", "celerium_door", false, false, true );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_01_isaac_defend_harper_console_loop );
	
	add_scene( "crosby_console_loop", "celerium_door", false, false, true );	
	add_actor_anim( "crosby", %generic_human::ch_mon_09_01_isaac_defend_crosby_console_loop );
	
	add_scene( "salazar_console_loop", "celerium_door", false, false, true );	
	add_actor_anim( "salazar", %generic_human::ch_mon_09_01_isaac_defend_salazar_console_loop );
	
	add_scene( "isaac_console_loop", "celerium_door", false, false, true );	
	add_actor_anim( "isaac", %generic_human::ch_mon_09_01_isaac_defend_isaac_console_loop, true );

	//approach to isaac from console
	add_scene( "lab_defend_approach_isaac", "celerium_door" );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_01_isaac_defend_harper_approach_isaac );
	add_actor_anim( "crosby", %generic_human::ch_mon_09_01_isaac_defend_crosby_approach_isaac );
	add_actor_anim( "salazar", %generic_human::ch_mon_09_01_isaac_defend_salazar_approach_isaac );	
//	add_actor_anim( "isaac", %generic_human::ch_mon_09_01_isaac_defend_isaac_approach_isaac, true );
	
	add_scene( "lab_defend_player_loop", "celerium_door", false, false, true );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_01_isaac_defend_harper_player_loop );
	add_actor_anim( "crosby", %generic_human::ch_mon_09_01_isaac_defend_crosby_player_loop );
	add_actor_anim( "salazar", %generic_human::ch_mon_09_01_isaac_defend_salazar_player_loop );		
	//add_actor_anim( "isaac", %generic_human::ch_mon_09_01_isaac_defend_isaac_player_loop, true );
	
	add_scene( "player_isaac_interact", "celerium_door" );
	add_player_anim( "player_body", %player::p_mon_09_01_isaac_defend_player_end, true );
	
	add_scene( "lab_defend_end", "celerium_door" );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_01_isaac_defend_harper_end );
	add_actor_anim( "crosby", %generic_human::ch_mon_09_01_isaac_defend_crosby_end );
	add_actor_anim( "salazar", %generic_human::ch_mon_09_01_isaac_defend_salazar_end );	
	add_actor_anim( "isaac", %generic_human::ch_mon_09_01_isaac_defend_isaac_end, true );

	add_scene( "isaac_hack_loop", "celerium_door", false, false, true );
	add_actor_anim( "isaac", %generic_human::ch_mon_09_04_codes_isaac_loop, true );
	
	add_scene( "isaac_hack_reaction", "celerium_door" );
	add_actor_anim( "isaac", %generic_human::ch_mon_09_04_codes_isaac_wounded, true );	
	
	add_scene( "isaac_hack_death", "celerium_door" );
	add_actor_anim( "isaac", %generic_human::ch_mon_09_04_codes_isaac_death, true );

	add_scene( "salazar_hack_approach", "celerium_door", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_09_04_codes_salazar_approach );
	
	add_scene( "salazar_hack_loop", "celerium_door", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_09_04_codes_salazar_loop );	
	
	// Shield animations
	add_scene( "harper_shield_plant", "celerium_door", true );	
	add_actor_anim( "harper", %generic_human::ch_mon_09_04_codes_harper );	
	add_prop_anim( "harper_shield", %animated_props::o_mon_09_04_codes_shield, "t6_wpn_shield_carry_world" );	
	
	add_scene( "player_shield_grab", "celerium_door" );	
	add_player_anim( "player_body", %player::p_mon_09_04_codes_grab_riotshield, true );	
	
	add_scene( "player_defend_shield", "celerium_door" );	
	add_prop_anim( "player_shield", %animated_props::o_mon_09_04_codes_player_shield, "t6_wpn_shield_carry_world", true );	
	
	// player death from nitrogen destructibles
	add_scene( "player_nitrogen_death", undefined, false, false, false, true );	
	add_player_anim( "player_body", %player::p_mon_09_02_nitrogen_death );
}

celerium_chamber_anims()
{
	//isaac celerium doors
	add_scene( "isaac_celerium_door_approach", "celerium_door" );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_01_celerium_door_isaac_approach, true );	
	
	add_scene( "isaac_celerium_door_loop", "celerium_door", false, false, true );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_01_celerium_door_isaac_loop, true );
	
	add_scene( "isaac_celerium_door_open", "celerium_door" );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_01_celerium_door_isaac_open, true );	
	
	//salazar celerium doors
	add_scene( "salazar_celerium_door_approach", "celerium_door", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_01_celerium_door_salazar_approach );
	
	add_scene( "salazar_celerium_door_loop", "celerium_door", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_01_celerium_door_salazar_loop );
	
	add_scene( "salazar_celerium_door_open", "celerium_door" );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_01_celerium_door_salazar_open );	
	
	//player celerium doors
	add_scene( "player_celerium_door_open", "celerium_door" );
	add_player_anim( "player_body", %player::p_mon_10_01_celerium_door_player, true );
	add_notetrack_flag( "player_body", "start_door", "player_triggered_celerium_door" );
	
	//isaac celerium chip
	add_scene( "isaac_celerium_approach", "celerium_chip_chamber", true );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_02_celerium_chamber_issac_approach, true );
	
	add_scene( "isaac_celerium_loop", "celerium_chip_chamber", false, false, true );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_02_celerium_chamber_issac_idle, true );
	
	add_scene( "isaac_celerium_end", "celerium_chip_chamber" );
	add_actor_anim( "isaac", %generic_human::ch_mon_10_02_celerium_chamber_issac_end, true );
	
	//isaacs chip
	//add_scene( "isaac_celerium_chip_end", "celerium_chip_chamber" );
	//add_prop_anim( "celerium_chip", %animated_props::o_mon_10_02_celerium_chamber_chip, "p6_celerium_chip", false, true );
	
	//salazar celerium chip
	add_scene( "salazar_celerium_approach", "celerium_chip_chamber", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_approach );
	
	add_scene( "salazar_celerium_loop", "celerium_chip_chamber", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_idle );
	
	add_scene( "salazar_celerium_end", "celerium_chip_chamber" );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_end );
	
	//salazar alts celerium chip
	add_scene( "salazar_celerium_approach_alt", "celerium_chip_chamber", true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_approach_alt );	
	
	add_scene( "salazar_celerium_loop_alt", "celerium_chip_chamber", false, false, true );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_idle_alt );	
	
	add_scene( "salazar_celerium_end_alt", "celerium_chip_chamber" );
	add_actor_anim( "salazar", %generic_human::ch_mon_10_02_celerium_chamber_salazar_end_alt );
	
	//add_scene( "salazar_celerium_chip_end_alt", "celerium_chip_chamber" );
	//add_prop_anim( "celerium_chip", %animated_props::o_mon_10_02_celerium_chamber_chip_alt, "p6_celerium_chip", false, true );
	
	//harper celerium chip
	add_scene( "harper_celerium_approach", "celerium_chip_chamber", true );
	add_actor_anim( "harper", %generic_human::ch_mon_10_02_celerium_chamber_harper_approach );
	
	add_scene( "harper_celerium_loop", "celerium_chip_chamber", false, false, true );
	add_actor_anim( "harper", %generic_human::ch_mon_10_02_celerium_chamber_harper_idle );
	
	add_scene( "harper_celerium_end", "celerium_chip_chamber" );
	add_actor_anim( "harper", %generic_human::ch_mon_10_02_celerium_chamber_harper_end );
	
	//crosby celerium chip
	add_scene( "crosby_celerium_approach", "celerium_chip_chamber", true );
	add_actor_anim( "crosby", %generic_human::ch_mon_10_02_celerium_chamber_crosby_approach );
	
	add_scene( "crosby_celerium_loop", "celerium_chip_chamber", false, false, true );
	add_actor_anim( "crosby", %generic_human::ch_mon_10_02_celerium_chamber_crosby_idle );
	
	add_scene( "crosby_celerium_end", "celerium_chip_chamber" );
	add_actor_anim( "crosby", %generic_human::ch_mon_10_02_celerium_chamber_crosby_end );	
	
	//player celerium chip
	//ending for player if isaac LIVES
	//add_scene( "player_celerium_chip_end_isaac", "celerium_chip_chamber" );
	//add_player_anim( "player_body", %player::p_mon_10_02_celerium_chamber_isaac_condition );
	
	add_scene( "salazar_celerium_chip_init", "celerium_chip_chamber" );
	add_prop_anim( "celerium_chip", %animated_props::o_mon_10_02_celerium_chamber_chip, "p6_celerium_chip", false, true );
	
	//ending for player if isaac DIES
	add_scene( "player_celerium_chip_end", "celerium_chip_chamber" );
	add_player_anim( "player_body", %player::p_mon_10_02_celerium_chamber_salazar_condition );	
	add_prop_anim( "celerium_chip", %animated_props::o_mon_10_02_celerium_chamber_chip, "p6_celerium_chip", false, true );
}