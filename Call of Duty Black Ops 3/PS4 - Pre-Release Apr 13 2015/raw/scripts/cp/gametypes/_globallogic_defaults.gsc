#using scripts\codescripts\struct;

#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_globallogic;
#using scripts\cp\gametypes\_globallogic_score;
#using scripts\cp\gametypes\_globallogic_utils;
#using scripts\cp\gametypes\_rank;
#using scripts\cp\gametypes\_spawnlogic;

#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreaks;

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
	if ( level.multiTeam )
	{
		SetDvar( "ui_text_endreason", game["strings"]["other_teams_forfeited"] );
		endReason = game["strings"]["other_teams_forfeited"];
		winner = team;
	}
	else if ( !isdefined( team ) )
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
	if ( team == "all" )
	{
		// favoring the "baddies" for now but maybe we want to favor the "goodguys"?
		winner = level.enemy_ai_team; 
		globallogic_utils::logTeamWinString( "team eliminated", winner );
		thread globallogic::endGame( winner, &"SM_ALL_PLAYERS_KILLED" );
	}
	else
	{
		winner = getWinningTeamFromLoser( team );
		globallogic_utils::logTeamWinString( "team eliminated", winner );
		thread globallogic::endGame( winner, &"SM_ALL_PLAYERS_KILLED" );
	}
}

function default_onLastTeamAliveEvent( team )
{
	if ( isdefined( level.teams[team] ) )
	{
		eliminatedString = game["strings"]["enemies_eliminated"];
		iPrintLn( eliminatedString );
		//makeDvarServerInfo( "ui_text_endreason", eliminatedString );
		SetDvar( "ui_text_endreason", eliminatedString );

		winner = globallogic::determineTeamWinnerByGameStat( "teamScores" );
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

function things_exist_which_could_revive_player( team )
{
	// we should check for things that can revive a player (like a friendly AI)

	// keep in mind that if this is true that we will potentially have to keep checking that
	// this thing exists until the player is revived.  For example if we figure out the 
	// friendly AI could revive the player we need to track if the AI is killed before they can.
	
	return false;
}

function team_can_be_revived( team )
{
	if ( things_exist_which_could_revive_player( team ) )
	{
		return true;
	}
	
	// are we playing solo
	if ( level.playerCount[team] == 1 && level.aliveCount[team] == 1 )
	{
		assert( level.alivePlayers[team].size == 1 );
	
		// if we have more lives available
		// auto revive will pick us up
		if ( level.alivePlayers[team][0].lives > 0 )
			return true;
	}
	
	// there is no way that anyone on this team can still be revived
	return false;
}

function default_onLastStandEvent( team )
{
	// check to see if the teams can be revived 
	if ( team_can_be_revived( team ) )
	{
		return;
	}
	
	// if not end the game
	if ( team == "all" )
	{
		thread globallogic::endGame( level.enemy_ai_team, &"SM_ALL_PLAYERS_KILLED" );
	}
	else
	{
		thread globallogic::endGame( util::getotherteam(team), &"SM_ALL_PLAYERS_KILLED" );
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
	
	spawnpointname = "cp_global_intermission";
	spawnpoints = struct::get_array(spawnpointname, "targetname");

	assert( spawnpoints.size, "There are no " + spawnpointname + " spawn points in the map.  There must be at least one."  );
	spawnpoint = spawnlogic::get_spawnpoint_random(spawnpoints);

	assert( IsDefined(spawnpoint.origin), "Spawnpoint (type " + spawnpointname + ") has no origin " );
	assert( IsDefined(spawnpoint.angles), "Spawnpoint (type " + spawnpointname + ") at " + spawnpoint.origin + " has no angles" );
	self spawn(spawnpoint.origin, spawnpoint.angles);
}

function default_onSpawnIntermission()
{
	spawnpointname = "cp_global_intermission";
	spawnpoints = struct::get_array(spawnpointname, "targetname");

//	spawnpoint = spawnlogic::get_spawnpoint_random(spawnpoints);
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

function default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, weapon )
{
	teamkill_penalty = 1;
	
	score = globallogic_score::_getPlayerScore( attacker );
	
	if ( score == 0 )
	{
		teamkill_penalty = 2;
	}
	
	if ( killstreaks::is_killstreak_weapon( weapon ) )
	{
		teamkill_penalty *= killstreaks::get_killstreak_team_kill_penalty_scale( weapon );
	}
	
	return teamkill_penalty;
}

function default_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, weapon )
{
	return rank::getScoreInfoValue( "team_kill" );
}


