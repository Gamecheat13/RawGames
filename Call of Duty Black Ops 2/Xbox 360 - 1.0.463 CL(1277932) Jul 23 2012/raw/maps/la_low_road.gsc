#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_scene;
#include maps\_vehicle;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#insert raw\maps\la.gsh;

/* ------------------------------------------------------------------------------------------
AUTOEXEC
-------------------------------------------------------------------------------------------*/
autoexec init_low_road()
{
	add_spawn_function_group( "g20_attackers", "targetname", ::g20_attackers_spawn_func );
	add_spawn_function_group( "low_road_choke_group2_rpg", "script_noteworthy", ::low_road_first_rpg );
	add_spawn_function_group( "gl_first_rpgs", "targetname", ::low_road_first_rpg );
	//add_spawn_function_group( "low_road_bus_rpg", "targetname", ::low_road_bus_rpg );
	//HACK: remove this after press demo
	GetEnt("low_road_bus_rpg", "targetname") Delete();
	add_spawn_function_ai_group( "low_road_snipers", ::spawn_func_low_road_sniper );
	add_spawn_function_group( "g20_group1_ss1", "script_noteworthy", ::g20_group1_ss1 );
	
	add_spawn_function_ai_group( "ai_group_low_road_left_side_flood", ::attack_potus );
	add_spawn_function_ai_group( "ai_group_low_road_right_side_flood", ::attack_potus );
	add_spawn_function_ai_group( "low_road_choke_group1b", ::attack_potus );
	add_spawn_function_ai_group( "ai_group_low_road_first_guys", ::attack_potus );
	
	add_trigger_function( "low_road_bigrig_entry", ::low_road_bigrig_enter );
	
	add_flag_function( "player_reached_sniper_rappel", ::sniper_rappel_options );
	
	add_spawn_function_veh( "g20_attack_drone", ::g20_attack_drone );
	add_spawn_function_veh( "sniper_van", ::spawn_fun_sniper_van);
	add_spawn_function_veh( "left_side_truck", ::left_side_truck );
	
	array_thread( GetEntArray( "crater_trigger", "targetname" ), ::crater_trigger );
	
	// link models to sniper platform
	m_platform = GetEnt( "sniper_platform", "targetname" );
	foreach ( m_piece in GetEntArray( "sniper_platform_linked", "targetname" ) )
	{
		m_piece LinkTo( m_platform );
	}
}

crater_trigger()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger", ent );
		if ( IsDefined( ent.chargeshotlevel ) && ent.chargeshotlevel > 0 )
		{
			exploder( self.script_int );
			self Delete();
		}
	}
}

g20_attackers_spawn_func()
{
	self.overrideactordamage = ::g20_attackers_damage;
}

