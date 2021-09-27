#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_props;

main()
{
	////////////// ANIMATIONS /////////
	load_actor_anims();
	load_player_anims();
	load_vehicle_anims();
	load_script_model_anims();
	load_dog_anims();
	
	thread setup_anim_model();
	add_cellphone_notetracks( "generic" );
	add_smoking_notetracks( "generic" );
	add_warlord_smoking_notetracks( "generic" );
}

#using_animtree("generic_human");
load_actor_anims()
{
	maps\_hand_signals::initHandSignals();
	
	// river
	level.scr_anim[ "generic" ][ "london_dock_soldier_walk" ] = %london_dock_soldier_walk;
	level.scr_anim[ "price" ][ "sniper_open_door" ] = %hunted_open_barndoor_flathand;
	level.scr_anim[ "generic" ][ "DRS_sprint" ]				 = %sprint1_loop;
	
	level.scr_anim[ "price" ][ "water_crouch_idle" ][0] = %africa_price_submerge_idle;
	level.scr_anim[ "price" ][ "water_emerge" ] = %africa_price_emerge_slow;
	level.scr_face[ "price" ][ "price_emerge_lines" ] = %africa_price_emerge_slow_face;
	//Nikolai, we're just outside the village.
	level.scr_sound[ "price" ][ "price_emerge_lines" ][0] = "warlord_pri_secureweapons";
	//The factory isn't far from here.  Makarov's cargo should be there.  Keep it silent.  Let's move.
	level.scr_sound[ "price" ][ "price_emerge_lines" ][1] = "warlord_pri_karamasarmy";
	
	level.scr_anim[ "soap" ][ "water_crouch_idle" ][0] = %africa_soap_submerge_idle;
	level.scr_anim[ "soap" ][ "water_emerge" ] = %africa_soap_emerge_slow;
	
	level.scr_anim[ "soap" ][ "africa_soap_pulldown_entrance_guy1" ] = %africa_soap_pulldown_entrance_guy1;
	level.scr_anim[ "soap" ][ "africa_soap_pulldown_crouch_idle_guy1" ][0] = %africa_soap_pulldown_crouch_idle_guy1;
	level.scr_anim[ "soap" ][ "river_pulldown" ] = %africa_soap_pulldown_kill_guy1;
	addNotetrack_customFunction( "soap", "show_knife", ::river_kill_knife, "river_pulldown" );
	addNotetrack_customFunction( "soap", "hide_knife", ::detach_knife, "river_pulldown" );
	level.scr_anim[ "militia" ][ "river_pulldown" ] = %africa_soap_pulldown_kill_guy2;
	
	level.scr_anim[ "price" ][ "price_log_duck" ] = %africa_soap_touches_tree;
	level.scr_anim[ "soap" ][ "soap_log_duck" ] = %africa_price_touches_tree;
	
	level.scr_anim[ "generic" ][ "react_behind" ] = %stand_cover_reaction_B;
	level.scr_anim[ "generic" ][ "react_behind_2" ] = %payback_sstorm_reaction_guard1;
	level.scr_anim[ "generic" ][ "react_ahead" ] = %payback_sstorm_guard_shoot_reaction_1;
	level.scr_anim[ "generic" ][ "react_ahead_2" ] = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "react_ahead_3" ] = %exposed_idle_reactB;
	
	level.scr_anim[ "price" ][ "CornerStndR_alert_signal_enemy_spotted" ] = %CornerStndR_alert_signal_enemy_spotted;
	level.scr_anim[ "generic" ][ "parabolic_leaning_guy_trans2smoke" ][0] = %parabolic_leaning_guy_trans2smoke;
	level.scr_anim[ "generic" ][ "patrol_bored_idle_smoke" ][0] = %patrol_bored_idle_smoke;
	
	level.scr_anim[ "generic" ][ "patrol_bored_walk" ][0]			  = %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_bored_walk" ][1]			  = %patrol_bored_patrolwalk_twitch;
	
	level.scr_anim[ "generic" ][ "patrol_london_walk" ][0]			= %london_dock_soldier_walk;
	
	level.scr_anim[ "generic" ][ "patrol_warlord_walk" ][0]			 	 			= %patrolwalk_swagger;
	level.scr_anim[ "generic" ][ "patrol_warlord_walk" ][1]				 			= %patrolwalk_bounce;
	level.scr_anim[ "generic" ][ "patrol_warlord_walk" ][2]				 			= %patrolwalk_tired;
	
	level.scr_anim[ "generic" ][ "patrol_warlord_walk_1" ][0] 						= %africa_npc_patrol_alt1_loop;
	level.scr_anim[ "generic" ][ "patrol_warlord_walk_2" ][0]						= %africa_npc_patrol_alt2_loop;
	level.scr_anim[ "militia" ][ "pulldown_walk" ][0] = %africa_npc_patrol_alt2_loop;
	
	level.scr_anim[ "soap" ][ "soap_burn_in" ] = %africa_roll_from_crouch_guy1_in;
	level.scr_anim[ "soap" ][ "soap_burn_idle" ][0] = %africa_roll_from_crouch_guy1_idle;
	level.scr_anim[ "soap" ][ "soap_burn_out" ] = %africa_roll_from_crouch_guy1_out;
	
	level.scr_anim[ "price" ][ "price_burn_in" ] = %africa_roll_from_crouch_guy2_in;
	level.scr_anim[ "price" ][ "price_burn_idle" ][0] = %africa_roll_from_crouch_guy2_idle;
	level.scr_anim[ "price" ][ "price_burn_out" ] = %africa_roll_from_crouch_guy2_out;
	
	level.scr_anim[ "militia" ][ "burn" ] = %africa_militia_torture_burn_militia;
	level.scr_anim[ "victim" ][ "burn" ] = %africa_militia_torture_burn_victim;
	addNotetrack_customFunction( "victim", "burn", ::burn_victim_fire, "burn" );
	level.scr_anim[ "victim" ][ "burn_escape" ] = %africa_militia_torture_victim_escape;
	level.scr_anim[ "generic" ][ "civilian_run_hunched_C" ] = %civilian_run_hunched_C;
	
	level.scr_anim[ "generic" ][ "africa_technical_passenger_back_idle_stopped" ][0] = %africa_technical_passenger_back_idle_stopped;
	level.scr_anim[ "generic" ][ "africa_technical_passenger_backside_idle_stopped" ][0] = %africa_technical_passenger_backside_idle_stopped;
	level.scr_anim[ "generic" ][ "africa_technical_passenger_lside_idle_stopped" ][0] = %africa_technical_passenger_lside_idle_stopped;
	level.scr_anim[ "generic" ][ "africa_technical_passenger_rside_idle_stopped" ][0] = %africa_technical_passenger_rside_idle_stopped;
	
	level.scr_anim[ "militia_1" ][ "river_execution" ] = %africa_execution_soldier_1;
	level.scr_anim[ "militia_2" ][ "river_execution" ] = %africa_execution_soldier_2;
	level.scr_anim[ "civ_1" ][ "river_execution" ] = %africa_execution_prisoner_1;
	level.scr_anim[ "civ_2" ][ "river_execution" ] = %africa_execution_prisoner_2;
	level.scr_anim[ "civ_3" ][ "river_execution" ] = %africa_execution_prisoner_3;
	level.scr_anim[ "civ_1" ][ "execution_loop_1" ][0] = %africa_execution_prisoner_1_loop;
	level.scr_anim[ "civ_2" ][ "execution_loop_2" ][0] = %africa_execution_prisoner_2_loop;
	level.scr_anim[ "civ_3" ][ "execution_loop_3" ][0] = %africa_execution_prisoner_3_loop;
	level.scr_anim[ "generic" ][ "civ_crouch_death" ] = %covercrouch_death_1;
	level.scr_anim[ "generic" ][ "civ_crouch_death2" ] = %exposed_crouch_death_fetal;	
	
	//level.scr_anim[ "militia" ][ "machete_kill" ] = %africa_machete_paired_guy1;
	//level.scr_anim[ "civ" ][ "machete_kill" ] = %africa_machete_paired_guy2;
	
	level.scr_anim[ "price" ][ "prone_dive" ] = %hunted_dive_2_pronehide_v2;
	level.scr_anim[ "soap" ][ "prone_dive" ] = %hunted_dive_2_pronehide_v2;
	
	level.scr_anim[ "generic" ][ "prone_search_1" ] = %africa_look_into_brush_guy1;
	level.scr_anim[ "generic" ][ "prone_search_2" ] = %africa_look_into_brush_guy2;
	
	//corpses
	level.scr_anim[ "generic" ][ "africa_pullbody_offbridge_guy1_deathIdle" ] = %africa_pullbody_offbridge_guy1_deathIdle;
	level.scr_anim[ "generic" ][ "africa_pullbody_offbridge_guy2_deathIdle" ] = %africa_pullbody_offbridge_guy2_deathIdle;
	
	level.scr_anim[ "militia" ][ "burn_dragger_drag" ] = %africa_burning_men_burner_drag;
	level.scr_anim[ "militia" ][ "burn_dragger_idle" ][0] = %africa_burning_men_burner_idle;
	level.scr_anim[ "militia" ][ "burn_watcher_watch" ] = %africa_burning_men_watcher_watch;
	level.scr_anim[ "militia" ][ "burn_watcher_idle" ][0] = %africa_burning_men_watcher_idle;
	level.scr_anim[ "civ_1" ][ "burn_dragger_drag" ] = %africa_burnbody_carried1;
	level.scr_anim[ "civ_2" ][ "burn_dragger_drag" ] = %africa_burnbody_carried2;
	
	level.scr_anim[ "generic" ][ "africa_burnbody_1" ][0] = %africa_burnbody_1;
	level.scr_anim[ "generic" ][ "africa_burnbody_2" ][0] = %africa_burnbody_2;
	level.scr_anim[ "generic" ][ "africa_burnbody_3" ][0] = %africa_burnbody_3;
	level.scr_anim[ "generic" ][ "africa_burnbody_4" ][0] = %africa_burnbody_4;
	level.scr_anim[ "generic" ][ "africa_burnbody_5" ][0] = %africa_burnbody_5;
	
	level.scr_anim[ "generic" ][ "dead_body_floating_1" ] = %dead_body_floating_1;
	//level.scr_anim[ "generic" ][ "scout_sniper_bodydump_deadguy_throw1" ] = %scout_sniper_bodydump_deadguy_throw1;
	level.scr_anim[ "generic" ][ "favela_escape_crucified_idle" ] = %favela_escape_crucified_idle;
	
	level.scr_anim[ "soap" ][ "cqb_crouch_exit_8" ] = %cqb_crouch_start_8;	
	level.scr_anim[ "soap" ][ "soap_wall_cover_enter" ] = %africa_stack_on_wall_in;
	level.scr_anim[ "soap" ][ "soap_wall_cover_idle" ][0] = %africa_stack_on_wall_idle;
	level.scr_anim[ "soap" ][ "soap_wall_cover_exit" ] = %africa_stack_on_wall_out;
	
	//ambient
	level.scr_anim[ "generic" ][ "coup_guard1_jeer" ][0] = %coup_guard1_jeer;
	//level.scr_anim[ "generic" ][ "coup_guard2_jeerB" ][0] = %coup_guard2_jeerB;
	//level.scr_anim[ "generic" ][ "coup_guard2_jeerC" ][0] = %coup_guard2_jeerC;
	level.scr_anim[ "generic" ][ "civ_captured" ][0] = %prague_resistance_walk_01;
	level.scr_anim[ "generic" ][ "casual_killer_walk_f" ][0] = %casual_killer_walk_f;
	
	level.scr_anim[ "generic" ][ "jeer_loop_1" ][0] = %coup_guard1_jeer;
	level.scr_anim[ "generic" ][ "jeer_loop_1" ][1] = %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "jeer_loop_2" ][0] = %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "jeer_loop_3" ][0] = %patrol_bored_idle_smoke;

	//bridge_scene
	level.scr_anim[ "generic" ][ "bridge_death_1" ] = %africa_pullbody_offbridge_death_guy1;
	level.scr_anim[ "generic" ][ "bridge_pulloff_1" ] = %africa_pullbody_offbridge_guy1;
	level.scr_anim[ "generic" ][ "float_idle_1" ] = %africa_pullbody_offbridge_guy1_deathIdle;
	level.scr_anim[ "generic" ][ "bridge_death_2" ] = %africa_pullbody_offbridge_death_guy2;
	level.scr_anim[ "generic" ][ "bridge_pulloff_2" ] = %africa_pullbody_offbridge_guy2;
	level.scr_anim[ "generic" ][ "float_idle_2" ] = %africa_pullbody_offbridge_guy2_deathIdle;
	level.scr_anim[ "price" ][ "bridge_pulloff_1" ] = %africa_pullbody_offbridge_price;
	level.scr_anim[ "soap" ][ "bridge_pulloff_2" ] = %africa_pullbody_offbridge_soap;
	addNotetrack_customFunction( "generic", "splash", ::play_splash_1, "bridge_pulloff_1" );
	addNotetrack_customFunction( "generic", "splash", ::play_splash_2, "bridge_pulloff_2" );

	// infiltration
	level.scr_anim[ "price" ][ "price_corner_kill" ] = %africa_price_paired_corner_kill_hero;
	level.scr_anim[ "generic" ][ "price_corner_kill" ] = %africa_price_paired_corner_kill_enemy;
	addNotetrack_customFunction( "price", "showKnife", ::corner_kill_knife, "price_corner_kill" );
	addNotetrack_customFunction( "price", "hideKnife", ::detach_knife, "price_corner_kill" );
	addNotetrack_customFunction( "price", "stab", ::stab_knife, "price_corner_kill" );
	addNotetrack_customFunction( "generic", "kill", ::kill_me, "price_corner_kill" );	
	
	level.scr_anim[ "generic" ][ "sleep_idle" ][0] = %parabolic_guard_sleeper_idle;
	level.scr_anim[ "generic" ][ "sleep_react" ] = %parabolic_guard_sleeper_react;
	level.scr_anim[ "generic" ][ "throat_stab" ] = %africa_tower_throat_stab_npc;
	addNotetrack_customFunction( "generic", "knife_in", ::throat_stab_npc, "throat_stab" );
	level.scr_anim[ "soap" ][ "soap_door_kill" ] = %africa_soap_paired_door_stab_push_hero;
	level.scr_anim[ "generic" ][ "soap_door_kill" ] = %africa_soap_paired_door_stab_push_enemy;	

	level.scr_anim[ "price" ][ "price_corner_kill_2" ] = %cornerSdR_melee_winD_defender;
	level.scr_anim[ "generic" ][ "price_corner_kill_2" ] = %cornerSdR_melee_winD_attacker;
	
	level.scr_anim[ "price" ][ "factory_breach" ] = %breach_kick_kickerR1_enter;
	level.scr_anim[ "soap" ] [ "factory_breach" ] = %breach_kick_stackL1_enter;
	addNotetrack_customFunction( "price", "kick", ::price_kick_door, "factory_breach" );
	
	// advance
	level.scr_anim[ "soap" ][ "dive_over_cover" ] = %africa_soap_dive_over_cover;
	level.scr_anim[ "soap" ][ "CornerCrL_alert_idle" ][0]	= %CornerCrL_alert_idle;
	
	// player technical
	level.scr_anim[ "generic" ][ "technical_gunner_death" ] = %warlord_pickup_gunner_death;
	level.scr_anim[ "generic" ][ "get_on_technical" ] = %warlord_pickup_gunner_push_off;
	level.scr_anim[ "generic" ][ "technical_driver_pull_out" ] = %africa_soap_pull_dead_driver_driver;
	level.scr_anim[ "soap" ][ "technical_driver_pull_out" ] = %africa_soap_pull_dead_driver_soap;
	level.scr_anim[ "soap" ][ "technical_driver_pull_out_idle" ][0] = %africa_soap_pull_dead_driver_soap_idle;
	level.scr_anim[ "soap" ][ "technical_driver_dive_out" ] = %africa_soap_dive_from_truck;	
	level.scr_anim[ "soap" ][ "knock_off_technical" ] = %warlord_pickup_soap_assist;
	
	level.scr_face[ "soap" ][ "knock_off_technical_lines" ] = %warlord_pickup_soap_assist_facial;
	//HOLD ON!
	level.scr_sound[ "soap" ][ "knock_off_technical_lines" ][0] = "warlord_mct_holdon";
	//Get up! We gotta get the hell out of here!
	level.scr_sound[ "soap" ][ "knock_off_technical_lines" ][1] = "warlord_mct_getup";
	//The whole militia is headed straight for us!
	level.scr_sound[ "soap" ][ "knock_off_technical_lines" ][2] = "warlord_mct_wholemilitia";
	
	// mortar run
	level.scr_anim[ "price" ][ "run_react_flinch" ] = %run_react_flinch;
	level.scr_anim[ "price" ][ "run_react_stumble" ] = %run_react_stumble;
	level.scr_anim[ "soap" ][ "run_react_flinch" ] = %run_react_flinch;
	level.scr_anim[ "soap" ][ "run_react_stumble" ] = %run_react_stumble;
	level.scr_anim[ "price" ][ "run_react_explosion1" ] = %africa_explosion_react_guy1;
	level.scr_anim[ "price" ][ "run_react_explosion2" ] = %africa_explosion_react_guy2;
	level.scr_anim[ "soap" ][ "run_react_explosion1" ] = %africa_explosion_react_guy1;
	level.scr_anim[ "soap" ][ "run_react_explosion2" ] = %africa_explosion_react_guy2;
	
	level.scr_anim[ "soap" ][ "soap_melee_kill" ] = %africa_soap_melee_kill;
	level.scr_anim[ "generic" ][ "soap_melee_kill" ] = %africa_soap_melee_kill_victim;
	level.scr_anim[ "price" ][ "soap_door_kickin" ] = %africa_soap_kickin_door;
	addNotetrack_customFunction ("price", "door_open", ::mortar_run_door_swing_open, "soap_door_kickin");
	
	level.scr_anim[ "militia" ][ "africa_pc_roof_jump_attacker" ] = %africa_pc_roof_jump_attacker;
	addNotetrack_customFunction( "militia", "kill_VM", ::roof_kill_player, "africa_pc_roof_jump_attacker" );
	level.scr_anim[ "militia" ][ "africa_pc_roof_jump_attacker_death" ] = %africa_pc_roof_jump_attacker_death;
	level.scr_anim[ "militia" ][ "africa_machette_idle" ] = %africa_machette_idle;
	
	level.scr_anim[ "generic" ][ "mortar_idle" ][0] = %africa_militia_mortar_idle;
	
	// player mortar
	level.scr_anim[ "generic" ][ "explosion_flying_react" ] = %africa_body_flying_explosion;
	
	// assault
	//level.scr_anim[ "generic" ][ "doorburst_wave" ]	= %doorburst_wave;
	level.scr_anim[ "generic" ][ "death_rooftop_A" ]  = %death_rooftop_A;
	//level.scr_anim[ "generic" ][ "death_rooftop_B" ]  = %death_rooftop_B;
	//level.scr_anim[ "generic" ][ "death_rooftop_D" ]  = %death_rooftop_D;
	//level.scr_anim[ "generic" ][ "death_rooftop_E" ]  = %death_rooftop_E;
	level.scr_anim[ "soap" ][ "approach_rip_sewer" ] = %africa_soap_rip_sewer_enter;
	level.scr_anim[ "soap" ][ "rip_sewer_idle" ][0] = %africa_soap_rip_sewer_idle;
	level.scr_anim[ "soap" ][ "rip_sewer_grate" ] = %africa_soap_rip_sewer_guy_1;
	level.scr_anim[ "soap" ][ "shoulder_charge_door" ] = %africa_soap_shoulder_charge_door;
	addNotetrack_customFunction( "soap", "impact_door", ::soap_bash_door, "shoulder_charge_door" );
	
	// breach
	level.scr_anim[ "generic" ][ "breach_chair_hide_reaction_v1" ] = %breach_chair_hide_reaction_v1;
	level.scr_anim[ "generic" ][ "breach_react_desk_v2" ] = %breach_react_desk_v2;
	level.scr_anim[ "generic" ][ "exposed_idle_reactA" ] = %exposed_idle_reactA;
	level.scr_anim[ "generic" ][ "breach_react_push_guy1" ] = %breach_react_push_guy1;
	level.scr_anim[ "generic" ][ "breach_react_push_guy2" ] = %breach_react_push_guy2;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy1" ] = %breach_react_guntoss_v2_guy1;
	level.scr_anim[ "generic" ][ "breach_react_guntoss_v2_guy2" ] = %breach_react_guntoss_v2_guy2;
	
	level.scr_anim[ "soap" ][ "doorkick" ] 						= %door_kick_in;
	addNotetrack_customFunction( "soap", "kick", ::kick_church_doors, "doorkick" );
	
	level.scr_anim[ "generic" ][ "africa_hyena_hold" ] = %africa_hyena_guy1;
	level.scr_anim[ "generic" ][ "africa_hyena_release" ] = %africa_hyena_release_guy1;
	
	// stand-off
	level.scr_anim[ "price" ][ "warlord_standoff" ] = %warlord_standoff_price;
	level.scr_anim[ "warlord" ][ "warlord_standoff" ] = %warlord_standoff_warlord;
	
	level.scr_anim[ "price" ][ "warlord_standoff_new" ] = %warlord_standoff_price;
	level.scr_anim[ "warlord" ][ "warlord_standoff_new" ] = %warlord_standoff_warlord;	
	
	level.scr_anim[ "price" ][ "warlord_ending" ] 	= %warlord_standoff_price_pt2;
	level.scr_face[ "price" ][ "price_ending_lines" ] = %warlord_standoff_price_pt2_face;
	//Price: He's getting away!
	level.scr_sound[ "price" ][ "price_ending_lines" ][0]		= "warlord_pri_hesgettingaway";
	//Price: Damn…
	level.scr_sound[ "price" ][ "price_ending_lines" ][1]		= "warlord_pri_damn";
	//Price: Nikolai, looks like we missed our window. Makarov's not here.
	level.scr_sound[ "price" ][ "price_ending_lines" ][2]		= "warlord_pri_missedwindow";
	//Price: Must've done a runner.  Just get us out of here.
	level.scr_sound[ "price" ][ "price_ending_lines" ][3]		= "warlord_pri_arunner";
	//Price: We'll ask the bastard ourselves when we find him.
	level.scr_sound[ "price" ][ "price_ending_lines" ][4]		= "warlord_pri_wellask";
	
	level.scr_anim[ "soap" ][ "warlord_ending" ] 	= %warlord_standoff_soap_pt2;
	//Soap: Empty. What do you think Makarov was after?
	level.scr_face[ "soap" ][ "warlord_mct_empty" ] = %warlord_standoff_soap_pt2_face;
	level.scr_sound[ "soap" ][ "warlord_mct_empty" ]		= "warlord_mct_empty";
	level.scr_anim[ "warlord" ][ "warlord_ending" ] = %warlord_standoff_warlord_pt2;
	addNotetrack_customFunction( "warlord", "blood", ::blood_warlord_vfx, "warlord_ending" );
}

