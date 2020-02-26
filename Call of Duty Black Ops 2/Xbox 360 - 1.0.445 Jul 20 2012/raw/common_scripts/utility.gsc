/*
	utility.gsc
		
	This is a utility script common to all game modes. Don't add anything with calls to game type
	specific script API calls.
*/

#insert raw\common_scripts\utility.gsh;

init_session_mode_flags()
{
	// should stay the same as eGameModes in com_gamemodes.h
	level.GAMEMODE_PUBLIC_MATCH			= 0;
	level.GAMEMODE_PRIVATE_MATCH		= 1;
	level.GAMEMODE_LOCAL_SPLITSCREEN	= 2;
	level.GAMEMODE_WAGER_MATCH			= 3;
	level.GAMEMODE_BASIC_TRAINING		= 4;
	level.GAMEMODE_THEATER				= 5;
	level.GAMEMODE_LEAGUE_MATCH			= 6;
	level.GAMEMODE_RTS					= 7;
}

/@
"Name: empty( <a>, <b>, <c>, <d>, <e> )"
"Summary: Empty function mainly used as a place holder or default function pointer in a system."
"Module: Utility"
"CallOn: "
"OptionalArg: <a> : option arg"
"OptionalArg: <b> : option arg"
"OptionalArg: <c> : option arg"
"OptionalArg: <d> : option arg"
"OptionalArg: <e> : option arg"
"Example: default_callback = ::empty;"
"SPMP: both"
@/
empty(a, b, c, d, e)
{
}

// ----------------------------------------------------------------------------------------------------
// -- Arrays ------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------

/@
"Name: add_to_array( <array> , <item>, <allow_dupes> )"
"Summary: Adds <item> to <array> and returns the new array.  Will not add the new value if undefined."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to add <item> to."
"MandatoryArg:	<item> The item to be added. This can be anything."
"OptionalArg:	<allow_dupes> If true, will add the new value if it already exists."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: both"
@/
add_to_array( array, item, allow_dupes )
{
	if( !IsDefined( item ) )
	{
		return array;
	}

	if (!IsDefined(allow_dupes))
	{
		allow_dupes = true;
	}

	if( !IsDefined( array ) )
	{
		array[ 0 ] = item;
	}
	else if (allow_dupes || !IsInArray(array, item))
	{
		array[ array.size ] = item;
	}

	return array;
}

/@
"Name: array_copy( <array> )"
"Summary: Returns a copy of an array."
"Module: Array"
"CallOn: "
"MandatoryArg:	<array> The array to copy."
"Example: a_nodes_copy = array_copy( a_nodes );"
"SPMP: both"
@/
array_copy( array )
{
	a_copy = [];
	foreach ( elem in array )
	{
		ARRAY_ADD( a_copy, elem );
	}	
	return a_copy;
}

/@
"Name: array_delete( <array> )"
"Summary: Delete all the elements in an array"
"Module: Array"
"MandatoryArg: <array> : The array whose elements to delete."
"Example: array_delete( GetAIArray( "axis" ) );"
"SPMP: both"
@/
array_delete( array, is_struct )
{
	foreach ( ent in array )
	{
		if ( IS_TRUE( is_struct ) )
		{
			ent structdelete();
			ent = undefined;
		}
		else if ( IsDefined( ent ) )
		{
			ent Delete();
		}
	}
}

/@
"Name: array_randomize( <array> )"
"Summary: Randomizes the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be randomized."
"Example: roof_nodes = array_randomize( roof_nodes );"
"SPMP: both"
@/
array_randomize( array )
{
	for( i = 0; i < array.size; i++ )
	{
		j = RandomInt( array.size );
		temp = array[ i ];
		array[ i ] = array[ j ];
		array[ j ] = temp;
	}

	return array;
}

/@
"Name: array_reverse( <array> )"
"Summary: Reverses the order of the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array to be reversed."
"Example: patrol_nodes = array_reverse( patrol_nodes );"
"SPMP: both"
@/
array_reverse( array )
{
	array2 = [];
	for( i = array.size - 1; i >= 0; i-- )
	{
		array2[ array2.size ] = array[ i ];
	}

	return array2;
}


/@
"Name: array_exclude( <array> , <arrayExclude> )"
"Summary: Returns an array excluding all members of < arrayExclude > "
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : Array containing all items"
"MandatoryArg: <arrayExclude> : Array containing all items to remove or individual entity"
"Example: newArray = array_exclude( array1, array2 );"
"SPMP: both"
@/
array_exclude( array, arrayExclude )// returns "array" minus all members of arrayExclude
{
	newarray = array;
	
	if( IsArray( arrayExclude ) )
	{
		for( i = 0;i < arrayExclude.size;i++ )
		{
			ArrayRemoveValue( newarray, arrayExclude[ i ] );
		}
	}
	else
	{
		ArrayRemoveValue( newarray, arrayExclude );
	}
  
	return newarray;
}

/@
"Name: array_notify( <array>, <notify> )"
"Summary: Sends a notify to every element within the array"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <notify>: the string notify sent to the elements"
"Example: array_notify( soldiers, "fire" );"
"SPMP: both"
@/
array_notify( ents, notifier )
{
	for( i = 0;i < ents.size;i++ )
	{
		ents[ i ] notify( notifier );
	}
}

/@
"Name: array_wait( <array>, <msg>, <timeout> )"
"Summary: waits for every entry in the <array> to recieve the <msg> notify, die, or timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <timeout>: timeout to kill the wait prematurely"
"Example: array_wait( guys, "at the hq" );"
"SPMP: both"
@/
array_wait( array, msg, timeout )
{
	keys = GetArrayKeys( array );
	structs = [];

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		structs[ key ] = SpawnStruct();
		structs[ key ]._array_wait = true;

		structs[ key ] thread array_waitlogic1( array[ key ], msg, timeout );
	}

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		if( IsDefined( array[ key ] ) && structs[ key ]._array_wait)
		{
			structs[ key ] waittill( "_array_wait" );
		}
	}
}

/@
"Name: array_wait_any( <array>, <msg>, <timeout> )"
"Summary: waits for any entry in the <array> to recieve the <msg> notify, die, or timeout"
"Module: Utility"
"MandatoryArg: <array>: the array of entities to wait on"
"MandatoryArg: <msg>: the msg each array entity will wait on"
"OptionalArg: <timeout>: timeout to kill the wait prematurely"
"Example: array_wait_any( guys, "at the hq" );"
"SPMP: both"
@/
array_wait_any(array, msg, timeout)
{
	if (array.size == 0)
	{
		return undefined;
	}

	keys = GetArrayKeys(array);
	structs = [];

	internal_msg = msg + "array_wait";

	for (i = 0; i < keys.size; i++)
	{
		key = keys[i];
		structs[ key ] = SpawnStruct();
		structs[ key ]._array_wait = true;
		structs[ key ] thread array_waitlogic3( array[ key ], msg, internal_msg, timeout );
	}

	level waittill(internal_msg, ent);

	return ent;
}

array_waitlogic1( ent, msg, timeout )
{
	self array_waitlogic2( ent, msg, timeout );

	self._array_wait = false;
	self notify( "_array_wait" );
}

array_waitlogic2( ent, msg, timeout )
{
	ent endon( msg );
	ent endon( "death" );

	if( IsDefined( timeout ) )
	{
		wait timeout;
	}
	else
	{
		ent waittill( msg );
	}
}

array_waitlogic3(ent, msg, internal_msg, timeout) // self = struct
{
	//GLocke 3.21.2010 Special case if waiting on "death"
	if(msg !="death")
	{
		ent endon("death");
	}
	level endon(internal_msg);
	
	self array_waitlogic2(ent, msg, timeout);
	level notify(internal_msg, ent);
}

// MikeD (3/20/2007): Checks the array if the "single" already exists, if so it returns false.
array_check_for_dupes( array, single )
{
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
}

// Lucas (5/22/2008) added an array_swap for easy quicksorting
array_swap( array, index1, index2 )
{
	assert( index1 < array.size, "index1 to swap out of range" );
	assert( index2 < array.size, "index2 to swap out of range" );

	temp = array[index1];
	array[index1] = array[index2];
	array[index2] = temp;

	return array;
}

