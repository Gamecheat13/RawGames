#include common_scripts\utility;
#include maps\mp\_utility;

getWinningTeamFromLoser( losing_team )
{
	if ( level.multiTeam )
	{
		return "tie";
	}
	else if ( losing_team == "axis" )
	{
		return "allies";
	}
	return "axis";
}

// when a team leaves completely, that team forfeited, team left wins round, ends game
default_onForfeit( team )
{
	level.gameForfeited= true;
	
		level notify ( "forfeit in progress" ); //ends all other forfeit threads attempting to run
	level endon( "forfeit in progress" );	//end if another forfeit thread is running
	level endon( "abort forfeit" );			//end if the team is no longer in forfeit status
	
	forfeit_delay = 20.0;						//forfeit wait, for switching teams and such
	
	announcement( game["strings"]["opponent_forfeiting_in"], forfeit_delay, 0 );
	wait (10.0);
	announcement( game["strings"]["opponent_forfeiting_in"], 10.0, 0 );
	wait (10.0);
	
	endReason = &"";
	if ( !isDefined( team ) )
	{
		SetDvar( "ui_text_endreason", game["strings"]["players_forfeited"] );
		endReason = game["strings"]["players_forfeited"];
		winner = level.players[0];
	}
	else if ( isdefined( level.teams[team] ) )
	{
		endReason = game["strings"][team+"_forfeited"];
		SetDvar( "ui_text_endreason", endReason );
		winner = getWinningTeamFromLoser( team );
	}
	else
	{
		//shouldn't get here
		assert( isdefined( team ), "Forfeited team is not defined" );
		assert( 0, "Forfeited team " + team + " is not allies or axis" );
		winner = "tie";
	}
	//exit game, last round, no matter if round limit reached or not
	level.forcedEnd = true;
	
	if ( isPlayer( winner ) )
		logString( "forfeit, win: " + winner getXuid() + "(" + winner.name + ")" );
	else
		maps\mp\gametypes\_globallogic_utils::logTeamWinString( "forfeit", winner );
	thread maps\mp\gametypes\_globallogic::endGame( winner, endReason );
}


default_onDeadEvent( team )
{
	if ( isdefined( level.teams[team] ) )
	{
		eliminatedString = game["strings"][team + "_eliminated"];
		iPrintLn( eliminatedString );
		makeDvarServerInfo( "ui_text_endreason", eliminatedString );
		SetDvar( "ui_text_endreason", eliminatedString );

		winner = getWinningTeamFromLoser( team );
		maps\mp\gametypes\_globallogic_utils::logTeamWinString( "team eliminated", winner );
		
		thread maps\mp\gametypes\_globallogic::endGame( winner, eliminatedString );
	}
	else
	{
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		SetDvar( "ui_text_endreason", game["strings"]["tie"] );

		maps\mp\gametypes\_globallogic_utils::logTeamWinString( "tie" );

		if ( level.teamBased )
			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["tie"] );
		else
			thread maps\mp\gametypes\_globallogic::endGame( undefined, game["strings"]["tie"] );
	}
}

default_onAliveCountChange( team )
{
}

default_onRoundEndGame( winner )
{
	return winner;
}

default_onOneLeftEvent( team )
{
	if ( !level.teamBased )
	{
		winner = maps\mp\gametypes\_globallogic_score::getHighestScoringPlayer();

		if ( isDefined( winner ) )
			logString( "last one alive, win: " + winner.name );
		else
			logString( "last one alive, win: unknown" );

		thread maps\mp\gametypes\_globallogic::endGame( winner, &"MP_ENEMIES_ELIMINATED" );
	}
	else
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( !isAlive( player ) )
				continue;
				
			if ( !isDefined( player.pers["team"] ) || player.pers["team"] != team )
				continue;
				
//			player maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "last_alive" );
			player maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "sudden_death" );
		}
	}
}


default_onTimeLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "teamScores" );

		maps\mp\gametypes\_globallogic_utils::logTeamWinString( "time limit", winner );
	}
	else
	{
		winner = maps\mp\gametypes\_globallogic_score::getHighestScoringPlayer();

		if ( isDefined( winner ) )
			logString( "time limit, win: " + winner.name );
		else
			logString( "time limit, tie" );
	}
	
	// i think these two lines are obsolete
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	SetDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
}

default_onScoreLimit()
{
	if ( !level.endGameOnScoreLimit )
		return false;

	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "teamScores" );

		maps\mp\gametypes\_globallogic_utils::logTeamWinString( "scorelimit", winner );
	}
	else
	{
		winner = maps\mp\gametypes\_globallogic_score::getHighestScoringPlayer();
		if ( isDefined( winner ) )
			logString( "scorelimit, win: " + winner.name );
		else
			logString( "scorelimit, tie" );
	}
	
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	SetDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
	return true;
}

default_onSpawnSpectator( origin, angles)
{
	if( isDefined( origin ) && isDefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}
	
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size, "There are no mp_global_intermission spawn points in the map.  There must be at least one."  );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}

default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
//	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	spawnpoint = spawnPoints[0];
	
	if( isDefined( spawnpoint ) )
	{
		self spawn( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		/#
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
		#/
	}
}

default_getTimeLimit()
{
	return clamp( GetGametypeSetting( "timeLimit" ), level.timeLimitMin, level.timeLimitMax );
}

default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_penalty = 1;
	
	if ( maps\mp\gametypes\_weapon_utils::isReducedTeamkillWeapon( sWeapon ))
	{
		teamkill_penalty = level.teamKillReducedPenalty;
	}
	return teamkill_penalty;
}

default_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	return maps\mp\gametypes\_rank::getScoreInfoValue( "team_kill" );
}


