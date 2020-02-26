#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_dialog;
#include maps\_objectives;
#include maps\_scene;
#include maps\_turret;
#include maps\_vehicle;
#include maps\pakistan_util;
#include maps\pakistan_s3_util;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_escape_bosses()
{
	skipto_teleport( "skipto_escape_bosses" );
	
	escape_setup( true );

	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	level.vh_player_drone thread store_previous_veh_nodes();
	level.vh_player_drone play_fx( "drone_spotlight_cheap", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx_cheap", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_player_soct thread watch_for_boost();
	
	nd_start = GetVehicleNode( level.skipto_point + "_player_start", "script_noteworthy" );
	level thread vehicle_switch( nd_start );
	
	a_ai_targets = GetEntArray( "ai_target", "script_noteworthy" );
	array_thread( a_ai_targets, ::add_spawn_function, ::set_lock_on_target, ( 0, 0, 45 ) );
	
	add_spawn_function_veh( "boss_apache", ::apache_setup );
	trigger_use( "spawn_apache" );
	trigger_use( "spawn_hotel_0" );
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	set_objective( level.OBJ_ESCAPE );
	flag_set( "vehicle_switched" );
}

skipto_warehouse()
{
	skipto_teleport( "skipto_warehouse" );
	
	escape_setup( true );

	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	level.vh_player_drone thread store_previous_veh_nodes();
	level.vh_player_drone play_fx( "drone_spotlight_cheap", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx_cheap", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_player_soct thread watch_for_boost();
	
	a_ai_targets = GetEntArray( "ai_target", "script_noteworthy" );
	array_thread( a_ai_targets, ::add_spawn_function, ::set_lock_on_target, ( 0, 0, 45 ) );
	
	add_spawn_function_veh( "boss_apache", ::apache_setup );
	
	level.vh_apache = spawn_vehicle_from_targetname( "boss_apache" );
	level.vh_super_soct = spawn_vehicle_from_targetname( "boss_soct" );
	
	level thread warehouse_vehicle_switch();
	level thread escape_bosses_objectives();
	level thread hack_triggers();
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	set_objective( level.OBJ_ESCAPE );
	flag_set( "vehicle_switched" );
}

main()
{
	/#
		IPrintLn( "Escape End" );
	#/
		
	level notify( "escape_bosses_started" );
		
	level.vh_player_drone thread escape_boss_drone_logic();
	
	for ( i = 1; i <= 3; i++ )
	{
		m_eleveator = GetEnt( "elevator0" + i, "targetname" );
		m_eleveator thread elevator_logic( i );
	}
	
	escape_boss_spawn_func();
	level thread escape_bosses_objectives();
	level thread escape_bosses_checkpoints();
	level thread escape_bosses_clean_up();
	level thread escape_bosses_vo();
	
	if ( level.skipto_point != "escape_bosses" )
	{
		trigger_wait( "spawn_apache" );
	}
	
	level.vh_apache thread apache_think();
	level.vh_player_soct thread hotel_super_soct_condition();
	level.vh_player_soct thread escape_bosses_fail();
	level thread drone_attack_water_tower();
	level thread water_tower();
	pipe_fall();
	
	level.vh_salazar_soct thread escape_bosses_salazar_logic();
	level thread hack_triggers();
	level thread soct_walkway_ai_spawn();
	level thread drone_attack_silo();
	level thread big_jump_check_2();
	level thread get_the_player_up_drone_vo();
}

hotel_super_soct_condition()
{
	level.harper thread hotel_super_soct_condition_vo();
	level.harper thread hotel_drone_condition_vo();
	
	if ( level.player get_temp_stat( SOCT_HAS_BOOST ))
	{
		level.vh_player_soct.n_intensity_min = 0;
		
		trigger_wait( "spawn_super_soct" );
		
		level.vh_player_soct.n_intensity_min = 6;
	}
	else
	{
		trigger_wait( "spawn_hotel_block_socts" );
	
		wait 0.05;
	
		ai_shooter_742 = GetEnt( "shooter_742_drone", "targetname" );
		ai_shooter_743 = GetEnt( "shooter_743_drone", "targetname" );
	
		ai_shooter_742.overrideActorDamage = ::hotel_soct_shooter_damage_override;
		ai_shooter_743.overrideActorDamage = ::hotel_soct_shooter_damage_override;
	
		trigger_wait( "non_super_soct_crash" );
		
		SetDvar( "ui_deadquote", &"PAKISTAN_SHARED_NON_SUPER_SOCT_FAIL" );
		
		level notify( "end_veh_collision_watcher" );
		level.vh_player_soct notify( "end_player_in_soct_fail" );
	
		level.player Suicide();
	}
}

hotel_super_soct_condition_vo()
{
	level.vh_salazar_soct waittill( "turn_left" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		if ( level.player get_temp_stat( SOCT_HAS_BOOST ) )
		{
			level.harper say_dialog( "harp_ram_em_0" );
		}
		else
		{
			level.harper say_dialog( "harp_go_left_go_left_0" );
		}
	}
}

hotel_drone_condition_vo()
{
	trigger_wait( "behind_hotel_drone" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		self say_dialog( "harp_where_gotta_keep_mov_0" );
	}
}

hotel_soct_shooter_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( str_weapon == "boat_gun_turret" )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

// self == player's soc-t
escape_bosses_fail()
{
	level endon( "pipe_fall_done" );
	
	trigger_wait( "pipe_fall_0" );
	
	while ( true )
	{
		self waittill( "veh_collision", v_location, v_normal, n_intensity, str_type, e_collide );
		
		if ( str_type == "metal" && !IsDefined( e_collide ) )
		{
			wait 0.05;
			
			if ( self GetSpeedMPH() < 0 )
			{				
				missionfailedwrapper( &"PAKISTAN_SHARED_PIPE_FAIL" );
			}
		}
		
		wait 0.05;
	}
}

escape_bosses_objectives()
{
	trigger_wait( "see_evac_point" );
	
	set_objective( level.OBJ_EVAC_POINT, getstruct( "evac_point", "targetname" ), "breadcrumb" );
	//exploder( 850 );
	purple_smoke();
//	IPrintLnBold( "Head toward the purple smoke! That's where the evac point is at!" );
	level notify( "see_purple_smoke" );
}

escape_bosses_checkpoints()
{
	trigger_wait( "escape_bosses_save_5" );
	
	autosave_by_name( "escape_bosses_save_5" );
	level.n_save = 5;
	
	trigger_wait( "escape_bosses_save_6" );
	
	autosave_by_name( "escape_bosses_save_6" );
	level.n_save = 6;
	
	trigger_wait( "escape_bosses_save_7" );
	
	autosave_by_name( "escape_bosses_save_7" );
	level.n_save = 7;
	
	level notify( "pipe_fall_done" );
}

escape_bosses_clean_up()
{
	level waittill( "hotel_clean_up" );
	
	enemy_clean_up( 18944, 0, true, true );
}

escape_bosses_vo()
{
//	trigger_wait( "wtf_vo" );
	wait 2;
	
	level.harper say_dialog( "harp_what_the_fuck_0" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		level.harper say_dialog( "harp_take_direct_control_0" );
	}
	
	trigger_wait( "near_pipes_drone" );
	
	level.harper say_dialog( "harp_something_tells_me_t_0" );
	
	trigger_wait( "pipe_fall_intro" );
	
	level.harper say_dialog( "harp_the_whole_place_is_c_0" );
	level.harper say_dialog( "harp_go_left_0" );
	
	trigger_wait( "pipe_fall_1" );
	
	level.harper say_dialog( "harp_go_right_0" );
	
	trigger_wait( "pipe_fall_2" );
	
	level.harper say_dialog( "harp_go_left_0" );
	
	trigger_wait( "spawn_factory_catwalk_1" );
	
	level.harper say_dialog( "harp_dammit_man_this_a_0" );
	level.harper say_dialog( "harp_find_a_way_through_0" );
	
	level waittill( "fxanim_silo_end_collapse_start" );
	
	level.harper say_dialog( "harp_it_s_comin_down_g_0" );
}

takedown_apache_vo()
{
	trigger_wait( "apache_retreat" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		level.harper say_dialog( "harp_put_this_son_of_a_bi_0" );
		level.harper say_dialog( "harp_once_and_for_all_0" );
	}
}

// HACK
hack_triggers()
{
	trigger_wait( "enter_final_warehouse" );
	
	level notify( "enter_final_warehouse" );
}

escape_boss_spawn_func()
{	
	a_hallway_bad = GetEntArray( "hotel_hallway_0", "targetname" );
	array_thread( a_hallway_bad, ::add_spawn_function, ::hallway_ai_logic );
	
	a_factory_walkway_2 = GetEntArray( "factory_walkway_2", "targetname" );
	array_thread( a_factory_walkway_2, ::add_spawn_function, ::soct_walkway_ai_logic );
	
	add_spawn_function_veh( "hotel_block_l", ::enemy_soct_setup, true );
	add_spawn_function_veh( "hotel_block_r", ::enemy_soct_setup, true );
	add_spawn_function_veh( "boss_soct", ::super_soct_think );
	
	level thread behind_hotel_drone();
	level thread near_pipes_drone();
	level thread near_catwalk_drone();
}

behind_hotel_drone()
{
	trigger_wait( "behind_hotel_drone" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup();
	vh_drone.origin = ( 25600, -21504, 832 );
	vh_drone SetPhysAngles( ( 0, 180, 0 ) );
	vh_drone SetLookAtEnt( level.vh_player_drone );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( 24064, -19456, 512 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "near_goal" );

	vh_drone SetHoverParams( 64 );
	
	trigger_wait( "pipe_fall_0" );
	
	vh_drone SetVehGoalPos( ( 20992, -21504, 832 ) );
	
	vh_drone waittill( "near_goal" );
	
	VEHICLE_DELETE( vh_drone );
}

near_pipes_drone()
{
	trigger_wait( "near_pipes_drone" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( 26112, -18944, 256 );
	vh_drone SetPhysAngles( ( 0, 180, 0 ) );
	vh_drone SetLookAtEnt( level.vh_player_drone );
	vh_drone.drivepath = 1;
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		wait 2.6; // time before moving the drone
	}
	else
	{
		wait 2;
	}
	
	vh_drone SetVehGoalPos( ( 28352, -18688, 448 ) );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 32064, -18432, 704 ) );
	
	vh_drone waittill( "goal" );

	vh_drone SetHoverParams( 64 );
	
	wait 3;
	
	VEHICLE_DELETE( vh_drone );
}

near_catwalk_drone()
{
	trigger_wait( "spawn_factory_catwalk_1" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup();
	vh_drone.origin = ( 39424, -13312, 448 );
	vh_drone SetPhysAngles( ( 0, 270, 0 ) );
	vh_drone SetLookAtEnt( level.vh_player_soct );
	vh_drone.drivepath = 1;
	
	vh_drone SetVehGoalPos( ( 39680, -13824, 576 ) );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 37888, -16000, 384 ) );
	VEHICLE_DELETE( vh_drone );
}