/@
"Name: array_average( <array> )"
"Summary: Given an array of numbers, returns the average (mean) value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers which will be averaged"
"Example: array_average( numbers );"
"SPMP: both"
@/
array_average( array )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	total = 0;

	for ( i = 0; i < array.size; i++ )
	{
		total += array[i];
	}

	return ( total / array.size );
}

/@
"Name: array_std_deviation( <array>, <mean> )"
"Summary: Given an array of numbers and the average of the array, returns the standard deviation value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers"
"MandatoryArg: <mean>: the average (mean) value of the array"
"Example: array_std_deviation( numbers, avg );"
"SPMP: both"
@/
array_std_deviation( array, mean )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	tmp = [];
	for ( i = 0; i < array.size; i++ )
	{
		tmp[i] = ( array[i] - mean ) * ( array[i] - mean );
	}

	total = 0;
	for ( i = 0; i < tmp.size; i++ )
	{
		total = total + tmp[i];
	}

	return Sqrt( total / array.size );
}

/@
"Name: random_normal_distribution( <mean>, <std_deviation>, <lower_bound>, <upper_bound> )"
"Summary: Given the mean and std deviation of a set of numbers, returns a random number from the normal distribution"
"Module: Utility"
"MandatoryArg: <mean>: the average (mean) value of the array"
"MandatoryArg: <std_deviation>: the standard deviation value of the array"
"OptionalArg: <lower_bound> the minimum value that will be returned"
"OptionalArg: <upper_bound> the maximum value that will be returned"
"Example: random_normal_distribution( avg, std_deviation );"
"SPMP: both"
@/
random_normal_distribution( mean, std_deviation, lower_bound, upper_bound )
{
	//pixbeginevent( "random_normal_distribution" );

	// implements the Box-Muller transform for Gaussian random numbers (http://en.wikipedia.org/wiki/Box-Muller_transform)
	x1 = 0;
	x2 = 0;
	w = 1;
	y1 = 0;

	while ( w >= 1 )
	{
		x1 = 2 * RandomFloatRange( 0, 1 ) - 1;
		x2 = 2 * RandomFloatRange( 0, 1 ) - 1;
		w = x1 * x1 + x2 * x2;
	}

	w = Sqrt( ( -2.0 * Log( w ) ) / w );
	y1 = x1 * w;

	number = mean + y1 * std_deviation;

	if ( IsDefined( lower_bound ) && number < lower_bound )
	{
		number = lower_bound;
	}

	if ( IsDefined( upper_bound ) && number > upper_bound )
	{
		number = upper_bound;
	}

	//pixendevent();

	return( number );
}

/@
"Name: random( <array> )"
"Summary: returns a random element from the passed in array "
"Module: Array"
"Example: random_spawner = random( event_1_spawners );"
"MandatoryArg: <array> : the array from which to pluck a random element"
"SPMP: both"
@/
random( array )
{
	keys = GetArrayKeys( array );
	return array[ keys[RandomInt( keys.size )] ];
}

/@
"Name: get_players( [str_team] )"
"Summary: Returns all of the players currently in the level"
"Module: Player"
"Example: a_players = get_players();"
"SPMP: singleplayer"
@/
get_players( str_team )
{
	if ( IsDefined( str_team ) )
	{
		return GetPlayers( str_team );
	}
	else
	{
		return GetPlayers();
	}
}

// ----------------------------------------------------------------------------------------------------
// -- Strings -----------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------

/@
"Name: is_prefix( <string>, <prefix> )"
"Summary: Check if a string has the specified prefix."
"Module: String"
"CallOn: "
"MandatoryArg: <string> : The string to check."
"MandatoryArg: <prefix> : The prefix."
"Example: is_prefix( "hq_cleared", "hq_" ); // true"
"SPMP: both"
@/
is_prefix( msg, prefix )
{
	if ( prefix.size > msg.size )
	{
		return false;
	}
	
	for ( i = 0; i < prefix.size; i++ )
	{
		if ( msg[ i ] != prefix[ i ] )
		{
			return false;
		}
	}

	return true;
}

/@
"Name: is_suffix( <string>, <suffix> )"
"Summary: Check if a string has the specified suffix."
"Module: String"
"CallOn: "
"MandatoryArg: <string> : The string to check."
"MandatoryArg: <suffix> : The suffix."
"Example: is_suffix( "hq_cleared", "_cleared" ); // true"
"SPMP: both"
@/
is_suffix( msg, suffix )
{
	if ( suffix.size > msg.size )
	{
		return false;
	}
	
	for ( i = 0; i < suffix.size; i++ )
	{
		if ( msg[ (msg.size - 1) - i ] != suffix[ (suffix.size - 1) - i ] )
		{
			return false;
		}
	}

	return true;
}

// ----------------------------------------------------------------------------------------------------
// -- Vectors -----------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------

/@
"Name: vector_compare( <vec1>, <vec2> )"
"Summary: For 3D vectors.  Returns true if the vectors are the same"
"MandatoryArg: <vec1> : A 3D vector (origin)"
"MandatoryArg: <vec2> : A 3D vector (origin)"
"Example: if (vector_compare(self.origin, node.origin){print(\"yay, i'm on the node!\");}"
"SPMP: both"
@/
vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0]) < .001) && (abs(vec1[1] - vec2[1]) < .001) && (abs(vec1[2] - vec2[2]) < .001);
}

//-- Other / Unsorted --//
/#
draw_debug_line(start, end, timer)
{
	for (i=0;i<timer*20;i++)
	{
		line (start, end, (1,1,0.5));
		wait (0.05);
	}
}
#/
	
waittillend(msg)
{
	self waittillmatch (msg, "end");
}

random_vector(max_length)
{
	return (RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length));
}

angle_dif(oldangle, newangle)
{
    outvalue=(oldangle-newangle)%360;
     if (outvalue<0)
          outvalue+=360;
     if (outvalue>180)
          outvalue=(outvalue-360)*-1;
     return outvalue;
}

sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
}


track(spot_to_track)
{
	if(IsDefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
			return;
	}
	self.current_target = spot_to_track;
}

clear_exception( type )
{
	assert( IsDefined( self.exception[ type ] ) );
	self.exception[ type ] = anim.defaultException;
}

set_exception( type, func )
{
	assert( IsDefined( self.exception[ type ] ) );
	self.exception[ type ] = func;
}

set_all_exceptions( exceptionFunc )
{
	keys = getArrayKeys( self.exception );
	for ( i=0; i < keys.size; i++ )
	{
		self.exception[ keys[ i ] ] = exceptionFunc;
	}
}

cointoss()
{
	return RandomInt( 100 ) >= 50 ;
}


waittill_string( msg, ent )
{
	if ( msg != "death" )
	{
		self endon ("death");
	}
		
	ent endon( "die" );
	self waittill( msg );
	ent notify( "returned", msg );
}

