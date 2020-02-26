#include common_scripts\utility;
#include maps\mp\_utility;

updateMatchBonusScores( winner )
{
	if ( !game["timepassed"] )
		return;

	if ( !level.rankedMatch )
		return;

	// dont give the bonus until the game is over
	if ( level.teamBased && isDefined( winner ) )
	{
		if ( winner == "endregulation" )
			return;
		}

	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = maps\mp\gametypes\_globallogic_utils::getTimePassed() / 1000;		
		// cap it at 20 minutes to avoid exploiting
		gameLength = min( gameLength, 1200 );

		// the bonus for final fight needs to be based on the total time played
		if ( level.gameType == "twar" && game["roundsplayed"] > 0 )
			gameLength += level.timeLimit * 60;
	}
	else
	{
		gameLength = level.timeLimit * 60;
	}

	if ( level.teamBased )
	{
		winningTeam = "tie";
		
		// TODO MTEAM - not sure if this is absolutely necessary but I dont know
		// if "winner" is anything other then a valid team or "tie" at this point
		foreach ( team in level.teams )
		{
			if ( winner == team )
			{
				winningTeam = team;
				break;
			}
		}

		if ( winningTeam != "tie" )
		{
			winnerScale = 1.0;
			loserScale = 0.5;
		}
		else
		{
			winnerScale = 0.75;
			loserScale = 0.75;
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}
	
			totalTimePlayed = player.timePlayed["total"];
			
			// make sure the players total time played is no 
			// longer then the game length to prevent exploits
			if ( totalTimePlayed > gameLength )
			{
				totalTimePlayed = gameLength;
			}
			
			// no bonus for hosts who force ends
			if ( level.hostForcedEnd && player IsHost() )
				continue;

			// no match bonus if negative game score
			if ( player.pers["score"] < 0 )
				continue;
				
			spm = player maps\mp\gametypes\_rank::getSPM();				
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined(player.pers["team"] ) && player.pers["team"] != "spectator" )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
	else
	{
		if ( isDefined( winner ) )
		{
			winnerScale = 1.0; // win
			loserScale = 0.5; // loss
		}
		else
		{
			winnerScale = 0.75; // tie
			loserScale = 0.75; // tie
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}
			
			totalTimePlayed = player.timePlayed["total"];
			
			// make sure the players total time played is no 
			// longer then the game length to prevent exploits
			if ( totalTimePlayed > gameLength )
			{
				totalTimePlayed = gameLength;
			}
			
			spm = player maps\mp\gametypes\_rank::getSPM();

			isWinner = false;
			for ( pIdx = 0; pIdx < min( level.placement["all"][0].size, 3 ); pIdx++ )
			{
				if ( level.placement["all"][pIdx] != player )
					continue;
				isWinner = true;				
			}
			
			if ( isWinner )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
}


giveMatchBonus( scoreType, score )
{
	self endon ( "disconnect" );

	level waittill ( "give_match_bonus" );
	
	self AddRankXPValue( scoreType, score );
	
	self maps\mp\gametypes\_rank::endGameUpdate();
}

doSkillUpdate( winner )
{
	skillUpdate( winner, level.teamBased );
}

getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}
	
	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}

resetScoreChain()
{
	self notify( "reset_score_chain" );
	
	//self LUINotifyEvent( &"score_event", 3, 0, 0, 0 );
	self.scoreChain = 0;
	self.rankUpdateTotal = 0;
}

scoreChainTimer()
{
	self notify( "score_chain_timer" );
	self endon( "reset_score_chain" );
	self endon( "score_chain_timer" );
	self endon( "death" );
	self endon( "disconnect" );
	
	wait 20;
	
	self thread resetScoreChain();
}

roundToNearestFive( score )
{
	rounding = score % 5;
	if ( rounding <= 2 )
	{
		return score - rounding;
	}
	else
	{
		return score + ( 5 - rounding );
	}
}

