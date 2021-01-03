#using scripts\codescripts\struct;

#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\zm\gametypes\_globallogic;
#using scripts\zm\gametypes\_globallogic_audio;
#using scripts\zm\gametypes\_globallogic_score;
#using scripts\zm\gametypes\_globallogic_utils;
#using scripts\zm\gametypes\_spawnlogic;

#using scripts\zm\_util;

#namespace globallogic_defaults;

function getWinningTeamFromLoser( losing_team )
{
	if ( level.multiTeam )
	{
		return "tie";
	}
	return util::getotherteam(losing_team);
}

// when a team leaves completely, that team forfeited, team left wins round, ends game
function default_onForfeit( team )
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
	if ( !isdefined( team ) )
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
	/#
	if ( isPlayer( winner ) )
		print( "forfeit, win: " + winner getXuid() + "(" + winner.name + ")" );
	else
		globallogic_utils::logTeamWinString( "forfeit", winner );
	#/
	thread globallogic::endGame( winner, endReason );
}


function default_onDeadEvent( team )
{
	if ( isdefined( level.teams[team] ) )
	{
		eliminatedString = game["strings"][team + "_eliminated"];
		iPrintLn( eliminatedString );
		//makeDvarServerInfo( "ui_text_endreason", eliminatedString );
		SetDvar( "ui_text_endreason", eliminatedString );

		winner = getWinningTeamFromLoser( team );
		globallogic_utils::logTeamWinString( "team eliminated", winner );
		
		thread globallogic::endGame( winner, eliminatedString );
	}
	else
	{
		//makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		SetDvar( "ui_text_endreason", game["strings"]["tie"] );

		globallogic_utils::logTeamWinString( "tie" );

		if ( level.teamBased )
			thread globallogic::endGame( "tie", game["strings"]["tie"] );
		else
			thread globallogic::endGame( undefined, game["strings"]["tie"] );
	}
}

function default_onAliveCountChange( team )
{
}

function default_onRoundEndGame( winner )
{
	return winner;
}

function default_onOneLeftEvent( team )
{
	if ( !level.teamBased )
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
		if ( isdefined( winner ) )
			print( "last one alive, win: " + winner.name );
		else
			print( "last one alive, win: unknown" );
		#/

		thread globallogic::endGame( winner, &"MP_ENEMIES_ELIMINATED" );
	}
	else
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( !isAlive( player ) )
				continue;
				
			if ( !isdefined( player.pers["team"] ) || player.pers["team"] != team )
				continue;
				
//			player globallogic_audio::leaderDialogOnPlayer( "last_alive" );
			player globallogic_audio::leaderDialogOnPlayer( "sudden_death" );
		}
	}
}


function default_onTimeLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = globallogic::determineTeamWinnerByGameStat( "teamScores" );

		globallogic_utils::logTeamWinString( "time limit", winner );
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();

		/#
		if ( isdefined( winner ) )
			print( "time limit, win: " + winner.name );
		else
			print( "time limit, tie" );
		#/
	}
	
	// i think these two lines are obsolete
	//makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	SetDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	
	thread globallogic::endGame( winner, game["strings"]["time_limit_reached"] );
}

function default_onScoreLimit()
{
	if ( !level.endGameOnScoreLimit )
		return false;

	winner = undefined;
	
	if ( level.teamBased )
	{
		winner = globallogic::determineTeamWinnerByGameStat( "teamScores" );

		globallogic_utils::logTeamWinString( "scorelimit", winner );
	}
	else
	{
		winner = globallogic_score::getHighestScoringPlayer();
		/#
		if ( isdefined( winner ) )
			print( "scorelimit, win: " + winner.name );
		else
			print( "scorelimit, tie" );
		#/
	}
	
	//makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	SetDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	thread globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
	return true;
}

function default_onSpawnSpectator( origin, angles)
{
	if( isdefined( origin ) && isdefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}
	
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size, "There are no mp_global_intermission spawn points in the map.  There must be at least one."  );
	spawnpoint = spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}

function default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
//	spawnpoint = spawnlogic::getSpawnpoint_Random(spawnpoints);
	spawnpoint = spawnPoints[0];
	
	if( isdefined( spawnpoint ) )
	{
		self spawn( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		/#
		util::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
		#/
	}
}

function default_getTimeLimit()
{
	return math::clamp( GetGametypeSetting( "timeLimit" ), level.timeLimitMin, level.timeLimitMax );
}

