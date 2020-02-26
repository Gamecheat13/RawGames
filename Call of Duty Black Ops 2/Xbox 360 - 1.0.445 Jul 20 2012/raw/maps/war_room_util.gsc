/*
 * Created by ScriptDevelop.
 * User: mslone
 * Date: 3/30/2012
 * Time: 11:54 AM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */

#include common_scripts\utility;
#include maps\_utility;

#insert raw\common_scripts\utility.gsh;

#define HOLO_TABLE_EXPLODER		(111)
#define MAX_TERRITORY_INDEX		(5)
#define CLIENT_FLAG_MAP_MONITOR 13
	
holo_table_system_init()
{
	flag_init( "allow_holo_table_input" );
}

// Rotate forever.
//
holo_table_rotate()
{
	self endon( "stop_holo_table" );
	
	while ( true )
	{		
		// Rotate at that POI for a bit.
		const rotate_time = 60.0;
		self.e_origin RotateYaw( 360, rotate_time, 0, 0 );
		wait rotate_time - 0.1;
	}
}

holo_table_get_selected_struct( str_holo_table )
{
	e_table = level.holo_tables[str_holo_table];
	return e_table.poi_list[e_table.cur_poi_index];
}

// Periodically change POI.
holo_table_run_poi( allow_player_input )
{
	self endon( "stop_holo_table" );
	
	// No options?  No problem.  Don't process it.
	if ( self.poi_list.size <= 1 )
	{
		return;
	}
	
	const use_dist_sq = 128 * 128;
	
	// Move to a different POI.
	if ( allow_player_input )
	{
		while ( true )
		{
			while ( DistanceSquared( level.player.origin, self.e_origin.origin ) > use_dist_sq )
			{
				wait_network_frame();
			}
			
			// while in range
			while ( DistanceSquared( level.player.origin, self.e_origin.origin ) <= use_dist_sq )
			{
				index_change = 0;
				if ( level.player ButtonPressed( "DPAD_LEFT" ) )
				{
					index_change = -1;
				}
				else if ( level.player ButtonPressed( "DPAD_RIGHT" ) )
				{
					index_change = 1;
				}
				
				if ( index_change != 0 && flag( "allow_holo_table_input" ) )
				{
					holo_table_change_poi( index_change, 0.5, true );
				}
				
				wait_network_frame();
			}
		}
	}
	else
	{
		while( true )
		{
			self holo_table_change_poi( 1 );
			wait 24.0;
		}
	}
}

holo_table_run( allow_player_input )
{
	// Cancels previous processes on this table, preventing multiple-input problems.
	self notify( "stop_holo_table" );
	
	const rotate_time = 45.0;
	self.display LinkTo( self.e_origin );
	self thread holo_table_rotate();
	self thread holo_table_run_poi( allow_player_input );
}
/#
holo_table_render_pois()
{	
	self endon( "stop_holo_table" );

	while ( true )
	{
		fvec = AnglesToForward( self.display.angles );
		rvec = AnglesToRight( self.display.angles );
		
		if ( isdefined( self.cur_poi_index ) )
		{
			foreach( s_poi in self.poi_list )
			{
				poi = s_poi.offset;
				world_offset = (rvec * poi[0]) + (fvec * poi[1]);
				world_pos = self.display.origin + world_offset;
				if ( s_poi == self.poi_list[self.cur_poi_index] )
				{
					draw_arrow_time( world_pos, self.display.origin, ( 1, 0, 0 ), 0.1 );
				} else {
					draw_arrow_time( world_pos, self.display.origin, ( 0.5, 0.5, 0.5 ), 0.1 );
				}
			}
		}
		
		wait 0.05;
	}
}
#/
// Blocking function that moves the map to a new position.
//
// n_index_change: the amount we should change the index. (-1 to prev target, 1 to next)
//
holo_table_change_poi( n_index_change, move_time_s = 2.0, display_level_name = false )
{
	// If none is specified, pick the next one.
	if ( !isdefined( self.cur_poi_index ) )
	{
		self.cur_poi_index = 0;
	} else {
		n_index_change = n_index_change % self.poi_list.size;
		self.cur_poi_index = ( self.cur_poi_index + n_index_change + self.poi_list.size ) % self.poi_list.size;
	}
	
	s_poi = self.poi_list[ self.cur_poi_index ];
	v_poi_offset = s_poi.offset;
	
	fvec = AnglesToForward( self.display.angles );
	rvec = AnglesToRight( self.display.angles );
	
	world_offset = (rvec * v_poi_offset[0]) + (fvec * v_poi_offset[1]);
	world_rotate_pos = self.e_origin.origin - world_offset;

	// make sure the origin sits still while we move.
	self.display Unlink();
	
	self.display MoveTo( world_rotate_pos, move_time_s, 0, 0 );
	wait move_time_s + 0.1;
	
	// Relink it to the origin so we can rotate again.
	self.display LinkTo( self.e_origin );
}