/@
"Name: waittill_multiple( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for all of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_multiple( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if (IsDefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (IsDefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (IsDefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (IsDefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (IsDefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/@
"Name: waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for all of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_multiple_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
@/
waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if ( IsDefined( ent1 ) )
	{
		assert( IsDefined( string1 ) );
		ent1 thread waittill_string( string1, ent );
		ent.threads++;
	}
	if ( IsDefined( ent2 ) )
	{
		assert( IsDefined( string2 ) );
		ent2 thread waittill_string ( string2, ent );
		ent.threads++;
	}
	if ( IsDefined( ent3 ) )
	{
		assert( IsDefined( string3 ) );
		ent3 thread waittill_string ( string3, ent );
		ent.threads++;
	}
	if ( IsDefined( ent4 ) )
	{
		assert( IsDefined( string4 ) );
		ent4 thread waittill_string ( string4, ent );
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/@
"Name: waittill_any_return( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string6> name of a notify to wait on"
"OptionalArg:	<string7> name of a notify to wait on"
"Example: which_notify = guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
waittill_any_return( string1, string2, string3, string4, string5, string6, string7 )
{
	if ((!IsDefined (string1) || string1 != "death") &&
	    (!IsDefined (string2) || string2 != "death") &&
	    (!IsDefined (string3) || string3 != "death") &&
	    (!IsDefined (string4) || string4 != "death") &&
	    (!IsDefined (string5) || string5 != "death") &&
	    (!IsDefined (string6) || string6 != "death") &&
	    (!IsDefined (string7) || string7 != "death"))
		self endon ("death");
		
	ent = SpawnStruct();

	if (IsDefined (string1))
		self thread waittill_string (string1, ent);

	if (IsDefined (string2))
		self thread waittill_string (string2, ent);

	if (IsDefined (string3))
		self thread waittill_string (string3, ent);

	if (IsDefined (string4))
		self thread waittill_string (string4, ent);

	if (IsDefined (string5))
		self thread waittill_string (string5, ent);

	if (IsDefined (string6))
		self thread waittill_string (string6, ent);

	if (IsDefined (string7))
		self thread waittill_string (string7, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

/@
"Name: waittill_any_array_return( <a_notifies> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<a_notifies> array of notifies to wait on"
"Example: str_which_notify = guy waittill_any_array_return( array( "goal", "pain", "near_goal", "bulletwhizby" ) );"
"SPMP: both"
@/
waittill_any_array_return( a_notifies )
{
	if ( IsInArray( a_notifies, "death" ) )
	{
		self endon("death");
	}
		
	s_tracker = SpawnStruct();
	
	foreach ( str_notify in a_notifies )
	{
		if ( IsDefined( str_notify ) )
		{
			self thread waittill_string( str_notify, s_tracker );
		}
	}

	s_tracker waittill( "returned", msg );
	s_tracker notify( "die" );
	return msg;
}

/@
"Name: waittill_any( <str_notify1>, <str_notify2>, <str_notify3>, <str_notify4>, <str_notify5> )"
"Summary: Waits for any of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<str_notify1> name of a notify to wait on"
"OptionalArg:	<str_notify2> name of a notify to wait on"
"OptionalArg:	<str_notify3> name of a notify to wait on"
"OptionalArg:	<str_notify4> name of a notify to wait on"
"OptionalArg:	<str_notify5> name of a notify to wait on"
"Example: guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
waittill_any( str_notify1, str_notify2, str_notify3, str_notify4, str_notify5 )
{
	Assert( IsDefined( str_notify1 ) );
	
	waittill_any_array( array( str_notify1, str_notify2, str_notify3, str_notify4, str_notify5 ) );
}

/@
"Name: waittill_any_array( <a_notifies> )"
"Summary: Waits for any of the the specified notifies in the array."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<a_notifies> array of notifies to wait on"
"Example: guy waittill_any_array( array( "goal", "pain", "near_goal", "bulletwhizby" ) );"
"SPMP: both"
@/
waittill_any_array( a_notifies )
{
	assert( IsDefined( a_notifies[0] ),
		"At least the first element has to be defined for waittill_any_array." );
	
	for ( i = 1; i < a_notifies.size; i++ )
	{
		if ( IsDefined( a_notifies[i] ) )
		{
			self endon( a_notifies[i] );
		}
	}
	
	self waittill( a_notifies[0] );
}

/@
"Name: waittill_any_timeout( <n_timeout>, <str_notify1>, [str_notify2], [str_notify3], [str_notify4], [str_notify5] )"
"Summary: Waits for any of the the specified notifies or times out."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<n_timeout> timeout in seconds"
"MandatoryArg:	<str_notify1> name of a notify to wait on"
"OptionalArg:	<str_notify2> name of a notify to wait on"
"OptionalArg:	<str_notify3> name of a notify to wait on"
"OptionalArg:	<str_notify4> name of a notify to wait on"
"OptionalArg:	<str_notify5> name of a notify to wait on"
"Example: guy waittill_any_timeout( 2, "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
waittill_any_timeout( n_timeout, string1, string2, string3, string4, string5 )
{
	if ( ( !isdefined( string1 ) || string1 != "death" ) &&
	( !isdefined( string2 ) || string2 != "death" ) &&
	( !isdefined( string3 ) || string3 != "death" ) &&
	( !isdefined( string4 ) || string4 != "death" ) &&
	( !isdefined( string5 ) || string5 != "death" ) )
		self endon( "death" );

	ent = spawnstruct();

	if ( isdefined( string1 ) )
		self thread waittill_string( string1, ent );

	if ( isdefined( string2 ) )
		self thread waittill_string( string2, ent );

	if ( isdefined( string3 ) )
		self thread waittill_string( string3, ent );

	if ( isdefined( string4 ) )
		self thread waittill_string( string4, ent );

	if ( isdefined( string5 ) )
		self thread waittill_string( string5, ent );

	ent thread _timeout( n_timeout );

	ent waittill( "returned", msg );
	ent notify( "die" );
	return msg;
}

_timeout( delay )
{
	self endon( "die" );

	wait( delay );
	self notify( "returned", "timeout" );
}


/@
"Name: waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for any of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_any_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
@/
waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6,ent7, string7 )
{
	assert( IsDefined( ent1 ) );
	assert( IsDefined( string1 ) );
	
	if ( ( IsDefined( ent2 ) ) && ( IsDefined( string2 ) ) )
		ent2 endon( string2 );

	if ( ( IsDefined( ent3 ) ) && ( IsDefined( string3 ) ) )
		ent3 endon( string3 );
	
	if ( ( IsDefined( ent4 ) ) && ( IsDefined( string4 ) ) )
		ent4 endon( string4 );
	
	if ( ( IsDefined( ent5 ) ) && ( IsDefined( string5 ) ) )
		ent5 endon( string5 );
	
	if ( ( IsDefined( ent6 ) ) && ( IsDefined( string6 ) ) )
		ent6 endon( string6 );
	
	if ( ( IsDefined( ent7 ) ) && ( IsDefined( string7 ) ) )
		ent7 endon( string7 );
	
	ent1 waittill( string1 );
}

/@
"Name: waittill_any_ents_two( ent1, string1, ent2, string2)"
"Summary: Waits for any of the the specified notifies on their associated entities [MAX TWO]."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"Example: guy waittill_any_ents_two( guy, "goal", guy, "pain");"
"SPMP: both"
@/
waittill_any_ents_two( ent1, string1, ent2, string2 )
{
	assert( IsDefined( ent1 ) );
	assert( IsDefined( string1 ) );
	
	if ( ( IsDefined( ent2 ) ) && ( IsDefined( string2 ) ) )
		ent2 endon( string2 );

	ent1 waittill( string1 );
}

/@
"Name: waittill_flag_exists( msg )"
"Summary: Waits for the sepcificed flag to exist / get intialized."
"Module: Utility"
"MandatoryArg:	<msg> the flag in question"
"Example: guy waittill_flag_exists( "level_init_complete" );"
"SPMP: both"
@/
waittill_flag_exists(msg)
{
	while( !flag_exists(msg) )
	{
		waittillframeend;
		if (flag_exists(msg))
			break;
		wait 0.05;
	}
}

/@
"Name: isFlashed()"
"Summary: Returns true if the player or an AI is flashed"
"Module: Utility"
"CallOn: An AI"
"Example: flashed = level.price isflashed();"
"SPMP: both"
@/
isFlashed()
{
	if ( !IsDefined( self.flashEndTime ) )
		return false;
	
	return GetTime() < self.flashEndTime;
}


/@
"Name: flag( <flagname> )"
"Summary: Checks if the flag is set. Returns true or false."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to check"
"Example: flag( "hq_cleared" );"
"SPMP: both"
@/
flag( flagname )
{
	assert( IsDefined( flagname ), "Tried to check flag but the flag was not defined." );
	assert( IsDefined( level.flag[ flagname ] ), "Tried to check flag " + flagname + " but the flag was not initialized." );
	if ( !level.flag[ flagname ] )
		return false;

	return true;
}


/@
"Name: flag_delete( <flagname> )"
"Summary: delete a flag that has been inited to free vars"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to create"
"Example: flag_delete( "hq_cleared" );"
"SPMP: SP"
@/
flag_delete( flagname )
{
	if( IsDefined( level.flag[ flagname ] ) )
	{
		level.flag[ flagname ] = undefined;
	}
	else
	{
		/#println( "flag_delete() called on flag that does not exist: " + flagname );#/
	}
}
	
/@
"Name: flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using flag_set or flag_wait"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to create"
"Example: flag_init( "hq_cleared" );"
"SPMP: both"
@/
flag_init( flagname, val )
{
	if ( !IsDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}

	if ( !IsDefined( level.sp_stat_tracking_func ) )
	{
		level.sp_stat_tracking_func = ::empty;
	}

	if ( !IsDefined( level.first_frame ) )
	{
		assert( !IsDefined( level.flag[ flagname ] ), "Attempt to reinitialize existing flag: " + flagname );
	}
	
	if (IS_TRUE(val))
	{
		level.flag[ flagname ] = true;

		/#
			level.flags_lock[ flagname ] = true;
		#/
	}
	else
	{
		level.flag[ flagname ] = false;

		/#
			level.flags_lock[ flagname ] = false;
		#/
	}
  
	if ( !IsDefined( level.trigger_flags ) )
	{
		init_trigger_flags();
		level.trigger_flags[ flagname ] = [];
	}
	else if ( !IsDefined( level.trigger_flags[ flagname ] ) )
	{
		level.trigger_flags[ flagname ] = [];
	}
	
	if ( is_suffix( flagname, "aa_" ) )
	{
		thread [[ level.sp_stat_tracking_func ]]( flagname );
	}
}

/@
"Name: flag_set( <flagname> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to set"
"Example: flag_set( "hq_cleared" );"
"SPMP: both"
@/
flag_set( flagname )
{
 /#
	assert( IsDefined( level.flag[ flagname ] ), "Attempt to set a flag before calling flag_init: " + flagname );
	assert( level.flag[ flagname ] == level.flags_lock[ flagname ] );
	level.flags_lock[ flagname ] = true;
#/
	level.flag[ flagname ] = true;
	level notify( flagname );

	set_trigger_flag_permissions( flagname );
}

/@
"Name: flag_set_for_time( <n_time>, <str_flag> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <n_time> : time to set the flag for"
"MandatoryArg: <str_flag> : name of the flag to set"
"Example: flag_set_for_time( 2, "hq_cleared" );"
"SPMP: both"
@/
flag_set_for_time( n_time, str_flag )
{
	level notify( "set_flag_for_time:" + str_flag );
	flag_set( str_flag );
	level endon( "set_flag_for_time:" + str_flag );
	wait n_time;
	flag_clear( str_flag );
}

/@
"Name: flag_toggle( <flagname> )"
"Summary: Toggles the specified flag."
"Module: Flag"
"MandatoryArg: <flagname> : name of the flag to toggle"
"Example: flag_toggle( "hq_cleared" );"
"SPMP: both"
@/
flag_toggle( flagname )
{
	if ( flag( flagname ) )
	{
		flag_clear( flagname );
	}
	else
	{
		flag_set( flagname );
	}
}

/@
"Name: flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set."
"Module: Flag"
"CallOn: Level"
"MandatoryArg: <flagname> : name of the flag to wait on"
"Example: flag_wait( "hq_cleared" );"
"SPMP: both"
@/
flag_wait( flagname )
{
	// TFLAME - 3/22/11 - useful to wait until flag exists so we can call flag_wait anywhere
	level waittill_flag_exists( flagname );
	
	while( !level.flag[ flagname ] )
	{
		level waittill( flagname );
	}
}

/@
"Name: flag_wait_any( <str_flag1>, <str_flag2>, <str_flag3>, <str_flag4>, <str_flag5> )"
"Summary: Waits until any of the the specified flags are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <str_flag1> : name of a flag to wait on"
"OptionalArg: <str_flag2> : name of a flag to wait on"
"OptionalArg: <str_flag3> : name of a flag to wait on"
"OptionalArg: <str_flag4> : name of a flag to wait on"
"OptionalArg: <str_flag5> : name of a flag to wait on"
"Example: flag_wait_any( "hq_cleared", "hq_destroyed", "hq_overrun", "hq_skipped" );"
"SPMP: both"
@/
flag_wait_any( str_flag1, str_flag2, str_flag3, str_flag4, str_flag5 )
{
	level flag_wait_any_array( array( str_flag1, str_flag2, str_flag3, str_flag4, str_flag5 ) );
}

/@
"Name: flag_wait_any_array( <a_flags> )"
"Summary: Waits until any of the the specified flags are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <a_flags> : array of flags to wait for"
"Example: flag_wait_any_array( a_my_flags );"
"SPMP: both"
@/
flag_wait_any_array( a_flags )
{
	while ( true )
	{
		for ( i = 0; i < a_flags.size; i++ )
		{
			if ( flag( a_flags[i] ) )
			{
				return a_flags[i];
			}
		}

		level waittill_any_array( a_flags );
	}
}

/@
"Name: flag_clear( <flagname> )"
"Summary: Clears the specified flag."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to clear"
"Example: flag_clear( "hq_cleared" );"
"SPMP: both"
@/
flag_clear( flagname )
{
 /#
	assert( IsDefined( level.flag[ flagname ] ), "Attempt to set a flag before calling flag_init: " + flagname );
	assert( level.flag[ flagname ] == level.flags_lock[ flagname ] );
	level.flags_lock[ flagname ] = false;
#/
	//do this check so we don't unneccessarily send a notify
	if (	level.flag[ flagname ] )
	{
		level.flag[ flagname ] = false;
		level notify( flagname );
		set_trigger_flag_permissions( flagname );
	}
}

/@
"Name: flag_waitopen( <flagname> )"
"Summary: Waits for the flag to open"
"Module: Flag"
"MandatoryArg: <flagname>: The flag"
"Example: flag_waitopen( "get_me_bagels" );"
"SPMP: both"
@/
flag_waitopen( flagname )
{
	while( level.flag[ flagname ] )
	{
		level waittill( flagname );
	}
}

/@
"Name: flag_waitopen_array( <a_flags> )"
"Summary: Waits for all the flags to be false"
"Module: Flag"
"MandatoryArg: <a_flags>: The flags to check"
"Example: flag_waitopen( array( "get_me_bagels", "puppies" ) );"
"SPMP: both"
@/
flag_waitopen_array( a_flags )
{
	foreach( str_flag in a_flags )
	{
		if ( flag( str_flag ) )
		{
			flag_waitopen( str_flag );
			continue;
		}
	}
}

/@
"Name: flag_exists( <flagname> )"
"Summary: Waits for the flag to open"
"Module: Flag"
"Call on: Entity, You can also call this on level entity for level flags."
"MandatoryArg: <flagname>: The flag"
"Example: flag_waitopen( "get_me_bagels" );"
"SPMP: both"
@/
flag_exists( flagname )
{
	if( self == level )
	{
		if( !IsDefined( level.flag ) )
			return false;

		if( IsDefined( level.flag[ flagname ] ) )
			return true;
	}
	else
	{
		if( !IsDefined( self.ent_flag ) )
			return false;

		if( IsDefined( self.ent_flag[ flagname ] ) )
			return true;
	}
	
	return false;
}

script_gen_dump_addline( string, signature )
{
	
	if ( !IsDefined( string ) )
	{
		string = "nowrite";// some things like the standardized CSV sound entries don't really need anything in script. just the asset
	}
		
	if ( !IsDefined( level._loadstarted ) )
	{
			// stashes commands away so they can be handled in the correct place within load
			if ( !IsDefined( level.script_gen_dump_preload ) )
				level.script_gen_dump_preload = [];
			struct = SpawnStruct();
			struct.string = string;
			struct.signature = signature;
			level.script_gen_dump_preload[ level.script_gen_dump_preload.size ] = struct;
			return;
	}
		
		
	if ( !IsDefined( level.script_gen_dump[ signature ] ) )
		level.script_gen_dump_reasons[ level.script_gen_dump_reasons.size ] = "Added: " + string;// console print as well as triggering the dump
	level.script_gen_dump[ signature ] = string;
	level.script_gen_dump2[ signature ] = string;// second array gets compared later with saved array. When something is missing dump is generated
}


/@
"Name: array_func( <array>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Runs the < func > function on every entity in the < array > array. The item will become "self" in the specified function. Each item is run through the function sequentially."
"Module: Array"
"CallOn: "
"MandatoryArg: array : array of entities to run through <func>"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: array_func( GetAIArray( "allies" ), ::set_ignoreme, false );"
"SPMP: both"
@/
array_func( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	if ( !IsDefined( entities ) )
	{
		return;
	}

	if ( IsArray( entities ) )
	{
		if ( entities.size )
		{
			keys = GetArrayKeys( entities );
			for ( i = 0; i < keys.size; i++ )
			{
				single_func( entities[keys[i]], func, arg1, arg2, arg3, arg4, arg5, arg6 );
			}
		}
	}
	else
	{
		single_func( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 );
	}
}


/@
"Name: single_func( <entity>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Runs the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: entity : the entity to run through <func>"
"MandatoryArg: func> : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: single_func( guy, ::set_ignoreme, false );"
"SPMP: both"
@/
single_func( entity, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	if ( !IsDefined( entity ) )
	{
		entity = level;
	}

	if ( IsDefined( arg6 ) )
	{
		entity [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
	}
	else if ( IsDefined( arg5 ) )
	{
		entity [[ func ]]( arg1, arg2, arg3, arg4, arg5 );
	}
	else if ( IsDefined( arg4 ) )
	{
		entity [[ func ]]( arg1, arg2, arg3, arg4 );
	}
	else if ( IsDefined( arg3 ) )
	{
		entity [[ func ]]( arg1, arg2, arg3 );
	}
	else if ( IsDefined( arg2 ) )
	{
		entity [[ func ]]( arg1, arg2 );
	}
	else if ( IsDefined( arg1 ) )
	{
		entity [[ func ]]( arg1 );
	}
	else
	{
		entity [[ func ]]();
	}
}


/@
"Name: array_thread( <entities>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Threads the < func > function on every entity in the < entities > array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: entities : array of entities to thread the process"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1: parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: array_thread( GetAIArray("allies"), ::set_ignoreme, false );"
"SPMP: both"
@/
array_thread( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	Assert( IsDefined( entities ), "Undefined entity array passed to common_scripts\utility::array_thread" );
	Assert( IsDefined( func ), "Undefined function passed to common_scripts\utility::array_thread" );

	if ( IsArray( entities ) )
	{
		if ( IsDefined( arg6 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
			}
		}
		else if ( IsDefined( arg5 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4, arg5 );
			}
		}
		else if ( IsDefined( arg4 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3, arg4 );
			}
		}
		else if ( IsDefined( arg3 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2, arg3 );
			}
		}
		else if ( IsDefined( arg2 ) )
		{
			foreach ( ent in entities )
			{
				ent thread [[ func ]]( arg1, arg2 );
			}
		}
		else if ( IsDefined( arg1 ) )
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
		single_thread( entities, func, arg1, arg2, arg3, arg4, arg5, arg6 );
	}
}

