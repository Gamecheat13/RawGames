#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\pel2_util;
#include maps\_vehicle_utility;

/////////////////////////////////
// FUNCTION: main
// CALLED ON: level
// PURPOSE: sets up all breadcrumb arrays and variables
// ADDITIONS NEEDED: None
/////////////////////////////////
main()
{
	level.breadcrumb_ent_array = [];
	level.breadcrumb_delta_array = [];
	level.breadcrumb_curr_index_array = [];
	level.breadcrumb_array = [];
	level.max_breadcrumb_ents = 4;
	level.max_breadcrumb_points = 50;
	/#
	level.debug_breadcrumb_level = -1;
	#/
}

/////////////////////////////////
// FUNCTION: add_new_breadcrumb_ent
// CALLED ON: level
// PURPOSE: Adds a new entity to be tracked by the breadcrumb system. Enforces a the max
//          breadcrumb ents and starts breadcrumb tracking threads
// ADDITIONS NEEDED:
/////////////////////////////////
add_new_breadcrumb_ent( ent, max_lag, max_start_dev, max_dev )
{
	if( !isDefined( max_start_dev ) )
	{
		max_start_dev = 0;
	}
	if( !isDefined( max_dev ) )
	{
		max_dev = 0;
	}
	
	index = -1;
	if( level.breadcrumb_ent_array.size < level.max_breadcrumb_ents )
	{
		index = level.breadcrumb_ent_array.size;
		level.breadcrumb_array = array_add( level.breadcrumb_array, [] );
		level.breadcrumb_ent_array = array_add( level.breadcrumb_ent_array, ent );
		level.breadcrumb_curr_index_array = array_add( level.breadcrumb_curr_index_array, 0 );
		level.breadcrumb_delta_array = array_add( level.breadcrumb_delta_array, max_lag/level.max_breadcrumb_points );
	}
	else
	{
		for( i = 0; i < level.breadcrumb_ent_array.size; i++ )
		{
			if( !isDefined( level.breadcrumb_ent_array[i] ) || level.breadcrumb_ent_array[i] == ent )
			{
				index = i;
				level.breadcrumb_array[index] = [];
				level.breadcrumb_ent_array[index] = ent;
				level.breadcrumb_curr_index_array[index] = 0;
				level.breadcrumb_delta_array[index] = max_lag/level.max_breadcrumb_points;
			}
		}
	}
	if( index == -1 )
	{
		/#
		iprintlnbold( "Trying to make a new breadcrumb ent when limit of "+level.max_breadcrumb_ents+" has already been reached. Remove a breadcrumb entity if you wish to add entity "+ent.classname );
		#/
		return undefined;
	}
	
	for( i = 0; i < level.max_breadcrumb_points; i++ )
	{
		if( max_start_dev != 0 )
		{
			randx = randomintrange( 0-max_start_dev, max_start_dev );
			randy = randomintrange( 0-max_start_dev, max_start_dev );
		}
		else
		{
			randx = 0;
			randy = 0;
		}
		
		random_point = ent.origin + ( randx, randy, 0 ) + (0, 0, 100);
		level.breadcrumb_array[index] = array_add( level.breadcrumb_array[index], random_point );
	}
	
	ent thread update_breadcrumb_trail( index, max_dev );
	/#
	ent thread debug_breadcrumb_trail( index );
	#/
	return level.breadcrumb_delta_array[ index ];
}

debug_breadcrumb_trail( index )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "stop breadcrumbs for "+index );
	color = ( 0, 0, 0 );
	/#
	switch( index )
	{
		case 0:
			color = ( 1, 1, 1 );
			break;
		case 1:
			color = ( 1, 0, 0 );
			break;
		case 2:
		 	color = ( 0, 1, 0 );
		 	break;
		case 3:
			color = ( 0, 0, 1 );
			break;
		case 4:
			color = ( 1, 1, 0 );
			break;
		case 5:
			color = ( 0, 1, 1 );
			break;
		case 6:
			color = ( 1, 0, 1 );
			break;
		default:
			color = ( 0, 0, 0 );
			break;
	}
	
	while( 1 )
	{
		if( (level.debug_breadcrumb_level == index) || level.debug_breadcrumb_level >= level.max_breadcrumb_ents )
		{
			temp_index = level.breadcrumb_curr_index_array[ index ]+1;
			for( i = 0; i < level.max_breadcrumb_points; i++ )
			{
				if( temp_index >= level.max_breadcrumb_points )
				{
					temp_index = 0;
				}
				print3d( level.breadcrumb_array[ index ][ temp_index ]+(0, 0, 20), ""+i, color, 1, 3, 1 );
				temp_index++;
			}
		}
		wait( 0.05 );
	}
	#/
}

