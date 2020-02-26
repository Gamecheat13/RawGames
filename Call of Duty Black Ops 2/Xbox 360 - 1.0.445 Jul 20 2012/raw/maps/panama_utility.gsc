#include common_scripts\utility;
#include maps\_utility;
#include maps\_objectives;
#include maps\_vehicle;
#include maps\_skipto;
#include maps\_scene;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

level_init_flags()
{
	//global flags
	flag_init( "movie_done" );
	flag_init( "movie_started" );
	
	// panama 1
	flag_init("kill_argue_vo");
	flag_init( "house_event_end" );
	flag_init( "house_follow_mason" );	
	flag_init( "house_meet_mason" );
	flag_init( "player_at_front_gate" );
	flag_init( "player_opened_shed" );
	flag_init( "player_frontyard_obj" );
	flag_init( "show_introscreen_title" );
	flag_init( "house_front_door_obj_done" );
	flag_init( "house_front_gate_obj" );
	flag_init( "start_shed_obj" );
//	flag_init( "trig_player_exit" );
//	flag_init( "start_skinner_wave" );
	flag_init( "can_turn_off_lights" );
	flag_init( "house_player_at_exit" );
	flag_init( "stop_ac130" );
	flag_init( "zodiac_approach_start" );
	flag_init( "zodiac_approach_end" );
	flag_init( "destroy_gaz_trucks" );
	flag_init( "player_at_first_blood" );
	flag_init( "mason_at_first_blood" );
	flag_init( "first_blood_guys_cleared" );
	flag_init( "contacted_skinner" );
	flag_init( "rooftop_goes_hot" );
	flag_init( "rooftop_spawned" );
	flag_init( "rooftop_clear" );
	flag_init( "runway_standoff_goes_hot" );
	flag_init( "runway_vo_done" );
	flag_init( "hangar_vo_done" );
	flag_init( "airfield_end" );
	flag_init( "learjet_battle_done" );
	flag_init( "hangar_doors_closing" );
	flag_init( "spawn_pdf_assaulters" );
//	flag_init( "parking_lot_gone_hot" );	
	flag_init( "parking_lot_guys_cleared" );	
	flag_init( "hangar_gone_hot" );	
	flag_init( "stop_intro_planes" );		
	flag_init( "stop_runway_planes" );		
	flag_init( "remove_hangar_god_mode" );		
	flag_init( "player_in_hangar" );
//	flag_init( "beach_jet_done" );
	flag_init( "stop_parking_lot_jets" );
	flag_init( "motel_jet_done" );	
	flag_init( "hangar_pdf_cleared" );	
	flag_init( "rooftop_guy_killed" );	
	flag_init( "seal_1_in_pos" );	
	flag_init( "seal_2_in_pos" );	
	flag_init( "start_pdf_ladder_reaction" );
	flag_init( "player_contextual_start" );	
	flag_init( "player_contextual_end" );	
	flag_init( "player_destroyed_learjet" );
	flag_init( "learjet_destroyed" );
	flag_init( "player_opened_grate" );
	flag_init( "player_second_melee" );
//	flag_init( "player_climb_up_done" );
	flag_init( "contextual_melee_success" );
//	flag_init( "skinner_motel_dialogue" );
	flag_init( "player_near_motel" );
	flag_init( "button_wait_done" );
	flag_init( "contextual_melee_done" );
	flag_init( "setup_runway_standoff" );
	flag_init( "player_on_roof" );
	flag_init( "turret_guy_died" );
	flag_init( "spawn_learjet_wave_2" );
	flag_init( "mason_getting_in_drain" );
	flag_init( "mason_at_drain" );
	flag_init( "spawn_parking_lot_backup" ); //trigger flag
	flag_init( "parking_lot_laststand" );
	flag_init( "mason_at_motel" );
	flag_init( "motel_scene_end" );
	flag_init( "start_intro_anims" );
	flag_init( "trig_mason_to_motel" );
	flag_init( "player_pull_pin" );
	flag_init( "motel_room_cleared" );
	flag_init( "breach_gun_raised" );
	flag_init( "beach_intro_vo_done" );
	flag_init( "player_climbs_up_ladder" );
	flag_init( "learjet_intro_vo_done" );
	flag_init( "learjet_pdf_with_rpg_at_final" );
	flag_init( "in_bash_position" );
	flag_init( "friendly_door_bash_done" );
	flag_init( "mcknight_sniping" );
	
	// panama 2
	flag_init( "ambulance_complete" );
	flag_init( "ambulance_staff_killed" );
	flag_init( "ambulance_player_engaged" );
	flag_init( "slums_done" );
	flag_init( "slums_player_at_overlook" );
	flag_init( "slums_noriega_at_overlook" );
	flag_init( "slums_mason_at_overlook" );
	flag_init( "slums_player_down" );
	flag_init( "slums_shot_at_snipers" );
	flag_init( "slums_e_02_start" );
	flag_init( "slums_e_02_finish" );
	flag_init( "slums_e_02_helicopter" ); //-- the apache
	flag_init( "slums_molotov_triggered" );
	flag_init( "slums_update_objective" );
	flag_init( "slums_nest_engage" );
	flag_init( "slums_apache_retreat" );
	flag_init( "slums_start_building_fire" );
	flag_init( "slums_bottleneck_reached" );
	flag_init( "slums_bottleneck_2_reached" );
	flag_init( "spawn_balcony_digbat" );
	flag_init( "building_breach_ready" );
	flag_init( "army_street_push" );
	flag_init( "left_path_cleanup" );
	flag_init( "slums_player_see_pistol_anim" );
	flag_init( "slums_player_took_point" );
	flag_init( "move_intro_heli" );
	flag_init( "slums_turn_off_player_ignore" );
	flag_init( "slums_rotate_door" );
	
	// panama 2 - SLUMS MOVEMENT FLAGS
	flag_init("slum_scene_waiting");
	flag_init( "noriega_moved_now_move_mason" );
	flag_init( "mv_noriega_to_van" );
	flag_init( "mv_noriega_to_dumpster" );
	flag_init( "mv_noriega to_parking_lot" );
	flag_init( "mv_noriega_to_gazebo" );
	flag_init( "mv_noriega_just_before_stairs" );
	flag_init( "mv_noriega_slums_left_bottleneck" );
	flag_init( "mv_noriega_right_of_church" );
	flag_init( "mv_noriega_before_church" );
	flag_init( "mv_noriega_slums_right_bottleneck" );
	flag_init( "mv_noriega_slums_right_bottleneck_complete" );
	flag_init( "mv_noriega_move_passed_library" );
	
	flag_init( "alley_molotov_digbat_animating");
	
	flag_init( "cleanup_before_digbat_parking_lot" );
	
	// panama 3
	flag_init( "panama_building_start" );
	flag_init( "player_at_clinic" );
	flag_init( "clinic_enter_hall_1" );
	flag_init( "clinic_enter_hall_2" );
	flag_init( "clinic_ceiling_collapsed" );
	flag_init( "post_gauntlet_player_fired" );
	flag_init( "post_gauntlet_mason_open_door" );
	flag_init( "jump_start" );
	flag_init( "chase_player_jumped" );
	flag_init( "clinic_wall_contact" );
	flag_init( "clinic_break_window" );
	flag_init( "chase_rescue_noriega" );
	flag_init( "checkpoint_approach_one" );
	flag_init( "checkpoint_approach_two" );
	flag_init( "checkpoint_reached" );
	flag_init( "checkpoint_cleared" );
	flag_init( "checkpoint_finished" );
	flag_init( "checkpoint_fade_now" );
	flag_init( "start_mason_run" );
	flag_init( "docks_battle_one_trigger_event" );
	flag_init( "docks_cleared" );
	flag_init( "docks_entering_elevator" );
	flag_init( "docks_rifle_mounted" );
	flag_init( "docks_kill_menendez" );
	flag_init( "sniper_start_timer" );
	flag_init( "sniper_stop_timer" );
	flag_init( "sniper_mason_shot1" );
	flag_init( "sniper_mason_shot2" );
	flag_init( "docks_mason_down" );
	flag_init( "docks_betrayed_fade_in" );
	flag_init( "docks_betrayed_fade_out" );
	flag_init( "docks_mason_dead_reveal" );
	flag_init( "docks_final_cin_fade_in" );
	flag_init( "docks_final_cin_fade_out" );
	flag_init( "docks_final_cin_landed1" );
	flag_init( "docks_final_cin_landed2" );
	flag_init( "challenge_nodeath_check_start" );
	flag_init( "challenge_nodeath_check_end" );
	flag_init( "challenge_docks_guards_speed_kill_start" );
	flag_init( "challenge_docks_guards_speed_kill_pause" );
	flag_init( "jeep_foliage_crash_1" );
	flag_init( "jeep_foliage_crash_2" );
	flag_init( "jeep_fence_crash" );
	flag_init( "start_gate_ambush" );
	flag_init( "fuel_tanks_destroyed" );
}

