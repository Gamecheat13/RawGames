/*-----------------------------------------------------------------------------
_fire_direction.csc 

This file handles the shader that's drawn in the world when using fire direction
This feature uses client flag 10

To use this in your map: 
- run clientscripts\_fire_direction::init_fire_direction after clientscripts\_load::main

-----------------------------------------------------------------------------*/
#include clientscripts\_utility;

// PROJECTED_GRID_RADIUS = radius of projeted grid shader as it appears in the world
#define PROJECTED_GRID_RADIUS 240
#define CLIENT_FLAG_OVERLAY 10

// call after _load
init()
{
	// register client flag used for shader
	level.grid_shader_enabled = false; 

	waitforclient(0);
	
	// initialize filter for projected grid
	clientscripts\_filter::init_filter_hud_projected_grid( level.localPlayers[0] );

	register_clientflag_callback( "scriptmover", CLIENT_FLAG_OVERLAY, ::set_shader_position );
	
	// turn grid shader on and off based on notifies from server script
	thread toggle_grid_shader();
}

toggle_grid_shader()
{
	level endon( "_fire_direction_kill" );
	
	while ( true )
	{
		level waittill( "grid_shader_on" );  // sent from server script
		grid_shader_enable();		
		
		level waittill( "grid_shader_off" );  // sent from server script
		grid_shader_disable();
	}
}

grid_shader_enable()
{	
	const FILTER_ID = 0;
	
	clientscripts\_filter::enable_filter_hud_projected_grid( level.localPlayers[0], FILTER_ID );
	clientscripts\_filter::set_filter_hud_projected_grid_radius( level.localPlayers[0], FILTER_ID, PROJECTED_GRID_RADIUS );
	level.grid_shader_enabled = true;
}

grid_shader_disable()
{
	const FILTER_ID = 0;
	
	clientscripts\_filter::disable_filter_hud_projected_grid( level.localPlayers[0], FILTER_ID );
	level.grid_shader_enabled = false;
}

//set shader position in the world
set_shader_position( localClientNum, set, newEnt ) // self = scriptmover
{
	level endon( "_fire_direction_kill" );
	level endon( "save_restore" ); 
	self endon( "entity_shutdown" );

	level.fire_direction_shader_on = true;
	
	while( level.fire_direction_shader_on )
	{
		if ( IsDefined( self ) )
		{
			n_dist = Distance( level.localPlayers[0].origin, self.origin );
			set_filter_hud_projected_grid_position( level.localPlayers[0], 0, n_dist );
		}
		
		wait .01;
	}
}