#using_animtree( "player" );
load_player_anims()
{
	level.scr_animtree[ "player_rig" ] 					 								= #animtree;
	level.scr_model[ "player_rig" ] 														= "viewhands_player_yuri";
	
	level.scr_anim[ "player_rig" ][ "water_emerge" ] = %africa_player_emerge_slow;
	
	level.scr_anim[ "player_rig" ][ "get_on_technical" ] 				= %warlord_pickup_player_geton;
	
	level.scr_anim[ "player_rig" ][ "knock_off_technical" ] 		= %warlord_pickup_player_knockoff;
	addNotetrack_customFunction( "player_rig", "timescale_start", ::timescale_start, "knock_off_technical" );
	addNotetrack_customFunction( "player_rig", "timescale_end", ::timescale_end, "knock_off_technical" );
	addNotetrack_customFunction( "player_rig", "rumble_small", ::anim_rumble_small, "knock_off_technical" );
	addNotetrack_customFunction( "player_rig", "rumble_meduim", ::anim_rumble_medium, "knock_off_technical" );
	addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "knock_off_technical" );
	
	level.scr_anim[ "player_rig" ][ "throat_stab" ] 						= %africa_tower_throat_stab_player;
	addNotetrack_customFunction( "player_rig", "knife_in", ::throat_stab_player, "throat_stab" );
	
	//level.scr_anim[ "player_rig" ][ "roof_fall" ] 							= %africa_pc_roof_fall;
	level.scr_anim[ "player_rig" ][ "roof_fall" ] = %africa_pc_roof_jump;
	addNotetrack_customFunction( "player_rig", "ps_warl_rooffall_land", ::roof_fall_land, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "start_slomo", ::roof_fall_slowmo, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "spawn_machetteguy", ::roof_fall_badguy, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "viewmodel_on", ::roof_fall_weapon, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "rumble_small", ::anim_rumble_small, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "rumble_medium", ::anim_rumble_medium, "roof_fall" );
	addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "roof_fall" );
	level.scr_anim[ "player_legs" ][ "roof_fall" ] = %africa_pc_roof_jump_legs;
	
	level.scr_anim[ "player_rig" ][ "warlord_standoff_new" ] 		= %warlord_standoff_player_start;
	addNotetrack_customFunction( "player_rig", "kick_door", ::warlord_door_open, "warlord_standoff_new" );
	//addNotetrack_customFunction( "player_rig", "slowmo_breach", ::warlord_slowmo, "warlord_standoff_new" );
	addNotetrack_customFunction( "player_rig", "hide_legs", ::hide_player_legs, "warlord_standoff_new" );
	addNotetrack_customFunction( "player_rig", "rumble_small", ::anim_rumble_small, "warlord_standoff_new" );
	addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "warlord_standoff_new" );
	
	level.scr_anim[ "player_rig" ][ "warlord_standoff_loop" ][0] 	= %warlord_standoff_player_loop;
	level.scr_anim[ "player_rig" ][ "warlord_standoff_end" ] 		= %warlord_standoff_player_end;
	addNotetrack_customFunction( "player_rig", "rumble_large", ::anim_rumble_large, "warlord_standoff_end" );
	
	level.scr_animtree[ "player_legs" ]													= #animtree;
	level.scr_model[ "player_legs" ]														= "viewlegs_generic";
	level.scr_anim[ "player_legs" ][ "warlord_standoff_new" ]		= %warlord_standoff_player_legs_start;
}

