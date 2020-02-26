#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_turret;
#include maps\_vehicle;
#include maps\_music;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

autoexec init_plaza()
{
	add_spawn_function_veh( "van_1", ::brake_van );
	
	add_spawn_function_group( "skylight_guys", "script_noteworthy", ::delete_on_goal );
	add_spawn_function_group( "skylight_leader", "targetname", ::skylight_leader );
	
	add_spawn_function_group( "plaza_grate_01", "targetname", ::plaza_grate_01 );
	add_spawn_function_group( "plaza_grate_02", "targetname", ::plaza_grate_02 );
	
	add_spawn_function_group( "plaza_balcony_rpg0", "script_noteworthy", ::init_balcony_ai );
	add_spawn_function_group( "plaza_balcony_sniper0", "script_noteworthy", ::init_balcony_ai );
	
	add_spawn_function_group( "plaza_gunner", "targetname", ::plaza_gunner );
	
	// shop cart 1
	a_prop = GetEnt( "plaza_cart_1", "targetname" );
	a_prop_links = GetEntArray( "plaza_cart_1_link", "targetname" );
	level thread cart_1_watcher();
	foreach ( m_prop_link in a_prop_links )
	{
		m_prop_link LinkTo( a_prop );
	}
	
	// shop cart 2
	a_prop = GetEnt( "plaza_cart_2", "targetname" );
	a_prop_links = GetEntArray( "plaza_cart_2_link", "targetname" );
	level thread cart_2_watcher();
	foreach ( m_prop_link in a_prop_links )
	{
		m_prop_link LinkTo( a_prop );
	}
	
	// planter
	level thread plaza_planter();
}

cart_1_watcher()
{
	scene_trigger = getent( "spawn_shopguy01", "targetname" );
	scene_trigger waittill( "trigger" );
	path_clip = getent( "cart_clip_1", "script_noteworthy" );
	path_clip ConnectPaths();
	scene_wait( "plaza_shopguy01" );
	path_clip DisconnectPaths();
}

cart_2_watcher()
{
	scene_trigger = getent( "spawn_shopguy02", "targetname" );
	scene_trigger waittill( "trigger" );	
	path_clip = getent( "cart_clip_2", "script_noteworthy" );
	path_clip ConnectPaths();
	scene_wait( "plaza_shopguy02" );
	path_clip DisconnectPaths();
}

plaza_planter()
{
	a_prop = GetEnt( "plaza_stairs_planter", "targetname" );
	m_prop_link = GetEnt( "plaza_stairs_planter_collision", "targetname" );
	m_prop_link LinkTo( a_prop );
	flag_wait( "plaza_planter_started" );
	m_prop_link ConnectPaths();
	flag_wait( "plaza_planter_done" );
	m_prop_link DisconnectPaths();
}

plaza_grate_01()
{
	self endon( "death" );
	self.deathFunction = ::ragdoll_death;
	scene_wait( "plaza_grate1" );
	level thread run_scene_and_delete( "plaza_grate1_loop" );
}

plaza_grate_02()
{
	self endon( "death" );
	self.deathFunction = ::ragdoll_death;
	scene_wait( "plaza_grate2" );
	level thread run_scene_and_delete( "plaza_grate2_loop" );
}

init_balcony_ai()
{
	self.a.disableReacquire = true;
}

