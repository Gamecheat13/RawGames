#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;

#insert raw\common_scripts\utility.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_plaza()
{
	init_hero( "harper" );
	start_teleport( "skipto_plaza" );
		
	level thread plaza_brute_force();
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	trigger_use( "plaza_color_start" );
//	trigger_use( "obj_plaza_start" );
	
	a_intersection_ssa = GetEntArray( "intersect_ssa", "targetname" );
	array_thread( a_intersection_ssa, ::add_spawn_function, ::magic_bullet_shield_and_force_goal );
	//simple_spawn( "intersect_ssa" ); // this is only for testing intersection
	
	set_objective( level.OBJ_STREET_REGROUP );
}

main()
{		
	init_hero( "harper" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper.script_ignore_suppression = 1;
	//ai_harper.script_sprint = 1;
	
	level.str_volume_current = "intersect_volume_0";
	
	plaza_spawn_objects();
	
	add_spawn_function_veh( "left_van", ::brake_van, "brake" );
	add_spawn_function_veh( "van_1", ::brake_van, "brake" );
	add_spawn_function_veh( "right_van", ::brake_van, "brake" );
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );	
	level thread fxanim_aerial_vehicles( 23 );
	
	level thread event_6_objectives();
	level thread clear_behind();
	level thread plaza_timer();
	
	level thread plaza_center_ais();
	level thread plaza_left_ais();
	level thread plaza_right_ais();
	level thread plaza_harper_movement();
	level thread plaza_right_color_logic();
	level thread plaza_spawn_manager();
	level thread intersection_ais();
	
	level thread intruder();
	
	//move_president_cougar();
	
	f35_crash();
	
	interception_animations();
	
	//wait 5;
	
	flag_wait( "event_6_done" );
}

event_6_objectives()
{
	level thread plaza_obj_dialog();
	
	level notify( "plaza_obj_ready" );
	objective_breadcrumb( level.OBJ_PLAZA, "obj_plaza_start" );
	set_objective( level.OBJ_PLAZA, undefined, "remove" );
	
	s_vip_cougar_obj = getstruct( "vip_cougar_obj", "targetname" );
	set_objective( level.OBJ_PLAZA, s_vip_cougar_obj, "protect" );
}

plaza_obj_dialog()
{
	ai_harper = GetEnt( "harper_ai", "targetname" );
	
	level.player say_dialog( "this_is_agent_jaco_007" );
	level.player say_dialog( "were_taking_heavy_008" );
	level.player say_dialog( "we_need_immediate_009" );
	ai_harper say_dialog( "theyre_dead_in_th_002" );
	level.player say_dialog( "were_on_our_way_002" );
	
	flag_set( "brute_force_vo_can_play" );
}

plaza_spawn_objects()
{
	vh_vip_cougar = spawn_vehicle_from_targetname( "intersect_vip_cougar" );
	vh_vip_cougar.overrideVehicleDamage = ::cougar_damage_override;
	vh_vip_cougar thread vip_cougar_died();
	
	s_ammo_crate = getstruct( "ammo_crate", "targetname" );
	m_ammo_crate = spawn( "script_model", s_ammo_crate.origin );
	m_ammo_crate SetModel( "p_jun_vc_ammo_crate" );
	m_ammo_crate.angles = s_ammo_crate.angles;
	m_ammo_crate.targetname = "weapon_crate";
	
	s_ammo_crate_open = getstruct( "ammo_crate_open", "targetname" );
	m_ammo_crate_open = spawn( "script_model", s_ammo_crate_open.origin );
	m_ammo_crate_open SetModel( "p_jun_vc_ammo_crate_open_single" );
	//m_ammo_crate_open.angles = m_ammo_crate_open.angles;
	m_ammo_crate_open.angles = (0, 30, 0);
	m_ammo_crate_open.targetname = "weapon_crate";
}

vip_cougar_died()
{
	self waittill( "death" );
	
	flag_set( "intersect_vip_cougar_died" );
	
	//IPrintLnBold( "vip cougar died" );
	
	set_objective( level.OBJ_PLAZA, undefined, "delete" );
	
	a_intersect_ssa = GetEntArray( "intersect_ssa_ai", "targetname" );
	foreach ( ai_ssa in a_intersect_ssa )
	{
		if ( ai_ssa.script_noteworthy == "intersect_ssa_0" || ai_ssa.script_noteworthy == "intersect_ssa_2" )
		{
			ai_ssa stop_magic_bullet_shield();
		}
	}
	
	n_cougar_origin = self.origin;
	self RadiusDamage(self.origin, 512, 512, 512, undefined, "MOD_EXPLOSIVE");
	
	foreach ( ai_ssa in a_intersect_ssa )
	{
		if ( ai_ssa.script_noteworthy == "intersect_ssa_0" || ai_ssa.script_noteworthy == "intersect_ssa_2" )
		{
			ai_ssa DoDamage( ai_ssa.health, n_cougar_origin );
		}
	}
	
	a_intersect_rpgs = GetEntArray( "intersect_rpg", "targetname" );
	a_weapon_crates = GetEntArray( "weapon_crate", "targetname" );
	a_things_to_delete = array_merge( a_weapon_crates, a_intersect_rpgs );
	foreach ( m_need_to_delete in a_things_to_delete )
	{
		m_need_to_delete Delete();
	}
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
//	ai_harper say_dialog( "intersect_fail" );
	ai_harper say_dialog( "were_too_late_se_008" );
}

plaza_timer()
{
	level endon( "plaza_decision_made" );
	
	level.is_plaza_successful = true;
	level.n_strikes = 0;
	n_violations_max = 10;
	ai_harper = GetEnt( "harper_ai", "targetname" );
	
	wait_for_either_trigger( "color_plaza_left_0", "t_plaza_right_hedge" );
	
	//IPrintLnBold( "start" );
	
	plaza_player_violation( n_violations_max );
	
	level.n_strikes++;
	//IPrintLnBold( "strike " + level.n_strikes );
//	level.player say_dialog( "plaza_strike_1_ssa" );
//	ai_harper thread say_dialog( "plaza_strike_1_harper" );
	level.player say_dialog( "where_the_hell_is_005" );
	
	plaza_player_violation( n_violations_max );
	
	level.n_strikes++;
	//IPrintLnBold( "strike " + level.n_strikes );
//	level.player say_dialog( "plaza_strike_2_ssa" );
//	ai_harper thread say_dialog( "plaza_strike_2_harper" );
	level.player say_dialog( "theyre_all_over_u_004" );
	
	plaza_player_violation( n_violations_max );
	
	level.n_strikes++;
	//IPrintLnBold( "strike " + level.n_strikes );
	//IPrintLnBold( "fail" );
//	level.player say_dialog( "plaza_strike_3_ssa" );
//	ai_harper thread say_dialog( "plaza_strike_3_harper" );
	level.player say_dialog( "we_cant_hold_out_003" );
}

