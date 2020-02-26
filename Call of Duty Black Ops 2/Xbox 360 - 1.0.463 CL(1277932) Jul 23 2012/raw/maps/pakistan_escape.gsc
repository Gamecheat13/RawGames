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
#include maps\_music;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\pakistan.gsh;

/* ------------------------------------------------------------------------------------------
SKIPTOS
-------------------------------------------------------------------------------------------*/
skipto_escape_battle()
{
	skipto_teleport( "skipto_escape_battle" );
	
	escape_setup( true );

	// Spawn drive hands
	ClientNotify( "enter_soct" );
	
	//TUEY - Set music during skipto
	setmusicstate ("PAKISTAN_CHASE");
	
	level.vh_player_drone play_fx( "drone_spotlight_cheap", level.vh_player_drone GetTagOrigin( "tag_flash" ), level.vh_player_drone GetTagAngles( "tag_flash" ), "remove_fx_cheap", true, "tag_flash" );
	level.vh_player_soct play_fx( "soct_spotlight", level.vh_player_soct GetTagOrigin( "tag_headlights" ), level.vh_player_soct GetTagAngles( "tag_headlights" ), "remove_fx", true, "tag_headlights" );
	
	level.vh_player_soct.driver = level.player;
	
	a_ai_targets = GetEntArray( "ai_target", "script_noteworthy" );
	array_thread( a_ai_targets, ::add_spawn_function, ::set_lock_on_target, ( 0, 0, 45 ) );
	
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	
	set_objective( level.OBJ_ESCAPE );
	flag_set( "vehicle_switched" );
}

main()
{
	/#
		IPrintLn( "Escape" );
	#/
		
	level.a_lanes = [];
	level.a_lanes[ "lane_0" ] = "occupied";
	level.a_lanes[ "lane_1" ] = "occupied";
	level.a_lanes[ "lane_2" ] = "occupied";
	
	escape_battle_spawn_func();
	level thread escape_battle_checkpoints();
	level thread escape_battle_hint();
	level thread escape_battle_vo();
	
	level.vh_player_drone thread store_previous_veh_nodes();
	level thread enemy_speed_control();
	
	trigger_wait( "vs_st_surprise" );
	
	level.vh_player_soct thread watch_for_boost();
	
	level thread enemy_respawn();
	level thread escape_battle_cleanup();
	
	trigger_wait( "vehicle_can_switch" );
	
	nd_start = GetVehicleNode( "escape_battle_player_start", "script_noteworthy" );
	level thread vehicle_switch( nd_start );
	
	flag_set( "vehicle_can_switch" );
	
	level thread load_gump_escape();
	level thread big_jump_check_1();
	level thread heli_crash();
	
	trigger_wait( "spawn_apache" );
}

enemy_speed_control()
{
	trigger_wait( "start_enemy_speed_control" );
	
	level.vh_player_soct thread rubberband_potential_soct();	
}

escape_battle_vo()
{
	level thread general_congrats_vo();
	
	trigger_wait( "vs_st_surprise" );
	
	level thread general_help_vo();
	level.vh_player_soct thread general_ram_vo();
	
	trigger_wait( "escape_battle_save_2" );
	
	level.harper say_dialog( "harp_go_left_onto_the_f_0" );
	
	trigger_wait( "change_course_vo" );
	
	level.harper say_dialog( "harp_change_course_man_0" );
	
	trigger_wait( "slanted_building_intro_vo" );
	
	level notify( "slanted_building_started" );
	level.harper say_dialog( "harp_mother_nature_dealt_0" );
	
	trigger_wait( "squeeze_vo" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		level.harper say_dialog( "harp_gonna_be_a_squeeze_0" );
	}
	
	trigger_wait( "go_for_it_vo" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		level.harper say_dialog( "harp_gotta_go_for_it_0" );
	}
}