g20_attackers_damage( eInflictor, e_attacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( !IsDefined( sMeansOfDeath ) || ( sMeansOfDeath == "MOD_UNKNOWN" ) )
	{
		return 0;
	}
	else if ( sMeansOfDeath == "MOD_CRUSH" )
	{
		if ( IsPlayer( e_attacker ) && !IsDefined(self.alreadyLaunched) )
		{
			self.alreadyLaunched = true;
			self StartRagdoll( true );
			
			v_launch = ( 0, 0, 100 );
			if( RandomInt( 100 ) < 40 )
			{
				v_launch += AnglesToForward( eInflictor.angles ) * 300;
			}
			self LaunchRagdoll( v_launch, "J_SpineUpper" );
		}
	}
	
	return iDamage;
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_sniper_rappel()
{
	a_heroes = array( "hillary", "sam", "jones" );
	if ( !flag( "harper_dead" ) )
	{
		ARRAY_ADD( a_heroes, "harper" );
	}
	
	init_heroes( a_heroes );
	skipto_teleport( "skipto_sniper_rappel", "squad" );
}

skipto_g20()
{
	init_low_road_heroes();
	
	skipto_teleport( "skipto_g20_group1", "squad" );
	
	get_player_cougar();
	
	run_scene_and_delete( "grouprappel_tbone" );
	//run_scene_and_delete( "low_road_intro" );
	
	level.veh_player_cougar SetAnimKnob( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 0 );
	
	spawn_vehicles_from_targetname( "low_road_vehicles" );
	
	simple_spawn( "g20_group1_ss" );
	
	kill_spawnernum( 101 );
	
	flag_set( "player_reached_sniper_rappel" );
	flag_set( "rappel_option" );
	flag_set( "low_road_choke_group2_cleared" );
	flag_set( "low_road_snipers_cleared" );
	flag_set( "done_rappelling" );
	
	level thread cover_convoy();
	noharper_open_cougar_door();

	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
//	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
}

skipto_sniper_exit()
{
	cleanup_kvp( "sm_low_road_first_guys" );
	cleanup_kvp( "low_road_bigrig_entry" );
	cleanup_kvp( "trig_low_road_rappel_left_enemies" );
	cleanup_kvp( "low_road_debris_fall" );
	
	noharper_open_cougar_door();
	
	skipto_g20();
	skipto_teleport_players( "skipto_sniper_exit" );
	flag_clear( "rappel_option" );
	flag_set( "sniper_option" );
}

init_low_road_heroes()
{
	init_hero( "harper" );
	init_hero( "hillary", ::hillary_think );
	init_hero( "sam" );
	init_hero( "jones" );
}

/* ------------------------------------------------------------------------------------------
MAIN
-------------------------------------------------------------------------------------------*/
main()
{
	level thread intro_scene();
	level thread regroup();
	
	load_gump_c();
	
	SetThreatBias( "potus", "potus_rushers", 90000 );
	
	spawn_vehicles_from_targetname( "low_road_vehicles" );
	
	level thread simple_spawn( "g20_group1_ss" );
	
	get_player_cougar();
	
	init_low_road_heroes();
	init_damage_fxanims();
	
	level thread remove_sight_blocker();
	
	level thread pre_rappel_backtrack_check();
	level thread post_rappel_backtrack_check();
	
	ClientNotify( "dl" );

	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
//	level thread spawn_aerial_vehicles( 10, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	level thread attack_convoy();
	
	level thread play_rappel_ambient_FX();
	
	flag_wait( "player_approaches_low_road" );
	
	level thread sniper_rappel_choice_fail();
	set_straffing_drones( "straffing_drone", "sniper_rappel_drone_strafe_org", 1000, undefined, 2, 4 );
	exploder(300);	// fires on car that falls in sniper platform collapse animation
	stop_exploder(1001);
	
	battle_flow();
	
	flag_set( "low_road_complete" );
	// Goes to last_stand_main()
}

load_gump_c()
{
	load_gump( "la_1_gump_1c" );
	
	m_cougar_destroyed = GetEnt( "cougar_destroyed", "targetname" );
	if ( IsDefined( m_cougar_destroyed ) )
	{
		m_cougar_destroyed SetModel( "veh_t6_mil_cougar_destroyed_low" );
	}
	
	level thread autosave_by_name( "after_sam" );
}

init_damage_fxanims()
{
	a_fxanims = [];
	
	ARRAY_ADD( a_fxanims, GetEnt( "fxanim_road_sign_snipe_01", "targetname" ) );
	ARRAY_ADD( a_fxanims, GetEnt( "fxanim_road_sign_snipe_02", "targetname" ) );
	ARRAY_ADD( a_fxanims, GetEnt( "fxanim_road_sign_snipe_03", "targetname" ) );
	ARRAY_ADD( a_fxanims, GetEnt( "fxanim_road_sign_snipe_04", "targetname" ) );
	
	exploder(360);	// Glow for sign 03. Turn off when sign gets shot
	exploder(361);	// Glow for sign 04. Turn off when sign gets shot	
	exploder(362);	// Glow for sign 03. Turn off when sign gets shot
	exploder(363);	// Glow for sign 04. Turn off when sign gets shot
	
	ARRAY_ADD( a_fxanims, GetEnt( "sniper_bus", "targetname" ) );
	ARRAY_ADD( a_fxanims, GetEnt( "sniper_train_middle", "targetname" ) );
	ARRAY_ADD( a_fxanims, GetEnt( "sniper_train_front", "targetname" ) );
	
	ARRAY_ADD( a_fxanims, GetEnt( "fxanim_sniper_freeway", "targetname" ) );
	
	array_thread( a_fxanims, ::trigger_damage_fxanim );
}

trigger_damage_fxanim()
{
	self SetModel( self.model );	// HACK to get bullet collision to work properly for gumped script models
	
	if ( self.targetname != "fxanim_sniper_freeway" )
	{
		self SetCanDamage( true );
	}
	
	b_played_bus_fx = false;
	
	while ( true )
	{
		self waittill( "damage", n_ammount, e_attacker, v_direction, v_point, str_type, str_tag, str_model, str_part, str_weapon, n_flags );
		
		if ( is_charged_shot( e_attacker ) || ( IS_VEHICLE( e_attacker ) && ( str_type == "MOD_EXPLOSIVE" ) ) )
		{
			switch ( self.targetname )
			{
				case "fxanim_road_sign_snipe_01":
					level notify( "fxanim_road_sign_snipe_01_start" );
					stop_exploder(360);
					return;
				case "fxanim_road_sign_snipe_02":
					level notify( "fxanim_road_sign_snipe_02_start" );
					stop_exploder(361);
					return;
				case "fxanim_road_sign_snipe_03":
					level notify( "fxanim_road_sign_snipe_03_start" );
					stop_exploder(362);
					return;
				case "fxanim_road_sign_snipe_04":
					level notify( "fxanim_road_sign_snipe_04_start" );
					stop_exploder(363);
					return;
					
				case "fxanim_sniper_freeway":
					if ( flag( "grouprappel_done" ) )
					{
						level thread run_scene_and_delete( "low_road_car_fall" );
						level notify( "fxanim_sniper_freeway_start" );
					}
					return;
					
				case "sniper_bus":
					if ( flag( "group_cover_go2_started" ) )
					{
						if ( !IS_TRUE( b_played_bus_fx ) )
						{
							b_played_bus_fx = true;
							GetEnt( "sniper_bus", "targetname" ) play_fx( "sniper_bus_window_shatter", undefined, undefined, -1, true, "bus_rock_jnt" );
							self HidePart( "tag_windows" );
						}
						
						level notify( "bus_rock" );
						run_scene( "sniper_bus_rock" );
					}
					break;
				case "sniper_train_front":
					run_scene( "sniper_train_rock_front" );
					break;
				case "sniper_train_middle":
					run_scene( "sniper_train_rock_middle" );
					break;
			}
		}
	}
}

is_charged_shot( e_attacker )
{
	return ( IsDefined( e_attacker.chargeshotlevel ) && e_attacker.chargeshotlevel > 0 );
}

intro_scene()
{
	level thread run_scene( "low_road_car_fall_loop" );
	
	load_gump( "la_1_gump_1c" );
	
	run_scene_first_frame( "low_road_bodies" );
	
	run_scene_first_frame( "low_road_intro" );
	run_scene_first_frame( "low_road_intro_cars" );
	run_scene_first_frame( "low_road_intro_policecars" );
	run_scene_first_frame( "low_road_intro_police1" );
	run_scene_first_frame( "low_road_intro_police2" );
	run_scene_first_frame( "low_road_intro_police3" );
	run_scene_first_frame( "low_road_intro_police4" );
	
	run_scene_first_frame( "grouprappel_tbone" );
	m_bigrig = get_model_or_models_from_scene( "grouprappel_tbone", "g20_group1_bigrig" );
	m_bigrig.targetname = "grouprappel_tbone_bigrig";
	
	run_scene_first_frame( "freeway_bigrig_entry", true );
	
	flag_wait( "player_approaches_low_road" );
	
	// Until choosing an option, hold weapon in non-combat position.
	level.player SetLowReady( true );
	
	level.player playsound( "evt_drone_group_flyby" );
	level thread run_scene_and_delete( "low_road_intro" );
	level thread run_scene_and_delete( "low_road_intro_cars" );
	level thread run_scene_and_delete( "low_road_intro_policecars" );
	
	level thread intro_cop1();
	level thread intro_cop2();
	level thread intro_cop3();
	level thread intro_cop4();
	
	level thread delay_police_car_damage();
	
	scene_wait( "low_road_intro" );
	wait_network_frame();
	level.veh_player_cougar SetAnimKnob( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 0 );
}

intro_cop1()
{
	run_scene_and_delete( "low_road_intro_police1" );
	run_scene_and_delete( "low_road_intro_police1_loop" );
}

intro_cop2()
{
	run_scene_and_delete( "low_road_intro_police2" );
	run_scene_and_delete( "low_road_intro_police2_loop" );
}

intro_cop3()
{
	run_scene_and_delete( "low_road_intro_police3" );
}

intro_cop4()
{
	run_scene_and_delete( "low_road_intro_police4" );
	run_scene_and_delete( "low_road_intro_police4_loop" );
}

delay_police_car_damage()
{
	flag_wait( "low_road_intro_policecars_started" );
	
	police_car1 = get_model_or_models_from_scene( "low_road_intro_policecars", "g20_group1_policecar1" );
	police_car1.takedamage = false;
	
	police_car2 = get_model_or_models_from_scene( "low_road_intro_policecars", "g20_group1_policecar2" );
	police_car2.takedamage = false;
	
	trigger_wait( "low_road_debris_fall" );
	
	police_car1.takedamage = true;
	police_car2.takedamage = true;
}

g20_attack_drone()
{
	self endon( "death" );
	
	e_target = GetEnt( "g20_attack_drone_target", "targetname" );
	self thread maps\_turret::shoot_turret_at_target( e_target, 4, undefined, 1 );
	self thread maps\_turret::shoot_turret_at_target( e_target, 4, undefined, 2 );
	
	wait 2;
	
	level.player playsound( "evt_avenger_explo" );
	exploder( 520 );	// drone strike explosions
	
	wait 1;
	
	spawn_func_scripted_flyby();
	
	wait 1;
	
	spawn_func_scripted_flyby();
}

attack_convoy()
{
	scene_wait( "low_road_intro" );
	level thread attack_convoy_random_explosions( level.veh_player_cougar.origin );
}

attack_convoy_random_explosions( v_pos )
{
	a_magic_rpg_orgs = get_struct_array( "convoy_attack_magic_rpg_orgs" );
	
	while ( !flag( "start_last_stand" ) )
	{
		v_random_pos = v_pos + FLAT_ORIGIN( random_vector( 300 ) );
		play_fx( "ambush_explosion", v_random_pos );
		
		wait 1;
		
		v_random_pos = v_pos + FLAT_ORIGIN( random_vector( 300 ) );
		MagicBullet( "usrpg_sp", RANDOM( a_magic_rpg_orgs ).origin, v_random_pos );
		
		wait RandomIntRange( 3, 5 );
	}
}

regroup()
{
	run_scene_first_frame( "groupcover_approach" );
	
	if ( !flag( "harper_dead" ) )
	{
		run_scene_first_frame( "groupcover_approach_harper" );
	}
	
	set_objective( level.OBJ_REGROUP, level.harper, "regroup" );
	
	level thread regroup_vo();
	level thread regroup_anim();
	
	flag_wait( "player_reached_sniper_rappel" );
	
	set_objective( level.OBJ_REGROUP, undefined, "delete" );
}

regroup_anim()
{
	if ( !flag( "harper_dead" ) )
	{
		level thread run_scene_and_delete( "groupcover_approach_harper" );
	}	
	
	run_scene_and_delete( "groupcover_approach" );
	
	if ( !flag( "harper_dead" ) )
	{
		level thread run_scene_and_delete( "groupcover_harper" );
	}	
	run_scene_and_delete( "groupcover" );
}

regroup_vo()
{
	level endon( "rappel_option" );
	level endon( "sniper_option" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "sect_harper_sitrep_0", 3 );
		level.harper queue_dialog( "harp_we_got_mercs_all_aro_0" );
		flag_wait( "player_reached_sniper_rappel" );
//		level.player queue_dialog( "harp_they_ve_got_rpgs_tar_0" );
		level.harper queue_dialog( "harp_lapd_is_trying_to_de_0" );
		level.harper queue_dialog( "harp_what_s_the_call_sec_0" );
	}
	else
	{
		level.player queue_dialog( "sect_agent_samuels_are_0" );
		level.sam queue_dialog( "samu_they_re_pinned_on_th_0" );
		level.sam queue_dialog( "samu_i_don_t_know_if_we_c_0" );
		level.sam queue_dialog( "samu_what_do_we_do_0" );
		level.player queue_dialog( "sect_we_need_those_vehicl_0" );
		level.player queue_dialog( "sect_we_gotta_make_quick_0" );
	}
}

