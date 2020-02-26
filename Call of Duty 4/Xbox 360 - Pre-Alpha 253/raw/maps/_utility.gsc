#include common_scripts\utility;
#include maps\_utility_code;

/*
=============
///ScriptDocBegin
"Name: flag_wait( <flagname> )"
"Summary: Waits until the specified flag is set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to wait on"
"Example: flag_wait( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_wait( msg )
{
	while( !level.flag[ msg ] )
		level waittill( msg );
}

/*
=============
///ScriptDocBegin
"Name: flag_wait_either( <flagname1>, <flagname2> )"
"Summary: Waits until either of the the specified flags are set."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1>: name of one flag to wait on"
"MandatoryArg: <flagname2>: name of the other flag to wait on"
"Example: flag_wait( "hq_cleared", "hq_destroyed" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_wait_either( flag1, flag2 )
{
	for ( ;; )
	{
		if ( flag( flag1 ) )
			return;
		if ( flag( flag2 ) )
			return;
		
		level waittill_either( flag1, flag2 );
	}
}

/*
=============
///ScriptDocBegin
"Name: flag_wait_or_timeout( <flagname>, <timer> )"
"Summary: Waits until either the flag gets set or the timer elapses."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname1: Name of one flag to wait on"
"MandatoryArg: <timer>: Amount of time to wait before continuing regardless of flag."
"Example: flag_wait_or_timeout( "time_to_go", 3 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_wait_or_timeout( flagname, timer )
{
	start_time = gettime();
	for ( ;; )
	{
		if ( level.flag[ flagname ] )
			break;
			
		if ( gettime() >= start_time + timer )
			break;

		wait_for_flag_or_time_elapses( flagname, timer );
	}
}

flag_waitopen (msg)
{
	while (level.flag[msg])
		level waittill (msg);
}


flag_trigger_init( message, trigger, continuous )
{
	flag_init( message );

	if ( !isDefined( continuous ) )
		continuous = false;
	
	assert( isSubStr( trigger.classname, "trigger" ) );
	trigger thread _flag_wait_trigger( message, continuous );
	
	return trigger;
}


flag_triggers_init( message, triggers, all )
{
	flag_init( message );

	if ( !isDefined( all ) )
		all = false;
	
	for ( index = 0; index < triggers.size; index++ )
	{
		assert( isSubStr( triggers[index].classname, "trigger" ) );
		triggers[index] thread _flag_wait_trigger( message, false );
	}
	
	return triggers;
}

flag_assert( msg )
{
	assertEx( !flag( msg ), "Flag " + msg + " set too soon!" );	
}

/*
=============
///ScriptDocBegin
"Name: flag_init( <flagname> )"
"Summary: Initialize a flag to be used. All flags must be initialized before using flag_set or flag_wait"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to create"
"Example: flag_init( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_init( message, trigger )
{
	if ( !isDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}
	assertEx( !isDefined( level.flag[message] ), "Attempt to reinitialize existing message: " + message );
	level.flag[message] = false;
/#
	level.flags_lock[message] = false;
#/
	if ( !isdefined( level.trigger_flags ) )
	{
		maps\_load::init_trigger_flags();
		level.trigger_flags[ message ] = [];
	}
	else
	if ( !isdefined( level.trigger_flags[ message ] ) )
	{
		level.trigger_flags[ message ] = [];
	}
}

/*
=============
///ScriptDocBegin
"Name: flag_set_delayed( <flagname>, <delay> )"
"Summary: Sets the specified flag after waiting the delay time, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to set"
"MandatoryArg: <delay>: time to wait before setting the flag"
"Example: flag_set_delayed( "hq_cleared", 2.5 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_set_delayed( message, delay )
{
	wait( delay );
	flag_set( message );
}

/*
=============
///ScriptDocBegin
"Name: flag_set( <flagname> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to set"
"Example: flag_set( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_set( message )
{
/#
	assertEx( isDefined( level.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[message] == level.flags_lock[message] );
	level.flags_lock[message] = true;
#/	
	level.flag[message] = true;
	level notify ( message );

	maps\_load::set_trigger_flag_permissions( message );
}

/*
=============
///ScriptDocBegin
"Name: flag_clear( <flagname> )"
"Summary: Clears the specified flag."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to clear"
"Example: flag_clear( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag_clear( message )
{
/#
	assertEx( isDefined( level.flag[message] ), "Attempt to set a flag before calling flag_init: " + message );
	assert( level.flag[message] == level.flags_lock[message] );
	level.flags_lock[message] = false;
#/	
	level.flag[message] = false;
	level notify ( message );

	maps\_load::set_trigger_flag_permissions( message );
}

/*
=============
///ScriptDocBegin
"Name: flag( <flagname> )"
"Summary: Checks if the flag is set. Returns true or false."
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname>: name of the flag to check"
"Example: flag( "hq_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flag( message )
{
	assertEx( isdefined( message ), "Tried to check flag but the flag was not defined." );
	assertEx( isdefined( level.flag[ message ] ), "Tried to check flag " + message + " but the flag was not initialized." );
	if ( !level.flag[message] )
		return false;

	return true;
}


_flag_wait_trigger( message, continuous )
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		flag_set( message );

		if ( !continuous )
			return;

		while ( other isTouching( self ) )
			wait ( 0.05 );
		
		flag_clear( messagE );
	}
}

/*
=============
///ScriptDocBegin
"Name: trigger_off()"
"Summary: Turns a trigger off so it can no longer be triggered."
"Module: Trigger"
"CallOn: A trigger"
"Example: trigger trigger_off();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
trigger_off()
{
	if ( !isDefined( self.realOrigin ) )
		self.realOrigin = self.origin;

	if ( self.origin == self.realorigin )
		self.origin += (0, 0, -10000);
	self.trigger_off = true;
}

/*
=============
///ScriptDocBegin
"Name: trigger_on()"
"Summary: Turns a trigger on. This only needs to be called if it was previously turned off"
"Module: Trigger"
"CallOn: A trigger"
"Example: trigger trigger_on();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
trigger_on()
{
	if ( isDefined( self.realOrigin ) )
		self.origin = self.realOrigin;
	self.trigger_off = undefined;
}


level_end_save()
{
	if ( level.missionfailed )
		return;

	if ( level.isSaving )
		return;

	if ( !isAlive( level.player ) )
		return;
		
	level.isSaving = true;
		
	imagename = "levelshots/autosave/autosave_" + level.script + "end";

	saveGame("levelend", &"AUTOSAVE_AUTOSAVE", imagename);
	
	level.isSaving = false;
}

/*
=============
///ScriptDocBegin
"Name: autosave_by_name( <savename> )"
"Summary: autosave the game with the specified save name"
"Module: Autosave"
"CallOn: "
"MandatoryArg: <savename>: name of the save file to create"
"Example: thread autosave_by_name( "building2_cleared" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
autosave_by_name( name )
{
	thread autosave_by_name_thread( name );
}

autosave_by_name_thread( name )
{
	if ( !isDefined( level.curAutoSave ) )
		level.curAutoSave = 1;
		
	imageName = "levelshots/autosave/autosave_" + level.script + level.curAutoSave;
	result = level maps\_autosave::tryAutoSave(level.curAutoSave, "autosave", imagename);
	if ( isDefined( result ) && result )
		level.curAutoSave++;
}


error( message )
{
	println ("^c*ERROR* ", message);
	wait 0.05;

/#
	if ( getDebugDvar( "debug" ) != "1" )
		assertMsg( "This is a forced error - attach the log file" );
#/
}

/*
=============
///ScriptDocBegin
"Name: array_thread( <entities>, <process>, <var1>, <var2>, <var3> )"
"Summary: Threads the <process> function on every entity in the <entities> array. The entity will become "self" in the specified function."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities>: array of entities to thread the process"
"MandatoryArg: <process>: pointer to a script function"
"OptionalArg: <var1>: parameter 1 to pass to the process"
"OptionalArg: <var2>: parameter 2 to pass to the process"
"OptionalArg: <var3>: parameter 3 to pass to the process"
"Example: array_thread( getaiarray( "allies" ), ::set_ignoreme, false );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_thread( entities, process, var1, var2, var3 )
{
	keys = getArrayKeys( entities );
	
	if ( isdefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1, var2, var3 );
			
		return;
	}

	if ( isdefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1, var2 );
			
		return;
	}

	if ( isdefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			entities[ keys[ i ] ] thread [[process]]( var1 );
			
		return;
	}

	for( i = 0 ; i < keys.size ; i++ )
		entities[ keys[ i ] ] thread [[process]]();
}

/*
=============
///ScriptDocBegin
"Name: array_levelthread( <entities>, <process>, <var1>, <var2>, <var3> )"
"Summary: Threads the <process> function for every entity in the <entities> array. The level calls the function and each entity of the array is passed as the first parameter to the process."
"Module: Array"
"CallOn: "
"MandatoryArg: <entities>: array of entities to thread the process"
"MandatoryArg: <process>: pointer to a script function"
"OptionalArg: <var1>: parameter 1 to pass to the process"
"OptionalArg: <var2>: parameter 2 to pass to the process"
"OptionalArg: <var3>: parameter 3 to pass to the process"
"Example: array_levelthread( getentarray( "palm", "targetname" ), ::palmTrees );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_levelthread( array, process, var1, var2, var3 )
{
	keys = getArrayKeys( array );
	
	if ( isdefined( var3 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			thread [[process]]( array[ keys[ i ] ], var1, var2, var3 );
			
		return;
	}

	if ( isdefined( var2 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			thread [[process]]( array[ keys[ i ] ], var1, var2 );
			
		return;
	}

	if ( isdefined( var1 ) )
	{
		for( i = 0 ; i < keys.size ; i++ )
			thread [[process]]( array[ keys[ i ] ], var1 );
			
		return;
	}

	for( i = 0 ; i < keys.size ; i++ )
		thread [[process]]( array[ keys[ i ] ] );
}



debug_message( message, origin, duration )
{
	if ( !isDefined( duration ) )
		duration = 5;
		
	for ( time = 0; time < (duration * 20) ; time++)
	{
		print3d( (origin + (0,0,45)), message, (0.48,9.4,0.76), 0.85 );
		wait 0.05;
	}
}


debug_message_clear( message, origin, duration, extraEndon )
{
	if ( isDefined( extraEndon ) )
	{
		level notify ( message + extraEndon );
		level endon ( message + extraEndon );
	}
	else
	{
		level notify ( message );
		level endon ( message );
	}
	
	if ( !isDefined( duration ) )
		duration = 5;
		
	for ( time = 0; time < (duration * 20) ; time++)
	{
		print3d ( (origin + (0, 0, 45)), message, (0.48,9.4,0.76), 0.85 );
		wait 0.05;
	}
}


chain_off( chain )
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
		else
			trigs[i].oldorigin = trigs[i].origin;

		trigs[i].origin = trigs[i].origin + (0,0,-5000);
	}
}


chain_on( chain )
{
	trigs = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigs.size;i++)
	if ((isdefined (trigs[i].script_chain)) && (trigs[i].script_chain == chain))
	{
		if (isdefined (trigs[i].oldorigin))
			trigs[i].origin = trigs[i].oldorigin;
	}
}


precache (model)
{
	ent = spawn ("script_model",(0,0,0));
	ent.origin = level.player getorigin();
	ent setmodel (model);
	ent delete();
}

/*
=============
///ScriptDocBegin
"Name: add_to_array( <array>, <ent> )"
"Summary: Adds <ent> to <array> and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: The array to add <ent> to."
"MandatoryArg: <ent>: The entity to be added."
"Example: nodes = add_to_array( nodes, new_node );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
add_to_array ( array, ent )
{
	if (!isdefined (ent))
		return array;

	if (!isdefined (array))
		array[0] = ent;
	else
		array[array.size] = ent;

	return array;
}

closerFunc( dist1, dist2 )
{
	return dist1 >= dist2;
}

fartherFunc( dist1, dist2 )
{
	return dist1 <= dist2;
}

/*
=============
///ScriptDocBegin
"Name: getClosest( <org>, <array>, <dist> )"
"Summary: Returns the closest entity in <array> to location <org>"
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on"
"OptionalArg: <dist>: Minimum distance to check"
"Example: friendly = getclosest( level.player.origin, allies );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
getClosest( org, array, dist )
{
	return compareSizes( org, array, dist, ::closerFunc);
}

/*
=============
///ScriptDocBegin
"Name: getClosestFx( <org>, <fxarray>, <dist> )"
"Summary: Returns the closest fx struct created by createfx in <fxarray> to location <org>"
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of createfx structs to check distance on. These are obtained with getfxarraybyID( <fxid> )"
"OptionalArg: <dist>: Minimum distance to check"
"Example: fxstruct = getClosestFx( hallway_tv, fxarray );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
getClosestFx( org, fxarray, dist )
{
	return compareSizesFx( org, fxarray, dist, ::closerFunc);
}

/*
=============
///ScriptDocBegin
"Name: getFarthest( <org>, <array>, <dist> )"
"Summary: Returns the farthest entity in <array> to location <org>"
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be farthest from."
"MandatoryArg: <array>: Array of entities to check distance on"
"OptionalArg: <dist>: Maximum distance to check"
"Example: target = getFarthest( level.player.origin, targets );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
getFarthest( org, array, dist )
{
	return compareSizes( org, array, dist, ::fartherFunc);
}

compareSizesFx(org, array, dist, compareFunc)
{
	if (!array.size)
		return undefined;
	if (isdefined(dist))
	{
		struct = undefined;
		keys = getArrayKeys( array );
		for ( i=0; i<keys.size; i++)
		{
			newdist = distance( array[ keys[i] ].v[ "origin" ], org);
			if ( [[ compareFunc ]]( newDist, dist ) )
				continue;
			dist = newdist;
			struct = array[ keys[i] ];
		}
		return struct;
	}

	keys = getArrayKeys( array );
	struct = array[ keys[0] ];
	dist = distance(struct.v[ "origin" ], org);
	for (i=1; i<keys.size; i++)
	{
		newdist = distance(array[ keys[i] ].v[ "origin" ], org);
		if ( [[ compareFunc ]]( newDist, dist ) )
			continue;
		dist = newdist;
		struct = array[ keys[i] ];
	}
	return struct;
}

compareSizes(org, array, dist, compareFunc)
{
	if (!array.size)
		return undefined;
	if (isdefined(dist))
	{
		ent = undefined;
		keys = getArrayKeys( array );
		for ( i=0; i<keys.size; i++)
		{
			newdist = distance( array[ keys[i] ].origin, org);
			if ( [[ compareFunc ]]( newDist, dist ) )
				continue;
			dist = newdist;
			ent = array[ keys[i] ];
		}
		return ent;
	}

	keys = getArrayKeys( array );
	ent = array[ keys[0] ];
	dist = distance(ent.origin, org);
	for (i=1; i<keys.size; i++)
	{
		newdist = distance(array[ keys[i] ].origin, org);
		if ( [[ compareFunc ]]( newDist, dist ) )
			continue;
		dist = newdist;
		ent = array[ keys[i] ];
	}
	return ent;
}

/*
=============
///ScriptDocBegin
"Name: get_closest_point( <origin>, <points>, <maxDist> )"
"Summary: Returns the closest point from array <points> from location <origin>"
"Module: Distance"
"CallOn: "
"MandatoryArg: <origin>: Origin to be closest to."
"MandatoryArg: <points>: Array of points to check distance on"
"OptionalArg: <maxDist>: Maximum distance to check"
"Example: target = getFarthest( level.player.origin, targets );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_closest_point( origin, points, maxDist )
{
	assert( points.size );
		
	closestPoint = points[0];
	dist = distance( origin, closestPoint );
	
	for ( index = 0; index < points.size; index++ )
	{
		testDist = distance( origin, points[index] );
		if ( testDist >= dist )
			continue;
			
		dist = testDist;
		closestPoint = points[index];
	}
	
	if ( !isDefined( maxDist ) || dist <= maxDist )
		return closestPoint;
		
	return undefined;		
}


/*
=============
///ScriptDocBegin
"Name: get_within_range( <org>, <array>, <dist> )"
"Summary: Returns all elements from the array that are within DIST range to ORG."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on"
"OptionalArg: <dist>: Maximum distance to check"
"Example: close_ai = get_within_range( level.player.origin, ai, 500 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_within_range( org, array, dist )
{
	guys = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( distance( array[ i ].origin, org ) <= dist )
			guys[ guys.size ] = array[ i ];
	}
	return guys;
}

/*
=============
///ScriptDocBegin
"Name: get_outisde_range( <org>, <array>, <dist> )"
"Summary: Returns all elements from the array that are outside DIST range to ORG."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on"
"OptionalArg: <dist>: Maximum distance to check"
"Example: close_ai = get_outside_range( level.player.origin, ai, 500 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_outside_range( org, array, dist )
{
	guys = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( distance( array[ i ].origin, org ) > dist )
			guys[ guys.size ] = array[ i ];
	}
	return guys;
}

/*
=============
///ScriptDocBegin
"Name: get_closest_living( <org>, <array>, <dist> )"
"Summary: Returns the closest living entity from the array from the origin"
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on"
"OptionalArg: <dist>: Maximum distance to check"
"Example: kicker = get_closest_living( node.origin, ai );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_closest_living(org, array, dist)
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	ent = undefined;		
	for (i=0;i<array.size;i++)
	{
		if (!isalive(array[i]))
			continue;
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		ent = array[i];
	}
	return ent;
}

get_highest_dot(start, end, array)
{
	if (!array.size)
		return;
	
	ent = undefined;		
	
	angles = vectorToAngles(end - start);
	dotforward = anglesToForward(angles);
	dot = -1;
	for (i=0;i<array.size;i++)
	{
		angles = vectorToAngles(array[i].origin - start);
		forward = anglesToForward(angles);
		
		newdot = vectordot(dotforward, forward);
		if (newdot < dot)
			continue;
		dot = newdot;
		ent = array[i];
	}
	return ent;
}

/*
=============
///ScriptDocBegin
"Name: get_closest_index( <org>, <array>, <dist> )"
"Summary: same as getClosest but returns the closest entity's array index instead of the actual entity."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on."
"OptionalArg: <dist>: Maximum distance to check"
"Example: "
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_closest_index( org, array, dist )
{
	if(!isdefined(dist))
		dist = 9999999;
	if (array.size < 1)
		return;
	index = undefined;		
	for (i=0;i<array.size;i++)
	{
		newdist = distance(array[i].origin, org);
		if (newdist >= dist)
			continue;
		dist = newdist;
		index = i;
	}
	return index;
}

get_closest_exclude (org, ents, excluders)
{
	if (!isdefined (ents))
		return undefined;

	range = 0;
	if (isdefined (excluders) && excluders.size)
	{
		exclude = [];
		for (i=0;i<ents.size;i++)
			exclude[i] = false;

		for (i=0;i<ents.size;i++)
		for (p=0;p<excluders.size;p++)
		if (ents[i] == excluders[p])
			exclude[i] = true;

		found_unexcluded = false;
		for (i=0;i<ents.size;i++)
		if ((!exclude[i]) && (isdefined (ents[i])))
		{
			found_unexcluded = true;
			range = distance (org, ents[i].origin);
			ent = i;
			i = ents.size + 1;
		}

		if (!found_unexcluded)
			return (undefined);
	}
	else
	{
		for (i=0;i<ents.size;i++)
		if (isdefined (ents[i]))
		{
			range = distance (org, ents[0].origin);
			ent = i;
			i = ents.size + 1;
		}
	}

	ent = undefined;

	for (i=0;i<ents.size;i++)
	if (isdefined (ents[i]))
	{
		exclude = false;
		if (isdefined (excluders))
		{
			for (p=0;p<excluders.size;p++)
			if (ents[i] == excluders[p])
				exclude = true;
		}

		if (!exclude)
		{
			newrange = distance (org, ents[i].origin);
			if (newrange <= range)
			{
				range = newrange;
				ent = i;
			}
		}
	}

	if (isdefined (ent))
		return ents[ent];
	else
		return undefined;
}

/*
=============
///ScriptDocBegin
"Name: get_closest_ai( <org>, <team> )"
"Summary: Returns the closest AI of the specified team to the specified origin."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <team>: Team to use. Can be "allies", "axis", or "both"."
"Example: friendly = get_closest_ai( level.player.origin, "allies" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_closest_ai( org, team )
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return getClosest( org, ents );
}

/*
=============
///ScriptDocBegin
"Name: get_array_of_closest( <org>, <array>, <excluders>, <max> )"
"Summary: Returns an array of all the entities in <array> sorted in order of closest to farthest."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org>: Origin to be closest to."
"MandatoryArg: <array>: Array of entities to check distance on."
"OptionalArg: <excluders>: Array of entities to exclude from the check."
"OptionalArg: <max>: Max size of the array to return"
"Example: allies_sort = get_array_of_closest( originFC1.origin, allies );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
get_array_of_closest( org, array, excluders, max )
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	if (!isdefined(max))
		max = array.size;
	if (!isdefined(excluders))
		excluders = [];

	// return the array, reordered from closest to farthest
	dist = [];
	index = [];
	for (i=0;i<array.size;i++)
	{
		excluded = false;
		for (p=0;p<excluders.size;p++)
		{
			if (array[i] != excluders[p])
				continue;
			excluded = true;
			break;
		}
		if (excluded)
			continue;
			
		dist[dist.size] = distance(org, array[i].origin);
		index[index.size] = i;
	}
		
	for (;;)
	{
		change = false;
		for (i=0;i<dist.size-1;i++)
		{
			if (dist[i] <= dist[i+1])
				continue;
			change = true;
			temp = dist[i];
			dist[i] = dist[i+1];
			dist[i+1] = temp;
			temp = index[i];
			index[i] = index[i+1];
			index[i+1] = temp;
		}
		if (!change)
			break;
	}
	
	newArray = [];
	if (max > dist.size)
		max = dist.size;
	for (i=0;i<max;i++)
		newArray[i] = array[index[i]];
	return newArray;
}

get_closest_ai_exclude (org, team, excluders)
{
	if (isdefined (team))
		ents = getaiarray (team);
	else
		ents = getaiarray ();

	if (ents.size == 0)
		return undefined;

	return get_closest_exclude (org, ents, excluders);
}

/*
=============
///ScriptDocBegin
"Name: stop_magic_bullet_shield()"
"Summary: Stops magic bullet shield on an AI, setting his health back to a normal value and making him vulnerable to death."
"Module: AI"
"CallOn: AI"
"Example: friendly stop_magic_bullet_shield();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

stop_magic_bullet_shield()
{
	assertEx( isdefined( self.magic_bullet_shield ) && self.magic_bullet_shield, "Tried to stop magic bullet shield on a guy without magic bulletshield" );
	self notify( "stop magic bullet shield" );
}

magic_bullet_death_detection()
{
	self endon( "stop magic bullet shield" );
	export = self.export;
	self waittill( "death" );
	if ( isdefined( self ) )
		assertEx( 0, "Magic bullet shield guy with export " + export + " died some how." );
	else
		assertEx( 0, "Magic bullet shield guy with export " + export + " died, most likely deleted from spawning guys." );
	
}

/*
=============
///ScriptDocBegin
"Name: magic_bullet_shield( <health>, <time>, <oldhealth>, <maxhealth_modifier> )"
"Summary: Makes an AI invulnerable to death. When he gets shot, he is ignored by enemies for <time> seconds and his health is regenerated."
"Module: AI"
"CallOn: AI"
"OptionalArg: <health>: Health to set on the AI while in magic_bullet_shield. Default is 100000000."
"OptionalArg: <time>: Time in seconds that the AI will be ignored after taking damage. Default is 5 seconds."
"OptionalArg: <oldhealth>: Health to give the AI when magic bullet shield is turned off. Default is the AI's health value when magic_bullet_shield is called."
"OptionalArg: <maxhealth_modifier>: Multiplier for the AI's .maxhealth while in magic_bullet_shiled mode. Modifies the color the friendly name will be. This is rarely set, but sometimes used for scripted sequences."
"Example: friendly magic_bullet_shield();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

magic_bullet_shield( health, time, oldhealth, maxhealth_modifier )
{
	thread magic_bullet_shield_thread( health, time, oldhealth, maxhealth_modifier );
}

magic_bullet_shield_thread( health, time, oldhealth, maxhealth_modifier )
{
		// clear out any existing shields and then wait for them to clear
	self notify( "stop magic bullet shield" );
	waittillframeend;
	
	if( !isdefined( self ) )
		return;
	
	self endon( "stop magic bullet shield" );
	self endon( "death" );
	
	if (!isdefined (maxhealth_modifier))
		maxhealth_modifier = 1;
	
	if (!isdefined (oldhealth))
		oldhealth = self.health;

	self.a.disableLongDeath = true;

	anim_nextStandingHitDying = self.a.nextStandingHitDying;		
	self.a.nextStandingHitDying = false;
	
	/#
	thread magic_bullet_death_detection();
	#/

	self thread stop_magic_bullet_shield_on_notify( oldhealth, anim_nextStandingHitDying );
	self.magic_bullet_shield = true;
	if (!isdefined (time))
		time = 5;

	if (!isdefined (health))
		health = 100000000;
		
	assertEx(health >= 5000, "MagicBulletShield shouldnt be set with low health amounts like < 5000");
	
	while (1)
	{
		self.health = health;
		self.maxhealth = (self.health * maxhealth_modifier);
		oldHealth = self.health;
		self waittill ("pain");
		if (oldHealth == self.health ) // the game spams pain notify every frame while a guy is in pain script
			continue;
			
		assertEx(self.health > 1000, "Magic bullet shield guy got impossibly low health");
		self thread ignore_me_timer(time);
	}
}



get_ignoreme()
{
	return self.ignoreme;
}

set_ignoreme( val )
{
	assertEx( isSentient( self ), "Non ai tried to set ignoreme" );
	self.ignoreme = val;
}

set_ignoreall( val )
{
	assertEx( isSentient( self ), "Non ai tried to set ignoraell" );
	self.ignoreall = val;
}

get_pacifist()
{
	return self.pacifist;
}

set_pacifist( val )
{
	assertEx( isSentient( self ), "Non ai tried to set pacifist" );
	self.pacifist = val;
}

ignore_me_timer(time)
{
	ai = getaiarray( "axis" );
	// force my enemy to acquire a new enemy
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isalive( guy.enemy ) )
			continue;
		if ( guy.enemy != self )
			continue;
		guy notify( "enemy" );
	}
	self endon( "death" );
	self endon( "pain" );
	self.ignoreme = true;
	wait( time );
	self.ignoreme = false;
}

/*
=============
///ScriptDocBegin
"Name: array_randomize( <array> )"
"Summary: Randomizes the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: Array to be randomized."
"Example: roof_nodes = array_randomize( roof_nodes );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_randomize( array )
{
    for (i = 0; i < array.size; i++)
    {
        j = randomint(array.size);
        temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
    return array;
}
/*
=============
///ScriptDocBegin
"Name: array_reverse( <array> )"
"Summary: Reverses the order of the array and returns the new array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: Array to be reversed."
"Example: patrol_nodes = array_reverse( patrol_nodes );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_reverse(array)
{
	array2 = [];
	for(i = array.size-1; i >= 0; i--)
		array2[array2.size] = array[i];
	return array2;
}

exploder_damage ()
{
	if (isdefined(self.v["delay"]))
		delay = self.v["delay"];
	else
		delay = 0;
		
	if (isdefined (self.v["damage_radius"]))
		radius = self.v["damage_radius"];
	else
		radius = 128;

	damage = self.v["damage"];
	origin = self.v["origin"];
	
	wait (delay);
	// Range, max damage, min damage
	radiusDamage (origin, radius, damage, damage);
}

exploder( num )
{
	[[level.exploderFunction]]( num );
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

activate_exploder (num)
{
	num = int(num);
	for (i=0;i<level.createFXent.size;i++)
	{
		ent = level.createFXent[i];
		if (!isdefined (ent))
			continue;
	
		if (ent.v["type"] != "exploder")
			continue;	
	
		// make the exploder actually removed the array instead?
		if (!isdefined(ent.v["exploder"]))
			continue;

		if (ent.v["exploder"] != num)
			continue;

		if (isdefined (ent.v["firefx"]))
			ent thread fire_effect();

		if ( isdefined ( ent.v["fxid"] ) && ent.v["fxid"] != "No FX" )
			ent thread cannon_effect();
		else
		if (isdefined (ent.v["soundalias"]))
			ent thread sound_effect();

		if (isdefined (ent.v["damage"]))
			ent thread exploder_damage();

		if (isdefined (ent.v["earthquake"]))
		{
			eq = ent.v["earthquake"];
			earthquake(level.earthquake[eq]["magnitude"],
						level.earthquake[eq]["duration"],
						ent.v["origin"],
						level.earthquake[eq]["radius"]);
		}

		if (ent.v["exploder_type"] == "exploder")
			ent thread brush_show();
		else
		if ((ent.v["exploder_type"] == "exploderchunk") || (ent.v["exploder_type"] == "exploderchunk visible"))
			ent thread brush_throw();
		else
			ent thread brush_delete();
	}

/*
	for (i=0;i<level.createFXent.size;i++)
	{
		ent = level.createFXent[i];
		if (!isdefined (ent))
			continue;
		if (ent.v["exploder"] != num)
			continue;
		ent thread brush_delete();
	}
*/
}

