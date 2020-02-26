#include common_scripts\utility;
#include maps\_utility;
#include maps\la_utility;
#include maps\_vehicle;
#include maps\_scene;
#include maps\_dialog;
#include maps\_turret;
#include maps\_music;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\la.gsh;

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

autoexec init_drive()
{
	add_spawn_function_group( "g20_attackers", "targetname", ::dodge_player );
	
	add_trigger_function( "skyline_start", ::skyline_start );
	add_trigger_function( "trig_collapse", ::trigger_collapse );
	add_flag_function( "skyline_crash_take_control", ::skyline_crash_take_control );
	add_flag_function( "skyline_crash_start", ::skyline_crash_start );
	add_trigger_function( "trigger_offramp", ::offramp );
	add_trigger_function( "trigger_lastturn", ::lastturn );
	add_trigger_function( "hero_drone_trigger", ::delete_drive_vehicles );
	add_trigger_function( "hero_drone_trigger", ::hero_drone );
	array_thread( GetEntArray( "fail_trigger", "targetname" ), ::fail_trigger );
	add_spawn_function_veh( "mini_hero_drone", ::mini_hero_drone );
	add_spawn_function_veh( "tanker_drone", ::tanker_drone );
	add_spawn_function_veh( "cougar_crash_big_rig", ::cougar_crash_big_rig );
}

main()
{
	/# level thread debug_vehicle_count(); #/
		
	use_player_cougar();

	level thread peel_out_sound(); 
	
	clientnotify( "drive_time" );
	
	level thread init_freeway_collapse();
	level thread ambient_drones();
	
	//level thread fxanim_aerial_vehicles( 45 );
	
	exploder( 56 );
	exploder( 57 );
	exploder( 58 );
	exploder( 59 );
	
	level thread cougar_damage_states();
	level thread push_vehicles();
	level thread collision_sounds();	
	delay_thread( 10, ::fail_watcher );
	
	if ( level.skipto_point != "skyline" )
	{
		level thread drive_vo();
	}
	
	flag_wait( "player_driving" );
	
	clientnotify( "cougar_chatter" );
	
	array_thread( GetAIArray( "axis" ), ::bloody_death );
}

peel_out_sound()  //play peelout sound only first time player hits the gas
{
	while (1)
	{
		if (level.player buttonpressed( "BUTTON_RTRIG"))
		{
			level.player playsound("veh_cougar_peel_f", "sounddone");
			level waittill ("sounddone");
			return;
		}
		
		else
		{
			wait .05;
		}
		wait (.05);
	}
}

dodge_player()
{
	const DIST = 3000 * 3000;
	
	self endon( "death" );
	
	flag_wait( "player_driving" );
	
	while ( Distance2DSquared( level.player.origin, self.origin ) > DIST )
	{
		wait .05;
	}
	
	if ( cointoss() )
	{
		self anim_generic( self, "dodge1" );
	}
	else
	{
		self anim_generic( self, "dodge2" );
	}
}

drive_vo()
{
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "harp_punch_it_section_0" );		// harper
		//level.player queue_dialog( "get_outta_the_fuck_013", 1 );	// harper
		level.player queue_dialog( "faster__ram_them_012", 3 );		// harper
	}
	else
	{
		level.player queue_dialog( "sect_on_my_lead_110_nor_0" );	//On my lead!  110 Northbound.  GO! GO! GO!
	}
	
	level.player queue_dialog( "sect_they_re_trying_to_bl_0", 0, undefined, "first_drone_strike" );
	level.player queue_dialog( "sect_push_through_em_0", 0, undefined, "first_drone_strike" );
	level.player queue_dialog( "sect_ram_anything_in_your_0", 0, undefined, "first_drone_strike" );
	//level.player queue_dialog( "sect_get_the_fuck_out_0", 0, undefined, "first_drone_strike" );
	
	level.player queue_dialog( "ande_section_you_ve_got_0", 0, "drive_under_first_overpass" ); // anderson
	//level.player queue_dialog( "left_left_015", 0, "first_drone_strike", "freeway_drone_started" );
	
	//flag_wait( "freeway_drone_started" );
	//level.player queue_dialog( "sect_engage_0" );
	
	level.player queue_dialog( "ande_i_have_lock_firin_0", 0, "freeway_drone_started" ); // anderson
	
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "the_whole_freeway_005", 1 );	// harper
	}
	else
	{
		level.player queue_dialog( "ande_right_section_the_0", 1 );	//Right, Section!  The overpass is coming down!
	}
	
	level.player queue_dialog( "holy_shit_006" );
}

