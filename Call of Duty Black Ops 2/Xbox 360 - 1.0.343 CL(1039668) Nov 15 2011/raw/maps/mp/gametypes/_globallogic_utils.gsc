#include maps\mp\_utility;

// to be used with things that are slow.
// unfortunately, it can only be used with things that aren't time critical.
WaitTillSlowProcessAllowed()
{
	while ( level.lastSlowProcessFrame == gettime() )
		wait .05;
	
	level.lastSlowProcessFrame = gettime();
}

testMenu()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		wait ( 10.0 );
		
		notifyData = spawnStruct();
		notifyData.titleText = &"MP_CHALLENGE_COMPLETED";
		notifyData.notifyText = "wheee";
		notifyData.sound = "mp_challenge_complete";

		self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	}
}

testShock()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		wait ( 3.0 );

		numShots = randomInt( 6 );
		
		for ( i = 0; i < numShots; i++ )
		{
			iPrintLnBold( numShots );
			self shellShock( "frag_grenade_mp", 0.2 );
			wait ( 0.1 );
		}
	}
}

testHPs()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	hps = [];
	hps[hps.size] = "radar_mp";
	hps[hps.size] = "artillery_mp";
	hps[hps.size] = "dogs_mp";

	for ( ;; )
	{
//		hp = hps[randomInt(hps.size)];
		hp = "radar_mp";
		if ( self thread maps\mp\killstreaks\_killstreaks::giveKillstreak( hp ) )
		{
			self playLocalSound( level.killstreaks[hp].informDialog );
		}

//		self thread maps\mp\killstreaks\_killstreaks::upgradeHardpointItem();
		
		wait ( 20.0 );
	}
}


// returns the best guess of the exact time until the scoreboard will be displayed and player control will be lost.
// returns undefined if time is not known
timeUntilRoundEnd()
{
	if ( level.gameEnded )
	{
		timePassed = (getTime() - level.gameEndTime) / 1000;
		timeRemaining = level.postRoundTime - timePassed;
		
		if ( timeRemaining < 0 )
			return 0;
		
		return timeRemaining;
	}
	
	if ( level.inOvertime )
		return undefined;
	
	if ( level.timeLimit <= 0 )
		return undefined;
	
	if ( !isDefined( level.startTime ) )
		return undefined;
	
	timePassed = (getTimePassed() - level.startTime)/1000;
	timeRemaining = (level.timeLimit * 60) - timePassed;
	
	return timeRemaining + level.postRoundTime;
}


getTimeRemaining()
{
	return level.timeLimit * 60 * 1000 - getTimePassed();
}


registerRoundSwitchDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundswitch");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundswitchDvar = dvarString;
	level.roundswitchMin = minValue;
	level.roundswitchMax = maxValue;
	level.roundswitch = getDvarInt( level.roundswitchDvar );
}

registerRoundLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundLimitDvar = dvarString;
	level.roundLimitMin = minValue;
	level.roundLimitMax = maxValue;
	level.roundLimit = getDvarInt( level.roundLimitDvar );
}


registerRoundWinLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundwinlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.roundWinLimitDvar = dvarString;
	level.roundWinLimitMin = minValue;
	level.roundWinLimitMax = maxValue;
	level.roundWinLimit = getDvarInt( level.roundWinLimitDvar );
}

registerScoreLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_scorelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.scoreLimitDvar = dvarString;	
	level.scorelimitMin = minValue;
	level.scorelimitMax = maxValue;
	level.scoreLimit = getDvarInt( level.scoreLimitDvar );
	
	SetDvar( "ui_scorelimit", level.scoreLimit );
}


registerTimeLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_timelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarFloat( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarFloat( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.timeLimitDvar = dvarString;	
	level.timelimitMin = minValue;
	level.timelimitMax = maxValue;
	level.timelimit = getDvarFloat( level.timeLimitDvar );
	
	SetDvar( "ui_timelimit", level.timelimit );
}


registerNumLivesDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_numlives");
	
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.numLivesDvar = dvarString;	
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
	level.numLives = getDvarInt( level.numLivesDvar );
	//makeDvarServerInfo( level.numLivesDvar, level.numLives );
}

registerPostRoundEvent( eventFunc )
{
	if ( !isDefined( level.postRoundEvents ) )
		level.postRoundEvents = [];
	
	level.postRoundEvents[level.postRoundEvents.size] = eventFunc;
}

executePostRoundEvents()
{
	if ( !isDefined( level.postRoundEvents ) )
		return;
		
	for ( i = 0 ; i < level.postRoundEvents.size ; i++ )
	{
		[[level.postRoundEvents[i]]]();
	}
}

getValueInRange( value, minValue, maxValue )
{
	if ( value > maxValue )
		return maxValue;
	else if ( value < minValue )
		return minValue;
	else
		return value;
}


/#
assertProperPlacement()
{
	numPlayers = level.placement["all"].size;
	for ( i = 0; i < numPlayers - 1; i++ )
	{
		if ( level.placement["all"][i].score < level.placement["all"][i + 1].score )
		{
			println("^1Placement array:");
			for ( i = 0; i < numPlayers; i++ )
			{
				player = level.placement["all"][i];
				println("^1" + i + ". " + player.name + ": " + player.score );
			}
			assertmsg( "Placement array was not properly sorted" );
			break;
		}
	}
}
#/


isValidClass( class )
{
	if ( level.oldschool )
	{
		assert( !isdefined( class ) );
		return true;
	}
	return isdefined( class ) && class != "";
}


playTickingSound( gametype_tick_sound )
{
	self endon("death");
	self endon("stop_ticking");
	level endon("game_ended");
	
	time = level.bombTimer;
	
	while(1)
	{
		self playSound( gametype_tick_sound );
		
		if ( time > 10 )
		{
			time -= 1;
			wait 1;
		}
		else if ( time > 4 )
		{
			time -= .5;
			wait .5;
		}
		else if ( time > 1 )
		{
			time -= .4;
			wait .4;
		}
		else
		{
			time -= .3;
			wait .3;
		}
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}

stopTickingSound()
{
	self notify("stop_ticking");
}

gameTimer()
{
	level endon ( "game_ended" );
	
	level waittill("prematch_over");
	// moving music to post spawn to allow for intro stingers
	//maps\mp\_music::setmusicstate( "UNDERSCORE" );
	
	level.startTime = getTime();
	level.discardTime = 0;
	
	if ( isDefined( game["roundMillisecondsAlreadyPassed"] ) )
	{
		level.startTime -= game["roundMillisecondsAlreadyPassed"];
		game["roundMillisecondsAlreadyPassed"] = undefined;
	}
	
	prevtime = gettime();
	
	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped )
		{
			// the wait isn't always exactly 1 second. dunno why.
			game["timepassed"] += gettime() - prevtime;
		}
		prevtime = gettime();
		wait ( 1.0 );
	}
}

getTimePassed()
{
	if ( !isDefined( level.startTime ) )
		return 0;
	
	if ( level.timerStopped )
		return (level.timerPauseTime - level.startTime) - level.discardTime;
	else
		return (gettime()            - level.startTime) - level.discardTime;

}


pauseTimer()
{	
	if ( level.timerStopped )
		return;
	
	level.timerStopped = true;
	level.timerPauseTime = gettime();
}


resumeTimer()
{	
	if ( !level.timerStopped )
		return;
	
	level.timerStopped = false;
	level.discardTime += gettime() - level.timerPauseTime;
}


getScoreRemaining( team )
{
	assert( IsPlayer( self ) || IsDefined( team ) );
	
	scoreLimit = level.scoreLimit;
	
	if ( IsPlayer( self ) )
		return scoreLimit - maps\mp\gametypes\_globallogic_score::_getPlayerScore( self );
	else
		return scoreLimit - GetTeamScore( team );
}