sound_effect ()
{
	self effect_soundalias();
}

effect_soundalias ( )
{
	if (!isdefined (self.v["delay"]))
		self.v["delay"] = 0;
	
	// save off this info in case we delete the effect
	origin = self.v["origin"];
	alias = self.v["soundalias"];
	wait (self.v["delay"]);
	play_sound_in_space ( alias, origin );
}

cannon_effect ()
{
	if ( !isdefined( self.v["delay"] ) )
		self.v["delay"] = 0;

	min_delay = self.v["delay"];
	max_delay = self.v["delay"] + 0.001; // cant randomfloatrange on the same #
	if ( isdefined(self.v["delay_min"]) )
		min_delay = self.v["delay_min"];

	if ( isdefined(self.v["delay_max"]) )
		max_delay = self.v["delay_max"];

	if ( min_delay > 0 )
		wait ( randomfloatrange( min_delay, max_delay ) );

	if ( isdefined( self.v["repeat"] ) )
	{
		for (i=0;i<self.v["repeat"];i++)
		{
			playfx( level._effect[ self.v["fxid"] ], self.v["origin"], self.v["forward"], self.v["up"] );
			exploder_playSound();

			if ( min_delay > 0 )
				wait ( randomfloatrange ( min_delay, max_delay ) );
		}
		return;
	}

	playfx( level._effect[ self.v["fxid"] ], self.v["origin"], self.v["forward"], self.v["up"] );
	exploder_playSound();
}

exploder_playSound( )
{
	if ( !isdefined( self.v[ "soundalias" ] ) || self.v[ "soundalias" ] == "nil" )
		return;
	
	play_sound_in_space ( self.v["soundalias"], self.v["origin"] );
}

fire_effect ( )
{
	if (!isdefined (self.v["delay"]))
		self.v["delay"] = 0;

	delay = self.v["delay"];
	if ((isdefined (self.v["delay_min"])) && (isdefined (self.v["delay_max"])))
		delay = self.v["delay_min"] + randomfloat (self.v["delay_max"] - self.v["delay_min"]);

	forward = self.v["forward"];
	up = self.v["up"];

	org = undefined;

	firefxSound = self.v["firefxsound"];
	origin = self.v["origin"];
	firefx = self.v["firefx"];
	ender = self.v["ender"];
	if (!isdefined (ender))
		ender = "createfx_effectStopper";
	timeout = self.v["firefxtimeout"];

	fireFxDelay = 0.5;
	if (isdefined (self.v["firefxdelay"]))
		fireFxDelay = self.v["firefxdelay"];

	wait (delay);

	if (isdefined (firefxSound))	
		level thread loop_fx_sound ( firefxSound, origin, ender, timeout );

	playfx ( level._effect[firefx], self.v["origin"], forward, up );

//	loopfx(				fxId,	fxPos, 	waittime,	fxPos2,	fxStart,	fxStop,	timeout)
//	maps\_fx::loopfx(	firefx,	origin,	delay,		org,	undefined,	ender,	timeout);
}

loop_sound_delete ( ender, ent )
{
	ent endon ("death");
	self waittill (ender);
	ent delete();
}

loop_fx_sound ( alias, origin, ender, timeout )
{
	org = spawn ("script_origin",(0,0,0));
	if ( isdefined( ender ) )
	{
		thread loop_sound_delete (ender, org);
		self endon( ender );
	}
	org.origin = origin;
	org playloopsound (alias);
	if (!isdefined (timeout))
		return;
		
	wait (timeout);
//	org delete();
}

