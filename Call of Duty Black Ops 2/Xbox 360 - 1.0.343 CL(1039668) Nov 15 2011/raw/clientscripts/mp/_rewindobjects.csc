#include clientscripts\mp\_utility;

init_rewind()
{
	level.rewindWatcherArray = [];

}

initRewindObjectWatchers( localClientNum )
{
	level.rewindWatcherArray[localClientNum] = [];
	createNapalmRewindWatcher( localClientNum );
	createAirstrikeRewindWatcher( localClientNum );
	level thread watchRewindableEvents( localClientNum );
}

watchRewindableEvents( localClientNum )
{
	for (;;)
	{
		if ( isdefined( level.rewindWatcherArray[localClientNum] ) )
		{
			rewindWatcherKeys = getArrayKeys( level.rewindWatcherArray[localClientNum] );
			for ( i = 0; i < rewindWatcherKeys.size; i++ )
			{
				rewindWatcher = level.rewindWatcherArray[localClientNum][rewindWatcherKeys[i]];

				if ( !isdefined( rewindWatcher ) )
					continue;
				
				if ( !isdefined( rewindWatcher.event ) )
					continue;
				
				timeKeys = getArrayKeys( rewindWatcher.event );
				for ( j = 0; j < timeKeys.size; j++ )
				{
					timeKey = timeKeys[j];
					if ( rewindWatcher.event[timeKey].inProgress == true )
						continue;

					if ( level.serverTime >= timeKey )
					{
						rewindWatcher thread startRewindableEvent( localClientNum, timeKey );
					}
				}
			}
		}
		wait( 0.1 );
	}
}

startRewindableEvent( localClientNum, timeKey )
{
	player = getlocalplayer( localClientNum );
	level endon( "demo_jump" + localClientNum );
	self.event[timeKey].inProgress = true;
	allFunctionsStarted = false;
	while( allFunctionsStarted == false )
	{
		allFunctionsStarted = true;
		assert(isdefined( self.timedFunctions  ) );
		timedFunctionKeys = getArrayKeys( self.timedFunctions );
		
		for ( i = 0; i < timedFunctionKeys.size; i++ )
		{
			timedFunction = self.timedFunctions[timedFunctionKeys[i]];
			timedFunctionKey = timedFunctionKeys[i];
			if ( self.event[timeKey].timedFunction[timedFunctionKey] == true )
				continue;
			startTime = timeKey + ( timedFunction.startTimeSec * 1000 );
			if ( startTime > level.serverTime )
			{
				allFunctionsStarted = false;
				continue;
			}
			self.event[timeKey].timedFunction[timedFunctionKey] = true;
				
			level thread [[timedFunction.function]]( localClientNum, startTime, timedFunction.startTimeSec, self.event[timeKey].data );
		}
		wait( 0.1 );
	}
}

createNapalmRewindWatcher( localClientNum )
{
	napalmRewindWatcher = createRewindWatcher( localClientNum, "napalm" );
	
	timeIncreaseBetweenPlanes = 0;
	
	//napalmRewindWatcher addTimedFunction( "napalmPlane", clientscripts\mp\_plane::flyPlane, timeIncreaseBetweenPlanes );
}

createAirstrikeRewindWatcher( localClientNum )
{
	airstrikeRewindWatcher = createRewindWatcher( localClientNum, "airstrike" );
//	airstrikeRewindWatcher addTimedFunction( "aistrikePlane", clientscripts\mp\_airstrike::flyAirstrikePlane, 0 );
}


createRewindWatcher( localClientNum, name )
{
	player = getlocalplayer( localClientNum );
	if ( !IsDefined(level.rewindWatcherArray[localClientNum]) )
	{
		level.rewindWatcherArray[localClientNum] = [];
	}
	
	rewindWatcher = getRewindWatcher( localClientNum, name );
	
	if ( !IsDefined( rewindWatcher ) )
	{ 
		rewindWatcher = SpawnStruct();
		level.rewindWatcherArray[localClientNum][level.rewindWatcherArray[localClientNum].size] = rewindWatcher;
	}
	
	rewindWatcher.name = name;
	rewindWatcher.event = [];

	rewindWatcher thread resetOnDemoJump( localClientNum );
		
	return 	rewindWatcher;
}