#using_animtree( "vehicles" );
load_vehicle_anims()
{
	level.scr_animtree[ "turret" ]					 			= #animtree;
	
	level.scr_anim[ "turret" ][ "get_on_technical" ] 			= %warlord_pickup_m2_50cal_push_off;
	level.scr_anim[ "turret" ][ "technical_gunner_death" ] 		= %warlord_pickup_m2_50cal_death;
	level.scr_anim[ "turret" ][ "technical_turret_hands_idle" ]			= %warlord_pickup_player_m2_50cal_idle;
	level.scr_anim[ "turret" ][ "technical_turret_hands_fire" ]			= %warlord_pickup_player_m2_50cal_fire;
	level.scr_anim[ "turret" ][ "technical_turret_hands_idle2fire" ]	= %warlord_pickup_player_m2_50cal_idle_to_fire;
	level.scr_anim[ "turret" ][ "technical_turret_hands_fire2idle" ]	= %warlord_pickup_player_m2_50cal_fire_to_idle;
	
	level.scr_anim[ "turret" ][ "technical_turret_gun_idle" ]			= %viewmodel_pickup_m2_50cal_idle;
	level.scr_anim[ "turret" ][ "technical_turret_gun_fire" ]			= %viewmodel_pickup_m2_50cal_fire;
	level.scr_anim[ "turret" ][ "technical_turret_gun_idle2fire" ]		= %viewmodel_pickup_m2_50cal_idle_to_fire;
	level.scr_anim[ "turret" ][ "technical_turret_gun_fire2idle" ]		= %viewmodel_pickup_m2_50cal_fire_to_idle;
	
	addNotetrack_customFunction( "turret", "swap_model", ::swap_turret_model, "get_on_technical" );
	
	level.scr_animtree[ "mi17" ] = #animtree;
	level.scr_anim[ "mi17" ][ "warlord_ending" ] = %warlord_standoff_mi17;
	level.scr_anim[ "mi17" ][ "mi17_idle" ][0] = %warlord_standoff_mi17_idle;
	level.scr_anim[ "mi17" ][ "mi17_rotors" ] = %warlord_standoff_mi17_idle_rotors;
	
	level.scr_animtree[ "technical" ] = #animtree;
	level.scr_anim[ "technical" ][ "open_gate" ][0] = %africa_technical_passenger_back_idle_tailgate;
}

