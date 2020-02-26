/*
la_2_fly.gsc - contains all functionality for air-to-air section of LA_2 
 */

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\la_utility;
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

main()
{
	
}

f35_dogfights()
{
	level thread maps\la_2_convoy::convoy_register_stop_point( "convoy_dogfight_stop_trigger", "convoy_continue" );
	level delay_thread( 4, ::flag_set, "convoy_continue" );
	level delay_thread( 3.5, ::flag_set, "convoy_at_dogfight" );	
	
	level.b_pip_5_played = false;
	level.b_pip_6_played = false;
	level.b_pip_7_played = false;
	
//	flag_wait( "convoy_at_dogfight" );
		
	maps\_lockonmissileturret::EnableLockOn();
	
	level thread maps\la_2_ground::convoy_blocked_by_debris();
	
	flag_set( "no_fail_from_distance" );
	flag_set( "convoy_nag_override" );  // don't play convoy damage/distance nag lines right now
	//level thread maps\la_2_player_f35::f35_tutorial_func( &"LA_2_HINT_MODE_PLANE", undefined, maps\la_2_player_f35::f35_control_check_mode, "dogfight_done" );

	// Fail setups	
	dogfights_monitor_warning_distance();
	dogfights_monitor_failure_distance();
	
	//level thread _autosave_after_bink();
		
	//t_lookat = get_ent( "greenlight_blast_off_lookat_trigger", "targetname", true );
	//t_lookat waittill( "trigger" );
	
	if ( level.skipto_point != "f35_dogfights" )
	{
		trigger_wait( "trig_dogfights_start", "targetname" );
	}
	
	level notify( "end_ambient_drones" );
	
//	wait 1.5;  // slight delay
	PlaySoundAtPosition("evt_pack_flyby", (-2213, 5513, 2346));
	
	//Notify for Room Change for Audio
	ClientNotify ("dfs_go");
	
	SetCullDist( 0 );
	level clientnotify( "set_jet_fog_banks" );
	level.player SetClientDvar("cg_tracerSpeed", 25000 ); 
	
	//SOUND - Shawn J
	//iprintlnbold ("air_to_air");
	level.player playsound ("evt_air_to_air");
	
	setmusicstate ("LA_2_DOGFIGHT");
	
	level thread maps\la_2_anim::vo_ground_air_transition();	
	level thread dogfight_event_logic();
	level thread dogfight_ambient_building_explosions();
	
	//-- 0.7 is the length of the spline for the lead in of the first drones
	level notify( "start_dogfight_event" );
			
//	e_temp waittill( "movedone" );
	wait 0.05; // wait a frame to prevent camera from freaking out
	//-- try to smooth out some of the earthquake shake
	level notify("stop_dogfight_shake");
	level thread _gentle_shake( 2.0 ); //-- 2 extra seconds of screen shake
	
	level.f35 thread maps\la_2_anim::vo_dogfight_f35();
	
	t_lookat = get_ent( "greenlight_blast_off_lookat_trigger", "targetname", true );
	t_lookat waittill( "trigger" );	
	
	level.f35 SetHeliHeightLock( false );
//	SetSavedDvar( "vehPlaneConventionalFlight", "1" );
	exploder( 700 );	
	
	flag_set( "dogfights_story_done" );
	
	level thread change_dogfights_fog_based_on_height();
	
	level thread _autosave_after_bink();
	
	scale_model_LODs( 1, 1 );
	
	flag_wait( "dogfight_done" );
	flag_clear( "convoy_nag_override" );
}

_autosave_after_bink()
{
	flag_waitopen( "pip_playing" );
	autosave_by_name( "la_2" );
}

_gentle_shake( n_time )
{
	n_shake_value = 0.2;
	n_loops = n_time / 0.05;
	n_shake_decrement = n_shake_value / n_loops;
	
	while( n_shake_value > 0 )
	{
		Earthquake( n_shake_value, 0.05, level.player.origin, 10000, level.player );
		n_shake_value -= n_shake_decrement;
		wait 0.05;
	}

}

_blast_off_sequence( n_time )
{
	level endon("stop_dogfight_shake");
	const n_rumble_delay = 0.25;
	n_count = Int( n_time / n_rumble_delay );
	
	level thread maps\la_2_anim::vo_ground_air_transition();
	level.player thread rumble_loop( n_count, n_rumble_delay, "damage_heavy" );
	
	while( true )
	{
		Earthquake( 0.25, 0.15, level.player.origin, 10000, level.player );
		wait 0.05;
	}
}

//-- turns targetting on and off depending on if the player is following a non-essential drone
//self == level.f35
mark_targetted_enemies_as_targets()
{
	while ( !flag( "dogfight_done" ) )
	{
		a_closest_drones = get_array_of_closest( level.player.origin, level.aerial_vehicles.axis, undefined, 10, 35000 );
				
		forward = AnglesToForward( level.player GetPlayerAngles() );
		
		bestdot = -999;
		chosenindex = -1;
		fov =  GetDvarFloat( "cg_fov" );
		
		weaponName = level.player GetTurretWeaponName();
		radius =  WeaponLockOnRadius( weaponName ) + 10;
		
		for ( i = 0; i < a_closest_drones.size; i++ )
		{
			if(target_isincircle( a_closest_drones[i], level.player, fov, radius ))
			{
				chosenIndex = i;
				break;				
			}
		}
		
		if(chosenindex > -1)
		{
			player_target = a_closest_drones[chosenindex];
			Target_Set( player_target );
		}
		else
		{
			player_target = self;	
		}
		
		
		a_temp = Target_GetArray();
	
		for ( i = 0; i < a_temp.size; i++ )
		{
			if( IS_TRUE( a_temp[i].objective_target ) || player_target == a_temp[i] )
			{
				//-- don't do anything, this one is supposed to be marked
			}
			else
			{
				Target_Remove( a_temp[ i ] );
			}
		}
		
		/* -- when isAssistedFlying works, uncomment this
		while( IS_TRUE( self.isAssistedFlying) )
		{
			wait 0.05;
		}
		*/
		
		wait(0.15);
	}
}

dogfights_monitor_warning_distance()
{
	a_warning_triggers = get_ent_array( "air_warning_trigger", "targetname", true );
	
	array_thread( a_warning_triggers, ::_dogfights_warning_distance_check );
}

_dogfights_warning_distance_check()
{
	// endon? 
	
	const n_warning_frequency = 4;
	n_warning_frequency_ms = n_warning_frequency * 1000;
	const n_wait_time_min = 0.8;
	const n_wait_time_max = 1.5;
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		e_triggered.dogfight_warning = true;		
		n_time = GetTime();
		
		if ( !IsDefined( e_triggered.dogfight_warning_time_last ) )
		{
			e_triggered.dogfight_warning_time_last = 0;
		}
		
		b_should_warn = false;
		if ( ( n_time - e_triggered.dogfight_warning_time_last ) > n_warning_frequency_ms )
		{
			b_should_warn = true;
		}
		
		if ( b_should_warn )
		{
			//level.f35 thread say_dialog( "F35_dogfight_distance_warning" );
			e_triggered.dogfight_warning_time_last = n_time;
		}
		
		n_wait_time = RandomFloatRange( n_wait_time_min, n_wait_time_max );
		wait n_wait_time;
	}
}

dogfights_monitor_failure_distance()
{
	a_failure_triggers = get_ent_array( "air_failure_trigger", "targetname", true );
	
	array_thread( a_failure_triggers, ::_dogfights_failure_distance_check );
}

_dogfights_failure_distance_check()
{
	// endon? 
	
	n_wait_min = 0.8;
	n_wait_max = 1.5;
	
	while ( true )
	{
		self waittill( "trigger", e_triggered );
		
		if ( IsPlayer( e_triggered ) && !IsGodMode( e_triggered ) )
		{
			SetDvar( "ui_deadquote", &"LA_2_DISTANCE_FAIL" );
			MissionFailed();
		}
		
		n_wait_time = RandomFloatRange( n_wait_min, n_wait_max );
		wait n_wait_time;
	}
}

_shake_in_jetwash()
{
	self endon( "death" );
	level endon( "dogfight_done" );
	
	while(1)
	{
		if( GetDvar("vehPlaneAssistedFlying") == "1")
		{
			if(IsDefined( level.player.missileTurretTarget ) )
			{
				if(DistanceSquared( level.player.missileTurretTarget.origin, level.f35.origin ) < 5000 * 5000)
				{
					Earthquake( 0.05, 0.15, level.player.origin, 10000, level.player );
					level.player PlayRumbleOnEntity( "damage_light" );
				}
				else if(DistanceSquared( level.player.missileTurretTarget.origin, level.f35.origin ) < 2500 * 2500)
				{
					Earthquake( 0.15, 0.15, level.player.origin, 10000, level.player );
					level.player PlayRumbleOnEntity( "damage_light" );
				}
			}
		}
		
		wait 0.15;
	}
	

}