plaza_gunner()
{
	flag_set( "plaza_gunner_spawned" );
		
	self waittill( "death" );
	flag_set( "plaza_gunner_dead" );
	
	level.harper priority_dialog( "harp_mg_s_down_move_up_0" );
	priority_dialog_enemy( "pmc3_we_ve_lost_the_mg_0" );
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_plaza()
{
	level.harper = init_hero( "harper" );
	level.harper.plaza_right = false;
	
	skipto_teleport( "skipto_plaza" );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	level thread maps\la_street::brute_force();
	
	trigger_use( "plaza_color_start" );
	
//	level thread press_demo_quadrotors();
	
	set_objective( level.OBJ_STREET_REGROUP );
	
	level.player.overridePlayerDamage = ::drone_player_damage_override;
}

main()
{
	load_gump( "la_1b_gump_1" );
	
	flag_set( "la_arena_start" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper = init_hero( "harper" );
		level.harper.script_ignore_suppression = 1;
	}
	
	level.harper.plaza_right = false;
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	level.player.overridePlayerDamage = ::drone_player_damage_override;
	
//	level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
//	level thread fxanim_aerial_vehicles( 23 );
	
	level thread plaza_deathposes();
	run_scene_first_frame( "plaza_bodies" );
	run_scene_first_frame( "plaza_shopguy01", true, true );
	run_scene_first_frame( "plaza_shopguy02", true, true );
	run_scene_first_frame( "plaza_planter", true, true );
	
	trigger_on( "plaza_building_fxanim" );
	
	level thread table_flips();
	
	level thread clear_behind();
	
	level thread plaza_harper_movement();
	level thread plaza_right_color_logic();
	
	level thread lockbreaker();
	
	level thread plaza_vo();
	
	level thread plaza_and_intersect_transition();
	
	//Block paths for clips associated with shopguy scenes
	wait 0.05;
	path_clip1 = getent( "cart_clip_1", "script_noteworthy" );
	path_clip1 DisconnectPaths();
	path_clip2 = getent( "cart_clip_2", "script_noteworthy" );
	path_clip2 DisconnectPaths();	

	f35_crash();
}


plaza_deathposes()
{
	run_scene_first_frame( "plazabody_02" );
	run_scene_first_frame( "plazabody_03" );
	run_scene_first_frame( "plazabody_04" );
	run_scene_first_frame( "plazabody_08" );
	run_scene_first_frame( "plazabody_10" );
	run_scene_first_frame( "plazabody_11" );
	run_scene_first_frame( "plazabody_13" );
	run_scene_first_frame( "plazabody_16" );
}


cleanup_color_plaza_right_2_inside()
{
	level endon( "intersection_started" );
	
	trigger_wait( "color_plaza_right_2_outside" );
	
	cleanup_kvp( "color_plaza_right_2_inside" );
}

cleanup_color_plaza_right_2_outside()
{
	level endon( "intersection_started" );
	
	trigger_wait( "color_plaza_right_2_inside" );
	
	cleanup_kvp( "color_plaza_right_2_outside" );
}

plaza_vo()
{
	level thread brute_force_vo();
	
	level thread plaza_vo_pmc_callouts();
	level thread plaza_vo_save_french_iav();
	
	//TUEY - shut off street music prior to the plaza event. (MOVED FOR PRESS TO QUAD ROTOR FUNC)
//	setmusicstate( "LA_1B_PLAZA");
	
//	if ( !flag( "harper_dead" ) )
//	{
//		level.harper queue_dialog( "harp_two_osprey_s_overhea_0" );
//	}
	
	//level.player queue_dialog( "ande_section_the_mercs_0" );	// Anderson
	level.player queue_dialog( "ande_we_have_enemy_aircra_0" );	// Anderson
	
	do_pip2();
	
	if ( flag( "player_has_bruteforce" ) && !flag( "brute_force_player_started" ) )
	{
		level.player queue_dialog( "our_iav_is_on_fire_003", 0, "near_bruteforce_cougar", "plaza_enter" );
	}
	
	flag_wait( "plaza_enter" );
	
	queue_dialog_enemy( "pmc3_here_they_come_0" );
	
	flag_wait( "plaza_gunner_spawned" );
	
	queue_dialog_enemy( "pmc2_get_on_the_mg_0" );	
	queue_dialog_enemy( "pmc3_open_fire_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_mg_s_got_the_entranc_0", 0, "plaza_gunner_spawned", "plaza_gunner_dead" );
		level.harper queue_dialog( "harp_those_fucking_cops_a_0", 0, undefined, array( "plaza_gunner_dead", "plaza_left_path", "plaza_right_path" ) );
		level.harper queue_dialog( "harp_find_another_way_rou_0", 0, "plaza_gunner_spawned", array( "plaza_gunner_dead", "plaza_left_path", "plaza_right_path" ) );
	}
	
	level.player queue_dialog( "sect_spread_out_open_up_0", 0, undefined, "f35_la_plaza_crash_end" );
	level.player queue_dialog( "sect_stay_on_line_0", 0, undefined, "f35_la_plaza_crash_end" );
	
	queue_dialog_enemy( "pmc3_get_the_rpgs_onto_th_0", 0, undefined, "f35_la_plaza_crash_end" );
	
	level thread priority_dialog_enemy( "pmc3_they_re_heading_into_0", 0, "plaza_right_path" );
	
	level thread left_path_vo();
	level thread middle_path_vo();
	level thread right_path_vo();
	
	flag_wait( "do_plaza_anderson_convo" );
	
	// Anderson convo
	level.player queue_dialog( "sect_anderson_the_frenc_0" );
	level.player queue_dialog( "ande_enemy_forces_are_tar_0" );	// Anderson
	level.player queue_dialog( "sect_that_s_them_hold_t_0" );
	
	queue_dialog_enemy( "pmc3_come_on_keep_push_0", 0, "f35_la_plaza_crash_start", "f35_la_plaza_crash_end" );
	
	/* FA38 crash */
	queue_dialog_enemy( "pmc2_focus_rpg_fire_on_th_0", 0, undefined, "f35_la_plaza_crash_start" );
	queue_dialog_enemy( "pmc1_bring_them_down_0", 0, undefined, "f35_la_plaza_crash_start" );
	
	flag_wait( "f35_la_plaza_crash_start" );
	
	queue_dialog_enemy( "pmc1_direct_hit_it_s_co_0", 0, "f35_la_plaza_crash_start", "f35_la_plaza_crash_end" );
	
	flag_wait( "f35_la_plaza_crash_end" );
	
	level thread autosave_by_name( "f35_plaza_crash" );
	
	level notify( "continue_path" );
	
	level.player queue_dialog( "ande_dammit_section_the_0", 0, "f35_la_plaza_crash_start" ); // Anderson
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "harp_nothing_we_can_do_0", 0, "f35_la_plaza_crash_start" );
	}
	/* !FA38 crash */
	
	queue_dialog_enemy( "pmc3_come_on_keep_push_0" );
	queue_dialog_enemy( "pmc3_get_on_them_0" );
	
	level.player queue_dialog( "ande_dammit_section_the_1" );
	level.player queue_dialog( "ande_i_can_t_hold_them_of_0" );
	level.player queue_dialog( "ande_they_re_dead_if_you_0" );
	
	flag_set( "plaza_vo_done" );
}