/@
"Name: array_ent_thread( <entities>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5] )"
"Summary: Threads the <func> function on self for every entity in the <entities> array, passing the entity has the first argument."
"Module: Array"
"CallOn: NA"
"MandatoryArg: entities : array of entities to thread the process"
"MandatoryArg: func : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func (after the entity)"
"OptionalArg: arg2 : parameter 2 to pass to the func (after the entity)"
"OptionalArg: arg3 : parameter 3 to pass to the func (after the entity)"
"OptionalArg: arg4 : parameter 4 to pass to the func (after the entity)"
"OptionalArg: arg5 : parameter 5 to pass to the func (after the entity)"
"Example: array_ent_thread( GetAIArray("allies"), ::do_something, false );"
"SPMP: both"
@/
array_ent_thread( entities, func, arg1, arg2, arg3, arg4, arg5 )
{
	Assert( IsDefined( entities ), "Undefined entity array passed to common_scripts\utility::array_ent_thread" );
	Assert( IsDefined( func ), "Undefined function passed to common_scripts\utility::array_ent_thread" );
	
	if ( IsArray( entities ) )
	{
		if ( entities.size )
		{
			keys = GetArrayKeys( entities );
			for ( i = 0; i < keys.size; i++ )
			{
				single_thread( self, func, entities[keys[i]], arg1, arg2, arg3, arg4, arg5 );
			}
		}
	}
	else
	{
		single_thread( self, func, entities, arg1, arg2, arg3, arg4, arg5 );
	}
}