//-- made for Greenlight, but useful overall.  More specific storytelling logic for the air to air section
dogfight_event_logic()
{
	define_air_to_air_offsets();
	
	_setup_deathblossom_offsets( "temp_drone", "deathblossom_special" );
	
	level waittill( "start_dogfight_event" );
	
	//-- jetwash shake
	level.f35 thread _shake_in_jetwash();
	
	//-- track kills
	level thread _dogfight_track_kills_for_vo();
	
	//-- vo threads
//	level thread maps\la_2_anim::vo_convoy_strafed();
	level thread maps\la_2_anim::vo_player_strafed();
	level.f35 thread maps\la_2_anim::vo_f38_target_lock_on_and_off();
	level thread maps\la_2_anim::vo_f38_shot_down_drone();
	level thread maps\la_2_anim::vo_player_shot_down_drone();
	
	//-- the intial strafing wave
	
	level thread dogfights_manage_wave_count();
	
	// -- the ambient drone manager
	level thread dogfight_ambient_drone_spawn_manager();
	
	level.b_should_match_speed = false;
	level.b_should_exceed_speed = false;
	
	level thread dogfight_friendly_vo_callouts();
	
	flag_set( "dogfight_wave_1" );
	
	level thread spawn_convoy_f35_allies( "start_flyby_to_convoy", 2, 1 );	
	spawn_convoy_strafing_wave( "start_flyby_to_convoy", 5, 1 );
	
	autosave_by_name( "strafe_1_complete" );
	
	wait_until_convoy_can_move( "convoy_moveto_second_position" );
	flag_set( "dogfight_wave_2" );
	maps\la_2::convoy_move_to_position( "convoy_moveto_second_position" );	
	
	level notify( "drone_wave_complete" );

//	spawn_convoy_f35_allies( "start_flyby_to_convoy", 2, 2, true );		
	
	level thread spawn_convoy_f35_allies( "start_flyby_to_convoy", 2, 2 );			
	autosave_by_name( "strafe_2_complete" );
	spawn_convoy_strafing_wave( "start_flyby_to_convoy", 6, 2 );
	
	wait_until_convoy_can_move( "convoy_moveto_final_position" );
	maps\la_2::convoy_move_to_position( "convoy_moveto_final_position" );
	
	level notify( "drone_wave_complete" );	
	
	level thread spawn_convoy_f35_allies( "start_flyby_to_convoy", 2, 3 );				
	flag_set( "dogfight_wave_3" );
	spawn_convoy_strafing_wave( "start_flyby_to_convoy", 8, 3 );
	
	autosave_by_name( "strafe_3_complete" );

	level notify("kill_flybys_remotely");
//	level.player say_dialog("fuck_theyre_th_070");
	//level.player say_dialog("warning_h_enemy_ai_030");
	
	wait_until_convoy_can_move( "convoy_moveto_eject_sequence" );
	maps\la_2::convoy_move_to_position( "convoy_moveto_eject_sequence" );
	
	flag_set( "dogfight_done" );
	level thread spawn_eject_friendly_follow_plane();
	
	level thread pip_start( "la_pip_seq_8" );
	level.player say_dialog( "a_drone_is_lining_049", 1.5 );		// A drone is lining up for an attack run on the President's convoy!
	level thread maps\la_2_anim::vo_convoy_distance_check_nag();
	
//	level.player say_dialog( "we_just_took_a_dir_052" );
	
//	spawn_death_blossom_special();
//	level.player thread say_dialog("fuck_yeah_055");
//	level notify( "dogfight_done" );
	
	//screen_fade_out( 2.0 );
	//nextmission();
}

dogfight_friendly_vo_callouts()
{
	a_general_vo = array( "convoy_tracking_si_019", "tracking_target_h_039", "target_lock_veloci_040", "maintaining_curren_041", "altitude_locked_042", "air1_i_have_lock_0", "air1_engaging_0", "air1_firing_missiles_0", "air1_nose_cannon_firing_0" );
	a_wave1_vo = array( "air2_he_s_on_me_tight_0", "air2_i_m_hit_0", "air1_break_right_0", "air2_got_drones_on_your_t_0" );
	a_wave2_vo = array( "air2_get_him_off_me_0", "air2_dammit_i_got_a_dro_0", "air1_break_left_0", "air2_i_can_t_shake_him_0", "air2_i_m_gonna_have_to_ej_0", "air2_eject_eject_eject_0" );
	a_wave3_vo = array( "air2_there_s_too_many_of_0", "air2_got_drones_buzzing_a_0", "air1_come_on_you_son_of_a_0", "air2_i_m_going_right_you_0", "air2_ejecting_now_0", "air2_i_am_going_down_i_0" );
	a_vo_callouts = [];
		
	flag_wait( "dogfights_story_done" );
	wait 5;	// delay for initial vo
	a_vo_callouts[ "generic" ]	= ArrayCombine( a_general_vo, a_wave1_vo, false, false );
	level thread vo_callouts( "player", "allies", a_vo_callouts, "dogfight_wave_2" );
	flag_wait( "dogfight_wave_2" );
	a_vo_callouts[ "generic" ]	= ArrayCombine( a_general_vo, a_wave2_vo, false, false );
	level thread vo_callouts( "player", "allies", a_vo_callouts, "dogfight_wave_3" );		
	flag_wait( "dogfight_wave_3" );
	a_vo_callouts[ "generic" ]	= ArrayCombine( a_general_vo, a_wave3_vo, false, false );
	level thread vo_callouts( "player", "allies", a_vo_callouts, "dogfight_done" );		
	flag_wait( "dogfight_done" );
	n=1;
}

define_air_to_air_offsets()
{
	//-- these are hard coded arrays of allowable offset groupings
	level.a_air_to_air_offsets = [];
	
	level.a_air_to_air_offsets[ "convoy" ] = [];
	level.a_air_to_air_offsets[ "convoy" ][0] = (1000,1000,0);
	level.a_air_to_air_offsets[ "convoy" ][1] = (-100,1000,0);
	level.a_air_to_air_offsets[ "convoy" ][2] = (1000,-1000,0);
	level.a_air_to_air_offsets[ "convoy" ][3] = (-100,-1000,0);
	
	
	level.a_air_to_air_offsets[ "player" ] = [];
	level.a_air_to_air_offsets[ "player" ][0] = (1000,1000,0);
	level.a_air_to_air_offsets[ "player" ][1] = (-1000,1000,0);
	level.a_air_to_air_offsets[ "player" ][2] = (1000,-1000,0);
	level.a_air_to_air_offsets[ "player" ][3] = (-1000,-1000,0);
	
	level.a_air_to_air_offsets[ "allies" ] = [];
	level.a_air_to_air_offsets[ "allies" ][0] = ( 1650, -1500, 0);
	level.a_air_to_air_offsets[ "allies" ][1] = ( 1650, 1500, 0);
	level.a_air_to_air_offsets[ "allies" ][2] = ( 2500, -1500, 1500 );
	level.a_air_to_air_offsets[ "allies" ][3] = ( 2500, 1500, 1500 );

	level.a_air_to_air_offsets[ "axis" ] = [];
	level.a_air_to_air_offsets[ "axis" ][0] = ( 1500, -3000, 0);
	level.a_air_to_air_offsets[ "axis" ][1] = ( 1500, 3000, 1500);
	level.a_air_to_air_offsets[ "axis" ][2] = ( -1500, -3000, -1500);
	level.a_air_to_air_offsets[ "axis" ][3] = ( -1500, 5000, 1000 );
	level.a_air_to_air_offsets[ "axis" ][4] = ( 1500, -5000, -1000 );
	level.a_air_to_air_offsets[ "axis" ][5] = ( 1500, 1750, -3000 );
	level.a_air_to_air_offsets[ "axis" ][6] = ( -1500, -1750, 3000 );
	level.a_air_to_air_offsets[ "axis" ][7] = ( -1500, 1750, 0);	
	level.a_air_to_air_offsets[ "axis" ][8] = ( 1500, -1750, 0);
	level.a_air_to_air_offsets[ "axis" ][9] = ( 1500, 1750, 0);
	level.a_air_to_air_offsets[ "axis" ][10] = ( -1500, -1750, 0);
	level.a_air_to_air_offsets[ "axis" ][11] = ( -1500, 1750, 0);

	level.highway_routes = [];
	level.highway_routes[0] = [];
	level.highway_routes[0][0] = "north_east_to_north_west_transfer";
	level.highway_routes[0][1] = "north_east_to_south_east_transfer";
	level.highway_routes[0][2] = "north_east_to_south_west_transfer";	
	
	level.highway_routes[1] = [];
	level.highway_routes[1][0] = "south_east_to_north_east_transfer";
	level.highway_routes[1][1] = "south_east_to_south_west_transfer";
	level.highway_routes[1][2] = "south_east_to_north_west_transfer";	

	level.highway_routes[2] = [];
	level.highway_routes[2][0] = "south_west_to_north_east_transfer";
	level.highway_routes[2][1] = "south_west_to_south_east_transfer";
	level.highway_routes[2][2] = "south_west_to_north_east_transfer";
	
	level.plane_radii = [];
	level.plane_radii["allies"] = 500;
	level.plane_radii["axis"] = 750;
}

spawn_eject_friendly_follow_plane()
{
//	level thread spawn_convoy_f35_allies( "start_flyby_for_eject", 1, 4, true, false );
//	wait .1;	
//	a_friendly = GetEntArray( "convoy_f35_ally_4", "targetname" );
//	a_friendly[0] _dogfight_follow_ally( false );
//	level thread wave_speed_monitor( a_friendly, 4000, 3000 );
//	a_friendly[0] thread _dogfight_speed_monitor( undefined, undefined, undefined, undefined, 0.5 );
	
	define_air_to_air_offsets();

	level thread spawn_convoy_f35_allies( "start_flyby_for_eject", 1, 4, undefined, true, false );				
	level thread spawn_convoy_strafing_wave( "start_flyby_for_eject", 4, 4 );	
	
	wait 1; 		// wait for all the planes to spawn in
	a_enemy_planes = GetEntArray( "convoy_strafing_plane", "targetname" );
	foreach( vh_plane in a_enemy_planes )
	{
		vh_plane veh_magic_bullet_shield( true );
	}
}

wait_until_convoy_can_move( str_structs_name )
{
	a_moveto_structs = GetStructArray( str_structs_name, "targetname" );
	a_vehicles = level.convoy.vehicles;
	
	can_move = false;
	
	while ( !can_move )
	{
		can_see_convoy = level.player is_player_looking_at( a_vehicles[0].origin, .7, false );
		can_see_moveto = level.player is_player_looking_at( a_moveto_structs[0].origin, .7, false );
		
		if( !can_see_convoy && !can_see_moveto )
		{
			can_move = true;	
		}
		
		wait 0.25;
	}	
}

dogfights_manage_wave_count()
{
	level endon( "dogfight_done" );
	
	level.n_current_strafing_wave = 1;
	
	while( true )
	{
		level waittill( "drone_wave_complete" );	
		level.n_current_strafing_wave++;
	}
	
}

pip_dogfights_1()
{
//	level thread pip_start( "pip_convoy_1" );
//	level.player say_dialog( "a_drone_is_lining_049" );
//	level.player say_dialog( "youve_got_to_shoo_050" );
	//level notify( "convoy_being_fired_on" );		
}