brush_delete()
{
//		if (ent.v["exploder_type"] != "normal" && !isdefined (ent.v["fxid"]) && !isdefined (ent.v["soundalias"]))
//		if (!isdefined (ent.script_fxid))

	num = self.v["exploder"];
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);
	else
		wait (.05); // so it disappears after the replacement appears

	if (!isdefined( self.model ))
		return;


	assert(isdefined(self.model));

	if (self.model.spawnflags & 1)
		self.model connectpaths();

	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;
			
		self.exploded = true;
		self.model hide();
		self.model notsolid();
		
		wait (3);
		self.exploded = undefined;
		self.model show();
		self.model solid();
		return;
	}

	if (!isdefined( self.v["fxid"] ) || self.v["fxid"] == "No FX" )
		self.v["exploder"] = undefined;
		
	waittillframeend; // so it hides stuff after it shows the new stuff
	self.model delete();
}

brush_show()
{
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);
	
	assert(isdefined(self.model));
	
	self.model show();
	self.model solid();
		
	if (self.model.spawnflags & 1)
	{
		if (!isdefined(self.model.disconnect_paths))
			self connectpaths();
		else
			self disconnectpaths();
	}

	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;

		self.exploded = true;
		wait (3);
		self.exploded = undefined;
		self.model hide();
		self.model notsolid();
	}
}

brush_throw()
{
	if (isdefined (self.v["delay"]))
		wait (self.v["delay"]);

	ent = undefined;
	if (isdefined (self.v["target"]))
		ent = getent (self.v["target"],"targetname");

	if (!isdefined (ent))
	{
		self.model delete();
		return;
	}

	self.model show();

	startorg = self.v["origin"];
	startang = self.v["angles"];
	org = ent.origin;


	temp_vec = ( org - self.v["origin"] );
	x = temp_vec[0];
	y = temp_vec[1];
	z = temp_vec[2];

	self.model rotateVelocity ((x,y,z), 12);

	self.model moveGravity ((x, y, z), 12);
	if (level.createFX_enabled)
	{
		if ( isdefined( self.exploded ) )
			return;

		self.exploded = true;
		wait (3);
		self.exploded = undefined;
		self.v["origin"] = startorg;
		self.v["angles"] = startang;
		self.model hide();
		return;
	}
	
	self.v["exploder"] = undefined;
	wait (6);
	self.model delete();
//	self delete();
}

flood_spawn( spawners )
{
	maps\_spawner::flood_spawner_scripted( spawners );
}

vector_multiply (vec, dif)
{
	vec = (vec[0] * dif, vec[1] * dif, vec[2] * dif);
	return vec;
}

set_ambient (track)
{
	level.ambient = track;
	if ((isdefined (level.ambient_track)) && (isdefined (level.ambient_track[track])))
	{
		ambientPlay (level.ambient_track[track], 2);
		println ("playing ambient track ", track);
	}
}

random (array)
{
	return array [randomint (array.size)];
}

get_friendly_chain_node (chainstring)
{
	chain = undefined;
	trigger = getentarray ("trigger_friendlychain","classname");
	for (i=0;i<trigger.size;i++)
	{
		if ((isdefined (trigger[i].script_chain)) && (trigger[i].script_chain == chainstring))
		{
			chain = trigger[i];
			break;
		}
	}

	if (!isdefined (chain))
	{
/#
		maps\_utility::error ("Tried to get chain " + chainstring + " which does not exist with script_chain on a trigger.");
#/
		return undefined;
	}

	node = getnode (chain.target,"targetname");
	return node;
}

shock_ondeath()
{
	precacheShellshock("default");
	self waittill ("death");
	
	if ( isdefined( self.specialDeath ) )
		return;
	
	if (getdvar ("r_texturebits") == "16")
		return;
	self shellshock("default", 3);
}

delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}