// self == player's drone
escape_boss_drone_logic()
{
	//	level.vh_player_drone waittill( "reached_end_node" );
		
	self waittill( "end_speed_control" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		flag_set( "stop_drone_speed_control" );
		self SetSpeed( 29, VH_ACCELERATION, VH_DECELERATION );
	}
	
	self waittill( "resume_drone_speed_control" );
	
	flag_clear( "stop_drone_speed_control" );
}

// self == an elevator
elevator_logic( n_elevator_number )
{	
	self endon( "being_deleted" );
	
	self SetCanDamage( true );
	self.health = 512;
	self.is_alive = true;
	
	const n_health_min = 105;
	
	for ( i = 1; i <= 2; i++ )
	{
		s_position = getstruct( "elevator_spot_" + n_elevator_number + "_" + i, "targetname" );
		ai_elevator = simple_spawn_single( "elevator_" + i );
		ai_elevator forceteleport( s_position.origin, s_position.angles );
		ai_elevator Linkto( self );
		ai_elevator thread eleveator_ai_logic( self );
	}
	
	trigger_wait( "move_elevators" );
	
	self thread set_lock_on_target();
	self thread elevator_delete();
	
	n_dest_height = self.origin[2];
	self MoveTo( self.origin - ( 0, 0, n_dest_height ), 9 );
	
	while ( self.is_alive )
	{
		self waittill( "damage", n_damage, e_attacker );
		
		if ( self.health < n_health_min && e_attacker == level.player )
		{
			self.is_alive = false;
		}
	}
	
	self MoveTo( self.origin - ( 0, 0, n_dest_height ), 2 );
	
	while ( self.origin[2] > 128 )
	{	
		wait 0.05;
	}
	
	PlayFX( level._effect[ "blockade_explosion" ], self.origin );
	self Delete();
}

