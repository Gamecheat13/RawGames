#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	player_anims();
	scripted_anims();
	generic_anims();
	open_area_vehicle_objects();
	open_area_script_objects();
	angel_flare_rig_anims();
	courtyard_curtains();
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_arms" ] 					 		= #animtree;
	level.scr_model[ "player_arms" ] 							= "viewhands_player_delta";
	level.scr_anim[ "player_arms" ][ "hummer_exit" ] 	= %paris_ac130_run_around_humvee_player;
	
	flag_init("notetrack_flag_sandman_start");
	addNotetrack_flag( "player_arms", "sandman_start", "notetrack_flag_sandman_start",  "hummer_exit" );
}



#using_animtree( "script_model" );
scripted_anims()
{
	level.scr_animtree[ "player_dragged" ] = #animtree;
	
	level.scr_anim[ "player_dragged" ][ "ANIM_player_dragged_top" ] 	= %paris_ac130_osprey_crash_player;
	level.scr_anim[ "player_dragged" ][ "ANIM_player_dragged_bottom" ] 	= %paris_ac130_osprey_crash_player_legs;

}

#using_animtree( "generic_human" );
generic_anims()
{
	level.scr_animtree[ "generic" ]								= #animtree;
	
	// Enemies
	
    //  -- Dying and Crawling
    
    level.scr_anim[ "generic" ][ "dying_crawl_looping" ]        = %dying_crawl_looping;
    
    // -- RPGs
    
    level.scr_anim[ "generic" ][ "RPG_conceal_2_standL" ] 		= %RPG_conceal_2_standL;
    level.scr_anim[ "generic" ][ "RPG_conceal_2_standR" ] 		= %RPG_conceal_2_standR;
    level.scr_anim[ "generic" ][ "RPG_standR_2_conceal" ] 		= %RPG_standR_2_conceal;
    level.scr_anim[ "generic" ][ "RPG_standL_2_conceal" ] 		= %RPG_standL_2_conceal;
    level.scr_anim[ "generic" ][ "RPG_conceal_idle" ] 			= %RPG_conceal_idle;
    level.scr_anim[ "generic" ][ "RPG_stand_twitch_v1" ] 		= %RPG_stand_twitch_v1; 
    
    // Drone
    
    level.scr_animtree[ "drone" ] 								= #animtree;
    
    // -- Patrol
    
    level.scr_anim[ "generic" ][ "patrol_jog" ]                 = %patrol_jog;
    level.scr_anim[ "generic" ][ "patrol_walk" ]                = %active_patrolwalk_v1;
    level.scr_anim[ "generic" ][ "patrol_bored_idle" ]          = %patrol_bored_idle;
    
    // -- Flee
    
    level.scr_anim[ "generic" ][ "run_lowready_F" ]             = %run_lowready_F;
    
    // -- Panic
    
    level.scr_anim[ "generic" ][ "hunted_tunnel_guy1_lookup" ]  = %hunted_tunnel_guy1_lookup;
    level.scr_anim[ "generic" ][ "unarmed_crouch_idle1" ]       = %unarmed_crouch_idle1;
    level.scr_anim[ "generic" ][ "unarmed_crouch_twitch1" ]     = %unarmed_crouch_twitch1;
    
    // -- Run
    
    level.scr_anim[ "generic" ][ "run_n_gun_F" ]				= %run_n_gun_F;
    
    // -- Jump
    
    level.scr_anim[ "generic" ][ "favela_escape_bigjump_soap" ] = %favela_escape_bigjump_soap;
    
    // -- Death
    
    level.scr_anim[ "generic" ][ "death_run_onfront" ]          = %death_run_onfront;
    level.scr_anim[ "generic" ][ "death_run_onleft" ]           = %death_run_onleft;
    level.scr_anim[ "generic" ][ "death_run_forward_crumple" ]  = %death_run_forward_crumple;
    
    // -- Fire Weapon
    
    level.scr_anim[ "generic" ][ "africa_body_flying_explosion" ]	= %crouch_cover_stand_aim_straight;
    
    // Friendlies
    level.scr_anim[ "generic" ][ "exposed_death_headshot" ]     = %africa_body_flying_explosion;
    level.scr_anim[ "generic" ][ "exposed_death_headshot" ]     = %exposed_death_headshot;
    level.scr_anim[ "generic" ][ "exposed_death_headtwist" ]    = %exposed_death_headtwist;
    
    level.scr_anim[ "generic" ][ "run_react_stumble_non_loop" ] = %run_react_stumble_non_loop;
    level.scr_anim[ "generic" ][ "prone_aim_5" ][ 0 ]           = %prone_aim_5;
    level.scr_anim[ "generic" ][ "prone_aim_5" ][ 1 ]           = %prone_aim_5;
    
    level.scr_anim[ "generic" ][ "corner_standR_explosion_divedown" ] 	= %corner_standR_explosion_divedown;
    level.scr_anim[ "generic" ][ "corner_standR_explosion_idle" ] 		= %corner_standR_explosion_idle;
    level.scr_anim[ "generic" ][ "corner_standR_explosion_standup" ] 	= %corner_standR_explosion_standup;
    
    level.scr_anim[ "generic" ][ "ANIM_intro_delta_shock_1" ]			= %exposed_flashbang_v1;
    level.scr_anim[ "generic" ][ "ANIM_intro_delta_shock_2" ]			= %exposed_flashbang_v2;
    level.scr_anim[ "generic" ][ "ANIM_intro_delta_shock_3" ]			= %exposed_flashbang_v3;
    level.scr_anim[ "generic" ][ "ANIM_intro_delta_shock_4" ]			= %exposed_flashbang_v4;
    level.scr_anim[ "generic" ][ "ANIM_intro_hvt_shock" ]				= %exposed_flashbang_v5;
    
    level.scr_anim[ "generic" ][ "ANIM_hvt_escape_dive_and_capture_hvt" ] = %traverse_window_M_2_dive;
    
    level.scr_anim[ "generic" ][ "ANIM_intro_sandman_opening" ]				= %paris_ac130_sandman_opening;
    level.scr_anim[ "generic" ][ "ANIM_intro_sandman_dragging_player" ]		= %paris_ac130_osprey_crash_sandman_dragplayer;
    level.scr_anim[ "generic" ][ "ANIM_intro_sandman_call_air_support" ]	= %paris_ac130_sandman_rescue_talk;
    
   	level.scr_anim[ "generic" ][ "ANIM_intro_player_dragged" ]			= %airport_civ_dying_groupb_wounded_relative;
   	
   	level.scr_anim[ "generic" ][ "setup_pose" ] 		= %casual_stand_idle;
   	level.scr_anim[ "generic" ][ "ANIM_throw_grenade" ]	= %coverstand_grenadea;
    
    // HVT
    level.scr_anim[ "generic" ][ "hostage_stand_fall" ]			= %hostage_stand_fall;
    level.scr_anim[ "generic" ][ "hostage_knees_fall" ]			= %hostage_knees_fall;
    level.scr_anim[ "generic" ][ "paris_ac130_hostage_run" ]	= %paris_ac130_hostage_run;
    
    level.scr_anim[ "generic" ][ "ANIM_hvt_escape_traversal_into_building" ] = %traverse_window_M_2_stop;
    
    level.scr_anim[ "generic" ][ "ANIM_hvt_idle_loop" ][ 0 ] 	= %wounded_carry_closet_idle_wounded;
    
    //New hvt anims 5.2010
     level.scr_anim[ "hvt" ][ "intro_hvt_idle" ][ 0 ] 	= %paris_ac130_hvt_idle_b;
     level.scr_anim[ "guard" ][ "intro_hvt_idle" ][ 0 ] 	= %paris_ac130_hvt_idle_a;
     
      level.scr_anim[ "guard" ][ "intro_hvt_arrive_guard" ]	= %paris_ac130_hvt_setdown_l_a;
      level.scr_anim[ "hvt" ][ "intro_hvt_arrive_hvt" ]	= %paris_ac130_hvt_setdown_l_b;
     
    
    // Guard + Hostage
    // - Escort
    
    level.scr_anim[ "generic" ][ "ANIM_guard_cover_idle_loop" ][ 0 ] 	= %paris_ac130_guard_cover_idle;
    level.scr_anim[ "generic" ][ "ANIM_guard_cover_out" ] 				= %paris_ac130_guard_cover_out;
    level.scr_anim[ "generic" ][ "ANIM_guard_run_loop" ] 				= %paris_ac130_guard_run;
    level.scr_anim[ "generic" ][ "ANIM_guard_cover_into" ] 				= %paris_ac130_guard_cover_into;
    
    level.scr_anim[ "generic" ][ "ANIM_hostage_cover_idle_loop" ][ 0 ]		= %paris_ac130_hostage_cover_idle;
    level.scr_anim[ "generic" ][ "ANIM_hostage_cover_out" ]					= %paris_ac130_hostage_cover_out;
    level.scr_anim[ "generic" ][ "ANIM_hostage_run_loop" ][ 0 ]				= %paris_ac130_hostage_run_relative;
    level.scr_anim[ "generic" ][ "ANIM_hostage_cover_into" ]				= %paris_ac130_hostage_cover_into;
    
   	// - Carry
   
   	level.scr_anim[ "generic" ][ "ANIM_hostage_wounded_idle" ][ 0 ]			= %wounded_carry_closet_idle_wounded;
	level.scr_anim[ "generic" ][ "ANIM_hostage_wounded_pickup" ]			= %wounded_carry_pickup_closet_wounded_straight;
	level.scr_anim[ "generic" ][ "ANIM_hostage_wounded_walk_loop" ][ 0 ]	= %wounded_carry_sprint_wounded_relative;
	level.scr_anim[ "generic" ][ "ANIM_hostage_wounded_putdown" ]		 	= %wounded_carry_putdown_closet_wounded;
	
	level.scr_anim[ "generic" ][ "ANIM_guard_carrier_pickup" ]		 		= %wounded_carry_pickup_closet_carrier_straight;
	level.scr_anim[ "generic" ][ "ANIM_guard_carrier_walk_loop" ]		 	= %wounded_carry_sprint_carrier;
	level.scr_anim[ "generic" ][ "ANIM_guard_carrier_putdown" ]		 		= %wounded_carry_putdown_closet_carrier;
	
    // Dying and Crawling
    
    level.scr_anim[ "crawl_death_1" ][ "crawl" ]		 		= %civilian_crawl_1;
	level.scr_anim[ "crawl_death_1" ][ "death" ][ 0 ]		 	= %civilian_crawl_1_death_A;
	level.scr_anim[ "crawl_death_1" ][ "death" ][ 1 ]		 	= %civilian_crawl_1_death_B;
	level.scr_anim[ "crawl_death_1" ][ "blood_fx_rate" ]		= .5;
	level.scr_anim[ "crawl_death_1" ][ "blood_fx" ]				= "blood_drip";
	
	level.scr_anim[ "crawl_death_2" ][ "crawl" ]		 		= %civilian_crawl_2;
	level.scr_anim[ "crawl_death_2" ][ "death" ][ 0 ]			= %civilian_crawl_2_death_A;
	level.scr_anim[ "crawl_death_2" ][ "death" ][ 1 ]			= %civilian_crawl_2_death_B;  
	level.scr_anim[ "crawl_death_2" ][ "blood_fx_rate" ]		= .25;
	
	level.scr_anim[ "generic" ][ "dying_stand_2_crawl_v3" ]		= %dying_stand_2_crawl_v3;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v3" ]		= %dying_crawl_death_v3;
	
	// Opsrey Crash
	
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_flyin_pilot" ] 	= %paris_ac130_osprey_flyin_pilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_flyin_copilot" ] 	= %paris_ac130_osprey_flyin_copilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_flyin_gunner" ] 	= %paris_ac130_osprey_flyin_gunner;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_idle_pilot" ] 	= %paris_ac130_osprey_idle_pilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_idle_copilot" ] 	= %paris_ac130_osprey_idle_copilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_idle_gunner" ] 	= %paris_ac130_osprey_idle_gunner;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_crash_pilot" ] 	= %paris_ac130_osprey_crash_pilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_crash_copilot" ] 	= %paris_ac130_osprey_crash_copilot;
	level.scr_anim[ "generic" ][ "ANIM_paris_ac130_osprey_crash_gunner" ] 	= %paris_ac130_osprey_crash_gunner;
}