/*
=============
///ScriptDocBegin
"Name: play_sound_on_tag( <alias>, <tag> )"
"Summary: Play the specified sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias>: Sound alias to play"
"OptionalArg: <tag>: Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"Example: vehicle thread play_sound_on_tag( "horn_honk" , "tag_engine" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_sound_on_tag (alias, tag)
{
	if ((isSentient (self)) && (!isalive (self)))
		return;

	org = spawn ("script_origin",(0,0,0));
	org endon ("death");

	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}

	org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}

/*
=============
///ScriptDocBegin
"Name: play_sound_on_entity( <alias> )"
"Summary: Play the specified sound alias on an entity at it's origin"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias>: Sound alias to play"
"Example: level.player play_sound_on_entity( "breathing_better" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_sound_on_entity( alias )
{
	play_sound_on_tag (alias);
}

/*
=============
///ScriptDocBegin
"Name: play_loop_sound_on_tag( <alias>, <tag> )"
"Summary: Play the specified looping sound alias on a tag of an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias>: Sound alias to loop"
"OptionalArg: <tag>: Tag on the entity to play sound on. If no tag is specified the entities origin will be used."
"Example: vehicle thread play_loop_sound_on_tag( "engine_belt_run" , "tag_engine" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_loop_sound_on_tag(alias, tag)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (tag))
		org linkto (self, tag, (0,0,0), (0,0,0));
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

/*
=============
///ScriptDocBegin
"Name: stop_loop_sound_on_entity( <alias> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias>: Sound alias to stop looping"
"Example: vehicle thread stop_loop_sound_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
stop_loop_sound_on_entity( alias )
{
	self notify ("stop sound" + alias);
}

/*
=============
///ScriptDocBegin
"Name: play_loop_sound_on_entity( <alias>, <offset> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: An entity"
"MandatoryArg: <alias>: Sound alias to loop"
"OptionalArg: <offset>: Offset for sound origin relative to the world from the models origin."
"Example: vehicle thread play_loop_sound_on_entity( "engine_belt_run" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
	org stoploopsound (alias);
	org delete();
}

/*
=============
///ScriptDocBegin
"Name: play_sound_in_space( <alias>, <origin>, <master> )"
"Summary: Stop playing the the loop sound alias on an entity"
"Module: Sound"
"CallOn: Level"
"MandatoryArg: <alias>: Sound alias to play"
"MandatoryArg: <origin>: Origin of the sound"
"OptionalArg: <master>: Play this sound as a master sound. Defaults to false"
"Example: play_sound_in_space( "siren", level.speaker.origin );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
play_sound_in_space (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias, "sounddone");
	else
		org playsound (alias, "sounddone");
	org waittill ("sounddone");
	org delete();
}

lookat (ent, timer)
{
	if (!isdefined (timer))
		timer = 10000;

	self animscripts\shared::lookatentity(ent, timer, "alert");
}

save_friendlies()
{
	ai = getaiarray ("allies");
	game_characters = 0;
	for (i=0;i<ai.size;i++)
	{
		if (isdefined (ai[i].script_friendname))
			continue;

//		attachsize =
//		println ("attachSize = ", self getAttachSize());

		game["character" + game_characters] = ai[i] codescripts\character::save();
		game_characters++;
	}

	game["total characters"] = game_characters;
}

load_friendlies()
{
	if (isdefined (game["total characters"]))
	{
		game_characters = game["total characters"];
		println ("Loading Characters: ", game_characters);
	}
	else
	{
		println ("Loading Characters: None!");
		return;
	}

	ai = getaiarray ("allies");
	total_ai = ai.size;
	index_ai = 0;

	spawners = getspawnerteamarray ("allies");
	total_spawners = spawners.size;
	index_spawners = 0;

	while (1)
	{
		if (((total_ai <= 0) && (total_spawners <= 0)) || (game_characters <= 0))
			return;

		if (total_ai > 0)
		{
			if (isdefined (ai[index_ai].script_friendname))
			{
				total_ai--;
				index_ai++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			ai[index_ai] codescripts\character::new();
			ai[index_ai] thread codescripts\character::load(game["character" + (game_characters-1)]);
			total_ai--;
			index_ai++;
			game_characters--;
			continue;
		}

		if (total_spawners > 0)
		{
			if (isdefined (spawners[index_spawners].script_friendname))
			{
				total_spawners--;
				index_spawners++;
				continue;
			}

			println ("Loading character.. ", game_characters);
			info = game["character" + (game_characters-1)];
			precache (info ["model"]);
			precache (info ["model"]);
			spawners[index_spawners] thread spawn_setcharacter (game["character" + (game_characters-1)]);
			total_spawners--;
			index_spawners++;
			game_characters--;
			continue;
		}
	}
}

/*
=============
///ScriptDocBegin
"Name: spawn_failed( <spawn> )"
"Summary: Checks to see if the spawned AI spawned correctly or had errors. Also waits until all spawn initialization is complete. Returns true or false."
"Module: AI"
"CallOn: "
"MandatoryArg: <spawn>: The actor that just spawned"
"Example: spawn_failed( level.price );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
spawn_failed (spawn)
{
	if (!isalive (spawn))
		return true;
	if (!isdefined (spawn.finished_spawning))
		spawn waittill ("finished spawning");

	if (isalive (spawn))
		return false;

	return true;
}

spawn_setcharacter (data)
{
	codescripts\character::precache(data);

	self waittill ("spawned",spawn);
	if (maps\_utility::spawn_failed(spawn))
		return;

	println ("Size is ", data["attach"].size);
	spawn codescripts\character::new();
	spawn codescripts\character::load(data);
}

key_hint_print(message, binding)
{
	// Note that this will insert only the first bound key for the action
	iprintlnbold(message, binding["key1"]);
}

view_tag( tag )
{
	self endon( "death" );
	for ( ;; )
	{
		maps\_debug::drawTag( tag );
		wait( 0.05 );
	}
}

assign_animtree()
{
	assertEx( isdefined( level.scr_animtree[ self.animname ] ), "There is no level.scr_animtree for animname " + self.animname );
	self UseAnimTree( level.scr_animtree[ self.animname ] );
}

assign_model()
{
	assertEx( isdefined( level.scr_model[ self.animname ] ), "There is no level.scr_model for animname " + self.animname );
	self setmodel( level.scr_model[ self.animname ] );
}

/*
=============
///ScriptDocBegin
"Name: spawn_anim_model( <animname> )"
"Summary: Spawns a script model and gives it the animtree and model associated with that animname"
"Module: _anim"
"MandatoryArg: <animname>: Name of the animname from this map_anim.gsc."
"Example: model = spawn_anim_model( "player_rappel" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

spawn_anim_model( animname )
{
	model = spawn( "script_model", (0,0,0) );
	model.animname = animname;
	model assign_animtree();
	model assign_model();
	return model;
}

/*
=============
///ScriptDocBegin
"Name: trigger_wait( <strName>, <strKey> )"
"Summary: Waits until a trigger with the specified key/value is triggered"
"Module: Trigger"
"CallOn: "
"MandatoryArg: <strName>: Name of the key on this trigger"
"MandatoryArg: <strKey>: Key on the trigger to use, example: "targetname" or "script_noteworthy""
"Example: trigger_wait( "player_in_building1, "targetname" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
trigger_wait (strName, strKey)
{
	eTrigger = getent (strName, strKey);
	if (!isdefined (eTrigger))
	{
		assertmsg ("trigger not found: " + strName + " key: " + strKey);
		return;
	}
	eTrigger waittill ("trigger", eOther);
	level notify (strName, eOther);
	return eOther;
}

/*
=============
///ScriptDocBegin
"Name: set_flag_on_trigger( <eTrigger>, <strFlag> )"
"Summary: Calls flag_set to set the specified flag when the trigger is triggered"
"Module: Trigger"
"CallOn: "
"MandatoryArg: <eTrigger>: trigger entity to use"
"MandatoryArg: <strFlag>: name of the flag to set"
"Example: set_flag_on_trigger( trig, "player_is_outside" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_flag_on_trigger( eTrigger, strFlag )
{
	if (!level.flag[strFlag])
	{
		eTrigger waittill ("trigger", eOther);
		flag_set(strFlag);
		return eOther;
	}
}

/*
=============
///ScriptDocBegin
"Name: set_flag_on_targetname_trigger( <flag> )"
"Summary: Sets the specified flag when a trigger with targetname <flag> is triggered."
"Module: Trigger"
"CallOn: "
"MandatoryArg: <flag>: name of the flag to set, and also the targetname of the trigger to use"
"Example:  set_flag_on_targetname_trigger( "player_is_outside" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
set_flag_on_targetname_trigger( msg )
{
	assert( isdefined( level.flag[ msg ] ) );
	if ( flag( msg ) )
		return;
		
	trigger = getent( msg, "targetname" );
	trigger waittill( "trigger" );
	flag_set( msg );
}

/*
=============
///ScriptDocBegin
"Name: is_in_array( <aeCollection>, <eFindee> )"
"Summary: Returns true if <eFindee> is an entity in array <aeCollection>. False if it is not. "
"Module: Array"
"CallOn: "
"MandatoryArg: <aeCollection>: array of entities to search through"
"MandatoryArg: <eFindee>: entity to check if it's in the array"
"Example: qBool = is_in_array( eTargets, vehicle1 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
is_in_array (aeCollection, eFindee)
{
	for (i = 0; i < aeCollection.size; i++)
	{
		if (aeCollection[i] == eFindee)
			return (true);
	}
	
	return (false);
}

/*
=============
///ScriptDocBegin
"Name: waittill_dead( <guys>, <num>, <timeoutLength> )"
"Summary: Waits until all the AI in array <guys> are dead."
"Module: AI"
"CallOn: "
"MandatoryArg: <guys>: Array of actors to wait until dead"
"OptionalArg: <num>: Number of guys that must die for this function to continue"
"OptionalArg: <timeoutLength>: Number of seconds before this function times out and continues"
"Example: waittill_dead( getaiarray( "axis" ) );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
waittill_dead(guys, num, timeoutLength)
{
	// verify the living-ness of the ai
	allAlive = true;
	for (i=0;i<guys.size;i++)
	{
		if (isalive(guys[i]))
			continue;
		allAlive = false;
		break;
	}
	assertEx (allAlive, "Waittill_Dead was called with dead or removed AI in the array, meaning it will never pass.");
	if (!allAlive)
	{	
		newArray = [];
		for (i=0;i<guys.size;i++)
		{
			if (isalive(guys[i]))
				newArray[newArray.size] = guys[i];
		}
		guys = newArray;
	}

	ent = spawnStruct();
	if (isdefined (timeoutLength))
	{
		ent endon ("thread timed out");
		ent thread waittill_dead_timeout(timeoutLength);
	}
	
	ent.count = guys.size;
	if (isdefined (num) && num < ent.count)
		ent.count = num;
	array_thread(guys, ::waittill_dead_thread, ent);
	
	while (ent.count > 0)
		ent waittill ("waittill_dead guy died");
}

waittill_dead_thread(ent)
{
	self waittill ("death");
	ent.count--;
	ent notify ("waittill_dead guy died");
}

waittill_dead_timeout(timeoutLength)
{
	wait (timeoutLength);
	self notify ("thread timed out");
}

waittill_aigroupcleared( aigroup )
{
	while( level._ai_group[aigroup].spawnercount || level._ai_group[aigroup].aicount )
		wait ( 0.25 );
}

get_ai_group_count( aigroup )
{
	return ( level._ai_group[aigroup].spawnercount + level._ai_group[aigroup].aicount );
}

get_ai_group_sentient_count( aigroup )
{
	return ( level._ai_group[aigroup].aicount );
}

get_ai_group_ai( aigroup )
{
	aiSet = [];
	for ( index = 0; index < level._ai_group[aigroup].ai.size; index++ )
	{
		if ( !isAlive( level._ai_group[aigroup].ai[index] ) )
			continue;
			
		aiSet[aiSet.size] = level._ai_group[aigroup].ai[index];
	}
	
	return ( aiSet );
}

// Creates an event based on this message if none exists, and sets it to true after the delay.
gather_delay_proc(msg, delay)
{
	if (isdefined (level.gather_delay[msg]))
	{
		if (level.gather_delay[msg])
		{
			wait (0.05);
			if (isalive (self))
				self notify ("gather_delay_finished" + msg + delay);
			return;
		}
		
		level waittill (msg);
		if (isalive (self))
			self notify ("gather_delay_finished" + msg + delay);
		return;
	}
	
	level.gather_delay[msg] = false;
	wait (delay);
	level.gather_delay[msg] = true;
	level notify (msg);
	if (isalive (self))
		self notify ("gather_delay_finished" + msg + delay);
}

gather_delay(msg, delay)
{
	thread gather_delay_proc(msg, delay);
	self waittill ("gather_delay_finished" + msg + delay);
}

set_environment(env)
{
	animscripts\utility::setEnv(env);
}

death_waiter(notifyString)
{
	self waittill ("death");
	level notify (notifyString);
}

getchar(num)
{
	if (num == 0)
		return "0";
	if (num == 1)
		return "1";
	if (num == 2)
		return "2";
	if (num == 3)
		return "3";
	if (num == 4)
		return "4";
	if (num == 5)
		return "5";
	if (num == 6)
		return "6";
	if (num == 7)
		return "7";
	if (num == 8)
		return "8";
	if (num == 9)
		return "9";
}

waittill_either( msg1, msg2 )
{
	self endon( msg1 );
	self waittill( msg2 );
}

/*
=============
///ScriptDocBegin
"Name: player_god_on()"
"Summary: Puts the player in god mode. Player takes damage but will never die."
"Module: Player"
"CallOn: "
"Example: thread player_god_on();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
player_god_on()
{
	thread player_god_on_thread();
}

player_god_on_thread()
{
	level.player endon ("godoff");
	level.player.oldhealth = level.player.health;
	
	for (;;)
	{
		level.player waittill ("damage");
		level.player.health = 10000;
	}	
}

/*
=============
///ScriptDocBegin
"Name: player_god_off()"
"Summary: Remove god mode from player. Player will be vulnerable to death again."
"Module: Player"
"CallOn: "
"Example: thread player_god_off();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
player_god_off()
{
	level.player notify ("godoff");
	assert(isdefined(level.player.oldhealth));
	level.player.health = level.player.oldhealth;
}


getlinks_array( array, linkMap )  //don't pass stuff through as an array of struct.linkname[] but only linkMap[]
{
	ents = [];
	for ( j = 0; j < array.size; j++ )
	{
		node = array[j];
		script_linkname = node.script_linkname;
		if ( !isdefined( script_linkname ) )
			continue;
		if ( !isdefined( linkMap[script_linkname] ) )
			continue;
		ents[ents.size] = node;
	}
	return ents;
}

// Adds only things that are new to the array.
// Requires the arrays to be of node with script_linkname defined.
array_merge_links( array1, array2 )
{
	if ( !array1.size )
		return array2;
	if ( !array2.size )
		return array1;

	linkMap = [];

	for ( i = 0; i < array1.size; i++ )
	{
		node = array1[i];
		linkMap[node.script_linkname] = true;
	}

	for ( i = 0; i < array2.size; i++ )
	{
		node = array2[i];
		if ( isdefined( linkMap[node.script_linkname] ) )
			continue;
		linkMap[node.script_linkname] = true;
		array1[array1.size] = node;
	}

	return array1;
}

/*
=============
///ScriptDocBegin
"Name: array_combine( <array1>, <array2> )"
"Summary: Combines the two arrays and returns the resulting array. This function doesn't care if it produces duplicates in the array."
"Module: Array"
"CallOn: "
"MandatoryArg: <array1>: first array"
"MandatoryArg: <array2>: second array"
"Example: combinedArray = array_combine( array1, array2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_combine(array1,array2)
{
	if(!array1.size)
		return array2;
	
	array3 = [];
	
	keys = getarraykeys(array1);
	for(i=0;i<keys.size;i++)
	{
		key = keys[ i ];
		array3[ array3.size ] = array1[ key ]; 
	}	
	
	keys = getarraykeys(array2);
	for(i=0;i<keys.size;i++)
	{
		key = keys[ i ];
		array3[ array3.size ] = array2[ key ];
	}
	
	return array3;
}

/*
=============
///ScriptDocBegin
"Name: array_merge( <array1>, <array2> )"
"Summary: Combines the two arrays and returns the resulting array. Adds only things that are new to the array, no duplicates."
"Module: Array"
"CallOn: "
"MandatoryArg: <array1>: first array"
"MandatoryArg: <array2>: second array"
"Example: combinedArray = array_merge( array1, array2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_merge(array1,array2) // adds only things that are new to the array
{
	if(array1.size == 0)
		return array2;
	if(array2.size == 0)
		return array1;
	newarray = array1;
	for(i=0;i<array2.size;i++)
	{
		foundmatch = false;
		for(j=0;j<array1.size;j++)
			if(array2[i] == array1[j])
			{
				foundmatch = true;
				break;
			}
		if(foundmatch)
			continue;
		else
			newarray[newarray.size] = array2[i];
	}
	return newarray;
}

/*
=============
///ScriptDocBegin
"Name: array_exclude( <array>, <arrayExclude> )"
"Summary: Returns an array excluding all members of <arrayExclude>"
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: Array containing all items"
"MandatoryArg: <arrayExclude>: Arary containing all items to remove"
"Example: newArray = array_exclude( array1, array2 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_exclude(array,arrayExclude) //returns "array" minus all members of arrayExclude
{
	newarray = array;
	for(i=0;i<arrayExclude.size;i++)
	{
		if (is_in_array (array, arrayExclude[i]))
			newarray = array_remove(newarray, arrayExclude[i]);
	}
	
	return newarray;
}

/*
=============
///ScriptDocBegin
"Name: flat_angle( <angle> )"
"Summary: Returns the specified angle as a flat angle. ( 45, 90, 30 ) becomes ( 0, 90, 30 ). Useful if you just need an angle around Y-axis."
"Module: Vector"
"CallOn: "
"MandatoryArg: <angle>: angles to flatten"
"Example: yaw = flat_angle( node.angles );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}

/*
=============
///ScriptDocBegin
"Name: flat_origin( <org> )"
"Summary: Returns a flat origin of the specified origin. Moves Z corrdinate to 0. ( x, y, z ) becomes ( x, y, 0 )"
"Module: Vector"
"CallOn: "
"MandatoryArg: <org>: origin to flatten"
"Example: org = flat_origin( self.origin );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}

plot_points(plotpoints,r,g,b,timer)
{
	lastpoint = plotpoints[0];
	if(!isdefined(r))
		r = 1;
	if(!isdefined(g))
		g = 1;
	if(!isdefined(b))
		b = 1;
	if(!isdefined(timer))
		timer = 0.05;
	for(i=1;i<plotpoints.size;i++)
	{
		thread draw_line_for_time(lastpoint,plotpoints[i],r,g,b,timer);
		lastpoint = plotpoints[i];	
	}
}

/*
=============
///ScriptDocBegin
"Name: draw_line_for_time( <org1>, <org2>, <r>, <g>, <b>, <timer> )"
"Summary: Draws a line from <org1> to <org2> in the specified color for the specified duration"
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1>: starting origin for the line"
"MandatoryArg: <org2>: ending origin for the line"
"MandatoryArg: <r>: red color value ( 0 to 1 )"
"MandatoryArg: <g>: green color value ( 0 to 1 )"
"MandatoryArg: <b>: blue color value ( 0 to 1 )"
"MandatoryArg: <timer>: time in seconds the line should last"
"Example: thread draw_line_for_time( level.player.origin, vehicle.origin, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_line_for_time(org1,org2,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (org1,org2, (r,g,b), 1);
		wait .05;		
	}
	
}

/*
=============
///ScriptDocBegin
"Name: draw_line_to_ent_for_time( <org1>, <ent>, <r>, <g>, <b>, <timer> )"
"Summary: Draws a line from <org1> to <ent> origin in the specified color for the specified duration. Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1>: starting origin for the line"
"MandatoryArg: <ent>: entity to draw line to"
"MandatoryArg: <r>: red color value ( 0 to 1 )"
"MandatoryArg: <g>: green color value ( 0 to 1 )"
"MandatoryArg: <b>: blue color value ( 0 to 1 )"
"MandatoryArg: <timer>: time in seconds the line should last"
"Example: thread draw_line_to_ent_for_time( level.player.origin, vehicle, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_line_to_ent_for_time(org1,ent,r,g,b,timer)
{
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (org1,ent.origin, (r,g,b), 1);
		wait .05;		
	}
	
}

draw_line_from_ent_for_time(ent,org,r,g,b,timer)
{
	draw_line_to_ent_for_time(org,ent,r,g,b,timer);
}

/*
=============
///ScriptDocBegin
"Name: draw_line_from_ent_to_ent_for_time( <ent1>, <ent2>, <r>, <g>, <b>, <timer> )"
"Summary: Draws a line from one entity origin to another entity origin in the specified color for the specified duration. Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <ent1>: entity to draw line from"
"MandatoryArg: <ent2>: entity to draw line to"
"MandatoryArg: <r>: red color value ( 0 to 1 )"
"MandatoryArg: <g>: green color value ( 0 to 1 )"
"MandatoryArg: <b>: blue color value ( 0 to 1 )"
"MandatoryArg: <timer>: time in seconds the line should last"
"Example: thread draw_line_from_ent_to_ent_for_time( level.player, vehicle, 1, 0, 0, 10.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_line_from_ent_to_ent_for_time(ent1,ent2,r,g,b,timer)
{
	ent1 endon( "death" );
	ent2 endon( "death" );
	
	timer = gettime()+(timer*1000);
	while(gettime()<timer)
	{
		line (ent1.origin,ent2.origin, (r,g,b), 1);
		wait .05;		
	}
	
}

/*
=============
///ScriptDocBegin
"Name: draw_line_from_ent_to_ent_until_notify( <ent1>, <ent2>, <r>, <g>, <b>, <notifyEnt>, <notifyString> )"
"Summary: Draws a line from one entity origin to another entity origin in the specified color until <notifyEnt> is notified <notifyString>. Updates to the entities origin each frame."
"Module: Debug"
"CallOn: "
"MandatoryArg: <ent1>: entity to draw line from"
"MandatoryArg: <ent2>: entity to draw line to"
"MandatoryArg: <r>: red color value ( 0 to 1 )"
"MandatoryArg: <g>: green color value ( 0 to 1 )"
"MandatoryArg: <b>: blue color value ( 0 to 1 )"
"MandatoryArg: <notifyEnt>: entity that waits for the notify"
"MandatoryArg: <notifyString>: notify string that will make the line stop being drawn"
"Example: thread draw_line_from_ent_to_ent_until_notify( level.player, guy, 1, 0, 0, guy, "anim_on_tag_done" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_line_from_ent_to_ent_until_notify( ent1, ent2, r, g, b, notifyEnt, notifyString )
{
	assert( isdefined( notifyEnt ) );
	assert( isdefined( notifyString ) );
	
	ent1 endon( "death" );
	ent2 endon( "death" );
	
	notifyEnt endon( notifyString );
	
	while(1)
	{
		line ( ent1.origin, ent2.origin, ( r, g, b ), 0.05 );
		wait .05;		
	}
	
}

/*
=============
///ScriptDocBegin
"Name: draw_line_until_notify( <org1>, <org2>, <r>, <g>, <b>, <notifyEnt>, <notifyString> )"
"Summary: Draws a line from <org1> to <org2> in the specified color until <notifyEnt> is notified <notifyString>"
"Module: Debug"
"CallOn: "
"MandatoryArg: <org1>: starting origin for the line"
"MandatoryArg: <org2>: ending origin for the line"
"MandatoryArg: <r>: red color value ( 0 to 1 )"
"MandatoryArg: <g>: green color value ( 0 to 1 )"
"MandatoryArg: <b>: blue color value ( 0 to 1 )"
"MandatoryArg: <notifyEnt>: entity that waits for the notify"
"MandatoryArg: <notifyString>: notify string that will make the line stop being drawn"
"Example: thread draw_line_until_notify( self.origin, targetLoc, 1, 0, 0, self, "stop_drawing_line" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_line_until_notify( org1, org2, r, g, b, notifyEnt, notifyString )
{
	assert( isdefined( notifyEnt ) );
	assert( isdefined( notifyString ) );
	
	notifyEnt endon( notifyString );
	
	while(1)
	{
		draw_line_for_time(org1,org2,r,g,b,0.05);	
	}
}

/*
=============
///ScriptDocBegin
"Name: draw_arrow_time( <start>, <end>, <color>, <duration> )"
"Summary: Draws an arrow pointing at <end> in the specified color for <duration> seconds."
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <start>: starting coordinate for the arrow"
"MandatoryArg: <end>: ending coordinate for the arrow"
"MandatoryArg: <color>: (r,g,b) color array for the arrow"
"MandatoryArg: <duration>: time in seconds to draw the arrow"
"Example: thread draw_arrow_time( lasttarg.origin, targ.origin, (0,0,1), 5.0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
draw_arrow_time (start, end, color, duration)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);
	up = anglestoup(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.1;
		 	
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.1);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.1);

	arrow[4] =  start;
	arrow[5] =  start + vectorScale(up, dist*(range)) + vectorScale(forward, dist*-0.1);
	arrow[6] =  end;
	arrow[7] =  start + vectorScale(up, dist*(-1 * range)) + vectorScale(forward, dist*-0.1);
	arrow[8] =  start;

	r = color[0];
	g = color[1];
	b = color[2];
	
	plot_points(arrow,r,g,b,duration);
}

draw_arrow (start, end, color)
{
	level endon ("newpath");
	pts = [];
	angles = vectortoangles(start - end);
	right = anglestoright(angles);
	forward = anglestoforward(angles);

	dist = distance(start, end);
	arrow = [];
	range = 0.05;
	arrow[0] =  start;
	arrow[1] =  start + vectorScale(right, dist*(range)) + vectorScale(forward, dist*-0.2);
	arrow[2] =  end;
	arrow[3] =  start + vectorScale(right, dist*(-1 * range)) + vectorScale(forward, dist*-0.2);

	for (p=0;p<4;p++)
	{
		nextpoint = p+1;
		if (nextpoint >= 4)
			nextpoint = 0;
		line(arrow[p], arrow[nextpoint], color, 1.0);
	}
}

clear_enemy_passthrough()
{
	self notify ("enemy");
	self clearEnemy();
}

/*
=============
///ScriptDocBegin
"Name: battlechatter_off( <team> )"
"Summary: Disable battlechatter for the specified team"
"Module: Battlechatter"
"CallOn: "
"MandatoryArg: <team>: team to disable battlechatter on"
"Example: battlechatter_off( "allies" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
battlechatter_off( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if ( isDefined( team ) )
	{
		level.battlechatter[team] = false;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = false;
		level.battlechatter["allies"] = false;
		level.battlechatter["neutral"] = false;
		soldiers = getAIArray();
	}

	if (!isDefined(anim.chatInitialized) || !anim.chatInitialized)
		return;

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[ index ].battlechatter = false;

	for ( index = 0; index < soldiers.size; index++ )
	{
		soldier = soldiers[ index ];
		if ( !isalive( soldier ) )
			continue;
			
		if ( !soldier.chatInitialized )
			continue;

		if ( !soldier.isSpeaking )
			continue;
			
		soldier wait_until_done_speaking();
	}
	
	speakDiff = getTime() - anim.lastTeamSpeakTime["allies"];

	if ( speakDiff < 1500 )
		wait ( speakDiff / 1000 );
		
	if ( isdefined( team ) )
		level notify ( team + " done speaking" );
	else
		level notify ( "done speaking" );
}

/*
=============
///ScriptDocBegin
"Name: battlechatter_on( <team> )"
"Summary: Enable battlechatter for the specified team"
"Module: Battlechatter"
"CallOn: "
"MandatoryArg: <team>: team to enable battlechatter on"
"Example: battlechatter_on( "allies" );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
battlechatter_on( team )
{
	thread battlechatter_on_thread( team );
}

battlechatter_on_thread( team )
{
	if ( !isDefined( level.battlechatter ) )
	{
		level.battlechatter = [];
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
	}

	if (!anim.chatInitialized)
		return;

	// buffer time
	wait ( 1.5 );
	
	if ( isDefined( team ) )
	{
		level.battlechatter[team] = true;
		soldiers = getAIArray( team );
	}
	else
	{
		level.battlechatter["axis"] = true;
		level.battlechatter["allies"] = true;
		level.battlechatter["neutral"] = true;
		soldiers = getAIArray();
	}

	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] set_battlechatter(true);
}

set_battlechatter( state )
{
	if (!anim.chatInitialized)
		return;

	if ( self.type == "dog" )
		return;

	if (state)
	{
		if(isdefined(self.script_bcdialog) && !self.script_bcdialog)
			self.battlechatter = false;
		else
			self.battlechatter = true;
	}
	else
	{
		self.battlechatter = false;
		
		if (isdefined(self.isSpeaking) && self.isSpeaking)
			self waittill ("done speaking");
	}
}

//
// This is for scripted sequence guys that the LD has setup to not 
// get interrupted in route.
//

set_friendly_chain_wrapper(node)
{
	level.player setFriendlyChain(node);
	level notify ("newFriendlyChain", node.script_noteworthy);
}


// Newvillers objective management
/*
	level.currentObjective = "obj1"; // disables non obj1 friendly chains if you're using newvillers style friendlychains
	objEvent = get_obj_event("center_house"); // a trigger with targetname objective_event and a script_deathchain value
	
	objEvent waittill_objectiveEvent(); // this waits until the AI with the event's script_deathchain are dead,
											then waits for trigger from the player. If it targets a friendly chain then it'll
											make the friendlies go to the chain.
*/