/@
"Name: single_thread( <entity>, <func>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5>, <arg6> )"
"Summary: Threads the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to thread <func> on"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: <arg1> : parameter 1 to pass to the func"
"OptionalArg: <arg2> : parameter 2 to pass to the func"
"OptionalArg: <arg3> : parameter 3 to pass to the func"
"OptionalArg: <arg4> : parameter 4 to pass to the func"
"OptionalArg: <arg5> : parameter 5 to pass to the func"
"OptionalArg: <arg6> : parameter 6 to pass to the func"
"Example: single_func( guy, ::special_ai_think, "some_string", 345 );"
"SPMP: both"
@/
single_thread(entity, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	Assert( IsDefined( entity ), "Undefined entity passed to common_scripts\utility::single_thread()" );

	if ( IsDefined( arg6 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
	}
	else if ( IsDefined( arg5 ) )
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if ( IsDefined( arg4 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3, arg4 );
	}
	else if ( IsDefined( arg3 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3 );
	}
	else if ( IsDefined( arg2 ) )
	{
		entity thread [[ func ]]( arg1, arg2 );
	}
	else if ( IsDefined( arg1 ) )
	{
		entity thread [[ func ]]( arg1 );
	}
	else
	{
		entity thread [[ func ]]();
	}
}

remove_undefined_from_array( array )
{
	newarray = [];
	for ( i = 0; i < array.size; i ++ )
	{
		if ( !IsDefined( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

/@
"Name: trigger_on( <name>, <type> )"
"Summary: Turns a trigger on. This only needs to be called if it was previously turned off"
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_on(); -or- trigger_on( "base_trigger", "targetname" )"
"SPMP: both"
@/
trigger_on( name, type )
{
	if ( IsDefined( name ) )
	{
		DEFAULT( type, "targetname" );
		
		ents = GetEntArray( name, type );
		array_thread( ents, ::trigger_on_proc );
	}
	else
	{
		self trigger_on_proc();
	}
}

trigger_on_proc()
{
	if ( IsDefined( self.realOrigin ) )
	{
		self.origin = self.realOrigin;
	}
	
	self.trigger_off = undefined;
}

/@
"Name: trigger_off( <name>, <type> )"
"Summary: Turns a trigger off so it can no longer be triggered."
"Module: Trigger"
"CallOn: A trigger"
"OptionalArg: <name> : the name corrisponding to a targetname or script_noteworthy to grab the trigger internally"
"OptionalArg: <type> : the type( targetname, or script_noteworthy ) corrisponding to a name to grab the trigger internally"
"Example: trigger trigger_off();"
"SPMP: both"
@/
trigger_off( name, type )
{
	if ( IsDefined( name ) )
	{
		DEFAULT( type, "targetname" );
		
		ents = GetEntArray( name, type );
		array_thread( ents, ::trigger_off_proc );
	}
	else
	{
		self trigger_off_proc();
	}
}
 
trigger_off_proc()
{
	if ( !IsDefined( self.realOrigin ) )
	{
		self.realOrigin = self.origin;
	}

	if ( self.origin == self.realorigin )
	{
		self.origin += ( 0, 0, -10000 );
	}
	
	self.trigger_off = true;
}

/@
Name: trigger_wait( <str_name> , str_key = "targetname", e_entity )
Summary: Waits until a trigger with the specified key / value is triggered. Returns the trigger and assigns the entity that triggered it to "trig.who".
Module: Trigger
MandatoryArg: str_name: Key value.
OptionalArg: str_key: Key name on the trigger to use, example: "targetname" or "script_noteworthy".
OptionalArg: e_entity: Wait for a specific entity to trigger the trigger.
Example: trigger_wait( "player_in_building1, "script_noteworthy" );
SPMP: both
@/
trigger_wait( str_name, str_key = "targetname", e_entity )
{
	if ( IsDefined( str_name ) )
	{
		triggers = GetEntArray( str_name, str_key );
		Assert( triggers.size > 0, "trigger not found: " + str_name + " key: " + str_key );
		
		if ( triggers.size == 1 )
		{
			trigger_hit = triggers[0];
			trigger_hit _trigger_wait( e_entity );
		}
		else
		{
			s_tracker = SpawnStruct();
			array_thread( triggers, ::_trigger_wait_think, s_tracker, e_entity );
			s_tracker waittill( "trigger", e_other, trigger_hit );
			trigger_hit.who = e_other;
		}
		
		level notify( str_name, trigger_hit.who );	// TODO: brianb - do we need this?
		
		return trigger_hit;
	}
	else
	{
		return _trigger_wait( e_entity );
	}
}

_trigger_wait( e_entity )
{
	do
	{
		if ( is_look_trigger( self ) )
		{
			self waittill( "trigger_look", e_other );
		}
		else
		{
			self waittill( "trigger", e_other );
		}
	}
	while ( IsDefined( e_entity ) && ( e_other != e_entity ) );
	
	self.who = e_other;
	return self;
}

_trigger_wait_think( s_tracker, e_entity )
{
	self endon( "death" );
	s_tracker endon( "trigger" );
	
	e_other = _trigger_wait( e_entity );
	s_tracker notify( "trigger", e_other, self );
}

/@
"Name: trigger_use( <strName> , <strKey>, <ent> )"
"Summary: Activates a trigger with the specified key / value is triggered"
"Module: Trigger"
"CallOn: "
"MandatoryArg: <strName> : Name of the key on this trigger"
"OptionalArg: <strKey> : Key on the trigger to use, example: "targetname" or "script_noteworthy""
"OptionalArg: <ent> : Entity that the trigger is used by"
"OptionalArg: <b_assert> : Set to false to not assert if the trigger doesn't exist"
"Example: trigger_use( "player_in_building1, "targetname", enemy );"
"SPMP: singleplayer"
@/
trigger_use( str_name, str_key = "targetname", ent, b_assert = true )
{
    if ( !IsDefined( ent ) )
    {
        ent = get_players()[0];
    }

	if ( IsDefined( str_name ) )
	{
		e_trig = GetEnt( str_name, str_key );
		if( !IsDefined( e_trig ) )
		{
			if ( b_assert )
			{
				AssertMsg( "trigger not found: " + str_name + " key: " + str_key );
			}
			
			return;
		}
    }
	else
	{
		e_trig = self;
		str_name = self.targetname;
	}
	
	e_trig UseBy( ent );
	
	level notify( str_name, ent );	// TODO: brianb - do we need this?
	
	if ( is_look_trigger( e_trig ) )
	{
		e_trig notify( "trigger_look" );
	}
	
	return e_trig;
}

set_trigger_flag_permissions( msg )
{
	// turns triggers on or off depending on if they have the proper flags set, based on their shift-g menu settings

	// this can be init before _load has run, thanks to AI.
	if ( !IsDefined( level.trigger_flags ) )
		return;

	// cheaper to do the upkeep at this time rather than with endons and waittills on the individual triggers
	level.trigger_flags[ msg ] = remove_undefined_from_array( level.trigger_flags[ msg ] );
	array_thread( level.trigger_flags[ msg ], ::update_trigger_based_on_flags );
}

update_trigger_based_on_flags()
{
	true_on = true;
	if ( IsDefined( self.script_flag_true ) )
	{
		true_on = false;
		tokens = create_flags_and_return_tokens( self.script_flag_true );
		
		// stay off unless any of the flags are true
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				true_on = true;
				break;
			}
		}
	}
	
	false_on = true;
	if ( IsDefined( self.script_flag_false ) )
	{
		tokens = create_flags_and_return_tokens( self.script_flag_false );
		
		// stay on unless any of the flags are true
		for( i=0; i < tokens.size; i++ )
		{
			if ( flag( tokens[ i ] ) )
			{
				false_on = false;
				break;
			}
		}
	}
	
	[ [ level.trigger_func[ true_on && false_on ] ] ]();
}

create_flags_and_return_tokens( flags )
{
	tokens = strtok( flags, " " );

	// create the flag if level script does not
	for( i=0; i < tokens.size; i++ )
	{
		if ( !IsDefined( level.flag[ tokens[ i ] ] ) )
		{
			flag_init( tokens[ i ] );
		}
	}
	
	return tokens;
}

init_trigger_flags()
{
	level.trigger_flags = [];
	level.trigger_func[ true ] = ::trigger_on;
	level.trigger_func[ false ] = ::trigger_off;
}

is_look_trigger( trig )
{
	return ( IsDefined( trig ) ? trig has_spawnflag( SPAWNFLAG_TRIGGER_LOOK ) && !IS_EQUAL( trig.classname, "trigger_damage" ) : false );
}

is_trigger_once( trig )
{
	return ( IsDefined( trig ) ? trig has_spawnflag( SPAWNFLAG_TRIGGER_TRIGGER_ONCE ) || ( IS_EQUAL( self.classname, "trigger_once" ) ) : false );
}

/@
"Name: getstruct( <name> , <type> )"
"Summary: Returns a struct with the specified value of "target", "targetname", "script_noteworthy", or "script_linkname"."
"Module: Utility"
"Example: getstruct("some_value", "targetname");"
"SPMP: both"
@/
getstruct( name, type = "targetname" )
{
	assert( IsDefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	array = level.struct_class_names[ type ][ name ];
	if( !IsDefined( array ) )
	{
		return undefined;
	}

	if( array.size > 1 )
	{
		assertMsg( "getstruct used for more than one struct of type " + type + " called " + name + "." );
		return undefined;
	}
	return array[ 0 ];
}

/@
"Name: getstructarray( <name> , <type )"
"Summary: gets an array of script_structs"
"Module: Array"
"CallOn: An entity"
"MandatoryArg: <name> : "
"MandatoryArg: <type> : "
"Example: fxemitters = getstructarray( "streetlights", "targetname" )"
"SPMP: both"
@/

getstructarray( name, type = "targetname" )
{
	Assert( IsDefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );

	array = level.struct_class_names[ type ][ name ];
	if ( !IsDefined( array ) )
		return [];
	
	return array;
}

structdelete()
{
	//self is a struct from Radiant
	//- tear down the entries in level.struct_class_names[]
	
	if(IsDefined(self.target) && IsDefined(level.struct_class_names["target"][self.target]))
	{
		level.struct_class_names["target"][self.target] = undefined;
	}
	
	if(IsDefined(self.targetname) && IsDefined(level.struct_class_names["targetname"][self.targetname]))
	{
		level.struct_class_names["targetname"][self.targetname] = undefined;
	}
	
	if(IsDefined(self.script_noteworthy) && IsDefined(level.struct_class_names["script_noteworthy"][self.script_noteworthy]))
	{
		level.struct_class_names["script_noteworthy"][self.script_noteworthy] = undefined;
	}
	
	if(IsDefined(self.script_linkname) && IsDefined(level.struct_class_names["script_linkname"][self.script_linkname]))
	{
		level.struct_class_names["script_linkname"][self.script_linkname] = undefined;
	}
	
}

struct_class_init()
{
	assert( !IsDefined( level.struct_class_names ), "level.struct_class_names is being initialized in the wrong place! It shouldn't be initialized yet." );
	
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	level.struct_class_names[ "script_unitrigger_type" ] = [];
	
	foreach ( s_struct in level.struct )
	{
		if ( IsDefined( s_struct.targetname ) )
		{
			if ( !IsDefined( level.struct_class_names[ "targetname" ][ s_struct.targetname ] ) )
				level.struct_class_names[ "targetname" ][ s_struct.targetname ] = [];
			
			size = level.struct_class_names[ "targetname" ][ s_struct.targetname ].size;
			level.struct_class_names[ "targetname" ][ s_struct.targetname ][ size ] = s_struct;
		}
		if ( IsDefined( s_struct.target ) )
		{
			if ( !IsDefined( level.struct_class_names[ "target" ][ s_struct.target ] ) )
				level.struct_class_names[ "target" ][ s_struct.target ] = [];
			
			size = level.struct_class_names[ "target" ][ s_struct.target ].size;
			level.struct_class_names[ "target" ][ s_struct.target ][ size ] = s_struct;
		}
		if ( IsDefined( s_struct.script_noteworthy ) )
		{
			if ( !IsDefined( level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] ) )
				level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ] = [];
			
			size = level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ].size;
			level.struct_class_names[ "script_noteworthy" ][ s_struct.script_noteworthy ][ size ] = s_struct;
		}
		if ( IsDefined( s_struct.script_linkname ) )
		{
			assert( !IsDefined( level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ] ), "Two structs have the same linkname" );
			level.struct_class_names[ "script_linkname" ][ s_struct.script_linkname ][ 0 ] = s_struct;
		}
		if ( IsDefined( s_struct.script_unitrigger_type ) )
		{
			if ( !IsDefined( level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] ) )
				level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ] = [];
			
			size = level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ].size;
			level.struct_class_names[ "script_unitrigger_type" ][ s_struct.script_unitrigger_type ][ size ] = s_struct;
		}		
	}
}