sniper_rappel_vo()
{	
	if ( flag( "sniper_option" ) )
	{
		level.player queue_dialog( "get_the_president_004" );
	}
	else
	{
		level.player queue_dialog( "rappel_down__go_001" );
	}
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_come_on_come_on_g_0", 1.5 );
		level.harper queue_dialog( "harp_we_re_on_ground_fu_0", 4 );
		level.harper queue_dialog( "harp_moving_to_cover_by_t_0" );
	}
	
	if ( flag( "sniper_option" ) )
	{
		level.player queue_dialog( "sect_stay_in_cover_i_ll_0" );
	}
	
	level thread low_road_pmc_vo_callouts();
	
//	if ( !PRESS_DEMO && !flag( "harper_dead" ) )
//	{
//		flag_wait( "left_side_rappel_started" );
//		level.harper queue_dialog( "harp_left_side_enemies_0", 4 );
//	}
	
	flag_wait( "low_road_choke_group1_cleared" );
	level.player queue_dialog( "sect_they_re_down_move_0" );

	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_moving_0", 1 );
//		level.harper queue_dialog( "harp_they_re_advancing_0", 4 );
	}
		
//	level.player queue_dialog( "sect_harper_there_s_too_0", 2, undefined, "low_road_choke_group1b_cleared" );
	
	flag_wait( "low_road_choke_group1b_cleared" );
//	level.player queue_dialog( "sect_okay_jones_move_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_moving_0", 1 );
		level.harper queue_dialog( "harp_we_re_taking_heavy_e_0", 1 );
		//level thread harper_sniper_nag();
	}
	
	level thread g20_cougar_nag_vo();
	
//	level.player queue_dialog( "sect_don_t_move_until_i_t_0" );
	
	flag_wait( "low_road_choke_group2_cleared" );
	flag_wait( "low_road_snipers_cleared" );
}

harper_sniper_nag()
{
	level endon( "low_road_snipers_cleared" );
	
	while ( true )
	{
		level.harper say_dialog( "harp_dammit_taking_fire_0" );
		wait 4;
		level.harper say_dialog( "harp_they_ve_got_fucking_0" );
		wait 3;
		level.harper say_dialog( "harp_behind_the_signs_0" );
		wait 3;
//		level.harper say_dialog( "harp_there_s_a_few_stragg_0" );
//		wait 4;
	}	
}

low_road_pmc_vo_callouts()
{
	a_vo_callouts = [];
	a_vo_callouts[ "generic" ]	= array( "pmc2_hold_the_blockade_0", "pmc2_keep_them_back_0", "pmc2_get_me_a_clip_0", "pmc2_i_need_ammo_0", "pmc1_dammit_weapon_s_ja_0", 
	                                   "pmc2_die_american_0", "pmc2_fuck_you_0", "pmc2_this_is_payback_0", "pmc1_keep_firing_0", "pmc1_eat_lead_and_die_mo_0", "pmc0_keep_shooting_you_f_0", 
	                                   "pmc1_keep_them_on_the_str_0", "pmc1_we_re_taking_you_dow_0", "pmc3_fuck_man_they_shot_0", "pmc3_i_m_out_0", "pmc3_that_was_close_0", 
	                                   "pmc3_we_can_t_hold_them_o_0", "pmc0_don_t_let_them_move_0", "pmc3_stay_on_them_0", "pmc3_keep_it_together_0", "pmc3_get_on_them_0", "pmc1_bring_them_down_0",
	                                   "pmc2_we_need_more_men_dow_0", "pmc1_bastards_0", "pmc1_we_re_losing_men_0" );
	
	level thread vo_callouts( undefined, "axis", a_vo_callouts, "low_road_snipers_cleared" );	
}

sniper_exit_vo()
{
	kill_all_pending_dialog();
	
//	level.player thread priority_dialog( "sect_clear_get_to_the_v_0" );

//	waittill_dialog_queue_finished();
	level.player DisableWeapons();
	wait 3;
	
	flag_set( "allow_sniper_exit" );
	
	flag_wait( "exit_sniper_player_started" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper priority_dialog( "harp_get_outta_there_sec_0" );
	}
	else
	{
		wait 4;	// pause so the line following plays at the right time.	
	}
	
	level.player priority_dialog( "sect_shiiiiit_0", 1 );
}

last_stand_vo()
{
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "we_got_rpgs_on_the_003", 0, "player_approaches_convoy" );
		//level.player queue_dialog( "keep_them_off_the_007", 3 );
	}
	else
	{
		level.sam queue_dialog( "stay_down_011", 0, "player_approaches_convoy" );
	}
	
	//level.player queue_dialog( "take_cover_by_the_010", 1 );
	
	level.player queue_dialog( "sect_get_on_the_radio_and_0", 2, undefined, "g20_group1_greet_harper_started" );
	level.player queue_dialog( "were_gonna_be_fig_002", 1, undefined, "g20_group1_greet_harper_started" );
	
	level thread last_stand_vo_nag();
	
	if ( !flag( "harper_dead" ) )
	{
		flag_wait( "g20_group1_greet_harper_started" );
		level.harper queue_dialog( "we_gotta_go_now_005" );
		level.harper queue_dialog( "everyone_h_on_my_l_003", 1 );
	}
	
	level.jones queue_dialog( "copy_that_001" );

	trigger_wait( "trig_cougar_enter" );
	
	level.sam queue_dialog( "samu_blue_route_is_go_i_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_punch_it_section_0", 2 );
	}
}

last_stand_vo_nag()
{
	level endon ( "g20_group1_greet_harper_started" );
	
	if ( !flag ( "harper_dead" ) )
	{
		a_nag_lines = array( "take_out_those_dam_004", "keep_them_off_the_007", "we_got_rpgs_on_the_003" );
	
		while ( true )
		{	
			a_nag_lines = array_randomize( a_nag_lines );
			
			foreach ( str_nag_line in a_nag_lines )
			{
				wait RandomFloatRange( 6.0, 9.0 );
				level.harper queue_dialog( str_nag_line );
			}
			
			wait 1;
		}
	}
}

waittill_enemies_by_pillar()
{
	if ( !flag( "low_road_choke_group1_cleared" ) )
	{
		level endon( "low_road_choke_group1_cleared" );
		trigger_wait( "behind_the_pillar" );
	}
}

waittill_enemies_by_bus()
{
	if ( !flag( "low_road_choke_group1b_cleared" ) )
	{
		level endon( "low_road_choke_group1b_cleared" );
		trigger_wait( "by_the_bus" );
	}
}

waittill_player_looking_at_me( str_flag )
{
	self endon( "death" );
	
	while ( !level.player is_ads() || !level.player is_looking_at( self, .98 ) )
	{
		wait .2;
	}
	
	flag_set( str_flag );
}

g20_group1_ss1()
{
	level.ai_g20_ss1 = self;
	self.takedamage = false;
	self maps\_anim::anim_set_blend_in_time( .3 );
	self maps\_anim::anim_set_blend_out_time( .3 );
}

