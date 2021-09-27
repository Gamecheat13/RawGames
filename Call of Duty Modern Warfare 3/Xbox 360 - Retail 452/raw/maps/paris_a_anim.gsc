// paris_anim.gsc
//
// animation setup stuff goes here, and our main() is called by paris::main().

#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;

main()
{
	maps\_hand_signals::initHandSignals();
	
	player_anims();
	generic_human_anims();
	vehicles_anims();
	animated_props_anims();
	script_model_anims();
}

#using_animtree( "player" );
player_anims()
{
	level.scr_animtree[ "player_rig" ]											= #animtree;
	level.scr_model[ "player_rig" ]												= "viewhands_player_delta";
	level.scr_anim[ "player_rig" ][ "player_manhole" ]								= %paris_player_enter_manhole;
}

#using_animtree("generic_human");	
generic_human_anims()
{
	
	// hand siganls
	level.scr_anim[ "generic" ][ "stand_cover_right_signal_move_out" ]			= %CornerStndR_alert_signal_move_out;
	
	level.scr_anim[ "generic" ][ "DRS_sprint" ]									= %sprint1_loop;

	// helicopter intro sequence
	level.scr_anim[ "lonestar" ][ "intro_heli_loop" ]							= [%paris_intro_heli_idle_sandman];
	level.scr_anim[ "reno"     ][ "intro_heli_loop" ]							= [%paris_intro_heli_idle_truck];
	level.scr_anim[ "pilot"    ][ "intro_heli_loop" ]							= [%helicopter_pilot1_idle];
	level.scr_anim[ "reno"     ][ "intro_roof_idle" ]							= [%paris_intro_roof_idle_truck];
	level.scr_anim[ "lonestar" ][ "intro_heli_exit" ]							= %paris_intro_heli_exit_sandman;
	level.scr_anim[ "reno"     ][ "intro_heli_exit" ]							= %paris_intro_heli_exit_grinch;
	level.scr_anim[ "lonestar" ][ "intro_roof_talk" ]							= %paris_intro_roof_talk_sandman;
	level.scr_anim[ "lonestar" ][ "intro_roof_jumpdown" ]						= %paris_intro_roof_jumpdown_sandman; 
	level.scr_anim[ "reno"     ][ "intro_roof_jumpdown" ]						= %paris_intro_roof_jumpdown_truck;

	// sandman checks vitals of a dead civilian
	level.scr_anim[ "lonestar" ][ "delta_check_vitals" ]						= %paris_delta_check_vitals_delta;
	level.scr_anim[ "corpse" ][ "delta_check_vitals" ]							= %paris_delta_check_vitals_corpse;

	// pushing the sofa off the ledge
	level.scr_anim[ "reno"     ][ "move_debris_in" ]							= %paris_delta_move_debris_in_guy2;
	level.scr_anim[ "reno"     ][ "move_debris_idle" ]							= [ %paris_delta_move_debris_idle_guy2 ];
	level.scr_anim[ "reno"     ][ "move_debris" ]								= %paris_delta_move_debris_out_guy2;
	level.scr_anim[ "lonestar" ][ "move_debris" ]								= %paris_delta_move_debris_guy1;
			
	// shimmeying across a narrow ledge
	level.scr_anim[ "lonestar" ][ "delta_ledge_walk" ]							= %paris_delta_ledge_walk_01;
	level.scr_anim[ "reno"     ][ "delta_ledge_walk" ]							= %paris_delta_ledge_walk_02;

	// delta gets fired at in the stairwell
	level.scr_anim[ "reno"    ][ "delta_stairwell_reaction" ]					= %paris_npc_shot_reaction_guy1;	
	level.scr_anim[ "lonestar"    ][ "delta_stairwell_reaction" ]				= %paris_npc_shot_reaction_guy2;	

	// guys breach their way out of the bookstore
	level.scr_anim[ "reno"     ] [ "bookstore_exit_st"   ]                      = %paris_bookstore_exit_guy1_st;
	level.scr_anim[ "reno"     ] [ "bookstore_exit_idle" ]                      = [ %paris_bookstore_exit_guy1_idle ];
	level.scr_anim[ "reno"     ] [ "bookstore_exit_exit" ]                      = %paris_bookstore_exit_guy1_exit;
	level.scr_anim[ "lonestar" ] [ "bookstore_exit_st"   ]                      = %paris_bookstore_exit_guy2_st;
	level.scr_anim[ "lonestar" ] [ "bookstore_exit_idle" ]                      = [ %paris_bookstore_exit_guy2_idle ];
	level.scr_anim[ "lonestar" ] [ "bookstore_exit_exit" ]                      = %paris_bookstore_exit_guy2_exit;	
	//play door breach fx
	addNotetrack_customFunction( "reno", "door_fx", ::fx_door_breach, "bookstore_exit_exit" );
	
	// bookstore alley death
	level.scr_anim[ "generic"  ][ "bookstore_alley_shooting_1" ]				= %paris_van_climb_paired_guy1_alt;
	level.scr_anim[ "generic"  ][ "bookstore_alley_shooting_2" ]				= %run_death_legshot;
	level.scr_anim[ "generic"  ][ "bookstore_alley_shooting_1_death" ]			= %paris_van_climb_paired_guy1_death;
	
	// gign meeting runner
	level.scr_anim[ "generic"  ][ "gign_meeting_runner" ]						= %paris_sabre_wave_kitchen;
	
	// gign meeting in restaurant
	level.scr_anim[ "generic" ][ "gign_wave" ]									= [ %launchfacility_b_blast_door_seq_waveidle ];
	level.scr_anim[ "gign_leader" ][ "conversation_with_gign_idle" ]			= [ %paris_delta_conversation_with_gign_a_idle ];
	level.scr_anim[ "gign_leader" ][ "conversation_with_gign" ]					= %paris_gign_conversation_wheres_volk_guy2;
	level.scr_anim[ "lonestar"    ][ "conversation_with_gign" ]					= %paris_gign_conversation_wheres_volk_guy1;	
	level.scr_anim[ "lonestar" ][ "conversation_with_gign_end"       ]  		= %CQB_walk_turn_4;

	level.scr_anim[ "redshirt" ][ "conversation_blocker" ]						= %paris_delta_conversation_blocker_guard;
	level.scr_anim[ "wounded"  ][ "conversation_blocker" ]						= %paris_delta_conversation_blocker_wounded;
	
//	level.scr_anim[ "redshirt" ][ "conversation_blocker_idle_no_origin" ]		= [ %corner_standL_alert_idle ];
	level.scr_anim[ "redshirt" ][ "conversation_blocker_idle_no_origin" ]		= [ %corner_standL_alert_twitch03 ];
	level.scr_anim[ "redshirt" ][ "conversation_blocker_exit"           ]       = %corner_standL_trans_OUT_2;
	level.scr_anim[ "redshirt" ][ "conversation_blocker_exit_end"       ]  		= %run_turn_L90;
	level.scr_anim[ "wounded"  ][ "conversation_blocker_idle_no_origin" ]		= [ %wounded_carry_closet_idle_wounded ];

	// balcony deaths
	level.scr_anim[ "generic" ][ "balcony_death" ] = [];
	level.scr_anim[ "generic" ][ "balcony_death" ][ 0 ] = %paris_rooftop_death_a;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 1 ] = %paris_rooftop_death_b;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 2 ] = %paris_rooftop_death_c;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 3 ] = %paris_rooftop_death_d;
	level.scr_anim[ "generic" ][ "balcony_death" ][ 4 ] = %paris_rooftop_death_e;

	// opening the manhole
	level.scr_anim[ "gign_leader" ][ "delta_pull_movemanhole" ]					= %paris_delta_pull_movemanhole_guy1;		
	level.scr_anim[ "lonestar"    ][ "delta_pull_movemanhole" ]					= %paris_delta_pull_movemanhole_guy2;		
	level.scr_anim[ "lonestar"    ][ "delta_pull_movemanhole_idle" ]			= [ %paris_delta_pull_movemanhole__idle_guy2 ];	
	//turn on manhole steam
	addNotetrack_customFunction( "gign_leader", "ps_scn_pars_manhole_open", ::fx_manhole_steam, "delta_pull_movemanhole" );
	
	// dead poses
	level.scr_anim[ "generic" ][ "death_pose_window" ]							= %death_pose_on_window;
	level.scr_anim[ "generic" ][ "death_pose_desk" ]							= %death_pose_on_desk;
	level.scr_anim[ "generic" ][ "death_sitting_pose_1" ]						= %death_sitting_pose_v1;
	level.scr_anim[ "generic" ][ "death_sitting_pose_2" ]						= %death_sitting_pose_v2;
	level.scr_anim[ "generic" ][ "death_pose_farmer" ]							= %hunted_farmsequence_farmer_deathpose;
	level.scr_anim[ "generic" ][ "death_pose_01" ]								= %paris_npc_dead_poses_v01;
	level.scr_anim[ "generic" ][ "death_pose_02" ]								= %paris_npc_dead_poses_v02;
	level.scr_anim[ "generic" ][ "death_pose_03" ]								= %paris_npc_dead_poses_v03;
	level.scr_anim[ "generic" ][ "death_pose_04" ]								= %paris_npc_dead_poses_v04;
	level.scr_anim[ "generic" ][ "death_pose_05" ]								= %paris_npc_dead_poses_v05;
	level.scr_anim[ "generic" ][ "death_pose_06" ]								= %paris_npc_dead_poses_v06;
	level.scr_anim[ "generic" ][ "death_pose_07" ]								= %paris_npc_dead_poses_v07;
	level.scr_anim[ "generic" ][ "death_pose_08" ]								= %paris_npc_dead_poses_v08;
	level.scr_anim[ "generic" ][ "death_pose_09" ]								= %paris_npc_dead_poses_v09;
	level.scr_anim[ "generic" ][ "death_pose_10" ]								= %paris_npc_dead_poses_v10;
	level.scr_anim[ "generic" ][ "death_pose_12" ]								= %paris_npc_dead_poses_v12;
	level.scr_anim[ "generic" ][ "death_pose_13" ]								= %paris_npc_dead_poses_v13;
	level.scr_anim[ "generic" ][ "death_pose_14" ]								= %paris_npc_dead_poses_v14;
	level.scr_anim[ "generic" ][ "death_pose_15" ]								= %paris_npc_dead_poses_v15;
	level.scr_anim[ "generic" ][ "death_pose_16" ]								= %paris_npc_dead_poses_v16;
	level.scr_anim[ "generic" ][ "death_pose_17" ]								= %paris_npc_dead_poses_v17;
	level.scr_anim[ "generic" ][ "death_pose_18" ]								= %paris_npc_dead_poses_v18;
	level.scr_anim[ "generic" ][ "death_pose_19" ]								= %paris_npc_dead_poses_v19;
	level.scr_anim[ "generic" ][ "death_pose_21" ]								= %paris_npc_dead_poses_v21;
	level.scr_anim[ "generic" ][ "death_pose_24" ]								= %paris_npc_dead_poses_v24_chair_sq;
	level.scr_anim[ "generic" ][ "death_pose_25" ]								= %paris_npc_dead_poses_v25_chair_wicker;
	level.scr_anim[ "generic" ][ "death_pose_26" ]								= %paris_npc_dead_poses_v26_couch;
	level.scr_anim[ "generic" ][ "death_pose_27" ]								= %paris_npc_dead_poses_v27_chair_bistro;
	level.scr_anim[ "generic" ][ "death_pose_28" ]								= %paris_npc_dead_poses_v28_table_bistro;

}