// self == an elevator
elevator_delete()
{
	self endon( "death" );
	
	trigger_wait( "spawn_super_soct" );
	
	self notify( "being_deleted" );
	self Delete();
}

// self == an enemy AI on the elevator
eleveator_ai_logic( m_elevator )
{
	self endon( "death" );
	
	self set_ignoreall( true );
	
	trigger_wait( "move_elevators" );
	
	self thread shoot_at_target( level.vh_player_drone, undefined, undefined, -1 );
	
	m_elevator waittill( "death" );
	
	self Delete();
}

// self == enemy AI
hallway_ai_logic()
{
	self endon( "death" );
	
	self thread run_over();
	
	trigger_wait( "hotel_hallway_runaway" );
	
	if ( self.script_noteworthy == "behind" )
	{
		self change_movemode( "sprint" );
	}
	else
	{
		self disable_tactical_walk();
	}
	
	self.goalradius = 16;
}

soct_walkway_ai_spawn()
{
	trigger_wait( "spawn_factory_walkway_2" );
	
	ai_behind = simple_spawn_single( "factory_walkway_2_behind" );
	ai_behind thread soct_walkway_ai_logic();
}

// self == enemies on the soc-t walkway
soct_walkway_ai_logic()
{
	self endon( "death" );
	
	self thread shoot_at_target( level.vh_player_drone );
	
	trigger_wait( "runaway_factory_walkway" );
	
	self thread run_over();
	
	if ( self.targetname == "factory_walkway_2_behind_ai" )
	{
		self change_movemode( "sprint" );
	}
	else
	{
		self disable_tactical_walk();
	}

	self.goalradius = 16;
}