givePlayerMomentumNotification( score, label, descValue, countsTowardRampage )
{
	rampageBonus = 0;
	if ( IsDefined( level.usingRampage ) && level.usingRampage )
	{
		if ( countsTowardRampage )
		{
			if ( !IsDefined( self.scoreChain ) )
			{
				self.scoreChain = 0;
			}
			self.scoreChain++;
			self thread scoreChainTimer();
		}
		if ( IsDefined( self.scoreChain ) && ( self.scoreChain >= 999 ) )
		{
			rampageBonus = roundToNearestFive( int( score * level.rampageBonusScale + 0.5 ) );
		}
	}

	if ( score != 0 ) 
	{
		self LUINotifyEvent( &"score_event", 3, label, score, rampageBonus );
	}

	score = score + rampageBonus;
	
	if ( ( score > 0 ) && self HasPerk( "specialty_earnmoremomentum" ) ) 
	{ 
		score = roundToNearestFive( int( score * GetDvarFloat( "perk_killstreakMomentumMultiplier" ) + 0.5 ) ); 
	} 
	
	_setPlayerMomentum( self, self.pers["momentum"] + score );
}

resetPlayerMomentumOnDeath( event )
{
	if ( event == "death" )
	{
		if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
			{
				_setPlayerMomentum( self, 0 );
				self thread resetScoreChain();
			}
	}
}

givePlayerMomentum( event, player, victim, weapon, descValue )
{
	if( isdefined(level.disableMomentum) && (level.disableMomentum==true) )
		return;
	
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );
	assert( isDefined( score ) );
	label = maps\mp\gametypes\_rank::getScoreInfoLabel( event );
	countsTowardRampage = maps\mp\gametypes\_rank::doesScoreInfoCountTowardRampage( event );

	if ( event == "death" )
	{
		_setPlayerMomentum( victim, victim.pers["momentum"] + score );
	}
		
	if ( score == 0 )
	{
		return;
	}
	
	if ( !IsDefined( label ) )
	{
		assertmsg( event + " label undefined" );
		player givePlayerMomentumNotification( score, "", descValue, countsTowardRampage );
		return;
	}
	
	size = player.momentumNotifyQueue.size;
	
	notifyNode = spawnstruct();
	notifyNode.score = score;
	notifyNode.label = label;
	notifyNode.descValue = descValue;
	notifyNode.countsTowardRampage = countsTowardRampage;
	
	player.momentumNotifyQueue[size] = notifyNode;
	
	player notify( "momentum_popup" );
}

givePlayerScore( event, player, victim, weapon, descValue )
{
	momentum = player.pers["momentum"];
	givePlayerMomentum( event, player, victim, weapon, descValue );
	newMomentum = player.pers["momentum"];

	if ( level.overridePlayerScore )
		return;

	pixbeginevent("level.onPlayerScore");
	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );
	newScore = player.pers["score"];	
	pixendevent();
	
	bbPrint( "mpplayerscore", "spawnid %d gametime %d type %s player %s delta %d deltamomentum %d team %s", getplayerspawnid( player ), getTime(), event, player.name, (newScore - score), ( newMomentum - momentum ), player.team);
	player maps\mp\_bb::bbAddToStat( "score", newScore - score );

	if ( score == newScore )
		return;
		
	pixbeginevent("givePlayerScore");
	recordPlayerStats( player, "score" , newScore );
	
	if ( level.rankedMatch || level.wagerMatch )
	{
		if ( IsDefined( victim ) && !victim is_bot() )
		{
			scoreDiff = (newScore - score);

			player AddPlayerStatWithGameType( "score", scoreDiff );
			if ( isDefined( player.pers["lastHighestScore"] ) && newScore > player.pers["lastHighestScore"] )
			{
				player setDStat( "HighestStats", "highest_score", newScore );
			}

			if( !level.wagerMatch )
			{
				player maps\mp\gametypes\_persistence::addRecentStat( false, 0, "score", scoreDiff );
			}
		}
	}
	
	pixendevent();
}

default_onPlayerScore( event, player, victim )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );

	assert( isDefined( score ) );
	
	if ( level.wagerMatch )
	{
		player thread maps\mp\gametypes\_rank::updateRankScoreHUD( score );
	}
	
	_setPlayerScore( player, player.pers["score"] + score );
}