plaza_player_violation( n_violations_max )
{
	level endon( "plaza_decision_made" );
	
	v_player_org_prev = level.player.origin;
	n_violations_per_strike = 0;
	while ( n_violations_per_strike <= n_violations_max )
	{
		wait 1;
		
		v_player_org_cur = level.player.origin;
		v_player_prev_x_min = v_player_org_prev + ( -64, 0, 0 );
		v_player_prev_x_max = v_player_org_prev + ( 64, 0, 0 );
		v_player_prev_y_min = v_player_org_prev + ( 0, -64, 0 );
		v_player_prev_y_max = v_player_org_prev + ( 0, 64, 0 );
		v_player_prev_z_min = v_player_org_prev + ( 0, 0, -64 );
		v_player_prev_z_max = v_player_org_prev + ( 0, 0, 64 );
		
		if( (v_player_org_cur[0] > v_player_prev_x_min[0]) && (v_player_org_cur[0] < v_player_prev_x_max[0])
		 && (v_player_org_cur[1] > v_player_prev_y_min[1]) && (v_player_org_cur[1] < v_player_prev_y_max[1])
		 && (v_player_org_cur[2]> v_player_prev_z_min[2]) && (v_player_org_cur[2] < v_player_prev_z_max[2]) )
		{
			n_violations_per_strike++;
			//IPrintLnBold( n_violations_per_strike );
		}
		
		v_player_org_prev = v_player_org_cur;
	}
}

brake_van( str_script_noteworthy )
{
	self endon( "death" );
	
	self.overrideVehicleDamage = ::van_damage_override;
	
//	if ( self.targetname == "van_1" )
//	{
//		//self thread left_van_based_on_van_death();
//	}
	
	self waittill( str_script_noteworthy );
	
	self SetSpeed( 0, 60, 60 );
	
	wait 1;
	
	//IPrintLnBold( self.velocity );
	
	self notify( "unload" ); // notify the van to unload passengers
	
	level notify( self.targetname + "_unload" );
}

cougar_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( str_means_of_death != "MOD_PROJECTILE_SPLASH" && str_means_of_death != "MOD_PROJECTILE" )
	{
		n_damage = 0;
	}
	else
	{
		level.b_intersect_cougar = false;
	}
	
	return n_damage;
}

van_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( str_means_of_death == "MOD_PROJECTILE_SPLASH" || str_means_of_death == "MOD_PROJECTILE" )
	{
		n_damage = self.health;
	}
	
	return n_damage;
}

should_kill_enemy( ai_enemy )
{
	is_enemy_behind_player = false;
	if ( IsDefined( ai_enemy ) && ai_enemy.origin[1] < level.player.origin[1] )
	{
		is_enemy_behind_player = true;
	}
	
	is_enemy_killable = false;
	if ( IsDefined( ai_enemy.script_noteworthy ) && ai_enemy.script_noteworthy == "plaza_no_kill" )
	{
		is_enemy_killable = true;
	}
	
	can_kill_enemy = false;
	if ( is_enemy_behind_player && is_enemy_killable )
	{
		can_kill_enemy = true;
	}
	
	return can_kill_enemy;
}

clear_behind()
{
	n_length_max_squared = 512 * 512;
	n_player_fov = GetDvarFloat( "cg_fov" );
	n_cos_player_fov = cos( n_player_fov );
	
	while ( true )
	{
		a_friendlies = GetAIArray( "allies" );
		a_enemies = GetAIArray( "axis" );
		
		a_valid_enemy_friendly_combos = [];
		
//		n_length_max_squared = 512 * 512;
//		n_player_fov = GetDvarFloat( "cg_fov" );
//		n_cos_player_fov = cos( n_player_fov );
		
		foreach ( ai_enemy in a_enemies )
		{
			if ( IsDefined( ai_enemy ) && ai_enemy.origin[1] < level.player.origin[1] )
			{
				foreach ( ai_friendly in a_friendlies )
				{
					n_length = LengthSquared( ai_enemy.origin - ai_friendly.origin );
					
					if ( n_length < n_length_max_squared )
					{
						s_enemy_to_friendly_info = SpawnStruct();
						s_enemy_to_friendly_info.ai_enemy = ai_enemy;
						s_enemy_to_friendly_info.ai_friendly = ai_friendly;
						s_enemy_to_friendly_info.n_length = n_length;
						
						ARRAY_ADD( a_valid_enemy_friendly_combos, s_enemy_to_friendly_info );
					}
					else
					{
						if ( !within_fov( level.player.origin, level.player.angles, ai_enemy.origin, n_cos_player_fov ) )
						{
							ai_enemy bloody_death();
						}
					}
				}
			}
		}
		
		a_best_matches = [];
		s_best_match_info = get_best_target_match( a_valid_enemy_friendly_combos );
		
		while ( IsDefined( s_best_match_info ) )
		{
			ARRAY_ADD( a_best_matches, s_best_match_info );
			
			a_valid_enemy_friendly_combos_updated = [];
			
			foreach ( s_check_for_valid in a_valid_enemy_friendly_combos )
			{
				if ( s_check_for_valid.ai_enemy != s_best_match_info.ai_enemy && s_check_for_valid.ai_friendly != s_best_match_info.ai_friendly )
				{
					ARRAY_ADD( a_valid_enemy_friendly_combos_updated, s_check_for_valid );
				}
			}
			
			a_valid_enemy_friendly_combos = a_valid_enemy_friendly_combos_updated;
			
			s_best_match_info = get_best_target_match( a_valid_enemy_friendly_combos );
		}
		
		foreach ( s_best_match_info in a_best_matches )
		{
			if ( IsAlive( s_best_match_info.ai_enemy ) )
			{
				s_best_match_info.ai_friendly shoot_at_target_perfect_aim( s_best_match_info.ai_enemy );
			}
		}
		
		wait 0.05;
	}
}

get_best_target_match( a_valid_enemy_friendly_combinations )
{
	s_best_match = undefined;
	
	foreach( s_enemy_to_friendly_info in a_valid_enemy_friendly_combinations )
	{
		if ( !IsDefined( s_best_match ) )
		{
			s_best_match = s_enemy_to_friendly_info;
		}
		else
		{
			if ( s_enemy_to_friendly_info.n_length < s_best_match.n_length )
			{
				s_best_match = s_enemy_to_friendly_info;
			}
		}
	}
	
	return s_best_match;
}

shoot_at_target_perfect_aim( ai_target )
{
	self endon( "death" );
	
	self.perfectaim = 1;
	
	self shoot_at_target( ai_target );
		
	self.perfectaim = 0;
}