// self == super soc-t boss
super_soct_think()
{
	self endon( "death" );
	
	level.vh_super_soct = self;
	self veh_magic_bullet_shield( true );
	
	self.n_time_between_shots = 0.05;
	self.e_target_current = GetEnt( "pipe_0", "targetname" );
	self thread super_soct_shoot_logic();
	self thread super_soct_speed_control( true );
	
	trigger_wait( "pipe_fall_0" );
	
	self.e_target_current = GetEnt( "pipe_1", "targetname" );
	
	trigger_wait( "pipe_fall_1" );
	
	self.e_target_current = GetEnt( "water_tower_end", "targetname" );
	
	trigger_wait( "pipe_fall_2" );
	
	self.n_time_between_shots = 3;
	self.e_target_current = level.player;
	self veh_magic_bullet_shield( false );
	self thread set_lock_on_target( ( 0, 0, 32 ) );
	self thread drone_kill_count();
	self thread add_scripted_damage_state( 0.5, ::soct_damaged_fx );
	self.overrideVehicleDamage = ::enemy_soct_damage_override;
}

// self == boss super soc-t
super_soct_shoot_logic()
{
	self endon( "death" );
	level endon( "hangar_started" );
	
	e_target_previous = self.e_target_current;
	self set_turret_target(	self.e_target_current, undefined, 1 );
	
	while ( true )
	{
		if ( e_target_previous != self.e_target_current )
		{
			self set_turret_target(	self.e_target_current, undefined, 1 );
			e_target_previous = self.e_target_current;
		}
		
		self thread fire_turret_for_time( 4.5, 1 );
		
		wait self.n_time_between_shots;
	}
}

// self == boss super soc-t
super_soct_speed_control( b_initial )
{
	self endon( "death" );
	self endon( "end_speed_control" );
	
	if ( IS_TRUE( b_initial ) )
	{
		self thread super_soct_speed();
		self waittill( "speed_control" );
	}
	
	while ( true )
	{
		if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
		{
			self SetSpeed( self.n_speed_based_on_soct, VH_ACCELERATION, VH_DECELERATION );
		}
		else if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
		{
			self SetSpeed( self.n_speed_based_on_drone, VH_ACCELERATION, VH_DECELERATION );
		}
		
		wait 0.05;
	}
}