_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

	if ( !level.rankedMatch )
	{
		player thread maps\mp\gametypes\_rank::updateRankScoreHUD( score - player.pers["score"] );
	}

	player.pers["score"] = score;
	player.score = player.pers["score"];
	recordPlayerStats( player, "score" , player.pers["score"] );

	player notify ( "update_playerscore_hud" );
	if ( level.wagerMatch )
		player thread maps\mp\gametypes\_wager::playerScored();
	player thread maps\mp\gametypes\_globallogic::checkScoreLimit();
	player thread maps\mp\gametypes\_globallogic::checkPlayerScoreLimitSoon();

}


_getPlayerScore( player )
{
	return player.pers["score"];
}


#define MAX_MOMENTUM 2000

_setPlayerMomentum( player, momentum )
{
	momentum = clamp( momentum, 0, MAX_MOMENTUM );

	oldMomentum = player.pers["momentum"];
	if ( momentum == oldMomentum )
		return;
	
	player maps\mp\_bb::bbAddToStat( "momentum", ( momentum - oldMomentum ));

	if ( momentum > oldMomentum )
	{
		highestMomentumCost = 0;
		numKillstreaks = player.killstreak.size;
		killStreakTypeArray = [];
		
		for ( currentKillstreak = 0 ; currentKillstreak < numKillstreaks ; currentKillstreak++ )
		{	
			killstreakType = maps\mp\killstreaks\_killstreaks::getKillstreakByMenuName( player.killstreak[ currentKillstreak ] );
			if ( IsDefined( killstreakType ) )
			{
				momentumCost = level.killstreaks[killstreakType].momentumCost;
				if ( momentumCost > highestMomentumCost ) 
				{
					highestMomentumCost = momentumCost;
				}
				killStreakTypeArray[killStreakTypeArray.size] = killstreakType;
			}
		}
		
		_givePlayerKillstreakInternal( player, momentum, oldMomentum, killStreakTypeArray );
		
		while ( highestMomentumCost > 0 && momentum >= highestMomentumCost )
		{
			oldMomentum = 0;
			momentum = momentum - highestMomentumCost;
			_givePlayerKillstreakInternal( player, momentum, oldMomentum, killStreakTypeArray );
		}
	}
		
	player.pers["momentum"] = momentum;
	player.momentum = player.pers["momentum"];
}

_givePlayerKillstreakInternal( player, momentum, oldMomentum, killStreakTypeArray )
{
	for ( killstreakTypeIndex = 0 ; killstreakTypeIndex < killStreakTypeArray.size; killstreakTypeIndex++ )
	{
		killstreakType = killStreakTypeArray[killstreakTypeIndex];
		
		momentumCost = level.killstreaks[killstreakType].momentumCost;
		if ( momentumCost > oldMomentum && momentumCost <= momentum )
		{
			
			weapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( killstreakType );
			if ( IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
			{
				player maps\mp\killstreaks\_killstreaks::changeKillstreakQuantity( weapon, 1 );
				player maps\mp\killstreaks\_killstreaks::addKillstreakToQueue( level.killstreaks[killstreakType].menuname, 0, killstreakType );
			}
			else
			{
				player maps\mp\killstreaks\_killstreaks::addKillstreakToQueue( level.killstreaks[killstreakType].menuname, 0, killstreakType );
				activeEventName = "reward_active";
				if ( IsDefined( weapon ) )
				{
					newEventName = weapon+"_active";
					if ( maps\mp\gametypes\_rank::isRegisteredEvent( newEventName ) )
					{
						activeEventName = newEventName;
					}
				}
				//player maps\mp\_scoreevents::processScoreEvent( activeEventName, player );
			}
		}
	}
}

/#
setPlayerMomentumDebug()
{
	setdvar( "sv_momentumPercent", 0.0 );
	
	while( true )
	{
		wait( 1 );
		momentumPercent = GetDvarFloatDefault( "sv_momentumPercent", 0.0 );
		if ( momentumPercent != 0.0 )
		{
			player = GetHostPlayer();
			if ( !isdefined( player ) ) 
			{
				return;
			}
			if ( isdefined( player.killstreak ) )
			{
				_setPlayerMomentum( player,  int( MAX_MOMENTUM * ( momentumPercent / 100 ) ) );
			}
		}
	}
}
#/

giveTeamScore( event, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;
		
	pixbeginevent("level.onTeamScore");
	teamScore = game["teamScores"][team];
	[[level.onTeamScore]]( event, team );
	pixendevent();
	
	newScore = game["teamScores"][team];
	
	bbPrint( "mpteamscores", "gametime %d event %s team %d diff %d score %d", getTime(), event, team, newScore - teamScore, newScore );
	
	if ( teamScore == newScore )
		return;
	
	updateTeamScores( team );

	thread maps\mp\gametypes\_globallogic::checkScoreLimit();
}

giveTeamScoreForObjective( team, score )
{
	teamScore = game["teamScores"][team];

	onTeamScore( score, team );

	newScore = game["teamScores"][team];
	
	bbPrint( "mpteamobjscores", "gametime %d  team %d diff %d score %d", getTime(), team, newScore - teamScore, newScore );
	
	if ( teamScore == newScore )
		return;
	
	updateTeamScores( team );

	thread maps\mp\gametypes\_globallogic::checkScoreLimit();
}

_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	updateTeamScores( team );
	
	thread maps\mp\gametypes\_globallogic::checkScoreLimit();
}