// sets flags for the skipto's and exits out at appropriate skipto point.  All previous skipto setups in this functions will be called before the current skipto setup is called
skipto_setup()
{
	load_gumps_panama();
	
	skipto = level.skipto_point;
		
	if ( skipto == "house" )
		return;	

	flag_set( "house_meet_mason" );
	flag_set( "house_follow_mason" );
	flag_set( "house_front_door_obj_done" );
	flag_set( "house_front_gate_obj" );
	flag_set( "player_at_front_gate" );
	flag_set( "start_shed_obj" );
	flag_set( "player_opened_shed" );
	flag_set( "player_frontyard_obj" );
	flag_set( "house_player_at_exit" );
//	flag_set( "house_event_end" );
	flag_set( "zodiac_approach_start" );	
	
	if ( skipto == "zodiac" )
		return;	
	
	flag_set( "zodiac_approach_end" );	
	
	if ( skipto == "beach" )
		return;

	flag_set( "mason_getting_in_drain" );
	flag_set( "player_climbs_up_ladder" );
	flag_set( "player_at_first_blood" );
	flag_set( "player_contextual_start" );
	//flag_set( "parking_lot_gone_hot" );
//	flag_set( "parking_lot_guys_cleared" );
	flag_set( "contextual_melee_done" );
	flag_set( "setup_runway_standoff" );
	
	if (skipto == "runway")
		return;		
	
	if (skipto == "learjet")
		return;		
	
//	flag_set( "airfield_end" );
	flag_set( "learjet_battle_done" );
	flag_set( "player_near_motel" );
//	flag_set( "skinner_motel_dialogue" );
	
	if (skipto == "motel")
		return;	

//	flag_set( "skinner_motel_dialogue" );
	flag_set( "mason_at_motel" );
	flag_set( "start_intro_anims" );
	flag_set( "motel_room_cleared" );
	flag_set( "motel_scene_end" );
		
	if (skipto == "slums_intro")
		return;		
		
	flag_set( "ambulance_complete" );
	flag_set( "slums_update_objective" );	

	if (skipto == "slums_main" )
		return;

	if (skipto == "building")
		return;	

	flag_set( "panama_building_start" );
	
	if (skipto == "chase")
		return;	

	flag_set( "chase_rescue_noriega" );
	flag_set( "jump_start" );
	
	if (skipto == "checkpoint")
		return;
	
	flag_set( "checkpoint_approach_one" );
	flag_set( "checkpoint_approach_two" );
	flag_set( "checkpoint_reached" );
	flag_set( "checkpoint_cleared" );
	flag_set( "checkpoint_finished" );
	
	if (skipto == "docks")
		return;		

	flag_set( "docks_cleared" );
	flag_set( "docks_entering_elevator" );
	
	if (skipto == "sniper")
		return;
}

