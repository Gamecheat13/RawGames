#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_props;

main()
{
	player_animations();
	npc_animations();
	script_models();
	animated_props();
	vehicles();

	// Dshk deathanim level callback func
	level.dshk_death_anim = ::dshk_death_anim_callback;
}

#using_animtree( "player" );
player_animations()
{
	//Default hands
	level.scr_animtree[ "player_rig" ] 								= #animtree;
	level.scr_model[ "player_rig" ] 								= "viewhands_player_delta";
	level.scr_animtree[ "player_rig_bloody" ]		 				= #animtree;
	level.scr_model[ "player_rig_bloody" ] 							= "viewhands_player_delta_dirty";
	
	
	//Rappel	
	level.scr_anim[ "player_rig" ][ "rappel_player" ]		= %berlin_player_rappel;
	level.scr_animtree[ "player_legs" ] 								= #animtree;
	level.scr_model[ "player_legs" ] 										= "viewlegs_generic"; //viewlegs_generic
	level.scr_anim[ "player_legs" ][ "rappel_player" ] 	= %berlin_player_legs_rappel;		
	
	
	//Building Collapse
	level.scr_anim[ "player_rig" ][ "bahn_tower" ]	= %berlin_sgt_down_bomb_hit_player;
	addNotetrack_customFunction( "player_rig", "vehicle_impact", maps\berlin_code::building_collapse_car_impact, "bahn_tower" );	
	
	level.scr_anim[ "player_rig_bloody" ][ "aftermath" ]	= %berlin_sgt_down_recovery_VM;
	addNotetrack_customFunction( "player_rig_bloody", "sandmanStart", ::aftermath_sandman_start, "aftermath" );
	
	
	//Reverse Breach
	level.scr_anim[ "player_rig" ]["reverse_breach"] = %berlin_reverse_breach_player;
	level.scr_anim[ "player_rig" ]["reverse_breach_idle"][0] = %berlin_reverse_breach_player_idle;
	level.scr_anim[ "player_rig" ]["reverse_breach_getup"] = %berlin_reveres_breach_player_getup;
	addNotetrack_customFunction( "player_rig", "weapon_pullout", maps\berlin_code::reverse_breach_weapon_pullout, "reverse_breach" );
	addNotetrack_customFunction( "player_rig", "door_breach", maps\berlin_code::reverse_breach_door_breach, "reverse_breach" );
	addNotetrack_customFunction( "player_rig", "draw_pistol", maps\berlin_code::reverse_breach_draw_pistol, "reverse_breach" );

	//A10
	level.scr_anim[ "player_rig" ]["goggles_on"] = %viewmodel_glock_NVG_puton;
	level.scr_anim[ "player_rig" ]["goggles_off"] = %viewmodel_glock_NVG_takeoff;
}