/////////////////////////////////
// FUNCTION: remove_breadcrumb_ent
// CALLED ON: level
// PURPOSE: removes and entity from the group being tracked by breadcrumbs in the level. Kills all
//          breadcrumb tracking threads.
// ADDITIONS NEEDED: None
/////////////////////////////////
remove_breadcrumb_ent( ent )
{
	for( i = 0; i < level.breadcrumb_ent_array.size; i++ )
	{
		if( level.breadcrumb_ent_array[i] == ent )
		{
			ent notify( "stop breadcrumbs for "+i );
			level.breadcrumb_array[i] = [];
			level.breadcrumb_ent_array[i] = undefined;
			level.breadcrumb_curr_index_array[i] = 0;
			level.breadcrumb_delta_array[i] = 0;
		}
	}
}

/////////////////////////////////
// FUNCTION: update_breadcrumb_trail
// CALLED ON: breadcrumb entity
// PURPOSE: drops a breadcrumb and indexes it every x seconds
// ADDITIONS NEEDED: None
/////////////////////////////////
update_breadcrumb_trail( index, max_dev ) 
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "stop breadcrumbs for "+index );
	while( 1 )
	{
		wait( level.breadcrumb_delta_array[ index ] );
		if( max_dev != 0 )
		{
			randx = randomintrange( 0-max_dev, max_dev );
			randy = randomintrange( 0-max_dev, max_dev );
		}
		else
		{
			randx = 0;
			randy = 0;
		}
		random_point = ( randx, randy, 0 );
		//level.breadcrumb_array[ index ][ level.breadcrumb_curr_index_array[index] ] = groundpos( self.origin + random_point + (0, 0, 100) );
		level.breadcrumb_array[ index ][ level.breadcrumb_curr_index_array[index] ] = self.origin + random_point;
		level.breadcrumb_curr_index_array[ index ]++;
		if( level.breadcrumb_curr_index_array[ index ] >= level.max_breadcrumb_points )
		{
			level.breadcrumb_curr_index_array[ index ] = 0;
		}
	}
}

/////////////////////////////////
// FUNCTION: get_delayed_position
// CALLED ON: level
// PURPOSE: Returns the breadcrumb closest to x seconds ago for a breadcrumb entity
// ADDITIONS NEEDED: None
/////////////////////////////////
get_delayed_position( ent, delay ) 
{
	for( i = 0; i < level.breadcrumb_ent_array.size; i++ )
	{
		if( level.breadcrumb_ent_array[i] == ent )
		{
			if( delay > ( level.max_breadcrumb_points * level.breadcrumb_delta_array[i] ) ) 
			{
				/#
				iprintlnbold( "entity "+ent.classname+" tried to get a delayed point outside of the delay range "+level.breadcrumb_delta_array[i]+" specified for it in add_breadcrumb_entity" );
				#/
				return (0, 0, 0);
			}
			else
			{
				lag_index = level.breadcrumb_curr_index_array[ i ] - int( delay / level.breadcrumb_delta_array[i] ) - 1; 
				if( lag_index < 0 )
				{
					lag_index = level.max_breadcrumb_points + lag_index;
				}
				assert( lag_index >= 0 && lag_index < level.max_breadcrumb_points );
				return level.breadcrumb_array[ i ][ lag_index ];
			}
		}
	}
	/#
	iprintln( "entity "+ent.classname+" is not a breadcrumb entity!" );
	#/
	return (0, 0, 0);
}