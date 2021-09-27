#include maps\_anim;
#include maps\_shg_fx;
#include maps\_utility;
#include common_scripts\utility;

main_anim()
{
	player_anims();
	generic_human();
	drone_anim();
	drone_cycles();
	vehicle_anims();
	script_model_anims();
}

#using_animtree( "player" );
player_anims()
{
	level.scr_model[ "player_rig_juggernaut" ] 						= "viewhands_player_juggernaut_ally";
	level.scr_animtree[ "player_rig_juggernaut" ] = #animtree;
	level.scr_model[ "player_rig" ] 						= "viewhands_player_pmc";
	level.scr_animtree[ "player_rig" ] = #animtree;
	level.scr_model[ "player_legs" ] 						= "viewlegs_juggernaut";
	level.scr_animtree[ "player_legs" ] = #animtree;
	
	// INTRO
	level.scr_anim[ "player_rig_juggernaut" ][ "intro" ] = %dubai_intro_player;
	
	
	// ELEVATOR
	level.scr_anim[ "player_rig_juggernaut" ][ "remove_gear_player" ] = %dubai_removing_grear_player;
	level.scr_anim[ "player_rig" ][ "remove_gear_player_2" ] = %dubai_removing_grear_player_2;
	
	level.scr_anim[ "player_rig" ][ "elevator_jump_player" ] = %dubai_jump_to_elevator_player;
	level.scr_anim[ "player_rig" ][ "elevator_jump_player_early" ] = %dubai_jump_to_elevator_early_player;
	
	// RESTAURANT
	level.scr_anim[ "player_rig" ][ "restaurant_destruction" ] = %dubai_restaurant_player_view;

	// FINALE	
	level.scr_anim[ "player_rig" ][ "helo_jump_1" ] = %dubai_helo_jump_player_1;
	level.scr_anim[ "player_rig" ][ "helo_jump_2" ] = %dubai_helo_jump_player_2;
	level.scr_anim[ "player_rig" ][ "helo_jump_3" ] = %dubai_helo_jump_player_3;
	level.scr_anim[ "player_rig" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_player_kick_fail;
	level.scr_anim[ "player_rig" ][ "helo_jump_stab_fail" ] = %dubai_helo_jump_player_stab_fail;
	level.scr_anim[ "player_legs" ][ "helo_jump_1" ] = %dubai_helo_jump_player_leg_1;
	level.scr_anim[ "player_legs" ][ "helo_jump_2" ] = %dubai_helo_jump_player_leg_2;
	level.scr_anim[ "player_legs" ][ "helo_jump_3" ] = %dubai_helo_jump_player_leg_3;
	level.scr_anim[ "player_legs" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_player_leg_kick_fail;

	level.scr_anim[ "player_rig" ][ "helo_jump_idle" ] = %dubai_helo_jump_player_idle;
	level.scr_anim[ "player_rig" ][ "helo_jump_middle" ] = %dubai_helo_jump_player_middle;
	level.scr_anim[ "player_rig" ][ "helo_jump_pull" ] = %dubai_helo_jump_player_pull;
	level.scr_anim[ "player_rig" ][ "helo_jump_push" ] = %dubai_helo_jump_player_push;
	level.scr_anim[ "player_rig" ][ "helo_jump_left" ] = %dubai_helo_jump_player_left;
	level.scr_anim[ "player_rig" ][ "helo_jump_right" ] = %dubai_helo_jump_player_right;

	level.scr_anim[ "player_rig" ][ "finale_wake" ] = %dubai_finale_wake_player;
	level.scr_anim[ "player_rig" ][ "finale_wake_idle" ][ 0 ] = %dubai_finale_wake_idle_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl01" ] = %dubai_finale_crawl01_player;
	level.scr_anim[ "player_rig" ][ "finale_fail_crawl01" ] = %dubai_finale_fail_crawl01_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl01_idle" ][ 0 ] = %dubai_finale_crawl01_idle_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl02" ] = %dubai_finale_crawl02_player;
	level.scr_anim[ "player_rig" ][ "finale_fail_crawl02" ] = %dubai_finale_fail_crawl02_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl02_idle" ][ 0 ] = %dubai_finale_crawl02_idle_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl03" ] = %dubai_finale_crawl03_player;
	level.scr_anim[ "player_rig" ][ "finale_fail_crawl03" ] = %dubai_finale_fail_crawl03_player;
	level.scr_anim[ "player_rig" ][ "finale_crawl03_idle" ][ 0 ] = %dubai_finale_crawl03_idle_player;
	level.scr_anim[ "player_rig" ][ "finale_draw" ] = %dubai_finale_draw_player;
	level.scr_anim[ "player_rig" ][ "finale_draw_fail" ] = %dubai_finale_draw_fail_player;
	level.scr_anim[ "player_rig" ][ "finale_draw_fail_blend" ][0] = %dubai_finale_draw_fail_blend_player;
	level.scr_anim[ "player_rig" ][ "finale_draw_fail_blend" ][1] = %dubai_finale_draw_fail_blend_look_player;
	level.scr_anim[ "player_rig" ][ "finale_showdown" ] = %dubai_finale_showdown_player;
	addNotetrack_customFunction( "player_rig", "fx_start_nose_bleed", ::fx_start_nose_bleed, "finale_wake" );
	addNotetrack_customFunction( "player_rig", "fx_shift_focus", ::fx_shift_focus, "finale_wake" );
	//addNotetrack_customFunction( "player_rig", "fx_stop_nose_bleed", ::fx_start_nose_bleed, "finale_wake" );
	
	level.scr_anim[ "player_rig" ][ "beatdown_idle_1" ][0] = %dubai_final_beatdown_player_idle_1;
	level.scr_anim[ "player_rig" ][ "beatdown_idle_1_look" ] = %dubai_final_beatdown_player_idle_1_look;
	level.scr_anim[ "player_rig" ][ "beatdown_idle_2_getup" ] = %dubai_final_beatdown_player_idle_2_getup;
	level.scr_anim[ "player_rig" ][ "beatdown_getup_idle" ][0] = %dubai_final_beatdown_player_getup_idle;
	level.scr_anim[ "player_rig" ][ "beatdown_tackle_start" ] = %dubai_final_beatdown_player_tackle_start;
	level.scr_anim[ "player_rig" ][ "beatdown_tackle" ] = %dubai_final_beatdown_player_tackle;
	level.scr_anim[ "player_rig" ][ "beatdown_tackle_alt" ] = %dubai_final_beatdown_player_tackle_alt;
	level.scr_anim[ "player_rig" ][ "beatdown_fail_2" ] = %dubai_final_beatdown_player_fail_2;
	
	addNotetrack_customFunction( "player_rig", "crack0", ::skylight_crack0_vfx, "beatdown_tackle" );
	
	level.scr_anim[ "player_rig" ][ "beatdown_choke" ] = %dubai_final_beatdown_player_choke;
	level.scr_anim[ "player_rig" ][ "beatdown_slam" ] = %dubai_final_beatdown_player_slam;
	
	addNotetrack_customFunction( "player_rig", "crack1", ::skylight_crack1_vfx, "beatdown_slam" );
	addNotetrack_customFunction( "player_rig", "crack2", ::skylight_crack2_vfx, "beatdown_slam" );
	
	level.scr_anim[ "player_rig" ][ "beatdown_smoking_idle" ] = %dubai_final_beatdown_player_smoking_idle;
	level.scr_anim[ "player_rig" ][ "beatdown_end" ] = %dubai_final_beatdown_player_end;
	level.scr_anim[ "player_rig" ][ "beatdown_fail" ] = %dubai_final_beatdown_player_fail;
	level.scr_anim[ "player_rig" ][ "beatdown_additive" ] = %dubai_final_beatdown_player_additive;

	level.scr_anim[ "player_rig" ][ "beatdown_fail" ] = %dubai_final_beatdown_player_fail;
	
	level.scr_anim[ "player_rig" ][ "finale_reflection" ] = %dubai_finale_reflection_player;
}