_setup_deathblossom_offsets( str_temp_planes , str_veh_pathnode )
{
	level.a_death_blossom_offsets = [];
	
	a_planes = GetEntArray( str_temp_planes, "targetname" );
	veh_node = GetVehicleNode( str_veh_pathnode, "targetname" );
	
	foreach( e_plane in a_planes )
	{
		ARRAY_ADD( level.a_death_blossom_offsets, (e_plane.origin - veh_node.origin) );
	}
	
	array_delete( a_planes );
}

_set_direction_on_nodes( str_node_targetname )
{
	nd_node_a = GetVehicleNode( str_node_targetname, "targetname" );
	nd_node_b = GetVehicleNode( nd_node_a.target, "targetname" );
	
	while( !IsDefined( nd_node_a.script_dir ) )
	{
		nd_node_c = GetVehicleNode( nd_node_b.target, "targetname" );
		
		v_b_to_c = nd_node_c.origin - nd_node_b.origin;
		temp_pos = nd_node_b.origin + (v_b_to_c / 4);

		nd_node_a.script_dir = VectorNormalize( temp_pos - nd_node_a.origin );
		
		nd_node_a = nd_node_b;
		nd_node_b = GetVehicleNode( nd_node_a.target, "targetname" );
	}
}

_set_strafing_run_objective_on_plane( n_index )
{
	const OBJ_MAX_DIST = 255000 * 255000;
	
	// objective marker
	if ( !IsDefined( level.dogfights_objective_strafe_marker_active ) )
	{
		level.dogfights_objective_strafe_marker_active = true;
		Objective_Add( level.OBJ_DOGFIGHTS_STRAFE, "current" );
		Objective_Set3D( level.OBJ_DOGFIGHTS_STRAFE, true, "red" );
	}	
	
	//Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, self );
	
	self.objective_target = 1;
	Target_Set( self );	
	is_objective_on = true;
	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, self );	
	
	while ( IsAlive( self ) )
	{	
		wait 1;
		
		if ( !IsAlive( self ) )
		{
			Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, ( 0, 0, 0 ) );	
			return;
		}
		
		can_see = level.player is_player_looking_at( self.origin, .7, false );
		n_dist = DistanceSquared( level.player.origin, self.origin );
		if ( is_objective_on && can_see )
		{
			is_objective_on = false;
			Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, ( 0, 0, 0 ) );	
		}
		else if ( !is_objective_on && ( !can_see ) )
		{
			is_objective_on = true;
			Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, self );		
		}
	}
		
	// self waittill_either( "death", "dogfight_done" );

	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS_STRAFE, n_index, ( 0, 0, 0 ) );  // clears additional position
	level.aerial_vehicles.dogfights.killed_total++;
	dogfights_objective_update_counter();
}

play_specialized_shot_audio()
{
	level.player waittill( "missile_fire", missile );
	clientnotify( "gnses" );
	setmusicstate ("LA_2_END");
	level.player playsound( "wpn_f35_rocket_fire_green" );
}

waitfor_leadplane_death( plane, array )
{
	plane waittill( "death" );
	
	origin = plane.origin;
	
	playsoundatposition( "exp_f35_missile_explo_green", origin );
	
	for(i=0;i<7;i++)
	{
		playsoundatposition( "wpn_death_blossom_fire_green", origin );
		wait(randomfloatrange(0,.1));
	}
}


//-- for now this is basically a dupe of spawn_convoy_strafing_wave
spawn_player_strafing_wave( n_scripted_count )
{
	level endon( "dogfight_done" );
	
	//const N_FLYBY_COUNT = 2;  // number of guys in a flyby 'pack'
	
	if(IsDefined(n_scripted_count))
	{
		N_FLYBY_COUNT = n_scripted_count;	
	}
	else
	{
		N_FLYBY_COUNT = 2;
	}
	
	const MAX_DISTANCE_FOR_FLYBY = 20000;
	
	// pause flybys
	flag_clear( "force_flybys_available" );
	flag_set( "strafing_run_active" );
	
	a_planes = [];
	
	vh_lead_plane = undefined;
	
	//-- imply threat on
	LUINotifyEvent( &"hud_missile_incoming", 1, 1 );
	level thread _pulse_hud_circle();
	
	for( i =0; i < 6; i++ )
	{
		//-- shoot at the player
		level thread player_strafe_burst_firing();	
		wait 0.5;
	}
	
	
	for ( i = 0; i < N_FLYBY_COUNT; i++ )
	{		
		//vh_plane = plane_spawn( "pegasus_fast_la2", ::dogfight_player_strafe, vh_lead_plane );
		vh_plane = plane_spawn( "avenger_fast_la2" );
		vh_plane init_chaff();
		vh_plane thread dogfight_countermeasures_think();
		vh_plane thread _dogfight_speed_monitor( "player", i-1 );
		
		while(!(vh_plane dogfight_player_strafe( vh_lead_plane, i - 1 )) )
		{
			wait(0.05);
		}
		
			//vh_plane ent_flag_init( "is_tracking" );
		vh_plane thread _dogfight_fire_on_command( "player" );
		vh_plane _setup_plane_firing_by_type();
		vh_plane thread _set_strafing_run_objective_on_plane( i );
		
		if( !IsDefined(vh_lead_plane) )
		{
			vh_lead_plane = vh_plane;
		}
		
		a_planes[ a_planes.size ] = vh_plane;
		
		wait 0.25;
	}
	
	level thread wave_speed_monitor( a_planes );
	
	//-- imply threat off
	level notify( "stop_circle_pulse" );
	LUINotifyEvent( &"hud_missile_incoming", 1, 0 );
	
	array_wait( a_planes, "death" );
		
	//iprintlnbold( "strafing run done" );
	flag_clear( "strafing_run_active" );
}

_pulse_hud_circle()
{
	level endon("stop_circle_pulse");
	
	const n_max = 1000;
	n_current = 1000;
	
	while (true)
	{
		LUINotifyEvent( &"hud_missile_incoming_dist", 2, Int(n_current / 12), Int(n_max / 12) );
		n_current = n_current - 40;
		
		if(n_current <= 100)
		{
			n_current = n_max;	
		}
		
		wait 0.05;
	}
}

spawn_convoy_strafing_wave( initial_path, n_count, n_wave_num )
{
	level endon( "dogfight_done" );
	
	if(!IsDefined( n_count ))
	{
		N_FLYBY_COUNT = 2;  // number of guys in a flyby 'pack'
	}
	else
	{
		N_FLYBY_COUNT = n_count;	
	}
	
	// pause flybys
	flag_clear( "force_flybys_available" );
	flag_set( "strafing_run_active" );
	
	if ( !IsDefined( level.a_convoy_planes ) )
	{
		level.a_convoy_planes = [];
	}
	else
	{
		ArrayRemoveValue( level.a_convoy_planes, undefined );
	}
	
	vh_lead_plane = undefined;
	
	level thread convoy_strafing_exploders( n_wave_num );
	
	for ( i = 0; i < N_FLYBY_COUNT; i++ )
	{		
		vh_plane = plane_spawn( "pegasus_fast_la2_dogfights", ::dogfight_convoy_strafe, initial_path, vh_lead_plane, i - 1 );
		
		vh_plane.is_dogfight_plane = true; //-- this makes it prep its guns instead of it's missiles
		vh_plane.n_wave_num = n_wave_num;
		vh_plane.targetname = "convoy_strafing_plane";
		vh_plane SetSpeedImmediate( 400, 10 );
		vh_plane thread _set_strafing_run_objective_on_plane( i );
		vh_plane thread _dogfight_fire_on_command( "convoy" );
		vh_plane thread _dogfight_drone_attack_missile_fire();
		vh_plane init_chaff();
		vh_plane thread dogfight_countermeasures_think();
		vh_plane thread _dogfight_speed_monitor( "convoy", i-1, 7000, 600, 0.9 );
		vh_plane thread _plane_drive_highway_internal();
		vh_plane thread dogfight_drone_evade();
		vh_plane thread f35_target_death_watcher();
		vh_plane.is_convoy_plane = true;		
		
		if ( n_wave_num == 2 || n_wave_num == 3 )
		{
			vh_plane thread dogfight_drones_weapons_think();
		}
		
		if( !IsDefined(vh_lead_plane) )
		{
			vh_lead_plane = vh_plane;
		}
		
		if ( n_wave_num == 3 )
		{
			// AWESOME!
			if ( i == 0 || i == 2 || i == 4 || i == 6  )
			{
				vh_plane.wave_3_split = true;	
			}
		}		
		
		level.a_convoy_planes[ level.a_convoy_planes.size ] = vh_plane;
		
		wait 0.25;
	}
	
	level notify( "drone_spawn_done" );
	
	level thread wave_speed_monitor( level.a_convoy_planes );
	level thread convoy_strafing_fail_watcher( 7 );
	
	array_wait( level.a_convoy_planes, "death" );
		
	//iprintlnbold( "strafing run done" );
	flag_clear( "strafing_run_active" );
}

convoy_strafing_exploders( n_wave )
{
	level endon( "drone_wave_complete" );
	
	if ( n_wave == 1 )
	{
		n_exploder = 510;	
	}
	else if ( n_wave == 2 )
	{
		n_exploder = 520;	
	}
	else if ( n_wave == 3 )
	{
		n_exploder = 530;	
	}
	
	
	while ( true )
	{
		level waittill( "missile_fired_at_convoy" );
		exploder( n_exploder );
		wait 10;
	}
}

