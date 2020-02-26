
#include maps\_utility;
#include common_scripts\utility;
#include animscripts\utility;



/*
///ScriptDocBegin
"Name: start_shrimp_path( <shrimp_effect>, <struct_targetname>, <min_speed>, <max_speed>, <min_respawn_delay>, <max_respawn_delay>, [start_delay], [str_kill_flag], [activate_all_paths] )"
"Summary: Sends a shrimp effect down a path of script structs that target each other to define the path."
"Module: _shrimps"
"MandatoryArg: <shrimp_effect>: level._effect[] effect entry to use fo the shrimp, usually an animated effect"
"MandatoryArg: <struct_targetname>: targetname of the path start"
"MandatoryArg: <min_speed>: min speed a shrimp moves down the path"
"MandatoryArg: <max_speed>: max speed a shrimp moves down the path"
"MandatoryArg: <min_respawn_delay>: Min delay before spawning the next shrimp"
"MandatoryArg: <max_respawn_delay>: Max delay before spawning the next shrimp"
"OptionalArg: [start_delay]: Delay before spawning starts"
"OptionalArg: [str_kill_flag]: If defined, when the flag is set the shrimp will delete itself"
"OptionalArg: [activate_all_paths]: if set then activates all paths with the given targetname, default is to pick a random path with targetname, minimu, is 1 path"
"Example: start_shrimp_path( level._effect["shrimp_run_left"], "shrimp_mall_spline1", 7, 12, 2, 8, undefined, undefined );"
"SPMP: singleplayer"
///ScriptDocEnd
*/

start_shrimp_path( shrimp_effect, str_path_start, min_speed, max_speed, min_respawn_delay, max_respawn_delay, start_delay, str_kill_flag, activate_all_paths )
{
	level endon( "stop_shrimps" );

	// Is there a delay before we start spawning shrimps down the path?
	if( IsDefined(start_delay) )
	{
		wait( start_delay );
	}

	// Get all the paths with this targetname
	a_all_path_starts = getstructarray( str_path_start, "targetname" );
	assert( IsDefined(a_all_path_starts), "Shrimp missing start struct - " + str_path_start );

	if( !IsDefined(activate_all_paths) )
	{
		only_one_path_required = randomint( a_all_path_starts.size );
	}
	else
	{
		only_one_path_required = undefined;
	}

	for( i=0; i<a_all_path_starts.size; i++ )
	{
		if( !IsDefined(only_one_path_required) || (only_one_path_required == i) )
		{
			s_path_start = a_all_path_starts[ i ];
			
			level thread _setup_shrimp_path( shrimp_effect, s_path_start, min_speed, max_speed, min_respawn_delay, max_respawn_delay, str_kill_flag );
		}
	}
}

//*****************************************************************************
//*****************************************************************************

_setup_shrimp_path( shrimp_effect, s_path_start, min_speed, max_speed, min_respawn_delay, max_respawn_delay, str_kill_flag )
{
	level endon( "stop_shrimps" );

	// Shrimp spawning loop
	while( 1 )
	{
		// Check the optional kill shrimps flag
		if( IsDefined(str_kill_flag) )
		{
			if( flag(str_kill_flag) )
			{
				return;
			}
		}
	
		speed = randomfloatrange( min_speed, max_speed );
		level thread shrimp_move_down_spline( shrimp_effect, s_path_start, speed, 0, str_kill_flag );
		
		delay = randomfloatrange( min_respawn_delay, max_respawn_delay );
		wait( delay );
	}
}


/*
///ScriptDocBegin
"Name: shrimp_move_down_spline( <shrimp_effect>, <struct_targetname>, <move_speed>, <start_delay>, [str_kill_flag] )"
"Summary: Sends a shrimp effect down a path of script structs that target each other to define the path."
"Module: _shrimps"
"MandatoryArg: <shrimp_effect>: level._effect[] effect entry to use fo the shrimp, usually an animated effect"
"MandatoryArg: <struct_targetname>: targetname of the path start script struct"
"MandatoryArg: <move_speed>: speed to move down the path"
"OptionalArg: [start_delay]: Delay before spawning shrimp"
"OptionalArg: [str_kill_flag]: If defined, when the flag is set the shrimp will delete itself"
"Example: shrimp_move_down_spline( level._effect["shrimp_run_left"], "shrimp_mall_spline1", 10, 0 );"
"SPMP: singleplayer"
///ScriptDocEnd
*/

shrimp_move_down_spline( shrimp_effect, s_path_start, move_speed, start_delay, str_kill_flag )
{
	level endon( "stop_shrimps" );
	
	// Delay before shrimp starts?
	if( IsDefined(start_delay) )
	{
		wait( start_delay );
	}
	
	// Spawn a script origin at the start of the path and move the origin down the path
	e_move = Spawn( "script_model", s_path_start.origin );
	e_move SetModel( "tag_origin" );

	PlayFXOnTag( shrimp_effect, e_move, "tag_origin" );
	
	s_dest_struct = getstruct( s_path_start.target, "targetname" );
	while( IsDefined(s_dest_struct) )
	{
		v_dir = vectornormalize( s_dest_struct.origin - e_move.origin );

		// While travelling to next position
		dist = distance( s_dest_struct.origin, e_move.origin );
		last_dist = dist;
		while( (dist > move_speed) && (dist <= last_dist) )
		{
			// Force shrimp to face camera
			v_fwd = vectornormalize( level.player.origin - e_move.origin );
			v_fwd = AnglesToForward(v_fwd );
			e_move.angles = v_fwd;
			
			// Add speed
			e_move.origin = e_move.origin + ( v_dir * move_speed );
			dist = distance( s_dest_struct.origin, e_move.origin );
			
			// Is the kill flag defined and set?
			if( IsDefined(str_kill_flag) )
			{	
				if( flag(str_kill_flag) )
				{
					e_move delete();
					return;
				}
			}
			
			wait( 0.01 );
		}
		
		// Are we at the end of the path?
		if( !IsDefined(s_dest_struct.target) )
		{
			break;
		}
		
		s_dest_struct = getstruct( s_dest_struct.target, "targetname" );
	}
	
	// Kill the moving shrimp
	e_move delete();
}


