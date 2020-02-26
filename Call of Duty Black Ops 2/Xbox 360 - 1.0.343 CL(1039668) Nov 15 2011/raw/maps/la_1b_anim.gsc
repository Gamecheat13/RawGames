#include maps\_utility;
#include maps\_dialog;
#include maps\_scene;
#include maps\_turret;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_scene.gsh;

#using_animtree ("generic_human");
main()
{
	event_5_anims();
	event_6_anims();
	event_7_anims();
	fxanim_test();

	precache_assets();	
	maps\voice\voice_la_1b::init_voice();
	
	init_vo();
}

event_5_anims()
{	
	//****************************************
	// cougar exit anims
	add_scene( "cougar_exit_player", "anim_align_cougar_crash" );
	add_player_anim( "player_body", %player::ch_la_05_01_cougar_exit_player, true );
	
	add_scene( "cougar_exit", "anim_align_cougar_crash" );
	add_actor_anim( "ter_cougar_exit", %generic_human::ch_la_05_01_cougar_exit_ter1 );
	add_actor_anim( "roofter_cougar_exit", %generic_human::ch_la_05_01_cougar_exit_roofter );
	add_actor_anim( "bdog_cougar_exit", %bigdog::v_la_05_01_cougar_exit_big_dog );
	add_prop_anim( "interior_cougar_exit", %animated_props::v_la_05_01_cougar_exit_cougar, "veh_t6_mil_cougar_interior_front" );
	add_prop_anim( "president_cougar_exit", %animated_props::v_la_05_01_cougar_exit_cougar02, "veh_t6_mil_cougar", true );
	add_vehicle_anim( "f35_cougar_exit", %vehicles::v_la_05_01_cougar_exit_f35, true, "tag_gear" );
	add_notetrack_custom_function( "f35_cougar_exit", "fire1", ::fire_turret_2 );
	add_notetrack_custom_function( "ter_cougar_exit", "fire_at_f35", ::fire_at_f35 );
	
	add_scene( "cougar_exit_friendlies", "anim_align_cougar_crash" );
	add_actor_anim( "harper", %generic_human::ch_la_05_01_cougar_exit_harper1 );
	add_actor_anim( "ce_bike_cop_1", %generic_human::ch_la_05_01_cougar_exit_bike_cop1, false, false, true );
	add_actor_anim( "ce_bike_cop_2", %generic_human::ch_la_05_01_cougar_exit_bike_cop2, false, false, true );
	add_actor_anim( "ce_bike_cop_3", %generic_human::ch_la_05_01_cougar_exit_bike_cop3, false, false, true );
	add_actor_anim( "ce_cop_1", %generic_human::ch_la_05_01_cougar_exit_cop1 );
	add_actor_anim( "ce_cop_2", %generic_human::ch_la_05_01_cougar_exit_cop2 );
	add_prop_anim( "wheeler_cougar_exit", %animated_props::v_la_05_01_cougar_exit_18wheeler, "veh_t6_civ_18wheeler_cab" );
	
	add_scene( "cougar_exit_cop_vh", "anim_align_cougar_crash" );
	add_prop_anim( "ce_bike_1", %animated_props::v_la_05_01_cougar_exit_bike1, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_bike_2", %animated_props::v_la_05_01_cougar_exit_bike2, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_bike_3", %animated_props::v_la_05_01_cougar_exit_bike3, "veh_t6_civ_police_motorcycle", true );
	add_prop_anim( "ce_car_1", %animated_props::v_la_05_01_cougar_exit_cop_car1, "veh_iw_civ_policecar_radiant", true );
	add_prop_anim( "ce_car_2", %animated_props::v_la_05_01_cougar_exit_cop_car2, "veh_iw_civ_policecar_radiant", true );
	add_vehicle_anim( "cop_car_cougar_exit", %vehicles::v_la_05_01_cougar_exit_cop_car3 );
	
//	add_scene( "cougar_exit_cop_car", "anim_align_cougar_crash" );
//	add_vehicle_anim( "cop_car_cougar_exit", %vehicles::v_la_05_01_cougar_exit_cop_car3 );
	
//	add_scene( "cougar_exit_driver", "anim_align_cougar_crash" );
//	add_actor_anim( "driver_cougar_exit", %generic_human::ch_la_05_01_cougar_exit_driver );
//	add_prop_anim( "wheeler_cougar_exit", %animated_props::v_la_05_01_cougar_exit_18wheeler, "veh_t6_civ_18wheeler_cab" );
//	
//	add_scene( "cougar_exit_driver_loop", "anim_align_cougar_crash", false, false, true );
//	add_actor_anim( "driver_cougar_exit", %generic_human::ch_la_05_01_cougar_exit_idle_driver );
	
	//****************************************
	// clear the street anims
	add_scene( "clear_the_street", "anim_align_semi_arrival" );
	add_actor_anim( "bdog_1_clear_the_street", %bigdog::v_la_05_02_clearthestreet_bdog1 );
	add_prop_anim( "wheeler_clear_the_street", %animated_props::v_la_05_02_clearthestreet_18whlr, "veh_t6_civ_18wheeler" );
	
	add_scene( "clear_the_street_bdog_2", "anim_align_semi_arrival" );
	add_actor_anim( "bdog_2_clear_the_street", %bigdog::v_la_05_02_clearthestreet_bdog2 );
	
	add_scene( "clear_the_street_ter", "anim_align_semi_arrival" );
	add_actor_anim( "ter_clear_the_street", %generic_human::ch_la_05_02_clearthestreet_ter1 );
	
	//****************************************
	// brute force anims
	add_scene( "brute_force", "anim_align_bruteforce" );
	add_prop_anim( "bruteforce_rubble_model", %animated_props::o_la_05_03_bruteforce_concrete );
	add_player_anim( "player_body", %player::ch_la_05_03_bruteforce_player, true );
	add_notetrack_custom_function( "player_body", "start_ssa_anim", ::start_ssa_anim );
	
	add_scene( "brute_force_ssa_1", "anim_align_bruteforce" );
	add_actor_anim( "ssa_1_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa1 );
	
	add_scene( "brute_force_ssa_2", "anim_align_bruteforce" );
	add_actor_anim( "ssa_2_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa2 );
	
	add_scene( "brute_force_ssa_3", "anim_align_bruteforce" );
	add_actor_anim( "ssa_3_brute_force", %generic_human::ch_la_05_03_bruteforce_ssa3 );
	
	add_scene( "brute_force_cougar", "anim_align_bruteforce" );
	add_prop_anim( "bruteforce_cougar", %animated_props::v_la_05_03_bruteforce_cougar );
	
	//****************************************
	// event 5 custom AI anims
	add_scene( "climb_on_top_train", "align_climb_top_train", false, true );
	add_actor_anim( "street_snipers",  %generic_human::ai_mantle_on_56 );
	
	add_scene( "train_surprise_attack", "align_train_surprise", false, true );
	add_actor_anim( "street_train_surprise", %generic_human::ai_mantle_on_56 );
}

fire_at_f35( ai_ter )
{
	vh_f35 = get_model_or_models_from_scene( "cougar_exit", "f35_cougar_exit" );
	v_canopy_pos = vh_f35 GetTagOrigin( "tag_canopy" );
	v_f35_pos = v_canopy_pos + ( 0, 0, -64 );
	v_rpg_pos = ai_ter GetTagOrigin( "tag_weapon" );
	MagicBullet( "rpg_sp", v_rpg_pos, v_f35_pos );
}

fire_turret_2( vh_f35 )
{
	vh_f35 fire_turret_for_time( 0.4, 2 );
}

/*
open_hatch( e_player )
{
	run_scene( "cougar_exit_cougar" );
}

enemy_top( vh_f35 )
{
	spawn_manager_enable( "sm_cougar_exit_top" );
	
	wait 9;
	
	//trigger_use( "move_president_cougar" );
}

enemy_bottom( vh_f35 )
{
	//spawn_manager_enable( "sm_cougar_exit_bottom" );
	run_scene( "cougar_exit_bottom" );
	
	scene_wait( "cougar_exit_player" );
	
	ai_cougar_exit_bottom = GetEnt( "ambush_cougar_exit_bottom_ai", "targetname" );
	if ( IsAlive( ai_cougar_exit_bottom ) )
	{
		ai_cougar_exit_bottom Delete();
	}
}

f35_fire( vh_f35 )
{
	ai_cougar_exit_top = GetEnt( "ambush_cougar_exit_top_ai", "targetname" );
	ai_cougar_exit_bottom = GetEnt( "ambush_cougar_exit_bottom_ai", "targetname" );
	
	while ( IsAlive( ai_cougar_exit_top ) )
	{
		vh_f35 cougar_exit_f35_shoot_at_enemy( ai_cougar_exit_top );
		
		wait 1;
	}
	
	while ( IsAlive( ai_cougar_exit_bottom ) )
	{
		vh_f35 cougar_exit_f35_shoot_at_enemy( ai_cougar_exit_bottom );
		
		wait 1;
	}
}

cougar_exit_f35_shoot_at_enemy( ai_enemy )
{
	if ( self f35_can_shoot_target( ai_enemy, 1 ) )
	{
		self thread shoot_turret_at_target( ai_enemy, 1, undefined, 1 );
	}
	else
	{
		self thread fire_turret_for_time( 1, 1 );
	}
	
	if ( self f35_can_shoot_target( ai_enemy, 2 ) )
	{
		self thread shoot_turret_at_target( ai_enemy, 1, undefined, 2 );
	}
	else
	{
		self thread fire_turret_for_time( 1, 2 );
	}
}

f35_can_shoot_target( e_target, n_turret_index )
{
	can_shoot_target = false;
	
	if ( n_turret_index == 1 )
	{
		v_turret = self GetTagOrigin( "tag_gunner_turret1" );
	}
	else
	{
		v_turret = self GetTagOrigin( "tag_gunner_turret2" );
	}
	
	a_trace_info = BulletTrace( v_turret, e_target.origin, false, undefined );
		
	if ( IsDefined( a_trace_info[ "entity" ] ) )
	{
		str_turret_hit = a_trace_info[ "entity" ].targetname;
	}

	if ( !IsDefined( str_turret_hit ) || str_turret_hit != "f35_cougar_exit" )
	{
		can_shoot_target = true;
	}

	return can_shoot_target;
}
*/

start_ssa_anim( e_player )
{
	level thread run_scene( "brute_force_cougar" );
	level thread run_scene( "brute_force_ssa_1" );
	level thread run_scene( "brute_force_ssa_2" );
	level thread run_scene( "brute_force_ssa_3" );
}

event_6_anims()
{
	//****************************************
	// F35 crash anims
	add_scene( "f35_crash_right", "anim_align_plane_react_lower" );
	//add_prop_anim( "f35_f35_crash", %animated_props::v_la_06_03_f35crash_f35, "veh_t6_air_f35" );
	add_prop_anim( "f35_f35_crash", %animated_props::fxanim_la_f35_airplane_anim, "veh_t6_air_f35" );
	//add_actor_anim( "harper", %generic_human::ch_la_06_03_f35crash_rightpath_harper );
	add_actor_anim( "guy_1_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy01 );
	add_actor_anim( "guy_2_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy02 );
	add_actor_anim( "guy_3_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy03 );
	add_actor_anim( "guy_4_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy04 );
	add_notetrack_custom_function( "f35_f35_crash", "f35_hit", ::f35_crash_fxanim );
	
	add_scene( "f35_crash_left", "anim_align_plane_react_lower" );
	//add_prop_anim( "f35_f35_crash", %animated_props::v_la_06_03_f35crash_f35, "veh_t6_air_f35" );
	add_prop_anim( "f35_f35_crash", %animated_props::fxanim_la_f35_airplane_anim, "veh_t6_air_f35" );
	//add_actor_anim( "harper", %generic_human::ch_la_06_03_f35crash_leftpath_harper );
	add_actor_anim( "guy_1_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy01 );
	add_actor_anim( "guy_2_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy02 );
	add_actor_anim( "guy_3_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy03 );
	add_actor_anim( "guy_4_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy04 );
	add_notetrack_custom_function( "f35_f35_crash", "f35_hit", ::f35_crash_fxanim );
	
	add_scene( "f35_crash_middle", "anim_align_plane_react_lower" );
//	add_prop_anim( "f35_f35_crash", %animated_props::fxanim_la_f35_airplane_anim, "veh_t6_air_f35" );
//	add_notetrack_custom_function( "f35_f35_crash", "f35_hit", ::f35_crash_fxanim );
	add_vehicle_anim( "f35_cougar_exit", %vehicles::fxanim_la_f35_airplane_anim );
	add_notetrack_custom_function( "f35_cougar_exit", "f35_hit", ::f35_crash_fxanim );
	
//	add_scene( "f35_crash_left_harper", "anim_align_plane_react_lower" );
//	add_actor_anim( "harper", %generic_human::ch_la_06_03_f35crash_leftpath_harper );
//	
//	add_scene( "f35_crash_left_guys", "anim_align_plane_react_lower" );
//	add_actor_anim( "guy_1_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy01 );
//	add_actor_anim( "guy_2_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy02 );
//	add_actor_anim( "guy_3_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy03 );
//	add_actor_anim( "guy_4_f35_crash", %generic_human::ch_la_06_03_f35crash_leftpath_guy04 );	
	
//	add_scene( "f35_crash_right_harper", "anim_align_plane_react_lower" );
//	add_actor_anim( "harper", %generic_human::ch_la_06_03_f35crash_rightpath_harper );
//	
//	add_scene( "f35_crash_right_guys", "anim_align_plane_react_lower" );
//	add_actor_anim( "guy_1_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy01 );
//	add_actor_anim( "guy_2_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy02 );
//	add_actor_anim( "guy_3_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy03 );
//	add_actor_anim( "guy_4_f35_crash", %generic_human::ch_la_06_03_f35crash_rightpath_guy04 );
	
	//****************************************
	// interception animations
	add_scene( "sam_guy_loop", "intersect_sam_cougar", false, false, true );
	add_actor_anim( "sam_guy", %generic_human::ch_la_06_04_interception_guy01_loop, false, false, false, false, "tag_gunner_turret2" );
	//add_vehicle_anim( "intersect_sam_cougar", %vehicles::v_la_06_04_interception_cougar_loop );
	//add_prop_anim( "intersect_sam_cougar", %animated_props::v_la_06_04_interception_cougar_loop, "veh_t6_mil_cougar" );
	
	add_scene( "sam_cougar_loop", "intersect_sam_cougar", false, false, true );
	add_vehicle_anim( "intersect_sam_cougar", %vehicles::v_la_06_04_interception_cougar_loop );
	
	add_scene( "shoot_down_drone_sam", "intersect_sam_cougar" );
	add_actor_anim( "sam_guy", %generic_human::ch_la_06_04_interception_shootdrone_guy01, false, false, false, false, "tag_gunner_turret2" );
	add_vehicle_anim( "intersect_sam_cougar", %vehicles::v_la_06_04_interception_shootdrone_cougar );
	
	add_scene( "shoot_down_drone", "anim_align_stadium_intersection" );
	add_vehicle_anim( "intersect_avenger_drone", %vehicles::v_la_06_04_interception_shootdrone_drone );
	
	add_scene( "ssa_thank", "anim_align_stadium_intersection", true );
	add_actor_anim( "thank_guy", %generic_human::ch_la_06_04_interception_thankplayer_guy02 );
	
	add_scene( "sam_complain", "intersect_sam_cougar" );
	add_actor_anim( "sam_guy", %generic_human::ch_la_06_04_interception_nagplayer_guy01, false, false, false, false, "tag_gunner_turret2" );
	add_vehicle_anim( "intersect_sam_cougar", %vehicles::v_la_06_04_interception_nagplayer_cougar );
	
	//****************************************
	// event 6 custom AI anims
	add_scene( "climb_on_hedge_1", "anim_climb_on_hedge_1", false, true );
	add_actor_anim( "plaza_hedge_1",  %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_on_hedge_2", "anim_climb_on_hedge_2", false, true );
	add_actor_anim( "plaza_hedge_2",  %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_plaza_building", "anim_climb_plaza_building", false, true );
	add_actor_anim( "plaza_building",  %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_on_cylinder_0", "anim_plaza_right_rpg_0" );
	add_actor_anim( "plaza_right_rpg_0", %generic_human::ai_mantle_on_56 );
	
	add_scene( "climb_on_cylinder_1", "anim_plaza_right_rpg_1" );
	add_actor_anim( "plaza_right_rpg_1", %generic_human::ai_mantle_on_56 );
	
	//****************************************
	// fxanim av vehicles test
//	add_scene( "avenger_ambient_1", undefined, false, true, true, true );
//	add_prop_anim( "generic", %animated_props::fxanim_la_drone_ambient_01_anim );
	
//	add_scene( "avenger_ambient_2", undefined, false, true, true, true );
//	add_prop_anim( "generic", %animated_props::fxanim_la_drone_ambient_02_anim );
}

event_7_anims()
{
	//****************************************
	// intruder anims
	add_scene( "intruder", "anim_align_intruder" );
	add_prop_anim( "lock_intruder", %animated_props::o_specialty_intruder_lock, "test_p_anim_specialty_lockbreaker_padlock", true );
	add_prop_anim( "torch_intruder", %animated_props::o_specialty_intruder_torch, "test_p_anim_specialty_lockbreaker_device", true );
	add_player_anim( "player_body", %player::int_specialty_intruder, true );
	
	//****************************************
	// sam anims
	add_scene( "sam_in", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_in, true );
	
	add_scene( "sam_out", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_out, true );
	
	add_scene( "sam_thrown_out", "intruder_sam" );
	add_player_anim( "player_body", %player::ch_la_07_01_sam_turret_thrown_out, true );
	
	//****************************************
	// lock_breaker anims
	add_scene( "lock_breaker" );
	add_prop_anim( "phone_lock_breaker", %animated_props::o_specialty_trespasser_phone, "test_p_anim_specialty_trespasser_device", true );
	add_player_anim( "player_body", %player::int_specialty_trespasser, true );
	
	//****************************************
	// sonar anims
	add_scene( "sonar_on", undefined, false, false, false, true );
	add_player_anim( "player_body", %player::ch_la_07_06_sonar_goggles_on_player, true );
	
	add_scene( "sonar_off", undefined, false, false, false, true );
	add_player_anim( "player_body", %player::ch_la_07_06_sonar_goggles_off_player, true );
	
	//****************************************
	// ending anims
	add_scene( "ending_wheeler", "anim_ending_wheeler" );
	add_prop_anim( "wheeler_ending", %animated_props::v_la_05_02_clearthestreet_18whlr, "veh_t6_civ_18wheeler" );
	
	add_scene( "ending_dog_fight", "la_1_ending_test" );
	add_prop_anim( "drone_ending_dog_fight", %animated_props::fxanim_la_drone_crash_tower_anim, "veh_t6_drone_avenger", true );
	add_prop_anim( "f35_ending_dog_fight", %animated_props::fxanim_la_f35_tower_flyby_anim, "veh_t6_air_f35", true );
	add_notetrack_custom_function( "drone_ending_dog_fight", "drone_crash", ::ending_drone_crash );
	
//	add_scene( "ending_anderson", "anim_anderson", false, false, true );
//	add_actor_anim( "anderson_la_1_end", %generic_human::ai_pistol_crouchcover_hide_blindfire );
	
	//****************************************
	// collapse building
	add_scene( "collapse_building_player", undefined, false, false, false, true );
	add_player_anim( "player_body", %player::ch_la_07_05_collapse_react_player, true );
//	add_notetrack_custom_function( "player_body", "start_dust", ::collapse_building_dust );
	add_notetrack_custom_function( "player_body", "level_end", ::la_1_ends );
	
	add_scene( "ending_drone", "anim_align_arena_exit" );
	add_prop_anim( "crash_drone_ending", %animated_props::fxanim_la_drone_crash_tower_anim, "veh_t6_drone_avenger" );
	
	add_scene( "collapse_building_harper", "anim_harper_ending", true );
	add_actor_anim( "harper", %generic_human::ch_la_07_05_collapse_react_harper );
	
	add_scene( "collapse_building_van", "anim_align_arena_exit" );
	add_vehicle_anim( "ending_van", %vehicles::v_la_07_04_van_entry );
	//add_prop_anim( "crash_drone_ending", %animated_props::fxanim_la_drone_crash_tower_anim, "veh_t6_drone_avenger" );
}

ending_drone_crash( m_drone )
{
	PlayFX( level._effect[ "ending_crash_explosion" ] , m_drone.origin );
}

collapse_building_dust( m_player_body )
{
	exploder( 790 );
}

la_1_ends( m_player_body )
{
	maps\la_utility::fade_to_black( 1 );
	
	maps\la_arena::la_2_transition();
	
	nextmission();
}

#using_animtree( "animated_props" );
fxanim_test()
{
	level.scr_animtree[ "fxanim_ambient_drone_1" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_1" ] = "veh_t6_drone_avenger";
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_1" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_drone_2" ] = #animtree;
	level.scr_model[ "fxanim_ambient_drone_2" ] = "veh_t6_drone_pegasus";
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_drone_2" ][ "drone_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
	
	level.scr_animtree[ "fxanim_ambient_f35" ] = #animtree;
	level.scr_model[ "fxanim_ambient_f35" ] = "veh_t6_air_f35";
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_1" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_01_anim;
	level.scr_anim[ "fxanim_ambient_f35" ][ "f35_ambient_2" ][ 0 ] =  %animated_props::fxanim_la_drone_ambient_02_anim;
}

f35_crash_fxanim( vh_f35 )
{
	level notify( "f35_env_start" );
}

init_vo()
{
	add_dialog( "low_road_choke_1", "We're stuck!" );
	add_dialog( "low_road_choke_1_thanks", "Thanks for the help!" );
	
	add_dialog( "low_road_choke_2", "We're stuck again!" );
	add_dialog( "low_road_choke_2_thanks", "Thanks for the help!" );
	
	add_dialog( "low_road_choke_3", "We're stuck again!" );
	add_dialog( "low_road_choke_3_thanks", "Thanks for the help!" );
	
	add_dialog( "enemies_flanking_left", "They're flanking us on the left!" );
	add_dialog( "snipers_on_the_bridge", "Snipers on the bridge!" );
	
//	event_5_vos();
//	event_6_vos();
}

event_5_vos()
{
	//****************************************
	// objectives
	add_dialog( "eliminate_bdogs", "Shit! They've control big dogs too! Take them out!" );
	
	//****************************************
	// bdog reminders
	add_dialog( "bdog_out_halfway", "The big dog in the street is halfway there!" );
	add_dialog( "bdog_in_halfway", "The big dog in the stores is halfway there!" );
	add_dialog( "bdog_out_almost", "The big dog in the street is almost there!" );
	add_dialog( "bdog_in_almost", "The big dog in the stores is almost there!" );
}

event_6_vos()
{
	//****************************************
	// objectives
	add_dialog( "intersect_ambush_obj_ssa", "We need help! We're ambushed in front of the Arena!" );
	add_dialog( "intersect_ambush_obj_harper", "We are heading there now." );
	
	//****************************************
	// plaza general dialogues
	add_dialog( "move_president_cougar_harper", "Take another street. We are going to help the other convoy. We'll meet up later" );
	add_dialog( "move_president_cougar_ssa", "Roger that." );
	
	//****************************************
	// plaza strikes
	add_dialog( "plaza_strike_1_ssa", "Where's the support!" );
	add_dialog( "plaza_strike_1_harper", "We are going as fast as we can!" );
	add_dialog( "plaza_strike_2_ssa", "We are dying here!" );
	add_dialog( "plaza_strike_2_harper", "Just hold on a few more seconds!" );
	add_dialog( "plaza_strike_3_ssa", "I don't think we can hold on any longer!" );
	add_dialog( "plaza_strike_3_harper", "We are almost there!" );
	
	//****************************************
	// intersection general dialogues
	add_dialog( "plaza_fail", "What took you guys so long?!?" );
	add_dialog( "intersect_sorry", "Sorry. There was a lot of resistance in the plaza." );
	add_dialog( "intersect_thanks", "Thanks for saving us." );
	add_dialog( "intersect_fail", "Fuck! We lost them!" );
}