get_obj_origin(msg)
{
	objOrigins = getentarray("objective","targetname");
	for (i=0;i<objOrigins.size;i++)
	{
		if (objOrigins[i].script_noteworthy == msg)
			return objOrigins[i].origin;
	}
}

get_obj_event(msg)
{
	objEvents = getentarray("objective_event","targetname");
	for (i=0;i<objEvents.size;i++)
	{
		if (objEvents[i].script_noteworthy == msg)
			return objEvents[i];
	}
}


waittill_objective_event()
{
	waittill_objective_event_proc(true);
}

waittill_objective_event_notrigger()
{
	waittill_objective_event_proc(false);
}


obj_set_chain_and_enemies()
{
	objChain = getnode(self.target,"targetname");
	objEnemies = getentarray(self.target,"targetname");
	flood_and_secure_scripted(objEnemies);
//	array_thread (, ::flood_begin);
	level notify ("new_friendly_trigger");
	level.player set_friendly_chain_wrapper(objChain);
}

flood_begin()
{
	self notify ("flood_begin");
}

flood_and_secure_scripted(spawners, instantRespawn)
{
	/*
		The "scripted" version acts as if it had been player triggered.
		
		Spawns AI that run to a spot then get a big goal radius. They stop spawning when auto delete kicks in, then start
		again when they are retriggered or the player gets close.
	
		trigger targetname flood_and_secure
		ai spawn and run to goal with small goalradius then get large goalradius
		spawner starts with a notify from any flood_and_secure trigger that triggers it
		spawner stops when an AI from it is deleted to make space for a new AI or when count is depleted
		spawners with count of 1 only make 1 guy.
		Spawners with count of more than 1 only deplete in count when the player kills the AI.
		spawner can target another spawner. When first spawner's ai dies from death (not deletion), second spawner activates.
	*/

	if (!isdefined(instantRespawn))
		instantRespawn = false;

	if (!isdefined (level.spawnerWave))
		level.spawnerWave = [];
	array_thread (spawners, maps\_spawner::flood_and_secure_spawner, instantRespawn);

	for (i=0;i<spawners.size;i++)
	{
		spawners[i].playerTriggered = true;
		spawners[i] notify ("flood_begin");
	}
}


debugorigin()
{
//	self endon ("killanimscript");
//	self endon (anim.scriptChange);
	self notify ("Debug origin");
	self endon ("Debug origin");
	self endon ("death");
	for (;;)
	{
		forward = anglestoforward (self.angles);
		forwardFar = vectorScale(forward, 30);
		forwardClose = vectorScale(forward, 20);
		right = anglestoright (self.angles);
		left = vectorScale(right, -10);
		right = vectorScale(right, 10);
		line (self.origin, self.origin + forwardFar, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + right, (0.9, 0.7, 0.6), 0.9);
		line (self.origin + forwardFar, self.origin + forwardClose + left, (0.9, 0.7, 0.6), 0.9);
		wait (0.05);
	}
}


get_links()
{
	return strtok( self.script_linkTo, " " );
}


player_seek(timeout)
{
	goalent = spawn("script_origin",level.player.origin);
	goalent linkto (level.player);
	if(isdefined(timeout))
		self thread timeout(timeout);
	self setgoalentity(goalent);
	if(!isdefined(self.oldgoalradius))
		self.oldgoalradius = self.goalradius;
	self.goalradius = 300;
	self waittill_any("goal","timeout");
	if(isdefined(self.oldgoalradius))
	{
		self.goalradius = self.oldgoalradius;
		self.oldgoalradius = undefined;
	}
	goalent delete();
}

timeout(timeout)
{
	self endon ("death");
	wait(timeout);
	self notify ("timeout");
}

set_forcegoal()
{
	if(isdefined(self.set_forcedgoal))
		return;
	
	self.oldfightdist 	= self.pathenemyfightdist;
	self.oldmaxdist 	= self.pathenemylookahead;
	self.oldmaxsight 	= self.maxsightdistsqrd;
	
	self.pathenemyfightdist = 8;
	self.pathenemylookahead = 8;
	self.maxsightdistsqrd = 1;
	self.set_forcedgoal = true;
}

unset_forcegoal()
{
	if(!isdefined(self.set_forcedgoal))
		return;
	
	self.pathenemyfightdist = self.oldfightdist;
	self.pathenemylookahead = self.oldmaxdist;
	self.maxsightdistsqrd 	= self.oldmaxsight;
	self.set_forcedgoal = undefined;
}


array_add ( array, ent )
{
	array[array.size] = ent;
	return array;
}

array_removeDead_keepkeys( array )
{
	newArray = [];
	keys = getarraykeys( array );
	for( i = 0; i < keys.size; i++ )
	{
		key = keys[ i ];
		if ( !isalive( array[ key ] ) )
			continue;
		newArray[ key ] = array[ key ];
	}

	return newArray;
}

/*
=============
///ScriptDocBegin
"Name: array_removeDead( <array> )"
"Summary: Returns a new array of <array> minus the dead entities"
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: The array to search for dead entities in."
"Example: friendlies = array_removeDead( friendlies );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_removeDead (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isalive(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

/*
=============
///ScriptDocBegin
"Name: array_removeUndefined( <array> )"
"Summary: Returns a new array of <array> minus the undefined indicies"
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: The array to search for undefined indicies in."
"Example: ents = array_removeUndefined( ents );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_removeUndefined (array)
{
	newArray = [];
	for(i = 0; i < array.size; i++)
	{
		if (!isdefined(array[i]))
			continue;
		newArray[newArray.size] = array[i];
	}

	return newArray;
}

/*
=============
///ScriptDocBegin
"Name: array_insert( <array>, <object>, <index> )"
"Summary: Returns a new array of <array> plus <object> at the specified index"
"Module: Array"
"CallOn: "
"MandatoryArg: <array>: The array to add to."
"MandatoryArg: <object>: The entity to add"
"MandatoryArg: <index>: The index position <object> should be added to."
"Example: ai = array_insert( ai, spawned, 0 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_insert(array, object, index)
{
	if(index == array.size)
	{
		temp = array;
		temp[temp.size] = object;
		return temp;
	}
	temp = [];
	offset = 0;
	for(i=0; i<array.size; i++)
	{
		if(i==index)
		{
			temp[i] = object;
			offset = 1;
		}
		temp[i + offset] = array[i];
	}
	
	return temp;
}

/*
=============
///ScriptDocBegin
"Name: array_remove( <ents>, <remover> )"
"Summary: Returns <ents> array minus <remover>"
"Module: Array"
"CallOn: "
"MandatoryArg: <ents>: array to remove <remover> from"
"MandatoryArg: <remover>: entity to remove from the array"
"Example: ents = array_remove( ents, guy );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
array_remove (ents, remover)
{
	newents = [];
	//if this array is a simple numbered array - array keys will return the array in a reverse order
	//causing the array that is returned from this function to be flipped, that is an un expected 
	//result, which is why we're counting down in the for loop instead of the usual counting up
	keys = getArrayKeys( ents );
	for(i = keys.size - 1; i >= 0; i--)
	{
		if(ents[ keys[ i ] ] != remover)
			newents[newents.size] = ents[ keys[ i ] ];
	}

	return newents;
}

array_remove_index ( array, index )
{
	newArray = [];
	keys = getArrayKeys( array );
	for( i = ( keys.size - 1 ) ; i >= 0 ; i-- )
	{
		if( keys[ i ] != index )
			newArray[ newArray.size ] = array[ keys[ i ] ];
	}

	return newArray;
}

array_notify (ents, notifier)
{
	for (i=0;i<ents.size;i++)
		ents[i] notify (notifier);
}


// fancy quicker struct array handling, assumes array elements are objects with which an index can be asigned to (IE: can't do 5.struct_array_index) 
// also have to be sure that objects can't be a part of another structarray setup as the index position is asigned to the object



getstruct( name, type )
{
	assertEx( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );
	
	array = level.struct_class_names[ type ][ name ];
	if( !isdefined( array ) )
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

getstructarray( name, type )
{
	assertEx( isdefined( level.struct_class_names ), "Tried to getstruct before the structs were init" );
	
	array = level.struct_class_names[ type ][ name ];
	return array;
}

struct_arrayspawn()
{
	struct = spawnstruct();
	struct.array = [];
	struct.lastindex = 0;
	return struct;
}

/*
structarray_add(struct,object)
{
	struct.array[struct.lastindex] = spawnstruct();
	struct.array[struct.lastindex].object = object;
	struct.array[struct.lastindex].struct_array_index = struct.lastindex;
	struct.lastindex++;
}
*/
structarray_add(struct,object)
{
	assert(!isdefined(object.struct_array_index));  //can't have elements of two structarrays on these. can add that later if it's needed
	struct.array[struct.lastindex] = object;
	object.struct_array_index = struct.lastindex;
	struct.lastindex++;
}

structarray_remove(struct,object)
{
	structarray_swaptolast(struct,object);
	struct.array[struct.lastindex-1] = undefined;
	struct.lastindex--;
}

structarray_swaptolast(struct,object)
{
	struct structarray_swap(struct.array[struct.lastindex-1],object);
}

structarray_shuffle(struct,shuffle)
{
	for(i=0;i<shuffle;i++)
		struct structarray_swap(struct.array[i],struct.array[randomint(struct.lastindex)]);
}



// starts this ambient track
set_ambient_alias(ambient, alias)
{
	// change the meaning of this ambience so that the ambience can change over the course of the level
	level.ambient_modifier[ambient] = alias;
	// if the ambient being aliased is the current ambience then restart it so it gets the new track
	if ( level.ambient == ambient )
		maps\_ambient::activateAmbient( ambient );
}


get_use_key()
{
	if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
	 	return "+usereload";
 	else
 		return "+activate";
}


doom()
{
	// send somebody far away then delete them
	self teleport((0,0,-15000));
	self dodamage(self.health + 1, (0,0,0));
}

/*
	move_generic		"Go! Go! Go!"
	move_flank			"Find a way to flank them! Go!"
	move_flankleft		"Take their left flank! Go!"
	move_flankright		"Move in on their left flank! Go!"
	move_follow			"Follow me!"
	move_forward		"Keep moving forward!"
	move_back			"Fall back!"
	
	infantry_generic	"Enemy Infantry!"
	infantry_exposed	"Infatry in the open!"
	infantry_many		"We got a load of german troops out there!"
	infantry_sniper		"Get your heads down! Sniper!"
	infantry_panzer		"Panzerschreck!"
	
	vehicle_halftrack	"Halftrack!"
	vehicle_panther		"Panther heavy tank!"
	vehicle_panzer		"Panzer tank!"
	vehicle_tank		"Look out! Enemy armor!"
	vehicle_truck		"Troop truck!"

	action_smoke		"Get some smoke out there!"

	The following can be appended to any infantry or vehicle dialog line:	
	_left				"On our left!"
	_right				"To the right!"
	_front				"Up front!"
	_rear				"Behind us!"
	_north				"To the north!"
	_south				"South!"
	_east				"To the east!"
	_west				"To the west!"
	_northwest			"To the northwest!"
	_southwest			"To the southwest!"
	_northeast			"To the northeast!"
	_southwest			"To the southeast!"
	_inbound_left		"Incoming
	_inbound_right		"Closing on our right flank!"
	_inbound_front		"Inbound dead ahead!"
	_inbound_rear		"Approaching from the rear!"
	_inbound_north		"Coming in from the north!"
	_inbound_south		"Coming in from the south!"
	_inbound_east		"Approaching from the east!"
	_inbound_west		"Pushing in from the west!"
*/

custom_battlechatter( string )
{
	excluders = [];
	excluders[0] = self;
	buddy = get_closest_ai_exclude( self.origin, self.team, excluders );

	if ( isDefined( buddy ) && distance( buddy.origin, self.origin ) > 384 ) 
		buddy = undefined;

	self animscripts\battlechatter_ai::beginCustomEvent();

	tokens = strTok( string, "_" );

	if ( !tokens.size )
		return;
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		self animscripts\battlechatter_ai::addGenericAliasEx( "order", "move", modifier );
			
	}
	else if ( tokens[0] == "infantry" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		self animscripts\battlechatter_ai::addGenericAliasEx( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			self animscripts\battlechatter_ai::addGenericAliasEx( "direction", "inbound", tokens[3] );
	}
	
	self animscripts\battlechatter_ai::endCustomEvent( 2000 );
}


force_custom_battlechatter( string, targetAI )
{
	tokens = strTok( string, "_" );
	soundAliases = [];

	if ( !tokens.size )
		return;

	if ( isDefined( targetAI ) && (isDefined( targetAI.bcName) || isDefined( targetAI.bcRank)) )
	{
		if ( isDefined( targetAI.bcName ) )
			nameAlias = self buildBCAlias( "name", targetAI.bcName );
		else
			nameAlias = self buildBCAlias( "rank", targetAI.bcRank );
			
		if ( soundExists( nameAlias ) )
			soundAliases[soundAliases.size] = nameAlias;
	}	
		
	if ( tokens[0] == "move" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";
			
		soundAliases[soundAliases.size] = self buildBCAlias( "order", "move", modifier );
	}
	else if ( tokens[0] == "infantry" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "infantry", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "vehicle" )
	{
		soundAliases[soundAliases.size] = self buildBCAlias( "threat", "vehicle", tokens[1] );
		
		if ( tokens.size > 2 && tokens[2] != "inbound" )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "relative", tokens[2] );
		else if ( tokens.size > 2 )
			soundAliases[soundAliases.size] = self buildBCAlias( "direction", "inbound", tokens[3] );
	}
	else if ( tokens[0] == "order" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "action", modifier );
	}
	else if ( tokens[0] == "cover" )
	{
		if ( tokens.size > 1 )
			modifier = tokens[1];
		else 
			modifier = "generic";

		soundAliases[soundAliases.size] = self buildBCAlias( "order", "cover", modifier );
	}
	
	for ( index = 0; index < soundAliases.size; index++)
	{
		self playSound( soundAliases[index], soundAliases[index], true);
		self waittill( soundAliases[index] );
	}
}


buildBCAlias( action, type, modifier )
{
	if ( isDefined( modifier ) )
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type + "_" + modifier );
	else
		return ( self.countryID + "_" + self.npcID + "_" + action + "_" + type );
}

get_stop_watch(time,othertime)
{
	watch = newHudElem();
	 if (isdefined( getdvar("xenonGame") ) && getdvar("xenonGame") == "true" )
	{
		watch.x = 68;
		watch.y = 35;
	}
	else
	{
		watch.x = 58;
		watch.y = 95;
	}
	
	watch.alignx = "center";
	watch.aligny = "middle";
	watch.horzAlign = "left";
	watch.vertAlign = "middle";
	if(isdefined(othertime))
		timer = othertime;
	else
		timer = level.explosiveplanttime;
	watch setClock(timer, time, "hudStopwatch", 64, 64); // count down for level.explosiveplanttime of 60 seconds, size is 64x64
	return watch;
}

objective_is_active(msg)
{
	active = false;
	// objective must be active for this trigger to hit
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		active = true;
		break;
	}
	return (active);
}

objective_is_inactive(msg)
{
	inactive = false;
	// objective must be active for this trigger to hit
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		inactive = true;
		break;
	}
	return (inactive);
}

set_objective_inactive(msg)
{
	// remove the objective from the active list
	array = [];
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] == msg)
			continue;
		array[array.size] = level.active_objective[i];
	}
	level.active_objective = array;
	
	
	// add it to the inactive list
	exists = false;
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.inactive_objective[level.inactive_objective.size] = msg;
		
	/#
	// assert that each objective is only on one list
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}