resetTeamScores()
{
	if ( !isdefined( level.roundScoreCarry) || level.roundScoreCarry == false || maps\mp\_utility::isFirstRound() )
	{
		foreach( team in level.teams )
		{
			game["teamScores"][team] = 0;
		}
	}
	
	maps\mp\gametypes\_globallogic_score::updateAllTeamScores();
}

resetAllScores()
{
	resetTeamScores();
	resetPlayerScores();
}

resetPlayerScores()
{
	players = level.players;
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{

		if ( IsDefined( players[i].pers["score"] ) )
			_setPlayerScore( players[i], 0 );
		
	}
}

updateTeamScores( team )
{
	setTeamScore( team, game["teamScores"][team] );
	level thread maps\mp\gametypes\_globallogic::checkTeamScoreLimitSoon( team );
}

updateAllTeamScores( )
{
	foreach( team in level.teams )
	{
		updateTeamScores( team );
	}
}

_getTeamScore( team )
{
	return game["teamScores"][team];
}

getHighestTeamScoreTeam()
{
	score = 0;
	winning_teams = [];
	
	foreach( team in level.teams )
	{
		team_score = game["teamScores"][team];
		if ( team_score > score )
		{
			score = team_score;
			winning_teams = [];
		}
		
		if ( team_score == score )
		{
			winning_teams[team] = team;
		}
	}
	
	return winning_teams;
}

areTeamArraysEqual( teamsA, teamsB )
{
	if ( teamsA.size != teamsB.size )
		return false;
		
	foreach( team in teamsA )
	{
		if ( !isdefined( teamsB[team] ) )
			return false;
	}
	
	return true;
}