#using_animtree("vehicles");	
vehicles_anims()
{	

}

#using_animtree( "animated_props" );
animated_props_anims()
{
	// the manhole that gets pulled aside
	level.scr_animtree[ "manhole" ]												= #animtree;
	level.scr_anim    [ "manhole" ][ "delta_pull_movemanhole" ]					= %paris_delta_pull_movemanhole_manhole;
	level.scr_anim    [ "manhole" ][ "delta_pull_movemanhole_idle" ]			= [ %paris_delta_pull_movemanhole_idle_manhole ];
}


#using_animtree( "script_model" );
script_model_anims()
{
	level.scr_animtree["debris"]												= #animtree;
	level.scr_model["debris"]													= "rooftop_roof_slab";
	level.scr_anim[ "debris"     ][ "move_debris" ]								= %paris_delta_move_debris;
	
	level.scr_animtree[ "bookstore_door" ]                                      = #animtree;
	level.scr_model[ "bookstore_door" ]                                         = "paris_exit_door_01_rigged";
	level.scr_anim[  "bookstore_door" ][ "bookstore_exit_exit" ]                = %paris_bookstore_exit_door_exit;
}

fx_manhole_steam(guy)
{
	//turn on steam fx
	exploder("manholesteam");
	//disable alpha threshhold as it looks bad on this effect
	setsaveddvar("fx_alphathreshold",0);
}

fx_door_breach(guy)
{
	exploder("msg_door_breach");
}