// self == boss super soc-t
super_soct_speed()
{
	self endon( "death" );
	
	self.n_speed_based_on_drone = 77;
	//self.n_speed_based_on_soct = 73;
	self.n_speed_based_on_soct = 86;
	
	self waittill( "speed_control" );
	
	self.n_speed_based_on_drone = 67;
	
	trigger_wait( "pipe_fall_0" );
	
	self.n_speed_based_on_drone = 63;
	self.n_speed_based_on_soct = 63;
	
	trigger_wait( "pipe_fall_1" );
	
	self.n_speed_based_on_soct = 71;
	
	trigger_wait( "pipe_fall_2" );
	
	self.n_speed_based_on_drone = 89;
	self.n_speed_based_on_soct = 63;
	self thread left_outside_speed_up();
	
//	level waittill( "fxanim_silo_end_collapse_start" );
//	
//	self.n_speed_based_on_soct = 89;
//	
//	trigger_wait( "player_at_2nd_floor" );
//	
//	self.n_speed_based_on_drone = 44;
//	self.n_speed_based_on_soct = 54;
//	self thread super_soct_speed_control();
}

// self == apache
apache_think()
{
	self endon( "death" );
	
	trigger_wait( "pipe_fall_0" );
	
	self ClearVehGoalPos();
	
	self.origin = ( 41728, -2048, 512 );
	self SetPhysAngles( ( 0, 270, 0 ) );
	self SetLookatEnt( level.vh_player_drone );
	self.drivepath = 1;
	self SetHoverParams( 512 );
	
	wait 0.05;
	
	level notify( "hotel_clean_up" );
	self enable_turret( 0 );
	
	level waittill( "fxanim_silo_end_collapse_start" );
	
	self SetVehGoalPos( ( 40448, 2048, 768 ) );
	self SetSpeed( 119 );
}