remove_sight_blocker()
{
	//flag_wait_any( "rappel_option", "sniper_option" );
	m_blocker = GetEnt( "sniper_rappel_sight_blocker", "targetname" );
	m_blocker Delete();
}

last_stand_main()
{
	set_ai_group_cleared_count( "low_road_last_stand", 2 );
	
	level.harper = init_hero( "harper" );
	
	if ( flag( "harper_dead" ) )
	{
		level.sam say_dialog( "clear_006" );
		level.sam say_dialog( "everyone_h_get_to_013" );		
	}
	
	if ( flag( "sniper_option" ) )
	{
		exit_sniper();
	}
	
	trigger_on( "start_last_stand" );
	trigger_wait( "start_last_stand" );
	
	level thread last_stand_vo();
	//level thread help_kill_dudes();
	
	set_objective( level.OBJ_POTUS, undefined, "done" );
	
	spawn_manager_enable( "sm_low_road_launcher" );
	
	waittill_ai_group_cleared( "low_road_last_stand" );

	level.disable_straffing_drone_shooting = undefined;
	set_straffing_drones( "straffing_drone", "last_stand_drone_strafe_org", 1000, undefined, .4, 1.8 );
	
	wait 3;	// give drones time to populate a little
	
	array_thread( GetAIArray( "axis" ), ::bloody_death );
	
	//level.harper thread say_dialog( "clear_006" );
	
	level thread g20_group_meetup();
	
	level delay_thread( 3, ::trigger_use, "gl_rpgs_trig" );
	level delay_thread( 6, ::g20_attackers );
	
	wait 8; // waits until Harper finishes talking to g20 guy
	
	enter_cougar();
	freeway_cleanup();
	
	set_straffing_drones( "off" );
	
	set_objective( level.OBJ_DRIVE );
	
	spawn_manager_kill( "sm_g20_attackers" );
}

g20_attackers()
{
	//spawn_manager_enable( "sm_g20_attackers" );
	
	level waittill( "first_drone_strike" );
	
	spawn_manager_kill( "sm_g20_attackers" );
	
	array_thread( GetEntArray( "g20_attackers_ai", "targetname" ), ::bloody_death );
}

help_kill_dudes()
{
	level.ai_g20_ss1.perfectaim = true;
	level.harper.perfectaim = true;
	
	wait 20;
	
	level.ai_g20_ss1.perfectaim = false;
	level.harper.perfectaim = false;
}

freeway_cleanup()
{
	//array_func( GetAIArray( "axis" ), ::self_delete );
	
	cleanup_array( level.heroes );
	cleanup( level.ai_g20_ss1 );
	
	// delete all drones to make sure we have room for civ cars on freeway durring drive
	
	level notify( "spawn_aerial_vehicles" ); // stop additional planes from spawning
	
	a_vehicles = GetVehicleArray();
	foreach ( veh in a_vehicles )
	{
		if ( IsSubStr( veh.model, "drone" ) || IsSubStr( veh.model, "f35" ) )
		{
			veh thread delete_when_not_looking_at();
		}
	}
}

enter_cougar()
{
	level thread drive_save_game();
			
	set_objective( level.OBJ_HIGHWAY, undefined, "done" );
	set_objective( level.OBJ_DRIVE, level.veh_player_cougar GetTagOrigin( "tag_player" ), &"LA_SHARED_OBJ_DRIVE" );
	get_player_cougar() Attach( "veh_t6_mil_cougar_interior_obj", "tag_body_animate_jnt" );
	
	ENTER_DIST = 100 * 100;
	
	v_tag_pos = level.veh_player_cougar GetTagOrigin( "tag_enter_driver" );
	v_tag_ang = level.veh_player_cougar GetTagAngles( "tag_enter_driver" );
	v_enter = AnglesToRight( v_tag_ang );
	
	level thread toggle_trig_cougar_enter();
	
	trigger_wait( "trig_cougar_enter" );
	
	level thread load_gump( "la_1_gump_1d" );
	
	trigger_use( "drive_start_vehicles_trig" );

	//level.player PlaySound ("evt_cougar_enter");
	
	get_player_cougar() Detach( "veh_t6_mil_cougar_interior_obj", "tag_body_animate_jnt" );
	
	level.player magic_bullet_shield();
			
	level thread run_scene_and_delete( "enter_cougar_potus" );
	run_scene_and_delete( "enter_cougar" );
	flag_set( "player_in_cougar" );
	
	//sound snapshot for being in the cougar
	clientnotify ("ssd");
	
	//TO DO: Music should actually get set as soon as you hit the gas pedal.
	level thread maps\_audio::switch_music_wait("LA_1_DRIVE", 2);
	
	level.player SetClientDvar( "player_sprintUnlimited", 0 );
	
	level.player stop_magic_bullet_shield();
}

drive_save_game()
{
	flag_wait( "la_1_gump_1d" );
	autosave_by_name( "drive" );
}

toggle_trig_cougar_enter()
{
	level endon( "entered_cougar" );
	
	while ( true )
	{
		trigger_on( "trig_cougar_enter" );
		level.player waittill ( "grenade_pullback" );
		trigger_off( "trig_cougar_enter" );
		level.player waittill ( "grenade_fire", grenade );
	}
}

low_road_first_rpg()
{
	self endon( "death" );
	
	if ( IsDefined( self.script_string ) )
	{
		self custom_ai_weapon_loadout( "usrpg_magic_bullet_sp" );
		self waittill( "goal" );
		e_target = get_ent( self.script_string );
		self shoot_at_target( e_target );
		self.a.allow_shooting = false;
		self custom_ai_weapon_loadout( "usrpg_sp" );
		wait 5;
		self.a.allow_shooting = true;
	}
}

low_road_bus_rpg()
{
	self thread waittill_bus_rpg_fire();
	delay_thread( 2, ::flag_set, "bus_rpg_guy_spawned" );
	self waittill( "death" );
	flag_set( "bus_rpg_guy_dead" );
}

waittill_bus_rpg_fire()
{
	self endon( "death" );
	self waittill( "shoot" );
	flag_set( "bus_rpg_guy_fired" );
	self thread waittill_player_looking_at_me( "player_looking_at_rpg_bus_guy" );
}

left_side_truck()
{
	self endon( "death" );
	self waittill( "unload" );
	
	ai1 = GetEnt( "terrorist_rappel_left1_ai", "targetname" );
	ai1 thread left_rappel( 1 );
	
	ai2 = GetEnt( "terrorist_rappel_left2_ai", "targetname" );
	ai2 thread left_rappel( 2 );
	
	ai3 = GetEnt( "terrorist_rappel_left3_ai", "targetname" );
	ai3 thread left_rappel( 3 );
	
	ai4 = GetEnt( "terrorist_rappel_left4_ai", "targetname" );
	ai4 thread left_rappel( 4 );

	array_wait( array( ai1, ai2, ai3, ai4 ), "death" );
	flag_set( "left_side_rappel_guys_dead" );
}

low_road_truck_1()
{
	self waittill( "death" );
	level thread drop_car();
}

drop_car()
{
	level.player playsound( "evt_sniper_car_fall_start" );
	level thread run_scene_and_delete( "low_road_car_fall" );
	level notify( "fxanim_sniper_freeway_start" );
}

left_rappel( num )
{
	self endon( "death" );
	self waittill( "jumpedout" );
	
	self thread waittill_player_looking_at_me( "player_looking_at_rappel_guy" );
	
	self thread run_scene_and_delete( "terrorist_rappel_left" + num );
	
	self waittill( "goal" );	
	flag_set( "left_side_rappel_started" );
	
	scene_wait( "terrorist_rappel_left" + num );
	
//	if ( flag( "sniper_option" ) )
//	{
		self set_spawner_targets( "low_road_attack_nodes01" );
//	}
//	else
//	{
//		self SetGoalVolumeAuto( level.goalVolumes[ "goal_volume_left_side" ] );
//	}
}