left_path_vo()
{
	flag_wait( "plaza_left_path" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_1st_floor_left_side_0", 0, array( "plaza_left_path" ), "player_reached_escalator" );
		level.harper queue_dialog( "harp_2nd_floor_by_the_es_0", 0, array( "plaza_left_path", "enemies_by_the_escalator" ), array( "plaza_top_of_stairs_cleared" ) );
	}
	
	flag_wait( "player_reached_top_of_escalator" );
	
	level.player queue_dialog( "ande_i_see_a_sam_turret_o_0", 0, array( "plaza_left_path" ) );
	level.player queue_dialog( "sect_i_ll_do_what_i_can_0", 0, array( "lockbreaker_started" ), "plaza_left_side_middle" );
	
	flag_set( "do_plaza_anderson_convo" );
	level waittill( "continue_path" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_sniper_dead_ahead_0", 0, array( "plaza_left_path", "plaza_end_balcony_sniper_spawning"), "plaza_end_balcony_sniper_cleared" );
		wait 1;
		level.harper queue_dialog( "harp_opposite_balcony_0", 0, array( "plaza_left_path", "plaza_end_balcony_rpg_spawning" ), "plaza_end_balcony_rpg_cleared" );
	}
}

middle_path_vo()
{
	level endon( "plaza_left_path" );
	level endon( "plaza_right_path" );
	level endon( "plaza_middle_right_path" );
	
	flag_wait( "f35_la_plaza_crash_start" );
	
	flag_set( "do_plaza_anderson_convo" );
	level waittill( "continue_path" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_rpg_right_side_hig_0", 0, "plaza_end_balcony_rpg_spawning", "plaza_end_balcony_rpg_cleared" );
		wait 1;
		level.harper queue_dialog( "harp_sniper_2nd_floor_0", 0, "plaza_end_balcony_sniper_spawning", "plaza_end_balcony_sniper_cleared" );
	}
}

right_path_vo()
{
	flag_wait_either( "plaza_right_path", "plaza_middle_right_path" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_1st_floor_right_sid_0", 0 );
	}
	
	flag_set( "do_plaza_anderson_convo" );
	level waittill( "continue_path" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_rpg_right_side_hig_0", 0, "plaza_end_balcony_rpg_spawning", "plaza_end_balcony_rpg_cleared" );
		wait 1;
		level.harper queue_dialog( "harp_sniper_2nd_floor_0", 0, "plaza_end_balcony_sniper_spawning", "plaza_end_balcony_sniper_cleared" );
	}
}

plaza_vo_pmc_callouts()
{
	a_intro_vo = array( "pmc3_they_re_still_fighti_0", "pmc2_get_on_the_mg_0", "pmc3_open_fire_0" );
	vo_callouts_intro( undefined, "axis", a_intro_vo );
	
	a_vo_callouts = [];

	a_vo_callouts[ "mall_2nd_floor_int" ] 	= array( "pmc1_second_floor_mall_0" );
	a_vo_callouts[ "mall_2nd_floor_ext" ]	= array( "pmc0_they_re_on_the_balco_0" );
	a_vo_callouts[ "mall_stairs" ]			= array( "pmc3_targets_on_the_stair_0" );
	a_vo_callouts[ "generic" ]				= array( "pmc3_get_on_them_0", "pmc1_bring_them_down_0", "pmc3_fall_back_to_the_are_0", "pmc1_here_they_come_1", "pmc3_here_they_come_0", 
	                                      				"pmc3_open_fire_0" );
	
	level thread vo_callouts( undefined, "axis", a_vo_callouts, "intersection_started", "rooftop_sam_in", 4.0, 10.0 );
}

