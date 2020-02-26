#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_drive()
{
	spawn_vehicles_from_targetname( "low_road_vehicles" );
}

skipto_skyline()
{
	s_skipto = get_struct( "skipto_skyline" );
	
	level.veh_player_cougar = get_player_cougar();
	level.veh_player_cougar.origin = s_skipto.origin;
	level.veh_player_cougar.angles = s_skipto.angles;
	
	flag_set( "drive_under_first_overpass" );
	flag_set( "drive_under_big_overpass" );
}

main()
{
	init_freeway_collapse();
	
	use_player_cougar();
	
	level thread fxanim_aerial_vehicles( 50 );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	level thread cougar_damage_states();
	level thread push_vehicles();
	delay_thread( 10, ::fail_watcher );
	
	if ( level.skipto_point != "skyline" )
	{
		level thread drive_vo();
	}
	
	flag_wait( "player_driving" );
	array_thread( GetAIArray( "axis" ), ::bloody_death );
}

drive_vo()
{
	anderson = level.player;
	anderson say_dialog( "septic__you_still_004", 1 );
	level.player say_dialog( "anderson_hows_ou_005", .5 );
	anderson say_dialog( "the_drones_are_bre_006", .5 );
	level.player say_dialog( "theyre_moving_ont_007", .5 );
//	anderson say_dialog( "well_i_think_you_008", .5 );
//	level.player say_dialog( "shit_009", .5 );
//	anderson say_dialog( "ill_be_there_as_s_010", .5 );
}

offramp_vo()
{
	anderson = level.player;
	harper = level.player;
	
	level.player say_dialog( "anderson_h_youre_001", 1 );
	anderson say_dialog( "its_bad_septic_002", .5 );
	harper say_dialog( "how_do_we_come_bac_002", .7 );
	level.player say_dialog( "i_dont_know_yet_003", .4 );
}

autoexec event_funcs()
{
	if ( !level.createFX_enabled )
	{
		add_trigger_function( "skyline_start", ::skyline_start );
		add_flag_function( "skyline_crash_take_control", ::skyline_crash_take_control );
		add_flag_function( "skyline_crash_start", ::skyline_crash_start );
		add_trigger_function( "trigger_offramp", ::offramp );
		add_trigger_function( "trigger_lastturn", ::lastturn );
		add_trigger_function( "hero_drone_trigger", ::delete_drive_vehicles );
		array_thread( GetEntArray( "fail_trigger", "targetname" ), ::fail_trigger );
		add_spawn_function_veh( "hero_drone", ::hero_drone );
		add_spawn_function_veh( "mini_hero_drone", ::mini_hero_drone );
		add_spawn_function_veh( "tanker_drone", ::tanker_drone );
		add_spawn_function_veh( "cougar_crash_big_rig", ::cougar_crash_big_rig );
	}
}
	
init_freeway_collapse()
{
	// Get freeway model
	a_fxanim_ents = GetEntArray( "fxanim", "script_noteworthy" );
	foreach ( ent in a_fxanim_ents )
	{
		if ( IS_EQUAL( ent.model, "fxanim_la_freeway_cars_mod" ) )
		{
			m_freeway = ent;
			break;
		}
	}
	
	link_models_by_targetname_sequence( "car", m_freeway );
	link_models_by_targetname_sequence( "light_pole", m_freeway );
}

link_models_by_targetname_sequence( str_id, m_linkto )
{
	i = 0;
	
	do
	{
		str_targetname = str_id + "_";
		
		i++;
		if ( i < 10 )
		{
			// add a leading zero on numbers less than 10
			str_targetname += "0";
		}
		
		str_targetname += i;
		
		model = GetEnt( str_targetname, "targetname" );
		if ( IsDefined( model ) )
		{
			model LinkTo( m_linkto, str_targetname + "_jnt" );
		}
	}
	while ( IsDefined( model ) );
}

collision_fail()
{
	level endon( "end_drive" );
	
	while ( true )
	{
		level.veh_player_cougar waittill( "veh_collision", v_hit_loc, v_normal, n_intensity, str_type, e_hit_ent );
	}
}

