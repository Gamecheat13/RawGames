#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace array;

/@
@/
function filter( &array, b_keep_keys, func_filter, arg1, arg2, arg3, arg4, arg5  )
{
	a_new = [];
	
	foreach ( key, val in array )
	{
		if ( util::single_func( self, func_filter, val, arg1, arg2, arg3, arg4, arg5 ) )
		{
			if ( IsString( key ) || IsWeapon( key ) )
			{
				// by default, string keys are kept
				if ( isdefined( b_keep_keys ) && !b_keep_keys )
				{
					a_new[ a_new.size ] = val;
				}
				else
				{
					a_new[ key ] = val;
				}
			}
			else
			{
				// by default, int keys are not kept
				if ( ( isdefined( b_keep_keys ) && b_keep_keys ) )
				{
					a_new[ key ] = val;
				}
				else
				{
					a_new[ a_new.size ] = val;
				}
			}
		}
	}
	
	return a_new;
}

/@
@/
function remove_undefined( array, b_keep_keys )
{
	if ( IsDefined( b_keep_keys ) )
	{
	 	ArrayRemoveValue( array, undefined, b_keep_keys );
	}
	else
	{
		ArrayRemoveValue( array, undefined );
	}
	
	return array;
}

function get_touching( &array, b_keep_keys )
{
	return filter( array, b_keep_keys, &IsTouching );
}

/@
"Name: array::remove_index( <array>, <index>, [b_keep_keys]  )"
"Summary: Removes a specified index from an array, returns a new array with the specified index removed."
"Module: Array"
"MandatoryArg: <array> : The array we will remove an index from."
"MandatoryArg: <index> : The index we will remove from the array."
"OptionalArg:  [b_keep_keys] : If true, retain existing keys. If false or undefined, existing keys of original array will be replaced by ints."
"Example: a_new = array::remove_index( array, 3 );"
"SPMP: both"
@/
function remove_index( array, index, b_keep_keys )
{
	a_new = [];
	
	foreach ( key, val in array )
	{
		if( key == index )
		{
			continue;	
		}
		else
		{
			if ( ( isdefined( b_keep_keys ) && b_keep_keys ) )
			{
				a_new[ key ] = val;
			}
			else
			{
				a_new[ a_new.size ] = val;
			}	
		}
	}
	
	return a_new;
}

/@
"Name: array::delete_all( <array> )"
"Summary: Delete all the elements in an array"
"Module: Array"
"MandatoryArg: <array> : The array whose elements to delete."
"Example: array::delete_all( GetAITeamArray( "axis" ) );"
"SPMP: both"
@/
function delete_all( &array, is_struct )
{
	foreach ( ent in array )
	{
		if ( isdefined( ent ) )
		{
			if ( ( isdefined( is_struct ) && is_struct ) )
			{
				ent struct::delete();
			}
			else if ( isdefined( ent.__vtable ) )
			{
				ent notify( "death" );    ent = undefined;	// class
			}
			else
			{
				ent Delete();
			}
		}
	}
}

/@
"Name: array::notify_all( <array>, <notify> )"
"Summary: Sends a notify to every element within the array"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <notify>: the string notify sent to the elements"
"Example: array::notify_all( soldiers, "fire" );"
"SPMP: both"
@/
function notify_all( &array, str_notify )
{
	foreach ( elem in array )
	{
		elem notify( str_notify );
	}
}

/@
"Name: thread_all( <entities>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Threads the < func > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: entities : array of entities to thread the function"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1: parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: array::thread_all( GetAITeamArray( "allies" ), &set_ignoreme, false );"
"SPMP: both"
@/
function thread_all( &entities, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	Assert( isdefined( entities ), "Undefined entity array passed to array::thread_all" );
	Assert( isdefined( func ), "Undefined function passed to array::thread_all" );

	if ( IsArray( entities ) )
	{
		if ( isdefined( arg6 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
			}
		}
		else if ( isdefined( arg5 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4, arg5 );
			}
		}
		else if ( isdefined( arg4 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4 );
			}
		}
		else if ( isdefined( arg3 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3 );
			}
		}
		else if ( isdefined( arg2 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2 );
			}
		}
		else if ( isdefined( arg1 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1 );
			}
		}
		else
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]();
			}
		}
	}
	else
	{
		util::single_thread( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 );
	}
}