plaza_vo_save_french_iav()
{
	level endon( "intersect_vip_cougar_saved" );
	level endon( "intersect_vip_cougar_died" );
	
	a_help_vo 		= array( "were_taking_heavy_008", "we_need_immediate_009", "we_cant_hold_out_003", "theyre_all_over_u_004", "where_the_hell_is_005" );
	a_respond_vo 	= array( "were_on_our_way_002", "on_our_way_004" );
	
	while ( true )
	{
		wait RandomIntRange( 15, 25 );
		level.player queue_dialog( a_help_vo[ RandomInt( a_help_vo.size ) ] );
		if ( RandomInt( 4 ) == 0 )
		{
			level.player queue_dialog( a_respond_vo[ RandomInt( a_respond_vo.size ) ] );
		}
	}
}

do_pip2()
{
	flag_wait( "bdog_front_dead" );
	flag_wait( "bdog_back_dead" );
	
//	wait 1;
	
	waittill_dialog_queue_finished();
	
	flag_set( "pip_playing" );	
	pause_dialog_queue();
	
	thread maps\_glasses::play_bink_on_hud( "la_pip_seq_2", !BINK_IS_LOOPING, !BINK_IN_MEMORY );//Streamed bink
	flag_wait( "glasses_bink_playing" );
	
	level.player priority_dialog( "samu_we_re_northbound_on_0" );	// Sam
	level.player priority_dialog( "pres_if_we_lose_any_more_0" );	// President
	level.player priority_dialog( "sect_understood_section_0" );
	
	flag_clear( "pip_playing" );
}

brute_force_vo()
{
	level endon( "brute_force_fail" );
	flag_wait( "brute_force_ssa_1_started" );
	
	flag_waitopen( "pip_playing" );
		
	ai_ss = get_ais_from_scene( "brute_force_ssa_1", "ssa_1_brute_force" );
	
	ai_ss priority_dialog( "ssa4_thank_god_0" );
	level.player priority_dialog( "grab_a_rifle_h_we_006" );
}

table_flips()
{
	run_scene_first_frame( "plaza_table_flip_01", true );
	run_scene_first_frame( "plaza_table_flip_02", true );
	
	flag_wait( "run_scene_plaza_table_flip" );
	
	level thread run_scene_and_delete( "plaza_table_flip_01" );
	level thread run_scene_and_delete( "plaza_table_flip_02" );
}

/* ------------------------------------------------------------------------------------------
RANDOM PLAZA SCRIPTS
-------------------------------------------------------------------------------------------*/
clear_behind()
{
	const n_min_dist_behind = 512;
	
	level endon( "plaza_decision_made" );
	
	// clear the enemies that are behind the player
	while ( true )
	{
		a_friendlies = GetAIArray( "allies" );
		a_enemies = GetAIArray( "axis" );

		foreach ( ai_enemy in a_enemies )
		{
			// wait one frame at the beginning of each enemy so we're only running this for one enemy per frame.
			wait_network_frame();
			
			// if the enemy doesn't exist or is dead, ignore him.
			if ( !IsDefined( ai_enemy ) || !IsAlive( ai_enemy ) )
			{
				continue;
			}
			
			// bigdogs should be ignored--force the player to fight them.
			if ( IS_TRUE( ai_enemy.isbigdog ) )
			{
				continue;
			}
			
			// Enemies less than n_min_dist_behind behind the player should be ignored.
			if ( ( level.player.origin[1] - ai_enemy.origin[1] ) < n_min_dist_behind )
			{
				continue;
			}
			
			// find the nearest friendly.
			a_nearest_friendly = SpawnStruct();
			
			// this value will define how close they have to be to the friendly by minimum.
			a_nearest_friendly.dist_sq = 512 * 512;
			
			foreach ( ai_friendly in a_friendlies )
			{
				// if the friendly doesn't exist or is dead, pick someone else.
				if ( !IsDefined( ai_friendly ) || !IsAlive( ai_friendly ) )
				{
					continue;
				}
				
				// too far from previous best friendly.  move along.
				n_dist_sq = LengthSquared( ai_enemy.origin - ai_friendly.origin );
				if ( n_dist_sq > a_nearest_friendly.dist_sq )
				{
					continue;
				}
				
				a_nearest_friendly.ai_friendly = ai_friendly;
				a_nearest_friendly.dist_squared = n_dist_sq;
			}
			
			// we found a suitable friendly to kill this suitable enemy.
			if ( IsDefined(a_nearest_friendly.ai_friendly) )
			{
				// basically the enemy that is behind the player and closest to this friendly
				a_nearest_friendly.ai_friendly shoot_at_target_perfect_aim( ai_enemy );
			}
			else		// no suitable friendly was found to kill this guy.
			{
				// if the enemy is not in range and the player is not looking, kill it
				if ( !( level.player is_player_looking_at( ai_enemy.origin, 0 ) ) )
				{
					ai_enemy bloody_death();
				}
			}
		}
		
		// wait before moving onto the next loop through everyone.
		wait_network_frame();
	}
}