getScorePerMinute( team )
{
	assert( IsPlayer( self ) || IsDefined( team ) );
	
	scoreLimit = level.scoreLimit;
	timeLimit = level.timeLimit;
	minutesPassed = ( getTimePassed() / ( 60 * 1000 ) ) + 0.0001;
	
	if ( IsPlayer( self ) )
		return maps\mp\gametypes\_globallogic_score::_getPlayerScore( self ) / minutesPassed;
	else
		return GetTeamScore( team ) / minutesPassed;
}


getEstimatedTimeUntilScoreLimit( team )
{
	assert( IsPlayer( self ) || IsDefined( team ) );
	
	scorePerMinute = self getScorePerMinute( team );
	scoreRemaining = self getScoreRemaining( team );
	
	if ( !scorePerMinute )
		return 999999;
	
	return scoreRemaining / scorePerMinute;
}


rumbler()
{
	self endon("disconnect");
	while(1)
	{
		wait(0.1);
		self PlayRumbleOnEntity( "damage_heavy" );
	}
}


waitForTimeOrNotify( time, notifyname )
{
	self endon( notifyname );
	wait time;
}


waitForTimeOrNotifyNoArtillery( time, notifyname )
{
	self endon( notifyname );
	wait time;
	while( isDefined( level.artilleryInProgress ) )
	{
		assert( level.artilleryInProgress ); // undefined or true
		wait .25;
	}
}


fakeLag()
{
	self endon ( "disconnect" );
	self.fakeLag = randomIntRange( 50, 150 );
	
	for ( ;; )
	{
		self SetClientFakelagTarget( self.fakeLag );
		wait ( randomFloatRange( 5.0, 15.0 ) );
	}
}


isHeadShot( sWeapon, sHitLoc, sMeansOfDeath )
{
	if( sHitLoc != "head" && sHitLoc != "helmet" )
	{
		return false;
	}

	switch( sMeansOfDeath )
	{
	case "MOD_MELEE":
	case "MOD_BAYONET":
		return false;
	case "MOD_IMPACT":
	   if( sWeapon != "knife_ballistic_mp" )
			return false;
	}

	//Auto-turrets should not have M.O.D. headshots -Leif
	switch( sWeapon )
	{
	case "auto_gun_turret_mp":
	case "cobra_20mm_comlink_mp":
		return false;
	}

	return true;
}


getHitLocHeight( sHitLoc )
{
	switch( sHitLoc )
	{
		case "helmet":
		case "head":
		case "neck":
			return 60;
		case "torso_upper":
		case "right_arm_upper":
		case "left_arm_upper":
		case "right_arm_lower":
		case "left_arm_lower":
		case "right_hand":
		case "left_hand":
		case "gun":
			return 48;
		case "torso_lower":
			return 40;
		case "right_leg_upper":
		case "left_leg_upper":
			return 32;
		case "right_leg_lower":
		case "left_leg_lower":
			return 10;
		case "right_foot":
		case "left_foot":
			return 5;
	}
	return 48;
}

debugLine( start, end )
{
	for ( i = 0; i < 50; i++ )
	{
		line( start, end );
		wait .05;
	}
}


isExcluded( entity, entityList )
{
	for ( index = 0; index < entityList.size; index++ )
	{
		if ( entity == entityList[index] )
			return true;
	}
	return false;
}


waitForTimeOrNotifies( desiredDelay )
{
	startedWaiting = getTime();
	
//	while( self.doingNotify )
//		wait ( 0.05 );

	waitedTime = (getTime() - startedWaiting)/1000;
	
	if ( waitedTime < desiredDelay )
	{
		wait desiredDelay - waitedTime;
		return desiredDelay;
	}
	else
	{
		return waitedTime;
	}
}