escape_battle_hint()
{
	trigger_wait( "vs_st_surprise" );
	
	screen_message_create( &"PAKISTAN_SHARED_SOCT_HINT_RAM" );
	
	level waittill_notify_or_timeout( "takedown", 5.5 );
	
	screen_message_delete();
	
	wait 3;
	
	flag_wait( "vehicle_can_switch" );
	
	wait 0.05; // try to give level.playerviewlockentity time to initialize
	
	screen_message_create( &"PAKISTAN_SHARED_SOCT_TO_DRONE_HINT" );
	
	level.player.viewlockedentity waittill_notify_or_timeout( "change_seat", 4.5 );
	
	screen_message_delete();
	
	if ( level.player get_temp_stat( SOCT_HAS_BOOST ) )
	{
		wait 3;
		
		b_hint_set = false;
		level.player.b_hint_done = false;
		level thread boost_while_in_soct();
		
		while ( !level.player.b_hint_done )
		{
			if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT && IS_FALSE( b_hint_set ) )
			{
				screen_message_create( &"PAKISTAN_SHARED_SOCT_HINT_BOOST" );
				b_hint_set = true;
			}
			else if ( level.player.vehicle_state == PLAYER_VH_STATE_DRONE && IS_TRUE( b_hint_set ) )
			{
				screen_message_delete();
				b_hint_set = false;
			}
			
			wait 0.05;
		}
		
		screen_message_delete();
	}
}

boost_while_in_soct()
{
	n_counter = 0;
	while ( !level.player SprintButtonPressed() && n_counter < 10.5 )
	{
		wait 0.05;
		
		n_counter += 0.05;
	}
	
	level.player.b_hint_done = true;
}

escape_battle_checkpoints()
{
	trigger_wait( "escape_intro_done" );
	
	autosave_by_name( "escape_intro_done" );
	level.n_save = 1;
	
	trigger_wait( "escape_battle_save_2" );
	
	autosave_by_name( "escape_battle_save_2" );
	level.n_save = 2;
	
	trigger_wait( "escape_battle_save_3" );
	
	while ( !flag( "pakistan_3_gump_escape" ) )
	{
		wait 0.05;
	}
	
	autosave_by_name( "escape_battle_save_3" );
	level.n_save = 3;
	
	trigger_wait( "escape_battle_done" );
	
	autosave_by_name( "escape_battle_done" );
	level.n_save = 4;
}

escape_battle_spawn_func()
{
	a_h_drop_bad = GetEntArray( "h_drop_bad", "targetname" );
	array_thread( a_h_drop_bad, ::add_spawn_function, ::run_over );
	
	sp_heli_crash_shooter = GetEnt( "heli_crash_shooter", "targetname" );
	sp_heli_crash_shooter add_spawn_function( ::heli_crash_ai_spawn_func );
		
	add_spawn_function_veh( "st_surprise_soct", ::enemy_soct_setup );
	add_spawn_function_veh( "st_soct_0", ::temp_magic_bullet_shield );
	add_spawn_function_veh( "st_soct_1", ::temp_magic_bullet_shield );
	add_spawn_function_veh( "st_soct_0", ::clear_lane, "lane_0" );
	add_spawn_function_veh( "st_soct_1", ::clear_lane, "lane_1" );
	add_spawn_function_veh( "st_surprise_soct", ::clear_lane, "lane_2" );
	//add_spawn_function_veh( "st_soct_1", ::block_player );
	
	add_spawn_function_veh( "h_soct_0", ::enemy_soct_setup, true );
	add_spawn_function_veh( "h_soct_1", ::enemy_soct_setup );
	add_spawn_function_veh( "h_soct_2", ::enemy_soct_setup );
	add_spawn_function_veh( "hwy_soct_3", ::enemy_soct_setup, true, level.vh_player_soct );
	add_spawn_function_veh( "hwy_drone_0", ::hwy_drone_0_logic );
	add_spawn_function_veh( "hwy_soct_3", ::hwy_soct_3_logic );
	add_spawn_function_veh( "hwy_heli_drop", ::set_lock_on_target );
	add_spawn_function_veh( "h_hind", ::heli_crash_hind_logic );
	add_spawn_function_veh( "h_hind", ::heli_shoot_logic, true );
	
	add_spawn_function_veh( "heli_crash_soct", ::enemy_soct_setup, true );
	add_spawn_function_veh( "heli_crash_soct", ::lerp_crash_soct_to_position );
	
	add_spawn_function_veh( "boss_apache", ::apache_setup );
	
//	level thread slanted_building_drone_0();
	level thread slanted_building_drone_1();
	level thread slanted_building_drone_2();
	level thread hotel_front_drone_0();
	level thread hotel_front_drone_1();
}

