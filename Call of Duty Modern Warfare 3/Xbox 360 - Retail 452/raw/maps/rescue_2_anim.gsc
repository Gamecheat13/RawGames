#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
//#include maps\_util_carlos;

main()
{
	price();
	generic_anims();
	sounds();
	saw_open_door();
	script_model();
	player_anims();
	explosion_deaths();
	group_scenes();
	props();
	vehicles();
	dialogue();
	drone_deaths();
	init_uav_radio_dialogue();
//	generator_anims();

	level.gunless_anims = 
	[ "bunker_toss_idle_guy1" ,
	 "prague_woundwalk_wounded",
	 "prague_civ_door_peek",
	 "prague_civ_door_runin",
	 "prague_resistance_hit_idle",
	 "DC_Burning_bunker_stumble",
	 "dc_burning_bunker_stumble",
	 "civilian_crawl_1",
	 "civilian_crawl_2",
	 "dying_crawl",
	 "DC_Burning_artillery_reaction_v1_idle",
	 "DC_Burning_artillery_reaction_v2_idle",
	 "DC_Burning_artillery_reaction_v3_idle",
	 "DC_Burning_artillery_reaction_v4_idle",
	 "DC_Burning_bunker_sit_idle",
	 "civilain_crouch_hide_idle",
	 "DC_Burning_stop_bleeding_wounded_endidle",
	 "DC_Burning_stop_bleeding_medic_endidle",
	 "DC_Burning_stop_bleeding_wounded_idle",
	 "prague_woundwalk_wounded_idle",
	 "prague_bully_civ_survive_idle",
	 "training_basketball_rest",
	 "prague_mourner_man_idle",
	 "airport_civ_dying_groupB_wounded",
	 "airport_civ_dying_groupB_pull",
	 "training_woundedwalk_soldier_1",
	 "training_woundedwalk_soldier_2" ];
}

#using_animtree( "generic_human" );

price()
{
}

generic_anims()
{	
	level.scr_anim[ "generic" ][ "rescue_npc_plantcharges_1" ] = %rescue_npc_plantcharges_1;
	level.scr_anim[ "generic" ][ "rescue_npc_plantcharges_2" ] = %rescue_npc_plantcharges_2;
	level.scr_anim[ "generic" ][ "rescue_price_plantcharges" ] = %rescue_price_plantcharges;
	
	addNotetrack_customFunction( "generic", "add_belt", ::show_charge, "rescue_npc_plantcharges_1" );
	addNotetrack_customFunction( "generic", "add_belt", ::show_charge, "rescue_npc_plantcharges_2" );
	addNotetrack_customFunction( "generic", "add_belt", ::show_charge, "rescue_price_plantcharges" );
	
	level.scr_anim[ "generic" ][ "rappel_left_mount" ]		= %rescue_npc_rappel_hookup_left;
	level.scr_anim[ "generic" ][ "rappel_right_mount" ]		= %rescue_npc_rappel_hookup_right;
	
	level.scr_anim[ "generic" ][ "rappel_idle_right" ][0]			= %rescue_npc_rappel_idle_right;
	level.scr_anim[ "generic" ][ "rappel_idle_left" ][0]			= %rescue_npc_rappel_idle_left;
	
	level.scr_anim[ "generic" ][ "rappel" ]					= %rescue_npc_rappel_drop;
	level.scr_anim[ "generic" ][ "rappel_2" ]				= %rescue_npc_rappel_drop_2;
		
	level.scr_anim[ "generic" ][ "rappel_skylight_drop" ]		= %rappel_skylight_drop;
	level.scr_anim[ "generic" ][ "bridge_rappel_L" ]			= %bridge_rappel_L;
	level.scr_anim[ "generic" ][ "bridge_rappel_R" ]			= %bridge_rappel_R;
	
	level.scr_anim[ "generic" ][ "doorkick_2_cqbwalk" ] 		= %doorkick_2_cqbwalk;
	level.scr_anim[ "delta" ][ "doorkick_2_cqbwalk" ] 			= %doorkick_2_cqbwalk;
	level.scr_anim[ "grinch" ][ "doorkick_2_cqbwalk" ] 			= %doorkick_2_cqbwalk;
	level.scr_anim[ "truck" ][ "doorkick_2_cqbwalk" ] 			= %doorkick_2_cqbwalk;
	level.scr_anim[ "sandman" ][ "doorkick_2_cqbwalk" ] 		= %doorkick_2_cqbwalk;
	level.scr_anim[ "price" ][ "doorkick_2_cqbwalk" ] 			= %doorkick_2_cqbwalk;
	
	level.scr_anim[ "generic" ][ "airport_security_guard_pillar_death_R" ] 		= %airport_security_guard_pillar_death_R;
	level.scr_anim[ "generic" ][ "RPG_stand_death_stagger" ] 					= %RPG_stand_death_stagger;

	level.scr_anim[ "generic" ][ "coverstand_hide_idle" ][0] 					= %coverstand_hide_idle;
	level.scr_anim[ "generic" ][ "covercrouch_hide_idle" ][0] 					= %covercrouch_hide_idle;
	
	
	level.scr_anim[ "generic" ][ "covercrouch_run_in_R" ]	= %covercrouch_run_in_R;
	level.scr_anim[ "generic" ][ "covercrouch_run_in_L" ]	= %covercrouch_run_in_L;
	level.scr_anim[ "generic" ][ "covercrouch_run_in_ML" ]	= %covercrouch_run_in_ML;
	level.scr_anim[ "generic" ][ "covercrouch_run_in_MR" ]	= %covercrouch_run_in_MR;
	level.scr_anim[ "generic" ][ "covercrouch_run_in_M" ]	= %covercrouch_run_in_M;
	
	level.scr_anim[ "generic" ][ "stunned1" ]	=%exposed_flashbang_v1;
	level.scr_anim[ "generic" ][ "stunned2" ]	=%exposed_flashbang_v2;
	level.scr_anim[ "generic" ][ "stunned3" ]	=%exposed_flashbang_v3;
	level.scr_anim[ "generic" ][ "stunned4" ]	=%exposed_flashbang_v4;
	level.scr_anim[ "generic" ][ "stunned5" ]	=%exposed_flashbang_v5;
	
	level.scr_anim[ "truck" ][ "stunned1" ]	=%exposed_flashbang_v1;
	level.scr_anim[ "truck" ][ "stunned1" ]		=%exposed_flashbang_v1;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_stand1" ]	=%hijack_generic_stumble_stand1;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_stand2" ]	=%hijack_generic_stumble_stand2;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_crouch1" ]	=%hijack_generic_stumble_crouch1;
	level.scr_anim[ "generic" ][ "hijack_generic_stumble_crouch2" ]	=%hijack_generic_stumble_crouch2;
	level.scr_anim[ "price" ][ "stunned5" ]		=%exposed_flashbang_v5;
	
	level.scr_anim[ "generic" ][ "exposed_flashbang_v3" ]					= %exposed_flashbang_v3;
	level.scr_anim[ "generic" ][ "dying_crawl_back" ]						= %dying_crawl_back;
	level.scr_anim[ "generic" ][ "dying_crawl_back_death" ]					= %dying_back_death_v1;
	level.scr_anim[ "generic" ][ "dying_crawl" ]							= %dying_crawl;
	level.scr_anim[ "generic" ][ "dying_crawl_death" ]						= %dying_crawl_death_v1;
	level.scr_anim[ "generic" ][ "civilian_crawl_1" ]						= %civilian_crawl_1;
	level.scr_anim[ "generic" ][ "civilian_crawl_1_death" ]					= %civilian_crawl_1_death_A;
	level.scr_anim[ "generic" ][ "civilian_crawl_2" ]						= %civilian_crawl_2;
	level.scr_anim[ "generic" ][ "civilian_crawl_2_death" ]					= %civilian_crawl_2_death_A;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ]				= %DC_Burning_bunker_stumble;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble_idle" ][0]		= %DC_Burning_bunker_sit_idle;