#using_animtree( "script_model" );
load_script_model_anims()
{
	level.scr_animtree[ "sniper_rifle" ]						= #animtree;
	level.scr_model[ "sniper_rifle" ]							= "viewmodel_m14_ebr";
	level.scr_anim[ "sniper_rifle" ][ "water_emerge" ]			= %africa_weapon_emerge_slow;
	
	level.scr_animtree[ "chair" ] 								= #animtree;
	level.scr_model[ "chair" ] 									= "com_folding_chair";
	level.scr_anim[ "chair" ][ "sleep_react" ]					= %parabolic_guard_sleeper_react_chair;
	
	level.scr_animtree[ "beretta" ]								= #animtree;
	level.scr_model[ "beretta" ]								= "viewmodel_fn_five_seven_sp_iw5";
	level.scr_anim[ "beretta" ][ "warlord_standoff_new" ]		= %warlord_standoff_beretta;
	level.scr_anim[ "beretta" ][ "warlord_standoff_end" ] 		= %warlord_standoff_beretta_end;
		
	level.scr_animtree[ "sewer_grate" ] 						= #animtree;
	level.scr_model[ "sewer_grate" ] 							= "afr_pipe_gate_01";
	level.scr_anim[ "sewer_grate" ][ "rip_sewer_grate" ]		= %africa_soap_rip_sewer_grate;
	
	level.scr_animtree[ "crowbar" ]								= #animtree;
	level.scr_model[ "crowbar" ] 								= "paris_crowbar_01";
	level.scr_anim[ "crowbar" ][ "warlord_ending" ]		 		= %warlord_standoff_crowbar;	
	
	level.scr_animtree[ "crate" ]								= #animtree;
	level.scr_model[ "crate" ]									= "afr_chem_crate_01";
	level.scr_anim[ "crate" ][ "warlord_ending" ]				= %warlord_standoff_crate;
	
	level.scr_animtree[ "turret_model" ]						= #animtree;
	level.scr_model[ "turret_model" ]							= "weapon_truck_m2_50cal_mg";
	level.scr_anim[ "turret_model" ][ "knock_off_technical" ]	= %warlord_pickup_m2_50cal_explode;
	
	level.scr_animtree[ "technical_model" ]						= #animtree;
	level.scr_model[ "technical_model" ] 						= "vehicle_pickup_technical_pb_destroyed";
	level.scr_anim[ "technical_model" ][ "knock_off_technical" ] = %warlord_pickup_technical_explode;
	
	level.scr_animtree[ "pallet" ]								= #animtree;
	level.scr_model[ "pallet" ]									= "vehicle_mi17_africa_palette";
	level.scr_anim[ "pallet" ][ "warlord_ending" ]				= %warlord_standoff_pallet;
	level.scr_anim[ "pallet" ][ "pallet_idle" ][0]		= %warlord_standoff_pallet_idle;
}

