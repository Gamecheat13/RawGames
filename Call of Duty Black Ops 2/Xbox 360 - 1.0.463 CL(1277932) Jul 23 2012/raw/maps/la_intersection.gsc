/*
 * Created by ScriptDevelop.
 * User: bbarnes
 * Date: 1/30/2012
 * Time: 9:07 PM
 *
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_objectives;
#include maps\_turret;
#include maps\_vehicle;
#include maps\la_utility;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#define GUMP "la_1b_gump_2"

autoexec init()
{
	add_flag_function( "looking_down_the_street", ::fa38_landing );
	add_trigger_function( "intersection_backtrack_fail", ::intersection_backtrack_fail );
	add_spawn_function_ai_group( "g20_attackers", ::spawn_func_g20_attackers );
	add_spawn_function_veh( "intersection_last_truck", ::intersection_last_truck );
	
	a_dest = GetEntArray( "destructible", "targetname" );
	foreach ( dest in a_dest )
	{
		if ( IS_EQUAL( dest.script_string, "explosion_car1" ) )
		{
			level.explosion_car1 = dest;
		}
	}
}

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_intersection()
{
	init_hero( "harper" );
	skipto_teleport( "skipto_intersection" );
}

main()
{
	level thread vip_cougar();
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	init_hero( "harper" );
	
	level thread intersection_deathposes();
	run_scene_first_frame( "intersection_bodies" );
	
	level thread simple_spawn( "intersection_ss", ::spawn_func_intersection_ss );
	
	init_vehicles();
	level thread spawn_right_truck();
	
	flag_wait( "intersection_started" );
	spawn_manager_enable( "t_intersection_spawn_manager" );	
	
	level thread intersection_vo();
	
	if ( IsDefined( level.veh_roof_sam ) )
	{
		level.veh_roof_sam Delete();
	}
	
	load_gump( GUMP );
	level thread sam_cougar();
	
	exploder( 500 ); // popin' smoke
	exploder( 10780 ); // hole in building
	level notify( "fxanim_skyscraper02_impact_start" );	// hole in building
	
	level thread autosave_by_name( "intersection_start" );
	
	level thread line_manager();
	level thread save_vip();
	
	set_aerial_vehicles();
	
	level thread drop_building1();
	building_collapse();
	
	la_2_transition();
	
	nextmission();
}


intersection_deathposes()
{
	run_scene_first_frame( "intersectbody_02" );
	run_scene_first_frame( "intersectbody_09" );
	run_scene_first_frame( "intersectbody_12" );
	run_scene_first_frame( "intersectbody_13" );
	run_scene_first_frame( "intersectbody_17" );
	run_scene_first_frame( "intersectbody_25" );
}


intersection_vo()
{
	level endon( "building_collapsing" );
	flag_wait_either( "plaza_vo_done", "player_reached_intersection" );
	
	level thread collapse_vo();
	level thread intersection_vo_pmc_callouts();
	
	level.player queue_dialog( "ande_watch_yourself_down_0" ); // anderson
	level.player queue_dialog( "ande_the_structures_are_b_0" ); // anderson
	level.player queue_dialog( "ande_any_more_drone_strik_0" ); // anderson
	
	queue_dialog_ally( "lpd3_where_the_hell_are_t_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper thread priority_dialog( "harp_we_re_too_late_sect_0", 2, "intersect_vip_cougar_died", "intersect_vip_cougar_saved" );
	}
	else
	{
		level.player thread priority_dialog( "sect_dammit_into_radi_0", 2, "intersect_vip_cougar_died", "intersect_vip_cougar_saved" );
	}
	
	flag_wait_any( "intersect_vip_cougar_died", "intersect_vip_cougar_saved" );
	
	//queue_dialog_enemy( "pmc0_take_down_that_sam_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_they_have_another_gu_0", 0, "intersection_truck_right" );
		level.harper queue_dialog( "harp_take_it_down_0", 0, "intersection_truck_right" );
	}
	
	flag_wait( "do_anderson_landing_vo" );
	
	level.player queue_dialog( "ande_section_i_took_a_0", 2 ); // anderson
	level.player queue_dialog( "how_bad_014" );
	level.player queue_dialog( "im_going_to_have_009" ); // anderson
	level.player queue_dialog( "were_on_our_way_012" );
	
	flag_set ( "ok_to_drop_building1" );
	
	//queue_dialog_enemy( "pmc2_get_to_the_downed_pl_0" );
	//queue_dialog_enemy( "pmc2_they_won_t_fire_on_t_0" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper queue_dialog( "harp_dammit_section_they_0" );
		level.harper queue_dialog( "harp_we_need_to_secure_th_0" );
	}
	
	wait 2;
	flag_set( "ok_to_drop_building" );
}

collapse_vo()
{
	flag_wait( "building_collapsing" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.harper priority_dialog( "harp_awww_shit_the_who_0", 2 );
		level.harper priority_dialog( "everybody_down_001", 2 );
	}
}

intersection_vo_pmc_callouts()
{
	a_intro_vo = array( "pmc1_here_they_come_1", "pmc3_open_fire_0" );
	vo_callouts_intro( undefined, "axis", a_intro_vo );
	
	a_vo_callouts = [];
	a_vo_callouts[ "generic" ]				= array( "pmc0_don_t_let_them_move_0", "pmc0_get_the_hell_away_0", "pmc0_hit_and_move_hit_a_0", "pmc0_keep_shooting_you_f_0", "pmc1_i_m_hit_0", 
	                                      			"pmc1_bastards_0", "pmc1_we_re_losing_men_0", "pmc1_keep_firing_0", "pmc1_dammit_weapon_s_ja_0", "pmc2_keep_them_back_0", "pmc2_get_me_a_clip_0", 
	                                      			"pmc2_i_need_ammo_0", "pmc2_we_need_more_men_dow_0", "pmc2_hold_the_blockade_0", "pmc3_hit_em_now_0", "pmc3_stay_on_them_0", "pmc3_i_got_him_0", 
	                                      			"pmc3_fuck_man_they_shot_0", "pmc3_i_m_out_0", "pmc3_keep_it_together_0", "pmc3_keep_your_heads_down_0" );
	
	level thread vo_callouts( undefined, "axis", a_vo_callouts, "building_collapsing" );
}

intersection_backtrack_fail()
{
	missionfailedwrapper( &"GAME_MISSIONFAILED" );
}

init_vehicles()
{
	a_vehicles = GetVehicleArray();
	a_destructibles = GetEntArray( "destructible", "targetname" );
	a_vehicles = ArrayCombine( a_vehicles, a_destructibles,true, false );
	
	foreach ( veh in a_vehicles )
	{
		if ( IS_EQUAL( veh.script_noteworthy, "veh_explosion" ) )
		{
			veh thread launch_car_on_deah();
		}
	}
	
	//level thread spawn_vehicles_from_targetname( "intersection_cars" );
}

spawn_right_truck()
{
	flag_wait_any( "intersect_vip_cougar_died", "intersect_vip_cougar_saved" );
	
	flag_wait( "looking_down_the_street" );
	
	if ( !flag( "right_truck_spawned" ) )
	{
		trigger_use( "right_truck_trigger" );
	}
}

launch_car_on_deah()
{
	self waittill( "death" );
	vehicle_explosion_launch();
}

set_aerial_vehicles()
{
	a_av_allies_spawner_targetnames = array( "f35_fast" );
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	//level thread spawn_aerial_vehicles( 45, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	//level thread fxanim_aerial_vehicles( 23 );
}

#define INTERSECTION_FALLBACK_KILL_COUNT 8

line_manager()
{
	flag_wait( "player_reached_intersection" );
	
	a_volumes = GetEntArray( "goal_volume_intersection", "targetname" );
	a_volumes = sort_by_script_int( a_volumes, true );
	
	add_spawn_function_group( "sp_intersection1", "targetname", ::spawn_func_intersection_fallback_ai );
	
	foreach ( volume in a_volumes )
	{
		level.current_intersection_goal_volume = volume;
		level notify( "intersection_goal_volume_update" );
		
		if ( IsDefined( volume.target ) )
		{
			trigger_use( volume.target );
		}
		
		level.intersection_kill_count = 0;
		
		wait 1;
		
		waittill_fallback( volume );
	}
}

waittill_fallback( volume )
{
	level endon( "intersection_kill_update" );
	level.player waittill_player_touches( volume );
}

spawn_func_intersection_fallback_ai()
{
	while ( IsAlive( self ) )
	{
		self SetGoalVolumeAuto( level.current_intersection_goal_volume );
		waittill_any_ents( level, "intersection_goal_volume_update", self, "death" );
	}
	
	level.intersection_kill_count++;
	
	if ( level.intersection_kill_count > INTERSECTION_FALLBACK_KILL_COUNT )
	{
		level notify( "intersection_kill_update" );
	}
}

vip_cougar()
{
	level.vh_vip_cougar = spawn_vehicle_from_targetname_and_drive( "vip_cougar" );
	level.vh_vip_cougar.overrideVehicleDamage = ::cougar_damage_override;
	level.vh_vip_cougar.death_anim = %vehicles::v_la_03_11_g20failure_cougar;
	
	level.vh_vip_cougar.health = 3000;
	level.vh_vip_cougar waittill( "death" );
		
	n_cougar_origin = level.vh_vip_cougar.origin;
	level.vh_vip_cougar RadiusDamage( n_cougar_origin, 512, 512, 512, undefined, "MOD_EXPLOSIVE");
	
	flag_set( "intersect_vip_cougar_died" );
}

cougar_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( str_means_of_death == "MOD_PROJECTILE" )
	{
		n_damage = 1000;
	}
	else
	{
		n_damage = 0;
	}
	
	return n_damage;
}

spawn_func_intersection_ss()
{
	self endon( "death" );
	self magic_bullet_shield();
	self thread intersection_ss_turn_off_mbs_when_player_gets_there();
	level.vh_vip_cougar waittill( "death" );
	self intersection_ss_kill();
	trigger_use( "color_move_after_vip_event" );
}

intersection_ss_turn_off_mbs_when_player_gets_there()
{
	self endon( "death" );
	flag_wait( "player_reached_intersection" );
	intersection_ss_turn_off_mbs();
}

intersection_ss_kill()
{
	if ( !IS_EQUAL( self.script_string, "intersection_ss_hero" ) )
	{
		self ragdoll_death();
	}
}

intersection_ss_turn_off_mbs()
{
	if ( !IS_EQUAL( self.script_string, "intersection_ss_hero" ) )
	{
		self stop_magic_bullet_shield();
	}
}


spawn_func_g20_attackers()
{
	self endon( "death" );
	self waittill( "goal" );
	
	shoot_at_target_untill_dead( level.vh_vip_cougar, undefined, 2 );
}

save_vip()
{
	level thread run_scene_and_delete( "ssathanks_ssa_idle" );
	
	level.vh_vip_cougar.takedamage = false;
	flag_wait( "player_reached_intersection" );
	level.vh_vip_cougar.takedamage = true;
	
	flag_wait_either( "intersect_vip_cougar_died", "g20_attackers_cleared" );
	
	if ( !flag( "intersect_vip_cougar_died" ) )
	{
		flag_set( "intersect_vip_cougar_saved" );
		level.vh_vip_cougar.takedamage = false;
		level thread save_vip_vo();
		level thread run_scene_and_delete( "ssathanks_harper" );
		level.harper waittill( "goal" );
		end_scene( "ssathanks_ssa_idle" );
		run_scene_and_delete( "ssathanks_ssa" );
	}
	else
	{
		level thread say_dialog( "sect_dammit_into_radi_0"  );
	}
	
	trigger_use( "color_move_after_vip_event" );
}

save_vip_vo()
{
	level.player say_dialog( "you_got_here_just_006" );
	level.player say_dialog( "you_fight_throu_007" );
}

sam_cougar()
{
	vh_sam = spawn_vehicle_from_targetname( "sam_cougar" );
	vh_sam.takedamage = false;
	
	level endon( "stop_sam_cougar" );
	
	vh_sam = GetEnt( "sam_cougar", "targetname" );
	vh_sam set_turret_ignore_line_of_sight( true, 2 );	
	e_target = spawn_model( "tag_origin" );
	
	while ( true )
	{
		e_target.origin = ( vh_sam.origin + ( 0, 0, 5000 ) ) + ( VectorNormalize( AnglesToForward( vh_sam.angles ) ) * 7000 ) + random_vector( 2000 );
		vh_sam set_turret_target( e_target, (0, 0, 0), 2 );
		vh_sam fire_turret_for_time( 2, 2 );
		wait 6;
	}
}

fa38_landing( trig, e_who )
{
	load_gump( GUMP );
	
	vh_fa38 = spawn_vehicle_from_targetname( "f35_vtol" );
	vh_fa38 HidePart( "tag_landing_gear_doors" );
	vh_fa38 Attach( "veh_t6_air_fa38_landing_gear", "tag_landing_gear_down" );
	vh_fa38 thread fa38_stop_snd();
	
	level thread run_scene_and_delete( "fa38_landing" );
	
	wait 6;
	flag_set( "do_anderson_landing_vo" );
}

fa38_stop_snd()
{
	wait (18);
	self vehicle_toggle_sounds (false);
}
	
intersection_last_truck()
{
	self waittill( "kill_car" );
	
	if ( level.explosion_car1.health > 0 )
	{
		self shoot_turret_at_target( level.explosion_car1, -1, undefined, 1 );
	}
	
	self enable_turret( 1 );
}

drop_building1()
{
	flag_wait_array( array( "ok_to_drop_building1", "looking_down_the_street" ) );
	
	//SOUND - Shawn J
	//iprintlnbold ("drop?");
	PlaySoundAtPosition ("evt_small_bldg_collapse", (9602, 2746, 293));
	
	Earthquake( .2, 1, level.player.origin, 20000 );
	level notify( "fxanim_bldg_convoy_block_start" );
}
	
building_collapse()
{
	flag_wait_array( array( "ok_to_drop_building", "looking_down_the_street" ) );
	
	//level notify( "fxanim_drone_skyscraper_crash_start" );	
	//level waittill( "exploder10780" );	// drone crash
	//level notify( "fxanim_skyscraper02_impact_start" );	// drone impact
	
	//SOUND - Shawn J
	level.player playsound( "evt_bldg_collapse_end" );
	
	//C. Ayers - shut off music for building collapse ending
	setmusicstate( "LA_1B_BUILDING_COLLAPSE");
	
	level.player magic_bullet_shield();
	level notify( "stop_sam_cougar" );
	
	level notify( "fxanim_skyscraper02_start" );
	flag_set( "building_collapsing" );
	
	Earthquake( .3, 12, level.player.origin, 20000 );
	level.player PlayRumbleOnEntity( "la_1b_building_collapse" );
	
	delay_thread( 3, ::set_player_invulnerable );	
	
	wait 10;
	
	//Eckert - Fade out sound
	level clientnotify( "fade_out" );

	level.player hide_hud();
	wait(2);
	screen_fade_out( 3 );
	StopAllRumbles();
}
	
set_player_invulnerable()
{
	level.player EnableInvulnerability();
}

la_2_transition()
{
	e_align = GetEnt( "f35_vtol", "targetname" );
	str_local_player_coordinates = level.player get_relative_position_string( e_align );
	SetDvar( "la_2_player_start_pos", str_local_player_coordinates );
	SetDvar( "la_1_ending_position", 1 );
	
	// did anderson live?
	b_saved_anderson = 0;
	if ( flag( "anderson_saved" ) )
	{
		b_saved_anderson = 1;
	}
	
	SetDvar( "la_F35_pilot_saved", b_saved_anderson );
	
	// did the first G20 vehicle live?
//	b_g20_saved_1st = 0;
//	if ( flag( "g20_group1_dead" ) )
//	{
//		b_g20_saved_1st = 1;
//	}
//	
//	SetDvar( "la_G20_1_saved", b_g20_saved_1st );
	
	// did the second G20 vehicle live?
	b_g20_saved_2nd = 0;
	if ( !flag( "intersect_vip_cougar_died" ) )
	{
		b_g20_saved_2nd = 1;
	}
	
	SetDvar( "la_G20_2_saved", b_g20_saved_2nd );
}

f35_land_fx( m_f35 )
{
	m_f35 play_fx( "f35_exhaust_hover_front", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_left" );
	m_f35 play_fx( "f35_exhaust_hover_front", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_right" );
	m_f35 play_fx( "f35_exhaust_hover_rear", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_left_rear" );
	m_f35 play_fx( "f35_exhaust_hover_rear", undefined, undefined, "stop_fx", true, "tag_fx_nozzle_right_rear" );
	
	scene_wait( "fa38_landing" );
	
	m_f35 notify( "stop_fx" );
}