/@
"Name: thread_all_ents( <entities>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5] )"
"Summary: Threads the <func> function on self for every entity in the <entities> array, passing the entity has the first argument."
"Module: Array"
"CallOn: NA"
"MandatoryArg: entities : array of entities to thread the function"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func (after the entity)"
"OptionalArg: arg2 : parameter 2 to pass to the func (after the entity)"
"OptionalArg: arg3 : parameter 3 to pass to the func (after the entity)"
"OptionalArg: arg4 : parameter 4 to pass to the func (after the entity)"
"OptionalArg: arg5 : parameter 5 to pass to the func (after the entity)"
"Example: array::thread_all_ents( GetAITeamArray( "allies" ), &do_something, false );"
"SPMP: both"
@/
function thread_all_ents( &entities, func, arg1, arg2, arg3, arg4, arg5 )
{
	Assert( isdefined( entities ), "Undefined entity array passed to util::array_ent_thread" );
	Assert( isdefined( func ), "Undefined function passed to util::array_ent_thread" );
	
	if ( IsArray( entities ) )
	{
		if ( entities.size )
		{
			keys = GetArrayKeys( entities );
			for ( i = 0; i < keys.size; i++ )
			{
				util::single_thread( self, func, entities[keys[i]], arg1, arg2, arg3, arg4, arg5 );
			}
		}
	}
	else
	{
		util::single_thread( self, func, entities, arg1, arg2, arg3, arg4, arg5 );
	}
}

/@
"Name: run_all( <entities>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Runs the < func > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: entities : array of entities to run the function"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1: parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: array::run_all( GetAITeamArray( "allies" ), &set_ignoreme, false );"
"SPMP: both"
@/
function run_all( &entities, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	Assert( isdefined( entities ), "Undefined entity array passed to array::run_all" );
	Assert( isdefined( func ), "Undefined function passed to array::run_all" );

	if ( IsArray( entities ) )
	{
		if ( isdefined( arg6 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
			}
		}
		else if ( isdefined( arg5 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1, arg2, arg3, arg4, arg5 );
			}
		}
		else if ( isdefined( arg4 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1, arg2, arg3, arg4 );
			}
		}
		else if ( isdefined( arg3 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1, arg2, arg3 );
			}
		}
		else if ( isdefined( arg2 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1, arg2 );
			}
		}
		else if ( isdefined( arg1 ) )
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]( arg1 );
			}
		}
		else
		{
			foreach ( ent in entities )
			{
				ent [[ func ]]();
			}
		}
	}
	else
	{
		util::single_func( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 );
	}
}

/@
"Name: array::exclude( <array> , <array_exclude> )"
"Summary: Returns an array excluding all members of < array_exclude > "
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array containing all items"
"MandatoryArg: <array_exclude> : Array containing all items to remove or individual entity"
"Example: newArray = array::exclude( array1, array2 );"
"SPMP: both"
@/
function exclude( array, array_exclude )// returns "array" minus all members of array_exclude
{
	newarray = array;
	
	if ( IsArray( array_exclude ) )
	{
		for ( i = 0; i < array_exclude.size; i++ )
		{
			ArrayRemoveValue( newarray, array_exclude[ i ] );
		}
	}
	else
	{
		ArrayRemoveValue( newarray, array_exclude );
	}
  
	return newarray;
}

/@
"Name: array::add( <array> , <item>, <allow_dupes> )"
"Summary: Adds <item> to <array>.  Will not add the new value if undefined."
"Module: Array"
"MandatoryArg:	<array> The array to add <item> to."
"MandatoryArg:	<item> The item to be added. This can be anything."
"OptionalArg:	<allow_dupes> If true, will add the new value if it already exists."
"Example: array::add( nodes, new_node );"
"SPMP: both"
@/
function add( &array, item, allow_dupes = true )
{
	if ( isdefined( item ) )
	{
		if ( allow_dupes || !IsInArray( array, item ) )
		{
			array[ array.size ] = item;
		}
	}

	return array;
}