#using_animtree( "dog" );
load_dog_anims()
{
	level.scr_anim[ "dog" ][ "dog_eat" ][0] = %africa_hyena_german_shepherd_eating_b;
	level.scr_anim[ "dog" ][ "dog_growl" ] = %german_shepherd_attackidle_growl;
	
	level.scr_anim[ "dog" ][ "africa_hyena_hold" ] = %africa_hyena_hyena;
	level.scr_anim[ "dog" ][ "africa_hyena_release" ] = %africa_hyena_release_hyena;
	
	level.scr_anim[ "dog" ][ "warlord_standoff_new" ] = %warlord_standoff_hyena_start;
	level.scr_anim[ "dog" ][ "warlord_standoff_loop" ][0] = %warlord_standoff_hyena_loop;
	level.scr_anim[ "dog" ][ "warlord_standoff_end" ] = %warlord_standoff_hyena_end;
}

setup_anim_model()
{
	wait 0.05;
	
	level.sewer_grate = spawn_anim_model( "sewer_grate" );
	org_rip_sewer_grate = GetStruct( "org_rip_sewer_grate", "targetname" );
	org_rip_sewer_grate anim_first_frame_solo( level.sewer_grate, "rip_sewer_grate" );
}

swap_turret_model( turret )
{
	turret SetModel( "weapon_truck_m2_50cal_mg_viewmodel" );
}

