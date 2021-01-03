#using scripts\codescripts\struct;

#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace hostmigration;

function debug_script_structs()
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

function UpdateTimerPausedness()
{
	shouldBeStopped = isdefined( level.hostMigrationTimer );
	
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

function pauseTimer()
{	
	level.migrationTimerPauseTime = gettime();
}


function resumeTimer()
{	
	level.discardTime += gettime() - level.migrationTimerPauseTime;
}

function lockTimer()
{
	level endon( "host_migration_begin" );
	level endon( "host_migration_end" );
	
	for( ;; )
	{
		currTime = gettime();
		{wait(.05);};
		if ( !level.timerStopped && isdefined(level.discardTime) )
		{
			level.discardTime += gettime() - currTime;
		}
	}
}

function matchStartTimerConsole_Internal( countTime, matchStartTimer )
{
	waittillframeend; // wait till cleanup of previous start timer if multiple happen at once
	visionSetNaked( "mpIntro", 0 );
	
	level endon( "match_start_timer_beginning" );
	while ( countTime > 0 && !level.gameEnded )
	{
		matchStartTimer thread hud::font_pulse( level );
		wait ( matchStartTimer.inFrames * 0.05 );
		matchStartTimer setValue( countTime );
		if ( countTime == 2 )
		{
			visionSetNaked( GetDvarString( "mapname" ), 3.0 );
		}
		countTime--;
		wait ( 1 - (matchStartTimer.inFrames * 0.05) );
	}
}

function matchStartTimerConsole( type, duration )
{
	level notify( "match_start_timer_beginning" );
	{wait(.05);};
	
	matchStartText = hud::createServerFontString( "objective", 1.5 );
	matchStartText hud::setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( game["strings"]["waiting_for_teams"] );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;
	
//	globallogic::waitForPlayers();
	matchStartText setText( game["strings"][type] ); // "match begins in:"
	
	matchStartTimer = hud::createServerFontString( "objective", 2.2 );
	matchStartTimer hud::setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer hud::font_pulse_init();

	countTime = int( duration );
	
	if ( countTime >= 2 )
	{
		matchStartTimerConsole_Internal( countTime, matchStartTimer );
		visionSetNaked( GetDvarString( "mapname" ), 3.0 );
	}
	else
	{
		visionSetNaked( "mpIntro", 0 );
		visionSetNaked( GetDvarString( "mapname" ), 1.0 );
	}
	
	matchStartTimer hud::destroyElem();
	matchStartText hud::destroyElem();
}

function hostMigrationWait()
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
	
	level notify( "host_migration_countdown_begin" );
	thread matchStartTimerConsole( "match_starting_in", 5.0 );
	wait 5;
}

function waittillHostMigrationCountDown()
{
	level endon( "host_migration_end" );

	if ( !isDefined( level.hostMigrationTimer ) )
	{
		return;
	}

	level waittill( "host_migration_countdown_begin" );
}


function hostMigrationWaitForPlayers()
{
	level endon( "hostmigration_enoughplayers" );
	wait 15;
}

function hostMigrationTimerThink_Internal()
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

function hostMigrationTimerThink()
{
	self endon( "disconnect" );
	level endon( "host_migration_begin" );
	
	hostMigrationTimerThink_Internal();
	
	if ( self.hostMigrationControlsFrozen )
	{
		self freezeControls( false );
	}
}

function waitTillHostMigrationDone()
{
	if ( !isdefined( level.hostMigrationTimer ) )
	{
		return 0;
	}
	
	starttime = gettime();
	level waittill( "host_migration_end" );
	return gettime() - starttime;
}

function waitTillHostMigrationStarts( duration )
{
	if ( isdefined( level.hostMigrationTimer ) )
	{
		return;
	}
	
	level endon( "host_migration_begin" );
	wait duration;
}

function waitLongDurationWithHostMigrationPause( duration )
{
	if ( duration == 0 )
	{
		return;
	}
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		if ( isdefined( level.hostMigrationTimer ) )
		{
			timePassed = waitTillHostMigrationDone();
			endtime += timePassed;
		}
	}

/#
	if( gettime() != endtime )
	{
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);
	}
#/	
	waitTillHostMigrationDone();
	
	return gettime() - starttime;
}


function waitLongDurationWithHostMigrationPauseEMP( duration )
{
	if ( duration == 0 )
	{
		return;
	}
	assert( duration > 0 );
	
	starttime = gettime();
	
	empendtime = gettime() + duration * 1000;
	level.empendtime = empendtime;
	
	while ( gettime() < empendtime )
	{
		waitTillHostMigrationStarts( (empendtime - gettime()) / 1000 );
		
		if ( isdefined( level.hostMigrationTimer ) )
		{
			timePassed = waitTillHostMigrationDone();
			if ( isdefined ( empendtime ) )
			{
				empendtime += timePassed;
			}
		}
	}

/#
	if( gettime() != empendtime )
	{
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO empendtime = " + empendtime);
	}
#/

	waitTillHostMigrationDone();
	
	level.empendtime = undefined;
	return gettime() - starttime;
}


function waitLongDurationWithGameEndTimeUpdate( duration )
{
	if ( duration == 0 )
	{
		return;
	}
	assert( duration > 0 );
	
	starttime = gettime();
	
	endtime = gettime() + duration * 1000;
	
	while ( gettime() < endtime )
	{
		waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		while ( isdefined( level.hostMigrationTimer ) )
		{
			endTime += 1000;
			setGameEndTime( int( endTime ) );
			wait 1;
		}
	}

/#
	if( gettime() != endtime )
	{
		println("SCRIPT WARNING: gettime() = " + gettime() + " NOT EQUAL TO endtime = " + endtime);
	}
#/

	while ( isdefined( level.hostMigrationTimer ) )
	{
		endTime += 1000;
		setGameEndTime( int( endTime ) );
		wait 1;
	}
	
	return gettime() - starttime;
}

function MigrationAwareWait( durationMs )
{
	waitTillHostMigrationDone();
	
	endTime = gettime() + durationMs;
	timeRemaining = durationMs;
	
	while( true )
	{
		event = level util::waittill_any_timeout( timeRemaining / 1000, "game_ended", "host_migration_begin" );
		
		if( event != "host_migration_begin" )
		{
			return;
		}

		timeRemaining = endTime - gettime();
		if( timeRemaining <= 0 )
		{
			return;
		}

		endTime = gettime() + durationMs;
		waitTillHostMigrationDone();
	}
}