// self == friendly AI
shoot_at_target_perfect_aim( ai_target )
{
	self endon( "death" );
	
	self.perfectaim = 1;
	
	self shoot_at_target( ai_target );
		
	self.perfectaim = 0;
}

// self == van
brake_van()
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::van_damage_override;
	
	self waittill( "brake" );
	
	while ( self GetSpeedMPH() > 0 )
	{
		wait 0.05;
	}
	
	self notify( "unload" ); // notify the van to unload passengers
	
	level notify( self.targetname + "_unload" );
}

// self == van
van_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( str_means_of_death == "MOD_PROJECTILE_SPLASH" || str_means_of_death == "MOD_PROJECTILE" )
	{
		n_damage = self.health;
	}
	
	return n_damage;
}

/* ------------------------------------------------------------------------------------------
AI RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
// self == enemy AI with RPG
plaza_rpg()
{
	self endon( "death" );
	
	self.a.allow_weapon_switch = false;
	self force_goal( undefined, 16 );
	self.goalradius = 16;
}

plaza_harper_movement()
{
	level thread plaza_harper_movement_left();
	level thread plaza_harper_movement_right();
	level thread plaza_harper_movement_center();
}

plaza_harper_movement_center()
{
	level endon( "intersection_started" );
	
	trigger_wait( "sm_plaza_center_3" );
	
	trigger_use( "intersection_start" );
}

plaza_harper_movement_left()
{
	level endon( "delete_plaza_left_color" );
	
	trigger_wait( "color_plaza_left_0" );
	
	level notify( "delete_plaza_right_color" );
	
	a_plaza_right_color = GetEntArray( "plaza_right_color", "script_noteworthy" );
	foreach( t_plaza_right_color in a_plaza_right_color )
	{
		t_plaza_right_color Delete();
	}
	
	level.harper.plaza_right = false;
}

plaza_harper_movement_right()
{
	level endon( "delete_plaza_right_color" );
	
	trigger_wait( "sm_plaza_right_0" );
	
	level notify( "delete_plaza_left_color" );
	
	a_plaza_left_color = GetEntArray( "plaza_left_color", "script_noteworthy" );
	foreach( t_plaza_left_color in a_plaza_left_color )
	{
		t_plaza_left_color Delete();
	}
	
	level.harper.plaza_right = true;
}

plaza_right_color_logic()
{
	level thread plaza_right_color_1_inside();
	level thread plaza_right_color_1_outside();
	level thread cleanup_color_plaza_right_2_inside();
	level thread cleanup_color_plaza_right_2_outside();
}

plaza_right_color_1_inside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_1" );
	
	trigger_wait( "color_plaza_right_1_inside" );
	
	cleanup_kvp( "color_plaza_right_1_outside", "targetname" );
	cleanup_kvp( "color_plaza_right_0_inside", "targetname" );
	
	level notify( "plaza_right_color_1" );
}

plaza_right_color_1_outside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_1" );
	
	trigger_wait( "color_plaza_right_1_outside" );
	
	cleanup_kvp( "color_plaza_right_1_inside", "targetname" );
	cleanup_kvp( "color_plaza_right_0_inside", "targetname" );
	
	level notify( "plaza_right_color_1" );
}

// self == enemy from center/front van
force_goal_after_unload()
{
	self endon( "death" );
	
	self force_goal( undefined, 16, true );
}

/* ------------------------------------------------------------------------------------------
F35 CRASH RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/

f35_crash()
{
	m_clip = GetEnt( "plaza_f38_clip", "targetname" );
	m_clip ConnectPaths();
	m_clip NotSolid();
	
	trig = trigger_wait( "t_f35_crash" );
	
	level thread f35_crash_sound();	
	
	Assert( IsDefined( level.harper.plaza_right ) );
	if ( IS_TRUE( level.harper.plaza_right ) )
	{
		//trigger_use( "color_plaza_right_3" );
		
		level notify( "plaza_right_color_2" );
		
//		cleanup_kvp( "color_plaza_right_2_outside" );
//		cleanup_kvp( "color_plaza_right_2_inside" );
		
//		level.harper thread force_goal( undefined, 16, true );
	}
	
	flag_set( "f35_la_plaza_crash_start" );
	
	wait 3.5;
	
	m_clip Solid();
	m_clip DisconnectPaths();
	
	if ( level.player IsTouching( m_clip ) )
	{
		level.player Suicide();
	}
	
	flag_set( "f35_la_plaza_crash_end" );
}

f35_crash_fx( m_f35 )
{
	run_scene_first_frame( "f35_crash_pilot" );
	
	m_f35 play_fx( "f35_exhaust_hover_front", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_left" );
	m_f35 play_fx( "f35_exhaust_hover_front", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_right" );
	m_f35 play_fx( "f35_exhaust_hover_rear", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_left_rear" );
	m_f35 play_fx( "f35_exhaust_hover_rear", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_right_rear" );
	
	level waittill( "f35_tower_02_start" );
	
	m_f35 notify( "stop_fx" );
	
	level clientnotify( "f35_crash_done" );
}

f35_crash_sound()
{
	temp_ent = spawn( "script_origin", (12331, -440, 657) );
	temp_ent playsound( "blk_f35_crash_incomming");
	wait (2);
	clientnotify( "snd_f35_crash" );
	level.player playsound("blk_f35_crash_impact");
	temp_ent delete();
}

// self == f35 collision/trigger box
kill_player_if_run_over( str_scene_name )
{
	level endon( str_scene_name + "_done" );
		
	while ( !level.player IsTouching( self ) )
	{
		wait 0.05;
	}
	
	level.player Suicide();
}

cleanup_street()
{
	// This is ugly, but we need to unlink stuff before the gump is unloaded
	// or we'll get a fatal code assert
	
	a_fxanim_models = GetEntArray( "fxanim", "script_noteworthy" );
	foreach ( ent in a_fxanim_models )
	{
		e_linked = ent GetLinkedEnt();
		if ( IsDefined( e_linked ) && IS_EQUAL( e_linked.model, "fxanim_la_apartment_mod" ) )
		{
			ent Unlink();
		}
	}
}

plaza_and_intersect_transition()
{
	flag_wait( "intersection_started" );
	
	cleanup_street();
	
	level notify( "plaza_decision_made" );
	
	level notify( "plaza_end" );
	
	cleanup_kvp( "sm_plaza_left_0" );
	cleanup_kvp( "sm_plaza_left_1" );
	cleanup_kvp( "sm_plaza_left_2" );
	cleanup_kvp( "sm_plaza_left_3" );
	cleanup_kvp( "sm_plaza_left_4" );
	cleanup_kvp( "sm_plaza_left_5" );
	cleanup_kvp( "sm_plaza_right_0" );
	cleanup_kvp( "sm_plaza_right_1" );
	cleanup_kvp( "sm_plaza_right_2" );
	cleanup_kvp( "sm_plaza_right_3" );
	cleanup_kvp( "sm_plaza_center_2" );
	cleanup_kvp( "sm_plaza_center_3" );
	cleanup_kvp( "plaza_stairs_left" );
	cleanup_kvp( "color_plaza_right_0_inside" );
	cleanup_kvp( "color_plaza_right_2_inside" );
	cleanup_kvp( "color_plaza_right_1_outside" );
	cleanup_kvp( "color_plaza_left_1" );
	cleanup_kvp( "color_plaza_left_2" );
	cleanup_kvp( "color_plaza_left_3" );
	cleanup_kvp( "color_plaza_left_4" );
	cleanup_kvp( "color_plaza_left_5" );
	
	cleanup_kvp( "color_plaza_right_1_inside" );
	cleanup_kvp( "color_plaza_right_2_outside" );
	
	a_friendlies = GetAIArray( "allies" );
	foreach ( ai_friendly in a_friendlies )
	{
		ai_friendly change_movemode("cqb");
		ai_friendly.perfectaim = 1;
	}
	
	a_friendlies = GetAIArray( "allies" );
	foreach ( ai_friendly in a_friendlies )
	{
		ai_friendly enable_ai_color();
		ai_friendly reset_movemode();
		ai_friendly.perfectaim = 0;
		ai_friendly thread force_goal( undefined, 16, true );
	}
}

/* ------------------------------------------------------------------------------------------
INTRUDER RELATED SCRIPTS
-------------------------------------------------------------------------------------------*/
lockbreaker()
{
	level.player waittill_player_has_lock_breaker_perk();
	
	m_lock = GetEnt( "lockbreaker_position", "targetname" );
	set_objective( level.OBJ_LOCK_PERK, m_lock.origin, "interact" );
	
	trigger_wait( "lockbreaker_use" );
	
	set_objective( level.OBJ_LOCK_PERK, undefined, "remove" );
	
	run_scene( "lockbreaker" );

	level thread intruder_sam();
}