/@
"Name: array::add_sorted( <array> , <item>, <allow_dupes> )"
"Summary: Adds <item> to <array> in sorted order from smallest to biggest.  Will not add the new value if undefined."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to add <item> to."
"MandatoryArg:	<item> The item to be added. This can be anything."
"OptionalArg:	<allow_dupes> If true, will add the new value if it already exists."
"Example: array::add_sorted( a_numbers, 4 );"
"SPMP: both"
@/
function add_sorted( &array, item, allow_dupes = true )
{
	if ( isdefined( item ) )
	{
		if ( allow_dupes || !IsInArray( array, item ) )
		{
			for ( i = 0; i <= array.size; i++ )
			{
				if ( ( i == array.size ) || ( item <= array[i] ) )
				{
					ArrayInsert( array, item, i );
					break;
				}
			}
		}
	}
}

/@
"Name: array::wait_till( <array>, <msg>, <n_timeout> )"
"Summary: waits for every entry in the <array> to recieve the <msg> notify, die, or n_timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <n_timeout>: n_timeout to kill the wait prematurely"
"Example: array::wait_till( guys, "at the hq" );"
"SPMP: both"
@/
function wait_till( &array, msg, n_timeout )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	
	s_tracker = SpawnStruct();
	s_tracker._array_wait_count = 0;
	
	foreach ( ent in array )
	{
		if ( isdefined( ent ) )
		{
			s_tracker._array_wait_count++;
			ent thread util::timeout( n_timeout, &_waitlogic, s_tracker, msg );
		}
	}
	
	if ( s_tracker._array_wait_count > 0 )
	{
		s_tracker waittill( "array_wait" );
	}
}

function _waitlogic( s_tracker, msg )
{
	self util::waittill_any( "death", msg );
	
	s_tracker._array_wait_count--;
	if ( s_tracker._array_wait_count == 0 )
	{
		s_tracker notify( "array_wait" );
	}
}

/@
@/
function flag_wait( &array, str_flag )
{
	for ( i = 0; i < array.size; i++ )
	{
		ent = array[i];		
		if ( !ent flag::get( str_flag ) )
		{
			ent waittill( str_flag );
			i = -1;
		}
	}
}

/@
@/
function flagsys_wait( &array, str_flag )
{
	for ( i = 0; i < array.size; i++ )
	{
		ent = array[i];		
		if ( !ent flagsys::get( str_flag ) )
		{
			ent waittill( str_flag );
			i = -1;
		}
	}
}

/@
@/
function flagsys_wait_any_flag( &array, ... )
{
	for ( i = 0; i < array.size; i++ )
	{
		ent = array[i];

		if ( isdefined( ent ) )
		{
			b_flag_set = false;
			foreach ( str_flag in vararg )
			{
				if ( ent flagsys::get( str_flag ) )
				{
					b_flag_set = true;
					break;					
				}
			}
			
			if ( !b_flag_set )
			{			
				ent util::waittill_any_array( vararg );
				i = -1;
			}
		}
	}
}

/@
@/
function flag_wait_clear( &array, str_flag )
{
	for ( i = 0; i < array.size; i++ )
	{
		ent = array[i];		
		if ( ent flag::get( str_flag ) )
		{
			ent waittill( str_flag );
			i = -1;
		}
	}
}

/@
@/
function flagsys_wait_clear( &array, str_flag )
{
	for ( i = 0; i < array.size; i++ )
	{
		ent = array[i];		
		if ( ent flagsys::get( str_flag ) )
		{
			ent waittill( str_flag );
			i = -1;
		}
	}
}