//	level.scr_anim[ "generic" ][ "death_explosion_stand_F_v4" ] = %death_explosion_stand_F_v4;	
//	level.scr_anim[ "generic" ][ "afgan_caves_intro_stop" ] = %afgan_caves_intro_stop;	
//	level.scr_anim[ "generic" ][ "door_kick_in" ] = %door_kick_in;	
//	level.scr_anim[ "generic" ][ "combatwalk_F_spin" ] = %combatwalk_F_spin;
//
//	level.scr_anim[ "generic" ][ "hunted_open_barndoor_stop" ] = %hunted_open_barndoor_stop;
//	level.scr_anim[ "generic" ][ "hunted_open_barndoor_idle" ][0] = %hunted_open_barndoor_idle;
//	level.scr_anim[ "generic" ][ "hunted_open_barndoor_flathand" ] = %hunted_open_barndoor_flathand;	

	level.scr_anim[ "truck" ][ "stunned1" ]	=%exposed_flashbang_v1;
	level.scr_anim[ "grinch" ][ "stunned2" ]	=%exposed_flashbang_v2;
	level.scr_anim[ "generic" ][ "stunned3" ]	=%exposed_flashbang_v3;
	level.scr_anim[ "sandman" ][ "stunned4" ]	=%exposed_flashbang_v4;
	level.scr_anim[ "price" ][ "stunned5" ]	=%exposed_flashbang_v5;
	
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded" ]		= %airport_civ_dying_groupB_wounded;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull" ]			= %airport_civ_dying_groupB_pull;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_wounded_death" ] = %airport_civ_dying_groupB_wounded_death;
	level.scr_anim[ "generic" ][ "airport_civ_dying_groupB_pull_death" ]	= %airport_civ_dying_groupB_pull_death;
	level.scr_anim[ "generic" ][ "training_woundedwalk_soldier_1" ] 		= %training_woundedwalk_soldier_1;
	level.scr_anim[ "generic" ][ "training_woundedwalk_soldier_2" ]			= %training_woundedwalk_soldier_2;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_A_zombie" ]				= %hunted_dazed_walk_A_zombie;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_B_blind" ]				= %hunted_dazed_walk_B_blind;
	level.scr_anim[ "generic" ][ "hunted_dazed_walk_C_limp" ]				= %hunted_dazed_walk_C_limp;
	
	level.scr_anim[ "generic" ][ "doorkick_2_cqbrun" ]				= %doorkick_2_cqbrun;
	level.scr_anim[ "generic" ][ "doorkick_2_stand" ]				= %doorkick_2_stand;

	level.scr_anim[ "generic" ][ "rescue_pres_run" ]						= %rescue_pres_run;
	level.scr_anim[ "generic" ][ "rescue_enemy_breach_run_1" ]				= %rescue_enemy_breach_run_1;
	level.scr_anim[ "generic" ][ "rescue_enemy_breach_run_2" ]				= %rescue_enemy_breach_run_2;
	level.scr_anim[ "generic" ][ "rescue_enemy_breach_run_3" ]				= %rescue_enemy_breach_run_3;
	level.scr_anim[ "generic" ][ "rescue_pres_breach_run_holder" ]			= %rescue_pres_breach_run_holder;
	level.scr_anim[ "generic" ][ "rescue_pres_breach_run_pres" ]			= %rescue_pres_breach_run_pres;
	level.scr_anim[ "generic" ][ "rescue_pres_breach_run_pres_death" ]		= %rescue_pres_breach_run_pres_death;
	level.scr_anim[ "generic" ][ "rescue_pres_breach_run_pres_survives" ]	= %rescue_pres_getup_fall;
	
	level.scr_anim[ "generic" ][ "breach_react_desk_v2" ]				= %breach_react_desk_v2;
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ]				= %breach_react_push_guy1;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ]				= %breach_react_push_guy2;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v2" ]			= %breach_react_blowback_v2;
	level.scr_anim[ "generic" ][ "breach_react_blowback_v3" ]			= %breach_react_blowback_v3;
	
	level.scr_anim[ "alena" ][ "rescue_chair_untie" ]			= %rescue_chair_untie_girl_1;
	level.scr_anim[ "price" ][ "rescue_chair_untie" ]			= %rescue_chair_untie_price;
	
	addnotetrack_attach( "price", "knife_give", "weapon_parabolic_knife", "tag_inhand", "rescue_chair_untie" );
	addnotetrack_detach( "price", "knife_take", "weapon_parabolic_knife", "tag_inhand", "rescue_chair_untie" );
	
	level.scr_anim[ "sandman" ][ "rescue_chair_untie" ]			= %rescue_chair_untie_soap;
	level.scr_anim[ "generic" ][ "rescue_chair_untie" ]			= %rescue_chair_untie_soldier;
	level.scr_anim[ "generic" ][ "rescue_chair_untie_idle" ][0]	= %rescue_chair_untie_soldier_idle;
	level.scr_anim[ "alena" ][ "rescue_chair_untie_idle" ][0]	= %rescue_chair_untie_girl_2;
	
	level.scr_anim[ "generic" ][ "exposed_dive_grenade_f" ]				= %exposed_dive_grenade_f;
	
	level.scr_anim[ "generic" ][ "exposed_dive_grenade_b" ]				= %exposed_dive_grenade_b;
	level.scr_anim[ "generic" ][ "exposed_death_blowback" ]				= %exposed_death_blowback;
	level.scr_anim[ "generic" ][ "stand_death_shoulder_spin" ]				= %stand_death_shoulder_spin;
	level.scr_anim[ "generic" ][ "ch_pragueb_7_5_crosscourt_aimantle_a" ]				= %ch_pragueb_7_5_crosscourt_aimantle_a;
	
	level.scr_anim[ "generic" ][ "pres_getup_idle" ][0]						= %rescue_pres_getup_loop;
	level.scr_anim[ "generic" ][ "pres_getup_president" ]					= %rescue_pres_getup_pres;
	level.scr_anim[ "generic" ][ "pres_getup_sandman" ]						= %rescue_pres_getup_price; 	// sandman is price and price is sandman!
	level.scr_anim[ "generic" ][ "pres_getup_price" ]						= %rescue_pres_getup_sandman; 	// sandman is price and price is sandman!
	
	addnotetrack_attach( "generic", "attach knife", "weapon_parabolic_knife", "tag_inhand", "pres_getup_price" );
	addnotetrack_detach( "generic", "detach knife", "weapon_parabolic_knife", "tag_inhand", "pres_getup_price" );
//	addnotetrack_detach( "generic", "remove flexcuff", "prop_flex_cuff", "tag_inhand", "pres_getup_president" );
	
	level.scr_anim[ "generic" ][ "rescue_blocked_door" ]					= %rescue_blocked_door;
	
	 //saw door breach
	 level.scr_anim[ "truck" ][ "breach_kick_kickerR1_enter" ]					= %breach_kick_kickerR1_enter;
	 level.scr_anim[ "generic" ][ "breach_sh_stackr1_idle" ]					= %breach_sh_stackr1_idle;
	 level.scr_anim[ "generic" ][ "active_patrolwalk_gundown" ]					= %active_patrolwalk_gundown;
	 
	 level.scr_anim[ "generic" ][ "afgan_caves_price_slide" ]					= %afgan_caves_price_slide;
	 level.scr_anim[ "truck" ][ "afgan_caves_price_slide" ]					= %afgan_caves_price_slide;
	 level.scr_anim[ "price" ][ "afgan_caves_price_slide" ]					= %afgan_caves_price_slide;
	 level.scr_anim[ "grinch" ][ "afgan_caves_price_slide" ]					= %afgan_caves_price_slide;
	 level.scr_anim[ "sandman" ][ "afgan_caves_price_slide" ]					= %afgan_caves_price_slide;


	// new anims for the elevator scene 
	level.scr_anim[ "price" ][ "rescue_elevator_speaking_price" ]			= %rescue_elevator_speaking_price;
	level.scr_anim[ "sandman" ][ "rescue_elevator_speaking_sandman" ]		= %rescue_elevator_speaking_sandman;	 


	level.scr_anim[ "price" ][ "melee_f_awin_attack" ]		= %melee_f_awin_attack;
	level.scr_anim[ "generic" ][ "melee_f_awin_defend" ]		= %melee_f_awin_defend;
	
	level.scr_anim[ "truck" ][ "ny_manhattan_radio_talk_idle" ]		= %ny_manhattan_radio_talk_idle;
	level.scr_anim[ "grinch" ][ "ny_manhattan_radio_talk_idle" ]		= %ny_manhattan_radio_talk_idle;
	level.scr_anim[ "delta_two" ][ "ny_manhattan_radio_talk_idle" ]		= %ny_manhattan_radio_talk_idle;
	
	level.scr_anim[ "truck" ][ "ny_manhattan_radio_sandman_talk" ]		= %ny_manhattan_radio_sandman_talk;
	level.scr_anim[ "grinch" ][ "ny_manhattan_radio_sandman_talk" ]		= %ny_manhattan_radio_sandman_talk;
	level.scr_anim[ "generic" ][ "ny_manhattan_radio_sandman_talk" ]		= %ny_manhattan_radio_sandman_talk;
	
	level.scr_anim[ "generic" ][ "corner_standL_alert_idle" ][0]		= %corner_standL_alert_idle;
	

}

explosion_deaths()
{
	level.explosion_deaths = [];
	level.explosion_deaths[ level.explosion_deaths.size ] = %death_explosion_stand_B_v1;
	level.explosion_deaths[ level.explosion_deaths.size ] = %death_explosion_stand_L_v1;
	level.explosion_deaths[ level.explosion_deaths.size ] = %death_explosion_stand_F_v1;
	level.explosion_deaths[ level.explosion_deaths.size ] = %death_explosion_stand_R_v1;
	level.explosion_deaths[ level.explosion_deaths.size ] = %death_explosion_forward_superfar;
}