timescale_start( ent )
{
	slowmo_setspeed_slow( 0.3 );
	slowmo_setlerptime_in( 0.2 );
	slowmo_lerp_in();
}

timescale_end( ent )
{
	slowmo_setlerptime_out( 0.3 );
	slowmo_lerp_out();
	slowmo_end();
}

start_death( ent )
{
	ent.allowdeath = true;
	ent.a.nodeath = true;
	ent.noragdoll = true;
	ent.diequietly = true;
	ent thread set_battlechatter( false );

	ent.dropWeapon = true;
	ent animscripts\shared::DropAIWeapon();
}

kill_me( ent )
{
	ent.dropWeapon = true;
	ent animscripts\shared::DropAIWeapon();
	ent thread set_battlechatter( false );
	
	// wait between dropping the weapon and killing the actor so 
	//   that the weapon drops properly (otherwise the actor will
	//   be undefined and the weapon won't detach properly).
	// I think this used to work without the wait, not sure what happened.
	wait 0.15;
	ent.allowdeath = true;
	ent.a.nodeath = true;
	ent.noragdoll = true;
	ent.diequietly = true;
	
	ent kill();
}

mortar_run_door_swing_open( ent )
{
	door = getEntarray( "mortar_door_kickin", "targetname" );
	foreach( thing in door )
	{
		thing rotateYaw( 180, 0.2, 0.1, 0.1 );
		thing connectPaths();
	}
}