convoy_strafing_fail_watcher( n_waves_until_fail )
{
	level endon( "drone_wave_complete" );

	e_harper = level.convoy.vh_van;
	n_times_attacked = 0;

	str_dialog_array = [];
	
	if ( !flag( "harper_dead" ) )
	{
		str_dialog_array = array( "septic__those_dro_008", "take_the_heat_off_009",	"the_drones_are_tar_051", "where_are_you_sep_010", "dammit_were_taki_014", "keep_them_off_us_015", "where_the_hell_are_016" );
	}
	else
	{
		str_dialog_array = array( "we_just_took_a_dir_052", "samu_we_re_taking_damage_0", "samu_dammit_we_re_under_0", "samu_keep_them_off_us_0", "samu_where_are_you_secti_0", "samu_we_need_you_with_the_0" );
	}
	str_dialog_array = array_randomize( str_dialog_array );
	
	while( true )
	{
		level waittill( "missile_fired_at_convoy" );	
		n_times_attacked++;
		
		b_play_vo = true;
		
		if ( (n_times_attacked >= 2) )
		{
			level thread convoy_strafing_kill_cougar();	
		}
		
		switch ( n_times_attacked )
		{
			case 1:
				b_pip_played = convoy_strafe_pip( level.b_pip_5_played, "la_pip_seq_5", "samu_the_drones_are_targe_0" ); // The drones are targeting the convoy!  You’ve gotta keep them off us, Section!
				if ( b_pip_played )
				{
					b_play_vo = false;
					level.b_pip_5_played = true;
				}
				break;
				
			case 3:
				b_pip_played = convoy_strafe_pip( level.b_pip_6_played, "la_pip_seq_6", "samu_dammit_section_w_0" ); // Dammit, Section!!! We just took a direct hit!
				if ( b_pip_played )
				{
					b_play_vo = false;
					level.b_pip_6_played = true;
				}
				break;
				
			case 6:
				b_pip_played = convoy_strafe_pip( level.b_pip_7_played, "la_pip_seq_7", "samu_dammit_section_on_0" ); // Dammit, Section!  One more of those and we’re dead meat!
				if ( b_pip_played )
				{
					b_play_vo = false;
					level.b_pip_7_played = true;
				}
				break;
				
			default:
				b_play_vo = true;
				break;
		}
		
		if ( n_times_attacked >= n_waves_until_fail )
		{
			wait 4;	// arbitary, wait for the convoy to be hit before failing
			SetDvar( "ui_deadquote", &"LA_2_OBJ_PROTECT_FAIL" );
			MissionFailed();		
		}
//		else if ( n_times_attacked == n_waves_until_fail- 1 )
//		{
//			delay_thread( 4, ::pip_dogfights_1 );	
//		}
		else if ( b_play_vo )
		{
			wait 3;
			e_harper say_dialog( str_dialog_array[n_times_attacked] );
		}
		
		wait 5;
	}
}

convoy_strafing_kill_cougar()
{
	vh_leader = convoy_get_leader();
	
	e_attacker = GetEntArray( "convoy_strafing_plane", "targetname" )[0];
	
	vh_leader.takedamage = true;
	vh_leader do_vehicle_damage( vh_leader.armor, e_attacker );
}

convoy_strafe_pip( b_has_pip_played, str_pip, str_vo )
{
	b_played_pip = false;
	if ( !b_has_pip_played )
	{
		wait 3;
		level thread pip_start( str_pip );	
		level.convoy.vh_potus say_dialog( str_vo, 1.5 );	
		b_played_pip = true;
	}
	
	return b_played_pip;
}


spawn_convoy_f35_allies( initial_path, n_count, n_wave_num, b_blah, b_follow_obj = true, b_remove_in_proximity = true )
{
	if ( !IsDefined( b_blah ) )
	{
		level waittill( "drone_spawn_done" );
	}
	else
	{
		if ( !IsDefined( level.drone_targets ) )
		{
			level.drone_targets = [];
			level.drone_targets[0] = level.player;
		}
	}
	
	f35_allies = [];
	
	if ( !IsDefined ( level.a_air_to_air_offsets ) )		// just in case we use a skipto
	{
		define_air_to_air_offsets();
	}
	
	nd_best_start = GetVehicleNode( initial_path, "targetname" );	
	
	for ( i = 0; i < n_count; i++ )
	{
		vh_plane = plane_spawn( "f35_fast_la2" );
		vh_plane SetModel( "veh_t6_air_fa38_x2" );
		vh_plane.targetname = "convoy_f35_ally_" + n_wave_num;
		vh_plane.script_noteworthy = "friendly_f35";
		
		vh_plane.n_wave_num = n_wave_num;
		
		vh_plane.default_path_fixed_offset = level.a_air_to_air_offsets[ "allies" ][i];				
		vh_plane PathFixedOffset( vh_plane.default_path_fixed_offset );
		
		vh_plane.default_path_variable_offset = ( 1000, 500, 1000 );		
		vh_plane PathVariableOffset( vh_plane.default_path_variable_offset, RandomFloatRange( 1, 2 ) );	
		vh_plane thread go_path( nd_best_start );	
		vh_plane thread _dogfight_ally_speed_monitor();  // ( "convoy", i-1, 3500, 1000 );
		vh_plane.is_convoy_plane = true;
		
		if ( b_follow_obj )
		{
			vh_plane thread _dogfight_follow_ally( b_remove_in_proximity );
		}
		
		if ( !IsDefined( b_blah ) )
			vh_plane thread dogfight_allies_weapons_think();
		
		vh_plane.transfer_route	= 1;
		vh_plane thread _plane_drive_highway_internal();
		
		f35_allies[i] = vh_plane;

		if ( IsDefined( b_blah ) || n_wave_num == 3 )
		{
			if ( IsDefined( level.drone_targets ) )
			{
				level.drone_targets[ level.drone_targets.size ] = vh_plane;
				vh_plane thread drone_target_death_watcher();
			}
		}
		
		if ( n_wave_num == 3 )
		{
			// AWESOME!6
			if ( i == 1 || i == 3 )
			{
				vh_plane.wave_3_split = true;	
			}
		}
		
		wait( 0.25 );
	}
	
	if ( !IsDefined( b_blah ) )
	{
		level waittill( "drone_wave_complete" );
		array_thread( f35_allies, ::f38_delete_offscreen );
		// array_delete( f35_allies );
	}
}

f38_delete_offscreen()
{
	self endon( "death" );
	while ( level.player is_player_looking_at( self.origin, .7, false ) )
	{
		wait 0.05;	
	}
	
	VEHICLE_DELETE( self );
}

_dogfight_follow_ally( b_remove_in_proximity = true )
{	
	maps\_objectives::set_objective( level.OBJ_FOLLOW, self, "follow" );	
	
	n_remove_follow_dist = 10000 * 10000;
	
	if ( b_remove_in_proximity )
	{	
		wait 7;		// arbitrary wait time to make it not turn off immediately if the player is nearby
		
		is_player_near = false;
		while ( IsAlive( self ) && IsDefined( self ) && !is_player_near )
		{
			n_dist = DistanceSquared( self.origin, level.f35.origin );
			
			if( n_dist < n_remove_follow_dist )
			{
				is_player_near = true;	
			}
			
			wait 0.05;
		}
		
		maps\_objectives::set_objective( level.OBJ_FOLLOW, self, "remove" );
	}
	else
	{
		level waittill( "eject_drone_spawned" );
		maps\_objectives::set_objective( level.OBJ_FOLLOW, self, "remove" );
	}
}

drone_target_death_watcher()
{
	self waittill( "death" );
	ArrayRemoveValue( level.drone_targets, self );
}

f35_target_death_watcher()
{
	self waittill( "death" );
	ArrayRemoveValue( level.a_convoy_planes, self );
}

_plane_drive_highway_internal( initial_path )
{
	self endon( "death" );
	
	if ( IsDefined( initial_path ) )
	{
		self thread go_path( initial_path );	
	}
	
	self thread _plane_respect_path_width();
	
	while ( 1 )
	{
		self waittill( "switch_node" );
		
		switch_node_name = self.currentNode.script_string;
		if ( switch_node_name == "transfer" )
		{
			// Get this loops highway id
			loop_id = self.currentNode.script_int;
				
			// for now just cycle
			switch_node_name = level.highway_routes[ loop_id ][ self.transfer_route ];
			
			// increment the transfer route
			self.transfer_route++; //= RandomIntRange( 0, 2 );
			if ( self.transfer_route >= level.highway_routes[ loop_id ].size )
			{
				self.transfer_route = 0;
			}
		}
		else if ( switch_node_name == "attack_path" )
		{
			if ( self.n_wave_num == 3 )
				continue;
			
			switch_node_name = "wave_" + self.n_wave_num + "_attack_path";	
		}
		else if ( switch_node_name == "wave_3_split_path" )
		{
			if ( !IsDefined( self.wave_3_split ) )
				continue;
		}
		
		self.switchNode = GetVehicleNode( switch_node_name, "targetname" );
		self SetSwitchNode( self.nextNode, self.switchNode );
	}	
}