sounds()
{
	level.scr_sound[ "launch_chopsaw1" ]				 = "launch_chopsaw1";
	level.scr_sound[ "launch_chopsaw2" ]				 = "launch_chopsaw2";
//	level.scr_sound[ "bridge_creaking" ]				 = "bridge_creaking";
//	level.scr_sound[ "hamburg_crush_tank" ]				 = "hamburg_crush_tank";
//	level.scr_sound[ "hamburg_garage_collapse" ]				 = "hamburg_garage_collapse";
//	level.scr_sound[ "scn_bridge_collapse" ]				 = "scn_bridge_collapse";
	
}

suburban_minigun_overrides()
{
	positions = vehicle_scripts\_suburban_minigun::setanims();
	positions = suburban_shared_overrides( positions );
	return positions;
}

suburban_overrides()
{
	positions = vehicle_scripts\_suburban::setanims();
	positions = suburban_shared_overrides( positions );

	positions[ 1 ].death = %uaz_rear_driver_death;
	positions[ 2 ].death = %uaz_rear_driver_death;
	positions[ 3 ].death = %uaz_rear_driver_death;

	return positions;
}

suburban_shared_overrides( positions )
{
	/*
	UAZ_Lguy_fire_side_v1
	UAZ_Lguy_fire_side_v2
	UAZ_Lguy_idle_hide

	UAZ_Rguy_scan_side_v1
	UAZ_Rguy_idle
	*/

	positions[ 1 ].hide_attack_left[ 0 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 1 ].hide_attack_left[ 1 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 1 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 1 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 2 ].hide_attack_left[ 0 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 2 ].hide_attack_left[ 1 ] = %UAZ_Rguy_scan_side_v1;
	positions[ 2 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 2 ].hide_attack_left_occurrence[ 1 ] = 500;

	positions[ 3 ].hide_attack_left[ 0 ] = %UAZ_Lguy_fire_side_v1;
	positions[ 3 ].hide_attack_left[ 1 ] = %UAZ_Lguy_fire_side_v2;
	positions[ 3 ].hide_attack_left_occurrence[ 0 ] = 500;
	positions[ 3 ].hide_attack_left_occurrence[ 1 ] = 500;

	return positions;
}

drone_deaths()
{
	level.scr_anim[ "generic" ][ "RPG_stand_death_stagger" ]				= %RPG_stand_death_stagger;
	level.scr_anim[ "generic" ][ "run_death_fallonback" ]				= %run_death_fallonback;
	level.scr_anim[ "generic" ][ "run_death_roll" ]				= %run_death_roll;
	
	level.drone_deaths_f = [];
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_forward_crumple;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_roll;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_flop;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %run_death_fallonback;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_onleft;
	level.drone_deaths_f[ level.drone_deaths_f.size ] = %death_run_onfront;
}

sparks_start(guy)
{
	guy thread maps\rescue_2_code::saw_sparks();
}
sparks_stop(guy)
{
	guy notify( "stop_sparks" );
}

burn_decal_prep(guy)
{
	guy thread maps\rescue_2_code::burn_decal_start();
}

spawn_dropped_saw(guy)
{
	PlayFXOnTag( getfx( "ball_bounce_dust" ), guy, "tag_inhand" );
	PlayFXOnTag( getfx( "ball_bounce_dust" ), guy, "tag_inhand" );
	wait(0.01);
	//origin = spawn ( script)
	saw = Spawn( "script_model", guy gettagorigin("tag_inhand") );
	playfx( level._effect[ "ball_bounce_dust" ], saw.origin, ( -6, 0, 1 ) );
	playfx( level._effect[ "ball_bounce_dust" ], saw.origin, ( -3, 4, 1 ) );
	saw.angles = guy gettagangles("tag_inhand"); 
	saw SetModel( "weapon_saw_rescue" );
}

addOnStart_animSound_chopsaw_foley()
{
	// This function generates errors unless delayed until the end of the frame.  I haven't confirmed but I think 
	// this is because _load has to create level.scr_notetrack first.
	waittillframeend;
	addOnStart_animSound( "truck", "rescue_saw_cutter", "scn_rescue_chopsaw_foley" );
}
saw_open_door()
{
	// saw sequence.
	level.scr_anim[ "truck" ][ "saw_side_pickup" ]			= %saw_side_pickup; // runs up and grabs saw, then places it on wall
	level.scr_anim[ "truck" ][ "saw_side_idleA" ]				= %saw_side_idleA; // sawing from up to down
	level.scr_anim[ "truck" ][ "saw_side_drop" ]				= %saw_side_drop; // use this as the ending.
	
	level.scr_anim[ "delta" ][ "saw_side_pull_idle" ]			= %saw_side_pull_idle;
	level.scr_anim[ "delta" ][ "saw_side_trans_b_2_pull" ]	= %saw_side_trans_b_2_pull;
	level.scr_anim[ "delta" ][ "saw_side_trans_A_2_B" ]		= %saw_side_trans_A_2_B;
	level.scr_anim[ "delta" ][ "saw_side_idleB" ]				= %saw_side_idleB;
	
	level.scr_anim[ "truck" ][ "rescue_saw_cutter" ]				= %rescue_saw_cutter;
	
	
	thread addOnStart_animSound_chopsaw_foley();
	addNotetrack_attach( "truck", "pickup", "weapon_saw_rescue", "TAG_INHAND", "rescue_saw_cutter" );
	addNotetrack_detach( "truck", "chopsaw_drop", "weapon_saw_rescue", "TAG_INHAND", "rescue_saw_cutter" );
	addNotetrack_customFunction( "truck", "start", ::sparks_start, "rescue_saw_cutter" );
	addNotetrack_customFunction( "truck", "stop", ::sparks_stop, "rescue_saw_cutter" );
	addNotetrack_customFunction( "truck", "start", ::burn_decal_prep, "rescue_saw_cutter" );
	addNotetrack_customFunction( "truck", "chopsaw_drop", ::spawn_dropped_saw, "rescue_saw_cutter" );
	

}