fa38_missle_fire( veh_fa38 )
{
	wait .1;
	struct = get_struct( "freeway_fa38_missile_struct" );
	veh_drone = GetEnt( "hero_drone", "targetname" );
	//-- HACK:
	e_missile = MagicBullet( MAGIC_MISSILE_FA38, struct.origin, veh_drone.origin, veh_fa38, veh_drone );
	e_missile endon("death");
	wait(1);
	e_missile ResetMissileDetonationTime( 0 );
}

offramp_vo()
{
	//Set music for dialog
	setmusicstate ("LA_1_HOPELESS");
	clientnotify ( "cougar_vol" );//adding snapshot to turn down cougar vol
	
	level.player queue_dialog( "sect_anderson_beat_how_0" ); // player
	level.player queue_dialog( "ande_it_s_bad_section_0" ); // anderson
	level.player queue_dialog( "ande_i_don_t_know_how_you_0" ); // anderson
	
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "harp_how_do_we_come_back_0" ); // harper
	}
	
	level.player queue_dialog( "i_dont_know_yet_003" ); // player
	
	flag_wait( "final_dialog_start" );
	
	if ( !flag( "harper_dead" ) )
	{
		level.player queue_dialog( "menendez_knew_exac_003" ); // harper
		flag_wait( "skyline_crash_take_control" );
		level.player queue_dialog( "i_think_weve_hear_004" ); // player
	}
	else
	{
		level.player queue_dialog( "ande_section_i_m_seeing_0" ); // anderson
		flag_wait( "skyline_crash_take_control" );
		level.player queue_dialog( "ande_on_your_right_0" ); // anderson
	}
}
	