lockbreaker_planted( m_player )	// notetrack = "planted"
{
}

lockbreaker_door_open( m_player ) // notetrack = "door_open"
{
	m_intruder_gate = GetEnt( "lockbreaker_gate", "targetname" );
	m_intruder_gate MoveZ( 94, 5 );
}

intruder_sam()
{
	level.b_sam_success = false;
	level.player thread sam_visionset();
	
	trigger_wait( "near_intruder_sam" );
	
	//level thread autosave_by_name( "intruder_sam_start" );
	level.player.ignoreme = true;
	
	level thread fxanim_drones();
	level thread intruder_sam_timer();
	
	if ( maps\_fire_direction::is_fire_direction_active() )
	{
		level.player maps\_fire_direction::_fire_direction_disable();
	}
	
	run_scene( "sam_in" );
	flag_set( "rooftop_sam_in" );
	
	level.player thread magic_bullet_shield();
	
	level.vehicleJoltTime = GetDvarFloat( "g_vehicleJoltTime" );
	level.vehicleJoltWaves = GetDvarFloat( "g_vehicleJoltWaves" );
	level.vehicleJoltIntensity = GetDvarFloat( "g_vehicleJoltIntensity" );

	SetSavedDvar( "g_vehicleJoltTime", 2 );
	SetSavedDvar( "g_vehicleJoltWaves", 1 );
	SetSavedDvar( "g_vehicleJoltIntensity", 8 );
	
	vh_sam = GetEnt( "intruder_sam", "targetname" );
	vh_sam UseVehicle( level.player, 2 );
	vh_sam thread intruder_sam_death();
	vh_sam.overrideVehicleDamage = ::sam_damage_override;
	vh_sam hide_sam_turret();
	vh_sam thread maps\_vehicle_death::vehicle_damage_filter( undefined, 5, 1 );
	
	level.player thread sam_cougar_player_damage_watcher();

	SetDvar( "aim_assist_script_disable", 0 );
	level.player.old_aim_assist_min_target_distance = GetDvarInt( "aim_assist_min_target_distance" );
    level.player SetClientDvar( "aim_assist_min_target_distance", 100000 );   // default is  10000
    
    level thread drone_sam_attack();
	
	level waittill( "intruder_sam_end" );
	
	level.player thread stop_magic_bullet_shield();
	flag_clear( "rooftop_sam_in" );
	
	if ( vh_sam.health > 0 )
	{
		vh_sam UseBy( level.player );
	}
	
	vh_sam show_sam_turret();

	SetSavedDvar( "g_vehicleJoltTime", level.vehicleJoltTime );
	SetSavedDvar( "g_vehicleJoltWaves", level.vehicleJoltWaves );
	SetSavedDvar( "g_vehicleJoltIntensity", level.vehicleJoltIntensity );
	
	if ( level.b_sam_success )
	{
		run_scene( "sam_out" );
	}
	else
	{
		vh_sam DoDamage( 10000, vh_sam.origin, undefined, undefined, "explosive" );
		run_scene( "sam_thrown_out" );
	}
	
	level thread plaza_vo_pmc_callouts();	// restart VO callouts
//	IPrintLnBold( "SCORE: " + level.drone_sam_attack_score );
	
	level.player SetClientDvar( "aim_assist_min_target_distance", level.player.old_aim_assist_min_target_distance );
	
	//level thread autosave_by_name( "intruder_sam_end" );
	level.player.ignoreme = false;
	
	if ( maps\_fire_direction::is_fire_direction_active() )
	{
		level.player maps\_fire_direction::_fire_direction_enable();	
	}
}