/@
"Name: wait_any( <array>, <msg>, <n_timeout> )"
"Summary: waits for any entry in the <array> to recieve the <msg> notify, die, or n_timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <n_timeout>: n_timeout to kill the wait prematurely"
"Example: array_wait_any( guys, "at the hq" );"
"SPMP: both"
@/
function wait_any( array, msg, n_timeout )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	
	s_tracker = SpawnStruct();

	a_structs = [];
	foreach ( ent in array )
	{
		if ( isdefined( ent ) )
		{
			s = SpawnStruct();
			s thread util::timeout( n_timeout, &_waitlogic2, s_tracker, ent, msg );
			if ( !isdefined( a_structs ) ) a_structs = []; else if ( !IsArray( a_structs ) ) a_structs = array( a_structs ); a_structs[a_structs.size]=s;;
		}
	}
	
	s_tracker endon( "array_wait" );
		
	wait_till( array, "death" );
}

function _waitlogic2( s_tracker, ent, msg )
{
	s_tracker endon( "array_wait" );
	ent endon( "death" );
	
	ent waittill( msg );
	s_tracker notify( "array_wait" );
}

function flag_wait_any( array, str_flag )
{
	self endon( "death" );
	
	foreach ( ent in array )
	{
		if ( ent flag::get( str_flag ) )
		{
			return ent;
		}
	}

	wait_any( array, str_flag );
}

/@
"Name: random( <array> )"
"Summary: returns a random element from the passed in array "
"Module: Array"
"Example: random_spawner = random( event_1_spawners );"
"MandatoryArg: <array> : the array from which to pluck a random element"
"SPMP: both"
@/
function random( array )
{
	keys = GetArrayKeys( array );
	return array[ keys[RandomInt( keys.size )] ];
}

/@
@/
function randomize( array )
{
	for ( i = 0; i < array.size; i++ )
	{
		j = RandomInt( array.size );
		temp = array[ i ];
		array[ i ] = array[ j ];
		array[ j ] = temp;
	}

	return array;
}

/@
"Name: array::reverse( <array> )"
"Summary: Reverses the order of the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be reversed."
"Example: patrol_nodes = array::reverse( patrol_nodes );"
"SPMP: both"
@/
function reverse( array )
{
	a_array2 = [];
	for ( i = array.size - 1; i >= 0; i-- )
	{
		a_array2[ a_array2.size ] = array[ i ];
	}

	return a_array2;
}

/@
@/
function remove_keys( array )
{
	a_new = [];
	
	foreach ( _, val in array )
	{
		if ( isdefined( val ) )
		{
			a_new[ a_new.size ] = val;
		}
	}
	
	return a_new;
}

/@
@/
function swap( &array, index1, index2 )
{
	assert( index1 < array.size, "index1 to swap out of range" );
	assert( index2 < array.size, "index2 to swap out of range" );

	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;
}

function pop( &array, index, b_keep_keys = true )
{
	if ( array.size > 0 )
	{
		if ( !isdefined( index ) )
		{
			keys = GetArrayKeys( array );
			index = keys[ 0 ];
		}
		
		if ( isdefined( array[index] ) )
		{
			ret = array[ index ];
			
			ArrayRemoveIndex( array, index, b_keep_keys );
			
			return ret;
		}	
	}
}

function pop_front( &array, b_keep_keys = true )
{
	keys = GetArrayKeys( array );
	index = keys[ keys.size - 1 ];
	return pop( array, index, b_keep_keys );
}

function push( &array, val, index )
{
	if ( !isdefined( index ) )
	{
		// use max free integer as index
		index = 0;
		foreach ( key in GetArrayKeys( array ) )
		{
			if ( IsInt( key ) && ( key >= index ) )
			{
				index = key + 1;
			}
		}
	}
	
	ArrayInsert( array, val, index );
}

function push_front( &array, val )
{
	push( array, val, 0 );
}

/@
"Name: get_closest( <org> , <array> , <dist> )"
"Summary: Returns the closest entity in < array > to location < org > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Minimum distance to check"
"Example: friendly = util::get_closest( GetPlayers( localclientnum )[0].origin, allies );"
"SPMP: singleplayer"
@/
function get_closest( org, &array, dist = undefined)
{
	assert( 0, "Deprecated function. Use 'ArrayGetClosest' instead." );
}