_plane_respect_path_width()
{
	self endon( "death" );
	
	while( 1 )
	{
		radius = ( self.vteam == "axis" ? level.plane_radii["axis"] : level.plane_radii["allies"] );
		//Circle( self.origin, radius, ( 1, 1, 1 ), false, 1 );		

		variable_offset = self GetPathVariableOffset();		
		fixed_offset = self GetPathFixedOffset();
		
		if ( IsDefined( self.nextNode ) )
		{
			if ( Abs( variable_offset[1] ) > self.nextNode.radius )
			{
				self PathVariableOffset( ( variable_offset[0], self.nextNode.radius, variable_offset[2] ), RandomFloatRange( 2, 5 ) );
			}
			else if ( Abs( variable_offset[1] ) < self.default_path_variable_offset[1] && self.default_path_variable_offset[1] < self.nextNode.radius )
			{
				self PathVariableOffset( ( variable_offset[0], self.default_path_variable_offset[1], variable_offset[2] ), RandomFloatRange( 2, 5 ) );
			}
			
			if ( IsDefined( self.nextNode.height ) )
			{
				target_z = self.nextNode.origin[2] + self.nextNode.height;
				path_z = self.pathpos[2];
				fixed_offset_z = fixed_offset[2];
				variable_offset_z = variable_offset[2];
				
				real_z = path_z + fixed_offset_z;
				
				if ( real_z < target_z )
				{
					Print3d( self.origin, "FIXED TOO LOW!", ( 1, 1, 0 ), 1, 10, 1 );
					
					new_offset_z = fixed_offset[2] + ( 1000 * 0.05 );
					self PathFixedOffset( ( fixed_offset[0], fixed_offset[1], new_offset_z ) );				
				}
				
				if ( real_z < target_z )
				{
					Print3d( self.origin, "VARIABLE TOO LOW!", ( 0, 1, 0 ), 1, 10, 1 );					
				}
			}
			else	
			{
				if ( IsDefined( self.default_path_fixed_offset ) )
				{
					if ( fixed_offset[2] != self.default_path_fixed_offset[2] )
					{
						delta_z = self.default_path_fixed_offset[2] - fixed_offset[2];
						self PathFixedOffset( ( fixed_offset[0], fixed_offset[1], fixed_offset[2] + delta_z * 0.05 ) );
					}				
				}
			}
		}
		

		if ( IsDefined( self.default_path_fixed_offset ) )	
		{
			if ( Abs( fixed_offset[1] ) > self.pathwidth )
			{
				desired_offset = ( self.default_path_fixed_offset[1] < 0 ? -self.pathwidth : self.pathwidth );
				
				delta =	( self.default_path_fixed_offset[1] - fixed_offset[1] ) / 0.05;
				delta = Clamp( delta, -1000, 1000 );
				
				new_offset_y = fixed_offset[1];			
				new_offset_y += delta * 0.05;
				new_offset_y = Clamp( new_offset_y, -self.pathwidth, self.pathwidth );				
						
				self PathFixedOffset( ( fixed_offset[0], new_offset_y, fixed_offset[2] ) );				
			}
			else
			{
				if ( Abs( fixed_offset[1] ) < Abs( self.default_path_fixed_offset[1] ) && Abs( self.default_path_fixed_offset[1] ) < self.pathwidth  )
				{
					new_offset_y = fixed_offset[1];
					
					delta =	( self.default_path_fixed_offset[1] - fixed_offset[1] ) / 0.05;
					delta = Clamp( delta, -1000, 1000 );
					
					new_offset_y += delta * 0.05;
					if ( self.default_path_fixed_offset[1] < 0 && new_offset_y < self.default_path_fixed_offset[1] )
					{
						new_offset_y = self.default_path_fixed_offset[1];
					}
					else if ( self.default_path_fixed_offset[1] > 0 && new_offset_y > self.default_path_fixed_offset[1] )
					{
						new_offset_y = self.default_path_fixed_offset[1];	
					}
					         
					new_offset_y = Clamp( new_offset_y, -self.pathwidth, self.pathwidth );					
					
					self PathFixedOffset( ( fixed_offset[0], new_offset_y, fixed_offset[2] ) );					
				}
			}
		}
	
		//iprintln( self.pathwidth );
		
		wait( 0.05 );
	}
}


// self = plane
plane_drive_highway( initial_path, vh_lead_plane, n_follower )
{	
	if ( IsDefined( vh_lead_plane ) )
	{
		self thread plane_drive_highway_follow( vh_lead_plane.chosen_path, n_follower );
		return;
	}
	
	if ( IsDefined( initial_path ) )
	{
		nd_best_start = GetVehicleNode( initial_path, "targetname" );
	}

	self.default_path_variable_offset = ( 2000, 2000, 2000 );
	self PathVariableOffset( self.default_path_variable_offset, RandomFloatRange( 3, 5 ) );
	self.chosen_path = nd_best_start;
	self thread _plane_drive_highway_internal( nd_best_start );
}

plane_drive_highway_follow( nd_start_path , num_offset )
{
	self endon("death");
	
	if ( num_offset < level.a_air_to_air_offsets[ "convoy" ].size )
	{
		self.default_path_fixed_offset = level.a_air_to_air_offsets[ "convoy" ][num_offset];
		self PathFixedOffset( self.default_path_fixed_offset );
	}
	
	self.default_path_variable_offset = ( 2000, 1000, 2000);
	self PathVariableOffset( self.default_path_variable_offset, RandomFloatRange( 2, 5 ) );
	
	self thread _plane_drive_highway_internal( nd_start_path );
}


dogfight_allies_weapons_think()
{
	self endon( "death" );
	
	while ( 1 )
	{
		wait( RandomFloatRange( 4, 6 ) );
		
		if (  level.a_convoy_planes.size > 0 )
		{
			target = Random(  level.a_convoy_planes );
			self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 1 );
			self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 2 );	

			self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 1 );
			self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 2 );

			if ( RandomInt( 100 ) < 20 )
			{
				self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 0 );	
				self FireWeapon( target );
			}
		}
	}
}

dogfight_drones_weapons_think()
{
	self endon( "death" );
	
	while ( 1 )
	{
		wait( RandomFloatRange( 4, 6 ) );
		
		if ( IsDefined( level.drone_targets ) && level.drone_targets.size > 0 )
		{
			target = Random( level.drone_targets );
			
			self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 0 );	
			self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 0 );
			

//			if ( RandomInt( 100 ) < 20 )
//			{
//				self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 1 );
//				self maps\_turret::set_turret_target( target, ( 0, 0, 0 ), 2 );	
//
//				self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 1 );
//				self thread maps\_turret::fire_turret_for_time( RandomFloatRange( 3, 5 ), 2 );
//				
//			}
		}
	}		
}

// self = enemy drone
dogfight_player_strafe( vh_lead_plane, n_follower )
{
	//-- shoot at the player
	level thread player_strafe_burst_firing();
	
	if(IsDefined(vh_lead_plane))
	{
		self thread dogfight_player_strafe_follow( vh_lead_plane, n_follower, (0, 36, 36)  );
		return true;
	}
	
	if( AbsAngleClamp180(level.f35.angles[2]) > 15 )
	{
		wait(1.0);
		return false;
	}
	
	//-- first start in front of the plane	
	v_forward = AnglesToForward( (0, level.f35.angles[1], level.f35.angles[2] ));
	
	//-- Now place 2 nodes around the plane, 1 above and 1 in front
	nd_start_path = GetVehicleNode("start_flyover_player_spline", "targetname");
	nd_start_path.origin = level.f35.origin /*- (v_forward * 0)*/ + (0,0,360);
	nd_next_path = GetVehicleNode( nd_start_path.target, "targetname" );
	nd_next_path.origin = level.f35.origin + (v_forward * 12000) + (0,0,120);

	//-- Now find forward nodes based on the position of the pathnode directly in front of the player
	front_ref_point = nd_next_path;
		
	
	//-- Find the best node
	a_dogfight_nodes = GetVehicleNodeArray( "dogfight", "script_noteworthy" );
	
	a_dogfight_valid_nodes = [];
	
	foreach( node in a_dogfight_nodes )
	{
		if( VectorDot( node.script_dir, v_forward ) > 0.60 )
		{
			ARRAY_ADD( a_dogfight_valid_nodes, node );
		}
		
	}
	
	//-- we need to fly to a node that the player can see
	a_dogfight_nodes_player_can_see = [];
	foreach( node in a_dogfight_valid_nodes )
	{
		if( level.player is_looking_at( node.origin, 0.7, true ) )
		{
			ARRAY_ADD( a_dogfight_nodes_player_can_see, node );
		}
	}
	
	//-- save over array
	a_dogfight_valid_nodes = a_dogfight_nodes_player_can_see;
	
	//-- cull out the closest nodes
	a_nodes_too_close = get_array_of_closest( front_ref_point.origin, a_dogfight_valid_nodes, undefined, undefined, 12000 );
	for( i=0; i < a_nodes_too_close.size; i++ )
	{
		ArrayRemoveValue( a_dogfight_valid_nodes, a_nodes_too_close[i] );
	}
	
	// if we didn't find a good node, then check behind the player
	if( a_dogfight_valid_nodes.size == 0 )
	{
		//--TODO: TAKE OUT THIS LINE FOR SURE
		wait 1.0;
		if(true) return false;
		///////////////////////////////////
		
		trig_dogfight = GetEnt( "trig_dogfight_spawn_control", "targetname");
		//-- return false if the player is in the city.  No spawning front ones from here
		if( level.player IsTouching( trig_dogfight ) )
		{
			wait 1.0;
			return false;	
		}
		
		//-- if the player is looking at the center of the city, then don't spawn from here
		if( level.player is_looking_at( FLAT_ORIGIN(trig_dogfight.origin) + (0,0,level.player.origin[2]), 0.5, false ) )
		{
			wait 1.0;
			return false;	
		}
		
		
		v_forward = -v_forward;
		
		foreach( node in a_dogfight_nodes )
		{
			if( VectorDot( node.script_dir, v_forward ) > 0.7 )
			{
				ARRAY_ADD( a_dogfight_valid_nodes, node );
			}
		}
		
		backwards = true;
		
		//-- cull out the closest nodes
		a_nodes_too_close = get_array_of_closest( level.f35.origin, a_dogfight_valid_nodes, undefined, undefined, 12000 );
		for( i=0; i < a_nodes_too_close.size; i++ )
		{
			ArrayRemoveValue( a_dogfight_valid_nodes, a_nodes_too_close[i] );
		}
	}
	else
	{
		backwards = false;
	}
	
	Assert( a_dogfight_valid_nodes.size > 0, "No good nodes in front of or behind the player, start adding side checks" );
	
		
	if( IS_TRUE( backwards ) )
	{
		//-- The node needs to be placed way out in front so you don't see the drone spawn in
		nd_start_path.origin = level.f35.origin - (v_forward * 24000) + (0,0,360);
		
		//-- go towards the closest node since you are flying at the player anyways
		nd_join_path = get_array_of_closest( level.f35.origin, a_dogfight_valid_nodes )[0];
		
		//-- NOW SETUP THE LAST 3 NODES SO THAT THEY HEAD TOWARD THE RIGHT PLACE
		
		nd_prev = nd_start_path;
		
		for(i = 0; i < 3; i++)
		{
			nd_next = GetVehicleNode( nd_prev.target, "targetname" );
			
			v_dir_to_path = nd_join_path.origin - nd_prev.origin;
			
			n_length_fwd = VectorDot( v_forward, v_dir_to_path );
			
			v_move_node = ( (v_forward * n_length_fwd * 0.5) + ( v_dir_to_path * 0.5 ) ) / 2 ;
			
			nd_next.origin = nd_prev.origin + v_move_node;
			
			nd_prev = nd_next;
		}
	}
	else
	{		
	
		//-- go towards the closest node since you are flying at the player anyways
		nd_join_path = get_array_of_closest( level.f35.origin, a_dogfight_valid_nodes )[0];
		
		nd_prev = nd_next_path;
		
		for(i = 0; i < 2; i++)
		{
			nd_next = GetVehicleNode( nd_prev.target, "targetname" );
			
			v_dir_to_path = nd_join_path.origin - nd_prev.origin;
			
			n_length_fwd = VectorDot( v_forward, v_dir_to_path );
			
			v_move_node = ( (v_forward * n_length_fwd * 0.5) + ( v_dir_to_path * 0.5 ) ) / 2 ;
			
			nd_next.origin = nd_prev.origin + v_move_node;
			
			nd_prev = nd_next;
		}
	}
	
	ReconnectVehicleNodes();
	
	self.chosen_path = nd_start_path;
	self.switch_nodes = [];
	self.switch_nodes[0] = nd_next;
	self.switch_nodes[1] = nd_join_path;
	self PathVariableOffset( (500, 500, 500), 1 );
	self thread go_path( nd_start_path );
	self SetSwitchNode( nd_next, nd_join_path);
	
	//-- since we are spawning these on top of the player
	self PlaySound ("evt_flyby_avenger_apex_spawn");
	
	return true;
}