spawn_func_low_road_sniper()
{
	self endon( "death" );
	trigger_wait( "trig_player_approaches_convoy" );
	self Delete();
}

spawn_func_rappel()
{
	// Clear Goal Volumes when player chooses rappel option so the AI can move around wherever they need to
	self ClearGoalVolume();
}

hillary_think()
{
	self endon( "death" );

	self SetThreatBiasGroup( "potus" );
	
	self set_ignoreme( true );
	
	scene_wait( "grouprappel" );
	
	self set_ignoreme( false );
	self.allowdeath = true;
	//self stop_magic_bullet_shield();	// TODO: removed for demoing, put this back in when event is finished
	
	self thread potus_fail();
	
	/#
	level endon( "stop_god_mode_potus_protection" );
	
	while ( true )
	{
		if ( IsGodMode( level.player ) )
		{
			self magic_bullet_shield();
		}
		else
		{
			//self stop_magic_bullet_shield();
		}
		
		wait 1;
	}
	#/
}

potus_fail()
{
	level endon( "player_in_cougar" );
	self waittill( "death" );
	missionfailedwrapper( &"LA_SHARED_PROTECT_FAIL" );
}

// Checks if the player backtracked after the SAM
pre_rappel_backtrack_check()
{
	level endon( "grouprappel_done" );
	trigger_wait( "pre_rappel_backtrack_trig" );
	missionfailedwrapper( &"GAME_MISSIONFAILED" );
}

post_rappel_backtrack_check()
{
	level endon( "player_driving" );
	trigger_wait( "post_rappel_backtrack_trig" );
	missionfailedwrapper( &"GAME_MISSIONFAILED" );
}

waittill_player_choice()
{
	str_option = level waittill_any_return( "sniper_option", "rappel_option" );
	spawner_delete( str_option );
}

battle_flow()
{
	set_ai_group_cleared_count( "low_road_choke_group1", 2 );
	thread temp_group_count();
	//set_ai_group_cleared_count( "low_road_choke_group2", 1 );
	
	waittill_player_choice();
	
	cleanup_array( GetEntArray( "terrorist_rappel_left1", "targetname" ) );
	cleanup_array( GetEntArray( "terrorist_rappel_left2", "targetname" ) );
	cleanup_array( GetEntArray( "terrorist_rappel_left3", "targetname" ) );
	cleanup_array( GetEntArray( "terrorist_rappel_left4", "targetname" ) );
	cleanup_array( GetEntArray( "low_road_bigrig_entry", "targetname" ) );
	
	level thread sniper_rappel_vo();
	
	//TUEY - Change the music out for the event.
	setmusicstate ("LA_1_SNIPER_RAPEL");
	
	level.disable_straffing_drone_shooting = true;
	
	level thread g20_cougar();
	
	delay_thread( 10, ::trigger_use, "low_road_move_up_1" );	// spawn RPG guys
	
	if ( flag( "rappel_option" ) )
	{
		delay_thread( 8, ::drop_car );
	}
	
	if ( flag( "sniper_option" ) )
	{
		add_spawn_function_veh( "low_road_truck_1", ::low_road_truck_1 );
		
		//delay_thread( 23, ::trigger_use, "sm_low_road_first_guys" );
//		simple_spawn_single( "fakey_dude_1", ::fakey_dude );
		
		//add_flag_function( "grouprappel_done", ::trigger_use, "sm_low_road_first_guys" );
		
		//delay_thread( 5, ::trigger_use, "veh_low_road_left_side" );	// spawn left side RPG truck
	}
	else
	{
		trigger_use( "low_road_high_right_rappel" );	// TODO: remove this when this guy is added to animation
		
		//delay_thread( 5, ::trigger_use, "sm_low_road_first_guys" );
	}
	
	delay_thread( 5, ::fxanim_sniper_drone_crash_start );
	
//	if ( !PRESS_DEMO )
//	{
//		delay_thread( 12, ::trigger_use, "veh_low_road_left_side_sniper" );	// spawn left side RPG truck
//	}
	
	//HACK: PUT THIS BACK IN AFTER ADDING THE SPAWNER BACK IN
	//delay_thread( 23, ::run_scene_and_delete, "low_road_rpg_guy_on_bus" );
	
	level.hillary.ignoreme = true;
	
	grouprappel();
	
	level.hillary.ignoreme = false;
	
	level thread potus_cover();
	
	//level thread vo_low_road_nag();
	
	delay_thread( 25, ::rush_potus );
	level thread low_road_fail_timer( 10, "low_road_group_1_cleared" );
	
	level thread autosave_by_name( "choke_1" );
	
	add_trigger_function( "low_road_debris_fall", ::freeway_chunks_fall );
	
	waittill_ai_group_cleared( "low_road_choke_group1" );
	trigger_use( "low_road_move_up_2" );
	
	level notify( "low_road_group_1_cleared" );
	
	level thread noharper_open_cougar_door();
	
//	if ( !PRESS_DEMO )
//	{	
//		if ( flag( "sniper_option" ) )
//		{
//			trigger_use( "low_road_bigrig_entry" );
////			simple_spawn_single( "fakey_dude_2", ::fakey_dude );
//		}
//		
//		flag_wait( "low_road_choke_group1b_cleared" );
//		
//		//if ( flag( "sniper_option" ) )
//		//{
//			//trigger_use( "sm_low_road_left_side_flood" );
//			//waittill_ai_group_count( "ai_group_low_road_left_side_flood", 2 );
//		//}
//	}
//	else
//	{
		flag_set( "low_road_choke_group1b_cleared" );
//	}
		
	trigger_use( "low_road_move_up_3" );
	trigger_use( "low_road_move_up_3b" );
	if ( flag( "rappel_option" ) )
	{
		delay_thread( 8, ::rappel_drop_signs );
	}
	
	//level thread identify_low_road_snipers();
	
	level thread run_scene( "terrorist_rappel1" );
	level thread run_scene( "terrorist_rappel2" );
	run_scene( "terrorist_rappel3" );
	
	level thread push_through_vo();
		
	delay_thread( 55, ::rush_potus );	// TODO: possibly bring this back down once there is a plan for the rushers
	level thread low_road_fail_timer( 60, "low_road_group_2_cleared" );
	
	level thread autosave_by_name( "choke_2" );
	
	while ( get_ai_group_count( "low_road_snipers" ) )
	{
		wait 0.1;	
	}
	
	level notify ( "low_road_snipers_cleared" );	
	level notify ( "low_road_group_2_cleared" );
	
	level thread clean_up_group2();
	
	level thread finish_potus_objective();	
	level thread run_to_convoy();
}

rappel_drop_signs()
{	
	level notify( "fxanim_road_sign_snipe_03_start" );
	wait RandomFloatRange( 0.5, 1.5 );
	level notify( "fxanim_road_sign_snipe_04_start" );
}

low_road_fail_timer( n_time, str_ender )
{
	level endon( str_ender );
	
//	thread test_timer( str_ender );
	
	wait n_time;
	
	missionfailedwrapper( &"LA_SHARED_PROTECT_FAIL" );
}

test_timer( str_ender )
{
	level endon ( str_ender );
	n_count = 0;
	while ( true )
	{
		wait 1;
		n_count++;
		iprintln( n_count );
	}
}

clean_up_group2()
{
	a_ai = get_ai_group_ai( "low_road_choke_group2" );
	array_thread( a_ai, ::clean_up_group2_ai );
}

clean_up_group2_ai()
{
	self endon( "death" );
	
	wait RandomFloatRange( 0.5, 5.0 );
	
	self bloody_death();
}

low_road_bigrig_enter()
{
	level thread run_scene_and_delete( "freeway_bigrig_entry" );
	wait 1;
	a_ai = get_ais_from_scene( "low_road_choke_group1" );
	
	foreach( ai_guy in a_ai )
	{
		a_ai.aigroup = "low_road_choke_group1";	
	}
}

temp_group_count()
{
	simple_spawn( "freeway_bigrig_entry_guys" );
	
//	while ( true )
//	{
//		iprintln( get_ai_group_count( "low_road_choke_group1" ) );
//		wait 1;
//	}
}

