#include maps\_utility;
#include common_scripts\utility;
#include maps\_scene;
#include maps\_dialog;
#include maps\_anim;

#using_animtree ("generic_human");
main()
{
	// Script sections
	speech_anims();
	market_anims();
	terrorist_hunt_anims();
	metal_storms_anims();
	morals_anims();
	drone_control_anims();
	hijacked_anims();
	capture_anims();
	
	precache_assets();
}

speech_anims()
{
	// Prayer anims
	add_scene( "speech_prayer", "speech_stage", false, false, true );
	add_actor_anim( "prayer_02", %generic_human::ch_yemen_01_01_prayer_guy02_praying, true );
	add_actor_anim( "prayer_03", %generic_human::ch_yemen_01_01_prayer_guy03_praying, true );
    add_actor_anim( "prayer_04", %generic_human::ch_yemen_01_01_prayer_guy04_praying, true );
	add_actor_anim( "prayer_05", %generic_human::ch_yemen_01_01_prayer_guy05_praying, true );
	add_actor_anim( "prayer_06", %generic_human::ch_yemen_01_01_prayer_guy06_praying, true );
	add_actor_anim( "prayer_07", %generic_human::ch_yemen_01_01_prayer_guy07_praying, true );
	add_actor_anim( "prayer_08", %generic_human::ch_yemen_01_01_prayer_guy08_praying, true );
	add_actor_anim( "prayer_10", %generic_human::ch_yemen_01_01_prayer_guy10_praying, true );
	
	// Player and actor praying anims
	add_scene( "speech_prayer_player", "speech_stage" );
	add_actor_anim( "prayer_09", %generic_human::ch_yemen_01_01_prayer_guy09_praying, true );
	add_player_anim( "player_body", %player::p_yemen_01_01_prayer_player_praying );
	
	// "He is waiting" anims
	add_scene( "speech_he_is_waiting", "speech_stage" );
	add_actor_anim( "prayer_09", %generic_human::ch_yemen_01_01_prayer_guy09_he_is_waiting, true );
	add_player_anim( "player_body", %player::p_yemen_01_01_prayer_player_he_is_waiting, true );
	
	// Idle anims
	add_scene( "speech_amb_idle_01", "speech_amb_idle_1", false, false, true );
	add_actor_anim( "prayer_idle_01", %generic_human::ch_yemen_01_01_prayer_guy04_idl, true );
	add_actor_anim( "prayer_idle_02", %generic_human::ch_yemen_01_01_prayer_guy06_idl, true );
	
	add_scene( "speech_amb_idle_02", "speech_amb_idle_2", false, false, true );
	add_actor_anim( "prayer_idle_03", %generic_human::ch_yemen_01_01_prayer_guy02_idl, true );
	add_actor_anim( "prayer_idle_04", %generic_human::ch_yemen_01_01_prayer_guy03_idl, true );
	add_actor_anim( "prayer_idle_05", %generic_human::ch_yemen_01_01_prayer_guy07_idl, true );
	add_actor_anim( "prayer_idle_06", %generic_human::ch_yemen_01_01_prayer_guy08_idl, true );

	add_scene( "speech_amb_idle_03", "speech_amb_idle_3", false, false, true );
	add_actor_anim( "prayer_idle_07", %generic_human::ch_yemen_01_01_prayer_guy05_idl, true );
	
//	add_scene( "speech_amb_idle_04", "speech_stage", false, false, true );
//	add_actor_anim( "prayer_10", %generic_human::ch_yemen_01_01_prayer_guy10_idl, true );	
	
	add_scene( "speech_amb_idle_05", "speech_stage", false, false, true );
	add_actor_anim( "prayer_09", %generic_human::ch_yemen_01_01_prayer_guy09_idl, true );	
		
	// Menendez Intro
	add_scene( "speech_menendez_intro_menendez", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_02_menendez_intro_menendez, true, true );
	
	add_scene( "speech_menendez_intro_player", "speech_stage" );
	add_player_anim( "player_body", %player::p_yemen_01_02_menendez_intro_player, false, 0, undefined, true, 1, 10, 10, 10, 10 );
	
	// Open Doors
	add_scene( "speech_opendoors", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_opendoors, true, true );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_opendoors, false, 0, undefined, true, 1, 10, 10, 10, 10 );
	
	// Speech walk
	add_scene( "speech_walk_with_defalco", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_walk_with_defalco, true, true );
	add_actor_anim( "defalco", %generic_human::ch_yemen_01_03_menendez_speech_defalco_walk_with_defalco, true, false );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_walk_with_defalco, false, 0, undefined, true, 1, 10, 10, 10, 10 );

	add_scene( "speech_walk_no_defalco", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_walk_no_defalco, true, true );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_walk_no_defalco, false, 0, undefined, true, 1, 10, 10, 10, 10 );
	
	add_scene( "speech_defalco_endidl", "speech_stage", false, false, true );
	add_actor_anim( "defalco", %generic_human::ch_yemen_01_03_menendez_speech_defalco_endidl, true, false );
	
	// Speech talk
	add_scene( "speech_talk", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_03_menendez_speech_menendez_talk, true, true );
	add_player_anim( "player_body", %player::p_yemen_01_03_menendez_speech_player_talk, true, 0, undefined, true, 1, 10, 10, 10, 10 );
}