#using_animtree( "script_model" );
script_models()
{
	//Sniper
	level.scr_animtree[ "rope" ]																					= #animtree;
	level.scr_model[ "rope" ] 																						= "weapon_rappel_rope_long";
	
	level.scr_anim[ "rope" ][ "bravo_rappel_mount" ]											= %berlin_granite_team_rappel_intro_rope;
	level.scr_anim[ "rope" ][ "bravo_rappel_drop" ]												= %berlin_granite_team_rappel_drop_rope;
	level.scr_anim[ "rope" ][ "bravo_rappel_drop02" ]											= %berlin_granite_team_rappel_drop02_rope;
	level.scr_anim[ "rope" ][ "bravo_rappel_drop03" ]											= %berlin_granite_team_rappel_drop03_rope;
	level.scr_anim[ "rope" ][ "bravo_rappel_drop04" ]											= %berlin_granite_team_rappel_drop04_rope;
	level.scr_anim[ "rope" ][ "bravo_rappel_idle" ][ 0 ]									= %berlin_granite_team_rappel_idle_rope;
	
	
	//Rappel
	level.scr_animtree[ "ai_rope" ]																				= #animtree;
	level.scr_model[ "ai_rope" ]																					= "weapon_rappel_rope_long";	
	level.scr_anim[ "ai_rope" ][ "rappel_ai" ]														= %berlin_rappel_rope_long_npc;
	
	level.scr_animtree[ "rope_player" ]																		= #animtree;
	level.scr_model[ "rope_player" ]																			= "weapon_rappel_rope_long";	
	level.scr_anim[ "rope_player" ][ "rappel_player" ]										= %berlin_rope_long_rappel;
	level.scr_anim[ "rope_player" ][ "rappel_player_idle" ]						= %berlin_rappel_rope_long_npc;
	
	//rope to glow and show objective.
	level.scr_animtree[ "player_rope_long_obj" ] 													= #animtree;
	level.scr_model[ "player_rope_long_obj" ] 														= "weapon_rappel_rope_long_obj";
	level.scr_anim[ "player_rope_long_obj" ][ "rappel_player" ]						= %berlin_rappel_rope_long_npc;

	level.scr_animtree[ "rope_carabiner" ] 																= #animtree;		
	level.scr_model[ "rope_carabiner" ] 																	= "weapon_carabiner_thin_rope";
	level.scr_anim[ "rope_carabiner" ][ "rappel_player" ]									= %berlin_rope_carabiner_rappel;
	
	
	//Building Collapse
	PreCacheModel( "building_tower_fall"); 
	level.scr_anim[ "bahn_tower_collapse" ][ "bahn_tower" ] 							= %berlin_sgt_down_bldg_collapse_BLDG;  
	level.scr_animtree[ "bahn_tower_collapse" ]					 									= #animtree;
	level.scr_model[ "bahn_tower_collapse" ]						 									= "building_tower_fall";
	
	//falling debris and swinging wires
	PreCacheModel( "berlin_destroyed_bldg_animated_parts"); 
	level.scr_anim[ "berlin_sgt_down_recovery_wires" ][ "bahn_tower_parts" ] = %berlin_sgt_down_recovery_wires;
	level.scr_animtree[ "berlin_sgt_down_recovery_wires" ]					 			= #animtree;
	level.scr_model[ "berlin_sgt_down_recovery_wires" ]						 				= "berlin_destroyed_bldg_animated_parts";
	
	
	//Traverse Building
	//falling column
	PreCacheModel( "concrete_column_collapse"); 
	level.scr_anim[ "berlin_falling_column" ][ "falling_column" ] 				= %berlin_falling_column;  
	level.scr_animtree[ "berlin_falling_column" ]					 								= #animtree;
	level.scr_model[ "berlin_falling_column" ]						 								= "concrete_column_collapse";
	
  
  //Reverse Breach
  level.scr_anim[ "breach_door_model" ][ "breach" ]			 								= %breach_player_door_hinge_v1;
	level.scr_animtree[ "breach_door_model" ]					 										= #animtree;
	level.scr_model[ "breach_door_model" ]						 										= "com_door_piece_hinge5";
	
	level.scr_anim[ "reverse_breach_gun" ][ "reverse_breach_getup" ]			= %berlin_reveres_breach_beretta_getup;
	level.scr_anim[ "reverse_breach_gun" ][ "reverse_breach" ]			 			= %berlin_reveres_breach_beretta;
	level.scr_animtree[ "reverse_breach_gun" ]					 									= #animtree;
	level.scr_model[ "reverse_breach_gun" ]						 										= "weapon_fn_fiveseven_sp_iw5";
}

#using_animtree( "animated_props" );
animated_props()
{
	//nothing for now
}

