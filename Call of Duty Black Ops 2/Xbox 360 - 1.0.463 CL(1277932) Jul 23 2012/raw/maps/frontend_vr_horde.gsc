/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 6/13/2012
 * Time: 6:38 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
 
#include common_scripts\utility;
#include maps\_utility;
#include maps\frontend_util;

#insert raw\common_scripts\utility.gsh;

// Stop all spawn managers and delete everyone still living.
//
level_complete_delete_everyone()
{
	level notify( "horde_spawning_stopped" );
	flag_clear( "horde_spawning_active" );
	sm_array = get_spawn_manager_array();
	foreach( sm in sm_array )
	{
		spawn_manager_disable( sm.targetname );
	}
	
	ai_array = GetAIArray( "axis" );
	array_delete( ai_array );
}

horde_run_clock( initial_time_s )
{
	level.m_horde_timer = initial_time_s;
	
	while ( level.m_horde_timer > 0.0 )
	{
		wait 1.0;
		level.m_horde_timer--;
	}
	
	// Time's up.
	level.m_horde_timer = 0;
	level_complete_delete_everyone();
	
	IPrintLnBold( "Time Out" );
}

waittill_spawn_manager_spawns_x_more( str_spawn_manager, num_extra_spawns )
{
	// find out how many we've spawned so far.
	spawn_managers = maps\_spawn_manager::get_spawn_manager_array( str_spawn_manager );
	prev_count = spawn_managers[0].spawncount;
	
	// wait till we've spawned a few more before disabling the spawner.
	while ( spawn_managers[0].spawncount < prev_count + num_extra_spawns )
	{
		wait 0.25;
	}
}

// Runs the spawn manager until it reaches the number of additional spawns specified, then
// increments level.m_sm_done, and returns.
//
spawn_manager_wave( num_extra_spawns, str_sm_name )
{
	level endon( "horde_spawning_stopped" );
	
	// Spawn wildly until we reach the desired number.
	spawn_manager_enable( str_sm_name );
	waittill_spawn_manager_spawns_x_more( str_sm_name, num_extra_spawns );
	
	// Stop spawning more.
	spawn_manager_disable( str_sm_name );
	
	// Send everyone to the safe volume so they're easier to kill (takes them down off the balconies).
	if ( isdefined( level.m_safe_volume ) )
	{
		ai_list = get_ai_group_ai( str_sm_name );
		foreach ( ai in ai_list )
		{
			ai SetGoalVolumeAuto( level.m_safe_volume );
		}
	}
	
	// Wait till the player has cut them down to half their full size before moving on.
	waittill_ai_group_ai_count( str_sm_name, num_extra_spawns * 0.5 );
	
	level.m_sm_done++;
}

// Run one wave through a set of spawn managers.
//
// str_sm_1: Name of the spawn manager for this wave.
// num_sm1_spawns: The number of spawns to fire off before considering the wave "complete"
//
// str_sm_2: opt
// num_sm2_spawns: opt
//
// ...and so on...
//
spawn_manager_wave_set( str_sm_1, num_sm1_spawns, str_sm_2, num_sm2_spawns )
{
	if ( !flag( "horde_spawning_active" ) )
	{
		return;
	}
	
	// Get everyone from the last wave and send them to the new area.
	if ( isdefined( level.m_safe_volume ) )
	{
		ai_axis = GetAIArray( "axis" );
		foreach ( ai in ai_axis )
		{
			ai SetGoalVolumeAuto( level.m_safe_volume );
		}
	}
	
	level.m_sm_done = 0;
	num_managers = 0;
	
	if ( isdefined( str_sm_1 ) )
	{
		num_managers++;
		level thread spawn_manager_wave( num_sm1_spawns, str_sm_1 );
	}
	
	if ( isdefined( str_sm_2 ) )
	{
		num_managers++;
		level thread spawn_manager_wave( num_sm2_spawns, str_sm_2 );
	}
	
	while ( level.m_sm_done < num_managers && flag( "horde_spawning_active" ) )
	{
		wait_network_frame();
	}
	
	level.m_sm_done = undefined;
}

horde_kill_report()
{
	if ( self.team == "axis" )
	{
		level.m_horde_timer += 2.5;
		IPrintLnBold( "+2.5sec = " + level.m_horde_timer + "sec" );
	}
}

// After a time, everyone will run to the "safe volume."
// This is to prevent guys from staying in towers too long.
//
run_to_safe_volume_after_time()
{
	if ( !flag( "horde_spawning_active" ) )
		return;
	
	self endon( "death" );
	wait level.m_safe_volume_delay;
	self SetGoalVolumeAuto( level.m_safe_volume );
}

run_horde_enemy()
{
	self thread run_to_safe_volume_after_time();
}

main()
{
	flag_init( "horde_spawning_active" );
	add_global_spawn_function( "axis", ::run_horde_enemy );
	
	trigger_on( "vr_start_trigger" );
	
	while ( true )
	{
		trigger_wait( "vr_start_trigger" );
		
		level.callbackActorKilled = ::horde_kill_report;
		
		level thread horde_run_clock( 60 );
	
		load_gump( "frontend_gump_vr" );
		
		skipto_teleport_players( "vr_horde_start" );
		
		toggle_vr_combat( true );
		
		vol_1 = GetEnt( "alley_1_volume", "targetname" );
		vol_2 = GetEnt( "alley_2_volume", "targetname" );
		
		// This can be tweaked as the game progresses.
		level.m_safe_volume_delay = 20.0;
		
		flag_set( "horde_spawning_active" );
		
		// Alternate back and forth.
		while ( flag( "horde_spawning_active" ) )
		{
			level.m_safe_volume = vol_1;
			spawn_manager_wave_set( "sm_alley_1a", 12, "sm_alley_1b", 12 );
			level.m_safe_volume = vol_2;
			spawn_manager_wave_set( "sm_alley_2a", 12, "sm_alley_2b", 12 );
		}
		
		toggle_vr_combat( false );
		level.callbackActorKilled = undefined;
	}
}