setup_objectives()
{
	level.a_objectives = [];
	level.n_obj_index = 0;
	
	//HOUSE
	level.OBJ_MEET					= register_objective( &"PANAMA_OBJ_MEET" );
	level.OBJ_MEET_MCKNIGHT			= register_objective( &"PANAMA_OBJ_MEET_MCKNIGHT" );
	level.OBJ_HOUSE_EMPTY			= register_objective( &"" );
	level.OBJ_SHED					= register_objective( &"PANAMA_OBJ_SHED" );
	level.OBJ_FRONTYARD				= register_objective( &"PANAMA_OBJ_FRONTYARD" );
	
	//AIRFIELD
	level.OBJ_INTERACT				= register_objective( &"" );
	level.OBJ_INTRUDER				= register_objective( &"" );
	level.OBJ_FOLLOW_MASON_1		= register_objective( &"" );
	level.OBJ_CAPTURE_NORIEGA		= register_objective( &"PANAMA_OBJ_CAPTURE_NORIEGA" );
	level.OBJ_ASSIST_SEALS			= register_objective( &"PANAMA_OBJ_ASSIST_SEALS" );

	//SLUMS
	level.OBJ_CAPTURE_MENENDEZ		= register_objective( &"PANAMA_OBJ_CAPTURE_MENENDEZ" );
	level.OBJ_FIND_FALSE_PROFIT 	= register_objective( &"PANAMA_OBJ_FIND_FALSE_PROFIT" );
	level.OBJ_REACH_CHECKPOINT		= register_objective( &"PANAMA_OBJ_REACH_CHECKPOINT" );
	
	//Docks
	level.OBJ_DOCKS_SNIPER			= register_objective( &"PANAMA_OBJ_DOCKS_SNIPER" );
	level.OBJ_DOCKS_KILL_MENENDEZ	= register_objective( &"PANAMA_OBJ_DOCKS_KILL_MENENDEZ" );
	//wait 0.05;
	
	if ( level.script == "panama" )
	{
		house_objectives();
		airfield_objectives();
	}
	else if ( level.script == "panama_2" )
	{
		while( !IsDefined( level.mason ) || !IsDefined( level.noriega ) )
		{
			wait 0.05;
		}
		
		slums_objectives();
	}
	else
	{
		while( !IsDefined( level.mason ) || !IsDefined( level.noriega ) )
		{
			wait 0.05;
		}
				
		chase_objectives();
		docks_objectives();	
	}
}

setup_global_challenges()
{
	wait_for_first_player();

	//global challenges
	level.player thread maps\_challenges_sp::register_challenge( "locateintel", ::locate_int );
	level.player thread maps\_challenges_sp::register_challenge( "nodeath", ::challenge_nodeath );
	
	/* all challenges below has been moved to their respective files (panama.gsc, panama_2.gsc, panama_3.gsc) */
	
	//perk challenges
//	level.player thread maps\_challenges_sp::register_challenge( "rescuesoldier", maps\panama_slums::challenge_rescue_soldier );
//	level.player thread maps\_challenges_sp::register_challenge( "findweaponcache", maps\panama_slums::challenge_find_weapon_cache );
//	level.player thread maps\_challenges_sp::register_challenge( "hangardoors", maps\panama_airfield::challenge_close_hangar_doors );

	//level specific challenges
//	level.player thread maps\_challenges_sp::register_challenge( "thinkfast", maps\panama_airfield::challenge_thinkfast );
//	level.player thread maps\_challenges_sp::register_challenge( "destroylearjet", maps\panama_airfield::challenge_destroy_learjet );
//	level.player thread maps\_challenges_sp::register_challenge( "destroyzpu", maps\panama_slums::challenge_destroy_zpu );
//	level.player thread maps\_challenges_sp::register_challenge( "grenadecombo", maps\panama_slums::challenge_grenade_combo );
//	level.player thread maps\_challenges_sp::register_challenge( "docksguardsspeedkill", maps\panama_docks::challenge_docks_guards_speed_kill );
}

//Handles logic for completing nodeath challenge
challenge_nodeath( str_notify )
{
	flag_wait( "challenge_nodeath_check_start" );
	
	n_deaths = get_player_stat( "deaths" );
	
	if ( n_deaths == 0 )
	{
		self notify( str_notify );
	}
	
	flag_set( "challenge_nodeath_check_end" );
}

locate_int( str_notify )
{
	flag_wait( "challenge_nodeath_check_start" );
	
	player_collected_all = collected_all();
	
	if( player_collected_all )
	{
		self notify( str_notify );		
	}	
}