// self = enemy drone
dogfight_convoy_strafe( initial_path, vh_lead_plane, n_follower )
{	
	
	if(IsDefined(vh_lead_plane))
	{
		self thread dogfight_convoy_strafe_follow( vh_lead_plane.chosen_path, n_follower );
		return;
	}
	
	if(IsDefined(initial_path))
	{
		nd_best_start = GetVehicleNode( initial_path, "targetname" );
	}
	else
	{
		a_last_strafed_nodes = [];
			
		a_convoy_strafe_nodes = GetVehicleNodeArray( "convoy_start_strafe_nodes", "script_noteworthy" );
		//a_convoy_strafe_nodes = get_array_of_closest( self.origin, a_convoy_strafe_nodes);
		a_convoy_strafe_nodes = array_randomize( a_convoy_strafe_nodes );
		
		while( !IsDefined(nd_best_start) )
		{
			for( i=0; i < a_convoy_strafe_nodes.size; i++ )
			{
				if( level.player is_looking_at( a_convoy_strafe_nodes[i].origin, 0.1, true ) )
				{
					continue;	
				}
				else
				{
					nd_best_start = a_convoy_strafe_nodes[i];
					break;
				}
			}
		}
	}

	self.default_path_variable_offset = ( 2000, 2000, 2000 );
	self PathVariableOffset( self.default_path_variable_offset, RandomFloatRange( 3, 5 ) );
	self.chosen_path = nd_best_start;
	self thread go_path( nd_best_start );
}

dogfight_convoy_strafe_follow( nd_start_path , num_offset )
{
	self endon("death");
	
	if(num_offset < level.a_air_to_air_offsets[ "convoy" ].size )
	{
		self.default_path_fixed_offset = level.a_air_to_air_offsets[ "convoy" ][num_offset];
		self PathFixedOffset( self.default_path_fixed_offset );
	}
	
	self.default_path_variable_offset = ( 2000, 1000, 2000 );
	self PathVariableOffset( self.default_path_variable_offset, RandomFloatRange( 2, 5 ) );
	
	self thread go_path( nd_start_path );
}

dogfight_player_strafe_follow( vh_leader , num_offset, vec_variation )
{
	self endon("death");
	
	self thread go_path( vh_leader.chosen_path );
	
	//-- since we are spawning these on top of the player
	self PlaySound ("evt_flyby_avenger_apex_spawn");
	
	if(num_offset < level.a_air_to_air_offsets[ "player" ].size )
	{
		self PathFixedOffset( level.a_air_to_air_offsets[ "player" ][num_offset] );
	}		
	
	self PathVariableOffset( (500, 500, 500), 1 );
	self SetSwitchNode( vh_leader.switch_nodes[0], vh_leader.switch_nodes[1]);
}

dogfight_drone_evade()
{
	self endon( "death" );
	
	while ( 1 )
	{
	
		self waittill( "damage" );
		
		//self.default_path_variable_offset = ( 500, 500, 500 );
		self PathVariableOffset( ( 1000, 1000, 1000 ), 1.0 );
		
		wait( 5 );
	}
}

// objectives are set manually with code functions instead of _objectives since it doesn't re-use objective positions. 
// if this situation arises anywhere other than LA_2 I will update the system to handle this. -TravisJ
_set_objective_on_plane()  // self = plane
{
	n_targets_total = DOGFIGHTS_TARGETS;
	
	// objective marker
	if ( !IsDefined( level.dogfights_objective_marker_active ) )
	{
		level.dogfights_objective_marker_active = true;
		Objective_Add( level.OBJ_DOGFIGHTS, "current" );
		Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", n_targets_total );
		dogfights_objective_setup();
		Objective_Set3D( level.OBJ_DOGFIGHTS, true, "default" );
	}
	
	//Objective_Position( level.OBJ_DOGFIGHTS, self );
	//Objective_Set3D( level.OBJ_DOGFIGHTS, true, "red" );
	n_index = dogfights_objective_get_available_position();
	//Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, self );
	
	self.objective_target = 1;
	Target_Set( self );
	
	self waittill_either( "death", "dogfight_done" );
	

	self dogfights_objective_release_position( n_index );
	Objective_AdditionalPosition( level.OBJ_DOGFIGHTS, n_index, ( 0, 0, 0 ) );  // clears additional position
	
	dogfights_objective_update_counter();
}

dogfights_objective_update_counter()
{
	n_targets_total = DOGFIGHTS_TARGETS;
	n_killed = level.aerial_vehicles.dogfights.killed_total;
	n_remaining = n_targets_total - n_killed;
	n_halfway = Int( n_targets_total * 0.5 );

	//-- greenlight hack: TODO: REMOVE IT
	if(true) return;
	
	if ( n_killed == n_halfway )
	{
		level thread _autosave_after_bink();
	}
	
	if ( n_remaining <= 0 )
	{
		if ( !flag( "dogfight_done" ) )
		{
			flag_set( "dogfight_done" );
			Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", 0 );
			Objective_State( level.OBJ_DOGFIGHTS, "done" );
		}
	}
	else 
	{
		Objective_String( level.OBJ_DOGFIGHTS, &"LA_2_OBJ_DOGFIGHTS", n_remaining );
	}
}

dogfights_objective_setup()
{
	// there are 8 max objective positions available within the objective system. we need to reuse these.
	level.aerial_vehicles.dogfights.objective_positions = [];
	n_max_objectives = 8;
	
	for ( i = 0; i < n_max_objectives; i++ )
	{
		// false = unoccupied, true = occupied
		level.aerial_vehicles.dogfights.objective_positions[ level.aerial_vehicles.dogfights.objective_positions.size ] = false;
	}
}

dogfights_objective_get_available_position()  // self = plane with objective marker on it
{
	Assert( !IsDefined( self.dogfights_objective_index ), "objective index is already defined on dogfight plane!" );
	
	n_free_position = -1;
	
	for ( i = 0; i < level.aerial_vehicles.dogfights.objective_positions.size; i++ )
	{
		if ( level.aerial_vehicles.dogfights.objective_positions[ i ] == false )
		{
			level.aerial_vehicles.dogfights.objective_positions[ i ] = true;
			self.dogfights_objective_index = i;
			n_free_position = i;
			break;
		}
	}
	
	return n_free_position;
}

dogfights_objective_release_position( n_index )  // self = plane that needs its objective marker removed
{
	level.aerial_vehicles.dogfights.objective_positions[ n_index ] = false;
}

_dogfight_spawner_determine_type()
{
	n_index = RandomInt( 2 );
	
	if ( n_index == 0 )
	{
		str_type = "avenger";
	}
	else 
	{
		str_type = "pegasus";
	}
	
	return str_type;
}

dogfight_enemy_counter()
{
	level.aerial_vehicles.dogfights.targets[  level.aerial_vehicles.dogfights.targets.size ] = self;
	
	self waittill( "death" );

	level.aerial_vehicles.dogfights.killed_total++;
	level.aerial_vehicles.player_killed_total++;
	level.aerial_vehicles.dogfights.targets = array_removeDead(  level.aerial_vehicles.dogfights.targets );
}


wave_speed_monitor( a_planes, n_ideal_dist = 8000, n_too_close = 6000 )
{
	level endon ( "drone_wave_complete" );	
	level endon ( "midair_collision_started" );

	n_dist_too_close = n_too_close * n_too_close;
	n_ideal_dist_sq = n_ideal_dist * n_ideal_dist;
	
	while ( true )
	{
		a_planes = array_removedead( a_planes );
		
		should_speed_up = false;
		is_player_close = false;
		
		foreach ( e_plane in a_planes )
		{
			if ( IsDefined( level.f35 ) )
			{
				n_distance_sq = Distance2DSquared( e_plane.origin, level.f35.origin );			
	
				if ( n_distance_sq < n_dist_too_close )
				{
					should_speed_up = true;
				}
				else if ( n_distance_sq < n_ideal_dist_sq )
				{				
					is_player_close = true;	
					
					v_plane_to_player = VectorNormalize( level.f35.origin - e_plane.origin );
					v_plane_forward = VectorNormalize( AnglesToForward( e_plane.angles ) );
					v_player_forward = VectorNormalize( AnglesToForward( level.f35.angles ) );
					
					if ( VectorDot( v_plane_to_player, v_plane_forward ) > 0.7 ) 	// is the player in front of this plane?
					{
						if ( VectorDot( v_plane_forward, v_player_forward ) > 0.7 )	// Is the player and this plane moving the same direction?
						{
							should_speed_up = true;	
						}
					}
				}
			}
			else
			{
				should_speed_up = true;	
			}
		}
		
		level.b_should_exceed_speed = should_speed_up;
		level.b_should_match_speed = is_player_close;
		
		wait 0.05;
	}
}