#define NUM_DRONE_WAVES 15

drone_sam_attack()
{
	level endon( "intruder_sam_end" );
	
	n_count = 6;
	
	angle_offsets = [];
	
	// RandomIntRange(0, 2) == 0 Left, RandomIntRange(0, 2) == 1 Right
	// RandomIntRange(60, 90) is in the front 180 degrees, but makes sure they spawn right out of the players view
	
	n_first_right_or_left = RandomIntRange(0, 2);
	
	angle_offset[0] = RandomIntRange(90, 100) + ( n_first_right_or_left * 170 );
	
	angle_offset[1] = 180; //RandomIntRange(90, 100) + ( ( n_first_right_or_left - 1 ) * -170 );
	
	angle_offset[2] = 180; //RandomIntRange(90, 100) + ( RandomIntRange(0, 2) * 170 );
	
	level.vehicleJoltTime = GetDvarFloat( "g_vehicleJoltTime" );
	level.vehicleJoltWaves = GetDvarFloat( "g_vehicleJoltWaves" );
	level.vehicleJoltIntensity = GetDvarFloat( "g_vehicleJoltIntensity" );

	SetSavedDvar( "g_vehicleJoltTime", 2 );
	SetSavedDvar( "g_vehicleJoltWaves", 1 );
	SetSavedDvar( "g_vehicleJoltIntensity", 8 );
	
	level.drone_sam_attack_score = 0;
	
	level thread update_drone_sam_attack_score();
	
	for ( i = 1; i <= NUM_DRONE_WAVES; i++ )
	{
		level.n_drone_wave = i;
		
		count = n_count + ( i - 1 );
		a_drones = spawn_sam_drone_group( "avenger_fast", count, 180 );
		array_thread( a_drones, ::intruder_sam_drone_end );
		array_thread( a_drones, ::intruder_sam_drone_score_watcher );
		
//		if ( angle_offset[ i - 1 ] <= 180 )
//		{
//			level notify( "sam_drones_left" );
//		}
//		else
//		{
//			level notify( "sam_drones_right" );
//		}
		
		level notify( "drones_spawned" );
		
		array_wait( a_drones, "death" );
		
		if ( level.n_drone_wave == NUM_DRONE_WAVES - 1 )
		{
			flag_set( "start_sam_end_vo" );
		}
		
		level notify( "good_shot" );		
	}
	
	foreach ( vh_drone in a_drones )
	{
		if ( IsDefined( vh_drone.deathmodel_pieces ) )
		{
			array_delete( vh_drone.deathmodel_pieces );
		}
	}
	
	SetSavedDvar( "g_vehicleJoltTime", level.vehicleJoltTime );
	SetSavedDvar( "g_vehicleJoltWaves", level.vehicleJoltWaves );
	SetSavedDvar( "g_vehicleJoltIntensity", level.vehicleJoltIntensity );
}