holo_table_get_table( str_hologram )
{
	return level.holo_tables[str_hologram];
}

holo_table_initialize( str_hologram, str_map_center_origin )
{
	holo_table = SpawnStruct();
	
	display = GetEnt( str_hologram, "targetname" );
	display.v_start_org = display.origin;
	display.v_start_ang = display.angles;
	display.n_start_scale = 0.1;
	
	holo_table.display = display;
	holo_table.e_origin = GetEnt( str_map_center_origin, "targetname" );
	
	// put them on the same veritcal plane.
	VEC_SET_Z( holo_table.e_origin.origin, display.origin[2] );
	
	// Grab "points of interest."
	holo_table.poi_list = [];
	if ( isdefined( holo_table.e_origin.target ) )
	{
		s_poi_list = GetStructArray( holo_table.e_origin.target );
				
		foreach ( s_poi in s_poi_list )
		{				
			fvec = AnglesToForward( holo_table.display.angles );
			rvec = AnglesToRight( holo_table.display.angles );
			
			// project the offset over the rvec to get the object-relative x offset.
			x_val = VectorDot( s_poi.origin - holo_table.display.origin, rvec );
			
			// project the offset over the fvec to get the object-relative y offset.
			y_val = VectorDot( s_poi.origin - holo_table.display.origin, fvec );
			
			// Put it all together, and wuddya get...
			s_poi.offset = (x_val, y_val, 0);
			
			ArrayInsert( holo_table.poi_list, s_poi, 0 );
		}
	} else {
		// one poi at the center by default.
		holo_table.poi_list[0] = SpawnStruct();
		holo_table.poi_list[0].origin = ( 0, 0, 0 );
	}
	
	if ( !IsDefined( level.holo_tables ) )
	{
		level.holo_tables = [];
	}
	
	level.holo_tables[str_hologram] = holo_table;
	
	return display;
}

holo_table_boot_sequence( allow_player_input )
{
	self.display holo_table_reset_display();
	
	const n_scale_time = 2;
	const n_blinks = 3;
	
	exploder( HOLO_TABLE_EXPLODER ); //-- moved this to frontend_util
	for( i=0; i<n_blinks; i++)
	{
		self.display Show();
		wait(0.1);
		self.display Hide();
		wait(0.1);
	}
	
	self.display Show();
	self.display holo_table_scale_overtime( n_scale_time );
	
	self thread holo_table_run( allow_player_input );
}

// ramps the scale of the holo table display model from zero to one.
//
// n_time: the time in seconds over which to scale the display.
// str_display_name: targetname of the display model
//
holo_table_scale_overtime( n_time, str_display_name = undefined )
{
	model = self;
	if ( isdefined( str_display_name ) )
	{
		model = GetEnt( str_display_name, "targetname" );
	}
	
	model SetScale( self.n_start_scale );
	model Show();
	
	incs = n_time / .05;
	inc_size = (1.0 - self.n_start_scale) / incs;
	
	for( i = 0; i < incs; i++ )
	{
		model.n_cur_scale += inc_size;
		model SetScale( self.n_cur_scale );
		wait(.05);
	}
	
	model SetScale(1.0);
}

