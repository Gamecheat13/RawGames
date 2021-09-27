#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

main()
{
	player_anims();
	body_anims();
	actor_anims();	
	prop_anims();
	ss_n_12_anims();
	blackshadow_anims();
	russian_sub_anims();
	ch46e_ny_harbor_anims();
	zodiac_anims();
	dvora_anims();
	script_model_anims();
	squad_vo();
	door();
	missile_key();
	maps\cinematic_setups\nyh_wetsub_exit::main();
	maps\cinematic_setups\nyh_delta_wetsub::main();
	building_destruction();
	
}

#using_animtree( "script_model" );
missile_key()
{
	level.scr_animtree[ "missile_key_player" ]								= #animtree;	
	level.scr_model[ "missile_key_player" ]									= "ny_harbor_missle_key";
	level.scr_anim[ "missile_key_player" ][ "sub_turn_key" ]				= %ny_harbor_missle_key_player_toss;

	level.scr_animtree[ "missile_key_sandman" ]								= #animtree;	
	level.scr_model[ "missile_key_sandman" ]								= "ny_harbor_missle_key";	
	level.scr_anim[ "missile_key_sandman" ][ "sub_turn_key" ]				= %ny_harbor_missle_key_sandman_key;
}

#using_animtree( "player" );
player_anims()
{
	//the animtree to use with the invisible model with animname "player_rig"
	level.scr_animtree[ "player_sdv_rig" ]						= #animtree;
	level.scr_animtree[ "player_sdv_legs" ]						= #animtree;
	level.scr_model[ "player_sdv_legs" ]						= "viewlegs_generic";
	//the invisible model with the animname "player_rig" that the anims will be played on
	level.scr_model[ "player_sdv_rig" ]							= "viewhands_player_udt";
	
	level.scr_anim[ "player_sdv_rig" ][ "sdv_idle" ][ 0 ]		= %harbor_player_sdv_idle;
	level.scr_anim[ "player_sdv_rig" ][ "sdv" ][ "idle" ]		= %harbor_player_sdv_idle;
	level.scr_anim[ "player_sdv_rig" ][ "sdv" ][ "turn_down" ]	= %harbor_player_sdv_turn_down;
	level.scr_anim[ "player_sdv_rig" ][ "sdv" ][ "turn_up" ]	= %harbor_player_sdv_turn_up;
	level.scr_anim[ "player_sdv_rig" ][ "sdv" ][ "turn_right" ]	= %harbor_player_sdv_turn_right;
	level.scr_anim[ "player_sdv_rig" ][ "sdv" ][ "turn_left" ]	= %harbor_player_sdv_turn_left;

	level.scr_anim[ "player_sdv_rig" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_player;
	addNotetrack_customFunction( "player_sdv_rig", "rumble_medium", ::anim_rumble_medium, "tunnel_intro" );
	addNotetrack_customFunction( "player_sdv_rig", "rumble_large", ::anim_rumble_large, "tunnel_intro" );
	level.scr_anim[ "player_sdv_rig" ][ "tunnel_spline" ] = %ny_harbor_underwater_cutting_player_pt2;
	level.scr_anim[ "player_sdv_rig" ][ "mine_plant" ]			= %ny_harbor_wetsub_plantmine_player;
	level.scr_anim[ "player_sdv_rig" ][ "ny_harbor_door_breach" ]	= %ny_harbor_door_breach_player;
	addNotetrack_customFunction( "player_sdv_rig", "Start_slowdown", maps\ny_harbor_code_sub::breach_slow_down, "ny_harbor_door_breach" );
	addNotetrack_customFunction( "player_sdv_rig", "Blow_charge", maps\ny_harbor_code_sub::blow_door, "ny_harbor_door_breach" );
	addNotetrack_customFunction( "player_sdv_rig", "rumble_large", ::anim_rumble_large, "ny_harbor_door_breach" );
	
	level.scr_anim[ "player_sdv_rig" ][ "sub_turn_key" ]	= %ny_harbor_missle_key_player_turnkey;
	//addNotetrack_customFunction( "player_sdv_rig", "ladder_climb", maps\ny_harbor_code_sub::sub_exit_ladder_climb, "sub_turn_key" );
	//addNotetrack_customFunction( "player_sdv_rig", "ladder_complete", maps\ny_harbor_code_sub::sub_exit_ladder_climb_complete, "sub_turn_key" );
	
	level.scr_anim[ "player_sdv_rig" ][ "player_ladder_slide" ]	= %ny_harbor_ladder_slide_player ;
	addNotetrack_customFunction( "player_sdv_rig", "rumble_small", ::anim_rumble_small, "player_ladder_slide" );
	addNotetrack_customFunction( "player_sdv_rig", "rumble_meduim", ::anim_rumble_medium, "player_ladder_slide" );
	addNotetrack_customFunction( "player_sdv_rig", "rumble_large", ::anim_rumble_large, "player_ladder_slide" );
	
	// sub surfacing
	level.scr_anim[ "player_sdv_rig" ][ "surfacing" ]	 = 			%ny_harbor_sub_surface_player ;
	level.scr_anim[ "player_sdv_rig" ][ "boarding" ]	 = 			%ny_harbor_sub_surface_player_pt2 ;

	level.scr_anim[ "player_sdv_rig" ][ "exit_to_zodiac" ]	 = 		%ny_harbor_sub_exit_player ;
	level.scr_anim[ "player_sdv_legs" ][ "exit_to_zodiac" ]	 = 		%ny_harbor_sub_exit_legs ;
	
	level.scr_anim[ "player_sdv_rig" ][ "finale_escape" ] = %ny_harbor_finale_airlift_player_end;
	level.scr_anim[ "player_sdv_rig" ][ "carrier_start" ] = %ny_harbor_finale_bump_player_start;
	level.scr_anim[ "player_sdv_rig" ][ "carrier_end" ] = %ny_harbor_finale_bump_player_end;
}

#using_animtree( "generic_human" );
body_anims()
{
	level.scr_animtree["floating_body"] = #animtree;
	level.scr_anim[ "generic" ][ "harbor_drowning_01" ]						 = %harbor_drowning_01;
	level.scr_anim[ "generic" ][ "harbor_drowning_01_idle" ][0]				 = %harbor_drowning_01_idle;
	level.scr_anim[ "generic" ][ "harbor_drowning_02" ]						 = %harbor_drowning_02;
	level.scr_anim[ "generic" ][ "harbor_drowning_02_idle" ][0]				 = %harbor_drowning_02_idle;
	level.scr_anim[ "generic" ][ "harbor_drowning_03" ]						 = %harbor_drowning_03;
	level.scr_anim[ "generic" ][ "harbor_drowning_03_idle" ][0]				 = %harbor_drowning_03_idle;

	level.scr_anim[ "generic" ][ "harbor_floating_idle_01" ][0]				 = %harbor_floating_idle_01;
	level.scr_anim[ "generic" ][ "harbor_floating_idle_02" ][0]				 = %harbor_floating_idle_02;
	level.scr_anim[ "generic" ][ "harbor_floating_idle_03" ][0]				 = %harbor_floating_idle_03;
	level.scr_anim[ "generic" ][ "harbor_floating_idle_04" ][0]				 = %harbor_floating_idle_04;

	level.scr_anim[ "generic" ][ "harbor_floating_struggle_01" ][0]			 = %harbor_floating_struggle_01;
	level.scr_anim[ "generic" ][ "harbor_floating_struggle_02" ][0]			 = %harbor_floating_struggle_02;

	level.scr_anim[ "generic" ][ "zodiac_driver_idle" ][0]			 		 = %prague_zodiac_driver_idle;

	// hanging anims
	/*
	level.scr_anim[ "generic" ][ "hang_fall_1" ] =			 			%ny_harbor_hang_fall_1 ;	
	level.scr_anim[ "generic" ][ "hang_fall_2" ] =			 			%ny_harbor_hang_fall_2 ;	
	level.scr_anim[ "generic" ][ "hang_idle_1" ] =			 			%ny_harbor_hang_idle_1 ;	
	level.scr_anim[ "generic" ][ "hang_idle_2" ] =			 			%ny_harbor_hang_idle_2 ;
	*/	
}

actor_anims()
{
	Sandman = "lonestar";
	
	// in sdv
	level.scr_anim[ "generic" ][ "wetsub_idle" ]			= %ny_harbor_wetsub_npc_idle;
	level.scr_anim[ "generic" ][ "wetsub_idle_alt01" ]		= %ny_harbor_wetsub_npc_idle_alt01;
	level.scr_anim[ "generic" ][ "wetsub_idle_alt02" ]		= %ny_harbor_wetsub_npc_idle_alt02;
	level.scr_anim[ "generic" ][ "wetsub_acknowledge" ]		= %ny_harbor_wetsub_npc_acknowledge;
	level.scr_anim[ "generic" ][ "wetsub_fwd" ]				= %ny_harbor_wetsub_npc_swim_fwd;
	level.scr_anim[ "generic" ][ "wetsub_rt" ]				= %ny_harbor_wetsub_npc_swim_rt;
	level.scr_anim[ "generic" ][ "wetsub_lt" ]				= %ny_harbor_wetsub_npc_swim_lt;
	level.scr_anim[ "generic" ][ "wetsub_up" ]				= %ny_harbor_wetsub_npc_swim_up;
	level.scr_anim[ "generic" ][ "wetsub_dn" ]				= %ny_harbor_wetsub_npc_swim_dwn;
	level.scr_anim[ "generic" ][ "wetsub_fwd_alt" ]			= %ny_harbor_wetsub_npc_swim_fwd_alt;
	level.scr_anim[ "generic" ][ "wetsub_rt_alt" ]			= %ny_harbor_wetsub_npc_swim_rt_alt;
	level.scr_anim[ "generic" ][ "wetsub_lt_alt" ]			= %ny_harbor_wetsub_npc_swim_lt_alt;
	
	//casual anims for first setup
	level.scr_anim[ "generic" ][ "balcony_fallloop_onback" ]	[0] 		= 			%balcony_fallloop_onback ;	
	level.scr_anim[ "generic" ][ "balcony_fallloop_tumbleforwards" ]	[0] = 			%balcony_fallloop_tumbleforwards ;	
	
	level.scr_anim[ "generic" ][ "ny_harbor_slams_bulkhead_door_shut" ] 	= 			%ny_harbor_slams_bulkhead_door_shut;	
	
	level.scr_anim[ "generic" ][ "ny_harbor_door_open" ] 					= 			%ny_harbor_door_open;	

	level.scr_anim[ "generic" ][ "ny_harbor_ssbn_coughing_recovery_guy1" ] 			= 			%ny_harbor_ssbn_coughing_recovery_guy1;
	addNotetrack_customFunction( "generic", "KILL ME", maps\ny_harbor_code_sub::sandman_kill, "ny_harbor_ssbn_coughing_recovery_guy1" );
	level.scr_anim[ "generic" ][ "ny_harbor_ssbn_coughing_recovery_guy2" ] 			= 			%ny_harbor_ssbn_coughing_recovery_guy2;
	
	level.scr_anim[ "generic" ][ "ny_harbor_door_breach" ] 							= 			%ny_harbor_door_breach_guy1;
	


	level.scr_anim[ "generic" ][ "ny_harbor_affected_russian_guy1" ] = 			%ny_harbor_affected_russian_guy1;
	//level.scr_anim[ "generic" ][ "ny_harbor_fire_extinguisher_npc_loop" ] [0]= 			%ny_harbor_fire_extinguisher_npc_loop;

///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////START HERE///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////          ///////////////////////////////////////////////////////////////////////////
	
	//sandman anims
	
	//////NEEDS AUDIT/////

	level.scr_anim[ "generic" ][ "npc_plant_side" ]										= %ny_harbor_wetsub_npc_plant_mine_side;
	level.scr_anim[ "generic" ][ "npc_plant_up" ]										= %ny_harbor_wetsub_npc_plant_mine_up;

	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_sandman_start" ]			= %ny_harbor_paried_takedown_sandman_start;
	level.scr_anim[ "lonestar" ][ "ny_harbor_captain_search_flip_over" ]				= %ny_harbor_paried_takedown_sandman_flip_over;
	level.scr_anim[ "lonestar" ][ "ny_harbor_captain_search_flip_over_b" ]				= %ny_harbor_paried_takedown_sandman_flip_over_b;
	level.scr_anim[ "lonestar" ][ "ny_harbor_captain_search_flip_over_c" ]				= %ny_harbor_paried_takedown_sandman_flip_over_c;
	addNotetrack_customFunction( "lonestar", "gotkey_dialog", maps\ny_harbor_code_vo::vo_sub_sandman_got_key, "ny_harbor_captain_search_flip_over" );
	addNotetrack_customFunction( "lonestar", "sandman_dialog", maps\ny_harbor_code_vo::vo_sub_sandman_captain_flip, "ny_harbor_captain_search_flip_over_b" );
	level.scr_anim[ "generic" ][ "ny_harbor_delta_bulkhead_open_guy1_v2" ]				= %ny_harbor_delta_bulkhead_open_guy1_v2;

	level.scr_anim[ Sandman ][ "ny_harbor_ladder_slide_sandman" ]						= %ny_harbor_ladder_slide_sandman ;
	
	//////AUDITed/////
	level.scr_anim[ Sandman ][ "ny_harbor_sandman_drops_frag_inhatch" ]					= %ny_harbor_sandman_drops_frag_inhatch ;
	level.scr_anim[ Sandman ][ "open_with_wheel" ] 										= %ny_harbor_delta_bulkhead_open_guy1_v2 ;	
	level.scr_anim[ Sandman ][ "open_with_wheel_approach" ] 							= %corner_standL_trans_CQB_IN_8;
	
	
	
	
	//barracks guy shuting door
	level.scr_anim[ "barracks_2" ][ "slam_door" ] 											= %ny_harbor_slams_bulkhead_door_shut;
	//barracks waver
	level.scr_anim[ "generic" ][ "launchfacility_b_blast_door_seq_waveidle" ]			= %launchfacility_b_blast_door_seq_waveidle;
	
	//barracks sandman exit
	level.scr_anim[ Sandman ][ "barracks_sandman_exit" ] 								= %ny_harbor_door_open;
	level.scr_anim[ Sandman ][ "barracks_sandman_exit_idle" ][0]						= %ny_harbor_door_idle;
	
	//Reactor room sandman paired kill
	level.scr_anim[ "generic" ][ "ny_harbor_doorway_headsmash" ] 						= %ny_harbor_doorway_headsmash_enemy;
	level.scr_anim[ "generic" ][ "ny_harbor_doorway_headsmash_enemy_deadpose" ]			= %ny_harbor_doorway_headsmash_enemy_deadpose;
	level.scr_anim[ Sandman ][ "ny_harbor_doorway_headsmash" ] 							= %ny_harbor_doorway_headsmash_sandman;
	level.scr_anim[ Sandman ][ "ny_harbor_doorway_headsmash_no_gun_flip" ] 				= %ny_harbor_doorway_headsmash_sandman_no_gun_flip;
	
	level.scr_anim[ "guy" ][ "extinguisher_loop" ][0] = %ny_harbor_fire_extinguisher_npc_loop;
	
	//dead anims
	level.scr_anim[ "generic" ][ "blow_back_dead" ]										= %blow_back_dead;
	level.scr_anim[ "generic" ][ "hunted_dying_deadguy" ] 								= %hunted_dying_deadguy;
	level.scr_anim[ "generic" ][ "death_sitting_pose_v1" ][ 0 ]							= %death_sitting_pose_v1;	
	level.scr_anim[ "generic" ][ "death_sitting_pose_v1_nl" ]							= %death_sitting_pose_v1;	
	level.scr_anim[ "generic" ][ "death_sitting_pose_v2" ]	 							= %death_sitting_pose_v2;		
	
	//breach anims
	level.scr_anim[ Sandman ][ "ny_harbor_door_breach_idle" ][ 0 ] 						= %ny_harbor_door_breach_sandman_idle;
	level.scr_face[ Sandman ][ "nyharbor_lns_kickercharge" ] = %ny_harbor_door_breach_sandman_face;
	level.scr_anim[ Sandman ][ "ny_harbor_door_breach_idle_trans" ]						= %ny_harbor_door_breach_sandman_idle_trans;
	level.scr_anim[ Sandman ][ "ny_harbor_door_breach" ] 								= %ny_harbor_door_breach_sandman;
	addNotetrack_customFunction( "lonestar", "Show_Charge_1", maps\ny_harbor_code_sub::show_charge_1, "ny_harbor_door_breach" );
	addNotetrack_customFunction( "lonestar", "Detach_Charge_1", maps\ny_harbor_code_sub::detach_charge_1, "ny_harbor_door_breach" );
	addNotetrack_customFunction( "lonestar", "Show_Charge_2", maps\ny_harbor_code_sub::show_charge_2, "ny_harbor_door_breach" );
	addNotetrack_customFunction( "lonestar", "Detach_Charge_2", maps\ny_harbor_code_sub::detach_charge_2, "ny_harbor_door_breach" );
	
	//Breach: guy reacts to breach
	level.scr_anim[ "generic" ][ "breach_enemy_1" ]			 							= %patrol_bored_react_walkstop;
	//Breach: guy throws gun
	level.scr_anim[ "breacher1" ][ "breach_enemy_2" ]			 						= %breach_react_push_guy1;
	level.scr_anim[ "breacher2" ][ "breach_enemy_2" ]			 						= %breach_react_push_guy2;
	
	
	//Breach: enemy charges at door with a knife
	level.scr_anim[ "knife_guy" ][ "breach_react_knife_idle" ]			 				= %breach_react_knife_idle;
	level.scr_anim[ "knife_guy" ][ "breach_react_knife_charge" ]							= %breach_react_knife_charge;
	level.scr_anim[ "knife_guy" ][ "breach_react_knife_charge_death" ]			 		= %death_shotgun_back_v1;

	//knife props for executions, etc
	addNotetrack_attach( "generic", "attach knife right", "weapon_parabolic_knife", "TAG_INHAND" );
	addNotetrack_detach( "generic", "detach knife right", "weapon_parabolic_knife", "TAG_INHAND", "breach_react_knife_charge" );

	//control room control panel
	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_start" ] 		= 			%ny_harbor_paried_takedown_captain_start;
	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_dead_1"  ] 		= 			%Ny_Harbor_Paried_Takedown_Captain_Dead_1;
	level.scr_anim[ "generic" ][ "ny_harbor_paried_takedown_captain_die"  ]		 	= 			%ny_harbor_paried_takedown_captain_die;
	level.scr_anim[ "generic" ][ "ny_harbor_captain_search_flip_over" ] 			= 			%ny_harbor_paried_takedown_captain_flip_over;
	
	
	level.scr_anim[ "lonestar" ][ "sub_turn_key" ] 									= 			%ny_harbor_missle_key_sandman_turnkey;
	level.scr_anim[ "lonestar" ][ "sub_turn_key2" ]									= 			%ny_harbor_missle_key_sandman_turnkey2;
	level.scr_anim[ "generic" ][ "sub_turn_key_idle" ][0] 							=			%ny_harbor_missle_key_sandman_idle;
//	addNotetrack_customFunction( "lonestar", "countdown_dialog", maps\ny_harbor_code_vo::vo_sandman_count_down, "sub_turn_key" );
	addNotetrack_customFunction( "lonestar", "green_light_on", maps\ny_harbor_fx::greenlighton_vfx, "sub_turn_key" );
	addNotetrack_customFunction( "lonestar", "red_light_off", maps\ny_harbor_fx::redlightoff_vfx, "sub_turn_key2" );



	//Sub sandman exit jump
	level.scr_anim[ Sandman ][ "sub_exit_jump" ] 										= %ny_harbor_sub_exit_sandman_jump;
	
	//dvora guys death anims
	level.scr_anim[ "generic" ][ "ny_harbor_davora_front_turret_death" ]										= %ny_harbor_davora_front_turret_death;
	level.scr_anim[ "generic" ][ "ny_harbor_davora_side_fall_death" ]										= %ny_harbor_davora_side_fall_death;
	level.scr_anim[ "generic" ][ "stand_death_shoulderback" ]										= %stand_death_shoulderback;
	level.scr_anim[ "generic" ][ "ny_harbor_stand_death_shoulderback_pose" ] [ 0 ]					= %ny_harbor_stand_death_shoulderback_pose;
	
	

	

	// sub surfacing
	level.scr_anim[ "lonestar" ][ "surfacing" ]	 = 			%ny_harbor_sub_surface_npc ;
	level.scr_anim[ "lonestar" ][ "boarding" ]	 = 			%ny_harbor_sub_surface_npc_pt2 ;
	// intro
	level.scr_anim[ "lonestar" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_sandman;
	addNotetrack_customFunction( "lonestar", "vo_grate", maps\ny_harbor_code_vo::vo_sandman_grate, "tunnel_intro" );
	
	level.scr_anim[ "lonestar" ][ "exit_to_zodiac" ] = %ny_harbor_sub_exit_sandman_trans;
	level.scr_anim[ "lonestar" ][ "wave_from_zodiac" ] = %ny_harbor_sub_exit_sandman_wave;
	level.scr_anim[ "lonestar" ][ "launch_react" ] = %ny_harbor_sandman_launch_react;
	

	
	//finale_escape
	level.scr_anim[ "lonestar" ][ "finale_escape" ] = %ny_harbor_finale_airlift_sandman;
	
	level.scr_animtree["ch_guy1"] = #animtree;
	level.scr_anim[ "ch_guy1" ][ "finale_escape" ] = %ny_harbor_finale_airlift_guy1;
	level.scr_anim[ "ch_guy1" ][ "chinook_idle" ] [0] = %ny_harbor_finale_airlift_guy1_idle;
	
	level.scr_animtree["ch_guy2"] = #animtree;
	level.scr_anim[ "ch_guy2" ][ "finale_escape" ] = %ny_harbor_finale_airlift_guy2;
	level.scr_anim[ "ch_guy2" ][ "chinook_idle" ] [0] = %ny_harbor_finale_airlift_guy2_idle;

	level.scr_anim[ "generic" ][ "exposed_crouch_death_fetal" ]				= %exposed_crouch_death_fetal;
	level.scr_anim[ "generic" ][ "exposed_crouch_death_twist" ] 			= %exposed_crouch_death_twist;
}


#using_animtree( "vehicles" );
ss_n_12_anims()
{
	level.scr_animtree["ss_n_12_missile"] = #animtree;
	level.scr_anim[ "ss_n_12_missile" ][ "open" ]		 = %ss_n_12_missile_open;
	level.scr_anim[ "ss_n_12_missile" ][ "open_idle" ]	 = %ss_n_12_missile_open_idle;
	level.scr_anim[ "ss_n_12_missile" ][ "close_idle" ] = %ss_n_12_missile_close_idle;
}

blackshadow_anims()
{
	level.scr_animtree["blackshadow"] = #animtree;
	// in sdv
	level.scr_anim[ "blackshadow" ][ "npc_plant_side" ]			= %ny_harbor_wetsub_vehicle_plant_mine_side;
	level.scr_anim[ "blackshadow" ][ "npc_plant_up" ]			= %ny_harbor_wetsub_vehicle_plant_mine_up;
	level.scr_anim[ "blackshadow" ][ "mine_plant" ]			= %ny_harbor_wetsub_plantmine_vehicle;

	level.scr_anim[ "blackshadow" ][ "surfacing" ]	 = 			%ny_harbor_sub_surface_vehicle ;
	level.scr_anim[ "blackshadow" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_SDV2;
	level.scr_anim[ "player_sdv" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_SDV1;
	level.scr_anim[ "player_sdv" ][ "tunnel_spline" ] = %ny_harbor_underwater_cutting_SDV1_pt2;
}

ch46e_ny_harbor_anims()
{
	level.scr_animtree[ "ch46e" ] = #animtree;
	level.scr_anim[ "ch46e" ][ "open_rear" ]					= %ch46e_ny_harbor_open_rear;
	level.scr_anim[ "ch46e" ][ "open_rear_loop" ][0]			= %ch46e_ny_harbor_open_rear_loop;
	level.scr_anim[ "ch46e" ][ "wide_open_rear_loop" ]	[0]		= %ch46e_ny_harbor_wide_open_rear_loop;
	level.scr_anim[ "ch46e" ][ "chinook_landing" ] 				= %ny_harbor_finale_airlift_ch46_start;
	level.scr_anim[ "ch46e" ][ "chinook_pre_idle" ] 				= %ny_harbor_finale_airlift_ch46_idle;
	level.scr_anim[ "ch46e" ][ "chinook_idle" ][0] 				= %ny_harbor_finale_airlift_ch46_idle;
	level.scr_anim[ "ch46e" ][ "finale_escape" ] 				= %ny_harbor_finale_airlift_ch46_end;
	level.scr_anim[ "ch46e" ][ "rotors" ]						= %sniper_escape_ch46_rotors;
	
	level.scr_animtree[ "ch46e2" ] = #animtree;
	level.scr_anim[ "ch46e2" ][ "chinook_landing" ] 				= %ny_harbor_finale_airlift_ch46_2_start;
	level.scr_anim[ "ch46e2" ][ "chinook_idle" ] [0]			= %ny_harbor_finale_airlift_ch46_2_idle;
	level.scr_anim[ "ch46e2" ][ "rotors" ]						= %sniper_escape_ch46_rotors;
}

russian_sub_anims()
{
	level.scr_animtree["russian_sub"] = #animtree;
	level.scr_anim[ "russian_sub" ][ "surfacing" ]			= %ny_harbor_sub_surface;
	level.scr_anim[ "russian_sub" ][ "propellers" ][0]		= %russian_oscar2_propellers;
}

zodiac_anims()
{
	level.scr_animtree["zodiac"] = #animtree;
	level.scr_anim[ "zodiac" ][ "exit_to_zodiac" ]	 = 		%ny_harbor_sub_exit_zodiac ;
	level.scr_anim[ "zodiac" ][ "carrier_start" ] = %ny_harbor_finale_bump_zodiac_start;
	level.scr_anim[ "zodiac" ][ "carrier_breach" ] = %ny_harbor_finale_bump_zodiac_breach;
	level.scr_anim[ "zodiac" ][ "carrier_end" ] = %ny_harbor_finale_bump_zodiac_end;
	level.scr_anim[ "zodiac_player" ][ "finale_escape" ] = %ny_harbor_finale_airlift_zodiac_end;
}

dvora_anims()
{
	level.scr_animtree[ "dvora" ] = #animtree;
	level.scr_anim[ "dvora" ][ "carrier_start" ] = %ny_harbor_finale_bump_dvora_start;
	level.scr_anim[ "dvora" ][ "carrier_breach" ] = %ny_harbor_finale_bump_dvora_breach;
	level.scr_anim[ "dvora" ][ "carrier_end" ] = %ny_harbor_finale_bump_dvora_end;
	level.scr_anim[ "dvora" ][ "destory" ] = %ny_harbor_finale_bump_dvora_destroy;
	level.scr_anim[ "dvora" ][ "destorychunk" ] = %ny_harbor_finale_bump_dvora_destroychunk;
	
}

#using_animtree( "animated_props" );
prop_anims()
{
}


#using_animtree( "script_model" );
script_model_anims()
{
	//breach actors and props
	level.scr_animtree[ "door_charge" ] = #animtree;
	level.scr_model[ "door_charge" ] = "weapon_frame_charge_iw5";
	level.scr_anim[ "door_charge" ][ "ny_harbor_door_breach" ]							= %ny_harbor_door_breach_player_charge2;
	
	level.scr_animtree[ "breach_door" ] = #animtree;
	level.scr_model[ "breach_door" ] = "ny_harbor_sub_pressuredoor_bridge";
	level.scr_anim[ "breach_door" ][ "ny_harbor_door_breach" ]							= %ny_harbor_door_breach_pressure_door;
	
	level.scr_animtree[ "breach_detonator1" ] = #animtree;
	level.scr_model[ "breach_detonator1" ] = "weapon_c4_detonator_iw5";
	level.scr_anim[ "breach_detonator1" ][ "ny_harbor_door_breach" ]					= %ny_harbor_door_breach_detonator_1;
	
	level.scr_animtree[ "breach_detonator2" ] = #animtree;
	level.scr_model[ "breach_detonator2" ] = "weapon_c4_detonator_iw5";
	level.scr_anim[ "breach_detonator2" ][ "ny_harbor_door_breach" ]					= %ny_harbor_door_breach_detonator_2;
	
	level.scr_animtree[ "breach_charge1" ] = #animtree;
	level.scr_model[ "breach_charge1" ] = "weapon_frame_charge_iw5_c4";
	level.scr_anim[ "breach_charge1" ][ "ny_harbor_door_breach" ]						= %ny_harbor_door_breach_sandman_charge1;
	
	level.scr_animtree[ "breach_charge2" ] = #animtree;
	level.scr_model[ "breach_charge2" ] = "weapon_frame_charge_iw5_c4";
	level.scr_anim[ "breach_charge2" ][ "ny_harbor_door_breach" ]						= %ny_harbor_door_breach_sandman_charge2;
	
	level.scr_animtree[ "missile_key_panel_box" ] = #animtree;
	level.scr_model[ "missile_key_panel_box" ] = "ny_harbor_missle_key_panel";
	level.scr_anim[ "missile_key_panel_box" ][ "sub_turn_key" ]				= %ny_harbor_missle_key_panel;
	
	level.scr_animtree[ "missile_key_panel" ] = #animtree;
	level.scr_model[ "missile_key_panel" ] = "ny_harbor_missle_key_box";
	level.scr_anim[ "missile_key_panel" ][ "sub_turn_key" ]					= %ny_harbor_missle_key_panel_launch_box;
	
		
	level.scr_animtree[ "tunnel_grate" ] = #animtree;
	level.scr_model[ "tunnel_grate" ] = "ny_harbor_tunnel_grate";
	level.scr_anim[ "tunnel_grate" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_grate;
	
	level.scr_animtree[ "torch" ] = #animtree;
	level.scr_model[ "torch" ] = "weapon_underwater_torch";
	level.scr_anim[ "torch" ][ "tunnel_intro" ] = %ny_harbor_underwater_cutting_torch;
	
	level.scr_anim[ "mine" ][ "npc_plant_side" ]			= %ny_harbor_wetsub_mine_plant_mine_side;
	level.scr_anim[ "mine" ][ "npc_plant_up" ]				= %ny_harbor_wetsub_mine_plant_mine_up;
	level.scr_anim[ "mine" ][ "mine_plant" ]				= %ny_harbor_wetsub_plantmine_mine;
	level.scr_anim[ "mine" ][ "mine_ref" ]					= %ny_harbor_wetsub_plantmine_mine_ref;
	level.scr_animtree[ "mine" ] = #animtree;
	
	level.scr_animtree["wave_front"] = #animtree;
	level.scr_anim[ "wave_front" ][ "wave" ]				= %fx_nyharbor_wave_front_anim;

	level.scr_animtree["wave_crashing"] = #animtree;
	level.scr_anim[ "wave_crashing" ][ "wave" ]				= %fx_nyharbor_wave_crashing_anim;


	level.scr_animtree["wave_side"] = #animtree;
	level.scr_anim[ "wave_side" ][ "wave" ]				= %fx_nyharbor_wave_side_anim;
	level.scr_animtree["explosion_wave"] = #animtree;
	level.scr_anim[ "explosion_wave" ][ "wave" ]				= %fx_nyharbor_explosion_wave_anim;
	level.scr_animtree["wave_displace"] = #animtree;
	level.scr_anim[ "wave_displace" ][ "wave" ]				= %fx_nyharbor_wave_displace_anim;

	level.scr_animtree["smoke_column"] = #animtree;
	level.scr_anim[ "smoke_column" ][ "fire" ]				= %fx_ny_smoke_column_anim;
	level.scr_anim[ "smoke_column" ][ "rot" ]				= %fx_ny_smoke_column_rot_anim;
	
	level.scr_animtree["missile_door"] = #animtree;
	level.scr_anim[ "missile_door" ][ "open" ]				= %ny_harbor_sub_missile_door_open;

	level.scr_animtree["missile_hatch"] = #animtree;
	level.scr_anim[ "missile_hatch" ][ "open" ]				= %ny_harbor_sub_missile_hatch_open;
	
	level.scr_animtree["burya"] = #animtree;
	level.scr_anim[ "burya" ][ "destruct_front" ]				= %ny_harbor_burya_corvette_front_blow;
	level.scr_anim[ "burya" ][ "destruct_mid" ]				= %ny_harbor_burya_corvette_mid_blow;
	level.scr_anim[ "burya" ][ "destruct_rear" ]				= %ny_harbor_burya_corvette_rear_blow;
	
	level.scr_animtree[ "mask" ] = #animtree;
	level.scr_model[ "mask" ] = "ny_harbor_dive_gear_mask";
	level.scr_anim[ "mask" ][ "boarding" ] = %ny_harbor_sub_surface_mask;
	
	level.scr_animtree[ "extinguisher" ] = #animtree;
	level.scr_model[ "extinguisher" ] = "com_fire_extinguisher_anim";
	level.scr_anim[ "extinguisher" ][ "extinguisher_loop" ][0] = %ny_harbor_fire_extinguisher_prop_loop;
}

door()
{
	level.scr_animtree["door"] = #animtree;
	level.scr_model[ "door" ] = "ny_harbor_sub_pressuredoor_rigged";
	level.scr_anim[ "door" ][ "open_with_wheel" ]						= %ny_harbor_delta_bulkhead_open_door_v2;
	level.scr_anim[ "door" ][ "slam_door" ]		 						= %ny_harbor_slams_bulkhead_door_shut_door;
	level.scr_anim[ "door" ][ "barracks_sandman_exit" ]		 			= %ny_harbor_door_open_door;

}

/*delete_tunnel_torch( ent )
{
	level.torch delete();
}*/

#using_animtree( "generic_human" );

squad_vo()
{
	Sandman = "lonestar";
	
	////////////////
	// Katz: Most of these look like old lines, but I don't want to delete them. I'm adding new lines under in
	// chronological order, rather than organized by squad member
	////////////////
	//////////////////
	// NEW LINES BEGIN
	//////////////////
	
	//Grinch: In position.
	level.scr_radio[ "nyharbor_rno_inposition" ]		= "nyharbor_rno_inposition";
	//Sandman: SDV Team Four, this is Metal 0-1. Radio check in the blind, over.
	level.scr_radio[ "nyharbor_lns_radiocheck" ]		= "nyharbor_lns_radiocheck";
	//We gotcha, Zero-One.  What's the ETA?
	level.scr_radio[ "nyharbor_sel_fivebyfive" ]		= "nyharbor_sel_fivebyfive";
	//Sandman: We're one minute out.
	level.scr_radio[ "nyharbor_lns_starttheparty" ]		= "nyharbor_lns_starttheparty";
	//SEAL Leader: Don't take too long.  We don't want to be out here all day..
	level.scr_radio[ "nyharbor_sel_copythat" ]		= "nyharbor_sel_copythat";
	//Grinch: Just don't start the party without us.
	level.scr_radio[ "nyharbor_rno_dontstart" ]			= "nyharbor_rno_dontstart";
	//Sandman: Almost through.
	level.scr_radio[ "nyharbor_lns_almostthrough" ]		= "nyharbor_lns_almostthrough";
	//Sandman: Primary entry point is open, stay tight, easy to get separated down here.
	level.scr_radio[ "nyharbor_lns_entrypoint" ]		= "nyharbor_lns_entrypoint";
	//Sandman: Maintain 2,9,5 degrees. 300 meters to link up.
	level.scr_radio[ "nyharbor_lns_linkup" ]		= "nyharbor_lns_linkup";
	//Grinch: Think anyone got out?
	level.scr_radio[ "nyharbor_rno_gotout" ] 		= "nyharbor_rno_gotout";
	//Sandman: Nothing we can do for them now.
	level.scr_radio[ "nyharbor_lns_forthem" ]		= "nyharbor_lns_forthem";

	//SEAL Leader: Metal 0-1, got you on the tracker.
	level.scr_radio[ "nyharbor_sel_ontracker" ]		= "nyharbor_sel_ontracker";
	//Sandman: Roger, approaching RV.
	level.scr_radio[ "nyharbor_lns_approachingrv" ]		= "nyharbor_lns_approachingrv";
	//Sandman: Eyes open, SEAL team should be up ahead.
	level.scr_radio[ "nyharbor_lns_upahead" ]		= "nyharbor_lns_upahead";
	//Grinch: I see them.
	level.scr_radio[ "nyharbor_rno_iseethem" ]		= "nyharbor_rno_iseethem";
	//SEAL leader: The sub's on the move. Intercept window is closing fast
	level.scr_radio[ "nyharbor_sel_intercept" ]		= "nyharbor_sel_intercept";
	//Sandman: Roger that, lead the way.
	level.scr_radio[ "nyharbor_lns_leadtheway" ]		= "nyharbor_lns_leadtheway";
	//SEAL leader: Watch your sonar. Russians are laying mines.
	level.scr_radio[ "nyharbor_sel_watchsonar" ]		= "nyharbor_sel_watchsonar";
	//Sandman: Frost, eyes on your sonar.
	level.scr_radio[ "nyharbor_lns_eyesonsonar" ]		= "nyharbor_lns_eyesonsonar";
	//Grinch: Mine! Left, left!
	level.scr_radio[ "nyharbor_rno_mineleft" ]		= "nyharbor_rno_mineleft";
	//Sandman: Right, right!
	level.scr_radio[ "nyharbor_lns_right" ]		= "nyharbor_lns_right";
	//Sandman: Keep it steady
	level.scr_radio[ "nyharbor_lns_keepitsteady" ]		= "nyharbor_lns_keepitsteady";
	//Sandman: Got another mine!
	level.scr_radio[ "nyharbor_lns_anothermine" ]		= "nyharbor_lns_anothermine";
	//Sandman: Right, right!
	level.scr_radio[ "nyharbor_lns_right" ]		= "nyharbor_lns_right";
	//Grinch: Mine!
	level.scr_radio[ "nyharbor_rno_mine" ]		= "nyharbor_rno_mine";
	//Sandman: Clear.
	level.scr_radio[ "nyharbor_lns_clear" ]		= "nyharbor_lns_clear";
	//SEAL leader: Target approching. Oscar-2, eight o'clock.
	level.scr_radio[ "nyharbor_sel_targetapproaching" ]		= "nyharbor_sel_targetapproaching";
	//Sandman: Power down, here we go.
	level.scr_radio[ "nyharbor_lns_powerdown" ]		= "nyharbor_lns_powerdown";
	//SEAL leader: Steady.
	level.scr_radio[ "nyharbor_sel_steady" ]		= "nyharbor_sel_steady";
	//Sandman: Wait til she passes.
	level.scr_radio[ "nyharbor_lns_waittilpasses" ]		= "nyharbor_lns_waittilpasses";
	//Sandman: Okay, go!
	level.scr_radio[ "nyharbor_lns_okaygo" ]		= "nyharbor_lns_okaygo";
	//Sandman: Frost, move!
	level.scr_radio[ "nyharbor_lns_frostmove" ]		= "nyharbor_lns_frostmove";
	//Sandman: Get in position.
	level.scr_radio[ "nyharbor_lns_getinposition" ]		= "nyharbor_lns_getinposition";
	//Sandman: Frost, plant the jaywick on the sub.
	level.scr_radio[ "nyharbor_lns_plantjaywick" ]		= "nyharbor_lns_plantjaywick";
	//Sandman: Hurry up!
	level.scr_radio[ "nyharbor_lns_hurryup" ]		= "nyharbor_lns_hurryup";
	//SEAL Leader: Planting.
	level.scr_radio[ "nyharbor_sel_planting" ]		= "nyharbor_sel_planting";
	//Grinch: Planting.
	level.scr_radio[ "nyharbor_rno_planting" ]		= "nyharbor_rno_planting";

	//Sandman: Mines armed. Clear out.
	level.scr_radio[ "nyharbor_lns_minesarmed" ]		= "nyharbor_lns_minesarmed";
	//SEAL Leader: Good job. We'll prep the exfil.
	level.scr_radio[ "nyharbor_sel_goodjob" ]		= "nyharbor_sel_goodjob";
	//Sandman: Going explosive. Hit it.
	level.scr_radio[ "nyharbor_lns_goingexplosive" ]		= "nyharbor_lns_goingexplosive";
	//Sandman: Overlord, this is Metal Zero One. Sub is surfacing. Commencing assault.
	level.scr_radio[ "nyharbor_lns_commencingassault" ]		= "nyharbor_lns_commencingassault";
	//Overlord: Roger, Zero-One, continue to Primary Objective. We need control of the sub's missiles.
	level.scr_radio[ "nyharbor_hqr_primaryobjective" ]		= "nyharbor_hqr_primaryobjective";
	//Sandman: Hold position
	level.scr_radio[ "nyharbor_lns_holdposition" ]		= "nyharbor_lns_holdposition";

	//Sandman: Frost, plant your mine!
	level.scr_radio[ "nyharbor_lns_plantyourmine" ]		= "nyharbor_lns_plantyourmine";
	//Sandman: Frost, get in position!
	level.scr_radio[ "nyharbor_lns_frostgetinposition" ]		= "nyharbor_lns_frostgetinposition";
	//Sandman: Hurry up!
	level.scr_radio[ "nyharbor_lns_hurryup" ]		= "nyharbor_lns_hurryup";
	//Truck: Deck secured. We'll hold topside.
	level.scr_sound[ "sub_truck" ][ "nyharbor_trk_decksecured" ]		= "nyharbor_trk_decksecured";
	//Truck: Get down the ladder!  We still got a job to do!
	level.scr_sound[ "sub_truck" ][ "nyharbor_trk_jobtodo" ]		= "nyharbor_trk_jobtodo";
	//Grinch: Deck secured!  Head down!
	level.scr_sound[ "sub_grinch" ][ "nyharbor_rno_headdown" ]		= "nyharbor_rno_headdown";
	//Grinch: Sandman needs you down there, Frost!
	level.scr_sound[ "sub_grinch" ][ "nyharbor_rno_downthere" ]		= "nyharbor_rno_downthere";
	//Truck: Incoming hind!!!  
	level.scr_sound[ "sub_truck" ][ "nyharbor_trk_incominghind" ]		= "nyharbor_trk_incominghind";
	
	////////////////////////sub interior
	//Sandman: Hatch opening!
	level.scr_sound["lonestar"][ "nyharbor_lns_hatchopening" ]		= "nyharbor_lns_hatchopening";
	//Sandman: Contact, coming out of the hatch!
	level.scr_sound["lonestar"][ "nyharbor_lns_comingout" ]				= "nyharbor_lns_comingout";						
	//Sandman: Frag out!		
	level.scr_sound["lonestar"][ "nyharbor_lns_fragout" ]					= "nyharbor_lns_fragout";									
	//Sandman: Clear. Head down.	
	level.scr_sound["lonestar"][ "nyharbor_lns_clearheaddown" ]		= "nyharbor_lns_clearheaddown";			
	//Sandman: Hold position at the door.
	level.scr_sound["lonestar"][ "nyharbor_lns_atthedoor2" ]		= "nyharbor_lns_atthedoor2";

	//Sandman: Alright Frost, sweep and clear. All unknowns are hostile.
	level.scr_sound[Sandman][ "nyharbor_lns_unknowns" ]		= "nyharbor_lns_unknowns";
	
	//Sandman: Rendezvous downstairs.
	level.scr_sound["lonestar"][ "nyharbor_lns_rvdownstairs" ]			= "nyharbor_lns_rvdownstairs";				
	//Sandman: Frost, head down the stairs.			
	level.scr_sound[ "lonestar" ][ "nyharbor_snd_downstairs" ] = "nyharbor_snd_downstairs";
	//Russian PA: Prepare to evacuate! Repeat, prepare to evacuate!
	level.scr_radio[ "nyharbor_rpa_evacuate" ]		= "nyharbor_rpa_evacuate";
	//Sandman: They're going to scuttle the sub! We gotta move, now!
	level.scr_sound[Sandman][ "nyharbor_lns_scuttle" ]		= "nyharbor_lns_scuttle";				
	//Sandman: Frost, take point.
	level.scr_sound[Sandman][ "nyharbor_lns_takepoint" ]		= "nyharbor_lns_takepoint";
	//Sandman: Stairs clear.		
	level.scr_sound["lonestar"][ "nyharbor_lns_stairsclear" ]			= "nyharbor_lns_stairsclear";					
	//Sandman: Take left.			
	level.scr_sound["lonestar"][ "nyharbor_lns_takeleft" ]					= "nyharbor_lns_takeleft";									
	//Sandman: We have to get to the bridge!
	level.scr_sound[Sandman][ "nyharbor_lns_tothebridge2" ]		= "nyharbor_lns_tothebridge2";

	//Sandman: In position. Put a kicker charge on the door.
	level.scr_sound[Sandman][ "nyharbor_lns_kickercharge" ]		= "nyharbor_lns_kickercharge";
	
	//Sandman: Area secure.
	level.scr_sound[Sandman][ "nyharbor_lns_areasecure" ]		= "nyharbor_lns_areasecure";
	//Sandman: Alright, I got the launch keys.
	level.scr_sound[Sandman][ "nyharbor_lns_launchkeys" ]		= "nyharbor_lns_launchkeys";
	//Sandman: Overlord, this is Metal Zero-One. I send checkpoint "Neptune," over.				
	level.scr_sound[Sandman][ "nyharbor_lns_checkpointneptune" ]		= "nyharbor_lns_checkpointneptune";			
	//Overlord: Roger Zero-One, copy "Neptune."	
	level.scr_radio[ "nyharbor_hqr_copyneptune"  ]		= "nyharbor_hqr_copyneptune";								
	//Sandman: I have the missile key and I'm accessing the launch codes now.		
	level.scr_sound[Sandman][ "nyharbor_lns_missilekey" ]	= "nyharbor_lns_missilekey";						
	level.scr_face[Sandman][ "nyharbor_lns_missilekey" ]	= %ny_harbor_paried_takedown_sandman_flip_over_c_face;						
	//Overlord: Grid coordinates follow: Tango Whiskey Zero Five Six Six Two Eight.
	level.scr_radio[ "nyharbor_hqr_coordinates" ]		= "nyharbor_hqr_coordinates";
	//Sandman: Coordinates confirmed! Launch in 30 seconds!		
	level.scr_sound[Sandman][ "nyharbor_lns_launchin30" ]= "nyharbor_lns_launchin30";
	level.scr_face[Sandman][ "nyharbor_lns_launchin30" ]	= %ny_harbor_missle_key_sandman_idle_face;
	//Sandman: Frost, get on the console!
	level.scr_sound[Sandman][ "nyharbor_lns_console" ]		= "nyharbor_lns_console";
	//Sandman: Frost, over here!
	level.scr_sound[Sandman][ "nyharbor_lns_overhere" ]		= "nyharbor_lns_overhere";
	//Sandman: 3, 2, 1, Turn!
	level.scr_sound[Sandman][ "nyharbor_lns_321turn" ]		= "nyharbor_lns_321turn";
	level.scr_face[Sandman][ "nyharbor_lns_321turn" ]		= %ny_harbor_missle_key_sandman_turnkey_face;
	//Sandman: Overlord, missiles armed and launching!
	level.scr_sound[Sandman][ "nyharbor_lns_missiles" ]		= "nyharbor_lns_missiles";
								
	//Overlord: Roger. SEAL team is in position for exfil.
	level.scr_radio [ "nyharbor_hqr_teaminposition" ]		= "nyharbor_hqr_teaminposition";					
	
	//Sandman: Go! Go!	
	level.scr_sound["lonestar"][ "nyharbor_lns_gogo" ]							= "nyharbor_lns_gogo";
	
	//Sandman: Let's move!	
	//level.scr_sound["lonestar"][ "nyharbor_lns_letsmove2" ]							= "nyharbor_lns_letsmove2";
	
	//Sandman: This way!	
	level.scr_sound["lonestar"][ "nyharbor_lns_thisway" ]							= "nyharbor_lns_thisway";

	//Sandman: Grinch, Truck, let's roll!!	
	level.scr_sound["lonestar"][ "nyharbor_lns_letsroll" ]							= "nyharbor_lns_letsroll";
	
	//Grinch: Amen to that!
	level.scr_radio [ "nyharbor_rno_amentothat" ]		= "nyharbor_rno_amentothat";					
		
	//Sandman: Missile's launching!
	level.scr_sound[Sandman][ "nyharbor_lns_missileslaunching" ]		= "nyharbor_lns_missileslaunching";
	//Sandman: Frost, punch it!
	level.scr_sound[Sandman][ "nyharbor_lns_punchit" ]		= "nyharbor_lns_punchit";
	//Sandman: Keep up with that zodiac!
	level.scr_sound[Sandman][ "nyharbor_lns_keepup" ]		= "nyharbor_lns_keepup";
	//Sandman: Gun it!
	level.scr_sound[Sandman][ "nyharbor_lns_gunit" ]		= "nyharbor_lns_gunit";
	//Sandman: Keep on going, Frost!
	level.scr_sound[Sandman][ "nyharbor_lns_keepongoing" ]		= "nyharbor_lns_keepongoing";
	//Sandman: Missile's coming in!
	level.scr_sound[Sandman][ "nyharbor_lns_missilescoming" ]		= "nyharbor_lns_missilescoming";
	//Sandman: Look out!
	level.scr_sound[Sandman][ "nyharbor_lns_lookout" ]		= "nyharbor_lns_lookout";
	//Sandman: Shoot the mines!
	level.scr_sound[Sandman][ "nyharbor_lns_shootmines" ]		= "nyharbor_lns_shootmines";
	//Chinook pilot: Metal 0-1, we are feet wet!
	level.scr_radio[ "nyharbor_plt_feetwet" ]		= "nyharbor_plt_feetwet";
	//Sandman: There's our bird!
	level.scr_sound[Sandman][ "nyharbor_lns_theresourbird" ]		= "nyharbor_lns_theresourbird";
	//Sandman: There she is! Go! Go!
	level.scr_sound[Sandman][ "nyharbor_lns_theresheis" ]		= "nyharbor_lns_theresheis";
	//Sandman: Overlord, mission complete. All Eagles accounted for.
	level.scr_sound[Sandman][ "nyharbor_lns_missioncomplete" ]		= "nyharbor_lns_missioncomplete";
	//Overlord: Roger Metal 0-1, missile strikes confirmed on multiple Russian hard targets in your AO. All primary threats neutralized. Good work, team, that's one for the books.
	level.scr_radio[ "nyharbor_hqr_oneforbooks" ] = "nyharbor_hqr_oneforbooks";
	//Sandman: Easy day, Overlord. Sandman out.
	level.scr_sound[Sandman][ "nyharbor_lns_easyday" ]		= "nyharbor_lns_easyday";
	
	//russian sailor lines
	//Russian Seaman 1: AMERICANS!!  AMERICANS!!!
	level.scr_sound[ "barracks_1" ][ "nyharbor_ru1_americans" ]		= "nyharbor_ru1_americans";
	//Russian Seaman 2: Get behind the door!  Come on!!  They're coming!!!
	level.scr_sound[ "barracks_2" ][ "nyharbor_ru2_behinddoor" ]		= "nyharbor_ru2_behinddoor";
	//Russian Seaman 1: Pavel!  Get those fires out!  Grab the extinguisher over there!  
	level.scr_sound[ "extinguisher" ][ "nyharbor_ru1_extinguisher" ]		= "nyharbor_ru1_extinguisher";
	//Russian Seaman 2: They've entered the reactor room!!!  
	level.scr_sound[ "reactor" ][ "nyharbor_ru2_reactorroom" ]		= "nyharbor_ru2_reactorroom";
	//Russian Seaman 3: Just rush them!!  They can't kill us all!!
	level.scr_sound[ "stairs" ][ "nyharbor_ru3_rushthem" ]		= "nyharbor_ru3_rushthem";
	//Russian Seaman 3: INTRUDERS!!!  INTRUDERS!!!!
	level.scr_sound[ "missile_1"][ "nyharbor_ru3_intruders" ]		= "nyharbor_ru3_intruders";
	//Russian Seaman 3: FIRE YOUR FUCKING WEAPON MIKHAIL!
	level.scr_sound[ "missile_2" ][ "nyharbor_ru3_fireyourweapon" ]		= "nyharbor_ru3_fireyourweapon";
	//Russian Seaman 3: BORIS!!!  I'm out of ammo!!!  Give me some more!!
	level.scr_sound[ "missile_3" ][ "nyharbor_ru3_outofammo" ]		= "nyharbor_ru3_outofammo";
}


#using_animtree("script_model");
building_destruction()
{
	level.scr_animtree["building_des"] = #animtree;
	level.scr_anim[ "building_des" ][ "ny_manhattan_building_exchange_01_facade_des_anim" ]		 = %ny_manhattan_building_exchange_01_facade_des_anim;
}

anim_rumble_small( guy )
{
	level.player PlayRumbleOnEntity( "viewmodel_small" );
}

anim_rumble_medium( guy )
{
	level.player PlayRumbleOnEntity( "viewmodel_medium" );
}

anim_rumble_large( guy )
{
	level.player PlayRumbleOnEntity( "viewmodel_large" );
}