init_freeway_collapse()
{	
	flag_wait( "la_1_gump_1d" );
	
	// Get freeway model	
	a_fxanim_ents = GetEntArray( "fxanim", "script_noteworthy" );
	foreach ( ent in a_fxanim_ents )
	{
		if ( IS_EQUAL( ent.model, "fxanim_la_freeway_cars_01_mod" ) )
		{
			m_freeway1 = ent;
			continue;
		}
		
		if ( IS_EQUAL( ent.model, "fxanim_la_freeway_cars_02_mod" ) )
		{
			m_freeway2 = ent;
			continue;
		}
	}
	
	GetEnt( "car_01", "targetname" ) LinkTo( m_freeway1, "car_01_jnt" );
	GetEnt( "car_02", "targetname" ) LinkTo( m_freeway1, "car_02_jnt" );
	GetEnt( "car_03", "targetname" ) LinkTo( m_freeway1, "car_03_jnt" );
	GetEnt( "car_04", "targetname" ) LinkTo( m_freeway1, "car_04_jnt" );
	GetEnt( "car_05", "targetname" ) LinkTo( m_freeway1, "car_05_jnt" );
	GetEnt( "car_06", "targetname" ) LinkTo( m_freeway1, "car_06_jnt" );
	GetEnt( "car_07", "targetname" ) LinkTo( m_freeway1, "car_07_jnt" );
	GetEnt( "car_08", "targetname" ) LinkTo( m_freeway1, "car_08_jnt" );
	GetEnt( "car_09", "targetname" ) LinkTo( m_freeway1, "car_09_jnt" );
	GetEnt( "car_10", "targetname" ) LinkTo( m_freeway1, "car_10_jnt" );
	GetEnt( "car_11", "targetname" ) LinkTo( m_freeway1, "car_11_jnt" );
	GetEnt( "car_12", "targetname" ) LinkTo( m_freeway1, "car_12_jnt" );
	GetEnt( "car_13", "targetname" ) LinkTo( m_freeway1, "car_13_jnt" );
	GetEnt( "car_14", "targetname" ) LinkTo( m_freeway1, "car_14_jnt" );
	GetEnt( "car_15", "targetname" ) LinkTo( m_freeway1, "car_15_jnt" );
	GetEnt( "car_16", "targetname" ) LinkTo( m_freeway1, "car_16_jnt" );
	GetEnt( "car_17", "targetname" ) LinkTo( m_freeway1, "car_17_jnt" );
	GetEnt( "car_18", "targetname" ) LinkTo( m_freeway1, "car_18_jnt" );
	GetEnt( "car_19", "targetname" ) LinkTo( m_freeway1, "car_19_jnt" );
	GetEnt( "car_20", "targetname" ) LinkTo( m_freeway1, "car_20_jnt" );
	
	GetEnt( "car_21", "targetname" ) LinkTo( m_freeway2, "car_01_jnt" );
	GetEnt( "car_22", "targetname" ) LinkTo( m_freeway2, "car_02_jnt" );
	GetEnt( "car_23", "targetname" ) LinkTo( m_freeway2, "car_03_jnt" );
	GetEnt( "car_24", "targetname" ) LinkTo( m_freeway2, "car_04_jnt" );
	GetEnt( "car_25", "targetname" ) LinkTo( m_freeway2, "car_05_jnt" );
	GetEnt( "car_26", "targetname" ) LinkTo( m_freeway2, "car_06_jnt" );
	GetEnt( "car_27", "targetname" ) LinkTo( m_freeway2, "car_07_jnt" );
	GetEnt( "car_28", "targetname" ) LinkTo( m_freeway2, "car_08_jnt" );
	GetEnt( "car_29", "targetname" ) LinkTo( m_freeway2, "car_09_jnt" );
	GetEnt( "car_30", "targetname" ) LinkTo( m_freeway2, "car_10_jnt" );
	GetEnt( "car_31", "targetname" ) LinkTo( m_freeway2, "car_11_jnt" );
	GetEnt( "car_32", "targetname" ) LinkTo( m_freeway2, "car_12_jnt" );
	GetEnt( "car_33", "targetname" ) LinkTo( m_freeway2, "car_13_jnt" );
	GetEnt( "car_34", "targetname" ) LinkTo( m_freeway2, "car_14_jnt" );
	GetEnt( "car_35", "targetname" ) LinkTo( m_freeway2, "car_15_jnt" );
	GetEnt( "car_36", "targetname" ) LinkTo( m_freeway2, "car_16_jnt" );
	GetEnt( "car_37", "targetname" ) LinkTo( m_freeway2, "car_17_jnt" );
	GetEnt( "car_38", "targetname" ) LinkTo( m_freeway2, "car_18_jnt" );
	
	GetEnt( "light_pole_01", "targetname" ) LinkTo( m_freeway2, "light_pole_01_jnt" );
	GetEnt( "light_pole_02", "targetname" ) LinkTo( m_freeway2, "light_pole_02_jnt" );
	GetEnt( "light_pole_03", "targetname" ) LinkTo( m_freeway2, "light_pole_03_jnt" );
	GetEnt( "light_pole_04", "targetname" ) LinkTo( m_freeway2, "light_pole_04_jnt" );
	GetEnt( "light_pole_05", "targetname" ) LinkTo( m_freeway2, "light_pole_05_jnt" );
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
			else if ( e_hit_ent.classname == "script_model" || IsAI( e_hit_ent ) )
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

collision_sounds()
{
	level endon( "end_drive" );

	level.disableGenericDialog = true;	
	
	while( 1 )
	{
		level.veh_player_cougar waittill( "veh_collision", v_hit_loc, v_normal, n_intensity, str_type, e_hit_ent );
		
		if ( IsDefined( e_hit_ent ) )
		{
			if( n_intensity > 20 )
			{
				//SOUND - Shawn J - impacts
				level.veh_player_cougar PlaySound( "evt_auto_impact_heavy" );
				//iprintlnbold ("vehicle hit heavy");
			}
			else
			{
				//SOUND - Shawn J - impacts
				level.veh_player_cougar PlaySound( "evt_auto_impact_light" );
				//iprintlnbold ("vehicle hit light");				
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

	clientnotify( "fssn1" );
	level.player playsound( "evt_flyby1_flyby_front" );
				
	wait .3;
	
	self thread maps\_turret::shoot_turret_at_target_once( e_target, undefined, 2 );
	
	flag_set( "first_drone_strike" );
	
	level.player playsound( "evt_billboard_flyby_fnt" );
}

tanker_drone()
{
	self thread maps\_turret::fire_turret_for_time( -1, 0 );
	
	level.player playsound( "evt_flyby2_flyby_front" );
	                    
	e_target = GetEnt( "tanker_drone_target", "targetname" );
	//self maps\_turret::set_turret_target( e_target, undefined, 1 );
	
	self maps\_turret::shoot_turret_at_target_once( e_target, ( -100, 0, 0 ), 1 );	
	
	e_target playsound( "evt_tanker_flyby_explosion" );
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
	level thread freeway_set_turret_targets();
	delay_thread( 3, ::run_scene_and_delete, "freeway_f35" );
	run_scene_and_delete( "freeway_drone" );
	
	level trigger_wait( "f38_goto_trigger" );
	
	veh_f38 = GetEnt( "f35_vtol", "targetname" );
	
	for( i = 1; i < 3; i++ )
	{
		f38_goto_struct = get_struct( "f38_drive_" + i + "_goto", "targetname" );
		veh_f38 SetVehGoalPos( f38_goto_struct.origin, false );
		
		veh_f38 waittill( "goal" );
	}
}

freeway_set_turret_targets()
{
	e_target1 = GetEnt( "overpass_target_1", "targetname" );
	e_target2 = GetEnt( "overpass_target_2", "targetname" );

	flag_wait( "freeway_drone_started" );
	
	veh_drone = GetEnt( "hero_drone", "targetname" );
	veh_drone set_turret_target( e_target1, (0, 0, 0), 1 );
	veh_drone set_turret_target( e_target2, (0, 0, 0), 2 );
	
	flag_wait( "freeway_f35_started" );
	
	veh_f35 = GetEnt( "f35_vtol", "targetname" );
	veh_f35 NotSolid();
	veh_f35 set_turret_target( veh_drone, (0, 0, 0), 0 );
}

trigger_collapse()
{
	wait 1.0;
	clientnotify( "fssn2" );
	level notify( "fxanim_freeway_collapse_start" );
	level.player playsound( "evt_freeway_collapse_front" );
}

#define OFFRAMP_SPEED 40
#define OFFRAMP_SPEED_DECEL_TIME 5

offramp()
{
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast" );
	
	clientnotify( "bbvi0" );
	
	//level thread spawn_aerial_vehicles( 36, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
	flag_set( "la_1_sky_transition" );
	
	//n_speed_max = level.veh_player_cougar GetMaxSpeed();
	
	level thread lerp_cougar_speed( 65, OFFRAMP_SPEED, OFFRAMP_SPEED_DECEL_TIME, true );
	
	level thread offramp_vo();
	
	level thread offramp_lapd();
}

offramp_lapd()
{
	wait 0.05;
	
	a_veh_lapd_offramp = GetEntArray( "lapd_offramp_veh", "targetname");
	
	for( i = 0; i < a_veh_lapd_offramp.size; i++ )
	{
		a_veh_lapd_offramp[ i ] SetSpeed( 0 );
	}
	
	trigger_wait( "trigger_lastturn" );
	
	for( i = 0; i < a_veh_lapd_offramp.size; i++ )
	{
		sound_ent[i] = spawn( "script_origin", a_veh_lapd_offramp[i].origin );
		sound_ent[i] linkto( a_veh_lapd_offramp[i], "tag_origin" );
		sound_ent[i] thread differing_starts();
		a_veh_lapd_offramp[ i ] ResumeSpeed( 10 );
	}
}

differing_starts()
{
	wait(randomfloatrange(.1, 2) );
	self playloopsound( "amb_drive_final_siren", 1 );
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
	
	clientnotify( "bbvi1" );
	
	a_av_allies_spawner_targetnames = array( "f35_fast" );	
	a_av_axis_spawner_targetnames = array( "avenger_fast" );	
	//level thread spawn_aerial_vehicles( 50, a_av_allies_spawner_targetnames, a_av_axis_spawner_targetnames );
	
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
	a_vehicles = get_vehicle_array( "drive_vehicles", "script_string" );
	array_thread( a_vehicles, ::delete_when_not_looking_at );
}

delete_offramp_vehicles()
{
	a_vehicles = get_vehicle_array( "offramp_vehicles", "script_string" );
	array_thread( a_vehicles, ::delete_when_not_looking_at );
}

#define CRASH_COUGAR_SPEED_MIN 20
#define CRASH_COUGAR_SPEED_MAX 40

#define CRASH_ANIM_DELAY_MIN .1
#define CRASH_ANIM_DELAY_MAX .6

#define CRASH_TRUCK_DELAY .8

skyline_start()
{
	level thread run_scene_and_delete( "skyline" );
	level.player playsound( "evt_dronebattle_front" );
	
	clientnotify( "bbvi2" );
}

skyline_crash_take_control( ent )
{
	level notify( "end_drive" );
	
	level.player FreezeControls( true );
	
	//TUEY - Set music to Cresendo
	
	level thread maps\_audio::switch_music_wait("LA_1_SEMI", 1.5);
	
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
	clientnotify( "sccs" );
	if ( !flag( "harper_dead" ) )
	{
		run_scene_and_delete( "cougar_crash" );
	}
	else 
	{
		n_length = GetAnimLength( %generic_human::ch_la_04_04_crash_harper );
		wait 2.3;
		crash();
	}
}

// This function runs off of a notetrack in the animation when the cougar gets hit
crash( ent )
{
	level.player PlayRumbleOnEntity( "artillery_rumble" );
	
	//level.player PlaySound("evt_semi_cougar_impact");	
	PlayFXOnTag( getfx( "cougar_crash" ), level.veh_player_cougar, "tag_origin" );
	
	screen_fade_out( 0 );	// no waits before this :)
	
	level.crash_bigrig Delete();	// bbarnes - assuming we want to kill the sounds from the cougar and bigrig
	if ( IsDefined( ent ) )
	{
		ent Delete();
	}
	
	//Eckert - Fading out sound	, needed an extra second to play crash sounds
	wait 2;
	level clientnotify( "fade_out" );
	
	wait 1;
	
	nextmission();
	//fastrestart();
}

// This function runs on the bigrig when it gets spawned
cougar_crash_big_rig()
{
	level.crash_bigrig = self;
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

// send client notify to show hands based off of get in animation
show_drive_hands( m_player_body )
{
	ClientNotify( "enter_cougar" );
}


ambient_drones()
{
	level thread spawn_ambient_drones( "trigger_bob", undefined, "avenger_street_flyby_1", "f38_street_flyby_1", "start_street_flyby_1", 4, 1, 3, 4, 500, 3 );
	level thread spawn_ambient_drones( "trigger_bob", undefined, "avenger_street_flyby_2", "f38_street_flyby_2", "start_street_flyby_2", 5, 1, 4, 5, 500, 2 );	
	level thread spawn_ambient_drones( "trigger_bob", undefined, "avenger_street_flyby_3", "f38_street_flyby_3", "start_street_flyby_3", 5, 1, 3, 4, 500 );		
	level thread spawn_ambient_drones( "trigger_bob", undefined, "avenger_street_flyby_4", "f38_street_flyby_4", "start_street_flyby_4", 5, 1, 4, 5, 500 );				
}




/#
debug_vehicle_count()
{
	hudelem = NewHudElem();
	hudelem.alignX = "left";
	hudelem.alignY = "bottom";
	hudelem.horzAlign = "left";
    hudelem.vertAlign = "bottom";
    hudelem.x = 0;
    hudelem.y = 0;    
  	hudelem.fontScale = 1.0;
	hudelem.color = (0.8, 1.0, 0.8);
	hudelem.font = "objective";
	hudelem.glowColor = (0.3, 0.6, 0.3);
	hudelem.glowAlpha = 1;
 	hudelem.foreground = 1;
 	hudelem.hidewheninmenu = true;
 	
 	while ( true )
 	{
 		n_count = GetVehicleArray().size;
 		hudelem SetValue( n_count );
 		wait .05;
 	}
}
#/