#using_animtree( "animated_props" );
market_anims()
{
	add_scene( "exit_stage", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_01_04_menendez_shoot_drones );
	
	add_scene( "exit_courtyard", "speech_stage" );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_02_01_menendez_exit );
	
	add_scene( "exit_courtyard_loop", "speech_stage", false, false, true );
	add_actor_anim( "menendez_speech", %generic_human::ch_yemen_02_01_menendez_exit_shoot_loop );
	
	level.scr_anim[ "generic" ][ "market_table_flip" ] = %generic_human::ch_yemen_02_02_table_flip_guy01;
	
	level.scr_model[ "market_table" ] = "p6_street_vendor_goods_table02";
	level.scr_anim[ "market_table" ][ "market_table_flip" ] = %animated_props::o_yemen_02_02_table_flip_table;
	level.scr_animtree[ "market_table" ] = #animtree;	
}

terrorist_hunt_anims()
{
	add_scene( "rocket_hall_intro", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy1", %generic_human::ch_yemen_03_03_xm25_intro_char_01 );
	add_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_intro_char_02 );
	add_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_intro_char_03 );
	add_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_intro_char_04 );
	add_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_intro_char_06 );
	add_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_intro_char_07 );
	add_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_intro_char_08 );
	add_player_anim( "player_body", %player::p_yemen_03_03_xm25_intro, false, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );
	
	add_scene( "rocket_hall_reaction_to_gun", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy1", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_01 );
	add_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_02 );
	add_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_03 );
	add_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_04 );
	add_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_06 );
	add_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_07 );
	add_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_reaction_to_drawing_gun_char_08 );
	add_player_anim( "player_body", %player::p_yemen_03_03_xm25_reaction_to_drawing_gun, false, undefined, undefined, true, 1, 45, 10, 15, 15, false, false );

	add_scene( "rocket_hall_reaction_to_firing", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_02 );
	add_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_03 );
	add_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_reaction_to_firing_gun_char_04 );
	
	add_scene( "rocket_hall_death_zone_1", "rockethall_align" );	// these all play if the rocket explodes in zone 1
	add_actor_anim( "rocket_hall_guy1", %generic_human::ch_yemen_03_03_xm25_deaths_char_01 );
	add_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_deaths_char_08 );
	
	add_scene( "rocket_hall_death_zone_2", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy2", %generic_human::ch_yemen_03_03_xm25_deaths_char_02 );
	add_actor_anim( "rocket_hall_guy3", %generic_human::ch_yemen_03_03_xm25_deaths_char_03 );
	add_actor_anim( "rocket_hall_guy4", %generic_human::ch_yemen_03_03_xm25_deaths_char_04 );	
	
	add_scene( "rocket_hall_death_zone_3", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy6", %generic_human::ch_yemen_03_03_xm25_deaths_char_06 );
	
	add_scene( "rocket_hall_death_zone_4", "rockethall_align" );
	add_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_deaths_char_07 );	

	add_scene( "rocket_hall_death_zone_5", "rockethall_align" );	// TODO: playing this anim since nothing is currently set in zone 3
	add_actor_anim( "rocket_hall_guy7", %generic_human::ch_yemen_03_03_xm25_deaths_char_07 );	
	
	add_scene( "rocket_hall_death_zone_1_loop", "rockethall_align", false, false, true );
	add_actor_anim( "rocket_hall_guy8", %generic_human::ch_yemen_03_03_xm25_deathcycle_char_08 );
}