drone_attack_water_tower()
{
	trigger_wait( "shoot_water_tower" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	nd_start = GetVehicleNode( "apache_start_1", "targetname" );
	vh_drone thread enemy_drone_setup( true );
	vh_drone go_path( nd_start );
	
	VEHICLE_DELETE( vh_drone );
}

drone_attack_silo()
{
	trigger_wait( "attack_catwalk_final" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup();
	
	e_target = GetEnt( "catwalk_final", "targetname" );
	vh_drone SetLookAtEnt( e_target );
	vh_drone set_turret_target( e_target, undefined, 0 );
	vh_drone fire_turret( 0 );
	
	nd_start = GetVehicleNode( "apache_start_2", "targetname" );
	vh_drone thread go_path( nd_start );

	vh_drone waittill( "shoot_catwalk_final" );
	
	vh_drone set_turret_target( e_target, undefined, 1 );
	vh_drone set_turret_target( e_target, undefined, 2 );
	
	wait 2;
	
	vh_drone fire_turret( 1 );
	vh_drone fire_turret( 2 );
	
	wait 0.05;
	
	e_target playsound( "exp_veh_large" );
	e_target playsound( "evt_watertower_collapse" );
	PlayFX( level._effect[ "blockade_explosion" ], e_target.origin );
	level notify( "fxanim_silo_end_collapse_start" );
	level notify( "fxanim_catwalk_end_collapse_start" );
	
	vh_drone waittill( "stop_lookat" );
	
	vh_drone ClearLookAtEnt();
	vh_drone veh_magic_bullet_shield( false );
	
	vh_drone waittill( "reached_end_node" );
	
	vh_drone DoDamage( vh_drone.health, vh_drone.origin );
}

// self == boss super soc-t
left_outside_speed_up()
{
	trigger_wait( "super_soct_speed_up" );
	
	self.n_speed_based_on_drone = 61;
	self.n_speed_based_on_soct = 76;
}

pipe_fall()
{
	trigger_wait( "spawn_super_soct" );
	
	flag_set( "player_cannot_get_hurt" );
	
	trigger_wait( "pipe_fall_0" );
	
	m_pipe = GetEnt( "pipe_0", "targetname" );
	PlayFX( level._effect[ "blockade_explosion" ], m_pipe.origin );
	m_pipe playsound( "exp_veh_large" );
	m_pipe MoveTo( m_pipe.origin - ( 0, 0, 256 ), 0.5 );
	m_pipe thread play_delayed_impact_sound( 0 );
	
	trigger_wait( "pipe_fall_1" );
	
	m_pipe = GetEnt( "pipe_1", "targetname" );
	PlayFX( level._effect[ "blockade_explosion" ], m_pipe.origin );
	m_pipe playsound( "exp_veh_large" );
	m_pipe MoveTo( m_pipe.origin - ( 0, 0, 256 ), 0.5 );
	m_pipe thread play_delayed_impact_sound( 1 );
	
	trigger_wait( "pipe_fall_2" );
	
	v_pos_end = GetEnt( "water_tower_end", "targetname" );
	m_pipe = GetEnt( "pipe_2", "targetname" );
	PlayFX( level._effect[ "blockade_explosion" ], v_pos_end.origin );
	v_pos_end playsound( "exp_veh_large" );
	m_pipe MoveTo( m_pipe.origin - ( 0, 0, 256 ), 0.5 );
	m_pipe thread play_delayed_impact_sound( 2 );
	
	flag_clear( "player_cannot_get_hurt" );
}

pipe_zone_player_damage_override( e_inflictor, e_attacker, n_damage, n_flags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime )
{
	n_damage = 0;
	
	return n_damage;
}

// self == pipe model
play_delayed_impact_sound( num )
{
	self waittill( "movedone" );
	self playsound( "evt_water_impact_0" + num );
}

water_tower()
{
	trigger_wait( "shoot_water_tower" );
	
	v_pos_start = getstruct( "water_tower_start", "targetname" );
	v_pos_end = GetEnt( "water_tower_end", "targetname" );
	MagicBullet( "usrpg_sp", v_pos_start.origin, v_pos_end.origin );
	
	wait 1;
	
	MagicBullet( "usrpg_sp", v_pos_start.origin, v_pos_end.origin );
	
	level.vh_apache waittill( "fire_rocket" );
	
	e_target = GetEnt( "apache_target_1", "targetname" );
	level.vh_apache set_turret_target( e_target, undefined, 1 );
	level.vh_apache set_turret_target( e_target, undefined, 2 );
	level.vh_apache fire_turret( 1 );
	level.vh_apache fire_turret( 2 );
}

// self == salazar's soct
escape_bosses_salazar_logic()
{
	self endon( "death" );
	
	self waittill( "speed_up" );
	
	self notify( "end_salazar_speed_control" );
	self SetSpeed( 91, VH_ACCELERATION, VH_DECELERATION );
	
	self waittill( "silo_pass" );
	
	m_wall = GetEnt( "silo_collision", "targetname" );
	m_wall MoveTo( m_wall.origin - ( 0, 0, 512 ), 0.05 );
}

warehouse_main()
{
	warehouse_spawn_func();
	level thread warehouse_vo();
	
	level.vh_player_drone thread warehouse_drone_logic();
	level.vh_salazar_soct thread warehouse_salazar_logic();
	
	if ( IS_VEHICLE( level.vh_super_soct ) )
	{
		level.vh_super_soct thread warehouse_super_soct_logic();
	}
	
	if ( IS_VEHICLE( level.vh_apache ) )
	{
		level.vh_apache thread warehouse_apache_logic();
	}
	
	prepare_for_hangar();
}

warehouse_vo()
{
	level thread takedown_apache_vo();
	
	level waittill( "see_purple_smoke" );
	
	level.harper say_dialog( "harp_daaaamn_i_see_smo_0" );
	
	trigger_wait( "prepare_for_hangar" );
	
	level.harper say_dialog( "harp_we_ve_still_gotta_a_0" );
}

warehouse_spawn_func()
{
	add_spawn_function_veh( "warehouse_soct_0", ::enemy_soct_setup, true );
}

// self == player's drone
warehouse_drone_logic()
{	
	trigger_wait( "spawn_warehouse_soct_0" );
	
	flag_set( "stop_drone_speed_control" );
	
	self SetSpeed( 55, VH_ACCELERATION, VH_DECELERATION );
	
	self waittill( "reached_end_node" );
	
	s_align = getstruct( "harper_faceburn", "targetname" );
	v_drone_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_8_3_hangar_event_drone );
	self SetVehGoalPos( v_drone_start_pos, false, 0 );
	self SetNearGoalNotifyDist( 512 );
	
	n_goal_speed = 61;
	if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE )
	{
		n_goal_speed = 119;
	}
	
	self thread lerp_vehicle_speed( self GetSpeedMPH(), n_goal_speed, 3 );
}