house_objectives()
{
	flag_wait( "house_meet_mason" );

	set_objective( level.OBJ_MEET, getstruct( "s_greet_mason_obj" ), "breadcrumb" );
	
	flag_wait( "house_follow_mason" );
	
	set_objective( level.OBJ_MEET, undefined, "remove" );
	set_objective( level.OBJ_MEET, undefined, "done" );
	set_objective( level.OBJ_MEET, undefined, "delete" );
	
	set_objective( level.OBJ_MEET_MCKNIGHT, getstruct( "s_front_door" ), "breadcrumb" );
	
	flag_wait( "house_front_door_obj_done" );
	
	set_objective( level.OBJ_MEET_MCKNIGHT, undefined, "remove" );
	set_objective( level.OBJ_MEET_MCKNIGHT, undefined, "done" );
	set_objective( level.OBJ_MEET_MCKNIGHT, undefined, "delete" );
	
	flag_wait( "house_front_gate_obj" );
	
	set_objective( level.OBJ_HOUSE_EMPTY, getstruct( "s_front_gate" ), "breadcrumb" );
	
	flag_wait( "player_at_front_gate" );
	
	set_objective( level.OBJ_HOUSE_EMPTY, undefined, "remove" );
	set_objective( level.OBJ_HOUSE_EMPTY, undefined, "done" );
	set_objective( level.OBJ_HOUSE_EMPTY, undefined, "delete" );
	
	flag_wait( "start_shed_obj" );
	
	set_objective( level.OBJ_SHED, getstruct( "s_shed_door_obj" ), "breadcrumb" );
	
	flag_wait( "player_opened_shed" );
	
	set_objective( level.OBJ_SHED, undefined, "remove" );
	set_objective( level.OBJ_SHED, undefined, "done" );
	set_objective( level.OBJ_SHED, undefined, "delete" );	
	
	flag_wait( "player_frontyard_obj" );
	
	set_objective( level.OBJ_FRONTYARD, getstruct( "s_player_gate_obj" ), "breadcrumb" );
	
	flag_wait( "house_player_at_exit" );
	
	set_objective( level.OBJ_FRONTYARD, undefined, "remove" );	
	set_objective( level.OBJ_FRONTYARD, undefined, "done" );
	set_objective( level.OBJ_FRONTYARD, undefined, "delete" );
}

airfield_objectives()
{
	flag_wait( "zodiac_approach_start" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA );
		
	flag_wait( "zodiac_approach_end" );
	
	wait 1;

	set_objective( level.OBJ_FOLLOW_MASON_1 , level.mason, "follow" );
	
	flag_wait( "mason_getting_in_drain" );
	
	set_objective( level.OBJ_FOLLOW_MASON_1 , level.mason, "remove" );
//	set_objective( level.OBJ_CAPTURE_NORIEGA, GetEnt( "beach_contextual_guard_ai", "targetname" ), "kill" );
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_knife_ladder_obj" ) , "kill" );
	
//	flag_wait( "mason_at_drain" );
//	
//	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_knife_ladder_obj" ), "breadcrumb" );
//	
//	flag_wait( "player_contextual_start" );
	
	flag_wait( "player_climbs_up_ladder" );

//	trig_contextual_melee = GetEnt( "trig_contextual_melee", "targetname" );
//	if ( IsDefined( trig_contextual_melee ) )
//	{
//		trig_contextual_melee Delete();
//	}

	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );

//	flag_wait( "parking_lot_guys_cleared" );
	flag_wait( "contextual_melee_done" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "follow" );
	
	flag_wait( "setup_runway_standoff" );
		
	wait( 2 );	

	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "remove" );	
	set_objective( level.OBJ_ASSIST_SEALS, level.mason, "follow" );
	
//	flag_wait( "airfield_end" );
	flag_wait( "learjet_battle_done" );

	set_objective( level.OBJ_ASSIST_SEALS, level.mason, "remove" );	
	set_objective( level.OBJ_ASSIST_SEALS, undefined, "done" );
	set_objective( level.OBJ_ASSIST_SEALS, undefined, "delete" );

	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "follow" );
	
//	flag_wait( "skinner_motel_dialogue" );
	flag_wait( "player_near_motel" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_hotel_obj_breadcrumb" ), "breadcrumb" );

	flag_wait( "mason_at_motel" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	set_objective( level.OBJ_CAPTURE_NORIEGA, level.mason, "remove" );
	set_objective( level.OBJ_CAPTURE_NORIEGA, getstruct( "s_breach_motel_obj" ), "breach" );

	flag_wait( "start_intro_anims" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "remove" );
	
	flag_wait( "motel_room_cleared" );
	
	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "done" );
	
	flag_wait( "motel_scene_end" );

	set_objective( level.OBJ_CAPTURE_NORIEGA, undefined, "delete" );
}

slums_objectives()
{
	
	flag_wait( "motel_scene_end" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ );
	
	flag_wait( "ambulance_complete" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, level.noriega, "follow" );
	
	flag_wait( "slums_update_objective" );
	
	//increase the draw distance of objectives
	level.player SetClientDvar("cg_objectiveIndicatorFarFadeDist", 80000);
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetEnt( "building_enter_front_door", "targetname" ).origin + (0,0,72) );

	flag_wait( "building_breach_ready" );
		
	set_objective( level.OBJ_REACH_CHECKPOINT, GetEnt( "building_breach_obj", "targetname" ).origin, "breach" );
	
	trigger_wait( "trig_building_player_breach" );
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
}