onTeamScore( score, team )
{
	game["teamScores"][team] += score;

	if ( level.scoreLimit && game["teamScores"][team] > level.scoreLimit )
		game["teamScores"][team] = level.scoreLimit;
		
	if ( level.splitScreen )	
		return;
		
	if ( level.scoreLimit == 1 )
		return;
		
	isWinning = getHighestTeamScoreTeam();

	if ( isWinning.size == 0 )
		return;
		
	if ( getTime() - level.lastStatusTime < 5000 )
		return;
	
	if ( areTeamArraysEqual(isWinning, level.wasWinning )  )
		return;
	
	level.lastStatusTime = getTime();
	
	// dont say anything if they are the tied for the lead currently because they are not really winning
	if ( isWinning.size == 1 )
	{
		// looping because its easier but there is only one iteration (size == 1)
		foreach( team in isWinning )
		{
				// dont say anything if you were already winning
				if ( isdefined( level.wasWinning[team] ) )
				{
					// ... and there was no one tied with you
					if ( level.wasWinning.size == 1 )
						continue;
				}
	
			// you have just taken the lead and you are the only one in the lead
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "lead_taken", team, "status" );
		}
	}
	
	// dont say anything if they were the tied for the lead previously because they were not really winning
	if ( level.wasWinning.size == 1)
	{
		// looping because its easier but there is only one iteration (size == 1)
		foreach( team in level.wasWinning )
		{
			// dont say anything if you are still winning  
			if ( isdefined( isWinning[team] ) )
			{
				// and you are not currently tied for the lead 
				if ( isWinning.size == 1 )
					continue;
					
				// or you were previously tied for the lead (already told)
				if ( level.wasWinning.size > 1 )
					continue; 
			}
			
			
			// you are either no longer winning or you were winning and now are tied for the lead
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "lead_lost", team, "status" );
		}
	}
	
	level.wasWinning = isWinning;
}


default_onTeamScore( event, team )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );
	
	assert( isDefined( score ) );

	onTeamScore( score, team );	
}

initPersStat( dataName, record_stats )
{
	if( !isDefined( self.pers[dataName] ) )
	{
		self.pers[dataName] = 0;
	}
	
	if ( !isdefined(record_stats) || record_stats == true )
	{
		recordPlayerStats( self, dataName, int(self.pers[dataName]) );
	}	
}


getPersStat( dataName )
{
	return self.pers[dataName];
}


incPersStat( dataName, increment, record_stats, includeGametype )
{
	pixbeginevent( "incPersStat" );

	self.pers[dataName] += increment;
	
	if ( isDefined( includeGameType ) && includeGameType )
	{
		self AddPlayerStatWithGameType( dataName, increment );
	}
	else
	{
		self AddPlayerStat( dataName, increment );
	}
	
	if ( !isdefined(record_stats) || record_stats == true )
	{
		self thread threadedRecordPlayerStats( dataName );
	}

	pixendevent();
}

threadedRecordPlayerStats( dataName )
{
	self endon("disconnect");
	waittillframeend;
	
	recordPlayerStats( self, dataName, self.pers[dataName] );
}

updateWinStats( winner )
{
	winner AddPlayerStatWithGameType( "losses", -1 );
	
	winner AddPlayerStatWithGameType( "wins", 1 );
	winner UpdateStatRatio( "wlratio", "wins", "losses" );
	winner AddPlayerStat( "cur_win_streak", 1 );
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	winner notify( "win" );
	
	cur_gamemode_win_streak = winner maps\mp\gametypes\_persistence::statGetWithGameType( "cur_win_streak" );
	gamemode_win_streak = winner maps\mp\gametypes\_persistence::statGetWithGameType( "win_streak" );

	cur_win_streak = winner GetDStat( "playerstatslist", "cur_win_streak", "StatValue" );
	if ( cur_win_streak > winner getDStat( "HighestStats", "win_streak" ) )
	{
		winner setDStat( "HighestStats", "win_streak", cur_win_streak );
	}
	
	if ( cur_gamemode_win_streak > gamemode_win_streak )
	{
		winner maps\mp\gametypes\_persistence::statSetWithGameType( "win_streak", cur_gamemode_win_streak );
	}
	
}

updateLossStats( loser )
{	
	loser AddPlayerStatWithGameType( "losses", 1 );
	loser UpdateStatRatio( "wlratio", "wins", "losses" );
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	loser notify( "loss" );
}


updateTieStats( loser )
{	
	loser AddPlayerStatWithGameType( "losses", -1 );
	
	loser AddPlayerStatWithGameType( "ties", 1 );
	loser UpdateStatRatio( "wlratio", "wins", "losses" );
	loser SetDStat( "playerstatslist", "cur_win_streak", "StatValue", 0 );		
	// This notify is used for the contracts system. It allows it to reset a contract's progress on this notify.
	loser notify( "tie" );
}