resetOnDemoJump( localClientNum )
{
	for (;;)
	{
		level waittill( "demo_jump" + localClientNum ); 
		
		self.inProgress = false;
	
		timedFunctionKeys = getArrayKeys( self.timedFunctions );
		
		for ( i = 0; i < timedFunctionKeys.size; i++ )
		{
			self.timedFunctions[timedFunctionKeys[i]].inProgress = false;
		}

		eventKeys = getArrayKeys( self.event );
		for ( i = 0; i < eventKeys.size; i++ )
		{
			self.event[eventKeys[i]].inProgress = false;
			timedFunctionKeys = getArrayKeys( self.event[eventKeys[i]].timedFunction );
			for ( index = 0; index < timedFunctionKeys.size; index++ )
			{
				self.event[eventKeys[i]].timedFunction[timedFunctionKeys[index]] = false;
			}
		}
	}
}

addTimedFunction( name, function, relativeStartTimeInSecs )
{
	if ( !IsDefined(self.timedFunctions) )
	{
		self.timedFunctions = [];
	}
	
	assert( !isdefined(self.timedFunctions[name] ) );
	
	self.timedFunctions[name] = spawnStruct();
	self.timedFunctions[name].inProgress = false;
	self.timedFunctions[name].function = function;
	self.timedFunctions[name].startTimeSec = relativeStartTimeInSecs;
}

getRewindWatcher( localClientNum, name )
{
	if ( !IsDefined( level.rewindWatcherArray[localClientNum] ) )
	{
		return undefined;
	}
	
	for ( watcher = 0; watcher < level.rewindWatcherArray[localClientNum].size; watcher++ )
	{
		if (level.rewindWatcherArray[localClientNum][watcher].name == name )
		{
			return level.rewindWatcherArray[localClientNum][watcher];
		}
	}
	
	return undefined;
}

addRewindableEventToWatcher( startTime, data )
{
	// duplicate message
	if ( isdefined( self.event[startTime] ) )
	{
		return;
	}
		
	self.event[startTime] = spawnStruct();
	self.event[startTime].data = data;
	self.event[startTime].inprogress = false;

	if ( isdefined( self.timedFunctions ) )
	{
		timedFunctionKeys = getArrayKeys( self.timedFunctions );
		self.event[startTime].timedFunction = [];
		for ( i = 0; i < timedFunctionKeys.size; i++ )
		{
			timedFunctionKey = timedFunctionKeys[i];
			self.event[startTime].timedFunction[timedFunctionKey] = false;
		}
	}
}

serverTimedMoveTo( localClientNum, startPoint, endPoint, startTime, duration )
{
	level endon( "demo_jump" + localClientNum );
	timeElapsed = ( level.serverTime - startTime ) * 0.001;
	assert( duration > 0 );
	doJump = true;
	if ( timeElapsed < 0.02 ) 
		doJump = false;
	if ( timeElapsed < duration )
	{
		moveTime = duration - timeElapsed;
		if ( doJump )
		{
			jumpPoint = getPointOnLine( startPoint, endPoint, ( timeElapsed / duration ) );
			self.origin = jumpPoint;
		}
		self moveTo( endPoint, moveTime, 0, 0 );	
		return true;
	}
	else 
	{
		self.origin = endPoint;
		return false;
	}
}

serverTimedRotateTo( localClientNum, angles, startTime, duration )
{
	level endon( "demo_jump" + localClientNum );
	timeElapsed = ( level.serverTime - startTime ) * 0.001;
	assert( duration > 0 );
	if ( timeElapsed < duration )
	{
		rotateTime = duration - timeElapsed;
		self RotateTo(angles, rotateTime, 0, 0 );	
		return true;
	}
	else 
	{
		self.angles = angles;
		return false;
	}
}

waitForServerTime( localClientNum, timeFromStart )
{
 	while( timeFromStart > level.serverTime )
 	{
	 	wait(0.01);
 	}
}

removeClientEntOnJump( clientEnt, localClientNum )
{
	clientEnt endon( "complete" );
	player = GetLocalPlayer( localClientNum );
	level waittill( "demo_jump" + localClientNum );

	clientEnt notify( "delete" );
	clientEnt forcedelete();
}

getPointOnLine( startPoint, endPoint, ratio )
{
	nextPoint = ( startPoint[0] + ( ( endPoint[0] - startPoint[0] ) * ratio ) , 
				  startPoint[1] + ( ( endPoint[1] - startPoint[1] ) * ratio ) ,
				  startPoint[2] + ( ( endPoint[2] - startPoint[2] ) * ratio ) );

	return nextPoint;
}