chase_objectives()
{
	flag_wait( "panama_building_start" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, level.mason, "follow" );
	
	trigger_wait("building_side_door_roof_fall");
	
	nurse_trigger = getent("trig_tackle_start", "targetname");
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, nurse_trigger.origin, "help" );
	
	trigger_wait("trig_tackle_start");
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	
	level waittill("end_gauntlet");
	//trigger_wait("chase_door_trigger");
	trigger_noriega = getent("chase_door_trigger", "targetname");
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_FIND_FALSE_PROFIT, trigger_noriega, "breadcrumb" );

	trigger_wait("chase_door_trigger");
	set_objective( level.OBJ_FIND_FALSE_PROFIT, undefined, "done" );
	
	flag_wait( "chase_rescue_noriega" );
	
	//set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "noriega_rescue_marker", "targetname" ), "help" );
	flag_wait( "jump_start" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "jump_obj_marker", "targetname" ), "jump" );
	flag_wait( "checkpoint_approach_one" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, level.mason, "follow" );
	flag_wait( "checkpoint_approach_two" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "checkpoint_approach_marker", "targetname" ), "breadcrumb" );
	flag_wait( "checkpoint_reached" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "remove" );
	flag_wait( "checkpoint_cleared" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, GetStruct( "checkpoint_obj_marker_jeep", "targetname" ), "enter" );
	flag_wait( "checkpoint_finished" );
	
	set_objective( level.OBJ_REACH_CHECKPOINT, undefined, "done" );
}

docks_objectives()
{	
	flag_wait( "docks_cleared" );
	
	set_objective( level.OBJ_DOCKS_SNIPER, GetStruct( "docks_obj_marker_elevator", "targetname" ), "enter" );
	flag_wait( "docks_entering_elevator" );
//	
	set_objective( level.OBJ_DOCKS_SNIPER, Getent( "sniper_noriega_kill_guard_trigger", "targetname" ), "follow" );
	trigger_Wait("sniper_noriega_kill_guard_trigger");
	
	set_objective( level.OBJ_DOCKS_SNIPER, undefined, "done" );
	flag_wait( "docks_kill_menendez" );
	
	set_objective( level.OBJ_CAPTURE_MENENDEZ, undefined, "delete" );
	set_objective( level.OBJ_DOCKS_KILL_MENENDEZ, level.mason, "kill" );
	flag_wait( "docks_mason_down" );
	
	set_objective( level.OBJ_DOCKS_KILL_MENENDEZ, undefined, "done" );
}

load_gumps_panama()
{
	if ( level.script == "panama_2" || level.script == "panama_3" )
	{
		return;
	}
	
//	if ( is_after_skipto( "checkpoint" ) )
//	{
//		load_gump( "panama_gump_4" );
//	}
//	else if ( is_after_skipto( "slums_main" ) )
//	{
//		load_gump( "panama_gump_3" );
//	}
//	if ( is_after_skipto( "house" ) )
//	{
//		level thread load_gump( "panama_gump_2" );
//	}
//	else
//	{
//		level thread load_gump( "panama_gump_1" );
//	}
}

// self == player
nightingale_watch()
{
	self endon( "death" );
	
	self thread nightingale_hint();
	
	while( true )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if( str_weapon_name == "nightingale_dpad_sp" )
		{
			//wait for grenade to reach the ground
			wait 1;	
			
			//e_grenade thread onSpawnDecoy();
			e_grenade thread nightingale_think();
			e_grenade thread nightingale_grab_enemy_attention();
		}
	}
}

// self == nightingale grenade
nightingale_think()
{
	//start the smoke
	PlayFXOnTag( level._effect[ "nightingale_smoke" ], self, "tag_fx" );
	
	const n_bullets = 256;
	
	//shoot friendly weapon bullets
	for ( i = 0; i < n_bullets; i++ )
	{
		v_start_pos = self.origin + ( 0, 0, 10 );
		v_end_pos = v_start_pos + ( 0, 0, 100 );
		v_offset = ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), 0 );
		MagicBullet( "m16_sp", v_start_pos, v_end_pos + v_offset );
		wait 0.05;
	}	
}

// self == nightingale grenade
nightingale_grab_enemy_attention()
{
//	const n_nightingale_dist_max = 850;
	const n_nightingale_dist_max_sq = 722500; // 850 x 850
	const n_check_times = 2;
	n_enemies_attracted = 0;
	
	// grab new enemy's attention certain amount of times
	for ( i = 0; i < n_check_times; i++ )
	{
		a_enemies = GetAIArray( "axis" );
		foreach( ai_enemy in a_enemies )
		{
			if( IsDefined( ai_enemy ) && IsAlive( ai_enemy ) )
			{
				// if the enemy is within a certin radius of the grenade
//				if( Distance2D( self.origin, ai_enemy.origin ) < n_nightingale_dist_max )
				if( Distance2DSquared( self.origin, ai_enemy.origin ) < n_nightingale_dist_max_sq )
				{
					// if the enemy's attention has not been grabbed by the nightingale
					if ( !IsDefined( ai_enemy.grenade_marked ) )
					{
						ai_enemy thread nightingale_react_logic( self );
						ai_enemy thread nightingale_marked();
						n_enemies_attracted++;
					}
				}
			}
		}
		
		wait 1; // give sometime before seeing what new enemy is nearby
	}
	
	if ( n_enemies_attracted > 1 )
	{
		level notify( "nightingale_challenge_completed" );
	}
}

// self == enemy effect by nightingale
nightingale_react_logic( e_grenade )
{
	self endon( "death" );
	e_grenade endon( "death" );
	
	self shoot_at_target( e_grenade, undefined, undefined, 0.5 );
	self aim_at_target( e_grenade, 11 );
}