move_president_cougar()
{
	trigger_wait( "t_street_done" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper say_dialog( "move_president_cougar_harper" );
	level.player say_dialog( "move_president_cougar_ssa" );
	
	trigger_use( "move_president_cougar" );
}

plaza_center_ais()
{
	a_plaza_center_0 = GetEntArray( "plaza_center_0", "targetname" );
	array_thread( a_plaza_center_0, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_center_1 = GetEntArray( "plaza_center_1", "targetname" );
	array_thread( a_plaza_center_1, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_plaza_center_2 = GetEntArray( "plaza_center_2", "targetname" );
	array_thread( a_plaza_center_2, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_plaza_center_3 = GetEntArray( "plaza_center_3", "targetname" );
	array_thread( a_plaza_center_3, ::add_spawn_function, ::force_goal, undefined, 16, true );
}

plaza_left_ais()
{
	a_plaza_left_0 = GetEntArray( "plaza_left_0", "targetname" );
	array_thread( a_plaza_left_0, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_plaza_left_1 = GetEntArray( "plaza_left_1", "script_noteworthy" );
	array_thread( a_plaza_left_1, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_left_4 = GetEntArray( "plaza_left_4", "targetname" );
	array_thread( a_plaza_left_4, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_left_5 = GetEntArray( "plaza_left_5", "targetname" );
	array_thread( a_plaza_left_5, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_left_rpg = GetEntArray( "plaza_left_rpg", "script_noteworthy" );
	array_thread( a_plaza_left_rpg, ::add_spawn_function, ::plaza_rpg );
}

plaza_right_ais()
{	
	a_plaza_right_inside_0 = GetEntArray( "plaza_right_inside_0", "script_noteworthy" );
	array_thread( a_plaza_right_inside_0, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_plaza_right_hunt = GetEntArray( "plaza_right_hunt", "script_noteworthy" );
	//array_thread( a_plaza_right_hunt, ::add_spawn_function, ::plaza_right_hunt_ai );
	
	a_plaza_right_outside_0 = GetEntArray( "plaza_right_outside_0", "script_noteworthy" );
	array_thread( a_plaza_right_outside_0, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_right_inside_1 = GetEntArray( "plaza_right_inside_1", "script_noteworthy" );
	array_thread( a_plaza_right_inside_1, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_plaza_right_outside_2 = GetEntArray( "plaza_right_outside_2", "script_noteworthy" );
	array_thread( a_plaza_right_outside_2, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_right_up_2 = GetEntArray( "plaza_right_up_2", "script_noteworthy" );
	array_thread( a_plaza_right_up_2, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_right_inside_3 = GetEntArray( "plaza_right_inside_3", "script_noteworthy" );
	array_thread( a_plaza_right_inside_3, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_right_building = GetEntArray( "plaza_right_building", "targetname" );
	array_thread( a_plaza_right_building, ::add_spawn_function, ::force_goal, undefined, 16 );
	
	a_plaza_right_rpg = GetEntArray( "plaza_right_rpg", "targetname" );
	array_thread( a_plaza_right_rpg, ::add_spawn_function, ::plaza_rpg );
	
	a_plaza_right_f35_crash = GetEntArray( "plaza_right_f35_crash", "targetname" );
	array_thread( a_plaza_right_rpg, ::add_spawn_function, ::plaza_right_crash_ai );
	
	//level thread plaza_hedge_ai();
	level thread plaza_bulding_sniper();
	level thread plaza_right_rpg_ai();
}

plaza_hedge_ai()
{	
	level endon( "end_plaza_right hedge" );
	
	trigger_wait( "t_plaza_right_hedge" );
	
	level thread plaza_hedge_sniper();
	
	run_scene( "climb_on_hedge_1" );
	run_scene( "climb_on_hedge_2" );
}

plaza_hedge_sniper()
{
	//ai_plaza_hedge_sniper = simple_spawn_single( "plaza_hedge_sniper" );
	ai_plaza_hedge_sniper.sprint = 1;
	ai_plaza_hedge_sniper force_goal( undefined, 16 );
	//ai_plaza_hedge_sniper.goalradius = 16;
}

plaza_right_hunt_ai()
{
	self endon( "death" );
	
	self.goalradius = 16;
	ai_harper = GetEnt( "harper_ai", "targetname" );
	
	while ( true )
	{	
		wait 3;
	}
}

plaza_bulding_sniper()
{
	trigger_wait( "sm_plaza_right_1" );
	
	run_scene( "climb_plaza_building" );
}

plaza_rpg()
{
	self endon( "death" );
	
	self.a.allow_weapon_switch = false;
	self force_goal( undefined, 16 );
	self.goalradius = 16;
}

plaza_right_rpg_ai()
{
	level endon( "event_6_done" );
	
	trigger_wait( "sm_f35_crash_right" );
	
	run_scene( "climb_on_cylinder_0" );
	run_scene( "climb_on_cylinder_1" );
}

plaza_right_crash_ai()
{
	self endon( "death" );
	
	self force_goal( undefined, 16 );
	self.goalradius = 16;
}

plaza_harper_movement()
{
	level thread plaza_harper_movement_left();
	level thread plaza_harper_movement_right();
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
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper.plaza_right = false;
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
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	ai_harper.plaza_right = true;
}

plaza_right_color_logic()
{
	level thread plaza_right_color_1_inside();
	level thread plaza_right_color_1_outside();
	level thread plaza_right_color_2_inside();
	level thread plaza_right_color_2_outside();
}

plaza_right_color_1_inside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_1" );
	
	trigger_wait( "color_plaza_right_1_inside" );
	
	t_color_plaza_right_1_outside = GetEnt( "color_plaza_right_1_outside", "targetname" );
	t_color_plaza_right_1_outside Delete();
	
	t_color_plaza_right_0_inside = GetEnt( "color_plaza_right_0_inside", "targetname" );
	t_color_plaza_right_0_inside Delete();
	
	level notify( "plaza_right_color_1" );
}

plaza_right_color_1_outside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_1" );
	
	trigger_wait( "color_plaza_right_1_outside" );
	
	t_color_plaza_right_1_inside = GetEnt( "color_plaza_right_1_inside", "targetname" );
	t_color_plaza_right_1_inside Delete();
	
	t_color_plaza_right_0_inside = GetEnt( "color_plaza_right_0_inside", "targetname" );
	t_color_plaza_right_0_inside Delete();
	
	level notify( "plaza_right_color_1" );
}

plaza_right_color_2_inside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_2" );
	
	trigger_wait( "color_plaza_right_2_inside" );
	
	t_color_plaza_right_2_outside = GetEnt( "color_plaza_right_2_outside", "targetname" );
	t_color_plaza_right_2_outside Delete();
	
	level notify( "plaza_right_color_2" );
}

plaza_right_color_2_outside()
{
	level endon( "delete_plaza_right_color" );
	level endon( "plaza_right_color_2" );
	
	trigger_wait( "color_plaza_right_2_outside" );
	
	t_color_plaza_right_2_inside = GetEnt( "color_plaza_right_2_inside", "targetname" );
	t_color_plaza_right_2_inside Delete();
	
	level notify( "plaza_right_color_2" );
}

plaza_spawn_manager()
{
//	level thread plaza_left_sm_0();
//	level thread plaza_right_sm_0();
//	level thread plaza_left_sm_1();
//	level thread plaza_right_sm_1();
//	level thread plaza_left_sm_2();
//	level thread plaza_right_sm_2();
//	level thread plaza_left_sm_3();
//	level thread plaza_right_sm_3();
//	level thread plaza_left_sm_4();
//	level thread plaza_right_sm_4();
}

plaza_left_sm_0()
{	
	level endon( "end_plaza_sm_0" );
	
	trigger_wait( "sm_plaza_left_0" );
	
	level notify( "end_plaza_right hedge" );
	
	t_plaza_right_hedge = GetEnt( "t_plaza_right_hedge", "targetname" );
	t_plaza_right_hedge Delete();
	
	level notify( "end_plaza_sm_0" );
}

plaza_right_sm_0()
{	
	level endon( "end_plaza_sm_0" );
	
	trigger_wait( "t_plaza_right_hedge" );
	
	trigger_off( "sm_plaza_left_0", "targetname" );
	trigger_off( "sm_plaza_left_2", "targetname" );
	
	level notify( "end_plaza_sm_0" );
}

plaza_left_sm_1()
{	
	level endon( "end_plaza_sm_1" );
	
	trigger_wait( "sm_plaza_left_1" );
	
	trigger_off( "sm_plaza_right_0", "targetname" );
	
	level notify( "end_plaza_sm_1" );
}

plaza_right_sm_1()
{	
	level endon( "end_plaza_sm_1" );
	
	trigger_wait( "sm_plaza_right_0" );
	
	trigger_off( "sm_plaza_left_1", "targetname" );
	
	level notify( "end_plaza_sm_1" );
}

plaza_left_sm_2()
{	
	level endon( "end_plaza_sm_2" );
	
	trigger_wait( "sm_plaza_left_3" );
	
	trigger_off( "sm_plaza_right_1", "targetname" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	if ( ai_harper.plaza_right == true )
	{
		trigger_use( "color_plaza_right_1_inside" );
		
		ai_harper force_goal( undefined, 16, true );
	}
	
	level notify( "end_plaza_sm_2" );
}

plaza_right_sm_2()
{	
	level endon( "end_plaza_sm_2" );
	
	trigger_wait( "sm_plaza_right_1" );
	
	trigger_off( "sm_plaza_left_3", "targetname" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	if ( ai_harper.plaza_right == false )
	{
		trigger_use( "color_plaza_left_3" );
		
		t_color_plaza_left_2 = GetEnt( "color_plaza_left_2", "targetname" );
		if ( IsDefined( t_color_plaza_left_2 ) )
		{
			t_color_plaza_left_2 Delete();
		}
		
		ai_harper force_goal( undefined, 16, true );
	}
	
	level notify( "end_plaza_sm_2" );
}

plaza_left_sm_3()
{	
	level endon( "end_plaza_sm_3" );
	
	trigger_wait( "sm_plaza_left_4" );
	
	trigger_off( "sm_plaza_right_2", "targetname" );
	
	level notify( "end_plaza_sm_3" );
}

plaza_right_sm_3()
{	
	level endon( "end_plaza_sm_3" );
	
	trigger_wait( "sm_plaza_right_2" );
	
	trigger_off( "sm_plaza_left_4", "targetname" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	if ( ai_harper.plaza_right == false )
	{
		trigger_use( "color_plaza_left_4" );
		
		ai_harper force_goal( undefined, 16, true );
	}
	
	level notify( "end_plaza_sm_3" );
}

plaza_left_sm_4()
{	
	level endon( "end_plaza_sm_4" );
	
	trigger_wait( "sm_plaza_left_5" );
	
	trigger_off( "sm_plaza_right_3", "targetname" );
	
	level notify( "end_plaza_sm_4" );
}

plaza_right_sm_4()
{	
	level endon( "end_plaza_sm_4" );
	
	trigger_wait( "sm_plaza_right_3" );
	
	trigger_off( "sm_plaza_left_5", "targetname" );
	
	level notify( "end_plaza_sm_4" );
}

f35_crash()
{
	//vh_sam_cougar = GetEnt( "intersect_sam_cougar", "targetname" );
	vh_sam_cougar = spawn_vehicle_from_targetname( "intersect_sam_cougar" );
	vh_sam_cougar veh_magic_bullet_shield( true );
	
	level thread f35_crash_left();
	level thread f35_crash_right();
	level thread f35_crash_middle();
}

f35_crash_left()
{
	level endon( "f35_crash_right" );
	level endon( "f35_crash_middle" );
	
	trigger_wait( "t_f35_crash_left" );
	
	level notify( "f35_crash_left" );
	
	thread f35_crash_sound();
	
	simple_spawn( "intersect_ssa" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	if ( ai_harper.plaza_right == true )
	{
		trigger_use( "color_plaza_right_3" );
		
		level notify( "plaza_right_color_2" );
		
		t_color_plaza_right_2_outside = GetEnt( "color_plaza_right_2_outside", "targetname" );
		if ( IsDefined( t_color_plaza_right_2_outside ) )
		{
			t_color_plaza_right_2_outside Delete();
		}
		
		t_color_plaza_right_2_inside = GetEnt( "color_plaza_right_2_inside", "targetname" );
		if ( IsDefined( t_color_plaza_right_2_inside ) )
		{
			t_color_plaza_right_2_inside Delete();
		}
		
		ai_harper force_goal( undefined, 16, true );
	}
	
	trigger_off( "sm_f35_crash_right", "targetname" );
	
	level thread sam_cougar_animation();

	run_scene( "f35_crash_left" );
	plaza_and_intersect_transition();

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

f35_crash_right()
{
	level endon( "f35_crash_left" );
	level endon( "f35_crash_middle" );
	
	trigger_wait( "t_f35_crash_right" );
	
	level notify( "f35_crash_right" );
	
	thread f35_crash_sound();
	
	simple_spawn( "intersect_ssa" );
	
	ai_harper = GetEnt( "harper_ai", "targetname" );
	if ( ai_harper.plaza_right == false )
	{
		trigger_use( "color_plaza_left_5" );
		
		ai_harper force_goal( undefined, 16, true );
	}
	
	level thread sam_cougar_animation();
	
	run_scene( "f35_crash_right" );
	
	plaza_and_intersect_transition();
}

f35_crash_middle()
{
	level endon( "f35_crash_left" );
	level endon( "f35_crash_right" );
	
	trigger_wait( "t_f35_crash_middle" );
	
	level notify( "f35_crash_middle" );
	
	thread f35_crash_sound();
	
	simple_spawn( "intersect_ssa" );
	
	level thread sam_cougar_animation();
	
	veh_f35 = spawn_vehicle_from_targetname( "f35_cougar_exit" );
	veh_f35 veh_toggle_tread_fx( false );
    veh_f35 veh_toggle_exhaust_fx( false );
    veh_f35 veh_magic_bullet_shield( true );
    
    t_f35_collision = GetEnt( "f35_collision", "targetname" );
    t_f35_collision EnableLinkTo();
    t_f35_collision LinkTo( veh_f35, "tag_origin" );
    
    m_f35_dynamic_path = GetEnt( "f35_dynamic_path", "targetname" );
    m_f35_dynamic_path LinkTo( veh_f35, "tag_origin" );
	
	level thread run_scene( "f35_crash_middle" );
	//flag_wait( "f35_crash_middle_started" );
//	m_f35 = get_model_or_models_from_scene( "f35_crash_middle", "f35_f35_crash" );
	t_f35_collision thread kill_player_if_run_over( "f35_crash_middle" );
	level thread spawn_left_rpg_ais();
	
	trigger_wait( "t_f35_crash_right" );
	
	plaza_and_intersect_transition();
}

kill_player_if_run_over( str_scene_name )
{
	level endon( "f35_crash_done" );
	
//	veh_f35 = GetEnt( "f35_cougar_exit", "targetname" );
//	veh_f35 veh_toggle_tread_fx( false );
//    veh_f35 veh_toggle_exhaust_fx( false );
//    veh_f35 veh_magic_bullet_shield( true );
	
	level thread wait_to_notify_done( str_scene_name );
	
	while ( !level.player IsTouching( self ) )
	{
		wait 0.05;
	}
	
	level.player Suicide();
	//IPrintLnBold( "TOUCHED" );
}

wait_to_notify_done( str_scene_name )
{
	scene_wait( str_scene_name );
	
	level notify( "f35_crash_done" );
	
	m_f35_dynamic_path = GetEnt( "f35_dynamic_path", "targetname" );
	m_f35_dynamic_path DisconnectPaths();
}

spawn_left_rpg_ais()
{
	level endon( "event_6_done" );
	
	trigger_wait( "sm_plaza_center_3" );
	
	trigger_use( "sm_f35_crash_right" );
}

plaza_and_intersect_transition()
{	
	autosave_by_name( "plaza_done" );
	
	//IPrintLnBold( "decide fail or not" );
	level notify( "plaza_decision_made" );
	//iPrintLnBold( level.n_strikes );
	level thread plaza_fail_condition();
	
	a_friendlies = array( "ssa_1", "ssa_2", "ssa_3", "harper" );
	a_friendly_ais = [];
	//a_friendlies = GetAIArray( "allies" );
	
	t_f35_crash_left = GetEnt( "t_f35_crash_left", "targetname" );
	
	foreach ( str_friendly in a_friendlies )
	{
		ai_friendly = GetEnt( str_friendly + "_ai", "targetname" );
		
		if ( IsAlive( ai_friendly ) )
		{
			if ( ai_friendly IsTouching( t_f35_crash_left ) )
			{
				ai_friendly disable_ai_color();
			}
			
			ai_friendly change_movemode("cqb");
			ai_friendly.perfectaim = 1;
			ARRAY_ADD( a_friendly_ais, ai_friendly );
		}
	}
	
	trigger_use( "move_to_intersect" );
	
	//a_plaza_clean_up = GetEntArray( "plaza_clean_up", "script_noteworthy" );
	a_plaza_clean_up = [];
	a_rpg_right = GetEntArray( "plaza_right_rpg_ai", "targetname" );
	//a_rpg_left = GetEntArray( "plaza_left_5_ai", "targetname" );
	a_f35_crash_ais = GetEntArray( "plaza_f35_crash_ai", "targetname" );
	a_plaza_clean_up = array_merge( a_plaza_clean_up, a_rpg_right );
	//a_plaza_clean_up = array_merge( a_plaza_clean_up, a_rpg_left );
	a_plaza_clean_up = array_merge( a_plaza_clean_up, a_f35_crash_ais );

	while ( a_plaza_clean_up.size > 0 )
	{
		if ( a_friendly_ais.size <= a_plaza_clean_up.size )
		{
			foreach ( n_key, ai_friendly in a_friendly_ais )
			{
				ai_friendly thread shoot_at_target_perfect_aim( a_plaza_clean_up[ n_key ] );
			}
		}
		else
		{
			foreach ( n_key, ai_left_in_plaza in a_plaza_clean_up )
			{
				a_friendly_ais[ n_key ] thread shoot_at_target_perfect_aim( ai_left_in_plaza );
			}
		}
		
		a_plaza_clean_up = array_removeDead( a_plaza_clean_up );
		
		wait 0.05;
	}
	
	foreach ( ai_friendly in a_friendly_ais )
	{
		ai_friendly enable_ai_color();
		ai_friendly reset_movemode();
		ai_friendly.perfectaim = 0;
		ai_friendly thread force_goal( undefined, 16, true );
	}
	
	trigger_use( "move_to_intersect" );
	
	waittill_intersection_done();
}

plaza_fail_condition()
{
	n_intersect_friendlies = 3;
	a_intersect_ssa = GetEntArray( "intersect_ssa_ai", "targetname" );
	a_intersect_ssa_organized = [];
	a_intersect_ssa_new = [];
	
	for ( i = 0; i < n_intersect_friendlies; i++ )
	{
		foreach ( ai_ssa in a_intersect_ssa )
		{
			if ( ai_ssa.script_noteworthy == "intersect_ssa_" + i )
			{
				ARRAY_ADD( a_intersect_ssa_organized, ai_ssa );
				a_intersect_ssa_new = array_remove( a_intersect_ssa, ai_ssa );
			}
		}
		
		a_intersect_ssa = a_intersect_ssa_new;
	}

	if ( level.n_strikes >= 1 )
	{
		a_intersect_ssa_organized[ 0 ] stop_magic_bullet_shield();
		a_intersect_ssa_organized[ 0 ] bloody_death();
	}
	
	if ( level.n_strikes >= 2 )
	{
		a_intersect_ssa_organized[ 1 ] thread fail_ssa_2();
	}
	
	if ( level.n_strikes == 3 )
	{
		level.is_plaza_successful = false;
		
		trigger_use( "t_right_van" );
		
//		a_intersect_ssa_organized[ 2 ] stop_magic_bullet_shield();
//		a_intersect_ssa_organized[ 2 ] bloody_death();
		
		//trigger_wait( "sm_intersect_middle" );
		
		level waittill( "right_van_unload" );
		
		a_right_van_group = get_ai_group_ai( "right_van_group" );
		foreach ( ai_right_van in a_right_van_group )
		{
			ai_right_van thread magic_bullet_shield_and_force_goal();
		}
		
		ai_destroy_vip_cougar = GetEnt( "destroy_vip_cougar_ai", "targetname" );
		//ai_destroy_vip_cougar waittill( "goal" );
		
		e_vip_cougar_origin = GetEnt( "vip_cougar_origin", "targetname" );
		
		//trigger_wait( "fire_magic_bullet" );
		trigger_wait( "shoot_drone" );
		t_fire_magic_bullet = GetEnt( "fire_magic_bullet", "targetname" );
		t_fire_magic_bullet wait_for_trigger_or_timeout( 3 );
		
		ai_destroy_vip_cougar thread aim_at_target( e_vip_cougar_origin, 1 );
		
		s_magic_bullet_start = getstruct( "magic_bullet_start", "targetname" );
		MagicBullet( "rpg_sp", s_magic_bullet_start.origin, e_vip_cougar_origin.origin );
		
		vh_vip_cougar = GetEnt( "intersect_vip_cougar", "targetname" );
		vh_vip_cougar DoDamage( vh_vip_cougar.health, vh_vip_cougar.origin, undefined, undefined, "projectile" );
		//level.b_vip_cougar_is_dead = true;
//		flag_set( "intersect_vip_cougar_died" );
//		set_objective( level.OBJ_PLAZA, undefined, "delete" );
//		IPrintLnBold( "vip cougar destroyed" );
	}
}

fail_ssa_2()
{
	self endon( "death" );
	
	trigger_wait( "ssa_1_move_up" );
	
	nd_ssa_2_killer = GetNode( "nd_ssa_2_killer", "script_noteworthy" );
	self.forceLongDeath = 1;
	
	wait 2;
	
	self stop_magic_bullet_shield();
	self DoDamage( 1, nd_ssa_2_killer.origin );
}

waittill_intersection_done()
{
//	trigger_wait( "t_left_van" );
	//level waittill( "left_van_unload" );
	
//	a_enemy_ais = GetAIArray( "axis" );
//	
//	while ( a_enemy_ais.size > 0 )
//	{	
//		wait 0.05;
//		
//		a_enemy_ais = GetAIArray( "axis" );
//	}
	
	waittill_ai_group_cleared( "right_van_group" );
	waittill_ai_group_cleared( "front_van_group" );
	waittill_ai_group_cleared( "left_van_group" );
	
//	t_move_into_intersection = GetEnt( "move_into_intersection", "targetname" );
//	t_move_into_intersection Delete();
	
	set_objective( level.OBJ_PLAZA, undefined, "delete" );
	
	level notify( "vip_cougar_saved" );
	
//	if ( is_false( level.b_intersect_cougar ) )
//	{
//		IPrintLnBold( "INTERSECTION COUGAR CHALLENGE FAILED!!!" );
//	}
//	else
//	{
//		IPrintLnBold( "INTERSECTION COUGAR CHALLENGE COMPLETED!!!" );
//	}
	
	flag_set( "event_6_done" );
	
	trigger_use( "cover_arena" );
}

intersection_ais()
{
	a_intersection_ssa = GetEntArray( "intersect_ssa", "targetname" );
	array_thread( a_intersection_ssa, ::add_spawn_function, ::magic_bullet_shield_and_force_goal );
	
	a_intersection_middle = GetEntArray( "intersect_middle", "targetname" );
	array_thread( a_intersection_middle, ::add_spawn_function, ::magic_bullet_shield_and_force_goal );
	
	a_intersection_rpg = GetEntArray( "intersect_rpg", "script_noteworthy" );
	array_thread( a_intersection_rpg, ::add_spawn_function, ::intersection_rpg_logic );
	
	a_right_van_ais = GetEntArray( "right_van_ai", "script_noteworthy" );
	array_thread( a_right_van_ais, ::add_spawn_function, ::force_goal, undefined, 16, true );
	
	a_front_van_ais = GetEntArray( "front_van_ai", "script_noteworthy" );
	array_thread( a_front_van_ais, ::add_spawn_function, ::force_goal_after_unload );
	
	a_left_van_ais = GetEntArray( "left_van_ai", "script_noteworthy" );
	array_thread( a_left_van_ais, ::add_spawn_function, ::left_van_magic );
	
//	waittill_spawn_manager_complete( "sm_intersect_middle" );
	
//	a_intersection_middle = GetEntArray( "intersect_middle_ai", "targetname" );
//	foreach ( ai_intersect_middle in a_intersection_middle )
//	{
//		ai_intersect_middle thread magic_bullet_shield_and_force_goal();
//	}
	
	spawn_left_van();
}

force_goal_after_unload()
{
	self endon( "death" );
	
	//level waittill( "van_1_unload" );
	
	self force_goal( undefined, 16, true );
	
	e_goal_volume = GetEnt( level.str_volume_current, "targetname");
	self SetGoalVolumeAuto( e_goal_volume );
}

left_van_magic()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	
	level waittill( "left_van_unload" );
	
	//wait 2;
	wait 0.05;
	
	self stop_magic_bullet_shield();
	
	//iPrintLnBold( "done_magic" );
	
	self force_goal( undefined, 16, true );
	
	e_goal_volume = GetEnt( level.str_volume_current, "targetname");
	self SetGoalVolumeAuto( e_goal_volume );
}

spawn_left_van()
{
	level endon( "event_6_done" );
	
	level thread left_van_based_on_ai();
		
	trigger_wait( "t_left_van", "targetname" );
	
	level notify( "end_left_van_wait" );
	
	trigger_use( "move_into_intersection" );
}

left_van_based_on_ai()
{
	level endon( "event_6_done" );
	level endon( "end_left_van_wait" );
	
	waittill_ai_group_amount_killed( "front_van_group", 2 );
	
	trigger_use( "t_left_van", "targetname" );
}

left_van_based_on_van_death()
{
	level endon( "end_left_van_wait" );
	
	self waittill( "death" );
	
	trigger_use( "t_left_van", "targetname" );
}

magic_bullet_shield_and_force_goal()
{
	self endon( "death" );
	
	self magic_bullet_shield();
	
	if ( IsDefined( self.targetname ) && self.targetname == "intersect_middle_ai" )
	{
		self thread force_goal( undefined, 16, true );
		
		e_goal_volume = GetEnt( level.str_volume_current, "targetname");
		self SetGoalVolumeAuto( e_goal_volume );
		
		wait 4.4;
		
		self stop_magic_bullet_shield();
	}
	else if ( IsDefined( self.script_aigroup ) && self.script_aigroup == "right_van_group" )
	{
		self force_goal( undefined, 16, true );
		
		e_goal_volume = GetEnt( level.str_volume_current, "targetname");
		self SetGoalVolumeAuto( e_goal_volume );
		
		wait 3;
		
		self stop_magic_bullet_shield();
	}
	else
	{
		self force_goal( undefined, 16, true );
	}
}

intersection_rpg_logic()
{
	//level endon( "vip_cougar_died" );
	self endon( "death" );
	
	vh_vip_cougar = GetEnt( "intersect_vip_cougar", "targetname" );
	e_vip_cougar = GetEnt( "vip_cougar_origin", "targetname" );
	
	//self magic_bullet_shield();
	self force_goal( undefined, 16, true );
	
	e_goal_volume = GetEnt( level.str_volume_current, "targetname");
	self SetGoalVolumeAuto( e_goal_volume );
	
	self thread waittill_vip_cougar_death();
	
//	if ( IsDefined( self.targetname ) && self.targetname == "destroy_vip_cougar_ai" )
//	{
//		e_vip_cougar_origin = GetEnt( "vip_cougar_origin", "targetname" );
//		
//		trigger_wait( "fire_magic_bullet" );
//		
//		self thread aim_at_target( e_vip_cougar_origin );
//		MagicBullet( "rpg_sp", self.origin + (0, 0, 69), e_vip_cougar_origin.origin );
//		
//		level.b_vip_cougar_is_dead = true;
//		flag_set( "intersect_vip_cougar_died" );
//		set_objective( level.OBJ_PLAZA, undefined, "delete" );
//		IPrintLnBold( "vip cougar destroyed" );
//	}
	
	if ( level.n_strikes == 3 )
	{
		flag_wait( "intersect_vip_cougar_died" );
	}
	
	//if ( vh_vip_cougar.health > 0 && !level.b_vip_cougar_is_dead )
	while ( vh_vip_cougar.health > 0 ) //&& !level.b_vip_cougar_is_dead )
	{
		//IPrintLnBold( "shooting" );
		self shoot_at_target( e_vip_cougar );

		wait 0.05;
	}
	
//	IPrintLnBold( "do something else" );
//	self.goalradius = 2048;
}

waittill_vip_cougar_death()
{
	self endon( "death" );
	
	flag_wait( "intersect_vip_cougar_died" );
	
	//self notify( "stop_shoot_at_target" );
	self stop_shoot_at_target();
	self.goalradius = 2048;
	//IPrintLnBold( "stop shooting" + self.script_noteworthy );
}

interception_animations()
{
	//plaza_sucess = true;
	//plaza_sucess = false;
	
	trigger_wait( "shoot_drone" );
	
	level notify( "stop_sam_cougar" );
	
	//SOUND - Shawn J
	playsoundatposition ("evt_drone_crash_l", (9724, -2784, 326));
	playsoundatposition ("evt_drone_crash_r", (9715, 2065, 182));
		
	level thread run_scene( "shoot_down_drone" );
	level thread run_scene( "shoot_down_drone_sam" );
	
	flag_wait( "shoot_down_drone_started" );

	vh_avenger = GetEnt( "intersect_avenger_drone", "targetname" );	
	PlayFXOnTag( level._effect[ "drone_smoke_trail" ], vh_avenger, "tag_gunner_turret2" );
	vh_avenger veh_magic_bullet_shield( true );
	
	vh_sam_cougar = GetEnt( "intersect_sam_cougar", "targetname" );
	vh_sam_cougar shoot_turret_at_target_once( vh_avenger, undefined, 2 );
	
	level thread shoot_random_car();
	level thread intersect_goal_volume_logic();
	
	scene_wait( "shoot_down_drone_sam" );
	
	//level thread destroy_drone_and_van();
	
	if ( level.is_plaza_successful )
	{
		level thread sam_cougar_animation();
		
		level waittill( "vip_cougar_saved" );
		
		a_intersect_ssa = GetEntArray( "intersect_ssa_ai", "targetname" );
		foreach ( ai_ssa in a_intersect_ssa )
		{
			if ( ai_ssa.script_noteworthy == "intersect_ssa_2" )
			{
				ai_thank_ssa = ai_ssa;
			}
		}
		
		if ( IsDefined( ai_thank_ssa ) )
		{
			is_intersect_g20_saved = true;
			level thread run_scene( "ssa_thank" );
//			ai_thank_ssa thread say_dialog( "intersect_thanks" );
			ai_thank_ssa say_dialog( "you_got_here_just_006" );
			level.player say_dialog( "you_fight_throu_007" );
		}
	}
	else
	{
//		a_ais_from_scene = get_ais_from_scene( "shoot_down_drone_sam" );
//		ai_sam = a_ais_from_scene[ 0 ];
//		ai_sam thread say_dialog( "plaza_fail" );
		
		run_scene( "sam_complain" );
		
//		ai_harper = GetEnt( "harper_ai", "targetname" );
//		ai_harper thread say_dialog( "intersect_sorry" );
		
		level thread sam_cougar_animation();
	}
	
	if ( IS_TRUE( is_intersect_g20_saved ) )
	{
		// IPrintLnBold( "INTERSECTION G20 SAVED!!!" );
		level notify( "intersect_g20_saved" );
	}
}

sam_cougar_animation()
{
	level endon( "stop_sam_cougar" );
	
	//level thread run_scene( "sam_cougar_loop" );
//	vh_sam_cougar = GetEnt( "intersect_sam_cougar", "targetname" );
//	vh_sam_cougar SetGunnerTargetVec( ( 6018, -1149, 669 ), 1 );
	
	level thread run_scene( "sam_guy_loop" );
	
	vh_sam_cougar = GetEnt( "intersect_sam_cougar", "targetname" );
	
	while ( true )
	{
		a_drones = GetEntArray( "pegasus_fast", "targetname" );
		a_avengers = GetEntArray( "avenger_fast", "targetname" );
		a_drones = array_merge( a_drones, a_avengers );
		
		vh_drone = random( a_drones );
		
		//b_can_see_drone = vh_sam_cougar can_turret_shoot_target( vh_drone, 2 );
		
		vh_sam_cougar shoot_turret_at_target_once( vh_drone, undefined, 2 );
		
		wait 3;
	}
}

shoot_random_car()
{
	//vh_random_car = GetEnt( "intersect_random_car", "targetname" );
	ai_rpg = simple_spawn_single( "intersect_magic_rpg_guy" );
	ai_rpg endon( "death" );
	
	vh_random_car = spawn_vehicle_from_targetname( "intersect_random_car" );
	vh_random_car.overrideVehicleDamage = ::random_car_damage_override;
	
	s_start_pos = getstruct( "intersect_magic_rpg", "targetname" );
	s_end_pos = getstruct( "intersect_magic_target", "targetname" );
	
	wait 3;
	//IPrintLnBold( "shoot" );
	ai_rpg aim_at_target( vh_random_car );
	MagicBullet( "rpg_sp", s_start_pos.origin, s_end_pos.origin  + ( 0, 0, 12 ) );
	
	ai_rpg thread intersection_rpg_logic();
	
	e_intersect_volume_0 = GetEnt( "intersect_volume_0", "targetname" );
	ai_rpg SetGoalVolumeAuto( e_intersect_volume_0 );
}

intersect_goal_volume_logic()
{
	trigger_wait( "intersect_color_1" );
	
	level.str_volume_current = "intersect_volume_1";
	set_enemies_to_goal_volume( level.str_volume_current );
	
	trigger_wait( "move_into_intersection" );
	
	level.str_volume_current = "intersect_volume_2";
	set_enemies_to_goal_volume( level.str_volume_current );
}

set_enemies_to_goal_volume( str_goal_volume )
{
	e_goal_volume = GetEnt( str_goal_volume, "targetname" );
	
	a_enemies = GetAIArray( "axis" );
	foreach ( ai_enemy in a_enemies )
	{
		ai_enemy SetGoalVolumeAuto( e_goal_volume );
	}
}

random_car_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( str_means_of_death == "MOD_PROJECTILE_SPLASH" || str_means_of_death == "MOD_PROJECTILE" )
	{
		s_exploding_pos = getstruct( "intersect_magic_target", "targetname" );
		PlayFX( level._effect[ "car_explosion" ] , s_exploding_pos.origin, v_dir );
		vehicle_explosion_launch( v_point );
		self DoDamage( self.health, self.origin, undefined, undefined, "riflebullet" );
	}
	
	if ( str_means_of_death != "MOD_RIFLE_BULLET" )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

destroy_drone_and_van()
{
	
	//vh_van_3 = GetEnt( "van_3", "targetname" );
	vh_avenger_drone = get_model_or_models_from_scene( "shoot_down_drone", "intersect_avenger_drone" );
	
	//IPrintLnBold( vh_van_3.health );
	//IPrintLnBold( vh_avenger_drone.health );
	
	//vh_van_3 thread delete_after_death();
	//vh_van_3 DoDamage( vh_van_3.health, vh_van_3.origin );
	
	vh_avenger_drone DoDamage( vh_avenger_drone.health, vh_avenger_drone.origin );
	vh_avenger_drone waittill( "crash_done" );
	
	vh_avenger_drone Delete();
	
	vh_van_1 = GetEnt( "van_1", "targetname" );
	vh_van_1 waittill( "reached_end_node" );
	//vh_van_1 SetSpeed( 0, 60, 60 );
	//vh_van_1 CancelAIMove();
	//iPrintLnBold( "at goal" );
}

delete_after_death()
{
	self waittill( "death" );
	self Delete();
}

intruder()
{
	level endon( "event_6_done" );
//	trigger_wait( "sm_plaza_0" );
	
//	if( !level.player HasPerk( "specialty_intruder" ) )
//	{
//		level notify( "plaza_brute_force" );
//		return;
//	}
	
//	level.prevent_player_damage	= ::player_prevent_damage;
	
//	level notify( "plaza_intruder" );
	
	level.player waittill_player_has_intruder_perk();
	
	s_intruder_pos = getstruct( "intruder_pos", "targetname" );
	set_objective( level.OBJ_INTERACT, s_intruder_pos.origin, "interact" );
	
	vh_intruder_sam = spawn_vehicle_from_targetname( "intruder_sam" );
	
	level thread intruder_sam();
	
	trigger_wait( "intruder_use" );
	
	set_objective( level.OBJ_INTERACT, s_intruder_pos, "remove" );
	
	t_intruder_use = GetEnt( "intruder_use", "targetname" );
	t_intruder_use Delete();
	
	run_scene( "intruder" );
	
	m_intruder_gate = GetEnt( "intruder_gate", "targetname" );
	m_intruder_gate Delete();
}

intruder_sam()
{	
	level.player thread sam_visionset();
	
	trigger_wait( "near_intruder_sam" );
	
	level thread fxanim_drones();
	level thread intruder_sam_timer();
	
	run_scene( "sam_in" );
	flag_set( "rooftop_sam_in" );
	
	vh_sam = GetEnt( "intruder_sam", "targetname" );
	vh_sam UseVehicle( level.player, 1 );
	vh_sam thread intruder_sam_death();
	vh_sam.overrideVehicleDamage = ::sam_damage_override;
	//vh_sam thread print_health();
	
	SetDvar( "aim_assist_script_disable", 0 );
	level.player.old_aim_assist_min_target_distance = GetDvarInt( "aim_assist_min_target_distance" );
    level.player SetClientDvar( "aim_assist_min_target_distance", 100000 );   // default is  10000
	
//	level.player waittill_use_button_pressed();
	level waittill( "intruder_sam_end" );
	
	flag_clear( "rooftop_sam_in" );
	vh_sam UseBy( level.player );
	
//	level.b_sam_success = true; // TODO: remove this hack
//	level notify( "intruder_sam_end" ); // TODO: remove this hack
	
	if ( level.b_sam_success )
	{
		run_scene( "sam_out" );
	}
	else
	{
		vh_sam DoDamage( 10000, vh_sam.origin, undefined, undefined, "explosive" );
		run_scene( "sam_thrown_out" );
	}
	
	level.player SetClientDvar( "aim_assist_min_target_distance", level.player.old_aim_assist_min_target_distance );
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

intruder_sam_death()
{
	level endon( "intruder_sam_end" );
	
	self waittill( "death" );
	
	level.b_sam_success = false;
	level notify( "intruder_sam_end" );
}

intruder_sam_timer()
{
	level endon( "intruder_sam_end" );
	
	n_time = 3 * 60; // 3 minutes
	
	wait n_time;
	
	level.b_sam_success = true;
	level notify( "intruder_sam_end" );
}

sam_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( n_damage < 11 )
	{
		level.player DoDamage( n_damage, e_attacker.origin );
	}
	
	n_damage = n_damage * 2;
	
	n_health_result = self.health - n_damage;
	if ( n_health_result < 40 )
	{
		level.b_sam_success = false;
		level notify( "intruder_sam_end" );
	}
	
	return n_damage;
}

player_prevent_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	return true;
}

plaza_brute_force()
{
//	level endon( "plaza_intruder" );
	
	//trigger_wait( "sm_plaza_0" );
//	level waittill( "plaza_brute_force" );
	
	level thread maps\la_street::brute_force();
	
	trigger_use( "obj_plaza_start" );
	
	trigger_wait( "t_street_done" );
	
	level notify( "fxanim_drone_chunks_start" );
}

/////////////////////////////////////////////////////////////////////////////////////////////
// PLAZA CHALLENGES
/////////////////////////////////////////////////////////////////////////////////////////////
challenge_sonar( str_notify )
{
	level waittill( "vip_cougar_saved" );
	
	if ( !IsDefined( level.b_intersect_cougar ) )
	{
		self notify( str_notify );
	}
}

challenge_rescuesecond( str_notify )
{
	level waittill( "intersect_g20_saved" );
	self notify( str_notify );
}