vo_low_road_nag()
{
	a_nag_lines = array( "harp_dammit_taking_fire_0", "harp_they_ve_got_fucking_0", "harp_behind_the_signs_0" );
	
	wait RandomFloatRange( 6.0, 8.0 );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "snipers__12_‘o_c_005" );
	
		while ( !flag( "low_road_snipers_cleared" ) )
		{
			a_nag_lines = array_randomize( a_nag_lines );
			
			foreach ( str_nag_line in a_nag_lines )
			{
				if ( !flag( "harper_dead" ) )
				{
					level.harper say_dialog( str_nag_line );
				}
			}
			
			wait RandomFloatRange( 6.0, 8.0 );
		}
	}
}

identify_low_road_snipers()
{
	s_start = GetStruct( "identifier_bullet_start", "targetname" );

	CreateThreatBiasGroup( "player" );
	CreateThreatBiasGroup( "sniper" );

	SetThreatBias( "player", "sniper", 15000 );
	
	wait 10;		// give them time to arrive and get into position
	
	level.player SetThreatBiasGroup( "player" );
	
	a_ai = get_ai_group_ai( "low_road_snipers" );

	foreach( ai_sniper in a_ai )
	{
		ai_sniper SetThreatBiasGroup( "sniper" );
	}
	
	while ( get_ai_group_count( "low_road_snipers" ) )
	{
		a_ai = array_randomize(	get_ai_group_ai( "low_road_snipers" ) );
		
		n_shots = RandomIntRange( 4, 7 );
		for( i = 0; i < n_shots; i++ )
		{
			v_end_point = a_ai[0].origin;
			v_end_point = ( v_end_point[0] + RandomIntRange( -128, 128 ), v_end_point[1], v_end_point[2] - RandomIntRange( -24, 48 ) );
			MagicBullet( "avenger_side_minigun", s_start.origin, v_end_point );
			wait RandomFloatRange( .1, .4 );
		}
		
		wait RandomIntRange( 2, 5 );
	}
}

grouprappel()
{	
	if ( flag( "sniper_option" ) )
	{
		add_scene_properties( "grouprappel_sniper_ter01", "grouprappel_tbone_bigrig" );
		add_scene_properties( "grouprappel_sniper_ter02", "grouprappel_tbone_bigrig" );
		add_scene_properties( "grouprappel_sniper_ter03", "grouprappel_tbone_bigrig" );		
		
		if ( !flag( "harper_dead" ) )
		{
			level thread run_scene_and_delete( "grouprappel_sniper_jack" );
		}
		level thread run_scene_and_delete( "grouprappel_sniper_tbone" );
		level thread run_scene( "grouprappel_sniper_ter01" );
		level thread run_scene( "grouprappel_sniper_ter02" );
		level thread run_scene( "grouprappel_sniper_ter03" );		
		level thread run_scene_and_delete( "grouprappel_sniper" );
		
		wait 1;
		
		a_trailer_ai[0] = get_ais_from_scene( "grouprappel_sniper_ter01" )[0];
		a_trailer_ai[1] = get_ais_from_scene( "grouprappel_sniper_ter02" )[0];
		a_trailer_ai[2] = get_ais_from_scene( "grouprappel_sniper_ter03" )[0];		
		array_thread( a_trailer_ai, ::grouprappel_ignore_until_doors );
		
		level thread bigrig_trailer_ai_nag_vo( a_trailer_ai );
		
		scene_wait( "grouprappel_sniper" );
	}
	else
	{
		add_scene_properties( "grouprappel_ter01", "grouprappel_tbone_bigrig" );
		add_scene_properties( "grouprappel_ter02", "grouprappel_tbone_bigrig" );
		add_scene_properties( "grouprappel_ter03", "grouprappel_tbone_bigrig" );		
		
		if ( !flag( "harper_dead" ) )
		{
			level thread run_scene_and_delete( "grouprappel_jack" );
		}
		level thread run_scene_and_delete( "grouprappel_tbone" );
		level thread run_scene_and_delete( "grouprappel_ter01" );
		level thread run_scene_and_delete( "grouprappel_ter02" );
		level thread run_scene_and_delete( "grouprappel_ter03" );
		level thread run_scene_and_delete( "grouprappel" );
		
		wait 1;
		
		a_trailer_ai[0] = get_ais_from_scene( "grouprappel_ter01" )[0];
		a_trailer_ai[1] = get_ais_from_scene( "grouprappel_ter02" )[0];
		a_trailer_ai[2] = get_ais_from_scene( "grouprappel_ter03" )[0];		
		array_thread( a_trailer_ai, ::grouprappel_ignore_until_doors );
		
		level thread bigrig_trailer_ai_nag_vo( a_trailer_ai );

		scene_wait( "grouprappel" );
	}
	
	flag_set( "grouprappel_done" );
}

// When the doors open, start nagging the player.
//
bigrig_trailer_ai_nag_vo( ai_list )
{
	// wait till the doors open.
	level waittill( "bigrig_trailer_doors_open" );
	
	if ( flag( "harper_dead" ) )
	{
		level.sam say_dialog( "samu_here_they_come_sect_0" );
		level.player say_dialog( "take_cover_by_the_010" );
	}
	else
	{
		level.harper say_dialog( "harp_several_mercs_inside_0" );
	}
	
	wait 2.0;
	
	while ( !flag("low_road_choke_group1_cleared") )
	{
		level.sam say_dialog( "samu_they_re_all_over_us_0" );		
		wait 8.0;
	}
}

grouprappel_ignore_until_doors()
{
	self set_ignoreme( true );
	self DisableAimAssist();
	self magic_bullet_shield();
	
	level waittill( "bigrig_trailer_doors_open" );
	
	self set_ignoreme( false );	
	self EnableAimAssist();
	self stop_magic_bullet_shield();
}

run_to_convoy()
{
	trigger_use( "low_road_move_up_4" );
	//level.player say_dialog( "good_work_people_012" );
	//level.harper say_dialog( "more_up_ahead_009", .5 );
	//level.harper thread say_dialog( "everyone_h_get_to_013", 1 );
	
	//TUEY set 
	//setmusicstate ("LA_1_BRIDGE_SCENE");
	level thread maps\_audio::switch_music_wait("LA_1_BRIDGE_SCENE", 2);
	
	//TUEY set the music to Pre Drive
	level thread maps\_audio::switch_music_wait("LA_1_PRE_DRIVE", 14);
	
	
}

fakey_dude()
{
	self.overrideActorDamage = ::fakey_dude_damage;
}

fakey_dude_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime, boneName )
{
	if ( IsPlayer( eAttacker ) )
	{
		return iDamage;
	}
	
	return 0;
}

fxanim_sniper_drone_crash_start()
{
	s_look = get_struct( "low_road_lookat_pos_right" );
	while ( !level.player is_player_looking_at( s_look.origin, .7, false ) || level.player is_ads() )
	{
		WAIT_FRAME;
	}
	
	level notify( "fxanim_sniper_drone_crash_start" );
}

finish_potus_objective()
{
	waittill_ai_group_count( "low_road_choke_group2", 0 );
	
	level notify( "stop_god_mode_potus_protection" );
	level.hillary magic_bullet_shield();
	
	level thread autosave_by_name( "low_road_cleared" );
	set_objective( level.OBJ_POTUS, undefined, "delete" );
}

freeway_chunks_fall()
{
	level notify( "fxanim_freeway_chunks_fall_start" );
	level.player playsound( "evt_sniper_freeway_debris_explo" );
	s_rumble = get_struct( "low_road_debris_fall_rumble_spot" );
	PlayRumbleOnPosition( "flyby", s_rumble.origin );
	Earthquake( .4, 3, s_rumble.origin, 5000);
}

#define G20_FAIL_TIME 90