push_vehicles()
{
	level endon( "end_drive" );
	
	while ( true )
	{
		level.veh_player_cougar waittill( "veh_collision", v_hit_loc, v_normal, n_intensity, str_type, e_hit_ent );
		
		if ( IsDefined( e_hit_ent ) && level.veh_player_cougar GetSpeedMPH() > 20 )
		{
			e_hit_ent play_fx( "vehicle_launch_trail", e_hit_ent.origin, e_hit_ent.angles, 4, true );
			
			//v_world_force = v_normal * ( n_intensity / 50 );
			v_world_force = ( 0, 0, 20 );
		    
			/#
				//level thread draw_line_for_time( v_hit_loc, v_hit_loc + v_world_force, 1, 0, 0, 2 );
			#/
			
		    if ( e_hit_ent.classname == "script_vehicle" )
		    {
				e_hit_ent SetBrake( true );
		    	e_hit_ent LaunchVehicle( v_world_force, v_hit_loc, false, true );
		    }
		    else if ( e_hit_ent.classname == "script_model" )
		    {
		    	e_hit_ent PhysicsLaunch( e_hit_ent.origin, v_world_force );
			}
		    
		    e_hit_ent DoDamage( 10, e_hit_ent.origin );
			
		    if ( n_intensity > 30 )
		    {
		    	play_fx( "vehicle_impact_lg", v_hit_loc, VectorToAngles( v_normal ), 2 );
				e_hit_ent delay_thread( 2, ::push_vehicles_damage );
				
				if ( IS_VEHICLE( e_hit_ent ) )
				{
					e_hit_ent play_fx( "vehicle_impact_front", e_hit_ent.origin, e_hit_ent.angles, -1, true, "body_animate_jnt" );
					e_hit_ent play_fx( "vehicle_impact_rear", e_hit_ent.origin, e_hit_ent.angles, -1, true, "body_animate_jnt" );
				}
		    }
		    else
		    {
		    	play_fx( "vehicle_impact_sm", v_hit_loc, VectorToAngles( v_normal ), 2 );
		    }
		}
	}
}

push_vehicles_damage()
{
	self DoDamage( RandomIntRange( 20, 200 ), self.origin );
}

cougar_damage_states()
{
	flag_wait( "drive_under_first_overpass" );
	level.veh_player_cougar ShowPart( "tag_windshield_d1" );
	level.veh_player_cougar HidePart( "tag_windshield" );
	flag_wait( "drive_under_big_overpass" );
	level.veh_player_cougar ShowPart( "tag_windshield_d2" );
	level.veh_player_cougar HidePart( "tag_windshield_d1" );
}

mini_hero_drone()
{
	self endon( "death" );
	
	e_target = GetEnt( "first_overpass_target", "targetname" );
	
	self thread maps\_turret::shoot_turret_at_target_once( e_target, undefined, 1 );

	PlaySoundAtPosition( "evt_freeway_flyby_one", (0, 0, 0) );	
				
	wait .3;
	
	self thread maps\_turret::shoot_turret_at_target_once( e_target, undefined, 2 );
	
	//SOUND - Shawn J
	PlaySoundAtPosition( "evt_freeway_explo_two", (9134, -36570, -322) );

	
}

tanker_drone()
{
	self thread maps\_turret::fire_turret_for_time( -1, 0 );
	
	e_target = GetEnt( "tanker_drone_target", "targetname" );
	//self maps\_turret::set_turret_target( e_target, undefined, 1 );
	
	self maps\_turret::shoot_turret_at_target_once( e_target, ( -100, 0, 0 ), 1 );

	
}

fail_trigger()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger", e_who );
		if ( IsPlayer( e_who ) )
		{
			level.veh_player_cougar ShowPart( "tag_windshield_d2" );
			level.veh_player_cougar ShowPart( "tag_windshield_d1" );
	
			e_who Suicide();
		}
	}
}