set_objective_active(msg)
{
	// remove the objective from the inactive list
	array = [];
	for (i=0;i<level.inactive_objective.size;i++)
	{
		if (level.inactive_objective[i] == msg)
			continue;
		array[array.size] = level.inactive_objective[i];
	}
	level.inactive_objective = array;
		
	// add it to the active list
	exists = false;
	for (i=0;i<level.active_objective.size;i++)
	{
		if (level.active_objective[i] != msg)
			continue;
		exists = true;
	}
	if (!exists)
		level.active_objective[level.active_objective.size] = msg;
		
	/#
	// assert that each objective is only on one list
	for (i=0;i<level.active_objective.size;i++)
	{
		for (p=0;p<level.inactive_objective.size;p++)
			assertEx(level.active_objective[i] != level.inactive_objective[p], "Objective is both inactive and active");
	}
	#/
}


detect_friendly_fire()
{
	level thread maps\_friendlyfire::detectFriendlyFireOnEntity(self);
}

missionFailedWrapper()
{
	if ( level.missionfailed )
		return;

	level.missionfailed = true;	
	missionfailed();
}


script_delay()
{
	startTime = getTime();
	if ( isDefined( self.script_delay ) )
		wait ( self.script_delay );
	else if ( isDefined( self.script_delay_min ) && isDefined( self.script_delay_max ) )
		wait ( randomFloatRange( self.script_delay_min, self.script_delay_max ) );
		
	return ( getTime() - startTime );
}


script_wait()
{
	startTime = getTime();
	if ( isDefined( self.script_wait ) )
	{
		wait (self.script_wait);

		if ( isDefined( self.script_wait_add ) )
			self.script_wait += self.script_wait_add;
	}
	else if ( isDefined( self.script_wait_min ) && isDefined( self.script_wait_max ) )
	{
		wait (randomFloatRange( self.script_wait_min, self.script_wait_max ));

		if ( isDefined( self.script_wait_add ) )
		{
			self.script_wait_min += self.script_wait_add;
			self.script_wait_max += self.script_wait_add;
		}
	}

	return ( getTime() - startTime );
}

guy_enter_vehicle(guy,vehicle)
{
	maps\_vehicle_aianim::guy_enter(guy,vehicle);
}

guy_array_enter_vehicle(guy,vehicle)
{
	maps\_vehicle_aianim::guy_array_enter(guy,vehicle);
}

guy_runtovehicle_load(guy,vehicle)
{
	maps\_vehicle_aianim::guy_runtovehicle(guy,vehicle);
	
}

get_force_color_guys( team, color )
{
	ai = getaiarray( team );
	guys = [];
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_forceColor ) )
			continue;
		
		if ( guy.script_forceColor != color )
			continue;
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

get_all_force_color_friendlies()
{
	ai = getaiarray( "allies" );
	guys = [];
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( !isdefined( guy.script_forceColor ) )
			continue;
		guys[ guys.size ] = guy;
	}
	
	return guys;
}

enable_ai_color()
{
	if ( isdefined( self.script_forceColor ) )
		return;
	if ( !isdefined( self.old_forceColor ) )
		return;
		
	set_force_color( self.old_forcecolor );
	self.old_forceColor = undefined;
}

disable_ai_color()
{
	if ( isdefined( self.new_force_color_being_set ) )
	{
		self endon( "death" );
		// setting force color happens after waittillframeend so we need to wait until it finishes
		// setting before we disable it, so a set followed by a disable will send the guy to a node.
		self waittill( "done_setting_new_color" );
	}
	
	self clearFixedNodeSafeVolume();
	// any color on this guy?
	if ( !isdefined( self.script_forceColor ) )
	{
		return;
	}

	assertEx( !isdefined( self.old_forcecolor ), "Tried to disable forcecolor on a guy that somehow had a old_forcecolor already. Investigate!!!" );
	
	self.old_forceColor = self.script_forceColor;
	
	
	// first remove the guy from the force color array he used to belong to
	level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ] = array_remove( level.arrays_of_colorForced_ai[ self.team ][ self.script_forcecolor ], self );
//	self maps\_colors::removeAIFromColorNumberArray();
	
	maps\_colors::left_color_node();
	self.script_forceColor = undefined;
	self.currentColorCode = undefined;
	/#
	update_debug_friendlycolor( self.ai_number );
	#/
}

clear_force_color()
{
	disable_ai_color();
}

check_force_color(_color)
{
	color = level.colorCheckList[tolower(_color)];
	if(isdefined(self.script_forcecolor) && color == self.script_forcecolor)
		return true;
	else
		return false;
}

get_force_color()
{
	color = self.script_forceColor;
	return color;
}

shortenColor( color )
{
	assertEx( isdefined( level.colorCheckList[ tolower( color ) ] ), "Tried to set force color on an undefined color: " + color );
	return level.colorCheckList[ tolower( color ) ];
}


set_force_color( _color )
{
	// shorten and lowercase the ai's forcecolor to a single letter
	color = shortenColor( _color );
	
	assertEx( maps\_colors::colorIsLegit( color ), "Tried to set force color on an undefined color: " + color );
	
	if ( !isAI( self ) )
	{
		set_force_color_spawner( color );
		return;
	}
		
	assertEx( isalive( self ), "Tried to set force color on a dead/undefined entity." );
	/*
	/#
	thread insure_player_does_not_set_forcecolor_twice_in_one_frame();
	#/
	*/

	if ( self.team == "allies" )
	{
		// enable fixed node mode.
		self.fixedNode = true;
		self.fixedNodeSafeRadius = 64;
		self.pathEnemyFightDist = 0;
		self.pathEnemyLookAhead = 0;
	}

//	maps\_colors::removeAIFromColorNumberArray();	
	self.script_color_axis = undefined;
	self.script_color_allies = undefined;
	self.old_forcecolor = undefined;
	
	if ( isdefined( self.script_forcecolor ) )
	{
		// first remove the guy from the force color array he used to belong to
		level.arrays_of_colorForced_ai[self.team][self.script_forcecolor] = array_remove(level.arrays_of_colorForced_ai[self.team][self.script_forcecolor], self);
	}
	self.script_forceColor = color;

	// get added to the new array of AI that are forced to this color
	level.arrays_of_colorForced_ai[self.team][self.script_forceColor] = array_add(level.arrays_of_colorForced_ai[self.team][self.script_forceColor], self);


	// set it here so that he continues in script as the correct color
	thread new_color_being_set( color );
}	

set_force_color_spawner( color )
{
	/*
	team = undefined;
	colorTeam = undefined;
	if (issubstr(self.classname,"axis"))
	{
		colorTeam = self.script_color_axis;
		team = "axis";
	}
	
	if (issubstr(self.classname,"ally"))
	{
		colorTeam = self.script_color_allies;
		team = "allies";
	}

	maps\_colors::removeSpawnerFromColorNumberArray();	
	*/
	
	self.script_forceColor = color;
//	self.script_color_axis = undefined;
//	self.script_color_allies = undefined;
	self.old_forceColor = undefined;
//	thread maps\_colors::spawner_processes_colorCoded_ai();
}

issue_color_orders(color_team, team)
{
	colorCodes = strtok( color_team, " " );
	colors = [];
	colorCodesByColorIndex = [];
	
	for (i=0;i<colorCodes.size;i++)
	{
		color = undefined;
		if (issubstr(colorCodes[i], "r"))
			color = "r";
		else
		if (issubstr(colorCodes[i], "b"))
			color = "b";
		else
		if (issubstr(colorCodes[i], "y"))
			color = "y";
		else
		if (issubstr(colorCodes[i], "c"))
			color = "c";
		else
		if (issubstr(colorCodes[i], "g"))
			color = "g";
		else
		if (issubstr(colorCodes[i], "p"))
			color = "p";
		else
		if (issubstr(colorCodes[i], "o"))
			color = "o";
		else
			assertEx(0, "Trigger at origin " + self getorigin() + " had strange color index " + colorCodes[i]);
		
		colorCodesByColorIndex[color] = colorCodes[i];
		colors[colors.size] = color;
	}
	
	assert(colors.size == colorCodes.size);
	
	for (i=0;i<colorCodes.size;i++)
	{
		// remove deleted spawners
		level.arrays_of_colorCoded_spawners[team][colorCodes[i]] = array_removeUndefined(level.arrays_of_colorCoded_spawners[team][colorCodes[i]]);

		assertex( isdefined(level.arrays_of_colorCoded_spawners[team][colorCodes[i]]), "Trigger refer to a color# that does not exist in any node for this team." );
		// set the .currentColorCode on each appropriate spawner
		for (p=0;p<level.arrays_of_colorCoded_spawners[team][colorCodes[i]].size;p++)
			level.arrays_of_colorCoded_spawners[team][colorCodes[i]][p].currentColorCode = colorCodes[i];
	}

	for (i=0;i<colors.size;i++)
	{
		// remove the dead from the color forced ai
		level.arrays_of_colorForced_ai[team][colors[i]] = array_removeDead(level.arrays_of_colorForced_ai[team][colors[i]]);
			
		// set the destination of the color forced spawners
		level.currentColorForced[team][colors[i]] = colorCodesByColorIndex[colors[i]];
	}
		
	for (i=0;i<colorCodes.size;i++)
		self thread maps\_colors::issue_color_order_to_ai(colorCodes[i], colors[i], team);
}


setDifficultyBias( num )
{
	level.difficultyBias = num;
	maps\_gameskill::setCurrentDifficulty();
}


//TODO: Non-hacky rumble.
flashRumbleLoop( duration )
{
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		level.player PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}


flashMonitor()
{
	self endon( "death" );
	
	for(;;)
	{
		level.player waittill( "flashbang", percent_distance, percent_angle, attacker, team );

		if ( "1" == getdvar( "noflash" ) )
			continue;
			
		//PrintLn( "Flashed by a grenade from team '", team, "'." );
	
		if ( percent_angle < 0.5 )
			percent_angle = 0.5;
		else if ( percent_angle > 0.8 )
			percent_angle = 1;
	
		if ( team == "axis" ) 
			seconds = percent_distance * percent_angle * 6.0;
		else
			seconds = percent_distance * percent_angle * 3.0;
	
		if ( seconds < 0.25 )
			continue;

		if ( isdefined( level.player.maxflashedseconds ) && seconds > level.player.maxflashedseconds )
 			seconds = level.player.maxflashedseconds;
	
		level.player notify("flashed");
		level.player.flashendtime = gettime() + seconds*1000; // player is flashed if flashDoneTime > gettime()
		level.player shellshock( "flashbang", seconds );
		
		if ( seconds > 2 )
			thread flashRumbleLoop( 0.75 );
		else
			thread flashRumbleLoop( 0.25 );
	}
}

pauseEffect()
{
	self maps\_createfx::update_fx_looper(false);
}

restartEffect()
{
	self maps\_createfx::update_fx_looper(true);
}

createLoopEffect( fxid )
{
	ent = maps\_createfx::createEffect( "loopfx", fxid );
	ent.v["delay"] = 0.5;
	return ent;
}

createOneshotEffect( fxid )
{
	ent = maps\_createfx::createEffect( "oneshotfx", fxid );
	ent.v["delay"] = -15;
	return ent;
}


createExploder( fxid )
{
	ent = maps\_createfx::createEffect( "exploder", fxid );
	ent.v["delay"] = 0;
	ent.v["exploder_type"] = "normal";
	return ent;
}

getfxarraybyID( fxid )
{
	array = [];
	for(i=0;i<level.createFXent.size;i++)
	{
		if(level.createFXent[i].v["fxid"] == fxid)
			array[array.size] = level.createFXent[i];
	}
	return array;
}

ignoreAllEnemies( qTrue )
{
	self notify( "ignoreAllEnemies_threaded" );
	self endon( "ignoreAllEnemies_threaded" );
	
	if ( qTrue )
	{
		// put the ai in a threat bias group that ignores all the other groups so he
		// doesnt get distracted and go into exposed while his goal radius is too small
		
		self.old_threat_bias_group = self getthreatbiasgroup();
		
		num = undefined;
		/#
			num = self getentnum();
			println ( "entity: " + num + "ignoreAllEnemies TRUE" );
			println ( "entity: " + num + " threatbiasgroup is " + self.old_threat_bias_group );
		#/
		
		createthreatbiasgroup( "ignore_everybody" );
		/#
			println ( "entity: " + num + "ignoreAllEnemies TRUE" );
			println ( "entity: " + num + " setthreatbiasgroup( ignore_everybody )" );
		#/
		self setthreatbiasgroup( "ignore_everybody" );
		teams = [];
		teams["axis"] = "allies";
		teams["allies"] = "axis";
		
		assertEx( self.team != "neutral", "Why are you making a guy have team neutral? And also, why is he doing anim_reach?" );
		ai = getaiarray( teams[ self.team ] );
		groups = [];
		for ( i=0; i<ai.size; i++)
			groups[ ai[i] getthreatbiasgroup() ] = true;
	
		keys = getarraykeys( groups );
		for ( i=0; i<keys.size; i++ )
		{
			/#
				println ( "entity: " + num + "ignoreAllEnemies TRUE" );
				println ( "entity: " + num + " setthreatbias( " + keys[i] + ",ignore_everybody, 0 )" );
			#/
			setthreatbias( keys[i], "ignore_everybody", 0 );
		}
			
		// should now be impossible for this guy to attack anybody on the other team
	}
	else
	{
		num = undefined;
		assertEx( isdefined( self.old_threat_bias_group ), "You can't use ignoreAllEnemies(false) on an AI that has never ran ignoreAllEnemies(true)" );
		/#
			num = self getentnum();
			println ( "entity: " + num + "ignoreAllEnemies FALSE" );
			println ( "entity: " + num + " self.old_threat_bias_group is " +  self.old_threat_bias_group );
		#/
		if ( self.old_threat_bias_group != "" )
		{
			/#
				println ( "entity: " + num + "ignoreAllEnemies FALSE" );
				println ( "entity: " + num + " setthreatbiasgroup( " + self.old_threat_bias_group + " )" );
			#/
			self setthreatbiasgroup( self.old_threat_bias_group );
		}
		self.old_threat_bias_group = undefined;
	}
}

vehicle_detachfrompath()
{
	maps\_vehicle::vehicle_pathdetach();
}

vehicle_resumepath()
{
	maps\_vehicle::vehicle_resumepathvehicle();
}

vehicle_land()
{
	maps\_vehicle::vehicle_landvehicle();
}

vehicle_liftoff(height)
{
	maps\_vehicle::vehicle_liftoffvehicle(height);
}

vehicle_dynamicpath(node,bwaitforstart)
{
	maps\_vehicle::vehicle_dynamicpathsvehicle(node,bwaitforstart);
}


groundpos(origin)
{
	return bullettrace(origin, (origin + (0,0,-100000)),0,self)["position"];
}

change_player_health_packets( num )
{
	level.player_health_packets += num;
	level notify( "update_health_packets" );

	if ( level.player_health_packets >= 3 )
		level.player_health_packets = 3;

//	if ( level.player_health_packets <= 0 )
//		level.player dodamage( level.player.health + 1623453, ( 0,0,0 ) );
}

getvehiclespawner(targetname)
{
	spawner = getent(targetname+"_vehiclespawner","targetname");
	return spawner;
}

getvehiclespawnerarray(targetname)
{
	spawner = getentarray(targetname+"_vehiclespawner","targetname");
	return spawner;
}

player_fudge_moveto ( dest,moverate )
{
	//moverate = units/persecond
	if(!isdefined(moverate))
		moverate = 200;
	//this function is to fudge move the player. I'm using this as a placeholder for an actual animation
	
	org = spawn("script_origin",level.player.origin);
	org.origin = level.player.origin;
	level.player linkto (org);
	dist = distance(level.player.origin,dest);
	movetime = dist/moverate;
	org moveto (dest,dist/moverate, .05,.05);
	wait movetime;
	level.player unlink();
}


add_start( msg, func )
{
	assertEx( !isdefined( level._loadStarted ), "Can't create starts after _load" );
	if ( !isdefined( level.start_functions ) )
		level.start_functions = [];

	msg = tolower( msg );
	level.start_functions[ msg ] = func;
}

default_start( func )
{
	level.default_start = func;
}

linetime( start, end, color, timer )
{
	thread linetime_proc( start, end, color, timer );
}