g20_cougar()
{
	vh_cougar = GetEnt("g20_group1_cougar3", "targetname");
	vh_cougar SetCanDamage( false );
	
	/# debug_timer(); #/
		
	flag_wait_or_timeout( "low_road_move_up_4", G20_FAIL_TIME );
	level notify( "g20_cougar_wait_done" );
	
	if ( flag( "low_road_move_up_4" ) )
	{
		level notify( "low_road_g20_saved" );
		SetDvar( "la_G20_1_saved", 1 );
	}
	else
	{
//		trigger_on( "t_killl_g20_group1" );
//		trigger_wait( "t_killl_g20_group1" );
		
		//exploder( 205 );	// cougar explodes
		exploder( 330 );
		
		vh_cougar = GetEnt("g20_group1_cougar3", "targetname");
		
		vh_cougar SetCanDamage( true );
		RadiusDamage(vh_cougar.origin, 64, vh_cougar.health * 2, vh_cougar.health * 2);
		
		level thread run_scene_and_delete( "g20_fail" );
		level.player queue_dialog( "were_too_late_008", 1 );
	}
}

g20_cougar_nag_vo()
{
	level endon( "g20_cougar_wait_done" );
	
	if ( !flag( "harper_dead" ) )
	{
		a_nag_lines = array( "harp_they_ve_got_rpgs_tar_0", "harp_they_ve_got_fucking_0", "harp_dammit_taking_fire_0" );
	}
	else
	{
		a_nag_lines = array( "samu_they_re_pinned_on_th_0", "samu_i_don_t_know_if_we_c_0", "keep_covering_the_002", "stay_in_cover_003" );
	}
	
	while ( true )
	{	
		a_nag_lines = array_randomize( a_nag_lines );
		
		foreach ( str_nag_line in a_nag_lines )
		{
			wait RandomFloatRange( 4.0, 8.0 );
			level.player say_dialog( str_nag_line );
		}
	}
}

spawner_delete( str_option )
{
	str_disable = ( str_option == "sniper_option" ? "rappel_option" : "sniper_option" );
	
	a_spawners = GetSpawnerArray();
	foreach ( sp in a_spawners )
	{
		if ( IS_EQUAL( sp.groupname, str_disable ) )
		{
			sp Delete();
		}
	}
	
	a_spawners = GetVehicleSpawnerArray();
	foreach ( sp in a_spawners )
	{
		if ( IS_EQUAL( sp.groupname, str_disable ) )
		{
			sp Delete();
		}
	}	
	
	a_nodes = GetNodeArray( str_disable, "script_noteworthy" );
	foreach ( node in a_nodes )
	{
		SetEnableNode( node, false );
	}
	
}

push_through_vo()
{
	wait 4;
	
	if ( !flag( "low_road_choke_group2_cleared" ) )
	{
		//level.player thread say_dialog( "push_through_they_004" );
	}
}

potus_cover()
{
	level.hillary endon( "death" );
	
	cover_1();
	flag_wait( "low_road_move_up_2" );
	cover_2();
	flag_wait( "low_road_move_up_3" );
	cover_3();
	flag_wait( "low_road_move_up_4" );
	cover_convoy();
}

cover_1()
{
	level thread run_scene_and_delete( "group_cover_idle1" );
}

cover_2()
{
	level.hillary.ignoreme = true;
	//level.harper say_dialog( "jones_you_ready_t_007" );
	//level.harper thread say_dialog( "okay__go_008", .5 );
	
	run_scene_and_delete( "group_cover_go2" );
	
	level thread cover_2_optional_vo();
	
	level thread run_scene_and_delete( "group_cover_idle2" );
	level.hillary.ignoreme = false;

	level thread bus_react();
}

cover_2_optional_vo()
{
	if( flag( "harper_dead" ) && !flag( "low_road_complete" ) )
	{
		level.sam say_dialog( "stay_down_011" );
	}
}

bus_react()
{
	level endon( "group_cover_go3_started" );
	
	while ( true )
	{
		level waittill( "bus_rock" );
		run_scene( "group_cover_bus_react" );
	}
}

cover_3()
{
	level.hillary.ignoreme = true;
	
	run_scene_and_delete( "group_cover_go3" );
		
	level thread run_scene_and_delete( "group_cover_idle3" );
	level.hillary.ignoreme = false;
	
	level thread cover_3_optional_vo();
	
	trigger_on( "low_road_debris_fall" );
	trigger_wait( "low_road_debris_fall" );
	
	// TODO: play group reaction scene to debris fall
}

cover_3_optional_vo()
{
	level endon( "low_road_snipers_cleared" );
	//level.player say_dialog( "keep_covering_the_002", 1.5 );
	
	if( flag( "harper_dead" ) && !flag( "low_road_complete" ) )
	{
		level.sam thread say_dialog( "protect_the_presid_001" );
	}
}

spawn_fun_sniper_van()
{
	self endon( "death" );
	self waittill( "unload" );
	//level.harper say_dialog( "snipers__12_?o_c_005", 1 );
	//level.player thread say_dialog( "stay_down_011", 1 );
}

cover_convoy()
{
	level.hillary.ignoreme = true;
	run_scene_and_delete( "group_to_convoy" );
	level thread run_scene_and_delete( "group_convoy_loop" );
	
	if ( flag( "harper_dead" ) )
	{
		level.sam say_dialog( "take_cover_by_the_010" );
	}
}

rush_potus()
{
	a_enemies = get_rush_enemies();

	while ( a_enemies.size > 0 )
	{
		a_enemies = remove_dead_from_array( a_enemies );
		if ( a_enemies.size > 0 )
		{
			enemy = RANDOM( a_enemies );

			a_rush_goal_nodes = GetNodeArray( "low_road_rush_node", "targetname" );
			nd_goal = getclosest( level.hillary.origin, a_rush_goal_nodes );
			
			enemy.goalradius = 300;
			enemy SetGoalNode( nd_goal );
			
			wait RandomFloatRange( 4, 4 + a_enemies.size );
		}
	}
}

get_rush_enemies()
{
	e_volume1 = level.goalVolumes[ "goal_volume_left_side" ];
	e_volume2 = level.goalVolumes[ "goal_volume_right_side" ];
	
	a_rush_enemies = [];
	a_enemies = GetAIArray( "axis" );
	foreach ( enemy in a_enemies )
	{
		if ( ( IsDefined( enemy.targetname ) && IsSubStr( enemy.targetname, "fakey_dude" ) ) || IsSubStr( enemy.classname, "rpg" ) )
		{
			continue;
		}
				
		if ( enemy IsTouching( e_volume1 ) || enemy IsTouching( e_volume2 ) )
		{
			ARRAY_ADD( a_rush_enemies, enemy );
		}
		else if ( IS_EQUAL( enemy.script_aigroup, "ai_group_low_road_left_side_flood" ) )
		{
			ARRAY_ADD( a_rush_enemies, enemy );
		}
		else if ( IS_EQUAL( enemy.script_aigroup, "ai_group_low_road_right_side_flood" ) )
		{
			ARRAY_ADD( a_rush_enemies, enemy );
		}
	}
	
	return a_rush_enemies;
}

attack_potus()
{
	if ( flag( "sniper_option" ) )
	{
		// override goal volume for sniper option so they can run around anywhere
		//self SetGoalVolumeAuto( level.goalVolumes[ "goal_volume_low_road" ] );
	}
	
	self SetThreatBiasGroup( "potus_rushers" );
	self.aggressivemode = true;
	self.canflank = true;
}

g20_group_meetup()
{
	level endon( "player_in_cougar" );
	
	level thread run_scene( "cougar_drive_wires" );
	
	if ( !flag( "harper_dead" ) )
	{
		level thread run_scene_and_delete( "g20_group1_greet_harper" );
		level delay_thread( .5, ::run_scene_and_delete, "g20_group1_greet", .5 );
			
		level.harper waittill( "goal" );
		level.veh_player_cougar SetAnim( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 1 ); // open the door for harper
			
		scene_wait( "g20_group1_greet_harper" );
		run_scene_and_delete( "harper_wait_in_cougar" );
	}
	else
	{
		level.sam say_dialog( "samu_we_have_to_go_now_0" );
		level.player say_dialog( "sect_get_to_the_trucks_0" );
//		level.veh_player_cougar SetAnim( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 1 ); // open the door for harper
	}
}