/@
"Name: getFarthest( <org> , <array> , <dist> )"
"Summary: Returns the farthest entity in < array > to location < org > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be farthest from."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Maximum distance to check"
"Example: target = getFarthest( level.player.origin, targets );"
"SPMP: singleplayer"
@/ 
function get_farthest( org, &array, dist = undefined )
{
	assert( 0, "Deprecated function. Use 'ArrayGetFarthest' instead." );
}

function closerFunc( dist1, dist2 )
{
	return dist1 >= dist2;
}

function fartherFunc( dist1, dist2 )
{
	return dist1 <= dist2;
}

/@
"Name: get_all_farthest( <org> , <array> , <excluders> , <max> )"
"Summary: Returns an array of all the entities in < array > sorted in order of farthest to closest."
"MandatoryArg: <org> : Origin to be farthest from."
"MandatoryArg: <array> : Array of entities (anything that contain .origin) to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"Example: allies_sort = get_all_farthest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/
function get_all_farthest( org, &array, excluders, max )
{
	sorted_array = get_closest( org, array, excluders );
	
	if(isdefined( max ))
	{
		temp_array = [];
		for( i=0; i < sorted_array.size; i++)
		{
			temp_array[temp_array.size] = sorted_array[sorted_array.size - i];
		}
		sorted_array = temp_array;
	}
	
	sorted_array = array::reverse( sorted_array );
		
	return( sorted_array );
}

/@
"Name: get_all_closest( <org> , <array> , <excluders> , <max>, <maxdist> )"
"Summary: Returns an array of all the entities in < array > sorted in order of closest to farthest."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"OptionalArg: <maxdist> : Max distance from the origin to return acceptable entities"
"Example: allies_sort = get_all_closest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/ 
function get_all_closest( org, &array, excluders, max, maxdist )
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	if( !isdefined( max ) )
		max = array.size; 
	if( !isdefined( excluders ) )
		excluders = [];
	
	maxdists2rd = undefined;
	if( isdefined( maxdist ) )
		maxdists2rd = maxdist * maxdist;
		
	// return the array, reordered from closest to farthest
	dist = []; 
	index = []; 
	for( i = 0;i < array.size;i ++ )
	{
		if(!isdefined(array[i]))
			continue;
		
		excluded = false; 
		for( p = 0;p < excluders.size;p ++ )
		{
			if( array[ i ] != excluders[ p ] )
				continue; 
			excluded = true; 
			break; 
		}
		if( excluded )
			continue; 
			
		length = distancesquared( org, array[ i ].origin );
		
		if( isdefined( maxdists2rd ) && maxdists2rd < length )
			continue;
			
		dist[ dist.size ] = length;
		
		
		index[ index.size ] = i;
	}
		
	for( ;; )
	{
		change = false; 
		for( i = 0;i < dist.size - 1;i ++ )
			{
			if( dist[ i ] <= dist[ i + 1 ] )
				continue; 
			change = true; 
			temp = dist[ i ];
			dist[ i ] = dist[ i + 1 ];
			dist[ i + 1 ] = temp;
			temp = index[ i ];
			index[ i ] = index[ i + 1 ];
			index[ i + 1 ] = temp;
		}
		if( !change )
			break; 
		}
	
	newArray = []; 
	if( max > dist.size )
		max = dist.size; 
	for( i = 0;i < max;i ++ )
		newArray[ i ] = array[ index[ i ] ];
	return newArray; 
}

function alphabetize( &array )
{
	return sort_by_value( array, true );
}

/@
function Name: sort_by_value( array, b_lowest_first = true )
Summary: sorts a list of ents by their value
Module: Utility
CallOn: n/a
ManditoryArg: <array>: array of values to sort
OptionalArg: [b_lowest_first]: sort from lowest to highest
function Example: list = array::sort_by_value( array );
SPMP: singleplayer
@/
//Use ArraySort for distance based sorting of entities
function sort_by_value( &array, b_lowest_first = false )
{
	return merge_sort( array, &_sort_by_value_compare_func, b_lowest_first );
}

