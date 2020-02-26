#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes\_hud_util;

debug_script_structs()
{
	/#
	if(isdefined(level.struct))
	{
		println("*** Num structs " + level.struct.size);
		println("");
		
		for(i = 0; i < level.struct.size; i ++)
		{
			struct = level.struct[i];

			if (isdefined(struct.targetname))
				println("---" + i + " : " + struct.targetname);
			else
				println("---" + i + " : " + "NONE");
		}
	}
	else
	{
		println("*** No structs defined.");
	}
	#/
}

UpdateTimerPausedness()
{
	shouldBeStopped = isDefined( level.hostMigrationTimer );
	
	if ( !level.timerStopped && shouldBeStopped )
	{
		level.timerStopped = true;
		level.timerPauseTime = gettime();
	}
	else if ( level.timerStopped && !shouldBeStopped )
	{
		level.timerStopped = false;
		level.discardTime += gettime() - level.timerPauseTime;
	}
}

Callback_HostMigrationSave()
{
//	debug_script_structs();
}

pauseTimer()
{	
	level.migrationTimerPauseTime = gettime();
}


resumeTimer()
{	
	level.discardTime += gettime() - level.migrationTimerPauseTime;
}

lockTimer()
{
	level endon( "host_migration_begin" );
	level endon( "host_migration_end" );
	
	for( ;; )
	{
		currTime = gettime();
		wait (0.05);
		if ( !level.timerStopped && IsDefined(level.discardTime) )
			level.discardTime += gettime() - currTime;
	}
}

Callback_HostMigration()
{
//	debug_script_structs();

	setSlowMotion( 1, 1, 0 );
	makedvarserverinfo( "ui_guncycle", 0 );
	
	level.hostMigrationReturnedPlayerCount = 0;
	
	if (level.inPrematchPeriod)
		level waittill("prematch_over");
	
	if ( level.gameEnded )
	{
	/#	println( "Migration starting at time " + gettime() + ", but game has ended, so no countdown." );	#/
		return;
	}
		
/#	println( "Migration starting at time " + gettime() );	#/
	
	level.hostMigrationTimer = true;
	sethostmigrationstatus(true);
	
	level notify( "host_migration_begin" );
	
	thread lockTimer();
	
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		player thread hostMigrationTimerThink();
	}
	
	level endon( "host_migration_begin" );
	hostMigrationWait();

	level.hostMigrationTimer = undefined;
	sethostmigrationstatus(false);
/#	println( "Migration finished at time " + gettime() );	#/
	
	level notify( "host_migration_end" );
}


matchStartTimerConsole_Internal( countTime, matchStartTimer )
{
	waittillframeend; // wait till cleanup of previous start timer if multiple happen at once
	visionSetNaked( "mpIntro", 0 );
	
	level endon( "match_start_timer_beginning" );
	while ( countTime > 0 && !level.gameEnded )
	{
		matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
		wait ( matchStartTimer.inFrames * 0.05 );
		matchStartTimer setValue( countTime );
		if ( countTime == 2 )
			visionSetNaked( GetDvar( "mapname" ), 3.0 );
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

matchStartTimerConsole( type, duration )
{
	level notify( "match_start_timer_beginning" );
	wait (0.05);
	
	matchStartText = createServerFontString( "objective", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;
	
//	waitForPlayers();
	matchStartText setText( game["strings"][type] ); // "match begins in:"
	
	matchStartTimer = createServerFontString( "objective", 2.2 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = int( duration );
	
	if ( countTime >= 2 )
	{
		matchStartTimerConsole_Internal( countTime, matchStartTimer );
		visionSetNaked( GetDvar( "mapname" ), 3.0 );
	}
	else
	{
		visionSetNaked( "mpIntro", 0 );
		visionSetNaked( GetDvar( "mapname" ), 1.0 );
	}
	
	matchStartTimer destroyElem();
	matchStartText destroyElem();
}

hostMigrationWait()
{
	level endon( "game_ended" );
	
	// start with a 20 second wait.
	// once we get enough players, or the first 15 seconds pass, switch to a 5 second timer.

	// Handle the case of the notify firing before we're even checking for it.
	if ( level.hostMigrationReturnedPlayerCount < level.players.size * 2 / 3 )
	{
		thread matchStartTimerConsole( "waiting_for_teams", 20.0 );
		hostMigrationWaitForPlayers();
	}
	
	thread matchStartTimerConsole( "match_starting_in", 5.0 );
	wait 5;
}


hostMigrationWaitForPlayers()
{
	level endon( "hostmigration_enoughplayers" );
	wait 15;
}

hostMigrationTimerThink_Internal()
{
	level endon( "host_migration_begin" );
	level endon( "host_migration_end" );
	
	self.hostMigrationControlsFrozen = false;

	while ( !isAlive( self ) )
	{
		self waittill( "spawned" );
	}
	
	self.hostMigrationControlsFrozen = true;
	self freezeControls( true );
	
	level waittill( "host_migration_end" );
}

hostMigrationTimerThink()
{
	self endon( "disconnect" );
	level endon( "host_migration_begin" );
	
	hostMigrationTimerThink_Internal();
	
	if ( self.hostMigrationControlsFrozen )
		self freezeControls( false );
}

waitTillHostMigrationDone()
{
	if ( !isDefined( level.hostMigrationTimer ) )
		return 0;
	
	starttime = gettime();
	level waittill( "host_migration_end" );
	return gettime() - starttime;
}

waitTillHostMigrationStarts( duration )
{
	if ( isDefined( level.hostMigrationTimer ) )
		return;
	
	level endon( "host_migration_begin" );
	wait duration;
}

waitLongDurationWithHostMigrationPause( duration )
{
	if ( duration == 0 )
		return;
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		if ( isDefined( level.hostMigrationTimer ) )
		{
			timePassed = waitTillHostMigrationDone();
			endtime += timePassed;
		}
	}
	
	if( gettime() != endtime )
	/#	println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);		#/
		
	waitTillHostMigrationDone();
	
	return gettime() - starttime;
}

waitLongDurationWithGameEndTimeUpdate( duration )
{
	if ( duration == 0 )
		return;
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		while ( isDefined( level.hostMigrationTimer ) )
		{
			endTime += 1000;
			setGameEndTime( int( endTime ) );
			wait 1;
		}
	}
	/#
	if( gettime() != endtime )
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);
	#/	
	while ( isDefined( level.hostMigrationTimer ) )
	{
		endTime += 1000;
		setGameEndTime( int( endTime ) );
		wait 1;
	}
	
	return gettime() - starttime;
}