/*
=============
///ScriptDocBegin
"Name: within_fov( <start_origin>, <start_angles>, <end_origin>, <fov> )"
"Summary: Returns true if <end_origin> is within the players field of view, otherwise returns false."
"Module: Vector"
"CallOn: "
"MandatoryArg: <start_origin>: starting origin for FOV check ( usually the players origin )"
"MandatoryArg: <start_angles>: angles to specify facing direction ( usually the players angles )"
"MandatoryArg: <end_origin>: origin to check if it's in the FOV"
"MandatoryArg: <fov>: cosine of the FOV angle to use"
"Example: qBool = within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = vectorNormalize( end_origin - start_origin );
	forward = anglestoforward( start_angles );
	dot = vectorDot( forward, normal );

	return dot >= fov;
}

waitSpread( start, end )
{
	if ( !isdefined( end ) )
	{
		end = start;
		start = 0;
	}
	assertEx( isdefined( start ) && isdefined( end ), "Waitspread was called without defining amount of time" );
	
	// temporarily disabling waitspread until I have time to fix it properly
	wait( randomfloatrange( start, end ) );
	if ( 1 )
		return;
	
	personal_wait_index = undefined;
	
	if ( !isdefined( level.active_wait_spread ) )
	{
		// the first guy sets it up and runs the master logic. Thread it off in case he dies
		
		level.active_wait_spread = true;
		level.wait_spreaders = 0;
		personal_wait_index = level.wait_spreaders;
		level.wait_spreaders++;
		thread waitSpread_code( start, end );
	}
	else
	{
		personal_wait_index = level.wait_spreaders;
		level.wait_spreaders++;
		waittillframeend; // give every other waitspreader in this frame a chance to increment wait_spreaders
	}

	waittillframeend; // wait for the logic to setup the waits
	
	wait( level.wait_spreader_allotment[ personal_wait_index ] );	
	
}

radio_dialogue( msg )
{
	assertEX( isdefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );
	level.player play_sound_on_entity ( level.scr_radio[ msg ] );
}

radio_dialogue_queue( msg )
{
	assertEX( isdefined( level.scr_radio[ msg ] ), "Tried to play radio dialogue " + msg + " that did not exist! Add it to level.scr_radio" );

	// thread off so if the calling thread gets killed we dont get stuck with a queue on the guy
	thread radio_queue_thread( msg );

	for ( ;; )
	{
		if ( !isdefined( self._radio_queue ) )
			break;
			
		self waittill( "finished_radio" );
	}
}


//HUD ELEMENT STUFF
hint_create(text, background)
{
	struct = spawnstruct();
	if(isdefined(background) && background == true)
		struct.bg = newHudElem();
	struct.elm = newHudElem();
	
	struct hint_position_internal();
	//elm.label 		= struct.text;
	//elm.debugtext 	= struct.text;
	struct.elm settext(text);

	return struct;
}

hint_delete()
{
	self notify("death");
	
	if(isdefined(self.elm))
		self.elm destroy();
	if(isdefined(self.bg))
		self.bg destroy();
}

hint_position_internal()
{
	if(level.xenon)
		self.elm.fontScale = 2;
	else
		self.elm.fontScale = 1.6;
		
	self.elm.x 			= 0;
	self.elm.y		 	= -40;
	self.elm.alignX 	= "center";
	self.elm.alignY 	= "bottom";	
	self.elm.horzAlign 	= "center";
	self.elm.vertAlign 	= "middle";
	
	if(!isdefined(self.bg))
		return;
		
	self.bg.x 			= 0;
	self.bg.y 			= -40;
	self.bg.alignX 		= "center";
	self.bg.alignY 		= "middle";
	self.bg.horzAlign 	= "center";
	self.bg.vertAlign 	= "middle";
	
	if(level.xenon)
		self.bg setshader("popmenu_bg", 650, 52);
	else
		self.bg setshader("popmenu_bg", 650, 42);
	self.bg.alpha = .5;
}

string( num )
{
	return ( "" + num );
}

ignoreEachOther( group1, group2 )
{
	// these threatbias groups ignore each other
	assertEx( threatbiasgroupexists( group1 ), "Tried to make threatbias group " + group1 + " ignore " + group2 + " but " + group1 + " does not exist!" );
	assertEx( threatbiasgroupexists( group2 ), "Tried to make threatbias group " + group2 + " ignore " + group1 + " but " + group2 + " does not exist!" );
	setIgnoreMeGroup( group1, group2 );
	setIgnoreMeGroup( group2, group1 );
}

add_spawn_function( function, param1, param2, param3 )
{
	assertEx( !isalive( self ), "Tried to add_spawn_function to a living guy." );
	assertEx( isdefined( self.spawn_functions ), "Tried to add_spawn_function before calling _load" );
	
	func = [];
	func[ "function" ] = function;
	func[ "param1" ] = param1;
	func[ "param2" ] = param2;
	func[ "param3" ] = param3;
	
	self.spawn_functions[ self.spawn_functions.size ] = func;
}

array_delete( array )
{
	for ( i=0; i < array.size; i++ )
	{
		array[ i ] delete();
	}
}


PlayerUnlimitedAmmoThread()
{
	while (1)
	{
		wait .5;

		currentWeapon = level.player getCurrentWeapon();
		if ( currentWeapon == "none" )
			continue;

		currentAmmo = level.player GetFractionMaxAmmo( currentWeapon );
		if ( currentAmmo < 0.2 )
			level.player GiveMaxAmmo( currentWeapon );
	}
}

ignore_triggers( timer )
{
	// ignore triggers for awhile so others can trigger the trigger we're in.
	self endon( "death" );
	self.ignoreTriggers = true;
	if ( isdefined( timer ) )
	{
		wait( timer );
	}
	else
	{
		wait( 0.5 );
	}
	self.ignoreTriggers = false;
}

/*
=============
///ScriptDocBegin
"Name: delayThread( <delay>, <function>, <arg1>, <arg2>, <arg3> )"
"Summary: Delaythread is cool! It saves you from having to write extra script for once off commands. Note you don’t have to thread it off. Delaythread is that smart!"
"Module: Utility"
"MandatoryArg: <delay>: The delay before the function occurs"
"MandatoryArg: <delay>: The function to run."
"OptionalArg: <arg1>: parameter 1 to pass to the process"
"OptionalArg: <arg2>: parameter 2 to pass to the process"
"OptionalArg: <arg3>: parameter 3 to pass to the process"
"Example: Delaythread( ::flag_set, "player_can_rappel", 3 );
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

delayThread( timer, func, param1, param2, param3 )
{
	// to thread it off
	thread delayThread_proc( func, timer, param1, param2, param3 );
}

activate_trigger_with_targetname( msg )
{
	trigger = getent( msg, "targetname" );
	trigger activate_trigger();
}

activate_trigger_with_noteworthy( msg )
{
	trigger = getent( msg, "script_noteworthy" );
	trigger activate_trigger();
}

is_hero()
{
	return isdefined( level.hero_list[ get_ai_number() ] );
}

get_ai_number()
{
	if ( !isdefined( self.ai_number ) )
	{
		set_ai_number();
	}
	return self.ai_number;
}

set_ai_number()
{
	self.ai_number = level.ai_number;
	level.ai_number++;
}

make_hero()
{
	level.hero_list[ self.ai_number ] = true;
}

unmake_hero()
{
	level.hero_list[ self.ai_number ] = undefined;
}

get_heroes()
{
	array = [];
	ai = getaiarray( "allies" );
	for ( i=0; i < ai.size; i++ )
	{
		if ( ai[ i ] is_hero() )
			array[ array.size ] = ai[ i ];
	}
	return array;
}

set_team_pacifist( team, val )
{
	ai = getaiarray( team );
	for ( i=0; i < ai.size; i++ )
	{
		ai[ i ].pacifist = val;
	}
}

replace_on_death()
{
	maps\_colors::colorNode_replace_on_death();
}

spawn_reinforcement( classname, color )
{
	maps\_colors::colorNode_spawn_reinforcement( classname, color );
}

clear_promotion_order()
{
	level.current_color_order = [];
}

set_promotion_order( deadguy, replacer )
{
	if ( !isdefined( level.current_color_order ) )
	{
		level.current_color_order = [];
	}

	deadguy = shortenColor( deadguy );
	replacer = shortenColor( replacer );
	
	level.current_color_order[ deadguy ] = replacer;
	
	// if there is no color order for the replacing color than
	// let script assume that it is meant to be replaced by
	// respawning guys
	if ( !isdefined( level.current_color_order[ replacer ] ) )
		set_empty_promotion_order( replacer );
}

set_empty_promotion_order( deadguy )
{
	if ( !isdefined( level.current_color_order ) )
	{
		level.current_color_order = [];
	}

	level.current_color_order[ deadguy ] = "none";
}

remove_dead_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( !isalive( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_undefined_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( !isdefined( array[ i ] ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_heroes_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( array[ i ] is_hero() )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_all_animnamed_guys_from_array( array )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( isdefined( array[ i ].animname ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

remove_color_from_array( array, color )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( !isdefined( guy.script_forceColor ) )
			continue;
		if ( guy.script_forceColor == color )
			continue;
		newarray[ newarray.size ] = guy;
	}
	return newarray;
}

remove_noteworthy_from_array( array, noteworthy )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( !isdefined( guy.script_noteworthy) )
			continue;
		if ( guy.script_noteworthy == noteworthy )
			continue;
		newarray[ newarray.size ] = guy;
	}
	return newarray;
}

get_closest_colored_friendly( color, origin )
{
	allies = get_force_color_guys( "allies", color );
	allies = remove_heroes_from_array( allies );

	if ( !isdefined( origin ) )
		friendly_origin = level.player.origin;
	else
		friendly_origin = origin;

	return getclosest( friendly_origin, allies );
}

remove_ai_without_classname( array, classname )
{
	newarray = [];
	for ( i=0; i < array.size; i++ )
	{
		if ( !issubstr( array[ i ].classname, classname ) )
			continue;
		newarray[ newarray.size ] = array[ i ];
	}
	return newarray;
}

get_closest_colored_friendly_with_classname( color, classname, origin )
{
	allies = get_force_color_guys( "allies", color );
	allies = remove_heroes_from_array( allies );

	if ( !isdefined( origin ) )
		friendly_origin = level.player.origin;
	else
		friendly_origin = origin;
		
	allies = remove_ai_without_classname( allies, classname );

	return getclosest( friendly_origin, allies );
}



promote_nearest_friendly( colorFrom, colorTo )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly( colorFrom );
		if ( !isalive( friendly ) )
		{
			wait( 1 );
			continue;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_promote_nearest_friendly( colorFrom, colorTo )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly( colorFrom );
		if ( !isalive( friendly ) )
		{
			assertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
			return;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_promote_nearest_friendly_with_classname( colorFrom, colorTo, classname )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly_with_classname( colorFrom, classname );
		if ( !isalive( friendly ) )
		{
			assertEx( 0, "Instant promotion from " + colorFrom + " to " + colorTo + " failed!" );
			return;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

promote_nearest_friendly_with_classname( colorFrom, colorTo, classname )
{
	for ( ;; )
	{
		friendly = get_closest_colored_friendly_with_classname( colorFrom, classname );
		if ( !isalive( friendly ) )
		{
			wait( 1 );
			continue;
		}
		
		friendly set_force_color( colorTo );
		return;
	}
}

instantly_set_color_from_array_with_classname( array, color, classname )
{
	// the guy is removed from the array so the function can be run on the array again
	foundGuy = false;
	newArray = [];
	for ( i=0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( foundGuy || !isSubstr( guy.classname, classname ) )
		{
			newArray[ newArray.size ] = guy;
			continue;
		}

		foundGuy = true;
		guy set_force_color( color );
	}
	return newArray;
}

instantly_set_color_from_array( array, color )
{
	// the guy is removed from the array so the function can be run on the array again
	foundGuy = false;
	newArray = [];
	for ( i=0; i < array.size; i++ )
	{
		guy = array[ i ];
		if ( foundGuy  )
		{
			newArray[ newArray.size ] = guy;
			continue;
		}

		foundGuy = true;
		guy set_force_color( color );
	}
	return newArray;
}

wait_for_script_noteworthy_trigger( msg )
{	
	wait_for_trigger( msg, "script_noteworthy" );
}

wait_for_targetname_trigger( msg )
{	
	wait_for_trigger( msg, "targetname" );
}

wait_for_flag_or_timeout( msg, timer )
{
	if ( flag( msg ) )
		return;
		
	ent = spawnStruct();
	ent thread ent_waits_for_level_notify( msg );
	ent thread ent_times_out( timer );
	ent waittill( "done" );
}

wait_for_trigger_or_timeout( timer )
{
	ent = spawnStruct();
	ent thread ent_waits_for_trigger( self );
	ent thread ent_times_out( timer );
	ent waittill( "done" );
}

wait_for_either_trigger( msg1, msg2 )
{	
	ent = spawnStruct();
	array = [];
	array = array_combine( array, getentarray( msg1, "targetname" ) );
	array = array_combine( array, getentarray( msg2, "targetname" ) );
	for ( i = 0; i < array.size; i++ )
	{
		ent thread ent_waits_for_trigger( array[ i ] );
	}

	ent waittill( "done" );
}

script_gen_dump_addline ( string,signature )
{
	
	if(!isdefined(string))
		string = "nowrite"; // some things like the standardized CSV sound entries don't really need anything in script. just the asset
		
	if(!isdefined(level._loadstarted))
	{
			//stashes commands away so they can be handled in the correct place within load
			if(!isdefined(level.script_gen_dump_preload))
				level.script_gen_dump_preload = [];
			struct = spawnstruct();
			struct.string = string;
			struct.signature = signature;
			level.script_gen_dump_preload[level.script_gen_dump_preload.size] = struct;
			return;
	}
		
		
	if(!isdefined(level.script_gen_dump[signature]))
		level.script_gen_dump_reasons[level.script_gen_dump_reasons.size] = "Added: "+string; //console print as well as triggering the dump
	level.script_gen_dump[signature] = string;
	level.script_gen_dump2[signature] = string; // second array gets compared later with saved array. When something is missing dump is generated
}

dronespawn ( spawner )
{
	spawner = maps\_spawner::spawner_dronespawn(spawner);
	assert(isdefined(spawner));
	return spawner;
}

makerealai ( drone )
{
	return maps\_spawner::spawner_makerealai(drone);
	
}


get_trigger_flag()
{
	if ( isdefined( self.script_flag ) )
	{
		return self.script_flag;
	}
	
	if ( isdefined( self.script_noteworthy ) )
	{
		return self.script_noteworthy;
	}
	
	assertEx( 0, "Flag trigger at " + self.origin + " has no script_flag set." );
}

isSpawner()
{
	spawners = getspawnerarray();
	for ( i=0; i < spawners.size; i++ )
	{
		if ( spawners[ i ] == self )
			return true;
	}
	return false;
}

set_default_pathenemy_settings()
{
	if ( self.team == "allies" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
		return;
	}
	if ( self.team == "axis" )
	{
		self.pathEnemyLookAhead = 350;
		self.pathEnemyFightDist = 350;
		return;
	}
}

cqb_walk(on_or_off) // (deprecated)
{
	if ( on_or_off == "on" )
	{
		self enable_cqbwalk();
	}
	else
	{
		assert( on_or_off == "off" );
		self disable_cqbwalk();
	}
}
enable_cqbwalk()
{
	self.cqbwalking = true;
	level thread animscripts\shared::findCQBPointsOfInterest();
	/#
	self thread animscripts\shared::CQBDebug();
	#/
}
disable_cqbwalk()
{
	self.cqbwalking = false;
	self.cqb_point_of_interest = undefined;
}

cqb_aim( the_target )
{
	if ( !isdefined( the_target ) )
	{
		self.cqb_target = undefined;
	}
	else
	{
		self.cqb_target = the_target;	
		
		if ( !isdefined( the_target.origin ) )
			assertmsg("target passed into cqb_aim does not have an origin!");
	}
}


set_force_cover( val )
{
	assertEx( val == "hide" || val == "none" || val == "show", "invalid force cover set on guy" );
	assertEx( isalive( self ), "Tried to set force cover on a dead guy" );
	self.a.forced_cover = val;
}

waittill_notify_or_timeout( msg, timer )
{
	self endon( msg );
	wait( timer );
}

do_in_order( func1, param1, func2, param2 )
{
	[[ func1 ]]( param1 );
	[[ func2 ]]( param2 );
}

scrub()
{
	// sets an AI to default settings, ignoring the .script_ values on him.
	self maps\_spawner::scrub_guy();
}
send_notify( msg )
{
	// functionalized so it can be function pointer'd
	self notify( msg );
}

deleteEnt( ent )
{
	// created so entities can be deleted using array_thread
	ent delete();
}


getfx( fx )
{
	assertEx( isdefined( level._effect[ fx ] ), "Fx " + fx + " is not defined in level._effect." );
	return level._effect[ fx ];
}

getanim( anime )
{
	assertEx( isdefined( self.animname ), "Called getanim on a guy with no animname" );
	assertEx( isdefined( level.scr_anim[ self.animname ][ anime ] ), "Called getanim on an inexistent anim" );
	return level.scr_anim[ self.animname ][ anime ];
}

add_hint_string( name, string, optionalFunc )
{
	assertex( isdefined( level.trigger_hint_string ), "Tried to add a hint string before _load was called." );
	assertEx( isdefined( name ), "Set a name for the hint string. This should be the same as the script_hint on the trigger_hint." );
	assertEx( isdefined( string ), "Set a string for the hint string. This is the string you want to appear when the trigger is hit." );
		
	level.trigger_hint_string[ name ] = string;
	if ( isdefined( optionalFunc ) )
	{
		level.trigger_hint_func[ name ] = optionalFunc;
	}
}

fire_radius( origin, radius )
{
	/#
	if ( level.createFX_enabled )
		return;
	#/
	
	trigger = spawn( "trigger_radius", origin, 0, radius, 48 );

	for ( ;; )
	{
		trigger waittill( "trigger", other );
		assertEx( other == level.player, "Tried to burn a non player in a fire" );
		level.player dodamage( 5, origin );
	}
}

clearThreatBias( group1, group2 )
{
	setThreatBias( group1, group2, 0 );
	setThreatBias( group2, group1, 0 );
}

scr_println( msg )
{
	// so println can be called from a function pointer
	println( msg );
}

// use in moderation!
ThrowGrenadeAtPlayerASAP()
{
	animscripts\combat_utility::ThrowGrenadeAtPlayerASAP_combat_utility();
}

//scriptgen precache wrapper commands - Nathan
//This will enable automatic zone source CSV exports if approved

/*
	It's important that when you write scripts with sg_precache in 
	them that you halt the scripts that use these assets when a scriptgen dump is required.
	
	If done currectly before the scriptgen dump call all of of the sg_precache commands will happen 
	and you won't have to run the game again to catch new sg_precaches;
	
	Do this to wait untill the sg_precache dump has been called (now it's ok to continue);
	
	sg_wait_dump();
	
	sg_precache lines should go before _load but in the case of tools they can go after.   
	IE in effectsEd somebody could initiate a dump after specifying some new assets to load.

*/