group_scenes()
{
	level.scr_anim[ "sandman" ][ "ending_last_stand" ]		= %rescue_ending_delta_last_stand_sandman;
	level.scr_anim[ "grinch" ][ "ending_last_stand" ]		= %rescue_ending_delta_last_stand_grinch;
	level.scr_anim[ "truck" ][ "ending_last_stand" ]		= %rescue_ending_delta_last_stand_truck;
	
	addNotetrack_customFunction( "sandman", "fire", maps\rescue_2_cavern_code::retreat_fire, "ending_last_stand" );
	addNotetrack_customFunction( "grinch", "fire", maps\rescue_2_cavern_code::retreat_fire, "ending_last_stand" );
	addNotetrack_customFunction( "truck", "fire", maps\rescue_2_cavern_code::retreat_fire, "ending_last_stand" );
	
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_sandman" ] = %rescue_ending_delta_retreat_sandman;
	addNotetrack_flag( "generic", "old_retreat_start", "old_retreat_start", "rescue_ending_delta_retreat_sandman" );
	addnotetrack_attach( "generic", "knife_pickup", "weapon_parabolic_knife", "TAG_INHAND", "rescue_ending_delta_retreat_sandman" );
	addnotetrack_detach( "generic", "knife_throw", "weapon_parabolic_knife", "TAG_INHAND", "rescue_ending_delta_retreat_sandman" );
	addnotetrack_attach( "generic", "attach clip right", "weapon_m16_clip_iw5", "TAG_INHAND", "rescue_ending_delta_retreat_sandman" );
	addnotetrack_detach( "generic", "detach clip right", "weapon_m16_clip_iw5", "TAG_INHAND", "rescue_ending_delta_retreat_sandman" );
	addNotetrack_customFunction( "generic", "knife_throw", ::knife_throw, "rescue_ending_delta_retreat_sandman" );
	addnotetrack_startfxontag( "generic", "knife_stab", "rescue_ending_delta_retreat_sandman", "bodyshot1", "TAG_INHAND" );
	addnotetrack_startfxontag( "generic", "bullet_hit", "rescue_ending_delta_retreat_sandman", "headshot1", "J_SHOULDER_RI" );
	addNotetrack_customFunction( "generic", "pistol_pickup", ::pistol_on_left, "rescue_ending_delta_retreat_sandman" );
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_sandman_ambusher" ] = %rescue_ending_delta_retreat_sandman_ambusher;
	addnotetrack_startfxontag( "generic", "knife_stab", "rescue_ending_delta_retreat_sandman_ambusher", "knife_stab", "J_NECK" );
	addnotetrack_startfxontag( "generic", "knife_pullout", "rescue_ending_delta_retreat_sandman_ambusher", "knife_stab", "J_NECK" );
	
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_truck" ] = %rescue_ending_delta_retreat_truck;
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_truck_ambusher" ] = %rescue_ending_delta_retreat_truck_ambusher;
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_grinch_v2" ] = %rescue_ending_delta_retreat_grinch_v2;
	
	
	addNotetrack_customFunction( "generic", "sandman_ambusher_start", maps\rescue_2_cavern_code::spawn_sandman_ambusher, "rescue_ending_delta_retreat_sandman" );
	addNotetrack_customFunction( "generic", "truck_ambusher_start", maps\rescue_2_cavern_code::spawn_truck_ambusher, "rescue_ending_delta_retreat_truck" );
	addNotetrack_customFunction( "generic", "fire", maps\rescue_2_cavern_code::retreat_fire, "rescue_ending_delta_retreat_sandman" );
	addNotetrack_customFunction( "generic", "fire", maps\rescue_2_cavern_code::retreat_fire, "rescue_ending_delta_retreat_truck" );
	
	addNotetrack_customFunction( "generic", "dropgun", ::grinch_drop_fake_gun, "rescue_ending_delta_retreat_grinch_v2" );
	addNotetrack_customFunction( "generic", "pistol_pickup", ::attach_left_pistol, "rescue_ending_delta_retreat_grinch_v2" );
	addNotetrack_customFunction( "generic", "fire_left", ::shoot_left, "rescue_ending_delta_retreat_grinch_v2" );
	addNotetrack_customFunction( "generic", "fire", maps\rescue_2_cavern_code::retreat_fire, "rescue_ending_delta_retreat_grinch_v2" );
	
	level.scr_anim[ "generic" ][ "rescue_ending_player_drag_handoff_truck" ] = %rescue_ending_player_drag_handoff_truck;
	level.scr_anim[ "generic" ][ "rescue_ending_player_drag_handoff_sandman" ] = %rescue_ending_player_drag_handoff_sandman;
	level.scr_anim[ "generic" ][ "rescue_ending_player_drag_handoff_price" ] = %rescue_ending_player_drag_handoff_price;

	addNotetrack_customFunction( "generic", "fire", maps\rescue_2_cavern_code::retreat_fire, "rescue_ending_player_drag_handoff_sandman" );
	addNotetrack_customFunction( "generic", "fire", maps\rescue_2_cavern_code::retreat_fire, "rescue_ending_player_drag_handoff_price" );
	
	level.scr_anim[ "generic" ][ "BH_getin" ] = %rescue_ending_pres_heli_getin_truck;
	level.scr_anim[ "grinch" ][ "BH_getin" ] = %rescue_ending_pres_heli_getin_grinch;
	level.scr_anim[ "president" ][ "BH_getin" ] = %rescue_ending_pres_heli_getin_president;
	
	level.scr_anim[ "price" ][ "BH_anim" ] = %rescue_ending_player_into_BH_price;
	level.scr_anim[ "president" ][ "BH_anim" ] = %rescue_ending_player_into_BH_president;
	addnotetrack_flag( "price", "delta_laststand_start", "start_delta_last_stand", "BH_anim" );
	
	level.scr_anim[ "price" ][ "rescue_door_breach_p" ] = %rescue_door_breach_price;
	level.scr_anim[ "sandman" ][ "rescue_door_breach_s" ] = %rescue_door_breach_sandman;

}

#using_animtree( "script_model" );
script_model()
{
	level.scr_animtree[ "rope_two" ] = #animtree;
	level.scr_anim[ "rope_two" ][ "coop_bridge_rappel_L" ]	= %coop_bridge_rappel_L;
	level.scr_anim[ "rope_two" ][ "coop_bridge_rappel_R" ]	= %coop_bridge_rappel_R;
	level.scr_anim[ "rope_two" ][ "coop_ropedrop_01" ]		= %coop_ropedrop_01;
	
	level.scr_animtree[ "rope" ] = #animtree;
	level.scr_model[ "rope" ] = "weapon_rappel_rope_long";
	level.scr_anim[ "rope" ][ "rappel_1" ] = %rescue_rope_long_rappel_1;
	level.scr_anim[ "rope" ][ "rappel_2" ] = %rescue_rope_long_rappel_2;
	
	level.scr_animtree[ "carabiner" ] = #animtree;
	level.scr_model[ "carabiner" ] = "weapon_carabiner_thin_rope";
	level.scr_anim[ "carabiner" ][ "rappel_1" ] = %rescue_rope_carabiner_rappel_1;
	level.scr_anim[ "carabiner" ][ "rappel_2" ] = %rescue_rope_carabiner_rappel_2;
	
	level.scr_anim[ "fxanim" ][ "fxanim_castle_generator_mod" ][0] 	= %fxanim_castle_generator_anim;

	level.scr_anim[ "semtex" ][ "rescue_npc_plantcharges_1" ] = %rescue_semtex_belt_npc1;
	level.scr_anim[ "semtex" ][ "rescue_npc_plantcharges_2" ] = %rescue_semtex_belt_npc2;
	level.scr_anim[ "semtex" ][ "rescue_price_plantcharges" ] = %rescue_semtex_belt_price;
	
	level.scr_animtree[ "rappelrope" ] = #animtree;
	level.scr_model[ "rappelrope" ] = "rescue2_rappelrope";
	level.scr_anim[ "rappelrope" ][ "rappel_left_mount" ]		= %rescue_npc_rappel_hookup_left_rappelrope;
	level.scr_anim[ "rappelrope" ][ "rappel_right_mount" ]		= %rescue_npc_rappel_hookup_right_rappelrope;
	level.scr_anim[ "rappelrope" ][ "rappel_idle_left" ][0]			= %rescue_npc_rappel_idle_left_rappelrope;
	level.scr_anim[ "rappelrope" ][ "rappel_idle_right" ][0]		= %rescue_npc_rappel_idle_right_rappelrope;
	level.scr_anim[ "rappelrope" ][ "rappel" ]					= %rescue_npc_rappel_drop_rappelrope;
	
	level.scr_animtree[ "flexcuff" ] = #animtree;
	level.scr_model[ "flexcuff" ] = "prop_flex_cuff";
	level.scr_anim[ "flexcuff" ][ "rescue_chair_untie" ]					= %rescue_chair_untie_flex_cuffs;
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ] = #animtree;
	level.scr_model[ "player_rig" ] = "viewhands_player_yuri_europe";
	level.scr_anim[ "player_rig" ][ "rappel_1" ] = %rescue_player_rappel_1;
	level.scr_anim[ "player_rig" ][ "rappel_2" ] = %rescue_player_rappel_2_mirrored;

	level.scr_anim[ "generic" ][ "rescue_ending_player_drag_handoff_player" ] = %rescue_ending_player_drag_handoff_player;
	level.scr_anim[ "generic" ][ "rescue_ending_player_into_bh_player" ] = %rescue_ending_player_into_bh_player;
	level.scr_anim[ "generic" ][ "rescue_ending_pres_heli_getin_player" ] = %rescue_ending_pres_heli_getin_player;
	level.scr_anim[ "generic" ][ "rescue_ending_delta_retreat_player" ] = %rescue_ending_delta_retreat_player;
	
	addnotetrack_flag( "generic", "delta_retreat_start", "start_delta_retreat", "rescue_ending_player_drag_handoff_player" );
	
	level.scr_animtree[ "player_legs" ] = #animtree;
	level.scr_model[ "player_legs" ] = "viewlegs_generic";
	level.scr_anim[ "player_legs" ][ "rappel_1" ] = %rescue_player_legs_rappel_1;
	level.scr_anim[ "player_legs" ][ "rappel_2" ] = %rescue_player_legs_rappel_2;
	
	level.scr_anim[ "player_rig" ][ "floor_breach" ] = %semtex_belt_deploy_player;
	level.scr_animtree[ "semtexbelt" ] = #animtree;
	level.scr_model[ "semtexbelt" ] = "mil_semtex_belt";
	level.scr_anim[ "semtexbelt" ][ "floor_breach" ] = %semtex_belt_deploy;
	
	addNotetrack_startFXonTag( "semtexbelt", "blinky", "floor_breach", "detonator_light", "tag_fx" );
	addNotetrack_sound( "semtexbelt", "blinky", "floor_breach", "scn_detonator_beep" );

	level.scr_animtree[ "semtexbeltnofx" ] = #animtree;
	level.scr_model[ "semtexbeltnofx" ] = "mil_semtex_belt_obj";
	level.scr_anim[ "semtexbeltnofx" ][ "floor_breach" ] = %semtex_belt_deploy;
}

#using_animtree( "animated_props" );
props()
{
	level.scr_animtree[ "swinging_light" ] = #animtree;
	level.scr_anim[ "swinging_light" ][ "wind_medium" ][ 0 ] = %payback_const_hanging_light;
}

#using_animtree( "vehicles" );
vehicles()
{
	level.scr_animtree[ "blackhawk" ] = #animtree;
	level.scr_model[ "blackhawk" ] = "vehicle_blackhawk_hero_sas_night";
	level.scr_anim[ "blackhawk" ][ "dodge" ] = %rescue_blackhawk_dodge_rpg;
	level.scr_anim[ "blackhawk" ][ "rescue_ending_pres_heli_getin_blackhawk" ] = %rescue_ending_pres_heli_getin_blackhawk;
}