hero_drone()
{
	self endon( "death" );
	
	level thread dominoes_vo();
	
	level thread f35_overpass( self );
	
	e_target = GetEnt( "overpass_target_1", "targetname" );
	e_target2 = GetEnt( "overpass_target_2", "targetname" );
	
	self maps\_turret::shoot_turret_at_target_once( e_target, undefined, 1 );
	
	e_target = GetEnt( "overpass_target_3", "targetname" );

	PlaySoundAtPosition( "evt_freeway_flyby_two", (0, 0, 0) );
	
	wait 1;
	
	self maps\_turret::shoot_turret_at_target_once( e_target2, undefined, 2 );
	
	PlaySoundAtPosition( "evt_freeway_explo_two", (0, 0, 0) );	
	
	wait .5;
	
	PlaySoundAtPosition( "evt_freeway_explo_three", (0, 0, 0) );	
	
	self maps\_turret::shoot_turret_at_target_once( e_target, undefined, 1 );
	
	level notify( "fxanim_freeway_collapse_start" );
	//SOUND - Shawn J
	PlaySoundAtPosition( "evt_freeway_collapse", (7840, -26393, 269) );

	
}

dominoes_vo()
{
	anderson = level.player;
	harper = level.player; // harper doesn't exist right now
	harper say_dialog( "weve_got_company_013" );
	anderson say_dialog( "this_ones_mine_015", .5 );
	level.player say_dialog( "dammit_014", .5 );
	level.player say_dialog( "nice_save_anderso_016", 2 );
}

f35_overpass( veh_drone )
{
	veh_drone script_delay();
	veh_f35 = get_f35_vtol();
	veh_f35 thread go_path( GetVehicleNode( "f35_overpass_path", "targetname" ) );
	veh_f35 maps\_turret::set_turret_target( veh_drone, undefined, 0 );
	veh_drone waittill( "fire_at_drone" );
	veh_f35 maps\_turret::shoot_turret_at_target_once( veh_drone, undefined, 0 );
}

#define OFFRAMP_SPEED 40
#define OFFRAMP_SPEED_DECEL_TIME 5

offramp()
{
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );
	
	level thread spawn_aerial_vehicles( 36, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	flag_set( "la_1_sky_transition" );
	
	//n_speed_max = level.veh_player_cougar GetMaxSpeed();
	
	level thread lerp_cougar_speed( 65, OFFRAMP_SPEED, OFFRAMP_SPEED_DECEL_TIME, true );
	
	level thread offramp_vo();
}

lerp_cougar_speed( n_current_speed, n_goal_speed, n_time, b_set_max_speed )
{
	level.veh_player_cougar endon( "death" );
	
	s_timer = new_timer();
	n_speed = n_current_speed;
	
	do
	{
		wait .05;
		n_current_time = s_timer get_time_in_seconds();
		n_speed = LerpFloat( n_current_speed, n_goal_speed, n_current_time / n_time );
		
		if ( IS_TRUE( b_set_max_speed ) )
		{
			level.veh_player_cougar SetVehMaxSpeed( n_speed );
		}
		else
		{
			level.veh_player_cougar SetSpeed( n_speed, 1000 );
		}
	}
	while ( n_speed > n_goal_speed );
}