updateWinLossStats( winner )
{
	if ( !wasLastRound() && !level.hostForcedEnd )
		return;
		
	players = level.players;

	if ( !isDefined( winner ) || ( isDefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] IsHost() )
				continue;
				
			updateTieStats( players[i] );
		}		
	} 
	else if ( isPlayer( winner ) )
	{
		if ( level.hostForcedEnd && winner IsHost() )
			return;
				
		updateWinStats( winner );
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;

			if ( level.hostForcedEnd && players[i] IsHost() )
				continue;

			if ( winner == "tie" )
				updateTieStats( players[i] );
			else if ( players[i].pers["team"] == winner )
				updateWinStats( players[i] );
			else
				players[i] SetDStat( "playerstatslist", "cur_win_streak", "StatValue", 0 );	

		}
	}
}

// self is the player
backupAndClearWinStreaks()
{
	// Global
	self.pers[ "winStreak" ] = self GetDStat( "playerstatslist", "cur_win_streak", "StatValue" );
	self SetDStat( "playerstatslist", "cur_win_streak", "StatValue", 0 );	
	
	// Gametype
	self.pers[ "winStreakForGametype" ] = maps\mp\gametypes\_persistence::statGetWithGameType( "cur_win_streak" ); 
	self maps\mp\gametypes\_persistence::statSetWithGameType( "cur_win_streak", 0 );
}

restoreWinStreaks( winner )
{
	// Global
	winner SetDStat( "playerstatslist", "cur_win_streak", "StatValue", winner.pers[ "winStreak" ] );
	
	// Gametype
	winner maps\mp\gametypes\_persistence::statSetWithGameType( "cur_win_streak", winner.pers[ "winStreakForGametype" ] );
}

incKillstreakTracker( sWeapon )
{
	self endon("disconnect");
	
	waittillframeend;
	
	if( sWeapon == "artillery_mp" )
		self.pers["artillery_kills"]++;
	
	if( sWeapon == "dog_bite_mp" )
		self.pers["dog_kills"]++;
}

trackAttackerKill( name, rank, xp, prestige, xuid )
{
	self endon("disconnect");
	attacker = self;
	
	waittillframeend;

	pixbeginevent("trackAttackerKill");
	
	if ( !isDefined( attacker.pers["killed_players"][name] ) )
		attacker.pers["killed_players"][name] = 0;

	if ( !isDefined( attacker.killedPlayersCurrent[name] ) )
		attacker.killedPlayersCurrent[name] = 0;

	if ( !isDefined( attacker.pers["nemesis_tracking"][name] ) )
		attacker.pers["nemesis_tracking"][name] = 0;

	attacker.pers["killed_players"][name]++;
	attacker.killedPlayersCurrent[name]++;
	attacker.pers["nemesis_tracking"][name] += 1.0;
	if ( attacker.pers["nemesis_name"] == name ) 
	{
		attacker maps\mp\_challenges::killedNemesis();
	}

	if( attacker.pers["nemesis_name"] == "" || attacker.pers["nemesis_tracking"][name] > attacker.pers["nemesis_tracking"][attacker.pers["nemesis_name"]] )
	{
		attacker.pers["nemesis_name"] = name;
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_rankIcon"] = prestige;
		attacker.pers["nemesis_xp"] = xp;
		attacker.pers["nemesis_xuid"] = xuid;
	}
	else if( isDefined( attacker.pers["nemesis_name"] ) && ( attacker.pers["nemesis_name"] == name ) )
	{
		attacker.pers["nemesis_rank"] = rank;
		attacker.pers["nemesis_xp"] = xp;
	}
	
	pixendevent();
}