animate_turret( to_hands_anim_name, hands_anim_name, to_gun_anim_name, gun_anim_name )
{
	self notify( "turret_anim_change" );
	self endon( "turret_anim_change" );
	
	to_hands_anim = self getanim( to_hands_anim_name );
	hands_anim = self getanim( hands_anim_name );
	to_gun_anim = self getanim( to_gun_anim_name );
	gun_anim = self getanim( gun_anim_name );
	
	// play transition animation
	self clearAnim( self.hands_animation, 0 );
	self clearAnim( self.gun_animation, 0 );
	self.hands_animation = to_hands_anim;
	self.gun_animation = to_gun_anim;
	self setAnim( to_gun_anim, 1, 0.1, 1 );
	self setFlaggedAnim( to_hands_anim_name, to_hands_anim, 1, 0.1, 1 );
	self waittillmatch( to_hands_anim_name, "end" );
	
	// play next state animation
	self clearAnim( to_hands_anim, 0 );
	self clearAnim( to_gun_anim, 0 );
	self.hands_animation = hands_anim;
	self.gun_animation = gun_anim;
	self setAnim( hands_anim, 1, 0.1, 1 );
	self setAnim( gun_anim, 1, 0.1, 1 );
}

burn_victim_fire( victim )
{
	victim notify( "victim_on_fire" );//do not delete this!! we need this notify to set off the animation
	flag_set( "victim_burn_vo" );
	//PlayFXOnTag( getfx( "burning_man" ), victim, "tag_origin" );
}

corner_kill_knife( ent )
{
	attach_knife( ent );
	//dust before knife stab
	wait(3.0);	
	exploder(999);
}

river_kill_knife( ent )
{
	attach_knife( ent );
	wait(0.6);
	PlayFXOnTag( getfx( "intro_knife_throat_fx" ), ent, "tag_knife_fx" );
	wait(1.2);	
	exploder(9999);
}
	
attach_knife( ent )
{
	ent.knife_attached = true;
	ent attach( "weapon_parabolic_knife", "TAG_INHAND", true );
}

detach_knife( ent )
{
	if ( IsDefined( ent.knife_attached ) && ent.knife_attached )
	{
		ent detach( "weapon_parabolic_knife", "TAG_INHAND", true );
		ent.knife_attached = undefined;
	}
}

stab_knife( ent )
{
	if ( IsDefined( ent.knife_attached ) && ent.knife_attached )
	{
		playfxontag( getfx( "knife_attack_fx" ), ent, "tag_knife_fx" );
	}
}

throat_stab_player( ent )
{
	playfxontag( getfx( "knife_attack_throat_fx" ), ent, "tag_knife_fx" );
}

throat_stab_npc( ent )
{
	start_death( ent );
	playfxontag( getfx( "knife_attack_throat_fx2" ), ent, "J_Neck" );
}

warlord_door_open( guy )
{
	warlord_door = GetEnt( "door_warlord_room", "targetname" );
	warlord_door RotateYaw( -140, 0.2, 0.1, 0.1 );
	warlord_door ConnectPaths();
}

kick_church_doors( ent )
{
	church_side_door_left = GetEnt( "church_side_door_left", "targetname" );
	church_side_door_right = GetEnt( "church_side_door_right", "targetname" );
	
	church_side_door_left RotateYaw( 180, 0.2, 0.1, 0.1 );
	church_side_door_right RotateYaw( -180, 0.2, 0.1, 0.1 );
	
	church_side_door_left ConnectPaths();
	church_side_door_right ConnectPaths();
}