#using_animtree( "generic_human" );
npc_animations()
{
	//Heli Ride
	level.scr_anim[ "generic" ][ "little_bird_death_guy1" ]	 			= %little_bird_death_guy1;
	level.scr_anim[ "generic" ][ "little_bird_death_guy2" ]	 			= %little_bird_death_guy2;
	level.scr_anim[ "generic" ][ "little_bird_death_guy3" ]	 			= %little_bird_death_guy3;
	
	
	//AA building
	level.scr_anim[ "generic" ][ "contengency_rocket_moment" ]		= %contengency_rocket_moment;
	addNotetrack_customFunction( "generic", "fire rocket", ::sniper_rooftop_attacker_fire_rocket, "contengency_rocket_moment" );
	
	
	//Sniper
	level.scr_anim[ "generic" ][ "bravo_rappel_mount" ] 				= %berlin_granite_team_rappel_intro;
	addNotetrack_customFunction( "generic", "ropeVis", ::sniper_rope_vis, "bravo_rappel_mount" );
	level.scr_anim[ "generic" ][ "bravo_rappel_drop" ] 					= %berlin_granite_team_rappel_drop;
	level.scr_anim[ "generic" ][ "bravo_rappel_drop02" ] 					= %berlin_granite_team_rappel_drop02;
	level.scr_anim[ "generic" ][ "bravo_rappel_drop03" ] 					= %berlin_granite_team_rappel_drop03;
	level.scr_anim[ "generic" ][ "bravo_rappel_drop04" ] 					= %berlin_granite_team_rappel_drop04;
	level.scr_anim[ "generic" ][ "bravo_rappel_idle" ][0] 				= %berlin_granite_team_rappel_idle;
	
	level.scr_anim[ "generic" ][ "prone_aim_idle" ][0]					= %prone_aim_idle;
	level.scr_anim[ "generic" ][ "berlin_crouch_2_spotting_idle" ][0]	= %berlin_crouch_2_spotting_idle;
	level.scr_anim[ "generic" ][ "berlin_crouch_2_spotting" ]			= %berlin_crouch_2_spotting;
	
	
	//Alley
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check" ] = %hunted_woundedhostage_check_hostage;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_idle_start" ]	= %hunted_woundedhostage_idle_start;
	level.scr_anim[ "generic" ][ "hunted_woundedhostage_check_end" ]		= %hunted_woundedhostage_idle_end;
	level.scr_anim[ "generic" ][ "dying_corpse_pose" ] = %dcburning_elevator_corpse_idle_B;
	
	
	//Building Collapse
	level.scr_anim[ "generic" ][ "dcburning_elevator_corpse_idle_B" ] = %dcburning_elevator_corpse_idle_B;
	level.scr_anim[ "generic" ][ "hunted_dying_deadguy_endidle" ] = %hunted_dying_deadguy_endidle;
	level.scr_anim[ "generic" ][ "dying_crawl" ] = %dying_crawl;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v1" ] = %dying_crawl_death_v1;
	level.scr_anim[ "generic" ][ "dying_crawl_death_v2" ] = %dying_crawl_death_v2;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_stumble" ] = %DC_Burning_bunker_stumble;
	level.scr_anim[ "generic" ][ "DC_Burning_bunker_sit_idle" ][0] = %DC_Burning_bunker_sit_idle;
	level.scr_anim[ "generic" ][ "civilain_crouch_hide_idle" ][0] = %civilain_crouch_hide_idle;
	level.scr_anim[ "generic" ][ "death_sitting_pose_v2" ] = %death_sitting_pose_v2;
	level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v02" ] = %paris_npc_dead_poses_v02;
	level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v06" ] = %paris_npc_dead_poses_v06;
	level.scr_anim[ "generic" ][ "paris_npc_dead_poses_v07" ] = %paris_npc_dead_poses_v07;
	
	
	//Traverse Building
	level.scr_anim[ "generic" ][ "cqb_to_ventwalk" ] 		= %berlin_cqb_to_ventwalk;
	level.scr_anim[ "generic" ][ "ventwalk" ] 		= %launchfacility_b_ventwalk_v1_cycle;
	level.scr_anim[ "generic" ][ "tank_corpse" ] 		= %berlin_tank_dead_pose;
	level.scr_anim[ "generic" ][ "slide" ] 		= %berlin_fallen_building_slide_npc;
	
	
	//Hotel
	level.scr_anim[ "generic" ][ "DRS_sprint" ]				 						= %sprint1_loop;
	
	
	//Reverse breach
	level.scr_anim[ "generic" ][ "reverse_breach_enemy_right" ]		= %berlin_reverse_breach_enemy_guy1;
	level.scr_anim[ "generic" ][ "reverse_breach_enemy_left" ]		= %berlin_reverse_breach_enemy_guy2;


	/*###########################
	#####PRESIDENT'S DAUGHTER####
	###########################*/
	
	//Reverse Breach
	level.scr_anim[ "alena" ][ "reverse_breach_idle" ][0]	 			= %berlin_reverse_breach_hind_girl_idle;
	level.scr_anim[ "alena" ][ "reverse_breach_getup" ]	 			= %berlin_reverse_breach_hind_girl_getup;
	
	
	/*######################
	##### HELI GUY 1 #######
	######################*/
	
	//Reverse Breach
	//level.scr_anim[ "guy_1" ][ "reverse_breach_idle" ][0]	 			= %berlin_reverse_breach_hind_guy1_idle;
	//level.scr_anim[ "guy_1" ][ "reverse_breach_getup" ]	 			= %berlin_reverse_breach_hind_guy1_getup;
	
	
	/*######################
	##### HELI GUY 2 #######
	######################*/
	
	//Reverse Breach
	level.scr_anim[ "guy_2" ][ "reverse_breach_idle" ][0]	 			= %berlin_reverse_breach_hind_guy2_idle;
	level.scr_anim[ "guy_2" ][ "reverse_breach_getup" ]	 			= %berlin_reverse_breach_hind_guy2_getup;
	
	
	/*######################
	#####LONE STAR ANIMS####
	######################*/
	
	//Intro/Building Collapse
	level.scr_anim[ "lone_star" ][ "bahn_tower" ] = %berlin_sgt_down_bomb_hit;
	level.scr_anim[ "lone_star" ][ "building_explosion_hit_wounded_loop" ][0] = %berlin_sgt_down_bomb_loop;
	
	level.scr_anim[ "lone_star" ][ "aftermath" ]	= %berlin_sgt_down_recovery_sgt;
	
	//Sandman: (CONT’D)Head for the building!
	level.scr_face[ "lone_star" ][ "head_for_building" ]	= %berlin_sgt_down_recovery_sgt_face;
	level.scr_sound[ "lone_star" ]["head_for_building"] = "berlin_cby_headforbuilding";
	
	level.scr_anim[ "lone_star" ][ "run" ]	= %afchase_shepherd_flee_loop;
	level.scr_anim[ "lone_star" ][ "patrol_jog" ]	= %patrol_jog;
	level.scr_anim[ "lone_star" ][ "patrol_jog_look_up" ]	= %patrol_jog_look_up;
	
	
	//Heli Ride
	level.scr_anim[ "lone_star" ][ "heli_ride" ][0]											= %berlin_littleb_intro_behaviors;
	level.scr_anim[ "lone_star" ][ "heli_crash_reaction" ]										= %berlin_littleb_intro_explosion_react;
	
	//Sandman: Granite team is hitting the target building - we drew overwatch! The president's daughter should still be inside the hotel!
	level.scr_face[ "lone_star" ][ "berlin_cby_graniteteam" ]		= %berlin_littleb_intro_behaviors_facial;
	level.scr_sound[ "lone_star" ][ "berlin_cby_graniteteam" ]		= "berlin_cby_graniteteam";
	
	
	//AA Building
	level.scr_anim[ "lone_star" ][ "berlin_throw_from_building" ]					= %berlin_throw_from_building_delta;
	
	
	//Ramp Uphill
	level.scr_anim[ "lone_star" ][ "combatcombat_run_fast_rampup_short" ] = %berlin_npc_ramp_up_qcb_walk;
	level.scr_anim[ "lone_star" ][ "combatcombat_run_fast_rampup_short_alt" ] = %berlin_npc_ramp_up_qcb_walk_alt;
	
	
	//Sniper
	level.scr_anim[ "lone_star" ][ "stand_2_crouch" ]											= %exposed_stand_2_crouch;
	level.scr_anim[ "lone_star" ][ "casual_crouch_idle_in" ]							= %casual_crouch_idle_in;
	level.scr_anim[ "lone_star" ][ "casual_crouch_idle_out" ]							= %casual_crouch_idle_out;
	level.scr_anim[ "lone_star" ][ "bog_b_spotter_spot_2_casual" ]				= %berlin_spotter_spot_2_casual;
	level.scr_anim[ "lone_star" ][ "bog_b_spotter_casual_2_spot" ]				= %berlin_spotter_casual_2_spot;
	level.scr_anim[ "lone_star" ][ "bog_b_spotter_spot_idle" ][0]					= %berlin_spotter_spot_idle;
	
	
	//RAPPEL
	level.scr_anim[ "lone_star" ][ "rappel_ai" ]						= %berlin_rappel_npc;
	
	
	//Traverse Building
	level.scr_anim[ "lone_star" ][ "cover_radio" ][ 0 ]  = %roadkill_cover_radio_soldier2;
	level.scr_anim[ "lone_star" ][ "roof_collapse" ]				= %berlin_building_collapse_react_delta; //gulag_end_dustcover_price; 
	
	level.scr_anim[ "lone_star" ][ "ventwalk" ] 		= %launchfacility_b_ventwalk_v1_cycle;
	level.scr_anim[ "lone_star" ][ "cqb_to_ventwalk" ] 		= %berlin_cqb_to_ventwalk;
	level.scr_anim[ "lone_star" ][ "slide" ] 		= %berlin_fallen_building_slide_npc;
	
	level.scr_anim[ "lone_star" ]["emerge_open_door"] = %berlin_delta_bust_door; //%hunted_open_barndoor_flathand;
	addNotetrack_customFunction( "lone_star", "door_open", ::emerge_door_open, "emerge_open_door" );
	
	level.scr_anim[ "lone_star" ][ "patrol_jog_360_once" ] 			= %berlin_patrol_jog_360;
	
	
	//Hotel
	level.scr_anim[ "lone_star" ][ "breach_kick" ]				= %breach_kick_stackL1_enter;
	level.scr_anim[ "lone_star" ]["doorkick_2_cqbrun"] = %doorkick_2_cqbrun;
	
	
	//Reverse Breach
	level.scr_anim[ "lone_star" ]["reverse_breach_guy_enter"] = %berlin_reverse_breach_guy_enter;
	level.scr_anim[ "lone_star" ]["reverse_breach_stand_idle"][0] = %berlin_reverse_breach_sandman_cover_idle;
	level.scr_anim[ "lone_star" ]["reverse_breach"] = %berlin_reverse_breach_guy;
	level.scr_anim[ "lone_star" ]["reverse_breach_idle"][0] = %berlin_reverse_breach_guy_idle;
	level.scr_anim[ "lone_star" ]["reverse_breach_getup"] = %berlin_reverse_breach_guy_getup;
	level.scr_anim[ "lone_star" ]["reverse_breach_end_1"] = %berlin_reverse_breach_sandman_end1;
	level.scr_anim[ "lone_star" ]["reverse_breach_end_2"] = %berlin_reverse_breach_sandman_end2;
	//facial
	//Sandman: We can't risk it!
	level.scr_sound[ "lone_star" ][ "berlin_cby_cantriskit" ]		= "berlin_cby_cantriskit";
	level.scr_face[ "lone_star" ][ "berlin_cby_cantriskit" ]		= %berlin_reverse_breach_sandman_end_face1;
	//Sandman: Overlord - negative precious cargo… We lost her.
	level.scr_sound[ "lone_star" ][ "berlin_cby_welosther" ]		= "berlin_cby_welosther";
	level.scr_face[ "lone_star" ][ "berlin_cby_welosther" ]		= %berlin_reverse_breach_sandman_end_face2;
	
  /*######################
	#########ESSEX ANIMS####
	######################*/
	
	//AA Building
	level.scr_anim[ "essex" ][ "berlin_throw_from_building" ]					= %berlin_throw_from_building_delta;
	level.scr_anim[ "defender" ][ "berlin_throw_from_building" ]			= %berlin_throw_from_building_russian;
	addNotetrack_customFunction( "defender", "fire", ::building_throw_break_glass, "berlin_throw_from_building" );
	addNotetrack_customFunction( "defender", "start_ragdoll", ::throw_victim_kill, "berlin_throw_from_building" );
	
	
	//Ramp Uphill
	level.scr_anim[ "essex" ][ "combatcombat_run_fast_rampup_short" ] = %berlin_npc_ramp_up_qcb_walk;	
	level.scr_anim[ "essex" ][ "combatcombat_run_fast_rampup_short_alt" ] = %berlin_npc_ramp_up_qcb_walk_alt;

	
	//NOT USED - level.scr_anim[ "essex" ][ "prone_aim_idle" ][0]									= %prone_aim_idle;
	
	
	//RAPPEL
	level.scr_anim[ "essex" ][ "rappel_ai" ]													= %berlin_rappel_npc;
	
	
	//Traverse Building
	level.scr_anim[ "essex" ][ "ventwalk" ] 		= %launchfacility_b_ventwalk_v1_cycle;
	level.scr_anim[ "essex" ][ "cqb_to_ventwalk" ] 		= %berlin_cqb_to_ventwalk;
	level.scr_anim[ "essex" ][ "slide" ] 		= %berlin_fallen_building_slide_npc;
	
	//Hotel
	level.scr_anim[ "essex" ][ "breach_kick" ] 													= %breach_kick_kickerR1_enter;
	
	//Reverse Breach
	level.scr_anim[ "essex" ][ "reverse_breach_getup" ]	 			= %berlin_reverse_breach_grinch_getup;
	level.scr_anim[ "essex" ][ "reverse_breach_end" ]	 			= %berlin_reverse_breach_grinch_end;


	/*######################
	#########TRUCK ANIMS####
	######################*/
	
	//AA Building
	level.scr_anim[ "truck" ][ "sniper_escape_spotter_idle" ][0]			= %berlin_crouch_2_spotting_idle;
	level.scr_anim[ "truck" ][ "berlin_crouch_2_spotting" ]						= %berlin_crouch_2_spotting;
	level.scr_model[ "binocs" ] 								 											= "weapon_binocular";
	
	
	//Ramp Uphill
	level.scr_anim[ "truck" ][ "combatcombat_run_fast_rampup_short" ] = %berlin_npc_ramp_up_qcb_walk;	
	level.scr_anim[ "truck" ][ "combatcombat_run_fast_rampup_short_alt" ] = %berlin_npc_ramp_up_qcb_walk_alt;
	
  //Rappel
	level.scr_anim[ "truck" ][ "rappel_ai" ]													= %berlin_rappel_npc;
	
	//Alley
	level.scr_anim[ "truck" ][ "hunted_woundedhostage_check" ]											= %hunted_woundedhostage_check_soldier;
	level.scr_anim[ "truck" ][ "hunted_woundedhostage_check_end" ]											= %hunted_woundedhostage_check_soldier_end;
	
	//Traverse Building
	level.scr_anim[ "truck" ][ "ventwalk" ] 		= %launchfacility_b_ventwalk_v1_cycle;
	level.scr_anim[ "truck" ][ "cqb_to_ventwalk" ] 		= %berlin_cqb_to_ventwalk;
	level.scr_anim[ "truck" ][ "slide" ] 		= %berlin_fallen_building_slide_npc;
	
		
	/*######################
	#########PLAYER BODY####
	######################*/
	
	//Reverse Breach
	level.scr_anim["reverse_breach_player_body"]["reverse_breach"] 		= %berlin_reverse_breach_playerbody;
	level.scr_anim["reverse_breach_player_body"]["reverse_breach_idle"][0] = %berlin_reverse_breach_playerbody_idle;
	level.scr_anim["reverse_breach_player_body"]["reverse_breach_getup"] = %berlin_reveres_breach_playerbody_getup;
	level.scr_model[ "reverse_breach_player_body" ]						 				= "body_delta_woodland_assault_aa_dusty";
	level.scr_animtree[ "reverse_breach_player_body" ]					 			= #animtree;
	
	
}