#using_animtree( "generic_human" );
dialogue()
{
	// Elevator
	// The President is being held on the other side of the diamond mine. price
		level.scr_sound["grinch"][ "rescue_pri_diamondmine" ] 	= "rescue_pri_diamondmine";
		
	//	easy grinch
		level.scr_sound["sandman"][ "rescue_pri_wayacross" ] = "rescue_pri_wayacross";
		
	//	Roger that.  Our guys should be in full force down there already. sandman
		level.scr_sound["sandman"][ "rescue_snd_rogerthat" ] 		= "rescue_snd_rogerthat";
		
	//	Let's just hope he's still alive.
		level.scr_radio[ "rescue_pri_stillalive" ] 		= "rescue_pri_stillalive";
		
	//	Stack up.
		level.scr_sound["sandman"][ "rescue_snd_stackup" ] 		= "rescue_snd_stackup";	
		
	//	What the hell was that?!
		level.scr_sound["generic"][ "rescue_snd_whatwasthat" ] 		= "rescue_snd_whatwasthat";	
	//	This is a bloody death trap!
		level.scr_sound["generic"][ "rescue_pri_deathtrap" ] 		= "rescue_pri_deathtrap";			
	
	// First caves
	//	Truck, Grinch - take topside!
		level.scr_sound["truck"][ "rescue_snd_taketopside" ] 		= "rescue_snd_taketopside";		
		
	//	The rest of you - on me!
		level.scr_sound["price"][ "rescue_pri_onme" ] 		= "rescue_pri_onme";
	
	// Zip line caves
		//	Targets!  Twelve o' clock high!
		level.scr_sound["truck"][ "rescue_trk_targetshigh" ] 		= "rescue_trk_targetshigh";

	//	I see em!
		level.scr_sound["grinch"][ "rescue_rno_iseeem" ] 		= "rescue_rno_iseeem";

	//	Sort 'em out!
		level.scr_sound["price"][ "rescue_pri_sortemout" ] 		= "rescue_pri_sortemout";	
	
	// Saw door
	//	Truck - you're up.
		level.scr_sound["sandman"][ "rescue_snd_youreup" ] 		= "rescue_snd_youreup";		
		
	//	Truck - on it!
		level.scr_sound["truck"][ "rescue_trk_onit" ] 		= "rescue_trk_onit";		
		
	// Bay
		//	They're closing the main doors!
		level.scr_sound["truck"][ "rescue_rno_closingdoors" ] 		= "rescue_rno_closingdoors";		
		
	//	Keep moving!  Go!
		level.scr_sound["price"][ "rescue_pri_keepmoving" ] 		= "rescue_pri_keepmoving";	
		
	//	We need another way out of here.
		level.scr_sound["grinch"][ "rescue_rno_needanotherway" ] 		= "rescue_rno_needanotherway";	
		
	//	Take the stairwell.  This way.
		level.scr_sound["sandman"][ "rescue_snd_takestairwell" ] 		= "rescue_snd_takestairwell";		
		
	//	Overlord, this is Sandman.  We're at the bottom of the mine - can you bring in support?
		level.scr_radio[ "rescue_snd_bringinsupport" ] 		= "rescue_snd_bringinsupport";		
		
	//	Affirmative, Sandman.  We'll chop a predator to you.
		level.scr_radio[ "rescue_hqr_chopapredator" ] 		= "rescue_hqr_chopapredator";		
		
	//	Ready?
		level.scr_sound["sandman"][ "rescue_snd_ready" ] 	= "rescue_snd_ready";	
		
	//	Go!
		level.scr_sound["price"][ "rescue_pri_go" ] 		= "rescue_pri_go";		
		level.scr_sound["generic"][ "rescue_pri_go" ] 		= "rescue_pri_go";		
	
	// yard
	//	Predator is online!  Take out their armor!
		level.scr_radio[ "rescue_snd_takeoutarmor" ] 		= "rescue_snd_takeoutarmor";			

	//	Take out those choppers!
		level.scr_radio[ "rescue_snd_takeoutchoppers" ] 		= "rescue_snd_takeoutchoppers";					
		
	//	Use the predator and take out the targets!
		level.scr_sound["sandman"][ "rescue_snd_usepredator" ] 		= "rescue_snd_usepredator";						
		
	//	One down!  Hit the other one!
		level.scr_radio[ "rescue_snd_onedown" ] 		= "rescue_snd_onedown";						
		
	//	Take out that last group, Yuri!
		level.scr_radio[ "rescue_pri_takeoutlastgroup" ] 		= "rescue_pri_takeoutlastgroup";						

	//	Stop wasting time, Yuri!  Take out the targets!
		level.scr_radio[ "rescue_pri_wastingtime" ] 		= "rescue_pri_wastingtime";								

	//	Nice work!
		level.scr_sound["sandman"][ "rescue_snd_nicework" ] 		= "rescue_snd_nicework";
		level.scr_radio[ "rescue_snd_nicework" ] 		= "rescue_snd_nicework";
		
	//	The President is just across the yard!  
		level.scr_sound["price"][ "rescue_pri_acrosstheyard" ] 		= "rescue_pri_acrosstheyard";	
		
	//	Let's move!
		level.scr_sound["sandman"][ "rescue_snd_letsmove" ] 		= "rescue_snd_letsmove";	
		
	// all clear	
		level.scr_sound["grinch"][ "rescue_rno_allclear" ] 		= "rescue_rno_allclear";	
		
	// lets move
		level.scr_sound["sandman"][ "rescue_snd_letsmove" ] 		= "rescue_snd_letsmove";	
	//	We have to get that door open!lets_move
	
		level.scr_sound["price"][ "rescue_pri_dooropen" ] 		= "rescue_pri_dooropen";
		
	//	How soon until that Predator is back online?
		level.scr_sound[ "rescue_pri_predatorback" ] 		= "rescue_pri_predatorback";
		  
	//	Overlord, we need another Predator!
		level.scr_sound["sandman"][ "rescue_snd_needpredator" ] 		= "rescue_snd_needpredator";
		
		level.scr_sound["sandman"][ "rescue_snd_tookoutuav" ] 		= "rescue_snd_tookoutuav";
		level.scr_sound["sandman"][ "rescue_snd_anotherway" ] 		= "rescue_snd_anotherway";
		
	//	We stay here and we're gonna get pinned down!
		level.scr_sound["price"][ "rescue_pri_getpinneddown" ] 		= "rescue_pri_getpinneddown";
		 
	//	Overlord - where the hell is the Predator?!
		level.scr_sound["sandman"][ "rescue_snd_whereispredator" ] 		= "rescue_snd_whereispredator";
		 
		
	//	Get inside!  Go!  Go!
		level.scr_sound["sandman"][ "rescue_snd_getinside" ] 		= "rescue_snd_getinside";									
		level.scr_radio[ "rescue_snd_getinside" ] 		= "rescue_snd_getinside";
		
		// in ele
		level.scr_sound["grinch"][ "rescue_rno_12oclock" ] 		= "rescue_rno_12oclock";
		level.scr_radio[ "rescue_rno_12oclock" ] 		= "rescue_rno_12oclock";
		
		// get the doors open
		level.scr_sound["sandman"][ "rescue_snd_getdoorsopen" ] 		= "rescue_snd_getdoorsopen";
		
		// Look out
		level.scr_sound["mccoy"][ "rescue_mcy_lookout" ] 		= "rescue_mcy_lookout";
		
		level.scr_radio[ "rescue_ru4_outthere" ] 		= "rescue_ru4_outthere";
		level.scr_radio[ "rescue_ru3_openfire" ] 		= "rescue_ru3_openfire";
		level.scr_radio[ "rescue_ru2_stayaway" ] 		= "rescue_ru2_stayaway";
		level.scr_radio[ "rescue_ru1_getready" ]		= "rescue_ru1_getready";	
					
					
				
				
		
// ****************************************** Part Deux **********************************************
	
	//Sandman: Overlord, we're in!  Approaching the target now.
	level.scr_radio[ "rescue_snd_holdingcell" ]			= "rescue_snd_holdingcell";

	//Price: Yuri, take care of the door.
	level.scr_sound[ "price" ][ "rescue_pri_openitup" ] 		= "rescue_pri_openitup";
	//Truck: Wait!
	level.scr_sound[ "truck" ][ "rescue_pri_bloody" ] 			= "rescue_pri_bloody";
	//Overlord: Metal Zero One - what is your status?  Have you secured the President?
	level.scr_radio[ "rescue_hqr_securedpresident" ] 			= "rescue_hqr_securedpresident";
	//Sandman: Negative, Overlord.  But we have the girl.
	level.scr_radio[ "rescue_snd_foundathena" ] 				= "rescue_snd_foundathena";
	//Overlord: We'll prep a team for extraction.  Continue searching for the President.
	level.scr_radio[ "rescue_hqr_sendinateam" ] 				= "rescue_hqr_sendinateam";
	//Truck: She says they took her father deeper in to the mine.
	level.scr_sound[ "truck" ][ "rescue_trk_furtherdown" ] 		= "rescue_trk_furtherdown";
	//Sandman: Then that's where we're going.  C'mon.
	level.scr_sound[ "sandman" ][ "rescue_snd_maybealive" ] 	= "rescue_snd_maybealive";
	//Truck: She's trying to say something…
	level.scr_sound[ "truck" ][ "rescue_trk_tryingtosay" ] 	= "rescue_trk_tryingtosay";
	
	//Price: On the catwalk!
	level.scr_sound[ "price" ][ "rescue_pri_onthecatwalk" ] 		 = "rescue_pri_onthecatwalk";
	//Grinch: There he is!  I see him!
	level.scr_sound[ "grinch" ][ "rescue_rno_thereheis" ] 		 = "rescue_rno_thereheis";
	//Price: Then we're not too late!  Keep pushing!
	level.scr_sound[ "price" ][ "rescue_pri_nottoolate" ] 		 = "rescue_pri_nottoolate";
	//Sandman: Hook up!
	level.scr_sound[ "sandman" ][ "rescue_snd_hookup" ]			 = "rescue_snd_hookup";
	//Sandman: Stop wasting time!  Hook up!
	level.scr_radio[ "rescue_snd_stopwasting" ] 				 = "rescue_snd_stopwasting";
	
	//Sandman: We're losin' him!  Let's go!
	level.scr_sound[ "sandman" ][ "rescue_snd_losinghim" ]		 = "rescue_snd_losinghim";
	//Sandman: C'mon, this way!
	level.scr_sound[ "sandman" ][ "rescue_snd_thisway" ]		 = "rescue_snd_thisway";
	//Price: Yuri!  Get back here!
	level.scr_sound[ "price" ][ "rescue_pri_yurigetbackhere" ]		 = "rescue_pri_yurigetbackhere";
	//Price: Where are you going?!
	level.scr_sound[ "price" ][ "rescue_pri_whereareyougoing" ]		 = "rescue_pri_whereareyougoing";

	//Grinch: There they are!
	level.scr_sound[ "grinch" ][ "rescue_rno_theretheyare" ]	 = "rescue_rno_theretheyare";
	level.scr_radio[ "rescue_snd_exactlocation" ]				 = "rescue_snd_exactlocation";
	//Price: It's reinforced steel.  We can't get through this!
	level.scr_sound[ "price" ][ "rescue_pri_cantbreak" ]		 = "rescue_pri_cantbreak";
	//Grinch: Any bright ideas?
	level.scr_sound[ "grinch" ][ "rescue_rno_brightideas" ] 	 = "rescue_rno_brightideas";
	//Price: I've got one.  Up top.  Follow me.
	level.scr_sound[ "price" ][ "rescue_pri_breachuptop" ]		 = "rescue_pri_breachuptop";
	//Grinch: We gotta go, now!
	level.scr_sound[ "grinch" ][ "rescue_rno_gottago" ]			 = "rescue_rno_gottago";
	//Grinch: Clear!
	level.scr_sound[ "grinch" ][ "rescue_rno_clear2" ]			 = "rescue_rno_clear2";

	//Price: Get charges here, here and here!
	level.scr_sound[ "price" ][ "rescue_pri_chargeshere" ] = "rescue_pri_chargeshere";
	level.scr_sound[ "price" ][ "rescue_pri_stackup" ] = "rescue_pri_stackup";
	//Sandman: Stack up.
	level.scr_sound[ "sandman" ][ "rescue_snd_stackup2" ]		 = "rescue_snd_stackup2";
	//Sandman: Overlord - jackpot.  The President is secure.
	level.scr_radio[ "rescue_snd_jackpot" ]						 = "rescue_snd_jackpot";
	//Overlord: Solid Copy.  Gather your team and proceed to the RV.
	level.scr_radio[ "rescue_hqr_extractionpoint" ]				 = "rescue_hqr_extractionpoint";
	//Sandman: Overlord, this place is gonna collapse any minute!  The birds need to come to us!
	level.scr_radio[ "rescue_snd_bringbirdtous" ]				 = "rescue_snd_bringbirdtous";
	//Overlord: Copy that.  Hammer One is now en route.  ETA thirty seconds.  Stand by.
	level.scr_radio[ "rescue_hqr_twobirds" ]					 = "rescue_hqr_twobirds";
	
	//Sandman: Hold this position!  Evac will be here in thirty seconds!
	level.scr_sound[ "sandman" ][ "rescue_snd_holdposition" ]		= "rescue_snd_holdposition";
	//Truck: More bad guys inbound!
	level.scr_sound[ "truck" ][ "rescue_trk_badguys" ]			 	= "rescue_trk_badguys";
	//Grinch: Watch the left flank!
	level.scr_sound[ "grinch" ][ "rescue_rno_enemiesonflank" ]	 	= "rescue_rno_enemiesonflank";
	//Sandman: Hammer One - you gonna bail us out of this or what?
	level.scr_radio[ "rescue_snd_bailusout" ] 						= "rescue_snd_bailusout";
	//Hammer One: Almost there.  Just hold on.
	level.scr_radio[ "rescue_hp1_almostthere" ] 					= "rescue_hp1_almostthere";
	
	//Grinch: Looks like our ride's here!
	level.scr_radio[ "rescue_snd_ourride" ]							= "rescue_snd_ourride";
	//Hammer One: Metal Zero One, this is Vulture Six - let's get the hell out of here.
	level.scr_radio[ "rescue_hp1_getouttahere" ] 					= "rescue_hp1_getouttahere";
	//Sandman: Sounds good, Six One! 
	level.scr_radio[ "rescue_snd_soundsgood" ]						= "rescue_snd_soundsgood";
	//Sandman: Alright - let's move!  Go!
	level.scr_sound[ "sandman" ][ "rescue_snd_letsmove2" ] 			= "rescue_snd_letsmove2";
	
	//Hammer One-Six: Get the President on board - we gotta get the hell outta here!
	level.scr_radio[ "rescue_hp2_presidenton" ]						= "rescue_hp2_presidenton";
	//Hammer One-Six: RPG!  Move!  Move!
	level.scr_radio[ "rescue_hp2_rpgmove" ]							= "rescue_hp2_rpgmove";
	//Hammer One-Six: Hang on!!
	level.scr_radio[ "rescue_hp2_hangon" ]							= "rescue_hp2_hangon";
	//Hammer One-Six: We can't stay here!  We gotta leave!
	level.scr_radio[ "rescue_hp2_gottaleave" ]						= "rescue_hp2_gottaleave";
	//Hammer One-Six: It's too hot!  We go back - we all die!
	level.scr_radio[ "rescue_hp2_toohot" ]							= "rescue_hp2_toohot";

	level.scr_sound[ "price" ][ "rescue_pri_prepexfil" ] = "rescue_pri_prepexfil";
	level.scr_sound[ "price" ][ "rescue_pri_gethimback" ] = "rescue_pri_gethimback";
	level.scr_sound[ "price" ][ "rescue_pri_deeperin" ] = "rescue_pri_deeperin";

	//Price: She's alright.  She's alive.
	level.scr_sound[ "price" ][ "rescue_pri_shesalive" ] = "rescue_pri_shesalive";
	//Price: Move! Move!
	level.scr_sound[ "price" ][ "rescue_pri_movemove" ] = "rescue_pri_movemove";
	//Price: Yuri!  YURI!
	level.scr_radio[ "rescue_pri_yurisdown" ] = "rescue_pri_yurisdown";
	//Price: Don't even think about it mate!  We're in this together!
	level.scr_sound[ "price" ][ "rescue_pri_dontthink" ] = "rescue_pri_dontthink";
	//Price: You better be right behind me!
	level.scr_sound[ "price" ][ "rescue_pri_betterbe" ] = "rescue_pri_betterbe";
	//Price: Sandman!  It's time to go!  C'mon!
	level.scr_sound[ "price" ][ "rescue_pri_timetogo" ] = "rescue_pri_timetogo";
	//Price: No!!!!!!!!
	level.scr_sound[ "price" ][ "rescue_pri_no" ] = "rescue_pri_no";
	//Price: Get us back down there!!!
	level.scr_sound[ "price" ][ "rescue_pri_backdown" ] = "rescue_pri_backdown";
	//Price: Sandman, do you read me?!
	level.scr_sound[ "price" ][ "rescue_pri_readme" ] = "rescue_pri_readme";
	//Price: Sandman…come in!
	level.scr_sound[ "price" ][ "rescue_pri_comein" ] = "rescue_pri_comein";
	//Price: Sandman…do you copy?
	level.scr_sound[ "price" ][ "rescue_pri_doyoucopy" ] = "rescue_pri_doyoucopy";
	//Price: Sandman…are you still there???
	level.scr_sound[ "price" ][ "rescue_pri_stillthere" ] = "rescue_pri_stillthere";

	level.scr_face[ "price" ][ "rescue_pri_readme" ] = %rescue_ending_player_into_bh_price_vo_readme;
	level.scr_face[ "price" ][ "rescue_pri_backdown" ] = %rescue_ending_player_into_bh_price_vo_backdown;
	level.scr_face[ "price" ][ "rescue_pri_comein" ] = %rescue_ending_player_into_bh_price_vo_comein;
	level.scr_face[ "price" ][ "rescue_pri_doyoucopy" ] = %rescue_ending_player_into_bh_price_vo_doyoucopy;
	level.scr_face[ "price" ][ "rescue_pri_comein" ] = %rescue_ending_player_into_bh_price_vo_readme;
	
	level.scr_sound[ "generic" ][ "rescue_aln_mumbles" ] = "rescue_aln_mumbles";

	//Sandman: Price!! You gotta go!  Make sure the president gets out!
	level.scr_sound[ "sandman" ][ "rescue_snd_gottago" ] = "rescue_snd_gottago";
	//Sandman: Grab your guy and get on the damn bird!!  We'll cover you!!
	level.scr_radio[ "rescue_snd_toomuchheat" ] = "rescue_snd_toomuchheat";
	//Sandman: Truck!  Cover the right side!!
	level.scr_sound[ "sandman" ][ "rescue_snd_coverright" ] = "rescue_snd_coverright";
	//Sandman: Just GO!  Get outta here!
	level.scr_radio[ "rescue_snd_justgo" ] = "rescue_snd_justgo";
	//Sandman: Just go!!! GO!!!!
	level.scr_radio[ "rescue_snd_goooo" ] = "rescue_snd_goooo";

	//Truck: They're closing the main doors!
	level.scr_sound[ "grinch" ][ "rescue_rno_closingdoors" ] = "rescue_rno_closingdoors";
	//Grinch: There they are!
	level.scr_sound[ "grinch" ][ "rescue_rno_theretheyare" ] = "rescue_rno_theretheyare";
	level.scr_sound[ "grinch" ][ "rescue_rno_gettocover" ] = "rescue_rno_gettocover";
	//Grinch: Out!
	level.scr_sound[ "grinch" ][ "rescue_rno_help" ] = "rescue_rno_help";
	//Grinch: President's secure!
	level.scr_sound[ "grinch" ][ "rescue_rno_pressecure" ] = "rescue_rno_pressecure";
	//Grinch: RPG!
	level.scr_radio[ "rescue_rno_rpg" ] = "rescue_rno_rpg";

	//Truck: What the hell!
	level.scr_sound[ "truck" ][ "rescue_trk_whatthe" ] = "rescue_trk_whatthe";
	//Truck: RPG!!
	level.scr_sound[ "truck" ][ "rescue_trk_rpg" ] = "rescue_trk_rpg";
	//Truck: RPG!!
	level.scr_radio[ "rescue_trk_rpg" ] = "rescue_trk_rpg";
	//Truck: Hang on!  I got ya!
	level.scr_sound[ "truck" ][ "rescue_trk_igotyou" ] = "rescue_trk_igotyou";
	//Truck: I'm out!
	level.scr_sound[ "truck" ][ "rescue_trk_imout" ] = "rescue_trk_imout";
	
	//Overlord: Solid Copy.  Gather your team and proceed to the RV.
	level.scr_radio[ "rescue_hqr_extractionpoint" ] = "rescue_hqr_extractionpoint";
	//Overlord: Copy that.  Hammer One is now en route.  ETA thirty seconds.  Stand by.
	level.scr_radio[ "rescue_hqr_twobirds" ] = "rescue_hqr_twobirds";

	//Russian President: My daughter…
	level.scr_sound[ "president" ][ "rescue_prs_daughter" ] = "rescue_prs_daughter";

	//Blackhawk pilot: Pull up!! Pull up!
	level.scr_radio[ "rescue_bhp_pullup" ] = "rescue_bhp_pullup";
	//Blackhawk pilot: Hang on!!
	level.scr_radio[ "rescue_bhp_hangon" ] = "rescue_bhp_hangon";
	//Blackhawk pilot: He's right!  We gotta move now!
	level.scr_radio[ "rescue_bhp_movenow" ] = "rescue_bhp_movenow";
	
	//Littlebird pilot: I'm hit! I'm hit!
	level.scr_radio[ "rescue_lbp_imhit" ] = "rescue_lbp_imhit";
	//Littlebird pilot: Going down!
	level.scr_radio[ "rescue_lbp_goindown" ] = "rescue_lbp_goindown";

	//US News Reporter: Thousands of people have gathed today to greet President Gurevich in his return to Moscow…
	level.scr_radio[ "rescue_nws_gatheredtoday" ] = "rescue_nws_gatheredtoday";
	//US News Reporter: … reports have confirmed that peace talks between Russia and the US are about to begin...
	level.scr_radio[ "rescue_nws_reportsconfirm" ] = "rescue_nws_reportsconfirm";
	//US News Reporter: In other news, the Ultranationalist Leader, Vladamir Makarov, is still at large.
	level.scr_radio[ "rescue_nws_othernews" ] = "rescue_nws_othernews";

	level.scr_sound[ "truck" ][ "rescue_trk_throughdoor" ] = "rescue_trk_throughdoor";
	level.scr_sound[ "truck" ][ "rescue_trk_daughter" ] = "rescue_trk_daughter";
	level.scr_sound[ "truck" ][ "rescue_trk_blastdoors" ] = "rescue_trk_blastdoors";
	level.scr_sound[ "truck" ][ "rescue_rno_thereitis" ] = "rescue_rno_thereitis";

	level.scr_sound[ "generic" ][ "rescue_dlt1_confirmstation" ] = "rescue_dlt1_confirmstation";

	level.scr_radio[ "US_1_threat_rpg" ] = "US_1_threat_rpg";
	
	// truck get these doors open.
	level.scr_sound["sandman"][ "rescue_snd_getdoorsopen" ] = "rescue_snd_getdoorsopen";
	// status
	level.scr_sound["sandman"][ "rescue_snd_status" ] = "rescue_snd_status";
	// keep moving
	level.scr_sound["sandman"][ "rescue_snd_keepmoving" ] = "rescue_snd_keepmoving";
	// keep moving heads up
	
	level.scr_sound["sandman"][ "rescue_snd_headsup" ] 		= "rescue_snd_headsup";
	level.scr_sound["sandman"][ "rescue_snd_sweepleft" ] 		= "rescue_snd_sweepleft";
	
	// get ready
	level.scr_sound["sandman"][ "rescue_snd_getready" ] = "rescue_snd_getready";
	
	// hop the rail move it.
	level.scr_sound["sandman"][ "rescue_snd_hoptherail" ] = "rescue_snd_hoptherail";
	
	// overloard a sam just took out our uav.
	level.scr_radio[ "rescue_snd_tookoutuav" ] = "rescue_snd_tookoutuav";
	
	// we need another way into the mine
	level.scr_radio[ "rescue_snd_anotherway" ] = "rescue_snd_anotherway";
	
	// everyone sit tight
	level.scr_sound["sandman"][ "rescue_snd_sittight"] = "rescue_snd_sittight";
	
	// cut through the contrsuction yard there's more cover.
	level.scr_sound["sandman"][ "rescue_snd_cutthrough" ] = "rescue_snd_cutthrough";
	
	// viper six were moving to the contrsuction yard... over
	// call these witht he friendly fire littlebirds
	level.scr_sound["sandman"][ "rescue_snd_watchfire" ] = "rescue_snd_watchfire";
	
	// price
	// the president is just across the yard
	level.scr_sound["price"][ "rescue_pri_acrosstheyard" ] = "rescue_pri_acrosstheyard";
	
	// we stay here and were gonna get pinned down.
	level.scr_sound["price"][ "rescue_pri_getpinneddown" ] = "rescue_pri_getpinneddown";
	
	// status
	level.scr_sound["grinch"][ "rescue_rno_wereclear" ] = "rescue_rno_wereclear";
	
	// were clear
	level.scr_sound["grinch"][ "rescue_rno_wereclear" ] = "rescue_rno_wereclear";

	// were clear
	level.scr_sound["truck"][ "rescue_rno_imgood" ] = "rescue_rno_imgood";

	// keep moving
	level.scr_radio[ "rescue_snd_keepmoving" ] = "rescue_snd_keepmoving";
	
	// Heads up!
	level.scr_radio[ "rescue_snd_headsup" ] = "rescue_snd_headsup";	
	
	// more bad guys dead ahead
	//level.scr_radio[ "rescue_trk_targetshigh" ] = "rescue_trk_targetshigh";	

	// all clear, call this before truck opens up the gate.
	level.scr_radio[ "rescue_rno_allclear" ] = "rescue_rno_allclear";		
	
	// They should be on the other side of the mine.
	level.scr_radio[ "rescue_snd_shouldbe" ] = "rescue_snd_shouldbe";		

	// Secondaries
	level.scr_radio[ "rescue_rno_secondaries" ] = "rescue_rno_secondaries";		

	// sit tight
	level.scr_radio[ "rescue_snd_sittight" ] = "rescue_snd_sittight";		

	// Hot damn
	level.scr_radio[ "rescue_rno_hotdamn" ] = "rescue_rno_hotdamn";	
	
	// HIND
	level.scr_radio[ "rescue_rno_hind" ] = "rescue_rno_hind";
	
	// cmon this way		
	level.scr_radio[ "rescue_snd_thisway" ] = "rescue_snd_thisway";

	// cmon this way		
	level.scr_radio[ "rescue_snd_sittight" ] = "rescue_snd_sittight";
	
	//Viper Six, team is on the ground.  Going in to cover pattern.
	level.scr_radio[ "rescue_lp1_coverpattern" ] = "rescue_lp1_coverpattern";
	
	// Viper four troops are on deck
	level.scr_radio[ "rescue_lp1_ondeck" ] = "rescue_lp1_ondeck";
	
	//	Viper Four, takin' out targets at the construction site.  Inbound and hot.
	level.scr_radio[ "rescue_lp1_constructionsite" ] = "rescue_lp1_constructionsite";
	
	// got a hind on my tail.
	level.scr_radio[ "rescue_lp1_gottahind" ] = "rescue_lp1_gottahind";	
	
	// Grinch, hot damn
	level.scr_radio[ "rescue_rno_hotdamn" ] = "rescue_rno_hotdamn";	
	
	level.scr_radio[ "rescue_hqr_fullagms" ] = "rescue_hqr_fullagms";
	
	level.scr_radio[ "rescue_lp1_engaging" ] = "rescue_lp1_engaging";
	
	level.scr_radio[ "rescue_lp1_gunshot" ] = "rescue_lp1_gunshot";
	
	level.scr_radio[ "rescue_lp1_nextarea" ] = "rescue_lp1_nextarea";
	
	
	level.scr_radio[ "rescue_lp1_nextarea" ] = "rescue_lp1_nextarea";
	
	level.scr_radio[ "rescue_hqr_payloadtarget" ] = "rescue_hqr_payloadtarget";
	
	//now
	level.scr_sound["price"][ "rescue_pri_now" ] = "rescue_pri_now";
	
	// We're not getting in there without some heavy firepower!
	level.scr_sound["price"][ "rescue_pri_heavyfire" ] = "rescue_pri_heavyfire";
	
	 // Now that's more like it!
	 level.scr_sound["price"][ "rescue_pri_morelikeit" ] = "rescue_pri_morelikeit";
 
 	level.scr_radio[ "rescue_lp1_gunsguns" ] = "rescue_lp1_gunsguns";


}