update_drone_sam_attack_score()
{
	level endon( "intruder_sam_end" );
	
	while ( 1 )
	{
		wait( 10 );
		level.drone_sam_attack_score += 1000;
		//IPrintLn( "Survival: +" + 1000 );
	}
}


fxanim_drones()
{
	a_fxanim_drones = GetEntArray( "fxanim_ambient_drone", "targetname" );
	
	level.is_player_in_sam = true;
	
	foreach ( m_drone in a_fxanim_drones )
	{
		m_drone Delete();
		level.n_av_models--;
	}
	
	level waittill( "intruder_sam_end" );
	
	level.is_player_in_sam = false;
}

intruder_sam_timer()
{
	level endon( "intruder_sam_end" );
	
	n_time = 2 * 60; // 2 minutes
	
	wait n_time;
	
	level.b_sam_success = true;
	level notify( "intruder_sam_end" );
}

// self == intruder sam
intruder_sam_death()
{
	level endon( "intruder_sam_end" );
	
	self waittill( "death" );
	
	level.b_sam_success = false;
	level notify( "intruder_sam_end" );
}

intruder_sam_drone_end()
{
	self endon( "death" );
	
	level waittill( "intruder_sam_end" );
	VEHICLE_DELETE( self );
}

#define DRONE_SCORE_MAX 5000
#define DRONE_SCORE_MIN 500
#define DRONE_SCORE_TIME 10
intruder_sam_drone_score_watcher()
{
	level endon( "intruder_sam_end" );
	
	self.n_birth_time = GetTime();
	self waittill( "death" );
	
	time = GetTime();
	
	delta = ( time - self.n_birth_time ) / 1000;
	t = delta / DRONE_SCORE_TIME;
	t = Clamp( t, 0.0, 1.0 );
	t = 1.0 - t;
	
	score = Int( LerpFloat( DRONE_SCORE_MIN, DRONE_SCORE_MAX, t ) ) * level.n_drone_wave;
	
	level.drone_sam_attack_score += score;
	
	//Print3d( self.origin, "KILL: +" + score, ( 1, 1, 1 ), 1, 10, 20 );
	level notify( "rooftop_drone_killed" ); 	// used for drone kill challenge
//	iprintlnbold( "+" + score );	
}

sam_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( n_damage < 11 )
	{
		level.player DoDamage( 1, e_attacker.origin );
	}
	
	return n_damage * 3;
}

hide_sam_turret()
{
	level.player hide_hud();
	self HidePart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self HidePart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
}

show_sam_turret()
{
	level.player show_hud();
	self ShowPart( "tag_gunner_turret2", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_canopy", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_stick_base", "veh_t6_mil_cougar_turret_sam" );
	self ShowPart( "tag_screen", "veh_t6_mil_cougar_turret_sam" );
}

skylight_leader()
{
	scene_wait( "skylight_leader" );
	self SetGoalNode( GetNode( self.target, "targetname" ) );
	self waittill( "goal" );
	self Delete();
}