function _sort_by_value_compare_func( val1, val2, b_lowest_first )
{
	if ( b_lowest_first )
	{
		return val1 < val2;
	}
	else
	{
		return val1 > val2;
	}
}

/@
function Name: sort_by_script_int( a_ents, b_lowest_first = true )
Summary: sorts a list of ents by their script_int value
Module: Utility
CallOn: n/a
ManditoryArg: <a_ents>: array of entities to sort
OptionalArg: [b_lowest_first]: sort from lowest to highest
function Example: list = array::sort_by_script_int( a_ents );
SPMP: singleplayer
@/
//Use ArraySort for distance based sorting of entities
function sort_by_script_int( &a_ents, b_lowest_first = false )
{
	return merge_sort( a_ents, &_sort_by_script_int_compare_func, b_lowest_first );
}

function _sort_by_script_int_compare_func( e1, e2, b_lowest_first )
{
	if ( b_lowest_first )
	{
		return e1.script_int < e2.script_int;
	}
	else
	{
		return e1.script_int > e2.script_int;
	}
}

function merge_sort( &current_list, func_sort, param )
{
	if ( current_list.size <= 1 )
	{
		return current_list;
	}
		
	left = [];
	right = [];
	
	middle = current_list.size / 2;
	
	for ( x = 0; x < middle; x++ )
	{
		if ( !isdefined( left ) ) left = []; else if ( !IsArray( left ) ) left = array( left ); left[left.size]=current_list[ x ];;
	}
	
	for ( ; x < current_list.size; x++ )
	{
		if ( !isdefined( right ) ) right = []; else if ( !IsArray( right ) ) right = array( right ); right[right.size]=current_list[ x ];;
	}
	
	left = merge_sort( left, func_sort, param );
	right = merge_sort( right, func_sort, param );
	
	result = merge( left, right, func_sort, param );

	return result;
}

function merge( left, right, func_sort, param )
{
	result = [];

	li = 0;
	ri = 0;
	while ( li < left.size && ri < right.size )
	{
		b_result = undefined;
		
		if ( isdefined( param ) )
		{
			b_result = [[ func_sort ]]( left[ li ], right[ ri ], param );
		}
		else
		{
			b_result = [[ func_sort ]]( left[ li ], right[ ri ] );
		}
		
		if ( b_result )
		{
			result[ result.size ] = left[ li ];
			li++;
		}
		else
		{
			result[ result.size ] = right[ ri ];
			ri++;
		}
	}

	while ( li < left.size )
	{
		result[ result.size ] = left[ li ];
		li++;
	}

	while ( ri < right.size )
	{
		result[ result.size ] = right[ ri ];
		ri++;
	}

	return result;
}

/@
"Name: spread_all( <entities> , <process> , <var1> , <var2> , <var3> )"
"Summary: Threads the < process > function on every entity in the < entities > array. Each thread is started 1 network frame apart from the next."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <process> : pointer to a script function"
"OptionalArg: <var1> : parameter 1 to pass to the process"
"OptionalArg: <var2> : parameter 2 to pass to the process"
"OptionalArg: <var3> : parameter 3 to pass to the process"
"Example: array::spread_all( GetAITeamArray( "allies" ),&set_ignoreme, false );"
"SPMP: Both"
@/

function spread_all( &entities, func, arg1, arg2, arg3, arg4, arg5 )
{
	Assert( isdefined( entities ), "Undefined entity array passed to array::spread_all_ents" );
	Assert( isdefined( func ), "Undefined function passed to array::spread_all_ents" );
	
	if ( IsArray( entities ) )
	{
		foreach ( ent in entities )
		{
			util::single_thread( ent, func, arg1, arg2, arg3, arg4, arg5 );
			wait randomfloatrange(.1-.1/3,.1+.1/3);
		}
	}
	else
	{
		util::single_thread( entities, func, arg1, arg2, arg3, arg4, arg5 );
		wait randomfloatrange(.1-.1/3,.1+.1/3);
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