#using_animtree( "vehicles" );
open_area_vehicle_objects()
{
	level.scr_anim[ "missle_boat_a" ][ "paris_ac130_ship_sink" ] 	= %paris_ac130_ship_sink;
	level.scr_animtree[ "missle_boat_a" ] 							= #animtree;
	
	level.scr_anim[ "barge_a" ][ "paris_ac130_barge_sink" ] 		= %paris_ac130_barge_sink;
	level.scr_animtree[ "barge_a" ] 								= #animtree;
	
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_opeing_a" ] 		= %paris_ac130_osprey_opeing_a;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_opeing_b" ] 		= %paris_ac130_osprey_opeing_b;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_opeing_c" ] 		= %paris_ac130_osprey_opeing_c;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_crash" ]			= %paris_ac130_osprey_crash;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_crash" ]			= %paris_ac130_osprey_crash;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_crash_vehicle1" ]	= %paris_ac130_osprey_crash_vehicle1;
	level.scr_anim[ "v22_osprey" ][ "paris_ac130_osprey_crash_vehicle2" ]	= %paris_ac130_osprey_crash_vehicle2;
	level.scr_anim[ "v22_osprey" ][ "ANIM_paris_ac130_osprey_crash_v2" ]	= %paris_ac130_osprey_crash_v2;
	level.scr_anim[ "v22_osprey" ][ "ANIM_paris_ac130_osprey_flyin" ]		= %paris_ac130_osprey_flyin;
	level.scr_anim[ "v22_osprey" ][ "ANIM_paris_ac130_osprey_idle" ]		= %paris_ac130_osprey_idle;
	level.scr_animtree[ "v22_osprey" ] 								= #animtree;
	
 	addNotetrack_startFXonTag( "v22_osprey", "rpg_impact", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_air_explosion", "tag_body" );
    addNotetrack_startFXonTag( "v22_osprey", "engine_blow", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_engine_explosion", "J_Blades_RI" );
    addNotetrack_startFXonTag( "v22_osprey", "engine_blow2", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_engine_explosion_sm", "J_Blades_RI" );
    addNotetrack_startFXonTag( "v22_osprey", "crash_ground_engine", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_crash_ground_engine", "J_Pivot_LE" );
//    addNotetrack_startFXonTag( "v22_osprey", "crash_ground", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_crash_ground", "J_Pivot_LE" );
    addNotetrack_startFXonTag( "v22_osprey", "blade_1_hit", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_blade_1_hit", "tag_blade1_ri_end_fx" );
    addNotetrack_startFXonTag( "v22_osprey", "blade_2_hit", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_blade_2_hit", "tag_blade2_ri_end_fx" );
    addNotetrack_startFXonTag( "v22_osprey", "blade_3_hit", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_blade_3_hit", "tag_blade3_ri_end_fx" );
    addNotetrack_startFXonTag( "v22_osprey", "skid_settle", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_dirt_kickup_settle", "TAG_SIDE_FX2" );
    addNotetrack_startFXonTag( "v22_osprey", "settle_lean", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_dirt_kickup_settle_small", "TAG_FRONT_FX1" );
    
    addNotetrack_startFXonTag( "v22_osprey", "side_skid_off", "ANIM_paris_ac130_osprey_crash_v2", "crash_heli_dustwave", "tag_body" );
    
    
//    addNotetrack_startFXonTag( "v22_osprey", "side_skid_on", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_side_skid", "tag_side_fx2" );
//    addNotetrack_startFXonTag( "v22_osprey", "nose_skid_on", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_nose_skid", "tag_front_fx2" );
//    addNotetrack_startFXonTag( "v22_osprey", "engine_skid_on", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_engine_skid", "tag_engine_le_fx2" );
    
//    addNotetrack_stopFXonTag( "v22_osprey", "side_skid_off", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_side_skid", "tag_side_fx2" );
//    addNotetrack_stopFXonTag( "v22_osprey", "nose_skid_off", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_nose_skid", "tag_front_fx2" );
//    addNotetrack_stopFXonTag( "v22_osprey", "engine_skid_off", "ANIM_paris_ac130_osprey_crash_v2", "FX_osprey_engine_skid", "tag_engine_le_fx2" );
	
	level.scr_animtree[ "car" ] 									= #animtree;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_1" ] 	= %paris_ac130_osprey_crash_car_01;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_2" ] 	= %paris_ac130_osprey_crash_car_02;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_3" ] 	= %paris_ac130_osprey_crash_car_03;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_4" ] 	= %paris_ac130_osprey_crash_car_04;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_5" ] 	= %paris_ac130_osprey_crash_car_05;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_6" ] 	= %paris_ac130_osprey_crash_car_06;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_7" ] 	= %paris_ac130_osprey_crash_car_07;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_8" ] 	= %paris_ac130_osprey_crash_car_08;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_9" ] 	= %paris_ac130_osprey_crash_car_09;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_10" ] 	= %paris_ac130_osprey_crash_car_10;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_11" ] 	= %paris_ac130_osprey_crash_car_11;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_12" ] 	= %paris_ac130_osprey_crash_car_12;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_13" ] 	= %paris_ac130_osprey_crash_car_13;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_14" ] 	= %paris_ac130_osprey_crash_car_14;
	level.scr_anim[ "car" ][ "paris_ac130_osprey_crash_car_15" ] 	= %paris_ac130_osprey_crash_car_15;
	
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_1", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_1", "car_explosion_ac130_car1", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_2", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_3", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_4", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_4", "car_explosion_ac130_car2", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_5", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_6", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_7", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_7", "car_explosion_ac130_car3", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_8", "FX_osprey_car_crash", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_8", "car_explosion_ac130_car2", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_9", "FX_osprey_car_crash", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_9", "car_explosion_ac130_car4_debris", "tag_origin" );
	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_9", "car_explosion_ac130_car1", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_10", "FX_osprey_car_crash", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_11", "FX_osprey_car_crash", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_12", "FX_osprey_car_crash", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_13", "FX_osprey_car_crash", "tag_origin" );
//	addNotetrack_startFXonTag( "car", "car_hit", "paris_ac130_osprey_crash_car_14", "FX_osprey_car_crash", "tag_origin" );

	
	level.scr_animtree[ "hummer" ] 								= #animtree;
	level.scr_anim[ "hummer" ][ "hummer_crash" ] 	= %paris_ac130_bridge_humvee_crash_car_01;
	level.scr_anim[ "hummer" ][ "hummer_exit" ] 	= %paris_ac130_run_around_humvee_door;
	
	//osprey crash notetracks
	//FRAME 1409 "rpg_impact"       ( 13.63333 )
	//FRAME 1497 "crash_ground"     ( 16.56667 )
	addNotetrack_customFunction( "v22_osprey", "rpg_impact", Maps\paris_ac130_slamzoom::notetrack_osprey_rpg_impact, "ANIM_paris_ac130_osprey_crash_v2" );
	addNotetrack_customFunction( "v22_osprey", "crash_ground", Maps\paris_ac130_slamzoom::notetrack_osprey_ground_impact, "ANIM_paris_ac130_osprey_crash_v2" );
	addNotetrack_customFunction( "v22_osprey", "rpg_impact", Maps\paris_ac130_slamzoom::notetrack_osprey_engine_smoke, "ANIM_paris_ac130_osprey_crash_v2" );
	addNotetrack_customFunction( "v22_osprey", "engine_blow", Maps\paris_ac130_slamzoom::notetrack_osprey_engine_fire, "ANIM_paris_ac130_osprey_crash_v2" );
	

	addNotetrack_customFunction( "v22_osprey", "side_skid_on", ::plane_body_scrape_start, "ANIM_paris_ac130_osprey_crash_v2" );
    addNotetrack_customFunction( "v22_osprey", "side_skid_off", ::plane_body_scrape_stop, "ANIM_paris_ac130_osprey_crash_v2" );
}

#using_animtree( "script_model" );
open_area_script_objects()
{
	level.scr_anim[ "radar_maz_a" ][ "ac130_radartower_crash" ] 	= %ac130_radartower_crash;
	level.scr_animtree[ "radar_maz_a" ] 							= #animtree;
}

#using_animtree( "script_model" );
angel_flare_rig_anims()
{
	level.scr_animtree[ "angel_flare_rig" ] 							= #animtree;
	level.scr_model[ "angel_flare_rig" ] 								= "angel_flare_rig";

	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][ 0 ]	= %ac130_angel_flares01;
	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][ 1 ]	= %ac130_angel_flares02;
	level.scr_anim[ "angel_flare_rig" ][ "ac130_angel_flares" ][ 2 ]	= %ac130_angel_flares03;

}

#using_animtree( "script_model" );
courtyard_curtains()
{
	level.scr_animtree[ "left_curtain" ] 							= #animtree;
	level.scr_model[ "left_curtain" ] 								= "com_curtains_left";
	level.scr_anim[ "left_curtain" ][ "left_curtain_wind" ][ 0 ]	= %ac_prs_curtain_le_wind;
	
	level.scr_animtree[ "right_curtain" ] 							= #animtree;
	level.scr_model[ "right_curtain" ] 								= "com_curtains_right";
	level.scr_anim[ "right_curtain" ][ "right_curtain_wind" ][ 0 ]	= %ac_prs_curtain_ri_wind;	
}

plane_body_scrape_start( guy )
{
    PlayFXOnTag( getfx( "FX_osprey_side_skid" ), guy, "TAG_SIDE_FX2" );
}

plane_body_scrape_stop( guy )
{
    StopFXOnTag( getfx( "FX_osprey_side_skid" ), guy, "TAG_SIDE_FX2" );
}