lastturn()
{
	delete_offramp_vehicles();
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast", "pegasus_fast" );	
	level thread spawn_aerial_vehicles( 50, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
//	for( i = 0; i < 70; i++ )
//	{
//		if( level.veh_player_cougar GetSpeedMPH() > 60 )
//		{
//			level.veh_player_cougar SetBrake( 1 );
//		}
//		else
//		{
//			level.veh_player_cougar SetBrake( 0 );
//		}
//		wait 0.05;
//	}
//	
//	level.veh_player_cougar SetBrake( 0 );
}

delete_drive_vehicles()
{
	a_all_vehicles = GetVehicleArray();
	foreach ( veh in a_all_vehicles )
	{
		if ( IsDefined( veh.script_string ) && ( veh.script_string == "drive_vehicles" ) )
		{
			veh Delete();
		}
	}
}

delete_offramp_vehicles()
{
	a_all_vehicles = GetVehicleArray();
	foreach ( veh in a_all_vehicles )
	{
		if ( IsDefined( veh.script_string ) && ( veh.script_string == "offramp_vehicles" ) )
		{
			veh Delete();
		}
	}
}

#define CRASH_COUGAR_SPEED_MIN 20
#define CRASH_COUGAR_SPEED_MAX 40

#define CRASH_ANIM_DELAY_MIN .2
#define CRASH_ANIM_DELAY_MAX .6

#define CRASH_TRUCK_DELAY .8

skyline_start( ent )
{
	level thread run_scene_and_delete( "skyline" );
}

skyline_crash_take_control( ent )
{
	level notify( "end_drive" );
	
	level.player FreezeControls( true );
	
	s_goal = get_struct( "cougar_crash_goal" );
	level.veh_player_cougar SetVehGoalPos( s_goal.origin, false, true );
	
	level thread lerp_cougar_speed( OFFRAMP_SPEED, CRASH_COUGAR_SPEED_MAX, 4, false );
}

skyline_crash_start( ent )
{
	n_speed = level.veh_player_cougar GetSpeedMPH();	
	n_anim_delay = linear_map( n_speed, CRASH_COUGAR_SPEED_MAX, CRASH_COUGAR_SPEED_MIN, CRASH_ANIM_DELAY_MIN, CRASH_ANIM_DELAY_MAX );
		
	delay_thread( n_anim_delay + CRASH_TRUCK_DELAY, ::spawn_vehicle_from_targetname_and_drive, "cougar_crash_big_rig" );
	
	wait n_anim_delay;
	
	level.veh_player_cougar SetAnim( %vehicles::v_la_04_04_crash_cougar_tag_player, 1, 0, 1 );
	run_scene_and_delete( "cougar_crash" );
}

// This function runs off of a notetrack in the animation when the cougar gets hit
crash( ent )
{
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	
	level.player PlaySound("evt_semi_cougar_impact");	
	PlayFXOnTag( getfx( "cougar_crash" ), level.veh_player_cougar, "tag_origin" );
		
	fade_to_black( 0 );
	
	wait 1;
	
	nextmission();
	//fastrestart();
}

// This function runs on the bigrig when it gets spawned
cougar_crash_big_rig()
{
	//self PlaySound("evt_semi_rev");
}

fail_watcher()
{
	level endon( "end_drive" );
	
	veh_player = get_player_cougar();
	
	while ( true )
	{
		n_speed = veh_player GetSpeedMPH();
		
		if ( n_speed < 30 )
		{
			flag_set( "drive_failing" );
			fail_warning();
			
			n_speed = veh_player GetSpeedMPH();
			if ( n_speed < 40 )
			{
				level thread missile_fail();
			}
		}
		else
		{
			flag_clear( "drive_failing" );
			
			level.player EnableInvulnerability();
			level.player EnableHealthShield( true );
		}
		
		wait .05;
	}
}

missile_fail()
{
	level.player DisableInvulnerability();
	level.player EnableHealthShield( false );
	
	v_player_forward = level.player get_forward( true );
	
	v_spawn_org = level.player.origin + ( 0, 0, 2000 ) + v_player_forward * -500;
	veh_drone = SpawnVehicle( "veh_t6_drone_avenger", "death_drone", "drone_avenger", v_spawn_org, level.player.angles );
	veh_drone.health = 10000;
	veh_drone SetVehGoalPos( v_spawn_org + v_player_forward * 100000 );
	veh_drone SetSpeed( 400, 300, 300 );
	
	veh_drone maps\_turret::set_turret_target( level.player, undefined, 1 );
	veh_drone maps\_turret::set_turret_target( level.player, undefined, 2 );
	
	wait 2;

	if ( flag( "drive_failing" ) )
	{
		veh_drone thread turret_rapid_fire( 1 );
		veh_drone thread turret_rapid_fire( 2 );
	}
	
	veh_drone waittill( "drone" );
}

turret_rapid_fire( n_index )
{
	self endon( "death" );
	
	self endon( "turret_rapid_fire_stop" );
	self delay_notify( "turret_rapid_fire_stop", 4 );
	
	while ( true )
	{
		self thread maps\_turret::fire_turret( n_index );
		wait .5;
	}
}

fail_warning()
{
	for ( i = 0; i < 100; i++ )
	{
		v_player_forward = level.player get_forward( true );
		v_target_offset = random_vector( 300 );
		
		v_start = level.player.origin + ( 0, 0, 500 );
		v_end = level.player.origin + v_player_forward + v_target_offset;
				
		MagicBullet( "avenger_side_minigun", v_start, v_end );
		
		wait .05;
	}
}
