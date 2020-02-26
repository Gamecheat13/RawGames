#include maps\mp\_utility;

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
	else if ( team == "allies" )
	{
		SetDvar( "ui_text_endreason", game["strings"]["allies_forfeited"] );
		endReason = game["strings"]["allies_forfeited"];
		winner = "axis";
	}
	else if ( team == "axis" )
	{
		SetDvar( "ui_text_endreason", game["strings"]["axis_forfeited"] );
		endReason = game["strings"]["axis_forfeited"];
		winner = "allies";
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
		logString( "forfeit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
	thread maps\mp\gametypes\_globallogic::endGame( winner, endReason );
}


default_onDeadEvent( team )
{
	if ( team == "allies" )
	{
		iPrintLn( game["strings"]["allies_eliminated"] );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["allies_eliminated"] );
		SetDvar( "ui_text_endreason", game["strings"]["allies_eliminated"] );

		logString( "team eliminated, win: axis, allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
		
		thread maps\mp\gametypes\_globallogic::endGame( "axis", game["strings"]["allies_eliminated"] );
	}
	else if ( team == "axis" )
	{
		iPrintLn( game["strings"]["axis_eliminated"] );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["axis_eliminated"] );
		SetDvar( "ui_text_endreason", game["strings"]["axis_eliminated"] );

		logString( "team eliminated, win: allies, allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );

		thread maps\mp\gametypes\_globallogic::endGame( "allies", game["strings"]["axis_eliminated"] );
	}
	else
	{
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		SetDvar( "ui_text_endreason", game["strings"]["tie"] );

		logString( "tie, allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );

		if ( level.teamBased )
			thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["tie"] );
		else
			thread maps\mp\gametypes\_globallogic::endGame( undefined, game["strings"]["tie"] );
	}
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
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";

		logString( "time limit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
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
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
		logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
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
		self spawn( spawnpoint.origin, spawnpoint.angles );
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

default_getTimeLimitDvarValue()
{
	return maps\mp\gametypes\_globallogic_utils::getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
}

default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_penalty = 1;
	
	if ( sWeapon == "artillery_mp" )
	{
		teamkill_penalty = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "artilleryTeamKillPenalty" );
	}
	return teamkill_penalty;
}

default_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	return maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
}