sg_precachemodel(model)
{
	script_gen_dump_addline("precachemodel(\""+model+"\");","xmodel_"+model);  // adds to scriptgendump
	
}

sg_precacheitem(item)
{
	script_gen_dump_addline("precacheitem(\""+item+"\");","item_"+item);  // adds to scriptgendump
}

sg_precachemenu(menu)
{
	script_gen_dump_addline("precachemenu(\""+menu+"\");","menu_"+menu);  // adds to scriptgendump
}

sg_precacherumble(rumble)
{
	script_gen_dump_addline("precacherumble(\""+rumble+"\");","rumble_"+rumble);  // adds to scriptgendump
}

sg_precacheshader(shader)
{
	script_gen_dump_addline("precacheshader(\""+shader+"\");","shader_"+shader);  // adds to scriptgendump
}

sg_precacheshellshock(shock)
{
	script_gen_dump_addline("precacheshellshock(\""+shock+"\");","shock_"+shock);  // adds to scriptgendump
}

sg_precachestring(string)
{
	script_gen_dump_addline("precachestring(\""+string+"\");","string_"+string);  // adds to scriptgendump
}

sg_precacheturret(turret)
{
	script_gen_dump_addline("precacheturret(\""+turret+"\");","turret_"+turret);  // adds to scriptgendump
}

sg_precachevehicle(vehicle)
{
	script_gen_dump_addline("precachevehicle(\""+vehicle+"\");","vehicle_"+vehicle);  // adds to scriptgendump
}

sg_getanim(animation)
{
	return level.sg_anim[animation];
}

sg_getanimtree(animtree)
{
	return level.sg_animtree[animtree];
}



sg_precacheanim(animation,animtree)
{
	if(!isdefined(animtree))
		animtree = "generic_human";
	/*
	 this is where the money is at.  we no longer have to seperate scripts that have animations in them
	 this eliminates the need for seperate vehiclescript calls, gags with animations, etc. 
	 animations are a string value when sg_precacheanim is called this writes them to the script gen and the CSV as animations
	 usage is something like this
	 
	sg_precacheanim(animation);
	
	when you go to use the anim do:
	
	animation = sg_getanim(animation);
	
	this will get the animation from scriptgen.
	
	*/
//	script_gen_dump_addline("level.sg_anim[\""+animation+"\"] = %"+animation+";","animation_"+animation);  // adds to scriptgendump
	
	sg_csv_addtype("xanim",animation);
	if(!isdefined(level.sg_precacheanims))
		level.sg_precacheanims = [];
	if(!isdefined(level.sg_precacheanims[animtree]))
		level.sg_precacheanims[animtree] = [];
	
	level.sg_precacheanims[animtree][animation] = true; // no sence setting it to anything else if the string is already in array key. beh.
}



sg_getfx(fx)
{
	return level.sg_effect[fx];
}

sg_precachefx(fx)
{
	/*
	
	effects require an id returned from loadfx. it's a little bit different kind of asset but will work the same as animations
	
	use
	
	sg_getfx(fx); to get the effects id for the specified effect string
	
	*/
	script_gen_dump_addline("level.sg_effect[\""+fx+"\"] = loadfx(\""+fx+"\");","fx_"+fx);  // adds to scriptgendump
}

sg_wait_dump()
{
	flag_wait("scriptgen_done");
}

sg_standard_includes()
{
	
	sg_csv_addtype("ignore","code_post_gfx");
	sg_csv_addtype("ignore","common");
	sg_csv_addtype("col_map_sp","maps/"+tolower(getdvar ("mapname"))+".d3dbsp");
	sg_csv_addtype("gfx_map","maps/"+tolower(getdvar ("mapname"))+".d3dbsp");
	sg_csv_addtype("rawfile","maps/"+tolower(getdvar ("mapname"))+".gsc");
	sg_csv_addtype("rawfile","maps/scriptgen/"+tolower(getdvar ("mapname"))+"_scriptgen.gsc");
	
	sg_csv_soundadd("us_battlechatter","all_sp"); // todo. find this automagically by ai's
	sg_csv_soundadd("ab_battlechatter","all_sp"); // 
	
	sg_csv_soundadd("voiceovers","all_sp");
	sg_csv_soundadd("common","all_sp");
	sg_csv_soundadd("generic","all_sp");
	sg_csv_soundadd("requests","all_sp");

//	ignore,code_post_gfx
//	ignore,common
//	col_map_sp,maps/nate_test.d3dbsp
//	gfx_map,maps/nate_test.d3dbsp
//	rawfile,maps/nate_test.gsc
//	sound,voiceovers,rallypoint,all_sp
//	sound,us_battlechatter,rallypoint,all_sp
//	sound,ab_battlechatter,rallypoint,all_sp
//	sound,common,rallypoint,all_sp
//	sound,generic,rallypoint,all_sp
//	sound,requests,rallypoint,all_sp	
	
}

sg_csv_soundadd(type,loadspec)
{
	script_gen_dump_addline("nowrite Sound CSV entry: "+type,"sound_"+type+","+tolower(getdvar ("mapname"))+","+loadspec);  // adds to scriptgendump
}

sg_csv_addtype(type,string)
{
	script_gen_dump_addline("nowrite CSV entry: "+type+","+string, type+"_"+string);  // adds to scriptgendump
}

array_combine_keys(array1,array2)  // mashes them in. array 2 will overwrite like keys, this works for what I'm using it for - Nate.
{
	if(!array1.size)
		return array2;
	keys = getarraykeys(array2);
	for(i=0;i<keys.size;i++)
		array1[keys[i]] = array2[keys[i]];
	return array1;
}

set_ignoreSuppression( val )
{
	self.ignoreSuppression = val;
}

set_goal_node( node )
{
	self setgoalnode( node );
}

set_goal_pos( pos )
{
	self setgoalpos( pos );
}

set_goal_radius( radius )
{
	self.goalradius = radius;
}

try_forever_spawn()
{
	export = self.export;
	for ( ;; )
	{
		assertEx( isdefined( self ), "Spawner with export " + export + " was deleted." );
		guy = self dospawn();
		if ( spawn_failed( guy ) )
		{
			wait( 1 );
			continue;
		}
		return guy;
	}
}


set_run_anim( anime )
{
	assertEx( isdefined( anime ), "Tried to set run anim but didn't specify which animation to ues" );
	assertEx( isdefined( self.animname ), "Tried to set run anim on a guy that had no anim name" );
	assertEx( isdefined( level.scr_anim[ self.animname ][ anime ] ), "Tried to set run anim but the anim was not defined in the maps _anim file" );
	
	self.a.combatrunanim = level.scr_anim[ self.animname ][ anime ];
	self.preCombatRunEnabled = false;
}

clear_run_anim()
{
	animscripts\init::SetupUniqueAnims();
	self.preCombatRunEnabled = true;
}

debugvar( msg, timer )
{
	if ( getdvar( msg ) == "" )
	{
		setdvar( msg, timer );
	}
	return getdvarfloat( msg );
}

physicsjolt_proximity( outer_radius, inner_radius, force )
{
	// Usage: <entity> thread physicjolt_proximity( 400, 256, (0,0,0.1) );

	self endon( "death" );
	self endon( "stop_physicsjolt" );

	if ( !isdefined(outer_radius) || !isdefined(inner_radius) || !isdefined(force) )
	{
		outer_radius = 400;
		inner_radius = 256;
		force = ( 0, 0, 0.075 );	// no direction on this one.
	}

	fade_distance = outer_radius*outer_radius;

	fade_speed = 3;
	base_force = force;

	while ( true )
	{
		wait 0.1; 

		force = base_force;

		if ( self.classname == "script_vehicle" )
		{
			speed = self getspeedMPH();
			if ( speed < fade_speed )
			{
				scale = speed / fade_speed;
				force = vector_multiply( base_force, scale );
			}
		}

		dist = distancesquared( self.origin, level.player.origin );
		scale = fade_distance / dist;
		if ( scale > 1 )
			scale = 1;
		force = vector_multiply( force, scale );
		total_force = force[0] + force[1] + force[2];

		if ( total_force > 0.025 )
			physicsJitter( self.origin, outer_radius, inner_radius, force[2], force[2] * 2.0 );
	}
}

set_goal_entity( ent )
{
	self setGoalEntity( ent );
}


activate_trigger()
{
	assertEx( !isdefined( self.trigger_off ), "Tried to activate trigger that is OFF (either from trigger_off or from flags set on it through shift-G menu" );
	self notify( "trigger" );
	
	if ( self.classname != "trigger_friendlychain" )
		return;

	node = getnode( self.target, "targetname" );
	assertEx( isdefined( node ), "Trigger_friendlychain at " + self.origin + " doesn't target a node" );
	level.player setfriendlychain( node );
}

/*
=============
///ScriptDocBegin
"Name: self_delete()"
"Summary: Just calls the delete() script command on self. Reason for this is so that we can use array_thread to delete entities"
"Module: Entity"
"CallOn: An entity"
"Example: ai[ 0 ] thread self_delete();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
self_delete()
{
	self delete();
}

remove_noColor_from_array( ai )
{
	newarray = [];
	for ( i=0; i < ai.size; i++ )
	{
		guy = ai[ i ];
		if ( guy has_color() )
			newarray[ newarray.size ] = guy;
	}
	
	return newarray;
}

has_color()
{
	// can lose color during the waittillframeend in left_color_node
	if ( self.team == "axis" )
	{
		return isdefined( self.script_color_axis ) || isdefined( self.script_forceColor );
	}
	
	return isdefined( self.script_color_allies ) || isdefined( self.script_forceColor );
}

clear_colors()
{
	clear_team_colors( "axis" );
	clear_team_colors( "allies" );
}

clear_team_colors( team )
{
	level.currentColorForced[ team ][ "r" ] = undefined;
	level.currentColorForced[ team ][ "b" ] = undefined;
	level.currentColorForced[ team ][ "c" ] = undefined;
	level.currentColorForced[ team ][ "y" ] = undefined;
	level.currentColorForced[ team ][ "p" ] = undefined;
	level.currentColorForced[ team ][ "o" ] = undefined;
	level.currentColorForced[ team ][ "g" ] = undefined;
}


get_script_palette()
{
	rgb = [];
	rgb[ "r" ] = ( 1,0,0 );
	rgb[ "o" ] = ( 1,0.5,0 );
	rgb[ "y" ] = ( 1,1,0 );
	rgb[ "g" ] = ( 0,1,0 );
	rgb[ "c" ] = ( 0,1,1 );
	rgb[ "b" ] = ( 0,0,1 );
	rgb[ "p" ] = ( 1,0,1 );
	return rgb;
}

/*
=============
///ScriptDocBegin
"Name: notify_delay( <notify_string>, <delay> )"
"Summary: Notifies self the string after waiting the specified delay time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <notify_string>: The string to notify"
"MandatoryArg: <delay>: Time to wait ( in seconds ) before sending the notify."
"Example: vehicle notify_delay( "start_to_smoke", 3.5 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
notify_delay( sNotifyString, fDelay )
{
	assert( isdefined( self ) );
	assert( isdefined( sNotifyString ) );
	assert( isdefined( fDelay ) );
	assert( fDelay > 0 );
	
	self endon( "death" );
	wait fDelay;
	if ( !isdefined( self ) )
		return;
	self notify( sNotifyString );
}

/*
=============
///ScriptDocBegin
"Name: gun_remove()"
"Summary: Removed the gun from the given AI. Often used for scripted sequences where you dont want the AI to carry a weapon."
"Module: AI"
"CallOn: An AI"
"Example: level.price gun_remove();"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
gun_remove()
{
	self animscripts\shared::placeWeaponOn( self.weapon, "none" );
}


/*
=============
///ScriptDocBegin
"Name: lerp_player_view_to_tag( <tag>, <lerptime>, <fraction>, <right_arc>, <left_arc>, <top_arc>, <bottom_arc> )"
"Summary: Lerps the player's view to the tag on the entity that calls the function.."
"Module: Utility"
"CallOn: An entity you want to lerp the player's view to."
"MandatoryArg: <tag>: Tag on the entity that you're lerping to."
"MandatoryArg: <lerptime>: Time to lerp over."
"OptionalArg: <fraction>: 0 to 1 amount that the rotation of the player's view should be effected by the entity. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <arcs>: Various arcs that limit how far the player can change his view."
"Example: car lerp_player_view_to_tag( "tag_windshield", 1 );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

lerp_player_view_to_tag( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
	origin = self gettagorigin( "tag_player" );
	angles = self gettagangles( "tag_player" );
	lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc );
	level.player playerlinkto( self, tag, fraction, right_arc, left_arc, top_arc, bottom_arc );
}

/*
=============
///ScriptDocBegin
"Name: lerp_player_view_to_position( <origin>, <angles>, <lerptime>, <fraction>, <right_arc>, <left_arc>, <top_arc>, <bottom_arc> )"
"Summary: Lerps the player's view to an origin and angles. See lerp_player_view_to_tag."
"Module: Utility"
"MandatoryArg: <origin>: The origin you're lerping to."
"MandatoryArg: <angles>: The angles you're lerping to."
"MandatoryArg: <lerptime>: Time to lerp over."
"OptionalArg: <fraction>: 0 to 1 amount that the rotation of the player's view should be effected by the destination angles. If you set it less than 1 then the player's view will not get all the way to the final angle."
"OptionalArg: <arcs>: Various arcs that limit how far the player can change his view."
"Example: lerp_player_view_to_position( org.origin, org.angles );"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/

lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc )
{
	linker = spawn( "script_origin", (0,0,0) );
	linker.origin = level.player.origin;
	linker.angles = level.player getplayerangles();
	if ( isdefined( right_arc ) )
	{
		level.player playerlinkto( linker, "", fraction, right_arc, left_arc, top_arc, bottom_arc );
	}
	else
	if ( isdefined( fraction ) )
	{
		level.player playerlinkto( linker, "", fraction );
	}
	else
	{
		level.player playerlinkto( linker );
	}
		
	linker moveto( origin, lerptime, lerptime * 0.25 );
	linker rotateto( angles, lerptime, lerptime * 0.25 );
	wait( lerptime );
}