dshk_death_anim_callback()
{
	death_anim = %gaz_turret_death;
	if ( IsDefined( self.ridingvehicle ) )
	{
		if( self.ridingvehicle.classname == "script_vehicle_t90_tank_woodland_berlin" )
		{
			death_anim = %berlin_tank_gunner_death;		
		}
	}

	return death_anim;
}

#using_animtree( "vehicles" );
vehicles()
{
	//Building Collapse
	level.scr_anim[ "car" ][ "bahn_tower" ] = %berlin_sgt_down_bldg_collapse_SUBCOMPACT;
	addNotetrack_customFunction( "car", "vfx_firesmk_carfly", ::carfly_vfx_start, "bahn_tower" );
	addNotetrack_customFunction( "car", "vfx_firesmk_carfly_stop", ::carfly_vfx_stop, "bahn_tower" );
	level.scr_animtree[ "car" ]					 = #animtree;
	level.scr_model[ "car" ] 						 	= "vehicle_subcompact_blue_destroyed";
	
	
	//A10	
	level.scr_anim[ "a10" ][ "berlin_a10_strafe_run_01" ] = %berlin_a10_strafe_run_01;
	level.scr_anim[ "a10" ][ "berlin_a10_strafe_run_02" ] = %berlin_a10_strafe_run_02;
	level.scr_anim[ "a10" ][ "berlin_a10_strafe_run_03" ] = %berlin_a10_strafe_run_03;
	level.scr_model[ "a10" ] 						 	= "vehicle_a10_warthog";
	level.scr_animtree[ "a10" ]					 = #animtree;
	addNotetrack_customFunction( "a10", "a10_fire", maps\berlin_a10::airstrike_fire, "berlin_a10_strafe_run_01" );
	addNotetrack_customFunction( "a10", "a10_fire", maps\berlin_a10::airstrike_fire, "berlin_a10_strafe_run_02" );
	addNotetrack_customFunction( "a10", "a10_fire", maps\berlin_a10::airstrike_fire, "berlin_a10_strafe_run_03" );
	
	
	//Reverse Breach
	level.scr_anim[ "heli" ][ "reverse_breach_first_frame" ] = %berlin_reverse_breach_hind_idle;
	level.scr_anim[ "heli" ][ "reverse_breach_idle" ][0] = %berlin_reverse_breach_hind_idle;
	level.scr_anim[ "heli" ][ "reverse_breach_getup" ] = %berlin_reverse_breach_hind_getup;
	level.scr_animtree[ "heli" ]					 = #animtree;
	
}


/***************************
*****NOTETRACK FUNCTIONS****
***************************/

sniper_rope_vis( guy )
{
	guy notify( "spawn_rope" );
}

//vfx: fire and smoke trailing off flying blue subcompact car
carfly_vfx_start( guy ) 
{
    wait(0.5);
    PlayFXOnTag( getfx( "fire_smoke_trail_emitter" ), guy, "TAG_BODY" );
} 

carfly_vfx_stop( guy ) 
{
    StopFXOnTag( getfx( "fire_smoke_trail_emitter" ), guy, "TAG_BODY" );
}

throw_victim_kill(guy)
{
	if(isalive(guy))
		guy kill();
}

building_throw_break_glass(guy)
{
	level.building_throw_fire_counter++;
	if(	level.building_throw_fire_counter == 6)
	{
		glass_to_break = getglass("building_throw_break_glass");
		wait(.6);
		DestroyGlass(glass_to_break, (-1,0,0));
	}
}

aftermath_sandman_start(ent)
{
	flag_set( "sandman_start_aftermath" );
}

emerge_door_open(ent)
{
	flag_set( "emerge_door_begin_open" );
}

sniper_rooftop_attacker_fire_rocket(ent)
{
	flag_set( "sniper_rooftop_fire_rocket" );
}