metal_storms_anims()
{
	add_scene( "courtyard_balcony_deaths", "metalstorms_align" );
	add_actor_anim( "courtyard_balcony_guy_1", %generic_human::ch_yemen_04_01_xplode_death_guy1 );
	add_actor_anim( "courtyard_balcony_guy_2", %generic_human::ch_yemen_04_01_xplode_death_guy2 );
	add_actor_anim( "courtyard_balcony_guy_3", %generic_human::ch_yemen_04_01_xplode_death_guy3 );
	add_actor_anim( "courtyard_balcony_guy_4", %generic_human::ch_yemen_04_01_xplode_death_guy4 );
}

morals_anims()
{
	
}

drone_control_anims()
{
	
}

hijacked_anims()
{
	//Menendez hacking drones
	add_scene( "hijacked_menendez_hack", "menendez_hack" );
	add_actor_anim( "menendez_temp", %generic_human::ch_yemen_07_01_menendez_hack );
	
	//Soldier hangs off of bridge
	add_scene( "hijacked_bridge_hang", "bridge_fall", false, false, true );
	add_actor_anim( "sp_hijacked_soldier_hang",%generic_human::ch_yemen_07_01_bridge_fall_loop );
//	add_actor_anim( "sp_hijacked_soldier_fall", %generic_human::ch_yemen_07_01_bridge_fall );
	
	//Soldier falls from bridge
	add_scene( "hijacked_bridge_fall", "bridge_fall" );
	add_actor_anim( "sp_hijacked_soldier_fall", %generic_human::ch_yemen_07_01_bridge_fall );
}

capture_anims()
{	
	//Sit Rep - Soldier pulls us in
	add_scene( "soldier_sitrep", "sit_rep" );
	add_actor_anim( "soldier_sitrep", %generic_human::ch_yemen_08_01_pull_to_cover_american );
	add_player_anim( "player_body", %player::p_yemen_08_01_pull_to_cover, true );
	
	//Sniper deaths
	add_scene( "soldier_crouch_sniped_1", "sit_rep" ); //
	add_actor_anim( "crouch_sniped_1", %generic_human::ch_yemen_08_01_crouch_sniped_1 );
	
	add_scene( "soldier_crouch_sniped_2", "sit_rep" );
	add_actor_anim( "crouch_sniped_2", %generic_human::ch_yemen_08_01_crouch_sniped_2 );
	
	add_scene( "soldier_crouch_sniped_3", "sit_rep" );
	add_actor_anim( "crouch_sniped_3", %generic_human::ch_yemen_08_01_crouch_sniped_3 );
	
	add_scene( "soldier_crouch_sniped_4", "sit_rep" );
	add_actor_anim( "crouch_sniped_4", %generic_human::ch_yemen_08_01_crouch_sniped_4 );
	
	add_scene( "soldier_run_sniped_1", "sit_rep" );
	add_actor_anim( "run_sniped_1", %generic_human::ch_yemen_08_01_run_sniped_1 );
	
	add_scene( "soldier_run_sniped_2", "sit_rep" );
	add_actor_anim( "run_sniped_2", %generic_human::ch_yemen_08_01_run_sniped_2 );
	
	add_scene( "soldier_run_sniped_3", "sit_rep" );
	add_actor_anim( "run_sniped_3", %generic_human::ch_yemen_08_01_run_sniped_3 );
	
	add_scene( "soldier_stand_sniped_1", "sit_rep" );
	add_actor_anim( "stand_sniped_1", %generic_human::ch_yemen_08_01_stand_sniped_1 );
	
	add_scene( "soldier_stand_sniped_2", "sit_rep" );
	add_actor_anim( "stand_sniped_2", %generic_human::ch_yemen_08_01_stand_sniped_2 );

	//Menendez surrenders
	add_scene( "surrender_menendez", "menendez_surrender" );
	add_actor_anim( "menendez_temp", %generic_human::ch_yemen_08_02_surrender_men );
	add_actor_anim( "soldier_1", %generic_human::ch_yemen_08_02_surrender_sldr1 );
	add_actor_anim( "soldier_2", %generic_human::ch_yemen_08_02_surrender_sldr2 );
	add_player_anim( "player_body", %player::p_yemen_08_02_surrender_plyr );
}