#using_animtree( "generic_human" );
generic_human()
{
	// INTRO
	level.scr_model[ "player_body_jugg" ] = "fullbody_juggernaut";
	level.scr_animtree[ "player_body_jugg" ] = #animtree;
	level.scr_anim[ "player_body_jugg" ][ "intro" ] = %dubai_intro_player_body;
	
	level.scr_model[ "player_body" ] = "body_juggernaut_nogear";
	level.scr_animtree[ "player_body" ] = #animtree;
	level.scr_anim[ "player_body" ][ "restaurant_destruction" ] = %dubai_restaurant_player_body;
	level.scr_anim[ "player_body" ][ "beatdown_slam" ] = %dubai_final_beatdown_playerbody_slam;
	level.scr_anim[ "player_body" ][ "beatdown_smoking_idle" ] = %dubai_final_beatdown_playerbody_smoking_idle;
	level.scr_anim[ "player_body" ][ "beatdown_end" ] = %dubai_final_beatdown_playerbody_end;
	addnotetrack_flag( "player_body", "yuri_idle", "restaurant_destruction_player_over_ledge", "restaurant_destruction" );
	addnotetrack_flag( "player_body", "rolling_soldier_start", "restaurant_destruction_rolling_soldier", "restaurant_destruction" );
	addnotetrack_flag( "player_body", "floor_done_tilting", "restaurant_destruction_floor_done", "restaurant_destruction" );
	
	level.scr_anim[ "generic" ][ "intro_guy1_death" ]			 		= %dubai_intro_guy1_death;
	level.scr_anim[ "generic" ][ "intro_guy2_death" ]			 		= %dubai_intro_guy2_death;
	level.scr_anim[ "generic" ][ "intro_guy3_death" ]			 		= %dubai_intro_guy3_death;
	level.scr_anim[ "generic" ][ "intro_guy4_death" ]			 		= %dubai_intro_guy4_death;
	level.scr_anim[ "generic" ][ "intro_guy5_death" ]			 		= %dubai_intro_guy5_death;
	level.scr_anim[ "generic" ][ "intro_guy6_death" ]			 		= %dubai_intro_guy6_death;
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy1_death" );
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy2_death" );
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy3_death" );
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy4_death" );
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy5_death" );
	addNotetrack_customFunction( "generic", "start_ragdoll", ::ai_kill, "intro_guy6_death" );
	
	level.scr_anim[ "generic" ][ "exterior_juggernaut_paired" ] = %dubai_juggernaut_paired_guy2;
	addNotetrack_customFunction( "generic", "ignoreall", ::ignore_all, "exterior_juggernaut_paired" );
	addNotetrack_customFunction( "generic", "dropgun", ::ai_kill, "exterior_juggernaut_paired" );
	addNotetrack_customFunction( "generic", "blood", ::blood_vfx, "exterior_juggernaut_paired" );
	
	level.scr_anim[ "generic" ][ "restaurant_rolling_soldier" ] = %dubai_restaurant_rolling_soldier;
	
	/*######################
	#######YURI ANIMS#######
	######################*/
	level.scr_anim[ "yuri" ][ "intro_yuri" ] = %dubai_intro_price;
	addnotetrack_flag( "yuri", "dialog_intro", "vo_intro_start", "intro_yuri" );
	addnotetrack_flag( "yuri", "dialog_getready", "vo_intro_get_ready", "intro_yuri" );
	addnotetrack_flag( "yuri", "ram_door", "intro_truck_left", "intro_yuri" );
	
	level.scr_anim[ "yuri" ][ "exterior_juggernaut_paired" ] = %dubai_juggernaut_paired_guy1;
	
	level.scr_anim[ "yuri" ][ "elevator_enter" ] = %dubai_jugg_elevator_enter;
	level.scr_anim[ "yuri" ][ "elevator_enter_idle" ][0] = %dubai_jugg_elevator_idle;
	level.scr_anim[ "yuri" ][ "elevator_press_button" ] = %dubai_jugg_elevator_button;
	level.scr_anim[ "yuri" ][ "elevator_idle_scan" ][0] = %dubai_jugg_elevator_idle_scan;
	
	level.scr_anim[ "yuri" ][ "chopper_react" ] = %dubai_helo_react_price;
	level.scr_anim[ "yuri" ][ "remove_gear" ] = %dubai_removing_grear_price;
	level.scr_anim[ "yuri" ][ "remove_gear_2" ] = %dubai_removing_grear_price_2;
	
	level.scr_face[ "yuri" ][ "dubai_pri_shredded" ] = %dubai_removing_grear_price_face;
	
	level.scr_anim[ "yuri" ][ "elevator_jump" ] = %dubai_jump_to_elevator_guy1;
	level.scr_anim[ "yuri" ][ "elevator_jump_idle" ] = %dubai_jump_to_elevator_guy1_idle;
	
	level.scr_anim[ "yuri" ][ "elevator_idle_post_jump" ][0] = %dubai_npc_elevator_idle;
	level.scr_anim[ "yuri" ][ "elevator_grenade_throw" ]			= %dubai_npc_elevator_exit;
	
	level.scr_anim[ "yuri" ][ "restaurant_wounded" ]			= %dubai_restaurant_yuri_start;
	level.scr_face[ "yuri" ][ "dubai_yur_dontlethim" ] = %dubai_restaurant_yuri_start_facial;
	level.scr_anim[ "yuri" ][ "restaurant_idle" ][0]			= %dubai_restaurant_yuri_idle;
	
	level.scr_anim[ "yuri" ][ "finale_showdown" ] = %dubai_finale_showdown_yuri;
	addNotetrack_customFunction( "yuri", "dropgun", ::finale_yuri_death, "finale_showdown" );
	
	/*######################
	######MAKAROV ANIMS#####
	######################*/
	level.scr_model[ "makarov" ] = "body_villain_makarov_prague";
	level.scr_animtree[ "makarov" ] = #animtree;
	
	level.scr_anim[ "makarov" ][ "helo_jump_1" ] = %dubai_helo_jump_makarov;
	level.scr_anim[ "makarov" ][ "helo_jump_idle" ][ 0 ] = %dubai_helo_jump_makarov_idle;
	level.scr_anim[ "makarov" ][ "helo_jump_idle_nl" ] = %dubai_helo_jump_makarov_idle;
	level.scr_anim[ "makarov" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_makarov_kick_fail;

	level.scr_anim[ "makarov" ][ "finale_wake" ] = %dubai_finale_wake_makarov;
	level.scr_anim[ "makarov" ][ "finale_wake_idle" ][ 0 ] = %dubai_finale_wake_idle_makarov;
	level.scr_anim[ "makarov" ][ "finale_showdown" ] = %dubai_finale_showdown_makarov;
	level.scr_anim[ "makarov" ][ "finale_draw" ] = %dubai_finale_draw_makarov;
	level.scr_anim[ "makarov" ][ "finale_draw_fail" ] = %dubai_finale_draw_fail_makarov03;

	level.scr_anim[ "makarov" ][ "finale_draw_fail_blend" ][0] = %dubai_finale_draw_fail_blend_makarov03;
	level.scr_anim[ "makarov" ][ "finale_draw_fail_blend" ][1] = %dubai_finale_draw_fail_blend_makarov_down;
	level.scr_anim[ "makarov" ][ "finale_draw_fail_blend" ][2] = %dubai_finale_draw_fail_blend_makarov_up;
	level.scr_anim[ "makarov" ][ "finale_draw_fail_blend" ][3] = %dubai_finale_draw_fail_blend_makarov_left;
	level.scr_anim[ "makarov" ][ "finale_draw_fail_blend" ][4] = %dubai_finale_draw_fail_blend_makarov_right;

	level.scr_anim[ "makarov" ][ "beatdown_idle_0" ][0]	= %dubai_final_beatdown_makarov_idle_2;
	level.scr_anim[ "makarov" ][ "beatdown_idle_1" ]	= %dubai_final_beatdown_makarov_idle_1;
	level.scr_anim[ "makarov" ][ "beatdown_tackle" ] = %dubai_final_beatdown_makarov_tackle;
	level.scr_anim[ "makarov" ][ "beatdown_choke" ] = %dubai_final_beatdown_makarov_choke;
	level.scr_anim[ "makarov" ][ "beatdown_slam" ] = %dubai_final_beatdown_makarov_slam;
	level.scr_anim[ "makarov" ][ "beatdown_fail_2" ] = %dubai_final_beatdown_makarov_fail_2;
	level.scr_anim[ "makarov" ][ "beatdown_hanging_idle" ][0] = %dubai_final_beatdown_makarov_hanging_idle;
	addNotetrack_customFunction( "makarov", "punch_r", ::makarov_punch_r_vfx, "beatdown_tackle" );
	addNotetrack_customFunction( "makarov", "punch_r2", ::makarov_punch_r2_vfx, "beatdown_tackle" );
	addNotetrack_customFunction( "makarov", "punch_l", ::makarov_punch_l_vfx, "beatdown_tackle" );
	addNotetrack_customFunction( "makarov", "pistol_fire", ::fx_makarov_pistol_fire, "finale_draw_fail" );
	addNotetrack_customFunction( "makarov", "pistol_fire", ::fx_makarov_pistol_fire, "finale_draw_fail_blend" );
	addNotetrack_customFunction( "makarov", "pistol_fire", ::fx_makarov_pistol_fire, "beatdown_fail_2" );
	addNotetrack_customFunction( "makarov", "fire", ::fx_makarov_pistol_fire, "beatdown_idle_1" );
	
	/*######################
	######PILOT ANIMS#####
	######################*/
	level.scr_anim[ "pilot" ][ "helo_jump_1" ] = %dubai_helo_jump_pilot_1;
	level.scr_anim[ "pilot" ][ "helo_jump_2" ] = %dubai_helo_jump_pilot_2;
	level.scr_anim[ "pilot" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_pilot_kick_fail;
	addNotetrack_customFunction( "pilot", "blood", ::pilot_blood_vfx, "helo_jump_2" );

	/*######################
	######COPILOT ANIMS#####
	######################*/
	level.scr_anim[ "copilot" ][ "helo_jump_1" ] = %dubai_helo_jump_copilot_1;
	level.scr_anim[ "copilot" ][ "helo_jump_2" ] = %dubai_helo_jump_copilot_2;
	level.scr_anim[ "copilot" ][ "helo_jump_3" ] = %dubai_helo_jump_copilot_3;
	level.scr_anim[ "copilot" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_copilot_kick_fail;
	level.scr_anim[ "copilot" ][ "helo_jump_stab_fail" ] = %dubai_helo_jump_copilot_stab_fail;
	addNotetrack_customFunction( "copilot", "gunshot", ::copilot_blood_vfx, "helo_jump_3" );
	addNotetrack_customFunction( "copilot", "fire", ::fx_copilot_pistol_fire, "helo_jump_stab_fail" );

	/*######################
	######STRANGER ANIMS#####
	######################*/
	level.scr_model[ "stranger" ]							= "body_fso_suit_a";
	level.scr_head[ "stranger" ]						=	"head_fso_d";
	level.scr_animtree[ "stranger" ]						= #animtree;
	level.scr_anim[ "stranger" ][ "beatdown_end" ]			= %dubai_final_beatdown_guy_end;
	
	/*######################
	######REFLECTION ANIMS#####
	######################*/
	level.scr_model[ "price" ]							= "body_juggernaut_nogear";
	level.scr_head[ "price" ]							= "head_price_africa";
	level.scr_animtree[ "price" ]						= #animtree;
	level.scr_anim[ "price" ][ "finale_reflection" ]	= %dubai_finale_reflection_guy1;
	level.scr_anim[ "price" ][ "finale_reflection_test" ]	= %dubai_finale_wake_reflection;
	
	
	/*######################
	########## PiP #########
	######################*/
	
	level.scr_anim[ "makarov" ][ "pip_scene_atrium" ] = %prague_soap_walk_under_grate;
	
	level.scr_anim[ "makarov" ][ "pip_scene_lounge" ] = 		%patrol_jog_look_up_once;
	
	level.scr_anim[ "makarov" ][ "pip_scene_restaurant" ] = 		%patrol_jog_orders_once;
}

drone_anim()
{
	level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle_loop" ][ 0 ] = %civilain_crouch_hide_idle_loop;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v1_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v1_idle;
	level.scr_anim[ "generic" ][ "DC_Burning_artillery_reaction_v2_idle" ][ 0 ] = %DC_Burning_artillery_reaction_v2_idle;
	level.scr_anim[ "generic" ][ "prague_resistance_hit_idle" ][ 0 ] = %prague_resistance_hit_idle;
	
	level.scr_anim[ "generic" ][ "civilian_crawl_1_death_A" ] = %civilian_crawl_1_death_A;
	
	level.drone_deaths_s = [];
	level.drone_deaths_s[ level.drone_deaths_s.size ] = %exposed_death;
	level.drone_deaths_s[ level.drone_deaths_s.size ] = %exposed_death_02;

	level.drone_deaths_r = [];
	level.drone_deaths_r[ level.drone_deaths_r.size ] = %run_death_roll;
	level.drone_deaths_r[ level.drone_deaths_r.size ] = %run_death_skid;
	level.drone_deaths_r[ level.drone_deaths_r.size ] = %run_death_flop;
	
	/*
	level.scr_anim[ "generic" ][ "run_death_roll" ] = %run_death_roll;
	level.scr_anim[ "generic" ][ "run_death_skid" ] = %run_death_skid;
	level.scr_anim[ "generic" ][ "run_death_flop" ] = %run_death_flop;
	
	level.scr_anim[ "generic" ][ "exposed_death_02" ] = %exposed_death_02;*/
	
	//atrium corpses
	level.scr_anim[ "generic" ][ "corner_standR_deathA" ] = %corner_standR_deathA;
	level.scr_anim[ "generic" ][ "corner_standR_deathB" ] = %corner_standR_deathB;
	level.scr_anim[ "generic" ][ "coverstand_death_left" ] = %coverstand_death_left;
	level.scr_anim[ "generic" ][ "coverstand_death_right" ] = %coverstand_death_right;
	level.scr_anim[ "generic" ][ "covercrouch_death_1" ] = %covercrouch_death_1;
	level.scr_anim[ "generic" ][ "prone_death_quickdeath" ] = %prone_death_quickdeath;
	level.scr_anim[ "generic" ][ "death_shotgun_back_v1" ] = %death_shotgun_back_v1;
}

drone_cycles()
{
	// Walkcycles
	level.scr_anim[ "generic" ][ "civilian_run_hunched_A_relative" ] = %civilian_run_hunched_A_relative;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_C_relative" ] = %civilian_run_hunched_C_relative;
	//level.scr_anim[ "generic" ][ "civilian_run_upright" ] = %civilian_run_upright;
	level.scr_anim[ "generic" ][ "civilian_run_upright_relative" ] = %civilian_run_upright_relative;
	//level.scr_anim[ "generic" ][ "civilian_run_hunched_flinch" ] = %civilian_run_hunched_flinch;
	level.scr_anim[ "generic" ][ "unarmed_scared_run" ] = %unarmed_scared_run;
	//level.scr_anim[ "generic" ][ "unarmed_panickedrun_stumble" ] = %unarmed_panickedrun_stumble;
}

#using_animtree( "vehicles" );
vehicle_anims()
{
	// INTRO TRUCK
	level.scr_model[ "intro_truck" ]						 							= "vehicle_dubai_intro_truck";
	level.scr_animtree[ "intro_truck" ]					 							= #animtree;
	level.scr_anim[ "intro_truck" ][ "intro" ] 								= %dubai_intro_truck;
	
	level.scr_model[ "md500" ]														= "vehicle_md_500_little_bird";
	level.scr_animtree[ "md500" ]													= #animtree;
	level.scr_anim[ "md500" ][ "restaurant_destruction" ] = %dubai_restaurant_md_500_little_bird;

	level.scr_anim[ "md500" ][ "helo_jump_1" ] = %dubai_helo_jump_helo_1;
	level.scr_anim[ "md500" ][ "helo_jump_2" ] = %dubai_helo_jump_helo_2;
	level.scr_anim[ "md500" ][ "helo_jump_3" ] = %dubai_helo_jump_helo_3;
	level.scr_anim[ "md500" ][ "helo_jump_idle" ] = %dubai_helo_jump_helo_idle;
	level.scr_anim[ "md500" ][ "helo_jump_kick_fail" ] = %dubai_helo_jump_helo_kick_fail;
	level.scr_anim[ "md500" ][ "helo_jump_stab_fail" ] = %dubai_helo_jump_helo_stab_fail;
	level.scr_anim[ "md500" ][ "helo_jump_middle" ] = %dubai_helo_jump_helo_handle_middle;
	level.scr_anim[ "md500" ][ "helo_jump_pull" ] = %dubai_helo_jump_helo_handle_pull;
	level.scr_anim[ "md500" ][ "helo_jump_push" ] = %dubai_helo_jump_helo_handle_push;
	level.scr_anim[ "md500" ][ "helo_jump_left" ] = %dubai_helo_jump_helo_handle_left;
	level.scr_anim[ "md500" ][ "helo_jump_right" ] = %dubai_helo_jump_helo_handle_right;
}

#using_animtree( "script_model" );
script_model_anims()
{
	// INTRO GUN
	level.scr_animtree[ "intro_player_gun" ] 									= #animtree;	
	level.scr_anim[ "intro_player_gun" ][ "intro" ]						= %dubai_intro_player_rifle;
	
	// INTRO PRICE HELMET
	level.scr_animtree[ "intro_yuri_helmet" ]									= #animtree;
	level.scr_anim[ "intro_yuri_helmet" ][ "intro_yuri" ]					= %dubai_intro_price_helmet;
	
	// ELEVATOR JUGGERNAUT GEAR
	level.scr_animtree[ "elevator_gear" ]											= #animtree;
	level.scr_anim[ "elevator_gear" ][ "remove_gear" ]				= %dubai_removing_grear_grear;
	level.scr_anim[ "elevator_gear" ][ "remove_gear_2" ]			= %dubai_removing_grear_grear_2;
	//level.scr_anim[ "elevator_gear" ][ "remove_gear_3" ]			= %dubai_removing_grear_grear_3;
	
	// RESTAURANT FLOOR
	level.scr_animtree[ "restaurant_floor" ] 									= #animtree;
	level.scr_model[ "restaurant_floor" ] 						= "dub_restaurant_floor_rigged";
	level.scr_anim[ "restaurant_floor" ][ "restaurant_destruction_floor" ]	= %dubai_restaurant_floor;
	
	// RESTAURANT COLUMN
	level.scr_animtree[ "restaurant_column" ] 									= #animtree;	
	level.scr_anim[ "restaurant_column" ][ "restaurant_column_shatter_1" ]						= %dubai_restaurant_column_shatter_1;
	level.scr_anim[ "restaurant_column" ][ "restaurant_column_shatter_2" ]						= %dubai_restaurant_column_shatter_2;
	
	// RESTAURANT TABLE ROUND
	level.scr_animtree[ "dub_restaurant_roundtable_set_sim" ] 									= #animtree;	
	level.scr_anim[ "dub_restaurant_roundtable_set_sim" ][ "dubai_restaurant_round_table_sim" ]						= %dubai_restaurant_round_table_sim;
	
	// RESTAURANT TABLE SQUARE
	level.scr_animtree[ "dub_restaurant_squaretable_set_sim" ] 									= #animtree;	
	level.scr_anim[ "dub_restaurant_squaretable_set_sim" ][ "dubai_restaurant_square_table_sim" ]						= %dubai_restaurant_square_table_sim;
	
	level.scr_model[ "fx_char_light_rig" ] 									= "fx_char_light_rig";	
	level.scr_animtree[ "fx_char_light_rig" ] 								= #animtree;	
	level.scr_anim[ "fx_char_light_rig" ][ "restaurant_wounded" ]			= %dubai_restaurant_yuri_lightrig_start;
	level.scr_anim[ "fx_char_light_rig" ][ "restaurant_idle" ][0]			= %dubai_restaurant_yuri_lightrig_idle;
	
	level.scr_anim[ "fx_char_light_rig" ][ "beatdown_idle_1" ]				= %dubai_final_beatdown_lighting_idle_1;
	level.scr_anim[ "fx_char_light_rig" ][ "beatdown_slam" ]				= %dubai_final_beatdown_lighting_slam;
	level.scr_anim[ "fx_char_light_rig" ][ "beatdown_tackle" ]				= %dubai_final_beatdown_lighting_tackle;
	level.scr_anim[ "fx_char_light_rig" ][ "beatdown_choke" ]				= %dubai_final_beatdown_lighting_choke;
	
	level.scr_anim[ "floor_glass" ][ "beatdown_slam" ]						= %dubai_final_beatdown_balcony_slam;
	level.scr_animtree[ "floor_glass" ]										= #animtree;
	
	// knife
	level.scr_animtree[ "knife" ] 									= #animtree;	
	level.scr_model[ "knife" ]	 									= "weapon_spyderco_folding_knife";	
	level.scr_anim[ "knife" ][ "helo_jump_2" ]						= %dubai_helo_jump_knife;
	
	// deagle
	level.scr_animtree[ "deagle" ] 									= #animtree;	
	level.scr_model[ "deagle" ]	 									= "viewmodel_desert_eagle_sp_iw5";	
	level.scr_anim[ "deagle" ][ "finale_draw" ]						= %dubai_finale_draw_deagle;
	level.scr_anim[ "deagle" ][ "finale_draw02" ]					= %dubai_finale_draw_deagle02;
	level.scr_anim[ "deagle" ][ "finale_draw_fail" ]				= %dubai_finale_draw_fail_deagle03;
	level.scr_anim[ "deagle" ][ "finale_showdown" ]					= %dubai_finale_showdown_deagle;
	level.scr_anim[ "deagle" ][ "beatdown_fail" ]					= %dubai_final_beatdown_weapon_fail;
	level.scr_anim[ "deagle" ][ "beatdown_idle_1" ]					= %dubai_final_beatdown_weapon_idle_1;
	level.scr_anim[ "deagle" ][ "beatdown_tackle" ]					= %dubai_final_beatdown_weapon_tackle;
	level.scr_anim[ "deagle" ][ "beatdown_fail_2" ]					= %dubai_final_beatdown_weapon_fail_2;
	
	// ropes
	level.scr_animtree[ "ropea" ] 									= #animtree;	
	level.scr_model[ "ropea" ]	 									= "weapon_finale_cable_a";	
	level.scr_anim[ "ropea" ][ "beatdown_choke" ]					= %dubai_final_beatdown_ropea_choke;
	level.scr_anim[ "ropea" ][ "beatdown_hanging_idle" ][0]			= %dubai_final_beatdown_ropea_hanging_idle;
	level.scr_anim[ "ropea" ][ "beatdown_idle_1" ][0]				= %dubai_final_beatdown_ropea_idle_1;
	level.scr_anim[ "ropea" ][ "beatdown_idle_3" ][0]				= %dubai_final_beatdown_ropea_idle_3;
	level.scr_anim[ "ropea" ][ "beatdown_slam" ]					= %dubai_final_beatdown_ropea_slam;
	
	level.scr_animtree[ "ropeb" ] 									= #animtree;	
	level.scr_model[ "ropeb" ]	 									= "weapon_finale_cable_b";	
	level.scr_anim[ "ropeb" ][ "beatdown_choke" ]					= %dubai_final_beatdown_ropeb_choke;
	level.scr_anim[ "ropeb" ][ "beatdown_hanging_idle" ][0]			= %dubai_final_beatdown_ropeb_hanging_idle;
	level.scr_anim[ "ropeb" ][ "beatdown_idle_3" ][0]				= %dubai_final_beatdown_ropeb_idle_3;
	level.scr_anim[ "ropeb" ][ "beatdown_slam" ]					= %dubai_final_beatdown_ropeb_slam;

	// skylight
	level.scr_animtree[ "skylight" ] 									= #animtree;
	level.scr_model[ "skylight" ]	 									= "dub_finale_skylight_shards";	
	level.scr_anim[ "skylight" ][ "skylight_shatter" ]					= %dubai_final_skylight_sim;
	
	// cigar
	level.scr_animtree[ "cigar" ] 									= #animtree;	
	level.scr_model[ "cigar" ]	 									= "dub_cigar_";	
	level.scr_anim[ "cigar" ][ "beatdown_slam" ]					= %dubai_final_beatdown_cigar_slam;
	level.scr_anim[ "cigar" ][ "beatdown_smoking_idle" ]			= %dubai_final_beatdown_cigar_smoking_idle;
	level.scr_anim[ "cigar" ][ "beatdown_end" ]						= %dubai_final_beatdown_cigar_end;
	addNotetrack_customFunction( "cigar", "cigar_smoke", ::cigar_smoke_vfx, "beatdown_slam" );

	// zippo
	level.scr_animtree[ "zippo" ] 									= #animtree;	
	level.scr_model[ "zippo" ]	 									= "weapon_lighter";	
	level.scr_anim[ "zippo" ][ "beatdown_slam" ]					= %dubai_final_beatdown_zippo_slam;
	addNotetrack_customFunction( "zippo", "zipp_spark", ::zippo_spark_vfx, "beatdown_slam" );
	addNotetrack_customFunction( "zippo", "zipp_fire", ::zippo_fire_vfx, "beatdown_slam" );
}


copilot_blood_vfx(ent)
{
	playfxontag( getfx( "copilot_muzzleflash" ), ent, "TAG_FLASH" );
	wait(1.3);
	playfxontag( getfx( "knife_attack_throat" ), ent, "J_Neck" );
}

pilot_blood_vfx(ent)
{
	playfxontag( getfx( "punch_pilot" ), ent, "J_Lip_Bot_LE" );
}

ignore_all( guy )
{
	guy.allowDeath = false;
	flag_set( "exterior_juggernaut_paired_complete" );
}

finale_yuri_death( guy )
{
	wait 1;
	
	ai_kill( guy );
}

ai_kill( guy )
{
	if ( !isalive( guy ) )
		return;
	guy.allowDeath = true;
	guy.a.nodeath = true;
	guy set_battlechatter( false );

	wait 0.05;
	guy kill();

	/*
	tagPos = guy gettagorigin( "j_SpineUpper" );	// rough tag to play fx on
	tagPos = PhysicsTrace( tagPos + ( 0,0,64), tagPos + ( 0,0,-64) );
	playfx( level._effect[ "deathfx_bloodpool_generic" ], tagPos );
	*/	
}

fx_start_nose_bleed(guy)
{
	fx_org = spawn_tag_origin();
	fx_org linkto(guy, "tag_camera", (0,0,0), (0,180,0));
	playfxontag(getfx("blood_drip_price_nose"), fx_org, "tag_origin");
}

fx_stop_nose_bleed(guy)
{
	//stopfxontag(getfx("blood_drip_price_nose"), fx_org, "tag_origin");
}

skylight_crack0_vfx(guy)
{
	wait 0.05;
	//iprintlnbold ("1");
	player_contents = level.player SetContents( 0 );      // disable collision on player
	MagicBullet( "nosound_magicbullet", ( 621, -116, 8110 ), ( 621, -116, 7900 ), level.player );
	level.player SetContents( player_contents );          // restore collision on player
	
	exploder(22000);
	exploder(22001);
	
	wait 3.0;
	//iprintlnbold ("2");
	//player_contents = level.player SetContents( 0 );      // disable collision on player
	//MagicBullet( "nosound_magicbullet", ( 621.5, -111.5, 8110 ), ( 621.5, -111.5, 7900 ) , level.player );
	//level.player SetContents( player_contents );          // restore collision on player
	//exploder(22002);
	
	wait(6.50);
	//iprintlnbold ("2");
	exploder(22002);
	
	/*
	ent = createExploderEx( "db_finale_glass_cracks_1", "21001" );
	ent set_origin_and_angles( ( 621.004, -112.486, 8109.33 ), ( 270, 0, 0 ) );

	ent = createExploderEx( "db_finale_glass_cracks_2", "21002" );
	ent set_origin_and_angles( ( 618.837, -114.205, 8109.33 ), ( 270, 0, 0 ) );

	ent = createExploderEx( "db_finale_glass_cracks_2", "21003" );
	ent set_origin_and_angles( ( 621.144, -114.638, 8109.33 ), ( 270, 0, 0 ) );

	ent = createExploderEx( "db_finale_glass_cracks_4", "21004" );
	ent set_origin_and_angles( ( 616.933, -109.556, 8109.33 ), ( 270, 0, 0 ) );

	ent = createExploderEx( "db_finale_glass_cracks_5", "21005" );
	ent set_origin_and_angles( ( 622.557, -81.4892, 8109.33 ), ( 270, 359.37, -3.36949 ) );

	ent = createExploderEx( "db_finale_glass_cracks_5", "21006" );
	ent set_origin_and_angles( ( 597.35, -113.621, 8105.32 ), ( 270.001, 359.682, 112.319 ) );

	ent = createExploderEx( "db_finale_glass_cracks_3", "21007" );
	ent set_origin_and_angles( ( 607.227, -123.806, 8109.32 ), ( 270, 0, 0 ) );

	ent = createExploderEx( "db_finale_glass_cracks_3", "21008" );
	ent set_origin_and_angles( ( 607.547, -108.036, 8109.32 ), ( 270, 0, 0 ) );
	exploder(22000);
	ent = createExploderEx( "db_finale_glass_cracks_3", "21003" );
	ent set_origin_and_angles( ( 616.842, -112.728, 8110.33 ), ( 270, 0, 0 ) );
	
	ent = createExploderEx( "db_finale_glass_cracks_4", "21007" );
	ent set_origin_and_angles( ( 651.234, -111.932, 8103.32 ), ( 270, 0, 0 ) );
	*/
}

skylight_crack1_vfx(guy)
{
	//wait 0.15;
	//iprintlnbold ("3");
	player_contents = level.player SetContents( 0 );      // disable collision on player
	MagicBullet( "nosound_magicbullet", ( 619.933, -116, 8110 ), ( 619.933, -116, 7900 ) , level.player );
	level.player SetContents( player_contents );          // restore collision on player
	exploder(22001);
}

skylight_crack2_vfx(guy)
{
	//wait 0.2;
	//iprintlnbold ("4");
	player_contents = level.player SetContents( 0 );      // disable collision on player
	MagicBullet( "nosound_magicbullet", (620.5, -104.5, 8110 ), ( 620.5, -104.5, 7900 ), level.player  );
	level.player SetContents( player_contents );          // restore collision on player
	exploder(22001);
}

blood_vfx(guy)
{
	playfxontag(getfx("generic_chestshot_blood"), guy, "J_SpineUpper");
}

makarov_punch_r_vfx(makarov)

{
  playfxontag( getfx( "makarov_punch_r" ), makarov, "J_Jaw" );
  exploder(903);
  exploder(22001);
}

makarov_punch_r2_vfx(makarov)

{
  playfxontag( getfx( "makarov_punch_r2" ), makarov, "J_Jaw" );
  exploder(904);
  exploder(22001);
}

makarov_punch_l_vfx(makarov)

{
	playfxontag( getfx( "makarov_punch_l" ), makarov, "J_Jaw" );
	exploder(902);
	exploder(22001);
}


zippo_spark_vfx(zippo)
{
	PlayFXOnTag( getfx( "zippo_sparks" ), zippo, "TAG_FX" );		
}

zippo_fire_vfx(zippo)
{
	PlayFXOnTag( getfx( "zippo_fire" ), zippo, "TAG_FX" );	
	wait(6.3);	
	//iprintlnbold("fireoff");
	StopFXOnTag( getfx( "zippo_fire" ), zippo, "TAG_FX" );	
}

cigar_smoke_vfx(cigar)
{
	PlayFXOnTag( getfx( "cigar_lite" ), cigar, "cigarTip" );
	wait(0.3);
	PlayFXOnTag( getfx( "cigar_puff" ), cigar, "TAG_ORIGIN" );
	wait(1.2);
	PlayFXOnTag( getfx( "cigar_puff" ), cigar, "TAG_ORIGIN" );
	wait(2.5);
	PlayFXOnTag( getfx( "cigar_lite_smoke" ), cigar, "cigarTip" );
	wait(14.0);
	exploder(910);
	wait(20.0);
	//fx_zone_watcher_either_off_killthread(5000,off_flag);
	//trigger5000 = getEnt("msg_fx_zone5000", "targetname");
	//trigger5000 trigger_off();
	if(!flag_exist("off_flag"))
		flag_init("off_flag");
	flag_set("off_flag");
	wait(0.1);
	kill_exploder(5000);
	wait(0.1);
	kill_exploder(5002);
	wait(0.1);
	kill_exploder(5003);
	wait(0.1);
	exploder(5004);
	flag_wait( "end_of_credits");
	wait(30.7);
	PlayFXOnTag( getfx( "cigar_drop" ), cigar, "cigarTip" );
}

fx_shift_focus(guy)
{
	start = level.dofDefault;	
	dof_wake_near = [];
	dof_wake_near[ "nearStart" ] = 50;
	dof_wake_near[ "nearEnd" ] = 200;
	dof_wake_near[ "nearBlur" ] = 4;
	dof_wake_near[ "farStart" ] = 500;
	dof_wake_near[ "farEnd" ] = 900;
	dof_wake_near[ "farBlur" ] = 3;
	

	blend_dof( start, dof_wake_near, 1.0 );
	
	wait(4.5);
	
	blend_dof( dof_wake_near, start, 4 );
}

fx_makarov_pistol_fire(guy)
{
	PlayFXOnTag( getfx( "makarov_muzzle_flash_simple" ), level.gun, "TAG_FLASH" );
}

fx_copilot_pistol_fire(guy)
{
	PlayFXOnTag( getfx( "makarov_muzzle_flash_simple_nodepth" ), guy, "TAG_FLASH" );
}