nightingale_marked()
{
	self endon( "death" );
	
	self.grenade_marked = true;
	
	wait 20;
	
	self.grenade_marked = undefined;
}

nightingale_hint()
{
	level endon( "nightingale_threw" );
	
	level thread hint_timer( "nightingale_selected" );
	screen_message_create( &"PANAMA_HINT_NIGHTINGALE_SELECT" );
	
	while ( !level.player ActionSlotTwoButtonPressed() )
	{
		wait .05;
	}
	
	level notify( "nightingale_selected" );
	
	level thread hint_timer( "nightingale_threw" );
	screen_message_delete();
	screen_message_create( &"PANAMA_HINT_NIGHTINGALE" );
	
	level.player waittill_attack_button_pressed();
	
	screen_message_delete();
	level notify( "nightingale_threw" );
}

hint_timer( str_notify )
{
	level endon( str_notify );
	
	wait 3;
	
	screen_message_delete();
}

onSpawnDecoy()
{
	self endon( "death" );
	
	self.initial_velocity = self GetVelocity();
	delay = 1;
	
	wait (delay );
	decoy_time = 30;
	spawn_time = GetTime();

	self thread simulateWeaponFire();

	while( 1 )
	{
		if ( GetTime() > spawn_time + ( decoy_time * 1000 ))
		{
			self destroyDecoy();
			return;
		}
		
		wait(0.05);
	}
}

moveDecoy( count, fire_time, main_dir, max_offset_angle )
{
	self endon( "death" );
	self endon( "done" );
	
	if ( !(self IsOnGround() ) )
		return;
		
	min_speed = 100;
	max_speed = 200;
	
	min_up_speed = 100;
	max_up_speed = 200;
	
	current_main_dir = RandomIntRange(main_dir - max_offset_angle,main_dir + max_offset_angle);
	
	avel = ( RandomFloatRange( 800, 1800) * (RandomIntRange( 0, 2 ) * 2 - 1), 0, RandomFloatRange( 580, 940) * (RandomIntRange( 0, 2 ) * 2 - 1));

	intial_up = RandomFloatRange( min_up_speed, max_up_speed );
	
	start_time = GetTime();
	gravity = GetDvarint( "bg_gravity" );
	
//	PrintLn( "start time " + start_time );
	for ( i = 0; i < 1; i++ )
	{		
		angles = ( 0,RandomIntRange(current_main_dir - max_offset_angle,current_main_dir + max_offset_angle), 0 );
		dir = AnglesToForward( angles );
		
		dir = VectorScale( dir, RandomFloatRange( min_speed, max_speed ) );
		
		deltaTime = ( GetTime() - start_time ) * 0.001;
		
		// must manually manage the gravity because of the way the Launch function and the tr interpolater work
		up = (0,0, (intial_up) - (800 * deltaTime)  );
		
		//TODO: There is no optional angular velocity parameter on the Launch() function.  Fixed this temporarily by removing the second
		//parameter.  -Jacob True
		//self Launch( dir + up, avel );
		self Launch( dir + up );
		
		wait( fire_time );
	}
//	PrintLn( "end time " + GetTime() );
}

destroyDecoy()
{
	self notify( "done" );
	//self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	// play deactivated particle effect here
}

simulateWeaponFire()
{
	self endon( "death" );
	self endon( "done" );
	
	weapon = "m16_sp";
	
	//self thread watchForExplosion(owner, weapon);
	self thread trackMainDirection();
	
	self.max_offset_angle = 30;
	
	fireTime = 10; //WeaponFireTime(weapon);
	clipSize = 5; // WeaponClipSize(weapon);
	reloadTime = 1.0; //WeaponReloadTime(weapon);

	if ( clipSize  > 30 )
		clipSize = 30;
		
	burst_spacing_min = 2;
	burst_spacing_max = 6;

	while( 1 )
	{
		burst_count = RandomIntRange( Int(clipSize * 0.6), clipSize );
		interrupt = false; // RandomIntRange( 0, 2 );
		self thread moveDecoy( burst_count, fireTime, self.main_dir, self.max_offset_angle );
		//self fireburst( weapon, fireTime, burst_count, interrupt );

		//finishWhileLoop(weapon, reloadTime, burst_spacing_min, burst_spacing_max);
	}
}


fireburst( weapon, fireTime, count, interrupt )
{
	interrupt_shot = count;
	
	if ( interrupt )
	{
		interrupt_shot = Int( count * RandomFloatRange( 0.6, 0.8 ) ); 
	}
	
	//self FakeFire( self.origin, weapon, interrupt_shot );
	wait ( fireTime * interrupt_shot );
	
	if ( interrupt )
	{
		//self FakeFire( owner, self.origin, weapon, count - interrupt_shot );
		wait ( fireTime * (count - interrupt_shot) );
	}
}

trackMainDirection()
{
	self endon( "death" );
	self endon( "done" );
	self.main_dir = Int(VectorToAngles((self.initial_velocity[0], self.initial_velocity[1], 0 ))[1]);
	
	up = (0,0,1);
	while( 1 )
	{
		self waittill( "grenade_bounce", pos, normal );
		
		dot = VectorDot( normal, up );
		
		// something got in the way thats somewhat vertical 
		if ( dot < 0.5 && dot > -0.5 ) 
		{
			self.main_dir = Int(VectorToAngles((normal[0], normal[1], 0 ))[1]);
		}
	}
}