noharper_open_cougar_door()
{
	if ( flag( "harper_dead" ) )
	{
		veh_player_cougar = get_player_cougar();
		veh_player_cougar SetAnim( %vehicles::v_la_03_12_entercougar_cougar, 1, 0, 1 ); // open the door if harper is dead
	}
}

sniper_rappel_options()
{
	level thread rappel_option();
	level thread sniper_option();
	
	flag_wait_any( "rappel_option", "sniper_option" );
	
	level.player EnableHealthShield( true );
	level.enable_straffing_drone_missiles = undefined;
	
	set_objective( level.OBJ_SNIPE, undefined, "delete" );
	set_objective( level.OBJ_RAPPEL, undefined, "delete" );
	
	set_objective( level.OBJ_HIGHWAY );
	set_objective( level.OBJ_POTUS, level.hillary, "protect" );
	
	// Now that they've chosen their option, hold the weapon in the combat ready position.
	level.player SetLowReady( false );
}

sniper_rappel_choice_fail()
{
	level endon( "sniper_option" );
	level endon( "rappel_option" );
	
	wait 15;
	
	level.player EnableHealthShield( false );
	level.enable_straffing_drone_missiles = true;
}

sniper_option()
{
	level endon( "rappel_option" );
	
	level.player waittill_player_has_sniper_weapon();
	flag_set( "player_has_sniper_weapon" );
	
	t_sniper = GetEnt( "sniper_trigger", "targetname" );
	set_objective( level.OBJ_SNIPE, t_sniper.origin, &"LA_SHARED_OBJ_SNIPE" );
	
	t_sniper trigger_wait();
	
	level.player switch_player_to_sniper_weapon();
	
	flag_wait( "grouprappel_done" );
	
	//run_scene_and_delete( "low_road_rpg_guy_on_bus" );
	
	waittill_ai_group_cleared( "low_road_choke_group2" );
	waittill_ai_group_cleared( "low_road_snipers" );
}

exit_sniper()
{
	level thread sniper_exit_vo();
	
	set_objective( level.OBJ_RAPPEL2, get_scene_start_pos( "exit_sniper_player", "player_body" ) );
	
	flag_wait( "allow_sniper_exit" );
	
	trigger_on( "sniper_fastrope_trigger" );
	trigger_wait( "sniper_fastrope_trigger" );
	
	set_objective( level.OBJ_RAPPEL2, undefined, "delete" );
	
	exploder( 311 ); // dust fall
	
	trigger = GetEnt( "kill_trigger_rappel", "targetname" );
	trigger Delete();
		
	flag_set( "started_rappelling" );
	
	level.player magic_bullet_shield();
	
	level thread run_scene_and_delete( "exit_sniper_player", .5 );
	run_scene_and_delete( "exit_sniper" );
	
	flag_set( "done_rappelling" );
	
	t_obj_position = GetEnt( "g20_objective_trigger", "targetname" );
	set_objective( level.OBJ_HIGHWAY, t_obj_position.origin, "breadcrumb" );
	level thread turn_off_breadcrumb_obj();
	
	//level thread exit_sniper_objective();
	
	level.player SetClientDvar( "player_sprintUnlimited", 1 );	
	level thread pause_rpg_guys();
	
	level.player stop_magic_bullet_shield();
	
	level thread vo_low_road_pacing();
}

vo_low_road_pacing()
{
	if ( !flag( "harper_dead" ) )
	{
		level.harper thread queue_dialog( "harp_rpg_right_side_hig_0" );
	}
	wait 4;
	level.player queue_dialog( "sect_agent_samuels_are_0" );
	level.player queue_dialog( "samu_they_re_pinned_on_th_0" );
	level.player queue_dialog( "keep_covering_the_002" );
	level.player queue_dialog( "stay_down_011" );
}

turn_off_breadcrumb_obj()
{
	trigger_wait( "g20_objective_trigger" );
	set_objective( level.OBJ_HIGHWAY, undefined, "remove" );
}

pause_rpg_guys()
{
	a_rpg_guys = GetEntArray( "exit_sniper_rpg_guy_ai", "targetname" );
	foreach ( ai_rpg in a_rpg_guys )
	{
		if ( IsAlive( ai_rpg ) )
		{
			ai_rpg.a.allow_shooting = false;
		}
	}
	
	wait 4;
	
	foreach ( ai_rpg in a_rpg_guys )
	{
		if ( IsAlive( ai_rpg ) )
		{
			ai_rpg.a.allow_shooting = true;
		}
	}
}

rappel_option()
{
	level endon( "sniper_option" );
	
	s_align = get_struct( "align_rappel", "targetname", true );
	s_align.angles = (0, 0, 0);
	
	t_rappel = GetEnt( "rappel_trigger", "targetname" );
	set_objective( level.OBJ_RAPPEL, t_rappel.origin, &"LA_SHARED_OBJ_RAPPEL" );
	
	t_rappel trigger_wait();
	
	level.player magic_bullet_shield();
	
	set_straffing_drones( "straffing_drone", "low_road_drone_strafe_org", 1500, undefined, 4, 5 );

	set_objective( level.OBJ_RAPPEL );
	
	level.player delay_thread( 3, ::switch_player_scene_to_delta );
	
	exploder( 310 ); // dust fall
	
	trigger = GetEnt( "kill_trigger_rappel", "targetname" );
	trigger Delete();
	
	flag_set( "started_rappelling" );
	run_scene_and_delete( "grouprappel_player" );
	flag_set( "done_rappelling" );
	
	level.player stop_magic_bullet_shield();
	
	//wait 1.5;
	//run_scene_and_delete( "low_road_rpg_guy_on_bus" );
}

switch_player_to_delta()
{
	wait 4;
	level.player switch_player_scene_to_delta();
}

return_true()
{
	return true;
}

play_rappel_ambient_FX()
{
	level endon( "rappel_option" );
	level endon( "sniper_option" );
	
	flag_wait( "player_approaches_low_road" );
	
	level thread play_random_gun_shots();
	level thread drone_squibs();
	
	while(1)
	{
		n_index = RandomIntRange( 1 , 4 );
		
		rpg_start = getstruct( "rpg_ambient_shot_start_" + n_index, "targetname" );
		rpg_end = getstruct( "rpg_ambient_shot_end_" + n_index, "targetname" );
		
		//MagicBullet( "usrpg_magic_bullet_sp", rpg_start.origin, rpg_end.origin );
		
		wait RandomFloatRange(3, 6);
	}
}

drone_squibs()
{
	level endon( "rappel_option" );
	level endon( "sniper_option" );
	
	trigger_wait( "trigger_drone_squibs" );
	squibs_start = getstruct( "drone_squibs_1", "targetname" );
	squibs_end = getstruct( "rpg_ambient_shot_end_2", "targetname" );
	
	for( i = 0; i < 10; i++ )
	{
		MagicBullet( "f35_side_minigun", squibs_start.origin, squibs_end.origin + ( 0, 500 - ( i * 50 ), 0 ) );
		wait 0.25;
	}
}

play_random_gun_shots()
{
	level endon( "rappel_option" );
	level endon( "sniper_option" );
	
	while( 1 )
	{
		squibs_start = getstruct( "squibs_start_" + RandomIntRange( 1 , 6 ), "targetname" );
		squibs_end = getstruct( "squibs_target_" + RandomIntRange( 1 , 6 ), "targetname" );
		
		for( i = 0; i < 6; i++ )
		{
			MagicBullet( MAGIC_BULLET_RIFLE, squibs_start.origin, squibs_end.origin );
			
			wait 0.05;
		}
		
		wait RandomFloatRange( .15, .25);
	}
}