soap_bash_door( ent )
{
	compound_door = GetEnt( "compound_door", "targetname" );
	compound_door RotateYaw( 110, 0.2, 0.1, 0.1 );
	compound_door ConnectPaths();
	//wait(0.0);	
	exploder(997);
}

hide_player_legs( ent )
{
	if ( IsDefined( level.player_legs ) )
	{
		level.player_legs Hide();
	}
}

warlord_slowmo( ent )
{
	slomo_duration = 3.5;
	
	level notify( "slowmo_go" );
	level endon( "slowmo_go" );

	slomoLerpTime_in = 0.5;
	slomoLerpTime_out = 0.75;
	slomobreachplayerspeed = 0.2;

	level.player thread play_sound_on_entity( "slomo_whoosh" );
	level.player thread maps\_slowmo_breach_church::player_heartbeat();

	thread maps\_slowmo_breach_church::slomo_breach_vision_change( ( slomoLerpTime_in * 2 ), ( slomoLerpTime_out / 2 ) );
	
	flag_clear( "can_save" );
	
	slowmo_setspeed_slow( 0.4 );
	slowmo_setlerptime_in( slomoLerpTime_in );
	slowmo_lerp_in();
	
	level.player SetMoveSpeedScale( slomobreachplayerspeed );

	startTime = GetTime();
	endTime = startTime + ( slomo_duration * 1000 );

	// wait for slowmo timeout, or wait for conditions to be met that will interrupt the slowmo
	while ( GetTime() < endTime )
	{
		wait( 0.05 );
	}

	level notify( "slowmo_breach_ending", slomoLerpTime_out );
	level notify( "stop_player_heartbeat" );

	level.player thread play_sound_on_entity( "slomo_whoosh" );
	slowmo_setlerptime_out( slomoLerpTime_out );
	slowmo_lerp_out();

	flag_set( "can_save" );
	
	if ( IsDefined( level.playerSpeed ) )
		level.player SetMoveSpeedScale( level.playerSpeed );
	else
		level.player SetMoveSpeedScale( 1 );
	
	setsaveddvar( "objectiveHide", false );
}

price_kick_door( ent )
{
	compound_door = GetEnt( "factory_door", "targetname" );
	compound_door RotateYaw( 110, 0.2, 0.1, 0.1 );
	compound_door ConnectPaths();
	//wait(0.0);	
	exploder(998);
}

add_warlord_smoking_notetracks( animname )
{
	if ( prop_notetrack_exist( animname, "add_warlord_smoking_notetracks" ) )
		return;

	addNotetrack_customFunction( animname, "attach cigar", 		::attach_cig );
	addNotetrack_customFunction( animname, "puff", 				::smoke_puff );
	addNotetrack_customFunction( animname, "exhale", 			::smoke_exhale );

	level._effect[ "cigar_glow" ]    	  						 = loadfx( "fire/cigar_glow_far" );
	level._effect[ "cigar_glow_puff" ] 							 = loadfx( "fire/cigar_glow_puff" );
	level._effect[ "cigar_smoke_puff" ]							 = loadfx( "smoke/cigarsmoke_puff_far" );
	level._effect[ "cigar_exhale" ]    							 = loadfx( "smoke/cigarsmoke_exhale_far" );

	level.scr_model[ "cigar" ]									 = "prop_price_cigar";
}

play_splash_1( ent )
{
 exploder(63);
}

play_splash_2( ent )
{
 exploder(62);
}

roof_fall_land( guy )
{
	roof_parts = getentarray( "mortar_roof_pieces", "script_noteworthy" );
	foreach( part in roof_parts )
	{
		curr_ang = part.angles;
		curr_org = part.origin;
		playfx(getfx("warlord_panel4x8_dest"),curr_org, anglestoforward(curr_ang));
		part delete();
	}
}

roof_fall_slowmo( guy )
{
	SetSlowMotion( 1.0, 0.80 );

	//set when guy is killed
	flag_wait( "roof_machete_guy_dead" );
	
	SetSlowMotion( 0.80, 1 );
}

roof_fall_badguy( guy )
{
	spawner = getent( "roof_machete_guy", "targetname" );
	guy = spawner spawn_ai( true );
	guy.animname = "militia";
	guy.health = 1;
	guy.allowdeath = true;
	guy set_deathanim( "africa_pc_roof_jump_attacker_death" );
	machette = spawn( "script_model", guy.origin );
	machette setmodel( "weapon_machette" );
	machette.origin = guy GetTagOrigin( "TAG_INHAND" );
	machette.angles = guy GetTagAngles( "TAG_INHAND" );
	machette linkto( guy, "TAG_INHAND" );
	machette show();
	guy gun_remove();
	org = getstruct( "org_fall_through_roof", "targetname" );
	org anim_single_solo( guy, "africa_pc_roof_jump_attacker" );
}

roof_fall_weapon( guy )
{
	level.player EnableWeapons();
	level.player EnableOffhandWeapons();
	level.player AllowSprint( true );
	level.player AllowCrouch( true );
	level.player AllowProne( true );
	level.player AllowMelee( true );
}

roof_kill_player( guy )
{
	if( isDefined( guy ) && isAlive( guy ) )
	{
		level.player kill();
	}
	guy anim_single_solo( guy, "africa_machette_idle" );
}

blood_warlord_vfx(warlord)
{
	playfxontag(getfx("warlord_chestshot_blood"), warlord, "J_SpineUpper");
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