//threaded once on the player at the start of the level
ir_strobe_watch()
{
	self endon( "death" );
	
	//check for multiple calls since this bool is created
	if( IsDefined( level.strobe_active ) )
	{
		return;
	}
	
	screen_message_create( "Use strobe grenades to call down AC130 fire on a position" );
	
	delay_thread( 5.0, ::screen_message_delete );

	level.strobe_active = false;
	level.strobe_queue = [];
	
	//function that watches for active but unused strobes
	self thread _ir_strobe_queue();
	
	while( 1 )
	{
		self waittill( "grenade_fire", e_grenade, str_weapon_name );
		
		if( str_weapon_name == "irstrobe_dpad_sp" )
		{
			e_grenade.active = true;
			e_grenade ent_flag_init( "start_fire" );
			level.strobe_queue[ level.strobe_queue.size ] = e_grenade;
			e_grenade thread _ir_strobe_logic();
		}
	}
}

_ir_strobe_queue()
{
	self endon( "death" );
	
	while( 1 )
	{
		if( !level.strobe_active )
		{
			for( i = 0; i < level.strobe_queue.size; i++ )
			{
				if( level.strobe_queue[i].active )
				{
					level.strobe_active = true;
					level.strobe_queue[i] ent_flag_set( "start_fire" );
					break;
				}
			}
		}
		
		wait 1;
	}
}

_ir_strobe_logic()
{
	//wait a few seconds before starting strobe
	wait 2;
	
	//create strobe blinking FX	
	e_model = spawn( "script_model", self.origin );
	e_model SetModel( "tag_origin" );
	PlayFxOnTag(level._effect["ir_strobe"], e_model, "tag_origin");
	e_model playloopsound( "fly_irstrobe_beep", .1 );

	//wait in queue until ready
	self ent_flag_wait( "start_fire" );
	
	//a reasonable time for the AC130 to get in firing position
	wait 3;	
	
	//check for LOS with the sky
	traceData = BulletTrace( self.origin, self.origin + (0,0,256), false, self );
	if( ( traceData[ "fraction" ] == 1 ) && !flag( "post_gauntlet_mason_open_door" ) )
	{
		//rain vulcan bullets
		v_end_pos = self.origin;
		ac130_shoot( v_end_pos, true );
	}
	else if( IsDefined(traceData["entity"]) && traceData["entity"].classname == "script_vehicle" ) //TODO: MAKE SURE THIS WILL BLOW UP DESTRUCTIBLE CARS AS WELL
	{
		if( traceData["entity"].vehicletype == "apc_m113" )
		{
			wait 6;	
		}
		else
		{
			//rain vulcan bullets
			v_end_pos = self.origin;
			ac130_shoot( v_end_pos, true );
		}
	}
	else
	{
		wait 6;
	}
	
	self.active = false;
	level.strobe_active = false;
	e_model delete();
	
}

air_ambience( str_veh_targetname, str_paths, flag_ender, n_min_wait, n_max_wait )
{
	if( !IsDefined( n_min_wait ) )
	{
		n_min_wait = 4.0;
	}
	
	if( !IsDefined( n_max_wait ) )
	{
		n_max_wait = 6.0;	
	}
	
	a_paths = GetVehicleNodeArray( str_paths, "targetname" );
	nd_last_path = a_paths[0];
	
	while( !flag( flag_ender ) )
	{
		nd_path = a_paths[ RandomInt( a_paths.size ) ];
		while( nd_path == nd_last_path )
		{
			nd_path = a_paths[ RandomInt( a_paths.size ) ];
		}
		nd_last_path = nd_path;
		
		v_jet = spawn_vehicle_from_targetname( str_veh_targetname );
		v_jet thread _air_ambience_think( nd_path );
		v_jet SetForceNoCull();
		
		if ( v_jet.vehicletype == "plane_mig23" )
		{
			v_jet thread add_jet_fx();
		}
		
		wait RandomFloatRange( n_min_wait, n_max_wait );
	}
}

_air_ambience_think( nd_path )
{
	self getonpath( nd_path );
	self gopath();
	VEHICLE_DELETE( self );
}

add_jet_fx()
{
	PlayFXOnTag( level._effect[ "jet_contrail" ], self, "tag_wingtip_l" );
	PlayFXOnTag( level._effect[ "jet_contrail" ], self, "tag_wingtip_r" );
	
	PlayFXOnTag( level._effect[ "jet_exhaust" ], self, "tag_engine_fx" );
}

ac130_ambience( flag_ender )
{
	while( !flag( flag_ender ) )
	{
		//find a position 5000 units roughly away from the player in front of him
		v_forward = AnglesToForward( level.player GetPlayerAngles() ) * 5000;
		v_end_pos = level.player.origin + ( v_forward[0], v_forward[1], 0 );
		
		//an additional offset of a 2000 radius
		v_offset = ( RandomIntRange( -2000, 2000 ), RandomIntRange( -2000, 2000 ), 0 );
		v_end_pos = v_end_pos + v_offset;
		
		ac130_shoot( v_end_pos );		
		
		wait 5;
	}
}