trackAttackeeDeath( attackerName, rank, xp, prestige, xuid )
{
	self endon("disconnect");

	waittillframeend;

	pixbeginevent("trackAttackeeDeath");

	if ( !isDefined( self.pers["killed_by"][attackerName] ) )
		self.pers["killed_by"][attackerName] = 0;

		self.pers["killed_by"][attackerName]++;

	if ( !isDefined( self.pers["nemesis_tracking"][attackerName] ) )
		self.pers["nemesis_tracking"][attackerName] = 0;
   
	self.pers["nemesis_tracking"][attackerName] += 1.5;

	if( self.pers["nemesis_name"] == "" || self.pers["nemesis_tracking"][attackerName] > self.pers["nemesis_tracking"][self.pers["nemesis_name"]] )
	{
		self.pers["nemesis_name"] = attackerName;
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_rankIcon"] = prestige;
		self.pers["nemesis_xp"] = xp;
		self.pers["nemesis_xuid"] =xuid;
	}
	else if( isDefined( self.pers["nemesis_name"] ) && ( self.pers["nemesis_name"] == attackerName ) )
	{
		self.pers["nemesis_rank"] = rank;
		self.pers["nemesis_xp"] = xp;
	}
	
	//Nemesis Killcam - ( hopefully even with the wait it gets there with enough time not to cause a flicker)
	if( self.pers["nemesis_name"] == attackerName && self.pers["nemesis_tracking"][attackerName] >= 2 )
		self setClientUIVisibilityFlag( "killcam_nemesis", 1 );
	else
		self setClientUIVisibilityFlag( "killcam_nemesis", 0 );

	pixendevent();
}

default_isKillBoosting()
{
	return false;
}

giveKillStats( sMeansOfDeath, sWeapon, eVictim )
{
	self endon("disconnect");
	
	waittillframeend;

	if ( level.rankedMatch && self [[level.isKillBoosting]]() )	
	{
		/#
			self IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU OFFENSIVE CREDIT AS BOOSTING PREVENTION" );
		#/
		return;
	}
		
	pixbeginevent("giveKillStats");
	
	self maps\mp\gametypes\_globallogic_score::incPersStat( "kills", 1, true, true );
	self.kills = self maps\mp\gametypes\_globallogic_score::getPersStat( "kills" );
	self UpdateStatRatio( "kdratio", "kills", "deaths" );

	attacker = self;
	if ( sMeansOfDeath == "MOD_HEAD_SHOT" && !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon )  )
	{
		attacker thread incPersStat( "headshots", 1 , true, false );
		attacker.headshots = attacker.pers["headshots"];
		eVictim recordKillModifier("headshot");
	}
	
	pixendevent();
}

incTotalKills( team )
{
	if ( level.teambased && isdefined( level.teams[team] ) )
	{
		game["totalKillsTeam"][team]++;				
	}	
	
	game["totalKills"]++;			
}