// self == salazar's soc-t
warehouse_salazar_logic()
{
	trigger_wait( "enter_final_warehouse" );
	
	nd_start = GetVehicleNode( "salazar_path_3", "targetname" );
	self.origin = nd_start.origin;
	wait 0.05;
	self thread go_path( nd_start );
	
	n_new_speed = nd_start.speed / INCHES_PER_SEC_TO_MPH;
	self SetSpeed( n_new_speed, VH_ACCELERATION, VH_DECELERATION );
	
	self waittill( "in_warehouse" );
	
	self thread salazar_soct_speed_control();
	
	self waittill( "reached_end_node" );
	              
	s_align = getstruct( "harper_faceburn", "targetname" );
	v_salazar_soct_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_8_3_hangar_event_soct02 );
	self SetVehGoalPos( v_salazar_soct_start_pos, false, 0 );
	self SetNearGoalNotifyDist( 512 );
	self thread lerp_vehicle_speed( self GetSpeedMPH(), 119, 3 );
}

// self == super soc-t
warehouse_super_soct_logic()
{
	self endon( "death" );
	
	//level waittill( "enter_final_warehouse" );
	trigger_wait( "enter_final_warehouse" );
	
	self notify( "end_speed_control" );
	
	nd_start = GetVehicleNode( "super_soct_start_2", "targetname" );
	self.origin = nd_start.origin;
	wait 0.05;
	self thread go_path( nd_start );
	
	//n_new_speed = nd_start.speed / INCHES_PER_SEC_TO_MPH;
	n_new_speed = 63;
	self SetSpeed( n_new_speed, VH_ACCELERATION, VH_DECELERATION );
	
	self waittill( "reached_end_node" );
	              
	s_align = getstruct( "harper_faceburn", "targetname" );
	v_super_soct_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_8_3_hangar_event_soct03 );
	self SetVehGoalPos( v_super_soct_start_pos, false, 0 );
	self SetNearGoalNotifyDist( 512 );
	self thread lerp_vehicle_speed( self GetSpeedMPH(), 119, 3 );
}

// self == apache
warehouse_apache_logic()
{
	self endon( "death" );
	
	trigger_wait( "enter_final_warehouse" );
	
	self ClearVehGoalPos();
	self clear_turret_target( 1 );
	self clear_turret_target( 2 );
	
	nd_start = GetVehicleNode( "apache_start_3", "targetname" );
	self.origin = nd_start.origin;
	self SetPhysAngles( ( 0, 270, 0 ) );
	self SetLookatEnt( level.vh_player_drone );
	self.drivepath = 1;
	self SetHoverParams( 64 );
	
	e_target = GetEnt( "apache_fake_drone_target", "targetname" );
	self set_turret_target( e_target, undefined, 1 );
	self set_turret_target( e_target, undefined, 2 );
	
	trigger_wait( "apache_final_appearance" );
	
	nd_start = GetVehicleNode( "apache_start_4", "targetname" );
	self thread set_lock_on_target();
	self SetVehGoalPos( nd_start.origin, 1 );
	
	level notify( "apache_showed_up" );
	
//	trigger_wait( "apache_fire_at_drone" );
	self waittill( "goal" );
	
	self veh_magic_bullet_shield( false );
	self.overrideVehicleDamage = ::apache_damage_override;
	
	self set_turret_target( e_target, undefined, 0 );
	self waittill( "turret_on_target" );
	self fire_turret( 1 );
	self fire_turret( 2 );
	
	self SetHoverParams( 64 );
	
	trigger_wait( "apache_retreat" );
	
	self thread go_path( nd_start );
	
	self set_turret_target( level.vh_player_drone, undefined, 0 );
	self thread warehouse_apache_shoot_logic();
	
	level.vh_player_drone SetLookatEnt( self );
	self thread warehouse_apache_death();
	
	self waittill( "stop_drive_path" );
	
	self.drivepath = 0;
	
	self waittill( "start_drive_path" );
	
	self.drivepath = 1;
	
	n_speed = 1;
	self SetSpeedImmediate( n_speed, 1000, 1000 );
	self SetSpeed( n_speed, 1000, 1000 );
	              
//	s_align = getstruct( "harper_faceburn", "targetname" );
//	v_apache_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_8_3_hangar_event_apache );
//	self SetVehGoalPos( v_apache_start_pos, false, 0 );
//	self SetNearGoalNotifyDist( 512 );
//	self thread lerp_vehicle_speed( self GetSpeedMPH(), 29, 3 );
}