// when should plane match speed?
// when should plane fly full speed?
// what are min/max speeds?
_dogfight_speed_monitor( str_path, n_path_index, ideal_dist, tolerance, dampening )  // self = plane
{
	self endon( "death" );
	
	n_speed_min = level.f35.speed_drone_min;
	n_speed_max = level.f35.speed_drone_max;
	const n_distance_ideal = 8000;
	if ( !IsDefined( ideal_dist ) )
	{
		ideal_dist = n_distance_ideal;	
	}
	
	n_distance_ideal_sq = ideal_dist * ideal_dist;
	const n_tolerance = 600;
	if ( !IsDefined( tolerance ) )
	{
		tolerance = n_tolerance;	
	}
	n_tolerance_sq = tolerance * tolerance;	
	
	const n_multiplier_slowdown = 0.7;
	if ( !IsDefined( dampening ) )
	{
		dampening = n_multiplier_slowdown;	
	}

	is_slow = false;
	
	while ( !flag( "dogfight_done" ) )
	{
		if ( self.n_wave_num == level.n_current_strafing_wave )
		{
			n_speed_new = level.f35 GetSpeedMPH();
			n_speed_max = level.f35 GetMaxSpeed() / 17.6;	// convert units/sec to MPH
			
			if ( level.b_should_exceed_speed )
			{
				self SetSpeed( n_speed_max * 1.2 );
			}
			else if ( !level.b_should_match_speed )
			{
				is_slow = true;
				n_speed_new = Int( n_speed_max * dampening );
				n_speed_new = clamp( n_speed_new, n_speed_min, n_speed_max );
				self SetSpeed( n_speed_new );
				//IPrintLn( self.model + " Slowing down" );
			}
			else if ( level.b_should_match_speed )
			{
				is_slow = false;
				n_speed_new = clamp( n_speed_new, n_speed_min, n_speed_max );
				self SetSpeed( n_speed_new );
				//IPrintLn( self.model + " Speeding Up" );
			}
		}
		
		wait 0.05;
	}
}

_dogfight_ally_speed_monitor()
{
	self endon ( "death" );
	
	n_distance_ideal = 5000 * 5000;
	n_dist_too_close = 3000 * 3000;
	
	while ( !flag( "dogfight_done" ) )
	{
		if ( level.a_convoy_planes.size > 0 )
		{
			e_target = level.a_convoy_planes[0];			
			n_dist = Distance2DSquared( self.origin, e_target.origin );
			
			foreach( e_temp_target in level.a_convoy_planes )
			{
				n_temp_dist = Distance2DSquared( self.origin, e_temp_target.origin );
				if ( n_temp_dist < n_dist )
				{
					e_target = e_temp_target;
					n_dist = n_temp_dist;
				}
			}
			
			v_player_to_enemy = VectorNormalize( e_target.origin - level.f35.origin );
			v_self_to_enemy = VectorNormalize( e_target.origin - self.origin );
			v_self_forward = VectorNormalize( AnglestoForward( self.angles ) );
			
			n_speed = e_target GetSpeedMPH();
			
			n_dot = VectorDot( v_self_forward, v_self_to_enemy );
			
			if ( n_dist < n_dist_too_close )	// if we're too close, slow down
			{
				n_speed *= 0.8;
			}
			else if ( n_dist > n_distance_ideal )	// have the ally speed up to catch up if he falls behind
			{
				n_speed *= 1.2;
			}
			
			self SetSpeed( n_speed, 250 );
		}
		
		wait 0.05;		
	}
}

//-- used to make vehicles fire from the spline
//-- TODO: clean this up because it was a quick hack for Green Light
_dogfight_fire_on_command( e_target )
{
	Assert( IsDefined( e_target ), "Spline strafer didnt have a target - _dogfight_fire_on_command" );
	
	self endon( "death" );
	level endon( "dogfight_done" );
	
	v_offset = ( 0, 0, 0 );
	const n_fire_time = 2;
	const n_wait_time = 0.25;
	const n_dot_player = 0.5;
	const n_dot_self = 0.1;
	const n_distance_for_missiles = 12000;
	n_distance_for_missiles_sq = n_distance_for_missiles * n_distance_for_missiles;
	const n_distance_for_missiles_max = 35000;
	n_distance_for_missiles_max_sq = n_distance_for_missiles_max * n_distance_for_missiles_max;
	const n_distance_for_guns = 10000;
	n_distance_for_guns_sq = n_distance_for_guns * n_distance_for_guns;
	const n_delay_between_fake_shots = 0.25;
	n_shots = Int( n_fire_time / n_delay_between_fake_shots );
	
	self _setup_plane_firing_by_type();
	
	while ( !flag( "dogfight_done" ) )
	{
		self waittill( "drone_update_target" );
		
		if( e_target == "convoy" )
		{
			e_my_target = get_array_of_closest( self.origin, level.convoy.vehicles )[0];
		}
		else if( e_target == "player" )
		{
			e_my_target = level.f35;	
		}
		
		//-- preset turret target
		for ( i = 0; i < self.weapon_indicies.size; i++ )
		{
			n_index = self.weapon_indicies[ i ];
			self maps\_turret::set_turret_target( e_my_target, v_offset, n_index );	
		}	
		
		self waittill( "drone_fire_turret" );
		
		level notify( "convoy_being_fired_on" );
		
		// actually fire the turrets
		for ( i = 0; i < self.weapon_indicies.size; i++ )
		{
			n_index = self.weapon_indicies[ i ];
			self maps\_turret::set_turret_target( e_my_target, v_offset, n_index );	
			self thread maps\_turret::fire_turret_for_time( n_fire_time, n_index );
		}	
	} 
}

_dogfight_drone_attack_missile_fire()
{
	self endon( "death" );
	
	while ( 1 )
	{
		self waittill( "drone_fire_missile" );
		level notify( "missile_fired_at_convoy" );
		
		structs = GetStructArray( "drone_attack_struct_" + self.n_wave_num, "targetname" );
		//self SetTargetOrigin( Random( structs ).origin );
		
		origin = Random( structs).origin;
		//aim_ent = Spawn( "script_origin", origin );
		
		//self SetGunnerTargetEnt( aim_ent, ( 0, 0, 0 ), 0 );
		//self SetGunnerTargetEnt( aim_ent, ( 0, 0, 0 ), 1 );		
		
		self SetGunnerTargetVec( origin, 0 );
		self SetGunnerTargetVec( origin, 1 );		

		wait( RandomFloatRange( 0.25, 1 ) );
		
		self FireGunnerWeapon( 0 );
		self FireGunnerWeapon( 1 );
		
		//wait( 4 );
		
		//aim_ent Delete();
	}
}

dogfight_countermeasures_think()
{
	self endon ( "death" );
	
	while ( true )
	{
		self waittill( "missileTurret_fired_at_me", e_missile );
		
		// try to use chaff, with a higher percentage the further the player is from the aircraft
		n_dist = Distance2D( self.origin, e_missile.origin );
		n_percent = n_dist * .003;
		if ( RandomInt( 100 ) < n_percent )
		{
			b_fired_chaff = try_to_use_chaff( e_missile );
		}
	}
}

dogfight_switch_node_test()
{
	self waittill( "drone_fire_turret" );	
	
	start_node = GetVehicleNode( "switch_test_1", "targetname" );
	end_node = GetVehicleNode( "switch_test_2", "targetname" );	
	
	self SetSwitchNode( start_node, end_node );
}

init_chaff()
{
	const n_chaff_max = 1;
	
	if ( !IsDefined( self.chaff_count ) )
	{
		self.chaff_count = n_chaff_max;
	}
}

// returns whether chaff was fired off
try_to_use_chaff( e_missile )
{
	b_used_chaff = false;
	
	if ( self can_use_chaff() )
	{
		b_used_chaff = true;
		self thread use_chaff( e_missile );
	}
	
	return b_used_chaff;
}

can_use_chaff()
{
	b_can_use_chaff = IsDefined( self.chaff_count ) && ( self.chaff_count > 0 );
	
	return b_can_use_chaff;
}

use_chaff( e_missile )
{	
	if ( IsDefined( e_missile ) && is_alive( self ) )
	{
//		iprintln( "enemy countermeasures detected..." );
		self.chaff_count--;
		n_chaff_scale = 200;
		n_chaff_time = 6;
		
		// play chaff FX
		PlayFXOnTag( level._effect[ "chaff" ], self, "tag_origin" );
		self playsound( "evt_drone_chaff_use" );
		
		// spawn chaff temp ent and move it
		v_forward = AnglesToForward( self.angles );
		v_right = AnglesToRight( self.angles );
		v_down = ( AnglesToUp( self.angles ) ) * ( -1 );
		v_chaff_pos = self.origin + ( v_down * n_chaff_scale );
		n_speed = self GetSpeedMPH();
		n_gravity = GetDvarInt( "phys_gravity" );
		v_gravity = GetDvarVector( "phys_gravity_dir" );
		v_chaff_direction = self.origin + ( v_forward * n_speed );
		
		v_chaff_dir = VectorNormalize( VectorScale( v_forward, -0.2 ) + v_right );
		
		v_velocity = VectorScale( v_chaff_dir, RandomIntRange(400, 600));
		v_velocity = ( v_velocity[0], v_velocity[1], v_velocity[2] - RandomIntRange(10, 100) );
		e_chaff = spawn( "script_model", v_chaff_pos );
		e_chaff SetModel( "tag_origin" );
		e_chaff MoveGravity( v_velocity, n_chaff_time );
		
		// redirect missile at chaff
		e_missile Missile_SetTarget( e_chaff );
		
		e_missile thread _detonate_missile_near_chaff( e_chaff );
		
		// wait until missile is dead
		wait n_chaff_time;
		
		// remove temp ent
		e_chaff Delete();
		
		if ( IsDefined( e_missile ) && is_alive( self ) )
		{
			e_missile notify( "stop_chasing_chaff" );
			e_missile Missile_SetTarget( self );
		}
	}
}