#using_animtree( "script_model" );
generator_anims()
{
	a_generators = GetEntArray( "fxanim_castle_generator_mod", "targetname" );
	foreach ( m_generator in a_generators )
	{
		m_generator.animname = "fxanim";
		m_generator UseAnimTree( #animtree );
		m_generator thread anim_loop_solo( m_generator, "fxanim_castle_generator_mod" );
		wait RandomFloatRange( .1, 3 );
	}
}

shoot_left( guy )
{
	w = guy.left_weapon;
	
	org = w getTagOrigin( "tag_flash" );
	ang = w getTagAngles( "tag_flash" );
	fwd = AnglesToForward( ang );
	
	PlayFXOnTag( getfx( "deserteagle_muzzleflash" ), w, "tag_flash" );
	MagicBullet( "deserteagle", org, org + fwd );
	guy.kill_timeout = 200;
	maps\rescue_2_cavern_code::retreat_fire( guy );
}

attach_left_pistol( guy )
{
	org = guy getTagOrigin( "tag_weapon_left" );
	p = spawn( "script_model", org );
	p setModel( "weapon_desert_eagle_iw5" );
	p HidePart( "tag_silencer" );
	
	p linkTo( guy, "tag_weapon_left", (0,0,0), (0,0,0) );
	
	guy.left_weapon = p;
}

knife_throw( guy )
{
	start = level.sandman getTagOrigin( "TAG_INHAND" );
	end = get_target_ent( "sandman_knife_destination" );
	knife = spawn( "script_model", start );
	knife setModel( "weapon_parabolic_knife" );
	knife.angles = VectorToAngles( end.origin - start );
	knife moveTo( end.origin, 0.15 );
	knife waittill( "movedone" );
	org = level.sandman_knife_guy getTagOrigin( "tag_eye" );
	knife.origin = org;
	knife linkTo( level.sandman_knife_guy, "tag_eye" );

	wait( 3 );

	knife delete();
}

grinch_drop_fake_gun( guy )
{
	weapon = guy.weapon;

	if ( weapon == "none" )
		return;

	guy animscripts\shared::detachAllWeaponModels();

	position = guy.weaponInfo[ weapon ].position;

	if ( position != "none" )
		guy thread DropFakeWeaponWrapper( weapon, position );

	guy animscripts\shared::detachWeapon( weapon );
	if ( weapon == guy.weapon )
		guy.weapon = "none";

	guy animscripts\shared::updateAttachedWeaponModels();
}

DropFakeWeaponWrapper( weapon, position )
{
	// this must be between calls to detachAllWeaponModels and updateAttachedWeaponModels!

	if ( self IsRagdoll() )
		return "none"; // too late. our weapon is no longer where it looks like it is.

	assert( self.a.weaponPosDropping[ position ] == "none" );
	self.a.weaponPosDropping[ position ] = weapon;

	actualDroppedWeapon = weapon;
	if ( issubstr( tolower( actualDroppedWeapon ), "rpg" ) )
		actualDroppedWeapon = "rpg_player";

	// unless we're already in the process of dropping more than one weapon,
	// this will not actually create the weapon until the next frame, so it can get the tag's velocity.
	org = self getTagOrigin( "tag_weapon_right" );
	ang = self getTagAngles( "tag_weapon_right" );
	weap = Spawn( "script_model", org );
	weap.angles = ang;
	m = getWeaponModel( weapon );
	weap setModel( m );
	weap PhysicsLaunchClient( weap.origin, (0,0,0) );

	// So we want to wait a bit before detaching the model.

	// No waiting before this point!
	self endon( "end_weapon_drop_" + position );
	wait .1;

	if ( !isDefined( self ) )
		return;
		
	self animscripts\shared::detachAllWeaponModels();
	self.a.weaponPosDropping[ position ] = "none";
	self animscripts\shared::updateAttachedWeaponModels();
}

show_charge( guy )
{
	if ( isdefined( guy.charge ) )
		guy.charge show();
}

pistol_on_left( guy )
{
	wait( 0.05 );
	guy animscripts\shared::placeWeaponOn( guy.weapon, "left" );
}

init_uav_radio_dialogue()
{
	if ( !IsDefined( level.scr_radio ) )
	{
		level.scr_radio = [];
	}

	level.uav_radio_initialized = true;

	// Offline / Online
	level.scr_radio[ "uav_reloading" ] 				 = "null";
	level.scr_radio[ "uav_offline" ] 				 = "null";
	level.scr_radio[ "uav_online" ] 				 = "rescue_snd_nicework";
	level.scr_radio[ "uav_online_repeat" ] 			 = "rescue_pri_wastingtime";

	level.scr_radio[ "uav_down" ] 					 = "null";

	// AI Kills
	level.scr_radio[ "uav_multi_kill" ] 			 = "rescue_hqr_fivepluskills";
	level.scr_radio[ "uav_multi_kill2" ] 			 = "rescue_hqr_fivepluskills";
	level.scr_radio[ "uav_few_kills" ] 				 = "rescue_hqr_goodhit";
	level.scr_radio[ "uav_3_kills" ] 				 = "rescue_hqr_nicework";
	level.scr_radio[ "uav_1_kill" ] 				 = "rescue_hqr_goodhit";
	
	level.scr_radio[ "uav_0_kill" ] 				 = "rescue_hqr_thatsamiss";
	level.scr_radio[ "uav_0_kill2" ] 				 = "Rescue_Hqr_Zerokills";

	level.scr_radio[ "uav_multi_vehicle_kill" ] 	 = "rescue_hqr_nicework";
	level.scr_radio[ "uav_multi_vehicle_kill2" ] 	 = "rescue_hqr_goodhit";

	level.scr_radio[ "uav_helo_kill" ] 				 = "rescue_hqr_goodhit";
	level.scr_radio[ "uav_btr_kill" ] 				 = "rescue_hqr_nicework";
	level.scr_radio[ "uav_truck_kill" ] 			 = "rescue_hqr_goodhit";
	level.scr_radio[ "uav_jeep_kill" ] 				 = "rescue_hqr_nicework";
	level.scr_radio[ "uav_direct_hit" ] 			 = "null";
}