hwy_drone_0_logic()
{
	self endon( "death" );
	
	self thread enemy_drone_setup( true );
	self SetLookAtEnt( level.vh_player_soct );
}

slanted_building_drone_0()
{
	trigger_wait( "slanted_building_drones" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( -4096, -19456, 512 );
	vh_drone SetPhysAngles( ( 0, 90, 0 ) );
	vh_drone SetLookAtEnt( level.player );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( -5120, -19456, 384 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( -1024, -21504, 512 ) );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 4096, -21504, 896 ) );
	
	vh_drone waittill( "near_goal" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		vh_drone DoDamage( vh_drone.health, vh_drone.origin );
	}
	else
	{
		vh_drone SetVehGoalPos( ( 3072, -22528, 1024 ) );
	
		vh_drone waittill( "goal" );
	
		if ( !IS_TRUE( vh_drone.crashing ) )
		{
			VEHICLE_DELETE( vh_drone );
		}
	}
}

slanted_building_drone_1()
{
	trigger_wait( "slanted_building_drones" );
	
	wait 0.15;
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( -4096, -19456, 512 );
	vh_drone SetPhysAngles( ( 0, 90, 0 ) );
	vh_drone SetLookAtEnt( level.player );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( -4864, -19456, 384 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );

	vh_drone SetVehGoalPos( ( -1024, -21504, 512 ) );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 4096, -21504, 896 ) );
	
	vh_drone waittill( "near_goal" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		vh_drone DoDamage( vh_drone.health, vh_drone.origin );
	}
	else
	{
		vh_drone SetVehGoalPos( ( 3072, -22528, 1024 ) );
		
		vh_drone waittill( "goal" );
		
		if ( !IS_TRUE( vh_drone.crashing ) )
		{
			VEHICLE_DELETE( vh_drone );
		}
	}
}

slanted_building_drone_2()
{
	trigger_wait( "heli_approach" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( 4608, -19968, 1216 );
	vh_drone SetPhysAngles( ( 0, 180, 0 ) );
	vh_drone SetLookAtEnt( level.player );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( 4608, -20992, 896 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 33 );
	
	vh_drone waittill( "goal" );
	
	if ( level.player.vehicle_state == PLAYER_VH_STATE_SOCT )
	{
		vh_drone DoDamage( vh_drone.health, vh_drone.origin );
	}
	else
	{
		vh_drone SetVehGoalPos( ( 3072, -22528, 1024 ) );
		
		vh_drone waittill( "goal" );
		
		if ( !IS_TRUE( vh_drone.crashing ) )
		{
			VEHICLE_DELETE( vh_drone );
		}
	}
}

hotel_front_drone_0()
{
	trigger_wait( "hotel_front_drones" );
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( 9728, -18944, 768 );
	vh_drone SetPhysAngles( ( 0, 180, 0 ) );
	vh_drone SetLookAtEnt( level.player );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( 9728, -19456, 448 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 10240, -18944, 1024 ) );
	
	vh_drone waittill( "goal" );
	
	if ( !IS_TRUE( vh_drone.crashing ) )
	{
		VEHICLE_DELETE( vh_drone );
	}
}

hotel_front_drone_1()
{
	trigger_wait( "hotel_front_drones" );
	
	wait 0.05;
	
	vh_drone = spawn_vehicle_from_targetname( "drone_respawner" );
	vh_drone endon( "death" );
	
	vh_drone thread enemy_drone_setup( true );
	vh_drone.origin = ( 10240, -22016, 768 );
	vh_drone SetPhysAngles( ( 0, 180, 0 ) );
	vh_drone SetLookAtEnt( level.player );
	vh_drone.drivepath = 1;
	vh_drone SetVehGoalPos( ( 10240, -21504, 448 ) );
	vh_drone SetNearGoalNotifyDist( 512 );
	vh_drone SetSpeed( 63 );
	
	vh_drone waittill( "goal" );
	
	vh_drone SetVehGoalPos( ( 10752, -22016, 1024 ) );
	
	vh_drone waittill( "goal" );
	
	if ( !IS_TRUE( vh_drone.crashing ) )
	{
		VEHICLE_DELETE( vh_drone );
	}
}
	