_detonate_missile_near_chaff( e_chaff )
{
	self endon( "death" );
	self endon( "stop_chasing_chaff" );
	
	const n_distance_explode = 256;
	n_distance_explode_sq = n_distance_explode * n_distance_explode;
	
	while ( IsDefined( e_chaff ) && IsDefined( self ) )
	{
		n_distance_sq = DistanceSquared( self.origin, e_chaff.origin );
		
		if ( n_distance_sq < n_distance_explode_sq )
		{
			self notify( "death" );
			wait 0.1;  // this is so death blossom can pull radius from missile 
			self ResetMissileDetonationTime( 0 );  // weirdly phrased, but this blows up the missile
		}
		
		wait 0.1;
	}
}

// replace with add_spawn_function_veh?
plane_spawn( str_targetname, func_behavior, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_targetname ), "str_targetname is a required parameter for plane_spawn!" );
	
	vh_plane = maps\_vehicle::spawn_vehicle_from_targetname( str_targetname );  // TODO: make this randomized
	vh_plane thread maps\la_2_drones_ambient::plane_counter();
	
	if ( IsDefined( func_behavior ) )
	{
		single_thread( vh_plane, func_behavior, param_1, param_2, param_3, param_4, param_5 );
	}
	
	return vh_plane;
}

uav_target_convoy_leader()
{
	while( !IsDefined( level.convoy.leader ) )
	{
		wait 0.05;
		//IPrintLnBold( "convoy leader undefined" );
	}
	
	vh_leader = level.convoy.leader;
	
	return vh_leader;
}

delay_weapon_firing( n_firing_wait, e_target, n_time, v_offset, n_index )
{
	self endon( "death" );
	
	wait n_firing_wait;
	
	if ( IsDefined( e_target ) )
	{
		self thread maps\_turret::shoot_turret_at_target( e_target, n_time, v_offset, n_index );
	}
}

// set burst firing parameters and anything else special about firing, then return array of turret indicies
_setup_plane_firing_by_type()  // self = vehicle
{
	a_indicies = [];
	
	if ( IS_PEGASUS( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 4;
		n_wait_max = 8;
		
		if ( IS_TRUE( self.is_dogfight_plane ) )  // missiles handled separately in dogfights
		{
			a_indicies[ a_indicies.size ] = 0;  // guns
		}
		else 
		{
			// fire dual missiles
			a_indicies[ a_indicies.size ] = 1;	// missiles
			//a_indicies[ a_indicies.size ] = 2;  // removing firing from secondary missile turret to lower FX count				
		}
	}
	else if ( IS_AVENGER( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		// fire bullet weapon
		a_indicies[ a_indicies.size ] = 0;	// guns
	}
	else if ( IS_F35_FAST( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}				
	}
	else if ( IS_F35_VTOL( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}			
	}
	else if ( IS_F35_FAST( self ) )
	{
		n_fire_min = 2;
		n_fire_max = 4.5;
		n_wait_min = 2;
		n_wait_max = 4;
	
		n_weapon_select = RandomInt( 2 );
		
		if ( n_weapon_select == 0 )  // missiles
		{
			a_indicies[ a_indicies.size ] = 0;		
		}
		else   // guns
		{
			a_indicies[ a_indicies.size ] = 1;		
			a_indicies[ a_indicies.size ] = 2;
		}			
	}
	else 
	{
		AssertMsg( self.vehicletype + " is not currently supported by _setup_plane_firing_by_type. implement this!" );
	}
	
	for ( i = 0; i < a_indicies.size; i++ )
	{
		n_index = a_indicies[ i ];
		self maps\_turret::set_turret_burst_parameters( n_fire_min, n_fire_max, n_wait_min, n_wait_max, n_index );
	}
	
	self.weapons_configured = true;
	self.weapon_indicies = a_indicies;
	
	return a_indicies;
}

_plane_move_to_point( s_position )  // self = plane
{
	Assert( IsDefined( s_position ), "s_position is a required parameter for _plane_move_to_point" );
	//Assert( IsDefined( s_position.angles ), "s_position at " + s_position.origin + "is missing angles for _plane_move_to_point" );
	
	self.origin = s_position.origin;
	
	if ( IsDefined( s_position.angles ) )
	{
		self.angles = s_position.angles;
	}
}


//todo: delete this and never speak of it again
GetBestMissileTurretTarget_f38_deathblossom()
{
	targetsAll = target_getArray();
	targetsValid = [];

	//targetsAll = get_array_of_closest( self.origin, targetsAll, undefined, 10, 12000 );
	
	
	
	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if( self InsideMissileTurretReticleNoLock( targetsAll[idx] ) && IS_TRUE(targetsAll[idx].db_target) )//Free for all
		{
			targetsValid[targetsValid.size] = targetsAll[idx];
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	chosenEnt = targetsValid[0];
	
	bestdot = -999;
	chosenindex = -1;
	if ( targetsValid.size > 1 )
	{
		forward = AnglesToForward( self GetPlayerAngles() );
		
		//TODO: find the closest
		for ( i = 0; i < targetsValid.size; i++ )
		{
			vec_to_target = VectorNormalize( targetsValid[i].origin - self get_eye() );
			dot = VectorDot( vec_to_target, forward );
			
			if ( dot > bestdot )
			{
				bestdot = dot;
				chosenindex = i;				
			}
		}
	}
	
	if ( chosenindex > -1 )
		chosenEnt = targetsValid[chosenindex];
	
	return chosenEnt;
}

//-- fake gun firing from behind the player
player_strafe_burst_firing()
{
	v_f35_forward = AnglesToForward( level.f35.angles );
	
	level notify( "player_being_fired_on" ); //-- play the VO
	
	if( cointoss() )
	{
		level.player playsound( "evt_strafe_burst_front_00" );
	}
	else
	{
		level.player playsound( "evt_strafe_burst_front_01" );
	}
	
	for( i = 0; i < 10; i++ )
	{
		//-- recalculate this each time because the player can move super fast and turn
		v_start = level.f35.origin + (0 , 0, 120 );
		v_end = v_start + (v_f35_forward * 1000);
		
		MagicBullet( "pegasus_side_minigun", v_start, v_end );
		wait 0.05;
	}
}

//-- this tracks the kills so that I can play the right VO
_dogfight_track_kills_for_vo()
{
	level endon("dogfight_done");
	
	while (true)
	{
		while( !IsDefined(level.player.missileturretTarget) )
		{
			wait 0.05;
		}

		level thread _notify_target_died( level.player.missileturretTarget );
		level thread _notify_target_lost( level.player.missileturretTarget );
		
		level waittill( "snd_target_gone", str_what_happened );
		
		switch( str_what_happened )
		{
			case "death_f38":
				level notify( "f38_shot_down_drone" );
				break;
				
			case "death_player":
				level notify( "player_shot_down_drone" );
				break;
				
			case "lost":
				level notify( "vo_lost_lock" );
				break;
		}
		
		wait(2);
	}
}


_notify_target_died( e_target )
{
	level endon( "snd_target_gone" );
	
	e_target waittill("death");
	
	if(IS_TRUE(e_target.locked_on))
	{
		level notify( "snd_target_gone", "death_f38" );
	}
	else
	{
		level notify( "snd_target_gone", "death_player" );
	}
}

_notify_target_lost( e_target )
{
	level endon( "snd_target_gone" );
	
	while( true )
	{
		while( IsDefined(level.player.missileturretTarget) && level.player.missileturretTarget == e_target )
		{
			wait 0.05;
		}
		
		wait(0.1);
		
		if( !IsDefined(level.player.missileturretTarget) || level.player.missileturretTarget != e_target )
		{
			level notify( "snd_target_gone", "lost" );
		}
	}
}

change_dogfights_fog_based_on_height()
{
	const n_poll_time = 1;  // how often function should check player height
	n_fog_transition_time = 1;  // time it takes to switch from low <-> high fog settings
	const n_fog_transition_height = 3800;  // this is 'lower tall buildings' height. anything below this = low fog setting
	
	// fog set to high at beginning since we're in predictable location
	maps\createart\la_2_art::art_jet_mode_settings();
	b_using_low_fog = false;
		
	while ( !flag( "dogfight_done" ) )
	{
		n_height_from_ground = level.player.origin[2];  // since geo is aligned to 0 on Z plane, can use straight value comparison
		b_in_low_range = ( n_height_from_ground < n_fog_transition_height );
		b_should_change_fog_setting = ( ( b_using_low_fog && !b_in_low_range ) || ( !b_using_low_fog && b_in_low_range ) );
		
		if ( b_should_change_fog_setting )
		{			
			if ( b_using_low_fog )
			{
				maps\createart\la_2_art::art_jet_mode_settings( n_fog_transition_time );
			}
			else 
			{
				maps\createart\la_2_art::art_vtol_mode_settings( n_fog_transition_time );
			}
			
			wait n_fog_transition_time;
			b_using_low_fog = !b_using_low_fog;
		}
		
		wait n_poll_time;
	}
}

dogfight_ambient_building_explosions()
{
	level endon( "dogfight_done" );
	
	n_max_dist = 12000 * 12000;
	n_min_dist = 6000 * 6000;
	a_explosion_structs = GetStructArray( "drone_amb_building_explosion", "targetname" );
	
	while ( true )
	{
		s_current_struct = undefined;
		n_current_dist = 100000 * 100000;
		foreach( s_explode_struct in a_explosion_structs )
		{
			n_dist = Distance2DSquared( level.f35.origin, s_explode_struct.origin );
			
			if ( n_dist < n_max_dist && n_dist > n_min_dist && n_dist < n_current_dist )
			{
				if ( level.player is_player_looking_at( s_explode_struct.origin, .7, false ) )
				
				n_current_dist = n_dist;
				s_current_struct = s_explode_struct;
			}
		}
		
		if ( IsDefined( s_current_struct ) )
		{
			PlayFX( level._effect[ "explosion_side_large" ], s_current_struct.origin, AnglesToForward( s_current_struct.angles ) );
		}
		
		wait 1;		
	}
}