// self == apache
apache_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psOffsetTime, b_damage_from_underneath, n_model_index, str_part_name )
{
	if ( e_attacker != level.player )
	{
		if ( IsDefined( e_attacker.vteam ) && e_attacker.vteam == "allies" )
		{
			n_damage = 1;
		}
		else
		{
			n_damage = 0;
		}
	}
	else if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		n_damage = 1;
	}
	
	return n_damage;
}

// self == apache
warehouse_apache_shoot_logic()
{
	self endon( "death" );
	self endon( "stop_shooting" );
	
	self waittill( "shoot" );
	
	self set_turret_target( level.vh_player_drone, undefined, 0 );
	self set_turret_target( level.vh_player_drone, undefined, 1 );
	self set_turret_target( level.vh_player_drone, undefined, 2 );
	
	while ( true )
	{
		self waittill( "turret_on_target" );
		self fire_turret( 1 );
		self fire_turret( 2 );
		
		wait RandomFloatRange( 0.4, 1.1 );
	}
}

// self == apache
warehouse_apache_death()
{
	level.vh_player_drone endon( "death" );
	
	self waittill( "death" );
	
	level.vh_player_drone ClearLookAtEnt();
}

warehouse_vehicle_switch()
{
	trigger_wait( "enter_final_warehouse" );
	
	nd_start = GetVehicleNode( level.skipto_point + "_player_start", "script_noteworthy" );
	level thread vehicle_switch( nd_start );
}

prepare_for_hangar()
{
	level thread stop_vehicle_switching();
	
	trigger_wait( "prepare_for_hangar" );
	
	level thread load_gump( "pakistan_3_gump_escape_end" );
//	level thread autosave_after_gump( "pakistan_3_gump_escape_end" );
	
	while ( !flag( "vehicle_switched" ) )
	{
		wait 0.05;
	}
	
//	level notify( "end_vehicle_switch" );
	level notify( "escape_done" );
	
	//level.player FreezeControls( true );
	
	//s_align = getstruct( "harper_faceburn", "targetname" );
	s_goal = getstruct( "player_soct_hangar_pos", "targetname" );
	
	//v_player_soct_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_8_3_hangar_event_soct01 );
	//level.vh_player_soct SetVehGoalPos( v_player_soct_start_pos, false, 0 );
	level.vh_player_soct SetVehGoalPos( s_goal.origin, false, 0 );
	level.vh_player_soct SetNearGoalNotifyDist( 768 );
	level.vh_player_soct thread lerp_vehicle_speed( level.vh_player_soct GetSpeedMPH(), 61, 3 );
	
	level.vh_player_soct waittill( "near_goal" );
}

autosave_after_gump( str_gump )
{
//	flag_wait( str_gump );
	scene_wait( "hangar" );
	
	wait 0.5;
	
	autosave_by_name( str_gump );
}

stop_vehicle_switching()
{
	trigger_wait( "stop_switching" );
	
	flag_set( "cannot_switch" );
}

big_jump_check_2()
{
	trigger_wait( "big_jump_2_start" );
	
	trigger_wait( "big_jump_2_end" );
	
	level notify( "big_jump" );
}