escape_battle_cleanup()
{
	enemy_clean_up( 10000, 1 );
	
	trigger_wait( "spawn_crash_heli" );
	
	enemy_clean_up( -6100, 1 );
	
	trigger_wait( "spawn_apache" );
	
	enemy_clean_up( 4096, 0, true, true );
}

load_gump_escape()
{
	trigger_wait( "load_gump_escape" );
	
	load_gump( "pakistan_3_gump_escape" );
}

// self == enemy soc-t named "hwy_soct_3"
hwy_soct_3_logic()
{
	self endon( "death" );
	
	trigger_wait( "move_vehicle_721" );
	
	wait 0.75; // magic moment to push the front part of the soc-t to look like it gets air
	
	v_force = ( 0, 0, 18 );
	
	self LaunchVehicle( v_force, self.origin + ( -64, 0, 0 ), false, true );
}

heli_crash()
{
	trigger_wait( "heli_approach" );
	
	vh_soct_crashes_into_heli = GetEnt( "heli_crash_soct", "targetname" );
	level.vh_salazar_soct add_turret_priority_target( vh_soct_crashes_into_heli, 1 );
	
//	run_scene( "heli_approach" );
//	
//	level thread run_scene( "heli_loop" );
	
	flag_wait( "heli_crash_ready" );
	
	level.vh_salazar_soct clear_turret_target_ent_array( 1 );
	
	run_scene( "heli_crash", 3 );
}

heli_crash_hind_logic()
{
	self waittill( "reached_end_node" );
	
	self ClearVehGoalPos();
	
	s_goal = getstruct( "soct_slant_bldg_jump", "targetname" );
	v_anim_start_pos = GetStartOrigin( s_goal.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_7_4_helo_crash_hind );
	
	self.origin = v_anim_start_pos - ( 0, 0, 512 );
	self SetPhysAngles( ( 0, 180, 0 ) );
	self SetLookatEnt( level.vh_salazar_soct );
	self.drivepath = 1;
	self SetHoverParams( 64 );
	
	trigger_wait( "heli_approach" );
	
	self SetVehGoalPos( v_anim_start_pos, 1 );
	
	self waittill( "goal" );
	
	self notify( "shoot" );
	
	trigger_wait( "heli_target_player" );
	
	self SetLookatEnt( level.vh_player_soct );
	
	flag_wait( "heli_crash_ready" );
	
	self notify( "stop_shooting" );
}

lerp_crash_soct_to_position()
{
	self endon( "death" );
	
	self waittill( "heli_crash_soct_end" );
	
	s_align = getstruct( "soct_slant_bldg_jump", "targetname" );
	v_anim_start_pos = GetStartOrigin( s_align.origin, ( 0, 0, 0 ), %vehicles::v_pakistan_7_4_helo_crash_soct );
	self SetVehGoalPos( v_anim_start_pos, false, 0 );
	self SetNearGoalNotifyDist( 256 );
	self thread lerp_vehicle_speed( self GetSpeedMPH(), 63, 6 );
	
	self waittill( "near_goal" );
	
	flag_set( "heli_crash_ready" );
}

heli_crash_ai_spawn_func()
{
	self endon( "death" );
	
	self.overrideActorDamage = ::crash_ai_damage_override;
}

crash_ai_damage_override( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, n_model_index, psOffsetTime, str_bone_name )
{
	if ( IsDefined( e_attacker.vteam ) && e_attacker.vteam == "axis" )
	{
		n_damage = 0;
	}
	else if ( IsDefined( e_attacker.vehicletype ) && e_attacker.vehicletype == "boat_soct_axis" )
	{
		n_damage = 0;
	}
	else if ( str_weapon == "boat_gun_turret" )
	{
		n_damage = 0;
	}
	
	return n_damage;
}

big_jump_check_1()
{
	trigger_wait( "big_jump_1" );
	
	level notify( "big_jump" );
}