// ramps the scale of the holo table display model from one to zero.
//
// n_time: the time in seconds over which to scale the display.
// str_display_name: targetname of the display model
//
holo_table_scale_overtime_reverse( n_time, str_display_name = undefined, hide_after = false )
{
	model = self;
	
	if ( !isdefined( self.n_cur_scale ) )
	{
		return;
	}
	
	if ( self.n_cur_scale <= 0.1 )
	{
		return;
	}
	
	if ( isdefined( str_display_name ) )
	{
		model = GetEnt( str_display_name, "targetname" );
	}
	
	incs = n_time / .05;
	inc_size = (1.0 - self.n_start_scale) / incs;
	
	for( i = 0; i < incs; i++ )
	{
		model.n_cur_scale -= inc_size;
		model SetScale( self.n_cur_scale );
		wait(.05);
	}
		
	model SetScale(self.n_start_scale);
	
	if ( is_true( hide_after ) )
	{
		model Hide();
	}
}

holo_table_reset_display()
{
	self.origin = self.v_start_org;
	self.angles = self.v_start_ang;	
	self.n_cur_scale = self.n_start_scale;
	self SetScale( self.n_start_scale );
	self Hide();
}

set_world_map_tint( territory_index, value )
{
	territory_index = clamp( territory_index, 0, MAX_TERRITORY_INDEX );
	
	rpc( "clientscripts/frontend", "set_world_map_tint", territory_index, value );
}

set_world_map_widget( territory_index, widget_on )
{
	value = 0;
	if ( widget_on )
		value = 1;
	
	territory_index = clamp( territory_index, 0, MAX_TERRITORY_INDEX );
	
	rpc( "clientscripts/frontend", "toggle_world_map_widget", territory_index, value );
}

set_world_map_marker( territory_index, marker_on )
{
	value = 0;
	if ( marker_on )
		value = 1;
	
	territory_index = clamp( territory_index, 0, MAX_TERRITORY_INDEX );
	
	rpc( "clientscripts/frontend", "toggle_world_map_marker", territory_index, value );
}

set_world_map_translation( x, y )
{
	rpc( "clientscripts/frontend", "set_world_map_translation", x, y );
}

set_world_map_rotation( theta )
{
	rpc( "clientscripts/frontend", "set_world_map_rotation", theta );
}

set_world_map_scale( scale )
{
	rpc( "clientscripts/frontend", "set_world_map_scale", scale );
}

set_world_map_icon( icon_index )
{
	icon_index = clamp( icon_index, 0, 6 );
	Rpc( "clientscripts/frontend", "set_world_map_icon", icon_index );
}

refresh_war_maps()
{
	monitor_list = GetEntArray( "world_map", "targetname" );
	
	// Clear the flag so we can re-set it.
	foreach( monitor in monitor_list )
	{
		monitor ClearClientFlag( CLIENT_FLAG_MAP_MONITOR );
	}
	
	wait_network_frame();
	
	foreach( monitor in monitor_list )
	{
		monitor SetClientFlag( CLIENT_FLAG_MAP_MONITOR );
	}
}

/#
randomize_war_map()
{
	while ( true )
	{
		wait 4.0;
		set_world_map_icon( RandomIntRange( 0, 6 ) );
		for ( i = 0; i < 6; i++ )
		{
			toggle = true;
			if ( RandomFloat( 1.0 ) > 0.5 ) 
			{
				toggle = false;
			}
			set_world_map_marker( i, toggle );
			
			toggle = true;
			if ( RandomFloat( 1.0 ) > 0.5 ) 
			{
				toggle = false;
			}
			set_world_map_widget( i, toggle );
			set_world_map_tint( i, RandomIntRange( 0, 6 ) );
		}
		refresh_war_maps();
	}
}
#/