fileprint_start( file )
{
	 /#
	filename = file;

//hackery here, sometimes the file just doesn't open so keep trying
//	file = -1;
//	while( file == -1 )
//	{
		file = openfile( filename, "write" );
//		if (file == -1)
//			wait .05; // try every frame untill the file becomes writeable
//	}
	level.fileprint = file;
	level.fileprintlinecount = 0;
	level.fileprint_filename = filename;
	#/
}

/@
"Name: fileprint_map_start( <filename> )"
"Summary: starts map export with the file trees\cod3\cod3\map_source\xenon_export\ < filename > .map adds header / worldspawn entity to the map.  Use this if you want to start a .map export."
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <param1> : "
"OptionalArg: <param2> : "
"Example: fileprint_map_start( filename );"
"SPMP: both"
@/

fileprint_map_start( file )
{
	 /#
	file = "map_source/" + file + ".map";
	fileprint_start( file );

	// for the entity count
	level.fileprint_mapentcount = 0;

	fileprint_map_header( true );
	#/
	
}

fileprint_chk( file , str )
{
	/#
		//dodging infinite loops for file dumping. kind of dangerous
		level.fileprintlinecount++;
		if (level.fileprintlinecount>400)
		{
			wait .05;
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln( file, str );
	#/
}

fileprint_map_header( bInclude_blank_worldspawn )
{
	if ( !IsDefined( bInclude_blank_worldspawn ) )
		bInclude_blank_worldspawn = false;
		
	// this may need to be updated if map format changes
	assert( IsDefined( level.fileprint ) );
	 /#
	fileprint_chk( level.fileprint, "iwmap 4" );
	fileprint_chk( level.fileprint, "\"000_Global\" flags  active" );
	fileprint_chk( level.fileprint, "\"The Map\" flags" );
	
	if ( !bInclude_blank_worldspawn )
		return;
	 fileprint_map_entity_start();
	 fileprint_map_keypairprint( "classname", "worldspawn" );
	 fileprint_map_entity_end();

	#/
}

/@
"Name: fileprint_map_keypairprint( <key1> , <key2> )"
"Summary: prints a pair of keys to the current open map( by fileprint_map_start() )"
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <key1> : "
"MandatoryArg: <key2> : "
"Example: fileprint_map_keypairprint( "classname", "script_model" );"
"SPMP: both"
@/

fileprint_map_keypairprint( key1, key2 )
{
	 /#
	assert( IsDefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "\"" + key1 + "\" \"" + key2 + "\"" );
	#/
}

/@
"Name: fileprint_map_entity_start()"
"Summary: prints entity number and opening bracket to currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_start();"
"SPMP: both"
@/

fileprint_map_entity_start()
{
	 /#
	assert( !IsDefined( level.fileprint_entitystart ) );
	level.fileprint_entitystart = true;
	assert( IsDefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "// entity " + level.fileprint_mapentcount );
	fileprint_chk( level.fileprint, "{" );
	level.fileprint_mapentcount ++ ;
	#/
}

/@
"Name: fileprint_map_entity_end()"
"Summary: close brackets an entity, required for the next entity to begin"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_end();"
"SPMP: both"
@/

fileprint_map_entity_end()
{
	 /#
	assert( IsDefined( level.fileprint_entitystart ) );
	assert( IsDefined( level.fileprint ) );
	level.fileprint_entitystart = undefined;
	fileprint_chk( level.fileprint, "}" );
	#/
}

/@
"Name: fileprint_end()"
"Summary: saves the currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_end();"
"SPMP: both"
@/
 
fileprint_end()
{
	 /#
	assert( !IsDefined( level.fileprint_entitystart ) );
	saved = closefile( level.fileprint );
	if (saved != 1)
	{
		println("-----------------------------------");
		println(" ");
		println("file write failure");
		println("file with name: "+level.fileprint_filename);
		println("make sure you checkout the file you are trying to save");
		println("note: USE P4 Search to find the file and check that one out");
		println("      Do not checkin files in from the xenonoutput folder, ");
		println("      this is junctioned to the proper directory where you need to go");
		println("junctions looks like this");
		println(" ");
		println("..\\xenonOutput\\scriptdata\\createfx      ..\\share\\raw\\maps\\createfx");
		println("..\\xenonOutput\\scriptdata\\createart     ..\\share\\raw\\maps\\createart");
		println("..\\xenonOutput\\scriptdata\\vision        ..\\share\\raw\\vision");
		println("..\\xenonOutput\\scriptdata\\scriptgen     ..\\share\\raw\\maps\\scriptgen");
		println("..\\xenonOutput\\scriptdata\\zone_source   ..\\xenon\\zone_source");
		println("..\\xenonOutput\\accuracy                  ..\\share\\raw\\accuracy");
		println("..\\xenonOutput\\scriptdata\\map_source    ..\\map_source\\xenon_export");
		println(" ");
		println("-----------------------------------");
		
		println( "File not saved( see console.log for info ) " );
	}
	level.fileprint = undefined;
	level.fileprint_filename = undefined;
	#/
}

/@
"Name: fileprint_radiant_vec( <vector> )"
"Summary: this converts a vector to a .map file readable format"
"Module: Fileprint"
"CallOn: An entity"
"MandatoryArg: <vector> : "
"Example: origin_string = fileprint_radiant_vec( vehicle.angles )"
"SPMP: both"
@/
fileprint_radiant_vec( vector )
{
	 /#
		string = "" + vector[ 0 ] + " " + vector[ 1 ] + " " + vector[ 2 ] + "";
		return string;
	#/
}


is_mature()
{
	if ( level.onlineGame )
		return true;

	return GetLocalProfileInt( "cg_mature" );
}

is_german_build()
{
	if( GetDvar( "language" ) == "german" )
	{
		return true;
	}
	return false;
}
is_gib_restricted_build()
{
	if( GetDvar( "language" ) == "german" )
	{
		return true;
	}
	if( GetDvar( "language" ) == "japanese" )
	{
		return true;
	}
	return false;
}

/@
"Name: is_true(<check>)"
"Summary: For boolean checks when undefined should mean 'false'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_true( self.is_linked ) ) { //do stuff }"
"SPMP: both"
@/
is_true(check)
{
	return(IsDefined(check) && check);
}

/@
"Name: is_false(<check>)"
"Summary: For boolean checks when undefined should mean 'true'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_false( self.is_linked ) ) { //do stuff }"
"SPMP: both"
@/
is_false(check)
{
	return(IsDefined(check) && !check);
}

/@
"Name: has_spawnflag(<spawnflags>)"
"Summary: Check to see if a spawnflag value is set on an entity."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg: <spawnflags> : The spawnflags value you want to check for."
"Example: if ( has_spawnflag( SPAWNFLAG_ACTOR_SPAWNER ) ) { //do stuff }"
"SPMP: both"
@/
has_spawnflag(spawnflags)
{
	if (IsDefined(self.spawnflags))
	{
		return ((self.spawnflags & spawnflags) == spawnflags);
	}

	return false;
}

/@
"Name: clamp(val, val_min, val_max)"
"Summary: Clamps a value between a min and max value."
"Module: Math"
"MandatoryArg: val: the value to clamp."
"MandatoryArg: val_min: the min value to clamp to."
"MandatoryArg: val_max: the mac value to clamp to."
"Example: clamped_val = clamp(8, 0, 5); // returns 5	*	clamped_val = clamp(-1, 0, 5); // returns 0"
"SPMP: both"
@/
clamp(val, val_min, val_max)
{
	if (val < val_min)
	{
		val = val_min;
	}
	else if (val > val_max)
	{
		val = val_max;
	}

	return val;
}

/@
"Name: linear_map(val, min_a, max_a, min_b, max_b)"
"Summary: Maps a value within one range to a value in another range."
"Module: Math"
"MandatoryArg: val: the value to map."
"MandatoryArg: min_a: the min value of the range in which <val> exists."
"MandatoryArg: max_a: the max value of the range in which <val> exists."
"MandatoryArg: min_b: the min value of the range in which the return value should exist."
"MandatoryArg: max_b: the max value of the range in which the return value should exist."
"Example: fov = linear_map(speed, min_speed, max_speed, min_fov, max_fov);"
"SPMP: both"
@/
linear_map(num, min_a, max_a, min_b, max_b)
{
	return clamp(( (num - min_a) / (max_a - min_a) * (max_b - min_b) + min_b ), min_b, max_b);
}


/@
"Name: lag(desired, curr, k, dt)"
"Summary: Changes a value from current to desired using 1st order differential lag."
"Module: Math"
"MandatoryArg: desired: desired value."
"MandatoryArg: curr: the current value."
"MandatoryArg: k: the strength of the lag ( lower = slower, higher = faster)."
"MandatoryArg: dt: time step to lag over ( usually 1 server frame )."
"Example: speed = lag(max_speed, speed, 1, 0.05);"
"SPMP: both"
@/
lag(desired, curr, k, dt)
{
    r = 0.0;

    if (((k * dt) >= 1.0) || (k <= 0.0))
    {
        r = desired;
    }
    else
    {
        err = desired - curr;
        r = curr + k * err * dt;
    }

    return r;
}

// Facial animation event notify wrappers
death_notify_wrapper( attacker, damageType )
{
	level notify( "face", "death", self );
	self notify( "death", attacker, damageType );
}

damage_notify_wrapper( damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags )
{
	level notify( "face", "damage", self );
	self notify( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
}

explode_notify_wrapper()
{
	level notify( "face", "explode", self );
	self notify( "explode" );
}

alert_notify_wrapper()
{
	level notify( "face", "alert", self );
	self notify( "alert" );
}

shoot_notify_wrapper()
{
	level notify( "face", "shoot", self );
	self notify( "shoot" );
}

melee_notify_wrapper()
{
	level notify( "face", "melee", self );
	self notify( "melee" );
}

isUsabilityEnabled()
{
	return ( !self.disabledUsability );
}


_disableUsability()
{
	self.disabledUsability++;
	self DisableUsability();
}


_enableUsability()
{
	self.disabledUsability--;
	
	assert( self.disabledUsability >= 0 );
	
	if ( !self.disabledUsability )
		self EnableUsability();
}


resetUsability()
{
	self.disabledUsability = 0;
	self EnableUsability();
}


_disableWeapon()
{
	if (!isDefined(self.disabledWeapon))
		self.disabledWeapon = 0;

	self.disabledWeapon++;
	self disableWeapons();
}

_enableWeapon()
{
	self.disabledWeapon--;
	
	assert( self.disabledWeapon >= 0 );
	
	if ( !self.disabledWeapon )
		self enableWeapons();
}

isWeaponEnabled()
{
	return ( !self.disabledWeapon );
}

/@
"Name: delay_thread(<delay>, <function>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5>)"
"Summary: Delay the execution of a thread."
"Module: Utility"
"MandatoryArg: <delay> : The delay before the function occurs"
"MandatoryArg: <delay> : The function to run."
"OptionalArg: <arg1> : parameter 1 to pass to the process"
"OptionalArg: <arg2> : parameter 2 to pass to the process"
"OptionalArg: <arg3> : parameter 3 to pass to the process"
"OptionalArg: <arg4> : parameter 4 to pass to the process"
"OptionalArg: <arg5> : parameter 5 to pass to the process"
"Example: delay_thread( ::flag_set, "player_can_rappel", 3 );
"SPMP: singleplayer"
@/

delay_thread(timer, func, param1, param2, param3, param4, param5, param6)
{
	self thread _delay_thread_proc(func, timer, param1, param2, param3, param4, param5, param6);
}

_delay_thread_proc(func, timer, param1, param2, param3, param4, param5, param6)
{
	self endon( "death" );
	
	wait( timer );
	
	single_thread( self, func, param1, param2, param3, param4, param5, param6 );
}

/@
"Name: delay_notify( <str_notify>, <n_delay>, [str_endon] )"
"Summary: Notifies self the string after waiting the specified delay time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <str_notify> : The string to notify"
"MandatoryArg: <n_delay> : Time to wait( in seconds ) before sending the notify."
"OptionalArg: <str_endon> : Endon to cancel the notify"
"Example: vehicle delay_notify( "start_to_smoke", 3.5 );"
"SPMP: singleplayer"
@/
delay_notify( str_notify, n_delay, str_endon )
{
	Assert( IsDefined( str_notify ) );
	Assert( IsDefined( n_delay ) );
	
	self thread _delay_notify_proc( str_notify, n_delay, str_endon );
}

_delay_notify_proc( str_notify, n_delay, str_endon )
{
	self endon( "death" );
	
	if ( IsDefined( str_endon ) )
	{
		self endon( str_endon );
	}
	
	if ( n_delay > 0 )
	{
		wait n_delay;
	}
	
	self notify( str_notify );
}

/@
"Name: notify_delay_with_ender( <notify_string> , <delay>, <ender> )"
"Summary: Notifies self the string after waiting the specified delay time.  Can pass through an ender to stop the notify from firing here"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <notify_string> : The string to notify"
"MandatoryArg: <delay> : Time to wait( in seconds ) before sending the notify."
"OptionalArg: <ender> : End the thread on this"
"Example: vehicle notify_delay_with_ender( "start_to_smoke", 3.5, "start_to_smoke");" // this would end this function if you had a notify firing in multiple places and didnt want it firing multiple times
"SPMP: singleplayer"
@/
notify_delay_with_ender( sNotifyString, fDelay, ender )
{
	if (isdefined(ender))
	{
		level endon (ender);
	}
	assert( IsDefined( self ) );
	assert( IsDefined( sNotifyString ) );
	assert( IsDefined( fDelay ) );
	//assert( fDelay > 0 ); //GLocke: changed to just not wait if passed in a 0 so that this function is friendly in loops where some need to be notified right away.

	self endon( "death" );
	
	if( fDelay > 0 )
	{
		wait fDelay;
	}
	
	if( !IsDefined( self ) )
	{
		return;
	}
	self notify( sNotifyString );
}

/*
=============
///ScriptDocBegin
"Name: ter_op( <statement> , <true_value> , <false_value> )"
"Summary: Functon that serves as a tertiary operator in C/C++"
"Module: Utility"
"CallOn: "
"MandatoryArg: <statement>: The statement to evaluate"
"MandatoryArg: <true_value>: The value that is returned when the statement evaluates to true"
"MandatoryArg: <false_value>: That value that is returned when the statement evaluates to false"
"Example: x = ter_op( x > 5, 2, 7 );"
"SPMP: both"
///ScriptDocEnd
=============
*/
/* DEAD CODE REMOVAL
ter_op( statement, true_value, false_value )
{
	if ( statement )
		return true_value;
	return false_value;
}
*/