ac130_shoot( v_end_pos, b_close )
{
	//the start position is about 3500 units above 0, just below the skybox
	v_start_pos = (v_end_pos[0], v_end_pos[1], 3500);
	
	//the fx play position is even higher, out of the skybox	
	v_fx_pos = v_start_pos;
	
	sound_ent = spawn( "script_origin", v_start_pos );
	
	//this call is made close to a player
	if( IsDefined( b_close ) && b_close )
	{
		Earthquake( 0.3, 8, v_end_pos, 1028 );
		level.player thread _ac130_vibration( v_start_pos );
		level thread _ac130_clear_enemies( v_start_pos );
	}
					
	for ( i = 0; i < 60; i++ )
	{
		v_offset_end = v_end_pos + ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), 0 );
		
		sound_ent playloopsound( "wpn_ac130_fire_loop_npc", .25 );
		MagicBullet( "ac130_vulcan_minigun", v_start_pos, v_offset_end );
		PlayFX( getfx( "ac130_sky_light" ), v_end_pos);
		wait 0.1;
	}
	
	sound_ent playsound( "wpn_ac130_fire_loop_ring_npc" );
	sound_ent delete();
	
	//stops rumble from the gunfire if it was going
	if( IsDefined( b_close ) && b_close )
	{
		level.player notify( "stop_rumble_check" );
	}
}

_ac130_vibration( v_start_pos )
{
	self endon( "stop_rumble_check" );
	
	while( 1 )
	{
		if( Distance2D( v_start_pos, self.origin ) < 1028 )
		{
			self PlayRumbleOnEntity( "damage_heavy" );
		}
		wait 0.05;
	}
}

_ac130_clear_enemies( v_start_pos )
{
	wait 1;
	
	a_axis = GetAIArray( "axis" );
	foreach( e_enemy in a_axis )
	{
		//if the enemy is currently distracted with a nightingale grenade kill them and notify the challenge
		if( IsAlive( e_enemy) && IsDefined( e_enemy.grenade_marked ) && e_enemy.grenade_marked )
		{
			MagicBullet( "ac130_vulcan_minigun", v_start_pos, e_enemy.origin );
			e_enemy die();
			level notify( "combo_death" );
			wait RandomFloatRange( 0.5, 1.0 );
		}
		//kill any enemies in the radius of the strobe grenade
		else if( IsAlive( e_enemy ) && ( Distance2D( v_start_pos, e_enemy.origin ) < 800 ) )
		{
			MagicBullet( "ac130_vulcan_minigun", v_start_pos, e_enemy.origin );
			e_enemy die();
			wait RandomFloatRange( 0.5, 1.0 );
		}
	}
}

sky_fire_light_ambience( str_area, flag_ender )
{
	a_exploder_id = [];
	
	switch( str_area )
	{
		case "airfield":
			a_exploder_id[0] = 102;
			a_exploder_id[1] = 103;
			a_exploder_id[2] = 104;
			a_exploder_id[3] = 105;
			break;
		case "slums":
			a_exploder_id[0] = 501;
			a_exploder_id[1] = 502;
			a_exploder_id[2] = 503;
			a_exploder_id[3] = 504;
			break;
	}
	
//	while( !flag( flag_ender ) )
//	{
//		wait RandomFloatRange( 5.0, 8.0 );
//		
//		n_exploder_id = a_exploder_id[ RandomInt( a_exploder_id.size ) ];
//		exploder( n_exploder_id );
//	}
}

player_lock_in_position( origin, angles )
{
	link_to_ent = spawn("script_model", origin);
	link_to_ent.angles = angles;
	link_to_ent setmodel("tag_origin");
	self playerlinktoabsolute(link_to_ent, "tag_origin");
	
	self waittill("unlink_from_ent");
	self unlink();
	link_to_ent delete();
}

old_man_woods( str_movie_name, notify_special )
{
	level clientnotify( "omw_on" );
	flag_clear( "movie_done" );
	flag_set( "movie_started" );
	play_movie( str_movie_name, false, false, undefined, true, "movie_done", 1 );
	flag_set( "movie_done" );
	flag_clear( "movie_started" );
	if(IsDefined (notify_special))
	{
		level clientnotify(notify_special);	
	}
	else
	{
		level clientnotify( "omw_off" );	
	}
}

run_anim_to_idle( str_start_scene, str_idle_scene )
{
	run_scene( str_start_scene );
	level thread run_scene( str_idle_scene );
}

fail_player( str_dead_quote_ref )
{
	SetDvar( "ui_deadquote", str_dead_quote_ref );
	level notify( "mission failed" );
	maps\_utility::missionFailedWrapper();
}

set_custom_flashlight_values( range, startRadius, endRadius, FOVInnerFraction, brightness, offset, color, bob_amount )
{
	//level wait_for_all_players();
	wait( 1.0 );
	
	// Turn on the light!
	SetSavedDvar( "r_enableFlashlight","1" );

	// Basic flashlight settings
	SetSavedDvar( "r_flashLightRange", range );
	SetSavedDvar( "r_flashLightStartRadius", startRadius );
	SetSavedDvar( "r_flashLightEndRadius", endRadius );
	SetSavedDvar( "r_flashLightFOVInnerFraction", FOVInnerFraction );
	SetSavedDvar( "r_flashLightBrightness", brightness );
	SetSavedDvar( "r_flashLightOffset", offset );
	SetSavedDvar( "r_flashLightColor", color );
	SetSavedDvar( "r_flashLightColor", bob_amount );
}

notify_on_lookat_trigger( str_trig_name, str_notify )
{
	level endon( str_notify ); //-- for multiple instances
	
	trigger_wait( str_trig_name, "targetname");
	level notify( str_notify );
}

// self == person that is about to use say_dialog
waittill_done_talking()
{
	while ( IS_TRUE( self.is_talking ) )
	{
		wait 0.05;
	}
}