setInflictorStat( eInflictor, eAttacker, sWeapon )
{
	if ( !isDefined( eAttacker ) )
		return;

	if ( !isDefined( eInflictor ) )
	{
		eAttacker AddWeaponStat( sWeapon, "hits", 1 );
		return;
	}

	if ( !isDefined( eInflictor.playerAffectedArray ) )
		eInflictor.playerAffectedArray = [];

	foundNewPlayer = true;
	for ( i = 0 ; i < eInflictor.playerAffectedArray.size ; i++ )
	{
		if ( eInflictor.playerAffectedArray[i] == self )
		{
			foundNewPlayer = false;
			break;
		}
	}

	if ( foundNewPlayer )
	{
		eInflictor.playerAffectedArray[eInflictor.playerAffectedArray.size] = self;
		if( sWeapon == "concussion_grenade_mp" || sWeapon == "tabun_gas_mp" )
		{
			eAttacker AddWeaponStat( sWeapon, "used", 1 );
		}
		eAttacker AddWeaponStat( sWeapon, "hits", 1 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
processShieldAssist( killedplayer ) // self == riotshield player
{
	self endon( "disconnect" );
	killedplayer endon( "disconnect" );

	wait .05; // don't ever run on the same frame as the playerkilled callback.
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();

	if ( !isdefined( level.teams[ self.pers["team"] ] )  )
		return;
	
	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;

	if ( !level.teambased )
		return;

	self maps\mp\gametypes\_globallogic_score::incPersStat( "assists", 1, true, true );

	self.assists = self maps\mp\gametypes\_globallogic_score::getPersStat( "assists" );

	 maps\mp\_scoreevents::processScoreEvent( "shield_assist", self, killedplayer, "riotshield_mp" );
}

processAssist( killedplayer, damagedone, weapon )
{
	self endon("disconnect");
	killedplayer endon("disconnect");
	
	wait .05; // don't ever run on the same frame as the playerkilled callback.
	maps\mp\gametypes\_globallogic_utils::WaitTillSlowProcessAllowed();
	
	if ( !isdefined( level.teams[ self.pers["team"] ] )  )
		return;
	
	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;

	if ( !level.teambased )
		return;
	
	assist_level = "assist";
	
	assist_level_value = int( ceil( damagedone / 25 ) );
	
	if ( assist_level_value < 1 )
	{
		assist_level_value = 1;
	}
	else if ( assist_level_value > 3 )
	{
		assist_level_value = 3;
	}
	assist_level = assist_level + "_" + ( assist_level_value * 25 );
	
	self maps\mp\gametypes\_globallogic_score::incPersStat( "assists", 1, true, true );

	self.assists = self  maps\mp\gametypes\_globallogic_score::getPersStat( "assists" );

	switch( weapon )
	{
	case "concussion_grenade_mp":
		assist_level = "assist_concussion";
		break;
	case "flash_grenade_mp":
		assist_level = "assist_flash";
		break;
	case "emp_grenade_mp":
		assist_level = "assist_emp";
		break;
	case "proximity_grenade_mp":
	case "proximity_grenade_aoe_mp":
		assist_level = "assist_proximity";
		break;
	}
	self maps\mp\_challenges::assisted();
	maps\mp\_scoreevents::processScoreEvent( assist_level, self, killedplayer, weapon );
}

processKillstreakAssists( attacker, inflictor, weaponName )
{
	if ( !isDefined( attacker ) || !isDefined( attacker.team ) || self IsEnemyPlayer( attacker ) == false )
		return;

	// if the player suicided, dont give the assist
	if ( self == attacker || ( attacker.classname == "trigger_hurt" || attacker.classname == "worldspawn" ) )
		return;

	foreach( player in level.players )
	{
		if ( player.team != attacker.team ) 
			continue;

		if ( player.team == "spectator" ) 
			continue;

		if ( player == attacker ) 
			continue;

		if ( player.sessionstate != "playing" )
			continue;

		assert( isdefined ( player.activeCounterUAVs ) );
		assert( isdefined ( player.activeUAVs ) );
		assert( isdefined ( player.activeSatellites ) );

		if ( player.activeCounterUAVs > 0 ) 
		{
			thread maps\mp\_scoreevents::processScoreEvent( "counter_uav_assist", player );
		}

		if ( player.activeUAVs > 0 ) 
		{
			thread maps\mp\_scoreevents::processScoreEvent( "uav_assist", player );
		}

		if ( player.activeSatellites > 0 ) 
		{
			thread maps\mp\_scoreevents::processScoreEvent( "satellite_assist", player );
		}
	}

	foreach( assistTeam in level.teams )
	{
		if ( assistTeam == self.team )
			continue;
		
		// if the attacker is a player only give the attackers team assist points
		if ( attacker.team != assistTeam )
			continue;
		
		// EMP assist
		activeEMPOwner = level.empOwners[assistTeam];
		if ( IsDefined( activeEMPOwner ) && IsPlayer( activeEMPOwner ) )
		{
			if ( IsDefined( attacker ) && ( activeEMPOwner != attacker ) )
			{
				if ( isDefined(activeEMPOwner.EMPTime) && activeEMPOwner.spawnTime < activeEMPOwner.EMPTime )
				{
					thread maps\mp\_scoreevents::processScoreEvent( "emp_assist", activeEMPOwner );
				}
			}
		}
	}
}


/#
xpRateThread()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	while ( level.inPrematchPeriod )
		wait ( 0.05 );

	for ( ;; )
	{
		wait ( 5.0 );
		if ( isdefined( level.teams[ level.players[0].pers["team"] ] )  )
			self maps\mp\gametypes\_rank::giveRankXP( "kill", int(min( GetDvarint( "scr_xprate" ), 50 )) );
	}
}
#/
