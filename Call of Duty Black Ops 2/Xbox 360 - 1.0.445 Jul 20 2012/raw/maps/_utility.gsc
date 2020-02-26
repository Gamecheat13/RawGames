#include common_scripts\utility;
#include maps\_utility_code;

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\level_progression.gsh;

/@
"Name: ent_flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set on self. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to wait on"
"Example: enemy ent_flag_wait( "goal" );"
"SPMP: singleplayer"
@/
ent_flag_wait( msg )
{
	self endon("death");

	while (!self.ent_flag[ msg ])
	{
		self waittill(msg);
	}
}

init_leaderboards()
{
	if( level.script != "frontend" )
	{
		levelAlias = TableLookup( LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_NAME, level.script, LEVEL_PROGRESSION_MISSION );
		
		if( levelAlias != "" )
		{
			lb_string = "LB_SP_CAMPAIGN LB_SP_"+levelAlias;
			PrecacheLeaderboards( lb_string );
		}
	}
}


/@
"Name: ent_flag_wait_either( <flagname1> , <flagname2> )"
"Summary: Waits until either of the the specified flags are set on self. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname1> : name of one flag to wait on"
"MandatoryArg: <flagname2> : name of the other flag to wait on"
"Example: enemy ent_flag_wait( "goal", "damage" );"
"SPMP: singleplayer"
@/
ent_flag_wait_either( flag1, flag2 )
{
	self endon ("death");

	for( ;; )
	{
		if (ent_flag( flag1 ))
		{
			return;
		}
		if (ent_flag( flag2 ))
		{
			return;
		}

		self waittill_either( flag1, flag2 );
	}
}

/@
"Name: ent_flag_wait_or_timeout( <flagname> , <timer> )"
"Summary: Waits until either the flag gets set on self or the timer elapses. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer> : Amount of time to wait before continuing regardless of flag."
"Example: ent_flag_wait_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
@/
ent_flag_wait_or_timeout( flagname, timer )
{
	self endon("death");

	start_time = gettime();
	for( ;; )
	{
		if( self.ent_flag[ flagname ] )
		{
			break;
		}

		if( gettime() >= start_time + timer * 1000 )
		{
			break;
		}

		self ent_wait_for_flag_or_time_elapses( flagname, timer );
	}
}

ent_flag_waitopen( msg )
{
	self endon("death");

	while( self.ent_flag[ msg ] )
	{
		self waittill( msg );
	}
}

/@
"Name: ent_flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using ent_flag_set or ent_flag_wait.  Some flags for ai are set by default such as 'goal', 'death', and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to create"
"Example: enemy ent_flag_init( "hq_cleared" );"
"SPMP: singleplayer"
@/
ent_flag_init( message, val )
{
	if( !IsDefined( self.ent_flag ) )
	{
		self.ent_flag = [];
		self.ent_flags_lock = [];
	}
	
	if ( !IsDefined( level.first_frame ) )
	{
		assert( !IsDefined( self.ent_flag[ message ] ), "Attempt to reinitialize existing flag '" + message + "' on entity.");
	}

	if (is_true(val))
	{
		self.ent_flag[ message ] = true;

		/#
			self.ent_flags_lock[ message ] = true;
		#/
	}
	else
	{
		self.ent_flag[ message ] = false;

		/#
			self.ent_flags_lock[ message ] = false;
		#/
	}
}

/@
"Name: ent_flag_exist( <flagname> )"
"Summary: checks to see if a flag exists"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to check"
"Example: if( enemy ent_flag_exist( "hq_cleared" ) );"
"SPMP: singleplayer"
@/
ent_flag_exist( message )
{
	if ( IsDefined( self.ent_flag ) && IsDefined( self.ent_flag[ message ] ) )
		return true;
	return false;
}

/@
"Name: ent_flag_set( <flagname> )"
"Summary: Sets the specified flag on self, all scripts using ent_flag_wait on self will now continue."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to set"
"Example: enemy ent_flag_set( "hq_cleared" );"
"SPMP: singleplayer"
@/
ent_flag_set( message )
{
	/#

	assert( IsDefined( self ), "Attempt to set a flag on entity that is not defined" );
	assert( IsDefined( self.ent_flag[ message ] ), "Attempt to set a flag before calling flag_init: '" + message + "'." );
	assert( self.ent_flag[ message ] == self.ent_flags_lock[ message ] );
	self.ent_flags_lock[ message ] = true;
	
	#/

	self.ent_flag[ message ] = true;
	self notify( message );
}

/@
"Name: ent_flag_toggle( <flagname> )"
"Summary: Toggles the specified ent flag."
"Module: Flag"
"MandatoryArg: <flagname> : name of the flag to toggle"
"Example: ent_flag_toggle( "hq_cleared" );"
"SPMP: SP"
@/
ent_flag_toggle( message )
{
	if (self ent_flag(message))
	{
		self ent_flag_clear(message);
	}
	else
	{
		self ent_flag_set(message);
	}
}

/@
"Name: ent_flag_clear( <flagname> )"
"Summary: Clears the specified flag on self."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to clear"
"Example: enemy ent_flag_clear( "hq_cleared" );"
"SPMP: singleplayer"
@/
ent_flag_clear( message )
{
	/#

	assert( IsDefined( self ), "Attempt to clear a flag on entity that is not defined" );
	assert( IsDefined( self.ent_flag[ message ] ), "Attempt to set a flag before calling flag_init: '" + message + "'." );
	assert( self.ent_flag[ message ] == self.ent_flags_lock[ message ] );
	self.ent_flags_lock[ message ] = false;

	#/

	//do this check so we don't unnecessarily send a notify
	if(	self.ent_flag[ message ] )
	{
		self.ent_flag[ message ] = false;
		self notify( message );
	}
}



/@
"Name: ent_flag( <flagname> )"
"Summary: Checks if the flag is set on self. Returns true or false."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <flagname> : name of the flag to check"
"Example: enemy ent_flag( "death" );"
"SPMP: singleplayer"
@/
ent_flag( message )
{
	assert( IsDefined( message ), "Tried to check flag but the flag was not defined." );
	assert( IsDefined( self.ent_flag[ message ] ), "Tried to check entity flag '" + message + "', but the flag was not initialized.");

	if( !self.ent_flag[ message ] )
	{
		return false;
	}

	return true;
}

ent_flag_init_ai_standards()
{
	message_array = [];

	message_array[ message_array.size ] = "goal";
	message_array[ message_array.size ] = "damage";

	for( i = 0; i < message_array.size; i++)
	{
		self ent_flag_init( message_array[ i ] );
		self thread ent_flag_wait_ai_standards( message_array[ i ] );
	}
}

ent_flag_wait_ai_standards( message )
{
	/*
	only runs the first time on the message, so for
	example if it's waiting on goal, it will only set
	the goal to true the first time.  It also doesn't
	call ent_set_flag() because that would notify the
	message possibly twice in the same frame, or worse
	in the next frame.
	*/
	self endon("death");
	self waittill( message );
	self.ent_flag[ message ] = true;
}

/@
"Name: flag_wait_either( <flagname1> , <flagname2> )"
"Summary: Waits until either of the the specified flags are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1> : name of one flag to wait on"
"MandatoryArg: <flagname2> : name of the other flag to wait on"
"Example: flag_wait( "hq_cleared", "hq_destroyed" );"
"SPMP: singleplayer"
@/
flag_wait_either( flag1, flag2 )
{
	for( ;; )
	{
		if( flag( flag1 ) )
		{
			return;
		}
		if( flag( flag2 ) )
		{
			return;
		}

		level waittill_either( flag1, flag2 );
	}
}

/@
"Name: flag_wait_all( <flagname1> , <flagname2>, <flagname3> , <flagname4> )"
"Summary: Waits until all of the the specified flags are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1> : name of a flag to wait on"
"MandatoryArg: <flagname2> : name of a flag to wait on"
"OptionalArg: <flagname3> : name of a flag to wait on"
"OptionalArg: <flagname4> : name of a flag to wait on"
"Example: flag_wait_any( "hq_cleared", "hq_destroyed", "hq_overrun", "hq_skipped" );"
"SPMP: singleplayer"
@/
flag_wait_all( flag1, flag2, flag3, flag4 )
{
	if( IsDefined( flag1 ) )
	{
		flag_wait( flag1 );
	}

	if( IsDefined( flag2 ) )
	{
		flag_wait( flag2 );
	}

	if( IsDefined( flag3 ) )
	{
		flag_wait( flag3 );
	}

	if( IsDefined( flag4 ) )
	{
		flag_wait( flag4 );
	}
}

/@
"Name: flag_wait_array( <a_flags> )"
"Summary: Waits until all of the flags in the array are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <a_flags> : array of flags to wait on"
"Example: flag_wait_any( array( "hq_cleared", "hq_destroyed", "hq_overrun", "hq_skipped" ) );"
"SPMP: singleplayer"
@/
flag_wait_array( a_flags )
{
	for ( i = 0; i < a_flags.size; i++ )
	{
		str_flag = a_flags[ i ];		
		if ( !flag( str_flag ) )
		{
			flag_wait( str_flag );
			i = -1; // start back at the begining
		}
	}
}

/@
"Name: flag_wait_or_timeout( <flagname> , <timer> )"
"Summary: Waits until either the flag gets set or the timer elapses."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer> : Amount of time to wait before continuing regardless of flag."
"Example: flag_wait_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
@/
flag_wait_or_timeout( flagname, timer )
{
	start_time = gettime();
	for( ;; )
	{
		if( level.flag[ flagname ] )
		{
			break;
		}

		if( gettime() >= start_time + timer * 1000 )
		{
			break;
		}

		wait_for_flag_or_time_elapses( flagname, timer );
	}
}

/@
"Name: flag_waitopen_or_timeout( <flagname> , <timer> )"
"Summary: Waits until either the flag gets cleared or the timer elapses."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer> : Amount of time to wait before continuing regardless of flag."
"Example: flag_waitopen_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
@/
flag_waitopen_or_timeout( flagname, timer )
{
	start_time = gettime();
	for( ;; )
	{
		if( !level.flag[ flagname ] )
		{
			break;
		}

		if( gettime() >= start_time + timer * 1000 )
		{
			break;
		}

		wait_for_flag_or_time_elapses( flagname, timer );
	}
}

/@
"Name: autosave_by_name( <savename> )"
"Summary: autosave the game with the specified save name"
"Module: Autosave"
"CallOn: "
"MandatoryArg: <savename> : name of the save file to create"
"Example: thread autosave_by_name( "building2_cleared" );"
"SPMP: singleplayer"
@/
autosave_by_name( name )
{
	thread autosave_by_name_thread( name );
}

//PARAMETER CLEANUP
autosave_by_name_thread( name/*, timeout*/ )
{
	if( !IsDefined( level.curAutoSave ) )
	{
		level.curAutoSave = 1;
	}

	imageName = "levelshots / autosave / autosave_" + level.script + level.curAutoSave;
	result = level maps\_autosave::try_auto_save( level.curAutoSave, /*"autosave",*/ imagename/*, timeout*/ );
	if( IsDefined( result ) && result )
	{
		level.curAutoSave++;
	}
}

/#
error( message )
{
	println( "^c * ERROR * ", message );
	wait 0.05;


	if( GetDebugDvar( "debug" ) != "1" )
	{
		assertmsg( message );
	}
}
#/
	
/#	
/@
"Name: debug_message( <message> , <origin>, <duration> )"
"Summary: Prints 3d debug text at the specified location for a duration of time."
"Module: Debug"
"MandatoryArg: <message>: String to print"
"MandatoryArg: <origin>: Location of string ( x, y, z )"
"OptionalArg: <duration>: Time to keep the string on screen. Defaults to 5 seconds."
"Example: debug_message( "I am the enemy", enemy.origin, 3.0 );"
"SPMP: singleplayer"
@/
debug_message( message, origin, duration )
{
	if( !IsDefined( duration ) )
	{
		duration = 5;
	}

	for( time = 0; time < ( duration * 20 );time ++ )
	{
		print3d( ( origin + ( 0, 0, 45 ) ), message, ( 0.48, 9.4, 0.76 ), 0.85 );
		wait 0.05;
	}
}

/@
"Name: debug_message_clear( <message> , <origin>, <duration>, <extraEndon> )"
"Summary: Prints 3d debug text at the specified location for a duration of time, but can be cleared before the normal time has passed if a notify occurs."
"Module: Debug"
"MandatoryArg: <message>: String to print"
"MandatoryArg: <origin>: Location of string ( x, y, z )"
"OptionalArg: <duration>: Time to keep the string on screen. Defaults to 5 seconds."
"OptionalArg: <extraEndon>: Level notify string that will make this text go away before the time expires."
"Example: debug_message( "I am the enemy", enemy.origin, 3.0, "enemy died" );"
"SPMP: singleplayer"
@/
debug_message_clear( message, origin, duration, extraEndon )
{
	if( IsDefined( extraEndon ) )
	{
		level notify( message + extraEndon );
		level endon( message + extraEndon );
	}
	else
	{
		level notify( message );
		level endon( message );
	}

	if( !IsDefined( duration ) )
	{
		duration = 5;
	}

	for( time = 0; time < ( duration * 20 );time ++ )
	{
		print3d( ( origin + ( 0, 0, 45 ) ), message, ( 0.48, 9.4, 0.76 ), 0.85 );
		wait 0.05;
	}
}


debugline(a, b, color)
{
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
}

debugorigin()
{
	//	self endon( "killanimscript" );
	//	self endon( anim.scriptChange );
	self notify( "Debug origin" );
	self endon( "Debug origin" );
	self endon( "death" );
	for( ;; )
	{
		forward = AnglesToForward( self.angles );
		forwardFar = VectorScale( forward, 30 );
		forwardClose = VectorScale( forward, 20 );
		right = AnglesToRight( self.angles );
		left = VectorScale( right, -10 );
		right = VectorScale( right, 10 );
		line( self.origin, self.origin + forwardFar, ( 0.9, 0.7, 0.6 ), 0.9 );
		line( self.origin + forwardFar, self.origin + forwardClose + right, ( 0.9, 0.7, 0.6 ), 0.9 );
		line( self.origin + forwardFar, self.origin + forwardClose + left, ( 0.9, 0.7, 0.6 ), 0.9 );
		wait( 0.05 );
	}
}
#/
	
precache( model )
{
	ent = spawn( "script_model", ( 0, 0, 0 ) );
	// SCRIPTER_MOD: dguzzo: 3-19-09 : no more level.player
	//	ent.origin = level.player getorigin();
	ent.origin = get_players()[0] getorigin();
	ent setmodel( model );
	ent delete();
}

closerFunc( dist1, dist2 )
{
	return dist1 >= dist2;
}

fartherFunc( dist1, dist2 )
{
	return dist1 <= dist2;
}

/@
"Name: getClosest( <org> , <array> , <dist> )"
"Summary: Returns the closest entity in < array > to location < org > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Minimum distance to check"
"Example: friendly = getclosest( get_players()[0].origin, allies );"
"SPMP: singleplayer"
@/
getClosest( org, array, dist )
{
	return compareSizes( org, array, dist, ::closerFunc );
}

/@
"Name: getFarthest( <org> , <array> , <dist> )"
"Summary: Returns the farthest entity in < array > to location < org > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be farthest from."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Maximum distance to check"
"Example: target = getFarthest( get_players()[0].origin, targets );"
"SPMP: singleplayer"
@/
getFarthest( org, array, dist )
{
	return compareSizes( org, array, dist, ::fartherFunc );
}

compareSizesFx( org, array, dist, compareFunc )
{
	if( !array.size )
	{
		return undefined;
	}
	if( IsDefined( dist ) )
	{
		struct = undefined;
		keys = getArrayKeys( array );
		for( i = 0; i < keys.size; i++ )
		{
			newdist = distance( array[ keys[ i ] ].v[ "origin" ], org );
			if( [[ compareFunc ]]( newDist, dist ) )
			{
				continue;
			}
			dist = newdist;
			struct = array[ keys[ i ] ];
		}
		return struct;
	}

	keys = getArrayKeys( array );
	struct = array[ keys[ 0 ] ];
	dist = distance( struct.v[ "origin" ], org );
	for( i = 1; i < keys.size; i++ )
	{
		newdist = distance( array[ keys[ i ] ].v[ "origin" ], org );
		if( [[ compareFunc ]]( newDist, dist ) )
		{
			continue;
		}
		dist = newdist;
		struct = array[ keys[ i ] ];
	}
	return struct;
}

compareSizes( org, array, dist, compareFunc )
{
	if( !array.size )
		return undefined;
	if( IsDefined( dist ) )
	{
		distSqr = dist * dist;
		ent = undefined;
		keys = GetArrayKeys( array );
		for( i = 0; i < keys.size; i ++ )
			{
			newdistSqr = DistanceSquared( array[ keys[ i ] ].origin, org );
			if( [[ compareFunc ]]( newdistSqr, distSqr ) )
				continue;
			distSqr = newdistSqr;
			ent = array[ keys[ i ] ];
		}
		return ent;
	}

	keys = GetArrayKeys( array );
	ent = array[ keys[ 0 ] ];
	distSqr = DistanceSquared( ent.origin, org );
	for( i = 1; i < keys.size; i ++ )
	{
		newdistSqr = DistanceSquared( array[ keys[ i ] ].origin, org );
		if( [[ compareFunc ]]( newdistSqr, distSqr ) )
			continue;
		distSqr = newdistSqr;
		ent = array[ keys[ i ] ];
	}
	return ent;
}

/@
"Name: get_closest_point( <origin> , <points> , <maxDist> )"
"Summary: Returns the closest point from array < points > from location < origin > "
"Module: Distance"
"CallOn: "
"MandatoryArg: <origin> : Origin to be closest to."
"MandatoryArg: <points> : Array of points to check distance on"
"OptionalArg: <maxDist> : Maximum distance to check"
"Example: target = getFarthest( get_players()[0].origin, targets );"
"SPMP: singleplayer"
@/
get_closest_point( origin, points, maxDist )
{
	assert( points.size );

	if (isdefined(maxdist))
	{
		maxdist = maxdist*maxdist;
	}

	closestPoint = points[ 0 ];
	
	
	distsq = Distancesquared( origin, closestPoint );

	for( index = 0; index < points.size; index ++ )
	{
		testDistsq = distancesquared( origin, points[ index ] );
		if( testDistsq >= distsq )
		{
			continue;
		}

		distsq = testDistsq;
		closestPoint = points[ index ];
	}

	if( !IsDefined( maxDist ) || distsq <= maxDist )
	{
		return closestPoint;
	}

	return undefined;
}


/@
"Name: get_within_range( <org> , <array> , <dist> )"
"Summary: Returns all elements from the array that are within DIST range to ORG."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Maximum distance to check"
"Example: close_ai = get_within_range( get_players()[0].origin, ai, 500 );"
"SPMP: singleplayer"
@/
get_within_range( org, array, dist )
{
	distsq = dist*dist;
	guys = [];
	for( i = 0; i < array.size; i++ )
	{
		if( distancesquared( array[ i ].origin, org ) <= distsq )
		{
			guys[ guys.size ] = array[ i ];
		}
	}
	return guys;
}

/@
"Name: get_outisde_range( <org> , <array> , <dist> )"
"Summary: Returns all elements from the array that are outside DIST range to ORG."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Maximum distance to check"
"Example: close_ai = get_outside_range( get_players()[0].origin, ai, 500 );"
"SPMP: singleplayer"
@/
get_outside_range( org, array, dist )
{
	distsq = dist*dist;
	guys = [];
	for( i = 0; i < array.size; i++ )
	{
		if( distancesquared( array[ i ].origin, org ) > distsq )
		{
			guys[ guys.size ] = array[ i ];
		}
	}
	return guys;
}

/@
"Name: get_closest_living( <org> , <array> , <dist> )"
"Summary: Returns the closest living entity from the array from the origin"
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on"
"OptionalArg: <dist> : Maximum distance to check"
"Example: kicker = get_closest_living( node.origin, ai );"
"SPMP: singleplayer"
@/
get_closest_living( org, array, dist )
{
	if( !IsDefined( dist ) )
	{
		dist = 9999999;
	}
	
	distsq = dist*dist;
	
	if( array.size < 1 )
	{
		return;
	}
	ent = undefined;
	for( i = 0;i < array.size;i++ )
	{
		if( !isalive( array[ i ] ) )
		{
			continue;
		}
		newdistsq = distancesquared( array[ i ].origin, org );
		if( newdistsq >= distsq )
		{
			continue;
		}
		distsq = newdistsq;
		ent = array[ i ];
	}
	return ent;
}

get_highest_dot( start, end, array )
{
	if( !array.size )
	{
		return;
	}

	ent = undefined;

	angles = VectorToAngles( end - start );
	dotforward = AnglesToForward( angles );
	dot = -1;
	for( i = 0;i < array.size;i++ )
	{
		angles = vectorToAngles( array[ i ].origin - start );
		forward = AnglesToForward( angles );

		newdot = VectorDot( dotforward, forward );
		if( newdot < dot )
		{
			continue;
		}
		dot = newdot;
		ent = array[ i ];
	}
	return ent;
}

/@
"Name: get_closest_index( <org> , <array> , <dist> )"
"Summary: same as getClosest but returns the closest entity's array index instead of the actual entity."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <dist> : Maximum distance to check"
"Example: "
"SPMP: singleplayer"
@/
get_closest_index( org, array, dist )
{
	if( !IsDefined( dist ) )
	{
		dist = 9999999;
	}
	distsq = dist*dist;
	if( array.size < 1 )
	{
		return;
	}
	index = undefined;
	for( i = 0;i < array.size;i++ )
	{
		newdistsq = distancesquared( array[ i ].origin, org );
		if( newdistsq >= distsq )
		{
			continue;
		}
		distsq = newdistsq;
		index = i;
	}
	return index;
}

get_farthest( org, array )
{
	if( array.size < 1 )
	{
		return;
	}

	distsq = Distancesquared( array[0].origin, org );
	ent = array[0];
	for( i = 1; i < array.size; i++ )
	{
		newdistsq = Distancesquared( array[i].origin, org );
		if( newdistsq <= distsq )
		{
			continue;
		}
		distsq = newdistsq;
		ent = array[i];
	}
	return ent;
}

/@
"Name: get_closest_ai( <org> , <team> )"
"Summary: Returns the closest AI of the specified team to the specified origin."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <team> : Team to use. Can be "allies", "axis", or "both"."
"Example: friendly = get_closest_ai( get_players()[0].origin, "allies" );"
"SPMP: singleplayer"
@/
get_closest_ai( org, team )
{
	if( IsDefined( team ) )
	{
		ents = GetAiArray( team );
	}
	else
	{
		ents = GetAiArray();
	}

	if( ents.size == 0 )
	{
		return undefined;
	}

	return getClosest( org, ents );
}

/@
"Name: get_array_of_closest( <org> , <array> , <excluders> , <max>, <maxdist> )"
"Summary: Returns an array of all the entities in < array > sorted in order of closest to farthest."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"OptionalArg: <maxdist> : Max distance from the origin to return acceptable entities"
"Example: allies_sort = get_array_of_closest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/
get_array_of_closest( org, array, excluders, max, maxdist )
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	
	DEFAULT( max, array.size );
	DEFAULT( excluders, [] );

	maxdists2rd = undefined;
	if ( IsDefined( maxdist ) )
	{
		maxdists2rd = maxdist * maxdist;
	}

	// return the array, reordered from closest to farthest
	dist = [];
	index = [];
	for ( i = 0; i < array.size; i++ )
	{
		if ( !IsDefined( array[ i ] ) )
		{
			continue;
		}
		
		if ( IsInArray( excluders, array[ i ] ) )
		{
			continue;
		}

		if ( IsVec( array[i] ) )
		{
			length = DistanceSquared( org, array[ i ] );
		}
		else
		{
			length = DistanceSquared( org, array[ i ].origin );
		}

		if ( IsDefined( maxdists2rd ) && maxdists2rd < length )
		{
			continue;
		}

		dist[ dist.size ] = length;
		index[ index.size ] = i;
	}

	for ( ;; )
	{
		change = false;
		for ( i = 0; i < dist.size - 1; i++ )
		{
			if ( dist[ i ] <= dist[ i + 1 ] )
			{
				continue;
			}
			
			change = true;
			temp = dist[ i ];
			dist[ i ] = dist[ i + 1 ];
			dist[ i + 1 ] = temp;
			temp = index[ i ];
			index[ i ] = index[ i + 1 ];
			index[ i + 1 ] = temp;
		}
		
		if ( !change )
		{
			break;
		}
	}

	newArray = [];
	if ( max > dist.size )
	{
		max = dist.size;
	}
	
	for ( i = 0; i < max; i++ )
	{
		newArray[ i ] = array[ index[ i ] ];
	}
	
	return newArray;
}


/@
"Name: get_array_of_farthest( <org> , <array> , <excluders> , <max> )"
"Summary: Returns an array of all the entities in < array > sorted in order of farthest to closest."
"MandatoryArg: <org> : Origin to be farthest from."
"MandatoryArg: <array> : Array of entities (anything that contain .origin) to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"Example: allies_sort = get_array_of_farthest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/
get_array_of_farthest( org, array, excluders, max )
{
	sorted_array = get_array_of_closest( org, array, excluders );
	
	if(IsDefined( max ))
	{
		temp_array = [];
		for( i=0; i < sorted_array.size; i++)
		{
			temp_array[temp_array.size] = sorted_array[sorted_array.size - i];
		}
		sorted_array = temp_array;
	}
	
	sorted_array = array_reverse( sorted_array );
		
	return( sorted_array );
}


/@
"Name: stop_magic_bullet_shield()"
"Summary: Stops magic bullet shield on an AI, setting his health back to a normal value and making him vulnerable to death."
"Module: AI"
"CallOn: AI"
"Example: friendly stop_magic_bullet_shield();"
"SPMP: singleplayer"
@/

stop_magic_bullet_shield( ent )
{
	DEFAULT( ent, self );
	
	if ( IsAI( ent ) )
	{
		ent BloodImpact( "normal" );
	}

	ent.attackerAccuracy = 1;	// TODO: restore old value if we need it.

	ent notify("stop_magic_bullet_shield");
	ent.magic_bullet_shield = undefined;
	ent._mbs = undefined;
}

/@
"Name: magic_bullet_shield()"
"Summary: Makes an AI invulnerable to death. When he gets shot, he is temporarily ignored by enemies."
"Module: AI"
"CallOn: AI"
"Example: guy magic_bullet_shield();"
"SPMP: singleplayer"
@/

magic_bullet_shield( ent )
{
	DEFAULT( ent, self );
	
	if ( !IS_TRUE( ent.magic_bullet_shield ) )
	{
		if ( IsAI( ent ) || IsPlayer( ent ) )
		{
			ent.magic_bullet_shield = true;

			/#
				level thread debug_magic_bullet_shield_death( ent );
			#/

			if ( !IsDefined( ent._mbs ) )
			{
				ent._mbs = SpawnStruct();
			}

			if ( IsAI( ent ) )
			{
				assert( IsAlive( ent ), "Tried to do magic_bullet_shield on a dead or undefined guy." );
				//assert( !ent.delayedDeath, "Tried to do magic_bullet_shield on a guy about to die." ); // no longer needed

				ent._mbs.last_pain_time = 0;
				ent._mbs.ignore_time = 2;
				ent._mbs.turret_ignore_time = 5;
				ent BloodImpact( "hero" );
			}

			ent.attackerAccuracy = 0.1;
		}
		else
		{
			if ( IS_VEHICLE( ent ) )
			{
				AssertMsg("Use veh_magic_bullet_shield for vehicles.");
			}
			else
			{
				AssertMsg("magic_bullet_shield does not support entity of classname '" + ent.classname + "'.");
			}
		}
	}
}

debug_magic_bullet_shield_death( guy )
{
	targetname = "none";
	if ( IsDefined( guy.targetname ) )
	{
		targetname = guy.targetname;
	}

	guy endon( "stop_magic_bullet_shield" );
	guy waittill( "death" );
	Assert( !IsDefined( guy ), "Guy died with magic bullet shield on with targetname: " + targetname );
}

/@
"Name: disable_long_death()"
"Summary: Disables long death on Self"
"Module: Utility"
"CallOn: An enemy AI"
"Example: level.zakhaev disable_long_death()"
"SPMP: singleplayer"
@/
disable_long_death()
{
	assert( isalive( self ), "Tried to disable long death on a non living thing" );
	self.a.disableLongDeath = true;
}

/@
"Name: enable_long_death()"
"Summary: Enables long death on Self"
"Module: Utility"
"CallOn: An enemy AI"
"Example: level.zakhaev enable_long_death()"
"SPMP: singleplayer"
@/
enable_long_death()
{
	assert( isalive( self ), "Tried to enable long death on a non living thing" );
	self.a.disableLongDeath = false;
}

/@
"Name: get_ignoreme()"
"Summary: Returns an actor's .ignoreme value"
"Module: AI"
"CallOn: an actor"
"Example: if( guy get_ignoreme() )..."
"SPMP: singleplayer"
@/
get_ignoreme()
{
	return self.ignoreme;
}

/@
"Name: set_ignoreme( <val> )"
"Summary: Sets an actor's .ignoreme value. If 'true', other entities will ignore him."
"Module: AI"
"CallOn: an actor"
"Example: guy set_ignoreme( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
set_ignoreme( val )
{
	assert( IsSentient( self ), "Non ai tried to set ignoreme" );
	self.ignoreme = val;
}

/@
"Name: set_ignoreall( <val> )"
"Summary: Sets an actor's .ignoreall value"
"Module: AI"
"CallOn: an actor"
"Example: guy set_ignoreall( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
set_ignoreall( val )
{
	assert( isSentient( self ), "Non ai tried to set ignoraell" );
	self.ignoreall = val;
}

/@
"Name: get_pacifist()"
"Summary: Returns an actor's .pacifist value"
"Module: AI"
"CallOn: an actor"
"Example: if( guy get_pacifist() )..."
"SPMP: singleplayer"
@/
get_pacifist()
{
	return self.pacifist;
}

/@
"Name: set_pacifist( <val> )"
"Summary: Sets an actor's .pacifist value. If 'true', he'll only fire back if fired upon first."
"Module: AI"
"CallOn: an actor"
"Example: guy set_pacifist( true );"
"MandatoryArg: <val> : Boolean"
"SPMP: singleplayer"
@/
set_pacifist( val )
{
	assert( IsSentient( self ), "Non ai tried to set pacifist" );
	self.pacifist = val;
}

turret_ignore_me_timer( time )
{
	self endon( "death" );
	self endon( "pain" );

	self.turretInvulnerability = true;
	wait time;
	self.turretInvulnerability = false;
}

exploder_damage()
{
	if( IsDefined( self.v[ "delay" ] ) )
	{
		delay = self.v[ "delay" ];
	}
	else
	{
		delay = 0;
	}

	if( IsDefined( self.v[ "damage_radius" ] ) )
	{
		radius = self.v[ "damage_radius" ];
	}
	else
	{
		radius = 128;
	}

	damage = self.v[ "damage" ];
	origin = self.v[ "origin" ];

	wait( delay );
	// Range, max damage, min damage
	self.model RadiusDamage( origin, radius, damage, damage / 3 );
}

exploder( num )
{
	[[ level.exploderFunction ]]( num );
	
/#
	//println ("Audio Debug - exploder " + num);
#/
}

exploder_before_load( num )
{
	// gotta wait twice because the createfx_init function waits once then inits all exploders. This guarentees
	// that if an exploder is run on the first frame, it happens after the fx are init.
	waittillframeend;
	waittillframeend;
	activate_exploder( num );
}

exploder_after_load( num )
{
	activate_exploder( num );
}

activate_exploder_on_clients(num)
{

	if(!IsDefined(level._exploder_ids[num]))
	{
		return;
	}

	if(!IsDefined(level._client_exploders[num]))
	{
		level._client_exploders[num] = 1;
	}

	if(!IsDefined(level._client_exploder_ids[num]))
	{
		level._client_exploder_ids[num] = 1;
	}

	ActivateClientExploder(level._exploder_ids[num]);
}

delete_exploder_on_clients(num)
{
	if(!IsDefined(level._exploder_ids[num]))
	{
		return;
	}


	if(!IsDefined(level._client_exploders[num]))
	{
		return;
	}

	level._client_exploders[num] = undefined;

	level._client_exploder_ids[num] = undefined;

	DeactivateClientExploder(level._exploder_ids[num]);
}

activate_exploder( num )
{
	num = int( num );
	level notify( "exploder" + num );
	
	/#
	// DLM - 2/1/2012 - Createfx should use older, less-optimized version of exploder activation since it creates new entities
	if (level.createFX_enabled)
	{
		for( i = 0;i < level.createFXent.size;i++ )
		{
			ent = level.createFXent[ i ];
			if( !IsDefined( ent ) )
			{
				continue;
			}
	
			if( ent.v[ "type" ] != "exploder" )
			{
				continue;
			}
	
			// make the exploder actually removed the array instead?
			if( !IsDefined( ent.v[ "exploder" ] ) )
			{
				continue;
			}
	
			if( ent.v[ "exploder" ] != num )
			{
				continue;
			}
	
			if(IsDefined(ent.v["exploder_server"]))
			{
				client_send = false;
			}
	
			ent activate_individual_exploder( num );
	
		}
		return;
	}
#/
	client_send = true;

	if(IsDefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{
			if(client_send && IsDefined(level.createFXexploders[num][i].v["exploder_server"]))
			{
				client_send = false;
			}
			
			level.createFXexploders[num][i] activate_individual_exploder( num );
		}
	}

	if(level.clientScripts)
	{
		if(!level.createFX_enabled && client_send == true)
		{
			activate_exploder_on_clients(num);
		}
	}

}

stop_exploder( num )
{
	num = int( num );
	/#
	// DLM - 2/1/2012 - Createfx should use older, less-optimized version of stopping exploders since it creates new entities
	if (level.createfx_enabled)
	{
		for( i = 0;i < level.createFXent.size;i++ )
		{
			ent = level.createFXent[ i ];
			if( !IsDefined( ent ) )
			{
				continue;
			}
	
			if( ent.v[ "type" ] != "exploder" )
			{
				continue;
			}
	
			// make the exploder actually removed the array instead?
			if( !IsDefined( ent.v[ "exploder" ] ) )
			{
				continue;
			}
	
			if( ent.v[ "exploder" ] != num )
			{
				continue;
			}
	
			if ( !IsDefined( ent.looper ) )
			{
				continue;
			}
	
			ent.looper delete();
		}
		return;
	}
#/
	if(level.clientScripts)
	{
		if(!level.createFX_enabled)
		{
			delete_exploder_on_clients(num);
		}
	}

	if(IsDefined(level.createFXexploders[num]))
	{
		for(i = 0; i < level.createFXexploders[num].size; i ++)
		{

			if ( !IsDefined( level.createFXexploders[num][i].looper ) )
			{
				continue;
			}

			level.createFXexploders[num][i].looper delete();
		}
	}
}

/@
"Name: activate_individual_exploder( num )"
"Summary: Activates an individual exploder, rather than all the exploders of a given number"
"Module: Utility"
"CallOn: An exploder"
"Example: exploder activate_individual_exploder( num );"
"SPMP: singleplayer"
@/

activate_individual_exploder( num )
{
	// CODER_MOD : DSL - Contents of if statement created on client.
	// GLocke (12/8/2008) - checking for self.v["exploder_server"] instead of self.exploder_server
	if(level.createFX_enabled || !level.clientScripts || !IsDefined(level._exploder_ids[num] ) || IsDefined(self.v["exploder_server"]))
	{
		/#
			println("Exploder " + num + " created on server.");
		#/
		
		if( IsDefined( self.v[ "firefx" ] ) )
		{
			self thread fire_effect();
		}

		if( IsDefined( self.v[ "fxid" ] ) && self.v[ "fxid" ] != "No FX" )
		{
			self thread cannon_effect();
		}
		else if( IsDefined( self.v[ "soundalias" ] ) )
		{
			self thread sound_effect();
		}

		if( IsDefined( self.v[ "earthquake" ] ) )
		{
			self thread exploder_earthquake();
		}

		if( IsDefined( self.v[ "rumble" ] ) )
		{
			self thread exploder_rumble();
		}
	}

	// CODER_MOD : DSL - Stuff below here happens on the server.

	if( IsDefined( self.v[ "trailfx" ] ) )
	{
		self thread trail_effect();
	}

	if( IsDefined( self.v[ "damage" ] ) )
	{
		self thread exploder_damage();
	}

	if( self.v[ "exploder_type" ] == "exploder" )
	{
		self thread brush_show();
	}
	else if( ( self.v[ "exploder_type" ] == "exploderchunk" ) || ( self.v[ "exploder_type" ] == "exploderchunk visible" ) )
	{
		self thread brush_throw();
	}
	else
	{
		self thread brush_delete();
	}
}

does_exploder_exist( n_exploder )
{
	if ( IsDefined( level.createFXexploders ) && IsDefined( level.createFXexploders[ n_exploder ] ) )
	{
		return true;
	}
	
	return false;
}


loop_sound_Delete( ender, ent )
{
	ent endon( "death" );
	self waittill( ender );
	ent Delete();
}

loop_fx_sound( alias, origin, ender, timeout )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	if( IsDefined( ender ) )
	{
		thread loop_sound_Delete( ender, org );
		self endon( ender );
	}
	org.origin = origin;
	org PlayLoopSound( alias );
	if( !IsDefined( timeout ) )
	{
		return;
	}

	wait( timeout );
	//	org Delete();
}

brush_delete()
{
	// 		if( ent.v[ "exploder_type" ] != "normal" && !IsDefined( ent.v[ "fxid" ] ) && !IsDefined( ent.v[ "soundalias" ] ) )
	// 		if( !IsDefined( ent.script_fxid ) )

	num = self.v[ "exploder" ];
	if( IsDefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}
	else
	{
		wait( .05 );// so it disappears after the replacement appears
	}

	if( !IsDefined( self.model ) )
	{
		return;
	}

	assert( IsDefined( self.model ) );

	if( self.model has_spawnflag( SPAWNFLAG_MODEL_DYNAMIC_PATH ) )
	{
		self.model ConnectPaths();
	}

//	if( level.createFX_enabled )
//	{
//		if( IsDefined( self.exploded ) )
//		{
//			return;
//		}
//
//		self.exploded = true;
//		self.model Hide();
//		self.model NotSolid();
//
//		wait( 3 );
//		self.exploded = undefined;
//		self.model Show();
//		self.model Solid();
//		return;
//	}

	if( !IsDefined( self.v[ "fxid" ] ) || self.v[ "fxid" ] == "No FX" )
	{
		self.v[ "exploder" ] = undefined;
	}

	waittillframeend;// so it hides stuff after it shows the new stuff
	self.model Delete();
}

brush_Show()
{
	if( IsDefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}

	assert( IsDefined( self.model ) );

	self.model Show();
	self.model Solid();

	if( self.model has_spawnflag( SPAWNFLAG_MODEL_DYNAMIC_PATH ) )
	{
		if( !IsDefined( self.model.disconnect_paths ) )
		{
			self.model ConnectPaths();
		}
		else
		{
			self.model DisconnectPaths();
		}
	}

//	if( level.createFX_enabled )
//	{
//		if( IsDefined( self.exploded ) )
//		{
//			return;
//		}
//
//		self.exploded = true;
//		wait( 3 );
//		self.exploded = undefined;
//		self.model Hide();
//		self.model NotSolid();
//	}
}

brush_throw()
{
	if( IsDefined( self.v[ "delay" ] ) )
	{
		wait( self.v[ "delay" ] );
	}

	ent = undefined;
	if( IsDefined( self.v[ "target" ] ) )
	{
		ent = getent( self.v[ "target" ], "targetname" );
	}

	if( !IsDefined( ent ) )
	{
		ent = GetStruct( self.v["target"], "targetname" );

		if( !IsDefined( ent ) )
		{
			self.model Delete();
			return;
		}
	}

	self.model Show();

	startorg = self.v[ "origin" ];
	startang = self.v[ "angles" ];
	org = ent.origin;


	temp_vec = ( org - self.v[ "origin" ] );
	x = temp_vec[ 0 ];
	y = temp_vec[ 1 ];
	z = temp_vec[ 2 ];

	physics = IsDefined( self.v[ "physics" ] );
	if ( physics )
	{
		target = undefined;
		if ( IsDefined( ent.target ) )
		{
			target = getent( ent.target, "targetname" );
		}

		if ( !IsDefined( target ) )
		{
			contact_point = startorg;// no spin just push it.
			throw_vec = ent.origin;
		}
		else
		{
			contact_point = ent.origin;
			throw_vec = VectorScale(target.origin - ent.origin, self.v[ "physics" ]);

		}

		// 		model = spawn( "script_model", startorg );
		// 		model.angles = startang;
		// 		model physicslaunch( model.origin, temp_vec );
		self.model physicslaunch( contact_point, throw_vec );
		return;
	}
	else
	{
		self.model RotateVelocity( ( x, y, z ), 12 );
		self.model moveGravity( ( x, y, z ), 12 );
	}


//	if( level.createFX_enabled )
//	{
//		if( IsDefined( self.exploded ) )
//		{
//			return;
//		}
//
//		self.exploded = true;
//		wait( 3 );
//		self.exploded = undefined;
//		self.v[ "origin" ] = startorg;
//		self.v[ "angles" ] = startang;
//		self.model Hide();
//		return;
//	}

	self.v[ "exploder" ] = undefined;
	wait( 6 );
	self.model Delete();
	//	self Delete();
}

shock_onpain()
{
	self endon( "death" );
	self endon( "disconnect" );

	if( GetDvar( "blurpain" ) == "" )
	{
		SetDvar( "blurpain", "on" );
	}

	while( 1 )
	{
		oldhealth = self.health;
		self waittill( "damage", damage, attacker, direction_vec, point, mod );

		if( IsDefined( level.shock_onpain ) && !level.shock_onpain )
		{
			continue;
		}

		if( IsDefined( self.shock_onpain ) && !self.shock_onpain )
		{
			continue;
		}

		if( self.health < 1 )
		{
			continue;
		}

		if( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" )
		{
			continue;
		}
		else if( mod == "MOD_GRENADE_SPLASH" || mod == "MOD_GRENADE" ||  mod == "MOD_EXPLOSIVE" )
		{
			self shock_onexplosion( damage );
		}
		else
		{
			if( GetDvar( "blurpain" ) == "on" )
			{
				self ShellShock( "pain", 0.5 );
			}
		}
	}
}

shock_onexplosion( damage )
{
	time = 0;

	multiplier = self.maxhealth / 100;
	scaled_damage = damage * multiplier;

	if( scaled_damage >= 90 )
	{
		time = 4;
	}
	else if( scaled_damage >= 50 )
	{
		time = 3;
	}
	else if( scaled_damage >= 25 )
	{
		time = 2;
	}
	else if( scaled_damage > 10 )
	{
		time = 1;
	}

	if( time )
	{
		self ShellShock( "explosion", time );
	}
}

shock_ondeath()
{
	// CODE_MOD
	// moved to _load::main so hot joiners would not try and
	// precache mid game
	//precacheShellshock( "default" );
	self waittill( "death" );

	if( IsDefined( level.shock_ondeath ) && !level.shock_ondeath )
	{
		return;
	}

	if( IsDefined( self.shock_ondeath ) && !self.shock_ondeath )
	{
		return;
	}

	if( IsDefined( self.specialDeath ) )
	{
		return;
	}

	if( GetDvar( "r_texturebits" ) == "16" )
	{
		return;
	}
	//self shellshock( "default", 3 );
}

delete_on_death( ent )
{
	ent endon( "death" );
	self waittill( "death" );
	if( IsDefined( ent ) )
	{
		ent delete();
	}
}


delete_on_death_wait_sound( ent, sounddone )
{
	ent endon( "death" );
	self waittill( "death" );
	if( IsDefined( ent ) )
	{
		if ( ent iswaitingonsound() )
		{
			ent waittill( sounddone );
		}

		ent Delete();
	}
}

/@
"Name: is_dead_sentient()"
"Summary: Checks to see if the AI is not defined, not sentient, and dead"
"CallOn: AI"
"MandatoryArg: <suspect> The AI you're checking to see is dead."
"Example: if ( is_dead_sentient( self ) )"
"SPMP: singleplayer"
@/
is_dead_sentient()
{
	if ( IsSentient( self ) && !IsAlive( self ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/@
"Name: is_alive_sentient()"
"Summary: Checks to see if the AI is defined, sentient, and alive"
"CallOn: AI"
"MandatoryArg: <suspect> The AI you're checking to see is alive."
"Example: if ( !e_dude is_alive_sentient() )"
"SPMP: singleplayer"
@/
is_alive_sentient()
{
	if ( IsAlive( self ) && IsSentient( self ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/@
"Name: is_alive( <ent> )"
"Summary: Checks to see if the entity is alive and not a corpse if a vehicle."
"CallOn: AI"
"MandatoryArg: <ent> The entity you're checking to see is alive."
"Example: if ( !is_alive( e_dude ) )"
"SPMP: singleplayer"
@/
is_alive( ent )
{
	return ( ( !is_corpse( ent ) ) && ( IsAlive( ent ) ) );
}

/@
"Name: is_corpse( <veh> )"
"Summary: Checks to see if a vehicle is a corpse."
"CallOn: AI"
"MandatoryArg: <veh> The vehicle you're checking to see is a corpse."
"Example: if ( !is_corpse( veh_truck ) )"
"SPMP: singleplayer"
@/
is_corpse( veh )
{
	if ( IsDefined( veh ) )
	{
		if ( is_true( veh.isacorpse ) )
		{
			return true;
		}
		else if ( IsDefined( veh.classname ) && ( veh.classname == "script_vehicle_corpse" ) )
		{
			return true;
		}
	}

	return false;
}

/@
"Name: play_sound_on_tag( <alias> , <tag>, <ends_on_death> )"
"Summary: Play the specified sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to play"
"OptionalArg: <tag> : Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"OptionalArg: <ends_on_death> : The sound will be cut short if the entity dies. Defaults to false."
"Example: vehicle thread play_sound_on_tag( "horn_honk", "tag_engine" );"
"SPMP: singleplayer"
@/
play_sound_on_tag( alias, tag, ends_on_death )
{
	if ( is_dead_sentient() )
	{
		return;
	}

	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );

	thread delete_on_death_wait_sound( org, "sounddone" );
	if ( IsDefined( tag ) )
	{
		org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}

	org PlaySound( alias, "sounddone" );
	if ( IsDefined( ends_on_death ) )
	{
		assert( ends_on_death, "ends_on_death must be true or undefined" );
		wait_for_sounddone_or_death( org );
		if(is_dead_sentient())
		{
			org StopSounds();
		}
		wait( 0.05 ); // stopsounds doesnt work if the org is deleted same frame
	}
	else
	{
		org waittill( "sounddone" );
	}
	org Delete();
}


/@
"Name: play_sound_on_tag_endon_death( <alias>, <tag> )"
"Summary: Play the specified sound alias on a tag of an entity but gets cut short if the entity dies"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to play"
"OptionalArg: <tag> : Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"Example: vehicle thread play_sound_on_tag_endon_death( "horn_honk", "tag_engine" );"
"SPMP: singleplayer"
@/
play_sound_on_tag_endon_death( alias, tag )
{
	play_sound_on_tag( alias, tag, true );
}

/@
"Name: play_sound_on_entity( <alias> )"
"Summary: Play the specified sound alias on an entity at it's origin"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to play"
"Example: guy play_sound_on_entity( "breathing_better" );"
"SPMP: singleplayer"
@/
play_sound_on_entity( alias )
{
	play_sound_on_tag( alias );
}

/@
"Name: play_loop_sound_on_tag( <alias> , <tag>, bStopSoundOnDeath )"
"Summary: Play the specified looping sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to loop"
"OptionalArg: <tag> : Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"OptionalArg: <bStopSoundOnDeath> : Defaults to true. If true, will stop the looping sound when self dies"
"Example: vehicle thread play_loop_sound_on_tag( "engine_belt_run", "tag_engine" );"
"SPMP: singleplayer"
@/
play_loop_sound_on_tag( alias, tag, bStopSoundOnDeath )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	if ( !IsDefined( bStopSoundOnDeath ) )
	{
		bStopSoundOnDeath = true;
	}
	if ( bStopSoundOnDeath )
	{
		thread delete_on_death( org );
	}
	if( IsDefined( tag ) )
	{
		org LinkTo( self, tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}
	//	org endon( "death" );
	org PlayLoopSound( alias );
	//	println( "playing loop sound ", alias, " on entity at origin ", self.origin, " at ORIGIN ", org.origin );
	self waittill( "stop sound" + alias );
	org StopLoopSound( alias );
	org Delete();
}

/@
"Name: stop_loop_sound_on_entity( <alias> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to stop looping"
"Example: vehicle thread stop_loop_sound_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
@/
stop_loop_sound_on_entity( alias )
{
	self notify( "stop sound" + alias );
}

/@
"Name: play_loop_sound_on_entity( <alias> , <offset> )"
"Summary: Play loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias> : Sound alias to loop"
"OptionalArg: <offset> : Offset for sound origin relative to the world from the models origin."
"Example: vehicle thread play_loop_sound_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
@/
play_loop_sound_on_entity( alias, offset )
{
	org = Spawn( "script_origin", ( 0, 0, 0 ) );
	org endon( "death" );
	thread delete_on_death( org );
	if( IsDefined( offset ) )
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org LinkTo( self );
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org LinkTo( self );
	}
	//	org endon( "death" );
	org PlayLoopSound( alias );
	//	println( "playing loop sound ", alias, " on entity at origin ", self.origin, " at ORIGIN ", org.origin );
	self waittill( "stop sound" + alias );
	org StopLoopSound( 0.1 );
	org Delete();
}

/@
"Name: play_sound_in_space( <alias> , <origin> , <master> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <alias> : Sound alias to play"
"MandatoryArg: <origin> : Origin of the sound"
"OptionalArg: <master> : Play this sound as a master sound. Defaults to false"
"Example: play_sound_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
@/
play_sound_in_space( alias, origin, master )
{
	org = Spawn( "script_origin", ( 0, 0, 1 ) );

	if( !IsDefined( origin ) )
	{
		origin = self.origin;
	}
	org.origin = origin;
	if( IsDefined( master ) && master )
	{
		org PlaySoundAsMaster( alias, "sounddone" );
	}
	else
	{
		org PlaySound( alias, "sounddone" );
	}
	org waittill( "sounddone" );

	// 5/29/08 - guzzo added b/c sometimes org can undefined and will cause a crash when it's deleted
	if( IsDefined( org ) )
	{
		org Delete();
	}

}

/@
"Name: spawn_failed( <spawn> )"
"Summary: Checks to see if the spawned AI spawned correctly or had errors. Also waits until all spawn initialization is complete. Returns true or false."
"Module: AI"
"CallOn: "
"MandatoryArg: <spawn> : The actor that just spawned"
"Example: spawn_failed( level.price );"
"SPMP: singleplayer"
@/
spawn_failed( spawn )
{
	if ( IsAlive( spawn ) )
	{
		if ( !IsDefined( spawn.finished_spawning ) )
		{
			spawn waittill("finished spawning");
		}

		waittillframeend;

		if ( IsAlive( spawn ) )
		{
			return false;
		}
	}

	return true;
}

spawn_setcharacter( data )
{
	codescripts\character::precache( data );

	self waittill( "spawned", spawn );
	if( maps\_utility::spawn_failed( spawn ) )
	{
		return;
	}

	/#println( "Size is ", data[ "attach" ].size );#/
	spawn codescripts\character::new();
	spawn codescripts\character::load( data );
}

/@
"Name: assign_animtree( [animname] )"
"Summary: Assigns the level.scr_animtree for the given animname to self."
"Module: Animation"
"OptionalArg: [animname] : You can optionally assign the animname for self at this juncture."
"Example: model = assign_animtree( "whatever" );"
"SPMP: singleplayer"
@/

assign_animtree( animname, animtree_override )
{
	animtree = animtree_override;
	if ( !IsDefined( animtree ) )
	{
		if( IsDefined( animname ) )
		{
			self.animname = animname;
		}
	
		assert( IsDefined( level.scr_animtree[ self.animname ] ), "There is no level.scr_animtree for animname " + self.animname );
	
		animtree = level.scr_animtree[ self.animname ];
	}
	
	self UseAnimTree( animtree );
}

assign_model( str_animname )
{
	if ( !IsDefined( str_animname ) )
	{
		str_animname = self.animname;
	}
	
	Assert( IsDefined( level.scr_model[ str_animname ] ), "There is no level.scr_model for animname " + str_animname );
	self SetModel( level.scr_model[ str_animname ] );
}

/@
"Name: spawn_anim_model( <animname>, [origin], [angles], [is_simple_prop] )"
"Summary: Spawns a script model and gives it the animtree and model associated with that animname"
"Module: Animation"
"MandatoryArg: <animname> : Name of the animname from this map_anim.gsc."
"OptionalArg: [origin] : Optional origin."
"OptionalArg: [anlges] : Optional angles."
"OptionalArg: [is_simple_prop] : Indicates this model doesn't have a skeleton and only the origin is animated (and needs special handling)"
"Example: model = spawn_anim_model( "player_rappel" );"
"SPMP: singleplayer"
@/
spawn_anim_model( str_animname, origin = (0, 0, 0), angles = (0, 0, 0), is_simple_prop )
{
	model = spawn( "script_model", origin );
	model.angles = angles;

	model assign_model( str_animname );
	model init_anim_model( str_animname, is_simple_prop );

	return model;
}

/@
"Name: init_anim_model( [animname], [is_simple_prop] )"
"Summary: inits a model to be used in a scripted animation."
"Module: Animation"
"OptionalArg: [animname] : Optional animname to use, else uses self.animname."
"OptionalArg: [is_simple_prop] : Indicates this model doesn't have a skeleton and only the origin is animated (and needs special handling)."
"Example: model init_anim_model();"
"SPMP: singleplayer"
@/
init_anim_model( animname, is_simple_prop = false, animtree_override )
{
	DEFAULT( animname, self.animname );

	assert( IsDefined( animname ), "Trying to init anim model with no animname.");

	self.animname = animname;

	if ( is_simple_prop )
	{
		if ( !IsDefined( self.anim_link ) )
		{
			self.anim_link = Spawn( "script_model", self.origin );
			self.anim_link SetModel( "tag_origin_animate" );

			level thread delete_anim_link_on_death( self, self.anim_link );

			// TODO: cleanup when animation is finished?
		}

		self.anim_link.animname = animname;
		self.anim_link assign_animtree( animname, animtree_override );

		self Unlink();

		self.anim_link.angles = self.angles;
		self.anim_link.origin = self.origin;

		self LinkTo( self.anim_link, "origin_animate_jnt" );
	}
	else
	{
		self assign_animtree( self.animname, animtree_override );
	}
}

delete_anim_link_on_death(ent, anim_link)
{
	anim_link endon("death");
	ent waittill("death");
	anim_link Delete();
}

triggerOff()
{
	if (!isdefined (self.realOrigin))
	{
		self.realOrigin = self.origin;
	}

	if (self.origin == self.realorigin)
	{
		self.origin += (0, 0, -10000);
	}
}

triggerOn()
{
	if (isDefined (self.realOrigin) )
	{
		self.origin = self.realOrigin;
	}
}

/@
"Name: set_flag_on_notify( <notifyStr> , <strFlag> )"
"Summary: Calls flag_set to set the specified flag when the notify is recieved on the parent entity"
"Module: Flag"
"CallOn: "
"MandatoryArg: <notifyStr> : notify to wait on"
"MandatoryArg: <strFlag> : name of the flag to set"
"Example: vehicle thread set_flag_on_notify( "dead", "he_is_dead_flag" );"
"SPMP: singleplayer"
@/
set_flag_on_notify( notifyStr, strFlag )
{
	if ( notifyStr != "death" )
	{
		self endon( "death" );
	}
	
	if( !level.flag[ strFlag ] )
	{
		self waittill( notifyStr );
		flag_set( strFlag );
	}
}

/@
"Name: set_flag_on_trigger( <eTrigger> , <strFlag> )"
"Summary: Calls flag_set to set the specified flag when the trigger is triggered"
"Module: Flag"
"CallOn: "
"MandatoryArg: <eTrigger> : trigger entity to use"
"MandatoryArg: <strFlag> : name of the flag to set"
"Example: set_flag_on_trigger( trig, "player_is_outside" );"
"SPMP: singleplayer"
@/
set_flag_on_trigger( eTrigger, strFlag )
{
	if( !level.flag[ strFlag ] )
	{
		eTrigger waittill( "trigger", eOther );
		flag_set( strFlag );
		return eOther;
	}
}

/@
"Name: set_flag_on_targetname_trigger( <flag> )"
"Summary: Sets the specified flag when a trigger with targetname < flag > is triggered."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flag> : name of the flag to set, and also the targetname of the trigger to use"
"Example:  set_flag_on_targetname_trigger( "player_is_outside" );"
"SPMP: singleplayer"
@/
set_flag_on_targetname_trigger( msg )
{
	assert( IsDefined( level.flag[ msg ] ) );
	if( flag( msg ) )
	{
		return;
	}

	trigger = GetEnt( msg, "targetname" );
	trigger waittill( "trigger" );
	flag_set( msg );
}

/@
"Name: waittill_dead( <guys> , <num> , <timeoutLength> )"
"Summary: Waits until all the AI in array < guys > are dead."
"Module: AI"
"CallOn: "
"MandatoryArg: <guys> : Array of actors to wait until dead"
"OptionalArg: <num> : Number of guys that must die for this function to continue"
"OptionalArg: <timeoutLength> : Number of seconds before this function times out and continues"
"Example: waittill_dead( getaiarray( "axis" ) );"
"SPMP: singleplayer"
@/
waittill_dead( guys, num, timeoutLength )
{
	// verify the living - ness of the ai
	allAlive = true;
	for( i = 0;i < guys.size;i++ )
	{
		if( isalive( guys[ i ] ) )
		{
			continue;
		}
		allAlive = false;
		break;
	}
	assert( allAlive, "Waittill_Dead was called with dead or removed AI in the array, meaning it will never pass." );
	if( !allAlive )
	{
		newArray = [];
		for( i = 0;i < guys.size;i++ )
		{
			if( isalive( guys[ i ] ) )
			{
				newArray[ newArray.size ] = guys[ i ];
			}
		}
		guys = newArray;
	}

	ent = SpawnStruct();
	if( IsDefined( timeoutLength ) )
	{
		ent endon( "thread_timed_out" );
		ent thread waittill_dead_timeout( timeoutLength );
	}

	ent.count = guys.size;
	if( IsDefined( num ) && num < ent.count )
	{
		ent.count = num;
	}
	array_thread( guys, ::waittill_dead_thread, ent );

	while( ent.count > 0 )
	{
		ent waittill( "waittill_dead guy died" );
	}
}

/@
"Name: waittill_dead_or_dying( <guys> , <num> , <timeoutLength> )"
"Summary: Similar to waittill_dead(). Waits until all the AI in array < guys > are dead OR dying (long deaths)."
"Module: AI"
"CallOn: "
"MandatoryArg: <guys> : Array of actors to wait until dead or dying"
"OptionalArg: <num> : Number of guys that must die or be dying for this function to continue"
"OptionalArg: <timeoutLength> : Number of seconds before this function times out and continues"
"Example: waittill_dead_or_dying( getaiarray( "axis" ) );"
"SPMP: singleplayer"
@/
waittill_dead_or_dying( guys, num, timeoutLength )
{
	// verify the living - ness and healthy - ness of the ai
	newArray = [];
	for( i = 0;i < guys.size;i++ )
	{
		if( isalive( guys[ i ] ) && !guys[ i ].ignoreForFixedNodeSafeCheck )
		{
			newArray[ newArray.size ] = guys[ i ];
		}
	}
	guys = newArray;

	ent = spawnStruct();
	if( IsDefined( timeoutLength ) )
	{
		ent endon( "thread_timed_out" );
		ent thread waittill_dead_timeout( timeoutLength );
	}

	ent.count = guys.size;

	// optional override on count
	if( IsDefined( num ) && num < ent.count )
	{
		ent.count = num;
	}

	array_thread( guys, ::waittill_dead_or_dying_thread, ent );

	while( ent.count > 0 )
	{
		ent waittill( "waittill_dead_guy_dead_or_dying" );
	}
}

waittill_dead_thread( ent )
{
	self waittill( "death" );
	ent.count-- ;
	ent notify( "waittill_dead guy died" );
}

waittill_dead_or_dying_thread( ent )
{
	self waittill_either( "death", "pain_death" );
	ent.count-- ;
	ent notify( "waittill_dead_guy_dead_or_dying" );
}

waittill_dead_timeout( timeoutLength )
{
	wait( timeoutLength );
	self notify( "thread_timed_out" );
}

/@
"Name: set_ai_group_cleared_count( <aigroup>, <count> )"
"Summary: Sets how many guys left in an aigroup for it to be "cleared"."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"MandatoryArg: <count> : How many guys/spawners are left when cleared."
"Example: set_ai_group_cleared_count( "room_1_guys", 2 ); // cleared when 2 guys are left"
"SPMP: singleplayer"
@/
set_ai_group_cleared_count(aigroup, count)
{
	maps\_spawner::aigroup_init(aigroup);
	level._ai_group[aigroup].cleared_count = count;
}

/@
"Name: waittill_ai_group_cleared( <aigroup> )"
"Summary: Waits until all of an AI group is cleared, including alive guys and spawners. If any spawners have a count greater than 0, this will continue to wait."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_cleared( "room_1_guys" );"
"SPMP: singleplayer"
@/
waittill_ai_group_cleared( aigroup )
{
	assert(IsDefined(level._ai_group[aigroup]), "The aigroup "+aigroup+" does not exist");
	flag_wait(aigroup + "_cleared");
}

/@
"Name: waittill_ai_group_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's count is equal to or lower than the specified number. The group's count is made up of the sum of its spawner counts and the number of alive guys in the group"
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
waittill_ai_group_count( aigroup, count )
{
	while ( get_ai_group_spawner_count( aigroup ) + level._ai_group[ aigroup ].aicount > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_ai_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's AI count is equal to or lower than the specified number. Only alive guys are counted (spawner counts are not counted)."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_ai_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
waittill_ai_group_ai_count( aigroup, count )
{
	while( level._ai_group[ aigroup ].aicount > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_spawner_count( <aigroup>, <count> )"
"Summary: Waits until an AI group's spawner count is equal to or lower than the specified number. Only spawner counts are counted (alive AI are not counted)."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_spawner_count( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
waittill_ai_group_spawner_count( aigroup, count )
{
	while ( get_ai_group_spawner_count( aigroup ) > count )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: waittill_ai_group_amount_killed( <aigroup>, <amount_killed> )"
"Summary: Waits until a certain number of members an AI group are killed."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: waittill_ai_group_amount_killed( "room_1_guys", 3 );"
"SPMP: singleplayer"
@/
waittill_ai_group_amount_killed( aigroup, amount_killed )
{
	while ( level._ai_group[ aigroup ].killed_count < amount_killed )
	{
		level._ai_group[ aigroup ] waittill( "update_aigroup" );
	}
}

/@
"Name: get_ai_group_count( <aigroup> )"
"Summary: Returns the integer sum of alive AI count and spawner count for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: if( get_ai_group_count( "room_1_guys" ) < 3 )..."
"SPMP: singleplayer"
@/
get_ai_group_count( aigroup )
{
	return( get_ai_group_spawner_count( aigroup ) + level._ai_group[ aigroup ].aicount );
}

/@
"Name: get_ai_group_sentient_count( <aigroup> )"
"Summary: Returns integer of the alive AI count for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: if( get_ai_group_sentient_count( "room_1_guys" ) < 3 )..."
"SPMP: singleplayer"
@/
get_ai_group_sentient_count( aigroup )
{
	return( level._ai_group[ aigroup ].aicount );
}

get_ai_group_spawner_count( aigroup )
{
	n_count = 0;
	foreach ( sp in level._ai_group[ aigroup ].spawners )
	{
		if ( IsDefined( sp ) )
		{
			n_count += sp.count;
		}
	}
	return n_count;
}

/@
"Name: get_ai_group_ai( <aigroup> )"
"Summary: Returns an array of the alive AI for this group."
"Module: AI"
"MandatoryArg: <aigroup> : The AI group"
"Example: room_1_guys = get_ai_group_ai( "room_1_guys" );"
"SPMP: singleplayer"
@/
get_ai_group_ai( aigroup )
{
	aiSet = [];
	for( index = 0; index < level._ai_group[ aigroup ].ai.size; index ++ )
	{
		if( !isAlive( level._ai_group[ aigroup ].ai[ index ] ) )
		{
			continue;
		}

		aiSet[ aiSet.size ] = level._ai_group[ aigroup ].ai[ index ];
	}

	return( aiSet );
}

/@
"Name: get_ai( <name> , <type> )"
"Summary: Returns single spawned ai in the level of <name> and <type>. Error if used on more than one ai with same name and type "
"Module: AI"
"CallOn: "
"MandatoryArg: <name> : the value of the targetname or script_noteworthy of the ai"
"MandatoryArg: <type> : valid types are targetname and script_noteworthy"
"Example: patroller = get_ai( "patrol", "script_noteworthy" );"
"SPMP: singleplayer"
@/
get_ai( name, type )
{
	array = get_ai_array( name, type );
	if( array.size > 1 )
	{
		assertMsg( "get_ai used for more than one living ai of type " + type + " called " + name + "." );
		return undefined;
	}
	return array[0];
}

/@
"Name: get_ai_array( <name> , <type> )"
"Summary: Returns array of spawned ai in the level of <name> and <type> "
"Module: AI"
"CallOn: "
"MandatoryArg: <name> : the value of the targetname or script_noteworthy of the ai"
"OptionalArg: <type> : valid types are targetname, classname and script_noteworthy.  Default to script_noteworthy"
"Example: patrollers = get_ai_array( "patrol", "script_noteworthy" );"
"SPMP: singleplayer"
@/
get_ai_array(name, type = "script_noteworthy" )
{
	ai = GetAIArray();
	
	array = [];
	for(i=0; i<ai.size; i++)
	{
		switch(type)
		{
		case "targetname":

			if(IsDefined(ai[i].targetname) && ai[i].targetname == name)
			{
				array[array.size] = ai[i];
			}
			break;

		case "script_noteworthy":

			if(IsDefined(ai[i].script_noteworthy) && ai[i].script_noteworthy == name)
			{
				array[array.size] = ai[i];
			}
			break;

		case "classname":

			if(IsDefined(ai[i].classname) && ai[i].classname == name)
			{
				array[array.size] = ai[i];
			}
			break;
			
		case "script_string":

			if(IsDefined(ai[i].script_string) && ai[i].script_string == name)
			{
				array[array.size] = ai[i];
			}
			break;

		}
	}
	return array;
}

set_environment( env )
{
	animscripts\utility::setEnv( env );
}


waittill_either( msg1, msg2 )
{
	self endon( msg1 );
	self waittill( msg2 );
}



/@
"Name: flat_angle( <angle> )"
"Summary: Returns the specified angle as a flat angle.( 45, 90, 30 ) becomes( 0, 90, 0 ). Useful if you just need an angle around Y - axis."
"Module: Vector"
"CallOn: "
"MandatoryArg: <angle> : angles to flatten"
"Example: yaw = flat_angle( node.angles );"
"SPMP: singleplayer"
@/
flat_angle( angle )
{
	rangle = ( 0, angle[ 1 ], 0 );
	return rangle;
}
/*
/@
"Name: flat_origin( <org> )"
"Summary: Returns a flat origin of the specified origin. Moves Z cordinate to 0.( x, y, z ) becomes( x, y, 0 )"
"Module: Vector"
"CallOn: "
"MandatoryArg: <org> : origin to flatten"
"Example: org = flat_origin( self.origin );"
"SPMP: singleplayer"
@/
flat_origin( org )
{
	rorg = ( org[ 0 ], org[ 1 ], 0 );
	return rorg;

}
*/
/#
plot_points( plotpoints, r, g, b, timer )
{
	lastpoint = plotpoints[ 0 ];
	if( !IsDefined( r ) )
	{
		r = 1;
	}
	if( !IsDefined( g ) )
	{
		g = 1;
	}
	if( !IsDefined( b ) )
	{
		b = 1;
	}
	if( !IsDefined( timer ) )
	{
		timer = 0.05;
	}
	for( i = 1;i < plotpoints.size;i++ )
	{
		thread draw_line_for_time( lastpoint, plotpoints[ i ], r, g, b, timer );
		lastpoint = plotpoints[ i ];
	}
}
#/
/#
/@
"Name: draw_line_for_time( <org1> , <org2> , <r> , <g> , <b> , <timer> )"
"Summary: Draws a line from < org1 > to < org2 > in the specified color for the specified duration"
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1> : starting origin for the line"
"MandatoryArg: <org2> : ending origin for the line"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <timer> : time in seconds the line should last"
"Example: thread draw_line_for_time( player.origin, vehicle.origin, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
@/
draw_line_for_time( org1, org2, r, g, b, timer )
{
	timer = gettime() + ( timer * 1000 );
	while( GetTime() < timer )
	{
		line( org1, org2, ( r, g, b ), 1 );
		RecordLine( org1, org2, (1,1,1), "Script" ); 
		wait .05;
	}

}

/@
"Name: draw_point( <org> , <scale>, <color>, <timer> )"
"Summary: Draws a point at <org> in the specified color for the specified duration"
"Module: Debug"
"CallOn: "
"MandatoryArg: <org> : starting origin for the line"
"MandatoryArg: <scale> : scalar of point"
"MandatoryArg: <color> : RGB value (0,0,0)
"MandatoryArg: <timer> : time in seconds the line should last"
"Example: thread draw_point( player.origin, 10, (1, 0, 0), 10.0 );"
"SPMP: singleplayer"
@/
draw_point( org, scale, color, timer )
{
	timer	= gettime() + ( timer * 1000 );
	range	= 10*scale;
	rt		= (range,0,0);
	ot		= (0,range,0);
	up		= (0,0,range);
	v1_1	= org + rt;
	v2_1	= org + ot;
	v3_1	= org + up;
	v1_2	= org - rt;
	v2_2	= org - ot;
	v3_2	= org - up;
	while( GetTime() < timer )
	{
		line( v1_1, v1_2, color, 1 );
		line( v2_1, v2_2, color, 1 );
		line( v3_1, v3_2, color, 1 );
		wait .05;
	}
}

/@
"Name: draw_line_to_ent_for_time( <org1> , <ent> , <r> , <g> , <b> , <timer> )"
"Summary: Draws a line from < org1 > to < ent > origin in the specified color for the specified duration. Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1> : starting origin for the line"
"MandatoryArg: <ent> : entity to draw line to"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <timer> : time in seconds the line should last"
"Example: thread draw_line_to_ent_for_time( guy.origin, vehicle, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
@/
draw_line_to_ent_for_time( org1, ent, r, g, b, timer )
{
	timer = gettime() + ( timer * 1000 );
	while( GetTime() < timer )
	{
		line( org1, ent.origin, ( r, g, b ), 1 );
		wait .05;
	}

}

draw_line_from_ent_for_time( ent, org, r, g, b, timer )
{
	draw_line_to_ent_for_time( org, ent, r, g, b, timer );
}

/@
"Name: draw_line_from_ent_to_ent_for_time( <ent1> , <ent2> , <r> , <g> , <b> , <timer> )"
"Summary: Draws a line from one entity origin to another entity origin in the specified color for the specified duration. Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <ent1> : entity to draw line from"
"MandatoryArg: <ent2> : entity to draw line to"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <timer> : time in seconds the line should last"
"Example: thread draw_line_from_ent_to_ent_for_time( guy, vehicle, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
@/
draw_line_from_ent_to_ent_for_time( ent1, ent2, r, g, b, timer )
{
	ent1 endon( "death" );
	ent2 endon( "death" );

	timer = gettime() + ( timer * 1000 );
	while( gettime() < timer )
	{
		line( ent1.origin, ent2.origin, ( r, g, b ), 1 );
		wait .05;
	}

}

/@
"Name: draw_line_from_ent_to_ent_until_notify( <ent1> , <ent2> , <r> , <g> , <b> , <notifyEnt> , <notifyString> )"
"Summary: Draws a line from one entity origin to another entity origin in the specified color until < notifyEnt > is notified < notifyString > . Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <ent1> : entity to draw line from"
"MandatoryArg: <ent2> : entity to draw line to"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <notifyEnt> : entity that waits for the notify"
"MandatoryArg: <notifyString> : notify string that will make the line stop being drawn"
"Example: thread draw_line_from_ent_to_ent_until_notify( get_players()[0], guy, 1, 0, 0, guy, "anim_on_tag_done" );"
"SPMP: singleplayer"
@/
draw_line_from_ent_to_ent_until_notify( ent1, ent2, r, g, b, notifyEnt, notifyString )
{
	assert( IsDefined( notifyEnt ) );
	assert( IsDefined( notifyString ) );

	ent1 endon( "death" );
	ent2 endon( "death" );

	notifyEnt endon( notifyString );

	while( 1 )
	{
		line( ent1.origin, ent2.origin, ( r, g, b ), 0.05 );
		wait .05;
	}

}

/@
"Name: draw_line_until_notify( <org1> , <org2> , <r> , <g> , <b> , <notifyEnt> , <notifyString> )"
"Summary: Draws a line from < org1 > to < org2 > in the specified color until < notifyEnt > is notified < notifyString > "
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1> : starting origin for the line"
"MandatoryArg: <org2> : ending origin for the line"
"MandatoryArg: <r> : red color value( 0 to 1 )"
"MandatoryArg: <g> : green color value( 0 to 1 )"
"MandatoryArg: <b> : blue color value( 0 to 1 )"
"MandatoryArg: <notifyEnt> : entity that waits for the notify"
"MandatoryArg: <notifyString> : notify string that will make the line stop being drawn"
"Example: thread draw_line_until_notify( self.origin, targetLoc, 1, 0, 0, self, "stop_drawing_line" );"
"SPMP: singleplayer"
@/
draw_line_until_notify( org1, org2, r, g, b, notifyEnt, notifyString )
{
	assert( IsDefined( notifyEnt ) );
	assert( IsDefined( notifyString ) );

	notifyEnt endon( notifyString );

	while( 1 )
	{
		draw_line_for_time( org1, org2, r, g, b, 0.05 );
	}
}

/@
"Name: draw_arrow_time( <start> , <end> , <color> , <duration> )"
"Summary: Draws an arrow pointing at < end > in the specified color for < duration > seconds."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <start> : starting coordinate for the arrow"
"MandatoryArg: <end> : ending coordinate for the arrow"
"MandatoryArg: <color> :( r, g, b ) color array for the arrow"
"MandatoryArg: <duration> : time in seconds to draw the arrow"
"Example: thread draw_arrow_time( lasttarg.origin, targ.origin, ( 0, 0, 1 ), 5.0 );"
"SPMP: singleplayer"
@/
draw_arrow_time( start, end, color, duration )
{
	level endon( "newpath" );
	pts = [];
	angles = VectorToAngles( start - end );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	dist = Distance( start, end );
	arrow = [];
	const range = 0.1;

	arrow[ 0 ] =  start;
	arrow[ 1 ] =  start + VectorScale( right, dist * ( range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 2 ] =  end;
	arrow[ 3 ] =  start + VectorScale( right, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.1 );

	arrow[ 4 ] =  start;
	arrow[ 5 ] =  start + VectorScale( up, dist * ( range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 6 ] =  end;
	arrow[ 7 ] =  start + VectorScale( up, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.1 );
	arrow[ 8 ] =  start;

	r = color[ 0 ];
	g = color[ 1 ];
	b = color[ 2 ];

	plot_points( arrow, r, g, b, duration );
}

draw_arrow( start, end, color )
{
	level endon( "newpath" );
	pts = [];
	angles = VectorToAngles( start - end );
	right = AnglesToRight( angles );
	forward = AnglesToForward( angles );

	dist = Distance( start, end );
	arrow = [];
	const range = 0.05;
	arrow[ 0 ] =  start;
	arrow[ 1 ] =  start + VectorScale( right, dist * ( range ) ) + VectorScale( forward, dist * - 0.2 );
	arrow[ 2 ] =  end;
	arrow[ 3 ] =  start + VectorScale( right, dist * ( - 1 * range ) ) + VectorScale( forward, dist * - 0.2 );

	for( p = 0;p < 4;p++ )
	{
		nextpoint = p + 1;
		if( nextpoint >= 4 )
		{
			nextpoint = 0;
		}
		line( arrow[ p ], arrow[ nextpoint ], color, 1.0 );
	}
}
#/
	
/@
"Name: battlechatter_off( <team> )"
"Summary: Disable DDS (formally known as battlechatter) for the specified team. Not specifying a team turns both teams off."
"Module: Battlechatter"
"CallOn: "
"MandatoryArg: <team> : team to disable DDS on"
"Example: battlechatter_off( "allies" );"
"SPMP: singleplayer"
@/
battlechatter_off( team )
{
	maps\_dds::dds_disable( team );
	return;
}

/@
"Name: battlechatter_on( <team> )"
"Summary: Enable DDS (formally known as battlechatter) for the specified team"
"Module: Battlechatter"
"CallOn: "
"MandatoryArg: <team> : team to enable DDS on"
"Example: battlechatter_on( "allies" );"
"SPMP: singleplayer"
@/
battlechatter_on( team )
{
	maps\_dds::dds_enable( team );
	return;
}

/@
"Name: dds_set_player_character_name( <hero_name> )"
"Summary: Sets the player character name in DDS so correct player DDS is played. Default for COD7 is Mason."
"Module: Battlechatter"
"CallOn: Player"
"MandatoryArg: <hero_name> : the player's hero name"
"Example: player dds_set_player_character_name( "hudson" );"
"SPMP: singleplayer"
@/
dds_set_player_character_name( hero_name )
{
	if( !IsPlayer( self ) )
	{
		/#PrintLn( "dds 'dds_set_player_character_name' function was not called on a player. No changes made." );#/
		return;
	}

	switch( hero_name )
	{
		case "mason":
		case "hudson":
		case "reznov":
			level.dds.player_character_name = GetSubStr( hero_name, 0, 3 );
			/#PrintLn( "dds setting player name to '" + level.dds.player_character_name + "'" );#/
			break;
		default:
			/#printLn( "dds: '" + hero_name + "' not a valid player name; setting to 'mason' (mas)" );#/
			level.dds.player_character_name = "mas";
			break;
	}
	self.dds_characterID = level.dds.player_character_name;
}

/@
"Name: dds_exclude_this_ai()"
"Summary: Mark an AI to not be in DDS and to not say any DDS lines."
"Module: Battlechatter"
"CallOn: AI"
"MandatoryArg: "
"Example: us_redshirt dds_exclude_this_ai();"
"SPMP: singleplayer"
@/
dds_exclude_this_ai()
{
	if( IsAI( self ) && IsAlive( self ) )
	{
		self.dds_characterID = undefined;
	}
	else
	{
		/#PrintLn( "Tried to mark an entity for DDS removal that was not an AI or not alive." );#/
	}
}

get_links()
{
	return Strtok( self.script_linkTo, " " );
}

/@
"Name: get_linked_ents()"
"Summary: Returns an array of entities that SELF is linked to"
"Module: Utility"
"CallOn: An entity that links to other entities"
"Example: spawners = heli get_linked_ents()"
"SPMP: singleplayer"
@/
get_linked_ents()
{
	array = [];

	if ( IsDefined( self.script_linkto ) )
	{
		linknames = get_links();
		for ( i = 0; i < linknames.size; i++ )
		{
			ent = getent( linknames[ i ], "script_linkname" );
			if ( IsDefined( ent ) )
			{
				array[ array.size ] = ent;
			}
		}
	}

	return array;
}

/@
"Name: get_linked_structs()"
"Summary: Returns an array of entities that SELF is linked to"
"Module: Utility"
"CallOn: An entity that links to other entities"
"Example: spawners = heli get_linked_structs()"
"SPMP: singleplayer"
@/
get_linked_structs()
{
	array = [];

	if ( IsDefined( self.script_linkto ) )
	{
		linknames = get_links();
		for ( i = 0; i < linknames.size; i++ )
		{
			ent = getstruct( linknames[ i ], "script_linkname" );
			if ( IsDefined( ent ) )
			{
				array[ array.size ] = ent;
			}
		}
	}

	return array;
}

/@
"Name: get_last_ent_in_chain( <sEntityType> )"
"Summary: Get the last entity/node/vehiclenode in a chain of targeted entities"
"Module: Entity"
"CallOn: Any entity that targets a chain of linked nodes, vehiclenodes or other entities like script_origin"
"MandatoryArg: <sEntityType>: needs to be specified as 'vehiclenode', 'pathnode' or 'ent'"
"Example: eLastNode = eVehicle get_last_ent_in_chain( "vehiclenode" );"
"SPMP: singleplayer"
@/
get_last_ent_in_chain( sEntityType )
{
	ePathpoint = self;
	while ( IsDefined(ePathpoint.target) )
	{
		wait (0.05);
		if ( IsDefined( ePathpoint.target ) )
		{
			switch ( sEntityType )
			{
			case "vehiclenode":
				ePathpoint = getvehiclenode( ePathpoint.target, "targetname" );
				break;
			case "pathnode":
				ePathpoint = getnode( ePathpoint.target, "targetname" );
				break;
			case "ent":
				ePathpoint = getent( ePathpoint.target, "targetname" );
				break;
			default:
				assertmsg("sEntityType needs to be 'vehiclenode', 'pathnode' or 'ent'");
			}
		}
		else
		{
			break;
		}
	}
	ePathend = ePathpoint;
	return ePathend;
}

set_forcegoal()
{
	if( IsDefined( self.set_forcedgoal ) )
	{
		return;
	}

	self.oldfightdist 	 = self.pathenemyfightdist;
	self.oldmaxdist 	 = self.pathenemylookahead;
	self.oldmaxsight 	 = self.maxsightdistsqrd;

	self.pathenemyfightdist = 8;
	self.pathenemylookahead = 8;
	self.maxsightdistsqrd = 1;
	self.set_forcedgoal = true;
}

unset_forcegoal()
{
	if( !IsDefined( self.set_forcedgoal ) )
	{
		return;
	}

	self.pathenemyfightdist = self.oldfightdist;
	self.pathenemylookahead = self.oldmaxdist;
	self.maxsightdistsqrd 	 = self.oldmaxsight;
	self.set_forcedgoal = undefined;
}

/@
"Name: array_removeDead( <array> )"
"Summary: Returns a new array of < array > minus the dead entities"
"Module: Array"
"CallOn: "
"MandatoryArg: <array> : The array to search for dead entities in."
"Example: friendlies = array_removeDead( friendlies );"
"SPMP: singleplayer"
@/

array_removeDead( array )
{
	newArray = [];

	if( !IsDefined( array ) )
	{
		return undefined;
	}

	for( i = 0; i < array.size; i++ )
	{
		//GLocke: the .isacorpse is a value specific to physics vehicles because they never become vehicle_corpse entities
		if( !isalive( array[ i ] ) || ( isDefined( array[i].isacorpse) && array[i].isacorpse) )
		{
			continue;
		}
		newArray[ newArray.size ] = array[ i ];
	}

	return newArray;
}


// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to( IE: can't do 5.struct_array_index )
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object

struct_arraySpawn()
{
	struct = SpawnStruct();
	struct.array = [];
	struct.lastindex = 0;
	return struct;
}

/@
"Name: structarray_add( <struct> , <object> )"
"Summary: "
"Module: Entity"
"CallOn: "
"MandatoryArg: <struct> : the struct array to which you wish to add an object"
"OptionalArg: <object> : the object you want to add to the struct array"
"Example: structarray_add( level.drones.team[self.team], self );"
"SPMP: singleplayer"
@/
structarray_add( struct, object )
{
	assert( !IsDefined( object.struct_array_index ) );// can't have elements of two structarrays on these. can add that later if it's needed
	struct.array[ struct.lastindex ] = object;
	object.struct_array_index = struct.lastindex;
	struct.lastindex ++ ;
}

/@
"Name: structarray_remove( <struct> , <object> )"
"Summary: "
"Module: Entity"
"CallOn: "
"MandatoryArg: <struct> : the struct array from which you wish to remove an object"
"OptionalArg: <object> : the object you want to remove from the struct array"
"Example: structarray_remove( level.drones.team[self.team], self );"
"SPMP: singleplayer"
@/
structarray_remove( struct, object )
{
	structarray_swaptolast( struct, object );
	struct.array[ struct.lastindex - 1 ] = undefined;
	struct.lastindex -- ;
}

structarray_swaptolast( struct, object )
{
	struct structarray_swap( struct.array[ struct.lastindex - 1 ], object );
}




/@
"Name: missionFailedWrapper()"
"Summary: Call when you want the player to fail the mission in a generic manner."
"Module: Utility"
"CallOn: player or level entity"
"MandatoryArg:"
"OptionalArg: <fail_hint> : Localized fail string."
"OptionalArg: <shader> 	  : Special fail icon Shader/Icon."
"OptionalArg: <iWidth> 	  : Shader/Icon width."
"OptionalArg: <iHeight>	  :	Shader/Icon height."
"OptionalArg: <fDelay> 	  : Delay to show the Shader/Icon."
"Example: maps\_utility::missionFailedWrapper();"
"SPMP: singleplayer"
@/
missionfailedwrapper( fail_hint, shader, iWidth, iHeight, fDelay, x, y )
{
	if( level.missionfailed )
	{
		return;
	}

	if ( IsDefined( level.nextmission ) )
	{
		return;  // don't fail the mission while the game is on it's way to the next mission.
	}

	if ( GetDvar( "failure_disabled" ) == "1" )
	{
		return;
	}

	// delete any existing in-game instructions created by screen_message_create() functionality
	screen_message_delete();

	if( IsDefined( fail_hint ) )
	{
		SetDvar( "ui_deadquote", fail_hint );
	}
	
	if( IsDefined( shader ) )
	{
		get_players()[0] thread maps\_load_common::special_death_indicator_hudelement( shader, iWidth, iHeight, fDelay, x, y );
	}

	level.missionfailed = true;
	flag_set( "missionfailed" );

	MissionFailed();
}

/@
"Name: nextmission()"
"Summary: Call at the end of the level scripting when the mission has been completed."
"Module: Utility"
"CallOn: "
"Example: nextmission();"
"SPMP: singleplayer"
@/
nextmission()
{
	maps\_endmission::_nextmission();
}

prefetchnext()
{
	maps\_endmission::prefetch_next();
}

script_flag_wait()
{
	if ( IsDefined( self.script_flag_wait ) )
	{
		self flag_wait( self.script_flag_wait );
		return true;
	}
	
	return false;
}

script_delay()
{
	if ( IsDefined( self.script_delay ) )
	{
		wait self.script_delay;
		return true;
	}
	else if ( IsDefined( self.script_delay_min ) && IsDefined( self.script_delay_max ) )
	{
		wait RandomFloatrange( self.script_delay_min, self.script_delay_max );
		return true;
	}

	return false;
}

script_wait( called_from_spawner )
{
	// co-op scaling should only affect calls from spawning functions
	if (!IsDefined(called_from_spawner))
	{
		called_from_spawner = false;
	}

	// set to 1 as default, decease scalar as more players join
	coop_scalar = 1;
	if ( called_from_spawner )
	{
		players = get_players();

		if (players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else if (players.size == 3)
		{
			coop_scalar = 0.4;
		}
		else if (players.size == 4)
		{
			coop_scalar = 0.1;
		}
	}

	startTime = GetTime();
	if( IsDefined( self.script_wait ) )
	{
		wait( self.script_wait * coop_scalar);

		if( IsDefined( self.script_wait_add ) )
		{
			self.script_wait += self.script_wait_add;
		}
	}
	else if( IsDefined( self.script_wait_min ) && IsDefined( self.script_wait_max ) )
	{
		wait( RandomFloatrange( self.script_wait_min, self.script_wait_max ) * coop_scalar);

		if( IsDefined( self.script_wait_add ) )
		{
			self.script_wait_min += self.script_wait_add;
			self.script_wait_max += self.script_wait_add;
		}
	}

	return( GetTime() - startTime );
}

// AE 5-14-09: cleaned this function up and took out the guy parameter (made it self)
//				this used to be guy_enter_vehicle( guy, vehicle )
/@
"Name: enter_vehicle( <vehicle> )"
"Summary: This puts the guy into the vehicle and tells him to idle."
"Module: AI"
"CallOn: an actor"
"MandatoryArg: <vehicle>: the vehicle to get in"
"Example: my_ai thread enter_vehicle(my_vehicle);"
"SPMP: singleplayer"
@/
enter_vehicle( vehicle, tag ) // self == ai
{
	self maps\_vehicle_aianim::vehicle_enter( vehicle, tag );
}

/@
"Name: guy_array_enter_vehicle( <guy>, <vehicle> )"
"Summary: This puts an array of guys into the vehicle and tells him to idle."
"Module: AI"
"MandatoryArg: <guy>: the array of guys to get in"
"MandatoryArg: <vehicle>: the vehicle to get in"
"Example: guy_array_enter_vehicle(my_guy_array, my_vehicle);"
"SPMP: singleplayer"
@/
guy_array_enter_vehicle( guy, vehicle )
{
	maps\_vehicle_aianim::guy_array_enter( guy, vehicle );
}

// AE 5-14-09: cleaned this function up and took out the guy parameter (made it self)
//				this used to be guy_runtovehicle_load( guy, vehicle )
/@
"Name: run_to_vehicle_load( <vehicle>, <bGodDriver>, <seat tag> )"
"Summary: This sends an AI to the vehicle, plays the loading animation, and attaches to the vehicle."
"Module: AI"
"CallOn: an actor"
"MandatoryArg: <vehicle>: the vehicle to run to and get in"
"OptionalArg: <bGodDriver>: Will the driver be invulnerable, true or false?"
"OptionalArg: <seat_tag>: the string seat tag for where you want them to go"
"Example: my_ai thread run_to_vehicle_load(my_vehicle, true, "tag_passenger1");"
"SPMP: singleplayer"
@/
run_to_vehicle_load(vehicle, bGodDriver, seat_tag) // self == ai
{
	self maps\_vehicle_aianim::run_to_vehicle( vehicle, bGodDriver, seat_tag );
}

// AE 7-21-09: created this so it would exist in docs because people don't know how to unload a vehicle
/@
"Name: vehicle_unload( <delay> )"
"Summary: This tells the AI to unload from the vehicle."
"Module: Vehicle"
"CallOn: a vehicle"
"OptionalArg: <delay>: a numerical value for time to wait until unloading"
"Example: my_vehicle vehicle_unload( 1.0 ); OR my_vehicle vehicle_unload();"
"SPMP: singleplayer"
@/
vehicle_unload(delay) // self == vehicle
{
	self maps\_vehicle::do_unload(delay);
}

/@
"Name: vehicle_override_anim( <action>, <tag>, <animation> )"
"Summary: Overrides specific global vehicle animations for a vehicle."
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <action> The action for the animation ("getin", "getout", "idle")."
"MandatoryArg: <tag>: The tag to override the animation for."
"MandatoryArg: <animation>: The animation to use."
"Example: vehicle vehicle_override_anim( "getout", "tag_passenger1", %my_super_special_getout_anim );"
"SPMP: singleplayer"
@/
vehicle_override_anim(action, tag, animation)
{
	self maps\_vehicle_aianim::override_anim(action, tag, animation);
}

// AE 7-20-09: created this so we can control the ai running to a vehicle and waiting
/@
"Name: set_wait_for_players( <vehicle seat tag>, <player array> )"
"Summary: This tells the vehicle that there will be a waiting animation that will play while waiting for the players to get in the vehicle."
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <vehicle seat tag>: the vehicle's seat tag that will wait"
"MandatoryArg: <player array>: the players to wait for before loading"
"Example: vehicle set_wait_for_players( "tag_passenger1", players );"
"SPMP: singleplayer"
@/
set_wait_for_players(seat_tag, player_array) // self == vehicle
{
	// get the vehicle ai anims
	vehicleanim = level.vehicle_aianims[ self.vehicletype ];

	// cross reference the seat tag to get the pos number
	for(i = 0; i < vehicleanim.size; i++)
	{
		if(vehicleanim[i].sittag == seat_tag)
		{
			// put the player array in another array to use later
			vehicleanim[i].wait_for_player = [];
			for(j = 0; j < player_array.size; j++)
			{
				vehicleanim[i].wait_for_player[j] = player_array[j];
			}
			break;
		}
	}
}

// AE 7-20-09: created this so we can control the ai running to a vehicle and waiting
/@
"Name: set_wait_for_notify( <vehicle seat tag>, <custom notify> )"
"Summary: This tells the vehicle that there will be a waiting animation that will play while waiting for a notify before getting in the vehicle."
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <vehicle seat tag>: the vehicle's seat tag that will wait"
"MandatoryArg: <custom notify>: the notify to wait for before getting in the vehicle"
"Example: vehicle set_wait_for_notify( "tag_passenger1", "load_now" );"
"SPMP: singleplayer"
@/
set_wait_for_notify(seat_tag, custom_notify) // self == vehicle
{
	// get the vehicle ai anims
	vehicleanim = level.vehicle_aianims[ self.vehicletype ];

	// cross reference the seat tag to get the pos number
	for(i = 0; i < vehicleanim.size; i++)
	{
		if(vehicleanim[i].sittag == seat_tag)
		{
			vehicleanim[i].wait_for_notify = custom_notify;
			break;
		}
	}
}

// AE 7-20-09: created this so we know if a player is on a vehicle
/@
"Name: is_on_vehicle( <vehicle> )"
"Summary: Returns true if a player is on the vehicle."
"Module: Vehicle"
"CallOn: a player"
"MandatoryArg: <vehicle>: the vehicle to check against"
"Example: if( player is_on_vehicle( vehicle ) )"
"SPMP: singleplayer"
@/
is_on_vehicle(vehicle) // self == player
{

	if(!IsDefined(self.viewlockedentity))
	{
		return false;
	}
	else if(self.viewlockedentity == vehicle)
	{
		return true;
	}

	if(!IsDefined(self.groundentity))
	{
		return false;
	}
	else if(self.groundentity == vehicle)
	{
		return true;
	}

	return false;
}

/@
"Name: get_force_color_guys( <team>, <color> )"
"Summary: Returns all alive ai of a certain force color."
"Module: AI"
"CallOn: "
"Example: red_guys = get_force_color_guys( "allies", "r" );"
"MandatoryArg: <team> : the team of the guys to check"
"MandatoryArg: <color> : the color value of the guys you want to collect"
"SPMP: singleplayer"
@/
get_force_color_guys( team, color )
{
	ai = GetAiArray( team );
	guys = [];
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !IsDefined( guy.script_forceColor ) )
		{
			continue;
		}

		if( guy.script_forceColor != color )
		{
			continue;
		}
		guys[ guys.size ] = guy;
	}

	return guys;
}

get_all_force_color_friendlies()
{
	ai = GetAiArray( "allies" );
	guys = [];
	for( i = 0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if( !IsDefined( guy.script_forceColor ) )
		{
			continue;
		}
		guys[ guys.size ] = guy;
	}

	return guys;
}

/@
"Name: enable_ai_color()"
"Summary: Re-enables an ai's force color. Only works on guys that have had a forceColor set previously."
"Module: Color"
"CallOn: An AI"
"Example: guy enable_ai_color();"
"SPMP: singleplayer"
@/
enable_ai_color()
{
	if( IsDefined( self.script_forceColor ) )
	{
		return;
	}
	if( !IsDefined( self.old_forceColor ) )
	{
		return;
	}

	set_force_color( self.old_forcecolor );
	self.old_forceColor = undefined;
}

/@
"Name: disable_ai_color()"
"Summary: disables an ai's force color. Essentially takes him off the color chain."
"Module: Color"
"CallOn: An AI"
"Example: guy disable_ai_color();"
"SPMP: singleplayer"
@/
disable_ai_color()
{
	if( IsDefined( self.new_force_color_being_set ) )
	{
		self endon( "death" );
		// setting force color happens after waittillframeend so we need to wait until it finishes
		// setting before we disable it, so a set followed by a disable will send the guy to a node.
		self waittill( "done_setting_new_color" );
	}

	self clearFixedNodeSafeVolume();
	// any color on this guy?
	if( !IsDefined( self.script_forceColor ) )
	{
		return;
	}

	assert( !IsDefined( self.old_forcecolor ), "Tried to disable forcecolor on a guy that somehow had a old_forcecolor already. Investigate!!!" );

	self.old_forceColor = self.script_forceColor;


	// first remove the guy from the force color array he used to belong to
	ArrayRemoveValue( level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ], self );
	// 	self maps\_colors::removeAIFromColorNumberArray();

	maps\_colors::left_color_node();
	self.script_forceColor = undefined;
	self.currentColorCode = undefined;
	/#
		update_debug_friendlycolor( self.ai_number );
#/
}

/@
"Name: clear_force_color()"
"Summary: Does the same thing as disable_ai_color()"
"Module: Color"
"CallOn: An AI"
"Example: guy clear_force_color();"
"SPMP: singleplayer"
@/
clear_force_color()
{
	disable_ai_color();
}

/@
"Name: check_force_color( <_color> )"
"Summary: Checks to see if a guy's color matches that of the passed in value. Returns true or false.
"Module: Color"
"CallOn: An AI"
"MandatoryArg: <_color> : the color string to check for"
"Example: if( guy check_force_color( "p" ) )..."
"SPMP: singleplayer"
@/
check_force_color( _color )
{
	color = level.colorCheckList[ tolower( _color ) ];
	if( IsDefined( self.script_forcecolor ) && color == self.script_forcecolor )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/@
"Name: get_force_color()"
"Summary: Returns a guy's force color"
"Module: Color"
"CallOn: An AI"
"Example: color = guy get_force_color()"
"SPMP: singleplayer"
@/
get_force_color()
{
	color = self.script_forceColor;
	return color;
}

shortenColor( color )
{
	assert( IsDefined( level.colorCheckList[ tolower( color ) ] ), "Tried to set force color on an undefined color: " + color );
	return level.colorCheckList[ tolower( color ) ];
}

/@
"Name: set_force_color( <_color> )"
"Summary: Sets a guy's force color"
"Module: Color"
"CallOn: An AI"
"Example: guy set_force_color( "p" );"
"SPMP: singleplayer"
@/
set_force_color( _color )
{
	// shorten and lowercase the ai's forcecolor to a single letter
	color = shortenColor( _color );

	assert( maps\_colors::colorIsLegit( color ), "Tried to set force color on an undefined color: " + color );

	if( !isAI( self ) )
	{
		set_force_color_spawner( color );
		return;
	}

	assert( isalive( self ), "Tried to set force color on a dead / undefined entity." );
	/*
	/#
	thread insure_player_does_not_set_forcecolor_twice_in_one_frame();
	#/
	*/

	if( self.team == "allies" )
	{
		// enable fixed node mode.
		self.fixedNode = true;
		self.fixedNodeSafeRadius = 64;
		self.pathEnemyFightDist = 0;
		self.pathEnemyLookAhead = 0;
	}

	// 	maps\_colors::removeAIFromColorNumberArray();
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	self.old_forcecolor = undefined;

	if( IsDefined( self.script_forcecolor ) )
	{
		// first remove the guy from the force color array he used to belong to
		ArrayRemoveValue( level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ], self );
	}
	self.script_forceColor = color;

	// get added to the new array of AI that are forced to this color
	ARRAY_ADD( level.arrays_of_colorForced_ai[ self.team ][ self.script_forceColor ], self );


	// set it here so that he continues in script as the correct color
	thread new_color_being_set( color );
}

set_force_color_spawner( color )
{
	/*
	team = undefined;
	colorTeam = undefined;
	if( IsSubStr( self.classname, "axis" ) )
	{
	colorTeam = self.script_color_axis;
	team = "axis";
	}

	if( IsSubStr( self.classname, "ally" ) )
	{
	colorTeam = self.script_color_allies;
	team = "allies";
	}

	maps\_colors::removeSpawnerFromColorNumberArray();
	*/

	self.script_forceColor = color;
	// 	self.script_color_axis = undefined;
	// 	self.script_color_allies = undefined;
	self.old_forceColor = undefined;
	// 	thread maps\_colors::spawner_processes_colorCoded_ai();
}



/@
"Name: disable_replace_on_death()"
"Summary: Disables replace on death for color reinforcements"
"Module: Color"
"CallOn: An AI"
"Example: guy disable_replace_on_death();"
"SPMP: singleplayer"
@/
disable_replace_on_death()
{
	self.replace_on_death = undefined;
	self notify( "_disable_reinforcement" );
}

createLoopEffect( fxid )
{
	ent = maps\_createfx::createEffect( "loopfx", fxid );
	ent.v[ "delay" ] = 0.5;
	return ent;
}

createOneshotEffect( fxid )
{
	ent = maps\_createfx::createEffect( "oneshotfx", fxid );
	ent.v[ "delay" ] = -15;
	return ent;
}

reportExploderIds()
{
	if(!IsDefined(level._exploder_ids))
	{
		return;
	}

	keys = GetArrayKeys( level._exploder_ids );

	/#
	println("Server Exploder dictionary : ");

	for( i = 0; i < keys.size; i++ )
	{
		println(keys[i] + " : " + level._exploder_ids[keys[i]]);
	}
	#/
}

getExploderId( ent )
{
	if(!IsDefined(level._exploder_ids))
	{
		level._exploder_ids = [];
		level._exploder_id = 1;
	}

	if(!IsDefined(level._exploder_ids[ent.v["exploder"]]))
	{
		level._exploder_ids[ent.v["exploder"]] = level._exploder_id;
		level._exploder_id ++;
	}

	return level._exploder_ids[ent.v["exploder"]];
}

createExploder( fxid )
{
	ent = maps\_createfx::createEffect( "exploder", fxid );
	ent.v[ "delay" ] = 0;
	ent.v[ "exploder" ] = 1;
	ent.v[ "exploder_type" ] = "normal";

	return ent;
}

vehicle_detachfrompath()
{
	maps\_vehicle::vehicle_pathDetach();
}

/@
"Name: vehicle_resumepath()"
"Summary: will resume to the last path a vehicle was on.  Only used for helicopters, ground vehicles don't ever deviate."
"Module: Vehicle"
"CallOn: An entity"
"Example: helicopter vehicle_resumepath();"
"SPMP: singleplayer"
@/

vehicle_resumepath()
{
	thread maps\_vehicle::vehicle_resumepathvehicle();
}

/@
"Name: vehicle_land()"
"Summary: lands a vehicle on the ground, _vehicle scripts take care of offsets and determining where the ground is relative to the origin.  Returns when land is complete"
"Module: Vehicle"
"CallOn: An entity"
"Example: helicopter vehicle_land();"
"SPMP: singleplayer"
@/

vehicle_land()
{
	maps\_vehicle::vehicle_landvehicle();
}

vehicle_liftoff( height )
{
	maps\_vehicle::vehicle_liftoffvehicle( height );
}


/@
"Name: add_skipto( <msg> , <func> , <loc_string> , <optional_func> )"
"Summary: add skipto with a string"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <msg>: string to identify the skipto"
"MandatoryArg: <func>: thread to skipto when this skipto is initialized."
"OptionalArg: <loc_string>: Localizated string to display, this became a requirement when loc_warnings were turned on."
"OptionalArg: <Optional_func>: The main logic function associated with this skipto point, will run in the order of the skipto points when a previous function completes."
"Example: 	add_skipto( "first_hind", ::skipto_first_hind, &"SKIPTOS_FIRSTHIND", ::first_hind_battle );"
"SPMP: singleplayer"
@/

add_skipto( msg, func, loc_string, optional_func )
{
	maps\_skipto::add_skipto_assert();
	
	msg = ToLower( msg );
	
	array = maps\_skipto::add_skipto_construct( msg, func, loc_string, optional_func );
	
	if( !IsDefined( func ) )
	{
		assert( IsDefined( func ), "add_skipto() called with no func parameter.." );
	}
	
	level.skipto_functions[ level.skipto_functions.size ] = array;
	level.skipto_arrays[ msg ] = array;
}

/@
"Name: set_skipto_cleanup_func( <func> )"
"Summary: set the skipto cleanup function for the level"
"Module: Utility"
"CallOn: Level"
"MandatoryArg: <func>: function that runs before any skipto function gets called. Used for shared skipto initialization."
"Example: 	set_skipto_cleanup_func( ::skipto_cleanup );"
"SPMP: singleplayer"
@/
set_skipto_cleanup_func( func )
{
	level.func_skipto_cleanup = func;
}

/@
"Name: default_skipto( <skipto> )"
"Summary: Set the default skipto point by name. Allows any skipto to be called by default when level loads naturally."
"Module: Utility"
"MandatoryArg: <skipto>: Which skipto to use as the default skipto. "
"Example: default_skipto( "ride" );"
"SPMP: singleplayer"
@/
default_skipto( skipto )
{
	level.default_skipto = skipto;
}

/@
"Name: skipto_teleport( <skipto_name>, <friendly_ai>, <coop_sort> )"
"Summary: teleports players and ai for skiptos"
"Module: Utility"
"CallOn: Structs must be set up in radiant with a targetname equal to skipto_name for the player(s) to teleport to.  Structs with a targetname of skipto_name+"_ai" must be set up for AI to teleport to"
"Example: skipto_teleport( "airfield", "blue_squad", true );"
"MandatoryArg: <skipto_name> : the name of the skipto"
"OptionalArg: <friendly_ai> : Either an array of AI or a script_noteworthy value of ai to teleport"
"OptionalArg: <coop_sort> : if the skipto is set up for coop, players will be placed in accordance with a script_int value on the skipto structs in radiant"
"SPMP: singleplayer"
@/
skipto_teleport( skipto_name, friendly_ai, coop_sort )
{
	skipto_teleport_ai( skipto_name, friendly_ai );
	skipto_teleport_players( skipto_name, coop_sort );
}

/@
"Name: skipto_teleport_ai( <skipto_name>, <friendly_ai> )"
"Summary: Teleports AI's to structs with the specified skipto_name+"_ai" as a targetname."
"Module: Utility"
"Example: skipto_teleport_ai( ::"mangrove", mangrove_heroes );"
"MandatoryArg: <skipto_name> : the name of the skipto event.  Must correspond to naming of structs in radiant"
"OptionalArg: <friendly_ai> : Array of AI to teleport.  This can also be a script_noteworthy string of AI to teleport.  If this parameter is empty, all living allies will be grabbed and teleported"
"SPMP: singleplayer"
@/
skipto_teleport_ai( skipto_name, friendly_ai )
{
	if ( !isdefined( friendly_ai ) )
	{
		if ( IsDefined( level.heroes ) )
		{
			friendly_ai = level.heroes;
		}
		else
		{
			friendly_ai = GetAIArray( "allies" );
		}
	}
	
	if ( IsString( friendly_ai ) )
	{
		friendly_ai = get_ai_array( friendly_ai, "script_noteworthy" );
	}
	
	if ( !IsArray( friendly_ai ) )
	{
		friendly_ai = array( friendly_ai );
	}

	a_skipto_structs = GetStructArray( skipto_name + "_ai", "targetname");

	if ( !a_skipto_structs.size )
		return;
		
	assert( a_skipto_structs.size >= friendly_ai.size, "Need more start positions for ai for " + skipto_name + "!  Tried to teleport "+friendly_ai.size+" AI to only "+a_skipto_structs.size+" structs" );

	for ( i = 0; i < friendly_ai.size; i++ )
	{
		start_i = 0;
		if (IsDefined(friendly_ai[i].script_int))
		{
			for (j = 0; j < a_skipto_structs.size; j++)
			{
				if (IsDefined(a_skipto_structs[j].script_int))
				{
					if (a_skipto_structs[j].script_int == friendly_ai[i].script_int)
					{
						start_i = j;
						break;
					}
				}
			}
		}

		friendly_ai[i] skipto_teleport_single_ai(a_skipto_structs[start_i]);
		ArrayRemoveValue(a_skipto_structs, a_skipto_structs[start_i]);
	}
}

skipto_teleport_single_ai(ai_skipto_spot)
{
	if ( IsDefined( ai_skipto_spot.angles ) )
	{
		self ForceTeleport( ai_skipto_spot.origin, ai_skipto_spot.angles );
	}
	else
	{
		self ForceTeleport( ai_skipto_spot.origin );
	}

	// so they don't run back to their original spot
	if ( IsDefined( ai_skipto_spot.target ) )
	{
		node = GetNode( ai_skipto_spot.target, "targetname" );
		if ( IsDefined( node ) )
		{
			self SetGoalNode( node );
			return;
		}
	}
	
	self SetGoalPos( ai_skipto_spot.origin );
}

skipto_teleport_players( skipto_name, coop_sort )
{
	wait_for_first_player();
	players = get_players();

	// Grab the skipto points. if this skipto is the entrypoint into the level or needs each player in a particular spot, sort them for coop placement
	if( IsDefined( coop_sort ) && coop_sort )
	{
		skipto_spots = get_sorted_skipto_spots( skipto_name );
	}
	else
	{
		skipto_spots = getstructarray( skipto_name, "targetname" );
	}

	// make sure there are enough points skipto spots for the players
	assert( skipto_spots.size >= players.size, "Need more skipto positions for players!" );

	// set up each player
	for (i = 0; i < players.size; i++)
	{
		// Set the players' origin to each skipto point
		players[i] setOrigin( skipto_spots[i].origin );

		if( IsDefined( skipto_spots[i].angles ) )
		{
			// Set the players' angles to face the right way.
			players[i] setPlayerAngles( skipto_spots[i].angles );
		}
	}

	set_breadcrumbs(skipto_spots);
}

// sort the coop skipto points based on their script_int value
get_sorted_skipto_spots( skipto_name )
{
	player_skipto_spots = getstructarray( skipto_name, "targetname" );

	for( i = 0; i < player_skipto_spots.size; i++ )
	{
		for( j = i; j < player_skipto_spots.size; j++ )
		{
			assert( IsDefined( player_skipto_spots[j].script_int ), "player skipto struct at: " + player_skipto_spots[j].origin + " must have a script_int set for coop spawning" );
			assert( IsDefined( player_skipto_spots[i].script_int ), "player skipto struct at: " + player_skipto_spots[i].origin + " must have a script_int set for coop spawning" );

			if( player_skipto_spots[j].script_int < player_skipto_spots[i].script_int )
			{
				temp = player_skipto_spots[i];
				player_skipto_spots[i] = player_skipto_spots[j];
				player_skipto_spots[j] = temp;
			}
		}
	}

	return player_skipto_spots;
}

/@
"Name: within_fov( <start_origin> , <start_angles> , <end_origin> , <fov> )"
"Summary: Returns true if < end_origin > is within the players field of view, otherwise returns false."
"Module: Vector"
"CallOn: "
"MandatoryArg: <start_origin> : starting origin for FOV check( usually the players origin )"
"MandatoryArg: <start_angles> : angles to specify facing direction( usually the players angles )"
"MandatoryArg: <end_origin> : origin to check if it's in the FOV"
"MandatoryArg: <fov> : cosine of the FOV angle to use"
"Example: qBool = within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"
"SPMP: singleplayer"
@/
within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin );
	forward = AnglesToForward( start_angles );
	dot = VectorDot( forward, normal );

	return dot >= fov;
}

/@
"Name: wait_for_buffer_time_to_pass( <last_queue_time> , <buffer_time> )"
"Summary: Wait until the current time is equal or greater than the last_queue_time (in ms) + buffer_time (in seconds)"
"Module: Utility"
"MandatoryArg: <last_queue_time>: The gettime() of the last event you want to buffer"
"MandatoryArg: <buffer_time>: The amount of time you want to insure has passed since the last queue time"
"Example: wait_for_buffer_time_to_pass( level.last_time_we_checked, 3 );"
"SPMP: singleplayer"
@/
wait_for_buffer_time_to_pass( last_queue_time, buffer_time )
{
	timer = buffer_time * 1000 - ( gettime() - last_queue_time );
	timer *= 0.001;
	if ( timer > 0 )
	{
		// 500ms buffer time between radio or dialogue sounds
		wait( timer );
	}
}




string( val )
{
	if ( isdefined( val ) )
	{
		return "" + val;
	}
	else
	{
		return "";
	}
}

/@
"Name: clear_threatbias( <group1>, <group2> )"
"Summary: Clears any threatbias between two groups"
"Module: AI"
"Example: clear_threatbias( "bunker_axis", "bunker_allies" );"
"MandatoryArg: <group1> : threatbias group 1"
"MandatoryArg: <group2> : threatbias group 2"
"SPMP: singleplayer"
@/
clear_threatbias( group1, group2 )
{
	SetThreatBias( group1, group2, 0 );
	SetThreatBias( group2, group1, 0 );
}

/@
"Name: add_global_spawn_function( <team> , <func> , <param1> , <param2> , <param3> )"
"Summary: All spawners of this team will run this function on spawn."
"Module: Utility"
"MandatoryArg: <team> : The team of the spawners that will run this function."
"MandatoryArg: <func> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"Example: add_global_spawn_function( "axis", ::do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/

add_global_spawn_function( team, function, param1, param2, param3 )
{
	assert( IsDefined( level.spawn_funcs ), "Tried to add_global_spawn_function before calling _load" );

	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;

	level.spawn_funcs[ team ][ level.spawn_funcs[ team ].size ] = func;
}

/@
"Name: remove_global_spawn_function( <team> , <func> )"
"Summary: Remove this function from the global spawn functions for this team."
"Module: Utility"
"MandatoryArg: <team> : The team of the spawners that will no longer run this function."
"MandatoryArg: <func> : The function to remove."
"Example: remove_global_spawn_function( "allies", ::do_the_amazing_thing );"
"SPMP: singleplayer"
@/

remove_global_spawn_function( team, function )
{
	assert( IsDefined( level.spawn_funcs ), "Tried to remove_global_spawn_function before calling _load" );

	array = [];
	for( i = 0; i < level.spawn_funcs[ team ].size; i++ )
	{
		if( level.spawn_funcs[ team ][ i ][ "function" ] != function )
		{
			array[ array.size ] = level.spawn_funcs[ team ][ i ];
		}
	}

	assert( level.spawn_funcs[ team ].size != array.size, "Tried to remove a function from level.spawn_funcs, but that function didn't exist!" );
	level.spawn_funcs[ team ] = array;
}

/@
"Name: add_spawn_function( <func> , [param1], [param2], [param3], [param4], [param5] )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"Module: Utility"
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"OptionalArg: <param5> : An optional parameter."
"Example: spawner add_spawn_function( ::do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/
add_spawn_function( function, param1, param2, param3, param4, param5 )
{
	assert( !IsDefined( level._loadStarted ) || !IsAlive( self ), "Tried to add_spawn_function to a living guy." );

	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	func[ "param5" ] = param5;

	if (!IsDefined(self.spawn_funcs))
	{
		self.spawn_funcs = [];
	}

	self.spawn_funcs[ self.spawn_funcs.size ] = func;
}

/@
"Name: add_spawn_function_veh( <targetname>, <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"Module: Utility"
"MandatoryArg: <targetname> : The targetname of the vehicle."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: add_spawn_function_veh( "amazing_vehicle", ::do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/
add_spawn_function_veh( veh_targetname, function, param1, param2, param3, param4 )
{
	//TODO: GLocke - turn this assert back on once POW is no longer needed
	//assert( IsDefined( level.vehicle_targetname_array[ veh_targetname ] ), "Tried to add_spawn_function_veh to vehicle spawners named *" + veh_targetname + "* but none were found" );
	if(!IsDefined( level.vehicle_targetname_array[ veh_targetname ] ))
	{
		/#PrintLn("Tried to add_spawn_function_veh to vehicle spawners named *" + veh_targetname + "* but none were found");#/
		return;
	}
	
	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	
	foreach ( n_spawn_group, a_spawners in level.vehicle_spawners )
	{
		foreach ( spawner in a_spawners )
		{
			if ( IsDefined( spawner.targetname ) && ( spawner.targetname == veh_targetname + "_vehiclespawner" ) )
			{
				if ( !IsDefined( spawner.spawn_funcs ) )
				{
					spawner.spawn_funcs = [];
				}
				
				spawner.spawn_funcs[ spawner.spawn_funcs.size ] = func;
			}
		}
	}
}

/@
"Name: add_spawn_function_veh_by_type( <vehicle_type>, <func> , <param1> , <param2> , <param3>, <param4> )"
"Summary: Anything that spawns from this spawner will run this function. Anything."
"Module: Utility"
"MandatoryArg: <vehicle_type> : The .vehicletype of the vehicle."
"MandatoryArg: <func1> : The function to run."
"OptionalArg: <param1> : An optional parameter."
"OptionalArg: <param2> : An optional parameter."
"OptionalArg: <param3> : An optional parameter."
"OptionalArg: <param4> : An optional parameter."
"Example: spawner add_spawn_function_veh_by_type( "tank_t72", ::do_the_amazing_thing, some_amazing_parameter );"
"SPMP: singleplayer"
@/
add_spawn_function_veh_by_type( veh_type, function, param1, param2, param3, param4 )
{
	assert( IsDefined( level.vehicle_spawners ), "Tried to add_spawn_function_veh_by_type before vehicle spawners were inited");
	
	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	func[ "param4" ] = param4;
	
	foreach ( n_spawn_group, a_spawners in level.vehicle_spawners )
	{
		foreach ( spawner in a_spawners )
		{
			if ( IsDefined( spawner.vehicletype ) && ( spawner.vehicletype == veh_type ) )
			{
				if ( !IsDefined( spawner.spawn_funcs ) )
				{
					spawner.spawn_funcs = [];
				}
				
				spawner.spawn_funcs[ spawner.spawn_funcs.size ] = func;
			}
		}
	}
}


/@
"Name: get_vehicle_spawner_array( <str_value>, [str_key] )"
"Summary: returns an array of vehicle spawners with a certain key value pair"
"Module: Vehicle"
"MandatoryArg: <str_value>: vehicle spawner name"
"OptionalArg: [str_key]: vehicle spawner key (targetname, script_noteworthy, etc). Defaults to 'targetname'."
"Example: a_vehicle_spawners = get_vehicle_spawner_array( "enemy_trucks", "targetname" );"
"SPMP: singleplayer"
@/
get_vehicle_spawner_array( str_value, str_key = "targetname" )
{
	Assert( IsDefined( str_value ), "Missing <str_value> argument to get_vehicle_spawner_array()" );
	
	// "_vehiclespawner" only appended to targetname key in _vehicle.gsc
	if ( str_key == "targetname" )
	{
		str_value += "_vehiclespawner";
	}
	
	a_spawners = get_struct_array( str_value, str_key );
	return a_spawners;
}


/@
"Name: get_vehicle_spawner( <str_value>, [str_key] )"
"Summary: returns a single vehicle spawner. This function will assert if more than one vehicle spawner with a certain key value pair is found."
"Module: Vehicle"
"MandatoryArg: <str_value>: string - vehicle spawner name"
"OptionalArg: [str_key]: lookup key for the vehicle spawner. Defaults to 'targetname'."
"Example: sp_truck = get_vehicle_spawner( "enemy_truck", "targetname" );"
"SPMP: singleplayer"
@/
get_vehicle_spawner( str_value, str_key = "targetname" )
{
	Assert( IsDefined( str_value ), "Missing <str_value> argument to get_vehicle_spawner()" );
	
	if ( str_key == "targetname" )
	{
		str_value += "_vehiclespawner";
	}
	
	a_spawners = get_struct_array( str_value, str_key );
	
	Assert( a_spawners.size < 2, "More than one vehicle spawner found with kvp '" + str_key + "/" + str_value );
	
	return a_spawners[0];
}

/@
"Name: get_vehicle_array( <str_value>, [str_key] )"
"Summary: returns an array of all vehicles with a specified key value pair"
"Module: Vehicle"
"MandatoryArg: <str_value>: vehicle name to look for"
"OptionalArg: [str_key]: lookup key used to find vehicle. Supports 'targetname', 'script_noteworthy', 'script_string', 'model'. Defaults to 'targetname'."
"Example: a_trucks = get_vehicle_array( "enemy_trucks", "targetname" );"
"SPMP: singleplayer"
@/
get_vehicle_array( str_value, str_key = "targetname" )
{
	a_all_vehicles = GetVehicleArray();
	
	if ( IsDefined( str_value ) )
	{
		a_veh = [];
		foreach ( veh in a_all_vehicles )
		{
			switch ( str_key )
			{
				case "targetname":			if ( IS_EQUAL( veh.targetname, str_value ) )		ARRAY_ADD( a_veh, veh ); break;
				case "script_noteworthy":	if ( IS_EQUAL( veh.script_noteworthy, str_value ) )	ARRAY_ADD( a_veh, veh ); break;
				case "script_string":		if ( IS_EQUAL( veh.script_string, str_value ) )		ARRAY_ADD( a_veh, veh ); break;
				case "model":				if ( IS_EQUAL( veh.model, str_value ) )				ARRAY_ADD( a_veh, veh ); break;
			}
		}
		
		return a_veh;
	}
	
	return a_all_vehicles;
}

/@
"Name: ignore_triggers( <timer> )"
"Summary: Makes the entity that this is threaded on not able to set off triggers for a certain length of time."
"Module: Utility"
"CallOn: an entity"
"Example: guy thread ignore_triggers( 0.2 );"
"SPMP: singleplayer"
@/
ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
	self endon( "death" );
	self.ignoreTriggers = true;
	if( IsDefined( timer ) )
	{
		wait( timer );
	}
	else
	{
		wait( 0.5 );
	}
	self.ignoreTriggers = false;
}

is_hero()
{
	return IsDefined( level.hero_list[ get_ai_number() ] );
}

get_ai_number()
{
	if( !IsDefined( self.ai_number ) )
	{
		set_ai_number();
	}
	return self.ai_number;
}

set_ai_number()
{
	if ( !IsDefined( level.ai_number ) )
	{
		level.ai_number = 0;
	}
	
	self.ai_number = level.ai_number;
	level.ai_number++ ;
}

/@
"Name: make_hero()"
"Summary: Will make the AI a hero.  This will call magic_bullet_shield on them as well as other hero behaviors."
"Module: AI"
"CallOn: Friendly AI"
"Example: hero_guy make_hero();"
"SPMP: singleplayer"
@/
make_hero( ent )
{
	DEFAULT( ent, self );
	
	if ( !IsDefined( level.hero_list[ ent.ai_number ] ) )
	{
		ent magic_bullet_shield();

		level.hero_list[ ent.ai_number ] = ent;

		// start IK processing
		// AI_TODO - no IK needed currently
		//self.ikpriority = 5;

		ent thread unmake_hero_on_death();
	}
}

unmake_hero_on_death()
{
	self waittill("death");

	level.hero_list[ self.ai_number ] = undefined;
}

/@
"Name: unmake_hero()"
"Summary: Removes the AI from the hero list and stops hero behaviors running on the AI such as magic_bullet_shield."
"Module: AI"
"CallOn: Friendly AI"
"Example: hero_guy unmake_hero();"
"SPMP: singleplayer"
@/
unmake_hero( ent )
{
	DEFAULT( ent, self );
	
	ent stop_magic_bullet_shield();
	level.hero_list[ ent.ai_number ] = undefined;

	// stop IK processing
	// AI_TODO - no IK needed currently
	ent.ikpriority = 0;
}

/@
"Name: get_heroes()"
"Summary: Returns an array of all heroes currently in the level."
"Module: AI"
"Example: heroes = get_heroes();"
"SPMP: singleplayer"
@/
get_heroes()
{
	return level.hero_list;
}

/@
"Name: replace_on_death()"
"Summary: Will replace a color guy after he dies. Good for manually putting a respawnable guy onto a color chain."
"Module: Utility"
"CallOn: an actor"
"Example: new_color_guy thread replace_on_death();"
"SPMP: singleplayer"
@/
replace_on_death()
{
	maps\_colors::colorNode_replace_on_death();
}

/@
"Name: remove_dead_from_array( <array> )"
"Summary: Takes an array, removes any dead entities, and returns the rest as a new array."
"Module: Utility"
"Example: guys_still_alive = remove_dead_from_array( squad_1 );"
"MandatoryArg: <array> : the array to search through"
"SPMP: singleplayer"
@/
remove_dead_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		if( !isalive( array[ i ] ) )
		{
			continue;
		}
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_heroes_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		if( array[ i ] is_hero() )
		{
			continue;
		}
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}
/@
"Name: remove_all_animnamed_guys_from_array( <array> )"
"Summary: Takes an array, removes the entities with an animname, and returns the rest as a new array."
"Module: Utility"
"Example: new_guys = remove_noteworthy_from_array( squad_1, "medic" );"
"MandatoryArg: <array> : the array to search through"
"SPMP: singleplayer"
@/
remove_all_animnamed_guys_from_array( array )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		if( IsDefined( array[ i ].animname ) )
		{
			continue;
		}
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_color_from_array( array, color )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		guy = array[ i ];
		if( !IsDefined( guy.script_forceColor ) )
		{
			continue;
		}
		if( guy.script_forceColor == color )
		{
			continue;
		}
		newarray[ newarray.size ] = guy;
	}
	return newarray;
}

/@
"Name: remove_noteworthy_from_array( <array>, <noteworthy> )"
"Summary: Takes an array, removes the entities with the specified script_noteworthy value, and returns the rest as a new array."
"Module: Utility"
"Example: new_guys = remove_noteworthy_from_array( squad_1, "medic" );"
"MandatoryArg: <array> : the array to search through"
"MandatoryArg: <noteworthy> : the noteworthy value you want to filter out"
"SPMP: singleplayer"
@/
remove_noteworthy_from_array( array, noteworthy )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		guy = array[ i ];
		// SCRIPTER_MOD: dguzzo: 3/23/2009 : this makes no sense to do
		//		if( !IsDefined( guy.script_noteworthy ) )
		//			continue;
		if( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == noteworthy )
		{
			continue;
		}
		newarray[ newarray.size ] = guy;
	}
	return newarray;
}



remove_without_classname( array, classname )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		if( !issubstr( array[ i ].classname, classname ) )
		{
			continue;
		}
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_without_model( array, model )
{
	newarray = [];
	for( i = 0; i < array.size; i++ )
	{
		if( !issubstr( array[ i ].model, model ) )
		{
			continue;
		}
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}


wait_for_either_trigger( str_targetname1, str_targetname2 )
{
	ent = SpawnStruct();
	array = [];
	array = ArrayCombine( array, GetEntArray( str_targetname1, "targetname" ), true, false );
	array = ArrayCombine( array, GetEntArray( str_targetname2, "targetname" ), true, false );
	for( i = 0; i < array.size; i++ )
	{
		ent thread ent_waits_for_trigger( array[ i ] );
	}

	ent waittill( "done", t_hit );
	return t_hit;
}

get_trigger_flag(flag_name_override)
{
	if (IsDefined(flag_name_override))
	{
		return flag_name_override;
	}

	if( IsDefined( self.script_flag ) )
	{
		return self.script_flag;
	}

	if( IsDefined( self.script_noteworthy ) )
	{
		return self.script_noteworthy;
	}

	assert( 0, "Flag trigger at " + self.origin + " has no script_flag set." );
}

/@
"Name: is_spawner( <ent> )"
"Summary: Checks if an entity is a spawner, returns true or false"
"Module: AI"
"CallOn: an entity"
"MandatoryArg: <ent> : The entity."
"Example: if ( is_spawner( guy ) )..."
"SPMP: singleplayer"
@/
is_spawner( ent )
{
	b_spawner = false;
	if ( IS_VEHICLE( ent ) )
	{
		b_spawner = ent has_spawnflag( SPAWNFLAG_VEHICLE_SPAWNER );
	}
	else
	{
		b_spawner = IsSpawner( ent );
	}
	
	return b_spawner;
}

set_default_pathenemy_settings()
{
	self.pathEnemyLookAhead = 192;
	self.pathEnemyFightDist = 192;
}

/@
"Name: enable_heat()"
"Summary: Puts an AI into heat mode."
"Module: AI"
"CallOn: an actor"
"Example: guy enable_heat();"
"SPMP: singleplayer"
@/
enable_heat()
{
	self thread animscripts\anims_table::setup_heat_anim_array();
}


/@
"Name: disable_heat()"
"Summary: turn off heat mode."
"Module: AI"
"CallOn: an actor"
"Example: guy disable_heat();"
"SPMP: singleplayer"
@/
disable_heat()
{
	self thread animscripts\anims_table::reset_heat_anim_array();
}

/@
"Name: enable_cqb()"
"Summary: turn on cqb mode."
"Module: AI"
"CallOn: an actor"
"Example: guy enable_cqb();"
"SPMP: singleplayer"
@/
enable_cqb()
{
	if( self animscripts\utility::AIHasOnlyPistol() )
		return;
	
	self.cqb = true;
	level thread animscripts\cqb::findCQBPointsOfInterest();
	self thread animscripts\anims_table_cqb::setup_cqb_anim_array();

	/#self thread animscripts\cqb::CQBDebug();#/
}

/@
"Name: disable_cqb()"
"Summary: turn off cqb mode."
"Module: AI"
"CallOn: an actor"
"Example: guy disable_cqb();"
"SPMP: singleplayer"
@/
disable_cqb()
{
	if(!IsDefined(self) && (!IsAlive(self)) )
		return;
			
	self.cqb					= false;
	self.cqb_point_of_interest	= undefined;
	self thread animscripts\anims_table_cqb::reset_cqb_anim_array();

	/#self notify( "end_cqb_debug" );#/
}

/@
"Name: set_cqb_run_anim()"
"Summary: Modify run anim for cqb mode."
"Module: AI"
"CallOn: an actor"
"Example: guy set_cqb_run_anim();"
"SPMP: singleplayer"
@/
set_cqb_run_anim( runAnim, walkAnim, sprintAnim )
{
	self thread animscripts\anims_table_cqb::set_cqb_run_anim( runAnim, walkAnim, sprintAnim );
}


/@
"Name: clear_cqb_run_anim()"
"Summary: Clear run anim for cqb mode."
"Module: AI"
"CallOn: an actor"
"Example: guy clear_cqb_run_anim();"
"SPMP: singleplayer"
@/
clear_cqb_run_anim()
{
	self thread animscripts\anims_table_cqb::clear_cqb_run_anim();
}

/@
"Name: change_movemode()"
"Summary: call it on AI to change move modes. Available modes are run(default), walk, sprint, cqb_run/cqb(default), cqb_walk, cqb_sprint."
"Module: AI"
"CallOn: an actor"
"Example: guy change_movemode();"
"SPMP: singleplayer"
@/
change_movemode( moveMode )
{
	self notify( "change_movemode", moveMode );

	if( !IsDefined( moveMode ) )
		moveMode = "run";

	// save elite state, only do it once for multiple/subsequent change movemode calls, until reset is called.
	if( IS_TRUE( self.elite ) && self.subclass == "elite" )
		self maps\ai_subclass\_subclass_elite::disable_elite();
	
	// turn CQB on/off
	if( IsSubStr( moveMode, "cqb" ) )
		enable_cqb();
	else
		disable_cqb();

	switch ( moveMode )
	{
		case "run":
		case "cqb_run":
		case "cqb":
		{
			self.sprint = false;
			self.walk	= false;
		}
		break;
		case "cqb_walk":
		case "walk":
		{
			self.sprint = false;
			self.walk	= true;
		}
		break;
		case "sprint":
		case "cqb_sprint":
		{
			self.sprint = true;
			self.walk	= false;
		}
		break;
		case "default":
		{
			AssertMsg( "Unsupported move mode." );
		}
	}
}

/@
"Name: reset_movemode()"
"Summary: call it on AI to change the movemode to default."
"Module: AI"
"CallOn: an actor"
"Example: guy reset_movemode();"
"SPMP: singleplayer"
@/
reset_movemode()
{
	disable_cqb();

	// restore elite
	if( IS_TRUE( self.elite ) )
		maps\ai_subclass\_subclass_elite::enable_elite();
		
	self.sprint = false;
	self.walk	= false;
}

/@
"Name: disable_tactical_walk"
"Summary: Disable close face enemy tactical walk behavior."
"Module: AI"
"CallOn: an actor"
"Example: guy disable_tactical_walk();"
"SPMP: singleplayer"
@/
disable_tactical_walk()
{
	Assert( IsAI( self ), "Tried to disable_tactical_walk but it wasn't called on an AI" );

	self.old_maxfaceenemydist = self.maxfaceenemydist;
	self.maxfaceenemydist = 0;
}


/@
"Name: enable_tactical_walk"
"Summary: Enable close face enemy tactical walk behavior."
"Module: AI"
"CallOn: an actor"
"Example: guy enable_tactical_walk();"
"SPMP: singleplayer"
@/
enable_tactical_walk()
{
	Assert( IsAI( self ), "Tried to enable_tactical_walk but it wasn't called on an AI" );

	if( IsDefined ( self.old_maxfaceenemydist ) )
		self.maxfaceenemydist = self.old_maxfaceenemydist;
	else
		self.maxfaceenemydist = anim.moveGlobals.CODE_FACE_ENEMY_DIST; // 512 units
}


/@
"Name: cqb_aim(the_target)"
"Summary: Sets a tartget when doing CQB walk."
"Module: AI"
"CallOn: an actor"
"Example: guy cqb_aim(the_target);"
"SPMP: singleplayer"
@/
cqb_aim( the_target )
{
	if( !IsDefined( the_target ) )
	{
		self.cqb_target = undefined;
	}
	else
	{
		self.cqb_target = the_target;

		if( !IsDefined( the_target.origin ) )
		{
			assertmsg( "target passed into cqb_aim does not have an origin!" );
		}
	}
}

/@
"Name: waittill_notify_or_timeout( <msg>, <timer> )"
"Summary: Waits until the owner receives the specified notify message or the specified time runs out. Do not thread this!"
"Module: Utility"
"CallOn: an entity"
"Example: tank waittill_notify_or_timeout( "turret_on_target", 10 ); "
"MandatoryArg: <msg> : The notify to wait for."
"MandatoryArg: <timer> : The amount of time to wait until overriding the wait statement."
"SPMP: singleplayer"
@/
waittill_notify_or_timeout( msg, timer )
{
	self endon( msg );
	wait( timer );
}

/@
"Name: waittill_any_or_timeout( <timer>, <msg1>, <msg2>, <msg3>, <msg4>, <msg5> )"
"Summary: Waits until the owner receives the specified notify message or the specified time runs out. Do not thread this!"
"Module: Utility"
"CallOn: an entity"
"Example: tank waittill_any_or_timeout( 10, "turret_on_target"); "
"MandatoryArg: <timer> : The amount of time to wait until overriding the wait statement."
"MandatoryArg: <msg1> : The notify to wait for."
"MandatoryArg: <msg2> : The notify to wait for."
"MandatoryArg: <msg3> : The notify to wait for."
"MandatoryArg: <msg4> : The notify to wait for."
"MandatoryArg: <msg5> : The notify to wait for."
"SPMP: singleplayer"
@/
waittill_any_or_timeout( timer, string1, string2, string3, string4, string5  )
{
	assert( IsDefined( string1 ) );
	
	self endon( string1 );
	
	if ( IsDefined( string2 ) )
	{
		self endon( string2 );
	}

	if ( IsDefined( string3 ) )
	{
		self endon( string3 );
	}

	if ( IsDefined( string4 ) )
	{
		self endon( string4 );
	}

	if ( IsDefined( string5 ) )
	{
		self endon( string5 );
	}
			
	wait( timer );
}



getfx( fx )
{
	assert( IsDefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}

/@
"Name: play_fx( <str_fx>, <v_origin>, [v_angles], [time_to_delete_or_notify], [b_link_to_self], [str_tag] )"
"Summary: play an effect at an origin or relative to an entity for a time or unitl a notify."
"Module: Utility"
"CallOn: level or entity to link fx to"
"MandatoryArg: <str_fx> : identifier of fx."
"MandatoryArg: <v_origin> : origin to play fx."
"OptionalArg: [v_angles] : angles to play fx."
"OptionalArg: [time_to_delete_or_notify] : when to delete to fx entity (time or notify). can be undefined if linking to an ent. it will die when it dies."
"OptionalArg: [b_link_to_self] : set to true to link to the entity this function is called on."
"OptionalArg: [str_tag] : tag to link to if linking."
"OptionalArg: [b_no_cull] : set to true to force it to not cull out."
"Example: e_ent play_fx( "splosion", undefined, undefined, 3, true, "tag_bone" );"
"SPMP: SP"
@/
play_fx( str_fx, v_origin, v_angles, time_to_delete_or_notify, b_link_to_self, str_tag, b_no_cull )
{
	if ( ( !IsDefined( time_to_delete_or_notify ) || ( !IsString( time_to_delete_or_notify ) && time_to_delete_or_notify == -1 ) )
	    && IS_TRUE( b_link_to_self ) && IsDefined( str_tag ) )
	{
		PlayFXOnTag( getfx( str_fx ), self, str_tag );
	}
	else
	{
		m_fx = spawn_model( "tag_origin", v_origin, v_angles );
		
		if ( IS_TRUE( b_link_to_self ) )
		{
			if ( IsDefined( str_tag ) )
			{
				m_fx LinkTo( self, str_tag, (0, 0, 0), (0, 0, 0) );
			}
			else
			{
				m_fx LinkTo( self );
			}
		}
		
		if ( IS_TRUE( b_no_cull ) )
		{
			m_fx setforcenocull();
		}
		
		PlayFXOnTag( getfx( str_fx ), m_fx, "tag_origin" );
		m_fx thread _play_fx_delete( self, time_to_delete_or_notify );
	}
}

_play_fx_delete( ent, time_to_delete_or_notify = (-1) )
{
	if ( IsString( time_to_delete_or_notify ) )
	{
		ent waittill_either( "death", time_to_delete_or_notify );
	}
	else if ( time_to_delete_or_notify > 0 )
	{
		ent waittill_notify_or_timeout( "death", time_to_delete_or_notify );
	}
	else
	{
		ent waittill( "death" );
	}
	
	self Delete();
}

getanim( anime )
{
	assert( IsDefined( self.animname ), "Called getanim on a guy with no animname" );
	assert( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Called getanim on an inexistent anim.  Animname:"+self.animname+".  Animname:"+anime );
	return level.scr_anim[ self.animname ][ anime ];
}

getanim_from_animname( anime, animname )
{
	assert( IsDefined( animname ), "Must supply an animname" );
	assert( IsDefined( level.scr_anim[ animname ][ anime ] ), "Called getanim on an inexistent anim" );
	return level.scr_anim[ animname ][ anime ];
}

getanim_generic( anime )
{
	assert( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Called getanim_generic on an inexistent anim" );
	return level.scr_anim[ "generic" ][ anime ];
}

add_hint_string( name, string, optionalFunc )
{
	assert( IsDefined( level.trigger_hint_string ), "Tried to add a hint string before _load was called." );
	assert( IsDefined( name ), "Set a name for the hint string. This should be the same as the script_hint on the trigger_hint." );
	assert( IsDefined( string ), "Set a string for the hint string. This is the string you want to appear when the trigger is hit." );

	level.trigger_hint_string[ name ] = string;
	precachestring( string );
	if( IsDefined( optionalFunc ) )
	{
		level.trigger_hint_func[ name ] = optionalFunc;
	}
}

ThrowGrenadeAtPlayerASAP()
{
	animscripts\combat_utility::ThrowGrenadeAtPlayerASAP_combat_utility();
}


/@
"Name: switch_weapon_ASAP "
"Summary:  AI Feature - Sumeet - Will force an AI to switch the weapon ASAP. This function will send "weapon_switched" notification once weapon switching is done. "
"Module: AI"
"CallOn: an actor"
"Example: dude switch_weapon_ASAP();"
"MandatoryArg:"
"OptionalArg: "
"SP: singleplayer"
@/

switch_weapon_ASAP()
{
	assert(IsAI(self), "Can only call this function on an AI character");

	// Check if AI is alive and weapon switching is not already being processed.
	if( IsAlive(self) && !self.a.weapon_switch_ASAP )
		self.a.weapon_switch_ASAP = true;
}

// scriptgen precache wrapper commands - Nathan
// This will enable automatic zone source CSV exports if approved

/*
It's important that when you write scripts with sg_precache in
them that you halt the scripts that use these assets when a scriptgen dump is required.

If done currectly before the scriptgen dump call all of of the sg_precache commands will happen
and you won't have to run the game again to catch new sg_precaches;

Do this to wait untill the sg_precache dump has been called( now it's ok to continue );

sg_wait_dump();

sg_precache lines should go before _load but in the case of tools they can go after.
IE in effectsEd somebody could initiate a dump after specifying some new assets to load.

*/

sg_precachemodel( model )
{
	script_gen_dump_addline( "precachemodel( \"" + model + "\" );", "xmodel_" + model );// adds to scriptgendump

}

sg_precacheitem( item )
{
	script_gen_dump_addline( "precacheitem( \"" + item + "\" );", "item_" + item );// adds to scriptgendump
}

sg_precachemenu( menu )
{
	script_gen_dump_addline( "precachemenu( \"" + menu + "\" );", "menu_" + menu );// adds to scriptgendump
}

sg_precacherumble( rumble )
{
	script_gen_dump_addline( "precacherumble( \"" + rumble + "\" );", "rumble_" + rumble );// adds to scriptgendump
}

sg_precacheshader( shader )
{
	script_gen_dump_addline( "precacheshader( \"" + shader + "\" );", "shader_" + shader );// adds to scriptgendump
}

sg_precacheshellshock( shock )
{
	script_gen_dump_addline( "precacheshellshock( \"" + shock + "\" );", "shock_" + shock );// adds to scriptgendump
}

sg_precachestring( string )
{
	script_gen_dump_addline( "precachestring( \"" + string + "\" );", "string_" + string );// adds to scriptgendump
}

sg_precacheturret( turret )
{
	script_gen_dump_addline( "precacheturret( \"" + turret + "\" );", "turret_" + turret );// adds to scriptgendump
}

sg_precachevehicle( vehicle )
{
	script_gen_dump_addline( "precachevehicle( \"" + vehicle + "\" );", "vehicle_" + vehicle );// adds to scriptgendump
}

sg_getanim( animation )
{
	return level.sg_anim[ animation ];
}

sg_getanimtree( animtree )
{
	return level.sg_animtree[ animtree ];
}



sg_precacheanim( animation, animtree )
{
	if( !IsDefined( animtree ) )
	{
		animtree = "generic_human";
	}
	/*
	this is where the money is at.  we no longer have to seperate scripts that have animations in them
	this eliminates the need for seperate vehiclescript calls, gags with animations, etc.
	animations are a string value when sg_precacheanim is called this writes them to the script gen and the CSV as animations
	usage is something like this

	sg_precacheanim( animation );

	when you go to use the anim do:

	animation = sg_getanim( animation );

	this will get the animation from scriptgen.

	*/
	// 	script_gen_dump_addline( "level.sg_anim[ \"" + animation + "\" ] = %" + animation + ";", "animation_" + animation );// adds to scriptgendump

	sg_csv_addtype( "xanim", animation );
	if( !IsDefined( level.sg_precacheanims ) )
	{
		level.sg_precacheanims = [];
	}
	if( !IsDefined( level.sg_precacheanims[ animtree ] ) )
	{
		level.sg_precacheanims[ animtree ] = [];
	}

	level.sg_precacheanims[ animtree ][ animation ] = true;// no sence setting it to anything else if the string is already in array key. beh.
}



sg_getfx( fx )
{
	return level.sg_effect[ fx ];
}

sg_precachefx( fx )
{
	/*

	effects require an id returned from loadfx. it's a little bit different kind of asset but will work the same as animations

	use

	sg_getfx( fx ); to get the effects id for the specified effect string

	*/
	script_gen_dump_addline( "level.sg_effect[ \"" + fx + "\" ] = loadfx( \"" + fx + "\" );", "fx_" + fx );// adds to scriptgendump
}

sg_wait_dump()
{
	flag_wait( "scriptgen_done" );
}

sg_standard_includes()
{

	sg_csv_addtype( "ignore", "code_post_gfx" );
	sg_csv_addtype( "ignore", "common" );
	sg_csv_addtype( "col_map_sp", "maps/" + tolower( GetDvar( "mapname" ) ) + ".d3dbsp" );
	sg_csv_addtype( "gfx_map", "maps/" + tolower( GetDvar( "mapname" ) ) + ".d3dbsp" );
	sg_csv_addtype( "rawfile", "maps/" + tolower( GetDvar( "mapname" ) ) + ".gsc" );
	sg_csv_addtype( "rawfile", "maps / scriptgen/" + tolower( GetDvar( "mapname" ) ) + "_scriptgen.gsc" );

	sg_csv_soundadd( "us_battlechatter", "all_sp" );// todo. find this automagically by ai's
	sg_csv_soundadd( "ab_battlechatter", "all_sp" );//

	sg_csv_soundadd( "voiceovers", "all_sp" );
	sg_csv_soundadd( "common", "all_sp" );
	sg_csv_soundadd( "generic", "all_sp" );
	sg_csv_soundadd( "requests", "all_sp" );

	// 	ignore, code_post_gfx
	// 	ignore, common
	// 	col_map_sp, maps / nate_test.d3dbsp
	// 	gfx_map, maps / nate_test.d3dbsp
	// 	rawfile, maps / nate_test.gsc
	// 	sound, voiceovers, rallypoint, all_sp
	// 	sound, us_battlechatter, rallypoint, all_sp
	// 	sound, ab_battlechatter, rallypoint, all_sp
	// 	sound, common, rallypoint, all_sp
	// 	sound, generic, rallypoint, all_sp
	// 	sound, requests, rallypoint, all_sp

}

sg_csv_soundadd( type, loadspec )
{
	script_gen_dump_addline( "nowrite Sound CSV entry: " + type, "sound_" + type + ", " + tolower( GetDvar( "mapname" ) ) + ", " + loadspec );// adds to scriptgendump
}

sg_csv_addtype( type, string )
{
	script_gen_dump_addline( "nowrite CSV entry: " + type + ", " + string, type + "_" + string );// adds to scriptgendump
}


set_ignoreSuppression( val )
{
	self.ignoreSuppression = val;
}

set_goalradius( radius )
{
	self.goalradius = radius;
}

set_allowdeath( val )
{
	self.allowdeath = val;
}

/@
"Name: set_run_anim( <anime>, <alwaysRunForward> )"
"Summary: Sets an actor's run anim, based on their animname."
"Module: AI"
"CallOn: an actor"
"Example: guy set_run_anim( "run_cautious" );"
"MandatoryArg: <anime> : the name of the anim as defined in the level.scr_anim array"
"OptionalArg: <alwaysRunForward> : Boolean : Sets the actor's .alwaysRunForward value."
"SPMP: singleplayer"
@/
set_run_anim( anime, alwaysRunForward )
{
	assert( IsDefined( anime ), "Tried to set run anim but didn't specify which animation to ues" );
	assert( IsDefined( self.animname ), "Tried to set run anim on a guy that had no anim name" );
	assert( IsDefined( level.scr_anim[ self.animname ][ anime ] ), "Tried to set run anim but the anim was not defined in the maps _anim file" );

	//this is good for slower run animations like patrol walks
	if( IsDefined( alwaysRunForward ) )
	{
		self.alwaysRunForward = alwaysRunForward;
	}
	else
	{
		self.alwaysRunForward = true;
	}

	self.a.combatrunanim = level.scr_anim[ self.animname ][ anime ];
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}

/@
"Name: set_generic_run_anim( <anime>, <alwaysRunForward> )"
"Summary: Sets an actor's run anim, based on the "generic" animname in level.scr_anim."
"Module: AI"
"CallOn: an actor"
"Example: guy set_generic_run_anim( "run_cautious" );"
"MandatoryArg: <anime> : the name of the anim as defined in the level.scr_anim array"
"OptionalArg: <alwaysRunForward> : Boolean : Sets the actor's .alwaysRunForward value."
"SPMP: singleplayer"
@/
set_generic_run_anim( anime, alwaysRunForward )
{
	assert( IsDefined( anime ), "Tried to set generic run anim but didn't specify which animation to ues" );
	assert( IsDefined( level.scr_anim[ "generic" ][ anime ] ), "Tried to set generic run anim but the anim was not defined in the maps _anim file" );

	//this is good for slower run animations like patrol walks
	if ( IsDefined( alwaysRunForward ) )
	{
		if ( alwaysRunForward )
		{
			self.alwaysRunForward = alwaysRunForward;
		}
		else
		{
			self.alwaysRunForward = undefined;
		}
	}
	else
	{
		self.alwaysRunForward = true;
	}

	self.a.combatrunanim = level.scr_anim[ "generic" ][ anime ];
	self.run_noncombatanim = self.a.combatrunanim;
	self.walk_combatanim = self.a.combatrunanim;
	self.walk_noncombatanim = self.a.combatrunanim;
	self.preCombatRunEnabled = false;
}

/@
"Name: clear_run_anim()"
"Summary: Clears any set run anims "
"Module: AI"
"CallOn: an actor"
"Example: guy clear_run_anim();"
"SPMP: singleplayer"
@/
clear_run_anim()
{
	self.alwaysRunForward = undefined;
	self.a.combatrunanim = undefined;
	self.run_noncombatanim = undefined;
	self.walk_combatanim = undefined;
	self.walk_noncombatanim = undefined;
	self.preCombatRunEnabled = true;
}

physicsjolt_proximity( outer_radius, inner_radius, force )
{
	// Usage: <entity > thread physicjolt_proximity( 400, 256, ( 0, 0, 0.1 ) );

	self endon( "death" );
	self endon( "stop_physicsjolt" );

	if( !IsDefined( outer_radius ) || !IsDefined( inner_radius ) || !IsDefined( force ) )
	{
		outer_radius = 400;
		inner_radius = 256;
		force = ( 0, 0, 0.075 );	 // no direction on this one.
	}

	fade_distance = outer_radius * outer_radius;

	const fade_speed = 3;
	base_force = force;

	while( true )
	{
		wait 0.1;

		force = base_force;

		if( self.classname == "script_vehicle" )
		{
			speed = self getspeedMPH();
			if( speed < fade_speed )
			{
				scale = speed / fade_speed;
				force = VectorScale( base_force, scale );
			}
		}
		// SCRIPTER_MOD: dguzzo: 3-19-09 : no more level.player
		//		dist = distancesquared( self.origin, level.player.origin );
		dist = distancesquared( self.origin, get_players()[0].origin );
		scale = fade_distance / dist;
		if( scale > 1 )
		{
			scale = 1;
		}
		force = VectorScale( force, scale );
		total_force = force[ 0 ] + force[ 1 ] + force[ 2 ];

		//if( total_force > 0.025 )
		//	physicsJitter( self.origin, outer_radius, inner_radius, force[ 2 ], force[ 2 ] * 2.0 );
	}
}



activate_trigger()
{
	assert( !IsDefined( self.trigger_off ), "Tried to activate trigger that is OFF( either from trigger_off or from flags set on it through shift - G menu" );

	if( IsDefined( self.script_color_allies ) )
	{
		// so we don't run activate_color_trigger twice, we set this var
		self.activated_color_trigger = true;
		maps\_colors::activate_color_trigger( "allies" );
	}

	if( IsDefined( self.script_color_axis ) )
	{
		// so we don't run activate_color_trigger twice, we set this var
		self.activated_color_trigger = true;
		maps\_colors::activate_color_trigger( "axis" );
	}

	self notify( "trigger" );
}

/@
"Name: self_delete()"
"Summary: Just calls the delete() script command on self. Reason for this is so that we can use array_thread to delete entities"
"Module: Entity"
"CallOn: An entity"
"Example: ai[ 0 ] thread self_delete();"
"SPMP: singleplayer"
@/
self_delete()
{
	if ( IsDefined( self ) )
	{
		self delete();
	}
}

has_color()
{
	// can lose color during the waittillframeend in left_color_node
	if ( self.team == "axis" )
	{
		return IsDefined( self.script_color_axis ) || IsDefined( self.script_forceColor );
	}

	return IsDefined( self.script_color_allies ) || IsDefined( self.script_forceColor );
}

get_script_palette()
{
	rgb = [];
	rgb[ "r" ] = ( 1, 0, 0 );
	rgb[ "o" ] = ( 1, 0.5, 0 );
	rgb[ "y" ] = ( 1, 1, 0 );
	rgb[ "g" ] = ( 0, 1, 0 );
	rgb[ "c" ] = ( 0, 1, 1 );
	rgb[ "b" ] = ( 0, 0, 1 );
	rgb[ "p" ] = ( 1, 0, 1 );
	return rgb;
}

/@
"Name: notify_delay( <notify_string> , <delay> )"
"Summary: Notifies self the string after waiting the specified delay time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <notify_string> : The string to notify"
"MandatoryArg: <delay> : Time to wait( in seconds ) before sending the notify."
"Example: vehicle notify_delay( "start_to_smoke", 3.5 );"
"SPMP: singleplayer"
@/
notify_delay( sNotifyString, fDelay )
{
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

/@
"Name: gun_remove()"
"Summary: Removed the gun from the given AI. Often used for scripted sequences where you dont want the AI to carry a weapon."
"Module: AI"
"CallOn: An AI"
"Example: level.price gun_remove();"
"SPMP: singleplayer"
@/
gun_remove()
{
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
}

/@
"Name: gun_switchto()"
"Summary: Switches the given AI's gun to the one specified."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <weaponName> : The weapontype name you want the AI to switch to."
"MandatoryArg: <whichHand> : Which hand to put the weapon in."
"Example: level.zeitzev gun_switchto( "ppsh", "right" );"
"SPMP: singleplayer"
@/
gun_switchto( weaponName, whichHand )
{
	self animscripts\shared::placeWeaponOn( weaponName, whichHand );
}

/@
"Name: gun_recall()"
"Summary: Give the AI his gun back."
"Module: AI"
"CallOn: An AI"
"Example: level.price gun_recall();"
"SPMP: singleplayer"
@/
gun_recall()
{
	self animscripts\shared::placeWeaponOn( self.weapon, "right" );
}

/@
"Name: custom_ai_weapon_loadout( <primaryWeapon>, [secondaryWeapon], [sideArm])"
"Summary: Override the GDT settings for this particular AI."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <primaryWeapon> : The primary weapon the AI will be armed with"
"OptionalArg: [secondaryWeapon] : Secondary weapon (will be stowed on back)"
"OptionalArg: [sideArm] : The sidearm weapon"
"Example: level.price custom_ai_weapon_loadout( "ak47_sp", "rpg_sp" );"
"SPMP: singleplayer"
@/
custom_ai_weapon_loadout( primary, secondary, sidearm )
{
	// remove everything
	self animscripts\shared::detachAllWeaponModels();

	if( IsDefined(self.primaryweapon) && self.primaryweapon != "" )
	{
		self animscripts\shared::detachWeapon(self.primaryweapon);
	}

	if( IsDefined(self.secondaryweapon) && self.secondaryweapon != "" )
	{
		self animscripts\shared::detachWeapon(self.secondaryweapon);
	}

	if( IsDefined(self.sideArm) && self.sideArm != "" )
	{
		self animscripts\shared::detachWeapon(self.sideArm);
	}

	self setPrimaryWeapon("");
	self setSecondaryWeapon("");
	self.sidearm			= "";

	// set up the primary
	if( IsDefined(primary) )
	{
		if( GetWeaponModel(primary) != "" )
		{
			self setPrimaryWeapon(primary);

			self animscripts\init::initWeapon( self.primaryweapon );
			self animscripts\shared::placeWeaponOn( self.primaryweapon, "right");
		}
		else
		{
			assert( false, "custom_ai_weapon_loadout: primary weapon " + primary + " is not in a csv or isn't precached" );
		}
	}

	// set up the secondary
	if( IsDefined(secondary) )
	{
		if( GetWeaponModel(secondary) != "" )
		{
			self setSecondaryWeapon(secondary);
			self animscripts\init::initWeapon( self.secondaryweapon );
			self animscripts\shared::placeWeaponOn( self.secondaryweapon, "back");
		}
		else
		{
			assert( false, "custom_ai_weapon_loadout: secondary weapon " + secondary + " is not in a csv or isn't precached" );
		}
	}

	// set up the sidearm
	if( IsDefined(sidearm) )
	{
		if( GetWeaponModel(sidearm) != "" )
		{
			self.sidearm = sidearm;
			self animscripts\init::initWeapon( self.sidearm );
		}
		else
		{
			assert( false, "custom_ai_weapon_loadout: sidearm weapon " + sidearm + " is not in a csv or isn't precached" );
		}
	}

	// set the current weapon
	self setCurrentWeapon(self.primaryweapon);
	self animscripts\weaponList::RefillClip();

	// set sniper
	self.isSniper = animscripts\combat_utility::isSniperRifle( self.weapon );
}

/@
"Name: lerp_player_view_to_tag( <tag> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc> )"
"Summary: Lerps the player's view to the tag on the entity that calls the function.."
"Module: Player"
"CallOn: An entity you want to lerp the player's view to."
"MandatoryArg: <ent> : The entity you want to link self (player) to."
"MandatoryArg: <tag> : Tag on the entity that you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the entity. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"Example: players[0] lerp_player_view_to_tag( car, "tag_windshield", 1 );"
"SPMP: singleplayer"
@/

lerp_player_view_to_tag( ent, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	lerp_player_view_to_tag_internal( ent, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, undefined );
}

/@
"Name: lerp_player_view_to_tag_and_hit_geo( <tag> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc> )"
"Summary: Lerps the player's view to the tag on the entity that calls the function. Geo will block the player."
"Module: Player"
"CallOn: An entity you want to lerp the player's view to."
"MandatoryArg: <tag> : Tag on the entity that you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the entity. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"Example: car lerp_player_view_to_tag_and_hit_geo( "tag_windshield", 1 );"
"SPMP: singleplayer"
@/

lerp_player_view_to_tag_and_hit_geo( ent, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	lerp_player_view_to_tag_internal( ent, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, true );
}

/@
"Name: lerp_player_view_to_position( <origin> , <angles> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc>, <hit_geo> )"
"Summary: Lerps the player's view to an origin and angles. See lerp_player_view_to_tag."
"Module: Player"
"MandatoryArg: <origin> : The origin you're lerping to."
"MandatoryArg: <angles> : The angles you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the destination angles. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <hit_geo> : Sets if the player will hit geo."
"Example: lerp_player_view_to_position( org.origin, org.angles );"
"SPMP: singleplayer"
@/

lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	linker = spawn( "script_origin", ( 0, 0, 0 ) );
	linker.origin = self.origin;
	linker.angles = self getplayerangles();

	if( IsDefined( hit_geo ) )
	{
		self playerlinkto( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
	}
	else if( IsDefined( right_arc ) )
	{
		self playerlinkto( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
	}
	else if( IsDefined( fraction ) )
	{
		self playerlinkto( linker, "", fraction );
	}
	else
	{
		self playerlinkto( linker );
	}

	linker moveto( origin, lerptime, lerptime * 0.25 );
	linker rotateto( angles, lerptime, lerptime * 0.25 );
	//	wait( lerptime );
	linker waittill( "movedone" );
	linker delete();
}


/@
"Name: lerp_player_view_to_tag_oldstyle( <tag> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc> )"
"Summary: Lerps the player's view to the tag on the entity that calls the function, using the oldstyle link which moves the player's view when the tag rotates."
"Module: Player"
"CallOn: An entity you want to lerp the player's view to."
"MandatoryArg: <tag> : Tag on the entity that you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the entity. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"Example: car lerp_player_view_to_tag_oldstyle( "tag_windshield", 1 );"
"SPMP: singleplayer"
@/
lerp_player_view_to_tag_oldstyle( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
	lerp_player_view_to_tag_oldstyle_internal( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, false );
}

/@
"Name: lerp_player_view_to_position_oldstyle( <origin> , <angles> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc>, <hit_geo> )"
"Summary: Lerps the player's view to an origin and angles. See lerp_player_view_to_tag_oldstyle. Oldstyle means that you're going to move to the point where the player's feet would be, rather than directly below the point where the view would be."
"Module: Player"
"MandatoryArg: <origin> : The origin you're lerping to."
"MandatoryArg: <angles> : The angles you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the destination angles. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <hit_geo> : Sets if the player will hit geo."
"Example: lerp_player_view_to_position_oldstyle( org.origin, org.angles );"
"SPMP: singleplayer"
@/

lerp_player_view_to_position_oldstyle( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	linker = spawn( "script_origin", ( 0, 0, 0 ) );
	linker.origin = get_player_feet_from_view();
	linker.angles = self getplayerangles();

	if( IsDefined( hit_geo ) )
	{
		self playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
	}
	else if( IsDefined( right_arc ) )
	{
		self playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
	}
	else if( IsDefined( fraction ) )
	{
		self playerlinktodelta( linker, "", fraction );
	}
	else
	{
		self playerlinktodelta( linker );
	}

	linker moveto( origin, lerptime, lerptime * 0.25 );
	linker rotateto( angles, lerptime, lerptime * 0.25 );
	//	wait( lerptime );
	linker waittill( "movedone" );
	linker delete();
}

/@
"Name: lerp_player_view_to_moving_position_oldstyle( <origin> , <angles> , <lerptime> , <fraction> , <right_arc> , <left_arc> , <top_arc> , <bottom_arc>, <hit_geo> )"
"Summary: Lerps the player's view to an origin and angles. See lerp_player_view_to_tag_oldstyle. Oldstyle means that you're going to move to the point where the player's feet would be, rather than directly below the point where the view would be."
"Module: Player"
"MandatoryArg: <origin> : The origin you're lerping to."
"MandatoryArg: <angles> : The angles you're lerping to."
"MandatoryArg: <lerptime> : Time to lerp over."
"OptionalArg: <fraction> : 0 to 1 amount that the rotation of the player's view should be effected by the destination angles. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <right_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <left_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <top_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <bottom_arc> : Arc that limits how far the player can change his view."
"OptionalArg: <hit_geo> : Sets if the player will hit geo."
"Example: lerp_player_view_to_position_oldstyle( org.origin, org.angles );"
"SPMP: singleplayer"
@/

lerp_player_view_to_moving_position_oldstyle( ent, tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	linker = spawn( "script_origin", ( 0, 0, 0 ) );
	linker.origin = self.origin;
	linker.angles = self getplayerangles();

	if( IsDefined( hit_geo ) )
	{
		self playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo );
	}
	else if( IsDefined( right_arc ) )
	{
		self playerlinktodelta( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
	}
	else if( IsDefined( fraction ) )
	{
		self playerlinktodelta( linker, "", fraction );
	}
	else
	{
		self playerlinktodelta( linker );
	}

	max_count=lerptime/0.0167;
	count=0;
	while (count < max_count)
	{
		origin = ent gettagorigin( tag );
		angles = ent gettagangles( tag );

		linker moveto( origin, 0.0167*(max_count-count) );
		linker rotateto( angles, 0.0167*(max_count-count) );
		wait( 0.0167 );
		count++;
	}
	linker delete();
}

/@
"Name: waittill_either_function( <func1> , <parm1> , <func2> , <parm2> )"
"Summary: Returns when either func1 or func2 have returned."
"Module: Utility"
"MandatoryArg: <func1> : A function pointer to a function that may return at some point."
"MandatoryArg: <func2> : Another function pointer to a function that may return at some point."
"OptionalArg: <parm1> : An optional parameter for func1."
"OptionalArg: <parm2> : An optional parameter for func2."
"Example: player_moves( 500 );"
"SPMP: singleplayer"
@/

waittill_either_function( func1, parm1, func2, parm2 )
{
	ent = spawnstruct();
	thread waittill_either_function_internal( ent, func1, parm1 );
	thread waittill_either_function_internal( ent, func2, parm2 );
	ent waittill( "done" );
}

waittill_msg( msg )
{
	if( IsPlayer( self ) )
	{
		self endon( "disconnect" );
	}

	self waittill( msg );
}


/@
"Name: display_hint( <hint> )"
"Summary: Displays a hint created with add_hint_string."
"Module: Utility"
"MandatoryArg: <hint> : The hint reference created with add_hint_string."
"Example: display_hint( "huzzah" )"
"SPMP: singleplayer"
@/
display_hint( hint )
{
	if ( GetDvar( "chaplincheat" ) == "1" )
	{
		return;
	}

	// hint triggers have an optional function they can boolean off of to determine if the hint will occur
	// such as not doing the NVG hint if the player is using NVGs already
	if( IsDefined( level.trigger_hint_func[ hint ] ) )
	{
		if( [[ level.trigger_hint_func[ hint ] ]]() )
		{
			return;
		}

		HintPrint( level.trigger_hint_string[ hint ], level.trigger_hint_func[ hint ] );
	}
	else
	{
		HintPrint( level.trigger_hint_string[ hint ] );
	}
}

/@
"Name: enable_careful()"
"Summary: Makes an AI not advance into his fixednode safe radius if an enemy enters it."
"Module: AI"
"Example: guy enable_careful()"
"SPMP: singleplayer"
@/
enable_careful()
{
	assert( isai( self ), "Tried to make an ai careful but it wasn't called on an AI" );
	self.script_careful = true;
}

/@
"Name: disable_careful()"
"Summary: Turns off careful mode for this AI."
"Module: AI"
"Example: guy disable_careful()"
"SPMP: singleplayer"
@/
disable_careful()
{
	assert( isai( self ), "Tried to unmake an ai careful but it wasn't called on an AI" );
	self.script_careful = false;
	self notify( "stop_being_careful" );
}

/@
"Name: set_fixednode()"
"Summary: Turns AI's fixednode state on/off."
"Module: AI"
"Example: guy set_fixednode( true )"
"SPMP: singleplayer"
@/
set_fixednode( b_toggle )
{
	assert( IsDefined( b_toggle ), "Missing parameter: must set fixednode to true or false" );
	
	self.fixednode = b_toggle;
}

/@
"Name: spawn_ai()"
"Summary: Spawns an AI from an AI spawner. Handles force spawning based on 'script_forcespawn' value."
"Module: Utility"
"OptionalArg: <bForceSpawn>: Set to true to force spawn the AI"
"Example: guy = spawner spawn_ai();"
"SPMP: singleplayer"
@/
spawn_ai( bForceSpawn, str_targetname )
{
	ai = undefined;
	
	// SUMEET - This check is to avoid script errors due to spawning two AI's from the same spawner on the
	// same frame.
	if( IsDefined( self.lastSpawnTime ) && self.lastSpawnTime >= GetTime() )
	{
		WAIT_FRAME;
	}

	no_enemy_info = IS_TRUE( self.script_noenemyinfo );
	no_threat_update_on_first_frame = IS_TRUE( self.script_no_threat_on_spawn );
	delete_on_count_zero = IS_TRUE( self.script_delete_on_zero );
	
	if ( has_spawnflag( SPAWNFLAG_ACTOR_SCRIPTFORCESPAWN ) || IsDefined( self.script_forcespawn ) || IS_TRUE( bForceSpawn ) )
	{
		ai = self StalingradSpawn( no_enemy_info, str_targetname, no_threat_update_on_first_frame );
	}
	else
	{
		ai = self DoSpawn( no_enemy_info, str_targetname, no_threat_update_on_first_frame );
	}

	// Store the last spawned time on the spawner
	if( IsDefined( ai ) )
	{
		self.lastSpawnTime = GetTime();
	}
	
	if( delete_on_count_zero && self.count <= 0 )
	{
		self Delete();
	}
	
	if ( !spawn_failed( ai ) )
	{
		return ai;
	}
}

#using_animtree( "generic_human" );

/@
"Name: spawn_drone()"
"Summary: Spawns a drone from a spawner"
"Module: Drones"
"OptionalArg: <b_make_fake_ai> : An optional parameter for having MakeFakeAI called on the drone. This will allow the drone to have a name."	
"Example: sp_drone spawn_drone();"
"SPMP: singleplayer"
@/
spawn_drone( b_make_fake_ai = false, str_targetname, b_spawn_collision = false )
{
	Assert( isdefined( self.classname ), "No classname set for drone" );
	
	m_drone = Spawn( "script_model", self.origin );
	m_drone GetDroneModel( self.classname );
	m_drone.angles = self.angles;

	if ( b_make_fake_ai )
   	{
		m_drone MakeFakeAI();
		m_drone.takedamage = true;
		
		m_drone.dr_ai_classname = self.classname;
				
		if ( IsDefined( self.script_friendname ) )
		{
			m_drone.name = self.script_friendname;
		}
		else
		{
			m_drone maps\_names::get_name();
		}
		
		if ( IsDefined( m_drone.name ) )
		{
			m_drone SetLookAtText( m_drone.name, &"" );
		}
		
		level thread maps\_friendlyfire::friendly_fire_think( m_drone );
   	}
	
	if ( b_spawn_collision )
	{
		m_drone.drone_collision = spawn_model( "drone_collision", m_drone.origin );
		m_drone.drone_collision LinkTo( m_drone );
		m_drone thread _drone_death();
	}

	m_drone UseAnimTree( #animtree );
	
	if ( IsDefined( str_targetname ) )
	{
		m_drone.targetname = str_targetname;
	}
	else if ( IsDefined( self.targetname ) )
	{
		m_drone.targetname = self.targetname + "_drone";
	}
	
	return m_drone;
}

private _drone_death()
{
	self waittill( "death" );
	self.drone_collision Delete();
}

/@
"Name: kill_spawnernum( <num> )"
"Summary: Kill spawners with script_killspawner value of <num>."
"Module: Utility"
"MandatoryArg: <num> : The killspawner number"
"Example: kill_spawnernum(4);"
"SPMP: singleplayer"
@/
kill_spawnernum( number )
{
	spawners = GetSpawnerArray();
	for( i = 0; i < spawners.size; i++ )
	{
		if( !IsDefined( spawners[i].script_killspawner ) )
		{
			continue;
		}

		if( number != spawners[i].script_killspawner )
		{
			continue;
		}

		spawners[i] Delete();
	}
}

/@
"Name: function_stack( <function>, <param1>, <param2>, <param3>, <param4> )"
"Summary: function stack is used to thread off multiple functions one after another an insure that they get called in the order you sent them in (like a FIFO queue or stack). function_stack will wait for the function to finish before continuing the next line of code, but since it internally threads the function off, the function will not end if the parent function which called function_stack() ends.  function_stack is also local to the entity that called it, if you call it on nothing it will use level and all functions sent to the stack will wait on the previous one sent to level.  The same works for entities.  This way you can have 2 AI's that thread off multiple functions but those functions are in individual stacks for each ai"
"Module: Utility"
"CallOn: level or an entity."
"MandatoryArg: <function> : the function to send to the stack"
"OptionalArg: <param1> : An optional parameter for <function>."
"OptionalArg: <param2> : An optional parameter for <function>."
"OptionalArg: <param3> : An optional parameter for <function>."
"OptionalArg: <param4> : An optional parameter for <function>."
"Example: level thread function_stack(::radio_dialogue, "scoutsniper_mcm_okgo" );"
"SPMP: singleplayer"
@/
function_stack( func, param1, param2, param3, param4 )
{
	self endon( "death" );
	localentity = spawnstruct();
	localentity thread function_stack_proc( self, func, param1, param2, param3, param4 );
	localentity waittill_either( "function_done", "death" );
}

/@
"Name: set_goal_node( <node> )"
"Summary: calls script command setgoalnode( <node> ), but also sets self.last_set_goalnode to <node>"
"Module: AI"
"CallOn: AI"
"MandatoryArg: <node> : node to send the ai to"
"Example: guy set_goal_node( node );"
"SPMP: singleplayer"
@/
set_goal_node( node )
{
	self.last_set_goalnode 	= node;
	self.last_set_goalpos 	= undefined;
	self.last_set_goalent 	= undefined;

	self SetGoalNode( node );
}

/@
"Name: set_goal_pos( <origin> )"
"Summary: calls script command setgoalpos( <origin> ), but also sets self.last_set_goalpos to <origin>"
"Module: AI"
"CallOn: AI"
"MandatoryArg: <origin> : origin to send the ai to"
"Example: guy set_goal_pos( vector );"
"SPMP: singleplayer"
@/
set_goal_pos( origin )
{
	self.last_set_goalnode 	= undefined;
	self.last_set_goalpos 	= origin;
	self.last_set_goalent 	= undefined;

	self SetGoalPos( origin );
}

/@
"Name: set_goal_ent( <entity> )"
"Summary: calls script command setgoalpos( <entity>.origin ), but also sets self.last_set_goalent to <origin>"
"Module: AI"
"CallOn: AI"
"MandatoryArg: <entity> : entity with .origin variable to send the ai to"
"Example: guy set_goal_ent( script_origin );"
"SPMP: singleplayer"
@/
set_goal_ent( target )
{
	set_goal_pos( target.origin );
	self.last_set_goalnode 	= undefined;
	self.last_set_goalpos 	= undefined;
	self.last_set_goalent 	= target;
}

/@
"Name: set_maxvisibledist( dist )"
"Summary: sets the AI's maxvisibledist to <dist>"
"Module: AI"
"CallOn: AI"
"MandatoryArg: <dist> : distance this AI will be visible from by others"
"Example: guy set_maxvisibledist( dist );"
"SPMP: singleplayer"
@/
set_maxvisibledist( dist )
{
	self.maxvisibledist = dist;
}

/*
=============
"Name: objective_complete( <obj> )"
"Summary: Sets an objective to DONE"
"Module: Utility"
"MandatoryArg: <obj>: The objective index"
"Example: objective_complete( 3 );"
"SPMP: singleplayer"
=============
*/

// SCRIPTER_MOD: dguzzo: 3-19-09 : pretty sure this is deprecated
//objective_complete( obj )
//{
//	objective_state( obj, "done" );
//	level notify( "objective_complete" + obj );
//}


/@
"Name: run_thread_on_targetname( <msg> , <func> , <param1> , <param2> , <param3> )"
"Summary: Runs the specified thread on any entity with that targetname"
"Module: Utility"
"MandatoryArg: <msg>: The targetname"
"MandatoryArg: <func>: The function"
"OptionalArg: <param1>: Optional argument"
"OptionalArg: <param2>: Optional argument"
"OptionalArg: <param3>: Optional argument"
"Example: run_thread_on_targetname( "chopper_guys", ::add_spawn_function, ::chopper_guys_land );"
"SPMP: singleplayer"
@/

run_thread_on_targetname( msg, func, param1, param2, param3 )
{
	array = getentarray( msg, "targetname" );
	array_thread( array, func, param1, param2, param3 );
}


/@
"Name: run_thread_on_noteworthy( <msg> , <func> , <param1> , <param2> , <param3> )"
"Summary: Runs the specified thread on any entity with that noteworthy"
"Module: Utility"
"MandatoryArg: <msg>: The noteworthy"
"MandatoryArg: <func>: The function"
"OptionalArg: <param1>: Optional argument"
"OptionalArg: <param2>: Optional argument"
"OptionalArg: <param3>: Optional argument"
"Example: run_thread_on_noteworthy( "chopper_guys", ::add_spawn_function, ::chopper_guys_land );"
"SPMP: singleplayer"
@/


run_thread_on_noteworthy( msg, func, param1, param2, param3 )
{
	array = getentarray( msg, "script_noteworthy" );

	array_thread( array, func, param1, param2, param3 );
}



/@
"Name: handsignal( <action> , <ender> , <waiter> )"
"Summary: Makes an AI do a handsignal."
"Module: Utility"
"CallOn: An ai"
"MandatoryArg: <action>: The string name of the animation. See below for list."
"OptionalArg: <end_on>: An optional ender "
"OptionalArg: <wait_till>: An optional string to wait for level notify on "
"Example: level.price handsignal( "go" );"
"SPMP: singleplayer"
@/
handsignal( action, end_on, wait_till )
{
	if ( IsDefined( end_on ) )
	{
		level endon( end_on );
	}
		
	if ( IsDefined( wait_till ) )
	{
		level waittill( wait_till );
	}
	
	switch ( action )
	{
		case "go":
			self maps\_anim::anim_generic(self, "signal_go");
			break;
		case "onme":
			self maps\_anim::anim_generic(self, "signal_onme");
			break;
		case "stop":
			self maps\_anim::anim_generic(self, "signal_stop");
			break;
		case "moveup":
			self maps\_anim::anim_generic(self, "signal_moveup");
			break;
		case "moveout":
			self maps\_anim::anim_generic(self, "signal_moveout");
			break;
	}
}

set_grenadeammo( count )
{
	self.grenadeammo = count;
}

// self = player
get_player_feet_from_view()
{
	tagorigin = self.origin;
	upvec = anglestoup( self getplayerangles() );
	height = self GetPlayerViewHeight();

	player_eye = tagorigin + (0,0,height);
	player_eye_fake = tagorigin + VectorScale( upvec, height );

	diff_vec = player_eye - player_eye_fake;

	fake_origin = tagorigin + diff_vec;
	return fake_origin;
}

set_console_status()
{
	if ( !IsDefined( level.Console ) )
	{
		level.Console = GetDvar( "consoleGame" ) == "true";
	}
	else
	{
		assert( level.Console == ( GetDvar( "consoleGame" ) == "true" ), "Level.console got set incorrectly." );
	}

	if ( !IsDefined( level.Consolexenon ) )
	{
		level.xenon = GetDvar( "xenonGame" ) == "true";
	}
	else
	{
		assert( level.xenon == ( GetDvar( "xenonGame" ) == "true" ), "Level.xenon got set incorrectly." );
	}
}

autosave_now( optional_useless_string, suppress_print )
{
	return maps\_autosave::autosave_game_now( suppress_print );
}

set_deathanim( deathanim )
{
	self.deathanim = getanim( deathanim );
}

clear_deathanim()
{
	self.deathanim = undefined;
}

/@
"Name: lerp_fov_overtime( <time> , <destfov> )"
"Summary: lerps from the current cg_fov value to the destfov value linearly over time"
"Module: Player"
"CallOn: a player"
"MandatoryArg: <time>: time to lerp"
"OptionalArg: <destfov>: field of view to go to"
"Example: players[0] thread lerp_fov_overtime(2.0, 45);"
"SPMP: singleplayer"
@/

lerp_fov_overtime( time, destfov, use_camera_tween )
{
	level notify( "lerp_fov_overtime" );
	level endon( "lerp_fov_overtime" );
	
	basefov = GetDvarfloat( "cg_fov" );
	destfov = Float( destfov );
	
	if ( basefov == destfov )
	{
		return;
	}
	
	/# iPrintLn( "lerp fov: " + destfov + ", " + time ); #/

	if( !IsDefined( use_camera_tween ) )
	{
		incs = int( time/.05 );
		incfov = (  destfov  -  basefov  ) / incs ;
		currentfov = basefov;
		
		// AE 9-17-09: if incfov is 0 we should move on without looping
		if(incfov == 0)
		{
			return;
		}
	
		for ( i = 0; i < incs; i++ )
		{
			currentfov += incfov;
			self SetClientDvar( "cg_fov", currentfov );
			wait .05;
		}
		//fix up the little bit of rounding error. not that it matters much .002, heh
		self SetClientDvar( "cg_fov", destfov );
	}
	else
	{
		self StartCameraTween( time );
		self SetClientDvar( "cg_fov", destfov );
	}
}



/@
"Name: anim_stopanimscripted()"
"Summary: Completely stops an animation started with _anim functions."
"Module: Utility"
"CallOn: An animating entity"
"Example: level.zakhaev anim_stopanimscripted();"
"SPMP: singleplayer"
@/
anim_stopanimscripted( n_blend_time )
{
	anim_ent = get_anim_ent();
	anim_ent StopAnimScripted( n_blend_time );
					
	anim_ent notify( "single anim", "end" );
	anim_ent notify( "looping anim", "end" );

	anim_ent maps\_anim::_stop_anim_threads();

	anim_ent notify( "_anim_stopped" );
}

/@
"Name: anim_stopscene()"
"Summary: Completely stops a scene started with the _scene.gsc system."
"Module: Utility"
"CallOn: An animating entity"
"Example: level.zakhaev anim_stopscene();"
"SPMP: singleplayer"
@/
anim_stopscene( n_blend_time )
{
	anim_ent = get_anim_ent();
	anim_ent StopAnimScripted( n_blend_time );
					
	anim_ent notify( "single anim", "end" );
	anim_ent notify( "looping anim", "end" );

	anim_ent maps\_anim::_stop_anim_threads();

	anim_ent notify( "_scene_stopped" );
}


get_anim_ent()
{
	if (IsDefined(self.anim_link))
	{
		self.anim_link.animname = self.animname;
		return self.anim_link;
	}

	return self;
}

/@
"Name: enable_additive_pain()"
"Summary: Enables additive pain on this AI"
"Module: Utility"
"CallOn: An ai"
"OptionalArg: <enable_regular_pain_on_low_health>: If set to true then additive pain will stop at 30% of starting health"
"Example: level.woods enable_additive_pain();"
"SPMP: singleplayer"
@/

enable_additive_pain( enable_regular_pain_on_low_health )
{
	assert( IsAI( self ), "Enable_additive_pain should be called on AI only." );
	self thread animscripts\pain::additive_pain_think( enable_regular_pain_on_low_health );
}

/@
"Name: disable_pain()"
"Summary: Disables pain on the AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev disable_pain();"
"SPMP: singleplayer"
@/
disable_pain()
{
	assert( isalive( self ), "Tried to disable pain on a non ai" );
	self.a.disablePain = true;
	self.allowPain = false;
}

/@
"Name: enable_pain()"
"Summary: Enables pain on the AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev enable_pain();"
"SPMP: singleplayer"
@/
enable_pain()
{
	assert( isalive( self ), "Tried to enable pain on a non ai" );
	self.a.disablePain = false;
	self.allowPain = true;
}


/@
"Name: disable_react()"
"Summary: Disables reaction behavior of given AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev disable_react();"
"SPMP: singleplayer"
@/
disable_react()
{
	assert( isalive( self ), "Tried to disable react on a non ai" );
	self.a.disableReact = true;
	self.allowReact = false;
}


/@
"Name: enable_react()"
"Summary: Enables reaction behavior of given AI"
"Module: Utility"
"CallOn: An ai"
"Example: level.zakhaev enable_react();"
"SPMP: singleplayer"
@/
enable_react()
{
	assert( isalive( self ), "Tried to enable react on a non ai" );
	self.a.disableReact = false;
	self.allowReact = true;
}

/@
"Name: enable_rambo()"
"Summary: Enables rambo behavior"
"Module: Utility"
"CallOn: level"
"Example: level enable_rambo();"
"SPMP: singleplayer"
@/
enable_rambo()
{
	if( IsDefined( level.norambo ) )
	{
		level.norambo = undefined;
	}
}

/@
"Name: disable_rambo()"
"Summary: disables rambo behavior"
"Module: Utility"
"CallOn: level"
"Example: level disable_rambo();"
"SPMP: singleplayer"
@/
disable_rambo()
{
	level.norambo = 1;
}

/@
"Name: die()"
"Summary: The entity does damage to itself of > health value"
"Module: Utility"
"CallOn: An entity"
"Example: enemy die();"
"SPMP: singleplayer"
@/
die()
{
	self dodamage( self.health + 150, (0,0,0) );
}

/@
"Name: is_ads()"
"Summary: Returns true if the player is more than 50% ads"
"Module: Utility"
"Example: player_is_ads = level.player is_ads();"
"SPMP: singleplayer"
@/
is_ads()
{
	return ( self playerADS() > 0.5 );
}

/@
"Name: enable_auto_adjust_threatbias()"
"Summary: Allows auto adjust to change the player threatbias. Defaults to on"
"Module: Utility"
"Example: enable_auto_adjust_threatbias();"
"SPMP: singleplayer"
@/
// TFLAME - 2/18/11 - REWRITE - Rewriting this function to phase out get_blended_difficulty
/*
enable_auto_adjust_threatbias(player)
{
	level.auto_adjust_threatbias = true;

	if ( level.gameskill >= 2 )
	{
		// hard and vet use locked values
		player.threatbias = int( maps\_gameskill::get_locked_difficulty_val( "threatbias", 1 ) );
		return;
	}

	
	// TFLAME - 2/18/11 - Removed support for this dvar in _gameskill, level.auto_adjust_difficulty_frac should be defined
	//level.auto_adjust_difficulty_frac = GetDvarint( "autodifficulty_frac" );
	
	// set the threatbias based on the current difficulty frac
	current_frac = level.auto_adjust_difficulty_frac * 0.01;

	// get the scalar value for threat bias
	players = get_players();
	level.coop_player_threatbias_scalar = maps\_gameskill::getCoopValue( "coopFriendlyThreatBiasScalar", players.size  );

	if (!IsDefined(level.coop_player_threatbias_scalar))
	{
		level.coop_player_threatbias_scalar = 1;
	}

	player.threatbias = int( maps\_gameskill::get_blended_difficulty( "threatbias", current_frac ) * level.coop_player_threatbias_scalar);
}
*/
enable_auto_adjust_threatbias(player)
{
	level.auto_adjust_threatbias = true;
	
	// get the scalar value for threat bias
	players = get_players();
	level.coop_player_threatbias_scalar = maps\_gameskill::getCoopValue( "coopFriendlyThreatBiasScalar", players.size  );

	if (!IsDefined(level.coop_player_threatbias_scalar))
	{
		level.coop_player_threatbias_scalar = 1;
	}

	player.threatbias = int( maps\_gameskill::get_locked_difficulty_val( "threatbias", 1 ) * level.coop_player_threatbias_scalar);
}

/@
"Name: disable_auto_adjust_threatbias()"
"Summary: Disallows auto adjust to change the player threatbias. Defaults to on"
"Module: Utility"
"Example: disable_auto_adjust_threatbias();"
"SPMP: singleplayer"
@/

disable_auto_adjust_threatbias()
{
	level.auto_adjust_threatbias = false;
}


/@
"Name: waittill_player_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Returns when the player can dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're waitting for player to look at"
"OptionalArg: <arc_angle_degrees> Optional arc in degrees from the leftmost limit to the rightmost limit. e.g. 90 is a quarter circle. Default is 90."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"Example: if ( get_players()[0] waittill_player_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
waittill_player_looking_at( origin, arc_angle_degrees = 90, do_trace )
{
	arc_angle_degrees = AbsAngleClamp360( arc_angle_degrees );
	dot = cos( arc_angle_degrees * 0.5 );
	
	while ( !is_player_looking_at( origin, dot, do_trace ) )
	{
		wait .05;
	}
}

/@
"Name: waittill_player_not_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Returns when the player cannot dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're waitting for player to look at"
"OptionalArg: <dot> Optional override dot (between 0 and 1) the higher the number, the more the player has to be looking right at the spot."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"Example: if ( get_players()[0] waittill_player_not_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
waittill_player_not_looking_at( origin, dot, do_trace )
{
	while ( is_player_looking_at( origin, dot, do_trace ) )
	{
		wait .05;
	}
}

/@
"Name: is_player_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Checks to see if the player can dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're checking if the player is looking at"
"OptionalArg: <dot> Optional override dot (between 0 and 1) the higher the number, the more the player has to be looking right at the spot."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"OptionalArg: <ignore_ent> Ignore ent passed to trace check"
"Example: if ( get_players()[0] is_player_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	assert(IsPlayer(self), "player_looking_at must be called on a player.");

	if (!IsDefined(dot))
	{
		dot = .7;
	}

	if (!IsDefined(do_trace))
	{
		do_trace = true;
	}

	eye = self get_eye();

	delta_vec = AnglesToForward(VectorToAngles(origin - eye));
	view_vec = AnglesToForward(self GetPlayerAngles());
		
	new_dot = VectorDot( delta_vec, view_vec );
	if ( new_dot >= dot )
	{
		if (do_trace)
		{
			return BulletTracePassed( origin, eye, false, ignore_ent );
		}
		else
		{
			return true;
		}
	}
	
	return false;
}

/@
"Name: look_at( <origin_or_ent>, <tween>, <force>, <tag>, <offset> )"
"Summary: Sets the player's angles to look at an origin or entity."
"Module: Utility"
"MandatoryArg: <origin_or_ent> The origin or entity for the player to look at."
"OptionalArg: <tween> Optional camera tween time."
"OptionalArg: <force> Freeze controls while looking to force the player to look."
"OptionalArg: <tag> option tag on the entity to look at."
"OptionalArg: <offset> Optional offset from the origin or tag."
"Example: player look_at(something, 2);"
"SPMP: singleplayer"
@/
look_at(origin_or_ent, tween, force, tag, offset)
{
	if (is_true(force))
	{
		self FreezeControls(true);
	}

	if (IsDefined(tween))
	{
		self StartCameraTween(tween);
	}

	self notify("look_at_begin");

	origin = origin_or_ent;

	if (!IsVec(origin_or_ent))
	{
		ent = origin_or_ent;

		if (IsDefined(tag))
		{
			// use tag position is tag is specified
			origin = ent GetTagOrigin( tag );
			Assert( IsDefined( origin ), "No tag '" + tag + "' to look at." );
		}
		else if (IsAI(origin_or_ent) && !IsDefined(offset))
		{
			// use eye pos by default for AI unless an offset is specified
			origin = ent get_eye();
		}
		else
		{
			// if all else fails, use the ent's origin
			origin = ent.origin;
		}
	}

	if (IsDefined(offset))
	{
		origin = origin + offset;
	}

	player_org = self get_eye();
	vec_to_pt = origin - player_org;
	self SetPlayerAngles(VectorToAngles(vec_to_pt));

	if ( IsDefined( tween ) )
	{
		wait tween;
	}

	if (is_true(force))
	{
		self FreezeControls(false);
	}

	self notify("look_at_end");
}



/@
"Name: add_wait( <func> , <parm1> , <parm2> , <parm3> )"
"Summary: Adds a function that you want to wait for completion on. Self of the function will be whatever add_wait is called on. Make sure you call add_wait before any wait, since the functions are stored globally."
"Module: Utility"
"MandatoryArg: <func>: The function."
"OptionalArg: <parm1>: Optional parameter"
"OptionalArg: <parm2>: Optional parameter"
"OptionalArg: <parm3>: Optional parameter"
"Example: add_wait( ::waittill_player_lookat );"
"SPMP: singleplayer"
@/
add_wait( func, parm1, parm2, parm3 )
{
	ent = spawnstruct();

	ent.caller = self;
	ent.func = func;
	ent.parms = [];
	if ( IsDefined( parm1 ) )
	{
		ent.parms[ ent.parms.size ] = parm1;
	}
	if ( IsDefined( parm2 ) )
	{
		ent.parms[ ent.parms.size ] = parm2;
	}
	if ( IsDefined( parm3 ) )
	{
		ent.parms[ ent.parms.size ] = parm3;
	}

	level.wait_any_func_array[ level.wait_any_func_array.size ] = ent;
}

/@
"Name: do_wait_any()"
"Summary: Waits until any of functions defined by add_wait complete. Clears the global variable where the functions were being stored."
"Module: Utility"
"Example: do_wait_any();"
"SPMP: singleplayer"
@/
do_wait_any()
{
	assert( IsDefined( level.wait_any_func_array ), "Tried to do a do_wait without addings funcs first" );
	assert( level.wait_any_func_array.size > 0, "Tried to do a do_wait without addings funcs first" );
	do_wait( level.wait_any_func_array.size - 1 );
}

/@
"Name: do_wait()"
"Summary: Waits until all of the functions defined by add_wait complete. Clears the global variable where the functions were being stored."
"Module: Utility"
"Example: do_wait();"
"SPMP: singleplayer"
@/
do_wait( count_to_reach )
{
	if ( !IsDefined( count_to_reach ) )
	{
		count_to_reach = 0;
	}


	assert( IsDefined( level.wait_any_func_array ), "Tried to do a do_wait without addings funcs first" );
	ent = spawnstruct();
	array = level.wait_any_func_array;
	endons = level.do_wait_endons_array;
	after_array = level.run_func_after_wait_array;

	level.wait_any_func_array = [];
	level.run_func_after_wait_array = [];
	level.do_wait_endons_array = [];

	ent.count = array.size;
	ent array_ent_thread( array, ::waittill_func_ends, endons );
	for ( ;; )
	{
		if ( ent.count <= count_to_reach )
		{
			break;
		}
		ent waittill( "func_ended" );
	}
	ent notify( "all_funcs_ended" );

	array_ent_thread( after_array, ::exec_func, [] );
}


/@
"Name: fail_on_friendly_fire()"
"Summary: If this is run, the player will fail the mission if he kills a friendly"
"Module: Utility"
"Example: fail_on_friendly_fire();"
"SPMP: singleplayer"
@/
fail_on_friendly_fire()
{
	if ( !IsDefined( level.friendlyfire_friendly_kill_points ) )
	{
		level.friendlyfire_friendly_kill_points = level.friendlyfire[ "friend_kill_points" ];
	}
	level.friendlyfire[ "friend_kill_points" ] 	= -60000;
}

/@
"Name: giveachievement_wrapper( <achievment>, [all_players] )"
"Summary: Gives an Achievement to the specified player"
"Module: Coop"
"MandatoryArg: <achievment>: The code string for the achievement"
"OptionalArg: [all_players]: If true, then give everyone the achievement"
"Example: player giveachievement_wrapper( "MAK_ACHIEVEMENT_RYAN" );"
"SPMP: singleplayer"
@/
giveachievement_wrapper( achievement, all_players )
{
	if ( achievement == "" )
	{
		return;
	}

	//no chieves in coopEPD(public demo)
	if ( isCoopEPD() )
	{
		return;
	}

	if( !( maps\_cheat::is_cheating() ) && ! ( flag("has_cheated") ) )
	{
		if( IsDefined( all_players ) && all_players )
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				players[i] GiveAchievement( achievement );
			}
		}
		else
		{
			if( !IsPlayer( self ) )
			{
				/#println( "^1self needs to be a player for _utility::giveachievement_wrapper()" );#/
				return;
			}

			self GiveAchievement( achievement );
		}
	}
}

slowmo_start()
{
	flag_set( "disable_slowmo_cheat" );
}

slowmo_end()
{
	maps\_cheat::slowmo_system_defaults();
	flag_clear( "disable_slowmo_cheat" );
}

slowmo_setspeed_slow( speed )
{
	if( !maps\_cheat::slowmo_check_system() )
	{
		return;
	}

	level.slowmo.speed_slow = speed;
}

slowmo_setspeed_norm( speed )
{
	if( !maps\_cheat::slowmo_check_system() )
	{
		return;
	}

	level.slowmo.speed_norm = speed;
}

slowmo_setlerptime_in( time )
{
	if( !maps\_cheat::slowmo_check_system() )
	{
		return;
	}

	level.slowmo.lerp_time_in = time;
}

slowmo_setlerptime_out( time )
{
	if( !maps\_cheat::slowmo_check_system() )
	{
		return;
	}

	level.slowmo.lerp_time_out = time;
}

slowmo_lerp_in()
{
	if( !flag( "disable_slowmo_cheat" ) )
	{
		return;
	}

	level.slowmo thread maps\_cheat::gamespeed_set( level.slowmo.speed_slow, level.slowmo.speed_current, level.slowmo.lerp_time_in );
	//level.slowmo thread maps\_cheat::gamespeed_slowmo();
}

slowmo_lerp_out()
{
	if( !flag( "disable_slowmo_cheat" ) )
	{
		return;
	}

	level.slowmo thread maps\_cheat::gamespeed_reset();
}

coopGame()
{
	return ( SessionModeIsSystemlink() || ( SessionModeIsOnlineGame() || IsSplitScreen() ) );
}

player_is_near_live_grenade()
{
	grenades = getentarray( "grenade", "classname" );
	for ( i = 0; i < grenades.size; i++ )
	{
		grenade = grenades[ i ];

		players = get_players();
		for( j = 0; j < players.size; j++ )
		{
			if( DistanceSquared( grenade.origin, players[j].origin ) < 250 * 250 )	// grenade radius is 220
			{
/#
					maps\_autosave::auto_save_print( "autosave failed: live grenade too close to player " + j );
#/

				return true;
			}
		}
	}

	return false;
}

player_died_recently()
{
	return GetDvarint( "player_died_recently" ) > 0;
}

/@
"Name: set_splitscreen_fog( [start_dist], [halfway_dist], [halfway_height], [base_height], [red], [green], [blue], [trans_time], [cull_dist] )"
"Summary: Sets the splitscreen fog for the level"
"Module: Splitscreen"
"OptionalArg: [start_dist]: the distance the fog starts at from the player's camera"
"OptionalArg: [halfway_dist]: the half-way mark for where the fog is 50% opaque"
"OptionalArg: [halfway_height]: the half-way height mark for where the fog starts to fade out"
"OptionalArg: [base_height]: the base height"
"OptionalArg: [red]: how much red to apply, 0 - 1"
"OptionalArg: [green]: how much green to apply, 0 - 1"
"OptionalArg: [blue]: how much blue to apply, 0 - 1 "
"OptionalArg: [trans_time]: the time it takes to go from it's current fog setting to the new fog setting"
"OptionalArg: [cull_dist]: the distance at which the game stop rendering objects"
"Example: set_splitscreen_fog( 500, 2000, 100000, 0, 0.5, 0.5, 0.5, 1, 4000 );"
"SPMP: singleplayer"
@/
set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist )
{
	if( !IsSplitScreen() )
	{
		return;
	}

	/#
		if( !IsDefined( start_dist ) && !IsDefined( halfway_dist ) && !IsDefined( halfway_height ) && !IsDefined( base_height ) && !IsDefined( red ) && !IsDefined( green ) && !IsDefined( blue ) )
		{
			level thread default_fog_print();
		}
	#/

		if( !IsDefined( start_dist ) )
		{
			start_dist = 0;
		}

		if( !IsDefined( halfway_dist ) )
		{
			halfway_dist = 200;
		}

		if( !IsDefined( base_height ) )
		{
			base_height = -2000;
		}

		if( !IsDefined( red ) )
		{
			red = 1;
		}

		if( !IsDefined( green ) )
		{
			green = 1;
		}

		if( !IsDefined( blue ) )
		{
			blue = 0;
		}

		if( !IsDefined( trans_time ) )
		{
			trans_time = 0;
		}

		if( !IsDefined( cull_dist ) )
		{
			cull_dist = 2000;
		}

		halfway_height = base_height + 2000;

		// This is used to make sure we set it up properly, if not _load should check this var and set the fog again.
		level.splitscreen_fog = true;

		SetVolFog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, 0 );
		//this not working
		//setVolFog( 0, 11.5, 46, 0, .62, .68, .57, 0);
		SetCullDist( cull_dist );
}

default_fog_print()
{
	wait_for_first_player();

	/#
	iprintlnbold( "^3USING DEFAULT FOG SETTINGS FOR SPLITSCREEN" );
	wait( 8 );
	iprintlnbold( "^3USING DEFAULT FOG SETTINGS FOR SPLITSCREEN" );
	wait( 8 );
	iprintlnbold( "^3USING DEFAULT FOG SETTINGS FOR SPLITSCREEN" );
	#/
}

// SCRIPTER_MOD
// MikeD( 03/07/07 ): Coop Section...

//--------------//
// Coop Section //
//--------------//

/@
"Name: get_host()"
"Summary: Returns the host of the game"
"Module: Coop"
"Example: host = get_host();"
"SPMP: singleplayer"
@/
get_host()
{
	players = get_players("all");

	for( i = 0; i < players.size; i++ )
	{
		if( players[i] GetEntityNumber() == 0 )
		{
			return players[i];
		}
	}
}



/@
"Name: any_player_IsTouching( <ent> )"
"Summary: Return true/false if any player in touching the given entity."
"Module: Coop"
"MandatoryArg: <ent>: The entity to check against if a player is touching"
"Example: if( any_player_IsTouching( trigger ) )"
"SPMP: singleplayer"
@/
any_player_IsTouching( ent, t )
{
	players = [];

	if(IsDefined(t))
	{
		players = get_players(t);
	}
	else
	{
		players = get_players();
	}

	for( i = 0; i < players.size; i++ )
	{
		if( IsAlive( players[i] ) && players[i] IsTouching( ent ) )
		{
			return true;
		}
	}

	return false;
}

/@
Name: waittill_player_touches( <ent> )
Summary: Waits until a player touching given entity
Module: Utility
MandatoryArg: <ent>: The entity to check against if a player is touching
Example: level.player waittill_player_touches( e_some_ent )
SPMP: singleplayer
@/
waittill_player_touches( ent )
{
	self endon( "death" );
	
	while ( !self IsTouching( ent ) )
	{
		WAIT_FRAME;
	}
}



/@
"Name: get_closest_player( <org> )"
"Summary: Returns the closest player to the given origin."
"Module: Coop"
"MandatoryArg: <origin>: The vector to use to compare the distances to"
"Example: closest_player = get_closest_player( objective.origin );"
"SPMP: singleplayer"
@/
get_closest_player( org, t )
{
	players = [];

	if(IsDefined(t))
	{
		players = get_players(t);
	}
	else
	{
		players = get_players();
	}

	return GetClosest( org, players );
}



freezecontrols_all( toggle, delay )
{
	if( IsDefined( delay ) )
	{
		wait( delay );
	}

	players = get_players("all");

	for( i = 0; i < players.size; i++ )
	{
		players[i] FreezeControls( toggle );
	}
}

// SCRIPTER_MOD
// JesseS( 3/15/2007 ): Added co-op flags sections, didn't convert trigger flags for now.
// TODO: Covert trigger based flag setting
player_flag_wait( msg )
{
	while( !self.flag[msg] )
	{
		self waittill( msg );
	}
}

player_flag_wait_either( flag1, flag2 )
{
	for( ;; )
	{
		if( flag( flag1 ) )
		{
			return;
		}

		if( flag( flag2 ) )
		{
			return;
		}

		self waittill_either( flag1, flag2 );
	}
}

player_flag_waitopen( msg )
{
	while( self.flag[msg] )
	{
		self waittill( msg );
	}
}

player_flag_init( message, trigger )
{
	if( !IsDefined( self.flag ) )
	{
		self.flag = [];
		self.flags_lock = [];
	}

	assert( !IsDefined( self.flag[message] ), "Attempt to reinitialize existing message: " + message );
	self.flag[message] = false;
	/#
		self.flags_lock[message] = false;
#/
}

player_flag_set( message )
{
	/#
		assert( IsDefined( self.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( self.flag[message] == self.flags_lock[message] );
	self.flags_lock[message] = true;
#/
	self.flag[message] = true;
	self notify( message );
}

player_flag_clear( message )
{
	/#
		assert( IsDefined( self.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( self.flag[message] == self.flags_lock[message] );
	self.flags_lock[message] = false;
#/
	self.flag[message] = false;
	self notify( message );
}

player_flag( message )
{
	assert( IsDefined( message ), "Tried to check flag but the flag was not defined." );
	if( !self.flag[message] )
	{
		return false;
	}

	return true;
}

/@
"Name: wait_for_first_player()"
"Summary: Waits for the first player to connect before returning"
"Module: Coop"
"Example: wait_for_first_player();"
"SPMP: singleplayer"
@/
wait_for_first_player()
{
	players = get_players("all");
	if( !IsDefined( players ) || players.size == 0 )
	{
		level waittill( "first_player_ready" );
	}
}

/@
"Name: wait_for_all_players()"
"Summary: Waits for all of the players to connect before returning"
"Module: Coop"
"Example: wait_for_all_players();"
"SPMP: singleplayer"
@/
wait_for_all_players()
{
	flag_wait( "all_players_connected" );
}

findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}

expandMins( mins, point )
{
	if ( mins[0] > point[0] )
	{
		mins = ( point[0], mins[1], mins[2] );
	}
	if ( mins[1] > point[1] )
	{
		mins = ( mins[0], point[1], mins[2] );
	}
	if ( mins[2] > point[2] )
	{
		mins = ( mins[0], mins[1], point[2] );
	}
	return mins;
}

expandMaxs( maxs, point )
{
	if ( maxs[0] < point[0] )
	{
		maxs = ( point[0], maxs[1], maxs[2] );
	}
	if ( maxs[1] < point[1] )
	{
		maxs = ( maxs[0], point[1], maxs[2] );
	}
	if ( maxs[2] < point[2] )
	{
		maxs = ( maxs[0], maxs[1], point[2] );
	}
	return maxs;
}

/@
"Name: get_ai_touching_volume( <team>, <volume_name>, [volume] )"
"Summary: Returns ai that are touching the specified volume"
"Module: AI"
"MandatoryArg: <team> : Check entities on this team only"
"MandatoryArg: <volume_name> : The targetname of a volume to check"
"OptionalArg: <volume> : An actual volume to check"
"Example: enemies_in_house = get_ai_touching_volume( "axis", "house_volume" );"
"Example: enemies_in_warehouse = get_ai_touching_volume( "axis", undefined, warehouse_volume );"
"SPMP: singleplayer"
@/
get_ai_touching_volume( team, volume_name, volume )
{
	if ( !IsDefined( volume ) )
	{
		volume = getent( volume_name, "targetname" );
		assert( IsDefined( volume ), volume_name + " does not exist" );
	}

	guys = getaiarray( team );
	guys_touching_volume = [];

	for( i=0; i < guys.size; i++ )
	{
		if ( guys[i] isTouching( volume ) )
		{
			guys_touching_volume[guys_touching_volume.size] = guys[i];
		}
	}

	return guys_touching_volume;
}

/@
"Name: get_ai_touching( [str_team], [str_species] )"
"Summary: Returns ai that are touching the specified entity"
"Module: AI"
"OptionalArg: <team> : Return entities on this team only"
"OptionalArg: <species> : Return entities of this species only"
"Example: a_enemies_in_house = trig_inside get_ai_touching( "axis", "human" );"
"SPMP: singleplayer"
@/
get_ai_touching( str_team, str_species )
{
	if ( !IsDefined( str_team ) )
	{
		str_team = "all";
	}
	
	if ( !IsDefined( str_species ) )
	{
		str_species = "all";
	}
	
	ai_potential = GetAISpeciesArray( str_team, str_species );
	a_ai_touching = [];
	
	foreach ( ai in ai_potential )
	{
		if ( ai IsTouching( self ) )
		{
			a_ai_touching[a_ai_touching.size] = ai;
		}
	}

	return a_ai_touching;
}

// CODER_MOD
// DSL 01/15/08 - Functions for dealing with client side script systems.

registerClientSys(sSysName)
{
	if(!IsDefined(level._clientSys))
	{
		level._clientSys = [];
	}

	if(level._clientSys.size >= 32)
	{
		/#error("Max num client systems exceeded.");#/
		return;
	}

	if(IsDefined(level._clientSys[sSysName]))
	{
		/#error("Attempt to re-register client system : " + sSysName);#/
		return;
	}
	else
	{
		level._clientSys[sSysName] = spawnstruct();
		level._clientSys[sSysName].sysID = ClientSysRegister(sSysName);
		/#
			println("registered client system "+sSysName+" to id "+level._clientSys[sSysName].sysID );
#/

	}
}

setClientSysState(sSysName, sSysState, player)
{
	if(!IsDefined(level._clientSys))
	{
		/#error("setClientSysState called before registration of any systems.");#/
		return;
	}

	if(!IsDefined(level._clientSys[sSysName]))
	{
		/#error("setClientSysState called on unregistered system " + sSysName);#/
		return;
	}

	if(IsDefined(player))
	{
		player ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
	}
	else
	{
		ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
		level._clientSys[sSysName].sysState = sSysState;
		/#
			println("set client system "+sSysName+"("+level._clientSys[sSysName].sysID+")"+" to "+sSysState);
#/

	}
}

// CODER_MOD GMJ 05/19/08 - Wait until a snapshot is acknowledged.
//                          Can help control having too many spawns in one frame.

/@
"Name: wait_network_frame()"
"Summary: Wait until a snapshot is acknowledged.  Can help control having too many spawns in one frame."
"Module: Utility"
"Example: wait_network_frame();"
"SPMP: singleplayer"
@/
wait_network_frame()
{
	//    snapshot_ids = getsnapshotindexarray();
	if(NumRemoteClients())
	{
    snapshot_ids = getsnapshotindexarray();

    acked = undefined;
    while (!IsDefined(acked))
    {
        level waittill("snapacknowledged");
        acked = snapshotacknowledged(snapshot_ids);
    }
	}
	else
	{
		wait(0.1);
	}
}

// SCRIPTER_MOD: JesseS (5/15/200): For sending notifies to the client.
clientNotify(event)
{
	if(level.clientscripts)
	{
		if(IsPlayer(self))
		{
			maps\_utility::setClientSysState("levelNotify", event, self);
		}
		else
		{
			maps\_utility::setClientSysState("levelNotify", event);
		}
	}
}

// CODER_MOD GMJ 06/05/08
// Wait until either:
// 1) it is ok to spawn according to the network (best-guess).
// 2) max_wait_seconds elapse.

/@
"Name: ok_to_spawn( <max_wait_seconds> )"
"Summary: wait until 1)it is ok to spawn according to the network (best-guess). 2) max_wait_seconds elapse."
"Module: Utility"
"OptionalArg: <max_wait_seconds> : Max amount of time to wait before checking network again"
"Example: ok_to_spawn( 5 );"
"SPMP: singleplayer"
@/

ok_to_spawn( max_wait_seconds )
{
	if( IsDefined( max_wait_seconds ) )
	{
		timer = GetTime() + max_wait_seconds * 1000;

		while( GetTime() < timer && !OkToSpawn() )
		{
			wait( 0.05 );
		}
	}
	else
	{
		while( !OkToSpawn() )
		{
			wait( 0.05 );
		}
	}
}

set_breadcrumbs(starts)
{
	if(!IsDefined(level._player_breadcrumbs))
	{
		maps\_callbackglobal::Player_BreadCrumb_Reset((0,0,0));
	}

	for(i = 0; i < starts.size; i++)
	{
		for(j = 0; j < starts.size; j++)
		{
			level._player_breadcrumbs[i][j].pos = starts[j].origin;
			if(IsDefined(starts[j].angles))
			{
				level._player_breadcrumbs[i][j].ang = starts[j].angles;
			}
			else
			{
				level._player_breadcrumbs[i][j].ang = (0,0,0);
			}
		}
	}
}

set_breadcrumbs_player_positions()
{
	if(!IsDefined(level._player_breadcrumbs))
	{
		maps\_callbackglobal::Player_BreadCrumb_Reset((0,0,0));
	}

	players = get_players();

	for(i = 0; i < players.size; i++)
	{
		level._player_breadcrumbs[i][0].pos = players[i].origin;
		level._player_breadcrumbs[i][0].ang = players[i].angles;
	}
}



/@
"Name: spread_array_thread( <entities> , <process> , <var1> , <var2> , <var3> )"
"Summary: Threads the < process > function on every entity in the < entities > array. The entity will become "self" in the specified function.  Each thread is started 1 network frame apart from the next."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities> : array of entities to thread the process"
"MandatoryArg: <process> : pointer to a script function"
"OptionalArg: <var1> : parameter 1 to pass to the process"
"OptionalArg: <var2> : parameter 2 to pass to the process"
"OptionalArg: <var3> : parameter 3 to pass to the process"
"Example: array_thread( getaiarray( "allies" ), ::set_ignoreme, false );"
"SPMP: SP"
@/

spread_array_thread( entities, process, var1, var2, var3 )
{
	keys = getArrayKeys( entities );

	if ( IsDefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
		{
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2, var3 );
			wait_network_frame();
		}

		return;
	}

	if ( IsDefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
		{
			entities[ keys[ i ] ] thread [[ process ]]( var1, var2 );
			wait_network_frame();
		}

		return;
	}

	if ( IsDefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
		{
			entities[ keys[ i ] ] thread [[ process ]]( var1 );
			wait_network_frame();
		}

		return;
	}

	for( i = 0 ; i < keys.size ; i++ )
	{
		entities[ keys[ i ] ] thread [[ process ]]();
		wait_network_frame();
	}
}

/@
"Name: simple_floodspawn( <name>, <spawn_func>, <spawn_func_2>)"
"Module: Utility"
"Summary: Simple way to floodspawn guys, with targetname 'name'"
"MandatoryArg: <name> : targetname of spawners to spawn"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <spawn_func_2> : function pointer to an additional spawn function"
"Example: simple_floodspawn( "defend_guys", ::defend_guys_strategy, ::defend_guys_retreat_strategy );"
"SPMP: singleplayer"
@/
simple_floodspawn( name, spawn_func, spawn_func_2 )
{
	spawners = getEntArray( name, "targetname" );
	assert( spawners.size, "no spawners with targetname " + name + " found!" );

	// add spawn function to each spawner if specified
	if( IsDefined( spawn_func ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func );
		}
	}

	if( IsDefined( spawn_func_2 ) )
	{
		for( i  = 0; i < spawners.size; i++ )
		{
			spawners[i] add_spawn_function( spawn_func_2 );
		}
	}

	for( i = 0; i < spawners.size; i++ )
	{
		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			wait_network_frame();
		}

		// same behavior in _spawner's flood_spawner_scripted() function
		spawners[i] thread maps\_spawner::flood_spawner_init();
		spawners[i] thread maps\_spawner::flood_spawner_think();
	}
}

/@
"Name: simple_spawn( <name_or_spawners>, <spawn_func>, <param1>, <param2>, <param3>, <param4>, <param5>, <bforce>)"
"Module: Utility"
"Summary: Simple way to spawn guys, with targetname or by passing in the spawners, just once (no floodspawning). Returns an array of the spawned ai."
"MandatoryArg: <name_or_spawners> : targetname of spawners or the spawners themselves"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <param1> : argument to pass to the spawn function"
"OptionalArg: <param2> : argument to pass to the spawn function"
"OptionalArg: <param3> : argument to pass to the spawn function"
"OptionalArg: <param4> : argument to pass to the spawn function"
"OptionalArg: <param5> : argument to pass to the spawn function"
"OptionalArg: <bForce> : true/false if you want to force the spawn"
"Example: simple_spawn( "bunker_guys", ::bunker_guys_strategy );"
"SPMP: singleplayer"
@/
simple_spawn( name_or_spawners, spawn_func, param1, param2, param3, param4, param5, bForce)
{
	spawners = [];
	if (IsString(name_or_spawners))
	{
		spawners = GetEntArray( name_or_spawners, "targetname" );
		assert( spawners.size, "no spawners with targetname " + name_or_spawners + " found!" );
	}
	else
	{
		if (IsArray(name_or_spawners))
		{
			spawners = name_or_spawners;
		}
		else
		{
			spawners[0] = name_or_spawners;
		}
	}

	ai_array = [];

	for ( i = 0; i < spawners.size; i++ )
	{
		while( IS_TRUE(spawners[i].spawning) )
		{
			wait_network_frame();
		}
		
		spawners[i].spawning = true;

		if( i % 2 )
		{
			//wait for a new network frame to be sent out before spawning in another guy
			wait_network_frame();
		}

		if ( IS_TRUE( spawners[i].script_drone ) )
		{
			ai = spawners[i] spawn_drone();
		}
		else
		{
			ai = spawners[i] spawn_ai( bForce );
		}
		
		spawners[i].spawning = undefined;
		
		if ( !IsDefined( ai ) || !IsAlive( ai ) )
		{
			continue;
		}

		if ( IsDefined( spawn_func ) )
		{
			single_thread( ai, spawn_func, param1, param2, param3, param4, param5 );
		}
		
		ARRAY_ADD( ai_array, ai );
	}

	return ai_array;
}

/@
"Name: simple_spawn_single( <name_or_spawner>, <spawn_func>, <param1>, <param2>, <param3>, <param4>, <param5>, <bforce>)"
"Module: Utility"
"Summary: Simple way to spawn just one guy, with targetname or by passing in the spawner, just once. Returns the spawned ai entity."
"MandatoryArg: <name_or_spawner> : targetname of spawner or the spawner"
"OptionalArg: <spawn_func> : function pointer to a spawn function"
"OptionalArg: <param1> : argument to pass to the spawn function"
"OptionalArg: <param2> : argument to pass to the spawn function"
"OptionalArg: <param3> : argument to pass to the spawn function"
"OptionalArg: <param4> : argument to pass to the spawn function"
"OptionalArg: <param5> : argument to pass to the spawn function"
"OptionalArg: <bforce> : true/false to force spawn"
"Example: simple_spawn( "ambush_guy", ::ambush_guy_strategy );"
"SPMP: singleplayer"
@/
simple_spawn_single( name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bforce )
{
	if (IsString(name_or_spawner))
	{
		spawner = GetEnt( name_or_spawner, "targetname" );
		assert( IsDefined( spawner ), "no spawner with targetname " + name_or_spawner + " found!" );
	}
	else if (IsArray(name_or_spawner))
	{
		AssertMsg("simple_spawn_single cannot be used on an array of spawners.  use simple_spawn instead.");
	}
	
	ai = simple_spawn(name_or_spawner, spawn_func, param1, param2, param3, param4, param5, bforce);
	assert( ai.size <= 1, "simple_spawn called from simple_spawn_single somehow spawned more than one guy!" );
	
	if (ai.size)
	{
		return ai[0];
	}
}


CanSpawnThink()
{
	level.canSpawnInOneFrame = 3;
	for(;;)
	{
		level.canSpawnCount = 0;
		wait_network_frame();
	}
}


CanSpawn()
{
	if(!isdefined(level.canSpawnInOneFrame))
	{
		thread CanSpawnThink();
	}

	return true;	// TFLAME 7/22/09 - TEMP for Stephen McCaul to look at issues of Canspawn
	//return OkToSpawn() && (level.canSpawnCount < level.canSpawnInOneFrame);
}


SpawnThrottleEnableThread()
{
	level notify ("spawn_throttle_enable_thread_ender");
	level endon ("spawn_throttle_enable_thread_ender");
	if (isdefined(level.flag["all_players_connected"]))
	{
		flag_wait("all_players_connected");
		level.spawnThrottleEnable = true;
	}
}


SpawnThrottleEnable()
{
	if(!isdefined(level.spawnThrottleEnable) || (isdefined(level.spawnThrottleEnable) && level.spawnThrottleEnable == false) )
	{
		level.spawnThrottleEnable = false;
		thread SpawnThrottleEnableThread();
	}
	return level.spawnThrottleEnable;
}

/@
"Name: DoSpawn(<noEnemyInfo>, <targetname>, <noThreatUpdate>)"
"Summary: Spawns an actor from an actor spawner, if possible (the spawner won't spawn if the player is looking at the spawn point, or if spawning would cause a telefrag)"
"Module: Spawn"
"CallOn: An actor spawner"
"OptionalArg: <noEnemyInfo> do not copy information about enemies from existing teammates (false by default)"
"OptionalArg: <targetname> sets the targetname of the spawned entity"
"OptionalArg: <noThreatUpdate> skip doing the threat update on spawn so that script can set ignoreMe, ignoreAll type flags before they're used by code
"Example:  spawned = driver DoSpawn( true, "name", false );"
"SPMP: singleplayer"
@/
DoSpawn( noEnemyInfo, targetname, noThreatUpdate )
{
	if( SpawnThrottleEnable() )
	{
		while( !CanSpawn() )
		{
			wait_network_frame();
		}
	}

	if( isdefined( level.canSpawnCount ) )
	{
		level.canSpawnCount += 1;
	}
 
	if( !IsDefined( noEnemyInfo ) )
	{
		noEnemyInfo = false;
	}
	
	if( !IsDefined(noThreatUpdate) )
	{
		noThreatUpdate = false;
	}
	
	return self CodeSpawnerSpawn( noEnemyInfo, targetname, noThreatUpdate );
}

/@
"Name: StalingradSpawn(<noEnemyInfo>, <targetname>, <noThreatUpdate>)"
"Summary: Force spawns an actor from an actor spawner, regardless of whether the spawn point is in sight or if the spawn will cause a telefrag"
"Module: Spawn"
"CallOn: An actor spawner"
"OptionalArg: <noEnemyInfo> do not copy information about enemies from existing teammates (false by default)"
"OptionalArg: <targetname> sets the targetname of the spawned entity"
"OptionalArg: <noThreatUpdate> skip doing the threat update on spawn so that script can set ignoreMe, ignoreAll type flags before they're used by code
"Example:  spawned = driver StalingradSpawn( true, "name" );"
"SPMP: singleplayer"
@/
StalingradSpawn( noEnemyInfo, targetname, noThreatUpdate )
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}
	
	if( !IsDefined( noEnemyInfo ) )
	{
		noEnemyInfo = false;
	}
	
	if( !IsDefined(noThreatUpdate) )
	{
		noThreatUpdate = false;
	}
	
	return self CodeSpawnerForceSpawn( noEnemyInfo, targetname, noThreatUpdate );
}

/@
"Name: Spawn( <classname>, <origin>, <flags>, <radius>, <height>, <destructibledef> )"
"Summary: Spawns a new entity and returns a reference to the entity."
"Module: Spawn"
"MandatoryArg: <classname> The name of the class to spawn"
"MandatoryArg: <origin> The position where the entity is to be spawned (vector)"
"OptionalArg: <flags> spawn flags (integer)"
"OptionalArg: <radius> The radius (or base dimensions) if this is a trigger_radius or trigger_lookat. Otherwise this parameter is invalid."
"OptionalArg: <height> The height if this is a trigger_radius or trigger_lookat. Otherwise this parameter is invalid."
"OptionalArg: <destructibledef> Use this field to specify the destructibledef and spawn a destructible."
"Example:  org = Spawn( "script_origin", self GetOrigin() );"
"SPMP: SP"
@/
Spawn(classname, origin, flags, radius, height, destructibledef)
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}


	if(IsDefined(destructibledef))
	{
		return CodeSpawn(classname, origin, flags, radius, height, destructibledef);
	}
	else if(IsDefined(height))
	{
		return CodeSpawn(classname, origin, flags, radius, height);
	}
	else if(IsDefined(radius))
	{
		return CodeSpawn(classname, origin, flags, radius);
	}
	else if(IsDefined(flags))
	{
		return CodeSpawn(classname, origin, flags);
	}
	else
	{
		return CodeSpawn(classname, origin);
	}
}

// pass in undefined for modelname if you want the model to be the same as what's in the GDT for your vehicletype
SpawnVehicle( modelname, targetname, vehicletype, origin, angles, destructibledef )
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}


	assert(IsDefined(targetname));
	assert(IsDefined(vehicletype));
	assert(IsDefined(origin));
	assert(IsDefined(angles));

	if(IsDefined(destructibledef))
	{
		return CodeSpawnVehicle( modelname, targetname, vehicletype, origin, angles, destructibledef );
	}
	else
	{
		return CodeSpawnVehicle( modelname, targetname, vehicletype, origin, angles );
	}
}



SpawnTurret( classname, origin, weaponinfoname )
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}


	return CodeSpawnTurret(classname, origin, weaponinfoname);
}



PlayLoopedFX( effectid, repeat, position, cull, forward, up, primlightfrac, lightoriginoffs )
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}

	if(IsDefined(lightoriginoffs))
	{
		return CodePlayLoopedFX(effectid, repeat, position, cull, forward, up, primlightfrac, lightoriginoffs);
	}
	else if(IsDefined(primlightfrac))
	{
		return CodePlayLoopedFX(effectid, repeat, position, cull, forward, up, primlightfrac);
	}
	else if(IsDefined(up))
	{
		return CodePlayLoopedFX(effectid, repeat, position, cull, forward, up);
	}
	else if(IsDefined(forward))
	{
		return CodePlayLoopedFX(effectid, repeat, position, cull, forward);
	}
	else if(IsDefined(cull))
	{
		return CodePlayLoopedFX(effectid, repeat, position, cull);
	}
	else
	{
		return CodePlayLoopedFX(effectid, repeat, position);
	}
}



/@
"Name: SpawnFx( <effect id>, <position>, <forward>, <up> )"
"Summary: Create an effect entity that can be re-triggered efficiently at arbitrary intervals.  This doesn't play the effect.  Use delete to free it when done.\n"
"MandatoryArg: <effect id> The effect id returned by loadfx.\n"
"MandatoryArg: <position> The position of the effect.\n"
"OptionalArg: <forward> The forward vector for the effect\n"
"OptionalArg: <up> The up vector for the effect\n"
"Module: Effects\n"
"Example: fxObj = SpawnFx( fxId, pos, dir );"
"SPMP: SP"
@/
SpawnFx( effect, position, forward, up, primlightfrac, lightoriginoffs )
{
	if(SpawnThrottleEnable())
	{
		while(!CanSpawn())
		{
			wait_network_frame();
		}
	}

	if(isdefined(level.canSpawnCount))
	{
		level.canSpawnCount += 1;
	}


	if(IsDefined(lightoriginoffs))
	{
		return CodeSpawnFx(effect, position, forward, up, primlightfrac, lightoriginoffs);
	}
	else if(IsDefined(primlightfrac))
	{
		return CodeSpawnFx(effect, position, forward, up, primlightfrac);
	}
	else if(IsDefined(up))
	{
		return CodeSpawnFx(effect, position, forward, up);
	}
	else if(IsDefined(forward))
	{
		return CodeSpawnFx(effect, position, forward);
	}
	else
	{
		return CodeSpawnFx(effect, position);
	}
}

/@
"Name: spawn_model(<model_name>, [origin], [angles])"
"Summary: Spawns a model at an origin and angles."
"Module: Utility"
"MandatoryArg: <model_name> the model name."
"OptionalArg: [origin] the origin to spawn the model at."
"OptionalArg: [angles] the angles to spawn the model at."
"Example: fx_model = spawn_model("tag_origin", org, ang);"
"SPMP: SP"
@/
spawn_model( model_name, origin, angles, n_spawnflags = 0 )
{
	if (!IsDefined(origin))
	{
		origin = (0, 0, 0);
	}

	model = Spawn( "script_model", origin, n_spawnflags );
	model SetModel( model_name );

	if( IsDefined( angles ) )
	{
		model.angles = angles;
	}

	return model;
}

/@
"Name: go_path( <path_start> )"
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <path_start> : the node, script_origin, or struct to start from"
"Summary: Attach and start the vehicle on its path."
"Example: vehicle thread go_path(path_start)"
"SPMP: singleplayer"
@/
go_path(path_start) // self == vehicle
{
	// getonpath will attach us to the path and allow us to get script_noteworthy notifies from nodes
	self maps\_vehicle::getonpath(path_start);

	// gopath starts us on the path
	self maps\_vehicle::gopath();
}

/@
"Name: disable_driver_turret()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Disables the main turret of a vehicle.  This is the primary fire of the driver."
"Example: vehicle disable_turret()"
"SPMP: singleplayer"
@/
disable_driver_turret() // self == vehicle
{
	self notify( "stop_turret_shoot");
}

/@
"Name: enable_driver_turret()"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Enables the main turret of a vehicle.  This is the primary fire of the driver."
"Example: vehicle enable_driver_turret()"
"SPMP: singleplayer"
@/
enable_driver_turret() // self == vehicle
{
	self notify( "stop_turret_shoot");
	self thread maps\_vehicle::turret_shoot();
}

/@
"Name: set_switch_node( <source_node>, <destination_node> )"
"Module: Vehicle"
"CallOn: a vehicle"
"MandatoryArg: <source_node_name> : the name of the node the vehicle is switching from"
"MandatoryArg: <destination_node_name> : the name of the node the vehicle is switching to"
"Summary: Switches from one path to another."
"Example: vehicle thread set_switch_node(src_node_name, dst_node_name);"
"SPMP: singleplayer"
@/
set_switch_node(src_node, dst_node) // self == vehicle
{
	assert(IsDefined(src_node));
	assert(IsDefined(dst_node));

	// _vehicle::vehicle_paths will be checking for this bool and the dst_node
	self.bSwitchingNodes = true;
	self.dst_node = dst_node;
	self SetSwitchNode(src_node, dst_node);
}



/@
"Name: veh_toggle_tread_fx( <on> )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles tread fx on (1) and off (0)"
"MandatoryArg: <on> : 1 - treadfx on, 0 - treadfx off"
"Example: level.tank veh_toggle_tread_fx(1);"
"SPMP: singleplayer"
@/
veh_toggle_tread_fx( on )
{
	if(!on)
	{
		self SetClientFlag(6);
	}
	else
	{
		self ClearClientFlag(6);
	}
}

/@
"Name: veh_toggle_exhaust_fx( <on> )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles exhaust fx on (1) and off (0)"
"MandatoryArg: <on> : 1 - exhaustfx on, 0 - exhaustfx off"
"Example: level.tank veh_toggle_exhaust_fx(0);"
"SPMP: singleplayer"
@/
veh_toggle_exhaust_fx( on )
{
	if(!on)
	{
		self SetClientFlag(8);
	}
	else
	{
		self ClearClientFlag(8);
	}
}

/@
"Name: veh_toggle_lights( <on> )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles headlight and taillight fx on (1) and off (0)"
"MandatoryArg: <on> : 1 - headlights on, 0 - headlights off"
"Example: level.tank veh_toggle_lights(0);"
"SPMP: singleplayer"
@/
veh_toggle_lights( on )
{
	if(on)
	{
		self SetClientFlag(10);
	}
	else
	{
		self ClearClientFlag(10);
	}
}

/@
"Name: vehicle_toggle_sounds( <on> )"
"Module: Vehicle"
"CallOn: Vehicle"
"Summary: Will toggle the vehicle's sounds between on (1) and off (0)"
"MandatoryArg: <on> : 1 - sounds on, 0 - sounds off"
"Example: car vehicle_toggle_sounds(0);"
"SPMP: singleplayer"
@/
vehicle_toggle_sounds( on )
{
	// this flag number should *NOT* be changed. if it needs to be changed, code must be updated as well.  See EF2_DISABLE_VEHICLE_SOUNDS in bg_public.h
	if(!on)
	{
		self SetClientFlag(2);
	}
	else
	{
		self ClearClientFlag(2);
	}
}

// --------------------------------------------------------------------------------
// ---- Spawn Manager - Scripter interface ----
// --------------------------------------------------------------------------------

/@
"Name: spawn_manager_set_global_active_count( count )"
"Module: Spawn Manager"
"Summary: Max number of AI active globally from all spawn managers in the level."
"MandatoryArg: count"
"Example: spawn_manager_set_global_active_count(16);"
"SPMP: singleplayer"
@/
spawn_manager_set_global_active_count( cnt )
{
	assert( cnt <= 32, "Max number of Active AI at a given time cant be more than 32" );
	level.spawn_manager_max_ai = cnt;
}

/@
"Name: sm_use_trig_when_complete( spawn_manager_targetname, trigger value, trigger key, only_once )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager complete or killed"
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: boolean - set this to true if you only want the trigger used once if it is in the player space"
"Example: level sm_use_trig_when_complete( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/
sm_use_trig_when_complete( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	self thread sm_use_trig_when_complete_internal( spawn_manager_targetname, trig_name, trig_key, once_only );
}

sm_use_trig_when_complete_internal( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if(IsDefined(once_only) && once_only )
	{
		trigger = GetEnt(trig_name, trig_key);
		assert(IsDefined(trigger), "The trigger " + trig_key + " / " + trig_name + " does not exist.");
		trigger endon("trigger");
	}

	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_complete");
		trigger_use(trig_name, trig_key);
	}
	else
	{
		AssertMsg("sm_use_trig_when_complete: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: sm_use_trig_when_cleared( spawn_manager_targetname, trigger value, trigger key, once_only )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager is done spawning and ai cleared."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: <once_only> - set this to true if you only want the trigger used once if it is in the player space"
"Example: level sm_use_trig_when_cleared( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/
sm_use_trig_when_cleared( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	self thread sm_use_trig_when_cleared_internal( spawn_manager_targetname, trig_name, trig_key, once_only );
}

sm_use_trig_when_cleared_internal( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if(IsDefined(once_only) && once_only )
	{
		trigger = GetEnt(trig_name, trig_key);
		assert(IsDefined(trigger), "The trigger " + trig_key + " / " + trig_name + " does not exist.");
		trigger endon("trigger");
	}

	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_cleared");
		trigger_use(trig_name, trig_key);
	}
	else
	{
		AssertMsg("sm_use_trig_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: sm_use_trig_when_enabled( spawn_manager_targetname, trigger value, trigger key, once_only )"
"Module: Spawn Manager"
"Summary: Use passed in trigger when Spawn Manager enabled."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: trigger value"
"MandatoryArg: trigger key"
"OptionalArg: <once_only> - set this to true if you only want the trigger used once if it is in the player space"
"Example: level sm_use_trig_when_enabled( "my_spawn_manager_01", "next_trig", "targetname", 1);"
"SPMP: singleplayer"
@/
sm_use_trig_when_enabled( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	self thread sm_use_trig_when_enabled_internal( spawn_manager_targetname, trig_name, trig_key, once_only );
}

sm_use_trig_when_enabled_internal( spawn_manager_targetname, trig_name, trig_key, once_only )
{
	if(IsDefined(once_only) && once_only )
	{
		trigger = GetEnt(trig_name, trig_key);
		assert(IsDefined(trigger), "The trigger " + trig_key + " / " + trig_name + " does not exist.");
		trigger endon("trigger");
	}

	// Check if the spawn manager is enabled based on the flags first and then wait for it to be enabled
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_enabled");
		trigger_use(trig_name, trig_key);
	}
	else
	{
		AssertMsg("sm_use_trig_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: sm_run_func_when_complete( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager is done spawning."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: level sm_run_func_when_complete(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
sm_run_func_when_complete( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	self thread sm_run_func_when_complete_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 );
}

sm_run_func_when_complete_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert(IsDefined(process), "sm_run_func_when_complete: the function is not defined");
	assert(level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ), "sm_run_func_when_complete: Spawn manager '" + spawn_manager_targetname + "' not found.");
	waittill_spawn_manager_complete( spawn_manager_targetname );
	single_func(ent, process, var1, var2, var3, var4, var5);
}


/@
"Name: sm_run_func_when_cleared( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager done spawning and ai cleared."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: level sm_run_func_when_cleared(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
sm_run_func_when_cleared( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	self thread sm_run_func_when_cleared_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 );
}

sm_run_func_when_cleared_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert(IsDefined(process), "sm_run_func_when_cleared: the function is not defined");
	assert(level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ), "sm_run_func_when_cleared: Spawn manager '" + spawn_manager_targetname + "' not found.");
	waittill_spawn_manager_cleared(spawn_manager_targetname);
	single_func(ent, process, var1, var2, var3, var4, var5);
}
/@
"Name: sm_run_func_when_enabled( spawn_manager_targetname, process, ent, var1, var2, var3, var4 )"
"Module: Spawn Manager"
"Summary: Runs function when Spawn Manager is enabled."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <process> : function pointer"
"OptionalArg: <ent> : entity to thread function on"
"OptionalArg: <var1> : first parameter"
"OptionalArg: <var2> : second parameter"
"OptionalArg: <var3> : third parameter"
"OptionalArg: <var4> : fourth parameter"
"Example: my_spawnmanager sm_run_func_when_enabled(::my_function, bob, steve);"
"SPMP: singleplayer"
@/
sm_run_func_when_enabled( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	self thread sm_run_func_when_enabled_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 );
}

sm_run_func_when_enabled_internal( spawn_manager_targetname, process, ent, var1, var2, var3, var4, var5 )
{
	assert(IsDefined(process), "sm_run_func_when_enabled: the function is not defined");
	assert(level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ), "sm_run_func_when_enabled: Spawn manager '" + spawn_manager_targetname + "' not found.");
	waittill_spawn_manager_enabled( spawn_manager_targetname );
	single_func(ent, process, var1, var2, var3, var4, var5);
}

/@
"Name: spawn_manager_enable( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Enable/Activate spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager_enable("spawn_manager_04");"
"SPMP: singleplayer"
@/
spawn_manager_enable( spawn_manager_targetname, no_assert )
{
	// Check if the spawn manager is found based on the flags first and then try to enable it.
	// A spawn manager is disabled by default before enabled/activating it for the first time.
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		for (i = 0; i < level.spawn_managers.size; i++)
		{
			if (level.spawn_managers[i].sm_id == spawn_manager_targetname)
			{
				level.spawn_managers[i] notify("enable");
				return;
			}
		}
	}
	else if (!is_true(no_assert))
	{
		AssertMsg("spawn_manager_enable: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: spawn_manager_disable( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Disable/Deactivate spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager_disable("spawn_manager_04");"
"SPMP: singleplayer"
@/
spawn_manager_disable( spawn_manager_targetname, no_assert )
{
	// Check if the spawn manager is enabled based on the flags first and then try to disable it.
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		for( i = 0; i < level.spawn_managers.size; i++ )
		{
			if( level.spawn_managers[i].sm_id == spawn_manager_targetname )
			{
				level.spawn_managers[i] notify("disable");
				return;
			}
		}
	}
	else if (!is_true(no_assert))
	{
		AssertMsg("spawn_manager_disable: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}


/@
"Name: spawn_manager_kill( <spawn_manager_targetname>, [no_assert] )"
"Module: Spawn Manager"
"Summary: Kill spawn manager with given targetname."
"MandatoryArg: <spawn_manager_targetname>"
"OptionalArg: [no_assert] : disable assert if spawn manager doesn't exist."
"Example: spawn_manager_kill("spawn_manager_04");"
"SPMP: singleplayer"
@/
spawn_manager_kill( spawn_manager_targetname, no_assert )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		for( i = 0; i < level.spawn_managers.size; i++ )
		{
			if( level.spawn_managers[i].sm_id == spawn_manager_targetname )
			{
				level.spawn_managers[i] notify("kill");
				return;
			}
		}
	}
	else if (!is_true(no_assert))
	{
		AssertMsg("spawn_manager_kill: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: is_spawn_manager_enabled( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager is enabled/active."
"MandatoryArg: <spawn_manager_targetname>"
"Example: is_spawn_manager_enabled("spawn_manager_04");"
"SPMP: singleplayer"
@/
is_spawn_manager_enabled( spawn_manager_targetname )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if( flag( "sm_" + spawn_manager_targetname + "_enabled" ) )
		{
			return true;
		}
		
		return false;
	}
	else
	{
		AssertMsg("is_spawn_manager_enabled: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
	
}

/@
"Name: is_spawn_manager_complete( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has finished spawning all the AI."
"MandatoryArg: <spawn_manager_targetname>"
"Example: is_spawn_manager_complete("spawn_manager_04");"
"SPMP: singleplayer"
@/
is_spawn_manager_complete( spawn_manager_targetname )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if( flag( "sm_" + spawn_manager_targetname + "_complete" ) )
		{
			return true;
		}
	
		return false;
	}
	else
	{
		AssertMsg("is_spawn_manager_complete: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: is_spawn_manager_cleared( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has finished spawning all the AI and all AI from this spawn manager are dead."
"MandatoryArg: <spawn_manager_targetname>"
"Example: is_spawn_manager_cleared("spawn_manager_04");"
"SPMP: singleplayer"
@/
is_spawn_manager_cleared( spawn_manager_targetname )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if( flag( "sm_" + spawn_manager_targetname + "_cleared" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg("is_spawn_manager_cleared: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: is_spawn_manager_killed( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns true if the spawn manager has has been killed."
"MandatoryArg: <spawn_manager_targetname>"
"Example: is_spawn_manager_killed("spawn_manager_04");"
"SPMP: singleplayer"
@/
is_spawn_manager_killed( spawn_manager_targetname )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		if( flag( "sm_" + spawn_manager_targetname + "_killed" ) )
		{
			return true;
		}

		return false;
	}
	else
	{
		AssertMsg("is_spawn_manager_killed: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: waittill_spawn_manager_cleared( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI and all AI from this spawn manager are dead."
"MandatoryArg: <spawn_manager_targetname>"
"Example: waittill_spawn_manager_cleared("spawn_manager_04");"
"SPMP: singleplayer"
@/
waittill_spawn_manager_cleared(spawn_manager_targetname)
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_cleared");
	}
	else
	{
		AssertMsg("waittill_spawn_manager_cleared: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: waittill_spawn_manager_ai_remaining( spawn_manager_targetname, count )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI and the amount of remaining AI is less than the specified count."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: <count> function returns when number of remaining ai count = count"
"Example: waittill_spawn_manager_ai_remaining("spawn_manager_04", 5);"
"SPMP: singleplayer"
@/
waittill_spawn_manager_ai_remaining(spawn_manager_targetname, count_to_reach)
{
	assert( IsDefined(count_to_reach), "# of AI remaining not specified in _utility::waittill_spawn_manager_ai_remaining()");
	assert( count_to_reach, "# of AI remaining specified in _utility::waittill_spawn_manager_ai_remaining() is 0, use waittill_spawn_manager_cleared" );

	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_complete");
	}
	else
	{
		AssertMsg("waittill_spawn_manager_ai_remaining: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
	
	if( flag( "sm_" + spawn_manager_targetname + "_cleared" ) )
	{
		return;
	}
	
	spawn_manager = maps\_spawn_manager::get_spawn_manager_array( spawn_manager_targetname );
	
	assert( spawn_manager.size, "Somehow the spawn manager doesnt exist, but related flag existed before." );
	assert( ( spawn_manager.size == 1 ), "Found two spawn managers with same targetname." );

	// spawn manager might be deleted while we are waiting too
	while( ( IsDefined( spawn_manager[0] ) ) && ( spawn_manager[0].activeAI.size > count_to_reach ) )
	{
		wait(0.1);
	}
}

/@
"Name: waittill_spawn_manager_complete( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has finished spawning all the AI."
"MandatoryArg: <spawn_manager_targetname>"
"Example: waittill_spawn_manager_complete("spawn_manager_04");"
"SPMP: singleplayer"
@/
waittill_spawn_manager_complete(spawn_manager_targetname)
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_complete");
	}
	else
	{
		AssertMsg("waittill_spawn_manager_complete: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: waittill_spawn_manager_enabled( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager is enabled/active."
"MandatoryArg: <spawn_manager_targetname>"
"Example: waittill_spawn_manager_enabled("spawn_manager_04");"
"SPMP: singleplayer"
@/
waittill_spawn_manager_enabled(spawn_manager_targetname)
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_enabled");
	}
	else
	{
		AssertMsg("waittill_spawn_manager_enabled: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
}

/@
"Name: waittill_spawn_manager_spawned_count( spawn_manager_targetname, count )"
"Module: Spawn Manager"
"Summary: Returns when the spawn manager has spawned the specified amount of AI."
"MandatoryArg: <spawn_manager_targetname>"
"MandatoryArg: count"
"Example: waittill_spawn_manager_spawned_count( "my_sm_targetname", 20 )
"SPMP: singleplayer"
@/

waittill_spawn_manager_spawned_count( spawn_manager_targetname, count )
{
	if( level flag_exists( "sm_" + spawn_manager_targetname + "_enabled" ) )
	{
		flag_wait("sm_" + spawn_manager_targetname + "_enabled");
	}
	else
	{
		AssertMsg("waittill_spawn_manager_spawned_count: Spawn manager '" + spawn_manager_targetname + "' not found.");
	}
	 
  spawn_manager = maps\_spawn_manager::get_spawn_manager_array( spawn_manager_targetname );

  assert( spawn_manager.size, "Somehow the spawn manager doesnt exist, but related flag existed before." );
  assert( ( spawn_manager.size == 1 ), "Found two spawn managers with same targetname." );

  assert( spawn_manager[0].count > count, "waittill_spawn_manager_spawned_count : Count should be less than total count on the spawn manager." );

  original_count = spawn_manager[0].count;

  // spawnCount holds the number of AI's are spawned
  while(1)
  {
    if( IsDefined( spawn_manager[0].spawnCount ) && ( spawn_manager[0].spawnCount < count ) && !is_spawn_manager_killed( spawn_manager_targetname ) )
    {
    	wait(0.5);
    }
    else
    {
    	break;
    }
  }
  
  return;
}

/@
"Name: get_ai_from_spawn_manager( spawn_manager_targetname )"
"Module: Spawn Manager"
"Summary: Returns the alive AI currently spawned from this spawn manager."
"MandatoryArg: <spawn_manager_targetname>"
"Example: a_guys = get_ai_from_spawn_manager( "my_sm_targetname" )
"SPMP: singleplayer"
@/

get_ai_from_spawn_manager( spawn_manager_targetname )
{
	sm = GetEnt( spawn_manager_targetname, "targetname" );
	
	if( !IsDefined( sm ) )
	{
		for( i = 0; i < level.spawn_managers.size; i++ )
		{
			if( level.spawn_managers[i].sm_id == spawn_manager_targetname )
			{
				sm = level.spawn_managers[i];
				break;
			}
		}	
	}
	
	Assert(IsDefined(sm), "Spawn manager: " + spawn_manager_targetname + " does not exist." );
	
	a_spawners = GetEntArray( sm.target, "targetname" );
	
	a_ai = [];
	
	foreach( spawner in a_spawners )
	{
		a_guys = GetEntArray( spawner.targetname + "_ai", "targetname" );
		
		if(a_guys.size > 0)
		{
			a_ai = ArrayCombine( a_ai, a_guys, true, false );
		}
	}
	
	return a_ai;
}


// --------------------------------------------------------------------------------
// ---- Spawn Manager - Scripter interface End ----
// --------------------------------------------------------------------------------

/@
"Name: veh_magic_bullet_shield( on = true )"
"Module: Vehicle"
"CallOn: a vehicle"
"Summary: Will toggle the vehicles god mode on"
"OptionalArg: [on] : true - god on, false - god off"
"Example: level.tank veh_magic_bullet_shield( true );"
"SPMP: singleplayer"
@/
veh_magic_bullet_shield( on = true )
{
	assert(!IsAI(self), "This is for vehicles, please use magic_bullet_shield for AI.");
	assert(!IsPlayer(self), "This is for vehicles, please use magic_bullet_shield for players.");

	self.magic_bullet_shield = ( on ? true : undefined );
}

/////////////////////////////////////////////////////////////////////
////////////////////////// CALLBACKS ////////////////////////////////
/////////////////////////////////////////////////////////////////////
/@
"Name: OnFirstPlayerConnect_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when the player connects"
"MandatoryArg: <func> the function you want to call on the new player."
"Example: OnFirstPlayerConnect_Callback(::on_first_player_connect);"
"SPMP: singleplayer"
@/
OnFirstPlayerConnect_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_first_player_connect", func);
}

/@
"Name: OnFirstPlayerConnect_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when the player connects"
"MandatoryArg: <func> the function you want to Remove on the new player."
"Example: OnFirstPlayerConnect_CallbackRemove(::on_first_player_connect);"
"SPMP: singleplayer"
@/
OnFirstPlayerConnect_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_first_player_connect", func);
}

/@
"Name: OnPlayerConnect_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player connects"
"MandatoryArg: <func> the function you want to call on the new player."
"Example: OnPlayerConnect_Callback(::on_player_connect);"
"SPMP: singleplayer"
@/
OnPlayerConnect_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_player_connect", func);
}

/@
"Name: OnPlayerConnect_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player connects"
"MandatoryArg: <func> the function you want to Remove on the new player."
"Example: OnPlayerConnect_CallbackRemove(::on_player_connect);"
"SPMP: singleplayer"
@/
OnPlayerConnect_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_player_connect", func);
}

/@
"Name: OnPlayerDisconnect_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player connects"
"MandatoryArg: <func> the function you want to call when a player disconnects."
"Example: OnPlayerDisconnect_Callback(::on_player_disconnect);"
"SPMP: singleplayer"
@/
OnPlayerDisconnect_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_player_disconnect", func);
}

/@
"Name: OnPlayerDisconnect_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player connects"
"MandatoryArg: <func> the function you want to Remove when a player disconnects."
"Example: OnPlayerDisconnect_CallbackRemove(::on_player_disconnect);"
"SPMP: singleplayer"
@/
OnPlayerDisconnect_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_player_disconnect", func);
}

/@
"Name: OnPlayerDamage_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player get damaged"
"MandatoryArg: <func> the function you want to call on the damaged player."
"Example: OnPlayerDamage_Callback(::on_player_damage);"
"SPMP: singleplayer"
@/
OnPlayerDamage_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_player_damage", func);
}

/@
"Name: OnPlayerDamage_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player get damaged"
"MandatoryArg: <func> the function you want to Remove on the damaged player."
"Example: OnPlayerDamage_CallbackRemove(::on_player_damage);"
"SPMP: singleplayer"
@/
OnPlayerDamage_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_player_damage", func);
}

/@
"Name: OnPlayerLastStand_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player goes into last stand"
"MandatoryArg: <func> the function you want to call when a player goes into last stand."
"Example: OnPlayerLastStand_Callback(::on_player_last_stand);"
"SPMP: singleplayer"
@/
OnPlayerLastStand_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_player_last_stand", func);
}

/@
"Name: OnPlayerLastStand_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player goes into last stand"
"MandatoryArg: <func> the function you want to remove when a player goes into last stand."
"Example: OnPlayerLastStand_CallbackRemove(::on_player_last_stand);"
"SPMP: singleplayer"
@/
OnPlayerLastStand_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_player_last_stand", func);
}

/@
"Name: OnPlayerKilled_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a player dies"
"MandatoryArg: <func> the function you want to call when a player dies."
"Example: OnPlayerKilled_Callback(::on_player_killed);"
"SPMP: singleplayer"
@/
OnPlayerKilled_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_player_killed", func);
}

/@
"Name: OnPlayerKilled_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a player dies"
"MandatoryArg: <func> the function you want to remove when a player dies."
"Example: OnPlayerKilled_CallbackRemove(::on_player_killed);"
"SPMP: singleplayer"
@/
OnPlayerKilled_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_player_killed", func);
}

// OnPlayerRevived_Callback(func)
// {
// 	// The revived callback doesn't seem to be called by code.
// 	// We need to fix this if we need this functionality
//
// 	maps\_callbackglobal::AddCallback("on_player_revived", func);
// }

/@
"Name: OnActorDamage_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an actor takes damage"
"MandatoryArg: <func> the function you want to call when an actor takes damage."
"Example: OnActorDamage_Callback(::on_actor_damage);"
"SPMP: singleplayer"
@/
OnActorDamage_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_actor_damage", func);
}

/@
"Name: OnActorDamage_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when an actor takes damage"
"MandatoryArg: <func> the function you want to remove when an actor takes damage."
"Example: OnActorDamage_CallbackRemove(::on_actor_damage);"
"SPMP: singleplayer"
@/
OnActorDamage_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_actor_damage", func);
}

/@
"Name: OnActorKilled_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when an actor dies"
"MandatoryArg: <func> the function you want to call when an actor dies."
"Example: OnActorDamage_Callback(::on_actor_killed);"
"SPMP: singleplayer"
@/
OnActorKilled_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_actor_killed", func);
}

/@
"Name: OnActorKilled_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when an actor dies"
"MandatoryArg: <func> the function you want to remove when an actor dies."
"Example: OnActorDamage_CallbackRemove(::on_actor_killed);"
"SPMP: singleplayer"
@/
OnActorKilled_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_actor_killed", func);
}

/@
"Name: OnVehicleDamage_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a vehicle takes damage"
"MandatoryArg: <func> the function you want to call when a vehicle takes damage."
"Example: OnVehicleDamage_Callback(::on_vehicle_damage);"
"SPMP: singleplayer"
@/
OnVehicleDamage_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_vehicle_damage", func);
}

/@
"Name: OnVehicleDamage_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback for when a vehicle takes damage"
"MandatoryArg: <func> the function you want to remove when a vehicle takes damage."
"Example: OnVehicleDamage_CallbackRemove(::on_vehicle_damage);"
"SPMP: singleplayer"
@/
OnVehicleDamage_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_vehicle_damage", func);
}


/@
"Name: OnSaveRestored_Callback(<func>)"
"Module: Callbacks"
"Summary: Set a callback for when a save is restored"
"MandatoryArg: <func> the function you want to call when a save is restored."
"Example: OnSaveRestored_Callback(::on_save_restored);"
"SPMP: singleplayer"
@/
OnSaveRestored_Callback(func)
{
	maps\_callbackglobal::AddCallback("on_save_restored", func);
}

/@
"Name: OnSaveRestored_CallbackRemove(<func>)"
"Module: Callbacks"
"Summary: Remove a callback that was set for when a save is restored"
"MandatoryArg: <func> the function you want to remove from the save restored functionality."
"Example: OnSaveRestored_CallbackRemove(::on_save_restored);"
"SPMP: singleplayer"
@/
OnSaveRestored_CallbackRemove(func)
{
	maps\_callbackglobal::RemoveCallback("on_save_restored", func);
}

/////////////////////////////////////////////////////////////////////
////////////////////////// END CALLBACKS ////////////////////////////
/////////////////////////////////////////////////////////////////////

/@
"Name: aim_at_target(target, duration)"
"Summary: Force AI to start aiming at given target"
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <target> The target entity."
"OptionalArg: <duration> The duraton of aiming. Leave undefined for infinite."
"Example: level.price aim_at_target( level.player );"
"SPMP: singleplayer"
@/
aim_at_target(target, duration)
{
	self	endon("death");
	self	endon("stop_aim_at_target");

	assert( IsDefined(target) );
	if( !IsDefined(target) )
	{
		return;
	}

	self SetEntityTarget( target );
	self.a.allow_shooting = false;

	// aim for duration
	if( IsDefined(duration) && duration > 0 )
	{
		elapsed = 0;
		while( elapsed < duration )
		{
			elapsed += 0.05;
			wait(0.05);
		}

		stop_aim_at_target();
	}
}

/@
"Name: stop_aim_at_target()"
"Summary: Stop the AI from forced aiming and allow it to go back to normal"
"Module: AI"
"CallOn: An AI"
"Example: level.price stop_aim_at_target();"
"SPMP: singleplayer"
@/
stop_aim_at_target()
{
	self ClearEntityTarget();
	self.a.allow_shooting = true;

	self notify("stop_aim_at_target");
}

/@
"Name: shoot_at_target(target, tag, fireDelay, duration)"
"Summary: Force AI to aim and shoot at given target"
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <target> The target entity."
"OptionalArg: <tag> The tag of the entity to shoot at"
"OptionalArg: <fireDelay> How long to wait before firing. The AI will aim during this time."
"OptionalArg: <duration> The duraton of aiming. Leave undefined for one shot only."
"Example: level.price aim_at_target( level.player );"
"SPMP: singleplayer"
@/
shoot_at_target(target, tag, fireDelay, duration)
{
	self endon("death");
	self endon("stop_shoot_at_target");

	Assert( IsDefined( target ), "shoot_at_target was passed an undefined target" );
	if ( !IsDefined( target ) || ( ( IS_EQUAL( duration, -1 ) ) && ( target.health <= 0 ) ) )
	{
		return;	// undefined target or target already dead
	}
	
	if( IsDefined(tag) && tag != "" && tag != "tag_eye" && tag != "tag_head" )
	{
		self SetEntityTarget( target, 1, tag );
	}
	else
	{
		self SetEntityTarget( target );
	}

	// make sure there's enough ammo to shoot
	self animscripts\weaponList::RefillClip();

	// wait to aim before firing
	if( IsDefined(fireDelay) && fireDelay > 0 )
	{
		self.a.allow_shooting = false;
		wait( fireDelay );
	}

	// turn on shooting
	self.a.allow_shooting = true;

	// make sure the AI shoots it, even if not visible
	self.cansee_override = true;

	// force the shoot pos now
	self animscripts\shoot_behavior::setShootEnt( target );

	// wait for first shot
	self waittill("shoot");

	// fire for duration
	if( IsDefined(duration) )
	{
		if( duration > 0)
		{
			elapsed = 0;
			while( elapsed < duration )
			{
				elapsed += 0.05;
				wait(0.05);
			}
		}
		else if (duration == -1)
		{
			target waittill("death");
		}
	}

	stop_shoot_at_target();
}

/@
"Name: shoot_at_target_untill_dead(target, tag, fireDelay)"
"Summary: Force AI to aim and shoot at given target untill it's dead."
"Module: AI"
"CallOn: An AI"
"MandatoryArg: <target> The target entity."
"OptionalArg: <tag> The tag of the entity to shoot at"
"OptionalArg: <fireDelay> How long to wait before firing. The AI will aim during this time."
"Example: level.price shoot_at_target_untill_dead( target_dude );"
"SPMP: singleplayer"
@/
shoot_at_target_untill_dead(target, tag, fireDelay)
{
	shoot_at_target(target, tag, fireDelay, -1);
}


/@
"Name: shoot_and_kill( <e_enemy>, [n_fire_delay] )"
"Summary: Forces an AI to aim and shoot at given enemy and guarantee the kill."
"CallOn: AI"
"MandatoryArg: <e_enemy> The AI you're going to have killed."
"OptionalArg: [n_fire_delay] How long to wait before firing. The AI will aim during this time."
"Example: ai_shooter thread shoot_and_kill( ai_victim, 10 );"
"SPMP: singleplayer"
@/
shoot_and_kill( e_enemy, n_fire_delay )
{
	self endon( "death" );

	self.old_perfectAim = self.perfectAim;
	self.perfectAim = true;
	
	self shoot_at_target( e_enemy, "J_head", n_fire_delay, -1 );

	self.perfectAim = self.old_perfectAim;
	self.old_pefectAim = undefined;
	
	self notify( "enemy_killed" );
}



/@
"Name: stop_shoot_at_target()"
"Summary: Give the AI his gun back."
"Module: AI"
"CallOn: An AI"
"Example: level.price stop_shoot_at_target();"
"SPMP: singleplayer"
@/
stop_shoot_at_target()
{
	self ClearEntityTarget();

	self.cansee_override = false;

	self notify("stop_shoot_at_target");
}

add_trigger_to_ent(ent) // Self == The trigger volume
{
	if(!IsDefined(ent._triggers))
	{
		ent._triggers = [];
	}
	
	ent._triggers[self GetEntityNumber()] = 1;
}

remove_trigger_from_ent(ent)	// Self == The trigger volume.
{
	if(!IsDefined(ent._triggers))
		return;
		
	if(!IsDefined(ent._triggers[self GetEntityNumber()]))
		return;
		
	ent._triggers[self GetEntityNumber()] = 0;
}

ent_already_in_trigger(trig)	// Self == The entity in the trigger volume.
{
	if(!IsDefined(self._triggers))
		return false;
		
	if(!IsDefined(self._triggers[trig GetEntityNumber()]))
		return false;
		
	if(!self._triggers[trig GetEntityNumber()])
		return false;
		
	return true;	// We're already in this trigger volume.
}

trigger_thread(ent, on_enter_payload, on_exit_payload)	// Self == The trigger.
{
	ent endon("entityshutdown");
	ent endon("death");
	
	if(ent ent_already_in_trigger(self))
		return;
		
	self add_trigger_to_ent(ent);

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());
	
	endon_condition = "leave_trigger_" + self GetEntityNumber();
	
	if(IsDefined(on_enter_payload))
	{
		self thread [[on_enter_payload]](ent, endon_condition);
	}
	
	while(IsDefined(ent) && ent IsTouching(self))
	{
		wait(0.01);
	}

	ent notify(endon_condition);

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if(IsDefined(ent) && IsDefined(on_exit_payload))
	{
		self thread [[on_exit_payload]](ent);
	}

	if(IsDefined(ent))
	{
		self remove_trigger_from_ent(ent);
	}

}


/@
"Name: delete_ents()"
"Summary: Delete all ents with specified mask within radius"
"Module: Utility"
"CallOn: "
"Example: delete_ents( level.CONTENTS_CORPSE, get_players()[0].origin, 1024 );"
"SPMP: singleplayer"
@/
delete_ents( mask, origin, radius )
{
	ents = entsearch( mask, origin, radius );
	for( i = 0; i < ents.size; i++ )
	{
		ents[i] delete();
	}
}

/@
"Name: set_drop_weapon(<weapon_name>)"
"Summary: Specify what weapon an AI will drop."
"Module: Utility"
"CallOn: AI"
"MandatoryArg: <weapon_name> The name of the weapon to drop."
"Example: guy set_drop_weapon("dragonov_sp");"
"SPMP: singleplayer"
@/
set_drop_weapon(weapon_name)
{
	assert(IsDefined(weapon_name) && IsString(weapon_name), "_utility::set_drop_weapon: Invalid weapon name!");
	self.script_dropweapon = weapon_name;
}


/@
"Name: take_and_giveback_weapons()"
"Summary: Removes all the player's weapons, waits for a notify that is passed through, and returns all weapons at previous ammo"
"Module: Player"
"CallOn: A player"
"Example: get_players()[0] thread take_and_giveback_weapons("giveback");"
"SPMP: singleplayer"
@/

take_and_giveback_weapons(mynotify, no_autoswitch)
{
	take_weapons();
	self waittill (mynotify);
	give_weapons(no_autoswitch);
}

take_weapons()
{
	self.curweapon = self GetCurrentWeapon();
	self.weapons_list = self GetWeaponsList();
	self.offhand = self GetCurrentOffhand();

	weapon_list_modified = [];

	// remove all the attachmentweapon/altweapons from the weaponlist
	for ( i = 0; i < self.weapons_list.size; i++)
	{
		if( !is_weapon_attachment( self.weapons_list[i] ) )
			weapon_list_modified[ weapon_list_modified.size ] = self.weapons_list[i];
	}

	// store the modified list back into the weapons list
	self.weapons_list = weapon_list_modified;

	// if the current weapon is an alt weapon, then find the base weapon and make it currentweapon
	// as we cant give just attachmentweapon/altweapon to the player
	if( is_weapon_attachment( self.curweapon ) )
	{
		self.curweapon = get_baseweapon_for_attachment( self.curweapon );
	}

	self.weapons_info = [];

	for ( i = 0; i < self.weapons_list.size; i++)
	{
		self.weapons_info[i] = SpawnStruct();

		if (IsDefined(self.offhand) && self.weapons_list[i] == self.offhand )
		{
			self.weapons_info[i]._ammo = 0;
			self.weapons_info[i]._stock = self GetWeaponAmmoStock(self.weapons_list[i]);
		}
		else
		{
			self.weapons_info[i]._ammo = self GetWeaponAmmoClip(self.weapons_list[i]);
			self.weapons_info[i]._stock = self GetWeaponAmmoStock(self.weapons_list[i]);
			self.weapons_info[i]._renderOptions = self GetWeaponRenderOptions( self.weapons_list[i] );
		}
	}

	self TakeAllWeapons();
}

give_weapons(no_autoswitch)
{
	for (i=0; i < self.weapons_list.size; i++)
	{
		if( IsDefined( self.weapons_info[i]._renderOptions ) )
		{
			self GiveWeapon(self.weapons_list[i], 0, self.weapons_info[i]._renderOptions );
		}
		else
		{
			self GiveWeapon(self.weapons_list[i]);
		}

		self SetWeaponAmmoClip(self.weapons_list[i], self.weapons_info[i]._ammo);
		self SetWeaponAmmoStock(self.weapons_list[i], self.weapons_info[i]._stock );
	}

	self.weapons_info = undefined;

	if( IsDefined( self.curweapon ) && !IsDefined(no_autoswitch) )
	{
		if ( self.curweapon != "none" )
		{
			self SwitchToWeapon(self.curweapon);
		}
		else
		{
			// If we had "none", then find a primary weapon to switch to
			// Try not to switch to a Pistol unless you have to
			str_primary = "";
			foreach( str_weapon in self.weapons_list)
			{
				if ( WeaponInventoryType( str_weapon ) == "primary" )
				{
					str_primary = str_weapon;

					// If it's not a pistol, go ahead and stop looking.
					//	Otherwise, go ahead and use the pistol unless we find
					//	another, non-pistol weapon.
					if ( WeaponClass( str_weapon ) != "pistol" )
					{
						break;
					}
				}
			}
			if ( str_primary != "" )
			{
				self SwitchToWeapon( str_primary );
			}
		}
	}
}

is_weapon_attachment( weapon_name )
{
	weapon_pieces = StrTok(weapon_name, "_");
	
	if( weapon_pieces[0] == "ft" || weapon_pieces[0] == "mk" || weapon_pieces[0] == "gl" )
	{
		return true;
	}
	
	return false;
}


// do not call this function from level script, only meant to be used by take_weapons function
get_baseweapon_for_attachment( weapon_name )
{
	Assert( is_weapon_attachment( weapon_name ) );

	// find the attachment type
	weapon_pieces = StrTok( weapon_name, "_" );
	
	attachment = weapon_pieces[0];
	Assert( weapon_pieces[0] == "ft" || weapon_pieces[0] == "mk" || weapon_pieces[0] == "gl" || weapon_pieces[0] == "db" );
	
	// find the weapon related to this attachment
	weapon = weapon_pieces[1];
	Assert( weapon_pieces[1] != "ft" && weapon_pieces[1] != "mk" && weapon_pieces[1] != "gl" && weapon_pieces[1] != "db"  );
	
	// now find a base weapon that has this combination
	for ( i = 0; i < self.weapons_list.size; i++)
	{
		if( IsSubStr( self.weapons_list[i], weapon ) && IsSubStr( self.weapons_list[i], attachment ) )
			return self.weapons_list[i];
	}

	// if in case no weapon is found, just return the first one in the inventory
	// this is just a fallback
	return self.weapons_list[0];
}




/@
"Name: screen_message_create(<string_message>)"
"Summary: Creates a HUD element at the correct position with the string or string reference passed in."
"Module: Utility"
"CallOn: N/A"
"MandatoryArg: <string_message_1> : A string or string reference to place on the screen."
"OptionalArg: <string_message_2> : A second string to display below the first."
"OptionalArg: <string_message_3> : A third string to display below the second."
"OptionalArg: <n_offset_y>: Optional offset in y direction that should only be used in very specific circumstances."
"OptionalArg: <n_time> : Length of time to display the message."
"Example: screen_message_create( &"LEVEL_STRING" );"
"SPMP: singleplayer"
@/
screen_message_create( string_message_1, string_message_2, string_message_3, n_offset_y, n_time )
{
	level notify( "screen_message_create" );
	level endon( "screen_message_create" );
	
	// if the mission is failing then do no create this instruction
	// because it can potentially overlap the death/hint string
	if( IsDefined( level.missionfailed ) && level.missionfailed )
		return;
	
	// if player is killed then this dvar will be set.
	// SUMEET_TODO - make it efficient next game instead of checking dvar here
	if( GetDvarInt( "hud_missionFailed" ) == 1 )
		return;

	if ( !IsDefined( n_offset_y ) )
	{
		n_offset_y = 0;
	}
	
	//handle displaying the first string
	if( !IsDefined(level._screen_message_1) )
	{
		//text element that displays the name of the event
		level._screen_message_1 = NewHudElem();
		level._screen_message_1.elemType = "font";
		level._screen_message_1.font = "objective";
		level._screen_message_1.fontscale = 1.8;
		level._screen_message_1.horzAlign = "center";
		level._screen_message_1.vertAlign = "middle";
		level._screen_message_1.alignX = "center";
		level._screen_message_1.alignY = "middle";
		level._screen_message_1.y = -60 + n_offset_y;
		level._screen_message_1.sort = 2;
		
		level._screen_message_1.color = ( 1, 1, 1 );
		level._screen_message_1.alpha = 0.70;
		
		level._screen_message_1.hidewheninmenu = true;
	}

	//set the text of the element to the string passed in
	level._screen_message_1 SetText( string_message_1 );

	if( IsDefined(string_message_2) )
	{
		//handle displaying the first string
		if( !IsDefined(level._screen_message_2) )
		{
			//text element that displays the name of the event
			level._screen_message_2 = NewHudElem();
			level._screen_message_2.elemType = "font";
			level._screen_message_2.font = "objective";
			level._screen_message_2.fontscale = 1.8;
			level._screen_message_2.horzAlign = "center";
			level._screen_message_2.vertAlign = "middle";
			level._screen_message_2.alignX = "center";
			level._screen_message_2.alignY = "middle";
			level._screen_message_2.y = -33 + n_offset_y;
			level._screen_message_2.sort = 2;

			level._screen_message_2.color = ( 1, 1, 1 );
			level._screen_message_2.alpha = 0.70;
			
			level._screen_message_2.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		level._screen_message_2 SetText( string_message_2 );
	}
	else if( IsDefined(level._screen_message_2) )
	{
		level._screen_message_2 Destroy();
	}
	
	if( IsDefined(string_message_3) )
	{
		//handle displaying the first string
		if( !IsDefined(level._screen_message_3) )
		{
			//text element that displays the name of the event
			level._screen_message_3 = NewHudElem();
			level._screen_message_3.elemType = "font";
			level._screen_message_3.font = "objective";
			level._screen_message_3.fontscale = 1.8;
			level._screen_message_3.horzAlign = "center";
			level._screen_message_3.vertAlign = "middle";
			level._screen_message_3.alignX = "center";
			level._screen_message_3.alignY = "middle";
			level._screen_message_3.y = -6 + n_offset_y;
			level._screen_message_3.sort = 2;

			level._screen_message_3.color = ( 1, 1, 1 );
			level._screen_message_3.alpha = 0.70;
			
			level._screen_message_3.hidewheninmenu = true;
		}
	
		//set the text of the element to the string passed in
		level._screen_message_3 SetText( string_message_3 );
	}
	else if( IsDefined(level._screen_message_3) )
	{
		level._screen_message_3 Destroy();
	}
	
	if ( IsDefined( n_time ) && n_time > 0 )
	{
		wait( n_time );
		
		screen_message_delete();
	}
}
	

/@
"Name: screen_message_delete()"
"Summary: Deletes the current message being displayed on the screen made using screen_message_create."
"Module: Utility"
"CallOn: N/A"
"Example: screen_message_delete();"
"SPMP: singleplayer"
@/
screen_message_delete()
{
	if( IsDefined(level._screen_message_1) )
	{
		level._screen_message_1 Destroy();
	}
	if( IsDefined(level._screen_message_2) )
	{
		level._screen_message_2 Destroy();
	}
	if( IsDefined(level._screen_message_3) )
	{
		level._screen_message_3 Destroy();
	}
}


/@
"Name: get_eye()"
"Summary: Get eye position accurately even on a player when linked to an entity."
"Module: Utility"
"CallOn: Player or AI"
"Example: eye_pos = player get_eye();"
"SPMP: singleplayer"
@/
get_eye()
{
	if (IsPlayer(self))
	{
		linked_ent = self GetLinkedEnt();
		if (IsDefined(linked_ent) && (GetDvarint( "cg_cameraUseTagCamera") > 0))
		{
			camera = linked_ent GetTagOrigin("tag_camera");
			if (IsDefined(camera))
			{
				return camera;
			}
		}
	}

	pos = self GetEye();
	return pos;
}

/@
"Name: vehicle_node_wait( <strName> , <strKey> )"
"Summary: Waits until a vehicle node with the specified key / value is triggered. Returns the node and assigns the entity that triggered it to "node.who"."
"Module: Vehicle"
"MandatoryArg: <strName> : Key value."
"OptionalArg: <strKey> : Key name on the node to use, example: "targetname" or "script_noteworthy". Defaults to "targetname"."
"Example: vehicle_node_wait( "heli_landing", "script_noteworthy" );"
"SPMP: SP"
@/
vehicle_node_wait( strName, strKey )
{
	if( !IsDefined( strKey ) )
	{
		strKey = "targetname";
	}

	nodes = GetVehicleNodeArray( strName, strKey );
	assert( IsDefined(nodes) && nodes.size > 0, "_utility::vehicle_node_wait - vehicle node not found: " + strName + " key: " + strKey );

	ent = SpawnStruct();
	array_thread( nodes, common_scripts\utility::_trigger_wait_think, ent );

	ent waittill( "trigger", eOther, node_hit );
	level notify( strName, eOther );

	if(IsDefined(node_hit))
	{
		node_hit.who = eother;
		return node_hit;
	}
	else
	{
		return eOther;
	}
}

/@
"Name: timescale_tween( <start>, <end>, <time>, [delay], [step_time] )"
"Summary: Tweens timescale from a starting value to an ending value over time."
"Module: Utility"
"MandatoryArg: start: Starting timescale."
"MandatoryArg: end: Ending timescale."
"MandatoryArg: time: Time to get form start to end."
"OptionalArg: delay: time delay before starting."
"OptionalArg: step_time: time delay between setting timescale values (how smoothly you want to step)."
"Example: level thread timescale_tween(.06, 1, tween_time);"
"SPMP: SP"
@/
timescale_tween(start, end, time, delay = 0.0, step_time = 0.1 )
{
	if ( !IsDefined( start ) )
	{
		start = GetTimeScale();
	}
	
	num_steps = time / step_time;
	time_scale_range = end - start;

	time_scale_step = 0;
	if (num_steps > 0)
	{
		time_scale_step = abs(time_scale_range) / num_steps;
	}

	if ( delay > 0.0 )
	{
		wait delay;
	}

	level notify("timescale_tween");
	level endon("timescale_tween");

	time_scale = start;
	SetTimeScale(time_scale);

	while (time_scale != end)
	{
		wait(step_time);

		if (time_scale_range > 0)
		{
			time_scale = min(time_scale + time_scale_step, end);
		}
		else if (time_scale_range < 0)
		{
			time_scale = max(time_scale - time_scale_step, end);
		}

		SetTimeScale(time_scale);
	}
}

/@
"Name: depth_of_field_tween( <n_near_start>, <n_near_end>, <n_far_start>, <n_far_end>, <n_near_blur>, <n_far_blur>, <n_time>, [n_step_time] )"
"Summary: Tweens depth of field from a starting values to an ending values over time."
"Module: Utility"
"MandatoryArg: n_near_start"
"MandatoryArg: n_near_end"
"MandatoryArg: n_far_start"
"MandatoryArg: n_far_end"
"MandatoryArg: n_near_blur"
"MandatoryArg: n_far_blur"
"MandatoryArg: n_time: time it takes to tween to the new values."
"OptionalArg: n_step_time: time delay between setting timescale values (how smoothly you want to step)."
"Example: level.player depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, 3 );"
"SPMP: SP"
@/
depth_of_field_tween( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur, n_time, n_step_time )
{
	self notify("depth_of_field_tween");
	self endon("depth_of_field_tween");
	
	const DEFAULT_STEP_TIME = .05;

	if ( !IsDefined( n_step_time ) )
	{
		n_step_time = DEFAULT_STEP_TIME;
	}

	n_steps = n_time / n_step_time;
	
	if ( n_steps > 0 )
	{
		n_near_start_current = self GetDepthOfField_NearStart();
		n_near_end_current = self GetDepthOfField_NearEnd();
		n_far_start_current = self GetDepthOfField_FarStart();
		n_far_end_current = self GetDepthOfField_FarEnd();
		n_near_blur_current = self GetDepthOfField_NearBlur();
		n_far_blur_current = self GetDepthOfField_FarBlur();
		
		// far_start can't be less than near_end, but the default values break that rule apparently
		n_far_start_current = max( n_far_start_current, n_near_end_current );
		
		n_near_start_step = 0;
		n_near_end_step	= 0;
		n_far_start_step = 0;
		n_far_end_step = 0;
		n_near_blur_step = 0;
		n_far_blur_step = 0;
	
		n_near_start_step = ( n_near_start - n_near_start_current ) / n_steps;
		n_near_end_step = ( n_near_end - n_near_end_current ) / n_steps;
		n_far_start_step = ( n_far_start - n_far_start_current ) / n_steps;
		n_far_end_step = ( n_far_end - n_far_end_current ) / n_steps;
		n_near_blur_step = ( n_near_blur - n_near_blur_current ) / n_steps;
		n_far_blur_step = ( n_far_blur - n_far_blur_current ) / n_steps;

		for ( i = 0; i < n_steps; i++ )
		{
			n_near_start_current += n_near_start_step;
			n_near_end_current += n_near_end_step;
			n_far_start_current += n_far_start_step;
			n_far_end_current += n_far_end_step;
			n_near_blur_current += n_near_blur_step;
			n_far_blur_current += n_far_blur_step;
			
			n_near_blur_current = max( n_near_blur_current, 4 ); // clamp to min near blur value
			
			if ( n_far_blur_current < 0 )
			{
				n_far_blur_current = 0;
			}
			
			self SetDepthOfField( n_near_start_current, n_near_end_current, n_far_start_current, n_far_end_current, n_near_blur_current, n_far_blur_current );
			
			wait n_step_time;
		}
		
		/* set final values to make sure exact values are set */
		
		n_near_blur = max( n_near_blur, 4 ); // clamp to min near blur value
		
		self SetDepthOfField( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur );
	}
}

/@
"Name: depth_of_field_off( <n_time> )"
"Summary: Tweens depth of field off over time."
"Module: Utility"
"OptionalArg: n_time: time it takes to tween off the DOF."
"Example: level.player depth_of_field_off( .5 );"
"SPMP: SP"
@/
depth_of_field_off( n_time )
{
	n_time = ( IsDefined( n_time ) ? n_time * 1000 : 0 );
	
	n_near_start_current = self GetDepthOfField_NearStart();
	n_near_end_current = self GetDepthOfField_NearEnd();
	n_far_start_current = self GetDepthOfField_FarStart();
	n_far_end_current = self GetDepthOfField_FarEnd();
	n_near_blur_current = self GetDepthOfField_NearBlur();
	n_far_blur_current = self GetDepthOfField_FarBlur();
	
	const n_near_start_to = 1;
	const n_near_end_to = 0;
	const n_far_start_to = 1;
	const n_far_end_to = 0;
	const n_near_blur_to = 6;
	const n_far_blur_to = 4;
	
	n_start_time = GetTime();
	
	do
	{
		wait .05;
		
		n_time_delta = GetTime() - n_start_time;
		n_time_frac = ( ( n_time > 0 ) ? ( n_time_delta / n_time ) : 1 );
		
		n_near_start	= LerpFloat( n_near_start_current,	n_near_start_to,	n_time_frac );
		n_near_end		= LerpFloat( n_near_end_current,	n_near_end_to,		n_time_frac );
		n_far_start		= LerpFloat( n_far_start_current,	n_far_start_to,		n_time_frac );
		n_far_end		= LerpFloat( n_far_end_current,		n_far_end_to,		n_time_frac );
		n_near_blur		= LerpFloat( n_near_blur_current,	n_near_blur_to,		n_time_frac );
		n_far_blur		= LerpFloat( n_far_blur_current,	n_far_blur_to,		n_time_frac );
		
		self SetDepthOfField( n_near_start, n_near_end, n_far_start, n_far_end, n_near_blur, n_far_blur );
	}
	while ( n_time_delta < n_time );
}

/@
"Name: player_seek"
"Summary: when called AI will move towards the player and attack the player."
"Module: Utility"
"Example: add script_playerseek kvp on the spawner"
"SPMP: SP"
@/
player_seek( delayed )
{
	self endon("death");
	
	// ignore suppression so that this AI can charge the player
	self.ignoresuppression = 1;

	// if this AI is supposed to go to a node, then wait until it gets to node
	if( IsDefined( self.target ) || IsDefined( self.script_spawner_targets ) )
	{
		self waittill("goal");
	}
		
	// now keep reducing the goalradius so this ai comes closer to the player in stages
	while(1)
	{
		// wait as needed
		if( IsDefined( delayed ) )
		{
			wait( RandomIntRange( 6, 12 ) );
		}
		else
		{
			wait( 0.05 );
		}
	
		// keep reducing the goal distance
		if( self.goalradius > 100 )
		{
			self.goalradius = self.goalradius - 100;
		}
		
		// modify the path enemy distance so that AI goes near the goal
		self.pathenemyFightdist = self.goalradius;

		// set the goal entity
		closest_player = get_closest_player( self.origin );
		self SetGoalEntity( closest_player );
		self animscripts\combat_utility::lookForBetterCover();
	}
}

/@
"Name: set_spawner_targets(<spawner_target_names>)"
"Summary: Gives an AI new script_spawner_targets node(s) to go to. Overrides previously set script_spawner_targets. Seperate sets by spaces."
"Module: Utility"
"Example: guy set_spawner_targets("balcony1 balcony2");"
"SPMP: SP"
@/
set_spawner_targets(spawner_targets)
{
	self thread maps\_spawner::go_to_spawner_target(StrTok(spawner_targets," "));
}

/@
"Name: ragdoll_death()"
"Summary: Starts ragdoll on an AI and kills him."
"Module: Utility"
"Example: guy ragdoll_death();"
"SPMP: SP"
@/
ragdoll_death()
{
	self animscripts\utility::do_ragdoll_death();
}

is_destructible()
{
	if (!IsDefined(self.script_noteworthy))
	{
		return false;
	}

	switch (self.script_noteworthy)
	{
	case "explodable_barrel":
		return true;
	}

	return false;
}

/@
"Name: waittill_not_moving()"
"Summary: waits for the object to stop moving"
"Module: Utility"
"CallOn: Object that moves like a thrown grenade"
"Example: self waittill_not_moving();"
"SPMP: singleplayer"
@/
waittill_not_moving()
{
	self endon("death");
	self endon( "disconnect" );
	self endon( "detonated" );
	level endon( "game_ended" );

	//if ( self.classname == "grenade" )
	//{
	//	self waittill("stationary");
	//}
	//else
	//{
		prevorigin = self.origin;
		while(1)
		{
			wait .15;
			if ( self.origin == prevorigin )
				break;
			prevorigin = self.origin;
		}
	//}
}

turn_off_friendly_player_look()
{
	level._dont_look_at_player = true;
}

turn_on_friendly_player_look()
{
	level._dont_look_at_player = false;
}

/@
"Name: force_goal([node_or_org], [radius], [shoot], [endon])"
"Summary: Force an AI to go to goal by temporarily disabling AI features."
"Module: AI"
"OptionalArg: [node_or_org] : Optional node or position to set the goal to."
"OptionalArg: [radius] : Option goal radius."
"OptionalArg: [shoot] : Enable/Disable shoot while moving (defaults to true)."
"OptionalArg: [endon] : The endon string that will set this AI back to normal (defaults to 'goal')."
"Example: self thread force_goal( node, 20, true );"
"SPMP: SP"
@/
force_goal( node_or_org, radius, shoot = true, end_on, keep_colors = false )
{
	self endon( "death" );

	goalradius = self.goalradius;
	if ( IsDefined( radius ) )
	{
		self.goalradius = radius;
	}

	color_enabled = false;
	if ( !keep_colors )
	{
		if ( IsDefined( get_force_color() ) )
		{
			color_enabled = true;
			self disable_ai_color();
		}
	}

	allowpain				= self.allowpain;
	allowreact				= self.allowreact;
	ignoreall				= self.ignoreall;
	ignoreme				= self.ignoreme;
	dontshootwhilemoving	= self.dontshootwhilemoving;
	ignoresuppression		= self.ignoresuppression;
	suppressionthreshold	= self.suppressionthreshold;
	nododgemove				= self.nododgemove;
	grenadeawareness		= self.grenadeawareness;
	pathenemylookahead		= self.pathenemylookahead;
	pathenemyfightdist		= self.pathenemyfightdist;
	meleeattackdist			= self.meleeattackdist;
	fixednodesaferadius		= self.fixednodesaferadius;

	if ( !shoot )
	{
		self set_ignoreall( true );
	}

	self.dontshootwhilemoving	= undefined;
	self.pathenemyfightdist		= 0;
	self.pathenemylookahead		= 0;
	self.ignoresuppression		= true;
	self.suppressionthreshold	= 1;
	self.nododgemove			= true;
	self.grenadeawareness		= 0;
	self.meleeattackdist		= 0;
	self.fixednodesaferadius	= 0;

	self set_ignoreme( true );
	self disable_react();
	self disable_pain();
	
	self PushPlayer( true );
	
	if ( self.bulletsInClip == 0 )
	{
		// no reload before moving
		self.bulletsInClip = 15;
	}

	if ( IsDefined( node_or_org ) )
	{
		if ( IsVec( node_or_org ) )
		{
			self set_goal_pos( node_or_org );
		}
		else
		{
			self set_goal_node( node_or_org );
		}
	}

	if ( IsDefined( end_on ) )
	{
		self waittill( end_on );
	}
	else
	{
		self waittill( "goal" );
	}

	if ( color_enabled )
	{
		enable_ai_color();
	}

	self PushPlayer( false );	// assume we want this off once we have reached goal

	self.goalradius = goalradius;
	self set_ignoreall( ignoreall );
	self set_ignoreme( ignoreme );

	if ( allowpain )
	{
		self enable_pain();
	}

	if ( allowreact )
	{
		self enable_react();
	}

	self.ignoresuppression		= ignoresuppression;
	self.suppressionthreshold	= suppressionthreshold;
	self.nododgemove			= nododgemove;
	self.dontshootwhilemoving	= dontshootwhilemoving;
	self.grenadeawareness		= grenadeawareness;
	self.pathenemylookahead		= pathenemylookahead;
	self.pathenemyfightdist		= pathenemyfightdist;
	self.meleeattackdist		= meleeattackdist;
	self.fixednodesaferadius	= fixednodesaferadius;
}

restore_ik_headtracking_limits()
{
	SetSavedDvar("ik_pitch_limit_thresh", 10);
	SetSavedDvar("ik_pitch_limit_max", 60);
	SetSavedDvar("ik_roll_limit_thresh", 30);
	SetSavedDvar("ik_roll_limit_max", 100);
	SetSavedDvar("ik_yaw_limit_thresh", 10);
	SetSavedDvar("ik_yaw_limit_max", 90);
}

relax_ik_headtracking_limits()
{
	SetSavedDvar("ik_pitch_limit_thresh", 110);
	SetSavedDvar("ik_pitch_limit_max", 120);
	SetSavedDvar("ik_roll_limit_thresh", 90);
	SetSavedDvar("ik_roll_limit_max", 100);
	SetSavedDvar("ik_yaw_limit_thresh", 80);
	SetSavedDvar("ik_yaw_limit_max", 90);
}



/@
"Name: enable_random_weapon_drops()"
"Summary: Enable AI to drop random weapons"
"Module: AI"
"Example: enable_random_weapon_drops()"
"SPMP: SP"
@/

enable_random_weapon_drops()
{
	level.rw_enabled = true;
}

/@
"Name: disable_random_weapon_drops()"
"Summary: Disable AI to drop random weapons"
"Module: AI"
"Example: disable_random_weapon_drops()"
"SPMP: SP"
@/

disable_random_weapon_drops()
{
	level.rw_enabled = false;
}

/@
"Name: enable_random_alt_weapon_drops()"
"Summary: Enable AI to drop random weapons with alt_weapon capabilities (ft, gl, mk, etc)"
"Module: AI"
"Example: enable_random_alt_weapon_drops()"
"SPMP: SP"
@/

enable_random_alt_weapon_drops()
{
	level.rw_attachments_allowed = true;
}

/@
"Name: disable_random_alt_weapon_drops()"
"Summary: Disable AI to drop random weapons with alt_weapon capabilities (ft, gl, mk, etc)"
"Module: AI"
"Example: disable_random_alt_weapon_drops()"
"SPMP: SP"
@/

disable_random_alt_weapon_drops()
{
	level.rw_attachments_allowed = false;
}

/@
"Name: set_random_alt_weapon_drops( <attachment_abbreviation> , <on_or_off> )"
"Summary: set the droppability of an alt weapon from the random weapon drop system). True/On  False/Off "
"Module: AI"
"Example: set_random_alt_weapon_drops( "ft" , true )"
"SPMP: SP"
@/

set_random_alt_weapon_drops( attachment_abbreviation, on_or_off )
{
	assert(IsDefined(attachment_abbreviation), "set_random_alt_weapon_drops called without passing in an attachment type");
	assert(IsDefined(on_or_off), "set_random_alt_weapon_drops called without telling the function whether it is on or off");
	
	switch( attachment_abbreviation )
	{
		case "ft":
			level.rw_ft_allowed = on_or_off;
		break;
		
		case "gl":
			level.rw_gl_allowed = on_or_off;
		break;
		
		case "mk":
			level.rw_mk_allowed = on_or_off;
		break;
		
		default:
			assert(false, "Weapon of type: " + attachment_abbreviation + " is not a valid attachment abbreviation." );
		break;
	}
}

button_held_think(which_button)
{
	self endon("disconnect");

	if (!IsDefined(self._holding_button))
	{
		self._holding_button = [];
	}
	
	self._holding_button[which_button] = false;
	
	time_started = 0;
	const use_time = 250; // GetDvarInt("g_useholdtime");

	while(1)
	{
		if(self._holding_button[which_button])
		{
			if(!self [[level._button_funcs[which_button]]]())
			{
				self._holding_button[which_button] = false;
			}
		}
		else
		{
			if(self [[level._button_funcs[which_button]]]())
			{
				if(time_started == 0)
				{
					time_started = GetTime();
				}

				if((GetTime() - time_started) > use_time)
				{
					self._holding_button[which_button] = true;
				}
			}
			else
			{
				if(time_started != 0)
				{
					time_started = 0;
				}
			}
		}

		wait(0.05);
	}
}

/@
"Name: use_button_held()"
"Summary: Returns true if the player is holding down their use button."
"Module: Player"
"Example: if(player use_button_held())"
"SPMP: SP"
@/

use_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._use_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_USE);
		self._use_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_USE];
}

/@
"Name: ads_button_held()"
"Summary: Returns true if the player is holding down their ADS button."
"Module: Player"
"Example: if(player ads_button_held())"
"SPMP: SP"
@/

ads_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._ads_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_ADS);
		self._ads_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_ADS];
}

/@
"Name: attack_button_held()"
"Summary: Returns true if the player is holding down their attack button."
"Module: Player"
"Example: if(player attack_button_held())"
"SPMP: SP"
@/

attack_button_held()
{
	init_button_wrappers();

	if(!IsDefined(self._attack_button_think_threaded))
	{
		self thread button_held_think(level.BUTTON_ATTACK);
		self._attack_button_think_threaded = true;
	}

	return self._holding_button[level.BUTTON_ATTACK];
}

// button pressed wrappers
use_button_pressed()
{
	Assert( IsPlayer( self ), "Must call use_button_pressed() on a player." );
	return ( self UseButtonPressed() );
}

ads_button_pressed()
{
	Assert( IsPlayer( self ), "Must call ads_button_pressed() on a player." );
	return ( self AdsButtonPressed() );
}

attack_button_pressed()
{
	Assert( IsPlayer( self ), "Must call attack_button_pressed() on a player." );
	return ( self AttackButtonPressed() );
}

/@
"Name: waittill_use_button_pressed()"
"Summary: Waits until the player is pressing their use button."
"Module: Player"
"Example: level.player waittill_use_button_pressed()"
"SPMP: SP"
@/

waittill_use_button_pressed()
{
	while ( !self use_button_pressed() )
	{
		wait .05;
	}
}

/@
"Name: waittill_attack_button_pressed()"
"Summary: Waits until the player is pressing their attack button."
"Module: Player"
"Example: level.player waittill_attack_button_pressed()"
"SPMP: SP"
@/

waittill_attack_button_pressed()
{
	while ( !self attack_button_pressed() )
	{
		wait .05;
	}
}

/@
"Name: waittill_ads_button_pressed()"
"Summary: Waits until the player is pressing their ads button."
"Module: Player"
"Example: level.player waittill_ads_button_pressed()"
"SPMP: SP"
@/

waittill_ads_button_pressed()
{
	while ( !self ads_button_pressed() )
	{
		wait .05;
	}
}

init_button_wrappers()
{
	if (!IsDefined(level._button_funcs))
	{
		level.BUTTON_USE	= 0;
		level.BUTTON_ADS	= 1;
		level.BUTTON_ATTACK	= 2;

		level._button_funcs[level.BUTTON_USE]		= ::use_button_pressed;
		level._button_funcs[level.BUTTON_ADS]		= ::ads_button_pressed;
		level._button_funcs[level.BUTTON_ATTACK]	= ::attack_button_pressed;
	}
}

/@
"Name: play_movie_on_surface_async(<movie_name>, is_looping, is_in_memory, start_on_notify, use_fullscreen_fade, notify_when_done, notify_offset)"
"Summary: play a bink movie in a surface in game such as a TV, projector screen, model, etc.."
"Module: Utility"
"MandatoryArg: <movie_name> : The name of the moive."
"OptionalArg: is_looping : is this a looping movie (default: false)"
"OptionalArg: is_in_memory : is this movie loaded, otherwise it will stream. (default: true)"
"OptionalArg: start_on_notify : level notify to wait for before playing."
"OptionalArg: notify_when_done : The notify this function will send when the video is done playing (on level)."
"OptionalArg: notify_offset : How far from the end of the video the notify will be sent."
"OptionalArg: seamless : Play 2 streamed movies back-to-back seamlessly (each gets half the read buffer)."
"Example: level thread play_movie_on_surface( "foo", true, false, "notify_foo_started", "notify_foo_done", 1 );"
"SPMP: singleplayer"
@/

play_movie_on_surface_async(movie_name, is_looping = false, is_in_memory = true, start_on_notify, notify_when_done, notify_offset = 0.3, seamless = false )
{
	if ( notify_offset < .3 )
	{
		notify_offset = .3;
	}

	cin_id = level load_movie_async( movie_name, is_looping, is_in_memory, IsDefined(start_on_notify), seamless );

	level thread play_movie_on_surface_thread( cin_id, movie_name, start_on_notify, notify_when_done, notify_offset );

	return cin_id;
}

play_movie_on_surface_thread( cin_id, movie_name, start_on_notify, notify_when_done, notify_offset )
{
	if (IsDefined(start_on_notify))
	{
		level waittill(start_on_notify);
	}

	while( IsCinematicPreloading( cin_id ) )
	{
		wait .05;
	}

	playsoundatposition("evt_"+movie_name+"_movie",(0,0,0));

	/#Println("pausing "+movie_name+": on surface");#/
	Pause3DCinematic( cin_id, false );

	waittill_movie_done( cin_id, notify_when_done, notify_offset );
}

play_movie_on_surface(movie_name, is_looping, is_in_memory, start_on_notify, notify_when_done, notify_offset)
{
	cin_id = play_movie_on_surface_async( movie_name, is_looping, is_in_memory, start_on_notify, notify_when_done, notify_offset );
	while( IsCinematicInProgress( cin_id ) )
	{
		wait .05;
	}
}

start_movie_scene()
{
	level notify("kill_scene_subs_thread");	// make sure only one scene is running before we kill the array.
	// clear out the scene subs array.
	level._scene_subs = [];
}

add_scene_line(scene_line, time, duration)
{
	if(!IsDefined(level._scene_subs))
	{
		level._scene_subs = [];
	}
	
	sl = SpawnStruct();
	sl.line = scene_line;
	sl.time = time;
	sl.duration = duration;
	
	for(i = 0; i < level._scene_subs.size; i ++)
	{
		if(time < level._scene_subs[i].time)
		{
			/#PrintLn("*** ERROR:  Cannot add an earlier line after a later one.  Times must always increase.");#/
			return;
		}
	}
	
	level._scene_subs[level._scene_subs.size] = sl;
}

sub_fade(alpha, duration)	// self == hud_elem
{
	self notify("kill_fade");
	self endon("kill_fade");	// only one fade running at a time, please.
	
	if(alpha == 1)	// fading in
	{
		self.alpha = 0;
	}

	self fadeOverTime( duration );
	self.alpha = alpha;
	wait( duration );
	
}

do_scene_sub(sub_string, duration)
{
	if(!GetLocalProfileInt("cg_subtitles"))
		return;
		
	if (!IsDefined(level.vo_hud))
	{
		level.vo_hud = NewHudElem();
		level.vo_hud.fontscale = 2;
		level.vo_hud.horzAlign = "center";
		level.vo_hud.vertAlign = "middle";
		level.vo_hud.alignX = "center";
		level.vo_hud.alignY = "middle";
		level.vo_hud.y = 180;
		level.vo_hud.sort = 0;
	}
	
	const fade_duration = 0.2;

	level.vo_hud thread sub_fade(1, fade_duration);

	old_scale = level.vo_hud.fontscale;

	level.vo_hud.fontscale = 1.5;

	old_sort = level.vo_hud.sort;

	level.vo_hud.sort = 1;


	level.vo_hud SetText(sub_string);

	wait (duration - fade_duration);
	
	level.vo_hud sub_fade(0, fade_duration); // Not threaded... Block.
	
	level.vo_hud SetText("");
	
	level.vo_hud.sort = old_sort;
	level.vo_hud.fontscale = old_scale;
}

playback_scene_subs()
{
	
	if(!IsDefined(level._scene_subs))
	{
		return;
	}
	
	level notify("kill_scene_subs_thread");
	level endon("kill_scene_subs_thread");
	
	scene_start = GetTime();
	
	for(i = 0; i < level._scene_subs.size; i ++)
	{
		level._scene_subs[i].time = scene_start + (level._scene_subs[i].time * 1000);
	}
	
	for(i = 0; i < level._scene_subs.size; i ++)
	{
		while(GetTime() < level._scene_subs[i].time)
		{
			wait(0.05);
		}
		
		do_scene_sub(level._scene_subs[i].line, level._scene_subs[i].duration);
	}
	
	level._scene_subs = undefined;
}

/@
"Name: play_movie(<movie_name>, is_looping, is_in_memory, start_on_notify, use_fullscreen_fade, notify_when_done, notify_offset)"
"Summary: play a bink movie."
"Module: Utility"
"MandatoryArg: <movie_name> : The name of the moive."
"OptionalArg: is_looping : is this a looping movie (default: false)"
"OptionalArg: is_in_memory : is this movie loaded, otherwise it will stream. (default: true)"
"OptionalArg: start_on_notify : level notify to wait for before playing."
"OptionalArg: use_fullscreen_trans : use fullscreen effect to transition in and out of video."
"OptionalArg: notify_when_done : The notify this function will send when the video is done playing (on level)."
"OptionalArg: notify_offset : How far from the end of the video the notify will be sent."
"OptionalArg: seamless : Play 2 streamed movies back-to-back seamlessly (each gets half the read buffer)."
"Example: level thread play_movie( "bar", false, false, "notify_bar_start", true, "notify_bar_done", 1 );"
"SPMP: singleplayer"
@/

play_movie_async(movie_name, is_looping, is_in_memory, start_on_notify, use_fullscreen_trans, notify_when_done, notify_offset, seamless)
{
	// TFLAME - 8/21/2010 - give these defaults for single use, non streamed
	if (!IsDefined(is_looping))
	{
		is_looping = false;
	}
	
	if (!IsDefined(is_in_memory))
	{
		is_in_memory = true;
	}
	
	if (!IsDefined(notify_offset) || notify_offset < .3)
	{
		notify_offset = .3;
	}

	if (!IsDefined(seamless))
	{
		seamless = false;
	}

	fullscreen_trans_in = "none";
	fullscreen_trans_out = "none";
	if (is_true(use_fullscreen_trans))
	{
		fullscreen_trans_in = "white";
		fullscreen_trans_out = "white";

		if (IsDefined(level.movie_trans_in))
		{
			fullscreen_trans_in = level.movie_trans_in;
		}

		if (IsDefined(level.movie_trans_out))
		{
			fullscreen_trans_out = level.movie_trans_out;
		}
	}
	
	cin_id = level load_movie_async( movie_name, is_looping, is_in_memory, IsDefined(start_on_notify), seamless );
	
	level thread play_movie_async_thread( cin_id, movie_name, start_on_notify, notify_when_done, notify_offset, fullscreen_trans_in, fullscreen_trans_out );

	return cin_id;
}

play_movie_async_thread( cin_id, movie_name, start_on_notify, notify_when_done, notify_offset, fullscreen_trans_in, fullscreen_trans_out )
{
	if (IsDefined(start_on_notify))
	{
		level waittill(start_on_notify);
	}

	level thread playback_scene_subs();
	level thread handle_movie_dvars( cin_id );

	vision_set = movie_fade_in(movie_name, fullscreen_trans_in);	//-- transition in

	hud = start_movie(cin_id, movie_name, fullscreen_trans_in);		//-- movie plays

	waittill_movie_done( cin_id, notify_when_done, notify_offset );

	//audio notify to activate default snapshot
	clientNotify ("pmo");
	
	//reset transitions to default
	level.movie_trans_in = undefined;
	level.movie_trans_out = undefined;

	level movie_fade_out(movie_name, vision_set, fullscreen_trans_out);	//-- transition out
}

play_movie(movie_name, is_looping, is_in_memory, start_on_notify, use_fullscreen_trans, notify_when_done, notify_offset)
{
	cin_id = play_movie_async(movie_name, is_looping, is_in_memory, start_on_notify, use_fullscreen_trans, notify_when_done, notify_offset);
	while( IsCinematicInProgress( cin_id ) )
	{
		wait .05;
	}
}

handle_movie_dvars(cin_id)
{
	players = GetPlayers();
	for (i=0;i<players.size;i++)
	{
		players[i]._hud_dvars = [];
		players[i]._hud_dvars["cl_scoreDraw"] = Int(GetDvar("cl_scoreDraw"));
		players[i]._hud_dvars["compass"] = Int(GetDvar("compass"));
		players[i]._hud_dvars["hud_showstance"] = Int(GetDvar("hud_showstance"));
		players[i]._hud_dvars["actionSlotsHide"] = Int(GetDvar("actionSlotsHide"));
		players[i]._hud_dvars["ammoCounterHide"] = Int(GetDvar("ammoCounterHide"));
		players[i]._hud_dvars["cg_cursorHints"] = Int(GetDvar("cg_cursorHints"));
		players[i]._hud_dvars["hud_showobjectives"] = Int(GetDvar("hud_showobjectives"));
		players[i]._hud_dvars["cg_drawFriendlyNames"] = Int(GetDvar("cg_drawfriendlynames"));

		players[i] SetClientDvars( "cl_scoreDraw",0,"compass",0,"hud_showstance",0,"actionSlotsHide",1,"ammoCounterHide",1,"cg_cursorHints",0, "hud_showobjectives", 0, "cg_drawfriendlynames", 0);
	}

	while( IsCinematicInProgress(cin_id) )
	{
		wait 0.05;
	}

	/#PrintLn("play_movie: resetting play movie dvars.");#/

	players = GetPlayers();
	for (i=0;i<players.size;i++)
	{
		keys = GetArrayKeys(players[i]._hud_dvars);

		players[i] SetClientDvars( keys[0],players[i]._hud_dvars[keys[0]],keys[1],players[i]._hud_dvars[keys[1]],keys[2],players[i]._hud_dvars[keys[2]],keys[3],players[i]._hud_dvars[keys[3]],keys[4],players[i]._hud_dvars[keys[4]],keys[5],players[i]._hud_dvars[keys[5]], keys[6], players[i]._hud_dvars[keys[6]], keys[7], players[i]._hud_dvars[keys[7]]);
	}
}

load_movie_async(movie_name, is_looping, is_in_memory, paused, seamless)
{
	cin_id = Start3DCinematic(movie_name, is_looping, is_in_memory, false/*paused*/, false/*synch*/, seamless);

	if (is_true(paused))
	{
		/#Println("pausing "+movie_name+": start notify defined");#/
		Pause3DCinematic( cin_id, true );
	}

	return cin_id;
}

start_movie(cin_id, movie_name, fullscreen_trans)
{
	level.fullscreen_hud_destroy_after_id = cin_id;

	while( IsCinematicPreloading( cin_id ) )
	{
		wait .05;
	}

	if ( !IsDefined(level.fullscreen_cin_hud) )
	{
		level.fullscreen_cin_hud = create_movie_hud( cin_id, fullscreen_trans );
	}

	PlaySoundAtPosition(movie_name+"_movie",(0,0,0));
	Pause3DCinematic( cin_id, false );
	
	return level.fullscreen_cin_hud;
}

create_movie_hud(cin_id, fullscreen_trans)
{
	movie_hud = NewHudElem();
	movie_hud.x = 0;
	movie_hud.y = 0;
	movie_hud.horzAlign  = "fullscreen";
	movie_hud.vertAlign  = "fullscreen";
	movie_hud.foreground = false; //Arcade Mode compatible
	movie_hud.sort = 0;
	movie_hud.alpha = 1;

	movie_hud SetShader("cinematic", 640, 480);

	movie_hud thread destroy_when_movie_is_stopped();

	return movie_hud;
}

destroy_when_movie_is_stopped()
{
	if (IsDefined(self))
	{
		while( IsCinematicInProgress(level.fullscreen_hud_destroy_after_id) )
		{
			wait 0.05;
		}
		/#println("destroy hud for movie id "+level.fullscreen_hud_destroy_after_id);#/
		self Destroy();
		level.fullscreen_hud_destroy_after_id = undefined;
	}
}

movie_fade_in(movie_name, fullscreen_trans)
{
	current_vision_set = "";

	if (fullscreen_trans != "none")
	{
		fade_hud = NewHudElem();

		PlaySoundAtPosition(movie_name+"_fade_in",(0,0,0));
		
		FADE_IN = .5;
		if (IsDefined(level.movie_fade_in_time))
		{
			FADE_IN = level.movie_fade_in_time;
		}

		switch (fullscreen_trans)
		{
		case "white":
			{
				current_vision_set = get_players()[0] GetVisionSetNaked();
				VisionSetNaked("int_frontend_char_trans", FADE_IN);
				break;
			}
		case "whitehud":
			{
				fade_hud.x = 0;
				fade_hud.y = 0;
				fade_hud.horzAlign  = "fullscreen";
				fade_hud.vertAlign  = "fullscreen";
				fade_hud.foreground = false; //Arcade Mode compatible
				fade_hud.sort = 0;
				fade_hud.alpha = 0;
				fade_hud SetShader("white", 640, 480);
				fade_hud FadeOverTime(FADE_IN);
				fade_hud.alpha = 1;

				break;
			}
		case "black":
			{
				fade_hud.x = 0;
				fade_hud.y = 0;
				fade_hud.horzAlign  = "fullscreen";
				fade_hud.vertAlign  = "fullscreen";
				fade_hud.foreground = false; //Arcade Mode compatible
				fade_hud.sort = 0;
				fade_hud.alpha = 0;
				fade_hud SetShader("black", 640, 480);
				fade_hud FadeOverTime(FADE_IN);
				fade_hud.alpha = 1;

				break;
			}
		}

		wait FADE_IN;
		fade_hud Destroy();
	}

	return current_vision_set;
}

movie_fade_out(movie_name, vision_set, fullscreen_trans)
{
	if (fullscreen_trans != "none")
	{
		fade_hud = NewHudElem();

		PlaySoundAtPosition(movie_name+"_fade_out",(0,0,0));

		FADE_OUT = .5;
		if (IsDefined(level.movie_fade_out_time))
		{
			FADE_OUT = level.movie_fade_out_time;
		}

		switch (fullscreen_trans)
		{
		case "white":
			{
				current_vision_set = get_players()[0] GetVisionSetNaked();
				if (current_vision_set != "int_frontend_char_trans")
				{
					vision_set = current_vision_set;
				}

				VisionSetNaked("int_frontend_char_trans", 0);
				wait .1;
				VisionSetNaked(vision_set, FADE_OUT);

				break;
			}
		case "whitehud":
			{
				fade_hud.x = 0;
				fade_hud.y = 0;
				fade_hud.horzAlign  = "fullscreen";
				fade_hud.vertAlign  = "fullscreen";
				fade_hud.foreground = false; //Arcade Mode compatible
				fade_hud.sort = 0;
				fade_hud.alpha = 1;
				fade_hud SetShader("white", 640, 480);
				fade_hud FadeOverTime(FADE_OUT);
				fade_hud.alpha = 0;

				break;
			}
		case "black":
			{
				fade_hud.x = 0;
				fade_hud.y = 0;
				fade_hud.horzAlign  = "fullscreen";
				fade_hud.vertAlign  = "fullscreen";
				fade_hud.foreground = false; //Arcade Mode compatible
				fade_hud.sort = 0;
				fade_hud.alpha = 1;
				fade_hud SetShader("black", 640, 480);
				fade_hud FadeOverTime(FADE_OUT);
				fade_hud.alpha = 0;
				
				current_vision_set = get_players()[0] GetVisionSetNaked();
				if (current_vision_set == "int_frontend_char_trans")
				{
					VisionSetNaked(vision_set, 0);
				}
				break;
			}
		}
		
		wait FADE_OUT;
		fade_hud Destroy();
	}
}

// wait until a cinematic movie is done.  notify [notify_when_done] when we're within [notify_offset] of the end of the movie
// WILL NOT WORK IN COOP MODES - DONT USE IT
waittill_movie_done(cin_id, notify_when_done, notify_offset)
{
	if( IsDefined(notify_when_done) )
	{
		while( IsCinematicPreloading( cin_id ) )
		{
			wait .05;
		}
		while( GetCinematicTimeRemaining( cin_id ) > notify_offset )
		{
			wait .05;
		}
		level notify(notify_when_done);
	}
	while( IsCinematicInProgress( cin_id ) )
	{
		wait .05;
	}
}

/@
"Name: allow_divetoprone()"
"Summary: Sets the dtp dvar to enable or disable dive to prone"
"Module: Level"
"Example: allow_divetoprone( false );"
"SPMP: SP"
@/
allow_divetoprone( allowed )
{
	if( !IsDefined( allowed ) )
	{
		return;
	}

	SetDvar( "dtp", allowed );
}

/@
"Name: waittill_player_shoots()"
"Summary: Waits for the player to fire a gun. Returns the weapon name.
"Module: Player"
"OptionalArg: <weapon_type> : Specify silencer preference to wait for: "silenced", "not_silenced", or "any". Deafaults to "any".
"OptionalArg: <ender> : Player notify to end the function.
"Example: player waittill_player_shoots("not_silenced", "stealth_over");
"SPMP: SP"
@/

waittill_player_shoots(weapon_type, ender)
{
	//silenced, not_silenced, any
	if(IsDefined(ender))
	{
		self endon (ender);
	}
	
	//if no weapon specified, then detect "any"
	if(!IsDefined (weapon_type))
	{
		weapon_type = "any";
	}
	
	while(1)
	{
		//wait for player to fire
		self waittill ("weapon_fired");
		
		//what gun does the player have
		gun = self GetCurrentWeapon();
		
		//return based on specified weapon
		if(weapon_type == "any") //all weapons are valid, return weapon
		{
			return gun;
		}
		else if(weapon_type =="silenced")//only looking for silenced shots
		{
			if( IsSubStr(gun, "silencer"))//if player has a silenced weapon, return
			{
				return gun;
			}
		}
		else //only looking for "not_silenced" shots
		{
			if( !IsSubStr(gun, "silencer"))//if weapon is not silenced, return
			{
				return gun;
			}
		}
		continue;//weapon fired is not the kind we want to detect, keep waiting
	}
	
}

/@
"Name: idle_at_cover( true/false )"
"Summary: If set to true, AI will only idle at cover node. Used with scripted animations starting at cover nodes.
"Module: AI"
"Example: self idle_at_cover( true );
"SPMP: SP"
@/

idle_at_cover( toggle )
{
	assert( IsAI(self), "idle_at_cover should only be called on AI entity." );
	assert( IsDefined(toggle), "Incorrect use of idle_at_cover");

	if ( toggle == true )
	{
		self.a.coverIdleOnly = true;
	}
	else if ( toggle == false )
	{
		self.a.coverIdleOnly = false;
	}
	else
	{
		AssertMsg("Incorrect use of idle_at_cover");
	}
}

/@
"Name: bloody_death( [str_body_part_tag], [n_delay_max] )"
"Summary: Kill an AI in a bloody manner."
"CallOn: AI"
"OptionalArg: <str_body_part_tag> Pass through "head", "body", or "neck" to play the blood effect on that tag. If not set, defaults into randomly selecting two body parts."
"OptionalArg: <n_delay_max> The maximum delay after which you want the AI to die"
"Example: ai_guy thread bloody_death( "head", 3.5 ); You must setup the level._effect['flesh_hit'] in your level_fx.gsc"
"SPMP: singleplayer"
@/
bloody_death( str_body_part_tag, n_delay_max )
{
	self endon( "death" );

	assert( IsDefined( level._effect[ "flesh_hit" ] ), "Define level._effect['flesh_hit'] in " + level.script + "_fx.gsc" );

	if ( !IsDefined( self ) )
	{
		return;
	}

	if ( !self is_alive_sentient() )
	{
		return;
	}

	if ( IsDefined( self.bloody_death ) && ( self.bloody_death ) )
	{
		return;
	}

	self.bloody_death = true;

	if ( IsDefined( n_delay_max ) )
	{
		wait RandomFloat( n_delay_max );
	}

	if( !IsDefined( str_body_part_tag ) )
	{
		a_tags = [];
		a_tags[ 0 ] = "j_hip_le";
		a_tags[ 1 ] = "j_hip_ri";
		a_tags[ 2 ] = "j_head";
		a_tags[ 3 ] = "j_spine4";
		a_tags[ 4 ] = "j_elbow_le";
		a_tags[ 5 ] = "j_elbow_ri";
		a_tags[ 6 ] = "j_clavicle_le";
		a_tags[ 7 ] = "j_clavicle_ri";
	}
	else
	{
		a_tags = [];
		
		switch ( str_body_part_tag )
		{
			case "head":
				a_tags[ 0 ] = "j_head";
				break;
			case "body":
				a_tags[ 0 ] = "j_spine4";
				break;
			case "neck":
				a_tags[ 0 ] = "j_neck";
				break;
			default:
				AssertMsg( str_body_part_tag + " is not a valid tag for bloody_death! Valid types are head, body or neck" );
				a_tags[ 0 ] = "j_head";
				break;
		}
	}
	
	const n_blood_hits = 2;
	const n_delay = 0.1;
	
	for ( i = 0; i < n_blood_hits; i++ )
	{
		if ( is_mature() )
		{
			n_wait_min = i * n_delay;  // 0 and n_delay
			n_wait_max = ( i + 1 ) * n_delay; // n_delay and 2*n_delay
			self delay_thread( RandomFloatRange( n_wait_min, n_wait_max ), ::bloody_death_fx, random( a_tags ), level._effect[ "flesh_hit" ] );
		}
	}
	
	wait n_delay * n_blood_hits;  // make sure all blood impacts have fired off

	if ( self is_alive_sentient() )
	{
		self DoDamage( self.health + 150, self.origin );
	}
}



/@
"Name: bloody_death_fx( <str_tag>, <str_fx_name> )"
"Summary: Used in bloody_death, plays a blood effect given tag. Does not kill an AI."
"CallOn: AI"
"MandatoryArg: <str_tag> The tag on which to play an effect."
"OptionalArg: <str_fx_name> The name of a specific effect you would like played on the tag. Should be in form level._effect[ <str_fx_name> ]"
"Example: ai_guy bloody_death_fx( "j_spine4" );"
"SPMP: singleplayer"
@/
bloody_death_fx( str_tag, str_fx_name )
{
	assert( IsDefined( str_tag ), "str_tag is a required parameter for bloody_death_fx" );
	
	if ( !IsDefined( str_fx_name ) )
	{
		str_fx_name = level._effect[ "flesh_hit" ];
	}

	PlayFxOnTag( str_fx_name, self, str_tag );
}



clientnotify_delay(msg, time)
{
	if (isdefined(time))
	{
		wait time;
	}
	clientnotify(msg);
}



/@
"Name: fake_physics_launch( <v_target_pos>, [n_force], [n_rotate_angle], [str_rotate_type] )"
"Summary: Launches an entity from it's current origin to a target position with some force with optional rotation. Uses bg_gravity dvar."
"Module: Entity"
"CallOn: Entity"
"MandatoryArg: <v_target_pos> The location the launched entity should land"
"OptionalArg: <n_force> Force to be applied to the object. Defaults to 1000."
"OptionalArg: <n_rotate_angle> Degrees that the object will rotate over the course of movement. Defaults to undefined."
"OptionalArg: <str_rotate_type> Axis of rotation the object will use. Defaults to pitch. Options are: "roll", "pitch", "yaw""
"Example: e_molotov fake_physicslaunch( s_goal.origin, 1000, 720, "pitch" );"
"SPMP: singleplayer"
@/
fake_physics_launch( v_target_pos, n_force, n_rotate_angle, str_rotate_type )
{
	assert( IsDefined( v_target_pos ), "v_target_pos is a required parameter for fake_physics_launch" );

	if ( !IsDefined( n_force ) )
	{
		n_force = 1000;
	}
	
	// launch position is object origin
	v_start_pos = self.origin;
	
	// bg_gravity dvar is normally positive and we need downward motion
	n_gravity = Abs( GetDvarInt( "bg_gravity" ) ) * -1;

	n_dist = Distance( v_start_pos, v_target_pos );
	
	n_time = n_dist / n_force;
	
	v_delta = v_target_pos - v_start_pos;
	
	// calculate drop based on gravity: (1/2)*G*(t^2)
	n_drop_from_gravity = 0.5 * n_gravity *( n_time * n_time );
	
	// scale X and Y based on time, scale Z based on time and gravity drop
	v_launch = ( ( v_delta[0] / n_time ), ( v_delta[1] / n_time ), ( v_delta[2] - n_drop_from_gravity ) / n_time );

	self MoveGravity( v_launch, n_time );
	
	// optional rotation in flight
	if ( IsDefined( n_rotate_angle ) )
	{
		if ( !IsDefined( str_rotate_type ) )
		{
			str_rotate_type = "pitch";
		}
		
		switch ( str_rotate_type )
		{
			case "roll":
				self RotateRoll( n_rotate_angle, n_time );
				break;
				
			case "pitch":
				self RotatePitch( n_rotate_angle, n_time );
				break;
				
			case "yaw":
				self RotateYaw( n_rotate_angle, n_time );
				break;
				
			default:
				AssertMsg( str_rotate_type + " is not a valid rotation type for fake_physics_launch" );
				break;
		}
	}
	
	return n_time;
}


/@
"Name: explosion_launch( <v_point>, <n_radius>, [n_force_min], [n_force_max], [n_launch_angle_min], [n_launch_angle_max], [b_use_drones] )"
"Summary: Gets AI and drones near a point within a radius, then launches them in physics. Note that code sets max active ragdoll bodies."
"Module: Entity"
"CallOn: level"
"MandatoryArg: <v_point> The origin of the launch radius"
"MandatoryArg: <n_radius> The maximum distance away from the origin that will still launch entities"
"OptionalArg: <n_force_min> The minimum amount of force with which to launch an entity. Defaults to 50."
"OptionalArg: <n_force_max> The maximum amount of force with which to launch an entity. Defaults to 150."
"OptionalArg: <n_launch_angle_min> The minimum angle entities can be launched from. Defaults to 25."
"OptionalArg: <n_launch_angle_max> The maximum angle entities can be launched from. Defaults to 45."
"OptionalArg: <b_use_drones> Search for drones as well as AI. Defaults to false."
"Example: explosion_launch( s_explosion_point.origin, 256, 50, 150, 25, 40, true );"
"SPMP: singleplayer"
@/
explosion_launch( v_point, n_radius, n_force_min, n_force_max, n_launch_angle_min, n_launch_angle_max, b_use_drones )
{
	assert( IsDefined( v_point ), "v_point is a required argument for explosion_launch" );
	assert( IsDefined( n_radius ), "n_radius is a required argument for explosion_launch" );
	
	if ( !IsDefined( n_force_min ) )
	{
		n_force_min = 50;
	}
	
	if ( !IsDefined( n_force_max ) )
	{
		n_force_max = 150;
	}
	
	if ( !IsDefined( n_launch_angle_min ) )
	{
		n_launch_angle_min = 25;
	}
	
	if ( !IsDefined( n_launch_angle_max ) )
	{
		n_launch_angle_max = 45;
	}
	
	if ( !IsDefined( b_use_drones ) )
	{
		b_use_drones = false;
	}
	
	// get all AI in the level, including dogs and civilians, then combine them into a single array
	a_guys = GetAISpeciesArray( "all", "all" );
	
	// if we want to use drones, add them to the array as well
	if ( b_use_drones )
	{
		a_drones =  GetEntArray( "drone", "targetname" );
		
		a_guys = ArrayCombine( a_drones, a_guys, true, false );
	}
	
	// use radius squared for performance
	n_radius_squared = n_radius * n_radius;
	
	for ( i = 0; i < a_guys.size; i++ )
	{
		if ( !IsDefined( a_guys[ i ] ) )  // error check since this handles potentially large groups
		{
			continue;
		}
		
		// drones may be dead but can still wind up in the array; exclude them
		if ( a_guys[ i ].health < 0 )
		{
			continue;
		}
		
		// don't launch hero characters
		if ( a_guys[ i ] is_hero() )
		{
			continue;
		}
		
		n_dist_squared = DistanceSquared( a_guys[ i ].origin, v_point );
		
		if ( ( n_dist_squared < n_radius_squared ) )
		{
			v_launch_direction = a_guys[ i ].origin - v_point;
		
			v_launch_direction = VectorNormalize( v_launch_direction );
			
			v_normalized = ( v_launch_direction[ 0 ], v_launch_direction[ 1 ], 0 );
			
			n_scale = linear_map( n_dist_squared, 0, n_radius_squared, n_force_min, n_force_max );
			
			n_angle = linear_map( n_dist_squared, 0, n_radius_squared, n_launch_angle_min, n_launch_angle_max );
			
			v_normalized *= n_scale;
			
			// determine final launch angle from X and Y direction of scaled vector, but use custom Z for launch angle
			v_final = ( v_normalized[ 0 ], v_normalized[ 1 ], n_angle );
			
			a_guys[ i ] anim_stopanimscripted();
			a_guys[ i ].force_gib = true;

			if ( IsAI( a_guys[ i ] ) )
			{
				a_guys[ i ] thread _launch_ai( v_final );
			}
			else
			{
				a_guys[ i ] thread _launch_drone( v_final );
			}
		}
	}
}


/*=============================================================================
SELF: AI
PURPOSE: ragdoll_death waits for 2 frames, so the death and launch functionality
	has been broken up to make launches look as close to simultaneous as possible
RETURNS: nothing
CREATOR: TravisJ 3/22/2011
=============================================================================*/
_launch_ai( v_physics_launch )
{
	self ragdoll_death();
	self LaunchRagdoll( v_physics_launch );
}


/*=============================================================================
SELF: drone
PURPOSE: allow _drones scripts to handle drone deaths, but use ragdoll launch if
	drone occupies a ragdoll slot
RETURNS: nothing
CREATOR: TravisJ 3/18/2011
=============================================================================*/
_launch_drone( v_physics_launch )
{
	self DoDamage( self.health + 100, v_physics_launch );
	
	wait_network_frame();  // _drones will perform ragdoll death if slots available within 1 server frame
	
	if ( IsDefined( self ) && IsDefined( self.ragdoll_start_time ) )  // _drones adds this parameter only if drone is added to ragdoll bucket
	{
		self LaunchRagdoll( v_physics_launch );
	}
}

/@
"Name: rumble_loop( <n_count>, [n_delay], [str_rumble_type] )"
"Summary: Plays a rumble on the player a various number of times with a delay between each one"
"Module: Entity"
"CallOn: player"
"MandatoryArg: <n_count> Number of times rumble will be played. Pass a negative value for continuous loop"
"OptionalArg: <n_delay> Wait time between each rumble. Defaults to 0.5"
"OptionalArg: <str_rumble_type> Rumble to be played. Remember to precache special rumbles before use. Defaults to 'damage_heavy'"
"Example: player rumble_loop( 5, 1, "heartbeat" )"
"SPMP: singleplayer"
@/
rumble_loop( n_count, n_delay, str_rumble_type )
{
	self notify( "_rumble_loop_stop" );  // only one loop at a time
	self endon( "_rumble_loop_stop" );	
	
	Assert( IsDefined( n_count ), "n_delay missing from rumble_loop" );
	Assert( IsPlayer( self ), "rumble_loop can only be used on players" );
	
	if ( IsDefined( n_delay ) && ( n_delay <= 0 ) )
	{
		AssertMsg( "n_delay cannot be a zero or negative value in rumble_loop" );
	}	
	
	if ( !IsDefined( n_delay ) )
	{
		n_delay = 0.5;
	}
	
	if ( !IsDefined( str_rumble_type ) )
	{
		str_rumble_type = "damage_heavy";  // precached in _load
	}
	
	b_loop_forever = ( n_count < 0 );
	n_times_played = 0;
	
	while ( ( n_times_played < n_count ) || b_loop_forever )
	{
		self PlayRumbleOnEntity( str_rumble_type );
		n_times_played++;
		wait n_delay;
	}
}

/@
"Name: rumble_loop_stop()"
"Summary: Stops a rumble loop"
"Module: Entity"
"CallOn: player"
"Example: level.player rumble_loop_stop()"
"SPMP: singleplayer"
@/
rumble_loop_stop()
{
	self notify( "_rumble_loop_stop" );
}

/@
"Name: is_looking_at( <ent_or_org>, [n_dot_range], [do_trace] )"
"Summary: Checks to see if an entity is facing a point within a specified dot then returns true or false. Can use bullet trace."
"Module: Entity"
"CallOn: Entity"
"MandatoryArg: <ent_or_org> entity or origin to check against"
"OptionalArg: [n_dot_range] custom dot range. Defaults to 0.8"
"OptionalArg: [do_trace] does a bullet trace along with checking the dot. Defaults to false"
"Example: is_facing_woods = player is_facing( level.woods.origin );"
"SPMP: singleplayer"
@/
is_looking_at( ent_or_org, n_dot_range = 0.67, do_trace = false, v_offset )
{
	Assert( IsDefined( ent_or_org ), "ent_or_org is required parameter for is_facing function" );

	v_point = ( IsVec( ent_or_org ) ? ent_or_org : ent_or_org.origin );
	
	if ( IsVec( v_offset ) )
	{
		v_point += v_offset;
	}
	
	b_can_see = false;
	b_use_tag_eye = false;
	
	if ( IsPlayer( self ) || IsAI( self ) )
	{
		b_use_tag_eye = true;
	}
	
	n_dot = self get_dot_direction( v_point, false, true, "forward", b_use_tag_eye );
	
	if ( n_dot > n_dot_range )
	{
		if ( do_trace )
		{
			v_eye = self get_eye();
			b_can_see = SightTracePassed( v_eye, v_point, false, ent_or_org );
		}
		else
		{
			b_can_see = true;
		}
	}
	
	return b_can_see;
}

/@
"Name: is_behind( <v_point>, [n_dot_range] )"
"Summary: checks to see if a point is behind an entity."
"Module: Math"
"CallOn: Entity"
"MandatoryArg: <v_point> point to check against"
"OptionalArg: <n_dot_range> custom dot range. Defaults to 0."
"Example: is_player_behind_woods = woods is_behind( level.player.origin );"
"SPMP: singleplayer"
@/
is_behind( v_point, n_dot_range )
{
	assert( IsDefined( v_point ), "v_point is a required parameter for is_behind" );
	
	if ( !IsDefined( n_dot_range ) )
	{
		n_dot_range = 0;
	}
	
	b_is_behind = false;
	
	n_dot = self get_dot_forward( v_point );
	
	if ( n_dot < n_dot_range )
	{
		b_is_behind = true;
	}

	return b_is_behind;
}

/@
"Name: dot_to_fov( <n_dot> )"
"Summary: Converts a dot product value to its corresponding FOV angle. Returns FOV between 0 and 360 degrees."
"Module: Math"
"CallOn: self not used"
"MandatoryArg: <n_dot> Dot product to be converted to FOV angle"
"Example: n_fov_angle = dot_to_fov( 0.7 );"
"SPMP: singleplayer"
@/
dot_to_fov( n_dot )
{
	assert( IsDefined( n_dot ), "n_dot is a required parameter for dot_to_fov" );
	
	n_fov = ACos( n_dot ) * 2;
	
	return n_fov;
}

/@
"Name: fov_to_dot( <n_fov> )"
"Summary: Converts a FOV value to a dot product."
"Module: Math"
"CallOn: self not used"
"MandatoryArg: <n_fov> Field of view angle between 0 and 360 degrees."
"Example: n_dot = fov_to_dot( 52 );"
"SPMP: singleplayer"
@/
fov_to_dot( n_fov )
{
	assert( IsDefined( n_fov ), "n_fov is required for fov_to_dot" );
	
	n_dot = Cos( n_fov * 0.5 );
	
	return n_dot;
}


/@
"Name: get_ent( <str_value>, [str_key], [b_assert_if_missing] )"
"Summary: Gets an entity with a specific key value pair. Performs error checking for returning multiple ents and undefined cases."
"Module: Entity"
"CallOn: unused"
"MandatoryArg: <str_value> string name to use when attempting to referencing an entity"
"OptionalArg: <str_key> string key to use when attempting to reference an entity. Defaults to "targetname""
"OptionalArg: <b_assert_if_missing> function will assert if no single entity is found with the matching key value pair. Defaults to false."
"Example: woods = get_ent( "woods_ai", "targetname", true );"
"SPMP: singleplayer"
@/
get_ent( str_value, str_key, b_assert_if_missing )
{
	// user should know a get_ent call is asserting, not get_ent_array, if str_value is missing
	assert( IsDefined( str_value ), "str_value is a required parameter for get_ent" );
	
	if ( !IsDefined( b_assert_if_missing ) )
	{
		b_assert_if_missing = false;
	}
	
	a_found = get_ent_array( str_value, str_key );
	
	if ( b_assert_if_missing && a_found.size == 0 )
	{
		AssertMsg( "get_ent found no entities with " + str_key + " " + str_value + "!" );
	}
	
	Assert( a_found.size <= 1, "get_ent returned more than one entity with " + string( str_key ) + " " + str_value + "!" );
	
	return a_found[ 0 ];
}

/@
"Name: get_ent_array( <str_value>, [str_key], [b_assert_if_missing] )"
"Summary: Gets an array of ents"
"Module: Entity"
"CallOn: unused"
"MandatoryArg: <str_value> string name to use when attempting to referencing an entity"
"OptionalArg: <str_key> string key to use when attempting to reference an entity. Defaults to "targetname""
"OptionalArg: <b_assert_if_missing> function will assert if no entities are found with the matching key value pair. Defaults to false."
"Example: a_guys = get_ent_array( "test_guys_ai", "targetname", true );"
"SPMP: singleplayer"
@/
get_ent_array( str_value, str_key = "targetname", b_assert_if_missing )
{
	assert( IsDefined( str_value ), "str_value is a required parameter for get_ent_array" );

	if ( IsDefined( str_key ) && ( str_key != "targetname" && str_key != "script_noteworthy" && str_key != "classname" ) )
	{
		AssertMsg( str_key + " is not a key supported by get_ent_array!" );
	}
		
	if ( !IsDefined( b_assert_if_missing ) )
	{
		b_assert_if_missing = false;
	}
	
	a_ents = GetEntArray( str_value, str_key );
		
	if ( ( a_ents.size == 0 ) && b_assert_if_missing )
	{
		AssertMsg( "get_ent_array found no ents with " + str_key + " " + str_value + "!" );
	}
	
	return a_ents;
}

/@
"Name: get_struct( <str_value>, [str_key], [b_assert_if_missing] )"
"Summary: finds and returns a struct with specified key value pair. Optionally asserts if none are found"
"Module: utility"
"CallOn: level"
"MandatoryArg: <str_value> string value of the struct to be found"
"OptionalArg: <str_key> string key of the struct to be found. Defaults to "targetname""
"OptionalArg: <b_assert_if_missing> If no structs with specified KVP are found, function will assert. Defaults to false."
"Example: s_launch_point = get_struct( "launch_point", "targetname", true )"
"SPMP: singleplayer"
@/
get_struct( str_value, str_key, b_assert_if_missing )
{
	// scripter should know if this function is asserting or get_struct_array
	Assert( IsDefined( str_value ), "str_value is a required parameter for get_struct" );
	
	if ( !IsDefined( str_key ) )
	{
		str_key = "targetname";
	}
	
	if ( !IsDefined( b_assert_if_missing ) )
	{
		b_assert_if_missing = false;
	}
	
	a_found = get_struct_array( str_value, str_key );
	
	if ( b_assert_if_missing && ( a_found.size == 0 ) )
	{
		AssertMsg( "get_struct found no struct with " + str_key + " " + str_value + "!" );
	}
	
	Assert( a_found.size <= 1, "get_struct found " + a_found.size + " structs with " + str_key + " " + str_value + "!" );
	
	return a_found[ 0 ];
}

/@
"Name: get_struct_array( <str_value>, <str_key>, <b_assert_if_missing> )"
"Summary: finds and returns an array of structs with specified key value pairs. Optionally asserts if none are found."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_value> string value of structs to be found "
"OptionalArg: <str_key> string key of structs to be found. Defaults to "targetname""
"OptionalArg: <b_assert_if_missing> If no structs are found with specified KVP, function will assert. Defaults to false."
"Example: a_structs = get_struct_array( "flight_points", "targetname", true );"
"SPMP: singleplayer"
@/
get_struct_array( str_value, str_key = "targetname", b_assert_if_missing = false )
{
	Assert( IsDefined( str_value ), "str_value is required parameter for get_struct_array" );
	
	a_found = getstructarray( str_value, str_key );
	
	if ( ( a_found.size == 0 ) && ( b_assert_if_missing ) )
	{
		AssertMsg( "get_struct_array found no structs with " + str_key + " " + str_value + "!" );
	}
	
	return a_found;
}

/@
"Name: add_flag_function( <str_flag_name>, <func_after_flag>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Waits for a flag, then runs a function with up to five input parameters on self"
"Module: Utility"
"CallOn: Anything you want to run a function on; AI, vehicles, etc."
"MandatoryArg: <str_flag_name> Name of a flag. Note that if it doesn't exist, it will be initialized in this function"
"MandatoryArg: <func_after_flag> Function pointer to the function that will be run after the flag is set"
"OptionalArg: <param_1> Input parameter to function"
"OptionalArg: <param_2> Input parameter to function"
"OptionalArg: <param_3> Input parameter to function"
"OptionalArg: <param_4> Input parameter to function"
"OptionalArg: <param_5> Input parameter to function"
"Example: woods add_flag_function( "tank_battle_start", ::nag_vo_until_flag, a_nag_lines, "tank_battle_end", 5, true, true );"
"SPMP: "
@/
add_flag_function( str_flag_name, func_after_flag, param_1, param_2, param_3, param_4, param_5 )
{
	assert( IsDefined( str_flag_name ), "str_flag_name is a required parameter for add_flag_function" );
	assert( IsDefined( func_after_flag ), "func_after_flag is a required parameter for add_flag_function" );
	
	// thread so script doesn't hang when this is used
	self thread _flag_wait_then_func( str_flag_name, func_after_flag, param_1, param_2, param_3, param_4, param_5 );
}

_flag_wait_then_func( str_flag_name, func_after_flag, param_1, param_2, param_3, param_4, param_5 )
{
	if ( !IsDefined( level.flag[ str_flag_name ] ) )
	{
		flag_init( str_flag_name );
	}
	
	flag_wait( str_flag_name );
	
	single_func( self, func_after_flag, param_1, param_2, param_3, param_4, param_5 );
}


/@
"Name: is_point_inside_volume( <v_point>, <e_volume> )"
"Summary: checks to see if a point is within a trigger or info volume"
"Module: Utility"
"CallOn: unused"
"MandatoryArg: <v_point> point to check"
"MandatoryArg: <e_volume> volume ent to check"
"Example: is_within_volume = is_point_within_volume( v_to_check, e_volume_to_check )"
"SPMP: singleplayer"
@/
is_point_inside_volume( v_point, e_volume )
{
	assert( IsDefined( v_point ), "v_point is missing in is_point_inside_volume" );
	assert( IsDefined( e_volume ), "e_volume is missing in is_point_inside_volume" );
	
	e_origin = Spawn( "script_origin", v_point );
	
	is_inside_volume = e_origin IsTouching( e_volume );
	
	e_origin Delete();
	
	return is_inside_volume;
}


/@
"Name: add_spawn_function_group( <str_value>, <str_key>, <func_spawn>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Gets all spawners with specified KVP, then adds spawn function to entire group with up to 5 input arguments."
"Module: Entity"
"CallOn: self unused"
"MandatoryArg: <str_value> Name of the spawners to find"
"MandatoryArg: <str_key> Key of the spawner to find; "targetname", "script_noteworthy", etc"
"MandatoryArg: <func_spawn> Spawn function to add to the spawners"
"OptionalArg: <param_1> Input parameter to function"
"OptionalArg: <param_2> Input parameter to function"
"OptionalArg: <param_3> Input parameter to function"
"OptionalArg: <param_4> Input parameter to function"
"OptionalArg: <param_5> Input parameter to function"
"Example: add_spawn_function_group( "physics_launch_guys", "targetname", ::set_ignoreall, true );"
"SPMP: singleplayer"
@/
add_spawn_function_group( str_value, str_key = "targetname", func_spawn, param_1, param_2, param_3, param_4, param_5 )
{
	Assert( IsDefined( str_value ), "str_value is a required parameter for add_spawn_function_group" );
	Assert( IsDefined( func_spawn ), "func_spawn is a required parameter for add_spawn_function_group" );
	
	a_spawners = [];
	
	if( str_key == "targetname" || str_key == "script_noteworthy" || str_key == "classname" )
	{
		a_spawners = GetSpawnerArray( str_value, str_key );
	}
	else if( str_key == "script_string" )
	{
		a_all_spawners = GetSpawnerArray();
		
		foreach ( sp in a_all_spawners )
		{
			if ( IS_EQUAL( sp.script_string, str_value ) )
			{
				ARRAY_ADD( a_spawners, sp ); break;			
			}
		}
	}
	else
	{
		AssertMsg( "add_spawn_function_group doesn't support " + str_key + "." );
	}
	
	array_func( a_spawners, ::add_spawn_function, func_spawn, param_1, param_2, param_3, param_4, param_5 );
}

/@
"Name: add_spawn_function_ai_group( <str_aigroup>, <func_spawn>, [param_1], [param_2], [param_3], [param_4], [param_5] )"
"Summary: Gets all spawners with specified ai group, then adds spawn function to entire group with up to 5 input arguments."
"Module: Entity"
"CallOn: self unused"
"MandatoryArg: <str_aigroup> ai group to add the spawn function to"
"MandatoryArg: <func_spawn> Spawn function to add to the spawners"
"OptionalArg: <param_1> Input parameter to function"
"OptionalArg: <param_2> Input parameter to function"
"OptionalArg: <param_3> Input parameter to function"
"OptionalArg: <param_4> Input parameter to function"
"OptionalArg: <param_5> Input parameter to function"
"Example: add_spawn_function_ai_group( "physics_launch_guys", ::set_ignoreall, true );"
"SPMP: singleplayer"
@/
add_spawn_function_ai_group( str_aigroup, func_spawn, param_1, param_2, param_3, param_4, param_5 )
{
	assert( IsDefined( str_aigroup ), "str_aigroup is a required parameter for add_spawn_function_ai_group" );
	assert( IsDefined( func_spawn ), "func_spawn is a required parameter for add_spawn_function_ai_group" );
	
	a_spawners = GetSpawnerArray();
	foreach ( e_spawner in a_spawners )
	{
		if ( IsDefined( e_spawner.script_aigroup ) && ( e_spawner.script_aigroup == str_aigroup ) )
		{
			e_spawner add_spawn_function( func_spawn, param_1, param_2, param_3, param_4, param_5 );
		}
	}
}

/@
"Name: add_trigger_function( <str_trig_targetname>, <func>, [param_1], [param_2], [param_3], [param_4], [param_5], [param_6] )"
"Summary: Runs a function when a trigger is hit."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_trig_targetname> : targetname of the trigger"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [param_1] : parameter 1 to pass to the func"
"OptionalArg: [param_2] : parameter 2 to pass to the func"
"OptionalArg: [param_3] : parameter 3 to pass to the func"
"OptionalArg: [param_4] : parameter 4 to pass to the func"
"OptionalArg: [param_5] : parameter 5 to pass to the func"
"OptionalArg: [param_6] : parameter 6 to pass to the func"
"Example: add_trigger_function( "my_trigger", ::my_trigger_function );"
"SPMP: SP"
@/
add_trigger_function( trigger, func, param_1, param_2, param_3, param_4, param_5, param_6 )
{
	level thread _do_trigger_function( trigger, func, param_1, param_2, param_3, param_4, param_5, param_6 );
}

_do_trigger_function( trigger, func, param_1, param_2, param_3, param_4, param_5, param_6 )
{
	if ( IsString( trigger ) )
	{
		trigger_wait( trigger );
	}
	else
	{
		trigger endon( "death" );
		trigger trigger_wait();

	}	
	
	single_thread( level, func, param_1, param_2, param_3, param_4, param_5, param_6 );
}

/@
"Name: get_dot_direction( <v_point>, [b_ignore_z], [b_normalize], [str_direction], [ b_use_eye] )"
"Summary: Calculates and returns dot between an entity's directional vector and a point."
"Module: Math"
"CallOn: Entity. Must have origin and angles parameters."
"MandatoryArg: <v_point> vector position to check against entity origin and angles"
"OptionalArg: <b_ignore_z> specify if get_dot should consider 2d or 3d dot. Defaults to false for 3d dot."
"OptionalArg: <str_direction> specify which vector type to use on angles. Valid options are "forward", "backward", "right", "left", "up" and "down". Defaults to "forward"."
"OptionalArg: <b_normalize> specify if the function should normalize the vector to target point. Defaults to true."
"OptionalArg: <b_use_eye> if self a player or AI, use tag_eye rather than .angles. Defaults to true on players, defaults to false on everything else.
"Example: n_dot = player get_dot_direction( woods.origin );"
"SPMP: singleplayer"
@/
get_dot_direction( v_point, b_ignore_z, b_normalize, str_direction, b_use_eye )
{
	assert( IsDefined( v_point ), "v_point is a required parameter for get_dot" );
	
	if ( !IsDefined( b_ignore_z ) )
	{
		b_ignore_z = false;
	}
	
	if ( !IsDefined( b_normalize ) )
	{
		b_normalize = true;
	}
	
	if ( !IsDefined( str_direction ) )
	{
		str_direction = "forward";
	}
	
	if ( !IsDefined( b_use_eye ) )
	{
		b_use_eye = false;
		
		if ( IsPlayer( self ) )
		{
			b_use_eye = true;
		}
	}
	
	v_angles = self.angles;
	v_origin = self.origin;
	
	if ( b_use_eye )
	{
		v_origin = self get_eye();
	}
	
	if ( IsPlayer( self ) )
	{
		v_angles = self GetPlayerAngles();
	}
	
	if ( b_ignore_z )
	{
		v_angles = ( v_angles[ 0 ], v_angles[ 1 ], 0 );
		v_point = ( v_point[ 0 ], v_point[ 1 ], 0 );
		v_origin = ( v_origin[ 0 ], v_origin[ 1 ], 0 );
	}
	
	switch ( str_direction )
	{
		case "forward":
			v_direction = AnglesToForward( v_angles );
			break;
		
		case "backward":
			v_direction = AnglesToForward( v_angles ) * ( -1 );
			break;
			
		case "right":
			v_direction = AnglesToRight( v_angles );
			break;
			
		case "left":
			v_direction = AnglesToRight( v_angles ) * ( -1 );
			break;
			
		case "up":
			v_direction = AnglesToUp( v_angles );
			break;
		
		case "down":
			v_direction = AnglesToUp( v_angles ) * ( -1 );
			break;
			
		default:
			AssertMsg( str_direction + " is not a valid str_direction for get_dot!" );
			v_direction = AnglesToForward( v_angles );   // have to initialize variable for default case
			break;
	}
	
	v_to_point = v_point - v_origin;
	
	if ( b_normalize )
	{
		v_to_point = VectorNormalize( v_to_point );
	}
	
	n_dot = VectorDot( v_direction, v_to_point );
	
	return n_dot;
}

/@
"Name: get_dot_from_eye( <v_point>, [b_ignore_z], [b_normalize], [str_direction] )"
"Summary: Calculates and returns dot between an entity's forward vector and a point based on tag_eye. Only use on players or AI"
"Module: Math"
"CallOn: Entity. Must have origin and angles parameters."
"MandatoryArg: <v_point> vector position to check against entity origin and angles"
"OptionalArg: [b_ignore_z] specify if get_dot should consider 2d or 3d dot. Defaults to false for 3d dot."
"OptionalArg: [b_normalize] specify if the function should normalize the vector to target point. Defaults to true."
"OptionalArg: [str_direction] specify which vector type to use on angles. Valid options are "forward", "backward", "right", "left", "up" and "down". Defaults to "forward"."
"Example: n_dot = player get_dot_from_eye( woods.origin );"
"SPMP: singleplayer"
@/
get_dot_from_eye( v_point, b_ignore_z, b_normalize, str_direction )
{
	assert( IsDefined( v_point ), "v_point is a required parameter for get_dot_forward" );
	Assert( ( IsPlayer( self ) || IsAI( self ) ), "get_dot_from_eye was used on a " + self.classname + ". Valid ents are players and AI, since they have tag_eye." );
	
	n_dot = get_dot_direction( v_point, b_ignore_z, b_normalize, str_direction, true );
	
	return n_dot;
}

/@
"Name: get_dot_forward( <v_point>, [b_ignore_z], [b_normalize] )"
"Summary: Calculates and returns dot between an entity's forward vector and a point."
"Module: Math"
"CallOn: Entity. Must have origin and angles parameters."
"MandatoryArg: <v_point> vector position to check against entity origin and angles"
"OptionalArg: <b_ignore_z> specify if get_dot should consider 2d or 3d dot. Defaults to false for 3d dot."
"OptionalArg: <b_normalize> specify if the function should normalize the vector to target point. Defaults to true."
"Example: n_dot = player get_dot_direction( woods.origin );"
"SPMP: singleplayer"
@/
get_dot_forward( v_point, b_ignore_z, b_normalize )
{
	// get_dot will assert if missing, but scripter should know it's coming from get_dot_forward
	assert( IsDefined( v_point ), "v_point is a required parameter for get_dot_forward" );
	
	n_dot = get_dot_direction( v_point, b_ignore_z, b_normalize, "forward" );
	
	return n_dot;
}

/@
"Name: get_dot_up( <v_point>, [b_ignore_z], [b_normalize] )"
"Summary: Calculates and returns dot between an entity's up vector and a point."
"Module: Math"
"CallOn: Entity. Must have origin and angles parameters."
"MandatoryArg: <v_point> vector position to check against entity origin and angles"
"OptionalArg: <b_ignore_z> specify if get_dot should consider 2d or 3d dot. Defaults to false for 3d dot."
"OptionalArg: <b_normalize> specify if the function should normalize the vector to target point. Defaults to true."
"Example: n_dot = player get_dot_direction( woods.origin );"
"SPMP: singleplayer"
@/
get_dot_up( v_point, b_ignore_z, b_normalize )
{
	// get_dot will assert if missing, but scripter should know it's coming from get_dot_up
	assert( IsDefined( v_point ), "v_point is a required parameter for get_dot_up" );
	
	n_dot = get_dot_direction( v_point, b_ignore_z, b_normalize, "up" );
	
	return n_dot;
}

/@
"Name: get_dot_right( <v_point>, [b_ignore_z], [b_normalize] )"
"Summary: Calculates and returns dot between an entity's right vector and a point."
"Module: Math"
"CallOn: Entity. Must have origin and angles parameters."
"MandatoryArg: <v_point> vector position to check against entity origin and angles"
"OptionalArg: <b_ignore_z> specify if get_dot should consider 2d or 3d dot. Defaults to false for 3d dot."
"OptionalArg: <b_normalize> specify if the function should normalize the vector to target point. Defaults to true."
"Example: n_dot = player get_dot_direction( woods.origin );"
"SPMP: singleplayer"
@/
get_dot_right( v_point, b_ignore_z, b_normalize )
{
	// get_dot will assert if missing, but scripter should know it's coming from get_dot_right
	assert( IsDefined( v_point ), "v_point is a required parameter for get_dot_right" );
	
	n_dot = get_dot_direction( v_point, b_ignore_z, b_normalize, "right" );
	
	return n_dot;
}


/@
"Name: player_wakes_up( <b_remove_weapons>, <str_return_weapons_notify>, <str_shader_name> )"
"Summary: Generic function to use when player is returning to consciousness or waking up. Puts player in prone position, then uses shellshock, rumble, restricts view angles and prohibits movement, and temporarily takes weapons. Sets flag "player_awake" when movement restored."
"Module: Player"
"CallOn: Player"
"OptionalArg: <b_remove_weapons> Whether or not players weapons should be available during wakeup. Defaults to true."
"OptionalArg: <str_return_weapons_notify> Custom notify to player when weapons should return. Sends default '_give_back_weapons' when movement controls return."
"OptionalArg: <str_shader_name> Full screen shader to use. Defaults to black."
"Example: player generic_wake_up();"
"SPMP: singleplayer"
@/
player_wakes_up( b_remove_weapons, str_return_weapons_notify )
{
	assert( IsPlayer( self ), "player_wakes_up can only be used on players!" );
	
	if ( !IsDefined( level.flag[ "player_awake" ] ) )  // if set, means player is fully awake and movement restored
	{
		flag_init( "player_awake" );
	}
	
	if ( !IsDefined( b_remove_weapons ) )
	{
		b_remove_weapons = true;
	}
	
	// restrict player movement and remove weapons here
	e_temp = Spawn( "script_origin", self.origin );
	e_temp.angles = self GetPlayerAngles();
	
	const n_view_percentage = 0;
	const n_right_arc = 45;
	const n_left_arc = 45;
	const n_top_arc = 45;
	const n_bottom_arc = 45;

	// prevent ground movement but retain view look
	self PlayerLinkToDelta( e_temp, undefined, n_view_percentage, n_right_arc, n_left_arc, n_top_arc, n_bottom_arc );
	
	self SetStance( "prone" );
	self AllowStand( false );
	self AllowSprint( false );
	self AllowJump( false );
	self AllowAds( !b_remove_weapons );  // if weapons removed, don't allow ADS. if weapons present, allow ADS
	self SetPlayerViewRateScale( 30 );
	self SetClientDvar( "cg_drawHUD", 0 );
	
	if ( b_remove_weapons )
	{
		self thread _player_wakes_up_remove_weapons( str_return_weapons_notify );
	}
	
	self ShellShock( "death", 12 );  // "explosion" includes ringing, "death" looks similar but without ringing sound
	self screen_fade_out( 0 );  // start off with black screen
	
	wait 0.2;

	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.4;

	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.4;
	
	self screen_fade_to_alpha_with_blur( 0.35, 2, 3 );
	
	wait 3.5;
	
	self screen_fade_to_alpha_with_blur( 1, 2.5, 6 );  // first fade to black
	
	self PlayRumbleOnEntity( "damage_light" );
	
	wait 0.5;
	
	self screen_fade_to_alpha_with_blur( 0.2, 2.5, 1.5 );

	wait 2;
	
	self screen_fade_to_alpha_with_blur( 1, 1, 6 );  // second fade to black
	
	wait 1;
	self SetPlayerViewRateScale( 80 );
	
	self screen_fade_to_alpha_with_blur( 0.2, 5, 1 );
	
	// player is awake enough now, return full movement controls
	self AllowStand( true );
	self AllowSprint( true );
	self AllowJump( true );
	self AllowAds( true );
	self ResetPlayerViewRateScale();
	self notify( "_give_back_weapons" ); // left as defaulted value so user can control timing if custom notify defined
	self SetClientDvar( "cg_drawHUD", 1 );
	flag_set( "player_awake" );
	self Unlink();
	e_temp Delete();
	
	self screen_fade_to_alpha_with_blur( 0, 6, 0 );  // restore vision to normal over a few seconds
}

// self = player
_player_wakes_up_remove_weapons( str_return_weapons_notify )
{
	level endon( "player_awake" );
	
	if ( !IsDefined( str_return_weapons_notify ) )
	{
		str_return_weapons_notify = "_give_back_weapons";
	}

	// wait until there's a weapon to remove, otherwise function will return to "none" and look like a bug if used at load
	while ( self GetCurrentWeapon() == "none" )
	{
		wait 0.05;
	}
	
	self thread take_and_giveback_weapons( str_return_weapons_notify );
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

/@
"Name: screen_fade_out( [n_time], [str_shader] )"
"Summary: Fades the screen out.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"OptionalArg: b_foreground: Set whether the HUD element is in the foreground. Defaults to false."
"Example: screen_fade_out( 3 );"
"SPMP: singleplayer"
@/
screen_fade_out( n_time, str_shader, b_foreground = false )
{
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );
	
	if ( !IsDefined( n_time ) )
	{
		n_time = 2;
	}
	
	hud = get_fade_hud( str_shader );
	hud.alpha = 0;
	hud.foreground = b_foreground;
	
	
	if ( IsDefined( n_time ) && ( n_time > 0 ) )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 1;
		
		flag_set( "screen_fade_out_start" );
		
		wait n_time;
	}
	else
	{
		hud.alpha = 1;
	}
	
	flag_clear( "screen_fade_out_start" );
	flag_set( "screen_fade_out_end" );
}

/@
"Name: screen_fade_in( [n_time], [str_shader] )"
"Summary: Fades the screen in.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"OptionalArg: b_foreground: Set whether the HUD element is in the foreground. Defaults to false."
"Example: screen_fade_in( 3 );"
"SPMP: singleplayer"
@/
screen_fade_in( n_time, str_shader, b_foreground = false )
{
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );
	
	if ( !IsDefined( n_time ) )
	{
		n_time = 2;
	}
	
	hud = get_fade_hud( str_shader );
	hud.alpha = 1;
	hud.foreground = b_foreground;
	
	if ( n_time > 0 )
	{
		hud FadeOverTime( n_time );
		hud.alpha = 0;
		
		flag_set( "screen_fade_in_start" );
		
		wait n_time;
	}
	
	if ( IsDefined( level.fade_hud ) )
	{
		level.fade_hud Destroy();
	}
	
	flag_clear( "screen_fade_in_start" );
	flag_set( "screen_fade_in_end" );
}

/@
"Name: screen_fade_to_alpha_with_blur( n_alpha, [n_time], [n_blur], [str_shader] )"
"Summary: Fades the screen in to a specified alpha and blur value.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: n_alpha: The alpha value to fade the hud to."
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: n_blur: The blur value."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"Example: screen_fade_to_alpha_with_blur( .3, 4, 1 );"
"SPMP: singleplayer"
@/
screen_fade_to_alpha_with_blur( n_alpha, n_fade_time, n_blur, str_shader )
{
	Assert( IsDefined( n_alpha ), "Must specify an alpha value for screen_fade_to_alpha_with_blur." );
	Assert( IsPlayer( self ), "screen_fade_to_alpha_with_blur can only be called on players!" );
	
	level notify( "_screen_fade" );
	level endon( "_screen_fade" );
	
	hud_fade = get_fade_hud( str_shader );
	hud_fade FadeOverTime( n_fade_time );
	hud_fade.alpha = n_alpha;
	
	if ( IsDefined( n_blur ) && ( n_blur > 0 ) )
	{
		self SetBlur( n_blur, n_fade_time );
	}
	
	wait n_fade_time;
}

/@
"Name: screen_fade_to_alpha( n_alpha, [n_time], [str_shader] )"
"Summary: Fades the screen in to a specified alpha value.  Uses any shader. Defaults to black."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: n_alpha: The alpha value to fade the hud to."
"OptionalArg: n_time: The time to fade. Defaults to 2 seconds. Can be 0."
"OptionalArg: str_shader: The shader to use for the hud element. Defaults to black."
"Example: screen_fade_to_alpha( .3 );"
"SPMP: singleplayer"
@/
screen_fade_to_alpha( n_alpha, n_fade_time, str_shader )
{
	screen_fade_to_alpha_with_blur( n_fade_time, n_alpha, 0, str_shader );
}

get_fade_hud( str_shader )
{
	if ( !IsDefined( str_shader ) )
	{
		str_shader = "black";
	}
	
	if ( !IsDefined( level.fade_hud ) )
	{
		level.fade_hud = NewHudElem();
		level.fade_hud.x = 0;
		level.fade_hud.y = 0;
		level.fade_hud.horzAlign  = "fullscreen";
		level.fade_hud.vertAlign  = "fullscreen";
		//level.fade_hud.foreground = false; //Arcade Mode compatible
		level.fade_hud.sort = 0;
		level.fade_hud.alpha = 0;
	}
		
	level.fade_hud SetShader( str_shader, 640, 480 );
	return level.fade_hud;
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////

/@
"Name: get_triggers(type1, type2, type3, type4, type5, type6, type7, type8, type9)"
"Summary: Gets all triggers on the map.  If only want certain types, can specify those"
"Module: Level"
"CallOn: N/A"
"OptionalArg: <type1-9> 	: Classname of Trigger to get."
"Example: trigs = get_triggers();"
"SPMP: singleplayer"
@/
get_triggers(type1, type2, type3, type4, type5, type6, type7, type8, type9)
{
	if (!isdefined(type1))
	{
		type1 = "trigger_damage";
		type2 = "trigger_hurt";
		type3 = "trigger_lookat";
		type4 = "trigger_once";
		type5 = "trigger_radius";
		type6 = "trigger_use";
		type7 = "trigger_use_touch";
		type8 = "trigger_box";
		type9 = "trigger_multiple";
	}
	
	assert(_is_valid_trigger_type(type1) );
	trigs = getentarray(type1, "classname"  );
	if (isdefined(type2))
	{
		assert(_is_valid_trigger_type(type2) );
		trigs = ArrayCombine(trigs, getentarray(type2, "classname"), true, false );
	}
	if (isdefined(type3))
	{
		assert(_is_valid_trigger_type(type3) );
		trigs = ArrayCombine(trigs, getentarray(type3, "classname"), true, false );
	}
	if (isdefined(type4))
	{
		assert(_is_valid_trigger_type(type4) );
		trigs = ArrayCombine(trigs, getentarray(type4, "classname"), true, false );
	}
	if (isdefined(type5))
	{
		assert(_is_valid_trigger_type(type5) );
		trigs = ArrayCombine(trigs, getentarray(type5, "classname"), true, false );
	}
	if (isdefined(type6))
	{
		assert(_is_valid_trigger_type(type6) );
		trigs = ArrayCombine(trigs, getentarray(type6, "classname"), true, false );
	}
	if (isdefined(type7))
	{
		assert(_is_valid_trigger_type(type7) );
		trigs = ArrayCombine(trigs, getentarray(type7, "classname"), true, false );
	}
	if (isdefined(type8))
	{
		assert(_is_valid_trigger_type(type8) );
		trigs = ArrayCombine(trigs, getentarray(type8, "classname"), true, false );
	}
	if (isdefined(type9))
	{
		assert(_is_valid_trigger_type(type9) );
		trigs = ArrayCombine(trigs, getentarray(type9,	"classname"), true, false );
	}
		
	return trigs;
}
	
_is_valid_trigger_type(type)
{
	if (type == "trigger_damage")
		return true;
	if (type == "trigger_hurt")
		return true;
	if (type == "trigger_lookat")
		return true;
	if (type == "trigger_once")
		return true;
	if (type == "trigger_radius")
		return true;
	if (type == "trigger_use")
		return true;
	if (type == "trigger_use")
		return true;
	if (type == "trigger_use_touch")
		return true;
	if (type == "trigger_box")
		return true;
	if (type == "trigger_multiple")
		return true;
			
	return false;
}

/@
"Name: get_player_stat( <stat_name> )"
"Summary:  Retrieves a player stat for a specific player"
"Module: stats"
"CallOn: Player"
"MandatoryArg: <stat_name> : the name of the stat to be fetched"
"Example: player get_player_stat( \"sp_kills_temp\" )"
"SPMP: SP"
@/
get_player_stat( stat_name )
{
	if( !IsPlayer( self ) )
	{
		/#PrintLn( "ERROR: Tried to get player stat "+stat_name+"on a non-player entity!" );#/
		return undefined;
	}
	
	return self GetSessStat( "PlayerSessionStats", stat_name );
}

/@
"Name: get_player_stat( <stat_name>, <value> )"
"Summary:  Sets a player stat for a specific player"
"Module: stats"
"CallOn: Player"
"MandatoryArg: <stat_name> : the name of the stat to be set"
"MandatoryArg: <value> : the value to set the desired stat to"
"Example: player get_player_stat( \"sp_kills_temp\", newKillCount )"
"SPMP: SP"
@/
set_player_stat( stat_name, value )
{
	if( !IsPlayer( self ) )
	{
		/#PrintLn( "ERROR: Tried to set player stat "+stat_name+"on a non-player entity!" );#/
		return undefined;
	}
	
	self SetSessStat( "PlayerSessionStats", stat_name, value );
}

/@
"Name: waitforstats()"
"Summary:  a utility function that waits until all the player's stats blobs have been inited on the server"
"Module: stats"
"Example: waitforstats()"
"SPMP: SP"
@/
waitforstats()
{
	flag_wait( "all_players_connected" );
	players = get_players();
	
	while( true )
	{
		all_stats_fetched = true;
		
		for( i = 0; i < players.size; i++ )
		{
			if( !players[i] HasDStats() )
			{
				all_stats_fetched = false;
			}
		}
		
		if( all_stats_fetched )
		{
			return;
		}
		
		/#PrintLn( "Stats not fetched yet!" );#/
		
		wait 0.05;
	}
}

/@
"Name: init_hero(name, func_init, arg1, arg2, arg3, arg4, arg5 )"
"Summary: a function that can spawn or grab an entity and turn it into a hero character"
"Module: Level"
"CallOn: N/A"
"OptionalArg: func_init, arg1, arg2, arg3, arg4, arg5"
"Example: init_hero(woods, ::equip_wooods, primary_gun, secondary_gun);
"SPMP: singleplayer"
@/

init_hero( name, func_init, arg1, arg2, arg3, arg4, arg5 )
{
	if ( !IsDefined( level.heroes ) )
	{
		level.heroes = [];
	}

	name = ToLower( name );

	ai_hero = GetEnt( name + "_ai", "targetname" );
	if ( !IsAlive( ai_hero ) )
	{
		spawner = GetEnt( name, "targetname" );
		if ( !IS_TRUE( spawner.spawning ) )
		{
			spawner.count++;
			ai_hero = simple_spawn_single( spawner );
			spawner notify( "hero_spawned", ai_hero );
		}
		else
		{
			// Another thread is already spawning this hero, just wait for that one
			spawner waittill( "hero_spawned", ai_hero );
		}
	}
	
	ai_hero.animname = name;
	
	if ( IsDefined( ai_hero.script_friendname ) )
	{
		ai_hero.name = ai_hero.script_friendname;
	}
	else
	{
		ai_hero.name = name;
	}
	
	ai_hero make_hero();

	if ( IsDefined( func_init ) )
	{
		single_thread( ai_hero, func_init, arg1, arg2, arg3, arg4, arg5 );
	}
	
	level.heroes = add_to_array( level.heroes, ai_hero, false );
	
	return ai_hero;
}

/@
"Name: init_heroes(a_hero_names, func_init, arg1, arg2, arg3, arg4, arg5 )"
"Summary: a function that takes an array of targetname string and set them up as hero characters"
"Module: Level"
"CallOn: N/A"
"OptionalArg: func_init, arg1, arg2, arg3, arg4, arg5"
"Example: init_hero( a_pow_heroes, ::equip_pow_heroes, primary_gun, secondary_gun);
"SPMP: singleplayer"
@/

init_heroes( a_hero_names, func, arg1, arg2, arg3, arg4, arg5 )
{
	a_heroes = [];
	foreach ( str_hero in a_hero_names )
	{
		ARRAY_ADD( a_heroes, init_hero( str_hero, func, arg1, arg2, arg3, arg4, arg5 ) );
	}

	return a_heroes;
}

getDvarFloatDefault( dvarName, defaultValue)
{
	value=getDvar(dvarName);
	if (value!= "")
	{
		return float(value);
	}	
	return defaultValue;
}	

getDvarIntDefault( dvarName, defaultValue)
{
	value=getDvar(dvarName);
	if (value!= "")
	{
		return int(value);
	}	
	return defaultValue;
}	

weaponDamageTrace(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
/#	
	if ( GetDvarint( "scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
#/	
	return trace;
}

	
closestPointOnLine( point, lineStart, lineEnd )
{
	lineMagSqrd = lengthsquared(lineEnd - lineStart);
 
  t =	( ( ( point[0] - lineStart[0] ) * ( lineEnd[0] - lineStart[0] ) ) +
			( ( point[1] - lineStart[1] ) * ( lineEnd[1] - lineStart[1] ) ) +
			( ( point[2] - lineStart[2] ) * ( lineEnd[2] - lineStart[2] ) ) ) /
			( lineMagSqrd );
 
  if( t < 0.0  )
	{
		return lineStart;
	}
	else if( t > 1.0 )
	{
		return lineEnd;
	}

	start_x = lineStart[0] + t * ( lineEnd[0] - lineStart[0] );
	start_y = lineStart[1] + t * ( lineEnd[1] - lineStart[1] );
	start_z = lineStart[2] + t * ( lineEnd[2] - lineStart[2] );
	
	return (start_x,start_y,start_z);
}

get2DYaw( start, end )
{
	vector = (end[0] - start[0], end[1] - start[1], 0);

	return vecToAngles( vector );
}

vecToAngles( vector )
{
	yaw = 0;
	
	vecX = vector[0];
	vecY = vector[1];
	
	if ( vecX == 0 && vecY == 0 )
		return 0;
		
	if ( vecY < 0.001 && vecY > -0.001 )
		vecY = 0.001;

	yaw = atan( vecX / vecY );
	
	if ( vecY < 0 )
		yaw += 180;

	return ( 90 - yaw );
}

wait_endon( waitTime, endOnString, endonString2, endonString3 )
{
	self endon ( endOnString );
	if ( isDefined( endonString2 ) )
		self endon ( endonString2 );
	if ( isDefined( endonString3 ) )
		self endon ( endonString3 );
	
	wait ( waitTime );
}

waitTillNotMoving()
{
	if ( self.classname == "grenade" )
	{
		self waittill("stationary");
	}
	else
	{
		prevorigin = self.origin;
		while(1)
		{
			wait .15;
			if ( self.origin == prevorigin )
				break;
			prevorigin = self.origin;
		}
	}
}

playSoundinSpace( alias, origin, master = false )
{
	DEFAULT( origin, self.origin );
	
	org = Spawn( "script_origin", (0, 0, 1) );	
	org.origin = origin;
	
	if ( master )
	{
		org PlaySoundAsMaster( alias );
	}
	else
	{
		org PlaySound( alias );
	}
	
	wait 10.0;
	org Delete();
}

/@
Name: sort_by_distance( <a_ents>, <v_origin> )
Summary: sorts a list of ents by distance to origin
Module: Utility
CallOn: n/a
ManditoryArg: <a_ents>: array of entities to sort
ManditoryArg: <v_origin>: position to check distance from
Example: list = sort_by_distance( allies, player.origin );
SPMP: singleplayer
@/
sort_by_distance( a_ents, v_origin )
{
	return maps\_utility_code::mergeSort( a_ents, ::_sort_by_distance_compare_func, v_origin );
}

_sort_by_distance_compare_func( e1, e2, origin )
{
	dist1 = DistanceSquared( e1.origin, origin );
	dist2 = DistanceSquared( e2.origin, origin );

	return dist1 > dist2;
}

/@
Name: sort_by_script_int( a_ents, b_lowest_first = true )
Summary: sorts a list of ents by their script_int value
Module: Utility
CallOn: n/a
ManditoryArg: <a_ents>: array of entities to sort
OptionalArg: [b_lowest_first]: sort from lowest to highest
Example: list = sort_by_script_int( allies );
SPMP: singleplayer
@/
sort_by_script_int( a_ents, b_lowest_first = false )
{
	return maps\_utility_code::mergeSort( a_ents, ::_sort_by_script_int_compare_func, b_lowest_first );
}

_sort_by_script_int_compare_func( e1, e2, b_lowest_first )
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


/@
"Name: set_battlechatter( <state> )"
"Summary: Turns an AI's battlechatter on/off. "
"Module: Battlechatter"
"CallOn: An AI"
"MandatoryArg: <state>: True/false, describes whether battlechatter should be on or off for this AI"
"Example: "
"SPMP: singleplayer"
@/
set_battlechatter( state )
{

	if ( self.type == "dog" )
		return;

	if ( state )
	{
		self.bsc_squelched = true;
	}
	else
	{
		if ( IsDefined( self.isSpeaking ) && self.isSpeaking )
			self wait_until_done_speaking();
		self.bsc_squelched = false;

	}
}

playSmokeSound( position, duration, startSound, stopSound, loopSound )
{
	smokeSound = spawn ("script_origin",(0,0,1));
	smokeSound.origin = position;
	
	smokeSound playsound( startSound );
	smokeSound playLoopSound ( loopSound );
	if ( duration > 0.5 )
		wait( duration - 0.5 );
	thread playSoundinSpace( stopSound, position );
	smokeSound StopLoopSound( .5);
	wait(.5);
	smokeSound delete();
}

/@
"Name: freeze_player_controls( <boolean> )"
"Summary:  Freezes the player's controls with appropriate 'if' checks"
"Module: Player"
"CallOn: Player"
"MandatoryArg: <boolean> : true or false"
"Example: freeze_player_controls( true )"
"SPMP: MP"
@/

freeze_player_controls( boolean )
{
	assert( IsDefined( boolean ), "'freeze_player_controls()' has not been passed an argument properly." );

	if( boolean && IsAlive( self ) )
	{
		self FreezeControls( boolean );

	}
	//'!level.gameEnded' check prevents the player from having their controls unfrozen during the end of rounds
	else if( !boolean && IsAlive( self ) && !level.gameEnded )
	{
		self FreezeControls( boolean );

	}
}



isKillStreaksEnabled()
{
	return IsDefined( level.killstreaksenabled ) && level.killstreaksenabled;
}

isKillStreaksStreakCountsEnabled()
{
	return !IsDefined(level.killstreakscountsdisabled ) || !level.killstreakscountsdisabled;
}

/@
"Name: get_story_stat( <stat_name> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the story event to grab"
"Example: "
"SPMP: singleplayer"
@/
get_story_stat( str_stat_name )
{
	if( level.script == "frontend" )
	{
		return self GetDStat( "PlayerCareerStats", "storypoints", str_stat_name );
	}
	else
	{
		return self GetSessStat( "storypoints", str_stat_name );
	}
}

/@
"Name: set_story_stat( <stat_name>, <eventState> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding  "
"MandatoryArg: <eventState>: The state of the given story event (1 for true, 0 for false ) "
"Example: "
"SPMP: singleplayer"
@/
set_story_stat( str_stat_name, b_event_state )
{
	if( level.script == "frontend" )
	{
		return self SetDStat( "PlayerCareerStats", "storypoints", str_stat_name, b_event_state );
	}
	else
	{
		return self SetSessStat( "storypoints", str_stat_name, b_event_state );
	}
}

/@
"Name: get_temp_stat( <stat_num> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the story event to grab"
"Example: "
"SPMP: singleplayer"
@/
get_temp_stat( n_temp_stat )
{
	return self GetSessStat( "PlayerTempStats", "stat", "TEMPSTAT_"+n_temp_stat );
}

/@
"Name: set_temp_stat( <stat_num>, <value> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding  "
"MandatoryArg: <eventState>: The state of the given story event (1 for true, 0 for false ) "
"Example: "
"SPMP: singleplayer"
@/
set_temp_stat( n_temp_stat, n_val )
{
	self SetSessStat( "PlayerTempStats", "stat", "TEMPSTAT_"+n_temp_stat, n_val );
}

/@
"Name: get_general_stat( <stat_name> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the stat to get the value of"
"Example: "
"SPMP: singleplayer"
@/
get_general_stat( str_stat_name )
{
	return self GetSessStat( "PlayerSessionStats", str_stat_name );
}

/@
"Name: inc_general_stat( <stat_name>, <eventState> )"
"Summary: wrapper to increment a challenge stat"
"Module: Code Wrappers"
"CallOn: An player"
"MandatoryArg: <stat_name>: the string corresponding to the stat to increment "
"Example: "
"SPMP: singleplayer"
@/
inc_general_stat( str_stat_name )
{
	self AddSessStat( "PlayerSessionStats", str_stat_name, 1 );
}

/@
"Name: hide_hud()"
"Summary: Hides the hud"
"Module: HUD"
"CallOn: Player"
"Example: self hide_hud();"
"SPMP: singleplayer"
@/
hide_hud() // self == player
{
	if ( !IsDefined( self._hide_hud_count ) )
	{
		self._hide_hud_count = 0;
		
		self SetClientDvars( "cg_drawfriendlynames", 0 );
		self SetClientUIVisibilityFlag( "hud_visible", 0 );
	}
	
	// Count calls to this function so calls can be stacked
	self._hide_hud_count++;
}

/@
"Name: show_hud()"
"Summary: Shows the hud"
"Module: HUD"
"CallOn: Player"
"Example: self show_hud()"
"SPMP: singleplayer"
@/
show_hud() // self == player
{
	if ( IsDefined( self._hide_hud_count ) )
	{
		// Only reset the HUD when show_hud calls match hide_hud calls
		
		self._hide_hud_count--;
		if ( self._hide_hud_count == 0 )
		{
			self SetClientDvars( "cg_drawfriendlynames", 1 );
			self SetClientUIVisibilityFlag( "hud_visible", 1 );
			
			self._hide_hud_count = undefined;
		}
	}
}


/@
"Name: Collected_all()"
"Summary: check to see if there are any collectable left in the level, return true if all collectable are collected. else return false"
"Module: Collectable"
"CallOn: level"
"Example: collect_all = collected_all();"
"SPMP: singleplayer"
@/
collected_all()
{
	if( HasCollectible( 1 ) && HasCollectible( 2 ) && HasCollectible( 3 ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

/@
"Name: load_gump( <str_gump> )"
"Summary: loads in a gump fastfile and if not threaded will block until fastfile has been loaded."
"Module: Level"
"CallOn: level"
"MandatoryArg: <str_gump>: name of gump fastfile"
"Example: load_gump( "str_gump_levelname_1" )"
"SPMP: singleplayer"
@/
load_gump( str_gump )
{
	if ( !level flag_exists( str_gump ) )
	{
		level flag_init( str_gump );
	}
	
	if ( !IS_EQUAL( level.gump, str_gump ) )
	{		
		flush_gump( str_gump );
		
		level.gump = str_gump;
		LoadGump( str_gump );
		
		level waittill( "gump_loaded" );
		level notify( "loaded_gump", str_gump );
		level flag_set( str_gump );
	}
	else
	{
		flag_wait( str_gump );
	}
	
	maps\_autosave::allow_save();
}

/@
"Name: flush_gump()"
"Summary: Unloads whatever gump fastfile has been loaded"
"Module: Level"
"CallOn: level"
"Example: flush_gump()"
"SPMP: singleplayer"
@/
flush_gump( str_gump_loading )
{
	str_gump_to_dump = level.gump;
	
	if ( IsDefined( str_gump_loading ) )
	{
		level.gump = str_gump_loading;
	}
	
	if ( IsDefined( str_gump_to_dump ) )
	{
		maps\_autosave::block_save();
		
		// make sure flushing happens at the end of the frame
		// so script can clean up stuff that might be in the gump
		
		level notify( "flushing_" + str_gump_to_dump );
		flag_clear( str_gump_to_dump );
		
		waittillframeend;
		waittillframeend;
		
		if ( !IsDefined( str_gump_loading ) )
		{
			level.gump = undefined;
		}
		
		FlushGump();
		level waittill( "gump_flushed" );
	}
}

/@
"Name: add_gump_function( <str_gump>, <func> )"
"Summary: Runs a level function when a gump fastfile has been loaded"
"Module: Level"
"CallOn: level"
"MandatoryArg: <str_gump>: name of gump fastfile"
"MandatoryArg: <func>: function to run when a gump is loaded"
"Example: add_gump_function( "la_gump2", ::my_gump_func )"
"SPMP: singleplayer"
@/
add_gump_function( str_gump, func )
{
	if ( !IsDefined( level._gump_functions ) )
	{
		level._gump_functions = [];
	}
	
	if ( !IsDefined( level._gump_functions[ str_gump ] ) )
	{
		level._gump_functions[ str_gump ] = [];
	}
	
	ARRAY_ADD( level._gump_functions[ str_gump ], func );
}

/@
"Name: waittill_player_has_brute_force_perk()"
"Summary: Returns once the player has the brute force perk"
"Module: Player"
"CallOn: Player"
"Example: waittill_player_has_brute_force_perk()"
"SPMP: singleplayer"
@/
waittill_player_has_brute_force_perk()
{
	while ( !self HasPerk( "specialty_brutestrength" ) )
	{
		wait 0.05;
	}
}

/@
"Name: waittill_player_has_intruder_perk()"
"Summary: Returns once the player has the intruder perk"
"Module: Player"
"CallOn: Player"
"Example: waittill_player_has_intruder_perk()"
"SPMP: singleplayer"
@/
waittill_player_has_intruder_perk()
{
	while ( !self HasPerk( "specialty_intruder" ) )
	{
		wait 0.05;
	}
}

/@
"Name: waittill_player_has_lock_breaker_perk()"
"Summary: Returns once the player has the lock breaker perk"
"Module: Player"
"CallOn: Player"
"Example: waittill_player_has_lock_breaker_perk()"
"SPMP: singleplayer"
@/
waittill_player_has_lock_breaker_perk()
{
	while ( !self HasPerk( "specialty_trespasser" ) )
	{
		wait 0.05;
	}
}

/@
"Name: waittill_textures_loaded()"
"Summary: Waits until textures are loaded"
"Module: Util"
"CallOn: NA"
"Example: waittill_textures_loaded()"
"SPMP: singleplayer"
@/
waittill_textures_loaded()
{
	while ( !AreTexturesLoaded() )
	{
		wait 0.05;
	}
}

waittill_asset_loaded( str_type, str_name )
{
	while ( !IsAssetLoaded( str_type, str_name ) )
	{
		level waittill( "gump_loaded" );
	}
}

// TIME

new_timer()
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetTime();
	return s_timer;
}

get_time()
{
	t_now = GetTime();
	return t_now - self.n_time_created;
}

get_time_in_seconds()
{
	return get_time() / 1000;
}

timer_wait( n_wait )
{
	wait n_wait;
	return get_time_in_seconds();
}

// DVARS

lerp_dvar( str_dvar, n_val, n_lerp_time, b_saved_dvar, b_client_dvar )
{
	n_start_val = GetDvarFloat( str_dvar );
	s_timer = new_timer();
	
	do
	{
		n_time_delta = s_timer timer_wait( .05 );
		n_curr_val = LerpFloat( n_start_val, n_val, n_time_delta / n_lerp_time );
		
		if ( IS_TRUE( b_saved_dvar ) )
		{
			SetSavedDvar( str_dvar, n_curr_val );
		}
		else if ( IS_TRUE( b_client_dvar ) )
		{
			self SetClientDvar( str_dvar, n_curr_val );
		}
		else
		{
			SetDvar( str_dvar, n_curr_val );
		}
	}
	while ( n_time_delta < n_lerp_time );
}

/@
"Name: get_level_era()"
"Summary: Returns the era that the current level is in ex. 'twentytwenty' or 'nineteeneighties'"
"Module: Util"
"CallOn: NA"
"Example: str_era = get_level_era()"
"SPMP: singleplayer"
@/
get_level_era()
{
	str_era = TableLookup( LEVEL_PROGRESSION_CSV, LEVEL_PROGRESSION_LEVEL_NAME, level.script, LEVEL_PROGRESSION_ERA );
	return str_era;
}

//-- for RTS mode
ishardPointsEnabled()
{
	return IsDefined( level.hardpointsenabled ) && level.hardpointsenabled;
}

/@
"Name: flag_wait_on( <flagname> )"
"Summary: Waits until the flag is initialized and set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of flag to wait on"
"Example: flag_wait_on( "all_players_connected" );"
"SPMP: singleplayer"
@/
flag_wait_on( flagname )
{
	while( !level flag_exists( flagname ) )
	{
		wait 0.05;
	}

	flag_wait( flagname );
}

/@
"Name: set_screen_fade_timer( [delay] )"
"Summary: Set the timer for screen fade."
"Module: Level"
"CallOn: N/A"
"MandatoryArg: [delay] : The delay in which you want the screen to fade in or out. Default is set to 2 seconds"
"Example: set_screen_fade_timer( 7 );"
"SPMP: singleplayer"
@/
set_screen_fade_timer( delay )
{
	assert( IsDefined( delay ), "You must specify a delay to change the fade screen's fadeTimer." );
	
	level.fade_screen.fadeTimer = delay;
}


/@
"Name: waittill_dialog_finished()"
"Summary: waits until self isn't talking."
"Module: Level"
"CallOn: N/A"
"Example: level.ai_dude waittill_dialog_finished();"
"SPMP: singleplayer"
@/
waittill_dialog_finished()
{
	self endon( "death" );
	
	if ( IS_TRUE( self.isTalking ) || IS_TRUE( self.is_about_to_talk ) )
	{
		self waittill_any( "done speaking", "cancel speaking", "kill_pending_dialog" );
	}
}

/@
"Name: waittill_dialog_finished_array( a_ents )"
"Summary: waits until all ents in array are finished talking."
"Module: Level"
"CallOn: N/A"
"Example: waittill_dialog_finished_array( array( level.player, level.harper ) );"
"SPMP: singleplayer"
@/
waittill_dialog_finished_array( a_ents, str_line )
{
	if ( a_ents.size > 0 )
	{
		for ( i = 0; i < a_ents.size; i++ )
		{
			ent = a_ents[ i ];
			
			if ( IsAlive( ent ) && IS_TRUE( ent.is_about_to_talk ) )
			{
				ent waittill_dialog_finished();
				waittillframeend;
				i = -1; // start back at the begining
			}
		}
	}
}

/@
"Name: ammo_refill_trigger()"
"Summary: Set a trigger to be an ammo cache/ammo refill trigger."
"Module: Level"
"CallOn: Trigger"
"Example: ammo_trigger ammo_refill_trigger();"
"SPMP: singleplayer"
@/
ammo_refill_trigger()
{
	self SetHintString( &"SCRIPT_AMMO_REFILL" );
	self SetCursorHint( "HINT_NOICON" );	
	
	while( 1 )
	{
		self waittill( "trigger", e_player );
		
		e_player player_disable_weapons();
					
		wait 2;
		
		a_str_weapons = e_player GetWeaponsList();
		foreach( str_weapon in a_str_weapons )
		{
			e_player GiveMaxAmmo( str_weapon );
			e_player SetWeaponAmmoClip( str_weapon, WeaponClipSize( str_weapon ) );
		}
			
		e_player player_enable_weapons();
	}
}

/@
"Name: player_enable_weapons( )"
"Summary:  Enables for a specific player"
"Module: Player"
"CallOn: Player"
"Example: player player_enable_weapons( )"
"SPMP: SP"
@/
player_enable_weapons( )
{
	if( !IsPlayer( self ) )
	{
		/#PrintLn( "ERROR: Tried to enable weapons on a non-player entity!" );#/
		return undefined;
	}
	
	self EnableWeapons();
	LUINotifyEvent( &"hud_expand_ammo", 0 );
}

/@
"Name: player_disable_weapons( )"
"Summary:  Disables weapons for a specific player"
"Module: Player"
"CallOn: Player"
"Example: player player_disable_weapons( )"
"SPMP: SP"
@/
player_disable_weapons( notify_event )
{
	if( !IsPlayer( self ) )
	{
		/#PrintLn( "ERROR: Tried to disable weapons on a non-player entity!" );#/
		return undefined;
	}
	
	self DisableWeapons();
	LUINotifyEvent( &"hud_shrink_ammo", 0 );
}

/@
"Name: player_walk_speed_adjustment( <e_rubber_band_to>, <str_endon>, <n_dist_min>, <n_dist_max>, [n_speed_scale_min], [n_speed_scale_max] )"
"Summary: Adjust the speed of the player based the distance between the entity that the player is rubber band to"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <e_rubber_band_to> The entity that the player is rubber banding to"
"MandatoryArg: <str_endon> The endon string that will stop adjusting the speed of the player"
"MandatoryArg: <n_dist_min> The minimum distance between the entity and the player before clamping to the minimum player movement speed scale"
"MandatoryArg: <n_dist_max> The maximum distance between the entity and the player before clamping to the maximum player movement speed scale"
"OptionalArg: [n_speed_scale_min] The minimum player movement speed that it will scaled to. 1 is the player's normal movement speed. Default is 0."
"OptionalArg: [n_speed_scale_max] The maximum player movement speed that it will scaled to. 1 is the player's normal movement speed. Default is 1."
"Example: level.player thread player_walk_speed_adjustment( level.ai_mason, "player_outro_started", 128, 256, 0.35, 0.65 )"
"SPMP: singleplayer"
@/
player_walk_speed_adjustment( e_rubber_band_to, str_endon, n_dist_min, n_dist_max, n_speed_scale_min = 0, n_speed_scale_max = 1 )
{
    Assert( IsPlayer( self ), "player_walk_speed_adjustment() must be called on a player" );
    Assert( IsDefined( e_rubber_band_to ), "e_rubber_band_to is a required argument for player_walk_speed_adjustment()" );
    Assert( IsDefined( n_dist_min ), "n_dist_min is a required argument for player_walk_speed_adjustment()" );
    Assert( IsDefined( n_dist_max ), "n_dist_max is a required argument for player_walk_speed_adjustment()" );

    level endon( str_endon );

    n_dist_min_sq = n_dist_min * n_dist_min;
    n_dist_max_sq = n_dist_max * n_dist_max;
    self.n_speed_scale_min = n_speed_scale_min;
    self.n_speed_scale_max = n_speed_scale_max;

    // scale the player's speed based on the distance between the player and the entity
    while ( true )
    {
        n_dist_sq = Distance2DSquared( self.origin, e_rubber_band_to.origin );
        n_speed_scale = linear_map( n_dist_sq, n_dist_min_sq, n_dist_max_sq, self.n_speed_scale_min, self.n_speed_scale_max );
        self SetMoveSpeedScale( n_speed_scale );

        wait 0.05;
    }
}